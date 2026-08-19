-- Decompiled with Potassium's decompiler.

return function() -- Line: 1
    local Parent = require(script.Parent);
    local u1 = nil;
    local u2 = nil;
    local u3 = nil;
    beforeEach(function() -- Line: 6
        -- upvalues: u1 (ref), Parent (copy), u2 (ref), u3 (ref)
        u1 = Parent.new({
            Kills = 0,
            Deaths = 0
        }, {
            SetKills = function(p4, p5) -- Line: 11, Name: SetKills
                p4.Kills = p5;
            end,

            IncrementDeaths = function(p6, p7) -- Line: 14, Name: IncrementDeaths
                p6.Deaths = p6.Deaths + p7;
            end
        });
        u2 = Parent.new({
            Money = 0
        }, {
            AddMoney = function(p8, p9) -- Line: 21, Name: AddMoney
                p8.Money = p8.Money + p9;
            end
        });
        u3 = Parent.combine({
            Stats = u1,
            Econ = u2
        });
    end);
    describe("State", function() -- Line: 31
        -- upvalues: Parent (copy), u3 (ref), u1 (ref), u2 (ref)
        it("should get state properly", function() -- Line: 32
            -- upvalues: Parent (ref)
            local v10 = Parent.new({
                ABC = 10
            }):GetState();
            expect(v10).to.be.a("table");
            expect(v10.ABC).to.equal(10);
        end);
        it("should get state from combined silos", function() -- Line: 41
            -- upvalues: u3 (ref)
            local v11 = u3:GetState();
            expect(v11).to.be.a("table");
            expect(v11.Stats).to.be.a("table");
            expect(v11.Econ).to.be.a("table");
            expect(v11.Stats.Kills).to.be.a("number");
            expect(v11.Stats.Deaths).to.be.a("number");
            expect(v11.Econ.Money).to.be.a("number");
        end);
        it("should not allow getting state from sub-silo", function() -- Line: 51
            -- upvalues: u1 (ref), u2 (ref)
            expect(function() -- Line: 52
                -- upvalues: u1 (ref)
                u1:GetState();
            end).to.throw();
            expect(function() -- Line: 55
                -- upvalues: u2 (ref)
                u2:GetState();
            end).to.throw();
        end);
        it("should throw error if attempting to modify state directly", function() -- Line: 60
            -- upvalues: u3 (ref)
            expect(function() -- Line: 61
                -- upvalues: u3 (ref)
                u3:GetState().Stats.Kills = 10;
            end).to.throw();
            expect(function() -- Line: 64
                -- upvalues: u3 (ref)
                u3:GetState().Stats.SomethingNew = 100;
            end).to.throw();
            expect(function() -- Line: 67
                -- upvalues: u3 (ref)
                u3:GetState().Stats = {};
            end).to.throw();
            expect(function() -- Line: 70
                -- upvalues: u3 (ref)
                u3:GetState().SomethingElse = {};
            end).to.throw();
        end);
    end);
    describe("Dispatch", function() -- Line: 76
        -- upvalues: u3 (ref), u1 (ref), u2 (ref), Parent (copy)
        it("should dispatch", function() -- Line: 77
            -- upvalues: u3 (ref), u1 (ref), u2 (ref)
            expect(u3:GetState().Stats.Kills).to.equal(0);
            u3:Dispatch(u1.Actions.SetKills(10));
            expect(u3:GetState().Stats.Kills).to.equal(10);
            u3:Dispatch(u2.Actions.AddMoney(10));
            u3:Dispatch(u2.Actions.AddMoney(20));
            expect(u3:GetState().Econ.Money).to.equal(30);
        end);
        it("should not allow dispatching from a sub-silo", function() -- Line: 86
            -- upvalues: u1 (ref), u2 (ref)
            expect(function() -- Line: 87
                -- upvalues: u1 (ref)
                u1:Dispatch(u1.Action.SetKills(0));
            end).to.throw();
            expect(function() -- Line: 90
                -- upvalues: u2 (ref)
                u2:Dispatch(u2.Action.AddMoney(0));
            end).to.throw();
        end);
        it("should not allow dispatching from within a modifier", function() -- Line: 95
            -- upvalues: Parent (ref)
            expect(function() -- Line: 96
                -- upvalues: Parent (ref)
                local u12 = nil;
                u12 = Parent.new({
                    Data = 0
                }, {
                    SetData = function(p13, p14) -- Line: 101, Name: SetData
                        -- upvalues: u12 (ref)
                        p13.Data = p14;
                        u12:Dispatch({
                            Name = "",
                            Payload = 0
                        });
                    end
                });
                u12:Dispatch(u12.Actions.SetData(0));
            end).to.throw();
        end);
    end);
    describe("Subscribe", function() -- Line: 111
        -- upvalues: u3 (ref), u1 (ref), Parent (copy)
        it("should subscribe to a silo", function() -- Line: 112
            -- upvalues: u3 (ref), u1 (ref)
            local u15 = nil;
            local u16 = nil;
            local u17 = 0;
            local v20 = u3:Subscribe(function(p18, p19) -- Line: 115
                -- upvalues: u17 (ref), u15 (ref), u16 (ref)
                u17 = u17 + 1;
                u15 = p18;
                u16 = p19;
            end);
            expect(u17).to.equal(0);
            u3:Dispatch(u1.Actions.SetKills(10));
            expect(u17).to.equal(1);
            expect(u15).to.be.a("table");
            expect(u16).to.be.a("table");
            expect(u15.Stats.Kills).to.equal(10);
            expect(u16.Stats.Kills).to.equal(0);
            u3:Dispatch(u1.Actions.SetKills(20));
            expect(u17).to.equal(2);
            expect(u15.Stats.Kills).to.equal(20);
            expect(u16.Stats.Kills).to.equal(10);
            v20();
            u3:Dispatch(u1.Actions.SetKills(30));
            expect(u17).to.equal(2);
        end);
        it("should not allow subscribing same function more than once", function() -- Line: 135
            -- upvalues: u3 (ref)
            local function sub() -- Line: 136
            end;

            expect(function() -- Line: 137
                -- upvalues: u3 (ref), sub (copy)
                u3:Subscribe(sub);
            end).never.to.throw();
            expect(function() -- Line: 140
                -- upvalues: u3 (ref), sub (copy)
                u3:Subscribe(sub);
            end).to.throw();
        end);
        it("should not allow subscribing to a sub-silo", function() -- Line: 145
            -- upvalues: u1 (ref)
            expect(function() -- Line: 146
                -- upvalues: u1 (ref)
                u1:Subscribe(function() -- Line: 147
                end);
            end).to.throw();
        end);
        it("should not allow subscribing from within a modifier", function() -- Line: 151
            -- upvalues: Parent (ref)
            expect(function() -- Line: 152
                -- upvalues: Parent (ref)
                local u21 = nil;
                u21 = Parent.new({
                    Data = 0
                }, {
                    SetData = function(p22, p23) -- Line: 157, Name: SetData
                        -- upvalues: u21 (ref)
                        p22.Data = p23;
                        u21:Subscribe(function() -- Line: 159
                        end);
                    end
                });
                u21:Dispatch(u21.Actions.SetData(0));
            end).to.throw();
        end);
    end);
    describe("Watch", function() -- Line: 167
        -- upvalues: u3 (ref), u2 (ref), u1 (ref)
        it("should watch value changes", function() -- Line: 168
            -- upvalues: u3 (ref), u2 (ref), u1 (ref)
            local u24 = 0;
            local u25 = 0;
            local v28 = u3:Watch(function(p26) -- Line: 169, Name: SelectMoney
                return p26.Econ.Money;
            end, function(p27) -- Line: 174
                -- upvalues: u24 (ref), u25 (ref)
                u24 = u24 + 1;
                u25 = p27;
            end);
            expect(u24).to.equal(1);
            u3:Dispatch(u2.Actions.AddMoney(10));
            expect(u24).to.equal(2);
            expect(u25).to.equal(10);
            u3:Dispatch(u2.Actions.AddMoney(20));
            expect(u24).to.equal(3);
            expect(u25).to.equal(30);
            u3:Dispatch(u2.Actions.AddMoney(0));
            expect(u24).to.equal(3);
            expect(u25).to.equal(30);
            u3:Dispatch(u1.Actions.SetKills(10));
            expect(u24).to.equal(3);
            expect(u25).to.equal(30);
            v28();
            u3:Dispatch(u2.Actions.AddMoney(10));
            expect(u24).to.equal(3);
            expect(u25).to.equal(30);
        end);
    end);
    describe("ResetToDefaultState", function() -- Line: 198
        -- upvalues: u3 (ref), u1 (ref), u2 (ref)
        it("should reset the silo to it\'s default state", function() -- Line: 199
            -- upvalues: u3 (ref), u1 (ref), u2 (ref)
            u3:Dispatch(u1.Actions.SetKills(10));
            u3:Dispatch(u2.Actions.AddMoney(30));
            expect(u3:GetState().Stats.Kills).to.equal(10);
            expect(u3:GetState().Econ.Money).to.equal(30);
            u3:ResetToDefaultState();
            expect(u3:GetState().Stats.Kills).to.equal(0);
            expect(u3:GetState().Econ.Money).to.equal(0);
        end);
    end);
end;