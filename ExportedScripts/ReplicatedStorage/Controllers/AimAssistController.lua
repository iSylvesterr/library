-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local DataController = require(ReplicatedStorage.Controllers.DataController);
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local v2 = GetUserPlatform();
local u3;

if table.find(v2, "Mobile") == nil then
    u3 = false;
else
    u3 = #v2 <= 1;
end;

local GamepadEnabled = UserInputService.GamepadEnabled;
local v4;

if table.find(v2, "Console") == nil then
    v4 = false;
else
    v4 = table.find(v2, "PC") == nil;
end;

local v5 = table.find(Constants.AIM_ASSIST_WHITELIST, LocalPlayer.UserId) ~= nil;
local u6;

if u3 then
    u6 = u3;
elseif GamepadEnabled then
    u6 = v4 or v5;
else
    u6 = v5;
end;

local CurrentCamera = Workspace.CurrentCamera;
local u7 = false;
local u8 = v5 and Constants.AIM_ASSIST_CONFIGS.DEVELOPER or Constants.AIM_ASSIST_CONFIGS.PLAYER;

local function doesRaycastIntersectSmoke(p9, p10, p11) -- Line: 49
    -- upvalues: Workspace (copy)
    local function rayIntersectsAABB(p12, p13, p14, p15, p16) -- Line: 50
        local v17 = 0;
        local v18, v19;

        if math.abs(p13.X) < 0.0001 then
            if p12.X < p14.X or p12.X > p15.X then
                return false;
            end;

            v18 = p16;
            v19 = v17;
        else
            local v20 = 1 / p13.X;
            v18 = (p14.X - p12.X) * v20;
            v19 = (p15.X - p12.X) * v20;

            if v19 >= v18 then
                local v21 = v18;
                v18 = v19;
                v19 = v21;
            end;

            if v17 >= v19 then
                v19 = v17;
            end;

            if v18 >= p16 then
                v18 = p16;
            end;

            if v18 < v19 then
                return false;
            end;
        end;

        if math.abs(p13.Y) < 0.0001 then
            if p12.Y < p14.Y or p12.Y > p15.Y then
                return false;
            end;
        else
            local v22 = 1 / p13.Y;
            local v23 = (p14.Y - p12.Y) * v22;
            local v24 = (p15.Y - p12.Y) * v22;

            if v24 >= v23 then
                local v25 = v23;
                v23 = v24;
                v24 = v25;
            end;

            if v19 >= v24 then
                v24 = v19;
            end;

            if v23 >= v18 then
                v23 = v18;
            end;

            if v23 < v24 then
                return false;
            end;

            v18 = v23;
            v19 = v24;
        end;

        if math.abs(p13.Z) < 0.0001 then
            if p12.Z < p14.Z or p12.Z > p15.Z then
                return false;
            end;
        else
            local v26 = 1 / p13.Z;
            local v27 = (p14.Z - p12.Z) * v26;
            local v28 = (p15.Z - p12.Z) * v26;

            if v28 >= v27 then
                local v29 = v27;
                v27 = v28;
                v28 = v29;
            end;

            if v19 >= v28 then
                v28 = v19;
            end;

            if v27 >= v18 then
                v27 = v18;
            end;

            if v27 < v28 then
                return false;
            end;

            v19 = v28;
        end;

        local v30;

        if v19 >= 0 then
            v30 = v19 <= p16;
        else
            v30 = false;
        end;

        return v30;
    end;

    local Debris = Workspace:FindFirstChild("Debris");

    if not Debris then
        return false;
    end;

    for _, child in ipairs(Debris:GetChildren()) do
        if child.Name:match("^VoxelSmoke_") and child:IsA("Folder") then
            for _, child2 in ipairs(child:GetChildren()) do
                if child2:IsA("BasePart") and child2.Name == "SmokeVoxel" then
                    local Size = child2.Size;
                    local Position = child2.Position;

                    if rayIntersectsAABB(p9, p10, Position - Size / 2, Position + Size / 2, p11) then
                        return true;
                    end;
                end;
            end;
        end;
    end;

    return false;
end;

local function isEnemyValid(p31, p32) -- Line: 110
    if not (p31 and p32) then
        return false;
    end;

    local v33 = p31:GetAttribute("Team");
    local v34 = p32:GetAttribute("Team");

    if not (v33 and v34) then
        return false;
    end;

    local v35 = {
        ["Counter-Terrorists"] = true,
        Terrorists = true
    };

    if v35[v33] and v35[v34] then
        return workspace:GetAttribute("Gamemode") == "Deathmatch" and true or v33 ~= v34;
    end;

    return false;
