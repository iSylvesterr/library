-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    if p1.ScrollingDirection == Enum.ScrollingDirection.X then
        local v2 = 0;
        local v3 = p1:FindFirstChildOfClass("UIListLayout");

        if v3 then
            v2 = v2 + v3.AbsoluteContentSize.X;
        end;

        local v4 = p1:FindFirstChildOfClass("UIGridLayout");

        if v4 then
            v2 = v2 + v4.AbsoluteContentSize.X;
        end;

        local v5 = p1:FindFirstChildOfClass("UIPadding");

        if v5 then
            v2 = v2 + (v5.PaddingLeft.Offset + v5.PaddingRight.Offset);
        end;

        p1.CanvasSize = UDim2.new(0, v2, 0, 0);

        return;
    end;

    local v6 = 0;
    local v7 = p1:FindFirstChildOfClass("UIListLayout");

    if v7 then
        v6 = v6 + v7.AbsoluteContentSize.Y;
    end;

    local v8 = p1:FindFirstChildOfClass("UIGridLayout");

    if v8 then
        v6 = v6 + v8.AbsoluteContentSize.Y;
    end;

    local v9 = p1:FindFirstChildOfClass("UIPadding");

    if v9 then
        v6 = v6 + (v9.PaddingBottom.Offset + v9.PaddingTop.Offset);
    end;

    p1.CanvasSize = UDim2.new(0, 0, 0, v6);
end;