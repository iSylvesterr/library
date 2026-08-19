-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 1
};
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local CollectionService = game:GetService("CollectionService");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local CutsceneGate = require(ReplicatedStorage.ClientModules.CutsceneGate);
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = workspace.CurrentCamera;
local Gardens = workspace:WaitForChild("Gardens");
local u2 = 0;
local u3 = false;
local u4 = 0;
local u5 = {};
local Assets = ReplicatedStorage.Assets;
local Dirt = Assets.Dirt;
local Seeds = Assets.Seeds;
local PlantSFX = game.SoundService.SFX.PlantSFX;
local Temporary = workspace.Temporary;
local u6 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u7 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u8 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u9 = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local u10 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local u11 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u12 = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local u13 = TweenInfo.new(0.12, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out);
local u14 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u15 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
local u16 = {
    Color3.fromRGB(101, 67, 33),
    Color3.fromRGB(92, 60, 28),
    Color3.fromRGB(110, 75, 40),
    Color3.fromRGB(85, 55, 25)
};
local u17 = {};

local function plantHasSprouted(p18) -- Line: 75
    for _, v in p18:QueryDescendants("BasePart:not([Transparency = 1])") do
        if tonumber(v.Name) then
            return true;
        end;
    end;

    return false;
end;

function v1.Init(p19) -- Line: 84
end;

function v1.Start(u20) -- Line: 87
    -- upvalues: UserInputService (copy), CutsceneGate (copy), CurrentCamera (copy), Networking (copy), LocalPlayer (copy)
    UserInputService.InputEnded:Connect(function(p21, p22) -- Line: 88
        -- upvalues: u20 (copy)
        u20:OnInputEnded(p21);
    end);
    UserInputService.TouchTapInWorld:Connect(function(p23, p24) -- Line: 95
        -- upvalues: CutsceneGate (ref), u20 (copy), CurrentCamera (ref)
        if p24 then
            return;
        end;

        if CutsceneGate.IsActive() then
            return;
        end;

        if not u20:IsTouchInput() then
            return;
        end;

        local v25 = u20:GetEquippedTool();

        if not v25 or v25:GetAttribute("SeedTool") == nil then
            return;
        end;

        u20:TryPlantWithRay((CurrentCamera:ViewportPointToRay(p23.X, p23.Y)));
    end);
    Networking.Plant.PlantFx.OnClientEvent:Connect(function(p26, p27, p28) -- Line: 107
        -- upvalues: u20 (copy)
        u20:PlayPlantFx(p26, p27, p28);
    end);
    u20:WatchBackpack();

    if LocalPlayer.Character then
        u20:WatchCharacter(LocalPlayer.Character);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p29) -- Line: 115
        -- upvalues: u20 (copy)
        u20:WatchCharacter(p29);
    end);
end;

function v1.IsTouchInput(p30) -- Line: 120
    -- upvalues: UserInputService (copy)
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled;
end;

function v1.WatchBackpack(u31) -- Line: 124
    -- upvalues: LocalPlayer (copy)
    local function hook(p32) -- Line: 125
        -- upvalues: u31 (copy)
        for _, child in p32:GetChildren() do
            if child:IsA("Tool") then
                u31:TrySetupSeedTool(child);
            end;
        end;

        p32.ChildAdded:Connect(function(p33) -- Line: 131
            -- upvalues: u31 (ref)
            if p33:IsA("Tool") then
                u31:TrySetupSeedTool(p33);
            end;
        end);
    end;

    local v34 = LocalPlayer:FindFirstChildOfClass("Backpack");

    if v34 then
        hook(v34);
    end;

    LocalPlayer.ChildAdded:Connect(function(p35) -- Line: 140
        -- upvalues: hook (copy)
        if p35:IsA("Backpack") then
            hook(p35);
        end;
    end);
end;

function v1.WatchCharacter(u36, p37) -- Line: 147
    for _, child in p37:GetChildren() do
        if child:IsA("Tool") then
            u36:TrySetupSeedTool(child);
        end;
    end;

    p37.ChildAdded:Connect(function(p38) -- Line: 153
        -- upvalues: u36 (copy)
        if p38:IsA("Tool") then
            u36:TrySetupSeedTool(p38);
        end;
    end);
end;

function v1.TrySetupSeedTool(p39, p40) -- Line: 160
    -- upvalues: u5 (copy)
    if u5[p40] then
        return;
    end;

    p39:SetupSeedTool(p40);
end;

