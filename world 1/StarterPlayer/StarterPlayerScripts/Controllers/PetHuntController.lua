-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local UserInputService = game:GetService("UserInputService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local MessagePrompt = require(ReplicatedStorage.ClientModules.MessagePrompt);
local PlayerStateClient = require(ReplicatedStorage.ClientModules.PlayerStateClient);
local ScreenResolution = require(ReplicatedStorage.ClientModules.ScreenResolution);
local PetTeleporterData = require(ReplicatedStorage.SharedModules.PetTeleporterData);
local PetHuntFlags = require(ReplicatedStorage.SharedModules.Flags.PetHuntFlags);
local Environment = require(ReplicatedStorage.SharedModules.Environment);
local NumberUtils = require(ReplicatedStorage.SharedModules.NumberUtils);
local Worlds = require(ReplicatedStorage.SharedModules.Worlds);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local u2 = setmetatable({}, {
    __mode = "k"
});
local u3 = false;
local u4 = nil;

local function getNotificationController() -- Line: 36
    -- upvalues: u4 (ref)
    if not u4 then
        local success, result = pcall(function() -- Line: 38
            return require(script.Parent:WaitForChild("NotificationController"));
        end);

        if success then
            u4 = result;
        end;
    end;

    return u4;
end;

local function notify(p5) -- Line: 48
    -- upvalues: u4 (ref)
    if type(p5) ~= "string" or p5 == "" then
        return;
    end;

    if not u4 then
        local success, result = pcall(function() -- Line: 38
            return require(script.Parent:WaitForChild("NotificationController"));
        end);

        if success then
            u4 = result;
        end;
    end;

    local v6 = u4;

    if v6 then
        v6:CreateNotification(p5);
    end;
end;

local function isQueued() -- Line: 59
    -- upvalues: PlayerStateClient (copy)
    local v7 = PlayerStateClient:GetLocalReplica();
    local v8;

    if v7 == nil or (v7.Data == nil or v7.Data.PetHuntEscrow == nil) then
        v8 = false;
    else
        v8 = v7.Data.PetHuntEscrow ~= false;
    end;

    return v8;
end;

local u9 = nil;
local u10 = false;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = { UDim2.fromScale(1.15, 0.22), UDim2.fromScale(1.4500000000000002, 0.78), UDim2.fromScale(0.8500000000000001, 0.78) };

local function isSmallScreen() -- Line: 97
    -- upvalues: UserInputService (copy), ScreenResolution (copy)
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and true or ScreenResolution.GetViewportSize().X < 1000;
end;

local function getSearchGui() -- Line: 104
    -- upvalues: PlayerGui (copy)
    local PetHuntSearch = PlayerGui:WaitForChild("PetHuntSearch", 10);

    if PetHuntSearch and PetHuntSearch:IsA("ScreenGui") then
        return PetHuntSearch;
    end;

    return nil;
end;

local function hideSearch() -- Line: 112
    -- upvalues: u10 (ref), u9 (ref), u12 (ref), u13 (ref), u14 (ref), u11 (ref), PlayerGui (copy)
    u10 = false;

    if u9 then
        task.cancel(u9);
        u9 = nil;
    end;

    if u12 then
        u12:Disconnect();
        u12 = nil;
    end;

    if u13 then
        u13:Disconnect();
        u13 = nil;
    end;

    if u14 then
        u14();
        u14 = nil;
    end;

    if u11 then
        u11:Destroy();
        u11 = nil;
    end;

    local PetHuntSearch = PlayerGui:FindFirstChild("PetHuntSearch");

    if PetHuntSearch and PetHuntSearch:IsA("ScreenGui") then
        PetHuntSearch.Enabled = false;
    end;
end;

local function showSearch(p16) -- Line: 140
    -- upvalues: hideSearch (copy), PlayerGui (copy), u10 (ref), SoundService (copy), u11 (ref), UserInputService (copy), ScreenResolution (copy), u13 (ref), u14 (ref), u15 (copy), u9 (ref), TweenService (copy), u12 (ref), RunService (copy)
    hideSearch();
    local PetHuntSearch = PlayerGui:WaitForChild("PetHuntSearch", 10);

    if not (PetHuntSearch and PetHuntSearch:IsA("ScreenGui")) then
        PetHuntSearch = nil;
    end;

    if not PetHuntSearch then
        return;
    end;

    u10 = true;
    pcall(function() -- Line: 150
        -- upvalues: SoundService (ref)
        local SFX = SoundService:FindFirstChild("SFX");

        if SFX then
            SFX = SFX:FindFirstChild("Notification");
        end;

        if SFX and SFX:IsA("Sound") then
            SFX:Play();
        end;
    end);
    PetHuntSearch.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets;
    local SearchingMessage = PetHuntSearch:FindFirstChild("SearchingMessage");
    local v17 = SearchingMessage and SearchingMessage.Parent and SearchingMessage.Parent:FindFirstChildWhichIsA("UIGridStyleLayout");

    if v17 then
        v17:Destroy();
    end;

    local u18;

    if SearchingMessage then
        u18 = SearchingMessage:FindFirstChild("Content");
    else
        u18 = SearchingMessage;
    end;

    if u18 then
        u18 = u18:FindFirstChild("TextLabel");
    end;

    if u18 and u18:IsA("TextLabel") then
        u18.Text = p16;
        local Frame = Instance.new("Frame");
        Frame.Name = "PetHuntSearchEmoji";
        Frame.Size = UDim2.fromScale(0.9, 0.9);
        Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY;
        Frame.BackgroundTransparency = 1;
        Frame.ZIndex = 10;
        Frame.Parent = u18;
        u11 = Frame;

        local function positionEmoji() -- Line: 202
            -- upvalues: Frame (copy), u18 (copy), UserInputService (ref), ScreenResolution (ref)
            if not Frame.Parent then
                return;
            end;

            local TextBounds = u18.TextBounds;

            if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and true or ScreenResolution.GetViewportSize().X < 1000 then
                Frame.AnchorPoint = Vector2.new(0.5, 0);
                Frame.Position = UDim2.new(0.5, 0, 0.5, TextBounds.Y * 0.5 + 6);

                return;
            end;

            local v19 = u18.AbsoluteSize.Y * 0.9 * 0.25;
            Frame.AnchorPoint = Vector2.new(0, 0.5);
            Frame.Position = UDim2.new(0.5, TextBounds.X * 0.5 + 38 + v19, 0.5, 0);
        end;

        positionEmoji();
        u13 = u18:GetPropertyChangedSignal("TextBounds"):Connect(positionEmoji);
        u14 = ScreenResolution.Observe(positionEmoji);
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = "Emoji";
        TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
        TextLabel.Position = u15[1];
        TextLabel.Size = UDim2.fromScale(0.85, 0.85);
        TextLabel.BackgroundTransparency = 1;
        TextLabel.Font = Enum.Font.GothamMedium;
        TextLabel.TextScaled = true;
        TextLabel.Text = "🔎";
        TextLabel.ZIndex = 10;
        TextLabel.Parent = Frame;
        u9 = task.spawn(function() -- Line: 237
            -- upvalues: u15 (ref), TweenService (ref), TextLabel (copy)
            local v20 = 1;

            while true do
                v20 = v20 % #u15 + 1;
                local v21 = TweenService:Create(TextLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    Position = u15[v20]
                });
                v21:Play();
                v21.Completed:Wait();
            end;
        end);
    end;

    if SearchingMessage and SearchingMessage:IsA("GuiObject") then
        u12 = RunService.RenderStepped:Connect(function() -- Line: 255
            -- upvalues: PlayerGui (ref), SearchingMessage (copy)
            local TeleportButtons = PlayerGui:FindFirstChild("TeleportButtons");

            if TeleportButtons then
                TeleportButtons = TeleportButtons:FindFirstChild("TeleportButtons");
            end;

            if not (TeleportButtons and TeleportButtons:IsA("GuiObject")) then
                return;
            end;

            local AbsolutePosition = TeleportButtons.AbsolutePosition;
            local AbsoluteSize = TeleportButtons.AbsoluteSize;
            local v22 = AbsolutePosition.Y + AbsoluteSize.Y;

            for _, child in TeleportButtons:GetChildren() do
                if child:IsA("TextButton") and child.Visible then
                    local v23 = child.AbsolutePosition.Y + child.AbsoluteSize.Y;

                    if v22 < v23 then
                        v22 = v23;
                    end;
                end;
            end;

            SearchingMessage.AnchorPoint = Vector2.new(0.5, 0);
            SearchingMessage.Position = UDim2.fromOffset(AbsolutePosition.X + AbsoluteSize.X * 0.5, v22 + 6);
        end);
    end;

    PetHuntSearch.Enabled = true;
