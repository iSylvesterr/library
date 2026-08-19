-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local HttpService = game:GetService("HttpService");
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Colors = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Colors);
require(ReplicatedStorage.Database.Custom.Types);
local u2 = TweenInfo.new(0.66, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out);
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = false;
local LocalPlayer = Players.LocalPlayer;

local function commaNumber(p10) -- Line: 39
    return tostring(p10):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function getItemProperties(p11, p12) -- Line: 43
    -- upvalues: ReplicatedStorage (copy)
    local v13 = ReplicatedStorage.Database.Custom:FindFirstChild(p11) or ReplicatedStorage.Database.Custom.GameStats:FindFirstChild(p11);

    if not (v13 and v13:IsA("Folder")) then
        return nil;
    end;

    local v14 = v13:FindFirstChild(p12);

    if not (v14 and v14:IsA("ModuleScript")) then
        return nil;
    end;

    local success, result = pcall(require, v14);

    return success and result and result or nil;
end;

local function playerHasBomb(p15) -- Line: 63
    -- upvalues: HttpService (copy)
    local v16 = p15:GetAttribute("Slot5");

    if not v16 then
        return false;
    end;

    local v17 = HttpService:JSONDecode(v16 or "[]");

    if v17 then
        v17 = v17.Weapon == "C4";
    end;

    return v17;
end;

local function parseArmorAttribute(u18) -- Line: 73
    -- upvalues: HttpService (copy)
    if typeof(u18) ~= "string" or u18 == "" then
        return nil;
    end;

    local success, result = pcall(function() -- Line: 78
        -- upvalues: HttpService (ref), u18 (copy)
        return HttpService:JSONDecode(u18);
    end);

    return success and typeof(result) == "table" and {
        Type = tostring(result.Type) or "",
        Health = tonumber(result.Health) or 0
    } or nil;
end;

local function getWeaponNameFromSlotAttribute(u19) -- Line: 92
    -- upvalues: HttpService (copy)
    if typeof(u19) ~= "string" or u19 == "" then
        return nil;
    end;

    local success, result = pcall(function() -- Line: 97
        -- upvalues: HttpService (ref), u19 (copy)
        return HttpService:JSONDecode(u19);
    end);

    if not success or typeof(result) ~= "table" then
        return nil;
    end;

    local Weapon = result.Weapon;

    if typeof(Weapon) == "string" and Weapon ~= "" then
        return Weapon;
    end;

    return nil;
end;

local function getTemplateHealthParts(p20) -- Line: 113
    local Health = p20:FindFirstChild("Health");
    local v21;

    if Health then
        v21 = Health:FindFirstChild("Bar");
    else
        v21 = Health;
    end;

    return Health, v21;
end;

local function setTemplateLifeState(p22, p23) -- Line: 119
    local Health = p22:FindFirstChild("Health");
    local v24;

    if Health then
        v24 = Health:FindFirstChild("Bar");
    else
        v24 = Health;
    end;

    local PlayerBackground = p22:FindFirstChild("PlayerBackground");
    local v25;

    if PlayerBackground then
        v25 = PlayerBackground:FindFirstChild("Player");
    else
        v25 = PlayerBackground;
    end;

    local v26;

    if v25 then
        v26 = v25:FindFirstChild("X");
    else
        v26 = v25;
    end;

    local Info = p22:FindFirstChild("Info");
    local v27;

    if Info then
        v27 = Info:FindFirstChild("Weapon");
    else
        v27 = Info;
    end;

    local v28;

    if Info then
        v28 = Info:FindFirstChild("Grenades");
    else
        v28 = Info;
    end;

    local v29;

    if Info then
        v29 = Info:FindFirstChild("Items");
    else
        v29 = Info;
    end;

    if p23 then
        if v24 then
            v24.Size = UDim2.fromScale(0, 1);
        end;

        if Health then
            Health.Visible = false;
        end;

        if v25 then
            v25.ImageTransparency = 0.5;
        end;

        if v26 then
            v26.Visible = true;
        end;

        if Info then
            Info.BackgroundTransparency = 0.75;

            if v27 then
                v27.Visible = false;
            end;

            if v28 then
                v28.Visible = false;
            end;

            if v29 then
                v29.Visible = false;
            end;
        end;

        if PlayerBackground then
            PlayerBackground.Transparency = 0.5;

            return Health, v24;
        end;
    else
        if v25 then
            v25.ImageTransparency = 0;
        end;

        if v26 then
            v26.Visible = false;
        end;

        if Info then
            Info.BackgroundTransparency = 0;
        end;

        if PlayerBackground then
            PlayerBackground.Transparency = 0;
        end;
    end;

    return Health, v24;
