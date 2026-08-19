-- -- -- ============================================================
-- -- -- CORE SECURITY: ANTI-HOOK, ANTI-SPY, & ANTI-TAMPER V3.2
-- -- -- ============================================================
local Proteksi = { Aman = true }

local function Banned(alasan)
    Proteksi.Aman = false
    local p = game:GetService("Players").LocalPlayer
    if p then
        p:Kick("Access Denied: " .. alasan)
    end
    task.wait(9e9)
end

pcall(function()
    local dummyEvent = Instance.new("RemoteEvent")
    local dummyFunc = Instance.new("RemoteFunction")

    local realFire = dummyEvent.FireServer
    local realInvoke = dummyFunc.InvokeServer

    if ishooked then
        if ishooked(realFire) and ishooked(realInvoke) then
            Banned("RemoteSpy Detected (FireServer & InvokeServer Hook)")
        end
    end

    if iscclosure and islclosure then
        if islclosure(realFire) and islclosure(realInvoke) then
            Banned("RemoteSpy Detected (Remote Closure Hook)")
        end
    end

    local KataTerlarang = {"hydroxide", "turtle spy", "cobalt", "bypasser", "remote spy", "simple spy", "ultimate debugging suite", "dark dex"}
    local SafeWords = {"codex", "index", "pokedex", "delta", "arceus", "fluxus", "hydrogen", "macsploit", "vegas", "evon", "furk", "trigon", "executor", "menu", "hub", "isylhub"}
    local IgnoreGuis = {"robloxgui", "chat", "bubblechat", "playerlist", "teleportgui", "robloxpromptgui", "purchaseprompt", "corescriptsroot"}

    local function isDexOrSpy(str)
        str = string.lower(str)
        if str == "dex" or str == "spy" then return false end

        if string.find(str, "dex") or string.find(str, "spy") then
            for _, safe in ipairs(SafeWords) do
                if string.find(str, safe) then return false end
            end
            return true
        end
        return false
    end

    task.spawn(function()
        while Proteksi.Aman do
            task.wait(3)
            local currentContainers = {game:GetService("CoreGui")}
            pcall(function() if gethui then table.insert(currentContainers, gethui()) end end)
            
            for _, container in ipairs(currentContainers) do
                pcall(function()
                    for _, ui in ipairs(container:GetChildren()) do
                        pcall(function()
                            local name = string.lower(ui.Name)
                            if table.find(IgnoreGuis, name) then return end

                            -- SCAN 1: Cek Nama dari UI (GUI Name)
                            for _, bad in ipairs(KataTerlarang) do
                                if string.find(name, bad) then Banned("Illegal UI Detected ("..bad..")") end
                            end
                            if isDexOrSpy(name) then Banned("Illegal UI Detected ("..name..")") end
                            
                            -- SCAN 2: Cek Isi Teks di dalam UI
                            for _, desc in pairs(ui:GetDescendants()) do
                                pcall(function()
                                    if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
                                        local text = string.lower(desc.Text)
                                        if string.len(text) < 40 then
                                            -- Kita HANYA mencari kata terlarang spesifik (seperti "dark dex")
                                            for _, bad in ipairs(KataTerlarang) do
                                                if string.find(text, bad) then
                                                    Banned("Illegal Text Element Detected ("..text..")")
                                                end
                                            end
                                            
                                            -- FIX V3.2:
                                            -- Pengecekan isDexOrSpy(text) DIHAPUS dari sini!
                                            -- Ini mencegah false positive saat ada notifikasi game/executor
                                            -- yang bertuliskan nama player seperti "you've joined dex".
                                        end
                                    end
                                end)
                            end
                        end)
                    end
                end)
            end
        end
    end)
end)

if not Proteksi.Aman then
    return 
end

-- ============================================================
-- KEY SYSTEM & TRACKING
-- ============================================================