end;

local function matchFound() -- Line: 287
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("PetHuntMatchFound") == true;
end;

local function watchQueueEnd() -- Line: 291
    -- upvalues: u10 (ref), PlayerStateClient (copy), LocalPlayer (copy), hideSearch (copy)
    task.spawn(function() -- Line: 292
        -- upvalues: u10 (ref), PlayerStateClient (ref), LocalPlayer (ref), hideSearch (ref)
        local v24 = os.clock() + 15;

        while u10 do
            local v25 = PlayerStateClient:GetLocalReplica();
            local v26;

            if v25 == nil or (v25.Data == nil or v25.Data.PetHuntEscrow == nil) then
                v26 = false;
            else
                v26 = v25.Data.PetHuntEscrow ~= false;
            end;

            if v26 or (LocalPlayer:GetAttribute("PetHuntMatchFound") == true or os.clock() >= v24) then
                break;
            end;

            task.wait(0.2);
        end;

        while u10 do
            local v27 = PlayerStateClient:GetLocalReplica();
            local v28;

            if v27 == nil or (v27.Data == nil or v27.Data.PetHuntEscrow == nil) then
                v28 = false;
            else
                v28 = v27.Data.PetHuntEscrow ~= false;
            end;

            if not v28 or LocalPlayer:GetAttribute("PetHuntMatchFound") == true then
                break;
            end;

            task.wait(0.2);
        end;

        hideSearch();
    end);
