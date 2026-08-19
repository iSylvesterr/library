-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local SoundService = game:GetService("SoundService");
local Debris = game:GetService("Debris");
local Players = game:GetService("Players");
local ContentProvider = game:GetService("ContentProvider");
local Bezier = require(ReplicatedStorage.ClientModules.Bezier);
local EggHatchAnim = require(script.Parent.EggHatchAnim);
local EggScreenShake = require(script.Parent.EggScreenShake);
local PetModules = require(ReplicatedStorage.SharedModules.PetModules);
local PetData = require(ReplicatedStorage.SharedData.PetData);
local PetSizes = require(ReplicatedStorage.SharedData.PetSizes);
local AnimatedGradient = require(ReplicatedStorage.SharedModules.AnimatedGradient);
local u2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 128, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 200, 0)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 128, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(128, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
});
local Assets = ReplicatedStorage:WaitForChild("Assets");
local Eggs = Assets:WaitForChild("Eggs");
local Pets = Assets:WaitForChild("Pets");
local RarityData = ReplicatedStorage.SharedModules.RarityData;
local EggEffects = Assets:FindFirstChild("EggEffects");
local Quad = Enum.EasingStyle.Quad;
local u3 = Random.new();
local Exponential = Enum.EasingStyle.Exponential;
local Quad2 = Enum.EasingStyle.Quad;
local u4 = { "rbxassetid://89897463147043", "rbxassetid://84124106284739", "rbxassetid://109098770620406", "rbxassetid://109098770620406" };
local u5 = { "rbxassetid://92457414302766", "rbxassetid://105505525581659", "rbxassetid://105012703607081", "rbxassetid://105012703607081" };
local u6 = { "rbxassetid://88608751101502", "rbxassetid://78796672742221" };
local _ = Players.LocalPlayer;
local Folder = Instance.new("Folder");
Folder.Name = "EggOpenSoundCache";
Folder.Parent = SoundService;
local u7 = {};

local function RegisterSoundTemplate(p8) -- Line: 155
    -- upvalues: u7 (copy), Folder (copy)
    if u7[p8] then
        return;
    end;

    local Sound = Instance.new("Sound");
    Sound.SoundId = p8;
    Sound.Parent = Folder;
    u7[p8] = Sound;
end;

if not u7["rbxassetid://121132824785522"] then
    local Sound = Instance.new("Sound");
    Sound.SoundId = "rbxassetid://121132824785522";
    Sound.Parent = Folder;
    u7["rbxassetid://121132824785522"] = Sound;
end;

if not u7["rbxassetid://104869826618847"] then
    local Sound = Instance.new("Sound");
    Sound.SoundId = "rbxassetid://104869826618847";
    Sound.Parent = Folder;
    u7["rbxassetid://104869826618847"] = Sound;
end;

if not u7["rbxassetid://78426714974899"] then
    local Sound = Instance.new("Sound");
    Sound.SoundId = "rbxassetid://78426714974899";
    Sound.Parent = Folder;
    u7["rbxassetid://78426714974899"] = Sound;
end;

if not u7["rbxassetid://116376053254864"] then
    local Sound = Instance.new("Sound");
    Sound.SoundId = "rbxassetid://116376053254864";
    Sound.Parent = Folder;
    u7["rbxassetid://116376053254864"] = Sound;
end;

if not u7["rbxassetid://131003613792899"] then
    local Sound = Instance.new("Sound");
    Sound.SoundId = "rbxassetid://131003613792899";
    Sound.Parent = Folder;
    u7["rbxassetid://131003613792899"] = Sound;
end;

if not u7["rbxassetid://93813602862073"] then
    local Sound = Instance.new("Sound");
    Sound.SoundId = "rbxassetid://93813602862073";
    Sound.Parent = Folder;
    u7["rbxassetid://93813602862073"] = Sound;
end;

for _, v in u4 do
    if not u7[v] then
        local Sound = Instance.new("Sound");
        Sound.SoundId = v;
        Sound.Parent = Folder;
        u7[v] = Sound;
    end;
end;

for _, v in u5 do
    if not u7[v] then
        local Sound = Instance.new("Sound");
        Sound.SoundId = v;
        Sound.Parent = Folder;
        u7[v] = Sound;
    end;
end;

for _, v in u6 do
    if not u7[v] then
        local Sound = Instance.new("Sound");
        Sound.SoundId = v;
        Sound.Parent = Folder;
        u7[v] = Sound;
    end;
end;

local function CreateSFX(p9, p10, p11) -- Line: 181
    -- upvalues: SoundService (copy)
    local Sound = Instance.new("Sound");
    Sound.SoundId = p10;
    Sound.Volume = 1.75;
    Sound.RollOffMaxDistance = 200;
    Sound.Looped = p11 == true;
    local SFXGroup = SoundService:FindFirstChild("SFXGroup");

    if SFXGroup and SFXGroup:IsA("SoundGroup") then
        Sound.SoundGroup = SFXGroup;
    end;

    Sound.Parent = p9;

    return Sound;
end;

local function PlaySFX(p12, p13) -- Line: 195
    -- upvalues: SoundService (copy), Debris (copy)
    if not p12 then
        return;
    end;

    if not p13 or (p13 == "" or p13 == "rbxassetid://0") then
        return;
    end;

    local Sound = Instance.new("Sound");
    Sound.SoundId = p13;
    Sound.Volume = 1.75;
    Sound.RollOffMaxDistance = 200;
    Sound.Looped = false;
    local SFXGroup = SoundService:FindFirstChild("SFXGroup");

    if SFXGroup and SFXGroup:IsA("SoundGroup") then
        Sound.SoundGroup = SFXGroup;
    end;

    Sound.Parent = p12;
    Sound:Play();
    Debris:AddItem(Sound, 5);
