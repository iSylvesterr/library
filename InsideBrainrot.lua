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
-- Napoleon | Inside Brainrot Auto Farm
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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local VirtualUser       = game:GetService("VirtualUser")
local LocalPlayer       = Players.LocalPlayer

-- ============================================================
-- REMOTES (toleran terhadap perubahan versi remo)
-- ============================================================
local EnterNestEvent, LeaveNestEvent

pcall(function()
    local pkgIndex = ReplicatedStorage:WaitForChild("packages", 10)
                        :WaitForChild("_Index", 10)
    for _, child in ipairs(pkgIndex:GetChildren()) do
        if child.Name:find("littensy_remo") then
            local container = child:FindFirstChild("remo")
                              and child.remo:FindFirstChild("container")
            if container then
                EnterNestEvent = container:FindFirstChild("game.nest.enterNest")
                LeaveNestEvent  = container:FindFirstChild("game.nest.leaveNest")
            end
            break
        end
    end
end)

-- ============================================================
-- RARITY MAP  (dari Brainrots_Dump.lua)
-- ============================================================
local BRAINROT_RARITY_MAP = {
    -- Common
    talpaDiFerro = "Common", pipiKiwi = "Common", porkupine = "Common",
    -- Uncommon
    pipiAvocado = "Uncommon", pipiCorni = "Uncommon",
    bonecaAmbalabu = "Uncommon", bambiniCrostini = "Uncommon",
    -- Rare
    brainrot21 = "Rare", penguinoCocosino = "Rare",
    bananitaDolphinita = "Rare", pepperoniPenguino = "Rare", chimpanziniBananini = "Rare",
    -- Epic
    brrBrrPatapim = "Epic", penguinoPhone = "Epic", foxitaAnanasita = "Epic",
    blueberriniOctopusini = "Epic", tungTungTungSahur = "Epic",
    -- Legendary
    avocadiniGuffo = "Legendary", banditoBobritto = "Legendary",
    cactoHipopotamo = "Legendary", trippiTroppi = "Legendary", brainrot67 = "Legendary",
    -- Mythical
    brainrot76 = "Mythical", ballerinaCappuccina = "Mythical", brainrot69 = "Mythical",
    liriliLarila = "Mythical", cappuccinoAssassino = "Mythical",
    -- Secret
    strawberelliFlamingelli = "Secret", bombardinoCrocodilo = "Secret",
    tralaleroTralala = "Secret", trubobuzzoFrazzolopoulos = "Secret",
    meowl = "Secret", los67 = "Secret", pinkMedussi = "Secret",
    -- Cosmic
    headlessHorse = "Cosmic", blueElephant = "Cosmic", dragonCannelloni = "Cosmic",
    spookyCombinasion = "Cosmic", laCasaBoo = "Cosmic",
    -- Divine
    grappellinoDoro = "Divine", strawberryElephant = "Divine",
    galactioFantasma = "Divine", martinoGravitino = "Divine",
    cupitronUFO = "Divine", dinDinValluero = "Divine",
    sadoSkeletono = "Divine", stoupoTraffico = "Divine",
    -- Celestial
    rubichettoCubini = "Celestial", wOrL = "Celestial", crostinaGelifio = "Celestial",
    glacierelloInfernitti = "Celestial", potatoRider = "Celestial",
    rubickPlanet = "Celestial", dugdug = "Celestial", udinDinDun = "Celestial", frogzoSoda = "Celestial",
    -- Infinity
    techScorpio = "Infinity", techDimon = "Infinity", grappeminoDojo = "Infinity", sadoBananito = "Infinity",
    -- Singularity
    fireCappuccino = "Singularity", fireMedusa = "Singularity", fireDragon = "Singularity",
    eleccoBee = "Singularity", tractoDino = "Singularity", tralalaTralalita = "Singularity",
    reptistono = "Singularity",
    -- Eternal
    vulture = "Eternal", pineaplino = "Eternal", rengRongo = "Eternal",
    neonMeowl = "Eternal", crocoBling = "Eternal", jobJobDiablo = "Eternal",
    lordoRobo = "Eternal", kingFalken = "Eternal",
    -- Paradox
    microbelloPizzini = "Paradox", lordVeyrath = "Paradox", piectopus = "Paradox",
    -- Exclusive
    ayocolo = "Exclusive", lupa = "Exclusive", cesaroStono = "Exclusive", tikiTotemo = "Exclusive",
}

-- ============================================================
-- NEST DATA
-- nestKey  = string yang di-fire ke server (EnterNest)
-- brainrots = list nama brainrot yang ada di nest itu
-- ============================================================
local NESTS = {
    { key = "noob", brainrots = {"talpaDiFerro","pipiKiwi","porkupine","bonecaAmbalabu","pipiAvocado","pipiCorni","bambiniCrostini","bananitaDolphinita","penguinoCocosino","pepperoniPenguino","brainrot21","chimpanziniBananini"} },
    { key = "brainrot67", brainrots = {"bonecaAmbalabu","pipiAvocado","pipiCorni","bambiniCrostini","bananitaDolphinita","penguinoCocosino","pepperoniPenguino","brainrot21","chimpanziniBananini","penguinoPhone","blueberriniOctopusini","foxitaAnanasita","brrBrrPatapim","tungTungTungSahur","banditoBobritto","cactoHipopotamo","avocadiniGuffo","trippiTroppi","brainrot67"} },
    { key = "esokSekolah", brainrots = {"bananitaDolphinita","penguinoCocosino","pepperoniPenguino","brainrot21","chimpanziniBananini","penguinoPhone","blueberriniOctopusini","foxitaAnanasita","brrBrrPatapim","tungTungTungSahur","banditoBobritto","cactoHipopotamo","avocadiniGuffo","trippiTroppi","brainrot67","liriliLarila","brainrot69","ballerinaCappuccina","cappuccinoAssassino","brainrot76"} },
    { key = "karkarKurkurkur", brainrots = {"penguinoPhone","blueberriniOctopusini","foxitaAnanasita","brrBrrPatapim","tungTungTungSahur","banditoBobritto","cactoHipopotamo","avocadiniGuffo","trippiTroppi","brainrot67","liriliLarila","brainrot69","ballerinaCappuccina","cappuccinoAssassino","brainrot76","laCasaBoo","spookyCombinasion","headlessHorse","blueElephant","dragonCannelloni"} },
    { key = "yellowLuckyBlock", brainrots = {"liriliLarila","brainrot69","ballerinaCappuccina","cappuccinoAssassino","brainrot76","banditoBobritto","cactoHipopotamo","avocadiniGuffo","trippiTroppi","brainrot67","laCasaBoo","spookyCombinasion","headlessHorse","blueElephant","dragonCannelloni","bombardinoCrocodilo","pinkMedussi","strawberelliFlamingelli","tralaleroTralala","trubobuzzoFrazzolopoulos","los67","meowl"} },
    { key = "strewberry", brainrots = {"laCasaBoo","spookyCombinasion","headlessHorse","blueElephant","dragonCannelloni","bombardinoCrocodilo","pinkMedussi","strawberelliFlamingelli","tralaleroTralala","trubobuzzoFrazzolopoulos","los67","meowl","rubichettoCubini","crostinaGelifio","glacierelloInfernitti","wOrL","frogzoSoda","dugdug","potatoRider","rubickPlanet","udinDinDun"} },
    { key = "jobJobJobSahur", brainrots = {"bombardinoCrocodilo","pinkMedussi","strawberelliFlamingelli","tralaleroTralala","trubobuzzoFrazzolopoulos","los67","meowl","rubichettoCubini","crostinaGelifio","glacierelloInfernitti","wOrL","frogzoSoda","dugdug","potatoRider","rubickPlanet","udinDinDun","galactioFantasma","cupitronUFO","stoupoTraffico","martinoGravitino","dinDinValluero","strawberryElephant","grappellinoDoro","sadoSkeletono"} },
    { key = "dragonCannelloni", brainrots = {"rubichettoCubini","crostinaGelifio","glacierelloInfernitti","wOrL","frogzoSoda","dugdug","potatoRider","rubickPlanet","udinDinDun","galactioFantasma","cupitronUFO","stoupoTraffico","martinoGravitino","dinDinValluero","strawberryElephant","grappellinoDoro","sadoSkeletono","techScorpio","techDimon","grappeminoDojo","rosano"} },
    { key = "vip", brainrots = {"bombardinoCrocodilo","pinkMedussi","tralaleroTralala","strawberelliFlamingelli","trubobuzzoFrazzolopoulos","los67","meowl","rubichettoCubini","crostinaGelifio","glacierelloInfernitti","wOrL","frogzoSoda","dugdug","potatoRider","rubickPlanet","udinDinDun","martinoGravitino","strawberryElephant","stoupoTraffico","cupitronUFO","dinDinValluero","galactioFantasma","grappellinoDoro","sadoSkeletono"} },
    { key = "vipPlus", brainrots = {"rubichettoCubini","crostinaGelifio","glacierelloInfernitti","wOrL","frogzoSoda","dugdug","potatoRider","rubickPlanet","udinDinDun","martinoGravitino","strawberryElephant","stoupoTraffico","cupitronUFO","dinDinValluero","galactioFantasma","grappellinoDoro","sadoSkeletono","sadoBananito","rosano","techDimon","grappeminoDojo","techScorpio"} },
    { key = "frogioBlingo", brainrots = {"galactioFantasma","cupitronUFO","stoupoTraffico","martinoGravitino","dinDinValluero","strawberryElephant","grappellinoDoro","sadoSkeletono","techScorpio","techDimon","grappeminoDojo","rosano"} },
    { key = "lavaGolem", brainrots = {"techScorpio","techDimon","grappeminoDojo","sadoBananito","rosano","fireCappuccino","fireMedusa","fireDragon","tractoDino","tokTakTek"} },
    { key = "eleccoBee", brainrots = {"techScorpio","techDimon","grappeminoDojo","sadoBananito","rosano","fireCappuccino","fireMedusa","fireDragon","tractoDino","tokTakTek","crocoBling","jobJobDiablo","neonMeowl"} },
    { key = "meowl", brainrots = {"fireCappuccino","fireMedusa","fireDragon","tractoDino","tokTakTek","crocoBling","jobJobDiablo","neonMeowl"} },
    { key = "lordVeyrath", brainrots = {"crocoBling","jobJobDiablo","neonMeowl","microbelloPizzini"} },
}

