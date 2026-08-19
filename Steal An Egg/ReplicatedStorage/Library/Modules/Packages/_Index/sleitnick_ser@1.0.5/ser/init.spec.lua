-- Decompiled with Potassium's decompiler.

return function() -- Line: 1
    local Parent = require(script.Parent);
    local Option = require(script.Parent.Parent.Option);
    describe("SerializeArgs", function() -- Line: 5
        -- upvalues: Option (copy), Parent (copy)
        it("should serialize an option", function() -- Line: 6
            -- upvalues: Option (ref), Parent (ref)
            local v1 = Option.Some(32);
            local v2 = table.unpack(Parent.SerializeArgs(v1));
            expect(v2.ClassName).to.equal("Option");
            expect(v2.Value).to.equal(32);
        end);
    end);
    describe("SerializeArgsAndUnpack", function() -- Line: 14
        -- upvalues: Option (copy), Parent (copy)
        it("should serialize an option", function() -- Line: 15
            -- upvalues: Option (ref), Parent (ref)
            local v3 = Option.Some(32);
            local v4 = Parent.SerializeArgsAndUnpack(v3);
            expect(v4.ClassName).to.equal("Option");
            expect(v4.Value).to.equal(32);
        end);
    end);
    describe("DeserializeArgs", function() -- Line: 23
        -- upvalues: Parent (copy), Option (copy)
        it("should deserialize args to option", function() -- Line: 24
            -- upvalues: Parent (ref), Option (ref)
            local v5 = table.unpack(Parent.DeserializeArgs({
                ClassName = "Option",
                Value = 32
            }));
            expect(Option.Is(v5)).to.equal(true);
            expect(v5:Contains(32)).to.equal(true);
        end);
    end);
    describe("DeserializeArgsAndUnpack", function() -- Line: 35
        -- upvalues: Parent (copy), Option (copy)
        it("should deserialize args to option", function() -- Line: 36
            -- upvalues: Parent (ref), Option (ref)
            local v6 = Parent.DeserializeArgsAndUnpack({
                ClassName = "Option",
                Value = 32
            });
            expect(Option.Is(v6)).to.equal(true);
            expect(v6:Contains(32)).to.equal(true);
        end);
    end);
end;