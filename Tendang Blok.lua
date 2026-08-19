-- -- ============================================================
-- -- CORE SECURITY: ANTI-HOOK, ANTI-SPY, & ANTI-TAMPER V3.2
-- -- ============================================================
-- local Proteksi = { Aman = true }

-- local function Banned(alasan)
--     Proteksi.Aman = false
--     local p = game:GetService("Players").LocalPlayer
--     if p then
--         p:Kick("Access Denied: " .. alasan)
--     end
--     task.wait(9e9)
-- end

-- pcall(function()
--     local dummyEvent = Instance.new("RemoteEvent")
--     local dummyFunc = Instance.new("RemoteFunction")

--     local realFire = dummyEvent.FireServer
--     local realInvoke = dummyFunc.InvokeServer

--     if ishooked then
--         if ishooked(realFire) and ishooked(realInvoke) then
--             Banned("RemoteSpy Detected (FireServer & InvokeServer Hook)")
--         end
--     end

--     if iscclosure and islclosure then
--         if islclosure(realFire) and islclosure(realInvoke) then
--             Banned("RemoteSpy Detected (Remote Closure Hook)")
--         end
--     end

--     local KataTerlarang = {"hydroxide", "turtle spy", "cobalt", "bypasser", "remote spy", "simple spy", "ultimate debugging suite", "dark dex", "dex++"}
--     local SafeWords = {"codex", "index", "pokedex", "delta", "arceus", "fluxus", "hydrogen", "macsploit", "vegas", "evon", "furk", "trigon", "executor", "menu", "hub", "isylhub"}
--     local IgnoreGuis = {"robloxgui", "chat", "bubblechat", "playerlist", "teleportgui", "robloxpromptgui", "purchaseprompt", "corescriptsroot"}

--     local function isDexOrSpy(str)
--         str = string.lower(str)
--         if str == "dex" or str == "spy" then return false end

--         if string.find(str, "dex") or string.find(str, "spy") then
--             for _, safe in ipairs(SafeWords) do
--                 if string.find(str, safe) then return false end
--             end
--             return true
--         end
--         return false
--     end

--     task.spawn(function()
--         while Proteksi.Aman do
--             task.wait(3)
--             local currentContainers = {game:GetService("CoreGui")}
--             pcall(function() if gethui then table.insert(currentContainers, gethui()) end end)
            
--             for _, container in ipairs(currentContainers) do
--                 pcall(function()
--                     for _, ui in ipairs(container:GetChildren()) do
--                         pcall(function()
--                             local name = string.lower(ui.Name)
--                             if table.find(IgnoreGuis, name) then return end

--                             -- SCAN 1: Cek Nama dari UI (GUI Name)
--                             for _, bad in ipairs(KataTerlarang) do
--                                 if string.find(name, bad) then Banned("Illegal UI Detected ("..bad..")") end
--                             end
--                             if isDexOrSpy(name) then Banned("Illegal UI Detected ("..name..")") end
                            
--                             -- SCAN 2: Cek Isi Teks di dalam UI
--                             for _, desc in pairs(ui:GetDescendants()) do
--                                 pcall(function()
--                                     if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
--                                         local text = string.lower(desc.Text)
--                                         if string.len(text) < 40 then
--                                             -- Kita HANYA mencari kata terlarang spesifik (seperti "dark dex")
--                                             for _, bad in ipairs(KataTerlarang) do
--                                                 if string.find(text, bad) then
--                                                     Banned("Illegal Text Element Detected ("..text..")")
--                                                 end
--                                             end
                                            
--                                             -- FIX V3.2:
--                                             -- Pengecekan isDexOrSpy(text) DIHAPUS dari sini!
--                                             -- Ini mencegah false positive saat ada notifikasi game/executor
--                                             -- yang bertuliskan nama player seperti "you've joined dex".
--                                         end
--                                     end
--                                 end)
--                             end
--                         end)
--                     end
--                 end)
--             end
--         end
--     end)
-- end)

-- if not Proteksi.Aman then
--     return 
-- end

-- -- ============================================================
-- -- KEY SYSTEM & TRACKING
-- -- ============================================================

-- local function showWarningUI(message)
--     local ScreenGui = Instance.new("ScreenGui")
--     local Frame = Instance.new("Frame")
--     local UICorner = Instance.new("UICorner")
--     local Title = Instance.new("TextLabel")
--     local Key = Instance.new("TextLabel")
--     local Description = Instance.new("TextLabel")
--     local ButtonClose = Instance.new("TextButton")
--     local UICorner_2 = Instance.new("UICorner")
--     local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
--     local Background = Instance.new("Frame")
--     local UIStroke = Instance.new("UIStroke")

--     ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
--     ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
--     ScreenGui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
--     ScreenGui.ScreenInsets = Enum.ScreenInsets.None

--     Background.Name = "Background"
--     Background.Parent = ScreenGui
--     Background.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
--     Background.BackgroundTransparency = 0.300
--     Background.BorderColor3 = Color3.fromRGB(0, 0, 0)
--     Background.BorderSizePixel = 0
--     Background.Size = UDim2.new(1, 0, 1, 0)
--     Background.ZIndex = 0

--     Frame.Parent = ScreenGui
--     Frame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
--     Frame.BackgroundTransparency = 0.100
--     Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
--     Frame.BorderSizePixel = 0
--     Frame.Position = UDim2.new(0.248725787, 0, 0.40242058, 0)
--     Frame.Size = UDim2.new(0.502548397, 0, 0.146747351, 0)

--     UICorner.CornerRadius = UDim.new(0.0500000007, 0)
--     UICorner.Parent = Frame
    
--     UIStroke.Parent = Frame
--     UIStroke.Color = Color3.fromRGB(255, 255, 255)
--     UIStroke.Thickness = 1

--     Title.Name = "Title"
--     Title.Parent = Frame
--     Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
--     Title.BackgroundTransparency = 1.000
--     Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
--     Title.BorderSizePixel = 0
--     Title.Position = UDim2.new(0.198198214, 0, 0, 0)
--     Title.Size = UDim2.new(0.6006006, 0, 0.289151847, 0)
--     Title.Font = Enum.Font.GothamBold
--     Title.Text = "Napoleon | Warning"
--     Title.TextColor3 = Color3.fromRGB(255, 255, 255)
--     Title.TextScaled = true
--     Title.TextSize = 14.000
--     Title.TextWrapped = true

--     Key.Name = "Key"
--     Key.Parent = Frame
--     Key.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
--     Key.BackgroundTransparency = 1.000
--     Key.BorderColor3 = Color3.fromRGB(0, 0, 0)
--     Key.BorderSizePixel = 0
--     Key.Position = UDim2.new(0.22862418, 0, 0.550000012, 0)
--     Key.Size = UDim2.new(0.533663452, 0, 0.154971421, 0)
--     Key.Font = Enum.Font.GothamBold
--     Key.Text = "discord.gg/napoleonsc"
--     Key.TextColor3 = Color3.fromRGB(106, 106, 124)
--     Key.TextScaled = true
--     Key.TextSize = 14.000
--     Key.TextWrapped = true

--     Description.Name = "Description"
--     Description.Parent = Frame
--     Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
--     Description.BackgroundTransparency = 1.000
--     Description.BorderColor3 = Color3.fromRGB(0, 0, 0)
--     Description.BorderSizePixel = 0
--     Description.Position = UDim2.new(0.060851898, 0, 0.306907117, 0)
--     Description.Size = UDim2.new(0.871821165, 0, 0.216986924, 0)
--     Description.Font = Enum.Font.Gotham
--     Description.Text = message
--     Description.TextColor3 = Color3.fromRGB(255, 255, 255)
--     Description.TextScaled = true
--     Description.TextSize = 14.000
--     Description.TextWrapped = true

--     ButtonClose.Name = "ButtonClose"
--     ButtonClose.Parent = Frame
--     ButtonClose.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
--     ButtonClose.BorderColor3 = Color3.fromRGB(0, 0, 0)
--     ButtonClose.BorderSizePixel = 0
--     ButtonClose.Position = UDim2.new(0.385395527, 0, 0.747835159, 0)
--     ButtonClose.Size = UDim2.new(0.229208946, 0, 0.206185549, 0)
--     ButtonClose.Font = Enum.Font.GothamBold
--     ButtonClose.Text = "Close"
--     ButtonClose.TextColor3 = Color3.fromRGB(255, 255, 255)
--     ButtonClose.TextScaled = true
--     ButtonClose.TextSize = 14.000
--     ButtonClose.TextWrapped = true

--     UICorner_2.CornerRadius = UDim.new(1, 0)
--     UICorner_2.Parent = ButtonClose

--     UITextSizeConstraint.Parent = ButtonClose
--     UITextSizeConstraint.MaxTextSize = 14
    
--     ButtonClose.MouseButton1Click:Connect(function()
--         ScreenGui:Destroy()
--     end)
-- end

-- local HttpService = game:GetService("HttpService")
-- local key = getgenv().Key or _G.Key

-- if not key then
--     showWarningUI("Key tidak ditemukan! Silahkan masukkan getgenv().Key")
--     return
-- end

-- local hwid = tostring(game:GetService("Players").LocalPlayer.UserId)
-- local mySessionNonce = HttpService:GenerateGUID(false)
-- local checkUrl = "http://napoleon-script.my.id/api/check?key=" .. key .. "&hwid=" .. hwid .. "&nonce=" .. mySessionNonce

