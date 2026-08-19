-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local TweenService = UtilsSystem.TweenService;
local PlayerGui = UtilsSystem.Players.LocalPlayer:WaitForChild("PlayerGui");
local u1 = {};
local u2 = {
    ScreenGui = nil,
    MainFrame = nil,
    ToggleButton = nil,
    IDInput = nil,
    AmountInput = nil,
    AddButton = nil,
    ReduceButton = nil,
    ClearButton = nil,
    SkillSlot1Input = nil,
    SkillSlot2Input = nil,
    SkillSlot3Input = nil,
    EquipSkillButton = nil,
    UnequipSkillButton = nil,
    ButtonWindowScrollFrame = nil
};
local u3 = {
    ID = "",
    Amount = "",
    SkillSlot1 = "",
    SkillSlot2 = "",
    SkillSlot3 = ""
};
local u4 = {};
local u5 = {
    OnAddClick = nil,
    OnReduceClick = nil,
    OnClearClick = nil,
    OnEquipSkillClick = nil,
    OnUnequipSkillClick = nil
};
local u6 = {};
local u7 = {};
local u8 = false;

local function _createInputGroup(p9, u10, p11) -- Line: 66
    -- upvalues: u3 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = u10 .. "Group";
    Frame.Size = UDim2.new(1, 0, 0, 50);
    Frame.Position = UDim2.new(0, 0, 0, p11);
    Frame.BackgroundTransparency = 1;
    Frame.Parent = p9;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Label";
    TextLabel.Size = UDim2.new(0, 90, 0, 30);
    TextLabel.Position = UDim2.new(0, 0, 0, 10);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = u10 .. ":";
    TextLabel.TextColor3 = Color3.fromRGB(220, 220, 220);
    TextLabel.TextSize = 20;
    TextLabel.Font = Enum.Font.Gotham;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "InputFrame";
    Frame2.Size = UDim2.new(1, -90, 0, 36);
    Frame2.Position = UDim2.new(0, 90, 0, 7);
    Frame2.BackgroundColor3 = Color3.fromRGB(50, 50, 50);
    Frame2.BorderSizePixel = 0;
    Frame2.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, 5);
    UICorner.Parent = Frame2;
    local TextBox = Instance.new("TextBox");
    TextBox.Name = "TextBox";
    TextBox.Size = UDim2.new(1, -8, 1, -8);
    TextBox.Position = UDim2.new(0, 4, 0, 4);
    TextBox.BackgroundTransparency = 1;
    TextBox.Text = "";
    TextBox.PlaceholderText = "请输入" .. u10;
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 140);
    TextBox.TextSize = 20;
    TextBox.Font = Enum.Font.Gotham;
    TextBox.TextXAlignment = Enum.TextXAlignment.Left;
    TextBox.ClearTextOnFocus = false;
    TextBox.Parent = Frame2;
    TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 118
        -- upvalues: u10 (copy), u3 (ref), TextBox (copy)
        if u10 == "ID" then
            u3.ID = TextBox.Text;

            return;
        end;

        if u10 == "物品数量" then
            u3.Amount = TextBox.Text;
        end;
    end);

    return TextBox;
end;

