--[[ proto_80_by.hrl ]]--

slg_cmd.fish = {
	["enter"]     		= {80000, "s2c_by_enter"},						-- 进入
	["leave"]     		= {80001, "s2c_leave_by"},						-- 离开
	["shoot"]     		= {80002, "s2c_by_shoot"},						-- 射击
	["chgCannon"]     	= {80003, "s2c_by_change_cannon"},				-- 换炮
	["hit"]     		= {80004, "s2c_by_shoot_fish"},					-- 打中鱼
	["skill"]     		= {80005, "s2c_by_use_skill"},					-- 使用技能
	["chgRoom"]     	= {80006, "s2c_by_change_room"},				-- 换桌
	["updPlayer"]     	= {80007, "s2c_by_player_info"},				-- 玩家信息变更
	["chgSkin"]     	= {80008, "s2c_by_change_skin"},				-- 切换皮肤

	["bbsLeave"]     	= {80101, "s2c_by_bc_player_enter_left"},		-- 广播玩家进出
	["bbsShort"]     	= {80102, "s2c_by_bc_player_shoot"},			-- 广播玩家射击
	["bbsUpdCannon"]	= {80103, "s2c_by_bc_player_change_cannon"},	-- 广播玩家改变炮台
	["bbsHit"]     		= {80104, "s2c_by_bc_player_shoot_fish"},		-- 广播玩家射中鱼
	["bbsUpdRoom"]     	= {80105, "s2c_by_bc_room_data"},				-- 广播房间数据
	["bbsFish"]     	= {80106, "s2c_by_bc_fish_make"},				-- 广播鱼生成
	["bbsTide"]     	= {80108, "s2c_by_bc_fish_tide"},				-- 广播进入鱼潮
	["debug"]     		= {80109, "s2c_by_shoot_info"},					-- 广播渔场Debug信息

	["cannonLv"]     	= {80110, "s2c_by_cannon_lv"},					-- 已解锁炮台等级
	["upgCannon"]     	= {80111, "s2c_by_cannon_lv_up"},				-- 升级炮台
	["drawInfo"]     	= {80112, "s2c_by_draw_info"},					-- 捕鱼抽奖
	["draw"]     		= {80113, "s2c_by_draw_do"},					-- 奖池捕鱼

	["taskStart"]     	= {80114, "s2c_reward_start"},					-- 悬赏任务开始
	["taskUpdate"]     	= {80115, "s2c_by_reward"},						-- 悬赏任务数据
	["taskFinish"]     	= {80116, "s2c_reward_result"},					-- 悬赏任务结算

	["bugleStart"]     	= {80131, "s2c_bugle_start"},					-- 悬赏任务开始
	["bugleFinish"]     = {80132, "s2c_bugle_result"},					-- 悬赏任务结算
	
	["changeSkin"]      = {80133, "s2c_buy_skin_info"},                 -- 激光炮台皮肤

	["suitExchange"]    = {80134, "s2c_by_exchange"},                 	-- 花色兑换
	["itemUpdate"]      = {80135, "s2c_by_item_change"},                -- 道具更新
    ["bombSkill"]       = {80136, "s2c_by_use_warhead"},                -- 弹头广播
	["notify_effects"]  = {80138, "s2c_by_notify_effects"},             -- 娜迦特效倍数通知其他用户

	["drillStart"] 		= {80142, "s2c_by_rocket_header_timer"},       	-- 钻头炮开始
	["drillFire"] 		= {80143, "s2c_by_use_rocket_header"},       	-- 钻头炮发炮
	["drillBomb"] 		= {80139, "s2c_by_rocket_header_bomb"},       	-- 钻头鱼爆炸
	["drillDie"] 		= {80144, "s2c_by_rocket_header_die"},       	-- 钻头炮爆炸
	["drillKill"] 		= {80145, "s2c_by_rocket_header_coin"},       	-- 钻头炮击杀

	["ghostSelectCard"] = {84000, "s2c_ghost_select_score"},       		-- 幽灵赏赐 选分
	["ghostOpenCard"] 	= {84001, "s2c_ghost_open_card"},       		-- 幽灵赏赐 翻牌
	["ghostLeave"] 		= {84002, "s2c_ghost_leave"},       			-- 幽灵赏赐 离开

	["petSkill"]        = {80140, "s2c_by_pet_skill_hit_fish"},         -- 宠物技能击中鱼    
	["petSkillEnd"]     = {80141, "s2c_broadcast_pet_skill_end"},       -- 广播宠物技能结束状态

	["matchTaskBegin"]  = {80118, "s2c_by_match_task_beining"},         -- 比赛任务开始
	["matchTaskUpdate"] = {80119, "s2c_by_match_task_update"},          -- 比赛任务更新
	["matchTaskEnd"]    = {80120, "s2c_by_match_task_ending"},          -- 比赛任务结束

	["matchEnd"]    	= {80121, "s2c_by_match_finish"},          		-- 比赛结束

	["relocation"]    	= {80148, "s2c_fish_position_precision"},       -- 鱼位置校验
	
	["change_pet"] 		= {80149, "s2c_change_pet"},  					-- 切换宠物

	["moneyTree"] 		= {80150, "s2c_get_shake_money_game_info"},  	-- 摇钱树 数据
	["moneyTreeBegin"] 	= {80151, "s2c_shake_money_begin"},  			-- 摇钱树 开始
	["moneyTreeEnd"] 	= {80152, "s2c_shake_money_end"},  				-- 摇钱树 结束

	["devilKingAnger"] 	= {80153, "s2c_anger_generate_boss"},  			-- 魔王怒气值
	["devilKingStatus"] = {80154, "s2c_call_boss_status"},  			-- 魔王状态
	["eightDoor"]       = {80155, "s2c_get_gossip_door_data"},  		-- 八卦阵

	["dragonLottery"]  	= {80156, "s2c_get_game_pool_data"},  			-- 金龙奖池
	["dragonReward"]  	= {80157, "s2c_user_pool_reward_data"},  		-- 金龙奖池发放

	["fishComing"]      = {80158, "s2c_by_bc_prefish_time"},  			-- 鱼预告

}

