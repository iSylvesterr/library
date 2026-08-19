-- Decompiled with Potassium's decompiler.

local Steven = workspace:WaitForChild("NPCS"):WaitForChild("Steven");
local ProximityPrompt = Steven:WaitForChild("HumanoidRootPart"):WaitForChild("ProximityPrompt");
local u1 = require("../NPCDialogueController");
local TopText = require(game:GetService("ReplicatedStorage"):WaitForChild("ClientModules"):WaitForChild("TopText"));
local SellValueData = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("SellValueData"));
local FruitValueCalc = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("FruitValueCalc"));
local SellFlags = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Flags"):WaitForChild("SellFlags"));
require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("MutationData"));
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);
local Worlds = require(game.ReplicatedStorage.SharedModules.Worlds);
local BidOddModule = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("BidOddModule"));
local NumberUtils = require(game.ReplicatedStorage.SharedModules.NumberUtils);
local RunService = game:GetService("RunService");
local HarvestedFruitHandleController = require(script.Parent.Parent.HarvestedFruitHandleController);
local RadialFXController = require(script.Parent.Parent.RadialFXController);
require(game.Players.LocalPlayer.PlayerScripts.Controllers.PlantLifecycleHandler);
local GuiController = require(script.Parent.Parent.GuiController);
local ABTests = require(game:GetService("ReplicatedStorage"):WaitForChild("UserGenerated"):WaitForChild("ABTests"));

local function PlayerInStock() -- Line: 27
    -- upvalues: ABTests (copy)
    return ABTests.GetAttribute(game.Players.LocalPlayer, "Sell.PriceStock.Enabled", false) == true;
end;

local Animations = Steven:WaitForChild("Animations");
local Success = Animations:WaitForChild("Success");
local Idle = Animations:WaitForChild("Idle");
Animations:WaitForChild("Interact");
local Fail = Animations:WaitForChild("Fail");
local Buy = Animations:WaitForChild("Buy");
local PetData = require(game.ReplicatedStorage.SharedData.PetData);
local BargainSFX = game.SoundService.SFX.BargainSFX;
local SellSFX = game.SoundService.SFX.SellSFX;
local Normal = SellSFX.Normal;
local Rainbow = SellSFX.Rainbow;
local Accept = BargainSFX.Accept;
local Decline = BargainSFX.Decline;
local Animator = Steven:WaitForChild("Humanoid"):WaitForChild("Animator");
local u2 = Animator:LoadAnimation(Success);
local v3 = Animator:LoadAnimation(Idle);
local u4 = Animator:LoadAnimation(Fail);
local u5 = Animator:LoadAnimation(Buy);
v3:Play(0.1, 3, 1);
local DevProductController = require(script.Parent.Parent.DevProductController);
local NotificationController = require(script.Parent.Parent.NotificationController);
local MessagePrompt = require(game.ReplicatedStorage.ClientModules.MessagePrompt);
local u6 = 0;
local u7 = false;
local u8 = false;
local u9 = { "Smart. The house always wins anyway.", "Good call -- my pockets are deep enough already.", "Chicken? ...I mean, very sensible.", "Bold of you to almost be bold.", "I\'ll pretend you never doubted yourself.", "Sometimes the smartest bet is no bet at all.", "Probably for the best. I was feeling lucky too." };

local function PromptSkipCooldown() -- Line: 112
    -- upvalues: DevProductController (copy)
    local u10 = false;
    local u11 = false;
    local v13 = DevProductController.PurchaseComplete:Connect(function(p12) -- Line: 116
        -- upvalues: u11 (ref), u10 (ref)
        if p12 == "Standalone:Skip Cooldown:1" then
            u11 = true;
            u10 = true;
        end;
    end);
    local v16 = DevProductController.PurchaseFailed:Connect(function(p14, p15) -- Line: 119
        -- upvalues: u10 (ref)
        if p14 == "Standalone:Skip Cooldown:1" then
            u10 = true;
        end;
    end);
    local v18 = DevProductController.PurchaseCancelled:Connect(function(p17) -- Line: 122
        -- upvalues: u10 (ref)
        if p17 == "Standalone:Skip Cooldown:1" then
            u10 = true;
        end;
    end);
    local v19, v20 = DevProductController:PromptPurchase("Standalone:Skip Cooldown:1");

    if v19 then
        if v20 ~= "Prompted Robux" and not u10 then
            u11 = true;
            u10 = true;
        end;
    else
        u10 = true;
    end;

    local v21 = os.clock();

    while not u10 and os.clock() - v21 < 60 do
        task.wait(0.1);
    end;

    v13:Disconnect();
    v16:Disconnect();
    v18:Disconnect();

    return u11;
end;

local u22 = { {
        Max = 50000,
        Name = "50K"
    }, {
        Max = 500000,
        Name = "500K"
    }, {
        Max = 2000000,
        Name = "2M"
    }, {
        Max = 10000000,
        Name = "10M"
    }, {
        Max = 100000000,
        Name = "100M"
    }, {
        Max = 500000000,
        Name = "500M"
    }, {
        Max = 1000000000,
        Name = "1B"
    }, {
        Max = (1 / 0),
        Name = "5B"
    } };

