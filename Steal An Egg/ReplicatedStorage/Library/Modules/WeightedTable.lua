-- Decompiled with Potassium's decompiler.

local u1 = {
    Instances = {}
};
u1.__index = u1;

function u1.new() -- Line: 6
    -- upvalues: u1 (copy)
    local BindableEvent = Instance.new("BindableEvent");
    BindableEvent.Parent = script;
    local v2 = {
        OnUpdate = BindableEvent.Event,
        Event = BindableEvent
    };
    setmetatable(v2, u1);

    return v2;
end;

function u1.Add(p3, p4, p5) -- Line: 17
    local v6 = game:GetService("HttpService"):GenerateGUID();
    p3.Instances[p4] = p5 or 1;

    return v6;
end;

function u1.SetWeight(p7, p8, p9) -- Line: 23
    if p7.Instances[p8] then
        p7.Instances[p8] = p9;
    end;

    p7.Event:Fire();
end;

function u1.GetHighestObject(p10) -- Line: 30
    local v11 = nil;
    local v12 = nil;

    for i, v in pairs(p10.Instances) do
        if v11 == nil or v11 <= v then
            v12 = i;
            v11 = v;
        end;
    end;

    return v12, v11;
end;

return u1;