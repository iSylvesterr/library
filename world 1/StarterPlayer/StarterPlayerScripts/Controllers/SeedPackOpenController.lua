-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 6
};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local SeedPackData = require(ReplicatedStorage.SharedModules.SeedPackData);
local SeedData = require(game.ReplicatedStorage.SharedModules.SeedData);
local SeedPackEffect = require(script.SeedPackEffect);
local CollectionService = game:GetService("CollectionService");
local _ = ReplicatedStorage.Assets.SeedPacks;
local Seeds = ReplicatedStorage.Assets.Seeds;
local _ = Players.LocalPlayer;
local _ = SoundService.SFX.Click;
local SeedpackSFX = SoundService.SFX.SeedpackSFX;
local _ = SeedpackSFX.SeedpackReward;
local _ = SeedpackSFX.SeedpackOpen;
local _ = SeedpackSFX.SeedpackSpawn;
local _ = SeedpackSFX.SeedpackCollect;
local SeedNameAttachment = game.ReplicatedStorage.Assets.SeedNameAttachment;
local u2 = {};
local u3 = 0;

local function FindGround(p4) -- Line: 92
    local v5 = RaycastParams.new();
    v5.FilterType = Enum.RaycastFilterType.Include;
    v5.FilterDescendantsInstances = { workspace.Baseplate };
    local v6 = workspace:Raycast(p4 + Vector3.new(0, 10, 0), Vector3.new(0, -25, 0), v5);

    if v6 then
        return v6.Position;
    end;

    return nil;
end;

local function HasPositionConflict(p7) -- Line: 109
    -- upvalues: u2 (copy)
    for _, v in u2 do
        if (p7 - v).Magnitude <= 8 then
            return true;
        end;
    end;

    return false;
end;

local function FindDropPosition(p8) -- Line: 119
    -- upvalues: FindGround (copy), u2 (copy)
    local Character = p8.Character;

    if not Character then
        return nil;
    end;

    if not Character.PrimaryPart then
        return nil;
    end;

    local v9 = Character:GetPivot();
    local Position = v9.Position;
    local _, v10, _ = v9:ToOrientation();

    for i = 7, 30 do
        local v11 = math.floor(6.283185307179586 * i / 8);
        local v12 = math.max(1, v11);
        local v13 = 6.283185307179586 / v12;

        for i2 = 0, v12 - 1 do
            local v14 = v10 + i2 * v13;
            local v15 = i * math.cos(v14);
            local v16 = i * math.sin(v14);
            local v17 = FindGround(Position + Vector3.new(v15, 0, v16));

            if v17 then
                local v18 = false;

                for _, v in u2 do
                    if (v17 - v).Magnitude <= 8 then
                        v18 = true;
                        break;
                    end;
                end;

                if not v18 then
                    return v17;
                end;
            end;
        end;
    end;

    return nil;
end;

local function ExpoInOut(p19) -- Line: 156
    if p19 == 0 then
        return 0;
    end;

    if p19 == 1 then
        return 1;
    end;

    local v20 = p19 * 2;

    if v20 < 1 then
        return math.pow(2, (v20 - 1) * 10) * 0.5 - 0.0005;
    end;

    return (-math.pow(2, (v20 - 1) * -10) + 2) * 0.50025;
end;

local function EaseOutBack(p21) -- Line: 169
    return math.pow(p21 - 1, 3) * 2.70158 + 1 + math.pow(p21 - 1, 2) * 1.70158;
end;

local function Bezier(u22, u23, u24) -- Line: 176
    return function(p25) -- Line: 177
        -- upvalues: u22 (copy), u23 (copy), u24 (copy)
        local v26 = 1 - p25;

        return v26 * v26 * u22 + v26 * 2 * p25 * u23 + p25 * p25 * u24;
    end;
end;

local function AutoControlPoint(p27, p28) -- Line: 183
    local v29 = (p27 + p28) / 2;
    local Magnitude = ((p27 - p28) * Vector3.new(1, 0, 1)).Magnitude;
    local X = v29.X;
    local v30 = math.max(p27.Y, p28.Y) + Magnitude;

    return Vector3.new(X, v30, v29.Z);
end;

local function LookAtFlat(p31, p32) -- Line: 189
    local v33 = Vector3.new(p32.X, p31.Y, p32.Z);

    if (p31.Position - v33).Magnitude < 0.001 then
        return p31;
    end;

    return CFrame.lookAt(p31.Position, v33);
