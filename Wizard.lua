-- -- -- ============================================================
-- -- -- CORE SECURITY: ANTI-HOOK, ANTI-SPY, & ANTI-TAMPER V3.2
-- -- -- ============================================================
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

-- ============================================================
-- ANTI-STAFF SYSTEM v2.5 (TOGGLEABLE FIXED)
-- Deteksi staff dari Group 509055872 & overhead tag
-- ============================================================
getgenv().AntiStaff = true -- Mengeset default awal langsung TRUE

do
    local _Players       = game:GetService("Players")
    local _TeleportSvc   = game:GetService("TeleportService")

    local STAFF_GROUP_ID = 509055872

    local STAFF_ROLES_EXACT = {
        owner      = true, developer  = true, admin      = true,
        manager    = true, ccm        = true, test       = true, cc = true,
    }

    local STAFF_ROLE_KEYWORDS = {
        "admin", "mod", "moderator", "staff", "developer", "dev",
        "owner", "manager", "helper", "tester", "test", "support",
        "operator", "official", "gamemaster", "gm", "ccm",
    }

    local STAFF_TAG_KEYWORDS = {
        "admin", "mod", "moderator", "staff", "developer", "dev",
        "owner", "manager", "helper", "tester", "support",
        "official", "gamemaster", "gm",
    }

    local _staffAlreadyFound = false

    local function _containsKeyword(str, list)
        local lower = string.lower(str)
        for _, kw in ipairs(list) do
            if string.find(lower, kw, 1, true) then
                return true, kw
            end
        end
        return false, nil
    end

    local function _isStaffRole(roleName)
        if not roleName or roleName == "" or roleName == "Guest" then return false, nil end
        local lower = string.lower(roleName)
        if STAFF_ROLES_EXACT[lower] then return true, "Role Exact: [" .. roleName .. "]" end
        local found, kw = _containsKeyword(roleName, STAFF_ROLE_KEYWORDS)
        if found then return true, "Role Keyword [" .. kw .. "]: " .. roleName end
        return false, nil
    end

    local function _hasAdminTag(targetPlayer)
        local char = targetPlayer.Character
        if not char then return false, nil end
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                local txt = tostring(obj.Text or "")
                if #txt > 0 and #txt < 60 then
                    local found, kw = _containsKeyword(txt, STAFF_TAG_KEYWORDS)
                    if found then return true, "Overhead Tag [" .. kw .. "]: " .. txt end
                end
            end
        end
        return false, nil
    end

    local function _emergencyStop(suspectName, reason)
        if not getgenv().AntiStaff then return end -- Abaikan jika toggle dimatikan
        if _staffAlreadyFound then return end
        _staffAlreadyFound = true

        warn("[NAPOLEON ANTI-STAFF] ⚠️ STAFF TERDETEKSI!")
        warn("[NAPOLEON ANTI-STAFF] Player : " .. tostring(suspectName))
        warn("[NAPOLEON ANTI-STAFF] Alasan : " .. tostring(reason))

        -- 1. Matikan semua fitur cheat biar aman
        local flags = {
            "AutoFarm","AutoCollect","AutoSkill","AutoSell",
            "AlchemyGod","AutoBrew","AutoFusePotions",
            "AutoAscend","AutoStats","AutoFavorite","AntiAFK",
        }
        for _, flag in ipairs(flags) do getgenv()[flag] = false end

        -- 2. Munculkan UI Raksasa "ADA STAF JIRR WKWK"
        pcall(function()
            local screenGui = Instance.new("ScreenGui")
            screenGui.IgnoreGuiInset = true
            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
            
            -- Pasang di CoreGui biar gak gampang kehapus game
            local coreGui = game:GetService("CoreGui")
            if coreGui then
                screenGui.Parent = coreGui
            else
                screenGui.Parent = _Players.LocalPlayer:WaitForChild("PlayerGui")
            end

            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(1, 0, 1, 0)
            bg.BackgroundColor3 = Color3.fromRGB(15, 0, 0) -- Warna merah gelap
            bg.BackgroundTransparency = 0.1
            bg.Parent = screenGui

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(0.9, 0, 0.4, 0)
            textLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = "ADA STAF JIRR WKWK"
            textLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            textLabel.TextScaled = true
            textLabel.Font = Enum.Font.GothamBlack
            textLabel.Parent = bg
            
            local subText = Instance.new("TextLabel")
            subText.Size = UDim2.new(1, 0, 0.2, 0)
            subText.Position = UDim2.new(0, 0, 1, 0)
            subText.BackgroundTransparency = 1
            subText.Text = "Terdeteksi: " .. suspectName .. " | Auto-Kick System"
            subText.TextColor3 = Color3.fromRGB(255, 255, 255)
            subText.TextScaled = true
            subText.Font = Enum.Font.GothamBold
            subText.Parent = textLabel
        end)

        task.wait(1.5)
        pcall(function()
            _Players.LocalPlayer:Kick("ADA STAF JIRR WKWK\n(System: Berhasil kabur dari " .. suspectName .. ")")
        end)
    end

    local function _checkPlayer(targetPlayer)
        if targetPlayer == _Players.LocalPlayer then return end

        task.spawn(function()
            task.wait(1.5)
            if not getgenv().AntiStaff then return end

            -- Cek Role di Group Staff
            local ok, role = pcall(function() return targetPlayer:GetRoleInGroup(STAFF_GROUP_ID) end)
            if ok and role then
                local isStaff, reason = _isStaffRole(role)
                if isStaff then
                    _emergencyStop(targetPlayer.Name, reason)
                    return
                end
            end

            -- Cek Overhead Tag
            if not targetPlayer.Character then
                local conn
                conn = targetPlayer.CharacterAdded:Connect(function(newChar)
                    conn:Disconnect()
                    task.wait(1)
                    if not getgenv().AntiStaff then return end
                    local found, rsn = _hasAdminTag(targetPlayer)
                    if found then _emergencyStop(targetPlayer.Name, rsn) end
                end)
            else
                local found, rsn = _hasAdminTag(targetPlayer)
                if found then
                    _emergencyStop(targetPlayer.Name, rsn)
                    return
                end
            end

            -- Pantau kalau dia respawn
            targetPlayer.CharacterAdded:Connect(function()
                task.wait(1)
                if not getgenv().AntiStaff then return end
                local found, rsn = _hasAdminTag(targetPlayer)
                if found then _emergencyStop(targetPlayer.Name, rsn) end
            end)
        end)
    end

    for _, p in ipairs(_Players:GetPlayers()) do _checkPlayer(p) end
    _Players.PlayerAdded:Connect(function(newPlayer) _checkPlayer(newPlayer) end)
end

-- KEY SISTEM DI BAWAH INI BANG

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

-- -- -- ============================================================
-- -- -- TRACKING
-- -- -- ============================================================
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
-- NAPOLEON v14.0 - ULTIMATE WIZARD (Alchemy God & Clean UI Edition)
-- ============================================================
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

-- ============================================================
-- ANTI AFK SYSTEM
-- ============================================================
player.Idled:Connect(function()
    if getgenv().AntiAFK then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)
local msgFolder = ReplicatedStorage:WaitForChild("Msg")
local remoteEventFolder = msgFolder:WaitForChild("RemoteEvent")

-- Jalur Komunikasi Remotes (100% Sesuai Log Cobalt)
local remoteFunction = msgFolder:WaitForChild("RemoteFunction"):WaitForChild("RemoteFunction")
local talkFunc = msgFolder:WaitForChild("Function"):WaitForChild("TalkFunc")
local generalRemoteEvent = remoteEventFolder:WaitForChild("RemoteEvent")
local releaseGroupSkillEvent = remoteEventFolder:WaitForChild("ReleaseGroupSkill")

