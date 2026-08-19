-- Decompiled with Potassium's decompiler.

local function mult(p1, p2) -- Line: 37
    local v3 = bit32.band(p1, 65535) * p2;
    local v4 = bit32.rshift(p1, 16) * p2;
    local v5 = bit32.band(v4, 65535);

    return v3 + bit32.lshift(v5, 16);
end;

return function(p6, p7) -- Line: 50, Name: xxhash32
    local v8 = p7 == nil and 0 or bit32.bor(p7, 0);
    local v9 = #p6;
    local v10 = 1;
    local v11 = 1;
    local v12;

    if v9 >= 16 then
        local v13 = v8 + 2654435761 + 2246822519;
        local v14 = v8 + 2246822519;
        local v15 = v8 - 2654435761;

        for _ = 0, v9 - 16, 16 do
            local v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30, v31 = string.byte(p6, v11, v11 + 15);
            local v32 = bit32.lshift(v19, 24);
            local v33 = bit32.lshift(v18, 16);
            local v34 = bit32.lshift(v17, 8);
            local v35 = bit32.bor(v32, v33, v34, v16);
            local v36 = bit32.band(v35, 65535) * 2246822519;
            local v37 = bit32.rshift(v35, 16) * 2246822519;
            local v38 = bit32.band(v37, 65535);
            local v39 = v13 + (v36 + bit32.lshift(v38, 16));
            local v40 = bit32.lrotate(v39, 13);
            local v41 = bit32.band(v40, 65535) * 2654435761;
            local v42 = bit32.rshift(v40, 16) * 2654435761;
            local v43 = bit32.band(v42, 65535);
            v13 = v41 + bit32.lshift(v43, 16);
            local v44 = bit32.lshift(v23, 24);
            local v45 = bit32.lshift(v22, 16);
            local v46 = bit32.lshift(v21, 8);
            local v47 = bit32.bor(v44, v45, v46, v20);
            local v48 = bit32.band(v47, 65535) * 2246822519;
            local v49 = bit32.rshift(v47, 16) * 2246822519;
            local v50 = bit32.band(v49, 65535);
            local v51 = v14 + (v48 + bit32.lshift(v50, 16));
            local v52 = bit32.lrotate(v51, 13);
            local v53 = bit32.band(v52, 65535) * 2654435761;
            local v54 = bit32.rshift(v52, 16) * 2654435761;
            local v55 = bit32.band(v54, 65535);
            v14 = v53 + bit32.lshift(v55, 16);
            local v56 = bit32.lshift(v27, 24);
            local v57 = bit32.lshift(v26, 16);
            local v58 = bit32.lshift(v25, 8);
            local v59 = bit32.bor(v56, v57, v58, v24);
            local v60 = bit32.band(v59, 65535) * 2246822519;
            local v61 = bit32.rshift(v59, 16) * 2246822519;
            local v62 = bit32.band(v61, 65535);
            local v63 = v8 + (v60 + bit32.lshift(v62, 16));
            local v64 = bit32.lrotate(v63, 13);
            local v65 = bit32.band(v64, 65535) * 2654435761;
            local v66 = bit32.rshift(v64, 16) * 2654435761;
            local v67 = bit32.band(v66, 65535);
            v8 = v65 + bit32.lshift(v67, 16);
            local v68 = bit32.lshift(v31, 24);
            local v69 = bit32.lshift(v30, 16);
            local v70 = bit32.lshift(v29, 8);
            local v71 = bit32.bor(v68, v69, v70, v28);
            local v72 = bit32.band(v71, 65535) * 2246822519;
            local v73 = bit32.rshift(v71, 16) * 2246822519;
            local v74 = bit32.band(v73, 65535);
            local v75 = v15 + (v72 + bit32.lshift(v74, 16));
            local v76 = bit32.lrotate(v75, 13);
            local v77 = bit32.band(v76, 65535) * 2654435761;
            local v78 = bit32.rshift(v76, 16) * 2654435761;
            local v79 = bit32.band(v78, 65535);
            v15 = v77 + bit32.lshift(v79, 16);
            v10 = v10 + 4;
            v11 = v11 + 16;
        end;

        v12 = bit32.lrotate(v13, 1) + bit32.lrotate(v14, 7) + bit32.lrotate(v8, 12) + bit32.lrotate(v15, 18);
    else
        v12 = bit32.bor(v8 + 374761393, 0);
    end;

    local v80 = bit32.bor(v12 + v9, 0);

    for _ = v10, v9 // 4 do
        local v81, v82, v83, v84 = string.byte(p6, v11, v11 + 3);
        local v85 = bit32.lshift(v84, 24);
        local v86 = bit32.lshift(v83, 16);
        local v87 = bit32.lshift(v82, 8);
        local v88 = bit32.bor(v85, v86, v87, v81);
        local v89 = bit32.band(v88, 65535) * 3266489917;
        local v90 = bit32.rshift(v88, 16) * 3266489917;
        local v91 = bit32.band(v90, 65535);
        local v92 = v80 + (v89 + bit32.lshift(v91, 16));
        local v93 = bit32.lrotate(v92, 17);
        local v94 = bit32.band(v93, 65535) * 668265263;
        local v95 = bit32.rshift(v93, 16) * 668265263;
        local v96 = bit32.band(v95, 65535);
        v80 = v94 + bit32.lshift(v96, 16);
        v10 = v10 + 1;
        v11 = v11 + 4;
    end;

    for i = -(v9 % 4), -1 do
        local v97 = string.byte(p6, i);
        local v98 = bit32.band(v97, 65535) * 374761393;
        local v99 = bit32.rshift(v97, 16) * 374761393;
        local v100 = bit32.band(v99, 65535);
        local v101 = v80 + (v98 + bit32.lshift(v100, 16));
        local v102 = bit32.lrotate(v101, 11);
        local v103 = bit32.band(v102, 65535) * 2654435761;
        local v104 = bit32.rshift(v102, 16) * 2654435761;
        local v105 = bit32.band(v104, 65535);
        v80 = v103 + bit32.lshift(v105, 16);
    end;

    local v106 = bit32.rshift(v80, 15);
    local v107 = bit32.bxor(v80, v106);
    local v108 = bit32.band(v107, 65535) * 2246822519;
    local v109 = bit32.rshift(v107, 16) * 2246822519;
    local v110 = bit32.band(v109, 65535);
    local v111 = v108 + bit32.lshift(v110, 16);
    local v112 = bit32.rshift(v111, 13);
    local v113 = bit32.bxor(v111, v112);
    local v114 = bit32.band(v113, 65535) * 3266489917;
    local v115 = bit32.rshift(v113, 16) * 3266489917;
    local v116 = bit32.band(v115, 65535);
    local v117 = v114 + bit32.lshift(v116, 16);
    local v118 = bit32.rshift(v117, 16);

    return bit32.bxor(v117, v118);
end;