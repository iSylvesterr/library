-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Assets = require(ReplicatedStorage.Directory.Assets);
local BBFromModelVisibleOnly = require(ReplicatedStorage.Library.Functions.BBFromModelVisibleOnly);
local EggItemUtil = require(ReplicatedStorage.Library.Util.EggItemUtil);
local Eggs = require(ReplicatedStorage.Library.Types.Eggs);
local FormatDurationSymbol = require(ReplicatedStorage.Library.Functions.FormatDurationSymbol);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local HoverHighlight = require(ReplicatedStorage.Library.Client.WorldFX.HoverHighlight);
local RenderStepped = require(ReplicatedStorage.Library.Functions.RenderStepped);
local SurfaceTracker = require(ReplicatedStorage.Library.Client.SmartProximityPrompt.SurfaceTracker);
local GradientSwap = require(ReplicatedStorage.Library.Functions.GradientSwap);
local Tween = require(ReplicatedStorage.Library.Functions.Tween);
local u1 = {};
local u2 = {};
local u3 = nil;
local u4 = nil;
local u5 = "";
local u6 = nil;
local u7 = 0;
local u8 = nil;
local u9 = nil;
local v10 = {};

local function getKey(p11, p12) -- Line: 75
    return `{p11}:{p12}`;
end;

local function bindGui() -- Line: 79
    -- upvalues: u4 (ref), GUI (copy)
    local v13 = u4;

    if v13 ~= nil then
        return v13;
    end;

    local v14 = GUI.AssetEggData();
    local v15 = v14:IsA("ScreenGui");
    assert(v15, "PlayerGui.AssetEggData must be a ScreenGui");
    local Frame = v14.Frame;
    local v16 = Frame:IsA("GuiObject");
    assert(v16, "AssetEggData.Frame must be a GuiObject");
    local CanvasGroup = Frame.CanvasGroup;
    local v17 = CanvasGroup:IsA("GuiObject");
    assert(v17, "AssetEggData.Frame.CanvasGroup must be a GuiObject");
    local DisplayName = CanvasGroup.DisplayName;
    local v18 = DisplayName:IsA("TextLabel");
    assert(v18, "AssetEggData.Frame.CanvasGroup.DisplayName must be a TextLabel");
    local RemainingHatchTime = CanvasGroup.RemainingHatchTime;
    local v19 = RemainingHatchTime:IsA("TextLabel");
    assert(v19, "AssetEggData.Frame.CanvasGroup.RemainingHatchTime must be a TextLabel");
    local v20 = {
        Root = v14,
        Frame = Frame,
        CanvasGroup = CanvasGroup,
        DisplayName = DisplayName,
        RemainingHatchTime = RemainingHatchTime
    };
    u4 = v20;
    Frame.Visible = false;
    RemainingHatchTime.RichText = true;

    return v20;
end;

local function getRemainingSeconds(p21) -- Line: 110
    -- upvalues: EggItemUtil (copy), Workspace (copy), Players (copy)
    local Record = p21.Record;
    local Placement = Record.Placement;

    if Placement == nil or Placement.ReadyAt ~= nil then
        return 0;
    end;

    local TimeSkipSeconds = p21.TimeSkipSeconds;
    local v22 = TimeSkipSeconds == nil and 0 or TimeSkipSeconds.Value;
    local v23 = EggItemUtil.GetRemainingGrowthSeconds(Record, Workspace:GetServerTimeNow(), Record.GrowthSpeedMultiplier, nil, Players.LocalPlayer) - v22;

    return math.max(0, v23);
end;

