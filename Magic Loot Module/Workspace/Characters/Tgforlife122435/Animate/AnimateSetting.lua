-- Decompiled with Potassium's decompiler.

return {
    CRAB_STEP_ENABLE = false,
    FALL_LAND_THRESHOLD = 0.6,
    LAND_ANIM_TIME = 0.48,
    LAND_LOCO_INTERRUPT_LOCK_SEC = 0.12,
    LAND_POST_STOP_SUPPRESS_AFTER_RUN_JUMP = 0.35,
    WALK_ANIMATION_SPEED = 0.1,
    MOVE_INTENT_FOR_LOCO = 0.01,
    STATIONARY_LOCO_SPEED = 0.5,
    STATIONARY_LOCO_SPEED_ENTER = 0.12,
    WALK_ACTION_SCALE_SPEED = 15,
    RUN_ACTION_SCALE_SPEED = 21,
    CLIMB_ACTION_SCALE_SPEED = 20,
    MIN_JUMP_ANIMATION_TIME = 0.3,
    FREEFALL_MIN_DURATION = 0.08,
    DIR_HYSTERESIS = 10,
    SWIM_MOVE_DIRECTION_THRESHOLD = 0.01,
    TransitionEnable = {
        StartRun = true,
        StartWalk = true,
        StopRun = true,
        StopWalk = false
    },
    RUN_LOCOMOTION_WALKSPEED_THRESHOLD = 16,
    EXPECTED_WALKSPEED_ATTRIBUTE = "ExpectedWalkSpeed",
    Transition = {
        StartRun = {
            fadeIn = 0.35,
            fadeOut = 0.2,
            middleDuration = 0.65,
            animationSpeed = 1,
            commitStableAfterSeconds = 0.3
        },
        StopRun = {
            fadeIn = 0.15,
            fadeOut = 0.15,
            middleDuration = 0,
            animationSpeed = 1,
            commitStableAfterSeconds = 0.3
        },
        StartWalk = {
            fadeIn = 0.3,
            fadeOut = 0.15,
            middleDuration = 0,
            animationSpeed = 1
        },
        StopWalk = {
            fadeIn = 0.3,
            fadeOut = 0.15,
            middleDuration = 0,
            animationSpeed = 0.5
        }
    },
    GroundLocomotionDriver = {
        transitionMinVisibleSeconds = 0.06,
        debugPrintGroundTransition = false
    },
    Fov = {
        sprintEnterSpeed = 16,
        sprintExitSpeed = 0.01,
        sprintMinHold = 0.35,
        sprintResumeDelay = 0,
        maxChangeFov = 8,
        changeSpeed = 30,
        resumeSpeed = 15
    }
};