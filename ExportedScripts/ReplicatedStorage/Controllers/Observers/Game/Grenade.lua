-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
game:GetService("UserInputService");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GrenadeSimulator = require(ReplicatedStorage.Shared.GrenadeSimulator);
local Debris = workspace:WaitForChild("Debris");
local u1 = {};

for _, child in ipairs(script.Executions:GetChildren()) do
    u1[child.Name] = require(child);
end;

local u2 = {};

local function createRaycastParams(p3, p4) -- Line: 65
    -- upvalues: Debris (copy), LocalPlayer (copy)
    local v5 = RaycastParams.new();
    v5.FilterType = Enum.RaycastFilterType.Exclude;
    local v6 = { p3, Debris };

    if LocalPlayer and LocalPlayer.Character then
        table.insert(v6, LocalPlayer.Character);
    end;

    v5.FilterDescendantsInstances = v6;
    v5.RespectCanCollide = false;
    v5.IgnoreWater = true;

    if p4 then
        v5.CollisionGroup = p4;
    end;

    return v5;
end;

local function startClientPrediction(u7) -- Line: 84
    -- upvalues: RunServiceController (copy), GrenadeSimulator (copy)
    local u8 = nil;
    u8 = RunServiceController.BindToRenderStep(`Observers.Game.Grenade.{u7.id}.Predict`, function(p9) -- Line: 86
        -- upvalues: u7 (copy), u8 (ref), GrenadeSimulator (ref)
        if u7.isResolved then
            u8:Disconnect();

            return;
        end;

        if not u7.model.Parent then
            u8:Disconnect();
            u7.isResolved = true;

            return;
        end;

        u7.state = GrenadeSimulator.simulate(u7.state, u7.config, u7.raycastParams, p9).state;
        local v10 = math.min(1, p9 * 20);
        u7.visualPosition = u7.visualPosition:Lerp(u7.state.position, v10);
        local Magnitude = u7.state.velocity.Magnitude;

        if Magnitude < 2 then
            u7.angularVelocity = u7.angularVelocity * math.max(0, 1 - p9 * 8);
        elseif Magnitude < 5 then
            u7.angularVelocity = u7.angularVelocity * math.max(0, 1 - p9 * 3);
        end;

        if u7.angularVelocity.Magnitude > 0.01 then
            local angularVelocity = u7.angularVelocity;
            local v11 = CFrame.fromAxisAngle(angularVelocity.Unit, angularVelocity.Magnitude * p9);
            u7.visualRotation = u7.visualRotation * v11;
        end;

        if u7.model.PrimaryPart then
            u7.model:PivotTo(CFrame.new(u7.visualPosition) * u7.visualRotation);
        end;
    end);
    u7.janitor:Add(u8, "Disconnect");
end;

local function reconcileState(p12, p13, p14) -- Line: 139
    local Magnitude = (p12.state.position - p13).Magnitude;

    if Magnitude <= 8 then
        if Magnitude > 2 then
            p12.state.position = p12.state.position:Lerp(p13, 0.08);
            p12.state.velocity = p12.state.velocity:Lerp(p14, 0.08);
        end;

        return;
    end;

    p12.state.position = p13;
    p12.state.velocity = p14;
    p12.visualPosition = p13;
end;