-- Kunci Utama Batas Ransel
local bagFullMaterial = player:WaitForChild("BagFullMaterial")

-- Load Module Database Game
local UtilsSystem = require(ReplicatedFirst.AllSideCode.UtilsSystem)
local CfgFind = UtilsSystem.CfgFind
local PlayerData = UtilsSystem.PlayerData
local EnumMgr = UtilsSystem.EnumMgr
local LanguageCfg
pcall(function()
    LanguageCfg = require(ReplicatedFirst.AllSideCode.ToolBasic.TranslationHelper.LanguageCfg)
end)

-- Variabel Utama UI
getgenv().AutoFarm = false
getgenv().AutoCollect = false
getgenv().AutoSkill = false
getgenv().AutoSell = false
getgenv().AlchemyGod = false -- State control untuk fitur baru Alchemy
getgenv().InstantKill = false -- Instant Kill toggle
getgenv().SelectedMaterialsToSell = {} 
getgenv().SelectedPotionsToSell = {}
getgenv().SelectedMonsters = {"All"} 

-- Auto Brewing & Fuse
getgenv().AutoBrew = false
getgenv().SelectedBrewMaterials = {}
getgenv().AutoFusePotions = false
getgenv().IsBrewingTaskRunning = false

local attackDelay = 0.2
local currentTarget = nil
local lastSafeCFrame = nil
local emptyChecksCount = 0

-- Teks Kamus untuk Dropdown
local AllMaterialNames = {}
local AllPotionNames = {}
local IdToTranslatedMap = {}
local TranslatedNameToIdMap = {} -- dipakai oleh Auto Brew
local monsterList = {"All"} 
local MonsterNameToIdMap = {} 

-- ============================================================
-- 🧪 ALCHEMY GOD + ⚔️ INSTANT KILL — SINGLE NAMECALL HOOK
-- PENTING: hookmetamethod __namecall hanya bisa dipasang SEKALI.
-- ============================================================
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- [1] ALCHEMY GOD: Paksa Purity brew selalu 100%
    if not checkcaller() and method == "InvokeServer" then 
        if args[1] == "\231\130\188\232\141\175" then 
            if type(args[2]) == "table" then
                args[2].gameScore = 100
            end
        end
    end

    return oldNamecall(self, unpack(args))
end)

-- ============================================================
-- ⚔️ INSTANT KILL — CLIENT-SIDE HEALTH BYPASS METHOD
-- ============================================================
local function isMonsterDead(monster)
    if not monster or not monster.Parent then return true end
    local hum = monster:FindFirstChildOfClass("Humanoid")
    if not hum then return true end
    if getgenv().InstantKill then
        return (hum:GetState() == Enum.HumanoidStateType.Dead)
    else
        return (hum.Health <= 0)
    end
end

task.spawn(function()
    while task.wait() do
        if getgenv().InstantKill and currentTarget and currentTarget.Parent then
            local hum = currentTarget:FindFirstChildOfClass("Humanoid")
            if hum and not isMonsterDead(currentTarget) then
                if hum.Health > 0 then
                    pcall(function()
                        hum.Health = 0
                    end)
                end
            end
        end
    end
end)


-- ============================================================
-- 📦 DATABASE MANIFEST INTERCEPTOR (Dropdown Generator)
-- ============================================================
local function buildKatalogDropdowns()
    -- 1. Generator Dropdown Material
    table.clear(AllMaterialNames)
    table.clear(IdToTranslatedMap)
    table.clear(TranslatedNameToIdMap)
    local materialTable = CfgFind.GetCfgByName("materialConf") or CfgFind.GetCfgByName("itemConf")
    if type(materialTable) == "table" then
        for id, data in pairs(materialTable) do
            if type(data) == "table" and data.ZhName then
                local translatedName = nil
                pcall(function() if LanguageCfg then translatedName = LanguageCfg.FormatByKey(data.ZhName) end end)
                if translatedName and translatedName ~= "" and translatedName ~= data.ZhName and not string.match(translatedName, "[\228-\233]") then
                    local stringId = tostring(id)
                    if not IdToTranslatedMap[stringId] then
                        IdToTranslatedMap[stringId] = translatedName
                        TranslatedNameToIdMap[translatedName] = tonumber(id)
                        table.insert(AllMaterialNames, translatedName)
                    end
                end
            end
        end
    end
    table.sort(AllMaterialNames)

    -- 1b. Generator Dropdown Potion
    table.clear(AllPotionNames)
    local potionTable = CfgFind.GetCfgByName("medicineConf") or CfgFind.GetCfgByName("potionConf") or CfgFind.GetCfgByName("drugConf")
    if type(potionTable) == "table" then
        for id, data in pairs(potionTable) do
            if type(data) == "table" and data.ZhName then
                local translatedName = nil
                pcall(function() if LanguageCfg then translatedName = LanguageCfg.FormatByKey(data.ZhName) end end)
                if translatedName and translatedName ~= "" and translatedName ~= data.ZhName and not string.match(translatedName, "[\228-\233]") then
                    local stringId = tostring(id)
                    if not IdToTranslatedMap[stringId] then
                        IdToTranslatedMap[stringId] = translatedName
                    end
                    if not table.find(AllPotionNames, translatedName) then
                        table.insert(AllPotionNames, translatedName)
                    end
                end
            end
        end
    end
    table.sort(AllPotionNames)

    -- 2. Generator Dropdown Monster + Registrasi Balik Nama Ke ID
    local enemyTable = CfgFind.GetCfgByName("enemyConf") or CfgFind.GetCfgByName("enemy") or CfgFind.GetCfgByName("monsterConf")
    if type(enemyTable) == "table" then
        for id, data in pairs(enemyTable) do
            if type(data) == "table" and data.ZhName then
                local transMonsterName = nil
                pcall(function() if LanguageCfg then transMonsterName = LanguageCfg.FormatByKey(data.ZhName) end end)
                if not transMonsterName or transMonsterName == "" then transMonsterName = data.ZhName end
                
                if transMonsterName then
                    local stringId = tostring(id)
                    MonsterNameToIdMap[transMonsterName] = stringId
                    
                    if not table.find(monsterList, transMonsterName) then
                        table.insert(monsterList, transMonsterName)
                    end
                end
            end
        end
    end
    table.sort(monsterList)
end
buildKatalogDropdowns()

-- ============================================================
-- 1. EXTRACT NAMA MONSTER
-- ============================================================
local monsterNameCache = setmetatable({}, {__mode = "k"})
local function getRealMonsterName(monsterObj)
    if monsterNameCache[monsterObj] then return monsterNameCache[monsterObj] end
    local finalName = nil
    local dbID = monsterObj:GetAttribute("ID")
    local zhNameAttr = monsterObj:GetAttribute("ZhName")
    if dbID then
        pcall(function()
            local enemyData = CfgFind.FindCfgByID(dbID, EnumMgr.ItemType.Enemy)
            if enemyData and enemyData.ZhName and LanguageCfg then
                local translated = LanguageCfg.FormatByKey(enemyData.ZhName)
                if translated and translated ~= "" then finalName = translated
                else finalName = enemyData.ZhName end
            end
        end)
    end
    if not finalName and zhNameAttr and LanguageCfg then
        pcall(function() finalName = LanguageCfg.FormatByKey(zhNameAttr) or zhNameAttr end)
    end
    if not finalName then
        for _, desc in ipairs(monsterObj:GetDescendants()) do
            if desc:IsA("TextLabel") and desc.Text ~= "" then
                local txt = desc.Text
                if not tonumber(txt) and not string.match(string.lower(txt), "lv%.?%s*%d+") then
                    finalName = txt; break
                end
            end
        end
    end
    if not finalName then finalName = "Monster ID: " .. tostring(dbID or monsterObj.Name) end
    monsterNameCache[monsterObj] = finalName
    return finalName
