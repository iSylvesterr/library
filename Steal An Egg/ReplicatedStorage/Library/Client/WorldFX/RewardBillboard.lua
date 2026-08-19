-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Library = ReplicatedStorage:WaitForChild("Library");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local __DEBRIS = workspace:WaitForChild("__DEBRIS");
local Functions = require(Library.Functions);

return function(p1, p2, p3, p4) -- Line: 8, Name: RewardBillboard
    -- upvalues: __DEBRIS (copy), Assets (copy), Functions (copy), RunService (copy)
    if typeof(p1) == "Vector3" then
        p1 = CFrame.new(p1) or p1;
    end;

    local u5 = p4 or 2;
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.Size = Vector3.new(0.05, 0.05, 0.05);
    Part.Transparency = 1;
    Part.CFrame = p1;
    Part.Name = "RewardBillboard";
    Part.Parent = __DEBRIS;
    local u6 = Assets.Billboards:FindFirstChild(p3):Clone();
    local v7 = u6:GetDescendants();

    if p2 then
        for _, v in ipairs(v7) do
            if v:IsA("TextLabel") then
                v.Text = p2;
            end;
        end;
    end;

    local Size = u6.Size;
    u6.Size = UDim2.new(u6.Size.X.Scale * 0.5, u6.Size.X.Offset * 0.5, u6.Size.Y.Scale * 0.5, u6.Size.Y.Offset * 0.5);
    Functions.Tween(u6, {
        Size = Size
    }, { 0.5, "Expo", "Out" });
    u6.Parent = Part;
    task.spawn(function() -- Line: 41
        -- upvalues: u6 (copy), u5 (copy), Functions (ref), RunService (ref)
        local v8 = os.clock();
        local StudsOffsetWorldSpace = u6.StudsOffsetWorldSpace;

        while u6 and (u6.Parent and os.clock() - v8 <= u5) do
            local v9 = 3 * Functions.Easing((os.clock() - v8) / u5, "Linear", "InOut");
            u6.StudsOffsetWorldSpace = StudsOffsetWorldSpace + Vector3.new(0, v9, 0);
            RunService.RenderStepped:Wait();
        end;
    end);
    local v10 = nil;

    for _, descendant in ipairs(u6:GetDescendants()) do
        if descendant.ClassName == "TextLabel" then
            v10 = Functions.Tween(descendant, {
                TextTransparency = 1,
                TextStrokeTransparency = 1
            }, { 0.5, "Linear", "Out" }, u5 - 0.5);
        elseif descendant.ClassName == "ImageLabel" then
            v10 = Functions.Tween(descendant, {
                ImageTransparency = 1
            }, { 0.5, "Linear", "Out" }, u5 - 0.5);
        elseif descendant.ClassName == "UIStroke" then
            Functions.Tween(descendant, {
                Transparency = 1
            }, { 0.5, "Linear", "Out" }, u5 - 0.5);
        end;
    end;

    v10.Completed:Connect(function() -- Line: 67
        -- upvalues: Part (copy)
        Part:Destroy();
    end);

    return u6, Part;
end;