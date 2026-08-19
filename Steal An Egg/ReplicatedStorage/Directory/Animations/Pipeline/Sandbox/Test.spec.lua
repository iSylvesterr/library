-- Decompiled with Potassium's decompiler.

return function() -- Line: 1
    local Parent = require(script.Parent.Parent);
    local t = require(game:GetService("ReplicatedStorage").Library.Modules.Packages.t);
    local v1 = string.rep("-", 50);
    local u2 = require(game:GetService("ReplicatedStorage").Library.Modules.Packages.Log).new():Mute();
    local u3 = t.interface({
        _animationInstance = t.instanceIsA("Animation"),
        _assetId = t.string,
        _flags = t.table,
        _deferredStack = t.interface({
            resolve = t.callback,
            reject = t.callback,
            onCancel = t.callback
        })
    });
    u2:AtTrace():Log((`{v1}[Test Starting]{v1}`));
    describe("testing the pipeline core features", function() -- Line: 20
        -- upvalues: Parent (copy), u2 (copy), u3 (copy)
        it("should retrieve the animation instance and setup the animation file format", function() -- Line: 21
            -- upvalues: Parent (ref), u2 (ref)
            local v4 = Parent:GetAndSerializeAnimation("138430619845557");
            expect(v4).to.be.a("table");
            u2:AtTrace():Log("Animation Package Retrieved:", v4);
        end);
        it("should get the cache and return a promise with cache data", function() -- Line: 27
            -- upvalues: u2 (ref), Parent (ref), u3 (ref)
            task.spawn(function() -- Line: 28
                -- upvalues: u2 (ref), Parent (ref)
                u2:AtTrace():Log("Attempting to acquire cache on parallel thread (testing lock mechanism):", Parent:GetPromisePacketFromId("138430619845557"));
            end);
            local v5 = os.clock();
            local v6, u7 = Parent:GetPromisePacketFromId("138430619845557");
            u2:AtTrace():Log("Cache Access Result:", v6, u7, (`| Cache Lock Release Time: {(os.clock() - v5) * 1000}ms`));
            expect(function() -- Line: 45
                -- upvalues: u3 (ref), u7 (copy)
                u3(u7);
            end).never.to.throw();
            expect(v6).to.be.a("table");
            v6:andThen(function(...) -- Line: 50
                warn("Animation Loading Promise Completed:", ...);
            end);
        end);
        it("Should return animation from cache instantly without waiting", function() -- Line: 55
            -- upvalues: Parent (ref), u2 (ref)
            local v8 = Parent:RushGetAnimationInstance("95927055497625");
            u2:AtTrace():Log("Quick-Retrieved Single Animation:", v8);
            expect(v8).to.be.a("userdata");
            local v9 = Parent:RushGetAnimationInstance({ "95927055497625" });
            u2:AtTrace():Log("Quick-Retrieved Multiple Animations:", v9);
            expect(v9).to.be.a("table");
        end);
        it("Should wait for the animations to preload", function() -- Line: 65
            -- upvalues: Parent (ref), u2 (ref)
            local v10 = Parent:GetAnimationPackageAfterPreload("117841136525207");
            u2:AtTrace():Log("Animation Preload Started:", v10);
            local u11 = os.clock();
            v10:andThen(function(...) -- Line: 70
                warn("Animation Preload Successful:", ...);
            end):catch(function(...) -- Line: 73
                warn("Animation Preload Failed:", ...);
            end):finally(function(...) -- Line: 76
                -- upvalues: u11 (copy)
                warn(`Animation Preload Completed in {(os.clock() - u11) * 1000}ms:`, ...);
            end);
        end);
    end);
    u2:AtTrace():Log((`{v1}[Test Complete]{v1}`));
end;