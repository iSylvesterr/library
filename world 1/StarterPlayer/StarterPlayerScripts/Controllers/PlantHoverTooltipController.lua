-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 10
};
local GuiService = game:GetService("GuiService");
local Players = game:GetService("Players");
local ProximityPromptService = game:GetService("ProximityPromptService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local Workspace = game:GetService("Workspace");
local SharedModules = ReplicatedStorage:WaitForChild("SharedModules");
local SeedData = require(SharedModules:WaitForChild("SeedData"));
local RarityVisuals = require(SharedModules:WaitForChild("RarityVisuals"));
local MutationData = require(SharedModules:WaitForChild("MutationData"));
local WeightFormat = require(SharedModules:WaitForChild("WeightFormat"));
local GrowthBoostSources = require(SharedModules:WaitForChild("GrowthBoostSources"));
local FruitIdentity = require(SharedModules:WaitForChild("FruitIdentity"));
local ScreenResolution = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("ScreenResolution"));
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local u2 = nil;
local u3 = nil;
local u4 = Color3.new(1, 1, 1);
local u5 = Color3.fromRGB(60, 220, 80);
local u6 = Color3.fromRGB(255, 255, 255);
local u7 = Color3.fromRGB(0, 0, 0);
local u8 = Vector2.new(220, 64);
local u9 = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
local Gardens = Workspace:WaitForChild("Gardens");
local Fruits = ReplicatedStorage:WaitForChild("PlantGenerationModules"):WaitForChild("Fruits");

local function isSingleHarvestPlant(p10) -- Line: 114
    -- upvalues: Fruits (copy), FruitIdentity (copy)
    local v11 = p10:GetAttribute("SeedName");

    if type(v11) == "string" then
        return Fruits:FindFirstChild(FruitIdentity.ResolveFruitName(v11)) == nil;
    end;

    return false;
end;

local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = {};
local u21 = nil;
local u22 = nil;
local u23 = nil;
local u24 = 0;
local u25 = false;
local u26 = 0;
local u27 = 0;
local u28 = 0;
local u29 = {};
local u30 = false;
local u31 = {};
local u32 = nil;
local u33 = 0;
local u34 = nil;
local u35 = nil;
local u36 = nil;
local u37 = nil;
local u38 = 0;
local u39 = 0;
local u40 = 0;
local u41 = 0;
local u42 = 0;
local u43 = 0;
local u44 = 0;
local u45 = 0;
local u46 = 0;

local function resetTimerBaseline() -- Line: 208
    -- upvalues: u37 (ref)
    u37 = nil;
end;

local u47 = nil;
local u48 = 0;
local u49 = 0;
local u50 = 0;
local u51 = 0;
local u52 = 0;
local u53 = 0;
local u54 = 0;

local function resetFruitTimerBaseline() -- Line: 227
    -- upvalues: u47 (ref), u54 (ref)
    u47 = nil;
    u54 = 0;
end;

local function getPointerLocation() -- Line: 239
    -- upvalues: u21 (ref), GuiService (copy), UserInputService (copy)
    local v55 = u21;

    if v55 then
        local v56 = GuiService:GetGuiInset();

        return Vector2.new(v55.Position.X + v56.X, v55.Position.Y + v56.Y);
    end;

    if UserInputService.MouseEnabled then
        return UserInputService:GetMouseLocation();
    end;

    return nil;
end;

local function formatGrowTime(p57) -- Line: 253
    if p57 <= 0 then
        return "";
    end;

    if p57 < 60 then
        if p57 == math.floor(p57) then
            return string.format("%ds", p57);
        end;

        return string.format("%.1fs", p57);
    end;

    local v58 = { { "y", 31104000 }, { "mo", 2592000 }, { "w", 604800 }, { "d", 86400 }, { "h", 3600 }, { "m", 60 }, { "s", 1 } };

    for i = 1, #v58 - 1 do
        local v59 = v58[i][1];
        local v60 = v58[i][2];

        if v60 <= p57 then
            local v61 = math.floor(p57 / v60);
            local v62 = v58[i + 1][1];
            local v63 = math.floor((p57 - v61 * v60) / v58[i + 1][2]);

            return string.format("%d%s %d%s", v61, v59, v63, v62);
        end;
    end;

    return string.format("%dm %ds", math.floor(p57 / 60), (math.floor(p57 % 60)));