local function _createDynamicButton(u12, p13, p14) -- Line: 137
    -- upvalues: _createInputGroup (copy), u4 (ref), TweenService (copy)
    local v15 = u12.Param1Name and u12.Param1Name ~= "";
    local v16 = u12.Param2Name and u12.Param2Name ~= "";
    local v17 = (v15 and 1 or 0) + (v16 and 1 or 0);
    local Frame = Instance.new("Frame");
    Frame.Name = u12.Name .. "Container";
    Frame.Size = UDim2.new(1, 0, 0, 24 + v17 * 50 + 42 + 24);
    Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 50);
    Frame.BorderSizePixel = 0;
    Frame.LayoutOrder = p13;
    Frame.Parent = p14;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, 8);
    UICorner.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "ContentFrame";
    Frame2.Size = UDim2.new(1, -16, 1, -24);
    Frame2.Position = UDim2.new(0, 8, 0, 12);
    Frame2.BackgroundTransparency = 1;
    Frame2.Parent = Frame;
    local u18;

    if v15 then
        u18 = _createInputGroup(Frame2, u12.Param1Name, 0);
        u18:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 175
            -- upvalues: u4 (ref), u12 (copy), u18 (ref)
            if not u4[u12.Name] then
                u4[u12.Name] = {};
            end;

            u4[u12.Name].Param1 = u18.Text;
        end);
    else
        u18 = nil;
    end;

    local u19;

    if v16 then
        u19 = _createInputGroup(Frame2, u12.Param2Name, v15 and 50 or 0);
        u19:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 188
            -- upvalues: u4 (ref), u12 (copy), u19 (ref)
            if not u4[u12.Name] then
                u4[u12.Name] = {};
            end;

            u4[u12.Name].Param2 = u19.Text;
        end);
    else
        u19 = nil;
    end;

    local TextButton = Instance.new("TextButton");
    TextButton.Name = u12.Name .. "Button";
    TextButton.Size = UDim2.new(1, 0, 0, 42);
    TextButton.Position = UDim2.new(0, 0, 0, v17 * 50);
    TextButton.BorderSizePixel = 0;
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextButton.TextSize = 22;
    TextButton.Font = Enum.Font.GothamBold;
    TextButton.BackgroundColor3 = u12.Color or Color3.fromRGB(70, 130, 180);
    TextButton.Text = u12.Name;
    TextButton.Parent = Frame2;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(0, 6);
    UICorner2.Parent = TextButton;
    local u20 = u12.Color or Color3.fromRGB(70, 130, 180);
    TextButton.MouseEnter:Connect(function() -- Line: 218
        -- upvalues: TweenService (ref), TextButton (copy), u20 (copy)
        TweenService:Create(TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = u20:Lerp(Color3.fromRGB(255, 255, 255), 0.2)
        }):Play();
    end);
    TextButton.MouseLeave:Connect(function() -- Line: 227
        -- upvalues: TweenService (ref), TextButton (copy), u20 (copy)
        TweenService:Create(TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = u20
        }):Play();
    end);

    if u12.Callback then
        TextButton.MouseButton1Click:Connect(function() -- Line: 238
            -- upvalues: u12 (copy)
            u12.Callback();
        end);
    end;

    if not u4[u12.Name] then
        u4[u12.Name] = {};

        if v15 then
            u4[u12.Name].Param1 = "";
        end;

        if v16 then
            u4[u12.Name].Param2 = "";
        end;
    end;

    u12._Param1Input = u18;
    u12._Param2Input = u19;
    u12._Button = TextButton;

    return Frame;
end;

local function _createAllDynamicButtons() -- Line: 266
    -- upvalues: u2 (ref), u6 (ref), u7 (ref), _createDynamicButton (copy)
    local ButtonWindowScrollFrame = u2.ButtonWindowScrollFrame;

    if not ButtonWindowScrollFrame then
        return;
    end;

    for i, v in ipairs(u6) do
        if not u7[v.Name] then
            local v21 = _createDynamicButton(v, i, ButtonWindowScrollFrame);
            u7[v.Name] = v21;
        end;
    end;
end;

