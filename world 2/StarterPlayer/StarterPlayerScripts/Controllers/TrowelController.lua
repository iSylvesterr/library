-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 1
};
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local ContextActionService = game:GetService("ContextActionService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local CutsceneGate = require(ReplicatedStorage.ClientModules.CutsceneGate);
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = workspace.CurrentCamera;
local Gardens = workspace:WaitForChild("Gardens");
local HideCollectProximityPrompts = LocalPlayer:WaitForChild("HideCollectProximityPrompts");
local u2 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = false;
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = false;
local u22 = 0;
local u23 = 0;
local u24 = nil;
local u25 = nil;
local u26 = {};
local u27 = nil;
local u28 = nil;
local u29 = nil;

function v1.Init(p30) -- Line: 62
end;

function v1.ResolveButton(p31, p32) -- Line: 66
    if not p32 then
        return nil;
    end;

    if p32:IsA("GuiButton") then
        return p32;
    end;

    local Button = p32:FindFirstChild("Button");

    if Button and Button:IsA("GuiButton") then
        return Button;
    end;

    local TextButton = p32:FindFirstChild("TextButton");

    if TextButton and TextButton:IsA("GuiButton") then
        return TextButton;
    end;

    return nil;
end;

function v1.IsTouchOnButton(p33, p34, p35) -- Line: 87
    if not (p35 and p35.Visible) then
        return false;
    end;

    local AbsolutePosition = p35.AbsolutePosition;
    local AbsoluteSize = p35.AbsoluteSize;
    local v36;

    if p34.X >= AbsolutePosition.X and (p34.X <= AbsolutePosition.X + AbsoluteSize.X and p34.Y >= AbsolutePosition.Y) then
        v36 = p34.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
    else
        v36 = false;
    end;

    return v36;
end;

function v1.IsTouchOnMoveUi(p37, p38) -- Line: 100
    -- upvalues: u4 (ref), u5 (ref)
    if not p38 or #p38 == 0 then
        return false;
    end;

    for _, v in p38 do
        if p37:IsTouchOnButton(v, u4) or p37:IsTouchOnButton(v, u5) then
            return true;
        end;
    end;

    return false;
end;

function v1.BindGamepadRotateAction(u39) -- Line: 114
    -- upvalues: ContextActionService (copy), u17 (ref), u15 (ref)
    ContextActionService:UnbindAction("TrowelRotateAction");
    ContextActionService:BindActionAtPriority("TrowelRotateAction", function(p40, p41, p42) -- Line: 118
        -- upvalues: u17 (ref), u15 (ref), u39 (copy)
        if p41 ~= Enum.UserInputState.Begin then
            return Enum.ContextActionResult.Pass;
        end;

        if not (u17 and u15) then
            return Enum.ContextActionResult.Pass;
        end;

        if p42.KeyCode == Enum.KeyCode.ButtonL1 then
            u39:RotateMove(-1);

            return Enum.ContextActionResult.Sink;
        end;

        if p42.KeyCode ~= Enum.KeyCode.ButtonR1 then
            return Enum.ContextActionResult.Pass;
        end;

        u39:RotateMove(1);

        return Enum.ContextActionResult.Sink;
    end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1);
end;

function v1.UnbindGamepadRotateAction(p43) -- Line: 144
    -- upvalues: ContextActionService (copy)
    ContextActionService:UnbindAction("TrowelRotateAction");
end;

function v1.BindMoveCancelAction(u44) -- Line: 148
    -- upvalues: ContextActionService (copy), u17 (ref), u15 (ref)
    ContextActionService:UnbindAction("TrowelMoveCancelAction");
    ContextActionService:BindActionAtPriority("TrowelMoveCancelAction", function(p45, p46, p47) -- Line: 152
        -- upvalues: u17 (ref), u15 (ref), u44 (copy)
        if p46 ~= Enum.UserInputState.Begin then
            return Enum.ContextActionResult.Pass;
        end;

        if not (u17 and u15) then
            return Enum.ContextActionResult.Pass;
        end;

        if p47.KeyCode ~= Enum.KeyCode.C and p47.KeyCode ~= Enum.KeyCode.ButtonB then
            return Enum.ContextActionResult.Pass;
        end;

        u44:CancelMove();

        return Enum.ContextActionResult.Sink;
    end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.C, Enum.KeyCode.ButtonB);
end;

function v1.UnbindMoveCancelAction(p48) -- Line: 172
    -- upvalues: ContextActionService (copy)
    ContextActionService:UnbindAction("TrowelMoveCancelAction");
end;

function v1.SetMoveUiVisible(p49, p50) -- Line: 176
    -- upvalues: u4 (ref), u5 (ref), UserInputService (copy), u6 (ref), u7 (ref), u8 (ref)
    if not u4 then
        return;
    end;

    u4.Visible = p50;

    if u5 then
        u5.Visible = p50;
    end;

    if not p50 then
        return;
    end;

    local v51 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled;
    local v52 = p49:IsUsingGamepad();

    if u6 then
        u6.Visible = v51;
    end;

    if u7 then
        u7.Visible = not v51 and not v52;
    end;

    if u8 then
        u8.Visible = v52;
    end;
end;

function v1.BindTrowelUi(u53, p54) -- Line: 196
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u17 (ref), u10 (ref)
    local TrowelUI = p54:FindFirstChild("TrowelUI");

    if not TrowelUI then
        return;
    end;

    u3 = TrowelUI;
    u4 = u53:ResolveButton(u3:FindFirstChild("InitialModeTrowel"):FindFirstChild("Cancel"));
    u5 = u53:ResolveButton(u3:FindFirstChild("InitialModeTrowel"):FindFirstChild("Rotate"));

    if u4 then
        local Text = u4:FindFirstChild("Text");

        if Text then
            u6 = Text:FindFirstChild("Mobile");
            u7 = Text:FindFirstChild("PC");
            u8 = Text:FindFirstChild("Console");
        end;

        if u9 then
            u9:Disconnect();
            u9 = nil;
        end;

        u9 = u4.MouseButton1Click:Connect(function() -- Line: 218
            -- upvalues: u17 (ref), u53 (copy)
            if u17 then
                u53:CancelMove();
            end;
        end);
    end;

    if u5 then
        if u10 then
            u10:Disconnect();
            u10 = nil;
        end;

        u10 = u5.MouseButton1Click:Connect(function() -- Line: 230
            -- upvalues: u17 (ref), u53 (copy)
            if u17 then
                u53:RotateMove(1);
            end;
        end);
    end;
end;

function v1.Start(u55) -- Line: 238
    -- upvalues: LocalPlayer (copy), u17 (ref), UserInputService (copy), CutsceneGate (copy), u16 (ref), Networking (copy), u27 (ref), u29 (ref), u28 (ref)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    u55:BindTrowelUi(PlayerGui);
    PlayerGui.ChildAdded:Connect(function(p56) -- Line: 243
        -- upvalues: u55 (copy), PlayerGui (copy), u17 (ref)
        if p56.Name == "TrowelUI" then
            u55:BindTrowelUi(PlayerGui);
            u55:SetMoveUiVisible(u17);
        end;
    end);
    u55:SetMoveUiVisible(false);
    UserInputService.InputBegan:Connect(function(p57, p58) -- Line: 252
        -- upvalues: u55 (copy)
        u55:OnInput(p57, p58);
    end);
    UserInputService.TouchTap:Connect(function(p59, p60) -- Line: 255
        -- upvalues: CutsceneGate (ref), u55 (copy)
        if p60 then
            return;
        end;

        if CutsceneGate.IsActive() then
            return;
        end;

        if u55:IsTouchOnMoveUi(p59) then
            return;
        end;

        u55:OnPrimaryAction();
    end);
    local Character = LocalPlayer.Character;

    if Character then
        u55:SetupCharacter(Character);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p61) -- Line: 270
        -- upvalues: u55 (copy)
        u55:SetupCharacter(p61);
    end);
    LocalPlayer:GetAttributeChangedSignal("PlotId"):Connect(function() -- Line: 274
        -- upvalues: u16 (ref)
        u16 = nil;
    end);
    Networking.Trowel.MoveRejected.OnClientEvent:Connect(function(p62) -- Line: 278
        -- upvalues: u27 (ref), u29 (ref), u28 (ref)
        if u27 and (u29 and u28 == p62) then
            if u27.Parent then
                u27:PivotTo(u29);
            end;

            u27 = nil;
            u28 = nil;
            u29 = nil;
        end;
    end);
