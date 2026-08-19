-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Utility = script.Parent.Parent.Utility;
require(script.Parent.Parent.Types);
local Bin = require(Utility.Bin);
local u1 = {
    Running = true,
    Climbing = true,
    Swimming = true,
    Freefall = true,
    Jumping = true
};

local function stateChanged(p2, p3, p4) -- Line: 18
    -- upvalues: u1 (copy)
    local Name = p4.Name;

    if u1[Name] then
        p2._pose = Name;

        return;
    end;

    p2._controller:ChangePose(Name, 1, true);
end;

local function jumping(p5) -- Line: 29
    p5._jumpTimer = p5.JumpDuration;
    p5._controller:ChangePose("Jumping", 1, true);
end;

local function movementChPose(p6, p7, p8) -- Line: 36
    local v9 = p8 / p6.BaseMoveSpeed;
    local v10 = p6._controller:GetCurrentTrack();

    if v10 then
        v10:AdjustSpeed(v9);
    end;

    p6._controller:ChangePose(p7, v9, true);
end;

local function climbing(p11, p12) -- Line: 47
    local v13 = p12 / p11.BaseMoveSpeed;
    local v14 = p11._controller:GetCurrentTrack();

    if v14 then
        v14:AdjustSpeed(v13);
    end;

    p11._controller:ChangePose("Climbing", v13, true);
end;

local function swimming(p15, p16) -- Line: 51
    local v17 = p16 <= p15.SwimIdleThreshold and "SwimIdle" or "Swimming";

    if v17 == "SwimIdle" then
        p16 = p15.SwimIdleSpeed or p16;
    end;

    local v18 = p16 / p15.BaseMoveSpeed;
    local v19 = p15._controller:GetCurrentTrack();

    if v19 then
        v19:AdjustSpeed(v18);
    end;

    p15._controller:ChangePose(v17, v18, true);
end;

local function running(p20, p21) -- Line: 57
    local v22 = p20._controller:GetPose();
    local v23 = (p21 == 0 or (v22 == "Landed" or (v22 == "Jumping" or v22 == "Freefall"))) and "Idle" or (p21 <= p20.BaseMoveSpeed and "Walk" or "Run");

    if v23 == "Idle" then
        p21 = p20.IdleSpeed or p21;
    end;

    local v24 = p21 / p20.BaseMoveSpeed;
    local v25 = p20._controller:GetCurrentTrack();

    if v25 then
        v25:AdjustSpeed(v24);
    end;

    p20._controller:ChangePose(v23, v24, true);
end;

local v26 = {};
local u27 = {
    __index = v26
};

local function pwarn(p28, p29) -- Line: 73
    warn(string.format("Usage of deprecated function: Connections:%s(), set Connections.%s directly instead.", p28, p29));
end;

function v26.SetRunThreshold(p30, p31) -- Line: 80
    warn(string.format(
        "Usage of deprecated function: Connections:%s(), set Connections.%s directly instead.",
        "SetRunThreshold",
        "BaseMoveSpeed"
    ));
    p30.BaseMoveSpeed = p31;
end;

function v26.SetSwimIdleSpeed(p32, p33) -- Line: 87
    warn(string.format(
        "Usage of deprecated function: Connections:%s(), set Connections.%s directly instead.",
        "SetSwimIdleSpeed",
        "SwimIdleSpeed"
    ));
    p32.SwimIdleSpeed = p33;
end;

function v26.SetIdleSpeed(p34, p35) -- Line: 94
    warn(string.format(
        "Usage of deprecated function: Connections:%s(), set Connections.%s directly instead.",
        "SetIdleSpeed",
        "IdleSpeed"
    ));
    p34.IdleSpeed = p35;
end;

function v26.SetSwimThreshold(p36, p37) -- Line: 101
    warn(string.format(
        "Usage of deprecated function: Connections:%s(), set Connections.%s directly instead.",
        "SetSwimThreshold",
        "SwimIdleThreshold"
    ));
    p36.SwimIdleThreshold = p37;
end;

