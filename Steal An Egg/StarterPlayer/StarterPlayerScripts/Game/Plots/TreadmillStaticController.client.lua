-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
local Audio = require(ReplicatedStorage.Library.Audio);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local BaseUpgradeTransitionLifecycle = require(ReplicatedStorage.Library.Client.BaseUpgradeTransitionLifecycle);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Easing = require(ReplicatedStorage.Library.Functions.Easing);
local Emit = require(ReplicatedStorage.Library.Functions.Emit);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local LocalPlotUpgradeVisibility = require(ReplicatedStorage.Library.Client.LocalPlotUpgradeVisibility);
local Lock = require(ReplicatedStorage.Library.Functions.Lock);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds);
local RenderStepped = require(ReplicatedStorage.Library.Functions.RenderStepped);
local RuntimeInstanceRegistry = require(ReplicatedStorage.Library.Modules.RuntimeInstanceRegistry);
local Save = require(ReplicatedStorage.Library.Client.Save);
local TreadmillStaticCover = require(ReplicatedStorage.Library.Client.UI.TreadmillStaticCover);
local Render = require(script.Render);
require(script.Types.Interface);
local TreadmillVideoController = require(ReplicatedStorage.Library.Client.TreadmillVideoController);
local PreloadAssets = require(ReplicatedStorage.Library.Functions.PreloadAssets);
local LocalPlayer = Players.LocalPlayer;
local u1 = Log.new();
local Treadmills = Constants.NETWORK_MAP.Treadmills;
local TreadmillUpgrade = ReplicatedStorage.Assets.Particles.TreadmillUpgrade;
local Folder = Instance.new("Folder");
Folder.Name = "__ClientTreadmillRenders";
Folder.Parent = Workspace;
task.spawn(PreloadAssets, TreadmillUpgrade);
local u2 = nil;
local u3 = {};
local u4 = false;
local u5 = Lock();
local u6 = false;
local u7 = 0;
local u8 = true;
local u9 = 0;
local u10 = 0;
local u11 = false;
local u12 = false;
local u13 = false;
local u14 = {};
local u15 = {};
local u16 = {};

local function destroyRender(p17) -- Line: 80
    -- upvalues: u15 (copy), LocalPlayer (copy), RuntimeInstanceRegistry (copy)
    local v18 = u15[p17];

    if v18 == nil then
        return;
    end;

    u15[p17] = nil;

    if v18.OwnerUserId == LocalPlayer.UserId then
        RuntimeInstanceRegistry.Clear("TreadmillPlotRender", (tostring(p17)));

        if RuntimeInstanceRegistry.Get("Treadmill", v18.TreadmillId) == v18.Model then
            RuntimeInstanceRegistry.Clear("Treadmill", v18.TreadmillId);
        end;
    end;

    if v18.Cover ~= nil then
        v18.Cover:Destroy();
    end;

    v18.Model:Destroy();
end;

local function resolveLocalRender() -- Line: 98
    -- upvalues: PlotCmds (copy), u15 (copy)
    local v19 = PlotCmds.GetMySlot();

    if v19 == nil then
        return nil;
    end;

    return u15[v19];
end;

local function animateScale(u20, u21, u22, p23, u24) -- Line: 103
    -- upvalues: RenderStepped (copy), Easing (copy), Render (copy)
    RenderStepped(function(p25, p26) -- Line: 110
        -- upvalues: u20 (copy), Easing (ref), u24 (copy), Render (ref), u21 (copy), u22 (copy)
        if u20.Model.Parent == nil then
            return true;
        end;

        local v27 = Easing(p26, u24, Enum.EasingDirection.Out);
        Render.SetGroundedScale(u20, u21 + (u22 - u21) * v27);

        return false;
    end, p23, true):Wait();

    if u20.Model.Parent ~= nil then
        Render.SetGroundedScale(u20, u22);
    end;
end;

