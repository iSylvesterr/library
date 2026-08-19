-- Decompiled with Potassium's decompiler.

local u15 = {
    layout = function(p1, p2, p3, p4) -- Line: 18, Name: layout
        local v5 = math.floor(p1 or 12);
        local v6 = math.clamp(v5, 2, p4);
        local v7 = math.floor(v6 / 2);
        local v8 = math.max(2, v7);
        local v9;

        if (p2 or 0) >= 0.5 and (p3 or 0) > 0 then
            local v10 = p4 - v6;

            if v10 >= 4 and math.floor(v10 / v8) < 2 then
                local v11 = math.floor(v10 / 2);
                local v12 = math.min(v8, v11);
                v8 = math.max(4, v12);
            end;

            local v13 = math.floor(v10 / v8);
            v9 = math.min(6, v13);

            if v9 < 0 then
                v9 = 0;
            end;
        else
            v9 = 0;
        end;

        return v6 + v9 * v8, v6, v8, v9;
    end,

    basis = function(p14) -- Line: 39, Name: basis
        if p14.Magnitude < 0.0001 then
            return Vector3.new(1, 0, 0), Vector3.new(0, 0, 1);
        end;

        local Unit = p14.Unit;
        local Unit2 = Unit:Cross(math.abs(Unit.Y) < 0.99 and Vector3.new(0, 1, 0) or Vector3.new(1, 0, 0)).Unit;

        return Unit2, Unit:Cross(Unit2);
    end
};

local function displace(p16, p17, p18, p19, p20, p21, p22) -- Line: 50
    -- upvalues: displace (copy)
    if p18 - p17 <= 1 then
        return;
    end;

    local v23 = math.floor((p17 + p18) / 2);
    p16[v23] = p16[p17]:Lerp(p16[p18], (v23 - p17) / (p18 - p17)) + p21 * ((math.random() * 2 - 1) * p19) + p22 * ((math.random() * 2 - 1) * p19);
    local v24 = p19 * p20;
    displace(p16, p17, v23, v24, p20, p21, p22);
    displace(p16, v23, p18, v24, p20, p21, p22);
end;

local function buildPolyline(p25, p26, p27, p28, p29, p30, p31, p32, p33, p34) -- Line: 66
    -- upvalues: u15 (copy), displace (copy)
    local v35 = p28 - p27;
    local Magnitude = v35.Magnitude;

    for i = 1, p26 + 1 do
        p25[i] = p27 + v35 * ((i - 1) / p26);
    end;

    if p32 and p29 ~= 0 then
        local v36, v37 = u15.basis(v35);
        displace(p25, 1, p26 + 1, p29, p30, v36, v37);
    end;

    if p31 ~= 0 and Magnitude > 0.0001 then
        local v38 = (p33 or Vector3.new(0, 1, 0)) * (p31 >= 0 and -1 or 1);
        local v39 = math.max(p34 or 1, 0);
        local v40 = math.abs(p31) * Magnitude;

        if v39 >= 1 then
            for i = 2, p26 do
                local v41 = (i - 1) / p26;
                local v42 = 4 * v41 * (1 - v41);

                if v39 ~= 1 then
                    v42 = v42 ^ v39;
                end;

                p25[i] = p25[i] + v38 * (v40 * v42);
            end;

            return;
        end;

        local v43 = v35 * (1 / Magnitude);
        local v44 = v38 - v43 * v38:Dot(v43);

        if v44.Magnitude > 0.0001 then
            local Unit = v44.Unit;
            local v45 = (Magnitude * Magnitude * 0.25 + v40 * v40) / (2 * v40);
            local v46 = math.clamp((v45 - v40) / v45, -1, 1);
            local v47 = math.acos(v46);
            local v48 = p27 + v35 * 0.5 + Unit * (v40 - v45);

            for i = 2, p26 do
                local v49 = (i - 1) / p26;
                local v50 = p27 + v35 * v49;
                local v51 = (2 * v49 - 1) * v47;
                local v52 = v48 + (v43 * math.sin(v51) + Unit * math.cos(v51)) * v45;
                local v53;

                if v39 >= 0.5 then
                    v53 = v52:Lerp(v50 + Unit * (v40 * 4 * v49 * (1 - v49)), (v39 - 0.5) * 2);
                else
                    v53 = (v50 + Unit * v40):Lerp(v52, v39 * 2);
                end;

                p25[i] = p25[i] + (v53 - v50);
            end;
        end;
    end;