end;

local function updateTemplateGrenades(p30, p31) -- Line: 183
    -- upvalues: u5 (copy), getItemProperties (copy)
    local Info = p30:FindFirstChild("Info");

    if not Info then
        return;
    end;

    local Grenades = Info:FindFirstChild("Grenades");

    if not Grenades then
        return;
    end;

    local v32 = u5[p31] or {};

    for i = 1, 4 do
        local v33 = Grenades:FindFirstChild((tostring(i)));

        if v33 then
            local v34 = v32[i];

            if v34 then
                local v35 = getItemProperties("Weapons", v34);
                v33.Image = v35 and v35.Icon or "";
                v33.Visible = true;
            else
                v33.Image = "";
                v33.Visible = false;
            end;
        end;
    end;

    Grenades.Visible = true;
end;

local function isTeammate(p36) -- Line: 213
    -- upvalues: LocalPlayer (copy)
    local v37 = LocalPlayer:GetAttribute("Team");
    local v38 = p36:GetAttribute("Team");

    if v37 and v38 then
        return v37 == v38;
    end;

    return false;
end;

local function summarizeDamageArray(p39) -- Line: 224
    if not p39 or #p39 == 0 then
        return nil, nil;
    end;

    local v40 = 0;

    for _, v in p39 do
        v40 = v40 + v;
    end;

    return v40, #p39;
end;

local function updateDamageFromMatrix(p41, p42, p43) -- Line: 239
    if not (p41 and p41.Parent) then
        return;
    end;

    local Info = p41:FindFirstChild("Info");

    if not Info then
        return;
    end;

    local Damages = Info:FindFirstChild("Damages");

    if not Damages then
        return;
    end;

    local v44, v45;

    if p42 and #p42 ~= 0 then
        v44 = #p42;
        v45 = 0;

        for _, v in p42 do
            v45 = v45 + v;
        end;
    else
        v45 = nil;
        v44 = nil;
    end;

    local v46, v47;

    if p43 and #p43 ~= 0 then
        v46 = #p43;
        v47 = 0;

        for _, v in p43 do
            v47 = v47 + v;
        end;
    else
        v47 = nil;
        v46 = nil;
    end;

    Damages.Visible = v45 ~= nil and true or v47 ~= nil;
    local Outgoing = Damages:FindFirstChild("Outgoing");

    if Outgoing then
        if v45 then
            Outgoing.Text = `{math.min(v45, 100)} in {v44}`;
            Outgoing.Visible = true;
        else
            Outgoing.Text = "";
            Outgoing.Visible = false;
        end;
    end;

    local Incoming = Damages:FindFirstChild("Incoming");

    if Incoming then
        if v47 then
            Incoming.Text = `{math.min(v47, 100)} in {v46}`;
            Incoming.Visible = true;

            return;
        end;

        Incoming.Text = "";
        Incoming.Visible = false;
    end;
end;

local function setTemplateKills(p48, p49) -- Line: 282
    local Kills = p48:FindFirstChild("Kills");

    if not Kills then
        return;
    end;

    for i = 1, 5 do
        local v50 = Kills:FindFirstChild((tostring(i)));

        if v50 then
            v50.Visible = i <= p49;
        end;
    end;
end;

local function hideTeammateOnlyInfo(p51) -- Line: 296
    local DefuseKit = p51:FindFirstChild("DefuseKit");

    if DefuseKit then
        DefuseKit.Visible = false;
    end;

    local Bomb = p51:FindFirstChild("Bomb");

    if Bomb then
        Bomb.Visible = false;
    end;

    local Info = p51:FindFirstChild("Info");

    if not Info then
        return;
    end;

    local Weapon = Info:FindFirstChild("Weapon");

    if Weapon then
        Weapon.Visible = false;
    end;

    local Cash = Info:FindFirstChild("Cash");

    if Cash then
        Cash.Visible = false;
    end;

    local Items = Info:FindFirstChild("Items");

    if Items then
        Items.Visible = false;
    end;

    local Grenades = Info:FindFirstChild("Grenades");

    if Grenades then
        Grenades.Visible = false;
    end;
end;

local function getCompetitiveStroke(p52) -- Line: 333
    local PlayerBackground = p52:FindFirstChild("PlayerBackground");

    if PlayerBackground then
        PlayerBackground = PlayerBackground:FindFirstChildOfClass("UIStroke");
    end;

    return PlayerBackground;
end;

local function ensureDefaultStrokeColor(p53) -- Line: 338
    local v54 = p53:GetAttribute("DefaultStrokeColor");

    if not v54 then
        v54 = p53.Color;
        p53:SetAttribute("DefaultStrokeColor", v54);
    end;

    return v54 or p53.Color;
