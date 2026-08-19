-- Decompiled with Potassium's decompiler.

local function getMiddle50(p1) -- Line: 2
    local v2 = #p1;
    local v3 = {};

    for i = math.floor(v2 * 0.25) + 1, math.ceil(v2 * 0.75) do
        table.insert(v3, p1[i]);
    end;

    return v3;
end;

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u4, p5, p6) -- Line: 19, Name: InitPlant
        -- upvalues: getMiddle50 (copy)
        local v7 = p6 or 1;
        local v8 = Random.new(p5);
        local FruitSpawnLocations = u4.FruitSpawnLocations;
        local Base = u4.Base;
        local u9 = 0;
        local Stud_Part = script.Stud_Part;
        local v10 = v8:NextInteger(4, 7);
        local v11 = 1 * (v7 * 0.25 + 0.75);
        local v12 = 3 * (v7 * 0.25 + 0.75);
        local v13 = 12 * (v7 * 0.25 + 0.75);
        local v14 = 1;

        if v8:NextInteger(1, 300) == 1 then
            v11 = v11 * 3;
            v12 = v12 * 3;
            v13 = v13 * 3;
            v10 = v10 * 3;
            v14 = v14 * 3;
        end;

        while v8:NextInteger(1, 30) == 1 do
            v13 = v13 + v8:NextInteger(4, 7);
            v10 = v10 + v8:NextInteger(4, 7);
            v14 = v14 + 0.25;
        end;

        local u15 = Color3.fromRGB(252, 172, 101);
        local v16 = {};

        local function buildChain(p17, p18, p19, p20, p21, p22, p23, p24, p25, p26) -- Line: 59
            -- upvalues: Stud_Part (copy), u15 (copy), u9 (ref), u4 (copy)
            local v27 = {};

            if p26 then
                p17 = p17 * CFrame.Angles(0, math.rad(p26), 0);
            end;

            for i = 1, p19 do
                local v28 = Stud_Part:Clone();
                v28.Color = u15;
                v28.Size = Vector3.new(p20, p21, p20);
                u9 = u9 + 1;
                v28.Name = tostring(u9);
                v28.CFrame = p17 * CFrame.new(0, p18.Y / 2 + v28.Size.Y / 2, 0);
                v28.CFrame = v28.CFrame * CFrame.new(0, -v28.Size.Y / 2, 0) * CFrame.Angles(math.rad(p22), 0, (math.rad(p23))) * CFrame.new(0, v28.Size.Y / 2, 0);
                v28.Parent = u4;
                p17 = v28.CFrame;
                p18 = v28.Size;
                table.insert(v27, v28);

                if i == 1 then
                    p22 = p24;
                    p23 = p25;
                else
                    p22 = p22 + p24;
                    p23 = p23 + p25;
                end;

                p20 = p20 * 0.95;
                p21 = p21 * 0.95;
            end;

            return v27;
        end;

        u9 = u9 + 1;
        local v29 = (v8:NextNumber() * 2 - 1) * 1.5;
        local v30 = (v8:NextNumber() * 2 - 1) * 1.5;
        local v31 = buildChain(Base.CFrame * CFrame.new(0, -Base.Size.Y / 2, 0), Base.Size, v13, v11, v12, v29, v30, v29 * 0.2, v30 * 0.2, nil);
        local v32 = getMiddle50(v31);

        for _ = 1, v10 do
            local v33 = v32[v8:NextInteger(1, #v32)];
            local v34 = v11 * 0.75;
            local v35 = v12 * 0.5;
            local v36 = v8:NextInteger(6, 10);
            local v37 = v8:NextInteger(40, 70) * (v8:NextInteger(0, 1) == 0 and -1 or 1);
            local v38 = v8:NextInteger(40, 70) * (v8:NextInteger(0, 1) == 0 and -1 or 1);
            local v39 = v8:NextInteger(-180, 180);
            local v40 = buildChain(v33.CFrame, v33.Size, v36, v34, v35, v37, v38, 2.5, 2.5, v39);

            if #v40 > 0 then
                table.insert(v16, v40[#v40]);
            end;

            local v41 = v8:NextInteger(1, 3);

            if #v40 > 2 then
                v40 = getMiddle50(v40);
            end;

            for _ = 1, v41 do
                if #v40 == 0 then
                    break;
                end;

                local v42 = v40[v8:NextInteger(1, #v40)];
                local v43 = v8:NextInteger(4, 6);
                local v44 = v8:NextInteger(35, 65) * (v8:NextInteger(0, 1) == 0 and -1 or 1);
                local v45 = v8:NextInteger(35, 65) * (v8:NextInteger(0, 1) == 0 and -1 or 1);
                local v46 = v8:NextInteger(-180, 180);
                local v47 = buildChain(v42.CFrame, v42.Size, v43, v34 * 0.65, v35 * 0.5, v44, v45, 2, 2, v46);

                if #v47 > 0 then
                    table.insert(v16, v47[#v47]);
                end;
            end;
        end;

        table.insert(v16, v31[#v31]);
        local v48 = {
            Color3.fromRGB(243, 121, 0),
            Color3.fromRGB(246, 158, 72),
            Color3.fromRGB(250, 76, 41),
            Color3.fromRGB(246, 158, 72)
        };
        local v49 = 0;

        for _, v in pairs(v16) do
            local v50 = script.Leaf_Part:Clone();
            local v51 = v8:NextInteger(5, 9) * 1.2;
            local v52 = v51 * (v8:NextInteger(6, 8) * 0.1) * 1.2;
            v50.Size = Vector3.new(v51 * (v7 * 0.1 + 0.9) * v14, v52 * (v7 * 0.1 + 0.9) * v14, v51 * (v7 * 0.1 + 0.9) * v14);
            v50.Color = v48[v8:NextInteger(1, #v48)];
            v50.Name = tostring(u9);
            v50.CFrame = v.CFrame * CFrame.new(0, v50.Size.Y / 2, 0);
            local v53 = v8:NextInteger(-180, 180);
            v50.Orientation = Vector3.new(0, v53, 0);
            v50.Parent = u4;

            if v49 < 2 and v8:NextInteger(1, 3) == 1 then
                script.LeafParticle:Clone().Parent = v50;
                v49 = v49 + 1;
            end;

            for _ = 1, 1 do
                local Part = Instance.new("Part");
                Part.Transparency = 1;
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.Size = Vector3.new(1, 1, 1);
                Part.Parent = FruitSpawnLocations;
                local v54 = RaycastParams.new();
                v54.FilterType = Enum.RaycastFilterType.Include;
                v54.FilterDescendantsInstances = { v50 };
                v54.IgnoreWater = true;
                local v55 = v8:NextNumber(0, 6.283185307179586);
                local v56 = -v8:NextNumber(0.15, 1);
                local v57 = math.sqrt(1 - v56 * v56);
                local v58 = math.cos(v55) * v57;
                local v59 = math.sin(v55) * v57;
                local v60 = Vector3.new(v58, v56, v59);
                local v61 = v50.Position + Vector3.new(v60.X * v50.Size.X * 0.6, v60.Y * v50.Size.Y * 1.2, v60.Z * v50.Size.Z * 0.6);
                local Unit = (v50.Position - v61).Unit;
                local v62 = math.max(v50.Size.X, v50.Size.Y, v50.Size.Z) * 3;
                local v63 = workspace:Raycast(v61, Unit * v62, v54);

                if v63 then
                    Part.Position = v63.Position + v63.Normal * 0.05;
                else
                    Part.Position = v50.Position;
                end;
            end;

            u9 = u9 + 0.25;
        end;

        u4:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u64) -- Line: 259, Name: BeginPlantGrowth
        local PrimaryPart = u64.PrimaryPart;
        local u65 = {};

        for _, v in u64:QueryDescendants("BasePart") do
            local v66 = tonumber(v.Name);

            if v66 then
                local v67 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v66
                };
                table.insert(u65, v67);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        table.sort(u65, function(p68, p69) -- Line: 277
            return p68[4] < p69[4];
        end);

        local function updateGrowth() -- Line: 279
            -- upvalues: u64 (copy), u65 (copy), PrimaryPart (copy)
            local v70 = u64:GetAttribute("Age") or 0;
            local v71 = u64:GetAttribute("MaxAge") or 1;

            for _, v in u65 do
                local v72 = v[1];
                local v73 = v[2];
                local v74 = v[3];
                local v75 = math.clamp(v70 - v[4], 0, 1);

                if v75 ~= v.lastProgress then
                    v.lastProgress = v75;

                    if v75 > 0 then
                        v72.Size = Vector3.new(v73.X * v75, v73.Y * v75, v73.Z * v75);
                        v72.CFrame = PrimaryPart.CFrame * v74 * CFrame.new(0, (v72.Size.Y - v73.Y) / 2, 0);
                        v72.Transparency = v72:GetAttribute("OG_Transparency") or 0;
                        v72.CanCollide = true;
                    else
                        v72.Transparency = 1;
                        v72.CanCollide = false;
                    end;
                end;
            end;

            if v71 <= v70 then
                for _, v in u64:QueryDescendants("ParticleEmitter") do
                    v.Enabled = true;
                end;
            end;

            if game.Players.LocalPlayer and (game:GetService("RunService"):IsClient() and (not u64:GetAttribute("playedSfx") and u64:GetAttribute("MaxAge") <= v70)) then
                u64:SetAttribute("playedSfx", true);
                game.SoundService:PlayLocalSound(game.SoundService.SFX.Happy);
            end;
        end;

        u64:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};