end

-- ============================================================
-- 2. NAPOLEON UI SETUP (CLEAN DESIGN OVERHAUL)
-- ============================================================
_G.ScriptFullyLoaded = false 
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Fdhlnn23/NapoleonUI/refs/heads/main/NPLN-UIv2.lua"))()
local ICON_ID = "96531489912535" 

local function notif(content, duration, title)
    if not _G.ScriptFullyLoaded then return end
    if Library and Library.MakeNotify then
        Library:MakeNotify({ Title = title or "NAPOLEON", Content = content, Delay = duration or 4, Icon = "rbxassetid://" .. ICON_ID })
    end
end

local Window = Library:Window({
    Title = "Napoloen", Footer = "Wizard Alchemy",
    Color = Color3.fromRGB(255, 255, 255), Color2 = Color3.fromRGB(192, 192, 192),
    ["Tab Width"] = 130, Image = "136289055140268", WindowIMG = "93732999692312", LogoHUB = "136289055140268"
})

local FarmTab = Window:AddTab({ Name = "Main", Icon = "rod" })
local FarmSection = FarmTab:AddSection("Auto Farming")

local MonsterDropdown = FarmSection:AddDropdown({
    Title = "Target Monster", Content = "Select monster to hunt.",
    Default = {"All"}, Options = monsterList, Multi = true,
    Callback = function(ValueTable)
        getgenv().SelectedMonsters = ValueTable
        currentTarget = nil 
        notif("Monster list updated!", 3)
    end    
})

getgenv().HopMethod = "Normal"
local HopDropdown = FarmSection:AddDropdown({
    Title = "Hop Method", Content = "Select action when target monsters are depleted.",
    Default = {"Normal"}, Options = {"Normal", "Server Hop"}, Multi = false,
    Callback = function(Value)
        if type(Value) == "table" then
            getgenv().HopMethod = Value[1] or "Normal"
        else
            getgenv().HopMethod = Value or "Normal"
        end
    end    
})

FarmSection:AddToggle({
    Title = "Auto Farm", Content = "Start farming selected monsters.",
    Default = false,
    Callback = function(Value)
        getgenv().AutoFarm = Value
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not Value then
            if hrp and hrp:FindFirstChild("FarmBV") then hrp.FarmBV:Destroy() end
            currentTarget = nil
            if char then
                for _, child in ipairs(char:GetChildren()) do
                    if child:IsA("BasePart") then child.CanCollide = true end
                end
            end
            notif("Auto Farm disabled.", 3)
        else
            notif("Auto Farm enabled!", 3, "Danger")
        end
    end    
})

FarmSection:AddToggle({
    Title = "Auto Use Skill", Content = "Use skills automatically in combat.",
    Default = false,
    Callback = function(Value) getgenv().AutoSkill = Value end    
})

FarmSection:AddToggle({
    Title = "Instant Kill", Content = "One-shot monsters via client-side Health bypass.",
    Default = false,
    Callback = function(Value)
        getgenv().InstantKill = Value
        if Value then
            notif("Instant Kill enabled! ⚡", 3, "Danger")
        else
            notif("Instant Kill disabled.", 3)
        end
    end
})

local EcoTab = Window:AddTab({ Name = "Auto", Icon = "loop" })

-- === Auto Collect ===
local AutoCollectSection = EcoTab:AddSection("Auto Collect")
AutoCollectSection:AddToggle({
    Title = "Auto Collect Drops",
    Content = "Pick up dropped items automatically.",
    Default = false,
    Callback = function(Value) getgenv().AutoCollect = Value end
})

-- === Auto Brewing ===
local AutoBrewingSection = EcoTab:AddSection("Auto Brewing")
AutoBrewingSection:AddToggle({
    Title = "Auto Brew (AFK)",
    Content = "Brew when selected material reaches 5.",
    Default = false,
    Callback = function(Value)
        getgenv().AutoBrew = Value
        if Value then notif("Auto Brew enabled!", 3, "Success") end
    end
})

AutoBrewingSection:AddDropdown({
    Title = "Brew Material",
    Content = "Pick material to brew in background.",
    Default = {},
    Options = AllMaterialNames,
    Multi = true,
    Callback = function(ValueTable)
        getgenv().SelectedBrewMaterials = ValueTable
    end
})

AutoBrewingSection:AddToggle({
    Title = "Manual Brew (Alchemy God)",
    Content = "Brew manually with 100% purity.",
    Default = false,
    Callback = function(Value)
        getgenv().AlchemyGod = Value
        local ok, GameCfg = pcall(function()
            return require(ReplicatedStorage.GuiScripts.ModuleScript.PotionBrewingGame.GameCfg)
        end)
        
        if ok and GameCfg and GameCfg.TEST_MODE then
            if Value then
                GameCfg.TEST_MODE.Game1 = true
                GameCfg.TEST_MODE.Game2 = true
                GameCfg.TEST_MODE.Game3 = true
                GameCfg.TEST_MODE.WatchPotionShowAnimation = true
                
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Alchemy God Aktif!",
                    Text = "Developer Auto-Skip menyala! Klik Racik dan lihat keajaibannya (100% Purity).",
                    Duration = 5
                })
                notif("Alchemy God enabled!", 3, "Success")
            else
                GameCfg.TEST_MODE.Game1 = false
                GameCfg.TEST_MODE.Game2 = false
                GameCfg.TEST_MODE.Game3 = false
                GameCfg.TEST_MODE.WatchPotionShowAnimation = false
                notif("Alchemy God disabled.", 3, "Danger")
            end
        else
            warn("Gagal menemukan GameCfg. Pastikan kamu sudah berada di dalam game.")
            notif("Failed to inject brew mod.", 3, "Danger")
        end
    end
})

-- === Auto Ascend ===
local AutoAscendSection = EcoTab:AddSection("Auto Ascend")
getgenv().AutoAscend = false
AutoAscendSection:AddToggle({
    Title = "Auto Ascend",
    Content = "Auto rank up when ready.",
    Default = false,
    Callback = function(Value)
        getgenv().AutoAscend = Value
        if Value then notif("Auto Ascend enabled!", 3, "Success") end
    end
})

-- === Auto Stats ===
local AutoStatsSection = EcoTab:AddSection("Auto Stats")
getgenv().AutoStats = false
getgenv().SelectedStats = {}

AutoStatsSection:AddToggle({
    Title = "Auto Update Stats",
    Content = "Auto allocate stat points.",
    Default = false,
    Callback = function(Value)
        getgenv().AutoStats = Value
        if Value then notif("Auto Stats enabled!", 3, "Success") end
    end
})

AutoStatsSection:AddDropdown({
    Title = "Stats to Upgrade",
    Content = "Select stats to allocate.",
    Default = {},
    Options = {"Attack", "HP", "Cooling Reduction", "Movement Speed"},
    Multi = true,
    Callback = function(ValueTable)
        getgenv().SelectedStats = ValueTable
    end
})

-- ============================================================
-- TAB: INVENTORY
-- ============================================================
local InvenTab = Window:AddTab({ Name = "Inventory", Icon = "bag" })

-- === Auto Sell ===
local SellSection = InvenTab:AddSection("Auto Sell")