end;

function v1.SetupCharacter(u63, p64) -- Line: 291
    -- upvalues: u15 (ref), u17 (ref)
    for _, child in p64:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("Trowel") then
            u15 = child;
            u63:StartHoverDetection();
        end;
    end;

    p64.ChildAdded:Connect(function(p65) -- Line: 301
        -- upvalues: u15 (ref), u63 (copy)
        if p65:IsA("Tool") and p65:GetAttribute("Trowel") then
            u15 = p65;
            u63:StartHoverDetection();
        end;
    end);
    p64.ChildRemoved:Connect(function(p66) -- Line: 308
        -- upvalues: u15 (ref), u17 (ref), u63 (copy)
        if p66:IsA("Tool") and (p66:GetAttribute("Trowel") and u15 == p66) then
            u15 = nil;

            if u17 then
                u63:CancelMove();
            end;

            u63:StopHoverDetection();
        end;
    end);
    local u67 = p64:FindFirstChildOfClass("Humanoid");

    if u67 then
        u67.Died:Connect(function() -- Line: 326
            -- upvalues: u17 (ref), u63 (copy), u67 (copy), u15 (ref)
            if u17 then
                u63:CancelMove();
            end;

            u67:UnequipTools();
            u15 = nil;
            u63:StopHoverDetection();
        end);
    end;
