-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local Other = ReplicatedStorage.Assets.Other;
local Character = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("MuzzleFlashes"):WaitForChild("Character");
require(ReplicatedStorage.Database.Custom.Types);
require(script:WaitForChild("Types"));
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local GetMuzzleFlash = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.GetMuzzleFlash);
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Attachments = require(ReplicatedStorage.Database.Custom.GameStats.Character.Attachments);
local u1 = { "PrimaryAttachment", "SecondaryAttachment", "MeleeAttachment" };
local u2 = {
    MuzzlePartL = 1,
    MuzzlePartR = 1,
    MuzzlePart = 1,
    RootPart = 1,
    Hitbox = 1,
    Insert = 1,
    move = 1
};
local u3 = CFrame.new(0, -0.4, 0.24) * CFrame.Angles(0, 3.141592653589793, 0);
local u4 = CFrame.new(0, 0.2, 0.8) * CFrame.Angles(1.5707963267948966, 0.20943951023931956, 0.17453292519943295);
local u5 = {};
local u6 = {};

local function dlog(p7, p8, ...) -- Line: 67
    -- upvalues: DebugFlags (copy)
    if not DebugFlags.IsEnabled("ThirdPersonWeaponModels") then
        return;
    end;

    warn((not p7 and "[ThirdPersonWeaponModels] " or "[ThirdPersonWeaponModels] " .. p7.Name .. " - ") .. p8:format(...));
end;

local function destroyInstance(p9) -- Line: 77
    if not p9 then
        return;
    end;

    p9:Destroy();
end;

local function IsWeaponEquippedInHand(p10, p11, p12) -- Line: 86
    local v13;

    if p10 == p12.Name then
        v13 = p11 == p12.Skin;
    else
        v13 = false;
    end;

    return v13;
end;

local function GetCharacterData(p14) -- Line: 92
    -- upvalues: u5 (copy)
    local v15 = u5[p14] or {
        Character = nil
    };
    u5[p14] = v15;

    return v15;
end;

local function GetCharacterAttachmentPart(p16, p17) -- Line: 100
    -- upvalues: u1 (copy)
    local v18 = u1[p16];

    if v18 then
        return p17:FindFirstChild(v18, true);
    end;

    return nil;
end;

local function GetJointPart(p19, p20) -- Line: 110
    -- upvalues: Attachments (copy)
    local v21 = Attachments.WEAPON_JOINT_PARTS[p19] or Attachments.DEFAULT_JOINT_PART;
    local v22 = p20:WaitForChild(v21, 10);
    local v23 = `Failed to get joint part: {v21} for weapon: {p19}`;
    assert(v22, v23);

    return v22;
end;

local function GetUpperTorso(p24) -- Line: 119
    local HumanoidRootPart = p24:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        local HumanoidRootPart2 = p24:WaitForChild("HumanoidRootPart", 10);

        if not (HumanoidRootPart2 and HumanoidRootPart2:IsA("BasePart")) then
            return nil;
        end;
    end;

    local UpperTorso = p24:FindFirstChild("UpperTorso");

    if UpperTorso and UpperTorso:IsA("BasePart") then
        return UpperTorso;
    end;

    local UpperTorso2 = p24:WaitForChild("UpperTorso", 10);

    if UpperTorso2 and UpperTorso2:IsA("BasePart") then
        return UpperTorso2;
    end;

    return nil;
end;

