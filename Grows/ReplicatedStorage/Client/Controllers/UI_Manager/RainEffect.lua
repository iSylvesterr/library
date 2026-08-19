-- Decompiled with Potassium's decompiler.

game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Packages = ReplicatedStorage:WaitForChild("Packages");
local Info = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Info");
ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Gui"):WaitForChild("Effects");
local Maid = require(Packages:WaitForChild("Maid"));
require(Info:WaitForChild("Images"));
local u1 = {};
local u2 = Random.new();

return function(p3) -- Line: 24
    -- upvalues: u1 (copy), Maid (copy), u2 (copy), TweenService (copy)
    function p3.AddRainEffect(p4, p5, u6, p7, p8, u9, p10) -- Line: 32
        -- upvalues: u1 (ref), Maid (ref), u2 (ref), TweenService (ref)
        if u1[p5] then
            return;
        end;

        u1[p5] = {};
        u1[p5].maid = Maid.new();
        local v11 = p10 or {};

        for i = 1, u6 do
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Size = p8;
            ImageLabel.Parent = p5;
            Instance.new("UIAspectRatioConstraint", ImageLabel);
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.Image = p7[u2:NextInteger(1, #p7)];
            ImageLabel.ImageTransparency = 0.5;
            local u12 = v11.RotatableImages and table.find(v11.RotatableImages, ImageLabel.Image) and true or false;
            task.spawn(function() -- Line: 58
                -- upvalues: ImageLabel (copy), i (copy), u6 (copy), u9 (copy), u12 (ref), u2 (ref), TweenService (ref)
                ImageLabel.Visible = false;
                task.wait(i / u6 * u9);
                ImageLabel.Visible = true;

                while ImageLabel do
                    if u12 then
                        ImageLabel.Rotation = u2:NextNumber(0, 360);
                        TweenService:Create(ImageLabel, TweenInfo.new(u9, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                            Rotation = u2:NextNumber(0, 360)
                        }):Play();
                    end;

                    local v13 = u2:NextNumber(-0.2, 1.2);
                    local v14 = v13 + u2:NextNumber(-0.5, 0.5);
                    local v15 = math.clamp(v14, -0.2, 1.2);
                    ImageLabel.Position = UDim2.fromScale(v13, -0.2);
                    TweenService:Create(ImageLabel, TweenInfo.new(u9, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                        Position = UDim2.fromScale(v15, 1.2)
                    }):Play();
                    task.wait(u9);
                end;
            end);
            u1[p5].maid:GiveTask(function() -- Line: 93
                -- upvalues: ImageLabel (copy)
                if ImageLabel then
                    ImageLabel:Destroy();
                end;
            end);
        end;
    end;

    function p3.RemoveRainEffect(p16, p17) -- Line: 100
        -- upvalues: u1 (ref)
        if u1[p17] then
            u1[p17].maid:Destroy();
            u1[p17] = nil;
        end;
    end;
end;