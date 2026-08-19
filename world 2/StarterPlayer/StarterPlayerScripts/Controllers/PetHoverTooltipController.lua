-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 11
};
local GuiService = game:GetService("GuiService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local Workspace = game:GetService("Workspace");
local PetData = require(ReplicatedStorage.SharedData.PetData);
local PetTypes = require(ReplicatedStorage.SharedData.PetTypes);
local RarityVisuals = require(ReplicatedStorage.SharedModules.RarityVisuals);
local AnimatedGradient = require(ReplicatedStorage.SharedModules.AnimatedGradient);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local u2 = Color3.new(1, 1, 1);
local u3 = Color3.fromRGB(0, 0, 0);
local u4 = Vector2.new(260, 44);
local u5 = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
local u6 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 165, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 200, 0)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 100, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(140, 0, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 200))
});
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = 0;
local u14 = 0;
local u15 = 0;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;

local function normString(p21) -- Line: 78
    if type(p21) == "string" and p21 ~= "" then
        return p21;
    end;

    return nil;
end;

local function getPointerLocation() -- Line: 87
    -- upvalues: u11 (ref), GuiService (copy), UserInputService (copy)
    local v22 = u11;

    if v22 then
        local v23 = GuiService:GetGuiInset();

        return Vector2.new(v22.Position.X + v23.X, v22.Position.Y + v23.Y);
    end;

    if UserInputService.MouseEnabled then
        return UserInputService:GetMouseLocation();
    end;

    return nil;
end;

local function ensurePetFolders() -- Line: 99
    -- upvalues: Workspace (copy), u18 (ref), u19 (ref)
    local Map = Workspace:FindFirstChild("Map");
    local v24;

    if Map then
        v24 = Map:FindFirstChild("WildPetSpawns");
    else
        v24 = nil;
    end;

    u18 = v24;
    local _PetVisualClient = Workspace:FindFirstChild("_PetVisualClient");
    local v25;

    if _PetVisualClient then
        v25 = _PetVisualClient:FindFirstChild("Models");
    else
        v25 = nil;
    end;

    u19 = v25;
end;

local function rayBoxDistance(p26, p27, p28, p29) -- Line: 106
    local v30 = p28:PointToObjectSpace(p26);
    local v31 = p28:VectorToObjectSpace(p27);
    local v32 = p29 * 0.5;
    local v33 = { v30.X, v30.Y, v30.Z };
    local v34 = { v31.X, v31.Y, v31.Z };
    local v35 = { v32.X, v32.Y, v32.Z };
    local v36 = (-1 / 0);
    local v37 = (1 / 0);

    for i = 1, 3 do
        if math.abs(v34[i]) < 1e-6 then
            if v33[i] < -v35[i] or v33[i] > v35[i] then
                return nil;
            end;
        else
            local v38 = (-v35[i] - v33[i]) / v34[i];
            local v39 = (v35[i] - v33[i]) / v34[i];

            if v39 >= v38 then
                local v40 = v38;
                v38 = v39;
                v39 = v40;
            end;

            if v36 >= v39 then
                v39 = v36;
            end;

            if v38 >= v37 then
                v38 = v37;
            end;

            if v38 < v39 then
                return nil;
            end;

            v37 = v38;
            v36 = v39;
        end;
    end;

    if v37 < 0 then
        return nil;
    end;

    return math.max(v36, 0);
end;