Remotes.Projectile.Spawn.Listen(function(u15) -- Line: 160
    -- upvalues: ReplicatedStorage (copy), Debris (copy), Janitor (copy), createRaycastParams (copy), u2 (copy), RunServiceController (copy), GrenadeSimulator (copy)
    local Id = u15.Id;
    local State = u15.State;
    local Physics = u15.Physics;
    task.defer(function() -- Line: 166
        -- upvalues: ReplicatedStorage (ref), u15 (copy), Id (copy), State (copy), Debris (ref), Janitor (ref), Physics (copy), createRaycastParams (ref), u2 (ref), RunServiceController (ref), GrenadeSimulator (ref)
        local v16 = ReplicatedStorage.Assets.Weapons:FindFirstChild(u15.Weapon);

        if v16 then
            v16 = v16:FindFirstChild("Character");
        end;

        if not v16 then
            warn("[Client Grenade] Base model not found for:", u15.Weapon);

            return;
        end;

        local v17 = v16:Clone();
        v17.Name = Id;
        v17:PivotTo(CFrame.new(State.Position));
        v17:SetAttribute("GrenadeName", u15.Weapon);
        v17:AddTag("Grenade");
        v17.Parent = Debris;

        for _, descendant in v17:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true;
                descendant.CanCollide = false;
            end;
        end;

        local v18 = Janitor.new();
        v18:Add(v17, "Destroy");
        local v19 = {
            angularVelocity = Vector3.new(0, 0, 0),
            simulationTime = 0,
            bounceCount = 0,
            isGrounded = false,
            isAtRest = false,
            hasTouched = false,
            accumulatedTime = 0,
            position = State.Position,
            velocity = State.Velocity,
            timestamp = State.StartTime or workspace:GetServerTimeNow(),
            isJumpThrow = State.IsJumpThrow or false
        };
        local v20 = u15.Weapon == "Molotov" and true or u15.Weapon == "Incendiary Grenade";
        local v21 = {
            rangeScale = 1,
            isNearThrow = false,
            radius = Physics.Radius,
            restitution = Physics.Restitution,
            maxBounces = Physics.MaxBounces
        };
        local v22;

        if Physics.FuseTime > 0 then
            v22 = Physics.FuseTime;
        else
            v22 = nil;
        end;

        v21.fuseTime = v22;
        v21.minimumFuseTime = v20 and 0.1 or nil;
        v21.explodeOnFloorImpact = v20 and true or nil;
        local Velocity = State.Velocity;
        local v23;

        if Velocity.Magnitude > 1 then
            local v24 = Velocity:Cross(Vector3.new(0, 1, 0));
            v23 = (v24.Magnitude <= 0.1 and Vector3.new(1, 0, 0) or v24.Unit) * Velocity.Magnitude * 0.5;
        else
            v23 = Vector3.new(0, 0, 0);
        end;

        local u25 = {
            isResolved = false,
            id = Id,
            model = v17,
            state = v19,
            config = v21,
            raycastParams = createRaycastParams(v17, Physics.CollisionGroup),
            visualPosition = State.Position,
            visualRotation = CFrame.identity,
            angularVelocity = v23,
            janitor = v18
        };
        u2[Id] = u25;
        local u26 = nil;
        u26 = RunServiceController.BindToRenderStep(`Observers.Game.Grenade.{u25.id}.Predict`, function(p27) -- Line: 86
            -- upvalues: u25 (copy), u26 (ref), GrenadeSimulator (ref)
            if u25.isResolved then
                u26:Disconnect();

                return;
            end;

            if not u25.model.Parent then
                u26:Disconnect();
                u25.isResolved = true;

                return;
            end;

            u25.state = GrenadeSimulator.simulate(u25.state, u25.config, u25.raycastParams, p27).state;
            local v28 = math.min(1, p27 * 20);
            u25.visualPosition = u25.visualPosition:Lerp(u25.state.position, v28);
            local Magnitude = u25.state.velocity.Magnitude;

            if Magnitude < 2 then
                u25.angularVelocity = u25.angularVelocity * math.max(0, 1 - p27 * 8);
            elseif Magnitude < 5 then
                u25.angularVelocity = u25.angularVelocity * math.max(0, 1 - p27 * 3);
            end;

            if u25.angularVelocity.Magnitude > 0.01 then
                local angularVelocity = u25.angularVelocity;
                local v29 = CFrame.fromAxisAngle(angularVelocity.Unit, angularVelocity.Magnitude * p27);
                u25.visualRotation = u25.visualRotation * v29;
            end;

            if u25.model.PrimaryPart then
                u25.model:PivotTo(CFrame.new(u25.visualPosition) * u25.visualRotation);
            end;
        end);
        u25.janitor:Add(u26, "Disconnect");
    end);
end);
Remotes.Projectile.Bounce.Listen(function(p30) -- Line: 259
    -- upvalues: u2 (copy), reconcileState (copy)
    local v31 = u2[p30.Id];

    if not v31 then
        return;
    end;

    reconcileState(v31, p30.Position, p30.Velocity);
    v31.state.bounceCount = p30.BounceIndex;
    v31.state.hasTouched = true;
    local Velocity = p30.Velocity;
    local v32 = Velocity - v31.state.velocity;

    if v32.Magnitude > 1 then
        local v33 = v32:Cross(Velocity);
        local v34;

        if v33.Magnitude > 0.1 then
            v34 = v33.Unit;
        else
            local v35 = Velocity:Cross(Vector3.new(0, 1, 0));
            v34 = v35.Magnitude <= 0.1 and Vector3.new(1, 0, 0) or v35.Unit;
        end;

        v31.angularVelocity = v31.angularVelocity + v34 * v32.Magnitude * 0.5;
    end;
end);
Remotes.Projectile.Resolve.Listen(function(p36) -- Line: 298
    -- upvalues: u2 (copy)
    local v37 = u2[p36.Id];

    if not v37 then
        return;
    end;

    v37.state.position = p36.Position;
    v37.state.isAtRest = true;
    v37.isResolved = true;
    v37.angularVelocity = Vector3.new(0, 0, 0);

    if v37.model.PrimaryPart then
        v37.model:PivotTo(CFrame.new(p36.Position) * v37.visualRotation);
    end;

    v37.model:SetAttribute("SimulationFinished", true);
    u2[p36.Id] = nil;
end);

return Observers.observeTag("Grenade", function(u38) -- Line: 325
    -- upvalues: u1 (copy), Janitor (copy), u2 (copy)
    local v39 = u38:GetAttribute("GrenadeName");

    if v39 then
        local u40 = u1[v39];
        local u41 = Janitor.new();
        u41:Add(u38:GetAttributeChangedSignal("SimulationFinished"):Connect(function() -- Line: 339
            -- upvalues: u38 (copy), u40 (copy), u41 (copy)
            local PrimaryPart = u38.PrimaryPart;

            if PrimaryPart and u38:GetAttribute("SimulationFinished") then
                if u40 then
                    u40(u41, PrimaryPart.Position, u38);

                    return;
                end;

                for _, descendant in u38:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.Transparency = 1;
                        descendant.CanCollide = false;
                    end;
                end;

                task.delay(0.5, function() -- Line: 354
                    -- upvalues: u38 (ref)
                    if u38 and u38.Parent then
                        u38:Destroy();
                    end;
                end);
            end;
        end));

        return function() -- Line: 364
            -- upvalues: u38 (copy), u2 (ref), u41 (copy)
            local Name = u38.Name;

            if u2[Name] then
                u2[Name].isResolved = true;
                u2[Name] = nil;
            end;

            u41:Destroy();
        end;
    end;
end);