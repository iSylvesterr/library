-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local SoundService = game:GetService("SoundService");
local ContentProvider = game:GetService("ContentProvider");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local u2 = LocalPlayer:GetMouse();
local MegaphoneIdChangeMenu = PlayerGui:WaitForChild("MegaphoneIdChangeMenu");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local MegaphoneSounds = require(ReplicatedStorage.SharedModules.MegaphoneSounds);
local GuiController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.GuiController);

local function notify(p3) -- Line: 51
    -- upvalues: ReplicatedStorage (copy)
    local Notify = ReplicatedStorage:FindFirstChild("Notify");

    if Notify and Notify:IsA("BindableEvent") then
        Notify:Fire(p3);
    end;
end;

local u4 = false;
local u5 = false;
local SFX = SoundService:FindFirstChild("SFX");
local v6 = SFX and SFX:FindFirstChild("Click");
local u7 = v6 and (v6:IsA("Sound") and v6) or nil;

local function playClick() -- Line: 72
    -- upvalues: u7 (copy)
    if u7 then
        u7.TimePosition = 0;
        u7:Play();
    end;
end;

local u8 = 1;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = false;

local function setCharCount(p17) -- Line: 106
    -- upvalues: u12 (ref)
    if u12 then
        u12.Text = `{p17}/{100}`;
    end;
end;

local function saveSoundId(p18) -- Line: 115
    -- upvalues: u11 (ref), u16 (ref), Networking (copy), u15 (ref), ReplicatedStorage (copy)
    if not u11 then
        return;
    end;

    u16 = p18 == true;
    local Text = u11.Text;

    if #Text > 100 then
        Text = string.sub(Text, 1, 100);
    end;

    Networking.Megaphone.SetSoundId:Fire(Text);
    local v19 = string.match(Text, "%d+");

    if v19 and v19 ~= u15 then
        u15 = v19;
        local Notify = ReplicatedStorage:FindFirstChild("Notify");

        if Notify and Notify:IsA("BindableEvent") then
            Notify:Fire("Megaphone sound updated!");
        end;
    end;
end;

local function openEdit() -- Line: 135
    -- upvalues: u4 (ref), u9 (ref), u11 (ref), LocalPlayer (copy), u15 (ref), u10 (ref), GuiController (copy), GuiService (copy), u12 (ref)
    if u4 then
        return;
    end;

    if not (u9 and u11) then
        return;
    end;

    u4 = true;
    local MegaphoneSoundId = LocalPlayer:FindFirstChild("MegaphoneSoundId");
    local v20 = string.match(MegaphoneSoundId and MegaphoneSoundId.Value or "", "%d+") or "";
    u15 = v20;

    if u10 then
        u10.Visible = false;
    end;

    u9.Visible = true;
    GuiController:Open("MegaphoneIdChangeMenu");
    u11.Text = v20;

    if not GuiService:IsTenFootInterface() then
        u11:CaptureFocus();
    end;

    local v21 = #v20;

    if u12 then
        u12.Text = `{v21}/{100}`;
    end;
end;

local function closeEdit() -- Line: 165
    -- upvalues: u4 (ref), GuiController (copy)
    if not u4 then
        return;
    end;

    GuiController:Close();
end;

local function setMenuEnabled(p22) -- Line: 174
    -- upvalues: u5 (ref), u10 (ref), MegaphoneIdChangeMenu (copy), u4 (ref), GuiController (copy)
    u5 = p22;

    if p22 then
        if u10 then
            u10.Visible = true;
        end;

        MegaphoneIdChangeMenu.Enabled = true;

        return;
    end;

    if u4 and u4 then
        GuiController:Close();
    end;

    MegaphoneIdChangeMenu.Enabled = false;
end;

local function isMegaphoneTool(p23) -- Line: 187
    local v24 = p23:IsA("Tool") and p23:GetAttribute("Megaphone") ~= nil;

    return v24;
end;

local u25 = {};

local function validateSoundId(p26) -- Line: 197
    -- upvalues: u25 (copy), ContentProvider (copy)
    local v27 = u25[p26];

    if v27 ~= nil then
        return v27;
    end;

    local Sound = Instance.new("Sound");
    Sound.SoundId = p26;
    local u28 = nil;
    local success = pcall(function() -- Line: 204
        -- upvalues: ContentProvider (ref), Sound (copy), u28 (ref)
        ContentProvider:PreloadAsync({ Sound }, function(p29, p30) -- Line: 205
            -- upvalues: u28 (ref)
            u28 = p30;
        end);
    end);
    Sound:Destroy();

    if success then
        success = u28 == Enum.AssetFetchStatus.Success;
    end;

    u25[p26] = success;

    return success;