end;

local function shouldShowInfoForPlayer(p55) -- Line: 348
    -- upvalues: u9 (ref), LocalPlayer (copy), u6 (copy), u7 (copy)
    if workspace:GetAttribute("Gamemode") == "Deathmatch" then
        return true;
    end;

    if workspace:GetAttribute("GameState") == "Warmup" then
        return false;
    end;

    if not u9 then
        return false;
    end;

    local v56 = LocalPlayer:GetAttribute("Team");
    local v57 = p55:GetAttribute("Team");
    local v58;

    if v56 and v57 then
        v58 = v56 == v57;
    else
        v58 = false;
    end;

    return v58 and true or ((u6[p55.UserId] or 0) > 0 and true or u7[p55.UserId] == true);
end;

local function setTemplateInfoRevealed(u59, p60, p61) -- Line: 370
    -- upvalues: u4 (copy), Janitor (copy), LocalPlayer (copy), getWeaponNameFromSlotAttribute (copy), getItemProperties (copy), Observers (copy), parseArmorAttribute (copy), HttpService (copy), updateTemplateGrenades (copy), hideTeammateOnlyInfo (copy), TweenService (copy), u2 (copy)
    if not (p60 and p60.Parent) then
        return;
    end;

    local Info = p60:FindFirstChild("Info");

    if not Info then
        return;
    end;

    local v62 = u4[Info];

    if v62 then
        v62:Cleanup();
    else
        v62 = Janitor.new();
        v62:LinkToInstance(p60);
        u4[Info] = v62;
    end;

    local v63 = Info:GetAttribute("OriginalSize");

    if not v63 then
        v63 = Info.Size;
        Info:SetAttribute("OriginalSize", v63);

        if not p61 then
            Info.Size = UDim2.fromScale(1, 0);
        end;
    end;

    if not p61 then
        local v64 = TweenService:Create(Info, u2, {
            Size = UDim2.fromScale(1, 0)
        });
        v64:Play();
        v62:Add(v64.Completed:Once(function(p65) -- Line: 488
            -- upvalues: Info (copy)
            if p65 == Enum.PlaybackState.Completed then
                Info.Visible = false;
            end;
        end));

        return;
    end;

    local v66 = LocalPlayer:GetAttribute("Team");
    local v67 = u59:GetAttribute("Team");
    local v68;

    if v66 and v67 then
        v68 = v66 == v67;
    else
        v68 = false;
    end;

    if v68 then
        local Character = u59.Character;

        if Character then
            Character = Character:GetAttribute("Dead") == true;
        end;

        local v69 = u59:GetAttribute("IsSpectating") == true;
        local v70;

        if Character == true then
            v70 = false;
        else
            v70 = v69 ~= true;
        end;

        local Weapon = Info:FindFirstChild("Weapon");

        if Weapon then
            local function updateEquippedWeaponImageFromSlots() -- Line: 410
                -- upvalues: getWeaponNameFromSlotAttribute (ref), u59 (copy), getItemProperties (ref), Weapon (copy)
                local v71 = getWeaponNameFromSlotAttribute(u59:GetAttribute("Slot1")) or (getWeaponNameFromSlotAttribute(u59:GetAttribute("Slot2")) or getWeaponNameFromSlotAttribute(u59:GetAttribute("Slot3")));

                if not v71 then
                    Weapon.Image = "";

                    return;
                end;

                local v72 = getItemProperties("Weapons", v71);
                Weapon.Image = v72 and v72.Icon or "";
            end;

            v62:Add(u59:GetAttributeChangedSignal("Slot1"):Connect(updateEquippedWeaponImageFromSlots));
            v62:Add(u59:GetAttributeChangedSignal("Slot2"):Connect(updateEquippedWeaponImageFromSlots));
            v62:Add(u59:GetAttributeChangedSignal("Slot3"):Connect(updateEquippedWeaponImageFromSlots));
            updateEquippedWeaponImageFromSlots();
            Weapon.Visible = v70;
        end;

        local Cash = Info:FindFirstChild("Cash");

        if Cash then
            v62:Add(Observers.observeAttribute(u59, "Money", function(p73) -- Line: 435
                -- upvalues: Cash (copy)
                Cash.Text = p73 and `${tostring(p73):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")}` or "";

                return nil;
            end));
            Cash.Visible = true;
        end;

        local Items = Info:FindFirstChild("Items");

        if Items then
            local Armor = Items:FindFirstChild("Armor");

            if Armor then
                local function updateArmor() -- Line: 447
                    -- upvalues: parseArmorAttribute (ref), u59 (copy), Armor (copy)
                    local v74 = parseArmorAttribute(u59:GetAttribute("Armor"));
                    local v75;

                    if v74 == nil then
                        v75 = false;
                    else
                        v75 = v74.Health > 0;
                    end;

                    Armor.Visible = v75;
                end;

                v62:Add(u59:GetAttributeChangedSignal("Armor"):Connect(updateArmor));
                local v76 = parseArmorAttribute(u59:GetAttribute("Armor"));
                local v77;

                if v76 == nil then
                    v77 = false;
                else
                    v77 = v76.Health > 0;
                end;

                Armor.Visible = v77;
            end;

            local Bomb = Items:FindFirstChild("Bomb");

            if Bomb then
                v62:Add(u59:GetAttributeChangedSignal("Slot5"):Connect(function() -- Line: 465
                    -- upvalues: Bomb (copy), u59 (copy), HttpService (ref)
                    local v78 = u59:GetAttribute("Slot5");
                    local v79;

                    if v78 then
                        v79 = HttpService:JSONDecode(v78 or "[]");

                        if v79 then
                            v79 = v79.Weapon == "C4";
                        end;
                    else
                        v79 = false;
                    end;

                    Bomb.Visible = v79;
                end));
                local v80 = u59:GetAttribute("Slot5");
                local v81;

                if v80 then
                    v81 = HttpService:JSONDecode(v80 or "[]");

                    if v81 then
                        v81 = v81.Weapon == "C4";
                    end;
                else
                    v81 = false;
                end;

                Bomb.Visible = v81;
            end;

            Items.Visible = true;
        end;

        updateTemplateGrenades(p60, u59.UserId);
    else
        hideTeammateOnlyInfo(p60);
    end;

    Info.Visible = true;
    TweenService:Create(Info, u2, {
        Size = v63
    }):Play();
