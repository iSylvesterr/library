-- Decompiled with Potassium's decompiler.

local v1 = {};

local function support(p2, p3, p4, p5) -- Line: 32
    local v6 = p2.XVector:Dot(p4);
    local v7 = math.abs(v6) * p3.X;
    local v8 = p2.YVector:Dot(p4);
    local v9 = v7 + math.abs(v8) * p3.Y;
    local v10 = p2.ZVector:Dot(p4);

    return (v9 + math.abs(v10) * p3.Z) * p5;
end;

local function spinCF(p11, p12, p13) -- Line: 38
    local Magnitude = p12.Magnitude;

    if Magnitude * p13 < 0.0001 then
        return p11;
    end;

    return CFrame.fromAxisAngle(p12 * (1 / Magnitude), Magnitude * p13) * p11;
end;

local function planeCrossTime(p14, p15, p16, p17, p18, p19) -- Line: 48
    local v20 = 0.5 * p16:Dot(p17);
    local v21 = p15:Dot(p17);
    local v22 = p14:Dot(p17) - p18;

    if math.abs(v20) < 1e-6 then
        if math.abs(v21) < 1e-9 then
            return nil;
        end;

        local v23 = -v22 / v21;

        if v23 >= 0 and v23 <= p19 then
            return v23;
        end;

        return nil;
    end;

    local v24 = v21 * v21 - 4 * v20 * v22;

    if v24 < 0 then
        return nil;
    end;

    local v25 = math.sqrt(v24);
    local v26 = (-v21 - v25) / (2 * v20);
    local v27 = (-v21 + v25) / (2 * v20);

    if v27 >= v26 then
        local v28 = v26;
        v26 = v27;
        v27 = v28;
    end;

    if v27 >= 0 and v27 <= p19 then
        return v27;
    end;

    if v26 >= 0 and v26 <= p19 then
        return v26;
    end;

    return nil;
end;

local function restPose(p29, p30, p31) -- Line: 75
    local v32 = p29.XVector:Dot(p31);
    local v33 = p29.YVector:Dot(p31);
    local v34 = p29.ZVector:Dot(p31);
    local v35 = math.abs(v32) / math.max(p30.X, 0.05);
    local v36 = math.abs(v33) / math.max(p30.Y, 0.05);
    local v37 = math.abs(v34) / math.max(p30.Z, 0.05);
    local v38, v39;

    if v36 <= v35 and v37 <= v35 then
        v38 = p29.XVector * (v32 >= 0 and 1 or -1);
        v39 = p30.X;
    elseif v37 <= v36 then
        v38 = p29.YVector * (v33 >= 0 and 1 or -1);
        v39 = p30.Y;
    else
        v38 = p29.ZVector * (v34 >= 0 and 1 or -1);
        v39 = p30.Z;
    end;

    local v40 = v38:Dot(p31);
    local v41 = math.clamp(v40, -1, 1);
    local v42 = v38:Cross(p31);

    if v42.Magnitude > 0.00001 and v41 < 0.9999 then
        return CFrame.fromAxisAngle(v42.Unit, (math.acos(v41))) * p29, v39;
    end;

    return p29, v39;
end;

