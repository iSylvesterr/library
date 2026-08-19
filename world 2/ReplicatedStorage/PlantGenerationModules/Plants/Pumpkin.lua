-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25,
        BaseWeight = 5
    },

    InitPlant = function(p1, p2, p3) -- Line: 7, Name: InitPlant
        Random.new(p2);
        local Base = p1.Base;
        local v4 = 3 * (p3 or 1);
        local v5 = script.Main:Clone();
        v5.Size = Vector3.new(v4, v4, v4);
        v5.CFrame = Base.CFrame * CFrame.new(0, -Base.Size.Y / 2 + v5.Size.Y / 2, 0) * CFrame.Angles(0, 0, 1.5707963267948966);
        v5.Parent = p1;
        local v6 = v4 * 0.15;
        local v7 = v6 * 1.2;
        local v8 = v5.CFrame * CFrame.new(0, v5.Size.Y / 2, 0);
        local v9 = {};
        local v10 = { v8 };
        local v11 = 1;

        for _ = 1, 8 do
            local v12 = v8 * CFrame.Angles(0, 0, 0.20943951023931956);
            local v13 = v12 * CFrame.new(0, v7 / 2, 0);
            local v14 = script.Stem:Clone();
            v14.Size = Vector3.new(v6, v7, v6);
            v14.CFrame = v13;
            v14:SetAttribute("GrowUp", true);
            v14.Parent = p1;
            table.insert(v9, v14);
            v8 = v12 * CFrame.new(0, v7, 0);
            table.insert(v10, v8);
        end;

        for i = #v9, 1, -1 do
            v9[i].Name = tostring(v11);
            v11 = v11 + 1;
        end;

        local v15 = v4 * 0.25;
        local v16 = v4 * 0.03;
        local v17 = { 1, -1, 1 };
        local v18 = { 25, -20, 30 };

        for i, v in ipairs({ 3, 5, 7 }) do
            if v10[v] then
                local v19 = v17[i];
                local v20 = v18[i];
                local v21 = v15 * (1 - (i - 1) * 0.15);
                local v22 = script.Stem:Clone();
                v22.Size = Vector3.new(v21, v16, v21);
                v22.CFrame = v10[v] * CFrame.new(v21 * 0.5 * v19, 0, v16 * 2) * CFrame.Angles(math.rad(v20), 0, (math.rad(v20 * v19)));
                v22:SetAttribute("GrowUp", true);
                v22.Name = tostring(v11);
                v22.Parent = p1;
                v11 = v11 + 1;
            end;
        end;

        local v23 = v4 * 0.07;
        local v24 = v6 * 0.95;
        local v25 = {};

        for i = 0, 28 do
            local v26 = i / 28;
            local v27 = v5.CFrame * CFrame.new(0, v5.Size.Y / 2, 0);
            local v28 = v26 * 8;

            for _ = 1, math.floor(v28) do
                v27 = v27 * CFrame.Angles(0, 0, 0.20943951023931956) * CFrame.new(0, v7, 0);
            end;

            local v29 = v28 - math.floor(v28);
            local v30 = v27 * CFrame.Angles(0, 0, v29 * 0.20943951023931956) * CFrame.new(0, v7 * v29, 0);
            local v31 = v26 * 3.141592653589793 * 2 * 1.5;
            local v32 = math.cos(v31) * v24;
            local v33 = math.sin(v31) * v24;
            local v34 = v30 * CFrame.new(v32, 0, v33);
            table.insert(v25, v34);
        end;

        for i = 1, #v25 - 1 do
            local Position = v25[i].Position;
            local Position2 = v25[i + 1].Position;
            local Magnitude = (Position2 - Position).Magnitude;
            local v35 = CFrame.lookAt(Position, Position + (Position2 - Position).Unit) * CFrame.Angles(-1.5707963267948966, 0, 0);
            local v36 = script.Stem:Clone();
            v36.Size = Vector3.new(v23, Magnitude, v23);
            v36.CFrame = v35 * CFrame.new(0, Magnitude / 2, 0);
            v36:SetAttribute("GrowUp", true);
            v36.Name = tostring(v11);
            v36.Parent = p1;
            v11 = v11 + 1;
        end;

        v5.Name = tostring(v11);
        v5.CFrame = v5.CFrame * CFrame.Angles(0, 3.141592653589793, 0);
        p1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u37) -- Line: 126, Name: BeginPlantGrowth
        local PrimaryPart = u37.PrimaryPart;
        local u38 = {};

        for _, v in u37:QueryDescendants("BasePart") do
            local v39 = tonumber(v.Name);

            if v39 then
                local v40 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v39
                };
                table.insert(u38, v40);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 142
            -- upvalues: u37 (copy), u38 (copy), PrimaryPart (copy)
            local v41 = u37:GetAttribute("Age") or 0;
            local v42 = u37:GetAttribute("MaxAge") or 1;
            local v43 = v41 / v42;

            for _, v in u38 do
                local v44 = v[1];
                local v45 = v[2];
                local v46 = v[3];
                local v47 = math.min((v43 - v[4] / v42) * v42, 1);
                local v48 = math.clamp(v47, 0, 1);

                if v48 ~= v.lastProgress then
                    v.lastProgress = v48;

                    if v47 > 0 then
                        v44.Size = Vector3.new(v45.X, v45.Y * v47, v45.Z);
                        local v49;

                        if v44:GetAttribute("GrowUp") then
                            v49 = (v45.Y - v44.Size.Y) / 2;
                        else
                            v49 = (v44.Size.Y - v45.Y) / 2;
                        end;

                        v44.CFrame = PrimaryPart.CFrame * v46 * CFrame.new(0, v49, 0);
                        v44.Transparency = v44:GetAttribute("OG_Transparency") or 0;
                        v44.CanCollide = true;

                        if v44:FindFirstChild("Decal") and v47 >= 1 then
                            for _, v2 in v44:QueryDescendants("> Decal") do
                                v2.Transparency = 0.4;
                            end;
                        end;
                    else
                        v44.Transparency = 1;
                        v44.CanCollide = false;
                    end;
                end;
            end;
        end;

        u37:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end
};