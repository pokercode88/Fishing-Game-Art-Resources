--[[
初始化
]]

local FishUtilTest = false

--[[ 加载相关配置表和协议文件 ]]--
if not BYFishConfig then loadConfig("BYFishConfig") end
-- if not BYPathConfig then loadConfig("BYPathConfig") end
if not Sound_fishConfig then loadConfig("Sound_fishConfig") end
if not BYCannonConfig then loadConfig("BYCannonConfig") end
if not BYCannonSkinConfig then loadConfig("BYCannonSkinConfig") end
if not BYFishWikiConfig then loadConfig("BYFishWikiConfig") end
if not BYBackGroundConfig then loadConfig("BYBackGroundConfig") end
if not BYRoomConfig then loadConfig("BYRoomConfig") end
if not BYCannonLevelConfig then loadConfig("BYCannonLevelConfig") end
if not BYLotteryConfig then loadConfig("BYLotteryConfig") end
if not BYLottery2Config then loadConfig("BYLottery2Config") end
if not BYSkillConfig then loadConfig("BYSkillConfig") end
if not BYEmojiConfig then loadConfig("BYEmojiConfig") end
if not BYGuideConfig then loadConfig("BYGuideConfig") end
if not MagicEmojiConfig then loadConfig("MagicEmojiConfig") end
if not CompetitionRoomConfig then loadConfig("CompetitionRoomConfig") end
if not BYFishWordConfig then loadConfig("BYFishWordConfig") end
if not BYFishCardConfig then loadConfig("BYFishCardConfig") end
if not PokerExchangeConfig then loadConfig("PokerExchangeConfig") end
if not RankingListConfig then loadConfig("RankingListConfig") end
if not BYRoomTopActiveConfig then loadConfig("BYRoomTopActiveConfig") end
if not GameLimitConfig then loadConfig("GameLimitConfig") end
if not TreasureFishConfig then loadConfig("TreasureFishConfig") end
if not CoinChooseConfig then loadConfig("CoinChooseConfig") end
if not BYFireFreqConfig then loadConfig("BYFireFreqConfig") end
if not BYFishTurntableNumberConfig then loadConfig("BYFishTurntableNumberConfig") end
if not BYEventConfig then loadConfig("BYEventConfig") end
if not BYRoomBGConfig then loadConfig("BYRoomBGConfig") end
if not BYRoomBGResConfig then loadConfig("BYRoomBGResConfig") end
if not DragonLotteryConfig then loadConfig("DragonLotteryConfig") end
require_ex "games.fish.models.FishProtocol"

--[[ 创建类全局DB和Com对象 ]]--
Game.fishDB = require_ex("games.fish.models.FishDB")
Game.fishCom = require_ex("games.fish.models.FishCom")

--[[ 注册入口函数 ]]--
Game:registerAPI("game", "fish", function(callback)
    Game.fishCom:onEnter(callback)
end)

--[[ 注册相关API,方便其他模块调用 ]]--
local apiList = {
    -- {"get",		"fishData",		handler(Game.fishDB, Game.fishDB.getData)},
	{"exit", 	"fish", 			handler(Game.fishCom, Game.fishCom.onExitGame)},
	{"get",  	"skinCannonInfo", 	handler(Game.fishDB, Game.fishDB.getSkinData)},  -- 获取激光炮台信息
	{"get", 	"fishRoomType", 	handler(Game.fishDB, Game.fishDB.getRoomType)},
	{"fish", 	"relocation", 		handler(Game.fishCom, Game.fishCom.onFishRelocation)},
	{"fish", 	"registerPush", 	handler(Game.fishCom, Game.fishCom.registerFPondPush)},
}
Game:registerAPIList(apiList)

--[[ 注册协议收包对应的解析表key ]]--
Game:registerParsePack(slg_cmd.fish)

--[[ 注册进入大厅前需要执行的函数(获取相关数据) ]]--
local prepareList = {
	-- function()
    --     Game.fishCom:queryData(handler(Game, Game.prepareNext))
    -- end,
}
Game:registerPrepareList(prepareList)

--[[ 单机模式生成测试数据 ]]--
if DEBUG_OFFLINE or FishUtilTest then
    Game.fishDB:testDataMonitor()
end