-- ============================================================
-- CRAFT-ONLY BRAINROTS (setIsCraft=true di game asli)
-- Brainrot ini TIDAK spawn dari nest manapun — hasil craft/fuse saja
-- Jika muncul di workspace, itu milik player lain (tidak bisa di-steal)
-- ============================================================
local CRAFT_ONLY = {
    vulture=true, pineaplino=true, rengRongo=true, lordoRobo=true, kingFalken=true,
    tralalaTralalita=true, reptistono=true, piectopus=true,
    tikiTotemo=true, tokTakTek=false, -- tokTakTek spawn dari nest
    ayocolo=true, lupa=true, cesaroStono=true,
    lordVeyrath=true,
}

-- Buat set brainrot per nest untuk lookup cepat
local NEST_BRAINROT_SET = {}
local NEST_RANK_MAP = {}
for i, nest in ipairs(NESTS) do
    local set = {}
    for _, b in ipairs(nest.brainrots) do set[b] = true end
    NEST_BRAINROT_SET[nest.key] = set
    NEST_RANK_MAP[nest.key] = i -- Untuk tie-breaker CPS (nest lebih tinggi = CPS lebih besar)
end

-- ============================================================
-- RARITY → NEST mapping
-- ============================================================
local RARITY_TO_NEST = {
    ["Common"]      = "noob",
    ["Rare"]        = "brainrot67",
    ["Epic"]        = "esokSekolah",
    ["Legendary"]   = "karkarKurkurkur",
    ["Mythical"]    = "yellowLuckyBlock",
    ["Cosmic"]      = "strewberry",
    ["Secret"]      = "jobJobJobSahur",
    ["Celestial"]   = "dragonCannelloni",
    ["Divine"]      = "frogioBlingo",
    ["Infinity"]    = "lavaGolem",
    ["Singularity"] = "eleccoBee",
    ["Eternal"]     = "meowl",
    ["Paradox"]     = "lordVeyrath",
}

-- ============================================================
-- BRAINROT → NEST mapping (berdasarkan weight tertinggi di tiap nest)
-- ============================================================
local BRAINROT_TO_NEST = {
    -- Common → noob
    talpaDiFerro = "noob", pipiKiwi = "noob", porkupine = "noob",
    -- Uncommon → brainrot67 (weight lebih tinggi dari noob)
    bonecaAmbalabu = "brainrot67", pipiAvocado = "brainrot67",
    pipiCorni = "brainrot67", bambiniCrostini = "brainrot67",
    -- Rare → esokSekolah (weight tertinggi)
    bananitaDolphinita = "esokSekolah", penguinoCocosino = "esokSekolah",
    pepperoniPenguino = "esokSekolah", brainrot21 = "esokSekolah", chimpanziniBananini = "esokSekolah",
    -- Epic → karkarKurkurkur (weight tertinggi)
    penguinoPhone = "karkarKurkurkur", blueberriniOctopusini = "karkarKurkurkur",
    foxitaAnanasita = "karkarKurkurkur", brrBrrPatapim = "karkarKurkurkur", tungTungTungSahur = "karkarKurkurkur",
    -- Legendary → karkarKurkurkur (weight tertinggi)
    banditoBobritto = "karkarKurkurkur", cactoHipopotamo = "karkarKurkurkur",
    avocadiniGuffo = "karkarKurkurkur", trippiTroppi = "karkarKurkurkur", brainrot67 = "karkarKurkurkur",
    -- Mythical → yellowLuckyBlock (weight tertinggi)
    liriliLarila = "yellowLuckyBlock", brainrot69 = "yellowLuckyBlock",
    ballerinaCappuccina = "yellowLuckyBlock", cappuccinoAssassino = "yellowLuckyBlock", brainrot76 = "yellowLuckyBlock",
    -- Cosmic → strewberry (weight tertinggi)
    laCasaBoo = "strewberry", spookyCombinasion = "strewberry",
    headlessHorse = "strewberry", blueElephant = "strewberry", dragonCannelloni = "strewberry",
    -- Secret → jobJobJobSahur (weight tertinggi)
    bombardinoCrocodilo = "jobJobJobSahur", pinkMedussi = "jobJobJobSahur",
    strawberelliFlamingelli = "jobJobJobSahur", tralaleroTralala = "jobJobJobSahur",
    trubobuzzoFrazzolopoulos = "jobJobJobSahur", los67 = "jobJobJobSahur", meowl = "jobJobJobSahur",
    -- Celestial → dragonCannelloni (weight tertinggi)
    rubichettoCubini = "dragonCannelloni", crostinaGelifio = "dragonCannelloni",
    glacierelloInfernitti = "dragonCannelloni", wOrL = "dragonCannelloni", frogzoSoda = "dragonCannelloni",
    dugdug = "dragonCannelloni", potatoRider = "dragonCannelloni",
    rubickPlanet = "dragonCannelloni", udinDinDun = "dragonCannelloni",
    -- Divine → frogioBlingo (dedicated Divine nest)
    galactioFantasma = "frogioBlingo", cupitronUFO = "frogioBlingo",
    stoupoTraffico = "frogioBlingo", martinoGravitino = "frogioBlingo",
    dinDinValluero = "frogioBlingo", strawberryElephant = "frogioBlingo",
    grappellinoDoro = "frogioBlingo", sadoSkeletono = "frogioBlingo",
    -- Infinity → eleccoBee (weight lebih tinggi dari lavaGolem)
    techScorpio = "eleccoBee", techDimon = "eleccoBee",
    grappeminoDojo = "eleccoBee", sadoBananito = "eleccoBee",
    rosano = "lavaGolem",
    -- Singularity → eleccoBee (weight lebih tinggi dari meowl)
    fireCappuccino = "eleccoBee", fireMedusa = "eleccoBee",
    fireDragon = "eleccoBee", tractoDino = "eleccoBee",
    -- Eternal (spawn dari nest)
    crocoBling = "lordVeyrath", jobJobDiablo = "lordVeyrath", neonMeowl = "lordVeyrath",
    -- Paradox (spawn dari nest)
    microbelloPizzini = "lordVeyrath",
    -- Craft-only Eternal/Paradox tidak di-map ke nest (tidak spawn dari nest)
}

-- ============================================================
-- DROPDOWN OPTIONS & CONFIG
-- ============================================================
-- Semua brainrot unik (sorted)
local ALL_BRAINROTS = {"None"}
do
    local seen = {}
    for _, nest in ipairs(NESTS) do
        for _, b in ipairs(nest.brainrots) do
            if not seen[b] then seen[b] = true; table.insert(ALL_BRAINROTS, b) end
        end
    end
    for b, isCraft in pairs(CRAFT_ONLY) do
        if isCraft and not seen[b] then
            seen[b] = true; table.insert(ALL_BRAINROTS, b)
        end
    end
    table.sort(ALL_BRAINROTS, function(a, b)
        if a == "None" then return true end
        if b == "None" then return false end
        return a < b
    end)
    table.insert(ALL_BRAINROTS, 2, "All Possible")
end

local MUTATION_LIST = { "None", "All Possible", "Non Mutasi", "Gold", "Diamond", "Poison", "Blazing", "Honey", "Astral" }

local RARITY_LIST = {
    "None",
    "Common", "Uncommon", "Rare", "Epic", "Legendary",
    "Mythical", "Secret", "Cosmic", "Divine", "Celestial",
    "Infinity", "Singularity", "Eternal", "Paradox", "Exclusive"
}

local Config = {
    AutoFarm       = false,
    TargetBrainrot = { ["None"] = true },
    TargetMutation = { ["None"] = true },
    TargetRarity   = { ["None"] = true },
    
    AutoSell           = false,
    SellTargetBrainrot = { ["None"] = true },
    SellTargetMutation = { ["None"] = true },
    SellTargetRarity   = { ["None"] = true },
}

local function parseMultiDropdown(val)
    local dict = {}
    if type(val) == "table" then
        local count = 0
        for k, v in pairs(val) do
            if type(k) == "number" then
                dict[v] = true
                count = count + 1
            elseif v == true then
                dict[k] = true
                count = count + 1
            end
        end
        if count == 0 then dict["None"] = true end
    else
        dict[val or "None"] = true
    end
    return dict
end

local function handleDropdownChange(val, dropObj)
    local arr = type(val) == "table" and val or {val}
    local changed = false
    
    -- Jika milih sesuatu tapi "None" masih nyangkut, buang "None"
    if #arr > 1 and table.find(arr, "None") then
        local newArr = {}
        for _, item in ipairs(arr) do
            if item ~= "None" then table.insert(newArr, item) end
        end
        arr = newArr
        changed = true
    -- Jika kosong (dilepas semua), otomatis balik ke "None"
    elseif #arr == 0 then
        arr = {"None"}
        changed = true
    end
    
    if changed and dropObj then
        dropObj:Set(arr)
    end
    return arr
end

-- ============================================================
-- UTILITY: Deteksi Brainrot Robux (Pajangan VIP/Toko)
-- ============================================================
local robuxPadsCache = nil

local function isRobuxBrainrot(model)
    local hrp = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
    if not hrp then return false end

    -- Build cache posisi pad Robux sekali saja biar tidak lag
    if not robuxPadsCache then
        robuxPadsCache = {}
        
        -- Fungsi bantu untuk scan folder
        local function scanFolder(folder)
            if not folder then return end
            for _, zone in ipairs(folder:GetChildren()) do
                -- APEXDEV: Daftarkan lokasi ruangan (nest) ke KNOWN_NEST_LOCATIONS!
                if zone:IsA("Model") or zone:IsA("Folder") then
                    local interior = zone:FindFirstChild("Interior")
                    if not interior then
                        local base = zone:FindFirstChild("base") or zone:FindFirstChild("Base")
                        if base then interior = base:FindFirstChild("Interior") end
                    end
                    
                    if interior then
                        -- Ambil pivot posisi interior sebagai pusat ruangan
                        local ok, pivot = pcall(function() return interior:GetPivot() end)
                        if ok and pivot then
                            KNOWN_NEST_LOCATIONS[zone.Name] = pivot.Position
                        end
                        
                        -- Cari pad robux
                        local pads = interior:FindFirstChild("Pads")
                        if pads then
                            for _, pad in ipairs(pads:GetChildren()) do
                                if pad:FindFirstChild("PriceRbx", true) or pad:FindFirstChild("LuckBillb", true) then
                                    local part = pad.PrimaryPart or pad:FindFirstChildWhichIsA("BasePart", true)
                                    if part then table.insert(robuxPadsCache, part) end
                                end
                            end
                        end
                    end
                end
            end
        end

        -- Cari di lokasi lama
        local buildings = workspace:FindFirstChild("Game")
            and workspace.Game:FindFirstChild("Map")
            and workspace.Game.Map:FindFirstChild("Buildings")
        scanFolder(buildings)
        
        -- Cari langsung di workspace (misal workspace["12"])
        scanFolder(workspace)
    end

    -- Cek apakah brainrot ini berdiri di dekat Pad Robux
    for _, padPart in ipairs(robuxPadsCache) do
        if padPart and padPart.Parent then
            if (hrp.Position - padPart.Position).Magnitude < 15 then
                return true -- Terlalu dekat dengan pad Robux (Pajangan)
            end
        end
    end
    return false
