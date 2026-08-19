-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 6, Name: InitPlant
        local v4 = Random.new(p2);
        local FruitSpawnLocations = u1.FruitSpawnLocations;
        local Base = u1.Base;
        local Stud_Part = script.Stud_Part;
        local Position = (Base.CFrame * CFrame.new(0, -Base.Size.Y / 2, 0)).Position;
        local v5 = ((p3 or 1) * 0.5 + 0.5) * 0.7;
        local u6 = {};

        local function orientYAlongDir(p7, p8) -- Line: 28
            local Unit = p8.Unit;
            local v9 = Vector3.new(0, 0, 1);
            local v10 = Unit:Dot(v9);
            local Unit2 = Unit:Cross(math.abs(v10) > 0.99 and Vector3.new(1, 0, 0) or v9).Unit;

            return CFrame.fromMatrix(p7, Unit2, Unit);
        end;

        local function makeBlock(p11, p12, p13, p14) -- Line: 38
            -- upvalues: Stud_Part (copy), u1 (copy)
            local v15 = Stud_Part:Clone();
            v15.Size = p11;
            v15.CFrame = p12;
            v15.Color = p14 or Color3.new(0.509804, 0.380392, 0.25098);
            v15.Anchored = true;
            v15.CanCollide = false;
            v15:SetAttribute("OG_Transparency", 0);
            v15.Name = tostring(p13);
            v15.Parent = u1;

            return v15;
        end;

        local function makeLeaf(p16, p17, p18, p19) -- Line: 51
            -- upvalues: makeBlock (copy), u6 (copy)
            local v20 = makeBlock(p16, p17, p18, p19);
            v20:SetAttribute("IsLeaf", true);
            table.insert(u6, v20);

            return v20;
        end;

        local function makeSegment(p21, p22, p23, p24, p25) -- Line: 58
            -- upvalues: makeBlock (copy)
            local v26 = p22 - p21;
            local Magnitude = v26.Magnitude;

            if Magnitude < 0.01 then
                return;
            end;

            local Unit = v26.Unit;
            local v27 = Vector3.new(0, 0, 1);
            local v28 = Unit:Dot(v27);
            local Unit2 = Unit:Cross(math.abs(v28) > 0.99 and Vector3.new(1, 0, 0) or v27).Unit;
            local v29 = CFrame.fromMatrix((p21 + p22) / 2, Unit2, Unit);
            makeBlock(Vector3.new(p23, Magnitude + 0.05, p23), v29, p24, p25);
        end;

        local v30 = 18 * v5;
        local v31 = 2.2 * v5;
        local v32 = 1.6 * v5;
        local v33 = 0.7 * v5;
        local v34 = 0 + 1;
        local v35 = 2.5 * v5;
        local v36 = 2.5 * v5;
        makeBlock(Vector3.new(v36, v35, v36), CFrame.new(Position + Vector3.new(0, v35 / 2, 0)), v34);
        local v37 = {};
        local v38 = 0;
        local v39 = {};
        local v40 = 0;

        local function getGreenColor(p41) -- Line: 18
            local v42 = 30 + p41:NextInteger(-10, 20);
            local v43 = 130 + p41:NextInteger(-20, 40);
            local v44 = 20 + p41:NextInteger(-10, 15);

            return Color3.fromRGB(v42, v43, v44);
        end;

        for i = 0, 2 do
            for i2 = 0, 1 do
                local v45 = i / 3 * 3.141592653589793 * 2;
                local v46 = v45 + (i2 / 2 - 0.5) * 1.5 + (v4:NextNumber() - 0.5) * 0.4;
                local v47 = 6 + v4:NextNumber() * 5;
                local v48 = 1 + v4:NextNumber() * 0.4;
                local v49 = 0.15 + v4:NextNumber() * 0.1;
                local v50 = 0.8 + v4:NextNumber() * 1.2;
                local v51 = math.cos(v45) * v31 * 0.5;
                local v52 = v4:NextNumber() * 1;
                local v53 = math.sin(v45) * v31 * 0.5;
                local v54 = Position + Vector3.new(v51, v52, v53);
                local v55 = math.floor(v47 * 0.3);
                local v56 = v55 < 2 and 2 or v55;
                local v57 = v4:NextNumber() * 100;
                local v58 = {};

                for i3 = 0, v56 do
                    local v59 = i3 / v56;
                    local v60 = v59 * v47;
                    local v61 = math.sin(v57) * 0.5 + 1.8;
                    local v62 = math.cos(v57 * 0.7) * 0.8 + 3.2;
                    local v63 = math.sin(v57 * 1.3) * 0.3 + 0.6;
                    local v64 = math.cos(v57 * 0.9) * 0.15 + 0.3;
                    local v65 = math.sin(v59 * 3.141592653589793 * v61 + v57) * v63 * v59 + math.sin(v59 * 3.141592653589793 * v62 + v57 * 2.1) * v64 * v59;
                    local v66 = v50 * (1 - v59) + math.sin(v59 * 3.141592653589793 * 1.5 + v57 * 0.5) * 0.15 * v59;

                    if v59 > 0.3 then
                        v66 = v66 - (v59 - 0.3) * 0.3;
                    end;

                    local v67 = math.max(v66, -0.15);
                    local v68 = v46 + 1.5707963267948966;
                    local v69 = math.cos(v46) * v60 + math.cos(v68) * v65;
                    local v70 = math.sin(v46) * v60 + math.sin(v68) * v65;
                    v58[i3 + 1] = v54 + Vector3.new(v69, v67, v70) * v5;
                end;

                local v71 = {};

                for i3 = 1, #v58 - 1 do
                    v71[i3] = (v48 + (v49 - v48) * ((i3 - 1) / (#v58 - 1))) * v5;
                end;

                table.insert(v37, {
                    points = v58,
                    widths = v71
                });

                if v38 < #v58 - 1 then
                    v38 = #v58 - 1;
                end;

                if v4:NextNumber() > 0.45 and #v58 > 4 then
                    local v72 = math.floor(#v58 * 0.45) + v4:NextInteger(0, (math.floor(#v58 * 0.2)));
                    local v73 = math.clamp(v72, 2, #v58 - 1);
                    local v74 = v46 + (v4:NextNumber() - 0.5) * 1.2;
                    local v75 = v47 * (0.25 + v4:NextNumber() * 0.25);
                    local v76 = v48 * 0.45;
                    local v77 = math.floor(v75 * 0.3);
                    local v78 = v77 < 2 and 2 or v77;
                    local v79 = v4:NextNumber() * 100;
                    local v80 = v58[v73];
                    local v81 = {};

                    for i3 = 0, v78 do
                        local v82 = i3 / v78;
                        local v83 = v82 * v75;
                        local v84 = math.sin(v79) * 0.5 + 1.8;
                        local v85 = math.cos(v79 * 0.7) * 0.8 + 3.2;
                        local v86 = math.sin(v79 * 1.3) * 0.3 + 0.6;
                        local v87 = math.cos(v79 * 0.9) * 0.15 + 0.3;
                        local v88 = math.sin(v82 * 3.141592653589793 * v84 + v79) * v86 * v82 + math.sin(v82 * 3.141592653589793 * v85 + v79 * 2.1) * v87 * v82;
                        local v89 = (1 - v82) * 0.1 + math.sin(v82 * 3.141592653589793 * 1.5 + v79 * 0.5) * 0.15 * v82;

                        if v82 > 0.3 then
                            v89 = v89 - (v82 - 0.3) * 0.3;
                        end;

                        local v90 = math.max(v89, -0.15);
                        local v91 = v74 + 1.5707963267948966;
                        local v92 = math.cos(v74) * v83 + math.cos(v91) * v88;
                        local v93 = math.sin(v74) * v83 + math.sin(v91) * v88;
                        v81[i3 + 1] = v80 + Vector3.new(v92, v90, v93) * v5;
                    end;

                    local v94 = {};

                    for i3 = 1, #v81 - 1 do
                        v94[i3] = (v76 + (v49 - v76) * ((i3 - 1) / (#v81 - 1))) * v5;
                    end;

                    table.insert(v39, {
                        points = v81,
                        widths = v94
                    });

                    if v40 < #v81 - 1 then
                        v40 = #v81 - 1;
                    end;
                end;
            end;
        end;

        for i = 1, v38 do
            v34 = v34 + 1;

            for _, v in v37 do
                if i <= #v.points - 1 then
                    local v95 = v.points[i];
                    local v96 = v.points[i + 1];
                    local v97 = v.widths[i];
                    local v98 = (v95 + v96) / 2;
                    local v99 = v96 - v95;
                    local Magnitude = v99.Magnitude;

                    if Magnitude >= 0.01 then
                        local Unit = v99.Unit;
                        local v100 = Vector3.new(0, 0, 1);
                        local v101 = Unit:Dot(v100);
                        local Unit2 = Unit:Cross(math.abs(v101) > 0.99 and Vector3.new(1, 0, 0) or v100).Unit;
                        local v102 = CFrame.fromMatrix(v98, Unit2, Unit);
                        makeBlock(Vector3.new(v97, Magnitude + 0.05, v97), v102, v34, nil);
                    end;
                end;
            end;
        end;

        for i = 1, v40 do
            v34 = v34 + 1;

            for _, v in v39 do
                if i <= #v.points - 1 then
                    local v103 = v.points[i];
                    local v104 = v.points[i + 1];
                    local v105 = v.widths[i];
                    local v106 = (v103 + v104) / 2;
                    local v107 = v104 - v103;
                    local Magnitude = v107.Magnitude;

                    if Magnitude >= 0.01 then
                        local Unit = v107.Unit;
                        local v108 = Vector3.new(0, 0, 1);
                        local v109 = Unit:Dot(v108);
                        local Unit2 = Unit:Cross(math.abs(v109) > 0.99 and Vector3.new(1, 0, 0) or v108).Unit;
                        local v110 = CFrame.fromMatrix(v106, Unit2, Unit);
                        makeBlock(Vector3.new(v105, Magnitude + 0.05, v105), v110, v34, nil);
                    end;
                end;
            end;
        end;

        local v111 = {};
        local v112 = {};
        local v113 = {};

        for i = 0, 2 do
            v111[i] = {};
            local v114 = i / 3 * 3.141592653589793 * 2;

            for i2 = 0, 10 do
                local v115 = i2 / 10;
                local v116 = v114 + v115 * 3.141592653589793 * 2 * 1;
                local v117 = v31 * (1 - v115 * 0.4);
                local v118 = v111[i];
                local v119 = {};
                local v120 = math.cos(v116) * v117;
                local v121 = math.sin(v116) * v117;
                v119.pos = Position + Vector3.new(v120, v115 * v30, v121);
                v119.t = v115;
                v119.angle = v116;
                v118[i2] = v119;
            end;
        end;

        for i = 0, 10 do
            v34 = v34 + 1;

            if i < 4 then
                local v122 = i / 4;
                local v123 = (2 - v122 * 1) * v5;
                local v124 = v30 / 4 + 0.1;
                local v125 = Position + Vector3.new(0, v122 * v30 + v124 / 2, 0);
                makeBlock(Vector3.new(v123, v124, v123), CFrame.new(v125), v34);
            end;

            if i > 0 and i <= 10 then
                for i2 = 0, 2 do
                    local v126 = v111[i2][i];
                    local v127 = v32 + (v33 - v32) * v126.t;
                    local pos = v111[i2][i - 1].pos;
                    local pos2 = v126.pos;
                    local v128 = (pos + pos2) / 2;
                    local v129 = pos2 - pos;
                    local Magnitude = v129.Magnitude;

                    if Magnitude >= 0.01 then
                        local Unit = v129.Unit;
                        local v130 = Vector3.new(0, 0, 1);
                        local v131 = Unit:Dot(v130);
                        local Unit2 = Unit:Cross(math.abs(v131) > 0.99 and Vector3.new(1, 0, 0) or v130).Unit;
                        local v132 = CFrame.fromMatrix(v128, Unit2, Unit);
                        makeBlock(Vector3.new(v127, Magnitude + 0.05, v127), v132, v34, nil);
                    end;

                    if v126.t < 0.15 then
                        table.insert(v113, {
                            pos = v126.pos,
                            angle = v126.angle,
                            helix = i2
                        });
                    end;

                    if v126.t > 0.85 then
                        table.insert(v112, {
                            pos = v126.pos,
                            angle = v126.angle,
                            helix = i2
                        });
                    end;
                end;
            end;
        end;

        local v133 = 6 + v4:NextInteger(0, 3);
        local v134 = {};

        for i = 1, v133 do
            local v135 = i / v133 * 3.141592653589793 * 2 + (v4:NextNumber() - 0.5) * 0.4;
            local v136 = 30 + v4:NextNumber() * 30;
            local v137 = math.rad(v136);
            local v138 = (4 + v4:NextNumber() * 4) * v5;
            local v139 = (1 + v4:NextNumber() * 0.5) * v5;
            local v140 = (0.2 + v4:NextNumber() * 0.15) * v5;
            local v141 = v30 * (0.55 + v4:NextNumber() * 0.45);
            local v142 = math.cos(v135) * v31 * 0.4;
            local v143 = math.sin(v135) * v31 * 0.4;
            local v144 = Vector3.new(v142, 0, v143);
            local v145 = Position + Vector3.new(0, v141, 0) + v144;
            local v146 = v4:NextNumber() * 100;

            for i2 = 1, 2 do
                local v147 = i2 / 2;
                local v148 = math.cos(v135);
                local v149 = math.sin(v135);
                local v150 = math.sin(v137) * (1 - v147 * 0.4);
                local v151 = math.sin(v147 * 3.141592653589793 * 2 + v146) * 0.2 * v147;
                local v152 = math.cos(v147 * 3.141592653589793 * 1.5 + v146 * 1.3) * 0.15 * v147;
                local v153 = v145 + Vector3.new(v148 + v151, v150, v149 + v152).Unit * (v138 / 2) * v5;
                local v154 = v139 + (v140 - v139) * v147;
                v34 = v34 + 1;
                local v155 = (v145 + v153) / 2;
                local v156 = v153 - v145;
                local Magnitude = v156.Magnitude;

                if Magnitude >= 0.01 then
                    local Unit = v156.Unit;
                    local v157 = Vector3.new(0, 0, 1);
                    local v158 = Unit:Dot(v157);
                    local Unit2 = Unit:Cross(math.abs(v158) > 0.99 and Vector3.new(1, 0, 0) or v157).Unit;
                    local v159 = CFrame.fromMatrix(v155, Unit2, Unit);
                    makeBlock(Vector3.new(v154, Magnitude + 0.05, v154), v159, v34, nil);
                end;

                if v147 > 0.3 and (v147 < 0.85 and v4:NextNumber() > 0.55) then
                    local v160 = v135 + (v4:NextNumber() - 0.5) * 1.2;
                    local v161 = 15 + v4:NextNumber() * 35;
                    local v162 = math.rad(v161);
                    local v163 = v138 * (0.3 + v4:NextNumber() * 0.3);
                    local v164 = v154 * 0.75;
                    v145 = v153;

                    for i3 = 1, 1 do
                        local v165 = i3 / 1;
                        local v166 = math.cos(v160) + math.sin(v165 * 3.141592653589793 + v146) * 0.15;
                        local v167 = math.sin(v162) * (1 - v165 * 0.5);
                        local v168 = math.sin(v160) + math.cos(v165 * 3.141592653589793 + v146) * 0.15;
                        local v169 = v153 + Vector3.new(v166, v167, v168).Unit * (v163 / 1) * v5;
                        local v170 = v164 + (v140 - v164) * v165;
                        v34 = v34 + 1;
                        local v171 = (v153 + v169) / 2;
                        local v172 = v169 - v153;
                        local Magnitude2 = v172.Magnitude;

                        if Magnitude2 >= 0.01 then
                            local Unit = v172.Unit;
                            local v173 = Vector3.new(0, 0, 1);
                            local v174 = Unit:Dot(v173);
                            local Unit2 = Unit:Cross(math.abs(v174) > 0.99 and Vector3.new(1, 0, 0) or v173).Unit;
                            local v175 = CFrame.fromMatrix(v171, Unit2, Unit);
                            makeBlock(Vector3.new(v170, Magnitude2 + 0.05, v170), v175, v34, nil);
                        end;

                        v153 = v169;
                    end;

                    table.insert(v134, v153);
                else
                    v145 = v153;
                end;
            end;

            table.insert(v134, v145);
        end;

        for _, v in v134 do
            for _ = 1, 2 + v4:NextInteger(0, 2) do
                local v176 = (v4:NextNumber() - 0.5) * 6 * v5;
                local v177 = (v4:NextNumber() - 0.3) * 4 * v5;
                local v178 = (v4:NextNumber() - 0.5) * 6 * v5;
                local v179 = v + Vector3.new(v176, v177, v178);
                local v180 = (4 + v4:NextNumber() * 4) * v5;
                local v181 = (1.8 + v4:NextNumber() * 1.4) * v5;
                local v182 = CFrame.new(v179) * CFrame.Angles((v4:NextNumber() - 0.5) * 0.3, v4:NextNumber() * 3.141592653589793 * 2, (v4:NextNumber() - 0.5) * 0.3);
                v34 = v34 + 1;
                local v183 = makeBlock(Vector3.new(v180, v181, v180), v182, v34, (getGreenColor(v4)));
                v183:SetAttribute("IsLeaf", true);
                table.insert(u6, v183);
            end;
        end;

        local v184 = Position + Vector3.new(0, v30 * 1.05, 0);
        local v185 = 11 * v5;
        local v186 = 7 * v5;

        for _ = 1, 20 + v4:NextInteger(0, 10) do
            local v187 = v4:NextNumber() * 3.141592653589793 * 2;
            local v188 = v4:NextNumber() * 3.141592653589793 * 0.6;
            local v189 = v185 * (0.4 + v4:NextNumber() * 0.6);
            local v190 = math.cos(v187) * math.sin(v188) * v189;
            local v191 = math.cos(v188) * v186 * 0.5 + (v4:NextNumber() - 0.3) * 2.5 * v5;
            local v192 = math.sin(v187) * math.sin(v188) * v189;
            local v193 = v184 + Vector3.new(v190, v191, v192);
            local v194 = (4.5 + v4:NextNumber() * 5) * v5;
            local v195 = (1.5 + v4:NextNumber() * 1.8) * v5;
            local v196 = CFrame.new(v193) * CFrame.Angles((v4:NextNumber() - 0.5) * 0.4, v4:NextNumber() * 3.141592653589793 * 2, (v4:NextNumber() - 0.5) * 0.4);
            v34 = v34 + 1;
            local v197 = makeBlock(Vector3.new(v194, v195, v194), v196, v34, (getGreenColor(v4)));
            v197:SetAttribute("IsLeaf", true);
            table.insert(u6, v197);
        end;

        for _, v in u6 do
            v.CanCollide = true;
        end;

        local v198 = RaycastParams.new();
        v198.FilterType = Enum.RaycastFilterType.Include;
        v198.FilterDescendantsInstances = { u1 };
        local v199 = 8 + v4:NextInteger(0, 6);
        local v200 = Position.Y + v30 * 0.5;
        local v201 = v30 * 1.2;
        local v202 = 0;

        for _ = 1, v199 * 8 do
            if v199 <= v202 then
                break;
            end;

            local v203 = v4:NextNumber() * 3.141592653589793 * 2;
            local v204 = v185 * (0.2 + v4:NextNumber() * 0.8);
            local v205 = Position.X + math.cos(v203) * v204;
            local v206 = Position.Z + math.sin(v203) * v204;
            local v207 = Vector3.new(v205, v200, v206);
            local v208 = workspace:Raycast(v207, Vector3.new(0, v201, 0), v198);

            if v208 and (v208.Instance and v208.Instance:GetAttribute("IsLeaf")) then
                local v209 = v208.Instance.CFrame.Position - Vector3.new(0, v208.Instance.Size.Y / 2, 0);
                local v210 = false;

                for _, child in FruitSpawnLocations:GetChildren() do
                    if (child.CFrame.Position - v209).Magnitude < 3 * v5 then
                        v210 = true;
                        break;
                    end;
                end;

                if not v210 then
                    local Part = Instance.new("Part");
                    Part.Size = Vector3.new(1, 1, 1);
                    Part.Transparency = 1;
                    Part.Anchored = true;
                    Part.CanCollide = false;
                    Part.CFrame = CFrame.new(v209);
                    Part.Name = "Fruit_Spawn";
                    Part.Parent = FruitSpawnLocations;
                    v202 = v202 + 1;
                end;
            end;
        end;

        if v202 < 4 and #u6 > 0 then
            for _ = 1, math.min(6, #u6) do
                if v199 <= v202 then
                    break;
                end;

                local v211 = u6[v4:NextInteger(1, #u6)];
                local v212 = v211.CFrame.Position - Vector3.new(0, v211.Size.Y / 2, 0);
                local v213 = false;

                for _, child in FruitSpawnLocations:GetChildren() do
                    if (child.CFrame.Position - v212).Magnitude < 3 * v5 then
                        v213 = true;
                        break;
                    end;
                end;

                if not v213 then
                    local Part = Instance.new("Part");
                    Part.Size = Vector3.new(1, 1, 1);
                    Part.Transparency = 1;
                    Part.Anchored = true;
                    Part.CanCollide = false;
                    Part.CFrame = CFrame.new(v212);
                    Part.Name = "Fruit_Spawn";
                    Part.Parent = FruitSpawnLocations;
                    v202 = v202 + 1;
                end;
            end;
        end;

        for _, v in u6 do
            v.CanCollide = false;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u214) -- Line: 451, Name: BeginPlantGrowth
        local PrimaryPart = u214.PrimaryPart;
        local u215 = {};

        for _, v in u214:QueryDescendants("BasePart") do
            local v216 = tonumber(v.Name);

            if v216 then
                local v217 = PrimaryPart.CFrame:ToObjectSpace(v.CFrame);
                local v218 = v217 * CFrame.new(0, -v.Size.Y / 2, 0);
                table.insert(u215, {
                    part = v,
                    maxSizeY = v.Size.Y,
                    fullSize = v.Size,
                    bottomCF = v218,
                    rotation = v217.Rotation,
                    partAge = v216
                });
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 475
            -- upvalues: u214 (copy), u215 (copy), PrimaryPart (copy)
            local v219 = u214:GetAttribute("Age") or 0;

            for _, v in u215 do
                local v220 = math.min(v219 - v.partAge, 1);
                local v221 = math.clamp(v220, 0, 1);

                if v221 ~= v.lastProgress then
                    v.lastProgress = v221;

                    if v220 > 0 then
                        local v222 = v.maxSizeY * v220;
                        v.part.Size = Vector3.new(v.fullSize.X, v222, v.fullSize.Z);
                        local v223 = v.bottomCF * CFrame.new(0, v222 / 2, 0);
                        v.part.CFrame = PrimaryPart.CFrame * CFrame.new(v223.Position) * v.rotation;
                        v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                        v.part.CanCollide = true;
                    else
                        v.part.Transparency = 1;
                        v.part.CanCollide = false;
                    end;
                end;
            end;

            if game.Players.LocalPlayer and (game:GetService("RunService"):IsClient() and (not u214:GetAttribute("playedSfx") and u214:GetAttribute("MaxAge") <= v219)) then
                u214:SetAttribute("playedSfx", true);
                game.SoundService:PlayLocalSound(game.SoundService.SFX.Happy);
            end;
        end;

        u214:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};