-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local BBFromModelVisibleOnly = require(ReplicatedStorage.Library.Functions.BBFromModelVisibleOnly);
local EggItemUtil = require(ReplicatedStorage.Library.Util.EggItemUtil);
local EggRenderer = require(script.Parent.EggRenderer);
local EggScaleUtil = require(ReplicatedStorage.Library.Util.EggScaleUtil);
require(ReplicatedStorage.Library.Types.Eggs);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Player = require(ReplicatedStorage.Library.Player);
local u1 = Log.new();
local u8 = {
    GetGrowthAlpha = function(p2, p3) -- Line: 37, Name: GetGrowthAlpha
        -- upvalues: EggItemUtil (copy), Workspace (copy)
        return EggItemUtil.GetGrowthAlpha(p2, Workspace:GetServerTimeNow(), p2.GrowthSpeedMultiplier, p3);
    end,

    GetDirectGrowthTweenRemainingSeconds = function(p4, p5) -- Line: 49, Name: GetDirectGrowthTweenRemainingSeconds
        -- upvalues: EggItemUtil (copy)
        local Placement = p4.Placement;

        return (Placement == nil or Placement.ReadyAt ~= nil) and 0 or (EggItemUtil.GetGrowthDuration(p4) >= 10 and 0 or EggItemUtil.GetRemainingGrowthWallSeconds(p4, p5, p4.GrowthSpeedMultiplier));
    end,

    GetStartScale = function(p6) -- Line: 65, Name: GetStartScale
        -- upvalues: EggScaleUtil (copy), EggRenderer (copy)
        return EggScaleUtil.GetPlacedStartScale(EggRenderer.GetAuthoredScale(p6), p6.AssetScale, p6.AssetCategory);
    end,

    GetTargetScale = function(p7) -- Line: 73, Name: GetTargetScale
        -- upvalues: EggScaleUtil (copy), EggRenderer (copy)
        return EggScaleUtil.GetPlacedTargetScale(EggRenderer.GetAuthoredScale(p7), p7.AssetScale, p7.AssetCategory);
    end
};

function u8.GetVisualScale(p9, p10, p11) -- Line: 81
    -- upvalues: u8 (copy)
    return p10 + u8.GetGrowthAlpha(p9, nil) * (p11 - p10);
end;

function u8.IsReady(p12, p13) -- Line: 89
    -- upvalues: u8 (copy)
    return u8.GetGrowthAlpha(p12, p13) >= 1;
end;

function u8.GetRemainingGrowthSeconds(p14, p15) -- Line: 96
    -- upvalues: EggItemUtil (copy), Workspace (copy)
    return EggItemUtil.GetRemainingGrowthSeconds(p14, Workspace:GetServerTimeNow(), p14.GrowthSpeedMultiplier, p15);
end;

function u8.GetSkipReason(p16) -- Line: 108
    -- upvalues: Asserts (copy), Player (copy), Players (copy), Workspace (copy), BBFromModelVisibleOnly (copy)
    Asserts.Model(p16);
    local v17 = Player.Optional.HumanoidRootPart(Players.LocalPlayer);

    if v17 == nil then
        return "local player root is unavailable";
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera == nil then
        return "current camera is unavailable";
    end;

    local v18 = BBFromModelVisibleOnly(p16);
    local Magnitude = (v17.Position - v18.Position).Magnitude;

    if Magnitude > 300 then
        return `distance {math.round(Magnitude)} studs exceeds {300}`;
    end;

    local _, v19 = CurrentCamera:WorldToViewportPoint(v18.Position);

    return not v19 and "visible bounds center is off-screen" or nil;
end;

function u8.GetGrowthScaleDeltaSkipReason(p20, p21) -- Line: 135
    -- upvalues: Asserts (copy)
    Asserts.finite(p20);
    Asserts.finite(p21);
    local v22 = math.abs(p21 - p20);

    if v22 <= 0.15 then
        return `scale delta {math.round(v22 * 1000) / 1000} does not exceed {0.15} presentation threshold`;
    end;

    local v23 = math.abs(p20);
    local v24 = v22 / math.max(v23, 0.001);

    if v24 <= 0.03 then
        return `relative scale delta {math.round(v24 * 10000) / 100}% does not exceed {3}% presentation threshold`;
    end;

    return nil;
end;

function u8.GetNaturalGrowthSkipReason(p25, p26) -- Line: 157
    -- upvalues: Asserts (copy), u8 (copy)
    Asserts.Model(p25);
    Asserts.finite(p26);
    local v27 = u8.GetGrowthScaleDeltaSkipReason(p25:GetScale(), p26);

    if v27 == nil then
        return u8.GetSkipReason(p25);
    end;

    return v27;
end;

function u8.LogSkipped(p28, p29, p30) -- Line: 170
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.string(p28);
    Asserts.string(p29);
    Asserts.string(p30);
    u1:AtInfo():Log((`Skipped placed egg {p29} for {p28}: {p30}`));
end;

return u8;