end;

function v1.GetPlayerPlantsFolder(p68) -- Line: 337
    -- upvalues: u16 (ref), LocalPlayer (copy), Gardens (copy)
    if u16 then
        return u16;
    end;

    local v69 = LocalPlayer:GetAttribute("PlotId");

    if not v69 then
        return nil;
    end;

    local v70 = Gardens:FindFirstChild("Plot" .. tostring(v69));

    if not v70 then
        return nil;
    end;

    u16 = v70:FindFirstChild("Plants");

    return u16;
end;

function v1.GetPlayerPlot(p71) -- Line: 356
    -- upvalues: LocalPlayer (copy), Gardens (copy)
    local v72 = LocalPlayer:GetAttribute("PlotId");

    if v72 then
        return Gardens:FindFirstChild("Plot" .. tostring(v72));
    end;

    return nil;
end;

function v1.IsWithinPlotBounds(p73, p74, p75) -- Line: 366
    local PlotSizeReference = p74:FindFirstChild("PlotSizeReference");

    if not (PlotSizeReference and PlotSizeReference:IsA("BasePart")) then
        return false;
    end;

    local v76 = PlotSizeReference.CFrame:PointToObjectSpace(p75);
    local v77 = PlotSizeReference.Size / 2;
    local v78;

    if math.abs(v76.X) <= v77.X then
        v78 = math.abs(v76.Z) <= v77.Z;
    else
        v78 = false;
    end;

    return v78;
end;

function v1.IsPartVisible(p79, p80) -- Line: 377
    return p80.Transparency < 1;
end;

function v1.CreateRaycastParams(p81, p82) -- Line: 381
    -- upvalues: LocalPlayer (copy)
    local v83 = RaycastParams.new();
    v83.FilterType = Enum.RaycastFilterType.Exclude;
    local v84 = {};
    local Character = LocalPlayer.Character;

    if Character then
        table.insert(v84, Character);
    end;

    if p82 then
        for _, v in p82 do
            table.insert(v84, v);
        end;
    end;

    v83.FilterDescendantsInstances = v84;

    return v83;
end;

function v1.RaycastIgnoreInvisible(p85, p86, p87, p88) -- Line: 400
    -- upvalues: LocalPlayer (copy), u18 (ref)
    local v89 = p87;
    local v90 = {};

    for _ = 1, 10 do
        local v91 = workspace:Raycast(p86, p87, p88);

        if not v91 then
            return nil;
        end;

        if p85:IsPartVisible(v91.Instance) then
            return v91;
        end;

        table.insert(v90, v91.Instance);
        local v92 = {};
        local Character = LocalPlayer.Character;

        if Character then
            table.insert(v92, Character);
        end;

        if u18 then
            table.insert(v92, u18);
        end;

        for _, v in v90 do
            table.insert(v92, v);
        end;

        p88.FilterDescendantsInstances = v92;
        local Magnitude = (v91.Position - p86).Magnitude;
        p86 = v91.Position + v89.Unit * 0.01;
        p87 = v89.Unit * (p87.Magnitude - Magnitude);

        if p87.Magnitude < 0.1 then
            return nil;
        end;
    end;

    return nil;
end;

function v1.IsUsingGamepad(p93) -- Line: 438
    -- upvalues: UserInputService (copy)
    local v94 = UserInputService:GetLastInputType();

    return (v94 == Enum.UserInputType.Gamepad1 or (v94 == Enum.UserInputType.Gamepad2 or v94 == Enum.UserInputType.Gamepad3)) and true or v94 == Enum.UserInputType.Gamepad4;