end;

local function writeSegments(p54, p55, p56, p57, p58) -- Line: 127
    local v59 = p58;

    for i = 1, p56 do
        local v60 = p55[i];
        local v61 = p55[i + 1];
        local Magnitude = (v61 - v60).Magnitude;
        local v62 = p57 + i;
        p54.revealDist[v62] = p58;

        if Magnitude > 0.0001 then
            p54.rollCFs[v62] = CFrame.lookAt((v60 + v61) * 0.5, v61);
        else
            p54.rollCFs[v62] = CFrame.new((v60 + v61) * 0.5);
        end;

        p54.segLen[v62] = math.max(Magnitude, 0.05);
        p58 = p58 + Magnitude;
    end;

    return p58 - v59;
end;

function u15.roll(p63, p64, p65, p66, p67) -- Line: 149
    -- upvalues: buildPolyline (copy), u15 (copy), writeSegments (copy)
    local v68 = math.clamp(p64._segCount or p63.mainSegs, 2, p63.mainSegs);
    local Magnitude = (p66 - p65).Magnitude;
    local v69 = (p64._amplitude or 0) * Magnitude;
    local v70 = p64._shapeMode or "Jitter";
    buildPolyline(p63.ptBuf, v68, p65, p66, v69, p64._decay or 0.5, p64._sag or 0, v70 ~= "Scroll", p64._sagDirWorld, p64._sagShape);

    if v70 ~= "Jitter" then
        for i = 1, v68 + 1 do
            p63.basePtBuf[i] = p63.ptBuf[i];
        end;

        local v71, v72 = u15.basis(p66 - p65);
        p63.scrollU = v71;
        p63.scrollV = v72;
        p63.scrollDist = Magnitude;
    end;

    p63.curSegs = v68;
    local v73 = writeSegments(p63, p63.ptBuf, v68, 0, 0);

    for i = v68 + 1, p63.mainSegs do
        p63.rollCFs[i] = p67;
        p63.segLen[i] = 0.05;
        p63.revealDist[i] = (1 / 0);
    end;

    local v74 = 0;

    for i = 1, p63.forkSlots do
        local v75 = p63.mainSegs + (i - 1) * p63.forkSegs;
        local v76 = p63.slotDepth[i];
        local v77 = false;

        if (p64._forkChance or 0) > math.random() and v76 <= (p64._forkDepth or 0) then
            local v78 = nil;
            local v79 = nil;
            local v80 = nil;
            local v81 = 0;
            local v82 = 0;
            local v83 = 0;

            if v76 == 1 then
                v81 = math.random(2, v68);
                v78 = p63.ptBuf[v81];
                v79 = (p63.ptBuf[v81 + 1] or p66) - v78;
                v80 = p63.revealDist[v81] or 0;
            elseif v74 > 0 then
                local v84 = math.random(1, v74);
                v78 = p63.forkAnchorPos[v84];
                v79 = p63.forkAnchorDir[v84];
                v80 = p63.forkAnchorReveal[v84];
                v82 = p63.forkAnchorSlot[v84];
                v83 = p63.forkAnchorPtIdx[v84];
            end;

            if v78 and (v79 and v79.Magnitude > 0.0001) then
                local v85 = (p64._forkLenScale or 0.4) ^ v76;
                local v86 = math.max(1, Magnitude * v85);
                local v87, v88 = u15.basis(v79);
                local v89 = math.random() * 3.141592653589793 * 2;
                local v90 = v87 * math.cos(v89) + v88 * math.sin(v89);
                local v91 = 0.2617993877991494 + math.random() * 0.5235987755982989;
                local v92 = CFrame.fromAxisAngle(v90, v91):VectorToWorldSpace(v79.Unit);
                buildPolyline(p63.forkPtBuf, p63.forkSegs, v78, v78 + v92 * v86, v69 * v85, p64._decay or 0.5, 0, true);
                writeSegments(p63, p63.forkPtBuf, p63.forkSegs, v75, v80);
                local v93 = p63.forkLocalPts[i];

                for i2 = 1, p63.forkSegs + 1 do
                    v93[i2] = p63.forkPtBuf[i2] - v78;
                end;

                p63.forkOriginIdx[i] = v81 or 0;
                p63.forkParentSlot[i] = v82 or 0;
                p63.forkParentPtIdx[i] = v83 or 0;
                p63.forkLen[i] = v86;
                local v94, v95 = u15.basis(v92);
                local forkV = p63.forkV;
                p63.forkU[i] = v94;
                forkV[i] = v95;
                p63.forkSeedU[i] = math.random() * 100;
                p63.forkSeedV[i] = 100 + math.random() * 100;

                if v76 == 1 then
                    v74 = v74 + 1;
                    local v96 = math.floor(p63.forkSegs / 2) + 1;
                    local v97 = math.max(2, v96);
                    p63.forkAnchorPos[v74] = p63.forkPtBuf[v97];
                    p63.forkAnchorDir[v74] = v92;
                    p63.forkAnchorReveal[v74] = v80;
                    p63.forkAnchorSlot[v74] = i;
                    p63.forkAnchorPtIdx[v74] = v97;
                end;

                v77 = true;
            end;
        end;

        if not v77 then
            p63.forkOriginIdx[i] = 0;
            p63.forkParentSlot[i] = 0;

            for i2 = 1, p63.forkSegs do
                local v98 = v75 + i2;
                p63.rollCFs[v98] = p67;
                p63.segLen[v98] = 0.05;
                p63.revealDist[v98] = (1 / 0);
            end;
        end;
    end;

    local v99 = 0;

    for i = 1, p63.partCount do
        local v100 = p63.revealDist[i];

        if v100 ~= (1 / 0) and v99 < v100 + p63.segLen[i] then
            v99 = v100 + p63.segLen[i];
        end;
    end;

    p63.maxReveal = v99;
    u15.sortReveal(p63);

    return v73;