-- local function decryptXOR(hexStr, secretKey)
--     local result = ""
--     local charIdx = 0
--     for i = 1, #hexStr, 2 do
--         local hexByte = hexStr:sub(i, i + 1)
--         local byte = tonumber(hexByte, 16)
--         if not byte then return nil end
--         local keyChar = secretKey:byte((charIdx % #secretKey) + 1)
--         result = result .. string.char(bit32.bxor(byte, keyChar))
--         charIdx = charIdx + 1
--     end
--     return result
-- end

-- local SECRET_KEY = "HOEEEE_MALING_PANGSIT"

-- local successCheck, responseCheck = pcall(function()
--     return game:HttpGet(checkUrl)
-- end)

-- if successCheck then
--     local decrypted = decryptXOR(responseCheck, SECRET_KEY)
    
--     if decrypted then
--         local splitPos = decrypted:find("|")
--         if splitPos then
--             local timestampStr = decrypted:sub(1, splitPos - 1)
--             local jsonStr = decrypted:sub(splitPos + 1)
            
--             local serverTime = tonumber(timestampStr)
--             local localTime = workspace:GetServerTimeNow()
            
--             if serverTime and math.abs(localTime - serverTime) > 60 then
--                 showWarningUI("Sesi kadaluarsa / Bypass terdeteksi! (Time Mismatch)")
--                 return
--             end
            
--             local ok, data = pcall(function() return HttpService:JSONDecode(jsonStr) end)
--             if ok and type(data) == "table" then
                
--                 if data.nonce ~= mySessionNonce then
--                     game.Players.LocalPlayer:Kick("Security Alert: HTTP Spoofing / Hooking Terdeteksi!")
--                     while true do end 
--                 end

--                 if not data.valid then
--                     showWarningUI(data.message or "Key tidak valid / Belum reset HWID!")
--                     return
--                 end
--             else
--                 showWarningUI("Invalid response (Bukan JSON) dari server.")
--                 return
--             end
--         else
--             showWarningUI("Format data dari server tidak valid!")
--             return
--         end
--     else
--         showWarningUI("Gagal mendekripsi data dari server.")
--         return
--     end
-- else
--     showWarningUI("Gagal terhubung ke server validasi key.")
--     return
-- end

-- ============================================================
-- TRACKING
-- ============================================================
-- local function getExecutorName()
--     if identifyexecutor then return identifyexecutor() end
--     if syn then return "Synapse X"
--     elseif Ronix then return "Ronix"
--     elseif fluxus then return "Fluxus"
--     elseif DELTA_VERSION then return "Delta"
--     else return "Unknown" end
-- end

-- task.spawn(function()
--     pcall(function()
--         -- Menggunakan waktu server global untuk log agar tidak dipalsukan jam lokal
--         local currentTime = workspace:GetServerTimeNow()
--         local logPath = "Napoleon_KICK-A-LUCKY-BLOCK_LastExec.txt"
        
--         if isfile and readfile and writefile then
--             if isfile(logPath) then
--                 local lastTime = tonumber(readfile(logPath))
--                 if lastTime and (currentTime - lastTime) < 3600 then
--                     return 
--                 end
--             end
--             writefile(logPath, tostring(currentTime))
--         else
--             if getgenv()._Napoleon_ExecLogged_Slime then return end
--             getgenv()._Napoleon_ExecLogged_Slime = true
--         end

--         local player = game:GetService("Players").LocalPlayer
--         if player then
--             local userid = tostring(player.UserId)
--             local username = player.Name
--             local executor = getExecutorName()
--             local placeid = tostring(game.PlaceId)
            
--             local url = "http://napoleon-script.my.id/api/track"
--                 .. "?script=KICK-A-LUCKY-BLOCK"
--                 .. "&userid=" .. userid
--                 .. "&username=" .. username
--                 .. "&executor=" .. (executor:gsub(" ", "%%20"))
--                 .. "&placeid=" .. placeid
--                 .. "&key=" .. key
                
--             game:HttpGet(url)
--         end
--     end)
-- end)

-- ============================================================
-- Napoleon UI Library
-- ============================================================
_G.ScriptFullyLoaded = false -- Fix: Reset status so notifications don't spam on re-execution

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Fdhlnn23/NapoleonUI/refs/heads/main/NPLN-UIv2.lua"))()

local ICON_ID = "96531489912535" -- Icon Napoleon

local function notif(content, duration, title)
    -- Blokir notif spam saat UI di-load, kecuali notif sukses di akhir
    if not _G.ScriptFullyLoaded then
        return
    end

    if Library and Library.MakeNotify then
        Library:MakeNotify({ Title = title or "Napoleon", Content = content, Delay = duration or 4, Icon = "rbxassetid://" .. ICON_ID })
    end
end


-- ============================================================
-- SERVICES & CORE
-- ============================================================
local Players          = game:GetService("Players")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local VirtualUser      = game:GetService("VirtualUser")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")
local TweenService     = game:GetService("TweenService")
local Lighting         = game:GetService("Lighting")
local Terrain          = workspace:FindFirstChildOfClass("Terrain")

local saverConnection  = nil
local blackScreenGui   = nil

local LocalPlayer      = Players.LocalPlayer
local isfromload = true

local KickEvent = ReplicatedStorage
    :WaitForChild("Shared")
    :WaitForChild("Packages")
    :WaitForChild("Network")
    :WaitForChild("rev_KickEvent")

local CollectEvent = ReplicatedStorage
    :WaitForChild("Shared")
    :WaitForChild("Packages")
    :WaitForChild("Network")
    :WaitForChild("rev_B_Collect")

local UpgradeRemote = ReplicatedStorage
    :WaitForChild("Shared")
    :WaitForChild("Packages")
    :WaitForChild("Network")
    :WaitForChild("rev_B_Upgrade")

local SellRemote = ReplicatedStorage
    :WaitForChild("Shared")
    :WaitForChild("Packages")
    :WaitForChild("Network")
    :WaitForChild("ref_B_Sell")

-- local CollectShardEvent = ReplicatedStorage
--     :WaitForChild("Shared")
--     :WaitForChild("Packages")
--     :WaitForChild("Network")
--     :WaitForChild("rev_CollectShard")

local CollectZone = workspace:WaitForChild("Zones"):WaitForChild("CollectZone")

local SpeedServiceClient = nil
pcall(function()
    SpeedServiceClient = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ServicesLoader"):WaitForChild("SpeedServiceClient"))
end)

local function getRealRunSpeed()
    if SpeedServiceClient then
        local ok, spd = pcall(function()
            local mult = SpeedServiceClient.Multiplier or 1
            local curr = SpeedServiceClient.CurrentSpeed or 16
            if SpeedServiceClient.InSlowMode then
                return curr
            end
            return curr * mult
        end)
        if ok and type(spd) == "number" then
            return spd
        end
    end
    
    -- Fallback
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        return char.Humanoid.WalkSpeed
    end
    
    return 16
end

-- ============================================================
-- CONFIG
-- ============================================================
local Config = {
    AutoFarm           = false,
    isRejoin         = false,
    AutoClickUpgrade   = true,   -- default ON, di Misc
    AutoRebirth        = false,
    AutoCollectCash    = false,
    CollectTimer       = 1,
    AutoUpgradeLevel   = false,
    TargetUpgradeLevel = 50,
    AutoSummon           = false,
    TargetSummonMutation = "None",

    EnableSnap         = false,
    SnapMode           = "Spesifik",
    SnapNameRules      = {}, -- Aturan by Nama: {["Meowl"] = {["Rainbow"] = true}}
    SnapRarityRules    = {},  -- {"None"} = semua rarity boleh

    EquipMode          = "CPS",

    -- Auto Equip Filter
    AutoEquipFilter        = false,
    EquipFilterBrainrots   = {"None"},
    EquipFilterMutations   = {"None"},
    EquipFilterLevel       = 0, -- 0 = semua level

    -- Auto Sell
    AutoSell             = false,
    SellMode             = "Brainrot",    -- "Brainrot", "Rarity"
    TargetSellBrainrots  = {"None"},
    TargetSellRarities   = {"None"},
    TargetSellMutations  = {"None"},

    -- Auto Trade
    AutoTrade            = false,
    TradeTargetPlayer    = "None",
    TargetTradeBrainrots = {"None"},
    TargetTradeRarities  = {"None"},
    TargetTradeMutations = {"None"},
    TradeAmount          = 0,

    -- Auto Accept Trade
    AutoAcceptTrade      = false,

    -- Webhook
    EnableWebhook        = false,
    WebhookURL           = "",
    WebhookRarities      = {"None"},
    WebhookMutations     = {"None"},

    -- Inventory Webhook
    EnableInventoryWebhook = false,
    InventoryWebhookURL    = "",
    InventoryWebhookTimer  = 10,
}

local HttpService = game:GetService("HttpService")
local snapConfigPath = "Napoleon_SnapRules.json"

-- Fungsi untuk menyimpan Rule ke dalam file
local function saveSnapConfig()
    if writefile then
        local dataToSave = {
            NameRules = Config.SnapNameRules or {},
            RarityRules = Config.SnapRarityRules or {}
        }
        pcall(function()
            writefile(snapConfigPath, HttpService:JSONEncode(dataToSave))
        end)
    end
end

-- Fungsi untuk memuat Rule dari file
local function loadSnapConfig()
    if isfile and readfile and isfile(snapConfigPath) then
        pcall(function()
            local content = readfile(snapConfigPath)
            local decodedData = HttpService:JSONDecode(content)
            if decodedData then
                Config.SnapNameRules = decodedData.NameRules or {}
                Config.SnapRarityRules = decodedData.RarityRules or {}
            end
        end)
    end
end

-- Muat konfigurasi yang tersimpan saat script pertama kali dieksekusi
loadSnapConfig()

-- ============================================================
-- DATABASE AUTO-EXTRACTION (DARI GAME MODULES)
-- ============================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataFolder = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Data")

-- Require Module bawaan game
local MutationData = require(DataFolder:WaitForChild("MutationData"))
local RarityData = require(DataFolder:WaitForChild("RarityData"))
local EntitiesData = require(DataFolder:WaitForChild("EntitiesData"))

-- 1. Setup Data Mutasi
local MUTATION_LIST = { "None", "Non Mutasi" }
local MutationBuffs = {}

if MutationData.ValidMutations then
    for _, mut in ipairs(MutationData.ValidMutations) do
        table.insert(MUTATION_LIST, mut)
    end
end

if MutationData.Buffs then
    for mut, data in pairs(MutationData.Buffs) do
        MutationBuffs[mut] = data.Value or 1
    end
end

-- 2. Fungsi Parse CPS (Menangani InfiniteMath Object / String Format)
local function parseCPS(cpsObj)
    if not cpsObj then return 0 end
    if type(cpsObj) == "number" then return cpsObj end
    
    local ok, num = pcall(function()
        local str = tostring(cpsObj):gsub(",", "")
        local suffixes = {K = 1e3, M = 1e6, B = 1e9, T = 1e12, Qa = 1e15, Qi = 1e18}
        local valStr, suffix = str:match("^([%d%.]+)%s*([a-zA-Z]*)$")
        
        if valStr then
            local n = tonumber(valStr)
            if n and suffix and suffixes[suffix] then
                return n * suffixes[suffix]
            elseif n then
                return n
            end
        end
        return tonumber(str)
    end)
    
    return (ok and type(num) == "number") and num or 0
end

-- 3. Setup Data Brainrot & Rarity
local EntityBaseCPS = {}
local BRAINROT_RARITY_MAP = {}
local BRAINROT_LIST = { "None" }
local tempBrainrotNames = {}
local raritySet = {}

if EntitiesData.Brainrots then
    for name, data in pairs(EntitiesData.Brainrots) do
        local rarity = data.Rarity or "Common"
        
        BRAINROT_RARITY_MAP[name] = rarity
        EntityBaseCPS[name] = parseCPS(data.CPS)
        raritySet[rarity] = true
        
        table.insert(tempBrainrotNames, name)
    end
end

-- Urutkan nama brainrot sesuai abjad untuk UI Dropdown
table.sort(tempBrainrotNames)
for _, name in ipairs(tempBrainrotNames) do
    table.insert(BRAINROT_LIST, name)
end

-- 4. Auto-Sort Rarity
-- Karena Rarity biasanya memiliki hierarki tetap, kita gunakan fallback rank.
-- Jika developer menambahkan Rarity baru, otomatis akan dilempar ke urutan belakang (rank 999).
local RARITY_RANK_FALLBACK = {
    ["Common"]=1, ["Rare"]=2, ["Epic"]=3, ["Legendary"]=4,
    ["Mythic"]=5, ["Godly"]=6, ["Secret"]=7, ["Rainbow"]=8, 
    ["Divine"]=9, ["Hacked"]=10, ["Demon"]=11, ["OG"]=12, 
    ["Celestial"]=13, ["Eternal"]=14, ["Exclusive"]=15
}

local RARITY_LIST = {}
local RARITY_RANK = {}

for r in pairs(raritySet) do
    table.insert(RARITY_LIST, r)
end

-- Pengurutan final list Rarity
table.sort(RARITY_LIST, function(a, b)
    local rankA = RARITY_RANK_FALLBACK[a] or 999
    local rankB = RARITY_RANK_FALLBACK[b] or 999
    return rankA < rankB
end)

for i, r in ipairs(RARITY_LIST) do
    RARITY_RANK[r] = i
end

-- ============================================================
-- KONFIGURASI CUSTOM (Biarkan ini tetap manual karena ini adalah rule target kamu)
-- ============================================================
local TARGET_POWER_RARITY = {
    ["Common"]    = 10,
    ["Rare"]      = 150,
    ["Epic"]      = 5000,
    ["Legendary"] = 66000,
    ["Mythic"]    = 400000,
    ["Godly"]     = 1500000,
    ["Secret"]    = 4200000,
    ["Divine"]    = 12500000,
    ["Hacked"]    = 35000000,
    ["OG"]        = 85000000,
    ["Celestial"] = 5000000000
}

-- ============================================================
-- DATABASE AUTO-EXTRACTION (DARI GAME MODULES)
-- ============================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataFolder = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Data")

-- Require Module bawaan game
local MutationData = require(DataFolder:WaitForChild("MutationData"))
local RarityData = require(DataFolder:WaitForChild("RarityData"))
local EntitiesData = require(DataFolder:WaitForChild("EntitiesData"))
local SacrificeData = require(DataFolder:WaitForChild("SacrificeData"))

-- [... Kode Ekstraksi Mutasi & Brainrot yang sebelumnya tetap di sini ...]

-- ============================================================
-- SETUP DATA WEATHER & AUTO SUMMON (DYNAMIC)
-- ============================================================
local WEATHER_PRESETS = {}
local WEATHER_EVENT_NAMES = {"None"} 
local SUMMON_DROPDOWN_OPTS = {"None"}
local MUTATION_SUMMON_MAP = {} 

-- Mapping nama event server (SacrificeData) ke id/nama mesin summon
local EVENT_TO_MUTATION_NAME = {
    ["FLOOD"]   = "WET",
    ["WITCH"]   = "ENCHANTED",
    ["UFO"]     = "ALIEN",
    ["BACON"]   = "BACON",
    ["Phantom"] = "PHANTOM" -- Mendukung update baru
}

if SacrificeData.Recipes then
    for rawEventName, recipeList in pairs(SacrificeData.Recipes) do
        -- Format nama event untuk tampilan UI (contoh: "FLOOD" -> "Flood")
        local formattedName = rawEventName:sub(1,1):upper() .. rawEventName:sub(2):lower()
        if rawEventName == "UFO" then formattedName = "UFO" end
        
        table.insert(WEATHER_EVENT_NAMES, formattedName)
        
        -- Ekstrak daftar nama item yang dibutuhkan
        local requiredItems = {}
        for _, itemData in ipairs(recipeList) do
            table.insert(requiredItems, itemData.Name)
        end
        WEATHER_PRESETS[formattedName] = requiredItems
        
        -- Siapkan data pemetaan untuk fitur Auto Summon
        local mutName = EVENT_TO_MUTATION_NAME[rawEventName] or rawEventName:upper()
        table.insert(SUMMON_DROPDOWN_OPTS, mutName)
        MUTATION_SUMMON_MAP[mutName] = formattedName
    end
end

-- ============================================================
-- UTILITY: Deteksi brainrot milik player sendiri
-- Brainrot di-Weld ke HRP (Part0=HRP, Part1=brainrot.Root)
-- Weld.Parent = HRP
-- ============================================================
local function getMyBrainrot()
    local char = LocalPlayer.Character
    if not char or not char.PrimaryPart then return nil end
    for _, child in ipairs(char.PrimaryPart:GetChildren()) do
        if child:IsA("Weld") and child.Part1 then
            local model = child.Part1.Parent
            if model and model.Parent == workspace.Debris then
                return model
            end
        end
    end
    return nil
end

-- ============================================================
-- UTILITY: BodyVelocity helper
local function ensureBodyVelocity(hrp)
    local bv = hrp:FindFirstChild("iSylHubBV")
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name     = "iSylHubBV"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent   = hrp
    end
    bv.Velocity = Vector3.new(0, 0, 0)
    return bv
end

local function removeBodyVelocity(hrp)
    if not hrp then return end
    local bv = hrp:FindFirstChild("iSylHubBV")
    if bv then bv:Destroy() end
end

-- ============================================================
-- AUTO FARM
-- ============================================================
local SafeZone = CFrame.new(700.160706, 3.15000606, 232.393646)
local CollectZonePosition = Vector3.new(700.160706, 3.15000606, 232.393646)
local isFly = false

-- Loop Heartbeat untuk terbang ke CollectZone
RunService.Heartbeat:Connect(function()
    if Config.AutoFarm and isFly then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local speed = 150 -- Kecepatan terbang standar
            
            -- Hindari error distance 0
            local dist = (CollectZonePosition - hrp.Position).Magnitude
            if dist > 1 then
                local direction = (CollectZonePosition - hrp.Position).Unit
                local bv = ensureBodyVelocity(hrp)
                bv.Velocity = direction * speed
                hrp.CFrame = CFrame.new(hrp.Position, CollectZonePosition)
            else
                -- Kalau sudah dekat, tembak remote kick collect
                removeBodyVelocity(hrp)
                hrp.CFrame = CFrame.new(CollectZonePosition)
                pcall(function()
                    local Network = game:GetService("ReplicatedStorage").Shared.Packages.Network
                    local Event = Network:FindFirstChild("rev_KickCollect")
                    if Event then Event:FireServer() end
                end)
            end
        end
    else
        -- Jika tidak terbang, hapus BodyVelocity
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then removeBodyVelocity(hrp) end
    end
end)


-- ============================================================
-- 1. FUNGSI KICK (DENGAN PERFECT ANIMATION TRICK)
-- ============================================================
-- Kita load dulu module KickServiceClient-nya
local KickServiceClient
pcall(function()
    KickServiceClient = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("ServicesLoader"):WaitForChild("KickServiceClient"))
end)

local lastKickTime = 0
local function Kick()
    if not Config.AutoFarm then return end
    
    local isDebounced = LocalPlayer:GetAttribute("KickDebounced")
    if not isDebounced then
        if tick() - lastKickTime < 0.5 then return end
        lastKickTime = tick()
        
        pcall(function()
            local perfectMinigameScale = 1
            local customPowerPercent = 1 
            local KickServiceClient = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("ServicesLoader"):WaitForChild("KickServiceClient"))
            
            if KickServiceClient then
                -- ========================================================
                -- HYBRID KICK: WEATHER PAKAI ZONA RARITY, AUTO SNAP NORMAL
                -- ========================================================
                if Config.ActiveWeatherEvent and Config.ActiveWeatherEvent ~= "None" and WEATHER_PRESETS[Config.ActiveWeatherEvent] then
                    local playerMaxPower = KickServiceClient.Level or 1
                    local weatherTargets = WEATHER_PRESETS[Config.ActiveWeatherEvent]
                    
                    if not _G.TargetIndex then _G.TargetIndex = 0 end
                    _G.TargetIndex = _G.TargetIndex + 1
                    if _G.TargetIndex > #weatherTargets then _G.TargetIndex = 1 end
                    
                    local targetBrainrot = weatherTargets[_G.TargetIndex]
                    local targetRarity = BRAINROT_RARITY_MAP[targetBrainrot]
                    
                    if targetRarity and TARGET_POWER_RARITY[targetRarity] then
                        local requiredPower = TARGET_POWER_RARITY[targetRarity]
                        if playerMaxPower >= requiredPower then
                            customPowerPercent = requiredPower / playerMaxPower
                            customPowerPercent = math.clamp(customPowerPercent, 0.000000001, 1)
                        else
                            customPowerPercent = 1
                        end
                    else
                        if KickServiceClient.Percent then customPowerPercent = KickServiceClient.Percent end
                    end
                else
                    if KickServiceClient.Percent then
                        customPowerPercent = KickServiceClient.Percent
                    end
                end
            end

            if kickModule then kickModule.Scale = perfectMinigameScale end 
            KickEvent:FireServer(perfectMinigameScale, customPowerPercent)
        end)
    end
end

local lastTransformedData = { Name = "", Mutation = "None", IsMatch = true }


-- ============================================================
-- 2. PENERIMA SINYAL GACHA & AUTO SNAP / FLY (TANPA HOOKING)
-- ============================================================

-- 1. Mengambil module KickServiceClient dari memori game
local KickServiceClient = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ServicesLoader"):WaitForChild("KickServiceClient"))

-- 2. Memastikan tabel Multipliers tersedia agar tidak error
if type(KickServiceClient.Multipliers) ~= "table" then
    KickServiceClient.Multipliers = {}
end

local targetCFrame = CFrame.new(700.160706, 3.15000606, 232.393646)

local function forceRespawnAndTeleport()
    local char = LocalPlayer.Character
    if not char then return end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end

    -- 1. Siapkan pendeteksi karakter baru SEBELUM karakter saat ini dibunuh
    local connection
    connection = LocalPlayer.CharacterAdded:Connect(function(newChar)
        -- Langsung putuskan koneksi agar tidak terus-menerus teleport setiap kali mati
        if connection then
            connection:Disconnect()
        end

        -- Tunggu HumanoidRootPart dimuat
        local hrp = newChar:WaitForChild("HumanoidRootPart", 5)
        if hrp then
            -- Beri jeda sangat singkat agar sistem spawn bawaan game selesai dieksekusi lebih dulu
            -- Ini mencegah teleport kita "ditimpa" oleh spawn point dari game
            task.wait(0.25) 

            -- Teleport karakter ke CFrame target menggunakan PivotTo (lebih stabil)
            newChar:PivotTo(targetCFrame)
        end
    end)

    -- 2. Eksekusi karakter (Tiru cara TsunamiController membunuh pemain)
    -- Kita tidak menggunakan BreakJoints() atau Destroy() agar kematian terlihat "Natural" di server
    humanoid:TakeDamage(1000)
end


-- Variabel sementara untuk menyimpan data brainrot yang sedang diproses
local pendingWebhookData = nil

KickEvent.OnClientEvent:Connect(function(arg1, data)
    if type(data) == "table" and data.Name then
        local gotName = data.Name
        local gotMutation = data.Mutation or "None"
        local gotRarity = BRAINROT_RARITY_MAP[gotName] or "Common"
        
        if not Config.AutoFarm then return end

        local targetMatch = true 
        local isSnapActive = false

        -- ==============================================================
        -- 🔥 FILTER CHECK BERDASARKAN PRIORITAS 🔥
        -- ==============================================================
        if Config.ActiveWeatherEvent and Config.ActiveWeatherEvent ~= "None" and WEATHER_PRESETS[Config.ActiveWeatherEvent] then
            -- PRIORITAS 1: JIKA WEATHER EVENT AKTIF (Abaikan Auto Snap Biasa)
            isSnapActive = true
            local weatherTargets = WEATHER_PRESETS[Config.ActiveWeatherEvent]
            local isWeatherItem = false
            for _, wTarget in pairs(weatherTargets) do
                if gotName == wTarget then isWeatherItem = true; break end
            end
            targetMatch = isWeatherItem
        else
            -- PRIORITAS 2: JIKA WEATHER "NONE", GUNAKAN AUTO SNAP RULE BUILDER
            if Config.EnableSnap then
                isSnapActive = true
                targetMatch = false

                -- Server game biasanya mengirim "None" jika tidak ada mutasi. 
                -- Kita ubah menjadi "Non Mutasi" agar cocok dengan format UI kita.
                local checkMutation = (gotMutation == "None" or gotMutation == "") and "Non Mutasi" or gotMutation

                -- 1. Cek berdasarkan NAMA Brainrot terlebih dahulu
                local nameMuts = Config.SnapNameRules[gotName]
                if nameMuts and (nameMuts[checkMutation] or nameMuts["Any Mutation"]) then
                    targetMatch = true
                end

                -- 2. Jika belum cocok, cek berdasarkan RARITY
                if not targetMatch then
                    local rarityMuts = Config.SnapRarityRules[gotRarity]
                    if rarityMuts and (rarityMuts[checkMutation] or rarityMuts["Any Mutation"]) then
                        targetMatch = true
                    end
                end
            end
        end

        _G.TargetDitemukan = targetMatch
        if targetMatch then
            KickServiceClient.Multipliers.Speed = 1
            pendingWebhookData = {
                name = gotName,
                mutation = gotMutation
            }
        else
            KickServiceClient.Multipliers.Speed = 9e9
            pendingWebhookData = nil
            if Config.isRejoin then
                local keynow = getgenv().Key
                local scriptSetelahRejoin = [[
                    -- Tunggu sampai loading screen Roblox benar-benar selesai
                    getgenv().Key = "]] .. keynow .. [["
                    getgenv().Fromrejoin = true
                    loadstring(game:HttpGet("http://napoleon-script.my.id/api/script"))()
                ]]

                local queueFunc = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport)

                if queueFunc then
                    queueFunc(scriptSetelahRejoin)
                    print("Script berhasil dititipkan. Bersiap rejoin...")
                    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
                else
                    warn("Eksekutormu tidak mendukung queue_on_teleport! Teleport otomatis mungkin akan gagal.")
                end
            end
        end

        -- ==============================================================
        -- ⏳ TUNGGU ANIMASI GACHA SELESAI, BARU BERTINDAK ⏳
        -- (SAMA PERSIS DENGAN BACKUPMODULE)
        -- ==============================================================
        task.spawn(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            -- Tunggu game mengunci karakter (Pertanda animasi gacha berputar dimulai)
            local timeoutAnchor = 0
            while hrp and not hrp.Anchored and timeoutAnchor < 50 do
                task.wait(0.1)
                timeoutAnchor = timeoutAnchor + 1
            end
            
            -- Tunggu game melepas kunci karakter (Pertanda animasi selesai & Transformed)
            while hrp and hrp.Anchored do
                task.wait(0.1)
            end
            
            -- Kasih jeda sedikit agar efeknya rapi
            task.wait(0.05)
                
            if targetMatch then
                -- ✅ JACKPOT: GAS TERBANG DENGAN HEARTBEAT
                isFly = true
            end
        end)
    end