end;

local u64 = {
    Fruits = true,
    FruitSpawnLocations = true
};

local function IsExcludedFromHeight(p65, p66) -- Line: 307
    -- upvalues: u64 (copy)
    local Parent = p65.Parent;

    while Parent and Parent ~= p66 do
        if u64[Parent.Name] then
            return true;
        end;

        Parent = Parent.Parent;
    end;

    return false;
end;

local function GetMeters(p67) -- Line: 322
    -- upvalues: u64 (copy)
    local v68 = p67:GetAttribute("Height");

    if v68 then
        return v68;
    end;

    local v69 = (-1 / 0);
    local v70 = (1 / 0);

    for _, v in p67:QueryDescendants("BasePart") do
        local Parent = v.Parent;
        local v71;

        while true do
            if not Parent or Parent == p67 then
                v71 = false;
                break;
            end;

            if u64[Parent.Name] then
                v71 = true;
                break;
            end;

            Parent = Parent.Parent;
        end;

        if not v71 then
            local Position = (v.CFrame * CFrame.new(0, v.Size.Y / 2, 0)).Position;

            if v69 < Position.Y then
                v69 = Position.Y;
            end;

            local Y = (v.CFrame * CFrame.new(0, -v.Size.Y / 2, 0)).Position.Y;

            if Y < v70 then
                v70 = Y;
            end;
        end;
    end;

    if v69 == (-1 / 0) then
        return nil;
    end;

    local v72 = math.round(v69 - v70);
    p67:SetAttribute("Height", v72);

    return v72;
end;

local function GetFruitRemaining(p73) -- Line: 358
    -- upvalues: u3 (ref), u54 (ref), u47 (ref), u52 (ref), u53 (ref), u48 (ref), u49 (ref), u50 (ref), u51 (ref)
    if not u3 then
        return nil;
    end;

    local v74 = tonumber(p73:GetAttribute("UserId"));
    local v75 = p73:GetAttribute("PlantId");
    local v76 = p73:GetAttribute("FruitId");

    if not v74 or (type(v75) ~= "string" or type(v76) ~= "string") then
        return nil;
    end;

    local v77 = u3:GetFruitGrowthData(v74, v75, v76);

    if type(v77) ~= "table" then
        return nil;
    end;

    local MaxAge = v77.MaxAge;
    local CurrentAge = v77.CurrentAge;
    local GrowthRate = v77.GrowthRate;
    u54 = type(v77.BoostSources) ~= "number" and 0 or v77.BoostSources;

    if type(MaxAge) ~= "number" or (type(CurrentAge) ~= "number" or type(GrowthRate) ~= "number") then
        return nil;
    end;

    if MaxAge <= CurrentAge or GrowthRate <= 0 then
        return nil;
    end;

    if u47 ~= p73 or (CurrentAge ~= u52 or GrowthRate ~= u53) then
        u47 = p73;
        u48 = CurrentAge;
        u49 = MaxAge;
        u50 = GrowthRate;
        u51 = os.clock();
        u52 = CurrentAge;
        u53 = GrowthRate;
    end;

    local v78 = u48 + (os.clock() - u51) * u50;
    local v79 = (u49 - math.min(v78, u49)) / u50;

    if v79 <= 0 then
        return nil;
    end;

    return v79;
end;

