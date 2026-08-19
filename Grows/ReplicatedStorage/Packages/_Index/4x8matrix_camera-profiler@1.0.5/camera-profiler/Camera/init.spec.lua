-- Decompiled with Potassium's decompiler.

return function() -- Line: 1
    local Parent = require(script.Parent);
    it("Should be able to generate a Camera instance", function() -- Line: 4
        -- upvalues: Parent (copy)
        expect(function() -- Line: 5
            -- upvalues: Parent (ref)
            Parent.new("Abc");
        end).never.to.throw();
        expect(function() -- Line: 9
            -- upvalues: Parent (ref)
            Parent.new();
        end).to.throw();
    end);
    it("Should be able to detect a Camera instance", function() -- Line: 14
        -- upvalues: Parent (copy)
        local Abcd = Parent.new("Abcd");
        expect(Parent.is(Abcd)).to.equal(true);
    end);
    describe("Camera Lifecycle methods", function() -- Line: 20
        -- upvalues: Parent (copy)
        it("Should be able to invoke & run camera lifecycles", function() -- Line: 21
            -- upvalues: Parent (ref)
            local Abcde = Parent.new("Abcde");
            local u1 = false;

            function Abcde.abc(p2) -- Line: 25
                -- upvalues: u1 (ref)
                u1 = true;
            end;

            Abcde:InvokeLifecycleMethod("abc");
            expect(u1).to.equal(true);
        end);
        it("Should be able to invoke & run camera lifecycles with varadic parameters", function() -- Line: 34
            -- upvalues: Parent (ref)
            local Abcdef = Parent.new("Abcdef");
            local u3 = false;

            function Abcdef.abc(p4, p5) -- Line: 38
                -- upvalues: u3 (ref)
                u3 = p5;
            end;

            Abcdef:InvokeLifecycleMethod("abc", true);
            expect(u3).to.equal(true);
        end);
        it("Should be able to return the result of a lifecycle", function() -- Line: 47
            -- upvalues: Parent (ref)
            local Abcdefg = Parent.new("Abcdefg");

            function Abcdefg.abc(p6, p7) -- Line: 50
                return p7;
            end;

            expect(Abcdefg:InvokeLifecycleMethod("abc", true)).to.equal(true);
        end);
    end);
end;