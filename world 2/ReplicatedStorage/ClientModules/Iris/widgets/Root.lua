-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    local u3 = 0;
    u1.WidgetConstructor("Root", {
        hasState = false,
        hasChildren = true,
        Args = {},
        Events = {},

        Generate = function(p4) -- Line: 12, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Folder = Instance.new("Folder");
            Folder.Name = "Iris_Root";
            local v5;

            if u1._config.UseScreenGUIs then
                v5 = Instance.new("ScreenGui");
                v5.ResetOnSpawn = false;
                v5.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                v5.ScreenInsets = u1._config.ScreenInsets;
                v5.IgnoreGuiInset = u1._config.IgnoreGuiInset;
                v5.DisplayOrder = u1._config.DisplayOrderOffset;
            else
                v5 = Instance.new("Frame");
                v5.AnchorPoint = Vector2.new(0.5, 0.5);
                v5.Position = UDim2.fromScale(0.5, 0.5);
                v5.Size = UDim2.fromScale(1, 1);
                v5.BackgroundTransparency = 1;
                v5.ZIndex = u1._config.DisplayOrderOffset;
            end;

            v5.Name = "PseudoWindowScreenGui";
            v5.Parent = Folder;
            local v6;

            if u1._config.UseScreenGUIs then
                v6 = Instance.new("ScreenGui");
                v6.ResetOnSpawn = false;
                v6.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                v6.DisplayOrder = u1._config.DisplayOrderOffset + 1024;
                v6.ScreenInsets = u1._config.ScreenInsets;
                v6.IgnoreGuiInset = u1._config.IgnoreGuiInset;
            else
                v6 = Instance.new("Frame");
                v6.AnchorPoint = Vector2.new(0.5, 0.5);
                v6.Position = UDim2.fromScale(0.5, 0.5);
                v6.Size = UDim2.fromScale(1, 1);
                v6.BackgroundTransparency = 1;
                v6.ZIndex = u1._config.DisplayOrderOffset + 1024;
            end;

            v6.Name = "PopupScreenGui";
            v6.Parent = Folder;
            local Frame = Instance.new("Frame");
            Frame.Name = "TooltipContainer";
            Frame.AutomaticSize = Enum.AutomaticSize.XY;
            Frame.Size = UDim2.fromOffset(0, 0);
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            u2.UIListLayout(Frame, Enum.FillDirection.Vertical, UDim.new(0, u1._config.PopupBorderSize));
            Frame.Parent = v6;
            local Frame2 = Instance.new("Frame");
            Frame2.Name = "MenuBarContainer";
            Frame2.AutomaticSize = Enum.AutomaticSize.Y;
            Frame2.Size = UDim2.fromScale(1, 0);
            Frame2.BackgroundTransparency = 1;
            Frame2.BorderSizePixel = 0;
            Frame2.Parent = v6;
            local Frame3 = Instance.new("Frame");
            Frame3.Name = "PseudoWindow";
            Frame3.AutomaticSize = Enum.AutomaticSize.XY;
            Frame3.Size = UDim2.new(0, 0, 0, 0);
            Frame3.Position = UDim2.fromOffset(0, 22);
            Frame3.BackgroundTransparency = u1._config.WindowBgTransparency;
            Frame3.BackgroundColor3 = u1._config.WindowBgColor;
            Frame3.BorderSizePixel = u1._config.WindowBorderSize;
            Frame3.BorderColor3 = u1._config.BorderColor;
            Frame3.Selectable = false;
            Frame3.SelectionGroup = true;
            Frame3.SelectionBehaviorUp = Enum.SelectionBehavior.Stop;
            Frame3.SelectionBehaviorDown = Enum.SelectionBehavior.Stop;
            Frame3.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop;
            Frame3.SelectionBehaviorRight = Enum.SelectionBehavior.Stop;
            Frame3.Visible = false;
            u2.UIPadding(Frame3, u1._config.WindowPadding);
            u2.UIListLayout(Frame3, Enum.FillDirection.Vertical, UDim.new(0, u1._config.ItemSpacing.Y));
            Frame3.Parent = v5;

            return Folder;
        end,

        Update = function(p7) -- Line: 100, Name: Update
            -- upvalues: u3 (ref)
            if u3 > 0 then
                p7.Instance.PseudoWindowScreenGui.PseudoWindow.Visible = true;
            end;
        end,

        Discard = function(p8) -- Line: 108, Name: Discard
            -- upvalues: u3 (ref)
            u3 = 0;
            p8.Instance:Destroy();
        end,

        ChildAdded = function(p9, p10) -- Line: 112, Name: ChildAdded
            -- upvalues: u3 (ref)
            local Instance2 = p9.Instance;

            if p10.type == "Window" then
                return p9.Instance;
            end;

            if p10.type == "Tooltip" then
                return Instance2.PopupScreenGui.TooltipContainer;
            end;

            if p10.type == "MenuBar" then
                return Instance2.PopupScreenGui.MenuBarContainer;
            end;

            local PseudoWindow = Instance2.PseudoWindowScreenGui.PseudoWindow;
            u3 = u3 + 1;
            PseudoWindow.Visible = true;

            return PseudoWindow;
        end,

        ChildDiscarded = function(p11, p12) -- Line: 131, Name: ChildDiscarded
            -- upvalues: u3 (ref)
            if p12.type ~= "Window" and (p12.type ~= "Tooltip" and p12.type ~= "MenuBar") then
                u3 = u3 - 1;

                if u3 == 0 then
                    p11.Instance.PseudoWindowScreenGui.PseudoWindow.Visible = false;
                end;
            end;
        end
    });
end;