local function BoostIcons(p80, p81) -- Line: 417
    -- upvalues: u26 (ref), u25 (ref), GrowthBoostSources (copy)
    local v82 = "";

    if u26 > 0 then
        v82 = v82 .. "🌕";
    end;

    if u25 then
        v82 = v82 .. "🌧️";
    end;

    if bit32.band(p80, GrowthBoostSources.Swan) ~= 0 then
        v82 = v82 .. "🦢";
    elseif p81 then
        v82 = v82 .. "💦";
    end;

    if bit32.band(p80, GrowthBoostSources.Sprinkler) ~= 0 then
        v82 = v82 .. "🚿";
    end;

    if bit32.band(p80, GrowthBoostSources.Deer) ~= 0 then
        v82 = v82 .. "🦌";
    end;

    if bit32.band(p80, GrowthBoostSources.Butterfly) ~= 0 then
        v82 = v82 .. "🦋";
    end;

    return v82;
end;

local function TimerText(p83, p84, p85) -- Line: 437
    -- upvalues: BoostIcons (copy), formatGrowTime (copy)
    local v86 = BoostIcons(p84, p85);

    if v86 == "" then
        return `{formatGrowTime(p83)} ⌛`;
    end;

    return `{v86}⏩ {formatGrowTime(p83)} ⌛`;
end;

local function gatherPlantsFolders() -- Line: 445
    -- upvalues: Gardens (copy)
    local v87 = {};

    if not Gardens then
        return v87;
    end;

    for _, child in Gardens:GetChildren() do
        if child:IsA("Model") then
            local Plants = child:FindFirstChild("Plants");

            if Plants and Plants:IsA("Folder") then
                table.insert(v87, Plants);
            end;
        end;
    end;

    return v87;
end;

local function ensurePlotsResolved() -- Line: 458
    -- upvalues: u32 (ref), u33 (ref), gatherPlantsFolders (copy), u31 (ref)
    local v88 = os.clock();

    if u32 and v88 - u33 < 1 then
        return;
    end;

    u33 = v88;
    local v89 = gatherPlantsFolders();
    u31 = v89;
    local v90 = RaycastParams.new();
    v90.FilterType = Enum.RaycastFilterType.Include;
    v90.FilterDescendantsInstances = v89;
    u32 = v90;

    if #v89 == 0 then
        u33 = 0;
    end;
end;

local function findHovered() -- Line: 484
    -- upvalues: u32 (ref), Workspace (copy), u21 (ref), GuiService (copy), UserInputService (copy)
    local v91 = u32;

    if not v91 then
        return nil, nil;
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return nil, nil;
    end;

    local v92 = u21;
    local v93;

    if v92 then
        local v94 = GuiService:GetGuiInset();
        v93 = Vector2.new(v92.Position.X + v94.X, v92.Position.Y + v94.Y);
    elseif UserInputService.MouseEnabled then
        v93 = UserInputService:GetMouseLocation();
    else
        v93 = nil;
    end;

    if not v93 then
        return nil, nil;
    end;

    local v95 = CurrentCamera:ViewportPointToRay(v93.X, v93.Y);
    local Origin = v95.Origin;
    local v96 = 1000;
    local v97 = nil;

    while v96 > 0 do
        v97 = Workspace:Raycast(Origin, v95.Direction * v96, v91);

        if not v97 then
            return nil, nil;
        end;

        local Instance2 = v97.Instance;

        if Instance2 and (Instance2:IsA("BasePart") and Instance2.Transparency < 1) then
            break;
        end;

        local Position = v97.Position;

        if not Position then
            return nil, nil;
        end;

        local v98 = (Position - Origin).Magnitude + 0.01;
        Origin = Origin + v95.Direction * v98;
        v96 = v96 - v98;
        v97 = nil;
    end;

    if not v97 then
        return nil, nil;
    end;

    local Instance2 = v97.Instance;
    local v99 = nil;

    while Instance2 do
        local Parent = Instance2.Parent;

        if Instance2:IsA("Model") and (Parent and Parent:IsA("Folder")) then
            if Parent.Name == "Fruits" and not v99 then
                v99 = Instance2;
            elseif Parent.Name == "Plants" then
                return Instance2, v99;
            end;
        end;

        Instance2 = Parent;
    end;

    return nil, nil;
end;