end;

local function PlayOwnerAwareSFX(p14, p15, p16, p17) -- Line: 203
    -- upvalues: u7 (copy), SoundService (copy), Debris (copy)
    local v18 = u7[p16];
    local v19;

    if v18 then
        v19 = v18:Clone();
    else
        v19 = Instance.new("Sound");
    end;

    v19.SoundId = p16;
    v19.Volume = p17 or 2;
    local SFXGroup = SoundService:FindFirstChild("SFXGroup");

    if SFXGroup and SFXGroup:IsA("SoundGroup") then
        v19.SoundGroup = SFXGroup;
    end;

    v19.RollOffMaxDistance = 250;
    v19.Parent = p14;
    v19:Play();
    Debris:AddItem(v19, 5);
end;

local function SetTrailEnabled(p20, p21) -- Line: 221
    for _, descendant in p20:GetDescendants() do
        if descendant:IsA("Trail") or (descendant:IsA("ParticleEmitter") or descendant:IsA("Beam")) then
            descendant.Enabled = p21;
        end;
    end;
end;

local function GroundBelow(p22) -- Line: 231
    -- upvalues: Players (copy)
    local v23 = RaycastParams.new();
    v23.FilterType = Enum.RaycastFilterType.Exclude;
    local v24 = {};
    local Temporary = workspace:FindFirstChild("Temporary");

    if Temporary then
        table.insert(v24, Temporary);
    end;

    for _, v in Players:GetPlayers() do
        if v.Character then
            table.insert(v24, v.Character);
        end;
    end;

    v23.FilterDescendantsInstances = v24;
    local v25 = workspace:Raycast(p22 + Vector3.new(0, 50, 0), Vector3.new(0, -500, 0), v23);

    if v25 then
        return v25.Position;
    end;

    return p22;
end;

local function PivotCFrameFor(p26) -- Line: 252
    if p26 then
        p26 = p26.Pivot;
    end;

    if typeof(p26) == "Vector3" then
        return CFrame.Angles(math.rad(p26.X), math.rad(p26.Y), (math.rad(p26.Z)));
    end;

    return CFrame.identity;
end;

local function EnsureAnimator(p27) -- Line: 260
    local v28 = p27:FindFirstChildOfClass("AnimationController");

    if not v28 then
        v28 = Instance.new("AnimationController");
        v28.Parent = p27;
    end;

    local v29 = v28:FindFirstChildOfClass("Animator");

    if not v29 then
        v29 = Instance.new("Animator");
        v29.Parent = v28;
    end;

    return v29;
end;

local function FindWalkAnimation(u30, p31) -- Line: 277
    local Animations = u30:FindFirstChild("Animations");

    local function lookup(p32) -- Line: 279
        -- upvalues: Animations (copy), u30 (copy)
        if not p32 or p32 == "" then
            return nil;
        end;

        local v33 = Animations and Animations:FindFirstChild(p32) or u30:FindFirstChild(p32);

        if v33 and v33:IsA("Animation") then
            return v33;
        end;

        return nil;
    end;

    if p31 then
        p31 = p31.Animations;
    end;

    local v34 = Animations and Animations:FindFirstChild("Walk") or u30:FindFirstChild("Walk");

    if not (v34 and v34:IsA("Animation")) then
        v34 = nil;
    end;

    if not v34 then
        if p31 then
            local Walk = p31.Walk;

            if Walk and Walk ~= "" then
                v34 = Animations and Animations:FindFirstChild(Walk) or u30:FindFirstChild(Walk);

                if not (v34 and v34:IsA("Animation")) then
                    v34 = nil;
                end;
            else
                v34 = nil;
            end;

            if not v34 then
                local Fly = p31.Fly;

                if Fly and Fly ~= "" then
                    v34 = Animations and Animations:FindFirstChild(Fly) or u30:FindFirstChild(Fly);

                    if not (v34 and v34:IsA("Animation")) then
                        v34 = nil;
                    end;
                else
                    v34 = nil;
                end;

                if not v34 then
                    local GroundIdle = p31.GroundIdle;

                    if GroundIdle and GroundIdle ~= "" then
                        v34 = Animations and Animations:FindFirstChild(GroundIdle) or u30:FindFirstChild(GroundIdle);

                        if not (v34 and v34:IsA("Animation")) then
                            v34 = nil;
                        end;
                    else
                        v34 = nil;
                    end;

                    if not v34 then
                        local Idle = p31.Idle;

                        if Idle and Idle ~= "" then
                            v34 = Animations and Animations:FindFirstChild(Idle) or u30:FindFirstChild(Idle);

                            if not (v34 and v34:IsA("Animation")) then
                                v34 = nil;
                            end;
                        else
                            v34 = nil;
                        end;
                    end;
                end;
            end;
        else
            v34 = p31;
        end;
    end;

    if v34 then
        return v34;
    end;

    if Animations then
        for _, child in Animations:GetChildren() do
            if child:IsA("Animation") then
                return child;
            end;
        end;
    end;

    for _, descendant in u30:GetDescendants() do
        if descendant:IsA("Animation") then
            return descendant;
        end;
    end;

    return nil;
end;

