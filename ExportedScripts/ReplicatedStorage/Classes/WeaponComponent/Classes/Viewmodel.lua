-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ReplicatedFirst = game:GetService("ReplicatedFirst");
local HttpService = game:GetService("HttpService");
require(script:WaitForChild("Types"));
local Camera = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("MuzzleFlashes"):WaitForChild("Camera");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GetMuzzleFlash = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.GetMuzzleFlash);
local AttachGlovesToViewmodel = require(ReplicatedStorage.Database.Components.Common.AttachGlovesToViewmodel);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Sound = require(ReplicatedStorage.Classes.Sound);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Animation = require(script.Classes.Animation);
local Bobble = require(script.Classes.Bobble);
local CurrentCamera = workspace.CurrentCamera;

local function updateTransparency(p2, p3) -- Line: 51
    local v4 = p2:GetDescendants();

    for _, v in ipairs(v4) do
        if v:IsA("BasePart") then
            local v5 = v:GetAttribute("HiddenTransparency");

            if p3 then
                local Transparency = v.Transparency;
                v.Transparency = 1;

                if not v5 then
                    v:SetAttribute("HiddenTransparency", Transparency);
                end;
            elseif v5 then
                v.Transparency = v5;
            end;
        elseif v:IsA("Texture") then
            if p3 then
                if v.Transparency < 1 then
                    v:SetAttribute("HiddenTransparency", v.Transparency);
                    v.Transparency = 1;
                end;
            else
                local v6 = v:GetAttribute("HiddenTransparency");

                if v6 ~= nil then
                    v.Transparency = v6;
                    v:SetAttribute("HiddenTransparency", nil);
                end;
            end;
        end;
    end;
end;

local function setupMuzzleFlashPart(p7, p8) -- Line: 91
    -- upvalues: GetMuzzleFlash (copy), Camera (copy)
    if not (p7 and p8.MuzzleType) then
        return;
    end;

    GetMuzzleFlash(p7, Camera, p8.MuzzleType, "Motor6D");

    if p8.HasSuppressor then
        GetMuzzleFlash(p7, Camera, "Suppressor", "Motor6D");
    end;
end;

local function toggleScopeVisibility(p9, p10) -- Line: 104
    for _, descendant in pairs(p9:GetDescendants()) do
        if descendant:IsA("MeshPart") then
            descendant.Transparency = p10 == true and 0 or 1;
        elseif descendant:IsA("SurfaceGui") then
            descendant.Enabled = p10;
        end;
    end;
end;

local function getChargeFillFrame(p11) -- Line: 116
    if not p11 then
        return nil;
    end;

    local Interactables = p11:FindFirstChild("Interactables");

    if Interactables then
        Interactables = Interactables:FindFirstChild("Charge", true);
    end;

    if Interactables then
        Interactables = Interactables:FindFirstChildOfClass("SurfaceGui");
    end;

    if not Interactables then
        return nil;
    end;

    local Frame = Interactables:FindFirstChild("Frame");

    if Frame and Frame:IsA("Frame") then
        return Frame;
    end;

    return Interactables:FindFirstChildWhichIsA("Frame");
end;

local function getChargeTextLabel(p12) -- Line: 136
    if not p12 then
        return nil;
    end;

    local Interactables = p12:FindFirstChild("Interactables");

    if Interactables then
        Interactables = Interactables:FindFirstChild("Charge", true);
    end;

    if Interactables then
        Interactables = Interactables:FindFirstChildOfClass("SurfaceGui");
    end;

    if not Interactables then
        return nil;
    end;

    local TextLabel = Interactables:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        return TextLabel;
    end;

    return Interactables:FindFirstChildWhichIsA("TextLabel");
end;

local function getRechargeChargeAlpha(p13) -- Line: 156
    if not p13 then
        return nil;
    end;

    local Properties = p13.Properties;

    if not Properties then
        return nil;
    end;

    local RechargeTime = Properties.RechargeTime;
    local Rounds = Properties.Rounds;

    if not RechargeTime or (not Rounds or Rounds <= 0) then
        return nil;
    end;

    local v14 = (tonumber(p13.Rounds) or Rounds) / Rounds;
    local v15 = math.clamp(v14, 0, 1);

    if v15 >= 1 then
        return 1;
    end;

    local v16 = tonumber(p13.RechargeStartTime);

    if not v16 then
        return v15;
    end;

    local v17 = workspace:GetServerTimeNow() - v16;
    local v18 = math.max(v17, 0) / RechargeTime;
    local v19 = v15 + math.clamp(v18, 0, 1) / Rounds;

    return math.clamp(v19, 0, 1);