local function refreshContent(p100) -- Line: 555
    -- upvalues: u14 (ref), u36 (ref), u20 (copy), MutationData (copy), u4 (copy), RarityVisuals (copy)
    if not u14 then
        return;
    end;

    if u36 then
        u36();
        u36 = nil;
    end;

    local v101 = p100:GetAttribute("SeedName");

    if type(v101) ~= "string" then
        v101 = nil;
    end;

    local v102;

    if v101 then
        v102 = u20[v101];
    else
        v102 = nil;
    end;

    local v103 = (not v102 or type(v102.Rarity) ~= "string") and "Common" or v102.Rarity;
    local v104 = p100:GetAttribute("Mutation");
    u14.Text = v101 or "?";
    local v105 = u14:FindFirstChildOfClass("UIGradient");

    if v105 then
        v105:Destroy();
    end;

    if type(v104) == "string" and v104 ~= "" then
        local v106 = MutationData.GetMutation(v104);

        if v106 and v106.Gradient then
            u14.TextColor3 = u4;
            v106.Gradient:Clone().Parent = u14;

            return;
        end;
    end;

    u36 = RarityVisuals.ApplyToLabels({ u14 }, v103);
end;

local function detachPlantListeners() -- Line: 602
    -- upvalues: u34 (ref), u35 (ref)
    if u34 then
        u34:Disconnect();
        u34 = nil;
    end;

    if u35 then
        u35:Disconnect();
        u35 = nil;
    end;
end;

local function attachPlantListeners(u107) -- Line: 607
    -- upvalues: u34 (ref), u35 (ref), u22 (ref), refreshContent (copy), u28 (ref)
    if u34 then
        u34:Disconnect();
        u34 = nil;
    end;

    if u35 then
        u35:Disconnect();
        u35 = nil;
    end;

    u34 = u107:GetAttributeChangedSignal("Mutation"):Connect(function() -- Line: 613
        -- upvalues: u22 (ref), u107 (copy), refreshContent (ref)
        if u22 == u107 then
            refreshContent(u107);
        end;
    end);
    u35 = u107.AncestryChanged:Connect(function(p108, p109) -- Line: 621
        -- upvalues: u22 (ref), u107 (copy), u28 (ref)
        if u22 == u107 and not p109 then
            u28 = 0;
        end;
    end);
end;

local function applyHoverState(p110) -- Line: 628
    -- upvalues: u22 (ref), u28 (ref), refreshContent (copy), attachPlantListeners (copy)
    if not p110 then
        if u22 then
            u28 = 0;
        end;

        return;
    end;

    if p110 == u22 then
        if u28 == 0 then
            u28 = 1;
        end;

        return;
    end;

    if u22 then
        u22 = p110;
        refreshContent(p110);
        attachPlantListeners(p110);

        return;
    end;

    u22 = p110;
    refreshContent(p110);
    attachPlantListeners(p110);
    u28 = 1;
end;

local function clearGradient() -- Line: 659
    -- upvalues: u14 (ref)
    local v111 = u14 and u14:FindFirstChildOfClass("UIGradient");

    if v111 then
        v111:Destroy();
    end;
end;

local function computeSuppression() -- Line: 666
    -- upvalues: u29 (copy), Workspace (copy), ScreenResolution (copy), u21 (ref), GuiService (copy), UserInputService (copy)
    if next(u29) == nil then
        return false;
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return false;
    end;

    local v112 = 150 * ScreenResolution.GetResolutionScale();
    local v113 = v112 * v112;
    local v114 = u21;
    local v115;

    if v114 then
        local v116 = GuiService:GetGuiInset();
        v115 = Vector2.new(v114.Position.X + v116.X, v114.Position.Y + v116.Y);
    elseif UserInputService.MouseEnabled then
        v115 = UserInputService:GetMouseLocation();
    else
        v115 = nil;
    end;

    if not v115 then
        return false;
    end;

    for i in u29 do
        local Parent = i.Parent;

        if Parent and Parent:IsA("BasePart") then
            local v117, v118 = CurrentCamera:WorldToViewportPoint(Parent.Position);

            if v118 then
                local v119 = v115.X - v117.X;
                local v120 = v115.Y - v117.Y;

                if v119 * v119 + v120 * v120 <= v113 then
                    return true;
                end;
            end;
        end;
    end;

    return false;
