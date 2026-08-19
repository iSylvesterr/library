-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local IsInBuyArea = require(ReplicatedStorage.Database.Components.Common.IsInBuyArea);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Spring = require(ReplicatedStorage.Shared.Spring);
local u2 = Janitor.new();
local u3 = Spring.new(1, 8, 0);
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;

local function commaNumber(p8) -- Line: 56
    return tostring(p8):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function getTargetPlayer() -- Line: 61
    -- upvalues: LocalPlayer (copy), SpectateController (copy)
    if LocalPlayer:GetAttribute("IsSpectating") then
        local v9 = SpectateController.GetPlayer();

        if v9 and v9 ~= LocalPlayer then
            return v9;
        end;
    end;

    return LocalPlayer;
end;

local function refreshPreferenceColor() -- Line: 71
    -- upvalues: GetPreferenceColor (copy), u6 (ref), u7 (ref)
    local v10 = GetPreferenceColor();

    if u6 == v10 then
        return;
    end;

    u6 = v10;

    if u7 then
        u7.Amount.TextColor3 = v10;
    end;
end;

function u1.CreatePlayerObserver(u11) -- Line: 86
    -- upvalues: u2 (copy), u4 (ref), u3 (copy), Observers (copy)
    u2:Cleanup();
    u4 = u11;
    local v12 = tonumber(u11:GetAttribute("Money"));

    if v12 then
        u3:setGoal(v12);
    end;

    local function noop() -- Line: 95
    end;

    u2:Add(Observers.observeAttribute(u11, "Money", function(p13) -- Line: 97
        -- upvalues: u4 (ref), u11 (copy), noop (copy), u3 (ref)
        if u4 ~= u11 then
            return noop;
        end;

        local v14 = tonumber(p13);

        if v14 then
            u3:setGoal(v14);
        end;

        return noop;
    end));
end;

local function refreshTrackedPlayer() -- Line: 110
    -- upvalues: LocalPlayer (copy), SpectateController (copy), u4 (ref), u1 (copy)
    local v15;

    if LocalPlayer:GetAttribute("IsSpectating") then
        v15 = SpectateController.GetPlayer();

        if not v15 or v15 == LocalPlayer then
            v15 = LocalPlayer;
        end;
    else
        v15 = LocalPlayer;
    end;

    if u4 == v15 then
        return;
    end;

    u1.CreatePlayerObserver(v15);
end;

function u1.Initialize(p16, p17) -- Line: 121
    -- upvalues: u7 (ref), LocalPlayer (copy), refreshTrackedPlayer (copy), refreshPreferenceColor (copy), DataController (copy), GetPreferenceColor (copy), u6 (ref)
    u7 = p17;

    if u7.Active then
        u7.Active = false;
    end;

    for _, descendant in ipairs(u7:GetDescendants()) do
        if descendant:IsA("GuiObject") then
            descendant.Active = false;
        end;
    end;

    LocalPlayer.CharacterAdded:Connect(refreshTrackedPlayer);
    LocalPlayer.CharacterRemoving:Connect(refreshTrackedPlayer);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(refreshPreferenceColor);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", refreshPreferenceColor);
    local v18 = GetPreferenceColor();

    if u6 == v18 then
        return;
    end;

    u6 = v18;

    if u7 then
        u7.Amount.TextColor3 = v18;
    end;
end;

function u1.Start() -- Line: 145
    -- upvalues: SpectateController (copy), refreshTrackedPlayer (copy), LocalPlayer (copy), u4 (ref), u1 (copy), RunServiceController (copy), u3 (copy), u5 (ref), u7 (ref), IsInBuyArea (copy), Router (copy)
    SpectateController.ListenToSpectate:Connect(refreshTrackedPlayer);
    LocalPlayer:GetAttributeChangedSignal("IsSpectating"):Connect(refreshTrackedPlayer);
    local v19;

    if LocalPlayer:GetAttribute("IsSpectating") then
        v19 = SpectateController.GetPlayer();

        if not v19 or v19 == LocalPlayer then
            v19 = LocalPlayer;
        end;
    else
        v19 = LocalPlayer;
    end;

    if u4 ~= v19 then
        u1.CreatePlayerObserver(v19);
    end;

    RunServiceController.BindToHeartbeat("UI.Money.Update", function(p20) -- Line: 154
        -- upvalues: u3 (ref), u5 (ref), u7 (ref), LocalPlayer (ref), IsInBuyArea (ref), Router (ref)
        local v21 = u3:getPosition();
        local v22 = math.round(v21);
        local v23 = tostring(v22):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");

        if v23 ~= u5 then
            u5 = v23;
            u7.Amount.Text = v23;
        end;

        u3:update(p20);

        if not LocalPlayer:GetAttribute("BuyMenu") then
            if u7.Buy.Visible then
                u7.Buy.Visible = false;
            end;

            return;
        end;

        local Visible = u7.Buy.Visible;
        local v24 = IsInBuyArea(LocalPlayer);

        if Visible ~= v24 then
            u7.Buy.Visible = v24;
        end;

        if not Visible or v24 then
            return;
        end;

        Router.broadcastRouter("CreateNotification", "You have left the buy zone", "You have left the buy zone", 2);
    end);
end;

return u1;