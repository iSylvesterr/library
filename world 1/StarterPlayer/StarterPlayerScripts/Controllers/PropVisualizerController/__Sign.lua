-- Decompiled with Potassium's decompiler.

local Networking = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Networking"));
local Players = game:GetService("Players");
game:GetService("RunService");
local SmartProximityPrompt = require(game:GetService("ReplicatedStorage"):WaitForChild("ClientModules"):WaitForChild("SmartProximityPrompt"));
local u1 = require("../GuiController");
local NotificationController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController);
local SignChangeTextMenu = Players.LocalPlayer.PlayerGui:WaitForChild("SignChangeTextMenu");
local u2 = {};

return function(u3) -- Line: 12
    -- upvalues: Players (copy), SignChangeTextMenu (copy), SmartProximityPrompt (copy), u1 (copy), u2 (copy), NotificationController (copy), Networking (copy)
    while true do
        local v4 = u3:GetAttribute("UserId");
        local v5;

        if typeof(v4) == "number" then
            v5 = game:GetService("Players"):GetPlayerByUserId(v4);
        else
            v5 = nil;
        end;

        local v6;

        if v5 == nil then
            v6 = false;
        else
            v6 = u3:IsDescendantOf(workspace);
        end;

        if not v6 then
            task.wait();
        end;

        if v6 then
            local v7 = v5.UserId == Players.LocalPlayer.UserId and u3:FindFirstChild("Primary");

            if v7 then
                SignChangeTextMenu.Frame.Input.ClearTextOnFocus = false;
                local ProximityPrompt = Instance.new("ProximityPrompt");
                ProximityPrompt.Name = "ChangeSignTextPrompt";
                ProximityPrompt.ActionText = "Change Text";
                ProximityPrompt.ObjectText = "Sign";
                ProximityPrompt.HoldDuration = 0;
                ProximityPrompt.RequiresLineOfSight = false;
                ProximityPrompt.MaxActivationDistance = 10;
                ProximityPrompt.Parent = v7;

                if ProximityPrompt and ProximityPrompt:IsA("ProximityPrompt") then
                    SmartProximityPrompt.AttachToModel(ProximityPrompt, u3, {
                        PartName = "ChangeSignTextPrompt",
                        MaxActivationDistance = 10,
                        TrackDistance = 24,
                        SurfaceOffset = 0.75,
                        FollowSpeed = 18
                    });
                    ProximityPrompt.Triggered:Connect(function() -- Line: 46
                        -- upvalues: u1 (ref), SignChangeTextMenu (ref), u3 (copy)
                        u1:Open("SignChangeTextMenu");
                        SignChangeTextMenu.Frame.Input.Text = u3:GetAttribute("ExtraData");
                        SignChangeTextMenu:SetAttribute("CurrentId", u3:GetAttribute("PropId"));
                        SignChangeTextMenu.Frame.CharCount.Text = `{#u3:GetAttribute("ExtraData")}/100`;
                        task.defer(function() -- Line: 53
                            -- upvalues: SignChangeTextMenu (ref)
                            SignChangeTextMenu.Frame.Input:CaptureFocus();
                        end);
                    end);
                    SignChangeTextMenu.Frame.Input:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 58
                        -- upvalues: SignChangeTextMenu (ref), u3 (copy)
                        SignChangeTextMenu.Frame.CharCount.Text = `{#SignChangeTextMenu.Frame.Input.Text}/100`;

                        if u3:GetAttribute("PropId") == SignChangeTextMenu:GetAttribute("CurrentId") then
                            local TextLabel = u3:FindFirstChild("TextLabel", true);

                            if not TextLabel then
                                return;
                            end;

                            TextLabel.Text = SignChangeTextMenu.Frame.Input.Text;
                        end;
                    end);
                    SignChangeTextMenu.Frame.Input.FocusLost:Connect(function() -- Line: 67
                        -- upvalues: u3 (copy), SignChangeTextMenu (ref), u2 (ref), u1 (ref), NotificationController (ref), Networking (ref)
                        if u3:GetAttribute("PropId") ~= SignChangeTextMenu:GetAttribute("CurrentId") then
                            return;
                        end;

                        SignChangeTextMenu:SetAttribute("CurrentId", nil);
                        local v8 = u3:GetAttribute("PropId");
                        local v9 = os.clock();
                        local v10 = 5 - (v9 - (u2[v8] or 0));

                        if v10 > 0 then
                            u1:Close("SignChangeTextMenu");
                            NotificationController:CreateNotification((`Please wait {math.ceil(v10)}s before changing sign text.`));

                            return;
                        end;

                        u2[v8] = v9;
                        Networking.Prop.SetPropExtraData:Fire(u3:GetAttribute("PropId"), SignChangeTextMenu.Frame.Input.Text);
                        u1:Close("SignChangeTextMenu");
                    end);
                end;
            end;

            local function updateDisplayText() -- Line: 90
                -- upvalues: u3 (copy)
                local v11 = u3:GetAttribute("ExtraData") or "";
                local TextLabel = u3:FindFirstChild("TextLabel", true);

                if TextLabel then
                    TextLabel.Text = v11;
                end;
            end;

            local v12 = u3:GetAttribute("ExtraData") or "";
            local TextLabel = u3:FindFirstChild("TextLabel", true);

            if TextLabel then
                TextLabel.Text = v12;
            end;

            u3:GetAttributeChangedSignal("ExtraData"):Connect(updateDisplayText);

            return;
        end;
    end;
end;