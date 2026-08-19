-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local EquipInventorySlot = require(ReplicatedStorage.Components.Common.UserInput.EquipInventorySlot);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local GetResolvedSkinInformation = require(ReplicatedStorage.Components.Common.GetResolvedSkinInformation);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local u2 = nil;
local u3 = 0;
local u4 = nil;
local u5 = {};
local u6 = nil;
local u7 = table.find(GetUserPlatform(), "Console") and #GetUserPlatform() <= 1;
local u8 = { {
        type = "Primary",
        space = 1
    }, {
        type = "Secondary",
        space = 1
    }, {
        type = "Melee",
        space = 2
    }, {
        type = "Grenade",
        space = 4
    }, {
        type = "C4",
        space = 1
    } };
local u9 = utf8.char(9733) .. " ";
local u10 = Color3.new(1, 1, 1);
local u11 = {};
local u12 = nil;
local u13 = {};
local u14 = nil;

local function getWeaponFrames() -- Line: 115
    -- upvalues: u14 (ref)
    return u14 and { u14.Primary, u14.Secondary, u14.Melee } or nil;
end;

local function isZeusWeapon(p15) -- Line: 122
    local v16;

    if p15 == nil then
        v16 = false;
    else
        v16 = p15.Name == "Zeus x27";
    end;

    return v16;
end;

local function shouldDisplaySkinSuffix(p17) -- Line: 126
    local v18;

    if p17 == "Vanilla" then
        v18 = false;
    else
        v18 = p17 ~= "Stock";
    end;

    return v18;
end;

local function getInventoryItemDisplayName(p19, p20) -- Line: 130
    -- upvalues: u9 (copy), GetSkinDisplayName (copy), LocalPlayer (copy)
    local v21;

    if p20 == "Melee" then
        local v22;

        if p19 == nil then
            v22 = false;
        else
            v22 = p19.Name == "Zeus x27";
        end;

        v21 = v22 and "" or (u9 or "");
    else
        v21 = "";
    end;

    local v23 = v21 .. p19.Name;

    if p19.Skin then
        local v24 = GetSkinDisplayName(p19.Skin);
        local v25;

        if v24 == "Vanilla" then
            v25 = false;
        else
            v25 = v24 ~= "Stock";
        end;

        v23 = v23 .. (v25 and " | " .. v24 or "");
    end;

    local v26 = (p19.Name == "T Knife" or p19.Name == "CT Knife") and "Knife" or v23;

    if p19.NameTag then
        v26 = `"{p19.NameTag}"`;
    end;

    local OriginalOwner = p19.OriginalOwner;

    if OriginalOwner and (OriginalOwner ~= "" and OriginalOwner ~= LocalPlayer.Name) then
        v26 = `"{OriginalOwner}'s {v26}"`;
    end;

    return v26;
end;

local function getImageLabelFromContainer(p27) -- Line: 157
    if not p27 then
        return nil;
    end;

    if p27:IsA("ImageLabel") then
        return p27;
    end;

    return p27:FindFirstChildWhichIsA("ImageLabel", true);
end;

local function getTextLabelFromContainer(p28) -- Line: 169
    if not p28 then
        return nil;
    end;

    if p28:IsA("TextLabel") then
        return p28;
    end;

    return p28:FindFirstChildWhichIsA("TextLabel", true);
end;

local function getMeleeImageLabels(p29) -- Line: 181
    local Weapon = p29:FindFirstChild("Weapon");
    local v30;

    if Weapon then
        v30 = Weapon:FindFirstChild("Melee") or nil;
    else
        v30 = nil;
    end;

    if v30 then
        if not v30:IsA("ImageLabel") then
            v30 = v30:FindFirstChildWhichIsA("ImageLabel", true);
        end;
    else
        v30 = nil;
    end;

    local Zeus = p29:FindFirstChild("Zeus");

    if not Zeus then
        if Weapon then
            Zeus = Weapon:FindFirstChild("Zeus") or nil;
        else
            Zeus = nil;
        end;
    end;

    if Zeus then
        if not Zeus:IsA("ImageLabel") then
            Zeus = Zeus:FindFirstChildWhichIsA("ImageLabel", true);
        end;
    else
        Zeus = nil;
    end;

    if not v30 and (Weapon and Weapon:IsA("Frame")) then
        v30 = Weapon:FindFirstChildOfClass("ImageLabel");
    end;

    return v30, Zeus;
end;

local function getMeleeWeaponNameLabels(p31) -- Line: 196
    local Weapon = p31:FindFirstChild("Weapon");
    local v32;

    if Weapon then
        v32 = Weapon:FindFirstChild("WeaponName") or nil;
    else
        v32 = nil;
    end;

    if v32 then
        if not v32:IsA("TextLabel") then
            v32 = v32:FindFirstChildWhichIsA("TextLabel", true);
        end;
    else
        v32 = nil;
    end;

    local v33 = p31:FindFirstChild("Zeus") or (Weapon and Weapon:FindFirstChild("Zeus") or nil);

    if not v33 then
        return v32, nil;
    end;

    if v33:IsA("TextLabel") then
        return v32, v33;
    end;

    return v32, v33:FindFirstChildWhichIsA("TextLabel", true);
end;

local function getFrameWeaponImageLabel(p34, p35) -- Line: 207
    -- upvalues: getMeleeImageLabels (copy)
    if not p34 then
        return nil;
    end;

    if p34.Name ~= "Melee" then
        return p34.Weapon:FindFirstChildOfClass("ImageLabel");
    end;

    local v36, v37 = getMeleeImageLabels(p34);
    local v38;

    if p35 == nil then
        v38 = false;
    else
        v38 = p35.Name == "Zeus x27";
    end;

    if v38 then
        v36 = v37 or v36;
    end;

    return v36;
end;

