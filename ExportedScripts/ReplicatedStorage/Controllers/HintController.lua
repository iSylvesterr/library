-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local HttpService = game:GetService("HttpService");
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = workspace.CurrentCamera;
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local InputController = require(script.Parent.InputController);
local DataController = require(script.Parent.DataController);
local ConfigController = require(script.Parent.ConfigController);
local RunServiceController = require(script.Parent.RunServiceController);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local u2 = {};
local u3 = nil;
local u4 = 0;
local u5 = nil;
local u6 = 0;
local Hints = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("UI"):WaitForChild("Hints");
local Static = Hints:WaitForChild("Static");
local Ranged = Hints:WaitForChild("Ranged");
local Middle = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainGui"):WaitForChild("Gameplay"):WaitForChild("Middle");
local u7 = {
    BuyMenu = {
        Type = "Static",
        Action = "Buy Menu",
        Blurb = "Open the Buy Menu!"
    },
    PlantAction = {
        Type = "Static",
        Action = "Fire",
        Blurb = "Plant the Bomb!"
    },
    EquipBomb = {
        Type = "Static",
        Action = "Explosives & Traps",
        Blurb = "Equip the Bomb!"
    },
    Inspect = {
        Type = "Static",
        Action = "Inspect",
        Blurb = "Inspect"
    },
    Reload = {
        Type = "Static",
        Action = "Reload",
        Blurb = "Reload your Weapon!"
    },
    Use = {
        Type = "Static",
        Action = "Use",
        Blurb = ""
    },
    Plant = {
        Type = "Ranged",
        Action = "Plant",
        Blurb = "Plant the Bomb!",
        HideDistance = 5
    },
    Defuse = {
        Type = "Ranged",
        Action = "Defuse",
        Blurb = "Defuse the Bomb!",
        HideDistance = 5
    },
    Rescue = {
        Type = "Ranged",
        Action = "Rescue",
        Blurb = "Rescue the Hostage!",
        HideDistance = 5
    },
    Return = {
        Type = "Ranged",
        Action = "Return",
        Blurb = "Return the Hostage",
        HideDistance = 5
    },
    Defend = {
        Type = "Ranged",
        Action = "Defend",
        Blurb = "Defend!",
        HideDistance = 0
    },
    HelpPlant = {
        Type = "Ranged",
        Action = "HelpPlant",
        Blurb = "Help Plant the Bomb",
        HideDistance = 0
    },
    DefendHostage = {
        Type = "Ranged",
        Action = "Defend",
        Blurb = "Defend the Hostages!",
        HideDistance = 0
    }
};

local function isInstructorEnabled() -- Line: 75
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local success, result = pcall(DataController.Get, LocalPlayer, "Settings.Game.HUD.Enable Game Instructor Messages");

    return not success or result ~= false;
end;

local function isOnboardingActive() -- Line: 81
    -- upvalues: u5 (ref), ConfigController (copy), GameState (copy), u6 (ref)
    if u5 == nil or u5 > 1 then
        return false;
    end;

    if not ConfigController.Get("IsNewOnboarding") then
        return false;
    end;

    local v8 = GameState.GetState();
    local v9 = u6;

    if v8 == "Buy Period" or v8 == "Warmup" then
        v9 = v9 + 1;
    end;

    return v9 <= 1;
end;

local function isAlive() -- Line: 94
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    local v10;

    if Character == nil then
        v10 = false;
    else
        v10 = Character.Health > 0;
    end;

    return v10;
end;

local function getRoot() -- Line: 100
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;
    local v11;

    if Character then
        v11 = Character.PrimaryPart or Character:FindFirstChild("HumanoidRootPart") or nil;
    else
        v11 = nil;
    end;

    return v11;
end;

local function decodeJSON(p12) -- Line: 105
    -- upvalues: HttpService (copy)
    if typeof(p12) ~= "string" then
        return nil;
    end;

    local success, result = pcall(HttpService.JSONDecode, HttpService, p12);

    if success and typeof(result) == "table" then
        return result;
    end;

    return nil;
end;

local function hasBomb(p13) -- Line: 112
    -- upvalues: HttpService (copy)
    local v14 = p13:GetAttribute("Slot5");
    local v15;

    if typeof(v14) == "string" then
        local v16;
        v16, v15 = pcall(HttpService.JSONDecode, HttpService, v14);

        if not v16 or typeof(v15) ~= "table" then
            v15 = nil;
        end;
    else
        v15 = nil;
    end;

    local v17;

    if v15 == nil then
        v17 = false;
    else
        v17 = v15.Weapon == "C4";
    end;

    return v17;
end;