end

-- ============================================================
-- UTILITY: Cek apakah model brainrot di workspace cocok dengan filter
-- ============================================================
-- Despawn window dari nestsIF.lua: despawnCooldown = {50, 90} detik
-- Kita pakai 50 detik sebagai worst-case (brainrot despawn paling cepat)
local DESPAWN_MIN = 50

-- Hitung estimasi sisa waktu brainrot (detik)
local function getTimeLeft(model)
    local spawnTime = model:GetAttribute("spawnTime") or model:GetAttribute("SpawnTime") or model:GetAttribute("spawnedAt")
    if not spawnTime then return DESPAWN_MIN end -- Tidak ada info → asumsikan masih ada waktu
    local elapsed = workspace:GetServerTimeNow() - spawnTime
    return math.max(0, DESPAWN_MIN - elapsed)
end

local function isTargetMatch(model)
    if not model then return false end
    
    -- MENCEGAH MENGAMBIL BRAINROT ROBUX/DISPLAY:
    if isRobuxBrainrot(model) then return false end

    -- Ambil nama asli dari attribute (kalo mutasi, model.Name bisa berubah jadi "diamond")
    local actualName = model:GetAttribute("name") or model.Name

    -- Jangan farm craft-only brainrot (tidak spawn dari nest, milik player lain)
    if CRAFT_ONLY[actualName] then return false end

    -- Filter nama brainrot
    if not Config.TargetBrainrot["None"] then
        if not Config.TargetBrainrot[actualName] then return false end
    end

    -- Filter rarity
    if not Config.TargetRarity["None"] then
        local rarity = model:GetAttribute("Rarity")
                    or BRAINROT_RARITY_MAP[actualName]
                    or "Common"
        if not Config.TargetRarity[rarity] then return false end
    end

    -- Filter mutasi
    if not Config.TargetMutation["None"] then
        local mut = model:GetAttribute("variant") or model:GetAttribute("Variant") or model:GetAttribute("Mutation")
        if not mut and model:GetAttribute("name") and model.Name ~= model:GetAttribute("name") then
            mut = model.Name
        end
        mut = mut or "None"
        
        local match = false
        for mName, _ in pairs(Config.TargetMutation) do
            if mName == "Non Mutasi" then
                if mut:lower() == "none" or mut:lower() == "" or mut:lower() == "normal" then
                    match = true; break
                end
            else
                -- Case-insensitive compare
                if mut:lower() == mName:lower() then
                    match = true; break
                end
            end
        end
        if not match then return false end
    end

    return true
end

-- ============================================================
-- BRAINROT CPS MAP (nilai _reward normal dari game data)
-- ============================================================
local BRAINROT_CPS_MAP = {
    talpaDiFerro = 2,           pipiKiwi = 6,              porkupine = 10,
    pipiAvocado = 13,           bonecaAmbalabu = 12,       pipiCorni = 19,
    bambiniCrostini = 25,       bananitaDolphinita = 50,   penguinoCocosino = 80,
    pepperoniPenguino = 115,    brainrot21 = 145,          chimpanziniBananini = 175,
    penguinoPhone = 200,        blueberriniOctopusini = 400, foxitaAnanasita = 600,
    brrBrrPatapim = 800,        tungTungTungSahur = 1000,  banditoBobritto = 1200,
    cactoHipopotamo = 2025,     avocadiniGuffo = 2850,     trippiTroppi = 3675,
    brainrot67 = 4500,          liriliLarila = 6000,       brainrot69 = 10000,
    ballerinaCappuccina = 14000, cappuccinoAssassino = 18000, brainrot76 = 22000,
    laCasaBoo = 37000,          spookyCombinasion = 52500, headlessHorse = 85000,
    blueElephant = 117500,      dragonCannelloni = 150000, bombardinoCrocodilo = 200000,
    pinkMedussi = 600000,       strawberelliFlamingelli = 960000, tralaleroTralala = 1720000,
    trubobuzzoFrazzolopoulos = 2480000, los67 = 3240000,   meowl = 4000000,
    rubichettoCubini = 4400000, crostinaGelifio = 4700000, glacierelloInfernitti = 5000000,
    wOrL = 6500000,             frogzoSoda = 7000000,      dugdug = 8000000,
    potatoRider = 9500000,      rubickPlanet = 11000000,   udinDinDun = 13000000,
    galactioFantasma = 25000000, cupitronUFO = 38000000,   stoupoTraffico = 45000000,
    martinoGravitino = 51000000, dinDinValluero = 64000000, strawberryElephant = 77000000,
    grappellinoDoro = 90000000, sadoSkeletono = 100000000, techScorpio = 175000000,
    techDimon = 462500000,      sadoBananito = 1000000000, fireCappuccino = 2000000000,
    fireMedusa = 3000000000,    fireDragon = 5000000000,   tractoDino = 7000000000,
    tralalaTralalita = 7500000000, reptistono = 15000000000, eleccoBee = 20000000000, crocoBling = 22000000000,
    jobJobDiablo = 30000000000, neonMeowl = 35000000000,   pineaplino = 40000000000,
    microbelloPizzini = 65000000000, vulture = 60000000000,      rengRongo = 100000000000,  lordoRobo = 130000000000,
    kingFalken = 250000000000, piectopus = 400000000000, lordVeyrath = 700000000000,
    rosano = 1300000000,
}

-- Multiplier per variant/mutation (estimasi dari _reward diamond/normal ratio)
local MUTATION_MULTIPLIER = {
    ["Normal"] = 1.0, ["Gold"] = 1.5, ["Diamond"] = 4.25,
    ["Poison"] = 3.0, ["Blazing"] = 5.0, ["Honey"] = 6.0, ["Astral"] = 8.0,
}

-- ============================================================
-- UTILITY: Scan workspace cari brainrot TERBAIK (CPS tertinggi)
-- ============================================================
local lockedNests = {}
local KNOWN_NEST_LOCATIONS = {} -- [nestKey] = Vector3

local DEFAULT_RARITY_CPS = {
    ["Common"] = 10,
    ["Rare"] = 100,
    ["Epic"] = 1000,
    ["Legendary"] = 10000,
    ["Mythical"] = 100000,
    ["Cosmic"] = 1000000,
    ["Secret"] = 5000000,
    ["Celestial"] = 15000000,
    ["Divine"] = 50000000,
    ["Infinity"] = 250000000,
    ["Singularity"] = 2000000000,
    ["Eternal"] = 50000000000,
}

