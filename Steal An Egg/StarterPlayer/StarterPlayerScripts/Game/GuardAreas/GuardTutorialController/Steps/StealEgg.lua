-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
require(ReplicatedStorage.Library.Client.GuardTutorialPresentationComponent);
require(script.Parent.Types.Interface);
local u1 = Color3.fromRGB(255, 255, 255);
local u4 = {
    StepId = "StealEgg",

    IsSatisfied = function(p2) -- Line: 25, Name: IsSatisfied
        local v3 = p2:HasStolenFirstEgg() and not p2:IsLocalPlayerInGameplay();

        return v3;
    end
};

function u4.Bind(u5, u6) -- Line: 29
    -- upvalues: u4 (copy), RunService (copy)
    local u7 = 0;
    local u8 = false;

    local function refresh() -- Line: 33
        -- upvalues: u8 (ref), u4 (ref), u5 (copy), u6 (copy)
        if u8 or not u4.IsSatisfied(u5) then
            return;
        end;

        u8 = true;
        u6();
    end;

    local u9 = u5.Changed:Connect(refresh);
    local u11 = RunService.Heartbeat:Connect(function(p10) -- Line: 43
        -- upvalues: u7 (ref), u8 (ref), u4 (ref), u5 (copy), u6 (copy)
        u7 = u7 + p10;

        if u7 < 0.1 then
            return;
        end;

        u7 = 0;

        if not u8 then
            if not u4.IsSatisfied(u5) then
                return;
            end;

            u8 = true;
            u6();
        end;
    end);
    task.defer(refresh);

    return function() -- Line: 54
        -- upvalues: u9 (copy), u11 (copy)
        u9:Disconnect();
        u11:Disconnect();
    end;
end;

function u4.Present(u12, u13) -- Line: 60
    -- upvalues: u4 (copy), u1 (copy), RunService (copy)
    local function refreshPresentation() -- Line: 64
        -- upvalues: u4 (ref), u13 (copy), u12 (copy), u1 (ref)
        if u4.IsSatisfied(u13) then
            u12:ClearAll();

            return;
        end;

        if u13:IsCarryingAreaEgg() or u13:HasStolenFirstEgg() then
            u12:ClearMessage();
            u12:UpdateBeamTarget(u13:GetGameplayExitTarget());

            return;
        end;

        local v14 = u13:GetClosestAreaEggTarget();

        if v14 == nil then
            u12:ClearBeam();
            u12:ShowAnimatedMessage("Steal an Egg!", u1);

            return;
        end;

        u12:ShowAnimatedMessage("Steal an Egg!", u1);
        u12:UpdateBeamTarget(v14);
    end;

    local function refreshMovingExitTarget() -- Line: 87
        -- upvalues: u4 (ref), u13 (copy), u12 (copy)
        if u4.IsSatisfied(u13) then
            u12:ClearAll();

            return;
        end;

        if not (u13:IsCarryingAreaEgg() or u13:HasStolenFirstEgg()) then
            return;
        end;

        u12:ClearMessage();
        u12:UpdateBeamTarget(u13:GetGameplayExitTarget());
    end;

    local u15 = u13.Changed:Connect(refreshPresentation);
    local u16 = 0;
    local u18 = RunService.Heartbeat:Connect(function(p17) -- Line: 103
        -- upvalues: u16 (ref), refreshMovingExitTarget (copy)
        u16 = u16 + p17;

        if u16 < 0.1 then
            return;
        end;

        u16 = 0;
        refreshMovingExitTarget();
    end);
    refreshPresentation();

    return function() -- Line: 114
        -- upvalues: u15 (copy), u18 (copy), u12 (copy)
        u15:Disconnect();
        u18:Disconnect();
        u12:ClearAll();
    end;
end;

return u4;