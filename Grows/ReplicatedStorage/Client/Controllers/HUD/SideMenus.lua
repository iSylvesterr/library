-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local TextService = game:GetService("TextService");
game:GetService("SocialService");
local Maid = require(ReplicatedStorage.Packages.Maid);
local Knit = require(ReplicatedStorage.Packages.Knit);
local Signal = require(ReplicatedStorage.Packages.Signal);
local MusicAndAmbience = require(ReplicatedStorage.Client.Modules.Utility.MusicAndAmbience);
require(ReplicatedStorage.Client.Modules.Utility.KeycodeToString);
require(ReplicatedStorage.Shared.Info.Constants);
require(ReplicatedStorage.Shared.Info.GlobalVars);
local CustomEnum = require(ReplicatedStorage.Shared.Info.CustomEnum);
local Images = require(ReplicatedStorage.Shared.Info.Images);
local AbbreviateNumber = require(ReplicatedStorage.Shared.Utility.AbbreviateNumber);
local EmotesInfo = require(ReplicatedStorage.Shared.Info.EmotesInfo);
local u1 = Knit.CreateController({
    Name = "SideMenus",
    hideTop = Signal.new(),
    showTop = Signal.new(),
    playEmoteLocal = Signal.new()
});
local PlayerGui = Players.LocalPlayer.PlayerGui;
local StarterPack = PlayerGui:WaitForChild("Windows"):WaitForChild("StarterPack");
local HUD = PlayerGui:WaitForChild("HUD");
local SideMenus = HUD:WaitForChild("SideMenus");
local Buttons = SideMenus:WaitForChild("Left"):WaitForChild("Buttons");
local CoinsWallet = HUD:WaitForChild("BottomLeft"):WaitForChild("CoinsWallet");
CoinsWallet:WaitForChild("Add"):WaitForChild("Button");
local TicketsWallet = HUD:WaitForChild("BottomLeft"):WaitForChild("TicketsWallet");
local Buttons2 = SideMenus:WaitForChild("Right"):WaitForChild("Buttons");
local Button = Buttons2:WaitForChild("StarterPackButton"):WaitForChild("Button");
local EmotesSection = Buttons2:WaitForChild("EmotesSection");
local Button2 = EmotesSection:WaitForChild("EmotesButton"):WaitForChild("Button");
local Selection = EmotesSection:WaitForChild("SelectionHolder"):WaitForChild("Selection");
local Row = Selection:WaitForChild("Row");
local Emote = Row:WaitForChild("Emote");
Row.Parent = script;
Emote.Parent = script;
local Index = PlayerGui:WaitForChild("Windows"):WaitForChild("Index");
local Button3 = Buttons:WaitForChild("Inventory"):WaitForChild("Button");
local Button4 = Buttons:WaitForChild("Shop"):WaitForChild("Button");
local Button5 = Buttons:WaitForChild("Index"):WaitForChild("Button");
local u2 = 0;
local NumberValue = Instance.new("NumberValue");
NumberValue.Value = -1;
NumberValue.Parent = script;
local u3 = nil;
local u4 = false;
local u5 = nil;
local Position = EmotesSection.Position;
local u6 = Position + UDim2.fromOffset(EmotesSection.AbsoluteSize.X * 1.5, 0);
local u7 = false;
local u8 = nil;
local Position2 = Selection.Position;
local u9 = Position2 + UDim2.fromOffset(Selection.AbsoluteSize.X * 1.5, 0);
local u10 = {};
local u11 = {};
local u12 = {};

function u1.updateCurrency(p13, p14) -- Line: 114
    -- upvalues: u1 (copy), CustomEnum (copy), TicketsWallet (copy), AbbreviateNumber (copy), NumberValue (copy), u2 (ref), CoinsWallet (copy), u3 (ref), TweenService (copy)
    TicketsWallet.TextLabel.Text = AbbreviateNumber(u1.DataClient.currentData.Currency[CustomEnum.CURRENCIES.TICKETS] or 0);
    TicketsWallet.Visible = (u1.DataClient.currentData.Rebirth or 0) >= 2;
    local v15 = u1.DataClient.currentData.Currency[CustomEnum.CURRENCIES.COINS];
    local v16, v17;

    if p14 then
        v16 = 0.01;
        v17 = 0;
        NumberValue.Value = v15;
        u2 = v15;
        CoinsWallet.TextLabel.Text = "$" .. AbbreviateNumber(v15);
    else
        v16 = 0.5;
        v17 = 0.05;
    end;

    if v15 ~= u2 then
        if u3 then
            u3:Cancel();
            v17 = 0;
        end;

        u2 = v15;
        u3 = TweenService:Create(NumberValue, TweenInfo.new(v16, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, v17), {
            Value = u2
        });
        u3:Play();
    end;
