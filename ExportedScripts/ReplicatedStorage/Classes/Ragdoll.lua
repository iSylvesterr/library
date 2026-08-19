-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script:WaitForChild("Types"));
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Signal = require(ReplicatedStorage.Packages.Signal);
local PartMultipliers = require(script.Configuration.PartMultipliers);
local Debris = workspace:WaitForChild("Debris");
local DefaultRagdoll = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("DefaultRagdoll");
local u2 = table.freeze({
    Accessory = true,
    Shirt = true,
    Pants = true,
    ShirtGraphic = true,
    BodyColors = true,
    CharacterMesh = true,
    WrapLayer = true,
    WrapTarget = true
});

local function IsWarmupAndDeathmatch() -- Line: 56
    -- upvalues: GameState (copy)
    local v3;

    if GameState.GetState() == "Warmup" then
        v3 = workspace:GetAttribute("Gamemode") == "Deathmatch";
    else
        v3 = false;
    end;

    return v3;
end;

local function CleanupAttachments(p4) -- Line: 60
    -- upvalues: Debris (copy)
    for _, v in { `{p4.Name}_Weapon`, (`{p4.Name}_WeaponAttachments`) } do
        local v5 = Debris:FindFirstChild(v);

        if v5 then
            v5:Destroy();
        end;
    end;

    local CharacterModel = p4:FindFirstChild("CharacterModel");

    if CharacterModel then
        CharacterModel:Destroy();
    end;
end;

local function IsCharacterAccessoryPart(p6) -- Line: 74
    local v7;

    if p6 == nil then
        v7 = false;
    else
        v7 = p6:HasTag("CharacterAccessory");
    end;

    return v7;
end;

local function CopyPoseAndMomentum(p8, p9) -- Line: 78
    for _, child in p8:GetChildren() do
        if child:IsA("BasePart") and child.Name ~= "CollisionCapsule" then
            local v10;

            if child == nil then
                v10 = false;
            else
                v10 = child:HasTag("CharacterAccessory");
            end;

            if not v10 then
                local v11 = p9:FindFirstChild(child.Name);

                if v11 and (v11:IsA("BasePart") and not v11.Anchored) then
                    v11.CFrame = child.CFrame;
                    v11.AssemblyLinearVelocity = child.AssemblyLinearVelocity;
                    v11.AssemblyAngularVelocity = child.AssemblyAngularVelocity;
                end;
            end;
        end;
    end;
end;

local function ReapplyRagdollBodyCollisions(p12) -- Line: 104
    for _, v in p12:QueryDescendants("BasePart") do
        if not v:HasTag("CharacterAccessory") then
            v.CollisionGroup = "Debris";
            v.CanQuery = false;
            v.CanTouch = false;
        end;
    end;
end;

local function GetRelativePath(p13, p14) -- Line: 117
    local v15 = {};

    while p14 and p14 ~= p13 do
        table.insert(v15, 1, p14.Name);
        p14 = p14.Parent;
    end;

    if p14 == p13 then
        return v15;
    end;

    return nil;
end;

local function FindByRelativePath(p16, p17) -- Line: 133
    for _, v in p17 do
        p16 = p16:FindFirstChild(v);

        if not p16 then
            return nil;
        end;
    end;

    return p16;
end;

local function CloneCharacterArmor(p18, p19) -- Line: 146
    -- upvalues: GetRelativePath (copy)
    local CharacterArmor = p18:FindFirstChild("CharacterArmor");
    local CharacterArmor2 = p19:FindFirstChild("CharacterArmor");
    local v20 = {};

    if not CharacterArmor then
        return v20;
    end;

    if not CharacterArmor2 then
        CharacterArmor2 = Instance.new("Folder");
        CharacterArmor2.Name = "CharacterArmor";
        CharacterArmor2.Parent = p19;
    end;

    for _, child in CharacterArmor2:GetChildren() do
        child:Destroy();
    end;

    for _, child in CharacterArmor:GetChildren() do
        local v21 = child:Clone();

        if child:IsA("BasePart") and v21:IsA("BasePart") then
            v20[child] = v21;
            v21.Massless = true;
        end;

        for _, v in child:QueryDescendants("BasePart") do
            local v22 = GetRelativePath(child, v);

            if v22 then
                local v23 = v21;

                for _, v2 in v22 do
                    v21 = v21:FindFirstChild(v2);

                    if not v21 then
                        v21 = nil;
                        break;
                    end;
                end;

                if v21 and v21:IsA("BasePart") then
                    v20[v] = v21;
                    v21.Massless = true;
                    v21 = v23;
                else
                    v21 = v23;
                end;
            end;
        end;

        for _, v in v21:QueryDescendants("Weld, WeldConstraint, Motor6D") do
            v:Destroy();
        end;

        v21.Parent = CharacterArmor2;
    end;

    return v20;
