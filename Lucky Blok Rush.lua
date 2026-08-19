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

--     local KataTerlarang = {"hydroxide", "turtle spy", "cobalt", "bypasser", "remote spy", "simple spy", "ultimate debugging suite", "dark dex"}
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
-- KEY SYSTEM & TRACKING
-- ============================================================

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
--         local logPath = "Napoleon_SlimeRNG_LastExec.txt"
        
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
--                 .. "?script=Lucky-Blok-Rush"
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
-- Napoleon | Lucky Blok Rush
-- ============================================================
_G.ScriptFullyLoaded = false

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Fdhlnn23/NapoleonUI/refs/heads/main/NPLN-UIv2.lua"))()

local ICON_ID = "96531489912535"

local function notif(content, duration, title)
    if not _G.ScriptFullyLoaded then return end
    if Library and Library.MakeNotify then
        Library:MakeNotify({
            Title   = title or "Napoleon",
            Content = content,
            Delay   = duration or 4,
            Icon    = "rbxassetid://" .. ICON_ID
        })
    end
end

-- ============================================================
-- SERVICES
-- ============================================================
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser       = game:GetService("VirtualUser")
local RunService        = game:GetService("RunService")
local Lighting          = game:GetService("Lighting")
local Terrain           = workspace:FindFirstChildOfClass("Terrain")

local LocalPlayer     = Players.LocalPlayer
local saverConnection = nil
local blackScreenGui  = nil

-- ============================================================
-- ANTI-AFK
-- ============================================================
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ============================================================
-- WINDOW UI
-- ============================================================
local Window = Library:Window({
    Title    = "Napoleon",
    Footer   = "Lucky Blok Rush",
    Color    = Color3.fromRGB(255, 255, 255),
    Color2   = Color3.fromRGB(192, 192, 192),
    ["Tab Width"] = 130,
    Image      = "136289055140268",
    WindowIMG  = "93732999692312",
    LogoHUB    = "136289055140268"
})
local Tabs = Window

-- ============================================================
-- TAB: INFO
-- ============================================================
local function LoadInfoTab()
    local InfoTab = Tabs:AddTab({ Name = "Info", Icon = "info" })
    local InfoSection = InfoTab:AddSection("Napoleon — Lucky Blok Rush", true)

    InfoSection:AddParagraph({
        Title   = "📋 Script Info",
        Content = "Script Napoleon untuk game Lucky Blok Rush."
    })

    InfoSection:AddButton({
        Title    = "Join Discord",
        Callback = function()
            if setclipboard then
                setclipboard("https://discord.gg/RKaZ9vEbpb")
                notif("Discord link disalin!", 3, "Napoleon")
            else
                notif("Join manual: discord.gg/RKaZ9vEbpb", 5, "Napoleon")
            end
        end
    })
end

-- ============================================================
-- TAB: MAIN
-- ============================================================
local autoStartEnabled = false
local stopAtBossName = "None (Infinite)"
local AutoFarmToggle = nil

