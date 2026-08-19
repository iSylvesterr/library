-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local RunService = game:GetService("RunService");
local v2 = UtilsSystem.WorldUtil.GetServerType();
local v3 = RunService:IsStudio();
local u4 = v2 == "开发服" or v3 == true;

function v1.print(...) -- Line: 38
    -- upvalues: u4 (ref)
    if u4 then
        print(...);
    end;
end;

function v1.warn(...) -- Line: 48
    -- upvalues: u4 (ref)
    if u4 then
        warn(...);
    end;
end;

function v1.printf(p5, ...) -- Line: 59
    -- upvalues: u4 (ref)
    if u4 then
        print(string.format(p5, ...));
    end;
end;

function v1.isDebug() -- Line: 69
    -- upvalues: u4 (ref)
    return u4;
end;

return v1;