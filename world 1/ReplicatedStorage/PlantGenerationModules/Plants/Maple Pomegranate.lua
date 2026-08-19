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

        local function orientYAlongDir(p7, p8) -- Line: 32
            local Unit = p8.Unit;
            local v9 = Vector3.new(0, 0, 1);
            local v10 = Unit:Dot(v9);
            local Unit2 = Unit:Cross(math.abs(v10) > 0.99 and Vector3.new(1, 0, 0) or v9).Unit;

            return CFrame.fromMatrix(p7, Unit2, Unit);
        end;

        local function makeBlock(p11, p12, p13, p14) -- Line: 42
            -- upvalues: Stud_Part (copy), u1 (copy)
            local v15 = Stud_Part:Clone();
            v15.Size = p11;
            v15.CFrame = p12;
            v15.Color = p14 or Color3.fromRGB(144, 80, 47);
            v15.Anchored = true;
            v15.CanCollide = false;
            v15:SetAttribute("OG_Transparency", 0);
            v15.Name = tostring(p13);
            v15.Parent = u1;

            return v15;
        end;

        local function makeLeaf(p16, p17, p18, p19) -- Line: 55
            -- upvalues: makeBlock (copy), u6 (copy)
            local v20 = makeBlock(p16, p17, p18, p19);
            v20:SetAttribute("IsLeaf", true);
            table.insert(u6, v20);

            return v20;
        end;

        local function makeSegment(p21, p22, p23, p24, p25) -- Line: 62
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
            local v30 = makeBlock(Vector3.new(p23, Magnitude + 0.05, p23), v29, p24, p25);
            v30.Material = "Glacier";
            v30.MaterialVariant = "2022 Stud Bark";
        end;

        local v31 = 18 * v5;
        local v32 = 2.2 * v5;
        local v33 = 1.6 * v5;
        local v34 = 0.7 * v5;
        local v35 = 0 + 1;
        local v36 = 2.5 * v5;
        local v37 = 2.5 * v5;
        local v38 = makeBlock(Vector3.new(v37, v36, v37), CFrame.new(Position + Vector3.new(0, v36 / 2, 0)), v35);
        v38.Material = "Glacier";
        v38.MaterialVariant = "2022 Stud Bark";
        local v39 = {};
        local v40 = 0;
        local v41 = {};
        local v42 = 0;

        local function getRedColor(p43) -- Line: 18
            local v44 = 206 + p43:NextInteger(-15, 25);
            local v45 = 132 + p43:NextInteger(-20, 20);
            local v46 = 16 + p43:NextInteger(-8, 12);

            return Color3.fromRGB(math.clamp(v44, 0, 255), math.clamp(v45, 0, 255), (math.clamp(v46, 0, 255)));
        end;

        for i = 0, 2 do
            for i2 = 0, 1 do
                local v47 = i / 3 * 3.141592653589793 * 2;
                local v48 = v47 + (i2 / 2 - 0.5) * 1.5 + (v4:NextNumber() - 0.5) * 0.4;
                local v49 = 6 + v4:NextNumber() * 5;
                local v50 = 1 + v4:NextNumber() * 0.4;
                local v51 = 0.15 + v4:NextNumber() * 0.1;
                local v52 = 0.8 + v4:NextNumber() * 1.2;
                local v53 = math.cos(v47) * v32 * 0.5;
                local v54 = v4:NextNumber() * 1;
                local v55 = math.sin(v47) * v32 * 0.5;
                local v56 = Position + Vector3.new(v53, v54, v55);
                local v57 = math.floor(v49 * 0.3);
                local v58 = v57 < 2 and 2 or v57;
                local v59 = v4:NextNumber() * 100;
                local v60 = {};

                for i3 = 0, v58 do
                    local v61 = i3 / v58;
                    local v62 = v61 * v49;
                    local v63 = math.sin(v59) * 0.5 + 1.8;
                    local v64 = math.cos(v59 * 0.7) * 0.8 + 3.2;
                    local v65 = math.sin(v59 * 1.3) * 0.3 + 0.6;
                    local v66 = math.cos(v59 * 0.9) * 0.15 + 0.3;
                    local v67 = math.sin(v61 * 3.141592653589793 * v63 + v59) * v65 * v61 + math.sin(v61 * 3.141592653589793 * v64 + v59 * 2.1) * v66 * v61;
                    local v68 = v52 * (1 - v61) + math.sin(v61 * 3.141592653589793 * 1.5 + v59 * 0.5) * 0.15 * v61;

                    if v61 > 0.3 then
                        v68 = v68 - (v61 - 0.3) * 0.3;
                    end;

                    local v69 = math.max(v68, -0.15);
                    local v70 = v48 + 1.5707963267948966;
                    local v71 = math.cos(v48) * v62 + math.cos(v70) * v67;
                    local v72 = math.sin(v48) * v62 + math.sin(v70) * v67;
                    v60[i3 + 1] = v56 + Vector3.new(v71, v69, v72) * v5;
                end;

                local v73 = {};

                for i3 = 1, #v60 - 1 do
                    v73[i3] = (v50 + (v51 - v50) * ((i3 - 1) / (#v60 - 1))) * v5;
                end;

                table.insert(v39, {
                    points = v60,
                    widths = v73
                });

                if v40 < #v60 - 1 then
                    v40 = #v60 - 1;
                end;

                if v4:NextNumber() > 0.45 and #v60 > 4 then
                    local v74 = math.floor(#v60 * 0.45) + v4:NextInteger(0, (math.floor(#v60 * 0.2)));
                    local v75 = math.clamp(v74, 2, #v60 - 1);
                    local v76 = v48 + (v4:NextNumber() - 0.5) * 1.2;
                    local v77 = v49 * (0.25 + v4:NextNumber() * 0.25);
                    local v78 = v50 * 0.45;
                    local v79 = math.floor(v77 * 0.3);
                    local v80 = v79 < 2 and 2 or v79;
                    local v81 = v4:NextNumber() * 100;
                    local v82 = v60[v75];
                    local v83 = {};

                    for i3 = 0, v80 do
                        local v84 = i3 / v80;
                        local v85 = v84 * v77;
                        local v86 = math.sin(v81) * 0.5 + 1.8;
                        local v87 = math.cos(v81 * 0.7) * 0.8 + 3.2;
                        local v88 = math.sin(v81 * 1.3) * 0.3 + 0.6;
                        local v89 = math.cos(v81 * 0.9) * 0.15 + 0.3;
                        local v90 = math.sin(v84 * 3.141592653589793 * v86 + v81) * v88 * v84 + math.sin(v84 * 3.141592653589793 * v87 + v81 * 2.1) * v89 * v84;
                        local v91 = (1 - v84) * 0.1 + math.sin(v84 * 3.141592653589793 * 1.5 + v81 * 0.5) * 0.15 * v84;

                        if v84 > 0.3 then
                            v91 = v91 - (v84 - 0.3) * 0.3;
                        end;

                        local v92 = math.max(v91, -0.15);
                        local v93 = v76 + 1.5707963267948966;
                        local v94 = math.cos(v76) * v85 + math.cos(v93) * v90;
                        local v95 = math.sin(v76) * v85 + math.sin(v93) * v90;
                        v83[i3 + 1] = v82 + Vector3.new(v94, v92, v95) * v5;
                    end;

                    local v96 = {};

                    for i3 = 1, #v83 - 1 do
                        v96[i3] = (v78 + (v51 - v78) * ((i3 - 1) / (#v83 - 1))) * v5;
                    end;

                    table.insert(v41, {
                        points = v83,
                        widths = v96
                    });

                    if v42 < #v83 - 1 then
                        v42 = #v83 - 1;
                    end;
                end;
            end;
        end;

        for i = 1, v40 do
            v35 = v35 + 1;

            for _, v in v39 do
                if i <= #v.points - 1 then
                    local v97 = v.points[i];
                    local v98 = v.points[i + 1];
                    local v99 = v.widths[i];
                    local v100 = (v97 + v98) / 2;
                    local v101 = v98 - v97;
                    local Magnitude = v101.Magnitude;

                    if Magnitude >= 0.01 then
                        local Unit = v101.Unit;
                        local v102 = Vector3.new(0, 0, 1);
                        local v103 = Unit:Dot(v102);
                        local Unit2 = Unit:Cross(math.abs(v103) > 0.99 and Vector3.new(1, 0, 0) or v102).Unit;
                        local v104 = CFrame.fromMatrix(v100, Unit2, Unit);
                        local v105 = makeBlock(Vector3.new(v99, Magnitude + 0.05, v99), v104, v35, nil);
                        v105.Material = "Glacier";
                        v105.MaterialVariant = "2022 Stud Bark";
                    end;
                end;
            end;
        end;

        for i = 1, v42 do
            v35 = v35 + 1;

            for _, v in v41 do
                if i <= #v.points - 1 then
                    local v106 = v.points[i];
                    local v107 = v.points[i + 1];
                    local v108 = v.widths[i];
                    local v109 = (v106 + v107) / 2;
                    local v110 = v107 - v106;
                    local Magnitude = v110.Magnitude;

                    if Magnitude >= 0.01 then
                        local Unit = v110.Unit;
                        local v111 = Vector3.new(0, 0, 1);
                        local v112 = Unit:Dot(v111);
                        local Unit2 = Unit:Cross(math.abs(v112) > 0.99 and Vector3.new(1, 0, 0) or v111).Unit;
                        local v113 = CFrame.fromMatrix(v109, Unit2, Unit);
                        local v114 = makeBlock(Vector3.new(v108, Magnitude + 0.05, v108), v113, v35, nil);
                        v114.Material = "Glacier";
                        v114.MaterialVariant = "2022 Stud Bark";
                    end;
                end;
            end;
        end;

        local v115 = {};
        local v116 = {};
        local v117 = {};

        for i = 0, 2 do
            v115[i] = {};
            local v118 = i / 3 * 3.141592653589793 * 2;

            for i2 = 0, 10 do
                local v119 = i2 / 10;
                local v120 = v118 + v119 * 3.141592653589793 * 2 * 1;
                local v121 = v32 * (1 - v119 * 0.4);
                local v122 = v115[i];
                local v123 = {};
                local v124 = math.cos(v120) * v121;
                local v125 = math.sin(v120) * v121;
                v123.pos = Position + Vector3.new(v124, v119 * v31, v125);
                v123.t = v119;
                v123.angle = v120;
                v122[i2] = v123;
            end;
        end;

        for i = 0, 10 do
            v35 = v35 + 1;

            if i < 4 then
                local v126 = i / 4;
                local v127 = (2 - v126 * 1) * v5;
                local v128 = v31 / 4 + 0.1;
                local v129 = Position + Vector3.new(0, v126 * v31 + v128 / 2, 0);
                local v130 = makeBlock(Vector3.new(v127, v128, v127), CFrame.new(v129), v35);
                v130.MaterialVariant = "2022 Stud Bark";
                v130.Material = "Glacier";
            end;

            if i > 0 and i <= 10 then
                for i2 = 0, 2 do
                    local v131 = v115[i2][i];
                    local v132 = v33 + (v34 - v33) * v131.t;
                    local pos = v115[i2][i - 1].pos;
                    local pos2 = v131.pos;
                    local v133 = (pos + pos2) / 2;
                    local v134 = pos2 - pos;
                    local Magnitude = v134.Magnitude;

                    if Magnitude >= 0.01 then
                        local Unit = v134.Unit;
                        local v135 = Vector3.new(0, 0, 1);
                        local v136 = Unit:Dot(v135);
                        local Unit2 = Unit:Cross(math.abs(v136) > 0.99 and Vector3.new(1, 0, 0) or v135).Unit;
                        local v137 = CFrame.fromMatrix(v133, Unit2, Unit);
                        local v138 = makeBlock(Vector3.new(v132, Magnitude + 0.05, v132), v137, v35, nil);
                        v138.Material = "Glacier";
                        v138.MaterialVariant = "2022 Stud Bark";
                    end;

                    if v131.t < 0.15 then
                        table.insert(v117, {
                            pos = v131.pos,
                            angle = v131.angle,
                            helix = i2
                        });
                    end;

                    if v131.t > 0.85 then
                        table.insert(v116, {
                            pos = v131.pos,
                            angle = v131.angle,
                            helix = i2
                        });
                    end;
                end;
            end;
        end;

        local v139 = 6 + v4:NextInteger(0, 3);
        local v140 = {};

        for i = 1, v139 do
            local v141 = i / v139 * 3.141592653589793 * 2 + (v4:NextNumber() - 0.5) * 0.4;
            local v142 = 30 + v4:NextNumber() * 30;
            local v143 = math.rad(v142);
            local v144 = (4 + v4:NextNumber() * 4) * v5;
            local v145 = (1 + v4:NextNumber() * 0.5) * v5;
            local v146 = (0.2 + v4:NextNumber() * 0.15) * v5;
            local v147 = v31 * (0.55 + v4:NextNumber() * 0.45);
            local v148 = math.cos(v141) * v32 * 0.4;
            local v149 = math.sin(v141) * v32 * 0.4;
            local v150 = Vector3.new(v148, 0, v149);
            local v151 = Position + Vector3.new(0, v147, 0) + v150;
            local v152 = v4:NextNumber() * 100;

            for i2 = 1, 2 do
                local v153 = i2 / 2;
                local v154 = math.cos(v141);
                local v155 = math.sin(v141);
                local v156 = math.sin(v143) * (1 - v153 * 0.4);
                local v157 = math.sin(v153 * 3.141592653589793 * 2 + v152) * 0.2 * v153;
                local v158 = math.cos(v153 * 3.141592653589793 * 1.5 + v152 * 1.3) * 0.15 * v153;
                local v159 = v151 + Vector3.new(v154 + v157, v156, v155 + v158).Unit * (v144 / 2) * v5;
                local v160 = v145 + (v146 - v145) * v153;
                v35 = v35 + 1;
                local v161 = (v151 + v159) / 2;
                local v162 = v159 - v151;
                local Magnitude = v162.Magnitude;

                if Magnitude >= 0.01 then
                    local Unit = v162.Unit;
                    local v163 = Vector3.new(0, 0, 1);
                    local v164 = Unit:Dot(v163);
                    local Unit2 = Unit:Cross(math.abs(v164) > 0.99 and Vector3.new(1, 0, 0) or v163).Unit;
                    local v165 = CFrame.fromMatrix(v161, Unit2, Unit);
                    local v166 = makeBlock(Vector3.new(v160, Magnitude + 0.05, v160), v165, v35, nil);
                    v166.Material = "Glacier";
                    v166.MaterialVariant = "2022 Stud Bark";
                end;

                if v153 > 0.3 and (v153 < 0.85 and v4:NextNumber() > 0.55) then
                    local v167 = v141 + (v4:NextNumber() - 0.5) * 1.2;
                    local v168 = 15 + v4:NextNumber() * 35;
                    local v169 = math.rad(v168);
                    local v170 = v144 * (0.3 + v4:NextNumber() * 0.3);
                    local v171 = v160 * 0.75;
                    v151 = v159;

                    for i3 = 1, 1 do
                        local v172 = i3 / 1;
                        local v173 = math.cos(v167) + math.sin(v172 * 3.141592653589793 + v152) * 0.15;
                        local v174 = math.sin(v169) * (1 - v172 * 0.5);
                        local v175 = math.sin(v167) + math.cos(v172 * 3.141592653589793 + v152) * 0.15;
                        local v176 = v159 + Vector3.new(v173, v174, v175).Unit * (v170 / 1) * v5;
                        local v177 = v171 + (v146 - v171) * v172;
                        v35 = v35 + 1;
                        local v178 = (v159 + v176) / 2;
                        local v179 = v176 - v159;
                        local Magnitude2 = v179.Magnitude;

                        if Magnitude2 >= 0.01 then
                            local Unit = v179.Unit;
                            local v180 = Vector3.new(0, 0, 1);
                            local v181 = Unit:Dot(v180);
                            local Unit2 = Unit:Cross(math.abs(v181) > 0.99 and Vector3.new(1, 0, 0) or v180).Unit;
                            local v182 = CFrame.fromMatrix(v178, Unit2, Unit);
                            local v183 = makeBlock(Vector3.new(v177, Magnitude2 + 0.05, v177), v182, v35, nil);
                            v183.Material = "Glacier";
                            v183.MaterialVariant = "2022 Stud Bark";
                        end;

                        v159 = v176;
                    end;

                    table.insert(v140, v159);
                else
                    v151 = v159;
                end;
            end;

            table.insert(v140, v151);
        end;

        for _, v in v140 do
            for _ = 1, 2 + v4:NextInteger(0, 2) do
                local v184 = (v4:NextNumber() - 0.5) * 6 * v5;
                local v185 = (v4:NextNumber() - 0.3) * 4 * v5;
                local v186 = (v4:NextNumber() - 0.5) * 6 * v5;
                local v187 = v + Vector3.new(v184, v185, v186);
                local v188 = (4 + v4:NextNumber() * 4) * v5;
                local v189 = (1.8 + v4:NextNumber() * 1.4) * v5;
                local v190 = CFrame.new(v187) * CFrame.Angles((v4:NextNumber() - 0.5) * 0.3, v4:NextNumber() * 3.141592653589793 * 2, (v4:NextNumber() - 0.5) * 0.3);
                v35 = v35 + 1;
                local v191 = makeBlock(Vector3.new(v188, v189, v188), v190, v35, (getRedColor(v4)));
                v191:SetAttribute("IsLeaf", true);
                table.insert(u6, v191);
            end;
        end;

        local v192 = Position + Vector3.new(0, v31 * 1.05, 0);
        local v193 = 11 * v5;
        local v194 = 7 * v5;

        for _ = 1, 20 + v4:NextInteger(0, 10) do
            local v195 = v4:NextNumber() * 3.141592653589793 * 2;
            local v196 = v4:NextNumber() * 3.141592653589793 * 0.6;
            local v197 = v193 * (0.4 + v4:NextNumber() * 0.6);
            local v198 = math.cos(v195) * math.sin(v196) * v197;
            local v199 = math.cos(v196) * v194 * 0.5 + (v4:NextNumber() - 0.3) * 2.5 * v5;
            local v200 = math.sin(v195) * math.sin(v196) * v197;
            local v201 = v192 + Vector3.new(v198, v199, v200);
            local v202 = (4.5 + v4:NextNumber() * 5) * v5;
            local v203 = (1.5 + v4:NextNumber() * 1.8) * v5;
            local v204 = CFrame.new(v201) * CFrame.Angles((v4:NextNumber() - 0.5) * 0.4, v4:NextNumber() * 3.141592653589793 * 2, (v4:NextNumber() - 0.5) * 0.4);
            v35 = v35 + 1;
            local v205 = makeBlock(Vector3.new(v202, v203, v202), v204, v35, (getRedColor(v4)));
            v205:SetAttribute("IsLeaf", true);
            table.insert(u6, v205);
        end;

        for _, v in u6 do
            v.CanCollide = true;
        end;

        local v206 = RaycastParams.new();
        v206.FilterType = Enum.RaycastFilterType.Include;
        v206.FilterDescendantsInstances = { u1 };
        local v207 = 8 + v4:NextInteger(0, 6);
        local v208 = Position.Y + v31 * 0.5;
        local v209 = v31 * 1.2;
        local v210 = 0;

        for _ = 1, v207 * 8 do
            if v207 <= v210 then
                break;
            end;

            local v211 = v4:NextNumber() * 3.141592653589793 * 2;
            local v212 = v193 * (0.2 + v4:NextNumber() * 0.8);
            local v213 = Position.X + math.cos(v211) * v212;
            local v214 = Position.Z + math.sin(v211) * v212;
            local v215 = Vector3.new(v213, v208, v214);
            local v216 = workspace:Raycast(v215, Vector3.new(0, v209, 0), v206);

            if v216 and (v216.Instance and v216.Instance:GetAttribute("IsLeaf")) then
                local v217 = v216.Instance.CFrame.Position - Vector3.new(0, v216.Instance.Size.Y / 2, 0);
                local v218 = false;

                for _, child in FruitSpawnLocations:GetChildren() do
                    if (child.CFrame.Position - v217).Magnitude < 3 * v5 then
                        v218 = true;
                        break;
                    end;
                end;

                if not v218 then
                    local Part = Instance.new("Part");
                    Part.Size = Vector3.new(1, 1, 1);
                    Part.Transparency = 1;
                    Part.Anchored = true;
                    Part.CanCollide = false;
                    Part.CFrame = CFrame.new(v217);
                    Part.Name = "Fruit_Spawn";
                    Part.Parent = FruitSpawnLocations;
                    v210 = v210 + 1;
                end;
            end;
        end;

        if v210 < 4 and #u6 > 0 then
            for _ = 1, math.min(6, #u6) do
                if v207 <= v210 then
                    break;
                end;

                local v219 = u6[v4:NextInteger(1, #u6)];
                local v220 = v219.CFrame.Position - Vector3.new(0, v219.Size.Y / 2, 0);
                local v221 = false;

                for _, child in FruitSpawnLocations:GetChildren() do
                    if (child.CFrame.Position - v220).Magnitude < 3 * v5 then
                        v221 = true;
                        break;
                    end;
                end;

                if not v221 then
                    local Part = Instance.new("Part");
                    Part.Size = Vector3.new(1, 1, 1);
                    Part.Transparency = 1;
                    Part.Anchored = true;
                    Part.CanCollide = false;
                    Part.CFrame = CFrame.new(v220);
                    Part.Name = "Fruit_Spawn";
                    Part.Parent = FruitSpawnLocations;
                    v210 = v210 + 1;
                end;
            end;
        end;

        for _, v in u6 do
            v.CanCollide = false;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u222) -- Line: 464, Name: BeginPlantGrowth
        local PrimaryPart = u222.PrimaryPart;
        local u223 = {};

        for _, v in u222:QueryDescendants("BasePart") do
            local v224 = tonumber(v.Name);

            if v224 then
                local v225 = PrimaryPart.CFrame:ToObjectSpace(v.CFrame);
                local v226 = v225 * CFrame.new(0, -v.Size.Y / 2, 0);
                table.insert(u223, {
                    part = v,
                    maxSizeY = v.Size.Y,
                    fullSize = v.Size,
                    bottomCF = v226,
                    rotation = v225.Rotation,
                    partAge = v224
                });
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 488
            -- upvalues: u222 (copy), u223 (copy), PrimaryPart (copy)
            local v227 = u222:GetAttribute("Age") or 0;

            for _, v in u223 do
                local v228 = math.min(v227 - v.partAge, 1);
                local v229 = math.clamp(v228, 0, 1);

                if v229 ~= v.lastProgress then
                    v.lastProgress = v229;

                    if v228 > 0 then
                        local v230 = v.maxSizeY * v228;
                        v.part.Size = Vector3.new(v.fullSize.X, v230, v.fullSize.Z);
                        local v231 = v.bottomCF * CFrame.new(0, v230 / 2, 0);
                        v.part.CFrame = PrimaryPart.CFrame * CFrame.new(v231.Position) * v.rotation;
                        v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                        v.part.CanCollide = true;
                    else
                        v.part.Transparency = 1;
                        v.part.CanCollide = false;
                    end;
                end;
            end;

            if game.Players.LocalPlayer and (game:GetService("RunService"):IsClient() and (not u222:GetAttribute("playedSfx") and u222:GetAttribute("MaxAge") <= v227)) then
                u222:SetAttribute("playedSfx", true);
                game.SoundService:PlayLocalSound(game.SoundService.SFX.Happy);
            end;
        end;

        u222:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};