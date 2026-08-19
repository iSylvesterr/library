-- Decompiled with Potassium's decompiler.

local MarketplaceService = game:GetService("MarketplaceService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local u1 = {};

local function updateCrosshairPreview(p2, u3, p4) -- Line: 29
    -- upvalues: u1 (copy), MarketplaceService (copy)
    if not u3 then
        return;
    end;

    if not p2.Visible then
        return;
    end;

    if not p2:IsDescendantOf(game) then
        return;
    end;

    local v5 = p4 or 1;
    local Alpha = u3.Alpha;
    local v6 = (not Alpha or (type(Alpha) ~= "table" or (not Alpha.Enabled or type(Alpha.Value) ~= "number"))) and 1 or Alpha.Value / 255;
    local v7 = u3.Green or 255;
    local v8 = u3.Blue or 0;
    local v9 = Color3.fromRGB(tonumber(u3.Red or 0) or 0, tonumber(v7) or 255, tonumber(v8) or 0);
    local v10 = u3["Crosshair Style"];
    local v11 = v10 == "Image";
    local Ticks = p2:FindFirstChild("Ticks");
    local Dot = p2:FindFirstChild("Dot");
    local Crosshair = p2:FindFirstChild("Crosshair");

    if not (Ticks and (Dot and Crosshair)) then
        return;
    end;

    Ticks.Visible = not v11;
    Dot.Visible = not v11 and u3["Center Dot"] == true;
    Crosshair.Visible = v11;

    if v11 then
        local v12 = "rbxassetid://" .. tostring(u3["Crosshair Image"]);
        local success, result = pcall(function() -- Line: 88
            -- upvalues: u1 (ref), u3 (copy), MarketplaceService (ref)
            return u1[u3["Crosshair Image"]] or MarketplaceService:GetProductInfoAsync(tonumber(u3["Crosshair Image"]), Enum.InfoType.Asset);
        end);

        if success then
            u1[u3["Crosshair Image"]] = result;

            if result.AssetTypeId == 13 then
                v12 = `https://www.roblox.com/asset-thumbnail/image?assetId={u3["Crosshair Image"]}&width=420&height=420&format=png`;
            end;
        end;

        Crosshair.Image = type(v12) == "string" and v12 and v12 or "rbxassetid://00000000";
        Crosshair.ImageColor3 = v9;
        Crosshair.ImageTransparency = 1 - v6;

        return;
    end;

    local Outline = u3.Outline;
    local v13, v14;

    if Outline and type(Outline) == "table" then
        v13 = Outline.Enabled == true;
        v14 = tonumber(Outline.Value) or 1;
    else
        v13 = false;
        v14 = 1;
    end;

    for _, v in ipairs({ "Up", "Down", "Left", "Right" }) do
        local v15 = Ticks:FindFirstChild(v);

        if v15 then
            v15.BackgroundColor3 = v9;
            v15.BackgroundTransparency = 1 - v6;
            v15.Visible = true;
            local v16 = tonumber(u3.Length) or 5;
            local v17 = tonumber(u3.Thickness) or 1;
            local v18 = 15 * (v16 / 5);
            local v19 = 2 * (v17 / 1);

            if v == "Up" or v == "Down" then
                v15.Size = UDim2.new(0, v19, 0, v18);
            else
                v15.Size = UDim2.new(0, v18, 0, v19);
            end;

            if v13 then
                v15.BorderSizePixel = v14;
                v15.BorderColor3 = Color3.new(0, 0, 0);
            else
                v15.BorderSizePixel = 0;
            end;
        end;
    end;

    local Up = Ticks:FindFirstChild("Up");

    if Up then
        Up.Visible = u3["T Style"] ~= true;
    end;

    if Dot and u3["Center Dot"] == true then
        Dot.BackgroundColor3 = v9;
        Dot.BackgroundTransparency = 1 - v6;

        if v13 then
            Dot.BorderSizePixel = v14;
            Dot.BorderColor3 = Color3.new(0, 0, 0);
        else
            Dot.BorderSizePixel = 0;
        end;
    end;

    local v20 = 5 + (tonumber(u3.Gap) or -1) * 5 / 5;

    if v10 == "Classic" then
        v20 = v20 * v5;
    end;

    local Right = Ticks:FindFirstChild("Right");
    local Down = Ticks:FindFirstChild("Down");
    local Left = Ticks:FindFirstChild("Left");
    local Up2 = Ticks:FindFirstChild("Up");

    if Right then
        Right.Position = UDim2.new(0.5, v20, 0.5, 0);
    end;

    if Down then
        Down.Position = UDim2.new(0.5, 0, 0.5, v20);
    end;

    if Left then
        Left.Position = UDim2.new(0.5, -v20, 0.5, 0);
    end;

    if Up2 then
        Up2.Position = UDim2.new(0.5, 0, 0.5, -v20);
    end;
end;

return function(p21, u22, u23, p24, u25, p26, p27, p28) -- Line: 192
    -- upvalues: Janitor (copy), LocalPlayer (copy), updateCrosshairPreview (copy), RunServiceController (copy)
    u23.LayoutOrder = u22;
    local u29 = Janitor.new();
    u29:Add(u23, "Destroy");
    local Crosshair = u23.Crosshair;
    local u30 = 0;
    local u31 = nil;

    local function isPreviewVisible() -- Line: 234
        -- upvalues: u23 (copy), LocalPlayer (ref)
        local v32 = u23:FindFirstAncestorOfClass("ScrollingFrame");

        if not (v32 and v32:IsDescendantOf(LocalPlayer.PlayerGui)) then
            return false;
        end;

        local v33 = u23;

        while v33 and v33 ~= LocalPlayer.PlayerGui do
            if v33:IsA("GuiObject") and not v33.Visible then
                return false;
            end;

            v33 = v33.Parent;
        end;

        return true;
    end;

    local function stopPreviewUpdate() -- Line: 251
        -- upvalues: u31 (ref)
        if u31 then
            u31:Disconnect();
            u31 = nil;
        end;
    end;

    local function updatePreviewStep(p34, p35) -- Line: 258
        -- upvalues: isPreviewVisible (copy), u31 (ref), u25 (copy), u30 (ref), updateCrosshairPreview (ref), Crosshair (copy)
        if not isPreviewVisible() then
            if u31 then
                u31:Disconnect();
                u31 = nil;
            end;

            return;
        end;

        local v36 = u25();

        if not v36 then
            return;
        end;

        local v37;

        if v36["Crosshair Style"] == "Classic" then
            u30 = u30 + p35;
            local v38 = math.sin(u30 * 3.141592653589793 * 2 * 0.25) * 2 + 1;
            v37 = math.max(v38, 0.75);
        else
            u30 = 0;
            v37 = 1;
        end;

        updateCrosshairPreview(Crosshair, v36, v37);
    end;

    u23.Parent = p21;

    local function syncPreviewUpdate() -- Line: 293
        -- upvalues: isPreviewVisible (copy), u31 (ref), RunServiceController (ref), u22 (copy), updatePreviewStep (copy)
        if not isPreviewVisible() then
            if u31 then
                u31:Disconnect();
                u31 = nil;
            end;

            return;
        end;

        if u31 then
            return;
        end;

        u31 = RunServiceController.BindToStepped(`UI.CrosshairPreview.{u22}`, updatePreviewStep);
        updatePreviewStep(0, 0);
    end;

    local u39 = {};

    local function refreshVisibilityConnections() -- Line: 316
        -- upvalues: u39 (copy), u23 (copy), LocalPlayer (ref), syncPreviewUpdate (copy)
        for _, v in ipairs(u39) do
            v:Disconnect();
        end;

        table.clear(u39);
        local v40 = u23;

        while v40 and v40 ~= LocalPlayer.PlayerGui do
            if v40:IsA("GuiObject") then
                local v41 = v40:GetPropertyChangedSignal("Visible");
                table.insert(u39, v41:Connect(syncPreviewUpdate));
            end;

            v40 = v40.Parent;
        end;
    end;

    refreshVisibilityConnections();
    u29:Add(u23.AncestryChanged:Connect(function() -- Line: 330
        -- upvalues: refreshVisibilityConnections (copy), isPreviewVisible (copy), u31 (ref), RunServiceController (ref), u22 (copy), updatePreviewStep (copy)
        refreshVisibilityConnections();

        if not isPreviewVisible() then
            if u31 then
                u31:Disconnect();
                u31 = nil;
            end;

            return;
        end;

        if u31 then
            return;
        end;

        u31 = RunServiceController.BindToStepped(`UI.CrosshairPreview.{u22}`, updatePreviewStep);
        updatePreviewStep(0, 0);
    end), "Disconnect");
    u29:Add(function() -- Line: 309, Name: clearVisibilityConnections
        -- upvalues: u39 (copy)
        for _, v in ipairs(u39) do
            v:Disconnect();
        end;

        table.clear(u39);
    end, true);
    u29:Add(stopPreviewUpdate, true);

    if isPreviewVisible() then
        if not u31 then
            u31 = RunServiceController.BindToStepped(`UI.CrosshairPreview.{u22}`, updatePreviewStep);
            updatePreviewStep(0, 0);
        end;
    elseif u31 then
        u31:Disconnect();
        u31 = nil;
    end;

    return function() -- Line: 339
        -- upvalues: u29 (copy)
        u29:Cleanup();
    end;
end;