-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local TweenService = game:GetService("TweenService");
local PlayerGui = game.Players.LocalPlayer.PlayerGui;
local u1 = {
    UI = {
        ScreenGui = nil,
        MainFrame = nil,
        IDInput = nil,
        AmountInput = nil,
        AddButton = nil,
        ReduceButton = nil,
        ClearButton = nil,
        ButtonWindowScrollFrame = nil,
        RacePickTemp = nil,
        RacePickGrid = nil
    },
    InputValues = {
        ID = "",
        Amount = ""
    },
    ButtonParams = {},
    Events = {
        OnAddClick = nil,
        OnReduceClick = nil,
        OnClearClick = nil
    },
    DynamicButtons = {}
};
local u2 = {};
local u3 = {};
local u4 = nil;
local u5 = Color3.fromRGB(72, 118, 175);
local u6 = Color3.fromRGB(92, 142, 205);

local function clearRacePickClones() -- Line: 68
    -- upvalues: u1 (copy)
    local RacePickGrid = u1.UI.RacePickGrid;

    if not RacePickGrid then
        return;
    end;

    for _, child in ipairs(RacePickGrid:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy();
        end;
    end;
end;

function u1.RebuildRacePickButtons() -- Line: 83
    -- upvalues: clearRacePickClones (copy), u1 (copy), u4 (ref), u3 (ref), u5 (copy), TweenService (copy), u6 (copy)
    clearRacePickClones();
    local RacePickGrid = u1.UI.RacePickGrid;
    local RacePickTemp = u1.UI.RacePickTemp;

    if not RacePickGrid or (not RacePickTemp or (not u4 or #u3 == 0)) then
        return;
    end;

    for i, v in ipairs(u3) do
        local u7 = RacePickTemp:Clone();
        u7.Visible = true;
        u7.Name = "Race_" .. tostring(v.id);
        u7.LayoutOrder = i;
        u7.Text = v.Zh;
        u7.AutoButtonColor = false;
        u7.BackgroundColor3 = u5;
        u7.Parent = RacePickGrid;
        local id = v.id;
        u7.MouseEnter:Connect(function() -- Line: 100
            -- upvalues: TweenService (ref), u7 (copy), u6 (ref)
            TweenService:Create(u7, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = u6
            }):Play();
        end);
        u7.MouseLeave:Connect(function() -- Line: 107
            -- upvalues: TweenService (ref), u7 (copy), u5 (ref)
            TweenService:Create(u7, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = u5
            }):Play();
        end);
        u7.MouseButton1Click:Connect(function() -- Line: 114
            -- upvalues: u4 (ref), id (copy)
            u4(id);
        end);
    end;
end;

function u1.SetRacePickList(p8, p9) -- Line: 123
    -- upvalues: u3 (ref), u4 (ref), u1 (copy)
    u3 = p8 or {};
    u4 = p9;

    if u1.UI.RacePickGrid and u1.UI.RacePickTemp then
        u1.RebuildRacePickButtons();
    end;
end;

local function createInputGroup(p10, u11, p12) -- Line: 138
    -- upvalues: u1 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = u11 .. "Group";
    Frame.Size = UDim2.new(1, 0, 0, 50);
    Frame.Position = UDim2.new(0, 0, 0, p12);
    Frame.BackgroundTransparency = 1;
    Frame.Parent = p10;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Label";
    TextLabel.Size = UDim2.new(0, 90, 0, 30);
    TextLabel.Position = UDim2.new(0, 0, 0, 10);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = u11 .. ":";
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
    TextBox.PlaceholderText = "请输入" .. u11;
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 140);
    TextBox.TextSize = 20;
    TextBox.Font = Enum.Font.Gotham;
    TextBox.TextXAlignment = Enum.TextXAlignment.Center;
    TextBox.ClearTextOnFocus = false;
    TextBox.Parent = Frame2;
    TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 190
        -- upvalues: u11 (copy), u1 (ref), TextBox (copy)
        if u11 == "ID" then
            u1.InputValues.ID = TextBox.Text;

            return;
        end;

        if u11 == "物品数量" then
            u1.InputValues.Amount = TextBox.Text;
        end;
    end);

    return TextBox;
end;

