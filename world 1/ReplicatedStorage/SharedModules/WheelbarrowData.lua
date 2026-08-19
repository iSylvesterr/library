-- Decompiled with Potassium's decompiler.

local GearImages = script.Parent.GearImages;

local function getGearImage(p1) -- Line: 3
    -- upvalues: GearImages (copy)
    local v2 = GearImages:FindFirstChild(p1);

    return v2 and v2.Value or "";
end;

local v3 = {};
local v4 = {
    Name = "Wheelbarrow"
};
local Wheelbarrow = GearImages:FindFirstChild("Wheelbarrow");
v4.IMG = Wheelbarrow and Wheelbarrow.Value or "";
v3.Data = v4;

return v3;