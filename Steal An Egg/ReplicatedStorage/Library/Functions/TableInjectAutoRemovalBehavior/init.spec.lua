-- Decompiled with Potassium's decompiler.

return function() -- Line: 1
    local ReplicatedStorage = game:GetService("ReplicatedStorage");
    local Parent = require(script.Parent);
    local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
    describe("testing the main functions", function() -- Line: 8
        -- upvalues: Parent (copy), Trove (copy)
        local u1 = {};
        local u2 = {};
        expect(function() -- Line: 11
            -- upvalues: Parent (ref), u1 (copy), u2 (copy)
            Parent({
                removeFrom = u1,
                object = u2
            });
        end).to.throw("Bad trove configuration inside removed object. If no trove intended then opt for creating one via config.");
        expect(function() -- Line: 15
            -- upvalues: Parent (ref)
            Parent({
                removeFrom = 33,
                object = 333
            });
        end).to.throw();
        it("Shouldl be able to handle a tabel with no trove", function() -- Line: 19
            -- upvalues: Parent (ref), u1 (copy), u2 (copy)
            local v3 = Parent({
                createTroveIfNotExists = true,
                removeFrom = u1,
                object = u2
            });
            print("sucessfully transformed the initial object", v3, u1);
            expect(v3).to.be.a("table");
            expect(v3._trove).to.be.a("table");
            expect(u1[1]).to.be.a("table");
            v3._trove:Destroy();
            print("sucessfully cleaed up the table from the initial object", u1);
            expect(u1[1]).never.to.be.a("table");
        end);
        it("Should be abel to handle the requests even if hte trove have been created internally", function() -- Line: 31
            -- upvalues: Trove (ref), Parent (ref), u1 (copy)
            local v4 = Trove.new();
            local v5 = Parent({
                removeFrom = u1,
                object = {
                    _trove = v4
                }
            });
            print("sucessfully transformed the inital. (Inernal trove)", v5, u1);
            expect(v5).to.be.a("table");
            expect(v5._trove).to.be.a("table");
            v4:Destroy();
            print("sucessfully cleaed up the table from the initial object", u1);
            expect(u1[1]).never.to.be.a("table");
        end);
        it("Should be abel to seutp the index override method", function() -- Line: 42
            -- upvalues: Trove (ref), Parent (ref), u1 (copy)
            local v6 = Trove.new();
            local v7 = Parent({
                indexOverride = "overrideindex",
                removeFrom = u1,
                object = {},
                overrideObjectTrove = v6
            });
            print("sucessfully transformed the initial with (Index override)+(External trove)", v7, u1);
            expect(u1.overrideindex).to.be.a("table");
            expect(v7._trove).never.be.a("table");
            v6:Destroy();
            print("sucessfully cleaed up the table from the initial object", u1);
            expect(u1.overrideindex).never.to.be.a("table");
        end);
    end);
end;