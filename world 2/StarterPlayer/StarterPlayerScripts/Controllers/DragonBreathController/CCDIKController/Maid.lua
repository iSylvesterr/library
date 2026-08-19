-- Decompiled with Potassium's decompiler.

local u1 = {
    ClassName = "Maid"
};
local u2 = nil;

function u1.new() -- Line: 38
    -- upvalues: u1 (copy)
    return setmetatable({
        _tasks = {}
    }, u1);
end;

function u1.__index(p3, p4) -- Line: 48
    -- upvalues: u1 (copy)
    if u1[p4] then
        return u1[p4];
    end;

    return p3._tasks[p4];
end;

function u1.__newindex(p5, p6, p7) -- Line: 65
    -- upvalues: u1 (copy)
    if u1[p6] ~= nil then
        error(("\'%s\' is reserved"):format((tostring(p6))), 2);
    end;

    local _tasks = p5._tasks;
    local v8 = _tasks[p6];
    _tasks[p6] = p7;

    if v8 then
        if type(v8) == "function" then
            v8();

            return;
        end;

        if typeof(v8) == "RBXScriptConnection" then
            v8:Disconnect();

            return;
        end;

        if v8.Destroy then
            v8:Destroy();
        end;
    end;
end;

function u1.GiveTask(p9, p10) -- Line: 89
    assert(p10, "Task cannot be false or nil");
    local v11 = #p9._tasks + 1;
    p9[v11] = p10;

    if type(p10) == "table" then
        local _ = p10.Destroy;
    end;

    return v11;
end;

function u1.GivePromise(u12, p13) -- Line: 102
    -- upvalues: u2 (ref)
    if p13:GetStatus() ~= u2.Status.Started then
        return p13;
    end;

    local v14 = u2.Resolve(p13);
    local u15 = u12:GiveTask(v14);
    v14:Finally(function() -- Line: 111
        -- upvalues: u12 (copy), u15 (copy)
        u12[u15] = nil;
    end);

    return v14;
end;

function u1.DoCleaning(p16) -- Line: 121
    local _tasks = p16._tasks;

    for i, v in pairs(_tasks) do
        if typeof(v) == "RBXScriptConnection" then
            _tasks[i] = nil;
            v:Disconnect();
        end;
    end;

    local v17, v18 = next(_tasks);

    while v18 ~= nil do
        _tasks[v17] = nil;

        if type(v18) == "function" then
            v18();
        elseif typeof(v18) == "RBXScriptConnection" then
            v18:Disconnect();
        elseif v18.Destroy then
            v18:Destroy();
        end;

        v17, v18 = next(_tasks);
    end;
end;

function u1.Init(p19) -- Line: 148
    -- upvalues: u2 (ref)
    u2 = p19.Shared.Promise;
end;

u1.Destroy = u1.DoCleaning;

return u1;