end;

local function onRenderStep(p121) -- Line: 702
    -- upvalues: u24 (ref), ensurePlotsResolved (copy), findHovered (copy), u23 (ref), applyHoverState (copy), u13 (ref), u14 (ref), u15 (ref), u16 (ref), u17 (ref), u18 (ref), u19 (ref), u30 (ref), computeSuppression (copy), u28 (ref), u27 (ref), u22 (ref), u34 (ref), u35 (ref), u36 (ref), u37 (ref), u47 (ref), u54 (ref), u2 (ref), GetFruitRemaining (copy), u26 (ref), u25 (ref), GrowthBoostSources (copy), formatGrowTime (copy), u3 (ref), WeightFormat (copy), u42 (ref), u43 (ref), u46 (ref), u38 (ref), u39 (ref), u40 (ref), u41 (ref), u44 (ref), u45 (ref), BoostIcons (copy), Fruits (copy), FruitIdentity (copy), GetMeters (copy), Workspace (copy), u21 (ref), GuiService (copy), UserInputService (copy), u8 (copy)
    u24 = u24 + p121;

    if u24 >= 0.1 then
        u24 = 0;
        ensurePlotsResolved();
        local v122, v123 = findHovered();

        if v122 then
            u23 = v123;
        end;

        applyHoverState(v122);
    end;

    if not (u13 and (u14 and (u15 and (u16 and (u17 and (u18 and u19)))))) then
        return;
    end;

    u30 = computeSuppression();
    local v124 = u30 and 0 or u28;
    local v125 = p121 / 0.1;

    if u27 < v124 then
        u27 = math.min(v124, u27 + v125);
    elseif v124 < u27 then
        u27 = math.max(v124, u27 - v125);
    end;

    local v126 = 1 - u27;
    u14.TextTransparency = v126;
    u15.Transparency = v126;
    u16.TextTransparency = v126;
    u17.Transparency = v126;
    u18.TextTransparency = v126;
    u19.Transparency = v126;
    u13.Visible = u27 > 0;

    if u27 ~= 0 or (u28 ~= 0 or not u22) then
        if u22 and u27 > 0 then
            local v127 = u22:GetAttribute("UserId");
            local v128 = u22:GetAttribute("PlantId");
            local v129;

            if u2 and (type(v127) == "number" and type(v128) == "string") then
                v129 = u2:GetPlantGrowthData(v127, v128);
            else
                v129 = nil;
            end;

            if u23 then
                local v130 = GetFruitRemaining(u23);

                if v130 then
                    local v131 = u54;
                    local v132 = "";

                    if u26 > 0 then
                        v132 = v132 .. "🌕";
                    end;

                    if u25 then
                        v132 = v132 .. "🌧️";
                    end;

                    if bit32.band(v131, GrowthBoostSources.Swan) ~= 0 then
                        v132 = v132 .. "🦢";
                    end;

                    if bit32.band(v131, GrowthBoostSources.Sprinkler) ~= 0 then
                        v132 = v132 .. "🚿";
                    end;

                    if bit32.band(v131, GrowthBoostSources.Deer) ~= 0 then
                        v132 = v132 .. "🦌";
                    end;

                    if bit32.band(v131, GrowthBoostSources.Butterfly) ~= 0 then
                        v132 = v132 .. "🦋";
                    end;

                    local v133;

                    if v132 == "" then
                        v133 = `{formatGrowTime(v130)} ⌛`;
                    else
                        v133 = `{v132}⏩ {formatGrowTime(v130)} ⌛`;
                    end;

                    u16.Text = v133;
                    u16.Visible = true;
                    u18.Text = "";
                    u18.Visible = false;
                else
                    u16.Text = "";
                    u16.Visible = false;
                    local v134 = u3:CalculateFruitWeight(u23);
                    u18.Text = not v134 and "⚖️ ?" or `⚖️ {WeightFormat.FormatGrams(v134)}`;
                    u18.Visible = true;
                    u47 = nil;
                    u54 = 0;
                end;

                u37 = nil;
            elseif v129 and (type(v129.MaxAge) == "number" and (type(v129.CurrentAge) == "number" and (type(v129.StableGrowthAmount) == "number" and (v129.StableGrowthAmount > 0 and v129.CurrentAge < v129.MaxAge)))) then
                local v135 = type(v129.BoostExpiresClock) ~= "number" and 0 or v129.BoostExpiresClock;
                local v136;

                if type(v129.PostBoostRate) == "number" then
                    v136 = v129.PostBoostRate;
                else
                    v136 = v129.StableGrowthAmount;
                end;

                if u37 ~= u22 or (v129.CurrentAge ~= u42 or (v129.StableGrowthAmount ~= u43 or v135 ~= u46)) then
                    u37 = u22;
                    u38 = v129.CurrentAge;
                    u39 = v129.MaxAge;
                    u40 = v129.StableGrowthAmount;
                    u41 = os.clock();
                    u44 = v136;
                    u45 = v135;
                    u42 = v129.CurrentAge;
                    u43 = v129.StableGrowthAmount;
                    u46 = v135;
                end;

                local v137 = os.clock();
                local v138;

                if v137 < u45 then
                    v138 = u40 > 0;
                else
                    v138 = false;
                end;

                local v139;

                if v138 or u45 == 0 then
                    v139 = u38 + (v137 - u41) * u40;
                else
                    local v140 = math.max(0, u45 - u41);
                    local v141 = v137 - math.max(u41, u45);
                    v139 = u38 + v140 * u40 + v141 * u44;
                end;

                local v142 = u39 - math.min(v139, u39);
                local v143;

                if v138 then
                    local v144 = u45 - v137;
                    local v145 = v144 * u40;

                    if v142 <= v145 then
                        v143 = v142 / u40;
                    elseif u44 > 0 then
                        v143 = v144 + (v142 - v145) / u44;
                    else
                        v143 = v142 / u40;
                    end;
                else
                    local v146;

                    if u44 > 0 then
                        v146 = u44;
                    else
                        v146 = u40;
                    end;

                    v143 = v142 / v146;
                end;

                local v147 = BoostIcons(type(v129.BoostSources) ~= "number" and 0 or v129.BoostSources, v138);
                local v148;

                if v147 == "" then
                    v148 = `{formatGrowTime(v143)} ⌛`;
                else
                    v148 = `{v147}⏩ {formatGrowTime(v143)} ⌛`;
                end;

                u16.Text = v148;
                u16.Visible = true;
                u18.Visible = false;
            else
                u16.Text = "";
                u16.Visible = false;
                local v149 = nil;
                local v150 = u22:GetAttribute("SeedName");
                local v151;

                if type(v150) == "string" then
                    v151 = Fruits:FindFirstChild(FruitIdentity.ResolveFruitName(v150)) == nil;
                else
                    v151 = false;
                end;

                if v151 then
                    local v152 = u3:CalculatePlantWeight(u22);

                    if type(v152) == "number" then
                        v149 = `⚖️ {WeightFormat.FormatGrams(v152)}`;
                    end;
                end;

                if not v149 then
                    local v153 = GetMeters(u22);
                    v149 = not v153 and "📏 10ft" or `📏 {math.round(v153)}ft`;
                end;

                u18.Text = v149;
                u18.Visible = true;
                u37 = nil;
                u47 = nil;
                u54 = 0;
            end;

            local CurrentCamera = Workspace.CurrentCamera;
            local v154 = u21;
            local v155;

            if v154 then
                local v156 = GuiService:GetGuiInset();
                v155 = Vector2.new(v154.Position.X + v156.X, v154.Position.Y + v156.Y);
            elseif UserInputService.MouseEnabled then
                v155 = UserInputService:GetMouseLocation();
            else
                v155 = nil;
            end;

            if CurrentCamera and v155 then
                local ViewportSize = CurrentCamera.ViewportSize;
                local v157 = math.min(u14.TextBounds.X, u8.X);
                local v158;

                if u16.Visible then
                    v158 = u16;
                else
                    v158 = u18;
                end;

                local v159 = math.min(v158.TextBounds.X, u8.X);
                local v160 = math.max(v157, v159);
                local v161 = v160 / 2;
                local v162 = u21 and 42 or 28;

                if v155.X + v162 + v160 <= ViewportSize.X then
                    u13.AnchorPoint = Vector2.new(0.5, 0.5);
                    u13.Position = UDim2.fromOffset(v155.X + v162 + v161, v155.Y);

                    return;
                end;

                u13.AnchorPoint = Vector2.new(0.5, 0.5);
                u13.Position = UDim2.fromOffset(v155.X - v162 - v161, v155.Y);
            end;
        end;

        return;
    end;

    u22 = nil;
    u23 = nil;

    if u34 then
        u34:Disconnect();
        u34 = nil;
    end;

    if u35 then
        u35:Disconnect();
        u35 = nil;
    end;

    if u36 then
        u36();
        u36 = nil;
    end;

    local v163 = u14 and u14:FindFirstChildOfClass("UIGradient");

    if v163 then
        v163:Destroy();
    end;

    u37 = nil;
    u47 = nil;
    u54 = 0;
    u16.Text = "";
    u18.Text = "";
