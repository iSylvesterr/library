-- Decompiled with Potassium's decompiler.

local v1 = {};
local Modules = script.Parent.Parent.Parent.Modules;
local StateManager = require(Modules.StateManager);
local Trove = require(Modules.Trove);
local Signal = require(Modules.Signal);
require(Modules.Types);
local Symbol = require(Modules.Symbol);
local Rendered = Symbol.new("Rendered");

function v1.__call(p2, u3) -- Line: 20
    -- upvalues: Trove (copy), Signal (copy), Symbol (copy), StateManager (copy)
    local u4 = Trove.new();
    local u5 = Signal.new();
    local RenderedInstance = Symbol.new("RenderedInstance");
    local u6 = os.clock();

    local function u8() -- Line: 27
        -- upvalues: u6 (ref), u3 (copy)
        local v7 = os.clock() - u6;
        u6 = os.clock();

        return u3(v7);
    end;

    local u9 = nil;
    u9 = setmetatable({
        Destroy = function() -- Line: 35, Name: Destroy
            -- upvalues: u4 (copy)
            u4:Destroy();
        end
    }, {
        __call = function(p10, p11, p12) -- Line: 39, Name: __call
            -- upvalues: u5 (copy), u4 (copy), StateManager (ref), u8 (copy), u9 (ref)
            u5:Fire(p11);
            u4:Add(StateManager:AttachStateToObject(p11, {
                Value = u8,
                PropertyName = p12
            }));

            return u9;
        end,

        __index = function(p13, p14) -- Line: 50, Name: __index
            -- upvalues: RenderedInstance (copy), u8 (copy), u5 (copy)
            if p14 == "__SEAM_OBJECT" then
                return RenderedInstance;
            end;

            if p14 == "Value" then
                return u8();
            end;

            if p14 == "AttachedToInstance" then
                return u5;
            end;

            return nil;
        end
    });

    return u9;
end;

function v1.__index(p15, p16) -- Line: 66
    -- upvalues: Rendered (copy)
    if p16 == "__SEAM_INDEX" then
        return Rendered;
    end;

    return p16 == "__SEAM_CAN_BE_SCOPED" and true or nil;
end;

return setmetatable({}, v1);