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

        local u15 = Color3.new(1, 0.92549, 0.631373);
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
            Color3.fromRGB(255, 133, 231),
            Color3.fromRGB(255, 174, 244),
            Color3.fromRGB(255, 98, 226),
            Color3.fromRGB(255, 169, 232)
        };

        for _, v in pairs(v16) do
            local v49 = script.Leaf_Part:Clone();
            local v50 = v8:NextInteger(5, 9) * 1.2;
            local v51 = v50 * (v8:NextInteger(6, 8) * 0.1) * 1.2;
            v49.Size = Vector3.new(v50 * (v7 * 0.1 + 0.9) * v14, v51 * (v7 * 0.1 + 0.9) * v14, v50 * (v7 * 0.1 + 0.9) * v14);
            v49.Color = v48[v8:NextInteger(1, #v48)];
            v49.Name = tostring(u9);
            v49.CFrame = v.CFrame * CFrame.new(0, v49.Size.Y / 2, 0);
            local v52 = v8:NextInteger(-180, 180);
            v49.Orientation = Vector3.new(0, v52, 0);
            v49.Parent = u4;

            for _ = 1, 1 do
                local Part = Instance.new("Part");
                Part.Transparency = 1;
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.Size = Vector3.new(1, 1, 1);
                Part.Parent = FruitSpawnLocations;
                local v53 = RaycastParams.new();
                v53.FilterType = Enum.RaycastFilterType.Include;
                v53.FilterDescendantsInstances = { v49 };
                v53.IgnoreWater = true;
                local v54 = v8:NextNumber(0, 6.283185307179586);
                local v55 = -v8:NextNumber(0.15, 1);
                local v56 = math.sqrt(1 - v55 * v55);
                local v57 = math.cos(v54) * v56;
                local v58 = math.sin(v54) * v56;
                local v59 = Vector3.new(v57, v55, v58);
                local v60 = v49.Position + Vector3.new(v59.X * v49.Size.X * 0.6, v59.Y * v49.Size.Y * 1.2, v59.Z * v49.Size.Z * 0.6);
                local Unit = (v49.Position - v60).Unit;
                local v61 = math.max(v49.Size.X, v49.Size.Y, v49.Size.Z) * 3;
                local v62 = workspace:Raycast(v60, Unit * v61, v53);

                if v62 then
                    Part.Position = v62.Position + v62.Normal * 0.05;
                else
                    Part.Position = v49.Position;
                end;
            end;

            u9 = u9 + 0.25;
        end;

        u4:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u63) -- Line: 251, Name: BeginPlantGrowth
        local PrimaryPart = u63.PrimaryPart;
        local u64 = {};

        for _, v in u63:QueryDescendants("BasePart") do
            local v65 = tonumber(v.Name);

            if v65 then
                local v66 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v65
                };
                table.insert(u64, v66);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        table.sort(u64, function(p67, p68) -- Line: 269
            return p67[4] < p68[4];
        end);

        local function updateGrowth() -- Line: 271
            -- upvalues: u63 (copy), u64 (copy), PrimaryPart (copy)
            local v69 = u63:GetAttribute("Age") or 0;

            for _, v in u64 do
                local v70 = v[1];
                local v71 = v[2];
                local v72 = v[3];
                local v73 = math.clamp(v69 - v[4], 0, 1);

                if v73 ~= v.lastProgress then
                    v.lastProgress = v73;

                    if v73 > 0 then
                        v70.Size = Vector3.new(v71.X * v73, v71.Y * v73, v71.Z * v73);
                        v70.CFrame = PrimaryPart.CFrame * v72 * CFrame.new(0, (v70.Size.Y - v71.Y) / 2, 0);
                        v70.Transparency = v70:GetAttribute("OG_Transparency") or 0;
                        v70.CanCollide = true;
                    else
                        v70.Transparency = 1;
                        v70.CanCollide = false;
                    end;
                end;
            end;

            if game.Players.LocalPlayer and (game:GetService("RunService"):IsClient() and (not u63:GetAttribute("playedSfx") and u63:GetAttribute("MaxAge") <= v69)) then
                u63:SetAttribute("playedSfx", true);
                game.SoundService:PlayLocalSound(game.SoundService.SFX.Happy);
            end;
        end;

        u63:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};