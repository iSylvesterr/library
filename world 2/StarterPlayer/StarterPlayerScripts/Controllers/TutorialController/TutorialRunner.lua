-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = assert(Players.LocalPlayer);
local PlayerGui = u1:WaitForChild("PlayerGui");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local Worlds = require(ReplicatedStorage.SharedModules.Worlds);
local TutorialUtils = require(script.Parent.TutorialUtils);
local PlayerScripts = u1:WaitForChild("PlayerScripts");
local NotificationController = require(PlayerScripts.Controllers.NotificationController);
local GuiController = require(PlayerScripts.Controllers.GuiController);
local u2 = not RunService:IsStudio() and function(...) -- Line: 46
end or print;
local u3 = {
    Variant1 = {
        Notifications = false,
        ForceTeleportGarden = false,
        ButtonHighlights = false
    },
    Variant2 = {
        Notifications = true,
        ForceTeleportGarden = false,
        ButtonHighlights = false
    },
    Variant3 = {
        Notifications = true,
        ForceTeleportGarden = true,
        ButtonHighlights = false
    },
    Variant4 = {
        Notifications = false,
        ForceTeleportGarden = true,
        ButtonHighlights = false
    },
    Variant5 = {
        Notifications = false,
        ForceTeleportGarden = false,
        ButtonHighlights = true
    },
    Variant6 = {
        Notifications = true,
        ForceTeleportGarden = false,
        ButtonHighlights = true
    },
    Variant7 = {
        Notifications = false,
        ForceTeleportGarden = false,
        ButtonHighlights = false
    },
    Variant8 = {
        Notifications = true,
        ForceTeleportGarden = false,
        ButtonHighlights = false
    },
    Variant9 = {
        Notifications = true,
        ForceTeleportGarden = true,
        ButtonHighlights = false
    },
    Variant10 = {
        Notifications = false,
        ForceTeleportGarden = true,
        ButtonHighlights = false
    },
    Variant11 = {
        Notifications = false,
        ForceTeleportGarden = false,
        ButtonHighlights = true
    },
    Variant12 = {
        Notifications = true,
        ForceTeleportGarden = false,
        ButtonHighlights = true
    }
};
local SeedShop = PlayerGui:WaitForChild("SeedShop");
local TeleportButtons = PlayerGui:WaitForChild("TeleportButtons"):WaitForChild("TeleportButtons");
local SeedsButton = TeleportButtons:WaitForChild("SeedsButton");
local GardenButton = TeleportButtons:WaitForChild("GardenButton");
local SellButton = TeleportButtons:WaitForChild("SellButton");
local Pointer = PlayerGui:WaitForChild("TutorialUI"):WaitForChild("Pointer");

local function notify(p4, p5) -- Line: 119
    -- upvalues: u2 (copy), NotificationController (copy)
    if not p4.Notifications then
        return;
    end;

    u2((`[Tutorial] Notifying: {p5}`));
    NotificationController:CreateNotification(p5, nil, 5);
end;

local function getCarrotFrame() -- Line: 128
    -- upvalues: SeedShop (copy)
    return SeedShop.Frame.NormalShop:FindFirstChild("Carrot");
end;

local function getNormalShop() -- Line: 132
    -- upvalues: SeedShop (copy)
    return SeedShop.Frame.NormalShop;
end;

local function findSeedHotbarSlot() -- Line: 136
    -- upvalues: PlayerGui (copy)
    local BackpackGui = PlayerGui:FindFirstChild("BackpackGui");

    if BackpackGui then
        BackpackGui = BackpackGui:FindFirstChild("Backpack");
    end;

    if BackpackGui then
        BackpackGui = BackpackGui:FindFirstChild("Hotbar");
    end;

    if not BackpackGui then
        return nil, nil;
    end;

    for i = 1, 10 do
        local v6 = BackpackGui:FindFirstChild((tostring(i)));

        if v6 and v6:IsA("GuiObject") then
            local ToolName = v6:FindFirstChild("ToolName");

            if ToolName and (ToolName:IsA("TextLabel") and string.find(ToolName.Text, "Seed")) then
                return v6.AbsolutePosition + Vector2.new(v6.AbsoluteSize.X * 0.5, 0), v6;
            end;
        end;
    end;

    return nil, nil;
end;

local function createTapIcon(p7) -- Line: 159
    -- upvalues: TweenService (copy)
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Transparency = 1;
    Part.Size = Vector3.new(0.001, 0.001, 0.001);
    Part.Position = p7;
    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Size = UDim2.fromScale(3, 3);
    BillboardGui.StudsOffset = Vector3.new(0, 2, 0);
    BillboardGui.AlwaysOnTop = true;
    BillboardGui.Parent = Part;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Image = "rbxassetid://7553620727";
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Parent = BillboardGui;
    local UIScale = Instance.new("UIScale");
    UIScale.Scale = 1;
    UIScale.Parent = ImageLabel;
    TweenService:Create(UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Scale = 1.3
    }):Play();
    Part.Parent = workspace;

    return Part;