SellSection:AddToggle({
    Title = "Auto Sell",
    Content = "Continuously sell selected items.",
    Default = false,
    Callback = function(Value)
        getgenv().AutoSell = Value
        if Value then notif("Auto Sell enabled!", 3, "Success") end
    end
})

SellSection:AddDropdown({
    Title = "Material to Sell",
    Content = "Select materials to auto-sell.",
    Default = {},
    Options = AllMaterialNames,
    Multi = true,
    Callback = function(ValueTable)
        getgenv().SelectedMaterialsToSell = ValueTable
    end
})

SellSection:AddDropdown({
    Title = "Potion to Sell",
    Content = "Select potions to auto-sell.",
    Default = {},
    Options = AllPotionNames,
    Multi = true,
    Callback = function(ValueTable)
        getgenv().SelectedPotionsToSell = ValueTable
    end
})

getgenv().SellAmount = 0
SellSection:AddInput({
    Title = "Sell Amount",
    Content = "0 = sell all.",
    Default = "0",
    Callback = function(Value)
        getgenv().SellAmount = tonumber(Value) or 0
    end
})

-- === Auto Fuse Potion ===
local FuseSection = InvenTab:AddSection("Auto Fuse Potion")
FuseSection:AddToggle({
    Title = "Auto Fuse Potion",
    Content = "Fuse potions to next tier. Stops at SSS.",
    Default = false,
    Callback = function(Value)
        getgenv().AutoFusePotions = Value
        if Value then notif("Auto Fuse enabled!", 3, "Success") end
    end
})

-- === Auto Favorite ===
local FavSection = InvenTab:AddSection("Auto Favorite")

getgenv().AutoFavorite = false
getgenv().SelectedMaterialsToFav = {}
getgenv().SelectedPotionsToFav = {}

FavSection:AddToggle({
    Title = "Auto Favorite",
    Content = "Lock selected items in inventory.",
    Default = false,
    Callback = function(Value)
        getgenv().AutoFavorite = Value
        if Value then notif("Auto Favorite enabled!", 3, "Success") end
    end
})

local FavMatDropdown = FavSection:AddDropdown({
    Title = "Material to Favorite",
    Content = "Click Refresh first.",
    Default = {},
    Options = {"(Refresh First)"},
    Multi = true,
    Callback = function(ValueTable)
        getgenv().SelectedMaterialsToFav = ValueTable
    end
})

local FavPotDropdown = FavSection:AddDropdown({
    Title = "Potion to Favorite",
    Content = "Click Refresh first.",
    Default = {},
    Options = {"(Refresh First)"},
    Multi = true,
    Callback = function(ValueTable)
        getgenv().SelectedPotionsToFav = ValueTable
    end
})

FavSection:AddButton({
    Title = "Refresh Inventory",
    Content = "Scan bag to update dropdowns.",
    Callback = function()
        local bagData = PlayerData.GetPlrDataByKey(player, "Bag")
        if not bagData then return end

        local invMats = {}
        local invPots = {}

        for uniqueID, item in pairs(bagData) do
            if type(item) == "table" and item.id then
                local itemCfg = CfgFind.FindCfgByID(item.id, item.tp)
                if itemCfg and itemCfg.ZhName then
                    local tName = nil
                    pcall(function() if LanguageCfg then tName = LanguageCfg.FormatByKey(itemCfg.ZhName) end end)
                    if tName then
                        local qty = tonumber(item.num) or tonumber(item.count) or tonumber(item.amount) or 0
                        if qty > 0 then
                            local isPotion = table.find(AllPotionNames, tName)
                            local isMaterial = table.find(AllMaterialNames, tName)
                            if isPotion or isMaterial then
                                tName = string.gsub(tName, "%s*[Pp]otion", "")
                                local tierVal = item.tier or item.grade or item.quality or item.refine or item.star or item.step or item.refineLevel or item.refineLv or item.purity
                                local qualityStr = tierVal and (" <" .. tostring(tierVal) .. ">") or ""
                                local finalName = tName .. qualityStr .. " [" .. tostring(qty) .. "x]"
                                if isPotion then
                                    if not table.find(invPots, finalName) then table.insert(invPots, finalName) end
                                elseif isMaterial then
                                    if not table.find(invMats, finalName) then table.insert(invMats, finalName) end
                                end
                            end
                        end
                    end
                end
            end
        end

        table.sort(invMats)
        table.sort(invPots)
        FavMatDropdown:SetValues(invMats)
        FavPotDropdown:SetValues(invPots)
        notif("Inventory refreshed!", 2, "Success")
    end
})

-- ============================================================
-- TAB: MISC
-- ============================================================
local MiscTab = Window:AddTab({ Name = "Misc", Icon = "settings" })
local MiscSection = MiscTab:AddSection("Miscellaneous")

getgenv().AntiAFK = true
MiscSection:AddToggle({
    Title = "Anti AFK",
    Content = "Prevent idle kick.",
    Default = true,
    Callback = function(Value)
        getgenv().AntiAFK = Value
        if Value then notif("Anti AFK enabled!", 3, "Success") end
    end
})

getgenv().AutoRefreshGuide = true
MiscSection:AddToggle({
    Title = "Auto Refresh Guide",
    Content = "Refresh guide for repeated rewards.",
    Default = true,
    Callback = function(Value)
        getgenv().AutoRefreshGuide = Value
    end
})

-- ============================================================
-- GAMEPASS UNLOCKER (Misc Tab Section)
-- ============================================================
local GamepassSection = MiscTab:AddSection("Gamepass Unlocker")

GamepassSection:AddButton({
    Title = "Unlock All Gamepass",
    Content = "Set all GamePass values to 1 client-side.",
    Callback = function()
        pcall(function()
            local gamePassFolder = game:GetService("Players").LocalPlayer:FindFirstChild("GamePass")
            if gamePassFolder then
                for _, child in ipairs(gamePassFolder:GetChildren()) do
                    if child:IsA("ValueBase") or child.ClassName:find("Value") then
                        child.Value = 1
                    end
                end
                notif("All gamepasses unlocked!", 4, "Success")
            else
                notif("GamePass folder not found!", 4, "Danger")
            end
        end)
    end
})

-- ============================================================
-- ANTI-STAFF UI (Misc Tab Section)
-- ============================================================
local AntiStaffSection = MiscTab:AddSection("Anti-Staff System")

AntiStaffSection:AddToggle({
    Title = "Anti-Staff Protection",
    Content = "Auto-rejoin server if staff is detected.",
    Default = true,
    Callback = function(Value)
        getgenv().AntiStaff = Value
        if Value then 
            notif("Anti-Staff enabled!", 3, "Success") 
        else 
            notif("Anti-Staff disabled!", 3, "Danger") 
        end
    end
})

