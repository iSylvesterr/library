-- Decompiled with Potassium's decompiler.

local u47 = {
    Constants = {
        SOURCE_TO_STUDS = 0.0763888888888889,
        SV_GRAVITY = 800,
        GRENADE_GRAVITY_SCALE = 0.39,
        GRENADE_ELASTICITY = 0.4,
        JUMP_THROW_ELASTICITY = 0.32,
        PLAYER_ELASTICITY = 0.3,
        MIN_ELASTICITY = 0,
        MAX_ELASTICITY = 0.9,
        MAX_THROW_VELOCITY_SOURCE = 750,
        PLAYER_VELOCITY_SCALE = 1.5,
        SLEEP_VELOCITY_SOURCE = 20,
        STOP_EPSILON_SOURCE = 0.1,
        FLOOR_NORMAL_THRESHOLD = 0.7,
        OVERBOUNCE = 2,
        FIXED_TIMESTEP = 0.0078125,
        MAX_BOUNCES = 20,
        THROW_POWER_SCALE = 0.7,
        THROW_POWER_BASE = 0.3,
        VELOCITY_SCALE = 0.58,
        GRAVITY = Vector3.new(0, -23.833334, 0),
        MAX_THROW_VELOCITY = 57.29166666666667,
        SLEEP_VELOCITY = 1.527777777777778,
        STOP_EPSILON = 0.0076388888888888895,
        THROW_UPWARD_BIAS_FAR = 0.06,
        THROW_UPWARD_BIAS_NEAR = 0.04,
        THROW_FORWARD_OFFSET = 1.35,
        THROW_HEIGHT_OFFSET = 2.4,
        PLAYER_VELOCITY_INHERITANCE = 1.5,
        PLAYER_VERTICAL_VELOCITY_SCALE = 2,
        GROUND_CHECK_DISTANCE = 0.2,
        MAX_SIMULATION_TIME = 10,
        JUMP_THROW_DETECTION_THRESHOLD = 5,
        JUMP_THROW_HORIZONTAL_DAMPENING = 1,
        JUMP_THROW_FIXED_VERTICAL = 20,
        JUMP_THROW_HEIGHT_BONUS = 0,
        MAX_THROW_SPEED = 50,
        MAX_JUMP_THROW_SPEED = 62,
        MAX_ACCUMULATED_TIME = 0.1,
        MAX_ITERATIONS_PER_FRAME = 16
    },

    createInitialState = function(p1, p2, p3, p4, p5, p6) -- Line: 259, Name: createInitialState
        local v7 = ((p3 == "Far" and 1 or 0) * 0.7 + 0.3) * 57.29166666666667 * p5 * 0.58;
        local v8 = p4.Y > 5;
        local v9 = 1;

        if v8 then
            p1 = p1 + Vector3.new(0, 0, 0);
        end;

        local v10 = v8 and Vector3.new(0, 20, 0) or Vector3.new(0, p4.Y * 2 * 0.58, 0);
        local v11;

        if v8 then
            v11 = Vector3.new(p2.X * v9, p2.Y, p2.Z * v9).Unit;
        else
            v11 = p2;
        end;

        local v12 = not v8 and 1 or v9;
        local v13 = v11 * v7 + v10 + (Vector3.new(p2.X * v12, p2.Y, p2.Z * v12).Unit * v7 * 0.15 + Vector3.new(0, p5 * 6.5 * 0.58, 0));
        local v14 = not v8 and 50 or (p2.Y - 0.4) * 20 + 62;

        if v14 < v13.Magnitude then
            v13 = v13.Unit * v14;
        end;

        local v15 = v13 + Vector3.new(p4.X, 0, p4.Z) * 1.5 * v9;
        local v16 = math.floor(p6 * 1000) % 1000;
        local v17 = math.floor(v16 / 11) % 13 - 6;
        local v18 = math.floor(v16 / 143) % 11 - 5;

        return {
            simulationTime = 0,
            bounceCount = 0,
            isGrounded = false,
            isAtRest = false,
            hasTouched = false,
            accumulatedTime = 0,
            position = p1,
            velocity = v15,
            angularVelocity = Vector3.new(v16 % 11 - 5, v17, v18),
            timestamp = p6,
            isJumpThrow = v8
        };
    end,

    createConfig = function(p19, p20, p21, p22, p23, p24) -- Line: 355, Name: createConfig
        return {
            restitution = 0.4,
            maxBounces = 20,
            radius = p19,
            fuseTime = p22,
            minimumFuseTime = p23,
            explodeOnFloorImpact = p24,
            rangeScale = p20,
            isNearThrow = p21
        };
    end,

    detectCollision = function(p25, p26, p27, p28) -- Line: 378, Name: detectCollision
        local v29 = p26 - p25;
        local Magnitude = v29.Magnitude;

        if Magnitude < 0.001 then
            return nil;
        end;

        local v30 = p27 * 0.01;
        local v31 = {
            Vector3.new(v30, 0, 0),
            Vector3.new(-v30, 0, 0),
            Vector3.new(0, v30, 0),
            Vector3.new(0, -v30, 0),
            Vector3.new(0, 0, v30),
            (Vector3.new(0, 0, -v30))
        };
        local v32 = (1 / 0);
        local v33 = workspace:Raycast(p25, v29, p28);
        local v34;

        if v33 and v33.Distance < v32 then
            v32 = v33.Distance;
            v34 = Vector3.new(0, 0, 0);
        else
            v33 = nil;
            v34 = Vector3.new(0, 0, 0);
        end;

        for _, v in v31 do
            local v35 = workspace:Raycast(p25 + v, v29, p28);

            if v35 and v35.Distance < v32 then
                v32 = v35.Distance;
                v34 = v;
                v33 = v35;
            end;
        end;

        if not v33 then
            return nil;
        end;

        local v36 = v33.Position - v34;
        local Magnitude2 = (v36 - p25).Magnitude;

        if Magnitude + v30 + 0.1 < Magnitude2 then
            return nil;
        end;

        local Instance = v33.Instance;
        local Parent = Instance.Parent;
        local v37;

        if Parent then
            v37 = Parent:FindFirstChildOfClass("Humanoid") ~= nil;
        else
            v37 = Parent;
        end;

        local v38 = Parent and Parent:HasTag("BreakableGlass") or Instance:HasTag("BreakableGlass");

        return {
            hit = true,
            position = v36,
            normal = v33.Normal,
            distance = Magnitude2,
            instance = Instance,
            isPlayer = v37,
            isGlass = v38
        };
    end,

    checkGrounded = function(p39, p40) -- Line: 459, Name: checkGrounded
        local v41 = workspace:Raycast(p39, Vector3.new(0, -0.2, 0), p40);

        if v41 then
            return true, v41.Normal;
        end;

        return false, nil;
    end,

    checkSurfaceContact = function(p42, p43, p44) -- Line: 471, Name: checkSurfaceContact
        local v45 = p43 + 0.1;

        for _, v in { Vector3.new(0, -1, 0), Vector3.new(0, 1, 0), Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0), Vector3.new(0, 0, 1), Vector3.new(0, 0, -1) } do
            local v46 = workspace:Raycast(p42, v * v45, p44);

            if v46 and v46.Distance < v45 then
                return true, v46.Normal;
            end;
        end;

        return false, nil;
    end
};

