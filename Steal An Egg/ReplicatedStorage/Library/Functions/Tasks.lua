-- Decompiled with Potassium's decompiler.

return function() -- Line: 1
    local u1 = {};
    local u2 = {};

    function u1.track(p3) -- Line: 5
        -- upvalues: u2 (copy)
        u2[p3] = true;
    end;

    function u1.cleanup() -- Line: 9
        -- upvalues: u2 (copy)
        for i in pairs(u2) do
            if coroutine.status(i) == "dead" then
                u2[i] = nil;
            end;
        end;
    end;

    function u1.spawn(p4, ...) -- Line: 17
        -- upvalues: u1 (copy)
        u1.track(task.spawn(p4, ...));
    end;

    function u1.defer(p5, ...) -- Line: 21
        -- upvalues: u1 (copy)
        u1.track(task.defer(p5, ...));
    end;

    function u1.delay(p6, p7, ...) -- Line: 25
        -- upvalues: u1 (copy)
        u1.track(task.delay(p6, p7, ...));
    end;

    function u1.isDone() -- Line: 29
        -- upvalues: u2 (copy)
        for i in pairs(u2) do
            if coroutine.status(i) ~= "dead" then
                return false;
            end;
        end;

        return true;
    end;

    function u1.wait() -- Line: 38
        -- upvalues: u1 (copy)
        while not u1.isDone() do
            task.wait();
        end;
    end;

    function u1.waitFor(p8) -- Line: 44
        -- upvalues: u1 (copy)
        local v9 = os.clock();

        while not u1.isDone() do
            if p8 <= os.clock() - v9 then
                return false;
            end;

            task.wait();
        end;

        return true;
    end;

    return u1;
end;