--[[
结点动作
单个结点的Action，不涉及到其他
e.g. 缩放、摇晃
]]

local M = class("EffNode")

function M:ctor()
    self:init()
end

function M:init()
	
end

------------------------------
--[[
漂浮效果
@param node     Node        结点
@param strength table/nil   增强（{x,y,z,f}）
@param origin   table/nil   增强（{x,y,z,f}）
]]
function M:adrift(node, strength, origin)
    if not node then return end
    strength = strength or { }
    origin = origin or { }
    local x = (origin.x or Number.random(5, 10)) + checknumber(strength.x)
    local y = (origin.y or Number.random(5, 10)) + checknumber(strength.y)
    local z = (origin.z or Number.randomFloat(0.5, 1.5)) + checknumber(strength.z)
    local f = (origin.f or Number.randomFloat(0.8, 1.2)) + checknumber(strength.f)
    local seq = {
        cc.RotateBy:create(1*f,cc.Vertex3F(x,y,z)),
        cc.RotateBy:create(2*f,cc.Vertex3F(-2*x,y,-z*2)),
        cc.RotateBy:create(1*f,cc.Vertex3F(x,-2*y,z)),
    }
    if node.__actAdrift__ then
        node:stopAction(node.__actAdrift__)
        node.__actAdrift__ = nil
    end
    node.__actAdrift__ = cc.RepeatForever:create(transition.sequence(seq))
    node:runAction(node.__actAdrift__)
end

--[[
呼吸效果
@param node         Node        结点
@param strength     number      呼吸强度
@param orgScaleX    number      原始ScaleX
@param orgScaleY    number      原始ScaleY
]]
function M:breathe(node, strength, orgScaleX, orgScaleY)
    if not node then return end
    strength = strength or 0.98
    orgScaleX = orgScaleX or node:getScaleX()
    orgScaleY = orgScaleY or node:getScaleY()
    local sx1, sx2 = orgScaleX*strength, orgScaleX*1
    local sy1, sy2 = orgScaleY*strength, orgScaleY*1
    local seq = {
        cc.ScaleTo:create(Number.randomFloat(0.9, 1.2), sx1, sy1),
        cc.DelayTime:create(Number.randomFloat(0.05, 0.15)),
        cc.ScaleTo:create(Number.randomFloat(0.9, 1.2), sx2, sy2),
        cc.DelayTime:create(Number.randomFloat(0.05, 0.15)),
    }
    if node.__actBreathe__ then
        node:stopAction(node.__actBreathe__)
        node.__actBreathe__ = nil
    end
    node.__actBreathe__ = cc.RepeatForever:create(transition.sequence(seq))
    node:runAction(node.__actBreathe__)
end

--[[
冒泡效果
@param node         Node        结点
@param delay        number      延迟
@param strength     number      强度
@param startScale   number      起始Scale
@param orgScaleX    number      原始ScaleX
@param orgScaleY    number      原始ScaleY
]]
function M:bubble(node, delay, strength, startScale, orgScaleX, orgScaleY)
    if not node then return end
    strength = strength or 1.2
    startScale = checknumber(startScale)
    orgScaleX = orgScaleX or node:getScaleX()
    orgScaleY = orgScaleY or node:getScaleY()
    local sx1, sx2 = orgScaleX*strength, orgScaleX*1
    local sy1, sy2 = orgScaleY*strength, orgScaleY*1
    local seq = {
        cc.DelayTime:create(checknumber(delay)),
        cc.ScaleTo:create(0.01, startScale, startScale),
        cc.Show:create(),
        cc.ScaleTo:create(0.2, sx1, sy1),
        cc.DelayTime:create(0.03),
        cc.ScaleTo:create(0.1, sx2, sy2),
    }
    node:setVisible(false)
    node:runAction(transition.sequence(seq))
end