---------------------------------------------------------

slg_protocol["proto_by_tool_info"] = {
{name = "id", type = "", unit = 1},
{name = "num", type = "", unit = 1},
{name = "cnum", type = "", unit = 1},
}

slg_protocol["proto_tool_data"] = {
{name = "tool_id", type = "", unit = 1},
{name = "tool_num", type = "", unit = 1},
}

slg_protocol["proto_by_player"] = {
{name = "player_id", type = "", unit = 1},
{name = "facelook", type = "", unit = 1},
{name = "vip", type = "", unit = 1},
{name = "name", type = "", unit = 1},
{name = "num_list", type = "", unit = 2},
{name = "pos", type = "", unit = 1},
{name = "cannon_id", type = "", unit = 1},
{name = "lottery", type = "", unit = 1},
{name = "cannon_lv", type = "", unit = 1},
{name = "lv", type = "", unit = 1},
{name = "is_month_card_player", type = "", unit = 1},
{name = "skin", type = "", unit = 1},
{name = "lock", type = "", unit = 1},
{name = "frency", type = "", unit = 1},
{name = "in_time", type = "", unit = 1},
{name = "coinctlid", type = "", unit = 1},
{name = "warhead_status", type = "", unit = 1},
{name = "change_list", type = "", unit = 2},
{name = "using_pet_id", type = "", unit = 1},
{name = "pet_level", type = "", unit = 1},
{name = "give_tool", type = "", unit = 2},
}

slg_protocol["proto_faint_history"] = {
{name = "skill_id", type = "", unit = 1},
{name = "start_time", type = "", unit = 1},
{name = "keey_time", type = "", unit = 1},
}

slg_protocol["proto_by_fish"] = {
{name = "fish_uid", type = "", unit = 1},
{name = "fish_id", type = "", unit = 1},
{name = "times", type = "", unit = 1},
{name = "time_stamp", type = "", unit = 1},
{name = "path_id", type = "", unit = 1},
{name = "cold_history", type = "", unit = 2},
{name = "x_offset", type = "", unit = 1},
{name = "y_offset", type = "", unit = 1},
{name = "faint_history", type = "proto_faint_history", unit = 2},
}