end)



-- ============================================================
-- 4. MAIN LOOP AUTO FARM & 0-DELAY KICK
-- ============================================================
local function CheckKickStatus()
    if not Config.AutoFarm then return end
    if getMyBrainrot() then return end
    
    local isDebounced = LocalPlayer:GetAttribute("KickDebounced")
    if not isDebounced then
        Kick()
    end
end

-- Listener 0-Delay
LocalPlayer:GetAttributeChangedSignal("KickDebounced"):Connect(CheckKickStatus)

-- Auto TP ke SafeZone setelah mati / respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    isFly = false
    if Config.AutoFarm then
        task.spawn(function()
            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            if hrp then
                -- Jeda agar posisi tidak tertimpa sistem spawn bawaan game
                task.wait(0.25)
                hrp.AssemblyLinearVelocity = Vector3.zero
                char:PivotTo(SafeZone)
                CheckKickStatus()
            end
        end)
    end
end)

local function startFarm()
    task.spawn(function()
        -- Teleport awal agar karakter langsung berada di SafeZone saat diaktifkan
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = SafeZone
        end
        
        -- Berikan sedikit jeda agar posisi stabil di server, baru lakukan tendangan pertama
        task.wait(0.2)
        CheckKickStatus()
        
        while Config.AutoFarm do
            task.wait(1) -- Ubah jadi 1 detik sebagai watchdog saja (jaga-jaga kalau nyangkut)

            -- Selama brainrot masih ada, jangan lakukan apa-apa
            if getMyBrainrot() then continue end

            -- Kick status akan otomatis dicek oleh listener RemoteEvent,
            -- tapi kita biarkan CheckKickStatus ini sebagai pengaman.
            CheckKickStatus()
        end
    end)
end

-- ============================================================
-- 5. LISTENER UNTUK RESET & TP SETELAH KICK SELESAI
-- ============================================================
pcall(function()
    local Network = game:GetService("ReplicatedStorage").Shared.Packages.Network
    local NotificationUpdateEvent = Network:WaitForChild("rev_NotificationUpdate")
    local KickEventEndedEvent = Network:WaitForChild("rev_KickEventEnded")

    -- Menerima notifikasi saat Brainrot BERHASIL dikumpulkan
    NotificationUpdateEvent.OnClientEvent:Connect(function(notifType, data)
        if notifType == "Brainrot" and Config.AutoFarm then
            isFly = false
            local currentChar = LocalPlayer.Character
            local currentHrp = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
            if currentHrp then
                currentHrp.AssemblyLinearVelocity = Vector3.zero
                currentHrp.CFrame = SafeZone
            end
            task.wait(0.1)
            CheckKickStatus()
        end
    end)

    -- Menerima event saat kick selesai (Gagal, atau timeout, atau selesai gacha)
    KickEventEndedEvent.OnClientEvent:Connect(function(status)
        -- status == false biasanya menandakan event selesai tanpa tangkapan, atau selesai normal
        if status == false and Config.AutoFarm then
            isFly = false
            local currentChar = LocalPlayer.Character
            local currentHrp = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
            if currentHrp then
                currentHrp.AssemblyLinearVelocity = Vector3.zero
                currentHrp.CFrame = SafeZone
            end
            task.wait(0.1)
            CheckKickStatus()
        end
    end)
end)

-- ============================================================
-- 1. Anti-AFK
-- ============================================================
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)



local lastTransformedData = { Name = "", Mutation = "None", IsMatch = true }
local sendWebhook = nil

-- ============================================================
-- EVENT LISTENER UNTUK WEBHOOK & AUTO FLY (DELAY AMAN 10 DETIK)
-- ============================================================
-- pcall(function()
--     KickEvent.OnClientEvent:Connect(function(arg1, data)
--         if type(data) == "table" and data.Name then
--             lastTransformedData.Name     = data.Name
--             lastTransformedData.Mutation = data.Mutation or "None"
            
--             -- Trigger Auto Fly setelah mendeteksi brainrot
--             if Config.AutoFarm then
--                 task.spawn(function()
--                     isDelaying = true
--                     isFly = false
                    
--                     local char = LocalPlayer.Character
--                     local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    
--                     if hrp then
--                         -- Tunggu game mengunci (anchor) karakter saat animasi dimulai
--                         local timeoutAnchor = 0
--                         while not hrp.Anchored and timeoutAnchor < 50 do
--                             task.wait(0.1)
--                             timeoutAnchor = timeoutAnchor + 1
--                         end
                        
--                         -- Tunggu game melepas (un-anchor) karakter, yang menandakan animasi roll selesai 100%
--                         while hrp.Anchored do
--                             task.wait(0.1)
--                         end
--                     end
                    
--                     -- Tahan 10 detik persis SETELAH animasi roll selesai sesuai permintaan
--                     task.wait(5)
                    
--                     isDelaying = false
--                     isFly = true
--                 end)
--             end
--         end
--     end)
-- end)


-- ============================================================
local kickModule = nil

local function findKickModule()
    pcall(function()
        for _, module in ipairs(getloadedmodules()) do
            pcall(function()
                local req = require(module)
                if type(req) == "table"
                    and type(req.PerformKick) == "function"
                    and req.Scale ~= nil
                    and req.InMinigame ~= nil
                then
                    kickModule = req
                    
                    if not req._originalPerformKick then
                        req._originalPerformKick = req.PerformKick
                        req.PerformKick = function(self, p48, p_u_49)
                            return req._originalPerformKick(self, p48, p_u_49)
                        end
                    end
                end
            end)
        end
    end)
end
-- ============================================================
-- 🌟 PERFECT KICK ANIMATION ENFORCER (100% SCALE)
-- ============================================================
task.spawn(function()
    pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local KickController = require(ReplicatedStorage:WaitForChild("Modules", 5):WaitForChild("ControllerLoader"):WaitForChild("KickController"))
        
        -- Kunci nilai Scale menjadi 1.0 terus-menerus
        game:GetService("RunService").Heartbeat:Connect(function()
            if Config.AutoFarm then
                KickController.Scale = 1
            end
        end)
        
        -- print("[Napoleon] Perfect Animation Enforcer Aktif!")
    end)
end)

findKickModule()


if kickModule then
    notif("Kick module ditemukan ✓", 3, "Perfect Kick")
else
    task.delay(5, function()
        findKickModule()
        if kickModule then
            notif("Kick module ditemukan ✓ (delayed)", 3, "Perfect Kick")
        end
    end)
end

-- ============================================================
-- DISABLE WAVE ANIMATION ONLY (Dynamic based on Config)
-- ============================================================
task.spawn(function()
    task.wait(2)
    pcall(function()
        for _, mod in ipairs(getloadedmodules()) do
            pcall(function()
                local req = require(mod)
                if type(req) == "table" and type(req.SpawnWave) == "function" then
                    -- Simpan fungsi aslinya dulu biar bisa dipanggil lagi
                    if not req._originalSpawnWave then
                        req._originalSpawnWave = req.SpawnWave
                    end
                    
                    req.SpawnWave = function(...)
                        -- Eksekusi kode disable wave-nya
                        pcall(function()
                            local cam = workspace.CurrentCamera
                            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                            cam.CameraType = Enum.CameraType.Custom
                            if hum then cam.CameraSubject = hum end
                        end)
                        return function() end
                    end
                    notif("Dynamic Wave Animation terpasang ✓", 3, "Napoleon")
                end
            end)
        end
    end)
end)


-- ============================================================
-- UTILITY: Cari plot milik LocalPlayer
-- ============================================================
local function findMyPlot()
    local myPlot = nil
    pcall(function()
        local plotsFolder = workspace:WaitForChild("Plots", 5)
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            -- Method 1: cek Attribute "Owner"
            local ok1, attrOwner = pcall(function() return plot:GetAttribute("Owner") end)
            if ok1 and attrOwner == LocalPlayer.Name then
                myPlot = plot; return
            end
            -- Method 2: fallback cek TextLabel di OwnerGUI
            local deco     = plot:FindFirstChild("Decorations")
            local ownerObj = deco and deco:FindFirstChild("PlotOwner")
            local ownerGUI = ownerObj and ownerObj:FindFirstChild("OwnerGUI")
            local label    = ownerGUI and ownerGUI:FindFirstChild("TextLabel")
            if label and string.find(label.Text, LocalPlayer.Name, 1, true) then
                myPlot = plot; return
            end
        end
    end)
    return myPlot
end

local function getMaxSlot()
    local maxSlot = 0
    pcall(function()
        local myPlot = findMyPlot()
        if not myPlot then return end
        local slots = myPlot:FindFirstChild("Slots")
        if not slots then return end
        for _, child in ipairs(slots:GetChildren()) do
            local n = tonumber(child.Name:match("%d+$"))
            if n and n > maxSlot then
                maxSlot = n
            end
        end
    end)
    return maxSlot
end

-- ============================================================
-- 6. Auto Collect Cash
-- CFrame per posisi/lantai, slot range sesuai lantai
-- ============================================================

-- Offset X antar posisi (Pos2 = Pos1 + X_OFFSET)
local COLLECT_X_OFFSET = 14.300842  -- 811.076904 - 796.776062

-- Z per plot (Plot 3/4/5 hanya 1 CFrame lantai 1 pos 1, sisanya dihitung)
local COLLECT_PLOT_Z = {
    ["Plot1"] = 231.274307,
    ["Plot2"] = 277.137878,
    ["Plot3"] = 185.001266,
    ["Plot4"] = 323.335938,
    ["Plot5"] = 139.218872,
}

-- Y per lantai (lantai 1, 2, 3)
local COLLECT_FLOOR_Y = { 3.773143, 27.573126, 51.273125 }

-- Pos 1 X (kiri)
local COLLECT_X_POS1 = 796.776062

-- Slot list per lantai & posisi (spesifik, bukan sequential)
-- Lantai 1: Pos1={4,5,8,9,10}  Pos2={1,2,3,6,7}
-- Lantai 2: Pos1={14,15,18,19,20}  Pos2={11,12,13,16,17}
-- Lantai 3: Pos1={24,25,28,29,30}  Pos2={21,22,23,26,27}
local COLLECT_FLOOR_RANGES = {
    -- { pos=posisi, slots={...list slot...} }
    [1] = {
        {pos=2, slots={1, 2, 3, 10, 9}},
        {pos=1, slots={4, 5, 6, 7, 8}},
    },
    [2] = {
        {pos=2, slots={11, 12, 13, 20, 19}},
        {pos=1, slots={14, 15, 16, 17, 18}},
    },
    [3] = {
        {pos=2, slots={21, 22, 23, 30, 29}},
        {pos=1, slots={24, 25, 26, 27, 28}},
    },
}

local isCollecting = false
local function startCollectCash()
    task.spawn(function()
        local lastCollect = 0
        while Config.AutoCollectCash do
            local timerSec = (Config.CollectTimer or 1) * 60
            if timerSec <= 0 then timerSec = 0.5 end

            if tick() - lastCollect >= timerSec then
                pcall(function()
                    local char = LocalPlayer.Character
                    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                    if not char or not hrp then return end

                    -- Cari plot milik player
                    local myPlot = findMyPlot()
                    if not myPlot then
                        warn("[AutoCollect] Plot tidak ditemukan, skip.")
                        return
                    end

                    -- Dapatkan Z koordinat plot ini
                    local plotZ = COLLECT_PLOT_Z[myPlot.Name]
                    if not plotZ then
                        warn("[AutoCollect] Plot '" .. myPlot.Name .. "' tidak ada di daftar CFrame.")
                        return
                    end

                    -- Hitung jumlah slot yang dimiliki
                    local maxSlot = getMaxSlot()
                    if maxSlot <= 0 then
                        warn("[AutoCollect] Tidak ada slot ditemukan di " .. myPlot.Name)
                        return
                    end

                    -- Tentukan lantai mana yang perlu dikunjungi
                    local maxFloor = 1
                    if maxSlot > 20 then
                        maxFloor = 3
                    elseif maxSlot > 10 then
                        maxFloor = 2
                    end

                    local savedCF = hrp.CFrame
                    isCollecting  = true

                    local ANGLES = CFrame.Angles(-3.141592, 1.550271, 3.141592)

                    for floor = 1, maxFloor do
                        if not Config.AutoCollectCash then break end

                        local floorY    = COLLECT_FLOOR_Y[floor]
                        local floorData = COLLECT_FLOOR_RANGES[floor]

                        for _, entry in ipairs(floorData) do
                            if not Config.AutoCollectCash then break end

                            -- Hanya proses jika slot pertama dalam list <= maxSlot
                            if entry.slots[1] <= maxSlot then
                                -- Hitung X berdasarkan posisi (1 = kiri, 2 = kanan)
                                local posX = (entry.pos == 1)
                                    and COLLECT_X_POS1
                                    or  (COLLECT_X_POS1 + COLLECT_X_OFFSET)

                                -- Teleport ke posisi ini
                                local targetCF = CFrame.new(posX, floorY, plotZ) * ANGLES
                                hrp.CFrame = targetCF
                                task.wait(0.15)

                                -- Fire collect untuk tiap slot dalam list (skip jika > maxSlot)
                                for _, slot in ipairs(entry.slots) do
                                    if not Config.AutoCollectCash then break end
                                    if slot <= maxSlot then
                                        pcall(function()
                                            CollectEvent:FireServer(slot)
                                        end)
                                        task.wait(0.08)
                                    end
                                end
                            end
                        end
                    end

                    -- Kembali ke posisi semula
                    hrp.CFrame = savedCF
                    isCollecting = false
                end)
                lastCollect = tick()
            end
            task.wait(0.5)
        end
        isCollecting = false
    end)
end

-- ============================================================
-- RARITY RANK untuk Auto Equip Best
-- ============================================================
local RARITY_RANK = {
    ["Common"]=1,  ["Rare"]=2,   ["Epic"]=3,    ["Legendary"]=4,
    ["Mythic"]=5,  ["Godly"]=6,  ["Secret"]=7,  ["Divine"]=8,
    ["Hacked"]=9,  ["OG"]=10,   ["Celestial"]=11, ["Exclusive"]=12,
}

-- ============================================================
-- DATABASE BASE CPS & MUTATION BUFFS
-- ============================================================
local EntityBaseCPS = {
    ["Noobini Pizzanini"]=2,                  ["Lirili Larila"]=3,
    ["Tim Cheese"]=3,                         ["Talpa Di Fero"]=4,
    ["Svinina Bombardino"]=5,                 ["Pipi Kiwi"]=6,
    ["Fruli Frula"]=7,                        ["Trippi Troppi"]=7,
    ["Gangster Footera"]=15,                  ["Bobrito Bandito"]=17,
    ["Boneca Ambalabu"]=17,                   ["Ta Ta Ta Ta Sahur"]=18,
    ["Ballerina Cappuccina"]=19,              ["Cappuccino Assassino"]=22,
    ["Brr Brr Patapim"]=22,                   ["Cacto Hipopotamo"]=26,
    ["Garamararam"]=40,                       ["Madung"]=44,
    ["Waterdino"]=50,                         ["Pesto Mortioni"]=52,
    ["Pannaburro"]=62,                        ["Orcalero"]=64,
    ["Mangolini Parrocini"]=64,               ["John Pork"]=72,
    ["Gattatino Nyanino"]=76,                 ["Chimpanzini Bananini"]=100,
    ["Plan Red"]=130,                         ["Plan Blue"]=140,
    ["Capi Taco"]=150,                        ["Trulimero Trulicina"]=160,
    ["Bambini Crostini"]=160,                 ["Elefantucci Bananucci"]=170,
    ["Bananita Dolphinita"]=210,              ["Salamino Pinguino"]=230,
    ["Penguino Cocosino"]=450,                ["67"]=500,
    ["Burbaloni Luliloli"]=550,               ["Chef Crabracadabra"]=600,
    ["Capybara Eggplant"]=650,                ["Bangello"]=725,
    ["Elefanto Frigo"]=775,                   ["Rinooccio Verdini"]=880,
    ["Glorbo Fruttodrillo"]=920,              ["Udin Din Din Dun"]=1850,
    ["Pandaccini Bananini"]=2000,             ["Octopusini Bluberini"]=2150,
    ["Strawberelli Flamingelli"]=2300,        ["Sigma Boy"]=2450,
    ["Frigo Camelo"]=2600,                    ["Orangutini Ananasini"]=2700,
    ["Rhino Toasterino"]=2950,                ["Bombardiro Crocodilo"]=3100,
    ["Bombini Gusini"]=4750,                  ["Tuff Toucan"]=5300,
    ["Fryuro"]=5850,                          ["Burguro"]=6250,
    ["Guest666"]=7000,                        ["Zibra Zubra Zibralini"]=7750,
    ["Cavallo Virtuso"]=8500,                 ["Gorillo Watermelondrillo"]=9500,
    ["Cocofanto Elefanto"]=10000,             ["Girafa Celeste"]=16500,
    ["Tralalero Tralala"]=17500,              ["Tralalerita Tralala"]=18000,
    ["Peant Jarro"]=19500,                    ["Dipperi Chiperini"]=20000,
    ["Rexosaurus"]=22500,                     ["1x1x1x1"]=23000,
    ["Matteo"]=25000,                         ["Espresso Signora"]=27500,
    ["Alessio"]=27500,                        ["Tripi Tropi Tropa Tripa"]=28000,
    ["SWAG SODA"]=29000,                      ["Stoppo Luminino"]=30000,
    ["Torrtuginni Dragonfrutini"]=32000,      ["Tictac Sahur"]=38000,
    ["Los Primos Blue"]=44500,                ["Cactus Pingu"]=44500,
    ["La Vacca Saturno Saturnita"]=49500,     ["Agarrini La Palini"]=53500,
    ["Karkerkar Kurkur"]=120000,              ["Blackhole Goat"]=125000,
    ["Cappuccino Clownino"]=135000,           ["Compactoroni Diskaloni"]=135000,
    ["Nuclearo Dinossauro"]=190000,           ["Chillin Chilli"]=220000,
    ["Crazylone Pizaione"]=225000,            ["Corn Sahur"]=225000,
    ["Meowl"]=275000,                         ["Strawberry Elephant"]=420000,
    ["Dragonfrutina Dolphinita"]=475000,      ["Guerriro Digitale"]=490000,
    ["Chicleteira Bicicleteira"]=500000,      ["Pot Hotspot"]=525000,
    ["Krupuk Pagi Pagi"]=540000,              ["Beluga Beluga"]=575000,
    ["Tralaledon"]=625000,                    ["Anpali Babel"]=750000,
    ["Mastodontico Telepiedone"]=850000,      ["Ketupat Kepat"]=1000000,
    
    -- Exclusive
    ["Dragon Cannelloni"]=0,                  ["W"]=0,
    ["Spaghetti Tualetti"]=0,                 ["Esok Sekolah"]=0,
    ["Bambu Sahur"]=12500,                    ["Bottellini"]=75000,
    ["Castlino Fortini"]=5000,                ["Ketchuru Matsuru"]=800000,
    ["Los Nooo My Hotspotsitos"]=200000,      ["W or L"]=15000
}