end;

local function CopyPartVisuals(p24, p25) -- Line: 197
    for _, child in p24:GetChildren() do
        if child:IsA("BasePart") then
            local v26 = p25:FindFirstChild(child.Name);

            if v26 and v26:IsA("BasePart") then
                v26.Color = child.Color;

                for _, child2 in child:GetChildren() do
                    if child2:IsA("Decal") or child2:IsA("SurfaceAppearance") then
                        child2:Clone().Parent = v26;
                    end;
                end;
            end;
        end;
    end;
end;

local function CopyTopLevelAppearance(p27, p28) -- Line: 219
    -- upvalues: u2 (copy)
    for _, child in p27:GetChildren() do
        if u2[child.ClassName] then
            child:Clone().Parent = p28;
        end;
    end;
end;

local function ResolveWeldPart(p29, p30, p31, p32) -- Line: 229
    -- upvalues: GetRelativePath (copy)
    if not p29 then
        return nil;
    end;

    local v33 = p32[p29];

    if v33 then
        return v33;
    end;

    local v34 = GetRelativePath(p30, p29);

    if not v34 then
        return nil;
    end;

    for _, v in v34 do
        p31 = p31:FindFirstChild(v);

        if not p31 then
            p31 = nil;
            break;
        end;
    end;

    if p31 and p31:IsA("BasePart") then
        return p31;
    end;

    return nil;
end;

