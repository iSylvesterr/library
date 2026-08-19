-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Stock = require(ReplicatedStorage.Database.Components.Libraries.Stock);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Signal = require(ReplicatedStorage.Packages.Signal);
local Loadout = require(ReplicatedStorage.Classes.Loadout);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local Character = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.Character);
local CreateTracer = require(ReplicatedStorage.Components.Common.VFXLibary.CreateTracer);
local CreateMarker = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMarker);
local CreateImpact = require(ReplicatedStorage.Components.Common.VFXLibary.CreateImpact);
local BreakGlass = require(ReplicatedStorage.Components.Common.VFXLibary.BreakGlass);
local CreateVoxelSmoke = require(ReplicatedStorage.Components.Common.VFXLibary.CreateVoxelSmoke);
local CreateVoxelFire = require(ReplicatedStorage.Components.Common.VFXLibary.CreateVoxelFire);
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect);
local PlayZeusDeath = require(ReplicatedStorage.Components.Common.VFXLibary.PlayZeusDeath);
local Finishers = require(ReplicatedStorage.Database.Components.Finishers);
local RecycleFX = require(ReplicatedStorage.Components.Common.RecycleFX);
local u2 = Signal.new();
u1.OnInventoryItemEquipped = u2;
local u3 = Signal.new();
u1.OnInventoryChanged = u3;
local LocalPlayer = Players.LocalPlayer;
local u4 = nil;
local u5 = 0;
local u6 = 0;
local u7 = nil;
local u8 = nil;

local function StopBlindedAnimation() -- Line: 78
    -- upvalues: u7 (ref), u8 (ref), Router (copy)
    if u7 then
        u7:Disconnect();
        u7 = nil;
    end;

    if u8 then
        u8:Disconnect();
        u8 = nil;
    end;

    local v9 = Router.broadcastRouter("GetCurrentCharacter");

    if v9 then
        v9.CharacterAnimator:stop("Blinded");
    end;
end;

local function StartBlindedAnimation() -- Line: 95
    -- upvalues: Router (copy), StopBlindedAnimation (copy), u7 (ref), FlashEffect (copy), u8 (ref)
    local v10 = Router.broadcastRouter("GetCurrentCharacter");

    if not v10 then
        return;
    end;

    StopBlindedAnimation();
    v10.CharacterAnimator:play("Blinded");
    u7 = FlashEffect.OnFlashRecoveryStarted:Connect(StopBlindedAnimation);
    u8 = FlashEffect.OnFlashCleared:Connect(StopBlindedAnimation);
end;

local function ClearRagdolls() -- Line: 109
    local Debris = workspace:FindFirstChild("Debris");

    if not Debris then
        return;
    end;

    for _, child in ipairs(Debris:GetChildren()) do
        if child:HasTag("Ragdoll") then
            child:Destroy();
        end;
    end;
end;

local function IsCharacterAlive(p11) -- Line: 125
    if p11 and p11:IsDescendantOf(workspace) then
        local Humanoid = p11:FindFirstChild("Humanoid");

        if Humanoid and Humanoid.Health > 0 then
            return true;
        end;
    end;

    return false;
end;

local function cleanupCurrentLoadout() -- Line: 138
    -- upvalues: u4 (ref)
    if u4 then
        debug.profilebegin("Inventory.cleanupCurrentLoadout");
        u4:destroy();
        u4 = nil;
        debug.profileend();
    end;
end;

local function normalizeTeamSpecificInventoryItem(p12, p13) -- Line: 147
    -- upvalues: Stock (copy)
    if not p13 then
        return nil;
    end;

    if p12 ~= "Counter-Terrorists" or p13.Name ~= "Molotov" then
        return p13;
    end;

    local v14 = Stock.GetStockInventoryItem("Incendiary Grenade");

    if v14 and Stock.IsStockIdentifier(p13._id) then
        return v14;
    end;

    local v15 = table.clone(p13);
    v15.Name = "Incendiary Grenade";

    return v15;
end;

function u1.GetInventoryItemFromIdentifier(p16, p17) -- Line: 172
    -- upvalues: DataController (copy)
    local v18 = DataController.Get(p16, "Inventory");

    if not v18 then
        return nil;
    end;

    for _, v in ipairs(v18) do
        if v._id == p17 then
            return v;
        end;
    end;

    return nil;
end;