local function localBombEquipped() -- Line: 117
    -- upvalues: LocalPlayer (copy), HttpService (copy)
    local v18 = LocalPlayer:GetAttribute("CurrentEquipped");
    local v19;

    if typeof(v18) == "string" then
        local v20;
        v20, v19 = pcall(HttpService.JSONDecode, HttpService, v18);

        if not v20 or typeof(v19) ~= "table" then
            v19 = nil;
        end;
    else
        v19 = nil;
    end;

    local v21;

    if v19 == nil then
        v21 = false;
    else
        v21 = v19.Name == "C4";
    end;

    return v21;
end;

local function teammateBombCarrier() -- Line: 122
    -- upvalues: LocalPlayer (copy), Players (copy), HttpService (copy)
    local v22 = LocalPlayer:GetAttribute("Team");

    if not v22 then
        return nil;
    end;

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v:GetAttribute("Team") == v22 then
            local v23 = v:GetAttribute("Slot5");
            local v24;

            if typeof(v23) == "string" then
                local v25;
                v25, v24 = pcall(HttpService.JSONDecode, HttpService, v23);

                if not v25 or typeof(v24) ~= "table" then
                    v24 = nil;
                end;
            else
                v24 = nil;
            end;

            local v26;

            if v24 == nil then
                v26 = false;
            else
                v26 = v24.Weapon == "C4";
            end;

            if v26 then
                return v;
            end;
        end;
    end;

    return nil;
end;

local function distanceToOBB(p27, p28) -- Line: 133
    local v29 = p27.CFrame:PointToObjectSpace(p28);
    local v30 = p27.Size * 0.5;
    local v31 = math.clamp(v29.X, -v30.X, v30.X);
    local v32 = math.clamp(v29.Y, -v30.Y, v30.Y);
    local v33 = math.clamp(v29.Z, -v30.Z, v30.Z);
    local v34 = Vector3.new(v31, v32, v33);

    return (p27.CFrame:PointToWorldSpace(v34) - p28).Magnitude;
end;

