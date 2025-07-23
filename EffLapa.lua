--[[
拉霸机（单个）
@see startLapa
]]

local M = class("EffLapa")

local DUR_ONE = 0.3
local DURATION = 2
local REWARDIDX = 2

function M:ctor(list, args, callback)
    self:init(list, args, callback)
end

function M:init(list, args, callback, run)
    if list then
        self._list = list
        self._runner = self._list:getInnerContainer()
        self._finishCallback = callback

        self:setParam(args)

        self._amount = self._list:getChildrenCount()
        self._uint = self._list:getItem(0)
        self._uintSize = self._uint:getContentSize().height
        self._totalSize = self._uintSize * self._amount

        if args.run or run then
            self:run()
        end
    end
end

function M:setParam(param)
    param.duration = param.duration or DURATION
    self._param = param

    self._endCallback = param.endCallback
    self._maxDur = param.duration
    self._to = param.to
    self._from = param.from
    self._factor = -1
end

function M:updateFromTo(from, to)
    self._from = from or self._from
    self._to = to or self._to
end

function M:run(param)
    if param then
        self:setParam(param)
    end
    
    local seq = {
        cc.EaseExponentialIn:create(cc.MoveTo:create(1.0, cc.p(0, -self._uintSize*2))),
    }
    local runTurn = Number.ceil(self._maxDur / DUR_ONE)
    for i = 1, runTurn do
        seq[#seq+1] = cc.MoveTo:create(DUR_ONE, cc.p(0, self._uintSize-self._totalSize+Number.random(0,self._uintSize)))
        seq[#seq+1] = cc.Place:create(cc.p(0, Number.random(0, self._uintSize)))
    end
    seq[#seq+1] = cc.CallFunc:create(function()
        local item = self._list:getItem(self._to)
        local itemReward = self._list:getItem(REWARDIDX)
        local posY = item:getPositionY()
        local posRewardY = itemReward:getPositionY()
        item:setPositionY(posRewardY)
        itemReward:setPositionY(posY)
    end)
    seq[#seq+1] = cc.EaseExponentialOut:create(cc.MoveTo:create(2.0, cc.p(0, -self._uintSize*(self._amount-REWARDIDX-1))))
    seq[#seq+1] = cc.DelayTime:create(0.4)
    if self._finishCallback then
        seq[#seq+1] = cc.CallFunc:create(function()
            self._finishCallback(self._list:getItem(self._to))
        end)
    end

    self._runner:runAction(transition.sequence(seq))
end

function M:stop()
    self._runner:stopAllActions()
end

function M:destroy()
    self:stop()
end

--------------------------------------------
--[[
拉霸开始滚动
@param list     ListView    listview对象
@param args     table       参数表
@param callback function    结束回调

@see args : {
                duration : 高速旋转持续时间
                from : 起始的节点索引
                to : 结束的节点索引
            }
]]
function M:startLapa(list, args, callback)
    if self._list and self._list == list then
        self:stop()
    end
    self:init(list, args, callback, true)
end

return M