-- Tombol scan manual semua player di server saat ini
AntiStaffSection:AddButton({
    Title = "Scan Server Now",
    Content = "Cek semua player di server sekarang.",
    Callback = function()
        local scanned = 0
        local found   = {}
        local _PS     = game:GetService("Players")
        local me      = _PS.LocalPlayer

        local STAFF_EXACT_UI = {
            owner=true, developer=true, admin=true,
            manager=true, ccm=true, test=true, cc=true,
        }
        local STAFF_KW_UI = {
            "admin","mod","moderator","staff","developer","dev",
            "owner","manager","helper","tester","test","support",
            "operator","official","gamemaster","gm","ccm",
        }

        notif("Scanning " .. #_PS:GetPlayers() .. " player(s)...", 3, "Napoleon")

        for _, p in ipairs(_PS:GetPlayers()) do
            if p ~= me then
                scanned += 1
                pcall(function()
                    local role = p:GetRoleInGroup(509055872) or "Guest"
                    local rLow = string.lower(role)
                    local isStaff = STAFF_EXACT_UI[rLow]
                    if not isStaff then
                        for _, kw in ipairs(STAFF_KW_UI) do
                            if string.find(rLow, kw, 1, true) then
                                isStaff = true; break
                            end
                        end
                    end
                    if isStaff and role ~= "Guest" then
                        table.insert(found, p.Name .. " [" .. role .. "]")
                    end
                end)
            end
        end

        if #found > 0 then
            notif("⚠️ STAFF DITEMUKAN: " .. table.concat(found, ", "), 8, "Danger")
            warn("[NAPOLEON ANTI-STAFF] Manual Scan Result:")
            for _, s in ipairs(found) do warn("  → " .. s) end
        else
            notif("✅ Scan selesai. " .. scanned .. " player dicek. Tidak ada staff.", 4, "Success")
        end
    end
})

_G.ScriptFullyLoaded = true
notif("NAPOLEON v14.0 Ready!", 4, "Success")


-- ============================================================
-- 3. LOGIKA KITING MUTLAK + AUTO NO-CLIP + HOVER ANCHOR + CAMERA LOCK
-- ============================================================
local camPart = workspace:FindFirstChild("NplnCamPart")
if not camPart then
    camPart = Instance.new("Part")
    camPart.Name = "NplnCamPart"
    camPart.Transparency = 1
    camPart.Anchored = true
    camPart.CanCollide = false
    camPart.Size = Vector3.new(1, 1, 1)
    camPart.Parent = workspace
end

local function getValidTarget()
    local folder = workspace:FindFirstChild("Monster")
    if not folder then return nil end
    for _, monster in ipairs(folder:GetChildren()) do
        local hum = monster:FindFirstChildOfClass("Humanoid")
        if hum and not isMonsterDead(monster) then
            local realName = getRealMonsterName(monster)
            local isMatched = false
            
            if table.find(getgenv().SelectedMonsters, "All") then
                isMatched = true
            else
                for _, targetName in ipairs(getgenv().SelectedMonsters) do
                    if string.lower(realName) == string.lower(targetName) then
                        isMatched = true
                        break
                    end
                end
            end
            
            if isMatched then return monster end
        end
    end
    return nil
end

-- ============================================================
--  REJOIN NEW SERVER (Monster Fresh)
-- ============================================================
local function executeServerHop()
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local placeId = game.PlaceId
    local currentJobId = game.JobId
    local LocalPlayer = game:GetService("Players").LocalPlayer

    local queueFunc = queue_on_teleport
        or queueonteleport
        or (syn and syn.queue_on_teleport)

    local scriptSetelahRejoin = [[
        repeat task.wait() until game:IsLoaded()
        pcall(function()
            if isfile("Wizard.lua") then
                loadstring(readfile("Wizard.lua"))()
            elseif isfile("Napoleon_Source/Wizard.lua") then
                loadstring(readfile("Napoleon_Source/Wizard.lua"))()
            end
        end)
    ]]

    local function getNewServer()
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
        local ok, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)

        if not ok or not result or not result.data then
            warn("[Rejoin] Gagal ambil list server. Fallback ke Teleport biasa.")
            return nil
        end

        for _, server in ipairs(result.data) do
            if server.id ~= currentJobId and server.playing < server.maxPlayers then
                return server.id
            end
        end
        return nil
    end

    notif("Monsters depleted! Hopping to a new server...", 4, "Napoleon Hop")
    task.wait(1)

    local targetJobId = getNewServer()

    if queueFunc and scriptSetelahRejoin:match("%S") then
        pcall(function() queueFunc(scriptSetelahRejoin) end)
    end

    if targetJobId then
        TeleportService:TeleportToPlaceInstance(placeId, targetJobId, LocalPlayer)
    else
        pcall(function()
            local options = Instance.new("TeleportOptions")
            options.ShouldReserveServer = false
            TeleportService:TeleportAsync(placeId, {LocalPlayer}, options)
        end)
    end
end

-- 🚀 TARGETING & COLLISION WORKER (Menghapus Beban CPU Frame-By-Frame)
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().AutoFarm then
            local char = player.Character
            if char then
                -- Menjalankan ini 10x per detik JAUH LEBIH RINGAN dibanding 60x per detik di Heartbeat
                for _, child in ipairs(char:GetChildren()) do
                    if child:IsA("BasePart") and child.CanCollide then 
                        child.CanCollide = false 
                    end
                end
            end
            
            if not currentTarget or not currentTarget.Parent or isMonsterDead(currentTarget) then
                currentTarget = getValidTarget()
                if currentTarget then
                    emptyChecksCount = 0
                    -- Cache stat monster ke Atribut lokal agar Heartbeat tidak perlu baca database tiap frame!
                    local attackRange = 0
                    local maxChase = 45
                    pcall(function()
                        local dbID = currentTarget:GetAttribute("ID")
                        local enemyData = CfgFind.FindCfgByID(dbID, EnumMgr.ItemType.Enemy)
                        if enemyData then
                            attackRange = tonumber(enemyData.attackRange) or 0
                            maxChase = tonumber(enemyData.patientRange) or 45
                        end
                    end)
                    currentTarget:SetAttribute("CachedAttackRange", attackRange)
                    currentTarget:SetAttribute("CachedMaxChase", maxChase)
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if not getgenv().AutoFarm then 
        if hrp and hrp:FindFirstChild("FarmBV") then hrp.FarmBV:Destroy() end
        lastSafeCFrame = nil
        
        if hum and workspace.CurrentCamera.CameraSubject == camPart then
            workspace.CurrentCamera.CameraSubject = hum
        end
        return 
    end
    
    if not hrp then return end
    
    if currentTarget and currentTarget.Parent and not isMonsterDead(currentTarget) then
        local bv = hrp:FindFirstChild("FarmBV")
        if not bv then
            bv = Instance.new("BodyVelocity")
            bv.Name = "FarmBV"
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.zero
            bv.Parent = hrp
        end
        
        local monsterCF = currentTarget:GetPivot()
        local atkRange = currentTarget:GetAttribute("CachedAttackRange") or 0
        local maxChs = currentTarget:GetAttribute("CachedMaxChase") or 45
        
        -- ============================================================
        -- ANTI-LOG SAFE MOVEMENT (BYPASS TELEPORT DETECT)
        -- ============================================================
        local driftZ = math.random(-2, 2)
        local driftY = math.random(-1, 1)

        local safeZ, safeY
        if atkRange <= 0 then
            safeZ = 0 + driftZ
            safeY = -12 + driftY
        else
            safeZ = math.clamp(atkRange + 10, 10, maxChs + 10)
            safeY = -18 
        end
        
        local targetPos = (monsterCF * CFrame.new(0, safeY, safeZ)).Position
        local idealCFrame = CFrame.lookAt(targetPos, monsterCF.Position)
        
        if not lastSafeCFrame then
            lastSafeCFrame = idealCFrame 
        else
            local dist = (lastSafeCFrame.Position - idealCFrame.Position).Magnitude
            if dist > 30 then
                lastSafeCFrame = lastSafeCFrame:Lerp(idealCFrame, 0.2) 
            else
                lastSafeCFrame = idealCFrame
            end
        end
        
        hrp.CFrame = lastSafeCFrame
        
        -- [!!!] PHYSICS WIPER: ANTI DETECTED TELEPORT [!!!]
        -- Menghapus jejak momentum/kecepatan agar server tidak mendeteksi speedhack
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.RotVelocity = Vector3.new(0, 0, 0)
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end)
        
        -- CAMERA LOCK
        camPart.Position = monsterCF.Position + Vector3.new(0, 2, 0)
        workspace.CurrentCamera.CameraSubject = camPart
    else
        if lastSafeCFrame then
            hrp.CFrame = lastSafeCFrame
        end
        if hum and workspace.CurrentCamera.CameraSubject == camPart then
            workspace.CurrentCamera.CameraSubject = hum
        end
    end
