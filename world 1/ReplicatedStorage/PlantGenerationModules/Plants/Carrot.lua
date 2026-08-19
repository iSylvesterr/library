-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25,
        BaseWeight = 0.8
    },

    InitPlant = function(p1, p2, p3) -- Line: 8, Name: InitPlant
        local v4 = Random.new(p2);
        local v5 = p1.PrimaryPart or p1:FindFirstChild("Base");
        local v6 = p3 or 1;

        for _, v in ipairs(p1:QueryDescendants("BasePart")) do
            if v ~= v5 then
                v.Size = v.Size * v6;
                local v7 = v5.CFrame:ToObjectSpace(v.CFrame);
                v.CFrame = v5.CFrame * CFrame.new(v7.Position * v6) * v7.Rotation;
            end;
        end;

        local v8 = Color3.fromHSV(0.1 + 0.03 * ((v4:NextInteger(1, 10) - 0.1) * 0.1), 1, 1);

        if v4:NextInteger(1, 100) == 1 then
            v8 = Color3.new(1, 1, 0);
        end;

        if v4:NextInteger(1, 1000) == 1 then
            v8 = Color3.new(0, 0.333333, 1);
        end;

        if v4:NextInteger(1, 10000) == 1 then
            v8 = Color3.new(1, 0.333333, 1);
        end;

        if v4:NextInteger(1, 100000) == 1 then
            v8 = Color3.new(1, 1, 1);
        end;

        if v4:NextInteger(1, 1000000) == 1 then
            v8 = Color3.new(0, 0, 0);
        end;

        for _, child in pairs(p1:GetChildren()) do
            if child.Name == "1" or child.Name == "2" then
                child.Color = v8;
            end;
        end;

        p1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u9) -- Line: 66, Name: BeginPlantGrowth
        local PrimaryPart = u9.PrimaryPart;
        local u10 = {};

        for _, v in u9:QueryDescendants("BasePart") do
            local v11 = tonumber(v.Name);

            if v11 then
                local v12 = {
                    part = v,
                    maxSize = v.Size,
                    offset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v11
                };
                table.insert(u10, v12);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 86
            -- upvalues: u9 (copy), u10 (copy), PrimaryPart (copy)
            local v13 = u9:GetAttribute("Age") or 0;
            local v14 = u9:GetAttribute("MaxAge") or 1;
            local v15 = v13 / v14;

            for _, v in u10 do
                local part = v.part;
                local maxSize = v.maxSize;
                local offset = v.offset;
                local v16 = math.min((v15 - v.partAge / v14) * v14, 1);
                local v17 = math.clamp(v16, 0, 1);

                if v17 ~= v.lastProgress then
                    v.lastProgress = v17;

                    if v16 > 0 then
                        part.Size = Vector3.new(maxSize.X, maxSize.Y * v16, maxSize.Z);
                        part.CFrame = PrimaryPart.CFrame * offset * CFrame.new(0, (part.Size.Y - maxSize.Y) / 2, 0);
                        part.Transparency = part:GetAttribute("OG_Transparency") or 0;
                        part.CanCollide = true;

                        if part:FindFirstChild("Decal") and v16 >= 1 then
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

        u9:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end
};