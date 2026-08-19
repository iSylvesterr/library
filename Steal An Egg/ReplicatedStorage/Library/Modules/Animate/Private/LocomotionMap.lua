-- Decompiled with Potassium's decompiler.

local Constants = require(script.Parent.Constants);

return {
    run = {
        Speed = Constants.BASE_RUN_SPEED,
        Velocity = Vector2.yAxis * Constants.BASE_RUN_SPEED
    },
    walk = {
        Speed = Constants.BASE_WALK_SPEED,
        Velocity = Vector2.yAxis * Constants.BASE_WALK_SPEED
    }
};