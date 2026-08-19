-- Decompiled with Potassium's decompiler.

local function ComputePadding(p1, p2) -- Line: 23
    return Vector2.new(p2.PaddingLeft.Offset + p2.PaddingRight.Offset, p2.PaddingTop.Offset + p2.PaddingBottom.Offset) + p1 * Vector2.new(p2.PaddingLeft.Scale + p2.PaddingRight.Scale, p2.PaddingTop.Scale + p2.PaddingBottom.Scale);
end;

local function ComputeCanvasSize(p3, p4) -- Line: 36
    -- upvalues: ComputePadding (copy)
    local zero = Vector2.zero;
    local zero2 = Vector2.zero;
    local v5 = p3.AbsolutePosition + p3.CanvasPosition;
    local AbsoluteSize = p3.AbsoluteSize;

    for _, child in p3:GetChildren() do
        if child:IsA("GuiObject") and child.Visible then
            local AbsoluteSize2 = child.AbsoluteSize;
            local v6 = child:FindFirstChildOfClass("UIPadding");

            if v6 then
                AbsoluteSize2 = AbsoluteSize2 + ComputePadding(AbsoluteSize2, v6);
            end;

            local v7 = child.AbsolutePosition - v5;

            if p4 then
                zero = zero:Min(v7);
            end;

            zero2 = zero2:Max(v7 + AbsoluteSize2);
        end;
    end;

    local v8 = p3:FindFirstChildOfClass("UIListLayout");

    if v8 then
        zero2 = zero2:Max(v8.AbsoluteContentSize);
    end;

    local v9 = p3:FindFirstChildOfClass("UIGridLayout");

    if v9 then
        zero2 = zero2:Max(v9.AbsoluteContentSize);
    end;

    local v10 = zero2 + zero:Abs();
    local v11 = p3:FindFirstChildWhichIsA("UIPadding");

    if v11 then
        v10 = v10 + ComputePadding(AbsoluteSize, v11);
    end;

    local ScrollingDirection = p3.ScrollingDirection;

    if ScrollingDirection == Enum.ScrollingDirection.X then
        v10 = v10 * Vector2.xAxis;
    elseif ScrollingDirection == Enum.ScrollingDirection.Y then
        v10 = v10 * Vector2.yAxis;
    end;

    return UDim2.fromOffset(v10.X, v10.Y);
end;

local function Update(p12) -- Line: 96
    -- upvalues: ComputeCanvasSize (copy)
    if p12.Destroyed then
        return;
    end;

    p12.Frame.CanvasSize = ComputeCanvasSize(p12.Frame, p12.IncludeNegativeOffset);
end;

local function RequestUpdate(u13) -- Line: 105
    -- upvalues: ComputeCanvasSize (copy)
    if u13.Destroyed or u13.Scheduled then
        return;
    end;

    u13.Scheduled = true;
    task.defer(function() -- Line: 110
        -- upvalues: u13 (copy), ComputeCanvasSize (ref)
        u13.Scheduled = false;
        local v14 = u13;

        if v14.Destroyed then
            return;
        end;

        v14.Frame.CanvasSize = ComputeCanvasSize(v14.Frame, v14.IncludeNegativeOffset);
    end);
end;

local function Unwatch(p15, p16) -- Line: 116
    local v17 = p15.Connections[p16];

    if not v17 then
        return;
    end;

    for _, v in v17 do
        v:Disconnect();
    end;

    p15.Connections[p16] = nil;
end;

