-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local TopText = require(ReplicatedStorage.ClientModules.TopText);
local NPC = require(ReplicatedStorage.ClientModules.NPC);
local LocalPlayer = Players.LocalPlayer;
LocalPlayer:WaitForChild("PlayerGui");
local GuiController = require(LocalPlayer.PlayerScripts.Controllers.GuiController);
local NotificationController = require(LocalPlayer.PlayerScripts.Controllers.NotificationController);
local ViewGuildProgressController = require(LocalPlayer.PlayerScripts.Controllers.ViewGuildProgressController);
local u1 = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
local u2 = { "View Guild", "View Leaderboard", "View Rewards", "Nevermind" };
local u3 = { "Create Guild", "View Leaderboard", "View Rewards", "What are guilds?", "Nevermind" };
local u4 = { "What can I do for you, member?", "Welcome back. How\'s the guild?" };
local u5 = { "Looking to start a guild?", "Need help with guilds?" };
local u6 = false;
local u7 = nil;

local function IsInGuild() -- Line: 52
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("GuildId") ~= nil;
end;

local function PickRandom(p8) -- Line: 56
    return p8[math.random(1, #p8)];
end;

local function SetHighlight(p9, p10) -- Line: 60
    -- upvalues: TweenService (copy), u1 (copy)
    local DialogueHighlight = p9:FindFirstChild("DialogueHighlight");

    if not DialogueHighlight then
        DialogueHighlight = Instance.new("Highlight");
        DialogueHighlight.Name = "DialogueHighlight";
        DialogueHighlight.DepthMode = Enum.HighlightDepthMode.Occluded;
        DialogueHighlight.FillTransparency = 1;
        DialogueHighlight.OutlineTransparency = 1;
        DialogueHighlight.Adornee = p9;
        DialogueHighlight.Parent = p9;
    end;

    assert(DialogueHighlight);
    TweenService:Create(DialogueHighlight, u1, {
        OutlineTransparency = p10
    }):Play();
end;

local function OpenGuildShop(p11) -- Line: 77
    -- upvalues: GuiController (copy)
    GuiController:Open("GuildShop");
end;

local function WaitForSelection(p12, p13) -- Line: 81
    -- upvalues: TopText (copy), u6 (ref)
    local u14 = TopText.ShowChoices(p12, p13);

    if #u14 == 0 then
        return nil, nil;
    end;

    local function anyAlive() -- Line: 90
        -- upvalues: u14 (copy)
        for _, v in u14 do
            if v and v.Parent then
                return true;
            end;
        end;

        return false;
    end;

    local v15 = {};
    local u16 = nil;

    for i, v in u14 do
        local Frame = v:FindFirstChild("Frame");

        if Frame then
            local ImageButton = Frame:FindFirstChild("ImageButton");

            if ImageButton and ImageButton:IsA("GuiButton") then
                table.insert(v15, ImageButton.MouseButton1Click:Connect(function() -- Line: 104
                    -- upvalues: u16 (ref), i (copy)
                    u16 = i;
                end));
            end;
        end;
    end;

    local v18 = TopText.ConnectChoiceKeyboard(u14, function(p17) -- Line: 110
        -- upvalues: u16 (ref)
        if u16 == nil then
            u16 = p17;
        end;
    end);

    while true do
        if u16 ~= nil then
            for _, v in v15 do
                v:Disconnect();
            end;

            v18();
            TopText.RemovePlayerSideFrame(p12);
            local v19 = p13[u16];

            if p12.Character then
                TopText.PlayerResponse(p12.Character, v19, true);
            end;

            return u16, v19;
        end;

        if not u6 then
            for _, v in v15 do
                v:Disconnect();
            end;

            v18();
            TopText.RemovePlayerSideFrame(p12);

            return nil, nil;
        end;

        local v20 = false;

        for _, v in u14 do
            if v and v.Parent then
                v20 = true;
                break;
            end;
        end;

        if not v20 then
            for _, v in v15 do
                v:Disconnect();
            end;

            v18();

            return nil, nil;
        end;

        task.wait(0.05);
    end;
end;

local function HandleCreateGuild() -- Line: 149
    -- upvalues: LocalPlayer (copy), NotificationController (copy), GuiController (copy)
    if LocalPlayer:GetAttribute("GuildId") ~= nil then
        NotificationController:CreateNotification("You\'re already in a guild!");

        return;
    end;

    if not GuiController:IsOpen("CreateGuild") then
        GuiController:Open("CreateGuild", nil, { "HUD" });
    end;
end;

local function HandleViewGuild() -- Line: 159
    -- upvalues: LocalPlayer (copy), NotificationController (copy), GuiController (copy)
    if LocalPlayer:GetAttribute("GuildId") ~= nil then
        if not GuiController:IsOpen("ViewGuildPage") then
            GuiController:Open("ViewGuildPage", nil, { "HUD" });
        end;

        return;
    end;

    NotificationController:CreateNotification("You aren\'t in a guild");
end;

local function HandleViewLeaderboard(p21) -- Line: 169
    -- upvalues: GuiController (copy)
    if not GuiController:IsOpen("ViewGuildLeaderboard") then
        GuiController:Open("ViewGuildLeaderboard", nil, { "HUD" });
    end;
end;

local function HandleViewRewards() -- Line: 175
    -- upvalues: GuiController (copy), ViewGuildProgressController (copy)
    if not GuiController:IsOpen("ViewGuildProgress") then
        ViewGuildProgressController:SetNoReturn();
        GuiController:Open("ViewGuildProgress", nil, { "HUD" });
    end;
end;

local function HandleNevermind() -- Line: 184
    task.wait(0.5);
end;

local function HandleWhatAreGuilds(p22) -- Line: 194
    -- upvalues: TopText (copy), u6 (ref)
    TopText.NpcText(p22, "You must be invited to join!", true);
    task.wait(2.5);

    if not u6 then
        return;
    end;

    TopText.NpcText(p22, "Get weekly exclusive prizes!", true);
    task.wait(2.5);

    if not u6 then
        return;
    end;

    TopText.NpcText(p22, "Compete globally!", true);
    task.wait(2.5);
end;

local function EndConversation(p23, p24) -- Line: 206
    -- upvalues: u6 (ref), TopText (copy), LocalPlayer (copy), NPC (copy), SetHighlight (copy)
    u6 = false;
    TopText.TakeAwayResponses(p23, LocalPlayer);
    TopText.RemovePlayerSideFrame(LocalPlayer);
    NPC.EndSpeaking(LocalPlayer);
    SetHighlight(p23, 1);
    task.wait(0.4);

    if p24.Parent then
        p24.Enabled = true;
    end;
end;

local function StartConversation(u25, u26, p27) -- Line: 218
    -- upvalues: u6 (ref), NPC (copy), LocalPlayer (copy), SetHighlight (copy), u7 (ref), TopText (copy), u4 (copy), u5 (copy), u2 (copy), u3 (copy), WaitForSelection (copy), HandleCreateGuild (copy), GuiController (copy), HandleViewGuild (copy), HandleViewRewards (copy), HandleWhatAreGuilds (copy), EndConversation (copy)
    if u6 then
        return;
    end;

    if not NPC.CanSpeak(LocalPlayer) then
        return;
    end;

    u6 = true;
    NPC.StartSpeaking(LocalPlayer);
    p27.Enabled = false;
    SetHighlight(u25, 1);

    if u7 then
        u7:Play(0.1, 100, 1);
    end;

    local v28 = task.spawn(function() -- Line: 234
        -- upvalues: u6 (ref), LocalPlayer (ref), u26 (copy), TopText (ref), u25 (copy)
        while u6 do
            task.wait(0.25);
            local Character = LocalPlayer.Character;

            if Character then
                Character = Character:FindFirstChild("HumanoidRootPart");
            end;

            if Character and (Character:IsA("BasePart") and (Character.Position - u26.Position).Magnitude > 10) then
                TopText.NpcText(u25, "...", true);
                u6 = false;
                TopText.RemovePlayerSideFrame(LocalPlayer);

                return;
            end;
        end;
    end);
    local u29 = false;
    local v30 = LocalPlayer:GetAttributeChangedSignal("GuildId"):Connect(function() -- Line: 256
        -- upvalues: u29 (ref), u6 (ref), TopText (ref), LocalPlayer (ref)
        u29 = true;
        u6 = false;
        TopText.RemovePlayerSideFrame(LocalPlayer);
    end);
    local v31;

    if LocalPlayer:GetAttribute("GuildId") ~= nil then
        local v32 = u4;
        v31 = v32[math.random(1, #v32)];
    else
        local v33 = u5;
        v31 = v33[math.random(1, #v33)];
    end;

    TopText.NpcText(u25, v31, true);
    task.wait(0.4);

    while u6 do
        local v34;

        if LocalPlayer:GetAttribute("GuildId") ~= nil then
            v34 = u2;
        else
            v34 = u3;
        end;

        local _, v35 = WaitForSelection(LocalPlayer, v34);

        if u29 or not v35 then
            break;
        end;

        if v35 == "Create Guild" then
            HandleCreateGuild();
            break;
        end;

        if v35 == "View Guild Shop!" then
            GuiController:Open("GuildShop");
            break;
        end;

        if v35 == "View Guild" then
            HandleViewGuild();
            break;
        end;

        if v35 == "View Leaderboard" then
            if not GuiController:IsOpen("ViewGuildLeaderboard") then
                GuiController:Open("ViewGuildLeaderboard", nil, { "HUD" });
            end;

            break;
        end;

        if v35 == "View Rewards" then
            HandleViewRewards();
            break;
        end;

        if v35 ~= "What are guilds?" then
            if v35 == "Nevermind" then
                task.wait(0.5);
            end;

            break;
        end;

        HandleWhatAreGuilds(u25);
    end;

    v30:Disconnect();

    if coroutine.status(v28) ~= "dead" then
        task.cancel(v28);
    end;

    EndConversation(u25, p27);
end;

return function() -- Line: 324
    -- upvalues: u7 (ref), SetHighlight (copy), u6 (ref), LocalPlayer (copy), StartConversation (copy)
    task.spawn(function() -- Line: 325
        -- upvalues: u7 (ref), SetHighlight (ref), u6 (ref), LocalPlayer (ref), StartConversation (ref)
        local NPCS = workspace:WaitForChild("NPCS", 30);

        if not NPCS then
            return;
        end;

        local Gilbert = NPCS:WaitForChild("Gilbert", 30);

        if not (Gilbert and Gilbert:IsA("Model")) then
            return;
        end;

        local HumanoidRootPart = Gilbert:WaitForChild("HumanoidRootPart", 10);

        if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
            return;
        end;

        local ProximityPrompt = HumanoidRootPart:WaitForChild("ProximityPrompt", 10);

        if not (ProximityPrompt and ProximityPrompt:IsA("ProximityPrompt")) then
            return;
        end;

        local Humanoid = Gilbert:WaitForChild("Humanoid", 10);
        local Animations = Gilbert:WaitForChild("Animations", 10);

        if Humanoid and (Humanoid:IsA("Humanoid") and Animations) then
            local Animator = Humanoid:WaitForChild("Animator", 10);
            local Interact = Animations:FindFirstChild("Interact");

            if Animator and (Animator:IsA("Animator") and (Interact and Interact:IsA("Animation"))) then
                u7 = Animator:LoadAnimation(Interact);
            end;
        end;

        ProximityPrompt.PromptShown:Connect(function() -- Line: 354
            -- upvalues: SetHighlight (ref), Gilbert (copy)
            SetHighlight(Gilbert, 0);
        end);
        ProximityPrompt.PromptHidden:Connect(function() -- Line: 357
            -- upvalues: u6 (ref), SetHighlight (ref), Gilbert (copy)
            if not u6 then
                SetHighlight(Gilbert, 1);
            end;
        end);
        ProximityPrompt.Triggered:Connect(function(p36) -- Line: 362
            -- upvalues: LocalPlayer (ref), StartConversation (ref), Gilbert (copy), HumanoidRootPart (copy), ProximityPrompt (copy)
            if p36 ~= LocalPlayer then
                return;
            end;

            task.spawn(StartConversation, Gilbert, HumanoidRootPart, ProximityPrompt);
        end);
    end);
end;