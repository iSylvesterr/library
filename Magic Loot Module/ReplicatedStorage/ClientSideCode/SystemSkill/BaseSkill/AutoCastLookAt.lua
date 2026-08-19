-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local RunService = UtilsSystem.RunService;
local ReplicatedStorage = UtilsSystem.ReplicatedStorage;
local LocalPlayer = UtilsSystem.LocalPlayer;
local v1 = {};
local u2 = false;
local u3 = false;
local u4 = nil;
local u5 = nil;

local function _getDesiredLookTargetPos() -- Line: 41
    -- upvalues: LocalPlayer (copy), ReplicatedStorage (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return nil;
    end;

    local Position = HumanoidRootPart:GetPivot().Position;
    local NowTargetCurrent = ReplicatedStorage:FindFirstChild("NowTargetCurrent");

    if NowTargetCurrent and NowTargetCurrent:IsA("ObjectValue") then
        local Value = NowTargetCurrent.Value;

        if Value and Value.Parent then
            local Position2 = Value.Position;

            return Vector3.new(Position2.X, Position.Y, Position2.Z);
        end;
    end;

    return nil;
end;

local function _setHumanoidAutoRotate(p6) -- Line: 67
    -- upvalues: LocalPlayer (copy)
    if LocalPlayer:GetAttribute("IsShiftLocked") then
        return;
    end;

    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    local Humanoid = Character:FindFirstChild("Humanoid");

    if Humanoid and Humanoid:IsA("Humanoid") then
        Humanoid.AutoRotate = p6;
    end;
end;

local function _setActive(p7) -- Line: 85
    -- upvalues: u2 (ref), LocalPlayer (copy)
    if u2 == p7 then
        return;
    end;

    u2 = p7;

    if p7 then
        if LocalPlayer:GetAttribute("IsShiftLocked") then
            return;
        end;

        local Character = LocalPlayer.Character;

        if not Character then
            return;
        end;

        local Humanoid = Character:FindFirstChild("Humanoid");

        if Humanoid and Humanoid:IsA("Humanoid") then
            Humanoid.AutoRotate = false;
        end;
    else
        if LocalPlayer:GetAttribute("IsShiftLocked") then
            return;
        end;

        local Character = LocalPlayer.Character;

        if not Character then
            return;
        end;

        local Humanoid = Character:FindFirstChild("Humanoid");

        if Humanoid and Humanoid:IsA("Humanoid") then
            Humanoid.AutoRotate = true;
        end;
    end;
end;

local function _tickLookAt() -- Line: 100
    -- upvalues: LocalPlayer (copy), _getDesiredLookTargetPos (copy)
    if LocalPlayer:GetAttribute("IsShiftLocked") then
        return;
    end;

    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return;
    end;

    local v8 = _getDesiredLookTargetPos();

    if not v8 then
        return;
    end;

    local v9 = HumanoidRootPart:GetPivot();

    if (v9.Position - v8).Magnitude <= 0.1 then
        return;
    end;

    local v10 = CFrame.lookAt(v9.Position, v8);
    local v11 = HumanoidRootPart.CFrame:Lerp(v10, 0.25);
    HumanoidRootPart.CFrame = CFrame.new(v9.Position) * v11.Rotation;
end;

local function _onHeartbeat() -- Line: 132
    -- upvalues: u4 (ref), _getDesiredLookTargetPos (copy), u2 (ref), LocalPlayer (copy), _tickLookAt (copy)
    if not u4 then
        return;
    end;

    local v12 = u4();

    if v12 and not _getDesiredLookTargetPos() then
        v12 = false;
    end;

    if u2 ~= v12 then
        u2 = v12;

        if v12 then
            local v13 = not LocalPlayer:GetAttribute("IsShiftLocked") and LocalPlayer.Character;

            if v13 then
                local Humanoid = v13:FindFirstChild("Humanoid");

                if Humanoid and Humanoid:IsA("Humanoid") then
                    Humanoid.AutoRotate = false;
                end;
            end;
        else
            local v14 = not LocalPlayer:GetAttribute("IsShiftLocked") and LocalPlayer.Character;

            if v14 then
                local Humanoid = v14:FindFirstChild("Humanoid");

                if Humanoid and Humanoid:IsA("Humanoid") then
                    Humanoid.AutoRotate = true;
                end;
            end;
        end;
    end;

    if u2 then
        _tickLookAt();
    end;
end;

function v1.shouldSuppressSkillLookAt() -- Line: 152
    -- upvalues: u2 (ref)
    return u2;
end;

function v1.isActive() -- Line: 160
    -- upvalues: u2 (ref)
    return u2;
end;

function v1.start(p15) -- Line: 168
    -- upvalues: u3 (ref), u4 (ref), _getDesiredLookTargetPos (copy), u2 (ref), LocalPlayer (copy), _tickLookAt (copy), u5 (ref), RunService (copy), _onHeartbeat (copy)
    if u3 then
        return;
    end;

    u3 = true;
    u4 = p15;

    if u4 then
        local v16 = u4();

        if v16 and not _getDesiredLookTargetPos() then
            v16 = false;
        end;

        if u2 ~= v16 then
            u2 = v16;

            if v16 then
                local v17 = not LocalPlayer:GetAttribute("IsShiftLocked") and LocalPlayer.Character;

                if v17 then
                    local Humanoid = v17:FindFirstChild("Humanoid");

                    if Humanoid and Humanoid:IsA("Humanoid") then
                        Humanoid.AutoRotate = false;
                    end;
                end;
            else
                local v18 = not LocalPlayer:GetAttribute("IsShiftLocked") and LocalPlayer.Character;

                if v18 then
                    local Humanoid = v18:FindFirstChild("Humanoid");

                    if Humanoid and Humanoid:IsA("Humanoid") then
                        Humanoid.AutoRotate = true;
                    end;
                end;
            end;
        end;

        if u2 then
            _tickLookAt();
        end;
    end;

    u5 = RunService.Heartbeat:Connect(_onHeartbeat);
end;

function v1.stop() -- Line: 181
    -- upvalues: u5 (ref), u3 (ref), u4 (ref), u2 (ref), LocalPlayer (copy)
    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;

    u3 = false;
    u4 = nil;

    if u2 == false then
        return;
    end;

    u2 = false;

    if LocalPlayer:GetAttribute("IsShiftLocked") then
        return;
    end;

    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    local Humanoid = Character:FindFirstChild("Humanoid");

    if Humanoid and Humanoid:IsA("Humanoid") then
        Humanoid.AutoRotate = true;
    end;
end;

return v1;