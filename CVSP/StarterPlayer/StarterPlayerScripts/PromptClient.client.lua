-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ProximityPromptService = game:GetService("ProximityPromptService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local MarketplaceService = game:GetService("MarketplaceService");
local GroupService = game:GetService("GroupService");
local AvatarEditorService = game:GetService("AvatarEditorService");
local SocialService = game:GetService("SocialService");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local ClientEffectsModules = ReplicatedStorage:WaitForChild("ClientEffectsModules");
local Effects = require(ClientEffectsModules.Effects);
local ItemNameParser = require(Modules.ItemNameParser);
local GetItemValue = require(Modules.GetItemValue);
local BountyData = require(Modules.BountyData);
local Simple = require(Modules.FormatNumber.Simple);
local UISoundController = require(ReplicatedStorage.Sounds.UISoundController);
local DialogueGUI = ReplicatedStorage:WaitForChild("DialogueGUI");
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local LocalPlayer = Players.LocalPlayer;
local u1 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", (1 / 0));
local Events = PlayerGui:WaitForChild("MainGui"):WaitForChild("Events");
local World = workspace:WaitForChild("World", (1 / 0));
local Camera = workspace:WaitForChild("Camera");
local PottedPlants = World.Map.PottedPlants;
local u2 = {
    _default = {
        greeting = "Hello!",
        whoAreYou = "I\'m a merchant!",
        openShop = "Take a look!",
        cancel = "Bye!"
    },
    Timbles = {
        greeting = "Hey mister! Wanna see what I found?",
        whoAreYou = "I don\'t know, I\'m only five!",
        openShop = "Ok! Check these out!",
        cancel = "Bye-bye mister!"
    },
    Martian = {
        greeting = "Zeep zorp.",
        whoAreYou = "I zooped from planet Gloob Teep. Zeeble teebles.",
        openShop = "Schloop Toop!",
        cancel = "Freaking zoople doople."
    },
    ["King Capybara"] = {
        greeting = "Hello underling.",
        whoAreYou = "I\'m your king... you fight for me. Show me some respect!",
        openShop = "You better have the funds...",
        cancel = "Go and make me more money!"
    },
    Jester = {
        greeting = "Hello! Hi! Ehehehe!",
        whoAreYou = "No, no no no! The mystery... it\'s way more fun! Ehehehe!",
        openShop = "Oh goodie! Take your pick! Hehehe",
        cancel = "Until next time! Ehehe!"
    },
    Cassidy = {
        greeting = "Mornin\'. Lookin\' for work?",
        whoAreYou = "Name\'s Cassidy. Bring what the board asks and I\'ll pay in bounty tokens.",
        openShop = "Spend them tokens wisely.",
        cancel = "So long."
    }
};

local function getMerchantData(p3) -- Line: 79
    -- upvalues: u2 (copy)
    return u2[p3:GetAttribute("MerchantName")] or u2._default;
end;

local u4 = nil;
local u5 = nil;
local u6 = 0;
local u7 = nil;
local u8 = true;
local u9 = nil;
local u10 = nil;

local function togglePrompt(p11, p12) -- Line: 98
    if p11:IsA("ProximityPrompt") then
        p11.Enabled = p12;
    end;
end;

local function clearHighlight() -- Line: 104
    -- upvalues: u7 (ref)
    if u7 then
        u7:Destroy();
        u7 = nil;
    end;
end;

local function makeHighlight(p13) -- Line: 111
    -- upvalues: u7 (ref), World (copy)
    if u7 then
        u7:Destroy();
        u7 = nil;
    end;

    if not p13 then
        return;
    end;

    local Highlight = Instance.new("Highlight");
    Highlight.Name = "PromptHighlight";
    Highlight.FillTransparency = 1;
    Highlight.OutlineColor = Color3.new(1, 1, 1);
    Highlight.OutlineTransparency = 0;
    Highlight.Adornee = p13;
    Highlight.Parent = World:WaitForChild("Visuals");
    u7 = Highlight;
end;

local function typeTextRich(p14, p15, p16, p17) -- Line: 128
    -- upvalues: UISoundController (copy), u6 (ref)
    p14.RichText = true;
    p14.Text = "";
    UISoundController.Stop("Typing");
    UISoundController.Play("Typing");

    local function isPunctuation(p18) -- Line: 134
        return (p18 == "." or (p18 == "," or p18 == "!")) and true or p18 == "?";
    end;

    local v19 = 1;
    local v20 = "";
    local v21 = {};

    while v19 <= #p15 do
        if u6 ~= p17 then
            return;
        end;

        local v22 = string.sub(p15, v19, v19);

        if v22 == "<" then
            local v23 = string.find(p15, ">", v19, true);

            if not v23 then
                break;
            end;

            local v24 = string.sub(p15, v19, v23);
            v20 = v20 .. v24;
            local v25 = v24:match("^</(%w+)");
            local v26 = v24:match("/>$") == nil and v24:match("^<(%w+)");

            if v25 then
                for i = #v21, 1, -1 do
                    if v21[i] == v25 then
                        table.remove(v21, i);
                        break;
                    end;
                end;
            elseif v26 then
                table.insert(v21, v26);
            end;

            v19 = v23 + 1;
        else
            v20 = v20 .. v22;
            v19 = v19 + 1;
            local v27 = "";

            for i = #v21, 1, -1 do
                v27 = v27 .. "</" .. v21[i] .. ">";
            end;

            p14.Text = v20 .. v27;

            if (v22 == "." or (v22 == "," or v22 == "!")) and true or v22 == "?" then
                UISoundController.Stop("Typing");
                task.wait(0.15);
                UISoundController.Play("Typing");
            else
                task.wait(p16);
            end;
        end;
    end;

    if u6 == p17 then
        p14.Text = p15;
    end;

    UISoundController.Stop("Typing");
end;

local u35 = {
    NPC = function(p28, p29, p30) -- Line: 198, Name: NPC
        -- upvalues: u5 (ref), u6 (ref), DialogueGUI (copy), typeTextRich (copy)
        if u5 then
            u5:Destroy();
        end;

        local v31;

        if p29 then
            v31 = p29:FindFirstChild("DialoguePart");
        else
            v31 = p29;
        end;

        if not v31 then
            return;
        end;

        u6 = u6 + 1;
        local v32 = u6;
        local v33 = DialogueGUI:Clone();
        v33.Adornee = v31;
        v33.Parent = p29;
        v33.Enabled = true;
        local Frame = v33:FindFirstChild("Frame");

        if Frame then
            Frame = Frame:FindFirstChildWhichIsA("TextLabel");
        end;

        if Frame then
            typeTextRich(Frame, p30, 0.02, v32);
        end;

        u5 = v33;
    end,

    HideAll = function(p34) -- Line: 217, Name: HideAll
        -- upvalues: u6 (ref), u5 (ref)
        u6 = u6 + 1;

        if u5 then
            u5:Destroy();
            u5 = nil;
        end;
    end
};

local function sayThenHide(p36, u37, p38, p39) -- Line: 226
    -- upvalues: u35 (copy)
    u35:NPC(p36, p38);
    task.delay(p39 or 2, function() -- Line: 228
        -- upvalues: u35 (ref), u37 (copy)
        u35:HideAll();
        local v40 = u37;

        if v40:IsA("ProximityPrompt") then
            v40.Enabled = true;
        end;
    end);
end;

local function parseEquippedTool() -- Line: 238
    -- upvalues: LocalPlayer (copy), ItemNameParser (copy)
    local v41 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool");

    if not v41 then
        return nil;
    end;

    if v41:GetAttribute("isTower") ~= true and v41:GetAttribute("isPlant") ~= true then
        return nil;
    end;

    if v41:GetAttribute("Favorited") == true then
        return nil;
    end;

    local _, _, v42, v43 = ItemNameParser(v41.Name);

    if v42 and v43 then
        return v41, v42, v43;
    end;

    return nil;
end;

local function formatValue(p44, p45) -- Line: 248
    -- upvalues: GetItemValue (copy), Simple (copy)
    local v46 = GetItemValue({
        SizeScaling = p44,
        itemName = p45
    });

    return Simple.Format((math.round(v46)));
end;

local function collectToolsByAttribute(u47) -- Line: 253
    -- upvalues: LocalPlayer (copy)
    local u48 = {};
    local Character = LocalPlayer.Character;

    if not Character then
        return u48;
    end;

    local function tryAdd(p49) -- Line: 257
        -- upvalues: u47 (copy), u48 (copy)
        if p49:IsA("Tool") and (p49:GetAttribute(u47) == true and not table.find(u48, p49)) then
            table.insert(u48, p49);
        end;
    end;

    local v50 = Character:FindFirstChildWhichIsA("Tool");

    if v50 and (v50:IsA("Tool") and (v50:GetAttribute(u47) == true and not table.find(u48, v50))) then
        table.insert(u48, v50);
    end;

    for _, child in LocalPlayer.Backpack:GetChildren() do
        if child:IsA("Tool") and (child:GetAttribute(u47) == true and not table.find(u48, child)) then
            table.insert(u48, child);
        end;
    end;

    return u48;
end;

local function hideMenu() -- Line: 272
    -- upvalues: u4 (ref), u8 (ref)
    if u4 then
        if u4.GUI then
            u4.GUI:Destroy();
        end;

        if u4.Anchor then
            u4.Anchor:Destroy();
        end;

        u4 = nil;
    end;

    u8 = true;
end;

local u51 = nil;

local function openMenu(u52, u53) -- Line: 283
    -- upvalues: u51 (ref), u4 (ref), u8 (ref), u2 (copy), LocalPlayer (copy), PlayerGui (copy), RunService (copy), Camera (copy), u35 (copy), TweenService (copy), openMenu (copy)
    local u54 = u51[u53];

    if not u54 then
        return;
    end;

    if u4 then
        if u4.GUI then
            u4.GUI:Destroy();
        end;

        if u4.Anchor then
            u4.Anchor:Destroy();
        end;

        u4 = nil;
    end;

    u8 = true;
    local u55 = u52:FindFirstAncestorWhichIsA("Model");

    if u54.ancestor then
        u55 = u52:FindFirstAncestor(u54.ancestor) or u55;
    end;

    if not u55 then
        warn("PromptClient: could not resolve NPC for menu \'" .. u53 .. "\'");

        return;
    end;

    local u56 = u2[u55:GetAttribute("MerchantName")] or u2._default;
    local DialoguePart = u55:WaitForChild("DialoguePart");
    local HumanoidRootPart = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart");
    local Part = Instance.new("Part");
    Part.Name = "MenuAnchor";
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.Size = Vector3.new(0.1, 0.1, 0.1);
    Part.Transparency = 1;
    Part.Position = HumanoidRootPart.Position;
    Part.Parent = workspace;
    local v57 = u54.template:Clone();
    v57.Adornee = Part;
    v57.Parent = PlayerGui;
    v57.Enabled = true;
    local u58 = {
        GUI = v57,
        Anchor = Part
    };
    u4 = u58;
    local u59 = nil;
    u59 = RunService.RenderStepped:Connect(function() -- Line: 320
        -- upvalues: u4 (ref), u58 (copy), Part (copy), HumanoidRootPart (copy), u59 (ref), Camera (ref), DialoguePart (copy), u8 (ref), u35 (ref), u55 (ref), u52 (copy), u54 (copy), u56 (copy)
        if u4 ~= u58 or not (Part.Parent and HumanoidRootPart.Parent) then
            u59:Disconnect();

            return;
        end;

        Part.Position = HumanoidRootPart.Position + Vector3.new(-0.5, 0.5, 0);
        Part.CFrame = CFrame.new(Part.Position, Camera.CFrame.Position);

        if (DialoguePart.Position - HumanoidRootPart.Position).Magnitude > 20 then
            u59:Disconnect();

            if u4 then
                if u4.GUI then
                    u4.GUI:Destroy();
                end;

                if u4.Anchor then
                    u4.Anchor:Destroy();
                end;

                u4 = nil;
            end;

            u8 = true;
            u35:HideAll();
            local u60 = u52;
            u35:NPC(u55, (u54.leaveText(u56)));
            task.delay(1.5, function() -- Line: 228
                -- upvalues: u35 (ref), u60 (copy)
                u35:HideAll();
                local v61 = u60;

                if v61:IsA("ProximityPrompt") then
                    v61.Enabled = true;
                end;
            end);
        end;
    end);
    local Frame = v57:WaitForChild("Frame");

    for _, v in u54.order do
        local v62 = Frame:FindFirstChild(v);

        if v62 then
            local v63 = UDim2.new(1, 0, 0, 0);
            v62.Visible = false;
            v62.Size = v63;
            v62.BackgroundTransparency = 1;
            v62.TextLabel.TextTransparency = 1;
            local UIStroke = v62.TextLabel:FindFirstChild("UIStroke");

            if UIStroke then
                UIStroke.Transparency = 1;
            end;
        end;
    end;

    task.spawn(function() -- Line: 347
        -- upvalues: u54 (copy), u4 (ref), u58 (copy), Frame (copy), TweenService (ref)
        for _, v in u54.order do
            if u4 ~= u58 then
                return;
            end;

            local v64 = Frame:FindFirstChild(v);

            if v64 then
                v64.Visible = true;
                TweenService:Create(v64, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, u54.heightScale, 0)
                }):Play();
                TweenService:Create(v64.TextLabel, TweenInfo.new(0.25), {
                    TextTransparency = 0
                }):Play();
                local UIStroke = v64.TextLabel:FindFirstChild("UIStroke");

                if UIStroke then
                    TweenService:Create(UIStroke, TweenInfo.new(0.25), {
                        Transparency = 0
                    }):Play();
                end;

                task.wait(0.1);
            end;
        end;
    end);
    local v71 = {
        npc = u55,
        prompt = u52,
        npcData = u56,

        close = function() -- Line: 369
            -- upvalues: u4 (ref), u8 (ref)
            if u4 then
                if u4.GUI then
                    u4.GUI:Destroy();
                end;

                if u4.Anchor then
                    u4.Anchor:Destroy();
                end;

                u4 = nil;
            end;

            u8 = true;
        end,

        say = function(p65, p66) -- Line: 373
            -- upvalues: u4 (ref), u8 (ref), u55 (ref), u52 (copy), u35 (ref)
            if u4 then
                if u4.GUI then
                    u4.GUI:Destroy();
                end;

                if u4.Anchor then
                    u4.Anchor:Destroy();
                end;

                u4 = nil;
            end;

            u8 = true;
            local u67 = u52;
            u35:NPC(u55, p65);
            task.delay(p66 or 2, function() -- Line: 228
                -- upvalues: u35 (ref), u67 (copy)
                u35:HideAll();
                local v68 = u67;

                if v68:IsA("ProximityPrompt") then
                    v68.Enabled = true;
                end;
            end);
        end,

        sayAndReturn = function(u69, p70) -- Line: 378
            -- upvalues: u4 (ref), u8 (ref), u35 (ref), u55 (ref), openMenu (ref), u52 (copy), u53 (copy)
            if u4 then
                if u4.GUI then
                    u4.GUI:Destroy();
                end;

                if u4.Anchor then
                    u4.Anchor:Destroy();
                end;

                u4 = nil;
            end;

            u8 = true;
            task.spawn(function() -- Line: 380
                -- upvalues: u35 (ref), u55 (ref), u69 (copy)
                u35:NPC(u55, u69);
            end);
            task.delay(p70 or 2, function() -- Line: 381
                -- upvalues: u35 (ref), u4 (ref), openMenu (ref), u52 (ref), u53 (ref)
                u35:HideAll();

                if not u4 then
                    openMenu(u52, u53);
                end;
            end);
        end
    };
    local u72 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

    for i, v in u54.callbacks(v71) do
        local u73 = Frame:FindFirstChild(i);

        if u73 then
            local TextColor3 = u73.Number.TextColor3;
            u73.MouseEnter:Connect(function() -- Line: 395
                -- upvalues: TweenService (ref), u73 (copy), u72 (copy)
                TweenService:Create(u73.Number, u72, {
                    TextColor3 = Color3.new(1, 1, 1)
                }):Play();
                TweenService:Create(u73.TextLabel, u72, {
                    Position = UDim2.new(0.05, 0, 0, 0)
                }):Play();
            end);
            u73.MouseLeave:Connect(function() -- Line: 399
                -- upvalues: TweenService (ref), u73 (copy), u72 (copy), TextColor3 (copy)
                TweenService:Create(u73.Number, u72, {
                    TextColor3 = TextColor3
                }):Play();
                TweenService:Create(u73.TextLabel, u72, {
                    Position = UDim2.new(0, 0, 0, 0)
                }):Play();
            end);
            u73.Activated:Connect(v);
        end;
    end;
