-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ExplorerAccess = require(ReplicatedStorage.SharedModules.ExplorerAccess);
local ExplorerFlags = require(ReplicatedStorage.SharedModules.Flags.ExplorerFlags);
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local WorldRelease = require(ReplicatedStorage.SharedModules.WorldRelease);
local LocalPlayer = Players.LocalPlayer;
local EventWorldsTeleporterController = require(LocalPlayer.PlayerScripts.Controllers.EventWorldsTeleporterController);
local u1 = {
    StartOrder = 6
};
local u2 = {};
local u3 = false;

local function shortcutOpen() -- Line: 55
    -- upvalues: ExplorerFlags (copy), ExplorerAccess (copy), WorldRelease (copy), LocalPlayer (copy)
    if not ExplorerFlags.MailboxPromptEnabled:Get() then
        return false;
    end;

    if ExplorerAccess.IsAvailable() then
        return WorldRelease.MenuUnlocked(LocalPlayer.UserId);
    end;

    return false;
end;

local function watchCountdown() -- Line: 69
    -- upvalues: u3 (ref), WorldRelease (copy), u1 (copy)
    if u3 then
        return;
    end;

    u3 = true;
    task.spawn(function() -- Line: 74
        -- upvalues: WorldRelease (ref), u3 (ref), u1 (ref)
        while WorldRelease.IsGateActive() and not WorldRelease.IsOpen() do
            task.wait(1);
        end;

        u3 = false;
        u1:Refresh();
    end);
end;

function u1.Refresh(p4) -- Line: 83
    -- upvalues: ExplorerFlags (copy), ExplorerAccess (copy), WorldRelease (copy), LocalPlayer (copy), u2 (copy), u3 (ref), u1 (copy)
    local v5;

    if ExplorerFlags.MailboxPromptEnabled:Get() and ExplorerAccess.IsAvailable() then
        v5 = WorldRelease.MenuUnlocked(LocalPlayer.UserId);
    else
        v5 = false;
    end;

    for i, v in u2 do
        if i.Parent == nil or v.Parent == nil then
            u2[i] = nil;
        else
            v.Enabled = v5;
            local v6;

            if v5 then
                v6 = Vector2.new(0, -35);
            else
                v6 = Vector2.zero;
            end;

            i.UIOffset = v6;
        end;
    end;

    if not v5 and (WorldRelease.IsGateActive() and not WorldRelease.IsOpen()) then
        if u3 then
            return;
        end;

        u3 = true;
        task.spawn(function() -- Line: 74
            -- upvalues: WorldRelease (ref), u3 (ref), u1 (ref)
            while WorldRelease.IsGateActive() and not WorldRelease.IsOpen() do
                task.wait(1);
            end;

            u3 = false;
            u1:Refresh();
        end);
    end;
end;

local function bindMailboxPrompt(p7) -- Line: 103
    -- upvalues: u2 (copy), ExplorerFlags (copy), ExplorerAccess (copy), WorldRelease (copy), LocalPlayer (copy), EventWorldsTeleporterController (copy)
    local Parent = p7.Parent;

    if Parent == nil or u2[p7] ~= nil then
        return;
    end;

    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.Name = "MailboxTravelPrompt";
    ProximityPrompt.ObjectText = "Event Worlds";
    ProximityPrompt.ActionText = "Travel";
    ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.F;
    ProximityPrompt.GamepadKeyCode = Enum.KeyCode.ButtonY;
    ProximityPrompt.HoldDuration = 0;
    ProximityPrompt.MaxActivationDistance = p7.MaxActivationDistance;
    ProximityPrompt.RequiresLineOfSight = p7.RequiresLineOfSight;
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
    ProximityPrompt.UIOffset = Vector2.new(0, 35);
    ProximityPrompt.Enabled = false;
    ProximityPrompt.Parent = Parent;
    ProximityPrompt.Triggered:Connect(function() -- Line: 129
        -- upvalues: ExplorerFlags (ref), ExplorerAccess (ref), WorldRelease (ref), LocalPlayer (ref), EventWorldsTeleporterController (ref)
        local v8;

        if ExplorerFlags.MailboxPromptEnabled:Get() and ExplorerAccess.IsAvailable() then
            v8 = WorldRelease.MenuUnlocked(LocalPlayer.UserId);
        else
            v8 = false;
        end;

        if not v8 then
            return;
        end;

        EventWorldsTeleporterController:Open();
    end);
    u2[p7] = ProximityPrompt;
end;

function u1.Init(p9) -- Line: 143
end;

function u1.Start(p10) -- Line: 145
    -- upvalues: bindMailboxPrompt (copy), u1 (copy), ExplorerFlags (copy), ExplorerAccess (copy), WorldRelease (copy), FastFlags (copy)
    local Gardens = workspace:WaitForChild("Gardens", 30);

    if not Gardens then
        warn("[MailboxTravelPromptController] workspace.Gardens never arrived; no mailbox travel prompts");

        return;
    end;

    for _, descendant in Gardens:GetDescendants() do
        if descendant:IsA("ProximityPrompt") and descendant.Name == "MailboxPrompt" then
            bindMailboxPrompt(descendant);
        end;
    end;

    Gardens.DescendantAdded:Connect(function(p11) -- Line: 160
        -- upvalues: bindMailboxPrompt (ref), u1 (ref)
        if p11:IsA("ProximityPrompt") and p11.Name == "MailboxPrompt" then
            bindMailboxPrompt(p11);
            u1:Refresh();
        end;
    end);

    local function refresh() -- Line: 167
        -- upvalues: u1 (ref)
        u1:Refresh();
    end;

    ExplorerFlags.Enabled.Changed:Connect(refresh);
    ExplorerFlags.MailboxPromptEnabled.Changed:Connect(refresh);
    ExplorerFlags.TravelMenuEnabled.Changed:Connect(refresh);
    ExplorerFlags.ReleaseAtUnix.Changed:Connect(refresh);
    workspace:GetAttributeChangedSignal(ExplorerAccess.OverrideAttribute):Connect(refresh);
    workspace:GetAttributeChangedSignal(WorldRelease.ReleaseAtAttribute):Connect(refresh);
    workspace:GetAttributeChangedSignal(WorldRelease.MenuFlagAttribute):Connect(refresh);

    if not FastFlags.IsLoaded() then
        task.spawn(function() -- Line: 184
            -- upvalues: FastFlags (ref), u1 (ref)
            FastFlags.Loaded:Wait();
            u1:Refresh();
        end);
    end;

    u1:Refresh();
end;

return u1;