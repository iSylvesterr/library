-- Decompiled with Potassium's decompiler.

local v1 = {};
game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local u2 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u3 = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u4 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
UDim2.fromScale(0.5, 0.14);
UDim2.fromScale(0.5, 0.5);
UDim2.fromScale(0.5, 0.78);
local u5 = table.freeze({
    [Enum.UserInputType.Gamepad1] = true,
    [Enum.UserInputType.Gamepad2] = true,
    [Enum.UserInputType.Gamepad3] = true,
    [Enum.UserInputType.Gamepad4] = true,
    [Enum.UserInputType.Gamepad5] = true,
    [Enum.UserInputType.Gamepad6] = true,
    [Enum.UserInputType.Gamepad7] = true,
    [Enum.UserInputType.Gamepad8] = true
});
local u6 = table.freeze({
    Defusal = "Defusal",
    Deathmatch = "Deathmatch",
    UnrankedComp = "UnrankedComp",
    Trading = "Trading"
});
local u7 = table.freeze({
    Casual = "Defusal",
    Competitive = "UnrankedComp",
    Deathmatch = "Deathmatch"
});
local u8 = table.freeze({
    ["Bomb Defusal"] = "Defusal",
    ["Hostage Rescue"] = "Defusal",
    Deathmatch = "Deathmatch"
});
local u9 = table.freeze({
    [Constants.GAMEMODE_PLACE_IDS.Casual] = "Defusal",
    [Constants.GAMEMODE_PLACE_IDS.Competitive] = "UnrankedComp",
    [Constants.GAMEMODE_PLACE_IDS.Deathmatch] = "Deathmatch",
    [Constants.GAMEMODE_PLACE_IDS.Trading] = "Trading"
});
local u10 = 0;
local u11 = nil;
local u12 = {};

local function withYScaleOffset(p13, p14) -- Line: 93
    return UDim2.new(p13.X.Scale, p13.X.Offset, p13.Y.Scale + p14, p13.Y.Offset);
end;

local function getCurrentModeName() -- Line: 99
    -- upvalues: u7 (copy), u8 (copy), u9 (copy)
    local v15 = workspace:GetAttribute("ServerGamemode");
    local v16 = workspace:GetAttribute("Gamemode");

    if typeof(v15) == "string" and u7[v15] then
        return u7[v15];
    end;

    if typeof(v16) == "string" and u8[v16] then
        return u8[v16];
    end;

    return u9[game.PlaceId];
end;

local function updateCurrentModeButtons() -- Line: 116
    -- upvalues: getCurrentModeName (copy), u12 (copy), TweenService (copy), u3 (copy)
    local v17 = getCurrentModeName();

    for i, v in pairs(u12) do
        v.SelectButton.Text = v17 == i and "YOU ARE HERE" or v.SelectButtonDefaultText;

        if v.SelectButtonTitle then
            v.SelectButtonTitle.Text = v17 == i and "YOU ARE HERE" or (v.SelectButtonTitleDefaultText or "");
        end;

        if v17 == i then
            v.SelectOverlay.Visible = true;
            v.SelectButton.Visible = false;
            v.CurrentMode.Visible = true;
            TweenService:Create(v.ModeLabel, u3, {
                Position = v.ModeLabelHoverPosition
            }):Play();

            if v.DescriptionLabel and v.DescriptionLabelHoverPosition then
                TweenService:Create(v.DescriptionLabel, u3, {
                    Position = v.DescriptionLabelHoverPosition
                }):Play();
            end;

            if v.SelectOverlayStroke then
                v.SelectOverlayStroke.Transparency = 0;
            end;
        else
            v.CurrentMode.Visible = false;
        end;
    end;
end;

local function shouldShowSelectForInput(p18) -- Line: 152
    -- upvalues: u5 (copy)
    return p18 == Enum.UserInputType.Touch and true or u5[p18] == true;
end;

local function shouldKeepSelectVisible() -- Line: 158
    -- upvalues: UserInputService (copy), GetUserPlatform (copy)
    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        return true;
    end;

    local v19 = GetUserPlatform();
    local v20;

    if table.find(v19, "Mobile") == nil then
        v20 = false;
    else
        v20 = #v19 <= 1;
    end;

    return v20 or UserInputService:GetLastInputType() == Enum.UserInputType.Touch;
end;

local function markSelectVisibilityChanged(p21) -- Line: 171
    p21.SelectVisibilityVersion = p21.SelectVisibilityVersion + 1;

    return p21.SelectVisibilityVersion;
end;