local function getFrameWeaponNameLabel(p39, p40) -- Line: 223
    -- upvalues: getMeleeWeaponNameLabels (copy)
    if not p39 then
        return nil;
    end;

    if p39.Name ~= "Melee" then
        return p39.Weapon:FindFirstChild("WeaponName");
    end;

    local v41, v42 = getMeleeWeaponNameLabels(p39);
    local v43;

    if p40 == nil then
        v43 = false;
    else
        v43 = p40.Name == "Zeus x27";
    end;

    if v43 then
        v41 = v42 or v41;
    end;

    return v41;
end;

local function clearFrameWeaponNameLabels(p44) -- Line: 239
    -- upvalues: getMeleeWeaponNameLabels (copy)
    if not p44 then
        return;
    end;

    if p44.Name ~= "Melee" then
        local WeaponName = p44.Weapon:FindFirstChild("WeaponName");

        if WeaponName then
            WeaponName.Visible = false;
            WeaponName.Text = "";
        end;

        return;
    end;

    local v45, v46 = getMeleeWeaponNameLabels(p44);

    if v45 then
        v45.Visible = false;
        v45.Text = "";
    end;

    if v46 then
        v46.Visible = false;
        v46.Text = "";
    end;
end;

local function getVisibleWeaponImageLabel(p47) -- Line: 264
    -- upvalues: getMeleeImageLabels (copy)
    if not p47 then
        return nil;
    end;

    if p47.Name == "Melee" then
        local v48, v49 = getMeleeImageLabels(p47);

        if v49 and v49.Visible then
            return v49;
        end;

        if v48 and v48.Visible then
            return v48;
        end;
    end;

    return p47.Weapon:FindFirstChildOfClass("ImageLabel");
end;

local function updateMeleeInventoryFrame(p50, p51, p52) -- Line: 282
    -- upvalues: getMeleeImageLabels (copy), getMeleeWeaponNameLabels (copy), u12 (ref), getInventoryItemDisplayName (copy)
    local v53, v54 = getMeleeImageLabels(p50);
    local v55, v56 = getMeleeWeaponNameLabels(p50);
    p50:SetAttribute("Slot", 3);
    p50.Keybind.Text = "3";
    local v57 = {};
    local v58 = nil;
    local v59 = nil;

    for _, v in ipairs(p51._items) do
        local v60 = `${v.Name}<{v.Identifier}>`;
        table.insert(v57, v60);
        local v61;

        if v == nil then
            v61 = false;
        else
            v61 = v.Name == "Zeus x27";
        end;

        if v61 then
            v59 = v;
        else
            v58 = v;
        end;
    end;

    if v53 then
        v53.Visible = v58 ~= nil;
    end;

    if v58 and v53 then
        v53.Image = v58.Properties.Icon;
        v53.ImageColor3 = u12(v58);
    end;

    if v54 then
        v54.Visible = v59 ~= nil;
    end;

    if v59 and v54 then
        v54.Image = v59.Properties.Icon;
        v54.ImageColor3 = u12(v59);
    end;

    local v62;

    if p52 and p52.Properties.Slot == "Melee" then
        v62 = p52;
    else
        v62 = v58 or v59;
    end;

    if v62 then
        local v63;

        if p50 then
            if p50.Name == "Melee" then
                local v64;
                v63, v64 = getMeleeWeaponNameLabels(p50);
                local v65;

                if v62 == nil then
                    v65 = false;
                else
                    v65 = v62.Name == "Zeus x27";
                end;

                if v65 then
                    v63 = v64 or v63;
                end;
            else
                v63 = p50.Weapon:FindFirstChild("WeaponName");
            end;
        else
            v63 = nil;
        end;

        local v66;

        if p52 == nil then
            v66 = false;
        else
            v66 = p52.Properties.Slot == "Melee";
        end;

        if v55 and v55 ~= v63 then
            v55.Visible = false;
        end;

        if v56 and v56 ~= v63 then
            v56.Visible = false;
        end;

        if v63 then
            v63.TextColor3 = u12(v62);
            v63.Text = v62.Name:find("Zeus") and "Taser" or getInventoryItemDisplayName(v62, "Melee");
            v63.Visible = v66;
        end;
    else
        p50.Equip.Visible = false;

        if p50 then
            if p50.Name == "Melee" then
                local v67, v68 = getMeleeWeaponNameLabels(p50);

                if v67 then
                    v67.Visible = false;
                    v67.Text = "";
                end;

                if v68 then
                    v68.Visible = false;
                    v68.Text = "";
                end;
            else
                local WeaponName = p50.Weapon:FindFirstChild("WeaponName");

                if WeaponName then
                    WeaponName.Visible = false;
                    WeaponName.Text = "";
                end;
            end;
        end;

        if v53 then
            v53.Visible = false;
        end;

        if v54 then
            v54.Visible = false;
        end;
    end;
end;

local function getObjectiveKitAttributeName() -- Line: 353
    local v69 = workspace:GetAttribute("Gamemode");

    return v69 == "Bomb Defusal" and "HasDefuseKit" or (v69 == "Hostage Rescue" and "HasRescueKit" or nil);
end;

local function shouldShowObjectiveKitIcon(p70) -- Line: 363
    if not p70 then
        return false;
    end;

    if p70:GetAttribute("Team") ~= "Counter-Terrorists" then
        return false;
    end;

    local v71 = workspace:GetAttribute("Gamemode");
    local v72 = v71 == "Bomb Defusal" and "HasDefuseKit" or (v71 == "Hostage Rescue" and "HasRescueKit" or nil);

    if v72 then
        return p70:GetAttribute(v72) == true;
    end;

    return false;
end;

