-- Decompiled with Potassium's decompiler.

local v1 = {};
local TweenService = game:GetService("TweenService");
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
local Tween = Symbol.new("Tween");

local function ConvertValueToUnpackedTweens(p2) -- Line: 35
    -- upvalues: UnpackType (copy)
    local v3 = UnpackType(p2, (typeof(p2)));

    for i, v in v3 do
        v3[i] = {
            Position0 = v,
            Position1 = v,
            Tick0 = os.clock()
        };
    end;

    return v3;
end;

function v1.__call(p4, p5, u6) -- Line: 46
    -- upvalues: GetValue (copy), ConvertValueToUnpackedTweens (copy), Trove (copy), Signal (copy), Symbol (copy), UpdateSignals (copy), TweenService (copy), PackType (copy), IsValueChanged (copy), UnpackType (copy), StateManager (copy)
    local u7 = GetValue(p5);
    local u8 = typeof(u7);
    local u9 = ConvertValueToUnpackedTweens(u7);
    local u10 = Trove.new();
    local u11 = Signal.new();
    local u12 = Signal.new();
    local u13 = u7;
    local u14 = u7;
    local Tween2 = Symbol.new("Tween");
    u10:Add(UpdateSignals.OnFramePreUpdate:Connect(function() -- Line: 57
        -- upvalues: GetValue (ref), u6 (ref), u9 (ref), TweenService (ref), u13 (ref), PackType (ref), u8 (copy), IsValueChanged (ref), u14 (ref), u12 (copy)
        local v15 = GetValue(u6);
        local v16 = {};

        for i, v in u9 do
            local v17 = (os.clock() - v.Tick0) / v15.Time;
            local v18 = TweenService:GetValue(math.clamp(v17, 0, 1), v15.EasingStyle, v15.EasingDirection);
            local v19 = v.Position0 + (v.Position1 - v.Position0) * v18;

            if math.abs(v19) <= 0.001 then
                v19 = 0;
            elseif math.abs(v19 - v.Position0) <= 0.001 then
                v19 = v.Position0;
            end;

            v16[i] = v19;
        end;

        u13 = PackType(v16, u8);

        if IsValueChanged(u14, u13) then
            u12:Fire("Value");
        end;

        u14 = u13;
    end));
    local u20 = nil;
    u20 = setmetatable({
        Destroy = function() -- Line: 85, Name: Destroy
            -- upvalues: u9 (ref), u10 (ref)
            u9 = nil;
            u10:Destroy();
            u10 = nil;
        end
    }, {
        __index = function(p21, p22) -- Line: 91, Name: __index
            -- upvalues: Tween2 (copy), u13 (ref), u12 (copy), u11 (copy), u6 (ref)
            if p22 == "__SEAM_OBJECT" then
                return Tween2;
            end;

            if p22 == "Value" then
                return u13;
            end;

            if p22 == "Changed" then
                return u12;
            end;

            if p22 == "AttachedToInstance" then
                return u11;
            end;

            if p22 == "TweenInfo" then
                return u6;
            end;

            return nil;
        end,

        __newindex = function(p23, p24, p25) -- Line: 107, Name: __newindex
            -- upvalues: u7 (ref), GetValue (ref), UnpackType (ref), u8 (copy), u9 (ref), u6 (ref)
            if p24 == "Target" then
                u7 = GetValue(p25);
                local v26 = UnpackType(u7, u8);

                for i, v in u9 do
                    v.Position0 = v.Position1;
                    v.Position1 = v26[i];
                    v.Tick0 = os.clock();
                end;

                return;
            end;

            if p24 ~= "Value" then
                if p24 == "TweenInfo" then
                    u6 = p25;
                end;

                return;
            end;

            local v27 = UnpackType(p25, u8);

            for i, v in u9 do
                v.Position0 = v27[i];
                v.Position1 = v27[i];
                v.Tick0 = os.clock();
            end;
        end,

        __call = function(u28, p29, p30) -- Line: 131, Name: __call
            -- upvalues: u11 (copy), u10 (ref), StateManager (ref), u20 (ref)
            u11:Fire(p29);
            u10:Add(StateManager:AttachStateToObject(p29, {
                Value = function() -- Line: 135, Name: Value
                    -- upvalues: u28 (copy)
                    return u28.Value;
                end,

                PropertyName = p30
            }));

            return u20;
        end
    });

    if typeof(p5) == "table" and p5.__SEAM_OBJECT then
        p5(u20, "Target");
    end;

    return u20;
end;

function v1.__index(p31, p32) -- Line: 153
    -- upvalues: Tween (copy)
    if p32 == "__SEAM_OBJECT" then
        return Tween;
    end;

    return p32 == "__SEAM_CAN_BE_SCOPED" and true or nil;
end;

return setmetatable({}, v1);