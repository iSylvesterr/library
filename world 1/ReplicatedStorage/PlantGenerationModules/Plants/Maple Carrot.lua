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
                local v12 = not v:GetAttribute("DontShow");
                local v13 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v13, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v12 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v14 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v11,
                    decals = v13
                };
                table.insert(u10, v14);
                v.CanCollide = false;

                if v12 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 101
            -- upvalues: u9 (copy), u10 (copy), PrimaryPart (copy)
            local v15 = u9:GetAttribute("Age") or 0;
            local v16 = u9:GetAttribute("MaxAge") or 1;
            local v17 = v15 / v16;

            for _, v in u10 do
                if not v.part:GetAttribute("DontShow") then
                    local v18 = math.clamp((v17 - v.partAge / v16) * v16, 0, 1);

                    if v18 ~= v.lastProgress then
                        v.lastProgress = v18;

                        if v18 > 0 then
                            local v19 = v.maxSize * v18;
                            v.part.Size = v19;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v19.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v18);
                            end;
                        else
                            v.part.Transparency = 1;
                            v.part.CanCollide = false;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = 1;
                            end;
                        end;
                    end;
                end;
            end;
        end;

        u9:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end
};