end;

local function getOptionText(p8) -- Line: 197
    local Text_Element = p8:FindFirstChild("Text_Element", true);

    if Text_Element then
        local v9 = Text_Element:GetAttribute("Text");

        if type(v9) == "string" then
            return v9;
        end;
    end;

    return nil;
end;

local function findOptionInBillboard(p10) -- Line: 208
    -- upvalues: PlayerGui (copy)
    local Billboard_UI = PlayerGui:FindFirstChild("Billboard_UI");

    if not Billboard_UI then
        return nil;
    end;

    local Objects = Billboard_UI:FindFirstChild("Objects");

    if not Objects then
        return nil;
    end;

    for _, child in Objects:GetChildren() do
        if child:IsA("GuiObject") then
            local Text_Element = child:FindFirstChild("Text_Element", true);
            local v11;

            if Text_Element then
                v11 = Text_Element:GetAttribute("Text");

                if type(v11) ~= "string" then
                    v11 = nil;
                end;
            else
                v11 = nil;
            end;

            if v11 and string.find(v11, p10, 1, true) then
                return child;
            end;
        end;
    end;

    return nil;
end;

local function isBillboardOpen() -- Line: 229
    -- upvalues: PlayerGui (copy)
    local Billboard_UI = PlayerGui:FindFirstChild("Billboard_UI");

    if not Billboard_UI then
        return false;
    end;

    local Objects = Billboard_UI:FindFirstChild("Objects");
    local v12;

    if Objects == nil then
        v12 = false;
    else
        v12 = #Objects:GetChildren() > 1;
    end;

    return v12;
end;

local function waitForDialogueOption(p13, p14) -- Line: 238
    -- upvalues: PlayerGui (copy), u2 (copy), findOptionInBillboard (copy)
    local v15 = 0;
    local Billboard_UI = PlayerGui:FindFirstChild("Billboard_UI");
    local v16;

    if Billboard_UI then
        local Objects = Billboard_UI:FindFirstChild("Objects");

        if Objects == nil then
            v16 = false;
        else
            v16 = #Objects:GetChildren() > 1;
        end;
    else
        v16 = false;
    end;

    local v17 = nil;

    while not (p14 and p14()) do
        local v18 = findOptionInBillboard(p13);

        if v18 then
            return v18;
        end;

        local Billboard_UI2 = PlayerGui:FindFirstChild("Billboard_UI");
        local v19;

        if Billboard_UI2 then
            local Objects = Billboard_UI2:FindFirstChild("Objects");

            if Objects == nil then
                v19 = false;
            else
                v19 = #Objects:GetChildren() > 1;
            end;
        else
            v19 = false;
        end;

        if v19 then
            v16 = true;
            v17 = nil;
        elseif v16 then
            if v17 then
                if os.clock() - v17 > 1 then
                    u2((`[Tutorial] Billboard closed while waiting for "{p13}"`));

                    return nil;
                end;
            else
                v17 = os.clock();
            end;
        end;

        v15 = v15 + 0.1;

        if v15 >= 2 then
            v15 = 0;
            local Billboard_UI3 = PlayerGui:FindFirstChild("Billboard_UI");

            if Billboard_UI3 then
                local Objects = Billboard_UI3:FindFirstChild("Objects");

                if Objects then
                    local v20 = {};

                    for _, child in Objects:GetChildren() do
                        local v21;

                        if child:IsA("GuiObject") then
                            local Text_Element = child:FindFirstChild("Text_Element", true);

                            if Text_Element then
                                v21 = Text_Element:GetAttribute("Text");

                                if type(v21) ~= "string" then
                                    v21 = nil;
                                end;
                            else
                                v21 = nil;
                            end;
                        else
                            v21 = nil;
                        end;

                        local v22 = `{child.Name}={v21 or "nil"}`;
                        table.insert(v20, v22);
                    end;

                    u2((`[Tutorial] Searching for "{p13}", available: [{table.concat(v20, ", ")}]`));
                else
                    u2((`[Tutorial] Searching for "{p13}", no Objects container`));
                end;
            else
                u2((`[Tutorial] Searching for "{p13}", no Billboard_UI`));
            end;
        end;

        task.wait(0.1);
    end;

    u2((`[Tutorial] shouldStop fired while waiting for "{p13}"`));

    return nil;
end;

