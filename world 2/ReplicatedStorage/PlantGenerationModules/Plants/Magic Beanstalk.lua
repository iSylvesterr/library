-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("RunService");
local u1 = ReplicatedStorage.Assets:FindFirstChild("Meshes/BeanStalkMesh");

local function createStudPart() -- Line: 13
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.Massless = true;
    Part.BackSurface = Enum.SurfaceType.Studs;
    Part.BottomSurface = Enum.SurfaceType.Studs;
    Part.FrontSurface = Enum.SurfaceType.Studs;
    Part.LeftSurface = Enum.SurfaceType.Studs;
    Part.RightSurface = Enum.SurfaceType.Studs;
    Part.Size = Vector3.new(2, 1, 4);

    return Part;
end;

local function clampScale(p2) -- Line: 34
    local v3 = typeof(p2) ~= "number" and 0.6 or p2;

    return math.clamp(v3, 0.05, 1) * 2.4;
end;

local function applySizeToModel(u4) -- Line: 39
    local v5 = u4:GetAttribute("BeanstalkSize");
    local v6 = typeof(v5) ~= "number" and 0.6 or v5;
    local v7 = typeof(v6) ~= "number" and 0.6 or v6;
    local u8 = math.clamp(v7, 0.05, 1) * 2.4;
    local _, _ = pcall(function() -- Line: 43
        -- upvalues: u4 (copy), u8 (copy)
        u4:ScaleTo(u8);
    end);
end;

local function ensureLabel(u9) -- Line: 50
    local v10 = u9.PrimaryPart or u9:FindFirstChild("Base");

    if not v10 then
        return;
    end;

    if v10:FindFirstChild("GuildBeanstalkLabel") then
        return;
    end;

    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Name = "GuildBeanstalkLabel";
    BillboardGui.Size = UDim2.fromOffset(300, 80);
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 50, 0);
    BillboardGui.AlwaysOnTop = true;
    BillboardGui.LightInfluence = 0;
    BillboardGui.MaxDistance = 250;
    local Frame = Instance.new("Frame");
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundColor3 = Color3.fromRGB(20, 25, 35);
    Frame.BackgroundTransparency = 0.25;
    Frame.BorderSizePixel = 0;
    Frame.Parent = BillboardGui;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, 8);
    UICorner.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3.fromRGB(110, 231, 167);
    UIStroke.Thickness = 1.5;
    UIStroke.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Size = UDim2.fromScale(1, 1);
    TextLabel.Font = Enum.Font.GothamBold;
    TextLabel.TextColor3 = Color3.fromRGB(230, 237, 243);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
    TextLabel.TextStrokeTransparency = 0.5;
    TextLabel.Text = "";
    TextLabel.Parent = Frame;
    BillboardGui.Parent = v10;

    local function updateLabel() -- Line: 95
        -- upvalues: u9 (copy), TextLabel (copy), BillboardGui (copy)
        local v11 = u9:GetAttribute("GuildTag");
        local v12 = u9:GetAttribute("GuildName");

        if typeof(v11) == "string" and (v11 ~= "" and (typeof(v12) == "string" and v12 ~= "")) then
            TextLabel.Text = `[{v11}] {v12}`;
            BillboardGui.Enabled = true;

            return;
        end;

        if typeof(v12) ~= "string" or v12 == "" then
            BillboardGui.Enabled = false;

            return;
        end;

        TextLabel.Text = v12;
        BillboardGui.Enabled = true;
    end;

    updateLabel();
    u9:GetAttributeChangedSignal("GuildTag"):Connect(updateLabel);
    u9:GetAttributeChangedSignal("GuildName"):Connect(updateLabel);
end;

local function bindAttributeListeners(u13) -- Line: 114
    -- upvalues: applySizeToModel (copy)
    u13:GetAttributeChangedSignal("BeanstalkSize"):Connect(function() -- Line: 115
        -- upvalues: applySizeToModel (ref), u13 (copy)
        applySizeToModel(u13);
    end);
end;

