-- Decompiled with Potassium's decompiler.

return function(u1) -- Line: 12
    local Mutex = require(script.Parent.Mutex);
    u1:Describe("Mutex contention", function() -- Line: 15
        -- upvalues: u1 (copy), Mutex (copy)
        u1:Test("releases many queued waiters without synchronous wakeup recursion", function() -- Line: 16
            -- upvalues: Mutex (ref), u1 (ref)
            local u2 = Mutex.new();
            local v3 = assert(u2:tryLock());
            local u4 = 0;

            for _ = 1, 256 do
                task.spawn(function() -- Line: 23
                    -- upvalues: u2 (copy), u4 (ref)
                    u2:run(function() -- Line: 24
                        -- upvalues: u4 (ref)
                        u4 = u4 + 1;
                    end);
                end);
            end;

            local v5 = os.clock() + 5;

            while #u2.waiters < 256 and os.clock() < v5 do
                task.wait();
            end;

            u1:Expect(#u2.waiters):ToBe(256);
            u2:unlock(v3);
            local v6 = os.clock() + 15;

            while u4 < 256 and os.clock() < v6 do
                task.wait();
            end;

            u1:Expect(u4):ToBe(256);
            u2:Destroy();
        end);
    end);
end;