-- Decompiled with Potassium's decompiler.

game:GetService("MaterialService");
local LeafMesh = script.LeafMesh;
local SpikeMesh = script.SpikeMesh;
local Head = script.Head;
local _ = script.VenusClose;
local _ = script.VenusHead;
require(game.StarterPlayer.StarterPlayerScripts.Controllers.InverseKinematicsController);

local function CreatePart(p1, p2, p3) -- Line: 13
    local Part = Instance.new("Part");
    local v4 = p2 or "Studs";
    Part.Parent = p1;
    Part.TopSurface = Enum.SurfaceType[v4];
    Part.BackSurface = Enum.SurfaceType[v4];
    Part.FrontSurface = Enum.SurfaceType[v4];
    Part.BottomSurface = Enum.SurfaceType[v4];
    Part.LeftSurface = Enum.SurfaceType[v4];
    Part.RightSurface = Enum.SurfaceType[v4];
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.Transparency = 1;

    if p3 then
        Part.MaterialVariant = p3;
    end;

    return Part;
end;

local function CreateMeshPart(p5, p6, p7) -- Line: 34
    local v8 = p6:Clone();
    v8.Parent = p5;
    v8.Anchored = true;
    v8.CanCollide = false;
    v8.Transparency = 1;

    if p7 then
        v8.MaterialVariant = p7;
    end;

    return v8;
end;

local function GetDifference(p9, p10) -- Line: 46
    return p10 + (p9 - p10) / 2;