end;

local function onActivated(p29) -- Line: 304
    -- upvalues: u3 (ref), RunService (copy), PetHuntFlags (copy), PlayerStateClient (copy), MessagePrompt (copy), Networking (copy), u4 (ref), NumberUtils (copy), Worlds (copy), LocalPlayer (copy), PetTeleporterData (copy), showSearch (copy), hideSearch (copy), u10 (ref)
    local v30 = p29:GetAttribute("PetTeleporter");

    if type(v30) ~= "string" then
        return;
    end;

    if u3 then
        return;
    end;

    if not (RunService:IsStudio() or PetHuntFlags.OpenEnabled:Get()) then
        return;
    end;

    u3 = true;
    local v31 = PlayerStateClient:GetLocalReplica();
    local v32;

    if v31 == nil or (v31.Data == nil or v31.Data.PetHuntEscrow == nil) then
        v32 = false;
    else
        v32 = v31.Data.PetHuntEscrow ~= false;
    end;

    if v32 then
        local v33 = MessagePrompt.Prompt({
            message = "Leave the hunt queue? Your teleporter will be returned.",
            titleOverride = "Leave Hunt Queue?",
            yield = true,
            hideClose = true,
            options = MessagePrompt.Choices.YesNo
        });
        u3 = false;

        if v33 then
            Networking.PetHunt.LeaveQueue:Fire();
        end;

        return;
    end;

    local v34, v35 = Networking.PetHunt.CheckAfford:Fire(v30);

    if v34 == false then
        u3 = false;

        if type(v35) == "number" and v35 > 0 then
            local v36 = `You must have {NumberUtils.FormatWithCommas(v35)} {Worlds.WalletStatName(LocalPlayer)} to use this pet teleporter!`;

            if type(v36) == "string" then
                if v36 == "" then
                    return;
                end;

                if not u4 then
                    local success, result = pcall(function() -- Line: 38
                        return require(script.Parent:WaitForChild("NotificationController"));
                    end);

                    if success then
                        u4 = result;
                    end;
                end;

                local v37 = u4;

                if v37 then
                    v37:CreateNotification(v36);
                end;
            end;
        else
            if not u4 then
                local success, result = pcall(function() -- Line: 38
                    return require(script.Parent:WaitForChild("NotificationController"));
                end);

                if success then
                    u4 = result;
                end;
            end;

            local v38 = u4;

            if v38 then
                v38:CreateNotification("No pet of that rarity can be found in this world!");

                return;
            end;
        end;

        return;
    end;

    local v39 = PetTeleporterData.Get(v30);
    local v40;

    if v39 then
        v40 = v39.Rarity;
    else
        v40 = v39;
    end;

    if not MessagePrompt.Prompt({
        yield = true,
        hideClose = true,
        message = not v40 and "Are you sure you want to use this? You will lose your teleporter and be teleported to a server with the pet!" or `Are you sure you want to use this? You will lose your teleporter and be teleported to a server with the {v40} pet!`,
        titleOverride = not v39 and "Use Pet Teleporter?" or `Use {v39.DisplayName}?`,
        options = MessagePrompt.Choices.YesNo
    }) then
        u3 = false;

        return;
    end;

    u3 = false;
    showSearch("You\'ve entered the hunt queue! Searching for a pet...");
    local v41, v42 = Networking.PetHunt.JoinQueue:Fire(v30);

    if v41 then
        task.spawn(function() -- Line: 292
            -- upvalues: u10 (ref), PlayerStateClient (ref), LocalPlayer (ref), hideSearch (ref)
            local v43 = os.clock() + 15;

            while u10 do
                local v44 = PlayerStateClient:GetLocalReplica();
                local v45;

                if v44 == nil or (v44.Data == nil or v44.Data.PetHuntEscrow == nil) then
                    v45 = false;
                else
                    v45 = v44.Data.PetHuntEscrow ~= false;
                end;

                if v45 or (LocalPlayer:GetAttribute("PetHuntMatchFound") == true or os.clock() >= v43) then
                    break;
                end;

                task.wait(0.2);
            end;

            while u10 do
                local v46 = PlayerStateClient:GetLocalReplica();
                local v47;

                if v46 == nil or (v46.Data == nil or v46.Data.PetHuntEscrow == nil) then
                    v47 = false;
                else
                    v47 = v46.Data.PetHuntEscrow ~= false;
                end;

                if not v47 or LocalPlayer:GetAttribute("PetHuntMatchFound") == true then
                    break;
                end;

                task.wait(0.2);
            end;

            hideSearch();
        end);

        return;
    end;

    hideSearch();

    if v42 and type(v42) == "string" then
        if v42 == "" then
            return;
        end;

        if not u4 then
            local success, result = pcall(function() -- Line: 38
                return require(script.Parent:WaitForChild("NotificationController"));
            end);

            if success then
                u4 = result;
            end;
        end;

        local v48 = u4;

        if v48 then
            v48:CreateNotification(v42);
        end;
    end;