local function ReattachCharacterArmorWelds(p35, p36, p37) -- Line: 257
    -- upvalues: GetRelativePath (copy)
    local CharacterArmor = p35:FindFirstChild("CharacterArmor");

    local function IsCharacterArmorPart(p38) -- Line: 264
        -- upvalues: CharacterArmor (copy)
        local v39;

        if p38 == nil or CharacterArmor == nil then
            v39 = false;
        else
            v39 = p38:IsDescendantOf(CharacterArmor);
        end;

        return v39;
    end;

    local function CloneJoint(p40, p41, p42) -- Line: 268
        if not p40:IsA("Weld") then
            if not p40:IsA("WeldConstraint") then
                if p40:IsA("Motor6D") then
                    local v43 = p42:FindFirstChild(p40.Name);

                    if not (v43 and (v43:IsA("Motor6D") and v43)) then
                        v43 = Instance.new("Motor6D");
                    end;

                    v43.Name = p40.Name;
                    v43.C0 = p40.C0;
                    v43.C1 = p40.C1;
                    v43.Part0 = p41;
                    v43.Part1 = p42;
                    v43.Parent = p42;
                end;

                return;
            end;

            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Name = p40.Name;
            WeldConstraint.Part0 = p41;
            WeldConstraint.Part1 = p42;
            WeldConstraint.Parent = p41;

            return;
        end;

        local Weld = Instance.new("Weld");
        Weld.Name = p40.Name;
        Weld.C0 = p40.C0;
        Weld.C1 = p40.C1;
        Weld.Part0 = p41;
        Weld.Part1 = p42;
        Weld.Parent = p41;
    end;

    for _, v in p35:QueryDescendants("Weld, WeldConstraint, Motor6D") do
        local Part0 = v.Part0;
        local Part1 = v.Part1;
        local v44;

        if Part0 == nil or CharacterArmor == nil then
            v44 = false;
        else
            v44 = Part0:IsDescendantOf(CharacterArmor);
        end;

        local v45, v46, v47, v48, v49;

        if v44 then
            if Part0 then
                v45 = p37[Part0];

                if v45 then
                    v46 = p36;
                else
                    v47 = GetRelativePath(p35, Part0);

                    if v47 then
                        v46 = p36;

                        for _, v2 in v47 do
                            p36 = p36:FindFirstChild(v2);

                            if not p36 then
                                p36 = nil;
                                break;
                            end;
                        end;

                        if p36 and p36:IsA("BasePart") then
                            v45 = p36;
                        else
                            v45 = nil;
                        end;
                    else
                        v46 = p36;
                        v45 = nil;
                    end;
                end;
            else
                v46 = p36;
                v45 = nil;
            end;

            if Part1 then
                v48 = p37[Part1];

                if v48 then
                    p36 = v46;
                    v46 = v48;
                else
                    v49 = GetRelativePath(p35, Part1);

                    if v49 then
                        p36 = v46;

                        for _, v2 in v49 do
                            v46 = v46:FindFirstChild(v2);

                            if not v46 then
                                v46 = nil;
                                break;
                            end;
                        end;

                        if not (v46 and v46:IsA("BasePart")) then
                            v46 = nil;
                        end;
                    else
                        p36 = v46;
                        v46 = nil;
                    end;
                end;
            else
                p36 = v46;
                v46 = nil;
            end;

            if v45 and v46 then
                CloneJoint(v, v45, v46);
            end;
        else
            local v50;

            if Part1 == nil or CharacterArmor == nil then
                v50 = false;
            else
                v50 = Part1:IsDescendantOf(CharacterArmor);
            end;

            if v50 then
                if Part0 then
                    v45 = p37[Part0];

                    if v45 then
                        v46 = p36;
                    else
                        v47 = GetRelativePath(p35, Part0);

                        if v47 then
                            v46 = p36;

                            for _, v2 in v47 do
                                p36 = p36:FindFirstChild(v2);

                                if not p36 then
                                    p36 = nil;
                                    break;
                                end;
                            end;

                            if p36 and p36:IsA("BasePart") then
                                v45 = p36;
                            else
                                v45 = nil;
                            end;
                        else
                            v46 = p36;
                            v45 = nil;
                        end;
                    end;
                else
                    v46 = p36;
                    v45 = nil;
                end;

                if Part1 then
                    v48 = p37[Part1];

                    if v48 then
                        p36 = v46;
                        v46 = v48;
                    else
                        v49 = GetRelativePath(p35, Part1);

                        if v49 then
                            p36 = v46;

                            for _, v2 in v49 do
                                v46 = v46:FindFirstChild(v2);

                                if not v46 then
                                    v46 = nil;
                                    break;
                                end;
                            end;

                            if not (v46 and v46:IsA("BasePart")) then
                                v46 = nil;
                            end;
                        else
                            p36 = v46;
                            v46 = nil;
                        end;
                    end;
                else
                    p36 = v46;
                    v46 = nil;
                end;

                if v45 and v46 then
                    CloneJoint(v, v45, v46);
                end;
            else
                local v51;

                if Part0 == nil then
                    v51 = false;
                else
                    v51 = Part0:HasTag("CharacterAccessory");
                end;

                if v51 then
                    if Part0 then
                        v45 = p37[Part0];

                        if v45 then
                            v46 = p36;
                        else
                            v47 = GetRelativePath(p35, Part0);

                            if v47 then
                                v46 = p36;

                                for _, v2 in v47 do
                                    p36 = p36:FindFirstChild(v2);

                                    if not p36 then
                                        p36 = nil;
                                        break;
                                    end;
                                end;

                                if p36 and p36:IsA("BasePart") then
                                    v45 = p36;
                                else
                                    v45 = nil;
                                end;
                            else
                                v46 = p36;
                                v45 = nil;
                            end;
                        end;
                    else
                        v46 = p36;
                        v45 = nil;
                    end;

                    if Part1 then
                        v48 = p37[Part1];

                        if v48 then
                            p36 = v46;
                            v46 = v48;
                        else
                            v49 = GetRelativePath(p35, Part1);

                            if v49 then
                                p36 = v46;

                                for _, v2 in v49 do
                                    v46 = v46:FindFirstChild(v2);

                                    if not v46 then
                                        v46 = nil;
                                        break;
                                    end;
                                end;

                                if not (v46 and v46:IsA("BasePart")) then
                                    v46 = nil;
                                end;
                            else
                                p36 = v46;
                                v46 = nil;
                            end;
                        end;
                    else
                        p36 = v46;
                        v46 = nil;
                    end;

                    if v45 and v46 then
                        CloneJoint(v, v45, v46);
                    end;
                else
                    local v52;

                    if Part1 == nil then
                        v52 = false;
                    else
                        v52 = Part1:HasTag("CharacterAccessory");
                    end;

                    if v52 then
                        if Part0 then
                            v45 = p37[Part0];

                            if v45 then
                                v46 = p36;
                            else
                                v47 = GetRelativePath(p35, Part0);

                                if v47 then
                                    v46 = p36;

                                    for _, v2 in v47 do
                                        p36 = p36:FindFirstChild(v2);

                                        if not p36 then
                                            p36 = nil;
                                            break;
                                        end;
                                    end;

                                    if p36 and p36:IsA("BasePart") then
                                        v45 = p36;
                                    else
                                        v45 = nil;
                                    end;
                                else
                                    v46 = p36;
                                    v45 = nil;
                                end;
                            end;
                        else
                            v46 = p36;
                            v45 = nil;
                        end;

                        if Part1 then
                            v48 = p37[Part1];

                            if v48 then
                                p36 = v46;
                                v46 = v48;
                            else
                                v49 = GetRelativePath(p35, Part1);

                                if v49 then
                                    p36 = v46;

                                    for _, v2 in v49 do
                                        v46 = v46:FindFirstChild(v2);

                                        if not v46 then
                                            v46 = nil;
                                            break;
                                        end;
                                    end;

                                    if not (v46 and v46:IsA("BasePart")) then
                                        v46 = nil;
                                    end;
                                else
                                    p36 = v46;
                                    v46 = nil;
                                end;
                            end;
                        else
                            p36 = v46;
                            v46 = nil;
                        end;

                        if v45 and v46 then
                            CloneJoint(v, v45, v46);
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

