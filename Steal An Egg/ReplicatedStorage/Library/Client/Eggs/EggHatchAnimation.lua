-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Assets = require(ReplicatedStorage.Directory.Assets);
local Audio = require(ReplicatedStorage.Library.Audio);
local BBFromModelVisibleOnly = require(ReplicatedStorage.Library.Functions.BBFromModelVisibleOnly);
local Bezier = require(ReplicatedStorage.Library.Functions.Bezier);
local Easing = require(ReplicatedStorage.Library.Functions.Easing);
local EggActionMovement = require(script.Parent.EggActionMovement);
local EggRenderer = require(script.Parent.EggRenderer);
local Eggs = require(ReplicatedStorage.Library.Types.Eggs);
local EmitDescendants = require(ReplicatedStorage.Library.Functions.EmitDescendants);
require(ReplicatedStorage.Library.Types.AssetItem);
local ItemDisplay = require(ReplicatedStorage.Library.Modules.ItemDisplay);
local Player = require(ReplicatedStorage.Library.Player);
local RenderStepped = require(ReplicatedStorage.Library.Functions.RenderStepped);
local Transparency = require(ReplicatedStorage.Library.Functions.Transparency);
local CollisionGroups = require(ReplicatedStorage.Library.Types.CollisionGroups);
local u1 = Color3.fromRGB(248, 248, 248);
local Assets2 = ReplicatedStorage.Assets;
local __DEBRIS = Workspace.__DEBRIS;
local PlacedEggOpen = Assets2.Particles["Egg Open"].PlacedEggOpen;
local EggExplode = PlacedEggOpen.EggExplode;
local Trail = PlacedEggOpen.Trail;
local EggPoof = Assets2.EggPoof;
local v2 = __DEBRIS:IsA("Folder");
assert(v2, "Workspace.__DEBRIS must be a Folder");
local v3 = EggExplode:IsA("Model");
assert(v3, "PlacedEggOpen.EggExplode must be a Model");
local v4 = Trail:IsA("Trail");
assert(v4, "PlacedEggOpen.Trail must be a Trail");
local v5 = EggPoof:IsA("BasePart");
assert(v5, "Assets.EggPoof must be a BasePart");

for _, descendant in EggExplode:GetDescendants() do
    if descendant:IsA("BasePart") then
        descendant.CollisionGroup = CollisionGroups.PLAYER_COLLISION_GROUP;
    end;
end;

local v6 = {};

local function buildAssetItemData(p7, p8) -- Line: 88
    return {
        HasBeenFirstPlaced = false,
        Category = p7.AssetCategory,
        Scale = p8 or p7.AssetScale,
        EyeColor = p7.AssetEyeColor,
        ColorSeed = p7.AssetColorSeed,
        ColorIndex = p7.AssetColorIndex,
        Mutations = p7.Mutations or {},
        BaseMutation = p7.BaseMutation
    };
end;

local function playPoofSound() -- Line: 101
    -- upvalues: Audio (copy)
    Audio.Play("rbxassetid://102267539121951", script, nil, 1);
end;

local function playAssetRevealSound(p9, p10) -- Line: 105
    -- upvalues: Assets (copy), Audio (copy)
    local RandomIdleSound = Assets.Directory[p9.AssetCategory].RandomIdleSound;

    if RandomIdleSound == nil then
        return nil;
    end;

    return Audio.PlayFromSoundFile(RandomIdleSound, p10);
end;

local function autoControlPoint(p11, p12) -- Line: 114
    local v13 = (p11 + p12) / 2;
    local Magnitude = ((p11 - p12) * Vector3.new(1, 0, 1)).Magnitude;
    local v14 = math.max(p11.Y, p12.Y) + Magnitude * 0.5;

    return Vector3.new(v13.X, v14, v13.Z);
end;