function v1.SetupSeedTool(u41, u42) -- Line: 165
    -- upvalues: u5 (copy), u3 (ref)
    if u5[u42] then
        return;
    end;

    local v43 = {};
    table.insert(v43, u42.Activated:Connect(function() -- Line: 170
        -- upvalues: u42 (copy), u41 (copy)
        if u42:GetAttribute("SeedTool") == nil then
            return;
        end;

        u41:OnPlantTriggered();
    end));
    table.insert(v43, u42.Deactivated:Connect(function() -- Line: 175
        -- upvalues: u3 (ref)
        u3 = false;
    end));
    table.insert(v43, u42.AncestryChanged:Connect(function() -- Line: 179
        -- upvalues: u42 (copy), u41 (copy)
        if not u42:IsDescendantOf(game) then
            u41:CleanupSeedTool(u42);
        end;
    end));
    table.insert(v43, u42.Destroying:Connect(function() -- Line: 185
        -- upvalues: u41 (copy), u42 (copy)
        u41:CleanupSeedTool(u42);
    end));
    u5[u42] = v43;
end;

function v1.CleanupSeedTool(p44, p45) -- Line: 192
    -- upvalues: u5 (copy)
    local v46 = u5[p45];

    if not v46 then
        return;
    end;

    for _, v in v46 do
        v:Disconnect();
    end;

    u5[p45] = nil;
end;

function v1.GetPlayerPlot(p47) -- Line: 199
    -- upvalues: LocalPlayer (copy), Gardens (copy)
    local v48 = LocalPlayer:GetAttribute("PlotId");

    if v48 then
        return Gardens:FindFirstChild("Plot" .. v48);
    end;

    return nil;
end;

function v1.GetEquippedTool(p49) -- Line: 205
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character then
        return Character:FindFirstChildWhichIsA("Tool");
    end;

    return nil;
end;

function v1.CreatePlantAreaParams(p50) -- Line: 211
    -- upvalues: CollectionService (copy)
    local v51 = RaycastParams.new();
    v51.FilterType = Enum.RaycastFilterType.Include;
    v51.FilterDescendantsInstances = CollectionService:GetTagged("PlantArea");

    return v51;
end;

function v1.CreatePlantsParams(p52) -- Line: 218
    local v53 = RaycastParams.new();
    v53.FilterType = Enum.RaycastFilterType.Include;
    local v54 = {};

    for _, child in workspace.Gardens:GetChildren() do
        local Plants = child:FindFirstChild("Plants");

        if Plants then
            table.insert(v54, Plants);
        end;
    end;

    v53.FilterDescendantsInstances = v54;

    return v53;
end;

function v1.TryPlantWithRay(p55, p56) -- Line: 232
    -- upvalues: u2 (ref), Networking (copy)
    local v57 = os.clock();

    if v57 - u2 < 0.05 then
        return false;
    end;

    local v58 = p55:GetEquippedTool();

    if not v58 then
        return false;
    end;

    local v59 = v58:GetAttribute("SeedTool");

    if not v59 then
        return false;
    end;

    local v60 = p55:GetPlayerPlot();

    if not v60 then
        return false;
    end;

    local v61 = p55:CreatePlantAreaParams();
    local v62 = nil;

    for _ = 1, 5 do
        v62 = workspace:Raycast(p56.Origin, p56.Direction * 5000, v61);

        if not v62 then
            break;
        end;

        local Instance2 = v62.Instance;

        if Instance2.Transparency < 1 then
            break;
        end;

        local FilterDescendantsInstances = v61.FilterDescendantsInstances;
        local v63 = table.find(FilterDescendantsInstances, Instance2);

        if not v63 then
            break;
        end;

        table.remove(FilterDescendantsInstances, v63);
        v61.FilterDescendantsInstances = FilterDescendantsInstances;
    end;

    if not v62 then
        return false;
    end;

    if not v62.Instance:IsDescendantOf(v60) then
        return false;
    end;

    local v64 = workspace:Raycast(p56.Origin, p56.Direction * 5000, p55:CreatePlantsParams());

    if v64 then
        local Position = v62.Position;
        local Position2 = v64.Position;

        if (Vector2.new(Position2.X, Position2.Z) - Vector2.new(Position.X, Position.Z)).Magnitude < 1 then
            return false;
        end;
    end;

    u2 = v57;
    Networking.Plant.PlantSeed:Fire(v62.Position, v59, v58);

    return true;
end;

