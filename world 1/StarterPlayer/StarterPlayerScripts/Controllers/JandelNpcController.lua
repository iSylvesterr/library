-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local v1 = {};
local u2 = {};

local function loadRig(p3) -- Line: 36
    local v4 = p3:FindFirstChildOfClass("Humanoid");

    if not v4 then
        warn((`[JandelNpcController] "{p3.Name}" is tagged JandelNpc but has no Humanoid`));

        return nil;
    end;

    local u5 = v4:FindFirstChildOfClass("Animator");

    if not u5 then
        u5 = Instance.new("Animator");
        u5.Parent = v4;
    end;

    local v6 = {};
    local Animations = p3:FindFirstChild("Animations");

    if Animations then
        for _, child in Animations:GetChildren() do
            if child:IsA("Animation") then
                local success, result = pcall(function() -- Line: 56
                    -- upvalues: u5 (ref), child (copy)
                    return u5:LoadAnimation(child);
                end);

                if success and result then
                    v6[child.Name] = result;
                end;
            end;
        end;
    end;

    local v7 = {
        Model = p3,
        Animator = u5,
        Tracks = v6,
        Idle = v6.Idle
    };

    if v7.Idle then
        v7.Idle.Looped = true;
        v7.Idle:Play(0.2);
    end;

    return v7;
end;

local function bindRig(u8) -- Line: 81
    -- upvalues: u2 (copy), loadRig (copy)
    if u2[u8] then
        return;
    end;

    local v9 = loadRig(u8);

    if not v9 then
        return;
    end;

    u2[u8] = v9;
    u8.Destroying:Once(function() -- Line: 88
        -- upvalues: u2 (ref), u8 (copy)
        u2[u8] = nil;
    end);
end;

local function playOn(u10, p11) -- Line: 93
    local u12 = u10.Tracks[p11];

    if not u12 then
        return false;
    end;

    for _, v in u10.Tracks do
        if v ~= u12 and v.IsPlaying then
            v:Stop(0.2);
        end;
    end;

    if p11 == "Idle" then
        u12.Looped = true;
        u12:Play(0.2);

        return true;
    end;

    u12.Looped = false;
    u12:Play(0.2);

    if u10.Idle and u10.Idle ~= u12 then
        u12.Stopped:Once(function() -- Line: 115
            -- upvalues: u10 (copy), u12 (copy)
            local v13 = u10.Model.Parent and (not u12.IsPlaying and u10.Idle);

            if v13 then
                v13.Looped = true;
                v13:Play(0.2);
            end;
        end);
    end;

    return true;
end;

local function playAnimation(p14) -- Line: 129
    -- upvalues: u2 (copy), playOn (copy)
    local v15 = 0;

    for _, v in u2 do
        if v.Model.Parent and playOn(v, p14) then
            v15 = v15 + 1;
        end;
    end;

    if v15 == 0 then
        warn((`[JandelNpcController] no tagged NPC could play "{p14}"`));
    end;
end;

function v1.Start(p16) -- Line: 143
    -- upvalues: CollectionService (copy), u2 (copy), loadRig (copy), bindRig (copy), Networking (copy), playAnimation (copy)
    for _, v in CollectionService:GetTagged("JandelNpc") do
        if v:IsA("Model") then
            if not u2[v] then
                local v17 = loadRig(v);

                if v17 then
                    u2[v] = v17;
                    v.Destroying:Once(function() -- Line: 88
                        -- upvalues: u2 (ref), v (copy)
                        u2[v] = nil;
                    end);
                end;
            end;
        end;
    end;

    CollectionService:GetInstanceAddedSignal("JandelNpc"):Connect(function(p18) -- Line: 151
        -- upvalues: bindRig (ref)
        if p18:IsA("Model") then
            task.defer(bindRig, p18);
        end;
    end);
    CollectionService:GetInstanceRemovedSignal("JandelNpc"):Connect(function(p19) -- Line: 158
        -- upvalues: u2 (ref)
        if p19:IsA("Model") then
            u2[p19] = nil;
        end;
    end);
    Networking.Commentary.NpcAnimation.OnClientEvent:Connect(function(p20) -- Line: 164
        -- upvalues: playAnimation (ref)
        if type(p20) ~= "string" or p20 == "" then
            return;
        end;

        playAnimation(p20);
    end);
end;

return v1;