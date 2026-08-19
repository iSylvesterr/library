-- Decompiled with Potassium's decompiler.

local SkillActionControl = require(script.Parent.Parent.SkillActionControl);
local _ = game:GetService("Players").LocalPlayer;
local v3 = {
    isReleasePlayerOnly = true,

    Create = function(p1, p2) -- Line: 17, Name: Create
        -- upvalues: SkillActionControl (copy)
        p1.actionInfo = p2;
        p1.state = SkillActionControl.StateEnum.NoStart;
        p1.startTime = p1.actionInfo.startTime;
        p1.overTime = p1.actionInfo.overTime;
        p1.speedMultiplier = p1.actionInfo.speedMultiplier or 0;
        p1.saveOriginalSpeed = p1.actionInfo.saveOriginalSpeed ~= false;
        p1.originalWalkSpeed = nil;
        p1.directionConfig = p1.actionInfo.directionConfig or {};
    end
};

local function getDirectionParams(p4, p5) -- Line: 37
    local v6 = {
        overTime = p4.actionInfo.overTime,
        speedMultiplier = p4.actionInfo.speedMultiplier or 0,
        saveOriginalSpeed = p4.actionInfo.saveOriginalSpeed ~= false
    };
    local v7 = p4.directionConfig[p5];

    if v7 then
        for i, v in pairs(v7) do
            if v ~= nil then
                v6[i] = v;
            end;
        end;
    end;

    return v6;
end;

function v3.Init(p8) -- Line: 54
    -- upvalues: SkillActionControl (copy)
    p8.state = SkillActionControl.StateEnum.NoStart;
    p8.originalWalkSpeed = nil;
end;

function v3.Run(p9, p10) -- Line: 59
end;

function v3.Start(p11, p12) -- Line: 63
    -- upvalues: getDirectionParams (copy)
    local character = p11.baseSkill.character;

    if not character then
        return;
    end;

    local v13 = character:FindFirstChildOfClass("Humanoid");

    if not v13 then
        return;
    end;

    local v14 = p11.baseSkill.skillInputData and p11.baseSkill.skillInputData.moveDirectionStr;
    local v15 = getDirectionParams(p11, type(v14) ~= "string" and "Forward" or v14);
    p11.overTime = v15.overTime;
    p11.saveOriginalSpeed = v15.saveOriginalSpeed;
    local speedMultiplier = v15.speedMultiplier;

    if p11.saveOriginalSpeed then
        p11.originalWalkSpeed = v13.WalkSpeed;
    end;

    if speedMultiplier == 0 then
        v13.WalkSpeed = 0;

        return;
    end;

    v13.WalkSpeed = (p11.originalWalkSpeed or 16) * speedMultiplier;
end;

function v3.OnOver(p16, p17) -- Line: 101
    local v18 = p16.baseSkill and p16.baseSkill.character;

    if not v18 then
        return;
    end;

    local v19 = v18:FindFirstChildOfClass("Humanoid");

    if not v19 then
        return;
    end;

    if p16.saveOriginalSpeed and p16.originalWalkSpeed then
        v19.WalkSpeed = p16.originalWalkSpeed;

        return;
    end;

    v19.WalkSpeed = 16;
end;

return v3;