local function _createButton(p13, p14, u15, p16, p17) -- Line: 211
    local TextButton = Instance.new("TextButton");
    TextButton.Name = p14 .. "Button";
    TextButton.Size = UDim2.new(0, 100, 0, 40);
    TextButton.Position = UDim2.new(0, p16, 0, p17);
    TextButton.BackgroundColor3 = u15;
    TextButton.BorderSizePixel = 0;
    TextButton.Text = p14;
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextButton.TextSize = 14;
    TextButton.Font = Enum.Font.GothamBold;
    TextButton.Parent = p13;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, 6);
    UICorner.Parent = TextButton;
    TextButton.MouseEnter:Connect(function() -- Line: 229
        -- upvalues: TextButton (copy), u15 (copy)
        game:GetService("TweenService"):Create(TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = u15:Lerp(Color3.fromRGB(255, 255, 255), 0.2)
        }):Play();
    end);
    TextButton.MouseLeave:Connect(function() -- Line: 238
        -- upvalues: TextButton (copy), u15 (copy)
        game:GetService("TweenService"):Create(TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = u15
        }):Play();
    end);

    return TextButton;
end;

local u18 = false;

local function createDynamicButton(u19, p20, p21) -- Line: 257
    -- upvalues: u1 (copy), createInputGroup (copy)
    local ParamNames = u19.ParamNames;

    if not ParamNames then
        ParamNames = {};

        if u19.Param1Name and u19.Param1Name ~= "" then
            table.insert(ParamNames, u19.Param1Name);
        end;

        if u19.Param2Name and u19.Param2Name ~= "" then
            table.insert(ParamNames, u19.Param2Name);
        end;

        u19.ParamNames = ParamNames;
    end;

    local u22 = #ParamNames;
    local v23 = u22 <= 0 and 0 or math.ceil(u22 / 2);
    local Frame = Instance.new("Frame");
    Frame.Name = u19.Name .. "Container";
    Frame.Size = UDim2.new(1, 0, 0, v23 * 50 + 24 + 42 + 24);
    Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 50);
    Frame.BorderSizePixel = 0;
    Frame.LayoutOrder = p20;
    Frame.Parent = p21;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, 8);
    UICorner.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "ContentFrame";
    Frame2.Size = UDim2.new(1, -16, 1, -24);
    Frame2.Position = UDim2.new(0, 8, 0, 12);
    Frame2.BackgroundTransparency = 1;
    Frame2.Parent = Frame;

    if u1.ButtonParams[u19.Name] then
        u1.ButtonParams[u19.Name]._maxIndex = u22;
    else
        u1.ButtonParams[u19.Name] = {
            _maxIndex = u22
        };
    end;

    local v24 = u1.ButtonParams[u19.Name];
    local v25 = {};
    local v26 = u22 >= 2;
    local v27, v28;

    if v26 then
        v27 = Instance.new("Frame");
        v27.Name = "LeftColumn";
        v27.BackgroundTransparency = 1;
        v27.Size = UDim2.new(0.5, -6, 1, 0);
        v27.Position = UDim2.new(0, 0, 0, 0);
        v27.Parent = Frame2;
        v28 = Instance.new("Frame");
        v28.Name = "RightColumn";
        v28.BackgroundTransparency = 1;
        v28.Size = UDim2.new(0.5, -6, 1, 0);
        v28.Position = UDim2.new(0.5, 6, 0, 0);
        v28.Parent = Frame2;
    else
        v28 = nil;
        v27 = nil;
    end;

    for i, v in ipairs(ParamNames) do
        local v29, v30;

        if v26 then
            v29 = math.floor((i - 1) / 2) * 50;

            if (i - 1) % 2 + 1 == 1 then
                v30 = v27;
            else
                v30 = v28;
            end;
        else
            v30 = Frame2;
            v29 = 0;
        end;

        local u31 = createInputGroup(v30, v, v29);
        v25[i] = u31;
        local v32 = v24[i];

        if (not v32 or v32 == "") and v ~= nil then
            v32 = v24[v];
        end;

        local v33 = v32 == nil and "" or v32;
        v24[i] = v33;

        if v ~= nil then
            v24[v] = v33;
        end;

        if i == 1 and v24.Param1 == nil then
            v24.Param1 = v33;
        end;

        if i == 2 and v24.Param2 == nil then
            v24.Param2 = v33;
        end;

        if v33 ~= "" then
            u31.Text = tostring(v33);
        end;

        u31:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 393
            -- upvalues: u1 (ref), u19 (copy), u22 (copy), i (copy), u31 (copy), v (copy)
            local v34 = u1.ButtonParams[u19.Name];

            if not v34 then
                v34 = {
                    _maxIndex = u22
                };
                u1.ButtonParams[u19.Name] = v34;
            end;

            v34[i] = u31.Text;
            v34[v] = u31.Text;

            if i == 1 then
                v34.Param1 = u31.Text;

                return;
            end;

            if i == 2 then
                v34.Param2 = u31.Text;
            end;
        end);
    end;

    local TextButton = Instance.new("TextButton");
    TextButton.Name = u19.Name .. "Button";
    TextButton.Size = UDim2.new(1, 0, 0, 42);
    TextButton.Position = UDim2.new(0, 0, 0, v23 * 50);
    TextButton.BorderSizePixel = 0;
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextButton.TextSize = 22;
    TextButton.Font = Enum.Font.GothamBold;
    TextButton.BackgroundColor3 = u19.Color or Color3.fromRGB(70, 130, 180);
    TextButton.Text = u19.Name;
    TextButton.Parent = Frame2;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(0, 6);
    UICorner2.Parent = TextButton;
    local u35 = u19.Color or Color3.fromRGB(70, 130, 180);
    TextButton.MouseEnter:Connect(function() -- Line: 433
        -- upvalues: TextButton (copy), u35 (copy)
        game:GetService("TweenService"):Create(TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = u35:Lerp(Color3.fromRGB(255, 255, 255), 0.2)
        }):Play();
    end);
    TextButton.MouseLeave:Connect(function() -- Line: 442
        -- upvalues: TextButton (copy), u35 (copy)
        game:GetService("TweenService"):Create(TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = u35
        }):Play();
    end);

    if u19.Callback then
        TextButton.MouseButton1Click:Connect(function() -- Line: 453
            -- upvalues: u19 (copy)
            u19.Callback();
        end);
    end;

    u19._ParamInputs = v25;
    u19._Param1Input = v25[1];
    u19._Param2Input = v25[2];

    return Frame;