local function SetWeaponProperties(p25) -- Line: 143
    for _, descendant in ipairs(p25:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CollisionGroup = "WeaponModel";
            descendant.CastShadow = false;
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = false;
            descendant.Anchored = false;
            descendant.Massless = true;
        end;
    end;
end;

local function HideInvisibleParts(p26) -- Line: 159
    -- upvalues: u2 (copy)
    for i, v in pairs(u2) do
        local v27 = p26:FindFirstChild(i, true);

        if v27 then
            v27.Transparency = v;
        end;
    end;
end;

local function SetupMuzzleFlashPart(p28, p29) -- Line: 172
    -- upvalues: GetMuzzleFlash (copy), Character (copy)
    if not (p28 and p29.MuzzleType) then
        return;
    end;

    GetMuzzleFlash(p28, Character, p29.MuzzleType, "WeldConstraint");

    if p29.HasSuppressor then
        GetMuzzleFlash(p28, Character, "Suppressor", "WeldConstraint");
    end;
end;

local function SetModelVisible(p30, p31) -- Line: 185
    -- upvalues: HideInvisibleParts (copy)
    for _, descendant in ipairs(p30:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Transparency = p31 and 0 or 1;
        end;
    end;

    HideInvisibleParts(p30);
end;

local function CreateWeldForWeapon(p32, u33) -- Line: 198
    local Parent = u33.Parent;

    if not (Parent and Parent:IsA("BasePart")) then
        error((`Character attachment parent is not a BasePart: {u33.Name}`));
    end;

    local u34 = p32:FindFirstChild("Insert", true) or p32.PrimaryPart;

    if not u34 then
        error("Weapon model has no PrimaryPart or Insert part");
    end;

    local WeaponAttachment = u34:FindFirstChild("WeaponAttachment");

    if not WeaponAttachment then
        WeaponAttachment = Instance.new("Attachment");
        WeaponAttachment.Name = "WeaponAttachment";
        WeaponAttachment.Parent = u34;
    end;

    p32:PivotTo(Parent.CFrame * u33.CFrame * WeaponAttachment.CFrame:Inverse() * u34.CFrame:Inverse() * p32:GetPivot());
    local success, result = pcall(function() -- Line: 228
        -- upvalues: u34 (copy), u33 (copy), WeaponAttachment (copy)
        local AttachmentConstraint = Instance.new("AttachmentConstraint");
        AttachmentConstraint.Parent = u34;
        AttachmentConstraint.Attachment0 = u33;
        AttachmentConstraint.Attachment1 = WeaponAttachment;

        return AttachmentConstraint;
    end);

    if not success then
        result = Instance.new("WeldConstraint");
        result.Parent = u34;
        result.Part0 = Parent;
        result.Part1 = u34;
    end;

    return result;
end;

local function GetPlayerAttachmentsFolder(p35) -- Line: 251
    local Debris = workspace:FindFirstChild("Debris");

    if not Debris then
        return nil;
    end;

    local v36 = p35.Name .. "_WeaponAttachments";
    local v37 = Debris:FindFirstChild(v36);

    if not v37 then
        v37 = Instance.new("Folder");
        v37.Name = v36;
        v37.Parent = Debris;
    end;

    v37:SetAttribute("PersistentDebris", true);

    return v37;
end;

local function ToModelWithPrimaryPart(p38) -- Line: 272
    local v39 = p38:Clone();

    if v39:IsA("BasePart") then
        local Model = Instance.new("Model");
        v39.Parent = Model;
        Model.PrimaryPart = v39;

        return Model, v39;
    end;

    if v39:IsA("Model") then
        local v40 = v39.PrimaryPart or v39:FindFirstChildWhichIsA("BasePart", true);

        if v40 then
            if not v39.PrimaryPart then
                v39.PrimaryPart = v40;
            end;

            return v39, v40;
        end;

        if v39 then
            v39:Destroy();
        end;

        return nil, nil;
    end;

    local Model = Instance.new("Model");
    v39.Parent = Model;
    local v41 = Model:FindFirstChildWhichIsA("BasePart", true);

    if v41 then
        Model.PrimaryPart = v41;

        return Model, v41;
    end;

    if Model then
        Model:Destroy();
    end;

    return nil, nil;
end;

local function GetObjectiveKitAttachmentOffset(p42) -- Line: 309
    -- upvalues: u3 (copy)
    local BodyBackAttachment = p42:FindFirstChild("BodyBackAttachment", true);

    if BodyBackAttachment and BodyBackAttachment:IsA("Attachment") then
        return BodyBackAttachment.CFrame * u3;
    end;

    return u3;
end;

local function GetOrCreateObjectiveKitAttachment(p43) -- Line: 320
    -- upvalues: u3 (copy), GetUpperTorso (copy)
    local BodyBackAttachment = p43:FindFirstChild("BodyBackAttachment", true);
    local v44;

    if BodyBackAttachment and BodyBackAttachment:IsA("Attachment") then
        v44 = BodyBackAttachment.CFrame * u3;
    else
        v44 = u3;
    end;

    local ObjectiveKitAttachment = p43:FindFirstChild("ObjectiveKitAttachment", true);

    if ObjectiveKitAttachment and ObjectiveKitAttachment:IsA("Attachment") then
        ObjectiveKitAttachment.CFrame = v44;

        return ObjectiveKitAttachment;
    end;

    local v45 = GetUpperTorso(p43);

    if not v45 then
        return nil;
    end;

    local Attachment = Instance.new("Attachment");
    Attachment.Name = "ObjectiveKitAttachment";
    Attachment.CFrame = v44;
    Attachment.Parent = v45;

    return Attachment;
end;

local function CreateObjectiveKitHolsterModel(p46, p47) -- Line: 343
    -- upvalues: Other (copy), dlog (copy), GetOrCreateObjectiveKitAttachment (copy), ToModelWithPrimaryPart (copy), SetWeaponProperties (copy), HideInvisibleParts (copy), CreateWeldForWeapon (copy), GetPlayerAttachmentsFolder (copy)
    local DefuseKit = Other:FindFirstChild("DefuseKit");

    if not DefuseKit then
        dlog(p46, "objective kit holster skipped: missing template Assets.Other.DefuseKit");

        return nil;
    end;

    local v48 = GetOrCreateObjectiveKitAttachment(p47);

    if not v48 then
        dlog(p46, "objective kit holster skipped: no valid character attachment");

        return nil;
    end;

    local v49 = ToModelWithPrimaryPart(DefuseKit);

    if not v49 then
        dlog(p46, "objective kit holster skipped: template has no BasePart");

        return nil;
    end;

    SetWeaponProperties(v49);
    HideInvisibleParts(v49);
    CreateWeldForWeapon(v49, v48);
    local v50 = GetPlayerAttachmentsFolder(p46);

    if not v50 then
        if v49 then
            v49:Destroy();
        end;

        return nil;
    end;

    v49.Name = "ObjectiveKitHolster";
    v49.Parent = v50;

    return v49;
end;

local function DestroyObjectiveKitHolster(p51) -- Line: 379
    if p51.ObjectiveKitHolsterModel then
        local ObjectiveKitHolsterModel = p51.ObjectiveKitHolsterModel;

        if ObjectiveKitHolsterModel then
            ObjectiveKitHolsterModel:Destroy();
        end;

        p51.ObjectiveKitHolsterModel = nil;
    end;
end;

local function ShouldShowObjectiveKitHolster(p52) -- Line: 388
    if p52:GetAttribute("Team") == "Counter-Terrorists" then
        return p52:GetAttribute("HasDefuseKit") == true and true or p52:GetAttribute("HasRescueKit") == true;
    end;

    return false;
end;

local function UpdateObjectiveKitHolster(p53, p54) -- Line: 398
    -- upvalues: u5 (copy), CreateObjectiveKitHolsterModel (copy)
    local v55 = u5[p53] or {
        Character = nil
    };
    u5[p53] = v55;
    local v56;

    if p53:GetAttribute("Team") == "Counter-Terrorists" then
        v56 = p53:GetAttribute("HasDefuseKit") == true and true or p53:GetAttribute("HasRescueKit") == true;
    else
        v56 = false;
    end;

    if not v56 then
        if v55.ObjectiveKitHolsterModel then
            local ObjectiveKitHolsterModel = v55.ObjectiveKitHolsterModel;

            if ObjectiveKitHolsterModel then
                ObjectiveKitHolsterModel:Destroy();
            end;

            v55.ObjectiveKitHolsterModel = nil;
        end;

        return;
    end;

    local ObjectiveKitHolsterModel = v55.ObjectiveKitHolsterModel;

    if ObjectiveKitHolsterModel and ObjectiveKitHolsterModel.Parent then
        return;
    end;

    if v55.ObjectiveKitHolsterModel then
        local ObjectiveKitHolsterModel2 = v55.ObjectiveKitHolsterModel;

        if ObjectiveKitHolsterModel2 then
            ObjectiveKitHolsterModel2:Destroy();
        end;

        v55.ObjectiveKitHolsterModel = nil;
    end;

    v55.ObjectiveKitHolsterModel = CreateObjectiveKitHolsterModel(p53, p54);
end;

local function GetOrCreateBombAttachment(p57) -- Line: 417
    -- upvalues: u4 (copy), GetUpperTorso (copy)
    local BombAttachment = p57:FindFirstChild("BombAttachment", true);

    if BombAttachment and BombAttachment:IsA("Attachment") then
        BombAttachment.CFrame = u4;

        return BombAttachment;
    end;

    local v58 = GetUpperTorso(p57);

    if not v58 then
        return nil;
    end;

    local Attachment = Instance.new("Attachment");
    Attachment.Name = "BombAttachment";
    Attachment.CFrame = u4;
    Attachment.Parent = v58;

    return Attachment;
end;

local function CreateBombHolsterModel(p59, p60) -- Line: 440
    -- upvalues: dlog (copy), HttpService (copy), GetOrCreateBombAttachment (copy), Skins (copy), SetWeaponProperties (copy), HideInvisibleParts (copy), CreateWeldForWeapon (copy), GetPlayerAttachmentsFolder (copy)
    local v61 = p59:GetAttribute("Slot5");

    if not v61 then
        dlog(p59, "bomb holster skipped: no Slot5 attribute");

        return nil;
    end;

    local v62 = HttpService:JSONDecode(v61);

    if not v62 or v62.Weapon ~= "C4" then
        dlog(p59, "bomb holster skipped: Slot5 does not contain C4");

        return nil;
    end;

    local v63 = GetOrCreateBombAttachment(p60);

    if not v63 then
        dlog(p59, "bomb holster skipped: no valid character attachment (missing UpperTorso)");

        return nil;
    end;

    local v64 = Skins.GetCharacterModel("C4", v62.Skin or "", v62.Float, v62.StatTrack, v62.NameTag, false, v62.Stickers);

    if not v64 then
        dlog(p59, "bomb holster skipped: SkinHandler returned nil for C4");

        return nil;
    end;

    SetWeaponProperties(v64);
    HideInvisibleParts(v64);
    CreateWeldForWeapon(v64, v63);
    local v65 = GetPlayerAttachmentsFolder(p59);

    if not v65 then
        if v64 then
            v64:Destroy();
        end;

        return nil;
    end;

    v64.Name = "BombHolster";
    v64.Parent = v65;

    return v64;
end;

local function DestroyBombHolster(p66) -- Line: 493
    if p66.BombHolsterModel then
        local BombHolsterModel = p66.BombHolsterModel;

        if BombHolsterModel then
            BombHolsterModel:Destroy();
        end;

        p66.BombHolsterModel = nil;
    end;
end;

local function UpdateBombHolster(p67, p68, p69) -- Line: 502
    -- upvalues: u5 (copy), HttpService (copy), CreateBombHolsterModel (copy), SetModelVisible (copy)
    local v70 = u5[p67] or {
        Character = nil
    };
    u5[p67] = v70;
    local v71 = p67:GetAttribute("Slot5");
    local v72;

    if v71 then
        v72 = HttpService:JSONDecode(v71);

        if v72 then
            v72 = v72.Weapon == "C4";
        end;
    else
        v72 = false;
    end;

    if not v72 then
        if v70.BombHolsterModel then
            local BombHolsterModel = v70.BombHolsterModel;

            if BombHolsterModel then
                BombHolsterModel:Destroy();
            end;

            v70.BombHolsterModel = nil;
        end;

        return;
    end;

    if p69 then
        p69 = p69.Name == "C4";
    end;

    local BombHolsterModel = v70.BombHolsterModel;

    if not (BombHolsterModel and BombHolsterModel.Parent) then
        if v70.BombHolsterModel then
            local BombHolsterModel2 = v70.BombHolsterModel;

            if BombHolsterModel2 then
                BombHolsterModel2:Destroy();
            end;

            v70.BombHolsterModel = nil;
        end;

        BombHolsterModel = CreateBombHolsterModel(p67, p68);
        v70.BombHolsterModel = BombHolsterModel;
    end;

    if BombHolsterModel then
        SetModelVisible(BombHolsterModel, not p69);
    end;
end;

local function CacheWeaponCharacterModel(p73, p74, p75, p76, p77, p78, p79, p80, p81, p82) -- Line: 538
    -- upvalues: Skins (copy), dlog (copy), SetWeaponProperties (copy), HideInvisibleParts (copy), u1 (copy), CreateWeldForWeapon (copy), GetPlayerAttachmentsFolder (copy), u5 (copy)
    local v83 = nil;
    local v84;

    if p76 == "Smoke Grenade" then
        v84 = p73:GetAttribute("Team");

        if v84 ~= "Counter-Terrorists" and v84 ~= "Terrorists" then
            v84 = v83;
        end;
    else
        v84 = v83;
    end;

    local v85 = Skins.GetCharacterModel(p76, p77, p78, p79, p80, false, p82, v84);

    if not v85 then
        dlog(p73, "holster skipped: SkinHandler returned nil for slot=%d weapon=%s skin=%s", p75, p76, p77);

        return nil;
    end;

    SetWeaponProperties(v85);
    HideInvisibleParts(v85);
    local v86 = u1[p75];
    local v87;

    if v86 then
        v87 = p74:FindFirstChild(v86, true);
    else
        v87 = nil;
    end;

    if not v87 then
        dlog(p73, "missing character attachment for slot=%d weapon=%s (expected %s)", p75, p76, (tostring(u1[p75])));
        error((`Missing character attachment for slot: {p75}`));
    end;

    CreateWeldForWeapon(v85, v87);
    local v88 = GetPlayerAttachmentsFolder(p73);

    if v88 then
        v85.Parent = v88;
        v85.Name = p76;
    end;

    local v89 = u5[p73] or {
        Character = nil
    };
    u5[p73] = v89;
    v89[p75] = {
        StatTrack = p79,
        Stickers = p82,
        NameTag = p80,
        Model = v85,
        Float = p78,
        Charm = p81,
        Weapon = p76,
        Skin = p77
    };
    dlog(p73, "cached holster slot=%d weapon=%s skin=%s visible=%s", p75, p76, p77, "unknown");

    return v85;
end;

local function ClearPlayerCache(p90) -- Line: 631
    -- upvalues: u6 (copy), u5 (copy), dlog (copy)
    local v91 = u6[p90];

    if v91 then
        v91:Disconnect();
        u6[p90] = nil;
    end;

    local v92 = u5[p90];

    if not v92 then
        return;
    end;

    if v92.ObjectiveKitHolsterModel then
        local ObjectiveKitHolsterModel = v92.ObjectiveKitHolsterModel;

        if ObjectiveKitHolsterModel then
            ObjectiveKitHolsterModel:Destroy();
        end;

        v92.ObjectiveKitHolsterModel = nil;
    end;

    if v92.BombHolsterModel then
        local BombHolsterModel = v92.BombHolsterModel;

        if BombHolsterModel then
            BombHolsterModel:Destroy();
        end;

        v92.BombHolsterModel = nil;
    end;

    for i, v in pairs(v92) do
        if v and (typeof(i) == "number" and typeof(v) == "table") then
            local Model = v.Model;

            if Model then
                Model:Destroy();
            end;

            v92[i] = nil;
        end;
    end;

    local Debris = workspace:FindFirstChild("Debris");

    if Debris then
        local v93 = Debris:FindFirstChild(p90.Name .. "_Weapon");

        if v93 then
            v93:Destroy();
        end;

        local v94 = Debris:FindFirstChild(p90.Name .. "_WeaponAttachments");

        if v94 then
            v94:Destroy();
        end;
    end;

    dlog(p90, "cleared player cache (destroyed holsters)");
    u5[p90] = nil;
end;

local function InitializePlayerCache(u95, p96) -- Line: 665
    -- upvalues: u5 (copy), ClearPlayerCache (copy), u6 (copy)
    local v97 = u5[u95] or {
        Character = nil
    };
    u5[u95] = v97;

    if v97.Character == p96 then
        return;
    end;

    if v97.Character then
        ClearPlayerCache(u95);
        v97 = u5[u95] or {
            Character = nil
        };
        u5[u95] = v97;
    end;

    v97.Character = p96;
    local v98 = u6[u95];

    if v98 then
        v98:Disconnect();
    end;

    u6[u95] = p96.AncestryChanged:Connect(function(p99, p100) -- Line: 682
        -- upvalues: u95 (copy), u5 (ref)
        if not p100 or p100.Name == "Debris" then
            local Debris = workspace:FindFirstChild("Debris");

            if Debris then
                local v101 = Debris:FindFirstChild(u95.Name .. "_Weapon");

                if v101 then
                    v101:Destroy();
                end;

                local v102 = Debris:FindFirstChild(u95.Name .. "_WeaponAttachments");

                if v102 then
                    v102:Destroy();
                end;
            end;

            local v103 = u5[u95];

            if v103 then
                v103.ObjectiveKitHolsterModel = nil;
                v103.BombHolsterModel = nil;

                for i, v in pairs(v103) do
                    if v and (typeof(i) == "number" and typeof(v) == "table") then
                        v103[i] = nil;
                    end;
                end;

                v103.Character = nil;
            end;
        end;
    end);
end;

local function UpdateCachedWeapon(p104, p105, p106, p107, p108) -- Line: 712
    -- upvalues: GetWeaponProperties (copy), u5 (copy), SetModelVisible (copy), dlog (copy), CacheWeaponCharacterModel (copy)
    local v109 = GetWeaponProperties(p107.Weapon);

    if v109 and v109.ShootingOptions == "Dual" then
        return;
    end;

    local v110 = u5[p104] or {
        Character = nil
    };
    u5[p104] = v110;
    local v111 = v110[p106];

    if v111 then
        if v111.Skin == p107.Skin and (v111.Weapon == p107.Weapon and v111.Model) then
            local Skin = v111.Skin;
            local v112;

            if v111.Weapon == p108.Name then
                v112 = Skin == p108.Skin;
            else
                v112 = false;
            end;

            SetModelVisible(v111.Model, not v112);

            return;
        end;

        local v113 = v111.Model and v111.Model;

        if v113 then
            v113:Destroy();
        end;
    end;

    v110[p106] = nil;
    local Skin = p107.Skin;
    local v114;

    if p107.Weapon == p108.Name then
        v114 = Skin == p108.Skin;
    else
        v114 = false;
    end;

    dlog(p104, "holster slot=%d weapon=%s skin=%s equippedInHand=%s", p106, p107.Weapon, p107.Skin, (tostring(v114)));
    local v115 = CacheWeaponCharacterModel(p104, p105, p106, p107.Weapon, p107.Skin, p107.Float, p107.StatTrack, p107.NameTag, p107.Charm, p107.Stickers);

    if v115 then
        SetModelVisible(v115, not v114);
    end;
end;

local function RemoveCachedWeapon(p116, p117) -- Line: 779
    -- upvalues: u5 (copy)
    local v118 = u5[p116];
    local v119 = v118 and v118[p117];

    if v119 then
        local Model = v119.Model;

        if Model and Model then
            Model:Destroy();
        end;

        v118[p117] = nil;
    end;
end;

local function CreateCharacterWeapons(p120, p121, p122, p123) -- Line: 798
    -- upvalues: InitializePlayerCache (copy), u5 (copy), UpdateCachedWeapon (copy), UpdateObjectiveKitHolster (copy), UpdateBombHolster (copy)
    InitializePlayerCache(p120, p121);

    if not p123[1] then
        local v124 = u5[p120];
        local v125 = v124 and v124[1];

        if v125 then
            local Model = v125.Model;

            if Model and Model then
                Model:Destroy();
            end;

            v124[1] = nil;
        end;
    end;

    if not p123[2] then
        local v126 = u5[p120];
        local v127 = v126 and v126[2];

        if v127 then
            local Model = v127.Model;

            if Model and Model then
                Model:Destroy();
            end;

            v126[2] = nil;
        end;
    end;

    if not p123[3] then
        local v128 = u5[p120];
        local v129 = v128 and v128[3];

        if v129 then
            local Model = v129.Model;

            if Model and Model then
                Model:Destroy();
            end;

            v128[3] = nil;
        end;
    end;

    for i, v in pairs(p123) do
        if v then
            UpdateCachedWeapon(p120, p121, i, v, p122);
        end;
    end;

    UpdateObjectiveKitHolster(p120, p121);
    UpdateBombHolster(p120, p121, p122);
end;

local function SetupSuppressorState(p130, p131, p132) -- Line: 828
    local Silencer = p130:FindFirstChild("Silencer", true);

    if not (Silencer and p131.HasSuppressor) then
        return;
    end;

    Silencer.Transparency = p132 and 0 or 1;
end;

local function CreateMotor6DAttachment(p133, p134, p135) -- Line: 839
    local Motor6D = Instance.new("Motor6D");
    Motor6D.Name = "WeaponAttachment" .. (p135 or "");
    Motor6D.Parent = p133;
    Motor6D.Part0 = p133;
    Motor6D.Part1 = p135 and p134:FindFirstChild(p135, true) or p134.PrimaryPart;
    local Properties = p134:FindFirstChild("Properties");

    if Properties then
        for _, v in ipairs(p135 and { "LEFT", "RIGHT" } or { "" }) do
            local v136 = Properties:FindFirstChild("C0" .. v);

            if v136 then
                Motor6D.C0 = v136.Value;
            end;

            local v137 = Properties:FindFirstChild("C1" .. v);

            if v137 then
                Motor6D.C1 = v137.Value;
            end;
        end;
    end;

    return Motor6D;
end;

local function CreateDualMotor6DAttachments(p138, p139) -- Line: 873
    -- upvalues: CreateMotor6DAttachment (copy)
    local RightHand = p138:FindFirstChild("RightHand");
    local LeftHand = p138:FindFirstChild("LeftHand");

    if not (RightHand and LeftHand) then
        warn("CreateDualMotor6DAttachments: Could not find RightHand or LeftHand for dual weapon");

        return;
    end;

    CreateMotor6DAttachment(RightHand, p139, "HandleR");
    CreateMotor6DAttachment(LeftHand, p139, "HandleL");
end;

local function CleanupPreviousWeapon(p140, p141, p142) -- Line: 892
    local WeaponAttachment = p142:FindFirstChild("WeaponAttachment");
    p141:ClearAllChildren();
    local Debris = workspace:FindFirstChild("Debris");

    if Debris then
        local v143 = Debris:FindFirstChild(p140.Name .. "_Weapon");

        if v143 and v143 then
            v143:Destroy();
        end;
    end;

    if WeaponAttachment and WeaponAttachment then
        WeaponAttachment:Destroy();
    end;

    local WeaponAttachmentHandleR = p142:FindFirstChild("WeaponAttachmentHandleR");

    if WeaponAttachmentHandleR then
        if not WeaponAttachmentHandleR then
            return;
        end;

        WeaponAttachmentHandleR:Destroy();
    end;
end;

local function CreateEquippedWeapon(p144, p145, p146) -- Line: 918
    -- upvalues: Attachments (copy), GetWeaponProperties (copy), CleanupPreviousWeapon (copy), Skins (copy), dlog (copy), SetWeaponProperties (copy), HideInvisibleParts (copy), GetMuzzleFlash (copy), Character (copy), CreateDualMotor6DAttachments (copy), CreateMotor6DAttachment (copy)
    local Parent = p145.Parent;

    if not Parent or Parent.Name == "Debris" then
        return nil, nil;
    end;

    local Name = p146.Name;
    local v147 = Attachments.WEAPON_JOINT_PARTS[Name] or Attachments.DEFAULT_JOINT_PART;
    local v148 = p145:WaitForChild(v147, 10);
    local v149 = `Failed to get joint part: {v147} for weapon: {Name}`;
    assert(v148, v149);
    local v150 = GetWeaponProperties(p146.Name);

    if not v150 then
        return nil, nil;
    end;

    local WeaponModel = p145:FindFirstChild("WeaponModel");

    if not WeaponModel then
        return nil, nil;
    end;

    CleanupPreviousWeapon(p144, WeaponModel, v148);
    local LeftHand = p145:FindFirstChild("LeftHand");

    if LeftHand then
        local WeaponAttachmentHandleL = LeftHand:FindFirstChild("WeaponAttachmentHandleL");

        if WeaponAttachmentHandleL and WeaponAttachmentHandleL then
            WeaponAttachmentHandleL:Destroy();
        end;
    end;

    local v151 = nil;
    local v152;

    if p146.Name == "Smoke Grenade" then
        v152 = p144:GetAttribute("Team");

        if v152 ~= "Counter-Terrorists" and v152 ~= "Terrorists" then
            v152 = v151;
        end;
    else
        v152 = v151;
    end;

    local v153 = Skins.GetCharacterModel(p146.Name, p146.Skin, p146.Float, p146.StatTrack, p146.NameTag, false, p146.Stickers, v152);

    if not v153 then
        dlog(p144, "equipped weapon skipped: SkinHandler returned nil for weapon=%s skin=%s", p146.Name, p146.Skin);

        return nil, nil;
    end;

    SetWeaponProperties(v153);
    HideInvisibleParts(v153);
    local IsSuppressed = p146.IsSuppressed;
    local Silencer = v153:FindFirstChild("Silencer", true);

    if Silencer and v150.HasSuppressor then
        Silencer.Transparency = IsSuppressed and 0 or 1;
    end;

    local v154 = v150.MuzzleType and v153:FindFirstChild("Interactables");

    if v150.ShootingOptions == "Dual" then
        if v154 then
            local MuzzlePartL = v154:FindFirstChild("MuzzlePartL");

            if MuzzlePartL and v150.MuzzleType then
                GetMuzzleFlash(MuzzlePartL, Character, v150.MuzzleType, "WeldConstraint");

                if v150.HasSuppressor then
                    GetMuzzleFlash(MuzzlePartL, Character, "Suppressor", "WeldConstraint");
                end;
            end;

            local MuzzlePartR = v154:FindFirstChild("MuzzlePartR");

            if MuzzlePartR and v150.MuzzleType then
                GetMuzzleFlash(MuzzlePartR, Character, v150.MuzzleType, "WeldConstraint");

                if v150.HasSuppressor then
                    GetMuzzleFlash(MuzzlePartR, Character, "Suppressor", "WeldConstraint");
                end;
            end;
        end;

        CreateDualMotor6DAttachments(p145, v153);
    else
        if v154 then
            local MuzzlePart = v154:FindFirstChild("MuzzlePart");

            if MuzzlePart and v150.MuzzleType then
                GetMuzzleFlash(MuzzlePart, Character, v150.MuzzleType, "WeldConstraint");

                if v150.HasSuppressor then
                    GetMuzzleFlash(MuzzlePart, Character, "Suppressor", "WeldConstraint");
                end;
            end;
        end;

        CreateMotor6DAttachment(v148, v153, nil);
    end;

    local Debris = workspace:FindFirstChild("Debris");

    if Debris then
        v153.Parent = Debris;
        v153.Name = p144.Name .. "_Weapon";
        v153:SetAttribute("PersistentDebris", true);
    end;

    return v153, v148;
end;

local function u159(p155, p156, p157) -- Line: 1030
    -- upvalues: CreateEquippedWeapon (copy), CreateCharacterWeapons (copy), ClearPlayerCache (copy)
    local Character2 = p155.Character;

    if Character2 then
        local _, v158 = CreateEquippedWeapon(p155, Character2, p156);

        if v158 then
            CreateCharacterWeapons(p155, Character2, p156, p157);

            return v158, ClearPlayerCache;
        end;
    end;

    return nil, nil;
end;

local v161 = setmetatable({}, {
    __call = function(p160, ...) -- Line: 1082, Name: __call
        -- upvalues: u159 (copy)
        return u159(...);
    end
});
v161.ClearPlayerCache = ClearPlayerCache;

function v161.RefreshObjectiveKitHolster(p162) -- Line: 1050
    -- upvalues: InitializePlayerCache (copy), UpdateObjectiveKitHolster (copy)
    local Character2 = p162.Character;

    if not Character2 then
        return;
    end;

    InitializePlayerCache(p162, Character2);
    UpdateObjectiveKitHolster(p162, Character2);
end;

function v161.RefreshBombHolster(p163) -- Line: 1062
    -- upvalues: InitializePlayerCache (copy), HttpService (copy), UpdateBombHolster (copy)
    local Character2 = p163.Character;

    if not Character2 then
        return;
    end;

    InitializePlayerCache(p163, Character2);
    local v164 = p163:GetAttribute("CurrentEquipped");
    local v165;

    if v164 then
        v165 = HttpService:JSONDecode(v164);
    else
        v165 = nil;
    end;

    UpdateBombHolster(p163, Character2, v165);
end;

Players.PlayerRemoving:Connect(function(p166) -- Line: 1091
    -- upvalues: ClearPlayerCache (copy)
    ClearPlayerCache(p166);
end);

return v161;