local function runLocalUpgradeAnimation(p28, p29) -- Line: 124
    -- upvalues: TweenService (copy), TreadmillUpgrade (copy), Emit (copy), Audio (copy), Message (copy), animateScale (copy)
    local Root = p28.Model.Root;
    local v30 = Root:IsA("BasePart");
    local v31 = `Treadmill "{p28.TreadmillId}" Root must be a BasePart`;
    assert(v30, v31);
    local Highlight = Instance.new("Highlight");
    Highlight.Adornee = p28.Model;
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    Highlight.FillColor = Color3.new(1, 1, 1);
    Highlight.FillTransparency = 1;
    Highlight.OutlineColor = Color3.new(1, 1, 1);
    Highlight.OutlineTransparency = 1;
    Highlight.Parent = p28.Model;
    local v32 = TweenService:Create(Highlight, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        FillTransparency = 0.15,
        OutlineTransparency = 0
    });
    local u33 = TweenService:Create(Highlight, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        FillTransparency = 1,
        OutlineTransparency = 1
    });
    v32.Completed:Once(function() -- Line: 145
        -- upvalues: u33 (copy)
        u33:Play();
    end);
    u33.Completed:Once(function() -- Line: 148
        -- upvalues: Highlight (copy)
        Highlight:Destroy();
    end);
    v32:Play();
    Emit(Root, nil, TreadmillUpgrade:Clone():GetChildren());
    Audio.Play(130233661094961, script, { 0.9, 1.1 }, 1.5);
    Message.Bottom({
        Message = "Successfully upgraded your treadmill!",
        Time = 0.7,
        Color = Color3.fromRGB(0, 255, 47)
    });
    animateScale(p28, p29 * 0.8, p29, 0.55, Enum.EasingStyle.Elastic);
end;

local function replaceRender(p34, p35, p36, p37) -- Line: 170
    -- upvalues: u16 (copy), u15 (copy), animateScale (copy), destroyRender (copy), Render (copy), LocalPlayer (copy), Folder (copy), RuntimeInstanceRegistry (copy), u2 (ref), TreadmillStaticCover (copy), runLocalUpgradeAnimation (copy)
    local v38 = (u16[p34] or 0) + 1;
    u16[p34] = v38;
    local v39 = u15[p34];

    if p37 and v39 ~= nil then
        local v40 = v39.Model:GetScale();
        animateScale(v39, v40, v40 * 0.8, 0.22, Enum.EasingStyle.Quad);

        if u16[p34] ~= v38 then
            return;
        end;
    end;

    destroyRender(p34);
    local v41 = Render.Build(p34, p35, p36, p37 and 0.8 or 1, p35 == LocalPlayer.UserId, Folder);
    u15[p34] = v41;

    if p35 == LocalPlayer.UserId then
        RuntimeInstanceRegistry.Set("TreadmillPlotRender", tostring(p34), v41.Model);
        v41.RateSign.Enabled = u2 == nil;
        local Cover = v41.Cover;

        if Cover ~= nil then
            TreadmillStaticCover.SetEnabled(Cover, u2 == nil);
        end;

        if u2 ~= nil then
            RuntimeInstanceRegistry.Set("Treadmill", v41.TreadmillId, v41.Model);
        end;
    end;

    if p37 then
        runLocalUpgradeAnimation(v41, v41.Model:GetScale() / 0.8);
    end;
end;

local function refreshSlot(p42, p43, p44) -- Line: 213
    -- upvalues: u16 (copy), destroyRender (copy), LocalPlayer (copy), u3 (copy), Players (copy), Save (copy), PlotCmds (copy), u13 (ref), u7 (ref), BaseUpgradeTransitionLifecycle (copy), replaceRender (copy)
    if p43 == nil then
        u16[p42] = (u16[p42] or 0) + 1;
        destroyRender(p42);

        return;
    end;

    if p43 ~= LocalPlayer.UserId and u3[p43] ~= true then
        u16[p42] = (u16[p42] or 0) + 1;
        destroyRender(p42);

        return;
    end;

    local v45 = Players:GetPlayerByUserId(p43);

    if v45 == nil then
        return;
    end;

    local v46 = Save.Get(v45);

    if v46 == nil or PlotCmds.GetSlotOwner(p42) ~= p43 then
        return;
    end;

    if v46.BaseUpgradeLevel == 0 then
        destroyRender(p42);

        return;
    end;

    if p43 ~= LocalPlayer.UserId or not u13 and (u7 ~= 0 or not BaseUpgradeTransitionLifecycle.IsPlaying()) then
        replaceRender(p42, p43, v46, p44);

        return;
    end;

    u13 = true;
    destroyRender(p42);
