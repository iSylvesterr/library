-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local ScreenResolution = require(ReplicatedStorage.ClientModules.ScreenResolution);
local ScreenConfetti = require(ReplicatedStorage.ClientModules.Effects.ScreenConfetti);

local function dprint(...) -- Line: 21
end;

local function sizeRow(p1, p2) -- Line: 42
    -- upvalues: ScreenResolution (copy)
    local v3 = p2 * 1000 * ScreenResolution.GetResolutionScale();
    local v4 = math.round(v3);
    p1.Size = UDim2.new(p1.Size.X.Scale, p1.Size.X.Offset, 0, v4);
end;

local function fmtHMS(p5) -- Line: 47
    local v6 = math.floor(p5);
    local v7 = math.max(0, v6);

    return string.format("%02d:%02d:%02d", v7 // 3600, v7 % 3600 // 60, v7 % 60);
end;

local function fmtNum(p8) -- Line: 53
    if p8 ~= math.floor(p8) then
        return string.format("%.1f", p8);
    end;

    local v9 = math.floor(p8);

    return tostring(v9);
end;

local function setLayeredText(p10, p11) -- Line: 62
    if not (p10 and p10:IsA("TextLabel")) then
        return;
    end;

    p10.Text = p11;
    local TextLabel = p10:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.Text = p11;
    end;
end;

local function setProgressBar(p12, p13) -- Line: 71
    local ProgressBarContainer = p12:FindFirstChild("ProgressBarContainer");

    if not ProgressBarContainer then
        return;
    end;

    local v14 = tonumber(p13.Target) or 1;
    local v15 = tonumber(p13.Progress) or 0;
    local v16 = v14 <= 0 and 0 or math.clamp(v15 / v14, 0, 1);
    local ProgressBar = ProgressBarContainer:FindFirstChild("ProgressBar");

    if ProgressBar and ProgressBar:IsA("GuiObject") then
        ProgressBar.Size = UDim2.new(v16, 0, ProgressBar.Size.Y.Scale, ProgressBar.Size.Y.Offset);
    end;

    local Amount = ProgressBarContainer:FindFirstChild("Amount");

    if Amount and Amount:IsA("TextLabel") then
        local v17 = math.floor(v16 * 100 + 0.5);
        local v18 = p13.Unit == "kg" and "kg" or "";
        local format = string.format;
        local v19;

        if v15 == math.floor(v15) then
            local v20 = math.floor(v15);
            v19 = tostring(v20);
        else
            v19 = string.format("%.1f", v15);
        end;

        local v21;

        if v14 == math.floor(v14) then
            local v22 = math.floor(v14);
            v21 = tostring(v22);
        else
            v21 = string.format("%.1f", v14);
        end;

        Amount.Text = format("%d%% (%s%s/%s%s)", v17, v19, v18, v21, v18);
    end;
end;

local function setup() -- Line: 91
    -- upvalues: Players (copy), dprint (copy), ScreenResolution (copy), fmtHMS (copy), setProgressBar (copy), Networking (copy), ScreenConfetti (copy), RunService (copy)
    local LocalPlayer = Players.LocalPlayer;
    local PilgrimQuests = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("PilgrimQuests");
    local Frame = PilgrimQuests:WaitForChild("Frame");
    local Header = Frame:WaitForChild("Header");
    local Content = Frame:WaitForChild("Content");
    local QuestInfo = Content:WaitForChild("QuestInfo");
    local Frame2 = Content:WaitForChild("Frame");
    local ExitButton = Header:WaitForChild("ExitButton");
    local QuestTemplate_Ongoing = Frame2:WaitForChild("QuestTemplate_Ongoing");
    local QuestTemplate_Completed = Frame2:WaitForChild("QuestTemplate_Completed");
    local QuestTemplate_Future = Frame2:WaitForChild("QuestTemplate_Future");
    local FinalReward = Frame2:WaitForChild("FinalReward");
    local Progression_Filled = Frame2:FindFirstChild("Progression_Filled");
    local Progression_Empty = Frame2:FindFirstChild("Progression_Empty");
    local GuiController = require(LocalPlayer.PlayerScripts:WaitForChild("Controllers"):WaitForChild("GuiController"));
    local u23 = Frame2:FindFirstChildOfClass("UIListLayout");
    dprint("setup: list is", Frame2.ClassName, "layout found:", u23 ~= nil);

    local function refreshCanvas() -- Line: 120
        -- upvalues: Frame2 (copy), u23 (copy), ScreenResolution (ref), dprint (ref)
        if Frame2:IsA("ScrollingFrame") and u23 then
            Frame2.AutomaticCanvasSize = Enum.AutomaticSize.None;
            local v24 = 24 * ScreenResolution.GetResolutionScale();
            local v25 = math.round(v24);
            Frame2.CanvasSize = UDim2.new(0, 0, 0, u23.AbsoluteContentSize.Y + v25);
            dprint("refreshCanvas: window.Y=", math.floor(Frame2.AbsoluteSize.Y), "content.Y=", math.floor(u23.AbsoluteContentSize.Y), "canvas=", (tostring(Frame2.CanvasSize)));
        end;
    end;

    if u23 then
        u23:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshCanvas);
    end;

    refreshCanvas();
    local Folder = Instance.new("Folder");
    Folder.Name = "PilgrimTemplateStore";
    Folder.Parent = script;

    for _, child in Frame2:GetChildren() do
        if child ~= FinalReward and (child:IsA("GuiObject") and (string.find(child.Name, "QuestTemplate_", 1, true) == 1 or string.find(child.Name, "Progression_", 1, true) == 1)) then
            child.Parent = Folder;
        end;
    end;

    local u26 = not FinalReward:IsA("GuiObject") and 0 or FinalReward.Size.Y.Scale;
    local u27 = {
        completed = QuestTemplate_Completed,
        ongoing = QuestTemplate_Ongoing,
        future = QuestTemplate_Future
    };
    local u28 = {};
    local u29 = nil;
    local u30 = false;
    local u31 = false;

    local function clearClones() -- Line: 172
        -- upvalues: u28 (copy)
        for _, v in u28 do
            v:Destroy();
        end;

        table.clear(u28);
    end;

    local function updateHeader() -- Line: 179
        -- upvalues: u29 (ref), QuestInfo (copy), fmtHMS (ref)
        if not u29 then
            return;
        end;

        local v32 = (u29.ResetAtUnix or 0) - workspace:GetServerTimeNow();
        QuestInfo.Text = string.format("%d/%d Quests Completed (Refresh in %s)", u29.Done or 0, u29.Total or 0, fmtHMS(v32));
    end;

    local u33 = 0;

    local function addClone(p34, p35) -- Line: 191
        -- upvalues: u33 (ref), ScreenResolution (ref), Frame2 (copy), u28 (copy)
        if not p34 then
            return nil;
        end;

        u33 = u33 + 1;
        local v36 = p34:Clone();
        v36.Name = p35;

        if v36:IsA("GuiObject") then
            v36.LayoutOrder = u33;
            v36.Visible = true;
            local v37 = v36.Size.Y.Scale * 1000 * ScreenResolution.GetResolutionScale();
            local v38 = math.round(v37);
            v36.Size = UDim2.new(v36.Size.X.Scale, v36.Size.X.Offset, 0, v38);
        end;

        v36.Parent = Frame2;
        table.insert(u28, v36);

        return v36;
    end;

    local function addConnector(p39, p40) -- Line: 210
        -- upvalues: Progression_Filled (copy), Progression_Empty (copy), u33 (ref), ScreenResolution (ref), Frame2 (copy), u28 (copy)
        local v41;

        if p39 then
            v41 = Progression_Filled;
        else
            v41 = Progression_Empty;
        end;

        if not v41 then
            return;
        end;

        u33 = u33 + 1;
        local v42 = v41:Clone();
        v42.Name = p40;

        if v42:IsA("GuiObject") then
            v42.LayoutOrder = u33;
            v42.Visible = true;
            local v43 = v42.Size.Y.Scale * 1000 * ScreenResolution.GetResolutionScale();
            local v44 = math.round(v43);
            v42.Size = UDim2.new(v42.Size.X.Scale, v42.Size.X.Offset, 0, v44);
        end;

        v42.Parent = Frame2;
        table.insert(u28, v42);
    end;

    local function render(p45) -- Line: 214
        -- upvalues: u29 (ref), u28 (copy), u33 (ref), dprint (ref), u27 (copy), ScreenResolution (ref), Frame2 (copy), setProgressBar (ref), u30 (ref), Networking (ref), render (copy), Progression_Filled (copy), Progression_Empty (copy), FinalReward (copy), u26 (copy), QuestInfo (copy), fmtHMS (ref)
        u29 = p45;

        for _, v in u28 do
            v:Destroy();
        end;

        table.clear(u28);
        u33 = 0;
        local v46;

        if p45 then
            v46 = p45.Enabled;
        else
            v46 = p45;
        end;

        dprint("render: enabled=", v46, "questCount=", p45 and type(p45.Quests) == "table" and (#p45.Quests or "n/a") or "n/a");

        if not p45 or (not p45.Enabled or type(p45.Quests) ~= "table") then
            return;
        end;

        for i, v in p45.Quests do
            local v47 = u27[v.Status];

            if v47 then
                local v48 = `Quest_{i}`;
                local v49;

                if v47 then
                    u33 = u33 + 1;
                    v49 = v47:Clone();
                    v49.Name = v48;

                    if v49:IsA("GuiObject") then
                        v49.LayoutOrder = u33;
                        v49.Visible = true;
                        local v50 = v49.Size.Y.Scale * 1000 * ScreenResolution.GetResolutionScale();
                        local v51 = math.round(v50);
                        v49.Size = UDim2.new(v49.Size.X.Scale, v49.Size.X.Offset, 0, v51);
                    end;

                    v49.Parent = Frame2;
                    table.insert(u28, v49);
                else
                    v49 = nil;
                end;

                if v49 then
                    if v.Status ~= "future" then
                        local QuestName = v49:FindFirstChild("QuestName");
                        local v52 = tostring(v.Description);

                        if QuestName and QuestName:IsA("TextLabel") then
                            QuestName.Text = v52;
                            local TextLabel = QuestName:FindFirstChild("TextLabel");

                            if TextLabel and TextLabel:IsA("TextLabel") then
                                TextLabel.Text = v52;
                            end;
                        end;

                        setProgressBar(v49, v);
                    end;

                    local v53;

                    if v.Status == "ongoing" then
                        v53 = v.Kind == "delivery";
                    else
                        v53 = false;
                    end;

                    local SubmitButton = v49:FindFirstChild("SubmitButton");

                    if SubmitButton and SubmitButton:IsA("GuiButton") then
                        SubmitButton.Visible = v53;

                        if v53 then
                            SubmitButton.MouseButton1Click:Connect(function() -- Line: 248
                                -- upvalues: u30 (ref), Networking (ref), render (ref)
                                if u30 then
                                    return;
                                end;

                                u30 = true;
                                local v54 = Networking.Pilgrim.SubmitDelivery:Fire();
                                u30 = false;

                                if v54 then
                                    render(v54);
                                end;
                            end);
                        end;
                    end;

                    if v.Status == "ongoing" then
                        local TextLabel = v49:FindFirstChild("TextLabel");

                        if TextLabel and TextLabel:IsA("TextLabel") then
                            TextLabel.Visible = not v53;
                        end;
                    end;
                end;
            end;

            local v55 = v.Status == "completed";
            local v56 = `Conn_{i}`;
            local v57;

            if v55 then
                v57 = Progression_Filled;
            else
                v57 = Progression_Empty;
            end;

            if v57 then
                u33 = u33 + 1;
                local v58 = v57:Clone();
                v58.Name = v56;

                if v58:IsA("GuiObject") then
                    v58.LayoutOrder = u33;
                    v58.Visible = true;
                    local v59 = v58.Size.Y.Scale * 1000 * ScreenResolution.GetResolutionScale();
                    local v60 = math.round(v59);
                    v58.Size = UDim2.new(v58.Size.X.Scale, v58.Size.X.Offset, 0, v60);
                end;

                v58.Parent = Frame2;
                table.insert(u28, v58);
            end;
        end;

        local Reward = FinalReward:FindFirstChild("Reward");
        local v61;

        if Reward then
            v61 = Reward:FindFirstChild("Name");
        else
            v61 = Reward;
        end;

        local v62 = tostring(p45.RewardName or "Reward");

        if v61 and v61:IsA("TextLabel") then
            v61.Text = v62;
            local TextLabel = v61:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.Text = v62;
            end;
        end;

        if Reward then
            local v63;

            if p45.ChainComplete == true then
                v63 = p45.RewardClaimed ~= true;
            else
                v63 = false;
            end;

            local Overshadow = Reward:FindFirstChild("Overshadow");

            if Overshadow and Overshadow:IsA("GuiObject") then
                Overshadow.Visible = not v63;
            end;

            local Claimed = Reward:FindFirstChild("Claimed");

            if Claimed and Claimed:IsA("GuiObject") then
                Claimed.Visible = p45.RewardClaimed == true;
            end;

            if Reward:IsA("GuiButton") then
                Reward.Active = v63;
            end;
        end;

        if FinalReward:IsA("GuiObject") then
            local v64 = FinalReward;
            local v65 = u26 * 1000 * ScreenResolution.GetResolutionScale();
            local v66 = math.round(v65);
            v64.Size = UDim2.new(v64.Size.X.Scale, v64.Size.X.Offset, 0, v66);
        end;

        if not u29 then
            return;
        end;

        local v67 = (u29.ResetAtUnix or 0) - workspace:GetServerTimeNow();
        QuestInfo.Text = string.format("%d/%d Quests Completed (Refresh in %s)", u29.Done or 0, u29.Total or 0, fmtHMS(v67));
    end;

    ExitButton.MouseButton1Click:Connect(function() -- Line: 330
        -- upvalues: GuiController (copy)
        GuiController:Close();
    end);
    local u68 = nil;

    local function playClaimConfetti() -- Line: 338
        -- upvalues: u68 (ref), ScreenConfetti (ref)
        if u68 and u68:IsActive() then
            u68:Stop();
        end;

        u68 = ScreenConfetti.Play(ScreenConfetti.GrandPrizeParams);
    end;

    local Reward = FinalReward:FindFirstChild("Reward");

    if Reward and Reward:IsA("GuiButton") then
        Reward.MouseButton1Click:Connect(function() -- Line: 347
            -- upvalues: u31 (ref), u29 (ref), Networking (ref), render (copy), u68 (ref), ScreenConfetti (ref)
            if u31 or not u29 then
                return;
            end;

            if u29.ChainComplete ~= true or u29.RewardClaimed == true then
                return;
            end;

            u31 = true;
            local v69 = Networking.Pilgrim.ClaimReward:Fire();
            u31 = false;

            if v69 then
                render(v69);

                if v69.RewardClaimed == true then
                    if u68 and u68:IsActive() then
                        u68:Stop();
                    end;

                    u68 = ScreenConfetti.Play(ScreenConfetti.GrandPrizeParams);
                end;
            end;
        end);
    end;

    PilgrimQuests:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 365
        -- upvalues: PilgrimQuests (copy), Networking (ref), render (copy)
        if not PilgrimQuests.Enabled then
            return;
        end;

        task.spawn(function() -- Line: 367
            -- upvalues: Networking (ref), render (ref)
            render((Networking.Pilgrim.GetState:Fire()));
        end);
    end);
    Networking.Pilgrim.StateUpdated.OnClientEvent:Connect(function(p70) -- Line: 373
        -- upvalues: render (copy)
        render(p70);
    end);
    ScreenResolution.Observe(function() -- Line: 379
        -- upvalues: u29 (ref), render (copy)
        if u29 then
            render(u29);
        end;
    end);
    local u71 = 0;
    RunService.Heartbeat:Connect(function(p72) -- Line: 387
        -- upvalues: u71 (ref), PilgrimQuests (copy), u29 (ref), QuestInfo (copy), fmtHMS (ref)
        u71 = u71 + p72;

        if u71 < 1 then
            return;
        end;

        u71 = 0;

        if PilgrimQuests.Enabled and u29 then
            if not u29 then
                return;
            end;

            local v73 = (u29.ResetAtUnix or 0) - workspace:GetServerTimeNow();
            QuestInfo.Text = string.format("%d/%d Quests Completed (Refresh in %s)", u29.Done or 0, u29.Total or 0, fmtHMS(v73));
        end;
    end);
end;

return function() -- Line: 399
    -- upvalues: setup (copy)
    task.spawn(setup);
end;