end;

function v1.GetMouseWorldRay(p95) -- Line: 446
    -- upvalues: LocalPlayer (copy), UserInputService (copy), CurrentCamera (copy)
    if not p95:IsUsingGamepad() then
        local v96 = UserInputService:GetMouseLocation();
        local v97 = CurrentCamera:ViewportPointToRay(v96.X, v96.Y);

        return v97.Origin, v97.Direction * 5000;
    end;

    local Character = LocalPlayer.Character;

    if not Character then
        return nil, nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        return HumanoidRootPart.Position + HumanoidRootPart.CFrame.LookVector * 8 + Vector3.new(0, 50, 0), Vector3.new(0, -100, 0);
    end;

    return nil, nil;
end;

function v1.GetPlantTarget(p98, p99) -- Line: 462
    if not p99 then
        return nil, nil;
    end;

    local v100 = p98:GetPlayerPlantsFolder();

    if not v100 then
        return nil, nil;
    end;

    while p99 and p99 ~= workspace do
        local Parent = p99.Parent;

        if Parent and Parent.Name == "Fruits" then
            local Parent2 = Parent.Parent;

            if Parent2 and Parent2.Parent == v100 then
                return Parent2, Parent2.Name;
            end;
        end;

        if Parent == v100 and p99:IsA("Model") then
            return p99, p99.Name;
        end;

        p99 = Parent;
    end;

    return nil, nil;
end;

function v1.ClearHighlight(p101) -- Line: 489
    -- upvalues: u11 (ref), u12 (ref), u13 (ref)
    if u11 then
        u11:Destroy();
        u11 = nil;
    end;

    u12 = nil;
    u13 = nil;
end;

function v1.DisableCollisions(p102, p103) -- Line: 502
    -- upvalues: u26 (ref)
    u26 = {};

    for _, descendant in p103:GetDescendants() do
        if descendant:IsA("BasePart") then
            u26[descendant] = {
                canCollide = descendant.CanCollide,
                anchored = descendant.Anchored,
                canTouch = descendant.CanTouch
            };
            descendant.CanCollide = false;
            descendant.Anchored = true;
            descendant.CanTouch = false;
        end;
    end;

    local PrimaryPart = p103.PrimaryPart;

    if PrimaryPart and not u26[PrimaryPart] then
        u26[PrimaryPart] = {
            canCollide = PrimaryPart.CanCollide,
            anchored = PrimaryPart.Anchored,
            canTouch = PrimaryPart.CanTouch
        };
        PrimaryPart.CanCollide = false;
        PrimaryPart.Anchored = true;
        PrimaryPart.CanTouch = false;
    end;
end;

function v1.RestoreCollisions(p104) -- Line: 522
    -- upvalues: u26 (ref)
    for i, v in u26 do
        if i and i.Parent then
            i.CanCollide = v.canCollide;
            i.Anchored = v.anchored;
            i.CanTouch = v.canTouch;
        end;
    end;

    u26 = {};
end;

local u105 = 0;

function v1.UpdateHoverHighlight(p106) -- Line: 539
    -- upvalues: u17 (ref), u105 (ref), u12 (ref), u11 (ref), u13 (ref)
    if u17 then
        return;
    end;

    local v107, v108 = p106:GetMouseWorldRay();

    if not v107 then
        return;
    end;

    local v109 = p106:RaycastIgnoreInvisible(v107, v108, (p106:CreateRaycastParams()));
    local v110, v111 = p106:GetPlantTarget(v109 and v109.Instance or nil);
    u105 = u105 + 1;

    if u105 >= 120 then
        u105 = 0;
    end;

    if v110 == u12 then
        return;
    end;

    p106:ClearHighlight();

    if v110 then
        local Highlight = Instance.new("Highlight");
        Highlight.FillColor = Color3.fromRGB(0, 255, 0);
        Highlight.FillTransparency = 0.5;
        Highlight.OutlineTransparency = 1;
        Highlight.Parent = v110;
        Highlight.Adornee = v110;
        u11 = Highlight;
        u12 = v110;
        u13 = v111;
    end;
end;