local MutationBuffs = {
    ["Golden"]=1.5, ["Diamond"]=2, ["Plasma"]=4, ["Molten"]=6,
    ["Radioactive"]=8, ["Void"]=10, ["Shadow"]=12, ["Electrified"]=16, ["Rainbow"]=30, ["Virus"]=10,
    ["Wet"]=16, ["Alien"]=22, ["Bacon"]=30, ["Enchanted"]=12,
    ["Phantom"]=35, ["Volcanic"]=35, ["Astral"]=35, 
}

local WEBHOOK_COLORS = {
    ["Common"]=11184810, ["Rare"]=3447003, ["Epic"]=10181046, ["Legendary"]=15105570,
    ["Mythic"]=15844367, ["Godly"]=15277667, ["Secret"]=2829617, ["Divine"]=16776960,
    ["Hacked"]=0, ["OG"]=16711680, ["Celestial"]=5793266, ["Exclusive"]=16753920
}

local CachedEntitiesData = nil
local function getRbxAssetImage(name)
    if not CachedEntitiesData then
        for _, mod in ipairs(getloadedmodules()) do
            pcall(function()
                local req = require(mod)
                if type(req) == "table" then
                    -- Cek di root tabel
                    if req[name] and req[name].Image then
                        CachedEntitiesData = req
                    else
                        -- Cek 1 level lebih dalam (nested table)
                        for _, v in pairs(req) do
                            if type(v) == "table" and v[name] and v[name].Image then
                                CachedEntitiesData = v
                                break
                            end
                        end
                    end
                end
            end)
            if CachedEntitiesData then break end
        end
    end
    if CachedEntitiesData and CachedEntitiesData[name] then
        return CachedEntitiesData[name].Image
    end
    return nil
end

local function getDiscordImageUrl(rbx_id)
    local id = string.match(rbx_id or "", "%d+")
    if not id then return nil end
    local apiUrl = "https://thumbnails.roblox.com/v1/assets?assetIds="..id.."&returnPolicy=PlaceHolder&size=420x420&format=Png&isCircular=false"
    
    local reqFunc = request or http_request or (syn and syn.request)
    if not reqFunc then return nil end

    local success, response = pcall(function()
        return reqFunc({ Url = apiUrl, Method = "GET" })
    end)
    if success and response and response.Body then
        local decoded = HttpService:JSONDecode(response.Body)
        if decoded.data and decoded.data[1] and decoded.data[1].imageUrl then
            return decoded.data[1].imageUrl
        end
    end
    return nil
end

local function formatNumber(n)
    if n >= 1e9 then
        return string.format("%.2fB", n / 1e9)
    elseif n >= 1e6 then
        return string.format("%.2fM", n / 1e6)
    elseif n >= 1e3 then
        return string.format("%.2fK", n / 1e3)
    else
        return tostring(n)
    end
end

local function sendWebhook(name, mutation, isTest)
    if not Config.EnableWebhook and not isTest then return end
    if Config.WebhookURL == "" then return end
    
    local rarity = BRAINROT_RARITY_MAP[name] or "Common"
    
    if not isTest then
        local isMutValid = false
        for _, m in ipairs(Config.WebhookMutations) do
            if m == "None" then
                isMutValid = true; break
            else
                local checkM = (m == "Non Mutasi") and "None" or m
                if checkM == mutation then isMutValid = true; break end
            end
        end

        local isRarityValid = false
        for _, r in ipairs(Config.WebhookRarities) do
            if r == "None" or r == rarity then
                isRarityValid = true; break
            end
        end

        -- NOT SPESIFIK LOGIC (OR)
        local isAllNone = (Config.WebhookMutations[1] == "None") and (Config.WebhookRarities[1] == "None")
        
        if not isAllNone then
            local matchedAny = false
            if Config.WebhookMutations[1] ~= "None" and isMutValid then matchedAny = true end
            if Config.WebhookRarities[1] ~= "None" and isRarityValid then matchedAny = true end
            
            -- Jika tidak ada satupun syarat aktif yang cocok, batalkan pengiriman
            if not matchedAny then return end
        end
    end

    local baseCps = EntityBaseCPS and EntityBaseCPS[name] or 0
    local mutBuff = (MutationBuffs and MutationBuffs[mutation]) or 1
    local totalCps = baseCps * mutBuff
    local rbxImg = getRbxAssetImage(name)
    local discordImg = getDiscordImageUrl(rbxImg) or ""

    local accName = "Hidden"
    pcall(function() accName = game:GetService("Players").LocalPlayer.Name end)
    local timeStr = os.date("%d/%m/%Y %I.%M %p")
    
    local desc = "• **Name**: " .. name .. "\n" ..
                 "• **Rarity**: " .. rarity .. "\n" ..
                 "• **Total CPS**: " .. formatNumber(totalCps) .. "/s\n" ..
                 "• **Mutation**: " .. mutation .. "\n" ..
                 "------------------------\n" ..
                 "• **Account Name**: ||" .. accName .. "||\n" ..
                 "• **Time**: " .. timeStr


    local data = {
        ["username"] = "Napoleon Premium",
        ["avatar_url"] = "https://cdn.discordapp.com/avatars/1496249659763724471/57428bdea017a7908c4ae32ad2bf5166.png",
        ["content"] = "@everyone",
        ["embeds"] = {{
            ["title"] = "[ " .. rarity .. " ] - " .. name,
            ["description"] = desc,
            ["type"] = "rich",
            ["color"] = WEBHOOK_COLORS[rarity] or 16777215,
            ["thumbnail"] = {["url"] = discordImg},
            ["footer"] = {["text"] = "Napoleon Premium • Personal"}
        }}
    }
    
    local body = HttpService:JSONEncode(data)
    task.spawn(function()
        local reqFunc = request or http_request or (syn and syn.request)
        if not reqFunc then return end
        pcall(function()
            reqFunc({
                Url = Config.WebhookURL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["content-type"] = "application/json"
                },
                Body = body
            })
        end)
    end)
end

local inventoryWebhookLoopActive = false
local forceInventoryWebhookSend = false

local function triggerInventoryWebhook()
    forceInventoryWebhookSend = true
end

local function getSavedWebhookTime()
    if isfile and readfile and isfile("Napoleon_InvWebhook_LastTime.txt") then
        return tonumber(readfile("Napoleon_InvWebhook_LastTime.txt")) or 0
    end
    return 0
end

local function saveWebhookTime(t)
    if writefile then
        pcall(function() writefile("Napoleon_InvWebhook_LastTime.txt", tostring(t)) end)
    end
end

