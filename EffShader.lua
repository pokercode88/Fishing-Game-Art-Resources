--[[
着色器
]]

local M = class("EffShader")

function M:ctor()
    self:init()
end

function M:init()
	
end

------------------------------
--[[
设置灰度显示
@param node     Node        结点
@param enable   boolean     是否变灰
]]
function M:setGray(node, enable)
    if not node then return end
    if node.maskTID then
        if enable then
            self:setMaskGray(node)
        else
            self:setMask(node)
        end
    else
        self:setShader(node, enable, ENUM.DEFAULT.SHADER.shadow)
    end
end

local function _setShaderEnable(node)
    return node.getTexture or node.loadTexture or node.getSkeleton
end

--[[
设置结点着色
@param node     Node        结点
@param enable   boolean     是否着色
@param shader   string      着色器
]]
function M:setShader(node, enable, shader)
    if not node or node.getLetter then
        return
    end

    shader = enable and shader or "ShaderPositionTextureColor_noMVP"
    if node.getChildrenCount and node:getChildrenCount() > 0 then
        -- 遍历子结点
        if _setShaderEnable(node) then
            node:setGLProgram(cc.GLProgramCache:getInstance():getGLProgram(shader))
        end
        local t = node:getChildren()
        for _, var in pairs(t) do
            self:setShader(var, enable, shader)
        end
    else
        if _setShaderEnable(node) then
            node:setGLProgram(cc.GLProgramCache:getInstance():getGLProgram(shader))
        end
    end
end

--[[
设置遮罩 (黑白)
@param node     Node        结点
@param enable   boolean     是否变灰
]]
function M:setMask(node, mask)
    if not node then return end
    if type(mask) == "string" then
        local texture = textureCache:addImage(mask)
        node.maskTID = texture:getName()
    end

    local glprogram = cc.GLProgramCache:getInstance():getGLProgram(ENUM.DEFAULT.SHADER.shadow)
    local glprogramstate = cc.GLProgramState:getOrCreateWithGLProgram(glprogram)
    glprogramstate:setUniformTexture("u_mask_texture", node.maskTID)
    node:setGLProgramState(glprogramstate)
end

function M:setMaskGray(node, mask)
    if not node then return end
    if type(mask) == "string" then
        local texture = textureCache:addImage(mask)
        node.maskTID = texture:getName()
    end

    local glprogram = cc.GLProgramCache:getInstance():getGLProgram(ENUM.DEFAULT.SHADER.shadow)
    local glprogramstate = cc.GLProgramState:getOrCreateWithGLProgram(glprogram)
    glprogramstate:setUniformTexture("u_mask_texture", node.maskTID)
    node:setGLProgramState(glprogramstate)
end

return M