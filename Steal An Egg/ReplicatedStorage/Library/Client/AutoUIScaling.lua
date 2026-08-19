-- Decompiled with Potassium's decompiler.

return function(u1) -- Line: 1
    local v2;

    if typeof(u1) == "Instance" then
        v2 = u1:IsA("ScrollingFrame");
    else
        v2 = false;
    end;

    local v3 = `Expected ScrollingFrame, got {typeof(u1)}`;
    assert(v2, v3);
    local RunService = game:GetService("RunService");
    local v4 = workspace;
    local u5 = u1:FindFirstChildOfClass("UIListLayout") or u1:FindFirstChildOfClass("UIGridLayout");
    assert(u5, "UIListLayout or UIGridLayout not found in the provided ScrollingFrame.");
    local u6 = u1:FindFirstChildOfClass("UIPadding");

    local function ancestorEnabled(p7) -- Line: 16
        -- upvalues: ancestorEnabled (copy)
        if not p7 then
            return false;
        end;

        if p7:IsA("LayerCollector") then
            return p7.Enabled;
        end;

        if p7:IsA("GuiObject") and not p7.Visible then
            return false;
        end;

        return ancestorEnabled(p7.Parent);
    end;

    local u8 = false;
    local u9 = false;

    if u1:IsA("LayerCollector") then
        u9 = u1.Enabled;
    elseif not u1:IsA("GuiObject") or u1.Visible then
        local Parent = u1.Parent;

        if Parent then
            if Parent:IsA("LayerCollector") then
                u9 = Parent.Enabled;
            elseif Parent:IsA("GuiObject") and not Parent.Visible then
                u9 = false;
            else
                u9 = ancestorEnabled(Parent.Parent);
            end;
        else
            u9 = false;
        end;
    end;

    local function refreshVisible() -- Line: 36
        -- upvalues: u1 (copy), u9 (ref), ancestorEnabled (copy), u8 (ref)
        if u1:IsA("LayerCollector") then
            u9 = u1.Enabled;
        elseif u1:IsA("GuiObject") and not u1.Visible then
            u9 = false;
        else
            local Parent = u1.Parent;
            local v10;

            if Parent then
                if Parent:IsA("LayerCollector") then
                    v10 = Parent.Enabled;
                elseif Parent:IsA("GuiObject") and not Parent.Visible then
                    v10 = false;
                else
                    v10 = ancestorEnabled(Parent.Parent);
                end;
            else
                v10 = false;
            end;

            u9 = v10;
        end;

        u8 = true;
    end;

    local function updateCanvasSize() -- Line: 47
        -- upvalues: u9 (ref), u8 (ref), u1 (copy), u5 (copy), u6 (copy)
        if not (u9 and u8) then
            return;
        end;

        u8 = false;
        local AbsoluteWindowSize = u1.AbsoluteWindowSize;
        local AbsoluteContentSize = u5.AbsoluteContentSize;

        if u6 then
            AbsoluteContentSize = AbsoluteContentSize + Vector2.new(u6.PaddingLeft.Offset, u6.PaddingTop.Offset) + Vector2.new(u6.PaddingRight.Offset, u6.PaddingBottom.Offset) + AbsoluteWindowSize * Vector2.new(u6.PaddingLeft.Scale, u6.PaddingTop.Scale) + AbsoluteWindowSize * Vector2.new(u6.PaddingRight.Scale, u6.PaddingBottom.Scale);
        end;

        if u1.ScrollingDirection == Enum.ScrollingDirection.X then
            AbsoluteContentSize = Vector2.new(AbsoluteContentSize.X, AbsoluteWindowSize.Y);
        elseif u1.ScrollingDirection == Enum.ScrollingDirection.Y then
            AbsoluteContentSize = Vector2.new(AbsoluteWindowSize.X, AbsoluteContentSize.Y);
        end;

        u1.CanvasSize = UDim2.fromOffset(AbsoluteContentSize.X, AbsoluteContentSize.Y);
    end;

    RunService.RenderStepped:Connect(function() -- Line: 69
        -- upvalues: updateCanvasSize (copy)
        updateCanvasSize();
    end);
    u5:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshVisible);
    u1:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(refreshVisible);
    v4.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(refreshVisible);
    updateCanvasSize();
    local Parent = u1.Parent;

    while Parent do
        if Parent:IsA("BillboardGui") or Parent:IsA("ScreenGui") then
            Parent:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 83
                -- upvalues: Parent (copy), u1 (copy), u9 (ref), ancestorEnabled (copy), u8 (ref)
                if Parent.Enabled then
                    if u1:IsA("LayerCollector") then
                        u9 = u1.Enabled;
                    elseif u1:IsA("GuiObject") and not u1.Visible then
                        u9 = false;
                    else
                        local Parent2 = u1.Parent;
                        local v11;

                        if Parent2 then
                            if Parent2:IsA("LayerCollector") then
                                v11 = Parent2.Enabled;
                            elseif Parent2:IsA("GuiObject") and not Parent2.Visible then
                                v11 = false;
                            else
                                v11 = ancestorEnabled(Parent2.Parent);
                            end;
                        else
                            v11 = false;
                        end;

                        u9 = v11;
                    end;

                    u8 = true;
                end;
            end);
            break;
        end;

        if Parent:IsA("Frame") then
            Parent:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 92
                -- upvalues: Parent (copy), u1 (copy), u9 (ref), ancestorEnabled (copy), u8 (ref)
                if Parent.Visible then
                    if u1:IsA("LayerCollector") then
                        u9 = u1.Enabled;
                    elseif u1:IsA("GuiObject") and not u1.Visible then
                        u9 = false;
                    else
                        local Parent2 = u1.Parent;
                        local v12;

                        if Parent2 then
                            if Parent2:IsA("LayerCollector") then
                                v12 = Parent2.Enabled;
                            elseif Parent2:IsA("GuiObject") and not Parent2.Visible then
                                v12 = false;
                            else
                                v12 = ancestorEnabled(Parent2.Parent);
                            end;
                        else
                            v12 = false;
                        end;

                        u9 = v12;
                    end;

                    u8 = true;
                end;
            end);
        end;

        Parent = Parent.Parent;
    end;
end;