local function LoadMainTab()
    local MainTab = Tabs:AddTab({ Name = "Main", Icon = "rod" })
    
    local FarmSection = MainTab:AddSection("Auto Farm")
    AutoFarmToggle = FarmSection:AddToggle({
        Title    = "Auto Start Fight",
        Title2   = "Enable",
        Content  = "Otomatis memanggil boss dan masuk ke mode pertarungan",
        Default  = false,
        Callback = function(val)
            autoStartEnabled = val
            if val then
                notif("Auto Start Fight ON", 3, "Auto Farm")
                
                -- [BYPASS CUTSCENE ANIMATION]
                pcall(function()
                    local StarDropSystem = require(game:GetService("ReplicatedStorage"):WaitForChild("GameShared"):WaitForChild("StarDropSystem"))
                    if not StarDropSystem._oldPlaySequence then
                        StarDropSystem._oldPlaySequence = StarDropSystem.PlaySequence
                    end
                    -- Timpa fungsinya jadi kosong (bypass instant)
                    StarDropSystem.PlaySequence = function() end
                end)
                
                task.spawn(function()
                    local success, err = pcall(function()
                        local Knit = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"))
                        local CombatController = Knit.GetController("CombatController")
                        
                        -- Loop 1: Auto Start Fight
                        task.spawn(function()
                            local lastCombatEnd = 0
                            while autoStartEnabled do
                                local inCombat = LocalPlayer:GetAttribute("InCombat")
                                
                                if inCombat then
                                    lastCombatEnd = tick()
                                else
                                    -- Langsung mulai jika ini eksekusi pertama, atau tunggu 3.5s setelah fight terakhir
                                    if tick() - lastCombatEnd >= 3.5 then
                                        pcall(function() CombatController:Start() end)
                                    end
                                end
                                task.wait(0.5)
                            end
                        end)
                        
                        -- Loop 2: Auto Attack & Anti-Damage (Float)
                        task.spawn(function()
                            local currentBoss = nil
                            local currentBossName = ""
                            
                            while autoStartEnabled do
                                if LocalPlayer:GetAttribute("InCombat") then
                                    -- 1. Auto Attack (Fast Bypass)
                                    pcall(function() CombatController:AttackBoss() end)
                                    
                                    -- 2. Teleport & Float di Atas Boss (Tanpa Gerak-Gerak)
                                    pcall(function()
                                        local char = LocalPlayer.Character
                                        if char and char:FindFirstChild("HumanoidRootPart") then
                                            local hrp = char.HumanoidRootPart
                                            
                                            -- Cari Boss (hanya saat belum punya target atau target mati)
                                            if not currentBoss or not currentBoss.Parent or not currentBoss:FindFirstChild("Humanoid") or currentBoss.Humanoid.Health <= 0 then
                                                -- Cek apakah boss sebelumnya yang mati adalah target kita
                                                if currentBossName ~= "" and stopAtBossName ~= "None (Infinite)" then
                                                    if currentBossName == stopAtBossName or currentBossName:match(stopAtBossName) then
                                                        notif("Target Boss [" .. stopAtBossName .. "] Terkalahkan! Auto Claim Reward...", 4, "Auto Farm")
                                                        
                                                        -- PENTING: Hapus platform & reset target DULU sebelum Finish()
                                                        -- supaya TeleportToPlot() dari game tidak dilawan tether!
                                                        currentBoss = nil
                                                        currentBossName = ""
                                                        local platToRemove = workspace:FindFirstChild("AutoFarmPlatform")
                                                        if platToRemove then platToRemove:Destroy() end
                                                        
                                                        -- Pastikan player tidak lagi terikat tether sebelum finish
                                                        if char and char:FindFirstChild("HumanoidRootPart") then
                                                            char.HumanoidRootPart.Anchored = false
                                                        end
                                                        
                                                        task.wait(0.3) -- beri waktu platform hilang dan tether berhenti
                                                        
                                                        -- Baru panggil Finish untuk claim reward
                                                        pcall(function() CombatController:Finish() end)
                                                        -- Loop 1 akan otomatis 'Start()' lagi setelah 3.5 detik!
                                                        return -- Keluar dari pcall supaya tether gak kepanggil lagi
                                                    end
                                                end
                                                
                                                currentBoss = nil
                                                currentBossName = ""
                                                local minDistance = 300
                                                
                                                for _, obj in ipairs(workspace:GetDescendants()) do
                                                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Name ~= LocalPlayer.Name then
                                                        if not game.Players:GetPlayerFromCharacter(obj) then
                                                            local root = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                                                            if root then
                                                                local dist = (root.Position - hrp.Position).Magnitude
                                                                if dist < minDistance then
                                                                    minDistance = dist
                                                                    currentBoss = obj
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                                
                                                if currentBoss then
                                                    currentBossName = currentBoss:GetAttribute("HpName") or currentBoss.Name
                                                end
                                            end
                                            
                                            -- Bikin platform raksasa dan pasang tether (tali pengaman) ke player
                                            if currentBoss then
                                                local bossRoot = currentBoss:FindFirstChild("HumanoidRootPart") or currentBoss.PrimaryPart
                                                if bossRoot then
                                                    local plat = workspace:FindFirstChild("AutoFarmPlatform")
                                                    if not plat then
                                                        plat = Instance.new("Part")
                                                        plat.Name = "AutoFarmPlatform"
                                                        -- Ukuran raksasa biar bisa lari-lari bebas di langit!
                                                        plat.Size = Vector3.new(1500, 2, 1500) 
                                                        plat.Anchored = true
                                                        plat.Transparency = 1
                                                        plat.CanCollide = true
                                                        plat.Parent = workspace
                                                    end
                                                    
                                                    -- Platform terus ngikutin boss dari atas
                                                    plat.CFrame = bossRoot.CFrame * CFrame.new(0, 16, 0)
                                                    
                                                    -- Tether: Kalau player iseng lompat keluar atau jatuh, tarik balik ke atas kepala boss!
                                                    if math.abs(hrp.Position.Y - plat.Position.Y) > 15 then
                                                        hrp.CFrame = plat.CFrame * CFrame.new(0, 3, 0)
                                                        hrp.Anchored = true
                                                        task.wait(0.05)
                                                        hrp.Anchored = false
                                                    end
                                                end
                                            else
                                                -- Jika boss tidak ada, bersihkan platform agar player turun ke arena
                                                local plat = workspace:FindFirstChild("AutoFarmPlatform")
                                                if plat then plat:Destroy() end
                                            end
                                        end
                                    end)
                                else
                                    -- Reset boss target & hapus platform kalau pertarungan selesai
                                    currentBoss = nil
                                    local plat = workspace:FindFirstChild("AutoFarmPlatform")
                                    if plat then plat:Destroy() end
                                end
                                -- Disesuaikan dengan batas maksimal server (0.225s) agar tidak spam remote sia-sia
                                task.wait(0.22)
                            end
                        end)
                    end)
                    
                    if not success then
                        notif("Knit Error: " .. tostring(err), 7, "Debug")
                        autoStartEnabled = false
                    end
                end)
            else
                notif("Auto Start Fight OFF", 3, "Auto Farm")
                
                -- Hapus platform ketika fitur dimatikan
                pcall(function()
                    local plat = workspace:FindFirstChild("AutoFarmPlatform")
                    if plat then plat:Destroy() end
                end)
                
                -- Kembalikan fungsi animasi aslinya
                pcall(function()
                    local StarDropSystem = require(game:GetService("ReplicatedStorage"):WaitForChild("GameShared"):WaitForChild("StarDropSystem"))
                    if StarDropSystem._oldPlaySequence then
                        StarDropSystem.PlaySequence = StarDropSystem._oldPlaySequence
                    end
                end)
            end
        end
    })

    FarmSection:AddDropdown({
        Title   = "Auto Finish At Boss",
        Content = "Otomatis Finish (Claim Reward) jika boss ini dikalahkan, lalu mengulang farm",
        Options = {
            "None (Infinite)", "Noob", "Thief", "Knight", "Void Solider", "Knightmare",
            "Greenwarden", "THE KING", "Cactus Boy", "Imp", "Anubis", "Dark Mage", "Ascended",
            "Mecha Knight", "1x1x1x1", "Aharoni", "Snowman", "Evil Elf", "Mad Marshmallow",
            "Frost Knight", "Gingerbread", "CRAZY SANTA"
        },
        Default = "None (Infinite)",
        Callback = function(val)
            stopAtBossName = val
        end
    })

    local ExploitSection = MainTab:AddSection("Exploit")

    -- ============================================================
    -- EXPLOIT 1: x2 Train Speed (CONFIRMED WORK)
    -- ============================================================
    ExploitSection:AddToggle({
        Title    = "x2 Train Speed",
        Title2   = "Enable",
        Content  = "Inject X2_TRAIN_SPEED → cooldown training jadi 0.125s",
        Default  = false,
        Callback = function(val)
            local ActiveEvents = game:GetService("ReplicatedStorage"):FindFirstChild("ActiveEvents")
            if not ActiveEvents then notif("ActiveEvents tidak ditemukan!", 4, "Exploit") return end
            if val then
                pcall(function()
                    if not ActiveEvents:FindFirstChild("X2_TRAIN_SPEED") then
                        local ev = Instance.new("StringValue")
                        ev.Name  = "X2_TRAIN_SPEED"
                        ev.Value = "X2_TRAIN_SPEED"
                        ev.Parent = ActiveEvents
                    end
                end)
                notif("x2 Train Speed AKTIF! Cooldown: 0.125s", 4, "Exploit")
            else
                pcall(function()
                    local ev = ActiveEvents:FindFirstChild("X2_TRAIN_SPEED")
                    if ev and ev:IsA("StringValue") then ev:Destroy() end
                end)
                notif("x2 Train Speed OFF", 3, "Exploit")
            end
        end
    })

    -- ============================================================
    -- EXPLOIT 2: x4 Train Speed
    -- ============================================================
    ExploitSection:AddToggle({
        Title    = "x4 Train Speed",
        Title2   = "Enable",
        Content  = "Inject X4_TRAIN_SPEED",
        Default  = false,
        Callback = function(val)
            local ActiveEvents = game:GetService("ReplicatedStorage"):FindFirstChild("ActiveEvents")
            if not ActiveEvents then notif("ActiveEvents tidak ditemukan!", 4, "Exploit") return end
            if val then
                pcall(function()
                    if not ActiveEvents:FindFirstChild("X4_TRAIN_SPEED") then
                        local ev = Instance.new("StringValue")
                        ev.Name  = "X4_TRAIN_SPEED"
                        ev.Value = "X4_TRAIN_SPEED"
                        ev.Parent = ActiveEvents
                    end
                end)
                notif("x4 Train Speed AKTIF!", 4, "Exploit")
            else
                pcall(function()
                    local ev = ActiveEvents:FindFirstChild("X4_TRAIN_SPEED")
                    if ev and ev:IsA("StringValue") then ev:Destroy() end
                end)
                notif("x4 Train Speed OFF", 3, "Exploit")
            end
        end
    })

    -- ============================================================
    -- EXPLOIT 3: x10 Train Speed
    -- ============================================================
    ExploitSection:AddToggle({
        Title    = "x10 Train Speed",
        Title2   = "Enable",
        Content  = "Inject X10_TRAIN_SPEED (Maksimal)",
        Default  = false,
        Callback = function(val)
            local ActiveEvents = game:GetService("ReplicatedStorage"):FindFirstChild("ActiveEvents")
            if not ActiveEvents then notif("ActiveEvents tidak ditemukan!", 4, "Exploit") return end
            if val then
                pcall(function()
                    if not ActiveEvents:FindFirstChild("X10_TRAIN_SPEED") then
                        local ev = Instance.new("StringValue")
                        ev.Name  = "X10_TRAIN_SPEED"
                        ev.Value = "X10_TRAIN_SPEED"
                        ev.Parent = ActiveEvents
                    end
                end)
                notif("x10 Train Speed AKTIF!", 4, "Exploit")
            else
                pcall(function()
                    local ev = ActiveEvents:FindFirstChild("X10_TRAIN_SPEED")
                    if ev and ev:IsA("StringValue") then ev:Destroy() end
                end)
                notif("x10 Train Speed OFF", 3, "Exploit")
            end
        end
    })

    -- ============================================================
    -- EXPLOIT 4: Damage Boost Event
    -- ============================================================
    ExploitSection:AddToggle({
        Title    = "x1.25 Damage Boost",
        Title2   = "Enable",
        Content  = "Inject DAMAGE_EVENT → +25% Damage ke Boss",
        Default  = false,
        Callback = function(val)
            local ActiveEvents = game:GetService("ReplicatedStorage"):FindFirstChild("ActiveEvents")
            if not ActiveEvents then notif("ActiveEvents tidak ditemukan!", 4, "Exploit") return end
            if val then
                pcall(function()
                    if not ActiveEvents:FindFirstChild("DAMAGE_EVENT") then
                        local ev = Instance.new("StringValue")
                        ev.Name  = "DAMAGE_EVENT"
                        ev.Value = "DAMAGE_EVENT"
                        ev.Parent = ActiveEvents
                    end
                end)
                notif("Damage Boost AKTIF!", 4, "Exploit")
            else
                pcall(function()
                    local ev = ActiveEvents:FindFirstChild("DAMAGE_EVENT")
                    if ev and ev:IsA("StringValue") then ev:Destroy() end
                end)
                notif("Damage Boost OFF", 3, "Exploit")
            end
        end
    })