end;

local u31 = false;

local function tryPlay() -- Line: 222
    -- upvalues: u4 (ref), u31 (ref), LocalPlayer (copy), ReplicatedStorage (copy), validateSoundId (copy), Networking (copy), u8 (ref), u16 (ref)
    if u4 then
        return;
    end;

    if u31 then
        return;
    end;

    local MegaphoneSoundId = LocalPlayer:FindFirstChild("MegaphoneSoundId");

    if MegaphoneSoundId then
        MegaphoneSoundId = MegaphoneSoundId.Value;
    end;

    if type(MegaphoneSoundId) == "string" and MegaphoneSoundId ~= "" then
        u31 = true;
        task.spawn(function() -- Line: 234
            -- upvalues: validateSoundId (ref), MegaphoneSoundId (copy), u31 (ref), ReplicatedStorage (ref), Networking (ref), u8 (ref), u16 (ref)
            local v32 = validateSoundId(MegaphoneSoundId);
            u31 = false;

            if v32 then
                Networking.Megaphone.Play:Fire(u8, u16);

                return;
            end;

            local Notify = ReplicatedStorage:FindFirstChild("Notify");

            if Notify and Notify:IsA("BindableEvent") then
                Notify:Fire("Your sound id is invalid!");
            end;
        end);

        return;
    end;

    local Notify = ReplicatedStorage:FindFirstChild("Notify");

    if Notify and Notify:IsA("BindableEvent") then
        Notify:Fire("Pick a sound first!");
    end;
end;

local u33 = setmetatable({}, {
    __mode = "k"
});

local function wireToolActivation(p34) -- Line: 248
    -- upvalues: u33 (copy), tryPlay (copy)
    if u33[p34] then
        return;
    end;

    u33[p34] = true;
    p34.Activated:Connect(tryPlay);
end;

local function percentToVolume(p35) -- Line: 254
    return math.clamp(p35, 0, 1) * 4.8 + 0.2;
end;

local function volumeToPercent(p36) -- Line: 258
    return math.clamp((p36 - 0.2) / 4.8, 0, 1);
end;

local function snapPercent(p37) -- Line: 263
    return math.round(p37 / 0.1) * 0.1;
end;

