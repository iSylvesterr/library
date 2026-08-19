-- Decompiled with Potassium's decompiler.

local u1 = {};
local MarketplaceService = game:GetService("MarketplaceService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local CurrentCamera = Workspace.CurrentCamera;
local Settings = require(script:WaitForChild("Settings"));
local u2 = {};
local u3 = nil;
local u4 = nil;

local function rotationToPx(p5) -- Line: 49
    -- upvalues: CurrentCamera (copy)
    local ViewportSize = CurrentCamera.ViewportSize;
    local v6, v7;

    if ViewportSize.X > ViewportSize.Y then
        v6 = CurrentCamera.MaxAxisFieldOfView;
        v7 = CurrentCamera.FieldOfView;
    else
        v6 = CurrentCamera.FieldOfView;
        v7 = CurrentCamera.MaxAxisFieldOfView;
    end;

    if typeof(p5) == "number" then
        return p5 / v7 * ViewportSize.Y;
    end;

    return p5 / Vector2.new(v6, v7) * ViewportSize;
end;

local function shouldShowCrosshair(p8) -- Line: 81
    -- upvalues: u3 (ref)
    local Parent = u3.Parent;

    return p8.Properties.ShowCrosshair and not (Parent.TeamSelection.Visible or Parent.Leaderboard.Visible or (Parent.EndScreen.Visible or Parent.BuyMenu.Visible)) and not p8.IsAiming;
end;

local function calculateBloomScaleFromSpread(p9) -- Line: 96
    -- upvalues: CurrentCamera (copy)
    local v10 = math.clamp(p9 / 2, 0, 30);
    local ViewportSize = CurrentCamera.ViewportSize;
    local v11, v12;

    if ViewportSize.X > ViewportSize.Y then
        v11 = CurrentCamera.MaxAxisFieldOfView;
        v12 = CurrentCamera.FieldOfView;
    else
        v11 = CurrentCamera.FieldOfView;
        v12 = CurrentCamera.MaxAxisFieldOfView;
    end;

    local v13;

    if typeof(v10) == "number" then
        v13 = v10 / v12 * ViewportSize.Y;
    else
        v13 = v10 / Vector2.new(v11, v12) * ViewportSize;
    end;

    if typeof(v13) == "Vector2" then
        return math.max(v13.X, v13.Y) / 15 + 1;
    end;

    return 1 + v13 / 15;
end;

local function getCrosshairDisplayState(p14) -- Line: 124
    if p14 and p14.getCrosshairDisplayState then
        return p14:getCrosshairDisplayState();
    end;

    return nil;
end;

local function getDisplayedOuterSpread(p15, p16) -- Line: 134
    return (not p16 or type(p16.OuterSpread) ~= "number") and (p15.getSpread and (p15:getSpread() or 0) or 0) or p16.OuterSpread;
end;

local function calculateBloomScale(p17, p18) -- Line: 148
    -- upvalues: CurrentCamera (copy)
    local v19;

    if p18 and type(p18.OuterSpread) == "number" then
        v19 = p18.OuterSpread;
    else
        v19 = p17.getSpread and (p17:getSpread() or 0) or 0;
    end;

    local v20 = math.clamp(v19 / 2, 0, 30);
    local ViewportSize = CurrentCamera.ViewportSize;
    local v21, v22;

    if ViewportSize.X > ViewportSize.Y then
        v21 = CurrentCamera.MaxAxisFieldOfView;
        v22 = CurrentCamera.FieldOfView;
    else
        v21 = CurrentCamera.FieldOfView;
        v22 = CurrentCamera.MaxAxisFieldOfView;
    end;

    local v23;

    if typeof(v20) == "number" then
        v23 = v20 / v22 * ViewportSize.Y;
    else
        v23 = v20 / Vector2.new(v21, v22) * ViewportSize;
    end;

    if typeof(v23) == "Vector2" then
        return math.max(v23.X, v23.Y) / 15 + 1;
    end;

    return 1 + v23 / 15;
end;

local function getDynamicSpreadPixels(p24) -- Line: 155
    return math.max(0, (p24 - 1) * 15);
end;

local function getConfiguredGapPixels(p25) -- Line: 161
    -- upvalues: Settings (ref)
    return (p25 or Settings.Gap) * 5 / 5;
end;

local function getRestingGapPixels(p26) -- Line: 167
    -- upvalues: Settings (ref)
    local v27;

    if p26 then
        v27 = p26.Gap;
    else
        v27 = p26;
    end;

    local v28 = (v27 or Settings.Gap) * 5 / 5;

    if p26 and p26["Crosshair Style"] == "Classic" then
        return v28;
    end;

    return v28 + 5;
end;

local function calculateRecoilOffset(p29) -- Line: 179
    -- upvalues: Settings (ref), CameraController (copy), ReplicatedStorage (copy), CurrentCamera (copy)
    if not (p29.Recoil and (p29.Properties and (p29.Properties.Recoil and Settings["Follow Recoil"]))) then
        return UDim2.new();
    end;

    local v30 = 1 - p29.Properties.Recoil.CameraScale;
    local v31 = CameraController.getWeaponKickRotation();
    local RotationValue = p29.Recoil.RotationValue;
    local v32 = 0;

    if game:GetService("UserInputService").TouchEnabled then
        local success, result = pcall(function() -- Line: 204
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.AimAssistController);
        end);

        if success and (result and result.GetRecoilAssistMultiplier) then
            v32 = result.GetRecoilAssistMultiplier();
        end;
    end;

    local v33 = Vector3.new(RotationValue.X * (1 - v32), RotationValue.Y * (1 - v32), RotationValue.Z);
    local v34 = Vector2.new(v33.Y - v31.Y, v33.X - v31.X) * 57.29577951308232;
    local ViewportSize = CurrentCamera.ViewportSize;
    local v35, v36;

    if ViewportSize.X > ViewportSize.Y then
        v35 = CurrentCamera.MaxAxisFieldOfView;
        v36 = CurrentCamera.FieldOfView;
    else
        v35 = CurrentCamera.FieldOfView;
        v36 = CurrentCamera.MaxAxisFieldOfView;
    end;

    local v37;

    if typeof(v34) == "number" then
        v37 = v34 / v36 * ViewportSize.Y;
    else
        v37 = v34 / Vector2.new(v35, v36) * ViewportSize;
    end;

    if typeof(v37) ~= "Vector2" then
        return UDim2.new();
    end;

    local v38 = v37 * -v30 / CurrentCamera.ViewportSize;

    return UDim2.fromScale(v38.X, v38.Y);