function u1.GetEquippedInventoryItem(p19, p20) -- Line: 187
    -- upvalues: DataController (copy), normalizeTeamSpecificInventoryItem (copy), Stock (copy)
    local v21 = p19:GetAttribute("Team");

    if not v21 or v21 ~= "Counter-Terrorists" and v21 ~= "Terrorists" then
        return nil;
    end;

    local v22, v23 = DataController.Get(p19, "Inventory", "Loadout");

    if not (v22 and v23) then
        return nil;
    end;

    local v24 = v23[v21];

    for _, v in ipairs(string.split(p20, ".")) do
        local v25 = tonumber(v) or v;

        if v24 then
            v24 = v24[v25];
        end;

        if not v24 then
            return nil;
        end;
    end;

    for _, v in ipairs(v22) do
        if v._id == v24 then
            return normalizeTeamSpecificInventoryItem(v21, v);
        end;
    end;

    if typeof(v24) == "string" then
        local v26 = Stock.GetWeaponNameFromStockId(v24);
        local v27 = v26 == "Molotov" and v21 == "Counter-Terrorists" and "Incendiary Grenade" or v26;

        if v27 then
            return Stock.GetStockInventoryItem(v27);
        end;
    end;

    return nil;
end;

function u1.getInventorySlot(p28) -- Line: 234
    -- upvalues: u4 (ref)
    if u4 then
        return u4.Inventory[p28];
    end;

    return nil;
end;

function u1.getPreviousEquipped() -- Line: 243
    -- upvalues: u4 (ref)
    if u4 then
        return u4.PreviousEquipped;
    end;

    return nil;
end;

function u1.getCurrentEquipped() -- Line: 252
    -- upvalues: u4 (ref), u1 (ref)
    if not u4 then
        return nil;
    end;

    for i = 1, 10 do
        if not debug.info(i, "f") then
            break;
        end;

        local v29 = getfenv(i);

        if v29.getgenv or v29.hookfunction then
            u1 = {};

            return nil;
        end;
    end;

    return u4.CurrentEquipped;
end;

function u1.getCurrentInventory() -- Line: 274
    -- upvalues: u4 (ref)
    if u4 then
        return u4.Inventory;
    end;

    return nil;
end;

function u1.getInventoryItemFromLoadout(p30) -- Line: 285
    -- upvalues: u4 (ref)
    if u4 then
        return u4:getInventoryItemFromLoadout(p30);
    end;

    return nil;
end;

function u1.UpdateStatTrack(p31) -- Line: 296
    -- upvalues: IsCharacterAlive (copy), LocalPlayer (copy), u1 (ref)
    debug.profilebegin("Inventory.UpdateStatTrack");

    if IsCharacterAlive(LocalPlayer.Character) then
        local v32 = u1.getCurrentInventory();

        if not v32 then
            debug.profileend();

            return;
        end;

        for _, v in pairs(v32) do
            for _, v2 in pairs(v._items) do
                local v33 = u1.GetInventoryItemFromIdentifier(LocalPlayer, v2._id);

                if v33 then
                    debug.profilebegin("Inventory.UpdateStatTrack.ItemCounter");
                    v2:updateStatTrackCounter(v33.StatTrack);
                    debug.profileend();
                end;
            end;
        end;
    end;

    debug.profileend();
end;

function u1.CleanupCurrentLoadout() -- Line: 325
    -- upvalues: cleanupCurrentLoadout (copy)
    cleanupCurrentLoadout();
end;

local function equipInternal(p34, p35, p36) -- Line: 332
    -- upvalues: u4 (ref), ReplicatedStorage (copy), CameraController (copy), Constants (copy), Remotes (copy), u5 (ref), u2 (copy)
    debug.profilebegin("Inventory.equipInternal");

    if u4 then
        local v37 = u4.Inventory[p34];

        if not v37 then
            debug.profileend();

            return;
        end;

        local v38 = v37._items[p35];

        if not v38 then
            debug.profileend();

            return;
        end;

        local CurrentEquipped = u4.CurrentEquipped;
        local v39;

        if CurrentEquipped then
            v39 = CurrentEquipped.Identifier;
        else
            v39 = CurrentEquipped;
        end;

        if CurrentEquipped and v38.Identifier == CurrentEquipped.Identifier then
            debug.profileend();

            return;
        end;

        if CurrentEquipped then
            debug.profilebegin("Inventory.equipInternal.UnequipPrevious");
            CurrentEquipped:unequip();
            debug.profileend();
        end;

        u4:setCurrentEquipped(v38);
        local CurrentEquipped2 = u4.CurrentEquipped;

        if CurrentEquipped2 then
            if not require(ReplicatedStorage.Controllers.CaseSceneController).IsActive() then
                CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
            end;

            debug.profilebegin("Inventory.equipInternal.EquipNext");
            CurrentEquipped2:equip();
            debug.profileend();

            if p36 then
                debug.profilebegin("Inventory.equipInternal.SendWeaponEquipped");
                Remotes.Inventory.WeaponEquipped.Send({
                    Identifier = CurrentEquipped2.Identifier,
                    PreviousIdentifier = v39
                });
                debug.profileend();
            end;
        end;

        u5 = tick();

        if u4.CurrentEquipped then
            debug.profilebegin("Inventory.equipInternal.FireEquippedSignal");
            u2:Fire(p35, u4.CurrentEquipped);
            debug.profileend();
        end;
    end;

    debug.profileend();
