-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
require(ReplicatedStorage.Library.Client.GuardTutorialPresentationComponent);
require(script.Parent.Types.Interface);
local u1 = Color3.fromRGB(255, 255, 255);
local u3 = {
    StepId = "HeadToPen",

    IsSatisfied = function(p2) -- Line: 25, Name: IsSatisfied
        return p2:HasReturnedToPen();
    end
};

function u3.Bind(u4, u5) -- Line: 29
    -- upvalues: u3 (copy), RunService (copy)
    local u6 = 0;
    local u7 = false;

    local function refresh() -- Line: 33
        -- upvalues: u7 (ref), u3 (ref), u4 (copy), u5 (copy)
        if u7 or not u3.IsSatisfied(u4) then
            return;
        end;

        u7 = true;
        u5();
    end;

    local u8 = u4.Changed:Connect(refresh);
    local u10 = RunService.Heartbeat:Connect(function(p9) -- Line: 43
        -- upvalues: u6 (ref), u7 (ref), u3 (ref), u4 (copy), u5 (copy)
        u6 = u6 + p9;

        if u6 < 0.1 then
            return;
        end;

        u6 = 0;

        if not u7 then
            if not u3.IsSatisfied(u4) then
                return;
            end;

            u7 = true;
            u5();
        end;
    end);
    task.defer(refresh);

    return function() -- Line: 54
        -- upvalues: u8 (copy), u10 (copy)
        u8:Disconnect();
        u10:Disconnect();
    end;
end;

function u3.Present(u11, u12) -- Line: 60
    -- upvalues: u3 (copy), u1 (copy)
    local function refreshPresentation() -- Line: 64
        -- upvalues: u3 (ref), u12 (copy), u11 (copy), u1 (ref)
        if u3.IsSatisfied(u12) then
            u11:ClearAll();

            return;
        end;

        local v13 = u12:GetPlotSpawnTarget();
        u11:ShowAnimatedMessage("Go to your Pen!", u1);

        if v13 == nil then
            u11:ClearBeam();

            return;
        end;

        u11:UpdateBeamTarget(v13);
    end;

    local u14 = u12.Changed:Connect(refreshPresentation);
    refreshPresentation();

    return function() -- Line: 82
        -- upvalues: u14 (copy), u11 (copy)
        u14:Disconnect();
        u11:ClearAll();
    end;
end;

return u3;