local function updateObjectiveKitIcon(p73) -- Line: 381
    -- upvalues: u14 (ref)
    local DefuseKit = u14.Grenade.DefuseKit;
    local v74;

    if p73 and p73:GetAttribute("Team") == "Counter-Terrorists" then
        local v75 = workspace:GetAttribute("Gamemode");
        local v76 = v75 == "Bomb Defusal" and "HasDefuseKit" or (v75 == "Hostage Rescue" and "HasRescueKit" or nil);

        if v76 then
            v74 = p73:GetAttribute(v76) == true;
        else
            v74 = false;
        end;
    else
        v74 = false;
    end;

    DefuseKit.Visible = v74;
end;

local function resetFadeTimer() -- Line: 385
    -- upvalues: u6 (ref), u5 (copy), u14 (ref)
    if u6 then
        task.cancel(u6);
        u6 = nil;
    end;

    for _, v in u5 do
        v:Cancel();
    end;

    table.clear(u5);
    local v77 = u14 and { u14.Primary, u14.Secondary, u14.Melee } or nil;

    if not v77 then
        return;
    end;

    for _, v in ipairs(v77) do
        if v:IsA("Frame") then
            local Equip = v:FindFirstChild("Equip");

            if Equip and Equip:IsA("Frame") then
                Equip.BackgroundTransparency = 0.225;
            end;

            for _, v2 in v:QueryDescendants("ImageLabel, TextLabel") do
                if v2:IsA("ImageLabel") then
                    v2.ImageTransparency = 0.225;
                else
                    v2.TextTransparency = 0.225;
                end;
            end;
        end;
    end;
end;

local function startFade() -- Line: 421
    -- upvalues: DataController (copy), LocalPlayer (copy), resetFadeTimer (copy), u14 (ref), TweenService (copy), u5 (copy), u6 (ref)
    if DataController.Get(LocalPlayer, "Settings.Game.Item.Always Show Inventory") ~= false then
        resetFadeTimer();

        return;
    end;

    resetFadeTimer();
    local v78 = u14 and { u14.Primary, u14.Secondary, u14.Melee } or nil;

    if not v78 then
        return;
    end;

    for _, v in ipairs(v78) do
        if v:IsA("Frame") then
            local Equip = v:FindFirstChild("Equip");

            if Equip and Equip:IsA("Frame") then
                local v79 = TweenService:Create(Equip, TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                    BackgroundTransparency = 1
                });
                u5[v.Name .. "_Equip"] = v79;
                v79:Play();
            end;

            for _, v2 in v:QueryDescendants("ImageLabel", "TextLabel") do
                local v80 = v2:IsA("ImageLabel") and {
                    ImageTransparency = 1
                } or {
                    TextTransparency = 1
                };
                local v81 = TweenService:Create(v2, TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.In), v80);
                u5[v.Name .. "_" .. v2:GetFullName()] = v81;
                v81:Play();
            end;
        end;
    end;

    u6 = task.delay(5, function() -- Line: 469
        -- upvalues: u6 (ref)
        u6 = nil;
    end);
end;

u12 = function(p82) -- Line: 475
    -- upvalues: GetPreferenceColor (copy), DataController (copy), LocalPlayer (copy), GetResolvedSkinInformation (copy), Rarities (copy)
    if not p82 then
        return GetPreferenceColor();
    end;

    if DataController.Get(LocalPlayer, "Settings.Game.HUD.Glow Weapon with Rarity Color") ~= true then
        return GetPreferenceColor();
    end;

    local v83 = GetResolvedSkinInformation(p82.Name, p82.Skin);

    if not (v83 and v83.rarity) then
        return GetPreferenceColor();
    end;

    local v84 = Rarities[v83.rarity];

    if v84 then
        return v84.Color;
    end;

    return GetPreferenceColor();
end;

local function playPickupFlash(p85, p86) -- Line: 503
    -- upvalues: TweenService (copy), u10 (copy)
    local v87 = p85:GetAttribute("DefaultSize");

    if not v87 then
        return;
    end;

    local v88 = UDim2.new(v87.X.Scale * 1.1, v87.X.Offset * 1.1, v87.Y.Scale * 1.1, v87.Y.Offset * 1.1);

    for _ = 1, 6 do
        local v89 = TweenService:Create(p85, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            ImageColor3 = u10,
            Size = v88
        });
        v89:Play();
        v89.Completed:Wait();
        local v90 = TweenService:Create(p85, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
            ImageColor3 = p86,
            Size = v87
        });
        v90:Play();
        v90.Completed:Wait();
    end;
end;

local function startPickupFlash(u91, u92, u93) -- Line: 543
    -- upvalues: u11 (copy), playPickupFlash (copy)
    if u11[u91] then
        task.cancel(u11[u91]);
        u11[u91] = nil;
    end;

    local v94 = u92:GetAttribute("DefaultSize");

    if v94 then
        u92.ImageColor3 = u93;
        u92.Size = v94;
    end;

    u11[u91] = task.spawn(function() -- Line: 555
        -- upvalues: playPickupFlash (ref), u92 (copy), u93 (copy), u11 (ref), u91 (copy)
        playPickupFlash(u92, u93);
        u11[u91] = nil;
    end);
end;

local function buildInventorySnapshot(p95) -- Line: 561
    local v96 = {};

    for _, v in p95 do
        local _strict_type = v._settings._strict_type;
        v96[_strict_type] = {};

        for _, v2 in v._items do
            local Identifier = v2.Identifier;

            if Identifier then
                v96[_strict_type][Identifier] = true;
            end;
        end;
    end;

    return v96;
end;

