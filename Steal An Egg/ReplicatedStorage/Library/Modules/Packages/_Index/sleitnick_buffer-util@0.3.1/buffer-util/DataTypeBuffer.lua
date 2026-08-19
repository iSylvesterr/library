-- Decompiled with Potassium's decompiler.

require(script.Parent.Types);
local u1 = {
    DataTypesToString = {
        [BrickColor] = "BrickColor",
        [CFrame] = "CFrame",
        [Color3] = "Color3",
        [DateTime] = "DateTime",
        [Ray] = "Ray",
        [Rect] = "Rect",
        [Region3] = "Region3",
        [Region3int16] = "Region3int16",
        [UDim] = "UDim",
        [UDim2] = "UDim2",
        [Vector2] = "Vector2",
        [Vector3] = "Vector3",
        [Vector2int16] = "Vector2int16",
        [Vector3int16] = "Vector3int16"
    },
    ReadWrite = {}
};
u1.ReadWrite.BrickColor = {
    write = function(p2, p3) -- Line: 32, Name: write
        p2:WriteUInt16(p3.Number);
    end,

    read = function(p4) -- Line: 36, Name: read
        local v5 = p4:ReadUInt16();

        return BrickColor.new(v5);
    end
};
u1.ReadWrite.CFrame = {
    write = function(p6, p7) -- Line: 43, Name: write
        -- upvalues: u1 (copy)
        u1.ReadWrite.Vector3.write(p6, p7.Position);
        u1.ReadWrite.Vector3.write(p6, p7.XVector);
        u1.ReadWrite.Vector3.write(p6, p7.YVector);
        u1.ReadWrite.Vector3.write(p6, p7.ZVector);
    end,

    read = function(p8) -- Line: 50, Name: read
        -- upvalues: u1 (copy)
        local v9 = u1.ReadWrite.Vector3.read(p8);
        local v10 = u1.ReadWrite.Vector3.read(p8);
        local v11 = u1.ReadWrite.Vector3.read(p8);
        local v12 = u1.ReadWrite.Vector3.read(p8);

        return CFrame.fromMatrix(v9, v10, v11, v12);
    end
};
u1.ReadWrite.Color3 = {
    write = function(p13, p14) -- Line: 60, Name: write
        p13:WriteFloat32(p14.R);
        p13:WriteFloat32(p14.G);
        p13:WriteFloat32(p14.B);
    end,

    read = function(p15) -- Line: 66, Name: read
        local v16 = p15:ReadFloat32();
        local v17 = p15:ReadFloat32();
        local v18 = p15:ReadFloat32();

        return Color3.new(v16, v17, v18);
    end
};
u1.ReadWrite.DateTime = {
    write = function(p19, p20) -- Line: 75, Name: write
        p19:WriteFloat64(p20.UnixTimestampMillis);
    end,

    read = function(p21) -- Line: 79, Name: read
        local v22 = p21:ReadFloat64();

        return DateTime.fromUnixTimestampMillis(v22);
    end
};
u1.ReadWrite.Ray = {
    write = function(p23, p24) -- Line: 86, Name: write
        -- upvalues: u1 (copy)
        u1.ReadWrite.Vector3.write(p23, p24.Origin);
        u1.ReadWrite.Vector3.write(p23, p24.Direction);
    end,

    read = function(p25) -- Line: 91, Name: read
        -- upvalues: u1 (copy)
        local v26 = u1.ReadWrite.Vector3.read(p25);
        local v27 = u1.ReadWrite.Vector3.read(p25);

        return Ray.new(v26, v27);
    end
};
u1.ReadWrite.Rect = {
    write = function(p28, p29) -- Line: 99, Name: write
        -- upvalues: u1 (copy)
        u1.ReadWrite.Vector3.write(p28, p29.Min);
        u1.ReadWrite.Vector3.write(p28, p29.Max);
    end,

    read = function(p30) -- Line: 104, Name: read
        -- upvalues: u1 (copy)
        local v31 = u1.ReadWrite.Vector3.read(p30);
        local v32 = u1.ReadWrite.Vector3.read(p30);

        return Rect.new(v31, v32);
    end
};
u1.ReadWrite.Region3 = {
    write = function(p33, p34) -- Line: 112, Name: write
        -- upvalues: u1 (copy)
        local Position = p34.CFrame.Position;
        local v35 = p34.Size * 0.5;
        u1.ReadWrite.Vector3.write(p33, Position - v35);
        u1.ReadWrite.Vector3.write(p33, Position + v35);
    end,

    read = function(p36) -- Line: 121, Name: read
        -- upvalues: u1 (copy)
        local v37 = u1.ReadWrite.Vector3.read(p36);
        local v38 = u1.ReadWrite.Vector3.read(p36);

        return Region3.new(v37, v38);
    end
};
u1.ReadWrite.Region3int16 = {
    write = function(p39, p40) -- Line: 129, Name: write
        -- upvalues: u1 (copy)
        u1.ReadWrite.Vector3int16.write(p39, p40.Min);
        u1.ReadWrite.Vector3int16.write(p39, p40.Max);
    end,

    read = function(p41) -- Line: 134, Name: read
        -- upvalues: u1 (copy)
        local v42 = u1.ReadWrite.Vector3int16.read(p41);
        local v43 = u1.ReadWrite.Vector3int16.read(p41);

        return Region3int16.new(v42, v43);
    end
};
u1.ReadWrite.UDim = {
    write = function(p44, p45) -- Line: 142, Name: write
        p44:WriteFloat32(p45.Scale);
        p44:WriteInt32(p45.Offset);
    end,

    read = function(p46) -- Line: 147, Name: read
        local v47 = p46:ReadFloat32();
        local v48 = p46:ReadInt32();

        return UDim.new(v47, v48);
    end
};
u1.ReadWrite.UDim2 = {
    write = function(p49, p50) -- Line: 155, Name: write
        -- upvalues: u1 (copy)
        u1.ReadWrite.UDim.write(p49, p50.X);
        u1.ReadWrite.UDim.write(p49, p50.Y);
    end,

    read = function(p51) -- Line: 160, Name: read
        -- upvalues: u1 (copy)
        local v52 = u1.ReadWrite.UDim.read(p51);
        local v53 = u1.ReadWrite.UDim.read(p51);

        return UDim2.new(v52, v53);
    end
};
u1.ReadWrite.Vector2 = {
    write = function(p54, p55) -- Line: 168, Name: write
        p54:WriteFloat32(p55.X);
        p54:WriteFloat32(p55.Y);
    end,

    read = function(p56) -- Line: 173, Name: read
        local v57 = p56:ReadFloat32();
        local v58 = p56:ReadFloat32();

        return Vector2.new(v57, v58);
    end
};
u1.ReadWrite.Vector3 = {
    write = function(p59, p60) -- Line: 181, Name: write
        p59:WriteFloat32(p60.X);
        p59:WriteFloat32(p60.Y);
        p59:WriteFloat32(p60.Z);
    end,

    read = function(p61) -- Line: 187, Name: read
        local v62 = p61:ReadFloat32();
        local v63 = p61:ReadFloat32();
        local v64 = p61:ReadFloat32();

        return Vector3.new(v62, v63, v64);
    end
};
u1.ReadWrite.Vector2int16 = {
    write = function(p65, p66) -- Line: 196, Name: write
        p65:WriteInt16(p66.X);
        p65:WriteInt16(p66.Y);
    end,

    read = function(p67) -- Line: 201, Name: read
        local v68 = p67:ReadInt16();
        local v69 = p67:ReadInt16();

        return Vector2int16.new(v68, v69);
    end
};
u1.ReadWrite.Vector3int16 = {
    write = function(p70, p71) -- Line: 209, Name: write
        p70:WriteInt16(p71.X);
        p70:WriteInt16(p71.Y);
        p70:WriteInt16(p71.Z);
    end,

    read = function(p72) -- Line: 215, Name: read
        local v73 = p72:ReadInt16();
        local v74 = p72:ReadInt16();
        local v75 = p72:ReadInt16();

        return Vector3int16.new(v73, v74, v75);
    end
};

return u1;