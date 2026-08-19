-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local Bezier = require(ReplicatedStorage.ClientModules.Bezier);
local Spring2 = require(ReplicatedStorage.ClientModules.Spring2);
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local PetData = require(ReplicatedStorage.SharedData.PetData);
local EggData = require(ReplicatedStorage.SharedModules.EggData);
local CrateData = require(ReplicatedStorage.SharedModules.CrateData);
local SeedPackData = require(ReplicatedStorage.SharedModules.SeedPackData);
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local CamShake = require(ReplicatedStorage.ClientModules.CamShake);
local Assets = ReplicatedStorage.Assets;

local function ResolveRarity(p2, p3) -- Line: 22
    -- upvalues: PetData (copy), EggData (copy), CrateData (copy), SeedPackData (copy), SeedData (copy)
    if p2 == "Pets" then
        local v4 = PetData[p3];

        if type(v4) == "table" then
            return v4.Rarity;
        end;

        return nil;
    end;

    if p2 == "Eggs" then
        local v5 = EggData.GetData(p3);

        return v5 and v5.Rarity or nil;
    end;

    if p2 == "Crates" then
        local v6 = CrateData.GetData(p3);

        return v6 and v6.Rarity or nil;
    end;

    if p2 == "SeedPacks" then
        local v7 = SeedPackData.GetData(p3);

        return v7 and v7.Rarity or nil;
    end;

    for _, v in SeedData do
        if v.SeedName == p3 then
            return v.Rarity;
        end;
    end;

    return nil;
end;

local function ResolveModelSource(p8, p9) -- Line: 45
    -- upvalues: Assets (copy)
    if p8 == "Eggs" then
        local Eggs = Assets:FindFirstChild("Eggs");

        if Eggs then
            Eggs = Eggs:FindFirstChild(p9);
        end;

        return Eggs;
    end;

    if p8 == "Crates" then
        local Crates = Assets:FindFirstChild("Crates");

        if Crates then
            Crates = Crates:FindFirstChild(p9);
        end;

        return Crates;
    end;

    if p8 ~= "SeedPacks" then
        return Assets.Seeds:FindFirstChild(p9);
    end;

    local SeedPacks = Assets:FindFirstChild("SeedPacks");

    if SeedPacks then
        SeedPacks = SeedPacks:FindFirstChild(p9);
    end;

    return SeedPacks;
end;

local RarityData = ReplicatedStorage.SharedModules.RarityData;
local SeedPackEffects = ReplicatedStorage.Assets.SeedPackEffects;

local function CreateSFX(p10, p11, p12) -- Line: 70
    -- upvalues: SoundService (copy)
    local Sound = Instance.new("Sound");
    Sound.SoundId = p11;
    Sound.Volume = 1;
    Sound.RollOffMaxDistance = 200;
    Sound.Looped = p12 == true;
    Sound.SoundGroup = SoundService:FindFirstChild("SFXGroup");
    Sound.Parent = p10;

    return Sound;
end;

local u13 = {};
local u14 = SeedPackEffects.Luck:Clone();
local Attachment = Instance.new("Attachment");
u14.Parent = Attachment;
Attachment.Parent = workspace.Terrain;
local u15 = RaycastParams.new();
u15.FilterDescendantsInstances = {};
u15.FilterType = Enum.RaycastFilterType.Include;

local function raycastClick(p16) -- Line: 96
    -- upvalues: u15 (copy)
    local Position = workspace.CurrentCamera.CFrame.Position;
    local v17 = game.Players.LocalPlayer:GetMouse().Hit.Position - Position;
    u15.FilterDescendantsInstances = { p16 };

    return workspace:Raycast(Position, v17, u15);
end;