end;

local function refreshPlayerRender(p47, p48) -- Line: 250
    -- upvalues: PlotCmds (copy), refreshSlot (copy)
    for i, v in pairs(PlotCmds.GetState()) do
        if v == p47.UserId then
            refreshSlot(i, v, p48);

            return;
        end;
    end;
end;

local function applyRemoteSessionTransition(p49, p50, p51) -- Line: 259
    -- upvalues: u9 (ref), LocalPlayer (copy), u3 (copy), refreshPlayerRender (copy)
    if p51 <= u9 then
        return;
    end;

    u9 = p51;

    if p49 == LocalPlayer then
        return;
    end;

    if p50 then
        u3[p49.UserId] = true;
    else
        u3[p49.UserId] = nil;
    end;

    refreshPlayerRender(p49, false);
end;

local function synchronizeRemoteSessionSnapshot() -- Line: 275
    -- upvalues: Network (copy), Treadmills (copy), Asserts (copy), u3 (copy), LocalPlayer (copy), u9 (ref), u14 (copy), u8 (ref), refreshPlayerRender (copy)
    local v52, v53 = Network.Invoke(Treadmills.REQUEST_ACTIVE_RENDER_SNAPSHOT);
    Asserts.array.uniqueInteger(v52);
    Asserts.number(v53);
    table.clear(u3);

    for _, v in ipairs(v52) do
        if v ~= LocalPlayer.UserId then
            u3[v] = true;
        end;
    end;

    u9 = v53;
    table.sort(u14, function(p54, p55) -- Line: 286
        return p54.Revision < p55.Revision;
    end);
    u8 = false;

    for _, v in ipairs(u14) do
        local Player = v.Player;
        local Active = v.Active;
        local Revision = v.Revision;

        if Revision > u9 then
            u9 = Revision;

            if Player ~= LocalPlayer then
                if Active then
                    u3[Player.UserId] = true;
                else
                    u3[Player.UserId] = nil;
                end;

                refreshPlayerRender(Player, false);
            end;
        end;
    end;

    table.clear(u14);
end;

local function refreshLocalRender(p56) -- Line: 296
    -- upvalues: u6 (ref), refreshPlayerRender (copy), LocalPlayer (copy)
    u6 = true;
    refreshPlayerRender(LocalPlayer, p56);
    u6 = false;
end;

local function consumePendingUpgradeRefresh() -- Line: 302
    -- upvalues: u4 (ref), u11 (ref), u2 (ref), u12 (ref), u6 (ref), refreshPlayerRender (copy), LocalPlayer (copy), u10 (ref), Workspace (copy)
    if not u4 or (not u11 or u2 ~= nil) then
        return;
    end;

    local v57 = u12;
    u4 = false;
    u11 = false;
    u12 = false;
    u6 = true;
    refreshPlayerRender(LocalPlayer, v57);
    u6 = false;
    u10 = Workspace:GetServerTimeNow() + 1.25;
end;

local function refreshPlotUpgradeVisibility() -- Line: 314
    -- upvalues: LocalPlotUpgradeVisibility (copy), u7 (ref)
    LocalPlotUpgradeVisibility.Refresh("TreadmillUpgrade", u7 > 0);
end;

local function revealFirstExpansionTreadmill() -- Line: 318
    -- upvalues: Save (copy), u7 (ref), u13 (ref), LocalPlotUpgradeVisibility (copy), u6 (ref), refreshPlayerRender (copy), LocalPlayer (copy), u10 (ref), Workspace (copy)
    local v58 = Save.Get();
    assert(v58 ~= nil, "First expansion treadmill reveal requires local save data");

    if v58.BaseUpgradeLevel == 0 then
        return;
    end;

    u7 = v58.BaseUpgradeLevel;
    u13 = false;
    LocalPlotUpgradeVisibility.Refresh("TreadmillUpgrade", u7 > 0);
    u6 = true;
    refreshPlayerRender(LocalPlayer, true);
    u6 = false;
    u10 = Workspace:GetServerTimeNow() + 1.25;