local function getPlayerBodyPosition(p15, p16) -- Line: 122
    -- upvalues: Player (copy)
    local v17 = Player.Optional.PrimaryPart(p15);

    if v17 then
        return v17:GetPivot().Position;
    end;

    return p16;
end;

local function getBottomCFrameFacingPlayer(p18, p19, p20) -- Line: 127
    -- upvalues: Players (copy), Player (copy)
    local v21 = Players:GetPlayerByUserId(p18);

    if v21 == nil then
        return CFrame.new(p19) * p20;
    end;

    local v22 = Player.Optional.PrimaryPart(v21);
    local v23;

    if v22 then
        v23 = v22:GetPivot().Position;
    else
        v23 = p19;
    end;

    local v24 = Vector3.new(v23.X, p19.Y, v23.Z);

    if (p19 - v24).Magnitude < 0.001 then
        return CFrame.new(p19) * p20;
    end;

    return CFrame.lookAt(p19, v24);
end;

local function shakeEggPass(p25, p26, p27) -- Line: 146
    -- upvalues: RunService (copy), EggActionMovement (copy)
    local v28 = 0;

    while v28 < 0.5 do
        v28 = v28 + RunService.Heartbeat:Wait();
        local v29 = tick() * 90;
        local v30 = (1 - v28 / 0.5) * math.sin(v29) * p27;
        EggActionMovement.SetPivot(p25, p26 * CFrame.Angles(0, 0, (math.rad(v30))));
    end;
end;

local function shakeEgg(p31, p32) -- Line: 155
    -- upvalues: shakeEggPass (copy)
    shakeEggPass(p31, p32, 7);
    task.wait(0.3);
    shakeEggPass(p31, p32, 9);
    task.wait(0.3);
    shakeEggPass(p31, p32, 13);
end;

local function pivotAssetToEggBottom(p33, p34) -- Line: 163
    -- upvalues: BBFromModelVisibleOnly (copy)
    local v35 = p33:GetPivot();
    local v36, v37 = BBFromModelVisibleOnly(p33);
    local v38 = p34 - p34.Position;
    p33:PivotTo(CFrame.new(p34.Position - (v36.Position - Vector3.new(0, 1, 0) * (v37.Y * 0.5) - v35.Position)) * v38);
end;

local function growAsset(u39, u40, u41) -- Line: 174
    -- upvalues: RenderStepped (copy), Easing (copy), pivotAssetToEggBottom (copy)
    local u42 = u41 * 0.5;
    RenderStepped(function(p43, p44) -- Line: 176
        -- upvalues: u39 (copy), Easing (ref), u42 (copy), u41 (copy), pivotAssetToEggBottom (ref), u40 (copy)
        if u39.Parent == nil then
            return true;
        end;

        local v45 = Easing(p44, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out);
        u39:ScaleTo(u42 + (u41 - u42) * v45);
        pivotAssetToEggBottom(u39, u40);
    end, 1.3, true):Wait();

    if u39.Parent ~= nil then
        u39:ScaleTo(u41);
        pivotAssetToEggBottom(u39, u40);
    end;
end;

local function lookAtPlayer(u46, u47) -- Line: 194
    -- upvalues: RenderStepped (copy), Player (copy), Easing (copy)
    local u48 = u46:GetPivot();
    RenderStepped(function(p49, p50) -- Line: 196
        -- upvalues: u46 (copy), u48 (copy), u47 (copy), Player (ref), Easing (ref)
        if u46.Parent == nil then
            return true;
        end;

        local v51 = math.sin(6.283185307179586 * p50 * 0.5) * 1;
        local v52 = u48 + Vector3.new(0, v51, 0);
        local Position = u48.Position;
        local v53 = Player.Optional.PrimaryPart(u47);

        if v53 then
            Position = v53:GetPivot().Position;
        end;

        local v54 = Vector3.new(Position.X, v52.Y, Position.Z);
        local v55;

        if (v52.Position - v54).Magnitude < 0.001 then
            v55 = v52;
        else
            v55 = CFrame.lookAt(v52.Position, v54);
        end;

        u46:PivotTo(v52:Lerp(v55, (Easing(p50, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))));
    end, 3, true):Wait();