local function bombSiteParts() -- Line: 140
    local v35 = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Zones") and workspace.Map.Zones:FindFirstChild("Sites");
    local v36 = {};

    if not v35 then
        return v36;
    end;

    for _, descendant in ipairs(v35:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant:GetAttribute("Site") then
            table.insert(v36, descendant);
        end;
    end;

    return v36;
end;

local function bombSiteRepresentatives() -- Line: 152
    -- upvalues: bombSiteParts (copy)
    local v37 = {};

    for _, v in ipairs((bombSiteParts())) do
        local v38 = v:GetAttribute("Site");

        if not v37[v38] then
            v37[v38] = v;
        end;
    end;

    return v37;
end;

local function isInPlantZone() -- Line: 161
    -- upvalues: LocalPlayer (copy), bombSiteParts (copy), distanceToOBB (copy)
    local Character = LocalPlayer.Character;
    local v39;

    if Character then
        v39 = Character.PrimaryPart or Character:FindFirstChild("HumanoidRootPart") or nil;
    else
        v39 = nil;
    end;

    if not v39 then
        return false;
    end;

    for _, v in ipairs((bombSiteParts())) do
        if distanceToOBB(v, v39.Position) <= 0.25 then
            return true;
        end;
    end;

    return false;
end;

local function buyMenuFrame() -- Line: 170
    -- upvalues: Middle (copy)
    local BuyMenu = Middle:FindFirstChild("BuyMenu");

    if BuyMenu and BuyMenu:IsA("GuiObject") then
        return BuyMenu;
    end;

    return nil;
end;

local function canShowBuyMenu() -- Line: 176
    -- upvalues: GameState (copy)
    local v40 = GameState.GetState();

    return v40 == "Buy Period" and true or v40 == "Warmup";
end;

local u41 = nil;
local u42 = nil;

local function isOnScreen(p43) -- Line: 187
    -- upvalues: CurrentCamera (copy)
    local v44, v45 = CurrentCamera:WorldToViewportPoint(p43);

    if not v45 then
        return false, v44;
    end;

    local ViewportSize = CurrentCamera.ViewportSize;

    if v44.X < 100 or (v44.X > ViewportSize.X - 100 or (v44.Y < 100 or v44.Y > ViewportSize.Y - 100)) then
        return false, v44;
    end;

    return true, v44;
end;

local function updateRangedHint(p46) -- Line: 198
    -- upvalues: u41 (ref), LocalPlayer (copy), u42 (ref), CurrentCamera (copy)
    local target = p46.target;

    if not (target and target.Parent) then
        u41(p46.hintId);

        return;
    end;

    local v47 = p46.icon or p46.ui:FindFirstChild("Icon");
    local v48 = p46.arrow or p46.ui:FindFirstChild("Arrow");
    local v49 = p46.attentionFrame or p46.ui:FindFirstChild("Attention");

    if not (v47 and (v48 and v49)) then
        return;
    end;

    p46.icon = v47;
    p46.arrow = v48;
    p46.attentionFrame = v49;
    local Position = target.Position;

    if p46.promoteOnClose and p46.hideDistance > 0 then
        local Character = LocalPlayer.Character;
        local v50;

        if Character then
            v50 = Character.PrimaryPart or (Character:FindFirstChild("HumanoidRootPart") or nil);
        else
            v50 = nil;
        end;

        if v50 and (v50.Position - Position).Magnitude <= p46.hideDistance then
            local hintType = p46.hintType;
            u41(p46.hintId);

            if hintType == "Defuse" then
                u42("Use", nil, "Defuse the Bomb!", "Use", false);
                task.delay(3, function() -- Line: 221
                    -- upvalues: u41 (ref)
                    u41("Use");
                end);

                return;
            end;

            if hintType ~= "Rescue" then
                if hintType == "Plant" then
                    u42("PlantAction", nil, nil, "PlantAction", false);
                end;

                return;
            end;

            u42("Use", nil, "Rescue the Hostage!", "Use", false);
            task.delay(3, function() -- Line: 224
                -- upvalues: u41 (ref)
                u41("Use");
            end);

            return;
        end;
    end;

    local CFrame = CurrentCamera.CFrame;
    local ViewportSize = CurrentCamera.ViewportSize;
    local v51, v52 = CurrentCamera:WorldToViewportPoint(Position);
    local v53;

    if v52 then
        local ViewportSize2 = CurrentCamera.ViewportSize;
        v53 = v51.X >= 100 and (v51.X <= ViewportSize2.X - 100 and (v51.Y >= 100 and v51.Y <= ViewportSize2.Y - 100));
    else
        v53 = false;
    end;

    if v53 then
        p46.ui.BackgroundTransparency = 0.5;
        p46.ui.Position = UDim2.new(0, v51.X, 0, v51.Y - 60 - 30);
        p46.ui.AnchorPoint = Vector2.new(0.5, 0.5);
        v49.Size = UDim2.new(0.75, 0, 0.75, 0);
        v49.Visible = true;
        v48.Visible = false;
        v47.Visible = false;
    else
        p46.ui.BackgroundTransparency = 1;
        local Unit = (Position - CFrame.Position).Unit;
        local v54 = -Unit:Dot(CFrame.UpVector);
        local v55 = Unit:Dot(CFrame.RightVector);
        local v56 = math.atan2(v54, v55);
        local v57 = Vector2.new(ViewportSize.X / 2, ViewportSize.Y / 2);
        local v58 = math.min(ViewportSize.X, ViewportSize.Y) / 2 - 60;
        p46.ui.Position = UDim2.new(0, v57.X + math.cos(v56) * v58, 0, v57.Y + math.sin(v56) * v58 - 30);
        p46.ui.AnchorPoint = Vector2.new(0.5, 0.5);
        v48.Visible = true;
        v48.Position = UDim2.new(0.5, 0, 0.5, 0);
        v48.AnchorPoint = Vector2.new(0.5, 0.5);
        v48.Rotation = math.deg(v56) - 90;
        local v59 = v56 + 3.141592653589793;
        v47.Position = UDim2.new(0.5, math.cos(v59) * 55, 0.5, math.sin(v59) * 55);
        v47.Visible = true;
        v49.Visible = false;
    end;

    p46.ui.Visible = true;
end;

local function ensureRenderLoop() -- Line: 267
    -- upvalues: u3 (ref), RunServiceController (copy), u2 (copy), updateRangedHint (copy)
    if u3 then
        return;
    end;

    u3 = RunServiceController.BindToRenderStep("HintController.RenderRangedHints", function() -- Line: 269
        -- upvalues: u2 (ref), u3 (ref), updateRangedHint (ref)
        local v60 = {};

        for _, v in pairs(u2) do
            if v.target then
                table.insert(v60, v);
            end;
        end;

        if #v60 ~= 0 then
            for _, v in ipairs(v60) do
                updateRangedHint(v);
            end;

            return;
        end;

        u3:Disconnect();
        u3 = nil;
    end);
end;

local function configureStatic(p61, p62, p63) -- Line: 288
    -- upvalues: GetPreferenceColor (copy), InputController (copy)
    p61.Left.BackgroundColor3 = GetPreferenceColor();
    p61.Right.BackgroundColor3 = GetPreferenceColor();
    p61.Instructions.Text = p63 or p62.Blurb;
    p61.ControlIcon.KeycapIcon.Control.Text = InputController.GetActionKeybind(p62.Action) or "???";
end;

local function configureRanged(p64, p65, p66) -- Line: 295
    -- upvalues: GetPreferenceColor (copy), u3 (ref), RunServiceController (copy), u2 (copy), updateRangedHint (copy)
    p64.Left.BackgroundColor3 = GetPreferenceColor();
    p64.Right.BackgroundColor3 = GetPreferenceColor();
    p64.Attention.Instructions.Text = p66 or p65.Blurb;

    if u3 then
        return;
    end;

    u3 = RunServiceController.BindToRenderStep("HintController.RenderRangedHints", function() -- Line: 269
        -- upvalues: u2 (ref), u3 (ref), updateRangedHint (ref)
        local v67 = {};

        for _, v in pairs(u2) do
            if v.target then
                table.insert(v67, v);
            end;
        end;

        if #v67 ~= 0 then
            for _, v in ipairs(v67) do
                updateRangedHint(v);
            end;

            return;
        end;

        u3:Disconnect();
        u3 = nil;
    end);
end;

u42 = function(p68, p69, p70, p71, p72) -- Line: 302
    -- upvalues: u7 (copy), DataController (copy), LocalPlayer (copy), GameState (copy), u2 (copy), u41 (ref), Static (copy), GetPreferenceColor (copy), InputController (copy), Middle (copy), Ranged (copy), u3 (ref), RunServiceController (copy), updateRangedHint (copy)
    local v73 = u7[p68];

    if v73 then
        local success, result = pcall(DataController.Get, LocalPlayer, "Settings.Game.HUD.Enable Game Instructor Messages");

        if not success or result ~= false then
            local v74 = GameState.GetState();

            if p68 == "BuyMenu" then
                if v74 ~= "Buy Period" and (v74 ~= "Round In Progress" and v74 ~= "Warmup") then
                    return;
                end;
            elseif v74 ~= "Round In Progress" then
                return;
            end;

            local v75 = p71 or p68;
            local v76 = u2[v75];

            if v76 and (v76.hintType == p68 and v76.target == p69) then
                return;
            end;

            if v76 then
                u41(v75);
            end;

            if v73.Type ~= "Static" then
                if v73.Type == "Ranged" and p69 then
                    local v77 = Ranged:Clone();
                    u2[v75] = {
                        ui = v77,
                        target = p69,
                        hintType = p68,
                        hintId = v75,
                        hideDistance = v73.HideDistance or 0,
                        promoteOnClose = p72 == true,
                        icon = v77:FindFirstChild("Icon"),
                        arrow = v77:FindFirstChild("Arrow"),
                        attentionFrame = v77:FindFirstChild("Attention")
                    };
                    v77.Left.BackgroundColor3 = GetPreferenceColor();
                    v77.Right.BackgroundColor3 = GetPreferenceColor();
                    v77.Attention.Instructions.Text = p70 or v73.Blurb;

                    if not u3 then
                        u3 = RunServiceController.BindToRenderStep("HintController.RenderRangedHints", function() -- Line: 269
                            -- upvalues: u2 (ref), u3 (ref), updateRangedHint (ref)
                            local v78 = {};

                            for _, v in pairs(u2) do
                                if v.target then
                                    table.insert(v78, v);
                                end;
                            end;

                            if #v78 ~= 0 then
                                for _, v in ipairs(v78) do
                                    updateRangedHint(v);
                                end;

                                return;
                            end;

                            u3:Disconnect();
                            u3 = nil;
                        end);
                    end;

                    v77:SetAttribute("Type", p68);
                    v77.Parent = Middle;
                    v77.Visible = true;
                end;

                return;
            end;

            local v79 = Static:Clone();
            v79.Left.BackgroundColor3 = GetPreferenceColor();
            v79.Right.BackgroundColor3 = GetPreferenceColor();
            v79.Instructions.Text = p70 or v73.Blurb;
            v79.ControlIcon.KeycapIcon.Control.Text = InputController.GetActionKeybind(v73.Action) or "???";
            u2[v75] = {
                target = nil,
                hideDistance = 0,
                promoteOnClose = false,
                ui = v79,
                hintType = p68,
                hintId = v75
            };
            v79:SetAttribute("Type", p68);
            v79.Position = v79.Position - UDim2.fromOffset(0, 30);
            v79.Parent = Middle;
            v79.Visible = true;
        end;
    end;
end;

u41 = function(p80) -- Line: 346
    -- upvalues: u2 (copy), u3 (ref)
    if p80 then
        local v81 = u2[p80];

        if v81 then
            v81.ui:Destroy();
            u2[p80] = nil;
        end;

        return;
    end;

    for i, v in pairs(u2) do
        v.ui:Destroy();
        u2[i] = nil;
    end;

    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;
end;

function v1.createHint(p82, p83, p84, p85, p86, p87) -- Line: 365
    -- upvalues: u42 (ref)
    u42(p83, p84, p85, p86, p87);
end;

function v1.clearHint(p88, p89) -- Line: 369
    -- upvalues: u41 (ref)
    u41(p89);
end;

local function reconcile(p90, p91) -- Line: 378
    -- upvalues: u2 (copy), u41 (ref), u42 (ref)
    local v92 = {};

    for i, v in pairs(u2) do
        if p91(i) then
            local v93 = p90[i];

            if not v93 or v93.target ~= v.target then
                table.insert(v92, i);
            end;
        end;
    end;

    for _, v in ipairs(v92) do
        u41(v);
    end;

    for i, v in pairs(p90) do
        if not u2[i] then
            u42(v.type, v.target, nil, i, false);
        end;
    end;
end;

local function isDefusalManaged(p94) -- Line: 399
    return (p94 == "HelpPlant" or (p94 == "PlantAction" or (p94 == "EquipBomb" or string.sub(p94, 1, 6) == "Plant_"))) and true or string.sub(p94, 1, 7) == "Defend_";
end;

local function computeDefusalDesired() -- Line: 405
    -- upvalues: u5 (ref), ConfigController (copy), GameState (copy), u6 (ref), DataController (copy), LocalPlayer (copy), CollectionService (copy), bombSiteRepresentatives (copy), HttpService (copy), isInPlantZone (copy), teammateBombCarrier (copy)
    local v95 = {};
    local v96;

    if u5 == nil or u5 > 1 or not ConfigController.Get("IsNewOnboarding") then
        v96 = false;
    else
        local v97 = GameState.GetState();
        local v98 = u6;

        if v97 == "Buy Period" or v97 == "Warmup" then
            v98 = v98 + 1;
        end;

        v96 = v98 <= 1;
    end;

    if v96 and (GameState.GetState() == "Round In Progress" and workspace:GetAttribute("Gamemode") == "Bomb Defusal") then
        local success, result = pcall(DataController.Get, LocalPlayer, "Settings.Game.HUD.Enable Game Instructor Messages");

        if not success or result ~= false then
            local Character = LocalPlayer.Character;

            if Character then
                Character = Character:FindFirstChildOfClass("Humanoid");
            end;

            local v99;

            if Character == nil then
                v99 = false;
            else
                v99 = Character.Health > 0;
            end;

            if v99 and #CollectionService:GetTagged("Bomb") <= 0 then
                local v100 = LocalPlayer:GetAttribute("Team");
                local v101 = bombSiteRepresentatives();

                if v100 == "Terrorists" then
                    local v102 = LocalPlayer:GetAttribute("Slot5");
                    local v103;

                    if typeof(v102) == "string" then
                        local v104;
                        v104, v103 = pcall(HttpService.JSONDecode, HttpService, v102);

                        if not v104 or typeof(v103) ~= "table" then
                            v103 = nil;
                        end;
                    else
                        v103 = nil;
                    end;

                    local v105;

                    if v103 == nil then
                        v105 = false;
                    else
                        v105 = v103.Weapon == "C4";
                    end;

                    if v105 then
                        if not isInPlantZone() then
                            for i, v in pairs(v101) do
                                v95["Plant_" .. i] = {
                                    type = "Plant",
                                    target = v
                                };
                            end;

                            return v95;
                        end;

                        local v106 = LocalPlayer:GetAttribute("CurrentEquipped");
                        local v107;

                        if typeof(v106) == "string" then
                            local v108;
                            v108, v107 = pcall(HttpService.JSONDecode, HttpService, v106);

                            if not v108 or typeof(v107) ~= "table" then
                                v107 = nil;
                            end;
                        else
                            v107 = nil;
                        end;

                        local v109;

                        if v107 == nil then
                            v109 = false;
                        else
                            v109 = v107.Name == "C4";
                        end;

                        if v109 then
                            v95.PlantAction = {
                                type = "PlantAction",
                                target = nil
                            };

                            return v95;
                        end;

                        v95.EquipBomb = {
                            type = "EquipBomb",
                            target = nil
                        };

                        return v95;
                    end;

                    local v110 = teammateBombCarrier();
                    local v111 = v110 and v110.Character and v110.Character.PrimaryPart;

                    if v111 then
                        v95.HelpPlant = {
                            type = "HelpPlant",
                            target = v111
                        };

                        return v95;
                    end;
                elseif v100 == "Counter-Terrorists" then
                    for i, v in pairs(v101) do
                        v95["Defend_" .. i] = {
                            type = "Defend",
                            target = v
                        };
                    end;
                end;

                return v95;
            end;
        end;
    end;

    return v95;
end;

local function reconcileDefusal() -- Line: 444
    -- upvalues: reconcile (copy), computeDefusalDesired (copy), isDefusalManaged (copy)
    reconcile(computeDefusalDesired(), isDefusalManaged);
end;

task.spawn(function() -- Line: 448
    -- upvalues: reconcile (copy), computeDefusalDesired (copy), isDefusalManaged (copy)
    while true do
        reconcile(computeDefusalDesired(), isDefusalManaged);
        task.wait(0.25);
    end;
end);

local function isHostageManaged(p112) -- Line: 458
    return (p112 == "Return" or string.sub(p112, 1, 7) == "Rescue_") and true or string.sub(p112, 1, 14) == "DefendHostage_";
end;

local function closestHostageReturnPart() -- Line: 464
    -- upvalues: LocalPlayer (copy)
    local v113 = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Zones") and workspace.Map.Zones:FindFirstChild("Hints");
    local Character = LocalPlayer.Character;
    local v114;

    if Character then
        v114 = Character.PrimaryPart or (Character:FindFirstChild("HumanoidRootPart") or nil);
    else
        v114 = nil;
    end;

    if not (v113 and v114) then
        return nil;
    end;

    local v115 = (1 / 0);
    local v116 = nil;

    for _, child in ipairs(v113:GetChildren()) do
        if child:IsA("BasePart") then
            local Magnitude = (child.Position - v114.Position).Magnitude;

            if Magnitude < v115 then
                v116 = child;
                v115 = Magnitude;
            end;
        end;
    end;

    return v116;
end;

local function computeHostageDesired() -- Line: 478
    -- upvalues: u5 (ref), ConfigController (copy), GameState (copy), u6 (ref), DataController (copy), LocalPlayer (copy), closestHostageReturnPart (copy), CollectionService (copy)
    local v117 = {};
    local v118;

    if u5 == nil or u5 > 1 or not ConfigController.Get("IsNewOnboarding") then
        v118 = false;
    else
        local v119 = GameState.GetState();
        local v120 = u6;

        if v119 == "Buy Period" or v119 == "Warmup" then
            v120 = v120 + 1;
        end;

        v118 = v120 <= 1;
    end;

    if v118 and (GameState.GetState() == "Round In Progress" and workspace:GetAttribute("Gamemode") == "Hostage Rescue") then
        local success, result = pcall(DataController.Get, LocalPlayer, "Settings.Game.HUD.Enable Game Instructor Messages");

        if not success or result ~= false then
            local Character = LocalPlayer.Character;

            if Character then
                Character = Character:FindFirstChildOfClass("Humanoid");
            end;

            local v121;

            if Character == nil then
                v121 = false;
            else
                v121 = Character.Health > 0;
            end;

            if v121 then
                local v122 = LocalPlayer:GetAttribute("Team");

                if v122 == "Counter-Terrorists" then
                    if LocalPlayer:GetAttribute("IsCarryingHostage") ~= true then
                        for _, v in ipairs(CollectionService:GetTagged("Hostage")) do
                            if v:GetAttribute("CanRescue") and v.PrimaryPart then
                                v117["Rescue_" .. v.Name] = {
                                    type = "Rescue",
                                    target = v.PrimaryPart
                                };
                            end;
                        end;

                        return v117;
                    end;

                    local v123 = closestHostageReturnPart();

                    if v123 then
                        v117.Return = {
                            type = "Return",
                            target = v123
                        };

                        return v117;
                    end;
                elseif v122 == "Terrorists" then
                    for _, v in ipairs(CollectionService:GetTagged("Hostage")) do
                        if v:GetAttribute("CanRescue") and v.PrimaryPart then
                            v117["DefendHostage_" .. v.Name] = {
                                type = "DefendHostage",
                                target = v.PrimaryPart
                            };
                        end;
                    end;
                end;

                return v117;
            end;
        end;
    end;

    return v117;
end;

local function reconcileHostage() -- Line: 509
    -- upvalues: reconcile (copy), computeHostageDesired (copy), isHostageManaged (copy)
    reconcile(computeHostageDesired(), isHostageManaged);
end;

task.spawn(function() -- Line: 513
    -- upvalues: reconcile (copy), computeHostageDesired (copy), isHostageManaged (copy)
    while true do
        reconcile(computeHostageDesired(), isHostageManaged);
        task.wait(1);
    end;
end);

local function maybeClearBuyMenu() -- Line: 523
    -- upvalues: u2 (copy), u5 (ref), ConfigController (copy), GameState (copy), u6 (ref), u41 (ref), u4 (ref)
    if not u2.BuyMenu then
        return;
    end;

    local v124;

    if u5 == nil or u5 > 1 or not ConfigController.Get("IsNewOnboarding") then
        v124 = false;
    else
        local v125 = GameState.GetState();
        local v126 = u6;

        if v125 == "Buy Period" or v125 == "Warmup" then
            v126 = v126 + 1;
        end;

        v124 = v126 <= 1;
    end;

    if v124 then
        if u4 <= tick() then
            local v127 = GameState.GetState();

            if v127 ~= "Buy Period" and v127 ~= "Warmup" then
                u41("BuyMenu");
            end;
        end;

        return;
    end;

    u41("BuyMenu");
end;

local function tryShowBuyMenu() -- Line: 534
    -- upvalues: u5 (ref), ConfigController (copy), GameState (copy), u6 (ref), LocalPlayer (copy), Middle (copy), u4 (ref), u2 (copy), u42 (ref)
    local v128;

    if u5 == nil or u5 > 1 or not ConfigController.Get("IsNewOnboarding") then
        v128 = false;
    else
        local v129 = GameState.GetState();
        local v130 = u6;

        if v129 == "Buy Period" or v129 == "Warmup" then
            v130 = v130 + 1;
        end;

        v128 = v130 <= 1;
    end;

    if not v128 then
        return;
    end;

    local v131 = LocalPlayer:GetAttribute("Team");

    if v131 == "Terrorists" or v131 == "Counter-Terrorists" then
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        local v132;

        if Character == nil then
            v132 = false;
        else
            v132 = Character.Health > 0;
        end;

        if v132 then
            local BuyMenu = Middle:FindFirstChild("BuyMenu");

            if not (BuyMenu and BuyMenu:IsA("GuiObject")) then
                BuyMenu = nil;
            end;

            if BuyMenu and BuyMenu.Visible then
                return;
            end;

            u4 = tick() + 5;

            if not u2.BuyMenu then
                u42("BuyMenu", nil, nil, "BuyMenu", false);
            end;
        end;
    end;
end;

LocalPlayer.CharacterAdded:Connect(tryShowBuyMenu);
LocalPlayer:GetAttributeChangedSignal("Team"):Connect(tryShowBuyMenu);

if LocalPlayer.Character then
    task.spawn(tryShowBuyMenu);
end;

task.spawn(function() -- Line: 550
    -- upvalues: u2 (copy), u5 (ref), ConfigController (copy), GameState (copy), u6 (ref), u41 (ref), u4 (ref), Middle (copy)
    while true do
        if u2.BuyMenu then
            local v133;

            if u5 == nil or u5 > 1 or not ConfigController.Get("IsNewOnboarding") then
                v133 = false;
            else
                local v134 = GameState.GetState();
                local v135 = u6;

                if v134 == "Buy Period" or v134 == "Warmup" then
                    v135 = v135 + 1;
                end;

                v133 = v135 <= 1;
            end;

            if v133 then
                if u4 <= tick() then
                    local v136 = GameState.GetState();

                    if v136 ~= "Buy Period" and v136 ~= "Warmup" then
                        u41("BuyMenu");
                    end;
                end;
            else
                u41("BuyMenu");
            end;
        end;

        local BuyMenu = Middle:FindFirstChild("BuyMenu");

        if not (BuyMenu and BuyMenu:IsA("GuiObject")) then
            BuyMenu = nil;
        end;

        if BuyMenu and (BuyMenu.Visible and u2.BuyMenu) then
            local v137 = GameState.GetState();

            if v137 ~= "Buy Period" and v137 ~= "Warmup" then
                u41("BuyMenu");
            end;
        end;

        task.wait(0.5);
    end;
end);
Remotes.Hints.BombSiteEntered.Listen(function(p138) -- Line: 565
    -- upvalues: u5 (ref), ConfigController (copy), GameState (copy), u6 (ref), CollectionService (copy), u42 (ref)
    if p138 and p138.action == "Defuse" then
        local v139;

        if u5 == nil or u5 > 1 or not ConfigController.Get("IsNewOnboarding") then
            v139 = false;
        else
            local v140 = GameState.GetState();
            local v141 = u6;

            if v140 == "Buy Period" or v140 == "Warmup" then
                v141 = v141 + 1;
            end;

            v139 = v141 <= 1;
        end;

        if v139 then
            local v142 = CollectionService:GetTagged("Bomb");

            if #v142 ~= 1 then
                return;
            end;

            local PrimaryPart = v142[1].PrimaryPart;

            if PrimaryPart then
                u42("Defuse", PrimaryPart, nil, "Defuse", true);
            end;
        end;
    end;
end);
Remotes.Hints.ClearHint.Listen(function(p143) -- Line: 573
    -- upvalues: u41 (ref), u2 (copy)
    if p143 then
        p143 = p143.hintType;
    end;

    if p143 == nil or p143 == "" then
        u41();

        return;
    end;

    local v144 = {};

    for i, v in pairs(u2) do
        if i == p143 or v.hintType == p143 then
            table.insert(v144, i);
        end;
    end;

    for _, v in ipairs(v144) do
        u41(v);
    end;
end);

local function clearOnboardingHints() -- Line: 589
    -- upvalues: u2 (copy), u41 (ref)
    local v145 = {};

    for i in pairs(u2) do
        if i == "BuyMenu" or (i == "Defuse" or i == "Use") or (i == "HelpPlant" or (i == "PlantAction" or (i == "EquipBomb" or string.sub(i, 1, 6) == "Plant_")) or string.sub(i, 1, 7) == "Defend_" or (i == "Return" or string.sub(i, 1, 7) == "Rescue_" or string.sub(i, 1, 14) == "DefendHostage_")) then
            table.insert(v145, i);
        end;
    end;

    for _, v in ipairs(v145) do
        u41(v);
    end;
end;

Remotes.Character.CharacterDied.Listen(function() -- Line: 602
    -- upvalues: u41 (ref)
    u41();
end);
DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Enable Game Instructor Messages", function(p146) -- Line: 604
    -- upvalues: u41 (ref)
    if p146 == false then
        u41();
    end;
end);
ConfigController.OnChanged("IsNewOnboarding", function() -- Line: 608
    -- upvalues: clearOnboardingHints (copy), tryShowBuyMenu (copy), reconcileDefusal (copy), reconcileHostage (copy)
    clearOnboardingHints();
    task.spawn(tryShowBuyMenu);
    task.spawn(reconcileDefusal);
    task.spawn(reconcileHostage);
end);
u6 = GameState.GetState() == "Round In Progress" and 1 or u6;
GameState.ListenToState(function(p147, p148) -- Line: 623
    -- upvalues: u6 (ref), u2 (copy), u41 (ref), u5 (ref), ConfigController (copy), GameState (copy), u4 (ref), tryShowBuyMenu (copy), reconcileDefusal (copy), reconcileHostage (copy)
    if p148 == "Round In Progress" and (p147 ~= nil and p147 ~= "Round In Progress") then
        u6 = u6 + 1;
    end;

    if p148 ~= "Round In Progress" then
        local v149 = {};

        for i in pairs(u2) do
            if i ~= "BuyMenu" then
                table.insert(v149, i);
            end;
        end;

        for _, v in ipairs(v149) do
            u41(v);
        end;
    end;

    if u2.BuyMenu then
        local v150;

        if u5 == nil or u5 > 1 or not ConfigController.Get("IsNewOnboarding") then
            v150 = false;
        else
            local v151 = GameState.GetState();
            local v152 = u6;

            if v151 == "Buy Period" or v151 == "Warmup" then
                v152 = v152 + 1;
            end;

            v150 = v152 <= 1;
        end;

        if v150 then
            if u4 <= tick() then
                local v153 = GameState.GetState();

                if v153 ~= "Buy Period" and v153 ~= "Warmup" then
                    u41("BuyMenu");
                end;
            end;
        else
            u41("BuyMenu");
        end;
    end;

    if p148 ~= "Round In Progress" then
        if p148 == "Buy Period" or p148 == "Warmup" then
            task.spawn(tryShowBuyMenu);
        end;

        return;
    end;

    task.spawn(tryShowBuyMenu);
    task.spawn(reconcileDefusal);
    task.spawn(reconcileHostage);
end);
DataController.CreateListener(LocalPlayer, "Statistics.Joins", function(p154) -- Line: 649
    -- upvalues: u5 (ref), tryShowBuyMenu (copy), reconcileDefusal (copy), reconcileHostage (copy)
    u5 = typeof(p154) == "number" and p154 and p154 or nil;
    task.spawn(tryShowBuyMenu);
    task.spawn(reconcileDefusal);
    task.spawn(reconcileHostage);
end);
CollectionService:GetInstanceAddedSignal("Bomb"):Connect(function() -- Line: 657
    -- upvalues: reconcileDefusal (copy)
    task.spawn(reconcileDefusal);
end);
CollectionService:GetInstanceRemovedSignal("Bomb"):Connect(function() -- Line: 658
    -- upvalues: u41 (ref), reconcileDefusal (copy)
    u41("Defuse");
    u41("Use");
    task.spawn(reconcileDefusal);
end);
LocalPlayer:GetAttributeChangedSignal("Slot5"):Connect(function() -- Line: 666
    -- upvalues: reconcileDefusal (copy)
    task.spawn(reconcileDefusal);
end);
LocalPlayer:GetAttributeChangedSignal("CurrentEquipped"):Connect(function() -- Line: 667
    -- upvalues: reconcileDefusal (copy)
    task.spawn(reconcileDefusal);
end);
LocalPlayer:GetAttributeChangedSignal("IsCarryingHostage"):Connect(function() -- Line: 668
    -- upvalues: reconcileHostage (copy)
    task.spawn(reconcileHostage);
end);

return v1;