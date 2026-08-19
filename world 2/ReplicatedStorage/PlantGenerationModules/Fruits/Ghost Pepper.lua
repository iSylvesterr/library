-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");

return {
    GrowData = {
        GrowRate = 0.0088,
        BaseWeight = 7.5,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(u1, p2, p3) -- Line: 13, Name: InitFruit
        local u4 = Random.new(p2);
        local _ = p3 * 0.2;

        local function GetRandomHSV(p5, p6) -- Line: 19
            -- upvalues: u4 (copy)
            local v7, v8, v9 = p5:ToHSV();
            local v10 = p6 or 0.05;
            local v11 = (v7 + u4:NextNumber(-v10, v10)) % 1;

            return Color3.fromHSV(v11, math.clamp(v8, 0, 1), (math.clamp(v9, 0, 1))), v11, v8, v9;
        end;

        local v12 = {
            Color3.fromRGB(184, 41, 12),
            Color3.fromRGB(184, 62, 6),
            Color3.fromRGB(207, 28, 28),
            Color3.fromRGB(124, 37, 16)
        };
        local u13 = v12[u4:NextInteger(1, #v12)];
        local u14 = nil;

        local function generateTrunk(p15, p16) -- Line: 38
            -- upvalues: u4 (copy), u13 (copy), u14 (ref), u1 (copy)
            for i = 1, p16 do
                local v17 = script.Part:Clone();
                local v18 = math.clamp(2.5 - i * 0.1, 1, 10) * u4:NextNumber(0.9, 1.1);
                local Angles = CFrame.Angles;
                local v19 = u4:NextNumber(5, 15);
                local v20 = math.rad(v19);
                local v21 = u4:NextNumber(-5, 5);
                local v22 = math.rad(v21);
                local v23 = u4:NextNumber(5, 15);
                local v24 = Angles(v20, v22, (math.rad(v23)));
                local v25, v26, v27 = u13:ToHSV();
                local v28 = 0.025 or 0.05;
                local v29 = (v25 + u4:NextNumber(-v28, v28)) % 1;
                v17.Color = Color3.fromHSV(v29, math.clamp(v26, 0, 1), (math.clamp(v27, 0, 1)));
                v17.Size = Vector3.new(v18, 1.5, v18);
                local v30;

                if u14 then
                    v30 = u14.Size.Y;
                    p15 = u14:GetPivot();
                else
                    v30 = 0;
                end;

                local v31 = 1.5 + u4:NextNumber(-0.5, 0.5);
                v17.CFrame = p15 * CFrame.new(0, v30 / 3, 0) * v24 * CFrame.new(0, v31 / 3, 0);
                v17.Name = i + 2;
                v17.Parent = u1;

                if i == math.floor(p16 / 2) then
                    local v32 = script.PixelGradient:Clone();
                    v32.Parent = v17;
                    v32.Enabled = true;
                end;

                if u14 then
                    local v33 = u14:GetPivot();
                    local Angles2 = CFrame.Angles;
                    local v34 = u4:NextInteger(-20, 20);
                    local v35 = math.rad(v34);
                    local v36 = u4:NextInteger(-20, 20);
                    local v37 = math.rad(v36);
                    local v38 = u4:NextInteger(-20, 20);
                    u14:PivotTo(v33 * Angles2(v35, v37, (math.rad(v38))));
                end;

                v17:AddTag("GhostPepper");
                u14 = v17;
            end;

            u14 = nil;
        end;

        local v39 = u4:NextInteger(6, 10);

        while u4:NextInteger(1, 6) == 1 do
            v39 = v39 + 1;
        end;

        local v40 = u1["2"]:GetPivot();
        local Angles = CFrame.Angles;
        local v41 = u4:NextInteger(1, 360);
        generateTrunk(v40 * Angles(0, math.rad(v41), 0), v39);
        u1:ScaleTo(p3);
        u1:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u42) -- Line: 86, Name: BeginFruitGrowth
        local PrimaryPart = u42.PrimaryPart;
        local u43 = {};

        for _, v in u42:QueryDescendants("BasePart") do
            local v44 = tonumber(v.Name);

            if v44 then
                local v45 = not v:GetAttribute("DontShow");
                local v46 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v44
                };
                table.insert(u43, v46);
                v.CanCollide = false;

                if v45 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 107
            -- upvalues: u42 (copy), u43 (copy), PrimaryPart (copy)
            local v47 = u42:GetAttribute("Age") or 0;
            local v48 = u42:GetAttribute("MaxAge") or 1;
            local v49 = v47 / v48;

            for _, v in u43 do
                if not v.part:GetAttribute("DontShow") then
                    local v50 = math.clamp((v49 - v.partAge / v48) * v48, 0, 1);

                    if v50 ~= v.lastProgress then
                        v.lastProgress = v50;

                        if v50 > 0 then
                            local v51 = v.maxSize * v50;
                            v.part.Size = v51;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v51.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;
                        else
                            v.part.Transparency = 1;
                            v.part.CanCollide = false;
                        end;
                    end;
                end;
            end;
        end;

        u42:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p52) -- Line: 143, Name: OnFullyGrown
        local v53 = p52:GetAttribute("CorePartName");

        if v53 then
            local v54 = p52:FindFirstChild(v53);
            local v55 = v54 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v55 then
                local v56 = v55:Clone();
                v56.Name = "ProximityPrompt";
                v56.Parent = v54;
            end;
        end;

        p52:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Acorn",
        Harvestable = true
    }
};