end;

function u1.updateEmotes(p18) -- Line: 151
    -- upvalues: u11 (copy), EmotesInfo (copy)
    local Owned = p18.DataClient.currentData.Gamepasses.EMOTE_VIP.Owned;

    for i, v in u11 do
        local Button6 = v.slot.Button;

        if (not EmotesInfo.Emotes[i].vipOnly or Owned) and true or false then
            Button6.ImageTransparency = 0;
        else
            Button6.ImageTransparency = 0.75;
        end;
    end;
end;

function u1.OpenEmotes(p19) -- Line: 175
    -- upvalues: u4 (ref), u5 (ref), Maid (copy), EmotesSection (copy), u6 (copy), TweenService (copy), Position (copy)
    if u4 == true then
        return;
    end;

    u4 = true;

    if u5 then
        u5:Destroy();
    end;

    u5 = Maid.new();
    EmotesSection.Position = u6;
    EmotesSection.Visible = true;
    local u20 = TweenService:Create(EmotesSection, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = Position
    });
    u20:Play();
    u5:GiveTask(function() -- Line: 192
        -- upvalues: u20 (copy)
        if u20 then
            u20:Cancel();
        end;
    end);
end;

function u1.CloseEmotes(p21) -- Line: 197
    -- upvalues: u4 (ref), u5 (ref), Maid (copy), EmotesSection (copy), Position (copy), TweenService (copy), u6 (copy)
    if u4 == false then
        return;
    end;

    u4 = false;

    if u5 then
        u5:Destroy();
    end;

    u5 = Maid.new();
    EmotesSection.Position = Position;
    local u22 = TweenService:Create(EmotesSection, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = u6
    });
    u22:Play();
    u5:GiveTask(function() -- Line: 213
        -- upvalues: u22 (copy)
        if u22 then
            u22:Cancel();
        end;
    end);
    u5:GiveTask(u22.Completed:Once(function() -- Line: 217
        -- upvalues: EmotesSection (ref)
        EmotesSection.Visible = false;
    end));
end;

function u1.OpenSubEmotes(p23) -- Line: 222
    -- upvalues: u7 (ref), u8 (ref), Maid (copy), Selection (copy), u9 (copy), TweenService (copy), Position2 (copy)
    if u7 == true then
        return;
    end;

    u7 = true;

    if u8 then
        u8:Destroy();
    end;

    u8 = Maid.new();
    Selection.Position = u9;
    Selection.Visible = true;
    local u24 = TweenService:Create(Selection, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = Position2
    });
    u24:Play();
    u8:GiveTask(function() -- Line: 239
        -- upvalues: u24 (copy)
        if u24 then
            u24:Cancel();
        end;
    end);
end;

function u1.CloseSubEmotes(p25) -- Line: 244
    -- upvalues: u7 (ref), u8 (ref), Maid (copy), Selection (copy), Position2 (copy), TweenService (copy), u9 (copy)
    if u7 == false then
        return;
    end;

    u7 = false;

    if u8 then
        u8:Destroy();
    end;

    u8 = Maid.new();
    Selection.Position = Position2;
    local u26 = TweenService:Create(Selection, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = u9
    });
    u26:Play();
    u8:GiveTask(function() -- Line: 260
        -- upvalues: u26 (copy)
        if u26 then
            u26:Cancel();
        end;
    end);
    u8:GiveTask(u26.Completed:Once(function() -- Line: 264
        -- upvalues: Selection (ref)
        Selection.Visible = false;
    end));
end;