slg_protocol["proto_by_shoot"] = {
{name = "shoot_uid", type = "", unit = 1},
{name = "cannon_id", type = "", unit = 1},
{name = "fish_uid", type = "", unit = 1},
{name = "player_id", type = "", unit = 1},
{name = "pos", type = "", unit = 1},
{name = "time_stamp", type = "", unit = 1},
{name = "pos_x", type = "", unit = 1},
{name = "pos_y", type = "", unit = 1},
{name = "direct", type = "", unit = 1},
{name = "angle", type = "", unit = 1},
{name = "tan", type = "", unit = 1},
{name = "pospx", type = "", unit = 1},
{name = "pospy", type = "", unit = 1},
{name = "pos2x", type = "", unit = 1},
{name = "pos2y", type = "", unit = 1},
{name = "cannon_skin", type = "", unit = 1},
}

slg_protocol["proto_by_res"] = {
{name = "gtid", type = "", unit = 1},
{name = "num", type = "", unit = 1},
}

slg_protocol["proto_fish_res_list"] = {
{name = "fish_uid", type = "", unit = 1},
{name = "res_list", type = "proto_by_res", unit = 2},
}

slg_protocol["proto_reward_fish"] = {
{name = "fishid", type = "", unit = 1},
{name = "need", type = "", unit = 1},
{name = "num", type = "", unit = 1},
}

slg_protocol["proto_reward_res"] = {
{name = "pid", type = "", unit = 1},
{name = "rank", type = "", unit = 1},
{name = "kill_list", type = "proto_reward_fish", unit = 2},
}

slg_protocol["s2c_reward_start"] = {
{name = "ret_code", type = "", unit = 1},
}

slg_protocol["s2c_by_reward"] = {
{name = "expire", type = "", unit = 1},
{name = "reward_list", type = "proto_reward_res", unit = 2},
}

slg_protocol["s2c_reward_result"] = {
{name = "pid", type = "", unit = 1},
{name = "itemid", type = "", unit = 1},
{name = "num", type = "", unit = 1},
}

slg_protocol["c2s_by_enter"] = {
{name = "room_type", type = "", unit = 1},
}

slg_protocol["s2c_by_enter"] = {
{name = "ret_code", type = "", unit = 1},
{name = "room_type", type = "", unit = 1},
}

slg_protocol["c2s_leave_by"] = {
{name = "player_id", type = "", unit = 1},
{name = "op", type = "", unit = 1},
}

slg_protocol["s2c_leave_by"] = {
{name = "ret_code", type = "", unit = 1},
}

slg_protocol["c2s_by_shoot"] = {
{name = "type", type = "", unit = 1},
{name = "cannon_id", type = "", unit = 1},
{name = "fish_uid", type = "", unit = 1},
{name = "shoot_uid", type = "", unit = 1},
{name = "pos_x", type = "", unit = 1},
{name = "pos_y", type = "", unit = 1},
{name = "direct", type = "", unit = 1},
{name = "angle", type = "", unit = 1},
{name = "tan", type = "", unit = 1},
{name = "pospx", type = "", unit = 1},
{name = "pospy", type = "", unit = 1},
{name = "pos2x", type = "", unit = 1},
{name = "pos2y", type = "", unit = 1},
{name = "rage_multiple", type = "", unit = 1},
}

slg_protocol["s2c_by_shoot"] = {
{name = "ret_code", type = "", unit = 1},
{name = "type", type = "", unit = 1},
{name = "cannon_id", type = "", unit = 1},
{name = "fish_uid", type = "", unit = 1},
{name = "shoot_uid", type = "", unit = 1},
{name = "pos_x", type = "", unit = 1},
{name = "pos_y", type = "", unit = 1},
{name = "direct", type = "", unit = 1},
{name = "angle", type = "", unit = 1},
{name = "tan", type = "", unit = 1},
{name = "pospx", type = "", unit = 1},
{name = "pospy", type = "", unit = 1},
{name = "pos2x", type = "", unit = 1},
{name = "pos2y", type = "", unit = 1},
}