function v1.StartMove(p112) -- Line: 579
    -- upvalues: u12 (ref), u13 (ref), u17 (ref), u18 (ref), u19 (ref), u21 (ref), u24 (ref), u25 (ref), u22 (ref), u23 (ref), u20 (ref)
    if not (u12 and u13) then
        return;
    end;

    u17 = true;
    u18 = u12;
    u19 = u13;
    u21 = false;
    u24 = nil;
    u25 = u18:GetPivot();
    local PrimaryPart = u18.PrimaryPart;

    if PrimaryPart then
        local _, v113, _ = PrimaryPart.CFrame:ToEulerAnglesYXZ();
        u22 = math.deg(v113);
        u23 = PrimaryPart.Size.Y / 2;
    else
        u22 = 0;
        u23 = 0;
    end;

    p112:DisableCollisions(u18);
    p112:ClearHighlight();
    p112:SetMoveUiVisible(true);
    p112:BindGamepadRotateAction();
    p112:BindMoveCancelAction();
    local Highlight = Instance.new("Highlight");
    Highlight.FillColor = Color3.fromRGB(0, 255, 0);
    Highlight.FillTransparency = 0.5;
    Highlight.OutlineTransparency = 1;
    Highlight.Parent = u18;
    Highlight.Adornee = u18;
    u20 = Highlight;
end;

function v1.UpdateMovingPlant(p114) -- Line: 617
    -- upvalues: u17 (ref), u18 (ref), u21 (ref), u20 (ref), u24 (ref), u22 (ref)
    if not (u17 and u18) then
        return;
    end;

    for _, descendant in u18:GetDescendants() do
        if descendant:IsA("BasePart") then
            if descendant.CanCollide then
                descendant.CanCollide = false;
            end;

            if descendant.CanTouch then
                descendant.CanTouch = false;
            end;
        end;
    end;

    local v115, v116 = p114:GetMouseWorldRay();

    if not v115 then
        return;
    end;

    local v117 = p114:RaycastIgnoreInvisible(v115, v116, (p114:CreateRaycastParams({ u18 })));

    if not v117 then
        u21 = false;

        if u20 then
            u20.FillColor = Color3.fromRGB(255, 0, 0);
        end;

        return;
    end;

    local v118 = p114:GetPlayerPlot();
    local v119 = v117.Instance:HasTag("PlantArea");

    if v119 then
        if v118 == nil then
            v119 = false;
        else
            v119 = v117.Instance:IsDescendantOf(v118) and p114:IsWithinPlotBounds(v118, v117.Position);
        end;
    end;

    u21 = v119;
    u24 = v117.Position;
    u18:PivotTo(CFrame.new(v117.Position.X, v117.Position.Y + 3, v117.Position.Z) * CFrame.Angles(0, math.rad(u22), 0));

    if u20 then
        u20.FillColor = u21 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0);
    end;
end;

function v1.LandPlant(p120, u121, p122, p123, p124, u125) -- Line: 666
    -- upvalues: TweenService (copy), u2 (copy)
    if not (u121 and u121.Parent) then
        return;
    end;

    local function restoreTheseCollisions() -- Line: 671
        -- upvalues: u125 (copy)
        for i, v in u125 do
            if i and i.Parent then
                i.CanCollide = v.canCollide;
                i.Anchored = v.anchored;
                i.CanTouch = v.canTouch;
            end;
        end;
    end;

    local u126 = CFrame.new(p122.X, p122.Y, p122.Z) * CFrame.Angles(0, math.rad(p123), 0);

    if not u121.PrimaryPart then
        u121:PivotTo(u126);
        restoreTheseCollisions();

        return;
    end;

    local u127 = u121:GetPivot();
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Value = 0;
    local v128 = TweenService:Create(NumberValue, u2, {
        Value = 1
    });
    local u129 = NumberValue.Changed:Connect(function() -- Line: 695
        -- upvalues: u121 (copy), u127 (copy), u126 (copy), NumberValue (copy)
        if u121 and u121.Parent then
            u121:PivotTo(u127:Lerp(u126, NumberValue.Value));
        end;
    end);
    v128.Completed:Connect(function() -- Line: 701
        -- upvalues: u129 (ref), NumberValue (copy), u121 (copy), u126 (copy), restoreTheseCollisions (copy)
        u129:Disconnect();
        NumberValue:Destroy();

        if u121 and u121.Parent then
            u121:PivotTo(u126);
        end;

        restoreTheseCollisions();
    end);
    v128:Play();
end;

