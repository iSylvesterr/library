-- Decompiled with Potassium's decompiler.

return function() -- Line: 1
    local Parent = require(script.Parent);

    local function Awaiter(u1) -- Line: 4
        local u2 = {};
        local u3 = nil;
        local u4 = nil;

        function u2.Resume(...) -- Line: 8
            -- upvalues: u4 (ref), u3 (ref)
            if coroutine.running() ~= u4 then
                task.cancel(u4);
            end;

            task.spawn(u3, ...);
        end;

        function u2.Yield() -- Line: 14
            -- upvalues: u3 (ref), u4 (ref), u1 (copy), u2 (copy)
            u3 = coroutine.running();
            u4 = task.delay(u1, function() -- Line: 16
                -- upvalues: u2 (ref)
                u2.Resume();
            end);

            return coroutine.yield();
        end;

        return u2;
    end;

    local u5 = nil;
    beforeEach(function() -- Line: 25
        -- upvalues: u5 (ref)
        u5 = Instance.new("BindableEvent");
    end);
    afterEach(function() -- Line: 28
        -- upvalues: u5 (ref)
        u5:Destroy();
        u5 = nil;
    end);
    describe("Single", function() -- Line: 33
        -- upvalues: Parent (copy), Awaiter (copy), u5 (ref)
        it("should spawn a new concur instance", function() -- Line: 34
            -- upvalues: Parent (ref)
            local u6 = nil;
            expect(function() -- Line: 36
                -- upvalues: Parent (ref), u6 (ref)
                Parent.spawn(function() -- Line: 37
                    -- upvalues: u6 (ref)
                    u6 = 10;
                end);
            end).to.never.throw();
            expect(u6).to.equal(10);
        end);
        it("should defer a new concur instance", function() -- Line: 44
            -- upvalues: Awaiter (ref), Parent (ref)
            local u7 = Awaiter(1);
            expect(function() -- Line: 46
                -- upvalues: Parent (ref), u7 (copy)
                Parent.defer(function() -- Line: 47
                    -- upvalues: u7 (ref)
                    u7.Resume(10);
                end);
            end).to.never.throw();
            local v8 = u7.Yield();
            expect(v8).to.equal(10);
        end);
        it("should delay a new concur instance", function() -- Line: 55
            -- upvalues: Awaiter (ref), Parent (ref)
            local u9 = Awaiter(1);
            expect(function() -- Line: 57
                -- upvalues: Parent (ref), u9 (copy)
                Parent.delay(0.1, function() -- Line: 58
                    -- upvalues: u9 (ref)
                    u9.Resume(10);
                end);
            end).to.never.throw();
            local v10 = u9.Yield();
            expect(v10).to.equal(10);
        end);
        it("should create an immediate value concur instance", function() -- Line: 66
            -- upvalues: Parent (ref)
            local u11 = nil;
            expect(function() -- Line: 68
                -- upvalues: u11 (ref), Parent (ref)
                u11 = Parent.value(10);
            end).to.never.throw();
            expect(u11).to.be.ok();
            expect(u11:IsCompleted()).to.equal(true);
            local v12, v13 = u11:Await();
            expect(v12).to.never.be.ok();
            expect(v13).to.equal(10);
        end);
        it("should create a concur instance to watch an event with no predicate", function() -- Line: 78
            -- upvalues: Parent (ref), u5 (ref)
            local u14 = nil;
            expect(function() -- Line: 80
                -- upvalues: u14 (ref), Parent (ref), u5 (ref)
                u14 = Parent.event(u5.Event);
            end).to.never.throw();
            expect(u14:IsCompleted()).to.equal(false);
            u5:Fire(10);
            local v15, v16 = u14:Await(1);
            expect(v15).to.never.be.ok();
            expect(v16).to.equal(10);
        end);
        it("should create a concur instance to watch an event with a predicate", function() -- Line: 90
            -- upvalues: Parent (ref), u5 (ref)
            local u17 = nil;
            expect(function() -- Line: 92
                -- upvalues: u17 (ref), Parent (ref), u5 (ref)
                u17 = Parent.event(u5.Event, function(p18) -- Line: 93
                    return p18 < 10;
                end);
            end).to.never.throw();
            expect(u17:IsCompleted()).to.equal(false);
            u5:Fire(10);
            u5:Fire(5);
            local v19, v20 = u17:Await(1);
            expect(v19).to.never.be.ok();
            expect(v20).to.equal(5);
        end);
    end);
    describe("Multi", function() -- Line: 106
        -- upvalues: Parent (copy), u5 (ref)
        it("should complete all concur instances", function() -- Line: 107
            -- upvalues: Parent (ref), u5 (ref)
            local v21 = {
                Parent.spawn(function() -- Line: 108
                    return 10;
                end),
                Parent.defer(function() -- Line: 111
                    return 20;
                end),
                Parent.delay(0, function() -- Line: 114
                    return 30;
                end),
                Parent.spawn(function() -- Line: 117
                    error("fail");
                end),
                (Parent.event(u5.Event))
            };
            local v22 = Parent.all(v21);
            expect(v22:IsCompleted()).to.equal(false);
            u5:Fire(40);
            local v23, v24 = v22:Await(1);
            expect(v23).to.never.be.ok();
            expect(v24[1][1]).to.never.be.ok();
            expect(v24[1][2]).to.equal(10);
            expect(v24[2][1]).to.never.be.ok();
            expect(v24[2][2]).to.equal(20);
            expect(v24[3][1]).to.never.be.ok();
            expect(v24[3][2]).to.equal(30);
            expect(v24[4][1]).to.be.ok();
            expect(v24[4][2]).to.never.be.ok();
            expect(v24[5][1]).to.never.be.ok();
            expect(v24[5][2]).to.equal(40);
        end);
        it("should complete the first concur instance", function() -- Line: 138
            -- upvalues: Parent (ref)
            local v25 = { Parent.defer(function() -- Line: 139
                    return 10;
                end), (Parent.spawn(function() -- Line: 142
                    return 20;
                end)) };
            local v26, v27 = Parent.first(v25):Await(1);
            expect(v26).to.never.be.ok();
            expect(v27).to.equal(20);
        end);
    end);
    describe("Stop", function() -- Line: 152
        -- upvalues: Parent (copy), u5 (ref)
        it("should stop a single concur", function() -- Line: 153
            -- upvalues: Parent (ref)
            local v28 = Parent.defer(function() -- Line: 154
                return 10;
            end);
            expect(v28:IsCompleted()).to.equal(false);
            v28:Stop();
            expect(v28:IsCompleted()).to.equal(true);
            local v29, v30 = v28:Await();
            expect(v29).to.equal(Parent.Errors.Stopped);
            expect(v30).to.never.be.ok();
        end);
        it("should stop multiple concurs", function() -- Line: 165
            -- upvalues: Parent (ref), u5 (ref)
            local v31 = { Parent.defer(function() -- Line: 166
                end), Parent.delay(1, function() -- Line: 167
                end), (Parent.event(u5.Event)) };
            local v32 = Parent.all(v31);
            v32:Stop();
            local v33, v34 = v32:Await();
            expect(v33).to.equal(Parent.Errors.Stopped);
            expect(v34).to.never.be.ok();
        end);
        it("should not stop an already completed concur", function() -- Line: 176
            -- upvalues: Parent (ref)
            local v35 = Parent.spawn(function() -- Line: 177
                return 10;
            end);
            expect(v35:IsCompleted()).to.equal(true);
            v35:Stop();
            local v36, v37 = v35:Await();
            expect(v36).to.never.be.ok();
            expect(v37).to.equal(10);
        end);
    end);
    describe("IsCompleted", function() -- Line: 188
        -- upvalues: Parent (copy)
        it("should correctly check if a concur instance is completed", function() -- Line: 189
            -- upvalues: Parent (ref)
            local v38 = Parent.defer(function() -- Line: 190
            end);
            expect(v38:IsCompleted()).to.equal(false);
            local v39 = v38:Await();
            expect(v39).to.never.be.ok();
            expect(v38:IsCompleted()).to.equal(true);
        end);
        it("should be marked as completed if error", function() -- Line: 197
            -- upvalues: Parent (ref)
            local v40 = Parent.spawn(function() -- Line: 198
                error("err");
            end);
            expect(v40:IsCompleted()).to.equal(true);
        end);
        it("should be marked as completed if stopped", function() -- Line: 204
            -- upvalues: Parent (ref)
            local v41 = Parent.defer(function() -- Line: 205
            end);
            v41:Stop();
            expect(v41:IsCompleted()).to.equal(true);
        end);
    end);
    describe("Await", function() -- Line: 211
        -- upvalues: Parent (copy)
        it("should await concur to be completed", function() -- Line: 212
            -- upvalues: Parent (ref)
            local v42, v43 = Parent.defer(function() -- Line: 213
                return 10;
            end):Await(1);
            expect(v42).to.never.be.ok();
            expect(v43).to.equal(10);
        end);
        it("should await concur to be completed even if error", function() -- Line: 221
            -- upvalues: Parent (ref)
            local v44, v45 = Parent.defer(function() -- Line: 222
                return error("err");
            end):Await(1);
            expect(v44).to.be.ok();
            expect(v45).to.never.be.ok();
        end);
        it("should await concur to be completed even if stopped", function() -- Line: 230
            -- upvalues: Parent (ref)
            local u46 = Parent.delay(0.1, function() -- Line: 231
                return 10;
            end);
            task.defer(function() -- Line: 234
                -- upvalues: u46 (copy)
                u46:Stop();
            end);
            local v47, v48 = u46:Await(1);
            expect(v47).to.equal(Parent.Errors.Stopped);
            expect(v48).to.never.be.ok();
        end);
        it("should return completed values immediately if already completed", function() -- Line: 242
            -- upvalues: Parent (ref)
            local v49 = Parent.spawn(function() -- Line: 243
                return 10;
            end);
            expect(v49:IsCompleted()).to.equal(true);
            local v50, v51 = v49:Await();
            expect(v50).to.never.be.ok();
            expect(v51).to.equal(10);
        end);
        it("should timeout", function() -- Line: 252
            -- upvalues: Parent (ref)
            local v52 = Parent.delay(0.2, function() -- Line: 253
                return 10;
            end);
            local v53, v54 = v52:Await(0.1);
            expect(v53).to.equal(Parent.Errors.Timeout);
            expect(v54).to.never.be.ok();
            local v55, v56 = v52:Await();
            expect(v55).to.never.be.ok();
            expect(v56).to.equal(10);
        end);
    end);
    describe("OnCompleted", function() -- Line: 265
        -- upvalues: Awaiter (copy), Parent (copy)
        it("should fire function once completed", function() -- Line: 266
            -- upvalues: Awaiter (ref), Parent (ref)
            local u57 = Awaiter(0.1);
            local v58 = Parent.defer(function() -- Line: 268
                return 10;
            end);
            expect(v58:IsCompleted()).to.equal(false);
            v58:OnCompleted(function(p59, p60) -- Line: 272
                -- upvalues: u57 (copy)
                u57.Resume(p59, p60);
            end);
            local v61, v62 = u57.Yield();
            expect(v61).to.never.be.ok();
            expect(v62).to.equal(10);
        end);
        it("should fire function even if already completed", function() -- Line: 280
            -- upvalues: Parent (ref)
            local v63 = Parent.spawn(function() -- Line: 281
                return 10;
            end);
            expect(v63:IsCompleted()).to.equal(true);
            local u64 = nil;
            local u65 = nil;
            v63:OnCompleted(function(p66, p67) -- Line: 286
                -- upvalues: u64 (ref), u65 (ref)
                u64 = p66;
                u65 = p67;
            end);
            expect(u64).to.never.be.ok();
            expect(u65).to.equal(10);
        end);
        it("should fire function even if error", function() -- Line: 293
            -- upvalues: Awaiter (ref), Parent (ref)
            local u68 = Awaiter(0.1);
            Parent.defer(function() -- Line: 295
                error("err");
            end):OnCompleted(function(p69, p70) -- Line: 298
                -- upvalues: u68 (copy)
                u68.Resume(p69, p70);
            end);
            local v71, v72 = u68.Yield();
            expect(v71).to.be.ok();
            expect(v72).to.never.be.ok();
        end);
        it("should fire function even if stopped", function() -- Line: 306
            -- upvalues: Awaiter (ref), Parent (ref)
            local u73 = Awaiter(0.2);
            local u74 = Parent.delay(0.1, function() -- Line: 308
                error("err");
            end);
            u74:OnCompleted(function(p75, p76) -- Line: 311
                -- upvalues: u73 (copy)
                u73.Resume(p75, p76);
            end);
            task.defer(function() -- Line: 314
                -- upvalues: u74 (copy)
                u74:Stop();
            end);
            local v77, v78 = u73.Yield();
            expect(v77).to.equal(Parent.Errors.Stopped);
            expect(v78).to.never.be.ok();
        end);
        it("should fire function even if timeout", function() -- Line: 322
            -- upvalues: Awaiter (ref), Parent (ref)
            local u79 = Awaiter(0.5);
            Parent.delay(0.2, function() -- Line: 324
                error("err");
            end):OnCompleted(function(p80, p81) -- Line: 327
                -- upvalues: u79 (copy)
                u79.Resume(p80, p81);
            end, 0.1);
            local v82, v83 = u79.Yield();
            expect(v82).to.equal(Parent.Errors.Timeout);
            expect(v83).to.never.be.ok();
        end);
        it("should unbind function", function() -- Line: 335
            -- upvalues: Parent (ref)
            local v84 = Parent.defer(function() -- Line: 336
            end);
            local u85 = nil;
            v84:OnCompleted(function() -- Line: 338
                -- upvalues: u85 (ref)
                u85 = 10;
            end)();
            local v86 = v84:Await();
            expect(v86).to.never.be.ok();
            task.wait();
            expect(u85).to.never.be.ok();
        end);
    end);
end;