end;

local function updateAutomaticScope(p39, p40) -- Line: 242
    -- upvalues: CurrentCamera (copy), Settings (ref)
    if not p39.IsAiming or p39.Properties.AimingOptions ~= "AutomaticScope" then
        return;
    end;

    if not p39.getBaseSpread then
        return;
    end;

    local ScopeReticlePart = p39.Viewmodel.Bobble.ScopeReticlePart;

    if not ScopeReticlePart then
        return;
    end;

    local v41 = p39:getBaseSpread() or 0;
    local Frame = ScopeReticlePart.SurfaceGui.Frame.Frame;
    local v42 = math.rad(CurrentCamera.FieldOfView / 2);
    local v43 = math.tan(v42) * 2 * 0.15;
    local ViewportSize = CurrentCamera.ViewportSize;
    local v44 = ViewportSize.X / ViewportSize.Y * v43 / 0.15;
    local v45 = math.clamp(v41, 0, 2) * 2;
    Frame.Size = UDim2.fromScale(v45 + 2.5, v45 + 2.5);
    Frame.Position = UDim2.fromScale(0.5, 0.5) + UDim2.new(p40.X.Scale * v44, 0, p40.Y.Scale * (v43 / 0.15), 0);
    local _ = Settings["Use Crosshair Color for Scope Dot"];
end;

local function updateTickPositions(p46, p47, p48, p49) -- Line: 287
    -- upvalues: Settings (ref)
    if not p46 then
        return;
    end;

    local v50;

    if p48 then
        v50 = p48.Gap;
    else
        v50 = p48;
    end;

    local v51 = (v50 or Settings.Gap) * 5 / 5;

    if not p48 or p48["Crosshair Style"] ~= "Classic" then
        v51 = v51 + 5;
    end;

    local v52 = v51 + (p49 or 0) + (p47 - 1) * 15;
    p46.Right.Position = UDim2.new(0.5, v52, 0.5, 0);
    p46.Down.Position = UDim2.new(0.5, 0, 0.5, v52);
    p46.Left.Position = UDim2.new(0.5, -v52, 0.5, 0);
    p46.Up.Position = UDim2.new(0.5, 0, 0.5, -v52);
end;

local function resetTickPositions(p53, p54) -- Line: 306
    -- upvalues: Settings (ref)
    if not p53 then
        return;
    end;

    local v55;

    if p54 then
        v55 = p54.Gap;
    else
        v55 = p54;
    end;

    local v56 = (v55 or Settings.Gap) * 5 / 5;

    if not p54 or p54["Crosshair Style"] ~= "Classic" then
        v56 = v56 + 5;
    end;

    p53.Right.Position = UDim2.new(0.5, v56, 0.5, 0);
    p53.Down.Position = UDim2.new(0.5, 0, 0.5, v56);
    p53.Left.Position = UDim2.new(0.5, -v56, 0.5, 0);
    p53.Up.Position = UDim2.new(0.5, 0, 0.5, -v56);