end;

local function SetModelAnchored(p34) -- Line: 199
    for _, descendant in p34:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CastShadow = false;
            descendant.CanQuery = false;
        end;
    end;
end;

local function EnsurePrimaryPart(p35) -- Line: 210
    if p35.PrimaryPart then
        return;
    end;

    local Center = p35:FindFirstChild("Center");

    if Center then
        p35.PrimaryPart = Center;

        return;
    end;

    local v36 = p35:FindFirstChildWhichIsA("BasePart", true);

    if v36 then
        p35.PrimaryPart = v36;
    end;
end;

local function RenderFor(u37, u38) -- Line: 226
    -- upvalues: u3 (ref), RunService (copy)
    u3 = u3 + 1;
    local u39 = ("SeedPackRS_%d"):format(u3);
    local u40 = 0;
    local u41 = false;
    RunService:BindToRenderStep(u39, Enum.RenderPriority.Last.Value, function(p42) -- Line: 233
        -- upvalues: u41 (ref), u40 (ref), u38 (copy), u37 (copy), RunService (ref), u39 (copy)
        if u41 then
            return;
        end;

        u40 = math.min(u40 + p42, u38);

        if u37(p42, (math.clamp(u40 / u38, 0, 1))) or u38 <= u40 then
            u41 = true;
            RunService:UnbindFromRenderStep(u39);
        end;
    end);

    while not u41 do
        task.wait();
    end;
end;

local function CaptureVisuals(p43) -- Line: 251
    local v44 = {};

    for _, descendant in p43:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(v44, {
                Property = "Transparency",
                Instance = descendant,
                Original = descendant.Transparency
            });
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            table.insert(v44, {
                Property = "Transparency",
                Instance = descendant,
                Original = descendant.Transparency
            });
        elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
            table.insert(v44, {
                Property = "ImageTransparency",
                Instance = descendant,
                Original = descendant.ImageTransparency
            });
            table.insert(v44, {
                Property = "BackgroundTransparency",
                Instance = descendant,
                Original = descendant.BackgroundTransparency
            });
        elseif descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            table.insert(v44, {
                Property = "TextTransparency",
                Instance = descendant,
                Original = descendant.TextTransparency
            });
            table.insert(v44, {
                Property = "BackgroundTransparency",
                Instance = descendant,
                Original = descendant.BackgroundTransparency
            });
        elseif descendant:IsA("Frame") then
            table.insert(v44, {
                Property = "BackgroundTransparency",
                Instance = descendant,
                Original = descendant.BackgroundTransparency
            });
        end;
    end;

    return v44;
end;

local function ApplyFade(p45, p46) -- Line: 273
    for _, v in p45 do
        v.Instance[v.Property] = v.Original + (1 - v.Original) * p46;
    end;
end;

local function WhiteWash(p47) -- Line: 280
    -- upvalues: CollectionService (copy)
    for _, descendant in p47:GetDescendants() do
        if descendant:IsA("BasePart") then
            for _, v in CollectionService:GetTags(descendant) do
                CollectionService:RemoveTag(descendant, v);
            end;

            descendant.Color = Color3.new(1, 1, 1);
            descendant.Material = Enum.Material.SmoothPlastic;
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            descendant:Destroy();
        end;
    end;
end;

local function UpdateLabelPosition(p48, p49) -- Line: 296
    p48.CFrame = CFrame.new(p49.Position + Vector3.new(0, 5, 0));
end;

local function ApplyBlackHighlight(p50) -- Line: 301
    local Highlight = Instance.new("Highlight");
    Highlight.FillColor = Color3.new(0, 0, 0);
    Highlight.FillTransparency = 0;
    Highlight.OutlineColor = Color3.new(0, 0, 0);
    Highlight.OutlineTransparency = 1;
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
    Highlight.Parent = p50;

    return Highlight;
end;

local function ApplySemiTransparency(p51, p52) -- Line: 314
    local v53 = {};

    for _, descendant in p51:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(v53, {
                Instance = descendant,
                Original = descendant.Transparency
            });
            descendant.Transparency = descendant.Transparency + (1 - descendant.Transparency) * p52;
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            table.insert(v53, {
                Instance = descendant,
                Original = descendant.Transparency
            });
            descendant.Transparency = descendant.Transparency + (1 - descendant.Transparency) * p52;
        end;
    end;

    return v53;
end;

