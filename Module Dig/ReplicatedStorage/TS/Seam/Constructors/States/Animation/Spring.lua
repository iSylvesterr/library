-- Decompiled with Potassium's decompiler.

local v1 = {};
local Parent = script.Parent.Parent.Parent;
local Modules = Parent.Parent.Modules;
local GetValue = require(Parent.Utilities.GetValue);
local StateManager = require(Modules.StateManager);
local PackType = require(Modules.PackType);
local UnpackType = require(Modules.UnpackType);
local Trove = require(Modules.Trove);
local Signal = require(Modules.Signal);
require(Modules.Types);
local IsValueChanged = require(Modules.IsValueChanged);
local Symbol = require(Modules.Symbol);
local UpdateSignals = require(Modules.UpdateSignals);
local Spring = Symbol.new("Spring");

local function GetPositionAndVelocity(p2, p3, p4, p5, p6, p7) -- Line: 33
    local v8 = (os.clock() - p7) * p6;
    local v9 = p5 ^ 2;
    local v10, v11, v12;

    if v9 < 1 then
        v10 = (1 - v9) ^ 0.5;
        local v13 = math.exp(-p5 * v8) / v10;
        v11 = v13 * math.cos(v10 * v8);
        v12 = v13 * math.sin(v10 * v8);
    elseif v9 == 1 then
        v11 = math.exp(-p5 * v8);
        v12 = v11 * v8;
        v10 = 1;
    else
        v10 = (v9 - 1) ^ 0.5;
        v11 = math.exp((-p5 + v10) * v8) / (2 * v10) + math.exp((-p5 - v10) * v8) / (2 * v10);
        v12 = math.exp((-p5 + v10) * v8) / (2 * v10) - math.exp((-p5 - v10) * v8) / (2 * v10);
    end;

    local v14 = { v10 * v11 + p5 * v12, 1 - (v10 * v11 + p5 * v12), v12 / p6 };
    local v15 = { -p6 * v12, p6 * v12, v10 * v11 - p5 * v12 };

    return v14[1] * p2 + v14[2] * p4 + v14[3] * p3, v15[1] * p2 + v15[2] * p4 + v15[3] * p3;
end;

local function ConvertValueToUnpackedSprings(p16) -- Line: 83
    -- upvalues: UnpackType (copy)
    local v17 = UnpackType(p16, (typeof(p16)));

    for i, v in v17 do
        v17[i] = {
            Velocity = 0,
            StartingPosition = v,
            StartingTime = os.clock(),
            Target = v
        };
    end;

    return v17;
end;