--[[
波动效果（小幅缩放）
@param node         Node        结点
@param origin       number      强度
@param strength     number      强度
@param dur          number      时长
]]
function M:ripple(node, origin, strength, dur)
    if not node then return end
    origin = origin or 0.8
    strength = strength or 1.05
    dur = dur or 0.14
    local orgScaleX = node:getScaleX()
    local orgScaleY = node:getScaleY()
    local sx1, sx2 = orgScaleX*strength, orgScaleX*1
    local sy1, sy2 = orgScaleY*strength, orgScaleY*1
    local seq = {
        cc.ScaleTo:create(dur, sx1, sy1),
        cc.ScaleTo:create(dur/2, sx2, sy2),
    }
    node:setScale(origin)
    node:runAction(transition.sequence(seq))
end

function M:rippleOut(node, callback, dst, strength, dur)
    if not node then return end
    dst = dst or 0.6
    strength = strength or 1.05
    dur = dur or 0.14
    local orgScaleX = node:getScaleX()
    local orgScaleY = node:getScaleY()
    local sx1, sx2 = orgScaleX*strength, orgScaleX*dst
    local sy1, sy2 = orgScaleY*strength, orgScaleY*dst
    local seq = {
        cc.ScaleTo:create(dur/2, sx1, sy1),
        cc.Spawn:create(cc.ScaleTo:create(dur, sx2, sy2), cc.FadeOut:create(dur)),
    }
    if type(callback) == "function" then
        table.insert(seq, cc.CallFunc:create(callback))
    end
    node:runAction(transition.sequence(seq))
end

--[[
悬浮
@param node         Node        结点
@param x            number      X方向位移
@param y            number      Y方向位移
@param speed        number      悬浮速度
]]
function M:floating(node, x, y, speed)
    if not node then return end
    x = x or 0
    y = y or 10
    local seq = {
        cc.MoveBy:create(Number.randomFloat(1.7, 2), cc.p(x, y)),
        cc.DelayTime:create(Number.randomFloat(0.05, 0.15)),
        cc.MoveBy:create(Number.randomFloat(1.7, 2), cc.p(x, -y)),
        cc.DelayTime:create(Number.randomFloat(0.05, 0.15)),
    }
    if node.__actFloating__ then
        node:stopAction(node.__actFloating__)
        node.__actFloating__ = nil
    end
    if node.originalX then
        node:setPositionX(node.originalX)
    end
    if node.originalY then
        node:setPositionY(node.originalY)
    end
    if speed then
        node.__actFloating__ = cc.Speed:create(cc.RepeatForever:create(transition.sequence(seq)), speed)
    else
        node.__actFloating__ = cc.RepeatForever:create(transition.sequence(seq))
    end
    node:runAction(node.__actFloating__) 
end

--[[
摇晃
@param node         Node        结点
@param enable       boolean     开始/停止
@param interval     number      晃动间隔
@param strength     number      强度（晃动角度）
]]
function M:rock(node, enable, interval, strength)
    if not node then
        return
    end
    if enable then
        interval = interval or 1.5
        strength = strength or 5
        local seq = {
            cc.DelayTime:create(0.5),
            cc.RotateTo:create(0.1, -strength),
            cc.RotateTo:create(0.1, strength),
            cc.RotateTo:create(0.1, -strength),
            cc.RotateTo:create(0.1, strength),
            cc.RotateTo:create(0.1, 0),
            cc.DelayTime:create(interval)
        }
        if node.__actRock__ then
            node:stopAction(node.__actRock__)
            node.__actRock__ = nil
        end
        node:setRotation(0)
        node.__actRock__ = cc.RepeatForever:create(transition.sequence(seq))
        node:runAction(node.__actRock__)
    else
        if node.__actRock__ then
            node:stopAction(node.__actRock__)
            node.__actRock__ = nil
        end
        node:setRotation(0)
    end
end