end;

local u20 = Color3.fromRGB(125, 20, 20);
local u21 = Color3.fromRGB(255, 235, 140);
local u22 = Color3.fromRGB(40, 223, 213);

local function updateChargeFrame(p23, p24) -- Line: 196
    -- upvalues: getChargeFillFrame (copy), getChargeTextLabel (copy), getRechargeChargeAlpha (copy), u22 (copy), u20 (copy), u21 (copy)
    local ChargeFillFrame = p23.ChargeFillFrame;

    if not (ChargeFillFrame and ChargeFillFrame.Parent) then
        ChargeFillFrame = getChargeFillFrame(p23.Model);
        p23.ChargeFillFrame = ChargeFillFrame;
        local v25;

        if ChargeFillFrame then
            v25 = ChargeFillFrame.Size or nil;
        else
            v25 = nil;
        end;

        p23.ChargeFillBaseSize = v25;
    end;

    local ChargeTextLabel = p23.ChargeTextLabel;

    if not (ChargeTextLabel and ChargeTextLabel.Parent) then
        ChargeTextLabel = getChargeTextLabel(p23.Model);
        p23.ChargeTextLabel = ChargeTextLabel;
    end;

    local ChargeFillBaseSize = p23.ChargeFillBaseSize;

    if not (ChargeFillFrame and ChargeFillBaseSize) then
        return;
    end;

    local v26 = getRechargeChargeAlpha(p23.WeaponComponent) or 1;
    local DisplayedChargeAlpha = p23.DisplayedChargeAlpha;
    local v27;

    if DisplayedChargeAlpha == nil or v26 < DisplayedChargeAlpha then
        v27 = v26;
    else
        local v28 = math.clamp(p24 * 3.5, 0, 1);
        v27 = DisplayedChargeAlpha + (v26 - DisplayedChargeAlpha) * v28;
    end;

    if math.abs(v26 - v27) > 0.001 then
        v26 = v27;
    end;

    local v29 = v26 >= 0.999 and 1 or v26;
    p23.DisplayedChargeAlpha = v29;
    ChargeFillFrame.Size = UDim2.new(ChargeFillBaseSize.X.Scale, ChargeFillBaseSize.X.Offset, 0.8 * v29, 0);
    local v30;

    if v29 >= 0.999 then
        v30 = u22;
    else
        v30 = u20:Lerp(u21, v29);
    end;

    ChargeFillFrame.BackgroundColor3 = v30;

    if ChargeTextLabel then
        ChargeTextLabel.Text = `{math.round(v29 * 100)}%`;
        ChargeTextLabel.TextColor3 = v30;
    end;
end;

local function stripWeaponGeometry(p31) -- Line: 254
    for _, v in ipairs({ "Weapon", "WeaponL", "WeaponR", "CharmBase" }) do
        local v32 = p31:FindFirstChild(v);

        if v32 then
            v32:Destroy();
        end;
    end;
end;

function u1.aim(p33) -- Line: 263
    -- upvalues: toggleScopeVisibility (copy), CurrentCamera (copy)
    if p33.Bobble then
        p33.Bobble:setIsAiming(true);
    end;

    toggleScopeVisibility(p33.Bobble.Scope, true);
    toggleScopeVisibility(p33.Bobble.ScopeReticlePart, true);

    if p33.MuzzlePartWeld then
        local CFrame2 = CurrentCamera.CFrame;
        local WorldPivot = p33.Model.WorldPivot;
        local v34 = CFrame2 + CFrame2.UpVector * -0.5 + WorldPivot.LookVector * 1 + WorldPivot.RightVector * 0.1;
        p33.MuzzlePartWeld.C0 = p33.MuzzlePartWeld.Part0.CFrame:Inverse() * v34;
    end;
end;

function u1.unaim(p35) -- Line: 289
    -- upvalues: toggleScopeVisibility (copy)
    if p35.Bobble then
        p35.Bobble:setIsAiming(false);
    end;

    toggleScopeVisibility(p35.Bobble.Scope, false);
    toggleScopeVisibility(p35.Bobble.ScopeReticlePart, false);

    if p35.OriginalC0 and p35.MuzzlePartWeld then
        p35.MuzzlePartWeld.C0 = p35.OriginalC0;
    end;
end;

