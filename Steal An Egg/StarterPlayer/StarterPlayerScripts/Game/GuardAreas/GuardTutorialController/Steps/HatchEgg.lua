-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
require(ReplicatedStorage.Library.Client.GuardTutorialPresentationComponent);
local StepUtils = require(script.Parent.Parent.StepUtils);
require(script.Parent.Types.Interface);
local u1 = Color3.fromRGB(255, 255, 255);
local u3 = {
    StepId = "HatchEgg",

    IsSatisfied = function(p2) -- Line: 26, Name: IsSatisfied
        return p2:HasHatchedEgg();
    end
};

function u3.Bind(p4, p5) -- Line: 30
    -- upvalues: StepUtils (copy), u3 (copy)
    return StepUtils.BindOnAdapterChanged(p4, u3.IsSatisfied, p5);
end;

function u3.Present(u6, u7) -- Line: 34
    -- upvalues: u3 (copy), u1 (copy), RunService (copy)
    local function refreshPresentation() -- Line: 38
        -- upvalues: u3 (ref), u7 (copy), u6 (copy), u1 (ref)
        if u3.IsSatisfied(u7) then
            u6:ClearAll();

            return;
        end;

        if not u7:HasHatchableEgg() then
            u6:ClearAll();

            return;
        end;

        u6:ShowAnimatedMessage("Hatch the Egg!", u1);
        local v8 = u7:GetNearestHatchableEggTarget();

        if v8 == nil then
            u6:ClearBeam();

            return;
        end;

        u6:UpdateBeamTarget(v8);
    end;

    local u9 = u7.Changed:Connect(refreshPresentation);
    local u10 = 0;
    local u12 = RunService.Heartbeat:Connect(function(p11) -- Line: 60
        -- upvalues: u10 (ref), refreshPresentation (copy)
        u10 = u10 + p11;

        if u10 < 0.25 then
            return;
        end;

        u10 = 0;
        refreshPresentation();
    end);
    refreshPresentation();

    return function() -- Line: 71
        -- upvalues: u9 (copy), u12 (copy), u6 (copy)
        u9:Disconnect();
        u12:Disconnect();
        u6:ClearAll();
    end;
end;

return u3;