end;

local function applyTickVisuals(p57, p58, p59, p60, p61) -- Line: 320
    if not p57 then
        return;
    end;

    for _, v in ipairs({ "Up", "Down", "Left", "Right" }) do
        local v62 = p57:FindFirstChild(v);

        if v62 then
            v62.BackgroundColor3 = p58;
            v62.BackgroundTransparency = 1 - p59;
            v62.Visible = true;
            local v63 = 15 * (p60.Length / 5) * p61;
            local v64 = 2 * (p60.Thickness / 1);

            if v == "Up" or v == "Down" then
                v62.Size = UDim2.new(0, v64, 0, v63);
            else
                v62.Size = UDim2.new(0, v63, 0, v64);
            end;

            if p60.Outline.Enabled then
                v62.BorderSizePixel = p60.Outline.Value;
                v62.BorderColor3 = Color3.new(0, 0, 0);
            else
                v62.BorderSizePixel = 0;
            end;
        end;
    end;

    if p57.Up then
        p57.Up.Visible = not p60["T Style"];
    end;
end;

function u1.ResetCrosshair() -- Line: 364
    -- upvalues: u3 (ref), resetTickPositions (copy), Settings (ref), u4 (ref), InventoryController (copy)
    if u3 then
        u3.Position = UDim2.fromScale(0.5, 0.5);
        resetTickPositions(u3.Ticks, Settings);
        resetTickPositions(u4, Settings);
        local v65 = InventoryController.getCurrentEquipped();

        if v65 and typeof(v65) == "table" then
            if v65.IsAiming and (v65.Properties and v65.Properties.AimingOptions == "AutomaticScope") then
                local Viewmodel = v65.Viewmodel;

                if Viewmodel and Viewmodel.Bobble then
                    local ScopeReticlePart = Viewmodel.Bobble.ScopeReticlePart;
                    local v66 = ScopeReticlePart and (ScopeReticlePart.SurfaceGui and ScopeReticlePart.SurfaceGui.Frame) and ScopeReticlePart.SurfaceGui.Frame:FindFirstChild("Frame");

                    if v66 then
                        v66.Position = UDim2.fromScale(0.5, 0.5);
                        v66.Size = UDim2.fromScale(2.5, 2.5);
                    end;
                end;
            end;

            local Recoil = v65.Recoil;

            if Recoil then
                Recoil.Value = Vector2.zero;
                Recoil.Time = 0;
                Recoil.RotationValue = Vector3.new(0, 0, 0);
            end;
        end;
    end;
end;

