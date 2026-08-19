-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");

local function ManualScale(p1, p2) -- Line: 3
    if p2 == 1 then
        return;
    end;

    local v3 = p1:GetPivot();

    for _, v in p1:QueryDescendants("BasePart, Attachment, SpecialMesh, Weld, Motor6D") do
        if v:IsA("BasePart") then
            v.Size = v.Size * p2;
            local v4 = v3:ToObjectSpace(v.CFrame);
            v.CFrame = v3 * CFrame.new(v4.Position * p2) * v4.Rotation;
        elseif v:IsA("Attachment") then
            v.Position = v.Position * p2;
        elseif v:IsA("SpecialMesh") then
            v.Scale = v.Scale * p2;
            v.Offset = v.Offset * p2;
        elseif v:IsA("Weld") or v:IsA("Motor6D") then
            v.C0 = CFrame.new(v.C0.Position * p2) * v.C0.Rotation;
            v.C1 = CFrame.new(v.C1.Position * p2) * v.C1.Rotation;
        end;
    end;
end;

return {
    GrowData = {
        GrowRate = 0.0061,
        BaseWeight = 3,
        GrowTickTime = NumberRange.new(4.8, 6)
    },

    InitFruit = function(u5, p6, p7) -- Line: 31, Name: InitFruit
        -- upvalues: ManualScale (copy)
        local MaterialService = game:GetService("MaterialService");
        local v8 = (p7 or 1) * 0.5 + 0.5;
        local u9 = Random.new(p6);
        local _ = u5.Base;

        local function GetRandomHSV(p10, p11) -- Line: 46
            -- upvalues: u9 (copy)
            local v12, v13, v14 = p10:ToHSV();
            local v15 = p11 or 0.05;
            local v16 = v12 + u9:NextNumber(-v15, v15);
            local v17 = math.clamp(v16, 0, 0.99);

            return Color3.fromHSV(v17, v13, v14), v17, v13, v14;
        end;

        local v18, v19 = Color3.fromRGB(51, 136, 5);
        local v20, v21, v22 = v18:ToHSV();
        local v23 = v19 or 0.05;
        local v24 = v20 + u9:NextNumber(-v23, v23);
        local v25 = math.clamp(v24, 0, 0.99);
        Color3.fromHSV(v25, v21, v22);

        local function CreatePart(p26, p27, p28) -- Line: 56
            -- upvalues: u5 (copy), MaterialService (copy)
            local Part = Instance.new("Part");
            local v29 = p26 or "Studs";
            Part.Parent = u5;
            Part.TopSurface = Enum.SurfaceType[v29];
            Part.BackSurface = Enum.SurfaceType[v29];
            Part.FrontSurface = Enum.SurfaceType[v29];
            Part.BottomSurface = Enum.SurfaceType[v29];
            Part.LeftSurface = Enum.SurfaceType[v29];
            Part.RightSurface = Enum.SurfaceType[v29];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0;

            if p28 then
                Part.Shape = Enum.PartType[p28];
            end;

            if p27 then
                Part.MaterialVariant = p27;
                local v30 = MaterialService:FindFirstChild(p27, true);

                if not v30 then
                    return Part;
                end;

                Part.Material = v30.BaseMaterial;
            end;

            return Part;
        end;

        local v31 = u5["3"];
        local CFrame2 = v31.CFrame;
        local Angles = CFrame.Angles;
        local v32 = u9:NextNumber(-180, 180);
        v31.CFrame = CFrame2 * Angles(0, math.rad(v32), 0);

        for i = 1, 4 do
            local v33 = u5["1"];
            local v34 = script.Leaf:Clone();
            v34.Parent = u5;
            local v35 = v33.CFrame * CFrame.Angles(0, math.rad(i * 90), 0) * CFrame.new(0, -v33.Size.Y * 0.35, -v33.Size.Z / 2.5);
            local Angles2 = CFrame.Angles;
            local v36 = u9:NextNumber(45, 70);
            local v37 = math.rad(v36);
            local v38 = u9:NextNumber(-10, 10);
            v34:PivotTo(v35 * Angles2(v37, 0, (math.rad(v38))));
            v34.Name = 2;
        end;

        for i = 1, 4 do
            local v39 = 90 * (i * u9:NextNumber(0.8, 1.2));
            local v40 = u5["2"];
            local v41 = script.SmallLeaf:Clone();
            v41.Parent = u5;
            local v42 = v40.CFrame * CFrame.Angles(0, math.rad(v39), 0) * CFrame.new(0, v40.Size.Y * 0.4, -v40.Size.Z / 2.5);
            local Angles2 = CFrame.Angles;
            local v43 = u9:NextNumber(15, 30);
            local v44 = math.rad(v43);
            local v45 = u9:NextNumber(-10, 10);
            v41:PivotTo(v42 * Angles2(v44, 0, (math.rad(v45))));
            v41.Name = 3;
        end;

        local v46 = u9:NextInteger(2, 4);

        for i = 1, v46 do
            local v47 = script.SpikeLeaf:Clone();
            v47.Parent = u5;
            local v48 = 360 / v46 * (i * u9:NextNumber(0.8, 1.2));
            local v49 = u5["2"];
            v47.Name = 4;
            v47.Size = v47.Size * u9:NextNumber(0.7, 1.1);
            local v50 = v49.CFrame * CFrame.Angles(0, math.rad(v48), 0);
            local Angles2 = CFrame.Angles;
            local v51 = u9:NextNumber(15, 25);
            v47.CFrame = v50 * Angles2(math.rad(v51), 0, 0) * CFrame.new(0, v49.Size.Y / 2.25 + v47.Size.Y / 2, 0);
        end;

        ManualScale(u5, v8 + v8 ^ 3 * 0.00001);
        u5:AddTag("InitializationComplete");
    end,

    BeginFruitGrowth = function(u52) -- Line: 130, Name: BeginFruitGrowth
        local PrimaryPart = u52.PrimaryPart;
        local u53 = {};

        for _, v in u52:QueryDescendants("BasePart") do
            local v54 = tonumber(v.Name);

            if v54 then
                local v55 = not v:GetAttribute("DontShow");
                local v56 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v56, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v55 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v57 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v54,
                    decals = v56
                };
                table.insert(u53, v57);
                v.CanCollide = false;

                if v55 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 165
            -- upvalues: u52 (copy), u53 (copy), PrimaryPart (copy)
            local v58 = u52:GetAttribute("Age") or 0;
            local v59 = u52:GetAttribute("MaxAge") or 1;
            local v60 = v58 / v59;

            for _, v in u53 do
                if not v.part:GetAttribute("DontShow") then
                    local v61 = math.clamp((v60 - v.partAge / v59) * v59, 0, 1);

                    if v61 ~= v.lastProgress then
                        v.lastProgress = v61;

                        if v61 > 0 then
                            local v62 = v.maxSize * v61;
                            v.part.Size = v62;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v62.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v61);
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

        u52:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    OnFullyGrown = function(p63) -- Line: 204, Name: OnFullyGrown
        local v64 = p63:GetAttribute("CorePartName");

        if v64 then
            local v65 = p63:FindFirstChild(v64);
            local v66 = v65 and game.ServerStorage:FindFirstChild("Collect_PROX_Apple");

            if v66 then
                local v67 = v66:Clone();
                v67.Name = "ProximityPrompt";
                v67.Parent = v65;
            end;
        end;

        p63:AddTag("PlantGenerated");
    end,

    Extras = {
        FruitType = "Corn",
        Harvestable = true
    }
};