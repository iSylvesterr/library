-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
require(ReplicatedStorage.Library.Client.GuardTutorialPresentationComponent);
require(script.Parent.Types.Interface);
local SurfaceGuiButton = require(ReplicatedStorage.Library.Client.UI.SurfaceGuiButton);
local u1 = Color3.fromRGB(255, 255, 255);
local u2 = {
    StepId = "ExpandPen"
};

local function shouldPresent(p3) -- Line: 31
    local v4 = p3:CanAffordFirstBaseExpansion() and not p3:IsLocalPlayerInGameplay();

    return v4;
end;

function u2.IsSatisfied(p5) -- Line: 39
    return p5:HasFinishedFirstBaseExpansion();
end;

function u2.Bind(u6, u7) -- Line: 43
    -- upvalues: u2 (copy), RunService (copy)
    local u8 = 0;
    local u9 = false;

    local function refresh() -- Line: 47
        -- upvalues: u9 (ref), u2 (ref), u6 (copy), u7 (copy)
        if u9 or not u2.IsSatisfied(u6) then
            return;
        end;

        u9 = true;
        u7();
    end;

    local u10 = u6.Changed:Connect(refresh);
    local u12 = RunService.Heartbeat:Connect(function(p11) -- Line: 56
        -- upvalues: u8 (ref), u9 (ref), u2 (ref), u6 (copy), u7 (copy)
        u8 = u8 + p11;

        if u8 >= 0.1 then
            u8 = 0;

            if not u9 then
                if not u2.IsSatisfied(u6) then
                    return;
                end;

                u9 = true;
                u7();
            end;
        end;
    end);
    task.defer(refresh);

    return function() -- Line: 65
        -- upvalues: u10 (copy), u12 (copy)
        u10:Disconnect();
        u12:Disconnect();
    end;
end;

function u2.Present(u13, u14) -- Line: 71
    -- upvalues: u2 (copy), SurfaceGuiButton (copy), u1 (copy), RunService (copy)
    local u15 = 0;
    local u16 = false;
    local u17 = false;
    local u18 = nil;

    local function clear() -- Line: 80
        -- upvalues: u16 (ref), u17 (ref), u18 (ref), u13 (copy)
        if not u16 then
            return;
        end;

        u16 = false;
        u17 = false;
        u18 = nil;
        u13:ClearAll();
    end;

    local function u24() -- Line: 90
        -- upvalues: u2 (ref), u14 (copy), u16 (ref), u17 (ref), u18 (ref), u13 (copy), SurfaceGuiButton (ref), u1 (ref)
        if not u2.IsSatisfied(u14) then
            local v19 = u14;
            local v20 = v19:CanAffordFirstBaseExpansion() and not v19:IsLocalPlayerInGameplay();

            if v20 then
                local v21 = u14:GetPlotUpgradeSignTarget();

                if v21 == nil then
                    if not u16 then
                        return;
                    end;

                    u16 = false;
                    u17 = false;
                    u18 = nil;
                    u13:ClearAll();

                    return;
                end;

                if u16 and u18 == v21 then
                    if not u17 then
                        local v22 = SurfaceGuiButton.Get(v21, "FirstUpgrade");

                        if v22 ~= nil then
                            u13:ShowTap(v22, true);
                            u17 = true;
                        end;
                    end;

                    return;
                end;

                u16 = true;
                u18 = v21;
                u13:ShowAnimatedMessage("Upgrade your Pen!", u1);
                u13:ShowBeam(v21.Position + Vector3.new(0, -1, 0));
                local v23 = SurfaceGuiButton.Get(v21, "FirstUpgrade");

                if v23 ~= nil then
                    u13:ShowTap(v23, true);
                    u17 = true;
                end;

                return;
            end;
        end;

        if not u16 then
            return;
        end;

        u16 = false;
        u17 = false;
        u18 = nil;
        u13:ClearAll();
    end;

    local u25 = u14.Changed:Connect(u24);
    local u27 = RunService.Heartbeat:Connect(function(p26) -- Line: 124
        -- upvalues: u15 (ref), u24 (copy)
        u15 = u15 + p26;

        if u15 >= 0.1 then
            u15 = 0;
            u24();
        end;
    end);
    u24();

    return function() -- Line: 133
        -- upvalues: u25 (copy), u27 (copy), u16 (ref), u17 (ref), u18 (ref), u13 (copy)
        u25:Disconnect();
        u27:Disconnect();

        if not u16 then
            return;
        end;

        u16 = false;
        u17 = false;
        u18 = nil;
        u13:ClearAll();
    end;
end;

return u2;