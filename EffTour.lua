--[[
鱼巡游 (3D)
@see startLapa
]]

local M = class("EffTour")

local DUR_ONE = 0.3
local DURATION = 2

function M:ctor(node, params, callback)
    self:init(node, params, callback)
end

function M:init(node, params, callback)
    if params and params.run then
        self:tour(node, params, callback)
    end
end

------------------------------
--[[
巡游
@param node     Node        结点
@param params   table       参数
@param callback function    回调函数
]]
function M:tour(node, params, callback)
    if not node then return end
    params = params or {}
    self._originScale = params.scale or node:getScale()
    self._callback = callback or params.callback
    if not params.path or params.path == 1 then
        self:tourPath1(node)
    elseif params.path == 2 then
        self:tourPath2(node)
    elseif params.path == 3 then
        self:tourPath3(node)
    end
end

function M:tourPath1(node)
    if node.__actTour__ then
        node:stopAction(node.__actTour__)
        node.__actTour__ = nil
    end
    node:setPosition(display.width + 200, display.height)
    node:setRotation3D({x = 60, y = -30, z = -30})

    local move1 = cc.MoveTo:create(5.0, {x = display.cx+150, y = display.height * 0.2+50})
    local scale1 = cc.ScaleTo:create(5.0, self._originScale * 0.6)
    local action1 = cc.Spawn:create(move1, scale1)

    local posControl21 = cc.p(display.cx+100, display.height * 0.2)
    local posControl22 = cc.p(display.cx, display.height * 0.1)
    local posControl23 = cc.p(display.cx-100, display.height * 0.2)
    local bzConfig2 = {posControl21, posControl22, posControl23}
    local seq2 = {
        cc.ScaleTo:create(1.0, self._originScale * 0.5),
        cc.ScaleTo:create(1.0, self._originScale * 0.6),
    }
    local move2 = cc.BezierTo:create(2.0, bzConfig2)
    local scale2 = transition.sequence(seq2)
    local rotate2 = cc.RotateTo:create(2.0, {x = 30, y = 10, z = 30})
    local action2 = cc.Spawn:create(move2, scale2, rotate2)

    local move3 = cc.MoveTo:create(4.0, {x = 250, y = display.height*0.5-150})
    local scale3 = cc.ScaleTo:create(4.0, self._originScale * 0.9)
    local rotate3 = cc.RotateTo:create(4.0, {x = 80, y = 80, z = 15})
    local action3 = cc.Spawn:create(move3, scale3, rotate3)

    local posControl41 = cc.p(200, display.height*0.5-100)
    local posControl42 = cc.p(150, display.height*0.5-50)
    local posControl43 = cc.p(200, display.height*0.5)
    local bzConfig4 = {posControl41, posControl42, posControl43}
    local seq4 = {
        cc.ScaleTo:create(1.0, self._originScale * 1.0),
        cc.ScaleTo:create(1.0, self._originScale * 1.1),
    }
    local move4 = cc.BezierTo:create(2.0, bzConfig4)
    local scale4 = transition.sequence(seq4)
    local rotate4 = cc.RotateTo:create(2.0, {x = 80, y = 100, z = 5})
    local action4 = cc.Spawn:create(move4, scale4, rotate4)

    local move5 = cc.MoveTo:create(6.0, {x = display.cx+300, y = display.height+300})
    local scale5 = cc.ScaleTo:create(6.0, self._originScale * 2.0)
    local rotate5 = cc.RotateTo:create(3.0, {x = 60, y = 150, z = -30})
    local action5 = cc.Spawn:create(move5, scale5, rotate5)

    local callback = cc.CallFunc:create(function()
        if self._callback then
            if type(self._callback) == "function" then
                self._callback()
            else
                node:removeSelf()
            end
        end
    end)

    node.__actTour__ = transition.sequence({action1, action2, action3, action4, action5, callback})
    node:runAction(node.__actTour__)
end

function M:tourPath2(node)
    if node.__actTour__ then
        node:stopAction(node.__actTour__)
        node.__actTour__ = nil
    end
    node:setPosition(display.cx, display.height+20)
    node:setScale(self._originScale * 0.01)
    node:setRotation3D({x = 90, y = 60, z = -90})

    local move1 = cc.MoveTo:create(8.0, {x = display.cx, y = display.height*0.8})
    local scale1 = cc.ScaleTo:create(8.0, self._originScale * 0.2)
    local action1 = cc.Spawn:create(move1, scale1)

    local move2 = cc.MoveTo:create(7.0, {x = display.cx, y = display.cy})
    local scale2 = cc.ScaleTo:create(7.0, self._originScale * 1.2)
    local action2 = cc.Spawn:create(move2, scale2)

    local move3 = cc.MoveTo:create(3.0, {x = display.cx, y = display.height*0.1})
    local scale3 = cc.ScaleTo:create(3.0, self._originScale * 2.4)
    local action3 = cc.Spawn:create(move3, scale3)

    local move4 = cc.MoveTo:create(2.0, {x = display.cx, y = -500})
    local scale4 = cc.ScaleTo:create(2.0, self._originScale * 5.4)
    local action4 = cc.Spawn:create(move4, scale4)

    local callback = cc.CallFunc:create(function()
        if self._callback then
            if type(self._callback) == "function" then
                self._callback()
            else
                node:removeSelf()
            end
        end
    end)

    node.__actTour__ = transition.sequence({action1, action2, action3, action4, callback})
    node:runAction(node.__actTour__)
end

function M:tourPath3(node)

end

return M