-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local Debris = workspace:WaitForChild("Debris");
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local InputController = require(ReplicatedStorage.Controllers.InputController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local CharacterHighlight = require(ReplicatedStorage.Classes.CharacterHighlight);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local CharacterKinematics = require(script.Components.CharacterKinematics);
local Defuser = require(script.Components.Defuser);
local u1 = {
    ["Counter-Terrorists"] = Color3.fromRGB(25, 80, 170),
    Terrorists = Color3.fromRGB(255, 215, 70)
};
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = nil;

local function CleanupNameTagJanitor(p6) -- Line: 55
    -- upvalues: u3 (copy), u5 (ref)
    if u3[p6] then
        u3[p6]:Destroy();
        u3[p6] = nil;

        if u5 then
            u5();
        end;
    end;
end;

local function waitForHumanoid(p7, p8) -- Line: 67
    local v9 = p7:FindFirstChildOfClass("Humanoid");

    if v9 then
        return v9;
    end;

    local v10 = tick();

    while p7.Parent do
        task.wait(0.1);
        local v11 = p7:FindFirstChildOfClass("Humanoid");

        if v11 then
            return v11;
        end;

        if p8 and p8 <= tick() - v10 then
            return nil;
        end;
    end;

    return nil;
end;

local function IsActiveAliveCharacter(p12, p13, p14) -- Line: 90
    -- upvalues: Debris (copy)
    local v15;

    if p12.Character == p13 then
        v15 = p13:IsDescendantOf(workspace) and not p13:IsDescendantOf(Debris);

        if v15 then
            if p13:GetAttribute("Dead") == true then
                v15 = false;
            else
                v15 = p14.Health > 0;
            end;
        end;
    else
        v15 = false;
    end;

    return v15;
end;

local function GetNameTagDisplayColor(p16, p17, p18, p19) -- Line: 100
    return p17 and p17:GetAttribute("CompetitivePlayerColor") or p19;
end;

local function ApplyNameTagTextColor(p20, p21) -- Line: 112
    for _, descendant in ipairs(p20:GetDescendants()) do
        if descendant:IsA("TextLabel") then
            descendant.TextColor3 = p21;
        elseif descendant:IsA("TextButton") then
            descendant.TextColor3 = p21;
        elseif descendant:IsA("TextBox") then
            descendant.TextColor3 = p21;
        end;
    end;
end;

local function CreateNameTag(u22, u23, u24) -- Line: 126
    -- upvalues: u1 (copy), waitForHumanoid (copy), Debris (copy), u3 (copy), u5 (ref), Janitor (copy), ReplicatedStorage (copy), PlayerGui (copy), ApplyNameTagTextColor (copy), Observers (copy), HttpService (copy), GetWeaponProperties (copy), u4 (copy)
    local u25 = u1[u24];

    if not u25 then
        return nil;
    end;

    local u26 = waitForHumanoid(u23);

    if not u26 then
        return nil;
    end;

    local Head = u23:WaitForChild("Head");

    if Head and u26 then
        local v27;

        if u22.Character == u23 then
            v27 = u23:IsDescendantOf(workspace) and not u23:IsDescendantOf(Debris);

            if v27 then
                if u23:GetAttribute("Dead") == true then
                    v27 = false;
                else
                    v27 = u26.Health > 0;
                end;
            end;
        else
            v27 = false;
        end;

        if v27 then
            if u3[u22] then
                u3[u22]:Destroy();
                u3[u22] = nil;

                if u5 then
                    u5();
                end;
            end;

            local v28 = Janitor.new();
            local u29 = v28:Add(ReplicatedStorage.Assets.Other.Character.Arrow:Clone());
            local v30;

            if u23 then
                v30 = u23:GetAttribute("CompetitivePlayerColor") or u25;
            else
                v30 = u25;
            end;

            u29.Arrow.ImageColor3 = v30;
            u29.Adornee = Head;
            u29.Parent = PlayerGui;
            local u31 = v28:Add(ReplicatedStorage.Assets.Other.Character.NameTag:Clone());
            u31.Info.PlayerName.Text = `{u22.DisplayName}`;
            u31.Info.Weapons.Bomb.Visible = false;
            u31.Adornee = Head;
            u31.Parent = PlayerGui;
            u31.Info.Health.Text = `{math.ceil(u26.Health / u26.MaxHealth * 100)}%`;
            ApplyNameTagTextColor(u31, v30);
            v28:Add(u23:GetAttributeChangedSignal("CompetitivePlayerColor"):Connect(function() -- Line: 171
                -- upvalues: u22 (copy), u23 (copy), u24 (copy), u25 (copy), u29 (copy), u31 (copy), ApplyNameTagTextColor (ref)
                local v32 = u23;
                local v33 = u25;

                if v32 then
                    v33 = v32:GetAttribute("CompetitivePlayerColor") or v33;
                end;

                if u29.Parent and u29:FindFirstChild("Arrow") then
                    u29.Arrow.ImageColor3 = v33;
                end;

                if not u31.Parent then
                    return;
                end;

                ApplyNameTagTextColor(u31, v33);
            end));
            v28:Add(u26:GetPropertyChangedSignal("Health"):Connect(function() -- Line: 185
                -- upvalues: u31 (copy), u26 (copy)
                if not (u31 and (u31.Parent and u31:FindFirstChild("Info"))) then
                    return;
                end;

                u31.Info.Health.Text = `{math.ceil(u26.Health / u26.MaxHealth * 100)}%`;
            end));
            v28:Add(Observers.observeAttribute(u22, "CurrentEquipped", function(p34) -- Line: 193
                -- upvalues: u31 (copy), HttpService (ref), GetWeaponProperties (ref), u22 (copy)
                if not (u31 and (u31.Parent and u31:FindFirstChild("Info"))) then
                    return function() -- Line: 195
                    end;
                end;

                local v35 = HttpService:JSONDecode(p34 or "[]");

                if v35 and v35.Name then
                    local v36 = GetWeaponProperties(v35.Name);

                    if u31.Info and (u31.Info.Weapons and u31.Info.Weapons.Gun) then
                        u31.Info.Weapons.Gun.Image = v36 and (v36.Icon or "") or "";
                        u31.Info.Weapons.Gun.Visible = v36 or false;
                    end;
                elseif u31.Info and (u31.Info.Weapons and u31.Info.Weapons.Gun) then
                    u31.Info.Weapons.Gun.Visible = false;
                end;

                if v35 then
                    v35 = v35.Name == "C4";
                end;

                if u31.Info and (u31.Info.Weapons and u31.Info.Weapons.Bomb) then
                    local v37 = u22:GetAttribute("Slot5");
                    local v38;

                    if v37 then
                        v38 = HttpService:JSONDecode(v37);

                        if v38 then
                            v38 = v38.Weapon == "C4";
                        end;
                    else
                        v38 = false;
                    end;

                    if v38 then
                        v38 = not v35;
                    end;

                    u31.Info.Weapons.Bomb.Visible = v38;
                end;

                return function() -- Line: 234
                    -- upvalues: u31 (ref)
                    if u31 and (u31:FindFirstChild("Info") and (u31.Info.Weapons and u31.Info.Weapons.Gun)) then
                        u31.Info.Weapons.Gun.Visible = false;
                    end;
                end;
            end));
            v28:Add(Observers.observeAttribute(u22, "Slot5", function(p39) -- Line: 242
                -- upvalues: u31 (copy), HttpService (ref), u22 (copy)
                if not (u31 and (u31.Parent and u31:FindFirstChild("Info"))) then
                    return function() -- Line: 244
                    end;
                end;

                local v40 = HttpService:JSONDecode(p39 or "[]");

                if v40 then
                    v40 = v40.Weapon == "C4";
                end;

                local v41 = u22:GetAttribute("CurrentEquipped");
                local v42;

                if v41 then
                    v42 = HttpService:JSONDecode(v41);

                    if v42 then
                        v42 = v42.Name == "C4";
                    end;
                else
                    v42 = false;
                end;

                if u31.Info and (u31.Info.Weapons and u31.Info.Weapons.Bomb) then
                    if v40 then
                        v40 = not v42;
                    end;

                    u31.Info.Weapons.Bomb.Visible = v40;
                end;

                return function() -- Line: 266
                    -- upvalues: u31 (ref)
                    if u31 and (u31:FindFirstChild("Info") and (u31.Info.Weapons and u31.Info.Weapons.Bomb)) then
                        u31.Info.Weapons.Bomb.Visible = false;
                    end;
                end;
            end));
            u3[u22] = v28;
            u4[u22] = {
                Arrow = u29,
                NameTag = u31
            };
            v28:Add(function() -- Line: 283
                -- upvalues: u4 (ref), u22 (copy)
                u4[u22] = nil;
            end);

            local function cleanupIfCharacterBecameStale() -- Line: 287
                -- upvalues: u22 (copy), u23 (copy), u26 (copy), Debris (ref), u3 (ref), u5 (ref)
                local v43 = u23;
                local v44 = u26;
                local v45;

                if u22.Character == v43 then
                    v45 = v43:IsDescendantOf(workspace) and not v43:IsDescendantOf(Debris);

                    if v45 then
                        if v43:GetAttribute("Dead") == true then
                            v45 = false;
                        else
                            v45 = v44.Health > 0;
                        end;
                    end;
                else
                    v45 = false;
                end;

                if not v45 then
                    local v46 = u22;

                    if u3[v46] then
                        u3[v46]:Destroy();
                        u3[v46] = nil;

                        if u5 then
                            u5();
                        end;
                    end;
                end;
            end;

            v28:Add(u23:GetAttributeChangedSignal("Dead"):Connect(cleanupIfCharacterBecameStale));
            v28:Add(u26.Died:Connect(cleanupIfCharacterBecameStale));
            v28:Add(u23.AncestryChanged:Connect(cleanupIfCharacterBecameStale));

            if u5 then
                u5();
            end;

            return v28;
        end;
    end;

    return nil;
end;

u5 = function() -- Line: 307
    -- upvalues: u4 (copy), u1 (copy), ApplyNameTagTextColor (copy)
    for i, v in pairs(u4) do
        local v47 = i:GetAttribute("Team");
        local v48;

        if v47 then
            v48 = u1[v47] or nil;
        else
            v48 = nil;
        end;

        if v47 and v48 then
            local Character = i.Character;

            if Character then
                v48 = Character:GetAttribute("CompetitivePlayerColor") or v48;
            end;

            if v.Arrow and v.Arrow.Parent then
                v.Arrow.Arrow.ImageColor3 = v48;
            end;

            if v.NameTag and v.NameTag.Parent then
                ApplyNameTagTextColor(v.NameTag, v48);
            end;
        end;
    end;
end;

workspace:GetAttributeChangedSignal("ServerGamemode"):Connect(function() -- Line: 326
    -- upvalues: u5 (ref)
    if u5 then
        u5();
    end;
end);

local function characterAdded(p49, p50, p51) -- Line: 334
    -- upvalues: CameraController (copy), InputController (copy)
    local v52 = p50:FindFirstChildOfClass("Humanoid");

    if not v52 then
        local v53 = tick();

        repeat
            task.wait(0.1);
            v52 = p50:FindFirstChildOfClass("Humanoid");
        until v52 or tick() - v53 > 5;
    end;

    if not v52 then
        return;
    end;

    CameraController.setPerspective(true, false);
    p51:Add(function() -- Line: 346
        -- upvalues: CameraController (ref)
        CameraController.setPerspective(false, true);
    end);
    InputController.enableGroup("Gameplay");
    p51:Add(function() -- Line: 352
        -- upvalues: InputController (ref)
        InputController.disableGroup("Gameplay");
    end);
    p51:Add(v52.StateChanged:Connect(function(p54, p55) -- Line: 357
        -- upvalues: CameraController (ref)
        CameraController.StateChanged(p54, p55);
    end));
end;

local function SetAllNameTagsVisibility(p56) -- Line: 364
    -- upvalues: u4 (copy)
    for _, v in pairs(u4) do
        if v.Arrow then
            v.Arrow.Enabled = p56;
        end;

        if v.NameTag then
            v.NameTag.Enabled = p56;
        end;
    end;
end;

SpectateController.ListenToSpectate:Connect(function(p57) -- Line: 377, Name: OnSpectateChanged
    -- upvalues: SetAllNameTagsVisibility (copy)
    SetAllNameTagsVisibility(p57 == nil);
end);

return Observers.observeCharacter(function(u58, u59) -- Line: 389
    -- upvalues: u2 (copy), Janitor (copy), u3 (copy), u5 (ref), LocalPlayer (copy), characterAdded (copy), Players (copy), CreateNameTag (copy), CharacterKinematics (copy), Defuser (copy), CharacterHighlight (copy), SpectateController (copy), Observers (copy), RunServiceController (copy)
    if u2[u58] then
        u2[u58]:Destroy();
        u2[u58] = nil;
    end;

    local u60 = Janitor.new();
    u2[u58] = u60;

    if u3[u58] then
        u3[u58]:Destroy();
        u3[u58] = nil;

        if u5 then
            u5();
        end;
    end;

    if LocalPlayer == u58 then
        characterAdded(u58, u59, u60);

        for i, _ in pairs(u3) do
            if u3[i] then
                u3[i]:Destroy();
                u3[i] = nil;

                if u5 then
                    u5();
                end;
            end;
        end;

        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= LocalPlayer then
                local Character = v.Character;

                if Character and Character:IsDescendantOf(workspace) then
                    local v61 = LocalPlayer:GetAttribute("Team");
                    local v62 = v:GetAttribute("Team");

                    if v61 == v62 and (v62 == "Terrorists" or v62 == "Counter-Terrorists") and workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
                        CreateNameTag(v, Character, v62);

                        if u2[v] then
                            u2[v]:Add(function() -- Line: 429
                                -- upvalues: v (copy), u3 (ref), u5 (ref)
                                local v63 = v;

                                if u3[v63] then
                                    u3[v63]:Destroy();
                                    u3[v63] = nil;

                                    if u5 then
                                        u5();
                                    end;
                                end;
                            end);
                        end;
                    end;
                end;
            end;
        end;
    else
        local v64 = u58:GetAttribute("Team");
        local v65 = v64 == "Counter-Terrorists" and Color3.fromRGB(0, 75, 200) or (v64 == "Terrorists" and Color3.fromRGB(255, 220, 50) or Color3.fromRGB(255, 255, 255));
        u60:Add(function() -- Line: 447
            -- upvalues: CharacterKinematics (ref), u58 (copy)
            CharacterKinematics.cleanup(u58);
        end);
        local u66 = Defuser.new(u58, u59);
        u60:Add(function() -- Line: 452
            -- upvalues: u66 (copy)
            u66:Destroy();
        end);
        local v67 = workspace:GetAttribute("Gamemode");
        local v68 = v64 == "Terrorists" and true or v64 == "Counter-Terrorists";
        local v69;

        if v68 then
            v69 = v67 ~= "Deathmatch";
        else
            v69 = v68;
        end;

        local v70 = LocalPlayer:GetAttribute("Team") == v64;

        if v68 then
            local v71;

            if v67 == "Deathmatch" then
                v71 = Enum.HighlightDepthMode.Occluded;
            else
                v71 = Enum.HighlightDepthMode.AlwaysOnTop;
            end;

            local u72 = u60:Add(CharacterHighlight.new(u59, {
                OutlineTransparency = 0.4,
                FillTransparency = 0.7,
                DepthMode = v71,
                FillColor = Color3.fromRGB(255, 255, 255),
                OutlineColor = v65
            }));

            local function updateHighlightVisible() -- Line: 475
                -- upvalues: u59 (copy), u58 (copy), LocalPlayer (ref), SpectateController (ref), u72 (copy)
                if not (u59 and u59.Parent) then
                    return;
                end;

                local v73 = workspace:GetAttribute("Gamemode");
                local v74 = workspace:GetAttribute("GameState");
                local v75 = u58:GetAttribute("Team");
                local v76 = u59:GetAttribute("Dead") == true;
                local v77 = u59:GetAttribute("Invincible") == true;
                local v78 = LocalPlayer:GetAttribute("IsSpectating") == true;
                local v79 = SpectateController.GetPlayer();
                local v80;

                if v79 then
                    v80 = v79:GetAttribute("Team");
                else
                    v80 = v79;
                end;

                local v81 = SpectateController.GetCurrentSpectateInstance();
                local v82;

                if v81 == nil then
                    v82 = false;
                else
                    v82 = v81.PerspectiveState == "First-Person";
                end;

                local v83 = v79 == u58;
                local v84 = LocalPlayer:GetAttribute("Team") == v75;

                if v78 then
                    if not v82 then
                        v83 = v82;
                    end;
                else
                    v83 = v78;
                end;

                local v85;

                if v73 == "Deathmatch" then
                    v85 = false;
                elseif v78 then
                    if v80 == v75 then
                        v85 = not v83;
                    else
                        v85 = false;
                    end;
                else
                    v85 = v78;
                end;

                if v84 then
                    v78 = v84;
                elseif v78 then
                    v78 = v80 == v75;
                end;

                local v86 = v77 and not v83 and (v73 == "Deathmatch" and true or (v74 == "Warmup" and true or v78));
                local v87;

                if v86 and v74 == "Warmup" then
                    v87 = Enum.HighlightDepthMode.Occluded;
                elseif v73 == "Deathmatch" then
                    v87 = Enum.HighlightDepthMode.Occluded;
                else
                    v87 = Enum.HighlightDepthMode.AlwaysOnTop;
                end;

                if u72.Highlight and u72.Highlight.Parent then
                    u72.Highlight.DepthMode = v87;
                end;

                if v76 then
                    u72.OutlineOnly = false;
                    u72:UpdateState(false);

                    return;
                end;

                local v88;

                if v85 then
                    v88 = not v86;
                else
                    v88 = v85;
                end;

                u72.OutlineOnly = v88;
                u72:UpdateState(v86 or v85);
            end;

            u60:Add(Observers.observeAttribute(u59, "Dead", function(p89) -- Line: 515
                -- upvalues: updateHighlightVisible (copy), u72 (copy)
                updateHighlightVisible();

                return function() -- Line: 517
                    -- upvalues: u72 (ref)
                    u72:UpdateState(false);
                end;
            end));
            u60:Add(Observers.observeAttribute(u59, "Invincible", function(p90) -- Line: 522
                -- upvalues: updateHighlightVisible (copy), u72 (copy)
                updateHighlightVisible();

                return function() -- Line: 524
                    -- upvalues: u72 (ref)
                    u72:UpdateState(false);
                end;
            end));
            u60:Add(Observers.observeAttribute(LocalPlayer, "IsSpectating", function() -- Line: 529
                -- upvalues: updateHighlightVisible (copy)
                updateHighlightVisible();

                return function() -- Line: 531
                end;
            end));
            u60:Add(SpectateController.ListenToSpectate:Connect(function() -- Line: 534
                -- upvalues: updateHighlightVisible (copy)
                updateHighlightVisible();
            end));
            u60:Add(Observers.observeAttribute(LocalPlayer, "Team", function() -- Line: 538
                -- upvalues: updateHighlightVisible (copy)
                updateHighlightVisible();

                return function() -- Line: 540
                end;
            end));
            u60:Add(Observers.observeAttribute(u58, "Team", function() -- Line: 543
                -- upvalues: updateHighlightVisible (copy)
                updateHighlightVisible();

                return function() -- Line: 545
                end;
            end));
            u60:Add(Observers.observeAttribute(workspace, "GameState", function() -- Line: 548
                -- upvalues: updateHighlightVisible (copy)
                updateHighlightVisible();

                return function() -- Line: 550
                end;
            end));
            local u91 = 0;
            u72.Janitor:Add(RunServiceController.BindToHeartbeat(`Observers.Character.HighlightSync.{u58.UserId}`, function(p92) -- Line: 555
                -- upvalues: u91 (ref), LocalPlayer (ref), u59 (copy), updateHighlightVisible (copy)
                u91 = u91 + p92;

                if u91 >= 0.2 then
                    u91 = 0;

                    if LocalPlayer:GetAttribute("IsSpectating") == true or u59:GetAttribute("Invincible") == true then
                        updateHighlightVisible();
                    end;
                end;
            end));
            updateHighlightVisible();
        end;

        if v70 and v69 then
            CreateNameTag(u58, u59, v64);
            u60:Add(function() -- Line: 573
                -- upvalues: u58 (copy), u3 (ref), u5 (ref)
                local v93 = u58;

                if u3[v93] then
                    u3[v93]:Destroy();
                    u3[v93] = nil;

                    if u5 then
                        u5();
                    end;
                end;
            end);
        end;

        if LocalPlayer:GetAttribute("IsSpectating") and not SpectateController.GetCurrentSpectateInstance() then
            SpectateController.Next();
        end;
    end;

    return function() -- Line: 588
        -- upvalues: u60 (copy)
        u60:Destroy();
    end;
end);