-- Decompiled with Potassium's decompiler.

local u1 = game.ReplicatedStorage.Assets["Meshes/BeanStalkMesh"];
local Stud_Part = script.Stud_Part;

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u2, p3, p4) -- Line: 9, Name: InitPlant
        -- upvalues: u1 (copy), Stud_Part (copy)
        local v5 = p4 or 1;
        local v6 = Random.new(p3);
        local FruitSpawnLocations = u2.FruitSpawnLocations;
        local Base = u2.Base;
        local CollectionService = game:GetService("CollectionService");
        local v7 = 3 * v5 * v6:NextInteger(7, 14) * 0.1;
        local v8 = 2 * v5 * v6:NextInteger(7, 14) * 0.1;
        local v9 = v5 * v6:NextInteger(7, 14) * 0.1;
        local v10 = math.clamp(v9, 1, (1 / 0));
        local v11 = math.sqrt(v10) * 30;
        local u12 = 0;

        while v6:NextInteger(1, 10) == 1 do
            v11 = v11 + 5;
        end;

        local v13 = 3 * v6:NextInteger(7, 14) * 0.1;
        local v14 = Base.CFrame * CFrame.new(0, -Base.Size.Y / 2, 0);
        local v15 = 3 * v6:NextInteger(7, 14) * 0.1 * v5;
        local v16 = v6:NextInteger(950, 995) * 0.001;
        local v17 = 0;
        local v18 = {};

        for i = 1, v11 do
            u12 = u12 + 1;
            v7 = v7 * v16;
            v8 = v8 * v16;
            local v19 = i * 0.1 % 2;
            local v20 = v19 <= 1 and v19 and v19 or 2 - v19;
            v17 = v17 + 10;
            local v21 = math.rad(v17);
            local _ = v7 / 2;
            local v22 = CFrame.new(math.cos(v21) * v15, 0, math.sin(v21) * v15);
            local v23 = u1:Clone();
            v23.Size = Vector3.new(v7 * 2, v8 * 1.25, v7 * 2);
            v23.Color = Color3.fromHSV(0.24500000000000002 + v20 * 0.025, 0.5 + v20 * 0.175, 0.5 + v20 * 0.25);
            v23.CFrame = v14 * v22 * CFrame.new(0, v23.Size.Y / 2, 0);
            v23.Name = tostring(u12);
            v23.Parent = u2;

            if u12 % 2 == 0 then
                table.insert(v18, v23);
            end;

            local v24 = v14 * CFrame.new(0, v8, 0);
            v14 = v24 * CFrame.Angles(math.rad(-1 + v20 * 2), math.rad(v13), (math.rad(-1 + v20 * 2)));
        end;

        local function attachWedges(p25) -- Line: 73
            -- upvalues: u12 (ref), Stud_Part (ref), u2 (copy), CollectionService (copy)
            u12 = u12 + 1;
            local v26 = Stud_Part:Clone();
            v26.Anchored = true;
            v26.Shape = Enum.PartType.Wedge;
            v26.Size = Vector3.new(p25.Size.Z, p25.Size.Y * 0.5, p25.Size.X / 2);
            v26.CFrame = p25.CFrame * CFrame.new(-p25.Size.X / 4, -(p25.Size.Y / 2 + v26.Size.Y / 2), 0);
            v26.CFrame = v26.CFrame * CFrame.Angles(0, 1.5707963267948966, 0);
            v26.CFrame = v26.CFrame * CFrame.Angles(0, 0, 3.141592653589793);
            v26.Color = p25.Color;
            v26.Name = tostring(u12);
            v26.Parent = u2;
            CollectionService:AddTag(v26, "DetailPart");
            local v27 = Stud_Part:Clone();
            v27.Shape = Enum.PartType.Wedge;
            v27.Size = Vector3.new(p25.Size.Z, p25.Size.Y * 0.5, p25.Size.X / 2);
            v27.CFrame = p25.CFrame * CFrame.new(p25.Size.X / 4, -(p25.Size.Y / 2 + v27.Size.Y / 2), 0);
            v27.CFrame = v27.CFrame * CFrame.Angles(0, -1.5707963267948966, 0);
            v27.CFrame = v27.CFrame * CFrame.Angles(0, 0, 3.141592653589793);
            v27.Color = p25.Color;
            v27.Name = tostring(u12);
            v27.Parent = u2;
            CollectionService:AddTag(v27, "DetailPart");
        end;

        for i = #v18, 1, -1 do
            local v28 = v18[i];
            u12 = u12 + 1;
            local v29 = v28.CFrame * CFrame.Angles(1.5707963267948966, 0, 0);
            local Angles = CFrame.Angles;
            local v30 = v6:NextInteger(-180, 180);
            local v31 = v29 * Angles(0, 0, (math.rad(v30)));
            local Angles2 = CFrame.Angles;
            local v32 = -v6:NextInteger(30, 45);
            local v33 = v31 * Angles2(math.rad(v32), 0, 0);
            local Magnitude = v28.Size.Magnitude;
            local v34 = Stud_Part:Clone();
            v34.Color = v28.Color;
            local v35 = v6:NextInteger(17, 21) * 0.1 * (Magnitude * 0.34);
            v34.Size = Vector3.new(1 * (Magnitude * 0.2), v35, 2);
            v34.CFrame = v33 * CFrame.new(0, v34.Size.Y / 2, 0);
            v34.Name = tostring(u12);
            v34.Parent = u2;
            u12 = u12 + 1;
            local v36 = v6:NextInteger(27, 30) * 0.1;
            local v37 = Stud_Part:Clone();
            v37.Color = v28.Color;
            v37.Size = Vector3.new(v36 * (Magnitude * 0.2), v36 * (Magnitude * 0.2), 2);
            v37.CFrame = v34.CFrame * CFrame.new(0, v34.Size.Y / 2 + v37.Size.Y / 2, 0) * CFrame.Angles(3.141592653589793, 0, 0);
            v37.Name = tostring(u12);
            v37.Parent = u2;
            CollectionService:AddTag(v37, "DetailPart");
            attachWedges(v37);
            v37.CFrame = v37.CFrame * CFrame.Angles(3.141592653589793, 0, 0);
            local v38 = Stud_Part:Clone();
            v38.CanCollide = false;
            v38.Transparency = 1;
            v38.Size = Vector3.new(0.1, 0.1, 0.1);
            v38.CFrame = CFrame.new((v37.CFrame * CFrame.new(0, 0, v37.Size.Z / 2)).Position) * CFrame.Angles(-1.5707963267948966, 0, 0);
            v38.Orientation = Vector3.new(v38.Orientation.X, -v34.Orientation.Y, v38.Orientation.Z);
            v38.Parent = FruitSpawnLocations;
            v38.Name = "FruitSpawn";
        end;

        u2:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u39) -- Line: 155, Name: BeginPlantGrowth
        local PrimaryPart = u39.PrimaryPart;
        local u40 = {};

        for _, v in u39:QueryDescendants("BasePart") do
            local v41 = tonumber(v.Name);

            if v41 then
                local v42 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v41
                };
                table.insert(u40, v42);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 171
            -- upvalues: u39 (copy), u40 (copy), PrimaryPart (copy)
            local v43 = u39:GetAttribute("Age") or 0;

            for _, v in u40 do
                local v44 = v[1];
                local v45 = v[2];
                local v46 = v[3];
                local v47 = math.min(v43 - v[4], 1);
                local v48 = math.clamp(v47, 0, 1);

                if v48 ~= v.lastProgress then
                    v.lastProgress = v48;

                    if v47 > 0 then
                        v44.Size = Vector3.new(v45.X, v45.Y * v47, v45.Z);
                        v44.CFrame = PrimaryPart.CFrame * v46 * CFrame.new(0, (v44.Size.Y - v45.Y) / 2, 0);
                        v44.Transparency = v44:GetAttribute("OG_Transparency") or 0;
                        v44.CanCollide = true;
                    else
                        v44.Transparency = 1;
                        v44.CanCollide = false;
                    end;
                end;
            end;

            if game.Players.LocalPlayer and (game:GetService("RunService"):IsClient() and (not u39:GetAttribute("playedSfx") and u39:GetAttribute("MaxAge") <= v43)) then
                u39:SetAttribute("playedSfx", true);
                game.SoundService:PlayLocalSound(game.SoundService.SFX.Happy);
            end;
        end;

        u39:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};