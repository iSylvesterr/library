-- Decompiled with Potassium's decompiler.

local Promise = require(script.Parent.Parent.Parent.Promise);
local Signal = require(script.Parent.Parent.Parent.Signal);
local ClientRemoteSignal = require(script.Parent.ClientRemoteSignal);
require(script.Parent.Parent.Types);
local u1 = {};
u1.__index = u1;

function u1.new(p2, p3, p4) -- Line: 32
    -- upvalues: u1 (copy), ClientRemoteSignal (copy), Signal (copy), Promise (copy)
    local u5 = setmetatable({}, u1);
    u5._rs = ClientRemoteSignal.new(p2, p3, p4);
    u5._ready = false;
    u5._value = nil;
    u5.Changed = Signal.new();
    u5._rs:Fire();
    local u6 = nil;
    u5._readyPromise = Promise.new(function(p7) -- Line: 45
        -- upvalues: u6 (ref)
        u6 = p7;
    end);
    u5._changed = u5._rs:Connect(function(p8) -- Line: 48
        -- upvalues: u5 (copy), u6 (ref)
        local v9 = p8 ~= u5._value;
        u5._value = p8;

        if not u5._ready then
            u5._ready = true;
            u6(p8);
        end;

        if v9 then
            u5.Changed:Fire(p8);
        end;
    end);

    return u5;
end;

function u1.Get(p10) -- Line: 71
    return p10._value;
end;

function u1.OnReady(p11) -- Line: 94
    return p11._readyPromise;
end;

function u1.IsReady(p12) -- Line: 110
    return p12._ready;
end;

function u1.Observe(p13, p14) -- Line: 135
    if p13._ready then
        task.defer(p14, p13._value);
    end;

    return p13.Changed:Connect(p14);
end;

function u1.Destroy(p15) -- Line: 145
    p15._rs:Destroy();

    if p15._readyPromise then
        p15._readyPromise:cancel();
    end;

    if p15._changed then
        p15._changed:Disconnect();
    end;

    p15.Changed:Destroy();
end;

return u1;