end;

local function createAllDynamicButtons() -- Line: 469
    -- upvalues: u1 (copy), u2 (ref), createDynamicButton (copy)
    local ButtonWindowScrollFrame = u1.UI.ButtonWindowScrollFrame;

    if not ButtonWindowScrollFrame then
        return;
    end;

    for i, v in ipairs(u1.DynamicButtons) do
        if not u2[v.Name] then
            local v36 = createDynamicButton(v, i + 1, ButtonWindowScrollFrame);
            u2[v.Name] = v36;
        end;
    end;
end;

function u1.CreateUI() -- Line: 486
    -- upvalues: u18 (ref), u1 (copy), u2 (ref), PlayerGui (copy), createInputGroup (copy), u5 (copy), createAllDynamicButtons (copy)
    if not (u18 and (u1.UI.ScreenGui and u1.UI.ScreenGui.Parent)) then
        if u1.UI.ScreenGui and not u1.UI.ScreenGui.Parent then
            u1.UI.ScreenGui = nil;
            u18 = false;
            u2 = {};
            u1.UI.RacePickTemp = nil;
            u1.UI.RacePickGrid = nil;
        end;

        local ScreenGui = Instance.new("ScreenGui");
        ScreenGui.Name = "DebugSystemUI";
        ScreenGui.ResetOnSpawn = false;
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
        ScreenGui.DisplayOrder = 999;
        ScreenGui.IgnoreGuiInset = false;
        ScreenGui.Parent = PlayerGui;
        u1.UI.ScreenGui = ScreenGui;
        local Frame = Instance.new("Frame");
        Frame.Name = "MainFrame";
        Frame.Size = UDim2.new(0.4, 0, 1, 0);
        Frame.AnchorPoint = Vector2.new(0, 0.5);
        Frame.Position = UDim2.new(0, 0, 0.5, 0);
        Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
        Frame.BorderSizePixel = 0;
        Frame.ZIndex = 10;
        Frame.Visible = true;
        Frame.Parent = ScreenGui;
        u1.UI.MainFrame = Frame;
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
        TextButton.MouseButton1Click:Connect(function() -- Line: 577
            -- upvalues: u1 (ref)
            u1.Hide();
        end);
        local ScrollingFrame = Instance.new("ScrollingFrame");
        ScrollingFrame.Name = "ContentScrollFrame";
        ScrollingFrame.Size = UDim2.new(1, 0, 1, -45);
        ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y;
        ScrollingFrame.Position = UDim2.new(0, 0, 0, 45);
        ScrollingFrame.BackgroundTransparency = 1;
        ScrollingFrame.BorderSizePixel = 0;
        ScrollingFrame.ScrollBarThickness = 6;
        ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100);
        ScrollingFrame.Parent = Frame;
        local Frame3 = Instance.new("Frame");
        Frame3.Name = "ContentFrame";
        Frame3.Size = UDim2.new(1, -40, 0, 1000);
        Frame3.Position = UDim2.new(0, 20, 0, 0);
        Frame3.BackgroundTransparency = 1;
        Frame3.Parent = ScrollingFrame;
        u1.UI.IDInput = createInputGroup(Frame3, "ID", 25);
        u1.UI.AmountInput = createInputGroup(Frame3, "物品数量", 95);
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
        u1.UI.AddButton = Instance.new("TextButton");
        u1.UI.AddButton.Name = "添加Button";
        u1.UI.AddButton.Size = UDim2.new(0, 95, 0, 40);
        u1.UI.AddButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50);
        u1.UI.AddButton.BorderSizePixel = 0;
        u1.UI.AddButton.Text = "添加";
        u1.UI.AddButton.TextColor3 = Color3.fromRGB(255, 255, 255);
        u1.UI.AddButton.TextSize = 22;
        u1.UI.AddButton.Font = Enum.Font.GothamBold;
        u1.UI.AddButton.LayoutOrder = 1;
        u1.UI.AddButton.Parent = Frame4;
        local UICorner4 = Instance.new("UICorner");
        UICorner4.CornerRadius = UDim.new(0, 6);
        UICorner4.Parent = u1.UI.AddButton;
        u1.UI.AddButton.MouseEnter:Connect(function() -- Line: 647
            -- upvalues: u1 (ref)
            game:GetService("TweenService"):Create(u1.UI.AddButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(50, 150, 50):Lerp(Color3.fromRGB(255, 255, 255), 0.2)
            }):Play();
        end);
        u1.UI.AddButton.MouseLeave:Connect(function() -- Line: 656
            -- upvalues: u1 (ref)
            game:GetService("TweenService"):Create(u1.UI.AddButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            }):Play();
        end);
        u1.UI.AddButton.MouseButton1Click:Connect(function() -- Line: 665
            -- upvalues: u1 (ref)
            if u1.Events.OnAddClick then
                u1.Events.OnAddClick();
            end;
        end);
        u1.UI.ReduceButton = Instance.new("TextButton");
        u1.UI.ReduceButton.Name = "减少Button";
        u1.UI.ReduceButton.Size = UDim2.new(0, 95, 0, 40);
        u1.UI.ReduceButton.BackgroundColor3 = Color3.fromRGB(150, 100, 50);
        u1.UI.ReduceButton.BorderSizePixel = 0;
        u1.UI.ReduceButton.Text = "减少";
        u1.UI.ReduceButton.TextColor3 = Color3.fromRGB(255, 255, 255);
        u1.UI.ReduceButton.TextSize = 22;
        u1.UI.ReduceButton.Font = Enum.Font.GothamBold;
        u1.UI.ReduceButton.LayoutOrder = 2;
        u1.UI.ReduceButton.Parent = Frame4;
        local UICorner5 = Instance.new("UICorner");
        UICorner5.CornerRadius = UDim.new(0, 6);
        UICorner5.Parent = u1.UI.ReduceButton;
        u1.UI.ReduceButton.MouseEnter:Connect(function() -- Line: 689
            -- upvalues: u1 (ref)
            game:GetService("TweenService"):Create(u1.UI.ReduceButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(150, 100, 50):Lerp(Color3.fromRGB(255, 255, 255), 0.2)
            }):Play();
        end);
        u1.UI.ReduceButton.MouseLeave:Connect(function() -- Line: 698
            -- upvalues: u1 (ref)
            game:GetService("TweenService"):Create(u1.UI.ReduceButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(150, 100, 50)
            }):Play();
        end);
        u1.UI.ReduceButton.MouseButton1Click:Connect(function() -- Line: 707
            -- upvalues: u1 (ref)
            if u1.Events.OnReduceClick then
                u1.Events.OnReduceClick();
            end;
        end);
        u1.UI.ClearButton = Instance.new("TextButton");
        u1.UI.ClearButton.Name = "清空Button";
        u1.UI.ClearButton.Size = UDim2.new(0, 95, 0, 40);
        u1.UI.ClearButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50);
        u1.UI.ClearButton.BorderSizePixel = 0;
        u1.UI.ClearButton.Text = "清空";
        u1.UI.ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255);
        u1.UI.ClearButton.TextSize = 22;
        u1.UI.ClearButton.Font = Enum.Font.GothamBold;
        u1.UI.ClearButton.LayoutOrder = 3;
        u1.UI.ClearButton.Parent = Frame4;
        local UICorner6 = Instance.new("UICorner");
        UICorner6.CornerRadius = UDim.new(0, 6);
        UICorner6.Parent = u1.UI.ClearButton;
        u1.UI.ClearButton.MouseEnter:Connect(function() -- Line: 731
            -- upvalues: u1 (ref)
            game:GetService("TweenService"):Create(u1.UI.ClearButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(150, 50, 50):Lerp(Color3.fromRGB(255, 255, 255), 0.2)
            }):Play();
        end);
        u1.UI.ClearButton.MouseLeave:Connect(function() -- Line: 740
            -- upvalues: u1 (ref)
            game:GetService("TweenService"):Create(u1.UI.ClearButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(150, 50, 50)
            }):Play();
        end);
        u1.UI.ClearButton.MouseButton1Click:Connect(function() -- Line: 749
            -- upvalues: u1 (ref)
            if u1.Events.OnClearClick then
                u1.Events.OnClearClick();
            end;
        end);
        local Frame5 = Instance.new("Frame");
        Frame5.Name = "Divider";
        Frame5.Size = UDim2.new(1, 0, 0, 2);
        Frame5.Position = UDim2.new(0, 0, 0, 240);
        Frame5.BackgroundColor3 = Color3.fromRGB(100, 100, 100);
        Frame5.BorderSizePixel = 0;
        Frame5.Parent = Frame3;
        local UICorner7 = Instance.new("UICorner");
        UICorner7.CornerRadius = UDim.new(0, 1);
        UICorner7.Parent = Frame5;
        local TextLabel2 = Instance.new("TextLabel");
        TextLabel2.Name = "ButtonSectionTitle";
        TextLabel2.Size = UDim2.new(1, 0, 0, 30);
        TextLabel2.Position = UDim2.new(0, 0, 0, 250);
        TextLabel2.BackgroundTransparency = 1;
        TextLabel2.Text = "动态按钮";
        TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255);
        TextLabel2.TextSize = 24;
        TextLabel2.Font = Enum.Font.GothamBold;
        TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel2.Parent = Frame3;
        local Frame6 = Instance.new("Frame");
        Frame6.Name = "ButtonContainerFrame";
        Frame6.Size = UDim2.new(1, 0, 0, 10);
        Frame6.Position = UDim2.new(0, 0, 0, 290);
        Frame6.BackgroundTransparency = 1;
        Frame6.BorderSizePixel = 0;
        Frame6.Parent = Frame3;
        u1.UI.ButtonWindowScrollFrame = Frame6;
        local Folder = Instance.new("Folder");
        Folder.Name = "_RacePickTmpl";
        Folder.Parent = ScreenGui;
        local Frame7 = Instance.new("Frame");
        Frame7.Name = "RacePickHolder";
        Frame7.AutomaticSize = Enum.AutomaticSize.Y;
        Frame7.Size = UDim2.new(1, 0, 0, 0);
        Frame7.BackgroundColor3 = Color3.fromRGB(28, 30, 36);
        Frame7.BorderSizePixel = 0;
        Frame7.LayoutOrder = 0;
        Frame7.Parent = Frame6;
        local UICorner8 = Instance.new("UICorner");
        UICorner8.CornerRadius = UDim.new(0, 10);
        UICorner8.Parent = Frame7;
        local UIStroke = Instance.new("UIStroke");
        UIStroke.Color = Color3.fromRGB(55, 58, 68);
        UIStroke.Thickness = 1;
        UIStroke.Transparency = 0.35;
        UIStroke.Parent = Frame7;
        local UIPadding = Instance.new("UIPadding");
        UIPadding.PaddingTop = UDim.new(0, 14);
        UIPadding.PaddingBottom = UDim.new(0, 16);
        UIPadding.PaddingLeft = UDim.new(0, 14);
        UIPadding.PaddingRight = UDim.new(0, 14);
        UIPadding.Parent = Frame7;
        local UIListLayout2 = Instance.new("UIListLayout");
        UIListLayout2.FillDirection = Enum.FillDirection.Vertical;
        UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout2.Padding = UDim.new(0, 12);
        UIListLayout2.Parent = Frame7;
        local TextLabel3 = Instance.new("TextLabel");
        TextLabel3.Name = "RacePickTitle";
        TextLabel3.BackgroundTransparency = 1;
        TextLabel3.Size = UDim2.new(1, 0, 0, 26);
        TextLabel3.Font = Enum.Font.GothamBold;
        TextLabel3.TextSize = 22;
        TextLabel3.TextColor3 = Color3.fromRGB(255, 255, 255);
        TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel3.Text = "切换种族";
        TextLabel3.LayoutOrder = 1;
        TextLabel3.Parent = Frame7;
        local Frame8 = Instance.new("Frame");
        Frame8.Name = "RacePickGrid";
        Frame8.AutomaticSize = Enum.AutomaticSize.Y;
        Frame8.Size = UDim2.new(1, 0, 0, 0);
        Frame8.BackgroundTransparency = 1;
        Frame8.BorderSizePixel = 0;
        Frame8.LayoutOrder = 2;
        Frame8.Parent = Frame7;
        local UIGridLayout = Instance.new("UIGridLayout");
        UIGridLayout.CellSize = UDim2.new(0, 224, 0, 72);
        UIGridLayout.CellPadding = UDim2.fromOffset(8, 8);
        UIGridLayout.FillDirection = Enum.FillDirection.Horizontal;
        UIGridLayout.FillDirectionMaxCells = 5;
        UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left;
        UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
        UIGridLayout.Parent = Frame8;
        u1.UI.RacePickGrid = Frame8;
        local TextButton2 = Instance.new("TextButton");
        TextButton2.Name = "Temp";
        TextButton2.Size = UDim2.new(0, 224, 0, 72);
        TextButton2.Visible = false;
        TextButton2.Text = "";
        TextButton2.TextSize = 45;
        TextButton2.Font = Enum.Font.GothamBold;
        TextButton2.BackgroundColor3 = u5;
        TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255);
        TextButton2.BorderSizePixel = 0;
        TextButton2.AutoButtonColor = false;
        local UICorner9 = Instance.new("UICorner");
        UICorner9.CornerRadius = UDim.new(0, 8);
        UICorner9.Parent = TextButton2;
        TextButton2.Parent = Folder;
        u1.UI.RacePickTemp = TextButton2;
        local UIListLayout3 = Instance.new("UIListLayout");
        UIListLayout3.FillDirection = Enum.FillDirection.Vertical;
        UIListLayout3.HorizontalAlignment = Enum.HorizontalAlignment.Center;
        UIListLayout3.VerticalAlignment = Enum.VerticalAlignment.Top;
        UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout3.Padding = UDim.new(0, 12);
        UIListLayout3.Parent = Frame6;
        local u37 = false;
        UIListLayout3:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line: 887
            -- upvalues: u37 (ref), Frame6 (copy), UIListLayout3 (copy)
            if not u37 then
                u37 = true;
                task.defer(function() -- Line: 890
                    -- upvalues: Frame6 (ref), UIListLayout3 (ref), u37 (ref)
                    if Frame6 and UIListLayout3 then
                        Frame6.Size = UDim2.new(1, 0, 0, UIListLayout3.AbsoluteContentSize.Y + 20);
                    end;

                    u37 = false;
                end);
            end;
        end);
        local UIListLayout4 = Instance.new("UIListLayout");
        UIListLayout4.FillDirection = Enum.FillDirection.Vertical;
        UIListLayout4.HorizontalAlignment = Enum.HorizontalAlignment.Center;
        UIListLayout4.VerticalAlignment = Enum.VerticalAlignment.Top;
        UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout4.Padding = UDim.new(0, 0);
        UIListLayout4.Parent = Frame3;
        local u38 = false;
        UIListLayout4:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line: 910
            -- upvalues: u38 (ref), Frame3 (copy), UIListLayout4 (copy), ScrollingFrame (copy)
            if not u38 then
                u38 = true;
                task.defer(function() -- Line: 913
                    -- upvalues: Frame3 (ref), UIListLayout4 (ref), ScrollingFrame (ref), u38 (ref)
                    if Frame3 and (UIListLayout4 and ScrollingFrame) then
                        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout4.AbsoluteContentSize.Y + 20);
                    end;

                    u38 = false;
                end);
            end;
        end);
        createAllDynamicButtons();
        u1.RebuildRacePickButtons();
        u18 = true;

        return ScreenGui;
    end;
