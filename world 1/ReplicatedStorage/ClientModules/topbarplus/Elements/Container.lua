-- Decompiled with Potassium's decompiler.

local u1 = false;
local u2 = 0;

return function(u3) -- Line: 15
    -- upvalues: u1 (ref), u2 (ref)
    local GuiService = game:GetService("GuiService");
    local Players = game:GetService("Players");
    local UserInputService = game:GetService("UserInputService");
    local v4 = {};
    local u5 = require(script.Parent.Parent.Packages.GoodSignal).new();
    local u6 = GuiService:GetGuiInset();
    local u7 = 0;
    local u8 = 0;
    local u9 = 0;
    local u10 = 0;
    local u11 = false;
    local u12 = false;

    local function checkInset(p13) -- Line: 32
        -- upvalues: GuiService (copy), u11 (ref), u12 (ref), UserInputService (copy), u3 (copy), u10 (ref), checkInset (copy), Players (copy), u1 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u5 (copy), u2 (ref)
        local Height = GuiService.TopbarInset.Height;
        local v14 = Height <= 36;
        u11 = GuiService:IsTenFootInterface();
        u12 = UserInputService.VREnabled;
        u3.isOldTopbar = v14;
        u10 = u10 + 1;

        if Height == 0 and p13 == nil then
            task.defer(function() -- Line: 45
                -- upvalues: checkInset (ref)
                task.wait(8);
                checkInset("ForceConvertToOld");
            end);
        elseif u10 == 1 then
            task.delay(5, function() -- Line: 50
                -- upvalues: Players (ref), u10 (ref), checkInset (ref)
                Players.LocalPlayer:WaitForChild("PlayerGui");

                if u10 == 1 then
                    checkInset();
                end;
            end);
        end;

        if u3.isOldTopbar and (not u11 and (not u12 and (u1 == false and (Height ~= 0 or p13 == "ForceConvertToOld")))) then
            u1 = true;
            task.defer(function() -- Line: 62
                -- upvalues: u3 (ref), GuiService (ref)
                local Classic = require(script.Parent.Parent.Features.Themes.Classic);
                u3.modifyBaseTheme(Classic);

                local function decideToHideTopbar() -- Line: 69
                    -- upvalues: GuiService (ref), u3 (ref)
                    if GuiService.MenuIsOpen then
                        u3.setTopbarEnabled(false, true);

                        return;
                    end;

                    u3.setTopbarEnabled();
                end;

                GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(decideToHideTopbar);

                if GuiService.MenuIsOpen then
                    u3.setTopbarEnabled(false, true);

                    return;
                end;

                u3.setTopbarEnabled();
            end);
        end;

        u6 = GuiService:GetGuiInset();
        u7 = v14 and 12 or u6.Y - 50;
        u8 = v14 and 2 or 0;
        u9 = -2;

        if u11 then
            u7 = 10;
            u8 = 0;
        end;

        if GuiService.TopbarInset.Height == 0 and not u1 then
            u8 = u8 + 13;
            u9 = 50;
        end;

        u5:Fire(u6);
        local Y = u6.Y;

        if Y ~= u2 then
            u2 = Y;
            task.defer(function() -- Line: 100
                -- upvalues: u3 (ref), Y (copy)
                u3.insetHeightChanged:Fire(Y);
            end);
        end;
    end;

    GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(checkInset);
    checkInset("FirstTime");
    local ScreenGui = Instance.new("ScreenGui");
    u5:Connect(function() -- Line: 110
        -- upvalues: ScreenGui (copy), u7 (ref)
        ScreenGui:SetAttribute("StartInset", u7);
    end);
    ScreenGui.Name = "TopbarStandard";
    ScreenGui.Enabled = true;
    ScreenGui.DisplayOrder = u3.baseDisplayOrder;
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets;
    v4[ScreenGui.Name] = ScreenGui;
    u3.baseDisplayOrderChanged:Connect(function() -- Line: 121
        -- upvalues: ScreenGui (copy), u3 (copy)
        ScreenGui.DisplayOrder = u3.baseDisplayOrder;
    end);
    local Frame = Instance.new("Frame");
    Frame.Name = "Holders";
    Frame.BackgroundTransparency = 1;
    u5:Connect(function() -- Line: 128
        -- upvalues: u12 (ref), u11 (ref), u9 (ref), Frame (copy), u8 (ref)
        local v15 = u12 and 36 or 56;
        local v16;

        if u11 then
            v16 = UDim2.new(1, 0, 0, v15);
        else
            v16 = UDim2.new(1, 0, 1, u9);
        end;

        Frame.Position = UDim2.new(0, 0, 0, u8);
        Frame.Size = v16;
    end);
    Frame.Visible = true;
    Frame.ZIndex = 1;
    Frame.Parent = ScreenGui;
    local u17 = ScreenGui:Clone();
    local Holders = u17.Holders;

    local function updateCenteredHoldersHeight() -- Line: 140
        -- upvalues: Holders (copy), GuiService (copy), u9 (ref)
        Holders.Size = UDim2.new(1, 0, 0, GuiService.TopbarInset.Height + u9);
    end;

    u17.Name = "TopbarCentered";
    u17.DisplayOrder = u3.baseDisplayOrder;
    u17.ScreenInsets = Enum.ScreenInsets.None;
    u3.baseDisplayOrderChanged:Connect(function() -- Line: 146
        -- upvalues: u17 (copy), u3 (copy)
        u17.DisplayOrder = u3.baseDisplayOrder;
    end);
    v4[u17.Name] = u17;
    u5:Connect(updateCenteredHoldersHeight);
    Holders.Size = UDim2.new(1, 0, 0, GuiService.TopbarInset.Height + u9);
    local u18 = ScreenGui:Clone();
    u18.Name = u18.Name .. "Clipped";
    u18.DisplayOrder = u3.baseDisplayOrder + 1;
    u3.baseDisplayOrderChanged:Connect(function() -- Line: 157
        -- upvalues: u18 (copy), u3 (copy)
        u18.DisplayOrder = u3.baseDisplayOrder + 1;
    end);
    v4[u18.Name] = u18;
    local u19 = u17:Clone();
    u19.Name = u19.Name .. "Clipped";
    u19.DisplayOrder = u3.baseDisplayOrder + 1;
    u3.baseDisplayOrderChanged:Connect(function() -- Line: 165
        -- upvalues: u19 (copy), u3 (copy)
        u19.DisplayOrder = u3.baseDisplayOrder + 1;
    end);
    v4[u19.Name] = u19;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame:SetAttribute("IsAHolder", true);
    ScrollingFrame.Name = "Left";
    u5:Connect(function() -- Line: 174
        -- upvalues: ScrollingFrame (copy), u7 (ref)
        ScrollingFrame.Position = UDim2.fromOffset(u7, 0);
    end);
    ScrollingFrame.Size = UDim2.new(1, -24, 1, 0);
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.Visible = true;
    ScrollingFrame.ZIndex = 1;
    ScrollingFrame.Active = false;
    ScrollingFrame.ClipsDescendants = true;
    ScrollingFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.None;
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 1, -1);
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X;
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X;
    ScrollingFrame.ScrollBarThickness = 0;
    ScrollingFrame.BorderSizePixel = 0;
    ScrollingFrame.Selectable = false;
    ScrollingFrame.ScrollingEnabled = false;
    ScrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Never;
    ScrollingFrame.Parent = Frame;
    local UIListLayout = Instance.new("UIListLayout");
    u5:Connect(function() -- Line: 195
        -- upvalues: UIListLayout (copy), u7 (ref)
        UIListLayout.Padding = UDim.new(0, u7);
    end);
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left;
    UIListLayout.Parent = ScrollingFrame;
    local u20 = ScrollingFrame:Clone();
    u5:Connect(function() -- Line: 205
        -- upvalues: u20 (copy), u7 (ref)
        u20.UIListLayout.Padding = UDim.new(0, u7);
    end);
    u20.ScrollingEnabled = false;
    u20.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    u20.Name = "Center";
    u20.Parent = Holders;
    local u21 = ScrollingFrame:Clone();
    u5:Connect(function() -- Line: 214
        -- upvalues: u21 (copy), u7 (ref)
        u21.UIListLayout.Padding = UDim.new(0, u7);
    end);
    u21.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    u21.Name = "Right";
    u21.AnchorPoint = Vector2.new(1, 0);
    u21.Position = UDim2.new(1, -12, 0, 0);
    u21.Parent = Frame;

    local function healthBarIsShowing() -- Line: 228
        -- upvalues: u3 (copy), u11 (ref), u12 (ref), Players (copy)
        if u3.isOldTopbar or (u11 or u12) then
            return false;
        end;

        local Character = Players.LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        local v22;

        if Character == nil then
            v22 = false;
        else
            v22 = Character.Health < Character.MaxHealth;
        end;

        return v22;
    end;

    local function updateRightPosition() -- Line: 238
        -- upvalues: u3 (copy), u11 (ref), u12 (ref), Players (copy), u21 (copy)
        local v23;

        if u3.isOldTopbar or (u11 or u12) then
            v23 = false;
        else
            local Character = Players.LocalPlayer.Character;

            if Character then
                Character = Character:FindFirstChildOfClass("Humanoid");
            end;

            if Character == nil then
                v23 = false;
            else
                v23 = Character.Health < Character.MaxHealth;
            end;
        end;

        u21.Position = UDim2.new(1, -((v23 and 150 or 0) + 12), 0, 0);
    end;

    local function watchHumanoid(p24) -- Line: 243
        -- upvalues: updateRightPosition (copy), u3 (copy), u11 (ref), u12 (ref), Players (copy), u21 (copy)
        local Humanoid = p24:WaitForChild("Humanoid", 10);

        if not (Humanoid and Humanoid:IsA("Humanoid")) then
            return;
        end;

        Humanoid.HealthChanged:Connect(updateRightPosition);
        Humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(updateRightPosition);
        local v25;

        if u3.isOldTopbar or (u11 or u12) then
            v25 = false;
        else
            local Character = Players.LocalPlayer.Character;

            if Character then
                Character = Character:FindFirstChildOfClass("Humanoid");
            end;

            if Character == nil then
                v25 = false;
            else
                v25 = Character.Health < Character.MaxHealth;
            end;
        end;

        u21.Position = UDim2.new(1, -((v25 and 150 or 0) + 12), 0, 0);
    end;

    u5:Connect(updateRightPosition);
    Players.LocalPlayer.CharacterAdded:Connect(watchHumanoid);

    if Players.LocalPlayer.Character then
        task.spawn(watchHumanoid, Players.LocalPlayer.Character);
    end;

    u5:Fire(u6);

    return v4;
end;