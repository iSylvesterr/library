-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AnimationModule = UtilsSystem.AnimationModule;
local ResRestore = UtilsSystem.ResRestore;
local ResourceUtil = UtilsSystem.ResourceUtil;
local u1 = {};

local function _preloadAnimations() -- Line: 55
    -- upvalues: AnimationModule (copy), ResRestore (copy)
    local v2 = AnimationModule.GetPreloadTable();

    if #v2 == 0 then
        return;
    end;

    ResRestore.PreloadAnimation(v2);
end;

local function _preloadConfiguredSkills() -- Line: 67
    -- upvalues: u1 (copy), ResourceUtil (copy)
    for _, v in u1 do
        if type(v) == "string" and v ~= "" then
            ResourceUtil.PreloadSkill(v);
        end;
    end;
end;

task.defer(function() -- Line: 78
    -- upvalues: AnimationModule (copy), ResRestore (copy), _preloadConfiguredSkills (copy)
    local v3 = AnimationModule.GetPreloadTable();

    if #v3 ~= 0 then
        ResRestore.PreloadAnimation(v3);
    end;

    _preloadConfiguredSkills();
end);