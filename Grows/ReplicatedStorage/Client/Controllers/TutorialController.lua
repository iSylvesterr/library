-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local TweenService = game:GetService("TweenService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Maid = require(ReplicatedStorage.Packages.Maid);
local RebirthConfig = require(ReplicatedStorage.Shared.Info.RebirthConfig);
local u1 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true);
local v2 = Knit.CreateController({
    Name = "TutorialController"
});

function v2.KnitStart(p3) -- Line: 25
    -- upvalues: Players (copy), Maid (copy), Knit (copy), SoundService (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), u1 (copy), RebirthConfig (copy)
    local LocalPlayer = Players.LocalPlayer;
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local v4 = Maid.new();
    p3._maid = v4;
    local u5 = Knit.GetService("TutorialService");
    local v6 = Knit.GetService("PlayerPlotService");
    local UI_Manager = p3.UI_Manager;
    local DataClient = p3.DataClient;
    local SoundController = p3.SoundController;
    local HUD = PlayerGui:WaitForChild("HUD");
    local TutorialText = HUD:WaitForChild("TutorialText");
    local TextLabel = TutorialText:WaitForChild("Center"):WaitForChild("TextLabel");
    TutorialText.Visible = false;
    local MainMenuDarken = PlayerGui:WaitForChild("MainMenuDarken");
    local TutorialArrow = HUD.SideMenus.Left.Buttons.Rebirth:WaitForChild("TutorialArrow");
    local Rebirth = PlayerGui:WaitForChild("Windows"):WaitForChild("Rebirth");
    local TutorialArrow2 = Rebirth.Content.Buttons.Unlock:WaitForChild("TutorialArrow");
    local SkipRebirth = Rebirth.Content.Buttons.SkipRebirth;
    local Exit = Rebirth.Top.Exit;
    local UI = SoundService:WaitForChild("SoundEffects"):WaitForChild("UI");
    local TextTick = UI:FindFirstChild("TextTick");

    if not TextTick or TextTick.SoundId == "" then
        TextTick = UI:WaitForChild("Hover");
    end;

    local u7 = 0;
    local u8 = nil;

    local function showText(p9) -- Line: 68
        -- upvalues: u7 (ref), TextLabel (copy), TutorialText (copy), SoundController (copy), TextTick (ref), LocalPlayer (copy)
        u7 = u7 + 1;
        local v10 = u7;
        TextLabel.MaxVisibleGraphemes = 0;
        TextLabel.Text = p9;
        TutorialText.Visible = true;
        local v11 = string.split(p9, " ");
        local v12 = 0;

        for i = 1, #v11 do
            if u7 ~= v10 then
                return;
            end;

            v12 = v12 + (utf8.len(v11[i]) + (i > 1 and 1 or 0));
            TextLabel.MaxVisibleGraphemes = v12;
            SoundController:PlaySound(TextTick, LocalPlayer, {
                PlaybackSpeed = NumberRange.new(0.85, 1.15)
            });

            if i < #v11 then
                task.wait(0.1);
            end;
        end;

        TextLabel.MaxVisibleGraphemes = -1;
    end;

    local function setSticky(p13) -- Line: 86
        -- upvalues: u8 (ref), showText (copy), u7 (ref), TutorialText (copy), TextLabel (copy)
        u8 = p13;

        if p13 then
            task.spawn(showText, p13);

            return;
        end;

        u7 = u7 + 1;
        TutorialText.Visible = false;
        TextLabel.Text = "";
    end;

    local function showTransient(u14, u15) -- Line: 98
        -- upvalues: showText (copy), u7 (ref), u8 (ref), TutorialText (copy), TextLabel (copy)
        task.spawn(function() -- Line: 99
            -- upvalues: showText (ref), u14 (copy), u7 (ref), u15 (copy), u8 (ref), TutorialText (ref), TextLabel (ref)
            showText(u14);
            task.wait(u15);

            if u7 ~= u7 then
                return;
            end;

            if u8 then
                task.spawn(showText, u8);

                return;
            end;

            TutorialText.Visible = false;
            TextLabel.Text = "";
        end);
    end;

    local u16 = nil;
    local v17 = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Greedy"):WaitForChild("ArrowBeam"):Clone();
    v17.Anchored = true;
    v17.CFrame = CFrame.new(0, -500, 0);
    v17.Parent = workspace;
    local Start = v17:WaitForChild("Start");
    local End = v17:WaitForChild("End");
    local Beam = Start:WaitForChild("Beam");
    Beam.Enabled = false;
    v4:GiveTask(RunService.Heartbeat:Connect(function() -- Line: 128
        -- upvalues: u16 (ref), LocalPlayer (copy), Beam (copy), Start (copy), End (copy)
        local v18 = u16 and u16();
        local v19 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");

        if not (v18 and v19) then
            Beam.Enabled = false;

            return;
        end;

        local v20 = Vector3.new(v18.X - v19.Position.X, 0, v18.Z - v19.Position.Z);
        Start.WorldPosition = v19.Position + (v20.Magnitude > 1 and v20.Unit or Vector3.new(0, 0, 1)) * 4;
        End.WorldPosition = Vector3.new(v18.X, v19.Position.Y, v18.Z);
        Beam.Enabled = true;
    end));
    v4:GiveTask(v17);
    local u21 = nil;
    v6:GetMyPlot():andThen(function(p22) -- Line: 149
        -- upvalues: u21 (ref)
        u21 = p22;
    end);
    v4:GiveTask(v6.PlotAssigned:Connect(function(p23) -- Line: 150
        -- upvalues: u21 (ref)
        u21 = p23;
    end));

    local function myPlotModel() -- Line: 152
        -- upvalues: u21 (ref)
        if not u21 then
            return nil;
        end;

        local v24 = workspace:FindFirstChild("BigField") and workspace.BigField:FindFirstChild("PlayerPlots");

        if v24 then
            v24 = v24:FindFirstChild("PlayerPlot" .. u21);
        end;

        return v24;
    end;

    local function nearestOakSeed() -- Line: 158
        -- upvalues: LocalPlayer (copy)
        local v25 = workspace:FindFirstChild("BigField") and workspace.BigField:FindFirstChild("ConveyorSeeds");
        local v26 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");

        if not (v25 and v26) then
            return nil;
        end;

        local v27 = nil;
        local v28 = nil;

        for _, child in v25:GetChildren() do
            if child:GetAttribute("SeedType") == "Oak" then
                local Position = child:GetPivot().Position;
                local Magnitude = (Position - v26.Position).Magnitude;

                if not v27 or Magnitude < v27 then
                    v28 = Position;
                    v27 = Magnitude;
                end;
            end;
        end;

        return v28;
    end;

    local function myPlantPart() -- Line: 173
        -- upvalues: u21 (ref)
        local v29;

        if u21 then
            v29 = workspace:FindFirstChild("BigField") and workspace.BigField:FindFirstChild("PlayerPlots");

            if v29 then
                v29 = v29:FindFirstChild("PlayerPlot" .. u21);
            end;
        else
            v29 = nil;
        end;

        if v29 then
            v29 = v29:FindFirstChild("SeedPlot");
        end;

        if v29 then
            v29 = v29:FindFirstChild("PlotTP");
        end;

        return v29 and v29.Position or nil;
    end;

    local function sellStandPos() -- Line: 180
        local v30 = workspace:FindFirstChild("BigField") and workspace.BigField:FindFirstChild("SellStand");

        if v30 then
            v30 = v30:FindFirstChild("PromptHolder");
        end;

        return v30 and v30.Position or nil;
    end;

    local function myPlotCenter() -- Line: 186
        -- upvalues: u21 (ref)
        local v31;

        if u21 then
            v31 = workspace:FindFirstChild("BigField") and workspace.BigField:FindFirstChild("PlayerPlots");

            if v31 then
                v31 = v31:FindFirstChild("PlayerPlot" .. u21);
            end;
        else
            v31 = nil;
        end;

        if not v31 then
            return nil;
        end;

        for _, v in { "Plot3", "Plot2", "Plot1" } do
            local v32 = v31:FindFirstChild(v);

            if v32 then
                v32 = v32:FindFirstChild("Dirt");
            end;

            if v32 then
                return v32.Position + Vector3.new(0, v32.Size.Y / 2, 0);
            end;
        end;

        return nil;
    end;

    local u33 = Maid.new();
    v4:GiveTask(u33);
    local u34 = false;
    local Position = TutorialArrow.Position;
    local Position2 = TutorialArrow2.Position;

    local function stopArrow(p35, p36) -- Line: 207
        p35.Visible = false;
        p35.Position = p36;
    end;

    local function loopArrow(u37, u38, p39) -- Line: 212
        -- upvalues: TweenService (ref), u1 (ref), u33 (copy)
        u37.Visible = true;
        u37.Position = u38;
        local u40 = TweenService:Create(u37, u1, {
            Position = UDim2.new(u38.X.Scale + p39, u38.X.Offset, u38.Y.Scale, u38.Y.Offset)
        });
        u40:Play();
        u33:GiveTask(function() -- Line: 219
            -- upvalues: u40 (copy), u37 (copy), u38 (copy)
            u40:Cancel();
            local v41 = u37;
            v41.Visible = false;
            v41.Position = u38;
        end);
    end;

    local function onRebirthMenuOpened() -- Line: 225
        -- upvalues: TutorialArrow (copy), Position (copy), loopArrow (copy), TutorialArrow2 (copy), Position2 (copy), SkipRebirth (copy), Exit (copy), UI_Manager (copy), Rebirth (copy)
        local v42 = TutorialArrow;
        v42.Visible = false;
        v42.Position = Position;
        loopArrow(TutorialArrow2, Position2, 0.15);
        SkipRebirth.Visible = false;
        Exit.Visible = false;
        UI_Manager:SetTutorialWindowLock(Rebirth, Rebirth);
    end;

    local function clearRebirthPush() -- Line: 233
        -- upvalues: u34 (ref), u33 (copy), MainMenuDarken (copy), SkipRebirth (copy), Exit (copy), UI_Manager (copy)
        if not u34 then
            return;
        end;

        u34 = false;
        u33:DoCleaning();
        MainMenuDarken.Enabled = false;
        SkipRebirth.Visible = true;
        Exit.Visible = true;
        UI_Manager:SetTutorialWindowLock(nil, nil);
    end;

    local function activateRebirthPush() -- Line: 243
        -- upvalues: u34 (ref), MainMenuDarken (copy), UI_Manager (copy), Rebirth (copy), loopArrow (copy), TutorialArrow (copy), Position (copy), u33 (copy), TutorialArrow2 (copy), Position2 (copy), SkipRebirth (copy), Exit (copy)
        if u34 then
            return;
        end;

        u34 = true;
        MainMenuDarken.Enabled = true;
        UI_Manager:SetTutorialWindowLock(Rebirth, nil);
        loopArrow(TutorialArrow, Position, -0.15);
        u33:GiveTask(UI_Manager.WindowOpened:Connect(function(p43) -- Line: 249
            -- upvalues: Rebirth (ref), TutorialArrow (ref), Position (ref), loopArrow (ref), TutorialArrow2 (ref), Position2 (ref), SkipRebirth (ref), Exit (ref), UI_Manager (ref)
            if p43 == Rebirth then
                local v44 = TutorialArrow;
                v44.Visible = false;
                v44.Position = Position;
                loopArrow(TutorialArrow2, Position2, 0.15);
                SkipRebirth.Visible = false;
                Exit.Visible = false;
                UI_Manager:SetTutorialWindowLock(Rebirth, Rebirth);
            end;
        end));
    end;

    local function watchCoins(p45) -- Line: 254
        -- upvalues: DataClient (copy), RebirthConfig (ref), activateRebirthPush (copy)
        p45:GiveTask(DataClient.EV_UPDATE:Connect(function() -- Line: 255, Name: check
            -- upvalues: DataClient (ref), RebirthConfig (ref), activateRebirthPush (ref)
            local currentData = DataClient.currentData;

            if (currentData and (currentData.Currency and currentData.Currency.COINS) or 0) >= (RebirthConfig.GetCost(1) or (1 / 0)) then
                activateRebirthPush();
            end;
        end));
        local currentData = DataClient.currentData;

        if (currentData and (currentData.Currency and currentData.Currency.COINS) or 0) >= (RebirthConfig.GetCost(1) or (1 / 0)) then
            activateRebirthPush();
        end;
    end;

    local PlayerPlotController = p3.PlayerPlotController;
    local u46 = false;
    local u47 = 0;

    local function armCollectFruit(u48) -- Line: 273
        -- upvalues: u46 (ref), u8 (ref), showText (copy), u16 (ref), PlayerPlotController (copy)
        u46 = true;
        u8 = "Collect fruits";
        task.spawn(showText, "Collect fruits");

        u16 = function() -- Line: 276
            -- upvalues: PlayerPlotController (ref), u48 (copy)
            return PlayerPlotController:GetTutorialFruitTarget(u48);
        end;
    end;

    local function showPlantReminder() -- Line: 282
        -- upvalues: u46 (ref), u8 (ref), showText (copy), u16 (ref), myPlotCenter (copy)
        if u46 then
            return;
        end;

        u8 = "Plant full grown trees in your plot to harvest their fruit!";
        task.spawn(showText, "Plant full grown trees in your plot to harvest their fruit!");
        u16 = myPlotCenter;
    end;

    local u49 = Maid.new();
    v4:GiveTask(u49);

    local function render(p50) -- Line: 295
        -- upvalues: u49 (copy), u16 (ref), u8 (ref), u7 (ref), TutorialText (copy), TextLabel (copy), u34 (ref), u33 (copy), MainMenuDarken (copy), SkipRebirth (copy), Exit (copy), UI_Manager (copy), showText (copy), u5 (copy), nearestOakSeed (copy), myPlantPart (copy), sellStandPos (copy), DataClient (copy), RebirthConfig (ref), activateRebirthPush (copy)
        u49:DoCleaning();
        u16 = nil;
        u8 = nil;
        u7 = u7 + 1;
        TutorialText.Visible = false;
        TextLabel.Text = "";

        if u34 then
            u34 = false;
            u33:DoCleaning();
            MainMenuDarken.Enabled = false;
            SkipRebirth.Visible = true;
            Exit.Visible = true;
            UI_Manager:SetTutorialWindowLock(nil, nil);
        end;

        if p50 == 0 then
            task.spawn(function() -- Line: 302
                -- upvalues: showText (ref), u5 (ref)
                showText("Welcome to Greedy Growers!");
                task.wait(3);
                u5:WelcomeSeen();
            end);

            return;
        end;

        if p50 == 1 then
            u8 = "Buy an Oak Seed from the river";
            task.spawn(showText, "Buy an Oak Seed from the river");
            u16 = nearestOakSeed;

            return;
        end;

        if p50 == 2 then
            u8 = "Plant the seed";
            task.spawn(showText, "Plant the seed");
            u16 = myPlantPart;

            return;
        end;

        if p50 ~= 4 then
            if p50 == 5 then
                u49:GiveTask(DataClient.EV_UPDATE:Connect(function() -- Line: 255, Name: check
                    -- upvalues: DataClient (ref), RebirthConfig (ref), activateRebirthPush (ref)
                    local currentData = DataClient.currentData;

                    if (currentData and (currentData.Currency and currentData.Currency.COINS) or 0) >= (RebirthConfig.GetCost(1) or (1 / 0)) then
                        activateRebirthPush();
                    end;
                end));
                local currentData = DataClient.currentData;

                if (currentData and (currentData.Currency and currentData.Currency.COINS) or 0) >= (RebirthConfig.GetCost(1) or (1 / 0)) then
                    activateRebirthPush();
                end;
            end;

            return;
        end;

        u8 = "Sell the tree";
        task.spawn(showText, "Sell the tree");
        u16 = sellStandPos;
    end;

    v4:GiveTask(u5.StepChanged:Connect(function(p51) -- Line: 322
        -- upvalues: u34 (ref), u33 (copy), MainMenuDarken (copy), SkipRebirth (copy), Exit (copy), UI_Manager (copy), Rebirth (copy), render (copy)
        if p51 == 6 then
            if u34 then
                u34 = false;
                u33:DoCleaning();
                MainMenuDarken.Enabled = false;
                SkipRebirth.Visible = true;
                Exit.Visible = true;
                UI_Manager:SetTutorialWindowLock(nil, nil);
            end;

            UI_Manager:CloseWindow(Rebirth, true, true);
        end;

        render(p51);
    end));
    v4:GiveTask(u5.Event:Connect(function(p52, u53) -- Line: 331
        -- upvalues: showText (copy), u7 (ref), u8 (ref), TutorialText (copy), TextLabel (copy), u47 (ref), u16 (ref), myPlotCenter (copy), u46 (ref), PlayerPlotController (copy)
        if p52 == "lightning" then
            local u54 = "Be careful, lightning can strike at any moment!";
            local u55 = 6;
            task.spawn(function() -- Line: 99
                -- upvalues: showText (ref), u54 (copy), u7 (ref), u55 (copy), u8 (ref), TutorialText (ref), TextLabel (ref)
                showText(u54);
                task.wait(u55);

                if u7 ~= u7 then
                    return;
                end;

                if u8 then
                    task.spawn(showText, u8);

                    return;
                end;

                TutorialText.Visible = false;
                TextLabel.Text = "";
            end);

            return;
        end;

        if p52 == "finale" then
            u47 = u47 + 1;
            local u56 = u47;
            task.spawn(function() -- Line: 337
                -- upvalues: u16 (ref), myPlotCenter (ref), showText (ref), u56 (copy), u47 (ref), u46 (ref), u8 (ref)
                u16 = myPlotCenter;
                showText("You got a fully grown tree!");
                task.wait(3);

                if u56 == u47 then
                    if u46 then
                        return;
                    end;

                    u8 = "Plant full grown trees in your plot to harvest their fruit!";
                    task.spawn(showText, "Plant full grown trees in your plot to harvest their fruit!");
                    u16 = myPlotCenter;
                end;
            end);

            return;
        end;

        if p52 ~= "plantReminder" then
            if p52 == "plantHide" then
                u47 = u47 + 1;

                if not u46 then
                    u16 = nil;
                    u8 = nil;
                    u7 = u7 + 1;
                    TutorialText.Visible = false;
                    TextLabel.Text = "";

                    return;
                end;
            else
                if p52 == "collectFruit" then
                    u46 = true;
                    u8 = "Collect fruits";
                    task.spawn(showText, "Collect fruits");

                    u16 = function() -- Line: 276
                        -- upvalues: PlayerPlotController (ref), u53 (copy)
                        return PlayerPlotController:GetTutorialFruitTarget(u53);
                    end;

                    return;
                end;

                if p52 == "fruitTip" then
                    u46 = false;
                    u16 = nil;
                    u8 = nil;
                    u7 = u7 + 1;
                    TutorialText.Visible = false;
                    TextLabel.Text = "";
                    local u57 = "Tip: Fruits can mutate during weather events!";
                    local u58 = 6;
                    task.spawn(function() -- Line: 99
                        -- upvalues: showText (ref), u57 (copy), u7 (ref), u58 (copy), u8 (ref), TutorialText (ref), TextLabel (ref)
                        showText(u57);
                        task.wait(u58);

                        if u7 ~= u7 then
                            return;
                        end;

                        if u8 then
                            task.spawn(showText, u8);

                            return;
                        end;

                        TutorialText.Visible = false;
                        TextLabel.Text = "";
                    end);

                    return;
                end;

                if p52 == "ungrownTreeTip" then
                    local u59 = "Tip: This tree isn\'t fully grown, so it can\'t grow fruits!";
                    local u60 = 6;
                    task.spawn(function() -- Line: 99
                        -- upvalues: showText (ref), u59 (copy), u7 (ref), u60 (copy), u8 (ref), TutorialText (ref), TextLabel (ref)
                        showText(u59);
                        task.wait(u60);

                        if u7 ~= u7 then
                            return;
                        end;

                        if u8 then
                            task.spawn(showText, u8);

                            return;
                        end;

                        TutorialText.Visible = false;
                        TextLabel.Text = "";
                    end);
                end;
            end;

            return;
        end;

        if u46 then
            return;
        end;

        u8 = "Plant full grown trees in your plot to harvest their fruit!";
        task.spawn(showText, "Plant full grown trees in your plot to harvest their fruit!");
        u16 = myPlotCenter;
    end));
    task.spawn(function() -- Line: 366
        -- upvalues: DataClient (copy), LocalPlayer (copy), u5 (copy), render (copy), u46 (ref), u8 (ref), showText (copy), u16 (ref), PlayerPlotController (copy), myPlotCenter (copy)
        if not DataClient:GetLoaded() then
            DataClient.EV_FIRST_UPDATE:Wait();
        end;

        if not LocalPlayer.Character then
            LocalPlayer.CharacterAdded:Wait();
        end;

        task.wait(1.5);
        local v61, v62 = u5:GetStep():await();

        if v61 and v62 ~= nil then
            render(v62);
        end;

        if v61 and v62 == 7 then
            local v63, v64 = u5:GetFruitPending():await();

            if v63 and v64 then
                for _ = 1, 10 do
                    if u46 then
                        break;
                    end;

                    local v65, u66 = u5:GetFruitObjective():await();

                    if v65 and u66 then
                        u46 = true;
                        u8 = "Collect fruits";
                        task.spawn(showText, "Collect fruits");

                        u16 = function() -- Line: 276
                            -- upvalues: PlayerPlotController (ref), u66 (copy)
                            return PlayerPlotController:GetTutorialFruitTarget(u66);
                        end;

                        break;
                    end;

                    task.wait(1);
                end;

                if not u46 then
                    local v67, v68 = u5:GetPlantHintNeeded():await();

                    if v67 and v68 then
                        if u46 then
                            return;
                        end;

                        u8 = "Plant full grown trees in your plot to harvest their fruit!";
                        task.spawn(showText, "Plant full grown trees in your plot to harvest their fruit!");
                        u16 = myPlotCenter;
                    end;
                end;
            end;
        end;
    end);
end;

function v2.KnitInit(p69) -- Line: 403
    -- upvalues: Knit (copy)
    p69.UI_Manager = Knit.GetController("UI_Manager");
    p69.DataClient = Knit.GetController("DataClient");
    p69.SoundController = Knit.GetController("SoundController");
    p69.PlayerPlotController = Knit.GetController("PlayerPlotController");
end;

return v2;