local function PhysicsClipVelocity(p48, p49, p50) -- Line: 521
    local v51 = p48:Dot(p49) * p50;
    local v52 = p48.X - p49.X * v51;
    local v53 = p48.Y - p49.Y * v51;
    local v54 = p48.Z - p49.Z * v51;
    local v55 = math.abs(v52) < 0.0076388888888888895 and 0 or v52;
    local v56 = math.abs(v53) < 0.0076388888888888895 and 0 or v53;
    local v57 = math.abs(v54) < 0.0076388888888888895 and 0 or v54;

    return Vector3.new(v55, v56, v57);
end;

function u47.integrate(p58, p59, p60, p61) -- Line: 560
    if p61 then
        return p58 + p59 * p60, p59;
    end;

    local v62 = p59.Y - p60 * 23.83333396911621;
    local v63 = Vector3.new(p59.X * p60, (p59.Y + v62) / 2 * p60, p59.Z * p60);
    local v64 = Vector3.new(p59.X, v62, p59.Z);

    return p58 + v63, v64;
end;

function u47.calculateBounce(p65, p66, p67, p68) -- Line: 605
    -- upvalues: PhysicsClipVelocity (copy)
    local v69 = table.clone(p67);
    local v70 = math.clamp((p67.isJumpThrow and 0.32 or 0.4) * (p68 and 0.3 or 1), 0, 0.9);
    local v71 = PhysicsClipVelocity(p65, p66, 2) * v70;

    if p66.Y > 0.7 and v71:Dot(v71) < 2.3341049382716053 then
        v69.bounceCount = p67.bounceCount + 1;
        v69.hasTouched = true;

        return Vector3.new(0, 0, 0), v69;
    end;

    v69.bounceCount = p67.bounceCount + 1;
    v69.hasTouched = true;

    return v71, v69;
end;

function u47.shouldStop(p72, p73, p74) -- Line: 665
    if p73 and p74 then
        return p72:Dot(p72) < 2.3341049382716053;
    end;

    return false;
end;

