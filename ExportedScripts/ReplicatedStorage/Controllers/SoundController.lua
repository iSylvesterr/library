-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ContentProvider = game:GetService("ContentProvider");
local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local LocalPlayer = Players.LocalPlayer;
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Router = require(ReplicatedStorage.Database.Security.Router);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Sound = require(ReplicatedStorage.Classes.Sound);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect);
local MovementSounds = require(script.MovementSounds);
local Character = require(ReplicatedStorage.Database.Audio.Character);
local FloorSounds = require(ReplicatedStorage.Database.Audio.FloorSounds);
local CurrentCamera = Workspace.CurrentCamera;
local u2 = {
    WeaponSuppressed = 50,
    Footstep = 48,
    Landing = 60,
    Weapon = 120,
    Melee = 50,
    Jump = 40
};
local u3 = {};
local u4 = {};
local u5 = nil;
local u6 = { "Knife", "Bayonet", "Karambit", "Daggers" };
local u7 = {
    Headshot = 1,
    Humiliation = 2,
    MultiKill = 3,
    KillSpree = 4,
    Rampage = 5,
    Dominating = 6,
    ["Monster Kill"] = 7,
    LudicrusKill = 8,
    Unstoppable = 9,
    Godlike = 10
};
local u8 = {
    [2] = "MultiKill",
    [3] = "KillSpree",
    [4] = "Rampage",
    [5] = "Dominating",
    [6] = "Monster Kill",
    [7] = "LudicrusKill",
    [8] = "Unstoppable",
    [9] = "Godlike"
};
local u9 = 0;
local u10 = nil;
local u11 = 0;
local u12 = nil;

local function isKnifeWeapon(p13) -- Line: 101
    -- upvalues: u6 (copy)
    for _, v in ipairs(u6) do
        if string.find(p13, v) then
            return true;
        end;
    end;

    return false;
end;

local function stopCurrentAccolade() -- Line: 110
    -- upvalues: u10 (ref), u11 (ref)
    if u10 then
        local v14 = u10;
        u10 = nil;
        u11 = 0;

        if v14.Parent then
            v14:Stop();
            v14:Destroy();
        end;
    end;
end;

local function updateBombPlantedMusicVolume(p15) -- Line: 122
    -- upvalues: u12 (ref), DataController (copy), LocalPlayer (copy)
    if u12 and u12.Parent then
        local v16 = (tonumber(p15) or 50) / 50;
        local v17 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100;
        local v18 = (tonumber(v17) or 100) / 100;
        local v19 = u12:GetAttribute("BaseVolume");

        if typeof(v19) ~= "number" then
            v19 = u12.Volume;
        end;

        u12.Volume = v19 * v16 * v18;
    end;
end;

function u1.SetBombPlantedMusicVolume(p20) -- Line: 134
    -- upvalues: updateBombPlantedMusicVolume (copy)
    updateBombPlantedMusicVolume(p20);
end;

local function GetRollOffDistance(p21, p22) -- Line: 149
    if p21 and p21.Properties then
        p22 = p21.Properties.RollOffMaxDistance or p22;
    end;

    return p22;
end;

local function GetLocalPlayerPosition() -- Line: 155
    -- upvalues: LocalPlayer (copy)
    local Character2 = LocalPlayer.Character;

    if Character2 and Character2:IsDescendantOf(workspace) then
        local Humanoid = Character2:FindFirstChild("Humanoid");
        local v23 = Humanoid and (Humanoid.Health > 0 and Character2:FindFirstChild("HumanoidRootPart"));

        if v23 then
            return v23.Position;
        end;
    end;

    return nil;
end;

local function GetWeaponAudio(p24) -- Line: 174
    -- upvalues: u4 (copy), ReplicatedStorage (copy)
    if u4[p24] then
        return u4[p24];
    end;

    local v25 = ReplicatedStorage.Database.Audio.Weapons:FindFirstChild(p24);

    if v25 then
        local success, result = pcall(require, v25);

        if success and result then
            u4[p24] = result;

            return result;
        end;
    end;

    return nil;
