-- Decompiled with Potassium's decompiler.

require(game.ReplicatedFirst.AllSideCode.Class.Class);

return {
    create = function(u1) -- Line: 60, Name: create
        local animate = u1.animate;
        local humanoid = u1.humanoid;
        local character = u1.character;
        local localPlayer = u1.localPlayer;
        local setting = u1.setting;
        local u2 = "Idle";
        local u3 = 0;
        local u4 = 0;
        local u5 = 0;
        local u6 = false;
        local u7 = "Idle";
        local u8 = "Idle";
        local u9 = nil;
        local u10 = 0;
        local u11 = 0;
        local u12 = nil;
        local LAND_ANIM_TIME = setting.LAND_ANIM_TIME;
        local LAND_LOCO_INTERRUPT_LOCK_SEC = setting.LAND_LOCO_INTERRUPT_LOCK_SEC;
        local u13 = 0;
        local u14 = 0;
        local u15 = false;
        local u16 = 0;
        local u17 = false;
        local u18 = 0;
        local MOVE_INTENT_FOR_LOCO = setting.MOVE_INTENT_FOR_LOCO;
        local FALL_LAND_THRESHOLD = setting.FALL_LAND_THRESHOLD;
        local MIN_JUMP_ANIMATION_TIME = setting.MIN_JUMP_ANIMATION_TIME;
        local u19 = setting.FREEFALL_MIN_DURATION or 0.08;
        local STATIONARY_LOCO_SPEED = setting.STATIONARY_LOCO_SPEED;
        local u20 = (type(STATIONARY_LOCO_SPEED) ~= "number" or (STATIONARY_LOCO_SPEED ~= STATIONARY_LOCO_SPEED or STATIONARY_LOCO_SPEED < 0)) and 0.5 or STATIONARY_LOCO_SPEED;
        local STATIONARY_LOCO_SPEED_ENTER = setting.STATIONARY_LOCO_SPEED_ENTER;
        local v21 = (type(STATIONARY_LOCO_SPEED_ENTER) ~= "number" or (STATIONARY_LOCO_SPEED_ENTER ~= STATIONARY_LOCO_SPEED_ENTER or STATIONARY_LOCO_SPEED_ENTER < 0)) and 0.12 or STATIONARY_LOCO_SPEED_ENTER;

        if u20 >= v21 then
            u20 = v21;
        end;

        local u22 = {
            StartRun = "Run",
            StartWalk = "Walk",
            StopRun = "Idle",
            StopWalk = "Idle"
        };

        local function _transitionOpts(p23) -- Line: 119
            -- upvalues: setting (copy)
            local v24 = setting.Transition and setting.Transition[p23];

            return v24 and {
                fadeTime = v24.fadeTime,
                fadeIn = v24.fadeIn,
                fadeOut = v24.fadeOut,
                middleDuration = v24.middleDuration,
                animationSpeed = v24.animationSpeed
            } or nil;
        end;

        local function _shouldSkipLandAnimation(p25, p26) -- Line: 139
            -- upvalues: localPlayer (copy)
            return localPlayer:GetAttribute("SkillActionLock") and true or false;
        end;

        local function _isGroundTransitionEnabled(p27) -- Line: 174
            -- upvalues: setting (copy)
            local TransitionEnable = setting.TransitionEnable;

            return (not TransitionEnable or TransitionEnable[p27] == nil) and true or TransitionEnable[p27] == true;
        end;

        local function _runLocoWalkSpeedThreshold() -- Line: 186
            -- upvalues: setting (copy)
            local RUN_LOCOMOTION_WALKSPEED_THRESHOLD = setting.RUN_LOCOMOTION_WALKSPEED_THRESHOLD;

            return (type(RUN_LOCOMOTION_WALKSPEED_THRESHOLD) ~= "number" or RUN_LOCOMOTION_WALKSPEED_THRESHOLD ~= RUN_LOCOMOTION_WALKSPEED_THRESHOLD) and 16 or RUN_LOCOMOTION_WALKSPEED_THRESHOLD;
        end;

        local function _walkSpeedForLocomotionCompare() -- Line: 198
            -- upvalues: humanoid (copy), setting (copy), localPlayer (copy)
            local WalkSpeed = humanoid.WalkSpeed;
            local v28 = localPlayer:GetAttribute(setting.EXPECTED_WALKSPEED_ATTRIBUTE or "ExpectedWalkSpeed");

            if type(v28) == "number" and (v28 == v28 and v28 >= 0) then
                return math.max(WalkSpeed, v28);
            end;

            return WalkSpeed;
        end;

        local function _hasMoveInputIntent() -- Line: 212
            -- upvalues: humanoid (copy), MOVE_INTENT_FOR_LOCO (copy)
            return MOVE_INTENT_FOR_LOCO <= humanoid.MoveDirection.Magnitude;
        end;

        local function _resolveEffectiveMoveSpeed(p29) -- Line: 221
            -- upvalues: character (copy)
            local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");
            local v30;

            if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity;
                v30 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude;

                if p29 >= v30 then
                    v30 = p29;
                end;
            else
                v30 = p29;
            end;

            return v30;
        end;

        local function _stationarySpeedThreshold() -- Line: 238
            -- upvalues: u8 (ref), u20 (ref), u20 (ref)
            if u8 == "Run" or u8 == "Walk" then
                return u20;
            end;

            return u20;
        end;

        local function _computeDesiredLocomotion(p31) -- Line: 250
            -- upvalues: humanoid (copy), MOVE_INTENT_FOR_LOCO (copy), u8 (ref), u20 (ref), u20 (ref), setting (copy), localPlayer (copy)
            if MOVE_INTENT_FOR_LOCO > humanoid.MoveDirection.Magnitude then
                return "Idle";
            end;

            local v32;

            if u8 == "Run" or u8 == "Walk" then
                v32 = u20;
            else
                v32 = u20;
            end;

            if p31 <= v32 then
                return "Idle";
            end;

            local WalkSpeed = humanoid.WalkSpeed;
            local v33 = localPlayer:GetAttribute(setting.EXPECTED_WALKSPEED_ATTRIBUTE or "ExpectedWalkSpeed");

            if type(v33) == "number" and (v33 == v33 and v33 >= 0) then
                WalkSpeed = math.max(WalkSpeed, v33);
            end;

            local RUN_LOCOMOTION_WALKSPEED_THRESHOLD = setting.RUN_LOCOMOTION_WALKSPEED_THRESHOLD;

            return ((type(RUN_LOCOMOTION_WALKSPEED_THRESHOLD) ~= "number" or RUN_LOCOMOTION_WALKSPEED_THRESHOLD ~= RUN_LOCOMOTION_WALKSPEED_THRESHOLD) and 16 or RUN_LOCOMOTION_WALKSPEED_THRESHOLD) < WalkSpeed and "Run" or "Walk";
        end;

        local function _applyStableLocomotionVisual(p34, p35) -- Line: 270
            -- upvalues: u14 (ref), u2 (ref), animate (copy), u1 (copy), u13 (ref)
            if p34 ~= "Idle" then
                u14 = 0;
            end;

            local v36 = time();

            if p34 == "Idle" and (u2 == "Land" and v36 < u14) then
                return;
            end;

            if p34 == "Run" then
                animate:setBaseSpeed("Run", u1.getRunAnimationSpeed(p35, "Run"));

                if u1.isShiftLocked() then
                    local v37 = u1.getRelativeMoveDirection();

                    if v37 == "Left" then
                        animate:setBasePos("Run_Left");
                    elseif v37 == "Right" then
                        animate:setBasePos("Run_Right");
                    elseif v37 == "Back" then
                        animate:setBasePos("Run_Back");
                    else
                        animate:setBasePos("Run");
                    end;
                else
                    animate:setBasePos("Run");
                end;

                u2 = "Run";
            elseif p34 == "Walk" then
                animate:setBaseSpeed("Walk", u1.getRunAnimationSpeed(p35, "Walk"));

                if u1.isShiftLocked() then
                    local v38 = u1.getRelativeMoveDirection();

                    if v38 == "Left" then
                        animate:setBasePos("Walk_Left");
                    elseif v38 == "Right" then
                        animate:setBasePos("Walk_Right");
                    elseif v38 == "Back" then
                        animate:setBasePos("Walk_Back");
                    else
                        animate:setBasePos("Walk");
                    end;
                else
                    animate:setBasePos("Walk");
                end;

                u2 = "Walk";
            else
                animate:setBasePos("Idle");
                u2 = "Idle";
            end;

            if p34 == "Idle" then
                u13 = 0;
                u14 = 0;
            end;
        end;

        local function _holdingLandAgainstIdle(p39) -- Line: 328
            -- upvalues: u2 (ref), u14 (ref)
            local v40;

            if u2 == "Land" then
                v40 = p39 < u14;
            else
                v40 = false;
            end;

            return v40;
        end;

        local function _beginGroundTransition(u41, u42, p43) -- Line: 338
            -- upvalues: setting (copy), humanoid (copy), localPlayer (copy), u10 (ref), u11 (ref), u9 (ref), u2 (ref), animate (copy), u1 (copy), character (copy), u12 (ref), u8 (ref), _applyStableLocomotionVisual (copy), u3 (ref)
            local GroundLocomotionDriver = setting.GroundLocomotionDriver;

            if GroundLocomotionDriver and GroundLocomotionDriver.debugPrintGroundTransition then
                local v44 = print;
                local WalkSpeed = humanoid.WalkSpeed;
                local WalkSpeed2 = humanoid.WalkSpeed;
                local v45 = localPlayer:GetAttribute(setting.EXPECTED_WALKSPEED_ATTRIBUTE or "ExpectedWalkSpeed");

                if type(v45) == "number" and (v45 == v45 and v45 >= 0) then
                    WalkSpeed2 = math.max(WalkSpeed2, v45);
                end;

                local RUN_LOCOMOTION_WALKSPEED_THRESHOLD = setting.RUN_LOCOMOTION_WALKSPEED_THRESHOLD;
                v44("[GroundTransition] 衔接:", u41, "目标稳定态:", u42, "移动速度:", p43, "WalkSpeed:", WalkSpeed, "有效(含预期):", WalkSpeed2, "跑走阈值:", (type(RUN_LOCOMOTION_WALKSPEED_THRESHOLD) ~= "number" or RUN_LOCOMOTION_WALKSPEED_THRESHOLD ~= RUN_LOCOMOTION_WALKSPEED_THRESHOLD) and 16 or RUN_LOCOMOTION_WALKSPEED_THRESHOLD);
            end;

            u10 = u10 + 1;
            local u46 = u10;
            local v47 = (not GroundLocomotionDriver or GroundLocomotionDriver.transitionMinVisibleSeconds == nil) and 0.06 or math.max(0, GroundLocomotionDriver.transitionMinVisibleSeconds);
            u11 = time() + v47;
            u9 = u41;
            u2 = u41;

            if u42 == "Run" then
                animate:setBaseSpeed("Run", u1.getRunAnimationSpeed(p43, "Run"));
            elseif u42 == "Walk" then
                animate:setBaseSpeed("Walk", u1.getRunAnimationSpeed(p43, "Walk"));
            end;

            local function _commitTransitionStableEarly() -- Line: 372
                -- upvalues: character (ref), u46 (copy), u10 (ref), u9 (ref), u41 (copy), u12 (ref), u8 (ref), u42 (copy), _applyStableLocomotionVisual (ref), u3 (ref)
                if not character.Parent then
                    return;
                end;

                if u46 ~= u10 then
                    return;
                end;

                if u9 ~= u41 then
                    return;
                end;

                u10 = u10 + 1;
                u9 = nil;
                u12 = nil;
                u8 = u42;
                _applyStableLocomotionVisual(u42, u3);
            end;

            local function v48() -- Line: 389
                -- upvalues: character (ref), u46 (copy), u10 (ref), u9 (ref), u41 (copy), u12 (ref), u8 (ref), u42 (copy), _applyStableLocomotionVisual (ref), u3 (ref)
                if not character.Parent then
                    return;
                end;

                if u46 ~= u10 then
                    return;
                end;

                if u9 ~= u41 then
                    return;
                end;

                u9 = nil;
                u12 = nil;
                u8 = u42;
                _applyStableLocomotionVisual(u42, u3);
            end;

            local v49 = setting.Transition and setting.Transition[u41];
            local v50, v51 = animate:playTransition(u41, v48, v49 and {
                fadeTime = v49.fadeTime,
                fadeIn = v49.fadeIn,
                fadeOut = v49.fadeOut,
                middleDuration = v49.middleDuration,
                animationSpeed = v49.animationSpeed
            } or nil);

            if v50 then
                u12 = v51;
                local v52 = setting.Transition and setting.Transition[u41];

                if v52 then
                    v52 = v52.commitStableAfterSeconds;
                end;

                if type(v52) == "number" and (v52 == v52 and v52 > 0) then
                    task.delay(v52, _commitTransitionStableEarly);
                end;

                return;
            end;

            u9 = nil;
            u12 = nil;
            u10 = u10 + 1;
            u8 = u42;
            _applyStableLocomotionVisual(u42, p43);
        end;

        local function _refreshGroundLocomotion(p53, p54) -- Line: 428
            -- upvalues: u7 (ref), u15 (ref), u13 (ref), u14 (ref), u9 (ref), u11 (ref), u22 (copy), u12 (ref), u10 (ref), u8 (ref), _applyStableLocomotionVisual (copy), setting (copy), humanoid (copy), localPlayer (copy), _beginGroundTransition (copy), u2 (ref), animate (copy), u18 (ref)
            local v55 = time();
            u7 = p53;

            if p53 == "Walk" or p53 == "Run" then
                u15 = false;
                u13 = 0;
                u14 = 0;
            end;

            if u9 then
                if u11 <= v55 then
                    local v56 = u9;

                    if v56 then
                        v56 = u22[v56];
                    end;

                    if v56 and p53 ~= v56 then
                        if u12 then
                            u12();
                            u12 = nil;
                        end;

                        u10 = u10 + 1;
                        u9 = nil;
                        u8 = p53;
                        _applyStableLocomotionVisual(p53, p54);

                        return;
                    end;
                end;

                return;
            end;

            local RUN_LOCOMOTION_WALKSPEED_THRESHOLD = setting.RUN_LOCOMOTION_WALKSPEED_THRESHOLD;
            local v57 = (type(RUN_LOCOMOTION_WALKSPEED_THRESHOLD) ~= "number" or RUN_LOCOMOTION_WALKSPEED_THRESHOLD ~= RUN_LOCOMOTION_WALKSPEED_THRESHOLD) and 16 or RUN_LOCOMOTION_WALKSPEED_THRESHOLD;

            if u8 == "Idle" and p53 ~= "Idle" then
                local WalkSpeed = humanoid.WalkSpeed;
                local v58 = localPlayer:GetAttribute(setting.EXPECTED_WALKSPEED_ATTRIBUTE or "ExpectedWalkSpeed");

                if type(v58) == "number" and (v58 == v58 and v58 >= 0) then
                    WalkSpeed = math.max(WalkSpeed, v58);
                end;

                if v57 < WalkSpeed then
                    local TransitionEnable = setting.TransitionEnable;

                    if (not TransitionEnable or TransitionEnable.StartRun == nil) and true or TransitionEnable.StartRun == true then
                        _beginGroundTransition("StartRun", "Run", p54);

                        return;
                    end;

                    u8 = "Run";
                    _applyStableLocomotionVisual("Run", p54);

                    return;
                end;

                local TransitionEnable = setting.TransitionEnable;

                if (not TransitionEnable or TransitionEnable.StartWalk == nil) and true or TransitionEnable.StartWalk == true then
                    _beginGroundTransition("StartWalk", "Walk", p54);

                    return;
                end;

                u8 = "Walk";
                _applyStableLocomotionVisual("Walk", p54);

                return;
            end;

            if p53 ~= "Idle" or u8 ~= "Run" and u8 ~= "Walk" then
                if u8 == p53 then
                    _applyStableLocomotionVisual(p53, p54);

                    return;
                end;

                local v59;

                if u2 == "Land" then
                    v59 = v55 < u14;
                else
                    v59 = false;
                end;

                if v59 and (p53 ~= "Walk" and p53 ~= "Run") then
                    return;
                end;

                u8 = p53;
                _applyStableLocomotionVisual(p53, p54);

                return;
            end;

            local v60;

            if u2 == "Land" then
                v60 = v55 < u14;
            else
                v60 = false;
            end;

            if v60 then
                return;
            end;

            if u15 then
                u15 = false;
                u8 = "Idle";
                local v61 = time();

                if u2 == "Land" and v61 < u14 then
                    return;
                end;

                animate:setBasePos("Idle");
                u2 = "Idle";
                u13 = 0;
                u14 = 0;

                return;
            end;

            if u18 > 0 and v55 < u18 then
                u8 = "Idle";
                local v62 = time();

                if u2 == "Land" and v62 < u14 then
                    return;
                end;

                animate:setBasePos("Idle");
                u2 = "Idle";
                u13 = 0;
                u14 = 0;

                return;
            end;

            local WalkSpeed = humanoid.WalkSpeed;
            local v63 = localPlayer:GetAttribute(setting.EXPECTED_WALKSPEED_ATTRIBUTE or "ExpectedWalkSpeed");

            if type(v63) == "number" and (v63 == v63 and v63 >= 0) then
                WalkSpeed = math.max(WalkSpeed, v63);
            end;

            if v57 < WalkSpeed then
                local TransitionEnable = setting.TransitionEnable;

                if (not TransitionEnable or TransitionEnable.StopRun == nil) and true or TransitionEnable.StopRun == true then
                    _beginGroundTransition("StopRun", "Idle", p54);

                    return;
                end;

                u8 = "Idle";
                local v64 = time();

                if u2 == "Land" and v64 < u14 then
                    return;
                end;

                animate:setBasePos("Idle");
                u2 = "Idle";
                u13 = 0;
                u14 = 0;

                return;
            end;

            local TransitionEnable = setting.TransitionEnable;

            if (not TransitionEnable or TransitionEnable.StopWalk == nil) and true or TransitionEnable.StopWalk == true then
                _beginGroundTransition("StopWalk", "Idle", p54);

                return;
            end;

            u8 = "Idle";
            local v65 = time();

            if u2 == "Land" and v65 < u14 then
                return;
            end;

            animate:setBasePos("Idle");
            u2 = "Idle";
            u13 = 0;
            u14 = 0;
        end;

        local function _maybeRecordSkipLocoStopWhileLanding() -- Line: 516
            -- upvalues: u3 (ref), character (copy), humanoid (copy), MOVE_INTENT_FOR_LOCO (copy), u8 (ref), u20 (ref), u20 (ref), setting (copy), localPlayer (copy), u15 (ref)
            local v66 = u3;
            local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");
            local v67;

            if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity;
                v67 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude;

                if v66 >= v67 then
                    v67 = v66;
                end;
            else
                v67 = v66;
            end;

            local v68;

            if MOVE_INTENT_FOR_LOCO <= humanoid.MoveDirection.Magnitude then
                local v69;

                if u8 == "Run" or u8 == "Walk" then
                    v69 = u20;
                else
                    v69 = u20;
                end;

                if v67 <= v69 then
                    v68 = "Idle";
                else
                    local WalkSpeed = humanoid.WalkSpeed;
                    local v70 = localPlayer:GetAttribute(setting.EXPECTED_WALKSPEED_ATTRIBUTE or "ExpectedWalkSpeed");

                    if type(v70) == "number" and (v70 == v70 and v70 >= 0) then
                        WalkSpeed = math.max(WalkSpeed, v70);
                    end;

                    local RUN_LOCOMOTION_WALKSPEED_THRESHOLD = setting.RUN_LOCOMOTION_WALKSPEED_THRESHOLD;
                    v68 = ((type(RUN_LOCOMOTION_WALKSPEED_THRESHOLD) ~= "number" or RUN_LOCOMOTION_WALKSPEED_THRESHOLD ~= RUN_LOCOMOTION_WALKSPEED_THRESHOLD) and 16 or RUN_LOCOMOTION_WALKSPEED_THRESHOLD) < WalkSpeed and "Run" or "Walk";
                end;
            else
                v68 = "Idle";
            end;

            if v68 == "Idle" and (u8 == "Run" or u8 == "Walk") then
                u15 = true;
            end;
        end;

        local function _applyGroundLocomotion(p71) -- Line: 523
            -- upvalues: character (copy), humanoid (copy), MOVE_INTENT_FOR_LOCO (copy), u8 (ref), u20 (ref), u20 (ref), setting (copy), localPlayer (copy), _refreshGroundLocomotion (copy)
            local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");
            local v72;

            if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity;
                v72 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude;

                if p71 >= v72 then
                    v72 = p71;
                end;
            else
                v72 = p71;
            end;

            local v73;

            if MOVE_INTENT_FOR_LOCO <= humanoid.MoveDirection.Magnitude then
                local v74;

                if u8 == "Run" or u8 == "Walk" then
                    v74 = u20;
                else
                    v74 = u20;
                end;

                if v72 <= v74 then
                    v73 = "Idle";
                else
                    local WalkSpeed = humanoid.WalkSpeed;
                    local v75 = localPlayer:GetAttribute(setting.EXPECTED_WALKSPEED_ATTRIBUTE or "ExpectedWalkSpeed");

                    if type(v75) == "number" and (v75 == v75 and v75 >= 0) then
                        WalkSpeed = math.max(WalkSpeed, v75);
                    end;

                    local RUN_LOCOMOTION_WALKSPEED_THRESHOLD = setting.RUN_LOCOMOTION_WALKSPEED_THRESHOLD;
                    v73 = ((type(RUN_LOCOMOTION_WALKSPEED_THRESHOLD) ~= "number" or RUN_LOCOMOTION_WALKSPEED_THRESHOLD ~= RUN_LOCOMOTION_WALKSPEED_THRESHOLD) and 16 or RUN_LOCOMOTION_WALKSPEED_THRESHOLD) < WalkSpeed and "Run" or "Walk";
                end;
            else
                v73 = "Idle";
            end;

            _refreshGroundLocomotion(v73, v72);
        end;

        local function _applyRunJumpLandSuppress(p76) -- Line: 532
            -- upvalues: setting (copy), u18 (ref)
            local LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP = setting.LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP;

            if type(LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP) == "number" and (LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP == LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP and LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP > 0) then
                u18 = p76 + LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP;

                return;
            end;

            u18 = p76;
        end;

        return {
            onRunning = function(p77) -- Line: 541, Name: onRunning
                -- upvalues: humanoid (copy), u3 (ref)
                local v78 = humanoid:GetState();

                if v78 ~= Enum.HumanoidStateType.Climbing and v78 ~= Enum.HumanoidStateType.Swimming then
                    u3 = p77;
                end;
            end,

            onJumping = function(p79) -- Line: 548, Name: onJumping
                -- upvalues: u1 (copy), u17 (ref), u8 (ref), u16 (ref), u9 (ref), u12 (ref), u10 (ref), animate (copy), u4 (ref), MIN_JUMP_ANIMATION_TIME (copy), u2 (ref)
                if p79 == false then
                    return;
                end;

                if u1.isFlightActive() then
                    return;
                end;

                u17 = u8 == "Run";
                u16 = time();

                if u9 or u12 then
                    if u12 then
                        u12();
                        u12 = nil;
                    end;

                    u10 = u10 + 1;
                    u9 = nil;
                end;

                animate:setBasePos("Jump");
                u4 = time() + MIN_JUMP_ANIMATION_TIME;
                u2 = "Jump";
            end,

            onFreeFalling = function(p80) -- Line: 563, Name: onFreeFalling
                -- upvalues: u6 (ref), u5 (ref), u16 (ref)
                if p80 and not u6 then
                    u6 = true;
                    u5 = time();

                    if u16 == 0 then
                        u16 = time();
                    end;
                elseif not p80 and u6 then
                    u6 = false;
                end;
            end,

            onClimbing = function(p81) -- Line: 575, Name: onClimbing
                -- upvalues: u3 (ref)
                u3 = p81;
            end,

            onSwimming = function(p82) -- Line: 579, Name: onSwimming
                -- upvalues: u3 (ref)
                u3 = p82;
            end,

            onStateChanged = function(p83, p84) -- Line: 583, Name: onStateChanged
                -- upvalues: u1 (copy), u15 (ref), u9 (ref), u12 (ref), u10 (ref), u6 (ref), u16 (ref), FALL_LAND_THRESHOLD (copy), localPlayer (copy), u13 (ref), u14 (ref), u17 (ref), LAND_ANIM_TIME (copy), setting (copy), u18 (ref), animate (copy), u2 (ref), LAND_LOCO_INTERRUPT_LOCK_SEC (copy)
                if p84 ~= Enum.HumanoidStateType.Landed then
                    return;
                end;

                if u1.isFlightActive() then
                    return;
                end;

                u15 = false;

                if u9 or u12 then
                    if u12 then
                        u12();
                        u12 = nil;
                    end;

                    u10 = u10 + 1;
                    u9 = nil;
                end;

                u6 = false;
                local v85 = FALL_LAND_THRESHOLD <= (u16 > 0 and time() - u16 or 0);

                if localPlayer:GetAttribute("SkillActionLock") and true or false then
                    u13 = 0;
                    u14 = 0;

                    if u17 then
                        u17 = false;
                        local v86 = time() + LAND_ANIM_TIME;
                        local LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP = setting.LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP;

                        if type(LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP) == "number" and (LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP == LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP and LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP > 0) then
                            u18 = v86 + LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP;

                            return;
                        end;

                        u18 = v86;
                    end;
                else
                    animate:setBasePos(v85 and "Land" or "LightLand");
                    u2 = "Land";
                    local v87 = time();
                    local v88 = v87 + LAND_ANIM_TIME;
                    u13 = v87 + LAND_LOCO_INTERRUPT_LOCK_SEC;
                    u14 = v88;

                    if u17 then
                        u17 = false;
                        local LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP = setting.LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP;

                        if type(LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP) == "number" and (LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP == LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP and LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP > 0) then
                            u18 = v88 + LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP;

                            return;
                        end;

                        u18 = v88;
                    end;
                end;
            end,

            update = function(p89) -- Line: 621, Name: update
                -- upvalues: u1 (copy), humanoid (copy), u6 (ref), u9 (ref), u12 (ref), u10 (ref), u13 (ref), u14 (ref), setting (copy), MOVE_INTENT_FOR_LOCO (copy), u2 (ref), animate (copy), u3 (ref), character (copy), u8 (ref), u20 (ref), u20 (ref), localPlayer (copy), u15 (ref), u5 (ref), u19 (copy), u4 (ref), _refreshGroundLocomotion (copy)
                local v90 = time();

                if u1.isFlightActive() then
                    return;
                end;

                if v90 < u1.getRollLockDeadline() then
                    return;
                end;

                local v91 = humanoid:GetState();
                local v92 = u6 or v91 == Enum.HumanoidStateType.Freefall;
                local v93 = humanoid.FloorMaterial ~= Enum.Material.Air;

                if v91 == Enum.HumanoidStateType.Swimming then
                    if u9 or u12 then
                        if u12 then
                            u12();
                            u12 = nil;
                        end;

                        u10 = u10 + 1;
                        u9 = nil;
                    end;

                    u13 = 0;
                    u14 = 0;
                    local SWIM_MOVE_DIRECTION_THRESHOLD = setting.SWIM_MOVE_DIRECTION_THRESHOLD;

                    if type(SWIM_MOVE_DIRECTION_THRESHOLD) ~= "number" or (SWIM_MOVE_DIRECTION_THRESHOLD ~= SWIM_MOVE_DIRECTION_THRESHOLD or SWIM_MOVE_DIRECTION_THRESHOLD < 0) then
                        SWIM_MOVE_DIRECTION_THRESHOLD = MOVE_INTENT_FOR_LOCO;
                    end;

                    local v94 = SWIM_MOVE_DIRECTION_THRESHOLD <= humanoid.MoveDirection.Magnitude and "Swim" or "SwimIdle";

                    if u2 ~= v94 then
                        animate:setBasePos(v94);
                        u2 = v94;
                    end;

                    return;
                end;

                if v91 == Enum.HumanoidStateType.Climbing then
                    if u9 or u12 then
                        if u12 then
                            u12();
                            u12 = nil;
                        end;

                        u10 = u10 + 1;
                        u9 = nil;
                    end;

                    u13 = 0;
                    u14 = 0;
                    animate:setBaseSpeed("Climb", u1.getRunAnimationSpeed(u3, "Climb"));

                    if u2 ~= "Climb" then
                        animate:setBasePos("Climb");
                        u2 = "Climb";
                    end;

                    return;
                end;

                if u13 > 0 and v90 < u13 then
                    local v95 = u3;
                    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");
                    local v96;

                    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                        local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity;
                        v96 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude;

                        if v95 >= v96 then
                            v96 = v95;
                        end;
                    else
                        v96 = v95;
                    end;

                    local v97;

                    if MOVE_INTENT_FOR_LOCO <= humanoid.MoveDirection.Magnitude then
                        local v98;

                        if u8 == "Run" or u8 == "Walk" then
                            v98 = u20;
                        else
                            v98 = u20;
                        end;

                        if v96 <= v98 then
                            v97 = "Idle";
                        else
                            local WalkSpeed = humanoid.WalkSpeed;
                            local v99 = localPlayer:GetAttribute(setting.EXPECTED_WALKSPEED_ATTRIBUTE or "ExpectedWalkSpeed");

                            if type(v99) == "number" and (v99 == v99 and v99 >= 0) then
                                WalkSpeed = math.max(WalkSpeed, v99);
                            end;

                            local RUN_LOCOMOTION_WALKSPEED_THRESHOLD = setting.RUN_LOCOMOTION_WALKSPEED_THRESHOLD;
                            v97 = ((type(RUN_LOCOMOTION_WALKSPEED_THRESHOLD) ~= "number" or RUN_LOCOMOTION_WALKSPEED_THRESHOLD ~= RUN_LOCOMOTION_WALKSPEED_THRESHOLD) and 16 or RUN_LOCOMOTION_WALKSPEED_THRESHOLD) < WalkSpeed and "Run" or "Walk";
                        end;
                    else
                        v97 = "Idle";
                    end;

                    if v97 == "Idle" and (u8 == "Run" or u8 == "Walk") then
                        u15 = true;
                    end;

                    return;
                end;

                local v100;

                if u2 == "Land" then
                    v100 = v90 < u14;
                else
                    v100 = false;
                end;

                if v100 then
                    local v101 = u3;
                    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");
                    local v102;

                    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                        local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity;
                        v102 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude;

                        if v101 >= v102 then
                            v102 = v101;
                        end;
                    else
                        v102 = v101;
                    end;

                    local v103;

                    if MOVE_INTENT_FOR_LOCO <= humanoid.MoveDirection.Magnitude then
                        local v104;

                        if u8 == "Run" or u8 == "Walk" then
                            v104 = u20;
                        else
                            v104 = u20;
                        end;

                        if v102 <= v104 then
                            v103 = "Idle";
                        else
                            local WalkSpeed = humanoid.WalkSpeed;
                            local v105 = localPlayer:GetAttribute(setting.EXPECTED_WALKSPEED_ATTRIBUTE or "ExpectedWalkSpeed");

                            if type(v105) == "number" and (v105 == v105 and v105 >= 0) then
                                WalkSpeed = math.max(WalkSpeed, v105);
                            end;

                            local RUN_LOCOMOTION_WALKSPEED_THRESHOLD = setting.RUN_LOCOMOTION_WALKSPEED_THRESHOLD;
                            v103 = ((type(RUN_LOCOMOTION_WALKSPEED_THRESHOLD) ~= "number" or RUN_LOCOMOTION_WALKSPEED_THRESHOLD ~= RUN_LOCOMOTION_WALKSPEED_THRESHOLD) and 16 or RUN_LOCOMOTION_WALKSPEED_THRESHOLD) < WalkSpeed and "Run" or "Walk";
                        end;
                    else
                        v103 = "Idle";
                    end;

                    if v103 == "Idle" and (u8 == "Run" or u8 == "Walk") then
                        u15 = true;
                    end;
                end;

                if v91 == Enum.HumanoidStateType.Jumping then
                    if u9 or u12 then
                        if u12 then
                            u12();
                            u12 = nil;
                        end;

                        u10 = u10 + 1;
                        u9 = nil;
                    end;

                    u13 = 0;
                    u14 = 0;

                    if u2 ~= "Jump" then
                        animate:setBasePos("Jump");
                        u2 = "Jump";
                    end;

                    return;
                end;

                if v92 then
                    if u9 or u12 then
                        if u12 then
                            u12();
                            u12 = nil;
                        end;

                        u10 = u10 + 1;
                        u9 = nil;
                    end;

                    u13 = 0;
                    u14 = 0;

                    if u4 <= v90 and (u19 <= v90 - u5 and u2 ~= "Fall") then
                        animate:setBasePos("Fall");
                        u2 = "Fall";
                    end;

                    return;
                end;

                if not v93 then
                    if u9 or u12 then
                        if u12 then
                            u12();
                            u12 = nil;
                        end;

                        u10 = u10 + 1;
                        u9 = nil;
                    end;

                    u13 = 0;
                    u14 = 0;

                    if u4 <= v90 and u2 ~= "Fall" then
                        animate:setBasePos("Fall");
                        u2 = "Fall";
                    end;

                    return;
                end;

                local v106 = u3;
                local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");
                local v107;

                if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                    local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity;
                    v107 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude;

                    if v106 >= v107 then
                        v107 = v106;
                    end;
                else
                    v107 = v106;
                end;

                local v108;

                if MOVE_INTENT_FOR_LOCO <= humanoid.MoveDirection.Magnitude then
                    local v109;

                    if u8 == "Run" or u8 == "Walk" then
                        v109 = u20;
                    else
                        v109 = u20;
                    end;

                    if v107 <= v109 then
                        v108 = "Idle";
                    else
                        local WalkSpeed = humanoid.WalkSpeed;
                        local v110 = localPlayer:GetAttribute(setting.EXPECTED_WALKSPEED_ATTRIBUTE or "ExpectedWalkSpeed");

                        if type(v110) == "number" and (v110 == v110 and v110 >= 0) then
                            WalkSpeed = math.max(WalkSpeed, v110);
                        end;

                        local RUN_LOCOMOTION_WALKSPEED_THRESHOLD = setting.RUN_LOCOMOTION_WALKSPEED_THRESHOLD;
                        v108 = ((type(RUN_LOCOMOTION_WALKSPEED_THRESHOLD) ~= "number" or RUN_LOCOMOTION_WALKSPEED_THRESHOLD ~= RUN_LOCOMOTION_WALKSPEED_THRESHOLD) and 16 or RUN_LOCOMOTION_WALKSPEED_THRESHOLD) < WalkSpeed and "Run" or "Walk";
                    end;
                else
                    v108 = "Idle";
                end;

                _refreshGroundLocomotion(v108, v107);
            end,

            abortDriver = function() -- Line: 149, Name: abortDriver
                -- upvalues: u9 (ref), u12 (ref), u10 (ref)
                if not (u9 or u12) then
                    return;
                end;

                if u12 then
                    u12();
                    u12 = nil;
                end;

                u10 = u10 + 1;
                u9 = nil;
            end,

            clearLandTimingWindows = function() -- Line: 164, Name: clearLandTimingWindows
                -- upvalues: u13 (ref), u14 (ref)
                u13 = 0;
                u14 = 0;
            end,

            getGroundStable = function() -- Line: 709, Name: getGroundStable
                -- upvalues: u8 (ref)
                return u8;
            end,

            resetPose = function() -- Line: 713, Name: resetPose
                -- upvalues: u2 (ref)
                u2 = "";
            end,

            destroy = function() -- Line: 717, Name: destroy
                -- upvalues: u9 (ref), u12 (ref), u10 (ref), u13 (ref), u14 (ref)
                if u9 or u12 then
                    if u12 then
                        u12();
                        u12 = nil;
                    end;

                    u10 = u10 + 1;
                    u9 = nil;
                end;

                u13 = 0;
                u14 = 0;
            end
        };
    end
};