end;

local function tryConnect(u49) -- Line: 395
    -- upvalues: u2 (copy), onActivated (copy)
    if not u49:IsA("Tool") then
        return;
    end;

    if u49:GetAttribute("PetTeleporter") == nil then
        return;
    end;

    if u2[u49] then
        return;
    end;

    u2[u49] = true;
    u49.Activated:Connect(function() -- Line: 407
        -- upvalues: onActivated (ref), u49 (copy)
        task.spawn(onActivated, u49);
    end);
end;

local function watch(p50) -- Line: 412
    -- upvalues: tryConnect (copy)
    for _, child in p50:GetChildren() do
        tryConnect(child);
    end;

    p50.ChildAdded:Connect(tryConnect);
end;

local function watchRefundMessage() -- Line: 430
    -- upvalues: LocalPlayer (copy), u4 (ref)
    local u51 = nil;

    local function trySend() -- Line: 432
        -- upvalues: LocalPlayer (ref), u51 (ref), u4 (ref)
        local v52 = LocalPlayer:GetAttribute("PetHuntRefundMessage");

        if type(v52) ~= "string" or v52 == "" then
            return;
        end;

        if LocalPlayer:GetAttribute("LoadingScreenDone") ~= true then
            return;
        end;

        local v53, v54 = string.match(v52, "^([^|]*)|(.+)$");

        if v53 then
            v52 = v53;
        else
            v54 = v52;
        end;

        if u51 == v52 then
            return;
        end;

        u51 = v52;

        if type(v54) == "string" then
            if v54 == "" then
                return;
            end;

            if not u4 then
                local success, result = pcall(function() -- Line: 38
                    return require(script.Parent:WaitForChild("NotificationController"));
                end);

                if success then
                    u4 = result;
                end;
            end;

            local v55 = u4;

            if v55 then
                v55:CreateNotification(v54);
            end;
        end;
    end;

    LocalPlayer:GetAttributeChangedSignal("PetHuntRefundMessage"):Connect(trySend);
    LocalPlayer:GetAttributeChangedSignal("LoadingScreenDone"):Connect(trySend);
    trySend();
