-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");

return {
    new = function(u1, u2, u3, u4) -- Line: 5, Name: new
        -- upvalues: RunService (copy)
        local v5 = type(u1) == "number";
        assert(v5);
        local v6 = type(u2) == "number";
        assert(v6);
        local v7 = type(u3) == "number";
        assert(v7);
        local v8 = type(u4) == "function";
        assert(v8);
        local u9 = {};
        local u10 = false;
        local u11 = {};

        function u9.get(u12, p13, p14, ...) -- Line: 15
            -- upvalues: u10 (ref), u1 (copy), u11 (copy), u4 (copy)
            assert(u12 ~= nil);

            if p13 ~= nil then
                local v15 = type(p13) == "number";
                assert(v15);
                assert(p13 == p13);
                assert(p13 >= 0);
            end;

            local v16 = p14 == nil and true or type(p14) == "boolean";
            assert(v16);
            assert(not u10);
            local v17 = p13 or u1;
            local u18 = u11[u12];

            if u18 then
                u18.usedTimestamp = os.clock();
            else
                u18 = {
                    usedTimestamp = os.clock()
                };
                u11[u12] = u18;
            end;

            if not p14 and (not u18.executeTimestamp or v17 <= os.clock() - u18.executeTimestamp) then
                if u18.executing then
                    repeat
                        task.wait();
                    until not u18.executing;

                    u18.usedTimestamp = os.clock();
                else
                    u18.executing = true;
                    local u19 = nil;
                    local success, result = pcall(function(...) -- Line: 42
                        -- upvalues: u4 (ref), u12 (copy), u19 (ref), u18 (ref)
                        local v20, v21 = u4(u12, ...);

                        if v20 then
                            u19 = os.clock();
                            assert(u19);
                            u18.valueTimestamp = u19;
                            u18.value = v21;
                        end;
                    end, ...);
                    u19 = u19 or os.clock();
                    assert(u19);
                    u18.executeTimestamp = u19;
                    u18.usedTimestamp = u19;
                    u18.executing = false;

                    if not success then
                        print(`SmartCache.get({u12}, {v17}, {p14}, ...) failed: {tostring(result)}`);
                    end;
                end;
            end;

            return u18.value;
        end;

        function u9.clear(p22) -- Line: 66
            -- upvalues: u10 (ref), u11 (copy)
            assert(p22 ~= nil);
            assert(not u10);
            u11[p22] = nil;
        end;

        function u9.set(p23, p24, p25) -- Line: 72
            -- upvalues: u10 (ref), u11 (copy)
            assert(p23 ~= nil);
            assert(not u10);
            local v26 = os.clock();
            local v27 = u11[p23];

            if v27 then
                v27.usedTimestamp = v26;
            else
                v27 = {
                    usedTimestamp = v26
                };
                u11[p23] = v27;
            end;

            if not p25 then
                v27.executeTimestamp = v26;
                v27.valueTimestamp = v26;
            end;

            v27.value = p24;
        end;

        function u9.gc() -- Line: 90
            -- upvalues: u10 (ref), u11 (copy), u2 (copy)
            if not u10 then
                local v28 = os.clock();

                for i, v in pairs(u11) do
                    if not v.executing and u2 <= v28 - v.usedTimestamp then
                        u11[i] = nil;
                    end;
                end;
            end;
        end;

        local u29 = nil;
        local u30 = math.random() * u3;
        u29 = RunService.Heartbeat:Connect(function(p31) -- Line: 103
            -- upvalues: u10 (ref), u29 (ref), u30 (ref), u3 (copy), u9 (copy)
            if u10 then
                if u29 then
                    u29:Disconnect();
                end;
            else
                u30 = u30 + p31;

                if u3 <= u30 then
                    u30 = 0;
                    u9.gc();
                end;
            end;
        end);

        function u9.destroy() -- Line: 117
            -- upvalues: u10 (ref), u29 (ref)
            if not u10 then
                u10 = true;

                if u29 then
                    u29:Disconnect();
                end;
            end;
        end;

        return u9;
    end
};