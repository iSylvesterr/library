-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new(p2, p3, p4, p5) -- Line: 60
    -- upvalues: u1 (copy)
    local v6 = setmetatable({
        X = p2,
        Y = p3,
        Z = p4,
        W = p5
    }, u1);
    table.freeze(v6);

    return v6;
end;

function u1.euler(p7, p8, p9) -- Line: 81
    -- upvalues: u1 (copy)
    local v10 = math.cos(p7 * 0.5);
    local v11 = math.cos(p8 * 0.5);
    local v12 = math.cos(p9 * 0.5);
    local v13 = math.sin(p7 * 0.5);
    local v14 = math.sin(p8 * 0.5);
    local v15 = math.sin(p9 * 0.5);

    return u1.new(v10 * v14 * v15 + v11 * v12 * v13, v10 * v12 * v14 - v11 * v13 * v15, v10 * v11 * v15 - v12 * v13 * v14, v13 * v14 * v15 + v10 * v11 * v12);
end;

function u1.axisAngle(p16, p17) -- Line: 105
    -- upvalues: u1 (copy)
    local v18 = p17 / 2;
    local v19 = math.sin(v18);

    return u1.new(v19 * p16.X, v19 * p16.Y, v19 * p16.Z, (math.cos(v18)));
end;

function u1.lookRotation(p20, p21) -- Line: 122
    -- upvalues: u1 (copy)
    local Unit = p20.Unit;
    local v22 = (p21 == nil and Vector3.new(0, 1, 0) or p21.Unit):Cross(Unit);
    local v23 = Unit:Cross(v22);
    local X = v22.X;
    local Y = v22.Y;
    local Z = v22.Z;
    local X2 = v23.X;
    local Y2 = v23.Y;
    local Z2 = v23.Z;
    local X3 = Unit.X;
    local Y3 = Unit.Y;
    local Z3 = Unit.Z;
    local v24 = X + Y2 + Z3;

    if v24 > 0 then
        local v25 = math.sqrt(v24 + 1);

        return u1.new((Z2 - Y3) * v25, (X3 - Z) * v25, (Y - X2) * v25, v25 * 0.5);
    end;

    if Y2 <= X and Z3 <= X then
        local v26 = math.sqrt(1 + X - Y2 - Z3);
        local v27 = 0.5 / v26;

        return u1.new(v26 * 0.5, (Y + X2) * v27, (Z + X3) * v27, (Z2 - Y3) * v27);
    end;

    if Z3 < Y2 then
        local v28 = math.sqrt(1 + Y2 - X - Z3);
        local v29 = 0.5 / v28;

        return u1.new((X2 + Y) * v29, v28 * 0.5, (Y3 + Z2) * v29, (X3 - Z) * v29);
    end;

    local v30 = math.sqrt(Z3 + 1 - X - Y2);
    local v31 = 0.5 / v30;

    return u1.new((X3 + Z) * v31, (Y3 + Z2) * v31, v30 * 0.5, (Y - X2) * v31);
end;

function u1.cframe(p32) -- Line: 179
    -- upvalues: u1 (copy)
    local _, _, _, v33, v34, v35, v36, v37, v38, v39, v40, v41 = p32:Orthonormalize():GetComponents();
    local v42 = v33 + v37 + v41;
    local v43, v44, v45, v46;

    if v42 > 0 then
        local v47 = math.sqrt(v42 + 1) * 2;
        v43 = (v40 - v38) / v47;
        v44 = (v35 - v39) / v47;
        v45 = (v36 - v34) / v47;
        v46 = v47 * 0.25;
    elseif v37 < v33 and v41 < v33 then
        local v48 = math.sqrt(1 + v33 - v37 - v41) * 2;
        v43 = v48 * 0.25;
        v44 = (v34 + v36) / v48;
        v45 = (v35 + v39) / v48;
        v46 = (v40 - v38) / v48;
    elseif v41 < v37 then
        local v49 = math.sqrt(1 + v37 - v33 - v41) * 2;
        v43 = (v34 + v36) / v49;
        v44 = v49 * 0.25;
        v45 = (v38 + v40) / v49;
        v46 = (v35 - v39) / v49;
    else
        local v50 = math.sqrt(1 + v41 - v33 - v37) * 2;
        v43 = (v35 + v39) / v50;
        v44 = (v38 + v40) / v50;
        v45 = v50 * 0.25;
        v46 = (v36 - v34) / v50;
    end;

    return u1.new(v43, v44, v45, v46);
