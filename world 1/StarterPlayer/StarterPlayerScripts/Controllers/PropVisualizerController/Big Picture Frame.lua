-- Decompiled with Potassium's decompiler.

local Networking = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Networking"));
local Players = game:GetService("Players");
local SmartProximityPrompt = require(game:GetService("ReplicatedStorage"):WaitForChild("ClientModules"):WaitForChild("SmartProximityPrompt"));
local u1 = require("../GuiController");
local NotificationController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController);
local ImageAssetId = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("ImageAssetId"));
local PictureFrameIdChangeMenu = Players.LocalPlayer.PlayerGui:WaitForChild("PictureFrameIdChangeMenu");
local u2 = 0;

local function ResolveImage(p3) -- Line: 15
    -- upvalues: ImageAssetId (copy)
    return ImageAssetId.ResolveForDisplay(p3);
end;

return function(u4) -- Line: 19
    -- upvalues: Players (copy), PictureFrameIdChangeMenu (copy), SmartProximityPrompt (copy), ImageAssetId (copy), u1 (copy), u2 (ref), NotificationController (copy), Networking (copy)
    while true do
        local v5 = u4:GetAttribute("UserId");
        local v6;

        if typeof(v5) == "number" then
            v6 = game:GetService("Players"):GetPlayerByUserId(v5);
        else
            v6 = nil;
        end;

        local v7;

        if v6 == nil then
            v7 = false;
        else
            v7 = u4:IsDescendantOf(workspace);
        end;

        if not v7 then
            task.wait();
        end;

        if v7 then
            local v8 = v6.UserId == Players.LocalPlayer.UserId and u4:FindFirstChild("Main");

            if v8 then
                PictureFrameIdChangeMenu.Frame.Input.ClearTextOnFocus = false;
                local ProximityPrompt = Instance.new("ProximityPrompt");
                ProximityPrompt.Name = "ChangePictureFrameImagePrompt";
                ProximityPrompt.ActionText = "Edit";
                ProximityPrompt.ObjectText = "Image ID";
                ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
                ProximityPrompt.HoldDuration = 0;
                ProximityPrompt.RequiresLineOfSight = false;
                ProximityPrompt.MaxActivationDistance = 10;
                ProximityPrompt.Parent = v8;

                if ProximityPrompt and ProximityPrompt:IsA("ProximityPrompt") then
                    SmartProximityPrompt.AttachToModel(ProximityPrompt, u4, {
                        PartName = "ChangePictureFrameImagePrompt",
                        MaxActivationDistance = 10,
                        TrackDistance = 24,
                        SurfaceOffset = 0.75,
                        FollowSpeed = 18
                    });
                    ProximityPrompt.Triggered:Connect(function() -- Line: 54
                        -- upvalues: ImageAssetId (ref), u4 (copy), u1 (ref), PictureFrameIdChangeMenu (ref)
                        local v9 = ImageAssetId.Parse(u4:GetAttribute("ExtraData")) or "";
                        local v10 = tostring(v9);
                        u1:Open("PictureFrameIdChangeMenu");
                        PictureFrameIdChangeMenu.Frame.Input.Text = v10;
                        PictureFrameIdChangeMenu:SetAttribute("CurrentId", u4:GetAttribute("PropId"));
                        local CharCount = PictureFrameIdChangeMenu.Frame:FindFirstChild("CharCount");

                        if CharCount then
                            CharCount.Text = `{#v10}/100`;
                        end;

                        task.defer(function() -- Line: 67
                            -- upvalues: PictureFrameIdChangeMenu (ref)
                            PictureFrameIdChangeMenu.Frame.Input:CaptureFocus();
                        end);
                    end);
                    PictureFrameIdChangeMenu.Frame.Input:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 72
                        -- upvalues: PictureFrameIdChangeMenu (ref), u4 (copy), ImageAssetId (ref)
                        local Input = PictureFrameIdChangeMenu.Frame.Input;
                        local v11 = Input.Text:gsub("%D", "");

                        if v11 ~= Input.Text then
                            Input.Text = v11;

                            return;
                        end;

                        local CharCount = PictureFrameIdChangeMenu.Frame:FindFirstChild("CharCount");

                        if CharCount then
                            CharCount.Text = `{#Input.Text}/100`;
                        end;

                        if u4:GetAttribute("PropId") == PictureFrameIdChangeMenu:GetAttribute("CurrentId") then
                            local ImageLabel = u4:FindFirstChild("ImageLabel", true);

                            if not ImageLabel then
                                return;
                            end;

                            ImageLabel.Image = ImageAssetId.ResolveForDisplay(Input.Text);
                        end;
                    end);
                    PictureFrameIdChangeMenu.Frame.Input.FocusLost:Connect(function() -- Line: 94
                        -- upvalues: u4 (copy), PictureFrameIdChangeMenu (ref), u2 (ref), u1 (ref), NotificationController (ref), Networking (ref)
                        if u4:GetAttribute("PropId") ~= PictureFrameIdChangeMenu:GetAttribute("CurrentId") then
                            return;
                        end;

                        PictureFrameIdChangeMenu:SetAttribute("CurrentId", nil);
                        local v12 = os.clock();
                        local v13 = 0.1 - (v12 - u2);

                        if v13 > 0 then
                            u1:Close("PictureFrameIdChangeMenu");
                            NotificationController:CreateNotification((`Please wait {math.ceil(v13)}s before changing the picture frame image.`));

                            return;
                        end;

                        u2 = v12;
                        Networking.Prop.SetPropExtraData:Fire(u4:GetAttribute("PropId"), PictureFrameIdChangeMenu.Frame.Input.Text);
                        u1:Close("PictureFrameIdChangeMenu");
                    end);
                end;
            end;

            local function updateDisplayImage() -- Line: 116
                -- upvalues: u4 (copy), ImageAssetId (ref)
                local v14 = u4:GetAttribute("ExtraData") or "";
                local ImageLabel = u4:FindFirstChild("ImageLabel", true);

                if ImageLabel then
                    ImageLabel.Image = ImageAssetId.ResolveForDisplay(v14);
                end;
            end;

            local v15 = u4:GetAttribute("ExtraData") or "";
            local ImageLabel = u4:FindFirstChild("ImageLabel", true);

            if ImageLabel then
                ImageLabel.Image = ImageAssetId.ResolveForDisplay(v15);
            end;

            u4:GetAttributeChangedSignal("ExtraData"):Connect(updateDisplayImage);

            return;
        end;
    end;
end;