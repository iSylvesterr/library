-- Decompiled with Potassium's decompiler.

local u1 = {
    TIME_VARIANCE = 0.07,
    COMPARISON_CHECKS = 1,
    JUMP_WHEN_STUCK = true
};
local PathfindingService = game:GetService("PathfindingService");
local Players = game:GetService("Players");

local function output(p2, p3) -- Line: 20
    p2((p2 == error and "SimplePath Error: " or "SimplePath: ") .. p3);
end;

local u4 = {
    StatusType = {
        Idle = "Idle",
        Active = "Active"
    },
    ErrorType = {
        LimitReached = "LimitReached",
        TargetUnreachable = "TargetUnreachable",
        ComputationError = "ComputationError",
        AgentStuck = "AgentStuck"
    }
};

function u4.__index(p5, p6) -- Line: 36
    -- upvalues: u4 (copy)
    if p6 == "Stopped" and not p5._humanoid then
        local v7 = error;
        v7((v7 == error and "SimplePath Error: " or "SimplePath: ") .. "Attempt to use Path.Stopped on a non-humanoid.");
    end;

    return p5._events[p6] and p5._events[p6].Event or p6 == "LastError" and p5._lastError or (p6 == "Status" and p5._status or u4[p6]);
end;

local Part = Instance.new("Part");
Part.Size = Vector3.new(0.3, 0.3, 0.3);
Part.Anchored = true;
Part.CanCollide = false;
Part.Material = Enum.Material.Neon;
Part.Shape = Enum.PartType.Ball;

local function declareError(p8, p9) -- Line: 56
    p8._lastError = p9;
    p8._events.Error:Fire(p9);
end;