function v26.SetJumpDuration(p38, p39) -- Line: 108
    warn(string.format(
        "Usage of deprecated function: Connections:%s(), set Connections.%s directly instead.",
        "SetJumpDuration",
        "JumpDuration"
    ));
    p38.JumpDuration = p39;
end;

function v26.Destroy(p40) -- Line: 118
    p40._trash:Clear();
    setmetatable(p40, nil);
    table.clear(p40);
end;

return {
    new = function(u41, p42, p43) -- Line: 136, Name: new
        -- upvalues: Bin (copy), u27 (copy), u1 (copy), RunService (copy)
        local v44 = p43 or p42:FindFirstChildWhichIsA("Humanoid");

        if not v44 then
            error((`Humanoid not found for rig {p42}`));
        end;

        local v45 = Bin.new();
        local v46 = {
            _jumpTimer = 0,
            JumpDuration = 0.2,
            SwimIdleSpeed = 12,
            SwimIdleThreshold = 2,
            IdleSpeed = 16,
            BaseMoveSpeed = 16,
            _controller = u41,
            _trash = v45,
            _pose = u41:GetPose()
        };
        local u47 = setmetatable(v46, u27);
        v45:Add(v44.Running:Connect(function(p48) -- Line: 161
            -- upvalues: u47 (copy)
            local v49 = u47;
            local v50 = v49._controller:GetPose();
            local v51 = (p48 == 0 or (v50 == "Landed" or (v50 == "Jumping" or v50 == "Freefall"))) and "Idle" or (p48 <= v49.BaseMoveSpeed and "Walk" or "Run");

            if v51 == "Idle" then
                p48 = v49.IdleSpeed or p48;
            end;

            local v52 = p48 / v49.BaseMoveSpeed;
            local v53 = v49._controller:GetCurrentTrack();

            if v53 then
                v53:AdjustSpeed(v52);
            end;

            v49._controller:ChangePose(v51, v52, true);
        end), v44.Climbing:Connect(function(p54) -- Line: 164
            -- upvalues: u47 (copy)
            local v55 = u47;
            local v56 = p54 / v55.BaseMoveSpeed;
            local v57 = v55._controller:GetCurrentTrack();

            if v57 then
                v57:AdjustSpeed(v56);
            end;

            v55._controller:ChangePose("Climbing", v56, true);
        end), v44.Swimming:Connect(function(p58) -- Line: 167
            -- upvalues: u47 (copy)
            local v59 = u47;
            local v60 = p58 <= v59.SwimIdleThreshold and "SwimIdle" or "Swimming";

            if v60 == "SwimIdle" then
                p58 = v59.SwimIdleSpeed or p58;
            end;

            local v61 = p58 / v59.BaseMoveSpeed;
            local v62 = v59._controller:GetCurrentTrack();

            if v62 then
                v62:AdjustSpeed(v61);
            end;

            v59._controller:ChangePose(v60, v61, true);
        end), v44.StateChanged:Connect(function(p63, p64) -- Line: 170
            -- upvalues: u47 (copy), u1 (ref)
            local v65 = u47;
            local Name = p64.Name;

            if u1[Name] then
                v65._pose = Name;

                return;
            end;

            v65._controller:ChangePose(Name, 1, true);
        end), v44.Jumping:Connect(function() -- Line: 173
            -- upvalues: u47 (copy)
            local v66 = u47;
            v66._jumpTimer = v66.JumpDuration;
            v66._controller:ChangePose("Jumping", 1, true);
        end), RunService.Heartbeat:Connect(function(p67) -- Line: 176
            -- upvalues: u47 (copy), u41 (copy)
            u47._jumpTimer = math.max(u47._jumpTimer - p67, 0);
            local v68 = u41:GetPose();

            if u47._pose == "Freefall" and (v68 == "Run" or v68 == "Walk") then
                u41:ChangePose("FellOff", 1, true);
            end;

            if u47._pose == "Freefall" and u47._jumpTimer <= 0 then
                u41:ChangePose("Freefall", 1, true);
            end;
        end));

        return u47;
    end
};