function u1.CreateUI() -- Line: 284
    -- upvalues: u8 (ref), u2 (ref), u7 (ref), PlayerGui (copy), u1 (copy), _createInputGroup (copy), TweenService (copy), u5 (ref), u3 (ref), _createAllDynamicButtons (copy)
    if not (u8 and (u2.ScreenGui and u2.ScreenGui.Parent)) then
        if u2.ScreenGui and not u2.ScreenGui.Parent then
            u2.ScreenGui = nil;
            u8 = false;
            u7 = {};
        end;

        local ScreenGui = Instance.new("ScreenGui");
        ScreenGui.Name = "DebugSystemUI";
        ScreenGui.ResetOnSpawn = false;
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
        ScreenGui.DisplayOrder = 999;
        ScreenGui.IgnoreGuiInset = true;
        ScreenGui.Parent = PlayerGui;
        u2.ScreenGui = ScreenGui;
        local Frame = Instance.new("Frame");
        Frame.Name = "MainFrame";
        Frame.Size = UDim2.new(0, 420, 0, 700);
        Frame.Position = UDim2.new(1, -430, 0.5, -350);
        Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
        Frame.BorderSizePixel = 0;
        Frame.ZIndex = 10;
        Frame.Visible = false;
        Frame.Parent = ScreenGui;
        u2.MainFrame = Frame;
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(0, 8);
        UICorner.Parent = Frame;
        local Frame2 = Instance.new("Frame");
        Frame2.Name = "TitleBar";
        Frame2.Size = UDim2.new(1, 0, 0, 45);
        Frame2.Position = UDim2.new(0, 0, 0, 0);
        Frame2.BackgroundColor3 = Color3.fromRGB(20, 20, 20);
        Frame2.BorderSizePixel = 0;
        Frame2.ZIndex = 11;
        Frame2.Parent = Frame;
        local UICorner2 = Instance.new("UICorner");
        UICorner2.CornerRadius = UDim.new(0, 8);
        UICorner2.Parent = Frame2;
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = "TitleLabel";
        TextLabel.Size = UDim2.new(1, -50, 1, 0);
        TextLabel.Position = UDim2.new(0, 15, 0, 0);
        TextLabel.BackgroundTransparency = 1;
        TextLabel.ZIndex = 12;
        TextLabel.Text = "调试系统";
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
        TextLabel.TextSize = 26;
        TextLabel.Font = Enum.Font.GothamBold;
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel.Parent = Frame2;
        local TextButton = Instance.new("TextButton");
        TextButton.Name = "CloseButton";
        TextButton.Size = UDim2.new(0, 30, 0, 30);
        TextButton.Position = UDim2.new(1, -35, 0.5, -15);
        TextButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50);
        TextButton.BorderSizePixel = 0;
        TextButton.ZIndex = 12;
        TextButton.Text = "×";
        TextButton.TextColor3 = Color3.fromRGB(255, 255, 255);
        TextButton.TextSize = 28;
        TextButton.Font = Enum.Font.GothamBold;
        TextButton.Parent = Frame2;
        local UICorner3 = Instance.new("UICorner");
        UICorner3.CornerRadius = UDim.new(0, 4);
        UICorner3.Parent = TextButton;
        TextButton.MouseButton1Click:Connect(function() -- Line: 371
            -- upvalues: u1 (ref)
            u1.Hide();
        end);
        local ScrollingFrame = Instance.new("ScrollingFrame");
        ScrollingFrame.Name = "ContentScrollFrame";
        ScrollingFrame.Size = UDim2.new(1, 0, 1, -45);
        ScrollingFrame.Position = UDim2.new(0, 0, 0, 45);
        ScrollingFrame.BackgroundTransparency = 1;
        ScrollingFrame.BorderSizePixel = 0;
        ScrollingFrame.ScrollBarThickness = 6;
        ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100);
        ScrollingFrame.Parent = Frame;
        local Frame3 = Instance.new("Frame");
        Frame3.Name = "ContentFrame";
        Frame3.Size = UDim2.new(0, 350, 0, 1000);
        Frame3.Position = UDim2.new(0, 20, 0, 0);
        Frame3.BackgroundTransparency = 1;
        Frame3.Parent = ScrollingFrame;
        u2.IDInput = _createInputGroup(Frame3, "ID", 25);
        u2.AmountInput = _createInputGroup(Frame3, "物品数量", 95);
        local Frame4 = Instance.new("Frame");
        Frame4.Name = "ButtonFrame";
        Frame4.Size = UDim2.new(1, 0, 0, 50);
        Frame4.Position = UDim2.new(0, 0, 0, 165);
        Frame4.BackgroundTransparency = 1;
        Frame4.Parent = Frame3;
        local UIListLayout = Instance.new("UIListLayout");
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout.Padding = UDim.new(0, 8);
        UIListLayout.Parent = Frame4;
        u2.AddButton = Instance.new("TextButton");
        u2.AddButton.Name = "添加Button";
        u2.AddButton.Size = UDim2.new(0, 95, 0, 40);
        u2.AddButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50);
        u2.AddButton.BorderSizePixel = 0;
        u2.AddButton.Text = "添加";
        u2.AddButton.TextColor3 = Color3.fromRGB(255, 255, 255);
        u2.AddButton.TextSize = 22;
        u2.AddButton.Font = Enum.Font.GothamBold;
        u2.AddButton.LayoutOrder = 1;
        u2.AddButton.Parent = Frame4;
        local UICorner4 = Instance.new("UICorner");
        UICorner4.CornerRadius = UDim.new(0, 6);
        UICorner4.Parent = u2.AddButton;
        u2.AddButton.MouseEnter:Connect(function() -- Line: 442
            -- upvalues: TweenService (ref), u2 (ref)
            TweenService:Create(u2.AddButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(50, 150, 50):Lerp(Color3.fromRGB(255, 255, 255), 0.2)
            }):Play();
        end);
        u2.AddButton.MouseLeave:Connect(function() -- Line: 451
            -- upvalues: TweenService (ref), u2 (ref)
            TweenService:Create(u2.AddButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            }):Play();
        end);
        u2.AddButton.MouseButton1Click:Connect(function() -- Line: 460
            -- upvalues: u5 (ref)
            if u5.OnAddClick then
                u5.OnAddClick();
            end;
        end);
        u2.ReduceButton = Instance.new("TextButton");
        u2.ReduceButton.Name = "减少Button";
        u2.ReduceButton.Size = UDim2.new(0, 95, 0, 40);
        u2.ReduceButton.BackgroundColor3 = Color3.fromRGB(150, 100, 50);
        u2.ReduceButton.BorderSizePixel = 0;
        u2.ReduceButton.Text = "减少";
        u2.ReduceButton.TextColor3 = Color3.fromRGB(255, 255, 255);
        u2.ReduceButton.TextSize = 22;
        u2.ReduceButton.Font = Enum.Font.GothamBold;
        u2.ReduceButton.LayoutOrder = 2;
        u2.ReduceButton.Parent = Frame4;
        local UICorner5 = Instance.new("UICorner");
        UICorner5.CornerRadius = UDim.new(0, 6);
        UICorner5.Parent = u2.ReduceButton;
        u2.ReduceButton.MouseEnter:Connect(function() -- Line: 484
            -- upvalues: TweenService (ref), u2 (ref)
            TweenService:Create(u2.ReduceButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(150, 100, 50):Lerp(Color3.fromRGB(255, 255, 255), 0.2)
            }):Play();
        end);
        u2.ReduceButton.MouseLeave:Connect(function() -- Line: 493
            -- upvalues: TweenService (ref), u2 (ref)
            TweenService:Create(u2.ReduceButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(150, 100, 50)
            }):Play();
        end);
        u2.ReduceButton.MouseButton1Click:Connect(function() -- Line: 502
            -- upvalues: u5 (ref)
            if u5.OnReduceClick then
                u5.OnReduceClick();
            end;
        end);
        u2.ClearButton = Instance.new("TextButton");
        u2.ClearButton.Name = "清空Button";
        u2.ClearButton.Size = UDim2.new(0, 95, 0, 40);
        u2.ClearButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50);
        u2.ClearButton.BorderSizePixel = 0;
        u2.ClearButton.Text = "清空";
        u2.ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255);
        u2.ClearButton.TextSize = 22;
        u2.ClearButton.Font = Enum.Font.GothamBold;
        u2.ClearButton.LayoutOrder = 3;
        u2.ClearButton.Parent = Frame4;
        local UICorner6 = Instance.new("UICorner");
        UICorner6.CornerRadius = UDim.new(0, 6);
        UICorner6.Parent = u2.ClearButton;
        u2.ClearButton.MouseEnter:Connect(function() -- Line: 526
            -- upvalues: TweenService (ref), u2 (ref)
            TweenService:Create(u2.ClearButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(150, 50, 50):Lerp(Color3.fromRGB(255, 255, 255), 0.2)
            }):Play();
        end);
        u2.ClearButton.MouseLeave:Connect(function() -- Line: 535
            -- upvalues: TweenService (ref), u2 (ref)
            TweenService:Create(u2.ClearButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(150, 50, 50)
            }):Play();
        end);
        u2.ClearButton.MouseButton1Click:Connect(function() -- Line: 544
            -- upvalues: u5 (ref)
            if u5.OnClearClick then
                u5.OnClearClick();
            end;
        end);
        local TextLabel2 = Instance.new("TextLabel");
        TextLabel2.Name = "SkillSectionTitle";
        TextLabel2.Size = UDim2.new(1, 0, 0, 30);
        TextLabel2.Position = UDim2.new(0, 0, 0, 225);
        TextLabel2.BackgroundTransparency = 1;
        TextLabel2.Text = "技能装备";
        TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255);
        TextLabel2.TextSize = 24;
        TextLabel2.Font = Enum.Font.GothamBold;
        TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel2.Parent = Frame3;
        u2.SkillSlot1Input = _createInputGroup(Frame3, "技能槽1 ID", 255);
        u2.SkillSlot1Input:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 564
            -- upvalues: u3 (ref), u2 (ref)
            u3.SkillSlot1 = u2.SkillSlot1Input.Text;
        end);
        u2.SkillSlot2Input = _createInputGroup(Frame3, "技能槽2 ID", 325);
        u2.SkillSlot2Input:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 569
            -- upvalues: u3 (ref), u2 (ref)
            u3.SkillSlot2 = u2.SkillSlot2Input.Text;
        end);
        u2.SkillSlot3Input = _createInputGroup(Frame3, "技能槽3 ID", 395);
        u2.SkillSlot3Input:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 574
            -- upvalues: u3 (ref), u2 (ref)
            u3.SkillSlot3 = u2.SkillSlot3Input.Text;
        end);
        local Frame5 = Instance.new("Frame");
        Frame5.Name = "SkillButtonFrame";
        Frame5.Size = UDim2.new(1, 0, 0, 50);
        Frame5.Position = UDim2.new(0, 0, 0, 465);
        Frame5.BackgroundTransparency = 1;
        Frame5.Parent = Frame3;
        local UIListLayout2 = Instance.new("UIListLayout");
        UIListLayout2.FillDirection = Enum.FillDirection.Horizontal;
        UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center;
        UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center;
        UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout2.Padding = UDim.new(0, 8);
        UIListLayout2.Parent = Frame5;
        u2.EquipSkillButton = Instance.new("TextButton");
        u2.EquipSkillButton.Name = "EquipSkillButton";
        u2.EquipSkillButton.Size = UDim2.new(0, 150, 0, 40);
        u2.EquipSkillButton.BackgroundColor3 = Color3.fromRGB(50, 130, 180);
        u2.EquipSkillButton.BorderSizePixel = 0;
        u2.EquipSkillButton.Text = "装备技能";
        u2.EquipSkillButton.TextColor3 = Color3.fromRGB(255, 255, 255);
        u2.EquipSkillButton.TextSize = 22;
        u2.EquipSkillButton.Font = Enum.Font.GothamBold;
        u2.EquipSkillButton.LayoutOrder = 1;
        u2.EquipSkillButton.Parent = Frame5;
        local UICorner7 = Instance.new("UICorner");
        UICorner7.CornerRadius = UDim.new(0, 6);
        UICorner7.Parent = u2.EquipSkillButton;
        u2.EquipSkillButton.MouseButton1Click:Connect(function() -- Line: 611
            -- upvalues: u5 (ref)
            if u5.OnEquipSkillClick then
                u5.OnEquipSkillClick();
            end;
        end);
        u2.UnequipSkillButton = Instance.new("TextButton");
        u2.UnequipSkillButton.Name = "UnequipSkillButton";
        u2.UnequipSkillButton.Size = UDim2.new(0, 150, 0, 40);
        u2.UnequipSkillButton.BackgroundColor3 = Color3.fromRGB(150, 80, 50);
        u2.UnequipSkillButton.BorderSizePixel = 0;
        u2.UnequipSkillButton.Text = "卸下技能";
        u2.UnequipSkillButton.TextColor3 = Color3.fromRGB(255, 255, 255);
        u2.UnequipSkillButton.TextSize = 22;
        u2.UnequipSkillButton.Font = Enum.Font.GothamBold;
        u2.UnequipSkillButton.LayoutOrder = 2;
        u2.UnequipSkillButton.Parent = Frame5;
        local UICorner8 = Instance.new("UICorner");
        UICorner8.CornerRadius = UDim.new(0, 6);
        UICorner8.Parent = u2.UnequipSkillButton;
        u2.UnequipSkillButton.MouseButton1Click:Connect(function() -- Line: 633
            -- upvalues: u5 (ref)
            if u5.OnUnequipSkillClick then
                u5.OnUnequipSkillClick();
            end;
        end);
        local TextButton2 = Instance.new("TextButton");
        TextButton2.Name = "ToggleButton";
        TextButton2.Size = UDim2.new(0, 120, 0, 45);
        TextButton2.Position = UDim2.new(1, -130, 1, -55);
        TextButton2.BackgroundColor3 = Color3.fromRGB(50, 100, 150);
        TextButton2.BorderSizePixel = 0;
        TextButton2.ZIndex = 10;
        TextButton2.Text = "调试窗口";
        TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255);
        TextButton2.TextSize = 22;
        TextButton2.Font = Enum.Font.GothamBold;
        TextButton2.Parent = ScreenGui;
        local UICorner9 = Instance.new("UICorner");
        UICorner9.CornerRadius = UDim.new(0, 8);
        UICorner9.Parent = TextButton2;
        TextButton2.MouseEnter:Connect(function() -- Line: 658
            -- upvalues: TweenService (ref), TextButton2 (copy)
            TweenService:Create(TextButton2, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(50, 100, 150):Lerp(Color3.fromRGB(255, 255, 255), 0.2)
            }):Play();
        end);
        TextButton2.MouseLeave:Connect(function() -- Line: 667
            -- upvalues: TweenService (ref), TextButton2 (copy)
            TweenService:Create(TextButton2, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(50, 100, 150)
            }):Play();
        end);
        TextButton2.MouseButton1Click:Connect(function() -- Line: 677
            -- upvalues: Frame (copy), TextButton2 (copy)
            if Frame.Visible then
                Frame.Visible = false;
                TextButton2.Text = "调试窗口";

                return;
            end;

            Frame.Visible = true;
            TextButton2.Text = "关闭调试";
        end);
        u2.ToggleButton = TextButton2;
        local Frame6 = Instance.new("Frame");
        Frame6.Name = "Divider";
        Frame6.Size = UDim2.new(1, 0, 0, 2);
        Frame6.Position = UDim2.new(0, 0, 0, 530);
        Frame6.BackgroundColor3 = Color3.fromRGB(100, 100, 100);
        Frame6.BorderSizePixel = 0;
        Frame6.Parent = Frame3;
        local UICorner10 = Instance.new("UICorner");
        UICorner10.CornerRadius = UDim.new(0, 1);
        UICorner10.Parent = Frame6;
        local TextLabel3 = Instance.new("TextLabel");
        TextLabel3.Name = "ButtonSectionTitle";
        TextLabel3.Size = UDim2.new(1, 0, 0, 30);
        TextLabel3.Position = UDim2.new(0, 0, 0, 540);
        TextLabel3.BackgroundTransparency = 1;
        TextLabel3.Text = "动态按钮";
        TextLabel3.TextColor3 = Color3.fromRGB(255, 255, 255);
        TextLabel3.TextSize = 24;
        TextLabel3.Font = Enum.Font.GothamBold;
        TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel3.Parent = Frame3;
        local ScrollingFrame2 = Instance.new("ScrollingFrame");
        ScrollingFrame2.Name = "ButtonScrollFrame";
        ScrollingFrame2.Size = UDim2.new(1, -10, 0, 400);
        ScrollingFrame2.Position = UDim2.new(0, 0, 0, 580);
        ScrollingFrame2.BackgroundTransparency = 1;
        ScrollingFrame2.BorderSizePixel = 0;
        ScrollingFrame2.ScrollBarThickness = 6;
        ScrollingFrame2.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100);
        ScrollingFrame2.Parent = Frame3;
        u2.ButtonWindowScrollFrame = ScrollingFrame2;
        local UIListLayout3 = Instance.new("UIListLayout");
        UIListLayout3.FillDirection = Enum.FillDirection.Vertical;
        UIListLayout3.HorizontalAlignment = Enum.HorizontalAlignment.Center;
        UIListLayout3.VerticalAlignment = Enum.VerticalAlignment.Top;
        UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout3.Padding = UDim.new(0, 12);
        UIListLayout3.Parent = ScrollingFrame2;
        local u22 = false;
        UIListLayout3:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line: 741
            -- upvalues: u22 (ref), ScrollingFrame2 (copy), UIListLayout3 (copy)
            if not u22 then
                u22 = true;
                task.defer(function() -- Line: 744
                    -- upvalues: ScrollingFrame2 (ref), UIListLayout3 (ref), u22 (ref)
                    if ScrollingFrame2 and UIListLayout3 then
                        ScrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, UIListLayout3.AbsoluteContentSize.Y + 20);
                    end;

                    u22 = false;
                end);
            end;
        end);
        local UIListLayout4 = Instance.new("UIListLayout");
        UIListLayout4.FillDirection = Enum.FillDirection.Vertical;
        UIListLayout4.HorizontalAlignment = Enum.HorizontalAlignment.Left;
        UIListLayout4.VerticalAlignment = Enum.VerticalAlignment.Top;
        UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout4.Padding = UDim.new(0, 0);
        UIListLayout4.Parent = Frame3;
        local u23 = false;
        UIListLayout4:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line: 763
            -- upvalues: u23 (ref), Frame3 (copy), UIListLayout4 (copy), ScrollingFrame (copy)
            if not u23 then
                u23 = true;
                task.defer(function() -- Line: 766
                    -- upvalues: Frame3 (ref), UIListLayout4 (ref), ScrollingFrame (ref), u23 (ref)
                    if Frame3 and (UIListLayout4 and ScrollingFrame) then
                        Frame3.Size = UDim2.new(1, 0, 0, UIListLayout4.AbsoluteContentSize.Y + 20);
                        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, Frame3.Size.Y.Offset);
                    end;

                    u23 = false;
                end);
            end;
        end);
        _createAllDynamicButtons();
        u8 = true;

        return ScreenGui;
    end;
