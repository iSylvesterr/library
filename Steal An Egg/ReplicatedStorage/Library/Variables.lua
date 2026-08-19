-- Decompiled with Potassium's decompiler.

local CountedLock = require(game.ReplicatedStorage.Library.Modules.CountedLock);

return {
    BrainrotEggActive = 0,
    ActiveAssetsInitialLoadComplete = false,
    HammerEquipped = false,
    SelectedActiveItem = nil,
    FirstStreamingStatusSet = false,
    Streaming = false,
    ServerClosing = false,
    HideProgressUI = false,
    HideGoalsUI = false,
    GameLoaded = true,
    DisableInfoOverlay = false,
    IsInteractingWithNpc = false,
    IsUsingFreecam = false,
    IsUsingTool = false,
    Trading = false,
    PotatoMode = false,
    Locks = {
        DisableBoostUI = CountedLock.new(),
        AreaEggRunBack = CountedLock.new(),
        GuardedGameplayMusic = CountedLock.new(),
        HideUI = CountedLock.new(),
        HideUIAllowNotifications = CountedLock.new(),
        DisableNotifications = CountedLock.new(),
        DisableShiftLock = CountedLock.new(),
        DisableTouchControls = CountedLock.new(),
        AddScreenCurrency = CountedLock.new()
    },
    Desktop = true,
    Mobile = false,
    Console = false,
    VR = false,
    Platform = "Desktop",
    Chatting = false,
    Typing = false,
    Orientation = Enum.ScreenOrientation.LandscapeSensor,
    Portrait = false,
    Landscape = true,
    SafeAreaInsets = {
        left = 0,
        top = 0,
        right = 0,
        bottom = 0
    },
    NotchSide = {
        None = true,
        Left = false,
        Right = false
    },
    MessageOpen = false,
    GuiThatWasEnabled = nil,
    GiftUserId = nil,
    GiftUserName = nil,
    GiftMessage = nil
};