end;

function u15.diffLive(p101) -- Line: 271
    local v102 = 0;

    for i = 1, p101.partCount do
        local v103 = p101.revealDist[i] ~= (1 / 0);

        if v103 and not p101.prevLive[i] then
            v102 = v102 + 1;
            p101.newlyLiveIdx[v102] = i;
            p101.lastWrittenLen[i] = -1;
        end;

        p101.prevLive[i] = v103;
    end;

    return v102;
end;

function u15.planSizes(p104, p105, p106) -- Line: 291
    local v107 = p106 or p105 ~= p104.lastThick;
    local v108 = 0;

    for i = 1, p104.partCount do
        if p104.revealDist[i] ~= (1 / 0) then
            local v109 = p104.segLen[i];

            if v107 or v109 ~= p104.lastWrittenLen[i] then
                v108 = v108 + 1;
                p104.sizeWriteIdx[v108] = i;
                p104.lastWrittenLen[i] = v109;
            end;
        end;
    end;

    p104.lastThick = p105;

    return v108;
end;

function u15.applyScroll(p110, p111, p112) -- Line: 312
    local curSegs = p110.curSegs;
    local scrollU = p110.scrollU;
    local scrollV = p110.scrollV;

    if not curSegs or (curSegs < 2 or not scrollU) then
        return;
    end;

    local v113 = (p111._amplitude or 0) * (p110.scrollDist or 0);
    local v114 = p111._waves or 3;
    local v115 = p111._decay or 0.5;
    local v116 = p111._noiseSeedA or 0;
    local v117 = p111._noiseSeedB or 500;
    local ptBuf = p110.ptBuf;
    local basePtBuf = p110.basePtBuf;

    for i = 1, curSegs + 1 do
        local v118 = (i - 1) / curSegs;
        local v119 = 4 * v118 * (1 - v118);
        local v120 = v119 * v119;
        local v121 = v118 * v114 - p112;
        local v122 = v118 * v114 * 2.7 - p112 * 1.6;
        local v123 = (math.noise(v121, v116) + math.noise(v122, v116 + 37.1) * v115) * v113 * v120;
        local v124 = (math.noise(v121, v117) + math.noise(v122, v117 + 37.1) * v115) * v113 * v120;
        ptBuf[i] = basePtBuf[i] + scrollU * v123 + scrollV * v124;
    end;

    for i = 1, curSegs do
        local v125 = ptBuf[i];
        local v126 = ptBuf[i + 1];
        local Magnitude = (v126 - v125).Magnitude;

        if Magnitude > 0.0001 then
            p110.rollCFs[i] = CFrame.lookAt((v125 + v126) * 0.5, v126);
        else
            p110.rollCFs[i] = CFrame.new((v125 + v126) * 0.5);
        end;

        p110.segLen[i] = math.max(Magnitude, 0.05);
    end;