end;

local function getTargetCenterPosition(p36) -- Line: 149
    return not (p36 and p36.PrimaryPart) and Vector3.new(0, 0, 0) or p36.PrimaryPart.Position;
end;

local function getTargetHeadPosition(p37) -- Line: 160
    local Head = p37:FindFirstChild("Head");

    if Head then
        return Head.Position;
    end;

    return nil;
end;

local function getAngleToTarget(p38, p39) -- Line: 170
    local v40 = p38.LookVector:Dot((p39 - p38.Position).Unit);
    local v41 = math.clamp(v40, -1, 1);

    return math.acos(v41);
end;

local function isTargetVisible(p42, p43) -- Line: 184
    -- upvalues: doesRaycastIntersectSmoke (copy), LocalPlayer (copy), Workspace (copy)
    if not (p42 and p42.PrimaryPart) then
        return false;
    end;

    local v44 = not (p42 and p42.PrimaryPart) and Vector3.new(0, 0, 0) or p42.PrimaryPart.Position;
    local Unit = (v44 - p43).Unit;
    local Magnitude = (v44 - p43).Magnitude;

    if doesRaycastIntersectSmoke(p43, Unit, Magnitude) then
        return false;
    end;

    local v45 = RaycastParams.new();
    v45.FilterType = Enum.RaycastFilterType.Exclude;
    v45.FilterDescendantsInstances = { LocalPlayer.Character };
    local v46 = Workspace:Raycast(p43, Unit * Magnitude, v45);

    return not v46 and true or (p42:IsAncestorOf(v46.Instance) and true or false);
end;

local function findBestTarget(p47) -- Line: 221
    -- upvalues: Players (copy), LocalPlayer (copy), isEnemyValid (copy), u8 (copy), isTargetVisible (copy)
    local v48 = 0;
    local v49 = nil;

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and isEnemyValid(LocalPlayer, v) then
            local Character = v.Character;

            if Character and Character.PrimaryPart then
                local v50 = Character:FindFirstChildOfClass("Humanoid");

                if v50 and (v50.Health > 0 and Character:GetAttribute("Dead") ~= true) then
                    local v51 = not (Character and Character.PrimaryPart) and Vector3.new(0, 0, 0) or Character.PrimaryPart.Position;
                    local Position = p47.Position;
                    local Magnitude = (v51 - Position).Magnitude;

                    if u8.TargetSelection.MaxDistance >= Magnitude then
                        local v52 = p47.LookVector:Dot((v51 - p47.Position).Unit);
                        local v53 = math.clamp(v52, -1, 1);
                        local v54 = math.acos(v53);

                        if u8.TargetSelection.MaxAngle >= v54 and isTargetVisible(Character, Position) then
                            local v55 = 1 / (Magnitude + 1) * (1 - v54 / u8.TargetSelection.MaxAngle);

                            if v48 < v55 then
                                v49 = Character;
                                v48 = v55;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return v49;
end;

local function calculateFrictionMultiplier(p56, p57) -- Line: 289
    -- upvalues: u8 (copy), CurrentCamera (copy)
    if not (u8.Friction.Enabled and p57) then
        return u8.Friction.MaxSensitivity;
    end;

    if not (CurrentCamera and p57.PrimaryPart) then
        return u8.Friction.MaxSensitivity;
    end;

    local v58 = not (p57 and p57.PrimaryPart) and Vector3.new(0, 0, 0) or p57.PrimaryPart.Position;
    local Position = p56.Position;
    local v59, v60 = CurrentCamera:WorldToViewportPoint(v58);

    if not v60 or v59.Z < 0 then
        return u8.Friction.MaxSensitivity;
    end;

    local v61 = CurrentCamera.ViewportSize / 2;
    local v62 = Vector2.new(v61.X, v61.Y);
    local Magnitude = (Vector2.new(v59.X, v59.Y) - v62).Magnitude;
    local Magnitude2 = (v58 - Position).Magnitude;
    local v63 = 2 / Magnitude2 * v61.Y * 2;
    local v64 = u8.Friction.BubbleRadius * (v61.Y / Magnitude2) * 2;

    if v64 + v63 / 2 < Magnitude then
        return u8.Friction.MaxSensitivity;
    end;

    if math.max(0, Magnitude - v63 / 2) <= v64 then
        return u8.Friction.MinSensitivity;
    end;

    return u8.Friction.MaxSensitivity;
end;

function v1.IsEnabled() -- Line: 348
    -- upvalues: u7 (ref)
    return u7;
end;

function v1.SetEnabled(p65) -- Line: 354
    -- upvalues: u7 (ref)
    u7 = p65;