end

-- ============================================================
-- TAB: MISCELLANEOUS
-- ============================================================
local autoX2SpeedEnabled = false
local currentBonusId = nil

-- Setup Knit listener untuk menangkap bonus yang spawn
task.spawn(function()
    pcall(function()
        local Knit = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"))
        local TrainingService = Knit.GetService("TrainingService")
        
        TrainingService.SpawnBonus:Connect(function(bonusId)
            currentBonusId = bonusId
            if autoX2SpeedEnabled and currentBonusId then
                task.spawn(function()
                    pcall(function()
                        TrainingService:ClaimBonus(currentBonusId)
                        currentBonusId = nil
                        
                        -- Sembunyikan UI manual biar ga nyangkut di layar
                        local btn = LocalPlayer.PlayerGui:FindFirstChild("SpeedEffect")
                        if btn then
                            local x2Btn = btn:FindFirstChild("x2Speed", true)
                            if x2Btn then x2Btn.Visible = false end
                        end
                    end)
                end)
            end
        end)
    end)
end)

local function LoadMiscTab()
    local MiscTab = Tabs:AddTab({ Name = "Miscellaneous", Icon = "rod" })

    -- [ Auto x2 Speed ]
    local SpeedSection = MiscTab:AddSection("Speed Booster")
    SpeedSection:AddToggle({
        Title    = "Auto x2 Speed",
        Title2   = "Enable",
        Content  = "Otomatis mengklaim x2 Speed bonus (via Knit API)",
        Default  = false,
        Callback = function(val)
            autoX2SpeedEnabled = val
            if val then
                notif("Auto x2 Speed ON", 3, "Speed")
                -- Jika ada bonus yang sudah muncul sebelum toggle diaktifkan
                if currentBonusId then
                    task.spawn(function()
                        pcall(function()
                            local Knit = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"))
                            local TrainingService = Knit.GetService("TrainingService")
                            TrainingService:ClaimBonus(currentBonusId)
                            currentBonusId = nil
                            
                            local btn = LocalPlayer.PlayerGui:FindFirstChild("SpeedEffect")
                            if btn then
                                local x2Btn = btn:FindFirstChild("x2Speed", true)
                                if x2Btn then x2Btn.Visible = false end
                            end
                        end)
                    end)
                end
            else
                notif("Auto x2 Speed OFF", 3, "Speed")
            end
        end
    })

    local antiAfkConnection = nil
    local SystemSection = MiscTab:AddSection("System")
    SystemSection:AddToggle({
        Title    = "Anti-AFK & Remove Reconnect",
        Title2   = "Enable",
        Content  = "Bypass 20 menit idle & Hapus AutoReconnect bawaan game",
        Default  = true, -- Auto nyala dari UI framework
        Callback = function(val)
            if val then
                notif("Anti-AFK & Reconnect Bypass ON", 3, "System")
                
                -- 1. Hapus Auto Reconnect bawaan game
                pcall(function()
                    local hud = LocalPlayer.PlayerGui:FindFirstChild("HUD")
                    if hud then
                        local autoRc = hud:FindFirstChild("AutoReconnect")
                        if autoRc then
                            local scriptRc = autoRc:FindFirstChild("AutoReconnectScript")
                            if scriptRc then
                                scriptRc.Disabled = true
                                scriptRc:Destroy()
                                notif("Auto Reconnect dihapus!", 3, "System")
                            end
                        end
                    end
                end)

                -- 2. Anti-AFK (Bypass Idled kick)
                if not antiAfkConnection then
                    antiAfkConnection = LocalPlayer.Idled:Connect(function()
                        local VirtualUser = game:GetService("VirtualUser")
                        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        task.wait(1)
                        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    end)
                end
            else
                notif("Anti-AFK OFF", 3, "System")
                if antiAfkConnection then
                    antiAfkConnection:Disconnect()
                    antiAfkConnection = nil
                end
            end
        end
    })
