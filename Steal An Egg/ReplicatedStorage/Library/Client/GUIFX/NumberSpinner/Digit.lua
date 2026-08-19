-- Decompiled with Potassium's decompiler.

local TextService = game:GetService("TextService");
local TweenService = game:GetService("TweenService");
local u1 = TweenInfo.new(0.15);

return {
    new = function(u2, p3, p4, p5, p6) -- Line: 6, Name: new
        -- upvalues: TweenService (copy), TextService (copy), u1 (copy)
        local u7 = {
            Duration = u2.Duration,
            Value = p5,
            Labels = table.create(10),
            CanvasTweens = table.create(10)
        };
        local u8 = TweenInfo.new(u2.Duration);
        local Frame = Instance.new("Frame");
        Frame.Name = "digit";
        Frame.LayoutOrder = p4;
        Frame.BackgroundTransparency = 1;

        if p3.TextSize then
            Frame.Size = UDim2.new(0, 0, 0, u2.TextSize + 6);
        else
            Frame.Size = UDim2.fromScale(0, 1);
            Frame.AutomaticSize = Enum.AutomaticSize.X;
        end;

        Frame.ClipsDescendants = true;
        Frame.ZIndex = p6 and (p6.ZIndex or 1) or 1;
        local Frame2 = Instance.new("Frame");
        Frame2.Name = "canvas";
        Frame2.Size = UDim2.new(1, 0, 10, 0);
        Frame2.BackgroundTransparency = 1;
        Frame2.Parent = Frame;
        Frame2.ZIndex = p6 and (p6.ZIndex or 1) or 1;
        Frame2.Position = UDim2.new(0, 0, -u7.Value, 0);
        local v9 = p3.PrefixLabel:FindFirstChildWhichIsA("UIStroke");
        local v10 = p3.PrefixLabel:FindFirstChildWhichIsA("UIGradient");

        for i = 0, 9 do
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "n_" .. i;
            TextLabel.BackgroundTransparency = 1;
            TextLabel.TextSize = u2.TextSize;
            TextLabel.TextColor3 = u2.TextColor3;
            TextLabel.Font = u2.Font;
            TextLabel.Text = i;
            TextLabel.Position = UDim2.new(0, 0, i * 0.1, 0);
            TextLabel.ZIndex = p6 and (p6.ZIndex or 1) or 1;

            if p3.TextSize then
                TextLabel.TextSize = p3.TextSize;
                TextLabel.Size = UDim2.new(1, 0, 0.1, 0);
            else
                TextLabel.Size = UDim2.new(0, 0, 0.1, 0);
                TextLabel.TextScaled = true;
                TextLabel.TextWrapped = true;
                TextLabel.AutomaticSize = Enum.AutomaticSize.X;
            end;

            if v9 then
                v9:Clone().Parent = TextLabel;
            end;

            if v10 then
                v10:Clone().Parent = TextLabel;
            end;

            TextLabel.Parent = Frame2;
            u7.Labels[i] = TextLabel;
            u7.CanvasTweens[i] = TweenService:Create(Frame2, u8, {
                Position = UDim2.new(0, 0, -i, 0)
            });
        end;

        Frame.Parent = u2.Frame;
        local v11 = TextService:GetTextSize("8", u2.TextSize, u2.Font, Vector2.new(u2.TextSize, u2.TextSize));
        TweenService:Create(Frame, u1, {
            Size = UDim2.new(0, v11.X + 1, 0, v11.Y + 10)
        }):Play();
        local v18 = setmetatable({}, {
            __index = function(p12, u13) -- Line: 79, Name: __index
                -- upvalues: u7 (copy)
                local v14 = u7[u13];

                if v14 then
                    return v14;
                end;

                if pcall(function() -- Line: 83
                    -- upvalues: u7 (ref), u13 (copy)
                    local _ = u7.Labels[1][u13];
                end) then
                    return u7.Labels[1][u13];
                end;

                return nil;
            end,

            __newindex = function(p15, u16, p17) -- Line: 91, Name: __newindex
                -- upvalues: u7 (copy)
                if not u7[u16] then
                    if pcall(function() -- Line: 97
                        -- upvalues: u7 (ref), u16 (copy)
                        local _ = u7.Labels[1][u16];
                    end) then
                        u7.Labels[0][u16] = p17;
                        u7.Labels[1][u16] = p17;
                        u7.Labels[2][u16] = p17;
                        u7.Labels[3][u16] = p17;
                        u7.Labels[4][u16] = p17;
                        u7.Labels[5][u16] = p17;
                        u7.Labels[6][u16] = p17;
                        u7.Labels[7][u16] = p17;
                        u7.Labels[8][u16] = p17;
                        u7.Labels[9][u16] = p17;
                        u7:Update(u16, p17);
                    end;

                    return;
                end;

                u7[u16] = p17;
                u7:Update(u16, p17);
            end
        });

        function u7.Destroy(p19) -- Line: 116
            -- upvalues: TextService (ref), u2 (copy), TweenService (ref), Frame (copy), u1 (ref), u7 (copy)
            local v20 = TextService:GetTextSize("8", u2.TextSize, u2.Font, Vector2.new(u2.TextSize, u2.TextSize));
            local u21 = TweenService:Create(Frame, u1, {
                Size = UDim2.new(0, 0, 0, v20.Y + 10)
            });
            u21.Completed:Connect(function() -- Line: 126
                -- upvalues: Frame (ref), u7 (ref), u21 (copy)
                Frame:Destroy();
                table.clear(u7);
                u21:Destroy();
            end);
            u21:Play();
        end;

        function u7.Update(p22, p23, p24) -- Line: 133
            -- upvalues: u8 (ref), u7 (copy), TweenService (ref), Frame2 (copy), TextService (ref), u2 (copy), Frame (copy), u1 (ref)
            if p23 ~= "Duration" then
                if p23 == "Value" then
                    local v25 = u7.CanvasTweens[p24];

                    if v25 then
                        v25:Play();

                        return;
                    end;
                elseif p23 == "TextSize" or p23 == "Font" then
                    local v26 = TextService:GetTextSize("8", u2.TextSize, u2.Font, Vector2.new(u2.TextSize, u2.TextSize));
                    TweenService:Create(Frame, u1, {
                        Size = UDim2.new(0, v26.X + 1, 0, v26.Y + 10)
                    }):Play();
                end;

                return;
            end;

            u8 = TweenInfo.new(p24);

            for i = 0, 9 do
                u7.CanvasTweens[i] = TweenService:Create(Frame2, u8, {
                    Position = UDim2.new(0, 0, -i, 0)
                });
            end;
        end;

        return v18;
    end
};