-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Functions = require(ReplicatedStorage:WaitForChild("Library").Functions);
local GetHolder = require(script.Parent.GetHolder);

return function(p1, p2, p3, p4) -- Line: 6
    -- upvalues: GetHolder (copy), Functions (copy)
    local u5 = p1 or 1;
    local u6 = p2 or 1;
    local u7 = p3 or Color3.new(1, 1, 1);
    local u8 = p4 or 0;
    task.spawn(function() -- Line: 12
        -- upvalues: u7 (copy), GetHolder (ref), u5 (copy), Functions (ref), u8 (copy), u6 (copy)
        local Frame = Instance.new("Frame");
        Frame.BackgroundTransparency = 1;
        Frame.BackgroundColor3 = u7;
        Frame.Size = UDim2.new(2, 0, 2, 0);
        Frame.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame.Position = UDim2.new(0.5, 0, 0.5, 0);
        Frame.BorderSizePixel = 0;
        Frame.Parent = GetHolder();

        if u5 > 0 then
            Functions.Tween(Frame, {
                BackgroundTransparency = u8
            }, { u5, "Expo", "Out" });
            wait(u5);
        else
            Frame.BackgroundTransparency = u8;
        end;

        if u6 > 0 then
            Functions.Tween(Frame, {
                BackgroundTransparency = 1
            }, { u6, "Sine", "Out" });
            wait(u6);
        else
            Frame.BackgroundTransparency = 1;
        end;

        Frame:Destroy();
    end);
end;