end;

function u1.GetID() -- Line: 939
    -- upvalues: u1 (copy)
    return u1.InputValues.ID;
end;

function u1.GetAmount() -- Line: 947
    -- upvalues: u1 (copy)
    return u1.InputValues.Amount;
end;

function u1.SetID(p39) -- Line: 955
    -- upvalues: u1 (copy)
    u1.InputValues.ID = p39;

    if u1.UI.IDInput then
        u1.UI.IDInput.Text = p39;
    end;
end;

function u1.SetAmount(p40) -- Line: 966
    -- upvalues: u1 (copy)
    u1.InputValues.Amount = p40;

    if u1.UI.AmountInput then
        u1.UI.AmountInput.Text = p40;
    end;
end;

function u1.OnAddClick(p41) -- Line: 977
    -- upvalues: u1 (copy)
    u1.Events.OnAddClick = p41;
end;

function u1.OnReduceClick(p42) -- Line: 985
    -- upvalues: u1 (copy)
    u1.Events.OnReduceClick = p42;
end;

function u1.OnClearClick(p43) -- Line: 993
    -- upvalues: u1 (copy)
    u1.Events.OnClearClick = p43;
end;

function u1.GetButtonParam1(p44) -- Line: 1002
    -- upvalues: u1 (copy)
    local v45 = u1.ButtonParams[p44];

    return v45 and (v45[1] or v45.Param1 or "") or "";