end;

function u1.Show() -- Line: 789
    -- upvalues: u8 (ref), u2 (ref), u1 (copy)
    if not (u8 and (u2.ScreenGui and u2.ScreenGui.Parent)) then
        u1.CreateUI();
    end;

    if u2.MainFrame then
        if u2.MainFrame.Visible then
            if u2.ToggleButton then
                u2.ToggleButton.Text = "关闭调试";
            end;
        else
            u2.MainFrame.Visible = true;

            if u2.ToggleButton then
                u2.ToggleButton.Text = "关闭调试";
            end;
        end;
    end;
end;

function u1.Hide() -- Line: 815
    -- upvalues: u2 (ref)
    if u2.MainFrame then
        u2.MainFrame.Visible = false;

        if u2.ToggleButton then
            u2.ToggleButton.Text = "调试窗口";
        end;
    end;
end;

function u1.Toggle() -- Line: 828
    -- upvalues: u8 (ref), u2 (ref), u1 (copy)
    if not (u8 and (u2.ScreenGui and u2.ScreenGui.Parent)) then
        u1.CreateUI();
    end;

    if u2.MainFrame then
        local Visible = u2.MainFrame.Visible;
        u2.MainFrame.Visible = not Visible;

        if u2.ToggleButton then
            u2.ToggleButton.Text = Visible and "调试窗口" or "关闭调试";
        end;
    end;
