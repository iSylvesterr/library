-- Decompiled with Potassium's decompiler.

game:GetService("TweenService");
local Maid = require(game.ReplicatedStorage.Packages.Maid);

return function(p1) -- Line: 16
    -- upvalues: Maid (copy)
    function p1.AddTextShadow(p2, u3, p4, p5, p6) -- Line: 25
        -- upvalues: Maid (ref)
        local u7 = Maid.new();
        local u8 = u3:Clone();
        u8:ClearAllChildren();
        u8.BackgroundTransparency = 1;
        u8.TextColor3 = p6 or Color3.new(0, 0, 0);
        u8.TextTransparency = p5 or 0.1;
        u8.Parent = u3;
        u8.Size = UDim2.new(1, 0, 1, 0);
        u8.AnchorPoint = Vector2.new(0.5, 0.5);
        u8.Position = u3.Position + UDim2.new(0.5, 0, 0.5, 0) + p4;
        u8.ZIndex = u3.ZIndex - 1;
        u7:GiveTask(u3.Changed:Connect(function() -- Line: 39
            -- upvalues: u8 (copy), u3 (copy)
            u8.Text = u3.Text;
        end));
        u7:GiveTask(u3.Destroying:Connect(function() -- Line: 43
            -- upvalues: u7 (copy), u8 (copy)
            if u7 then
                u7:Destroy();
            end;

            if u8 then
                u8:Destroy();
            end;
        end));
    end;
end;