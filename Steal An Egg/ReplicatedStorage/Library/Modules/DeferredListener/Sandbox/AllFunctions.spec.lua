-- Decompiled with Potassium's decompiler.

return function() -- Line: 1
    print("Sandbox begin");
    local v1 = os.clock();
    local Parent = require(script.Parent.Parent);
    print((`it took {(os.clock() - v1) * 1000}ms to load the deferred listener.`));
    describe("creating a new deffered linstener", function() -- Line: 7
        -- upvalues: Parent (copy)
        local v2 = os.clock();
        local v3 = Parent.new();
        print(`it took {(os.clock() - v2) * 1000}ms to create the new deferred listener:`, v3);
        it("Verifiying all valause and indexes", function() -- Line: 15
            -- upvalues: Parent (ref)
            local v4 = Parent.new();
            expect(v4).to.be.a("table");
            expect(v4._stackContainer).to.be.a("table");
            expect(v4._stackChainConfig).never.to.be.ok();
        end);
        it("Shoudl be able to verify the entire api", function() -- Line: 23
            -- upvalues: Parent (ref)
            local u5 = Parent.new():GetOrCreateExecutableStack("newStack");
            it("Should be able to successfuly interact with the stack api", function() -- Line: 27
                -- upvalues: u5 (copy), Parent (ref)
                expect(u5._name).to.equal("newStack");
                u5:MarkAsResolved();
                expect(u5:IsFlagSet(Parent.STATE_FLAGS.RESOLVED)).to.equal(true);
                expect(u5:AddListener("nil stack")).never.to.be.ok();
                expect(u5:AddListener(print, "this was printed")).never.to.be.ok();
                u5:ClearFlag(Parent.STATE_FLAGS.RESOLVED);
                expect(u5:AddListener(print, "this was printe ( in an ok state ){ 1 }")).to.be.ok();
                expect(u5:AddListener(print, "this was printe ( in an ok state ){ 2 }")).to.be.ok();
                u5:SetFlag(Parent.STATE_FLAGS.RESOLVING);
                print("promise awaiting status result after resolving all listeners:", u5:ResolveAllListeners():await());
                expect(u5:ResolveAllListeners():await()).to.equal(false);
                u5:ClearFlag(Parent.STATE_FLAGS.RESOLVING);
                expect(u5:ResolveAllListeners()).to.be.a("table");
            end);
        end);
        it("Shoudl follow hte stack config api correclty without deviations", function() -- Line: 47
            -- upvalues: Parent (ref)
            local u6 = Parent.new({
                selfResolveOnDestroy = true
            });
            local u7 = u6:GetOrCreateExecutableStack("newStack");
            local u8 = u6:GetOrCreateExecutableStack("newStack2");
            local u9 = u8:Extend();
            it("Should say that the stack is empty cuase htere are pending listeners", function() -- Line: 53
                -- upvalues: u9 (copy), u8 (copy)
                expect(u9).to.be.a("table");
                expect(u8:IsStackChainEmpty()).to.equal(true);
            end);
            it("Should say that the stack is not empty casue we adde a listener to teh extension stack", function() -- Line: 58
                -- upvalues: u9 (copy), u8 (copy)
                expect(u9).to.be.a("table");
                u9:AddListener(print, "extension stack trace that it was adde to the listeenr");
                expect(u8:IsStackChainEmpty()).to.equal(false);
                expect(u8._sharedListData._masterIndex).to.equal(1);
            end);
            it("Should be able to successfuly interact with the even if mulptle stacks are here", function() -- Line: 65
                -- upvalues: u7 (copy), Parent (ref)
                expect(u7._name).to.equal("newStack");
                u7:MarkAsResolved();
                expect(u7:IsFlagSet(Parent.STATE_FLAGS.RESOLVED)).to.equal(true);
                expect(u7:AddListener("nil stack")).never.to.be.ok();
                expect(u7:AddListener(print, "this was printed")).never.to.be.ok();
                u7:ClearFlag(Parent.STATE_FLAGS.RESOLVED);
                expect(u7:AddListener(print, "this was printe ( in an ok state ){ 1 }")).to.be.ok();
                expect(u7:AddListener(print, "this was printe ( in an ok state ){ 2 }")).to.be.ok();
                u7:SetFlag(Parent.STATE_FLAGS.RESOLVING);
                print("promise awaiting status result after resolving all listeners:", u7:ResolveAllListeners():await());
                expect(u7:ResolveAllListeners():await()).to.equal(false);
                u7:ClearFlag(Parent.STATE_FLAGS.RESOLVING);
                expect(u7:ResolveAllListeners()).to.be.a("table");
                expect(u7:AddListener(print, "this was printe [Destroy] ( in an ok state ){ 1:1 }")).to.be.ok();
                expect(u7:AddListener(print, "this was printe [Destroy] ( in an ok state ){ 2:2 }")).to.be.ok();
            end);
            it("Should crreateh the 2 stacks related to the second stack:", function() -- Line: 87
                -- upvalues: u8 (copy)
                expect(u8:AddListener(print, "this was printe [Stack2] ( in an ok state ){ 1:1 }")).to.be.ok();
                expect(u8:AddListener(print, "this was printe [Stack2] ( in an ok state ){ 2:2 }")).to.be.ok();
            end);
            it("Should never say that the stack is empty cuase htere are pending listeners", function() -- Line: 92
                -- upvalues: u8 (copy)
                expect(u8:IsStackChainEmpty()).to.equal(false);
            end);
            it("Shoudl be able to destroye the entire childs inside the stack", function() -- Line: 96
                -- upvalues: u6 (copy)
                print("desotrying stack expecting the entire chain to be destroyed");
                u6:Destroy();
            end);
            it("Shoudl be able to resolve all listeners within the entire deferred stack pipeline", function() -- Line: 101
                -- upvalues: u6 (copy)
                expect(function() -- Line: 102
                    -- upvalues: u6 (ref)
                    local v10 = u6:ResolveAll(true);
                    expect(v10).to.be.a("table");
                    v10:andThen(function(...) -- Line: 105
                        print("this promise shouwd successfully set the big promise with no issues:", ...);
                    end);
                end).to.throw();
            end);
        end);
    end);
end;