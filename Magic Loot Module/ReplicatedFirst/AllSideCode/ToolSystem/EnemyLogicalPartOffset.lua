-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = {
    Root = CFrame.new(),
    HumanoidRootPart = CFrame.new(),
    Torso = CFrame.new(0, 0.5, 0),
    UpperTorso = CFrame.new(0, 0.6, 0),
    Head = CFrame.new(0, 1.5, 0),
    LeftHand = CFrame.new(-1.2, 0.4, -0.3),
    RightHand = CFrame.new(1.2, 0.4, -0.3),
    LeftArm = CFrame.new(-1, 0.5, 0),
    RightArm = CFrame.new(1, 0.5, 0),
    Weapon = CFrame.new(1.2, 0.4, -0.8),
    Mouth = CFrame.new(0, 1.35, -0.55),
    CastOrigin = CFrame.new(0, 1.2, -1)
};
local u3 = {
    hrp = "HumanoidRootPart",
    root = "Root",
    head = "Head",
    hand = "RightHand",
    righthand = "RightHand",
    lefthand = "LeftHand",
    weapon = "Weapon",
    cast = "CastOrigin",
    castorigin = "CastOrigin",
    mouth = "Mouth"
};

local function _normalizeKey(p4) -- Line: 54
    -- upvalues: u3 (copy)
    local v5 = string.gsub(p4, "%s+", "");

    return u3[string.lower(v5)] or v5;
end;

function u1.getLocalOffset(p6, p7) -- Line: 71
    -- upvalues: u3 (copy), u2 (copy)
    local v8 = string.gsub(p6, "%s+", "");
    local v9 = u3[string.lower(v8)] or v8;

    if type(p7) == "table" and type(p7.logicalPartOffsets) == "table" then
        local v10 = p7.logicalPartOffsets[v9] or p7.logicalPartOffsets[p6];

        if typeof(v10) == "CFrame" then
            return v10;
        end;

        if typeof(v10) == "Vector3" then
            return CFrame.new(v10);
        end;

        if type(v10) == "table" and typeof(v10.x) == "number" then
            return CFrame.new(v10.x, v10.y or 0, v10.z or 0);
        end;
    end;

    return u2[v9] or CFrame.new();
end;

function u1.resolveWorldCFrame(p11, p12, p13) -- Line: 96
    -- upvalues: u1 (copy)
    return p11 * u1.getLocalOffset(p12, p13);
end;

function u1.resolveWorldPosition(p14, p15, p16) -- Line: 108
    -- upvalues: u1 (copy)
    return u1.resolveWorldCFrame(p14, p15, p16).Position;
end;

return u1;