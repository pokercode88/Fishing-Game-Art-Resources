--[[
Fish管理类
]]

local M = class("FishMng")

local FFish = require_ex("games.fish.views.base.FFish")
local FBullet = require_ex("games.fish.views.base.FBullet")
--local FPlayer = require_ex("games.fish.views.base.FPlayer")

local RebornCD = 2

function M:ctor()
    self:init()
end

function M:init()
	-- 路径翻转坐标（性能优化）
	if BYPathConfig and not BYPathConfig.opt then
		BYPathConfig.opt = true
		for _, cfg in ipairs(BYPathConfig) do
			cfg.pathFlip = {}
			cfg.pathHead = table.newclone(cfg.path[1])
			cfg.pathFlipHead = cc.p(CC_DESIGN_RESOLUTION.width-cfg.pathHead.x, CC_DESIGN_RESOLUTION.height-cfg.pathHead.y)
			for i, p in ipairs(cfg.path) do
				p.x = p.x - cfg.pathHead.x
				p.y = p.y - cfg.pathHead.y
				cfg.pathFlip[i] = cc.pMul(p, -1)
			end
		end
	end

	-- 炮台偏移
	self._cannonOrigin = {}
	-- 子弹计数
	self._myBullets = 0
	-- 开炮频率
	self._fireFreq = 1
	-- 鱼池
	self._fishPool = {}
	-- 子弹池
	self._bulletPool = {}
	-- boss池
	self._bossFish = {}

	-- 需要进行碰撞检测的鱼(活跃的)
	self._aliveFishes = {}
end

-----------------------------------------
-- 炮台偏移
function M:setCannonOrigin(idx, pos)
	self._cannonOrigin[idx] = pos
end

function M:getCannonOrigin(idx)
	if self._cannonOrigin[idx] then
		return self._cannonOrigin[idx].x, self._cannonOrigin[idx].y
	end
	return 0, 0
end

-----------------------------------------
-- 子弹计数
function M:getMyBullets()
	return self._myBullets
end

function M:addMyBullet(uid)
	self._myBullets = self._myBullets + 1
	self:updateFireFreq()
end

function M:removeMyBullet(uid)
	self._myBullets = self._myBullets - 1
	if self._myBullets < 0 then
		self._myBullets = 0
	end
	self:updateFireFreq()
end

function M:getFireFreqIds()
	if not self._fireFreqIds then
		local ids = BYFireFreqConfig.getIds()
		table.sort(ids,function(a, b)
			return a < b
		end)
		self._fireFreqIds = ids
	end
	return self._fireFreqIds
end

function M:updateFireFreq()
	local ids = self:getFireFreqIds()
	for _, v in ipairs(ids) do
		local range = BYFireFreqConfig.range(v)
		if self._myBullets >= range[1] and (self._myBullets <=range[2] or range[2]==-1) then
			self._fireFreq = BYFireFreqConfig.freq(v) / 100
			break
		end
	end
end

function M:getFireFreq()
	return self._fireFreq
end

-----------------------------------------
-- 鱼池
function M:createFish(pond, data, isEnter, index)
	local key, fish = tostring(data.fish_id)
	if self._fishPool[key] and #self._fishPool[key] > 0 
		and self._fishPool[key][1]:getState(FishState.idle) then
		fish = self._fishPool[key][1]
		table.remove(self._fishPool[key], 1)
		fish:reborn(data)
	else
		fish = FFish:new(pond, data, isEnter, index)
	end
	if fish:isBoss() then
		self:addBossFish(fish.fish_uid)
	elseif not LOW_MACHINE then
		-- 入场音乐/音效
		local music = BYFishConfig.coming(fish.fish_id)
		if not Assist.isEmpty(music) then
            if isEnter then
                if Sound_fishConfig.type(music) == 1 then
                    Game:performDelay(function()
                        Audio.playConfig(music)
                    end, 1)
                end
            else
                Audio.playConfig(music)
            end
		end
	end
    self:addAliveFish(fish)

    return fish
end

function M:removeFish(fish)
	if fish:isBoss() then
		self:removeBossFish(fish.fish_uid)
    elseif not LOW_MACHINE then
    	-- 入场音乐/音效
		local music = BYFishConfig.miss(fish.fish_id)
		if not Assist.isEmpty(music) then
			if music == "BGM>normal" then
				Game.fishCom:playBGM()
			else
				Audio.playConfig(music)
			end
		end
	end
	self:removeAliveFish(fish)

	local key = tostring(fish.fish_id)
	if not self._fishPool[key] then
		self._fishPool[key] = {fish}
	else
		if #self._fishPool[key] > 3 then
			fish:purge()
		else
			table.insert(self._fishPool[key], fish)
		end
	end
end

-----------------------------------------
-- 活跃鱼
function M:getAliveFishs()
	return self._aliveFishes
end

function M:addAliveFish(fish)
	fish.__dead__ = false
	local tmpFish
	for i = 1, #self._aliveFishes do
		tmpFish = self._aliveFishes[i]
		if tmpFish:getTimesArea() > fish:getTimesArea() then
			table.insert(self._aliveFishes, i, fish)
			return
		end
	end
	table.insert(self._aliveFishes, fish)
end

function M:removeAliveFish(fish)
	if fish.__dead__ then return end

	for i, tmp in ipairs(self._aliveFishes) do
		if tmp.fish_uid == fish.fish_uid then
			fish.__dead__ = true
			table.remove(self._aliveFishes, i)
			break
		end
	end
end

-----------------------------------------
-- Boss池
function M:getBossFishCount()
	return table.nums(self._bossFish)
end

function M:addBossFish(uid)
	self._bossFish[uid] = true
	if LOW_MACHINE then return end -- 低端机优化(忽略BOSS音乐)
	Audio.playMusic(Sound_fishConfig["BGM>boss"].file, true)
end

function M:removeBossFish(uid)
	self._bossFish[uid] = nil
	if LOW_MACHINE then return end -- 低端机优化(忽略BOSS音乐)
	if self:getBossFishCount() == 0 then
		Game.fishCom:playBGM()
    end
end

-----------------------------------------
-- 子弹池
function M:createBullet(pond, data)
	local bullet
	local skinId = data.skin
	if (not skinId) or skinId <= 0 then
		skinId = BYCannonConfig.bycannon_id(data.cannon_id)
	end
	data.showSkinId = skinId
	skinId = tostring(skinId)

	if self._bulletPool[skinId] and #self._bulletPool[skinId] > 0 then
		bullet = self._bulletPool[skinId][1]
		if not bullet.__rebornTime__ or bullet.__rebornTime__ < Timer:getCurTimeStamp() then
			bullet:reborn(data)
			table.remove(self._bulletPool[skinId], 1)
		else
			bullet = FBullet:new(pond, data)
		end
	else
		bullet = FBullet:new(pond, data)
	end
	if bullet:isMySelf() then
		self:addMyBullet()
	end

	return bullet
end

function M:removeBullet(bullet)
	bullet.__rebornTime__ = Timer:getCurTimeStamp() + RebornCD
	local skinId = tostring(bullet.showSkinId)
	self._bulletPool[skinId] = self._bulletPool[skinId] or {}
	table.insert(self._bulletPool[skinId], bullet)
end

-----------------------------------------
-- 清空
function M:clear()
	self._myBullets = 0
	self._fireFreq = 1
	self._fishPool = {}
	self._bulletPool = {}
	self._bossFish = {}
	self._aliveFishes = {}
end

return M:new()