local function RestoreSemiTransparency(p54) -- Line: 331
    for _, v in p54 do
        if v.Instance and v.Instance.Parent then
            v.Instance.Transparency = v.Original;
        end;
    end;
end;

local function GetAllSeedNames() -- Line: 343
    -- upvalues: Seeds (copy)
    local v55 = {};

    for _, child in Seeds:GetChildren() do
        if child:IsA("Model") or child:IsA("BasePart") then
            table.insert(v55, child.Name);
        end;
    end;

    return v55;
end;

local function BuildSlotSequence(p56, p57, p58) -- Line: 353
    -- upvalues: SeedPackData (copy), SeedData (copy)
    local v59 = {};
    local v60 = SeedPackData.GetData(p58);
    local v61 = {};

    if v60 and v60.Seeds then
        for _, v in v60.Seeds do
            if not table.find(v61, v.SeedName) then
                table.insert(v61, v.SeedName);
            end;
        end;
    elseif v60 and v60.CustomProgressBased then
        for _, v in SeedData do
            if v.RestockShop and not table.find(v61, v.SeedName) then
                table.insert(v61, v.SeedName);
            end;
        end;
    end;

    if #v61 == 0 then
        for _ = 1, p57 do
            table.insert(v59, p56);
        end;

        return v59;
    end;

    local u62 = {};

    for _, v in v61 do
        local v63 = nil;

        for _, v2 in SeedData do
            if v2.SeedName == v then
                v63 = v2;
                break;
            end;
        end;

        table.insert(u62, {
            Name = v,
            Price = v63 and v63.PurchasePrice or 0
        });
    end;

    table.sort(u62, function(p64, p65) -- Line: 394
        return p64.Price < p65.Price;
    end);
    local v66 = 1;

    for i, v in ipairs(u62) do
        if v.Name == p56 then
            v66 = i;
            break;
        end;
    end;

    local u67 = {};
    local v68 = v66 - 1;

    if v68 >= 1 then
        table.insert(u67, {
            Weight = 60,
            Index = v68
        });
    end;

    table.insert(u67, {
        Weight = 20,
        Index = v66
    });
    local v69 = v66 + 1;
    local v70 = 10;

    while v69 <= #u62 and v70 >= 0.1 do
        table.insert(u67, {
            Index = v69,
            Weight = v70
        });
        v70 = v70 / 2;
        v69 = v69 + 1;
    end;

    local u71 = 0;

    for _, v in u67 do
        u71 = u71 + v.Weight;
    end;

    local function PickFromPool(p72) -- Line: 426
        -- upvalues: u71 (ref), u67 (copy), u62 (copy)
        for _ = 1, 20 do
            local v73 = math.random() * u71;
            local v74 = 0;

            for _, v in ipairs(u67) do
                v74 = v74 + v.Weight;

                if v73 <= v74 then
                    local Name = u62[v.Index].Name;

                    if Name ~= p72 then
                        return Name;
                    end;

                    break;
                end;
            end;
        end;

        for _, v in ipairs(u67) do
            if u62[v.Index].Name ~= p72 then
                return u62[v.Index].Name;
            end;
        end;

        return u62[u67[1].Index].Name;
    end;

    for i = 1, p57 - 2 do
        local v75;

        if i > 1 then
            v75 = v59[i - 1] or nil;
        else
            v75 = nil;
        end;

        local v76 = PickFromPool(v75);
        table.insert(v59, v76);
    end;

    local v77 = false;

    if math.random(1, 5) == 1 then
        local v78 = math.min(v66 + 3, #u62);

        if v66 < v78 then
            local v79;

            if #v59 > 0 then
                v79 = v59[#v59] or nil;
            else
                v79 = nil;
            end;

            local Name = u62[v78].Name;

            if Name == v79 and v78 < #u62 then
                Name = u62[v78 + 1].Name;
            elseif Name == v79 and v66 + 1 < v78 then
                Name = u62[v78 - 1].Name;
            end;

            table.insert(v59, Name);
            v77 = true;
        end;
    end;

    if not v77 then
        local v80;

        if #v59 > 0 then
            v80 = v59[#v59] or nil;
        else
            v80 = nil;
        end;

        local v81 = PickFromPool(v80);
        table.insert(v59, v81);
    end;

    table.insert(v59, p56);

    return v59;
end;

local function GetSlotInterval(p82, p83) -- Line: 480
    local v84 = p82 / p83;

    return v84 * v84 * 0.6 + 0.1;
end;

local RarityData = game.ReplicatedStorage.SharedModules.RarityData;

local function PrepareSeedModel(p85) -- Line: 488
    -- upvalues: Seeds (copy), SetModelAnchored (copy), SeedNameAttachment (copy), SeedData (copy), RarityData (copy)
    local v86 = Seeds:FindFirstChild(p85);

    if not v86 then
        return nil, nil, nil;
    end;

    local v87 = v86:Clone();
    local v88;

    if v87:IsA("BasePart") then
        v88 = Instance.new("Model");
        v88.Name = p85;
        v87.Parent = v88;
        v88.PrimaryPart = v87;
    else
        v88 = v87;
    end;

    if not v88.PrimaryPart then
        local Center = v88:FindFirstChild("Center");

        if Center then
            v88.PrimaryPart = Center;
        else
            local v89 = v88:FindFirstChildWhichIsA("BasePart", true);

            if v89 then
                v88.PrimaryPart = v89;
            end;
        end;
    end;

    SetModelAnchored(v88);
    local v90 = SeedNameAttachment:Clone();
    v90.Parent = game.Workspace.Temporary;
    local v91 = nil;

    for _, v in pairs(SeedData) do
        if v.SeedName == p85 then
            v91 = v;
        end;
    end;

    local v92;

    if v91 then
        local Rarity = v91.Rarity;
        v92 = RarityData.Gradients:FindFirstChild(Rarity);
        v90.BillboardGui.Rarity_Name.TextLabel.Text = Rarity;
        v90.BillboardGui.Rarity_Name.Text = Rarity;

        if v92 then
            v92:Clone().Parent = v90.BillboardGui.Rarity_Name.TextLabel;
            v92:Clone().Parent = v90.BillboardGui.Rarity_Name;
        end;
    else
        v92 = nil;
    end;

    v90.BillboardGui.Seed_Name.TextLabel.Text = p85;
    v90.BillboardGui.Seed_Name.Text = p85;

    return v88, v90, v92;
end;

function v1.Init(p93) -- Line: 540
end;

function v1.Start(p94) -- Line: 543
    -- upvalues: Networking (copy), SeedPackEffect (copy), Players (copy)
    Networking.SeedPack.ReplicateOpenSeedPack.OnClientEvent:Connect(function(u95, u96, u97, u98, p99) -- Line: 544
        -- upvalues: SeedPackEffect (ref), Players (ref), Networking (ref)
        if not (u95 and u95.Character) then
            return;
        end;

        local Position = u95.Character.HumanoidRootPart.Position;
        local u100 = CFrame.new(p99, p99 + CFrame.new(p99, Position).LookVector);
        task.spawn(function() -- Line: 551
            -- upvalues: SeedPackEffect (ref), u96 (copy), u97 (copy), u98 (copy), Position (copy), u100 (copy), u95 (copy), Players (ref), Networking (ref)
            SeedPackEffect.Open(u96, u97, u98, Position, u100);

            if u95 == Players.LocalPlayer then
                Networking.SeedPack.ConfirmSeedPack:Fire(u96, u97, u98);
            end;
        end);
    end);
    Networking.SeedPack.ConfirmSeedPack.OnClientEvent:Connect(function(p101, p102) -- Line: 564
        -- upvalues: SeedPackEffect (ref)
        SeedPackEffect.UpdateDropData(p101, p102);
    end);
end;

function v1.ReturnRandomItem(p103, p104) -- Line: 569
    local v105 = 0;

    for _, v in pairs(p104) do
        v105 = v105 + v.Chance;
    end;

    local v106 = math.random() * v105;
    local v107 = 0;

    for _, v in pairs(p104) do
        v107 = v107 + v.Chance;

        if v106 <= v107 then
            return v;
        end;
    end;

    return p104[#p104];
end;

function v1.PlaySFXLocation(p108, p109, p110) -- Line: 587
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.Size = Vector3.new(1, 1, 1);
    Part.Parent = game.Workspace.Temporary;
    Part.Transparency = 1;
    Part.Position = p110;
    local v111 = p109:Clone();
    v111.Parent = Part;
    v111.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
    v111.Playing = true;
    game.Debris:AddItem(Part, v111.TimeLength * v111.PlaybackSpeed);
end;

function v1.Roll(p112, p113, p114) -- Line: 1024
    return p114 or p112:ReturnRandomItem(p113);
end;

return v1;