end;

local function refreshTemplateInfoVisibilityForPlayer(p82) -- Line: 496
    -- upvalues: u3 (copy), setTemplateInfoRevealed (copy), shouldShowInfoForPlayer (copy)
    local v83 = u3[p82.UserId];

    if not (v83 and v83.Parent) then
        return;
    end;

    setTemplateInfoRevealed(p82, v83, (shouldShowInfoForPlayer(p82)));
end;

local function setupBombDefusalTemplate(p84, u85, u86, p87) -- Line: 505
    -- upvalues: Janitor (copy), setTemplateLifeState (copy), u9 (ref), u3 (copy), setTemplateInfoRevealed (copy), shouldShowInfoForPlayer (copy), LocalPlayer (copy), u1 (copy), TweenService (copy), Observers (copy), HttpService (copy)
    local u88 = u86:GetAttribute("Team");
    local u89 = workspace:GetAttribute("Gamemode");
    local u90 = nil;

    local function monitorHealthBar(p91) -- Line: 515
        -- upvalues: u90 (ref), Janitor (ref), u85 (copy), u86 (copy), setTemplateLifeState (ref), u9 (ref), u3 (ref), setTemplateInfoRevealed (ref), shouldShowInfoForPlayer (ref), LocalPlayer (ref), u1 (ref), u88 (copy), TweenService (ref), Observers (ref)
        if u90 then
            u90:Destroy();
            u90 = nil;
        end;

        local v92 = Janitor.new();
        u90 = v92;
        local Humanoid = p91:WaitForChild("Humanoid", 3);

        if not (u85 and u85.Parent) then
            return;
        end;

        local function updateDeadState() -- Line: 529
            -- upvalues: u85 (ref), u86 (ref), setTemplateLifeState (ref), u9 (ref), u3 (ref), setTemplateInfoRevealed (ref), shouldShowInfoForPlayer (ref), LocalPlayer (ref), u1 (ref)
            if not (u85 and u85.Parent) then
                return;
            end;

            local Character = u86.Character;
            local v93;

            if Character then
                v93 = Character:GetAttribute("Dead") == true;
            else
                v93 = Character;
            end;

            local v94 = u86:GetAttribute("IsSpectating") == true;
            local v95 = v93 == true and true or v94 == true;
            local u96, u97 = setTemplateLifeState(u85, v95);

            if not v95 and u9 then
                local v98 = u86;
                local v99 = u3[v98.UserId];

                if v99 and v99.Parent then
                    setTemplateInfoRevealed(v98, v99, (shouldShowInfoForPlayer(v98)));
                end;
            end;

            if not v95 then
                local v100 = LocalPlayer:GetAttribute("Team");
                local v101 = u86:GetAttribute("Team");
                local v102;

                if v100 and v101 then
                    v102 = v100 == v101;
                else
                    v102 = false;
                end;

                if v102 and Character then
                    local u103 = Character:FindFirstChildOfClass("Humanoid");

                    if u103 and (u96 and u97) then
                        local function updateHealthBar() -- Line: 547
                            -- upvalues: u103 (copy), u85 (ref), u97 (copy), u96 (copy)
                            if u103 and (u103.Parent and (u85 and (u85.Parent and u97))) then
                                local v104 = math.floor(u103.Health) / u103.MaxHealth;
                                local v105 = math.clamp(v104, 0, 1);
                                u97.Size = UDim2.fromScale(v105, 1);
                                u96.Visible = true;
                            end;
                        end;

                        if u103 and (u103.Parent and (u85 and (u85.Parent and u97))) then
                            local v106 = math.floor(u103.Health) / u103.MaxHealth;
                            local v107 = math.clamp(v106, 0, 1);
                            u97.Size = UDim2.fromScale(v107, 1);
                            u96.Visible = true;
                        end;

                        task.delay(0.5, updateHealthBar);
                    end;
                end;
            end;

            u1.refreshCompetitiveColors();
        end;

        updateDeadState();
        local Health = u85:FindFirstChild("Health");
        local u108;

        if Health then
            u108 = Health:FindFirstChild("Bar");
        else
            u108 = Health;
        end;

        if Humanoid then
            v92:Add(Humanoid:GetPropertyChangedSignal("Health"):Connect(function() -- Line: 575
                -- upvalues: u86 (ref), Humanoid (copy), LocalPlayer (ref), u88 (ref), u108 (copy), TweenService (ref)
                local Character = u86.Character;

                if Character then
                    Character = Character:GetAttribute("Dead") == true;
                end;

                if not Character and (u86:GetAttribute("IsSpectating") ~= true and (Humanoid and (Humanoid.Parent and (LocalPlayer:GetAttribute("Team") == u88 and u108)))) then
                    local v109 = TweenInfo.new(0.25);
                    local v110 = {};
                    local fromScale = UDim2.fromScale;
                    local v111 = math.floor(Humanoid.Health) / Humanoid.MaxHealth;
                    v110.Size = fromScale(math.clamp(v111, 0, 1), 1);
                    TweenService:Create(u108, v109, v110):Play();
                end;
            end));
        end;

        if Health then
            v92:Add(p91:GetAttributeChangedSignal("Dead"):Connect(updateDeadState));
        end;

        v92:Add(Observers.observeAttribute(u86, "IsSpectating", function(p112) -- Line: 603
            -- upvalues: updateDeadState (copy)
            updateDeadState();

            return nil;
        end));
    end;

    if u88 == "Terrorists" then
        p84:Add(Observers.observeAttribute(u86, "Slot5", function(p113) -- Line: 611
            -- upvalues: u86 (copy), LocalPlayer (ref), HttpService (ref), u85 (copy)
            local v114 = u86:GetAttribute("Team");
            local v115 = LocalPlayer:GetAttribute("Team");
            local v116 = HttpService:JSONDecode(p113 or "[]");
            local Bomb = u85:FindFirstChild("Bomb");

            if Bomb then
                if v114 == v115 then
                    if v116 then
                        v116 = v116.Weapon == "C4";
                    end;
                else
                    v116 = false;
                end;

                Bomb.Visible = v116;
            end;

            return function() -- Line: 622
                -- upvalues: u85 (ref)
                local Bomb2 = u85:FindFirstChild("Bomb");

                if Bomb2 then
                    Bomb2.Visible = false;
                end;
            end;
        end));
    elseif u88 == "Counter-Terrorists" then
        local function updateObjectiveKitVisibility() -- Line: 630
            -- upvalues: LocalPlayer (ref), u86 (copy), u89 (copy), u85 (copy)
            local v117 = LocalPlayer:GetAttribute("Team");
            local v118 = u86:GetAttribute("Team");
            local v119;

            if u89 == "Hostage Rescue" then
                v119 = u86:GetAttribute("HasRescueKit") == true;
            else
                v119 = u86:GetAttribute("HasDefuseKit") == true;
            end;

            local DefuseKit = u85:FindFirstChild("DefuseKit");

            if DefuseKit then
                if v119 then
                    v119 = v118 == v117;
                end;

                DefuseKit.Visible = v119;
            end;
        end;

        local function hideObjectiveKits() -- Line: 644
            -- upvalues: u85 (copy)
            local DefuseKit = u85:FindFirstChild("DefuseKit");

            if DefuseKit then
                DefuseKit.Visible = false;
            end;
        end;

        p84:Add(Observers.observeAttribute(u86, "HasDefuseKit", function(p120) -- Line: 651
            -- upvalues: updateObjectiveKitVisibility (copy), hideObjectiveKits (copy)
            updateObjectiveKitVisibility();

            return hideObjectiveKits;
        end));
        p84:Add(Observers.observeAttribute(u86, "HasRescueKit", function(p121) -- Line: 656
            -- upvalues: updateObjectiveKitVisibility (copy), hideObjectiveKits (copy)
            updateObjectiveKitVisibility();

            return hideObjectiveKits;
        end));
        updateObjectiveKitVisibility();
    end;

    if u86.Character then
        monitorHealthBar(u86.Character);
    else
        setTemplateLifeState(u85, true);
    end;

    p84:Add(function() -- Line: 671
        -- upvalues: u90 (ref)
        if u90 then
            u90:Destroy();
            u90 = nil;
        end;
    end);
    p84:Add(u86.CharacterAdded:Connect(monitorHealthBar));
