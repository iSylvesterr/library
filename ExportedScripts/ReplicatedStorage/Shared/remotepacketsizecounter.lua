-- Decompiled with Potassium's decompiler.

local u1 = {
    ["nil"] = 0,
    EnumItem = 4,
    boolean = 1,
    number = 8,
    UDim = 8,
    UDim2 = 16,
    Ray = 24,
    Faces = 6,
    Axes = 6,
    BrickColor = 4,
    Color3 = 12,
    Vector2 = 8,
    Vector3 = 12,
    Instance = 4,
    Vector2int16 = 4,
    Vector3int16 = 6,
    NumberSequenceKeypoint = 12,
    ColorSequenceKeypoint = 16,
    NumberRange = 8,
    Rect = 16,
    PhysicalProperties = 20,
    Color3uint8 = 3
};
local u2 = {
    [CFrame.Angles(0, 0, 0)] = true,
    [CFrame.Angles(0, 3.141592653589793, 0)] = true,
    [CFrame.Angles(1.5707963267948966, 0, 0)] = true,
    [CFrame.Angles(-1.5707963267948966, -3.141592653589793, 0)] = true,
    [CFrame.Angles(0, 3.141592653589793, 3.141592653589793)] = true,
    [CFrame.Angles(0, 0, 3.141592653589793)] = true,
    [CFrame.Angles(-1.5707963267948966, 0, 0)] = true,
    [CFrame.Angles(1.5707963267948966, 3.141592653589793, 0)] = true,
    [CFrame.Angles(0, 3.141592653589793, 1.5707963267948966)] = true,
    [CFrame.Angles(0, 0, -1.5707963267948966)] = true,
    [CFrame.Angles(0, 1.5707963267948966, 1.5707963267948966)] = true,
    [CFrame.Angles(0, -1.5707963267948966, -1.5707963267948966)] = true,
    [CFrame.Angles(0, 0, 1.5707963267948966)] = true,
    [CFrame.Angles(0, -3.141592653589793, -1.5707963267948966)] = true,
    [CFrame.Angles(0, -1.5707963267948966, 1.5707963267948966)] = true,
    [CFrame.Angles(0, 1.5707963267948966, -1.5707963267948966)] = true,
    [CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0)] = true,
    [CFrame.Angles(1.5707963267948966, 1.5707963267948966, 0)] = true,
    [CFrame.Angles(0, -1.5707963267948966, 0)] = true,
    [CFrame.Angles(0, 1.5707963267948966, 0)] = true,
    [CFrame.Angles(1.5707963267948966, -1.5707963267948966, 0)] = true,
    [CFrame.Angles(-1.5707963267948966, 1.5707963267948966, 0)] = true,
    [CFrame.Angles(0, 1.5707963267948966, 3.141592653589793)] = true,
    [CFrame.Angles(0, -1.5707963267948966, 3.141592653589793)] = true
};

local function GetDataByteSize(p3, p4) -- Line: 69
    -- upvalues: u1 (copy), GetDataByteSize (copy), u2 (copy)
    local v5 = typeof(p3);

    if u1[v5] then
        return u1[v5];
    end;

    if v5 == "string" then
        return #p3 + 2;
    end;

    if v5 == "table" then
        if p4[p3] then
            return 0;
        end;

        p4[p3] = true;
        local v6 = 1;
        local v7 = 0;
        local v8 = 0;
        local v9 = true;

        for i, v in next, p3 do
            if i == v6 then
                v6 = v6 + 1;
            else
                v9 = false;
            end;

            v7 = v7 + (GetDataByteSize(i, p4) + 1);
            v8 = v8 + (GetDataByteSize(v, p4) + 1);
        end;

        return 1 + (v9 and #p3 + v8 or v7 + v8);
    end;

    if v5 ~= "CFrame" then
        if v5 ~= "NumberSequence" and v5 ~= "ColorSequence" then
            warn("Unsupported data type: " .. v5);

            return 0;
        end;

        local v10 = 4;

        for _, v in next, p3.Keypoints do
            v10 = v10 + GetDataByteSize(v, p4);
        end;

        return v10;
    end;

    local v11 = false;

    for i in next, u2 do
        if i == p3.Rotation then
            v11 = true;
            break;
        end;
    end;

    return v11 and 13 or 21;
end;

local v16 = {
    RemoteOverhead = 9,
    TypeOverhead = 1,

    GetPacketSize = function(p12) -- Line: 150, Name: GetPacketSize
        -- upvalues: GetDataByteSize (copy)
        local v13 = p12.IgnoreRemoteOffset and 0 or 9;
        local v14 = {};

        for _, v in ipairs(p12.PacketData) do
            v13 = v13 + (GetDataByteSize(v, v14) + 1);
        end;

        return v13;
    end,

    GetDataByteSize = function(p15) -- Line: 164, Name: GetDataByteSize
        -- upvalues: GetDataByteSize (copy)
        return GetDataByteSize(p15, {});
    end
};
table.freeze(v16);

return v16;