end;

local function watchLobbyTargetPet() -- Line: 458
    -- upvalues: LocalPlayer (copy), u4 (ref)
    task.spawn(function() -- Line: 459
        -- upvalues: LocalPlayer (ref), u4 (ref)
        local v56 = os.clock() + 120;

        while os.clock() < v56 do
            local v57 = LocalPlayer:GetAttribute("PetHuntTargetPetName");

            if type(v57) == "string" and (v57 ~= "" and LocalPlayer:GetAttribute("LoadingScreenDone") == true) then
                local v58 = `Your pet teleporter found a {v57}!`;

                if type(v58) == "string" and v58 ~= "" then
                    if not u4 then
                        local success, result = pcall(function() -- Line: 38
                            return require(script.Parent:WaitForChild("NotificationController"));
                        end);

                        if success then
                            u4 = result;
                        end;
                    end;

                    local v59 = u4;

                    if v59 then
                        v59:CreateNotification(v58);
                    end;
                end;

                LocalPlayer:SetAttribute("PetHuntTargetPetName", nil);

                return;
            end;

            task.wait(0.3);
        end;
    end);
end;

function v1.Init(p60) -- Line: 473
end;

function v1.Start(p61) -- Line: 475
    -- upvalues: watchRefundMessage (copy), Environment (copy), LocalPlayer (copy), u4 (ref), tryConnect (copy)
    watchRefundMessage();

    if Environment.isPetHuntPlace then
        task.spawn(function() -- Line: 459
            -- upvalues: LocalPlayer (ref), u4 (ref)
            local v62 = os.clock() + 120;

            while os.clock() < v62 do
                local v63 = LocalPlayer:GetAttribute("PetHuntTargetPetName");

                if type(v63) == "string" and (v63 ~= "" and LocalPlayer:GetAttribute("LoadingScreenDone") == true) then
                    local v64 = `Your pet teleporter found a {v63}!`;

                    if type(v64) == "string" and v64 ~= "" then
                        if not u4 then
                            local success, result = pcall(function() -- Line: 38
                                return require(script.Parent:WaitForChild("NotificationController"));
                            end);

                            if success then
                                u4 = result;
                            end;
                        end;

                        local v65 = u4;

                        if v65 then
                            v65:CreateNotification(v64);
                        end;
                    end;

                    LocalPlayer:SetAttribute("PetHuntTargetPetName", nil);

                    return;
                end;

                task.wait(0.3);
            end;
        end);
    end;

    local v66 = LocalPlayer:FindFirstChildOfClass("Backpack") or LocalPlayer:WaitForChild("Backpack", 10);

    if v66 then
        for _, child in v66:GetChildren() do
            tryConnect(child);
        end;

        v66.ChildAdded:Connect(tryConnect);
    end;

    if LocalPlayer.Character then
        local Character = LocalPlayer.Character;

        for _, child in Character:GetChildren() do
            tryConnect(child);
        end;

        Character.ChildAdded:Connect(tryConnect);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p67) -- Line: 488
        -- upvalues: tryConnect (ref), LocalPlayer (ref)
        for _, child in p67:GetChildren() do
            tryConnect(child);
        end;

        p67.ChildAdded:Connect(tryConnect);
        local v68 = LocalPlayer:FindFirstChildOfClass("Backpack") or LocalPlayer:WaitForChild("Backpack", 10);

        if v68 then
            for _, child in v68:GetChildren() do
                tryConnect(child);
            end;

            v68.ChildAdded:Connect(tryConnect);
        end;
    end);
end;

return v1;