end;

function u1.GetPlayerNoiseCone() -- Line: 197
    -- upvalues: u5 (ref)
    if u5 and tick() - u5.Time >= 2 then
        u5 = nil;
    end;

    return u5;
end;

function u1.UpdatePlayerNoiseCone(p26, p27, p28) -- Line: 212
    -- upvalues: u5 (ref)
    local v29 = p27 * 0.5;
    local v30 = tick();

    if p28 then
        v29 = v29 * 0.5;
    end;

    if u5 and (v30 - u5.Time < 2 and v29 < u5.Range) then
        u5.Time = v30;

        return;
    end;

    u5 = {
        Position = p26,
        Range = v29,
        Time = v30
    };
end;

function u1.GetFootstepRange(p31, p32) -- Line: 242
    -- upvalues: FloorSounds (copy)
    local v33 = FloorSounds[p31] or FloorSounds.Concrete;
    local v34 = v33 and (v33.Properties and v33.Properties.RollOffMaxDistance) or 48;

    if p32 then
        v34 = v34 * 0.5 or v34;
    end;

    return v34;
end;

function u1.GetWeaponShootRange(p35, p36) -- Line: 250
    -- upvalues: u4 (copy), ReplicatedStorage (copy)
    local v37;

    if u4[p35] then
        v37 = u4[p35];
    else
        local v38 = ReplicatedStorage.Database.Audio.Weapons:FindFirstChild(p35);

        if v38 then
            local v39;
            v39, v37 = pcall(require, v38);

            if v39 and v37 then
                u4[p35] = v37;
            else
                v37 = nil;
            end;
        else
            v37 = nil;
        end;
    end;

    if not v37 then
        return p36 and 50 or 120;
    end;

    if p36 and v37.Silencer then
        local Silencer = v37.Silencer;

        return Silencer and (Silencer.Properties and Silencer.Properties.RollOffMaxDistance) or 50;
    end;

    local Shoot = v37.Shoot;

    return Shoot and (Shoot.Properties and Shoot.Properties.RollOffMaxDistance) or 120;
end;

function u1.GetMeleeRange(p40) -- Line: 266
    -- upvalues: u4 (copy), ReplicatedStorage (copy)
    local v41;

    if u4[p40] then
        v41 = u4[p40];
    else
        local v42 = ReplicatedStorage.Database.Audio.Weapons:FindFirstChild(p40);

        if v42 then
            local v43;
            v43, v41 = pcall(require, v42);

            if v43 and v41 then
                u4[p40] = v41;
            else
                v41 = nil;
            end;
        else
            v41 = nil;
        end;
    end;

    if not v41 then
        return 50;
    end;

    local HitOne = v41.HitOne;

    return HitOne and (HitOne.Properties and HitOne.Properties.RollOffMaxDistance) or 50;
end;

function u1.GetMovementRange(p44, p45) -- Line: 278
    -- upvalues: u2 (copy), Character (copy)
    local v46 = u2[p44] or 48;

    if p44 == "Landing" then
        local v47 = Character["Fall Damage"];

        if v47 and v47.Properties then
            v46 = v47.Properties.RollOffMaxDistance or v46;
        end;
    end;

    if p45 then
        v46 = v46 * 0.5 or v46;
    end;

    return v46;
end;

function u1.ClearPlayerNoiseCone() -- Line: 290
    -- upvalues: u5 (ref)
    u5 = nil;
end;

