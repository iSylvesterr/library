-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local ServerClock = require(ReplicatedStorage.ClientModules.ServerClock);
local PetData = require(ReplicatedStorage.SharedData.PetData);
local PetSizes = require(ReplicatedStorage.SharedData.PetSizes);
local PetTypes = require(ReplicatedStorage.SharedData.PetTypes);
local AnimatedGradient = require(ReplicatedStorage.SharedModules.AnimatedGradient);
local GuildContestFlags = require(ReplicatedStorage.SharedModules.Flags.GuildContestFlags);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local GuiController = require(LocalPlayer.PlayerScripts.Controllers.GuiController);
local MailboxItemCatalog = require(LocalPlayer.PlayerScripts.Controllers.MailboxController.MailboxItemCatalog);
local v1 = {
    StartOrder = 9
};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = {};
local u15 = nil;
local u16 = false;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = Color3.fromRGB(39, 20, 11);
local u22 = "ViewGuildPage";

local function abbreviateNumber(p23) -- Line: 84
    if p23 < 1000 then
        return tostring(p23);
    end;

    local v24 = string.format("%.1f", p23 / 1000);

    if v24:sub(-2) == ".0" then
        return v24:sub(1, -3) .. "K";
    end;

    return v24 .. "K";
end;

local function parseRange(p25) -- Line: 98
    -- upvalues: abbreviateNumber (copy)
    local v26 = tonumber(p25);

    if v26 then
        return v26, v26, "#" .. abbreviateNumber(v26);
    end;

    local v27, v28 = string.match(p25, "^(%d+)%-(%d+)$");

    if v27 and v28 then
        return tonumber(v27), tonumber(v28), "#" .. abbreviateNumber((tonumber(v27))) .. "-" .. abbreviateNumber((tonumber(v28)));
    end;

    local v29 = string.match(p25, "^(%d+)%-$");

    if v29 then
        return tonumber(v29), (1 / 0), "#" .. abbreviateNumber((tonumber(v29))) .. "+";
    end;

    return (1 / 0), (1 / 0), p25;
end;

local function resolvePetReward(p30) -- Line: 113
    -- upvalues: PetSizes (copy), PetTypes (copy), PetData (copy)
    local item = p30.item;

    if typeof(item) ~= "string" or item == "" then
        return "", "";
    end;

    local v31 = PetSizes.Normalize(p30.size);
    local v32;

    if PetTypes.IsValid(p30.type) then
        v32 = p30.type;
    else
        v32 = nil;
    end;

    local v33 = {};

    if v31 then
        local v34 = PetSizes.DisplaySize(v31) or v31;
        table.insert(v33, v34);
    end;

    if v32 then
        table.insert(v33, v32);
    end;

    table.insert(v33, PetData.GetSpeciesDisplayName(item));

    return table.concat(v33, " "), PetData.GetImage(item, v31);
end;

local function formatRewardName(p35) -- Line: 129
    -- upvalues: resolvePetReward (copy), MailboxItemCatalog (copy)
    if typeof(p35) ~= "table" then
        return nil;
    end;

    if typeof(p35.display) == "string" and p35.display ~= "" then
        return p35.display;
    end;

    local item = p35.item;

    if typeof(item) ~= "string" or item == "" then
        return nil;
    end;

    local v36 = tonumber(p35.count) or 1;

    if p35.category == "Pets" then
        local v37 = resolvePetReward(p35);

        if v37 ~= "" then
            return string.format("%dx %s", v36, v37);
        end;
    end;

    local v38 = typeof(p35.category) ~= "string" and "" or p35.category;
    local success, result = pcall(MailboxItemCatalog.Resolve, v38, item, p35);

    if success and typeof(result) == "string" then
        if result == "" then
            result = item;
        end;
    else
        result = item;
    end;

    return string.format("%dx %s", v36, result);
end;

local function rewardBareName(p39) -- Line: 151
    -- upvalues: resolvePetReward (copy), MailboxItemCatalog (copy)
    if typeof(p39) ~= "table" then
        return "";
    end;

    if typeof(p39.display) == "string" and p39.display ~= "" then
        return p39.display;
    end;

    local item = p39.item;

    if typeof(item) ~= "string" or item == "" then
        return "";
    end;

    if p39.category == "Pets" then
        local v40 = resolvePetReward(p39);

        if v40 ~= "" then
            return v40;
        end;
    end;

    local v41 = typeof(p39.category) ~= "string" and "" or p39.category;
    local success, result = pcall(MailboxItemCatalog.Resolve, v41, item, p39);

    if success and (typeof(result) == "string" and result ~= "") then
        return result;
    end;

    return item;
end;

local function resolveRewardIcon(p42) -- Line: 168
    -- upvalues: resolvePetReward (copy), MailboxItemCatalog (copy)
    if typeof(p42) ~= "table" then
        return "";
    end;

    local item = p42.item;

    if typeof(item) ~= "string" or item == "" then
        return "";
    end;

    if p42.category == "Pets" then
        local _, v43 = resolvePetReward(p42);

        return v43;
    end;

    local v44 = typeof(p42.category) ~= "string" and "" or p42.category;
    local v45, _, v46 = pcall(MailboxItemCatalog.Resolve, v44, item, p42);

    return (not v45 or typeof(v46) ~= "string") and "" or v46;
