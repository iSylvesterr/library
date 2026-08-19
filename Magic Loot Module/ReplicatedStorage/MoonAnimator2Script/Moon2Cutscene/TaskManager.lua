-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 20
    -- upvalues: u1 (copy)
    return setmetatable({
        tasks = {}
    }, u1);
end;

function u1.clone(p2) -- Line: 28
    p2.cloned = {};

    for i, v in p2.tasks do
        p2.cloned[i] = v;
    end;

    return p2.cloned;
end;

function u1.register(u3, u4, u5, u6) -- Line: 44
    if not u6 then
        u3.tasks[u4] = u3.tasks[u4] or {};
        table.insert(u3.tasks[u4], u5);
    end;

    if u3.cloned then
        u3.cloned[u4] = u3.cloned[u4] or {};
        table.insert(u3.cloned[u4], u5);
    end;

    return function() -- Line: 55
        -- upvalues: u6 (copy), u3 (copy), u5 (copy), u4 (copy)
        if not u6 then
            table.remove(u3.tasks, table.find(u3.tasks, u5));
        end;

        if u3.cloned then
            table.remove(u3.cloned[u4], table.find(u3.cloned[u4], u5));
        end;
    end;
end;

function u1.onEnd(p7, ...) -- Line: 71
    return p7:register(true, ...);
end;

function u1.run(p8) -- Line: 79
    for _, v in p8 or {} do
        task.spawn(v);
    end;
end;

return u1;