--[[
缩放
@param node         Node        结点
@param delay        number      延迟
@param strength     number      强度（缩放比例）
@param orgScaleX    number      原始比例
@param orgScaleY    number      原始比例
]]
function M:zoom(node, delay, strength, orgScaleX, orgScaleY)
    if not node then return end
    strength = strength or 0.95
    orgScaleX = orgScaleX or node:getScaleX()
    orgScaleY = orgScaleY or node:getScaleY()
    local sx1, sx2 = orgScaleX*strength, orgScaleX*1
    local sy1, sy2 = orgScaleY*strength, orgScaleY*1
    local seq = {
        cc.ScaleTo:create(0.03, sx1, sy1),
        cc.DelayTime:create(0.03),
        cc.ScaleTo:create(0.03, sx2, sy2),
        cc.CallFunc:create(function()
            node.__actZoom__ = nil
        end)
    }
    if delay then
        table.insert(seq, 1, cc.DelayTime:create(delay))
        table.insert(seq, 2, cc.Show:create())
        node:setVisible(false)
    end
    if node.__actZoom__ then
        node:stopAction(node.__actZoom__)
        node.__actZoom__ = nil
    end
    node.__actZoom__ = transition.sequence(seq)
    node:runAction(node.__actZoom__)
end

--[[
缩小消失
@param node         Node        结点
@param strength     number      缩放比例
@param dstPos       Point       目标位置
@param duration     number      延迟
@param callback     function    结束回调
]]
function M:zoomOut(node, strength, dstPos, duration, callback)
    if not node then return end
    strength = strength or 0.01
    duration = duration or 0.15
    local orgScale = node:getScale()
    local s1, s2 = orgScale*1.05, orgScale*strength
    local scaleTo = cc.ScaleTo:create(duration, s2)
    if dstPos then
        local moveTo = cc.MoveTo:create(duration, dstPos)
        scaleTo = cc.Spawn:create(scaleTo, moveTo)
    end
    local seq = {
        cc.ScaleTo:create(0.1, s1),
        scaleTo,
        cc.CallFunc:create(function()
            node.__actZoomOut__ = nil
            if callback then
                callback()
            end
        end)
    }
    --if delay then
    --    table.insert(seq, 1, cc.DelayTime:create(delay))
    --end
    if node.__actZoomOut__ then
        node:stopAction(node.__actZoomOut__)
        node.__actZoomOut__ = nil
    end
    node.__actZoomOut__ = transition.sequence(seq)
    node:runAction(node.__actZoomOut__)
end

--[[
闪烁
@param node         Node        结点
@param min_opacity  number      最小透明度
@param max_opacity  number      最大透明度
@param dur          number      过渡持续时长
]]
function M:blink(node, min_opacity, max_opacity, dur)
    if not node then return end
    min_opacity = min_opacity or 0
    max_opacity = max_opacity or 255
    dur = dur or 0.03
    local seq = {
        cc.FadeTo:create(dur, max_opacity),
        cc.FadeTo:create(dur, min_opacity),
    }
    if node.__actBlink__ then
        node:stopAction(node.__actBlink__)
        node.__actBlink__ = nil
    end
    node.__actBlink__ = cc.RepeatForever:create(transition.sequence(seq))
    node:runAction(node.__actBlink__)
end

