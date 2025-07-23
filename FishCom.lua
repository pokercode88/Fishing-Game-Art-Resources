--[[ 
Fish相关逻辑（交互和响应） 
]]

local M = class("FishCom")
local _TAG = "FISH"
local PondName = "FPond"

local BULLET_S_LEN = 1000000

-- 添加全局事件
addGlobalEvent(_TAG, "USE_SKILL")
addGlobalEvent(_TAG, "ADD_PLAYER")
addGlobalEvent(_TAG, "UPD_PLAYER")
addGlobalEvent(_TAG, "DEL_PLAYER")
addGlobalEvent(_TAG, "SHOOT")
addGlobalEvent(_TAG, "UPD_CANNON")
addGlobalEvent(_TAG, "UPD_CANNON_CB")
addGlobalEvent(_TAG, "HIT_FISH")
addGlobalEvent(_TAG, "UPD_ROOM")
addGlobalEvent(_TAG, "ADD_FISH")
addGlobalEvent(_TAG, "FISH_TIDE")
addGlobalEvent(_TAG, "UPD_CANNONLV")
addGlobalEvent(_TAG, "UPD_LOTTERY")
addGlobalEvent(_TAG, "DO_LOTTERY")
addGlobalEvent(_TAG, "TREAS_TASK_START")
addGlobalEvent(_TAG, "TREAS_TASK_CHANGE")
addGlobalEvent(_TAG, "TREAS_TASK_RESULT")
addGlobalEvent(_TAG, "DEL_BULLET")
addGlobalEvent(_TAG, "WEEK_HAPPY")
addGlobalEvent(_TAG, "EXIT_GAME")
addGlobalEvent(_TAG, "BUGLE_TASK_START")
addGlobalEvent(_TAG, "BUGLE_TASK_RESULT")
addGlobalEvent(_TAG, "SUIT_EXCHANGE_RESULT")
addGlobalEvent(_TAG, "ITEM_UPDATE")
addGlobalEvent(_TAG, "DEL_SPECIAL_DROP")
addGlobalEvent(_TAG, "ADD_SPECIAL_DROP")
addGlobalEvent(_TAG, "UPD_BOMBSKILL")
addGlobalEvent(_TAG, "USE_CHAT")
addGlobalEvent(_TAG, "LOADING_TIMEOUT")
addGlobalEvent(_TAG, "NOTIFY_EFFECT")
addGlobalEvent(_TAG, "CHANGE_ROOMEXIT_GAME")
addGlobalEvent(_TAG, "UPD_JADE_ITEM_COUNT")
addGlobalEvent(_TAG, "TREASURE_FISH_FINISH")
addGlobalEvent(_TAG, "DRILL_START")
addGlobalEvent(_TAG, "DRILL_FIRE")
addGlobalEvent(_TAG, "DRILL_KILL")
addGlobalEvent(_TAG, "PET_HIT_FISH")
addGlobalEvent(_TAG, "DRILL_BOMB")
addGlobalEvent(_TAG, "DRILL_FINISH")
addGlobalEvent(_TAG, "PET_SKILL_TIMEOUT")
addGlobalEvent(_TAG, "MATCH_TASK_BEGIN")
addGlobalEvent(_TAG, "MATCH_TASK_UPDATE")
addGlobalEvent(_TAG, "MATCH_TASK_END")
addGlobalEvent(_TAG, "MATCH_END")
addGlobalEvent(_TAG, "RESET_IDLETIME")
addGlobalEvent(_TAG, "RELOCATION")
addGlobalEvent(_TAG, "PET_CHANGE")
addGlobalEvent(_TAG, "MONEY_TREE_END")
addGlobalEvent(_TAG, "CHANGE_CLEAR_TASK")
addGlobalEvent(_TAG, "DEVIL_KING_ANGER")
addGlobalEvent(_TAG, "DEVIL_KING_STATUS")
addGlobalEvent(_TAG, "EIGHT_DOOR")
addGlobalEvent(_TAG, "FISH_COMING")


