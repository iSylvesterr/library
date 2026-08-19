-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CamShake = require(ReplicatedStorage.ClientModules.CamShake);
local v1 = {};

local function getLocalHrp() -- Line: 38
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;

    if LocalPlayer then
        LocalPlayer = LocalPlayer.Character;
    end;

    if LocalPlayer then
        LocalPlayer = LocalPlayer:FindFirstChild("HumanoidRootPart");
    end;

    if LocalPlayer and LocalPlayer:IsA("BasePart") then
        return LocalPlayer;
    end;

    return nil;
end;

local function isInRange(p2) -- Line: 48
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;

    if LocalPlayer then
        LocalPlayer = LocalPlayer.Character;
    end;

    if LocalPlayer then
        LocalPlayer = LocalPlayer:FindFirstChild("HumanoidRootPart");
    end;

    if not (LocalPlayer and LocalPlayer:IsA("BasePart")) then
        LocalPlayer = nil;
    end;

    if LocalPlayer then
        return (LocalPlayer.Position - p2).Magnitude <= 250;
    end;

    return false;
end;

local function resolvePathSize(p3) -- Line: 56
    return p3 ~= "Big" and p3 ~= "Huge" and "Normal" or p3;
end;

local function computeGrowImpact(p4, p5) -- Line: 63
    local v6 = p4 - 1;

    return (v6 * 0.85 + 1.4) * (p5 == "Huge" and 1.25 or 1) * 1, v6 * 3 + 8;
end;

local function playImpactShake(p7, p8, p9, p10) -- Line: 73
    -- upvalues: CamShake (copy)
    CamShake:ShakeOnce(p7, p8, p9 or 0.04, p10 or 0.4, Vector3.new(0.3, 0.3, 0.3), Vector3.new(2, 2, 5));
end;

local function playGrowImpact(p11, p12) -- Line: 84
    -- upvalues: Players (copy), CamShake (copy)
    if p11._pathSize == "Normal" then
        return;
    end;

    if p12 < 1 then
        return;
    end;

    local _eggPosition = p11._eggPosition;
    local LocalPlayer = Players.LocalPlayer;

    if LocalPlayer then
        LocalPlayer = LocalPlayer.Character;
    end;

    if LocalPlayer then
        LocalPlayer = LocalPlayer:FindFirstChild("HumanoidRootPart");
    end;

    if not (LocalPlayer and LocalPlayer:IsA("BasePart")) then
        LocalPlayer = nil;
    end;

    local v13;

    if LocalPlayer then
        v13 = (LocalPlayer.Position - _eggPosition).Magnitude <= 250;
    else
        v13 = false;
    end;

    if not v13 then
        return;
    end;

    local v14 = p12 - 1;
    CamShake:ShakeOnce((v14 * 0.85 + 1.4) * (p11._pathSize == "Huge" and 1.25 or 1) * 1, v14 * 3 + 8, 0.04, 0.4, Vector3.new(0.3, 0.3, 0.3), Vector3.new(2, 2, 5));
end;

local function playHatchImpact(p15) -- Line: 99
    -- upvalues: Players (copy), CamShake (copy)
    if p15._pathSize == "Normal" then
        return;
    end;

    if p15._maxGrowTier < 1 then
        return;
    end;

    local _eggPosition = p15._eggPosition;
    local LocalPlayer = Players.LocalPlayer;

    if LocalPlayer then
        LocalPlayer = LocalPlayer.Character;
    end;

    if LocalPlayer then
        LocalPlayer = LocalPlayer:FindFirstChild("HumanoidRootPart");
    end;

    if not (LocalPlayer and LocalPlayer:IsA("BasePart")) then
        LocalPlayer = nil;
    end;

    local v16;

    if LocalPlayer then
        v16 = (LocalPlayer.Position - _eggPosition).Magnitude <= 250;
    else
        v16 = false;
    end;

    if not v16 then
        return;
    end;

    local v17 = p15._maxGrowTier + 1 - 1;
    CamShake:ShakeOnce((v17 * 0.85 + 1.4) * (p15._pathSize == "Huge" and 1.25 or 1) * 1, v17 * 3 + 8, 0.08, 0.8, Vector3.new(0.3, 0.3, 0.3), Vector3.new(2, 2, 5));
end;

function v1.begin(p18, p19) -- Line: 119
    -- upvalues: Players (copy), CamShake (copy)
    return {
        _maxGrowTier = 0,
        _resolved = false,
        _eggPosition = p18,
        _pathSize = p19 ~= "Big" and p19 ~= "Huge" and "Normal" or p19,

        onWobbleBeat = function(p20, p21) -- Line: 129, Name: onWobbleBeat
        end,

        onGrowBeat = function(p22, p23, p24) -- Line: 132, Name: onGrowBeat
            -- upvalues: Players (ref), CamShake (ref)
            if p22._resolved or p22._pathSize == "Normal" then
                return;
            end;

            p22._maxGrowTier = math.max(p22._maxGrowTier, p23);

            if p22._pathSize == "Normal" then
                return;
            end;

            if p23 < 1 then
                return;
            end;

            local _eggPosition = p22._eggPosition;
            local LocalPlayer = Players.LocalPlayer;

            if LocalPlayer then
                LocalPlayer = LocalPlayer.Character;
            end;

            if LocalPlayer then
                LocalPlayer = LocalPlayer:FindFirstChild("HumanoidRootPart");
            end;

            if not (LocalPlayer and LocalPlayer:IsA("BasePart")) then
                LocalPlayer = nil;
            end;

            local v25;

            if LocalPlayer then
                v25 = (LocalPlayer.Position - _eggPosition).Magnitude <= 250;
            else
                v25 = false;
            end;

            if not v25 then
                return;
            end;

            local v26 = p23 - 1;
            CamShake:ShakeOnce((v26 * 0.85 + 1.4) * (p22._pathSize == "Huge" and 1.25 or 1) * 1, v26 * 3 + 8, 0.04, 0.4, Vector3.new(0.3, 0.3, 0.3), Vector3.new(2, 2, 5));
        end,

        onHatch = function(p27, p28) -- Line: 140, Name: onHatch
        end,

        onPetRevealed = function(p29) -- Line: 143, Name: onPetRevealed
            -- upvalues: Players (ref), CamShake (ref)
            if p29._resolved or p29._pathSize == "Normal" then
                return;
            end;

            p29._resolved = true;

            if p29._pathSize == "Normal" then
                return;
            end;

            if p29._maxGrowTier < 1 then
                return;
            end;

            local _eggPosition = p29._eggPosition;
            local LocalPlayer = Players.LocalPlayer;

            if LocalPlayer then
                LocalPlayer = LocalPlayer.Character;
            end;

            if LocalPlayer then
                LocalPlayer = LocalPlayer:FindFirstChild("HumanoidRootPart");
            end;

            if not (LocalPlayer and LocalPlayer:IsA("BasePart")) then
                LocalPlayer = nil;
            end;

            local v30;

            if LocalPlayer then
                v30 = (LocalPlayer.Position - _eggPosition).Magnitude <= 250;
            else
                v30 = false;
            end;

            if not v30 then
                return;
            end;

            local v31 = p29._maxGrowTier + 1 - 1;
            CamShake:ShakeOnce((v31 * 0.85 + 1.4) * (p29._pathSize == "Huge" and 1.25 or 1) * 1, v31 * 3 + 8, 0.08, 0.8, Vector3.new(0.3, 0.3, 0.3), Vector3.new(2, 2, 5));
        end,

        finishHatch = function(p32) -- Line: 151, Name: finishHatch
            p32._resolved = true;
        end
    };
end;

return v1;