end;

local function setupDeathmatchTemplate(p122, u123, p124, p125) -- Line: 683
    -- upvalues: Colors (copy), Observers (copy)
    local v126 = p124:GetAttribute("Team");
    local Info = u123:FindFirstChild("Info");

    if Info then
        local UIStroke = Info:FindFirstChild("UIStroke");

        if UIStroke then
            UIStroke.Color = Colors["Team Color"][v126];
        end;

        local Amount = Info:FindFirstChild("Amount");

        if Amount then
            Amount.Text = "0";
        end;
    end;

    local UIStroke = u123:FindFirstChild("UIStroke");

    if UIStroke then
        UIStroke.Color = Colors["Team Color"][v126];
    end;

    p122:Add(Observers.observeAttribute(p124, "Score", function(p127) -- Line: 711
        -- upvalues: u123 (copy)
        local Info2 = u123:FindFirstChild("Info");
        local v128 = Info2 and Info2:FindFirstChild("Amount");

        if v128 then
            v128.Text = tostring(p127);
        end;

        u123.LayoutOrder = -p127;

        return nil;
    end));
end;

local function refreshCompetitiveStrokeColors() -- Line: 727
    -- upvalues: u3 (copy), Players (copy), LocalPlayer (copy), u8 (copy)
    for i, v in u3 do
        local v129 = Players:GetPlayerByUserId(i);

        if v129 and (v and v.Parent) then
            local PlayerBackground = v:FindFirstChild("PlayerBackground");

            if PlayerBackground then
                PlayerBackground = PlayerBackground:FindFirstChildOfClass("UIStroke");
            end;

            if PlayerBackground then
                local v130 = PlayerBackground:GetAttribute("DefaultStrokeColor");

                if not v130 then
                    v130 = PlayerBackground.Color;
                    PlayerBackground:SetAttribute("DefaultStrokeColor", v130);
                end;

                local v131 = v130 or PlayerBackground.Color;
                local v132 = LocalPlayer:GetAttribute("Team");
                local v133 = v129:GetAttribute("Team");
                local v134;

                if v132 and v133 then
                    v134 = v132 == v133;
                else
                    v134 = false;
                end;

                if v134 then
                    local Character = v129.Character;
                    local v135;

                    if Character then
                        v135 = Character:GetAttribute("CompetitivePlayerColor");
                    else
                        v135 = nil;
                    end;

                    if v135 then
                        u8[i] = v135;
                    else
                        v135 = u8[i];
                    end;

                    if v135 then
                        PlayerBackground.Color = v135;
                    elseif v131 then
                        PlayerBackground.Color = v131;
                    end;
                else
                    PlayerBackground.Color = v131;
                end;
            end;
        end;
    end;