function M:ctor()

    --[[ 注册协议收包对应的解析函数 ]]--
    self._pushCallbackList = {
        {slg_cmd.fish.skill[1],             handler(self, self.replyUseSkill)},
        {slg_cmd.fish.updPlayer[1],         handler(self, self.replyPlayerUpdate)},
        {slg_cmd.fish.leave[1],             handler(self, self.replyExit)},

        {slg_cmd.fish.bbsLeave[1],          handler(self, self.replyPlayerEnterOrExit)},
        {slg_cmd.fish.bbsShort[1],          handler(self, self.replyShoot)},
        {slg_cmd.fish.bbsUpdCannon[1],      handler(self, self.replyCannonUpdate)},
        {slg_cmd.fish.bbsHit[1],            handler(self, self.replyHit)},
        {slg_cmd.fish.bbsUpdRoom[1],        handler(self, self.replyRoomUpdate)},
        {slg_cmd.fish.bbsFish[1],           handler(self, self.replyAddFish)},
        {slg_cmd.fish.relocation[1],        handler(self, self.replyFishRelocation)},
        {slg_cmd.fish.bbsTide[1],           handler(self, self.replyTide)},
        {slg_cmd.fish.debug[1],             handler(self, self.replyDebugData)},

        {slg_cmd.fish.cannonLv[1],          handler(self, self.replyCannonLvUpdate)},
        {slg_cmd.fish.drawInfo[1],          handler(self, self.replyLotteryUpdate)},
        {slg_cmd.fish.draw[1],              handler(self, self.replyLotteryNotify)},

        {slg_cmd.fish.taskStart[1],         handler(self, self.replyTaskStart)},
        {slg_cmd.fish.taskUpdate[1],        handler(self, self.replyTaskUpdate)},
        {slg_cmd.fish.taskFinish[1],        handler(self, self.replyTaskFinish)},

        {slg_cmd.fish.bugleStart[1],        handler(self, self.replyBugleStart)},
        {slg_cmd.fish.bugleFinish[1],       handler(self, self.replyBugleFinish)},
        {slg_cmd.fish.changeSkin[1],        handler(self, self.replyChangeSkin)},
        {slg_cmd.fish.suitExchange[1],      handler(self, self.replySuitExchange)},
        {slg_cmd.fish.itemUpdate[1],        handler(self, self.replyItemUpdate)},
        {slg_cmd.fish.bombSkill[1],         handler(self, self.replyBombSkill)},
        {slg_cmd.fish.notify_effects[1],    handler(self, self.replyNotifyEffect)},
        {slg_cmd.fish.ghostLeave[1],        handler(self, self.replyTreasureFishLeave)},
        {slg_cmd.fish.petSkill[1],          handler(self, self.replyPetSkill)},
        {slg_cmd.fish.petSkillEnd[1],       handler(self, self.replyPetSkillEnd)},
        {slg_cmd.fish.drillStart[1],        handler(self, self.replyDrillStart)},
        {slg_cmd.fish.drillFire[1],         handler(self, self.replyDrillFire)},
        {slg_cmd.fish.drillBomb[1],         handler(self, self.replyDrillBomb)},
        {slg_cmd.fish.drillKill[1],         handler(self, self.replyDrillKill)},
        {slg_cmd.fish.drillDie[1],          handler(self, self.replyDrillFinish)},

        {slg_cmd.fish.matchTaskBegin[1],    handler(self, self.replyMatchTaskStart)},
        {slg_cmd.fish.matchTaskUpdate[1],   handler(self, self.replyMatchTaskUpdate)},
        {slg_cmd.fish.matchTaskEnd[1],      handler(self, self.replyMatchTaskEnd)},
        {slg_cmd.fish.matchEnd[1],          handler(self, self.replyMatchEnd)},
        {slg_cmd.fish.change_pet[1],        handler(self, self.replyChangePet)},
        {slg_cmd.fish.moneyTreeEnd[1],      handler(self, self.replyMoneyTreeEnd)},
        {slg_cmd.fish.devilKingAnger[1],    handler(self, self.replyDevilAnger)},
        {slg_cmd.fish.devilKingStatus[1],   handler(self, self.replyDevilStatus)},
        {slg_cmd.fish.eightDoor[1],         handler(self, self.replyEightDoor)},
        {slg_cmd.fish.dragonReward[1],      handler(self, self.replyDragonReward)},
        {slg_cmd.fish.fishComing[1],        handler(self, self.replyFishComing)},
    }

    self:init()
end

function M:init()
    self._exchangeData = nil
    self._myUid = Game:doPluginAPI("get", "playerUid")
    self._bulletSuffix = tonumber(self._myUid) or (Timer:getCurTimeStamp()+Number.random(666, 9999))
    self._bulletUid = self._bulletSuffix * BULLET_S_LEN
    self._isEnter = false

    netCom.ignoreTimeOutCMD(slg_cmd.fish.leave[1])
    netCom.ignoreTimeOutCMD(slg_cmd.fish.drillFire[1])
    netCom.ignoreWaitTipCMD(slg_cmd.fish.enter[1])
    netCom.ignoreWaitTipCMD(slg_cmd.fish.moneyTreeBegin[1])
    netCom.ignoreWaitTipCMD(slg_cmd.fish.eightDoor[1])
end

function M:registerFPondPush()
    Game:registerPushMsg(self._pushCallbackList)
end

function M:unregisterFPondPush()
    Game:unregisterPushMsg(self._pushCallbackList)
end

----------------------------------
-- 通知及推送
--[[
服务器主动踢出
]]
function M:replyExit(pack, info)
    self._isEnter = false
    if info.ret_code ~= 0 then
        dump(info)
        Game:dispatchCustomEvent(GEvent(_TAG, "CHANGE_ROOMEXIT_GAME"),false)
        Game:tipError(info.ret_code)
    end

    self:unregisterFPondPush()
end

--[[
使用技能
]]
function M:replyUseSkill(pack, info)
    if checknumber(info.ret_code) == 0 then
        local player = Game.fishDB:getPlayer(info.player_id)
        if not player then return end

        dump(info, _TAG)
        if info.skill_id == FSkill.rage or info.skill_id == FSkill.rageFree then
            player.frency = true
            -- player.lock = false
        elseif info.skill_id == FSkill.lock then
            player.lock = true
        elseif info.skill_id == FSkill.summon then
            Game.fishDB:appendSummonFish(info.fish_id, info.player_id)
        elseif info.skill_id == FSkill.bugle then
            -- Game.fishDB:appendSummonFish(info.fish_id, info.player_id, true)
        elseif info.skill_id == FSkill.ice then
            local curTime = Timer:getCurTimeStamp()*1000
            local fishList = Game.fishDB:getFishList()
            for _, fish in pairs(fishList) do
                if not fish.cold_history then
                    fish.cold_history = {curTime}
                else
                    table.insert(fish.cold_history, curTime)
                end
            end
        end

        Game:dispatchCustomEvent(GEvent(_TAG, "USE_SKILL"), info)
    end