local function FindIdleAnimation(u35, p36) -- Line: 303
    local Animations = u35:FindFirstChild("Animations");

    local function _(p37) -- Line: 305
        -- upvalues: Animations (copy), u35 (copy)
        if not p37 or p37 == "" then
            return nil;
        end;

        local v38 = Animations and Animations:FindFirstChild(p37) or u35:FindFirstChild(p37);

        if v38 and v38:IsA("Animation") then
            return v38;
        end;

        return nil;
    end;

    if p36 then
        p36 = p36.Animations;
    end;

    local v39 = Animations and Animations:FindFirstChild("Idle") or u35:FindFirstChild("Idle");

    if not (v39 and v39:IsA("Animation")) then
        v39 = nil;
    end;

    if not v39 then
        if p36 then
            local Idle = p36.Idle;

            if Idle and Idle ~= "" then
                v39 = Animations and Animations:FindFirstChild(Idle) or u35:FindFirstChild(Idle);

                if not (v39 and v39:IsA("Animation")) then
                    v39 = nil;
                end;
            else
                v39 = nil;
            end;

            if not v39 then
                local GroundIdle = p36.GroundIdle;

                if GroundIdle and GroundIdle ~= "" then
                    v39 = Animations and Animations:FindFirstChild(GroundIdle) or u35:FindFirstChild(GroundIdle);

                    if not (v39 and v39:IsA("Animation")) then
                        v39 = nil;
                    end;
                else
                    v39 = nil;
                end;

                if not v39 then
                    local Fly = p36.Fly;

                    if not Fly or Fly == "" then
                        return nil;
                    end;

                    local v40 = Animations and Animations:FindFirstChild(Fly) or u35:FindFirstChild(Fly);

                    if v40 and v40:IsA("Animation") then
                        return v40;
                    end;

                    v39 = nil;
                end;
            end;
        else
            v39 = p36;
        end;
    end;

    return v39;
end;

local function LowestWorldY(p41) -- Line: 319
    local v42 = (1 / 0);

    for _, descendant in p41:GetDescendants() do
        if descendant:IsA("BasePart") then
            local CFrame2 = descendant.CFrame;
            local Size = descendant.Size;
            local v43 = Size.X / 2;
            local v44 = Size.Y / 2;
            local v45 = Size.Z / 2;

            for i = -1, 1, 2 do
                for i2 = -1, 1, 2 do
                    local Y = (CFrame2 * Vector3.new(i * v43, i2 * v44, -1 * v45)).Y;

                    if Y >= v42 then
                        Y = v42;
                    end;

                    v42 = (CFrame2 * Vector3.new(i * v43, i2 * v44, 1 * v45)).Y;

                    if v42 >= Y then
                        v42 = Y;
                    end;
                end;
            end;
        end;
    end;

    return v42;
end;

local function HighestWorldY(p46) -- Line: 340
    local v47 = (-1 / 0);

    for _, descendant in p46:GetDescendants() do
        if descendant:IsA("BasePart") then
            local CFrame2 = descendant.CFrame;
            local Size = descendant.Size;
            local v48 = Size.X / 2;
            local v49 = Size.Y / 2;
            local v50 = Size.Z / 2;

            for i = -1, 1, 2 do
                for i2 = -1, 1, 2 do
                    local Y = (CFrame2 * Vector3.new(i * v48, i2 * v49, -1 * v50)).Y;

                    if v47 >= Y then
                        Y = v47;
                    end;

                    v47 = (CFrame2 * Vector3.new(i * v48, i2 * v49, 1 * v50)).Y;

                    if Y >= v47 then
                        v47 = Y;
                    end;
                end;
            end;
        end;
    end;

    return v47;
end;

local function SetLabelText(p51, p52) -- Line: 360
    if not p51 then
        return;
    end;

    if p51:IsA("TextLabel") then
        p51.Text = p52;
    end;

    local TextLabel = p51:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.Text = p52;
    end;
end;

local function SetLabelScale(p53, p54) -- Line: 367
    if not p53 then
        return;
    end;

    local UIScale = p53:FindFirstChild("UIScale");

    if UIScale and UIScale:IsA("UIScale") then
        UIScale.Scale = p54;
    end;
end;

local function ApplyRainbow(p55) -- Line: 378
    -- upvalues: u2 (copy), AnimatedGradient (copy)
    if not p55 then
        return;
    end;

    local function apply(p56) -- Line: 380
        -- upvalues: u2 (ref), AnimatedGradient (ref)
        if not (p56 and p56:IsA("TextLabel")) then
            return;
        end;

        p56.TextColor3 = Color3.new(1, 1, 1);
        local UIGradient = Instance.new("UIGradient");
        UIGradient.Color = u2;
        UIGradient.Parent = p56;
        AnimatedGradient:Add(UIGradient);
    end;

    for _, child in p55:GetChildren() do
        if child:IsA("TextLabel") then
            apply(child);
        end;
    end;
end;