end;

function u1.Dot(p51, p52) -- Line: 226
    return p51.X * p52.X + p51.Y * p52.Y + p51.Z * p52.Z + p51.W * p52.W;
end;

function u1.Slerp(p53, p54, p55) -- Line: 246
    -- upvalues: u1 (copy)
    local v56 = p53:Dot(p54);
    local v57;

    if v56 < 0 then
        v56 = -v56;
        v57 = true;
    else
        v57 = false;
    end;

    local v58;

    if v56 > 0.99999 then
        v58 = 1 - p55;

        if v57 then
            p55 = -p55;
        end;
    else
        local v59 = math.acos(v56);
        local v60 = 1 / math.sin(v59);
        v58 = math.sin((1 - p55) * v59) * v60;

        if v57 then
            p55 = -math.sin(p55 * v59) * v60;
        else
            p55 = math.sin(p55 * v59) * v60;
        end;
    end;

    return u1.new(v58 * p53.X + p55 * p54.X, v58 * p53.Y + p55 * p54.Y, v58 * p53.Z + p55 * p54.Z, v58 * p53.W + p55 * p54.W);
end;

function u1.Angle(p61, p62) -- Line: 283
    local v63 = p61:Dot(p62);
    local v64 = math.abs(v63);
    local v65 = math.min(v64, 1);

    return v65 > 0.99999 and 0 or math.acos(v65) * 2;
end;

function u1.RotateTowards(p66, p67, p68) -- Line: 305
    local v69 = p66:Angle(p67);

    if v69 == 0 then
        return p66;
    end;

    return p66:Slerp(p67, p68 / v69);
end;

function u1.ToCFrame(p70, p71) -- Line: 340
    local v72 = p71 == nil and Vector3.new(0, 0, 0) or p71;

    return CFrame.new(v72.X, v72.Y, v72.Z, p70.X, p70.Y, p70.Z, p70.W);
end;

function u1.ToEulerAngles(p73) -- Line: 358
    local v74 = p73.X * p73.Y + p73.Z * p73.W;

    if v74 > 0.49999 then
        local v75 = math.atan2(p73.X, p73.W) * 2;

        return Vector3.new(0, v75, 1.5707963267948966);
    end;

    if v74 < -0.49999 then
        local v76 = math.atan2(p73.X, p73.W) * -2;

        return Vector3.new(0, v76, -1.5707963267948966);
    end;

    local v77 = p73.Y * p73.Y;
    local v78 = p73.Z * p73.Z;
    local v79 = math.atan2(p73.X * 2 * p73.W - p73.Y * 2 * p73.Z, 1 - p73.X * p73.X * 2 - v78 * 2);
    local v80 = math.atan2(p73.Y * 2 * p73.W - p73.X * 2 * p73.Z, 1 - v77 * 2 - v78 * 2);
    local v81 = math.asin(v74 * 2);

    return Vector3.new(v79, v80, v81);
end;

function u1.ToAxisAngle(p82) -- Line: 388
    local v83 = math.sqrt(p82.X * p82.X + p82.Y * p82.Y + p82.Z * p82.Z);

    if math.abs(v83) < 0.00001 or (p82.W > 1 or p82.W < -1) then
        return Vector3.new(0, 1, 0), 0;
    end;

    local v84 = 1 / v83;

    return Vector3.new(p82.X * v84, p82.Y * v84, p82.Z * v84), math.acos(p82.W) * 2;