local function setupVolumeSlider() -- Line: 271
    -- upvalues: u9 (ref), SoundService (copy), u8 (ref), u2 (copy), UserInputService (copy)
    if not u9 then
        return;
    end;

    local VolumeSliderFrame = u9:FindFirstChild("VolumeSliderFrame", true);

    if not VolumeSliderFrame then
        warn("[Megaphone] EditFrame has no VolumeSliderFrame; volume slider disabled");

        return;
    end;

    local Slider = VolumeSliderFrame:FindFirstChild("Slider", true);

    if not Slider then
        warn("[Megaphone] VolumeSliderFrame has no Slider; volume slider disabled");

        return;
    end;

    local Bar = Slider:FindFirstChild("Bar");
    local Notch = Slider:FindFirstChild("Notch");

    if not Bar then
        warn("[Megaphone] Slider has no Bar; volume slider disabled");

        return;
    end;

    if not Notch then
        warn("[Megaphone] Slider has no Notch; volume slider disabled");

        return;
    end;

    for _, descendant in VolumeSliderFrame:GetDescendants() do
        if descendant:IsA("LuaSourceContainer") and (descendant.Name == "SliderMusic" or (descendant.Name == "SliderSFX" or descendant.Name == "SliderMegaphone")) then
            descendant:Destroy();
        end;
    end;

    local SFX2 = SoundService:FindFirstChild("SFX");
    local v38 = SFX2 and SFX2:FindFirstChild("Scroll");
    local u39 = v38;

    local function setBar(p40) -- Line: 315
        -- upvalues: Bar (copy)
        Bar.Size = UDim2.new(p40, 0, 1, 0);
    end;

    local function playTick(p41) -- Line: 319
        -- upvalues: u39 (ref)
        if u39 and u39:IsA("Sound") then
            u39.TimePosition = 0;
            u39.PlaybackSpeed = p41 * 0.5 + 1;
            u39:Play();
        end;
    end;

    local v42 = 0.16666666666666669;
    Bar.Size = UDim2.new(v42, 0, 1, 0);
    u8 = 1;
    local u43 = v42;

    local function getPercent() -- Line: 334
        -- upvalues: u2 (ref), Slider (copy)
        local v44 = (u2.X - Slider.AbsolutePosition.X) / math.max(Slider.AbsoluteSize.X, 1);
        local v45 = math.clamp(v44, 0, 1) / 0.1;

        return math.round(v45) * 0.1;
    end;

    local function updateSlider() -- Line: 340
        -- upvalues: u2 (ref), Slider (copy), Bar (copy), u43 (ref), u39 (ref), u8 (ref)
        local v46 = (u2.X - Slider.AbsolutePosition.X) / math.max(Slider.AbsoluteSize.X, 1);
        local v47 = math.clamp(v46, 0, 1) / 0.1;
        local v48 = math.round(v47) * 0.1;
        Bar.Size = UDim2.new(v48, 0, 1, 0);

        if v48 ~= u43 then
            if u39 and u39:IsA("Sound") then
                u39.TimePosition = 0;
                u39.PlaybackSpeed = v48 * 0.5 + 1;
                u39:Play();
            end;

            u43 = v48;
            u8 = math.clamp(v48, 0, 1) * 4.8 + 0.2;
        end;
    end;

    local u49 = false;

    local function startDragLoop() -- Line: 351
        -- upvalues: u49 (ref), u2 (ref), Slider (copy), Bar (copy), u43 (ref), u39 (ref), u8 (ref)
        while u49 do
            local v50 = (u2.X - Slider.AbsolutePosition.X) / math.max(Slider.AbsoluteSize.X, 1);
            local v51 = math.clamp(v50, 0, 1) / 0.1;
            local v52 = math.round(v51) * 0.1;
            Bar.Size = UDim2.new(v52, 0, 1, 0);

            if v52 ~= u43 then
                if u39 and u39:IsA("Sound") then
                    u39.TimePosition = 0;
                    u39.PlaybackSpeed = v52 * 0.5 + 1;
                    u39:Play();
                end;

                u43 = v52;
                u8 = math.clamp(v52, 0, 1) * 4.8 + 0.2;
            end;

            task.wait(0.01);
        end;
    end;

    Notch.InputBegan:Connect(function(p53) -- Line: 358
        -- upvalues: u49 (ref), u2 (ref), Slider (copy), Bar (copy), u43 (ref), u39 (ref), u8 (ref)
        if p53.UserInputType == Enum.UserInputType.MouseButton1 or p53.UserInputType == Enum.UserInputType.Touch then
            if u49 then
                return;
            end;

            u49 = true;

            while u49 do
                local v54 = (u2.X - Slider.AbsolutePosition.X) / math.max(Slider.AbsoluteSize.X, 1);
                local v55 = math.clamp(v54, 0, 1) / 0.1;
                local v56 = math.round(v55) * 0.1;
                Bar.Size = UDim2.new(v56, 0, 1, 0);

                if v56 ~= u43 then
                    if u39 and u39:IsA("Sound") then
                        u39.TimePosition = 0;
                        u39.PlaybackSpeed = v56 * 0.5 + 1;
                        u39:Play();
                    end;

                    u43 = v56;
                    u8 = math.clamp(v56, 0, 1) * 4.8 + 0.2;
                end;

                task.wait(0.01);
            end;
        end;
    end);
    Notch.InputEnded:Connect(function(p57) -- Line: 367
        -- upvalues: u49 (ref)
        if p57.UserInputType == Enum.UserInputType.MouseButton1 or p57.UserInputType == Enum.UserInputType.Touch then
            u49 = false;
        end;
    end);
    UserInputService.InputEnded:Connect(function(p58) -- Line: 375
        -- upvalues: u49 (ref)
        if p58.UserInputType == Enum.UserInputType.MouseButton1 or p58.UserInputType == Enum.UserInputType.Touch then
            u49 = false;
        end;
    end);
end;

function v1.Init(p59) -- Line: 383
end;

