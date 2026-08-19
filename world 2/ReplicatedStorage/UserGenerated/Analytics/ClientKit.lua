-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = Asserts.Table({
    JoinSource = Asserts.Enum(Enum.JoinSource),
    ItemType = Asserts.Optional(Asserts.Enum(Enum.AvatarItemType)),
    AssetId = Asserts.Optional(Asserts.Pattern("^rbxassetid://%d+$")),
    OutfitId = Asserts.Optional(Asserts.Pattern("^rbxassetid://%d+$")),
    AssetType = Asserts.Optional(Asserts.Enum(Enum.AssetType))
});
local v2 = Asserts.Table({
    SourceGameId = Asserts.Optional(Asserts.Integer),
    SourcePlaceId = Asserts.Optional(Asserts.Integer),
    ReferredByPlayerId = Asserts.Optional(Asserts.Integer),
    Members = Asserts.Optional(Asserts.UniqueArray(Asserts.Integer)),
    TeleportData = Asserts.Optional(Asserts.Storable),
    LaunchData = Asserts.Optional(Asserts.Storable),
    GameJoinContext = Asserts.Optional(v1)
});
local v3 = {};

for _, v in ipairs(Enum.DeveloperMemoryTag:GetEnumItems()) do
    local Name = v.Name;
    v3[Name == "PhysicsParts" and "BaseParts" or Name] = Asserts.FiniteNonNegative;
end;

local v4 = Asserts.Table({
    ContactsCount = Asserts.IntegerNonNegative,
    DataReceiveKbps = Asserts.FiniteNonNegative,
    DataSendKbps = Asserts.FiniteNonNegative,
    FrameTime = Asserts.FiniteNonNegative,
    HeartbeatTime = Asserts.FiniteNonNegative,
    InstanceCount = Asserts.IntegerNonNegative,
    MovingPrimitivesCount = Asserts.IntegerNonNegative,
    PhysicsReceiveKbps = Asserts.FiniteNonNegative,
    PhysicsSendKbps = Asserts.FiniteNonNegative,
    PhysicsStepTime = Asserts.FiniteNonNegative,
    PrimitivesCount = Asserts.IntegerNonNegative,
    RenderCPUFrameTime = Asserts.FiniteNonNegative,
    RenderGPUFrameTime = Asserts.Number,
    SceneDrawcallCount = Asserts.IntegerNonNegative,
    SceneTriangleCount = Asserts.IntegerNonNegative,
    ShadowsDrawcallCount = Asserts.IntegerNonNegative,
    ShadowsTriangleCount = Asserts.IntegerNonNegative,
    UI2DDrawcallCount = Asserts.IntegerNonNegative,
    UI2DTriangleCount = Asserts.IntegerNonNegative,
    UI3DDrawcallCount = Asserts.IntegerNonNegative,
    UI3DTriangleCount = Asserts.IntegerNonNegative,
    MemoryUsageMbForTag = Asserts.Table(v3),
    TotalMemoryUsageMb = Asserts.FiniteNonNegative
});
local v5 = {
    AssertGameJoinContext = v1,
    AssertJoinData = v2,
    AssertData = Asserts.Table({
        System = Asserts.Table({
            UWP = Asserts.Optional(Asserts.Boolean),
            Windows = Asserts.Boolean,
            Time = Asserts.Finite,
            Clock = Asserts.Finite,
            ElapsedTime = Asserts.Finite,
            TimezoneOffset = Asserts.String,
            Timezone = Asserts.String,
            TimezoneDST = Asserts.Boolean,
            HeapSize = Asserts.FiniteNonNegative
        }),
        Game = Asserts.Table({
            LoadingDuration = Asserts.Optional(Asserts.FiniteNonNegative)
        }),
        LocalPlayer = Asserts.Table({
            JoinData = v2,
            NetworkPing = Asserts.Optional(Asserts.FinitePositive)
        }),
        TeleportService = Asserts.Table({
            TeleportData = Asserts.Optional(Asserts.Storable)
        }),
        Workspace = Asserts.Table({
            ServerTimeNow = Asserts.Finite,
            RealPhysicsFPS = Asserts.FiniteNonNegative,
            DistributedGameTime = Asserts.FiniteNonNegative,
            NumAwakeParts = Asserts.FiniteNonNegative,
            PhysicsThrottling = Asserts.IntegerRange(0, 100)
        }),
        Stats = Asserts.Optional(v4),
        UserInputService = Asserts.Table({
            DeviceForm = Asserts.Optional(Asserts.Enum(Enum.DeviceForm))
        }),
        GuiService = Asserts.Table({
            IsTenFootInterface = Asserts.Boolean,
            TouchControlsEnabled = Asserts.Boolean,
            GuiInsetTopLeft = Asserts.Vector2Finite,
            GuiInsetBotRight = Asserts.Vector2Finite,
            IsModalDialog = Asserts.Boolean,
            MenuIsOpen = Asserts.Boolean,
            PreferredTransparency = Asserts.Range(0, 1),
            ReducedMotionEnabled = Asserts.Boolean,
            CoreGuiNavigationEnabled = Asserts.Boolean,
            GuiNavigationEnabled = Asserts.Boolean,
            AutoSelectGuiEnabled = Asserts.Boolean
        }),
        CurrentCamera = Asserts.Table({
            ViewportSize = Asserts.Vector2Finite
        }),
        LocalizationService = Asserts.Table({
            RobloxLocaleId = Asserts.StringRange(0, 1000),
            SystemLocaleId = Asserts.StringRange(0, 5000)
        }),
        VoiceChatService = Asserts.Table({
            VoiceEnabled = Asserts.Optional(Asserts.Boolean)
        }),
        UserSettings = Asserts.Table({
            GameSettings = Asserts.Table({
                ControlMode = Asserts.Enum(Enum.ControlMode),
                VignetteEnabled = Asserts.Boolean,
                ComputerCameraMovementMode = Asserts.Enum(Enum.ComputerCameraMovementMode),
                ComputerMovementMode = Asserts.Enum(Enum.ComputerMovementMode),
                GamepadCameraSensitivity = Asserts.FiniteNonNegative,
                MouseSensitivity = Asserts.Range(0, 10),
                RotationType = Asserts.Enum(Enum.RotationType),
                SavedQualityLevel = Asserts.Enum(Enum.SavedQualitySetting),
                TouchCameraMovementMode = Asserts.Enum(Enum.TouchCameraMovementMode),
                TouchMovementMode = Asserts.Enum(Enum.TouchMovementMode),
                InFullScreen = Asserts.Boolean,
                InStudioMode = Asserts.Boolean
            })
        })
    }),
    AcceptRemote = script:WaitForChild("Accept"),
    PingRemote = script:WaitForChild("Ping"),
    MenuStateRemote = script:WaitForChild("MenuState"),
    FocusStateRemote = script:WaitForChild("FocusState")
};

return table.freeze(v5);