function u1.unhide(p36) -- Line: 304
    -- upvalues: updateTransparency (copy)
    if p36.Hidden then
        updateTransparency(p36.Model, false);
        p36.Hidden = false;
    end;
end;

function u1.hide(p37) -- Line: 314
    -- upvalues: updateTransparency (copy)
    if not p37.Hidden then
        updateTransparency(p37.Model, true);
        p37.Hidden = true;
    end;
end;

function u1.equip(p38, p39) -- Line: 323
    -- upvalues: CurrentCamera (copy)
    p38.IsEquipped = true;

    if not p38.Model then
        return;
    end;

    p38.Model.Parent = CurrentCamera;

    if p38.LargeWeaponModel then
        p38.LargeWeaponModel.Parent = CurrentCamera;
    end;

    p38.Animation:stopAnimations();
    p38.Animation:play("Idle");

    if p38.Hidden then
        p38:unhide();
    end;

    if not p39 then
        p38.Animation:play(p38.Animation:pickVariant("Equip"));
    end;
end;

function u1.unequip(p40) -- Line: 351
    p40.IsEquipped = false;
    p40.Animation:stopAnimations();

    if p40.Model then
        p40.Model.Parent = nil;
    end;

    if p40.LargeWeaponModel then
        p40.LargeWeaponModel.Parent = nil;
    end;
end;

function u1.applyCharmImpulse(p41, p42) -- Line: 367
    if p41.LargeCharmModel and p41.LargeCharmModel.PrimaryPart then
        local v43 = 0;

        for _, descendant in ipairs(p41.LargeCharmModel:GetDescendants()) do
            if descendant:IsA("BasePart") then
                v43 = v43 + descendant:GetMass();
            end;
        end;

        p41.LargeCharmModel.PrimaryPart:ApplyImpulse(p42 * 10 * v43);
    end;
end;

function u1.render(p44, p45) -- Line: 385
    -- upvalues: updateChargeFrame (copy), DataController (copy), CurrentCamera (copy)
    if not (p44.Model and p44.Model:FindFirstChild("Stats")) then
        return;
    end;

    debug.profilebegin("Viewmodel.render.UpdateChargeFrame");
    updateChargeFrame(p44, p45);
    debug.profileend();
    debug.profilebegin("Viewmodel.render.GetViewmodelSettings");
    local v46 = DataController.Get(p44.Player, "Settings.Game.Viewmodel") or {};
    debug.profileend();

    if p44.Bobble and (p44.Bobble.Character and p44.Bobble.Character.PrimaryPart) then
        debug.profilebegin("Viewmodel.render.BobbleNextCFrame");
        local v47, v48, v49 = p44.Bobble:getNextCFrame(p45);
        debug.profileend();
        local v50 = (v46["X Offset"] or 0) / 100;
        local v51 = (v46["Y Offset"] or 0) / 100;
        local v52 = (v46["Z Offset"] or 0) / 100;
        local v53 = CurrentCamera.CFrame * v47 * CFrame.Angles(p44.Model.Stats.Rotation.Value.X, p44.Model.Stats.Rotation.Value.Y, p44.Model.Stats.Rotation.Value.Z) * CFrame.new(p44.Model.Stats.Default.Value) * CFrame.new(v50, v51, v52);
        debug.profilebegin("Viewmodel.render.PivotModel");
        p44.Model:PivotTo(v53);
        debug.profileend();

        if p44.LargeWeaponModel and p44.SmallWeaponModel then
            debug.profilebegin("Viewmodel.render.PivotLargeWeaponModel");
            p44.LargeWeaponModel:PivotTo(p44.SmallWeaponModel:GetPivot());
            debug.profileend();
            local Position = p44.Model.WorldPivot.Position;

            if p44.LastViewmodelPosition then
                local v54 = Position - p44.LastViewmodelPosition;

                if p44.LargeCharmModel and p44.LargeCharmModel.PrimaryPart then
                    p44:applyCharmImpulse(-v54 * 0.2);
                end;
            end;

            p44.LastViewmodelPosition = Position;
        end;

        if p44.Bobble.Scope and p44.Bobble.IsAiming then
            debug.profilebegin("Viewmodel.render.Scope");
            local CFrame2 = CurrentCamera.CFrame;
            p44.Bobble.Scope:PivotTo(CFrame2 + CFrame2.LookVector * 0.15 + v48 + (v49.X * -CFrame2.LookVector + v49.Y * -CFrame2.UpVector));

            if p44.Bobble.ScopeReticlePart then
                p44.Bobble.ScopeReticlePart.CFrame = CFrame2 * CFrame.Angles(1.5707963267948966, 1.5707963267948966, -1.5707963267948966) + CFrame2.LookVector * 0.15;
            end;

            debug.profileend();
        end;
    end;