slg_protocol["c2s_by_change_cannon"] = {
{name = "cannon_id", type = "", unit = 1},
}

slg_protocol["s2c_by_change_cannon"] = {
{name = "ret_code", type = "", unit = 1},
{name = "cannon_id", type = "", unit = 1},
}

slg_protocol["c2s_by_shoot_fish"] = {
{name = "shoot_uid", type = "", unit = 1},
{name = "fish_uid_list", type = "", unit = 2},
}

slg_protocol["s2c_by_shoot_fish"] = {
{name = "ret_code", type = "", unit = 1},
{name = "shoot_uid", type = "", unit = 1},
{name = "fish_uid_list", type = "", unit = 2},
{name = "shoot_hide", type = "", unit = 1},
}

slg_protocol["c2s_by_use_skill"] = {
{name = "skill_id", type = "", unit = 1},
{name = "multiple", type = "", unit = 1},
}

slg_protocol["s2c_by_use_skill"] = {
{name = "ret_code", type = "", unit = 1},
{name = "player_id", type = "", unit = 1},
{name = "skill_id", type = "", unit = 1},
{name = "fish_id", type = "", unit = 1},
{name = "is_first", type = "", unit = 1},
{name = "award", type = "proto_tool_data", unit = 2},
{name = "death_fish", type = "", unit = 2},
}

slg_protocol["c2s_by_change_room"] = {
{name = "room_type", type = "", unit = 1},
}

slg_protocol["s2c_by_change_room"] = {
{name = "ret_code", type = "", unit = 1},
{name = "room_type", type = "", unit = 1},
}

slg_protocol["s2c_by_player_info"] = {
{name = "by_player", type = "proto_by_player", unit = 1},
}

slg_protocol["c2s_by_change_skin"] = {
{name = "skin", type = "", unit = 1},
}

slg_protocol["s2c_by_change_skin"] = {
{name = "code", type = "", unit = 1},
{name = "skin", type = "", unit = 1},
}

slg_protocol["s2c_by_bc_player_enter_left"] = {
{name = "type", type = "", unit = 1},
{name = "by_player", type = "proto_by_player", unit = 1},
}

slg_protocol["s2c_by_bc_player_shoot"] = {
{name = "shoot", type = "proto_by_shoot", unit = 1},
{name = "coin", type = "", unit = 1},
}

slg_protocol["s2c_by_bc_player_change_cannon"] = {
{name = "player_id", type = "", unit = 1},
{name = "cannon_id", type = "", unit = 1},
}

slg_protocol["s2c_by_bc_player_shoot_fish"] = {
{name = "player_id", type = "", unit = 1},
{name = "shoot_uid", type = "", unit = 1},
{name = "fish_state_list", type = "", unit = 2},
{name = "fish_res_list", type = "proto_fish_res_list", unit = 2},
{name = "card_type", type = "", unit = 1},
{name = "cards_list", type = "", unit = 2},
{name = "fish_multiple", type = "", unit = 1},
{name = "dial_list", type = "", unit = 2},
{name = "shoot_hide", type = "", unit = 1},
{name = "fish_drop", type = "proto_tool_data", unit = 2},
{name = "normal_drop", type = "proto_tool_data", unit = 2},
{name = "kill_drop", type = "proto_tool_data", unit = 2},
}

slg_protocol["s2c_by_bc_room_data"] = {
{name = "room_type", type = "", unit = 1},
{name = "time_stamp", type = "", unit = 1},
{name = "now_bg_id", type = "", unit = 1},
{name = "by_players", type = "proto_by_player", unit = 2},
{name = "fish_list", type = "proto_by_fish", unit = 2},
{name = "shoot_list", type = "proto_by_shoot", unit = 2},
{name = "poker_drop", type = "", unit = 1},
{name = "tool_info", type = "proto_by_tool_info", unit = 2},
{name = "special_drop", type = "", unit = 2},
{name = "horn_cd_time", type = "", unit = 1},
}

slg_protocol["s2c_by_bc_fish_make"] = {
{name = "fish", type = "proto_by_fish", unit = 2},
}

