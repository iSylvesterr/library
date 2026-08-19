-- Decompiled with Potassium's decompiler.

if not script.Parent:IsA("Actor") then
    return;
end;

local Event = script.Parent.Event;
local RunService = game:GetService("RunService");
local SmartBone = game:GetService("ReplicatedStorage").Library.Modules.Packages._Index.old_smartbone.SmartBone;
local Dependencies = SmartBone:WaitForChild("Dependencies");
local Config = require(Dependencies:WaitForChild("Config"));
local u1 = require(SmartBone);
local CameraUtil = require(Dependencies:WaitForChild("CameraUtil"));
local Debug = Config.Debug;
local clock = os.clock;
local u2 = clock();
local u3 = 60;
local u4 = {};

local function roundNumber(p5) -- Line: 38
    return math.floor(p5 * 1000 + 0.5) / 1000;
end;

local function smoothDelta() -- Line: 42
    -- upvalues: clock (copy), u4 (copy), u3 (ref), u2 (copy)
    local v6 = clock();

    for i = #u4, 1, -1 do
        local v7;

        if u4[i] >= v6 - 1 then
            v7 = u4[i] or nil;
        else
            v7 = nil;
        end;

        u4[i + 1] = v7;
    end;

    u4[1] = v6;
    local v8 = clock() - u2 >= 1 and #u4 or #u4 / (clock() - u2);
    u3 = math.floor(v8);

    return math.floor((u3 * (1 / u3) ^ 2 + 0.001) * 1000 + 0.5) / 1000;
end;

local function Initialize(p9, p10) -- Line: 56
    -- upvalues: u1 (copy), RunService (copy), smoothDelta (copy), CameraUtil (copy), Debug (copy)
    local u11 = u1.new(p9, p10);
    local u12 = 0;
    u11.SimulationConnection = RunService.Heartbeat:ConnectParallel(function(p13) -- Line: 61
        -- upvalues: smoothDelta (ref), u12 (ref), u11 (copy), CameraUtil (ref), Debug (ref)
        local v14 = smoothDelta();
        u12 = u12 + v14;
        local Magnitude = (workspace.CurrentCamera.CFrame.Position - u11.RootPart.Position).Magnitude;
        local ActivationDistance = u11.Settings.ActivationDistance;
        local v15 = math.clamp(Magnitude - u11.Settings.ThrottleDistance, 0, ActivationDistance) / ActivationDistance;
        local v16 = (1 - math.clamp(v15, 0, 1)) * u11.Settings.UpdateRate;
        local v17 = math.clamp(v16, 1, u11.Settings.UpdateRate);
        local v18 = math.floor(v17);
        local v19 = CameraUtil.WithinViewport(u11.RootPart);

        if u12 >= 1 / v18 then
            if Magnitude < ActivationDistance and v19 then
                local v20 = u12;
                u12 = 0;
                debug.profilebegin("SoftBone");

                if u11.InRange == false then
                    u11.InRange = true;
                end;

                u11:UpdateBones(v20, v18);
                debug.profileend();
                task.synchronize();
                debug.profilebegin("SoftBoneTransform");

                for _, v in u11.ParticleTrees do
                    u11:TransformBones(v, v20);

                    if Debug then
                        u11:DEBUG(v, v20);
                    end;
                end;

                debug.profileend();
                task.desynchronize();

                return;
            end;

            if u11.InRange == true then
                u11.InRange = false;

                for _, v in u11.ParticleTrees do
                    u11:ResetParticles(v);
                end;

                task.synchronize();

                for _, v in u11.ParticleTrees do
                    u11:ResetTransforms(v, v14);
                end;

                task.desynchronize();
            end;
        end;
    end);

    return u11;
end;

function Event.OnInvoke(p21, p22) -- Line: 133
    -- upvalues: u1 (copy), RunService (copy), smoothDelta (copy), CameraUtil (copy), Debug (copy)
    local u23 = u1.new(p21, p22);
    local u24 = 0;
    u23.SimulationConnection = RunService.Heartbeat:ConnectParallel(function(p25) -- Line: 61
        -- upvalues: smoothDelta (ref), u24 (ref), u23 (copy), CameraUtil (ref), Debug (ref)
        local v26 = smoothDelta();
        u24 = u24 + v26;
        local Magnitude = (workspace.CurrentCamera.CFrame.Position - u23.RootPart.Position).Magnitude;
        local ActivationDistance = u23.Settings.ActivationDistance;
        local v27 = math.clamp(Magnitude - u23.Settings.ThrottleDistance, 0, ActivationDistance) / ActivationDistance;
        local v28 = (1 - math.clamp(v27, 0, 1)) * u23.Settings.UpdateRate;
        local v29 = math.clamp(v28, 1, u23.Settings.UpdateRate);
        local v30 = math.floor(v29);
        local v31 = CameraUtil.WithinViewport(u23.RootPart);

        if u24 >= 1 / v30 then
            if Magnitude < ActivationDistance and v31 then
                local v32 = u24;
                u24 = 0;
                debug.profilebegin("SoftBone");

                if u23.InRange == false then
                    u23.InRange = true;
                end;

                u23:UpdateBones(v32, v30);
                debug.profileend();
                task.synchronize();
                debug.profilebegin("SoftBoneTransform");

                for _, v in u23.ParticleTrees do
                    u23:TransformBones(v, v32);

                    if Debug then
                        u23:DEBUG(v, v32);
                    end;
                end;

                debug.profileend();
                task.desynchronize();

                return;
            end;

            if u23.InRange == true then
                u23.InRange = false;

                for _, v in u23.ParticleTrees do
                    u23:ResetParticles(v);
                end;

                task.synchronize();

                for _, v in u23.ParticleTrees do
                    u23:ResetTransforms(v, v26);
                end;

                task.desynchronize();
            end;
        end;
    end);

    return u23;
end;