end;

u51 = {
    Sell = {
        heightScale = 0.16,
        template = ReplicatedStorage:WaitForChild("SellGUI"),
        order = { "SellCapybaras", "SellPlants", "SellItem", "HowMuch", "Cancel" },

        greeting = function() -- Line: 418, Name: greeting
            return "Yo! Got anything to sell bro?";
        end,

        leaveText = function() -- Line: 419, Name: leaveText
            return "Cya!";
        end,

        callbacks = function(u74) -- Line: 420, Name: callbacks
            -- upvalues: collectToolsByAttribute (copy), ItemNameParser (copy), GetItemValue (copy), Remotes (copy), Simple (copy), LocalPlayer (copy), parseEquippedTool (copy)
            local function bulkSell(u75) -- Line: 421
                -- upvalues: u74 (copy), collectToolsByAttribute (ref), ItemNameParser (ref), GetItemValue (ref), Remotes (ref), Simple (ref)
                u74.close();
                local v76 = u75 == "Capybara" and "towerID" or "plantID";
                local v77 = {};

                for _, v in collectToolsByAttribute(u75 == "Capybara" and "isTower" or "isPlant") do
                    if v:GetAttribute(v76) and v:GetAttribute("Favorited") ~= true then
                        table.insert(v77, v);
                    end;
                end;

                if #v77 == 0 then
                    u74.say("Sorry bro, you don\'t got anything I can buy.");

                    return;
                end;

                local v78 = 0;

                for _, v in v77 do
                    local _, _, v79, v80 = ItemNameParser(v.Name);

                    if v79 and v80 then
                        v78 = v78 + GetItemValue({
                            SizeScaling = v79,
                            itemName = v80
                        });
                    end;
                end;

                task.delay(1, function() -- Line: 442
                    -- upvalues: Remotes (ref), u75 (copy)
                    Remotes.Sell:FireServer("bulkSell", u75);
                end);
                u74.say("For all of your " .. string.lower(u75) .. "s, here\'s <font color=\'rgb(0,255,0)\'>" .. Simple.Format((math.round(v78))) .. "$</font>.");
            end;

            local function handleItemAction(p81) -- Line: 449
                -- upvalues: u74 (copy), LocalPlayer (ref), parseEquippedTool (ref), GetItemValue (ref), Simple (ref), Remotes (ref)
                u74.close();
                local v82 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool");

                if v82 and (v82:GetAttribute("isTower") == true or v82:GetAttribute("isPlant") == true) and v82:GetAttribute("Favorited") == true then
                    u74.say("That item is favorited!");

                    return;
                end;

                local v83, v84, v85 = parseEquippedTool();

                if not v83 then
                    if v82 then
                        u74.say("Sorry bro, I can\'t deal with that.");

                        return;
                    end;

                    if p81 then
                        u74.say("Hold out an item and I\'ll buy it bro.");

                        return;
                    end;

                    u74.say(math.random(1, 100) == 67 and "Hold out an item and I\'ll take a look brotein shake." or "Hold out an item and I\'ll take a look.");

                    return;
                end;

                local v86 = GetItemValue({
                    SizeScaling = v84,
                    itemName = v85
                });
                local v87 = Simple.Format((math.round(v86)));

                if not p81 then
                    u74.say("I\'d value that at <font color=\'rgb(0,255,0)\'>" .. v87 .. "$</font>.");

                    return;
                end;

                Remotes.Sell:FireServer("equippedItem");
                u74.say("Here\'s <font color=\'rgb(0,255,0)\'>" .. v87 .. "$</font>.");
            end;

            return {
                SellCapybaras = function() -- Line: 482, Name: SellCapybaras
                    -- upvalues: bulkSell (copy)
                    bulkSell("Capybara");
                end,

                SellPlants = function() -- Line: 483, Name: SellPlants
                    -- upvalues: bulkSell (copy)
                    bulkSell("Plant");
                end,

                SellItem = function() -- Line: 484, Name: SellItem
                    -- upvalues: handleItemAction (copy)
                    handleItemAction(true);
                end,

                HowMuch = function() -- Line: 485, Name: HowMuch
                    -- upvalues: handleItemAction (copy)
                    handleItemAction(false);
                end,

                Cancel = function() -- Line: 486, Name: Cancel
                    -- upvalues: u74 (copy)
                    u74.say("Cya bro!");
                end
            };
        end
    },
    Merchant = {
        heightScale = 0.22,
        template = ReplicatedStorage:WaitForChild("MerchantGUI"),
        order = { "OpenShop", "WhoAreYou", "Cancel" },

        greeting = function(p88) -- Line: 495, Name: greeting
            return p88.greeting;
        end,

        leaveText = function(p89) -- Line: 496, Name: leaveText
            return p89.cancel;
        end,

        callbacks = function(u90) -- Line: 497, Name: callbacks
            -- upvalues: u35 (copy), Events (copy)
            return {
                OpenShop = function() -- Line: 499, Name: OpenShop
                    -- upvalues: u90 (copy), u35 (ref), Events (ref)
                    u90.close();
                    u35:HideAll();
                    Events.ToggleOffAllFrames:Fire();
                    Events.ToggleMerchantShopFrame:Fire(true);
                    local prompt = u90.prompt;

                    if prompt:IsA("ProximityPrompt") then
                        prompt.Enabled = true;
                    end;
                end,

                WhoAreYou = function() -- Line: 506, Name: WhoAreYou
                    -- upvalues: u90 (copy)
                    u90.say(u90.npcData.whoAreYou);
                end,

                Cancel = function() -- Line: 507, Name: Cancel
                    -- upvalues: u90 (copy)
                    u90.say(u90.npcData.cancel);
                end
            };
        end
    },
    Bounty = {
        heightScale = 0.16,
        template = ReplicatedStorage:WaitForChild("BountyGUI"),
        order = { "TurnIn", "Bounties", "OpenShop", "WhoAreYou", "Cancel" },

        greeting = function(p91) -- Line: 516, Name: greeting
            return p91.greeting;
        end,

        leaveText = function(p92) -- Line: 517, Name: leaveText
            return p92.cancel;
        end,

        callbacks = function(u93) -- Line: 518, Name: callbacks
            -- upvalues: Remotes (copy), UISoundController (copy), BountyData (copy), Events (copy), u35 (copy)
            return {
                TurnIn = function() -- Line: 520, Name: TurnIn
                    -- upvalues: Remotes (ref), UISoundController (ref), u93 (copy)
                    local v94, v95 = Remotes.TurnInBounty:InvokeServer();

                    if v94 then
                        UISoundController.Play("Success");
                    end;

                    u93.sayAndReturn(v95 or "...", 2.5);
                end,

                Bounties = function() -- Line: 525, Name: Bounties
                    -- upvalues: Remotes (ref), u93 (copy), BountyData (ref)
                    local v96 = Remotes.RequestBounties:InvokeServer();

                    if not v96 then
                        u93.sayAndReturn("Board\'s empty. Come back in a minute.");

                        return;
                    end;

                    local v97, v98 = BountyData.generate();
                    local v99 = v96.EasyClaimed and " (done)" or "";
                    local v100 = v96.HardClaimed and " (done)" or "";
                    u93.sayAndReturn("<font color=\'rgb(0,255,0)\'>EASY:</font> " .. BountyData.describe(v97) .. v99 .. "\n<font color=\'rgb(255,0,0)\'>HARD:</font> " .. BountyData.describe(v98) .. v100, 10);
                end,

                OpenShop = function() -- Line: 541, Name: OpenShop
                    -- upvalues: Events (ref), u93 (copy), u35 (ref)
                    local ToggleBountyShopFrame = Events:FindFirstChild("ToggleBountyShopFrame");

                    if ToggleBountyShopFrame then
                        u93.close();
                        u35:HideAll();
                        Events.ToggleOffAllFrames:Fire();
                        ToggleBountyShopFrame:Fire(true);
                        local prompt = u93.prompt;

                        if prompt:IsA("ProximityPrompt") then
                            prompt.Enabled = true;
                        end;
                    else
                        u93.sayAndReturn("Shop ain\'t stocked yet. Come back soon.");
                    end;
                end,

                WhoAreYou = function() -- Line: 553, Name: WhoAreYou
                    -- upvalues: u93 (copy)
                    u93.say(u93.npcData.whoAreYou, 3.5);
                end,

                Cancel = function() -- Line: 554, Name: Cancel
                    -- upvalues: u93 (copy)
                    u93.say(u93.npcData.cancel);
                end
            };
        end
    }
};
local u101 = { 3607342886, 3607342943, 3607342995, 3607339812, 3607343068, 3607343121, 3607343196 };
local u137 = {
    EggShopPrompt = {
        ancestor = "EggNPC",
        shop = {
            dialogue = "Howdy! Here\'s the eggs I got right now:",
            toggleEvent = "ToggleEggShopFrame",
            delay = 1.5
        }
    },
    GearShopPrompt = {
        ancestor = "GearNPC",
        shop = {
            dialogue = "Heya kid. Here\'s the gears I got at the moment.",
            toggleEvent = "ToggleGearShopFrame",
            delay = 1.5
        }
    },
    TreeShopPrompt = {
        ancestor = "TreeNPC",
        shop = {
            dialogue = "I can sense your tree growing stronger...",
            toggleEvent = "ToggleTreeShopFrame",
            delay = 1.5
        }
    },
    SellPrompt = {
        ancestor = "SellNPC",
        menu = "Sell"
    },
    MerchantShopPrompt = {
        ancestor = "MerchantNPC",
        menu = "Merchant"
    },
    BountyPrompt = {
        menu = "Bounty"
    },
    BossSummonPrompt = {
        onTriggered = function(p102) -- Line: 583, Name: onTriggered
            -- upvalues: Events (copy)
            Events.ToggleBossSummonerFrame:Fire();
        end
    },
    FusePrompt = {
        onTriggered = function(p103) -- Line: 592, Name: onTriggered
            -- upvalues: Events (copy)
            Events.ToggleFuseMachineFrame:Fire();
        end
    },
    CapybaraVatPrompt = {
        onTriggered = function(p104) -- Line: 597, Name: onTriggered
            -- upvalues: Remotes (copy), UISoundController (copy)
            task.spawn(function() -- Line: 598
                -- upvalues: Remotes (ref), UISoundController (ref)
                Remotes.FuseAction:InvokeServer("Place", "Capybara");
                UISoundController.Play("Pop");
            end);
        end
    },
    PlantVatPrompt = {
        onTriggered = function(p105) -- Line: 605, Name: onTriggered
            -- upvalues: Remotes (copy), UISoundController (copy)
            task.spawn(function() -- Line: 606
                -- upvalues: Remotes (ref), UISoundController (ref)
                Remotes.FuseAction:InvokeServer("Place", "Plant");
                UISoundController.Play("Pop");
            end);
        end
    },
    HatchPrompt = {
        highlight = function(p106) -- Line: 615, Name: highlight
            local CorrespondingAdornee = p106:FindFirstChild("CorrespondingAdornee");

            return CorrespondingAdornee and CorrespondingAdornee.Value or nil;
        end,

        onTriggered = function(p107) -- Line: 619, Name: onTriggered
            -- upvalues: Remotes (copy)
            Remotes.Hatch:FireServer(p107.Parent.Parent.Name);
        end
    },
    EventPrompt = {
        onTriggered = function() -- Line: 625, Name: onTriggered
            -- upvalues: SocialService (copy)
            pcall(function() -- Line: 626
                -- upvalues: SocialService (ref)
                SocialService:PromptRsvpToEventAsync("2754981027201024597");
                SocialService:PromptRsvpToEventAsync("7442206518113600160");
            end);
        end
    },
    GroupPrompt = {
        onTriggered = function() -- Line: 634, Name: onTriggered
            -- upvalues: GroupService (copy), AvatarEditorService (copy)
            pcall(function() -- Line: 635
                -- upvalues: GroupService (ref), AvatarEditorService (ref)
                GroupService:PromptJoinAsync(14685986);
                AvatarEditorService:PromptSetFavorite(104973076655377, Enum.AvatarItemType.Asset, true);
            end);
        end
    },
    VIPPrompt = {
        highlight = function(p108) -- Line: 643, Name: highlight
            return p108:FindFirstAncestor("VIPNPC");
        end,

        onTriggered = function() -- Line: 646, Name: onTriggered
            -- upvalues: UISoundController (copy), MarketplaceService (copy), LocalPlayer (copy)
            pcall(function() -- Line: 647
                -- upvalues: UISoundController (ref), MarketplaceService (ref), LocalPlayer (ref)
                UISoundController.Play("Gem");
                MarketplaceService:PromptGamePassPurchase(LocalPlayer, 1899211207);
            end);
        end
    },
    LawnmowerPrompt = {
        onShown = function(p109) -- Line: 655, Name: onShown
            local v110 = p109.Parent and p109.Parent:FindFirstChild("DPSInfo");

            if v110 then
                v110.Enabled = true;
            end;
        end,

        onHidden = function(p111) -- Line: 660, Name: onHidden
            local v112 = p111.Parent and p111.Parent:FindFirstChild("DPSInfo");

            if v112 then
                v112.Enabled = false;
            end;
        end,

        onTriggered = function(p113) -- Line: 664, Name: onTriggered
            -- upvalues: LocalPlayer (copy), u101 (copy), MarketplaceService (copy)
            local Parent = p113.Parent.Parent;

            if Parent.Parent.Parent:GetAttribute("Owner") ~= LocalPlayer.UserId then
                return;
            end;

            local v114 = u101[tonumber(Parent.Name:match("%d+")) or 0];

            if v114 then
                MarketplaceService:PromptProductPurchase(LocalPlayer, v114);
            end;
        end
    },
    MoneyCollectionPrompt = {
        highlight = function(p115) -- Line: 676, Name: highlight
            return p115:FindFirstAncestor("CollectionMachine");
        end,

        onTriggered = function(p116) -- Line: 679, Name: onTriggered
            -- upvalues: LocalPlayer (copy), Remotes (copy), UISoundController (copy), Effects (copy)
            if p116.Parent.Parent.Parent:GetAttribute("Owner") ~= LocalPlayer.UserId then
                return;
            end;

            Remotes.CollectionMachine:FireServer();
            UISoundController.Play("Click");
            UISoundController.Play("SlotMachine");
            Effects.Play("MoneyCollect", {
                playerCharacter = LocalPlayer.Character
            });
        end
    },
    GiftPrompt = {
        onTriggered = function(p117) -- Line: 689, Name: onTriggered
            -- upvalues: Players (copy), u1 (copy), Remotes (copy)
            local v118 = p117:FindFirstAncestorOfClass("Model");

            if v118 then
                v118 = Players:GetPlayerFromCharacter(v118);
            end;

            if not v118 then
                return;
            end;

            local v119 = u1:FindFirstChildWhichIsA("Tool");

            if not v119 or (v119:GetAttribute("isPlant") or v119:GetAttribute("isTower")) ~= true then
                return;
            end;

            Remotes.GiftItem:FireServer(v118);
        end
    },
    BossPotPrompt = {
        onShown = function(p120) -- Line: 700, Name: onShown
            -- upvalues: u1 (copy)
            local v121 = u1:FindFirstChildWhichIsA("Tool");
            local v122 = p120:FindFirstAncestorWhichIsA("Model");

            if not v122 then
                return;
            end;

            local v123 = v122:GetAttribute("Occupied");
            local v124 = v122:GetAttribute("plantID");

            if v123 and v124 then
                p120.ObjectText = v124:split(":")[1];
                p120.ActionText = v121 and v121:GetAttribute("isPlant") and "Swap Boss Plants" or "Pick Up Boss Plant";

                return;
            end;

            if v121 and v121:GetAttribute("isPlant") == true then
                p120.ObjectText = v121.Name;
                p120.ActionText = "Place Boss Plant";

                return;
            end;

            p120.ObjectText = "Boss Pot";
            p120.ActionText = "Place Boss Plant (Hold out boss plant!)";
        end,

        onTriggered = function(p125) -- Line: 717, Name: onTriggered
            -- upvalues: LocalPlayer (copy), UISoundController (copy), Remotes (copy)
            local v126 = p125:FindFirstAncestorWhichIsA("Model");

            if not v126 then
                return;
            end;

            if v126.Parent.Parent.Parent:GetAttribute("Owner") ~= LocalPlayer.UserId then
                return;
            end;

            UISoundController.Play("Pop");
            local v127 = tonumber(v126.Name:match("%d+")) or 1;
            Remotes.PotInteract:FireServer(-v127);
        end
    },
    PotPrompt = {
        highlight = function() -- Line: 730, Name: highlight
            return nil;
        end,

        onShown = function(u128) -- Line: 731, Name: onShown
            -- upvalues: u1 (copy), makeHighlight (copy), PottedPlants (copy), u9 (ref), u10 (ref)
            local function updatePrompt(p129) -- Line: 732
                -- upvalues: u1 (ref), makeHighlight (ref), PottedPlants (ref)
                local v130 = u1:FindFirstChildWhichIsA("Tool");
                local v131 = p129:FindFirstAncestorWhichIsA("Model");

                if not v131 then
                    return;
                end;

                local v132 = v131:GetAttribute("Occupied");
                local v133 = v131:GetAttribute("plantID");

                if v130 and v130:GetAttribute("isPlant") == true then
                    p129.ObjectText = v130.Name;

                    if v132 then
                        p129.ActionText = "Swap Plants";
                        makeHighlight(PottedPlants.Client:FindFirstChild(v133));

                        return;
                    end;

                    p129.ActionText = "Place Plant";
                    makeHighlight(v131);

                    return;
                end;

                if v132 then
                    p129.ObjectText = v133:split(":")[1];
                    p129.ActionText = "Pick Up Plant";
                    makeHighlight(PottedPlants.Client:FindFirstChild(v133));

                    return;
                end;

                p129.ObjectText = "Hold out plant!";
                p129.ActionText = "Place Plant (Hold out plant!)";
                makeHighlight(v131);
            end;

            updatePrompt(u128);

            if u9 then
                u9:Disconnect();
            end;

            if u10 then
                u10:Disconnect();
            end;

            local function onToolChange(p134) -- Line: 765
                -- upvalues: u128 (copy), updatePrompt (copy)
                if not p134:IsA("Tool") then
                    return;
                end;

                task.defer(function() -- Line: 767
                    -- upvalues: u128 (ref)
                    u128.Enabled = false;
                    task.wait(0.05);
                    u128.Enabled = true;
                end);
                updatePrompt(u128);
            end;

            u9 = u1.ChildAdded:Connect(onToolChange);
            u10 = u1.ChildRemoved:Connect(onToolChange);
        end,

        onHidden = function() -- Line: 777, Name: onHidden
            -- upvalues: u9 (ref), u10 (ref)
            if u9 then
                u9:Disconnect();
                u9 = nil;
            end;

            if u10 then
                u10:Disconnect();
                u10 = nil;
            end;
        end,

        onTriggered = function(p135) -- Line: 781, Name: onTriggered
            -- upvalues: LocalPlayer (copy), UISoundController (copy), Remotes (copy)
            local v136 = p135:FindFirstAncestorWhichIsA("Model");

            if v136.Parent.Parent.Parent:GetAttribute("Owner") ~= LocalPlayer.UserId then
                return;
            end;

            UISoundController.Play("Pop");
            Remotes.PotInteract:FireServer((tonumber(v136.Name:match("%d+"))));
        end
    }
};

