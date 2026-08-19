-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local EmitDescendants = require(ReplicatedStorage.Library.Functions.EmitDescendants);
local Functions = require(ReplicatedStorage.Library.Functions);
local RenderStepped = require(ReplicatedStorage.Library.Functions.RenderStepped);
local u1 = { {
        Duration = 0.22,
        Height = 2.6,
        ImpactScale = 0.92,
        PeakScale = 1.12,
        PitchDegrees = -6,
        RollDegrees = 5
    }, {
        Duration = 0.18,
        Height = 1.65,
        ImpactScale = 0.96,
        PeakScale = 1.08,
        PitchDegrees = 4,
        RollDegrees = -3
    }, {
        Duration = 0.15,
        Height = 0.9,
        ImpactScale = 0.985,
        PeakScale = 1.04,
        PitchDegrees = -2,
        RollDegrees = 1.5
    } };
local u2 = {};

local function getEmitFuseContainer(p3, p4) -- Line: 55
    return p4:FindFirstChild("EmitFuse") or p3:FindFirstChild("EmitFuse");
end;

function u2.Emit(p5, p6) -- Line: 65
    -- upvalues: Asserts (copy), EmitDescendants (copy)
    Asserts.Model(p5);
    Asserts.BasePart(p6);
    local v7 = p6:FindFirstChild("EmitFuse") or p5:FindFirstChild("EmitFuse");

    if not v7 then
        return;
    end;

    EmitDescendants(v7);
end;

function u2.PlayBounce(u8, u9) -- Line: 77
    -- upvalues: Asserts (copy), u1 (copy), RenderStepped (copy), Functions (copy)
    Asserts.Model(u8);
    Asserts.func(u9);
    local u10 = u8:GetPivot();
    local u11 = u8:GetScale();

    for _, v in ipairs(u1) do
        local u12 = false;
        RenderStepped(function(p13, p14) -- Line: 87
            -- upvalues: u9 (copy), u8 (copy), u10 (copy), u11 (copy), u12 (ref), Functions (ref), v (copy)
            if u9() then
                local v15, v16, v17, v18;

                if p14 < 0.34 then
                    local v19 = Functions.Easing(math.min(p14 / 0.34, 1), Enum.EasingStyle.Back, Enum.EasingDirection.Out);
                    v15 = v.Height * v19;
                    v16 = u11 + (v.PeakScale - u11) * v19;
                    v17 = v.PitchDegrees * v19;
                    v18 = v.RollDegrees * v19;
                else
                    local v20 = 1 - Functions.Easing(math.max(p14 - 0.34, 0) / 0.66, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out);
                    v15 = v.Height * v20;
                    v17 = v.PitchDegrees * v20;
                    v18 = v.RollDegrees * v20;
                    local v21 = math.max(p14 - 0.34, 0) / 0.66;

                    if v21 < 0.55 then
                        local v22 = Functions.Easing(v21 / 0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
                        v16 = v.PeakScale + (v.ImpactScale - v.PeakScale) * v22;
                    else
                        local v23 = Functions.Easing((v21 - 0.55) / 0.45, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out);
                        v16 = v.ImpactScale + (u11 - v.ImpactScale) * v23;
                    end;
                end;

                u8:ScaleTo(v16);
                u8:PivotTo(u10 * CFrame.new(0, v15, 0) * CFrame.Angles(math.rad(v17), 0, (math.rad(v18))));

                return false;
            end;

            u8:PivotTo(u10);
            u8:ScaleTo(u11);
            u12 = true;

            return true;
        end, v.Duration, true):Wait();
        u8:ScaleTo(u11);
        u8:PivotTo(u10);

        if u12 then
            return false;
        end;
    end;

    return true;
end;

function u2.Play(p24, p25, p26) -- Line: 151
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.Model(p24);
    Asserts.BasePart(p25);
    Asserts.func(p26);

    if not u2.PlayBounce(p24, p26) then
        return false;
    end;

    u2.Emit(p24, p25);

    return true;
end;

return u2;