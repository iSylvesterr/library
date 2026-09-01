local HttpService = game:GetService("HttpService")

pcall(function()
    if not isfolder("Zeroin") then
        makefolder("Zeroin")
    end
    if not isfolder("Zeroin/Config") then
        makefolder("Zeroin/Config")
    end
end)

local univId = tostring(game.GameId)
if univId == "0" or univId == "" then
    univId = tostring(game.PlaceId)
end

local ConfigFile = "Zeroin/Config/Zeroin_" .. univId .. ".json"

ConfigData       = {}
Elements         = {}
CURRENT_VERSION  = nil

function SaveConfig()
    if writefile then
        ConfigData._version = CURRENT_VERSION
        pcall(function()
            writefile(ConfigFile, HttpService:JSONEncode(ConfigData))
        end)
    end
end

function LoadConfigFromFile()
    if not CURRENT_VERSION then return end
    
    local isFileSuccess, isFileResult = false, false
    if isfile then
        isFileSuccess, isFileResult = pcall(function() return isfile(ConfigFile) end)
    end

    if isFileSuccess and isFileResult then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(ConfigFile))
        end)
        if success and type(result) == "table" then
            if result._version == CURRENT_VERSION then
                ConfigData = result
            else
                ConfigData = { _version = CURRENT_VERSION }
            end
        else
            ConfigData = { _version = CURRENT_VERSION }
        end
    else
        ConfigData = { _version = CURRENT_VERSION }
    end
end

function LoadConfigElements()
    for key, element in pairs(Elements) do
        if ConfigData[key] ~= nil and element.Set then
            element:Set(ConfigData[key], true)
        end
    end
end

-- ============================================================
-- CONFIG PROFILE SYSTEM
-- ============================================================
local PROFILE_FOLDER = "Zeroin/Profiles"

local function EnsureProfileFolder()
    pcall(function()
        if not isfolder("Zeroin") then makefolder("Zeroin") end
        if not isfolder("Zeroin/Config") then makefolder("Zeroin/Config") end
        if not isfolder(PROFILE_FOLDER) then makefolder(PROFILE_FOLDER) end
    end)
end

function GetProfileList()
    local profiles = {}
    pcall(function()
        EnsureProfileFolder()
        local files = listfiles(PROFILE_FOLDER)
        for _, filePath in ipairs(files) do
            local normalized = tostring(filePath):gsub("\\", "/")
            local fileName = normalized:match("([^/]+)$") or ""
            if fileName:match("%.json$") then
                table.insert(profiles, (fileName:gsub("%.json$", "")))
            end
        end
    end)
    table.sort(profiles)
    return profiles
end

function SaveProfile(name)
    if not name or name == "" then return false end
    EnsureProfileFolder()
    local ok, err = pcall(function()
        writefile(PROFILE_FOLDER .. "/" .. name .. ".json", HttpService:JSONEncode(ConfigData))
    end)
    return ok, err
end

function LoadProfile(name)
    if not name or name == "" then return false end
    local path = PROFILE_FOLDER .. "/" .. name .. ".json"
    if not isfile then return false end
    local isFileSuccess, isFileResult = pcall(function() return isfile(path) end)
    if not isFileSuccess or not isFileResult then return false end
    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile(path))
    end)
    if ok and type(data) == "table" then
        for key, val in pairs(data) do
            ConfigData[key] = val
        end
        for key, element in pairs(Elements) do
            if ConfigData[key] ~= nil and element.Set then
                pcall(function()
                    element:Set(ConfigData[key])
                end)
                task.wait(0.03)
            end
        end
        SaveConfig()
        return true
    end
    return false
end

function DeleteProfile(name)
    if not name or name == "" then return false end
    local path = PROFILE_FOLDER .. "/" .. name .. ".json"
    local ok = pcall(function()
        if isfile(path) then delfile(path) end
    end)
    return ok
end

local Icons = {
    home      = "rbxassetid://10828236109",
    info      = "rbxassetid://10828236359",
    player    = "rbxassetid://12120698352",
    web       = "rbxassetid://137601480983962",
    bag       = "rbxassetid://8601111810",
    shop      = "rbxassetid://4985385964",
    cart      = "rbxassetid://128874923961846",
    plug      = "rbxassetid://137601480983962",
    settings  = "rbxassetid://70386228443175",
    loop      = "rbxassetid://122032243989747",
    gps       = "rbxassetid://17824309485",
    compas    = "rbxassetid://125300760963399",
    gamepad   = "rbxassetid://84173963561612",
    boss      = "rbxassetid://13132186360",
    scroll    = "rbxassetid://114127804740858",
    menu      = "rbxassetid://6340513838",
    crosshair = "rbxassetid://12614416478",
    user      = "rbxassetid://108483430622128",
    stat      = "rbxassetid://12094445329",
    eyes      = "rbxassetid://14321059114",
    sword     = "rbxassetid://82472368671405",
    discord   = "rbxassetid://94434236999817",
    star      = "rbxassetid://107005941750079",
    skeleton  = "rbxassetid://17313330026",
    payment   = "rbxassetid://18747025078",
    scan      = "rbxassetid://109869955247116",
    alert     = "rbxassetid://73186275216515",
    question  = "rbxassetid://17510196486",
    idea      = "rbxassetid://16833255748",
    strom     = "rbxassetid://13321880293",
    water     = "rbxassetid://100076212630732",
    dcs       = "rbxassetid://15310731934",
    start     = "rbxassetid://108886429866687",
    next      = "rbxassetid://12662718374",
    rod       = "rbxassetid://103247953194129",
    fish      = "rbxassetid://97167558235554",
    enviicon  = "rbxassetid://101669656973003",
    nplnicon  = "rbxassetid://111895858615511",
    nplnv4    = "rbxassetid://87167468756710",
}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")
local viewport = workspace.CurrentCamera.ViewportSize

-- Zeroin visual identity: sampled from the supplied black/emerald reference.
local ThemeColors = {
    BackgroundTop = Color3.fromRGB(5, 29, 19),
    BackgroundMid = Color3.fromRGB(6, 53, 32),
    BackgroundBottom = Color3.fromRGB(4, 31, 20),
    Accent = Color3.fromRGB(0, 205, 122),
    AccentBright = Color3.fromRGB(0, 229, 137),
    Border = Color3.fromRGB(20, 126, 83),
}

local function resolveImage(source)
    if source == nil then return "" end

    local value = tostring(source)
    if value == "" then return "" end
    if value:match("^rbxasset") or value:match("^https?://") then
        return value
    end
    if value:match("^%d+$") then
        return "rbxassetid://" .. value
    end

    -- Local images are useful during executor-side development. Published
    -- builds should pass a Roblox asset id so every user can load the logo.
    if getcustomasset then
        local ok, asset = pcall(getcustomasset, value)
        if ok and asset then return asset end
    end

    return value
end

local function isMobileDevice()
    return UserInputService.TouchEnabled
        and not UserInputService.KeyboardEnabled
        and not UserInputService.MouseEnabled
end

local isMobile = isMobileDevice()

local function safeSize(pxWidth, pxHeight)
    local scaleX = pxWidth / viewport.X
    local scaleY = pxHeight / viewport.Y

    if isMobile then
        if scaleX > 0.5 then scaleX = 0.5 end
        if scaleY > 0.3 then scaleY = 0.3 end
    end

    return UDim2.new(scaleX, 0, scaleY, 0)
end

local function MakeDraggable(topbarobject, object)
    local function CustomPos(topbarobject, object)
        local Dragging, DragInput, DragStart, StartPosition

        local function UpdatePos(input)
            local Delta = input.Position - DragStart
            local pos = UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
            local Tween = TweenService:Create(object, TweenInfo.new(0.2), { Position = pos })
            Tween:Play()
        end

        topbarobject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = input.Position
                StartPosition = object.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end
        end)

        topbarobject.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                DragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == DragInput and Dragging then
                UpdatePos(input)
            end
        end)
    end

    local function CustomSize(object)
        local Dragging, DragInput, DragStart, StartSize

        local minSizeX, minSizeY
        local defSizeX, defSizeY

        if isMobile then
            minSizeX, minSizeY = 100, 100
            defSizeX, defSizeY = 470, 270
        else
            minSizeX, minSizeY = 100, 100
            defSizeX, defSizeY = 586, 364
        end

        object.Size = UDim2.new(0, defSizeX, 0, defSizeY)

        local changesizeobject = Instance.new("Frame")
        changesizeobject.AnchorPoint = Vector2.new(1, 1)
        changesizeobject.BackgroundTransparency = 1
        changesizeobject.Size = UDim2.new(0, 40, 0, 40)
        changesizeobject.Position = UDim2.new(1, 20, 1, 20)
        changesizeobject.Name = "changesizeobject"
        changesizeobject.Parent = object

        local function UpdateSize(input)
            local Delta = input.Position - DragStart
            local newWidth = StartSize.X.Offset + Delta.X
            local newHeight = StartSize.Y.Offset + Delta.Y

            newWidth = math.max(newWidth, minSizeX)
            newHeight = math.max(newHeight, minSizeY)

            local Tween = TweenService:Create(object, TweenInfo.new(0.2), { Size = UDim2.new(0, newWidth, 0, newHeight) })
            Tween:Play()
        end

        changesizeobject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = input.Position
                StartSize = object.Size
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end
        end)

        changesizeobject.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                DragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == DragInput and Dragging then
                UpdateSize(input)
            end
        end)
    end

    CustomSize(object)
    CustomPos(topbarobject, object)
end

function CircleClick(Button, X, Y)
    spawn(function()
        Button.ClipsDescendants = true
        local Circle = Instance.new("ImageLabel")
        Circle.Image = "rbxassetid://266543268"
        Circle.ImageColor3 = Color3.fromRGB(80, 80, 80)
        Circle.ImageTransparency = 0.8999999761581421
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.BackgroundTransparency = 1
        Circle.ZIndex = 10
        Circle.Name = "Circle"
        Circle.Parent = Button

        local NewX = X - Circle.AbsolutePosition.X
        local NewY = Y - Circle.AbsolutePosition.Y
        Circle.Position = UDim2.new(0, NewX, 0, NewY)
        local Size = 0
        if Button.AbsoluteSize.X > Button.AbsoluteSize.Y then
            Size = Button.AbsoluteSize.X * 1.5
        elseif Button.AbsoluteSize.X < Button.AbsoluteSize.Y then
            Size = Button.AbsoluteSize.Y * 1.5
        elseif Button.AbsoluteSize.X == Button.AbsoluteSize.Y then
            Size = Button.AbsoluteSize.X * 1.5
        end

        local Time = 0.5
        Circle:TweenSizeAndPosition(UDim2.new(0, Size, 0, Size), UDim2.new(0.5, -Size / 2, 0.5, -Size / 2), "Out", "Quad",
            Time, false, nil)
        for i = 1, 10 do
            Circle.ImageTransparency = Circle.ImageTransparency + 0.01
            wait(Time / 10)
        end
        Circle:Destroy()
    end)
end

