-- Decompiled with Potassium's decompiler.

local u1 = game:GetService("RunService"):IsServer();
local u2 = {};

function u2.parent(u3) -- Line: 108
    -- upvalues: u2 (copy)
    return function(p4) -- Line: 109
        -- upvalues: u2 (ref), u3 (copy)
        return u2.func(p4, u3);
    end, function(p5) -- Line: 111
        -- upvalues: u2 (ref), u3 (copy)
        return u2.event(p5, u3);
    end;
end;

function u2.func(p6, p7) -- Line: 122
    -- upvalues: u1 (copy)
    if u1 then
        local RemoteFunction = Instance.new("RemoteFunction");
        RemoteFunction.Name = p6;
        RemoteFunction.Parent = p7 or script;

        return RemoteFunction;
    end;

    local v8 = (p7 or script):WaitForChild(p6);
    local v9 = v8:IsA("RemoteFunction");
    assert(v9, "expected remote function");

    return v8;
end;

function u2.event(p10, p11) -- Line: 141
    -- upvalues: u1 (copy)
    if u1 then
        local RemoteEvent = Instance.new("RemoteEvent");
        RemoteEvent.Name = p10;
        RemoteEvent.Parent = p11 or script;

        return RemoteEvent;
    end;

    local v12 = (p11 or script):WaitForChild(p10);
    local v13 = v12:IsA("RemoteEvent");
    assert(v13, "expected remote event");

    return v12;
end;

table.freeze(u2);

return u2;