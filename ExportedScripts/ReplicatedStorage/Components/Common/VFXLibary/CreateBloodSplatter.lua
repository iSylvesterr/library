-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local Debris = game:GetService("Debris");
local Debris2 = workspace:WaitForChild("Debris");
local GetRayIgnore = require(ReplicatedStorage.Components.Common.GetRayIgnore);
local u1 = RaycastParams.new();
u1.FilterType = Enum.RaycastFilterType.Exclude;
u1.IgnoreWater = true;
local u2 = { "rbxassetid://8635071092", "rbxassetid://8634747192", "rbxassetid://15067037717", "rbxassetid://18779968078" };

local function getDistanceSize(p3) -- Line: 38
    return math.clamp(p3, 2, 14) * 0.2;
end;

local function rotateVector(p4, p5, p6) -- Line: 43
    local v7 = p4.Magnitude == 1;

    local function snap(p8, p9) -- Line: 46
        if p9 > 0 then
            return math.floor(p8 / p9 + 0.5) * p9;
        end;

        warn("Grid size negative or 0");

        return p8;
    end;

    if p4.Magnitude <= 0 then
        return Vector3.new(0, 0, 0);
    end;

    local X = p4.X;
    local Y = p4.Y;
    local Z = p4.Z;
    local v10 = nil;
    local v11 = nil;
    local v12 = nil;

    if p5 == Enum.Axis.Z then
        v10 = X * math.cos(p6) - Y * math.sin(p6);
        v11 = X * math.sin(p6) + Y * math.cos(p6);
    elseif p5 == Enum.Axis.X then
        v11 = -Y * math.cos(p6) + Z * math.sin(p6);
        v12 = Y * math.sin(p6) + Z * math.cos(p6);
        v10 = X;
    elseif p5 == Enum.Axis.Y then
        v10 = X * math.cos(p6) - Z * math.sin(p6);
        v12 = X * math.sin(p6) + Z * math.cos(p6);
        v11 = Y;
    end;

    local v13 = math.floor(v10 / 0.001 + 0.5) * 0.001;
    local v14 = math.floor(v11 / 0.001 + 0.5) * 0.001;
    local v15 = math.floor(v12 / 0.001 + 0.5) * 0.001;
    local v16 = Vector3.new(v13, v14, v15);

    if v7 then
        v16 = v16.Unit;
    end;

    assert(v16 == v16, string.format("rotated vector nan %e %e %e -> %e %e %e", p4.X, p4.Y, p4.Z, v16.X, v16.Y, v16.Z));

    return v16;
end;

local function updateRaycastParameters() -- Line: 80
    -- upvalues: GetRayIgnore (copy), Players (copy), u1 (copy)
    local v17 = GetRayIgnore();

    for _, v in ipairs(Players:GetPlayers()) do
        if v.Character then
            table.insert(v17, v.Character);
        end;
    end;

    u1.FilterDescendantsInstances = v17;
end;