function v1.build(p43, p44, p45, p46, p47, p48, p49, p50, p51, p52) -- Line: 102
    -- upvalues: support (copy), planeCrossTime (copy), restPose (copy)
    local v53 = {};
    local v54 = Vector3.new(0, -p49, 0);
    local v55 = 0;
    local v56 = {
        impactT = nil,
        hit = nil,
        restT = (1 / 0),
        segs = v53
    };

    for i = 0, 3 do
        local v57 = i == 0 and 6 or 4;
        local v58 = math.max(p44.Y, 0) / math.max(p49, 1) * 2 + 1.5;
        local v59 = math.min(v58, 6);
        local v60 = v59 / v57;
        local v61 = p43;
        local v62 = nil;
        local v63 = nil;

        for i2 = 1, v57 do
            local v64 = i2 * v60;
            local v65 = v61 + p44 * v64 + v54 * (0.5 * v64 * v64);
            local v66 = v65 - p43;

            if v66.Magnitude > 0.0001 then
                local Unit = v66.Unit;
                local v67 = support(p45, p47, Unit, p48);
                local v68 = p52(p43, v66 + Unit * v67);

                if v68 then
                    local v69 = math.clamp((v68.Position - p43).Magnitude / (v66.Magnitude + v67), 0, 1);
                    local v70 = (i2 - 1) * v60 + v60 * v69;
                    local Magnitude = p46.Magnitude;
                    local v71;

                    if Magnitude * v70 < 0.0001 then
                        v71 = p45;
                    else
                        v71 = CFrame.fromAxisAngle(p46 * (1 / Magnitude), Magnitude * v70) * p45;
                    end;

                    local v72 = support(v71, p47, v68.Normal, p48);
                    local v73 = v68.Position:Dot(v68.Normal) + v72;
                    v62 = planeCrossTime(v61, p44, v54, v68.Normal, v73, v59) or v70;
                    v63 = v68;
                    break;
                end;
            end;

            p43 = v65;
        end;

        if not v63 then
            v53[#v53 + 1] = {
                kind = 1,
                t0 = v55,
                p0 = v61,
                v0 = p44,
                rot0 = p45,
                w = p46
            };

            return v56;
        end;

        local Normal = v63.Normal;
        local v74 = p44 + v54 * v62;
        local Magnitude = p46.Magnitude;
        local v75;

        if Magnitude * v62 < 0.0001 then
            v75 = p45;
        else
            v75 = CFrame.fromAxisAngle(p46 * (1 / Magnitude), Magnitude * v62) * p45;
        end;

        local v76 = support(v75, p47, Normal, p48);
        p43 = v61 + p44 * v62 + v54 * (0.5 * v62 * v62);
        v53[#v53 + 1] = {
            kind = 1,
            t0 = v55,
            p0 = v61,
            v0 = p44,
            rot0 = p45,
            w = p46
        };
        v55 = v55 + v62;

        if not v56.impactT then
            v56.impactT = v55;
            v56.hit = v63;
        end;

        local v77 = v74:Dot(Normal);
        local v78 = v74 - Normal * v77;

        if -v77 * p50 <= 6 or (Normal.Y <= 0.3 or i >= 3) then
            local Magnitude2 = v78.Magnitude;
            local v79 = math.max(p51 * p49 * 0.5, 10);
            local v80 = math.min(Magnitude2 / v79, 2);
            local v81 = Magnitude2 > 0.001 and v78.Unit or Vector3.new(1, 0, 0);
            local v82, v83 = restPose(v75, p47, Normal);
            local u84 = v63.Position:Dot(Normal);

            local function planeSeat(p85, p86) -- Line: 184
                -- upvalues: Normal (copy), u84 (copy)
                return p85 + Normal * (u84 + p86 - p85:Dot(Normal));
            end;

            local v87 = p43 + Normal * (u84 + v76 - p43:Dot(Normal));
            local v88 = v87 + v81 * (Magnitude2 * v80 - v79 * 0.5 * v80 * v80);
            local v89 = v88 + Normal * (u84 + v83 * p48 - v88:Dot(Normal));
            v53[#v53 + 1] = {
                kind = 2,
                t0 = v55,
                dur = math.max(v80, 0.15),
                p0 = v87,
                p1 = v89,
                rot0 = v75,
                rotF = v82
            };
            local v90 = v55 + math.max(v80, 0.15);
            v53[#v53 + 1] = {
                kind = 3,
                t0 = v90,
                cf = v82 + v89
            };
            v56.restT = v90;

            return v56;
        end;

        p44 = v78 * (1 - p51) + Normal * (-v77 * p50);
        local v91 = Normal:Cross(v78);

        if v91.Magnitude > 0.0001 and v78.Magnitude > 0.5 then
            p46 = v91.Unit * (v78.Magnitude / math.max(v76, 0.1));
        end;

        p45 = v75;
    end;

    return v56;
end;

function v1.evaluate(p92, p93, p94) -- Line: 201
    local segs = p92.segs;
    local v95 = segs[1];

    for i = 2, #segs do
        if segs[i].t0 > p93 then
            break;
        end;

        v95 = segs[i];
    end;

    if v95.kind ~= 1 then
        if v95.kind ~= 2 then
            return v95.cf;
        end;

        local v96 = math.clamp((p93 - v95.t0) / v95.dur, 0, 1);
        local v97 = 1 - (1 - v96) * (1 - v96);

        return v95.rot0:Lerp(v95.rotF, v97) + v95.p0:Lerp(v95.p1, v97);
    end;

    local v98 = math.max(p93 - v95.t0, 0);
    local v99 = v95.p0 + v95.v0 * v98 + Vector3.new(0, -0.5 * p94 * v98 * v98, 0);
    local rot0 = v95.rot0;
    local w = v95.w;
    local Magnitude = w.Magnitude;

    if Magnitude * v98 >= 0.0001 then
        rot0 = CFrame.fromAxisAngle(w * (1 / Magnitude), Magnitude * v98) * rot0;
    end;

    return rot0 + v99;
end;

return v1;