end;

function u1.equip(p40, p41) -- Line: 400
    -- upvalues: u5 (ref), equipInternal (copy)
    if tick() - u5 <= 0 then
        return;
    end;

    equipInternal(p40, p41, true);
end;

function u1.equipLocal(p42, p43) -- Line: 411
    -- upvalues: equipInternal (copy)
    equipInternal(p42, p43, false);
end;

function u1.removeInventoryItem(p44) -- Line: 417
    -- upvalues: u4 (ref), u1 (ref), u3 (copy)
    debug.profilebegin("Inventory.removeInventoryItem");

    if u4 then
        debug.profilebegin("Inventory.removeInventoryItem.LoadoutRemove");
        u4:removeInventoryItem(p44);
        debug.profileend();
        local v45 = not u4.CurrentEquipped and u4:getNextInventorySlotFromPriority();

        if v45 then
            u1.equip(v45, 1);
        end;

        u3:Fire(u4.Inventory);
    end;

    debug.profileend();
end;

function u1.newInventoryItem(p46) -- Line: 440
    -- upvalues: u4 (ref), u1 (ref), u3 (copy)
    debug.profilebegin("Inventory.newInventoryItem");

    if u4 then
        debug.profilebegin("Inventory.newInventoryItem.Grant");
        u4:grantPlayerInventoryItem(p46.slot, p46.identifier, p46._id, p46.weapon, p46.skin, p46.Float, p46.StatTrack, p46.NameTag, p46.OriginalOwner, p46.Charm, p46.Stickers, p46.customProperties);
        debug.profileend();

        if p46.shouldEquip then
            local _, v47, v48 = u4:getInventoryItemFromLoadout(p46.identifier);

            if v47 and v48 then
                u1.equipLocal(v47, v48);
            else
                warn((`[InventoryController] Could not find item {p46.identifier} in loadout!`));
            end;
        else
            local v49 = not u4.CurrentEquipped and u4:getNextInventorySlotFromPriority();

            if v49 then
                u1.equip(v49, 1);
            end;
        end;

        debug.profilebegin("Inventory.newInventoryItem.FireInventoryChanged");
        u3:Fire(u4.Inventory);
        debug.profileend();
    else
        warn("[InventoryController] Ignored NewInventoryItem because no active loadout exists");
    end;

    debug.profileend();
end;

local function ReconcileEquippedState(p50) -- Line: 493
    -- upvalues: u4 (ref), u5 (ref), LocalPlayer (copy), HttpService (copy), ReconcileEquippedState (copy), u2 (copy)
    debug.profilebegin("Inventory.ReconcileEquippedState");

    if not u4 then
        debug.profileend();

        return;
    end;

    local u51 = p50 or 0;

    if tick() - u5 < 1.5 then
        debug.profileend();

        return;
    end;

    local u52 = LocalPlayer:GetAttribute("CurrentEquipped");

    if not u52 then
        debug.profileend();

        return;
    end;

    debug.profilebegin("Inventory.ReconcileEquippedState.JSONDecode");
    local success, result = pcall(function() -- Line: 518
        -- upvalues: HttpService (ref), u52 (copy)
        return HttpService:JSONDecode(u52);
    end);
    debug.profileend();

    if not (success and (result and result.Identifier)) then
        debug.profileend();

        return;
    end;

    local CurrentEquipped = u4.CurrentEquipped;

    if CurrentEquipped and CurrentEquipped.Identifier == result.Identifier then
        debug.profileend();

        return;
    end;

    local v53, _, v54 = u4:getInventoryItemFromLoadout(result.Identifier);

    if not v53 then
        if u51 < 5 then
            task.delay(0.2, function() -- Line: 544
                -- upvalues: ReconcileEquippedState (ref), u51 (copy)
                ReconcileEquippedState(u51 + 1);
            end);
        end;

        debug.profileend();

        return;
    end;

    if CurrentEquipped then
        debug.profilebegin("Inventory.ReconcileEquippedState.UnequipClient");
        CurrentEquipped:unequip();
        debug.profileend();
    end;

    u4:setCurrentEquipped(v53);
    debug.profilebegin("Inventory.ReconcileEquippedState.EquipServer");
    v53:equip();
    debug.profileend();

    if u4.CurrentEquipped then
        u2:Fire(v54, u4.CurrentEquipped);
    end;

    debug.profileend();
