--[[
动作特效管理类
]]

local M = class("EffectManager")

--local director = cc.Director:getInstance()
--local scheduler = director:getScheduler()

--[[
动作特效类型
	cls: 对应特效类
	api: 实现接口
]]
cc.exports.EffType = {
	shader 		= {cls="EffShader", 	api="setShader"},	-- 着色
	adrift 		= {cls="EffNode", 		api="adrift"},		-- 漂浮效果
	breathe 	= {cls="EffNode", 		api="breathe"},		-- 呼吸效果
	bubble 		= {cls="EffNode", 		api="bubble"},		-- 冒泡效果
	ripple 		= {cls="EffNode", 		api="ripple"},		-- 波动效果
	rippleOut 	= {cls="EffNode", 		api="rippleOut"},	-- 波动消失
	floating	= {cls="EffNode", 		api="floating"},	-- 悬浮
	rock		= {cls="EffNode", 		api="rock"},		-- 摇晃
	zoom		= {cls="EffNode", 		api="zoom"},		-- 缩放
	zoomOut		= {cls="EffNode", 		api="zoomOut"},		-- 缩小
	flyTo		= {cls="EffNode", 		api="flyTo"},		-- 飞向
	beton		= {cls="EffNode", 		api="moveAndBack"},	-- 押注
	flop		= {cls="EffNode", 		api="flop"},		-- 翻转
	jelly		= {cls="EffNode", 		api="jelly"},		-- 果冻Q弹
	blink		= {cls="EffNode", 		api="blink"},		-- 闪烁
	lapa		= {cls="EffLapa", 		api="startLapa"},	-- 拉霸
	tour		= {cls="EffTour", 		api="tour"},		-- 鱼巡游
	slideIn		= {cls="EffNode", 		api="slideIn"},		-- 滑入
	slideOut	= {cls="EffNode", 		api="slideOut"},	-- 滑出
}

cc.exports.EffDir = {
	top 		= 1,
	left 		= 2,
	center 		= 3,
	right 		= 4,
	bottom 		= 5,
}

function M:ctor()
    self:init()
end

function M:init()
	self._effList = {}
	self._eff = {}

	for _,v in pairs(EffType) do
		if not self._eff[v.cls] then
			self._eff[v.cls] = require_ex("effect."..v.cls).new()
		end
	end
end

------------------------------
--[[
执行特效
@param effType 	number 	特效类型
@param ... 			 	不定长参数列表
]]
function M:doEffectAPI(effType, ...)
	if not effType or not self._eff[effType.cls] or not self._eff[effType.cls][effType.api] then
        return
    end
    self._eff[effType.cls][effType.api](self._eff[effType.cls], ...)
end

--[[
创建并执行特效
不重复利用特效对象，重新创建新的特效对象并执行
@param effType 	number 	特效类型
@param ... 			 	不定长参数列表
]]
function M:createEffect(effType, ...)
	if not effType then return end
	return require_ex("effect."..effType.cls).new(...)
end

return M.new()