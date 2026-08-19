-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local InputController = require(ReplicatedStorage.Controllers.InputController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Router = require(ReplicatedStorage.Database.Security.Router);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local u2 = table.find(GetUserPlatform(), "Mobile") and #GetUserPlatform() <= 1;
local u3 = nil;
local u4 = false;
local u5 = nil;
local u6 = nil;

local function IsCharacterAlive(p7) -- Line: 37
    local Character = p7.Character;

    if Character and Character:IsDescendantOf(workspace) then
        local Humanoid = Character:FindFirstChild("Humanoid");

        if Humanoid and Humanoid.Health > 0 then
            return true;
        end;
    end;

    return false;
end;

local function FormatKeybind(p8) -- Line: 50
    return not p8 and "E" or p8:gsub("Enum%.KeyCode%.", ""):gsub("Enum%.UserInputType%.", ""):gsub("Enum%.CustomInputType%.", "");
end;

local function IsBombResolved(p9) -- Line: 60
    if p9 then
        return (p9:GetAttribute("Defused") == true or p9:GetAttribute("Exploding") == true) and true or p9:GetAttribute("Exploded") == true;
    end;

    return false;
end;

local function GetActiveBomb() -- Line: 72
    -- upvalues: CollectionService (copy)
    local v10 = CollectionService:GetTagged("Bomb")[1];

    if v10 then
        local v11;

        if v10 then
            v11 = (v10:GetAttribute("Defused") == true or v10:GetAttribute("Exploding") == true) and true or v10:GetAttribute("Exploded") == true;
        else
            v11 = false;
        end;

        if not v11 then
            return v10;
        end;
    end;

    return nil;
end;

local function ShouldRunUpdate() -- Line: 83
    -- upvalues: LocalPlayer (copy), CollectionService (copy)
    local v12;

    if workspace:GetAttribute("Gamemode") == "Bomb Defusal" and LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
        local v13 = CollectionService:GetTagged("Bomb")[1];

        if v13 then
            local v14;

            if v13 then
                v14 = (v13:GetAttribute("Defused") == true or v13:GetAttribute("Exploding") == true) and true or v13:GetAttribute("Exploded") == true;
            else
                v14 = false;
            end;

            if v14 then
                v13 = nil;
            end;
        else
            v13 = nil;
        end;

        v12 = v13 ~= nil;
    else
        v12 = false;
    end;

    return v12;
end;

local function StopUpdateConnection() -- Line: 91
    -- upvalues: u6 (ref)
    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;
end;

local function CancelMobileDefuseIfNeeded() -- Line: 100
    -- upvalues: u2 (copy), u4 (ref), CollectionService (copy), u3 (ref), Router (copy)
    if not (u2 and u4) then
        return;
    end;

    local v15 = CollectionService:GetTagged("Bomb")[1];
    local v16;

    if v15 then
        v16 = (v15:GetAttribute("Defused") == true or v15:GetAttribute("Exploding") == true) and true or v15:GetAttribute("Exploded") == true;
    else
        v16 = false;
    end;

    u4 = false;
    u3 = nil;

    if not v16 then
        Router.broadcastRouter("Cancel Defuse Bomb");
    end;
end;

local function SyncUpdateConnection() -- Line: 118
    -- upvalues: LocalPlayer (copy), CollectionService (copy), u6 (ref), RunServiceController (copy), u5 (ref), u2 (copy), u4 (ref), u3 (ref), Router (copy), u1 (copy)
    local v17;

    if workspace:GetAttribute("Gamemode") == "Bomb Defusal" and LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
        local v18 = CollectionService:GetTagged("Bomb")[1];

        if v18 then
            local v19;

            if v18 then
                v19 = (v18:GetAttribute("Defused") == true or v18:GetAttribute("Exploding") == true) and true or v18:GetAttribute("Exploded") == true;
            else
                v19 = false;
            end;

            if v19 then
                v18 = nil;
            end;
        else
            v18 = nil;
        end;

        v17 = v18 ~= nil;
    else
        v17 = false;
    end;

    if v17 then
        if u6 then
            return;
        end;

        u6 = RunServiceController.BindToHeartbeat("UI.HoverBomb.Update", function(p20) -- Line: 124
            -- upvalues: LocalPlayer (ref), CollectionService (ref), u5 (ref), u2 (ref), u4 (ref), u3 (ref), Router (ref), u6 (ref), u1 (ref)
            local v21;

            if workspace:GetAttribute("Gamemode") == "Bomb Defusal" and LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
                local v22 = CollectionService:GetTagged("Bomb")[1];

                if v22 then
                    local v23;

                    if v22 then
                        v23 = (v22:GetAttribute("Defused") == true or v22:GetAttribute("Exploding") == true) and true or v22:GetAttribute("Exploded") == true;
                    else
                        v23 = false;
                    end;

                    if v23 then
                        v22 = nil;
                    end;
                else
                    v22 = nil;
                end;

                v21 = v22 ~= nil;
            else
                v21 = false;
            end;

            if v21 then
                local Character = LocalPlayer.Character;
                local v24;

                if Character and Character:IsDescendantOf(workspace) then
                    local Humanoid = Character:FindFirstChild("Humanoid");
                    v24 = Humanoid and Humanoid.Health > 0 and true or false;
                else
                    v24 = false;
                end;

                if v24 then
                    local v25 = u1.GetHoverState();
                    u5.Visible = v25;

                    if u2 and (u4 and (not v25 and u2)) then
                        if not u4 then
                            return;
                        end;

                        local v26 = CollectionService:GetTagged("Bomb")[1];
                        local v27;

                        if v26 then
                            v27 = (v26:GetAttribute("Defused") == true or v26:GetAttribute("Exploding") == true) and true or v26:GetAttribute("Exploded") == true;
                        else
                            v27 = false;
                        end;

                        u4 = false;
                        u3 = nil;

                        if not v27 then
                            Router.broadcastRouter("Cancel Defuse Bomb");

                            return;
                        end;
                    end;
                else
                    u5.Visible = false;

                    if u2 and u4 then
                        u4 = false;
                        u3 = nil;
                    end;
                end;

                return;
            end;

            u5.Visible = false;

            if u2 and u4 then
                local v28 = CollectionService:GetTagged("Bomb")[1];
                local v29;

                if v28 then
                    v29 = (v28:GetAttribute("Defused") == true or v28:GetAttribute("Exploding") == true) and true or v28:GetAttribute("Exploded") == true;
                else
                    v29 = false;
                end;

                u4 = false;
                u3 = nil;

                if not v29 then
                    Router.broadcastRouter("Cancel Defuse Bomb");
                end;
            end;

            if u6 then
                u6:Disconnect();
                u6 = nil;
            end;
        end);

        return;
    end;

    u5.Visible = false;

    if u2 and u4 then
        local v30 = CollectionService:GetTagged("Bomb")[1];
        local v31;

        if v30 then
            v31 = (v30:GetAttribute("Defused") == true or v30:GetAttribute("Exploding") == true) and true or v30:GetAttribute("Exploded") == true;
        else
            v31 = false;
        end;

        u4 = false;
        u3 = nil;

        if not v31 then
            Router.broadcastRouter("Cancel Defuse Bomb");
        end;
    end;

    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;
end;

function u1.GetHoverState() -- Line: 158
    -- upvalues: LocalPlayer (copy), CollectionService (copy), u2 (copy), u4 (ref)
    if LocalPlayer:GetAttribute("Team") ~= "Counter-Terrorists" then
        return false;
    end;

    local v32 = CollectionService:GetTagged("Bomb")[1];

    if not v32 then
        return false;
    end;

    local v33;

    if v32 then
        v33 = (v32:GetAttribute("Defused") == true or v32:GetAttribute("Exploding") == true) and true or v32:GetAttribute("Exploded") == true;
    else
        v33 = false;
    end;

    if v33 then
        return false;
    end;

    return u2 and (u4 or LocalPlayer:GetAttribute("IsDefusingBomb") == true) and true or (v32:GetAttribute("CanDefuse") and not v32:GetAttribute("IsGettingDefused") and true or false);
end;

function u1.Initialize(p34, p35) -- Line: 185
    -- upvalues: u5 (ref), u2 (copy), InputController (copy), DataController (copy), LocalPlayer (copy), SyncUpdateConnection (copy), CollectionService (copy), u6 (ref), RunServiceController (copy), u4 (ref), u3 (ref), Router (copy), u1 (copy), UserInputService (copy)
    u5 = p35;

    local function UpdateFrameText() -- Line: 189
        -- upvalues: u2 (ref), u5 (ref), InputController (ref)
        if u2 then
            u5.Text = "Hold to Defuse";

            return;
        end;

        local v36 = InputController.GetActionKeybind("Use");
        u5.Text = `[{not v36 and "E" or v36:gsub("Enum%.KeyCode%.", ""):gsub("Enum%.UserInputType%.", ""):gsub("Enum%.CustomInputType%.", "")}] Defuse Bomb`;
    end;

    if u2 then
        u5.Text = "Hold to Defuse";
    else
        local v37 = InputController.GetActionKeybind("Use");
        u5.Text = `[{not v37 and "E" or v37:gsub("Enum%.KeyCode%.", ""):gsub("Enum%.UserInputType%.", ""):gsub("Enum%.CustomInputType%.", "")}] Defuse Bomb`;
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", function(p38) -- Line: 202
        -- upvalues: UpdateFrameText (copy)
        if not p38 then
            return;
        end;

        task.defer(UpdateFrameText);
    end);
    LocalPlayer:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 211
        -- upvalues: LocalPlayer (ref), u5 (ref)
        if LocalPlayer:GetAttribute("Dead") then
            u5.Visible = false;
        end;
    end);
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 218
        -- upvalues: u5 (ref)
        u5.Visible = false;
    end);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(SyncUpdateConnection);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(SyncUpdateConnection);
    LocalPlayer.CharacterAdded:Connect(SyncUpdateConnection);
    LocalPlayer.CharacterRemoving:Connect(SyncUpdateConnection);
    CollectionService:GetInstanceAddedSignal("Bomb"):Connect(SyncUpdateConnection);
    CollectionService:GetInstanceRemovedSignal("Bomb"):Connect(SyncUpdateConnection);
    local v39;

    if workspace:GetAttribute("Gamemode") == "Bomb Defusal" and LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
        local v40 = CollectionService:GetTagged("Bomb")[1];

        if v40 then
            local v41;

            if v40 then
                v41 = (v40:GetAttribute("Defused") == true or v40:GetAttribute("Exploding") == true) and true or v40:GetAttribute("Exploded") == true;
            else
                v41 = false;
            end;

            if v41 then
                v40 = nil;
            end;
        else
            v40 = nil;
        end;

        v39 = v40 ~= nil;
    else
        v39 = false;
    end;

    if v39 then
        if not u6 then
            u6 = RunServiceController.BindToHeartbeat("UI.HoverBomb.Update", function(p42) -- Line: 124
                -- upvalues: LocalPlayer (ref), CollectionService (ref), u5 (ref), u2 (ref), u4 (ref), u3 (ref), Router (ref), u6 (ref), u1 (ref)
                local v43;

                if workspace:GetAttribute("Gamemode") == "Bomb Defusal" and LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
                    local v44 = CollectionService:GetTagged("Bomb")[1];

                    if v44 then
                        local v45;

                        if v44 then
                            v45 = (v44:GetAttribute("Defused") == true or v44:GetAttribute("Exploding") == true) and true or v44:GetAttribute("Exploded") == true;
                        else
                            v45 = false;
                        end;

                        if v45 then
                            v44 = nil;
                        end;
                    else
                        v44 = nil;
                    end;

                    v43 = v44 ~= nil;
                else
                    v43 = false;
                end;

                if v43 then
                    local Character = LocalPlayer.Character;
                    local v46;

                    if Character and Character:IsDescendantOf(workspace) then
                        local Humanoid = Character:FindFirstChild("Humanoid");
                        v46 = Humanoid and Humanoid.Health > 0 and true or false;
                    else
                        v46 = false;
                    end;

                    if v46 then
                        local v47 = u1.GetHoverState();
                        u5.Visible = v47;

                        if u2 and (u4 and (not v47 and u2)) then
                            if not u4 then
                                return;
                            end;

                            local v48 = CollectionService:GetTagged("Bomb")[1];
                            local v49;

                            if v48 then
                                v49 = (v48:GetAttribute("Defused") == true or v48:GetAttribute("Exploding") == true) and true or v48:GetAttribute("Exploded") == true;
                            else
                                v49 = false;
                            end;

                            u4 = false;
                            u3 = nil;

                            if not v49 then
                                Router.broadcastRouter("Cancel Defuse Bomb");

                                return;
                            end;
                        end;
                    else
                        u5.Visible = false;

                        if u2 and u4 then
                            u4 = false;
                            u3 = nil;
                        end;
                    end;

                    return;
                end;

                u5.Visible = false;

                if u2 and u4 then
                    local v50 = CollectionService:GetTagged("Bomb")[1];
                    local v51;

                    if v50 then
                        v51 = (v50:GetAttribute("Defused") == true or v50:GetAttribute("Exploding") == true) and true or v50:GetAttribute("Exploded") == true;
                    else
                        v51 = false;
                    end;

                    u4 = false;
                    u3 = nil;

                    if not v51 then
                        Router.broadcastRouter("Cancel Defuse Bomb");
                    end;
                end;

                if u6 then
                    u6:Disconnect();
                    u6 = nil;
                end;
            end);
        end;
    else
        u5.Visible = false;

        if u2 and u4 then
            local v52 = CollectionService:GetTagged("Bomb")[1];
            local v53;

            if v52 then
                v53 = (v52:GetAttribute("Defused") == true or v52:GetAttribute("Exploding") == true) and true or v52:GetAttribute("Exploded") == true;
            else
                v53 = false;
            end;

            u4 = false;
            u3 = nil;

            if not v53 then
                Router.broadcastRouter("Cancel Defuse Bomb");
            end;
        end;

        if u6 then
            u6:Disconnect();
            u6 = nil;
        end;
    end;

    if u2 then
        UserInputService.TouchStarted:Connect(function(p54, p55) -- Line: 233
            -- upvalues: u1 (ref), LocalPlayer (ref), u4 (ref), u3 (ref), Router (ref)
            if p55 then
                return;
            end;

            if u1.GetHoverState() then
                local Character = LocalPlayer.Character;
                local v56;

                if Character and Character:IsDescendantOf(workspace) then
                    local Humanoid = Character:FindFirstChild("Humanoid");
                    v56 = Humanoid and Humanoid.Health > 0 and true or false;
                else
                    v56 = false;
                end;

                if v56 and not u4 then
                    u3 = p54;
                    u4 = true;
                    Router.broadcastRouter("Start Defuse Bomb");
                end;
            end;
        end);
        UserInputService.TouchEnded:Connect(function(p57, p58) -- Line: 248
            -- upvalues: u3 (ref), u4 (ref), Router (ref)
            if p57 == u3 then
                u3 = nil;

                if u4 then
                    u4 = false;
                    Router.broadcastRouter("Cancel Defuse Bomb");
                end;
            end;
        end);
    end;
end;

return u1;