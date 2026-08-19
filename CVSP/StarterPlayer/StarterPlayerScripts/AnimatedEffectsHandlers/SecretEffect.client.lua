-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Bindables = game:GetService("ReplicatedStorage"):WaitForChild("Bindables");
local u1 = {};
local u2 = 0;

local function buildColorSequence(p3) -- Line: 15
    local v4 = {};

    for i = 0, 5 do
        local v5 = i / 5;
        local v6 = (math.sin((p3 + v5) * 3.141592653589793 * 2) + 1) / 2;
        local v7 = Color3.fromHSV(0, 0, v6);
        table.insert(v4, ColorSequenceKeypoint.new(v5, v7));
    end;

    return ColorSequence.new(v4);
end;

local function makeGradient(p8) -- Line: 26
    -- upvalues: buildColorSequence (copy)
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Rotation = 0;
    UIGradient.Color = buildColorSequence(0);
    UIGradient.Parent = p8;

    return UIGradient;
end;

RunService.Heartbeat:Connect(function(p9) -- Line: 34
    -- upvalues: u2 (ref), buildColorSequence (copy), u1 (copy)
    u2 = (u2 + 0.75 * p9) % 1;
    local v10 = buildColorSequence(u2);

    for i = #u1, 1, -1 do
        local v11 = u1[i];

        if v11.obj and v11.obj.Parent then
            v11.gradient.Color = v10;
        else
            if v11.gradient and v11.gradient.Parent then
                v11.gradient:Destroy();
            end;

            table.remove(u1, i);
        end;
    end;
end);

local function addObject(p12) -- Line: 51
    -- upvalues: u1 (copy), buildColorSequence (copy)
    for _, v in ipairs(u1) do
        if v.obj == p12 then
            return;
        end;
    end;

    local v13 = p12:FindFirstChildOfClass("UIGradient");

    if v13 then
        v13:Destroy();
    end;

    local v14 = {
        obj = p12
    };
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Rotation = 0;
    UIGradient.Color = buildColorSequence(0);
    UIGradient.Parent = p12;
    v14.gradient = UIGradient;
    table.insert(u1, v14);
end;

local function removeObject(p15) -- Line: 64
    -- upvalues: u1 (copy)
    for i = #u1, 1, -1 do
        local v16 = u1[i];

        if v16.obj == p15 then
            if v16.gradient and v16.gradient.Parent then
                v16.gradient:Destroy();
            end;

            table.remove(u1, i);

            return;
        end;
    end;
end;

Bindables.AddSecretGradient.Event:Connect(function(p17) -- Line: 78
    -- upvalues: addObject (copy)
    local v18 = typeof(p17) == "table" and p17 and p17 or { p17 };

    for _, v in ipairs(v18) do
        addObject(v);
    end;
end);
Bindables.RemoveSecretGradient.Event:Connect(function(p19) -- Line: 86
    -- upvalues: removeObject (copy)
    local v20 = typeof(p19) == "table" and p19 and p19 or { p19 };

    for _, v in ipairs(v20) do
        removeObject(v);
    end;
end);