local function highlightDialogueOption(p23, p24) -- Line: 291
    -- upvalues: TweenService (copy), Pointer (copy)
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Thickness = 99999;
    UIStroke.Color = Color3.new(0, 0, 0);
    UIStroke.Transparency = 1;
    UIStroke.Parent = p23;
    TweenService:Create(UIStroke, TweenInfo.new(0.3), {
        Transparency = 0.5
    }):Play();
    local u25 = Pointer:Clone();
    u25.Image = "rbxassetid://7553620727";
    u25.ImageTransparency = 0;
    u25.Visible = true;
    u25.AnchorPoint = Vector2.new(0.5, 0);
    u25.Position = UDim2.fromScale(0.5, 0.5);
    u25.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    u25.Size = p24 or UDim2.fromScale(1.5, 1.5);
    u25.Parent = p23;
    local v26 = u25:FindFirstChildWhichIsA("UIScale");
    local v27 = not v26 and 1 or v26.Scale;
    local u28;

    if v26 then
        u28 = TweenService:Create(v26, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            Scale = v27 * 1.1
        });
    else
        u28 = nil;
    end;

    if u28 then
        u28:Play();
    end;

    return function() -- Line: 336
        -- upvalues: u28 (copy), u25 (copy), UIStroke (copy)
        if u28 then
            u28:Cancel();
        end;

        u25:Destroy();
        UIStroke:Destroy();
    end;
end;

local function waitForDialogueOptionAndHighlight(p29, p30, p31) -- Line: 345
    -- upvalues: u2 (copy), waitForDialogueOption (copy), highlightDialogueOption (copy), PlayerGui (copy)
    u2((`[Tutorial] waitForDialogueOptionAndHighlight: searching for "{p29}"`));
    local v32 = waitForDialogueOption(p29, p31);

    if not v32 then
        return false;
    end;

    u2((`[Tutorial] Found "{p29}" -> {v32:GetFullName()}, highlighting`));
    local v33 = highlightDialogueOption(v32, p30);

    while v32.Parent do
        if p31 and p31() then
            u2((`[Tutorial] shouldStop fired while highlighting "{p29}"`));
            break;
        end;

        local Text_Element = v32:FindFirstChild("Text_Element", true);
        local v34;

        if Text_Element then
            v34 = Text_Element:GetAttribute("Text");

            if type(v34) ~= "string" then
                v34 = nil;
            end;
        else
            v34 = nil;
        end;

        if not (v34 and string.find(v34, p29, 1, true)) then
            break;
        end;

        task.wait(0.1);
    end;

    v33();

    if p31 and p31() then
        return true;
    end;

    task.wait(0.3);
    local Billboard_UI = PlayerGui:FindFirstChild("Billboard_UI");
    local v35;

    if Billboard_UI then
        local Objects = Billboard_UI:FindFirstChild("Objects");

        if Objects == nil then
            v35 = false;
        else
            v35 = #Objects:GetChildren() > 1;
        end;
    else
        v35 = false;
    end;

    if v35 then
        u2((`[Tutorial] "{p29}" step complete, advancing`));

        return true;
    end;

    u2((`[Tutorial] Billboard closed during "{p29}" without clicking, restarting`));

    return false;
end;

local function focusButtonAndWait(u36) -- Line: 388
    -- upvalues: TutorialUtils (copy)
    local v37 = TutorialUtils.focusObject(u36);
    local v38 = TutorialUtils.pointToUI(function() -- Line: 390
        -- upvalues: u36 (copy)
        return u36.AbsolutePosition + u36.AbsoluteSize * 0.5;
    end);
    u36.Activated:Wait();
    v38();
    v37(0.2);
    task.wait(0.3);
end;

local function distanceFromCharacter(p39) -- Line: 401
    -- upvalues: u1 (copy)
    local Character = u1.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    return not Character and 0 or (Character.Position - p39).Magnitude;
end;

