-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
game:GetService("Debris");
local TopText = require(game.ReplicatedStorage.ClientModules.TopText);
local NPC = require(game.ReplicatedStorage.ClientModules.NPC);
local _ = game.Players.LocalPlayer;
local u1 = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0);
local u2 = {};

local function tweenHighlightTransparency(u3, p4) -- Line: 19
    -- upvalues: u2 (copy), TweenService (copy), u1 (copy)
    local v5 = u2[u3];

    if v5 then
        v5:Cancel();
        v5:Destroy();
        u2[u3] = nil;
    end;

    local u6 = TweenService:Create(u3, u1, {
        OutlineTransparency = p4
    });
    u2[u3] = u6;
    u6.Completed:Once(function() -- Line: 28
        -- upvalues: u2 (ref), u3 (copy), u6 (copy)
        if u2[u3] == u6 then
            u2[u3] = nil;
        end;

        u6:Destroy();
    end);
    u6:Play();
end;

local v7 = {};
local u8 = false;

function v7.DoDialogue(p9, u10) -- Line: 87
    -- upvalues: TopText (copy), u8 (ref), NPC (copy), tweenHighlightTransparency (copy)
    local ProximityPrompt = u10.ProximityPrompt;
    local SpeakingNPC = u10.SpeakingNPC;
    local PromptList = u10.PromptList;
    local OperationMap = u10.OperationMap;
    local IntroLines = u10.IntroLines;
    local LocalPlayer = game.Players.LocalPlayer;
    local u11 = u10.RootPart or (SpeakingNPC:FindFirstChild("HumanoidRootPart") or SpeakingNPC);
    local DialogueHighlight = SpeakingNPC:FindFirstChild("DialogueHighlight");

    if not DialogueHighlight then
        DialogueHighlight = Instance.new("Highlight");

        if DialogueHighlight and DialogueHighlight:IsA("Highlight") then
            DialogueHighlight.Name = "DialogueHighlight";
            DialogueHighlight.DepthMode = Enum.HighlightDepthMode.Occluded;
            DialogueHighlight.FillTransparency = 1;
            DialogueHighlight.OutlineTransparency = 1;
            DialogueHighlight.Adornee = SpeakingNPC;
            DialogueHighlight.Parent = SpeakingNPC;
        end;
    end;

    local u12 = false;
    local u13 = false;
    local u14 = nil;
    local u15 = {};

    local function IsDialogueEnabled() -- Line: 126
        -- upvalues: SpeakingNPC (copy)
        if SpeakingNPC.Parent then
            return not SpeakingNPC:GetAttribute("DisableDialogue");
        end;

        return false;
    end;

    local function EndConversation(p16) -- Line: 133
        -- upvalues: TopText (ref), SpeakingNPC (copy), LocalPlayer (copy), u12 (ref), u14 (ref), u15 (copy), u13 (ref), u8 (ref), ProximityPrompt (copy), NPC (ref)
        TopText.TakeAwayResponses(SpeakingNPC, LocalPlayer);
        TopText.RemovePlayerSideFrame(LocalPlayer);

        if not u12 then
            return;
        end;

        if u14 then
            task.cancel(u14);
        end;

        for _, v in u15 do
            v:Disconnect();
        end;

        table.clear(u15);
        TopText.TakeAwayResponses(SpeakingNPC, LocalPlayer);
        TopText.RemovePlayerSideFrame(LocalPlayer);

        if p16.OnDialogueEnded then
            p16.OnDialogueEnded();
        end;

        u13 = false;
        u12 = false;

        if SpeakingNPC.Parent then
            SpeakingNPC:SetAttribute("ConversationStarted", false);
        end;

        u8 = false;
        task.defer(function() -- Line: 168
            -- upvalues: TopText (ref), SpeakingNPC (ref), LocalPlayer (ref)
            TopText.TakeAwayResponses(SpeakingNPC, LocalPlayer);
            TopText.RemovePlayerSideFrame(LocalPlayer);
        end);
        task.wait(0.5);

        if ProximityPrompt.Parent then
            local v17;

            if SpeakingNPC.Parent then
                v17 = not SpeakingNPC:GetAttribute("DisableDialogue");
            else
                v17 = false;
            end;

            ProximityPrompt.Enabled = v17;
        end;

        NPC.EndSpeaking(LocalPlayer);
    end;

    local function StartConversation(p18) -- Line: 180
        -- upvalues: u8 (ref), u12 (ref), SpeakingNPC (copy), NPC (ref), LocalPlayer (copy), u13 (ref), ProximityPrompt (copy), IntroLines (copy), TopText (ref), EndConversation (copy), PromptList (copy), u15 (copy), OperationMap (copy), u14 (ref)
        if u8 then
            return;
        end;

        if u12 then
            return;
        end;

        local v19;

        if SpeakingNPC.Parent then
            v19 = not SpeakingNPC:GetAttribute("DisableDialogue");
        else
            v19 = false;
        end;

        if not v19 then
            return;
        end;

        u12 = true;
        SpeakingNPC:SetAttribute("ConversationStarted", true);
        u8 = true;
        NPC.StartSpeaking(LocalPlayer);
        u13 = false;
        ProximityPrompt.Enabled = false;

        if p18.OnDialogueStarted then
            p18.OnDialogueStarted();
        end;

        if IntroLines then
            if p18.RandomIntroLine then
                local v20 = Random.new();
                TopText.NpcText(SpeakingNPC, IntroLines[v20:NextInteger(1, #IntroLines)], true);
                task.wait(0.5);
            else
                for _, v in IntroLines do
                    TopText.NpcText(SpeakingNPC, v, true);
                    task.wait(0.5);
                end;
            end;
        end;

        if not u12 or u13 then
            EndConversation(p18);

            return;
        end;

        if #PromptList > 0 then
            local u21 = TopText.ShowChoices(LocalPlayer, PromptList);
            local u22 = "";

            if not u12 or u13 then
                TopText.TakeAwayResponses(SpeakingNPC, LocalPlayer);
                TopText.RemovePlayerSideFrame(LocalPlayer);

                return;
            end;

            table.clear(u15);

            for _, v in u21 do
                local Frame = v:FindFirstChild("Frame");

                if Frame then
                    local ImageButton = Frame:FindFirstChild("ImageButton");

                    if ImageButton then
                        table.insert(u15, ImageButton.MouseButton1Click:Connect(function() -- Line: 243
                            -- upvalues: u22 (ref), Frame (copy)
                            u22 = Frame.Frame.Text_Element:GetAttribute("Text");
                        end));
                    end;
                end;
            end;

            local v25 = TopText.ConnectChoiceKeyboard(u21, function(p23) -- Line: 252
                -- upvalues: u22 (ref), u21 (copy)
                if u22 ~= "" then
                    return;
                end;

                local v24 = u21[p23];

                if v24 then
                    v24 = v24:FindFirstChild("Frame");
                end;

                if not v24 then
                    return;
                end;

                local Text_Element = v24.Frame:FindFirstChild("Text_Element");

                if not Text_Element then
                    return;
                end;

                u22 = Text_Element:GetAttribute("Text") or "";
            end);

            if not u12 or u13 then
                for _, v in u15 do
                    v:Disconnect();
                end;

                table.clear(u15);
                v25();
                TopText.TakeAwayResponses(SpeakingNPC, LocalPlayer);
                TopText.RemovePlayerSideFrame(LocalPlayer);

                return;
            end;

            while u22 == "" do
                task.wait();

                if u13 or not u12 then
                    for _, v in u15 do
                        v:Disconnect();
                    end;

                    table.clear(u15);
                    v25();
                    TopText.TakeAwayResponses(SpeakingNPC, LocalPlayer);
                    TopText.RemovePlayerSideFrame(LocalPlayer);

                    return;
                end;
            end;

            for _, v in u15 do
                v:Disconnect();
            end;

            v25();
            TopText.RemovePlayerSideFrame(LocalPlayer);

            if LocalPlayer.Character then
                TopText.PlayerResponse(LocalPlayer.Character, u22, true);
                local v26 = OperationMap[u22];

                if v26 then
                    u14 = task.spawn(v26);

                    repeat
                        task.wait();
                    until coroutine.status(u14) == "dead";
                end;
            end;
        end;

        EndConversation(p18);
    end;

    local u28 = ProximityPrompt.Triggered:Connect(function(p27) -- Line: 303
        -- upvalues: StartConversation (copy), u10 (copy)
        StartConversation(u10);
    end);
    local u29 = ProximityPrompt.MaxActivationDistance + 1;
    local u30 = SpeakingNPC.Destroying:Connect(function() -- Line: 310
        -- upvalues: u12 (ref), u13 (ref), EndConversation (copy), u10 (copy)
        if u12 then
            u13 = true;
            EndConversation(u10);
        end;
    end);
    local u35 = task.spawn(function() -- Line: 318
        -- upvalues: SpeakingNPC (copy), u12 (ref), EndConversation (copy), u10 (copy), LocalPlayer (copy), u11 (copy), u29 (copy), TopText (ref), u30 (ref)
        local v31 = false;

        while SpeakingNPC.Parent do
            task.wait(0.1);

            if not v31 and u12 then
                local v32;

                if SpeakingNPC.Parent then
                    v32 = not SpeakingNPC:GetAttribute("DisableDialogue");
                else
                    v32 = false;
                end;

                if v32 then
                    if SpeakingNPC:IsDescendantOf(workspace) then
                        if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
                            local v33 = nil;

                            if u11 and u11.Parent then
                                if u11:IsA("BasePart") then
                                    v33 = u11.Position;
                                elseif u11:IsA("Attachment") then
                                    v33 = u11.WorldPosition;
                                elseif u11:IsA("Model") then
                                    v33 = u11:GetPivot().Position;
                                end;
                            end;

                            if v33 and (LocalPlayer.Character.PrimaryPart.Position - v33).Magnitude >= u29 then
                                if u10.ExitLine then
                                    if u10.RandomExitLine and typeof(u10.ExitLine) == "table" then
                                        local v34 = Random.new();
                                        TopText.NpcText(SpeakingNPC, u10.ExitLine[v34:NextInteger(1, #u10.ExitLine)], true);
                                        v31 = false;
                                    else
                                        TopText.NpcText(SpeakingNPC, u10.ExitLine, true);
                                        v31 = false;
                                    end;
                                end;

                                EndConversation(u10);
                            end;
                        end;
                    else
                        EndConversation(u10);
                    end;
                else
                    EndConversation(u10);
                end;
            end;
        end;

        if u30 then
            u30:Disconnect();
        end;
    end);
    local u37 = ProximityPrompt.PromptShown:Connect(function() -- Line: 374
        -- upvalues: SpeakingNPC (copy), DialogueHighlight (ref), tweenHighlightTransparency (ref)
        local v36;

        if SpeakingNPC.Parent then
            v36 = not SpeakingNPC:GetAttribute("DisableDialogue");
        else
            v36 = false;
        end;

        if not v36 then
            return;
        end;

        assert(DialogueHighlight:IsA("Highlight"));
        tweenHighlightTransparency(DialogueHighlight, 0);
    end);
    local u38 = ProximityPrompt.PromptHidden:Connect(function() -- Line: 380
        -- upvalues: DialogueHighlight (ref), tweenHighlightTransparency (ref)
        assert(DialogueHighlight:IsA("Highlight"));
        tweenHighlightTransparency(DialogueHighlight, 1);
    end);

    return {
        End = function(p39) -- Line: 387, Name: End
            -- upvalues: u12 (ref), u13 (ref), EndConversation (copy), u10 (copy)
            if u12 then
                u13 = true;
                EndConversation(u10);
            end;
        end,

        Destroy = function(p40) -- Line: 395, Name: Destroy
            -- upvalues: u12 (ref), u13 (ref), EndConversation (copy), u10 (copy), u30 (ref), u35 (ref), u37 (ref), u38 (ref), u28 (ref)
            if u12 then
                u13 = true;
                EndConversation(u10);
            end;

            if u30 then
                u30:Disconnect();
                u30 = nil;
            end;

            if u35 then
                task.cancel(u35);
                u35 = nil;
            end;

            if u37 then
                u37:Disconnect();
                u37 = nil;
            end;

            if u38 then
                u38:Disconnect();
                u38 = nil;
            end;

            if u28 then
                u28:Disconnect();
                u28 = nil;
            end;
        end,

        IsActive = function(p41) -- Line: 424, Name: IsActive
            -- upvalues: u12 (ref)
            return u12;
        end
    };
end;

return v7;