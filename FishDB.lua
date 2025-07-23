--[[ 
Fish相关数据 
]]

local M = class("FishDB")

-- 房间类型
cc.exports.FishRoomType = {
    COIN 		= 1,	-- 经典场
    HUNT 		= 2,	-- 猎魔场
    MATCH		= 3,	-- 比赛场
}
cc.exports.FishRoomID = {
    shjs        = 3,    --深海巨兽
	captain 	= 4,	--幽灵船长
    hunt        = 5,    --海魔场
	haiyao      = 6,    --海妖漩涡
    ruins       = 7,    --废墟boss
}

-- 房间物品消耗表 金币 玉石 魔晶 钻石 子弹数 比赛积分
local COST_INDEX = {
	[ENUM.ITEM_ID.COIN]     = 1,
	[ENUM.ITEM_ID.JADE]     = 2,
	[ENUM.ITEM_ID.ENERGY]   = 3,
	[ENUM.ITEM_ID.DIAMOND]  = 4,
	[ENUM.ITEM_ID.BULLET]   = 5,
	[ENUM.ITEM_ID.SCORE]    = 6,
}

local GIVE_INDEX = {
	[ENUM.ITEM_ID.RAGE_FREE]		= 1,
}

-- 技能
cc.exports.FSkill = {
    lock 		= 1001,	-- 锁定
    ice 		= 1002,	-- 冰封
    rage 		= 1003,	-- 狂暴
    summon 		= 1004,	-- 召唤
    laser 		= 1005,	-- 激光
    bugle		= 1006,	-- 号角
    rageFree	= 1007,	-- 免费狂暴
    devilKing   = 1008, -- 召唤魔王
    nbomb 		= 1009,	-- 核弹
    battleAxe   = 1010, -- 亡灵战斧
    pet1        = 2001, --宠物1
    pet2        = 2002, --宠物2
    pet3        = 2003, --宠物3
}
-- 弹头列表
cc.exports.FMissile = {
    {cannon = 2000000001, item = ENUM.ITEM_ID.MISSILE1},
    {cannon = 2000000002, item = ENUM.ITEM_ID.MISSILE2},
    {cannon = 2000000003, item = ENUM.ITEM_ID.MISSILE3},
    {cannon = 2000000004, item = ENUM.ITEM_ID.MISSILE4},
}
-- 开火返回结果
cc.exports.FireResult = {
    SUCCESS		= 0,	-- 成功
    CANNON 		= -1,	-- 炮倍不足
    FRENZY		= -2,	-- 狂暴金币不足
    COIN		= -3,	-- 金币不足
    BULLET		= -4,	-- 子弹过多
}
-- 炮台列表
cc.exports.CannonType = {
    normal 		= 1,	-- 普通
    vip 		= 2,	-- 会员
    rage 		= 3,	-- 狂暴
	laser       = 4,    -- 激光
	drill       = 5,    -- 钻头
}
-- 特殊皮肤
cc.exports.CannonSkin = {
    drill       = 5000001,    -- 钻头
}
-- 背景数量
cc.exports.BG_MAX = 5
cc.exports.BGM_MAX = 2

-- 狂暴倍数
cc.exports.FrencyBetList = {2, 4}
-- 房间boss玩法事件id
cc.exports.RoomEventId ={
    bugle 		= 1,   	--船长
    haiyao 		= 2,    --海妖
    wljy   		= 3,    --亡灵剧院
}
-- 特殊鱼
cc.exports.FishSpe = {
	haiyao_boss 	= 95,	-- 娜迦
	haiyao_monster 	= 105,	-- 海妖水母
	dynj        	= 161,  -- 地狱男爵
	drill 			= 162, 	-- 钻头鱼
}
-- 碰撞
cc.exports.FishPhysic = {
	mask_none		= 0x0000,
	mask_fish		= 0x0001,
	mask_bullet		= 0x0010,
	mask_cbnone		= 0x0100,
	mask_cfnone		= 0x1000,
}

function M:ctor()
    self:init()
	-- Game:registerLogoutReset(self, handler(self, self.init))
end