function u1.SetupEmotes(u27) -- Line: 269
    -- upvalues: EmotesInfo (copy), u10 (copy), Row (copy), Selection (copy), Emote (copy), CustomEnum (copy), u12 (ref), u11 (copy), RunService (copy)
    local v28 = {};

    for i, _ in EmotesInfo.Emotes do
        table.insert(v28, i);
    end;

    table.sort(v28, function(p29, p30) -- Line: 275
        -- upvalues: EmotesInfo (ref)
        return EmotesInfo.Emotes[p29].order < EmotesInfo.Emotes[p30].order;
    end);
    local v31 = math.ceil(#v28 / EmotesInfo.EMOTES_PER_ROW);
    local v32 = 1;
    local v33 = 1;

    while true do
        if v32 > v31 then
            local u34 = 0;
            local u35 = false;
            RunService.Heartbeat:Connect(function(p36) -- Line: 340
                -- upvalues: u35 (ref), u34 (ref), EmotesInfo (ref), u12 (ref), u27 (copy)
                if u35 then
                    return;
                end;

                u34 = u34 + p36;

                if u34 < EmotesInfo.EMOTE_COOLDOWN then
                    return;
                end;

                u34 = 0;
                u35 = true;

                if #u12 > 0 then
                    u27.EmoteService.sendEmoteRequestBatch:Fire(u12);
                    u12 = {};
                end;

                u35 = false;
            end);

            return;
        end;

        if not u10[v32] then
            u10[v32] = Row:Clone();
            u10[v32].Parent = Selection;
        end;

        u10[v32].LayoutOrder = v32;

        for i = 1, EmotesInfo.EMOTES_PER_ROW do
            local u37 = v28[v33];

            if not u37 then
                break;
            end;

            local u38 = EmotesInfo.Emotes[u37];
            local v39 = Emote:Clone();
            v39.Parent = u10[v32];
            v39.LayoutOrder = i;
            v39.Button.Image = u38.image;
            v39.Button.Active = true;
            u27.UI_Manager:AddBounceButton(v39.Button, 1.1, nil, true);
            v39.Button.Activated:Connect(function() -- Line: 308
                -- upvalues: u38 (copy), u27 (copy), CustomEnum (ref), u12 (ref), u37 (copy)
                if u38.vipOnly and not u27.DataClient.currentData.Gamepasses.EMOTE_VIP.Owned then
                    u27.BundlesService.attemptBuyBundle:Fire(CustomEnum.BUNDLES.EMOTES, nil);

                    return;
                end;

                table.insert(u12, u37);
                u27.playEmoteLocal:Fire(u37);
            end);
            u11[u37] = {
                slot = v39
            };
            v33 = v33 + 1;
        end;

        v32 = v32 + 1;
    end;
end;

function u1.update(p40) -- Line: 362
    -- upvalues: u1 (copy), MusicAndAmbience (copy)
    if not u1.DataClient.currentData then
        return;
    end;

    p40:updateCurrency(false);
    p40:updateEmotes();
    local v41 = p40.DataClient.currentData.Settings.SoundVolume or 0.5;
    MusicAndAmbience:MusicVolumeSet(p40.DataClient.currentData.Settings.MusicVolume or 0.5);
    MusicAndAmbience:SoundVolumeSet(v41);
end;

function u1.KnitStart(u42) -- Line: 377
    -- upvalues: Button (copy), StarterPack (copy), Button2 (copy), u7 (ref), Images (copy), SideMenus (copy), Button4 (copy), Button3 (copy), Button5 (copy), Index (copy), CoinsWallet (copy), TextService (copy), NumberValue (copy), AbbreviateNumber (copy), UserInputService (copy)
    u42.UI_Manager:AddBounceButton(Button, 1.05);
    Button.Activated:Connect(function() -- Line: 382
        -- upvalues: u42 (copy), StarterPack (ref)
        u42.UI_Manager:ToggleWindow(StarterPack, true);
    end);
    u42.UI_Manager:AddEmitterTemplate(Button, UDim2.new(0.5, 0, 0.5, 0), u42.UI_Manager.PARTICLE_TEMPLATES.SPARKLE, {
        zIndex = 5,
        em_delay = 0.9
    });
    u42.UI_Manager:AddShineV3(Button, 2.5, Color3.new(1, 1, 1), {
        noThinTwinkle = true,
        rotSpeed = 60
    });
    u42:SetupEmotes();
    u42.UI_Manager:AddBounceButton(Button2, 1.05);
    Button2.Activated:Connect(function() -- Line: 404
        -- upvalues: u7 (ref), u42 (copy)
        if u7 then
            u42:CloseSubEmotes();

            return;
        end;

        u42:OpenSubEmotes();
    end);
    Button2.InputBegan:Connect(function(p43) -- Line: 412
        -- upvalues: Button2 (ref), Images (ref)
        if p43.UserInputType == Enum.UserInputType.MouseMovement or p43.UserInputType == Enum.UserInputType.Touch then
            Button2.ImageLabel.Image = Images.EM_LAUGH;
        end;
    end);
    Button2.InputEnded:Connect(function(p44) -- Line: 420
        -- upvalues: Button2 (ref), Images (ref)
        if p44.UserInputType == Enum.UserInputType.MouseMovement or p44.UserInputType == Enum.UserInputType.Touch then
            Button2.ImageLabel.Image = Images.EM_CHEER;
        end;
    end);
    SideMenus.Visible = true;
    u42.UI_Manager:AddEmitterTemplate(Button4, UDim2.new(0.5, 0, 0.5, 0), u42.UI_Manager.PARTICLE_TEMPLATES.SPARKLE, {
        zIndex = 5
    });
    u42.UI_Manager:AddShineV3(Button4:WaitForChild("Background"), 1.75, Color3.new(1, 1, 1), {
        noThinTwinkle = true,
        rotSpeed = 20
    });
    u42.UI_Manager:AddBounceButton(Button3, 1.05);
    Button3.Activated:Connect(function() -- Line: 447
        -- upvalues: u42 (copy)
        u42.HotbarController:ToggleInventory();
    end);
    u42.UI_Manager:AddBounceButton(Button5, 1.05);
    Button5.Activated:Connect(function() -- Line: 452
        -- upvalues: u42 (copy), Index (ref)
        u42.UI_Manager:ToggleWindow(Index, true);
    end);

    local function updateCoinsScale() -- Line: 457
        -- upvalues: CoinsWallet (ref), TextService (ref)
        local v45 = math.clamp(CoinsWallet.TextLabel.AbsoluteSize.Y, 12, 100);
        local X = TextService:GetTextSize(CoinsWallet.TextLabel.Text, v45, "SourceSans", 100 * CoinsWallet.TextLabel.AbsoluteSize).X;
        CoinsWallet.TextLabel.Size = UDim2.new(0, X, 1, 0);
    end;

    NumberValue.Changed:Connect(function(p46) -- Line: 470
        -- upvalues: CoinsWallet (ref), AbbreviateNumber (ref), updateCoinsScale (copy)
        CoinsWallet.TextLabel.Text = "$" .. AbbreviateNumber(p46);
        updateCoinsScale();
    end);
    updateCoinsScale();
    u42.DataClient.EV_UPDATE:Connect(function() -- Line: 482
        -- upvalues: u42 (copy), updateCoinsScale (copy)
        u42:update();
        updateCoinsScale();
    end);
    u42.DataClient.EV_FIRST_UPDATE:Once(function() -- Line: 488, Name: onFirstDataUpdate
        -- upvalues: u42 (copy), UserInputService (ref)
        u42:updateCurrency(true);
        UserInputService.InputBegan:Connect(function(p47, p48) -- Line: 491
            -- upvalues: u42 (ref)
            if p48 then
                return;
            end;

            if p47.UserInputType ~= Enum.UserInputType.Keyboard then
                return;
            end;

            if p47.KeyCode.Name == u42.DataClient.currentData.Settings.Keybinds.ExitAll then
                u42.UI_Manager:CloseOpenWindowsQuick();
                u42.HotbarController:CloseInventory(false);
            end;
        end);
    end);

    if u42.DataClient:GetLoaded() then
        u42:updateCurrency(true);
        UserInputService.InputBegan:Connect(function(p49, p50) -- Line: 491
            -- upvalues: u42 (copy)
            if p50 then
                return;
            end;

            if p49.UserInputType ~= Enum.UserInputType.Keyboard then
                return;
            end;

            if p49.KeyCode.Name == u42.DataClient.currentData.Settings.Keybinds.ExitAll then
                u42.UI_Manager:CloseOpenWindowsQuick();
                u42.HotbarController:CloseInventory(false);
            end;
        end);
    end;

    u42.UserInputParser.InputTypeChanged:Connect(function() -- Line: 517
        -- upvalues: u42 (copy)
        u42:update();
    end);
end;

function u1.UpdateHudDisabled(p51, p52) -- Line: 522
    -- upvalues: HUD (copy)
    HUD.Enabled = not p52;
end;

function u1.KnitInit(p53) -- Line: 526
    -- upvalues: Knit (copy)
    p53.DataClient = Knit.GetController("DataClient");
    p53.UI_Manager = Knit.GetController("UI_Manager");
    p53.UserInputParser = Knit.GetController("UserInputParser");
    p53.HotbarController = Knit.GetController("HotbarController");
    p53.EmoteService = Knit.GetService("EmoteService");
    p53.BundlesService = Knit.GetService("BundlesService");
end;

return u1;