slg_protocol["s2c_by_bc_fish_tide"] = {
{name = "now_bg_id", type = "", unit = 1},
{name = "time_stamp", type = "", unit = 1},
}

slg_protocol["proto_by_debug_info"] = {
{name = "key", type = "", unit = 1},
{name = "val", type = "", unit = 1},
}

slg_protocol["s2c_by_shoot_info"] = {
{name = "data", type = "proto_by_debug_info", unit = 2},
}

slg_protocol["c2s_by_cannon_lv"] = {
}

slg_protocol["s2c_by_cannon_lv"] = {
{name = "lv", type = "", unit = 1},
}

slg_protocol["proto_by_cannon_lv_reward"] = {
{name = "id", type = "", unit = 1},
{name = "val", type = "", unit = 1},
}

slg_protocol["c2s_by_cannon_lv_up"] = {
{name = "protect", type = "", unit = 1},
}

slg_protocol["s2c_by_cannon_lv_up"] = {
{name = "code", type = "", unit = 1},
{name = "result", type = "", unit = 1},
{name = "lv", type = "", unit = 1},
{name = "reward", type = "proto_by_cannon_lv_reward", unit = 2},
}

slg_protocol["c2s_by_draw_info"] = {
{name = "id", type = "", unit = 1},
}

slg_protocol["s2c_by_draw_info"] = {
{name = "coin", type = "", unit = 1},
{name = "fish", type = "", unit = 1},
}

slg_protocol["proto_by_draw_item"] = {
{name = "id", type = "", unit = 1},
{name = "num", type = "", unit = 1},
}

slg_protocol["c2s_by_draw_do"] = {
{name = "type", type = "", unit = 1},
}

slg_protocol["s2c_by_draw_do"] = {
{name = "code", type = "", unit = 1},
{name = "player_id", type = "", unit = 1},
{name = "coin", type = "", unit = 1},
{name = "fish", type = "", unit = 1},
{name = "reward", type = "proto_by_draw_item", unit = 2},
}

slg_protocol["s2c_by_match_task_beining"] = {
{name = "task_id", type = "", unit = 1},
{name = "beging_time", type = "", unit = 1},
{name = "ending_time", type = "", unit = 1},
{name = "integral_rewards", type = "", unit = 1},
{name = "finish_data", type = "proto_reward_fish", unit = 2},
}

slg_protocol["s2c_by_match_task_update"] = {
{name = "task_id", type = "", unit = 1},
{name = "finish_data", type = "proto_reward_fish", unit = 2},
}

slg_protocol["s2c_by_match_task_ending"] = {
{name = "task_id", type = "", unit = 1},
{name = "finish", type = "", unit = 1},
{name = "integral", type = "", unit = 1},
}

slg_protocol["s2c_by_match_finish"] = {
{name = "inning_integral", type = "", unit = 1},
{name = "cannon_add", type = "", unit = 1},
{name = "times_apply_add", type = "", unit = 1},
{name = "finally_integral", type = "", unit = 1},
{name = "day_max_integral", type = "", unit = 1},
{name = "vip_add", type = "", unit = 1},
}

slg_protocol["s2c_bugle_start"] = {
{name = "expire", type = "", unit = 1},
{name = "create", type = "", unit = 1},
{name = "event_id", type = "", unit = 1},
}

slg_protocol["s2c_bugle_result"] = {
{name = "player_id", type = "", unit = 1},
{name = "event_id", type = "", unit = 1},
}

slg_protocol["proto_buy_skin_info"] = {
{name = "skin_id", type = "", unit = 1},
{name = "valid_day", type = "", unit = 1},
}

slg_protocol["s2c_buy_skin_info"] = {
{name = "data", type = "proto_buy_skin_info", unit = 2},
}

slg_protocol["c2s_by_exchange"] = {
{name = "item_id", type = "", unit = 1},
}

slg_protocol["proto_by_item_info"] = {
{name = "id", type = "", unit = 1},
{name = "num", type = "", unit = 1},
}

slg_protocol["s2c_by_exchange"] = {
{name = "ret_code", type = "", unit = 1},
{name = "item_info", type = "proto_by_item_info", unit = 2},
}