end

--[[
玩家数据更新
]]
function M:replyPlayerUpdate(pack, info)
    Game.fishDB:updatePlayerInfo(info.by_player)
    Game:dispatchCustomEvent(GEvent(_TAG, "UPD_PLAYER"), info.by_player)
end

--[[
玩家进出房间
]]
function M:replyPlayerEnterOrExit(pack, info)
    dump(info, _TAG)
    if info.type == 0 then
        -- 进入
        Game.fishDB:updatePlayerInfo(info.by_player)
        Game:dispatchCustomEvent(GEvent(_TAG, "ADD_PLAYER"), info.by_player)
    elseif info.type == 1 then
        -- 离开
        local pos = info.by_player.pos
        local bs = Game.fishDB:removePlayer(pos)
        Game:dispatchCustomEvent(GEvent(_TAG, "DEL_PLAYER"), {pos=pos, bs=bs})
    end
end

--[[
射击
]]
function M:replyShoot(pack, info)
    local pos = info.shoot.pos
    local pInfo = Game.fishDB:getPlayer(pos, true)
    if not pInfo or pInfo.player_id == self._myUid then
        return
    end
    
    info.shoot.skin = (pInfo.frency and ENUM.RAGE_SKIN_ID or pInfo.skin)
    
    Game.fishDB:addBullet(info.shoot)

    local bombItemId = -1
    for _, v in ipairs(FMissile) do
        if info.shoot.cannon_id == v.cannon then
            bombItemId = v.item
            break
        end
    end
    info.shoot.bombItemId = bombItemId

    Game:dispatchCustomEvent(GEvent(_TAG, "SHOOT"), info.shoot)
end

--[[
炮台更新
]]
function M:replyCannonUpdate(pack, info)
    local pInfo = Game.fishDB:getPlayer(info.player_id)
    if pInfo and (pInfo.player_id~=self._myUid or info.skin==CannonSkin.drill) then
        pInfo.cannon_id = info.cannon_id
        local idx = Game.fishDB:seatToIdx(pInfo.pos)
        Game:dispatchCustomEvent(GEvent(_TAG, "UPD_CANNON"), {idx})
    end
end

--[[
打中鱼
]]
function M:replyHit(pack, info)
    local pond = Game.uiManager:getLayer(PondName)
    if pond and not pond:isLoading() then
        Game:dispatchCustomEvent(GEvent(_TAG, "HIT_FISH"), info)
    else
        local count = #info.fish_state_list / 2
        for i = 1, count do
            if info.fish_state_list[i * 2] == 0 then
                Game.fishDB:removeFish(info.fish_state_list[i * 2 - 1])
            end
        end
        Game.fishDB:removeBullet(info.shoot_uid)
    end
end

--[[
房间数据更新
]]
function M:replyRoomUpdate(pack, info)
    if Game.fishDB:roomExchanging() then
        self._exchangeData = info
        Game.fishDB:setBulgeLastTimeCD(info.horn_cd_time)
        -- 切换到其他房间需要清掉任务
        --local isClearTask = Game.fishDB:getRoomIdx() ~= info.room_type
        Game:dispatchCustomEvent(GEvent(_TAG, "CHANGE_CLEAR_TASK"), {true})
        return
    end
    if checknumber(info.time_stamp) > 0 then
        -- 同步服务器时间
        Timer:setCurTimeStamp(info.time_stamp / 1000)
    end
    Game.fishDB:setRoomBg(info.now_bg_id)
    Game.fishDB:setRoomIdx(info.room_type)
    Game.fishDB:setPlayerList(info.by_players)
    Game.fishDB:setFishList(info.fish_list)
    Game.fishDB:setBulletList(info.shoot_list)
    Game.fishDB:setItemInfo(info.tool_info)
    Game.fishDB:setBulgeLastTimeCD(info.horn_cd_time)
    self:updateSpecialDrop(info.special_drop)

    Game:dispatchCustomEvent(GEvent(_TAG, "UPD_ROOM"), {true})
end

--[[
道具更新
]]
function M:replyItemUpdate(pack, info)
    Game.fishDB:updateItemInfo(info.tool_info)
    Game:dispatchCustomEvent(GEvent(_TAG, "ITEM_UPDATE"), info)
end

--[[
生成鱼
]]
function M:replyAddFish(pack, info)
    for _, f in ipairs(info.fish) do
        Game.fishDB:addFish(f)
    end
    -- Game:dispatchCustomEvent(GEvent(_TAG, "ADD_FISH"), info.fish)
end

--[[
鱼位置校验
]]
function M:replyFishRelocation(pack, info)
    Game:dispatchCustomEvent(GEvent(_TAG, "RELOCATION"), info.precision_info)
end

--[[
鱼潮来袭
]]
function M:replyTide(pack, info)
    Game.fishDB:setFishList()
    Game.fishDB:setRoomBg(info.now_bg_id)
    Game:dispatchCustomEvent(GEvent(_TAG, "FISH_TIDE")) 
end