function M:init()
	-- 最大人数
	self.PMAX = 4
	-- 同向数量
	self.PMIRROR = self.PMAX / 2
	-- 正在切换房间
	self._roomExchanging = false
	-- 房间信息
	self._roomInfo = {}
	-- 鱼信息
    self._fishList = {}
    self._fishCount = 0
    self._addToQueue = false
    self._addQueue = require_ex("lib.Queue").new()
	-- 玩家信息
	self._players = {}
	self._seats = {}
	self._idxToSeat = {}
	self._seatToIdx = {}
	self._myIndex = 0
	self._myUid = Game:doPluginAPI("get", "playerUid")
	-- 子弹信息
    self._bulletList = {}
    self._bulletCannonData = {} -- 前端临时缓存数据
    -- 技能信息
    self._skillList = {}
	-- 抽奖信息
    self._lotteryCoin = 0
    self._lotteryFish = 0

    -- DEBUG信息
    self._fishDebugData = {}

    -- 魔法表情花费
    self._magicCost = 100

    -- 背景音乐
    self._bgmList = Table.shuffle(BGM_MAX)
    self._bgmIdx = 1

    -- 游戏内任务（猎魔悬赏，免费赛）
    self._taskData = nil
    self._taskFish = nil

    -- 召唤的鱼
    self._summonFish = {}
    self._bugleFish = nil

    -- 免费赛信息
    self._matchData = {}
	
	--激光炮台数据
	self._skinCanonList = {}

	--特殊掉落
	self._specialDrop = {}

    --道具信息
    self._itemInfo = {}

	-- 是否开启超时踢出
	self._idleDisable = true

	-- 物品掉落后飞到的位置 _itemPos[id]=pos
	self._itemPos = {}

	-- 加载进度
	self._progress = 0
    
    -- boss玩法结束后号角冷却时间
    self._hornCD = 0
	
    self._roomIdx = nil
	self._selfRoomCostIcon = {}
	self._otherRoomCostIcon = {}
	self._costItem = ENUM.ITEM_ID.COIN
	--货币掉落展示
	self._currencyDisplay = {
		[ENUM.ITEM_ID.COIN] = true
	}
	self._roomSkills = {}
	-- 狂暴
	self._frencyPause = false
	self._frencyBet = 1
	-- 金龙奖池奖励
	self._dragonLottery = {}
	-- 鱼入场预告
	self._fishComing = {}
end

function M:clear()
	self:init()
end

----------------------------------
-- 成员变量接口（getter/setter）
function M:getPMAX()
	return self.PMAX
end

function M:getMagicCost()
	return self._magicCost
end

function M:setMagicCost(cost)
	if not cost then
		cost = BYRoomConfig.magic_cost(self:getRoomId())
		if not cost and CompetitionRoomConfig then
			cost = CompetitionRoomConfig.magic_cost(self:getRoomId())
		end
	end
	self._magicCost = cost
end

function M:getLotteryCoin()
	return self._lotteryCoin or 0
end

function M:setLotteryCoin(num)
	self._lotteryCoin = num
end

function M:getLotteryFish()
	return self._lotteryFish or 0
end

function M:setLotteryFish(num)
	self._lotteryFish = num
end

function M:getPlayerCannonLv()
	return self._cannonLevel
end

function M:setPlayerCannonLv(lv)
	self._cannonLevel = lv
end

function M:roomExchanging()
	return self._roomExchanging
end

function M:setRoomExchanging(exc)
	self._roomExchanging = exc
end

function M:setSpecialDrop(info)
	self._specialDrop = info
end

function M:getSpecialDrop(id)
	if id then
		for i, v in ipairs(self._specialDrop) do
			if v == id then
				return i
			end
		end
		return
	end
	return self._specialDrop
end

function M:setItemInfo(info)
    self._itemInfo = {}
    for _, v in ipairs(info) do
        self._itemInfo[v.id] = v
    end
end

function M:getItemInfo(id)
    if id then
        return self._itemInfo[id]
    end
    return self._itemInfo
end

function M:updateItemInfo(info)
    for _, v in ipairs(info) do
        self._itemInfo[v.id] = v
    end
end

function M:setIdleDisable(enable)
	self._idleDisable = enable
end

function M:getIdleDisable()
	return self._idleDisable
end

function M:setItemPos(id, pos)
	self._itemPos[id] = pos
end

function M:getItemPos(id)
	return self._itemPos[id]
end

--[[
加载进度
]]
function M:setProgress(p)
    self._progress = p
end

function M:getProgress()
    return self._progress
end

--[[
设置狂暴状态 开火or暂停
]]
function M:setFrencyPause(v)
    self._frencyPause = v
end

