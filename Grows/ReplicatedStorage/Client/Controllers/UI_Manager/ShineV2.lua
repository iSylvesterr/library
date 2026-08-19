-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Packages = ReplicatedStorage:WaitForChild("Packages");
local Info = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Info");
local Effects = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Gui"):WaitForChild("Effects");
local Maid = require(Packages:WaitForChild("Maid"));
local Images = require(Info:WaitForChild("Images"));
local AdvancedShine = Effects:WaitForChild("AdvancedShine");
local u1 = {};
local u2 = { Images.BEAM1, Images.BEAM3 };

return function(p3) -- Line: 30
    -- upvalues: u1 (copy), Maid (copy), AdvancedShine (copy), u2 (copy), Images (copy), TweenService (copy), RunService (copy)
    function p3.AddShineV2(p4, u5, p6, u7, p8) -- Line: 36
        -- upvalues: u1 (ref), Maid (ref), AdvancedShine (ref), u2 (ref), Images (ref), TweenService (ref), RunService (ref)
        if not u1[u5] then
            u1[u5] = {};
            u1[u5].maid = Maid.new();
            local Frame = Instance.new("Frame");
            Frame.Name = "SuperShineContainer";
            Frame.Size = UDim2.new(p6, 0, p6, 0);
            Frame.AnchorPoint = u5.AnchorPoint;
            Frame.Position = u5.Position;
            Frame.BackgroundTransparency = 1;
            Frame.ZIndex = u5.ZIndex;
            Frame.Parent = u5;
            local u9 = {};

            for i = 1, u7 do
                u9[i] = {};
                u9[i].beam = AdvancedShine:Clone();
                u9[i].beam.Shine.ZIndex = u5.ZIndex - 0.1;
                u9[i].beam.Parent = Frame;
                u9[i].beam.Size = UDim2.new(1, 0, 0.1, 0);
                u9[i].speed = math.random(0, 50) / 50 + 1;
                u9[i].pulseOffset = math.random(0, 6.283185307179586);
                u9[i].resizeOffset = math.random(0, 6.283185307179586);

                if math.random(1, 2) == 1 then
                    local v10 = u9[i];
                    v10.speed = v10.speed * -1;
                end;

                u9[i].maxScale = math.random(2, 4) / 2;
                u9[i].beam.Shine.Image = u2[math.random(1, #u2)];
            end;

            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.Image = Images.GLOW;
            ImageLabel.Parent = Frame;
            ImageLabel.Size = UDim2.new(1, 0, 1, 0);
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
            ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0);
            u1[u5].glowTween = TweenService:Create(ImageLabel, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), {
                Size = UDim2.new(1.25, 0, 1.25, 0)
            });
            u1[u5].glowTween:Play();
            local u11 = 0;
            u1[u5].timeCon = RunService.RenderStepped:Connect(function(p12) -- Line: 84
                -- upvalues: u11 (ref), u9 (copy), u7 (copy)
                u11 = u11 + p12 * 60;

                for i, v in u9 do
                    local beam = v.beam;
                    local speed = v.speed;
                    local maxScale = v.maxScale;
                    local pulseOffset = v.pulseOffset;
                    local v13 = i * 360 / u7;
                    local v14 = (u11 * speed + v13 * 2) / 180 * 3.141592653589793;
                    beam.Rotation = v13 + speed * u11;
                    local v15 = math.sin(v14 + pulseOffset);
                    local v16 = math.max(v15, 0);

                    if i % 2 == 1 then
                        beam.Size = UDim2.new(maxScale * v16 * 0.85, 0, 0.2, 0);
                        beam.Shine.ImageTransparency = 0;
                    else
                        beam.Size = UDim2.new(maxScale, 0, 0.2, 0);
                        beam.Shine.ImageTransparency = math.sin(v14 * 4 + pulseOffset);
                    end;
                end;
            end);
            u1[u5].maid:GiveTask(function() -- Line: 112
                -- upvalues: Frame (copy), u1 (ref), u5 (copy)
                if Frame then
                    Frame:Destroy();
                end;

                if u1[u5].timeCon then
                    u1[u5].timeCon:Disconnect();
                end;

                if u1[u5].glowTween then
                    u1[u5].glowTween:Cancel();
                end;
            end);

            return u5;
        end;
    end;

    function p3.RemoveShineV2(p17, p18) -- Line: 122
        -- upvalues: u1 (ref)
        if u1[p18] then
            u1[p18].maid:Destroy();
            u1[p18] = nil;
        end;
    end;
end;