local function tweenSelectButtonFade(p22, p23) -- Line: 178
    -- upvalues: TweenService (copy), u4 (copy)
    local SelectButtonFrame = p22.SelectButtonFrame;
    local SelectButtonTitle = p22.SelectButtonTitle;
    TweenService:Create(p22.SelectButton, u4, {
        BackgroundTransparency = 1,
        TextTransparency = p23
    }):Play();

    if SelectButtonFrame then
        TweenService:Create(SelectButtonFrame, u4, {
            BackgroundTransparency = p23
        }):Play();
        local v24 = SelectButtonFrame:FindFirstChildOfClass("UIStroke");

        if v24 then
            TweenService:Create(v24, u4, {
                Transparency = p23
            }):Play();
        end;

        for _, descendant in ipairs(SelectButtonFrame:GetDescendants()) do
            if descendant:IsA("ImageLabel") then
                TweenService:Create(descendant, u4, {
                    ImageTransparency = p23
                }):Play();
            elseif descendant:IsA("TextLabel") then
                TweenService:Create(descendant, u4, {
                    TextTransparency = p23
                }):Play();
            end;
        end;
    end;

    if SelectButtonTitle then
        TweenService:Create(SelectButtonTitle, u4, {
            TextTransparency = p23
        }):Play();
    end;
end;

local function showCard(p25) -- Line: 222
    -- upvalues: TweenService (copy), u2 (copy), tweenSelectButtonFade (copy), updateCurrentModeButtons (copy), u3 (copy)
    p25.SelectVisibilityVersion = p25.SelectVisibilityVersion + 1;
    local _ = p25.SelectVisibilityVersion;
    p25.SelectOverlay.Visible = true;
    p25.SelectButton.Visible = true;
    local SelectOverlayStroke = p25.SelectOverlayStroke;

    if SelectOverlayStroke then
        SelectOverlayStroke.Transparency = 1;
        TweenService:Create(SelectOverlayStroke, u2, {
            Transparency = 0
        }):Play();
    end;

    tweenSelectButtonFade(p25, 0);
    updateCurrentModeButtons();
    TweenService:Create(p25.ModeLabel, u3, {
        Position = p25.ModeLabelHoverPosition
    }):Play();

    if p25.DescriptionLabel and p25.DescriptionLabelHoverPosition then
        TweenService:Create(p25.DescriptionLabel, u3, {
            Position = p25.DescriptionLabelHoverPosition
        }):Play();
    end;
end;

local function hideCard(u26) -- Line: 251
    -- upvalues: shouldKeepSelectVisible (copy), showCard (copy), tweenSelectButtonFade (copy), updateCurrentModeButtons (copy), TweenService (copy), u3 (copy), u2 (copy)
    local SelectButton = u26.SelectButton;

    if SelectButton.Text == "YOU ARE HERE" then
        return;
    end;

    if shouldKeepSelectVisible() then
        showCard(u26);

        return;
    end;

    u26.SelectVisibilityVersion = u26.SelectVisibilityVersion + 1;
    local SelectVisibilityVersion = u26.SelectVisibilityVersion;
    local SelectOverlayStroke = u26.SelectOverlayStroke;
    local SelectOverlay = u26.SelectOverlay;
    tweenSelectButtonFade(u26, 1);
    updateCurrentModeButtons();
    TweenService:Create(u26.ModeLabel, u3, {
        Position = u26.ModeLabelDefaultPosition
    }):Play();

    if u26.DescriptionLabel and u26.DescriptionLabelDefaultPosition then
        TweenService:Create(u26.DescriptionLabel, u3, {
            Position = u26.DescriptionLabelDefaultPosition
        }):Play();
    end;

    task.delay(0.18, function() -- Line: 279
        -- upvalues: shouldKeepSelectVisible (ref), u26 (copy), SelectVisibilityVersion (copy), SelectButton (copy)
        if shouldKeepSelectVisible() or (u26.IsHoveringCard or (u26.IsHoveringSelect or u26.SelectVisibilityVersion ~= SelectVisibilityVersion)) then
            return;
        end;

        SelectButton.Visible = false;
    end);

    if not SelectOverlayStroke then
        SelectOverlay.Visible = false;

        return;
    end;

    local v27 = TweenService:Create(SelectOverlayStroke, u2, {
        Transparency = 1
    });
    v27:Play();
    v27.Completed:Once(function() -- Line: 295
        -- upvalues: shouldKeepSelectVisible (ref), u26 (copy), SelectVisibilityVersion (copy), SelectOverlay (copy), SelectOverlayStroke (copy)
        if shouldKeepSelectVisible() or (u26.IsHoveringCard or (u26.IsHoveringSelect or u26.SelectVisibilityVersion ~= SelectVisibilityVersion)) then
            return;
        end;

        SelectOverlay.Visible = false;
        SelectOverlayStroke.Transparency = 0;
    end);