local function createBloodSplatterPart(p18, p19) -- Line: 94
    -- upvalues: ReplicatedStorage (copy), Debris2 (copy), u2 (copy), TweenService (copy), Debris (copy)
    local v20 = ReplicatedStorage.Assets.Other.BloodSplatter:Clone();
    v20.CFrame = p18;
    v20.CollisionGroup = "Debris";
    v20.CanCollide = false;
    v20.CanQuery = false;
    v20.CanTouch = false;
    v20.Anchored = true;
    v20.Size = p19;
    v20.Parent = Debris2;

    for _, descendant in ipairs(v20:GetDescendants()) do
        if descendant:IsA("Decal") then
            descendant.Texture = u2[math.random(1, #u2)];
            descendant.Color3 = Color3.fromRGB(126, 16, 24);
            TweenService:Create(descendant, TweenInfo.new(15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                Transparency = 1,
                Color3 = Color3.fromRGB(70, 10, 15)
            }):Play();
        end;
    end;

    Debris:AddItem(v20, 15);

    return v20;
end;

local function createBloodSplatter2(p21, p22) -- Line: 127
    -- upvalues: createBloodSplatterPart (copy)
    createBloodSplatterPart(CFrame.new(p21.Position, p21.Position + p21.Normal) * CFrame.Angles(3.141592653589793, 0, 0) + p21.Normal * 0.25, p22);
end;

local function getVolumeSize(p23, p24, p25) -- Line: 134
    -- upvalues: createBloodSplatterPart (copy)
    local v26 = p23.Y / 2;
    local v27 = p23.X / 2;
    local Position = p24.Position;
    local Normal = p24.Normal;
    local v28 = -Normal;
    local v29 = CFrame.new(Position, Position + v28 * 0.1);
    local v30 = Position + Normal;
    local v31 = v26;
    local v32 = v27;
    local v33 = false;

    for i = 0, 10 do
        v31 = v26 - i / 2;
        v32 = v27 - i / 2;
        local v34 = v30 + v29.UpVector * v31 + v29.RightVector * v32;
        local v35 = v30 - v29.UpVector * v31 + v29.RightVector * v32;
        local v36 = v30 - v29.UpVector * v31 - v29.RightVector * v32;
        local v37 = workspace:Raycast(v30 + v29.UpVector * v31 - v29.RightVector * v32, v28 * 2, p25);
        local v38 = workspace:Raycast(v34, v28 * 2, p25);
        local v39 = workspace:Raycast(v36, v28 * 2, p25);
        local v40 = workspace:Raycast(v35, v28 * 2, p25);

        if v37 and (v38 and (v39 and (v40 and (v37.Normal:Angle(v38.Normal) <= 1.5707963267948966 and (v39.Normal:Angle(v40.Normal) <= 1.5707963267948966 and v37.Normal:Angle(v39.Normal) <= 1.5707963267948966))))) then
            v33 = true;
            break;
        end;
    end;

    if v33 then
        local v41 = Vector3.new(v32 * 2, v31 * 2, 0.001);
        createBloodSplatterPart(CFrame.new(p24.Position, p24.Position + p24.Normal) * CFrame.Angles(3.141592653589793, 0, 0) + p24.Normal * 0.25, v41);
    end;
end;

local function calculateSplatterPositionSize(p42, p43, p44) -- Line: 199
    -- upvalues: rotateVector (copy), getVolumeSize (copy)
    local v45 = workspace:Raycast(p42, rotateVector(p43, Enum.Axis.Y, -0.2617993877991494), p44);
    local v46 = workspace:Raycast(p42, p43, p44);
    local v47 = workspace:Raycast(p42, rotateVector(p43, Enum.Axis.Y, 0.2617993877991494), p44);
    local v48;

    if v45 then
        if v46 then
            if v45.Instance == v46.Instance then
                v48 = v45.Normal == v46.Normal;
            else
                v48 = false;
            end;
        else
            v48 = v46;
        end;
    else
        v48 = v45;
    end;

    local v49;

    if v47 then
        if v46 then
            if v47.Instance == v46.Instance then
                v49 = v47.Normal == v46.Normal;
            else
                v49 = false;
            end;
        else
            v49 = v46;
        end;
    else
        v49 = v47;
    end;

    local v50 = nil;

    if v46 then
        v50 = Vector3.new(4, 4, 0) * (math.clamp(v46.Distance, 2, 14) * 0.2) + Vector3.new(0, 0, 0.001);
    elseif v47 then
        v50 = Vector3.new(4, 4, 0) * (math.clamp(v47.Distance, 2, 14) * 0.2) + Vector3.new(0, 0, 0.001);
    elseif v45 then
        v50 = Vector3.new(4, 4, 0) * (math.clamp(v45.Distance, 2, 14) * 0.2) + Vector3.new(0, 0, 0.001);
    end;

    if not v50 then
        return;
    end;

    if v46 then
        getVolumeSize(v50, v46, p44);
    end;

    if v45 and not v48 then
        getVolumeSize(v50, v45, p44);
    end;

    if v47 and not v49 then
        getVolumeSize(v50, v47, p44);
    end;
end;

local function createBloodSplatter(p51) -- Line: 235
    -- upvalues: createBloodSplatterPart (copy)
    local v52 = CFrame.new(p51.Position, p51.Position + p51.Normal) * CFrame.Angles(3.141592653589793, 0, 0);
    local v53 = Vector3.new(4, 4, 0) * (math.clamp(p51.Distance, 2, 14) * 0.2) + Vector3.new(0, 0, 0.001);
    createBloodSplatterPart(v52 + p51.Normal * 0.25, v53);
end;

return function(p54, p55) -- Line: 244
end;