local function findBestTargetInWorkspace()
    local bestModel  = nil
    local bestPrompt = nil
    local bestCPS    = -1
    local bestNest   = nil

    for _, child in ipairs(workspace:GetChildren()) do
        if child:IsA("Model") then
            local proxAttach = child:FindFirstChild("ProximityAttachment")
            if proxAttach then
                local prompt = proxAttach:FindFirstChildOfClass("ProximityPrompt")
                if prompt and isTargetMatch(child) then
                    local actualName = child:GetAttribute("name") or child.Name
                    
                    -- Abaikan jika sudah diblacklist total
                    if child:GetAttribute("IgnoredByFarming") then continue end

                    -- Cari posisi target dengan presisi tinggi
                    local targetPos
                    if proxAttach then
                        if proxAttach:IsA("Attachment") then targetPos = proxAttach.WorldPosition
                        elseif proxAttach:IsA("BasePart") then targetPos = proxAttach.Position end
                    end
                    if not targetPos then
                        pcall(function()
                            local ok, pivot = pcall(function() return child:GetPivot() end)
                            if ok and pivot then targetPos = pivot.Position end
                        end)
                        if not targetPos then
                            pcall(function()
                                local pp = child:FindFirstChildOfClass("BasePart")
                                if pp then targetPos = pp.Position end
                            end)
                        end
                    end
                    if not targetPos then continue end

                    -- DAPATKAN RARITY (Prioritas dari Attribute agar otak baru terdeteksi!)
                    local rarity = child:GetAttribute("Rarity") or child:GetAttribute("rarity") or BRAINROT_RARITY_MAP[actualName] or "Common"

                    -- 1. Baca langsung dari Attribute jika developer menyediakannya
                    local determinedNest = child:GetAttribute("nest") or child:GetAttribute("Nest") or child:GetAttribute("zone") or child:GetAttribute("Zone")

                    -- 2. Tebak nest dari lokasi fisik yang sudah diketahui (radius 350 stud = 1 ruangan)
                    if not determinedNest then
                        local closestDist = 350
                        for nKey, nPos in pairs(KNOWN_NEST_LOCATIONS) do
                            if not child:GetAttribute("NotInNest_" .. nKey) then
                                local d = (targetPos - nPos).Magnitude
                                if d < closestDist then
                                    closestDist = d
                                    determinedNest = nKey
                                end
                            end
                        end
                    end

                    -- 3. Jika lokasi belum diketahui, cari nest yang valid secara data (process of elimination)
                    if not determinedNest then
                        for i = #NESTS, 1, -1 do
                            local nKey = NESTS[i].key
                            if not lockedNests[nKey] and NEST_BRAINROT_SET[nKey] and NEST_BRAINROT_SET[nKey][actualName] then
                                -- Cek apakah nest ini sudah dicoret untuk instance ini
                                if not child:GetAttribute("NotInNest_" .. nKey) then
                                    -- Validasi tambahan: Jika kita sudah tahu posisi nest ini, tapi targetPos jauh, jangan dipilih!
                                    if KNOWN_NEST_LOCATIONS[nKey] and (targetPos - KNOWN_NEST_LOCATIONS[nKey]).Magnitude > 350 then
                                        continue
                                    end
                                    determinedNest = nKey
                                    break
                                end
                            end
                        end
                    end
                    
                    -- 4. Jika ini brainrot BARU (tidak ada di map), tebak nest dari Rarity-nya!
                    if not determinedNest then
                        local fbNest = RARITY_TO_NEST[rarity]
                        if fbNest and not lockedNests[fbNest] and not child:GetAttribute("NotInNest_" .. fbNest) then
                            if not (KNOWN_NEST_LOCATIONS[fbNest] and (targetPos - KNOWN_NEST_LOCATIONS[fbNest]).Magnitude > 350) then
                                determinedNest = fbNest
                            end
                        end
                    end
                    
                    -- Jika tidak ada nest yang cocok (misal semua terkunci atau sudah dicoret), abaikan
                    if not determinedNest then continue end

                    -- 5. BLOKIR AREA NEST TERTENTU (seperti area ke-2 di nest eleccoBee / Buildings["11"])
                    local isBlockedByWall = false
                    pcall(function()
                        local wall = workspace:FindFirstChild("Game")
                            and workspace.Game:FindFirstChild("Map")
                            and workspace.Game.Map:FindFirstChild("Buildings")
                            and workspace.Game.Map.Buildings:FindFirstChild("11")
                            and workspace.Game.Map.Buildings["11"]:FindFirstChild("Interior")
                            and workspace.Game.Map.Buildings["11"].Interior:FindFirstChild("walls")
                        
                        if wall then
                            local blockedWall = wall:GetChildren()[3]
                            if blockedWall and blockedWall:IsA("BasePart") then
                                local startPos = KNOWN_NEST_LOCATIONS[determinedNest]
                                if not startPos then
                                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    startPos = hrp and hrp.Position
                                end
                                
                                if startPos then
                                    local rayDir = targetPos - startPos
                                    local rayParams = RaycastParams.new()
                                    rayParams.FilterType = Enum.RaycastFilterType.Include
                                    rayParams.FilterDescendantsInstances = {blockedWall}
                                    
                                    local result = workspace:Raycast(startPos, rayDir, rayParams)
                                    if result then
                                        -- Raycast menabrak dinding pemisah! Brainrot ada di ruangan sebelah
                                        isBlockedByWall = true
                                    end
                                end
                            end
                        end
                    end)
                    if isBlockedByWall then continue end -- Abaikan brainrot yang ada di balik tembok!

                    -- ── SMART: Cek sisa waktu hidup brainrot ─────────────────
                    -- despawnCooldown {50,90}s dari nestsIF.lua; gunakan 50 worst-case
                    local timeLeft = getTimeLeft(child)
                    -- Estimasi waktu tempuh: jarak ke nest + jalan ke brainrot
                    local travelEst = 5 -- detik minimum (teleport nest + jalan)
                    if timeLeft < travelEst then continue end -- Tidak akan sempat

                    -- Hitung CPS nyata (fallback ke DEFAULT_RARITY_CPS jika namanya baru/belum terdata)
                    local baseCPS = BRAINROT_CPS_MAP[actualName] or DEFAULT_RARITY_CPS[rarity] or 0
                    local mutation = child:GetAttribute("variant") or child:GetAttribute("Variant") or child:GetAttribute("Mutation")
                    if not mutation and child:GetAttribute("name") and child.Name ~= child:GetAttribute("name") then
                        mutation = child.Name
                    end
                    mutation = mutation or "Normal"
                    
                    local mutNorm = mutation:sub(1,1):upper() .. mutation:sub(2):lower()
                    local mult = MUTATION_MULTIPLIER[mutNorm] or 1.0
                    local totalCPS = baseCPS * mult
                    
                    local hrpDist = 999999
                    pcall(function()
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then hrpDist = (hrp.Position - targetPos).Magnitude end
                    end)
                    
                    if totalCPS > bestCPS then
                        bestCPS    = totalCPS
                        bestModel  = child
                        bestPrompt = prompt
                        bestNest   = determinedNest
                        bestModelDist = hrpDist
                    elseif totalCPS == bestCPS and bestModelDist then
                        -- Jika CPS sama, ambil yang lebih dekat (menghindari milih brainrot di nest lain yang beda ruangan)
                        if hrpDist < bestModelDist then
                            bestCPS    = totalCPS
                            bestModel  = child
                            bestPrompt = prompt
                            bestNest   = determinedNest
                            bestModelDist = hrpDist
                        end
                    end
                end
            end
        end
    end

    return bestModel, bestPrompt, bestNest, bestCPS
end

-- ============================================================
-- UTILITY: Fire ProximityPrompt
-- ============================================================
local function fireProximityPrompt(prompt)
    if not prompt then return end
    local fired = false
    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt)
            fired = true
        end
    end)
    if not fired then
        pcall(function()
            for _, conn in ipairs(getconnections(prompt.Triggered)) do
                pcall(function() conn.Function(LocalPlayer) end)
            end
        end)
    end
end

-- ============================================================
-- AUTO FARM STATE MACHINE
-- Alur baru (Global Sniper): searching (scan workspace) → entering (nest) → moving → leaving → searching
-- ============================================================
local farmConn    = nil
local noclipConn  = nil
local farmState   = "idle"
local farmTimer   = 0
local moveTarget  = nil
local movePrompt  = nil
local targetNest  = nil

local farmTeleportFired = false
local farmTeleportWait  = 0
local farmOldPos        = Vector3.new()

local stuckTimer = 0
local lastDist = math.huge
local lastStuckDist = math.huge

local MOVE_SPEED  = 120   -- stud/s di dalam nest
local REACH_DIST  = 5    -- stud trigger prompt (butuh fisik dekat ke brainrot)

-- ============================================================
-- FREEZE GUARD SYSTEM
-- Guard di game punya CollisionGroup = "Guard" (dari guardsManager.lua)
-- ============================================================
local freezeGuardConn    = nil
local Config_FreezeGuard = false

local GUARD_COLLISION_GROUP = "Guard"

local frozenGuards = {}

local function startFreezeGuard()
    if freezeGuardConn then freezeGuardConn:Disconnect() end
    Config_FreezeGuard = true

    -- Fungsi untuk membekukan guard
    local function freezeObj(obj)
        if obj:IsA("BasePart") and obj.CollisionGroup == GUARD_COLLISION_GROUP then
            obj.Anchored = true
            obj.Velocity = Vector3.zero
            obj.RotVelocity = Vector3.zero
            frozenGuards[obj] = true
        end
    end

    -- Initial freeze untuk yang sudah ada
    for _, obj in ipairs(workspace:GetDescendants()) do
        freezeObj(obj)
    end

    -- Pantau guard baru tanpa membebani CPU (TIDAK PAKAI HEARTBEAT LAGI)
    freezeGuardConn = workspace.DescendantAdded:Connect(function(obj)
        if not Config_FreezeGuard then return end
        task.wait() -- Tunggu properti dasar di-set oleh game
        freezeObj(obj)
    end)
end

local function stopFreezeGuard()
    Config_FreezeGuard = false
    if freezeGuardConn then freezeGuardConn:Disconnect(); freezeGuardConn = nil end
    
    -- Unfreeze semua yang sudah dibekukan
    for obj, _ in pairs(frozenGuards) do
        pcall(function()
            if obj and obj.Parent then
                obj.Anchored = false
            end
        end)
    end
    table.clear(frozenGuards)
end

local function enterNest(key)
    pcall(function()
        if EnterNestEvent then EnterNestEvent:FireServer(key) end
    end)
end

local function leaveNest()
    pcall(function()
        if LeaveNestEvent then LeaveNestEvent:FireServer() end
    end)
end

-- ============================================================
-- COIL ORDER (dari yang terbaik ke terburuk, sesuai speedCoilsIF.lua)
-- ============================================================
local COIL_PRIORITY = {
    "Warp Coil", "Shiny Coil", "Honey Coil", "Magma Coil", "Rainbow Coil",
    "Dream Coil", "Inferno Coil", "Abyss Coil", "Poison Coil",
    "Lava Coil", "Water Coil", "Yellow Coil", "Blue Coil", "Red Coil",
}

local antiShakeConn = nil

-- Cari & equip coil terbaik dari backpack/tool player
local function equipBestCoil()
    pcall(function()
        local remotes = ReplicatedStorage:WaitForChild("packages", 5)
        -- Cari tool di backpack/character
        local function findCoilInPlayer()
            local toolNames = {}
            local bp = LocalPlayer:FindFirstChild("Backpack")
            local ch = LocalPlayer.Character
            if bp then
                for _, t in ipairs(bp:GetChildren()) do
                    if t:IsA("Tool") then table.insert(toolNames, t.Name) end
                end
            end
            if ch then
                for _, t in ipairs(ch:GetChildren()) do
                    if t:IsA("Tool") then table.insert(toolNames, t.Name) end
                end
            end
            return toolNames
        end

        local ownedTools = findCoilInPlayer()
        local bestCoil = nil
        for _, coilName in ipairs(COIL_PRIORITY) do
            for _, owned in ipairs(ownedTools) do
                if owned == coilName then
                    bestCoil = coilName
                    break
                end
            end
            if bestCoil then break end
        end

        if bestCoil then
            -- Fire holdItem remote via remo container
            local pkgIndex = ReplicatedStorage:WaitForChild("packages", 5):WaitForChild("_Index", 5)
            for _, child in ipairs(pkgIndex:GetChildren()) do
                if child.Name:find("littensy_remo") then
                    local container = child:FindFirstChild("remo") and child.remo:FindFirstChild("container")
                    if container then
                        local holdRemote = container:FindFirstChild("game.backpack.holdItem")
                        if holdRemote then
                            pcall(function() holdRemote:FireServer(bestCoil) end)
                            notif("Auto equip: " .. bestCoil .. " ✅", 3, "Coil")
                        end
                    end
                    break
                end
            end
        end
    end)
end

-- Matikan screen shake (override CameraOffset tiap frame)
local function startAntiShake()
    if antiShakeConn then antiShakeConn:Disconnect() end
    antiShakeConn = RunService.Heartbeat:Connect(function()
        pcall(function()
            local ch  = LocalPlayer.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if hum then hum.CameraOffset = Vector3.zero end
        end)
    end)
end