local function getEntryScreenPosition(p24) -- Line: 126
    -- upvalues: Workspace (copy), BBFromModelVisibleOnly (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera == nil then
        return false, Vector2.zero;
    end;

    local v25, v26 = CurrentCamera:WorldToViewportPoint(BBFromModelVisibleOnly(p24.Model).Position);

    if v26 then
        return true, Vector2.new(v25.X, v25.Y);
    end;

    return false, Vector2.zero;
end;

local function isEntryInRange(p27) -- Line: 142
    -- upvalues: Players (copy)
    local Character = Players.LocalPlayer.Character;

    if Character == nil then
        return false;
    end;

    local PrimaryPart = Character.PrimaryPart;

    if PrimaryPart == nil then
        return false;
    end;

    local _, v28 = p27.Tracker:GetClosestSurfacePoint(PrimaryPart.Position, 0);
    local v29;

    if v28 == nil then
        v29 = false;
    else
        v29 = v28 <= 7;
    end;

    return v29;
end;

local function selectNearestEntry() -- Line: 157
    -- upvalues: Players (copy), u1 (copy)
    local Character = Players.LocalPlayer.Character;

    if Character == nil or Character.PrimaryPart == nil then
        return nil;
    end;

    local Position = Character.PrimaryPart.Position;
    local v30 = (1 / 0);
    local v31 = nil;

    for _, v in pairs(u1) do
        if v.Model.Parent ~= nil then
            local _, v32 = v.Tracker:GetClosestSurfacePoint(Position, 0);

            if v32 ~= nil and (v32 <= 7 and v32 < v30) then
                v31 = v;
                v30 = v32;
            end;
        end;
    end;

    return v31;
end;

local function updateStaticContent(p33, p34) -- Line: 181
    -- upvalues: Assets (copy), GradientSwap (copy)
    local v35 = Assets.Directory[p34.Record.AssetCategory];
    local v36 = `Missing asset config for category {p34.Record.AssetCategory}`;
    assert(v35 ~= nil, v36);
    p33.DisplayName.Text = "Egg";
    local v37;

    if v35.Egg.HideRarity then
        v37 = nil;
    else
        v37 = v35.Rarity.Gradient;
    end;

    GradientSwap(p33.DisplayName, v37);
end;

local function updateCountdown(p38, p39) -- Line: 189
    -- upvalues: Players (copy), u5 (ref), EggItemUtil (copy), Workspace (copy), FormatDurationSymbol (copy)
    local v40 = p39.OwnerUserId == Players.LocalPlayer.UserId;
    p38.RemainingHatchTime.Visible = v40;

    if not v40 then
        u5 = "";

        return;
    end;

    local Record = p39.Record;
    local Placement = Record.Placement;
    local v41;

    if Placement == nil or Placement.ReadyAt ~= nil then
        v41 = 0;
    else
        local TimeSkipSeconds = p39.TimeSkipSeconds;
        local v42 = TimeSkipSeconds == nil and 0 or TimeSkipSeconds.Value;
        local v43 = EggItemUtil.GetRemainingGrowthSeconds(Record, Workspace:GetServerTimeNow(), Record.GrowthSpeedMultiplier, nil, Players.LocalPlayer) - v42;
        v41 = math.max(0, v43);
    end;

    local v44 = v41 <= 0 and "Ready!" or FormatDurationSymbol(v41);
    local v45 = EggItemUtil.GetServerGrowthBoostMultiplier();
    local v46 = p39.Record.GrowthSpeedMultiplier + v45;

    if v41 > 0 and v46 > 1 then
        v44 = v44 .. ` <font color="#FFD700">(x{v46})</font>`;
    end;

    if v44 == u5 then
        return;
    end;

    u5 = v44;
    p38.RemainingHatchTime.Text = v44;
end;

local function clearActiveHighlight() -- Line: 214
    -- upvalues: u6 (ref), HoverHighlight (copy)
    local v47 = u6;
    u6 = nil;

    if v47 ~= nil then
        HoverHighlight.FadeOut(v47, 0.25);
    end;
end;

local function clearFadeTween() -- Line: 222
    -- upvalues: u8 (ref), u9 (ref)
    local v48 = u8;
    u8 = nil;
    u9 = nil;

    if v48 ~= nil then
        v48:Cancel();
        v48:Destroy();
    end;
end;

local function playCanvasFade(u49, u50, u51) -- Line: 232
    -- upvalues: u8 (ref), u9 (ref), u3 (ref), u7 (ref), Tween (copy)
    if u8 ~= nil and u9 == u50 then
        return;
    end;

    local v52 = u8;
    u8 = nil;
    u9 = nil;

    if v52 ~= nil then
        v52:Cancel();
        v52:Destroy();
    end;

    u9 = u50;

    if u50 < 1 then
        u49.Frame.Visible = true;
    end;

    if math.abs(u49.CanvasGroup.GroupTransparency - u50) <= 0.001 then
        u49.CanvasGroup.GroupTransparency = u50;
        u9 = nil;

        if u50 >= 1 and (u51 ~= nil and (u3 == nil and u7 == u51)) then
            u49.Frame.Visible = false;
        end;

        return;
    end;

    local u53 = Tween(u49.CanvasGroup, {
        GroupTransparency = u50
    }, { 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out });
    u8 = u53;
    u53.Completed:Once(function(p54) -- Line: 258
        -- upvalues: u8 (ref), u53 (copy), u9 (ref), u49 (copy), u50 (copy), u51 (copy), u3 (ref), u7 (ref)
        if u8 == u53 then
            u8 = nil;
            u9 = nil;
        end;

        u53:Destroy();

        if p54 ~= Enum.PlaybackState.Completed then
            return;
        end;

        u49.CanvasGroup.GroupTransparency = u50;

        if u50 >= 1 and (u51 ~= nil and (u3 == nil and u7 == u51)) then
            u49.Frame.Visible = false;
        end;
    end);
end;

local function setActiveEntry(p55) -- Line: 275
    -- upvalues: u3 (ref), bindGui (copy), u5 (ref), u7 (ref), u6 (ref), HoverHighlight (copy), playCanvasFade (copy), Assets (copy), GradientSwap (copy), updateCountdown (copy)
    if p55 ~= nil then
        local v56 = bindGui();
        u7 = u7 + 1;

        if not v56.Frame.Visible then
            v56.CanvasGroup.GroupTransparency = 1;
        end;

        playCanvasFade(v56, 0, nil);
        local v57 = `{p55.OwnerUserId}:{p55.Uid}`;

        if u3 ~= v57 then
            u3 = v57;
            u5 = "";
            local v58 = u6;
            u6 = nil;

            if v58 ~= nil then
                HoverHighlight.FadeOut(v58, 0.25);
            end;

            u6 = HoverHighlight.FadeIn(p55.Model, "EggHoverHighlight", 0.25);
            local v59 = Assets.Directory[p55.Record.AssetCategory];
            local v60 = `Missing asset config for category {p55.Record.AssetCategory}`;
            assert(v59 ~= nil, v60);
            v56.DisplayName.Text = "Egg";
            local v61;

            if v59.Egg.HideRarity then
                v61 = nil;
            else
                v61 = v59.Rarity.Gradient;
            end;

            GradientSwap(v56.DisplayName, v61);
        end;

        updateCountdown(v56, p55);
        v56.Frame.Visible = true;

        return;
    end;

    if u3 == nil then
        return;
    end;

    local v62 = bindGui();
    u3 = nil;
    u5 = "";
    u7 = u7 + 1;
    local v63 = u7;
    local v64 = u6;
    u6 = nil;

    if v64 ~= nil then
        HoverHighlight.FadeOut(v64, 0.25);
    end;

    if v62.Frame.Visible then
        playCanvasFade(v62, 1, v63);
    end;
end;

local function updateBillboard() -- Line: 313
    -- upvalues: u2 (copy), u3 (ref), bindGui (copy), u5 (ref), u7 (ref), u6 (ref), HoverHighlight (copy), playCanvasFade (copy), selectNearestEntry (copy), Players (copy), Workspace (copy), BBFromModelVisibleOnly (copy), setActiveEntry (copy)
    if next(u2) ~= nil then
        if u3 == nil then
            return;
        end;

        local v65 = bindGui();
        u3 = nil;
        u5 = "";
        u7 = u7 + 1;
        local v66 = u7;
        local v67 = u6;
        u6 = nil;

        if v67 ~= nil then
            HoverHighlight.FadeOut(v67, 0.25);
        end;

        if v65.Frame.Visible then
            playCanvasFade(v65, 1, v66);
        end;

        return;
    end;

    local v68 = selectNearestEntry();

    if v68 ~= nil then
        local Character = Players.LocalPlayer.Character;
        local v69;

        if Character == nil then
            v69 = false;
        else
            local PrimaryPart = Character.PrimaryPart;

            if PrimaryPart == nil then
                v69 = false;
            else
                local _, v70 = v68.Tracker:GetClosestSurfacePoint(PrimaryPart.Position, 0);

                if v70 == nil then
                    v69 = false;
                else
                    v69 = v70 <= 7;
                end;
            end;
        end;

        if v69 then
            local v71 = bindGui();
            local CurrentCamera = Workspace.CurrentCamera;
            local v72, v73;

            if CurrentCamera == nil then
                v72 = Vector2.zero;
                v73 = false;
            else
                local v74, v75 = CurrentCamera:WorldToViewportPoint(BBFromModelVisibleOnly(v68.Model).Position);

                if v75 then
                    v72 = Vector2.new(v74.X, v74.Y);
                    v73 = true;
                else
                    v72 = Vector2.zero;
                    v73 = false;
                end;
            end;

            if v73 then
                setActiveEntry(v68);
                v71.Frame.Position = UDim2.fromOffset(v72.X, v72.Y);

                return;
            end;

            if u3 == nil then
                return;
            end;

            local v76 = bindGui();
            u3 = nil;
            u5 = "";
            u7 = u7 + 1;
            local v77 = u7;
            local v78 = u6;
            u6 = nil;

            if v78 ~= nil then
                HoverHighlight.FadeOut(v78, 0.25);
            end;

            if v76.Frame.Visible then
                playCanvasFade(v76, 1, v77);
            end;

            return;
        end;
    end;

    if u3 == nil then
        return;
    end;

    local v79 = bindGui();
    u3 = nil;
    u5 = "";
    u7 = u7 + 1;
    local v80 = u7;
    local v81 = u6;
    u6 = nil;

    if v81 ~= nil then
        HoverHighlight.FadeOut(v81, 0.25);
    end;

    if v79.Frame.Visible then
        playCanvasFade(v79, 1, v80);
    end;
end;

function v10.SetEntry(p82) -- Line: 340
    -- upvalues: Asserts (copy), Eggs (copy), u1 (copy), SurfaceTracker (copy)
    Asserts.number(p82.OwnerUserId);
    Asserts.string(p82.Uid);
    Asserts.Model(p82.Model);
    local v83 = Eggs.SchemaValidation.RuntimeEggRecord(p82.Record);
    assert(v83, "Invalid runtime egg record");
    local v84 = `{p82.OwnerUserId}:{p82.Uid}`;
    local v85 = u1[v84];
    local v86;

    if v85 == nil or v85.Model ~= p82.Model then
        v86 = SurfaceTracker.new(p82.Model);
    else
        v86 = v85.Tracker;
    end;

    if v85 ~= nil and v85.Model ~= p82.Model then
        v85.Tracker:Destroy();
    end;

    u1[v84] = {
        OwnerUserId = p82.OwnerUserId,
        Uid = p82.Uid,
        Record = p82.Record,
        Model = p82.Model,
        TimeSkipSeconds = p82.TimeSkipSeconds,
        Tracker = v86
    };
end;

function v10.SetNightPresentationActive(p87, p88, p89) -- Line: 365
    -- upvalues: Asserts (copy), u2 (copy), u3 (ref), bindGui (copy), u5 (ref), u7 (ref), u6 (ref), HoverHighlight (copy), playCanvasFade (copy)
    Asserts.number(p87);
    Asserts.string(p88);
    Asserts.boolean(p89);
    local v90 = `{p87}:{p88}`;

    if p89 then
        u2[v90] = p87;

        if u3 == nil then
            return;
        end;

        local v91 = bindGui();
        u3 = nil;
        u5 = "";
        u7 = u7 + 1;
        local v92 = u7;
        local v93 = u6;
        u6 = nil;

        if v93 ~= nil then
            HoverHighlight.FadeOut(v93, 0.25);
        end;

        if v91.Frame.Visible then
            playCanvasFade(v91, 1, v92);
        end;
    else
        u2[v90] = nil;
    end;
end;

function v10.RemoveEntry(p94, p95) -- Line: 379
    -- upvalues: Asserts (copy), u1 (copy), u2 (copy), u3 (ref), bindGui (copy), u5 (ref), u7 (ref), u6 (ref), HoverHighlight (copy), playCanvasFade (copy)
    Asserts.number(p94);
    Asserts.string(p95);
    local v96 = `{p94}:{p95}`;
    local v97 = u1[v96];

    if v97 ~= nil then
        v97.Tracker:Destroy();
    end;

    u1[v96] = nil;
    u2[v96] = nil;

    if u3 == v96 then
        if u3 == nil then
            return;
        end;

        local v98 = bindGui();
        u3 = nil;
        u5 = "";
        u7 = u7 + 1;
        local v99 = u7;
        local v100 = u6;
        u6 = nil;

        if v100 ~= nil then
            HoverHighlight.FadeOut(v100, 0.25);
        end;

        if v98.Frame.Visible then
            playCanvasFade(v98, 1, v99);
        end;
    end;
end;

function v10.DestroyOwner(p101) -- Line: 395
    -- upvalues: Asserts (copy), u1 (copy), u3 (ref), bindGui (copy), u5 (ref), u7 (ref), u6 (ref), HoverHighlight (copy), playCanvasFade (copy), u2 (copy)
    Asserts.number(p101);

    for i, v in pairs(u1) do
        if v.OwnerUserId == p101 then
            v.Tracker:Destroy();
            u1[i] = nil;

            if u3 == i then
                if u3 ~= nil then
                    local v102 = bindGui();
                    u3 = nil;
                    u5 = "";
                    u7 = u7 + 1;
                    local v103 = u7;
                    local v104 = u6;
                    u6 = nil;

                    if v104 ~= nil then
                        HoverHighlight.FadeOut(v104, 0.25);
                    end;

                    if v102.Frame.Visible then
                        playCanvasFade(v102, 1, v103);
                    end;
                end;
            end;
        end;
    end;

    for i, v in pairs(u2) do
        if v == p101 then
            u2[i] = nil;
        end;
    end;
end;

RenderStepped(function() -- Line: 418
    -- upvalues: updateBillboard (copy)
    updateBillboard();

    return nil;
end);

return v10;