local function createVisualWaypoints(p10) -- Line: 62
    -- upvalues: Part (copy)
    local v11 = {};

    for _, v in ipairs(p10) do
        local v12 = Part:Clone();
        v12.Position = v.Position;
        v12.Parent = workspace;
        v12.Color = v == p10[#p10] and Color3.fromRGB(0, 255, 0) or (v.Action == Enum.PathWaypointAction.Jump and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 139, 0));
        table.insert(v11, v12);
    end;

    return v11;
end;

local function destroyVisualWaypoints(p13) -- Line: 77
    if p13 then
        for _, v in ipairs(p13) do
            v:Destroy();
        end;
    end;
end;

local function getNonHumanoidWaypoint(p14) -- Line: 87
    for i = 2, #p14._waypoints do
        if (p14._waypoints[i].Position - p14._waypoints[i - 1].Position).Magnitude > 0.1 then
            return i;
        end;
    end;

    return 2;
end;

local function setJumpState(u15) -- Line: 98
    pcall(function() -- Line: 99
        -- upvalues: u15 (copy)
        if u15._humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and u15._humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
            u15._humanoid:ChangeState(Enum.HumanoidStateType.Jumping);
        end;
    end);
end;

local function move(u16) -- Line: 110
    if u16._waypoints[u16._currentWaypoint].Action == Enum.PathWaypointAction.Jump then
        pcall(function() -- Line: 99
            -- upvalues: u16 (copy)
            if u16._humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and u16._humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
                u16._humanoid:ChangeState(Enum.HumanoidStateType.Jumping);
            end;
        end);
    end;

    u16._humanoid:MoveTo(u16._waypoints[u16._currentWaypoint].Position);
end;

local function disconnectMoveConnection(p17) -- Line: 118
    p17._moveConnection:Disconnect();
    p17._moveConnection = nil;
end;

local function invokeWaypointReached(p18) -- Line: 124
    p18._events.WaypointReached:Fire(p18._agent, p18._waypoints[p18._currentWaypoint - 1], p18._waypoints[p18._currentWaypoint]);
end;

local function moveToFinished(u19, p20) -- Line: 130
    -- upvalues: u4 (copy)
    if not getmetatable(u19) then
        return;
    end;

    if not u19._humanoid then
        if p20 and u19._currentWaypoint + 1 <= #u19._waypoints then
            u19._events.WaypointReached:Fire(u19._agent, u19._waypoints[u19._currentWaypoint - 1], u19._waypoints[u19._currentWaypoint]);
            u19._currentWaypoint = u19._currentWaypoint + 1;

            return;
        end;

        if p20 then
            local _visualWaypoints = u19._visualWaypoints;

            if _visualWaypoints then
                for _, v in ipairs(_visualWaypoints) do
                    v:Destroy();
                end;
            end;

            u19._visualWaypoints = nil;
            u19._target = nil;
            u19._events.Reached:Fire(u19._agent, u19._waypoints[u19._currentWaypoint]);

            return;
        end;

        local _visualWaypoints = u19._visualWaypoints;

        if _visualWaypoints then
            for _, v in ipairs(_visualWaypoints) do
                v:Destroy();
            end;
        end;

        u19._visualWaypoints = nil;
        u19._target = nil;
        local TargetUnreachable = u19.ErrorType.TargetUnreachable;
        u19._lastError = TargetUnreachable;
        u19._events.Error:Fire(TargetUnreachable);

        return;
    end;

    if p20 and u19._currentWaypoint + 1 <= #u19._waypoints then
        if u19._currentWaypoint + 1 < #u19._waypoints then
            u19._events.WaypointReached:Fire(u19._agent, u19._waypoints[u19._currentWaypoint - 1], u19._waypoints[u19._currentWaypoint]);
        end;

        u19._currentWaypoint = u19._currentWaypoint + 1;

        if u19._waypoints[u19._currentWaypoint].Action == Enum.PathWaypointAction.Jump then
            pcall(function() -- Line: 99
                -- upvalues: u19 (copy)
                if u19._humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and u19._humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
                    u19._humanoid:ChangeState(Enum.HumanoidStateType.Jumping);
                end;
            end);
        end;

        u19._humanoid:MoveTo(u19._waypoints[u19._currentWaypoint].Position);

        return;
    end;

    if p20 then
        u19._moveConnection:Disconnect();
        u19._moveConnection = nil;
        u19._status = u4.StatusType.Idle;
        local _visualWaypoints = u19._visualWaypoints;

        if _visualWaypoints then
            for _, v in ipairs(_visualWaypoints) do
                v:Destroy();
            end;
        end;

        u19._visualWaypoints = nil;
        u19._events.Reached:Fire(u19._agent, u19._waypoints[u19._currentWaypoint]);

        return;
    end;

    u19._moveConnection:Disconnect();
    u19._moveConnection = nil;
    u19._status = u4.StatusType.Idle;
    local _visualWaypoints = u19._visualWaypoints;

    if _visualWaypoints then
        for _, v in ipairs(_visualWaypoints) do
            v:Destroy();
        end;
    end;

    u19._visualWaypoints = nil;
    local TargetUnreachable = u19.ErrorType.TargetUnreachable;
    u19._lastError = TargetUnreachable;
    u19._events.Error:Fire(TargetUnreachable);
end;

local function comparePosition(u21) -- Line: 173
    if u21._currentWaypoint == #u21._waypoints then
        return;
    end;

    u21._position._count = (u21._agent.PrimaryPart.Position - u21._position._last).Magnitude <= 0.07 and (u21._position._count + 1 or 0) or 0;
    u21._position._last = u21._agent.PrimaryPart.Position;

    if u21._position._count >= u21._settings.COMPARISON_CHECKS then
        if u21._settings.JUMP_WHEN_STUCK then
            pcall(function() -- Line: 99
                -- upvalues: u21 (copy)
                if u21._humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and u21._humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
                    u21._humanoid:ChangeState(Enum.HumanoidStateType.Jumping);
                end;
            end);
        end;

        local AgentStuck = u21.ErrorType.AgentStuck;
        u21._lastError = AgentStuck;
        u21._events.Error:Fire(AgentStuck);
    end;
end;

function u4.GetState(p22) -- Line: 188
    return p22._status;
end;

function u4.GetNearestCharacter(p23) -- Line: 193
    -- upvalues: Players (copy)
    local v24 = (1 / 0);
    local v25 = nil;

    for _, v in ipairs(Players:GetPlayers()) do
        if v.Character and (v.Character.PrimaryPart.Position - p23).Magnitude < v24 then
            v25 = v.Character;
            v24 = (v.Character.PrimaryPart.Position - p23).Magnitude;
        end;
    end;

    return v25;
end;

function u4.new(p26, p27, p28) -- Line: 205
    -- upvalues: u1 (copy), PathfindingService (copy), u4 (copy)
    if not (p26 and (p26:IsA("Model") and p26.PrimaryPart)) then
        local v29 = error;
        v29((v29 == error and "SimplePath Error: " or "SimplePath: ") .. "Pathfinding agent must be a valid Model Instance with a set PrimaryPart.");
    end;

    local v30 = {
        _status = "Idle",
        _t = 0,
        _settings = p28 or u1,
        _events = {
            Reached = Instance.new("BindableEvent"),
            WaypointReached = Instance.new("BindableEvent"),
            Blocked = Instance.new("BindableEvent"),
            Error = Instance.new("BindableEvent"),
            Stopped = Instance.new("BindableEvent")
        },
        _agent = p26,
        _humanoid = p26:FindFirstChildOfClass("Humanoid"),
        _path = PathfindingService:CreatePath(p27),
        _position = {
            _count = 0,
            _last = Vector3.new()
        }
    };
    local u31 = setmetatable(v30, u4);

    for i, v in pairs(u1) do
        u31._settings[i] = u31._settings[i] == nil and v and v or u31._settings[i];
    end;

    u31._path.Blocked:Connect(function(...) -- Line: 236
        -- upvalues: u31 (copy)
        if u31._currentWaypoint and (... and (u31._currentWaypoint <= ... and (... <= u31._currentWaypoint + 1 and u31._humanoid))) then
            local u32 = u31;
            pcall(function() -- Line: 99
                -- upvalues: u32 (copy)
                if u32._humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and u32._humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
                    u32._humanoid:ChangeState(Enum.HumanoidStateType.Jumping);
                end;
            end);
            u31._events.Blocked:Fire(u31._agent, u31._waypoints[...]);
        end;
    end);

    return u31;
end;

function u4.Destroy(p33) -- Line: 250
    for _, v in ipairs(p33._events) do
        v:Destroy();
    end;

    p33._events = nil;

    if rawget(p33, "_visualWaypoints") then
        local _visualWaypoints = p33._visualWaypoints;

        if _visualWaypoints then
            for _, v in ipairs(_visualWaypoints) do
                v:Destroy();
            end;
        end;

        p33._visualWaypoints = nil;
    end;

    p33._path:Destroy();
    setmetatable(p33, nil);

    for i, _ in pairs(p33) do
        p33[i] = nil;
    end;
end;

function u4.Stop(p34) -- Line: 265
    -- upvalues: u4 (copy)
    if not p34._humanoid then
        local v35 = error;
        v35((v35 == error and "SimplePath Error: " or "SimplePath: ") .. "Attempt to call Path:Stop() on a non-humanoid.");

        return;
    end;

    if p34._status == u4.StatusType.Idle then
        warn(debug.traceback((function(p36) -- Line: 271
            warn(debug.traceback(p36));
        end == error and "SimplePath Error: " or "SimplePath: ") .. "Attempt to run Path:Stop() in idle state"));

        return;
    end;

    p34._moveConnection:Disconnect();
    p34._moveConnection = nil;
    p34._status = u4.StatusType.Idle;
    local _visualWaypoints = p34._visualWaypoints;

    if _visualWaypoints then
        for _, v in ipairs(_visualWaypoints) do
            v:Destroy();
        end;
    end;

    p34._visualWaypoints = nil;
    p34._events.Stopped:Fire(p34._model);
end;

function u4.Run(u37, u38) -- Line: 282
    -- upvalues: moveToFinished (copy), u4 (copy), comparePosition (copy), createVisualWaypoints (copy), getNonHumanoidWaypoint (copy)
    if u38 or (u37._humanoid or not u37._target) then
        if not u38 or typeof(u38) ~= "Vector3" and not u38:IsA("BasePart") then
            local v39 = error;
            v39((v39 == error and "SimplePath Error: " or "SimplePath: ") .. "Pathfinding target must be a valid Vector3 or BasePart.");
        end;

        if os.clock() - u37._t <= u37._settings.TIME_VARIANCE and u37._humanoid then
            task.wait(os.clock() - u37._t);
            local LimitReached = u37.ErrorType.LimitReached;
            u37._lastError = LimitReached;
            u37._events.Error:Fire(LimitReached);

            return false;
        end;

        if u37._humanoid then
            u37._t = os.clock();
        end;

        local success, _ = pcall(function() -- Line: 304
            -- upvalues: u37 (copy), u38 (copy)
            u37._path:ComputeAsync(u37._agent.PrimaryPart.Position, typeof(u38) == "Vector3" and u38 or u38.Position);
        end);

        if not success or (u37._path.Status == Enum.PathStatus.NoPath or (#u37._path:GetWaypoints() < 2 or u37._humanoid and u37._humanoid:GetState() == Enum.HumanoidStateType.Freefall)) then
            local _visualWaypoints = u37._visualWaypoints;

            if _visualWaypoints then
                for _, v in ipairs(_visualWaypoints) do
                    v:Destroy();
                end;
            end;

            u37._visualWaypoints = nil;
            task.wait();
            local ComputationError = u37.ErrorType.ComputationError;
            u37._lastError = ComputationError;
            u37._events.Error:Fire(ComputationError);

            return false;
        end;

        u37._status = u37._humanoid and u4.StatusType.Active or u4.StatusType.Idle;
        u37._target = u38;
        pcall(function() -- Line: 329
            -- upvalues: u37 (copy)
            u37._agent.PrimaryPart:SetNetworkOwner(nil);
        end);
        u37._waypoints = u37._path:GetWaypoints();
        u37._currentWaypoint = 2;

        if u37._humanoid then
            comparePosition(u37);
        end;

        local _visualWaypoints = u37._visualWaypoints;

        if _visualWaypoints then
            for _, v in ipairs(_visualWaypoints) do
                v:Destroy();
            end;
        end;

        local v40 = u37.Visualize and createVisualWaypoints(u37._waypoints);
        u37._visualWaypoints = v40;
        local v41 = u37._humanoid and (u37._moveConnection or u37._humanoid.MoveToFinished:Connect(function(...) -- Line: 350
            -- upvalues: moveToFinished (ref), u37 (copy)
            moveToFinished(u37, ...);
        end));
        u37._moveConnection = v41;

        if u37._humanoid then
            u37._humanoid:MoveTo(u37._waypoints[u37._currentWaypoint].Position);
        elseif #u37._waypoints == 2 then
            u37._target = nil;
            local _visualWaypoints2 = u37._visualWaypoints;

            if _visualWaypoints2 then
                for _, v in ipairs(_visualWaypoints2) do
                    v:Destroy();
                end;
            end;

            u37._visualWaypoints = nil;
            u37._events.Reached:Fire(u37._agent, u37._waypoints[2]);
        else
            u37._currentWaypoint = getNonHumanoidWaypoint(u37);
            moveToFinished(u37, true);
        end;

        return true;
    end;

    moveToFinished(u37, true);
end;

return u4;