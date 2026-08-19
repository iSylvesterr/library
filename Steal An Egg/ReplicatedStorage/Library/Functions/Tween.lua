-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");

return function(p1, p2, p3, p4) -- Line: 9
    -- upvalues: TweenService (copy)
    local v5 = type(p1) ~= "table" and ({ p1 } or p1) or p1;
    local v6 = {};

    for _, v in ipairs(v5) do
        local v7 = p3 or { 1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out };

        if p3 then
            if p3[2] then
                local v8 = p3[2];

                if type(v8) == "string" then
                    if string.lower(v8) == "expo" then
                        p3[2] = Enum.EasingStyle.Exponential;
                    else
                        local v9 = Enum.EasingStyle[v8];
                        local v10 = `Invalid easing style provided: "{v8}"`;
                        p3[2] = assert(v9, v10);
                    end;
                end;
            else
                p3[2] = Enum.EasingStyle.Sine;
            end;

            if p3[3] then
                local v11 = p3[3];

                if typeof(v11) == "string" then
                    local v12 = Enum.EasingDirection[v11];
                    local v13 = `Invalid easing direction provided: "{v11}"`;
                    p3[3] = assert(v12, v13);
                end;
            else
                p3[3] = Enum.EasingDirection.InOut;
            end;
        end;

        local v14 = TweenInfo.new(unpack(v7));
        local u15 = nil;

        if v:IsA("Model") then
            if p2.Scale then
                u15 = Instance.new("NumberValue");
                u15.Value = v:GetScale();
                u15.Changed:Connect(function() -- Line: 62
                    -- upvalues: v (copy), u15 (ref)
                    if v.Parent then
                        v:ScaleTo(u15.Value);
                    end;
                end);
                p2.Value = p2.Scale;
                p2.Scale = nil;
            elseif p2.CFrame then
                u15 = Instance.new("CFrameValue");
                u15.Value = v:GetPivot();
                u15.Changed:Connect(function() -- Line: 76
                    -- upvalues: v (copy), u15 (ref)
                    if v.Parent then
                        v:PivotTo(u15.Value);
                    end;
                end);
                p2.Value = p2.CFrame;
                p2.CFrame = nil;
            elseif p2.Position then
                u15 = Instance.new("Vector3Value");
                u15.Value = v:GetPivot().Position;
                u15.Changed:Connect(function() -- Line: 90
                    -- upvalues: v (copy), u15 (ref)
                    if v.Parent then
                        local v16 = v:GetPivot();
                        v:PivotTo(v16 - v16.Position + u15.Value);
                    end;
                end);
                p2.Value = p2.Position;
                p2.Position = nil;
            end;
        end;

        local u17 = TweenService:Create(u15 or v, v14, p2);

        if u15 then
            u17.Completed:Once(function() -- Line: 106
                -- upvalues: u15 (ref)
                u15:Destroy();
            end);
        end;

        if p4 then
            task.delay(p4, function() -- Line: 113
                -- upvalues: u17 (copy)
                u17:Play();
            end);
        else
            u17:Play();
        end;

        table.insert(v6, u17);
    end;

    return unpack(v6);
end;