slg_protocol["s2c_by_item_change"] = {
{name = "tool_info", type = "proto_by_tool_info", unit = 2},
}

slg_protocol["c2s_ghost_select_score"] = {
}

slg_protocol["s2c_ghost_select_score"] = {
{name = "score", type = "", unit = 1},
{name = "ret_code", type = "", unit = 1},
}

slg_protocol["c2s_ghost_open_card"] = {
{name = "pos", type = "", unit = 1},
}

slg_protocol["s2c_ghost_open_card"] = {
{name = "ret_code", type = "", unit = 1},
{name = "id", type = "", unit = 1},
{name = "coin", type = "", unit = 1},
}

slg_protocol["c2s_ghost_leave"] = {
}

slg_protocol["s2c_ghost_leave"] = {
{name = "ret_code", type = "", unit = 1},
{name = "uid", type = "", unit = 1},
}

slg_protocol["c2s_by_use_warhead"] = {
{name = "warhead_id", type = "", unit = 1},
}

slg_protocol["s2c_by_use_warhead"] = {
{name = "ret_code", type = "", unit = 1},
{name = "use_uid", type = "", unit = 1},
{name = "warhead_id", type = "", unit = 1},
{name = "cannon_skin", type = "", unit = 1},
}

slg_protocol["c2s_by_notify_effects"] = {
{name = "ext", type = "", unit = 1},
}

slg_protocol["s2c_by_notify_effects"] = {
{name = "effects_uid", type = "", unit = 1},
{name = "effects_id", type = "", unit = 1},
{name = "effects_multiple", type = "", unit = 1},
{name = "end_status", type = "", unit = 1},
{name = "tool_data", type = "proto_tool_data", unit = 2},
{name = "show_multiple", type = "", unit = 1},
}

slg_protocol["s2c_by_rocket_header_bomb"] = {
{name = "ret_code", type = "", unit = 1},
{name = "uid", type = "", unit = 1},
{name = "coin_num", type = "", unit = 1},
{name = "shoot_id", type = "", unit = 1},
}

slg_protocol["pet_skill_die_fish_reward"] = {
{name = "fish_uid", type = "", unit = 1},
{name = "reward", type = "proto_tool_data", unit = 2},
{name = "fish_multiple", type = "", unit = 1},
{name = "card_type", type = "", unit = 1},
{name = "cards_list", type = "", unit = 2},
{name = "dial_list", type = "", unit = 2},
}

slg_protocol["c2s_by_pet_skill_hit_fish"] = {
{name = "skill_id", type = "", unit = 1},
{name = "fish_uid_list", type = "", unit = 2},
{name = "skill_posx", type = "", unit = 1},
{name = "skill_posy", type = "", unit = 1},
}

slg_protocol["s2c_by_pet_skill_hit_fish"] = {
{name = "ret_code", type = "", unit = 1},
{name = "skill_id", type = "", unit = 1},
{name = "uid", type = "", unit = 1},
{name = "die_fish_reward", type = "pet_skill_die_fish_reward", unit = 2},
{name = "skill_posx", type = "", unit = 1},
{name = "skill_posy", type = "", unit = 1},
{name = "hit_fish_uid", type = "", unit = 2},
}

slg_protocol["s2c_broadcast_pet_skill_end"] = {
{name = "uid", type = "", unit = 1},
{name = "skill_id", type = "", unit = 1},
{name = "state", type = "", unit = 1},
}

slg_protocol["s2c_by_rocket_header_timer"] = {
{name = "uid", type = "", unit = 1},
{name = "time", type = "", unit = 1},
}

slg_protocol["c2s_by_use_rocket_header"] = {
{name = "shoot_id", type = "", unit = 1},
}

slg_protocol["s2c_by_use_rocket_header"] = {
{name = "uid", type = "", unit = 1},
}

slg_protocol["c2s_by_rocket_header_die"] = {
}

slg_protocol["s2c_by_rocket_header_die"] = {
{name = "uid", type = "", unit = 1},
{name = "coin", type = "", unit = 1},
}

slg_protocol["s2c_by_rocket_header_coin"] = {
{name = "uid", type = "", unit = 1},
{name = "coin", type = "", unit = 1},
}