-- ============================================================
-- AUTO EQUIP COIL (Mendukung Custom Inventory Game)
-- ============================================================
local function equipBestCoil()
    task.spawn(function()
        task.wait(0.1) -- dipercepat menjadi 0.1 detik (instan)
        
        local ownedCoils = {}
        local foundData = false
        pcall(function()
            -- Scan seluruh memory (garbage collector) untuk mencari tabel inventory
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" and rawget(v, "type") == "tool" then
                    local tData = rawget(v, "tool")
                    if type(tData) == "table" and rawget(tData, "name") == "speedCoils" then
                        local variant = rawget(tData, "variant")
                        local id = rawget(tData, "id")
                        if variant and id then
                            ownedCoils[variant] = id
                            foundData = true
                        end
                    end
                end
            end
        end)
        
        if not foundData then
            notif("Gagal memindai UUID Coil di memori!", 2, "Warning")
            return
        end
        
        -- Urutan prioritas variant dari terbaik ke terburuk
        local COIL_VARIANTS = {
            "warp", "shiny", "honey", "magma", "rainbow", "dream", "inferno", "abyss",
            "poison", "lava", "water", "yellow", "blue", "red"
        }
        
        local bestVariant = nil
        local bestId = nil
        for _, v in ipairs(COIL_VARIANTS) do
            if ownedCoils[v] then
                bestVariant = v
                bestId = ownedCoils[v]
                break
            end
        end
        
        if bestId then
            local success = false
            pcall(function()
                -- Fire remote langsung menggunakan UUID asli
                local pkgIndex = ReplicatedStorage:WaitForChild("packages", 3):WaitForChild("_Index", 3)
                if pkgIndex then
                    for _, pkg in ipairs(pkgIndex:GetChildren()) do
                        if pkg.Name:find("littensy_remo") then
                            local container = pkg:FindFirstChild("remo") and pkg.remo:FindFirstChild("container")
                            if container then
                                local holdRemote = container:FindFirstChild("game.backpack.holdItem")
                                if holdRemote then 
                                    holdRemote:FireServer(bestId)
                                    success = true
                                end
                            end
                            break
                        end
                    end
                end
            end)
            if success then
                notif("Auto equip: " .. bestVariant .. " coil ✅", 3, "Coil")
            else
                notif("Gagal menembak remote holdItem", 3, "Error")
            end
        else
            notif("Kamu tidak punya Coil satupun!", 3, "Warning")
        end
    end)
end

local function stopAntiShake()
    if antiShakeConn then antiShakeConn:Disconnect(); antiShakeConn = nil end
end

-- ============================================================
-- ANTI ROLLBACK (BodyVelocity) & ANTI-GRAVITY FLY
-- Mencegah terpental dan mencegah jatuh (Cancel Gravity) saat jalan menggunakan CFrame
-- ============================================================
local function setAntiRollback(hrp, enable)
    if not hrp then return end
    local bv = hrp:FindFirstChild("AntiRollbackBV")
    if enable then
        if not bv then
            bv = Instance.new("BodyVelocity")
            bv.Name = "AntiRollbackBV"
            -- ApexDev: Tambahkan Y-axis MaxForce agar karakter BISA TERBANG dan TIDAK JATUH saat noclip!
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.zero
            bv.Parent = hrp
        end
    else
        if bv then bv:Destroy() end
    end
end

-- ============================================================
-- AUTO FUSE
-- ============================================================
local autoFuseLoop = false
local FUSE_RECIPES = {
    "piectopus", "reptistono", "kingFalken", "lordoRobo", "rengRongo", 
    "pineaplino", "vulture", "tralala", "bee", "lordVeyrath"
}

local function startAutoFuse()
    if autoFuseLoop then return end
    autoFuseLoop = true
    
    task.spawn(function()
        while Config.AutoFuse and autoFuseLoop do
            pcall(function()
                -- Ambil EXACT path seperti yang dideteksi oleh Cobalt logger
                local Event = game:GetService("ReplicatedStorage").packages._Index["littensy_remo@1.5.3"].remo.container["data.fuse.createFuse"]
                if not Event then return end
                
                -- Baca state game TANPA inner pcall agar isFusing tidak tertelan error diam-diam
                -- Outer pcall di atas sudah cukup melindungi dari crash
                local isFusing = false
                local prodMod = LocalPlayer.PlayerScripts:FindFirstChild("modules")
                    and LocalPlayer.PlayerScripts.modules:FindFirstChild("state")
                    and LocalPlayer.PlayerScripts.modules.state:FindFirstChild("producer")
                if prodMod then
                    local producer = require(prodMod)
                    local state = producer:getState()
                    if state and state.store and state.store.data and state.store.data[LocalPlayer.Name] and state.store.data[LocalPlayer.Name].fuse then
                        isFusing = true
                        local endTime = state.store.data[LocalPlayer.Name].fuse.endTime
                        if workspace:GetServerTimeNow() >= endTime then
                            local recipeToClaim = state.store.data[LocalPlayer.Name].fuse.recipe
                            Event:FireServer(recipeToClaim)
                            notif("Auto Fuse: Meng-claim " .. tostring(recipeToClaim) .. "!", 3, "Auto")
                        end
                    end
                end
                
                -- Jika slot sedang dipakai, berhenti dan tunggu loop berikutnya
                if isFusing then return end
                
                local targets = Config.TargetFuse or {}
                if targets["None"] or targets["All Possible"] or not next(targets) then
                    targets = {}
                    for _, v in ipairs(FUSE_RECIPES) do targets[v] = true end
                end
                
                for _, recipeName in ipairs(FUSE_RECIPES) do
                    if targets[recipeName] then
                        notif("Auto Fuse: Firing " .. recipeName .. "...", 1, "Auto")
                        Event:FireServer(recipeName)
                        task.wait(0.5) -- Jeda agar server merespons
                        
                        -- Verifikasi apakah tembakan barusan berhasil memulai fuse
                        local success = false
                        local prodMod = LocalPlayer.PlayerScripts:FindFirstChild("modules")
                            and LocalPlayer.PlayerScripts.modules:FindFirstChild("state")
                            and LocalPlayer.PlayerScripts.modules.state:FindFirstChild("producer")
                        if prodMod then
                            local producer = require(prodMod)
                            local state = producer:getState()
                            if state and state.store and state.store.data and state.store.data[LocalPlayer.Name] and state.store.data[LocalPlayer.Name].fuse then
                                success = true
                            end
                        end
                        
                        if success then 
                            notif("Auto Fuse: Berhasil memulai " .. recipeName .. "!", 2, "Auto")
                            break 
                        end
                    end
                end
            end)
            task.wait(2)
        end
        autoFuseLoop = false
    end)
end

-- ============================================================
-- AUTO RECYCLE (TOKEN MACHINE)
-- ============================================================
local autoRecycleLoop = false
local RECYCLE_RECIPES = {
    "frogzoSoda", "cupitronUFO", "techScorpio", "fireCappuccino", 
    "tralalaTralalita", "eleccoBee", "pineaplino", "vulture", 
    "rengRongo", "crocoBling", "lordoRobo", "piectopus", 
    "kingFalken", "reptistono", "lordVeyrath"
}

local function startAutoRecycle()
    if autoRecycleLoop then return end
    autoRecycleLoop = true
    
    task.spawn(function()
        while Config.AutoRecycle and autoRecycleLoop do
            pcall(function()
                local Event = game:GetService("ReplicatedStorage").packages._Index["littensy_remo@1.5.3"].remo.container["data.tokenMachine.createRecycle"]
                if not Event then return end
                
                -- Baca state game untuk SMART RECYCLE
                local isRecycling = false
                local prodMod = LocalPlayer.PlayerScripts:FindFirstChild("modules")
                    and LocalPlayer.PlayerScripts.modules:FindFirstChild("state")
                    and LocalPlayer.PlayerScripts.modules.state:FindFirstChild("producer")
                if prodMod then
                    local producer = require(prodMod)
                    local state = producer:getState()
                    if state and state.store and state.store.data and state.store.data[LocalPlayer.Name] and state.store.data[LocalPlayer.Name].recycle then
                        isRecycling = true
                        local endTime = state.store.data[LocalPlayer.Name].recycle.endTime
                        if workspace:GetServerTimeNow() >= endTime then
                            local recipeToClaim = state.store.data[LocalPlayer.Name].recycle.exchange
                            Event:FireServer(recipeToClaim)
                            notif("Auto Recycle: Meng-claim " .. tostring(recipeToClaim) .. "!", 3, "Auto")
                        end
                    end
                end
                
                -- Jika slot sedang dipakai, berhenti dan tunggu loop berikutnya
                if isRecycling then return end
                
                local targets = Config.TargetRecycle or {}
                if targets["None"] or targets["All Possible"] or not next(targets) then
                    targets = {}
                    for _, v in ipairs(RECYCLE_RECIPES) do targets[v] = true end
                end
                
                for _, recipeName in ipairs(RECYCLE_RECIPES) do
                    if targets[recipeName] then
                        notif("Auto Recycle: Firing " .. recipeName .. "...", 1, "Auto")
                        Event:FireServer(recipeName)
                        task.wait(0.5) -- Jeda agar server merespons
                        
                        -- Verifikasi apakah tembakan barusan berhasil memulai recycle
                        local success = false
                        local verifyProdMod = LocalPlayer.PlayerScripts:FindFirstChild("modules")
                            and LocalPlayer.PlayerScripts.modules:FindFirstChild("state")
                            and LocalPlayer.PlayerScripts.modules.state:FindFirstChild("producer")
                        if verifyProdMod then
                            local producer = require(verifyProdMod)
                            local state = producer:getState()
                            if state and state.store and state.store.data and state.store.data[LocalPlayer.Name] and state.store.data[LocalPlayer.Name].recycle then
                                success = true
                            end
                        end
                        
                        if success then
                            notif("Auto Recycle: Berhasil memulai " .. recipeName .. "!", 2, "Auto")
                            break
                        end
                    end
                end
            end)
            task.wait(2) -- Looping setiap 2 detik layaknya fuse
        end
        autoRecycleLoop = false
    end)
end

-- ============================================================
-- AUTO BUY TRADER
-- ============================================================
local autoTraderLoop = false