local function CreateLabel(p57, p58, p59, p60) -- Line: 396
    -- upvalues: Assets (copy), PetData (copy), ApplyRainbow (copy), RarityData (copy), TweenService (copy), Debris (copy)
    local SeedNameAttachment = Assets:FindFirstChild("SeedNameAttachment");

    if not SeedNameAttachment then
        return nil;
    end;

    local u61 = SeedNameAttachment:Clone();
    u61.Position = p59;
    local BillboardGui = u61:FindFirstChild("BillboardGui");

    if not BillboardGui then
        u61.Parent = workspace.Temporary;

        return u61, function() -- Line: 406
            -- upvalues: u61 (copy)
            u61:Destroy();
        end;
    end;

    local Seed_Name = BillboardGui:FindFirstChild("Seed_Name");
    local Rarity_Name = BillboardGui:FindFirstChild("Rarity_Name");
    local u62;

    if p58 and (p58 ~= "" and (Rarity_Name and Rarity_Name:IsA("GuiObject"))) then
        local function fitLine(p63) -- Line: 416
            p63.Size = UDim2.new(p63.Size.X.Scale, p63.Size.X.Offset, 0.3, 0);
        end;

        local v64 = Rarity_Name:Clone();
        v64.Name = "Type_Name";
        v64.LayoutOrder = 1;
        v64.Size = UDim2.new(v64.Size.X.Scale, v64.Size.X.Offset, 0.3, 0);
        v64.Parent = BillboardGui;
        u62 = v64;
        Rarity_Name.LayoutOrder = 2;
        Rarity_Name.Size = UDim2.new(Rarity_Name.Size.X.Scale, Rarity_Name.Size.X.Offset, 0.3, 0);

        if Seed_Name and Seed_Name:IsA("GuiObject") then
            Seed_Name.LayoutOrder = 0;
            Seed_Name.Size = UDim2.new(Seed_Name.Size.X.Scale, Seed_Name.Size.X.Offset, 0.3, 0);
        end;

        if BillboardGui:IsA("BillboardGui") then
            BillboardGui.Size = UDim2.new(BillboardGui.Size.X.Scale, BillboardGui.Size.X.Offset, 4.5, 0);
        end;
    else
        u62 = nil;
    end;

    if Seed_Name then
        local UIScale = Seed_Name:FindFirstChild("UIScale");

        if UIScale and UIScale:IsA("UIScale") then
            UIScale.Scale = 0;
        end;
    end;

    if Rarity_Name then
        local UIScale = Rarity_Name:FindFirstChild("UIScale");

        if UIScale and UIScale:IsA("UIScale") then
            UIScale.Scale = 0;
        end;
    end;

    local v65 = u62;

    if v65 then
        local UIScale = v65:FindFirstChild("UIScale");

        if UIScale and UIScale:IsA("UIScale") then
            UIScale.Scale = 0;
        end;
    end;

    local v66 = PetData.GetDisplayName(p57, p60);

    if Seed_Name then
        if Seed_Name:IsA("TextLabel") then
            Seed_Name.Text = v66;
        end;

        local TextLabel = Seed_Name:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.Text = v66;
        end;
    end;

    if u62 then
        local v67 = u62;

        if v67 then
            if v67:IsA("TextLabel") then
                v67.Text = p58;
            end;

            local TextLabel = v67:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.Text = p58;
            end;
        end;

        ApplyRainbow(u62);
    end;

    local v68 = PetData[p57] and PetData[p57].Rarity;

    if v68 then
        if Rarity_Name then
            if Rarity_Name:IsA("TextLabel") then
                Rarity_Name.Text = v68;
            end;

            local TextLabel = Rarity_Name:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.Text = v68;
            end;
        end;

        local Gradients = RarityData:FindFirstChild("Gradients");

        if Gradients then
            Gradients = Gradients:FindFirstChild(v68);
        end;

        if Gradients and Rarity_Name then
            local TextLabel = Rarity_Name:FindFirstChild("TextLabel");

            if TextLabel then
                Gradients:Clone().Parent = TextLabel;
            end;

            Gradients:Clone().Parent = Rarity_Name;
        end;
    end;

    u61.Parent = workspace.Temporary;

    local function popIn(p69, p70) -- Line: 470
        -- upvalues: TweenService (ref)
        if not p69 then
            return;
        end;

        local UIScale = p69:FindFirstChild("UIScale");

        if UIScale and UIScale:IsA("UIScale") then
            task.delay(p70, function() -- Line: 474
                -- upvalues: UIScale (copy), TweenService (ref)
                if UIScale.Parent then
                    TweenService:Create(UIScale, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {
                        Scale = 1
                    }):Play();
                end;
            end);
        end;
    end;

    popIn(Seed_Name, 0);
    popIn(u62, 0.1);
    popIn(Rarity_Name, 0.15);

    return u61, function() -- Line: 485, Name: popOut
        -- upvalues: TweenService (ref), Seed_Name (copy), u62 (ref), Rarity_Name (copy), Debris (ref), u61 (copy)
        local function shrink(p71) -- Line: 486
            -- upvalues: TweenService (ref)
            if not p71 then
                return;
            end;

            local UIScale = p71:FindFirstChild("UIScale");

            if UIScale and UIScale:IsA("UIScale") then
                TweenService:Create(UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {
                    Scale = 0
                }):Play();
            end;
        end;

        shrink(Seed_Name);
        shrink(u62);
        shrink(Rarity_Name);
        Debris:AddItem(u61, 0.6000000000000001);
    end;
end;

local function PreparePet(p72) -- Line: 504
    local v73 = p72.PrimaryPart or (p72:FindFirstChild("Torso") or p72:FindFirstChild("HumanoidRootPart") or (p72:FindFirstChild("RootPart") or p72:FindFirstChildWhichIsA("BasePart")));

    if not v73 then
        return nil;
    end;

    p72.PrimaryPart = v73;

    for _, descendant in p72:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Massless = true;
            descendant.Anchored = descendant == v73;
        end;
    end;

    return v73;
end;