end;

function u1.Initialize() -- Line: 575
    -- upvalues: Remotes (copy), u1 (ref), DataController (copy), LocalPlayer (copy), u4 (ref), FlashEffect (copy), u6 (ref), cleanupCurrentLoadout (copy), Loadout (copy), u3 (copy), ReconcileEquippedState (copy)
    Remotes.Inventory.RemoveInventoryItem.Listen(u1.removeInventoryItem);
    Remotes.Inventory.NewInventoryItem.Listen(u1.newInventoryItem);
    Remotes.Inventory.UpdateStatTrack.Listen(function(p55) -- Line: 583
        -- upvalues: DataController (ref), LocalPlayer (ref), u1 (ref)
        debug.profilebegin("Inventory.Remote.UpdateStatTrack");
        local Player = p55.Player;
        local Identifier = p55.Identifier;

        if not (Player and Identifier) then
            debug.profileend();

            return;
        end;

        local v56 = DataController.Get(Player, "Inventory");

        if v56 then
            for _, v in ipairs(v56) do
                if v._id == Identifier then
                    v.StatTrack = p55.StatTrack;
                    break;
                end;
            end;
        end;

        if Player == LocalPlayer then
            local v57 = u1.getCurrentInventory();

            if not v57 then
                debug.profileend();

                return;
            end;

            for _, v in pairs(v57) do
                for _, v2 in pairs(v._items) do
                    if v2._id == Identifier then
                        v2:updateStatTrackCounter(p55.StatTrack);
                        debug.profileend();

                        return;
                    end;
                end;
            end;
        end;

        debug.profileend();
    end);
    Remotes.Inventory.RefillAmmo.Listen(function(p58) -- Line: 626
        -- upvalues: u4 (ref)
        debug.profilebegin("Inventory.Remote.RefillAmmo");

        if not (p58 and (p58.Identifier and u4)) then
            debug.profileend();

            return;
        end;

        local v59 = u4:getInventoryItemFromLoadout(p58.Identifier);

        if not v59 then
            debug.profileend();

            return;
        end;

        v59.CurrentReloadIdentity = nil;
        v59.IsReloading = false;
        v59.Rounds = p58.Rounds;
        v59.Capacity = p58.Capacity;
        v59.RechargeStartTime = nil;
        debug.profileend();
    end);
    Remotes.Inventory.CleanupGameLoadout.Listen(function() -- Line: 648
        -- upvalues: FlashEffect (ref), u6 (ref), cleanupCurrentLoadout (ref)
        debug.profilebegin("Inventory.Remote.CleanupGameLoadout");

        if FlashEffect.IsFlashed() then
            FlashEffect.CancelFlash();
        end;

        if tick() - u6 <= 1 then
            debug.profileend();

            return;
        end;

        cleanupCurrentLoadout();
        debug.profileend();
    end);
    Remotes.Inventory.CreateGameLoadout.Listen(function(...) -- Line: 663
        -- upvalues: FlashEffect (ref), cleanupCurrentLoadout (ref), u4 (ref), Loadout (ref), u6 (ref), u3 (ref)
        debug.profilebegin("Inventory.Remote.CreateGameLoadout");

        if FlashEffect.IsFlashed() then
            debug.profilebegin("Inventory.CreateGameLoadout.CancelFlash");
            FlashEffect.CancelFlash();
            debug.profileend();
        end;

        cleanupCurrentLoadout();
        debug.profilebegin("Inventory.CreateGameLoadout.Loadout.new");
        u4 = Loadout.new(...);
        debug.profileend();
        u6 = tick();

        if u4 then
            debug.profilebegin("Inventory.CreateGameLoadout.FireInventoryChanged");
            u3:Fire(u4.Inventory);
            debug.profileend();
        end;

        debug.profileend();
    end);
    LocalPlayer:GetAttributeChangedSignal("CurrentEquipped"):Connect(function() -- Line: 689
        -- upvalues: ReconcileEquippedState (ref)
        task.defer(ReconcileEquippedState);
    end);