end;

function u1.attachSleeves(p55, p56) -- Line: 463
    -- upvalues: ReplicatedStorage (copy)
    local v57 = ReplicatedStorage.Assets.Sleeves:FindFirstChild(p56);

    if v57 then
        for _, child in ipairs(v57:GetChildren()) do
            local v58 = p55.Model:FindFirstChild(child.Name);

            if v58 then
                local v59 = child:Clone();
                v59.CastShadow = false;
                v59.CanCollide = false;
                v59.CanTouch = false;
                v59.Anchored = false;
                v59.CanQuery = false;
                v59.Name = "Sleeve";
                v59.Size = Vector3.new(v58.Size.X * 1.3, v58.Size.Y * 1.4, v58.Size.Z * 0.79);
                local v60 = CFrame.new(0, -0.02, -(v58.Size.Z / 2 - v59.Size.Z / 2));
                v59.Parent = v58;
                local Motor6D = Instance.new("Motor6D", v59);
                Motor6D.Part0 = v58;
                Motor6D.Part1 = v59;
                Motor6D.C0 = CFrame.identity;
                Motor6D.C1 = v60;
            end;
        end;
    end;
end;

function u1.addAttachments(p61, p62) -- Line: 505
    -- upvalues: Router (copy), Skins (copy), AttachGlovesToViewmodel (copy)
    debug.profilebegin("Viewmodel.addAttachments");
    local v63 = nil;
    local v64 = nil;
    local v65 = nil;

    if type(p62) == "string" then
        local v66 = Router.broadcastRouter("GetInventoryItemFromIdentifier", p61.Player, p62);

        if v66 then
            v63 = v66.Name;
            v64 = v66.Skin;
            v65 = v66.Float;
        end;
    elseif type(p62) == "table" then
        local SkinIdentifier = p62.SkinIdentifier;

        if type(SkinIdentifier) == "string" and SkinIdentifier ~= "" then
            local v67 = Router.broadcastRouter("GetInventoryItemFromIdentifier", p61.Player, SkinIdentifier);

            if v67 then
                v63 = v67.Name;
                v64 = v67.Skin;
                v65 = v67.Float;
            end;
        end;

        if not v63 and (type(p62.Name) == "string" and type(p62.Skin) == "string") then
            v63 = p62.Name;
            v64 = p62.Skin;

            if typeof(p62.Float) == "number" then
                v65 = p62.Float;
            else
                v65 = nil;
            end;
        end;
    end;

    if not (v63 and v64) then
        debug.profileend();

        return;
    end;

    debug.profilebegin("Viewmodel.addAttachments.GetGloves");
    local v68 = Skins.GetGloves(v63, v64, v65);
    debug.profileend();

    if not v68 then
        debug.profileend();

        return;
    end;

    debug.profilebegin("Viewmodel.addAttachments.AttachGloves");
    AttachGlovesToViewmodel(v68:GetChildren(), p61.Model);
    debug.profileend();

    if p61.Team == "Counter-Terrorists" then
        debug.profilebegin("Viewmodel.addAttachments.AttachSleeves");
        p61:attachSleeves((workspace:GetAttribute("CTCharacter")));
        debug.profileend();
    end;

    debug.profileend();
end;

