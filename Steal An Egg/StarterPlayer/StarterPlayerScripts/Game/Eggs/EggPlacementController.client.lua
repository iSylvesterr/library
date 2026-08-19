-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local ActionPromptCmds = require(ReplicatedStorage.Library.Client.ActionPromptCmds);
local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds);
local EggPlacementRaycast = require(ReplicatedStorage.Library.Client.Eggs.EggPlacementRaycast);
local EggToolDisplay = require(ReplicatedStorage.Library.Client.Eggs.EggToolDisplay);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
local PlacedEggRenderer = require(ReplicatedStorage.Library.Client.Eggs.PlacedEggRenderer);
local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Variables = require(ReplicatedStorage.Library.Variables);
local ButtonR2 = Enum.KeyCode.ButtonR2;
local LocalPlayer = Players.LocalPlayer;
local u1 = Trove.new();

local function showInvalidPlacement() -- Line: 36
    -- upvalues: Message (copy)
    Message.Bottom({
        Message = "Cannot place egg here!",
        Time = 2,
        Color = Color3.fromRGB(255, 80, 80)
    });
end;

local function tryPlace(p2) -- Line: 44
    -- upvalues: EggToolDisplay (copy), Message (copy), PlotCmds (copy), EggPlacementRaycast (copy), LocalPlayer (copy), EggCmds (copy), PlacedEggRenderer (copy)
    local v3 = EggToolDisplay.GetToolUid(p2);

    if v3 == nil then
        Message.Bottom({
            Message = "Cannot place egg here!",
            Time = 2,
            Color = Color3.fromRGB(255, 80, 80)
        });

        return;
    end;

    local v4 = PlotCmds.GetPlotData();

    if v4 == nil then
        Message.Bottom({
            Message = "Cannot place egg here!",
            Time = 2,
            Color = Color3.fromRGB(255, 80, 80)
        });

        return;
    end;

    local PetArea = v4.PetArea;
    local v5 = EggPlacementRaycast.Raycast(PetArea, LocalPlayer.UserId);

    if v5 == nil or v5.Instance ~= PetArea then
        Message.Bottom({
            Message = "Cannot place egg here!",
            Time = 2,
            Color = Color3.fromRGB(255, 80, 80)
        });

        return;
    end;

    local v6 = v4.CenterPoint.CFrame:ToObjectSpace(CFrame.new(v5.Position));
    local v7, v8 = EggCmds.RequestPlaceEgg(v3, v6);

    if v7 then
        PlacedEggRenderer.Refresh();

        return;
    end;

    Message.Bottom({
        Time = 2,
        Message = v8 or "Cannot place egg here!",
        Color = Color3.fromRGB(255, 80, 80)
    });
end;

local function canPlaceFromHere() -- Line: 78
    -- upvalues: Variables (copy), LocalPlayer (copy), PlotCmds (copy)
    if not Variables.Console then
        return false;
    end;

    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if Character == nil or not Character:IsA("BasePart") then
        return false;
    end;

    return PlotCmds.IsWorldPositionWithinLocalPlotBounds(Character.Position);
end;

local function refreshPlacePrompt() -- Line: 92
    -- upvalues: Variables (copy), LocalPlayer (copy), PlotCmds (copy), ActionPromptCmds (copy), ButtonR2 (copy)
    local v9;

    if Variables.Console then
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        if Character == nil or not Character:IsA("BasePart") then
            v9 = false;
        else
            v9 = PlotCmds.IsWorldPositionWithinLocalPlotBounds(Character.Position);
        end;
    else
        v9 = false;
    end;

    if v9 then
        ActionPromptCmds.Show("EggPlacement", ButtonR2, "Place Egg");

        return;
    end;

    ActionPromptCmds.Hide("EggPlacement");
end;

local function bindTool(u10) -- Line: 100
    -- upvalues: u1 (copy), tryPlace (copy), RunService (copy), Variables (copy), LocalPlayer (copy), PlotCmds (copy), ActionPromptCmds (copy), ButtonR2 (copy)
    u1:Clean();
    u1:Connect(u10.Activated, function() -- Line: 102
        -- upvalues: tryPlace (ref), u10 (copy)
        tryPlace(u10);
    end);
    local u11 = 0;
    u1:Connect(RunService.Heartbeat, function(p12) -- Line: 107
        -- upvalues: u11 (ref), Variables (ref), LocalPlayer (ref), PlotCmds (ref), ActionPromptCmds (ref), ButtonR2 (ref)
        u11 = u11 + p12;

        if u11 < 0.2 then
            return;
        end;

        u11 = 0;
        local v13;

        if Variables.Console then
            local Character = LocalPlayer.Character;

            if Character then
                Character = Character:FindFirstChild("HumanoidRootPart");
            end;

            if Character == nil or not Character:IsA("BasePart") then
                v13 = false;
            else
                v13 = PlotCmds.IsWorldPositionWithinLocalPlotBounds(Character.Position);
            end;
        else
            v13 = false;
        end;

        if v13 then
            ActionPromptCmds.Show("EggPlacement", ButtonR2, "Place Egg");

            return;
        end;

        ActionPromptCmds.Hide("EggPlacement");
    end);
    u1:Add(function() -- Line: 115
        -- upvalues: ActionPromptCmds (ref)
        ActionPromptCmds.Hide("EggPlacement");
    end);
    local v14;

    if Variables.Console then
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        if Character == nil or not Character:IsA("BasePart") then
            v14 = false;
        else
            v14 = PlotCmds.IsWorldPositionWithinLocalPlotBounds(Character.Position);
        end;
    else
        v14 = false;
    end;

    if v14 then
        ActionPromptCmds.Show("EggPlacement", ButtonR2, "Place Egg");
    else
        ActionPromptCmds.Hide("EggPlacement");
    end;
end;

local function refreshCharacter(p15) -- Line: 122
    -- upvalues: u1 (copy), EggToolDisplay (copy), bindTool (copy)
    u1:Clean();

    for _, child in ipairs(p15:GetChildren()) do
        if child.ClassName == "Tool" and EggToolDisplay.IsEggTool(child) then
            bindTool(child);

            return;
        end;
    end;
end;

local function bindCharacter(p16) -- Line: 132
    -- upvalues: refreshCharacter (copy), EggToolDisplay (copy), bindTool (copy), u1 (copy)
    refreshCharacter(p16);
    p16.ChildAdded:Connect(function(p17) -- Line: 134
        -- upvalues: EggToolDisplay (ref), bindTool (ref)
        if p17.ClassName == "Tool" and EggToolDisplay.IsEggTool(p17) then
            bindTool(p17);
        end;
    end);
    p16.ChildRemoved:Connect(function(p18) -- Line: 139
        -- upvalues: EggToolDisplay (ref), u1 (ref)
        if p18.ClassName == "Tool" and EggToolDisplay.IsEggTool(p18) then
            u1:Clean();
        end;
    end);
end;

LocalPlayer.CharacterAdded:Connect(bindCharacter);
Network.Fired(Network.NET_MAP.Treadmills.ACTIVE_TREADMILL_EVENT):Connect(function(p19) -- Line: 151
    -- upvalues: PlacedEggRenderer (copy)
    PlacedEggRenderer.SetPromptsSuppressed(p19 ~= nil);
end);

if LocalPlayer.Character ~= nil then
    bindCharacter(LocalPlayer.Character);
end;

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 158
    -- upvalues: LocalPlayer (copy), refreshCharacter (copy)
    local Character = LocalPlayer.Character;

    if Character ~= nil then
        refreshCharacter(Character);
    end;
end);