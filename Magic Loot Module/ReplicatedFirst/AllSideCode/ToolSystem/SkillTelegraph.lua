-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local SkillTelegraphConfig = require(script.SkillTelegraphConfig);
local SkillTelegraphInstance = require(script.SkillTelegraphInstance);
local u1 = {};
local u2 = {
    update = function() -- Line: 61, Name: update
    end,

    setWarnDuration = function() -- Line: 62, Name: setWarnDuration
    end,

    activate = function() -- Line: 63, Name: activate
    end,

    destroy = function() -- Line: 64, Name: destroy
    end
};

local function _isBossCaster(p3) -- Line: 73
    if not p3 then
        return false;
    end;

    local HumanoidRootPart = p3:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and (HumanoidRootPart:IsA("BasePart") and HumanoidRootPart:GetAttribute("Boss") == true) then
        return true;
    end;

    local PrimaryPart = p3.PrimaryPart;

    return PrimaryPart and PrimaryPart:GetAttribute("Boss") == true and true or p3:GetAttribute("Boss") == true;
end;

function u1.isEnabled(p4, p5) -- Line: 95
    -- upvalues: SkillTelegraphConfig (copy), _isBossCaster (copy)
    if not p4 then
        return false;
    end;

    if SkillTelegraphConfig.ENABLED_CHARACTER_TYPES[p4] == true then
        return p4 ~= "NPC" and true or _isBossCaster(p5);
    end;

    return false;
end;

function u1.new(p6) -- Line: 114
    -- upvalues: RunService (copy), u2 (copy), u1 (copy), SkillTelegraphInstance (copy)
    if not RunService:IsClient() then
        return u2;
    end;

    if p6.forceEnabled or u1.isEnabled(p6.characterType, p6.casterCharacter) then
        return SkillTelegraphInstance.new({
            shape = p6.shape,
            worldCFrame = p6.worldCFrame,
            hitboxSize = p6.hitboxSize,
            warnDuration = p6.warnDuration,
            activeDuration = p6.activeDuration,
            skipGroundAlign = p6.skipGroundAlign
        });
    end;

    return u2;
end;

u1.AIM_RUN_EVENT_KEY = "damageTelegraphAim";

function u1.destroyAllInRunData(p7) -- Line: 140
    -- upvalues: RunService (copy), u1 (copy)
    if not (RunService:IsClient() and p7) then
        return;
    end;

    local runEvent = p7.runEvent;
    local u8 = runEvent and runEvent[u1.AIM_RUN_EVENT_KEY];

    if u8 then
        pcall(function() -- Line: 148
            -- upvalues: u8 (copy)
            if typeof(u8) == "RBXScriptConnection" then
                u8:Disconnect();
            end;
        end);
        runEvent[u1.AIM_RUN_EVENT_KEY] = nil;
    end;

    local Logic = p7.Logic;

    if not Logic then
        return;
    end;

    local dangerTelegraph = Logic.dangerTelegraph;

    if dangerTelegraph and dangerTelegraph.destroy then
        dangerTelegraph:destroy();
    end;

    Logic.dangerTelegraph = nil;
    local dangerTelegraphs = Logic.dangerTelegraphs;

    if dangerTelegraphs then
        for i, v in dangerTelegraphs do
            if v and v.destroy then
                v:destroy();
            end;

            dangerTelegraphs[i] = nil;
        end;

        Logic.dangerTelegraphs = nil;
    end;
end;

return u1;