end;

local function flyAssetIntoPlayer(u56, u57) -- Line: 215
    -- upvalues: Transparency (copy), RenderStepped (copy), Player (copy), Bezier (copy), Easing (copy)
    local u58 = u56:GetScale();
    local u59 = u56:GetPivot();
    local u60 = Transparency();
    task.spawn(function() -- Line: 221
        -- upvalues: RenderStepped (ref), u56 (copy), u57 (copy), u59 (copy), Player (ref), Bezier (ref), Easing (ref), u60 (copy), u58 (copy)
        RenderStepped(function(p61, p62) -- Line: 222
            -- upvalues: u56 (ref), u57 (ref), u59 (ref), Player (ref), Bezier (ref), Easing (ref), u60 (ref), u58 (ref)
            if u56.Parent == nil then
                return true;
            end;

            local Position = u59.Position;
            local v63 = Player.Optional.PrimaryPart(u57);

            if v63 then
                Position = v63:GetPivot().Position;
            end;

            local Position2 = u59.Position;
            local Position3 = u59.Position;
            local v64 = (Position3 + Position) / 2;
            local Magnitude = ((Position3 - Position) * Vector3.new(1, 0, 1)).Magnitude;
            local v65 = math.max(Position3.Y, Position.Y) + Magnitude * 0.5;
            local v66 = Bezier(Position2, Vector3.new(v64.X, v65, v64.Z), Position);
            local v67 = CFrame.new(v66(p62)) * u59.Rotation;
            local v68 = Vector3.new(Position.X, v67.Y, Position.Z);

            if (v67.Position - v68).Magnitude >= 0.001 then
                v67 = CFrame.lookAt(v67.Position, v68);
            end;

            local v69 = Easing(math.clamp((p62 - 0.6) / 0.4, 0, 1), Enum.EasingStyle.Exponential, Enum.EasingDirection.In);
            u60(u56, 1, v69);
            u56:ScaleTo((math.max(0.001, u58 * (1 - v69))));
            u56:PivotTo(v67);
        end, 0.7, true):Wait();

        if u56.Parent ~= nil then
            u60(u56, 1, 1);
            u56:ScaleTo(0.001);
            u56:Destroy();
        end;
    end);
    task.wait(0.3);
end;

local function playAssetClaimSequence(p70, u71) -- Line: 253
    -- upvalues: Players (copy), RenderStepped (copy), Player (copy), Easing (copy), flyAssetIntoPlayer (copy)
    local u72 = Players:GetPlayerByUserId(p70);

    if u72 == nil then
        u71:Destroy();

        return;
    end;

    local u73 = u71:GetPivot();
    RenderStepped(function(p74, p75) -- Line: 196
        -- upvalues: u71 (copy), u73 (copy), u72 (copy), Player (ref), Easing (ref)
        if u71.Parent == nil then
            return true;
        end;

        local v76 = math.sin(6.283185307179586 * p75 * 0.5) * 1;
        local v77 = u73 + Vector3.new(0, v76, 0);
        local Position = u73.Position;
        local v78 = Player.Optional.PrimaryPart(u72);

        if v78 then
            Position = v78:GetPivot().Position;
        end;

        local v79 = Vector3.new(Position.X, v77.Y, Position.Z);
        local v80;

        if (v77.Position - v79).Magnitude < 0.001 then
            v80 = v77;
        else
            v80 = CFrame.lookAt(v77.Position, v79);
        end;

        u71:PivotTo(v77:Lerp(v80, (Easing(p75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))));
    end, 3, true):Wait();
    flyAssetIntoPlayer(u71, u72);
end;

