-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25,
        BaseWeight = 0.8
    },

    InitPlant = function(p1, p2, p3) -- Line: 12, Name: InitPlant
        local v4 = Random.new(p2);
        local v5 = p1.PrimaryPart or p1:FindFirstChild("Base");
        local v6 = (p3 or 1) * 2 + 0.3;

        for _, v in ipairs(p1:QueryDescendants("BasePart")) do
            if v ~= v5 then
                v.Size = v.Size * v6;
                local v7 = v5.CFrame:ToObjectSpace(v.CFrame);
                v.CFrame = v5.CFrame * CFrame.new(v7.Position * v6) * v7.Rotation;
            end;
        end;

        local v8 = p1:GetPivot();
        local Angles = CFrame.Angles;
        local v9 = v4:NextNumber(-10, 10);
        local v10 = math.rad(v9);
        local v11 = v4:NextNumber(-10, 10);
        p1:PivotTo(v8 * Angles(v10, 0, (math.rad(v11))));
        local Top = p1.Top;
        local v12 = Top:GetPivot();
        local Angles2 = CFrame.Angles;
        local v13 = v4:NextNumber(-3, 3);
        local v14 = math.rad(v13);
        local v15 = v4:NextNumber(-3, 3);
        Top:PivotTo(v12 * Angles2(v14, 0, (math.rad(v15))));
        local v16 = Top["4"];
        local v17 = Top["4"]:GetPivot();
        local Angles3 = CFrame.Angles;
        local v18 = v4:NextNumber(-3, 3);
        local v19 = math.rad(v18);
        local v20 = v4:NextNumber(-3, 3);
        v16:PivotTo(v17 * Angles3(v19, 0, (math.rad(v20))));

        for _, child in Top:GetChildren() do
            child.Parent = p1;
        end;

        local v21 = v4:NextNumber(-0.05, 0.05);

        for _, v in p1:QueryDescendants("BasePart") do
            local v22, v23, v24 = v.Color:ToHSV();
            v.Color = Color3.fromHSV(math.clamp(v22 + v21, 0.01, 0.99), v23, v24);

            if v:FindFirstChild("Decal") then
                for _, child in v:GetChildren() do
                    if child:IsA("Decal") then
                        local v25, v26, v27 = child.Color3:ToHSV();
                        child.Color3 = Color3.fromHSV(math.clamp(v25 + v21, 0.01, 0.99), v26, v27);
                    end;
                end;
            end;
        end;

        p1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u28) -- Line: 64, Name: BeginPlantGrowth
        local PrimaryPart = u28.PrimaryPart;
        local u29 = {};

        for _, v in u28:QueryDescendants("BasePart") do
            local v30 = tonumber(v.Name);

            if v30 then
                local v31 = {
                    part = v,
                    maxSize = v.Size,
                    offset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v30
                };
                table.insert(u29, v31);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 84
            -- upvalues: u28 (copy), u29 (copy), PrimaryPart (copy)
            local v32 = u28:GetAttribute("Age") or 0;
            local v33 = u28:GetAttribute("MaxAge") or 1;
            local v34 = v32 / v33;

            for _, v in u29 do
                local part = v.part;
                local maxSize = v.maxSize;
                local offset = v.offset;
                local v35 = math.min((v34 - v.partAge / v33) * v33, 1);
                local v36 = math.clamp(v35, 0, 1);

                if v36 ~= v.lastProgress then
                    v.lastProgress = v36;

                    if v35 > 0 then
                        part.Size = Vector3.new(maxSize.X, maxSize.Y * v35, maxSize.Z);
                        part.CFrame = PrimaryPart.CFrame * offset * CFrame.new(0, (part.Size.Y - maxSize.Y) / 2, 0);
                        part.Transparency = part:GetAttribute("OG_Transparency") or 0;
                        part.CanCollide = true;

                        if part:FindFirstChild("Decal") and v35 >= 1 then
                            for _, v2 in part:QueryDescendants("> Decal") do
                                v2.Transparency = 0.4;
                            end;
                        end;
                    else
                        part.Transparency = 1;
                        part.CanCollide = false;
                    end;
                end;
            end;
        end;

        u28:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end
};