end;

function u1.GetButtonParam2(p46) -- Line: 1015
    -- upvalues: u1 (copy)
    local v47 = u1.ButtonParams[p46];

    return v47 and (v47[2] or v47.Param2 or "") or "";
end;

function u1.GetButtonParams(p48) -- Line: 1028
    -- upvalues: u1 (copy)
    local v49 = u1.ButtonParams[p48];

    return v49 and {
        Param1 = v49[1] or (v49.Param1 or ""),
        Param2 = v49[2] or (v49.Param2 or "")
    } or {
        Param1 = "",
        Param2 = ""
    };
end;

function u1.GetButtonParam(p50, p51) -- Line: 1046
    -- upvalues: u1 (copy)
    local v52 = u1.ButtonParams[p50];

    return v52 and (typeof(p51) == "number" and (v52[p51] or "") or (v52[p51] or "")) or "";
end;

function u1.GetButtonParamList(p53) -- Line: 1064
    -- upvalues: u1 (copy)
    local v54 = u1.ButtonParams[p53];

    if not v54 then
        return {};
    end;

    local v55 = {};

    for i = 1, v54._maxIndex or 0 do
        table.insert(v55, v54[i] or "");
    end;

    return v55;
end;

function u1.SetButtonParam1(p56, p57) -- Line: 1083
    -- upvalues: u1 (copy)
    if not u1.ButtonParams[p56] then
        u1.ButtonParams[p56] = {
            _maxIndex = 1
        };
    end;

    local v58 = u1.ButtonParams[p56];
    v58[1] = p57;
    v58.Param1 = p57;

    for _, v in ipairs(u1.DynamicButtons) do
        if v.Name == p56 then
            local v59 = nil;

            if v.ParamNames and v.ParamNames[1] then
                v59 = v.ParamNames[1];
            elseif v.Param1Name then
                v59 = v.Param1Name;
            end;

            if v59 then
                v58[v59] = p57;
            end;

            if v._ParamInputs and v._ParamInputs[1] then
                v._ParamInputs[1].Text = p57;

                return;
            end;

            if v._Param1Input then
                v._Param1Input.Text = p57;

                return;
            end;

            break;
        end;
    end;