local function CopyCharacterAppearance(p53, p54) -- Line: 321
    -- upvalues: CloneCharacterArmor (copy), CopyPartVisuals (copy), CopyTopLevelAppearance (copy), ReattachCharacterArmorWelds (copy)
    local v55 = CloneCharacterArmor(p53, p54);
    CopyPartVisuals(p53, p54);
    CopyTopLevelAppearance(p53, p54);
    ReattachCharacterArmorWelds(p53, p54, v55);
end;

function u1.Impulse(u56, p57) -- Line: 331
    -- upvalues: GetWeaponProperties (copy), PartMultipliers (copy), RunServiceController (copy)
    local v58 = u56.CharacterModel:FindFirstChild(p57.Part);

    if not v58 then
        return;
    end;

    local v59 = GetWeaponProperties(p57.Weapon);

    if not v59 then
        return;
    end;

    local v60 = (v59.RagdollMultiplier or 45) * p57.DirectionMultiplier;
    local v61;

    if PartMultipliers[p57.Part] then
        local v62 = PartMultipliers[p57.Part];
        v61 = v60 * (math.random(v62.Minimum, v62.Maximum) / 100);
    else
        v61 = v60;
    end;

    local Unit = p57.Direction.Unit;
    local v63 = 2.5 + (p57.Part == "Head" and 1 or 0);
    v58.AssemblyLinearVelocity = (Unit * v61 + Vector3.new(-0, -5, -0)) * v63;
    local v64 = (Unit * v60 + Vector3.new(-0, -5, -0)) * v63 * 0.1;

    for _, child in u56.CharacterModel:GetChildren() do
        if child:IsA("BasePart") and (child ~= v58 and not child.Anchored) then
            local v65;

            if child == nil then
                v65 = false;
            else
                v65 = child:HasTag("CharacterAccessory");
            end;

            if not v65 then
                child.AssemblyLinearVelocity = child.AssemblyLinearVelocity + v64;
            end;
        end;
    end;

    u56.Janitor:Add(task.delay(5, function() -- Line: 377
        -- upvalues: u56 (copy), RunServiceController (ref)
        local CharacterModel = u56.CharacterModel;

        if not (CharacterModel and (CharacterModel.PrimaryPart and CharacterModel.Parent)) then
            return;
        end;

        local u66 = CharacterModel:QueryDescendants("BasePart:not(.CharacterAccessory)");

        if not u66 or #u66 == 0 then
            return;
        end;

        local u67 = 0;
        local u68 = 0;

        local function AnchorAllParts() -- Line: 393
            -- upvalues: u66 (copy)
            for _, v in u66 do
                if v and v.Parent then
                    v.Anchored = true;
                end;
            end;
        end;

        local v69 = RunServiceController.CreateBindingName("Classes.Ragdoll.WaitForSettle");
        u56.Janitor:Add(RunServiceController.BindToHeartbeat(v69, function(p70) -- Line: 403
            -- upvalues: CharacterModel (copy), u56 (ref), u68 (ref), u66 (copy), u67 (ref)
            if not (CharacterModel and (CharacterModel.PrimaryPart and CharacterModel.Parent)) then
                u56.Janitor:Remove("WaitForSettle");

                return;
            end;

            u68 = u68 + p70;
            local v71 = 0;
            local v72 = true;

            for _, v in u66 do
                if v and v.Parent then
                    v71 = v71 + 1;

                    if not v.Anchored then
                        local v73;

                        if v.AssemblyLinearVelocity.Magnitude < 0.13 then
                            v73 = v.AssemblyAngularVelocity.Magnitude < 0.13;
                        else
                            v73 = false;
                        end;

                        if not v73 then
                            v72 = false;
                        end;
                    end;
                end;
            end;

            if v71 == 0 then
                u56.Janitor:Remove("WaitForSettle");

                return;
            end;

            if v72 then
                u67 = u67 + p70;
            else
                u67 = 0;
            end;

            if u67 < 0.2 and u68 < 2.5 then
                return;
            end;

            for _, v in u66 do
                if v and v.Parent then
                    v.Anchored = true;
                end;
            end;

            u56.Janitor:Remove("WaitForSettle");
        end), "Disconnect", "WaitForSettle");
    end));