local function startAutoTrader()
    if autoTraderLoop then return end
    autoTraderLoop = true
    
    task.spawn(function()
        while Config.AutoTrader and autoTraderLoop do
            pcall(function()
                local Event = game:GetService("ReplicatedStorage").packages._Index["littensy_remo@1.5.3"].remo.container["data.trader.buyOffer"]
                if not Event then return end
                
                local prodMod = LocalPlayer.PlayerScripts:FindFirstChild("modules")
                    and LocalPlayer.PlayerScripts.modules:FindFirstChild("state")
                    and LocalPlayer.PlayerScripts.modules.state:FindFirstChild("producer")
                if not prodMod then return end
                
                local producer = require(prodMod)
                local state = producer:getState()
                if not state or not state.trader or not state.trader.offers then return end
                
                local offers = state.trader.offers
                
                local tBrainrot = Config.TraderTargetBrainrot or {}
                local tVariant = Config.TraderTargetVariant or {}
                
                -- Skip jika kedua target kosong/None
                local isBrainrotNone = (not next(tBrainrot) or tBrainrot["None"])
                local isVariantNone = (not next(tVariant) or tVariant["None"])
                if isBrainrotNone and isVariantNone then return end
                
                for index, offer in pairs(offers) do
                    if type(offer) == "table" and offer.brainrot and offer.variant then
                        local matchB = (isBrainrotNone or tBrainrot["All Possible"] or tBrainrot[offer.brainrot])
                        local matchV = (isVariantNone or tVariant["All Possible"] or tVariant[offer.variant])
                        
                        if matchB and matchV then
                            Event:FireServer(index)
                            task.wait(0.5) -- Jeda biar tidak kena rate limit
                        end
                    end
                end
            end)
            task.wait(5) -- Refresh loop yang santai untuk trader
        end
        autoTraderLoop = false
    end)
end

-- ============================================================
-- AUTO COLLECT CASH
-- ============================================================
local autoCollectCashLoop = false
local function startAutoCollectCash()
    if autoCollectCashLoop then return end
    autoCollectCashLoop = true
    
    task.spawn(function()
        while Config.AutoCollectCash and autoCollectCashLoop do
            pcall(function()
                local collectRemote = nil
                local collectAllRemote = nil
                local pkgIndex = ReplicatedStorage:FindFirstChild("packages") and ReplicatedStorage.packages:FindFirstChild("_Index")
                if pkgIndex then
                    for _, pkg in ipairs(pkgIndex:GetChildren()) do
                        if pkg.Name:find("littensy_remo") then
                            local container = pkg:FindFirstChild("remo") and pkg.remo:FindFirstChild("container")
                            if container then
                                collectRemote = container:FindFirstChild("data.base.collectPadMoney")
                                collectAllRemote = container:FindFirstChild("data.base.collectAllPadMoney")
                                if collectRemote then break end
                            end
                        end
                    end
                end
                
                local gameRemotes
                pcall(function()
                    gameRemotes = require(ReplicatedStorage:WaitForChild("shared"):WaitForChild("remotes"))
                end)
                
                if not collectRemote and not (gameRemotes and gameRemotes.data) then
                    return
                end
                
                -- Coba fitur bawaan server "Collect All" secara langsung
                local collectedAll = false
                pcall(function()
                    if collectAllRemote then
                        local res = collectAllRemote:InvokeServer()
                        if res ~= false then collectedAll = true end
                    elseif gameRemotes and gameRemotes.data and gameRemotes.data.base and gameRemotes.data.base.collectAllPadMoney then
                        local res = gameRemotes.data.base.collectAllPadMoney:request():await()
                        if res ~= false then collectedAll = true end
                    end
                end)
                
                if collectedAll then return end -- Selesai jika berhasil collect semua sekaligus
                
                -- Jika Collect All gagal / terkunci gamepass, eksekusi satu per satu
                local slotsToCollect = {}
                pcall(function()
                    local producer = require(LocalPlayer.PlayerScripts:WaitForChild("modules", 2):WaitForChild("state"):WaitForChild("producer"))
                    if producer then
                        local state = producer:getState()
                        if state and state.datas and state.datas[LocalPlayer.Name] then
                            local myBaseData = state.datas[LocalPlayer.Name].base
                            if myBaseData and myBaseData.money then
                                for slot, amount in pairs(myBaseData.money) do
                                    if type(slot) == "number" and type(amount) == "number" and amount > 0 then
                                        table.insert(slotsToCollect, slot)
                                    end
                                end
                            end
                        end
                    end
                end)
                
                -- Fallback: Jika gagal dapat data state asli, asumsikan collect semua max slot
                if #slotsToCollect == 0 then
                    for i = 1, 36 do table.insert(slotsToCollect, i) end
                end
                
                for _, slot in ipairs(slotsToCollect) do
                    if not Config.AutoCollectCash or not autoCollectCashLoop then break end
                    task.spawn(function()
                        pcall(function()
                            if collectRemote then
                                collectRemote:InvokeServer(slot)
                            elseif gameRemotes and gameRemotes.data and gameRemotes.data.base and gameRemotes.data.base.collectPadMoney then
                                gameRemotes.data.base.collectPadMoney:request(slot)
                            end
                        end)
                    end)
                    task.wait(0.02) -- Jeda cepat
                end
            end)
            task.wait(2)
        end
        autoCollectCashLoop = false
    end)
end

-- ============================================================
-- AUTO SELL BRAINROT
-- ============================================================
local autoSellLoop = false
local alreadySoldIDs = {}