end;

function u1.Inverse(p85) -- Line: 414
    -- upvalues: u1 (copy)
    local v86 = 1 / p85:Dot(p85);

    return u1.new(-p85.X * v86, -p85.Y * v86, -p85.Z * v86, p85.W * v86);
end;

function u1.Conjugate(p87) -- Line: 431
    -- upvalues: u1 (copy)
    return u1.new(-p87.X, -p87.Y, -p87.Z, p87.W);
end;

function u1.Normalize(p88) -- Line: 446
    -- upvalues: u1 (copy)
    local v89 = p88:Magnitude();

    if v89 < 0.00001 then
        return u1.identity;
    end;

    return u1.new(p88.X / v89, p88.Y / v89, p88.Z / v89, p88.W / v89);
end;

function u1.Magnitude(p90) -- Line: 467
    local v91 = p90:Dot(p90);

    return math.sqrt(v91);
end;

function u1.SqrMagnitude(p92) -- Line: 482
    return p92:Dot(p92);
end;

function u1._MulVector3(p93, p94) -- Line: 486
    local v95 = p93.X * 2;
    local v96 = p93.Y * 2;
    local v97 = p93.Z * 2;
    local v98 = p93.X * v95;
    local v99 = p93.Y * v96;
    local v100 = p93.Z * v97;
    local v101 = p93.X * v96;
    local v102 = p93.X * v97;
    local v103 = p93.Y * v97;
    local v104 = p93.W * v95;
    local v105 = p93.W * v96;
    local v106 = p93.W * v97;

    return Vector3.new((1 - (v99 + v100)) * p94.X + (v101 - v106) * p94.Y + (v102 + v105) * p94.Z, (v101 + v106) * p94.X + (1 - (v98 + v100)) * p94.Y + (v103 - v104) * p94.Z, (v102 - v105) * p94.X + (v103 + v104) * p94.Y + (1 - (v98 + v99)) * p94.Z);
end;

function u1._MulQuaternion(p107, p108) -- Line: 508
    -- upvalues: u1 (copy)
    return u1.new(p107.W * p108.X + p107.X * p108.W + p107.Y * p108.Z - p107.Z * p108.Y, p107.W * p108.Y + p107.Y * p108.W + p107.Z * p108.X - p107.X * p108.Z, p107.W * p108.Z + p107.Z * p108.W + p107.X * p108.Y - p107.Y * p108.X, p107.W * p108.W - p107.X * p108.X - p107.Y * p108.Y - p107.Z * p108.Z);
end;

function u1.__mul(p109, p110) -- Line: 526
    -- upvalues: u1 (copy)
    local v111 = typeof(p110);

    if v111 == "Vector3" then
        return u1._MulVector3(p109, p110);
    end;

    if v111 == "table" and getmetatable(p110) == u1 then
        return u1._MulQuaternion(p109, p110);
    end;

    error(`cannot multiply quaternion with type {v111}`, 2);
end;

function u1.__unm(p112) -- Line: 537
    -- upvalues: u1 (copy)
    return u1.new(-p112.X, -p112.Y, -p112.Z, -p112.W);
end;

function u1.__eq(p113, p114) -- Line: 541
    local v115;

    if p113.X == p114.X and (p113.Y == p114.Y and p113.Z == p114.Z) then
        v115 = p113.W == p114.W;
    else
        v115 = false;
    end;

    return v115;
end;

function u1.__tostring(p116) -- Line: 545
    return `{p116.X}, {p116.Y}, {p116.Z}, {p116.W}`;
end;

u1.mul = u1.__mul;
u1.identity = u1.new(0, 0, 0, 1);

return {
    new = u1.new,
    euler = u1.euler,
    axisAngle = u1.axisAngle,
    lookRotation = u1.lookRotation,
    cframe = u1.cframe,
    identity = u1.identity
};