end;

function u1.CloneCharacterModel(p74, p75) -- Line: 457
    -- upvalues: DefaultRagdoll (copy), CloneCharacterArmor (copy), CopyPartVisuals (copy), CopyTopLevelAppearance (copy), ReattachCharacterArmorWelds (copy), CleanupAttachments (copy), CopyPoseAndMomentum (copy), Debris (copy)
    local v76 = DefaultRagdoll:Clone();
    v76.Name = p75.Name;
    local v77 = CloneCharacterArmor(p75, v76);
    CopyPartVisuals(p75, v76);
    CopyTopLevelAppearance(p75, v76);
    ReattachCharacterArmorWelds(p75, v76, v77);
    CleanupAttachments(p75);
    v76:PivotTo(p75:GetPivot());
    CopyPoseAndMomentum(p75, v76);
    local v78 = v76:FindFirstChildOfClass("Humanoid");

    if v78 then
        v78.Sit = true;
        v78.PlatformStand = true;
    end;

    v76.Parent = Debris;
    v76:AddTag("Ragdoll");

    if p75.Parent then
        p75:Destroy();
    end;

    return v76;
end;

function u1.SetupCharacterAppearance(u79) -- Line: 485
    -- upvalues: ReapplyRagdollBodyCollisions (copy)
    for _, child in u79.CharacterModel:GetChildren() do
        if child:IsA("Accessory") or (child:IsA("Clothing") or child:IsA("ShirtGraphic")) then
            child.Parent = nil;
            task.defer(function() -- Line: 492
                -- upvalues: child (copy), u79 (copy)
                child.Parent = u79.CharacterModel;
            end);
        end;
    end;

    task.defer(function() -- Line: 500
        -- upvalues: u79 (copy), ReapplyRagdollBodyCollisions (ref)
        if not (u79.CharacterModel and u79.CharacterModel.Parent) then
            return;
        end;

        ReapplyRagdollBodyCollisions(u79.CharacterModel);
    end);
end;

function u1.new(p80, u81) -- Line: 512
    -- upvalues: u1 (copy), Janitor (copy), Signal (copy), GameState (copy)
    local u82 = setmetatable({}, u1);
    u82.Janitor = Janitor.new();
    u82.CharacterModel = u82.Janitor:Add(u82:CloneCharacterModel(p80));
    u82.OnDestroy = u82.Janitor:Add(Signal.new());
    u82.IsDestroyed = false;
    task.defer(function() -- Line: 528
        -- upvalues: GameState (ref), u82 (copy), u81 (copy)
        local v83;

        if GameState.GetState() == "Warmup" then
            v83 = workspace:GetAttribute("Gamemode") == "Deathmatch";
        else
            v83 = false;
        end;

        u82:SetupCharacterAppearance();
        u82:Impulse(u81);
        task.delay(v83 and 10 or 15, function() -- Line: 533
            -- upvalues: u82 (ref)
            u82:Destroy();
        end);
    end);

    return u82;
end;

function u1.Destroy(p84) -- Line: 546
    if not p84.IsDestroyed then
        p84.IsDestroyed = true;
        p84.OnDestroy:Fire();
        task.defer(p84.Janitor.Destroy, p84.Janitor);
    end;
end;

return u1;