local function PlayReveal(p74, p75, p76, u77, p78, p79, p80) -- Line: 530
    -- upvalues: PetModules (copy), Pets (copy), Assets (copy), PreparePet (copy), PetSizes (copy), LowestWorldY (copy), EnsureAnimator (copy), FindIdleAnimation (copy), CreateLabel (copy), HighestWorldY (copy), RunService (copy), FindWalkAnimation (copy), TweenService (copy), Quad2 (copy)
    local v81 = PetModules[p74];
    local v82, v83, v84;

    if Pets then
        local v85;

        if v81 then
            v85 = v81.AssetName or p74;
        else
            v85 = p74;
        end;

        v82 = Pets:FindFirstChild(v85);

        if not v82 then
            v83 = Assets;

            if v81 then
                v84 = v81.AssetName or p74;
            else
                v84 = p74;
            end;

            v82 = v83:FindFirstChild(v84);
        end;
    else
        v83 = Assets;

        if v81 then
            v84 = v81.AssetName or p74;
        else
            v84 = p74;
        end;

        v82 = v83:FindFirstChild(v84);
    end;

    if not (v82 and v82:IsA("Model")) then
        return;
    end;

    local v86 = v82:Clone();
    local u87 = PreparePet(v86);

    if not u87 then
        v86:Destroy();

        return;
    end;

    local u88 = PetSizes.GetScale(p78, v81 and {
        Big = v81.BigScale,
        Huge = v81.HugeScale
    } or nil);

    if u88 ~= 1 then
        v86:ScaleTo(u88);
    end;

    local v89;

    if v81 then
        v89 = v81.Pivot;
    else
        v89 = v81;
    end;

    local u90;

    if typeof(v89) == "Vector3" then
        u90 = CFrame.Angles(math.rad(v89.X), math.rad(v89.Y), (math.rad(v89.Z)));
    else
        u90 = CFrame.identity;
    end;

    local v91 = p75 + Vector3.new(0, 0, 0);

    local function resolveHrp() -- Line: 552
        -- upvalues: u77 (copy)
        local v92 = u77 and u77.Character;

        if v92 then
            v92 = v92:FindFirstChild("HumanoidRootPart");
        end;

        if v92 and v92:IsA("BasePart") then
            return v92;
        end;

        return nil;
    end;

    local v93;

    if u77 then
        v93 = u77.Character;
    else
        v93 = u77;
    end;

    if v93 then
        v93 = v93:FindFirstChild("HumanoidRootPart");
    end;

    if not (v93 and v93:IsA("BasePart")) then
        v93 = nil;
    end;

    local v94 = v93 and Vector3.new(v93.Position.X, v91.Y, v93.Position.Z) or v91 + p76 * Vector3.new(1, 0, 1);
    v86:PivotTo(CFrame.lookAt(v91, v94) * u90);
    v86.Parent = workspace.Temporary;
    local v95 = LowestWorldY(v86);

    if v95 ~= (1 / 0) then
        local v96 = p75.Y + 0 - v95;

        if math.abs(v96) > 0.001 then
            v86:PivotTo(v86:GetPivot() + Vector3.new(0, v96, 0));
        end;
    end;

    if p79 == "Rainbow" then
        v86:AddTag("PetRainbow");
    end;

    local v97 = EnsureAnimator(v86);
    local v98 = FindIdleAnimation(v86, v81);
    local v99;

    if v98 then
        v99 = v97:LoadAnimation(v98);
        v99.Looped = true;
        v99:Play();
    else
        v99 = nil;
    end;

    local u100, v101;

    if p80 then
        u100 = nil;
        v101 = nil;
    else
        u100, v101 = CreateLabel(p74, p79, v91, p78);
    end;

    local v102 = HighestWorldY(v86);
    local v103 = 3;
    local u104;

    if u100 then
        local BillboardGui = u100:FindFirstChild("BillboardGui");

        if BillboardGui and BillboardGui:IsA("BillboardGui") then
            v103 = BillboardGui.Size.Y.Scale;
        end;

        u104 = v102 - u87.Position.Y + v103 / 2 + 1;
        u100.Position = u87.Position + Vector3.new(0, u104, 0);
    else
        u104 = 1;
    end;

    local u105 = true;
    local v110 = RunService.RenderStepped:Connect(function(p106) -- Line: 621
        -- upvalues: u105 (ref), u87 (copy), u77 (copy), u90 (copy), u100 (ref), u104 (ref)
        if not u105 then
            return;
        end;

        if not (u87 and u87.Parent) then
            return;
        end;

        local v107 = u77 and u77.Character;

        if v107 then
            v107 = v107:FindFirstChild("HumanoidRootPart");
        end;

        if not (v107 and v107:IsA("BasePart")) then
            v107 = nil;
        end;

        local Position = u87.Position;

        if v107 then
            local v108 = Vector3.new(v107.Position.X, Position.Y, v107.Position.Z);
            local v109 = CFrame.lookAt(Position, v108) * u90;
            u87.CFrame = u87.CFrame:Lerp(v109, (math.clamp(p106 * 8, 0, 1)));
        end;

        if u100 and u100.Parent then
            u100.Position = Position + Vector3.new(0, u104, 0);
        end;
    end);
    task.wait(5);
    u105 = false;

    if v110 then
        v110:Disconnect();
    end;

    if v101 then
        v101();
    end;

    if v99 then
        v99:Stop(0.1);
    end;

    local function leapScale(p111) -- Line: 645
        -- upvalues: u88 (copy)
        return math.max(u88 * ((p111 <= 0.7 and 0 or (p111 - 0.7) / 0.30000000000000004) * -0.95 + 1), 0.01);
    end;

    local v112;

    if u77 then
        v112 = u77.Character;
    else
        v112 = u77;
    end;

    if v112 then
        v112 = v112:FindFirstChild("HumanoidRootPart");
    end;

    if not (v112 and v112:IsA("BasePart")) then
        v112 = nil;
    end;

    if v112 then
        local v113 = FindWalkAnimation(v86, v81);
        local v114;

        if v113 then
            v114 = v97:LoadAnimation(v113);
            v114.Looped = true;
            v114:Play();
        else
            v114 = nil;
        end;

        local Position = u87.Position;
        local v115 = 0;

        while v115 < 0.6 do
            v115 = v115 + RunService.Heartbeat:Wait();
            local v116 = TweenService:GetValue(v115 / 0.6, Quad2, Enum.EasingDirection.Out);
            local v117;

            if u77 then
                v117 = u77.Character;
            else
                v117 = u77;
            end;

            if v117 then
                v117 = v117:FindFirstChild("HumanoidRootPart");
            end;

            if not (v117 and v117:IsA("BasePart")) then
                v117 = nil;
            end;

            local v118;

            if v117 then
                v118 = v117.Position or Position;
            else
                v118 = Position;
            end;

            local v119 = (1 - v116) ^ 2 * Position + 2 * (1 - v116) * v116 * ((Position + v118) / 2 + Vector3.new(0, 8, 0)) + v116 ^ 2 * v118;
            v86:ScaleTo((math.max(u88 * ((v116 <= 0.7 and 0 or (v116 - 0.7) / 0.30000000000000004) * -0.95 + 1), 0.01)));
            local v120 = Vector3.new(v118.X, v119.Y, v118.Z);

            if (v120 - v119).Magnitude > 0.001 then
                u87.CFrame = CFrame.lookAt(v119, v120) * u90;
            else
                u87.CFrame = CFrame.new(v119) * u87.CFrame.Rotation;
            end;
        end;

        if v114 then
            v114:Stop(0);
        end;
    else
        local v121 = 0;

        while v121 < 0.6 do
            v121 = v121 + RunService.Heartbeat:Wait();
            local v122 = TweenService:GetValue(v121 / 0.6, Quad2, Enum.EasingDirection.Out);
            v86:ScaleTo((math.max(u88 * ((v122 <= 0.7 and 0 or (v122 - 0.7) / 0.30000000000000004) * -0.95 + 1), 0.01)));
        end;
    end;

    v86:Destroy();
