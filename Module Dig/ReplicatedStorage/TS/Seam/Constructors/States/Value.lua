-- Decompiled with Potassium's decompiler.

local v1 = {};
local Modules = script.Parent.Parent.Parent.Modules;
local StateManager = require(Modules.StateManager);
local Trove = require(Modules.Trove);
local Signal = require(Modules.Signal);
require(Modules.Types);
local IsValueChanged = require(Modules.IsValueChanged);
local Symbol = require(Modules.Symbol);
local Value = Symbol.new("Value");

local function GetAttendedTableValue(u2, u3) -- Line: 24
    -- upvalues: GetAttendedTableValue (copy), IsValueChanged (copy)
    if typeof(u2) ~= "table" then
        return u2;
    end;

    local u4 = {};

    local function CorrectFakeTable() -- Line: 36
        -- upvalues: u4 (copy), u2 (copy)
        local v5 = 1;

        for i, v in pairs(u4) do
            if i == v5 then
                v5 = v5 + 1;
                table.insert(u2, v);
            else
                u2[i] = v;
            end;

            u4[i] = nil;
        end;
    end;

    return setmetatable(u4, {
        __index = function(p6, p7) -- Line: 55, Name: __index
            -- upvalues: CorrectFakeTable (copy), GetAttendedTableValue (ref), u2 (copy), u3 (copy)
            CorrectFakeTable();

            return GetAttendedTableValue(u2[p7], u3);
        end,

        __newindex = function(p8, p9, p10) -- Line: 61, Name: __newindex
            -- upvalues: IsValueChanged (ref), u2 (copy), CorrectFakeTable (copy), u3 (copy)
            if IsValueChanged(u2[p9], p10) then
                CorrectFakeTable();
                u2[p9] = p10;
                u3:Fire("Value");
            end;
        end,

        __iter = function(p11) -- Line: 72, Name: __iter
            -- upvalues: CorrectFakeTable (copy), u2 (copy)
            CorrectFakeTable();

            return pairs(u2);
        end,

        __len = function(p12) -- Line: 78, Name: __len
            -- upvalues: CorrectFakeTable (copy), u2 (copy)
            CorrectFakeTable();

            return #u2;
        end,

        __tostring = function(p13) -- Line: 84, Name: __tostring
            -- upvalues: CorrectFakeTable (copy)
            CorrectFakeTable();

            return "SEAM_PROXY_TABLE (if you see this, try reading the value with Value.ValueRaw or GetValue(Value) instead when using tables)";
        end
    });
end;

local function DeepCopyTable(p14) -- Line: 94
    -- upvalues: DeepCopyTable (copy)
    local v15 = {};

    for i, v in p14 do
        if typeof(v) == "table" and not (v.__SEAM_INDEX or v.__SEAM_OBJECT) then
            v15[i] = DeepCopyTable(v);
        else
            v15[i] = v;
        end;
    end;

    return v15;
end;

function v1.__call(p16, p17) -- Line: 109
    -- upvalues: Trove (copy), Signal (copy), Symbol (copy), GetAttendedTableValue (copy), DeepCopyTable (copy), IsValueChanged (copy), StateManager (copy)
    local u18 = Trove.new();
    local u19 = Signal.new();
    local u20 = Signal.new();
    local Value2 = Symbol.new("Value");
    local u21 = false;
    local u22;

    if p17 == nil then
        u22 = nil;
    else
        u22 = typeof(p17);
    end;

    if u22 == "table" then
        p17 = table.clone(p17);
    end;

    local u23 = GetAttendedTableValue(p17, u19);
    local u24 = nil;
    u24 = setmetatable({
        Destroy = function(p25) -- Line: 132, Name: Destroy
            -- upvalues: u18 (copy)
            u18:Destroy();
        end
    }, {
        __index = function(p26, p27) -- Line: 136, Name: __index
            -- upvalues: Value2 (copy), u23 (ref), u22 (ref), DeepCopyTable (ref), u19 (copy), u20 (copy)
            if p27 == "__SEAM_OBJECT" then
                return Value2;
            end;

            if p27 == "Value" then
                return u23;
            end;

            if p27 == "ValueRaw" then
                if u22 == "table" then
                    return DeepCopyTable(u23);
                end;

                return u23;
            end;

            if p27 == "Changed" then
                return u19;
            end;

            if p27 == "AttachedToInstance" then
                return u20;
            end;

            return nil;
        end,

        __newindex = function(p28, p29, p30) -- Line: 158, Name: __newindex
            -- upvalues: u22 (ref), u21 (ref), u23 (ref), IsValueChanged (ref), u19 (copy), u24 (ref), Value2 (copy)
            if p29 == "Value" then
                if u22 == nil then
                    u22 = typeof(p30);
                elseif p30 ~= nil and typeof(p30) ~= u22 then
                    error("Invalid value type! Expected " .. u22 .. ", got " .. typeof(p30));
                end;

                if u21 then
                    error("Attempt to modify value when locked.");
                end;

                if u22 == "table" then
                    for i, _ in u23 do
                        if p30[i] == nil then
                            u23[i] = nil;
                        end;
                    end;

                    for i, v in p30 do
                        u23[i] = v;
                    end;
                else
                    if not IsValueChanged(u23, p30) then
                        return;
                    end;

                    u23 = p30;
                end;

                u19:Fire("Value", u23);

                return;
            end;

            if p29 ~= "__LOCKED" then
                if p29 == "__SEAM_OBJECT" then
                    return Value2;
                end;

                error("Ran into an unexpected error");

                return;
            end;

            if p30 ~= true then
                error("Can not unlock values.");

                return;
            end;

            u21 = true;
            u24:Destroy();
        end,

        __call = function(p31, p32, p33) -- Line: 212, Name: __call
            -- upvalues: u23 (ref), DeepCopyTable (ref), u20 (copy), u18 (copy), StateManager (ref)
            if not p32 then
                return;
            end;

            if not p33 then
                return;
            end;

            if typeof(u23) == "table" then
                p32[p33] = DeepCopyTable(u23);
            else
                p32[p33] = u23;
            end;

            u20:Fire(p32);
            u18:Add(StateManager:AttachStateToObject(p32, {
                Value = function() -- Line: 230, Name: Value
                    -- upvalues: u23 (ref), DeepCopyTable (ref)
                    if typeof(u23) == "table" then
                        return DeepCopyTable(u23);
                    end;

                    return u23;
                end,

                PropertyName = p33
            }));
        end
    });

    return u24;
end;

function v1.__index(p34, p35) -- Line: 246
    -- upvalues: Value (copy)
    if p35 == "__SEAM_INDEX" then
        return Value;
    end;

    return p35 == "__SEAM_CAN_BE_SCOPED" and true or nil;
end;

return setmetatable({}, v1);