function u1.UpdateCrosshair(p67) -- Line: 401
    -- upvalues: LocalPlayer (copy), ReplicatedStorage (copy), Settings (ref), DataController (copy), u3 (ref), u4 (ref), InventoryController (copy), u2 (copy), MarketplaceService (copy), applyTickVisuals (copy), CurrentCamera (copy), calculateRecoilOffset (copy), updateAutomaticScope (copy), updateTickPositions (copy), resetTickPositions (copy)
    local v68 = LocalPlayer:GetAttribute("IsSpectating") == true;
    local v69 = false;
    local v70 = nil;

    if v68 then
        local v71 = require(ReplicatedStorage.Controllers.SpectateController).GetCurrentSpectateInstance();

        if v71 and Settings["Show Player Crosshairs"] == true then
            v70 = DataController.Get(v71.Player, "Settings.Game.Crosshair");

            if v70 then
                v69 = true;
            end;
        end;

        if v71 and (v71.PerspectiveState == "First-Person" and v71.CurrentEquipped) then
            local Name = v71.CurrentEquipped.Name;

            if Name == "AWP" and true or Name == "SSG 08" or (Name == "AUG" and true or Name == "SG 553") and (v71.Player:GetAttribute("ScopeIncrement") or 0) > 0 then
                u3.Visible = false;

                if u3.Ticks then
                    for _, child in pairs(u3.Ticks:GetChildren()) do
                        if child:IsA("Frame") then
                            child.Visible = false;
                        end;
                    end;
                end;

                if u4 then
                    for _, child in pairs(u4:GetChildren()) do
                        if child:IsA("Frame") then
                            child.Visible = false;
                        end;
                    end;
                end;

                if u3.Dot then
                    u3.Dot.Visible = false;
                end;

                if u3.Crosshair then
                    u3.Crosshair.Visible = false;
                end;

                return;
            end;

            local v72 = v69 and v70 and v70 or Settings;
            local v73 = v72["Crosshair Style"] == "Image";

            if u3.Ticks then
                u3.Ticks.Visible = not v73;

                for _, child in pairs(u3.Ticks:GetChildren()) do
                    if child:IsA("Frame") then
                        child.Visible = true;
                    end;
                end;
            end;

            if u4 then
                u4.Visible = false;
            end;

            if u3.Dot then
                u3.Dot.Visible = not v73 and v72["Center Dot"];
            end;

            if u3.Crosshair then
                u3.Crosshair.Visible = v73;
            end;
        elseif v71 and v71.PerspectiveState == "First-Person" then
            u3.Visible = true;
        end;
    end;

    local Character = LocalPlayer.Character;
    local v74 = InventoryController.getCurrentEquipped();
    local v75 = v68 and not v74 and {
        IsAiming = false,
        Properties = {
            ShowCrosshair = true,
            AimingOptions = "None"
        }
    } or v74;

    if not (v68 or Character) then
        return;
    end;

    if not (v75 or v68) then
        return;
    end;

    local v76 = v68 and not v75 and {
        IsAiming = false,
        Properties = {
            ShowCrosshair = true,
            AimingOptions = "None"
        }
    } or v75;
    local u77 = v69 and v70 and v70 or Settings;
    local v78 = u77.Alpha.Enabled and (u77.Alpha.Value / 255 or 1) or 1;
    local v79 = Color3.fromRGB(u77.Red, u77.Green, u77.Blue);
    local v80;

    if u77["Crosshair Style"] == "Classic" and (v76 and v76.getCrosshairDisplayState) then
        v80 = v76:getCrosshairDisplayState();
    else
        v80 = nil;
    end;

    local v81 = u77["Crosshair Style"] == "Image";
    u3.Ticks.Visible = not v81;

    if u4 then
        u4.Visible = false;
    end;

    u3.Dot.Visible = not v81 and u77["Center Dot"];
    u3.Crosshair.Visible = v81;

    if v81 then
        local v82 = "rbxassetid://" .. tostring(u77["Crosshair Image"]);
        local success, result = pcall(function() -- Line: 554
            -- upvalues: u2 (ref), u77 (copy), MarketplaceService (ref)
            return u2[u77["Crosshair Image"]] or MarketplaceService:GetProductInfoAsync(tonumber(u77["Crosshair Image"]), Enum.InfoType.Asset);
        end);

        if success then
            u2[u77["Crosshair Image"]] = result;

            if result.AssetTypeId == 13 then
                v82 = `https://www.roblox.com/asset-thumbnail/image?assetId={u77["Crosshair Image"]}&width=420&height=420&format=png`;
            end;
        end;

        u3.Crosshair.Image = v82;
        u3.Crosshair.ImageColor3 = v79;
        u3.Crosshair.ImageTransparency = 1 - v78;
    else
        local v83 = v78 * 0.5;

        if u77["Crosshair Style"] ~= "Classic" then
            v83 = v78;
        end;

        applyTickVisuals(u3.Ticks, v79, v83, u77, u77["Crosshair Style"] == "Classic" and 0.35 or 1);
        applyTickVisuals(u4, v79, v78 * 1, u77, 0.65);

        if u3.Dot and u77["Center Dot"] then
            u3.Dot.BackgroundColor3 = v79;
            u3.Dot.BackgroundTransparency = 1 - v78;

            if u77.Outline.Enabled then
                u3.Dot.BorderSizePixel = u77.Outline.Value;
                u3.Dot.BorderColor3 = Color3.new(0, 0, 0);
            else
                u3.Dot.BorderSizePixel = 0;
            end;
        end;
    end;

    local Parent = u3.Parent;
    u3.Visible = v76.Properties.ShowCrosshair and not (Parent.TeamSelection.Visible or Parent.Leaderboard.Visible or (Parent.EndScreen.Visible or Parent.BuyMenu.Visible)) and not v76.IsAiming;
    local v84 = UDim2.new();
    local v85 = 1;

    if u3.Visible or v76.Properties.AimingOptions == "AutomaticScope" then
        if u77["Crosshair Style"] == "Classic Static" or u77["Crosshair Style"] == "Image" then
            v85 = 1;
        elseif u77["Crosshair Style"] == "Classic" then
            local v86;

            if v80 and type(v80.OuterSpread) == "number" then
                v86 = v80.OuterSpread;
            else
                v86 = v76.getSpread and (v76:getSpread() or 0) or 0;
            end;

            local v87 = math.clamp(v86 / 2, 0, 30);
            local ViewportSize = CurrentCamera.ViewportSize;
            local v88, v89;

            if ViewportSize.X > ViewportSize.Y then
                v88 = CurrentCamera.MaxAxisFieldOfView;
                v89 = CurrentCamera.FieldOfView;
            else
                v88 = CurrentCamera.FieldOfView;
                v89 = CurrentCamera.MaxAxisFieldOfView;
            end;

            local v90;

            if typeof(v87) == "number" then
                v90 = v87 / v89 * ViewportSize.Y;
            else
                v90 = v87 / Vector2.new(v88, v89) * ViewportSize;
            end;

            if typeof(v90) == "Vector2" then
                v85 = math.max(v90.X, v90.Y) / 15 + 1;
            else
                v85 = 1 + v90 / 15;
            end;
        end;

        v84 = calculateRecoilOffset(v76);
    end;

    updateAutomaticScope(v76, v84);
    u3.Position = UDim2.fromScale(0.5, 0.5) + v84;

    if not v81 then
        if u77["Crosshair Style"] == "Classic" then
            local v91 = math.max(0, (v85 - 1) * 15);

            if v80 then
                v80 = v80.InnerSpread;
            end;

            local v92;

            if type(v80) == "number" then
                local v93 = math.clamp(v80 / 2, 0, 30);
                local ViewportSize = CurrentCamera.ViewportSize;
                local v94, v95;

                if ViewportSize.X > ViewportSize.Y then
                    v94 = CurrentCamera.MaxAxisFieldOfView;
                    v95 = CurrentCamera.FieldOfView;
                else
                    v94 = CurrentCamera.FieldOfView;
                    v95 = CurrentCamera.MaxAxisFieldOfView;
                end;

                local v96;

                if typeof(v93) == "number" then
                    v96 = v93 / v95 * ViewportSize.Y;
                else
                    v96 = v93 / Vector2.new(v94, v95) * ViewportSize;
                end;

                local v97;

                if typeof(v96) == "Vector2" then
                    v97 = math.max(v96.X, v96.Y) / 15 + 1;
                else
                    v97 = 1 + v96 / 15;
                end;

                v92 = math.max(0, (v97 - 1) * 15);
            else
                v92 = math.min(v91, 7);
            end;

            local v98;

            if u77 then
                v98 = u77.Gap;
            else
                v98 = u77;
            end;

            local v99 = (v98 or Settings.Gap) * 5 / 5;

            if not u77 or u77["Crosshair Style"] ~= "Classic" then
                v99 = v99 + 5;
            end;

            local v100 = u77["Center Dot"] and v99 + v92 <= 0;
            local v101 = u77["Center Dot"] and v99 + v91 <= 0;

            if u4 then
                u4.Visible = not v100;

                if not v100 then
                    updateTickPositions(u4, v92 / 15 + 1, u77);
                end;
            end;

            if v101 then
                u3.Ticks.Visible = false;
                resetTickPositions(u3.Ticks, u77);

                return;
            end;

            u3.Ticks.Visible = true;
            updateTickPositions(u3.Ticks, v91 / 15 + 1, u77);

            return;
        end;

        u3.Ticks.Visible = true;
        updateTickPositions(u3.Ticks, v85, u77);

        if u4 then
            u4.Visible = false;
            resetTickPositions(u4, u77);
        end;
    end;
end;

function u1.Initialize(p102, p103) -- Line: 677
    -- upvalues: u3 (ref), u4 (ref), DataController (copy), LocalPlayer (copy), Settings (ref), u1 (copy), RunServiceController (copy), Remotes (copy)
    u3 = p103;
    u4 = u3:FindFirstChild("InnerTicks");

    if not u4 and u3.Ticks then
        local v104 = u3.Ticks:Clone();
        v104.Name = "InnerTicks";
        v104.Visible = false;
        v104.Parent = u3;
        u4 = v104;
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Game.Crosshair", function(p105) -- Line: 690
        -- upvalues: Settings (ref), u1 (ref)
        Settings = p105;
        task.delay(0.1, function() -- Line: 693
            -- upvalues: u1 (ref)
            u1.UpdateCrosshair(0);
        end);
    end);
    RunServiceController.BindToRenderStep("UI.Crosshair.Update", function(p106) -- Line: 699
        -- upvalues: u1 (ref)
        u1.UpdateCrosshair(p106);
    end);
    Remotes.Character.CharacterDied.Listen(function() -- Line: 704
        -- upvalues: u1 (ref)
        u1.ResetCrosshair();
    end);
end;

return u1;