--[[
测试数据
]]
function M:replyDebugData(pack, info)
    if FISH_DEBUG then
        Game.fishDB:setDebugData(info.data)
    end
end

--[[
炮台升级
]]
function M:replyCannonLvUpdate(pack, info)
    Game.fishDB:setPlayerCannonLv(info.lv)
    Game:dispatchCustomEvent(GEvent(_TAG, "UPD_CANNONLV"), info)
end

--[[
奖池更新
]]
function M:replyLotteryUpdate(pack, info)
    if info.coin then 
        Game.fishDB:setLotteryCoin(info.coin) 
    end
    if info.fish then 
        Game.fishDB:setLotteryFish(info.fish) 
    end
    Game:dispatchCustomEvent(GEvent(_TAG, "UPD_LOTTERY"), {true})
end

--[[
奖池抽奖
]]
function M:replyLotteryNotify(pack, info)
    dump(info, _TAG)
    if checknumber(info.code) == 0 and info.player_id ~= self._myUid then
        Game:dispatchCustomEvent(GEvent(_TAG, "DO_LOTTERY"), info)
    end
end

--[[
悬赏任务开始
]]
function M:replyTaskStart(pack, info)
    Game:dispatchCustomEvent(GEvent(_TAG, "TREAS_TASK_START"), {})
end

--[[
悬赏任务更新
]]
function M:replyTaskUpdate(pack, info)
    Game.fishDB:setTaskData(info)
    Game:dispatchCustomEvent(GEvent(_TAG, "TREAS_TASK_CHANGE"), info)
end

--[[
悬赏任务结束
]]
function M:replyTaskFinish(pack, info)
    Game.fishDB:setTaskData()
    Game:dispatchCustomEvent(GEvent(_TAG, "TREAS_TASK_RESULT"), info)
end

--[[
号角任务开始
]]
function M:replyBugleStart(pack, info)
    Game:dispatchCustomEvent(GEvent(_TAG, "BUGLE_TASK_START"), info)
end

--[[
号角任务结束
]]
function M:replyBugleFinish(pack, info)
    Game:dispatchCustomEvent(GEvent(_TAG, "BUGLE_TASK_RESULT"), info)
end
--- 比赛任务开始
function M:replyMatchTaskStart(pack, info)
    dump(info)
    Game:dispatchCustomEvent(GEvent(_TAG, "MATCH_TASK_BEGIN"), info)
end
--- 比赛任务更新
function M:replyMatchTaskUpdate(pack, info)
    dump(info)
    Game:dispatchCustomEvent(GEvent(_TAG, "MATCH_TASK_UPDATE"), info)
end
--- 比赛任务结束
function M:replyMatchTaskEnd(pack, info)
    dump(info)
    Game:dispatchCustomEvent(GEvent(_TAG, "MATCH_TASK_END"), info)
end

function M:replyMatchEnd(pack, info)
    dump(info)
    Game:dispatchCustomEvent(GEvent(_TAG, "MATCH_END"), info)
end

--[[
切换激光武器
]]
function M:replyChangeSkin(pack, info)
	Game.fishDB:setSkinData(info)
end

--[[
花色兑换
]]
function M:replySuitExchange(pack, info)
    if info.ret_code == 0 then
        Assist.showGetGoods(info.item_info)
    else
        self:tipError(info.ret_code)
    end
    Game:dispatchCustomEvent(GEvent(_TAG, "SUIT_EXCHANGE_RESULT"), info)
end

--[[
切换宠物
]]
function M:replyChangePet(pack, info)
	if checknumber(info.ret_code) ~= 0 then
		Game:tipError(info.ret_code)
		return
	end
	Game:dispatchCustomEvent(GEvent(_TAG, "PET_CHANGE"), info)
end

function M:onPetChagne(petId)
    netCom.send({petId}, slg_cmd.fish.change_pet[1])
end

----------------------------------
-- 交互及回调
function M:onEnter(callback, failCallback)
    local pondIdx = Game.fieldId or 0
    Game.fieldId = nil

    if pondIdx > 0 then
        -- 已选渔场，直接进入
        self:onEnterPond(pondIdx, callback, failCallback, true)
    else
        -- 进入选房界面
        local function _chooseCallback_(pondIdx_, callback_, failCallback_)
            self:onEnterPond(pondIdx_, callback_, failCallback_, true)
        end
        local imgTitle
        local data = {}
        local num = 1
        for i = 1, #BYRoomConfig do
            local cfg = BYRoomConfig[i]
            if cfg.open == 1 and cfg.room_type == 1 then
                data[num] = {
                    room_pouring = cfg.lock_cannon_lv_min,
                    room_limit = cfg.coin_area_k,
                    id = cfg.id,
                    icon = cfg.icon,
                    min_cannon_lv = cfg.lock_cannon_lv_min,
                    max_cannon_lv = cfg.lock_cannnon_lv_max,
                    check_in = cfg.check_in,
                }
                num = num + 1
            end
        end
        Game:doPluginAPI("game", "quickStart", function(fieldId)
            Game:doPluginAPI("room", "choose", data, imgTitle, _chooseCallback_, nil, 1, fieldId)
        end, nil, true)

        if type(callback) == "function" then
            callback()
        end
    end
end