end;

local function tryEnterStaticTreadmill() -- Line: 332
    -- upvalues: PlotCmds (copy), u15 (copy), u2 (ref), u4 (ref), u6 (ref), Workspace (copy), u10 (ref), LocalPlayer (copy), u5 (copy), RuntimeInstanceRegistry (copy), Network (copy), Treadmills (copy), u1 (copy)
    local v59 = PlotCmds.GetMySlot();
    local u60;

    if v59 == nil then
        u60 = nil;
    else
        u60 = u15[v59];
    end;

    if u2 ~= nil or (u4 or (u6 or u60 == nil)) then
        return;
    end;

    local v61 = Workspace:GetServerTimeNow();

    if v61 < u10 then
        return;
    end;

    local Character = LocalPlayer.Character;
    local v62;

    if Character == nil then
        v62 = nil;
    else
        v62 = Character:FindFirstChild("HumanoidRootPart");
    end;

    if v62 == nil or not v62:IsA("BasePart") then
        return;
    end;

    local v63 = RaycastParams.new();
    v63.FilterType = Enum.RaycastFilterType.Include;
    v63.FilterDescendantsInstances = { u60.Model, u60.Bottom };

    if Workspace:Raycast(v62.Position, Vector3.new(0, -8, 0), v63) == nil then
        return;
    end;

    u10 = v61 + 1.25;
    u5(function() -- Line: 354
        -- upvalues: RuntimeInstanceRegistry (ref), u60 (copy), Network (ref), Treadmills (ref), u1 (ref)
        RuntimeInstanceRegistry.Set("Treadmill", u60.TreadmillId, u60.Model);
        local v64, v65 = Network.Invoke(Treadmills.REQUEST_EQUIP_STATIC);

        if v64 ~= true then
            RuntimeInstanceRegistry.Clear("Treadmill", u60.TreadmillId);
            u1:AtWarning():Log((`Static treadmill entry rejected: {v65}`));
        end;
    end);
end;

if not Save.IsLocalDataLoaded() then
    Save.LoadedStats:Wait();
end;

local v66 = Save.Get();
assert(v66 ~= nil, "Static treadmill controller requires local save data");
local TreadmillUpgradeLevel = v66.TreadmillUpgradeLevel;
u7 = v66.BaseUpgradeLevel;
Network.Fired(Treadmills.ACTIVE_RENDER_STATE_EVENT):Connect(function(p67, p68, p69) -- Line: 375
    -- upvalues: Asserts (copy), u8 (ref), u14 (copy), u9 (ref), LocalPlayer (copy), u3 (copy), refreshPlayerRender (copy)
    Asserts.Player(p67);
    Asserts.boolean(p68);
    Asserts.number(p69);

    if u8 then
        table.insert(u14, {
            Active = p68,
            Player = p67,
            Revision = p69
        });

        return;
    end;

    if p69 <= u9 then
        return;
    end;

    u9 = p69;

    if p67 == LocalPlayer then
        return;
    end;

    if p68 then
        u3[p67.UserId] = true;
    else
        u3[p67.UserId] = nil;
    end;

    refreshPlayerRender(p67, false);
end);
synchronizeRemoteSessionSnapshot();

for i, v in pairs(PlotCmds.GetState()) do
    task.spawn(refreshSlot, i, v, false);
end;

