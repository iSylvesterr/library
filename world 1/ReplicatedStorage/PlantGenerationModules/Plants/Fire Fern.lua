-- Decompiled with Potassium's decompiler.

local MaterialService = game:GetService("MaterialService");
game:GetService("TweenService");

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u1, p2, p3) -- Line: 9, Name: InitPlant
        -- upvalues: MaterialService (copy)
        local v4 = p3 or 1;
        local u5 = Random.new(p2);
        local FruitSpawnLocations = u1.FruitSpawnLocations;
        local Base = u1.Base;

        local function GetRandomHSV(p6, p7) -- Line: 18
            -- upvalues: u5 (copy)
            local v8, v9, v10 = p6:ToHSV();
            local v11 = p7 or 0.05;
            local v12 = v8 + u5:NextNumber(-v11, v11);
            local v13 = math.clamp(v12, 0, 0.99);

            return Color3.fromHSV(v13, v9, v10), v13, v9, v10;
        end;

        local v14, v15 = Color3.fromRGB(51, 136, 5);
        local v16, v17, v18 = v14:ToHSV();
        local v19 = v15 or 0.05;
        local v20 = v16 + u5:NextNumber(-v19, v19);
        local v21 = math.clamp(v20, 0, 0.99);
        Color3.fromHSV(v21, v17, v18);

        local function CreatePart(p22, p23, p24) -- Line: 28
            -- upvalues: u1 (copy), MaterialService (ref)
            local Part = Instance.new("Part");
            local v25 = p22 or "Studs";
            Part.Parent = u1;
            Part.TopSurface = Enum.SurfaceType[v25];
            Part.BackSurface = Enum.SurfaceType[v25];
            Part.FrontSurface = Enum.SurfaceType[v25];
            Part.BottomSurface = Enum.SurfaceType[v25];
            Part.LeftSurface = Enum.SurfaceType[v25];
            Part.RightSurface = Enum.SurfaceType[v25];
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 0;

            for _, child in pairs(script:GetChildren()) do
                if child:IsA("Texture") then
                    child:Clone().Parent = Part;
                end;
            end;

            if p24 then
                Part.Shape = Enum.PartType[p24];
            end;

            if p23 then
                Part.MaterialVariant = p23;
                local v26 = MaterialService:FindFirstChild(p23, true);

                if not v26 then
                    return Part;
                end;

                Part.Material = v26.BaseMaterial;
            end;

            return Part;
        end;

        local function GetColorWithRange(p27, p28) -- Line: 64
            local v29, v30, v31 = p27:ToHSV();

            return Color3.fromHSV(v29 + p28, v30, v31);
        end;

        local function Lerp(p32, p33, p34) -- Line: 70
            return p32 + (p33 - p32) * p34;
        end;

        local function AddGradient(p35, p36) -- Line: 74
            for _, child in p36:GetChildren() do
                child:Clone().Parent = p35;
            end;
        end;

        local v37 = u5:NextNumber(1.8, 2.3);
        local v38 = u5:NextNumber(1.3, 1.8);
        local v39 = Color3.fromRGB(255, 86, 0);
        local v40 = CreatePart(nil, "2022 Stud");
        v40.Size = Vector3.new(v37, v38, v37) * v4;
        v40.CFrame = Base.CFrame * CFrame.new(0, v40.Size.Y / 2, 0);
        v40.Color = v39;
        v40.Name = 1;
        local v41 = CreatePart(nil, "2022 Stud");
        v41.Size = Vector3.new(v37, v38 * 0.65, v37) * v4;
        local v42 = Base.CFrame * CFrame.new(0, v41.Size.Y / 2, 0);
        local Angles = CFrame.Angles;
        local v43 = u5:NextNumber(35, 55);
        v41.CFrame = v42 * Angles(0, math.rad(v43), 0);
        v41.Color = v39;
        v41.Name = 2;

        for _, child in script.Decals:GetChildren() do
            child:Clone().Parent = v40;
        end;

        for _, child in script.Decals:GetChildren() do
            child:Clone().Parent = v41;
        end;

        local v44 = u5:NextInteger(4, 6);

        for i = 1, v44 do
            local v45 = script.Petal:Clone();
            v45.Parent = u1;
            v45:ScaleTo(v45:GetScale() * v4);
            local v46 = v40.CFrame * CFrame.Angles(0, math.rad(360 / v44 * i), 0) * CFrame.new(0, 0, -v40.Size.Z / 2);
            local Angles2 = CFrame.Angles;
            local v47 = u5:NextNumber(-65, -35);
            v45:PivotTo(v46 * Angles2(math.rad(v47), 0, 0));
            v45.PrimaryPart.Name = 3;
        end;

        local v48 = u5:NextInteger(3, 5);

        for i = 1, v48 do
            local v49 = script.Fern:Clone();
            v49.Parent = u1;
            v49:ScaleTo(v49:GetScale() * v4);
            local v50 = v40.CFrame * CFrame.Angles(0, math.rad(360 / v48 * i + 45), 0) * CFrame.new(0, v40.Size.Y / 2, v40.Size.Z / 2);
            local Angles2 = CFrame.Angles;
            local v51 = u5:NextNumber(35, 65);
            v49:PivotTo(v50 * Angles2(math.rad(v51), 0, 0));
            v49.PrimaryPart.Name = 3;
        end;

        for i = 1, 3 do
            local v52 = CreatePart();
            v52.Size = Vector3.new(1, 1, 1);
            v52.CFrame = v40.CFrame * CFrame.new(0, v40.Size.Y / 2, 0) * CFrame.Angles(0, math.rad(i * 120), 0) * CFrame.new(0, 0, -0.35) * CFrame.Angles(-0.3490658503988659, 0, 0);
            v52.Parent = FruitSpawnLocations;
            v52.Transparency = 1;
        end;

        local v53 = u5:NextNumber(-0.035, 0.035);

        for _, v in u1:QueryDescendants("BasePart") do
            local v54, v55, v56 = v.Color:ToHSV();
            v.Color = Color3.fromHSV(math.clamp(v54 + v53, 0.01, 0.99), v55, v56);

            if v:FindFirstChild("Decal") then
                for _, child in v:GetChildren() do
                    if child:IsA("Decal") then
                        local v57, v58, v59 = child.Color3:ToHSV();
                        child.Color3 = Color3.fromHSV(math.clamp(v57 + v53, 0.01, 0.99), v58, v59);
                    end;
                end;
            end;
        end;

        u1:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u60) -- Line: 159, Name: BeginPlantGrowth
        local PrimaryPart = u60.PrimaryPart;
        local u61 = {};

        for _, v in u60:QueryDescendants("BasePart") do
            local v62 = tonumber(v.Name);

            if v62 then
                local v63 = not v:GetAttribute("DontShow");
                local v64 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v64, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });

                        if v63 then
                            child.Transparency = 1;
                        end;
                    end;
                end;

                local v65 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v62,
                    decals = v64
                };
                table.insert(u61, v65);
                v.CanCollide = false;

                if v63 then
                    v.Transparency = 1;
                end;
            end;
        end;

        local function updateGrowth() -- Line: 194
            -- upvalues: u60 (copy), u61 (copy), PrimaryPart (copy)
            local v66 = u60:GetAttribute("Age") or 0;
            local v67 = u60:GetAttribute("MaxAge") or 1;
            local v68 = v66 / v67;

            for _, v in u61 do
                if not v.part:GetAttribute("DontShow") then
                    local v69 = math.clamp((v68 - v.partAge / v67) * v67, 0, 1);

                    if v69 ~= v.lastProgress then
                        v.lastProgress = v69;

                        if v69 > 0 then
                            local v70 = v.maxSize * v69;
                            v.part.Size = v70;
                            v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v70.Y) / 2), 0);
                            v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                            v.part.CanCollide = true;

                            for _, v2 in v.decals do
                                v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v69);
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

            if v67 <= v66 then
                for _, v in u60:QueryDescendants("ParticleEmitter") do
                    if not v:FindFirstAncestor("FireRing") then
                        v.Enabled = true;
                    end;
                end;

                if not u60:HasTag("FireFern") then
                    script.FireRing:Clone().Parent = u60.PrimaryPart;
                    u60:AddTag("FireFern");
                end;
            end;
        end;

        u60:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};