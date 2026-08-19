-- Decompiled with Potassium's decompiler.

return function() -- Line: 1
    local Parent = require(script.Parent.Parent);
    local u1 = {
        profile = {
            Deploy = 0
        },
        Achievements = {
            Deploy = 0
        },
        __master = {
            Deploy = 0
        }
    };
    local u4 = Parent.create_yield_structure({
        Graphics_Profile = {
            Deploy = function(p2) -- Line: 10, Name: Deploy
                -- upvalues: u1 (copy)
                local profile = u1.profile;
                profile.Deploy = profile.Deploy + 1;
                local __master = u1.__master;
                __master.Deploy = __master.Deploy + 1;
                print("[Deployign graphics]:State:", u1);
                expect(p2).to.be.a("table");
            end
        },
        Graphics_Achievements = {
            Deploy = function(p3) -- Line: 18, Name: Deploy
                -- upvalues: u1 (copy)
                local Achievements = u1.Achievements;
                Achievements.Deploy = Achievements.Deploy + 1;
                local __master = u1.__master;
                __master.Deploy = __master.Deploy + 1;
                print("[Deployign graphics]:State:", u1);
                expect(p3).to.be.a("table");
            end
        }
    });
    print("TEST EZ INSPECDT BOOTRSAPPER RUNNIGN [:] Current ecosystem:", u4);
    describe("FIRST TEST", function() -- Line: 28
        -- upvalues: Parent (copy), u4 (copy)
        local u5 = Parent.new(u4, nil, "DYNAMIC");
        expect(u5).to.be.a("table");
        it("should perfectly bootsrtappe the directory", function() -- Line: 31
            -- upvalues: u5 (copy)
            u5:Bootstrap();
            print("compoentn compoenent bootsrapped", u5);
            expect(u5.Group_Id).to.be.a("string");
            expect(u5.Lifecycle).to.be.a("string");
            expect(u5.__ecosystem).to.be.a("table");
        end);
    end);
    describe("DYNAMIC TEST", function() -- Line: 40
        -- upvalues: Parent (copy), u4 (copy), u1 (copy)
        local u6 = Parent.new(u4, nil, "DYNAMIC");
        expect(u6).to.be.a("table");
        it("should perfectly bootsrtappe the directory", function() -- Line: 43
            -- upvalues: u6 (copy), u4 (ref), u1 (ref)
            u6:Bootstrap();
            print("compoentn compoenent bootsrapped", u6, "ecsoystem:", u4, "Counters:", u1);
            expect(u6.Group_Id).to.be.equal("new_group");
            expect(u6.Lifecycle).to.be.equal("DYNAMIC");
            expect(u6.__ecosystem).to.be.a("table");
            expect(u1.profile.Deploy).to.be.equal(1);
            expect(u1.Achievements.Deploy).to.be.equal(1);
        end);
    end);
end;