function v1.ConfirmMove(p130) -- Line: 717
    -- upvalues: u17 (ref), u18 (ref), u21 (ref), u24 (ref), Networking (copy), u19 (ref), u22 (ref), u23 (ref), u25 (ref), u26 (ref), u27 (ref), u28 (ref), u29 (ref)
    if not (u17 and (u18 and (u21 and u24))) then
        return;
    end;

    Networking.Trowel.MovePlant:Fire(u19, u24, u22);
    local v131 = u18;
    local u132 = u19;
    local v133 = u26;
    u27 = v131;
    u28 = u132;
    u29 = u25;
    u26 = {};
    p130:EndMove(false);
    p130:LandPlant(v131, u24, u22, u23, v133);
    task.delay(2, function() -- Line: 740
        -- upvalues: u28 (ref), u132 (copy), u27 (ref), u29 (ref)
        if u28 == u132 then
            u27 = nil;
            u28 = nil;
            u29 = nil;
        end;
    end);
end;

function v1.RotateMove(p134, p135) -- Line: 749
    -- upvalues: u17 (ref), u22 (ref)
    if not u17 then
        return;
    end;

    u22 = (u22 + p135 * 45) % 360;
end;

function v1.CancelMove(p136) -- Line: 756
    -- upvalues: u17 (ref), u18 (ref), u25 (ref)
    if not u17 then
        return;
    end;

    if u18 and u25 then
        u18:PivotTo(u25);
    end;

    p136:EndMove(true);
end;

function v1.EndMove(p137, p138) -- Line: 766
    -- upvalues: u20 (ref), u17 (ref), u18 (ref), u19 (ref), u21 (ref), u24 (ref), u25 (ref)
    if u20 then
        u20:Destroy();
        u20 = nil;
    end;

    if p138 ~= false then
        p137:RestoreCollisions();
    end;

    u17 = false;
    u18 = nil;
    u19 = nil;
    u21 = false;
    u24 = nil;
    u25 = nil;
    p137:SetMoveUiVisible(false);
    p137:UnbindGamepadRotateAction();
    p137:UnbindMoveCancelAction();
end;

function v1.StartHoverDetection(u139) -- Line: 793
    -- upvalues: u14 (ref), HideCollectProximityPrompts (copy), RunService (copy), u17 (ref)
    if u14 then
        return;
    end;

    HideCollectProximityPrompts.Value = true;
    u14 = RunService.RenderStepped:Connect(function() -- Line: 798
        -- upvalues: u17 (ref), u139 (copy)
        debug.profilebegin("Controllers/TrowelController/RenderStepped");

        if u17 then
            u139:UpdateMovingPlant();
        else
            u139:UpdateHoverHighlight();
        end;

        debug.profileend();
    end);
end;

function v1.StopHoverDetection(p140) -- Line: 809
    -- upvalues: HideCollectProximityPrompts (copy), u14 (ref), u17 (ref)
    HideCollectProximityPrompts.Value = false;

    if u14 then
        u14:Disconnect();
        u14 = nil;
    end;

    if u17 then
        p140:CancelMove();
    end;

    p140:ClearHighlight();
end;

function v1.OnInput(p141, p142, p143) -- Line: 827
    -- upvalues: u15 (ref), CutsceneGate (copy), u17 (ref)
    if p143 then
        return;
    end;

    if not u15 then
        return;
    end;

    if CutsceneGate.IsActive() then
        return;
    end;

    local v144 = (p142.UserInputType == Enum.UserInputType.MouseButton1 or p142.KeyCode == Enum.KeyCode.ButtonA) and true or p142.KeyCode == Enum.KeyCode.ButtonR2;
    local v145 = (p142.KeyCode == Enum.KeyCode.R or p142.KeyCode == Enum.KeyCode.ButtonL1) and true or p142.KeyCode == Enum.KeyCode.ButtonR1;

    if (p142.KeyCode == Enum.KeyCode.C and true or p142.KeyCode == Enum.KeyCode.ButtonB) and u17 then
        p141:CancelMove();

        return;
    end;

    if v145 and u17 then
        p141:RotateMove(p142.KeyCode == Enum.KeyCode.ButtonL1 and -1 or 1);

        return;
    end;

    if v144 then
        p141:OnPrimaryAction();
    end;
end;

function v1.OnPrimaryAction(p146) -- Line: 860
    -- upvalues: u15 (ref), u17 (ref), u12 (ref), u13 (ref)
    if not u15 then
        return;
    end;

    if u17 then
        p146:ConfirmMove();

        return;
    end;

    if u12 and u13 then
        p146:StartMove();
    end;
end;

return v1;