local function Watch(u18, p19) -- Line: 127
    -- upvalues: ComputeCanvasSize (copy)
    if u18.Connections[p19] then
        return;
    end;

    local v20 = {};

    if p19:IsA("GuiObject") then
        v20[#v20 + 1] = p19:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- Line: 134
            -- upvalues: u18 (copy), ComputeCanvasSize (ref)
            local u21 = u18;

            if not u21.Destroyed then
                if u21.Scheduled then
                    return;
                end;

                u21.Scheduled = true;
                task.defer(function() -- Line: 110
                    -- upvalues: u21 (copy), ComputeCanvasSize (ref)
                    u21.Scheduled = false;
                    local v22 = u21;

                    if v22.Destroyed then
                        return;
                    end;

                    v22.Frame.CanvasSize = ComputeCanvasSize(v22.Frame, v22.IncludeNegativeOffset);
                end);
            end;
        end);
        v20[#v20 + 1] = p19:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 137
            -- upvalues: u18 (copy), ComputeCanvasSize (ref)
            local u23 = u18;

            if not u23.Destroyed then
                if u23.Scheduled then
                    return;
                end;

                u23.Scheduled = true;
                task.defer(function() -- Line: 110
                    -- upvalues: u23 (copy), ComputeCanvasSize (ref)
                    u23.Scheduled = false;
                    local v24 = u23;

                    if v24.Destroyed then
                        return;
                    end;

                    v24.Frame.CanvasSize = ComputeCanvasSize(v24.Frame, v24.IncludeNegativeOffset);
                end);
            end;
        end);
    else
        if not p19:IsA("UILayout") then
            return;
        end;

        v20[#v20 + 1] = p19.Changed:Connect(function() -- Line: 141
            -- upvalues: u18 (copy), ComputeCanvasSize (ref)
            local u25 = u18;

            if not u25.Destroyed then
                if u25.Scheduled then
                    return;
                end;

                u25.Scheduled = true;
                task.defer(function() -- Line: 110
                    -- upvalues: u25 (copy), ComputeCanvasSize (ref)
                    u25.Scheduled = false;
                    local v26 = u25;

                    if v26.Destroyed then
                        return;
                    end;

                    v26.Frame.CanvasSize = ComputeCanvasSize(v26.Frame, v26.IncludeNegativeOffset);
                end);
            end;
        end);
    end;

    u18.Connections[p19] = v20;
end;

return function(p27, p28) -- Line: 161, Name: AutomaticCanvasSize
    -- upvalues: ComputeCanvasSize (copy), Watch (copy)
    local u29 = {
        Scheduled = false,
        Destroyed = false,
        Frame = p27
    };
    local v30;

    if p28 then
        v30 = p28.IncludeNegativeOffset == true;
    else
        v30 = false;
    end;

    u29.IncludeNegativeOffset = v30;
    u29.Connections = {};
    u29.Connections[p27] = { p27:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- Line: 172
            -- upvalues: u29 (copy), ComputeCanvasSize (ref)
            local u31 = u29;

            if not u31.Destroyed then
                if u31.Scheduled then
                    return;
                end;

                u31.Scheduled = true;
                task.defer(function() -- Line: 110
                    -- upvalues: u31 (copy), ComputeCanvasSize (ref)
                    u31.Scheduled = false;
                    local v32 = u31;

                    if v32.Destroyed then
                        return;
                    end;

                    v32.Frame.CanvasSize = ComputeCanvasSize(v32.Frame, v32.IncludeNegativeOffset);
                end);
            end;
        end), p27.ChildAdded:Connect(function(p33) -- Line: 175
            -- upvalues: Watch (ref), u29 (copy), ComputeCanvasSize (ref)
            Watch(u29, p33);
            local u34 = u29;

            if not u34.Destroyed then
                if u34.Scheduled then
                    return;
                end;

                u34.Scheduled = true;
                task.defer(function() -- Line: 110
                    -- upvalues: u34 (copy), ComputeCanvasSize (ref)
                    u34.Scheduled = false;
                    local v35 = u34;

                    if v35.Destroyed then
                        return;
                    end;

                    v35.Frame.CanvasSize = ComputeCanvasSize(v35.Frame, v35.IncludeNegativeOffset);
                end);
            end;
        end), p27.ChildRemoved:Connect(function(p36) -- Line: 179
            -- upvalues: u29 (copy), ComputeCanvasSize (ref)
            local v37 = u29;
            local v38 = v37.Connections[p36];

            if v38 then
                for _, v in v38 do
                    v:Disconnect();
                end;

                v37.Connections[p36] = nil;
            end;

            local u39 = u29;

            if not u39.Destroyed then
                if u39.Scheduled then
                    return;
                end;

                u39.Scheduled = true;
                task.defer(function() -- Line: 110
                    -- upvalues: u39 (copy), ComputeCanvasSize (ref)
                    u39.Scheduled = false;
                    local v40 = u39;

                    if v40.Destroyed then
                        return;
                    end;

                    v40.Frame.CanvasSize = ComputeCanvasSize(v40.Frame, v40.IncludeNegativeOffset);
                end);
            end;
        end) };

    for _, child in p27:GetChildren() do
        Watch(u29, child);
    end;

    if not u29.Destroyed then
        u29.Frame.CanvasSize = ComputeCanvasSize(u29.Frame, u29.IncludeNegativeOffset);
    end;

    return function() -- Line: 191
        -- upvalues: u29 (copy)
        if u29.Destroyed then
            return;
        end;

        u29.Destroyed = true;

        for i in u29.Connections do
            local v41 = u29;
            local v42 = v41.Connections[i];

            if v42 then
                for _, v in v42 do
                    v:Disconnect();
                end;

                v41.Connections[i] = nil;
            end;
        end;
    end;
end;