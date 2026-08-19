-- Decompiled with Potassium's decompiler.

local u3 = {
    syncCatZIndex = function(p1, p2) -- Line: 26, Name: syncCatZIndex
        for _, v in pairs(p1.categoryToSecondFrame) do
            v.ZIndex = 1;
        end;

        if p2 then
            p2.ZIndex = 99;
        end;
    end
};

function u3.closeAny(p4) -- Line: 40
    -- upvalues: u3 (copy)
    local openDropdownScroll = p4.openDropdownScroll;
    p4.openDropdownScroll = nil;

    if openDropdownScroll and openDropdownScroll.Parent then
        openDropdownScroll.Visible = false;
        local Size = openDropdownScroll.Size;
        openDropdownScroll.Size = UDim2.new(Size.X.Scale, Size.X.Offset, 0, 0);
    end;

    u3.syncCatZIndex(p4, nil);
end;

function u3.applyScrollSortViewport(p5) -- Line: 56
    local Offset = p5.CanvasSize.Y.Offset;
    local v6 = p5:GetAttribute("DropMaxH");
    local v7 = (type(v6) ~= "number" or (v6 <= 0 or not v6)) and 320 or v6;
    local v8 = math.min(Offset <= 0 and 1 or Offset, v7);
    local Size = p5.Size;
    p5.Size = UDim2.new(Size.X.Scale, Size.X.Offset, 0, v8);
end;

function u3.layoutScrollSort(u9, u10, u11) -- Line: 75
    -- upvalues: u3 (copy)
    u9.SetUIlistSize(u11);

    if u11.Visible then
        u3.applyScrollSortViewport(u11);
    else
        local Size = u11.Size;
        u11.Size = UDim2.new(Size.X.Scale, Size.X.Offset, 0, 0);
    end;

    task.defer(function() -- Line: 83
        -- upvalues: u11 (copy), u9 (copy), u3 (ref), u10 (copy)
        if u11.Parent then
            u9.SetUIlistSize(u11);

            if u11.Visible then
                u3.applyScrollSortViewport(u11);
            else
                local Size = u11.Size;
                u11.Size = UDim2.new(Size.X.Scale, Size.X.Offset, 0, 0);
            end;
        end;

        if u10 and (u10.Parent and u10:FindFirstChildOfClass("UIListLayout")) then
            u9.SetUIlistSize(u10);
        end;
    end);
end;

function u3.clearDynamicChildren(p12, p13) -- Line: 105
    for _, child in p12:GetChildren() do
        if child ~= p13 and not (child:IsA("UICorner") or (child:IsA("UIListLayout") or child:IsA("UIStroke"))) then
            child:Destroy();
        end;
    end;
end;

return u3;