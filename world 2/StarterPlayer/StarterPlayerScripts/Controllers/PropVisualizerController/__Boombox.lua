-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local u1 = require("../GuiController");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local v2 = nil;
local BoomboxController = script.Parent.Parent:FindFirstChild("BoomboxController");
local u3;

if BoomboxController then
    local v4;
    v4, u3 = pcall(require, BoomboxController);

    if not v4 then
        u3 = v2;
    end;
else
    u3 = v2;
end;

local function isPaused(u5) -- Line: 35
    -- upvalues: HttpService (copy)
    if type(u5) ~= "string" or u5 == "" then
        return false;
    end;

    local success, result = pcall(function() -- Line: 39
        -- upvalues: HttpService (ref), u5 (copy)
        return HttpService:JSONDecode(u5);
    end);

    if success and type(result) == "table" then
        return result.p == true;
    end;

    return false;
end;

local function isBuildActive() -- Line: 50
    -- upvalues: LocalPlayer (copy)
    if LocalPlayer:GetAttribute("PropBuildActive") == true then
        return true;
    end;

    local Character = LocalPlayer.Character;

    if Character then
        for _, child in Character:GetChildren() do
            if child:IsA("Tool") and child:GetAttribute("Build") ~= nil then
                return true;
            end;
        end;
    end;

    return false;
end;

