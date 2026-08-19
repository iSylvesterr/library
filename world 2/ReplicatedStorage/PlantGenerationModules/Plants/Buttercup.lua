-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25,
        BaseWeight = 5
    },

    InitPlant = function(p1, p2, p3) -- Line: 8, Name: InitPlant
        local v4 = Random.new(p2);
        local Base = p1.Base;
        local Stud_Part = script.Stud_Part;
        local v5 = p3 or 1;
        local v6 = Stud_Part:Clone();
        v6.Color = Color3.new(0, 0.666667, 0);
        local v7 = v4:NextInteger(2, 3);
        v6.Size = Vector3.new(1, v7, 1) * v5;
        v6.CFrame = Base.CFrame * CFrame.new(0, v6.Size.Y / 2, 0);
        v6.Name = "1";
        v6.Parent = p1;
        local v8 = Stud_Part:Clone();
        v8.Color = Color3.new(1, 1, 0);
        v8.Size = Vector3.new(1, 1, 1) * v5;
        v8.CFrame = v6.CFrame * CFrame.new(0, v6.Size.Y / 2 + v8.Size.Y / 2, 0);
        v8.Name = "2";
        v8.Parent = p1;
        local v9 = Random.new(v4:NextInteger(1, 100000000));
        local v10 = Color3.fromHSV(v9:NextInteger(1, 100) * 0.01, 1, 1);

        if v9:NextInteger(1, 1000) == 1 then
            v10 = Color3.fromHSV(0, 0, 0);
        end;

        if v9:NextInteger(1, 1000) == 1 then
            v10 = Color3.fromHSV(0, 0, 1);
        end;

        local v11 = {};
        local v12 = Stud_Part:Clone();
        v12.Color = v10;
        v12.Size = Vector3.new(1, 1, 1) * v5;
        v12.CFrame = v8.CFrame * CFrame.new(v8.Size.X / 2 + v12.Size.X / 2, 0, 0);
        v12.CFrame = v12.CFrame * CFrame.Angles(0, 0, -1.5707963267948966);
        v12.Name = "3";
        v12.Parent = p1;
        table.insert(v11, v12);
        local v13 = Stud_Part:Clone();
        v13.Color = v10;
        v13.Size = Vector3.new(1, 1, 1) * v5;
        v13.CFrame = v8.CFrame * CFrame.new(-(v8.Size.X / 2 + v13.Size.X / 2), 0, 0);
        v13.CFrame = v13.CFrame * CFrame.Angles(0, 0, 1.5707963267948966);
        v13.Name = "3";
        v13.Parent = p1;
        table.insert(v11, v13);
        local v14 = Stud_Part:Clone();
        v14.Color = v10;
        v14.Size = Vector3.new(1, 1, 1) * v5;
        v14.CFrame = v8.CFrame * CFrame.new(0, 0, -(v8.Size.Z / 2 + v14.Size.Z / 2));
        v14.CFrame = v14.CFrame * CFrame.Angles(-1.5707963267948966, 0, 0);
        v14.Name = "3";
        v14.Parent = p1;
        table.insert(v11, v14);
        local v15 = Stud_Part:Clone();
        v15.Color = v10;
        v15.Size = Vector3.new(1, 1, 1) * v5;
        v15.CFrame = v8.CFrame * CFrame.new(0, 0, v8.Size.Z / 2 + v15.Size.Z / 2);
        v15.CFrame = v15.CFrame * CFrame.Angles(1.5707963267948966, 0, 0);
        v15.Name = "3";
        v15.Parent = p1;
        table.insert(v11, v15);
        p1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u16) -- Line: 79, Name: BeginPlantGrowth
        local PrimaryPart = u16.PrimaryPart;
        local u17 = {};

        for _, v in u16:QueryDescendants("BasePart") do
            local v18 = tonumber(v.Name);

            if v18 then
                local v19 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v18
                };
                table.insert(u17, v19);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 97
            -- upvalues: u16 (copy), u17 (copy), PrimaryPart (copy)
            local v20 = u16:GetAttribute("Age") or 0;
            local v21 = u16:GetAttribute("MaxAge") or 1;
            local v22 = v20 / v21;

            for _, v in u17 do
                local v23 = v[1];
                local v24 = v[2];
                local v25 = v[3];
                local v26 = math.min((v22 - v[4] / v21) * v21, 1);
                local v27 = math.clamp(v26, 0, 1);

                if v27 ~= v.lastProgress then
                    v.lastProgress = v27;

                    if v26 > 0 then
                        v23.Size = Vector3.new(v24.X, v24.Y * v26, v24.Z);
                        v23.CFrame = PrimaryPart.CFrame * v25 * CFrame.new(0, (v23.Size.Y - v24.Y) / 2, 0);
                        v23.Transparency = v23:GetAttribute("OG_Transparency") or 0;
                        v23.CanCollide = true;

                        if v23:FindFirstChild("Decal") and v26 >= 1 then
                            for _, v2 in v23:QueryDescendants("> Decal") do
                                v2.Transparency = 0.4;
                            end;
                        end;
                    else
                        v23.Transparency = 1;
                        v23.CanCollide = false;
                    end;
                end;
            end;
        end;

        u16:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end
};