end;

local function validEntries(p47) -- Line: 185
    -- upvalues: formatRewardName (copy)
    local v48 = {};

    if typeof(p47) ~= "table" then
        return v48;
    end;

    for _, v in p47 do
        if formatRewardName(v) then
            table.insert(v48, v);
        end;
    end;

    return v48;
end;

local function setChain(p49, p50) -- Line: 194
    if not p49 then
        return;
    end;

    p49.Text = p50;
    local TextLabel = p49:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.Text = p50;
    end;
end;

local function setInfo(p51, p52) -- Line: 205
    -- upvalues: u6 (ref), u7 (ref)
    if u6 then
        if p51 and p51 ~= "" then
            local v53 = u6;

            if v53 then
                v53.Text = p51;
                local TextLabel = v53:FindFirstChild("TextLabel");

                if TextLabel and TextLabel:IsA("TextLabel") then
                    TextLabel.Text = p51;
                end;
            end;

            u6.Visible = true;
        else
            u6.Visible = false;
        end;
    end;

    local v54 = u7;

    if not v54 then
        return;
    end;

    v54.Text = p52;
    local TextLabel = v54:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.Text = p52;
    end;
end;

local function isRainbowPet(p55) -- Line: 218
    -- upvalues: PetTypes (copy)
    local v56;

    if typeof(p55) == "table" and p55.category == "Pets" then
        v56 = p55.type == PetTypes.Rainbow;
    else
        v56 = false;
    end;

    return v56;
end;

local function imageOf(p57) -- Line: 224
    local Image = p57:FindFirstChild("Image");

    if Image and Image:IsA("ImageLabel") then
        return Image;
    end;

    return nil;
end;

local function getRewardDisplay(p58) -- Line: 233
    local RewardDisplay = p58:FindFirstChild("RewardDisplay");

    if RewardDisplay and RewardDisplay:IsA("GuiObject") then
        return RewardDisplay;
    end;

    return nil;
end;

local function makePlaceholderLabel(p59) -- Line: 243
    local Placeholder = p59:FindFirstChild("Placeholder");

    if Placeholder and Placeholder:IsA("TextLabel") then
        return Placeholder;
    end;

    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Placeholder";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(0.7, 0.7);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = "???";
    TextLabel.TextScaled = true;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Bold);
    TextLabel.ZIndex = 5;
    TextLabel.Visible = false;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Thickness = 2;
    UIStroke.Color = Color3.new(0, 0, 0);
    UIStroke.Parent = TextLabel;
    TextLabel.Parent = p59;

    return TextLabel;
end;

local function makeCountBadge(p60) -- Line: 271
    local Count = p60:FindFirstChild("Count");

    if Count and Count:IsA("TextLabel") then
        return Count;
    end;

    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Count";
    TextLabel.AnchorPoint = Vector2.new(1, 1);
    TextLabel.Position = UDim2.fromScale(1, 1);
    TextLabel.Size = UDim2.fromScale(0.72, 0.46);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = "";
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Bold);
    TextLabel.ZIndex = 6;
    TextLabel.Visible = false;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Thickness = 2;
    UIStroke.Color = Color3.new(0, 0, 0);
    UIStroke.Parent = TextLabel;
    TextLabel.Parent = p60;

    return TextLabel;
end;

local function getOrCreateStrip(p61) -- Line: 303
    local RewardStrip = p61:FindFirstChild("RewardStrip");

    if RewardStrip and RewardStrip:IsA("Frame") then
        return RewardStrip;
    end;

    local Frame = Instance.new("Frame");
    Frame.Name = "RewardStrip";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(0.8, 0.83);
    Frame.BackgroundTransparency = 1;
    Frame.ZIndex = 3;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Padding = UDim.new(0, 4);
    UIListLayout.Parent = Frame;
    Frame.Parent = p61;

    return Frame;
end;

local function clearStrip(p62) -- Line: 329
    -- upvalues: AnimatedGradient (copy)
    local RewardStrip = p62:FindFirstChild("RewardStrip");

    if not RewardStrip then
        return;
    end;

    for _, child in RewardStrip:GetChildren() do
        if child:IsA("GuiObject") and child.Name == "Icon" then
            local Image = child:FindFirstChild("Image");

            if not (Image and Image:IsA("ImageLabel")) then
                Image = nil;
            end;

            if Image then
                AnimatedGradient:Remove(Image);
            end;

            child:Destroy();
        end;
    end;
end;