return function(u6) -- Line: 70
    -- upvalues: Players (copy), isBuildActive (copy), LocalPlayer (copy), isPaused (copy), Networking (copy), u3 (ref), u1 (copy), PlayerGui (copy)
    local v7 = u6:GetAttribute("UserId");

    if type(v7) ~= "number" then
        return;
    end;

    local v8;

    repeat
        v8 = Players:GetPlayerByUserId(v7);
    until v8 and u6:IsDescendantOf(workspace);

    assert(v8);

    if v8.UserId ~= Players.LocalPlayer.UserId then
        return;
    end;

    local v9 = u6.PrimaryPart or u6:FindFirstChild("Hitbox") or (u6:FindFirstChild("Primary") or u6:FindFirstChildWhichIsA("BasePart"));

    if not v9 then
        return;
    end;

    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.Name = "BoomboxPlayPause";
    ProximityPrompt.ObjectText = "Boombox";
    ProximityPrompt.ActionText = "Pause";
    ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.E;
    ProximityPrompt.GamepadKeyCode = Enum.KeyCode.ButtonX;
    ProximityPrompt.HoldDuration = 0;
    ProximityPrompt.RequiresLineOfSight = false;
    ProximityPrompt.MaxActivationDistance = 12;
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
    ProximityPrompt.UIOffset = Vector2.new(0, -35);
    ProximityPrompt.Parent = v9;
    local ProximityPrompt2 = Instance.new("ProximityPrompt");
    ProximityPrompt2.Name = "BoomboxEdit";
    ProximityPrompt2.ObjectText = "Boombox";
    ProximityPrompt2.ActionText = "Edit";
    ProximityPrompt2.KeyboardKeyCode = Enum.KeyCode.F;
    ProximityPrompt2.GamepadKeyCode = Enum.KeyCode.ButtonY;
    ProximityPrompt2.HoldDuration = 0;
    ProximityPrompt2.RequiresLineOfSight = false;
    ProximityPrompt2.MaxActivationDistance = 12;
    ProximityPrompt2.Style = Enum.ProximityPromptStyle.Custom;
    ProximityPrompt2.UIOffset = Vector2.new(0, 35);
    ProximityPrompt2.Parent = v9;
    local u10 = false;

    local function shouldHide() -- Line: 127
        -- upvalues: u10 (ref), isBuildActive (ref)
        return u10 or isBuildActive();
    end;

    local function refreshPrompts() -- Line: 130
        -- upvalues: ProximityPrompt (copy), ProximityPrompt2 (copy), u10 (ref), isBuildActive (ref)
        if not (ProximityPrompt.Parent and ProximityPrompt2.Parent) then
            return;
        end;

        local v11 = not (u10 or isBuildActive());
        ProximityPrompt.Enabled = v11;
        ProximityPrompt2.Enabled = v11;
    end;

    LocalPlayer:GetAttributeChangedSignal("PropBuildActive"):Connect(refreshPrompts);

    local function bindCharacter(p12) -- Line: 142
        -- upvalues: ProximityPrompt (copy), ProximityPrompt2 (copy), u10 (ref), isBuildActive (ref)
        p12.ChildAdded:Connect(function(p13) -- Line: 143
            -- upvalues: ProximityPrompt (ref), ProximityPrompt2 (ref), u10 (ref), isBuildActive (ref)
            if p13:IsA("Tool") and (p13:GetAttribute("Build") ~= nil and ProximityPrompt.Parent) then
                if not ProximityPrompt2.Parent then
                    return;
                end;

                local v14 = not (u10 or isBuildActive());
                ProximityPrompt.Enabled = v14;
                ProximityPrompt2.Enabled = v14;
            end;
        end);
        p12.ChildRemoved:Connect(function(p15) -- Line: 148
            -- upvalues: ProximityPrompt (ref), ProximityPrompt2 (ref), u10 (ref), isBuildActive (ref)
            if p15:IsA("Tool") and (p15:GetAttribute("Build") ~= nil and ProximityPrompt.Parent) then
                if not ProximityPrompt2.Parent then
                    return;
                end;

                local v16 = not (u10 or isBuildActive());
                ProximityPrompt.Enabled = v16;
                ProximityPrompt2.Enabled = v16;
            end;
        end);
    end;

    if LocalPlayer.Character then
        bindCharacter(LocalPlayer.Character);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p17) -- Line: 157
        -- upvalues: bindCharacter (copy), ProximityPrompt (copy), ProximityPrompt2 (copy), u10 (ref), isBuildActive (ref)
        bindCharacter(p17);

        if ProximityPrompt.Parent then
            if not ProximityPrompt2.Parent then
                return;
            end;

            local v18 = not (u10 or isBuildActive());
            ProximityPrompt.Enabled = v18;
            ProximityPrompt2.Enabled = v18;
        end;
    end);

    local function enforce(u19) -- Line: 165
        -- upvalues: u10 (ref), isBuildActive (ref)
        u19:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 166
            -- upvalues: u19 (copy), u10 (ref), isBuildActive (ref)
            if u19.Enabled and (u10 or isBuildActive()) then
                u19.Enabled = false;
            end;
        end);
    end;

    ProximityPrompt:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 166
        -- upvalues: ProximityPrompt (copy), u10 (ref), isBuildActive (ref)
        if ProximityPrompt.Enabled and (u10 or isBuildActive()) then
            ProximityPrompt.Enabled = false;
        end;
    end);
    ProximityPrompt2:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 166
        -- upvalues: ProximityPrompt2 (copy), u10 (ref), isBuildActive (ref)
        if ProximityPrompt2.Enabled and (u10 or isBuildActive()) then
            ProximityPrompt2.Enabled = false;
        end;
    end);

    local function updatePlayPauseLabel() -- Line: 175
        -- upvalues: ProximityPrompt (copy), isPaused (ref), u6 (copy)
        ProximityPrompt.ActionText = isPaused(u6:GetAttribute("ExtraData")) and "Play" or "Pause";
    end;

    ProximityPrompt.ActionText = isPaused(u6:GetAttribute("ExtraData")) and "Play" or "Pause";
    u6:GetAttributeChangedSignal("ExtraData"):Connect(updatePlayPauseLabel);
    ProximityPrompt.Triggered:Connect(function() -- Line: 182
        -- upvalues: Networking (ref), u6 (copy)
        Networking.Boombox.TogglePause:Fire(u6:GetAttribute("PropId"));
    end);
    ProximityPrompt2.Triggered:Connect(function() -- Line: 186
        -- upvalues: u3 (ref), u10 (ref), ProximityPrompt (copy), ProximityPrompt2 (copy), isBuildActive (ref), u6 (copy)
        if not u3 then
            return;
        end;

        u10 = true;

        if ProximityPrompt.Parent and ProximityPrompt2.Parent then
            local v20 = not (u10 or isBuildActive());
            ProximityPrompt.Enabled = v20;
            ProximityPrompt2.Enabled = v20;
        end;

        if not u3:OpenFor(u6:GetAttribute("PropId"), u6:GetAttribute("ExtraData")) then
            u10 = false;

            if ProximityPrompt.Parent then
                if not ProximityPrompt2.Parent then
                    return;
                end;

                local v21 = not (u10 or isBuildActive());
                ProximityPrompt.Enabled = v21;
                ProximityPrompt2.Enabled = v21;
            end;
        end;
    end);

    local function onEditorClosed() -- Line: 204
        -- upvalues: u10 (ref), ProximityPrompt (copy), ProximityPrompt2 (copy), isBuildActive (ref)
        if not u10 then
            return;
        end;

        u10 = false;

        if ProximityPrompt.Parent then
            if not ProximityPrompt2.Parent then
                return;
            end;

            local v22 = not (u10 or isBuildActive());
            ProximityPrompt.Enabled = v22;
            ProximityPrompt2.Enabled = v22;
        end;
    end;

    u1.GuiUnfocusedSignal:Connect(function(p23) -- Line: 210
        -- upvalues: u10 (ref), ProximityPrompt (copy), ProximityPrompt2 (copy), isBuildActive (ref)
        if p23 and p23.Name == "BoomboxConfigMenu" then
            if not u10 then
                return;
            end;

            u10 = false;

            if ProximityPrompt.Parent then
                if not ProximityPrompt2.Parent then
                    return;
                end;

                local v24 = not (u10 or isBuildActive());
                ProximityPrompt.Enabled = v24;
                ProximityPrompt2.Enabled = v24;
            end;
        end;
    end);

    local function watchConfigGui(u25) -- Line: 216
        -- upvalues: u10 (ref), ProximityPrompt (copy), ProximityPrompt2 (copy), isBuildActive (ref)
        if u25.Name ~= "BoomboxConfigMenu" or not u25:IsA("ScreenGui") then
            return;
        end;

        u25:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 218
            -- upvalues: u25 (copy), u10 (ref), ProximityPrompt (ref), ProximityPrompt2 (ref), isBuildActive (ref)
            if not u25.Enabled then
                if not u10 then
                    return;
                end;

                u10 = false;

                if ProximityPrompt.Parent then
                    if not ProximityPrompt2.Parent then
                        return;
                    end;

                    local v26 = not (u10 or isBuildActive());
                    ProximityPrompt.Enabled = v26;
                    ProximityPrompt2.Enabled = v26;
                end;
            end;
        end);
    end;

    local BoomboxConfigMenu = PlayerGui:FindFirstChild("BoomboxConfigMenu");

    if BoomboxConfigMenu then
        watchConfigGui(BoomboxConfigMenu);
    else
        PlayerGui.ChildAdded:Connect(watchConfigGui);
    end;

    if ProximityPrompt.Parent and ProximityPrompt2.Parent then
        local v27 = not (u10 or isBuildActive());
        ProximityPrompt.Enabled = v27;
        ProximityPrompt2.Enabled = v27;
    end;
end;