return {
    GrowData = {
        InheritPlantSizeMultiplier = 0.25
    },

    InitPlant = function(u14, p15, p16) -- Line: 127, Name: InitPlant
        -- upvalues: u1 (copy), createStudPart (copy), CollectionService (copy), applySizeToModel (copy), ensureLabel (copy)
        local v17 = p16 or 1;
        local v18 = Random.new(p15);
        local FruitSpawnLocations = u14.FruitSpawnLocations;
        local Base = u14.Base;
        local v19 = v17 * 3 * v18:NextInteger(7, 14) * 0.1;
        local v20 = v17 * 2 * v18:NextInteger(7, 14) * 0.1;
        local v21 = v17 * v18:NextInteger(7, 14) * 0.1;
        local v22 = math.clamp(v21, 1, (1 / 0));
        local v23 = math.sqrt(v22) * 30;
        local u24 = 0;

        while v18:NextInteger(1, 10) == 1 do
            v23 = v23 + 5;
        end;

        local v25 = 3 * v18:NextInteger(7, 14) * 0.1;
        local v26 = Base.CFrame * CFrame.new(0, -Base.Size.Y / 2, 0);
        local v27 = 3 * v18:NextInteger(7, 14) * 0.1 * v17;
        local v28 = v18:NextInteger(950, 995) * 0.001;
        local v29 = 0;
        local v30 = {};

        for i = 1, v23 do
            u24 = u24 + 1;
            v19 = v19 * v28;
            v20 = v20 * v28;
            local v31 = i * 0.1 % 2;
            local v32 = v31 <= 1 and v31 and v31 or 2 - v31;
            v29 = v29 + 10;
            local v33 = math.rad(v29);
            local v34 = CFrame.new(math.cos(v33) * v27, 0, math.sin(v33) * v27);
            local v35 = u1:Clone();
            v35.Size = Vector3.new(v19 * 2, v20 * 1.25, v19 * 2);
            v35.Color = Color3.fromHSV(0.24500000000000002 + v32 * 0.025, 0.5 + v32 * 0.175, 0.5 + v32 * 0.25);
            v35.CFrame = v26 * v34 * CFrame.new(0, v35.Size.Y / 2, 0);
            v35.Name = tostring(u24);
            v35.Parent = u14;

            if u24 % 2 == 0 then
                table.insert(v30, v35);
            end;

            local v36 = v26 * CFrame.new(0, v20, 0);
            v26 = v36 * CFrame.Angles(math.rad(-1 + v32 * 2), math.rad(v25), (math.rad(-1 + v32 * 2)));
        end;

        local function attachWedges(p37) -- Line: 185
            -- upvalues: u24 (ref), createStudPart (ref), u14 (copy), CollectionService (ref)
            u24 = u24 + 1;
            local v38 = createStudPart();
            v38.Shape = Enum.PartType.Wedge;
            v38.Size = Vector3.new(p37.Size.Z, p37.Size.Y * 0.5, p37.Size.X / 2);
            v38.CFrame = p37.CFrame * CFrame.new(-p37.Size.X / 4, -(p37.Size.Y / 2 + v38.Size.Y / 2), 0);
            v38.CFrame = v38.CFrame * CFrame.Angles(0, 1.5707963267948966, 0);
            v38.CFrame = v38.CFrame * CFrame.Angles(0, 0, 3.141592653589793);
            v38.Color = p37.Color;
            v38.Name = tostring(u24);
            v38.Parent = u14;
            CollectionService:AddTag(v38, "DetailPart");
            local v39 = createStudPart();
            v39.Shape = Enum.PartType.Wedge;
            v39.Size = Vector3.new(p37.Size.Z, p37.Size.Y * 0.5, p37.Size.X / 2);
            v39.CFrame = p37.CFrame * CFrame.new(p37.Size.X / 4, -(p37.Size.Y / 2 + v39.Size.Y / 2), 0);
            v39.CFrame = v39.CFrame * CFrame.Angles(0, -1.5707963267948966, 0);
            v39.CFrame = v39.CFrame * CFrame.Angles(0, 0, 3.141592653589793);
            v39.Color = p37.Color;
            v39.Name = tostring(u24);
            v39.Parent = u14;
            CollectionService:AddTag(v39, "DetailPart");
        end;

        for i = #v30, 1, -1 do
            local v40 = v30[i];
            u24 = u24 + 1;
            local v41 = v40.CFrame * CFrame.Angles(1.5707963267948966, 0, 0);
            local Angles = CFrame.Angles;
            local v42 = v18:NextInteger(-180, 180);
            local v43 = v41 * Angles(0, 0, (math.rad(v42)));
            local Angles2 = CFrame.Angles;
            local v44 = -v18:NextInteger(30, 45);
            local v45 = v43 * Angles2(math.rad(v44), 0, 0);
            local Magnitude = v40.Size.Magnitude;
            local v46 = createStudPart();
            v46.Color = v40.Color;
            local v47 = v18:NextInteger(17, 21) * 0.1 * (Magnitude * 0.34);
            v46.Size = Vector3.new(1 * (Magnitude * 0.2), v47, 2);
            v46.CFrame = v45 * CFrame.new(0, v46.Size.Y / 2, 0);
            v46.Name = tostring(u24);
            v46.Parent = u14;
            u24 = u24 + 1;
            local v48 = v18:NextInteger(27, 30) * 0.1;
            local v49 = createStudPart();
            v49.Color = v40.Color;
            v49.Size = Vector3.new(v48 * (Magnitude * 0.2), v48 * (Magnitude * 0.2), 2);
            v49.CFrame = v46.CFrame * CFrame.new(0, v46.Size.Y / 2 + v49.Size.Y / 2, 0) * CFrame.Angles(3.141592653589793, 0, 0);
            v49.Name = tostring(u24);
            v49.Parent = u14;
            CollectionService:AddTag(v49, "DetailPart");
            attachWedges(v49);
            v49.CFrame = v49.CFrame * CFrame.Angles(3.141592653589793, 0, 0);
            local v50 = createStudPart();
            v50.Transparency = 1;
            v50.Size = Vector3.new(0.1, 0.1, 0.1);
            v50.CFrame = CFrame.new((v49.CFrame * CFrame.new(0, 0, v49.Size.Z / 2)).Position) * CFrame.Angles(-1.5707963267948966, 0, 0);
            v50.Orientation = Vector3.new(v50.Orientation.X, -v46.Orientation.Y, v50.Orientation.Z);
            v50.Parent = FruitSpawnLocations;
            v50.Name = "FruitSpawn";
        end;

        applySizeToModel(u14);
        u14:GetAttributeChangedSignal("BeanstalkSize"):Connect(function() -- Line: 115
            -- upvalues: applySizeToModel (ref), u14 (copy)
            applySizeToModel(u14);
        end);
        ensureLabel(u14);
        u14:AddTag("InitializationComplete");
        u14:AddTag("MagicBeanstalk");
    end,

    BeginPlantGrowth = function(u51) -- Line: 265, Name: BeginPlantGrowth
        local PrimaryPart = u51.PrimaryPart;
        local u52 = {};

        for _, v in u51:QueryDescendants("BasePart") do
            local v53 = tonumber(v.Name);

            if v53 then
                local v54 = {
                    v,
                    v.Size,
                    PrimaryPart.CFrame:ToObjectSpace(v.CFrame),
                    v53
                };
                table.insert(u52, v54);
                v.CanCollide = false;
                v.Transparency = 1;
            end;
        end;

        local function updateGrowth() -- Line: 281
            -- upvalues: u51 (copy), u52 (copy), PrimaryPart (copy)
            local v55 = u51:GetAttribute("Age") or 0;

            for _, v in u52 do
                local v56 = v[1];
                local v57 = v[2];
                local v58 = v[3];
                local v59 = math.min(v55 - v[4], 1);
                local v60 = math.clamp(v59, 0, 1);

                if v60 ~= v.lastProgress then
                    v.lastProgress = v60;

                    if v59 > 0 then
                        v56.Size = Vector3.new(v57.X, v57.Y * v59, v57.Z);
                        v56.CFrame = PrimaryPart.CFrame * v58 * CFrame.new(0, (v56.Size.Y - v57.Y) / 2, 0);
                        v56.Transparency = v56:GetAttribute("OG_Transparency") or 0;
                        v56.CanCollide = true;
                    else
                        v56.Transparency = 1;
                        v56.CanCollide = false;
                    end;
                end;
            end;
        end;

        u51:GetAttributeChangedSignal("Age"):Connect(updateGrowth);
        updateGrowth();
    end,

    Extras = {}
};