end;

function u1.GetID() -- Line: 849
    -- upvalues: u3 (ref)
    return u3.ID;
end;

function u1.GetAmount() -- Line: 857
    -- upvalues: u3 (ref)
    return u3.Amount;
end;

function u1.SetID(p24) -- Line: 866
    -- upvalues: u3 (ref), u2 (ref)
    u3.ID = p24;

    if u2.IDInput then
        u2.IDInput.Text = p24;
    end;
end;

function u1.SetAmount(p25) -- Line: 878
    -- upvalues: u3 (ref), u2 (ref)
    u3.Amount = p25;

    if u2.AmountInput then
        u2.AmountInput.Text = p25;
    end;
end;

function u1.OnAddClick(p26) -- Line: 890
    -- upvalues: u5 (ref)
    u5.OnAddClick = p26;
end;

function u1.OnReduceClick(p27) -- Line: 899
    -- upvalues: u5 (ref)
    u5.OnReduceClick = p27;
end;

function u1.OnClearClick(p28) -- Line: 908
    -- upvalues: u5 (ref)
    u5.OnClearClick = p28;
end;

function u1.GetSkillSlot1ID() -- Line: 916
    -- upvalues: u3 (ref)
    return u3.SkillSlot1;
end;

function u1.GetSkillSlot2ID() -- Line: 924
    -- upvalues: u3 (ref)
    return u3.SkillSlot2;