slg_protocol["c2s_fish_position_precision"] = {
{name = "ext", type = "", unit = 1},
}

slg_protocol["fish_precision_info"] = {
{name = "fish_uid", type = "", unit = 1},
{name = "current_time", type = "", unit = 1},
{name = "x_pos", type = "", unit = 1},
{name = "y_pos", type = "", unit = 1},
{name = "u_pos", type = "", unit = 1},
}

slg_protocol["s2c_fish_position_precision"] = {
{name = "precision_info", type = "fish_precision_info", unit = 2},
}

slg_protocol["c2s_change_pet"] = {
{name = "petid", type = "", unit = 1},
}

slg_protocol["s2c_change_pet"] = {
{name = "ret_code", type = "", unit = 1},
{name = "uid", type = "", unit = 1},
{name = "petid", type = "", unit = 1},
{name = "level", type = "", unit = 1},
}

slg_protocol["proto_shake_money_game_info"] = {
{name = "normal_times", type = "", unit = 1},
{name = "pet_times", type = "", unit = 1},
{name = "pet_id", type = "", unit = 1},
{name = "drop_tool", type = "proto_tool_data", unit = 2},
{name = "drop_multiple", type = "", unit = 1},
}

slg_protocol["c2s_get_shake_money_game_info"] = {
{name = "ext", type = "", unit = 1},
}

slg_protocol["s2c_get_shake_money_game_info"] = {
{name = "ret_code", type = "", unit = 1},
{name = "game_info", type = "proto_shake_money_game_info", unit = 1},
}

slg_protocol["c2s_shake_money_begin"] = {
{name = "ext", type = "", unit = 1},
}

slg_protocol["s2c_shake_money_begin"] = {
{name = "ret_code", type = "", unit = 1},
{name = "game_info", type = "proto_shake_money_game_info", unit = 1},
}

slg_protocol["s2c_shake_money_end"] = {
{name = "uid", type = "", unit = 1},
{name = "award", type = "proto_tool_data", unit = 2},
}

slg_protocol["s2c_anger_generate_boss"] = {
{name = "fish_id", type = "", unit = 1},
{name = "current_anger", type = "", unit = 1},
{name = "target_anger", type = "", unit = 1},
}

slg_protocol["s2c_call_boss_status"] = {
{name = "fish_id", type = "", unit = 1},
{name = "start_time", type = "", unit = 1},
{name = "end_time", type = "", unit = 1},
{name = "is_end", type = "", unit = 1},
}

slg_protocol["c2s_get_gossip_door_data"] = {
{name = "ext", type = "", unit = 1},
}

slg_protocol["s2c_get_gossip_door_data"] = {
{name = "ret_code", type = "", unit = 1},
{name = "uid", type = "", unit = 1},
{name = "multiple", type = "", unit = 1},
{name = "door_id", type = "", unit = 1},
{name = "is_end", type = "", unit = 1},
{name = "award", type = "proto_tool_data", unit = 2},
}

slg_protocol["game_pool_data"] = {
{name = "pool_type", type = "", unit = 1},
{name = "pool_num", type = "", unit = 1},
{name = "reward_history", type = "", unit = 2},
}

slg_protocol["c2s_get_game_pool_data"] = {
{name = "pool_type", type = "", unit = 1},
}

slg_protocol["s2c_get_game_pool_data"] = {
{name = "ret_code", type = "", unit = 1},
{name = "pool_data", type = "game_pool_data", unit = 1},
}

slg_protocol["s2c_user_pool_reward_data"] = {
{name = "uid", type = "", unit = 1},
{name = "pool_type", type = "", unit = 1},
{name = "reward_data", type = "proto_tool_data", unit = 2},
}

slg_protocol["proto_by_fish_preview"] = {
{name = "fish_id", type = "", unit = 1},
{name = "time_stamp", type = "", unit = 1},
{name = "prelv", type = "", unit = 1},
}

slg_protocol["s2c_by_bc_prefish_time"] = {
{name = "fish_pre_info", type = "proto_by_fish_preview", unit = 2},
}

---------------------------------------------------------