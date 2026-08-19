-- Decompiled with Potassium's decompiler.

local v1 = {};
local Modules = script.Parent.Parent.Parent.Modules;
local StateManager = require(Modules.StateManager);
local Trove = require(Modules.Trove);
local Signal = require(Modules.Signal);
require(Modules.Types);
local Symbol = require(Modules.Symbol);
require(script.Parent.Value);
local GetValue = require(script.Parent.Parent.Utilities.GetValue);
local IsState = require(script.Parent.Parent.Utilities.IsState);
local Computed = Symbol.new("Computed");

function v1.__call(p2, u3) -- Line: 23
    -- upvalues: Trove (copy), Signal (copy), Symbol (copy), IsState (copy), GetValue (copy), StateManager (copy)
    local u4 = Trove.new();
    local u5 = Signal.new();
    local u6 = {};
    local u7 = nil;
    local u8 = false;
    local u9 = Signal.new();
    local ComputedInstance = Symbol.new("ComputedInstance");

    local function Use(p10) -- Line: 33
        -- upvalues: IsState (ref), u6 (copy), GetValue (ref), u4 (copy), u7 (ref), u3 (copy), Use (copy), u5 (copy)
        if p10 ~= nil and IsState(p10) then
            if u6[p10] ~= nil then
                return GetValue(u6[p10]);
            end;

            u6[p10] = p10;
            u4:Add(p10.Changed:Connect(function() -- Line: 43
                -- upvalues: u7 (ref), u3 (ref), Use (ref), u5 (ref)
                u7 = u3(Use);
                u5:Fire("Value", u7);
            end));
        end;

        return GetValue(p10);
    end;

    local u11 = nil;
    u11 = setmetatable({
        Destroy = function() -- Line: 53, Name: Destroy
            -- upvalues: u4 (copy)
            u4:Destroy();
        end
    }, {
        __call = function(p12, p13, p14) -- Line: 57, Name: __call
            -- upvalues: u9 (copy), u4 (copy), StateManager (ref), u8 (ref), u7 (ref), u3 (copy), Use (copy), u11 (ref)
            u9:Fire(p13);
            u4:Add(StateManager:AttachStateToObject(p13, {
                Value = function() -- Line: 61, Name: Value
                    -- upvalues: u8 (ref), u7 (ref), u3 (ref), Use (ref)
                    if not u8 then
                        u7 = u3(Use);
                        u8 = true;
                    end;

                    return u7;
                end,

                PropertyName = p14
            }));

            return u11;
        end,

        __index = function(p15, p16) -- Line: 79, Name: __index
            -- upvalues: ComputedInstance (copy), u8 (ref), u7 (ref), u3 (copy), Use (copy), u5 (copy), u9 (copy)
            if p16 == "__SEAM_OBJECT" then
                return ComputedInstance;
            end;

            if p16 == "Value" then
                if not u8 then
                    u7 = u3(Use);
                    u8 = true;
                end;

                return u7;
            end;

            if p16 == "Changed" then
                if not u8 then
                    u7 = u3(Use);
                    u8 = true;
                end;

                return u5;
            end;

            if p16 == "AttachedToInstance" then
                return u9;
            end;

            return nil;
        end
    });

    return u11;
end;

function v1.__index(p17, p18) -- Line: 111
    -- upvalues: Computed (copy)
    if p18 == "__SEAM_INDEX" then
        return Computed;
    end;

    return p18 == "__SEAM_CAN_BE_SCOPED" and true or nil;
end;

return setmetatable({}, v1);