end;

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u11, p12, p13) -- Line: 56, Name: InitPlant
        -- upvalues: Head (copy), CreatePart (copy), SpikeMesh (copy), LeafMesh (copy)
        local FruitSpawnLocations = u11.FruitSpawnLocations;
        local Base = u11.Base;
        local u14 = Head:Clone();
        local v15 = Random.new(p12):NextNumber(3, 5);
        local u16 = Color3.fromRGB(32, 103, 56);
        local u17 = p12;
        local u18 = 0;
        math.randomseed(u17);

        local function ChangeSeed() -- Line: 72
            -- upvalues: u18 (ref), u17 (ref)
            u18 = u18 + 1;
            local v19 = math.clamp(u17 + u18, 1, 100) * 100;
            local v20 = u17;
            local v21 = u17 * math.random(1, (math.clamp(v19, 1, 10000)));
            u17 = math.clamp(v21, 1, 9100000000000);

            if u17 == v20 then
                u17 = 3;
            end;

            math.randomseed(u17);
        end;

        local u22 = math.random(35, 45);
        local u23 = math.random(1, 2) == 1 and 10 or -10;
        local u24 = 30;
        math.random(5, 8);

        local function CreateSpike(p25, p26, p27) -- Line: 98
            -- upvalues: CreatePart (ref), u17 (ref), u16 (copy), SpikeMesh (ref), u11 (copy)
            local Model = Instance.new("Model");
            Model.Name = "Spike";
            local v28 = CreatePart(Model, nil, "Studs");
            local v29 = Random.new(u17):NextNumber(1.25, 3) * (p27 or 1);
            v28.Size = Vector3.new(v29 * 0.2, v29 * 0.2, v29 * 0.65);
            v28.CFrame = p25 * CFrame.Angles(1.5707963267948966, 0, 0);
            v28.Color = u16;
            v28.Name = p26;
            local v30 = SpikeMesh:Clone();
            v30.Parent = Model;
            v30.Anchored = true;
            v30.CanCollide = false;
            v30.Transparency = 1;
            v30.MaterialVariant = "Studs";
            v30.Name = p26 + 1;
            v30.Size = Vector3.new(v29 / 2, v29, v29 * 0.1);
            local Y = v30.Size.Y;
            v30.CFrame = v28.CFrame * CFrame.new(0, Y + (v28.Size.Y - Y) / 2, 0) * CFrame.Angles(0, 1.5707963267948966, 0);
            Model.Parent = u11;

            return Model;
        end;

        local function CreateLeafStems(p31, p32) -- Line: 126
            -- upvalues: u18 (ref), u17 (ref), CreatePart (ref), CreateSpike (copy), LeafMesh (ref), u11 (copy)
            local RightVector = p31.CFrame.RightVector;
            local v33 = p32 + 1;
            local v34 = 1;
            local v35 = {};

            for i = 1, 2 do
                u18 = u18 + 1;
                local v36 = math.clamp(u17 + u18, 1, 100) * 100;
                local v37 = u17;
                local v38 = u17 * math.random(1, (math.clamp(v36, 1, 10000)));
                u17 = math.clamp(v38, 1, 9100000000000);

                if u17 == v37 then
                    u17 = 3;
                end;

                math.randomseed(u17);
                local Model = Instance.new("Model");
                local v39 = math.random(3, 4);
                local v40 = CreatePart(Model, nil, "Studs");
                v40.Size = Vector3.new(p31.Size.X / 2, p31.Size.Y * 0.35, p31.Size.Z / 2);
                v40.CFrame = p31.CFrame * CFrame.new(-RightVector * (p31.Size.Y * 0.35));
                v40.Color = p31.Color;
                v40.Name = v33;
                local CFrame2 = v40.CFrame;

                if v34 == 1 then
                    CFrame2 = CFrame2 * CFrame.Angles(0, 3.141592653589793, 0);
                end;

                for i2 = 1, v39 do
                    local v41 = CreatePart(Model, nil, "Studs");
                    v41.Size = Vector3.new((1 - i2 * 0.2) * 2, (1 - i2 * 0.2) * 1, (1 - i2 * 0.2) * 1);
                    v41.CFrame = CFrame2 * CFrame.Angles(0, math.rad(v34 * 6 * i2), 0) * CFrame.new(v40.Size.X * 0.7, 0, 0);
                    v41.Color = p31.Color;
                    v41.Name = v33 + i2;
                    CFrame2 = v41.CFrame;

                    if v34 == -1 then
                        v41.CFrame = v41.CFrame * CFrame.Angles(0, 3.141592653589793, 0);
                    end;

                    if i2 == 2 then
                        local v42 = CreateSpike(v41.CFrame * CFrame.new(0, 0, v41.Size.Z / 2) * CFrame.Angles(0, 0, -1.5707963267948966), v33, v41.Size.Y * 0.65);
                        local ObjectValue = Instance.new("ObjectValue");
                        ObjectValue.Parent = v41;
                        ObjectValue.Name = "Reference";
                        ObjectValue.Value = v42;
                    end;

                    v40 = v41;
                end;

                RightVector = -RightVector;
                v34 = -v34;
                local v43 = LeafMesh:Clone();
                v43.Parent = Model;
                v43.Anchored = true;
                v43.CanCollide = false;
                v43.Transparency = 1;
                v43.MaterialVariant = "Weld 2x2 Plastic";
                v43.Name = v33 + v39 + 1;
                v43.CFrame = CFrame2 * CFrame.Angles(0, 0, 1.5707963267948966);

                if v34 == -1 then
                    v43.CFrame = v43.CFrame * CFrame.Angles(0, 3.141592653589793, 0);
                end;

                v43.CFrame = v43.CFrame * (CFrame.Angles(3.141592653589793, 0, 0) * CFrame.new(0, v43.Size.Y * 0.45, 0));
                Model.Parent = u11;
                local v44 = CreatePart(Model, nil, "Studs");
                v44.Transparency = 1;
                v44.CFrame = v43.CFrame * CFrame.new(0, v43.Size.Y / 2, 0);
                v44.Size = Vector3.new(1, 1, 1);
                v44.Name = "EndJoint";
                Model.Name = "Leaf" .. i;
                table.insert(v35, Model);
            end;

            return v35;
        end;

        local function GenerateStem(p45, p46, p47) -- Line: 228
            -- upvalues: CreatePart (ref), u11 (copy), u23 (ref), u22 (ref), u16 (copy), u24 (ref), CreateLeafStems (copy), CreateSpike (copy), u17 (ref), GenerateStem (copy), u14 (copy), u18 (ref), FruitSpawnLocations (copy)
            local v48 = CreatePart(u11, nil, "Studs");
            local v49 = p47 * 0.03;

            if p47 == 4 then
                u23 = -u23;
            end;

            if p47 > 4.5 then
                v49 = v49 - p47 * 0.02;
            end;

            local v50 = p45 * CFrame.Angles(math.rad(u22), 0, 0);
            v48.Size = Vector3.new(p46.X * 0.85, p46.Y * 1.05, p46.Z * 0.85);
            v48.CFrame = v50 * CFrame.new(0, v48.Size.Y * (v48.Size.Y * 0.075), 0);
            v48.Color = Color3.new(u16.R + v49, u16.G + v49, u16.B + v49);
            u22 = u22 - u24;
            u24 = u24 - 6.5;
            v48.Name = p47;

            if p47 == 3 then
                for _, v in CreateLeafStems(v48, p47) do
                    local ObjectValue = Instance.new("ObjectValue");
                    ObjectValue.Parent = v48;
                    ObjectValue.Name = "LeafStemReference";
                    ObjectValue.Value = v;
                end;
            end;

            local v51 = p47 + 1;
            local v52 = v48.CFrame * CFrame.new(0, 0, v48.Size.Z / 2);
            local v53;

            if v51 == 5 then
                v53 = Random.new(u17):NextNumber(1.8, 2.1);
            else
                v53 = Random.new(u17):NextNumber(1.1, 1.4);
            end;

            local v54 = CreateSpike(v52, v51, v53);
            local ObjectValue = Instance.new("ObjectValue");
            ObjectValue.Parent = v48;
            ObjectValue.Name = "Reference";
            ObjectValue.Value = v54;
            local v55 = v48.CFrame * CFrame.new(0, v48.Size.Y / 2, 0);

            if v51 < 7 then
                GenerateStem(v55, v48.Size, v51);

                return;
            end;

            v48.Color = u16;
            u14:PivotTo(v55 * CFrame.Angles(0, 1.5707963267948966, 0));
            u14:ScaleTo(v48.Size.Y * Random.new(u17):NextNumber(0.165, 0.2));
            u14.Parent = u11;
            u14.Name = "PlantModel";

            for _, descendant in u14:GetDescendants() do
                local v56 = tonumber(descendant.Name);

                if v56 then
                    descendant.Name = v56 + v51 - 1;
                end;

                if descendant.Name == "Teeth" then
                    u18 = u18 + 1;
                    local v57 = math.clamp(u17 + u18, 1, 100) * 100;
                    local v58 = u17;
                    local v59 = u17 * math.random(1, (math.clamp(v57, 1, 10000)));
                    u17 = math.clamp(v59, 1, 9100000000000);

                    if u17 == v58 then
                        u17 = 3;
                    end;

                    math.randomseed(u17);
                    descendant:ScaleTo(Random.new(u17):NextNumber(0.65, 1.05));
                end;
            end;

            local Fruit_Spawn = u14:FindFirstChild("Fruit_Spawn");

            if Fruit_Spawn then
                Fruit_Spawn.Parent = FruitSpawnLocations;
            end;
        end;

        local v60 = CreatePart(u11, nil, "Studs");
        local v61 = Vector3.new(v15, v15, v15);
        v60.CFrame = Base.CFrame;
        v60.Size = v61;
        v60.Color = u16;
        v60.Name = 1;
        GenerateStem(v60.CFrame * CFrame.new(0, v15 / 2, 0), v61, 2);
        u11:ScaleTo((p13 or 1) * 0.25 + 0.75);
        u11:AddTag("InitializationComplete");
    end,

    BeginPlantGrowth = function(u62) -- Line: 329, Name: BeginPlantGrowth
        local PrimaryPart = u62.PrimaryPart;
        local u63 = {};

        for _, v in u62:QueryDescendants("BasePart") do
            local v64 = tonumber(v.Name);

            if v64 then
                local v65 = {};

                for _, child in v:GetChildren() do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        table.insert(v65, {
                            decal = child,
                            originalTransparency = child.Transparency
                        });
                        child.Transparency = 1;
                    end;
                end;

                local v66 = {
                    part = v,
                    maxSize = v.Size,
                    centerOffset = PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    partAge = v64,
                    decals = v65
                };
                table.insert(u63, v66);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 359
            -- upvalues: u62 (copy), u63 (copy), PrimaryPart (copy)
            local v67 = u62:GetAttribute("Age") or 0;

            for _, v in u63 do
                local v68 = math.min(v67 - v.partAge, 1);
                local v69 = math.clamp(v68, 0, 1);

                if v69 ~= v.lastProgress then
                    v.lastProgress = v69;

                    if v68 > 0 then
                        local v70 = v.maxSize.Y * v68;
                        v.part.Size = Vector3.new(v.maxSize.X, v70, v.maxSize.Z);
                        v.part.CFrame = PrimaryPart.CFrame * v.centerOffset * CFrame.new(0, -((v.maxSize.Y - v70) / 2), 0);
                        v.part.Transparency = v.part:GetAttribute("OG_Transparency") or 0;
                        v.part.CanCollide = true;

                        for _, v2 in v.decals do
                            v2.decal.Transparency = v2.originalTransparency + (1 - v2.originalTransparency) * (1 - v68);
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

            if game.Players.LocalPlayer and (game:GetService("RunService"):IsClient() and (not u62:GetAttribute("SetupIK") and u62:GetAttribute("MaxAge") <= v67)) then
                u62:SetAttribute("SetupIK", true);
                task.delay(1, function() -- Line: 397
                    -- upvalues: u62 (ref)
                    u62:AddTag("VenusFlyTrap");
                end);
            end;
        end;

        u62:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};