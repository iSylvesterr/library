-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
game:GetService("UserInputService");
local Maid = require(game.ReplicatedStorage.Packages.Maid);
local u1 = {};

return function(p2) -- Line: 14
    -- upvalues: u1 (copy), TweenService (copy), Maid (copy)
    local function evalColorSequence(p3, p4) -- Line: 15
        if p4 == 0 then
            return p3.Keypoints[1].Value;
        end;

        if p4 == 1 then
            return p3.Keypoints[#p3.Keypoints].Value;
        end;

        for i = 1, #p3.Keypoints - 1 do
            local v5 = p3.Keypoints[i];
            local v6 = p3.Keypoints[i + 1];

            if v5.Time <= p4 and p4 < v6.Time then
                local v7 = (p4 - v5.Time) / (v6.Time - v5.Time);

                return Color3.new((v6.Value.R - v5.Value.R) * v7 + v5.Value.R, (v6.Value.G - v5.Value.G) * v7 + v5.Value.G, (v6.Value.B - v5.Value.B) * v7 + v5.Value.B);
            end;
        end;
    end;

    function p2.SetCircBar(p8, p9, p10, p11, p12, p13) -- Line: 62
        -- upvalues: u1 (ref), TweenService (ref)
        if not u1[p9] then
            return;
        end;

        if u1[p9].currentRatio == p10 then
            return;
        end;

        local v14 = p12 or Enum.EasingStyle.Linear;
        local v15 = p13 or Enum.EasingDirection.InOut;
        local v16 = math.clamp(p10, 0, 1);

        if u1[p9].currentTween then
            u1[p9].currentTween:Cancel();
        end;

        u1[p9].currentRatio = v16;

        if p11 == 0 then
            u1[p9].numVal.Value = u1[p9].currentRatio;

            return;
        end;

        u1[p9].currentTween = TweenService:Create(u1[p9].numVal, TweenInfo.new(p11, v14, v15), {
            Value = u1[p9].currentRatio
        });
        u1[p9].currentTween:Play();
    end;

    function p2.AddCircBar(p17, u18, p19, p20, p21) -- Line: 90
        -- upvalues: u1 (ref), Maid (ref), evalColorSequence (copy)
        local u22 = p21 or ColorSequence.new(Color3.new(1, 1, 1));
        u1[u18] = {};
        u1[u18].maid = Maid.new();
        u1[u18].currentRatio = 0;
        u1[u18].currentTween = nil;
        u1[u18].numVal = Instance.new("NumberValue");
        u1[u18].numVal.Parent = u18;
        local Frame = Instance.new("Frame");
        Frame.Size = UDim2.new(0.5, 0, 1, 0);
        Frame.AnchorPoint = Vector2.new(1, 0.5);
        Frame.Position = UDim2.new(0.5, 0, 0.5, 0);
        Frame.ClipsDescendants = true;
        Frame.BackgroundTransparency = 1;
        Frame.Parent = u18;
        Frame.ZIndex = u18.ZIndex + 1;
        local ImageLabel = Instance.new("ImageLabel");
        ImageLabel.Size = UDim2.new(2 * p19, 0, 1 * p19, 0);
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
        ImageLabel.Position = UDim2.new(1, 0, 0.5, 0);
        ImageLabel.BackgroundTransparency = 1;
        ImageLabel.Image = "rbxassetid://140471508168198";
        ImageLabel.Parent = Frame;
        ImageLabel.ZIndex = u18.ZIndex + 1;
        local UIGradient = Instance.new("UIGradient");
        UIGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.501, Color3.new(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
        });

        if p20 then
            UIGradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(0.501, 1),
                NumberSequenceKeypoint.new(1, 1)
            });
        end;

        UIGradient.Parent = ImageLabel;
        local Frame2 = Instance.new("Frame");
        Frame2.Size = UDim2.new(0.5, 0, 1, 0);
        Frame2.AnchorPoint = Vector2.new(0, 0.5);
        Frame2.Position = UDim2.new(0.5, 0, 0.5, 0);
        Frame2.ClipsDescendants = true;
        Frame2.BackgroundTransparency = 1;
        Frame2.Parent = u18;
        Frame2.ZIndex = u18.ZIndex + 1;
        local ImageLabel2 = Instance.new("ImageLabel");
        ImageLabel2.Size = UDim2.new(2 * p19, 0, 1 * p19, 0);
        ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
        ImageLabel2.Position = UDim2.new(0, 0, 0.5, 0);
        ImageLabel2.BackgroundTransparency = 1;
        ImageLabel2.Image = "rbxassetid://140471508168198";
        ImageLabel2.Parent = Frame2;
        ImageLabel2.ZIndex = u18.ZIndex + 1;
        local UIGradient2 = Instance.new("UIGradient");
        UIGradient2.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.501, Color3.new(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
        });

        if p20 then
            UIGradient2.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(0.501, 1),
                NumberSequenceKeypoint.new(1, 1)
            });
        end;

        UIGradient2.Parent = ImageLabel2;
        u1[u18].maid:GiveTask(u1[u18].numVal.Changed:Connect(function(p23) -- Line: 173
            -- upvalues: UIGradient (copy), UIGradient2 (copy), evalColorSequence (ref), u22 (ref), ImageLabel (copy)
            UIGradient.Rotation = math.clamp(p23 * 360, 180, 360);
            UIGradient2.Rotation = math.clamp(p23 * 360, 0, 180);
            local v24 = evalColorSequence(u22, p23);
            UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, v24),
                ColorSequenceKeypoint.new(0.5, v24),
                ColorSequenceKeypoint.new(0.501, Color3.new(0, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
            });
            UIGradient2.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, v24),
                ColorSequenceKeypoint.new(0.5, v24),
                ColorSequenceKeypoint.new(0.501, Color3.new(0, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
            });

            if p23 < 0.5 then
                ImageLabel.Visible = false;

                return;
            end;

            ImageLabel.Visible = true;
        end));
        u1[u18].numVal.Value = 1;
        u1[u18].numVal.Value = 0;
        u1[u18].maid:GiveTask(function() -- Line: 202
            -- upvalues: u1 (ref), u18 (copy), Frame (copy)
            if u1[u18].numVal then
                u1[u18].numVal:Destroy();
            end;

            if Frame then
                Frame:Destroy();
            end;
        end);

        return u1[u18];
    end;

    function p2.RemoveCircBar(p25, p26) -- Line: 216
        -- upvalues: u1 (ref)
        if u1[p26] then
            u1[p26].maid:Destroy();
            u1[p26] = nil;
        end;
    end;

    return p2;
end;