function u1.construct(p69, p70, p71) -- Line: 568
    -- upvalues: Janitor (copy), Skins (copy), ReplicatedFirst (copy), stripWeaponGeometry (copy), HttpService (copy), GetMuzzleFlash (copy), Camera (copy)
    debug.profilebegin("Viewmodel.construct");

    if p69.ModelJanitor then
        debug.profilebegin("Viewmodel.construct.DestroyModelJanitor");
        p69.ModelJanitor:Destroy();
        debug.profileend();
    end;

    p69.ModelJanitor = Janitor.new();
    p69.CharmModel = nil;
    p69.LargeWeaponModel = nil;
    p69.SmallWeaponModel = nil;
    p69.LargeCharmModel = nil;
    p69.LastViewmodelPosition = nil;
    p69.ChargeFillFrame = nil;
    p69.ChargeTextLabel = nil;
    p69.ChargeFillBaseSize = nil;
    p69.DisplayedChargeAlpha = nil;

    if p69.Animation then
        debug.profilebegin("Viewmodel.construct.StopAnimations");
        p69.Animation:stopAnimations();
        debug.profileend();
    end;

    if p69.Model then
        debug.profilebegin("Viewmodel.construct.DestroyPreviousModel");
        p69.Model:Destroy();
        debug.profileend();
        p69.Model = nil;
    end;

    local v72 = p69.CameraModelWeapon or p69.Weapon;
    local v73 = nil;
    local v74;

    if v72 == "Smoke Grenade" then
        v74 = p69.Team;

        if v74 ~= "Counter-Terrorists" and v74 ~= "Terrorists" then
            v74 = v73;
        end;
    else
        v74 = v73;
    end;

    debug.profilebegin("Viewmodel.construct.GetCameraModel");
    p69.Model = Skins.GetCameraModel(v72, p69.Skin, p69.Float, p69.StatTrack, p69.NameTag, p69.Charm, p69.Stickers, v74);
    debug.profileend();

    if not p69.Model and p69.HideWeaponGeometry then
        debug.profilebegin("Viewmodel.construct.GetBaseWeaponModel");
        p69.Model = Skins.GetBaseWeaponModel(v72, "Camera");
        debug.profileend();
    end;

    if not p69.Model then
        debug.profileend();
        error((`Viewmodel.construct: Failed to get camera model for weapon "{v72}" with skin "{p69.Skin}"`));
    end;

    debug.profilebegin("Viewmodel.construct.ParentAndName");
    p69.Model.Parent = ReplicatedFirst;
    p69.Model.Name = v72;
    debug.profileend();

    if p69.HideWeaponGeometry then
        debug.profilebegin("Viewmodel.construct.StripWeaponGeometry");
        stripWeaponGeometry(p69.Model);
        debug.profileend();
    end;

    local u75 = p70:GetAttribute("EquippedGloves");

    if type(u75) == "string" and u75 ~= "" then
        debug.profilebegin("Viewmodel.construct.DecodeEquippedGloves");
        local success, result = pcall(function() -- Line: 664
            -- upvalues: HttpService (ref), u75 (copy)
            return HttpService:JSONDecode(u75);
        end);
        debug.profileend();

        if success and result then
            p69:addAttachments(result);
        else
            p69:addAttachments(u75);
        end;
    end;

    debug.profilebegin("Viewmodel.construct.SetupDescendants");

    for _, descendant in ipairs(p69.Model:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CollisionGroup = "Viewmodel";
            descendant.CanCollide = false;
            descendant.CastShadow = false;
            descendant.CanQuery = true;
            descendant.CanTouch = false;

            if descendant.Name == "HumanoidRootPart" or descendant.Name == "ViewmodelLight" then
                descendant.Transparency = 1;
            end;
        end;
    end;

    debug.profileend();
    debug.profilebegin("Viewmodel.construct.SetupArmColors");
    local v76 = p70:FindFirstChild("Body Colors");
    local v77 = nil;

    if v76 then
        v77 = v76.TorsoColor3;
    else
        local v78 = p70:FindFirstChild("Torso") or p70:FindFirstChild("UpperTorso");

        if v78 and v78:IsA("BasePart") then
            v77 = v78.Color;
        end;
    end;

    if v77 then
        for _, v in ipairs({ "Right Arm", "Left Arm" }) do
            local v79 = p69.Model:FindFirstChild(v);

            if v79 and v79:IsA("BasePart") then
                v79.Color = v77;
            end;
        end;
    end;

    debug.profileend();
    debug.profilebegin("Viewmodel.construct.CacheMuzzleParts");
    local Interactables = p69.Model:FindFirstChild("Interactables");
    local v80;

    if Interactables then
        v80 = Interactables:FindFirstChild("MuzzlePart", true) or (Interactables:FindFirstChild("MuzzlePartL", true) or Interactables:FindFirstChild("MuzzlePartR", true));
    else
        v80 = Interactables;
    end;

    p69.MuzzlePart = v80;

    if Interactables then
        p69.MuzzlePartL = Interactables:FindFirstChild("MuzzlePartL", true);
        p69.MuzzlePartR = Interactables:FindFirstChild("MuzzlePartR", true);

        if p69.MuzzlePartL and p69.MuzzlePartL:IsA("BasePart") then
            p69.MuzzlePartL.Transparency = 1;
        end;

        if p69.MuzzlePartR and p69.MuzzlePartR:IsA("BasePart") then
            p69.MuzzlePartR.Transparency = 1;
        end;
    end;

    if p69.MuzzlePart and p69.MuzzlePart:IsA("BasePart") then
        p69.MuzzlePart.Transparency = 1;
    end;

    if p69.MuzzlePart and not p69.MuzzlePart:FindFirstChild("WeldConstraint", true) then
        local v81 = p69.Model:GetDescendants();

        for _, v in ipairs(v81) do
            if v:IsA("Weld") and (v.Part1 == v80 or v.Part0 == v80) then
                p69.MuzzlePartWeld = v;
                p69.OriginalC0 = v.C0;
                break;
            end;
        end;
    end;

    debug.profileend();
    debug.profilebegin("Viewmodel.construct.ScaleTo");
    p69.Model:ScaleTo(0.1);
    debug.profileend();
    local Properties = p71.Properties;

    if Properties then
        if Properties.ShootingOptions == "Dual" then
            local MuzzlePartL = p69.MuzzlePartL;

            if MuzzlePartL and Properties.MuzzleType then
                GetMuzzleFlash(MuzzlePartL, Camera, Properties.MuzzleType, "Motor6D");

                if Properties.HasSuppressor then
                    GetMuzzleFlash(MuzzlePartL, Camera, "Suppressor", "Motor6D");
                end;
            end;

            local MuzzlePartR = p69.MuzzlePartR;

            if MuzzlePartR and Properties.MuzzleType then
                GetMuzzleFlash(MuzzlePartR, Camera, Properties.MuzzleType, "Motor6D");

                if Properties.HasSuppressor then
                    GetMuzzleFlash(MuzzlePartR, Camera, "Suppressor", "Motor6D");
                end;
            end;
        else
            local MuzzlePart = p69.MuzzlePart;

            if MuzzlePart and Properties.MuzzleType then
                GetMuzzleFlash(MuzzlePart, Camera, Properties.MuzzleType, "Motor6D");

                if Properties.HasSuppressor then
                    GetMuzzleFlash(MuzzlePart, Camera, "Suppressor", "Motor6D");
                end;
            end;
        end;
    end;

    debug.profilebegin("Viewmodel.construct.FindCharmModel");
    local CharmBase = p69.Model:FindFirstChild("CharmBase", true);

    if CharmBase and CharmBase:IsA("Model") then
        local v82 = CharmBase:FindFirstChildOfClass("Model");

        if v82 and v82.PrimaryPart then
            p69.CharmModel = v82;
        end;
    end;

    debug.profileend();

    if p69.CharmModel then
        debug.profilebegin("Viewmodel.construct.SetupCharmPhysics");
        p69:setupCharmPhysics();
        debug.profileend();
    end;

    debug.profilebegin("Viewmodel.construct.SetModelReferences");

    if p69.Animation then
        p69.Animation:setModel(p69.Model);
    end;

    if p69.Bobble then
        p69.Bobble:setModel(p69.Model);
    end;

    debug.profileend();
    debug.profilebegin("Viewmodel.construct.FinalEquipState");

    if p69.IsEquipped then
        p69:equip(false);
    else
        p69:unequip();
    end;

    debug.profileend();
    debug.profileend();
end;

function u1.setupCharmPhysics(u83) -- Line: 821
    -- upvalues: CurrentCamera (copy), RunServiceController (copy)
    if not u83.CharmModel then
        return;
    end;

    debug.profilebegin("Viewmodel.setupCharmPhysics");
    local Parent = u83.CharmModel.Parent;

    if not (Parent and Parent.PrimaryPart) then
        debug.profileend();

        return;
    end;

    u83.CharmModel:PivotTo(Parent.PrimaryPart.CFrame * CFrame.new(0, 0, -1));
    local CharmModel = u83.CharmModel;
    local u84 = u83.Model:FindFirstChild("Weapon") or (u83.Model:FindFirstChild("WeaponL") or u83.Model:FindFirstChild("WeaponR"));

    if not u84 then
        debug.profileend();

        return;
    end;

    debug.profilebegin("Viewmodel.setupCharmPhysics.CloneLargeProxy");
    local u85 = u84.Parent:Clone();
    u85.Parent = CurrentCamera;
    debug.profileend();
    local u86 = u85:FindFirstChild("Weapon") or (u85:FindFirstChild("WeaponL") or u85:FindFirstChild("WeaponR"));

    if not u86 then
        debug.profileend();

        return;
    end;

    debug.profilebegin("Viewmodel.setupCharmPhysics.TrimLargeProxy");

    for _, child in u85:GetChildren() do
        if child.Name ~= "Weapon" and (child.Name ~= "WeaponL" and (child.Name ~= "WeaponR" and child.Name ~= "CharmBase")) then
            child:Destroy();
        end;
    end;

    for _, descendant in ipairs(u85:GetDescendants()) do
        if descendant.Name == "ViewmodelLight" then
            descendant:Destroy();
        end;
    end;

    debug.profileend();
    debug.profilebegin("Viewmodel.setupCharmPhysics.ScaleAndPivotProxy");
    u85:ScaleTo(1);
    u85:PivotTo(u84.Parent:GetPivot());

    if u86 and u86.PrimaryPart then
        u86.PrimaryPart.Anchored = true;
    end;

    local v87 = u85:GetBoundingBox();

    if u85.PrimaryPart then
        u85.PrimaryPart.PivotOffset = u85.PrimaryPart.CFrame:ToObjectSpace(v87);
    else
        u85.WorldPivot = v87;
    end;

    u85.PrimaryPart = u86.PrimaryPart;
    debug.profileend();
    debug.profilebegin("Viewmodel.setupCharmPhysics.ConfigureProxyDescendants");

    for _, descendant in ipairs(u85:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Transparency = 1;
            descendant.CanCollide = true;
        elseif descendant:IsA("Decal") or (descendant:IsA("Texture") or descendant:IsA("Beam")) then
            descendant.Transparency = 1;
        elseif descendant:IsA("SurfaceGui") then
            descendant.Enabled = false;
        elseif descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false;
        end;
    end;

    debug.profileend();
    debug.profilebegin("Viewmodel.setupCharmPhysics.FindLargeCharm");
    local CharmBase = u85:FindFirstChild("CharmBase", true);
    local v88;

    if CharmBase and CharmBase:IsA("Model") then
        v88 = CharmBase:FindFirstChildOfClass("Model");

        if v88 then
            for _, descendant in ipairs(v88:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    descendant.CanCollide = true;
                    descendant.CollisionGroup = "Charm";
                end;
            end;
        end;
    else
        v88 = nil;
    end;

    debug.profileend();
    u83.LargeWeaponModel = u86.Parent;
    u83.SmallWeaponModel = u84;
    u83.LargeCharmModel = v88;

    if v88 and (CharmModel and u83.ModelJanitor) then
        local v89 = RunServiceController.CreateBindingName("Classes.Viewmodel.CharmSync");
        u83.ModelJanitor:Add(RunServiceController.BindToPostSimulation(v89, function() -- Line: 943
            -- upvalues: u83 (copy), CharmModel (copy), u86 (copy), u84 (copy)
            local LargeCharmModel = u83.LargeCharmModel;
            local v90 = CharmModel;

            if not (LargeCharmModel and v90) then
                return;
            end;

            if not (LargeCharmModel.PrimaryPart and v90.PrimaryPart) then
                return;
            end;

            local v91 = u86:GetPivot():ToObjectSpace((LargeCharmModel:GetPivot()));
            local v92 = CFrame.new(v91.Position / 10) * CFrame.fromOrientation(v91:ToOrientation());
            v90:PivotTo(u84:GetPivot() * v92);
        end));
    end;

    if u83.CharmModel.PrimaryPart then
        u83.CharmModel.PrimaryPart.Anchored = true;
    end;

    if not u83.ModelJanitor then
        debug.profileend();

        return;
    end;

    u83.ModelJanitor:Add(function() -- Line: 983
        -- upvalues: u85 (copy), u83 (copy)
        if u85 then
            u85:Destroy();
        end;

        u83.LargeWeaponModel = nil;
        u83.SmallWeaponModel = nil;
        u83.LargeCharmModel = nil;
    end);
    debug.profileend();
end;

function u1.new(u93, p94, p95) -- Line: 997
    -- upvalues: u1 (copy), Janitor (copy), Sound (copy), Animation (copy), Bobble (copy)
    debug.profilebegin("Viewmodel.new");
    local u96 = setmetatable({}, u1);
    u96.Janitor = Janitor.new();
    u96.ModelJanitor = Janitor.new();
    u96.IsDestroyed = false;
    u96.Player = u93.Player;
    u96.Team = u96.Player:GetAttribute("Team");
    u96.WeaponComponent = u93;
    u96.Weapon = p94;
    u96.CameraModelWeapon = u93.ViewmodelCameraWeapon or p94;
    u96.HideWeaponGeometry = u93.ViewmodelHideWeaponGeometry == true;
    u96.Skin = p95;
    u96.StatTrack = u93.StatTrack;
    u96.Stickers = u93.Stickers;
    u96.NameTag = u93.NameTag;
    u96.Float = u93.Float;
    u96.Charm = u93.Charm;
    u96.Hidden = false;
    u96.IsEquipped = false;
    u96.ChargeFillFrame = nil;
    u96.ChargeTextLabel = nil;
    u96.ChargeFillBaseSize = nil;
    u96.DisplayedChargeAlpha = nil;
    debug.profilebegin("Viewmodel.new.Sound");
    u96.Sound = Sound.new(u96.CameraModelWeapon);
    debug.profileend();
    debug.profilebegin("Viewmodel.new.Animation");
    u96.Animation = Animation.new(u96, u96.Player, nil, u96.Sound);
    debug.profileend();
    debug.profilebegin("Viewmodel.new.Bobble");
    u96.Bobble = Bobble.new(u93, nil);
    debug.profileend();
    local v97 = u93.Character or u96.Player and u96.Player.Character;

    if v97 then
        debug.profilebegin("Viewmodel.new.InitialConstruct");
        local success, result = pcall(u96.construct, u96, v97, u93);
        debug.profileend();

        if not success then
            debug.profileend();
            error(result, 2);
        end;
    end;

    u96.Janitor:Add(u96.Player.CharacterAdded:Connect(function(p98) -- Line: 1062
        -- upvalues: u96 (copy), u93 (copy)
        debug.profilebegin("Viewmodel.CharacterAdded.Construct");
        local success, result = pcall(u96.construct, u96, p98, u93);
        debug.profileend();

        if not success then
            warn((`[Viewmodel] CharacterAdded construct failed: {result}`));
        end;
    end));
    u96.Janitor:Add(function() -- Line: 1072
        -- upvalues: u96 (copy)
        if u96.Animation then
            u96.Animation:destroy();
            u96.Animation = nil;
        end;
    end);
    u96.Janitor:Add(function() -- Line: 1080
        -- upvalues: u96 (copy)
        if u96.Bobble then
            u96.Bobble:destroy();
            u96.Bobble = nil;
        end;
    end);
    u96.Janitor:Add(function() -- Line: 1088
        -- upvalues: u96 (copy)
        if u96.Sound then
            u96.Sound:destroy();
            u96.Sound = nil;
        end;
    end);
    u96.Janitor:Add(function() -- Line: 1096
        -- upvalues: u96 (copy)
        if u96.ModelJanitor then
            u96.ModelJanitor:Destroy();
            u96.ModelJanitor = nil;
        end;
    end);
    debug.profileend();

    return u96;
end;

function u1.destroy(p99) -- Line: 1111
    if not p99.IsDestroyed then
        debug.profilebegin("Viewmodel.destroy");
        p99.IsDestroyed = true;

        if p99.Animation then
            p99.Animation:stopAnimations();
        end;

        if p99.Animation then
            p99.Animation:destroy();
            p99.Animation = nil;
        end;

        if p99.Bobble then
            p99.Bobble:destroy();
            p99.Bobble = nil;
        end;

        if p99.Sound then
            p99.Sound:destroy();
            p99.Sound = nil;
        end;

        if p99.Model then
            p99.Model.Parent = nil;
            p99.Model:Destroy();
            p99.Model = nil;
        end;

        if p99.Janitor then
            p99.Janitor:Destroy();
            p99.Janitor = nil;
        end;

        p99.StatTrack = nil;
        p99.Stickers = nil;
        p99.NameTag = nil;
        p99.Player = nil;
        p99.Weapon = nil;
        p99.Float = nil;
        p99.Charm = nil;
        p99.Skin = nil;
        p99.Team = nil;
        p99.MuzzlePartWeld = nil;
        p99.MuzzlePartL = nil;
        p99.MuzzlePartR = nil;
        p99.MuzzlePart = nil;
        p99.OriginalC0 = nil;
        p99.CharmModel = nil;
        p99.ScaledCollisionModel = nil;
        p99.LargeCharmModel = nil;
        p99.LargeWeaponModel = nil;
        debug.profileend();
    end;
end;

return u1;