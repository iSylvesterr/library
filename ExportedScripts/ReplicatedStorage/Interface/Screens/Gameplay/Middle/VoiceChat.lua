-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local VoiceChat = require(ReplicatedStorage.Controllers.InputController.Actions.VoiceChat);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Colors = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Colors);
local u2 = nil;
local u3 = nil;
local u4 = {};
local u5 = nil;

local function updateVisibleTemplates(p6) -- Line: 60
    -- upvalues: u4 (copy), u2 (ref), u5 (ref)
    local v7 = {};

    for _, v in pairs(u4) do
        local IsSpeaking = v.IsSpeaking;

        if not IsSpeaking and v.StoppedAt then
            IsSpeaking = p6 - v.StoppedAt < 2.85;
        end;

        if IsSpeaking then
            table.insert(v7, v);
        else
            v.Alpha = 1;
            v.Frame.Visible = false;
        end;
    end;

    table.sort(v7, function(p8, p9) -- Line: 78
        if p8.IsSpeaking ~= p9.IsSpeaking then
            return p8.IsSpeaking;
        end;

        if p8.LastSpokeAt == p9.LastSpokeAt then
            return p8.Player.UserId < p9.Player.UserId;
        end;

        return p8.LastSpokeAt > p9.LastSpokeAt;
    end);
    local v10 = 0;

    for i, v in ipairs(v7) do
        local v11 = i <= 3;
        v.Frame.LayoutOrder = i;
        v.Frame.Visible = v11;

        if v11 then
            v10 = v10 + 1;

            if v.IsSpeaking or not v.StoppedAt then
                v.Alpha = 0;
            else
                v.Alpha = math.clamp((p6 - v.StoppedAt - 2.5) / 0.35, 0, 1);
            end;

            for i2, v2 in pairs(v.OriginalTransparency) do
                if i2.Parent then
                    for i3, v3 in pairs(v2) do
                        i2[i3] = v3 + (1 - v3) * v.Alpha;
                    end;
                end;
            end;
        end;
    end;

    if u2 then
        u2.Visible = v10 > 0;
    end;

    if #v7 == 0 and u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

local function ensureRenderConnection() -- Line: 128
    -- upvalues: u5 (ref), RunServiceController (copy), updateVisibleTemplates (copy)
    if u5 then
        return;
    end;

    u5 = RunServiceController.BindToHeartbeat("UI.VoiceChat.UpdateVisibleTemplates", function() -- Line: 133
        -- upvalues: updateVisibleTemplates (ref)
        updateVisibleTemplates(os.clock());
    end);
end;

local function updateEntry(p12, p13) -- Line: 140
    -- upvalues: Colors (copy)
    local v14 = p12.Player:GetAttribute("Team");
    local v15 = p12.Player:GetAttribute("CompetitivePlayerColor");

    if not v15 and v14 then
        v15 = Colors["Team Color"][v14];
    end;

    if p13 ~= nil then
        p12.SpeakingIcon.Visible = p13;
        p12.NotSpeakingIcon.Visible = not p13;
    end;

    local Character = p12.Player.Character;
    local v16;

    if Character then
        v16 = Character:FindFirstChildOfClass("Humanoid");
    else
        v16 = nil;
    end;

    local v17 = p12.Player:GetAttribute("IsSpectating") == true and true or p12.Player:GetAttribute("Team") == "Spectators";
    local v18 = (Character == nil or (Character:GetAttribute("Dead") == true or v16 == nil)) and true or v16.Health <= 0;
    p12.DeadFrame.Visible = v17 or v18;

    if v15 then
        p12.ColorGraphic.BackgroundColor3 = v15;
    end;
end;