end;

local function destroyCachedTemplate(p136) -- Line: 767
    -- upvalues: u3 (copy), u4 (copy)
    local v137 = u3[p136];

    if not v137 then
        return;
    end;

    local Info = v137:FindFirstChild("Info");
    local v138 = Info and u4[Info];

    if v138 then
        v138:Destroy();
        u4[Info] = nil;
    end;

    if v137.Parent then
        v137:Destroy();
    end;

    u3[p136] = nil;
end;

function u1.createTemplate(p139, p140) -- Line: 792
    -- upvalues: u3 (copy), u4 (copy), Janitor (copy), ReplicatedStorage (copy), setupDeathmatchTemplate (copy), LocalPlayer (copy), setupBombDefusalTemplate (copy), refreshCompetitiveStrokeColors (copy), setTemplateInfoRevealed (copy), shouldShowInfoForPlayer (copy)
    local UserId = p139.UserId;
    local v141 = u3[UserId];

    if v141 then
        local Info = v141:FindFirstChild("Info");
        local v142 = Info and u4[Info];

        if v142 then
            v142:Destroy();
            u4[Info] = nil;
        end;

        if v141.Parent then
            v141:Destroy();
        end;

        u3[UserId] = nil;
    end;

    local v143 = workspace:GetAttribute("Gamemode");
    local v144 = p139:GetAttribute("Team");

    if v144 ~= "Terrorists" and v144 ~= "Counter-Terrorists" then
        return nil;
    end;

    local v145 = Janitor.new();
    local u146;

    if v143 == "Deathmatch" then
        u146 = ReplicatedStorage.Assets.UI.Deathmatch.PlayerTemplate:Clone();
    else
        if v143 ~= "Bomb Defusal" and v143 ~= "Hostage Rescue" then
            v145:Destroy();

            return nil;
        end;

        local v147 = ReplicatedStorage.Assets.UI.BombDefusal:FindFirstChild(v144);

        if not v147 then
            warn((`[PlayerInfo]: Missing player template for team {v144}`));
            v145:Destroy();

            return nil;
        end;

        u146 = v147:Clone();
    end;

    if not u146 then
        v145:Destroy();

        return nil;
    end;

    local Bomb = u146:FindFirstChild("Bomb");

    if Bomb then
        Bomb.Visible = false;
    end;

    local Info = u146:FindFirstChild("Info");

    if Info then
        local v148 = Info:GetAttribute("OriginalSize");
        local v149 = v148 or Info.Size;

        if not v148 then
            Info:SetAttribute("OriginalSize", v149);
        end;

        if v143 == "Deathmatch" then
            Info.Size = v149;
            Info.Visible = true;
        else
            Info.Size = UDim2.fromScale(1, 0);
            Info.Visible = false;
        end;
    end;

    local PlayerBackground = u146:FindFirstChild("PlayerBackground");

    if PlayerBackground then
        PlayerBackground = PlayerBackground:FindFirstChild("Player");
    end;

    if PlayerBackground and PlayerBackground:IsA("ImageLabel") then
        PlayerBackground.Image = `rbxthumb://type=AvatarHeadShot&id={p139.UserId}&w=420&h=420`;
    end;

    u146.Parent = p140;
    u3[p139.UserId] = u146;
    local PlayerBackground2 = u146:FindFirstChild("PlayerBackground");

    if PlayerBackground2 then
        PlayerBackground2 = PlayerBackground2:FindFirstChildOfClass("UIStroke");
    end;

    if PlayerBackground2 then
        local v150 = PlayerBackground2:GetAttribute("DefaultStrokeColor");

        if not v150 then
            v150 = PlayerBackground2.Color;
            PlayerBackground2:SetAttribute("DefaultStrokeColor", v150);
        end;

        if not v150 then
            local _ = PlayerBackground2.Color;
        end;
    end;

    if v143 == "Deathmatch" then
        setupDeathmatchTemplate(v145, u146, p139, p140);
    else
        local Health = u146:FindFirstChild("Health");

        if Health then
            Health.Visible = LocalPlayer:GetAttribute("Team") == v144;
        end;

        setupBombDefusalTemplate(v145, u146, p139, p140);
        refreshCompetitiveStrokeColors();
        local v151 = u3[p139.UserId];

        if v151 and v151.Parent then
            setTemplateInfoRevealed(p139, v151, (shouldShowInfoForPlayer(p139)));
        end;
    end;

    v145:Add(function() -- Line: 885
        -- upvalues: u146 (ref)
        u146:Destroy();
    end);

    return v145;