local function resolveHighlight(p138, p139) -- Line: 794
    if p139.highlight then
        return p139.highlight(p138);
    end;

    return p139.ancestor and p138:FindFirstAncestor(p139.ancestor) or p138:FindFirstAncestorWhichIsA("Model");
end;

local function resolveNPC(p140, p141) -- Line: 805
    if p141.ancestor then
        local v142 = p140:FindFirstAncestor(p141.ancestor);

        if v142 then
            return v142;
        end;

        warn(("PromptClient: ancestor \'%s\' not found for prompt \'%s\', using nearest Model"):format(p141.ancestor, p140.Name));
    end;

    return p140:FindFirstAncestorWhichIsA("Model");
end;

ProximityPromptService.PromptShown:Connect(function(p143) -- Line: 814
    -- upvalues: u137 (ref), makeHighlight (copy), resolveHighlight (copy)
    local v144 = u137[p143.Name];

    if not v144 then
        return;
    end;

    makeHighlight(resolveHighlight(p143, v144));

    if v144.onShown then
        v144.onShown(p143);
    end;
end);
ProximityPromptService.PromptHidden:Connect(function(p145) -- Line: 821
    -- upvalues: u137 (ref), u7 (ref)
    local v146 = u137[p145.Name];

    if not v146 then
        return;
    end;

    if u7 then
        u7:Destroy();
        u7 = nil;
    end;

    if v146.onHidden then
        v146.onHidden(p145);
    end;
end);
ProximityPromptService.PromptTriggered:Connect(function(u147, p148) -- Line: 828
    -- upvalues: LocalPlayer (copy), u8 (ref), u137 (ref), u35 (copy), Events (copy), u51 (ref), u2 (copy), openMenu (copy)
    if p148 ~= LocalPlayer then
        return;
    end;

    if not u8 then
        return;
    end;

    local u149 = u137[u147.Name];

    if not u149 then
        return;
    end;

    if not u149.shop then
        if not u149.menu then
            if u149.onTriggered then
                u149.onTriggered(u147);
            end;

            return;
        end;

        local u150;

        if u149.ancestor then
            u150 = u147:FindFirstAncestor(u149.ancestor);

            if u150 then
                if not u150 then
                    return;
                end;

                if u147:IsA("ProximityPrompt") then
                    u147.Enabled = false;
                end;

                task.spawn(function() -- Line: 851
                    -- upvalues: u35 (ref), u150 (copy), u51 (ref), u149 (copy), u2 (ref), openMenu (ref), u147 (copy)
                    u35:NPC(u150, u51[u149.menu].greeting(u2[u150:GetAttribute("MerchantName")] or u2._default));
                    openMenu(u147, u149.menu);
                end);

                return;
            end;

            warn(("PromptClient: ancestor \'%s\' not found for prompt \'%s\', using nearest Model"):format(u149.ancestor, u147.Name));
        end;

        u150 = u147:FindFirstAncestorWhichIsA("Model");

        if not u150 then
            return;
        end;

        if u147:IsA("ProximityPrompt") then
            u147.Enabled = false;
        end;

        task.spawn(function() -- Line: 851
            -- upvalues: u35 (ref), u150 (copy), u51 (ref), u149 (copy), u2 (ref), openMenu (ref), u147 (copy)
            u35:NPC(u150, u51[u149.menu].greeting(u2[u150:GetAttribute("MerchantName")] or u2._default));
            openMenu(u147, u149.menu);
        end);

        return;
    end;

    local u151;

    if u149.ancestor then
        u151 = u147:FindFirstAncestor(u149.ancestor);

        if u151 then
            if u147:IsA("ProximityPrompt") then
                u147.Enabled = false;
            end;

            task.spawn(function() -- Line: 837
                -- upvalues: u35 (ref), u151 (copy), u149 (copy)
                u35:NPC(u151, u149.shop.dialogue);
            end);
            task.delay(u149.shop.delay, function() -- Line: 840
                -- upvalues: Events (ref), u149 (copy), u35 (ref), u147 (copy)
                Events.ToggleOffAllFrames:Fire();
                Events[u149.shop.toggleEvent]:Fire(true);
                task.delay(0.5, function() -- Line: 843
                    -- upvalues: u35 (ref)
                    u35:HideAll();
                end);
                local v152 = u147;

                if v152:IsA("ProximityPrompt") then
                    v152.Enabled = true;
                end;
            end);

            return;
        end;

        warn(("PromptClient: ancestor \'%s\' not found for prompt \'%s\', using nearest Model"):format(u149.ancestor, u147.Name));
    end;

    u151 = u147:FindFirstAncestorWhichIsA("Model");

    if u147:IsA("ProximityPrompt") then
        u147.Enabled = false;
    end;

    task.spawn(function() -- Line: 837
        -- upvalues: u35 (ref), u151 (copy), u149 (copy)
        u35:NPC(u151, u149.shop.dialogue);
    end);
    task.delay(u149.shop.delay, function() -- Line: 840
        -- upvalues: Events (ref), u149 (copy), u35 (ref), u147 (copy)
        Events.ToggleOffAllFrames:Fire();
        Events[u149.shop.toggleEvent]:Fire(true);
        task.delay(0.5, function() -- Line: 843
            -- upvalues: u35 (ref)
            u35:HideAll();
        end);
        local v152 = u147;

        if v152:IsA("ProximityPrompt") then
            v152.Enabled = true;
        end;
    end);
end);

