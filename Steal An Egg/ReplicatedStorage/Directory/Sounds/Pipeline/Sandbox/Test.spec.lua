-- Decompiled with Potassium's decompiler.

return function() -- Line: 1
    local Parent = require(script.Parent.Parent);
    require(game:GetService("ReplicatedStorage").Library.Modules.Packages.t);
    local v1 = string.rep("-", 50);
    local v2 = require(game:GetService("ReplicatedStorage").Library.Modules.Packages.Log).new():Mute();
    v2:AtTrace():Log((`{v1}[Test Starting]{v1}`));
    describe("testing the pipeline core features", function() -- Line: 9
        -- upvalues: Parent (copy)
        it("should be able to get and cerate sounds while still caching them and preloading them in hte background of hte game for future needs", function() -- Line: 12
            -- upvalues: Parent (ref)
            local v3 = Parent:BuildSoundFromProps("rbxassetid://9058815929", {
                Props = {
                    Volume = 2
                }
            });
            expect(v3).to.be.a("userdata");
            expect(v3.Volume).to.equal(2);
            print("loaded sound:", v3);
        end);
    end);
    v2:AtTrace():Log((`{v1}[Test Complete]{v1}`));
end;