end)

-- 🚀 SEQUENTIAL PATROL CHUNK LOADER (Berpindah Cepat, Instan Hop jika Kosong)
task.spawn(function()
    local entitiesPosFolder = workspace:WaitForChild("EntitiesPos")
    pcall(function() settings().Physics.AllowSleep = false end)
    
    local globalSpawnIndex = 1 

    while true do
        if getgenv().AutoFarm and not currentTarget then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp and entitiesPosFolder then
                local validSpawnPoints = {}
                
                if table.find(getgenv().SelectedMonsters, "All") then
                    validSpawnPoints = entitiesPosFolder:GetChildren()
                else
                    for _, monsterName in ipairs(getgenv().SelectedMonsters) do
                        local targetId = MonsterNameToIdMap[monsterName]
                        if targetId then
                            for _, child in ipairs(entitiesPosFolder:GetChildren()) do
                                if child.Name == targetId then
                                    table.insert(validSpawnPoints, child)
                                end
                            end
                        end
                    end
                end
                
                if #validSpawnPoints > 0 then
                    if globalSpawnIndex > #validSpawnPoints then
                        globalSpawnIndex = 1
                    end
                    
                    local currentPatrolSpawn = validSpawnPoints[globalSpawnIndex]
                    if currentPatrolSpawn and (currentPatrolSpawn:IsA("BasePart") or currentPatrolSpawn:IsA("Model")) then
                        local spawnPos = currentPatrolSpawn:GetPivot().Position
                        -- Sembunyi di bawah tanah saat patroli / mencari monster
                        lastSafeCFrame = CFrame.new(spawnPos + Vector3.new(0, -15, 0))
                        hrp.CFrame = lastSafeCFrame
                        
                        -- Tunggu 2.0 detik agar chunk me-render monster
                        task.wait(2.0)
                        
                        -- Cek apakah setelah rendering ada target yang valid
                        local foundTarget = getValidTarget()
                        if foundTarget then
                            currentTarget = foundTarget
                            emptyChecksCount = 0
                            globalSpawnIndex = globalSpawnIndex + 1
                        else
                            -- Jika tidak ada monster di spawn point ini
                            emptyChecksCount = emptyChecksCount + 1
                            if getgenv().HopMethod == "Server Hop" and emptyChecksCount >= #validSpawnPoints then
                                emptyChecksCount = 0
                                executeServerHop()
                            else
                                -- Jika normal atau belum semua spawn point dicek, lanjut ke spawn berikutnya
                                globalSpawnIndex = globalSpawnIndex + 1
                            end
                        end
                    else
                        globalSpawnIndex = globalSpawnIndex + 1
                    end
                else
                    emptyChecksCount = 0
                    task.wait(1)
                end
            else
                emptyChecksCount = 0
                task.wait(1)
            end
        else
            emptyChecksCount = 0
            task.wait(1)
        end
    end
end)

-- ============================================================
-- SUPER AIMBOT / POINT-BLANK SPOOFING (ANTI MLESET)
-- ============================================================
task.spawn(function()
    local lastSkill1 = 0
    local lastSkill2 = 0
    local cdSkill1 = 4 -- Cooldown skill 1 (detik)
    local cdSkill2 = 7 -- Cooldown skill 2 (detik)
    
    while task.wait(attackDelay) do
        if not getgenv().AutoFarm or not currentTarget then continue end
        
        -- FIX: Tambahkan pengecekan untuk part "Root" atau "PrimaryPart"
        -- Karena Big Bird's Nest tidak pakai "HumanoidRootPart" tapi "Root"
        local monsterHRP = currentTarget:FindFirstChild("HumanoidRootPart") 
                        or currentTarget:FindFirstChild("Torso") 
                        or currentTarget:FindFirstChild("Root") 
                        or currentTarget.PrimaryPart
                        
        if not monsterHRP then continue end
        
        local monsterPos = monsterHRP.Position
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        -- SPOOFING ORIGIN (POINT-BLANK)
        local fakeOriginPos = monsterPos + Vector3.new(0, 0, 1) 
        
        local releaseCF = CFrame.lookAt(fakeOriginPos, monsterPos)
        local targetCF = CFrame.new(monsterPos) * releaseCF.Rotation
        
        -- 1. BASIC ATTACK SELALU DI-FIRE (Slot 4)
        local args = {
            [1] = 4,
            [2] = {
                ["targetCF"] = targetCF,
                ["moveDirectionStr"] = "Forward",
                ["clientPredictCastId"] = HttpService:GenerateGUID(false),
                ["characterType"] = "Player",
                ["releaseCF"] = releaseCF, 
                ["characterId"] = player.UserId,
                ["trackTargetId"] = currentTarget.Name 
            }
        }
        
        pcall(function() releaseGroupSkillEvent:FireServer(unpack(args)) end)
        
        -- 2. AUTO SKILL (HANYA KETIKA READY / COOLDOWN SELESAI)
        if getgenv().AutoSkill then
            local now = os.clock()
            
            if now - lastSkill1 >= cdSkill1 then
                args[1] = 1
                pcall(function() releaseGroupSkillEvent:FireServer(unpack(args)) end)
                lastSkill1 = now
            end
            
            if now - lastSkill2 >= cdSkill2 then
                args[1] = 2
                pcall(function() releaseGroupSkillEvent:FireServer(unpack(args)) end)
                lastSkill2 = now
            end
        end
    end
end)

-- ============================================================
-- 4. LOGIKA AUTO COLLECT DROPS (MAGNET)
-- ============================================================
task.spawn(function()
    while task.wait(0.2) do
        if not getgenv().AutoCollect then continue end
        local dropsFolder = workspace:FindFirstChild("Drops")
        if dropsFolder then
            local myDrops = dropsFolder:FindFirstChild(tostring(player.UserId))
            if myDrops then
                for _, dropValue in ipairs(myDrops:GetChildren()) do
                    if dropValue:IsA("Vector3Value") then
                        pcall(function() generalRemoteEvent:FireServer("pick", dropValue.Name) end)
                    end
                end
            end
        end
    end
end)