local Zeroin = {}
function Zeroin:MakeNotify(NotifyConfig)
    local NotifyConfig = NotifyConfig or {}
    NotifyConfig.Title = NotifyConfig.Title or "Zeroin"
    NotifyConfig.Description = NotifyConfig.Description or "Notification"
    NotifyConfig.Content = NotifyConfig.Content or "Content"
    NotifyConfig.Icon = NotifyConfig.Icon or "108203634075572"
    NotifyConfig.Color = NotifyConfig.Color or Color3.fromRGB(150, 150, 150)
    NotifyConfig.Time = NotifyConfig.Time or 0.5
    NotifyConfig.Delay = NotifyConfig.Delay or 5
    local NotifyFunction = {}
    spawn(function()
        if not CoreGui:FindFirstChild("NotifyGui") then
            local NotifyGui = Instance.new("ScreenGui");
            NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            NotifyGui.Name = "NotifyGui"
            NotifyGui.Parent = CoreGui
        end
        if not CoreGui.NotifyGui:FindFirstChild("NotifyLayout") then
            local NotifyLayout = Instance.new("Frame");
            NotifyLayout.AnchorPoint = Vector2.new(1, 0)
            NotifyLayout.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NotifyLayout.BackgroundTransparency = 0.9990000128746033
            NotifyLayout.BorderColor3 = Color3.fromRGB(0, 0, 0)
            NotifyLayout.BorderSizePixel = 0
            NotifyLayout.Position = UDim2.new(1, -30, 0, 30)
            NotifyLayout.Size = UDim2.new(0, 320, 1, 0)
            NotifyLayout.Name = "NotifyLayout"
            NotifyLayout.Parent = CoreGui.NotifyGui
            local Count = 0
            CoreGui.NotifyGui.NotifyLayout.ChildRemoved:Connect(function()
                Count = 0
                for i, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
                    TweenService:Create(
                        v,
                        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                        { Position = UDim2.new(0, 0, 0, ((v.Size.Y.Offset + 12) * Count)) }
                    ):Play()
                    Count = Count + 1
                end
            end)
        end
        local NotifyPosHeigh = 0
        for i, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
            NotifyPosHeigh = v.Position.Y.Offset + v.Size.Y.Offset + 12
        end
        local NotifyFrame = Instance.new("Frame");
        local NotifyFrameReal = Instance.new("Frame");
        local UICorner = Instance.new("UICorner");
        local DropShadowHolder = Instance.new("Frame");
        local DropShadow = Instance.new("ImageLabel");
        local Top = Instance.new("Frame");
        local TextLabel = Instance.new("TextLabel");
        local UICorner1 = Instance.new("UICorner");
        local TextLabel1 = Instance.new("TextLabel");
        local Close = Instance.new("TextButton");
        local ImageLabel = Instance.new("ImageLabel");
        local TextLabel2 = Instance.new("TextLabel");

        NotifyFrame.BackgroundColor3 = Color3.fromRGB(29, 30, 35)
        NotifyFrame.BorderColor3 = Color3.fromRGB(29, 30, 35)
        NotifyFrame.BorderSizePixel = 0
        NotifyFrame.Size = UDim2.new(1, 0, 0, 150)
        NotifyFrame.Name = "NotifyFrame"
        NotifyFrame.BackgroundTransparency = 1
        NotifyFrame.Parent = CoreGui.NotifyGui.NotifyLayout
        NotifyFrame.AnchorPoint = Vector2.new(0, 0)
        NotifyFrame.Position = UDim2.new(0, 0, 0, NotifyPosHeigh)

        NotifyFrameReal.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        NotifyFrameReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
        NotifyFrameReal.BorderSizePixel = 0
        NotifyFrameReal.Position = UDim2.new(0, 400, 0, 0)
        NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
        NotifyFrameReal.Name = "NotifyFrameReal"
        NotifyFrameReal.Parent = NotifyFrame

        UICorner.Parent = NotifyFrameReal
        UICorner.CornerRadius = UDim.new(0, 8)

        DropShadowHolder.BackgroundTransparency = 1
        DropShadowHolder.BorderSizePixel = 0
        DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
        DropShadowHolder.ZIndex = 0
        DropShadowHolder.Name = "DropShadowHolder"
        DropShadowHolder.Parent = NotifyFrameReal

        local NotifIcon = Instance.new("ImageLabel")
        NotifIcon.Image = "rbxassetid://108203634075572" --.. NotifyConfig.Icon
        NotifIcon.BackgroundTransparency = 1
        NotifIcon.ImageTransparency = 0
        NotifIcon.BorderSizePixel = 0
        NotifIcon.Size = UDim2.new(0, 60, 0, 60)
        NotifIcon.Position = UDim2.new(0., 0, 0.05, 0)
        NotifIcon.ScaleType = Enum.ScaleType.Fit
        NotifIcon.Name = "NotifIcon"
        NotifIcon.ZIndex = 0
        NotifIcon.Parent = NotifyFrameReal

        Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Top.BackgroundTransparency = 0.9990000128746033
        Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Top.BorderSizePixel = 0
        Top.Position = UDim2.new(0, 55, 0, 0)
        Top.Size = UDim2.new(1, -55, 0, 36)
        Top.Name = "Top"
        Top.Parent = NotifyFrameReal

        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.Text = NotifyConfig.Title
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextSize = 14
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.BackgroundTransparency = 0.9990000128746033
        TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel.BorderSizePixel = 0
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.Parent = Top
        TextLabel.Position = UDim2.new(0, 10, 0, 0)

        UICorner1.Parent = Top
        UICorner1.CornerRadius = UDim.new(0, 5)

        TextLabel1.Font = Enum.Font.GothamBold
        TextLabel1.Text = NotifyConfig.Description
        TextLabel1.TextColor3 = NotifyConfig.Color
        TextLabel1.TextSize = 14
        TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel1.BackgroundColor3 = Color3.fromRGB(255, 130, 130)
        TextLabel1.BackgroundTransparency = 0.9990000128746033
        TextLabel1.TextTransparency = 0.3
        TextLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel1.BorderSizePixel = 0
        TextLabel1.Size = UDim2.new(1, 0, 1, 0)
        TextLabel1.Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0)
        TextLabel1.Parent = Top

        Close.Font = Enum.Font.SourceSans
        Close.Text = ""
        Close.TextColor3 = Color3.fromRGB(0, 0, 0)
        Close.TextSize = 14
        Close.AnchorPoint = Vector2.new(1, 0.5)
        Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Close.BackgroundTransparency = 0.9990000128746033
        Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Close.BorderSizePixel = 0
        Close.Position = UDim2.new(1, -5, 0.5, 0)
        Close.Size = UDim2.new(0, 25, 0, 25)
        Close.Name = "Close"
        Close.Parent = Top

        ImageLabel.Image = "rbxassetid://9886659671"
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ImageLabel.BackgroundTransparency = 0.9990000128746033
        ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ImageLabel.BorderSizePixel = 0
        ImageLabel.Position = UDim2.new(0.49000001, 0, 0.5, 0)
        ImageLabel.Size = UDim2.new(1, -8, 1, -8)
        ImageLabel.Parent = Close

        TextLabel2.Font = Enum.Font.GothamBold
        TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel2.TextSize = 13
        TextLabel2.Text = NotifyConfig.Content
        TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel2.TextYAlignment = Enum.TextYAlignment.Top
        TextLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel2.BackgroundTransparency = 0.9990000128746033
        TextLabel2.TextColor3 = Color3.fromRGB(150.0000062584877, 150.0000062584877, 150.0000062584877)
        TextLabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel2.BorderSizePixel = 0
        TextLabel2.Position = UDim2.new(0, 65, 0, 27)
        TextLabel2.Parent = NotifyFrameReal
        TextLabel2.Size = UDim2.new(1, -90, 0, 13)

        TextLabel2.Size = UDim2.new(1, -90, 0, 13 + (13 * (TextLabel2.TextBounds.X // TextLabel2.AbsoluteSize.X)))
        TextLabel2.TextWrapped = true

        if TextLabel2.AbsoluteSize.Y < 27 then
            NotifyFrame.Size = UDim2.new(1, 0, 0, 65)
        else
            NotifyFrame.Size = UDim2.new(1, 0, 0, TextLabel2.AbsoluteSize.Y + 40)
        end
        local waitbruh = false
        function NotifyFunction:Close()
            if waitbruh then
                return false
            end
            waitbruh = true
            TweenService:Create(
                NotifyFrameReal,
                TweenInfo.new(tonumber(NotifyConfig.Time), Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
                { Position = UDim2.new(0, 400, 0, 0) }
            ):Play()
            task.wait(tonumber(NotifyConfig.Time) / 1.2)
            NotifyFrame:Destroy()
        end

        Close.Activated:Connect(function()
            NotifyFunction:Close()
        end)
        TweenService:Create(
            NotifyFrameReal,
            TweenInfo.new(tonumber(NotifyConfig.Time), Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
            { Position = UDim2.new(0, 0, 0, 0) }
        ):Play()
        task.wait(tonumber(NotifyConfig.Delay))
        NotifyFunction:Close()
    end)
    return NotifyFunction
end

function notif(msg, delay, color, title, desc)
    return Zeroin:MakeNotify({
        Title = title or "Zeroin",
        Description = desc or "Notification",
        Content = msg or "Content",
        Color = color or Color3.fromRGB(150, 150, 150),
        Delay = delay or 4
    })
end

function Zeroin:Window(GuiConfig)
    GuiConfig              = GuiConfig or {}
    GuiConfig.Title        = GuiConfig.Title or "Zeroin"
    GuiConfig.Footer       = GuiConfig.Footer or "Zeroin >:D"
    GuiConfig.Color        = GuiConfig.Color or ThemeColors.Accent
    GuiConfig.Color2       = GuiConfig.Color2 or ThemeColors.BackgroundTop
    GuiConfig["Tab Width"] = GuiConfig["Tab Width"] or 120
    GuiConfig.Version      = GuiConfig.Version or 1

    CURRENT_VERSION        = GuiConfig.Version
    LoadConfigFromFile()

    local GuiFunc = {}

    local ZeroinOnTop = Instance.new("ScreenGui");
    local DropShadowHolder = Instance.new("Frame");
    local DropShadow = Instance.new("ImageLabel");
    local Main = Instance.new("Frame");
    local UICorner = Instance.new("UICorner");
    local Top = Instance.new("Frame");
    local TextLabel = Instance.new("TextLabel");
    local UICorner1 = Instance.new("UICorner");
    local TextLabel1 = Instance.new("TextLabel");
    local Close = Instance.new("TextButton");
    local ImageLabel1 = Instance.new("ImageLabel");
    local Min = Instance.new("TextButton");
    local ImageLabel2 = Instance.new("ImageLabel");
    local FullScreen = Instance.new("TextButton")
    local ImageLabel3 = Instance.new("ImageLabel")
    local LayersTab = Instance.new("Frame");
    local UICorner2 = Instance.new("UICorner");
    local UICorner3 = Instance.new("UICorner")
    local DecideFrame = Instance.new("Frame");
    local Layers = Instance.new("Frame");
    local UICorner6 = Instance.new("UICorner");
    local NameTab = Instance.new("TextLabel");
    local LayersReal = Instance.new("Frame");
    local LayersFolder = Instance.new("Folder");
    local LayersPageLayout = Instance.new("UIPageLayout");

    ZeroinOnTop.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ZeroinOnTop.Name = "ZeroinOnTop"
    ZeroinOnTop.ResetOnSpawn = false
    ZeroinOnTop.Parent = game:GetService("CoreGui")

    DropShadowHolder.BackgroundTransparency = 1
	--DropShadowHolder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    DropShadowHolder.BorderSizePixel = 0
    DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    if isMobile then
        DropShadowHolder.Size = UDim2.new(0, 470, 0, 270)
    else
        DropShadowHolder.Size = UDim2.new(0, 586, 0, 364)
    end
    DropShadowHolder.ZIndex = 0
    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = ZeroinOnTop

    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.6
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.BorderSizePixel = 0
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 47, 1, 47)
    DropShadow.ZIndex = 0
    DropShadow.Name = "DropShadow"
    DropShadow.Parent = DropShadowHolder

    if GuiConfig.Theme then
        Main:Destroy()
        Main = Instance.new("ImageLabel")
        Main.Image = "rbxassetid://" .. GuiConfig.Theme
        Main.ScaleType = Enum.ScaleType.Crop
        Main.BackgroundTransparency = 0.15
        Main.ImageTransparency = GuiConfig.ThemeTransparency or 0.15
    else
        -- A single dark-emerald material avoids Roblox UIGradient banding on
        -- very dark colors while preserving the requested black/green blend.
        Main.BackgroundColor3 = Color3.fromRGB(4, 28, 18)
        Main.BackgroundTransparency = 0.01
    end

    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(1, -47, 1, -47)
    Main.Name = "Main"
    Main.Parent = DropShadow

    UICorner3.Parent = Main
    UICorner3.CornerRadius = UDim.new(0.02, 0)

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = ThemeColors.Border
    MainStroke.Transparency = 0.18
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Thickness = 1.2
    MainStroke.Parent = Main

    Top.BackgroundColor3 = Color3.fromRGB(4, 28, 18)
    Top.BackgroundTransparency = 0.01
    Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Top.BorderSizePixel = 0
    Top.Size = UDim2.new(1, 0, 0, 38)
    Top.Name = "Top"
    Top.Parent = Main

    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.Text = GuiConfig.Title
    TextLabel.TextColor3 = Color3.fromRGB(170, 170, 170)
    TextLabel.TextSize = 14
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 0.9990000128746033
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.new(1, -100, 1, 0)
    TextLabel.Position = UDim2.new(0, 38, 0, 0)
    TextLabel.Parent = Top

    local LogoImg = Instance.new("ImageLabel")
    LogoImg.Image = resolveImage(GuiConfig.LogoHUB)
	LogoImg.BackgroundTransparency = 1
	LogoImg.BorderSizePixel = 0
	LogoImg.Size = UDim2.new(0, 22, 0, 22)
	LogoImg.Position = UDim2.new(0, 8, 0.5, -11)
	LogoImg.ScaleType = Enum.ScaleType.Fit
	LogoImg.Name = "LogoImg"
	LogoImg.Parent = Top

    UICorner1.Parent = Top

    local RightContainer = Instance.new("Frame")
    RightContainer.Name = "RightContainer"
    RightContainer.BackgroundTransparency = 1
    RightContainer.Size = UDim2.new(0.6, 0, 1, 0)
    RightContainer.Position = UDim2.new(1, -110, 0, 0)
    RightContainer.AnchorPoint = Vector2.new(1, 0)
    RightContainer.Parent = Top

    local TopListLayout = Instance.new("UIListLayout")
    TopListLayout.FillDirection = Enum.FillDirection.Horizontal
    TopListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    TopListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TopListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TopListLayout.Padding = UDim.new(0, 8)
    TopListLayout.Parent = RightContainer

    local function styleStatusChip(frame, order)
        frame.LayoutOrder = order
        frame.Size = UDim2.new(0, 0, 0, 20)
        frame.BackgroundColor3 = Color3.fromRGB(10, 40, 29)
        frame.BackgroundTransparency = 0
        frame.BorderSizePixel = 0
        frame.AutomaticSize = Enum.AutomaticSize.X
        frame.Parent = RightContainer

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 7)
        padding.PaddingRight = UDim.new(0, 7)
        padding.Parent = frame

        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 5)
        layout.Parent = frame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = frame

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(34, 91, 68)
        stroke.Transparency = 0.18
        stroke.Thickness = 1
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = frame
    end

    local function makeChipIcon(parent, image, order)
        local icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.LayoutOrder = order
        icon.Size = UDim2.fromOffset(12, 12)
        icon.BackgroundTransparency = 1
        icon.Image = image
        icon.ImageColor3 = Color3.fromRGB(151, 218, 184)
        icon.ImageTransparency = 0.08
        icon.ScaleType = Enum.ScaleType.Fit
        icon.Parent = parent
        return icon
    end

    local FooterFrame = Instance.new("Frame")
    FooterFrame.Name = "FooterFrame"
    styleStatusChip(FooterFrame, 1)
    makeChipIcon(FooterFrame, Icons.stat, 1)

    TextLabel1.Name = "FooterText"
    TextLabel1.LayoutOrder = 2
    TextLabel1.Size = UDim2.new(0, 0, 1, 0)
    TextLabel1.BackgroundTransparency = 1
    TextLabel1.Font = Enum.Font.GothamMedium
    TextLabel1.Text = "-- FPS"
    TextLabel1.TextColor3 = Color3.fromRGB(210, 232, 220)
    TextLabel1.TextSize = 10
    TextLabel1.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel1.AutomaticSize = Enum.AutomaticSize.X
    TextLabel1.Parent = FooterFrame

    local RunService = game:GetService("RunService")
    local fpsFrames, fpsElapsed, displayedFps = 0, 0, 60
    local fpsConnection
    fpsConnection = RunService.RenderStepped:Connect(function(deltaTime)
        fpsFrames = fpsFrames + 1
        fpsElapsed = fpsElapsed + deltaTime
        if fpsElapsed >= 0.5 then
            local currentFps = fpsFrames / fpsElapsed
            displayedFps = math.floor((displayedFps * 0.35) + (currentFps * 0.65) + 0.5)
            TextLabel1.Text = tostring(displayedFps) .. " FPS"
            fpsFrames, fpsElapsed = 0, 0
        end
    end)
    ZeroinOnTop.Destroying:Connect(function()
        if fpsConnection then fpsConnection:Disconnect() end
    end)

    local execName = tostring((identifyexecutor and identifyexecutor()) or "Unknown")
    execName = execName:gsub("%s*[Vv]ersion.*$", "")
    if #execName > 12 then execName = execName:sub(1, 11) .. "…" end

    local Executor = Instance.new("Frame")
    Executor.Name = "Executor"
    styleStatusChip(Executor, 2)
    makeChipIcon(Executor, Icons.plug, 1)

    local ExecutorTextLabel = Instance.new("TextLabel")
    ExecutorTextLabel.Name = "TextLabel"
    ExecutorTextLabel.LayoutOrder = 2
    ExecutorTextLabel.Size = UDim2.new(0, 0, 1, 0)
    ExecutorTextLabel.BackgroundTransparency = 1
    ExecutorTextLabel.Font = Enum.Font.GothamMedium
    ExecutorTextLabel.Text = execName
    ExecutorTextLabel.TextColor3 = Color3.fromRGB(190, 218, 202)
    ExecutorTextLabel.TextSize = 10
    ExecutorTextLabel.TextXAlignment = Enum.TextXAlignment.Center
    ExecutorTextLabel.AutomaticSize = Enum.AutomaticSize.X
    ExecutorTextLabel.Parent = Executor

    Close.Font = Enum.Font.SourceSans
    Close.Text = ""
    Close.TextColor3 = Color3.fromRGB(0, 0, 0)
    Close.TextSize = 14
    Close.AnchorPoint = Vector2.new(1, 0.5)
    Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Close.BackgroundTransparency = 0.9990000128746033
    Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Close.BorderSizePixel = 0
    Close.Position = UDim2.new(1, -8, 0.5, 0)
    Close.Size = UDim2.new(0, 25, 0, 25)
    Close.Name = "Close"
    Close.Parent = Top

    ImageLabel1.Image = "rbxassetid://9886659671"
    ImageLabel1.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel1.BackgroundTransparency = 0.9990000128746033
    ImageLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel1.BorderSizePixel = 0
    ImageLabel1.Position = UDim2.new(0.49, 0, 0.5, 0)
    ImageLabel1.Size = UDim2.new(1, -8, 1, -8)
    ImageLabel1.Parent = Close

    Min.Font = Enum.Font.SourceSans
    Min.Text = ""
    Min.TextColor3 = Color3.fromRGB(0, 0, 0)
    Min.TextSize = 14
    Min.AnchorPoint = Vector2.new(1, 0.5)
    Min.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Min.BackgroundTransparency = 0.9990000128746033
    Min.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Min.BorderSizePixel = 0
    Min.Position = UDim2.new(1, -68, 0.5, 0) --(1, -38, 0.5, 0)
    Min.Size = UDim2.new(0, 25, 0, 25)
    Min.Name = "Min"
    Min.Parent = Top

    ImageLabel2.Image = "rbxassetid://9886659276"
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel2.BackgroundTransparency = 0.9990000128746033
    ImageLabel2.ImageTransparency = 0.2
    ImageLabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel2.BorderSizePixel = 0
    ImageLabel2.Position = UDim2.new(0.5, 0, 0.5, 0)
    ImageLabel2.Size = UDim2.new(1, -9, 1, -9)
    ImageLabel2.Parent = Min

    FullScreen.Font = Enum.Font.SourceSans
    FullScreen.Text = ""
    FullScreen.TextColor3 = Color3.fromRGB(0, 0, 0)
    FullScreen.TextSize = 14
    FullScreen.AnchorPoint = Vector2.new(1, 0.5)
    FullScreen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    FullScreen.BackgroundTransparency = 0.9990000128746033
    FullScreen.BorderColor3 = Color3.fromRGB(0, 0, 0)
    FullScreen.BorderSizePixel = 0
    FullScreen.Position = UDim2.new(1, -38, 0.5, 0) --(1, -68, 0.5, 0)
    FullScreen.Size = UDim2.new(0, 25, 0, 25)
    FullScreen.Name = "FullScreen"
    FullScreen.Parent = Top

    ImageLabel3.Image = "rbxassetid://113480421738477" -- ganti dengan icon fullscreen sesuai assetid kamu
    ImageLabel3.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel3.BackgroundTransparency = 0.9990000128746033
    ImageLabel3.ImageTransparency = 0.2
    ImageLabel3.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel3.BorderSizePixel = 0
    ImageLabel3.Position = UDim2.new(0.5, 0, 0.5, 0)
    ImageLabel3.Size = UDim2.new(1, -9, 1, -9)
    ImageLabel3.Parent = FullScreen

    LayersTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LayersTab.BackgroundTransparency = 1
    LayersTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LayersTab.BorderSizePixel = 0
    -- Center the sidebar content between the window edge and divider.
    LayersTab.Position = UDim2.new(0, 8, 0, 50)
    -- Equal 8px gutters on both sides when Tab Width is 130.
    LayersTab.Size = UDim2.new(0, GuiConfig["Tab Width"] - 3, 1, -104)
    LayersTab.Name = "LayersTab"
    LayersTab.Parent = Main

    local TabDivider = Instance.new("Frame")
    TabDivider.Name = "TabDivider"
    TabDivider.AnchorPoint = Vector2.new(0, 0)
    TabDivider.BackgroundColor3 = ThemeColors.Border
    TabDivider.BackgroundTransparency = 0.65
    TabDivider.BorderSizePixel = 0
    TabDivider.Position = UDim2.new(0, GuiConfig["Tab Width"] + 13, 0, 38)
    TabDivider.Size = UDim2.new(0, 1, 1, -38)
    TabDivider.Parent = Main

    local SearchBarFrame = Instance.new("Frame")
    SearchBarFrame.Name = "SearchBarFrame"
    SearchBarFrame.Size = UDim2.new(1, 0, 0, 26)
    SearchBarFrame.Position = UDim2.new(0, 0, 0, 0)
    SearchBarFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SearchBarFrame.BackgroundTransparency = 0.93
    SearchBarFrame.Parent = LayersTab

    local SearchBarCorner = Instance.new("UICorner")
    SearchBarCorner.CornerRadius = UDim.new(0, 6)
    SearchBarCorner.Parent = SearchBarFrame

    local SearchBarStroke = Instance.new("UIStroke")
    SearchBarStroke.Thickness = 1
    SearchBarStroke.Transparency = 0.7
    SearchBarStroke.Color = GuiConfig.Color
    SearchBarStroke.Parent = SearchBarFrame

    local SearchBox = Instance.new("TextBox")
    SearchBox.Name = "SearchBox"
    SearchBox.BackgroundTransparency = 1
    SearchBox.Size = UDim2.new(1, -30, 1, 0)
    SearchBox.Position = UDim2.new(0, 24, 0, 0)
    SearchBox.TextSize = 11
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.Text = ""
    SearchBox.PlaceholderText = "Search..."
    SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    SearchBox.Parent = SearchBarFrame

    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.Name = "SearchIcon"
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Image = "rbxassetid://109869955247116"
    SearchIcon.AnchorPoint = Vector2.new(0, 0.5)
    SearchIcon.Position = UDim2.new(0, 7, 0.5, 0)
    SearchIcon.Size = UDim2.new(0, 13, 0, 13)
    SearchIcon.Parent = SearchBarFrame



    local DiscordUrl = "https://discord.gg/9snzkaGkRE"

    local DiscordCard = Instance.new("Frame")
    DiscordCard.Name = "DiscordCard"
    DiscordCard.BackgroundColor3 = Color3.fromRGB(10, 40, 29)
    DiscordCard.BackgroundTransparency = 0
    DiscordCard.BorderSizePixel = 0
    DiscordCard.Position = UDim2.new(0, 8, 1, -50)
    DiscordCard.Size = UDim2.new(0, GuiConfig["Tab Width"] - 3, 0, 40)
    DiscordCard.Parent = Main

    local DiscordCorner = Instance.new("UICorner")
    DiscordCorner.CornerRadius = UDim.new(0, 6)
    DiscordCorner.Parent = DiscordCard

    local DiscordStroke = Instance.new("UIStroke")
    DiscordStroke.Name = "Outline"
    DiscordStroke.Color = Color3.fromRGB(34, 91, 68)
    DiscordStroke.Transparency = 0.35
    DiscordStroke.Thickness = 1
    DiscordStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    DiscordStroke.Parent = DiscordCard

    local DiscordIcon = Instance.new("ImageLabel")
    DiscordIcon.Name = "DiscordIcon"
    DiscordIcon.BackgroundTransparency = 1
    DiscordIcon.Image = Icons.discord
    DiscordIcon.ImageColor3 = Color3.fromRGB(190, 218, 202)
    DiscordIcon.ImageTransparency = 0.08
    DiscordIcon.Position = UDim2.new(0, 8, 0.5, -8)
    DiscordIcon.Size = UDim2.fromOffset(16, 16)
    DiscordIcon.ScaleType = Enum.ScaleType.Fit
    DiscordIcon.Parent = DiscordCard

    local DiscordTitle = Instance.new("TextLabel")
    DiscordTitle.Name = "Title"
    DiscordTitle.BackgroundTransparency = 1
    DiscordTitle.Font = Enum.Font.GothamBold
    DiscordTitle.Text = "Discord"
    DiscordTitle.TextColor3 = Color3.fromRGB(225, 238, 231)
    DiscordTitle.TextSize = 11
    DiscordTitle.TextXAlignment = Enum.TextXAlignment.Left
    DiscordTitle.Position = UDim2.new(0, 31, 0, 4)
    DiscordTitle.Size = UDim2.new(1, -37, 0, 14)
    DiscordTitle.Parent = DiscordCard

    local DiscordLink = Instance.new("TextLabel")
    DiscordLink.Name = "Link"
    DiscordLink.BackgroundTransparency = 1
    DiscordLink.Font = Enum.Font.GothamMedium
    DiscordLink.Text = "discord.gg/9snzkaGkRE"
    DiscordLink.TextColor3 = Color3.fromRGB(151, 190, 169)
    DiscordLink.TextSize = 8
    DiscordLink.TextTruncate = Enum.TextTruncate.AtEnd
    DiscordLink.TextXAlignment = Enum.TextXAlignment.Left
    DiscordLink.Position = UDim2.new(0, 31, 0, 18)
    DiscordLink.Size = UDim2.new(1, -37, 0, 12)
    DiscordLink.Parent = DiscordCard

    local DiscordButton = Instance.new("TextButton")
    DiscordButton.Name = "CopyButton"
    DiscordButton.BackgroundTransparency = 1
    DiscordButton.Text = ""
    DiscordButton.Size = UDim2.fromScale(1, 1)
    DiscordButton.ZIndex = 4
    DiscordButton.Parent = DiscordCard

    DiscordButton.Activated:Connect(function()
        CircleClick(DiscordButton, Mouse.X, Mouse.Y)
        if setclipboard then
            local ok = pcall(setclipboard, DiscordUrl)
            if ok then
                notif("Discord invite copied to clipboard!", 3, GuiConfig.Color, "Zeroin", "Discord")
            else
                notif("Failed to copy Discord invite.", 3, Color3.fromRGB(220, 90, 90), "Zeroin", "Discord")
            end
        else
            notif("Clipboard is not supported by this executor.", 3, Color3.fromRGB(220, 170, 80), "Zeroin", "Discord")
        end
    end)

    UICorner2.CornerRadius = UDim.new(0, 2)
    UICorner2.Parent = LayersTab

    DecideFrame.AnchorPoint = Vector2.new(0.5, 0)
    DecideFrame.BackgroundColor3 = ThemeColors.Border
    DecideFrame.BackgroundTransparency = 0.65
    DecideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DecideFrame.BorderSizePixel = 0
    DecideFrame.Position = UDim2.new(0.5, 0, 0, 38)
    DecideFrame.Size = UDim2.new(1, 0, 0, 1)
    DecideFrame.Name = "DecideFrame"
    DecideFrame.Parent = Main

    Layers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Layers.BackgroundTransparency = 0.9990000128746033
    Layers.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Layers.BorderSizePixel = 0
    Layers.Position = UDim2.new(0, GuiConfig["Tab Width"] + 18, 0, 50)
    Layers.Size = UDim2.new(1, -(GuiConfig["Tab Width"] + 9 + 18), 1, -59)
    Layers.Name = "Layers"
    Layers.Parent = Main

    UICorner6.CornerRadius = UDim.new(0, 2)
    UICorner6.Parent = Layers

	local WindowImg1 = Instance.new("ImageLabel")
	WindowImg1.Image = resolveImage(GuiConfig.LogoHUB)
	WindowImg1.BackgroundTransparency = 1
	WindowImg1.ImageTransparency = 0.8
	WindowImg1.BorderSizePixel = 0
	WindowImg1.Size = UDim2.new(0.5, 0, 0.9, 0)
	WindowImg1.Position = UDim2.new(0, 0, 0.1, 0)
	WindowImg1.ScaleType = Enum.ScaleType.Fit
	WindowImg1.Name = "WindowImg1"
	WindowImg1.ZIndex = -1
	WindowImg1.Parent = Layers
    WindowImg1.Visible = false

	local WindowImg2 = Instance.new("ImageLabel")
	WindowImg2.Image = resolveImage(GuiConfig.WindowIMG)
	WindowImg2.BackgroundTransparency = 1
	WindowImg2.ImageTransparency = 0.8
	WindowImg2.BorderSizePixel = 0
    WindowImg2.AnchorPoint = Vector2.new(0.5, 0.5)
	WindowImg2.Size = UDim2.new(0.78, 0, 0.94, 0)
	WindowImg2.Position = UDim2.new(0.5, 0, 0.5, 0)
	WindowImg2.ScaleType = Enum.ScaleType.Fit
	WindowImg2.Name = "WindowImg2"
	WindowImg2.ZIndex = 0
	WindowImg2.Parent = Layers
    WindowImg2.Visible = true

    -- NameTab.Font = Enum.Font.GothamBold
    -- NameTab.Text = ""
    -- NameTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    -- NameTab.TextSize = 24
    -- NameTab.TextWrapped = true
    -- NameTab.TextXAlignment = Enum.TextXAlignment.Left
    -- NameTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    -- NameTab.BackgroundTransparency = 0.9990000128746033
    -- NameTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
    -- NameTab.BorderSizePixel = 0
    -- NameTab.Size = UDim2.new(1, 0, 0, 30)
    -- NameTab.Name = "NameTab"
    -- NameTab.Parent = Layers

    LayersReal.AnchorPoint = Vector2.new(0, 1)
    LayersReal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LayersReal.BackgroundTransparency = 0.9990000128746033
    LayersReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LayersReal.BorderSizePixel = 0
    LayersReal.ClipsDescendants = true
    LayersReal.Position = UDim2.new(0, 0, 1, 0)
    LayersReal.Size = UDim2.new(1, 0, 1, 0)
    LayersReal.Name = "LayersReal"
    LayersReal.Parent = Layers

    LayersFolder.Name = "LayersFolder"
    LayersFolder.Parent = LayersReal

    LayersPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LayersPageLayout.Name = "LayersPageLayout"
    LayersPageLayout.Parent = LayersFolder
    LayersPageLayout.TweenTime = 0.5
    LayersPageLayout.EasingDirection = Enum.EasingDirection.InOut
    LayersPageLayout.EasingStyle = Enum.EasingStyle.Quad

    local ScrollTab = Instance.new("ScrollingFrame");
    local UIListLayout = Instance.new("UIListLayout");

    ScrollTab.CanvasSize = UDim2.new(0, 0, 1.10000002, 0)
    ScrollTab.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
    ScrollTab.ScrollBarThickness = 0
    ScrollTab.Active = true
    ScrollTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ScrollTab.BackgroundTransparency = 0.9990000128746033
    ScrollTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ScrollTab.BorderSizePixel = 0
    ScrollTab.Size = UDim2.new(1, 0, 1, -36)
	ScrollTab.Position = UDim2.new(0, 0, 0, 36)
    ScrollTab.Name = "ScrollTab"
    ScrollTab.Parent = LayersTab

    UIListLayout.Padding = UDim.new(0, 3)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollTab

    local function UpdateSize1()
        local OffsetY = 0
        for _, child in ScrollTab:GetChildren() do
            if child.Name ~= "UIListLayout" then
                OffsetY = OffsetY + 3 + child.Size.Y.Offset
            end
        end
        ScrollTab.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
    end
    ScrollTab.ChildAdded:Connect(UpdateSize1)
    ScrollTab.ChildRemoved:Connect(UpdateSize1)

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(SearchBox.Text)
        local jumpedToTab = false
        for _, scrolLayers in pairs(LayersFolder:GetChildren()) do
            if scrolLayers:IsA("ScrollingFrame") and scrolLayers.Name == "ScrolLayers" then
                for _, section in pairs(scrolLayers:GetChildren()) do
                    if section.Name == "Section" then
                        local sectionAdd = section:FindFirstChild("SectionAdd")
                        local sectionReal = section:FindFirstChild("SectionReal")
                        if sectionAdd and sectionReal then
                            local sectionVisible = false
                            local searchableItems = {}
                            for _, descendant in ipairs(sectionAdd:GetDescendants()) do
                                if descendant:IsA("GuiObject") and descendant:GetAttribute("ZeroinSectionItem") then
                                    table.insert(searchableItems, descendant)
                                end
                            end

                            for _, item in ipairs(searchableItems) do
                                local match = query == ""
                                if not match then
                                    for _, desc in ipairs(item:GetDescendants()) do
                                        if desc:IsA("TextLabel") and (string.find(desc.Name, "Title") or string.find(desc.Name, "Text")) then
                                            local txt = string.lower(desc.Text)
                                            if string.find(txt, query, 1, true) then
                                                match = true
                                                if not jumpedToTab then
                                                    jumpedToTab = true
                                                    for _, sideTab in pairs(ScrollTab:GetChildren()) do
                                                        if sideTab.Name == "Tab" and sideTab.LayoutOrder == scrolLayers.LayoutOrder then
                                                            local selectEvt = sideTab:FindFirstChild("SelectEvent")
                                                            if selectEvt then selectEvt:Fire() end
                                                            break
                                                        end
                                                    end
                                                end
                                                break
                                            end
                                        end
                                    end
                                end
                                item.Visible = match
                                if match then sectionVisible = true end
                            end
                            if query ~= "" then
                                section.Visible = sectionVisible
                            else
                                section.Visible = true
                            end
                        end
                    end
                end
            end
        end
    end)

    function GuiFunc:DestroyGui()
        if CoreGui:FindFirstChild("ZeroinOnTop") then
            ZeroinOnTop:Destroy()
        end
    end

    -- Lightweight window minimize/restore animation. Only the root UIScale
    -- and root Position are animated, so descendants do not get individual
    -- tweens and the effect remains inexpensive on lower-end devices.
    local MinimizeScale = Instance.new("UIScale")
    MinimizeScale.Name = "MinimizeScale"
    MinimizeScale.Scale = 1
    MinimizeScale.Parent = DropShadowHolder

    local windowAnimationLocked = false
    local restorePosition = DropShadowHolder.Position
    local minimizeDuration = 0.2

    local function offsetPosition(position, yOffset)
        return UDim2.new(
            position.X.Scale,
            position.X.Offset,
            position.Y.Scale,
            position.Y.Offset + yOffset
        )
    end

    local function SetWindowVisible(visible)
        if windowAnimationLocked or not DropShadowHolder then return end
        if visible == DropShadowHolder.Visible and not windowAnimationLocked then return end

        windowAnimationLocked = true

        if visible then
            DropShadowHolder.Visible = true
            MinimizeScale.Scale = 0.88
            DropShadowHolder.Position = offsetPosition(restorePosition, 12)

            local scaleTween = TweenService:Create(
                MinimizeScale,
                TweenInfo.new(minimizeDuration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                { Scale = 1 }
            )
            local positionTween = TweenService:Create(
                DropShadowHolder,
                TweenInfo.new(minimizeDuration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                { Position = restorePosition }
            )
            scaleTween:Play()
            positionTween:Play()
            scaleTween.Completed:Once(function()
                MinimizeScale.Scale = 1
                DropShadowHolder.Position = restorePosition
                windowAnimationLocked = false
            end)
        else
            restorePosition = DropShadowHolder.Position
            local scaleTween = TweenService:Create(
                MinimizeScale,
                TweenInfo.new(minimizeDuration, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
                { Scale = 0.88 }
            )
            local positionTween = TweenService:Create(
                DropShadowHolder,
                TweenInfo.new(minimizeDuration, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
                { Position = offsetPosition(restorePosition, 12) }
            )
            scaleTween:Play()
            positionTween:Play()
            scaleTween.Completed:Once(function()
                DropShadowHolder.Visible = false
                DropShadowHolder.Position = restorePosition
                MinimizeScale.Scale = 1
                windowAnimationLocked = false
            end)
        end
    end

    local function ToggleWindowVisibility()
        SetWindowVisible(not DropShadowHolder.Visible)
    end

    Min.Activated:Connect(function()
        CircleClick(Min, Mouse.X, Mouse.Y)
        SetWindowVisible(false)
    end)
    Close.Activated:Connect(function()
        CircleClick(Close, Mouse.X, Mouse.Y)

        local Overlay = Instance.new("Frame")
        Overlay.Size = UDim2.new(1, 0, 1, 0)
        Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Overlay.BackgroundTransparency = 0.3
        Overlay.ZIndex = 50
        Overlay.Parent = DropShadowHolder

        local Dialog = Instance.new("ImageLabel")
        Dialog.Size = UDim2.new(0, 300, 0, 150)
        Dialog.Position = UDim2.new(0.5, -150, 0.5, -75)
        Dialog.Image = "rbxassetid://9542022979"
        Dialog.ImageTransparency = 0
        Dialog.BorderSizePixel = 0
        Dialog.ZIndex = 51
        Dialog.Parent = Overlay
        local UICorner = Instance.new("UICorner", Dialog)
        UICorner.CornerRadius = UDim.new(0, 8)

        local DialogGlow = Instance.new("Frame")
        DialogGlow.Size = UDim2.new(0, 310, 0, 160)
        DialogGlow.Position = UDim2.new(0.5, -155, 0.5, -80)
        DialogGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        DialogGlow.BackgroundTransparency = 0.75
        DialogGlow.BorderSizePixel = 0
        DialogGlow.ZIndex = 50
        DialogGlow.Parent = Overlay

        local GlowCorner = Instance.new("UICorner", DialogGlow)
        GlowCorner.CornerRadius = UDim.new(0, 10)

        local Gradient = Instance.new("UIGradient")
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 191, 255)),
            ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 140, 255)),
            ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 191, 255))
        })
        Gradient.Rotation = 90
        Gradient.Parent = DialogGlow

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 40)
        Title.Position = UDim2.new(0, 0, 0, 4)
        Title.BackgroundTransparency = 1
        Title.Font = Enum.Font.GothamBold
        Title.Text = "Zeroin Window"
        Title.TextSize = 22
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.ZIndex = 52
        Title.Parent = Dialog

        local Message = Instance.new("TextLabel")
        Message.Size = UDim2.new(1, -20, 0, 60)
        Message.Position = UDim2.new(0, 10, 0, 30)
        Message.BackgroundTransparency = 1
        Message.Font = Enum.Font.Gotham
        Message.Text = "Do you want to close this window?\nYou will not be able to open it again"
        Message.TextSize = 14
        Message.TextColor3 = Color3.fromRGB(200, 200, 200)
        Message.TextWrapped = true
        Message.ZIndex = 52
        Message.Parent = Dialog

        local Yes = Instance.new("TextButton")
        Yes.Size = UDim2.new(0.45, -10, 0, 35)
        Yes.Position = UDim2.new(0.05, 0, 1, -55)
        Yes.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Yes.BackgroundTransparency = 0.935
        Yes.Text = "Yes"
        Yes.Font = Enum.Font.GothamBold
        Yes.TextSize = 15
        Yes.TextColor3 = Color3.fromRGB(255, 255, 255)
        Yes.TextTransparency = 0.3
        Yes.ZIndex = 52
        Yes.Name = "Yes"
        Yes.Parent = Dialog
        Instance.new("UICorner", Yes).CornerRadius = UDim.new(0, 6)

        local Cancel = Instance.new("TextButton")
        Cancel.Size = UDim2.new(0.45, -10, 0, 35)
        Cancel.Position = UDim2.new(0.5, 10, 1, -55)
        Cancel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Cancel.BackgroundTransparency = 0.935
        Cancel.Text = "Cancel"
        Cancel.Font = Enum.Font.GothamBold
        Cancel.TextSize = 15
        Cancel.TextColor3 = Color3.fromRGB(255, 255, 255)
        Cancel.TextTransparency = 0.3
        Cancel.ZIndex = 52
        Cancel.Name = "Cancel"
        Cancel.Parent = Dialog
        Instance.new("UICorner", Cancel).CornerRadius = UDim.new(0, 6)

        Yes.MouseButton1Click:Connect(function()
            if ZeroinOnTop then ZeroinOnTop:Destroy() end
            if game.CoreGui:FindFirstChild("ToggleUIZeroin") then
                game.CoreGui.ToggleUIZeroin:Destroy()
            end
        end)

        Cancel.MouseButton1Click:Connect(function()
            Overlay:Destroy()
        end)
    end)

    local ToggleKey = Enum.KeyCode.F3
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == ToggleKey then
            ToggleWindowVisibility()
        end
    end)

    function GuiFunc:ToggleUI()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Parent = game:GetService("CoreGui")
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.Name = "ToggleUIZeroin"

        local MainButton = Instance.new("ImageLabel")
        MainButton.Parent = ScreenGui
        MainButton.Size = UDim2.new(0, 40, 0, 40)
        MainButton.Position = UDim2.new(0, 20, 0, 150)
        MainButton.BackgroundTransparency = 1
        MainButton.Image = resolveImage(GuiConfig.Image or GuiConfig.LogoHUB)
        MainButton.ScaleType = Enum.ScaleType.Fit

        local ToggleUIStroke = Instance.new("UIStroke")
        ToggleUIStroke.Color = ThemeColors.Border
        ToggleUIStroke.Thickness = 1.2
        ToggleUIStroke.Transparency = 0.18
        ToggleUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ToggleUIStroke.Parent = MainButton

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 6)
        UICorner.Parent = MainButton

        local Button = Instance.new("TextButton")
        Button.Parent = MainButton
        Button.Size = UDim2.new(1, 0, 1, 0)
        Button.BackgroundTransparency = 1
        Button.Text = ""

        Button.MouseButton1Click:Connect(function()
            ToggleWindowVisibility()
        end)

        local dragging = false
        local dragStart, startPos

        local function update(input)
            local delta = input.Position - dragStart
            MainButton.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end

        Button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = MainButton.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)
    end

    GuiFunc:ToggleUI()

    DropShadowHolder.Size = UDim2.new(0, 115 + TextLabel.TextBounds.X + 1 + TextLabel1.TextBounds.X, 0, 350)
    MakeDraggable(Top, DropShadowHolder)
    local isFullscreen = false
    local originalSize = DropShadowHolder.Size
    local originalPos  = DropShadowHolder.Position

    FullScreen.Activated:Connect(function()
        CircleClick(FullScreen, Mouse.X, Mouse.Y)
        isFullscreen = not isFullscreen

        if isFullscreen then
            -- simpan size & pos sebelum fullscreen
            originalSize = DropShadowHolder.Size
            originalPos  = DropShadowHolder.Position

            TweenService:Create(DropShadowHolder, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size     = UDim2.new(0.980000019, 0, 0.949999988, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
            }):Play()
        else
            TweenService:Create(DropShadowHolder, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size     = originalSize,
                Position = originalPos,
            }):Play()
        end
    end)

    local MoreBlur = Instance.new("Frame");
    local DropShadowHolder1 = Instance.new("Frame");
    local DropShadow1 = Instance.new("ImageLabel");
    local UICorner28 = Instance.new("UICorner");
    local ConnectButton = Instance.new("TextButton");

    MoreBlur.AnchorPoint = Vector2.new(1, 1)
    MoreBlur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MoreBlur.BackgroundTransparency = 0.999
    MoreBlur.BorderColor3 = Color3.fromRGB(0, 0, 0)
    MoreBlur.BorderSizePixel = 0
    MoreBlur.ClipsDescendants = true
    MoreBlur.Position = UDim2.new(1, 8, 1, 8)
    MoreBlur.Size = UDim2.new(1, 154, 1, 54)
    MoreBlur.Visible = false
    MoreBlur.Name = "MoreBlur"
    MoreBlur.Parent = Layers

    DropShadowHolder1.BackgroundTransparency = 1
    DropShadowHolder1.BorderSizePixel = 0
    DropShadowHolder1.Size = UDim2.new(1, 0, 1, 0)
    DropShadowHolder1.ZIndex = 0
    DropShadowHolder1.Name = "DropShadowHolder"
    DropShadowHolder1.Parent = MoreBlur

    DropShadow1.Image = "rbxassetid://6015897843"
    DropShadow1.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow1.ImageTransparency = 1
    DropShadow1.ScaleType = Enum.ScaleType.Slice
    DropShadow1.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow1.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow1.BackgroundTransparency = 1
    DropShadow1.BorderSizePixel = 0
    DropShadow1.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow1.Size = UDim2.new(1, 35, 1, 35)
    DropShadow1.ZIndex = 0
    DropShadow1.Name = "DropShadow"
    DropShadow1.Parent = DropShadowHolder1

    UICorner28.Parent = MoreBlur

    ConnectButton.Font = Enum.Font.SourceSans
    ConnectButton.Text = ""
    ConnectButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    ConnectButton.TextSize = 14
    ConnectButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ConnectButton.BackgroundTransparency = 0.999
    ConnectButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ConnectButton.BorderSizePixel = 0
    ConnectButton.Size = UDim2.new(1, 0, 1, 0)
    ConnectButton.Name = "ConnectButton"
    ConnectButton.Parent = MoreBlur

    local DropdownSelect = Instance.new("Frame");
    local UICorner36 = Instance.new("UICorner");
    local UIStroke14 = Instance.new("UIStroke");
    local DropdownSelectReal = Instance.new("Frame");
    local DropdownFolder = Instance.new("Folder");
    local DropPageLayout = Instance.new("UIPageLayout");

    DropdownSelect.AnchorPoint = Vector2.new(1, 0.5)
    DropdownSelect.BackgroundColor3 = Color3.fromRGB(30.00000011175871, 30.00000011175871, 30.00000011175871)
    DropdownSelect.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownSelect.BorderSizePixel = 0
    DropdownSelect.LayoutOrder = 1
    DropdownSelect.Position = UDim2.new(1, 172, 0.5, 0)
    DropdownSelect.Size = UDim2.new(0, 160, 1, -16)
    DropdownSelect.Name = "DropdownSelect"
    DropdownSelect.ClipsDescendants = true
    DropdownSelect.Parent = MoreBlur

    ConnectButton.Activated:Connect(function()
        if MoreBlur.Visible then
            TweenService:Create(MoreBlur, TweenInfo.new(0.3), { BackgroundTransparency = 0.999 }):Play()
            TweenService:Create(DropdownSelect, TweenInfo.new(0.3), { Position = UDim2.new(1, 172, 0.5, 0) }):Play()
            task.wait(0.3)
            MoreBlur.Visible = false
        end
    end)
    UICorner36.CornerRadius = UDim.new(0, 3)
    UICorner36.Parent = DropdownSelect

    UIStroke14.Color = Color3.fromRGB(12, 159, 255)
    UIStroke14.Thickness = 2.5
    UIStroke14.Transparency = 0.8
    UIStroke14.Parent = DropdownSelect

    DropdownSelectReal.AnchorPoint = Vector2.new(0.5, 0.5)
    DropdownSelectReal.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Latar Warna Dropdown
    DropdownSelectReal.BackgroundTransparency = 0.7
    DropdownSelectReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownSelectReal.BorderSizePixel = 0
    DropdownSelectReal.LayoutOrder = 1
    DropdownSelectReal.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropdownSelectReal.Size = UDim2.new(1, 1, 1, 1)
    DropdownSelectReal.Name = "DropdownSelectReal"
    DropdownSelectReal.Parent = DropdownSelect

    DropdownFolder.Name = "DropdownFolder"
    DropdownFolder.Parent = DropdownSelectReal

    DropPageLayout.EasingDirection = Enum.EasingDirection.InOut
    DropPageLayout.EasingStyle = Enum.EasingStyle.Quad
    DropPageLayout.TweenTime = 0.009999999776482582
    DropPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    DropPageLayout.FillDirection = Enum.FillDirection.Vertical
    DropPageLayout.Archivable = false
    DropPageLayout.Name = "DropPageLayout"
    DropPageLayout.Parent = DropdownFolder
    --// Tabs
    local Tabs = {}
    local CountTab = 0
    local CountDropdown = 0
    local PageTransitionToken = 0

    local function SetSectionArrowsVisible(visible)
        for _, descendant in ipairs(LayersFolder:GetDescendants()) do
            if descendant.Name == "FeatureImg" and descendant:IsA("ImageLabel") then
                descendant.Visible = visible
            end
        end
    end

    local function HideArrowsDuringPageTransition()
        PageTransitionToken = PageTransitionToken + 1
        local token = PageTransitionToken
        SetSectionArrowsVisible(false)
        task.delay(LayersPageLayout.TweenTime + 0.04, function()
            if token == PageTransitionToken then
                SetSectionArrowsVisible(true)
            end
        end)
    end
    function Tabs:AddTab(TabConfig)
        local TabConfig = TabConfig or {}
        TabConfig.Name = TabConfig.Name or "Tab"
        TabConfig.Icon = TabConfig.Icon or ""

        local ScrolLayers = Instance.new("ScrollingFrame");
        local UIListLayout1 = Instance.new("UIListLayout");

        ScrolLayers.ScrollBarImageColor3 = Color3.fromRGB(80.00000283122063, 80.00000283122063, 80.00000283122063)
        ScrolLayers.ScrollBarThickness = 0
        ScrolLayers.Active = true
        ScrolLayers.LayoutOrder = CountTab
        ScrolLayers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ScrolLayers.BackgroundTransparency = 0.9990000128746033
        ScrolLayers.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ScrolLayers.BorderSizePixel = 0
        ScrolLayers.Size = UDim2.new(1, 0, 1, 0)
        ScrolLayers.Name = "ScrolLayers"
        ScrolLayers.Parent = LayersFolder

        UIListLayout1.Padding = UDim.new(0, 3)
        UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout1.Parent = ScrolLayers

        local Tab = Instance.new("Frame");
        local UICorner3 = Instance.new("UICorner");
        local TabButton = Instance.new("TextButton");
        local TabName = Instance.new("TextLabel")
        local TabIconImg
        local UIStroke2 = Instance.new("UIStroke");
        local UICorner4 = Instance.new("UICorner");

        Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        if CountTab == 0 then
            Tab.BackgroundTransparency = 0.9200000166893005
        else
            Tab.BackgroundTransparency = 0.9990000128746033
        end
        Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Tab.BorderSizePixel = 0
        Tab.LayoutOrder = CountTab
        Tab.Size = UDim2.new(1, 0, 0, 30)
        Tab.Name = "Tab"
        Tab.Parent = ScrollTab

        UICorner3.CornerRadius = UDim.new(0, 4)
        UICorner3.Parent = Tab

        TabButton.Font = Enum.Font.GothamBold
        TabButton.Text = ""
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 13
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundTransparency = 0.9990000128746033
        TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 1, 0)
        TabButton.Name = "TabButton"
        TabButton.Parent = Tab

        local textOffsetX = 8
        local TabIconNative

        local function makeLine(parent, size, position, rotation)
            local line = Instance.new("Frame")
            line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            line.BorderSizePixel = 0
            line.AnchorPoint = Vector2.new(0.5, 0.5)
            line.Size = size
            line.Position = position
            line.Rotation = rotation or 0
            line.Parent = parent
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = line
            return line
        end

        local function makeNativeLucideIcon(iconName)
            local icon = Instance.new("CanvasGroup")
            icon.Name = "TabIconNative"
            icon.Size = UDim2.fromOffset(14, 14)
            icon.Position = UDim2.new(0, 8, 0.5, 0)
            icon.AnchorPoint = Vector2.new(0, 0.5)
            icon.BackgroundTransparency = 1
            icon.GroupTransparency = CountTab == 0 and 0 or 0.4
            icon.Parent = Tab

            if iconName == "home" then
                -- Lucide Home: roof plus open rectangular body.
                makeLine(icon, UDim2.fromOffset(9, 2), UDim2.fromOffset(4.2, 4), -42)
                makeLine(icon, UDim2.fromOffset(9, 2), UDim2.fromOffset(9.8, 4), 42)
                makeLine(icon, UDim2.fromOffset(2, 7), UDim2.fromOffset(2.5, 9.5), 0)
                makeLine(icon, UDim2.fromOffset(2, 7), UDim2.fromOffset(11.5, 9.5), 0)
                makeLine(icon, UDim2.fromOffset(10, 2), UDim2.fromOffset(7, 13), 0)
            elseif iconName == "info" then
                -- Lucide CircleInfo: stroked circle, dot, and stem.
                local circle = Instance.new("Frame")
                circle.Name = "Circle"
                circle.AnchorPoint = Vector2.new(0.5, 0.5)
                circle.BackgroundTransparency = 1
                -- Keep the stroke inside the 14x14 CanvasGroup. A full 13px
                -- circle plus stroke was clipped by the CanvasGroup boundary.
                circle.Size = UDim2.fromOffset(11, 11)
                circle.Position = UDim2.fromOffset(7, 7)
                circle.Parent = icon
                local circleCorner = Instance.new("UICorner")
                circleCorner.CornerRadius = UDim.new(1, 0)
                circleCorner.Parent = circle
                local circleStroke = Instance.new("UIStroke")
                circleStroke.Color = Color3.fromRGB(255, 255, 255)
                circleStroke.Thickness = 1.25
                circleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                circleStroke.Parent = circle
                makeLine(icon, UDim2.fromOffset(1.8, 1.8), UDim2.fromOffset(7, 4.2), 0)
                makeLine(icon, UDim2.fromOffset(1.8, 5), UDim2.fromOffset(7, 9), 0)
            end

            return icon
        end

        if TabConfig.Icon and TabConfig.Icon ~= "" then
            if TabConfig.Icon == "home" or TabConfig.Icon == "info" then
                TabIconNative = makeNativeLucideIcon(TabConfig.Icon)
            else
                TabIconImg = Instance.new("ImageLabel")
                TabIconImg.Name = "TabIcon"
                TabIconImg.Size = UDim2.fromOffset(14, 14)
                TabIconImg.Position = UDim2.new(0, 8, 0.5, 0)
                TabIconImg.AnchorPoint = Vector2.new(0, 0.5)
                TabIconImg.BackgroundTransparency = 1
                if Icons and Icons[TabConfig.Icon] then
                    TabIconImg.Image = Icons[TabConfig.Icon]
                else
                    TabIconImg.Image = resolveImage(TabConfig.Icon)
                end
                TabIconImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
                TabIconImg.ImageTransparency = CountTab == 0 and 0 or 0.4
                TabIconImg.ScaleType = Enum.ScaleType.Fit
                TabIconImg.Parent = Tab
            end

            textOffsetX = 28
        end

        TabName.Font = Enum.Font.GothamMedium
        TabName.Text = tostring(TabConfig.Name)
        TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabName.TextSize = 12
        TabName.TextTransparency = CountTab == 0 and 0 or 0.4
        TabName.TextXAlignment = Enum.TextXAlignment.Left
        TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabName.BackgroundTransparency = 0.9990000128746033
        TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabName.BorderSizePixel = 0
        TabName.Size = UDim2.new(1, -textOffsetX, 1, 0)
        TabName.Position = UDim2.new(0, textOffsetX, 0, 0)
        TabName.Name = "TabName"
        TabName.Parent = Tab

        if CountTab == 0 then
            LayersPageLayout:JumpToIndex(0)
            NameTab.Text = TabConfig.Name
            local ChooseFrame = Instance.new("Frame");
            ChooseFrame.BackgroundColor3 = GuiConfig.Color
            ChooseFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ChooseFrame.BorderSizePixel = 0
            ChooseFrame.Position = UDim2.new(0, 2, 0, 9)
            ChooseFrame.Size = UDim2.new(0, 1, 0, 12)
            ChooseFrame.Name = "ChooseFrame"
            ChooseFrame.Parent = Tab

            UIStroke2.Color = GuiConfig.Color
            UIStroke2.Thickness = 1.600000023841858
            UIStroke2.Parent = ChooseFrame

            UICorner4.Parent = ChooseFrame
        end

        local SelectEvent = Instance.new("BindableEvent")
        SelectEvent.Name = "SelectEvent"
        SelectEvent.Parent = Tab

        TabButton.Activated:Connect(function()
            CircleClick(TabButton, Mouse.X, Mouse.Y)
            SelectEvent:Fire()
        end)

        SelectEvent.Event:Connect(function()
            local FrameChoose
            for a, s in ScrollTab:GetChildren() do
                for i, v in s:GetChildren() do
                    if v.Name == "ChooseFrame" then
                        FrameChoose = v
                        break
                    end
                end
            end
            if FrameChoose ~= nil and Tab.LayoutOrder ~= LayersPageLayout.CurrentPage.LayoutOrder then
                for _, TabFrame in ScrollTab:GetChildren() do
                    if TabFrame.Name == "Tab" then
                        TweenService:Create(
                            TabFrame,
                            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
                            { BackgroundTransparency = 0.9990000128746033 }
                        ):Play()
                        
                        local tIcon = TabFrame:FindFirstChild("TabIcon")
                        local tNativeIcon = TabFrame:FindFirstChild("TabIconNative")
                        local tName = TabFrame:FindFirstChild("TabName")
                        if tIcon then
                            TweenService:Create(tIcon, TweenInfo.new(0.3), { ImageTransparency = 0.4 }):Play()
                        end
                        if tNativeIcon then
                            TweenService:Create(tNativeIcon, TweenInfo.new(0.3), { GroupTransparency = 0.4 }):Play()
                        end
                        if tName then
                            TweenService:Create(tName, TweenInfo.new(0.3), { TextTransparency = 0.4 }):Play()
                        end
                    end
                end
                TweenService:Create(
                    Tab,
                    TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
                    { BackgroundTransparency = 0.9200000166893005 }
                ):Play()
                
                if TabIconImg then
                    TweenService:Create(TabIconImg, TweenInfo.new(0.6), { ImageTransparency = 0 }):Play()
                end
                if TabIconNative then
                    TweenService:Create(TabIconNative, TweenInfo.new(0.6), { GroupTransparency = 0 }):Play()
                end
                TweenService:Create(TabName, TweenInfo.new(0.6), { TextTransparency = 0 }):Play()

                TweenService:Create(
                    FrameChoose,
                    TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    { Position = UDim2.new(0, 2, 0, 9 + (33 * Tab.LayoutOrder)) }
                ):Play()
                HideArrowsDuringPageTransition()
                LayersPageLayout:JumpToIndex(Tab.LayoutOrder)
                task.wait(0.05)
                NameTab.Text = TabConfig.Name
                TweenService:Create(
                    FrameChoose,
                    TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    { Size = UDim2.new(0, 1, 0, 20) }
                ):Play()
                task.wait(0.2)
                TweenService:Create(
                    FrameChoose,
                    TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    { Size = UDim2.new(0, 1, 0, 12) }
                ):Play()
            end
        end)
        --// Section
        local Sections = {}
        local CountSection = 0
        function Sections:AddSection(Title, AlwaysOpen)
            local Title = Title or "Title"

            -- Sections are intentionally always open. The second argument is
            -- retained only for backward API compatibility.
            local Section = Instance.new("Frame")
            Section.Name = "Section"
            Section.BackgroundTransparency = 1
            Section.BorderSizePixel = 0
            Section.ClipsDescendants = false
            Section.LayoutOrder = CountSection
            Section.Size = UDim2.new(1, 0, 0, 36)
            Section.Parent = ScrolLayers

            local SectionReal = Instance.new("Frame")
            SectionReal.Name = "SectionReal"
            SectionReal.BackgroundTransparency = 1
            SectionReal.BorderSizePixel = 0
            SectionReal.Position = UDim2.fromOffset(0, 0)
            SectionReal.Size = UDim2.new(1, 0, 0, 27)
            SectionReal.Parent = Section

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "SectionTitle"
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = Title
            SectionTitle.TextColor3 = Color3.fromRGB(225, 238, 231)
            SectionTitle.TextSize = 13
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.TextYAlignment = Enum.TextYAlignment.Top
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.fromOffset(6, 0)
            SectionTitle.Size = UDim2.new(1, -12, 0, 18)
            SectionTitle.Parent = SectionReal

            local SectionAdd = Instance.new("Frame")
            SectionAdd.Name = "SectionAdd"
            SectionAdd.BackgroundColor3 = Color3.fromRGB(10, 40, 29)
            SectionAdd.BackgroundTransparency = 0.28
            SectionAdd.BorderSizePixel = 0
            SectionAdd.ClipsDescendants = true
            -- 2px inset keeps the Border stroke visible on both sides.
            SectionAdd.Position = UDim2.fromOffset(2, 27)
            SectionAdd.Size = UDim2.new(1, -4, 0, 0)
            SectionAdd.Parent = Section

            local SectionAddCorner = Instance.new("UICorner")
            SectionAddCorner.CornerRadius = UDim.new(0, 6)
            SectionAddCorner.Parent = SectionAdd

            -- Popup portal for dropdown menus. It lives at section level so
            -- buttons outside a 46px dropdown row remain hit-testable, while
            -- still moving together with the section when the page scrolls.
            local SectionOverlay = Instance.new("Frame")
            SectionOverlay.Name = "SectionOverlay"
            SectionOverlay.BackgroundTransparency = 1
            SectionOverlay.BorderSizePixel = 0
            SectionOverlay.Position = SectionAdd.Position
            SectionOverlay.Size = SectionAdd.Size
            SectionOverlay.Active = false
            SectionOverlay.ZIndex = 80
            SectionOverlay.Parent = Section

            local SectionAddStroke = Instance.new("UIStroke")
            SectionAddStroke.Name = "SectionOutline"
            SectionAddStroke.Color = Color3.fromRGB(34, 91, 68)
            SectionAddStroke.Transparency = 0.22
            SectionAddStroke.Thickness = 1
            SectionAddStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            SectionAddStroke.Parent = SectionAdd

            local RowsLayout = Instance.new("UIListLayout")
            RowsLayout.Name = "RowsLayout"
            RowsLayout.Padding = UDim.new(0, 4)
            RowsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            RowsLayout.Parent = SectionAdd

            local UIPadding = Instance.new("UIPadding")
            UIPadding.PaddingTop = UDim.new(0, 6)
            UIPadding.PaddingBottom = UDim.new(0, 10)
            UIPadding.PaddingLeft = UDim.new(0, 8)
            UIPadding.PaddingRight = UDim.new(0, 8)
            UIPadding.Parent = SectionAdd

            local function UpdateSizeScroll()
                local layout = ScrolLayers:FindFirstChildOfClass("UIListLayout")
                if layout then
                    ScrolLayers.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
                end
            end

            local function UpdateSizeSection()
                local contentHeight = RowsLayout.AbsoluteContentSize.Y + 16 -- account for top/bottom padding
                SectionAdd.Size = UDim2.new(1, -4, 0, contentHeight)
                SectionOverlay.Position = SectionAdd.Position
                SectionOverlay.Size = SectionAdd.Size
                Section.Size = UDim2.new(1, 0, 0, 27 + contentHeight)
                task.defer(UpdateSizeScroll)
            end

            RowsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSizeSection)

            local NextItem = 0
            local PendingRow

            local function updateRowHeight(row)
                if not row then return end
                local leftCell = row:FindFirstChild("LeftCell")
                local rightCell = row:FindFirstChild("RightCell")
                local fullCell = row:FindFirstChild("FullCell")
                local function cellHeight(cell)
                    if not cell then return 0 end
                    local item = cell:FindFirstChildWhichIsA("GuiObject")
                    return (item and item.Visible) and item.Size.Y.Offset or 0
                end
                local height
                if fullCell then
                    height = cellHeight(fullCell)
                    fullCell.Size = UDim2.new(1, 0, 0, height)
                else
                    local leftHeight = cellHeight(leftCell)
                    local rightHeight = cellHeight(rightCell)
                    height = math.max(leftHeight, rightHeight)
                    if leftCell then leftCell.Size = UDim2.new(0.5, -3, 0, height) end
                    if rightCell then rightCell.Size = UDim2.new(0.5, -3, 0, height) end
                end
                row.Size = UDim2.new(1, 0, 0, height)
                task.defer(UpdateSizeSection)
            end

            local function makeRow(order)
                local row = Instance.new("Frame")
                row.Name = "SectionRow"
                row.BackgroundTransparency = 1
                row.BorderSizePixel = 0
                row.LayoutOrder = order
                row.Size = UDim2.new(1, 0, 0, 0)
                row.Parent = SectionAdd
                return row
            end

            local function MountSectionItem(item, fullWidth)
                local row, cell, column

                if fullWidth then
                    -- Finish a pending half-row, then mount this item alone.
                    if NextItem % 2 == 1 then NextItem = NextItem + 1 end
                    row = makeRow(math.floor(NextItem / 2))
                    cell = Instance.new("Frame")
                    cell.Name = "FullCell"
                    cell.Position = UDim2.fromOffset(0, 0)
                    cell.Size = UDim2.new(1, 0, 0, item.Size.Y.Offset)
                    column = "Full"
                    NextItem = NextItem + 2
                    PendingRow = nil
                else
                    local isLeft = NextItem % 2 == 0
                    row = isLeft and makeRow(math.floor(NextItem / 2)) or PendingRow
                    if isLeft then PendingRow = row end
                    cell = Instance.new("Frame")
                    cell.Name = isLeft and "LeftCell" or "RightCell"
                    cell.Position = isLeft and UDim2.fromOffset(0, 0) or UDim2.new(0.5, 3, 0, 0)
                    cell.Size = UDim2.new(0.5, -3, 0, item.Size.Y.Offset)
                    column = isLeft and "Left" or "Right"
                    NextItem = NextItem + 1
                end

                cell.BackgroundTransparency = 1
                cell.BorderSizePixel = 0
                cell.Parent = row

                item:SetAttribute("ZeroinSectionItem", true)
                item:SetAttribute("ZeroinColumn", column)
                item.LayoutOrder = 0
                item.AnchorPoint = Vector2.zero
                item.Position = UDim2.fromOffset(0, 0)
                item.Size = UDim2.new(1, 0, item.Size.Y.Scale, item.Size.Y.Offset)
                item.BackgroundTransparency = 1
                item.BorderSizePixel = 0
                item.Parent = cell

                local function refresh()
                    updateRowHeight(row)
                end
                item:GetPropertyChangedSignal("Size"):Connect(refresh)
                item:GetPropertyChangedSignal("Visible"):Connect(refresh)
                task.defer(refresh)
            end

            local layout = ScrolLayers:FindFirstChildOfClass("UIListLayout")
            if layout then
                layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSizeScroll)
            end

            local Items = {}
            local CountItem = 0

            function Items:AddParagraph(ParagraphConfig)
                local ParagraphConfig = ParagraphConfig or {}
                ParagraphConfig.Title = ParagraphConfig.Title or "Title"
                ParagraphConfig.Content = ParagraphConfig.Content or "Content"
                local ParagraphFunc = {}

                local Paragraph = Instance.new("Frame")
                local UICorner14 = Instance.new("UICorner")
                local ParagraphTitle = Instance.new("TextLabel")
                local ParagraphContent = Instance.new("TextLabel")

                Paragraph.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Paragraph.BackgroundTransparency = 0.935
                Paragraph.BorderSizePixel = 0
                Paragraph.LayoutOrder = CountItem
                Paragraph.Size = UDim2.new(1, 0, 0, 46)
                Paragraph.Name = "Paragraph"
                MountSectionItem(Paragraph, ParagraphConfig.FullWidth ~= false)

                UICorner14.CornerRadius = UDim.new(0, 4)
                UICorner14.Parent = Paragraph

                local iconOffset = 10
                if ParagraphConfig.Icon then
                    local IconImg = Instance.new("ImageLabel")
                    IconImg.Size = UDim2.new(0, 20, 0, 20)
                    IconImg.Position = UDim2.new(0, 8, 0, 12)
                    IconImg.BackgroundTransparency = 1
                    IconImg.Name = "ParagraphIcon"
                    IconImg.Parent = Paragraph

                    if Icons and Icons[ParagraphConfig.Icon] then
                        IconImg.Image = Icons[ParagraphConfig.Icon]
                    else
                        IconImg.Image = ParagraphConfig.Icon
                    end

                    iconOffset = 30
                end

                ParagraphTitle.Font = Enum.Font.GothamBold
                ParagraphTitle.Text = ParagraphConfig.Title
                ParagraphTitle.TextColor3 = Color3.fromRGB(231, 231, 231)
                ParagraphTitle.TextSize = 13
                ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
                ParagraphTitle.TextYAlignment = Enum.TextYAlignment.Top
                ParagraphTitle.BackgroundTransparency = 1
                ParagraphTitle.Position = UDim2.new(0, iconOffset, 0, 10)
                ParagraphTitle.Size = UDim2.new(1, -(iconOffset + 8), 0, 13)
                ParagraphTitle.Name = "ParagraphTitle"
                ParagraphTitle.Parent = Paragraph

                ParagraphContent.Font = Enum.Font.Gotham
                ParagraphContent.Text = ParagraphConfig.Content
                ParagraphContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                ParagraphContent.TextSize = 12
                ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
                ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
                ParagraphContent.BackgroundTransparency = 1
                ParagraphContent.Position = UDim2.new(0, iconOffset, 0, 25)
                ParagraphContent.Name = "ParagraphContent"
                ParagraphContent.TextWrapped = false
                ParagraphContent.RichText = true
                ParagraphContent.Parent = Paragraph

                ParagraphContent.Size = UDim2.new(1, -(iconOffset + 8), 0, ParagraphContent.TextBounds.Y)

                local ParagraphButton
                if ParagraphConfig.ButtonText then
                    ParagraphButton = Instance.new("TextButton")
                    ParagraphButton.Position = UDim2.new(0, 10, 0, 42)
                    ParagraphButton.Size = UDim2.new(1, -22, 0, 28)
                    ParagraphButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    ParagraphButton.BackgroundTransparency = 0.935
                    ParagraphButton.Font = Enum.Font.GothamBold
                    ParagraphButton.TextSize = 12
                    ParagraphButton.TextTransparency = 0.3
                    ParagraphButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ParagraphButton.Text = ParagraphConfig.ButtonText
                    ParagraphButton.Parent = Paragraph

                    local btnCorner = Instance.new("UICorner")
                    btnCorner.CornerRadius = UDim.new(0, 6)
                    btnCorner.Parent = ParagraphButton

                    if ParagraphConfig.ButtonCallback then
                        ParagraphButton.MouseButton1Click:Connect(ParagraphConfig.ButtonCallback)
                    end
                end

                local function UpdateSize()
                    local totalHeight = ParagraphContent.TextBounds.Y + 33
                    if ParagraphButton then
                        totalHeight = totalHeight + ParagraphButton.Size.Y.Offset + 5
                    end
                    Paragraph.Size = UDim2.new(1, 0, 0, totalHeight)
                end

                UpdateSize()

                ParagraphContent:GetPropertyChangedSignal("TextBounds"):Connect(UpdateSize)

                function ParagraphFunc:SetContent(content)
                    content = content or "Content"
                    ParagraphContent.Text = content
                    UpdateSize()
                end

                function ParagraphFunc:SetTitle(title)
                    ParagraphTitle.Text = title or "Title"
                end

                ParagraphFunc.Frame = Paragraph
                CountItem = CountItem + 1
                return ParagraphFunc
            end

            function Items:AddPanel(PanelConfig)
                PanelConfig = PanelConfig or {}
                PanelConfig.Title = PanelConfig.Title or "Title"
                PanelConfig.Content = PanelConfig.Content or ""
                PanelConfig.Placeholder = PanelConfig.Placeholder or nil
                PanelConfig.Default = PanelConfig.Default or ""
                PanelConfig.ButtonText = PanelConfig.Button or PanelConfig.ButtonText or "Confirm"
                PanelConfig.ButtonCallback = PanelConfig.Callback or PanelConfig.ButtonCallback or function() end
                PanelConfig.SubButtonText = PanelConfig.SubButton or PanelConfig.SubButtonText or nil
                PanelConfig.SubButtonCallback = PanelConfig.SubCallback or PanelConfig.SubButtonCallback or
                    function() end

                local configKey = "Panel_" .. PanelConfig.Title
                if ConfigData[configKey] ~= nil then
                    PanelConfig.Default = ConfigData[configKey]
                end

                local PanelFunc = { Value = PanelConfig.Default }

                local baseHeight = 50

                if PanelConfig.Placeholder then
                    baseHeight = baseHeight + 40
                end

                if PanelConfig.SubButtonText then
                    baseHeight = baseHeight + 40
                else
                    baseHeight = baseHeight + 36
                end

                local Panel = Instance.new("Frame")
                Panel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Panel.BackgroundTransparency = 0.935
                Panel.Size = UDim2.new(1, 0, 0, baseHeight)
                Panel.LayoutOrder = CountItem
                MountSectionItem(Panel, PanelConfig.FullWidth ~= false)

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = Panel

                local Title = Instance.new("TextLabel")
                Title.Font = Enum.Font.GothamBold
                Title.Text = PanelConfig.Title
                Title.TextSize = 13
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0, 10, 0, 10)
                Title.Size = UDim2.new(1, -20, 0, 13)
                Title.Parent = Panel

                local Content = Instance.new("TextLabel")
                Content.Font = Enum.Font.Gotham
                Content.Text = PanelConfig.Content
                Content.TextSize = 12
                Content.TextColor3 = Color3.fromRGB(255, 255, 255)
                Content.TextTransparency = 0
                Content.TextXAlignment = Enum.TextXAlignment.Left
                Content.BackgroundTransparency = 1
                Content.RichText = true
                Content.Position = UDim2.new(0, 10, 0, 28)
                Content.Size = UDim2.new(1, -20, 0, 14)
                Content.Parent = Panel

                local InputBox
                if PanelConfig.Placeholder then
                    local InputFrame = Instance.new("Frame")
                    InputFrame.AnchorPoint = Vector2.new(0.5, 0)
                    InputFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    InputFrame.BackgroundTransparency = 0.95
                    InputFrame.Position = UDim2.new(0.5, 0, 0, 48)
                    InputFrame.Size = UDim2.new(1, -20, 0, 30)
                    InputFrame.Parent = Panel

                    local inputCorner = Instance.new("UICorner")
                    inputCorner.CornerRadius = UDim.new(0, 4)
                    inputCorner.Parent = InputFrame

                    InputBox = Instance.new("TextBox")
                    InputBox.Font = Enum.Font.GothamBold
                    InputBox.PlaceholderText = PanelConfig.Placeholder
                    InputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
                    InputBox.Text = PanelConfig.Default
                    InputBox.TextSize = 11
                    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                    InputBox.BackgroundTransparency = 1
                    InputBox.TextXAlignment = Enum.TextXAlignment.Left
                    InputBox.Size = UDim2.new(1, -10, 1, -6)
                    InputBox.Position = UDim2.new(0, 5, 0, 3)
                    InputBox.Parent = InputFrame
                end

                local yBtn = 0
                if PanelConfig.Placeholder then
                    yBtn = 88
                else
                    yBtn = 48
                end

                local ButtonMain = Instance.new("TextButton")
                ButtonMain.Font = Enum.Font.GothamBold
                ButtonMain.Text = PanelConfig.ButtonText
                ButtonMain.TextColor3 = Color3.fromRGB(255, 255, 255)
                ButtonMain.TextSize = 12
                ButtonMain.TextTransparency = 0.3
                ButtonMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ButtonMain.BackgroundTransparency = 0.935
                ButtonMain.Size = PanelConfig.SubButtonText and UDim2.new(0.5, -12, 0, 30) or UDim2.new(1, -20, 0, 30)
                ButtonMain.Position = UDim2.new(0, 10, 0, yBtn)
                ButtonMain.Parent = Panel

                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 6)
                btnCorner.Parent = ButtonMain

                ButtonMain.MouseButton1Click:Connect(function()
                    PanelConfig.ButtonCallback(InputBox and InputBox.Text or "")
                end)

                if PanelConfig.SubButtonText then
                    local SubButton = Instance.new("TextButton")
                    SubButton.Font = Enum.Font.GothamBold
                    SubButton.Text = PanelConfig.SubButtonText
                    SubButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    SubButton.TextSize = 12
                    SubButton.TextTransparency = 0.3
                    SubButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    SubButton.BackgroundTransparency = 0.935
                    SubButton.Size = UDim2.new(0.5, -12, 0, 30)
                    SubButton.Position = UDim2.new(0.5, 2, 0, yBtn)
                    SubButton.Parent = Panel

                    local subCorner = Instance.new("UICorner")
                    subCorner.CornerRadius = UDim.new(0, 6)
                    subCorner.Parent = SubButton

                    SubButton.MouseButton1Click:Connect(function()
                        PanelConfig.SubButtonCallback(InputBox and InputBox.Text or "")
                    end)
                end

                if InputBox then
                    InputBox.FocusLost:Connect(function()
                        PanelFunc.Value = InputBox.Text
                        ConfigData[configKey] = InputBox.Text
                        SaveConfig()
                    end)
                end

                function PanelFunc:GetInput()
                    return InputBox and InputBox.Text or ""
                end

                CountItem = CountItem + 1
                return PanelFunc
            end

            function Items:AddButton(ButtonConfig)
                ButtonConfig = ButtonConfig or {}
                ButtonConfig.Title = ButtonConfig.Title or "Confirm"
                ButtonConfig.Callback = ButtonConfig.Callback or function() end
                ButtonConfig.SubTitle = ButtonConfig.SubTitle or nil
                ButtonConfig.SubCallback = ButtonConfig.SubCallback or function() end

                local Button = Instance.new("Frame")
                Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Button.BackgroundTransparency = 1
                Button.Size = UDim2.new(1, 0, 0, 40)
                Button.LayoutOrder = CountItem
                MountSectionItem(Button, ButtonConfig.FullWidth ~= false)

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = Button

                -- Konfigurasi Animasi
                local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

                -- MAIN BUTTON
                local MainButton = Instance.new("TextButton")
                MainButton.Font = Enum.Font.GothamBold
                MainButton.Text = "    " .. ButtonConfig.Title
                MainButton.TextSize = 12
                MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                MainButton.TextTransparency = 0.3
                MainButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                MainButton.BackgroundTransparency = 0.935
                MainButton.AutoButtonColor = false
                MainButton.TextXAlignment = Enum.TextXAlignment.Left

                local ButtonIcon = Instance.new("ImageLabel")
                ButtonIcon.Name = "Icon"
                ButtonIcon.Parent = MainButton -- Masuk ke dalam MainButton

                -- Ukuran & Posisi (Sesuaikan angka di bawah dengan kebutuhanmu)
                ButtonIcon.Size = UDim2.new(0, 20, 0, 20) -- Ganti 20, 20 dengan ukuranmu
                ButtonIcon.Position = UDim2.new(1, -8, 0.5, 0)
                ButtonIcon.AnchorPoint = Vector2.new(1, 0.5)

                -- Properti Tampilan
                ButtonIcon.BackgroundTransparency = 1 -- Agar background icon tidak kelihatan
                ButtonIcon.Image = "rbxassetid://90520342625816" -- Ganti 0 dengan ID gambarmu
                ButtonIcon.ImageColor3 = Color3.fromRGB(255, 255, 255) -- Warna icon
                ButtonIcon.ImageTransparency = 0.3 -- Biar estetik (cocok dengan teksmu yang transparan 0.3)
                ButtonIcon.ScaleType = Enum.ScaleType.Fit -- Agar gambar tidak gepeng
                
                local mainNormalSize = ButtonConfig.SubTitle
                    and UDim2.new(0.5, -4, 1, 0)
                    or  UDim2.new(1, 0, 1, 0)
                local mainShrinkSize = UDim2.new(
                    mainNormalSize.X.Scale,
                    mainNormalSize.X.Offset - 2,
                    mainNormalSize.Y.Scale,
                    mainNormalSize.Y.Offset - 2
                )

                MainButton.Size     = mainNormalSize
                MainButton.Position = UDim2.new(0, 0, 0, 0)
                MainButton.AnchorPoint = Vector2.new(0, 0)
                MainButton.Parent = Button


                local mainCorner = Instance.new("UICorner")
                mainCorner.CornerRadius = UDim.new(0, 4)
                mainCorner.Parent = MainButton

                -- Efek Animasi Main Button
                MainButton.MouseButton1Down:Connect(function()
                    TweenService:Create(MainButton, tweenInfo, {Size = mainShrinkSize}):Play()
                end)
                MainButton.MouseButton1Up:Connect(function()
                    TweenService:Create(MainButton, tweenInfo, {Size = mainNormalSize}):Play()
                end)
                MainButton.MouseLeave:Connect(function()
                    TweenService:Create(MainButton, tweenInfo, {Size = mainNormalSize}):Play()
                end)

                MainButton.MouseButton1Click:Connect(ButtonConfig.Callback)

                -- SUB BUTTON
                if ButtonConfig.SubTitle then
                    local SubButton = Instance.new("TextButton")
                    SubButton.Font = Enum.Font.GothamBold
                    SubButton.Text = "    " .. ButtonConfig.SubTitle
                    SubButton.TextSize = 12
                    SubButton.TextTransparency = 0.3
                    SubButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    SubButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    SubButton.BackgroundTransparency = 0.935
                    SubButton.AutoButtonColor = false
                    SubButton.TextXAlignment = Enum.TextXAlignment.Left
                    
                    local SubButtonIcon = Instance.new("ImageLabel")
                    SubButtonIcon.Name = "Icon"
                    SubButtonIcon.Parent = SubButton
                    SubButtonIcon.Size = UDim2.new(0, 20, 0, 20)
                    SubButtonIcon.Position = UDim2.new(1, -8, 0.5, 0)
                    SubButtonIcon.AnchorPoint = Vector2.new(1, 0.5)
                    SubButtonIcon.BackgroundTransparency = 1
                    SubButtonIcon.Image = "rbxassetid://90520342625816"
                    SubButtonIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                    SubButtonIcon.ImageTransparency = 0.3
                    SubButtonIcon.ScaleType = Enum.ScaleType.Fit

                    local subNormalSize = UDim2.new(0.5, -4, 1, 0)
                    local subShrinkSize = UDim2.new(
                        subNormalSize.X.Scale,
                        subNormalSize.X.Offset - 2,
                        subNormalSize.Y.Scale,
                        subNormalSize.Y.Offset - 2
                    )

                    SubButton.Size     = subNormalSize
                    SubButton.Position = UDim2.new(0.5, 4, 0, 0)
                    SubButton.AnchorPoint = Vector2.new(0, 0)
                    SubButton.Parent = Button


                    local subCorner = Instance.new("UICorner")
                    subCorner.CornerRadius = UDim.new(0, 4)
                    subCorner.Parent = SubButton

                    -- Efek Animasi Sub Button
                    SubButton.MouseButton1Down:Connect(function()
                        TweenService:Create(SubButton, tweenInfo, {Size = subShrinkSize}):Play()
                    end)
                    SubButton.MouseButton1Up:Connect(function()
                        TweenService:Create(SubButton, tweenInfo, {Size = subNormalSize}):Play()
                    end)
                    SubButton.MouseLeave:Connect(function()
                        TweenService:Create(SubButton, tweenInfo, {Size = subNormalSize}):Play()
                    end)

                    SubButton.MouseButton1Click:Connect(ButtonConfig.SubCallback)
                end

                CountItem = CountItem + 1
            end

            function Items:AddToggle(ToggleConfig)
                local ToggleConfig = ToggleConfig or {}
                ToggleConfig.Title = ToggleConfig.Title or "Title"
                ToggleConfig.Title2 = ToggleConfig.Title2 or ""
                ToggleConfig.Content = ToggleConfig.Content or ""
                ToggleConfig.Default = ToggleConfig.Default or false
                ToggleConfig.Callback = ToggleConfig.Callback or function() end
                ToggleConfig.Keybind = ToggleConfig.Keybind or false

                local configKey = "Toggle_" .. ToggleConfig.Title
                local keybindConfigKey = configKey .. "_Keybind"

                if ConfigData[configKey] ~= nil then
                    ToggleConfig.Default = ConfigData[configKey]
                end

                local currentKeybind = nil
                if ConfigData[keybindConfigKey] ~= nil then
                    currentKeybind = ConfigData[keybindConfigKey]
                end

                local ToggleFunc = { Value = ToggleConfig.Default }

                local Toggle = Instance.new("Frame")
                local UICorner20 = Instance.new("UICorner")
                local ToggleTitle = Instance.new("TextLabel")
                local ToggleContent = Instance.new("TextLabel")
                local ToggleButton = Instance.new("TextButton")
                local FeatureFrame2 = Instance.new("Frame")
                local KeybindFrame = Instance.new("Frame")
                local UICorner22 = Instance.new("UICorner")
                local UIStroke8 = Instance.new("UIStroke")
                local ToggleCircle = Instance.new("Frame")
                local UICorner23 = Instance.new("UICorner")
                local UICorner24 = Instance.new("UICorner")
                local KeybindButton = Instance.new("TextButton")

                Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Toggle.BackgroundTransparency = 0.935
                Toggle.BorderSizePixel = 0
                Toggle.LayoutOrder = CountItem
                Toggle.Name = "Toggle"
                MountSectionItem(Toggle, ToggleConfig.FullWidth == true)

                UICorner20.CornerRadius = UDim.new(0, 4)
                UICorner20.Parent = Toggle

                ToggleTitle.Font = Enum.Font.GothamBold
                ToggleTitle.Text = ToggleConfig.Title
                ToggleTitle.TextSize = 13
                ToggleTitle.TextColor3 = Color3.fromRGB(231, 231, 231)
                ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
                ToggleTitle.TextYAlignment = Enum.TextYAlignment.Top
                ToggleTitle.BackgroundTransparency = 1
                ToggleTitle.Position = UDim2.new(0, 10, 0, 10)
                ToggleTitle.Size = UDim2.new(1, -100, 0, 13)
                ToggleTitle.Name = "ToggleTitle"
                ToggleTitle.Parent = Toggle

                local ToggleTitle2 = Instance.new("TextLabel")
                ToggleTitle2.Font = Enum.Font.GothamBold
                ToggleTitle2.Text = ToggleConfig.Title2
                ToggleTitle2.TextSize = 12
                ToggleTitle2.TextColor3 = Color3.fromRGB(231, 231, 231)
                ToggleTitle2.TextXAlignment = Enum.TextXAlignment.Left
                ToggleTitle2.TextYAlignment = Enum.TextYAlignment.Top
                ToggleTitle2.BackgroundTransparency = 1
                ToggleTitle2.Position = UDim2.new(0, 10, 0, 23)
                ToggleTitle2.Size = UDim2.new(1, -100, 0, 12)
                ToggleTitle2.Name = "ToggleTitle2"
                ToggleTitle2.Parent = Toggle

                ToggleContent.Font = Enum.Font.GothamBold
                ToggleContent.Text = ToggleConfig.Content
                ToggleContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToggleContent.TextSize = 12
                ToggleContent.TextTransparency = 0.6
                ToggleContent.TextXAlignment = Enum.TextXAlignment.Left
                ToggleContent.TextYAlignment = Enum.TextYAlignment.Bottom
                ToggleContent.BackgroundTransparency = 1
                ToggleContent.Size = UDim2.new(1, -100, 0, 12)
                ToggleContent.Name = "ToggleContent"
                ToggleContent.Parent = Toggle

                if ToggleConfig.Title2 ~= "" then
                    Toggle.Size = UDim2.new(1, 0, 0, 57)
                    ToggleContent.Position = UDim2.new(0, 10, 0, 36)
                    ToggleTitle2.Visible = true
                else
                    Toggle.Size = UDim2.new(1, 0, 0, 46)
                    ToggleContent.Position = UDim2.new(0, 10, 0, 23)
                    ToggleTitle2.Visible = false
                end

                ToggleContent.Size = UDim2.new(1, -100, 0,
                    12 + (12 * (ToggleContent.TextBounds.X // ToggleContent.AbsoluteSize.X)))
                ToggleContent.TextWrapped = true
                if ToggleConfig.Title2 ~= "" then
                    Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 47)
                else
                    Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 33)
                end

                ToggleContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                    ToggleContent.TextWrapped = false
                    ToggleContent.Size = UDim2.new(1, -100, 0,
                        12 + (12 * (ToggleContent.TextBounds.X // ToggleContent.AbsoluteSize.X)))
                    if ToggleConfig.Title2 ~= "" then
                        Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 47)
                    else
                        Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 33)
                    end
                    ToggleContent.TextWrapped = true
                    UpdateSizeSection()
                end)

                ToggleButton.Font = Enum.Font.SourceSans
                ToggleButton.Text = ""
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.Size = UDim2.new(1, 0, 1, 0)
                ToggleButton.Name = "ToggleButton"
                ToggleButton.Parent = Toggle

                FeatureFrame2.AnchorPoint = Vector2.new(1, 0.5)
                FeatureFrame2.BackgroundTransparency = 0.92
                FeatureFrame2.BorderSizePixel = 0
                FeatureFrame2.Position = UDim2.new(1, -15, 0.5, 0)
                FeatureFrame2.Size = UDim2.new(0, 30, 0, 15)
                FeatureFrame2.Name = "FeatureFrame"
                FeatureFrame2.Parent = Toggle

                UICorner22.Parent = FeatureFrame2

                UIStroke8.Color = Color3.fromRGB(255, 255, 255)
                UIStroke8.Thickness = 2
                UIStroke8.Transparency = 0.9
                UIStroke8.Parent = FeatureFrame2

                ToggleCircle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                ToggleCircle.BorderSizePixel = 0
                ToggleCircle.Size = UDim2.new(0, 14, 0, 14)
                ToggleCircle.Name = "ToggleCircle"
                ToggleCircle.Parent = FeatureFrame2

                UICorner23.CornerRadius = UDim.new(0, 15)
                UICorner23.Parent = ToggleCircle

                KeybindFrame.AnchorPoint = Vector2.new(1, 0.5)
                KeybindFrame.BackgroundTransparency = 0.92
                KeybindFrame.BorderSizePixel = 0
                KeybindFrame.Position = UDim2.new(0.9, -20, 0.5, 0)
                KeybindFrame.Size = UDim2.new(0, 70, 0, 20)
                KeybindFrame.Name = "KeybindFrame"
                KeybindFrame.Parent = Toggle

                UICorner24.Parent = KeybindFrame

                KeybindButton.Font = Enum.Font.GothamBold
                KeybindButton.Text = "Keybind"
                KeybindButton.BackgroundTransparency = 1
                KeybindButton.Size = UDim2.new(1, 0, 1, 0)
                KeybindButton.Position = UDim2.new(0, 0, 0, 0)
                KeybindButton.TextXAlignment = Enum.TextXAlignment.Center
                KeybindButton.TextYAlignment = Enum.TextYAlignment.Center
                KeybindButton.Name = "KeybindButton"
                KeybindButton.TextColor3 = Color3.fromRGB(225, 225, 225)
                KeybindButton.TextSize = 12
                KeybindButton.Parent = KeybindFrame

                local isRecording = false
                local lastRecordCancel = 0

                local ignoredKeys = {
                    [Enum.KeyCode.LeftControl] = true, [Enum.KeyCode.RightControl] = true,
                    [Enum.KeyCode.LeftAlt] = true, [Enum.KeyCode.RightAlt] = true,
                    [Enum.KeyCode.LeftShift] = true, [Enum.KeyCode.RightShift] = true,
                    [Enum.KeyCode.Unknown] = true
                }

                local function GetModifiersString(excludeKey)
                    local keys = ""
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and excludeKey ~= Enum.KeyCode.LeftControl then keys = keys .. "LeftControl + " end
                    if UserInputService:IsKeyDown(Enum.KeyCode.RightControl) and excludeKey ~= Enum.KeyCode.RightControl then keys = keys .. "RightControl + " end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) and excludeKey ~= Enum.KeyCode.LeftAlt then keys = keys .. "LeftAlt + " end
                    if UserInputService:IsKeyDown(Enum.KeyCode.RightAlt) and excludeKey ~= Enum.KeyCode.RightAlt then keys = keys .. "RightAlt + " end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and excludeKey ~= Enum.KeyCode.LeftShift then keys = keys .. "LeftShift + " end
                    if UserInputService:IsKeyDown(Enum.KeyCode.RightShift) and excludeKey ~= Enum.KeyCode.RightShift then keys = keys .. "RightShift + " end
                    return keys
                end

                KeybindButton:GetPropertyChangedSignal("TextBounds"):Connect(function()
                    KeybindFrame.Size = UDim2.new(0, KeybindButton.TextBounds.X + 20, 0, 20)
                end)

                if not ToggleConfig.Keybind or isMobile then
                    KeybindFrame.Visible = false
                else
                    if currentKeybind then
                        KeybindButton.Text = "[ " .. currentKeybind .. " ]"
                    else
                        KeybindButton.Text = "Keybind"
                    end

                    KeybindButton.MouseButton1Click:Connect(function()
                        if not isRecording and tick() - lastRecordCancel > 0.1 then
                            isRecording = true
                            KeybindButton.Text = "[ ... ]"
                        end
                    end)

                    UserInputService.InputBegan:Connect(function(input, gameProcessed)
                        if isRecording then
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                isRecording = false
                                lastRecordCancel = tick()
                                currentKeybind = nil
                                KeybindButton.Text = "Keybind"
                                ConfigData[keybindConfigKey] = nil
                                SaveConfig()
                            elseif input.UserInputType == Enum.UserInputType.Keyboard then
                                local key = input.KeyCode
                                if key == Enum.KeyCode.Escape or key == Enum.KeyCode.Backspace then
                                    isRecording = false
                                    currentKeybind = nil
                                    KeybindButton.Text = "Keybind"
                                    ConfigData[keybindConfigKey] = nil
                                    SaveConfig()
                                elseif ignoredKeys[key] then
                                    if key ~= Enum.KeyCode.Unknown then
                                        KeybindButton.Text = "[ " .. GetModifiersString() .. "... ]"
                                    end
                                else
                                    local finalBind = GetModifiersString() .. key.Name
                                    currentKeybind = finalBind
                                    KeybindButton.Text = "[ " .. finalBind .. " ]"
                                    isRecording = false
                                    ConfigData[keybindConfigKey] = currentKeybind
                                    SaveConfig()
                                end
                            end
                        else
                            if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                                if currentKeybind then
                                    local checkStr = GetModifiersString(input.KeyCode) .. input.KeyCode.Name
                                    if checkStr == currentKeybind then
                                        ToggleFunc.Value = not ToggleFunc.Value
                                        ToggleFunc:Set(ToggleFunc.Value)
                                    end
                                end
                            end
                        end
                    end)

                    UserInputService.InputEnded:Connect(function(input, gameProcessed)
                        if isRecording and ignoredKeys[input.KeyCode] and input.KeyCode ~= Enum.KeyCode.Unknown then
                            currentKeybind = input.KeyCode.Name
                            KeybindButton.Text = "[ " .. currentKeybind .. " ]"
                            isRecording = false
                            ConfigData[keybindConfigKey] = currentKeybind
                            SaveConfig()
                        end
                    end)
                end

                ToggleButton.Activated:Connect(function()
                    ToggleFunc.Value = not ToggleFunc.Value
                    ToggleFunc:Set(ToggleFunc.Value)
                end)

                function ToggleFunc:Set(Value)
                    if typeof(ToggleConfig.Callback) == "function" then
                        local ok, err = pcall(function()
                            ToggleConfig.Callback(Value)
                        end)
                        if not ok then warn("Toggle Callback error:", err) end
                    end
                    ConfigData[configKey] = Value
                    SaveConfig()
                    if Value then
                        TweenService:Create(ToggleTitle, TweenInfo.new(0.2), { TextColor3 = Color3.fromRGB(255, 255, 255) }):Play()
                        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), { Position = UDim2.new(0, 15, 0, 0), BackgroundColor3 = Color3.fromRGB(46, 46, 46) })
                            :Play()
                        TweenService:Create(UIStroke8, TweenInfo.new(0.2), { Color = Color3.fromRGB(255, 255, 255), Transparency = 0 })
                            :Play()
                        TweenService:Create(FeatureFrame2, TweenInfo.new(0.2),
                            { BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0 }):Play()
                    else
                        TweenService:Create(ToggleTitle, TweenInfo.new(0.2),
                            { TextColor3 = Color3.fromRGB(230, 230, 230) }):Play()
                        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), { Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(230, 230, 230) }):Play()
                        TweenService:Create(UIStroke8, TweenInfo.new(0.2),
                            { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.9 }):Play()
                        TweenService:Create(FeatureFrame2, TweenInfo.new(0.2),
                            { BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.92 }):Play()
                    end
                end

                ToggleFunc:Set(ToggleFunc.Value)
                CountItem = CountItem + 1
                Elements[configKey] = ToggleFunc
                return ToggleFunc
            end

            function Items:AddSlider(SliderConfig)
                local SliderConfig = SliderConfig or {}
                SliderConfig.Title = SliderConfig.Title or "Slider"
                SliderConfig.Content = SliderConfig.Content or ""
                SliderConfig.Increment = SliderConfig.Increment or 1
                SliderConfig.Min = SliderConfig.Min or 0
                SliderConfig.Max = SliderConfig.Max or 100
                SliderConfig.Default = SliderConfig.Default or 50
                SliderConfig.Callback = SliderConfig.Callback or function() end

                local configKey = "Slider_" .. SliderConfig.Title
                if ConfigData[configKey] ~= nil then
                    SliderConfig.Default = ConfigData[configKey]
                end

                local SliderFunc = { Value = SliderConfig.Default }

                local Slider = Instance.new("Frame");
                local UICorner15 = Instance.new("UICorner");
                local SliderTitle = Instance.new("TextLabel");
                local SliderContent = Instance.new("TextLabel");
                local SliderInput = Instance.new("Frame");
                local UICorner16 = Instance.new("UICorner");
                local TextBox = Instance.new("TextBox");
                local SliderFrame = Instance.new("Frame");
                local UICorner17 = Instance.new("UICorner");
                local SliderDraggable = Instance.new("Frame");
                local UICorner18 = Instance.new("UICorner");
                local UIStroke5 = Instance.new("UIStroke");
                local SliderCircle = Instance.new("Frame");
                local UICorner19 = Instance.new("UICorner");
                local UIStroke6 = Instance.new("UIStroke");
                local UIStroke7 = Instance.new("UIStroke");

                Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Slider.BackgroundTransparency = 0.935
                Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Slider.BorderSizePixel = 0
                Slider.LayoutOrder = CountItem
                Slider.Size = UDim2.new(1, 0, 0, 46)
                Slider.Name = "Slider"
                MountSectionItem(Slider, SliderConfig.FullWidth ~= false)

                UICorner15.CornerRadius = UDim.new(0, 4)
                UICorner15.Parent = Slider

                SliderTitle.Font = Enum.Font.GothamBold
                SliderTitle.Text = SliderConfig.Title
                SliderTitle.TextColor3 = Color3.fromRGB(230.77499270439148, 230.77499270439148, 230.77499270439148)
                SliderTitle.TextSize = 13
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
                SliderTitle.TextYAlignment = Enum.TextYAlignment.Top
                SliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderTitle.BackgroundTransparency = 0.9990000128746033
                SliderTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SliderTitle.BorderSizePixel = 0
                SliderTitle.Position = UDim2.new(0, 10, 0, 10)
                SliderTitle.Size = (SliderConfig.FullWidth ~= false)
                    and UDim2.new(1, -180, 0, 13)
                    or UDim2.new(1, -20, 0, 13)
                SliderTitle.Name = "SliderTitle"
                SliderTitle.Parent = Slider

                SliderContent.Font = Enum.Font.GothamBold
                SliderContent.Text = SliderConfig.Content
                SliderContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                SliderContent.TextSize = 12
                SliderContent.TextTransparency = 0.6000000238418579
                SliderContent.TextXAlignment = Enum.TextXAlignment.Left
                SliderContent.TextYAlignment = Enum.TextYAlignment.Bottom
                SliderContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderContent.BackgroundTransparency = 0.9990000128746033
                SliderContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SliderContent.BorderSizePixel = 0
                SliderContent.Position = UDim2.new(0, 10, 0, 25)
                SliderContent.Size = (SliderConfig.FullWidth ~= false)
                    and UDim2.new(1, -180, 0, 12)
                    or UDim2.new(1, -20, 0, 12)
                SliderContent.Name = "SliderContent"
                SliderContent.Parent = Slider

                local sliderTextWidthOffset = (SliderConfig.FullWidth ~= false) and -180 or -20
                local sliderBottomPadding = (SliderConfig.FullWidth ~= false) and 33 or 58
                SliderContent.Size = UDim2.new(1, sliderTextWidthOffset, 0,
                    12 + (12 * (SliderContent.TextBounds.X // math.max(1, SliderContent.AbsoluteSize.X))))
                SliderContent.TextWrapped = true
                Slider.Size = UDim2.new(1, 0, 0, SliderContent.AbsoluteSize.Y + sliderBottomPadding)

                SliderContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                    SliderContent.TextWrapped = false
                    SliderContent.Size = UDim2.new(1, sliderTextWidthOffset, 0,
                        12 + (12 * (SliderContent.TextBounds.X // math.max(1, SliderContent.AbsoluteSize.X))))
                    Slider.Size = UDim2.new(1, 0, 0, SliderContent.AbsoluteSize.Y + sliderBottomPadding)
                    SliderContent.TextWrapped = true
                    UpdateSizeSection()
                end)

                SliderInput.AnchorPoint = Vector2.new(1, 0.5)
                SliderInput.BackgroundColor3 = GuiConfig.Color
                SliderInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SliderInput.BackgroundTransparency = 1
                SliderInput.BorderSizePixel = 0
                SliderInput.Position = (SliderConfig.FullWidth ~= false)
                    and UDim2.new(1, -155, 0.5, 0)
                    or UDim2.new(1, -10, 1, -15)
                SliderInput.Size = UDim2.new(0, 28, 0, 20)
                SliderInput.Name = "SliderInput"
                SliderInput.Parent = Slider

                UICorner16.CornerRadius = UDim.new(0, 2)
                UICorner16.Parent = SliderInput

                TextBox.Font = Enum.Font.GothamBold
                TextBox.Text = "90"
                TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextBox.TextSize = 13
                TextBox.TextWrapped = true
                TextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                TextBox.BackgroundTransparency = 0.9990000128746033
                TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
                TextBox.BorderSizePixel = 0
                TextBox.Position = UDim2.new(0, -1, 0, 0)
                TextBox.Size = UDim2.new(1, 0, 1, 0)
                TextBox.Parent = SliderInput

                SliderFrame.AnchorPoint = (SliderConfig.FullWidth ~= false)
                    and Vector2.new(1, 0.5)
                    or Vector2.new(0, 0.5)
                SliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderFrame.BackgroundTransparency = 0.800000011920929
                SliderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Position = (SliderConfig.FullWidth ~= false)
                    and UDim2.new(1, -20, 0.5, 0)
                    or UDim2.new(0, 10, 1, -15)
                SliderFrame.Size = (SliderConfig.FullWidth ~= false)
                    and UDim2.new(0, 100, 0, 3)
                    or UDim2.new(1, -58, 0, 3)
                SliderFrame.Name = "SliderFrame"
                SliderFrame.Parent = Slider

                local SliderHitbox = Instance.new("Frame")
                SliderHitbox.Name = "SliderHitbox"
                SliderHitbox.AnchorPoint = SliderFrame.AnchorPoint
                SliderHitbox.BackgroundTransparency = 1
                SliderHitbox.BorderSizePixel = 0
                SliderHitbox.Position = SliderFrame.Position
                SliderHitbox.Size = UDim2.new(SliderFrame.Size.X.Scale, SliderFrame.Size.X.Offset, 0, 24)
                SliderHitbox.Active = true
                SliderHitbox.ZIndex = SliderFrame.ZIndex + 2
                SliderHitbox.Parent = Slider

                UICorner17.Parent = SliderFrame

                SliderDraggable.AnchorPoint = Vector2.new(0, 0.5)
                SliderDraggable.BackgroundColor3 = GuiConfig.Color
                SliderDraggable.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SliderDraggable.BorderSizePixel = 0
                SliderDraggable.Position = UDim2.new(0, 0, 0.5, 0)
                SliderDraggable.Size = UDim2.new(0.899999976, 0, 0, 1)
                SliderDraggable.Name = "SliderDraggable"
                SliderDraggable.Parent = SliderFrame

                UICorner18.Parent = SliderDraggable

                SliderCircle.AnchorPoint = Vector2.new(1, 0.5)
                SliderCircle.BackgroundColor3 = GuiConfig.Color
                SliderCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SliderCircle.BorderSizePixel = 0
                SliderCircle.Position = UDim2.new(1, 4, 0.5, 0)
                SliderCircle.Size = UDim2.new(0, 8, 0, 8)
                SliderCircle.Name = "SliderCircle"
                SliderCircle.Parent = SliderDraggable

                UICorner19.Parent = SliderCircle

                UIStroke6.Color = GuiConfig.Color
                UIStroke6.Parent = SliderCircle

                local Dragging = false
                local UpdatingTextInternally = false
                local function Round(Number, Factor)
                    local Result = math.floor(Number / Factor + (math.sign(Number) * 0.5)) * Factor
                    if Result < 0 then
                        Result = Result + Factor
                    end
                    return Result
                end
                function SliderFunc:Set(Value, options)
                    options = options or {}
                    Value = math.clamp(Round(Value, SliderConfig.Increment), SliderConfig.Min, SliderConfig.Max)
                    SliderFunc.Value = Value
                    local valueText = tostring(Value)
                    if TextBox.Text ~= valueText then
                        UpdatingTextInternally = true
                        TextBox.Text = valueText
                        UpdatingTextInternally = false
                    end
                    local fillSize = UDim2.fromScale((Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 1)
                    if options.Instant then
                        SliderDraggable.Size = fillSize
                    else
                        TweenService:Create(
                            SliderDraggable,
                            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            { Size = fillSize }
                        ):Play()
                    end

                    SliderConfig.Callback(Value)
                    if options.Save ~= false then
                        ConfigData[configKey] = Value
                        SaveConfig()
                    end
                end

                local function updateFromPosition(x)
                    local SizeScale = math.clamp(
                        (x - SliderFrame.AbsolutePosition.X) / math.max(1, SliderFrame.AbsoluteSize.X),
                        0,
                        1
                    )
                    SliderFunc:Set(
                        SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale),
                        { Instant = true, Save = false }
                    )
                end

                SliderHitbox.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                        TweenService:Create(
                            SliderCircle,
                            TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            { Size = UDim2.new(0, 14, 0, 14) }
                        ):Play()
                        updateFromPosition(Input.Position.X)
                    end
                end)

                UserInputService.InputEnded:Connect(function(Input)
                    if Dragging and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
                        Dragging = false
                        ConfigData[configKey] = SliderFunc.Value
                        SaveConfig()
                        TweenService:Create(
                            SliderCircle,
                            TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            { Size = UDim2.new(0, 8, 0, 8) }
                        ):Play()
                    end
                end)

                UserInputService.InputChanged:Connect(function(Input)
                    if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                        updateFromPosition(Input.Position.X)
                    end
                end)

                TextBox:GetPropertyChangedSignal("Text"):Connect(function()
                    if UpdatingTextInternally then return end
                    local Valid = TextBox.Text:gsub("[^%d%.]", "")
                    if Valid ~= "" and tonumber(Valid) then
                        local ValidNumber = math.clamp(tonumber(Valid), SliderConfig.Min, SliderConfig.Max)
                        SliderFunc:Set(ValidNumber)
                    elseif Valid == "" then
                        SliderFunc:Set(SliderConfig.Min)
                    end
                end)
                SliderFunc:Set(SliderConfig.Default)
                CountItem = CountItem + 1
                Elements[configKey] = SliderFunc
                return SliderFunc
            end

            function Items:AddInput(InputConfig)
                local InputConfig = InputConfig or {}
                InputConfig.Title = InputConfig.Title or "Title"
                InputConfig.Content = InputConfig.Content or ""
                InputConfig.Callback = InputConfig.Callback or function() end
                InputConfig.Default = InputConfig.Default or ""

                local configKey = "Input_" .. InputConfig.Title
                if ConfigData[configKey] ~= nil then
                    InputConfig.Default = ConfigData[configKey]
                end

                local InputFunc = { Value = InputConfig.Default }

                local Input = Instance.new("Frame");
                local UICorner12 = Instance.new("UICorner");
                local InputTitle = Instance.new("TextLabel");
                local InputContent = Instance.new("TextLabel");
                local InputFrame = Instance.new("Frame");
                local UICorner13 = Instance.new("UICorner");
                local InputTextBox = Instance.new("TextBox");

                Input.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Input.BackgroundTransparency = 0.935
                Input.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Input.BorderSizePixel = 0
                Input.LayoutOrder = CountItem
                Input.Size = UDim2.new(1, 0, 0, 46)
                Input.Name = "Input"
                MountSectionItem(Input, InputConfig.FullWidth ~= false)

                UICorner12.CornerRadius = UDim.new(0, 4)
                UICorner12.Parent = Input

                InputTitle.Font = Enum.Font.GothamBold
                InputTitle.Text = InputConfig.Title or "TextBox"
                InputTitle.TextColor3 = Color3.fromRGB(230.77499270439148, 230.77499270439148, 230.77499270439148)
                InputTitle.TextSize = 13
                InputTitle.TextXAlignment = Enum.TextXAlignment.Left
                InputTitle.TextYAlignment = Enum.TextYAlignment.Top
                InputTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                InputTitle.BackgroundTransparency = 0.9990000128746033
                InputTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                InputTitle.BorderSizePixel = 0
                InputTitle.Position = UDim2.new(0, 10, 0, 10)
                InputTitle.Size = UDim2.new(1, -20, 0, 13)
                InputTitle.Name = "InputTitle"
                InputTitle.Parent = Input

                InputContent.Font = Enum.Font.GothamBold
                InputContent.Text = InputConfig.Content or "This is a TextBox"
                InputContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                InputContent.TextSize = 12
                InputContent.TextTransparency = 0.6000000238418579
                InputContent.TextWrapped = true
                InputContent.TextXAlignment = Enum.TextXAlignment.Left
                InputContent.TextYAlignment = Enum.TextYAlignment.Bottom
                InputContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                InputContent.BackgroundTransparency = 0.9990000128746033
                InputContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
                InputContent.BorderSizePixel = 0
                InputContent.Position = UDim2.new(0, 10, 0, 25)
                InputContent.Size = UDim2.new(1, -20, 0, 12)
                InputContent.Name = "InputContent"
                InputContent.Parent = Input

                if InputConfig.Content == "" then
                    InputContent.Visible = false
                    InputContent.Size = UDim2.new(1, -20, 0, 0)
                    Input.Size = UDim2.new(1, 0, 0, 73)
                else
                    InputContent.Size = UDim2.new(1, -20, 0,
                        12 + (12 * (InputContent.TextBounds.X // math.max(1, InputContent.AbsoluteSize.X))))
                    InputContent.TextWrapped = true
                    Input.Size = UDim2.new(1, 0, 0, InputContent.AbsoluteSize.Y + 75)
                end

                InputContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                    if InputConfig.Content ~= "" then
                        InputContent.TextWrapped = false
                        InputContent.Size = UDim2.new(1, -20, 0,
                            12 + (12 * (InputContent.TextBounds.X // math.max(1, InputContent.AbsoluteSize.X))))
                        Input.Size = UDim2.new(1, 0, 0, InputContent.AbsoluteSize.Y + 75)
                        InputFrame.Position = UDim2.new(0.5, 0, 0, InputContent.Position.Y.Offset + InputContent.AbsoluteSize.Y + 10)
                        InputContent.TextWrapped = true
                        UpdateSizeSection()
                    end
                end)

                InputFrame.AnchorPoint = Vector2.new(0.5, 0)
                InputFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                InputFrame.BackgroundTransparency = 0.949999988079071
                InputFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                InputFrame.BorderSizePixel = 0
                InputFrame.ClipsDescendants = true
                if InputConfig.Content == "" then
                    InputFrame.Position = UDim2.new(0.5, 0, 0, 33)
                else
                    InputFrame.Position = UDim2.new(0.5, 0, 0, InputContent.Position.Y.Offset + InputContent.AbsoluteSize.Y + 10)
                end
                InputFrame.Size = UDim2.new(1, -20, 0, 30)
                InputFrame.Name = "InputFrame"
                InputFrame.Parent = Input

                UICorner13.CornerRadius = UDim.new(0, 4)
                UICorner13.Parent = InputFrame

                InputTextBox.CursorPosition = -1
                InputTextBox.Font = Enum.Font.GothamBold
                InputTextBox.PlaceholderColor3 = Color3.fromRGB(120.00000044703484, 120.00000044703484,
                    120.00000044703484)
                InputTextBox.PlaceholderText = "Write ur input here!"
                InputTextBox.Text = InputConfig.Default
                InputTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                InputTextBox.TextSize = 12
                InputTextBox.TextXAlignment = Enum.TextXAlignment.Left
                InputTextBox.AnchorPoint = Vector2.new(0, 0.5)
                InputTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                InputTextBox.BackgroundTransparency = 0.9990000128746033
                InputTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
                InputTextBox.BorderSizePixel = 0
                InputTextBox.Position = UDim2.new(0, 5, 0.5, 0)
                InputTextBox.Size = UDim2.new(1, -10, 1, -8)
                InputTextBox.Name = "InputTextBox"
                InputTextBox.Parent = InputFrame
                function InputFunc:Set(Value)
                    InputTextBox.Text = Value
                    InputFunc.Value = Value
                    InputConfig.Callback(Value)
                    ConfigData[configKey] = Value
                    SaveConfig()
                end

                InputFunc:Set(InputFunc.Value)

                InputTextBox.FocusLost:Connect(function()
                    InputFunc:Set(InputTextBox.Text)
                end)
                CountItem = CountItem + 1
                Elements[configKey] = InputFunc
                return InputFunc
            end
            
            function Items:AddDropdown(DropdownConfig)
                local DropdownConfig = DropdownConfig or {}
                DropdownConfig.Title = DropdownConfig.Title or "Title"
                DropdownConfig.Content = DropdownConfig.Content or ""
                DropdownConfig.Multi = DropdownConfig.Multi or false
                DropdownConfig.Options = DropdownConfig.Options or {}
                DropdownConfig.Default = DropdownConfig.Default or (DropdownConfig.Multi and {} or nil)
                DropdownConfig.Callback = DropdownConfig.Callback or function() end

                local configKey = "Dropdown_" .. DropdownConfig.Title
                if ConfigData[configKey] ~= nil then
                    DropdownConfig.Default = ConfigData[configKey]
                end

                local DropdownFunc = { Value = DropdownConfig.Default, Options = DropdownConfig.Options }

                local Dropdown = Instance.new("Frame")
                local DropdownButton = Instance.new("TextButton")
                local UICorner10 = Instance.new("UICorner")
                local DropdownTitle = Instance.new("TextLabel")
                local DropdownContent = Instance.new("TextLabel")
                local SelectOptionsFrame = Instance.new("Frame")
                local UICorner11 = Instance.new("UICorner")
                local OptionSelecting = Instance.new("TextLabel")
                local OptionImg = Instance.new("ImageLabel")

                Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Dropdown.BackgroundTransparency = 0.935
                Dropdown.BorderSizePixel = 0
                -- The compact popup may extend below the 46px dropdown row.
                Dropdown.ClipsDescendants = false
                Dropdown.LayoutOrder = CountItem
                Dropdown.Size = UDim2.new(1, 0, 0, 46)
                Dropdown.Name = "Dropdown"
                MountSectionItem(Dropdown, DropdownConfig.FullWidth ~= false)

                DropdownButton.Text = ""
                DropdownButton.BackgroundTransparency = 1
                DropdownButton.Name = "ToggleButton"

                UICorner10.CornerRadius = UDim.new(0, 4)
                UICorner10.Parent = Dropdown

                DropdownTitle.Font = Enum.Font.GothamBold
                DropdownTitle.Text = DropdownConfig.Title
                DropdownTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                DropdownTitle.TextSize = 13
                DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
                DropdownTitle.BackgroundTransparency = 1
                DropdownTitle.Position = UDim2.new(0, 10, 0, 10)
                DropdownTitle.Size = (DropdownConfig.FullWidth ~= false)
                    and UDim2.new(1, -180, 0, 13)
                    or UDim2.new(1, -20, 0, 13)
                DropdownTitle.Name = "DropdownTitle"
                DropdownTitle.Parent = Dropdown

                DropdownContent.Font = Enum.Font.GothamBold
                DropdownContent.Text = DropdownConfig.Content
                DropdownContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                DropdownContent.TextSize = 12
                DropdownContent.TextTransparency = 0.6
                DropdownContent.TextWrapped = true
                DropdownContent.TextXAlignment = Enum.TextXAlignment.Left
                DropdownContent.BackgroundTransparency = 1
                DropdownContent.Position = UDim2.new(0, 10, 0, 25)
                DropdownContent.Size = (DropdownConfig.FullWidth ~= false)
                    and UDim2.new(1, -180, 0, 12)
                    or UDim2.new(1, -20, 0, 12)
                DropdownContent.Name = "DropdownContent"
                DropdownContent.Parent = Dropdown

                if DropdownConfig.FullWidth ~= false then
                    Dropdown.Size = UDim2.new(1, 0, 0, 46)
                    SelectOptionsFrame.AnchorPoint = Vector2.new(1, 0.5)
                    SelectOptionsFrame.Position = UDim2.new(1, -7, 0.5, 0)
                    SelectOptionsFrame.Size = UDim2.new(0, 148, 0, 30)
                else
                    Dropdown.Size = UDim2.new(1, 0, 0, 76)
                    SelectOptionsFrame.AnchorPoint = Vector2.new(0.5, 1)
                    SelectOptionsFrame.Position = UDim2.new(0.5, 0, 1, -7)
                    SelectOptionsFrame.Size = UDim2.new(1, -20, 0, 28)
                end
                SelectOptionsFrame.BackgroundColor3 = Color3.fromRGB(8, 36, 25)
                SelectOptionsFrame.BackgroundTransparency = 0
                SelectOptionsFrame.Name = "SelectOptionsFrame"
                SelectOptionsFrame.LayoutOrder = CountDropdown
                SelectOptionsFrame.Parent = Dropdown

                UICorner11.CornerRadius = UDim.new(0, 5)
                UICorner11.Parent = SelectOptionsFrame

                local SelectStroke = Instance.new("UIStroke")
                SelectStroke.Color = Color3.fromRGB(34, 91, 68)
                SelectStroke.Transparency = 0.45
                SelectStroke.Thickness = 1
                SelectStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                SelectStroke.Parent = SelectOptionsFrame

                -- The selector itself owns the interaction button. Keeping the
                -- hit target inside this visual frame makes open/close toggling
                -- deterministic even while the popup overlay is active.
                DropdownButton.Size = UDim2.fromScale(1, 1)
                DropdownButton.Position = UDim2.fromOffset(0, 0)
                DropdownButton.ZIndex = 120
                DropdownButton.Parent = SelectOptionsFrame

                OptionSelecting.Font = Enum.Font.GothamBold
                OptionSelecting.Text = DropdownConfig.Multi and "Select Options" or "Select Option"
                OptionSelecting.TextColor3 = Color3.fromRGB(255, 255, 255)
                OptionSelecting.TextSize = 12
                OptionSelecting.TextTransparency = 0.6
                OptionSelecting.TextXAlignment = Enum.TextXAlignment.Left
                OptionSelecting.AnchorPoint = Vector2.new(0, 0.5)
                OptionSelecting.BackgroundTransparency = 1
                OptionSelecting.Position = UDim2.new(0, 5, 0.5, 0)
                OptionSelecting.Size = UDim2.new(1, -30, 1, -8)
                OptionSelecting.Name = "OptionSelecting"
                OptionSelecting.ZIndex = 121
                OptionSelecting.Parent = SelectOptionsFrame

                OptionImg.Image = "rbxassetid://16851841101"
                OptionImg.ImageColor3 = Color3.fromRGB(230, 230, 230)
                OptionImg.AnchorPoint = Vector2.new(1, 0.5)
                OptionImg.BackgroundTransparency = 1
                OptionImg.Position = UDim2.new(1, 0, 0.5, 0)
                OptionImg.Size = UDim2.new(0, 25, 0, 25)
                OptionImg.Name = "OptionImg"
                OptionImg.ZIndex = 121
                OptionImg.Parent = SelectOptionsFrame

                local DropdownContainer = Instance.new("Frame")
                DropdownContainer.Name = "InlineMenu"
                DropdownContainer.BackgroundColor3 = Color3.fromRGB(4, 25, 17)
                DropdownContainer.BackgroundTransparency = 0
                DropdownContainer.BorderSizePixel = 0
                DropdownContainer.ClipsDescendants = true
                DropdownContainer.Active = true
                DropdownContainer.AnchorPoint = Vector2.new(1, 0)
                DropdownContainer.Size = UDim2.fromOffset(154, 0)
                DropdownContainer.Visible = false
                DropdownContainer.ZIndex = 100
                DropdownContainer.Parent = SectionOverlay

                local MenuCorner = Instance.new("UICorner")
                MenuCorner.CornerRadius = UDim.new(0, 6)
                MenuCorner.Parent = DropdownContainer

                local MenuShield = Instance.new("TextButton")
                MenuShield.Name = "InteractionShield"
                MenuShield.BackgroundTransparency = 1
                MenuShield.BorderSizePixel = 0
                MenuShield.Text = ""
                MenuShield.AutoButtonColor = false
                MenuShield.Active = true
                MenuShield.Selectable = false
                MenuShield.Size = UDim2.fromScale(1, 1)
                MenuShield.ZIndex = 101
                MenuShield.Parent = DropdownContainer

                local MenuStroke = Instance.new("UIStroke")
                MenuStroke.Color = Color3.fromRGB(34, 91, 68)
                MenuStroke.Transparency = 0.3
                MenuStroke.Thickness = 1
                MenuStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                MenuStroke.Parent = DropdownContainer

                local SearchBox = Instance.new("TextBox")
                SearchBox.PlaceholderText = "Search options..."
                SearchBox.PlaceholderColor3 = Color3.fromRGB(116, 159, 136)
                SearchBox.Font = Enum.Font.GothamMedium
                SearchBox.Text = ""
                SearchBox.TextSize = 10
                SearchBox.TextColor3 = Color3.fromRGB(220, 234, 226)
                SearchBox.BackgroundColor3 = Color3.fromRGB(10, 43, 31)
                SearchBox.BackgroundTransparency = 0
                SearchBox.BorderSizePixel = 0
                SearchBox.Size = UDim2.new(1, -10, 0, 25)
                SearchBox.Position = UDim2.fromOffset(5, 5)
                SearchBox.ZIndex = 105
                SearchBox.ClearTextOnFocus = false
                SearchBox.Name = "SearchBox"
                SearchBox.Parent = DropdownContainer

                local SearchCorner = Instance.new("UICorner")
                SearchCorner.CornerRadius = UDim.new(0, 4)
                SearchCorner.Parent = SearchBox

                local ScrollSelect = Instance.new("ScrollingFrame")
                ScrollSelect.Size = UDim2.new(1, -10, 1, -40)
                ScrollSelect.Position = UDim2.fromOffset(5, 35)
                ScrollSelect.ZIndex = 103
                ScrollSelect.Active = true
                ScrollSelect.ScrollBarImageColor3 = Color3.fromRGB(34, 91, 68)
                ScrollSelect.ScrollBarImageTransparency = 0.25
                ScrollSelect.BorderSizePixel = 0
                ScrollSelect.BackgroundTransparency = 1
                ScrollSelect.ScrollBarThickness = 2
                ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, 0)
                ScrollSelect.Name = "ScrollSelect"
                ScrollSelect.Parent = DropdownContainer

                local UIListLayout4 = Instance.new("UIListLayout")
                UIListLayout4.Padding = UDim.new(0, 2)
                UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout4.Parent = ScrollSelect

                UIListLayout4:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, UIListLayout4.AbsoluteContentSize.Y)
                end)

                local updateInlineMenuSize

                SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                    local query = string.lower(SearchBox.Text)
                    for _, option in pairs(ScrollSelect:GetChildren()) do
                        if option.Name == "Option" and option:FindFirstChild("OptionText") then
                            local text = string.lower(option.OptionText.Text)
                            option.Visible = query == "" or string.find(text, query, 1, true)
                        end
                    end
                    ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, UIListLayout4.AbsoluteContentSize.Y)
                    task.defer(function()
                        if updateInlineMenuSize then updateInlineMenuSize() end
                    end)
                end)

                local DropCount = 0
                local MenuOpen = false
                Dropdown:SetAttribute("MenuOpen", false)
                local MaxVisibleOptions = 5

                local function countVisibleOptions()
                    local count = 0
                    for _, option in ipairs(ScrollSelect:GetChildren()) do
                        if option.Name == "Option" and option.Visible then
                            count = count + 1
                        end
                    end
                    return count
                end

                updateInlineMenuSize = function()
                    local visibleCount = math.max(1, countVisibleOptions())
                    local listHeight = math.min(visibleCount, MaxVisibleOptions) * 32
                    local menuHeight = 40 + listHeight
                    DropdownContainer.Size = UDim2.fromOffset(154, menuHeight)
                    DropdownContainer.Visible = MenuOpen
                    Dropdown:SetAttribute("MenuOpen", MenuOpen)
                    OptionImg.Rotation = MenuOpen and 180 or 0
                end

                local function updatePopupPosition()
                    -- Position relative to the section portal, directly below
                    -- the selector, so it moves naturally with section scroll.
                    local dropdownRight = Dropdown.AbsolutePosition.X + Dropdown.AbsoluteSize.X
                    local popupX = dropdownRight - SectionOverlay.AbsolutePosition.X - 7
                    local popupY = Dropdown.AbsolutePosition.Y - SectionOverlay.AbsolutePosition.Y + 43
                    DropdownContainer.Position = UDim2.fromOffset(popupX, popupY)
                end

                local function setMenuOpen(open)
                    MenuOpen = open

                    -- Raise the dropdown and its row/cell while open. Roblox
                    -- sibling rows with the same ZIndex can otherwise intercept
                    -- clicks even when the popup descendants have a high ZIndex.
                    local cell = Dropdown.Parent
                    local row = cell and cell.Parent
                    Dropdown.ZIndex = open and 90 or 1
                    if cell and cell:IsA("GuiObject") then cell.ZIndex = open and 89 or 1 end
                    if row and row:IsA("GuiObject") then row.ZIndex = open and 88 or 1 end
                    SelectOptionsFrame.ZIndex = open and 91 or 1
                    DropdownButton.ZIndex = 120
                    SectionOverlay.Active = open
                    if open then updatePopupPosition() end
                    updateInlineMenuSize()
                end

                DropdownButton.Activated:Connect(function()
                    setMenuOpen(not DropdownContainer.Visible)
                end)

                local function pointInside(guiObject, point)
                    if not guiObject or not guiObject.Visible then return false end
                    local position = guiObject.AbsolutePosition
                    local size = guiObject.AbsoluteSize
                    return point.X >= position.X
                        and point.X <= position.X + size.X
                        and point.Y >= position.Y
                        and point.Y <= position.Y + size.Y
                end

                -- Close the popup when clicking/tapping anywhere outside the
                -- selector and popup. Interactions inside search/options remain
                -- untouched and therefore do not dismiss the menu.
                UserInputService.InputBegan:Connect(function(input)
                    if not MenuOpen then return end

                    if input.KeyCode == Enum.KeyCode.Escape then
                        setMenuOpen(false)
                        return
                    end

                    if input.UserInputType ~= Enum.UserInputType.MouseButton1
                        and input.UserInputType ~= Enum.UserInputType.Touch then
                        return
                    end

                    local point = Vector2.new(input.Position.X, input.Position.Y)
                    if not pointInside(SelectOptionsFrame, point)
                        and not pointInside(DropdownContainer, point) then
                        setMenuOpen(false)
                    end
                end)

                ScrolLayers:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
                    if MenuOpen then updatePopupPosition() end
                end)
                Dropdown:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
                    if MenuOpen then updatePopupPosition() end
                end)

                function DropdownFunc:Clear()
                    for _, DropFrame in ScrollSelect:GetChildren() do
                        if DropFrame.Name == "Option" then
                            DropFrame:Destroy()
                        end
                    end
                    DropdownFunc.Value = DropdownConfig.Multi and {} or nil
                    DropdownFunc.Options = {}
                    OptionSelecting.Text = DropdownConfig.Multi and "Select Options" or "Select Option"
                    DropCount = 0
                    updateInlineMenuSize()
                end

                function DropdownFunc:AddOption(option)
                    local label, value
                    if typeof(option) == "table" and option.Label and option.Value ~= nil then
                        label = tostring(option.Label)
                        value = option.Value
                    else
                        label = tostring(option)
                        value = option
                    end

                    local Option = Instance.new("Frame")
                    local OptionButton = Instance.new("TextButton")
                    local OptionText = Instance.new("TextLabel")
                    local ChooseFrame = Instance.new("Frame")
                    local UIStroke15 = Instance.new("UIStroke")
                    local UICorner38 = Instance.new("UICorner")
                    local UICorner37 = Instance.new("UICorner")

                    Option.BackgroundColor3 = Color3.fromRGB(10, 43, 31)
                    Option.BackgroundTransparency = 1
                    Option.Size = UDim2.new(1, -2, 0, 30)
                    Option.Name = "Option"
                    Option.ZIndex = 104
                    Option.Parent = ScrollSelect

                    UICorner37.CornerRadius = UDim.new(0, 3)
                    UICorner37.Parent = Option

                    OptionButton.BackgroundTransparency = 1
                    OptionButton.Size = UDim2.new(1, 0, 1, 0)
                    OptionButton.ZIndex = 106
                    OptionButton.Active = true
                    OptionButton.Selectable = true
                    OptionButton.AutoButtonColor = false
                    OptionButton.Text = ""
                    OptionButton.Name = "OptionButton"
                    OptionButton.Parent = Option

                    OptionText.Font = Enum.Font.GothamBold
                    OptionText.Text = label
                    OptionText.TextSize = 12
                    OptionText.TextColor3 = Color3.fromRGB(214, 232, 220)
                    OptionText.Position = UDim2.new(0, 9, 0, 8)
                    OptionText.Size = UDim2.new(1, -30, 0, 13)
                    OptionText.BackgroundTransparency = 1
                    OptionText.TextXAlignment = Enum.TextXAlignment.Left
                    OptionText.ZIndex = 105
                    OptionText.Name = "OptionText"
                    OptionText.Parent = Option

                    Option:SetAttribute("RealValue", value)

                    ChooseFrame.AnchorPoint = Vector2.new(0, 0.5)
                    ChooseFrame.BackgroundColor3 = GuiConfig.Color
                    ChooseFrame.Position = UDim2.new(0, 2, 0.5, 0)
                    ChooseFrame.Size = UDim2.new(0, 0, 0, 0)
                    ChooseFrame.Name = "ChooseFrame"
                    ChooseFrame.ZIndex = 105
                    ChooseFrame.Parent = Option

                    UIStroke15.Color = GuiConfig.Color
                    UIStroke15.Thickness = 1.6
                    UIStroke15.Transparency = 0.999
                    UIStroke15.Parent = ChooseFrame
                    UICorner38.Parent = ChooseFrame

                    OptionButton.Activated:Connect(function()
                        if DropdownConfig.Multi then
                            if not table.find(DropdownFunc.Value, value) then
                                table.insert(DropdownFunc.Value, value)
                            else
                                for i, v in pairs(DropdownFunc.Value) do
                                    if v == value then
                                        table.remove(DropdownFunc.Value, i)
                                        break
                                    end
                                end
                            end
                        else
                            DropdownFunc.Value = value
                        end
                        DropdownFunc:Set(DropdownFunc.Value)
                        -- Keep the popup open after selection, matching the
                        -- original dropdown behavior. Click the selector again
                        -- to close it.
                    end)
                    DropCount = DropCount + 1
                    updateInlineMenuSize()
                end

                function DropdownFunc:Set(Value)
                    if DropdownConfig.Multi then
                        DropdownFunc.Value = type(Value) == "table" and Value or {}
                    else
                        DropdownFunc.Value = (type(Value) == "table" and Value[1]) or Value
                    end

                    ConfigData[configKey] = DropdownFunc.Value
                    SaveConfig()

                    local texts = {}
                    for _, Drop in ScrollSelect:GetChildren() do
                        if Drop.Name == "Option" and Drop:FindFirstChild("OptionText") then
                            local v = Drop:GetAttribute("RealValue")
                            local selected = DropdownConfig.Multi and table.find(DropdownFunc.Value, v) or
                                DropdownFunc.Value == v

                            if selected then
                                TweenService:Create(Drop.ChooseFrame, TweenInfo.new(0.2),
                                    { Size = UDim2.new(0, 1, 0, 12) }):Play()
                                TweenService:Create(Drop.ChooseFrame.UIStroke, TweenInfo.new(0.2), { Transparency = 0 })
                                    :Play()
                                TweenService:Create(Drop, TweenInfo.new(0.2), { BackgroundTransparency = 0.935 }):Play()
                                table.insert(texts, Drop.OptionText.Text)
                            else
                                TweenService:Create(Drop.ChooseFrame, TweenInfo.new(0.1),
                                    { Size = UDim2.new(0, 0, 0, 0) }):Play()
                                TweenService:Create(Drop.ChooseFrame.UIStroke, TweenInfo.new(0.1),
                                    { Transparency = 0.999 }):Play()
                                TweenService:Create(Drop, TweenInfo.new(0.1), { BackgroundTransparency = 0.999 }):Play()
                            end
                        end
                    end

                    OptionSelecting.Text = (#texts == 0)
                        and (DropdownConfig.Multi and "Select Options" or "Select Option")
                        or table.concat(texts, ", ")

                    updateInlineMenuSize()

                    if DropdownConfig.Callback then
                        if DropdownConfig.Multi then
                            DropdownConfig.Callback(DropdownFunc.Value)
                        else
                            local str = (DropdownFunc.Value ~= nil) and tostring(DropdownFunc.Value) or ""
                            DropdownConfig.Callback(str)
                        end
                    end
                end

                function DropdownFunc:SetValue(val)
                    self:Set(val)
                end

                function DropdownFunc:GetValue()
                    return self.Value
                end

                function DropdownFunc:SetValues(newList, selecting)
                    newList = newList or {}
                    selecting = selecting or (DropdownConfig.Multi and {} or nil)
                    DropdownFunc:Clear()
                    for _, v in ipairs(newList) do
                        DropdownFunc:AddOption(v)
                    end
                    DropdownFunc.Options = newList
                    DropdownFunc:Set(selecting)
                end

                DropdownFunc:SetValues(DropdownFunc.Options, DropdownFunc.Value)

                CountItem = CountItem + 1
                CountDropdown = CountDropdown + 1
                Elements[configKey] = DropdownFunc
                return DropdownFunc
            end

            function Items:AddDivider()
                local Divider = Instance.new("Frame")
                Divider.Name = "Divider"
                MountSectionItem(Divider, true)
                Divider.AnchorPoint = Vector2.new(0.5, 0)
                Divider.Position = UDim2.new(0.5, 0, 0, 0)
                Divider.Size = UDim2.new(1, 0, 0, 2)
                Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Divider.BackgroundTransparency = 0
                Divider.BorderSizePixel = 0
                Divider.LayoutOrder = CountItem

                local UIGradient = Instance.new("UIGradient")
                UIGradient.Color = ColorSequence.new {
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
                    ColorSequenceKeypoint.new(0.5, GuiConfig.Color),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
                }
                UIGradient.Parent = Divider

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 2)
                UICorner.Parent = Divider

                CountItem = CountItem + 1
                return Divider
            end

            function Items:AddSubSection(title)
                title = title or "Sub Section"

                local SubSection = Instance.new("Frame")
                SubSection.Name = "SubSection"
                MountSectionItem(SubSection, true)
                SubSection.BackgroundTransparency = 1
                SubSection.Size = UDim2.new(1, 0, 0, 22)
                SubSection.LayoutOrder = CountItem

                local Background = Instance.new("Frame")
                Background.Parent = SubSection
                Background.Size = UDim2.new(1, 0, 1, 0)
                Background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Background.BackgroundTransparency = 1
                Background.BorderSizePixel = 0
                Instance.new("UICorner", Background).CornerRadius = UDim.new(0, 6)

                local Label = Instance.new("TextLabel")
                Label.Parent = SubSection
                Label.AnchorPoint = Vector2.new(0, 0.5)
                Label.Position = UDim2.new(0, 10, 0.5, 0)
                Label.Size = UDim2.new(1, -20, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Font = Enum.Font.GothamBold
                Label.Text = title
                Label.TextColor3 = GuiConfig.Color
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left

                CountItem = CountItem + 1
                return SubSection
            end

            CountSection = CountSection + 1
            return Items
        end

        CountTab = CountTab + 1
        local safeName = TabConfig.Name:gsub("%s+", "_")
        _G[safeName] = Sections
        return Sections
    end

    -- ═══════════════════════════════════════════════════
    -- SETTINGS TAB (Config Profile System)
    -- ═══════════════════════════════════════════════════
    function Tabs:AddConfigTab()
        pcall(function()
            local SettingsTab = Tabs:AddTab({ Name = "Config", Icon = "settings" })

            -- helper notif dengan title "Config" (global notif: msg, delay, color, title)
            local function cnotif(msg, delay)
                notif(msg, delay, GuiConfig.Color, "Config")
            end

            -- ═══ INFO SECTION ═══
            -- local InfoSection = SettingsTab:AddSection("Informasi", true)
            -- InfoSection:AddParagraph({
            --     Title   = "Auto-Save Aktif",
            --     Content = "Semua perubahan (toggle, slider, dropdown) otomatis tersimpan ke file saat kamu ubah. Saat relog, setting kamu akan otomatis ter-load kembali.\n\nGunakan Profile untuk menyimpan beberapa preset yang berbeda."
            -- })

            -- ═══ AUTO-LOAD SAAT STARTUP ═══
            -- Panggil LoadConfigElements setelah semua element dibuat
            task.defer(function()
                pcall(function()
                    LoadConfigElements()
                end)
            end)

            -- ═══ PROFILE SECTION ═══
            local ConfigSection = SettingsTab:AddSection("Config Profile")

            local profileDropdown
            local selectedProfile = "None"

            local function RefreshProfileDropdown()
                local fresh = GetProfileList()
                if #fresh == 0 then table.insert(fresh, "None") end
                if profileDropdown and profileDropdown.SetValues then
                    profileDropdown:SetValues(fresh, fresh[1] or "None")
                end
                selectedProfile = fresh[1] or "None"
                return fresh
            end

            local profiles = GetProfileList()
            if #profiles == 0 then table.insert(profiles, "None") end

            profileDropdown = ConfigSection:AddDropdown({
                Title   = "Select Profile",
                Content = "Select the profile you want to load or delete",
                Options = profiles,
                Default = profiles[1] or "None",
                Multi   = false,
                Callback = function(val)
                    selectedProfile = val
                end
            })

            ConfigSection:AddButton({
                Title = "Refresh",
                Callback = function()
                    local fresh = RefreshProfileDropdown()
                    cnotif("Found " .. tostring(#fresh) .. " profiles", 3)
                end
            })

            local profileNameInput = ConfigSection:AddInput({
                Title   = "New Profile Name",
                Content = "Type a name to save new profile",
                Default = "",
                Callback = function(val) end
            })


            ConfigSection:AddButton({
                Title    = "Save Profile",
                SubTitle = "Load Profile",
                Callback = function()
                    local name = profileNameInput.Value
                    if not name or name == "" or name == "None" then
                        cnotif("Type a profile name first!", 3)
                        return
                    end
                    name = name:gsub("[^%w_%-]", "_")
                    local ok = SaveProfile(name)
                    if ok then
                        cnotif("Profile '" .. name .. "' saved successfully!", 4)
                        task.wait(0.2)
                        local newList = GetProfileList()
                        if not table.find(newList, name) then
                            table.insert(newList, name)
                            table.sort(newList)
                        end
                        if #newList > 1 then
                            for i = #newList, 1, -1 do
                                if newList[i] == "None" then table.remove(newList, i) end
                            end
                        end
                        if profileDropdown and profileDropdown.SetValues then
                            profileDropdown:SetValues(newList, name)
                        end
                        selectedProfile = name
                    else
                        cnotif("Failed to save profile!", 3)
                    end
                end,
                SubCallback = function()
                    if not selectedProfile or selectedProfile == "" or selectedProfile == "None" then
                        cnotif("Select a profile from the dropdown first!", 3)
                        return
                    end
                    cnotif("Loading '" .. selectedProfile .. "'...", 2)
                    task.spawn(function()
                        local ok = LoadProfile(selectedProfile)
                        if ok then
                            cnotif("Profile '" .. selectedProfile .. "' loaded successfully!", 4)
                        else
                            cnotif("Failed to load profile!", 3)
                        end
                    end)
                end
            })

            ConfigSection:AddButton({
                Title    = "Delete Profile",
                SubTitle = "Copy Config",
                Callback = function()
                    if not selectedProfile or selectedProfile == "" or selectedProfile == "None" then
                        cnotif("Select the profile you want to delete!", 3)
                        return
                    end
                    local ok = DeleteProfile(selectedProfile)
                    if ok then
                        cnotif("Profile '" .. selectedProfile .. "' dihapus!", 3)
                        selectedProfile = "None"
                        local newList = GetProfileList()
                        if #newList == 0 then table.insert(newList, "None") end
                        if profileDropdown and profileDropdown.SetValues then
                            profileDropdown:SetValues(newList, newList[1])
                        end
                    else
                        cnotif("Failed to delete profile!", 3)
                    end
                end,
                SubCallback = function()
                    -- Copy current ConfigData as JSON to clipboard
                    if setclipboard then
                        local json = HttpService:JSONEncode(ConfigData)
                        setclipboard(json)
                        cnotif("Config copied to clipboard successfully!", 3)
                    else
                        cnotif("Executor does not support clipboard!", 3)
                    end
                end
            })

            -- ═══ IMPORT CONFIG ═══
            local ImportSection = SettingsTab:AddSection("Import Config")

            local importInput = ImportSection:AddPanel({
                Title       = "Paste JSON Config",
                Placeholder = "Paste JSON Config here...",
                ButtonText  = "Import & Load",
                Callback    = function(val)
                    if not val or val == "" then
                        cnotif("JSON Input is empty!", 3)
                        return
                    end
                    local ok, data = pcall(function()
                        return HttpService:JSONDecode(val)
                    end)
                    if not ok or type(data) ~= "table" then
                        cnotif("Invalid JSON!", 3)
                        return
                    end
                    -- Apply ke ConfigData dan semua elemen
                    for key, v in pairs(data) do
                        ConfigData[key] = v
                    end
                    SaveConfig()
                    for key, element in pairs(Elements) do
                        if ConfigData[key] ~= nil and element.Set then
                            pcall(function()
                                element:Set(ConfigData[key])
                            end)
                            task.wait(0.02)
                        end
                    end
                    cnotif("Config imported successfully!", 4)
                end
            })


            -- ═══ THEME SECTION ═══
            local ThemeSection = SettingsTab:AddSection("Theme")

            local themePresets = {
                ["Blue"]  = { color = Color3.fromRGB(150, 150, 150),  color2 = Color3.fromRGB(0, 0, 14) },
                ["Red"] = { color = Color3.fromRGB(255, 66, 66),  color2 = Color3.fromRGB(14, 0, 0) },
                ["Purple"]  = { color = Color3.fromRGB(160, 30, 255), color2 = Color3.fromRGB(10, 0, 14) },
            }

            ThemeSection:AddDropdown({
                Title   = "Theme",
                Options = { "Blue", "Red", "Purple" },
                Default = "Blue",
                Callback = function(value)
                    local preset = themePresets[value]
                    if preset then
                        Tabs:SetTheme(preset.color, preset.color2)
                    end
                end
            })
        end)
    end


    -- Kumpulkan referensi elemen warna yang bisa diubah secara dinamis
    local _themeColorElements = {
        titleLabel  = TextLabel,
        footerFrm   = FooterFrame,
        mainStroke  = MainStroke,
        decideFrm   = DecideFrame,
        tabDivider  = TabDivider,
        mainBG      = Main,
        topBar      = Top,
        executorFrm = Executor,
    }
    local _themeTabChooseFrames = {} -- referensi semua ChooseFrame tab

    function Tabs:SetTheme(newColor, newColor2)
        GuiConfig.Color  = newColor
        GuiConfig.Color2 = newColor2 or newColor

        -- Update topbar (Title & Footer text)
        -- TweenService:Create(_themeColorElements.titleLabel, TweenInfo.new(0.4), { TextColor3 = newColor }):Play()
        local chipSurface = newColor:Lerp(Color3.fromRGB(9, 34, 25), 0.9)
        if _themeColorElements.footerFrm then
            TweenService:Create(_themeColorElements.footerFrm, TweenInfo.new(0.4), {
                BackgroundColor3 = chipSurface
            }):Play()
        end
        if _themeColorElements.executorFrm then
            TweenService:Create(_themeColorElements.executorFrm, TweenInfo.new(0.4), {
                BackgroundColor3 = chipSurface
            }):Play()
        end

        -- Update border stroke, DecideFrame & TabDivider
        TweenService:Create(_themeColorElements.mainStroke, TweenInfo.new(0.4), {
            Color = newColor:Lerp(Color3.fromRGB(15, 60, 40), 0.75)
        }):Play()
        TweenService:Create(_themeColorElements.decideFrm, TweenInfo.new(0.4), {
            BackgroundColor3 = newColor:Lerp(Color3.fromRGB(15, 60, 40), 0.75),
            BackgroundTransparency = 0.65
        }):Play()
        if _themeColorElements.tabDivider then
            TweenService:Create(_themeColorElements.tabDivider, TweenInfo.new(0.4), {
                BackgroundColor3 = newColor:Lerp(Color3.fromRGB(15, 60, 40), 0.75),
                BackgroundTransparency = 0.65
            }):Play()
        end

        -- Solid tinted surfaces eliminate color banding entirely. Lerp keeps
        -- alternate themes dark while retaining a visible accent undertone.
        TweenService:Create(_themeColorElements.mainBG, TweenInfo.new(0.4), {
            BackgroundColor3 = newColor:Lerp(Color3.fromRGB(2, 14, 9), 0.93)
        }):Play()
        if _themeColorElements.topBar then
            TweenService:Create(_themeColorElements.topBar, TweenInfo.new(0.4), {
                BackgroundColor3 = newColor:Lerp(Color3.fromRGB(2, 14, 9), 0.93),
                BackgroundTransparency = 0.01
            }):Play()
        end

        -- Update ChooseFrame & UIStroke di semua tab
        for _, tab in ScrollTab:GetChildren() do
            if tab.Name == "Tab" then
                local cf = tab:FindFirstChild("ChooseFrame")
                if cf then
                    TweenService:Create(cf, TweenInfo.new(0.3), { BackgroundColor3 = newColor }):Play()
                    local stk = cf:FindFirstChildOfClass("UIStroke")
                    if stk then
                        TweenService:Create(stk, TweenInfo.new(0.3), { Color = newColor }):Play()
                    end
                end
            end
        end

        -- Update semua elemen di dalam ZeroinOnTop secara langsung
        for _, gui in ZeroinOnTop:GetDescendants() do
            if gui.Name == "SectionTitle" and gui:IsA("TextLabel") then
                local sectionReal = gui.Parent
                if sectionReal and sectionReal.Name == "SectionReal" then
                    local featureFrame = sectionReal:FindFirstChild("FeatureFrame")
                    -- Jika FeatureFrame tidak ada (AlwaysOpen=true) atau rotasinya 90 (terbuka)
                    if not featureFrame or featureFrame.Rotation > 45 then
                        TweenService:Create(gui, TweenInfo.new(0.4), { TextColor3 = Color3.fromRGB(255, 255, 255) }):Play()
                    end
                end
            end

            -- SubSection label
            if gui.Name == "SubSection" and gui:IsA("Frame") then
                local lbl = gui:FindFirstChildOfClass("TextLabel")
                if lbl then
                    TweenService:Create(lbl, TweenInfo.new(0.4), { TextColor3 = newColor }):Play()
                end
            end

            -- Divider gradient
            if gui.Name == "Divider" and gui:IsA("Frame") then
                local grad = gui:FindFirstChildOfClass("UIGradient")
                if grad then
                    grad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
                        ColorSequenceKeypoint.new(0.5, newColor),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
                    })
                end
            end

            -- Dropdown ChooseFrame option
            if gui.Name == "ChooseFrame" and gui:IsA("Frame") and gui.Parent and gui.Parent.Name == "Option" then
                TweenService:Create(gui, TweenInfo.new(0.3), { BackgroundColor3 = newColor }):Play()
                local stk = gui:FindFirstChildOfClass("UIStroke")
                if stk then
                    TweenService:Create(stk, TweenInfo.new(0.3), { Color = newColor }):Play()
                end
            end

            -- Toggle yang sedang ON (FeatureFrame.BackgroundTransparency ≈ 0)
            if gui.Name == "FeatureFrame" and gui:IsA("Frame") and gui.Parent and gui.Parent.Name == "Toggle" then
                if gui.BackgroundTransparency < 0.1 then
                    -- toggle ini ON, update warnanya langsung
                    TweenService:Create(gui, TweenInfo.new(0.3), { BackgroundColor3 = newColor }):Play()
                    local stk = gui:FindFirstChildOfClass("UIStroke")
                    if stk then
                        TweenService:Create(stk, TweenInfo.new(0.3), { Color = newColor }):Play()
                    end
                    -- update juga teks judul toggle yang ON
                    local toggleParent = gui.Parent
                    if toggleParent then
                        local ttl = toggleParent:FindFirstChild("ToggleTitle")
                        if ttl then
                            TweenService:Create(ttl, TweenInfo.new(0.3), { TextColor3 = newColor }):Play()
                        end
                    end
                end
            end

        end
    end

    return Tabs
end

-- -- ============================================================
-- -- UI TESTING / EXECUTION
-- -- ============================================================
-- local ICON_ID = "108203634075572"
-- local function notif(content, duration, title)
--     if Zeroin and Zeroin.MakeNotify then
--         Zeroin:MakeNotify({
--             Title   = title or "Zeroin",
--             Content = content,
--             Delay   = duration or 4,
--             Icon    = ICON_ID
--         })
--     end
-- end

-- local MarketplaceService = game:GetService("MarketplaceService")

-- local GameName = "Unknown"

-- pcall(function()
--     GameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
-- end)

-- local Window = Zeroin:Window({
--     Title    = "Zeroin",
--     Footer   = GameName,
--     Color    = Color3.fromRGB(150, 150, 150),
--     Color2   = Color3.fromRGB(0, 0, 14),
--     ["Tab Width"] = 130,
--     Image      = "76157300179532",
--     WindowIMG  = "91334002283698",
--     LogoHUB    = "122210019620425"
-- })
-- local Tabs = Window

-- local function LoadInfoTab()
--     local InfoTab = Tabs:AddTab({ Name = "About", Icon = "info" })
--     local InfoSection = InfoTab:AddSection("About Zeroin", true)

--     local inviteCode = "zeroinontop"
--     local discordLink = "https://discord.gg/" .. inviteCode

--     local DiscordParagraph = InfoSection:AddParagraph({
--         Title          = "Loading...",
--         Icon           = "nplnv4",
--         Content        = "Members: Loading... | Online: Loading...",
--         ButtonText     = "Copy Link",
--         ButtonCallback = function()
--             if setclipboard then
--                 setclipboard(discordLink)
--                 notif("Successfully copied the link!", 3, "Zeroin")
--             end
--         end
--     })

--     task.spawn(function()
--         pcall(function()
--             local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
--             local res
--             if req then
--                 res = req({
--                     Url = "https://discord.com/api/v9/invites/" .. inviteCode .. "?with_counts=true",
--                     Method = "GET"
--                 })
--                 res = res.Body
--             else
--                 res = game:HttpGet("https://discord.com/api/v9/invites/" .. inviteCode .. "?with_counts=true")
--             end
            
--             local decoded = game:GetService("HttpService"):JSONDecode(res)
--             if decoded and decoded.guild then
--                 DiscordParagraph:SetTitle(decoded.guild.name)
--                 DiscordParagraph:SetContent("Members: " .. tostring(decoded.approximate_member_count) .. " | Online: " .. tostring(decoded.approximate_presence_count))
--             end
--         end)
--     end)

-- 	InfoSection:AddButton({ Title = "Tes", Callback = function(value) end })
-- end

-- local function LoadMainTab()
--     local MainTab = Tabs:AddTab({ Name = "Main", Icon = "home" })
    
--     local DemoSection = MainTab:AddSection("Elements Showcase")

--     -- DemoSection:AddParagraph({
--     --     Title          = "Paragraph Demo",
--     --     Content        = "This is a paragraph example.\nYou can write multiline descriptions here.",
--     --     ButtonText     = "Click Me",
--     --     ButtonCallback = function()
--     --         notif("Paragraph button clicked!", 2)
--     --     end
--     -- })

--     -- DemoSection:AddButton({
--     --     Title = "Normal Button",
--     --     Callback = function()
--     --         notif("Normal button clicked!", 2)
--     --     end
--     -- })

--     -- DemoSection:AddButton({
--     --     Title       = "Dual Button",
--     --     SubTitle    = "Second Button",
--     --     Callback    = function()
--     --         notif("Main button clicked!", 2)
--     --     end,
--     --     SubCallback = function()
--     --         notif("Sub button clicked!", 2)
--     --     end
--     -- })

--     -- DemoSection:AddDivider()

--     -- DemoSection:AddSubSection("Toggles & Sliders")

--     DemoSection:AddToggle({
--         Title    = "Example Toggle",
--         Default  = false,
--         Keybind  = true,
--         Callback = function(value)
--             notif("Toggle is now: " .. tostring(value), 2)
--         end
--     })

--     -- DemoSection:AddSlider({
--     --     Title     = "Example Slider",
--     --     Increment = 1,
--     --     Min       = 1,
--     --     Max       = 100,
--     --     Default   = 50,
--     --     Callback  = function(value)
--     --         -- notif("Slider value: " .. tostring(value), 2)
--     --     end
--     -- })

--     -- DemoSection:AddDivider()

--     -- DemoSection:AddSubSection("Inputs & Dropdowns")

--     -- DemoSection:AddInput({
--     --     Title    = "Example Input",
--     --     Content  = "Type something and press enter",
--     --     Default  = "",
--     --     Callback = function(val)
--     --         notif("Input submitted: " .. tostring(val), 2)
--     --     end
--     -- })

--     -- DemoSection:AddInput({
--     --     Title    = "Example Input 2",
--     --     Callback = function(val)
--     --         notif("Input submitted: " .. tostring(val), 2)
--     --     end
--     -- })

--     -- DemoSection:AddPanel({
--     --     Title       = "Example Panel",
--     --     Placeholder = "Enter text here...",
--     --     ButtonText  = "Submit Panel",
--     --     Callback    = function(val)
--     --         notif("Panel submitted: " .. tostring(val), 2)
--     --     end
--     -- })

--     -- DemoSection:AddDropdown({
--     --     Title    = "Single Dropdown",
--     --     Content  = "Select one option",
--     --     Options  = { "Option 1", "Option 2", "Option 3" },
--     --     Default  = "Option 1",
--     --     Multi    = false,
--     --     Callback = function(val)
--     --         notif("Selected: " .. tostring(val), 2)
--     --     end
--     -- })

--     -- DemoSection:AddDropdown({
--     --     Title    = "Multi Dropdown",
--     --     Content  = "Select multiple options",
--     --     Options  = { "Apple", "Banana", "Orange" },
--     --     Default  = {"Apple"},
--     --     Multi    = true,
--     --     Callback = function(val)
--     --         -- val is a table of selected items
--     --     end
--     -- })
-- end

-- LoadInfoTab()
-- LoadMainTab()

-- -- Panggil fungsi untuk menambahkan tab config di urutan paling akhir
-- Tabs:AddConfigTab()

return Zeroin