-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(p1, p2, p3) -- Line: 7, Name: InitPlant
        local v4 = Random.new(p2);
        local _ = p1.FruitSpawnLocations;
        local Base = p1.Base;
        local v5 = 0.75 + (p3 or 1) * 0.25;
        local v6 = 4 * v5;
        local v7 = 5 * v5;
        local v8 = 0.3 * v5;
        local CFrame2 = Base.CFrame;
        local Size = Base.Size;
        local v9 = 0;
        local v10 = {};

        for _ = 1, 1000 do
            if v6 > 1.5 then
                v9 = v9 + 1;
                v6 = v6 - v8;
                v7 = v7 - v8 * 0.5;
                local v11 = game.ReplicatedStorage.Assets.Stud_Part:Clone();
                v11.Size = Vector3.new(v6, v7, v6);
                v11.CFrame = CFrame2 * CFrame.new(0, Size.Y / 2 + v11.Size.Y / 2, 0);
                v11.Anchored = true;
                v11.CanCollide = false;
                v11.Color = Color3.new(0.27451, 0.180392, 0.0627451);
                v11.Name = tostring(v9);
                CFrame2 = v11.CFrame;
                Size = v11.Size;
                v11.Parent = p1;
                table.insert(v10, v11);
            end;
        end;

        local v12 = 0;
        local v13 = 0;
        local v14 = {};

        for _, v in pairs(v10) do
            local v15 = math.sqrt(v.Size.X * 15);
            local v16 = math.round(v15);
            v12 = v12 + 1;

            for i = 1, v16 do
                v9 = v9 + 1;
                local v17 = v:Clone();
                v17.Size = Vector3.new(v.Size.X * 0.5, v.Size.Y, v.Size.X * 0.5);

                if v13 < v17.Size.X then
                    v13 = v17.Size.X;
                end;

                local CFrame3 = v.CFrame;
                local Angles = CFrame.Angles;
                local v18 = math.rad(360 / v16 * i + v12 * 5);
                local v19 = v4:NextInteger(-20, 20);
                local v20 = CFrame3 * Angles(0, v18, (math.rad(v19)));
                local Angles2 = CFrame.Angles;
                local v21 = 90 - v12 * 10 + v4:NextInteger(-10, 10) * (v12 * 0.5 + 1);
                local v22 = math.clamp(v21, 5, 90);
                v17.CFrame = v20 * Angles2(math.rad(v22), 0, 0) * CFrame.new(0, v17.Size.Y / 2, 0);
                v17.Name = tostring(v9);
                v17.Anchored = true;
                v17.Parent = p1;
                table.insert(v14, v17);
            end;
        end;

        local v23 = (1 / 0);
        local v24 = (-1 / 0);

        for _, v in pairs(v14) do
            if v.Position.Y < v23 then
                v23 = v.Position.Y;
            end;

            if v24 < v.Position.Y then
                v24 = v.Position.Y;
            end;
        end;

        for _, v in pairs(v14) do
            v9 = v9 + 1;
            local v25 = v.Size.X * 3 + 1;
            local v26 = math.clamp(1 + v.Size.X * 0.25, 1, 3);
            local v27 = 0.3 + (v24 == v23 and 0.5 or (v.Position.Y - v23) / (v24 - v23)) * 0.5;

            for _ = 1, v26 do
                local v28 = v:Clone();
                v28.Size = Vector3.new(v25, v25, v25);
                v28.Name = tostring(v9);
                v28.Color = Color3.fromHSV(0.333333, 0.876921, v27);
                v28.Parent = p1;
                v28.CFrame = v.CFrame * CFrame.new(0, v.Size.Y / 2 + v28.Size.Y / 2, 0);
                local v29 = v4:NextInteger(0, 360);
                local v30 = v4:NextInteger(0, 360);
                v28.Orientation = Vector3.new(v29, v30, v4:NextInteger(0, 360));
            end;
        end;

        p1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u31) -- Line: 106, Name: BeginPlantGrowth
        local PrimaryPart = u31.PrimaryPart;
        local u32 = {};

        for _, v in u31:QueryDescendants("BasePart") do
            local v33 = tonumber(v.Name);

            if v33 then
                local v34 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v33
                };
                table.insert(u32, v34);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 124
            -- upvalues: u31 (copy), u32 (copy), PrimaryPart (copy)
            local v35 = u31:GetAttribute("Age") or 0;

            for _, v in u32 do
                local v36 = v[1];
                local v37 = v[2];
                local v38 = v[3];
                local v39 = math.min(v35 - v[4], 1);
                local v40 = math.clamp(v39, 0, 1);

                if v40 ~= v.lastProgress then
                    v.lastProgress = v40;

                    if v39 > 0 then
                        v36.Size = Vector3.new(v37.X, v37.Y * v39, v37.Z);
                        v36.CFrame = PrimaryPart.CFrame * v38 * CFrame.new(0, (v36.Size.Y - v37.Y) / 2, 0);
                        v36.Transparency = v36:GetAttribute("OG_Transparency") or 0;
                        v36.CanCollide = true;
                    else
                        v36.Transparency = 1;
                        v36.CanCollide = false;
                    end;
                end;
            end;

            if game.Players.LocalPlayer and (game:GetService("RunService"):IsClient() and (not u31:GetAttribute("playedSfx") and u31:GetAttribute("MaxAge") <= v35)) then
                u31:SetAttribute("playedSfx", true);
                game.SoundService:PlayLocalSound(game.SoundService.SFX.Happy);
            end;
        end;

        u31:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};