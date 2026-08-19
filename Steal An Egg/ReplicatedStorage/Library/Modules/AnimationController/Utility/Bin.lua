-- Decompiled with Potassium's decompiler.

local u8 = {
    RBXScriptConnection = function(p1) -- Line: 2
        p1:Disconnect();
    end,

    Instance = function(p2) -- Line: 5
        p2:Destroy();
    end,

    table = function(p3) -- Line: 8
        if p3.__gc then
            p3.__gc(p3);
        end;

        table.clear(p3);
        pcall(setmetatable, p3, nil);
    end,

    number = function(p4) -- Line: 15
    end,

    string = function(p5) -- Line: 18
    end,

    ["function"] = function(p6) -- Line: 22
        task.spawn(p6);
    end,

    thread = function(p7) -- Line: 25
        task.cancel(p7);
    end
};
local v9 = {};
local u10 = {
    __index = v9
};

function v9.Add(p11, ...) -- Line: 33
    local v12 = { ... };
    table.move(v12, 1, #v12, #p11._trash + 1, p11._trash);
end;

function v9.Remove(p13, ...) -- Line: 38
    for _, v in { ... } do
        local v14 = table.find(p13._trash, v);

        if v14 then
            table.remove(p13._trash, v14);
        end;
    end;
end;

function v9.Clear(p15) -- Line: 47
    -- upvalues: u8 (copy)
    for _, v in p15._trash do
        local v16 = u8[typeof(v)];

        if v16 then
            v16(v);
        end;
    end;

    table.clear(p15._trash);
end;

return {
    new = function() -- Line: 59, Name: new
        -- upvalues: u10 (copy)
        return setmetatable({
            _trash = {}
        }, u10);
    end,

    schedule = function(p17, p18) -- Line: 65, Name: schedule
        -- upvalues: u8 (copy)
        local v19 = u8[typeof(p17)];

        if not v19 then
            return;
        end;

        task.delay(p18, v19, p17);
    end
};