end;

function u1.GetSkillSlot3ID() -- Line: 932
    -- upvalues: u3 (ref)
    return u3.SkillSlot3;
end;

function u1.OnEquipSkillClick(p29) -- Line: 941
    -- upvalues: u5 (ref)
    u5.OnEquipSkillClick = p29;
end;

function u1.OnUnequipSkillClick(p30) -- Line: 950
    -- upvalues: u5 (ref)
    u5.OnUnequipSkillClick = p30;
end;

function u1.GetButtonParam1(p31) -- Line: 959
    -- upvalues: u4 (ref)
    return u4[p31] and (u4[p31].Param1 or "") or "";
end;

function u1.GetButtonParam2(p32) -- Line: 971
    -- upvalues: u4 (ref)
    return u4[p32] and (u4[p32].Param2 or "") or "";
end;

function u1.GetButtonParams(p33) -- Line: 983
    -- upvalues: u4 (ref)
    return u4[p33] and {
        Param1 = u4[p33].Param1 or "",
        Param2 = u4[p33].Param2 or ""
    } or {
        Param1 = "",
        Param2 = ""
    };
end;

function u1.SetButtonParam1(p34, p35) -- Line: 998
    -- upvalues: u4 (ref), u6 (ref)
    if not u4[p34] then
        u4[p34] = {
            Param1 = "",
            Param2 = ""
        };
    end;

    u4[p34].Param1 = p35;

    for _, v in ipairs(u6) do
        if v.Name == p34 and v._Param1Input then
            v._Param1Input.Text = p35;

            return;
        end;
    end;