local function detectAndFlashNewItems(p97) -- Line: 576
    -- upvalues: buildInventorySnapshot (copy), u13 (ref), u14 (ref), startPickupFlash (copy), GetPreferenceColor (copy), getMeleeImageLabels (copy), u12 (ref)
    local v98 = buildInventorySnapshot(p97);

    for _, v in p97 do
        local _strict_type = v._settings._strict_type;
        local v99 = u13[_strict_type] or {};

        for i, v2 in v._items do
            local Identifier = v2.Identifier;

            if Identifier and not v99[Identifier] then
                if _strict_type == "Grenade" then
                    local v100 = u14.Grenade.Grenades:FindFirstChild((tostring(i)));

                    if v100 then
                        local Grenade = v100:FindFirstChild("Grenade");

                        if Grenade and Grenade.Visible then
                            startPickupFlash("Grenade_" .. i, Grenade, GetPreferenceColor());
                        end;
                    end;
                elseif _strict_type == "C4" then
                    local Bomb = u14.Grenade:FindFirstChild("Bomb");

                    if Bomb and Bomb.Visible then
                        startPickupFlash("C4", Bomb, GetPreferenceColor());
                    end;
                else
                    local v101 = u14:FindFirstChild(_strict_type);

                    if v101 and v101:FindFirstChild("Weapon") then
                        local v102;

                        if _strict_type == "Melee" then
                            if v101 then
                                if v101.Name == "Melee" then
                                    local v103;
                                    v102, v103 = getMeleeImageLabels(v101);
                                    local v104;

                                    if v2 == nil then
                                        v104 = false;
                                    else
                                        v104 = v2.Name == "Zeus x27";
                                    end;

                                    if v104 then
                                        v102 = v103 or v102;
                                    end;
                                else
                                    v102 = v101.Weapon:FindFirstChildOfClass("ImageLabel");
                                end;
                            else
                                v102 = nil;
                            end;
                        elseif v101 then
                            if v101.Name == "Melee" then
                                v102, v102 = getMeleeImageLabels(v101);

                                if not (v102 and v102.Visible) then
                                    if not (v102 and v102.Visible) then
                                        v102 = v101.Weapon:FindFirstChildOfClass("ImageLabel");
                                    end;
                                end;
                            else
                                v102 = v101.Weapon:FindFirstChildOfClass("ImageLabel");
                            end;
                        else
                            v102 = nil;
                        end;

                        if v102 and v102.Visible then
                            startPickupFlash(_strict_type .. "_" .. v2.Name, v102, u12(v2));
                        end;
                    end;
                end;
            end;
        end;
    end;

    u13 = v98;
end;

local function updateCurrentEquipped(p105, p106) -- Line: 626
    -- upvalues: u2 (ref), u3 (ref), TweenService (copy), u4 (ref), getMeleeImageLabels (copy), getMeleeWeaponNameLabels (copy), u14 (ref), GetPreferenceColor (copy), u12 (ref), getInventoryItemDisplayName (copy), u7 (copy)
    if u2 then
        if u2.Name == "Grenade" then
            local v107 = u2:WaitForChild("Grenades"):FindFirstChild((tostring(u3)));

            if v107 then
                local Grenade = v107:FindFirstChild("Grenade");
                TweenService:Create(Grenade, TweenInfo.new(0.1), {
                    Size = Grenade:GetAttribute("DefaultSize")
                }):Play();
            end;
        else
            local v108 = u4;

            if not v108 then
                local v109 = u2;

                if v109 then
                    if v109.Name == "Melee" then
                        v108, v108 = getMeleeImageLabels(v109);

                        if not (v108 and v108.Visible) then
                            if not (v108 and v108.Visible) then
                                v108 = v109.Weapon:FindFirstChildOfClass("ImageLabel");
                            end;
                        end;
                    else
                        v108 = v109.Weapon:FindFirstChildOfClass("ImageLabel");
                    end;
                else
                    v108 = nil;
                end;
            end;

            local v110 = u2;

            if v110 then
                if v110.Name == "Melee" then
                    local v111, v112 = getMeleeWeaponNameLabels(v110);

                    if v111 then
                        v111.Visible = false;
                        v111.Text = "";
                    end;

                    if v112 then
                        v112.Visible = false;
                        v112.Text = "";
                    end;
                else
                    local WeaponName = v110.Weapon:FindFirstChild("WeaponName");

                    if WeaponName then
                        WeaponName.Visible = false;
                        WeaponName.Text = "";
                    end;
                end;
            end;

            u2.Equip.Visible = false;

            if v108 then
                TweenService:Create(v108, TweenInfo.new(0.1), {
                    Size = v108:GetAttribute("DefaultSize")
                }):Play();
            end;
        end;
    end;

    local v113 = u14:FindFirstChild((tostring(p106.Properties.Slot)));
    u2 = v113;
    u4 = nil;

    if v113 then
        if v113.Name == "Grenade" then
            local v114 = v113.Grenades:FindFirstChild((tostring(p105)));
            u3 = p105;

            if v114 then
                local Grenade = v114:FindFirstChild("Grenade");
                Grenade.ImageColor3 = GetPreferenceColor();
                TweenService:Create(Grenade, TweenInfo.new(0.1), {
                    Size = Grenade:GetAttribute("DefaultSize") + UDim2.fromScale(0.1, 0.1)
                }):Play();
            end;
        else
            local v115;

            if v113 then
                if v113.Name == "Melee" then
                    local v116;
                    v115, v116 = getMeleeImageLabels(v113);
                    local v117;

                    if p106 == nil then
                        v117 = false;
                    else
                        v117 = p106.Name == "Zeus x27";
                    end;

                    if v117 then
                        v115 = v116 or v115;
                    end;
                else
                    v115 = v113.Weapon:FindFirstChildOfClass("ImageLabel");
                end;
            else
                v115 = nil;
            end;

            local v118;

            if v113 then
                if v113.Name == "Melee" then
                    local v119;
                    v118, v119 = getMeleeWeaponNameLabels(v113);
                    local v120;

                    if p106 == nil then
                        v120 = false;
                    else
                        v120 = p106.Name == "Zeus x27";
                    end;

                    if v120 then
                        v118 = v119 or v118;
                    end;
                else
                    v118 = v113.Weapon:FindFirstChild("WeaponName");
                end;
            else
                v118 = nil;
            end;

            u4 = v115;

            if v115 then
                v115.ImageColor3 = u12(p106);
            end;

            if v113 then
                if v113.Name == "Melee" then
                    local v121, v122 = getMeleeWeaponNameLabels(v113);

                    if v121 then
                        v121.Visible = false;
                        v121.Text = "";
                    end;

                    if v122 then
                        v122.Visible = false;
                        v122.Text = "";
                    end;
                else
                    local WeaponName = v113.Weapon:FindFirstChild("WeaponName");

                    if WeaponName then
                        WeaponName.Visible = false;
                        WeaponName.Text = "";
                    end;
                end;
            end;

            if v118 then
                v118.TextColor3 = u12(p106);
                v118.Text = p106.Name:find("Zeus") and "Taser" or getInventoryItemDisplayName(p106, v113.Name);
                v118.Visible = true;
            end;

            v113.Equip.Visible = true;

            if v115 then
                TweenService:Create(v115, TweenInfo.new(0.1), {
                    Size = v115:GetAttribute("DefaultSize") + UDim2.fromScale(0.1, 0.1)
                }):Play();
            end;
        end;
    end;

    if v113 then
        v113 = v113:FindFirstChild("CycleWeaponsIcons");
    end;

    if not u7 then
        return;
    end;

    if not v113 then
        return;
    end;

    v113.Visible = u7;