function v1.Start(p60) -- Line: 386
    -- upvalues: u9 (ref), MegaphoneIdChangeMenu (copy), u10 (ref), GuiController (copy), u4 (ref), u5 (ref), u11 (ref), u12 (ref), u13 (ref), u14 (ref), MegaphoneSounds (copy), saveSoundId (copy), u7 (copy), openEdit (copy), setupVolumeSlider (copy), PlayerGui (copy), Networking (copy), u33 (copy), tryPlay (copy), LocalPlayer (copy)
    u9 = MegaphoneIdChangeMenu:FindFirstChild("EditFrame") or MegaphoneIdChangeMenu:FindFirstChild("Frame");
    u10 = MegaphoneIdChangeMenu:FindFirstChild("SettingsButton");
    MegaphoneIdChangeMenu.Enabled = false;

    if not u9 then
        warn("[Megaphone] MegaphoneIdChangeMenu has no EditFrame/Frame; menu disabled");

        return;
    end;

    u9.Visible = false;
    GuiController.GuiUnfocusedSignal:Connect(function(p61) -- Line: 406
        -- upvalues: MegaphoneIdChangeMenu (ref), u4 (ref), u9 (ref), u10 (ref), u5 (ref), GuiController (ref)
        if p61 ~= MegaphoneIdChangeMenu then
            return;
        end;

        if not u4 then
            return;
        end;

        u4 = false;

        if u9 then
            u9.Visible = false;
        end;

        if u10 then
            u10.Visible = true;
        end;

        task.defer(function() -- Line: 413
            -- upvalues: u5 (ref), u4 (ref), GuiController (ref), MegaphoneIdChangeMenu (ref)
            if u5 and (not u4 and GuiController.Gui == nil) then
                MegaphoneIdChangeMenu.Enabled = true;
            end;
        end);
    end);
    u11 = u9:FindFirstChild("Input", true);
    u12 = u9:FindFirstChild("CharCount", true);
    u13 = u9:FindFirstChild("DiceButton", true);
    u14 = u9:FindFirstChild("ExitButton", true);

    if u11 then
        u11.ClearTextOnFocus = false;
        u11:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 431
            -- upvalues: u11 (ref), u12 (ref)
            local Text = u11.Text;

            if #Text > 100 then
                u11.Text = string.sub(Text, 1, 100);

                return;
            end;

            local v62 = #Text;

            if u12 then
                u12.Text = `{v62}/{100}`;
            end;
        end);
    end;

    local u63 = 0;

    local function rollDice() -- Line: 445
        -- upvalues: u63 (ref), u11 (ref), MegaphoneSounds (ref)
        local v64 = os.clock();

        if v64 - u63 < 0.2 then
            return;
        end;

        u63 = v64;

        if u11 then
            u11.Text = MegaphoneSounds.Random();
        end;
    end;

    if u13 then
        u13.MouseButton1Click:Connect(function() -- Line: 455
            -- upvalues: u63 (ref), u11 (ref), MegaphoneSounds (ref), saveSoundId (ref)
            local v65 = os.clock();

            if v65 - u63 >= 0.2 then
                u63 = v65;

                if u11 then
                    u11.Text = MegaphoneSounds.Random();
                end;
            end;

            saveSoundId(true);
        end);
    end;

    if u14 then
        u14.MouseButton1Click:Connect(function() -- Line: 466
            -- upvalues: u7 (ref), saveSoundId (ref), u4 (ref), GuiController (ref)
            if u7 then
                u7.TimePosition = 0;
                u7:Play();
            end;

            saveSoundId();

            if not u4 then
                return;
            end;

            GuiController:Close();
        end);
    end;

    if u10 then
        u10.MouseButton1Click:Connect(function() -- Line: 474
            -- upvalues: u4 (ref), u7 (ref), openEdit (ref)
            if u4 then
                return;
            end;

            if u7 then
                u7.TimePosition = 0;
                u7:Play();
            end;

            openEdit();
        end);
    else
        warn("[Megaphone] MegaphoneIdChangeMenu has no SettingsButton");
    end;

    setupVolumeSlider();

    local function clickedOn(p66, p67) -- Line: 490
        -- upvalues: PlayerGui (ref)
        if not (p66 and p67) then
            return false;
        end;

        local UserInputType = p66.UserInputType;

        if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
            return false;
        end;

        local Position = p66.Position;

        for _, v in PlayerGui:GetGuiObjectsAtPosition(Position.X, Position.Y) do
            if v == p67 or v:IsDescendantOf(p67) then
                return true;
            end;
        end;

        local AbsolutePosition = p67.AbsolutePosition;
        local AbsoluteSize = p67.AbsoluteSize;
        local v68;

        if Position.X >= AbsolutePosition.X and (Position.X <= AbsolutePosition.X + AbsoluteSize.X and Position.Y >= AbsolutePosition.Y) then
            v68 = Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
        else
            v68 = false;
        end;

        return v68;
    end;

    if u11 then
        u11.FocusLost:Connect(function(p69, p70) -- Line: 516
            -- upvalues: clickedOn (copy), u13 (ref), u63 (ref), u11 (ref), MegaphoneSounds (ref), saveSoundId (ref), u4 (ref), GuiController (ref)
            if not clickedOn(p70, u13) then
                saveSoundId(false);

                if p69 then
                    if not u4 then
                        return;
                    end;

                    GuiController:Close();
                end;

                return;
            end;

            local v71 = os.clock();

            if v71 - u63 >= 0.2 then
                u63 = v71;

                if u11 then
                    u11.Text = MegaphoneSounds.Random();
                end;
            end;

            saveSoundId(true);
        end);
    end;

    Networking.Megaphone.PlaySound.OnClientEvent:Connect(function(p72, p73, p74, p75) -- Line: 534
        if not (p72 and p72:IsA("BasePart")) then
            return;
        end;

        if not p72:IsDescendantOf(workspace) then
            return;
        end;

        if type(p73) ~= "string" or p73 == "" then
            return;
        end;

        local MegaphoneSound = p72:FindFirstChild("MegaphoneSound");

        if MegaphoneSound then
            MegaphoneSound:Destroy();
        end;

        local Sound = Instance.new("Sound");
        Sound.Name = "MegaphoneSound";
        Sound.SoundId = p73;
        Sound.Looped = false;
        Sound.Volume = p74;
        Sound.RollOffMaxDistance = p75;
        Sound.Parent = p72;
        Sound:Play();
        Sound.Ended:Connect(function() -- Line: 559
            -- upvalues: Sound (copy)
            Sound:Destroy();
        end);
        task.delay(30, function() -- Line: 563
            -- upvalues: Sound (copy)
            if Sound.Parent then
                Sound:Destroy();
            end;
        end);
    end);

    local function bindCharacter(p76) -- Line: 573
        -- upvalues: u5 (ref), u10 (ref), MegaphoneIdChangeMenu (ref), u33 (ref), tryPlay (ref), u4 (ref), GuiController (ref)
        p76.ChildAdded:Connect(function(p77) -- Line: 574
            -- upvalues: u5 (ref), u10 (ref), MegaphoneIdChangeMenu (ref), u33 (ref), tryPlay (ref)
            local v78 = p77:IsA("Tool") and p77:GetAttribute("Megaphone") ~= nil;

            if v78 then
                u5 = true;

                if u10 then
                    u10.Visible = true;
                end;

                MegaphoneIdChangeMenu.Enabled = true;

                if u33[p77] then
                    return;
                end;

                u33[p77] = true;
                p77.Activated:Connect(tryPlay);
            end;
        end);
        p76.ChildRemoved:Connect(function(p79) -- Line: 580
            -- upvalues: u5 (ref), u4 (ref), GuiController (ref), MegaphoneIdChangeMenu (ref)
            local v80 = p79:IsA("Tool") and p79:GetAttribute("Megaphone") ~= nil;

            if v80 then
                u5 = false;

                if u4 and u4 then
                    GuiController:Close();
                end;

                MegaphoneIdChangeMenu.Enabled = false;
            end;
        end);

        for _, child in p76:GetChildren() do
            local v81 = child:IsA("Tool") and child:GetAttribute("Megaphone") ~= nil;

            if v81 then
                u5 = true;

                if u10 then
                    u10.Visible = true;
                end;

                MegaphoneIdChangeMenu.Enabled = true;

                if not u33[child] then
                    u33[child] = true;
                    child.Activated:Connect(tryPlay);
                end;
            end;
        end;
    end;

    bindCharacter(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait());
    LocalPlayer.CharacterAdded:Connect(function(p82) -- Line: 596
        -- upvalues: u5 (ref), u4 (ref), GuiController (ref), MegaphoneIdChangeMenu (ref), bindCharacter (copy)
        u5 = false;

        if u4 and u4 then
            GuiController:Close();
        end;

        MegaphoneIdChangeMenu.Enabled = false;
        bindCharacter(p82);
    end);
end;

return v1;