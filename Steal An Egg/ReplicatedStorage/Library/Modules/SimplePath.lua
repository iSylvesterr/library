-- Decompiled with Potassium's decompiler.

local u1 = {
    TIME_VARIANCE = 0.07,
    COMPARISON_CHECKS = 1,
    JUMP_WHEN_STUCK = true
};
local PathfindingService = game:GetService("PathfindingService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local u2 = RunService:IsServer();

local function output(p3, p4) -- Line: 69
    p3((p3 == error and "SimplePath Error: " or "SimplePath: ") .. p4);
end;

local u5 = {
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

function u5.__index(p6, p7) -- Line: 87
    -- upvalues: u5 (copy)
    if p7 == "Stopped" and not p6._humanoid then
        local v8 = error;
        v8((v8 == error and "SimplePath Error: " or "SimplePath: ") .. "Attempt to use Path.Stopped on a non-humanoid.");
    end;

    return p6._events[p7] and p6._events[p7].Event or p7 == "LastError" and p6._lastError or (p7 == "Status" and p6._status or u5[p7]);
end;

local Part = Instance.new("Part");
Part.Size = Vector3.new(0.3, 0.3, 0.3);
Part.Anchored = true;
Part.CanCollide = false;
Part.Material = Enum.Material.Neon;
Part.Shape = Enum.PartType.Ball;

local function declareError(p9, p10) -- Line: 104
    p9._lastError = p10;
    p9._events.Error:Fire(p10);
end;

local function createVisualWaypoints(p11) -- Line: 109
    -- upvalues: Part (copy)
    local v12 = {};

    for _, v in ipairs(p11) do
        local v13 = Part:Clone();
        v13.Position = v.Position;
        v13.Parent = workspace;
        v13.Color = v == p11[#p11] and Color3.fromRGB(0, 255, 0) or (v.Action == Enum.PathWaypointAction.Jump and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 139, 0));
        table.insert(v12, v13);
    end;

    return v12;
end;

local function destroyVisualWaypoints(p14) -- Line: 123
    if p14 then
        for _, v in ipairs(p14) do
            v:Destroy();
        end;
    end;
end;

local function getNonHumanoidWaypoint(p15) -- Line: 132
    local _waypoints = p15._waypoints;

    for i = 2, #_waypoints do
        if (_waypoints[i].Position - _waypoints[i - 1].Position).Magnitude > 0.1 then
            return i;
        end;
    end;

    return 2;
end;

local function setJumpState(u16) -- Line: 142
    pcall(function() -- Line: 143
        -- upvalues: u16 (copy)
        local _humanoid = u16._humanoid;

        if _humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and _humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
            _humanoid:ChangeState(Enum.HumanoidStateType.Jumping);
        end;
    end);
end;

local function move(u17) -- Line: 154
    local _waypoints = u17._waypoints;
    local _currentWaypoint = u17._currentWaypoint;

    if _waypoints[_currentWaypoint].Action == Enum.PathWaypointAction.Jump then
        pcall(function() -- Line: 143
            -- upvalues: u17 (copy)
            local _humanoid = u17._humanoid;

            if _humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and _humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
                _humanoid:ChangeState(Enum.HumanoidStateType.Jumping);
            end;
        end);
    end;

    u17._humanoid:MoveTo(_waypoints[_currentWaypoint].Position);
end;

local function disconnectMoveConnection(p18) -- Line: 164
    p18._moveConnection:Disconnect();
    p18._moveConnection = nil;
end;

local function invokeWaypointReached(p19) -- Line: 170
    local _waypoints = p19._waypoints;
    local _currentWaypoint = p19._currentWaypoint;
    p19._events.WaypointReached:Fire(p19._agent, _waypoints[_currentWaypoint - 1], _waypoints[_currentWaypoint]);
end;

local function moveToFinished(u20, p21) -- Line: 178
    -- upvalues: u5 (copy)
    if not getmetatable(u20) then
        return;
    end;

    local _waypoints = u20._waypoints;
    local _currentWaypoint = u20._currentWaypoint;

    if not u20._humanoid then
        if p21 and _currentWaypoint + 1 <= #_waypoints then
            local _waypoints2 = u20._waypoints;
            local _currentWaypoint2 = u20._currentWaypoint;
            u20._events.WaypointReached:Fire(u20._agent, _waypoints2[_currentWaypoint2 - 1], _waypoints2[_currentWaypoint2]);
            u20._currentWaypoint = _currentWaypoint + 1;

            return;
        end;

        if p21 then
            local _visualWaypoints = u20._visualWaypoints;

            if _visualWaypoints then
                for _, v in ipairs(_visualWaypoints) do
                    v:Destroy();
                end;
            end;

            u20._visualWaypoints = nil;
            u20._target = nil;
            u20._events.Reached:Fire(u20._agent, _waypoints[_currentWaypoint]);

            return;
        end;

        local _visualWaypoints = u20._visualWaypoints;

        if _visualWaypoints then
            for _, v in ipairs(_visualWaypoints) do
                v:Destroy();
            end;
        end;

        u20._visualWaypoints = nil;
        u20._target = nil;
        local TargetUnreachable = u20.ErrorType.TargetUnreachable;
        u20._lastError = TargetUnreachable;
        u20._events.Error:Fire(TargetUnreachable);

        return;
    end;

    if p21 and _currentWaypoint + 1 <= #_waypoints then
        if _currentWaypoint + 1 < #_waypoints then
            local _waypoints2 = u20._waypoints;
            local _currentWaypoint2 = u20._currentWaypoint;
            u20._events.WaypointReached:Fire(u20._agent, _waypoints2[_currentWaypoint2 - 1], _waypoints2[_currentWaypoint2]);
        end;

        u20._currentWaypoint = _currentWaypoint + 1;
        local _waypoints2 = u20._waypoints;
        local _currentWaypoint2 = u20._currentWaypoint;

        if _waypoints2[_currentWaypoint2].Action == Enum.PathWaypointAction.Jump then
            pcall(function() -- Line: 143
                -- upvalues: u20 (copy)
                local _humanoid = u20._humanoid;

                if _humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and _humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
                    _humanoid:ChangeState(Enum.HumanoidStateType.Jumping);
                end;
            end);
        end;

        u20._humanoid:MoveTo(_waypoints2[_currentWaypoint2].Position);

        return;
    end;

    if p21 then
        u20._moveConnection:Disconnect();
        u20._moveConnection = nil;
        u20._status = u5.StatusType.Idle;
        local _visualWaypoints = u20._visualWaypoints;

        if _visualWaypoints then
            for _, v in ipairs(_visualWaypoints) do
                v:Destroy();
            end;
        end;

        u20._visualWaypoints = nil;
        u20._events.Reached:Fire(u20._agent, _waypoints[_currentWaypoint]);

        return;
    end;

    u20._moveConnection:Disconnect();
    u20._moveConnection = nil;
    u20._status = u5.StatusType.Idle;
    local _visualWaypoints = u20._visualWaypoints;

    if _visualWaypoints then
        for _, v in ipairs(_visualWaypoints) do
            v:Destroy();
        end;
    end;

    u20._visualWaypoints = nil;
    local TargetUnreachable = u20.ErrorType.TargetUnreachable;
    u20._lastError = TargetUnreachable;
    u20._events.Error:Fire(TargetUnreachable);
end;

local function comparePosition(u22) -- Line: 221
    if u22._currentWaypoint == #u22._waypoints then
        return;
    end;

    local PrimaryPart = u22._agent.PrimaryPart;
    u22._position._count = (PrimaryPart.Position - u22._position._last).Magnitude <= 0.07 and (u22._position._count + 1 or 0) or 0;
    u22._position._last = PrimaryPart.Position;

    if u22._position._count >= u22._settings.COMPARISON_CHECKS then
        if u22._settings.JUMP_WHEN_STUCK then
            pcall(function() -- Line: 143
                -- upvalues: u22 (copy)
                local _humanoid = u22._humanoid;

                if _humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and _humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
                    _humanoid:ChangeState(Enum.HumanoidStateType.Jumping);
                end;
            end);
        end;

        local AgentStuck = u22.ErrorType.AgentStuck;
        u22._lastError = AgentStuck;
        u22._events.Error:Fire(AgentStuck);
    end;
end;

function u5.GetNearestCharacter(p23) -- Line: 241
    -- upvalues: Players (copy)
    local v24 = (1 / 0);
    local v25 = nil;

    for _, v in ipairs(Players:GetPlayers()) do
        if v.Character and v.Character.PrimaryPart then
            local Magnitude = (v.Character.PrimaryPart.Position - p23).Magnitude;

            if Magnitude < v24 then
                v25 = v.Character;
                v24 = Magnitude;
            end;
        end;
    end;

    return v25;
end;

function u5.new(p26, p27, p28) -- Line: 254
    -- upvalues: u1 (copy), PathfindingService (copy), u5 (copy), RunService (copy)
    if not (p26 and (p26:IsA("Model") and p26.PrimaryPart)) then
        local v29 = error;
        v29((v29 == error and "SimplePath Error: " or "SimplePath: ") .. "Pathfinding agent must be a valid Model Instance with a set PrimaryPart.");
    end;

    local v30 = {
        _status = "Idle",
        _t = 0,
        _waypoints = nil,
        _currentWaypoint = nil,
        _target = nil,
        _visualWaypoints = nil,
        _moveConnection = nil,
        _lastError = nil,
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
        },
        StatusType = u5.StatusType,
        ErrorType = u5.ErrorType,
        Visualize = RunService:IsStudio()
    };
    local u31 = setmetatable(v30, u5);

    for i, v in pairs(u1) do
        u31._settings[i] = u31._settings[i] == nil and v and v or u31._settings[i];
    end;

    u31._path.Blocked:Connect(function(p32) -- Line: 293
        -- upvalues: u31 (copy)
        local _currentWaypoint = u31._currentWaypoint;

        if _currentWaypoint and (_currentWaypoint <= p32 and (p32 <= _currentWaypoint + 1 and u31._humanoid)) then
            local u33 = u31;
            pcall(function() -- Line: 143
                -- upvalues: u33 (copy)
                local _humanoid = u33._humanoid;

                if _humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and _humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
                    _humanoid:ChangeState(Enum.HumanoidStateType.Jumping);
                end;
            end);
            local _waypoints = u31._waypoints;

            if _waypoints then
                u31._events.Blocked:Fire(u31._agent, _waypoints[p32]);
            end;
        end;
    end);

    return u31;
end;

function u5.Destroy(p34) -- Line: 311
    for _, v in pairs(p34._events) do
        v:Destroy();
    end;

    if p34._visualWaypoints then
        local _visualWaypoints = p34._visualWaypoints;

        if _visualWaypoints then
            for _, v in ipairs(_visualWaypoints) do
                v:Destroy();
            end;
        end;

        p34._visualWaypoints = nil;
    end;

    p34._path:Destroy();
    setmetatable(p34, nil);

    for i, _ in pairs(p34) do
        p34[i] = nil;
    end;
end;

function u5.Stop(p35) -- Line: 325
    -- upvalues: u5 (copy)
    if not p35._humanoid then
        local v36 = error;
        v36((v36 == error and "SimplePath Error: " or "SimplePath: ") .. "Attempt to call Path:Stop() on a non-humanoid.");

        return;
    end;

    if p35._status == u5.StatusType.Idle then
        return;
    end;

    p35._moveConnection:Disconnect();
    p35._moveConnection = nil;
    p35._status = u5.StatusType.Idle;
    local _visualWaypoints = p35._visualWaypoints;

    if _visualWaypoints then
        for _, v in ipairs(_visualWaypoints) do
            v:Destroy();
        end;
    end;

    p35._visualWaypoints = nil;
    p35._events.Stopped:Fire(p35._agent);
end;

function u5.Run(u37, u38) -- Line: 342
    -- upvalues: moveToFinished (copy), u5 (copy), u2 (copy), comparePosition (copy), getNonHumanoidWaypoint (copy)
    if not u38 and (not u37._humanoid and u37._target) then
        moveToFinished(u37, true);

        return true;
    end;

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

    if not pcall(function() -- Line: 360
        -- upvalues: u37 (copy), u38 (copy)
        local PrimaryPart = u37._agent.PrimaryPart;
        local v40;

        if typeof(u38) == "Vector3" then
            v40 = u38;
        else
            v40 = u38.Position;
        end;

        u37._path:ComputeAsync(PrimaryPart.Position, v40);
    end) or (not u37._path or (u37._path.Status == Enum.PathStatus.NoPath or #u37._path:GetWaypoints() < 2)) then
        local v41 = not u37._path and "PathNil" or u37._path.Status;
        local v42 = u37._path and #u37._path:GetWaypoints() or 0;
        warn("no path:", v41, v42);
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

    local v43;

    if u37._humanoid then
        v43 = u5.StatusType.Active;
    else
        v43 = u5.StatusType.Idle;
    end;

    u37._status = v43;
    u37._target = u38;

    if u2 then
        local success, result = pcall(function() -- Line: 386
            -- upvalues: u37 (copy)
            u37._agent.PrimaryPart:SetNetworkOwner(nil);
        end);

        if not success then
            warn((`failed to set network owner: {result}`));
        end;
    end;

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

    if u37.Visualize then
        local _ = u37._waypoints;
    end;

    if u37._humanoid then
        u37._moveConnection = u37._moveConnection or u37._humanoid.MoveToFinished:Connect(function(p44) -- Line: 411
            -- upvalues: moveToFinished (ref), u37 (copy)
            moveToFinished(u37, p44);
        end);
    end;

    if u37._humanoid then
        u37._humanoid:MoveTo(u37._waypoints[u37._currentWaypoint].Position);
    else
        local _waypoints = u37._waypoints;

        if #_waypoints == 2 then
            u37._target = nil;
            local _visualWaypoints2 = u37._visualWaypoints;

            if _visualWaypoints2 then
                for _, v in ipairs(_visualWaypoints2) do
                    v:Destroy();
                end;
            end;

            u37._visualWaypoints = nil;
            u37._events.Reached:Fire(u37._agent, _waypoints[2]);
        else
            u37._currentWaypoint = getNonHumanoidWaypoint(u37);
            moveToFinished(u37, true);
        end;
    end;

    return true;
end;

return u5;