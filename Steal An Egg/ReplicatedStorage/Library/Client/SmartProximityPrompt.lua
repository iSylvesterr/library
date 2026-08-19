-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local Player = require(ReplicatedStorage.Library.Player);
local SurfaceTracker = require(script.SurfaceTracker);
local LocalPlayer = Players.LocalPlayer;
local u1 = {};
local u2 = nil;
local v3 = {};

local function getLocalPlayerPosition() -- Line: 49
    -- upvalues: Player (copy), LocalPlayer (copy)
    local v4 = Player.Optional.PrimaryPart(LocalPlayer);

    if v4 then
        return v4.Position;
    end;

    return nil;
end;

local function cleanupPrompt(p5) -- Line: 54
    -- upvalues: u1 (copy)
    local v6 = u1[p5];

    if v6 == nil then
        return;
    end;

    u1[p5] = nil;
    v6.Tracker:Destroy();
    v6.PromptPart:Destroy();
end;

local function updatePromptStates(p7) -- Line: 65
    -- upvalues: u1 (copy), u2 (ref), Player (copy), LocalPlayer (copy)
    if next(u1) == nil then
        local v8 = u2;

        if v8 ~= nil then
            v8:Disconnect();
            u2 = nil;
        end;

        return;
    end;

    local v9 = Player.Optional.PrimaryPart(LocalPlayer);
    local v10;

    if v9 then
        v10 = v9.Position;
    else
        v10 = nil;
    end;

    if v10 == nil then
        return;
    end;

    for i, v in pairs(u1) do
        if i.Parent == nil or (v.Model.Parent == nil or v.PromptPart.Parent == nil) then
            local v11 = u1[i];

            if v11 ~= nil then
                u1[i] = nil;
                v11.Tracker:Destroy();
                v11.PromptPart:Destroy();
            end;
        else
            local v12, v13 = v.Tracker:GetClosestSurfacePoint(v10, v.SurfaceOffset);

            if v12 ~= nil and (v13 ~= nil and v.TrackDistance >= v13) then
                local v14 = math.clamp(p7 * v.FollowSpeed, 0, 1);
                v.PromptPart.CFrame = CFrame.new(v.PromptPart.Position:Lerp(v12, v14));
            end;
        end;
    end;
end;

local function ensureHeartbeat() -- Line: 96
    -- upvalues: u2 (ref), RunService (copy), updatePromptStates (copy)
    if u2 ~= nil then
        return;
    end;

    u2 = RunService.Heartbeat:Connect(updatePromptStates);
end;

function v3.AttachToModel(u15, p16, p17) -- Line: 108
    -- upvalues: Workspace (copy), SurfaceTracker (copy), u1 (copy), u2 (ref), RunService (copy), updatePromptStates (copy)
    local v18 = "SmartPromptPart";
    local v19 = 0.75;
    local v20 = 18;
    local v21 = 7;
    local v22;

    if p17 == nil then
        v22 = nil;
    else
        v18 = p17.PartName or v18;
        v19 = p17.SurfaceOffset or v19;
        v20 = p17.FollowSpeed or v20;
        v21 = p17.TrackDistance or v21;
        v22 = p17.MaxActivationDistance;
    end;

    if v22 ~= nil then
        u15.MaxActivationDistance = v22;
    end;

    local v23 = math.max(v21, u15.MaxActivationDistance);
    local Part = Instance.new("Part");
    Part.Name = v18;
    Part.Size = Vector3.new(1, 1, 1);
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanTouch = false;
    Part.CanQuery = false;
    Part.CFrame = p16:GetPivot();
    Part.Parent = Workspace;
    local v24 = SurfaceTracker.new(p16, Part);
    u15.RequiresLineOfSight = false;
    u15.Parent = Part;
    u1[u15] = {
        Model = p16,
        PromptPart = Part,
        Tracker = v24,
        SurfaceOffset = v19,
        FollowSpeed = v20,
        TrackDistance = v23
    };

    if u2 == nil then
        u2 = RunService.Heartbeat:Connect(updatePromptStates);
    end;

    local u27 = u15.Destroying:Once(function() -- Line: 151
        -- upvalues: u15 (copy), u1 (ref)
        local v25 = u15;
        local v26 = u1[v25];

        if v26 == nil then
            return;
        end;

        u1[v25] = nil;
        v26.Tracker:Destroy();
        v26.PromptPart:Destroy();
    end);
    local u30 = p16.Destroying:Once(function() -- Line: 154
        -- upvalues: u15 (copy), u1 (ref)
        local v28 = u15;
        local v29 = u1[v28];

        if v29 == nil then
            return;
        end;

        u1[v28] = nil;
        v29.Tracker:Destroy();
        v29.PromptPart:Destroy();
    end);

    return function() -- Line: 158
        -- upvalues: u27 (copy), u30 (copy), u15 (copy), u1 (ref)
        u27:Disconnect();
        u30:Disconnect();
        local v31 = u15;
        local v32 = u1[v31];

        if v32 == nil then
            return;
        end;

        u1[v31] = nil;
        v32.Tracker:Destroy();
        v32.PromptPart:Destroy();
    end;
end;

return v3;