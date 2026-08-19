-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Functions = require(Library.Functions);
local Assets = ReplicatedStorage:WaitForChild("Assets");
local RunService = game:GetService("RunService");
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local u1 = Random.new();

return function(p2, p3, p4) -- Line: 34
    -- upvalues: Constants (copy), Assets (copy), Functions (copy), u1 (copy), RunService (copy)
    local u5 = p4 == true;
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.Size = Vector3.new(0.05, 0.05, 0.05);
    Part.CastShadow = false;
    Part.Transparency = 1;
    Part.CFrame = p2;
    Part.Name = "RewardBillboard";
    Part.Parent = workspace:WaitForChild("__DEBRIS", Constants.STUDIO_YIELD_TIMEOUT);
    local u6 = Assets.Billboards:FindFirstChild(u5 and "Critical" or "Damage"):Clone();
    u6.Parent = Part;
    local v7 = Functions.Commas(p3 or 0);
    u6.Damage.Text = v7;

    for _, child in ipairs(u6.Damage:GetChildren()) do
        if child.ClassName == "TextLabel" then
            child.Text = v7;
        end;
    end;

    coroutine.wrap(function() -- Line: 58
        -- upvalues: u6 (copy), u5 (copy), Functions (ref)
        local Size = u6.Size;
        local v8 = u5 and 3 or 2;
        u6.Size = UDim2.new(u6.Size.X.Scale * v8, u6.Size.X.Offset * v8, u6.Size.Y.Scale * v8, u6.Size.Y.Offset * v8);
        Functions.Wait(u5 and 0.08 or 0.05);
        Functions.Tween(u6, {
            Size = Size
        }, { 0.1, "Sine", "Out" });
    end)();

    if u5 then
        coroutine.wrap(function() -- Line: 72
            -- upvalues: u6 (copy), Functions (ref)
            u6.Damage:FindFirstChildOfClass("UIGradient").Enabled = false;
            Functions.Wait(0.05);
            u6.Damage:FindFirstChildOfClass("UIGradient").Enabled = true;
        end)();
    end;

    coroutine.wrap(function() -- Line: 79
        -- upvalues: u1 (ref), Functions (ref), u6 (copy), RunService (ref)
        local v9 = os.clock();
        local v10 = u1:NextNumber(-3, 3);
        local v11 = u1:NextNumber(3.5, 5);
        local v12 = u1:NextNumber(-3, 3);

        while os.clock() - v9 <= 1.3 do
            local v13 = Functions.Easing((os.clock() - v9) / 1.3, "Sine", "Out");
            local v14 = v11 * v13 * math.sin(v13 * 3.141592653589793);
            u6.StudsOffsetWorldSpace = Vector3.new(v10 * v13, v14, v12 * v13);
            RunService.RenderStepped:Wait();
        end;
    end)();
    Functions.Tween(u6, {
        Size = UDim2.new(0, 0, 0, 0)
    }, { 0.4, "Back", "Out" }, 0.9).Completed:Connect(function() -- Line: 96
        -- upvalues: Part (copy)
        Part:Destroy();
    end);
end;