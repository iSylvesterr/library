-- Decompiled with Potassium's decompiler.

return function() -- Line: 1
    local Parent = require(script.Parent);
    describe("Constructor", function() -- Line: 4
        -- upvalues: Parent (copy)
        it("should create a new symbol", function() -- Line: 5
            -- upvalues: Parent (ref)
            local v1 = Parent("Test");
            expect(v1).to.be.a("userdata");
            expect(v1 == v1).to.equal(true);
            expect((tostring(v1))).to.equal("Symbol(Test)");
        end);
        it("should create a new symbol with no name", function() -- Line: 12
            -- upvalues: Parent (ref)
            local v2 = Parent();
            expect(v2).to.be.a("userdata");
            expect(v2 == v2).to.equal(true);
            expect((tostring(v2))).to.equal("Symbol()");
        end);
        it("should be unique regardless of the name", function() -- Line: 19
            -- upvalues: Parent (ref)
            expect(Parent("Test") == Parent("Test")).to.equal(false);
            expect(Parent() == Parent()).to.equal(false);
            expect(Parent("Test") == Parent()).to.equal(false);
            expect(Parent("Test1") == Parent("Test2")).to.equal(false);
        end);
        it("should be useable as a table key", function() -- Line: 26
            -- upvalues: Parent (ref)
            local v3 = Parent();
            expect(({
                [v3] = 100
            })[v3]).to.equal(100);
        end);
    end);
end;