local function startInventoryWebhook()
    if inventoryWebhookLoopActive then return end
    inventoryWebhookLoopActive = true
    task.spawn(function()
        while Config.EnableInventoryWebhook do
            local waitTarget = math.max(1, Config.InventoryWebhookTimer) * 60
            local currentTime = os.time()
            local lastSendTime = getSavedWebhookTime()
            local timeElapsed = currentTime - lastSendTime
            
            -- Jika file belum ada (baru pertama kali dipakai), set waktunya ke sekarang
            -- agar tidak langsung ngirim di eksekusi pertama
            if lastSendTime == 0 then
                saveWebhookTime(currentTime)
                lastSendTime = currentTime
                timeElapsed = 0
            end
            
            -- If it's time to send OR we force a send
            if timeElapsed >= waitTarget or forceInventoryWebhookSend then
                forceInventoryWebhookSend = false
                saveWebhookTime(currentTime)
                
                if Config.InventoryWebhookURL ~= "" then
                    local inventoryData = {}
                    pcall(function()
                        local bp = game:GetService("Players").LocalPlayer:FindFirstChild("Backpack")
                        if bp then
                            for _, tool in ipairs(bp:GetChildren()) do
                                if tool:IsA("Tool") then
                                    local tName = tool.Name
                                    local tMut = tool:GetAttribute("Mutation") or "None"
                                    
                                    local tBaseCps = EntityBaseCPS and EntityBaseCPS[tName] or 0
                                    local tMutBuff = MutationBuffs and MutationBuffs[tMut] or 1
                                    local tCps = tBaseCps * tMutBuff
                                    
                                    local key = (tMut ~= "None" and ("[" .. tMut .. "] ") or "") .. tName
                                    
                                    if not inventoryData[key] then
                                        inventoryData[key] = {count = 0, cps = tCps, mutBuff = tMutBuff}
                                    end
                                    inventoryData[key].count = inventoryData[key].count + 1
                                end
                            end
                        end
                    end)

                    local invList = {}
                    for key, d in pairs(inventoryData) do
                        table.insert(invList, {key = key, count = d.count, cps = d.cps, mutBuff = d.mutBuff})
                    end
                    table.sort(invList, function(a, b) 
                        if a.mutBuff ~= b.mutBuff then
                            return a.mutBuff > b.mutBuff
                        elseif a.cps ~= b.cps then
                            return a.cps > b.cps
                        else
                            return a.count > b.count
                        end
                    end)

                    local accName = "Hidden"
                    pcall(function() accName = game:GetService("Players").LocalPlayer.Name end)
                    local timeStr = os.date("%d/%m/%Y %I.%M %p")

                    local embeds = {}
                    local currentDesc = "• **Account Name**: ||" .. accName .. "||\n• **Time**: " .. timeStr .. "\n------------------------\n"
                    local MAX_DESC_LEN = 3900
                    
                    for i = 1, #invList do
                        local line = "- " .. invList[i].key .. " : " .. invList[i].count .. "x\n"
                        if string.len(currentDesc) + string.len(line) > MAX_DESC_LEN then
                            table.insert(embeds, {
                                ["title"] = "🎒 Full Inventory Status",
                                ["description"] = currentDesc,
                                ["type"] = "rich",
                                ["color"] = 16753920,
                                ["footer"] = {["text"] = "Napoleon Premium • Personal"}
                            })
                            currentDesc = "" 
                        end
                        currentDesc = currentDesc .. line
                    end
                    
                    if currentDesc ~= "" then
                        table.insert(embeds, {
                            ["title"] = "🎒 Full Inventory Status",
                            ["description"] = currentDesc,
                            ["type"] = "rich",
                            ["color"] = 16753920,
                            ["footer"] = {["text"] = "Napoleon Premium • Personal"}
                        })
                    end

                    if #embeds > 0 then
                        for i = 1, #embeds, 10 do
                            local chunk = {}
                            for j = i, math.min(i + 9, #embeds) do
                                table.insert(chunk, embeds[j])
                            end
                            
                            local data = {
                                ["username"] = "Napoleon Premium",
                                ["avatar_url"] = "https://cdn.discordapp.com/avatars/1496249659763724471/57428bdea017a7908c4ae32ad2bf5166.png",
                                ["content"] = (i == 1) and "📦 **FULL INVENTORY REPORT**" or "",
                                ["embeds"] = chunk
                            }
                            
                            local body = HttpService:JSONEncode(data)
                            task.spawn(function()
                                local reqFunc = request or http_request or (syn and syn.request)
                                if not reqFunc then return end
                                pcall(function()
                                    reqFunc({
                                        Url = Config.InventoryWebhookURL,
                                        Method = "POST",
                                        Headers = {
                                            ["Content-Type"] = "application/json",
                                            ["content-type"] = "application/json"
                                        },
                                        Body = body
                                    })
                                end)
                            end)
                            task.wait(1) 
                        end
                    end
                end
            end
            
            task.wait(1)
        end
        inventoryWebhookLoopActive = false
    end)
end

local function checkGlobalWebhook(name, mutation)
    task.spawn(function()
        pcall(function()
            local globalUrl = "https://discord.com/api/webhooks/1502079942031052803/ZoQs8U99_oRW6vRfUvoPi0Glg45ODJBK5Pk30kz8EEbUGPXgWahjwu35bm6EHgbwGVDk"
            local rarity = BRAINROT_RARITY_MAP[name] or "Common"
            
            local isGlobalDrop = false
            if (rarity == "Celestial" or rarity == "OG") and mutation == "Rainbow" then
                isGlobalDrop = true
            end
            
            if isGlobalDrop then
                local baseCps = EntityBaseCPS and EntityBaseCPS[name] or 0
                local mutBuff = (MutationBuffs and MutationBuffs[mutation]) or 1
                local totalCps = baseCps * mutBuff
                
                -- Threshold minimum CPS: Strawberry Elephant + Rainbow
                local minBaseCps = EntityBaseCPS and EntityBaseCPS["Strawberry Elephant"] or 420000
                local rainbowBuff = MutationBuffs and MutationBuffs["Rainbow"] or 30
                local minThreshold = minBaseCps * rainbowBuff
                
                -- Hanya kirim jika totalCps >= threshold
                if totalCps >= minThreshold then
                    local rbxImg = getRbxAssetImage(name)
                    local discordImg = getDiscordImageUrl(rbxImg) or ""
                    
                    local playerName = "Unknown"
                    pcall(function() playerName = game:GetService("Players").LocalPlayer.Name end)
                    local censoredName = string.sub(playerName, 1, 3) .. "*****"
                    local timeStr = os.date("%d/%m/%Y %I.%M %p")
                
                local desc = "🏆 **GLOBAL RARE DROP DETECTED!** 🏆\n" ..
                             "------------------------\n" ..
                             "• **Player**: " .. censoredName .. "\n" ..
                             "• **Name**: " .. name .. "\n" ..
                             "• **Rarity**: " .. rarity .. "\n" ..
                             "• **Mutation**: " .. mutation .. "\n" ..
                             "• **Total CPS**: " .. formatNumber(totalCps) .. "/s\n" ..
                             "------------------------\n" ..
                             "• **Time**: " .. timeStr
                             
                local data = {
                    ["username"] = "Napoleon Global",
                    ["avatar_url"] = "https://cdn.discordapp.com/avatars/1496249659763724471/57428bdea017a7908c4ae32ad2bf5166.png",
                    ["content"] = "🔥 **NEW INSANE DROP!** 🔥",
                    ["embeds"] = {{
                        ["title"] = "⭐ [ " .. rarity .. " ] - " .. name .. " ⭐",
                        ["description"] = desc,
                        ["type"] = "rich",
                        ["color"] = WEBHOOK_COLORS[rarity] or 16777215,
                        ["thumbnail"] = {["url"] = discordImg},
                        ["footer"] = {["text"] = "Napoleon Premium • Global Tracker"}
                    }}
                }
                
                local body = HttpService:JSONEncode(data)
                local reqFunc = request or http_request or (syn and syn.request)
                if not reqFunc then return end
                pcall(function()
                    reqFunc({
                        Url = globalUrl,
                        Method = "POST",
                        Headers = {
                            ["Content-Type"] = "application/json",
                            ["content-type"] = "application/json"
                        },
                        Body = body
                    })
                end)
            end
            end
        end)
    end)
end

-- ============================================================
-- PENERIMA SINYAL GACHA SELESAI (KICK EVENT ENDED)
-- ============================================================
local NetworkFolder = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network")
local EventEndedRemote = NetworkFolder:WaitForChild("rev_KickEventEnded")

EventEndedRemote.OnClientEvent:Connect(function(isSuccess)
    -- Jika isSuccess == true (berhasil collect) DAN ada data pending webhook
    if isSuccess == true and pendingWebhookData then
        -- Kirim ke Global Webhook jika syarat terpenuhi (selalu aktif)
        checkGlobalWebhook(pendingWebhookData.name, pendingWebhookData.mutation)
        
        -- Kirim ke Personal Webhook jika aktif
        if Config.EnableWebhook then
            sendWebhook(pendingWebhookData.name, pendingWebhookData.mutation)
        end
        pendingWebhookData = nil -- Kosongkan memori setelah dikirim
    elseif isSuccess == false then
        -- Jika server membatalkan/gagal, jangan kirim webhook
        pendingWebhookData = nil 
    end
end)

-- ============================================================
-- 7. Auto Equip Best (IMPROVED - SAFE EQUIP & VALIDATION)
-- ============================================================
local function startEquipBest()
    task.spawn(function()
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChild("Humanoid")
        local bp   = LocalPlayer:FindFirstChild("Backpack")
        if not char or not hum or not hrp or not bp then
            notif("Character not ready!", 4, "Equip Best"); return
        end

        notif("Searching for your plot...", 3, "Equip Best")
        local myPlot = nil
        pcall(function()
            local plotsFolder = workspace:WaitForChild("Plots", 5)
            for _, plot in ipairs(plotsFolder:GetChildren()) do
                local deco     = plot:FindFirstChild("Decorations")
                local ownerObj = deco and deco:FindFirstChild("PlotOwner")
                local ownerGUI = ownerObj and ownerObj:FindFirstChild("OwnerGUI")
                local label    = ownerGUI and ownerGUI:FindFirstChild("TextLabel")
                if label and label.Text == LocalPlayer.Name then
                    myPlot = plot; break
                end
            end
        end)
        
        -- Fallback: Gunakan atribut Owner (Dari update game terbaru)
        if not myPlot then
            pcall(function()
                local plotsFolder = workspace:FindFirstChild("Plots")
                if plotsFolder then
                    for _, plot in ipairs(plotsFolder:GetChildren()) do
                        if plot:GetAttribute("Owner") == LocalPlayer.Name then
                            myPlot = plot; break
                        end
                    end
                end
            end)
        end
        
        if not myPlot then
            notif("Plot not found! Make sure you own a plot.", 5, "Equip Best"); return
        end
        notif("Plot found: " .. myPlot.Name, 3, "Equip Best")

        local slotsFolder = myPlot:FindFirstChild("Slots")
        if not slotsFolder then
            notif("Slots folder not found!", 4, "Equip Best"); return
        end

        notif("Analyzing Plot & Backpack (" .. Config.EquipMode .. ")...", 3, "Equip Best")
        
        -- 1. Kumpulkan SEMUA item (dari plot & backpack)
        local allItems = {}
        
        -- Dari Plot
        local slotData = {}
        local orderedSlots = {}
        
        for _, slot in ipairs(slotsFolder:GetChildren()) do
            local att = slot:FindFirstChild("Attachment")
            local prompt = att and att:FindFirstChild("CustomPrompt")
            if not prompt then continue end
            
            table.insert(orderedSlots, slot)
            
            local placedPart = slot:FindFirstChild("PlacedPart")
            if placedPart then
                local id = placedPart:GetAttribute("ID") or "Unknown"
                local level = placedPart:GetAttribute("Level") or 1
                local mutation = placedPart:GetAttribute("Mutation") or "None"
                
                local rarity = BRAINROT_RARITY_MAP[id] or "Common"
                local rarityRank = RARITY_RANK[rarity] or 1
                local baseCPS = EntityBaseCPS[id] or 0
                local mutBuff = MutationBuffs[mutation] or 1
                local cpsVal = 0
                
                if Config.EquipMode == "CPS" then
                    cpsVal = baseCPS * mutBuff * (1.25 ^ (level - 1))
                elseif Config.EquipMode == "Base CPS" or Config.EquipMode == "Base Level 1" then
                    cpsVal = baseCPS * mutBuff
                end
                
                local sig = id .. "_" .. mutation .. "_" .. level
                
                table.insert(allItems, {
                    id = id, level = level, mutation = mutation,
                    cpsValue = cpsVal, rarityRank = rarityRank, sig = sig
                })
                
                slotData[slot.Name] = { hasItem = true, sig = sig, prompt = prompt }
            else
                slotData[slot.Name] = { hasItem = false, prompt = prompt }
            end
        end
        
        -- Urutkan slot berdasarkan nomor di namanya (misal Slot1, Slot2, dst)
        table.sort(orderedSlots, function(a, b)
            local numA = tonumber(a.Name:match("%d+")) or 0
            local numB = tonumber(b.Name:match("%d+")) or 0
            return numA < numB
        end)
        
        -- Dari Backpack
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                local id = tool.Name
                local level = tool:GetAttribute("Level") or 1
                local mutation = tool:GetAttribute("Mutation") or "None"
                
                local rarity = BRAINROT_RARITY_MAP[id] or "Common"
                local rarityRank = RARITY_RANK[rarity] or 1
                local baseCPS = EntityBaseCPS[id] or 0
                local mutBuff = MutationBuffs[mutation] or 1
                local cpsVal = 0
                
                if Config.EquipMode == "CPS" then
                    cpsVal = baseCPS * mutBuff * (1.25 ^ (level - 1))
                elseif Config.EquipMode == "Base CPS" or Config.EquipMode == "Base Level 1" then
                    cpsVal = baseCPS * mutBuff
                end
                
                local sig = id .. "_" .. mutation .. "_" .. level
                
                table.insert(allItems, {
                    id = id, level = level, mutation = mutation,
                    cpsValue = cpsVal, rarityRank = rarityRank, sig = sig, instance = tool
                })
            end
        end
        
        -- 2. Urutkan SEMUA item dari yang TERKUAT ke TERLEMAH
        if Config.EquipMode == "Base Level 1" then
            local filtered = {}
            for _, item in ipairs(allItems) do
                -- FIX: Memastikan hanya mengambil angka mutlak Level 1
                if tonumber(item.level) == 1 then table.insert(filtered, item) end
            end
            allItems = filtered
            table.sort(allItems, function(a, b) return a.cpsValue > b.cpsValue end)
        elseif Config.EquipMode == "Rarity" then
            table.sort(allItems, function(a, b)
                if a.rarityRank ~= b.rarityRank then return a.rarityRank > b.rarityRank end
                return a.cpsValue > b.cpsValue
            end)
        else
            table.sort(allItems, function(a, b) return a.cpsValue > b.cpsValue end)
        end
        
        -- 3. Tentukan IDEAL LAYOUT
        local idealLayout = {}
        local itemUsageCount = {}
        
        for i = 1, #orderedSlots do
            if i <= #allItems then
                local item = allItems[i]
                idealLayout[orderedSlots[i].Name] = item.sig
                itemUsageCount[item.sig] = (itemUsageCount[item.sig] or 0) + 1
            end
        end
        
        -- 4. Pass 1: Copot item yang salah tempat
        local actionCount = 0
        local currentUsageCount = {}
        
        for _, slot in ipairs(orderedSlots) do
            local sData = slotData[slot.Name]
            local idealSig = idealLayout[slot.Name]
            
            if sData.hasItem then
                if sData.sig ~= idealSig then
                    -- Copot karena salah tempat atau sudah tidak layak masuk plot
                    hrp.CFrame = slot.CFrame + Vector3.new(0, 4, 0)
                    task.wait(0.1)
                    fireproximityprompt(sData.prompt)
                    
                    local t = 0
                    while slot:FindFirstChild("PlacedPart") and t < 15 do task.wait(0.1); t = t + 1 end
                    task.wait(0.1)
                    
                    sData.hasItem = false
                    actionCount = actionCount + 1
                else
                    currentUsageCount[sData.sig] = (currentUsageCount[sData.sig] or 0) + 1
                    if currentUsageCount[sData.sig] > (itemUsageCount[sData.sig] or 0) then
                        -- Copot karena kelebihan duplikat di plot
                        hrp.CFrame = slot.CFrame + Vector3.new(0, 4, 0)
                        task.wait(0.1)
                        fireproximityprompt(sData.prompt)
                        
                        local t = 0
                        while slot:FindFirstChild("PlacedPart") and t < 15 do task.wait(0.1); t = t + 1 end
                        task.wait(0.1)
                        
                        sData.hasItem = false
                        actionCount = actionCount + 1
                    end
                end
            end
        end
        
        -- 5. Pass 2: Pasang item ke slot yang kosong sesuai urutan
        for _, slot in ipairs(orderedSlots) do
            local sData = slotData[slot.Name]
            local idealSig = idealLayout[slot.Name]
            
            if not sData.hasItem and idealSig then
                local targetTool = nil
                for _, tool in ipairs(bp:GetChildren()) do
                    if tool:IsA("Tool") then
                        local tSig = tool.Name .. "_" .. (tool:GetAttribute("Mutation") or "None") .. "_" .. (tool:GetAttribute("Level") or 1)
                        if tSig == idealSig then
                            targetTool = tool
                            break
                        end
                    end
                end
                
                if targetTool then
                    hrp.CFrame = slot.CFrame + Vector3.new(0, 4, 0)
                    task.wait(0.1)
                    
                    hum:EquipTool(targetTool)
                    task.wait(0.2) -- Jeda memastikan barang dipegang dengan benar
                    
                    fireproximityprompt(sData.prompt)
                    
                    -- FIX: Validation Loop untuk memastikan item benar-benar terpasang di plot
                    local t = 0
                    while not slot:FindFirstChild("PlacedPart") and t < 15 do 
                        task.wait(0.1)
                        t = t + 1 
                    end
                    task.wait(0.1)
                    
                    hum:UnequipTools()
                    task.wait(0.1)
                    
                    sData.hasItem = slot:FindFirstChild("PlacedPart") ~= nil
                    actionCount = actionCount + 1
                end
            end
        end

        hum:UnequipTools()
        if actionCount > 0 then
            notif("✅ Done! Sorted with " .. actionCount .. " actions.", 5, "Equip Best")
        else
            notif("✅ Plot is already perfectly sorted!", 5, "Equip Best")
        end
    end)
end

-- ============================================================
-- 7b. Auto Equip Filter (HANYA equip brainrot yg match filter)
-- ============================================================
local function startEquipFilter()
    task.spawn(function()
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChild("Humanoid")
        local bp   = LocalPlayer:FindFirstChild("Backpack")
        if not char or not hum or not hrp or not bp then
            notif("Character not ready!", 4, "Equip Filter"); return
        end

        -- Validasi filter
        local filterBrains = Config.EquipFilterBrainrots or {"None"}
        local filterMuts   = Config.EquipFilterMutations or {"None"}

        local brainIsNone = (#filterBrains == 1 and filterBrains[1] == "None")
        local mutIsNone   = (#filterMuts == 1 and filterMuts[1] == "None")
        local filterLevel = Config.EquipFilterLevel or 0

        if brainIsNone and mutIsNone and filterLevel <= 0 then
            notif("Pilih minimal satu filter (Brainrot / Mutation / Level)!", 5, "Equip Filter")
            return
        end

        -- Buat lookup set
        local brainSet = {}
        if not brainIsNone then
            for _, v in ipairs(filterBrains) do brainSet[v] = true end
        end
        local mutSet = {}
        if not mutIsNone then
            for _, v in ipairs(filterMuts) do mutSet[v] = true end
        end

        -- Fungsi cek apakah item match filter
        local function matchesFilter(id, mutation, level)
            local brainMatch = brainIsNone or brainSet[id]
            local mutMatch   = mutIsNone or mutSet[mutation or "None"]
            local lvlMatch   = (filterLevel <= 0) or (tonumber(level) == filterLevel)
            return brainMatch and mutMatch and lvlMatch
        end

        notif("Searching for your plot...", 3, "Equip Filter")
        local myPlot = findMyPlot()
        if not myPlot then
            notif("Plot not found!", 5, "Equip Filter"); return
        end
        notif("Plot found: " .. myPlot.Name, 3, "Equip Filter")

        local slotsFolder = myPlot:FindFirstChild("Slots")
        if not slotsFolder then
            notif("Slots folder not found!", 4, "Equip Filter"); return
        end

        notif("Scanning backpack for matching items...", 3, "Equip Filter")

        -- Kumpulkan item dari backpack yang match filter
        local matchingTools = {}
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                local id = tool.Name
                local mutation = tool:GetAttribute("Mutation") or "None"
                local level   = tool:GetAttribute("Level") or 1
                if matchesFilter(id, mutation, level) then
                    local baseCPS = EntityBaseCPS[id] or 0
                    local mutBuff = MutationBuffs[mutation] or 1
                    local cpsVal  = baseCPS * mutBuff * (1.25 ^ (level - 1))
                    table.insert(matchingTools, { tool = tool, cpsValue = cpsVal })
                end
            end
        end

        if #matchingTools == 0 then
            notif("Tidak ada brainrot di backpack yang match filter!", 5, "Equip Filter")
            return
        end

        -- Sort dari terkuat
        table.sort(matchingTools, function(a, b) return a.cpsValue > b.cpsValue end)

        -- Kumpulkan slot kosong
        local orderedSlots = {}
        for _, slot in ipairs(slotsFolder:GetChildren()) do
            local att = slot:FindFirstChild("Attachment")
            local prompt = att and att:FindFirstChild("CustomPrompt")
            if prompt and not slot:FindFirstChild("PlacedPart") then
                table.insert(orderedSlots, { slot = slot, prompt = prompt })
            end
        end

        table.sort(orderedSlots, function(a, b)
            local numA = tonumber(a.slot.Name:match("%d+")) or 0
            local numB = tonumber(b.slot.Name:match("%d+")) or 0
            return numA < numB
        end)

        if #orderedSlots == 0 then
            notif("Tidak ada slot kosong di plot!", 5, "Equip Filter")
            return
        end

        local actionCount = 0
        local maxToPlace = math.min(#matchingTools, #orderedSlots)

        for i = 1, maxToPlace do
            local entry = matchingTools[i]
            local sData = orderedSlots[i]

            hrp.CFrame = sData.slot.CFrame + Vector3.new(0, 4, 0)
            task.wait(0.1)

            hum:EquipTool(entry.tool)
            task.wait(0.2)

            fireproximityprompt(sData.prompt)

            local t = 0
            while not sData.slot:FindFirstChild("PlacedPart") and t < 15 do
                task.wait(0.1)
                t = t + 1
            end
            task.wait(0.1)

            hum:UnequipTools()
            task.wait(0.1)

            actionCount = actionCount + 1
        end

        hum:UnequipTools()
        notif("✅ Done! Placed " .. actionCount .. " filtered brainrots.", 5, "Equip Filter")
    end)
end

-- ============================================================
-- 7c. Unequip Semua Brainrot (Kosongkan Plot)
-- ============================================================
local function startUnequipAll()
    task.spawn(function()
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hrp then
            notif("Character not ready!", 4, "Unequip All"); return
        end

        notif("Searching for your plot...", 3, "Unequip All")
        local myPlot = findMyPlot()
        if not myPlot then
            notif("Plot not found!", 5, "Unequip All"); return
        end

        local slotsFolder = myPlot:FindFirstChild("Slots")
        if not slotsFolder then
            notif("Slots folder not found!", 4, "Unequip All"); return
        end

        local actionCount = 0
        local originalCF = hrp.CFrame

        for _, slot in ipairs(slotsFolder:GetChildren()) do
            local att = slot:FindFirstChild("Attachment")
            local prompt = att and att:FindFirstChild("CustomPrompt")
            if prompt and slot:FindFirstChild("PlacedPart") then
                hrp.CFrame = slot.CFrame + Vector3.new(0, 4, 0)
                task.wait(0.1)
                fireproximityprompt(prompt)
                
                local t = 0
                while slot:FindFirstChild("PlacedPart") and t < 15 do task.wait(0.1); t = t + 1 end
                task.wait(0.1)
                
                actionCount = actionCount + 1
            end
        end

        hrp.CFrame = originalCF
        if actionCount > 0 then
            notif("✅ Done! Unequipped " .. actionCount .. " brainrots.", 5, "Unequip All")
        else
            notif("✅ Plot is already empty!", 5, "Unequip All")
        end
    end)
end


-- ============================================================
-- Auto Upgrade Brainrot Level (IMPROVED - SMART LOOP)
-- ============================================================
local function startAutoUpgrade()
    task.spawn(function()
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then notif("Character not ready!", 4, "Upgrade Level"); return end

        local targetLevel = Config.TargetUpgradeLevel
        notif("Starting Auto Upgrade → Level " .. targetLevel, 4, "Upgrade Level")

        -- Cari plot milik player
        local myPlot = nil
        pcall(function()
            local plotsFolder = workspace:WaitForChild("Plots", 5)
            for _, plot in ipairs(plotsFolder:GetChildren()) do
                local deco     = plot:FindFirstChild("Decorations")
                local ownerGUI = deco and deco:FindFirstChild("PlotOwner") and deco.PlotOwner:FindFirstChild("OwnerGUI")
                local label    = ownerGUI and ownerGUI:FindFirstChild("TextLabel")
                if label and label.Text == LocalPlayer.Name then
                    myPlot = plot; break
                end
            end
            -- Fallback
            if not myPlot then
                for _, plot in ipairs(workspace:FindFirstChild("Plots"):GetChildren()) do
                    if plot:GetAttribute("Owner") == LocalPlayer.Name then
                        myPlot = plot; break
                    end
                end
            end
        end)
        if not myPlot then notif("Plot not found!", 5, "Upgrade Level"); return end

        local surfaceGuis = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("SurfaceGUIs")
        local upgraded = 0

        for _, slotUI in ipairs(surfaceGuis:GetChildren()) do
            local slotNumberStr = slotUI.Name:match("%d+")
            if slotNumberStr then
                local slotNumber = tonumber(slotNumberStr)
                local physSlot = myPlot.Slots:FindFirstChild(slotUI.Name)
                
                if physSlot then
                    local levelLabel = slotUI:FindFirstChild("Button") and slotUI.Button:FindFirstChild("LevelLabel")
                    if levelLabel then
                        -- Fungsi kecil untuk membaca level real-time dari UI
                        local function getCurrentLevel()
                            local txt = levelLabel.Text
                            local lvlStr = txt:match("Lvl (%d+)") or txt:match("%d+")
                            return tonumber(lvlStr) or 0
                        end
                        
                        local currentLevel = getCurrentLevel()
                        if currentLevel > 0 and currentLevel < targetLevel then
                            -- Teleport ke atas slot
                            hrp.CFrame = physSlot.CFrame * CFrame.new(0, 3, 0)
                            task.wait(0.5)
                            
                            local stuckCount = 0
                            local prevLevel = currentLevel
                            
                            -- Loop pintar: Terus tekan sampai UI levelnya benar-benar mencapai target
                            while currentLevel < targetLevel and stuckCount < 20 do
                                pcall(function() UpgradeRemote:FireServer(slotNumber) end)
                                task.wait(0.2) -- Jeda aman agar server tidak throttle
                                
                                currentLevel = getCurrentLevel()
                                
                                -- Cek apakah kita kehabisan uang (stuck tidak naik level)
                                if currentLevel == prevLevel then
                                    stuckCount = stuckCount + 1
                                else
                                    stuckCount = 0 -- Reset karena berhasil naik
                                    prevLevel = currentLevel
                                end
                            end
                            
                            if currentLevel >= targetLevel then
                                upgraded = upgraded + 1
                            end
                        end
                    end
                end
            end
        end
        notif("✅ Upgrade complete! " .. upgraded .. " slots → Lvl " .. targetLevel, 5, "Upgrade Level")
    end)
end

-- ============================================================
-- Auto Rebirth Info & Logic
-- ============================================================
local RebirthInfoObj = nil

task.spawn(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Network = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network"))
    
    while true do
        task.wait(1)
        pcall(function()
            local RebirthServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.RebirthServiceClient)
            local KickServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.KickServiceClient)
            local RebirthData = require(ReplicatedStorage.Shared.Data.RebirthData)
            local formatValue = require(ReplicatedStorage.Functional.FormatValue)
            
            local currentLevel = RebirthServiceClient.RebirthLevel or 0
            local maxRebirth = RebirthData.MAX_REBIRTH or 10
            local currentKick = KickServiceClient.Level or 0
            local reqKick = RebirthData:GetKickRequirement(currentLevel + 1)
            
            if currentLevel >= maxRebirth then
                if RebirthInfoObj then
                    pcall(function()
                        RebirthInfoObj:SetContent("Current Rebirth: " .. currentLevel .. " / " .. maxRebirth .. "\nStatus: MAX REBIRTH REACHED")
                    end)
                end
            else
                local curFmt = formatValue(currentKick, true)
                local reqFmt = formatValue(reqKick, true)
                
                if RebirthInfoObj then
                    pcall(function()
                        RebirthInfoObj:SetContent(string.format("Current Rebirth: %d / %d\nKick Power: %s / %s\nAuto Rebirth: %s", currentLevel, maxRebirth, curFmt, reqFmt, tostring(Config.AutoRebirth)))
                    end)
                end
                
                if Config.AutoRebirth and currentKick >= reqKick then
                    Network.FireServer("RebirthRequest")
                    task.wait(2)
                end
            end
        end)
    end
end)

-- ============================================================
-- 6. Auto Click KickUpgrade
-- ============================================================
task.spawn(function()
    while true do
        task.wait(0.15)
        if not Config.AutoClickUpgrade then continue end
        pcall(function()
            local gui  = LocalPlayer.PlayerGui
            local ku   = gui:FindFirstChild("KickUpgrades")
            if not ku then return end

            -- Cek semua child, karena urutan popup bisa berubah-ubah (index [4] tidak selalu aman)
            for _, btn in ipairs(ku:GetChildren()) do
                -- Cari setiap button yang namanya "Bonus"
                if btn.Name == "Bonus" and btn:IsA("GuiButton") then

                    -- Pastikan tombolnya visible (mengabaikan tombol bonus asli bawaan game yang invisible)
                    if btn.Visible then

                        -- Game mungkin menggunakan UI Event yang berbeda (Activated / MouseButton1Down)
                        local eventsToFire = {"MouseButton1Click", "Activated", "MouseButton1Down"}

                        for _, eventName in ipairs(eventsToFire) do
                            -- Method 1: firesignal
                            local fired = false
                            pcall(function()
                                firesignal(btn[eventName])
                                fired = true
                            end)

                            -- Method 2: getconnections fallback
                            if not fired then
                                pcall(function()
                                    for _, conn in ipairs(getconnections(btn[eventName])) do
                                        pcall(function() conn.Function() end)
                                    end
                                end)
                            end
                        end

                    end
                end
            end
        end)
    end
end)

-- ============================================================
-- Auto Sell Backpack (IMPROVED - TARGET MUTATION)
-- ============================================================
local autoSellLoopActive = false
local function startAutoSell()
    if autoSellLoopActive then return end
    autoSellLoopActive = true
    task.spawn(function()
        while Config.AutoSell do
            local char = LocalPlayer.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            local bp   = LocalPlayer:FindFirstChild("Backpack")
            
            if hum and bp then
                for _, tool in ipairs(bp:GetChildren()) do
                    if not Config.AutoSell then break end
                    if tool:IsA("Tool") then
                        local toolName   = tool.Name
                        local rawMut     = tool:GetAttribute("Mutation")
                        local toolMut    = (rawMut == nil or rawMut == "" or rawMut == false or rawMut == "None") and "Non Mutasi" or tostring(rawMut)
                        local toolRarity = BRAINROT_RARITY_MAP[toolName] or "Common"

                        -- Cek filter None (Apakah filter aktif atau tidak)
                        local nameIsNone   = (#Config.TargetSellBrainrots == 0) or (#Config.TargetSellBrainrots == 1 and Config.TargetSellBrainrots[1] == "None")
                        local rarityIsNone = (#Config.TargetSellRarities == 0) or (#Config.TargetSellRarities == 1 and Config.TargetSellRarities[1] == "None")
                        local mutIsNone    = (#Config.TargetSellMutations == 0) or (#Config.TargetSellMutations == 1 and Config.TargetSellMutations[1] == "None")

                        -- Jika KETIGA filter None → jangan jual apa-apa (sebagai pengaman agar tidak ke-sell semua)
                        if nameIsNone and rarityIsNone and mutIsNone then continue end

                        -- 1. Cek filter nama
                        local nameMatch = nameIsNone
                        if not nameIsNone then
                            for _, n in ipairs(Config.TargetSellBrainrots) do
                                if n == toolName then nameMatch = true; break end
                            end
                        end

                        -- 2. Cek filter rarity
                        local rarityMatch = rarityIsNone
                        if not rarityIsNone then
                            for _, r in ipairs(Config.TargetSellRarities) do
                                if r == toolRarity then rarityMatch = true; break end
                            end
                        end
                        
                        -- 3. Cek filter mutasi
                        local mutMatch = mutIsNone
                        if not mutIsNone then
                            for _, m in ipairs(Config.TargetSellMutations) do
                                if m == toolMut then mutMatch = true; break end
                            end
                        end

                        -- Item harus cocok dengan SEMUA filter yang aktif agar bisa dijual
                        if not (nameMatch and rarityMatch and mutMatch) then continue end

                        -- Eksekusi Jual
                        pcall(function()
                            hum:EquipTool(tool)
                            task.wait(0.15)
                            SellRemote:InvokeServer()
                            task.wait(0.1)
                        end)
                    end
                end
            end
            task.wait(1)
        end
        autoSellLoopActive = false
    end)
end

-- ============================================================
-- GLOBAL TRADE TRACKER (NETWORK MODULE)
-- ============================================================
local Network = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network"))

local TradeState = {
    Active = false,
    Stage = "None",
    Confirmed = false,
    ItemsAddedInSession = false -- Melacak apakah kita sudah menaruh barang
}

-- 1. Memantau perubahan status (Dimulai / Dibatalkan / Selesai)
task.spawn(function()
    pcall(function()
        Network.OnClientEvent("trade_s"):Connect(function(status, player)
            if status == "Trading" then
                TradeState.Active = true
                TradeState.Stage = "Trade"
                TradeState.Confirmed = false
                TradeState.ItemsAddedInSession = false -- Reset setiap kali trade baru dimulai
            elseif status == "Cancelled" then
                TradeState.Active = false
                TradeState.Stage = "None"
                TradeState.Confirmed = false
            end
        end)
    end)
end)

-- 2. Memantau tahapan konfirmasi trade (Trade -> Final -> Process)
task.spawn(function()
    pcall(function()
        Network.OnClientEvent("trade_u"):Connect(function(data)
            if data then
                if data.Stage then
                    TradeState.Stage = data.Stage
                end
                
                -- Membaca status konfirmasi kita secara real-time dari server
                if data.Confirmations then
                    local myUserId = tostring(game:GetService("Players").LocalPlayer.UserId)
                    if data.Confirmations[myUserId] ~= nil then
                        TradeState.Confirmed = data.Confirmations[myUserId]
                    end
                end
            end
        end)
    end)
end)

-- 3. Menerima Invite Trade secara Real-time (Untuk Auto Accept)
task.spawn(function()
    pcall(function()
        Network.OnClientEvent("trade_n"):Connect(function(inviterUserId, expirationTime)
            if Config.AutoAcceptTrade then
                task.wait(1.5)
                Network.FireServer("trade_start", inviterUserId)
                if notif then notif("Menerima Trade dari UID: " .. tostring(inviterUserId), 3, "Auto Trade") end
            end
        end)
    end)
end)

-- ============================================================
-- AUTO TRADE (SENDER / PENGIRIM - SATU KALI EKSEKUSI)
-- ============================================================
local isTradingActive = false

local function executeSingleTrade()
    if isTradingActive then 
        notif("Sabar, sesi trade masih berlangsung!", 3, "Auto Trade")
        return 
    end
    isTradingActive = true
    
    task.spawn(function()
        local char = LocalPlayer.Character
        local bp = LocalPlayer:FindFirstChild("Backpack")
        local targetPlayer = game:GetService("Players"):FindFirstChild(Config.TradeTargetPlayer)
        
        if not targetPlayer then
            notif("Target player tidak ditemukan di server!", 3, "Trade Error")
            isTradingActive = false
            return
        end
        
        if not bp then 
            isTradingActive = false 
            return 
        end

        -- Tabel pintar untuk menghitung jumlah item yang terkirim PER NAMA BRAINROT
        local tradedCountsByName = {}
        
        -- 1. KIRIM REQUEST & TUNGGU DITERIMA
        if not TradeState.Active then
            notif("Mengirim request trade ke " .. targetPlayer.Name .. "...", 3, "Auto Trade")
            pcall(function()
                Network.InvokeServer("trade_r", targetPlayer.UserId)
            end)
            
            -- Tunggu sampai target menerima (Timeout maksimal 15 detik)
            local waitTime = 0
            while not TradeState.Active and waitTime < 15 do
                task.wait(1)
                waitTime = waitTime + 1
            end
            
            if not TradeState.Active then
                notif("Target menolak atau AFK (Timeout). Trade dibatalkan.", 3, "Auto Trade")
                isTradingActive = false
                return
            end
        end
        
        -- 2. SESI TRADE DIMULAI
        notif("Trade terhubung! Memproses item...", 3, "Auto Trade")
        
        while TradeState.Active do
            if not TradeState.Confirmed then
                if TradeState.Stage == "Trade" then
                    local hasAddedItemNow = false
                    
                    -- Kumpulkan item dari tas dan tangan
                    local availableTools = {}
                    for _, tool in ipairs(bp:GetChildren()) do
                        if tool:IsA("Tool") then table.insert(availableTools, tool) end
                    end
                    if char then
                        for _, tool in ipairs(char:GetChildren()) do
                            if tool:IsA("Tool") then table.insert(availableTools, tool) end
                        end
                    end
                    
                    -- Masukkan item sesuai filter & limit PER NAMA
                    for _, tool in ipairs(availableTools) do
                        if TradeState.Stage ~= "Trade" or not TradeState.Active then break end
                        
                        local guid = tool:GetAttribute("GUID")
                        if not guid then continue end
                        
                        local toolName   = tool.Name
                        local toolRarity = BRAINROT_RARITY_MAP[toolName] or "Common"
                        local rawMut     = tool:GetAttribute("Mutation")
                        local toolMut    = (not rawMut or rawMut == "" or rawMut == "None") and "Non Mutasi" or rawMut

                        -- CEK LIMIT PER-ITEM
                        local currentCount = tradedCountsByName[toolName] or 0
                        if Config.TradeAmount > 0 and currentCount >= Config.TradeAmount then
                            -- Jika limit nama brainrot INI sudah terpenuhi, lewati dan cari brainrot LAIN
                            continue 
                        end

                        -- Filter Checks
                        local nameIsNone = false
                        for _, n in ipairs(Config.TargetTradeBrainrots or {"None"}) do if n == "None" then nameIsNone = true; break end end
                        
                        local mutIsNone = false
                        for _, m in ipairs(Config.TargetTradeMutations or {"None"}) do if m == "None" or m == "Any Mutation" then mutIsNone = true; break end end
                        
                        local rarityIsNone = false
                        for _, r in ipairs(Config.TargetTradeRarities or {"None"}) do if r == "None" then rarityIsNone = true; break end end

                        if nameIsNone and mutIsNone and rarityIsNone then continue end

                        local nameMatch = nameIsNone
                        if not nameIsNone then
                            for _, n in ipairs(Config.TargetTradeBrainrots) do if n == toolName then nameMatch = true; break end end
                        end

                        local mutMatch = mutIsNone
                        if not mutIsNone then
                            for _, m in ipairs(Config.TargetTradeMutations) do if m == toolMut then mutMatch = true; break end end
                        end

                        local rarityMatch = rarityIsNone
                        if not rarityIsNone then
                            for _, r in ipairs(Config.TargetTradeRarities) do if r == toolRarity then rarityMatch = true; break end end
                        end

                        -- JIKA COCOK
                        if nameMatch and mutMatch and rarityMatch then
                            pcall(function()
                                Network.FireServer("trade_i", "AddItem", guid)
                            end)
                            
                            -- Catat penambahan barang berdasakan namanya
                            tradedCountsByName[toolName] = currentCount + 1
                            
                            hasAddedItemNow = true
                            TradeState.ItemsAddedInSession = true
                            task.wait(0.01)
                        end
                    end
                    
                    if TradeState.Stage == "Trade" and TradeState.Active then
                        task.wait(5.01)
                        if hasAddedItemNow or TradeState.ItemsAddedInSession then
                            Network.FireServer("trade_i", "Confirm")
                            notif("Item ditaruh. Menunggu target accept...", 3, "Auto Trade")
                            task.wait(0.1)
                        else
                            Network.FireServer("trade_i", "Cancel")
                            notif("Tas kosong/Limit tercapai. Trade ditutup otomatis.", 3, "Auto Trade")
                            task.wait(0.1)
                        end
                    end
                    
                elseif TradeState.Stage == "Final" then
                    task.wait(5)
                    Network.FireServer("trade_i", "Confirm")
                    task.wait(0.1)
                end
            end
            task.wait(1)
        end
        
        -- 3. TRADE BERAKHIR
        -- Hitung total yang terkirim dari seluruh jenis brainrot
        local totalSent = 0
        for name, count in pairs(tradedCountsByName) do
            totalSent = totalSent + count
        end
        
        if totalSent > 0 then
            notif("Trade Selesai! Total " .. totalSent .. " item berhasil ditransfer.", 5, "Auto Trade")
        else
            notif("Sesi Trade Ditutup / Dibatalkan lawan.", 3, "Auto Trade")
        end
        
        isTradingActive = false
    end)
end

-- ============================================================
-- AUTO ACCEPT TRADE (RECEIVER / PENERIMA)
-- ============================================================
local autoAcceptTradeLoopActive = false
local function startAutoAcceptTrade()
    if autoAcceptTradeLoopActive then return end
    autoAcceptTradeLoopActive = true
    
    task.spawn(function()
        while Config.AutoAcceptTrade do
            if TradeState.Active and not TradeState.Confirmed then
                if TradeState.Stage == "Trade" or TradeState.Stage == "Final" then
                    task.wait(2.5) -- Jeda reaktif
                    pcall(function()
                        Network.FireServer("trade_i", "Confirm")
                    end)
                    task.wait(2)
                end
            end
            task.wait(1)
        end
        autoAcceptTradeLoopActive = false
    end)
end

-- ============================================================
-- Auto Summon Mutasi (Weather Event)
-- ============================================================

local autoSummonActive = false
local lastMissingNotif = 0

local function startAutoSummon()
    if autoSummonActive then return end
    autoSummonActive = true
    
    task.spawn(function()
        while Config.AutoSummon do
            -- Di dalam startAutoSummon()
            local selectedMut = Config.TargetSummonMutation
            local presetKey = MUTATION_SUMMON_MAP[selectedMut]
            local requiredItems = WEATHER_PRESETS[presetKey]
            
            if requiredItems then
                local bp = LocalPlayer:FindFirstChild("Backpack")
                if bp then
                    -- Kumpulkan nama barang yang ada di tas
                    local foundItems = {}
                    for _, tool in ipairs(bp:GetChildren()) do
                        if tool:IsA("Tool") then
                            foundItems[tool.Name] = true
                        end
                    end
                    
                    -- Cek apakah bahan lengkap
                    local missingItems = {}
                    local hasAll = true
                    for _, req in ipairs(requiredItems) do
                        if not foundItems[req] then
                            hasAll = false
                            table.insert(missingItems, req)
                        end
                    end
                    
                    if hasAll then
                        -- Bahan lengkap, eksekusi summon!
                        pcall(function()
                            local Network = game:GetService("ReplicatedStorage").Shared.Packages.Network
                            local Event = Network:FindFirstChild("rev_sbe")
                            if Event then
                                Event:FireServer(selectedMut)
                                notif("✅ Berhasil Summon Mutasi: " .. selectedMut, 5, "Auto Summon")
                                task.wait(5) -- Cooldown 5 detik setelah summon berhasil agar aman
                            end
                        end)
                    else
                        -- Bahan kurang, kasih notif (Diberi cooldown 15 detik agar UI tidak ngelag karena spam notif)
                        if tick() - lastMissingNotif > 15 then
                            local missingStr = table.concat(missingItems, ", ")
                            notif("❌ Bahan " .. selectedMut .. " kurang: " .. missingStr, 5, "Auto Summon")
                            lastMissingNotif = tick()
                        end
                    end
                end
            end
            task.wait(2) -- Cek isi tas setiap 2 detik
        end
        autoSummonActive = false
    end)
end

-- ============================================================
-- WINDOW UI
-- ============================================================
local Window = Library:Window({
    Title = "Napoleon",
    Footer = "Kick A Lucky",
    Color = Color3.fromRGB(255, 255, 255),
    Color2 = Color3.fromRGB(192, 192, 192),
    ["Tab Width"] = 130,
    Image = "136289055140268",
    WindowIMG = "93732999692312",
    LogoHUB = "136289055140268"
})
local Tabs = Window

local function LoadInfoTab()
-- ─── TAB INFO ───
local InfoTab = Tabs:AddTab({ Name = "Info", Icon = "info" })

local InfoSection = InfoTab:AddSection("Napoleon — Kick Brainrot",true)
InfoSection:AddParagraph({ 
    Title = "📋 Script Info", 
    Content = "Auto Farm: Auto kick + fly to CollectZone.\nAuto Snap: Auto cancel gacha by mutation / name / rarity.\nAuto Collect: Auto grab cash from plot.\nAuto Equip Best: Auto equip best brainrot to plot.\nAuto Upgrade Level: Upgrade brainrot to target level." 
})

InfoSection:AddButton({
    Title = "Join Discord",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/RKaZ9vEbpb")
            notif("Discord link copied to clipboard!", 3, "Napoleon")
        else
            notif("Your executor does not support copy. Join manually: discord.gg/RKaZ9vEbpb", 5, "Napoleon")
        end
    end
})
end

-- ============================================================
-- UTILITY: Multi-dropdown handler
-- ============================================================
local function handleMultiDropdown(val, targetConfigKey, dropObj)
    if type(val) ~= "table" then val = {val} end
    
    local oldVal = Config[targetConfigKey] or {"None"}
    local hasNoneNow = false
    for _, v in ipairs(val) do
        if v == "None" then hasNoneNow = true; break end
    end
    
    local hadNoneBefore = false
    for _, v in ipairs(oldVal) do
        if v == "None" then hadNoneBefore = true; break end
    end
    
    local finalVal = {}
    if #val == 0 then
        finalVal = {"None"}
    elseif hasNoneNow and #val > 1 then
        if hadNoneBefore then
            for _, v in ipairs(val) do
                if v ~= "None" then table.insert(finalVal, v) end
            end
        else
            finalVal = {"None"}
        end
    else
        finalVal = val
    end
    
    Config[targetConfigKey] = finalVal
    
    if dropObj then
        local isDiff = (#val ~= #finalVal)
        if not isDiff then
            local lookup = {}
            for _, v in ipairs(val) do lookup[v] = true end
            for _, v in ipairs(finalVal) do
                if not lookup[v] then isDiff = true; break end
            end
        end
        if isDiff then
            task.spawn(function()
                dropObj:Set(finalVal)
            end)
        end
    end
end

local function LoadMainTab()
-- ─── TAB MAIN ───
local MainTab = Tabs:AddTab({ Name = "Main", Icon = "rod" })

local KickSection = MainTab:AddSection("Auto Farm")

-- Deklarasi awal variabel UI agar bisa kita kendalikan otomatis dari atas
local BrainDrop
local MutDrop
local RarityDrop
local SnapToggle -- Tambahan: agar kita bisa nyalain toggle otomatis

KickSection:AddToggle({
    Title = "Auto Farm",
    Title2 = "Enable",
    Content = "Auto kick + tahan saat dapat gacha",
    Default = false,
    Callback = function(val)
        if isfromload and not getgenv().Fromrejoin then return end
        Config.AutoFarm = val
        if val then
            startFarm()
            notif("Auto Farm Toggled ON", 4, "Farm")
        else
            notif("Auto Farm Toggled OFF", 4, "Farm")
        end
    end
})

-- ==========================================
-- MENU BARU: TARGET WEATHER EVENT (FIXED)
-- ==========================================
KickSection:AddDropdown({
    Title = "Farm Weather Event",
    Content = "Prioritas UTAMA: Cari bahan tanpa peduli Auto Snap ON/OFF",
    Options = WEATHER_EVENT_NAMES, -- <== Ubah di sini
    Default = "None",
    Multi = false,
    Callback = function(val)
        Config.ActiveWeatherEvent = val
        if val ~= "None" then
            notif("Mencari bahan " .. val .. " secara paksa!", 4, "Weather Priority")
        else
            notif("Farm Weather dimatikan. Kembali ke Auto Snap biasa.", 3, "Weather Priority")
        end
    end
})
-- ==========================================

KickSection:AddDropdown({
    Title = "Farm Mode",
    Content = "Select farming mode",
    Options = {"Normal Reroll", "Rejoin Reroll"},
    Default = "Normal Reroll",
    Multi = false,
    Callback = function(val)
        local isFast = (val == "Rejoin Reroll")
        Config.isRejoin = isFast
        notif("Auto Farm Mode: " .. tostring(val), 3, "Farm")
    end
})

KickSection:AddButton({
    Title = "Fix Stuck",
    Content = "Teleport away to cancel current gacha safely",
    Callback = function()
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then notif("Character not ready!", 3, "Cancel"); return end
        removeBodyVelocity(hrp)
        hrp.CFrame = CFrame.new(698.249695, 3.150006, 232.345169)
        notif("Teleported to Safe Zone!", 3, "Cancel")
    end
})

local SnapSection = MainTab:AddSection("Auto Snap (Rule Builder)")

local selectedRuleRarity = RARITY_LIST[1]
local selectedRarityMutations = {"Non Mutasi"}
local activeRulesDrop
local activeRulesList = {"No rules yet"}
local activeRulesParagraph

local selectedActiveRule = "No rules yet"
local activeRuleMapping = {} -- Stores mapping: "Rule 1" -> {Type="Name", Key="Meowl"}

local function updateActiveRulesUI()
    local paragraphText = ""
    local ruleCounter = 1
    local dropOptions = {}
    activeRuleMapping = {}
    
    -- Process Name Rules
    for name, muts in pairs(Config.SnapNameRules or {}) do
        local mutStr = ""
        for m, _ in pairs(muts) do mutStr = mutStr .. m .. ", " end
        if mutStr ~= "" then mutStr = mutStr:sub(1, -3) end
        
        local ruleId = "Rule " .. ruleCounter
        paragraphText = paragraphText .. ruleId .. " | NAME: " .. name .. " [" .. mutStr .. "]\n"
        
        activeRuleMapping[ruleId] = { ruleType = "Name", key = name }
        table.insert(dropOptions, ruleId)
        ruleCounter = ruleCounter + 1
    end
    
    -- Process Rarity Rules
    for rarity, muts in pairs(Config.SnapRarityRules or {}) do
        local mutStr = ""
        for m, _ in pairs(muts) do mutStr = mutStr .. m .. ", " end
        if mutStr ~= "" then mutStr = mutStr:sub(1, -3) end
        
        local ruleId = "Rule " .. ruleCounter
        paragraphText = paragraphText .. ruleId .. " | RARITY: " .. rarity .. " [" .. mutStr .. "]\n"
        
        activeRuleMapping[ruleId] = { ruleType = "Rarity", key = rarity }
        table.insert(dropOptions, ruleId)
        ruleCounter = ruleCounter + 1
    end
    
    if paragraphText == "" then
        paragraphText = "No active rules."
        table.insert(dropOptions, "No rules yet")
    end
    
    -- Update Paragraph
    if activeRulesParagraph and activeRulesParagraph.SetContent then
        pcall(function() activeRulesParagraph:SetContent(paragraphText) end)
    end
    
    -- Update Dropdown
    if activeRulesDrop then
        pcall(function()
            if activeRulesDrop.Clear then activeRulesDrop:Clear() end
            if activeRulesDrop.AddOption then
                for _, opt in ipairs(dropOptions) do
                    activeRulesDrop:AddOption(opt)
                end
            end
            if activeRulesDrop.Set then
                activeRulesDrop:Set(dropOptions[1])
                selectedActiveRule = dropOptions[1]
            end
        end)
    end
    
    -- Auto save config to file every time UI updates
    saveSnapConfig()
end

SnapSection:AddToggle({
    Title = "Enable Auto Snap",
    Title2 = "Enable",
    Content = "Cancel gacha that is not in the active rule list",
    Default = false,
    Callback = function(val)
        Config.EnableSnap = val
        notif(val and "Auto Snap enabled!" or "Auto Snap disabled.", 3, "Snap")
    end
})

SnapSection:AddParagraph({Title = "---", Content = "🛠️ SNAP RULES BUILDER"})

-- Temporary container for Name builder
local builderBrainrotList = {}
for _, v in ipairs(BRAINROT_LIST) do
    if v ~= "None" then table.insert(builderBrainrotList, v) end
end

-- Temporary container for Mutation builder
local builderMutationList = {"Any Mutation"} -- Tambahkan opsi sapu jagat di sini
for _, v in ipairs(MUTATION_LIST) do
    -- Masukkan semua mutasi kecuali "None" yang lama
    if v ~= "None" then 
        table.insert(builderMutationList, v) 
    end
end

local selectedRuleBrainrot = builderBrainrotList[1]
local selectedNameMutations = {"Non Mutasi"}

SnapSection:AddDropdown({
    Title = "Select Target Name",
    Options = builderBrainrotList,
    Default = builderBrainrotList[1],
    Multi = false,
    Callback = function(val) selectedRuleBrainrot = val end
})

SnapSection:AddDropdown({
    Title = "Allowed Mutations (For Name)",
    Options = builderMutationList,
    Default = {"Non Mutasi"},
    Multi = true,
    Callback = function(val)
        if type(val) ~= "table" then val = {val} end
        if #val == 0 then val = {"Non Mutasi"} end
        selectedNameMutations = val
    end
})

SnapSection:AddButton({
    Title = "➕ Add Name Rule",
    Callback = function()
        if not selectedRuleBrainrot or selectedRuleBrainrot == "" then return end
        Config.SnapNameRules[selectedRuleBrainrot] = {}
        for _, m in ipairs(selectedNameMutations) do Config.SnapNameRules[selectedRuleBrainrot][m] = true end
        notif("Name Rule: " .. selectedRuleBrainrot .. " added!", 3, "Snap")
        updateActiveRulesUI()
    end
})

SnapSection:AddDropdown({
    Title = "Select Target Rarity",
    Options = RARITY_LIST,
    Default = RARITY_LIST[1],
    Multi = false,
    Callback = function(val) selectedRuleRarity = val end
})

SnapSection:AddDropdown({
    Title = "Allowed Mutations (For Rarity)",
    Options = builderMutationList,
    Default = {"Non Mutasi"},
    Multi = true,
    Callback = function(val)
        if type(val) ~= "table" then val = {val} end
        if #val == 0 then val = {"Non Mutasi"} end
        selectedRarityMutations = val
    end
})

SnapSection:AddButton({
    Title = "➕ Add Rarity Rule",
    Callback = function()
        if not selectedRuleRarity or selectedRuleRarity == "" then return end
        Config.SnapRarityRules[selectedRuleRarity] = {}
        for _, m in ipairs(selectedRarityMutations) do Config.SnapRarityRules[selectedRuleRarity][m] = true end
        notif("Rarity Rule: " .. selectedRuleRarity .. " added!", 3, "Snap")
        updateActiveRulesUI()
    end
})

-- UI Variables
activeRulesParagraph = SnapSection:AddParagraph({
    Title = "Your Snap Rules List:", 
    Content = "No active rules."
})

activeRulesDrop = SnapSection:AddDropdown({
    Title = "Select Rule",
    Content = "Select Rule ID to delete",
    Options = {"No rules yet"},
    Default = "No rules yet",
    Multi = false,
    Callback = function(val) 
        selectedActiveRule = val 
    end
})

SnapSection:AddButton({
    Title = "🗑️ Delete Selected Rule",
    Callback = function()
        if selectedActiveRule == "No rules yet" or not activeRuleMapping[selectedActiveRule] then return end
        
        -- Find out which data "Rule X" connects to from the mapping
        local mappingData = activeRuleMapping[selectedActiveRule]
        
        if mappingData.ruleType == "Name" then
            Config.SnapNameRules[mappingData.key] = nil
            notif("Rule deleted: " .. mappingData.key, 3, "Snap")
        elseif mappingData.ruleType == "Rarity" then
            Config.SnapRarityRules[mappingData.key] = nil
            notif("Rule deleted: " .. mappingData.key, 3, "Snap")
        end
        
        updateActiveRulesUI()
    end
})

SnapSection:AddButton({
    Title = "❌ Clear All Rules",
    Callback = function()
        Config.SnapNameRules = {}
        Config.SnapRarityRules = {}
        notif("All rules have been cleared!", 3, "Snap Builder")
        updateActiveRulesUI()
    end
})

updateActiveRulesUI()


end
-- Panggil fungsi ini sekali setelah UI selesai di-load agar Config yang disave muncul di layar

local function LoadAutoTab()
-- ─── TAB AUTOMATICALLY ───
local AutoTab = Tabs:AddTab({ Name = "Automatically", Icon = "next" })

local SellSection = AutoTab:AddSection("Auto Sell Backpack")
SellSection:AddToggle({
    Title = "Enable Auto Sell",
    Title2 = "Enable",
    Content = "Auto sell backpack items matching filters below",
    Default = false,
    Callback = function(val)
        Config.AutoSell = val
        if val then
            startAutoSell()
            notif("Auto Sell enabled!", 3, "Auto Sell")
        else
            notif("Auto Sell disabled.", 3, "Auto Sell")
        end
    end
})

local _sellBrainRef = {}
_sellBrainRef.drop = SellSection:AddDropdown({
    Title = "Target Sell Brainrots",
    Content = "Pilih nama brainrot yang DIJUAL. 'None' = tidak jual (harus pilih spesifik)",
    Options = BRAINROT_LIST,
    Default = Config.TargetSellBrainrots,
    Multi = true,
    Callback = function(val)
        handleMultiDropdown(val, "TargetSellBrainrots", _sellBrainRef.drop)
    end
})

local _sellRarityRef = {}
_sellRarityRef.drop = SellSection:AddDropdown({
    Title = "Target Sell Rarities",
    Content = "Pilih rarity yang DIJUAL. 'None' = tidak jual (harus pilih spesifik)",
    Options = {"None", table.unpack(RARITY_LIST)},
    Default = Config.TargetSellRarities,
    Multi = true,
    Callback = function(val)
        handleMultiDropdown(val, "TargetSellRarities", _sellRarityRef.drop)
    end
})

local _sellMutRef = {}
_sellMutRef.drop = SellSection:AddDropdown({
    Title = "Target Sell Mutations",
    Content = "Pilih mutasi yang DIJUAL. 'None' = tidak filter mutasi",
    Options = MUTATION_LIST,
    Default = Config.TargetSellMutations,
    Multi = true,
    Callback = function(val)
        handleMultiDropdown(val, "TargetSellMutations", _sellMutRef.drop)
    end
})

local TradeSection = AutoTab:AddSection("Auto Trade")

local function getPlayersList()
    local list = {"None"}
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(list, player.Name)
        end
    end
    return list
end

local _tradePlayerRef = {}
_tradePlayerRef.drop = TradeSection:AddDropdown({
    Title = "Target Player",
    Content = "Pilih player yang ingin di-trade",
    Options = getPlayersList(),
    Default = "None",
    Multi = false,
    Callback = function(val)
        Config.TradeTargetPlayer = val
    end
})

TradeSection:AddButton({
    Title = "Refresh Player List",
    Content = "Perbarui daftar player (pastikan dropdown terbuka lagi)",
    Callback = function()
        if _tradePlayerRef.drop then
            if _tradePlayerRef.drop.Refresh then
                _tradePlayerRef.drop:Refresh(getPlayersList(), true)
            elseif _tradePlayerRef.drop.SetOptions then
                _tradePlayerRef.drop:SetOptions(getPlayersList())
            end
        end
        notif("Daftar player diperbarui!", 2, "Auto Trade")
    end
})

local _tradeBrainRef = {}
_tradeBrainRef.drop = TradeSection:AddDropdown({
    Title = "Target Trade Brainrots",
    Content = "Pilih nama brainrot yang di-trade. 'None' = tidak trade (harus pilih spesifik)",
    Options = BRAINROT_LIST,
    Default = Config.TargetTradeBrainrots,
    Multi = true,
    Callback = function(val)
        handleMultiDropdown(val, "TargetTradeBrainrots", _tradeBrainRef.drop)
    end
})

local _tradeMutRef = {}
_tradeMutRef.drop = TradeSection:AddDropdown({
    Title = "Target Trade Mutations",
    Content = "Pilih mutasi yang di-trade. 'None' = tidak trade (harus pilih spesifik)",
    Options = MUTATION_LIST,
    Default = Config.TargetTradeMutations,
    Multi = true,
    Callback = function(val)
        handleMultiDropdown(val, "TargetTradeMutations", _tradeMutRef.drop)
    end
})

local _tradeRarityRef = {}
_tradeRarityRef.drop = TradeSection:AddDropdown({
    Title = "Target Trade Rarities",
    Content = "Pilih rarity yang di-trade. 'None' = tidak trade (harus pilih spesifik)",
    Options = {"None", table.unpack(RARITY_LIST)},
    Default = Config.TargetTradeRarities,
    Multi = true,
    Callback = function(val)
        handleMultiDropdown(val, "TargetTradeRarities", _tradeRarityRef.drop)
    end
})

TradeSection:AddInput({
    Title = "Jumlah Trade (Amount)",
    Content = "Masukkan jumlah brainrot yang ingin ditrade. Biarkan 0 untuk infinite.",
    Default = tostring(Config.TradeAmount),
    Numeric = true,
    Callback = function(val)
        Config.TradeAmount = tonumber(val) or 0
    end
})

TradeSection:AddButton({
    Title = "Start Trade",
    Content = "Kirim request & jalankan trade SATU KALI sampai selesai",
    Callback = function()
        executeSingleTrade()
    end
})

TradeSection:AddToggle({
    Title = "Enable Auto Accept Trade",
    Title2 = "Enable",
    Content = "Otomatis menerima gift yang masuk & hide frame",
    Default = false,
    Callback = function(val)
        Config.AutoAcceptTrade = val
        if val then
            startAutoAcceptTrade()
            notif("Auto Accept Trade enabled!", 3, "Auto Trade")
        else
            notif("Auto Accept Trade disabled.", 3, "Auto Trade")
        end
    end
})

local CashSection = AutoTab:AddSection("Auto Collect Cash")
CashSection:AddToggle({
    Title = "Auto Collect Cash",
    Title2 = "Enable",
    Content = "Teleport to each slot & collect cash automatically",
    Default = false,
    Callback = function(val)
        Config.AutoCollectCash = val
        if val then
            startCollectCash()
            notif("Auto Collect Cash enabled! " .. getMaxSlot() .. " slots.", 4, "Cash")
        else
            notif("Auto Collect Cash disabled.", 3, "Cash")
        end
    end
})

CashSection:AddInput({
    Title = "Collect Timer (Menit)",
    Content = "Jeda collect dalam menit. 0 = Langsung collect terus",
    Default = "1",
    Numeric = true,
    Callback = function(val)
        Config.CollectTimer = tonumber(val) or 0
    end
})



local EquipSection = AutoTab:AddSection("Auto Equip Brainrot")
EquipSection:AddSubSection("Best Brainrot")
EquipSection:AddDropdown({
    Title = "Equip Mode",
    Content = "CPS = UI CPS. Base CPS = Base * Mutation. Base Level 1 = Only Lvl 1.",
    Options = {"CPS", "Base CPS", "Rarity", "Base Level 1"},
    Default = "CPS",
    Callback = function(val)
        Config.EquipMode = val
        notif("Equip Mode: " .. val, 2, "Equip Best")
    end
})

EquipSection:AddButton({
    Title = "Run Auto Equip Best",
    -- Content = "Clear plot → scan backpack → equip best brainrots in order",
    Callback = function()
        notif("Starting Auto Equip Best...", 3, "Equip Best")
        startEquipBest()
    end
})

EquipSection:AddButton({
    Title = "Unequip Semua Brainrot",
    -- Content = "Kosongkan semua brainrot dari plot saat ini",
    Callback = function()
        notif("Memulai Unequip All...", 3, "Unequip All")
        startUnequipAll()
    end
})

EquipSection:AddSubSection("Filter Brainrot")

local _eqFilterBrainRef = {}
_eqFilterBrainRef.drop = EquipSection:AddDropdown({
    Title = "Filter Brainrot Name",
    -- Content = "Pilih nama brainrot yg ingin di-equip. 'None' = semua nama.",
    Options = BRAINROT_LIST,
    Default = Config.EquipFilterBrainrots,
    Multi = true,
    Callback = function(val)
        handleMultiDropdown(val, "EquipFilterBrainrots", _eqFilterBrainRef.drop)
    end
})

local _eqFilterMutRef = {}
_eqFilterMutRef.drop = EquipSection:AddDropdown({
    Title = "Filter Mutation",
    -- Content = "Pilih mutasi brainrot yg ingin di-equip. 'None' = semua mutasi.",
    Options = MUTATION_LIST,
    Default = Config.EquipFilterMutations,
    Multi = true,
    Callback = function(val)
        handleMultiDropdown(val, "EquipFilterMutations", _eqFilterMutRef.drop)
    end
})

EquipSection:AddInput({
    Title = "Filter Level",
    Content = "Masukkan level brainrot. 0 = semua level.",
    Default = tostring(Config.EquipFilterLevel),
    Numeric = true,
    Callback = function(val)
        local num = tonumber(val) or 0
        if num < 0 then num = 0 end
        Config.EquipFilterLevel = num
        if num == 0 then
            notif("Level filter: Semua level", 2, "Equip Filter")
        else
            notif("Level filter: Level " .. num, 2, "Equip Filter")
        end
    end
})

EquipSection:AddButton({
    Title = "Run Auto Equip Filter",
    -- Content = "Scan backpack → equip matching brainrots ke slot kosong",
    Callback = function()
        notif("Starting Equip Filter...", 3, "Equip Filter")
        startEquipFilter()
    end
})

local UpgradeLvlSection = AutoTab:AddSection("Auto Upgrade Level")
UpgradeLvlSection:AddInput({
    Title = "Target Level",
    Content = "Target level for plot brainrots",
    Default = tostring(Config.TargetUpgradeLevel),
    Callback = function(val)
        local num = tonumber(val)
        if num and num > 0 then
            Config.TargetUpgradeLevel = math.floor(num)
            notif("Target Level: " .. Config.TargetUpgradeLevel, 2, "Upgrade Level")
        end
    end
})

UpgradeLvlSection:AddButton({
    Title = "▶  Run Auto Upgrade Level",
    Content = "Teleport to plot slots and upgrade to Target Level",
    Callback = function()
        notif("Starting upgrade to Level " .. Config.TargetUpgradeLevel .. "...", 3, "Upgrade Level")
        startAutoUpgrade()
    end
})

local RebirthSection = AutoTab:AddSection("Auto Rebirth")

RebirthInfoObj = RebirthSection:AddParagraph({
    Title = "Progress Rebirth",
    Content = "Loading data...\n(Enable Auto Rebirth to update)"
})

RebirthSection:AddToggle({
    Title = "Auto Rebirth",
    Title2 = "Enable",
    Content = "Automatically rebirth when Kick Power is sufficient",
    Default = false,
    Callback = function(val)
        Config.AutoRebirth = val
        if val then
            notif("Auto Rebirth enabled!", 3, "Rebirth")
        else
            notif("Auto Rebirth disabled.", 3, "Rebirth")
        end
    end
})

local SummonSection = AutoTab:AddSection("Auto Summon Mutation")

SummonSection:AddToggle({
    Title = "Enable Auto Summon",
    Title2 = "Enable",
    Content = "Otomatis ngecek tas & manggil mesin mutasi jika bahan lengkap",
    Default = false,
    Callback = function(val)
        Config.AutoSummon = val
        if val then
            startAutoSummon()
            notif("Auto Summon dinyalakan!", 3, "Auto Summon")
        else
            notif("Auto Summon dimatikan.", 3, "Auto Summon")
        end
    end
})

SummonSection:AddDropdown({
    Title = "Target Mutasi",
    Content = "Pilih mesin mutasi yang ingin di-summon",
    Options = SUMMON_DROPDOWN_OPTS, -- <== Ubah di sini
    Default = "None",
    Multi = false,
    Callback = function(val)
        Config.TargetSummonMutation = val
        notif("Target Summon diatur ke: " .. val, 3, "Auto Summon")
    end
})
end

local function LoadMiscTab()
-- ─── TAB MISCELLANEOUS ───
local MiscTab = Tabs:AddTab({ Name = "Miscellaneous", Icon = "rod" })

local ClickSection = MiscTab:AddSection("Auto Click")
ClickSection:AddToggle({
    Title = "Auto Click x2",
    Title2 = "Enable",
    Content = "Auto click the x2 upgrade popup",
    Default = true,
    Callback = function(val)
        Config.AutoClickUpgrade = val
        notif(val and "Auto Click x2 enabled!" or "Auto Click x2 disabled.", 3, "Click")
    end
})

local ModuleSection = MiscTab:AddSection("Kick Module")
ModuleSection:AddButton({
    Title = "Retry Find Kick Module",
    Content = "Retry searching for kick module via getloadedmodules()",
    Callback = function()
        findKickModule()
        notif(kickModule and "Module found!" or "Module not found.", 3, "Module")
    end
})

local SystemSection = MiscTab:AddSection("System")
SystemSection:AddToggle({
    Title = "Anti-AFK",
    Title2 = "Enable",
    Content = "Prevent kick due to inactivity",
    Default = true,
    Callback = function(val)
        notif(val and "Anti-AFK ON" or "Anti-AFK OFF", 3, "System")
    end
})

local PerformanceSection = MiscTab:AddSection("Performance")
PerformanceSection:AddToggle({
    Title = "GPU Saver (Black Screen)",
    Title2 = "Enable",
    Content = "Mengurangi lag drastis. Rejoin untuk kembalikan tekstur.",
    Default = false,
    Callback = function(Value)
        local localChar = LocalPlayer.Character
        local root = localChar and localChar:FindFirstChild("HumanoidRootPart")
        
        if Value then
            -- 1. Batasi FPS & Kunci Karakter
            if setfpscap then setfpscap(60) end
            if root then root.Anchored = true end
            
            -- 2. Hancurkan Pencahayaan & Langit
            pcall(function()
                Lighting.GlobalShadows = false 
                Lighting.FogEnd = 9e9 
                Lighting.Brightness = 0
                for _, v in pairs(Lighting:GetChildren()) do
                    if v:IsA("PostEffect") or v:IsA("Sky") or v:IsA("Atmosphere") then 
                        v:Destroy() 
                    end
                end
            end)
            
            -- 3. Bersihkan Partikel & Tekstur
            task.spawn(function()
                pcall(function()
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Texture") or v:IsA("Decal") then v:Destroy()
                        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then v:Destroy()
                        elseif v:IsA("BasePart") and not v:IsA("Terrain") then
                            v.Material = Enum.Material.SmoothPlastic 
                            v.Reflectance = 0 
                            v.CastShadow = false
                        elseif v:IsA("MeshPart") then 
                            v.TextureID = "" 
                            v.Material = Enum.Material.SmoothPlastic 
                            v.CastShadow = false
                        elseif v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then 
                            v:Destroy() 
                        end
                    end
                end)
            end)
            
            -- 4. Matikan Efek Air
            pcall(function()
                Terrain.WaterWaveSize = 0 
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0 
                Terrain.WaterTransparency = 1
            end)
            
            -- 5. Kunci Kamera di atas langit
            workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
            if saverConnection then saverConnection:Disconnect() end
            saverConnection = RunService.RenderStepped:Connect(function()
                workspace.CurrentCamera.CFrame = CFrame.new(0, 100000, 0)
                workspace.CurrentCamera.FieldOfView = 1
            end)
            
            -- 6. Buat GUI Hitam
            if not blackScreenGui then
                blackScreenGui = Instance.new("ScreenGui")
                blackScreenGui.Name = "NukeGUI"
                blackScreenGui.IgnoreGuiInset = true
                blackScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
                blackScreenGui.DisplayOrder = 10000
                
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1,0,1,0)
                frame.BackgroundColor3 = Color3.new(0,0,0)
                frame.BorderSizePixel = 0
                frame.Parent = blackScreenGui
                
                local label = Instance.new("TextLabel")
                label.Text = "GPU SAVER ON\nGPU LOAD: MINIMAL"
                label.Size = UDim2.new(1,0,0.1,0)
                label.Position = UDim2.new(0,0,0.45,0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.new(1,0,0)
                label.Font = Enum.Font.GothamBold
                label.TextSize = 24
                label.Parent = frame
            end
            blackScreenGui.Enabled = true
            notif("GPU Saver Aktif! Grafik telah dihapus.", 4, "Performance")
            
        else
            -- =======================================
            -- KEMBALIKAN PENGATURAN (TURN OFF)
            -- =======================================
            if saverConnection then 
                saverConnection:Disconnect() 
                saverConnection = nil 
            end
            if root then root.Anchored = false end
            
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            workspace.CurrentCamera.FieldOfView = 70
            
            if blackScreenGui then 
                blackScreenGui.Enabled = false 
            end
            notif("GPU Saver Mati. (Rejoin untuk kembalikan tekstur map)", 4, "Performance")
        end
    end
})
end

local function LoadWebhookTab()
-- ─── TAB WEBHOOK ───
local WebhookTab = Tabs:AddTab({ Name = "Webhook", Icon = "message" })
local WebhookSection = WebhookTab:AddSection("Discord Webhook Settings")

WebhookSection:AddToggle({
    Title = "Enable Webhook",
    Title2 = "Enable",
    Content = "Send a webhook log when target brainrot is farmed",
    Default = Config.EnableWebhook,
    Callback = function(val)
        Config.EnableWebhook = val
        notif("Webhook " .. (val and "ON" or "OFF"), 3, "Webhook")
    end
})

WebhookSection:AddInput({
    Title = "Webhook URL",
    Content = "Enter your Discord webhook URL",
    Default = Config.WebhookURL,
    Callback = function(val)
        Config.WebhookURL = val
        notif("Webhook URL saved!", 3, "Webhook")
    end
})

-- PERBAIKAN 1: Tambahkan tabel unpack "None" dan gunakan handleMultiDropdown
local _webhookRarityRef = {}
_webhookRarityRef.drop = WebhookSection:AddDropdown({
    Title = "Target Rarities",
    Content = "Select rarities to trigger webhook. 'None' = Semua Rarity",
    Options = {"None", table.unpack(RARITY_LIST)}, 
    Default = Config.WebhookRarities,
    Multi = true,
    Callback = function(val)
        handleMultiDropdown(val, "WebhookRarities", _webhookRarityRef.drop)
    end
})

-- PERBAIKAN 2: Gunakan MUTATION_LIST dan handleMultiDropdown
local _webhookMutRef = {}
_webhookMutRef.drop = WebhookSection:AddDropdown({
    Title = "Target Mutations",
    Content = "Select mutations to trigger webhook. 'None' = Semua Mutasi",
    Options = MUTATION_LIST,
    Default = Config.WebhookMutations,
    Multi = true,
    Callback = function(val)
        handleMultiDropdown(val, "WebhookMutations", _webhookMutRef.drop)
    end
})

WebhookSection:AddButton({
    Title = "Test Webhook",
    Content = "Send a test message to Discord",
    Callback = function()
        if Config.WebhookURL == "" then
            notif("Please enter a Webhook URL first!", 3, "Webhook")
            return
        end
        notif("Sending test webhook...", 3, "Webhook")
        if sendWebhook then
            sendWebhook("Noobini Pizzanini", "Rainbow", true)
        end
    end
})

local InvWebhookSection = WebhookTab:AddSection("Inventory Webhook")

InvWebhookSection:AddToggle({
    Title = "Enable Inventory Webhook",
    Title2 = "Enable",
    Content = "Kirim full inventory secara berkala",
    Default = Config.EnableInventoryWebhook,
    Callback = function(val)
        Config.EnableInventoryWebhook = val
        if val then
            startInventoryWebhook()
            notif("Inventory Webhook ON", 3, "Webhook")
        else
            notif("Inventory Webhook OFF", 3, "Webhook")
        end
    end
})

InvWebhookSection:AddInput({
    Title = "Inventory Webhook URL",
    Content = "Masukkan link Discord webhook untuk Inventory",
    Default = Config.InventoryWebhookURL,
    Callback = function(val)
        Config.InventoryWebhookURL = val
        notif("Inventory Webhook URL saved!", 3, "Webhook")
    end
})

InvWebhookSection:AddButton({
    Title = "Send Inventory Now",
    Content = "Kirim full inventory sekarang (bypass timer)",
    Callback = function()
        if not Config.EnableInventoryWebhook then
            notif("Nyalakan Enable Inventory Webhook dulu!", 3, "Webhook")
            return
        end
        if triggerInventoryWebhook then
            triggerInventoryWebhook()
            notif("Mengirim Inventory...", 3, "Webhook")
        end
    end
})

InvWebhookSection:AddInput({
    Title = "Timer (Menit)",
    Content = "Berapa menit sekali kirim inventory (min 1 menit)",
    Default = tostring(Config.InventoryWebhookTimer),
    Numeric = true,
    Callback = function(val)
        local num = tonumber(val) or 10
        if num < 1 then num = 1 end
        Config.InventoryWebhookTimer = num
        notif("Timer set to " .. num .. " menit", 3, "Webhook")
    end
})
end

LoadInfoTab()
task.wait(0.05)
LoadMainTab()
task.wait(0.05)
LoadAutoTab()
task.wait(0.05)
LoadMiscTab()
task.wait(0.05)
LoadWebhookTab()

-- ============================================================
-- RESPAWN HANDLER
-- ============================================================
LocalPlayer.CharacterAdded:Connect(function(char)
    if Config.AutoFarm then
        task.wait(1)
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if hrp then ensureBodyVelocity(hrp) end
    end
end)

task.wait(1)
_G.ScriptFullyLoaded = true
isfromload = false
notif("Script successfully loaded! Open the Farm tab.", 5, "Napoleon")