end

-- ============================================================
-- TAB: AUTO SELL
-- ============================================================
local autoSellEnabled  = false
local sellTargetType   = {"None"}
local sellTargetMut    = {"None"}
local sellTargetRarity = {"None"}

-- Build list dari Config game langsung
local listBrainrot = {"None", "All"}
local listMutasi   = {"None", "All", "Non-Mutasi"}
local listRarity   = {"None", "All"}

pcall(function()
    local RS = game:GetService("ReplicatedStorage")
    local BC = require(RS.Configs.BrainrotsConfig)
    local MC = require(RS.Configs.MutationConfig)

    local tB, tR, tM = {}, {}, {}
    for id, d in pairs(BC) do
        local displayId = string.gsub(id, "_", " ")
        if not table.find(tB, displayId) then table.insert(tB, displayId) end
        if d.rarity and not table.find(tR, d.rarity) then table.insert(tR, d.rarity) end
    end
    for _, d in pairs(MC) do
        local n = d.name or d.id
        if n and string.upper(n) ~= "NORMAL" and not table.find(tM, n) then
            table.insert(tM, n)
        end
    end
    table.sort(tB); table.sort(tR); table.sort(tM)
    for _, v in ipairs(tB) do
        if v ~= "None" and v ~= "All" then table.insert(listBrainrot, v) end
    end
    for _, v in ipairs(tR) do
        if v ~= "None" and v ~= "All" then table.insert(listRarity, v) end
    end
    for _, v in ipairs(tM) do
        if v ~= "None" and v ~= "All" then table.insert(listMutasi, v) end
    end
end)

