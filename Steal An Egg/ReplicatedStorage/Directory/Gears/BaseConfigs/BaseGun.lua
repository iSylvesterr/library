-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types.ToolConfigs);
local v1 = {
    __index = require(script.Parent.Default)
};
local v2 = setmetatable({}, v1);
v2.PROJECTILE_SPEED = 250;
v2.PROJECTILE_ACCELERATION = Vector3.new(0, 0, 0);
v2.PROJECTILE_SIZE = Vector3.new(0.6, 0.2, 0.6);
v2.PROJECTILE_COLOR = Color3.new(1, 0.9, 0.2);
v2.PROJECTILE_TEMPLATE = nil;
v2.MAX_RANGE = 1500;
v2.DAMAGE = 25;
v2.RAGDOLL_FORCE = 50;
v2.RAGDOLL_DURATION = 0.8;
v2.FORCE_RANDOMNESS = 0.2;
v2.SHOOT_VFX = nil;
v2.HIT_VFX = nil;
v2.IMPACT_VFX_COLOR = Color3.new(1, 0.6, 0);
v2.IMPACT_VFX_SIZE = 4;
v2.IMPACT_DECAL = "rbxassetid://0";
v2.IMPACT_LIGHT_ENABLED = true;
v2.IMPACT_LIGHT_COLOR = Color3.new(1, 0.6, 0);
v2.IMPACT_LIGHT_RANGE = 12;
v2.RECOIL_MAGNITUDE = 2;
v2.COOLDOWN = 0.3;
v2.TRAJECTORY = {
    type = "Default"
};

return v2;