local function makeIcon(p63, p64, p65, p66) -- Line: 345
    -- upvalues: resolveRewardIcon (copy), u21 (ref), makePlaceholderLabel (copy), AnimatedGradient (copy), PetTypes (copy), makeCountBadge (copy), MailboxItemCatalog (copy), rewardBareName (copy)
    local v67 = p64:Clone();
    v67.Name = "Icon";
    v67.Visible = true;
    v67.AnchorPoint = Vector2.new(0, 0);
    v67.Position = UDim2.new();
    v67.Size = UDim2.fromScale(1, 1);
    v67.LayoutOrder = p66;
    local v68 = v67:FindFirstChildOfClass("UIAspectRatioConstraint");

    if v68 and v68:IsA("UIAspectRatioConstraint") then
        v68.AspectRatio = 1;
        v68.AspectType = Enum.AspectType.FitWithinMaxSize;
        v68.DominantAxis = Enum.DominantAxis.Height;
    end;

    local v69 = resolveRewardIcon(p65);
    local v70;

    if typeof(p65) == "table" and typeof(p65.item) == "string" then
        v70 = p65.item ~= "";
    else
        v70 = false;
    end;

    local v71;

    if v70 then
        v71 = v69 == "";
    else
        v71 = v70;
    end;

    local v72;

    if v71 then
        v72 = Color3.new(0, 0, 0);
    else
        v72 = u21;
    end;

    v67.BackgroundColor3 = v72;
    local v73 = makePlaceholderLabel(v67);

    if v73 then
        v73.Visible = v71;
    end;

    local Image = v67:FindFirstChild("Image");

    if not (Image and Image:IsA("ImageLabel")) then
        Image = nil;
    end;

    if Image then
        AnimatedGradient:Remove(Image);

        if v71 then
            Image.Image = "";
        else
            Image.Image = v69;
            local v74;

            if typeof(p65) == "table" and p65.category == "Pets" then
                v74 = p65.type == PetTypes.Rainbow;
            else
                v74 = false;
            end;

            if v74 then
                AnimatedGradient:AddRainbowColor(Image, "ImageColor3");
            end;
        end;
    end;

    local v75 = tonumber(p65.count) or 1;
    local v76 = math.floor(v75);
    local v77 = makeCountBadge(v67);

    if v77 then
        v77.Text = "x" .. tostring(v76);
        v77.Visible = v76 > 1;
    end;

    local v78 = (typeof(p65) ~= "table" or typeof(p65.category) ~= "string") and "" or p65.category;
    local v79 = "";
    local v80;

    if v70 then
        local v81;
        v81, v80 = pcall(MailboxItemCatalog.ResolveRarity, v78, p65.item);

        if v81 then
            if typeof(v80) ~= "string" then
                v80 = v79;
            end;
        else
            v80 = v79;
        end;
    else
        v80 = v79;
    end;

    v67:SetAttribute("ItemToolTip", (rewardBareName(p65)));
    v67:SetAttribute("ItemToolTipImage", v69);
    v67:SetAttribute("ItemToolTipRarity", v80);
    v67:SetAttribute("ItemToolTipSubtitle", v76 <= 1 and "" or "x" .. tostring(v76));
    v67.Parent = p63;
end;

local function applyBracket(p82, p83, p84) -- Line: 422
    -- upvalues: getOrCreateStrip (copy), clearStrip (copy), makeIcon (copy)
    local Place = p82:FindFirstChild("Place");

    if Place and (Place:IsA("TextLabel") and Place) then
        Place.Text = p83;
        local TextLabel = Place:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.Text = p83;
        end;
    end;

    local RewardName = p82:FindFirstChild("RewardName");

    if RewardName and RewardName:IsA("TextLabel") then
        RewardName.Visible = false;
    end;

    local RewardDisplay = p82:FindFirstChild("RewardDisplay");

    if not (RewardDisplay and RewardDisplay:IsA("GuiObject")) then
        RewardDisplay = nil;
    end;

    if RewardDisplay then
        RewardDisplay.Visible = false;
    end;

    local v85 = getOrCreateStrip(p82);
    clearStrip(p82);

    if v85 and RewardDisplay then
        local v86 = 0;

        for _, v in p84 do
            v86 = v86 + 1;

            if v86 > 6 then
                break;
            end;

            makeIcon(v85, RewardDisplay, v, v86);
        end;
    end;

    p82.Visible = true;
end;

local function hideButton(p87) -- Line: 449
    -- upvalues: clearStrip (copy)
    if not p87 then
        return;
    end;

    clearStrip(p87);
    p87.Visible = false;
end;

local function clearClones() -- Line: 455
    -- upvalues: u14 (copy)
    for _, v in u14 do
        v:Destroy();
    end;

    table.clear(u14);
end;

local function sortedRangeKeys(p88) -- Line: 463
    -- upvalues: parseRange (copy)
    local v89 = {};

    for i in p88 do
        if typeof(i) == "string" then
            table.insert(v89, i);
        end;
    end;

    table.sort(v89, function(p90, p91) -- Line: 468
        -- upvalues: parseRange (ref)
        local v92, v93 = parseRange(p90);
        local v94, v95 = parseRange(p91);

        if v92 ~= v94 then
            return v92 < v94;
        end;

        if v93 == v95 then
            return p90 < p91;
        end;

        return v93 < v95;
    end);

    return v89;
