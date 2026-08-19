-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local InputController = require(ReplicatedStorage.Controllers.InputController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local CenterScreenRaycast = require(ReplicatedStorage.Components.Common.CenterScreenRaycast);
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;

local function FormatKeybind(p6) -- Line: 30
    return not p6 and "E" or p6:gsub("Enum%.KeyCode%.", ""):gsub("Enum%.UserInputType%.", ""):gsub("Enum%.CustomInputType%.", "");
end;

local function IsCharacterAlive(p7) -- Line: 40
    local Character = p7.Character;

    if Character and Character:IsDescendantOf(workspace) then
        local Humanoid = Character:FindFirstChild("Humanoid");

        if Humanoid and Humanoid.Health > 0 then
            return true;
        end;
    end;

    return false;
end;

local function ShouldRunUpdate() -- Line: 53
    -- upvalues: LocalPlayer (copy)
    local v8;

    if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
        local Character = LocalPlayer.Character;

        if Character and Character:IsDescendantOf(workspace) then
            local Humanoid = Character:FindFirstChild("Humanoid");

            if Humanoid and Humanoid.Health > 0 then
                return true;
            end;

            v8 = false;
        else
            v8 = false;
        end;
    else
        v8 = false;
    end;

    return v8;
end;

local function StopUpdateConnection() -- Line: 59
    -- upvalues: u5 (ref)
    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

local function SyncUpdateConnection() -- Line: 68
    -- upvalues: LocalPlayer (copy), u5 (ref), RunServiceController (copy), u2 (ref), u1 (copy)
    local v9;

    if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
        local Character = LocalPlayer.Character;

        if Character and Character:IsDescendantOf(workspace) then
            local Humanoid = Character:FindFirstChild("Humanoid");
            v9 = Humanoid and Humanoid.Health > 0 and true or false;
        else
            v9 = false;
        end;
    else
        v9 = false;
    end;

    if v9 then
        if u5 then
            return;
        end;

        u5 = RunServiceController.BindToHeartbeat("UI.HoverHostage.Update", function(p10) -- Line: 74
            -- upvalues: LocalPlayer (ref), u2 (ref), u5 (ref), u1 (ref)
            local v11;

            if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
                local Character = LocalPlayer.Character;

                if Character and Character:IsDescendantOf(workspace) then
                    local Humanoid = Character:FindFirstChild("Humanoid");
                    v11 = Humanoid and Humanoid.Health > 0 and true or false;
                else
                    v11 = false;
                end;
            else
                v11 = false;
            end;

            if v11 then
                u2.Visible = u1.GetHoverState();

                return;
            end;

            u2.Visible = false;

            if u5 then
                u5:Disconnect();
                u5 = nil;
            end;
        end);

        return;
    end;

    u2.Visible = false;

    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

local function TrackCharacter(p12) -- Line: 93
    -- upvalues: u3 (ref), u4 (ref), SyncUpdateConnection (copy), LocalPlayer (copy), u5 (ref), RunServiceController (copy), u2 (ref), u1 (copy)
    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;

    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    if p12 then
        u3 = p12:GetAttributeChangedSignal("Dead"):Connect(SyncUpdateConnection);
        u4 = p12.ChildAdded:Connect(function(p13) -- Line: 105
            -- upvalues: LocalPlayer (ref), u5 (ref), RunServiceController (ref), u2 (ref), u1 (ref)
            if p13:IsA("Humanoid") then
                local v14;

                if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
                    local Character = LocalPlayer.Character;

                    if Character and Character:IsDescendantOf(workspace) then
                        local Humanoid = Character:FindFirstChild("Humanoid");
                        v14 = Humanoid and Humanoid.Health > 0 and true or false;
                    else
                        v14 = false;
                    end;
                else
                    v14 = false;
                end;

                if v14 then
                    if u5 then
                        return;
                    end;

                    u5 = RunServiceController.BindToHeartbeat("UI.HoverHostage.Update", function(p15) -- Line: 74
                        -- upvalues: LocalPlayer (ref), u2 (ref), u5 (ref), u1 (ref)
                        local v16;

                        if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
                            local Character = LocalPlayer.Character;

                            if Character and Character:IsDescendantOf(workspace) then
                                local Humanoid = Character:FindFirstChild("Humanoid");
                                v16 = Humanoid and Humanoid.Health > 0 and true or false;
                            else
                                v16 = false;
                            end;
                        else
                            v16 = false;
                        end;

                        if v16 then
                            u2.Visible = u1.GetHoverState();

                            return;
                        end;

                        u2.Visible = false;

                        if u5 then
                            u5:Disconnect();
                            u5 = nil;
                        end;
                    end);

                    return;
                end;

                u2.Visible = false;

                if u5 then
                    u5:Disconnect();
                    u5 = nil;
                end;
            end;
        end);
    end;

    local v17;

    if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
        local Character = LocalPlayer.Character;

        if Character and Character:IsDescendantOf(workspace) then
            local Humanoid = Character:FindFirstChild("Humanoid");
            v17 = Humanoid and Humanoid.Health > 0 and true or false;
        else
            v17 = false;
        end;
    else
        v17 = false;
    end;

    if v17 then
        if u5 then
            return;
        end;

        u5 = RunServiceController.BindToHeartbeat("UI.HoverHostage.Update", function(p18) -- Line: 74
            -- upvalues: LocalPlayer (ref), u2 (ref), u5 (ref), u1 (ref)
            local v19;

            if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
                local Character = LocalPlayer.Character;

                if Character and Character:IsDescendantOf(workspace) then
                    local Humanoid = Character:FindFirstChild("Humanoid");
                    v19 = Humanoid and Humanoid.Health > 0 and true or false;
                else
                    v19 = false;
                end;
            else
                v19 = false;
            end;

            if v19 then
                u2.Visible = u1.GetHoverState();

                return;
            end;

            u2.Visible = false;

            if u5 then
                u5:Disconnect();
                u5 = nil;
            end;
        end);

        return;
    end;

    u2.Visible = false;

    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

function u1.GetHoverState() -- Line: 118
    -- upvalues: CenterScreenRaycast (copy)
    return CenterScreenRaycast.GetHoveredHostage(5) ~= nil;
end;

function u1.Initialize(p20, p21) -- Line: 125
    -- upvalues: u2 (ref), InputController (copy), DataController (copy), LocalPlayer (copy), SyncUpdateConnection (copy), TrackCharacter (copy), u3 (ref), u4 (ref), u5 (ref), RunServiceController (copy), u1 (copy)
    u2 = p21;

    local function UpdateFrameText() -- Line: 129
        -- upvalues: InputController (ref), u2 (ref)
        local v22 = InputController.GetActionKeybind("Use");
        u2.Text = `[{not v22 and "E" or v22:gsub("Enum%.KeyCode%.", ""):gsub("Enum%.UserInputType%.", ""):gsub("Enum%.CustomInputType%.", "")}] Pick Up Hostage`;
    end;

    local v23 = InputController.GetActionKeybind("Use");
    u2.Text = `[{not v23 and "E" or v23:gsub("Enum%.KeyCode%.", ""):gsub("Enum%.UserInputType%.", ""):gsub("Enum%.CustomInputType%.", "")}] Pick Up Hostage`;
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", function(p24) -- Line: 138
        -- upvalues: UpdateFrameText (copy)
        if not p24 then
            return;
        end;

        task.defer(UpdateFrameText);
    end);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(SyncUpdateConnection);
    LocalPlayer.CharacterAdded:Connect(TrackCharacter);
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 148
        -- upvalues: u3 (ref), u4 (ref), LocalPlayer (ref), u5 (ref), RunServiceController (ref), u2 (ref), u1 (ref)
        if u3 then
            u3:Disconnect();
            u3 = nil;
        end;

        if u4 then
            u4:Disconnect();
            u4 = nil;
        end;

        local v25;

        if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
            local Character = LocalPlayer.Character;

            if Character and Character:IsDescendantOf(workspace) then
                local Humanoid = Character:FindFirstChild("Humanoid");
                v25 = Humanoid and Humanoid.Health > 0 and true or false;
            else
                v25 = false;
            end;
        else
            v25 = false;
        end;

        if v25 then
            if u5 then
                return;
            end;

            u5 = RunServiceController.BindToHeartbeat("UI.HoverHostage.Update", function(p26) -- Line: 74
                -- upvalues: LocalPlayer (ref), u2 (ref), u5 (ref), u1 (ref)
                local v27;

                if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
                    local Character = LocalPlayer.Character;

                    if Character and Character:IsDescendantOf(workspace) then
                        local Humanoid = Character:FindFirstChild("Humanoid");
                        v27 = Humanoid and Humanoid.Health > 0 and true or false;
                    else
                        v27 = false;
                    end;
                else
                    v27 = false;
                end;

                if v27 then
                    u2.Visible = u1.GetHoverState();

                    return;
                end;

                u2.Visible = false;

                if u5 then
                    u5:Disconnect();
                    u5 = nil;
                end;
            end);

            return;
        end;

        u2.Visible = false;

        if u5 then
            u5:Disconnect();
            u5 = nil;
        end;
    end);
    TrackCharacter(LocalPlayer.Character);
end;

return u1;