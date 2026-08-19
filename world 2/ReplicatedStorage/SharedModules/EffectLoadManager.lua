-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local PerfFlags = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Flags"):WaitForChild("PerfFlags"));
local v1 = {};

if Lighting:GetAttribute("ActiveWeatherEffects") == nil then
    Lighting:SetAttribute("ActiveWeatherEffects", 0);
end;

local u2 = 0.016666666666666666;

local function recompute() -- Line: 39
    -- upvalues: Lighting (copy), u2 (ref)
    local v3 = Lighting:GetAttribute("ActiveWeatherEffects") or 1;
    local v4 = math.max(1, v3);
    u2 = 1 / math.max(10, 60 / v4);
end;

Lighting:GetAttributeChangedSignal("ActiveWeatherEffects"):Connect(recompute);
local v5 = Lighting:GetAttribute("ActiveWeatherEffects") or 1;
local v6 = math.max(1, v5);
u2 = 1 / math.max(10, 60 / v6);

function v1.Register() -- Line: 49
    -- upvalues: Lighting (copy)
    Lighting:SetAttribute("ActiveWeatherEffects", (Lighting:GetAttribute("ActiveWeatherEffects") or 0) + 1);
end;

function v1.Unregister() -- Line: 54
    -- upvalues: Lighting (copy)
    local v7 = (Lighting:GetAttribute("ActiveWeatherEffects") or 0) - 1;
    Lighting:SetAttribute("ActiveWeatherEffects", (math.max(0, v7)));
end;

function v1.GetTickInterval() -- Line: 60
    -- upvalues: u2 (ref)
    return u2;
end;

function v1.GetActiveCount() -- Line: 65
    -- upvalues: Lighting (copy)
    local v8 = Lighting:GetAttribute("ActiveWeatherEffects") or 1;

    return math.max(1, v8);
end;

function v1.GetTickIntervalForCount(p9) -- Line: 73
    -- upvalues: PerfFlags (copy)
    local v10 = PerfFlags.MutationColorPopulationBaseHz:Get();
    local v11 = PerfFlags.MutationColorPopulationFloorHz:Get();
    local v12 = v10 / math.max(1, p9);

    return 1 / math.max(v11, v12);
end;

function v1.SpeedScaleForCount(p13) -- Line: 84
    local v14 = 1 / math.max(1, p13);

    return math.max(0.16666666666666666, v14);
end;

local function GetInstancePosition(p15) -- Line: 88
    if p15:IsA("BasePart") then
        return p15.Position;
    end;

    if p15:IsA("Model") then
        local PrimaryPart = p15.PrimaryPart;

        if PrimaryPart then
            return PrimaryPart.Position;
        end;

        return p15:GetPivot().Position;
    end;

    local v16 = p15:FindFirstChildWhichIsA("BasePart");

    if v16 then
        return v16.Position;
    end;

    return nil;
end;

local function IsRoughlyOnScreen(p17, p18) -- Line: 108
    local v19 = p17:WorldToViewportPoint(p18);

    if v19.Z <= 0 then
        return false;
    end;

    local ViewportSize = p17.ViewportSize;
    local v20 = ViewportSize.X * 0.25;
    local v21 = ViewportSize.Y * 0.25;
    local v22;

    if v19.X >= -v20 and (v19.X <= ViewportSize.X + v20 and v19.Y >= -v21) then
        v22 = v19.Y <= ViewportSize.Y + v21;
    else
        v22 = false;
    end;

    return v22;
end;

function v1.DistanceIntervalMultiplier(p23) -- Line: 122
    -- upvalues: GetInstancePosition (copy), PerfFlags (copy), IsRoughlyOnScreen (copy)
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return 1;
    end;

    local v24 = GetInstancePosition(p23);

    if not v24 then
        return 1;
    end;

    local Magnitude = (CurrentCamera.CFrame.Position - v24).Magnitude;

    if PerfFlags.MutationColorFarDistance:Get() <= Magnitude then
        return nil;
    end;

    if PerfFlags.MutationColorOffscreenCulling:Get() and not IsRoughlyOnScreen(CurrentCamera, v24) then
        return nil;
    end;

    return Magnitude <= PerfFlags.MutationColorNearDistance:Get() and 1 or PerfFlags.MutationColorMidIntervalMultiplier:Get();
end;

function v1.ShouldAnimateInstance(p25, p26) -- Line: 144
    -- upvalues: GetInstancePosition (copy), PerfFlags (copy), IsRoughlyOnScreen (copy), Players (copy)
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return true;
    end;

    local v27 = GetInstancePosition(p25);

    if not v27 then
        return true;
    end;

    if (CurrentCamera.CFrame.Position - v27).Magnitude < PerfFlags.MutationColorFarDistance:Get() and (not PerfFlags.MutationColorOffscreenCulling:Get() or IsRoughlyOnScreen(CurrentCamera, v27)) then
        return true;
    end;

    local v28 = p26 or 0;

    if v28 <= 0 then
        return false;
    end;

    local LocalPlayer = Players.LocalPlayer;

    if LocalPlayer then
        LocalPlayer = LocalPlayer.Character;
    end;

    if LocalPlayer then
        return (LocalPlayer:GetPivot().Position - v27).Magnitude <= v28;
    end;

    return false;
end;

return v1;