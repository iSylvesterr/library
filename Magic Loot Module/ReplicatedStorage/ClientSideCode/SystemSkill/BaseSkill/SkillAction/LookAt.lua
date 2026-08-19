-- Decompiled with Potassium's decompiler.

local SkillActionControl = require(script.Parent.Parent.SkillActionControl);
local HumanModule = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).HumanModule;
local LocalPlayer = game:GetService("Players").LocalPlayer;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = {
    isReleasePlayerOnly = true,
    playerSubjectOnly = true
};

local function isLocalPlayerCaster(p2) -- Line: 24
    -- upvalues: LocalPlayer (copy)
    if not (p2 and LocalPlayer) then
        return false;
    end;

    if p2.characterType == "Player" then
        return p2.characterId == LocalPlayer.UserId;
    end;

    return false;
end;

local function getDesiredLookTargetPos(p3) -- Line: 38
    -- upvalues: LocalPlayer (copy), ReplicatedStorage (copy)
    local Character = LocalPlayer.Character;

    if not (Character and Character:FindFirstChild("HumanoidRootPart")) then
        return nil;
    end;

    local Position = Character.HumanoidRootPart:GetPivot().Position;
    local NowTargetCurrent = ReplicatedStorage:FindFirstChild("NowTargetCurrent");

    if NowTargetCurrent and (NowTargetCurrent.Value and NowTargetCurrent.Value.Parent) then
        local Position2 = NowTargetCurrent.Value.Position;

        return Vector3.new(Position2.X, Position.Y, Position2.Z);
    end;

    if p3.skillInputData and p3.skillInputData.targetCF then
        local Position2 = p3.skillInputData.targetCF.Position;

        return Vector3.new(Position2.X, Position.Y, Position2.Z);
    end;

    local Position2 = LocalPlayer:GetMouse().Hit.Position;

    return Vector3.new(Position2.X, Position.Y, Position2.Z);
end;

function v1.Create(p4, p5) -- Line: 61
    -- upvalues: SkillActionControl (copy)
    p4.actionInfo = p5;
    p4.state = SkillActionControl.StateEnum.NoStart;
    p4.startTime = p4.actionInfo.startTime;
    p4.overTime = p4.actionInfo.overTime;
    p4.speedType = p4.actionInfo.speedType;
end;

function v1.Init(p6) -- Line: 69
    -- upvalues: SkillActionControl (copy)
    p6.state = SkillActionControl.StateEnum.NoStart;
end;

function v1.Run(p7, p8) -- Line: 73
    -- upvalues: SkillActionControl (copy), LocalPlayer (copy), getDesiredLookTargetPos (copy)
    if p7.state ~= SkillActionControl.StateEnum.Play then
        return;
    end;

    local Character = LocalPlayer.Character;

    if not (Character and Character:FindFirstChild("HumanoidRootPart")) then
        return;
    end;

    local v9 = getDesiredLookTargetPos(p7.baseSkill);

    if not v9 then
        return;
    end;

    if LocalPlayer:GetAttribute("IsShiftLocked") then
        return;
    end;

    local v10 = Character.HumanoidRootPart:GetPivot();

    if (v10.Position - v9).Magnitude <= 0.1 then
        return;
    end;

    local v11 = CFrame.lookAt(v10.Position, v9);
    local v12 = Character.HumanoidRootPart.CFrame:Lerp(v11, 0.25);
    Character.HumanoidRootPart.CFrame = CFrame.new(v10.Position) * v12.Rotation;
end;

function v1.Start(p13, p14) -- Line: 106
    -- upvalues: LocalPlayer (copy), HumanModule (copy)
    if p13.speedType then
        local baseSkill = p13.baseSkill;
        local v15;

        if baseSkill and LocalPlayer and baseSkill.characterType == "Player" then
            v15 = baseSkill.characterId == LocalPlayer.UserId;
        else
            v15 = false;
        end;

        if v15 then
            HumanModule.SetLocalPlayerSpeedAttribute(p13.speedType, true);
            HumanModule.UpdateLocalPlayerSpeed(0.1);
            local Character = LocalPlayer.Character;
            local v16 = Character and (not LocalPlayer:GetAttribute("IsShiftLocked") and Character:FindFirstChild("Humanoid"));

            if v16 then
                v16.AutoRotate = false;
            end;
        end;
    end;
end;

function v1.OnOver(p17, p18) -- Line: 122
    -- upvalues: LocalPlayer (copy), HumanModule (copy)
    if p17.speedType then
        local baseSkill = p17.baseSkill;
        local v19;

        if baseSkill and LocalPlayer and baseSkill.characterType == "Player" then
            v19 = baseSkill.characterId == LocalPlayer.UserId;
        else
            v19 = false;
        end;

        if v19 then
            HumanModule.SetLocalPlayerSpeedAttribute(p17.speedType, false);
            HumanModule.UpdateLocalPlayerSpeed(0.1);
            local Character = LocalPlayer.Character;
            local v20 = Character and Character:FindFirstChild("Humanoid");

            if v20 then
                v20.AutoRotate = true;
            end;
        end;
    end;
end;

return v1;