end;

local function renderRewards(p96) -- Line: 478
    -- upvalues: u14 (copy), u10 (ref), clearStrip (copy), u11 (ref), u12 (ref), u13 (ref), u8 (ref), sortedRangeKeys (copy), validEntries (copy), parseRange (copy), applyBracket (copy)
    for _, v in u14 do
        v:Destroy();
    end;

    table.clear(u14);
    local v97 = u10;

    if v97 then
        clearStrip(v97);
        v97.Visible = false;
    end;

    local v98 = u11;

    if v98 then
        clearStrip(v98);
        v98.Visible = false;
    end;

    local v99 = u12;

    if v99 then
        clearStrip(v99);
        v99.Visible = false;
    end;

    if u13 then
        u13.Visible = false;
    end;

    if not u8 or typeof(p96) ~= "table" then
        return;
    end;

    local v100 = 0;

    for _, v in sortedRangeKeys(p96) do
        local v101 = validEntries(p96[v]);

        if #v101 ~= 0 then
            v100 = v100 + 1;
            local _, _, v102 = parseRange(v);

            if v100 == 1 and u10 then
                u10.LayoutOrder = 1;
                applyBracket(u10, v102, v101);
            elseif v100 == 2 and u11 then
                u11.LayoutOrder = 2;
                applyBracket(u11, v102, v101);
            elseif v100 == 3 and u12 then
                u12.LayoutOrder = 3;
                applyBracket(u12, v102, v101);
            elseif v100 >= 4 and u13 then
                local v103 = u13:Clone();
                v103.Name = "RewardClone" .. tostring(v100);
                v103.LayoutOrder = v100;
                v103.Parent = u8;
                table.insert(u14, v103);
                applyBracket(v103, v102, v101);
            end;
        end;
    end;
end;

local u104 = {};

local function clearLocalSection() -- Line: 525
    -- upvalues: u104 (copy), clearStrip (copy)
    for _, v in u104 do
        if v:IsA("ImageButton") then
            clearStrip(v);
        end;

        v:Destroy();
    end;

    table.clear(u104);
end;

local function addSectionTitle(p105, p106, p107) -- Line: 537
    -- upvalues: u9 (ref), u8 (ref), u104 (copy)
    local v108;

    if u9 then
        v108 = u9:Clone();
    else
        v108 = Instance.new("TextLabel");
        v108.BackgroundTransparency = 1;
        v108.TextScaled = true;
        v108.TextColor3 = Color3.new(1, 1, 1);
    end;

    v108.Name = p105;
    v108.Size = UDim2.new(0.98, 0, 0.12, 0);
    v108.Visible = true;
    v108.LayoutOrder = p107;

    if v108 then
        v108.Text = p106;
        local TextLabel = v108:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.Text = p106;
        end;
    end;

    v108.Parent = u8;
    table.insert(u104, v108);
end;

local function renderLocalTable(p109, p110, p111) -- Line: 558
    -- upvalues: sortedRangeKeys (copy), validEntries (copy), parseRange (copy), u13 (ref), u8 (ref), u104 (copy), applyBracket (copy)
    if typeof(p109) ~= "table" then
        return 0;
    end;

    local v112 = 0;

    for _, v in sortedRangeKeys(p109) do
        local v113 = validEntries(p109[v]);

        if #v113 ~= 0 then
            v112 = v112 + 1;
            local _, _, v114 = parseRange(v);
            local v115 = u13:Clone();
            v115.Name = p110 .. tostring(v112);
            v115.LayoutOrder = p111 + v112;
            v115.Parent = u8;
            table.insert(u104, v115);
            applyBracket(v115, v114, v113);
        end;
    end;

    return v112;
end;

local function renderLocalRewards(p116, p117) -- Line: 578
    -- upvalues: clearLocalSection (copy), GuildContestFlags (copy), u8 (ref), u13 (ref), renderLocalTable (copy), addSectionTitle (copy)
    clearLocalSection();

    if not GuildContestFlags.LocalContestsEnabled:Get() then
        return;
    end;

    if not (u8 and u13) then
        return;
    end;

    local v118;

    if typeof(p116) == "table" then
        v118 = p116["local"];
    else
        v118 = nil;
    end;

    if typeof(v118) ~= "table" or v118.enabled == false then
        return;
    end;

    local v119 = 0;
    local bands = v118.bands;

    if typeof(bands) == "table" and #bands > 0 then
        local v120 = nil;

        if typeof(p117) == "string" and p117 ~= "" then
            for _, v in bands do
                if typeof(v) == "table" and v.name == p117 then
                    v120 = v;
                    break;
                end;
            end;
        end;

        if v120 then
            v119 = renderLocalTable(v120.rewards, "LocalRewardClone", 100);

            if v119 > 0 then
                addSectionTitle("LocalRewardsTitle", `{v120.name} Bracket Rewards`, 100);
            end;
        else
            local v121 = 100;

            for i, v in bands do
                if typeof(v) == "table" and typeof(v.name) == "string" then
                    local v122 = renderLocalTable(v.rewards, `LocalRewardClone_B{i}_`, v121);

                    if v122 > 0 then
                        addSectionTitle(`LocalRewardsTitle_B{i}`, `{v.name} Bracket Rewards`, v121);
                        v121 = v121 + (v122 + 1);
                        v119 = v119 + v122;
                    end;
                end;
            end;
        end;
    else
        v119 = renderLocalTable(v118.rewards, "LocalRewardClone", 100);

        if v119 > 0 then
            addSectionTitle("LocalRewardsTitle", "Local Bracket Rewards", 100);
        end;
    end;

    if v119 == 0 then
        return;
    end;

    addSectionTitle("GlobalRewardsTitle", "Global Rewards", 0);