local function startAutoSell()
    if autoSellLoop then return end
    autoSellLoop = true
    table.clear(alreadySoldIDs) -- Reset cache setiap kali diaktifkan
    
    task.spawn(function()
        while Config.AutoSell and autoSellLoop do
            pcall(function()
                -- Cari remote sellItem manual (fallback)
                local sellRemote = nil
                local pkgIndex = ReplicatedStorage:FindFirstChild("packages") and ReplicatedStorage.packages:FindFirstChild("_Index")
                if pkgIndex then
                    for _, pkg in ipairs(pkgIndex:GetChildren()) do
                        if pkg.Name:find("littensy_remo") then
                            local container = pkg:FindFirstChild("remo") and pkg.remo:FindFirstChild("container")
                            if container then
                                sellRemote = container:FindFirstChild("data.backpack.sellItem")
                                if sellRemote then break end
                            end
                        end
                    end
                end
                
                -- Coba pakai module bawaan game agar lebih sempurna eksekusinya
                local gameRemotes
                pcall(function()
                    gameRemotes = require(ReplicatedStorage:WaitForChild("shared"):WaitForChild("remotes"))
                end)
                
                if not sellRemote and not (gameRemotes and gameRemotes.data) then 
                    notif("Error: Remote Auto Sell tidak ditemukan!", 2, "Debug")
                    return 
                end
                
                -- SAFETY CHECK: Jika semua dropdown adalah "None", JANGAN jual apa-apa (Bahaya ludes)
                if Config.SellTargetBrainrot["None"] and Config.SellTargetMutation["None"] and Config.SellTargetRarity["None"] then
                    return
                end
                
                local function checkFilter(dict, val)
                    if dict["None"] then return true end
                    local normVal = string.lower(string.gsub(val, "_", " "))
                    for k, _ in pairs(dict) do
                        if k ~= "None" then
                            local normK = string.lower(string.gsub(k, "_", " "))
                            if normK == normVal then return true end
                        end
                    end
                    return false
                end

                -- Cari brainrot di inventory (scan GC)
                local itemsToSell = {}
                for _, v in pairs(getgc(true)) do
                    if type(v) == "table" and rawget(v, "type") == "brainrot" then
                        local bData = rawget(v, "brainrot")
                        if type(bData) == "table" then
                            local name = rawget(bData, "name")
                            local variant = rawget(bData, "variant")
                            local id = rawget(bData, "id")
                            
                            if name and id then
                                local rarity = BRAINROT_RARITY_MAP[name] or "Common"
                                
                                local mutStr = variant
                                if not mutStr or mutStr == "" then
                                    mutStr = "Non Mutasi"
                                else
                                    local lowerMut = string.lower(mutStr)
                                    if lowerMut == "none" or lowerMut == "normal" or lowerMut == "non mutasi" then
                                        mutStr = "Non Mutasi"
                                    end
                                end
                                
                                local passBrainrot = checkFilter(Config.SellTargetBrainrot, name)
                                local passMutation = checkFilter(Config.SellTargetMutation, mutStr)
                                local passRarity   = checkFilter(Config.SellTargetRarity, rarity)
                                
                                if passBrainrot and passMutation and passRarity then
                                    -- Anti-spam: jangan jual item yang ID-nya sama berkali-kali kalau nyangkut di memori
                                    if not alreadySoldIDs[id] then
                                        table.insert(itemsToSell, id)
                                        alreadySoldIDs[id] = true
                                    end
                                end
                            end
                        end
                    end
                end
                
                if #itemsToSell > 0 then
                    notif("Mencoba menjual " .. #itemsToSell .. " brainrot...", 2, "Auto Sell")
                end
                
                -- Tembak remote untuk menjual masing-masing UUID yang cocok
                for _, id in ipairs(itemsToSell) do
                    if not Config.AutoSell or not autoSellLoop then break end
                    
                    if gameRemotes and gameRemotes.data and gameRemotes.data.backpack and gameRemotes.data.backpack.sellItem then
                        gameRemotes.data.backpack.sellItem:fire(id)
                    elseif sellRemote then
                        sellRemote:FireServer(id)
                    end
                    
                    task.wait(0.1)
                end
            end)
            
            task.wait(2.5) -- Jeda SEBELUM scan berikutnya, tapi scan pertama INSTAN
        end
        autoSellLoop = false
    end)
end

local function stopFarm()
    Config.AutoFarm = false
    farmState = "idle"
    moveTarget = nil
    movePrompt = nil
    targetNest = nil
    farmTeleportFired = false
    if farmConn then farmConn:Disconnect(); farmConn = nil end
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    stopAntiShake()
    pcall(function()
        local ch = LocalPlayer.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        setAntiRollback(hrp, false)
        if ch then
            for _, part in ipairs(ch:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end)
end

local function startFarm()
    if farmConn then farmConn:Disconnect() end
    if noclipConn then noclipConn:Disconnect() end
    
    startAntiShake()  -- matikan screen shake
    task.defer(equipBestCoil)  -- equip coil terbaik
    farmState = "searching"
    farmTimer = 0 -- Di-set ke 0 agar pencarian target pertama dieksekusi INSTAN tanpa jeda

    -- Noclip Stepped Connection (Sangat kuat karena dieksekusi sebelum physics engine!)
    noclipConn = RunService.Stepped:Connect(function()
        if Config.AutoFarm and (farmState == "moving" or farmState == "returning") then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end)

    farmConn = RunService.Heartbeat:Connect(function(dt)
        if not Config.AutoFarm then farmState = "idle"; return end

        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end

        -- Set Anti Rollback: HANYA aktif saat bergerak ke target atau returning ke lobby
        local isMoving = (farmState == "moving" or farmState == "returning")
        setAntiRollback(hrp, isMoving)

        -- ── SEARCHING: scan seluruh workspace cari target dengan rank/CPS tertinggi ───
        if farmState == "searching" then
            if tick() - farmTimer < 0.1 then return end
            
            local bestModel, bestPrompt, nestKey = findBestTargetInWorkspace()
            if bestModel and nestKey then
                moveTarget = bestModel
                movePrompt = bestPrompt
                targetNest = nestKey
                farmState  = "entering"
                farmTimer  = tick()
            else
                -- Tunggu sampai ada brainrot yang spawn
                farmTimer = tick()
            end

        -- ── ENTERING: Tunggu konfirmasi teleport ──────────────────────
        elseif farmState == "entering" then
            if tick() - farmTimer < 0.5 then return end
            
            if not farmTeleportFired then
                -- Cek dulu apakah targetnya ternyata sudah di dekat kita!
                local tPos
                pcall(function()
                    if moveTarget and moveTarget.Parent then
                        local ok, pivot = pcall(function() return moveTarget:GetPivot() end)
                        if ok and pivot then
                            tPos = pivot.Position
                        else
                            local pp = moveTarget:FindFirstChildOfClass("BasePart")
                            if pp then tPos = pp.Position end
                        end
                    end
                end)
                
                -- Jika sudah dekat (< 350 studs), kita sudah di nest yang benar!
                if tPos and (hrp.Position - tPos).Magnitude < 350 then
                    KNOWN_NEST_LOCATIONS[targetNest] = hrp.Position
                    farmTeleportFired = false
                    
                    stuckTimer = tick()
                    lastDist = math.huge
                    farmState = "moving"
                    farmTimer = tick()
                    return
                end

                enterNest(targetNest)
                farmTeleportFired = true
                farmTeleportWait = tick()
                farmOldPos = hrp.Position
                return
            end
            
            -- Mengecek apakah karakter SUDAH BENAR-BENAR TER-TELEPORT ke nest oleh server
            local distMoved = (hrp.Position - farmOldPos).Magnitude
            
            if distMoved > 50 then
                -- Posisi berubah drastis (teleport berhasil!)
                -- Simpan lokasi nest ini untuk scan berikutnya!
                KNOWN_NEST_LOCATIONS[targetNest] = hrp.Position
                
                farmTeleportFired = false
                
                stuckTimer = tick()
                lastDist = math.huge
                lastStuckDist = math.huge -- RESET VARIABLE STUCK YANG BARU
                farmState = "moving"
                farmTimer = tick()
                
            elseif tick() - farmTeleportWait > 3 then
                -- Sudah 3 detik tapi tidak teleport juga = NEST TERKUNCI ATAU KEJEBAK!
                notif("Nest '"..tostring(targetNest).."' terkunci/bug! Memaksa leave...", 5, "Warning")
                lockedNests[targetNest] = true
                
                farmTeleportFired = false
                moveTarget = nil
                farmState = "leaving" -- Paksa leave nest agar tidak nyangkut terus-terusan
                farmTimer = tick()
            end

        -- ── MOVING: heartbeat walk ke posisi brainrot ───────────────────
        elseif farmState == "moving" then
            if not moveTarget or not moveTarget.Parent then
                -- Target hilang (dikumpulkan orang lain)
                -- HARUS leaveNest() dulu sebelum pindah ke nest lain!
                farmState = "leaving"
                farmTimer = tick()
                return
            end

            -- REAL-TIME SCAN: Cek jika ada target yang jauh lebih bagus (tiap 0.3 detik)
            if tick() - farmTimer > 0.3 then
                farmTimer = tick()
                local newModel, newPrompt, newNest, newCPS = findBestTargetInWorkspace()
                
                if newModel and newModel ~= moveTarget then
                    -- Hitung CPS target saat ini untuk perbandingan
                    local curName = moveTarget:GetAttribute("name") or moveTarget.Name
                    
                    local curMut = moveTarget:GetAttribute("variant") or moveTarget:GetAttribute("Variant") or moveTarget:GetAttribute("Mutation")
                    if not curMut and moveTarget:GetAttribute("name") and moveTarget.Name ~= moveTarget:GetAttribute("name") then
                        curMut = moveTarget.Name
                    end
                    curMut = curMut or "Normal"
                    
                    local curMutNorm = curMut:sub(1,1):upper() .. curMut:sub(2):lower()
                    local curRarity = moveTarget:GetAttribute("Rarity") or moveTarget:GetAttribute("rarity") or BRAINROT_RARITY_MAP[curName] or "Common"
                    local curBaseCPS = BRAINROT_CPS_MAP[curName] or DEFAULT_RARITY_CPS[curRarity] or 0
                    local currentCPS = curBaseCPS * (MUTATION_MULTIPLIER[curMutNorm] or 1.0)
                    
                    if newCPS > currentCPS then
                        moveTarget = newModel
                        movePrompt = newPrompt
                        
                        if newNest ~= targetNest then
                            targetNest = newNest
                            farmState = "entering"
                            farmTeleportFired = false
                            farmTimer = tick()
                            return
                        else
                            stuckTimer = tick()
                            lastDist = math.huge
                        end
                    end
                end
            end

            -- Cari posisi target dengan presisi tinggi (ApexDev patch: pakai ProximityAttachment!)
            local targetPos
            pcall(function()
                if moveTarget and moveTarget.Parent then
                    local proxAttach = moveTarget:FindFirstChild("ProximityAttachment")
                    if proxAttach then
                        if proxAttach:IsA("Attachment") then targetPos = proxAttach.WorldPosition
                        elseif proxAttach:IsA("BasePart") then targetPos = proxAttach.Position end
                    end
                    
                    if not targetPos then
                        local ok, pivot = pcall(function() return moveTarget:GetPivot() end)
                        if ok and pivot then
                            targetPos = pivot.Position
                        else
                            local pp = moveTarget:FindFirstChildOfClass("BasePart")
                            if pp then targetPos = pp.Position end
                        end
                    end
                end
            end)
            if not targetPos then
                farmState = "searching"; farmTimer = tick(); return
            end

            -- Cek apakah karakter baru saja respawn / mati (Mencegah terbang dari lobby ke target lama)
            if not hrp:GetAttribute("FarmInitialized") then
                hrp:SetAttribute("FarmInitialized", true)
                -- Jika baru respawn, reset state!
                if farmState == "moving" or farmState == "entering" or farmState == "returning" then
                    farmState = "searching"
                    farmTimer = tick()
                    moveTarget = nil
                    return
                end
            end

            local dist = (hrp.Position - targetPos).Magnitude

            if dist > 250 then
                -- Jarak terlalu jauh (berada di beda ruangan)! Blacklist nest ini agar script mencoba nest lain!
                moveTarget:SetAttribute("NotInNest_" .. targetNest, true)
                farmState = "leaving"
                farmTimer = tick()
                return
            end

            -- STUCK DETECTION: Cek progres pergerakan setiap 2 detik
            if not lastStuckDist or lastStuckDist == math.huge then
                lastStuckDist = dist
                stuckTimer = tick()
            end

            if tick() - stuckTimer > 2.0 then
                -- Dalam 2 detik harusnya kita maju ~100 stud (karena speed 50).
                -- Jika jarak ke target berkurang kurang dari 10 stud, fix kita nabrak tembok!
                if (lastStuckDist - dist) < 10 then
                    notif("Nabrak tembok! Brainrot beda ruangan, blacklist " .. targetNest, 3, "Warning")
                    moveTarget:SetAttribute("NotInNest_" .. targetNest, true)
                    farmState = "leaving"
                    farmTimer = tick()
                    return
                end
                -- Lolos cek, update rekor jarak
                lastStuckDist = dist
                stuckTimer = tick()
            end

            if dist <= REACH_DIST then
                -- Sudah dekat → ubah state ke grabbing untuk nunggu 0.1s
                farmState  = "grabbing"
                farmTimer  = tick()
            else
                -- Gerak ke arah brainrot
                local dir  = (targetPos - hrp.Position).Unit
                local step = math.min(MOVE_SPEED * dt, dist - 1)
                hrp.CFrame = hrp.CFrame + dir * step
            end

        -- ── GRABBING: tunggu 0.1 detik sebelum fire prompt agar tidak gagal grab ──
        elseif farmState == "grabbing" then
            if tick() - farmTimer < 0.1 then return end
            if movePrompt then
                fireProximityPrompt(movePrompt)
            end
            moveTarget = nil
            movePrompt = nil
            farmState  = "leaving"
            farmTimer  = tick()

        -- ── LEAVING: fire remote leave nest, lalu jalan balik ke lobby ──
        elseif farmState == "leaving" then
            if tick() - farmTimer < 0.1 then return end
            leaveNest()
            farmState = "returning"
            farmTimer = tick()

        -- ── RETURNING: noclip + cepat ke koordinat lobby ────────────────
        elseif farmState == "returning" then
            local HOME_POS  = Vector3.new(-48.56, 33.51, -295.75)
            local HOME_DIST = 12   -- threshold "sudah sampai"
            local RETURN_SPEED = 120 -- stud/s ditingkatkan agar lebih cepat balik

            local dist = (hrp.Position - HOME_POS).Magnitude
            if dist <= HOME_DIST then
                -- Sudah sampai → matikan noclip → searching
                farmState = "searching"
                farmTimer = tick()
            else
                local dir  = (HOME_POS - hrp.Position).Unit
                local step = math.min(RETURN_SPEED * dt, dist - 1)
                hrp.CFrame = CFrame.new(hrp.Position + dir * step)
            end
        end
    end)
end

-- ============================================================
-- Anti-AFK
-- ============================================================
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ============================================================
-- UI
-- ============================================================
local Window = Library:Window({
    Title     = "Napoleon",
    Footer    = "Inside Brainrot",
    Color     = Color3.fromRGB(255, 255, 255),
    Color2    = Color3.fromRGB(192, 192, 192),
    ["Tab Width"] = 130,
    Image     = "136289055140268",
    WindowIMG = "93732999692312",
    LogoHUB   = "136289055140268",
})
local Tabs = Window

-- ── TAB: Info ──────────────────────────────────────────────
local InfoTab = Tabs:AddTab({ Name = "Info", Icon = "info" })
local InfoSection = InfoTab:AddSection("Napoleon — Inside Brainrot", true)
InfoSection:AddParagraph({
    Title   = "📋 Script Info",
    Content = "Auto Farm: Automatically selects the correct nest, collects brainrots, and repeats.\n\nTarget Brainrot: Filter specific brainrot names.\nTarget Mutation: Filter mutations (Gold, Eternal, etc).\nTarget Rarity: Filter rarity (Epic, Legendary, etc).\n\nIf all filters are 'None', it will farm all brainrots from the noob nest.",
})
InfoSection:AddButton({
    Title = "Join Discord",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/RKaZ9vEbpb")
            notif("Discord link copied!", 3, "Napoleon")
        else
            notif("discord.gg/RKaZ9vEbpb", 5, "Napoleon")
        end
    end,
})

-- ── TAB: Main ──────────────────────────────────────────────
local MainTab = Tabs:AddTab({ Name = "Main", Icon = "rod" })
local FarmSection = MainTab:AddSection("Auto Farm")

-- Toggle Auto Farm
FarmSection:AddToggle({
    Title   = "Auto Farm",
    Title2  = "Enable",
    Content = "Automatically selects nest based on filters and collects brainrots",
    Default = false,
    Callback = function(val)
        Config.AutoFarm = val
        if val then
            startFarm()
            notif("Auto Farm ON ✅", 4, "Farm")
        else
            stopFarm()
            notif("Auto Farm OFF", 4, "Farm")
        end
    end,
})

-- Toggle Freeze Guard
FarmSection:AddToggle({
    Title   = "Freeze Guard",
    Title2  = "Enable",
    Content = "Freezes all guards in the nest so they don't interrupt your farm",
    Default = false,
    Callback = function(val)
        Config_FreezeGuard = val
        if val then
            startFreezeGuard()
            notif("Freeze Guard ON ✅", 4, "Guard")
        else
            stopFreezeGuard()
            notif("Freeze Guard OFF", 4, "Guard")
        end
    end,
})

-- Dropdown 1: Target Brainrot
local dropFarmBrainrot
dropFarmBrainrot = FarmSection:AddDropdown({
    Title   = "Target Brainrot",
    Content = "Select specific brainrot names (Multi-select)",
    Options = ALL_BRAINROTS,
    Default = {"None"},
    Multi   = true,
    Callback = function(val)
        local arr = handleDropdownChange(val, dropFarmBrainrot)
        Config.TargetBrainrot = parseMultiDropdown(arr)
    end,
})

-- Dropdown 2: Target Mutasi
local dropFarmMutasi
dropFarmMutasi = FarmSection:AddDropdown({
    Title   = "Target Mutation",
    Content = "Select specific mutations (Multi-select)",
    Options = MUTATION_LIST,
    Default = {"None"},
    Multi   = true,
    Callback = function(val)
        local arr = handleDropdownChange(val, dropFarmMutasi)
        Config.TargetMutation = parseMultiDropdown(arr)
    end,
})

-- Dropdown 3: Target Rarity
local dropFarmRarity
dropFarmRarity = FarmSection:AddDropdown({
    Title   = "Target Rarity",
    Content = "Select specific rarities (Multi-select)",
    Options = RARITY_LIST,
    Default = {"None"},
    Multi   = true,
    Callback = function(val)
        local arr = handleDropdownChange(val, dropFarmRarity)
        Config.TargetRarity = parseMultiDropdown(arr)
    end,
})

-- ============================================================
-- TAB: Auto (Sell)
-- ============================================================
local AutoTab = Tabs:AddTab({ Name = "Auto", Icon = "wallet" })
local AutoSellSection = AutoTab:AddSection("Auto Sell Brainrot")

-- Toggle Auto Sell
AutoSellSection:AddToggle({
    Title   = "Auto Sell",
    Title2  = "Enable",
    Content = "Automatically sells brainrots in your inventory based on filters below",
    Default = false,
    Callback = function(val)
        Config.AutoSell = val
        if val then
            startAutoSell()
            notif("Auto Sell ON ✅", 4, "Farm")
        else
            autoSellLoop = false
            notif("Auto Sell OFF", 4, "Farm")
        end
    end,
})

-- Dropdown 1: Target Brainrot Sell
local dropSellBrainrot
dropSellBrainrot = AutoSellSection:AddDropdown({
    Title   = "Target Brainrot to Sell",
    Content = "Select brainrot names to automatically sell",
    Options = ALL_BRAINROTS,
    Default = {"None"},
    Multi   = true,
    Callback = function(val)
        local arr = handleDropdownChange(val, dropSellBrainrot)
        Config.SellTargetBrainrot = parseMultiDropdown(arr)
    end,
})

-- Dropdown 2: Target Mutasi Sell
local dropSellMutasi
dropSellMutasi = AutoSellSection:AddDropdown({
    Title   = "Target Mutation to Sell",
    Content = "Select mutations to sell (Check 'Non Mutasi' for normal brainrots)",
    Options = MUTATION_LIST,
    Default = {"None"},
    Multi   = true,
    Callback = function(val)
        local arr = handleDropdownChange(val, dropSellMutasi)
        Config.SellTargetMutation = parseMultiDropdown(arr)
    end,
})

-- Dropdown 3: Target Rarity Sell
local dropSellRarity
dropSellRarity = AutoSellSection:AddDropdown({
    Title   = "Target Rarity to Sell",
    Content = "Select rarities to automatically sell",
    Options = RARITY_LIST,
    Default = {"None"},
    Multi   = true,
    Callback = function(val)
        local arr = handleDropdownChange(val, dropSellRarity)
        Config.SellTargetRarity = parseMultiDropdown(arr)
    end,
})

-- ============================================================
-- TAB: Auto (Base)
-- ============================================================
local AutoBaseSection = AutoTab:AddSection("Auto Base")

AutoBaseSection:AddToggle({
    Title   = "Auto Collect Cash",
    Title2  = "Enable",
    Content = "Continuously collects cash from all brainrot pads in your base",
    Default = false,
    Callback = function(val)
        Config.AutoCollectCash = val
        if val then
            startAutoCollectCash()
            notif("Auto Collect Cash ON ✅", 4, "Auto")
        else
            autoCollectCashLoop = false
            notif("Auto Collect Cash OFF", 4, "Auto")
        end
    end,
})

-- ============================================================
-- TAB: Auto (Fuse)
-- ============================================================
local AutoFuseSection = AutoTab:AddSection("Auto Fuse")

AutoFuseSection:AddToggle({
    Title   = "Auto Fuse",
    Title2  = "Enable",
    Content = "Automatically crafts brainrots and claims them when finished",
    Default = false,
    Callback = function(val)
        Config.AutoFuse = val
        if val then
            startAutoFuse()
            notif("Auto Fuse ON ✅", 4, "Auto")
        else
            autoFuseLoop = false
            notif("Auto Fuse OFF", 4, "Auto")
        end
    end,
})

local FUSE_RECIPE_LIST = {
    "None", "All Possible", 
    "piectopus", "reptistono", "kingFalken", "lordoRobo", "rengRongo", 
    "pineaplino", "vulture", "tralala", "bee", "lordVeyrath"
}

local dropFuse
dropFuse = AutoFuseSection:AddDropdown({
    Title   = "Target Fuse Recipe",
    Content = "Select specific recipes to prioritize for fusion",
    Options = FUSE_RECIPE_LIST,
    Default = {"All Possible"},
    Multi   = true,
    Callback = function(val)
        local arr = handleDropdownChange(val, dropFuse)
        Config.TargetFuse = parseMultiDropdown(arr)
    end,
})

local AutoRecycleSection = AutoTab:AddSection("Auto Recycle (Token Machine)")

local RECYCLE_RECIPE_LIST = {
    "None", "All Possible",
    "frogzoSoda", "cupitronUFO", "techScorpio", "fireCappuccino", 
    "tralalaTralalita", "eleccoBee", "pineaplino", "vulture", 
    "rengRongo", "crocoBling", "lordoRobo", "piectopus", 
    "kingFalken", "reptistono", "lordVeyrath"
}

local dropRecycle
dropRecycle = AutoRecycleSection:AddDropdown({
    Title   = "Target Recycle Recipe",
    Content = "Select specific brainrots to convert into tokens",
    Options = RECYCLE_RECIPE_LIST,
    Default = {"All Possible"},
    Multi   = true,
    Callback = function(val)
        local arr = handleDropdownChange(val, dropRecycle)
        Config.TargetRecycle = parseMultiDropdown(arr)
    end,
})

AutoRecycleSection:AddToggle({
    Title    = "Auto Recycle",
    Content  = "Automatically recycles/converts pets into tokens",
    Default  = false,
    Callback = function(val)
        Config.AutoRecycle = val
        if val then startAutoRecycle() end
    end
})

local AutoTraderSection = AutoTab:AddSection("Auto Buy (Trader)")

local dropTraderBrainrot
dropTraderBrainrot = AutoTraderSection:AddDropdown({
    Title   = "Target Brainrot to Buy",
    Content = "Select specific brainrots to buy from the Trader",
    Options = ALL_BRAINROTS,
    Default = {"None"},
    Multi   = true,
    Callback = function(val)
        local arr = handleDropdownChange(val, dropTraderBrainrot)
        Config.TraderTargetBrainrot = parseMultiDropdown(arr)
    end,
})

local dropTraderMutasi
dropTraderMutasi = AutoTraderSection:AddDropdown({
    Title   = "Target Mutation to Buy",
    Content = "Select specific mutations to buy (e.g. Gold, Eternal)",
    Options = MUTATION_LIST,
    Default = {"None"},
    Multi   = true,
    Callback = function(val)
        local arr = handleDropdownChange(val, dropTraderMutasi)
        Config.TraderTargetVariant = parseMultiDropdown(arr)
    end,
})

AutoTraderSection:AddToggle({
    Title    = "Auto Buy Trader",
    Content  = "Automatically buys pets from the Trader based on your filters",
    Default  = false,
    Callback = function(val)
        Config.AutoTrader = val
        if val then startAutoTrader() end
    end
})

-- ============================================================
-- Anti-AFK
-- ============================================================
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ============================================================
-- DONE
-- ============================================================
task.wait(1)
_G.ScriptFullyLoaded = true
notif("Inside Brainrot loaded! Buka tab Main untuk mulai.", 5, "Napoleon")
