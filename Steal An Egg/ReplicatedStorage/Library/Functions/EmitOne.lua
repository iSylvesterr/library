-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Variables = require(game.ReplicatedStorage.Library.Variables);

function EmitOne(u1, p2)
    -- upvalues: Asserts (copy), Constants (copy), Variables (copy)
    local TimeScale = u1.TimeScale;

    if TimeScale < 0 then
        return 0;
    end;

    local v3 = u1:GetAttribute("EmitCount") or u1.Rate;
    Asserts.number(v3);
    local v4 = v3 - math.floor(v3);
    local u5 = math.floor(v3);

    if v4 > 0 and math.random() < v4 then
        u5 = u5 + 1;
    end;

    if (p2 and Constants.IS_MOBILE or Variables.PotatoMode) and u5 > 1 then
        local v6 = typeof(p2) == "number" and p2 and p2 or 0.1;
        u5 = math.max(u5 * v6, 1);
    end;

    if u5 < 1 then
        return 0;
    end;

    local v7 = u1:GetAttribute("EmitDelay") or 0;

    if v7 == (1 / 0) then
        return 0;
    end;

    Asserts.number(v7);
    local v8 = math.max(v7, 0);
    task.delay(v8, function() -- Line: 53
        -- upvalues: u1 (copy), u5 (ref)
        u1:Emit(u5);
    end);

    return v8 + u1.Lifetime.Max / TimeScale;
end;

return EmitOne;