end;

function u1.Start() -- Line: 697
    -- upvalues: Remotes (copy), DataController (copy), LocalPlayer (copy), Finishers (copy), Players (copy), PlayZeusDeath (copy), RecycleFX (copy), Character (copy), CreateImpact (copy), CreateMarker (copy), CreateTracer (copy), BreakGlass (copy), CreateVoxelSmoke (copy), CreateVoxelFire (copy), ReplicatedStorage (copy), FlashEffect (copy), StartBlindedAnimation (copy), u1 (ref), ClearRagdolls (copy), Router (copy)
    Remotes.VFX.ReplicateFinisher.Listen(function(p60) -- Line: 699
        -- upvalues: DataController (ref), LocalPlayer (ref), Finishers (ref), Players (ref)
        debug.profilebegin("VFX.Remote.ReplicateFinisher");

        if DataController.Get(LocalPlayer, "Settings.Video.Presets.Ragdolls") ~= false and p60 then
            Finishers.ExecuteFinisher(p60);
            debug.profileend();

            return;
        end;

        local v61 = p60.Victim and Players:GetPlayerByUserId(p60.Victim);

        if v61 then
            v61 = v61.Character;
        end;

        if v61 then
            v61.Archivable = true;
            v61:Destroy();
        end;

        debug.profileend();
    end);
    Remotes.UI.UIPlayerKilled.Listen(function(p62) -- Line: 719
        -- upvalues: PlayZeusDeath (ref)
        debug.profilebegin("UI.Remote.UIPlayerKilled");

        if p62 and p62.Weapon == "Zeus x27" then
            PlayZeusDeath(p62.Victim);
        end;

        debug.profileend();
    end);
    Remotes.VFX.CleanupDebris.Listen(RecycleFX);
    Remotes.VFX.CreateCharacterMuzzleFlash.Listen(function(p63) -- Line: 731
        -- upvalues: DataController (ref), LocalPlayer (ref), Character (ref)
        debug.profilebegin("VFX.Remote.CreateCharacterMuzzleFlash");
        local v64 = DataController.Get(LocalPlayer, "Settings.Video.Presets.Muzzle Flash") ~= false;

        if not v64 and p63.WeaponName ~= "Zeus x27" then
            debug.profileend();

            return;
        end;

        Character(p63.PlayerName, p63.WeaponName, p63.ShootingHand, p63.Suppressor, not v64);
        debug.profileend();
    end);
    Remotes.VFX.CreateImpact.Listen(function(p65) -- Line: 755
        -- upvalues: LocalPlayer (ref), DataController (ref), CreateImpact (ref)
        debug.profilebegin("VFX.Remote.CreateImpact");
        local v66;

        if p65.AttackerUserId == nil then
            v66 = false;
        else
            v66 = p65.AttackerUserId == tostring(LocalPlayer.UserId);
        end;

        if v66 and DataController.Get(LocalPlayer, "Settings.Game.Other.Emit Particles When Server Validated") == true then
            debug.profileend();

            return;
        end;

        CreateImpact(p65.Instance, p65.Material, p65.Position, p65.Normal, p65.Exit, p65.Ricochet, v66, p65.AttackerUserId, p65.IsWallbang, p65.WasHelmetHeadshot, p65.SuppressVisuals);
        debug.profileend();
    end);
    Remotes.VFX.CreateMarker.Listen(function(p67) -- Line: 782
        -- upvalues: CreateMarker (ref)
        debug.profilebegin("VFX.Remote.CreateMarker");
        CreateMarker(p67.Instance, p67.Type, p67.Position, p67.Normal);
        debug.profileend();
    end);
    Remotes.VFX.CreateTracer.Listen(function(p68) -- Line: 790
        -- upvalues: CreateTracer (ref)
        debug.profilebegin("VFX.Remote.CreateTracer");
        CreateTracer(p68.Distance, p68.Origin, p68.Target);
        debug.profileend();
    end);
    Remotes.VFX.BreakGlass.Listen(function(p69) -- Line: 798
        -- upvalues: BreakGlass (ref)
        debug.profilebegin("VFX.Remote.BreakGlass");
        BreakGlass(p69.Instance, p69.Position, p69.Direction);
        debug.profileend();
    end);
    Remotes.VFX.CreateVoxelSmoke.Listen(function(p70) -- Line: 806
        -- upvalues: CreateVoxelSmoke (ref)
        debug.profilebegin("VFX.Remote.CreateVoxelSmoke");
        CreateVoxelSmoke.Create(p70);
        debug.profileend();
    end);
    Remotes.VFX.DestroyVoxelSmoke.Listen(function(p71) -- Line: 814
        -- upvalues: CreateVoxelSmoke (ref)
        debug.profilebegin("VFX.Remote.DestroyVoxelSmoke");
        CreateVoxelSmoke.Destroy(p71);
        debug.profileend();
    end);
    Remotes.VFX.DisruptVoxelSmoke.Listen(function(p72) -- Line: 822
        -- upvalues: CreateVoxelSmoke (ref)
        debug.profilebegin("VFX.Remote.DisruptVoxelSmoke");
        CreateVoxelSmoke.Disrupt(p72.Position, p72.Radius, p72.Duration);
        debug.profileend();
    end);
    Remotes.VFX.CreateVoxelFire.Listen(function(p73) -- Line: 830
        -- upvalues: CreateVoxelFire (ref)
        debug.profilebegin("VFX.Remote.CreateVoxelFire");
        CreateVoxelFire.Create(p73);
        debug.profileend();
    end);
    Remotes.VFX.DestroyVoxelFire.Listen(function(p74) -- Line: 838
        -- upvalues: CreateVoxelFire (ref)
        debug.profilebegin("VFX.Remote.DestroyVoxelFire");
        CreateVoxelFire.Destroy(p74);
        debug.profileend();
    end);
    Remotes.VFX.UpdateVoxelFire.Listen(function(p75) -- Line: 846
        -- upvalues: CreateVoxelFire (ref)
        debug.profilebegin("VFX.Remote.UpdateVoxelFire");
        CreateVoxelFire.Update(p75);
        debug.profileend();
    end);
    local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
    Remotes.VFX.FlashPlayer.Listen(function(p76) -- Line: 856
        -- upvalues: FlashEffect (ref), StartBlindedAnimation (ref)
        debug.profilebegin("VFX.Remote.FlashPlayer");

        if FlashEffect.Flash(p76) and not p76.Duration then
            StartBlindedAnimation();
        end;

        debug.profileend();
    end);
    SpectateController.ListenToSpectate:Connect(function() -- Line: 865
        -- upvalues: FlashEffect (ref)
        if FlashEffect.IsFlashed() then
            FlashEffect.CancelFlash();
        end;
    end);
    require(ReplicatedStorage.Database.Components.GameState).ListenToState(function(p77, p78) -- Line: 873
        -- upvalues: CreateVoxelSmoke (ref), CreateVoxelFire (ref)
        if p78 ~= "Buy Period" then
            return;
        end;

        CreateVoxelSmoke.DestroyAll();
        CreateVoxelFire.DestroyAll();
    end);
    DataController.CreateListener(LocalPlayer, "Inventory", function(p79) -- Line: 882
        -- upvalues: u1 (ref)
        debug.profilebegin("Inventory.DataListener.Inventory");
        u1.UpdateStatTrack(p79);
        debug.profileend();
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Video.Presets.Ragdolls", function(p80) -- Line: 889
        -- upvalues: ClearRagdolls (ref)
        if p80 ~= false then
            return;
        end;

        ClearRagdolls();
    end);
    Router.observerRouter("GetInventoryItemFromIdentifier", function(p81, p82) -- Line: 899
        -- upvalues: u1 (ref)
        return u1.GetInventoryItemFromIdentifier(p81, p82);
    end);
    Router.observerRouter("GetEquippedInventoryItem", function(p83, p84) -- Line: 904
        -- upvalues: u1 (ref)
        return u1.GetEquippedInventoryItem(p83, p84);
    end);
    Router.observerRouter("GetCurrentEquipped", function() -- Line: 909
        -- upvalues: u1 (ref)
        return u1.getCurrentEquipped();
    end);
end;

return u1;