function M:onEnterPond(pondIdx, callback, cbFail, cbEnter)
    Game:doPluginAPI("delay", "redpacket", true)
    Audio.stopAllSounds()
    Game:onBack()

    Game.fishDB:setRoomExchanging(false)

    if DEBUG_OFFLINE then
        self:onEnterPondCallback({room_type=1, room_bg=Number.random(1,2)}, callback, cbFail, cbEnter)
        return
    end

    if not netCom.isWaitingFor(slg_cmd.fish.enter[1]) then
        -- 进入渔场
        -- 条件判断避免多次请求
        -- 进入超时限制避免超时后再次响应回复
        if not Game.reloadToGame then
            Game:showWaitUI(Config.localize("fish_born"), true)
        end
        netCom.sendHeartBeat()
        self._enterTimeout = nil
		Game.fishDB:setRoomIdx(pondIdx)

        self:registerFPondPush()

        netCom.send({pondIdx}, slg_cmd.fish.enter[1], function(pack, info)
            if self and type(self.onEnterPondCallback) == "function" then
                if not self._enterTimeout or self._enterTimeout < Timer:getCurTimeStamp() then
                    if info.room_type == ENUM.ROOM_ID.ENTIRE then
                        Game:doPluginAPI("query", "rankData", 26, function()
                            self:onEnterPondCallback(info, callback, cbFail, cbEnter)
                        end, true, true, {1,7})
                    elseif info.room_type == ENUM.ROOM_ID.GRAND_PRIX then
                        Game:doPluginAPI("query", "rankData", 27, nil, true, true)
                        Game:doPluginAPI("query", "rankData", 28, function()
                            self:onEnterPondCallback(info, callback, cbFail, cbEnter)
                        end, true, true)
                    else
                        self:onEnterPondCallback(info, callback, cbFail, cbEnter)
                    end
                end
            end
        end, handler(self, self.unregisterFPondPush))
    end
end

function M:onEnterPondCallback(info, callback, cbFail, cbEnter)
    dump(info, _TAG)
    if checknumber(info.ret_code) == 0 then
        self._isEnter = true
        Game.tipEvent = nil
        Game.fishDB:updateRoomInfo({room_id = info.room_type})
        
        if callback == true or cbEnter == true then
            require_ex("games.fish.views."..PondName).new():addToScene(10)
            Game:dispatchCustomEvent(GEvent(_TAG, "UPD_ROOM"), {false})
        end
        if type(callback) == "function" then
            callback()
        end

        self:queryLotteryInfo()
        return true

    else
        Game:destroyWaitUI()
        Game:onFore()

        if Game.enterFromField then
            Game.enterFromField = nil
            Game:enterScene(ENUM.SCENCE.PLATFORM)
        end
        if type(cbFail) == "function" then
            cbFail()
        else
            if BYRoomConfig.room_type(info.room_type) == FishRoomType.MATCH then
                Game:tipError(info.ret_code or info.code or info.ret_type)
            end
        end
        self._isEnter = false
        return false
    end
end

function M:onExit(op)
    if not DEBUG_OFFLINE and self and not (type(op)=="boolean" and op == false) then
        self._isEnter = false
        self._enterTimeout = Timer:getCurTimeStamp() + 100
        netCom.send({self._myUid, checknumber(op)}, slg_cmd.fish.leave[1])
    end
end

--[[
射击
]]
function M:onFire(x, y, radian, seat, targetFish, zidanType, fishUid, callback)
    -- 客户端生成子弹UID
    self._bulletUid = self._bulletUid + 1
    local uid = self._bulletUid
    local pInfo = Game.fishDB:getPlayerByIdx(seat)
    --local cannon_id = pInfo.cannon_id
    local targetFishUid = fishUid
    if fishUid <= 0 and targetFish ~= nil then
        targetFishUid = targetFish.fish_uid
    end

    if zidanType ~= 0 and zidanType ~= CannonSkin.drill then
        Game.fishDB:cacheBomb(uid, zidanType)
        if callback then
            callback(zidanType, uid)
        end
    else
        local skinId = pInfo.frency and ENUM.RAGE_SKIN_ID or pInfo.skin
        local bInfo = {
            shoot_uid = uid,
            cannon_id = pInfo.cannon_id,
            player_id = pInfo.player_id,
            pos = pInfo.pos,
            time_stamp = Timer:getCurTimeStamp() * 1000,
            pos_x = x,
            pos_y = y,
            skin = skinId,
            fish_uid = targetFishUid,
        }
        local cost = BYCannonConfig.level(pInfo.cannon_id) or 1
        if pInfo.frency then
            -- 狂暴双倍消耗
            local bet = Game.fishDB:getFrencyBet()
            cost = cost * bet
        end
        local info = {shoot = bInfo, coin = pInfo.coin - cost}
        Game.fishDB:addBullet(info.shoot)
        info.coin = pInfo.coin-cost
        
        if callback then
            callback(zidanType, uid, info.shoot, pInfo.pos)
        end
    end

    -- 请求射击
    if not DEBUG_OFFLINE then
        local bet = pInfo.frency and Game.fishDB:getFrencyBet() or 1
        local data = {
            0,
            checknumber(zidanType),
            checknumber(targetFishUid),
            checknumber(uid),
            checknumber(x),
            checknumber(y),
            0, radian, 0, 0, 0, 0, 0, bet
        }
        netCom.send(data, slg_cmd.fish.shoot[1])
    end

    return uid
end