-- ============================================================
-- 5. UI UNLOCKER (Prevent game UI from blocking AFK brew/fuse)
-- ============================================================
task.spawn(function()
    pcall(function()
        local MatChoose = require(ReplicatedStorage.GuiScripts.ModuleScript.MaterialChoose)
        if type(MatChoose.openUi) == "function" and not MatChoose._napoleonHooked then
            local oldOpen = MatChoose.openUi
            MatChoose.openUi = function(self, ...)
                if getgenv().AutoBrew or getgenv().AutoFusePotions then return end
                return oldOpen(self, ...)
            end
            MatChoose._napoleonHooked = true
        end
    end)

    pcall(function()
        local PotionGame = require(ReplicatedStorage.GuiScripts.ModuleScript.PotionBrewingGame)
        if type(PotionGame.openUi) == "function" and not PotionGame._napoleonHooked then
            local oldOpen = PotionGame.openUi
            PotionGame.openUi = function(self, ...)
                if getgenv().AutoBrew or getgenv().AutoFusePotions then return end
                return oldOpen(self, ...)
            end
            PotionGame._napoleonHooked = true
        end
    end)

    pcall(function()
        local PotionFuse = require(ReplicatedStorage.GuiScripts.ModuleScript.PotionFuse)
        if type(PotionFuse.openUi) == "function" and not PotionFuse._napoleonHooked then
            local oldOpen = PotionFuse.openUi
            PotionFuse.openUi = function(self, ...)
                if getgenv().AutoBrew or getgenv().AutoFusePotions then return end
                return oldOpen(self, ...)
            end
            PotionFuse._napoleonHooked = true
        end
    end)

    while task.wait(0.5) do
        if getgenv().AutoBrew or getgenv().AutoFusePotions then
            pcall(function()
                if UtilsSystem and UtilsSystem.UIMgr then
                    UtilsSystem.UIMgr.SetMainUIVisible(true)
                    UtilsSystem.UIMgr.SetMainToolsVisible(true)
                    UtilsSystem.UIMgr.ShowMovieBlack(false)
                    UtilsSystem.UIMgr.ShowChooseBlackGui(false)
                end
                player:SetAttribute("RUN_STATE", true)
            end)
        end
    end
end)

-- ============================================================
-- 6. LOGIKA SMART AUTO BREW (AFK)
-- ============================================================
task.spawn(function()
    local BREW_CAULDRON_ID = 8000001
    local BREW_AMOUNT = 5

    while task.wait(2) do
        if not getgenv().AutoBrew then continue end
        pcall(function()
            if type(getgenv().SelectedBrewMaterials) ~= "table" then return end

            local bagData = PlayerData.GetPlrDataByKey(player, "Bag")
            if type(bagData) ~= "table" then return end

            local bagCounts = {}
            for uniqueID, item in pairs(bagData) do
                if type(item) == "table" and item.id then
                    local amt = tonumber(item.num) or tonumber(item.count) or tonumber(item.amount) or 0
                    local idNum = tonumber(item.id)
                    if idNum and tonumber(item.tp) == EnumMgr.ItemType.Material then
                        bagCounts[idNum] = (bagCounts[idNum] or 0) + amt
                    end
                end
            end

            for k, v in pairs(getgenv().SelectedBrewMaterials) do
                local matName = type(v) == "string" and v or k
                local staticID = TranslatedNameToIdMap[matName]

                if staticID then
                    local currentCount = bagCounts[staticID] or 0
                    if currentCount >= BREW_AMOUNT then
                        getgenv().IsBrewingTaskRunning = true

                        task.spawn(function()
                            pcall(function()
                                remoteFunction:InvokeServer(
                                    "\xE7\x82\xBC\xE8\x8D\xAF\xE6\xB8\xB8\xE6\x88\x8F\xE5\xBC\x80\xE5\xA7\x8B",
                                    { cauldronID = BREW_CAULDRON_ID, materials = { [staticID] = BREW_AMOUNT } }
                                )
                            end)

                            task.wait(0.2)

                            pcall(function()
                                remoteFunction:InvokeServer("\xE7\x82\xBC\xE8\x8D\xAF", { gameScore = 100 })
                            end)

                            task.wait(0.3)
                            getgenv().IsBrewingTaskRunning = false
                        end)

                        task.wait(1.5)
                        break
                    end
                end
            end
        end)
    end
end)

-- ============================================================
-- 7. LOGIKA AUTO POTION FUSE (DYNAMIC TIER DETECTION)
-- ============================================================
task.spawn(function()
    while task.wait(3.5) do
        if not getgenv().AutoFusePotions then continue end
        pcall(function()
            local bagData = PlayerData.GetPlrDataByKey(player, "Bag")
            if type(bagData) ~= "table" then return end

            local potionGroups = {}

            for uniqueID, item in pairs(bagData) do
                if type(item) == "table" and item.id then
                    local itemType = tonumber(item.tp)

                    if itemType == EnumMgr.ItemType.Potion then
                        local mpTp = item.mpTp

                        -- Abaikan potion di tier maksimal (SSS)
                        if type(mpTp) == "string" and string.upper(mpTp) == "SSS" then
                            continue
                        end

                        local groupKey = tostring(item.id) .. "_" .. tostring(mpTp)
                        local dynamicID = item.onlyID or tonumber(uniqueID) or uniqueID

                        if groupKey and dynamicID then
                            if not potionGroups[groupKey] then
                                potionGroups[groupKey] = { sampleItem = item, ids = {} }
                            end
                            table.insert(potionGroups[groupKey].ids, dynamicID)
                        end
                    end
                end
            end

            for groupKey, group in pairs(potionGroups) do
                -- Default fallback: butuh 3 potion untuk fuse
                local TARGET_AMOUNT = 3

                pcall(function()
                    local GetData = UtilsSystem.GetData
                    if GetData and GetData.GetPotionUpgradeNeedCount then
                        local required = GetData.GetPotionUpgradeNeedCount(group.sampleItem)
                        if required and type(required) == "number" and required > 0 then
                            TARGET_AMOUNT = required
                        end
                    end
                end)

                if #group.ids >= TARGET_AMOUNT then
                    getgenv().IsBrewingTaskRunning = true

                    local fusePayload = {}
                    for i = 1, TARGET_AMOUNT do
                        table.insert(fusePayload, group.ids[i])
                    end

                    task.spawn(function()
                        pcall(function()
                            remoteFunction:InvokeServer(
                                "\xE8\x8D\xAF\xE6\xB0\xB4\xE5\x90\x88\xE6\x88\x90",
                                { onlyIDs = fusePayload }
                            )
                        end)

                        task.wait(0.5)
                        getgenv().IsBrewingTaskRunning = false
                    end)

                    task.wait(1.5)
                    break
                end
            end
        end)
    end
end)

-- ============================================================
local function autoSellProcess()
    local bagData = PlayerData.GetPlrDataByKey(player, "Bag")
    if not bagData or type(bagData) ~= "table" then return end
    
    local idsToSell = {}
    local countsToSell = {}
    local isBrewingNow = getgenv().IsBrewingTaskRunning
    
    for uniqueID, item in pairs(bagData) do
        if type(item) == "table" and item.id then
            local itemQty = tonumber(item.num) or tonumber(item.count) or tonumber(item.amount) or 0
            if itemQty > 0 then
                -- Ambil nama dari map yang sudah dibangun saat startup (lebih andal)
                local rawName = IdToTranslatedMap[tostring(item.id)]
                
                -- Fallback: cari lewat database jika tidak ada di map
                if not rawName then
                    pcall(function()
                        local cfg = CfgFind.FindCfgByID(item.id, item.tp)
                            or CfgFind.FindCfgByID(item.id, EnumMgr.ItemType.Potion)
                        if cfg and cfg.ZhName and LanguageCfg then
                            rawName = LanguageCfg.FormatByKey(cfg.ZhName)
                        end
                    end)
                end
                
                if rawName then
                    -- Material: cocokkan nama yang di-strip (tanpa kata Potion)
                    local strippedName = string.gsub(rawName, "%s*[Pp]otion", "")
                    local isMaterial = getgenv().SelectedMaterialsToSell and table.find(getgenv().SelectedMaterialsToSell, strippedName)
                    
                    -- Potion: cocokkan nama asli (ada kata Potion), skip jika sedang brewing
                    local isPotion = false
                    if not isBrewingNow then
                        isPotion = getgenv().SelectedPotionsToSell and table.find(getgenv().SelectedPotionsToSell, rawName)
                    end
                    
                    if isMaterial or isPotion then
                        local dynamicID = item.onlyID or tonumber(uniqueID) or uniqueID
                        local sellQty = getgenv().SellAmount or 0
                        if sellQty == 0 or sellQty > itemQty then
                            sellQty = itemQty
                        end
                        table.insert(idsToSell, dynamicID)
                        table.insert(countsToSell, sellQty)
                    end
                end
            end
        end
    end
    
    if #idsToSell > 0 then
        task.spawn(function()
            pcall(function()
                remoteFunction:InvokeServer("\xE5\x87\xBA\xE5\x94\xAE\xE8\x83\x8C\xE5\x8C\x85\xE7\x89\xA9\xE5\x93\x81", {
                    ["onlyIDList"] = idsToSell,
                    ["countList"] = countsToSell
                })
            end)
        end)
    end