function v1.OnPlantTriggered(u65) -- Line: 277
    -- upvalues: CutsceneGate (copy), u3 (ref), UserInputService (copy), CurrentCamera (copy), u4 (ref)
    if CutsceneGate.IsActive() then
        return;
    end;

    if u65:IsTouchInput() then
        return;
    end;

    if u3 then
        return;
    end;

    local v66 = UserInputService:GetMouseLocation();
    u65:TryPlantWithRay((CurrentCamera:ViewportPointToRay(v66.X, v66.Y)));
    u3 = true;
    u4 = os.clock();
    task.spawn(function() -- Line: 292
        -- upvalues: u3 (ref), u4 (ref), UserInputService (ref), CurrentCamera (ref), u65 (copy)
        while u3 and os.clock() - u4 < 1 do
            task.wait(0.05);
        end;

        while u3 do
            local v67 = UserInputService:GetMouseLocation();
            u65:TryPlantWithRay((CurrentCamera:ViewportPointToRay(v67.X, v67.Y)));
            task.wait(0.4);
        end;
    end);
end;

function v1.OnInputEnded(p68, p69) -- Line: 307
    -- upvalues: u3 (ref)
    if p69.UserInputType == Enum.UserInputType.MouseButton1 or (p69.UserInputType == Enum.UserInputType.Touch or p69.KeyCode == Enum.KeyCode.ButtonR2) then
        u3 = false;
    end;
end;

function v1.SetPartsTransparency(p70, p71, p72) -- Line: 315
    if p71:IsA("BasePart") then
        p71.Transparency = p72;
    end;

    for _, v in p71:QueryDescendants("BasePart") do
        v.Transparency = p72;
    end;
end;