--[[
换炮
]]
function M:onCannonChange(cannonId, callback, ignoreErrorTips)
    netCom.send({cannonId}, slg_cmd.fish.chgCannon[1], function(pack, info)
        if checknumber(info.ret_code) == 0 then
            local pInfo = Game.fishDB:getPlayer()
            if pInfo then
                pInfo.cannon_id = info.cannon_id
                local idx = Game.fishDB:seatToIdx(pInfo.pos)
                if callback then
                    callback(cannonId)
                end
                Game:dispatchCustomEvent(GEvent(_TAG, "UPD_CANNON"), {idx})
            end
        elseif not ignoreErrorTips then
            self:tipError(info.ret_code or info.code)
        end
    end)
end

--[[
打中鱼
]]
function M:onHitFish(bulletUid, killList, igoreRemove)
    netCom.send({bulletUid, #killList, killList}, slg_cmd.fish.hit[1], function(pack, info)
        if checknumber(info.ret_code) ~= 0 then
            self:tipError(info.ret_code or info.code)
        end
    end)
    if not igoreRemove then
        -- Game.fishDB:removeBullet(bulletUid)
        Game:dispatchCustomEvent(GEvent(_TAG, "DEL_BULLET"), {uid=bulletUid, bomb=true})
    end
end

--[[
宠物技能碰撞
]]
function M:onPetHitFish(skillId, killList, pos)
    netCom.send({skillId, #killList, killList, pos.x, pos.y}, slg_cmd.fish.petSkill[1])
end

--[[
宠物击中广播
]]
function M:replyPetSkill(pack, info)
    Game:dispatchCustomEvent(GEvent(_TAG, "PET_HIT_FISH"), info)
end
--[[
宠物技能使用状态结束
]]
function M:replyPetSkillEnd(pack, info)
    Game:dispatchCustomEvent(GEvent(_TAG, "PET_SKILL_TIMEOUT"), info)
end

--[[
使用技能
]]
function M:onSkill(skillId, callback)
    local bet = Game.fishDB:getFrencyBet()
    netCom.send({skillId, bet}, slg_cmd.fish.skill[1], function(pack, info)
        if checknumber(info.ret_code) ~= 0 then
            self:tipError(info.ret_code)
        else
            execute(callback)
        end
    end)
end

--[[
炮台升级
]]
function M:reqUpgradeCannon()
    netCom.send({false}, slg_cmd.fish.upgCannon[1], function(pack, info)
        dump(info, _TAG)
        if checknumber(info.code) == 0 and info.result then
            Game.fishDB:setPlayerCannonLv(info.lv)
            local coinAdd = 0
            local pInfo = Game.fishDB:getPlayer()
            if info.reward and #info.reward > 0 then
                for _,v in ipairs(info.reward) do
                    if v.id == ENUM.ITEM_ID.COIN then
                        coinAdd = coinAdd + v.val
                    end
                end
            end
            pInfo.coin = pInfo.coin + coinAdd

            Game:dispatchCustomEvent(GEvent(_TAG, "UPD_CANNON_CB"), {lv=info.lv, coinAdd=coinAdd})
		else
			self:tipError(info.code)
        end
    end)
end

--[[
换皮肤
]]
function M:reqChangeSkin(skinId, callback)
    netCom.send({skinId}, slg_cmd.fish.chgSkin[1], function(pack, info)
        if checknumber(info.code) == 0 then
            local pInfo = Game.fishDB:getPlayer()
            pInfo.skin = info.skin

            local idx = Game.fishDB:seatToIdx(pInfo.pos)
            Game:dispatchCustomEvent(GEvent(_TAG, "UPD_CANNON"), {idx})
            if callback then 
                callback(info) 
            end
        else
            self:tipError(info.code)
        end
    end)
end

--[[
核弹头广播
]]
function M:replyBombSkill(pack, info)
    if info.use_uid == self._myUid then
        return
    end
    Game:dispatchCustomEvent(GEvent(_TAG, "UPD_BOMBSKILL"), info)
end

--[[
使用核弹头
]]
function M:onBombSkill(warhead_id)
    netCom.send({warhead_id}, slg_cmd.fish.bombSkill[1], function(pack, info)
        if checknumber(info.ret_code) ~= 0 then
            self:tipError(info.ret_code)
        end
    end)
end

--[[
特殊鱼打死数据实时显示
]]
function M:replyNotifyEffect(pack, info)
	-- if info.effects_uid == self._myUid then return end
	Game:dispatchCustomEvent(GEvent(_TAG, "NOTIFY_EFFECT"), info)
end

function M:onSendNotifyEffect(ext)
	netCom.send({ext}, slg_cmd.fish.notify_effects[1])
end

--[[
奖池抽奖
]]
function M:queryLotteryInfo()
    netCom.send({1}, slg_cmd.fish.drawInfo[1])
end

function M:reqLotteryDraw(id, callback)
    netCom.send({id}, slg_cmd.fish.draw[1], function(pack, info)
        if checknumber(info.code) == 0 then
            if info.player_id ~= self._myUid then
                return
            end
            Game.fishDB:setLotteryCoin(info.coin)
            Game.fishDB:setLotteryFish(info.fish)

            Game:dispatchCustomEvent(GEvent(_TAG, "UPD_LOTTERY"), {false, info.reward})
            if callback then 
                callback(info) 
            end
        else
            self:tipError(info.code)
        end
    end)
end

--[[
换桌
]]
function M:reqChangeRoom(roomId, callback, cbFail, cmd)
    Game:doPluginAPI("ingore", "redpacket", 1)
    Game:doPluginAPI("delay", "redpacket", true)
    Audio.stopAllSounds()
    Game.fishDB:setRoomExchanging(true)
    Game:showWaitUI(Config.localize("fish_born"), true)

    netCom.send({roomId}, cmd or slg_cmd.fish.chgRoom[1], function(pack, info)
        dump(info, _TAG)
        Game.fishDB:setRoomExchanging(false)

        if checknumber(info.ret_code) == 0 then
            self._isEnter = true
            Game.tipEvent = nil
            Game.fishDB:updateRoomInfo({room_id=info.room_type, room_bg=self._exchangeData.now_bg_id})
            if checknumber(self._exchangeData.time_stamp) > 0 then
                Timer:setCurTimeStamp(self._exchangeData.time_stamp / 1000)
            end
            Game.fishDB:setPlayerList(self._exchangeData.by_players)
            Game.fishDB:setFishList(self._exchangeData.fish_list)
            Game.fishDB:setBulletList(self._exchangeData.shoot_list)
            Game.fishDB:setItemInfo(self._exchangeData.tool_info)
            Game.fishDB:setBulgeLastTimeCD(self._exchangeData.horn_cd_time)
            self:updateSpecialDrop(self._exchangeData.special_drop)

            Game:dispatchCustomEvent(GEvent(_TAG, "UPD_ROOM"), {true, true})
            if callback then 
                callback() 
            end

        else
            Game:destroyWaitUI()
            Game:onFore()
            
            if Game.enterFromField then
                Game.enterFromField = nil
                Game:enterScene(ENUM.SCENCE.PLATFORM)
            elseif cbFail then
                cbFail()
            end
			Game:dispatchCustomEvent(GEvent(_TAG, "CHANGE_ROOMEXIT_GAME"))
			-- Game:doPluginAPI("exit", "fish")
            Game:tipError(info.ret_code or info.code or info.ret_type)
        end
    end)
end

--------------------------------------------------------------------
--- 宝藏鱼
function M:reqTreasureFishSelectCard(callFunc)
    netCom.send({}, slg_cmd.fish.ghostSelectCard[1], function(pack,info)
        if info.ret_code == 0 then
            callFunc(info.score)
        else
            self:tipError(info.ret_code)
            callFunc()
        end
    end)
end

function M:reqTreasureFishOpenCard(pos, callFunc)
    netCom.send({pos}, slg_cmd.fish.ghostOpenCard[1], function(pack,info)
        if info.ret_code == 0 then
            callFunc(info)
        else
            self:tipError(info.ret_code)
            callFunc()
        end
    end)
end

function M:replyTreasureFishLeave(pack, info)
    Game:dispatchCustomEvent(GEvent(_TAG, "TREASURE_FISH_FINISH"), info.uid)
end

function M:reqTreasureFishLeave(callFunc)
    netCom.send({}, slg_cmd.fish.ghostLeave[1], function(pack, info)
        if info.ret_code ~= 0 then
            self:tipError(info.ret_code)
        end
        execute(callFunc,info)
    end)
end

--------------------------------------------------------------------
--- 钻石鱼
function M:replyDrillStart(pack, info)
    Game:dispatchCustomEvent(GEvent(_TAG, "DRILL_START"), info)
end

function M:replyDrillFire(pack, info)
    Game:dispatchCustomEvent(GEvent(_TAG, "DRILL_FIRE"), info)
end

function M:replyDrillBomb(pack, info)
    Game:dispatchCustomEvent(GEvent(_TAG, "DRILL_BOMB"), info)
end

function M:replyDrillKill(pack, info)
    Game:dispatchCustomEvent(GEvent(_TAG, "DRILL_KILL"), info)
end

function M:replyDrillFinish(pack, info)
    Game:dispatchCustomEvent(GEvent(_TAG, "DRILL_FINISH"), info)
end

function M:onDrillFire(shoot_uid)
    netCom.send({shoot_uid}, slg_cmd.fish.drillFire[1])
end

function M:onDrillDie(callback)
    netCom.send({}, slg_cmd.fish.drillDie[1])
end

-------------------------------------------------------------------
--- 摇钱树
function M:replyMoneyTreeEnd(pack, info)
    Game:dispatchCustomEvent(GEvent(_TAG,"MONEY_TREE_END"),info)
end

function M:reqMoneyTree(callFunc)
    netCom.send({},slg_cmd.fish.moneyTree[1],function(pack,info)
        execute(callFunc,info)
        if info.ret_code ~= 0 then
            Game:tipError(info.ret_code)
        end
    end)
end

function M:onShakeMoneyTree(callFunc)
    netCom.send({},slg_cmd.fish.moneyTreeBegin[1],function(pack,info)
        execute(callFunc,info)
        if info.ret_code ~= 0 then
            Game:tipError(info.ret_code)
        end
    end,callFunc)
end
-------------------------------------------------------------------
--- 魔王 八卦阵
function M:replyDevilAnger(pack, info)
    dump(info)
    Game:dispatchCustomEvent(GEvent(_TAG,"DEVIL_KING_ANGER"),info)
end

function M:replyDevilStatus(pack, info)
    dump(info)
    Game:dispatchCustomEvent(GEvent(_TAG,"DEVIL_KING_STATUS"),info)
end

function M:replyEightDoor(pack, info)
    dump(info)
    if info.ret_code == 0 then
        Game:dispatchCustomEvent(GEvent(_TAG,"EIGHT_DOOR"),info)
    end
end

function M:onEightDoorOpen(callFunc)
    netCom.send({},slg_cmd.fish.eightDoor[1],function(pack,info)
        if info.ret_code ~= 0 then
            Game:tipError(info.ret_code)
        end
        execute(callFunc,info)
    end,callFunc)
end
-------------------------------------------------------------------
--- 金龙奖池
function M:reqDragonLottery(ty, callFunc)
    netCom.send({ty},slg_cmd.fish.dragonLottery[1],function(pack,info)
        if info.ret_code == 0 then
            execute(callFunc,info)
        else
            Game:tipError(info.ret_code)
        end
    end)
end

function M:replyDragonReward(pack, info)
    dump(info)
    Game.fishDB:setDragonLotteryReward(info.uid,info.pool_type,info.reward_data)
end
-------------------------------------------------------------------
--- 鱼入场预告
function M:replyFishComing(pack, info)
    dump(info)
    Game.fishDB:setFishComing(info.fish_pre_info)
    Game:dispatchCustomEvent(GEvent(_TAG,"FISH_COMING"),Game.fishDB:getFishComing())
end
-------------------------------------------------------------------
function M:onComeToForeGround(roomId, callback, cbFail)
    Audio.stopAllSounds()
    Game.fishDB:setRoomExchanging(true)

    netCom.send({roomId}, slg_cmd.fish.chgRoom[1], function(pack, info)
        dump(info, _TAG)
        Game.fishDB:setRoomExchanging(false)

        if checknumber(info.ret_code) == 0 then
            Game.fishDB:updateRoomInfo({room_id=info.room_type, room_bg=self._exchangeData.now_bg_id})
            if checknumber(self._exchangeData.time_stamp) > 0 then
                Timer:setCurTimeStamp(self._exchangeData.time_stamp / 1000)
            end
            Game.fishDB:setPlayerList(self._exchangeData.by_players)
            Game.fishDB:setFishList(self._exchangeData.fish_list)
            Game.fishDB:setBulletList(self._exchangeData.shoot_list)
            Game.fishDB:setShowSuit(self._exchangeData.poker_drop == 1)
            Game.fishDB:setItemInfo(self._exchangeData.tool_info)
            self:updateSpecialDrop(self._exchangeData.special_drop)
            Game:dispatchCustomEvent(GEvent(_TAG, "UPD_ROOM"), {true, true})
            if callback then 
                callback() 
            end
        else
            Game:onFore()
            if Game.enterFromField then
                Game.enterFromField = nil
                Game:enterScene(ENUM.SCENCE.PLATFORM)
            elseif cbFail then
                cbFail()
            end
            Game:tipError(info.ret_code or info.code or info.ret_type)
        end
    end)
end

function M:onComeToBackGround()
    self._isEnter = false
    self._enterTimeout = Timer:getCurTimeStamp() + 100
    self:unregisterFPondPush()
end

function M:onSuitExchange(item_id)
    netCom.send({item_id}, slg_cmd.fish.suitExchange[1])
end

--[[
外部调用退出游戏接口
]]
function M:onExitGame(callFunc)
	Game:dispatchCustomEvent(GEvent(_TAG, "EXIT_GAME"), callFunc)
end

function M:updateSpecialDrop(info)
    local special_drop = Game.fishDB:getSpecialDrop()
    for _, v in ipairs(special_drop) do
        local key = table.keyof(info, v)
        if not key then
            Game:dispatchCustomEvent(GEvent(_TAG,"DEL_SPECIAL_DROP"), v)
        else
            table.remove(info, key)
        end
    end
    for _, v in ipairs(info) do
        Game:dispatchCustomEvent(GEvent(_TAG,"ADD_SPECIAL_DROP"), v)
        table.insert(special_drop, v)
    end
    Game.fishDB:setSpecialDrop(special_drop)
end

--[[
聊天
]]
function M:onEventChat(event)
	Game:dispatchCustomEvent(GEvent(_TAG, "USE_CHAT"), event)
end

function M:playBGM(toNext)
    local bgm
    if Game.fishDB:isMatchRoom() then
        bgm = Sound_fishConfig["BGM>match"].file
	elseif Game.fishDB:isRuinsRoom() then
		bgm = Sound_fishConfig["BGM>yushi"].file
    else
        local idx = Game.fishDB:getBgmIdx(toNext)
        bgm = string.format(Sound_fishConfig["BGM>normal"].file, idx)
    end
    Audio.playMusic(bgm, true)
end

--[[
玉石场玉石数量变更
]]
function M:jadeCountChange(count)
     Game:dispatchCustomEvent(GEvent(_TAG, "UPD_JADE_ITEM_COUNT"), {count = count})
end

function M:tipError(code, ...)
    if self._isEnter then
        Game:tipError(code, ...)
    end
end

--[[
鱼位置校验（主动）
]]
function M:onFishRelocation()
    netCom.send({}, slg_cmd.fish.relocation[1])
end

-----------------------------------------------------
-- @discarded
function M:getUI()
    return Game.uiManager:getLayer(PondName)
end

return M:new()