local function LoadAutoTab()
    local AutoTab     = Tabs:AddTab({ Name = "Auto", Icon = "rod" })
    local SellSection = AutoTab:AddSection("Auto Sell Brainrot", false) -- false = auto terbuka
    SellSection:AddToggle({
        Title   = "Auto Sell Brainrot",
        Title2  = "Enable",
        Content = "Jual otomatis brainrot dari Backpack sesuai filter",
        Default = false,
        Callback = function(val)
            autoSellEnabled = val
            if not val then
                notif("Auto Sell OFF", 3, Color3.fromRGB(255, 100, 100))
                return
            end
            notif("Auto Sell ON", 3, Color3.fromRGB(100, 255, 100))
            task.spawn(function()
                -- Cari SellRF dengan robust
                local SellRF = nil
                local rfOk, rfErr = pcall(function()
                    SellRF = game:GetService("ReplicatedStorage")
                        .Packages._Index["sleitnick_knit@1.7.0"]
                        .knit.Services.InventoryService.RF.SellBrainrot
                end)
                if not rfOk or not SellRF then
                    SellRF = game:GetService("ReplicatedStorage"):FindFirstChild("SellBrainrot", true)
                end
                if not SellRF then
                    notif("ERROR: SellBrainrot RF tidak ditemukan! " .. tostring(rfErr), 6, Color3.fromRGB(255,0,0))
                    autoSellEnabled = false
                    return
                end

                local BC = require(game:GetService("ReplicatedStorage").Configs.BrainrotsConfig)
                
                local function hasTarget(arr, val)
                    -- Jika array kosong (tdk ada yg dipilih) ATAU ada None/All, anggap lolos filter
                    if type(arr) ~= "table" or #arr == 0 then return true end
                    if table.find(arr, "None") or table.find(arr, "All") then return true end
                    
                    local normVal = string.lower(string.gsub(val, "_", " "))
                    for _, v in ipairs(arr) do
                        local normV = string.lower(string.gsub(v, "_", " "))
                        if normV == normVal then return true end
                    end
                    return false
                end

                while autoSellEnabled do
                    -- SAFETY CHECK: Jika semua dropdown adalah "None" atau kosong, JANGAN jual apa-apa!
                    if (table.find(sellTargetType, "None") or #sellTargetType == 0) and
                       (table.find(sellTargetMut, "None") or #sellTargetMut == 0) and
                       (table.find(sellTargetRarity, "None") or #sellTargetRarity == 0) then
                        task.wait(1)
                        continue
                    end

                    local items = {}
                    local bp = LocalPlayer:FindFirstChild("Backpack")
                    if bp then
                        for _, t in ipairs(bp:GetChildren()) do
                            if t:IsA("Tool") then table.insert(items, t) end
                        end
                    end
                    local char = LocalPlayer.Character
                    if char then
                        for _, t in ipairs(char:GetChildren()) do
                            if t:IsA("Tool") then table.insert(items, t) end
                        end
                    end

                    for _, item in ipairs(items) do
                        if not autoSellEnabled then break end
                        local bType    = item:GetAttribute("BrainrotType")
                        local entityId = item:GetAttribute("EntityId")
                        if not bType or not entityId then continue end

                        local mutRaw  = item:GetAttribute("BrainrotMutation") or "NORMAL"
                        local mutNorm = (mutRaw == "NORMAL" or mutRaw == "") and "Non-Mutasi" or mutRaw
                        local cfg     = BC[bType]
                        local bRarity = cfg and cfg.rarity or ""

                        -- Cek array dengan helper hasTarget
                        local okType = hasTarget(sellTargetType, bType)
                        local okMut  = hasTarget(sellTargetMut, mutNorm)
                        local okRar  = hasTarget(sellTargetRarity, bRarity)

                        if okType and okMut and okRar then
                            local ok, err = pcall(function()
                                SellRF:InvokeServer(entityId)
                            end)
                            if ok then
                                notif("Sold: " .. bType, 2, Color3.fromRGB(100, 255, 150))
                            else
                                notif("Sell gagal: " .. tostring(err), 5, Color3.fromRGB(255, 80, 80))
                            end
                            task.wait(0.1)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    })

    local dropBrainrot, dropMut, dropRar

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
            dropObj:SetValue(arr)
        end
        
        return arr
    end

    -- Dropdown 1: Target Brainrot
    dropBrainrot = SellSection:AddDropdown({
        Title   = "Target Brainrot",
        Content = "Pilih ID brainrot yang dijual (None/All = skip filter ini)",
        Options = listBrainrot,
        Default = {"None"},
        Multi   = true,
        Callback = function(v) sellTargetType = handleDropdownChange(v, dropBrainrot) end
    })

    -- Dropdown 2: Target Mutasi
    dropMut = SellSection:AddDropdown({
        Title   = "Target Mutasi",
        Content = "Pilih mutasi, Non-Mutasi = NORMAL (None/All = skip filter ini)",
        Options = listMutasi,
        Default = {"None"},
        Multi   = true,
        Callback = function(v) sellTargetMut = handleDropdownChange(v, dropMut) end
    })

    -- Dropdown 3: Target Rarity
    dropRar = SellSection:AddDropdown({
        Title   = "Target Rarity",
        Content = "Pilih rarity yang dijual (None/All = skip filter ini)",
        Options = listRarity,
        Default = {"None"},
        Multi   = true,
        Callback = function(v) sellTargetRarity = handleDropdownChange(v, dropRar) end
    })

    -- Lakukan sinkronisasi awal untuk mengatasi config lama yang tersimpan
    task.spawn(function()
        task.wait(0.2)
        if dropBrainrot then sellTargetType = handleDropdownChange(sellTargetType, dropBrainrot) end
        if dropMut then sellTargetMut = handleDropdownChange(sellTargetMut, dropMut) end
        if dropRar then sellTargetRarity = handleDropdownChange(sellTargetRarity, dropRar) end
    end)
end

-- ============================================================
-- LOAD TABS
-- ============================================================
LoadInfoTab()
task.wait(0.05)
LoadMainTab()
task.wait(0.05)
LoadAutoTab()
task.wait(0.05)
LoadMiscTab()

-- ============================================================
-- FINISH
-- ============================================================
task.wait(1)
_G.ScriptFullyLoaded = true
notif("Script berhasil dimuat!", 5, "Napoleon")
