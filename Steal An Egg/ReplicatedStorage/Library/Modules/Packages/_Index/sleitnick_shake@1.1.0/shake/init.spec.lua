-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");

local function AwaitStop(p1) -- Line: 3
    local v2 = os.clock();
    p1:Update();

    while p1:IsShaking() do
        task.wait();
        p1:Update();
    end;

    return os.clock() - v2;
end;

return function() -- Line: 13
    -- upvalues: AwaitStop (copy), RunService (copy)
    local Parent = require(script.Parent);
    describe("Construct", function() -- Line: 16
        -- upvalues: Parent (copy)
        it("should construct a new shake instance", function() -- Line: 17
            -- upvalues: Parent (ref)
            expect(function() -- Line: 18
                -- upvalues: Parent (ref)
                Parent.new();
            end).to.never.throw();
        end);
    end);
    describe("Static Functions", function() -- Line: 24
        -- upvalues: Parent (copy)
        it("should get next render name", function() -- Line: 25
            -- upvalues: Parent (ref)
            local v3 = Parent.NextRenderName();
            local v4 = Parent.NextRenderName();
            local v5 = Parent.NextRenderName();
            expect(v3).to.be.a("string");
            expect(v4).to.be.a("string");
            expect(v5).to.be.a("string");
            expect(v3).to.never.equal(v4);
            expect(v4).to.never.equal(v5);
            expect(v5).to.never.equal(v3);
        end);
        it("should perform inverse square", function() -- Line: 37
            -- upvalues: Parent (ref)
            local v6 = Parent.InverseSquare(Vector3.new(10, 10, 10), 10);
            expect((typeof(v6))).to.equal("Vector3");
            expect(v6).to.equal(Vector3.new(0.099999994, 0.099999994, 0.099999994));
        end);
    end);
    describe("Cloning", function() -- Line: 48
        -- upvalues: Parent (copy)
        it("should clone a shake instance", function() -- Line: 49
            -- upvalues: Parent (ref)
            local v7 = Parent.new();
            v7.Amplitude = 5;
            v7.Frequency = 2;
            v7.FadeInTime = 3;
            v7.FadeOutTime = 4;
            v7.SustainTime = 6;
            v7.Sustain = true;
            v7.PositionInfluence = Vector3.new(1, 2, 3);
            v7.RotationInfluence = Vector3.new(3, 2, 1);

            function v7.TimeFunction() -- Line: 59
                return os.clock();
            end;

            local v8 = v7:Clone();
            expect(v8).to.be.a("table");
            expect((getmetatable(v8))).to.equal(Parent);
            expect(v8).to.never.equal(v7);

            for _, v in ipairs({ "Amplitude", "Frequency", "FadeInTime", "FadeOutTime", "SustainTime", "Sustain", "PositionInfluence", "RotationInfluence", "TimeFunction" }) do
                expect(v7[v]).to.equal(v8[v]);
            end;
        end);
        it("should clone a shake instance but ignore running state", function() -- Line: 82
            -- upvalues: Parent (ref)
            local v9 = Parent.new();
            v9:Start();
            local v10 = v9:Clone();
            expect(v9:IsShaking()).to.equal(true);
            expect(v10:IsShaking()).to.equal(false);
        end);
    end);
    describe("Shaking", function() -- Line: 91
        -- upvalues: Parent (copy), AwaitStop (ref), RunService (ref)
        it("should start", function() -- Line: 92
            -- upvalues: Parent (ref)
            local v11 = Parent.new();
            expect(v11:IsShaking()).to.equal(false);
            v11:Start();
            expect(v11:IsShaking()).to.equal(true);
        end);
        it("should stop", function() -- Line: 99
            -- upvalues: Parent (ref)
            local v12 = Parent.new();
            v12:Start();
            expect(v12:IsShaking()).to.equal(true);
            v12:Stop();
            expect(v12:IsShaking()).to.equal(false);
        end);
        it("should shake for nearly no time", function() -- Line: 107
            -- upvalues: Parent (ref), AwaitStop (ref)
            local v13 = Parent.new();
            v13.FadeInTime = 0;
            v13.FadeOutTime = 0;
            v13.SustainTime = 0;
            v13:Start();
            local v14 = AwaitStop(v13);
            expect(v14).to.be.near(0, 0.05);
        end);
        it("should shake for fade in time", function() -- Line: 117
            -- upvalues: Parent (ref), AwaitStop (ref)
            local v15 = Parent.new();
            v15.FadeInTime = 0.1;
            v15.FadeOutTime = 0;
            v15.SustainTime = 0;
            v15:Start();
            local v16 = AwaitStop(v15);
            expect(v16).to.be.near(0.1, 0.05);
        end);
        it("should shake for fade out time", function() -- Line: 127
            -- upvalues: Parent (ref), AwaitStop (ref)
            local v17 = Parent.new();
            v17.FadeInTime = 0;
            v17.FadeOutTime = 0.1;
            v17.SustainTime = 0;
            v17:Start();
            local v18 = AwaitStop(v17);
            expect(v18).to.be.near(0.1, 0.05);
        end);
        it("should shake for sustain time", function() -- Line: 137
            -- upvalues: Parent (ref), AwaitStop (ref)
            local v19 = Parent.new();
            v19.FadeInTime = 0;
            v19.FadeOutTime = 0;
            v19.SustainTime = 0.1;
            v19:Start();
            local v20 = AwaitStop(v19);
            expect(v20).to.be.near(0.1, 0.05);
        end);
        it("should shake for fade in and sustain time", function() -- Line: 147
            -- upvalues: Parent (ref), AwaitStop (ref)
            local v21 = Parent.new();
            v21.FadeInTime = 0.1;
            v21.FadeOutTime = 0;
            v21.SustainTime = 0.1;
            v21:Start();
            local v22 = AwaitStop(v21);
            expect(v22).to.be.near(0.2, 0.05);
        end);
        it("should shake for fade out and sustain time", function() -- Line: 157
            -- upvalues: Parent (ref), AwaitStop (ref)
            local v23 = Parent.new();
            v23.FadeInTime = 0;
            v23.FadeOutTime = 0.1;
            v23.SustainTime = 0.1;
            v23:Start();
            local v24 = AwaitStop(v23);
            expect(v24).to.be.near(0.2, 0.05);
        end);
        it("should shake for fade in and fade out time", function() -- Line: 167
            -- upvalues: Parent (ref), AwaitStop (ref)
            local v25 = Parent.new();
            v25.FadeInTime = 0.1;
            v25.FadeOutTime = 0.1;
            v25.SustainTime = 0;
            v25:Start();
            local v26 = AwaitStop(v25);
            expect(v26).to.be.near(0.2, 0.05);
        end);
        it("should shake for fading and sustain time", function() -- Line: 177
            -- upvalues: Parent (ref), AwaitStop (ref)
            local v27 = Parent.new();
            v27.FadeInTime = 0.1;
            v27.FadeOutTime = 0.1;
            v27.SustainTime = 0.1;
            v27:Start();
            local v28 = AwaitStop(v27);
            expect(v28).to.be.near(0.3, 0.05);
        end);
        it("should shake indefinitely", function() -- Line: 187
            -- upvalues: Parent (ref), AwaitStop (ref)
            local u29 = Parent.new();
            u29.FadeInTime = 0;
            u29.FadeOutTime = 0;
            u29.SustainTime = 0;
            u29.Sustain = true;
            u29:Start();
            task.delay(0.1, function() -- Line: 195
                -- upvalues: u29 (copy)
                u29:StopSustain();
            end);
            local v30 = AwaitStop(u29);
            expect(v30).to.be.near(0.1, 0.05);
        end);
        it("should shake indefinitely and fade out", function() -- Line: 202
            -- upvalues: Parent (ref), AwaitStop (ref)
            local u31 = Parent.new();
            u31.FadeInTime = 0;
            u31.FadeOutTime = 0.1;
            u31.SustainTime = 0;
            u31.Sustain = true;
            u31:Start();
            task.delay(0.1, function() -- Line: 210
                -- upvalues: u31 (copy)
                u31:StopSustain();
            end);
            local v32 = AwaitStop(u31);
            expect(v32).to.be.near(0.2, 0.05);
        end);
        it("should shake indefinitely and fade out with fade in time", function() -- Line: 217
            -- upvalues: Parent (ref), AwaitStop (ref)
            local u33 = Parent.new();
            u33.FadeInTime = 0.1;
            u33.FadeOutTime = 0.1;
            u33.SustainTime = 0;
            u33.Sustain = true;
            u33:Start();
            task.delay(0.3, function() -- Line: 225
                -- upvalues: u33 (copy)
                u33:StopSustain();
            end);
            local v34 = AwaitStop(u33);
            expect(v34).to.be.near(0.4, 0.05);
        end);
        it("should connect to signal", function() -- Line: 232
            -- upvalues: Parent (ref), RunService (ref), AwaitStop (ref)
            local v35 = Parent.new();
            v35.SustainTime = 0.1;
            v35:Start();
            local u36 = false;
            local v37 = v35:OnSignal(RunService.Heartbeat, function() -- Line: 237
                -- upvalues: u36 (ref)
                u36 = true;
            end);
            expect((typeof(v37))).to.equal("RBXScriptConnection");
            expect(v37.Connected).to.equal(true);
            AwaitStop(v35);
            expect(u36).to.equal(true);
            expect(v37.Connected).to.equal(false);
        end);
        it("should bind to render step", function() -- Line: 247
            -- upvalues: Parent (ref), AwaitStop (ref)
            local v38 = Parent.new();
            v38.SustainTime = 0.1;
            v38:Start();
            local u39 = false;
            v38:BindToRenderStep("ShakeTest", Enum.RenderPriority.Last.Value, function() -- Line: 252
                -- upvalues: u39 (ref)
                u39 = true;
            end);
            AwaitStop(v38);
            expect(u39).to.equal(true);
        end);
    end);
end;