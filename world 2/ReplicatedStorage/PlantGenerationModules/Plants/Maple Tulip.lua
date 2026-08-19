-- Decompiled with Potassium's decompiler.

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25,
        BaseWeight = 0.5
    },

    InitPlant = function(u1, p2, p3) -- Line: 8, Name: InitPlant
        local u4 = Random.new(p2);
        local Base = u1.Base;
        local _ = script.Stud_Part;
        local u5 = p3 or 1;
        local u6 = nil;
        local u7 = Vector3.new(0.18, 0.6, 0.18) * u5;
        local u8 = {
            Color3.fromRGB(255, 113, 47),
            Color3.fromRGB(244, 212, 180),
            Color3.fromRGB(255, 191, 0),
            Color3.fromRGB(132, 51, 13),
            Color3.fromRGB(135, 31, 36),
            Color3.fromRGB(148, 99, 161)
        };

        local function generateTrunk(p9, p10, p11) -- Line: 29
            -- upvalues: u8 (copy), u4 (copy), u7 (copy), u6 (ref), Base (copy), u1 (copy), u5 (ref)
            local v12 = u8[u4:NextInteger(1, #u8)];

            for i = 1, p10 do
                local v13 = script.Stud_Part:Clone();
                local X = u7.X;
                local v14 = u7.Y + u4:NextNumber(-0.15, 0.15);
                local Angles = CFrame.Angles;
                local v15 = u4:NextNumber(-15, 15);
                local v16 = math.rad(v15);
                local v17 = u4:NextNumber(-15, 15);
                local v18 = math.rad(v17);
                local v19 = u4:NextNumber(-15, 15);
                local v20 = Angles(v16, v18, (math.rad(v19)));
                local new = CFrame.new;
                local Position = p9.Position;
                local v21 = u4:NextNumber(-15, 15);
                local v22 = u4:NextNumber(-15, 15);
                new(Position + Vector3.new(v21, v22, u4:NextNumber(-15, 15)));
                v13.Color = Color3.fromRGB(184, 197, 41);
                v13.Size = Vector3.new(X, v14, X);

                if u6 and u6 ~= Base then
                    p9 = u6:GetPivot();
                    v13.CFrame = p9 * CFrame.new(0, u6.Size.Y / 2.05, 0) * v20 * CFrame.new(0, v14 / 2.05, 0);
                else
                    v13.CFrame = p9 * v20 * CFrame.new(0, v14 / 2.05, 0);
                end;

                v13.Name = i;
                v13.Parent = u1;

                if i == 1 then
                    for _, child in script.decals:GetChildren() do
                        child:Clone().Parent = v13;
                    end;
                end;

                if i == p10 then
                    local v23 = script.Top:Clone();
                    v23:ScaleTo(0.6 * u5);
                    local v24 = v13:GetPivot() * CFrame.new(0, v13.Size.Y / 2, 0);
                    local Angles2 = CFrame.Angles;
                    local v25 = u4:NextInteger(-15, 15);
                    local v26 = math.rad(v25);
                    local v27 = u4:NextInteger(-15, 15);
                    local v28 = math.rad(v27);
                    local v29 = u4:NextInteger(-15, 15);
                    v23:PivotTo(v24 * Angles2(v26, v28, (math.rad(v29))));

                    for _, child in v23:GetChildren() do
                        child.Color = v12;
                        child.Name = tonumber(child.Name) + i;
                        child.Parent = u1;
                    end;

                    v23:Destroy();
                end;

                u6 = v13;
            end;

            u6 = nil;
        end;

        local v30 = math.clamp(1000 - u5 ^ 5, 10, 100000);
        local v31 = 1;

        while u4:NextInteger(1, v30) == 1 and v31 < 40 do
            v31 = v31 + 1;
        end;

        for i = 1, v31 do
            local v32 = u4:NextInteger(2, 3);

            while u4:NextInteger(1, 7) == 1 and v32 < 65 do
                v32 = v32 + 1;
            end;

            if v31 > 1 then
                local v33 = Base:GetPivot();
                generateTrunk(v33 * CFrame.Angles(0, (i - 1) / v31 * 3.141592653589793 * 2, 0) * CFrame.Angles(-0.3839724354387525, 0, 0), v32, v33);
            else
                generateTrunk(Base:GetPivot(), v32, Base:GetPivot());
            end;
        end;

        local v34 = 1;

        while u4:NextInteger(1, 5) == 1 and v34 < 65 do
            v34 = v34 + 1;
        end;

        for _ = 1, v34 do
            local v35 = u1.Wedge:Clone();
            v35:ScaleTo(u5);
            local v36 = u1:GetPivot();
            local Angles = CFrame.Angles;
            local v37 = u4:NextInteger(-20, 20);
            local v38 = math.rad(v37);
            local v39 = u4:NextInteger(0, 360);
            local v40 = math.rad(v39);
            local v41 = u4:NextInteger(-20, 20);
            v35:PivotTo(v36 * Angles(v38, v40, (math.rad(v41))));
            v35["1"].Parent = u1;
            v35:Destroy();
        end;

        u1.Wedge:Destroy();
        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u42) -- Line: 130, Name: BeginPlantGrowth
        local PrimaryPart = u42.PrimaryPart;
        local u43 = {};

        for _, v in u42:QueryDescendants("BasePart") do
            local v44 = tonumber(v.Name);

            if v44 then
                local v45 = not v:GetAttribute("DontShow");
                local v46 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v46, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v45 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v47 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v44,
                    decals = v46
                };
                table.insert(u43, v47);
                v.CanCollide = false;

                if v45 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 165
            -- upvalues: u42 (copy), u43 (copy), PrimaryPart (copy)
            local v48 = u42:GetAttribute("Age") or 0;
            local v49 = u42:GetAttribute("MaxAge") or 1;
            local v50 = v48 / v49;

            for _, v in u43 do
                if not v.part:GetAttribute("DontShow") then
                    local v51 = math.clamp((v50 - v.partAge / v49) * v49, 0, 1);

                    if v51 ~= v.lastProgress then
                        v.lastProgress = v51;

                        if v51 > 0 then
                            local v52 = v.maxSize * v51;
                            v.part.Size = v52;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v52.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v51);
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

        u42:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end
};