end;

function u15.applyScrollForks(p127, p128, p129) -- Line: 353
    local forkSegs = p127.forkSegs;
    local v130 = p128._waves or 3;

    for i = 1, p127.forkSlots do
        local v131 = p127.forkOriginIdx[i] or 0;
        local v132 = p127.forkParentSlot[i] or 0;

        if v131 ~= 0 or v132 ~= 0 then
            local v133;

            if v132 == 0 then
                v133 = p127.ptBuf[v131];
            else
                v133 = p127.forkWorldPts[v132];

                if v133 then
                    v133 = v133[p127.forkParentPtIdx[i]];
                end;
            end;

            if v133 then
                local v134 = p127.forkLocalPts[i];
                local v135 = p127.forkWorldPts[i];
                local v136 = p127.forkU[i];
                local v137 = p127.forkV[i];
                local v138 = (p128._amplitude or 0) * (p127.forkLen[i] or 1);
                local v139 = p127.forkSeedU[i] or 0;
                local v140 = p127.forkSeedV[i] or 50;

                for i2 = 1, forkSegs + 1 do
                    local v141 = (i2 - 1) / forkSegs;
                    local v142 = v141 * v130 - p129 * 1.35;
                    v135[i2] = v133 + v134[i2] + v136 * (math.noise(v142, v139) * v138 * v141) + v137 * (math.noise(v142, v140) * v138 * v141);
                end;

                local v143 = p127.mainSegs + (i - 1) * forkSegs;

                for i2 = 1, forkSegs do
                    local v144 = v135[i2];
                    local v145 = v135[i2 + 1];
                    local Magnitude = (v145 - v144).Magnitude;
                    local v146 = v143 + i2;

                    if Magnitude > 0.0001 then
                        p127.rollCFs[v146] = CFrame.lookAt((v144 + v145) * 0.5, v145);
                    else
                        p127.rollCFs[v146] = CFrame.new((v144 + v145) * 0.5);
                    end;

                    p127.segLen[v146] = math.max(Magnitude, 0.05);
                end;
            end;
        end;
    end;
end;

function u15.sortReveal(p147) -- Line: 400
    local revealOrder = p147.revealOrder;
    local revealDist = p147.revealDist;

    for i = 2, p147.partCount do
        local v148 = revealOrder[i];
        local v149 = i - 1;

        while v149 >= 1 and revealDist[v148] < revealDist[revealOrder[v149]] do
            revealOrder[v149 + 1] = revealOrder[v149];
            v149 = v149 - 1;
        end;

        revealOrder[v149 + 1] = v148;
    end;
end;

return u15;