function M:isFrencyPause()
	return self._frencyPause
end

--[[
狂暴倍率
]]
function M:setFrencyBet(v)
    self._frencyBet = v
end

function M:getFrencyBet()
	return FrencyBetList[self._frencyBet] or FrencyBetList[1]
end

--[[
获取当前背景音乐
@param toNext 	boolean 	是否递增
]]
function M:getBgmIdx(toNext)
	if toNext then
		self._bgmIdx = self._bgmIdx + 1
		if self._bgmIdx > #self._bgmList then
			self._bgmIdx = 1
		end
	end
	return self._bgmList[self._bgmIdx]
end

--[[
抽奖信息
@param coin 	number 	金币数量
@param fish 	number 	鱼数量
]]
function M:getLotteryAward(coin, fish)
	coin = coin or self:getLotteryCoin()
	fish = fish or self:getLotteryFish()
	local ids = BYLotteryConfig.getIds()
    local cfg
    for k = #ids, 1, -1 do
    	cfg = BYLotteryConfig[ids[k]]
        if cfg and coin >= cfg.gold and fish >= cfg.by_num then
            return cfg
        end
    end
end

----------------------------------
-- 座位索引互换(性能优化)
function M:initSeatIdx()
	self._idxToSeat = {}
	self._seatToIdx = {}

	local myself = self._players[self._myUid]
	if myself and myself.pos > self.PMIRROR then
		-- 对位换位
		local idx
		for pos = 1, self.PMAX do
			idx = pos - self.PMIRROR
			if idx <= 0 then
				idx = idx + self.PMAX
			end
			self._seatToIdx[pos] = idx
			self._idxToSeat[idx] = pos
		end
	else
		for pos = 1, self.PMAX do
			self._seatToIdx[pos] = pos
			self._idxToSeat[pos] = pos
		end
	end
end

function M:seatToIdx(pos)
	return self._seatToIdx[pos]
end

function M:idxToSeat(index)
	return self._idxToSeat[index]
end

----------------------------------
-- 判断检测
--[[
破产判断
@param uid 		number 		玩家ID/玩家位置
@param isSeat 	boolean/nil	指定为座位
@return boolean
]]
function M:isPlayerBrokeup(uid, isSeat)
	-- 比赛场不显示破产
	if self:isMatchRoom() then return false end
	
	uid = uid or self._myUid
	if isSeat or uid <= self.PMAX then
		uid = self._seats[self._seatToIdx[uid]]
	end

	local playerInfo = self:getPlayer(uid)
	if not playerInfo then return false end

	local limit = BYRoomConfig.min_cannon_lv(self:getRoomId())
    local itemNum = playerInfo.coin
	return itemNum < checknumber(limit)
end

--[[
炮倍是否锁定
@param cannonId 	number 	炮台ID
@param cannonLv 	number 	炮台等级
@return boolean
]]
function M:isCannonLocked(cannonId, cannonLv)
	if not cannonLv or not cannonId then return end
	local mult = BYCannonLevelConfig.cannon_multiple(cannonLv)
	local lv = BYCannonConfig.level(cannonId)
	return checknumber(mult) < checknumber(lv)
end