end;

function u1.SetButtonParam2(p60, p61) -- Line: 1122
    -- upvalues: u1 (copy)
    if not u1.ButtonParams[p60] then
        u1.ButtonParams[p60] = {
            _maxIndex = 2
        };
    end;

    local v62 = u1.ButtonParams[p60];

    if not v62._maxIndex or v62._maxIndex < 2 then
        v62._maxIndex = 2;
    end;

    v62[2] = p61;
    v62.Param2 = p61;

    for _, v in ipairs(u1.DynamicButtons) do
        if v.Name == p60 then
            local v63 = nil;

            if v.ParamNames and v.ParamNames[2] then
                v63 = v.ParamNames[2];
            elseif v.Param2Name then
                v63 = v.Param2Name;
            end;

            if v63 then
                v62[v63] = p61;
            end;

            if v._ParamInputs and v._ParamInputs[2] then
                v._ParamInputs[2].Text = p61;

                return;
            end;

            if v._Param2Input then
                v._Param2Input.Text = p61;

                return;
            end;

            break;
        end;
    end;
end;

function u1.AddButton(p64, p65, p66) -- Line: 1169
    -- upvalues: u1 (copy), u2 (ref), createDynamicButton (copy)
    local Name = p64.Name;
    local Param1Name = p64.Param1Name;
    local Param2Name = p64.Param2Name;

    for _, v in ipairs(u1.DynamicButtons) do
        if v.Name == Name then
            return;
        end;
    end;

    local v67 = {};

    if p64.ParamNames and #p64.ParamNames > 0 then
        for _, v in ipairs(p64.ParamNames) do
            if v and v ~= "" then
                table.insert(v67, v);
            end;
        end;
    else
        if Param1Name and Param1Name ~= "" then
            table.insert(v67, Param1Name);
        end;

        if Param2Name and Param2Name ~= "" then
            table.insert(v67, Param2Name);
        end;
    end;

    local v68 = {
        Name = Name,
        Param1Name = Param1Name,
        Param2Name = Param2Name,
        ParamNames = v67,
        Callback = p65,
        Color = p66
    };
    table.insert(u1.DynamicButtons, v68);
    local v69 = u1.ButtonParams[Name] or {};
    v69._maxIndex = #v67;

    for i, v in ipairs(v67) do
        if v69[i] == nil then
            v69[i] = "";
        end;

        if v and (v ~= "" and v69[v] == nil) then
            v69[v] = "";
        end;

        if i == 1 and v69.Param1 == nil then
            v69.Param1 = v69[1];
        elseif i == 2 and v69.Param2 == nil then
            v69.Param2 = v69[2];
        end;
    end;

    u1.ButtonParams[Name] = v69;

    if u1.UI.ButtonWindowScrollFrame and u2 then
        u2[Name] = createDynamicButton(v68, #u1.DynamicButtons + 1, u1.UI.ButtonWindowScrollFrame);
    end;
end;

function u1.RemoveButton(p70) -- Line: 1249
    -- upvalues: u1 (copy), u2 (ref)
    for i, v in ipairs(u1.DynamicButtons) do
        if v.Name == p70 then
            table.remove(u1.DynamicButtons, i);
            break;
        end;
    end;

    u1.ButtonParams[p70] = nil;

    if u2[p70] then
        local v71 = u2[p70];

        if v71.Parent then
            v71:Destroy();
        end;

        u2[p70] = nil;

        if u1.UI.ButtonWindowScrollFrame then
            for i, v in ipairs(u1.DynamicButtons) do
                local v72 = u2[v.Name];

                if v72 and v72.Parent then
                    v72.LayoutOrder = i;
                end;
            end;
        end;
    end;
end;

function u1.ClearButtons() -- Line: 1284
    -- upvalues: u2 (ref), clearRacePickClones (copy), u3 (ref), u4 (ref), u1 (copy)
    if u2 then
        for _, v in pairs(u2) do
            if v.Parent then
                v:Destroy();
            end;
        end;

        u2 = {};
    end;

    clearRacePickClones();
    u3 = {};
    u4 = nil;
    u1.DynamicButtons = {};
    u1.ButtonParams = {};
end;

function u1.Hide() -- Line: 1306
    -- upvalues: u1 (copy)
    if u1.UI.ScreenGui then
        u1.UI.ScreenGui.Enabled = false;
    end;
end;

task.spawn(function() -- Line: 1314
    -- upvalues: u1 (copy)
    u1.CreateUI();
    u1.Hide();
end);

return u1;