local function navigateToSeedShop(p40) -- Line: 410
    -- upvalues: TutorialUtils (copy), u1 (copy), focusButtonAndWait (copy), SeedsButton (copy), RunService (copy)
    local identity = CFrame.identity;

    if not p40.ButtonHighlights then
        local u42 = TutorialUtils.observeTag("Tutorial_SeedShopNPC", function(p41) -- Line: 439
            -- upvalues: identity (ref)
            identity = p41.CFrame;

            return nil;
        end, { workspace });
        local u43 = TutorialUtils.createArrow(u1, identity);
        local u44 = RunService.PreRender:Connect(function() -- Line: 445
            -- upvalues: u43 (copy), identity (ref)
            u43.move(identity);
        end);
        TutorialUtils.waitUntilDistance(function() -- Line: 449
            -- upvalues: identity (ref)
            return identity.Position;
        end, 15);

        return function() -- Line: 453
            -- upvalues: u44 (copy), u43 (copy), u42 (copy)
            u44:Disconnect();
            u43.destroy();
            u42();
        end;
    end;

    local u46 = TutorialUtils.observeTag("Tutorial_SeedShopNPC", function(p45) -- Line: 414
        -- upvalues: identity (ref)
        identity = p45.CFrame;

        return nil;
    end, { workspace });
    local Position = identity.Position;
    local Character = u1.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if (not Character and 0 or (Character.Position - Position).Magnitude) > 15 then
        focusButtonAndWait(SeedsButton);
    end;

    local u47 = TutorialUtils.createArrow(u1, identity);
    local u48 = RunService.PreRender:Connect(function() -- Line: 424
        -- upvalues: u47 (copy), identity (ref)
        u47.move(identity);
    end);
    TutorialUtils.waitUntilDistance(function() -- Line: 428
        -- upvalues: identity (ref)
        return identity.Position;
    end, 15);

    return function() -- Line: 432
        -- upvalues: u48 (copy), u47 (copy), u46 (copy)
        u48:Disconnect();
        u47.destroy();
        u46();
    end;
end;

local function navigateToPlot(p49, p50, p51) -- Line: 460
    -- upvalues: TutorialUtils (copy), focusButtonAndWait (copy), GardenButton (copy), u1 (copy)
    if not (p49.ButtonHighlights or p49.ForceTeleportGarden) then
        local u52 = TutorialUtils.createArrow(u1, CFrame.new(p51));

        while not TutorialUtils.isInsidePlot(p50) do
            task.wait(0.1);
        end;

        return function() -- Line: 489
            -- upvalues: u52 (copy)
            u52.destroy();
        end;
    end;

    if not TutorialUtils.isInsidePlot(p50) then
        focusButtonAndWait(GardenButton);
    end;

    if TutorialUtils.isInsidePlot(p50) then
        return function() -- Line: 469
        end;
    end;

    local u53 = TutorialUtils.createArrow(u1, CFrame.new(p51));

    while not TutorialUtils.isInsidePlot(p50) do
        task.wait(0.1);
    end;

    return function() -- Line: 478
        -- upvalues: u53 (copy)
        u53.destroy();
    end;
end;

local function navigateToSteven(p54) -- Line: 494
    -- upvalues: TutorialUtils (copy), u1 (copy), focusButtonAndWait (copy), SellButton (copy), RunService (copy)
    local identity = CFrame.identity;

    if not p54.ButtonHighlights then
        local u56 = TutorialUtils.observeTag("Tutorial_SellNPC", function(p55) -- Line: 523
            -- upvalues: identity (ref)
            identity = p55.CFrame;

            return nil;
        end, { workspace });
        local u57 = TutorialUtils.createArrow(u1, identity);
        local u58 = RunService.PreRender:Connect(function() -- Line: 529
            -- upvalues: u57 (copy), identity (ref)
            u57.move(identity);
        end);
        TutorialUtils.waitUntilDistance(function() -- Line: 533
            -- upvalues: identity (ref)
            return identity.Position;
        end, 15);

        return function() -- Line: 537
            -- upvalues: u58 (copy), u57 (copy), u56 (copy)
            u58:Disconnect();
            u57.destroy();
            u56();
        end;
    end;

    local u60 = TutorialUtils.observeTag("Tutorial_SellNPC", function(p59) -- Line: 498
        -- upvalues: identity (ref)
        identity = p59.CFrame;

        return nil;
    end, { workspace });
    local Position = identity.Position;
    local Character = u1.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if (not Character and 0 or (Character.Position - Position).Magnitude) > 15 then
        focusButtonAndWait(SellButton);
    end;

    local u61 = TutorialUtils.createArrow(u1, identity);
    local u62 = RunService.PreRender:Connect(function() -- Line: 508
        -- upvalues: u61 (copy), identity (ref)
        u61.move(identity);
    end);
    TutorialUtils.waitUntilDistance(function() -- Line: 512
        -- upvalues: identity (ref)
        return identity.Position;
    end, 15);

    return function() -- Line: 516
        -- upvalues: u62 (copy), u61 (copy), u60 (copy)
        u62:Disconnect();
        u61.destroy();
        u60();
    end;
end;