end

local function autoFavoriteProcess()
    local bagData = PlayerData.GetPlrDataByKey(player, "Bag")
    if not bagData or type(bagData) ~= "table" then return end
    
    for uniqueID, item in pairs(bagData) do
        if type(item) == "table" and tonumber(item.isLock) ~= 1 and tonumber(item.lock) ~= 1 and item.isLock ~= true then
            local itemCfg = CfgFind.FindCfgByID(item.id, item.tp)
            if itemCfg and itemCfg.ZhName then
                local tName = nil
                pcall(function() if LanguageCfg then tName = LanguageCfg.FormatByKey(itemCfg.ZhName) end end)
                if tName then
                    tName = string.gsub(tName, "%s*[Pp]otion", "")
                    
                    local tierVal = item.tier or item.grade or item.quality or item.refine or item.star or item.step or item.refineLevel or item.refineLv or item.purity
                    local qualityStr = ""
                    if tierVal then qualityStr = " <" .. tostring(tierVal) .. ">" end
                    
                    local inventoryString = tName .. qualityStr
                    local isMatched = false
                    
                    if getgenv().SelectedMaterialsToFav then
                        for _, selName in ipairs(getgenv().SelectedMaterialsToFav) do
                            local baseSelName = string.gsub(selName, " %[%d+x%]$", "")
                            if baseSelName == inventoryString then
                                isMatched = true break
                            end
                        end
                    end
                    
                    if not isMatched and getgenv().SelectedPotionsToFav then
                        for _, selName in ipairs(getgenv().SelectedPotionsToFav) do
                            local baseSelName = string.gsub(selName, " %[%d+x%]$", "")
                            if baseSelName == inventoryString then
                                isMatched = true break
                            end
                        end
                    end
                    
                    if isMatched then
                        local dynamicID = item.onlyID or tonumber(uniqueID) or uniqueID
                        item.isLock = 1 -- Optimistic lock agar tidak spamming loop
                        task.spawn(function()
                            pcall(function()
                                generalRemoteEvent:FireServer("\xE9\x94\x81\xE5\xAE\x9A\xE7\x89\xA9\xE5\x93\x81", {
                                    isLock = 1,
                                    onlyID = dynamicID
                                })
                            end)
                        end)
                    end
                end
            end
        end
    end
end

task.spawn(function()
    while task.wait(1) do -- DIPERCEPAT: Mengecek ransel setiap 1 detik
        if getgenv().AutoSell then
            -- Mencegah error crash jika fungsi autoSellProcess gagal
            pcall(function()
                autoSellProcess()
            end)
        end
        
        if getgenv().AutoFavorite then
            pcall(function()
                autoFavoriteProcess()
            end)
        end
        
        if getgenv().AutoRefreshGuide then
            pcall(function()
                -- Format Hex yang aman sesuai tangkapan Cobalt
                generalRemoteEvent:FireServer("\xE5\x88\xB7\xE6\x96\xB0\xE5\xBC\x95\xE5\xAF\xBC")
            end)
        end
    end
end)

-- ============================================================
-- 6. SMART AUTO BREW (AFK) - SOLUSI 100% PURITY FIXED!
-- ============================================================
task.spawn(function()
    local BREW_CAULDRON_ID = 8000001
    local BREW_AMOUNT = 5

    while task.wait(2) do
        if not getgenv().AutoBrew then continue end
        pcall(function()
            if type(getgenv().SelectedBrewMaterials) ~= "table" then return end

            local bagData = PlayerData.GetPlrDataByKey(player, "Bag")
            if type(bagData) ~= "table" then return end

            local bagCounts = {}
            for uniqueID, item in pairs(bagData) do
                if type(item) == "table" and item.id then
                    local amt = tonumber(item.num) or tonumber(item.count) or tonumber(item.amount) or 0
                    local idNum = tonumber(item.id)
                    if idNum and tonumber(item.tp) == EnumMgr.ItemType.Material then
                        bagCounts[idNum] = (bagCounts[idNum] or 0) + amt
                    end
                end
            end

            for k, v in pairs(getgenv().SelectedBrewMaterials) do
                local matName = type(v) == "string" and v or k
                local staticID = TranslatedNameToIdMap[matName]

                if staticID then
                    local currentCount = bagCounts[staticID] or 0
                    if currentCount >= BREW_AMOUNT then
                        getgenv().IsBrewingTaskRunning = true

                        -- Bikin payload materials yang valid sesuai kebutuhan server
                        local materialPayload = { [staticID] = BREW_AMOUNT }

                        task.spawn(function()
                            -- STEP 1: Mulai Minigame Alkimia
                            pcall(function()
                                remoteFunction:InvokeServer(
                                    "\xE7\x82\xBC\xE8\x8D\xAF\xE6\xB8\xB8\xE6\x88\x8F\xE5\xBC\x80\xE5\xA7\x8B",
                                    { cauldronID = BREW_CAULDRON_ID, materials = materialPayload }
                                )
                            end)

                            task.wait(0.3) -- Jeda tipis memberikan waktu server sinkronisasi paket

                            -- STEP 2: Kirim Hasil Akhir Lengkap (Duplikasi data agar tembus Validasi Server 100% Purity)
                            pcall(function()
                                remoteFunction:InvokeServer(
                                    "\xE7\x82\xBC\xE8\x8D\xAF", 
                                    { 
                                        cauldronID = BREW_CAULDRON_ID,
                                        materials = materialPayload,
                                        gameScore = 100 
                                    }
                                )
                            end)

                            task.wait(0.3)
                            getgenv().IsBrewingTaskRunning = false
                        end)

                        task.wait(1.5)
                        break
                    end
                end
            end
        end)
    end
end)

-- ============================================================
-- 7. LOGIKA AUTO UPDATE STATS
-- ============================================================
task.spawn(function()
    local StatToAttrMap = {
        ["Attack"] = 1,
        ["HP"] = 5,
        ["Cooling Reduction"] = 39,
        ["Movement Speed"] = 41
    }
    
    while task.wait(3) do
        if getgenv().AutoStats and getgenv().SelectedStats and #getgenv().SelectedStats > 0 then
            pcall(function()
                for _, statName in ipairs(getgenv().SelectedStats) do
                    local attrId = StatToAttrMap[statName]
                    if attrId then
                        local args = {
                            [1] = "\229\177\158\230\128\167\229\138\160\231\130\185",
                            [2] = {
                                ["AttrTp"] = attrId,
                                ["PointNum"] = 1
                            }
                        }
                        remoteFunction:InvokeServer(unpack(args))
                        task.wait(0.1) -- Jeda kecil per stat agar aman
                    end
                end
            end)
        end
    end
end)

-- ============================================================
-- 8. INFINITE ZOOM OUT (AUTO AKTIF)
-- ============================================================
task.spawn(function()
    pcall(function()
        if player then
            player.CameraMaxZoomDistance = 99999
        end
    end)
end)