end;

function u1.cleanupTemplate(p152) -- Line: 892
    -- upvalues: u3 (copy), u4 (copy), u6 (copy), u7 (copy), u8 (copy), refreshCompetitiveStrokeColors (copy)
    local UserId = p152.UserId;
    local v153 = u3[UserId];

    if v153 then
        local Info = v153:FindFirstChild("Info");
        local v154 = Info and u4[Info];

        if v154 then
            v154:Destroy();
            u4[Info] = nil;
        end;

        if v153.Parent then
            v153:Destroy();
        end;

        u3[UserId] = nil;
    end;

    u3[UserId] = nil;
    u6[UserId] = nil;
    u7[UserId] = nil;
    u8[UserId] = nil;
    refreshCompetitiveStrokeColors();
end;

function u1.refreshCompetitiveColors() -- Line: 904
    -- upvalues: refreshCompetitiveStrokeColors (copy)
    refreshCompetitiveStrokeColors();
end;

function u1.applyTemplateLifeState(p155, p156) -- Line: 908
    -- upvalues: setTemplateLifeState (copy)
    return setTemplateLifeState(p155, p156);
end;

function u1.setTeammateInfoRevealed(p157) -- Line: 912
    -- upvalues: u9 (ref), u3 (copy), Players (copy), setTemplateInfoRevealed (copy), shouldShowInfoForPlayer (copy)
    if workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
        p157 = false;
    end;

    u9 = p157;

    for i, v in u3 do
        local v158 = Players:GetPlayerByUserId(i);

        if v158 and (v and v.Parent) then
            local v159 = u3[v158.UserId];

            if v159 then
                if v159.Parent then
                    setTemplateInfoRevealed(v158, v159, (shouldShowInfoForPlayer(v158)));
                end;
            end;
        end;
    end;
