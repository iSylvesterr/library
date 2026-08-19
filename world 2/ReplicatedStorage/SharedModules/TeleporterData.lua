-- Decompiled with Potassium's decompiler.

local GearImages = script.Parent.GearImages;

local function getGearImage(p1) -- Line: 3
    -- upvalues: GearImages (copy)
    local v2 = GearImages:FindFirstChild(p1);

    return v2 and v2.Value or "";
end;

local v3 = {};
local v4 = {};
local v5 = {
    Name = "Teleporter",
    Description = "Teleport around your garden!",
    TeleportDistance = 15
};
local Teleporter = GearImages:FindFirstChild("Teleporter");
v5.IMG = Teleporter and Teleporter.Value or "";
v4[1] = v5;
v3.Data = v4;

return v3;