end;

local function convertInventoryDataToServerLoadout(p123) -- Line: 710
    -- upvalues: u8 (copy)
    local v124 = {};

    if not p123 or #p123 == 0 then
        return nil;
    end;

    for i = 1, 5 do
        local v125 = p123[i];

        if v125 then
            v124[i] = {
                _items = {},
                _settings = {
                    _strict_slot_space = v125._settings._strict_slot_space,
                    _strict_type = v125._settings._strict_type
                }
            };

            for _, v in ipairs(v125._items) do
                table.insert(v124[i]._items, v);
            end;
        else
            v124[i] = {
                _items = {},
                _settings = {
                    _strict_slot_space = u8[i].space,
                    _strict_type = u8[i].type
                }
            };
        end;
    end;

    return v124;
end;

local function updateInventoryFrame(p126, p127) -- Line: 752
    -- upvalues: GetPreferenceColor (copy), u14 (ref), LocalPlayer (copy), InventoryController (copy), updateMeleeInventoryFrame (copy), GetSkinDisplayName (copy), u12 (ref), getInventoryItemDisplayName (copy)
    local v128 = GetPreferenceColor();
    u14.Grenade.DefuseKit.ImageColor3 = v128;
    u14.Grenade.Bomb.ImageColor3 = v128;
    local v129 = p127 or LocalPlayer;
    local DefuseKit = u14.Grenade.DefuseKit;
    local v130;

    if v129 and v129:GetAttribute("Team") == "Counter-Terrorists" then
        local v131 = workspace:GetAttribute("Gamemode");
        local v132 = v131 == "Bomb Defusal" and "HasDefuseKit" or (v131 == "Hostage Rescue" and "HasRescueKit" or nil);

        if v132 then
            v130 = v129:GetAttribute(v132) == true;
        else
            v130 = false;
        end;
    else
        v130 = false;
    end;

    DefuseKit.Visible = v130;

    if workspace:GetAttribute("Gamemode") == "Hostage Rescue" then
        u14.Grenade.Bomb.Visible = false;
    end;

    local v133 = InventoryController.getCurrentEquipped();

    for _, v in ipairs(p126) do
        if v._settings._strict_type == "Melee" then
            updateMeleeInventoryFrame(u14.Melee, v, v133);
        elseif v._settings._strict_slot_space == 1 then
            local v134 = u14:FindFirstChild(v._settings._strict_type);

            if v134 then
                local v135 = v._items[1];

                if v135 then
                    local Weapon = v134:FindFirstChild("Weapon");
                    v134:SetAttribute("Slot", v135.Slot);
                    v134.Keybind.Text = v135.Slot;

                    if Weapon then
                        local v136 = v134.Weapon:FindFirstChild(v135.Properties.Class);
                        local v137 = (v._settings._strict_type == "Melee" and "â˜… " or "") .. v135.Name;

                        if v135.Skin then
                            local v138 = GetSkinDisplayName(v135.Skin);
                            local v139;

                            if v138 == "Vanilla" then
                                v139 = false;
                            else
                                v139 = v138 ~= "Stock";
                            end;

                            v137 = v137 .. (v139 and " | " .. v138 or "");
                        end;

                        local v140 = (v135.Name == "T Knife" or v135.Name == "CT Knife") and "Knife" or v137;

                        if v135.NameTag then
                            v140 = `"{v135.NameTag}"`;
                        end;

                        local OriginalOwner = v135.OriginalOwner;

                        if OriginalOwner and (OriginalOwner ~= "" and OriginalOwner ~= LocalPlayer.Name) then
                            ("\"%*\'s %*\""):format(OriginalOwner, v140);
                        end;

                        v134.Weapon.WeaponName.TextColor3 = u12(v135);
                        v134.Weapon.WeaponName.Text = v135.Name:find("Zeus") and "Taser" or getInventoryItemDisplayName(v135, v._settings._strict_type);
                        local v141;

                        if v133 then
                            v141 = v133.Properties.Slot == v._settings._strict_type;
                        else
                            v141 = v133;
                        end;

                        v134.Weapon.WeaponName.Visible = v141;

                        if v136 then
                            for _, child in v134.Weapon:GetChildren() do
                                if child:IsA("ImageLabel") then
                                    child.Visible = child == v136;
                                end;
                            end;

                            v136.Image = v135.Properties.Icon;
                            v136.ImageColor3 = u12(v135);
                        end;
                    end;
                else
                    v134.Equip.Visible = false;
                    v134.Weapon.WeaponName.Text = "";
                    v134.Weapon.WeaponName.Visible = false;

                    for _, child in v134.Weapon:GetChildren() do
                        if child:IsA("ImageLabel") then
                            child.Visible = false;
                        end;
                    end;
                end;
            elseif v._settings._strict_type == "C4" then
                u14.Grenade.Bomb.Visible = v._items[1];
            end;
        elseif v._settings._strict_type == "Grenade" then
            for i = 1, 4 do
                local v142 = u14.Grenade.Grenades:FindFirstChild((tostring(i)));

                if v142 then
                    local v143 = v._items[i];

                    if v143 then
                        v142.Grenade.ImageColor3 = v128;
                        v142.Grenade.Visible = true;
                        v142.Dot.Visible = false;

                        if v143.Properties and v143.Properties.Icon then
                            v142.Grenade.Image = v143.Properties.Icon;
                        end;
                    else
                        v142.Grenade.Visible = false;
                        v142.Dot.Visible = true;
                    end;
                end;
            end;
        end;
    end;

    for _, child in u14:GetChildren() do
        if child:IsA("Frame") then
            local v144 = child.Name == "Grenade";

            for _, v in p126 do
                if #v._items > 0 and v._settings._strict_type == child.Name then
                    v144 = true;
                    break;
                end;
            end;

            child.Visible = v144;
        end;
    end;