local function setupGiftPrompt(p153) -- Line: 865
    -- upvalues: u1 (copy)
    if p153 == u1 then
        return;
    end;

    local v154 = p153:FindFirstChild("HumanoidRootPart") or p153:WaitForChild("HumanoidRootPart", 10);

    if not v154 or v154:FindFirstChild("GiftPrompt") then
        return;
    end;

    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.Name = "GiftPrompt";
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
    ProximityPrompt.ObjectText = "Give Item";
    ProximityPrompt.MaxActivationDistance = 10;
    ProximityPrompt.RequiresLineOfSight = false;
    ProximityPrompt.HoldDuration = 1.5;
    ProximityPrompt.Parent = v154;

    local function updateEnabled() -- Line: 879
        -- upvalues: u1 (ref), ProximityPrompt (copy)
        local v155 = u1:FindFirstChildWhichIsA("Tool");
        local v156;

        if v155 then
            v156 = (v155:GetAttribute("isPlant") or v155:GetAttribute("isTower")) == true;
        else
            v156 = v155;
        end;

        ProximityPrompt.Enabled = v156;

        if v155 then
            ProximityPrompt.ActionText = "Gift " .. v155.Name;
        end;
    end;

    local v157 = u1:FindFirstChildWhichIsA("Tool");
    local v158;

    if v157 then
        v158 = (v157:GetAttribute("isPlant") or v157:GetAttribute("isTower")) == true;
    else
        v158 = v157;
    end;

    ProximityPrompt.Enabled = v158;

    if v157 then
        ProximityPrompt.ActionText = "Gift " .. v157.Name;
    end;

    u1.ChildAdded:Connect(function(p159) -- Line: 888
        -- upvalues: u1 (ref), ProximityPrompt (copy)
        if p159:IsA("Tool") then
            local v160 = u1:FindFirstChildWhichIsA("Tool");
            local v161;

            if v160 then
                v161 = (v160:GetAttribute("isPlant") or v160:GetAttribute("isTower")) == true;
            else
                v161 = v160;
            end;

            ProximityPrompt.Enabled = v161;

            if v160 then
                ProximityPrompt.ActionText = "Gift " .. v160.Name;
            end;
        end;
    end);
    u1.ChildRemoved:Connect(function(p162) -- Line: 891
        -- upvalues: u1 (ref), ProximityPrompt (copy)
        if p162:IsA("Tool") then
            local v163 = u1:FindFirstChildWhichIsA("Tool");
            local v164;

            if v163 then
                v164 = (v163:GetAttribute("isPlant") or v163:GetAttribute("isTower")) == true;
            else
                v164 = v163;
            end;

            ProximityPrompt.Enabled = v164;

            if v163 then
                ProximityPrompt.ActionText = "Gift " .. v163.Name;
            end;
        end;
    end);
end;

local function setupPlayer(p165) -- Line: 896
    -- upvalues: LocalPlayer (copy), setupGiftPrompt (copy)
    if p165 == LocalPlayer then
        return;
    end;

    if p165.Character then
        setupGiftPrompt(p165.Character);
    end;

    p165.CharacterAdded:Connect(setupGiftPrompt);
end;

for _, v in Players:GetPlayers() do
    if v ~= LocalPlayer then
        if v.Character then
            setupGiftPrompt(v.Character);
        end;

        v.CharacterAdded:Connect(setupGiftPrompt);
    end;
end;

Players.PlayerAdded:Connect(setupPlayer);