local function createEntry(p19) -- Line: 169
    -- upvalues: u4 (copy), u3 (ref), u2 (ref), updateEntry (copy)
    if u4[p19] then
        return u4[p19];
    end;

    if not (u3 and u2) then
        return nil;
    end;

    local v20 = u3:Clone();
    v20.Name = tostring(p19.UserId);
    v20.Visible = false;
    v20.Parent = u2;
    local Profile = v20.Profile;
    v20.DisplayName.Text = p19.DisplayName;
    Profile.Image = `rbxthumb://type=AvatarHeadShot&id={p19.UserId}&w=150&h=150`;
    local u21 = {
        Alpha = 1,
        IsSpeaking = false,
        LastSpokeAt = 0,
        StoppedAt = nil,
        CharacterConnections = {},
        ColorGraphic = v20.ColorDot.Graphic,
        Connections = {},
        DeadFrame = Profile.IsKilled,
        Frame = v20,
        NotSpeakingIcon = v20.IsNotSpeaking,
        OriginalTransparency = {},
        Player = p19,
        SpeakingIcon = v20.IsSpeaking
    };
    local v22 = { v20 };

    for _, descendant in ipairs(v20:GetDescendants()) do
        table.insert(v22, descendant);
    end;

    for _, v in ipairs(v22) do
        local v23 = {};

        if v:IsA("GuiObject") then
            v23.BackgroundTransparency = v.BackgroundTransparency;
        end;

        if v:IsA("TextLabel") or (v:IsA("TextButton") or v:IsA("TextBox")) then
            v23.TextTransparency = v.TextTransparency;
            v23.TextStrokeTransparency = v.TextStrokeTransparency;
        end;

        if v:IsA("ImageLabel") or v:IsA("ImageButton") then
            v23.ImageTransparency = v.ImageTransparency;
        end;

        if v:IsA("UIStroke") then
            v23.Transparency = v.Transparency;
        end;

        if next(v23) then
            u21.OriginalTransparency[v] = v23;
        end;
    end;

    local function connectCharacter(p24) -- Line: 235
        -- upvalues: u21 (copy), updateEntry (ref)
        for _, v in ipairs(u21.CharacterConnections) do
            v:Disconnect();
        end;

        table.clear(u21.CharacterConnections);

        if not p24 then
            updateEntry(u21);

            return;
        end;

        local CharacterConnections = u21.CharacterConnections;
        local v25 = p24:GetAttributeChangedSignal("Dead");
        table.insert(CharacterConnections, v25:Connect(function() -- Line: 249
            -- upvalues: updateEntry (ref), u21 (ref)
            updateEntry(u21);
        end));
        local v26 = p24:FindFirstChildOfClass("Humanoid");

        if v26 then
            local CharacterConnections2 = u21.CharacterConnections;
            local v27 = v26:GetPropertyChangedSignal("Health");
            table.insert(CharacterConnections2, v27:Connect(function() -- Line: 258
                -- upvalues: updateEntry (ref), u21 (ref)
                updateEntry(u21);
            end));
        end;

        updateEntry(u21);
    end;

    local Connections = u21.Connections;
    local v28 = p19:GetAttributeChangedSignal("IsSpectating");
    table.insert(Connections, v28:Connect(function() -- Line: 269
        -- upvalues: updateEntry (ref), u21 (copy)
        updateEntry(u21);
    end));
    local Connections2 = u21.Connections;
    local v29 = p19:GetAttributeChangedSignal("Team");
    table.insert(Connections2, v29:Connect(function() -- Line: 276
        -- upvalues: updateEntry (ref), u21 (copy)
        updateEntry(u21);
    end));
    local Connections3 = u21.Connections;
    local v30 = p19:GetAttributeChangedSignal("CompetitivePlayerColor");
    table.insert(Connections3, v30:Connect(function() -- Line: 283
        -- upvalues: updateEntry (ref), u21 (copy)
        updateEntry(u21);
    end));
    table.insert(u21.Connections, p19.CharacterAdded:Connect(function(p31) -- Line: 290
        -- upvalues: connectCharacter (copy)
        connectCharacter(p31);
    end));
    table.insert(u21.Connections, p19.CharacterRemoving:Connect(function() -- Line: 297
        -- upvalues: u21 (copy), updateEntry (ref)
        task.defer(function() -- Line: 298
            -- upvalues: u21 (ref), updateEntry (ref)
            for _, v in ipairs(u21.CharacterConnections) do
                v:Disconnect();
            end;

            table.clear(u21.CharacterConnections);
            updateEntry(u21);
        end);
    end));
    u4[p19] = u21;
    connectCharacter(p19.Character);
    updateEntry(u21, false);

    return u21;
end;

local function destroyEntry(p32) -- Line: 312
    -- upvalues: u4 (copy), updateVisibleTemplates (copy)
    local v33 = u4[p32];

    if not v33 then
        return;
    end;

    u4[p32] = nil;

    for _, v in ipairs(v33.CharacterConnections) do
        v:Disconnect();
    end;

    for _, v in ipairs(v33.Connections) do
        v:Disconnect();
    end;

    table.clear(v33.CharacterConnections);
    table.clear(v33.Connections);
    v33.Frame:Destroy();
    updateVisibleTemplates(os.clock());
end;

local function setPlayerSpeaking(p34, p35) -- Line: 336
    -- upvalues: u4 (copy), createEntry (copy), updateEntry (copy), updateVisibleTemplates (copy), u5 (ref), RunServiceController (copy)
    local v36 = u4[p34] or createEntry(p34);

    if not v36 then
        return;
    end;

    v36.IsSpeaking = p35;

    if p35 then
        v36.Alpha = 0;
        v36.LastSpokeAt = os.clock();
        v36.StoppedAt = nil;
    else
        v36.StoppedAt = os.clock();
    end;

    updateEntry(v36, p35);
    updateVisibleTemplates(os.clock());

    if p35 or v36.StoppedAt then
        if u5 then
            return;
        end;

        u5 = RunServiceController.BindToHeartbeat("UI.VoiceChat.UpdateVisibleTemplates", function() -- Line: 133
            -- upvalues: updateVisibleTemplates (ref)
            updateVisibleTemplates(os.clock());
        end);
    end;
end;

function v1.Initialize(p37, p38) -- Line: 363
    -- upvalues: u2 (ref), u3 (ref)
    local Template = p38.Template;
    u2 = p38;
    u3 = Template;
    Template.Visible = false;
    u2.Visible = false;
end;

function v1.Start() -- Line: 373
    -- upvalues: u3 (ref), VoiceChat (copy), setPlayerSpeaking (copy), Players (copy), createEntry (copy), destroyEntry (copy), u4 (copy), updateEntry (copy), updateVisibleTemplates (copy), u5 (ref), RunServiceController (copy)
    if not u3 then
        return;
    end;

    VoiceChat.SpeakingChanged:Connect(setPlayerSpeaking);
    Players.PlayerAdded:Connect(createEntry);
    Players.PlayerRemoving:Connect(destroyEntry);

    for _, v in ipairs(Players:GetPlayers()) do
        createEntry(v);

        if VoiceChat.IsPlayerSpeaking(v) then
            local v39 = u4[v] or createEntry(v);

            if v39 then
                v39.IsSpeaking = true;
                v39.Alpha = 0;
                v39.LastSpokeAt = os.clock();
                v39.StoppedAt = nil;
                updateEntry(v39, true);
                updateVisibleTemplates(os.clock());

                if not u5 then
                    u5 = RunServiceController.BindToHeartbeat("UI.VoiceChat.UpdateVisibleTemplates", function() -- Line: 133
                        -- upvalues: updateVisibleTemplates (ref)
                        updateVisibleTemplates(os.clock());
                    end);
                end;
            end;
        end;
    end;

    updateVisibleTemplates(os.clock());
end;

return v1;