end;

function v1.GetBestTarget() -- Line: 360
    -- upvalues: u6 (copy), u7 (ref), u8 (copy), FlashEffect (copy), CurrentCamera (copy), LocalPlayer (copy), findBestTarget (copy)
    if not u6 then
        return nil;
    end;

    if not (u7 and u8.TargetSelection.Enabled) then
        return nil;
    end;

    if FlashEffect.IsFlashed() then
        return nil;
    end;

    if CurrentCamera and LocalPlayer.Character then
        return findBestTarget(CurrentCamera.CFrame);
    end;

    return nil;
end;

function v1.GetFrictionMultiplier() -- Line: 384
    -- upvalues: u6 (copy), u8 (copy), u7 (ref), FlashEffect (copy), CurrentCamera (copy), LocalPlayer (copy), findBestTarget (copy), calculateFrictionMultiplier (copy)
    if not u6 then
        return u8.Friction.MaxSensitivity;
    end;

    if not (u7 and u8.Friction.Enabled) then
        return u8.Friction.MaxSensitivity;
    end;

    if FlashEffect.IsFlashed() then
        return u8.Friction.MaxSensitivity;
    end;

    if not (CurrentCamera and LocalPlayer.Character) then
        return u8.Friction.MaxSensitivity;
    end;

    local CFrame2 = CurrentCamera.CFrame;

    return calculateFrictionMultiplier(CFrame2, (findBestTarget(CFrame2)));
end;

local function findTargetWithRaycast(p66) -- Line: 411
    -- upvalues: u8 (copy), LocalPlayer (copy), Workspace (copy), Players (copy), isEnemyValid (copy), doesRaycastIntersectSmoke (copy)
    local Position = p66.Position;
    local MaxDistance = u8.Magnetism.MaxDistance;
    local v67 = RaycastParams.new();
    v67.FilterType = Enum.RaycastFilterType.Exclude;
    v67.FilterDescendantsInstances = { LocalPlayer.Character };
    local v68 = u8.Magnetism.MaxAngleHorizontal / 2;
    local v69 = u8.Magnetism.MaxAngleVertical / 2;

    for i = -1, 1 do
        for i2 = -1, 1 do
            local LookVector = (p66 * CFrame.Angles(i2 * v69, i * v68, 0)).LookVector;
            local v70 = Workspace:Raycast(Position, LookVector * MaxDistance, v67);

            if v70 then
                local v71 = v70.Instance:FindFirstAncestorOfClass("Model");

                if v71 and v71:FindFirstChildOfClass("Humanoid") then
                    local v72 = Players:GetPlayerFromCharacter(v71);

                    if v72 and isEnemyValid(LocalPlayer, v72) then
                        local v73 = v71:FindFirstChildOfClass("Humanoid");

                        if v73 and (v73.Health > 0 and v71:GetAttribute("Dead") ~= true) then
                            local Magnitude = (v70.Position - Position).Magnitude;

                            if Magnitude <= MaxDistance and not doesRaycastIntersectSmoke(Position, LookVector, Magnitude) then
                                return v71;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return nil;
end;

local function calculateMagnetismRotation(p74, p75, p76) -- Line: 465
    -- upvalues: u8 (copy)
    if not (p75 and p75.PrimaryPart) then
        return Vector2.zero;
    end;

    local v77 = not (p75 and p75.PrimaryPart) and Vector3.new(0, 0, 0) or p75.PrimaryPart.Position;
    local Position = p74.Position;
    local LookVector = p74.LookVector;

    if (v77 - Position).Magnitude > u8.Magnetism.MaxDistance then
        return Vector2.zero;
    end;

    local Unit = (v77 - Position).Unit;
    local v78 = Vector3.new(LookVector.X, 0, LookVector.Z).Unit:Dot(Vector3.new(Unit.X, 0, Unit.Z).Unit);
    local v79 = math.clamp(v78, -1, 1);
    local v80 = math.acos(v79);

    if u8.Magnetism.MaxAngleHorizontal < v80 then
        return Vector2.zero;
    end;

    if v80 <= u8.Magnetism.StopThreshold then
        return Vector2.zero;
    end;

    if v80 > 1.5707963267948966 then
        return Vector2.zero;
    end;

    local v81 = math.atan2(-LookVector.X, -LookVector.Z);
    local v82 = math.atan2(-Unit.X, -Unit.Z) - v81;

    if v82 > 3.141592653589793 then
        v82 = v82 - 6.283185307179586;
    elseif v82 < -3.141592653589793 then
        v82 = v82 + 6.283185307179586;
    end;

    local v83 = math.abs(v82);

    if v83 < 0.001 then
        return Vector2.zero;
    end;

    local v84 = math.min(u8.Magnetism.PullStrength * p76, v83);
    local v85 = v82 > 0 and 1 or -1;

    if v85 == v85 then
        return Vector2.new(v85 * v84, 0);
    end;

    return Vector2.zero;
