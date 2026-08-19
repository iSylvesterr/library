-- Decompiled with Potassium's decompiler.

local u1 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(248, 233, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(248, 177, 0)) });

local function hidden(p2) -- Line: 8
    return `<font transparency="1">{p2}</font>`;
end;

return {
    VIP_GRADIENT_ROTATION = 90,
    VIP_GRADIENT = u1,
    VIP_TAG_COLOR = Color3.fromRGB(248, 205, 0),
    VipTag = {
        clear = function(p3) -- Line: 14, Name: clear
            local VipTagOverlay = p3:FindFirstChild("VipTagOverlay");

            if VipTagOverlay ~= nil then
                VipTagOverlay:Destroy();
            end;
        end,

        applyPrefix = function(p4, p5) -- Line: 21, Name: applyPrefix
            -- upvalues: u1 (copy)
            local VipTagOverlay = p4:FindFirstChild("VipTagOverlay");

            if VipTagOverlay ~= nil then
                VipTagOverlay:Destroy();
            end;

            p4.RichText = true;
            p4.Text = `{"<font transparency=\"1\">[VIP]</font>"} {p5}`;
            local v6 = p4:Clone();

            for _, child in v6:GetChildren() do
                child:Destroy();
            end;

            v6.Name = "VipTagOverlay";
            v6.AnchorPoint = Vector2.new(0.5, 0.5);
            v6.Position = UDim2.fromScale(0.5, 0.5);
            v6.Size = UDim2.fromScale(1, 1);
            v6.Rotation = 0;
            v6.BackgroundTransparency = 1;
            v6.TextColor3 = Color3.new(1, 1, 1);
            v6.TextTransparency = 0;
            v6.ZIndex = p4.ZIndex + 1;
            v6.Text = `[VIP] {`<font transparency="1">{p5}</font>`}`;
            local UIGradient = Instance.new("UIGradient");
            UIGradient.Name = "VipTagGradient";
            UIGradient.Color = u1;
            UIGradient.Rotation = 90;
            UIGradient.Parent = v6;
            v6.Parent = p4;
        end
    }
};