end;

function u1.updateTeammateGrenades(p160) -- Line: 929
    -- upvalues: u5 (copy), Players (copy), u3 (copy), updateTemplateGrenades (copy)
    for _, v in p160 do
        local v161 = tonumber(v.userId);

        if v161 then
            u5[v161] = v.grenades or {};
            local v162 = Players:GetPlayerByUserId(v161);
            local v163 = u3[v161];

            if v162 and (v163 and v163.Parent) then
                updateTemplateGrenades(v163, v161);
            end;
        end;
    end;
end;

function u1.incrementTemplateKills(p164) -- Line: 947
    -- upvalues: GameState (copy), u6 (copy), u3 (copy), setTemplateKills (copy), Players (copy), setTemplateInfoRevealed (copy), shouldShowInfoForPlayer (copy)
    if GameState.GetState() == "Warmup" then
        return;
    end;

    u6[p164] = (u6[p164] or 0) + 1;
    local v165 = u3[p164];

    if v165 and v165.Parent then
        setTemplateKills(v165, u6[p164]);
    end;

    local v166 = Players:GetPlayerByUserId(p164);
    local v167 = v166 and u3[v166.UserId];

    if v167 then
        if not v167.Parent then
            return;
        end;

        setTemplateInfoRevealed(v166, v167, (shouldShowInfoForPlayer(v166)));
    end;
end;

function u1.updateRoundDamageMatrix(p168) -- Line: 965
    -- upvalues: Players (copy), u7 (copy), u3 (copy), updateDamageFromMatrix (copy), setTemplateInfoRevealed (copy), shouldShowInfoForPlayer (copy)
    local v169 = p168.outgoing or {};
    local v170 = p168.incoming or {};

    for _, v in Players:GetPlayers() do
        local v171 = tostring(v.UserId);
        local v172 = v169[v171] or nil;
        local v173 = v170[v171] or nil;
        local v174;

        if v172 == nil then
            v174 = false;
        else
            v174 = #v172 > 0;
        end;

        local v175;

        if v173 == nil then
            v175 = false;
        else
            v175 = #v173 > 0;
        end;

        local v176 = u7[v.UserId] == true;
        local v177 = v174 or v175;
        u7[v.UserId] = v177;
        updateDamageFromMatrix(u3[v.UserId], v172, v173);

        if v176 ~= v177 then
            local v178 = u3[v.UserId];

            if v178 then
                if v178.Parent then
                    setTemplateInfoRevealed(v, v178, (shouldShowInfoForPlayer(v)));
                end;
            end;
        end;
    end;
end;

function u1.getTemplateByUserId(p179) -- Line: 990
    -- upvalues: u3 (copy)
    return u3[p179];
end;

Remotes.UI.TeammateGrenades.Listen(u1.updateTeammateGrenades);
Remotes.UI.RoundDamageMatrix.Listen(u1.updateRoundDamageMatrix);
GameState.ListenToState(function(p180, p181) -- Line: 997
    -- upvalues: u3 (copy), u6 (copy), u7 (copy), setTemplateKills (copy), Players (copy), setTemplateInfoRevealed (copy), shouldShowInfoForPlayer (copy)
    if p180 == "Buy Period" and p181 ~= "Buy Period" then
        for i, v in u3 do
            u6[i] = nil;
            u7[i] = nil;

            if v and v.Parent then
                setTemplateKills(v, 0);
            end;
        end;
    end;

    for i, v in u3 do
        local v182 = Players:GetPlayerByUserId(i);

        if v182 and (v and v.Parent) then
            local v183 = u3[v182.UserId];

            if v183 then
                if v183.Parent then
                    setTemplateInfoRevealed(v182, v183, (shouldShowInfoForPlayer(v182)));
                end;
            end;
        end;
    end;
end);
Players.PlayerRemoving:Connect(function(p184) -- Line: 1017
    -- upvalues: u1 (copy)
    u1.cleanupTemplate(p184);
end);

return u1;