end;

local function calculateVerticalMagnetismRotation(p86, p87, p88, p89) -- Line: 549
    -- upvalues: u8 (copy)
    local Head = p87:FindFirstChild("Head");
    local v90;

    if Head then
        v90 = Head.Position;
    else
        v90 = nil;
    end;

    if not v90 then
        return 0;
    end;

    local VerticalMagnetism = u8.VerticalMagnetism;
    local Position = p86.Position;

    if (v90 - Position).Magnitude > VerticalMagnetism.MaxDistance then
        return 0;
    end;

    local Unit = (v90 - Position).Unit;
    local v91 = math.clamp(p86.LookVector.Y, -1, 1);
    local v92 = math.asin(v91);
    local v93 = math.clamp(Unit.Y, -1, 1);
    local v94 = math.asin(v93) - v92;
    local v95 = math.abs(v94);

    if not p89 and VerticalMagnetism.MaxAngleVertical < v95 then
        return 0;
    end;

    if v95 <= VerticalMagnetism.StopThreshold then
        return 0;
    end;

    if v95 < 0.001 then
        return 0;
    end;

    local v96 = math.min(VerticalMagnetism.PullStrength * p88, v95);
    local v97 = v94 > 0 and 1 or -1;

    return v97 ~= v97 and 0 or v97 * v96;
end;

function v1.GetMagnetismRotation(p98) -- Line: 598
    -- upvalues: u6 (copy), u7 (ref), u8 (copy), FlashEffect (copy), CurrentCamera (copy), LocalPlayer (copy), findBestTarget (copy), findTargetWithRaycast (copy), calculateMagnetismRotation (copy), calculateVerticalMagnetismRotation (copy), GamepadEnabled (copy)
    if not u6 then
        return Vector2.zero;
    end;

    if not (u7 and u8.Magnetism.Enabled) then
        return Vector2.zero;
    end;

    if FlashEffect.IsFlashed() then
        return Vector2.zero;
    end;

    if not (CurrentCamera and LocalPlayer.Character) then
        return Vector2.zero;
    end;

    local v99 = p98 or 0.016666666666666666;
    local CFrame2 = CurrentCamera.CFrame;
    local v100 = findBestTarget(CFrame2) or findTargetWithRaycast(CFrame2);

    if not v100 then
        return Vector2.zero;
    end;

    local v101 = calculateMagnetismRotation(CFrame2, v100, v99);
    local v102 = math.abs(v101.X) > 0.0001;
    local v103 = not u8.VerticalMagnetism.Enabled and 0 or calculateVerticalMagnetismRotation(CFrame2, v100, v99, v102);
    local v104 = Vector2.new(v101.X, v103);

    if GamepadEnabled then
        v104 = v104 * 0.5;
    end;

    return v104;
end;

function v1.GetRecoilAssistMultiplier() -- Line: 648
    -- upvalues: u6 (copy), u7 (ref), u8 (copy), FlashEffect (copy), CurrentCamera (copy), LocalPlayer (copy), findBestTarget (copy)
    if not u6 then
        return 0;
    end;

    if not (u7 and u8.RecoilAssist.Enabled) then
        return 0;
    end;

    if FlashEffect.IsFlashed() then
        return 0;
    end;

    if u8.RecoilAssist.RequiresTarget then
        if not (CurrentCamera and LocalPlayer.Character) then
            return 0;
        end;

        if not findBestTarget(CurrentCamera.CFrame) then
            return 0;
        end;
    end;

    return u8.RecoilAssist.ReductionAmount;
end;

function v1.Initialize() -- Line: 683
    -- upvalues: u7 (ref), u6 (copy), DataController (copy), LocalPlayer (copy), u3 (copy), GamepadEnabled (copy)
    u7 = u6;
    DataController.CreateListener(LocalPlayer, "Settings.Game.Other.Mobile Aim Assist", function(p105) -- Line: 686
        -- upvalues: u3 (ref), u7 (ref)
        if u3 then
            u7 = p105 ~= false;
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.Other.Controller Aim Assist", function(p106) -- Line: 692
        -- upvalues: GamepadEnabled (ref), u7 (ref)
        if GamepadEnabled then
            u7 = p106 ~= false;
        end;
    end);
end;

return v1;