local function GetSaveStreakBracket(p23) -- Line: 168
    -- upvalues: u22 (copy)
    for _, v in u22 do
        if p23 < v.Max then
            return v.Name;
        end;
    end;

    return u22[#u22].Name;
end;

local function GetSaveStreakProductKey(p24, p25) -- Line: 177
    -- upvalues: u22 (copy)
    local v26 = math.clamp(p25, 1, 10);
    local v27;

    for _, v in u22 do
        if p24 < v.Max then
            v27 = v.Name;
            break;
        end;
    end;

    v27 = u22[#u22].Name;

    return `SaveStreak:{v27}:{v26}`;
end;

local function PromptSaveStreakPurchase(u28) -- Line: 184
    -- upvalues: DevProductController (copy)
    local u29 = false;
    local u30 = false;
    local v32 = DevProductController.PurchaseComplete:Connect(function(p31) -- Line: 188
        -- upvalues: u28 (copy), u30 (ref), u29 (ref)
        if p31 == u28 then
            u30 = true;
            u29 = true;
        end;
    end);
    local v34 = DevProductController.PurchaseFailed:Connect(function(p33) -- Line: 191
        -- upvalues: u28 (copy), u29 (ref)
        if p33 == u28 then
            u29 = true;
        end;
    end);
    local v36 = DevProductController.PurchaseCancelled:Connect(function(p35) -- Line: 194
        -- upvalues: u28 (copy), u29 (ref)
        if p35 == u28 then
            u29 = true;
        end;
    end);
    local v37, v38 = DevProductController:PromptPurchase(u28);

    if v37 then
        if v38 ~= "Prompted Robux" and not u29 then
            u30 = true;
            u29 = true;
        end;
    else
        u29 = true;
    end;

    local v39 = os.clock();

    while not u29 and os.clock() - v39 < 60 do
        task.wait(0.1);
    end;

    v32:Disconnect();
    v34:Disconnect();
    v36:Disconnect();

    return u30;
end;

Networking.NPCS.LegendaryFx.OnClientEvent:Connect(function() -- Line: 221, Name: PlayStevenLegendaryParticles
    -- upvalues: Steven (copy)
    local HumanoidRootPart = Steven:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    for _, descendant in HumanoidRootPart:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local v40 = descendant:GetAttribute("EmitCount");

            if v40 and v40 > 0 then
                descendant:Emit(v40);
            end;
        end;
    end;
end);

local function Coins(p41) -- Line: 242
    -- upvalues: NumberUtils (copy), Worlds (copy)
    return NumberUtils.Abbreviate(p41) .. Worlds.Current.CurrencySuffix;
end;

local function GetPlayerSheckles(p42) -- Line: 246
    -- upvalues: Worlds (copy)
    local leaderstats = p42:FindFirstChild("leaderstats");

    if leaderstats then
        leaderstats = leaderstats:FindFirstChild(Worlds.WalletStatName(p42));
    end;

    return not (leaderstats and leaderstats:IsA("IntValue")) and 0 or leaderstats.Value;
end;

local function WaitForChoice(p43, p44) -- Line: 255
    -- upvalues: TopText (copy)
    local u45 = TopText.ShowChoices(p43, p44);
    local u46 = nil;
    local v47 = {};

    if #u45 == 0 then
        return nil, "__DISMISSED__";
    end;

    local function AnyChoiceAlive() -- Line: 264
        -- upvalues: u45 (copy)
        for _, v in u45 do
            if v and v.Parent then
                return true;
            end;
        end;

        return false;
    end;

    for i, v in u45 do
        local Frame = v:FindFirstChild("Frame");

        if Frame then
            local ImageButton = Frame:FindFirstChild("ImageButton");

            if ImageButton then
                table.insert(v47, ImageButton.MouseButton1Click:Connect(function() -- Line: 278
                    -- upvalues: u46 (ref), i (copy)
                    u46 = i;
                end));
            end;
        end;
    end;

    local v49 = TopText.ConnectChoiceKeyboard(u45, function(p48) -- Line: 284
        -- upvalues: u46 (ref)
        if u46 == nil then
            u46 = p48;
        end;
    end);

    while true do
        if u46 ~= nil then
            for _, v in v47 do
                v:Disconnect();
            end;

            v49();
            TopText.RemovePlayerSideFrame(p43);

            if p43.Character then
                TopText.PlayerResponse(p43.Character, p44[u46], true);
            end;

            return u46, p44[u46];
        end;

        local v50 = false;

        for _, v in u45 do
            if v and v.Parent then
                v50 = true;
                break;
            end;
        end;

        if not v50 then
            for _, v in v47 do
                v:Disconnect();
            end;

            v49();

            return nil, "__DISMISSED__";
        end;

        task.wait(0.05);
    end;
end;

local function IsPlayerInDialogueRange() -- Line: 312
    -- upvalues: Steven (copy), ProximityPrompt (copy)
    local Character = game.Players.LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    local HumanoidRootPart = Steven:FindFirstChild("HumanoidRootPart");

    if Character and HumanoidRootPart then
        return (Character.Position - HumanoidRootPart.Position).Magnitude < ProximityPrompt.MaxActivationDistance + 1;
    end;

    return false;
end;

local function PromptConfirm(u51) -- Line: 337
    -- upvalues: MessagePrompt (copy), Steven (copy), ProximityPrompt (copy)
    local u52 = false;
    local u53 = false;
    task.spawn(function() -- Line: 341
        -- upvalues: MessagePrompt (ref), u51 (copy), u53 (ref), u52 (ref)
        u53 = MessagePrompt.Prompt(u51) == true;
        u52 = true;
    end);
    task.spawn(function() -- Line: 347
        -- upvalues: u52 (ref), Steven (ref), ProximityPrompt (ref), MessagePrompt (ref)
        while not u52 do
            local Character = game.Players.LocalPlayer.Character;

            if Character then
                Character = Character:FindFirstChild("HumanoidRootPart");
            end;

            local HumanoidRootPart = Steven:FindFirstChild("HumanoidRootPart");
            local v54;

            if Character and HumanoidRootPart then
                v54 = (Character.Position - HumanoidRootPart.Position).Magnitude < ProximityPrompt.MaxActivationDistance + 1;
            else
                v54 = false;
            end;

            if not v54 then
                MessagePrompt.Dismiss();

                return;
            end;

            task.wait(0.1);
        end;
    end);

    while not u52 do
        task.wait(0.05);
    end;

    return u53;
end;

local function OfferStreakRevive(p55, p56, p57) -- Line: 371
    -- upvalues: u22 (copy), WaitForChoice (copy), PromptSaveStreakPurchase (copy)
    local v58 = math.clamp(p56, 1, 10);
    local v59;

    for _, v in u22 do
        if p57 < v.Max then
            v59 = v.Name;
            break;
        end;
    end;

    v59 = u22[#u22].Name;
    local v60 = `SaveStreak:{v59}:{v58}`;
    local v61, v62 = WaitForChoice(p55, { string.format("Revive Streak %d🔥", p56), "Nevermind" });

    if v62 == "__DISMISSED__" or v61 ~= 1 then
        return false;
    end;

    return PromptSaveStreakPurchase(v60);
end;

local function WaitForChoiceWithCooldown(p63, u64, u65, u66, p67, u68) -- Line: 386
    -- upvalues: TopText (copy)
    local v69 = os.clock() < u66;
    local u70 = nil;
    local u71 = {};
    local v72 = table.clone(u64);

    if v69 then
        local v73 = u66 - os.clock();
        local v74 = math.max(0, v73);
        v72[u65] = string.format("%s <font color=\"#888888\">[%.1fs]</font>", u64[u65], v74);
    end;

    local u75 = TopText.ShowChoices(p63, v72);

    if #u75 == 0 then
        return nil, "__DISMISSED__";
    end;

    local function _() -- Line: 405
        -- upvalues: u75 (copy)
        for _, v in u75 do
            if v and v.Parent then
                return true;
            end;
        end;

        return false;
    end;

    local u76 = nil;

    if v69 then
        local v77 = u75[u65];

        if v77 then
            v77 = v77:FindFirstChild("Frame");
        end;

        if v77 then
            v77 = v77:FindFirstChild("Frame");
        end;

        if v77 then
            v77 = v77:FindFirstChild("Text_Element");
        end;

        local u78 = v77;

        if u78 and u78:IsA("TextLabel") then
            u76 = task.spawn(function() -- Line: 424
                -- upvalues: u70 (ref), u75 (copy), u66 (copy), u78 (ref), u64 (copy), u65 (copy), u68 (copy)
                while u70 == nil do
                    local v79 = false;

                    for _, v in u75 do
                        if v and v.Parent then
                            v79 = true;
                            break;
                        end;
                    end;

                    if not v79 then
                        break;
                    end;

                    local v80 = u66 - os.clock();

                    if v80 <= 0 then
                        u78.Text = "[\"" .. u64[u65] .. "\"]";
                        local v81 = u68 and u75[u68];

                        if v81 then
                            v81:Destroy();

                            return;
                        end;
                    end;

                    u78.Text = string.format("[\"%s <font color=\"#888888\">[%.1fs]</font>\"]", u64[u65], v80);
                    task.wait(0.1);
                end;
            end);
        end;
    end;

    local u82 = {};

    if p67 then
        for i, v in pairs(p67) do
            local v83 = u75[i];

            if v83 then
                local Frame = v83:FindFirstChild("Frame");

                if Frame then
                    Frame = Frame:FindFirstChild("Frame");
                end;

                if Frame then
                    Frame = Frame:FindFirstChild("Text_Element");
                end;

                if Frame then
                    table.insert(u82, task.spawn(function() -- Line: 460
                        -- upvalues: u70 (ref), u75 (copy), Frame (copy), v (copy), TopText (ref)
                        local v84 = 0;

                        while u70 == nil do
                            local v85 = false;

                            for _, v2 in u75 do
                                if v2 and v2.Parent then
                                    v85 = true;
                                    break;
                                end;
                            end;

                            if not v85 then
                                break;
                            end;

                            v84 = v84 + task.wait(0.04);

                            if not (Frame and Frame.Parent) then
                                break;
                            end;

                            Frame.Text = "[\"" .. v.before .. TopText.BuildRainbowText(v.colored, v84) .. v.after .. "\"]";
                        end;
                    end));
                end;
            end;
        end;
    end;

    for i, v in ipairs(u75) do
        local Frame = v:FindFirstChild("Frame");

        if Frame then
            local ImageButton = Frame:FindFirstChild("ImageButton");

            if ImageButton then
                table.insert(u71, ImageButton.MouseButton1Click:Connect(function() -- Line: 478
                    -- upvalues: u70 (ref), i (copy)
                    u70 = i;
                end));
            end;
        end;
    end;

    local u87 = TopText.ConnectChoiceKeyboard(u75, function(p86) -- Line: 487
        -- upvalues: u70 (ref)
        if u70 == nil then
            u70 = p86;
        end;
    end);

    local function Cleanup() -- Line: 493
        -- upvalues: u76 (ref), u71 (copy), u82 (copy), u87 (copy)
        if u76 then
            task.cancel(u76);
        end;

        for _, v in u71 do
            v:Disconnect();
        end;

        for _, v in u82 do
            task.cancel(v);
        end;

        u87();
    end;

    while true do
        if u70 ~= nil then
            Cleanup();
            TopText.RemovePlayerSideFrame(p63);

            if v69 and (u70 == u65 and os.clock() < u66) then
                return u65, "__COOLDOWN__";
            end;

            if u68 and u70 == u68 then
                return u70, u64[u70];
            end;

            local v88 = u64[u70];

            if p63.Character then
                TopText.PlayerResponse(p63.Character, v88, true);
            end;

            return u70, v88;
        end;

        local v89 = false;

        for _, v in u75 do
            if v and v.Parent then
                v89 = true;
                break;
            end;
        end;

        if not v89 then
            Cleanup();

            return nil, "__DISMISSED__";
        end;

        task.wait(0.05);
    end;
end;

local function IsPlayerNearSteven(p90) -- Line: 527
    -- upvalues: Steven (copy)
    local Character = p90.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    local HumanoidRootPart = Steven:FindFirstChild("HumanoidRootPart");

    if Character and HumanoidRootPart then
        return (Character.Position - HumanoidRootPart.Position).Magnitude <= 15;
    end;

    return false;
end;

local function IsHoldingPet(p91) -- Line: 538
    local Character = p91.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Tool");
    end;

    local v92;

    if typeof(Character) == "Instance" then
        v92 = Character:GetAttribute("Pet") ~= nil;
    else
        v92 = false;
    end;

    return v92;
end;

local function GetHeldFruitInfo(p93) -- Line: 547
    -- upvalues: SellValueData (copy), FruitValueCalc (copy)
    local Character = p93.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Tool");
    end;

    if not Character then
        return nil, "You aren\'t holding anything!";
    end;

    if Character:GetAttribute("PottedPlant") == true then
        local v94 = { "I don\'t buy potted plants, just the fruits!", "I only want harvested fruits, not the whole plant." };

        return nil, v94[math.random(#v94)];
    end;

    local v95 = Character:GetAttribute("FruitName");

    if not v95 then
        if Character:GetAttribute("Pet") then
            return "Pet", {
                PetID = Character:GetAttribute("PetId"),
                Tool = Character,
                PetName = Character:GetAttribute("Pet")
            };
        end;

        if Character.Name == "Shovel" then
            local v96 = { "I don\'t want your shovel.", "Bring me a fruit, not a shovel..", "I only want plants!" };

            return nil, v96[math.random(#v96)];
        end;

        local v97 = { "That isn\'t a plant..", "What am I meant to do with that?", "Plants only, please.." };

        return nil, v97[math.random(#v97)];
    end;

    local v98 = Character:GetAttribute("Id");

    if not v98 then
        return nil, "I can\'t tell what that is..";
    end;

    if not SellValueData[v95] then
        return nil, "I\'ve never seen that before";
    end;

    local v99 = Character:GetAttribute("DecayAlpha");

    return {
        Tool = Character,
        FruitName = v95,
        FruitId = v98,
        BaseValue = FruitValueCalc(v95, Character:GetAttribute("SizeMultiplier"), Character:GetAttribute("Mutation"), p93, v99),
        DecayAlpha = v99
    };
end;

local function DestroyAllFruitTools(p100) -- Line: 599
    -- upvalues: RunService (copy)
    local v101 = p100.Character and p100.Character:FindFirstChildOfClass("Tool");

    if v101 and v101:GetAttribute("FruitName") then
        v101:Destroy();
    end;

    local Backpack = p100:FindFirstChild("Backpack");

    if Backpack then
        local u102 = {};

        for _, child in Backpack:GetChildren() do
            if child:IsA("Tool") and child:GetAttribute("FruitName") then
                table.insert(u102, child);
            end;
        end;

        if #u102 > 0 then
            task.spawn(function() -- Line: 613
                -- upvalues: u102 (copy), RunService (ref)
                local v103 = 1;

                while v103 <= #u102 do
                    local v104 = math.min(#u102, v103 + 100 - 1);

                    for i = v103, v104 do
                        local v105 = u102[i];

                        if v105 and v105.Parent then
                            v105:Destroy();
                        end;
                    end;

                    v103 = v104 + 1;
                    RunService.Heartbeat:Wait();
                end;
            end);
        end;
    end;
end;

local function SafeDestroyTool(p106) -- Line: 632
    if p106 and p106.Parent then
        p106:Destroy();
    end;
end;

local function RunInventoryBargainLoop(p107, p108, p109) -- Line: 644
    -- upvalues: Networking (copy), SellFlags (copy), TopText (copy), Steven (copy), u6 (ref), BidOddModule (copy), u2 (copy), Accept (copy), RadialFXController (copy), NumberUtils (copy), Worlds (copy), Decline (copy), u4 (copy), WaitForChoiceWithCooldown (copy), NotificationController (copy), PromptSkipCooldown (copy), HarvestedFruitHandleController (copy), u5 (copy), Rainbow (copy), Coins (copy), Normal (copy)
    local _ = p108.TotalSellValue or p109;
    local v110 = Networking.NPCS.CheckDailyDeal:Fire();

    if v110 then
        v110 = v110.Available;
    end;

    local v111 = SellFlags.DailyDealPrice(p108.TotalBaseValue or p108.TotalValue);
    TopText.NpcText(Steven, "Let me reconsider everything...", true);
    task.wait(0.5);
    local v112 = Networking.NPCS.AskBidAll:Fire();

    if not (v112 and v112.Success) then
        if v112 and v112.Reason == "Cooldown" then
            TopText.NpcText(Steven, string.format("Slow down! Ask me again in %d seconds.", v112.Remaining), true);
            u6 = os.clock() + v112.Remaining;
        elseif v112 and v112.Reason == "NoMoney" then
            TopText.NpcText(Steven, "You can\'t afford my appraisal fee for all of this!", true);
        else
            TopText.NpcText(Steven, "I can\'t do that right now.", true);
        end;

        task.wait(1);

        return;
    end;

    local NewTotalOffer = v112.NewTotalOffer;
    local v113 = v112.NewTotalSellValue or v112.NewTotalOffer;
    u6 = os.clock() + BidOddModule.BID_COOLDOWN;
    local v114;

    if (v112.IncreasedCount or 0) > 0 then
        u2:Play(0.2, 10, 1);

        if v112.HadLegendary then
            local v115 = {
                { "LEGENDARY " .. string.upper(p107.DisplayName) .. "! I offer you... ", "!" }
            };
            Accept.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
            Accept.TimePosition = 0;
            Accept.Playing = true;
            RadialFXController:PlayFX("Rainbow");
            local v116 = v115[math.random(#v115)];
            TopText.RainbowNpcText(Steven, v116[1], NumberUtils.Abbreviate(v113) .. Worlds.Current.CurrencySuffix, v116[2], true);
            task.wait(1);
            v114 = true;
        else
            Accept.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
            Accept.TimePosition = 0;
            Accept.Playing = true;
            RadialFXController:PlayFX("Green");
            TopText.NpcText(Steven, string.format("I can do <font color=\'#00FF00\'>%s</font> now. %d higher, %d unchanged.", NumberUtils.Abbreviate(v113) .. Worlds.Current.CurrencySuffix, v112.IncreasedCount or 0, v112.SameCount or 0), true);
            task.wait(1);
            v114 = false;
        end;
    else
        RadialFXController:PlayFX("Red");
        local v117 = v112.RefusedAll and "No deal. I\'m not raising any of these right now." or "Still <font color=\'#FFFF00\'>%s</font>. Nothing went higher this time.";
        TopText.NpcText(Steven, v112.RefusedAll and v117 and v117 or string.format(v117, NumberUtils.Abbreviate(v113) .. Worlds.Current.CurrencySuffix), true);
        Decline.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        Decline.Playing = true;
        u4:Play(0.2, 10, 1);
        task.wait(1);
        v114 = false;
    end;

    while true do
        local v118 = math.floor(NewTotalOffer * (BidOddModule.CostMultiplier - 1));
        local v119 = string.format("Ask for more <font color=\"#FF4444\">[COST: %s]</font>", NumberUtils.Abbreviate(v118) .. Worlds.Current.CurrencySuffix);
        local v120 = { v114 and string.format("Deal [SELL: %s]", NumberUtils.Abbreviate(v113) .. Worlds.Current.CurrencySuffix) or string.format("Deal <font color=\"#FFFF00\">[SELL: %s]</font>", NumberUtils.Abbreviate(v113) .. Worlds.Current.CurrencySuffix), v119 };
        local v121 = os.clock() < u6 and #v120 or nil;
        local v122;

        if v110 then
            local format = string.format;
            local v123 = NumberUtils.Abbreviate(v111) .. Worlds.Current.CurrencySuffix;
            table.insert(v120, format("Daily Deal [SELL: %s]", v123));
            v122 = #v120;
        else
            v122 = nil;
        end;

        table.insert(v120, "Nevermind");
        local v124 = {};

        if v114 then
            v124[1] = {
                before = "Deal ",
                after = "",
                colored = "[SELL: " .. (NumberUtils.Abbreviate(v113) .. Worlds.Current.CurrencySuffix) .. "]"
            };
        end;

        if v110 and v122 then
            v124[v122] = {
                before = "Daily Deal ",
                after = "",
                colored = "[SELL: " .. (NumberUtils.Abbreviate(v111) .. Worlds.Current.CurrencySuffix) .. "]"
            };
        end;

        if next(v124) == nil then
            v124 = nil;
        end;

        local v125, v126 = WaitForChoiceWithCooldown(p107, v120, 2, u6, v124, v121);

        if v126 == "__COOLDOWN__" then
            local v127 = u6 - os.clock();
            local v128 = math.max(0, v127);
            NotificationController:CreateNotification(`Please wait {math.ceil(v128)}s`, false, 2);
        elseif v121 and v125 == v121 then
            if PromptSkipCooldown() then
                u6 = 0;
            end;

            task.wait(0.3);
        else
            if v126 == "__DISMISSED__" then
                task.wait(0.2);

                return;
            end;

            if v125 ~= 2 then
                if v125 == 1 then
                    if v114 and p107.Character then
                        TopText.RainbowPlayerResponse(p107.Character, "Deal ", "[SELL: " .. (NumberUtils.Abbreviate(v113) .. Worlds.Current.CurrencySuffix) .. "]", "", true);
                    end;

                    task.wait(0.5);

                    if p108.FruitCount > 100 then
                        TopText.NpcText(Steven, "Calculating...", true);
                        task.wait(1);
                    end;

                    task.wait(0.25);
                    TopText.NpcText(Steven, "Let me get your payment...", true);
                    task.wait(0.5);
                    local v129 = Networking.NPCS.SellAll:Fire();

                    if not (v129 and v129.Success) then
                        TopText.NpcText(Steven, "Something went wrong.. try again.", true);
                        task.wait(1);

                        return;
                    end;

                    HarvestedFruitHandleController:DisconnectAllFruitTools();
                    u5:Play(0.2, 10, 1);

                    if v114 then
                        Rainbow.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                        Rainbow.TimePosition = 0;
                        Rainbow.Playing = true;
                        Networking.NPCS.LegendaryFx:Fire();
                        TopText.NpcCountUp(Steven, {
                            TextBefore = "Here\'s ",
                            Rainbow = true,
                            ShouldDisappear = false,
                            TextAfter = string.format(" for %d items!", v129.SoldCount),
                            FinalAmount = v129.SellPrice,
                            Format = Coins
                        });
                    else
                        Normal.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                        Normal.TimePosition = 0;
                        Normal.Playing = true;
                        TopText.NpcCountUp(Steven, {
                            TextBefore = "Here\'s ",
                            Color = "#00FF00",
                            ShouldDisappear = false,
                            TextAfter = string.format(" for %d items!", v129.SoldCount),
                            FinalAmount = v129.SellPrice,
                            Format = Coins
                        });
                    end;

                    task.wait(1);

                    return;
                end;

                if not v110 or v125 ~= v122 then
                    task.wait(0.5);

                    return;
                end;

                task.wait(0.5);

                if p108.FruitCount > 100 then
                    TopText.NpcText(Steven, "Calculating...", true);
                    task.wait(1);
                end;

                task.wait(0.25);
                TopText.NpcText(Steven, "Daily deal it is! Let me get your payment...", true);
                task.wait(0.5);
                local v130 = Networking.NPCS.UseDailyDealAll:Fire();

                if not (v130 and v130.Success) then
                    if v130 and v130.Reason == "NotAvailable" then
                        TopText.NpcText(Steven, "That deal expired.. sorry!", true);
                    else
                        TopText.NpcText(Steven, "Something went wrong.. try again.", true);
                    end;

                    task.wait(1);

                    return;
                end;

                HarvestedFruitHandleController:DisconnectAllFruitTools();
                u5:Play(0.2, 10, 1);
                Rainbow.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                Rainbow.TimePosition = 0;
                Rainbow.Playing = true;
                TopText.NpcCountUp(Steven, {
                    TextBefore = "DAILY DEAL! Here\'s ",
                    Rainbow = true,
                    ShouldDisappear = false,
                    TextAfter = string.format(" for %d items!", v130.SoldCount),
                    FinalAmount = v130.SellPrice,
                    Format = Coins
                });
                task.wait(1);

                return;
            end;

            task.wait(0.5);
            TopText.NpcText(Steven, "Let me reconsider everything...", true);
            task.wait(0.5);
            local v131 = Networking.NPCS.AskBidAll:Fire();

            if v131 and v131.Success then
                NewTotalOffer = v131.NewTotalOffer;
                v113 = v131.NewTotalSellValue or v131.NewTotalOffer;
                u6 = os.clock() + BidOddModule.BID_COOLDOWN;

                if (v131.IncreasedCount or 0) > 0 then
                    u2:Play(0.2, 10, 1);

                    if v131.HadLegendary then
                        local v132 = {
                            { "LEGENDARY " .. string.upper(p107.DisplayName) .. "! I offer you... ", "!" }
                        };
                        Accept.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                        Accept.TimePosition = 0;
                        Accept.Playing = true;
                        RadialFXController:PlayFX("Rainbow");
                        local v133 = v132[math.random(#v132)];
                        TopText.RainbowNpcText(Steven, v133[1], NumberUtils.Abbreviate(v113) .. Worlds.Current.CurrencySuffix, v133[2], true);
                        task.wait(1);
                        v114 = true;
                    else
                        Accept.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                        Accept.TimePosition = 0;
                        Accept.Playing = true;
                        RadialFXController:PlayFX("Green");
                        TopText.NpcText(Steven, string.format("I can do <font color=\'#00FF00\'>%s</font> now. %d higher, %d unchanged.", NumberUtils.Abbreviate(v113) .. Worlds.Current.CurrencySuffix, v131.IncreasedCount or 0, v131.SameCount or 0), true);
                        task.wait(1);
                        v114 = false;
                    end;
                else
                    RadialFXController:PlayFX("Red");
                    local v134 = v131.RefusedAll and "No deal. I\'m not raising any of these right now." or "Still <font color=\'#FFFF00\'>%s</font>. Nothing went higher this time.";
                    TopText.NpcText(Steven, v131.RefusedAll and v134 and v134 or string.format(v134, NumberUtils.Abbreviate(v113) .. Worlds.Current.CurrencySuffix), true);
                    Decline.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                    Decline.Playing = true;
                    u4:Play(0.2, 10, 1);
                    task.wait(1);
                    v114 = false;
                end;
            else
                if v131 and v131.Reason == "Cooldown" then
                    TopText.NpcText(Steven, string.format("Slow down! Ask me again in %d seconds.", v131.Remaining), true);
                    u6 = os.clock() + v131.Remaining;
                elseif v131 and v131.Reason == "NoMoney" then
                    TopText.NpcText(Steven, "You can\'t afford my appraisal fee for all of this!", true);
                else
                    TopText.NpcText(Steven, "I can\'t do that right now.", true);
                end;

                task.wait(1);
            end;
        end;
    end;
end;

local function RunSingleBargainLoop(p135, p136, p137) -- Line: 973
    -- upvalues: SellFlags (copy), Networking (copy), TopText (copy), Steven (copy), u6 (ref), BidOddModule (copy), u2 (copy), Accept (copy), NumberUtils (copy), Worlds (copy), RadialFXController (copy), Decline (copy), u4 (copy), WaitForChoiceWithCooldown (copy), NotificationController (copy), PromptSkipCooldown (copy), GetHeldFruitInfo (copy), Rainbow (copy), u5 (copy), Coins (copy), Normal (copy)
    local v138 = SellFlags.Apply(p136.FruitName, p137);
    math.floor(v138);
    local v139 = Networking.NPCS.CheckDailyDeal:Fire();

    if v139 then
        v139 = v139.Available;
    end;

    local v140 = SellFlags.DailyDealPrice(p136.BaseValue);
    TopText.NpcText(Steven, "Let me reconsider...", true);
    task.wait(0.5);
    local v141 = Networking.NPCS.AskBid:Fire(p136.FruitId);

    if not (v141 and v141.Success) then
        if v141 and v141.Reason == "Cooldown" then
            TopText.NpcText(Steven, string.format("Slow down! Ask me again in %d seconds.", v141.Remaining), true);
            u6 = os.clock() + v141.Remaining;
        elseif v141 and v141.Reason == "NoMoney" then
            TopText.NpcText(Steven, "You can\'t afford my appraisal fee!", true);
        elseif v141 and v141.Reason == "Favorited" then
            TopText.NpcText(Steven, "You cannot bargain favorited fruit!", true);
        else
            TopText.NpcText(Steven, "I can\'t do that right now.", true);
        end;

        task.wait(1);

        return;
    end;

    local NewOffer = v141.NewOffer;
    local v142 = v141.NewSellValue or v141.NewOffer;
    u6 = os.clock() + BidOddModule.BID_COOLDOWN;
    local v143;

    if v141.Won then
        u2:Play(0.2, 10, 1);

        if v141.Multiplier == 20 then
            local v144 = {
                { "LEGENDARY " .. string.upper(p135.DisplayName) .. "! I offer you... ", "!" }
            };
            Accept.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
            Accept.TimePosition = 0;
            Accept.Playing = true;
            local v145 = v144[math.random(#v144)];
            TopText.RainbowNpcText(Steven, v145[1], NumberUtils.Abbreviate(v142) .. Worlds.Current.CurrencySuffix, v145[2], true);
            RadialFXController:PlayFX("Rainbow");
            task.wait(1);
            v143 = true;
        else
            local v146 = { "Actually, I can do <font color=\'#00FF00\'>%s</font>!", "On second thought.. <font color=\'#00FF00\'>%s</font>!", "You drive a hard bargain. <font color=\'#00FF00\'>%s</font>." };
            Accept.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
            Accept.TimePosition = 0;
            Accept.Playing = true;
            TopText.NpcText(Steven, v146[math.random(#v146)]:format(NumberUtils.Abbreviate(v142) .. Worlds.Current.CurrencySuffix), true);
            RadialFXController:PlayFX("Green");
            task.wait(1);
            v143 = false;
        end;
    else
        local v147 = { "Sorry, <font color=\'#FFFF00\'>%s</font> is the best I can do.", "I thought about it.. <font color=\'#FFFF00\'>%s</font>. Can\'t go higher.", "No luck. Still <font color=\'#FFFF00\'>%s</font>." };
        Decline.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        Decline.TimePosition = 0;
        Decline.Playing = true;
        u4:Play(0.2, 10, 1);
        TopText.NpcText(Steven, v147[math.random(#v147)]:format(NumberUtils.Abbreviate(v142) .. Worlds.Current.CurrencySuffix), true);
        RadialFXController:PlayFX("Red");
        task.wait(1);
        v143 = false;
    end;

    while true do
        local v148 = math.floor(NewOffer * (BidOddModule.CostMultiplier - 1));
        local v149 = string.format("Ask for more <font color=\"#FF4444\">[COST: %s]</font>", NumberUtils.Abbreviate(v148) .. Worlds.Current.CurrencySuffix);
        local v150 = { v143 and string.format("Deal [SELL: %s]", NumberUtils.Abbreviate(v142) .. Worlds.Current.CurrencySuffix) or string.format("Deal <font color=\"#FFFF00\">[SELL: %s]</font>", NumberUtils.Abbreviate(v142) .. Worlds.Current.CurrencySuffix), v149 };
        local v151 = nil;
        local v152;

        if os.clock() < u6 then
            table.insert(v150, "<font color=\"#00FF00\">Skip Cooldown 3R$</font>");
            v152 = #v150;
        else
            v152 = nil;
        end;

        if v139 then
            local format = string.format;
            local v153 = NumberUtils.Abbreviate(v140) .. Worlds.Current.CurrencySuffix;
            table.insert(v150, format("Daily Deal [SELL: %s]", v153));
            v151 = #v150;
        end;

        table.insert(v150, "Nevermind");
        local v154 = {};

        if v143 then
            v154[1] = {
                before = "Deal ",
                after = "",
                colored = "[SELL: " .. (NumberUtils.Abbreviate(v142) .. Worlds.Current.CurrencySuffix) .. "]"
            };
        end;

        if v139 and v151 then
            v154[v151] = {
                before = "Daily Deal ",
                after = "",
                colored = "[SELL: " .. (NumberUtils.Abbreviate(v140) .. Worlds.Current.CurrencySuffix) .. "]"
            };
        end;

        if next(v154) == nil then
            v154 = nil;
        end;

        local v155, v156 = WaitForChoiceWithCooldown(p135, v150, 2, u6, v154, v152);

        if v156 == "__COOLDOWN__" then
            local v157 = u6 - os.clock();
            local v158 = math.max(0, v157);
            NotificationController:CreateNotification(`Please wait {math.ceil(v158)}s`, false, 2);
        elseif v152 and v155 == v152 then
            if PromptSkipCooldown() then
                u6 = 0;
            end;

            task.wait(0.3);
        else
            if v156 == "__DISMISSED__" then
                task.wait(0.2);

                return;
            end;

            if v155 ~= 2 then
                if v155 == 1 then
                    if v143 and p135.Character then
                        TopText.RainbowPlayerResponse(p135.Character, "Deal ", "[SELL: " .. (NumberUtils.Abbreviate(v142) .. Worlds.Current.CurrencySuffix) .. "]", "", true);
                    end;

                    task.wait(0.5);
                    local v159, v160 = GetHeldFruitInfo(p135);

                    if not v159 then
                        TopText.NpcText(Steven, v160, true);
                        task.wait(1);

                        return;
                    end;

                    local Tool = v159.Tool;
                    task.wait(0.25);
                    TopText.NpcText(Steven, "Let me get your payment...", true);
                    task.wait(0.5);
                    local v161 = Networking.NPCS.SellFruit:Fire(v159.FruitId);

                    if v161 and v161.Success then
                        if v143 then
                            Networking.NPCS.LegendaryFx:Fire();
                            Rainbow.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                            Rainbow.TimePosition = 0;
                            Rainbow.Playing = true;
                            local v162 = { { "Pleasure doing business! Here\'s ", "." }, { "Sold! ", ", all yours." }, { "Done deal. ", " coming your way!" } };
                            local v163 = v162[math.random(#v162)];
                            u5:Play(0.2, 10, 1);
                            TopText.NpcCountUp(Steven, {
                                Rainbow = true,
                                ShouldDisappear = true,
                                TextBefore = v163[1],
                                TextAfter = v163[2],
                                FinalAmount = v161.SellPrice,
                                Format = Coins
                            });
                        else
                            Normal.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                            Normal.TimePosition = 0;
                            Normal.Playing = true;
                            local v164 = { { "Pleasure doing business! Here\'s ", "." }, { "Sold! ", ", all yours." }, { "Done deal. ", " coming your way!" } };
                            local v165 = v164[math.random(#v164)];
                            u5:Play(0.2, 10, 1);
                            TopText.NpcCountUp(Steven, {
                                Color = "#00FF00",
                                ShouldDisappear = true,
                                TextBefore = v165[1],
                                TextAfter = v165[2],
                                FinalAmount = v161.SellPrice,
                                Format = Coins
                            });
                        end;

                        if Tool and Tool.Parent then
                            Tool:Destroy();
                        end;
                    elseif v161 and v161.Reason == "Favorited" then
                        TopText.NpcText(Steven, "You cannot sell favorited fruit!", true);
                    else
                        TopText.NpcText(Steven, "Something went wrong.. try again.", true);
                    end;

                    task.wait(1);

                    return;
                end;

                if not v139 or v155 ~= v151 then
                    task.wait(0.5);

                    return;
                end;

                task.wait(0.5);
                local v166, v167 = GetHeldFruitInfo(p135);

                if not v166 then
                    TopText.NpcText(Steven, v167, true);
                    task.wait(1);

                    return;
                end;

                local Tool = v166.Tool;
                task.wait(0.25);
                TopText.NpcText(Steven, "Daily deal! Let me get your payment...", true);
                task.wait(0.5);
                local v168 = Networking.NPCS.UseDailyDealSingle:Fire(v166.FruitId);

                if v168 and v168.Success then
                    u5:Play(0.2, 10, 1);
                    Rainbow.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                    Rainbow.TimePosition = 0;
                    Rainbow.Playing = true;
                    TopText.NpcCountUp(Steven, {
                        TextBefore = "DAILY DEAL! Here\'s ",
                        TextAfter = "!",
                        Rainbow = true,
                        ShouldDisappear = false,
                        FinalAmount = v168.SellPrice,
                        Format = Coins
                    });

                    if Tool and Tool.Parent then
                        Tool:Destroy();
                    end;
                elseif v168 and v168.Reason == "NotAvailable" then
                    TopText.NpcText(Steven, "That deal expired.. sorry!", true);
                elseif v168 and v168.Reason == "Favorited" then
                    TopText.NpcText(Steven, "You cannot sell favorited fruit!", true);
                else
                    TopText.NpcText(Steven, "Something went wrong.. try again.", true);
                end;

                task.wait(1);

                return;
            end;

            task.wait(0.5);
            TopText.NpcText(Steven, "Let me reconsider...", true);
            task.wait(0.5);
            local v169, v170 = GetHeldFruitInfo(p135);

            if not v169 then
                TopText.NpcText(Steven, v170, true);
                task.wait(1);

                return;
            end;

            local v171 = Networking.NPCS.AskBid:Fire(v169.FruitId);

            if v171 and v171.Success then
                NewOffer = v171.NewOffer;
                v142 = v171.NewSellValue or v171.NewOffer;
                u6 = os.clock() + BidOddModule.BID_COOLDOWN;

                if v171.Won then
                    u2:Play(0.2, 10, 1);

                    if v171.Multiplier == 20 then
                        local v172 = {
                            { "LEGENDARY " .. string.upper(p135.DisplayName) .. "! I offer you... ", "!" }
                        };
                        Accept.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                        Accept.TimePosition = 0;
                        Accept.Playing = true;
                        local v173 = v172[math.random(#v172)];
                        TopText.RainbowNpcText(Steven, v173[1], NumberUtils.Abbreviate(v142) .. Worlds.Current.CurrencySuffix, v173[2], true);
                        RadialFXController:PlayFX("Rainbow");
                        task.wait(1);
                        v143 = true;
                    else
                        local v174 = { "Actually, I can do <font color=\'#00FF00\'>%s</font>!", "On second thought.. <font color=\'#00FF00\'>%s</font>!", "You drive a hard bargain. <font color=\'#00FF00\'>%s</font>." };
                        Accept.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                        Accept.TimePosition = 0;
                        Accept.Playing = true;
                        TopText.NpcText(Steven, v174[math.random(#v174)]:format(NumberUtils.Abbreviate(v142) .. Worlds.Current.CurrencySuffix), true);
                        RadialFXController:PlayFX("Green");
                        task.wait(1);
                        v143 = false;
                    end;
                else
                    local v175 = { "Sorry, <font color=\'#FFFF00\'>%s</font> is the best I can do.", "I thought about it.. <font color=\'#FFFF00\'>%s</font>. Can\'t go higher.", "No luck. Still <font color=\'#FFFF00\'>%s</font>." };
                    Decline.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                    Decline.TimePosition = 0;
                    Decline.Playing = true;
                    u4:Play(0.2, 10, 1);
                    TopText.NpcText(Steven, v175[math.random(#v175)]:format(NumberUtils.Abbreviate(v142) .. Worlds.Current.CurrencySuffix), true);
                    RadialFXController:PlayFX("Red");
                    task.wait(1);
                    v143 = false;
                end;
            else
                if v171 and v171.Reason == "Cooldown" then
                    TopText.NpcText(Steven, string.format("Slow down! Ask me again in %d seconds.", v171.Remaining), true);
                    u6 = os.clock() + v171.Remaining;
                elseif v171 and v171.Reason == "NoMoney" then
                    TopText.NpcText(Steven, "You can\'t afford my appraisal fee!", true);
                elseif v171 and v171.Reason == "Favorited" then
                    TopText.NpcText(Steven, "You cannot bargain favorited fruit!", true);
                else
                    TopText.NpcText(Steven, "I can\'t do that right now.", true);
                end;

                task.wait(1);
            end;
        end;
    end;
end;

local function PlayDoubleOrNothingWin(p176, p177, p178) -- Line: 1310
    -- upvalues: u2 (copy), Accept (copy), Rainbow (copy), RadialFXController (copy), Networking (copy), TopText (copy), Steven (copy), Coins (copy)
    u2:Play(0.2, 10, 1);

    if p177 < 2 then
        Accept.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        Accept.TimePosition = 0;
        Accept.Playing = true;
        RadialFXController:PlayFX("Green");
        TopText.NpcCountUp(Steven, {
            TextBefore = "Congrats! ",
            TextAfter = "",
            Color = "#00FF00",
            ShouldDisappear = false,
            FinalAmount = p178,
            Format = Coins
        });

        return;
    end;

    Accept.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
    Accept.TimePosition = 0;
    Accept.Playing = true;
    Rainbow.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
    Rainbow.TimePosition = 0;
    Rainbow.Playing = true;
    RadialFXController:PlayFX("Rainbow");
    Networking.NPCS.LegendaryFx:Fire();
    TopText.NpcCountUp(Steven, {
        TextBefore = "Congrats! ",
        Rainbow = true,
        ShouldDisappear = false,
        TextAfter = string.format(" 🔥%d", p177),
        FinalAmount = p178,
        Format = Coins
    });
end;

local function RunDoubleOrNothingLoop(p179, p180) -- Line: 1347
    -- upvalues: Networking (copy), TopText (copy), Steven (copy), Worlds (copy), u7 (ref), WaitForChoice (copy), u9 (copy), u8 (ref), u4 (copy), Decline (copy), RadialFXController (copy), HarvestedFruitHandleController (copy), OfferStreakRevive (copy), u2 (copy), Accept (copy), Coins (copy), NotificationController (copy), PlayDoubleOrNothingWin (copy), NumberUtils (copy), u5 (copy), Rainbow (copy), Normal (copy)
    local v181 = Networking.NPCS.PreviewSellAll:Fire();

    if v181 and (v181.FruitCount or 0) > 100 then
        TopText.NpcText(Steven, "Calculating...", true);
        task.wait(0.5);
    end;

    if not v181 or (v181.FruitCount or 0) <= 0 then
        TopText.NpcText(Steven, "You don\'t have any fruits!", true);
        task.wait(1);

        return;
    end;

    local leaderstats = p179:FindFirstChild("leaderstats");

    if leaderstats then
        leaderstats = leaderstats:FindFirstChild(Worlds.WalletStatName(p179));
    end;

    if (not (leaderstats and leaderstats:IsA("IntValue")) and 0 or leaderstats.Value) <= 0 then
        TopText.NpcText(Steven, `Come back when you've got some {string.lower(Worlds.Current.CurrencyName)} to your name!`, true);
        task.wait(1);

        return;
    end;

    if not u7 then
        u7 = true;
        TopText.NpcText(Steven, "Are you sure? You\'re risking EVERY fruit in your inventory!", true);
        task.wait(0.1);
        local v182, v183 = WaitForChoice(p179, { "Yes", "Nevermind" });

        if v183 == "__DISMISSED__" or v182 ~= 1 then
            task.wait(0.4);
            TopText.NpcText(Steven, u9[math.random(#u9)], true);
            task.wait(1);

            return;
        end;
    end;

    task.wait(0.4);
    TopText.NpcText(Steven, "Double or nothing... feeling lucky?", true);
    task.wait(0.6);
    local v184 = true;
    local v185 = 0;

    while true do
        if v184 then
            v184 = false;
            u8 = true;
            local v186 = Networking.NPCS.DoubleOrNothing:Fire();
            print("[DoubleOrNothing] roll result:", v186);

            if v186 and v186.Busted then
                u8 = false;
                u4:Play(0.2, 10, 1);
                Decline.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                Decline.TimePosition = 0;
                Decline.Playing = true;
                RadialFXController:PlayFX("Red");
                TopText.NpcText(Steven, "Better luck next time!", true);
                HarvestedFruitHandleController:DisconnectAllFruitTools();
                task.wait(1);
                local v187 = v186.Wins or 0;

                if not v186.CanRevive or v187 < 1 then
                    return;
                end;

                if not OfferStreakRevive(p179, v187, v186.InventoryValue or 0) then
                    if p180 then
                        p180();
                    end;

                    return;
                end;

                u2:Play(0.2, 10, 1);
                Accept.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                Accept.TimePosition = 0;
                Accept.Playing = true;
                RadialFXController:PlayFX("Green");
                u8 = true;
                v185 = v186.LostValue or 0;
                TopText.NpcCountUp(Steven, {
                    TextBefore = "Streak revived! ",
                    TextAfter = "",
                    Color = "#00FF00",
                    ShouldDisappear = false,
                    FinalAmount = v185,
                    Format = Coins
                });
                NotificationController:CreateNotification(string.format("Revived Streak %d🔥!", v187));
                task.wait(1);
            else
                if not (v186 and v186.Won) then
                    if v186 and v186.Reason == "NoFruits" then
                        u8 = false;
                        TopText.NpcText(Steven, "You don\'t have any fruits!", true);
                        task.wait(1);

                        return;
                    end;

                    if v186 then
                        v186 = v186.Reason;
                    end;

                    warn("[DoubleOrNothing] unexpected roll result, reason:", v186);
                    u8 = false;
                    TopText.NpcText(Steven, "I can\'t do that right now.", true);
                    task.wait(1);

                    return;
                end;

                local Wins = v186.Wins;
                v185 = v186.Pot;
                HarvestedFruitHandleController:DisconnectAllFruitTools();
                PlayDoubleOrNothingWin(p179, Wins, v185);
                task.wait(1);
            end;
        end;

        local v188 = { string.format("Sell <font color=\"#FFFF00\">[SELL: %s]</font>", NumberUtils.Abbreviate(v185) .. Worlds.Current.CurrencySuffix) };
        table.insert(v188, "Double or Nothing");
        local v189 = #v188;
        local v190, v191 = WaitForChoice(p179, v188);
        local v192 = v191 == "__DISMISSED__";

        if v192 or v190 == 1 then
            if not v192 then
                task.wait(0.4);
                TopText.NpcText(Steven, "Let me get your payment...", true);
                task.wait(0.5);
            end;

            local v193 = Networking.NPCS.CashOutDoubleOrNothing:Fire();

            if not (v193 and v193.Success) then
                if not v192 then
                    TopText.NpcText(Steven, "Something went wrong.. try again.", true);
                    task.wait(1);
                end;

                return;
            end;

            u8 = false;
            HarvestedFruitHandleController:DisconnectAllFruitTools();
            u5:Play(0.2, 10, 1);

            if (v193.Wins or 0) >= 2 then
                Rainbow.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                Rainbow.TimePosition = 0;
                Rainbow.Playing = true;
                TopText.NpcCountUp(Steven, {
                    TextBefore = "Here\'s ",
                    Rainbow = true,
                    ShouldDisappear = false,
                    TextAfter = string.format(" for %d items!", v193.SoldCount or 0),
                    FinalAmount = v193.SellPrice,
                    Format = Coins
                });
            else
                Normal.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                Normal.TimePosition = 0;
                Normal.Playing = true;
                TopText.NpcCountUp(Steven, {
                    TextBefore = "Here\'s ",
                    Color = "#00FF00",
                    ShouldDisappear = false,
                    TextAfter = string.format(" for %d items!", v193.SoldCount or 0),
                    FinalAmount = v193.SellPrice,
                    Format = Coins
                });
            end;

            task.wait(1);

            return;
        end;

        if v189 and v190 == v189 then
            task.wait(0.4);
            TopText.NpcText(Steven, "Double or nothing!", true);
            task.wait(0.5);
            v184 = true;
        end;
    end;
end;

local function StartDailyDealRainbow(u194, u195) -- Line: 1571
    -- upvalues: TopText (copy)
    task.spawn(function() -- Line: 1572
        -- upvalues: u194 (copy), TopText (ref), u195 (copy)
        local Billboard_UI = u194.PlayerGui:FindFirstChild("Billboard_UI");

        if Billboard_UI then
            Billboard_UI = Billboard_UI:FindFirstChild("Objects");
        end;

        if not Billboard_UI then
            return;
        end;

        local v196 = os.clock() + 5;
        local v197 = nil;

        while os.clock() < v196 do
            for _, child in Billboard_UI:GetChildren() do
                local Frame = child:FindFirstChild("Frame");

                if Frame then
                    Frame = Frame:FindFirstChild("Frame");
                end;

                if Frame then
                    Frame = Frame:FindFirstChild("Text_Element");
                end;

                if Frame and (Frame:IsA("TextLabel") and Frame:GetAttribute("Text") == "Daily Deal!") then
                    v197 = Frame;
                    break;
                end;
            end;

            if v197 then
                break;
            end;

            task.wait();
        end;

        if not v197 then
            return;
        end;

        local v198 = 0;

        while v197 and v197.Parent do
            v198 = v198 + task.wait(0.04);

            if not (v197 and v197.Parent) then
                break;
            end;

            v197.Text = "[\"Daily Deal " .. TopText.BuildRainbowText(u195, v198) .. "\"]";
        end;
    end);
end;

local function DailyDealOperation() -- Line: 1606
    -- upvalues: Networking (copy), TopText (copy), Steven (copy), HarvestedFruitHandleController (copy), u5 (copy), Accept (copy), Rainbow (copy), RadialFXController (copy), Coins (copy)
    task.wait(0.5);
    local _ = game.Players.LocalPlayer;
    local v199 = Networking.NPCS.PreviewSellAll:Fire();

    if v199 and (v199.FruitCount or 0) > 100 then
        TopText.NpcText(Steven, "Calculating...", true);
        task.wait(1);
    end;

    if not v199 or (v199.FruitCount or 0) <= 0 then
        TopText.NpcText(Steven, "You don\'t have anything to sell!", true);
        task.wait(1);

        return;
    end;

    task.wait(0.25);
    TopText.NpcText(Steven, "Daily deal it is! Let me get your payment...", true);
    task.wait(0.5);
    local v200 = Networking.NPCS.UseDailyDealAll:Fire();

    if not (v200 and v200.Success) then
        if v200 and v200.Reason == "NotAvailable" then
            TopText.NpcText(Steven, "That deal expired.. sorry!", true);
        else
            TopText.NpcText(Steven, "Something went wrong.. try again.", true);
        end;

        task.wait(1);

        return;
    end;

    HarvestedFruitHandleController:DisconnectAllFruitTools();
    u5:Play(0.2, 10, 1);
    Accept.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
    Accept.TimePosition = 0;
    Accept.Playing = true;
    Rainbow.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
    Rainbow.TimePosition = 0;
    Rainbow.Playing = true;
    RadialFXController:PlayFX("Rainbow");
    Networking.NPCS.LegendaryFx:Fire();
    TopText.NpcCountUp(Steven, {
        TextBefore = "DAILY DEAL! Here\'s ",
        Rainbow = true,
        ShouldDisappear = false,
        TextAfter = string.format(" for %d items!", v200.SoldCount),
        FinalAmount = v200.SellPrice,
        Format = Coins
    });
    task.wait(1);
end;

return function() -- Line: 1658
    -- upvalues: SellFlags (copy), Worlds (copy), ABTests (copy), Networking (copy), NumberUtils (copy), TopText (copy), GuiController (copy), DailyDealOperation (copy), Steven (copy), HarvestedFruitHandleController (copy), u5 (copy), Normal (copy), Coins (copy), GetHeldFruitInfo (copy), WaitForChoice (copy), PromptConfirm (copy), BidOddModule (copy), RunInventoryBargainLoop (copy), RunSingleBargainLoop (copy), RunDoubleOrNothingLoop (copy), PetData (copy), u1 (copy), ProximityPrompt (copy), u8 (ref)
    local LocalPlayer = game.Players.LocalPlayer;
    local u201 = {};
    local u202 = false;
    local u203 = "";
    local u204 = nil;

    local function RebuildPromptList() -- Line: 1674
        -- upvalues: SellFlags (ref), LocalPlayer (copy), Worlds (ref), u201 (copy), u202 (ref), ABTests (ref)
        local v205 = SellFlags.DoubleOrNothingEnabled:Get();
        local v206 = LocalPlayer:GetAttribute("SellModeOverride");

        if v206 == "Bargain" or v206 == "DoubleOrNothing" then
            v205 = true;
        else
            v206 = "DoubleOrNothing";
        end;

        if workspace:GetAttribute("InTutorial") == true then
            v205 = false;
        else
            local v207 = LocalPlayer;
            local leaderstats = v207:FindFirstChild("leaderstats");

            if leaderstats then
                leaderstats = leaderstats:FindFirstChild(Worlds.WalletStatName(v207));
            end;

            if (not (leaderstats and leaderstats:IsA("IntValue")) and 0 or leaderstats.Value) <= 0 then
                v205 = false;
            end;
        end;

        table.clear(u201);

        if u202 then
            table.insert(u201, "Daily Deal!");
        end;

        table.insert(u201, "Sell Inventory!");
        table.insert(u201, "Sell This!");
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChildOfClass("Tool");
        end;

        local v208;

        if typeof(Character) == "Instance" then
            v208 = Character:GetAttribute("Pet") ~= nil;
        else
            v208 = false;
        end;

        if v208 then
            table.insert(u201, "Sell All Pets!");
        end;

        table.insert(u201, "How much is this worth?");

        if v205 then
            if v206 == "DoubleOrNothing" then
                table.insert(u201, "Double or Nothing!");
            else
                table.insert(u201, "Bargain!");
            end;
        end;

        if ABTests.GetAttribute(game.Players.LocalPlayer, "Sell.PriceStock.Enabled", false) == true then
            local v209 = LocalPlayer;
            local leaderstats = v209:FindFirstChild("leaderstats");

            if leaderstats then
                leaderstats = leaderstats:FindFirstChild(Worlds.WalletStatName(v209));
            end;

            if (not (leaderstats and leaderstats:IsA("IntValue")) and 0 or leaderstats.Value) >= 10000 then
                table.insert(u201, "View Sell Prices!");
            end;
        end;

        table.insert(u201, "Nevermind");
    end;

    RebuildPromptList();
    LocalPlayer:GetAttributeChangedSignal("SellModeOverride"):Connect(RebuildPromptList);
    workspace:GetAttributeChangedSignal("InTutorial"):Connect(RebuildPromptList);
    ABTests.PlayerUpdated:Connect(function(p210) -- Line: 1733
        -- upvalues: LocalPlayer (copy), RebuildPromptList (copy)
        if p210 == LocalPlayer then
            RebuildPromptList();
        end;
    end);
    task.spawn(function() -- Line: 1738
        -- upvalues: Worlds (ref), LocalPlayer (copy), RebuildPromptList (copy)
        local v211 = Worlds.WaitForWalletStat(LocalPlayer, 30);

        if v211 then
            v211:GetPropertyChangedSignal("Value"):Connect(RebuildPromptList);
            RebuildPromptList();
        end;
    end);

    local function RefreshDailyDealEntry() -- Line: 1752
        -- upvalues: Networking (ref), SellFlags (ref), u202 (ref), u203 (ref), NumberUtils (ref), Worlds (ref), RebuildPromptList (copy), LocalPlayer (copy), TopText (ref)
        local v212 = Networking.NPCS.CheckDailyDeal:Fire();
        local v213 = Networking.NPCS.PreviewSellAll:Fire();
        local v214 = v213 and (v213.FruitCount or 0) or 0;
        local v215 = not v213 and 0 or SellFlags.DailyDealPrice(v213.TotalBaseValue or (v213.TotalValue or 0));

        if v212 and (v212.Available and (v214 > 0 and v215 > 0)) then
            u202 = true;
            u203 = "[" .. (NumberUtils.Abbreviate(v215) .. Worlds.Current.CurrencySuffix) .. "]";
        else
            u202 = false;
            u203 = "";
        end;

        RebuildPromptList();

        if u202 then
            local u216 = LocalPlayer;
            local u217 = u203;
            task.spawn(function() -- Line: 1572
                -- upvalues: u216 (copy), TopText (ref), u217 (copy)
                local Billboard_UI = u216.PlayerGui:FindFirstChild("Billboard_UI");

                if Billboard_UI then
                    Billboard_UI = Billboard_UI:FindFirstChild("Objects");
                end;

                if not Billboard_UI then
                    return;
                end;

                local v218 = os.clock() + 5;
                local v219 = nil;

                while os.clock() < v218 do
                    for _, child in Billboard_UI:GetChildren() do
                        local Frame = child:FindFirstChild("Frame");

                        if Frame then
                            Frame = Frame:FindFirstChild("Frame");
                        end;

                        if Frame then
                            Frame = Frame:FindFirstChild("Text_Element");
                        end;

                        if Frame and (Frame:IsA("TextLabel") and Frame:GetAttribute("Text") == "Daily Deal!") then
                            v219 = Frame;
                            break;
                        end;
                    end;

                    if v219 then
                        break;
                    end;

                    task.wait();
                end;

                if not v219 then
                    return;
                end;

                local v220 = 0;

                while v219 and v219.Parent do
                    v220 = v220 + task.wait(0.04);

                    if not (v219 and v219.Parent) then
                        break;
                    end;

                    v219.Text = "[\"Daily Deal " .. TopText.BuildRainbowText(u217, v220) .. "\"]";
                end;
            end);
        end;
    end;

    local u259 = {
        ["View Sell Prices!"] = function() -- Line: 1780
            -- upvalues: GuiController (ref)
            GuiController:Open("FruitStockPrice");
        end,

        ["Daily Deal!"] = DailyDealOperation,

        ["Sell Inventory!"] = function() -- Line: 1793
            -- upvalues: Networking (ref), TopText (ref), Steven (ref), HarvestedFruitHandleController (ref), u5 (ref), Normal (ref), Coins (ref)
            local _ = game.Players.LocalPlayer;
            local v221 = Networking.NPCS.PreviewSellAll:Fire();

            if v221 and (v221.FruitCount or 0) > 100 then
                TopText.NpcText(Steven, "Calculating...", true);
                task.wait(0.5);
            end;

            if not v221 or (v221.FruitCount or 0) <= 0 then
                TopText.NpcText(Steven, "You don\'t have anything to sell!", true);
                task.wait(1);

                return;
            end;

            task.wait(0.25);
            TopText.NpcText(Steven, "Let me get your payment...", true);
            task.wait(0.5);
            local v222 = Networking.NPCS.SellAll:Fire();

            if not (v222 and v222.Success) then
                TopText.NpcText(Steven, "Something went wrong.. try again.", true);
                task.wait(1);

                return;
            end;

            HarvestedFruitHandleController:DisconnectAllFruitTools();
            u5:Play(0.2, 10, 1);
            Normal.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
            Normal.TimePosition = 0;
            Normal.Playing = true;
            TopText.NpcCountUp(Steven, {
                TextBefore = "Here\'s ",
                Color = "#00FF00",
                ShouldDisappear = false,
                TextAfter = string.format(" for %d items!", v222.SoldCount),
                FinalAmount = v222.SellPrice,
                Format = Coins
            });
            task.wait(1);
        end,

        ["Sell This!"] = function() -- Line: 1836
            -- upvalues: GetHeldFruitInfo (ref), TopText (ref), Steven (ref), Networking (ref), u5 (ref), Normal (ref), Coins (ref)
            task.wait(0.5);
            local v223, v224 = GetHeldFruitInfo(game.Players.LocalPlayer);

            if not v223 then
                TopText.NpcText(Steven, v224, true);
                task.wait(1);

                return;
            end;

            if v223 == "Pet" then
                local Tool = v224.Tool;
                local v225 = Networking.NPCS.SellPet:Fire(v224.PetID);

                if v225 and v225.Success then
                    u5:Play(0.2, 10, 1);
                    Normal.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                    Normal.TimePosition = 0;
                    Normal.Playing = true;
                    TopText.NpcCountUp(Steven, {
                        TextBefore = "Here\'s ",
                        TextAfter = "!",
                        Color = "#00FF00",
                        ShouldDisappear = false,
                        FinalAmount = v225.SellPrice,
                        Format = Coins
                    });

                    if Tool and Tool.Parent then
                        Tool:Destroy();
                    end;
                elseif v225 and v225.Reason == "Favorited" then
                    TopText.NpcText(Steven, "You cannot sell favorited pets!", true);
                else
                    TopText.NpcText(Steven, "Something went wrong.. try again.", true);
                end;

                task.wait(1);

                return;
            end;

            local Tool = v223.Tool;
            local v226 = Networking.NPCS.SellFruit:Fire(v223.FruitId);

            if v226 and v226.Success then
                u5:Play(0.2, 10, 1);
                Normal.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                Normal.TimePosition = 0;
                Normal.Playing = true;
                TopText.NpcCountUp(Steven, {
                    TextBefore = "Here\'s ",
                    TextAfter = "!",
                    Color = "#00FF00",
                    ShouldDisappear = false,
                    FinalAmount = v226.SellPrice,
                    Format = Coins
                });

                if Tool and Tool.Parent then
                    Tool:Destroy();
                end;
            elseif v226 and v226.Reason == "Favorited" then
                TopText.NpcText(Steven, "You cannot sell favorited fruit!", true);
            else
                TopText.NpcText(Steven, "Something went wrong.. try again.", true);
            end;

            task.wait(1);
        end,

        ["Sell All Pets!"] = function() -- Line: 1902
            -- upvalues: Networking (ref), TopText (ref), Steven (ref), NumberUtils (ref), Worlds (ref), WaitForChoice (ref), PromptConfirm (ref), u5 (ref), Normal (ref), Coins (ref)
            task.wait(0.5);
            local LocalPlayer2 = game.Players.LocalPlayer;
            local v227 = Networking.NPCS.PreviewSellAllPets:Fire();
            local v228 = v227 and (v227.PetCount or 0) or 0;

            if v228 <= 0 then
                if (v227 and (v227.FavoritedCount or 0) or 0) > 0 or (v227 and v227.EquippedCount or 0) > 0 then
                    TopText.NpcText(Steven, "Your only pets are favorited or out following you - I can\'t take those!", true);
                else
                    TopText.NpcText(Steven, "You don\'t have any pets to sell!", true);
                end;

                task.wait(1);

                return;
            end;

            local v229 = v227 and v227.TotalValue or 0;
            local v230 = v228 == 1 and "pet" or "pets";
            TopText.NpcText(Steven, string.format("All %d of your %s? That\'d be %s.", v228, v230, NumberUtils.Abbreviate(v229) .. Worlds.Current.CurrencySuffix), true);
            task.wait(0.1);
            local v231, v232 = WaitForChoice(LocalPlayer2, { string.format("Sell all %d %s", v228, v230), "Nevermind" });

            if v232 == "__DISMISSED__" or v231 ~= 1 then
                task.wait(0.4);
                TopText.NpcText(Steven, "Probably wise. They\'re good company.", true);
                task.wait(1);

                return;
            end;

            if not PromptConfirm({
                titleOverride = "Sell ALL Your Pets?",
                yield = true,
                message = string.format("You are about to sell <b>%d</b> %s for <font color=\"#00FF00\">%s</font>.\n\n<font color=\"#FF4040\"><b>THEY ARE GONE FOREVER.</b> This cannot be undone, and you cannot buy them back.</font>", v228, v230, NumberUtils.Abbreviate(v229) .. Worlds.Current.CurrencySuffix),
                options = { "Sell Them All", "Cancel" },
                optionDelays = { 1.5, 0 }
            }) then
                task.wait(0.4);
                TopText.NpcText(Steven, "Changed your mind? No harm done.", true);
                task.wait(1);

                return;
            end;

            task.wait(0.25);
            TopText.NpcText(Steven, "Let me get your payment...", true);
            task.wait(0.5);
            local v233 = Networking.NPCS.SellAllPets:Fire();

            if not (v233 and v233.Success) then
                if v233 and v233.Reason == "Disabled" then
                    TopText.NpcText(Steven, "I\'m not buying anything right now, sorry!", true);
                elseif v233 and (v233.Reason == "RateLimited" or v233.Reason == "SpamThrottled") then
                    TopText.NpcText(Steven, "Slow down! Come back in a moment.", true);
                elseif v233 and v233.Reason == "NoPets" then
                    TopText.NpcText(Steven, "You don\'t have any pets to sell!", true);
                else
                    TopText.NpcText(Steven, "Something went wrong.. try again.", true);
                end;

                task.wait(1);

                return;
            end;

            u5:Play(0.2, 10, 1);
            Normal.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
            Normal.TimePosition = 0;
            Normal.Playing = true;
            local v234 = v233.SoldCount or v228;
            TopText.NpcCountUp(Steven, {
                TextBefore = "Here\'s ",
                Color = "#00FF00",
                ShouldDisappear = false,
                TextAfter = string.format(" for %d %s!", v234, v234 == 1 and "pet" or "pets"),
                FinalAmount = v233.SellPrice,
                Format = Coins
            });
            task.wait(1);
        end,

        ["Bargain!"] = function() -- Line: 2002
            -- upvalues: Networking (ref), BidOddModule (ref), GetHeldFruitInfo (ref), TopText (ref), Steven (ref), NumberUtils (ref), Worlds (ref), WaitForChoice (ref), RunInventoryBargainLoop (ref), RunSingleBargainLoop (ref)
            task.wait(0.5);
            local LocalPlayer2 = game.Players.LocalPlayer;
            local v235 = Networking.NPCS.PreviewSellAll:Fire();
            local v236;

            if v235 then
                v236 = (v235.FruitCount or 0) > 0;
            else
                v236 = v235;
            end;

            local v237 = v236 and (v235.TotalValue or 0) or 0;
            local v238 = math.floor(v237 * (BidOddModule.CostMultiplier - 1));
            local v239 = GetHeldFruitInfo(LocalPlayer2);
            local v240 = v239 ~= nil;
            local v241;

            if v240 then
                local v242 = Networking.NPCS.GetFruitBid:Fire(v239.FruitId);
                v241 = v239.BaseValue;

                if v242 and v242.BidPrice > 0 then
                    v241 = v242.CurrentOffer;
                end;
            else
                v241 = 0;
            end;

            local v243 = math.floor(v241 * (BidOddModule.CostMultiplier - 1));

            if not (v236 or v240) then
                TopText.NpcText(Steven, "You don\'t have anything to bargain with!", true);
                task.wait(1);

                return;
            end;

            TopText.NpcText(Steven, "What would you like to bargain over?", true);
            task.wait(0.1);
            local v244 = {};
            local v245 = nil;
            local v246;

            if v236 then
                local format = string.format;
                local v247 = NumberUtils.Abbreviate(v238) .. Worlds.Current.CurrencySuffix;
                table.insert(v244, format("Bargain Inventory <font color=\"#FF4444\">[COST: %s]</font>", v247));
                v246 = #v244;
            else
                v246 = nil;
            end;

            if v240 then
                local format = string.format;
                local v248 = NumberUtils.Abbreviate(v243) .. Worlds.Current.CurrencySuffix;
                table.insert(v244, format("Bargain This <font color=\"#FF4444\">[COST: %s]</font>", v248));
                v245 = #v244;
            end;

            table.insert(v244, "Nevermind");
            local _ = #v244;
            local v249, v250 = WaitForChoice(LocalPlayer2, v244);

            if v250 == "__DISMISSED__" then
                task.wait(0.2);

                return;
            end;

            if v246 and v249 == v246 then
                RunInventoryBargainLoop(LocalPlayer2, v235, v237);

                return;
            end;

            if v245 and v249 == v245 then
                RunSingleBargainLoop(LocalPlayer2, v239, v241);

                return;
            end;

            task.wait(0.5);
        end,

        ["Double or Nothing!"] = function() -- Line: 2075
            -- upvalues: RunDoubleOrNothingLoop (ref), u204 (ref)
            task.wait(0.5);
            RunDoubleOrNothingLoop(game.Players.LocalPlayer, u204);
        end,

        ["How much is this worth?"] = function() -- Line: 2084
            -- upvalues: TopText (ref), Steven (ref), GetHeldFruitInfo (ref), PetData (ref), NumberUtils (ref), Worlds (ref), Networking (ref), SellFlags (ref)
            task.wait(0.5);
            TopText.NpcText(Steven, "Let me take a look...", true);
            task.wait(1);
            local v251, v252 = GetHeldFruitInfo(game.Players.LocalPlayer);

            if not v251 then
                TopText.NpcText(Steven, v252, true);
                task.wait(1);

                return;
            end;

            if v251 == "Pet" then
                local v253 = PetData.GetSellValue(v252.PetName);
                local v254 = { "I\'ll give you <font color=\'#FFFF00\'>%s</font> for that", "I\'d value it at <font color=\'#FFFF00\'>%s</font>", "Best I can do is <font color=\'#FFFF00\'>%s</font>", "I could do <font color=\'#FFFF00\'>%s</font>", "That is worth about <font color=\'#FFFF00\'>%s</font>", "You\'re looking at about <font color=\'#FFFF00\'>%s</font> for that", "I\'d pay no more than <font color=\'#FFFF00\'>%s</font>", "Very cute, I\'d give you <font color=\'#FFFF00\'>%s</font>" };
                TopText.NpcText(Steven, v254[math.random(#v254)]:format(NumberUtils.Abbreviate(v253) .. Worlds.Current.CurrencySuffix), true);
                task.wait(1);

                return;
            end;

            local v255 = Networking.NPCS.GetFruitBid:Fire(v251.FruitId);
            local v256;

            if v255 and v255.CurrentSellValue then
                v256 = v255.CurrentSellValue;
            else
                local v257 = SellFlags.Apply(v251.FruitName, v251.BaseValue);
                v256 = math.floor(v257);
            end;

            local v258 = { "I\'ll give you <font color=\'#FFFF00\'>%s</font> for that", "I\'d value it at <font color=\'#FFFF00\'>%s</font>", "Best I can do is <font color=\'#FFFF00\'>%s</font>", "I could do <font color=\'#FFFF00\'>%s</font>", "That is worth about <font color=\'#FFFF00\'>%s</font>", "You\'re looking at about <font color=\'#FFFF00\'>%s</font> for that", "I\'d pay no more than <font color=\'#FFFF00\'>%s</font>" };
            TopText.NpcText(Steven, v258[math.random(#v258)]:format(NumberUtils.Abbreviate(v256) .. Worlds.Current.CurrencySuffix), true);
            task.wait(1);
        end,

        Nevermind = function() -- Line: 2145
            task.wait(0.5);
        end
    };

    u204 = function() -- Line: 2153, Name: ShowMainSellMenuOnce
        -- upvalues: RefreshDailyDealEntry (copy), u201 (copy), WaitForChoice (ref), LocalPlayer (copy), u259 (ref)
        RefreshDailyDealEntry();
        local _, v260 = WaitForChoice(LocalPlayer, (table.clone(u201)));

        if v260 == "__DISMISSED__" then
            return;
        end;

        local v261 = u259[v260];

        if v261 then
            v261();
        end;
    end;

    u1:DoDialogue({
        ExitLine = "Goodbye!",
        ProximityPrompt = ProximityPrompt,
        SpeakingNPC = Steven,
        PromptList = u201,
        OperationMap = u259,

        OnDialogueStarted = function() -- Line: 2171, Name: OnDialogueStarted
            -- upvalues: RefreshDailyDealEntry (copy)
            RefreshDailyDealEntry();
        end,

        OnDialogueEnded = function() -- Line: 2178, Name: OnDialogueEnded
            -- upvalues: u8 (ref), Networking (ref), u202 (ref), u203 (ref), RebuildPromptList (copy)
            if u8 then
                u8 = false;
                task.spawn(function() -- Line: 2187
                    -- upvalues: Networking (ref)
                    Networking.NPCS.CashOutDoubleOrNothing:Fire();
                end);
            end;

            u202 = false;
            u203 = "";
            RebuildPromptList();
        end,

        IntroLines = { "Got anything to sell?" }
    });
end;