--[[
获取下(上)一个炮倍等级的炮倍
@param cannonId 	number 	炮台ID
@param bigger 		boolean 上/下
]]
function M:getNextCannonId(cannonId, bigger)
	if not self._cannonLevel then return end

	local unlockMulti = BYCannonLevelConfig.cannon_multiple(self._cannonLevel)
	local index = 1
	local maxIndex = #self._validCannons
	
	for k, id in pairs(self._validCannons) do
		if id == cannonId then
			index = k
		end
		if unlockMulti == BYCannonConfig.level(id) then
			maxIndex = k
		end
	end
	
	--解锁在1000倍以下可以显示下一档未解锁
	if unlockMulti < ENUM.CANNON_SEP_MULTI then
		maxIndex = Number.min(#self._validCannons, maxIndex+1)
	end

	if bigger then
		index = index + 1
		if index > maxIndex then
			index = 1
		end
	else
		index = index - 1
		if index == 0 then
			index = maxIndex
		end
	end

	return self._validCannons[index]
end

--[[
判断炮台能否升到指定等级
@param lv 			number 	等级
@param limitMulti 	number 	炮倍级限制
@return boolean, number
]]
function M:cannonUpgEnable(lv, limitMulti)
	if not lv or lv < 1 or self:isMatchRoom() then
		return false, 0
	end

	local cfg = BYCannonLevelConfig[lv]
	if not cfg or cfg.next_level == 0 or (limitMulti and limitMulti <= cfg.cannon_multiple) then
		return false, 0
	end

	local cost = 0
    for _, need in ipairs(cfg.level_res) do
        if need[1] == ENUM.ITEM_ID.DIAMOND then
            cost = cost + need[2]
        end
    end
    local pInfo = self:getPlayer()
    local diamond = self:getDiamondCount(pInfo)
    if diamond then
        return diamond >= cost, cost
    end
    local enough = Game:doPluginAPI("check", "playerAsset", {ENUM.ITEM_ID.DIAMOND, cost})
    return enough, cost
end

--[[
是否为金币场
]]
function M:isCoinRoom()
	return self:getRoomType() ~= FishRoomType.HUNT
end

--[[
是否为猎魔场
]]
function M:isHuntRoom()
	return self:getRoomType() == FishRoomType.HUNT
end

--[[
是否为比赛场
]]
function M:isMatchRoom()
	return self:getRoomType() == FishRoomType.MATCH
end

--[[
是否废墟场
]]
function M:isRuinsRoom()
    return self:getRoomId() == FishRoomID.ruins
end

--[[
换房功能是否可用
]]
function M:exchangeEnable()
	return true
end

---------------------------------------
-- 房间数据
function M:updateRoomInfo(args)
	table.merge(self._roomInfo, args)
	local roomId = self:getRoomId()
    self._roomIdx = roomId
	local min = BYRoomConfig.min_cannon_lv(roomId)
	local max = BYRoomConfig.max_cannon_lv(roomId)
	local matchMin = MatchRoomConfig.cannon_lv_limit(roomId)
	self._validCannons = {}

	local cfg
	local ids = BYCannonConfig.getIds()
	if checknumber(matchMin) > 0 then
		min = BYCannonLevelConfig.cannon_multiple(matchMin)
	end
	for _, id in pairs(ids) do
		cfg = BYCannonConfig[id]
		if cfg.type == 1 and Number.inRange(cfg.level, min, max) then
			table.insert(self._validCannons, id)
		end
	end
	table.sort(self._validCannons, function(a, b)
		return BYCannonConfig.level(a) < BYCannonConfig.level(b)
	end)
	
	self._selfRoomCostIcon = BYRoomConfig.cost_icon(roomId)
	self._otherRoomCostIcon = BYRoomConfig.cost_icon_other(roomId)
	self._costItem = BYRoomConfig.cost_item(roomId)
	self._currencyDisplay={}
	for _, v in ipairs(BYRoomConfig.float_item(roomId)) do
		self._currencyDisplay[v] = true
	end
	self._roomSkills = {}
	for _, v in ipairs(BYRoomConfig.room_skill_usable(roomId)) do
		self._roomSkills[v] = true
	end
	self._dragonLottery = {}
	self._fishComing = {}
end

--[[
提前保存玩家进入的房间
]]
function M:setRoomIdx(roomId)
    self._roomIdx = roomId
end

function M:getRoomIdx()
	return self._roomIdx or checknumber(self._roomInfo.room_id)
end

function M:getRoomId()
	return checknumber(self._roomInfo.room_id)
end

function M:getRoomType()
	local roomId = self:getRoomId()
	local roomType = BYRoomConfig.room_type(roomId)
	return checknumber(roomType)
end

function M:getRoomBg()
    local bg
    if LOW_MACHINE then
        local roomId = self:getRoomId()
        bg = BYRoomConfig.background(roomId)
    end
	return bg or self._roomInfo.room_bg or Number.random(1, BG_MAX)
end

function M:setRoomBg(bg)
	bg = bg or ((self._roomInfo.room_bg % BG_MAX) + 1)
	self._roomInfo.room_bg = bg
end

function M:getRoomLimit(roomId)
	roomId = roomId or self:getRoomId()
	return BYRoomConfig[roomId].coin_area_k
end

function M:getSelfRoomCostIcon()
	return self._selfRoomCostIcon
end

function M:getOtherRoomCostIcon()
	return self._otherRoomCostIcon
end

function M:checkRoomSkill(skillId)
	return self._roomSkills[skillId]
end

--[[
渔场消耗道具ID
]]
function M:getCostItemId()
    return self._costItem
end

function M:checkCurrencyDisplay(id)
	return self._currencyDisplay[id]
end

function M:getItemNum(itemId, info)
    if not info then
        info = self:getPlayer()
    end
    if info and info.num_list then
        return info.num_list[COST_INDEX[itemId]]
    end
end

function M:getItemChangeNum(itemId, info)
    if not info then
        info = self:getPlayer()
    end
    if info and info.change_list then
        return info.change_list[COST_INDEX[itemId]]
    end
end

function M:getItemNumForRoom(info, isChange)
    if not self._roomIdx then return end
    if #self._selfRoomCostIcon < 2 then
        self._selfRoomCostIcon = BYRoomConfig.cost_icon(self._roomIdx)
        self._otherRoomCostIcon = BYRoomConfig.cost_icon_other(self._roomIdx)
    end
    local num1 = info.player_id == self._myUid and self._selfRoomCostIcon[1] or self._otherRoomCostIcon[1]
    local num2 = info.player_id == self._myUid and self._selfRoomCostIcon[2] or self._otherRoomCostIcon[2]
    if isChange then
        return self:getItemChangeNum(num1,info), self:getItemChangeNum(num2,info)
    else
        return self:getItemNum(num1,info), self:getItemNum(num2,info)
    end
end

--钻石特殊处理，升级炮台处理
function M:getDiamondCount(info)
    if not info then return false end
    return self:getItemNum(ENUM.ITEM_ID.DIAMOND,info)
end

function M:getGiveNum(itemId, info)
    if not info then
        info = self:getPlayer()
    end
    if info and info.give_tool then
        return info.give_tool[GIVE_INDEX[itemId]]
    end
end

-------------------------------------------------
-- 鱼数据
function M:setFishList(list)
	self._fishList = {}
	self._addQueue:clear()
	if list then
		self._addToQueue = false
		self._fishCount = #list
		for _, fish in ipairs(list) do
			self._fishList[tostring(fish.fish_uid)] = fish
		end
	else
		self._fishCount = 0
	end
end

function M:addFish(fish)
	if not fish then return end

	local key = tostring(fish.fish_uid)
	if not self._fishList[key] then
		self._fishCount = self._fishCount + 1
	end
	self._fishList[key] = fish
	if self._addToQueue then
		self._addQueue:push(key)
	end
end

function M:removeFish(uid)
	local key = tostring(uid)
	if self._fishList[key] then
		self._fishCount = self._fishCount - 1
	end
	self._fishList[key] = nil
end

function M:getFishList(forAdd)
	if forAdd then
		self._addToQueue = true
		self._addQueue:clear()
	end
	return self._fishList
end

function M:getFish(uid)
	return self._fishList[tostring(uid)]
end

function M:getFishCount()
	return self._fishCount
end

function M:getFishFrozen(uid)
	local fish = self._fishList[tostring(uid)]
	if fish then
		return fish.cold_history
	end
end

function M:getAddFish()
	if self._addToQueue then
		local key = self._addQueue:pop()
		return key and self._fishList[key]
	end
end

-------------------------------------------------
-- 玩家数据
function M:setPlayerList(list)
	self._players = {}
	self._seats = {}
	
	for _, p in ipairs(list) do
        -- 绑定coin到player身上
        local coin, coin2 = self:getItemNumForRoom(p)
        p.coin, p.coin2 = coin, coin2
		self._players[p.player_id] = p
		self._seats[p.pos] = p.player_id
	end

	self:initSeatIdx()
	self._myIndex = self:getPlayerIndex()
end

function M:removePlayer(uid, isSeat)
	if isSeat or uid <= self.PMAX then
		uid = self._seats[uid]
	end
	local player = self._players[uid]
	if not player then return end

	-- 移除该玩家所有子弹
	local count, bs, bullet = #self._bulletList, {}
	for i = count, 1, -1 do
		bullet = self._bulletList[i]
		if bullet.player_id == uid then
			bs[#bs + 1] = bullet.shoot_uid
			table.remove(self._bulletList, i)
		end
	end
	-- 清空玩家数据
	self._seats[player.pos] = nil
	self._players[uid] = nil

	return bs
end

function M:updatePlayerInfo(player)
    local p = self._players[player.player_id]
    local coin, coin2
    if p then
        coin, coin2 = p.coin, p.coin2
    else
        coin, coin2 = self:getItemNumForRoom(player)
    end
    player.coin, player.coin2 = coin, coin2 

	self._players[player.player_id] = player
	self._seats[player.pos] = player.player_id
end

function M:getPlayers()
	return self._players
end

function M:getPlayer(uid, isSeat)
	if not uid then
		uid = self._myUid
	elseif isSeat or uid <= self.PMAX then
		uid = self._seats[uid]
	end
	return self._players[uid]
end

function M:getPlayerByIdx(idx)
	local uid = self._seats[self._idxToSeat[idx]]
	return self._players[uid]
end

function M:getPlayerIndex(pid)
	pid = pid or self._myUid
	local player = self._players[pid]
	if not player then return 0 end
	return self._seatToIdx[player.pos]
end

function M:getMyIndex()
	return self._myIndex
end

-------------------------------------------------
-- 子弹数据
function M:setBulletList(list)
	self._bulletList = list
end

function M:addBullet(info)
	self._bulletList[#self._bulletList+1] = info
end

function M:removeBullet(uid)
	local bullet
	for i, v in ipairs(self._bulletList) do
		if v.shoot_uid == tonumber(uid) then
			bullet = v
			table.remove(self._bulletList, i)
			break
		end
	end
	return bullet
end

function M:getBulletList()
	return self._bulletList
end

function M:getBullet(uid)
	for _, v in ipairs(self._bulletList) do
		if v.shoot_uid == tonumber(uid) then
			return v
		end
	end
end

function M:getListCount()
	return #self._bulletList
end

-- 弹头缓存
function M:cacheBomb(shootUid, cannonId)
	self._bulletCannonData[tostring(shootUid)] = cannonId
end

function M:uncacheBomb(uid)
	local key = tostring(uid)
	local bombId = self._bulletCannonData[key]
	self._bulletCannonData[key] = nil
	return bombId
end

-------------------------------------------------
-- 后端日志记录
function M:setDebugData(data)
	if data then
		local info = {}
		for i, v in ipairs(data) do
			info[i] = v.val
		end
		self._fishDebugData = {data}
		-- 写文件
		local logFile = string.format("%s/fish_debug.txt", Platform.getStorageEx())
		local logStr = table.concat(info, ",")
		cc.FileUtils:getInstance():addStringToFile(logStr.."\n", logFile)
	end
end

function M:getDebugData()
	return self._fishDebugData
end

-------------------------------------------------
-- 游戏内任务数据
function M:setTaskData(data)
	self._taskData = data
	self._taskFish = nil
	if data then
		self._taskFish = {}
		if data.kill_list then
			for _, v in ipairs(data.kill_list) do
            	self._taskFish[v.fishid] = true
            end
		elseif data.reward_list then
			for _, p in ipairs(data.reward_list) do
		        if p.pid == self._myUid then
		            for _, v in ipairs(p.kill_list) do
						self._taskFish[v.fishid] = true
		            end
		        end
		    end
        elseif data.finish_data then
            for _, v in ipairs(data.finish_data) do
				self._taskFish[v.fishid] = true
            end
	    end
	end
end

function M:getTaskData()
	return self._taskData
end

function M:checkTaskFish(fid)
	if not Assist.isEmpty(self._taskFish) then
		return self._taskFish[fid]
	end
end

function M:isInTask()
	return not Assist.isEmpty(self._taskFish)
end

-------------------------------------------------
-- 召唤数据
function M:appendSummonFish(uid, pid, bugle)
	self._summonFish[tostring(uid)] = pid
	if bugle then
		self._bugleFish = uid
	end
end

function M:checkSummonFish(uid)
	return self._summonFish[tostring(uid)], (self._bugleFish and self._bugleFish==uid)
end

function M:removeSummonFish(uid)
	self._summonFish[tostring(uid)] = nil
	if self._bugleFish and self._bugleFish==uid then
		self._bugleFish = nil
	end
end

function M:clearSummonFish()
	self._summonFish = {}
	self._bugleFish = nil
end

-------------------------------------------------
-- 比赛场数据
function M:setMatchData(data)
	self._matchData = data
end

function M:getMatchData()
	return self._matchData
end

function M:getMatchReward()
	return self._matchData.reward
end

-- 设置激光炮台数据
function M:setSkinData(info)
	self._skinCanonList = info.data
end

function M:getSkinData()
	return self._skinCanonList
end

--[[
设置号角冷却时间
]]
function M:setBulgeLastTimeCD(cd)
    self._hornCD = cd
end

function M:getBulgeLastTimeCD()
    return self._hornCD
end

function M:setDragonLotteryReward(player_id, ty, reward)
	ty = ty or self:getRoomId()
	if not self._dragonLottery[player_id] then
		self._dragonLottery[player_id] = {}
	end
	self._dragonLottery[player_id][ty] = reward
end

function M:getDragonLotteryReward(player_id, ty, ignoreClear)
	ty = ty or self:getRoomId()
	local ret = self._dragonLottery[player_id] and self._dragonLottery[player_id][ty]
	if not ignoreClear then
		self:setDragonLotteryReward(player_id,ty,nil)
	end
	return ret
end

function M:setFishComing(info)
	for _, v in ipairs(info) do
		v.time_stamp = v.time_stamp / 1000
		self._fishComing[v.fish_id] = v
	end
end

function M:getFishComing()
	local list = {}
	for k, v in pairs(self._fishComing) do
		if v.time_stamp > Timer:getCurTimeStamp() then
			table.insert(list,v)
		else
			self._fishComing[k] = nil
		end
	end
	table.sort(list,function(a, b)
		return a.prelv > b.prelv
	end)
	return list[1]
end
----------------------------------
-- 单机数据模拟
function M:testDataMonitor()
	local player_list = {}
	local myIdx = Number.random(1, self.PMAX)
    for i = 1, self.PMAX do
    	if i ~= myIdx and Number.random(1, 10) < 70 then
	    	player_list[i] = self:simPlayerInfo(i)
		end
    end
    player_list[myIdx] = {
	    player_id = Game:doPluginAPI("get", "playerUid"),
	    special_id = Game:doPluginAPI("get", "playerUid"),
	    facelook = Game:doPluginAPI("get", "playerIcon"),
	    vip_lv = Game:doPluginAPI("get", "playerVIP"),
	    name = Game:doPluginAPI("get", "playerName"),
	    coin = Game:doPluginAPI("get", "playerCoin"),
	    cannon_id = 1000000001,
	    pos = myIdx,
	}
    self._seats = player_list

    local fishList, initAmount = {}, Number.random(10, 100)
    for i = 1, initAmount do
    	fishList[i] = self:simFishInfo()
    end
    self._fishList = fishList

    -- local bullet_list, initAmount = {}, Number.random(10, 100)
    -- for i = 1, initAmount do
    -- 	bullet_list[i] = self:simBulletInfo()
    -- end
    -- self._bulletList = bullet_list
end

function M:simPlayerInfo(i)
	return {
		        player_id = Number.random(10000000, 10999999),
		        special_id = String.random(8),
		        facelook = Number.random(10001, 10006),
		        vip_lv = Number.random(0, 10),
		        name = String.random(8),
		        coin = Number.random(1000, 10000),
		        cannon_id = 1000000001,
		        pos = i,
		    }
end

function M:simFishInfo(i)
	return {
		        fish_uid = Number.random(10000000, 10999999),
		        fish_id = Number.random(1, 24),
		        time_stamp = (Timer:getCurTimeStamp() - Number.random(0, 60)) * 1000,
		        path_id = Number.random(1, 66),
		    }
end

function M:simBulletInfo(pid)
	return {
		        shoot_uid = Number.random(10000000, 10999999),
		        cannon_id = BYCannonListConfig[Number.random(1, 26)].cannon_id,
		        player_id = pid or self._seats[Number.random(1, self.PMAX)].player_id,
		        time_stamp = (Timer:getCurTimeStamp() - Number.random(0, 60)) * 1000,
		        pos_x = nil,
		        pos_y = nil
		    }
end


--[[
宠物信息
]]
function M:savePetType(info)
	self._petMyInfo = info
end

function M:getPetData()
	return self._petMyInfo or {}
end

--[[
设置宠物上场状态
]]
function M:setPetType(idx)
	if not self._petMyInfo or #self._petMyInfo < 1 then
		self._petMyInfo = Game:doPluginAPI("get", "petData") -- 确保进大厅前已经请求过数据
	end
	for k,v in ipairs(self._petMyInfo) do
		if idx == k then
			v.use_state = 1
		else
			v.use_state = 0
		end
	end
end

----------------------------------
-- @discarded
function M:onExit()
	self:init()
end

return M:new()