end;

function u1.SetButtonParam2(p36, p37) -- Line: 1018
    -- upvalues: u4 (ref), u6 (ref)
    if not u4[p36] then
        u4[p36] = {
            Param1 = "",
            Param2 = ""
        };
    end;

    u4[p36].Param2 = p37;

    for _, v in ipairs(u6) do
        if v.Name == p36 and v._Param2Input then
            v._Param2Input.Text = p37;

            return;
        end;
    end;
end;

function u1.SetButtonText(p38, p39) -- Line: 1041
    -- upvalues: u6 (ref)
    for _, v in ipairs(u6) do
        if v.Name == p38 and v._Button then
            v._Button.Text = p39;

            return;
        end;
    end;
end;

function u1.AddButton(p40, p41, p42) -- Line: 1057
    -- upvalues: u6 (ref), u4 (ref), u2 (ref), u7 (ref), _createDynamicButton (copy)
    local Name = p40.Name;
    local Param1Name = p40.Param1Name;
    local Param2Name = p40.Param2Name;

    for _, v in ipairs(u6) do
        if v.Name == Name then
            return;
        end;
    end;

    local v43 = {
        Name = Name,
        Param1Name = Param1Name,
        Param2Name = Param2Name,
        Callback = p41,
        Color = p42
    };
    table.insert(u6, v43);
    u4[Name] = {};

    if Param1Name and Param1Name ~= "" then
        u4[Name].Param1 = "";
    end;

    if Param2Name and Param2Name ~= "" then
        u4[Name].Param2 = "";
    end;

    if u2.ButtonWindowScrollFrame and u7 then
        u7[Name] = _createDynamicButton(v43, #u6, u2.ButtonWindowScrollFrame);
    end;
end;

function u1.RemoveButton(p44) -- Line: 1099
    -- upvalues: u6 (ref), u4 (ref), u7 (ref), u2 (ref)
    for i, v in ipairs(u6) do
        if v.Name == p44 then
            table.remove(u6, i);
            break;
        end;
    end;

    u4[p44] = nil;

    if u7[p44] then
        local v45 = u7[p44];

        if v45.Parent then
            v45:Destroy();
        end;

        u7[p44] = nil;

        if u2.ButtonWindowScrollFrame then
            for i, v in ipairs(u6) do
                local v46 = u7[v.Name];

                if v46 and v46.Parent then
                    v46.LayoutOrder = i;
                end;
            end;
        end;
    end;
end;

function u1.ClearButtons() -- Line: 1134
    -- upvalues: u7 (ref), u6 (ref), u4 (ref)
    if u7 then
        for _, v in pairs(u7) do
            if v.Parent then
                v:Destroy();
            end;
        end;

        u7 = {};
    end;

    u6 = {};
    u4 = {};
end;

function u1.destroy() -- Line: 1155
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref)
    if u2.ScreenGui then
        u2.ScreenGui:Destroy();
    end;

    u2 = {
        ScreenGui = nil,
        MainFrame = nil,
        ToggleButton = nil,
        IDInput = nil,
        AmountInput = nil,
        AddButton = nil,
        ReduceButton = nil,
        ClearButton = nil,
        SkillSlot1Input = nil,
        SkillSlot2Input = nil,
        SkillSlot3Input = nil,
        EquipSkillButton = nil,
        UnequipSkillButton = nil,
        ButtonWindowScrollFrame = nil
    };
    u3 = {
        ID = "",
        Amount = "",
        SkillSlot1 = "",
        SkillSlot2 = "",
        SkillSlot3 = ""
    };
    u4 = {};
    u5 = {
        OnAddClick = nil,
        OnReduceClick = nil,
        OnClearClick = nil,
        OnEquipSkillClick = nil,
        OnUnequipSkillClick = nil
    };
    u6 = {};
    table.clear(u7);
    u8 = false;
end;

task.spawn(function() -- Line: 1190
    -- upvalues: u1 (copy)
    u1.CreateUI();
    u1.Hide();
end);

return u1;