function u47.step(p75, p76, p77, p78) -- Line: 684
    -- upvalues: u47 (copy)
    local v79 = table.clone(p75);
    v79.simulationTime = p75.simulationTime + p78;
    local v80 = nil;

    if v79.simulationTime >= 10 then
        v79.isAtRest = true;

        return v79, {
            type = "timeout",
            normal = Vector3.new(0, 1, 0),
            timestamp = p75.timestamp + v79.simulationTime,
            position = v79.position,
            velocity = v79.velocity,
            bounceCount = v79.bounceCount
        };
    end;

    if p76.fuseTime and v79.simulationTime >= p76.fuseTime then
        v79.isAtRest = true;

        return v79, {
            type = "fuse",
            normal = Vector3.new(0, 1, 0),
            timestamp = p75.timestamp + v79.simulationTime,
            position = v79.position,
            velocity = v79.velocity,
            bounceCount = v79.bounceCount
        };
    end;

    if p75.bounceCount >= p76.maxBounces then
        v79.isAtRest = true;
        v79.velocity = Vector3.new(0, 0, 0);

        return v79, {
            type = "rest",
            normal = Vector3.new(0, 1, 0),
            velocity = Vector3.new(0, 0, 0),
            timestamp = p75.timestamp + v79.simulationTime,
            position = v79.position,
            bounceCount = v79.bounceCount
        };
    end;

    local position = v79.position;
    local v81, v82 = u47.integrate(v79.position, v79.velocity, p78, v79.isGrounded);
    local v83 = u47.detectCollision(position, v81, p76.radius, p77);

    if v83 then
        local v84;
        v84, v79 = u47.calculateBounce(v82, v83.normal, v79, v83.isPlayer);
        v79.position = v83.position + v83.normal * 0.05;
        v79.velocity = v84;

        if p76.explodeOnFloorImpact and v83.normal.Y > 0.7 and (not p76.minimumFuseTime or v79.simulationTime >= p76.minimumFuseTime) then
            v79.isAtRest = true;

            return v79, {
                type = "floor_impact",
                timestamp = p75.timestamp + v79.simulationTime,
                position = v79.position,
                normal = v83.normal,
                velocity = v79.velocity,
                bounceCount = v79.bounceCount
            };
        end;

        v80 = {
            type = "bounce",
            timestamp = p75.timestamp + v79.simulationTime,
            position = v79.position,
            normal = v83.normal,
            velocity = v79.velocity,
            bounceCount = v79.bounceCount
        };
    else
        v79.position = v81;
        v79.velocity = v82;
    end;

    local v85, v86 = u47.checkGrounded(v79.position, p77);
    v79.isGrounded = v85;

    if not u47.shouldStop(v79.velocity, v85, v79.hasTouched) or (p76.minimumFuseTime and v79.simulationTime < p76.minimumFuseTime or p76.fuseTime) then
        return v79, v80;
    end;

    v79.isAtRest = true;
    v79.velocity = Vector3.new(0, 0, 0);
    v79.angularVelocity = Vector3.new(0, 0, 0);

    return v79, {
        type = "rest",
        velocity = Vector3.new(0, 0, 0),
        timestamp = p75.timestamp + v79.simulationTime,
        position = v79.position,
        normal = v86 or Vector3.new(0, 1, 0),
        bounceCount = v79.bounceCount
    };
end;

function u47.simulate(p87, p88, p89, p90) -- Line: 817
    -- upvalues: u47 (copy)
    if p87.isAtRest then
        if not p88.fuseTime then
            return {
                state = p87,
                events = {}
            };
        end;

        local v91 = table.clone(p87);
        v91.simulationTime = p87.simulationTime + p90;

        return v91.simulationTime >= p88.fuseTime and {
            state = v91,
            events = {
                {
                    type = "fuse",
                    normal = Vector3.new(0, 1, 0),
                    timestamp = p87.timestamp + v91.simulationTime,
                    position = v91.position,
                    velocity = v91.velocity,
                    bounceCount = v91.bounceCount
                }
            }
        } or {
            state = v91,
            events = {}
        };
    end;

    local v92 = table.clone(p87);
    v92.accumulatedTime = p87.accumulatedTime + p90;
    local v93, v94;

    if v92.accumulatedTime > 0.1 then
        v92.accumulatedTime = 0.1;
        v93 = 0;
        v94 = {};
    else
        v93 = 0;
        v94 = {};
    end;

    while v92.accumulatedTime >= 0.0078125 and v93 < 16 do
        v93 = v93 + 1;
        v92.accumulatedTime = v92.accumulatedTime - 0.0078125;
        local v95;
        v92, v95 = u47.step(v92, p88, p89, 0.0078125);

        if v95 then
            table.insert(v94, v95);
        end;

        if v92.isAtRest then
            break;
        end;
    end;

    return {
        state = v92,
        events = v94
    };
end;

function u47.calculateThrowParameters(p96, p97, p98, p99) -- Line: 900
    local v100 = p98 == "Near";
    local v101 = (v100 and 0.04 or 0.06) * math.clamp(p99, 0.8, 1.2);
    local v102 = 1.35;
    local v103 = 2.4;
    local v104;

    if v100 then
        v102 = v102 * 0.55;
        v104 = v103 * 0.8;
        v101 = v101 + 0.08;
    else
        v104 = v103 + 0.1;
    end;

    local Unit = (p97 + Vector3.new(0, v101, 0)).Unit;
    local v105 = Vector3.new(p97.X, 0, p97.Z);

    return p96 + (v105.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v105).Unit * v102 + Vector3.new(0, v104, 0), Unit;
end;

function u47.interpolateState(p106, p107, p108) -- Line: 937
    local v109 = table.clone(p107);
    v109.position = p106.position:Lerp(p107.position, p108);
    v109.velocity = p106.velocity:Lerp(p107.velocity, p108);
    v109.angularVelocity = p106.angularVelocity:Lerp(p107.angularVelocity, p108);

    return v109;
end;

return u47;