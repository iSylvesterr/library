-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local u1 = {};

local function vec3ToArray(p2) -- Line: 64
    return { p2.X, p2.Y, p2.Z };
end;

local function calculateAngle(p3, p4) -- Line: 68
    local Magnitude = p3.Magnitude;

    if Magnitude < 0.001 then
        return 0;
    end;

    local v5 = (p3 / Magnitude):Dot(p4);
    local v6 = math.abs(v5);
    local v7 = math.clamp(v6, -1, 1);
    local v8 = math.acos(v7);

    return math.deg(v8);
end;

function u1.startRecording(p9, p10, p11, p12, p13, p14) -- Line: 91
    local v15 = {
        map_name = "",
        end_position = nil,
        end_reason = nil,
        grenade_type = p9,
        throw_type = p10,
        start_position = { p11.X, p11.Y, p11.Z }
    };
    local Unit = p12.Unit;
    v15.throw_direction = { Unit.X, Unit.Y, Unit.Z };
    v15.player_velocity = { p13.X, p13.Y, p13.Z };
    v15.player_state = p14 or "standing";
    v15.start_time = tick();
    v15.points = {};
    v15.bounces = {};

    return v15;
end;

function u1.recordPoint(p16, p17, p18) -- Line: 122
    local v19 = math.floor(p17.simulationTime * 1000);

    if not p18 and v19 - (#p16.points <= 0 and -16 or p16.points[#p16.points].time_ms) < 16 then
        return;
    end;

    local v20 = {
        time_ms = v19
    };
    local position = p17.position;
    v20.position = { position.X, position.Y, position.Z };
    local velocity = p17.velocity;
    v20.velocity = { velocity.X, velocity.Y, velocity.Z };
    v20.speed = p17.velocity.Magnitude;
    table.insert(p16.points, v20);
end;

function u1.recordBounce(p21, p22, p23, p24) -- Line: 156
    local v25 = p22.normal or Vector3.new(0, 1, 0);
    local velocity = p22.velocity;
    local v26 = {
        time_ms = math.floor((p22.timestamp - (p21.start_time or p22.timestamp)) * 1000)
    };
    local position = p22.position;
    v26.position = { position.X, position.Y, position.Z };
    v26.velocity_before = { p23.X, p23.Y, p23.Z };
    v26.velocity_after = { velocity.X, velocity.Y, velocity.Z };
    v26.surface_normal = { v25.X, v25.Y, v25.Z };
    v26.surface_type = p24 or "world";
    local Magnitude = p23.Magnitude;
    local v27;

    if Magnitude < 0.001 then
        v27 = 0;
    else
        local v28 = (p23 / Magnitude):Dot(v25);
        local v29 = math.abs(v28);
        local v30 = math.clamp(v29, -1, 1);
        local v31 = math.acos(v30);
        v27 = math.deg(v31);
    end;

    v26.incident_angle = v27;
    local Magnitude2 = velocity.Magnitude;
    local v32;

    if Magnitude2 < 0.001 then
        v32 = 0;
    else
        local v33 = (velocity / Magnitude2):Dot(v25);
        local v34 = math.abs(v33);
        local v35 = math.clamp(v34, -1, 1);
        local v36 = math.acos(v35);
        v32 = math.deg(v36);
    end;

    v26.reflection_angle = v32;
    table.insert(p21.bounces, v26);
end;

function u1.finishRecording(p37, p38, p39) -- Line: 186
    p37.end_position = { p38.X, p38.Y, p38.Z };
    p37.end_reason = p39;
end;

function u1.exportJSON(p40, p41) -- Line: 202
    -- upvalues: HttpService (copy)
    return HttpService:JSONEncode({
        metadata = {
            source = "roblox",
            grenade_type = p40.grenade_type,
            throw_type = p40.throw_type,
            map = p41 or (p40.map_name or ""),
            coordinate_system = {
                up_axis = "y",
                unit = "studs"
            }
        },
        throw_params = {
            start_position = p40.start_position,
            throw_direction = p40.throw_direction,
            player_velocity = p40.player_velocity,
            player_state = p40.player_state
        },
        trajectory = p40.points,
        bounces = p40.bounces,
        summary = {
            duration_ms = #p40.points <= 0 and 0 or p40.points[#p40.points].time_ms,
            bounce_count = #p40.bounces,
            end_position = p40.end_position,
            end_reason = p40.end_reason
        }
    });
end;

function u1.simulateAndExport(p42, p43, p44, p45, p46, p47, p48, p49, p50) -- Line: 257
    -- upvalues: u1 (copy)
    local v51, v52 = p42.calculateThrowParameters(p45, p46, p44, p48.rangeScale);
    local v53 = p42.createInitialState(v51, v52, p44, p47, p48.rangeScale, tick());
    local v54 = u1.startRecording(p43, p44 == "Far" and "left" or "right", v51, v52, p47, p47.Magnitude > 1 and "walking" or "standing");
    u1.recordPoint(v54, v53, true);
    local v55 = 0;

    while not v53.isAtRest and v55 < 10000 do
        v55 = v55 + 1;
        local velocity = v53.velocity;
        local v56 = p42.simulate(v53, p48, p49, 0.016666666666666666);
        v53 = v56.state;
        u1.recordPoint(v54, v53);

        for _, v in v56.events do
            if v.type == "bounce" then
                u1.recordBounce(v54, v, velocity);
            elseif v.type == "rest" or (v.type == "fuse" or v.type == "floor_impact") then
                u1.finishRecording(v54, v.position, v.type);
            end;
        end;
    end;

    if not v54.end_reason then
        u1.finishRecording(v54, v53.position, "timeout");
    end;

    u1.recordPoint(v54, v53, true);

    return u1.exportJSON(v54, p50);
end;

return u1;