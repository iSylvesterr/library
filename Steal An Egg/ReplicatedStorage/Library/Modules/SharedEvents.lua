-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = 0;
local u2 = {};
local u3 = {};

local function pushPartCFrame(p4, p5) -- Line: 10
    -- upvalues: u1 (ref), u2 (copy), u3 (copy)
    u1 = u1 + 1;
    u2[u1] = p4;
    u3[u1] = p5;

    return nil;
end;

local function stepParts() -- Line: 17
    -- upvalues: u2 (copy), u3 (copy), u1 (ref)
    debug.profilebegin("SharedEventUtils:StepParts");
    workspace:BulkMoveTo(u2, u3, Enum.BulkMoveMode.FireCFrameChanged);
    u1 = 0;
    table.clear(u2);
    table.clear(u3);
    debug.profileend();

    return nil;
end;

local function loadAnimation(u6, p7, p8) -- Line: 27
    local u9 = p7:LoadAnimation(p8);

    local function cleanup() -- Line: 29
        -- upvalues: u9 (copy)
        u9:Stop(0);
        u9:Destroy();
    end;

    u6:Add(cleanup);

    return u9, function() -- Line: 34
        -- upvalues: u6 (copy), cleanup (copy)
        u6:Remove(cleanup);
    end;
end;

if RunService:IsServer() then
    RunService.PostSimulation:Connect(stepParts);
else
    RunService.PreRender:Connect(stepParts);
end;

return {
    pushPartCFrame = pushPartCFrame,
    loadAnimation = loadAnimation
};