end;

u1.PlayReveal = PlayReveal;

function u1.Open(p123, p124, p125, p126, p127, u128, p129, p130, p131, p132) -- Line: 706
    -- upvalues: Eggs (copy), GroundBelow (copy), EggEffects (copy), PlayOwnerAwareSFX (copy), SetTrailEnabled (copy), Bezier (copy), RunService (copy), TweenService (copy), Quad (copy), u4 (copy), EggScreenShake (copy), u5 (copy), u6 (copy), EggHatchAnim (copy), Exponential (copy), u3 (copy), PlayReveal (copy)
    local v133 = p132 or Eggs:FindFirstChild(p124);

    if not v133 then
        return;
    end;

    local v134 = GroundBelow(p127.Position);
    local v135 = Vector3.new(p127.Position.X, v134.Y + 0, p127.Position.Z);
    local v136 = CFrame.new(v135, v135 + p127.LookVector * Vector3.new(1, 0, 1));
    local u137 = v133:Clone();

    for _, descendant in u137:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
        end;
    end;

    local u138 = u137.PrimaryPart or (u137:FindFirstChild("Handle") or u137:FindFirstChildWhichIsA("BasePart"));

    if not u138 then
        u137:Destroy();

        return;
    end;

    if EggEffects and EggEffects:FindFirstChild("Attachment") then
        EggEffects.Attachment:Clone().Parent = u138;
    end;

    local u139 = EggEffects.Shake:Clone();
    u139.Parent = u138;
    local u140 = EggEffects.Highlight:Clone();
    u140.Parent = u138;
    u140.DepthMode = Enum.HighlightDepthMode.Occluded;
    u140.FillTransparency = 1;
    u140.OutlineTransparency = 1;
    u137.Parent = workspace.Temporary;
    PlayOwnerAwareSFX(u138, u128, "rbxassetid://121132824785522");

    if p131 then
        u137:PivotTo(v136);
        SetTrailEnabled(u137, false);
    else
        u137:PivotTo(CFrame.new(p126, p126 + v136.LookVector * Vector3.new(1, 0, 1)));
        SetTrailEnabled(u137, true);
        local v141 = Bezier.new(p126, (p126 + v136.Position) / 2 + Vector3.new(0, 16, 0), v136.Position);
        local v142 = 0;

        while v142 < 0.3 do
            v142 = v142 + RunService.Heartbeat:Wait();
            local v143 = v141:CalculatePositionAt((TweenService:GetValue(v142 / 0.3, Quad, Enum.EasingDirection.Out)));
            u137:PivotTo(CFrame.new(v143, v143 + v136.LookVector));
        end;

        u137:PivotTo(v136);
        PlayOwnerAwareSFX(u138, u128, "rbxassetid://104869826618847");
        SetTrailEnabled(u137, false);

        for i = 1, 2 do
            local v144 = 0.45 ^ (i - 1) * 2.5;

            if v144 <= 0 then
                break;
            end;

            local v145 = math.sqrt(v144 / 2.5) * 0.2;
            local v146 = 0;

            while v146 < v145 do
                v146 = v146 + RunService.Heartbeat:Wait();
                local v147 = math.clamp(v146 / v145, 0, 1);
                u137:PivotTo(v136 * CFrame.new(0, v144 * 4 * v147 * (1 - v147), 0));
            end;

            u137:PivotTo(v136);
        end;
    end;

    task.wait(1);
    local u148 = u4;
    local u149 = 0;

    local function v151() -- Line: 809
        -- upvalues: u138 (copy), u149 (ref), u148 (ref), PlayOwnerAwareSFX (ref), u128 (copy), u140 (copy), u139 (copy)
        u149 = u149 + 1;
        local v150 = u148[u149];

        if v150 then
            PlayOwnerAwareSFX(u138, u128, v150);
        end;

        u140.FillTransparency = 0;
        u140.OutlineTransparency = 0.5;
        game.TweenService:Create(u140, TweenInfo.new(0.3), {
            FillTransparency = 1,
            OutlineTransparency = 1
        }):Play();

        for _, child in u139:GetChildren() do
            if child:IsA("ParticleEmitter") then
                child:Emit(child:GetAttribute("EmitCount"));
            end;
        end;
    end;

    local u152 = EggScreenShake.begin(v136.Position, p129);
    local v158 = {
        onWobbleBeat = function(p153) -- Line: 832, Name: onWobbleBeat
            -- upvalues: u152 (copy)
            u152:onWobbleBeat(p153);
        end,

        onGrowStart = function(p154, p155) -- Line: 835, Name: onGrowStart
            -- upvalues: PlayOwnerAwareSFX (ref), u138 (copy), u128 (copy), u148 (ref), u5 (ref), u149 (ref), u6 (ref)
            if p154 ~= 1 then
                if p154 == 2 then
                    PlayOwnerAwareSFX(u138, u128, "rbxassetid://93813602862073", 4);
                    u148 = u6;
                    u149 = 0;
                end;

                return;
            end;

            PlayOwnerAwareSFX(u138, u128, "rbxassetid://131003613792899", 4);
            u148 = u5;
            u149 = 0;
        end,

        onGrowBeat = function(p156, p157) -- Line: 846, Name: onGrowBeat
            -- upvalues: u152 (copy)
            u152:onGrowBeat(p156, p157);
        end
    };

    if p129 == "Big" then
        EggHatchAnim.RunBigPreHatchSequence(u137, v136, v151, v158);
    elseif p129 == "Huge" then
        EggHatchAnim.RunHugePreHatchSequence(u137, v136, v151, v158);
    else
        EggHatchAnim.RunPreHatchSequence(u137, v136, EggHatchAnim.NormalPreHatchConfig, v151, v158);
    end;

    u152:onHatch(p129);
    local v159 = u137:GetScale() - 1;

    if math.abs(v159) <= 0.001 then
        u137:PivotTo(v136);
    end;

    if p129 == "Big" then
        PlayOwnerAwareSFX(u138, u128, "rbxassetid://78426714974899", 4);
    elseif p129 == "Huge" then
        PlayOwnerAwareSFX(u138, u128, "rbxassetid://116376053254864", 4);
    end;

    local u160 = {};

    for _, descendant in u137:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Color = Color3.new(1, 1, 1);

            if descendant:IsA("MeshPart") then
                descendant.TextureID = "";
            end;

            table.insert(u160, {
                Part = descendant,
                Start = descendant.Transparency
            });
        elseif descendant:IsA("Decal") or (descendant:IsA("Texture") or descendant:IsA("SurfaceAppearance")) then
            descendant:Destroy();
        end;
    end;

    local u161 = u137:GetScale();
    local u162 = EggHatchAnim.ResolveHatchTargetScale(p129, u161);

    if p129 ~= "Huge" then
        task.spawn(function() -- Line: 890
            -- upvalues: RunService (ref), TweenService (ref), Exponential (ref), u137 (copy), u161 (copy), u162 (copy), u160 (copy)
            local v163 = 0;

            while v163 < 0.6 do
                v163 = v163 + RunService.Heartbeat:Wait();
                local v164 = TweenService:GetValue(math.clamp(v163 / 0.6, 0, 1), Exponential, Enum.EasingDirection.Out);
                u137:ScaleTo(u161 + (u162 - u161) * v164);

                for _, v in u160 do
                    if v.Part.Parent then
                        v.Part.Transparency = v.Start + (1 - v.Start) * v164;
                    end;
                end;
            end;

            u137:Destroy();
        end);
    end;

    if p129 == "Huge" then
        local u165 = 0;
        game.TweenService:Create(u140, TweenInfo.new(0.6), {
            FillTransparency = 0,
            OutlineTransparency = 0
        }):Play();
        local u166 = true;
        task.spawn(function() -- Line: 919
            -- upvalues: u165 (ref), u166 (ref), RunService (ref), TweenService (ref), Exponential (ref), u137 (copy), u161 (copy)
            while u165 < 1.2 and u166 do
                u165 = u165 + RunService.Heartbeat:Wait();
                local v167 = TweenService:GetValue(math.clamp(u165 / 0.6, 0, 1), Exponential, Enum.EasingDirection.Out);
                u137:ScaleTo(u161 + (0.2 - u161) * v167);
            end;

            u165 = 0;

            while u165 < 3 and u166 do
                u165 = u165 + RunService.Heartbeat:Wait();
                local v168 = TweenService:GetValue(math.clamp(u165 / 3, 0, 1), Exponential, Enum.EasingDirection.Out);
                u137:ScaleTo(0.2 + (u161 - 0.2) * v168);
            end;
        end);
        local u169 = game.ReplicatedStorage.Assets.EggEffects.HugeUnlock:Clone();
        u169.Parent = workspace.Temporary;
        u169:PivotTo(u137:GetPivot());
        local v170 = u137:GetPivot();
        local v171 = u169.ScaleMe:GetPivot();

        for _, child in u169.HugeEffect:GetChildren() do
            TweenService:Create(child, TweenInfo.new(0.8), {
                TimeScale = 1
            }):Play();
        end;

        for _, child in u169.Floor:GetChildren() do
            TweenService:Create(child, TweenInfo.new(3), {
                TimeScale = 1
            }):Play();
        end;

        for _, child in u169.ScaleMe.HugeEffect.Attachment:GetChildren() do
            TweenService:Create(child, TweenInfo.new(3), {
                TimeScale = 1
            }):Play();
        end;

        local v172 = 0;
        local v173 = 0;

        while v172 < 2 do
            local v174 = RunService.Heartbeat:Wait();
            v172 = v172 + v174;
            v173 = v173 + 1080 * (v174 * v172 / 2);
            local v175 = TweenService:GetValue(math.clamp(v172 / 2, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
            local v176 = CFrame.new(u3:NextNumber(-1, 1) * v175 * 0.5, u3:NextNumber(-1, 1) * v175 * 0.5, u3:NextNumber(-1, 1) * v175 * 0.5);
            u137:PivotTo(v170:Lerp(v171, v175) * v176 * CFrame.Angles(0, math.rad(v173), 0));
            u169.HugeEffect:PivotTo(CFrame.new(u137.PrimaryPart.Position));
            u169.ScaleMe:PivotTo(CFrame.new(u137.PrimaryPart.Position));
            u169.ScaleMe:ScaleTo(v175);
        end;

        local v177 = u137:GetScale();
        task.delay(1.3, function() -- Line: 989
            -- upvalues: u169 (copy)
            for _, descendant in u169:GetDescendants() do
                if descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = false;
                end;
            end;
        end);
        local v178 = 0;

        while v178 < 1.5 do
            local v179 = RunService.Heartbeat:Wait();
            v178 = v178 + v179;
            local v180 = CFrame.new(u3:NextNumber(-1, 1) * 0.5, u3:NextNumber(-1, 1) * 0.5, u3:NextNumber(-1, 1) * 0.5);
            v173 = v173 + 1080 * v179;

            if v178 > 1.1 then
                local v181 = v178 - 1.1;
                u166 = false;
                local v182 = TweenService:GetValue(math.clamp(v181 / 0.4, 0, 1), Exponential, Enum.EasingDirection.Out);
                u137:ScaleTo(v177 + (0.1 - v177) * v182);
                u137:PivotTo(v171:Lerp(v170, (TweenService:GetValue(math.clamp(v181 / 0.4, 0, 1), Enum.EasingStyle.Back, Enum.EasingDirection.In))) * v180 * CFrame.Angles(0, math.rad(v173), 0));
                u169.HugeEffect:PivotTo(CFrame.new(u137.PrimaryPart.Position));
                u169.ScaleMe:PivotTo(CFrame.new(u137.PrimaryPart.Position));
            else
                u137:PivotTo(v171 * v180 * CFrame.Angles(0, math.rad(v173), 0));
            end;
        end;

        local v183 = EggEffects.Huge:Clone();
        v183.Parent = workspace.Terrain;
        v183.WorldPosition = u137:GetPivot().Position;
        u137:Destroy();

        for _, child in v183:GetChildren() do
            if child:IsA("ParticleEmitter") then
                child:Emit(child:GetAttribute("EmitCount"));
            elseif child:IsA("PointLight") then
                TweenService:Create(child, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    Range = 0,
                    Brightness = 1
                }):Play();
            end;
        end;

        game.Debris:AddItem(v183, 7);
        u137:Destroy();
    else
        local v184 = p129 == "Big" and EggEffects.Big:Clone() or EggEffects.Common:Clone();
        v184.Parent = workspace.Terrain;
        v184.WorldPosition = u137:GetPivot().Position;

        for _, child in v184:GetChildren() do
            if child:IsA("ParticleEmitter") then
                child:Emit(child:GetAttribute("EmitCount"));
            elseif child:IsA("PointLight") then
                TweenService:Create(child, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    Range = 0,
                    Brightness = 1
                }):Play();
            end;
        end;

        game.Debris:AddItem(v184, 7);
    end;

    if p129 == "Big" or p129 == "Huge" then
        u152:onPetRevealed();
    end;

    task.wait(0.1);
    PlayReveal(p125, Vector3.new(v136.Position.X, v134.Y, v136.Position.Z), v136.LookVector, u128, p129, p130);