--[[
飞向
@param node         Node        结点
@param pos          Point       坐标
@param strength     number      放大
@param scaleOut     number      终点缩放比例
@param dur          number      持续时长
@param callback     function    完成回调
]]
function M:flyTo(node, pos, strength, scaleOut, dur, callback)
    if not node then return end
    strength = strength or 1.1
    scaleOut = scaleOut or 0.1
    dur = dur or 0.5
    local orgScale = node:getScale()
    local s1 = orgScale*strength
    local s2 = orgScale*scaleOut
    local seq = {
        cc.ScaleTo:create(0.05, s1),
        cc.ScaleTo:create(dur-0.05, s2),
    }
    if callback then
        seq[#seq+1] = cc.CallFunc:create(callback)
    end
    node:runAction(transition.sequence(seq))
    transition.moveTo(node, {time = dur, x = pos.x, y = pos.y, easing = "BACKIN"})
end

--[[
移动后迅速归位（押注）
@param node         Node        结点
@param time         number      每次移动时间
@param base         Point       初始位置
@param distance     number      移动距离
@param is_right     boolean     是否在右边
@param callback     function    完成回调
]]
function M:moveAndBack(node, time, base, distance, is_right, callback)
    if not node then return end
    node:stopAllActions()
    node:setPosition(base)

    local move_back3 = function()
        local moveTo4 = cc.MoveTo:create(time, cc.p(base.x, base.y))
        --local action4 = cc.EaseBackInOut:create(moveTo4)
        node:runAction(cc.Sequence:create(moveTo4,cc.CallFunc:create(function() if callback then callback() end end)))
    end
    local move_back2 = function()
        if is_right then
            local moveTo3 = cc.MoveTo:create(time, cc.p(base.x+(distance-19), base.y))
            --local action3 = cc.EaseBackInOut:create(cc.Spawn:create(moveTo3))
            node:runAction(cc.Sequence:create(moveTo3, cc.CallFunc:create(move_back3)))
        else
            local moveTo3 = cc.MoveTo:create(time, cc.p(base.x-(distance-19), base.y))
            --local action3 = cc.EaseBackInOut:create(cc.Spawn:create(moveTo3))
            node:runAction(cc.Sequence:create(moveTo3, cc.CallFunc:create(move_back3)))
        end
    end
    local move_back1 = function()
        if is_right then
            local moveTo2 = cc.MoveTo:create(time, cc.p(base.x-(distance-15), base.y))
            --local action2 = cc.EaseBackInOut:create(cc.Spawn:create(moveTo2))
            node:runAction(cc.Sequence:create(moveTo2, cc.CallFunc:create(move_back2)))
        else
            local moveTo2 = cc.MoveTo:create(time, cc.p(base.x+(distance-15), base.y))
            --local action2 = cc.EaseBackInOut:create(cc.Spawn:create(moveTo2))
            node:runAction(cc.Sequence:create(moveTo2, cc.CallFunc:create(move_back2)))
        end
    end
    local move_back0 = function()
        if is_right then
            local moveTo1 = cc.MoveTo:create(time, cc.p(base.x+distance, base.y))
            --local action1 = cc.EaseBackInOut:create(cc.Spawn:create(moveTo1))
            node:runAction(cc.Sequence:create(moveTo1, cc.CallFunc:create(move_back1)))
        else
            local moveTo1 = cc.MoveTo:create(time, cc.p(base.x-distance, base.y))
            --local action1 = cc.EaseBackInOut:create(cc.Spawn:create(moveTo1))
            node:runAction(cc.Sequence:create(moveTo1, cc.CallFunc:create(move_back1)))
        end
    end
    if is_right then
        local moveTo0 = cc.MoveTo:create(time, cc.p(base.x-6, base.y))
        --local action0 = cc.EaseBackInOut:create(cc.Spawn:create(moveTo0))
        node:runAction(cc.Sequence:create(moveTo0, cc.CallFunc:create(move_back0)))
    else
        local moveTo0 = cc.MoveTo:create(time, cc.p(base.x+6, base.y))
        --local action0 = cc.EaseBackInOut:create(cc.Spawn:create(moveTo0))
        node:runAction(cc.Sequence:create(moveTo0, cc.CallFunc:create(move_back0)))
    end
end

--[[
翻转
@param node         Node        结点
@param delay        number      延迟
@param dur          number/list 每90度翻转持续时长，list决定是否还原
@param restore      boolean     是否还原（完整翻转）
]]
function M:flop(node, delay, dur, restore)
    if not node then return end
    dur = dur or {0.3, 0.2, 0.1, 0.07, 0.07, 0.07, 0.07, 0.07, 0.07, 0.07, 0.07, 0.1, 0.2, 0.3}
    if restore == nil then
        restore = true
    end
    if restore then
        if type(dur) == "number" then
            dur = {dur}
        end
        local count = 4 * Number.ceil(#dur / 4)
        if #dur < count then
            for i = #dur+1, count do
                dur[i] = dur[i-1]
            end
        end
    end
    
    local seq = {}
    for i,v in ipairs(dur) do
        seq[i] = cc.OrbitCamera:create(v, 1, 0, -90*(i-1), -90, 0, 0)
    end
    if delay then
        table.insert(seq, cc.DelayTime:create(delay))
    end
    node:runAction(transition.sequence(seq))
end

--[[
果冻Q弹
@param node         Node        结点
@param delay        number      延迟
@param dur          number      间隔（0不重复）
]]
function M:jelly(node, delay, dur)
    if not node then return end
    local function _spawnAction_(params)  
        local actScale = cc.ScaleTo:create(params.time, params.sx, params.sy, params.sz)  
        local actFade = cc.FadeIn:create(params.time)  
        return cc.Spawn:create(actScale, actFade)      
    end  
    local seq = {
        _spawnAction_({time = 0.06, sx = 0.63, sy = 1.3, sz = 1}),
        _spawnAction_({time = 0.12, sx = 1.1, sy = 0.7, sz = 1}),
        _spawnAction_({time = 0.07, sx = 0.8, sy = 1.1, sz = 1}),
        _spawnAction_({time = 0.07, sx = 1.1, sy = 0.95, sz = 1}),
        _spawnAction_({time = 0.07, sx = 0.95, sy = 1.05, sz = 1}),
        _spawnAction_({time = 0.07, sx = 1, sy = 1, sz = 1}),
        cc.CallFunc:create(function()
            node.__actJelly__ = nil
        end)
    }
    if delay then
        table.insert(seq, 1, cc.DelayTime:create(delay))
    end

    if node.__actJelly__ then
        node:stopAction(node.__actJelly__)
        node.__actJelly__ = nil
    end
    if dur and dur > 0 then
        seq[#seq] = cc.DelayTime:create(dur)
        node.__actJelly__ = cc.RepeatForever:create(transition.sequence(seq))
    else
        node.__actJelly__ = transition.sequence(seq)
    end
    node:runAction(node.__actJelly__)
end

--[[
滑入
@param node         Node            结点
@param delay        number          延迟
@param dir          number          方向
@param strength     number/point    幅度
@param dur          number          持续时长
]]
function M:slideIn(node, delay, dir, strength, dur)
    if not node then return end
    strength = strength or 100
    dur = dur or 0.3

    local x, y
    if node.__slidePos__ then
        x, y = node.__slidePos__.x, node.__slidePos__.y
    else
        x, y = node:getPosition()
        node.__slidePos__ = cc.p(x, y)
    end
    local fx, fy = x, y
    if dir == EffDir.top then
        fy = y + strength
    elseif dir == EffDir.left then
        fx = x - strength
    elseif dir == EffDir.center then
        fx, fy = strength.x, strength.y
    elseif dir == EffDir.right then
        fx = x + strength
    elseif dir == EffDir.bottom then
        fy = y - strength
    end

    node:setPosition(fx, fy)
    local seq = {
        cc.EaseBackOut:create(cc.MoveTo:create(dur, cc.p(x, y))),
    }
    if delay then
        table.insert(seq, 1, cc.DelayTime:create(delay))
        table.insert(seq, 2, cc.Show:create())
        node:setVisible(false)
    end
    node:runAction(transition.sequence(seq))
end

--[[
滑出
@param node         Node        结点
@param delay        number      延迟
@param dir          number      方向
@param strength     number      幅度
@param dur          number      持续时长
@param hide         boolean     最后隐藏
]]
function M:slideOut(node, delay, dir, strength, dur, hide)
    if not node then return end
    strength = strength or 100
    dur = dur or 0.3
    local x, y = node:getPosition()
    local tx, ty = x, y
    if dir == EffDir.top then
        ty = y + strength
    elseif dir == EffDir.left then
        tx = x - strength
    elseif dir == EffDir.center then
        tx, ty = strength.x, strength.y
    elseif dir == EffDir.right then
        tx = x + strength
    elseif dir == EffDir.bottom then
        ty = y - strength
    end

    local seq = {
        cc.EaseBackIn:create(cc.MoveTo:create(dur, cc.p(tx, ty)))
    }
    if delay then
        table.insert(seq, 1, cc.DelayTime:create(delay))
    end
    if hide then
        table.insert(seq, cc.Hide:create())
    end
    node:runAction(transition.sequence(seq))
end

return M