end;

function v1.Initialize(p145, p146) -- Line: 886
    -- upvalues: u14 (ref), EquipInventorySlot (copy), InventoryController (copy)
    u14 = p146;

    if u14.Active then
        u14.Active = false;
    end;

    for _, v in u14:QueryDescendants("GuiObject") do
        v.Active = false;
    end;

    for _, v in u14:QueryDescendants("ImageLabel, ImageButton") do
        if v.Parent.Name == "Weapon" or (v.Name == "Grenade" or v.Name == "Bomb") then
            v:SetAttribute("DefaultSize", v.Size);
        end;
    end;

    for _, child in u14:GetChildren() do
        if child:IsA("Frame") and child:FindFirstChild("Button") then
            child.Button.MouseButton1Click:Connect(function() -- Line: 908
                -- upvalues: child (copy), EquipInventorySlot (ref)
                local v147 = child:GetAttribute("Slot");

                if v147 then
                    EquipInventorySlot(v147);
                end;
            end);
        end;
    end;

    for _, child in u14.Grenade.Grenades:GetChildren() do
        if child:IsA("Frame") then
            child:FindFirstChild("Button").MouseButton1Click:Connect(function() -- Line: 920
                -- upvalues: InventoryController (ref), child (copy)
                InventoryController.equip(4, (tonumber(child.Name)));
            end);
        end;
    end;

    local Bomb = u14.Grenade.Bomb;

    if Bomb:IsA("ImageButton") then
        Bomb.MouseButton1Click:Connect(function() -- Line: 928
            -- upvalues: Bomb (copy), InventoryController (ref)
            if not Bomb.Visible then
                return;
            end;

            InventoryController.equip(5, 1);
        end);
    end;
end;