end;

local function buildGui() -- Line: 973
    -- upvalues: PlayerGui (copy), u12 (ref), u8 (copy), u13 (ref), u9 (copy), u14 (ref), u7 (copy), u15 (ref), u5 (copy), u16 (ref), u17 (ref), u6 (copy), u18 (ref), u19 (ref)
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "PlantHoverTooltip";
    ScreenGui.DisplayOrder = -1;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    ScreenGui.Enabled = true;
    ScreenGui.Parent = PlayerGui;
    u12 = ScreenGui;
    local Frame = Instance.new("Frame");
    Frame.Name = "Frame";
    Frame.AnchorPoint = Vector2.new(0, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.Size = UDim2.fromOffset(u8.X, u8.Y);
    Frame.Position = UDim2.fromOffset(0, 0);
    Frame.Visible = false;
    Frame.Parent = ScreenGui;
    u13 = Frame;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.FillDirection = Enum.FillDirection.Vertical;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Padding = UDim.new(0, 2);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Name";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BorderSizePixel = 0;
    TextLabel.FontFace = u9;
    TextLabel.LayoutOrder = 1;
    TextLabel.Size = UDim2.new(1, 0, 0.55, 0);
    TextLabel.Text = "";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextSize = 24;
    TextLabel.TextTransparency = 1;
    TextLabel.TextWrapped = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Center;
    TextLabel.Parent = Frame;
    u14 = TextLabel;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
    UIStroke.Color = u7;
    UIStroke.LineJoinMode = Enum.LineJoinMode.Round;
    UIStroke.Thickness = 2;
    UIStroke.Transparency = 1;
    UIStroke.Parent = TextLabel;
    u15 = UIStroke;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Color = ColorSequence.new(u7);
    UIGradient.Parent = UIStroke;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Timer";
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.BorderSizePixel = 0;
    TextLabel2.FontFace = u9;
    TextLabel2.LayoutOrder = 2;
    TextLabel2.Size = UDim2.new(1, 0, 0.4, 0);
    TextLabel2.Text = "";
    TextLabel2.TextColor3 = u5;
    TextLabel2.TextScaled = true;
    TextLabel2.TextSize = 20;
    TextLabel2.TextTransparency = 1;
    TextLabel2.TextWrapped = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Center;
    TextLabel2.TextYAlignment = Enum.TextYAlignment.Center;
    TextLabel2.Parent = Frame;
    u16 = TextLabel2;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
    UIStroke2.Color = u7;
    UIStroke2.LineJoinMode = Enum.LineJoinMode.Round;
    UIStroke2.Thickness = 2;
    UIStroke2.Transparency = 1;
    UIStroke2.Parent = TextLabel2;
    u17 = UIStroke2;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Meters";
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.BorderSizePixel = 0;
    TextLabel3.FontFace = u9;
    TextLabel3.LayoutOrder = 2;
    TextLabel3.Size = UDim2.new(1, 0, 0.4, 0);
    TextLabel3.Text = "";
    TextLabel3.TextColor3 = u6;
    TextLabel3.TextScaled = true;
    TextLabel3.TextSize = 20;
    TextLabel3.TextTransparency = 1;
    TextLabel3.TextWrapped = true;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Center;
    TextLabel3.TextYAlignment = Enum.TextYAlignment.Center;
    TextLabel3.Visible = false;
    TextLabel3.Parent = Frame;
    u18 = TextLabel3;
    local UIStroke3 = Instance.new("UIStroke");
    UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
    UIStroke3.Color = u7;
    UIStroke3.LineJoinMode = Enum.LineJoinMode.Round;
    UIStroke3.Thickness = 2;
    UIStroke3.Transparency = 1;
    UIStroke3.Parent = TextLabel3;
    u19 = UIStroke3;
end;

function v1.Init(p164) -- Line: 1116
    -- upvalues: SeedData (copy), u20 (copy)
    for _, v in SeedData do
        if type(v) == "table" and type(v.SeedName) == "string" then
            u20[v.SeedName] = v;
        end;
    end;
end;

function v1.Start(p165) -- Line: 1127
    -- upvalues: u2 (ref), u3 (ref), buildGui (copy), ReplicatedStorage (copy), u25 (ref), Workspace (copy), u26 (ref), ProximityPromptService (copy), u29 (copy), UserInputService (copy), u21 (ref), RunService (copy), onRenderStep (copy)
    u2 = require(script.Parent.PlantVisualizerController);
    u3 = require(script.Parent.FruitVisualizerController);
    buildGui();
    task.spawn(function() -- Line: 1138
        -- upvalues: ReplicatedStorage (ref), u25 (ref)
        local WeatherValues = ReplicatedStorage:WaitForChild("WeatherValues", 30);

        if not WeatherValues then
            return;
        end;

        local function refreshRain() -- Line: 1141
            -- upvalues: u25 (ref), WeatherValues (copy)
            u25 = WeatherValues:GetAttribute("Rain_Playing") == true;
        end;

        u25 = WeatherValues:GetAttribute("Rain_Playing") == true;
        WeatherValues:GetAttributeChangedSignal("Rain_Playing"):Connect(refreshRain);
    end);

    local function refreshHarvestMoon() -- Line: 1151
        -- upvalues: Workspace (ref), u26 (ref)
        local v166 = Workspace:GetAttribute("HarvestMoonGrowthBoost");
        u26 = type(v166) ~= "number" and 0 or v166;
    end;

    local v167 = Workspace:GetAttribute("HarvestMoonGrowthBoost");
    u26 = type(v167) ~= "number" and 0 or v167;
    Workspace:GetAttributeChangedSignal("HarvestMoonGrowthBoost"):Connect(refreshHarvestMoon);
    ProximityPromptService.PromptShown:Connect(function(p168) -- Line: 1163
        -- upvalues: u29 (ref)
        if p168:HasTag("HarvestPrompt") then
            u29[p168] = true;
        end;
    end);
    ProximityPromptService.PromptHidden:Connect(function(p169) -- Line: 1168
        -- upvalues: u29 (ref)
        if p169:HasTag("HarvestPrompt") then
            u29[p169] = nil;
        end;
    end);
    UserInputService.TouchStarted:Connect(function(p170, p171) -- Line: 1178
        -- upvalues: u21 (ref)
        if p171 then
            return;
        end;

        if u21 == nil then
            u21 = p170;
        end;
    end);
    UserInputService.TouchEnded:Connect(function(p172) -- Line: 1184
        -- upvalues: u21 (ref)
        if p172 == u21 then
            u21 = nil;
        end;
    end);
    RunService:BindToRenderStep("PlantHoverTooltip", Enum.RenderPriority.Camera.Value - 1, onRenderStep);
end;

return v1;