local function showWarningUI(message)
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")
    local Key = Instance.new("TextLabel")
    local Description = Instance.new("TextLabel")
    local ButtonClose = Instance.new("TextButton")
    local UICorner_2 = Instance.new("UICorner")
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
    local Background = Instance.new("Frame")
    local UIStroke = Instance.new("UIStroke")

    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
    ScreenGui.ScreenInsets = Enum.ScreenInsets.None

    Background.Name = "Background"
    Background.Parent = ScreenGui
    Background.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    Background.BackgroundTransparency = 0.300
    Background.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Background.BorderSizePixel = 0
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.ZIndex = 0

    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    Frame.BackgroundTransparency = 0.100
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.248725787, 0, 0.40242058, 0)
    Frame.Size = UDim2.new(0.502548397, 0, 0.146747351, 0)

    UICorner.CornerRadius = UDim.new(0.0500000007, 0)
    UICorner.Parent = Frame
    
    UIStroke.Parent = Frame
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 1

    Title.Name = "Title"
    Title.Parent = Frame
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Title.BorderSizePixel = 0
    Title.Position = UDim2.new(0.198198214, 0, 0, 0)
    Title.Size = UDim2.new(0.6006006, 0, 0.289151847, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Napoleon | Warning"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    Title.TextSize = 14.000
    Title.TextWrapped = true

    Key.Name = "Key"
    Key.Parent = Frame
    Key.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Key.BackgroundTransparency = 1.000
    Key.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Key.BorderSizePixel = 0
    Key.Position = UDim2.new(0.22862418, 0, 0.550000012, 0)
    Key.Size = UDim2.new(0.533663452, 0, 0.154971421, 0)
    Key.Font = Enum.Font.GothamBold
    Key.Text = "discord.gg/napoleonsc"
    Key.TextColor3 = Color3.fromRGB(106, 106, 124)
    Key.TextScaled = true
    Key.TextSize = 14.000
    Key.TextWrapped = true

    Description.Name = "Description"
    Description.Parent = Frame
    Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Description.BackgroundTransparency = 1.000
    Description.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Description.BorderSizePixel = 0
    Description.Position = UDim2.new(0.060851898, 0, 0.306907117, 0)
    Description.Size = UDim2.new(0.871821165, 0, 0.216986924, 0)
    Description.Font = Enum.Font.Gotham
    Description.Text = message
    Description.TextColor3 = Color3.fromRGB(255, 255, 255)
    Description.TextScaled = true
    Description.TextSize = 14.000
    Description.TextWrapped = true

    ButtonClose.Name = "ButtonClose"
    ButtonClose.Parent = Frame
    ButtonClose.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    ButtonClose.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ButtonClose.BorderSizePixel = 0
    ButtonClose.Position = UDim2.new(0.385395527, 0, 0.747835159, 0)
    ButtonClose.Size = UDim2.new(0.229208946, 0, 0.206185549, 0)
    ButtonClose.Font = Enum.Font.GothamBold
    ButtonClose.Text = "Close"
    ButtonClose.TextColor3 = Color3.fromRGB(255, 255, 255)
    ButtonClose.TextScaled = true
    ButtonClose.TextSize = 14.000
    ButtonClose.TextWrapped = true

    UICorner_2.CornerRadius = UDim.new(1, 0)
    UICorner_2.Parent = ButtonClose

    UITextSizeConstraint.Parent = ButtonClose
    UITextSizeConstraint.MaxTextSize = 14
    
    ButtonClose.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
end

local HttpService = game:GetService("HttpService")
local key = getgenv().Key or _G.Key

if not key then
    showWarningUI("Key tidak ditemukan! Silahkan masukkan getgenv().Key")
    return
end

local hwid = tostring(game:GetService("Players").LocalPlayer.UserId)
local mySessionNonce = HttpService:GenerateGUID(false)
local checkUrl = "http://napoleon-script.my.id/api/check?key=" .. key .. "&hwid=" .. hwid .. "&nonce=" .. mySessionNonce

local function decryptXOR(hexStr, secretKey)
    local result = ""
    local charIdx = 0
    for i = 1, #hexStr, 2 do
        local hexByte = hexStr:sub(i, i + 1)
        local byte = tonumber(hexByte, 16)
        if not byte then return nil end
        local keyChar = secretKey:byte((charIdx % #secretKey) + 1)
        result = result .. string.char(bit32.bxor(byte, keyChar))
        charIdx = charIdx + 1
    end
    return result
end

local SECRET_KEY = "HOEEEE_MALING_PANGSIT"

local successCheck, responseCheck = pcall(function()
    return game:HttpGet(checkUrl)
end)

if successCheck then
    local decrypted = decryptXOR(responseCheck, SECRET_KEY)
    
    if decrypted then
        local splitPos = decrypted:find("|")
        if splitPos then
            local timestampStr = decrypted:sub(1, splitPos - 1)
            local jsonStr = decrypted:sub(splitPos + 1)
            
            local serverTime = tonumber(timestampStr)
            local localTime = workspace:GetServerTimeNow()
            
            if serverTime and math.abs(localTime - serverTime) > 60 then
                showWarningUI("Sesi kadaluarsa / Bypass terdeteksi! (Time Mismatch)")
                return
            end
            
            local ok, data = pcall(function() return HttpService:JSONDecode(jsonStr) end)
            if ok and type(data) == "table" then
                
                if data.nonce ~= mySessionNonce then
                    game.Players.LocalPlayer:Kick("Security Alert: HTTP Spoofing / Hooking Terdeteksi!")
                    while true do end 
                end

                if not data.valid then
                    showWarningUI(data.message or "Key tidak valid / Belum reset HWID!")
                    return
                end
            else
                showWarningUI("Invalid response (Bukan JSON) dari server.")
                return
            end
        else
            showWarningUI("Format data dari server tidak valid!")
            return
        end
    else
        showWarningUI("Gagal mendekripsi data dari server.")
        return
    end
else
    showWarningUI("Gagal terhubung ke server validasi key.")
    return
end

-- ============================================================
-- TRACKING
-- ============================================================
local function getExecutorName()
    if identifyexecutor then return identifyexecutor() end
    if syn then return "Synapse X"
    elseif Ronix then return "Ronix"
    elseif fluxus then return "Fluxus"
    elseif DELTA_VERSION then return "Delta"
    else return "Unknown" end
end

task.spawn(function()
    pcall(function()
        -- Menggunakan waktu server global untuk log agar tidak dipalsukan jam lokal
        local currentTime = workspace:GetServerTimeNow()
        local logPath = "Napoleon_SlimeRNG_LastExec.txt"
        
        if isfile and readfile and writefile then
            if isfile(logPath) then
                local lastTime = tonumber(readfile(logPath))
                if lastTime and (currentTime - lastTime) < 3600 then
                    return 
                end
            end
            writefile(logPath, tostring(currentTime))
        else
            if getgenv()._Napoleon_ExecLogged_Slime then return end
            getgenv()._Napoleon_ExecLogged_Slime = true
        end

        local player = game:GetService("Players").LocalPlayer
        if player then
            local userid = tostring(player.UserId)
            local username = player.Name
            local executor = getExecutorName()
            local placeid = tostring(game.PlaceId)
            
            local url = "http://napoleon-script.my.id/api/track"
                .. "?script=slime-rng"
                .. "&userid=" .. userid
                .. "&username=" .. username
                .. "&executor=" .. (executor:gsub(" ", "%%20"))
                .. "&placeid=" .. placeid
                .. "&key=" .. key
                
            game:HttpGet(url)
        end
    end)
end)

-- ============================================================
-- Napoleon UI Library
-- ============================================================
_G.ScriptFullyLoaded = false

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Fdhlnn23/NapoleonUI/refs/heads/main/NPLN-UIv2.lua"))()

local ICON_ID = "96531489912535"

local function notif(content, duration, title)
    if not _G.ScriptFullyLoaded then return end
    if Library and Library.MakeNotify then
        Library:MakeNotify({ Title = title or "Napoleon", Content = content, Delay = duration or 4, Icon = "rbxassetid://" .. ICON_ID })
    end
end

-- ============================================================
-- SERVICES & CORE
-- ============================================================
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer       = Players.LocalPlayer
local VirtualUser       = game:GetService("VirtualUser")

-- Posisi zona fight
local FIGHT_CFRAME = CFrame.new(284.34, 10.83, 333.00) * CFrame.Angles(0, math.rad(89.17), 0)

local function TeleportTo(cf)
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = cf end
end

-- Equip kembali barbel saat farm berhenti
-- Deteksi otomatis via Attribute "Kind" == "Weight"
-- Retry beberapa kali karena karakter mungkin masih dalam state fight
local function EquipBarbel()
    task.spawn(function()
        -- Coba equip hingga 5x dengan jeda bertambah (0.5s, 1.0s, 1.5s, 2.0s, 2.5s)
        for attempt = 1, 5 do
            task.wait(attempt * 0.5)

            local done = false
            pcall(function()
                local char = LocalPlayer.Character
                local hum  = char and char:FindFirstChildOfClass("Humanoid")
                if not hum or hum.Health <= 0 then return end

                -- Cek apakah sudah ter-equip di tangan
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") and tool:GetAttribute("Kind") == "Weight" then
                        done = true  -- sudah equipped, berhenti retry
                        return
                    end
                end

                -- Cari di Backpack
                for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool:GetAttribute("Kind") == "Weight" then
                        hum:EquipTool(tool)
                        done = true
                        return
                    end
                end
            end)

            if done then break end  -- berhasil, tidak perlu retry lagi
        end
    end)
end

-- ============================================================
-- CONFIG STATE
-- ============================================================
local Config = {
    FarmEnabled  = false,           -- Intent user (toggle ON/OFF)
    AutoFarm     = false,           -- Farm benar-benar aktif sekarang
    AutoX2       = false,           -- Auto X2 Power Boost pop-up
    EventTrigger = {["None"]=true}, -- Set event yang dipilih (multi)
    SnapMutation = {["None"]=true}, -- Set mutasi target untuk snap (multi)
}

-- (isSetNone, IsAnySelectedEventActive, GetSelectedActiveEventNames
--  didefinisikan di bawah, setelah IsEventActive tersedia)

-- ============================================================
-- DATA DARI EXPORTED SCRIPTS
-- EventsData.lua → daftar semua event dengan key internal
-- MutationsData.lua → daftar semua mutasi
-- ============================================================

-- Event list: key internal → display name (urut berdasarkan Order)
local EVENT_LIST = {
    "None",
    "Tacos",
    "Galaxy",
    "Disco",
    "Lucky",
    "Hacker",
    "RainbowStar",
    "SunBurst",
    "Sand",
    "Fire",
}
local EVENT_DISPLAY = {
    ["None"]       = "None (Manual)",
    ["Tacos"]      = "Tacos",
    ["Galaxy"]     = "Galaxy",
    ["Disco"]      = "Disco",
    ["Lucky"]      = "Lucky",
    ["Hacker"]     = "Hacker",
    ["RainbowStar"]= "Rainbow Star",
    ["SunBurst"]   = "Sun Burst",
    ["Sand"]       = "Sandstorm",
    ["Fire"]       = "Fire",
}

-- Mutation list: "None" = tidak snap / abaikan apapun
-- Hanya yang HasThemeMutation + mutasi reguler (Weight > 0) yang relevan
local MUTATION_LIST = {
    "None",
    "Gold",
    "Diamond",
    "Sand",
    "Fire",
    "SunBurst",
    "RainbowStar",
    "Hacker",
    "Tacos",
    "Galaxy",
    "Disco",
}
local MUTATION_DISPLAY = {
    ["None"]       = "None (Farm Semua)",
    ["Gold"]       = "Gold (x1.2)",
    ["Diamond"]    = "Diamond (x1.4)",
    ["Sand"]       = "Sand (x1.8)",
    ["Fire"]       = "Fire (x2.2)",
    ["SunBurst"]   = "Sun Burst (x2.5)",
    ["RainbowStar"]= "Rainbow Star (x3.0)",
    ["Hacker"]     = "Hacker (x4.0) ⚡",
    ["Tacos"]      = "Tacos (x2.25) [Event]",
    ["Galaxy"]     = "Galaxy (x2.6) [Event]",
    ["Disco"]      = "Disco (x2.7) [Event]",
}

-- ============================================================
-- SINCY CHANNEL HELPERS
-- ============================================================
local ConsPackages   = require(ReplicatedStorage.ConsPackages)
local SincyClient    = ConsPackages.Sincy.Client

local _fightCh   = nil
local _eventsCh  = nil

local function GetFightChannel()
    if _fightCh then return _fightCh end
    local ok, ch = pcall(function()
        return SincyClient.WaitChannel(("Fighting_%*"):format(LocalPlayer.UserId), 0)
    end)
    if ok and ch then _fightCh = ch end
    return _fightCh
end

local function GetEventsChannel()
    if _eventsCh then return _eventsCh end
    local ok, ch = pcall(function()
        -- SincyChannelName dari EventsConfig.lua = "Events"
        return SincyClient.WaitChannel("Events", 0)
    end)
    if ok and ch then _eventsCh = ch end
    return _eventsCh
end

-- Cek apakah event tertentu sedang aktif di server
-- EventsController.lua: ActiveEvents adalah dictionary di Sincy channel "Events"
local function IsEventActive(eventKey)
    if eventKey == "None" or eventKey == nil then return false end
    local ch = GetEventsChannel()
    if not ch then return false end
    local activeEvents = ch:GetData("ActiveEvents")
    return typeof(activeEvents) == "table" and activeEvents[eventKey] ~= nil
end

-- Helper: cek apakah "None" adalah satu-satunya pilihan (= fitur off)
local function isSetNone(set)
    if not next(set) then return true end  -- set kosong = dianggap None
    return set["None"] == true
end

-- Helper: cek apakah salah satu event yang dipilih sedang aktif
local function IsAnySelectedEventActive()
    if isSetNone(Config.EventTrigger) then return false end
    for key in pairs(Config.EventTrigger) do
        if key ~= "None" and IsEventActive(key) then return true end
    end
    return false
end

-- Helper: daftar nama event yang sedang aktif dari pilihan user
local function GetSelectedActiveEventNames()
    local names = {}
    for key in pairs(Config.EventTrigger) do
        if key ~= "None" and IsEventActive(key) then
            table.insert(names, EVENT_DISPLAY[key] or key)
        end
    end
    return names
end

-- Ambil semua event yang sedang aktif (untuk status display)
local function GetActiveEvents()
    local ch = GetEventsChannel()
    if not ch then return {} end
    local activeEvents = ch:GetData("ActiveEvents")
    if typeof(activeEvents) ~= "table" then return {} end
    local list = {}
    for k in activeEvents do table.insert(list, k) end
    return list
end

-- Fight state helpers
local function GetFightData()
    local ch = GetFightChannel()
    if not ch then return nil end
    local data = ch:GetData()
    return typeof(data) == "table" and data or nil
end

local function IsFightActive()
    local d = GetFightData()
    return d ~= nil and d.Active == true
end

-- Ambil mutasi dari block yang sedang di-fight
-- FightingController.lua: data.Block.Mutation (string, bisa nil)
local function GetCurrentMutation()
    local d = GetFightData()
    if not d then return nil end
    local block = d.Block
    if typeof(block) ~= "table" then return nil end
    local mut = block.Mutation
    return typeof(mut) == "string" and mut ~= "" and mut or nil
end

-- ============================================================
-- REMOTE EVENTS
-- Link.lua: v8.Fire = FireServer via RemoteEvents folder
-- ============================================================
local RE             = ReplicatedStorage.ConsPackages.Link.RemoteEvents
local DamageBoostClick = RE:WaitForChild("DamageBoostClick", 10)
local StopFightRemote  = RE:FindFirstChild("StopFight")

-- ============================================================
-- ANTI-AFK
-- ============================================================
getgenv().AntiAFKEnabled = true

task.spawn(function()
    pcall(function()
        local gc = getconnections or get_signal_cons
        if gc then
            for _, conn in pairs(gc(LocalPlayer.Idled)) do
                if conn.Disable then conn:Disable() end
            end
        end
    end)
end)

task.spawn(function()
    local VIM = game:GetService("VirtualInputManager")
    while true do
        task.wait(60)
        if not getgenv().AntiAFKEnabled then continue end
        pcall(function() VIM:SendMouseMoveEvent(0, 0, game) end)
        pcall(function() VIM:SendTouchEvent(0, Enum.UserInputState.Change, 0, 0, game) end)
        pcall(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(0.1)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

LocalPlayer.Idled:Connect(function()
    if getgenv().AntiAFKEnabled then
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end
end)

-- ============================================================
-- WINDOW UI
-- ============================================================
local Window = Library:Window({
    Title     = "Napoleon",
    Footer    = "Fight A Lucky Block",
    Color     = Color3.fromRGB(255, 255, 255),
    Color2    = Color3.fromRGB(192, 192, 192),
    ["Tab Width"] = 130,
    Image     = "136289055140268",
    WindowIMG = "93732999692312",
    LogoHUB   = "136289055140268"
})
local Tabs = Window

-- ─── TAB INFO ───
local function LoadInfoTab()
    local InfoTab     = Tabs:AddTab({ Name = "Info", Icon = "info" })
    local InfoSection = InfoTab:AddSection("Napoleon — Fight A Lucky Block", true)
    InfoSection:AddParagraph({
        Title   = "📋 Script Info",
        Content = "Event-based Auto Farm: aktif otomatis saat event yang dipilih live. Snap Mutation: stop fight langsung jika mutasi tidak sesuai target."
    })
    InfoSection:AddButton({
        Title    = "Join Discord",
        Callback = function()
            if setclipboard then
                setclipboard("https://discord.gg/RKaZ9vEbpb")
                notif("Discord link copied!", 3, "Napoleon")
            else
                notif("discord.gg/RKaZ9vEbpb", 5, "Napoleon")
            end
        end
    })
end

-- Referensi global toggle Auto Farm (untuk sync UI dari loop event)
local _AutoFarmToggleRef = nil

-- ─── TAB MAIN ───
local function LoadMainTab()
    local MainTab = Tabs:AddTab({ Name = "Main", Icon = "rod" })

    -- ── SECTION: AUTO FARM (semua dalam 1 section) ──
    local FarmSection = MainTab:AddSection("Auto Farm")

    -- Simpan referensi toggle agar bisa di-set ulang secara programatik
    local AutoFarmToggle
    AutoFarmToggle = FarmSection:AddToggle({
        Title    = "Auto Farm",
        Title2   = "Enable",
        Content  = "Aktifkan manual (jika Event Trigger = None). Jika event dipilih, hanya aktif saat event live.",
        Default  = false,
        Callback = function(val)
            Config.FarmEnabled = val
            if val then
                local noEventSelected = isSetNone(Config.EventTrigger)
                if noEventSelected then
                    -- Mode manual: langsung aktif
                    Config.AutoFarm = true
                    pcall(TeleportTo, FIGHT_CFRAME)
                    notif("Auto Farm Aktif ✅", 3, "Napoleon")
                else
                    -- Mode event: standby, tunggu event muncul
                    Config.AutoFarm = false
                    if IsAnySelectedEventActive() then
                        Config.AutoFarm = true
                        pcall(TeleportTo, FIGHT_CFRAME)
                        local names = GetSelectedActiveEventNames()
                        notif("🚀 Event aktif: " .. table.concat(names, ", ") .. " → Farm dimulai!", 4, "Napoleon")
                    else
                        EquipBarbel()
                        local keys = {}
                        for k in pairs(Config.EventTrigger) do if k ~= "None" then table.insert(keys, EVENT_DISPLAY[k] or k) end end
                        notif("⏳ Standby... menunggu event: " .. table.concat(keys, ", "), 5, "Napoleon")
                    end
                end
            else
                Config.FarmEnabled = false
                Config.AutoFarm = false
                EquipBarbel()  -- retry internal, non-blocking
                notif("Auto Farm Nonaktif ❌", 3, "Napoleon")
            end
        end
    })
    -- Expose ke scope luar agar loop event monitor bisa sync toggle UI
    _AutoFarmToggleRef = AutoFarmToggle

    -- Dropdown 1: Event Trigger (MULTI)
    local eventDropItems = {}
    for _, key in ipairs(EVENT_LIST) do
        table.insert(eventDropItems, EVENT_DISPLAY[key] or key)
    end

    -- Helper: Napoleon UI multi-dropdown bisa return dict {displayName=true} ATAU array {"displayName"}
    -- Fungsi ini handle kedua format dan map ke internal key
    local function parseEventDropdown(val)
        local newSet = {}
        if type(val) == "table" then
            for k, v in pairs(val) do
                local displayName
                if type(k) == "string" and v == true then
                    displayName = k  -- format dict: {["Hacker ⚡"] = true}
                elseif type(k) == "number" and type(v) == "string" then
                    displayName = v  -- format array: {1 = "Hacker ⚡"}
                end
                if displayName then
                    for _, key in ipairs(EVENT_LIST) do
                        if (EVENT_DISPLAY[key] or key) == displayName then
                            newSet[key] = true
                            break
                        end
                    end
                end
            end
        elseif type(val) == "string" then
            for _, key in ipairs(EVENT_LIST) do
                if (EVENT_DISPLAY[key] or key) == val then
                    newSet[key] = true; break
                end
            end
        end
        if not next(newSet) or newSet["None"] then
            newSet = {["None"] = true}
        end
        return newSet
    end

    FarmSection:AddDropdown({
        Title   = "Event Trigger",
        Options = eventDropItems,
        Default = {EVENT_DISPLAY["None"]},
        Multi   = true,
        Callback = function(val)
            local newSet = parseEventDropdown(val)
            Config.EventTrigger = newSet

            if newSet["None"] then
                notif("Event Trigger nonaktif (manual mode)", 3, "Napoleon")
                -- Jika toggle farm sedang nyala, langsung farm
                if Config.FarmEnabled then
                    Config.AutoFarm = true
                    pcall(TeleportTo, FIGHT_CFRAME)
                end
            else
                local keys = {}
                for k in pairs(newSet) do table.insert(keys, EVENT_DISPLAY[k] or k) end
                -- Cek langsung apakah ada yang aktif sekarang
                if IsAnySelectedEventActive() then
                    -- Auto-aktifkan farm sekarang juga (tidak perlu toggle manual)
                    Config.FarmEnabled = true
                    Config.AutoFarm = true
                    pcall(TeleportTo, FIGHT_CFRAME)
                    -- Sync toggle UI ke ON
                    if _AutoFarmToggleRef and _AutoFarmToggleRef.Set then
                        task.defer(function() _AutoFarmToggleRef:Set(true) end)
                    end
                    local names = GetSelectedActiveEventNames()
                    notif("🚀 Event " .. table.concat(names, ", ") .. " AKTIF → Farm langsung dimulai!", 4, "Napoleon")
                else
                    -- Jika event tidak aktif, masuk ke standby mode
                    Config.AutoFarm = false
                    EquipBarbel()
                    notif("⏳ Standby menunggu event: " .. table.concat(keys, ", "), 4, "Napoleon")
                end
            end
        end
    })

    -- Dropdown 2: Snap Mutation (MULTI)
    local mutDropItems = {}
    for _, key in ipairs(MUTATION_LIST) do
        table.insert(mutDropItems, MUTATION_DISPLAY[key] or key)
    end

    local function parseMutDropdown(val)
        local newSet = {}
        if type(val) == "table" then
            for k, v in pairs(val) do
                local displayName
                if type(k) == "string" and v == true then
                    displayName = k
                elseif type(k) == "number" and type(v) == "string" then
                    displayName = v
                end
                if displayName then
                    for _, key in ipairs(MUTATION_LIST) do
                        if (MUTATION_DISPLAY[key] or key) == displayName then
                            newSet[key] = true; break
                        end
                    end
                end
            end
        elseif type(val) == "string" then
            for _, key in ipairs(MUTATION_LIST) do
                if (MUTATION_DISPLAY[key] or key) == val then
                    newSet[key] = true; break
                end
            end
        end
        if not next(newSet) or newSet["None"] then
            newSet = {["None"] = true}
        end
        return newSet
    end

    FarmSection:AddDropdown({
        Title   = "Snap Mutation",
        Options = mutDropItems,
        Default = {MUTATION_DISPLAY["None"]},
        Multi   = true,
        Callback = function(val)
            local newSet = parseMutDropdown(val)
            Config.SnapMutation = newSet
            if newSet["None"] then
                notif("Snap nonaktif → farm semua mutasi", 3, "Napoleon")
            else
                local names = {}
                for k in pairs(newSet) do table.insert(names, MUTATION_DISPLAY[k] or k) end
                notif("Snap aktif → target: " .. table.concat(names, ", "), 3, "Napoleon")
            end
        end
    })

    -- Button cek event aktif
    FarmSection:AddButton({
        Title    = "Cek Event Aktif Sekarang",
        Callback = function()
            local activeList = GetActiveEvents()
            if #activeList == 0 then
                notif("Tidak ada event aktif saat ini.", 4, "Napoleon")
            else
                notif("Event aktif: " .. table.concat(activeList, ", "), 5, "Napoleon")
            end
        end
    })

    -- ── SECTION: AUTO POWER BOOST ──
    local PowerSection = MainTab:AddSection("Auto Power Boost")

    PowerSection:AddToggle({
        Title    = "Auto X2",
        Title2   = "Enable",
        Content  = "Auto click tombol X2 Power Boost saat pop-up muncul",
        Default  = false,
        Callback = function(val)
            Config.AutoX2 = val
            notif(val and "Auto X2 Aktif ⚡" or "Auto X2 Nonaktif", 3, "Napoleon")
        end
    })
end

-- ─── TAB MISC ───
local function LoadMiscTab()
    local MiscTab = Tabs:AddTab({ Name = "Misc", Icon = "rbxassetid://130986441300365" })

    local AntiAFKSection = MiscTab:AddSection("Anti AFK")
    AntiAFKSection:AddToggle({
        Title    = "Anti AFK",
        Title2   = "Enable",
        Content  = "Mencegah kick AFK dengan simulasi input.",
        Default  = true,
        Callback = function(val)
            getgenv().AntiAFKEnabled = val
            notif(val and "Anti AFK Aktif" or "Anti AFK Nonaktif", 3, "Napoleon")
        end
    })
end

LoadInfoTab()
LoadMainTab()
LoadMiscTab()

-- ============================================================
-- AUTO CLICK LOGIC
-- ============================================================
local function ClickButton(button)
    if getconnections then
        for _, connection in ipairs(getconnections(button.MouseButton1Click)) do
            pcall(function() connection:Fire() end)
        end
        for _, connection in ipairs(getconnections(button.Activated)) do
            pcall(function() connection:Fire() end)
        end
    end
    if firesignal then
        pcall(function() firesignal(button.MouseButton1Click) end)
        pcall(function() firesignal(button.Activated) end)
    end
end

-- Auto X2: cari tombol X2 Power Boost di LocalToSpawnPopUps
task.spawn(function()
    while true do
        task.wait(0.05)
        if Config.AutoX2 then
            pcall(function()
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    local mainScreen = playerGui:FindFirstChild("MainScreen")
                    if mainScreen then
                        local hud = mainScreen:FindFirstChild("HUD")
                        if hud then
                            local popups = hud:FindFirstChild("LocalToSpawnPopUps")
                            if popups then
                                local imgBtn = popups:FindFirstChild("ImageButton")
                                if imgBtn and imgBtn:IsA("ImageButton") and imgBtn.Visible and popups.Visible then
                                    ClickButton(imgBtn)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ============================================================
-- LOOP 1: Monitor Event Aktif via Sincy "Events" Channel
-- EventsController.lua: ActiveEvents = dictionary di channel "Events"
-- Saat event yang dipilih muncul  → nyalakan farm
-- Saat event yang dipilih hilang  → matikan farm
-- ============================================================
task.spawn(function()
    -- Tunggu sampai Sincy channel "Events" siap (bisa butuh beberapa detik)
    local eventsCh = nil
    while not eventsCh do
        task.wait(2)
        eventsCh = GetEventsChannel()
    end

    local lastEventState = false

    while true do
        task.wait(1)

        -- Kalau mode manual (None), skip event monitor
        if isSetNone(Config.EventTrigger) then
            lastEventState = false
            continue
        end

        local activeNow = IsAnySelectedEventActive()

        -- Salah satu event yang dipilih baru menyala
        if activeNow and not lastEventState then
            if Config.FarmEnabled then
                Config.AutoFarm = true
                pcall(TeleportTo, FIGHT_CFRAME)
                local names = GetSelectedActiveEventNames()
                notif("🟢 Event " .. table.concat(names, ", ") .. " AKTIF → Auto Farm menyala!", 5, "Napoleon")
            end

        -- Semua event yang dipilih sudah selesai
        elseif not activeNow and lastEventState then
            Config.AutoFarm = false
            EquipBarbel()  -- retry internal, non-blocking
            if Config.FarmEnabled then
                notif("🔴 Semua event selesai → Barbel di-equip, standby...", 5, "Napoleon")
            end
        end

        lastEventState = activeNow
    end
end)

-- ============================================================
-- SNAP via Notification/Show Hook
-- Server kirim "Mutation acquired: X!" lewat RemoteEvent ini
-- Jauh lebih cepat dari polling Sincy (real-time, tidak ada delay)
-- ============================================================

-- Flag per-fight: apakah sudah menerima notif mutasi di fight ini?
-- Reset setiap fight baru dimulai (di Loop 3)
local _mutationNotifReceived = false

local NotifShowEvent = RE:FindFirstChild("Notification/Show")
if not NotifShowEvent then
    pcall(function()
        NotifShowEvent = RE:WaitForChild("Notification/Show", 5)
    end)
end

if NotifShowEvent then
    NotifShowEvent.OnClientEvent:Connect(function(message, notifType)
        if not Config.AutoFarm then return end
        if type(message) ~= "string" then return end

        -- Parse format: "Mutation acquired: Diamond!"
        local mutName = message:match("Mutation acquired: (.-)!")
        if not mutName then return end

        -- Tandai bahwa fight ini memang ada mutasi
        _mutationNotifReceived = true

        local snapSet = Config.SnapMutation
        if isSetNone(snapSet) then return end -- snap tidak aktif

        if snapSet[mutName] then
            -- ✅ Match!
            notif(
                string.format("✅ Snap Match! %s → terus fight!", MUTATION_DISPLAY[mutName] or mutName),
                4, "Napoleon"
            )
        else
            -- ❌ Bukan target → stop fight
            if StopFightRemote then
                pcall(function() StopFightRemote:FireServer() end)
            end
            local targetNames = {}
            for k in pairs(snapSet) do
                if k ~= "None" then table.insert(targetNames, MUTATION_DISPLAY[k] or k) end
            end
            notif(
                string.format("⚡ Snap! %s bukan target (%s) → Stop!",
                    mutName, table.concat(targetNames, "/")
                ), 4, "Napoleon"
            )
        end
    end)
else
    warn("[Napoleon] Notification/Show event tidak ditemukan.")
end

-- ============================================================
-- LOOP 2: Spam DamageBoostClick — 20x/detik
-- MaxClicksPerSec = 20 dari Balance/Combat.lua
-- ============================================================
task.spawn(function()
    local INTERVAL = 1 / 20
    while true do
        task.wait(INTERVAL)
        if Config.AutoFarm and DamageBoostClick then
            pcall(function() DamageBoostClick:FireServer() end)
        end
    end
end)

-- ============================================================
-- LOOP 3: CORE AUTO FARM — Re-entry + Snap Fallback
-- Dua mekanisme snap:
--   1. Hook Notification/Show → deteksi mutasi CEPAT (real-time)
--   2. Timer fallback → kalau ~3 detik tidak ada notif mutasi, 
--      berarti block tidak punya mutasi → stop jika snap aktif
--      dan "None" tidak ada di target set
-- ============================================================
-- Waktu tunggu sebelum dianggap "tidak ada mutasi" (detik)
local SNAP_NO_MUT_TIMEOUT = 3.5

task.spawn(function()
    while true do
        task.wait(0.5)
        if not Config.AutoFarm then continue end

        local ch = GetFightChannel()
        if not ch then continue end

        -- Tidak ada fight → TP ke posisi
        if not IsFightActive() then
            pcall(TeleportTo, FIGHT_CFRAME)
            task.wait(1)
            continue
        end

        -- ── Fight baru dimulai ──
        -- Reset flag mutasi untuk fight ini
        _mutationNotifReceived = false
        local fightStartTime = tick()
        local snapStopped = false

        -- Tunggu fight selesai, sambil cek snap no-mutation fallback
        while IsFightActive() and Config.AutoFarm do
            task.wait(0.2)

            -- Cek snap fallback: kalau sudah lewat SNAP_NO_MUT_TIMEOUT detik
            -- dan belum ada notif mutasi → block ini tidak punya mutasi
            if not snapStopped
               and not isSetNone(Config.SnapMutation)            -- snap aktif
               and not _mutationNotifReceived                    -- belum ada notif mutasi
               and not Config.SnapMutation["None"]               -- "None" tidak di target
               and (tick() - fightStartTime) >= SNAP_NO_MUT_TIMEOUT
            then
                -- Block tidak punya mutasi, tapi user mau mutasi → SNAP
                if StopFightRemote then
                    pcall(function() StopFightRemote:FireServer() end)
                end
                local targetNames = {}
                for k in pairs(Config.SnapMutation) do
                    if k ~= "None" then table.insert(targetNames, MUTATION_DISPLAY[k] or k) end
                end
                notif(
                    string.format("⚡ Snap! Block tanpa mutasi (target: %s) → Stop!",
                        table.concat(targetNames, "/")
                    ), 4, "Napoleon"
                )
                snapStopped = true
            end
        end

        -- Fight selesai → re-enter
        if Config.AutoFarm then
            task.wait(0.35)
            pcall(TeleportTo, FIGHT_CFRAME)
        end
    end
end)

_G.ScriptFullyLoaded = true
notif("Script loaded! Event Farm + Snap Ready 🎯", 5, "Napoleon")