function v1.CreateDirtChunk(p73, p74) -- Line: 325
    -- upvalues: u16 (copy), Temporary (copy), TweenService (copy), u12 (copy), u13 (copy), u14 (copy), u15 (copy), Debris (copy)
    local Part = Instance.new("Part");
    local u75 = math.random(25, 45) / 100;
    Part.Size = Vector3.new(u75, u75 * 0.7, u75);
    Part.Color = u16[math.random(1, #u16)];
    Part.Material = Enum.Material.SmoothPlastic;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CastShadow = false;
    Part.Transparency = 0;
    Part.Position = p74 + Vector3.new(0, 0.05, 0);
    local v76 = math.random(-30, 30);
    local v77 = math.random(-180, 180);
    Part.Orientation = Vector3.new(v76, v77, math.random(-30, 30));
    Part.Parent = Temporary;
    local v78 = math.random(0, 360);
    local v79 = math.rad(v78);
    local v80 = math.random(30, 60) / 100;
    local v81 = math.cos(v79) * v80;
    local v82 = math.sin(v79) * v80;
    local v83 = math.random(50, 90) / 100;
    local v84 = p74 + Vector3.new(v81 * 0.6, v83, v82 * 0.6);
    local u85 = p74 + Vector3.new(v81, 0.02, v82);
    local u86 = u85 + Vector3.new(0, -0.01, 0);
    local v87 = {
        Position = v84
    };
    local Orientation = Part.Orientation;
    local v88 = math.random(-45, 45);
    local v89 = math.random(-90, 90);
    v87.Orientation = Orientation + Vector3.new(v88, v89, math.random(-45, 45));
    local v90 = TweenService:Create(Part, u12, v87);
    v90:Play();
    v90.Completed:Connect(function() -- Line: 356
        -- upvalues: TweenService (ref), Part (copy), u13 (ref), u85 (copy), u75 (copy), u14 (ref), u86 (copy), u15 (ref), Debris (ref)
        local v91 = TweenService:Create(Part, u13, {
            Position = u85,
            Size = Vector3.new(u75 * 1.1, u75 * 0.5, u75 * 1.1)
        });
        v91:Play();
        v91.Completed:Connect(function() -- Line: 363
            -- upvalues: TweenService (ref), Part (ref), u14 (ref), u86 (ref), u75 (ref), u15 (ref), Debris (ref)
            local v92 = TweenService:Create(Part, u14, {
                Position = u86,
                Size = Vector3.new(u75, u75 * 0.65, u75)
            });
            v92:Play();
            v92.Completed:Connect(function() -- Line: 370
                -- upvalues: TweenService (ref), Part (ref), u15 (ref), Debris (ref)
                task.delay(0.15, function() -- Line: 371
                    -- upvalues: TweenService (ref), Part (ref), u15 (ref), Debris (ref)
                    TweenService:Create(Part, u15, {
                        Transparency = 1
                    }):Play();
                    Debris:AddItem(Part, u15.Time);
                end);
            end);
        end);
    end);
end;

function v1.PlaySfx(p93) -- Line: 381
    -- upvalues: PlantSFX (copy), Temporary (copy)
    local u94 = PlantSFX:Clone();
    u94.PlaybackSpeed = 1 + math.random(-10, 10) / 100;
    u94.Parent = Temporary;
    u94:Play();
    u94.Ended:Connect(function() -- Line: 386
        -- upvalues: u94 (copy)
        u94:Destroy();
    end);
end;

function v1.SpawnDirtChunks(u95, u96) -- Line: 391
    for i = 1, math.random(6, 10) do
        task.delay(i * 0.015, function() -- Line: 394
            -- upvalues: u95 (copy), u96 (copy)
            u95:CreateDirtChunk(u96);
        end);
    end;
end;

function v1.WaitForPlantSprout(p97, p98) -- Line: 403
    -- upvalues: LocalPlayer (copy)
    local u99 = workspace:GetServerTimeNow() + math.random(7, 11);

    local function waitOutMinimum() -- Line: 407
        -- upvalues: u99 (copy)
        local v100 = u99 - workspace:GetServerTimeNow();

        if v100 > 0 then
            task.wait(v100);
        end;
    end;

    if not p98 or p98 == "" then
        local v101 = u99 - workspace:GetServerTimeNow();

        if v101 > 0 then
            task.wait(v101);
        end;

        return;
    end;

    local v102 = workspace:GetServerTimeNow() + 600;
    local v103 = `{LocalPlayer.UserId}_{p98}`;
    local v104 = nil;

    while workspace:GetServerTimeNow() < v102 do
        local v105 = p97:GetPlayerPlot();

        if v105 then
            v105 = v105:FindFirstChild("Plants");
        end;

        if v105 then
            v104 = v105:FindFirstChild(v103);

            if v104 then
                break;
            end;
        end;

        task.wait(0.25);
    end;

    if v104 and v104:IsA("Model") then
        while workspace:GetServerTimeNow() < v102 and v104.Parent do
            if v104:GetAttribute("PlantGrowthReady") then
                local v106 = false;

                for _, v in v104:QueryDescendants("BasePart:not([Transparency = 1])") do
                    if tonumber(v.Name) then
                        v106 = true;
                        break;
                    end;
                end;

                if v106 then
                    break;
                end;
            end;

            task.wait(0.25);
        end;
    end;

    local v107 = u99 - workspace:GetServerTimeNow();

    if v107 > 0 then
        task.wait(v107);
    end;
end;

function v1.CreateDirtDecal(u108, p109, u110) -- Line: 444
    -- upvalues: u17 (copy), Dirt (copy), Temporary (copy), TweenService (copy), u6 (copy), u7 (copy), Debris (copy)
    if u110 and u110 ~= "" then
        if u17[u110] then
            return;
        end;

        u17[u110] = true;
    end;

    local u111 = Dirt:Clone();
    u111.Position = p109 - Vector3.new(0, 0.01, 0);
    local X = Dirt.Orientation.X;
    local v112 = math.random(-180, 180);
    u111.Orientation = Vector3.new(X, v112, Dirt.Orientation.Z);
    u111.Size = Vector3.new(0.1, 0.8, 0.8);
    u111.Transparency = 1;
    u111.Parent = Temporary;
    TweenService:Create(u111, u6, {
        Size = Vector3.new(0.1, 2, 2),
        Transparency = 0
    }):Play();
    task.spawn(function() -- Line: 460
        -- upvalues: u108 (copy), u110 (copy), u111 (copy), TweenService (ref), u7 (ref), Debris (ref)
        u108:WaitForPlantSprout(u110);

        if not (u111 and u111.Parent) then
            return;
        end;

        TweenService:Create(u111, u7, {
            Size = Vector3.new(0.1, 1.75, 1.75),
            Transparency = 1
        }):Play();
        Debris:AddItem(u111, u7.Time);
    end);
end;

function v1.EnsureSeedMarker(p113, p114, p115, p116, p117) -- Line: 473
    -- upvalues: LocalPlayer (copy), u17 (copy)
    if p114 ~= LocalPlayer.UserId then
        return;
    end;

    if not p115 or p115 == "" then
        return;
    end;

    if u17[p115] then
        return;
    end;

    local v118 = false;

    for _, v in p116:QueryDescendants("BasePart:not([Transparency = 1])") do
        if tonumber(v.Name) then
            v118 = true;
            break;
        end;
    end;

    if v118 then
        return;
    end;

    p113:CreateDirtDecal(p117, p115);
end;

function v1.CreateImpactRing(p119, p120) -- Line: 481
    -- upvalues: Temporary (copy), TweenService (copy), Debris (copy)
    local Part = Instance.new("Part");
    Part.Shape = Enum.PartType.Cylinder;
    Part.Size = Vector3.new(0.05, 0.3, 0.3);
    Part.Color = Color3.fromRGB(139, 90, 43);
    Part.Material = Enum.Material.SmoothPlastic;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CastShadow = false;
    Part.Transparency = 0.3;
    Part.Position = p120 + Vector3.new(0, 0.02, 0);
    Part.Orientation = Vector3.new(0, 0, 90);
    Part.Parent = Temporary;
    TweenService:Create(Part, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(0.05, 1.8, 1.8),
        Transparency = 1
    }):Play();
    Debris:AddItem(Part, 0.35);
end;

function v1.PlayPlantFx(u121, u122, p123, u124) -- Line: 504
    -- upvalues: Seeds (copy), Temporary (copy), u8 (copy), TweenService (copy), u9 (copy), u10 (copy), u11 (copy), Debris (copy)
    local v125 = Seeds:FindFirstChild(p123);

    if not v125 then
        u121:PlaySfx();
        u121:SpawnDirtChunks(u122);
        u121:CreateDirtDecal(u122, u124);
        u121:CreateImpactRing(u122);

        return;
    end;

    local u126 = v125:Clone();
    local u127;

    if u126:IsA("BasePart") then
        u127 = u126;
    else
        u127 = u126.PrimaryPart;
    end;

    if not u127 then
        u126:Destroy();

        return;
    end;

    u127.Anchored = true;
    u127.CanCollide = false;
    local Size = u127.Size;
    local Orientation = u127.Orientation;
    local v128 = CFrame.new(u122 + Vector3.new(0, 1.5, 0)) * CFrame.Angles(0, math.rad(Orientation.Y), 0);
    local v129 = CFrame.new(u122 + Vector3.new(0, 2, 0)) * CFrame.Angles(0, math.rad(Orientation.Y + 15), 0);
    local u130 = CFrame.new(u122 + Vector3.new(0, 0.15, 0)) * CFrame.Angles(0, math.rad(Orientation.Y + 60), 0);
    local u131 = CFrame.new(u122 + Vector3.new(0, 0.15 - Size.Y * 0.15, 0)) * CFrame.Angles(0, math.rad(Orientation.Y + 60), 0);
    local u132 = CFrame.new(u122 + Vector3.new(0, -0.1, 0)) * CFrame.Angles(0, math.rad(Orientation.Y + 60), 0);
    u127.CFrame = v128;
    u121:SetPartsTransparency(u126, 1);
    u126.Parent = Temporary;
    u121:TweenAllPartsTransparency(u126, u8, 0);
    local v133 = TweenService:Create(u127, u9, {
        CFrame = v129
    });
    v133:Play();
    v133.Completed:Once(function() -- Line: 544
        -- upvalues: TweenService (ref), u127 (copy), u10 (ref), u130 (copy), u11 (ref), u131 (copy), Size (copy), u132 (copy), u121 (copy), u126 (copy), u122 (copy), u124 (copy), Debris (ref)
        local v134 = TweenService:Create(u127, u10, {
            CFrame = u130
        });
        v134:Play();
        v134.Completed:Once(function() -- Line: 550
            -- upvalues: TweenService (ref), u127 (ref), u11 (ref), u131 (ref), Size (ref), u132 (ref), u121 (ref), u126 (ref), u122 (ref), u124 (ref), Debris (ref)
            local v135 = TweenService:Create(u127, u11, {
                CFrame = u131,
                Size = Vector3.new(Size.X * 1.3, Size.Y * 0.6, Size.Z * 1.3)
            });
            v135:Play();
            v135.Completed:Once(function() -- Line: 557
                -- upvalues: TweenService (ref), u127 (ref), u132 (ref), Size (ref), u121 (ref), u126 (ref), u122 (ref), u124 (ref), Debris (ref)
                local v136 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
                TweenService:Create(u127, v136, {
                    CFrame = u132,
                    Size = Size * 0.8
                }):Play();
                u121:TweenAllPartsTransparency(u126, v136, 1);
                u121:PlaySfx();
                u121:SpawnDirtChunks(u122);
                u121:CreateDirtDecal(u122, u124);
                u121:CreateImpactRing(u122);
                Debris:AddItem(u126, 0.2);
            end);
        end);
    end);
end;

function v1.TweenAllPartsTransparency(p137, p138, p139, p140) -- Line: 578
    -- upvalues: TweenService (copy)
    if p138:IsA("BasePart") then
        TweenService:Create(p138, p139, {
            Transparency = p140
        }):Play();
    end;

    for _, v in p138:QueryDescendants("BasePart") do
        TweenService:Create(v, p139, {
            Transparency = p140
        }):Play();
    end;
end;

return v1;