end;

local function requestSubplaceTeleport(p28) -- Line: 313
    -- upvalues: u10 (ref), Remotes (copy)
    local v29 = tick();

    if v29 - u10 < 0.75 then
        print((`[Modes] Ignored mode request ({p28}) due to cooldown`));

        return false;
    end;

    u10 = v29;
    Remotes.Modes.SelectGamemode.Send(p28);

    return true;
end;

local function bindModeCard(u30) -- Line: 327
    -- upvalues: u11 (ref), u12 (copy), updateCurrentModeButtons (copy), getCurrentModeName (copy), tweenSelectButtonFade (copy), shouldKeepSelectVisible (copy), u5 (copy), showCard (copy), hideCard (copy), UserInputService (copy), Router (copy), u6 (copy), u10 (ref), Remotes (copy)
    local v31 = u11:WaitForChild("SelectMode"):FindFirstChild(u30, true);

    if not (v31 and v31:IsA("ImageButton")) then
        warn((`[Modes] Missing mode card "{u30}"`));

        return;
    end;

    local Container = v31:WaitForChild("Container");
    local Info = Container:WaitForChild("Info");
    local Select = Info:WaitForChild("Select");
    local v32 = Select:FindFirstChildOfClass("UIStroke");
    local Description = Info:FindFirstChild("Description");
    local Select2 = Info:WaitForChild("Select");
    local Frame = Select2:FindFirstChild("Frame");
    local Title = Select2:FindFirstChild("Title");
    local Mode = Info:WaitForChild("Mode");
    local Button = v31:FindFirstChild("Button");

    if Button and Button:IsA("GuiButton") then
        Button.Active = false;
        pcall(function() -- Line: 349
            -- upvalues: Button (copy)
            Button.Interactable = false;
        end);
    end;

    local ImageButton = Container:FindFirstChild("ImageButton");

    if ImageButton and ImageButton:IsA("GuiButton") then
        ImageButton.Active = false;
        pcall(function() -- Line: 356
            -- upvalues: ImageButton (copy)
            ImageButton.Interactable = false;
        end);
    end;

    Select.Visible = false;
    Select2.Visible = false;
    Select2.ZIndex = 10;
    local Position = Mode.Position;
    local v33 = UDim2.new(Position.X.Scale, Position.X.Offset, Position.Y.Scale + -0.18, Position.Y.Offset);
    local v34;

    if Description and Description:IsA("TextLabel") then
        v34 = Description.Position;
    else
        v34 = nil;
    end;

    local v35;

    if v34 then
        v35 = UDim2.new(v34.X.Scale, v34.X.Offset, v34.Y.Scale + -0.18, v34.Y.Offset);
    else
        v35 = nil;
    end;

    if Frame and Frame:IsA("Frame") then
        Frame.ZIndex = 10;
        Frame.BackgroundTransparency = 1;
        local v36 = Frame:FindFirstChildOfClass("UIStroke");

        if v36 then
            v36.Transparency = 1;
        end;

        for _, descendant in ipairs(Frame:GetDescendants()) do
            if descendant:IsA("GuiObject") then
                descendant.ZIndex = 11;
            end;

            if descendant:IsA("ImageLabel") then
                descendant.ImageTransparency = 1;
            elseif descendant:IsA("TextLabel") then
                descendant.TextTransparency = 1;
            end;
        end;
    end;

    if Title and Title:IsA("TextLabel") then
        Title.ZIndex = 11;
        Title.TextTransparency = 1;
    end;

    local u37 = {
        IsHoveringCard = false,
        IsHoveringSelect = false,
        SelectVisibilityVersion = 0,
        SelectOverlay = Select,
        SelectOverlayStroke = v32,
        SelectButton = Select2,
        CurrentMode = Container.Top.YouAreHere
    };

    if not (Frame and Frame:IsA("Frame")) then
        Frame = nil;
    end;

    u37.SelectButtonFrame = Frame;
    local v38;

    if Title and Title:IsA("TextLabel") then
        v38 = Title;
    else
        v38 = nil;
    end;

    u37.SelectButtonTitle = v38;
    u37.ModeLabel = Mode;
    u37.SelectButtonDefaultText = Select2.Text;
    local v39;

    if Title and Title:IsA("TextLabel") then
        v39 = Title.Text;
    else
        v39 = nil;
    end;

    u37.SelectButtonTitleDefaultText = v39;

    if not (Description and Description:IsA("TextLabel")) then
        Description = nil;
    end;

    u37.DescriptionLabel = Description;
    u37.ModeLabelDefaultPosition = Position;
    u37.ModeLabelHoverPosition = v33;
    u37.DescriptionLabelDefaultPosition = v34;
    u37.DescriptionLabelHoverPosition = v35;
    u12[u30] = u37;
    updateCurrentModeButtons();

    local function updateCardForLastInputType(p40) -- Line: 431
        -- upvalues: getCurrentModeName (ref), u30 (copy), u37 (copy), tweenSelectButtonFade (ref), updateCurrentModeButtons (ref), shouldKeepSelectVisible (ref), u5 (ref), showCard (ref), hideCard (ref)
        if getCurrentModeName() ~= u30 then
            if shouldKeepSelectVisible() or (p40 == Enum.UserInputType.Touch or u5[p40] == true) then
                showCard(u37);

                return;
            end;

            if u37.IsHoveringCard or u37.IsHoveringSelect then
                showCard(u37);

                return;
            end;

            hideCard(u37);

            return;
        end;

        local v41 = u37;
        v41.SelectVisibilityVersion = v41.SelectVisibilityVersion + 1;
        local _ = v41.SelectVisibilityVersion;
        u37.SelectButton.Visible = true;
        tweenSelectButtonFade(u37, 0);
        updateCurrentModeButtons();
    end;

    UserInputService.LastInputTypeChanged:Connect(updateCardForLastInputType);
    updateCardForLastInputType(UserInputService:GetLastInputType());
    v31.MouseEnter:Connect(function() -- Line: 455
        -- upvalues: getCurrentModeName (ref), u30 (copy), Router (ref), u37 (copy), showCard (ref)
        if getCurrentModeName() == u30 then
            return;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        u37.IsHoveringCard = true;
        showCard(u37);
    end);
    v31.MouseLeave:Connect(function() -- Line: 465
        -- upvalues: u37 (copy), shouldKeepSelectVisible (ref), showCard (ref), hideCard (ref)
        u37.IsHoveringCard = false;

        if shouldKeepSelectVisible() then
            showCard(u37);

            return;
        end;

        task.defer(function() -- Line: 472
            -- upvalues: shouldKeepSelectVisible (ref), u37 (ref), hideCard (ref)
            if shouldKeepSelectVisible() or (u37.IsHoveringCard or u37.IsHoveringSelect) then
                return;
            end;

            hideCard(u37);
        end);
    end);
    Select2.MouseEnter:Connect(function() -- Line: 480
        -- upvalues: getCurrentModeName (ref), u30 (copy), u37 (copy), showCard (ref)
        if getCurrentModeName() == u30 then
            return;
        end;

        u37.IsHoveringSelect = true;
        showCard(u37);
    end);
    Select2.MouseLeave:Connect(function() -- Line: 489
        -- upvalues: u37 (copy), shouldKeepSelectVisible (ref), showCard (ref), hideCard (ref)
        u37.IsHoveringSelect = false;

        if shouldKeepSelectVisible() then
            showCard(u37);

            return;
        end;

        if not u37.IsHoveringCard then
            hideCard(u37);
        end;
    end);
    Select2.Activated:Connect(function() -- Line: 498, Name: onSelectPressed
        -- upvalues: getCurrentModeName (ref), u30 (copy), u6 (ref), Router (ref), u10 (ref), Remotes (ref), Select2 (copy), Title (copy)
        if getCurrentModeName() == u30 then
            return;
        end;

        local v42 = u6[u30];
        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if v42 then
            local v43 = tick();
            local v44;

            if v43 - u10 < 0.75 then
                print((`[Modes] Ignored mode request ({v42}) due to cooldown`));
                v44 = false;
            else
                u10 = v43;
                Remotes.Modes.SelectGamemode.Send(v42);
                v44 = true;
            end;

            if v44 then
                Select2.Text = "TELEPORTING";

                if Title and Title:IsA("TextLabel") then
                    Title.Text = "TELEPORTING";
                end;
            end;
        end;
    end);
end;

function v1.Initialize(p45, p46) -- Line: 520
    -- upvalues: u11 (ref)
    u11 = p46;
end;

function v1.Start() -- Line: 526
    -- upvalues: bindModeCard (copy), updateCurrentModeButtons (copy)
    bindModeCard("Defusal");
    bindModeCard("Deathmatch");
    bindModeCard("UnrankedComp");
    bindModeCard("Trading");
    workspace:GetAttributeChangedSignal("ServerGamemode"):Connect(updateCurrentModeButtons);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(updateCurrentModeButtons);
    updateCurrentModeButtons();
end;

return v1;