function u1.Initialize() -- Line: 297
    -- upvalues: ReplicatedStorage (copy), Sound (copy), ContentProvider (copy), Router (copy), MenuState (copy), CurrentCamera (copy), DataController (copy), LocalPlayer (copy), GameState (copy), RunServiceController (copy), Remotes (copy), FlashEffect (copy), DebugFlags (copy), u12 (ref), Players (copy), updateBombPlantedMusicVolume (copy), u9 (ref), u10 (ref), u11 (ref), u8 (copy), u7 (copy), isKnifeWeapon (copy), u1 (copy)
    for _, descendant in ipairs(ReplicatedStorage.Database.Audio:GetDescendants()) do
        if descendant:IsA("ModuleScript") then
            Sound.createSoundGroup(descendant);
        end;
    end;

    task.spawn(function() -- Line: 306
        -- upvalues: ContentProvider (ref), ReplicatedStorage (ref)
        ContentProvider:PreloadAsync({ ReplicatedStorage.Sounds });
    end);
    Router.observerRouter("RunRoundSound", function(p48) -- Line: 311
        -- upvalues: MenuState (ref), Sound (ref), CurrentCamera (ref)
        if MenuState.GetCurrentScreen() == nil then
            return Sound.new("Round"):playOneTime({
                Parent = CurrentCamera,
                Name = p48
            });
        end;
    end);
    Router.observerRouter("PlayCountdownTimer", function() -- Line: 325
        -- upvalues: DataController (ref), LocalPlayer (ref), MenuState (ref), Sound (ref)
        local v49 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Main Menu Volume") or 100) / 100;

        if MenuState.GetCurrentScreen() == nil then
            if v49 > 0 then
                Sound.new("Interface"):playOneTime({
                    Name = "Countdown Timer",
                    Parent = LocalPlayer.PlayerGui
                }, v49);
            end;

            return nil;
        end;
    end);
    local u50 = nil;
    local u51 = nil;
    local u52 = nil;

    local function getBuyPhaseFadeMultiplier(p53) -- Line: 349
        return p53 < 6 and 1 or math.max(0, 1 - (p53 - 6) * 0.2);
    end;

    local function updateBuyPhaseVolume(p54) -- Line: 360
        -- upvalues: u50 (ref), DataController (ref), LocalPlayer (ref), u52 (ref), u51 (ref)
        if not (u50 and u50.Parent) then
            return;
        end;

        local v55 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round Start Volume") or 50) / 50;
        local v56 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
        local v57 = u50:GetAttribute("BaseVolume") or u50.Volume;
        local v58;

        if p54 and u52 then
            local v59 = tick() - u52;
            v58 = v59 < 6 and 1 or math.max(0, 1 - (v59 - 6) * 0.2);
        else
            v58 = 1;
        end;

        u50.Volume = v57 * v55 * v56 * v58;

        if p54 and u52 then
            local v60 = tick() - u52;

            if (v60 < 6 and 1 or math.max(0, 1 - (v60 - 6) * 0.2)) <= 0 then
                if u51 then
                    u51:Disconnect();
                    u51 = nil;
                end;

                u50:Stop();
                u50:Destroy();
                u50 = nil;
                u52 = nil;
            end;
        end;
    end;

    GameState.ListenToState(function(p61, p62) -- Line: 394
        -- upvalues: LocalPlayer (ref), u50 (ref), u51 (ref), u52 (ref), DataController (ref), Sound (ref), CurrentCamera (ref), RunServiceController (ref), updateBuyPhaseVolume (copy)
        if p62 == "Buy Period" then
            local v63 = LocalPlayer:GetAttribute("Team");

            if v63 ~= "Counter-Terrorists" and v63 ~= "Terrorists" then
                return;
            end;

            if u50 then
                if u51 then
                    u51:Disconnect();
                    u51 = nil;
                end;

                if u50.Parent then
                    u50:Stop();
                    u50:Destroy();
                end;

                u50 = nil;
                u52 = nil;
            end;

            local v64 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round Start Volume") or 50) / 50;
            u50 = Sound.new("Round"):play({
                Name = "Buy Phase",
                Parent = CurrentCamera
            }, v64);

            if u50 then
                local u65 = u50;
                u65.Destroying:Once(function() -- Line: 430
                    -- upvalues: u50 (ref), u65 (copy), u52 (ref)
                    if u50 == u65 then
                        u50 = nil;
                        u52 = nil;
                    end;
                end);
                local v66 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
                local Volume = u50.Volume;

                if v64 > 0 and v66 > 0 then
                    Volume = Volume / (v64 * v66) or Volume;
                end;

                u50:SetAttribute("BaseVolume", Volume);
                u52 = tick();
                task.spawn(function() -- Line: 450
                    -- upvalues: u51 (ref), RunServiceController (ref), u50 (ref), u52 (ref), updateBuyPhaseVolume (ref)
                    u51 = RunServiceController.BindToHeartbeat("SoundController.BuyPhaseFade", function() -- Line: 453
                        -- upvalues: u50 (ref), u52 (ref), updateBuyPhaseVolume (ref), u51 (ref)
                        if u50 and u50.Parent then
                            if not u52 then
                                return;
                            end;

                            local v67 = tick() - u52;
                            local v68 = v67 >= 6;
                            updateBuyPhaseVolume(v68);

                            if v68 and (not (u50 and u50.Parent) or (v67 < 6 and 1 or math.max(0, 1 - (v67 - 6) * 0.2)) <= 0) and u51 then
                                u51:Disconnect();
                                u51 = nil;
                            end;
                        elseif u51 then
                            u51:Disconnect();
                            u51 = nil;
                        end;
                    end);
                end);
            end;
        elseif u50 then
            if u51 then
                u51:Disconnect();
                u51 = nil;
            end;

            if u50.Parent then
                u50:Stop();
                u50:Destroy();
            end;

            u50 = nil;
            u52 = nil;
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Audio.Music.Round Start Volume", function() -- Line: 500
        -- upvalues: updateBuyPhaseVolume (copy), u51 (ref)
        updateBuyPhaseVolume(u51 ~= nil);
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", function() -- Line: 503
        -- upvalues: updateBuyPhaseVolume (copy), u51 (ref)
        updateBuyPhaseVolume(u51 ~= nil);
    end);
    Remotes.Sound.ReplicateSound.Listen(function(p69) -- Line: 508
        -- upvalues: FlashEffect (ref), DebugFlags (ref), u12 (ref), Sound (ref), Players (ref), LocalPlayer (ref), MenuState (ref), GameState (ref), DataController (ref), updateBombPlantedMusicVolume (ref)
        local v70 = FlashEffect.GetAudioFadeMultiplier();

        if DebugFlags.IsEnabled("WeaponFX") then
            local v71 = p69 and p69.Name and (tostring(p69.Name) or "") or "";
            local v72 = p69 and p69.Class and (tostring(p69.Class) or "") or "";
            local v73 = string.lower(v71);

            if string.find(v73, "shoot", 1, true) or string.find(v73, "fire", 1, true) then
                local v74 = FlashEffect.IsFlashed();
                local v75 = warn;
                local v76 = tostring(v74);
                local v77;

                if p69 then
                    v77 = p69.Parent;
                else
                    v77 = p69;
                end;

                local v78 = tostring(v77);
                local v79;

                if p69 then
                    v79 = p69.Position;
                else
                    v79 = p69;
                end;

                local v80 = tostring(v79);
                local v81;

                if p69 then
                    v81 = p69.Path;
                else
                    v81 = p69;
                end;

                v75(("[WeaponFX][Client][Sound] recv class=%s name=%s flashed=%s parent=%s position=%s path=%s"):format(v72, v71, v76, v78, v80, (tostring(v81))));
            end;
        end;

        if p69.Name == "Bomb Planted Music" and (p69.Class == "Counter-Terrorists" and u12) then
            if u12.Parent then
                u12:Stop();
                u12:Destroy();
            end;

            u12 = nil;
        end;

        if p69.Position then
            Sound.new(p69.Class):PlaySoundAtPosition({
                Position = p69.Position,
                Class = p69.Class,
                Name = p69.Name
            }, tonumber(p69.Duration), v70);

            return;
        end;

        if p69.Parent or p69.Path then
            if p69.Parent and p69.Parent:IsA("BasePart") then
                local Parent = p69.Parent;

                if Parent and Parent.Name == "Head" then
                    local Parent2 = Parent.Parent;

                    if Parent2 and (Parent2:IsA("Model") and (Parent2:IsDescendantOf(workspace) and Players:GetPlayerFromCharacter(Parent2) == LocalPlayer)) then
                        if DebugFlags.IsEnabled("WeaponFX") then
                            warn(("[WeaponFX][Client][Sound] skipped local duplicate head sound name=%s class=%s"):format(tostring(p69.Name), (tostring(p69.Class))));
                        end;

                        return;
                    end;
                end;
            end;

            if (p69.Name == "Bomb Planted" or (p69.Name == "Bomb Defused" or p69.Name == "Hostage Rescued")) and MenuState.GetCurrentScreen() ~= nil then
                return;
            end;

            if p69.Name == "Bomb Planted Music" and p69.Class == "Counter-Terrorists" then
                if GameState.GetState() ~= "Round In Progress" then
                    return;
                end;

                if MenuState.GetCurrentScreen() ~= nil then
                    return;
                end;

                v70 = v70 * ((DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50) / 50);
            elseif (p69.Name == "Counter-Terrorists Win" or p69.Name == "Terrorists Win") and p69.Class == "Round" then
                if MenuState.GetCurrentScreen() ~= nil then
                    return;
                end;

                v70 = v70 * ((DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50);
            end;

            local u82 = Sound.new(p69.Class):playOneTime({
                Parent = p69.Parent,
                Name = p69.Name,
                Path = p69.Path
            }, v70);

            if (p69.Name == "Counter-Terrorists Win" or p69.Name == "Terrorists Win") and (p69.Class == "Round" and u82) then
                if u82 then
                    local v83 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50;
                    local v84 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
                    local Volume = u82.Volume;

                    if v83 > 0 and v84 > 0 then
                        Volume = Volume / (v83 * v84) or Volume;
                    end;

                    u82:SetAttribute("BaseVolume", Volume);

                    local function updateRoundWinVolume() -- Line: 630
                        -- upvalues: u82 (copy), DataController (ref), LocalPlayer (ref), Volume (copy)
                        if u82 and u82.Parent then
                            local v85 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50;
                            local v86 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
                            u82.Volume = (u82:GetAttribute("BaseVolume") or Volume) * v85 * v86;
                        end;
                    end;

                    local u87 = DataController.CreateListener(LocalPlayer, "Settings.Audio.Music.Round End Volume", updateRoundWinVolume);
                    local u88 = DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", updateRoundWinVolume);
                    u82.Destroying:Once(function() -- Line: 646
                        -- upvalues: DataController (ref), LocalPlayer (ref), u87 (copy), u88 (copy)
                        DataController.RemoveListener(LocalPlayer, "Settings.Audio.Music.Round End Volume", u87);
                        DataController.RemoveListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", u88);
                    end);
                end;
            else
                u12 = p69.Name == "Bomb Planted Music" and (p69.Class == "Counter-Terrorists" and u82);

                if u12 then
                    local v89 = (DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50) / 50;
                    local v90 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
                    local Volume = u12.Volume;

                    if v89 > 0 and v90 > 0 then
                        Volume = Volume / (v89 * v90) or Volume;
                    end;

                    u12:SetAttribute("BaseVolume", Volume);

                    local function updateBombPlantedVolume() -- Line: 669
                        -- upvalues: u12 (ref), DataController (ref), LocalPlayer (ref), updateBombPlantedMusicVolume (ref)
                        if u12 and u12.Parent then
                            updateBombPlantedMusicVolume(DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50);
                        end;
                    end;

                    local u91 = DataController.CreateListener(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume", updateBombPlantedVolume);
                    local u92 = DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", updateBombPlantedVolume);
                    u12.Destroying:Once(function() -- Line: 680
                        -- upvalues: DataController (ref), LocalPlayer (ref), u91 (copy), u92 (copy)
                        DataController.RemoveListener(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume", u91);
                        DataController.RemoveListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", u92);
                    end);
                end;
            end;
        end;
    end);
    local CollectionService = game:GetService("CollectionService");

    local function setupBombDefuseListener() -- Line: 693
        -- upvalues: CollectionService (copy), u12 (ref)
        local u93 = CollectionService:GetTagged("Bomb")[1];

        if u93 and u93:IsDescendantOf(workspace) then
            local u94 = nil;
            u94 = u93:GetAttributeChangedSignal("Defused"):Connect(function() -- Line: 697
                -- upvalues: u93 (copy), u12 (ref), u94 (ref)
                if u93:GetAttribute("Defused") then
                    if u12 then
                        if u12.Parent then
                            u12:Stop();
                            u12:Destroy();
                        end;

                        u12 = nil;
                    end;

                    if u94 then
                        u94:Disconnect();
                    end;
                end;
            end);
        end;
    end;

    CollectionService:GetInstanceAddedSignal("Bomb"):Connect(function(p95) -- Line: 716
        -- upvalues: setupBombDefuseListener (copy)
        setupBombDefuseListener();
    end);
    task.defer(function() -- Line: 721
        -- upvalues: setupBombDefuseListener (copy)
        setupBombDefuseListener();
    end);
    GameState.ListenToState(function(p96, p97) -- Line: 726
        -- upvalues: u12 (ref)
        if p97 ~= "Round In Progress" and u12 then
            if u12.Parent then
                u12:Stop();
                u12:Destroy();
            end;

            u12 = nil;
        end;
    end);
    Remotes.UI.UIPlayerKilled.Listen(function(p98) -- Line: 737
        -- upvalues: LocalPlayer (ref), u9 (ref), u10 (ref), u11 (ref), u8 (ref), u7 (ref), isKnifeWeapon (ref), Sound (ref)
        if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
            return;
        end;

        local v99 = tostring(LocalPlayer.UserId);

        if p98.Victim == v99 then
            u9 = 0;

            if u10 then
                local v100 = u10;
                u10 = nil;
                u11 = 0;

                if v100.Parent then
                    v100:Stop();
                    v100:Destroy();
                end;
            end;

            return;
        end;

        if p98.Killer ~= v99 then
            return;
        end;

        u9 = u9 + 1;
        local u101 = u8[math.min(u9, 9)];
        local u102;

        if u101 then
            u102 = u7[u101] or 0;
        else
            u102 = 0;
            u101 = nil;
        end;

        if p98.Headshot and u102 < 1 then
            u102 = 1;
            u101 = "Headshot";
        end;

        if p98.Weapon and (isKnifeWeapon(p98.Weapon) and u102 < 2) then
            u101 = "Humiliation";
            u102 = 2;
        end;

        if not u101 then
            return;
        end;

        if u102 < u11 then
            return;
        end;

        if u10 then
            local v103 = u10;
            u10 = nil;
            u11 = 0;

            if v103.Parent then
                v103:Stop();
                v103:Destroy();
            end;
        end;

        task.delay(0.2, function() -- Line: 791
            -- upvalues: u102 (ref), u11 (ref), u10 (ref), Sound (ref), LocalPlayer (ref), u101 (ref)
            if u102 < u11 then
                return;
            end;

            if u10 then
                local v104 = u10;
                u10 = nil;
                u11 = 0;

                if v104.Parent then
                    v104:Stop();
                    v104:Destroy();
                end;
            end;

            local u105 = Sound.new("Deathmatch"):play({
                Parent = LocalPlayer.PlayerGui,
                Name = u101
            });

            if u105 then
                u10 = u105;
                u11 = u102;
                u105.Ended:Once(function() -- Line: 805
                    -- upvalues: u10 (ref), u105 (copy), u11 (ref)
                    if u10 == u105 then
                        u10 = nil;
                        u11 = 0;
                    end;
                end);
                u105.Destroying:Once(function() -- Line: 811
                    -- upvalues: u10 (ref), u105 (copy), u11 (ref)
                    if u10 == u105 then
                        u10 = nil;
                        u11 = 0;
                    end;
                end);
            end;
        end);
    end);
    Remotes.Sound.StopSoundAtPosition.Listen(function(p106) -- Line: 822
        local Debris = workspace:FindFirstChild("Debris");

        if not Debris then
            return;
        end;

        for _, child in ipairs(Debris:GetChildren()) do
            if child.Name == "Sound" and (child:IsA("BasePart") and (child.Position - p106.Position).Magnitude <= p106.Radius) then
                child:Destroy();
            end;
        end;
    end);
    Router.observerRouter("UpdatePlayerNoiseCone", function(p107, p108, p109, p110) -- Line: 838
        -- upvalues: u1 (ref)
        if typeof(p109) ~= "number" then
            p109 = ({
                Footstep = u1.GetFootstepRange(p109 or "Concrete", p110),
                Landing = u1.GetMovementRange("Landing", p110),
                Jump = u1.GetMovementRange("Jump", p110)
            })[p107];
        end;

        if not p109 then
            return nil;
        end;

        u1.UpdatePlayerNoiseCone(p108, p109, p110);

        return nil;
    end);
end;

function u1.Start() -- Line: 862
    -- upvalues: Observers (copy), LocalPlayer (copy), u3 (copy), MovementSounds (copy), u1 (copy), u9 (ref), u10 (ref), u11 (ref), Players (copy), RunServiceController (copy)
    Observers.observeCharacter(function(p111, p112) -- Line: 864
        -- upvalues: LocalPlayer (ref), u3 (ref), MovementSounds (ref), u1 (ref), u9 (ref), u10 (ref), u11 (ref)
        local u113 = u3[p111];

        if not u113 then
            u113 = MovementSounds.new(p111);
            u3[p111] = u113;
        end;

        if p111 == LocalPlayer then
            u1.ClearPlayerNoiseCone();
            u9 = 0;

            if u10 then
                local v114 = u10;
                u10 = nil;
                u11 = 0;

                if v114.Parent then
                    v114:Stop();
                    v114:Destroy();
                end;
            end;
        end;

        u113:SetCharacter(p112);

        return function() -- Line: 885
            -- upvalues: u113 (ref)
            u113:SetCharacter(nil);
        end;
    end);
    Players.PlayerRemoving:Connect(function(p115) -- Line: 891
        -- upvalues: u3 (ref)
        local v116 = u3[p115];

        if v116 then
            u3[p115] = nil;
            v116:Destroy();
        end;
    end);
    RunServiceController.BindToHeartbeat("SoundController.MovementSounds", function(p117) -- Line: 900
        -- upvalues: LocalPlayer (ref), u3 (ref)
        local Character2 = LocalPlayer.Character;
        local v118;

        if Character2 and Character2:IsDescendantOf(workspace) then
            local Humanoid = Character2:FindFirstChild("Humanoid");
            local v119 = Humanoid and (Humanoid.Health > 0 and Character2:FindFirstChild("HumanoidRootPart"));

            if v119 then
                v118 = v119.Position;
            else
                v118 = nil;
            end;
        else
            v118 = nil;
        end;

        for _, v in pairs(u3) do
            v:Update(p117, v118);
        end;
    end);
end;

return u1;