end;

local function formatHeaderCountdown(p123, p124) -- Line: 635
    local v125 = p124 and "Ends in" or "Starts in";
    local v126 = math.floor((p123 < 0 and 0 or p123) + 0.5);

    if v126 < 3600 then
        local v127 = v126 // 60;

        return string.format("%s %dm %ds", v125, v127, v126 - v127 * 60);
    end;

    if v126 < 86400 then
        local v128 = v126 // 3600;

        return string.format("%s %dh %dm", v125, v128, (v126 - v128 * 3600) // 60);
    end;

    local v129 = v126 // 86400;

    return string.format("%s %dd %dh", v125, v129, (v126 - v129 * 86400) // 3600);
end;

local function refreshHeaderTimer() -- Line: 655
    -- upvalues: u17 (ref), u18 (ref), u4 (ref), ServerClock (copy), u5 (ref), formatHeaderCountdown (copy)
    local v130 = u17;
    local v131;

    if v130 then
        v131 = true;
    else
        v130 = u18;
        v131 = false;
    end;

    if not v130 then
        if u4 then
            u4.Visible = false;
        end;

        return false;
    end;

    local v132 = v130 - ServerClock.Now();

    if v132 <= 0 then
        return true;
    end;

    if u5 then
        u5.Text = formatHeaderCountdown(v132, v131);
    end;

    if u4 then
        u4.Visible = true;
    end;

    return false;
end;

local function stopTimerLoop() -- Line: 679
    -- upvalues: u19 (ref)
    if u19 then
        task.cancel(u19);
        u19 = nil;
    end;
end;

local function startTimerLoop() -- Line: 689
    -- upvalues: u19 (ref), u16 (ref), u17 (ref), u18 (ref), u4 (ref), ServerClock (copy), u5 (ref), formatHeaderCountdown (copy), u20 (ref)
    if u19 then
        return;
    end;

    u19 = task.spawn(function() -- Line: 691
        -- upvalues: u16 (ref), u17 (ref), u18 (ref), u4 (ref), ServerClock (ref), u5 (ref), formatHeaderCountdown (ref), u19 (ref), u20 (ref)
        while u16 and (u17 or u18) do
            local v133 = u17;
            local v134;

            if v133 then
                v134 = true;
            else
                v133 = u18;
                v134 = false;
            end;

            local v135;

            if v133 then
                local v136 = v133 - ServerClock.Now();

                if v136 <= 0 then
                    v135 = true;
                else
                    if u5 then
                        u5.Text = formatHeaderCountdown(v136, v134);
                    end;

                    if u4 then
                        u4.Visible = true;
                        v135 = false;
                    else
                        v135 = false;
                    end;
                end;
            elseif u4 then
                u4.Visible = false;
                v135 = false;
            else
                v135 = false;
            end;

            if v135 then
                u19 = nil;
                u20();

                return;
            end;

            task.wait(1);
        end;

        u19 = nil;
    end);
end;

local function renderBetween(p137) -- Line: 710
    -- upvalues: u3 (ref), u9 (ref), renderRewards (copy), renderLocalRewards (copy), u18 (ref), u17 (ref), u6 (ref), u7 (ref), u4 (ref), ServerClock (copy), u5 (ref), formatHeaderCountdown (copy), u19 (ref), u16 (ref), u20 (ref)
    local lastConfig = p137.lastConfig;
    local v138 = typeof(lastConfig) == "table";
    local phase = p137.phase;

    if v138 and (typeof(lastConfig.displayName) == "string" and lastConfig.displayName ~= "") then
        local v139 = u3;
        local displayName = lastConfig.displayName;

        if v139 then
            v139.Text = displayName;
            local TextLabel = v139:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.Text = displayName;
            end;
        end;
    elseif phase == "pending" then
        local v140 = u3;

        if v140 then
            v140.Text = "Competition Starting Soon";
            local TextLabel = v140:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.Text = "Competition Starting Soon";
            end;
        end;
    else
        local v141 = u3;

        if v141 then
            v141.Text = "No Active Competition";
            local TextLabel = v141:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.Text = "No Active Competition";
            end;
        end;
    end;

    if u9 then
        u9.Visible = v138;
        local v142 = v138 and u9;

        if v142 then
            v142.Text = "Last Week\'s Rewards";
            local TextLabel = v142:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.Text = "Last Week\'s Rewards";
            end;
        end;
    end;

    local v143;

    if v138 then
        v143 = lastConfig.rewards;
    else
        v143 = nil;
    end;

    renderRewards(v143);

    if not v138 then
        lastConfig = nil;
    end;

    renderLocalRewards(lastConfig, nil);

    if phase ~= "pending" or typeof(p137.startsAt) ~= "number" then
        u18 = nil;
        u17 = nil;

        if u19 then
            task.cancel(u19);
            u19 = nil;
        end;

        if u4 then
            u4.Visible = false;
        end;

        local v144, v145;

        if v138 then
            v144 = "No upcoming competition... yet!";
            v145 = "Last week\'s competition has ended - check back soon for the next one.";
        else
            v144 = "No competition running... yet!";
            v145 = "Check back soon for the next guild competition!";
        end;

        if u6 then
            if v144 and v144 ~= "" then
                local v146 = u6;

                if v146 then
                    v146.Text = v144;
                    local TextLabel = v146:FindFirstChild("TextLabel");

                    if TextLabel and TextLabel:IsA("TextLabel") then
                        TextLabel.Text = v144;
                    end;
                end;

                u6.Visible = true;
            else
                u6.Visible = false;
            end;
        end;

        local v147 = u7;

        if not v147 then
            return;
        end;

        v147.Text = v145;
        local TextLabel = v147:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.Text = v145;
        end;

        return;
    end;

    u18 = p137.startsAt;
    u17 = nil;
    local v148 = v138 and "Next competition starting soon!" or "New competition starting soon!";
    local v149 = v138 and "Last week\'s competition has ended! The next one starts soon -- here\'s what was up for grabs:" or "A new guild competition is about to begin!";

    if u6 then
        if v148 and v148 ~= "" then
            local v150 = u6;

            if v150 then
                v150.Text = v148;
                local TextLabel = v150:FindFirstChild("TextLabel");

                if TextLabel and TextLabel:IsA("TextLabel") then
                    TextLabel.Text = v148;
                end;
            end;

            u6.Visible = true;
        else
            u6.Visible = false;
        end;
    end;

    local v151 = u7;

    if v151 then
        v151.Text = v149;
        local TextLabel = v151:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.Text = v149;
        end;
    end;

    local v152 = u17;
    local v153;

    if v152 then
        v153 = true;
    else
        v152 = u18;
        v153 = false;
    end;

    if v152 then
        local v154 = v152 - ServerClock.Now();

        if v154 > 0 then
            if u5 then
                u5.Text = formatHeaderCountdown(v154, v153);
            end;

            if u4 then
                u4.Visible = true;
            end;
        end;
    elseif u4 then
        u4.Visible = false;
    end;

    if u19 then
        return;
    end;

    u19 = task.spawn(function() -- Line: 691
        -- upvalues: u16 (ref), u17 (ref), u18 (ref), u4 (ref), ServerClock (ref), u5 (ref), formatHeaderCountdown (ref), u19 (ref), u20 (ref)
        while u16 and (u17 or u18) do
            local v155 = u17;
            local v156;

            if v155 then
                v156 = true;
            else
                v155 = u18;
                v156 = false;
            end;

            local v157;

            if v155 then
                local v158 = v155 - ServerClock.Now();

                if v158 <= 0 then
                    v157 = true;
                else
                    if u5 then
                        u5.Text = formatHeaderCountdown(v158, v156);
                    end;

                    if u4 then
                        u4.Visible = true;
                        v157 = false;
                    else
                        v157 = false;
                    end;
                end;
            elseif u4 then
                u4.Visible = false;
                v157 = false;
            else
                v157 = false;
            end;

            if v157 then
                u19 = nil;
                u20();

                return;
            end;

            task.wait(1);
        end;

        u19 = nil;
    end);
end;

local function renderSnapshot(p159) -- Line: 762
    -- upvalues: u18 (ref), u17 (ref), u3 (ref), u6 (ref), u7 (ref), u9 (ref), renderRewards (copy), renderLocalRewards (copy), u4 (ref), ServerClock (copy), u5 (ref), formatHeaderCountdown (copy), u19 (ref), u16 (ref), u20 (ref), renderBetween (copy)
    if typeof(p159) ~= "table" then
        return;
    end;

    if p159.phase == "running" and typeof(p159.config) == "table" then
        local config = p159.config;
        u18 = nil;
        local v160;

        if typeof(p159.endsAt) == "number" then
            v160 = p159.endsAt;
        else
            v160 = nil;
        end;

        u17 = v160;
        local v161 = u3;
        local v162 = typeof(config.displayName) ~= "string" and "Competition" or config.displayName;

        if v161 then
            v161.Text = v162;
            local TextLabel = v161:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.Text = v162;
            end;
        end;

        local v163 = {};

        if typeof(config.description) == "table" then
            for _, v in config.description do
                if typeof(v) == "string" and v ~= "" then
                    table.insert(v163, v);
                end;
            end;
        end;

        if #v163 > 0 then
            local v164 = table.remove(v163, 1);
            local v165 = table.concat(v163, "\n");

            if u6 then
                if v164 and v164 ~= "" then
                    local v166 = u6;

                    if v166 then
                        v166.Text = v164;
                        local TextLabel = v166:FindFirstChild("TextLabel");

                        if TextLabel and TextLabel:IsA("TextLabel") then
                            TextLabel.Text = v164;
                        end;
                    end;

                    u6.Visible = true;
                else
                    u6.Visible = false;
                end;
            end;

            local v167 = u7;

            if v167 then
                v167.Text = v165;
                local TextLabel = v167:FindFirstChild("TextLabel");

                if TextLabel and TextLabel:IsA("TextLabel") then
                    TextLabel.Text = v165;
                end;
            end;
        else
            if u6 then
                u6.Visible = false;
            end;

            local v168 = u7;

            if v168 then
                v168.Text = "Score points for your guild while the competition is live!";
                local TextLabel = v168:FindFirstChild("TextLabel");

                if TextLabel and TextLabel:IsA("TextLabel") then
                    TextLabel.Text = "Score points for your guild while the competition is live!";
                end;
            end;
        end;

        if u9 then
            u9.Visible = true;
            local v169 = u9;

            if v169 then
                v169.Text = "Rewards";
                local TextLabel = v169:FindFirstChild("TextLabel");

                if TextLabel and TextLabel:IsA("TextLabel") then
                    TextLabel.Text = "Rewards";
                end;
            end;
        end;

        renderRewards(config.rewards);
        local localBracket = p159.localBracket;
        local v170;

        if typeof(localBracket) == "table" and (typeof(localBracket.band) == "string" and localBracket.band ~= "") then
            v170 = localBracket.band;
        else
            v170 = nil;
        end;

        renderLocalRewards(config, v170);
        local v171 = u17;
        local v172;

        if v171 then
            v172 = true;
        else
            v171 = u18;
            v172 = false;
        end;

        if v171 then
            local v173 = v171 - ServerClock.Now();

            if v173 > 0 then
                if u5 then
                    u5.Text = formatHeaderCountdown(v173, v172);
                end;

                if u4 then
                    u4.Visible = true;
                end;
            end;
        elseif u4 then
            u4.Visible = false;
        end;

        if u17 then
            if u19 then
                return;
            end;

            u19 = task.spawn(function() -- Line: 691
                -- upvalues: u16 (ref), u17 (ref), u18 (ref), u4 (ref), ServerClock (ref), u5 (ref), formatHeaderCountdown (ref), u19 (ref), u20 (ref)
                while u16 and (u17 or u18) do
                    local v174 = u17;
                    local v175;

                    if v174 then
                        v175 = true;
                    else
                        v174 = u18;
                        v175 = false;
                    end;

                    local v176;

                    if v174 then
                        local v177 = v174 - ServerClock.Now();

                        if v177 <= 0 then
                            v176 = true;
                        else
                            if u5 then
                                u5.Text = formatHeaderCountdown(v177, v175);
                            end;

                            if u4 then
                                u4.Visible = true;
                                v176 = false;
                            else
                                v176 = false;
                            end;
                        end;
                    elseif u4 then
                        u4.Visible = false;
                        v176 = false;
                    else
                        v176 = false;
                    end;

                    if v176 then
                        u19 = nil;
                        u20();

                        return;
                    end;

                    task.wait(1);
                end;

                u19 = nil;
            end);

            return;
        end;

        if u19 then
            task.cancel(u19);
            u19 = nil;
        end;
    else
        renderBetween(p159);
    end;
end;

u20 = function() -- Line: 805, Name: fetchAndRender
    -- upvalues: Networking (copy), u16 (ref), renderSnapshot (copy)
    task.spawn(function() -- Line: 806
        -- upvalues: Networking (ref), u16 (ref), renderSnapshot (ref)
        local success, result = pcall(function() -- Line: 807
            -- upvalues: Networking (ref)
            return Networking.Guild.GetCompetition:Fire();
        end);

        if success and u16 then
            renderSnapshot(result);
        end;
    end);
end;

local function ResolveRefs(p178) -- Line: 816
    -- upvalues: u3 (ref), u15 (ref), u4 (ref), u5 (ref), u9 (ref), u7 (ref), u6 (ref), u10 (ref), u21 (ref), u8 (ref), u11 (ref), u12 (ref), u13 (ref)
    local GuildProgress = p178:FindFirstChild("GuildProgress");

    if not GuildProgress then
        return;
    end;

    local Header = GuildProgress:FindFirstChild("Header");

    if Header then
        local TextLabel = Header:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            u3 = TextLabel;
        end;

        local ExitButton = Header:FindFirstChild("ExitButton");

        if ExitButton and ExitButton:IsA("GuiButton") then
            u15 = ExitButton;
        end;

        local RefreshIn = Header:FindFirstChild("RefreshIn");

        if RefreshIn and RefreshIn:IsA("GuiObject") then
            u4 = RefreshIn;
            RefreshIn.Visible = false;
            local Timer = RefreshIn:FindFirstChild("Timer");

            if Timer and Timer:IsA("TextLabel") then
                u5 = Timer;
            end;
        end;
    end;

    local Content = GuildProgress:FindFirstChild("Content");

    if not Content then
        return;
    end;

    local TextLabel = Content:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        u9 = TextLabel;
    end;

    local Info = Content:FindFirstChild("Info");
    local v179;

    if Info then
        v179 = Info:FindFirstChild("Description");
    else
        v179 = Info;
    end;

    if v179 and v179:IsA("TextLabel") then
        u7 = v179;
    end;

    if Info then
        Info = Info:FindFirstChild("Header");
    end;

    if Info and Info:IsA("TextLabel") then
        u6 = Info;
        u6.RichText = true;
        local TextLabel2 = u6:FindFirstChild("TextLabel");

        if TextLabel2 and TextLabel2:IsA("TextLabel") then
            TextLabel2.RichText = true;
        end;
    end;

    local v180 = Content:FindFirstChild("1", true);

    if v180 and v180:IsA("ImageButton") then
        u10 = v180;
        local RewardDisplay = v180:FindFirstChild("RewardDisplay");

        if not (RewardDisplay and RewardDisplay:IsA("GuiObject")) then
            RewardDisplay = nil;
        end;

        if RewardDisplay then
            u21 = RewardDisplay.BackgroundColor3;
        end;

        local Parent = v180.Parent;

        if Parent and Parent:IsA("ScrollingFrame") then
            u8 = Parent;
            local v181 = Parent:FindFirstChild("2");

            if v181 and v181:IsA("ImageButton") then
                u11 = v181;
            end;

            local v182 = Parent:FindFirstChild("3");

            if v182 and v182:IsA("ImageButton") then
                u12 = v182;
            end;

            local v183 = Parent:FindFirstChild("4");

            if v183 and v183:IsA("ImageButton") then
                u13 = v183;
                v183.Visible = false;
            end;
        end;
    end;
end;

local function BindButtons() -- Line: 885
    -- upvalues: u15 (ref), u22 (ref), GuiController (copy)
    if u15 then
        u15.MouseButton1Click:Connect(function() -- Line: 887
            -- upvalues: u22 (ref), GuiController (ref)
            if u22 then
                GuiController:Open(u22, nil, { "HUD" });
            end;

            if GuiController:IsOpen("ViewGuildProgress") then
                GuiController:Close();
            end;
        end);
    end;
end;

function v1.SetReturnGui(p184, p185) -- Line: 899
    -- upvalues: u22 (ref)
    u22 = (typeof(p185) ~= "string" or p185 == "") and "ViewGuildPage" or p185;
end;

function v1.SetNoReturn(p186) -- Line: 907
    -- upvalues: u22 (ref)
    u22 = nil;
end;

function v1.SetTargetGuildId(p187, p188) -- Line: 911
end;

function v1.Init(p189) -- Line: 913
end;

function v1.Start(p190) -- Line: 915
    -- upvalues: PlayerGui (copy), u2 (ref), ResolveRefs (copy), u15 (ref), u22 (ref), GuiController (copy), u16 (ref), u8 (ref), u20 (ref), u19 (ref)
    task.spawn(function() -- Line: 916
        -- upvalues: PlayerGui (ref), u2 (ref), ResolveRefs (ref), u15 (ref), u22 (ref), GuiController (ref), u16 (ref), u8 (ref), u20 (ref), u19 (ref)
        local ViewGuildProgress = PlayerGui:WaitForChild("ViewGuildProgress", 30);

        if not (ViewGuildProgress and ViewGuildProgress:IsA("ScreenGui")) then
            return;
        end;

        u2 = ViewGuildProgress;
        ViewGuildProgress.Enabled = false;
        ResolveRefs(ViewGuildProgress);

        if u15 then
            u15.MouseButton1Click:Connect(function() -- Line: 887
                -- upvalues: u22 (ref), GuiController (ref)
                if u22 then
                    GuiController:Open(u22, nil, { "HUD" });
                end;

                if GuiController:IsOpen("ViewGuildProgress") then
                    GuiController:Close();
                end;
            end);
        end;

        GuiController.GuiFocusedSignal:Connect(function(p191) -- Line: 923
            -- upvalues: ViewGuildProgress (copy), u16 (ref), u8 (ref), u20 (ref)
            if p191 == ViewGuildProgress then
                u16 = true;

                if u8 then
                    u8.CanvasPosition = Vector2.zero;
                end;

                u20();
            end;
        end);
        GuiController.GuiUnfocusedSignal:Connect(function(p192) -- Line: 930
            -- upvalues: ViewGuildProgress (copy), u16 (ref), u19 (ref), u22 (ref)
            if p192 == ViewGuildProgress then
                u16 = false;

                if u19 then
                    task.cancel(u19);
                    u19 = nil;
                end;

                u22 = "ViewGuildPage";
            end;
        end);
    end);
end;

return v1;