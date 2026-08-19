-- Decompiled with Potassium's decompiler.

local GearImages = script.Parent.GearImages;

local function getGearImage(p1) -- Line: 3
    -- upvalues: GearImages (copy)
    local v2 = GearImages:FindFirstChild(p1);

    return v2 and v2.Value or "";
end;

local v3 = {};
local v4 = {};
local Crowbar = GearImages:FindFirstChild("Crowbar");
v4.IMG = Crowbar and Crowbar.Value or "";
v3.Data = v4;

return v3;