end;

function u1.OpenInPlace(p185, p186, p187, p188, p189, p190, p191) -- Line: 1094
    -- upvalues: Assets (copy), u1 (copy)
    local PetAssets = Assets:FindFirstChild("PetAssets");

    if PetAssets then
        PetAssets = PetAssets:FindFirstChild("DragonEgg");
    end;

    if not PetAssets then
        return;
    end;

    local v192 = p188 + Vector3.new(0, 0, -1);
    local v193;

    if p189 then
        v193 = p189.Character;
    else
        v193 = p189;
    end;

    if v193 then
        v193 = v193:FindFirstChild("HumanoidRootPart");
    end;

    if v193 and v193:IsA("BasePart") then
        v192 = Vector3.new(v193.Position.X, p188.Y, v193.Position.Z);
    end;

    local v194 = CFrame.new(p188, v192);
    u1.Open(p185, p186, p187, p188, v194, p189, p190, p191, true, PetAssets);
end;

task.spawn(function() -- Line: 1115
    -- upvalues: u7 (copy), ContentProvider (copy)
    local u195 = {};

    for _, v in u7 do
        table.insert(u195, v);
    end;

    local u196 = {};
    local success, result = pcall(function() -- Line: 1122
        -- upvalues: ContentProvider (ref), u195 (copy), u196 (copy)
        ContentProvider:PreloadAsync(u195, function(p197, p198) -- Line: 1123
            -- upvalues: u196 (ref)
            if p198 == Enum.AssetFetchStatus.Failure or p198 == Enum.AssetFetchStatus.TimedOut then
                table.insert(u196, p197);
            end;
        end);
    end);

    if success then
        if #u196 > 0 then
            warn((`[EggEffect] {#u196} egg-open sound(s) failed to preload: {table.concat(u196, ", ")}`));
        end;

        return;
    end;

    warn((`[EggEffect] Sound preload errored: {result}`));
end);

return u1;