function v1.__call(p18, p19, u20, u21) -- Line: 99
    -- upvalues: GetValue (copy), ConvertValueToUnpackedSprings (copy), Trove (copy), Signal (copy), Symbol (copy), UpdateSignals (copy), GetPositionAndVelocity (copy), PackType (copy), IsValueChanged (copy), UnpackType (copy), StateManager (copy)
    local u22 = GetValue(p19);
    local u23 = typeof(u22);
    local u24 = ConvertValueToUnpackedSprings(u22);
    local u25 = Trove.new();
    local u26 = Signal.new();
    local u27 = Signal.new();
    local u28 = u22;
    local u29 = u22;
    local Spring2 = Symbol.new("Spring");
    u25:Add(UpdateSignals.OnFramePreUpdate:Connect(function() -- Line: 110
        -- upvalues: u24 (ref), GetPositionAndVelocity (ref), GetValue (ref), u21 (ref), u20 (ref), u28 (ref), PackType (ref), u23 (copy), IsValueChanged (ref), u29 (ref), u27 (copy)
        local v30 = {};

        for i, v in u24 do
            local v31, _ = GetPositionAndVelocity(v.StartingPosition, v.Velocity, v.Target, GetValue(u21), GetValue(u20), v.StartingTime);

            if math.abs(v31) <= 0.001 then
                v31 = 0;
            elseif math.abs(v31 - v.Target) <= 0.001 then
                v31 = v.Target;
            end;

            v30[i] = v31;
        end;

        u28 = PackType(v30, u23);

        if IsValueChanged(u29, u28) then
            u27:Fire("Value");
        end;

        u29 = u28;
    end));
    local u32 = nil;
    u32 = setmetatable({
        Destroy = function() -- Line: 135, Name: Destroy
            -- upvalues: u24 (ref), u25 (ref)
            u24 = nil;
            u25:Destroy();
            u25 = nil;
        end
    }, {
        __index = function(p33, p34) -- Line: 141, Name: __index
            -- upvalues: Spring2 (copy), u28 (ref), u24 (ref), GetPositionAndVelocity (ref), GetValue (ref), u21 (ref), u20 (ref), PackType (ref), u23 (copy), u27 (copy), u26 (copy)
            if p34 == "__SEAM_OBJECT" then
                return Spring2;
            end;

            if p34 == "Value" then
                return u28;
            end;

            if p34 == "Velocity" then
                local v35 = {};

                for i, v in u24 do
                    local _, v36 = GetPositionAndVelocity(v.StartingPosition, v.Velocity, v.Target, GetValue(u21), GetValue(u20), v.StartingTime);
                    v35[i] = v36;
                end;

                return PackType(v35, u23);
            end;

            if p34 == "Changed" then
                return u27;
            end;

            if p34 == "AttachedToInstance" then
                return u26;
            end;

            if p34 == "Speed" then
                return u20;
            end;

            if p34 == "Dampening" then
                return u21;
            end;

            return nil;
        end,

        __newindex = function(p37, p38, p39) -- Line: 169, Name: __newindex
            -- upvalues: u22 (ref), GetValue (ref), UnpackType (ref), u23 (copy), u24 (ref), GetPositionAndVelocity (ref), u21 (ref), u20 (ref)
            if p38 == "Target" then
                u22 = GetValue(p39);
                local v40 = UnpackType(u22, u23);

                for i, v in u24 do
                    local v41, v42 = GetPositionAndVelocity(v.StartingPosition, v.Velocity, v.Target, GetValue(u21), GetValue(u20), v.StartingTime);
                    v.StartingPosition = v41;
                    v.Velocity = v42;
                    v.StartingTime = os.clock();
                    v.Target = v40[i];
                end;

                return;
            end;

            if p38 == "Value" then
                local v43 = UnpackType(p39, u23);

                for i, v in u24 do
                    local _, v44 = GetPositionAndVelocity(v.StartingPosition, v.Velocity, v.Target, GetValue(u21), GetValue(u20), v.StartingTime);
                    v.StartingPosition = v43[i];
                    v.Velocity = v44;
                    v.StartingTime = os.clock();
                end;

                return;
            end;

            if p38 == "Dampening" then
                u21 = p39;

                return;
            end;

            if p38 == "Speed" then
                u20 = p39;

                return;
            end;

            if p38 == "Velocity" then
                local v45 = UnpackType(p39, u23);

                for i, v in u24 do
                    local v46, _ = GetPositionAndVelocity(v.StartingPosition, v.Velocity, v.Target, GetValue(u21), GetValue(u20), v.StartingTime);
                    v.Velocity = v45[i];
                    v.StartingPosition = v46;
                    v.StartingTime = os.clock();
                end;
            end;
        end,

        __call = function(u47, p48, p49) -- Line: 210, Name: __call
            -- upvalues: u26 (copy), u25 (ref), StateManager (ref), u27 (copy), u32 (ref)
            u26:Fire(p48);
            u25:Add(StateManager:AttachStateToObject(p48, {
                Value = function() -- Line: 214, Name: Value
                    -- upvalues: u27 (ref), u47 (copy)
                    u27:Fire("Value");

                    return u47.Value;
                end,

                PropertyName = p49
            }));

            return u32;
        end
    });

    if typeof(p19) == "table" and p19.__SEAM_OBJECT then
        p19(u32, "Target");
    end;

    return u32;
end;

function v1.__index(p50, p51) -- Line: 233
    -- upvalues: Spring (copy)
    if p51 == "__SEAM_OBJECT" then
        return Spring;
    end;

    return p51 == "__SEAM_CAN_BE_SCOPED" and true or nil;
end;

return setmetatable({}, v1);