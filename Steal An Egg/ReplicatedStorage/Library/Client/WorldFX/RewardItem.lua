-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Library = ReplicatedStorage:WaitForChild("Library");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local __DEBRIS = workspace:WaitForChild("__DEBRIS");
local Functions = require(Library.Functions);
local ItemUI = require(ReplicatedStorage.Library.Client.UI.ItemUI);
local Player = require(ReplicatedStorage.Library.Player);

return function(p1, p2, p3) -- Line: 11, Name: createRewardItemBillboard
    -- upvalues: Player (copy), Assets (copy), __DEBRIS (copy), ItemUI (copy), Functions (copy), RunService (copy)
    if typeof(p1) == "Instance" and p1:IsA("Player") then
        local v4 = Player.Optional.PrimaryPart(p1);
        assert(v4);
        local v5 = 3 + math.random() * 3;
        local v6 = math.random() * 2 * 3.141592653589793;
        local v7 = math.cos(v6);
        local v8 = math.sin(v6);
        local v9 = v5 * Vector3.new(v7, 0, v8);
        p1 = CFrame.new(v4.Position + v9);
    elseif typeof(p1) == "Vector3" then
        p1 = CFrame.new(p1);
    elseif typeof(p1) ~= "CFrame" then
        p1 = nil;
    end;

    assert(p1);
    local u10 = (p3 or {}).time or 3;
    local u11 = Assets.Billboards:FindFirstChild("RewardItem"):Clone();
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.Size = Vector3.new();
    Part.Transparency = 1;
    Part.CFrame = p1;
    Part.Name = "RewardBillboard";
    Part.Parent = __DEBRIS;
    local v12 = ItemUI.Create(p2, {
        HideStrength = true,
        NoOverlay = true,
        NoScribble = true,
        HideQuantity = p2:GetAmount() == 1
    });
    v12.BackgroundTransparency = 1;
    v12.AnchorPoint = Vector2.new(0.5, 0.5);
    v12.Size = UDim2.new(0.35, 0, 0.35, 0);
    v12.Position = UDim2.new(0.5, 0, 0.5, 0);
    v12.Parent = u11;
    u11.Parent = Part;
    coroutine.wrap(function() -- Line: 47
        -- upvalues: u11 (copy), Functions (ref)
        local Size = u11.Size;
        u11.Size = UDim2.new(u11.Size.X.Scale * 1.3, u11.Size.X.Offset * 1.3, u11.Size.Y.Scale * 1.3, u11.Size.Y.Offset * 1.3);
        Functions.Wait(0.05);
        Functions.Tween(u11, {
            Size = Size
        }, { 0.1, "Sine", "Out" });
    end)();
    coroutine.wrap(function() -- Line: 60
        -- upvalues: u11 (copy), u10 (copy), Functions (ref), RunService (ref)
        local v13 = os.clock();
        local StudsOffsetWorldSpace = u11.StudsOffsetWorldSpace;

        while os.clock() - v13 <= u10 do
            local v14 = 3 * Functions.Easing((os.clock() - v13) / u10, "Linear", "InOut");
            u11.StudsOffsetWorldSpace = StudsOffsetWorldSpace + Vector3.new(0, v14, 0);
            RunService.RenderStepped:Wait();
        end;
    end)();
    local v15 = nil;

    for _, descendant in ipairs(u11:GetDescendants()) do
        if descendant.ClassName == "TextLabel" then
            v15 = Functions.Tween(descendant, {
                TextTransparency = 1,
                TextStrokeTransparency = 1
            }, { 0.5, "Linear", "Out" }, u10 - 0.5);
        elseif descendant.ClassName == "ImageLabel" then
            v15 = Functions.Tween(descendant, {
                ImageTransparency = 1
            }, { 0.5, "Linear", "Out" }, u10 - 0.5);
        elseif descendant.ClassName == "UIStroke" then
            Functions.Tween(descendant, {
                Transparency = 1
            }, { 0.5, "Linear", "Out" }, u10 - 0.5);
        end;
    end;

    v15.Completed:Connect(function() -- Line: 86
        -- upvalues: Part (copy)
        Part:Destroy();
    end);

    return u11;
end;