LocalPlotUpgradeVisibility.Refresh("TreadmillUpgrade", u7 > 0);
PlotCmds.OnAnyPlotUpdated:Connect(function(p70, p71) -- Line: 395
    -- upvalues: LocalPlotUpgradeVisibility (copy), u7 (ref), refreshSlot (copy)
    LocalPlotUpgradeVisibility.Refresh("TreadmillUpgrade", u7 > 0);
    task.spawn(refreshSlot, p70, p71, false);
end);
PlotCmds.OnPlotsFolderUpdated:Connect(function() -- Line: 399
    -- upvalues: LocalPlotUpgradeVisibility (copy), u7 (ref), PlotCmds (copy), refreshSlot (copy)
    LocalPlotUpgradeVisibility.Refresh("TreadmillUpgrade", u7 > 0);

    for i, v in pairs(PlotCmds.GetState()) do
        task.spawn(refreshSlot, i, v, false);
    end;
end);
Players.PlayerAdded:Connect(function(p72) -- Line: 405
    -- upvalues: refreshPlayerRender (copy)
    task.spawn(refreshPlayerRender, p72, false);
end);
Players.PlayerRemoving:Connect(function(p73) -- Line: 408
    -- upvalues: u3 (copy), u15 (copy), u16 (copy), destroyRender (copy)
    u3[p73.UserId] = nil;

    for i, v in pairs(u15) do
        if v and v.OwnerUserId == p73.UserId then
            u16[i] = (u16[i] or 0) + 1;
            destroyRender(i);
        end;
    end;
end);
Save.LoadedOtherStats:Connect(function(p74) -- Line: 417
    -- upvalues: refreshPlayerRender (copy)
    refreshPlayerRender(p74, false);
end);
Save.OtherStatChanged:Connect(function(p75, p76) -- Line: 420
    -- upvalues: refreshPlayerRender (copy), Save (copy), u15 (copy), TreadmillStaticCover (copy)
    if p76 == "TreadmillUpgradeLevel" then
        refreshPlayerRender(p75, false);

        return;
    end;

    if p76 == "TreadmillMediaFeedState" then
        local v77 = Save.Get(p75, false);

        if v77 ~= nil then
            for _, v in pairs(u15) do
                if v and (v.OwnerUserId == p75.UserId and v.Cover ~= nil) then
                    TreadmillStaticCover.ApplyFeed(v.Cover, v77.TreadmillMediaFeedState);
                end;
            end;
        end;
    end;
end);
Save.GetStatChangedSignal("TreadmillUpgradeLevel"):Connect(function() -- Line: 434
    -- upvalues: Save (copy), TreadmillUpgradeLevel (ref), LocalPlotUpgradeVisibility (copy), u7 (ref), u2 (ref), u4 (ref), u11 (ref), u12 (ref), u6 (ref), refreshPlayerRender (copy), LocalPlayer (copy), u10 (ref), Workspace (copy)
    local v78 = Save.Get();
    assert(v78 ~= nil, "Local treadmill upgrade requires save data");
    local v79 = TreadmillUpgradeLevel < v78.TreadmillUpgradeLevel;
    TreadmillUpgradeLevel = v78.TreadmillUpgradeLevel;
    LocalPlotUpgradeVisibility.Refresh("TreadmillUpgrade", u7 > 0);

    if u2 == nil and not u4 then
        u6 = true;
        refreshPlayerRender(LocalPlayer, v79);
        u6 = false;

        return;
    end;

    u11 = true;
    u12 = u12 or v79;

    if u4 and u11 then
        if u2 ~= nil then
            return;
        end;

        local v80 = u12;
        u4 = false;
        u11 = false;
        u12 = false;
        u6 = true;
        refreshPlayerRender(LocalPlayer, v80);
        u6 = false;
        u10 = Workspace:GetServerTimeNow() + 1.25;
    end;
end);
Save.GetStatChangedSignal("BaseUpgradeLevel"):Connect(function() -- Line: 448
    -- upvalues: Save (copy), u7 (ref), LocalPlotUpgradeVisibility (copy), BaseUpgradeTransitionLifecycle (copy), u13 (ref), u6 (ref), refreshPlayerRender (copy), LocalPlayer (copy), u10 (ref), Workspace (copy)
    local v81 = Save.Get();
    assert(v81 ~= nil, "Local base upgrade requires save data");
    local v82;

    if u7 == 0 then
        v82 = v81.BaseUpgradeLevel > 0;
    else
        v82 = false;
    end;

    u7 = v81.BaseUpgradeLevel;

    if not v82 then
        LocalPlotUpgradeVisibility.Refresh("TreadmillUpgrade", u7 > 0);

        return;
    end;

    if BaseUpgradeTransitionLifecycle.IsPlaying() then
        u7 = 0;
        u13 = true;
        LocalPlotUpgradeVisibility.Refresh("TreadmillUpgrade", u7 > 0);

        return;
    end;

    local v83 = Save.Get();
    assert(v83 ~= nil, "First expansion treadmill reveal requires local save data");

    if v83.BaseUpgradeLevel == 0 then
        return;
    end;

    u7 = v83.BaseUpgradeLevel;
    u13 = false;
    LocalPlotUpgradeVisibility.Refresh("TreadmillUpgrade", u7 > 0);
    u6 = true;
    refreshPlayerRender(LocalPlayer, true);
    u6 = false;
    u10 = Workspace:GetServerTimeNow() + 1.25;
end);
BaseUpgradeTransitionLifecycle.Completed:Connect(function() -- Line: 466
    -- upvalues: u13 (ref), Save (copy), u7 (ref), LocalPlotUpgradeVisibility (copy), u6 (ref), refreshPlayerRender (copy), LocalPlayer (copy), u10 (ref), Workspace (copy)
    if u13 then
        local v84 = Save.Get();
        assert(v84 ~= nil, "First expansion treadmill reveal requires local save data");

        if v84.BaseUpgradeLevel == 0 then
            return;
        end;

        u7 = v84.BaseUpgradeLevel;
        u13 = false;
        LocalPlotUpgradeVisibility.Refresh("TreadmillUpgrade", u7 > 0);
        u6 = true;
        refreshPlayerRender(LocalPlayer, true);
        u6 = false;
        u10 = Workspace:GetServerTimeNow() + 1.25;
    end;
end);
Network.Fired(Treadmills.ACTIVE_TREADMILL_EVENT):Connect(function(p85, p86, p87, p88, p89) -- Line: 472
    -- upvalues: u2 (ref), PlotCmds (copy), u15 (copy), RuntimeInstanceRegistry (copy), u10 (ref), Workspace (copy), u4 (ref), u11 (ref), u12 (ref), u6 (ref), refreshPlayerRender (copy), LocalPlayer (copy), TreadmillStaticCover (copy)
    u2 = p85;

    if p85 == nil then
        RuntimeInstanceRegistry.Clear("Treadmill");
        u10 = Workspace:GetServerTimeNow() + 1.25;

        if p89 == true then
            u4 = true;

            if u4 and (u11 and u2 == nil) then
                local v90 = u12;
                u4 = false;
                u11 = false;
                u12 = false;
                u6 = true;
                refreshPlayerRender(LocalPlayer, v90);
                u6 = false;
                u10 = Workspace:GetServerTimeNow() + 1.25;
            end;
        end;
    else
        local v91 = PlotCmds.GetMySlot();
        local v92;

        if v91 == nil then
            v92 = nil;
        else
            v92 = u15[v91];
        end;

        local v93;

        if v92 == nil then
            v93 = false;
        else
            v93 = v92.TreadmillId == p85;
        end;

        local v94 = `Missing active treadmill render "{p85}"`;
        assert(v93, v94);
        RuntimeInstanceRegistry.Set("Treadmill", p85, v92.Model);
    end;

    local v95 = PlotCmds.GetMySlot();
    local v96;

    if v95 == nil then
        v96 = nil;
    else
        v96 = u15[v95];
    end;

    if v96 ~= nil then
        v96.RateSign.Enabled = p85 == nil;
        local Cover = v96.Cover;

        if Cover ~= nil then
            TreadmillStaticCover.SetEnabled(Cover, p85 == nil);
        end;
    end;
end);
TreadmillVideoController.MediaChanged:Connect(function(p97) -- Line: 505
    -- upvalues: PlotCmds (copy), u15 (copy), TreadmillStaticCover (copy)
    local v98 = PlotCmds.GetMySlot();
    local v99;

    if v98 == nil then
        v99 = nil;
    else
        v99 = u15[v98];
    end;

    if v99 ~= nil then
        local Cover = v99.Cover;

        if Cover ~= nil then
            TreadmillStaticCover.ApplyMedia(Cover, p97);
        end;
    end;
end);
RunService.Heartbeat:Connect(tryEnterStaticTreadmill);