function v1.Start() -- Line: 939
    -- upvalues: InventoryController (copy), LocalPlayer (copy), updateInventoryFrame (copy), detectAndFlashNewItems (copy), updateCurrentEquipped (copy), DataController (copy), resetFadeTimer (copy), startFade (copy), u14 (ref), u12 (ref), getMeleeImageLabels (copy), getMeleeWeaponNameLabels (copy), SpectateController (copy), Remotes (copy), convertInventoryDataToServerLoadout (copy), Players (copy)
    InventoryController.OnInventoryChanged:Connect(function(p148) -- Line: 941
        -- upvalues: LocalPlayer (ref), updateInventoryFrame (ref), detectAndFlashNewItems (ref)
        if not LocalPlayer:GetAttribute("IsSpectating") then
            updateInventoryFrame(p148);
            detectAndFlashNewItems(p148);
        end;
    end);
    InventoryController.OnInventoryItemEquipped:Connect(function(p149, p150) -- Line: 950
        -- upvalues: updateCurrentEquipped (ref), DataController (ref), LocalPlayer (ref), resetFadeTimer (ref), startFade (ref)
        updateCurrentEquipped(p149, p150);

        if DataController.Get(LocalPlayer, "Settings.Game.Item.Always Show Inventory") == false then
            local Slot = p150.Properties.Slot;

            if Slot == "Primary" or (Slot == "Secondary" or (Slot == "Melee" or Slot == "Grenade")) then
                resetFadeTimer();
                startFade();
            end;
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Glow Weapon with Rarity Color", function() -- Line: 966
        -- upvalues: InventoryController (ref), updateInventoryFrame (ref), u14 (ref), u12 (ref), getMeleeImageLabels (ref), getMeleeWeaponNameLabels (ref)
        local v151 = InventoryController.getCurrentInventory();

        if v151 then
            updateInventoryFrame(v151);
        end;

        local v152 = InventoryController.getCurrentEquipped();

        if v152 then
            local v153 = u14:FindFirstChild((tostring(v152.Properties.Slot)));

            if v153 and v153.Name ~= "Grenade" then
                local v154 = u12(v152);
                local v155;

                if v153 then
                    if v153.Name == "Melee" then
                        local v156;
                        v155, v156 = getMeleeImageLabels(v153);
                        local v157;

                        if v152 == nil then
                            v157 = false;
                        else
                            v157 = v152.Name == "Zeus x27";
                        end;

                        if v157 then
                            v155 = v156 or v155;
                        end;
                    else
                        v155 = v153.Weapon:FindFirstChildOfClass("ImageLabel");
                    end;
                else
                    v155 = nil;
                end;

                if v155 then
                    v155.ImageColor3 = v154;
                end;

                local v158;

                if v153 then
                    if v153.Name == "Melee" then
                        local v159;
                        v158, v159 = getMeleeWeaponNameLabels(v153);
                        local v160;

                        if v152 == nil then
                            v160 = false;
                        else
                            v160 = v152.Name == "Zeus x27";
                        end;

                        if v160 then
                            v158 = v159 or v158;
                        end;
                    else
                        v158 = v153.Weapon:FindFirstChild("WeaponName");
                    end;
                else
                    v158 = nil;
                end;

                if v158 then
                    v158.TextColor3 = v154;
                end;
            end;
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", function() -- Line: 991
        -- upvalues: LocalPlayer (ref), SpectateController (ref), Remotes (ref), InventoryController (ref), updateInventoryFrame (ref)
        if LocalPlayer:GetAttribute("IsSpectating") == true then
            local v161 = SpectateController.GetPlayer();

            if v161 then
                Remotes.Inventory.RequestSpectatedPlayerInventory.Send(v161);
            end;
        else
            local v162 = InventoryController.getCurrentInventory();

            if v162 then
                updateInventoryFrame(v162);
            end;
        end;
    end);

    local function updateLocalObjectiveKitIcon() -- Line: 1007
        -- upvalues: LocalPlayer (ref), u14 (ref)
        if not LocalPlayer:GetAttribute("IsSpectating") then
            local v163 = LocalPlayer;
            local DefuseKit = u14.Grenade.DefuseKit;
            local v164;

            if v163 and v163:GetAttribute("Team") == "Counter-Terrorists" then
                local v165 = workspace:GetAttribute("Gamemode");
                local v166 = v165 == "Bomb Defusal" and "HasDefuseKit" or (v165 == "Hostage Rescue" and "HasRescueKit" or nil);

                if v166 then
                    v164 = v163:GetAttribute(v166) == true;
                else
                    v164 = false;
                end;
            else
                v164 = false;
            end;

            DefuseKit.Visible = v164;
        end;
    end;

    LocalPlayer:GetAttributeChangedSignal("HasDefuseKit"):Connect(updateLocalObjectiveKitIcon);
    LocalPlayer:GetAttributeChangedSignal("HasRescueKit"):Connect(updateLocalObjectiveKitIcon);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(updateLocalObjectiveKitIcon);
    Remotes.Inventory.SpectatedPlayerInventory.Listen(function(p167) -- Line: 1020
        -- upvalues: LocalPlayer (ref), SpectateController (ref), convertInventoryDataToServerLoadout (ref), updateInventoryFrame (ref), updateCurrentEquipped (ref)
        if LocalPlayer:GetAttribute("IsSpectating") == true then
            local v168 = SpectateController.GetPlayer();
            local v169 = v168 and (p167.Player == v168 and convertInventoryDataToServerLoadout(p167.Inventory));

            if v169 then
                updateInventoryFrame(v169, v168);
                local v170 = p167.EquippedSlot or 0;
                local v171 = p167.EquippedSlotSpace or 0;

                if v170 > 0 and v171 > 0 then
                    local v172 = v169[v170];

                    if v172 and (v172._items and v172._items[v171]) then
                        updateCurrentEquipped(v171, v172._items[v171]);
                    end;
                end;
            end;
        end;
    end);
    SpectateController.ListenToSpectate:Connect(function(p173) -- Line: 1046
        -- upvalues: Remotes (ref), u14 (ref), InventoryController (ref), updateInventoryFrame (ref), updateCurrentEquipped (ref), LocalPlayer (ref)
        if p173 then
            Remotes.Inventory.RequestSpectatedPlayerInventory.Send(p173);
            local DefuseKit = u14.Grenade.DefuseKit;
            local v174;

            if p173 and p173:GetAttribute("Team") == "Counter-Terrorists" then
                local v175 = workspace:GetAttribute("Gamemode");
                local v176 = v175 == "Bomb Defusal" and "HasDefuseKit" or (v175 == "Hostage Rescue" and "HasRescueKit" or nil);

                if v176 then
                    v174 = p173:GetAttribute(v176) == true;
                else
                    v174 = false;
                end;
            else
                v174 = false;
            end;

            DefuseKit.Visible = v174;

            return;
        end;

        local v177 = InventoryController.getCurrentInventory();

        if v177 then
            updateInventoryFrame(v177);
        end;

        local v178 = InventoryController.getCurrentEquipped();

        if v177 and (v178 and v178.Identifier) then
            local v179 = false;

            for i = 1, 5 do
                if v179 then
                    break;
                end;

                local v180 = v177[i];

                if v180 and v180._items then
                    for i2, v in ipairs(v180._items) do
                        if v.Identifier == v178.Identifier then
                            updateCurrentEquipped(i2, v);
                            v179 = true;
                            break;
                        end;
                    end;
                end;
            end;
        end;

        local v181 = LocalPlayer;
        local DefuseKit = u14.Grenade.DefuseKit;
        local v182;

        if v181 and v181:GetAttribute("Team") == "Counter-Terrorists" then
            local v183 = workspace:GetAttribute("Gamemode");
            local v184 = v183 == "Bomb Defusal" and "HasDefuseKit" or (v183 == "Hostage Rescue" and "HasRescueKit" or nil);

            if v184 then
                v182 = v181:GetAttribute(v184) == true;
            else
                v182 = false;
            end;
        else
            v182 = false;
        end;

        DefuseKit.Visible = v182;
    end);

    local function updateSpectatedObjectiveKit() -- Line: 1083
        -- upvalues: LocalPlayer (ref), SpectateController (ref), u14 (ref)
        local v185 = LocalPlayer:GetAttribute("IsSpectating") == true and SpectateController.GetPlayer();

        if v185 then
            local DefuseKit = u14.Grenade.DefuseKit;
            local v186;

            if v185 and v185:GetAttribute("Team") == "Counter-Terrorists" then
                local v187 = workspace:GetAttribute("Gamemode");
                local v188 = v187 == "Bomb Defusal" and "HasDefuseKit" or (v187 == "Hostage Rescue" and "HasRescueKit" or nil);

                if v188 then
                    v186 = v185:GetAttribute(v188) == true;
                else
                    v186 = false;
                end;
            else
                v186 = false;
            end;

            DefuseKit.Visible = v186;
        end;
    end;

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            v:GetAttributeChangedSignal("HasDefuseKit"):Connect(updateSpectatedObjectiveKit);
            v:GetAttributeChangedSignal("HasRescueKit"):Connect(updateSpectatedObjectiveKit);
            v:GetAttributeChangedSignal("Team"):Connect(updateSpectatedObjectiveKit);
        end;
    end;

    Players.PlayerAdded:Connect(function(p189) -- Line: 1103
        -- upvalues: LocalPlayer (ref), updateSpectatedObjectiveKit (copy)
        if p189 == LocalPlayer then
            return;
        end;

        p189:GetAttributeChangedSignal("HasDefuseKit"):Connect(updateSpectatedObjectiveKit);
        p189:GetAttributeChangedSignal("HasRescueKit"):Connect(updateSpectatedObjectiveKit);
        p189:GetAttributeChangedSignal("Team"):Connect(updateSpectatedObjectiveKit);
    end);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(function() -- Line: 1112
        -- upvalues: LocalPlayer (ref), SpectateController (ref), u14 (ref)
        if LocalPlayer:GetAttribute("IsSpectating") then
            local v190 = LocalPlayer:GetAttribute("IsSpectating") == true and SpectateController.GetPlayer();

            if v190 then
                local DefuseKit = u14.Grenade.DefuseKit;
                local v191;

                if v190 and v190:GetAttribute("Team") == "Counter-Terrorists" then
                    local v192 = workspace:GetAttribute("Gamemode");
                    local v193 = v192 == "Bomb Defusal" and "HasDefuseKit" or (v192 == "Hostage Rescue" and "HasRescueKit" or nil);

                    if v193 then
                        v191 = v190:GetAttribute(v193) == true;
                    else
                        v191 = false;
                    end;
                else
                    v191 = false;
                end;

                DefuseKit.Visible = v191;
            end;
        else
            local v194 = LocalPlayer;
            local DefuseKit = u14.Grenade.DefuseKit;
            local v195;

            if v194 and v194:GetAttribute("Team") == "Counter-Terrorists" then
                local v196 = workspace:GetAttribute("Gamemode");
                local v197 = v196 == "Bomb Defusal" and "HasDefuseKit" or (v196 == "Hostage Rescue" and "HasRescueKit" or nil);

                if v197 then
                    v195 = v194:GetAttribute(v197) == true;
                else
                    v195 = false;
                end;
            else
                v195 = false;
            end;

            DefuseKit.Visible = v195;
        end;
    end);

    if LocalPlayer:GetAttribute("IsSpectating") then
        local v198 = LocalPlayer:GetAttribute("IsSpectating") == true and SpectateController.GetPlayer();

        if v198 then
            local DefuseKit = u14.Grenade.DefuseKit;
            local v199;

            if v198 and v198:GetAttribute("Team") == "Counter-Terrorists" then
                local v200 = workspace:GetAttribute("Gamemode");
                local v201 = v200 == "Bomb Defusal" and "HasDefuseKit" or (v200 == "Hostage Rescue" and "HasRescueKit" or nil);

                if v201 then
                    v199 = v198:GetAttribute(v201) == true;
                else
                    v199 = false;
                end;
            else
                v199 = false;
            end;

            DefuseKit.Visible = v199;
        end;
    else
        local v202 = LocalPlayer;
        local DefuseKit = u14.Grenade.DefuseKit;
        local v203;

        if v202 and v202:GetAttribute("Team") == "Counter-Terrorists" then
            local v204 = workspace:GetAttribute("Gamemode");
            local v205 = v204 == "Bomb Defusal" and "HasDefuseKit" or (v204 == "Hostage Rescue" and "HasRescueKit" or nil);

            if v205 then
                v203 = v202:GetAttribute(v205) == true;
            else
                v203 = false;
            end;
        else
            v203 = false;
        end;

        DefuseKit.Visible = v203;
    end;

    local function requestSpectatedInventoryUpdate() -- Line: 1127
        -- upvalues: LocalPlayer (ref), SpectateController (ref), Remotes (ref)
        local v206 = LocalPlayer:GetAttribute("IsSpectating") == true and SpectateController.GetPlayer();

        if v206 then
            Remotes.Inventory.RequestSpectatedPlayerInventory.Send(v206);
        end;
    end;

    Remotes.Inventory.NewInventoryItem.Listen(function(p207) -- Line: 1138
        -- upvalues: LocalPlayer (ref), SpectateController (ref), Remotes (ref)
        local v208 = LocalPlayer:GetAttribute("IsSpectating") == true and SpectateController.GetPlayer();

        if v208 then
            Remotes.Inventory.RequestSpectatedPlayerInventory.Send(v208);
        end;
    end);
    Remotes.Inventory.RemoveInventoryItem.Listen(function(p209) -- Line: 1144
        -- upvalues: LocalPlayer (ref), SpectateController (ref), Remotes (ref)
        local v210 = LocalPlayer:GetAttribute("IsSpectating") == true and SpectateController.GetPlayer();

        if v210 then
            Remotes.Inventory.RequestSpectatedPlayerInventory.Send(v210);
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.Item.Always Show Inventory", function() -- Line: 1149
        -- upvalues: DataController (ref), LocalPlayer (ref), resetFadeTimer (ref), startFade (ref)
        local v211 = DataController.Get(LocalPlayer, "Settings.Game.Item.Always Show Inventory") ~= false;
        resetFadeTimer();

        if not v211 then
            startFade();
        end;
    end);
    task.wait(0.1);

    if DataController.Get(LocalPlayer, "Settings.Game.Item.Always Show Inventory") == false then
        startFade();
    end;
end;

return v1;