local function findHoveredPetAt(p41, p42) -- Line: 135
    -- upvalues: Workspace (copy), u18 (ref), u19 (ref), rayBoxDistance (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return nil;
    end;

    local v43 = CurrentCamera:ViewportPointToRay(p41, p42);
    local Origin = v43.Origin;
    local Direction = v43.Direction;
    local v44 = 1000;
    local v45 = nil;

    for _, v in { u18, u19 } do
        if v then
            for _, child in v:GetChildren() do
                if child:IsA("Model") then
                    local v46, v47 = child:GetBoundingBox();
                    local v48 = rayBoxDistance(Origin, Direction, v46, v47);

                    if v48 and v48 < v44 then
                        v45 = child;
                        v44 = v48;
                    end;
                end;
            end;
        end;
    end;

    return v45;
end;

local function resolvePet(p49) -- Line: 162
    -- upvalues: u18 (ref), u19 (ref), Workspace (copy)
    local Parent = p49.Parent;

    if Parent == u18 then
        local v50 = p49:GetAttribute("PetName");

        if type(v50) ~= "string" or v50 == "" then
            v50 = nil;
        end;

        if not v50 then
            return nil;
        end;

        local v51 = {
            Species = v50
        };
        local v52 = p49:GetAttribute("PetSize");

        if type(v52) ~= "string" or v52 == "" then
            v52 = nil;
        end;

        v51.Size = v52;
        local v53 = p49:GetAttribute("PetType");

        if type(v53) ~= "string" or v53 == "" then
            v53 = nil;
        end;

        v51.Type = v53;

        return v51;
    end;

    if Parent ~= u19 then
        return nil;
    end;

    local v54 = p49:GetAttribute("Owner");

    if type(v54) ~= "string" or v54 == "" then
        v54 = nil;
    end;

    local v55 = p49:GetAttribute("OwnerSlot");

    if type(v55) ~= "string" or v55 == "" then
        v55 = nil;
    end;

    if not (v54 and v55) then
        return nil;
    end;

    local PlayerPetReferences = Workspace:FindFirstChild("PlayerPetReferences");

    if PlayerPetReferences then
        PlayerPetReferences = PlayerPetReferences:FindFirstChild(v54);
    end;

    if PlayerPetReferences then
        PlayerPetReferences = PlayerPetReferences:FindFirstChild(v55);
    end;

    if not PlayerPetReferences then
        return nil;
    end;

    local v56 = PlayerPetReferences:GetAttribute("PetSpecies");

    if type(v56) ~= "string" or v56 == "" then
        v56 = nil;
    end;

    if not v56 then
        return nil;
    end;

    local v57 = {
        Species = v56
    };
    local v58 = PlayerPetReferences:GetAttribute("PetSize");

    if type(v58) ~= "string" or v58 == "" then
        v58 = nil;
    end;

    v57.Size = v58;
    local v59 = PlayerPetReferences:GetAttribute("PetType");

    if type(v59) ~= "string" or v59 == "" then
        v59 = nil;
    end;

    v57.Type = v59;

    return v57;
end;

local function clearNameStyling() -- Line: 197
    -- upvalues: u16 (ref), u9 (ref), AnimatedGradient (copy)
    if u16 then
        u16();
        u16 = nil;
    end;

    local v60 = u9 and u9:FindFirstChildOfClass("UIGradient");

    if v60 then
        AnimatedGradient:Remove(v60);
        v60:Destroy();
    end;
end;

local function applyNameStyle(p61) -- Line: 211
    -- upvalues: u9 (ref), u16 (ref), AnimatedGradient (copy), PetData (copy), PetTypes (copy), u2 (copy), u6 (copy), RarityVisuals (copy)
    if not u9 then
        return;
    end;

    if u16 then
        u16();
        u16 = nil;
    end;

    local v62 = u9 and u9:FindFirstChildOfClass("UIGradient");

    if v62 then
        AnimatedGradient:Remove(v62);
        v62:Destroy();
    end;

    u9.Text = PetData.GetDisplayName(p61.Species, p61.Size);

    if p61.Type ~= PetTypes.Rainbow then
        local v63 = PetData[p61.Species];
        local v64 = (not v63 or type(v63.Rarity) ~= "string") and "Common" or v63.Rarity;
        u16 = RarityVisuals.ApplyToLabels({ u9 }, v64);

        return;
    end;

    u9.TextColor3 = u2;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Color = u6;
    UIGradient.Parent = u9;
    AnimatedGradient:Add(UIGradient);
end;

local function detachPetListeners() -- Line: 232
    -- upvalues: u17 (ref)
    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;
end;

local function attachPetListeners(u65) -- Line: 239
    -- upvalues: u17 (ref), u12 (ref), u15 (ref)
    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    u17 = u65.AncestryChanged:Connect(function(p66, p67) -- Line: 241
        -- upvalues: u12 (ref), u65 (copy), u15 (ref)
        if u12 == u65 and not p67 then
            u15 = 0;
        end;
    end);
end;

local function refreshContent(p68) -- Line: 248
    -- upvalues: resolvePet (copy), u9 (ref), u16 (ref), AnimatedGradient (copy), applyNameStyle (copy)
    local v69 = resolvePet(p68);

    if v69 then
        applyNameStyle(v69);

        return;
    end;

    if u9 then
        u9.Text = "?";
    end;

    if u16 then
        u16();
        u16 = nil;
    end;

    local v70 = u9 and u9:FindFirstChildOfClass("UIGradient");

    if v70 then
        AnimatedGradient:Remove(v70);
        v70:Destroy();
    end;
end;

local function applyHoverState(u71) -- Line: 258
    -- upvalues: u12 (ref), u15 (ref), resolvePet (copy), u9 (ref), u16 (ref), AnimatedGradient (copy), applyNameStyle (copy), u17 (ref)
    if not u71 then
        if u12 then
            u15 = 0;
        end;

        return;
    end;

    if u71 == u12 then
        if u15 == 0 then
            u15 = 1;
        end;

        return;
    end;

    if u12 then
        u12 = u71;
        local v72 = resolvePet(u71);

        if v72 then
            applyNameStyle(v72);
        else
            if u9 then
                u9.Text = "?";
            end;

            if u16 then
                u16();
                u16 = nil;
            end;

            local v73 = u9 and u9:FindFirstChildOfClass("UIGradient");

            if v73 then
                AnimatedGradient:Remove(v73);
                v73:Destroy();
            end;
        end;

        if u17 then
            u17:Disconnect();
            u17 = nil;
        end;

        u17 = u71.AncestryChanged:Connect(function(p74, p75) -- Line: 241
            -- upvalues: u12 (ref), u71 (copy), u15 (ref)
            if u12 == u71 and not p75 then
                u15 = 0;
            end;
        end);

        return;
    end;

    u12 = u71;
    local v76 = resolvePet(u71);

    if v76 then
        applyNameStyle(v76);
    else
        if u9 then
            u9.Text = "?";
        end;

        if u16 then
            u16();
            u16 = nil;
        end;

        local v77 = u9 and u9:FindFirstChildOfClass("UIGradient");

        if v77 then
            AnimatedGradient:Remove(v77);
            v77:Destroy();
        end;
    end;

    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    u17 = u71.AncestryChanged:Connect(function(p78, p79) -- Line: 241
        -- upvalues: u12 (ref), u71 (copy), u15 (ref)
        if u12 == u71 and not p79 then
            u15 = 0;
        end;
    end);
    u15 = 1;
end;

local function onRenderStep(p80) -- Line: 281
    -- upvalues: u13 (ref), Workspace (copy), u18 (ref), u19 (ref), u11 (ref), GuiService (copy), UserInputService (copy), applyHoverState (copy), findHoveredPetAt (copy), u8 (ref), u9 (ref), u10 (ref), u14 (ref), u15 (ref), u12 (ref), u17 (ref), u16 (ref), AnimatedGradient (copy), u4 (copy)
    u13 = u13 + p80;

    if u13 >= 0.1 then
        u13 = 0;
        local Map = Workspace:FindFirstChild("Map");
        local v81;

        if Map then
            v81 = Map:FindFirstChild("WildPetSpawns");
        else
            v81 = nil;
        end;

        u18 = v81;
        local _PetVisualClient = Workspace:FindFirstChild("_PetVisualClient");
        local v82;

        if _PetVisualClient then
            v82 = _PetVisualClient:FindFirstChild("Models");
        else
            v82 = nil;
        end;

        u19 = v82;
        local v83 = u11;
        local v84;

        if v83 then
            local v85 = GuiService:GetGuiInset();
            v84 = Vector2.new(v83.Position.X + v85.X, v83.Position.Y + v85.Y);
        elseif UserInputService.MouseEnabled then
            v84 = UserInputService:GetMouseLocation();
        else
            v84 = nil;
        end;

        local v86;

        if v84 then
            v86 = findHoveredPetAt(v84.X, v84.Y);
        else
            v86 = nil;
        end;

        applyHoverState(v86);
    end;

    if not (u8 and (u9 and u10)) then
        return;
    end;

    local v87 = p80 / 0.1;

    if u14 < u15 then
        u14 = math.min(u15, u14 + v87);
    elseif u15 < u14 then
        u14 = math.max(u15, u14 - v87);
    end;

    local v88 = 1 - u14;
    u9.TextTransparency = v88;
    u10.Transparency = v88;
    u8.Visible = u14 > 0;

    if u14 ~= 0 or (u15 ~= 0 or not u12) then
        if u12 and u14 > 0 then
            local CurrentCamera = Workspace.CurrentCamera;
            local v89 = u11;
            local v90;

            if v89 then
                local v91 = GuiService:GetGuiInset();
                v90 = Vector2.new(v89.Position.X + v91.X, v89.Position.Y + v91.Y);
            elseif UserInputService.MouseEnabled then
                v90 = UserInputService:GetMouseLocation();
            else
                v90 = nil;
            end;

            if CurrentCamera and v90 then
                local ViewportSize = CurrentCamera.ViewportSize;
                local v92 = u11 and 42 or 28;
                local v93 = math.min(u9.TextBounds.X, u4.X);
                local v94 = v93 / 2;

                if v90.X + v92 + v93 <= ViewportSize.X then
                    u8.AnchorPoint = Vector2.new(0.5, 0.5);
                    u8.Position = UDim2.fromOffset(v90.X + v92 + v94, v90.Y);

                    return;
                end;

                u8.AnchorPoint = Vector2.new(0.5, 0.5);
                u8.Position = UDim2.fromOffset(v90.X - v92 - v94, v90.Y);
            end;
        end;

        return;
    end;

    u12 = nil;

    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    if u16 then
        u16();
        u16 = nil;
    end;

    local v95 = u9 and u9:FindFirstChildOfClass("UIGradient");

    if v95 then
        AnimatedGradient:Remove(v95);
        v95:Destroy();
    end;
end;

local function buildGui() -- Line: 334
    -- upvalues: PlayerGui (copy), u7 (ref), u4 (copy), u8 (ref), u5 (copy), u9 (ref), u3 (copy), u10 (ref)
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "PetHoverTooltip";
    ScreenGui.DisplayOrder = -1;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    ScreenGui.Enabled = true;
    ScreenGui.Parent = PlayerGui;
    u7 = ScreenGui;
    local Frame = Instance.new("Frame");
    Frame.Name = "Frame";
    Frame.AnchorPoint = Vector2.new(0, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.Size = UDim2.fromOffset(u4.X, u4.Y);
    Frame.Position = UDim2.fromOffset(0, 0);
    Frame.Visible = false;
    Frame.Parent = ScreenGui;
    u8 = Frame;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.FillDirection = Enum.FillDirection.Vertical;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Name";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BorderSizePixel = 0;
    TextLabel.FontFace = u5;
    TextLabel.Size = UDim2.new(1, 0, 1, 0);
    TextLabel.Text = "";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextSize = 24;
    TextLabel.TextTransparency = 1;
    TextLabel.TextWrapped = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Center;
    TextLabel.Parent = Frame;
    u9 = TextLabel;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
    UIStroke.Color = u3;
    UIStroke.LineJoinMode = Enum.LineJoinMode.Round;
    UIStroke.Thickness = 2;
    UIStroke.Transparency = 1;
    UIStroke.Parent = TextLabel;
    u10 = UIStroke;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Color = ColorSequence.new(u3);
    UIGradient.Parent = UIStroke;
end;

function v1.Start(p96) -- Line: 394
    -- upvalues: buildGui (copy), u20 (ref), LocalPlayer (copy), Workspace (copy), u18 (ref), u19 (ref), findHoveredPetAt (copy), resolvePet (copy), UserInputService (copy), u11 (ref), GuiService (copy), RunService (copy), onRenderStep (copy)
    buildGui();
    local success, result = pcall(function() -- Line: 399
        return require(script.Parent.PetListController);
    end);

    if success then
        u20 = result;
    end;

    local function tryOpenPetInfoAt(p97, p98) -- Line: 409
        -- upvalues: u20 (ref), LocalPlayer (ref), Workspace (ref), u18 (ref), u19 (ref), findHoveredPetAt (ref), resolvePet (ref)
        if not (u20 and u20.ShowPetInfo) then
            return false;
        end;

        if LocalPlayer:GetAttribute("IsInOwnGarden") ~= true then
            return false;
        end;

        local Character = LocalPlayer.Character;

        if Character and Character:FindFirstChildWhichIsA("Tool") then
            return false;
        end;

        local Map = Workspace:FindFirstChild("Map");
        local v99;

        if Map then
            v99 = Map:FindFirstChild("WildPetSpawns");
        else
            v99 = nil;
        end;

        u18 = v99;
        local _PetVisualClient = Workspace:FindFirstChild("_PetVisualClient");
        local v100;

        if _PetVisualClient then
            v100 = _PetVisualClient:FindFirstChild("Models");
        else
            v100 = nil;
        end;

        u19 = v100;
        local v101 = findHoveredPetAt(p97, p98);

        if not v101 then
            return false;
        end;

        if v101.Parent ~= u19 then
            return false;
        end;

        if v101:GetAttribute("Owner") ~= LocalPlayer.Name then
            return false;
        end;

        local v102 = resolvePet(v101);

        if not v102 then
            return false;
        end;

        u20:ShowPetInfo(v102.Species, v102.Size, v102.Type);

        return true;
    end;

    UserInputService.InputBegan:Connect(function(p103, p104) -- Line: 431
        -- upvalues: UserInputService (ref), tryOpenPetInfoAt (copy)
        if p104 then
            return;
        end;

        if p103.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        local v105 = UserInputService:GetMouseLocation();
        tryOpenPetInfoAt(v105.X, v105.Y);
    end);
    UserInputService.TouchStarted:Connect(function(p106, p107) -- Line: 442
        -- upvalues: u11 (ref)
        if p107 then
            return;
        end;

        if u11 == nil then
            u11 = p106;
        end;
    end);
    UserInputService.TouchEnded:Connect(function(p108) -- Line: 448
        -- upvalues: u11 (ref)
        if p108 == u11 then
            u11 = nil;
        end;
    end);
    UserInputService.TouchTapInWorld:Connect(function(p109, p110) -- Line: 458
        -- upvalues: GuiService (ref), tryOpenPetInfoAt (copy)
        if p110 then
            return;
        end;

        local v111 = GuiService:GetGuiInset();
        tryOpenPetInfoAt(p109.X + v111.X, p109.Y + v111.Y);
    end);
    RunService:BindToRenderStep("PetHoverTooltip", Enum.RenderPriority.Camera.Value - 1, onRenderStep);
end;

return v1;