function v1.Open(u18, p19, u20, p21, u22, p23, p24, u25, p26, u27, u28) -- Line: 111
    -- upvalues: ReplicatedStorage (copy), u13 (copy), Spring2 (copy), SeedPackEffects (copy), SoundService (copy), Networking (copy), raycastClick (copy), Attachment (copy), u14 (copy), Bezier (copy), ResolveRarity (copy), CamShake (copy), RarityData (copy), ResolveModelSource (copy)
    local u29 = p23 or "Seeds";
    local v30 = ReplicatedStorage.Assets.SeedPacks:FindFirstChild(p19);
    u13[u18] = u20;
    local v31 = v30 or ReplicatedStorage.Assets.SeedPacks.Normal;
    local v32 = CFrame.new(p21, p21 + u22.LookVector * Vector3.new(1, 0, 1));
    local u33 = Spring2.new(Vector3.new(0, 0, 0));
    u33.Speed = 11;
    u33.Damper = 0.85;
    local u34 = v31:Clone();
    u34:PivotTo(v32);
    local v35 = RaycastParams.new();
    v35.FilterType = Enum.RaycastFilterType.Exclude;
    v35.FilterDescendantsInstances = { workspace.Temporary };
    local v36 = workspace:Raycast(u22.Position, Vector3.new(-0, -7, -0), v35);

    if v36 and v36.Position then
        local v37 = Vector3.new(u22.X, v36.Position.Y + 2, u22.Z);
        u22 = CFrame.new(v37, v37 + u22.LookVector * Vector3.new(1, 0, 1));
    end;

    local u38;

    if SeedPackEffects:FindFirstChild(p19) then
        u38 = SeedPackEffects:FindFirstChild(p19):Clone();
    else
        u38 = SeedPackEffects.Attachment:Clone();
    end;

    u38.Parent = u34.PrimaryPart or u34.Handle;
    local v39 = u34:GetAttribute("Color");

    for _, descendant in u38:GetDescendants() do
        if descendant:HasTag("ColorPart") then
            descendant.Color = ColorSequence.new(v39);
        end;
    end;

    local v40 = u34.PrimaryPart or u34:FindFirstChild("Handle");
    local Sound = Instance.new("Sound");
    Sound.SoundId = "rbxassetid://73484699086664";
    Sound.Volume = 1;
    Sound.RollOffMaxDistance = 200;
    Sound.Looped = false;
    Sound.SoundGroup = SoundService:FindFirstChild("SFXGroup");
    Sound.Parent = v40;
    local Sound2 = Instance.new("Sound");
    Sound2.SoundId = "rbxassetid://121908287846654";
    Sound2.Volume = 1;
    Sound2.RollOffMaxDistance = 200;
    Sound2.Looped = false;
    Sound2.SoundGroup = SoundService:FindFirstChild("SFXGroup");
    Sound2.Parent = v40;
    local Sound3 = Instance.new("Sound");
    Sound3.SoundId = "rbxassetid://100648776972641";
    Sound3.Volume = 1;
    Sound3.RollOffMaxDistance = 200;
    Sound3.Looped = true;
    Sound3.SoundGroup = SoundService:FindFirstChild("SFXGroup");
    Sound3.Parent = v40;
    local Sound4 = Instance.new("Sound");
    Sound4.SoundId = "rbxassetid://100636385506315";
    Sound4.Volume = 1;
    Sound4.RollOffMaxDistance = 200;
    Sound4.Looped = false;
    Sound4.SoundGroup = SoundService:FindFirstChild("SFXGroup");
    Sound4.Parent = v40;
    local u41 = false;
    local Part = Instance.new("Part");
    Part.CanCollide = false;
    Part.CanQuery = true;
    Part.CanTouch = false;
    Part.Anchored = true;
    local u42 = u34:GetExtentsSize() * 1.25;
    Part.Transparency = 1;
    Part.Size = u42;
    Part.CFrame = u22;
    Part.Parent = workspace.Temporary;
    game.Debris:AddItem(Part, 4.8);

    if not p26 then
        local u43 = script.ClickDetector:Clone();
        u43.Parent = Part;
        local u46 = u43.MouseClick:Connect(function() -- Line: 195
            -- upvalues: u41 (ref), Networking (ref), u18 (copy), raycastClick (ref), Part (copy), Attachment (ref), u14 (ref)
            if not u41 then
                Networking.SeedPack.ClickPack:Fire(u18);
            end;

            u41 = true;
            task.delay(0.1, function() -- Line: 201
                -- upvalues: u41 (ref)
                u41 = false;
            end);
            local v44 = raycastClick(Part);
            local v45 = v44 and v44.Position or game.Players.LocalPlayer:GetMouse().Hit.Position;

            if v44 then
                Attachment.WorldCFrame = CFrame.new(v45);
                u14:Emit(16);
            end;
        end);
        task.delay(3.8, function() -- Line: 216
            -- upvalues: u46 (ref), u43 (copy)
            u46:Disconnect();
            u43:Destroy();
        end);
    end;

    local v47 = Bezier.new(v32.Position, (v32.Position + u22.Position) / 2 + Vector3.new(0, 16, 0), u22.Position);

    for _, descendant in u34:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanQuery = true;

            if u28 then
                descendant.CanCollide = false;
                descendant.CanTouch = false;
            end;
        end;
    end;

    u34.Parent = workspace.Temporary;
    Sound:Play();
    local v48 = 0;

    while v48 < 0.3 do
        v48 = v48 + game:GetService("RunService").Heartbeat:Wait();
        local v49 = v47:CalculatePositionAt((game:GetService("TweenService"):GetValue(v48 / 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)));
        u34:PivotTo(CFrame.new(v49, v49 + u22.LookVector));
    end;

    Sound2:Play();
    local v50 = 0;

    while v50 < 0.5 do
        v50 = v50 + game:GetService("RunService").Heartbeat:Wait();
        local v51 = 1 - v50 / 0.5;
        local v52 = math.rad(v51 * 1440) - 1.5707963267948966;
        local v53 = (math.sin(v52) + 1) / 2 * v51;
        u34:PivotTo(u22 * CFrame.new(0, v53 * 0.5, 0));
    end;

    Sound3:Play();
    local u54 = nil;
    local u55 = 0;
    local u56 = true;
    task.spawn(function() -- Line: 275
        -- upvalues: u38 (ref), u56 (ref), u55 (ref), u54 (ref), u34 (ref), u33 (copy), u22 (ref)
        u38.Trail.Trail.Enabled = false;
        local v57 = 0;

        while u56 do
            local v58 = game:GetService("RunService").Heartbeat:Wait();
            v57 = v57 + v58;
            local v59 = CFrame.Angles(0, 0, 0);

            if u55 > 0 then
                u55 = math.max(u55 - v58, 0);
                v59 = u54();
            end;

            local v60 = math.clamp(v57, 0, 1);
            local v61 = tick();
            local v62 = math.rad(v61 * 3);
            local v63 = math.cos(v62) * 0.3;
            local v64 = math.sin(v61 * 2.2) * 0.4;
            local v65 = math.rad(v61 * 1.6);
            local v66 = math.cos(v65) * 0.1;
            local v67 = Vector3.new(v63, v64, v66);
            u33.Target = u34:GetPivot():VectorToObjectSpace(v67);
            u33:Update(v58);
            local v68 = u22 * CFrame.new((Vector3.new(0, 0, 0)):Lerp(u33.Position, v60));
            local v69 = CFrame.new();
            local Angles = CFrame.Angles;
            local v70 = tick() * 2;
            local v71 = math.cos(v70) * 0.06;
            local v72 = tick() * 1.5;
            local v73 = math.sin(v72) * 0.1;
            local v74 = tick() * 2;
            u34:PivotTo(v68 * v69:Lerp(Angles(v71, v73, math.sin(v74) * 0.1), v60) * v59);
        end;
    end);
    task.wait(0.4);

    u54 = function() -- Line: 315
        -- upvalues: u55 (ref)
        local v75 = tick() * 90;
        local v76 = (1 - u55 / 0.9) * math.sin(v75);

        return CFrame.Angles(0, 0, (math.rad(v76 * 2)));
    end;

    u55 = 0.9;
    task.wait(1.4);

    u54 = function() -- Line: 325
        -- upvalues: u55 (ref)
        local v77 = tick() * 90;
        local v78 = (1 - u55 / 0.9) * math.sin(v77);

        return CFrame.Angles(0, 0, (math.rad(v78 * 4)));
    end;

    u55 = 0.9;
    task.wait(1.4);

    u54 = function() -- Line: 339
        -- upvalues: u55 (ref)
        local v79 = tick() * 90;
        local v80 = (1 - u55 / 0.8) * math.sin(v79);

        return CFrame.Angles(0, 0, (math.rad(v80 * 6)));
    end;

    u55 = 0.8;
    task.wait(0.8);
    local v81 = ResolveRarity(u29, u20);

    if v81 and table.find({ "Legendary", "Mythic" }, v81) then
        local Sound5 = Instance.new("Sound");
        Sound5.SoundId = "rbxassetid://82591599137987";
        Sound5.Volume = 1;
        Sound5.RollOffMaxDistance = 200;
        Sound5.Looped = false;
        Sound5.SoundGroup = SoundService:FindFirstChild("SFXGroup");
        Sound5.Parent = v40;
        Sound5:Play();
        task.wait(0.8);
        local u82 = SeedPackEffects.Highlight:Clone();
        u82.FillTransparency = 1;
        u82.OutlineTransparency = 1;
        u82.Parent = u34;
        u82.Enabled = true;
        local v83 = 1 - ((game.Workspace.CurrentCamera.CFrame.Position - u34:GetPivot().p).Magnitude + 20) / 90;
        CamShake:StartShake(2 * v83, 14 * v83, 12, Vector3.new(0.2, 0.2, 0));

        u54 = function() -- Line: 376
            -- upvalues: u55 (ref), u82 (copy), u34 (ref)
            local v84 = 1 - u55 / 3;
            u82.FillTransparency = 1 - v84;
            u82.OutlineTransparency = 1 - v84;
            u34:ScaleTo(v84 * 3 + 1);
            local v85 = Random.new():NextUnitVector() * v84;
            local v86 = u34:GetExtentsSize().Y / 2 * 0.1;
            local v87 = tick() * 90;
            local v88 = v84 * math.sin(v87);

            return CFrame.new(v85 * v86) * CFrame.new(0, u34:GetExtentsSize().Y / 2 * v84, 0) * CFrame.Angles(0, 0, (math.rad(v88 * 6)));
        end;

        u55 = 3;
        task.wait(3);

        for _, child in u38.BigEmit:GetChildren() do
            child:Emit(child:GetAttribute("EmitCount"));
        end;

        CamShake:StopSustained(0.5);
    else
        for _, child in u38.Emit:GetChildren() do
            child:Emit(child:GetAttribute("EmitCount"));
        end;
    end;

    Sound3:Stop();
    Sound4:Play();

    for _, descendant in u34:GetDescendants() do
        if descendant:IsA("BasePart") or descendant:IsA("Decal") then
            descendant.Transparency = 1;
        elseif descendant:IsA("SurfaceGui") then
            descendant.Enabled = false;
        end;
    end;

    for _, child in u38.Aura:GetChildren() do
        child.Enabled = false;
    end;

    task.spawn(function() -- Line: 429
        -- upvalues: u20 (ref), u13 (ref), u18 (copy), u56 (ref), ResolveRarity (ref), u29 (ref), RarityData (ref), ReplicatedStorage (ref), u22 (ref), u28 (copy), u42 (copy), u25 (copy), u27 (copy), ResolveModelSource (ref), SeedPackEffects (ref)
        u20 = u13[u18];
        u13[u18] = nil;
        u56 = false;
        local u89 = ResolveRarity(u29, u20);
        local u90;

        if u89 then
            u90 = RarityData.Gradients:FindFirstChild(u89);
        else
            u90 = nil;
        end;

        local function SpawnBillboard(p91) -- Line: 442
            -- upvalues: ReplicatedStorage (ref), u22 (ref), u28 (ref), u20 (ref), u89 (copy), u90 (copy)
            local v92 = p91 or 1.5;
            local u93 = ReplicatedStorage.Assets.SeedNameAttachment:Clone();
            u93.Position = u22.Position + Vector3.new(0, v92, 0);

            if u28 and u93:IsA("BasePart") then
                u93.CanCollide = false;
                u93.CanTouch = false;
                u93.CanQuery = false;
            end;

            u93.BillboardGui.Rarity_Name.UIScale.Scale = 0;
            u93.BillboardGui.Seed_Name.UIScale.Scale = 0;
            u93.Parent = workspace.Temporary;
            game.TweenService:Create(u93, TweenInfo.new(3), {
                Position = u22.Position + Vector3.new(0, v92 + 1.5, 0)
            }):Play();
            u93.BillboardGui.Seed_Name.TextLabel.Text = u20;
            u93.BillboardGui.Seed_Name.Text = u20;
            game.TweenService:Create(u93.BillboardGui.Seed_Name.UIScale, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {
                Scale = 1
            }):Play();
            task.delay(0.15, function() -- Line: 463
                -- upvalues: u93 (copy)
                game.TweenService:Create(u93.BillboardGui.Rarity_Name.UIScale, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {
                    Scale = 1
                }):Play();
            end);

            if u89 then
                u93.BillboardGui.Rarity_Name.TextLabel.Text = u89;
                u93.BillboardGui.Rarity_Name.Text = u89;

                if u90 then
                    u90:Clone().Parent = u93.BillboardGui.Rarity_Name.TextLabel;
                    u90:Clone().Parent = u93.BillboardGui.Rarity_Name;
                end;
            end;

            return u93;
        end;

        if u29 ~= "Pets" then
            local v94 = ResolveModelSource(u29, u20);

            if v94 then
                local v95 = v94:Clone();
                local u96;

                if v95:IsA("BasePart") then
                    u96 = Instance.new("Model");
                    v95.Parent = u96;
                    u96.PrimaryPart = v95;
                elseif v95.PrimaryPart then
                    u96 = v95;
                else
                    v95.PrimaryPart = v95:FindFirstChildWhichIsA("BasePart", true);
                    u96 = v95;
                end;

                for _, descendant in u96:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.Anchored = true;
                        descendant.CanCollide = false;
                        descendant.CanQuery = false;
                        descendant.CanTouch = false;
                    end;
                end;

                u96:PivotTo(u22);
                u96.Parent = workspace.Temporary;
                local v97;

                if u29 == "Eggs" or (u29 == "Crates" or u29 == "SeedPacks") then
                    local v98, v99 = u96:GetBoundingBox();
                    v97 = v98.Position.Y + v99.Y / 2 - u22.Position.Y + 1;
                else
                    v97 = nil;
                end;

                local u100 = SpawnBillboard(v97);
                task.delay(3, function() -- Line: 535
                    -- upvalues: u100 (copy), u96 (ref)
                    game.TweenService:Create(u100.BillboardGui.Seed_Name.UIScale, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {
                        Scale = 0
                    }):Play();
                    task.delay(0.15, function() -- Line: 538
                        -- upvalues: u100 (ref), u96 (ref)
                        game.TweenService:Create(u100.BillboardGui.Rarity_Name.UIScale, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {
                            Scale = 0
                        }):Play();
                        game.Debris:AddItem(u100, 1);
                        task.wait(0.15);
                        local v101 = 0;

                        while v101 < 1 do
                            v101 = v101 + game:GetService("RunService").Heartbeat:Wait();
                            local v102 = 1 - game.TweenService:GetValue(v101, Enum.EasingStyle.Back, Enum.EasingDirection.InOut);
                            u96:ScaleTo((math.clamp(v102, 0.01, 1)));
                        end;

                        u96:Destroy();
                    end);
                end);
                local u103 = SeedPackEffects.Highlight:Clone();
                u103.Parent = u96;
                u103.Enabled = true;
                task.delay(0.2, function() -- Line: 561
                    -- upvalues: u103 (copy)
                    game.TweenService:Create(u103, TweenInfo.new(0.7), {
                        FillTransparency = 1
                    }):Play();
                    game.Debris:AddItem(u103, 0.3);
                end);
                local v104 = 0;
                local v105 = 0;

                while v104 < 5 do
                    local v106 = game:GetService("RunService").Heartbeat:Wait();
                    v104 = v104 + v106;
                    v105 = v105 + 25.132741228718345 * math.clamp(1 - v104 / 1, 0.1, 1) * v106;
                    local v107 = tick();
                    local v108 = (math.sin(v107) + 1) * 0.5 / 2;
                    u96:PivotTo(u22 * CFrame.Angles(0, v105, 0) * CFrame.new(0, v108, 0));
                end;
            end;

            return;
        end;

        local u109 = SpawnBillboard();
        task.delay(3, function() -- Line: 485
            -- upvalues: u109 (copy)
            game.TweenService:Create(u109.BillboardGui.Seed_Name.UIScale, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {
                Scale = 0
            }):Play();
            task.delay(0.15, function() -- Line: 487
                -- upvalues: u109 (ref)
                game.TweenService:Create(u109.BillboardGui.Rarity_Name.UIScale, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {
                    Scale = 0
                }):Play();
                game.Debris:AddItem(u109, 1);
            end);
        end);
        local EggEffect = require(script.Parent.Parent.EggOpenController.EggEffect);
        local v110;

        if u42 == nil or u42 == "" then
            v110 = nil;
        else
            v110 = u42;
        end;

        local v111;

        if u25 == nil or u25 == "" then
            v111 = nil;
        else
            v111 = u25;
        end;

        EggEffect.PlayReveal(u20, u22.Position, u22.LookVector, u27, v110, v111, true);
    end);
    game.Debris:AddItem(u34, 5);
end;

function v1.UpdateDropData(p112, p113) -- Line: 592
    -- upvalues: u13 (copy)
    if u13[p112] == nil then
        return;
    end;

    u13[p112] = p113;
end;

return v1;