return function(u63) -- Line: 544
    -- upvalues: u3 (copy), u2 (copy), TutorialUtils (copy), NotificationController (copy), navigateToSeedShop (copy), SeedShop (copy), RunService (copy), GuiController (copy), navigateToPlot (copy), u1 (copy), findSeedHotbarSlot (copy), createTapIcon (copy), navigateToSteven (copy), Worlds (copy), PlayerGui (copy), waitForDialogueOptionAndHighlight (copy), Networking (copy)
    local u64 = u3[u63];

    if not u64 then
        u2((`[TutorialRunner] Unknown variant "{u63}", falling back to Variant1`));
        u64 = u3.Variant1;
    end;

    workspace:SetAttribute("InTutorial", true);
    local v122, v123 = xpcall(function() -- Line: 553
        -- upvalues: TutorialUtils (ref), u2 (ref), u63 (copy), u64 (ref), NotificationController (ref), navigateToSeedShop (ref), SeedShop (ref), RunService (ref), GuiController (ref), navigateToPlot (ref), u1 (ref), findSeedHotbarSlot (ref), createTapIcon (ref), navigateToSteven (ref), Worlds (ref), PlayerGui (ref), waitForDialogueOptionAndHighlight (ref), Networking (ref)
        local v65 = false;

        for _, v in TutorialUtils.getTools() do
            if v:GetAttribute("FruitName") then
                v65 = true;
                break;
            end;
        end;

        local v66 = TutorialUtils.getPlayerPlot();
        local v67;

        if v66 then
            v67 = v66:FindFirstChild("Plants");
        else
            v67 = v66;
        end;

        local v68 = v67 and #v67:GetChildren() or 0;
        local v69 = TutorialUtils.hasSeed();
        local v70 = v65 and 8 or (v68 > 0 and 7 or (v69 and 4 or 1));
        u2((`[Tutorial] {u63} starting at step {v70} (fruit={v65}, plants={v68}, seed={v69}, plot={v66 ~= nil})`));

        if v70 <= 3 then
            u2("[Tutorial] Step 1: Navigate to seed shop");

            if u64.Notifications then
                u2("[Tutorial] Notifying: Head to the Seed Shop!");
                NotificationController:CreateNotification("Head to the Seed Shop!", nil, 5);
            end;

            while not TutorialUtils.hasSeed() do
                local v71 = navigateToSeedShop(u64);

                while not SeedShop.Enabled do
                    RunService.PreRender:Wait();
                end;

                if u64.Notifications then
                    u2("[Tutorial] Notifying: Buy a Carrot Seed!");
                    NotificationController:CreateNotification("Buy a Carrot Seed!", nil, 5);
                end;

                local v72 = false;
                local v73 = "carrot";
                local v74 = nil;
                local v75 = nil;
                local NormalShop = SeedShop.Frame.NormalShop;
                NormalShop.ScrollingEnabled = false;

                local function isCarrotSelected() -- Line: 606
                    -- upvalues: NormalShop (copy)
                    return NormalShop.Sheckles_Shelf.Visible and NormalShop.Sheckles_Shelf.LayoutOrder == 4;
                end;

                if NormalShop.Sheckles_Shelf.Visible and NormalShop.Sheckles_Shelf.LayoutOrder == 4 then
                    v73 = "buy";
                end;

                while SeedShop.Enabled and not v72 do
                    if v73 == "carrot" then
                        v74 = TutorialUtils.focusObject(function() -- Line: 617
                            -- upvalues: SeedShop (ref)
                            local Carrot = SeedShop.Frame.NormalShop:FindFirstChild("Carrot");

                            if not Carrot then
                                return nil;
                            end;

                            local Main_Frame = Carrot.Main_Frame;

                            return {
                                Position = Main_Frame.AbsolutePosition,
                                Size = Main_Frame.AbsoluteSize
                            };
                        end);
                        v75 = TutorialUtils.pointToUI(function() -- Line: 626
                            -- upvalues: SeedShop (ref)
                            local Carrot = SeedShop.Frame.NormalShop:FindFirstChild("Carrot");

                            if not Carrot then
                                return nil;
                            end;

                            local Main_Frame = Carrot.Main_Frame;

                            return Main_Frame.AbsolutePosition + Main_Frame.AbsoluteSize * 0.5;
                        end);

                        while SeedShop.Enabled do
                            if NormalShop.Sheckles_Shelf.Visible and NormalShop.Sheckles_Shelf.LayoutOrder == 4 then
                                break;
                            end;

                            RunService.PreRender:Wait();
                        end;

                        if v75 then
                            v75();
                            v75 = nil;
                        end;

                        if v74 then
                            v74(0.2);
                            v74 = nil;
                        end;

                        if not SeedShop.Enabled then
                            break;
                        end;

                        v73 = "buy";
                    end;

                    if v73 == "buy" then
                        v74 = TutorialUtils.focusObject(function() -- Line: 658
                            -- upvalues: NormalShop (copy)
                            if not NormalShop.Sheckles_Shelf.Visible then
                                return nil;
                            end;

                            local BuyButton = NormalShop.Sheckles_Shelf.Main_Frame.Buttons.BuyButton;

                            return {
                                Position = BuyButton.AbsolutePosition,
                                Size = BuyButton.AbsoluteSize
                            };
                        end);
                        v75 = TutorialUtils.pointToUI(function() -- Line: 665
                            -- upvalues: NormalShop (copy)
                            if not NormalShop.Sheckles_Shelf.Visible then
                                return nil;
                            end;

                            local BuyButton = NormalShop.Sheckles_Shelf.Main_Frame.Buttons.BuyButton;

                            return BuyButton.AbsolutePosition + BuyButton.AbsoluteSize * 0.5;
                        end);

                        while SeedShop.Enabled and not TutorialUtils.hasSeed() do
                            task.wait(0.1);
                        end;

                        if v75 then
                            v75();
                            v75 = nil;
                        end;

                        if v74 then
                            v74(0.2);
                            v74 = nil;
                        end;

                        if TutorialUtils.hasSeed() then
                            v72 = true;
                        end;

                        break;
                    end;
                end;

                if v75 then
                    v75();
                end;

                if v74 then
                    v74(0);
                end;

                NormalShop.ScrollingEnabled = true;
                v71();

                if v72 then
                    break;
                end;
            end;

            if SeedShop.Enabled then
                local ExitButton = SeedShop.Frame.Header.ExitButton;
                local v76 = TutorialUtils.pointToUI(function() -- Line: 714
                    -- upvalues: SeedShop (ref), ExitButton (copy)
                    if SeedShop.Enabled then
                        return ExitButton.AbsolutePosition + ExitButton.AbsoluteSize * 0.5;
                    end;

                    return nil;
                end);
                local v77 = os.clock() + 20;

                while SeedShop.Enabled do
                    if v77 <= os.clock() then
                        GuiController:Close("SeedShop");
                        break;
                    end;

                    task.wait(0.1);
                end;

                v76();
            end;
        end;

        if v70 <= 6 then
            u2("[Tutorial] Step 4: Navigate to plot");

            if u64.Notifications then
                u2("[Tutorial] Notifying: Go to your Garden!");
                NotificationController:CreateNotification("Go to your Garden!", nil, 5);
            end;

            local v78;

            while true do
                v78 = TutorialUtils.getPlayerPlot();

                if v78 then
                    break;
                end;

                task.wait(0.5);
            end;

            local v79 = assert(v78:FindFirstChild("SpawnPoint"));
            local v80 = v79:IsA("BasePart");
            assert(v80, "SpawnPoint must be a BasePart");
            local Position = v79.Position;
            local v81 = assert(v78:FindFirstChild("Plants"));
            local v82 = v81:IsA("Folder");
            assert(v82, "Plants must be a Folder");
            local u83 = false;
            local v84 = v81.ChildAdded:Connect(function() -- Line: 758
                -- upvalues: u83 (ref)
                u83 = true;
            end);
            u83 = #v81:GetChildren() > 0 and true or u83;

            if not u83 then
                navigateToPlot(u64, v78, Position)();
            end;

            v84:Disconnect();

            if not u83 then
                if u64.Notifications then
                    u2("[Tutorial] Notifying: Plant your seed!");
                    NotificationController:CreateNotification("Plant your seed!", nil, 5);
                end;

                if GuiController.Gui then
                    GuiController:Close();
                end;

                local function isSeedEquipped() -- Line: 783
                    -- upvalues: u1 (ref)
                    local Character = u1.Character;
                    local v85;

                    if Character then
                        v85 = Character:FindFirstChildWhichIsA("Tool");
                    else
                        v85 = nil;
                    end;

                    local v86;

                    if v85 == nil then
                        v86 = false;
                    else
                        v86 = v85:GetAttribute("SeedTool") ~= nil;
                    end;

                    return v86;
                end;

                local Character = u1.Character;
                local v87;

                if Character then
                    v87 = Character:FindFirstChildWhichIsA("Tool");
                else
                    v87 = nil;
                end;

                local v88;

                if v87 == nil then
                    v88 = false;
                else
                    v88 = v87:GetAttribute("SeedTool") ~= nil;
                end;

                if not v88 then
                    local v89 = TutorialUtils.pointToUI(function() -- Line: 790
                        -- upvalues: findSeedHotbarSlot (ref)
                        return findSeedHotbarSlot();
                    end);
                    TutorialUtils.waitUntilSeedEquipped();
                    v89();
                end;

                if #v81:GetChildren() > 0 then
                    u83 = true;
                else
                    u83 = false;
                end;

                if not u83 then
                    local v90 = v81.ChildAdded:Connect(function() -- Line: 801
                        -- upvalues: u83 (ref)
                        u83 = true;
                    end);
                    local v91 = v79.CFrame * CFrame.new(10, -5, -30);

                    while not u83 do
                        local v92;

                        if TutorialUtils.isInsidePlot(v78) then
                            local Character2 = u1.Character;
                            local v93;

                            if Character2 then
                                v93 = Character2:FindFirstChildWhichIsA("Tool");
                            else
                                v93 = nil;
                            end;

                            local v94;

                            if v93 == nil then
                                v94 = false;
                            else
                                v94 = v93:GetAttribute("SeedTool") ~= nil;
                            end;

                            if v94 then
                                local v95 = createTapIcon(v91.Position);

                                while not u83 and TutorialUtils.isInsidePlot(v78) do
                                    local Character3 = u1.Character;
                                    local v96;

                                    if Character3 then
                                        v96 = Character3:FindFirstChildWhichIsA("Tool");
                                    else
                                        v96 = nil;
                                    end;

                                    local v97;

                                    if v96 == nil then
                                        v97 = false;
                                    else
                                        v97 = v96:GetAttribute("SeedTool") ~= nil;
                                    end;

                                    if not v97 then
                                        break;
                                    end;

                                    task.wait(0.1);
                                end;

                                v95:Destroy();
                                local Character3 = u1.Character;
                                local v98;

                                if Character3 then
                                    v98 = Character3:FindFirstChildWhichIsA("Tool");
                                else
                                    v98 = nil;
                                end;

                                local v99;

                                if v98 == nil then
                                    v99 = false;
                                else
                                    v99 = v98:GetAttribute("SeedTool") ~= nil;
                                end;

                                if v99 or not TutorialUtils.isInsidePlot(v78) then
                                    if u83 then
                                        break;
                                    end;

                                    v92 = TutorialUtils.createArrow(u1, CFrame.new(Position));

                                    while not (u83 or TutorialUtils.isInsidePlot(v78)) do
                                        task.wait(0.1);
                                    end;

                                    v92.destroy();
                                end;
                            else
                                local v100 = TutorialUtils.pointToUI(function() -- Line: 810
                                    -- upvalues: findSeedHotbarSlot (ref)
                                    return findSeedHotbarSlot();
                                end);

                                while true do
                                    local v101;

                                    if true then
                                        local Character3 = u1.Character;

                                        if Character3 then
                                            v101 = Character3:FindFirstChildWhichIsA("Tool");
                                        else
                                            v101 = nil;
                                        end;
                                    end;

                                    local v102;

                                    if v101 == nil then
                                        v102 = false;
                                    else
                                        v102 = v101:GetAttribute("SeedTool") ~= nil;
                                    end;

                                    if v102 or (u83 or not TutorialUtils.isInsidePlot(v78)) then
                                        break;
                                    end;

                                    task.wait(0.1);
                                end;

                                v100();
                            end;
                        else
                            if u83 then
                                break;
                            end;

                            v92 = TutorialUtils.createArrow(u1, CFrame.new(Position));

                            while not (u83 or TutorialUtils.isInsidePlot(v78)) do
                                task.wait(0.1);
                            end;

                            v92.destroy();
                        end;
                    end;

                    v90:Disconnect();
                end;
            end;
        end;

        if v70 <= 7 then
            u2("[Tutorial] Step 7: Wait for growth");

            if u64.Notifications then
                u2("[Tutorial] Notifying: Wait for your crop to grow...");
                NotificationController:CreateNotification("Wait for your crop to grow...", nil, 5);
            end;

            local v103;

            while true do
                v103 = TutorialUtils.getPlayerPlot();

                if v103 then
                    break;
                end;

                task.wait(0.5);
            end;

            local u104 = assert(v103:FindFirstChild("Plants"));
            local UserId = u1.UserId;

            local function hasHarvestedFruitNow() -- Line: 903
                -- upvalues: TutorialUtils (ref)
                for _, v in TutorialUtils.getTools() do
                    if v:GetAttribute("FruitName") then
                        return true;
                    end;
                end;

                return false;
            end;

            local function findPlantModel() -- Line: 880
                -- upvalues: u104 (copy), UserId (copy)
                for _, child in u104:GetChildren() do
                    if child:IsA("Model") then
                        return child;
                    end;
                end;

                for _, descendant in workspace:GetDescendants() do
                    if descendant:IsA("Model") and (descendant:GetAttribute("UserId") == UserId and descendant:GetAttribute("SeedName") ~= nil) then
                        return descendant;
                    end;
                end;

                return nil;
            end;

            local u105 = nil;

            while true do
                local v106 = findPlantModel();

                if v106 then
                    u105 = v106;
                    break;
                end;

                local v107 = false;

                for _, v in TutorialUtils.getTools() do
                    if v:GetAttribute("FruitName") then
                        v107 = true;
                        break;
                    end;
                end;

                if v107 then
                    break;
                end;

                task.wait(0.2);
            end;

            while u105 and u105:IsDescendantOf(workspace) do
                local v108 = false;

                for _, v in TutorialUtils.getTools() do
                    if v:GetAttribute("FruitName") then
                        v108 = true;
                        break;
                    end;
                end;

                if v108 then
                    break;
                end;

                local v109 = u105:GetAttribute("Age");
                local v110 = u105:GetAttribute("MaxAge");

                if typeof(v109) == "number" and (typeof(v110) == "number" and v110 <= v109) or u105:FindFirstChild("HarvestPrompt", true) then
                    break;
                end;

                task.wait(0.2);

                if u105 and not u105:IsDescendantOf(workspace) then
                    u105 = findPlantModel() or u105;
                end;
            end;

            if u105 and not u105:IsDescendantOf(workspace) then
                u105 = findPlantModel() or u105;
            end;

            local v111;

            if u105 == nil then
                v111 = false;
            else
                v111 = u105:IsDescendantOf(workspace);
            end;

            if u105 and v111 then
                local v112 = false;

                for _, v in TutorialUtils.getTools() do
                    if v:GetAttribute("FruitName") then
                        v112 = true;
                        break;
                    end;
                end;

                if not v112 then
                    if u64.Notifications then
                        u2("[Tutorial] Notifying: Harvest your crop!");
                        NotificationController:CreateNotification("Harvest your crop!", nil, 5);
                    end;

                    local function getPlantTarget() -- Line: 976
                        -- upvalues: u105 (ref)
                        local v113 = u105.PrimaryPart or (u105:FindFirstChild("HarvestPart") or u105:FindFirstChildWhichIsA("BasePart"));

                        if v113 and v113:IsA("BasePart") then
                            return v113.CFrame;
                        end;

                        return u105:GetPivot();
                    end;

                    local u114 = TutorialUtils.createArrow(u1, getPlantTarget());
                    local v115 = RunService.PreRender:Connect(function() -- Line: 988
                        -- upvalues: u105 (ref), u114 (copy), getPlantTarget (copy)
                        if not u105:IsDescendantOf(workspace) then
                            return;
                        end;

                        u114.move(getPlantTarget());
                    end);

                    while u105 and u105:IsDescendantOf(workspace) do
                        local v116 = false;

                        for _, v in TutorialUtils.getTools() do
                            if v:GetAttribute("FruitName") then
                                v116 = true;
                                break;
                            end;
                        end;

                        if v116 then
                            break;
                        end;

                        task.wait(0.2);
                    end;

                    v115:Disconnect();
                    u114.destroy();
                end;
            end;
        end;

        u2("[Tutorial] Step 8: Navigate to Steven");

        if u64.Notifications then
            u2("[Tutorial] Notifying: Go sell your crop!");
            NotificationController:CreateNotification("Go sell your crop!", nil, 5);
        end;

        local v117 = navigateToSteven(u64);
        local u118 = Worlds.WaitForWalletStat(u1, 30);
        local Value = u118.Value;
        local u119 = Value < u118.Value;
        local v120 = u118.Changed:Connect(function() -- Line: 1021
            -- upvalues: u118 (copy), Value (copy), u119 (ref)
            if Value < u118.Value then
                u119 = true;
            end;
        end);
        u2("[Tutorial] Step 9: Highlight Sell Inventory option until a sale lands");

        local function isSaleDone() -- Line: 1029
            -- upvalues: u119 (ref)
            return u119;
        end;

        while not u119 do
            while true do
                local v121;

                if true then
                    local Billboard_UI = PlayerGui:FindFirstChild("Billboard_UI");

                    if Billboard_UI then
                        local Objects = Billboard_UI:FindFirstChild("Objects");

                        if Objects == nil then
                            v121 = false;
                        else
                            v121 = #Objects:GetChildren() > 1;
                        end;
                    else
                        v121 = false;
                    end;
                end;

                if v121 or u119 then
                    break;
                end;

                task.wait(0.1);
            end;

            if u119 then
                break;
            end;

            waitForDialogueOptionAndHighlight("Sell Inventory!", nil, isSaleDone);
        end;

        v120:Disconnect();
        u2("[Tutorial] Sale detected, completing tutorial");
        v117();
        Networking.Tutorial.Complete:Fire();
    end, debug.traceback);
    workspace:SetAttribute("InTutorial", nil);
    local NormalShop = SeedShop.Frame:FindFirstChild("NormalShop");

    if NormalShop then
        NormalShop.ScrollingEnabled = true;
    end;

    if not v122 then
        warn((`[TutorialRunner] Tutorial flow errored: {v123}`));
    end;
end;