-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script:WaitForChild("Types"));
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Spring = require(ReplicatedStorage.Shared.Spring);

function u1.UpdateState(p2, p3) -- Line: 21
    if not (p2.Highlight and p2.Highlight.Parent) then
        return;
    end;

    if p2.IsEnabled ~= p3 then
        p2.Highlight.Enabled = p3;
        p2.IsEnabled = p3;
    end;
end;

function u1.Construct(p4) -- Line: 33
    p4.Highlight.OutlineTransparency = p4.Properties.OutlineTransparency;
    p4.Highlight.FillTransparency = p4.Properties.FillTransparency;
    p4.Highlight.OutlineColor = p4.Properties.OutlineColor;
    p4.Highlight.DepthMode = p4.Properties.DepthMode;
    p4.Highlight.FillColor = p4.Properties.FillColor;
end;

local function waitForHumanoid(p5, p6) -- Line: 43
    local v7 = p5:FindFirstChildOfClass("Humanoid");

    if v7 then
        return v7;
    end;

    local v8 = tick();

    while p5.Parent do
        task.wait(0.1);
        local v9 = p5:FindFirstChildOfClass("Humanoid");

        if v9 then
            return v9;
        end;

        if p6 and p6 <= tick() - v8 then
            return nil;
        end;
    end;

    return nil;
end;

function u1.new(p10, p11) -- Line: 67
    -- upvalues: u1 (copy), Janitor (copy), Spring (copy), waitForHumanoid (copy), RunServiceController (copy)
    local u12 = setmetatable({}, u1);
    u12.Janitor = Janitor.new();
    u12.CurrentTransparency = Spring.new(0.95, 1.5, 0.6);
    u12.Properties = p11;
    u12.Character = p10;
    u12.Highlight = u12.Janitor:Add(Instance.new("Highlight", p10));
    u12.Highlight.Enabled = false;
    u12.IsEnabled = false;
    u12.OutlineOnly = false;
    u12:Construct();
    local v13 = waitForHumanoid(p10);

    if v13 then
        u12.Janitor:Add(v13.Died:Connect(function() -- Line: 94
            -- upvalues: u12 (copy)
            u12:Destroy();
        end));
    end;

    local v14 = RunServiceController.CreateBindingName("Classes.CharacterHighlight.Pulse");
    u12.Janitor:Add(RunServiceController.BindToHeartbeat(v14, function(p15) -- Line: 101
        -- upvalues: u12 (copy)
        if not (u12.Highlight and u12.Highlight.Parent) then
            return;
        end;

        local v16 = u12.CurrentTransparency:getPosition();
        u12.CurrentTransparency:update(p15);

        if v16 >= 0.8 then
            u12.CurrentTransparency:setGoal(0.6);
        elseif v16 <= 0.6 then
            u12.CurrentTransparency:setGoal(0.8);
        end;

        if u12.OutlineOnly then
            u12.Highlight.FillColor = u12.Properties.OutlineColor:Lerp(Color3.new(1, 1, 1), 0.2);
            u12.Highlight.FillTransparency = 0.9;

            return;
        end;

        u12.Highlight.FillColor = u12.Properties.FillColor;
        u12.Highlight.FillTransparency = v16;
    end));

    return u12;
end;

function u1.Destroy(p17) -- Line: 132
    p17.Janitor:Destroy();
end;

return u1;