local function revealAsset(p81, p82, u83, u84) -- Line: 264
    -- upvalues: ItemDisplay (copy), buildAssetItemData (copy), __DEBRIS (copy), Asserts (copy), BBFromModelVisibleOnly (copy), pivotAssetToEggBottom (copy), growAsset (copy), TweenService (copy)
    local u85 = ItemDisplay.CreateActiveModel(p82, buildAssetItemData(u83, 1), true, true);
    u85.Name = `{p81}_{p82}`;
    u85.Parent = __DEBRIS;
    local PrimaryPart = u85.PrimaryPart;
    Asserts.BasePart(PrimaryPart);
    PrimaryPart.Anchored = true;
    local Highlight = Instance.new("Highlight");
    Highlight.FillColor = Color3.new(1, 1, 1);
    Highlight.FillTransparency = 0;
    Highlight.OutlineTransparency = 1;
    Highlight.Adornee = u85;
    Highlight.Parent = u85;
    u85:ScaleTo(u83.AssetScale * 0.5);
    local v86, v87 = BBFromModelVisibleOnly(u85);
    PrimaryPart.PivotOffset = CFrame.new(0, v86.Position.Y - v87.Y * 0.5 - PrimaryPart.CFrame.Position.Y, 0);
    pivotAssetToEggBottom(u85, u84);
    task.spawn(function() -- Line: 285
        -- upvalues: growAsset (ref), u85 (copy), u84 (copy), u83 (copy)
        growAsset(u85, u84, u83.AssetScale);
    end);

    for _, descendant in ipairs(u85:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanQuery = false;
        end;
    end;

    TweenService:Create(Highlight, TweenInfo.new(0.5), {
        FillTransparency = 1
    }):Play();

    return u85;
end;

function v6.Play(p88, p89, p90, p91) -- Line: 307
    -- upvalues: Asserts (copy), Eggs (copy), EggRenderer (copy), EggExplode (copy), __DEBRIS (copy), Debris (copy), ReplicatedStorage (copy), BBFromModelVisibleOnly (copy), getBottomCFrameFacingPlayer (copy), shakeEgg (copy), u1 (copy), revealAsset (copy), Assets (copy), Audio (copy), Trail (copy), TweenService (copy), EmitDescendants (copy), EggPoof (copy), Players (copy), RenderStepped (copy), Player (copy), Easing (copy), flyAssetIntoPlayer (copy)
    Asserts.number(p88);
    Asserts.string(p89);
    local v92 = Eggs.SchemaValidation.SavedEgg(p90);
    assert(v92, "Invalid saved egg record");
    Asserts.Model(p91);
    EggRenderer.DisableCollisions(p91);
    local u93 = EggExplode:Clone();
    u93:ScaleTo(p91:GetScale() / 3);
    u93:PivotTo(p91:GetPivot());
    local Core = u93.Core;
    local v94 = Core:IsA("BasePart");
    assert(v94, "Egg explosion Core must be a BasePart");
    Core.Parent = __DEBRIS;
    Debris:AddItem(Core, 60);
    u93.Parent = ReplicatedStorage;
    task.wait(0.4);
    local v95 = p91:GetPivot();
    local v96, v97 = BBFromModelVisibleOnly(p91);
    local v98 = getBottomCFrameFacingPlayer(p88, v96.Position - Vector3.new(0, 1, 0) * (v97.Y * 0.5) + Vector3.new(0, 0.2, 0), v95 - v95.Position);
    shakeEgg(p91, v95);
    local v99 = 0;
    local v100 = 0;
    local v101 = 0;
    local v102 = 0;
    local v103 = 0;

    for _, descendant in ipairs(p91:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            local Color = descendant.Color;
            v99 = v99 + Color.R;
            v100 = v100 + Color.G;
            v101 = v101 + Color.B;
            v102 = v102 + 1;

            if descendant.Transparency > 0.3 then
                v103 = descendant.Transparency;
            end;
        end;
    end;

    local v104;

    if v102 > 0 then
        v104 = Color3.new(v99 / v102, v100 / v102, v101 / v102);
    else
        v104 = u1;
    end;

    local PrimaryPart = p91.PrimaryPart;
    Asserts.BasePart(PrimaryPart);
    local v105 = {
        Color = v104,
        Material = PrimaryPart.Material,
        MaterialVariant = PrimaryPart.MaterialVariant,
        Transparency = PrimaryPart.Transparency
    };
    p91:Destroy();
    u93.Parent = __DEBRIS;

    for _, descendant in ipairs(u93:GetDescendants()) do
        if descendant ~= Core and (descendant.Name ~= "RootPart" and descendant:IsA("BasePart")) then
            descendant.Anchored = false;
        end;
    end;

    local u106 = revealAsset(p88, p89, p90, v98);
    local RandomIdleSound = Assets.Directory[p90.AssetCategory].RandomIdleSound;
    local v107;

    if RandomIdleSound == nil then
        v107 = nil;
    else
        v107 = Audio.PlayFromSoundFile(RandomIdleSound, v98);
    end;

    for _, child in ipairs(u93:GetChildren()) do
        if not child:IsA("BasePart") then
            local v108 = child:IsA("Model");
            local v109 = `Explosion child {child:GetFullName()} must be a Model`;
            assert(v108, v109);
            local PrimaryPart2 = child.PrimaryPart;
            Asserts.BasePart(PrimaryPart2);
            local v110, v111 = child:GetBoundingBox();
            local Part = Instance.new("Part");
            Part.Transparency = 1;
            Part.CanCollide = false;
            Part.CanQuery = false;
            Part.CanTouch = false;
            Part.CFrame = v110;
            Part.Size = v111;
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = Part;
            WeldConstraint.Part1 = PrimaryPart2;
            WeldConstraint.Parent = Part;
            Part.Parent = child;
            local Attachment = Instance.new("Attachment");
            local Attachment2 = Instance.new("Attachment");
            Attachment.Parent = Part;
            Attachment2.Parent = Part;
            Attachment.Position = Vector3.new(0, v111.Y / 2, 0);
            Attachment2.Position = Vector3.new(0, -v111.Y / 2, 0);
            local v112 = Trail:Clone();
            v112.Attachment0 = Attachment;
            v112.Attachment1 = Attachment2;
            v112.Color = ColorSequence.new(v105.Color);
            v112.Parent = Attachment;
            v112.Enabled = true;
        end;
    end;

    Audio.Play("rbxassetid://102267539121951", script, nil, 1);

    for _, descendant in ipairs(u93:GetDescendants()) do
        if descendant ~= Core and (descendant.Name ~= "RootPart" and descendant:IsA("BasePart")) then
            local v113 = CFrame.new(Core.Position, descendant.Position).LookVector * 16 + Vector3.new(0, 24, 0);
            descendant.Transparency = v103;
            descendant.Color = v104;
            descendant.Material = v105.Material;
            descendant.MaterialVariant = v105.MaterialVariant;
            descendant:ApplyImpulse(v113 * descendant.AssemblyMass);
        end;
    end;

    task.delay(3, function() -- Line: 428
        -- upvalues: u93 (copy), TweenService (ref), Debris (ref)
        for _, child in ipairs(u93:GetChildren()) do
            for _, descendant in ipairs(child:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    TweenService:Create(descendant, TweenInfo.new(1), {
                        Transparency = 1
                    }):Play();
                end;
            end;
        end;

        Debris:AddItem(u93, 1);
    end);
    local Attachment = Core.Attachment;
    local v114 = Attachment:IsA("Attachment");
    assert(v114, "Egg explosion core Attachment must be an Attachment");

    for _, descendant in ipairs(Attachment:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") and descendant.Name == "ColorMe" then
            descendant.Color = ColorSequence.new(v105.Color);
        end;
    end;

    EmitDescendants(Attachment);
    local Rare = Core.Rare;
    local v115 = Rare:IsA("Attachment");
    assert(v115, "Egg explosion core Rare must be an Attachment");

    for _, descendant in ipairs(Rare:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant.Color = ColorSequence.new(v105.Color);
        end;
    end;

    EmitDescendants(Rare);
    local v116 = EggPoof:Clone();
    v116.CFrame = v95;
    v116.Parent = __DEBRIS;
    EmitDescendants(v116);
    Debris:AddItem(v116, 6);
    local u117 = Players:GetPlayerByUserId(p88);

    if u117 == nil then
        u106:Destroy();

        return v107;
    end;

    local u118 = u106:GetPivot();
    RenderStepped(function(p119, p120) -- Line: 196
        -- upvalues: u106 (copy), u118 (copy), u117 (copy), Player (ref), Easing (ref)
        if u106.Parent == nil then
            return true;
        end;

        local v121 = math.sin(6.283185307179586 * p120 * 0.5) * 1;
        local v122 = u118 + Vector3.new(0, v121, 0);
        local Position = u118.Position;
        local v123 = Player.Optional.PrimaryPart(u117);

        if v123 then
            Position = v123:GetPivot().Position;
        end;

        local v124 = Vector3.new(Position.X, v122.Y, Position.Z);
        local v125;

        if (v122.Position - v124).Magnitude < 0.001 then
            v125 = v122;
        else
            v125 = CFrame.lookAt(v122.Position, v124);
        end;

        u106:PivotTo(v122:Lerp(v125, (Easing(p120, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))));
    end, 3, true):Wait();
    flyAssetIntoPlayer(u106, u117);

    return v107;
end;

function v6.FadeSoundWhenGrantedToolUnequips(u126, u127) -- Line: 468
    -- upvalues: Asserts (copy), Players (copy), Audio (copy)
    Asserts.Sound(u126);
    Asserts.string(u127);

    if not u126:IsDescendantOf(game) then
        return;
    end;

    local LocalPlayer = Players.LocalPlayer;
    local u128 = nil;
    local u129 = nil;
    local u130 = nil;
    local u131 = nil;
    local u132 = false;

    local function disconnectLifecycle() -- Line: 482
        -- upvalues: u128 (ref), u129 (ref), u130 (ref), u131 (ref)
        if u128 ~= nil then
            u128:Disconnect();
            u128 = nil;
        end;

        if u129 ~= nil then
            u129:Disconnect();
            u129 = nil;
        end;

        if u130 ~= nil then
            u130:Disconnect();
            u130 = nil;
        end;

        if u131 ~= nil then
            u131:Disconnect();
            u131 = nil;
        end;
    end;

    local function fadeAndStop() -- Line: 501
        -- upvalues: disconnectLifecycle (copy), u126 (copy), Audio (ref)
        disconnectLifecycle();

        if not u126:IsDescendantOf(game) then
            return;
        end;

        Audio.Fade(u126, 0, 0.35).Completed:Once(function() -- Line: 508
            -- upvalues: u126 (ref)
            if u126:IsDescendantOf(game) then
                u126:Stop();
            end;
        end);
    end;

    local function tryBindTool(p133) -- Line: 515
        -- upvalues: u132 (ref), u127 (copy), u128 (ref), u131 (ref), fadeAndStop (copy)
        if u132 or (not p133:IsA("Tool") or p133:GetAttribute("UID") ~= u127) then
            return;
        end;

        u132 = true;

        if u128 ~= nil then
            u128:Disconnect();
            u128 = nil;
        end;

        u131 = p133.Unequipped:Once(fadeAndStop);
    end;

    u129 = u126.Ended:Once(disconnectLifecycle);
    u130 = u126.Stopped:Once(disconnectLifecycle);
    u128 = LocalPlayer.DescendantAdded:Connect(tryBindTool);

    for _, descendant in LocalPlayer:GetDescendants() do
        tryBindTool(descendant);

        if u132 then
            break;
        end;
    end;
end;

return v6;