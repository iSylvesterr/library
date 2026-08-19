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
--                 .. "?script=slime-rng"
--                 .. "&userid=" .. userid
--                 .. "&username=" .. username
--                 .. "&executor=" .. (executor:gsub(" ", "%%20"))
--                 .. "&placeid=" .. placeid
--                 .. "&key=" .. key
                
--             game:HttpGet(url)
--         end
--     end)
-- end)

-- Lanjutkan ke script utama kamu di sini...

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- ============================================================
-- ULTIMATE ANTI AFK (FOOLPROOF)
-- ============================================================
task.spawn(function()
    pcall(function()
        -- Method 1: Disable connections (Works on PC executors like Synapse/KRNL)
        local getconns = getconnections or get_signal_cons
        if getconns then
            pcall(function()
                for _, conn in pairs(getconns(Players.LocalPlayer.Idled)) do
                    if type(conn) == "table" and conn.Disable then
                        conn:Disable()
                    elseif type(conn) == "table" and conn.Disconnect then
                        conn:Disconnect()
                    end
                end
            end)
        end
        
        -- Method 2 & 3: Simulate Activity (Works on Mobile/Delta/Fluxus)
        local VirtualUser = game:GetService("VirtualUser")
        local VirtualInputManager = game:GetService("VirtualInputManager")
        
        -- Hook to Idled just in case
        Players.LocalPlayer.Idled:Connect(function()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
            end)
        end)

        -- Method 4: ACTIVE BACKGROUND LOOP (Force activity every 5 mins)
        -- Ini mengatasi bug di mana executor Android tidak me-trigger signal "Idled" saat dilatarbelakangkan
        task.spawn(function()
            while true do
                task.wait(300) -- Setiap 5 Menit
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
                pcall(function()
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Unknown, false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Unknown, false, game)
                end)
            end
        end)
    end)
end)

-- ============================================================
-- UI LIBRARY INITIALIZATION
-- ============================================================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Fdhlnn23/NapoleonUI/refs/heads/main/NPLN-UIv2.lua"))()
local ICON_ID = "96531489912535"

_G.ScriptFullyLoaded = false

local function notif(content, duration, title)
    if not _G.ScriptFullyLoaded then return end
    if Library and Library.MakeNotify then
        Library:MakeNotify({ Title = title or "Napoleon", Content = content, Delay = duration or 4, Icon = "rbxassetid://" .. ICON_ID })
    end
end

-- ============================================================
-- VARIABLES & GAME MODULES
-- ============================================================
local LocalPlayer = Players.LocalPlayer

local autoRollEnabled = false
local rollMode = "Normal Roll"
local fastRollThreadCount = 5
local rollLoopThread = nil

local autoCollectEnabled = false
local autoCollectThread = nil

local autoRebirthEnabled = false
local autoRebirthThread = nil

local autoClaimIndexEnabled = false
local autoClaimIndexThread = nil

local autoAttackSlimeEnabled = false
local autoAttackSlimeThread = nil

local autoFarmZoneEnabled = false
local autoFarmZoneThread = nil

local autoEquipBestEnabled = false
local autoEquipBestThread = nil

local WebhookConfig = {
    EnableWebhook = false,
    WebhookURL = "",
    WebhookRarities = {"None"},
    WebhookMutations = {"None"}
}

-- Premium Stacker Variables (Smart Stacking)
local stackerEnabled = false
local stackerThread = nil
local stackerExecuting = false 
local targetGolden = true
local targetDiamond = true
local targetVoid = false
local selectedDice = "hugeDice"

-- Safe Cadence to prevent premature pausing
local SAFE_CADENCE = {
    golden = 8,
    diamond = 75,
    void = 900
}

local oldSetInstant = nil
local oldSetRollTable = nil
local oldErrorAdd = nil

-- Client Modules (Accessed via pcall for safety hook)
local FastRollRemote = nil
local DataServiceClient = nil
local RollServiceClient = nil
local InventoryServiceClient = nil
local RollSlice = nil
local ErrorMessages = nil
local RarityTiers = nil
local SlimeItems = nil

pcall(function()
    FastRollRemote = ReplicatedStorage:WaitForChild("Packages", 5):WaitForChild("_Index", 5):WaitForChild("leifstout_networker@0.3.1", 5):WaitForChild("networker", 5):WaitForChild("_remotes", 5):WaitForChild("RollService", 5):WaitForChild("RemoteFunction", 5)
    DataServiceClient = require(ReplicatedStorage:WaitForChild("Packages", 5):WaitForChild("DataService", 5)).client
    RollServiceClient = require(ReplicatedStorage:WaitForChild("Source", 5):WaitForChild("Features", 5):WaitForChild("Roll", 5):WaitForChild("RollServiceClient", 5))
    InventoryServiceClient = require(ReplicatedStorage:WaitForChild("Source", 5):WaitForChild("Features", 5):WaitForChild("Inventory", 5):WaitForChild("InventoryServiceClient", 5))
    RollSlice = require(ReplicatedStorage:WaitForChild("Source", 5):WaitForChild("Features", 5):WaitForChild("Roll", 5):WaitForChild("RollSlice", 5))
    ErrorMessages = require(ReplicatedStorage:WaitForChild("Source", 5):WaitForChild("Core", 5):WaitForChild("UI", 5):WaitForChild("Components", 5):WaitForChild("ErrorMessages", 5))
    RarityTiers = require(ReplicatedStorage:WaitForChild("Source", 5):WaitForChild("Game", 5):WaitForChild("Items", 5):WaitForChild("RarityTiers", 5))
    
    local function GetLocalSlimes()
        local u1 = game:GetService("ReplicatedStorage")
        pcall(function() require(u1:WaitForChild("Source", 5):WaitForChild("Game", 5):WaitForChild("Items", 5):WaitForChild("DataTemplate", 5)) end)
        local u2 = require(u1:WaitForChild("Source", 5):WaitForChild("Features", 5):WaitForChild("Crafting", 5):WaitForChild("Recipes", 5))
        local u3 = require(u1:WaitForChild("Source", 5):WaitForChild("Features", 5):WaitForChild("Mutations", 5):WaitForChild("Mutations", 5))
        local u4 = {
            ["goopy"] = { ["name"] = "Goopy", ["weight"] = 1000000000000, ["damage"] = 4, ["health"] = 10, ["image"] = "rbxassetid://125014847814930", ["minZone"] = 0, ["invertedIcon"] = "rbxassetid://85906060374520", ["invertedTexture"] = "rbxassetid://79837892186578", ["colors"] = { Color3.fromRGB(139, 255, 44), Color3.fromRGB(0, 201, 124) } },
            ["sunset"] = { ["name"] = "Sunset", ["weight"] = 500000000000, ["damage"] = 5, ["health"] = 15, ["image"] = "rbxassetid://121554969636389", ["minZone"] = 0, ["invertedIcon"] = "rbxassetid://127474402104672", ["invertedTexture"] = "rbxassetid://121678853060004", ["colors"] = { Color3.fromRGB(255, 93, 168), Color3.fromRGB(255, 117, 107) } },
            ["fin"] = { ["name"] = "Fin", ["weight"] = 300000000000, ["damage"] = 6, ["health"] = 20, ["image"] = "rbxassetid://87279507965562", ["minZone"] = 0, ["invertedIcon"] = "rbxassetid://129625732691594", ["invertedTexture"] = "rbxassetid://112760530020068", ["colors"] = { Color3.fromRGB(93, 158, 255), Color3.fromRGB(107, 233, 255) } },
            ["leafy"] = { ["name"] = "Leafy", ["weight"] = 200000000000, ["damage"] = 7, ["health"] = 22, ["image"] = "rbxassetid://110387483496665", ["invertedIcon"] = "rbxassetid://108360820555238", ["invertedTexture"] = "rbxassetid://118524160689284", ["minZone"] = 0, ["colors"] = { Color3.fromRGB(93, 255, 161), Color3.fromRGB(18, 212, 0) } },
            ["cat"] = { ["name"] = "Meow", ["weight"] = 62000000000, ["damage"] = 8, ["health"] = 27, ["image"] = "rbxassetid://90044737038788", ["invertedIcon"] = "rbxassetid://128060204890132", ["invertedTexture"] = "rbxassetid://132812756290035", ["minZone"] = 0, ["colors"] = { Color3.fromRGB(189, 156, 107), Color3.fromRGB(119, 92, 73) } },
            ["glo"] = { ["name"] = "Glo", ["weight"] = 38000000000, ["damage"] = 10, ["health"] = 30, ["image"] = "rbxassetid://71398008901155", ["invertedIcon"] = "rbxassetid://81249348733318", ["invertedTexture"] = "rbxassetid://140250012094592", ["minZone"] = 0 },
            ["buggy"] = { ["name"] = "Buggy", ["weight"] = 21000000000, ["damage"] = 13, ["health"] = 36, ["image"] = "rbxassetid://127031604553936", ["invertedIcon"] = "rbxassetid://88228259754645", ["invertedTexture"] = "rbxassetid://97660993793456", ["minZone"] = 0 },
            ["boomy"] = { ["name"] = "Scorchy", ["weight"] = 13500000000, ["damage"] = 15, ["health"] = 43, ["image"] = "rbxassetid://79434801790939", ["invertedIcon"] = "rbxassetid://103006830338451", ["invertedTexture"] = "rbxassetid://104489489933770", ["minZone"] = 0 },
            ["brutis"] = { ["name"] = "Brutis", ["weight"] = 8200000000, ["damage"] = 18, ["health"] = 50, ["image"] = "rbxassetid://96141106213410", ["invertedIcon"] = "rbxassetid://119274072453430", ["invertedTexture"] = "rbxassetid://100258609853570", ["minZone"] = 0 },
            ["frankenSlime"] = { ["name"] = "Frankenslime", ["weight"] = 5200000000, ["damage"] = 20, ["health"] = 60, ["image"] = "rbxassetid://101295677521483", ["invertedIcon"] = "rbxassetid://115607458747725", ["invertedTexture"] = "rbxassetid://78835996001653", ["minZone"] = 0 },
            ["orca"] = { ["name"] = "Orca", ["weight"] = 3000000000, ["damage"] = 25, ["health"] = 72, ["iconSize"] = 1.3, ["image"] = "rbxassetid://81818054985491", ["invertedIcon"] = "rbxassetid://106483258231131", ["invertedTexture"] = "rbxassetid://118557011227562", ["minZone"] = 0, ["iconPosition"] = UDim2.fromScale(0.5, 0.54) },
            ["spike"] = { ["name"] = "Spike", ["weight"] = 1700000000, ["damage"] = 29, ["health"] = 88, ["image"] = "rbxassetid://121766812104264", ["invertedIcon"] = "rbxassetid://80080440209259", ["invertedTexture"] = "rbxassetid://102166619223485", ["minZone"] = 0 },
            ["axolotl"] = { ["name"] = "Axolotl", ["weight"] = 900000000, ["damage"] = 36, ["health"] = 105, ["iconSize"] = 1.26, ["image"] = "rbxassetid://138568829545430", ["invertedIcon"] = "rbxassetid://98795565302798", ["invertedTexture"] = "rbxassetid://136323963468290", ["minZone"] = 1, ["iconPosition"] = UDim2.fromScale(0.5, 0.55) },
            ["spidey"] = { ["name"] = "Spidey", ["weight"] = 504000000, ["damage"] = 43, ["health"] = 121, ["image"] = "rbxassetid://110453196439519", ["invertedIcon"] = "rbxassetid://140302511372352", ["invertedTexture"] = "rbxassetid://125693396113039", ["minZone"] = 1 },
            ["mushy"] = { ["name"] = "Mushy", ["weight"] = 277000000, ["damage"] = 50, ["health"] = 148, ["iconSize"] = 1.26, ["image"] = "rbxassetid://132119790080032", ["invertedIcon"] = "rbxassetid://107640014368924", ["invertedTexture"] = "rbxassetid://82657568780091", ["minZone"] = 2, ["iconPosition"] = UDim2.fromScale(0.5, 0.5) },
            ["rocky"] = { ["name"] = "Rocky", ["weight"] = 155000000, ["damage"] = 58, ["health"] = 176, ["image"] = "rbxassetid://119389913033936", ["invertedIcon"] = "rbxassetid://79865000080086", ["invertedTexture"] = "rbxassetid://117138055594724", ["minZone"] = 3 },
            ["lucky"] = { ["name"] = "Lucky", ["weight"] = 100000000, ["damage"] = 67, ["health"] = 200, ["image"] = "rbxassetid://88659965344315", ["invertedIcon"] = "rbxassetid://99807835263719", ["invertedTexture"] = "rbxassetid://123293380905111", ["minZone"] = 3 },
            ["stump"] = { ["name"] = "Stump", ["weight"] = 60000000, ["damage"] = 75, ["health"] = 232, ["image"] = "rbxassetid://104526065478721", ["invertedIcon"] = "rbxassetid://121036958160211", ["invertedTexture"] = "rbxassetid://84459008141209", ["minZone"] = 4 },
            ["lily"] = { ["name"] = "Pondy", ["weight"] = 40000000, ["damage"] = 85, ["health"] = 256, ["image"] = "rbxassetid://73633156837156", ["invertedIcon"] = "rbxassetid://104240894963877", ["invertedTexture"] = "rbxassetid://128746552274226", ["minZone"] = 4 },
            ["icy"] = { ["name"] = "Icy", ["weight"] = 25000000, ["damage"] = 96, ["health"] = 290, ["image"] = "rbxassetid://107549341119743", ["invertedIcon"] = "rbxassetid://109775863929944", ["invertedTexture"] = "rbxassetid://134224310942680", ["minZone"] = 5 },
            ["orbit"] = { ["name"] = "Orbit", ["weight"] = 17000000, ["damage"] = 115, ["health"] = 344, ["iconSize"] = 1.15, ["image"] = "rbxassetid://134237961759276", ["invertedIcon"] = "rbxassetid://125314529469682", ["invertedTexture"] = "rbxassetid://75748661466616", ["minZone"] = 5 },
            ["aegis"] = { ["name"] = "Aegis", ["weight"] = 10000000, ["damage"] = 138, ["health"] = 414, ["iconSize"] = 1.45, ["image"] = "rbxassetid://129596888311355", ["invertedIcon"] = "rbxassetid://108085324756765", ["invertedTexture"] = "rbxassetid://134753168360710", ["minZone"] = 6, ["iconPosition"] = UDim2.fromScale(0.5, 0.55) },
            ["wicked"] = { ["name"] = "Wicked", ["weight"] = 6600000, ["damage"] = 166, ["health"] = 496, ["iconSize"] = 1.05, ["image"] = "rbxassetid://90719636941813", ["invertedIcon"] = "rbxassetid://103420791517756", ["invertedTexture"] = "rbxassetid://121613615106947", ["minZone"] = 6, ["iconPosition"] = UDim2.fromScale(0.5, 0.45) },
            ["king"] = { ["name"] = "King", ["weight"] = 4000000, ["damage"] = 189, ["health"] = 567, ["image"] = "rbxassetid://131487299588107", ["invertedIcon"] = "rbxassetid://119269956354498", ["invertedTexture"] = "rbxassetid://134446654639287", ["minZone"] = 7 },
            ["guest"] = { ["name"] = "Guest", ["weight"] = 2500000, ["damage"] = 208, ["health"] = 624, ["image"] = "rbxassetid://106886986086246", ["invertedIcon"] = "rbxassetid://121021946951601", ["invertedTexture"] = "rbxassetid://85390874982371", ["minZone"] = 7 },
            ["ninja"] = { ["name"] = "Ninja", ["weight"] = 1700000, ["damage"] = 230, ["health"] = 690, ["image"] = "rbxassetid://71329585399252", ["invertedIcon"] = "rbxassetid://111800035489128", ["invertedTexture"] = "rbxassetid://133639753100907", ["minZone"] = 8 },
            ["buzz"] = { ["name"] = "Buzz", ["weight"] = 1000000, ["damage"] = 270, ["health"] = 810, ["iconSize"] = 1.1, ["image"] = "rbxassetid://91579123196118", ["invertedIcon"] = "rbxassetid://77369424956128", ["invertedTexture"] = "rbxassetid://90804668049911", ["minZone"] = 8, ["iconPosition"] = UDim2.fromScale(0.5, 0.55) },
            ["stormy"] = { ["name"] = "Stormy", ["weight"] = 700000, ["damage"] = 291, ["health"] = 870, ["iconSize"] = 1.4, ["image"] = "rbxassetid://138295134331622", ["invertedIcon"] = "rbxassetid://104384217949600", ["invertedTexture"] = "rbxassetid://90194956104587", ["minZone"] = 9, ["iconPosition"] = UDim2.fromScale(0.5, 0.45) },
            ["bucky"] = { ["name"] = "Bucky", ["weight"] = 450000, ["damage"] = 333, ["health"] = 999, ["iconSize"] = 1.35, ["image"] = "rbxassetid://120383542839889", ["invertedIcon"] = "rbxassetid://111037484001791", ["invertedTexture"] = "rbxassetid://107611046047904", ["minZone"] = 9, ["iconPosition"] = UDim2.fromScale(0.5, 0.35) },
            ["pokey"] = { ["name"] = "Pokey", ["weight"] = 300000, ["damage"] = 371, ["health"] = 1111, ["iconSize"] = 1.15, ["image"] = "rbxassetid://101200748535156", ["invertedIcon"] = "rbxassetid://73243943479555", ["invertedTexture"] = "rbxassetid://78586241879885", ["minZone"] = 10, ["iconPosition"] = UDim2.fromScale(0.5, 0.54) },
            ["slimeSlime"] = { ["name"] = "SlimeSlime", ["weight"] = 200000, ["damage"] = 419, ["health"] = 1256, ["image"] = "rbxassetid://83334448391499", ["invertedIcon"] = "rbxassetid://83233891233271", ["invertedTexture"] = "rbxassetid://134766812443908", ["minZone"] = 10 },
            ["unicorn"] = { ["name"] = "Unicorn", ["weight"] = 120000, ["damage"] = 508, ["health"] = 1524, ["iconSize"] = 1.1, ["image"] = "rbxassetid://82469966827101", ["invertedIcon"] = "rbxassetid://103087954899923", ["invertedTexture"] = "rbxassetid://89744338964620", ["minZone"] = 11, ["iconPosition"] = UDim2.fromScale(0.5, 0.475) },
            ["wizzy"] = { ["name"] = "Wizzy", ["weight"] = 80000, ["damage"] = 612, ["health"] = 1836, ["iconSize"] = 1.35, ["image"] = "rbxassetid://84211538001633", ["invertedIcon"] = "rbxassetid://81154618851526", ["invertedTexture"] = "rbxassetid://84818163570523", ["minZone"] = 11, ["iconPosition"] = UDim2.fromScale(0.5, 0.35) },
            ["flour"] = { ["name"] = "Petal", ["weight"] = 55000, ["damage"] = 734, ["health"] = 2300, ["iconSize"] = 1.05, ["image"] = "rbxassetid://124937734770442", ["invertedIcon"] = "rbxassetid://123934345186686", ["invertedTexture"] = "rbxassetid://80699920458811", ["minZone"] = 12 },
            ["shelly"] = { ["name"] = "Shelly", ["weight"] = 35000, ["damage"] = 880, ["health"] = 2640, ["iconSize"] = 1.05, ["image"] = "rbxassetid://113644834208086", ["invertedIcon"] = "rbxassetid://117384577731612", ["invertedTexture"] = "rbxassetid://87801106525511", ["minZone"] = 12 },
            ["derpy"] = { ["name"] = "Derpy", ["weight"] = 24000, ["damage"] = 1050, ["health"] = 3150, ["image"] = "rbxassetid://107448058521795", ["invertedIcon"] = "rbxassetid://118269206109875", ["invertedTexture"] = "rbxassetid://104165550003115", ["minZone"] = 13 },
            ["otto"] = { ["name"] = "Octo", ["weight"] = 16000, ["damage"] = 1260, ["health"] = 3780, ["iconSize"] = 1.45, ["image"] = "rbxassetid://139658326612671", ["invertedIcon"] = "rbxassetid://80824078516810", ["invertedTexture"] = "rbxassetid://137270347918433", ["minZone"] = 13, ["iconPosition"] = UDim2.fromScale(0.5, 0.55) },
            ["halo"] = { ["name"] = "Halo", ["weight"] = 11000, ["damage"] = 1512, ["health"] = 4500, ["image"] = "rbxassetid://119632823896702", ["invertedIcon"] = "rbxassetid://116301649192056", ["invertedTexture"] = "rbxassetid://136537219938383", ["minZone"] = 14, ["iconPosition"] = UDim2.fromScale(0.5, 0.525) },
            ["bomber"] = { ["name"] = "Bomber", ["weight"] = 7000, ["damage"] = 1810, ["health"] = 5430, ["iconSize"] = 1.1, ["image"] = "rbxassetid://118802012619593", ["invertedIcon"] = "rbxassetid://128169607644497", ["invertedTexture"] = "rbxassetid://136052037168788", ["minZone"] = 14, ["iconPosition"] = UDim2.fromScale(0.5, 0.5) },
            ["ufo"] = { ["name"] = "UFO", ["weight"] = 4500, ["damage"] = 2172, ["health"] = 6516, ["iconSize"] = 1.2, ["image"] = "rbxassetid://84571567979840", ["invertedIcon"] = "rbxassetid://131818577610664", ["invertedTexture"] = "rbxassetid://131605086573440", ["minZone"] = 15 },
            ["witchy"] = { ["name"] = "Witchy", ["weight"] = 3000, ["damage"] = 2600, ["health"] = 7800, ["iconSize"] = 1.2, ["image"] = "rbxassetid://95792608661411", ["invertedIcon"] = "rbxassetid://77134371127216", ["invertedTexture"] = "rbxassetid://98963911847904", ["minZone"] = 15, ["iconPosition"] = UDim2.fromScale(0.5, 0.45) },
            ["blackhole"] = { ["name"] = "Blackhole", ["weight"] = 2000, ["damage"] = 3120, ["health"] = 9360, ["iconSize"] = 1.3, ["image"] = "rbxassetid://75291163669132", ["invertedIcon"] = "rbxassetid://78662914683659", ["invertedTexture"] = "rbxassetid://97489249438818", ["minZone"] = 16 },
            ["ember"] = { ["name"] = "Ember", ["weight"] = 1250, ["damage"] = 3744, ["health"] = 11200, ["iconSize"] = 1.1, ["image"] = "rbxassetid://109587061202149", ["invertedIcon"] = "rbxassetid://78268245668127", ["invertedTexture"] = "rbxassetid://93495902116081", ["minZone"] = 16, ["iconPosition"] = UDim2.fromScale(0.5, 0.45) },
            ["pumpkin"] = { ["name"] = "Pumpkin", ["weight"] = 777, ["damage"] = 4492, ["health"] = 13500, ["image"] = "rbxassetid://73520789212019", ["invertedIcon"] = "rbxassetid://81347277376028", ["invertedTexture"] = "rbxassetid://101241458373121", ["minZone"] = 17 },
            ["ouchy"] = { ["name"] = "Ouchy", ["weight"] = 490, ["damage"] = 5400, ["health"] = 16200, ["iconSize"] = 1.4, ["image"] = "rbxassetid://71018813544154", ["invertedIcon"] = "rbxassetid://99664972820849", ["invertedTexture"] = "rbxassetid://124608713708355", ["minZone"] = 17, ["iconPosition"] = UDim2.fromScale(0.5, 0.55) },
            ["sharky"] = { ["name"] = "Sharky", ["weight"] = 333, ["damage"] = 6500, ["health"] = 19400, ["iconSize"] = 1.4, ["image"] = "rbxassetid://110042731614016", ["invertedIcon"] = "rbxassetid://131010934888645", ["invertedTexture"] = "rbxassetid://85519072747675", ["minZone"] = 18, ["iconPosition"] = UDim2.fromScale(0.5, 0.55) },
            ["dino"] = { ["name"] = "Dino", ["weight"] = 212, ["damage"] = 7800, ["health"] = 23400, ["iconSize"] = 1.15, ["image"] = "rbxassetid://136570963279793", ["invertedIcon"] = "rbxassetid://111474302944756", ["invertedTexture"] = "rbxassetid://93694449081240", ["minZone"] = 18 },
            ["monke"] = { ["name"] = "Monke", ["weight"] = 140, ["damage"] = 9360, ["health"] = 28000, ["iconSize"] = 1.35, ["image"] = "rbxassetid://77496763719646", ["invertedIcon"] = "rbxassetid://71142248382272", ["invertedTexture"] = "rbxassetid://91170950659629", ["minZone"] = 19 },
            ["prickly"] = { ["name"] = "Prickly", ["weight"] = 90, ["damage"] = 11200, ["health"] = 33700, ["iconSize"] = 1.54, ["image"] = "rbxassetid://84926848454541", ["invertedIcon"] = "rbxassetid://103392891003029", ["invertedTexture"] = "rbxassetid://70595106591814", ["minZone"] = 19, ["iconPosition"] = UDim2.fromScale(0.5, 0.57) },
            ["zoomy"] = { ["name"] = "Zoomy", ["weight"] = 63, ["damage"] = 13400, ["health"] = 40300, ["iconSize"] = 0.95, ["image"] = "rbxassetid://140487313117811", ["invertedIcon"] = "rbxassetid://113799765252765", ["invertedTexture"] = "rbxassetid://75173544886247", ["minZone"] = 20, ["iconPosition"] = UDim2.fromScale(0.5, 0.5) },
            ["waxie"] = { ["name"] = "Waxie", ["weight"] = 43, ["damage"] = 16100, ["health"] = 48200, ["iconSize"] = 1.375, ["image"] = "rbxassetid://124352884305657", ["invertedIcon"] = "rbxassetid://130060090039849", ["invertedTexture"] = "rbxassetid://83900194606525", ["minZone"] = 20, ["iconPosition"] = UDim2.fromScale(0.5, 0.4) },
            ["drakey"] = { ["name"] = "Drakey", ["weight"] = 29, ["damage"] = 19300, ["health"] = 58000, ["iconSize"] = 1.75, ["image"] = "rbxassetid://89226334072502", ["invertedIcon"] = "rbxassetid://105776660853713", ["invertedTexture"] = "rbxassetid://140321709355784", ["minZone"] = 21, ["iconPosition"] = UDim2.fromScale(0.5, 0.6) },
            ["germy"] = { ["name"] = "Germy", ["weight"] = 19, ["damage"] = 23100, ["health"] = 70000, ["iconSize"] = 1.15, ["image"] = "rbxassetid://114695028781494", ["invertedIcon"] = "rbxassetid://127254366989034", ["invertedTexture"] = "rbxassetid://137750089857030", ["minZone"] = 21 },
            ["palmy"] = { ["name"] = "Palmy", ["weight"] = 12.5, ["damage"] = 27700, ["health"] = 83000, ["iconSize"] = 1.5, ["image"] = "rbxassetid://117868893544144", ["invertedIcon"] = "rbxassetid://103058250774761", ["invertedTexture"] = "rbxassetid://100327177328759", ["minZone"] = 22, ["iconPosition"] = UDim2.fromScale(0.5, 0.55) },
            ["snazzy"] = { ["name"] = "Snazzy", ["weight"] = 8, ["damage"] = 33200, ["health"] = 100000, ["iconSize"] = 1.3, ["image"] = "rbxassetid://72729644483167", ["invertedIcon"] = "rbxassetid://106538903658787", ["invertedTexture"] = "rbxassetid://86132807277687", ["minZone"] = 22, ["iconPosition"] = UDim2.fromScale(0.5, 0.475) },
            ["bemmy"] = { ["name"] = "Bemmy", ["weight"] = 5.2, ["damage"] = 40000, ["health"] = 120000, ["iconSize"] = 1.1, ["image"] = "rbxassetid://127485383568253", ["invertedIcon"] = "rbxassetid://74161793377993", ["invertedTexture"] = "rbxassetid://82572123950555", ["minZone"] = 23 },
            ["mato"] = { ["name"] = "Mato", ["weight"] = 3.2, ["damage"] = 48000, ["health"] = 144000, ["iconSize"] = 1.1, ["image"] = "rbxassetid://113995789351545", ["invertedIcon"] = "rbxassetid://81949748399211", ["invertedTexture"] = "rbxassetid://114421800349557", ["minZone"] = 23 },
            ["frosty"] = { ["name"] = "Frosty", ["weight"] = 2, ["damage"] = 57600, ["health"] = 172000, ["iconSize"] = 1.3, ["image"] = "rbxassetid://128497431011038", ["invertedIcon"] = "rbxassetid://95313794147006", ["invertedTexture"] = "rbxassetid://109237026593958", ["minZone"] = 24, ["iconPosition"] = UDim2.fromScale(0.5, 0.525) },
            ["pouchy"] = { ["name"] = "Pouchy", ["weight"] = 1.25, ["damage"] = 70000, ["health"] = 210000, ["iconSize"] = 1.23, ["image"] = "rbxassetid://90338928566181", ["invertedIcon"] = "rbxassetid://137720137548497", ["invertedTexture"] = "rbxassetid://101275662851644", ["minZone"] = 24, ["iconPosition"] = UDim2.fromScale(0.5, 0.475) },
            ["hoppity"] = { ["name"] = "Hoppity", ["weight"] = 0.8, ["damage"] = 84000, ["health"] = 252000, ["iconSize"] = 1.3, ["image"] = "rbxassetid://126583635183345", ["invertedIcon"] = "rbxassetid://75349123853587", ["invertedTexture"] = "rbxassetid://79349540328449", ["minZone"] = 25, ["iconPosition"] = UDim2.fromScale(0.5, 0.425) },
            ["shady"] = { ["name"] = "Shady", ["weight"] = 0.54, ["damage"] = 100000, ["health"] = 300000, ["iconSize"] = 1.6, ["image"] = "rbxassetid://139585610533005", ["invertedIcon"] = "rbxassetid://82079725969075", ["invertedTexture"] = "rbxassetid://123221217375509", ["minZone"] = 25, ["iconPosition"] = UDim2.fromScale(0.5, 0.425) },
            ["galaxy"] = { ["name"] = "Galaxy", ["weight"] = 0.31, ["damage"] = 120000, ["health"] = 360000, ["iconSize"] = 1.2, ["image"] = "rbxassetid://120882053341325", ["invertedIcon"] = "rbxassetid://78972792003282", ["invertedTexture"] = "rbxassetid://92944611004225", ["minZone"] = 26 },
            ["painty"] = { ["name"] = "Painty", ["weight"] = 0.19, ["damage"] = 145000, ["health"] = 435000, ["iconSize"] = 1.35, ["image"] = "rbxassetid://76182996459728", ["invertedIcon"] = "rbxassetid://101816576794567", ["invertedTexture"] = "rbxassetid://117467023520795", ["minZone"] = 26, ["iconPosition"] = UDim2.fromScale(0.5, 0.38) },
            ["patty"] = { ["name"] = "Patty", ["weight"] = 0.115, ["damage"] = 174000, ["health"] = 522000, ["iconSize"] = 1.2, ["image"] = "rbxassetid://90737239703154", ["invertedIcon"] = "rbxassetid://122930981612451", ["invertedTexture"] = "rbxassetid://108362007765975", ["minZone"] = 27 },
            ["broclee"] = { ["name"] = "Broclee", ["weight"] = 0.075, ["damage"] = 210000, ["health"] = 630000, ["iconSize"] = 1.2, ["image"] = "rbxassetid://76190194778817", ["invertedIcon"] = "rbxassetid://84577758013974", ["invertedTexture"] = "rbxassetid://89871445669028", ["minZone"] = 27, ["iconPosition"] = UDim2.fromScale(0.5, 0.425) },
            ["meaty"] = { ["name"] = "Meaty", ["weight"] = 0.05, ["damage"] = 256000, ["health"] = 777000, ["iconSize"] = 1.2, ["image"] = "rbxassetid://85657138480145", ["invertedIcon"] = "rbxassetid://96334002390551", ["invertedTexture"] = "rbxassetid://133858042213150", ["minZone"] = 28 },
            ["zappy"] = { ["name"] = "Zappy", ["weight"] = 0.032, ["damage"] = 308000, ["health"] = 924000, ["iconSize"] = 1.35, ["image"] = "rbxassetid://138602335586757", ["invertedIcon"] = "rbxassetid://82493603309814", ["invertedTexture"] = "rbxassetid://125140353000676", ["minZone"] = 28, ["iconPosition"] = UDim2.fromScale(0.5, 0.38) },
            ["crafty"] = { ["name"] = "Crafty", ["weight"] = 0, ["damage"] = 90, ["health"] = 270, ["image"] = "rbxassetid://80275578334225", ["invertedIcon"] = "rbxassetid://130069906362907", ["invertedTexture"] = "rbxassetid://132381989688989", ["craftable"] = true, ["minZone"] = 0 },
            ["thorn"] = { ["name"] = "Thorn", ["weight"] = 0, ["damage"] = 167, ["health"] = 500, ["iconSize"] = 1.1, ["image"] = "rbxassetid://132737359040574", ["invertedIcon"] = "rbxassetid://85895000047007", ["invertedTexture"] = "rbxassetid://94150373762674", ["craftable"] = true, ["minZone"] = 0, ["iconPosition"] = UDim2.fromScale(0.5, 0.55) },
            ["geode"] = { ["name"] = "Geode", ["weight"] = 0, ["damage"] = 300, ["health"] = 900, ["iconSize"] = 1.3, ["image"] = "rbxassetid://120112215527315", ["invertedIcon"] = "rbxassetid://137662541184204", ["invertedTexture"] = "rbxassetid://130856696489606", ["craftable"] = true, ["minZone"] = 0, ["iconPosition"] = UDim2.fromScale(0.5, 0.35) },
            ["slimeSlimeSlime"] = { ["name"] = "SlimeSlimeSlime", ["weight"] = 0, ["damage"] = 676, ["health"] = 2028, ["iconSize"] = 1.3, ["image"] = "rbxassetid://116751290384627", ["invertedIcon"] = "rbxassetid://125371371093254", ["invertedTexture"] = "rbxassetid://99880092316508", ["craftable"] = true, ["minZone"] = 0, ["iconPosition"] = UDim2.fromScale(0.5, 0.4) },
            ["puffy"] = { ["name"] = "Puffy", ["weight"] = 0, ["damage"] = 1400, ["health"] = 4200, ["iconSize"] = 1.2, ["image"] = "rbxassetid://126480065415699", ["invertedIcon"] = "rbxassetid://83877809238490", ["invertedTexture"] = "rbxassetid://77417044589941", ["craftable"] = true, ["minZone"] = 0, ["iconPosition"] = UDim2.fromScale(0.5, 0.55) },
            ["astro"] = { ["name"] = "Astro", ["weight"] = 0, ["damage"] = 4100, ["health"] = 12300, ["iconSize"] = 1.1, ["image"] = "rbxassetid://84474255602247", ["invertedIcon"] = "rbxassetid://107242808504661", ["invertedTexture"] = "rbxassetid://97895890304137", ["craftable"] = true, ["minZone"] = 0 },
            ["sunny"] = { ["name"] = "Sunny", ["weight"] = 0, ["damage"] = 8100, ["health"] = 24300, ["iconSize"] = 1.3, ["image"] = "rbxassetid://124866647020868", ["invertedIcon"] = "rbxassetid://127425348993954", ["invertedTexture"] = "rbxassetid://129395265805262", ["craftable"] = true, ["minZone"] = 0, ["iconPosition"] = UDim2.fromScale(0.5, 0.55) },
            ["melly"] = { ["name"] = "Melly", ["weight"] = 0, ["damage"] = 31000, ["health"] = 93000, ["iconSize"] = 1.2, ["image"] = "rbxassetid://105418599267634", ["invertedIcon"] = "rbxassetid://70774822832676", ["invertedTexture"] = "rbxassetid://73333798478762", ["craftable"] = true, ["minZone"] = 0, ["iconPosition"] = UDim2.fromScale(0.5, 0.475) },
            ["sweetie"] = { ["name"] = "Sweetie", ["weight"] = 0, ["damage"] = 93000, ["health"] = 279000, ["iconSize"] = 1.3, ["image"] = "rbxassetid://117564828375077", ["invertedIcon"] = "rbxassetid://126365239809042", ["invertedTexture"] = "rbxassetid://76271685402726", ["minZone"] = 0, ["craftable"] = true, ["iconPosition"] = UDim2.fromScale(0.5, 0.45) }
        }
        local u5 = 0
        local u6 = {}
        local u7 = {}
        for v8, v9 in pairs(u4) do
            v9.id = v8
            if not v9.craftable then
                u5 = u5 + v9.weight
            end
        end
        local v10 = u5 > 0
        local function u31(p11, p12)
            local v13 = u6[p11]
            if v13 ~= nil then return v13 end
            local v14 = u4[p11]
            if not v14 then return 1 end
            if not v14.craftable then
                local v17 = v14.craftable and 0 or v14.weight / u5
                u6[p11] = v17
                return v17
            end
            if p12[p11] then return 1 end
            p12[p11] = true
            local v20 = u2.getRecipeByOutputId(p11)
            if not v20 then return 1 end
            local v23 = 0
            for _, v24 in ipairs(v20.inputs) do
                local v25 = u31(v24.id, p12) / u3.getVisualOddsMultiplier(v24.mutations)
                v23 = v23 + 1 / v25
            end
            local v30 = 1 / (v23 * 1.33)
            p12[p11] = nil
            u6[p11] = v30
            return v30
        end
        for _, v32 in pairs(u2.getRecipes()) do
            local v33 = u4[v32.outputId]
        end
        for v38, v39 in pairs(u4) do
            v39.rollOdds = v39.craftable and 0 or v39.weight / u5
            v39.odds = u31(v38, {})
            table.insert(u7, v39)
        end
        table.sort(u7, function(p40, p41)
            if p40.odds == p41.odds then
                return p40.id < p41.id
            else
                return p40.odds > p41.odds
            end
        end)
        for v42, v43 in ipairs(u7) do
            v43.layout = v42
        end
        local u67 = {
            ["getSlime"] = function(p44)
                if p44 == nil then return nil end
                return u4[p44]
            end,
            ["getSortedSlimes"] = function()
                return u7
            end,
            ["getImage"] = function(p48, p49)
                local v50 = u67.getSlime(p48)
                if not v50 then return "" end
                local v51 = p49 and p49.inverted == true or false
                if v51 and v50.invertedIcon and v50.invertedIcon ~= "" then
                    return v50.invertedIcon
                else
                    return v50.image
                end
            end,
            ["applyMutationVisuals"] = function(p52, p53, p54)
                local v55 = u67.getSlime(p53)
                if not v55 then return end
                local v56 = p54 and p54.inverted == true or false
                if v56 and v55.invertedTexture and v55.invertedTexture ~= "" then
                    local v57 = p52:FindFirstChild("SlimeBody", true)
                    if v57 and v57:IsA("MeshPart") then
                        local v58 = v57:FindFirstChildWhichIsA("SurfaceAppearance")
                        if v58 then
                            local v59 = u1:WaitForChild("Assets", 5) and u1.Assets:WaitForChild("InvertedSurfaceApearances", 5) and u1.Assets.InvertedSurfaceApearances:FindFirstChild(p53)
                            if v59 and v59:IsA("SurfaceAppearance") then
                                local v60 = v59:Clone()
                                v60.Name = v58.Name
                                v58:Destroy()
                                v60.Parent = v57
                            end
                        else
                            v57.TextureID = v55.invertedTexture
                        end
                    end
                end
            end,
            ["getModel"] = function(p61)
                local v62 = u1:WaitForChild("Assets", 5) and u1.Assets:WaitForChild("Slimes", 5) and u1.Assets.Slimes:FindFirstChild(p61)
                return v62
            end
        }
        return u67
    end
    
    SlimeItems = GetLocalSlimes()
end)

local RARITY_COLORS = {
    ["Basic"]        = Color3.fromRGB(191, 200, 207),
    ["Common"]       = Color3.fromRGB(130, 255, 92),
    ["Uncommon"]     = Color3.fromRGB(60,  214, 126),
    ["Rare"]         = Color3.fromRGB(99,  185, 255),
    ["Epic"]         = Color3.fromRGB(160, 89,  255),
    ["Legendary"]    = Color3.fromRGB(255, 132, 60),
    ["Mythic"]       = Color3.fromRGB(255, 66,  156),
    ["Divine"]       = Color3.fromRGB(255, 214, 61),
    ["Prismatic"]    = Color3.fromRGB(45,  212, 255),
    ["Transcendent"] = Color3.fromRGB(124, 94,  255),
    ["Ethereal"]     = Color3.fromRGB(255, 255, 255),
    ["Secret"]       = Color3.fromRGB(255, 71,  71),
    ["Celestial"]    = Color3.fromRGB(169, 228, 255),
    ["Astral"]       = Color3.fromRGB(137, 182, 255),
    ["Nova"]         = Color3.fromRGB(255, 144, 227),
    ["Solar"]        = Color3.fromRGB(255, 204, 87),
    ["Lunar"]        = Color3.fromRGB(177, 191, 255),
    ["Galactic"]     = Color3.fromRGB(160, 112, 255),
    ["Stellar"]      = Color3.fromRGB(93,  255, 229),
    ["Nebula"]       = Color3.fromRGB(206, 120, 255),
    ["Quantum"]      = Color3.fromRGB(89,  255, 149),
    ["Void"]         = Color3.fromRGB(65,  56,  110),
    ["Paradox"]      = Color3.fromRGB(255, 111, 111),
}

local function getMutationMultiplier(mutations)
    if type(mutations) ~= "table" then return 1 end
    local mult = 1
    if mutations.big then mult = mult * 100 end
    if mutations.shiny then mult = mult * 250 end
    if mutations.huge then mult = mult * 1000 end
    if mutations.inverted then mult = mult * 2500 end
    return mult
end

local function formatOdds(oddsValue)
    if not oddsValue or oddsValue <= 0 then return "?" end
    local denom = math.ceil(1 / oddsValue)
    
    if denom >= 1000000000 then return string.format("1/%.1fB", denom / 1000000000):gsub("%.0", "")
    elseif denom >= 1000000 then return string.format("1/%.1fM", denom / 1000000):gsub("%.0", "")
    elseif denom >= 1000 then return string.format("1/%.1fK", denom / 1000):gsub("%.0", "")
    else return "1/" .. tostring(denom) end
end

local function getSlimeInfo(id, mutations)
    local name = "Basic"
    local color = RARITY_COLORS["Basic"]
    local actualOdds = 1
    pcall(function()
        if RarityTiers and SlimeItems then
            local slime = SlimeItems.getSlime(id)
            if slime and slime.odds then
                actualOdds = slime.odds / getMutationMultiplier(mutations)
                local tier = RarityTiers.getTier(slime.odds)
                if tier and tier.name then
                    name  = tier.name
                    color = RARITY_COLORS[tier.name] or color
                end
            end
        end
    end)
    return name, color, actualOdds
end

-- ============================================================
-- LIVE GACHA LOG UI
-- ============================================================
local GUI_PARENT = LocalPlayer:WaitForChild("PlayerGui")
pcall(function() GUI_PARENT = game:GetService("CoreGui") end)

local oldLog = GUI_PARENT:FindFirstChild("NapoleonSlimeLog")
if oldLog then oldLog:Destroy() end

local C = {
    bg        = Color3.fromRGB(18, 18, 22),
    panel     = Color3.fromRGB(28, 28, 34),
    titleBar  = Color3.fromRGB(24, 24, 30),
    border    = Color3.fromRGB(80, 80, 95),
    accent    = Color3.fromRGB(230, 230, 230),
    textMain  = Color3.fromRGB(255, 255, 255),
    textSub   = Color3.fromRGB(170, 170, 180),
    textDim   = Color3.fromRGB(100, 100, 115),
    rowEven   = Color3.fromRGB(24, 24, 30),
    rowOdd    = Color3.fromRGB(28, 28, 34),
    rowMut    = Color3.fromRGB(36, 32, 48),
}

local LogGUI = Instance.new("ScreenGui")
LogGUI.Name = "NapoleonSlimeLog"
LogGUI.ResetOnSpawn = false
LogGUI.Enabled = false
LogGUI.Parent = GUI_PARENT

local FRAME_W = 340
local FRAME_H = 240
local FRAME_H_MIN = 38

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.AnchorPoint = Vector2.new(1, 0.5)
MainFrame.Size = UDim2.new(0, FRAME_W, 0, FRAME_H)
MainFrame.Position = UDim2.new(1, -15, 0.5, 0)
MainFrame.BackgroundColor3 = C.bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = LogGUI

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 10)
UICornerMain.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = C.border
UIStroke.Thickness = 1
UIStroke.Transparency = 0.3
UIStroke.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = C.titleBar
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 2
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0.5, 0)
TitleFix.Position = UDim2.new(0, 0, 0.5, 0)
TitleFix.BackgroundColor3 = C.titleBar
TitleFix.BorderSizePixel = 0
TitleFix.ZIndex = 2
TitleFix.Parent = TitleBar

local TitleLine = Instance.new("Frame")
TitleLine.Size = UDim2.new(1, 0, 0, 1)
TitleLine.Position = UDim2.new(0, 0, 1, -1)
TitleLine.BackgroundColor3 = C.border
TitleLine.BackgroundTransparency = 0.5
TitleLine.BorderSizePixel = 0
TitleLine.ZIndex = 3
TitleLine.Parent = TitleBar

local TitleIcon = Instance.new("ImageLabel")
TitleIcon.Size = UDim2.new(0, 20, 0, 20)
TitleIcon.Position = UDim2.new(0, 12, 0.5, 0)
TitleIcon.AnchorPoint = Vector2.new(0, 0.5)
TitleIcon.BackgroundTransparency = 1
TitleIcon.Image = "rbxassetid://136289055140268"
TitleIcon.ScaleType = Enum.ScaleType.Fit
TitleIcon.ZIndex = 3
TitleIcon.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 40, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Napoleon Live Roll"
TitleLabel.TextColor3 = C.textMain
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamMedium
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.TextScaled = false
TitleLabel.ZIndex = 3
TitleLabel.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 22)
MinBtn.Position = UDim2.new(1, -38, 0.5, -11)
MinBtn.AnchorPoint = Vector2.new(0, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
MinBtn.BorderSizePixel = 0
MinBtn.Text = "-"
MinBtn.TextColor3 = C.accent
MinBtn.TextSize = 12
MinBtn.Font = Enum.Font.GothamBold
MinBtn.ZIndex = 4
MinBtn.Parent = TitleBar

local MinBtnCorner = Instance.new("UICorner")
MinBtnCorner.CornerRadius = UDim.new(0, 6)
MinBtnCorner.Parent = MinBtn

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -38)
ContentFrame.Position = UDim2.new(0, 0, 0, 38)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = MainFrame

local HeaderFrame = Instance.new("Frame")
HeaderFrame.Size = UDim2.new(1, -20, 0, 24)
HeaderFrame.Position = UDim2.new(0, 10, 0, 8)
HeaderFrame.BackgroundColor3 = C.panel
HeaderFrame.BorderSizePixel = 0
HeaderFrame.Parent = ContentFrame

local HCorner = Instance.new("UICorner")
HCorner.CornerRadius = UDim.new(0, 6)
HCorner.Parent = HeaderFrame

local HLayout = Instance.new("UIListLayout")
HLayout.FillDirection = Enum.FillDirection.Horizontal
HLayout.SortOrder = Enum.SortOrder.LayoutOrder
HLayout.Parent = HeaderFrame

local function makeHeader(parent, widthScale, text, order)
    local c = Instance.new("TextLabel")
    c.Size = UDim2.new(widthScale, 0, 1, 0)
    c.BackgroundTransparency = 1
    c.Text = text
    c.TextColor3 = C.textSub
    c.TextSize = 10
    c.Font = Enum.Font.GothamBold
    c.TextXAlignment = Enum.TextXAlignment.Center
    c.LayoutOrder = order
    c.Parent = parent
end

makeHeader(HeaderFrame, 0.28, "SLIME", 1)
makeHeader(HeaderFrame, 0.22, "MUTATION", 2)
makeHeader(HeaderFrame, 0.26, "RARITY", 3)
makeHeader(HeaderFrame, 0.24, "VALUE", 4)

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -44)
ScrollFrame.Position = UDim2.new(0, 10, 0, 36)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 2
ScrollFrame.ScrollBarImageColor3 = C.border
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.ClipsDescendants = true
ScrollFrame.Parent = ContentFrame

local SLayout = Instance.new("UIListLayout")
SLayout.SortOrder = Enum.SortOrder.LayoutOrder
SLayout.Padding = UDim.new(0, 4)
SLayout.Parent = ScrollFrame

local MutColors = {
    big      = Color3.fromRGB(255, 180, 50),
    huge     = Color3.fromRGB(255, 80, 80),
    shiny    = Color3.fromRGB(130, 230, 255),
    inverted = Color3.fromRGB(200, 120, 255),
}

local logQueue = {}
local logCounter = 0
local logVisible = true

MinBtn.MouseButton1Click:Connect(function()
    logVisible = not logVisible
    ContentFrame.Visible = logVisible
    MinBtn.Text = logVisible and "-" or "+"
    MainFrame.Size = logVisible and UDim2.new(0, FRAME_W, 0, FRAME_H) or UDim2.new(0, FRAME_W, 0, FRAME_H_MIN)
end)

local function formatMutations(mutations)
    if not mutations or type(mutations) ~= "table" then
        return "-", C.textDim
    end
    local parts = {}
    local firstColor = C.textDim
    local first = true
    for k, v in pairs(mutations) do
        if v == true then
            local label = k:sub(1, 1):upper() .. k:sub(2)
            table.insert(parts, label)
            if first then
                firstColor = MutColors[k] or C.textSub
                first = false
            end
        end
    end
    if #parts == 0 then return "-", C.textDim end
    return table.concat(parts, "+"), firstColor
end

local function sendWebhook(slimeId, mutations, rarityName, rarityColor, actualOdds)
    if not WebhookConfig.EnableWebhook or WebhookConfig.WebhookURL == "" then return end
    
    local mutStr, _ = formatMutations(mutations)
    
    local rarityMatch = false
    if table.find(WebhookConfig.WebhookRarities, "None") then
        rarityMatch = true
    else
        for _, rar in ipairs(WebhookConfig.WebhookRarities) do
            if rarityName == rar then
                rarityMatch = true
                break
            end
        end
    end
    
    local mutMatch = false
    if table.find(WebhookConfig.WebhookMutations, "None") then
        mutMatch = true
    else
        for _, mut in ipairs(WebhookConfig.WebhookMutations) do
            if type(mutations) == "table" and mutations[string.lower(mut)] then
                mutMatch = true
                break
            end
        end
    end
    
    if not (rarityMatch and mutMatch) then return end

    local accName = "Hidden"
    pcall(function() accName = game:GetService("Players").LocalPlayer.Name end)
    local timeStr = os.date("%d/%m/%Y %I.%M %p")
    local oddsStr = formatOdds(actualOdds)
    
    local displayName = slimeId
    local imageId = ""
    pcall(function()
        if SlimeItems then
            local slime = SlimeItems.getSlime(slimeId)
            if slime then
                if slime.name then displayName = slime.name end
                if slime.image then imageId = slime.image end
            end
        end
    end)
    
    local coinsVal = 0
    local goopVal = 0
    local rebirthsVal = 0
    local locationStr = "Unknown"
    
    local ZONE_NAMES = {
        [1] = "Grasslands", [2] = "Desert", [3] = "Polar", [4] = "Volcano",
        [5] = "Islands", [6] = "Cave", [7] = "Heaven", [8] = "Jungle",
        [9] = "Canyon", [10] = "Mushroom Forest", [11] = "Moon",
        [12] = "Redwood Forest", [13] = "Meteor", [14] = "Candyland",
        [15] = "Cherry Grove", [16] = "Crystal Cavern", [17] = "Pumpkin Patch",
        [18] = "Atlantis", [19] = "River", [20] = "Pyramids",
        [21] = "Graveyard", [22] = "Hot Springs", [23] = "Tribe",
        [24] = "Toxic Wasteland", [25] = "Steampunk", [26] = "Winter Wonderland",
        [27] = "Farm", [28] = "Jungle Temple", [29] = "Underworld", [30] = "Swamp",
        [31] = "Mushroom Village", [32] = "The Void", [33] = "Honeycomb"
    }

    pcall(function()
        if DataServiceClient then
            coinsVal = DataServiceClient:get("coins") or DataServiceClient:get("money") or DataServiceClient:get("cash") or coinsVal
            goopVal = DataServiceClient:get("goop") or goopVal
            rebirthsVal = DataServiceClient:get("rebirths") or DataServiceClient:get("rebirth") or rebirthsVal
            local z = DataServiceClient:get("zone")
            if z then locationStr = ZONE_NAMES[z] or ("Zone " .. tostring(z)) end
        end
    end)
    
    pcall(function()
        local ls = game.Players.LocalPlayer:FindFirstChild("leaderstats")
        if ls then
            if ls:FindFirstChild("Coins") then coinsVal = ls.Coins.Value end
            if ls:FindFirstChild("Cash") then coinsVal = ls.Cash.Value end
            if ls:FindFirstChild("Money") then coinsVal = ls.Money.Value end
            if ls:FindFirstChild("Goop") then goopVal = ls.Goop.Value end
            if ls:FindFirstChild("Rebirths") then rebirthsVal = ls.Rebirths.Value end
            if ls:FindFirstChild("Rebirth") then rebirthsVal = ls.Rebirth.Value end
        end
    end)

    local formatNum = function(n)
        n = tonumber(n)
        if not n then return "0" end
        if n >= 1e9 then return string.format("%.2fB", n / 1e9)
        elseif n >= 1e6 then return string.format("%.2fM", n / 1e6)
        elseif n >= 1e3 then return string.format("%.2fK", n / 1e3)
        else return tostring(math.floor(n)) end
    end
    
    local r = math.clamp(math.floor(rarityColor.R * 255), 0, 255)
    local g = math.clamp(math.floor(rarityColor.G * 255), 0, 255)
    local b = math.clamp(math.floor(rarityColor.B * 255), 0, 255)
    local decColor = (r * 65536) + (g * 256) + b
    
    task.spawn(function()
        local reqFunc = request or http_request or (syn and syn.request)
        if not reqFunc then return end
        
        local thumbUrl = ""
        if imageId ~= "" then
            local numId = imageId:match("%d+")
            if numId then
                local apiUrl = "https://thumbnails.roblox.com/v1/assets?assetIds="..numId.."&returnPolicy=PlaceHolder&size=420x420&format=Png&isCircular=false"
                local success, response = pcall(function()
                    return reqFunc({ Url = apiUrl, Method = "GET" })
                end)
                if success and response and response.Body then
                    local ok, decoded = pcall(function() return game:GetService("HttpService"):JSONDecode(response.Body) end)
                    if ok and decoded and decoded.data and decoded.data[1] and decoded.data[1].imageUrl then
                        thumbUrl = decoded.data[1].imageUrl
                    end
                end
            end
        end

        local embedFields = {
            { name = "<:dna:1501810211160330341> Rarity", value = rarityName, inline = true },
            { name = "<:dice:1501810308946198548> Odds", value = oddsStr, inline = true },
            { name = "<:sparkles:1501810376940060692> Mutation", value = mutStr, inline = true },
            { name = "<:moneybag:1499960319210946671> Money", value = formatNum(coinsVal), inline = true },
            { name = "<:potions:1501810450898096188> Goop", value = formatNum(goopVal), inline = true },
            { name = "<:recycle:1501810546369106021> Rebirths", value = tostring(rebirthsVal), inline = true },
            { name = "<:earth:1501810626341769317> Location", value = locationStr, inline = true },
            { name = "<:guest:1499960602850754720> Account", value = "||" .. accName .. "||", inline = true }
        }

        local data = {
            ["username"] = "Napoleon Premium",
            ["avatar_url"] = "https://cdn.discordapp.com/avatars/1496249659763724471/57428bdea017a7908c4ae32ad2bf5166.png",
            ["content"] = "@everyone",
            ["embeds"] = {{
                ["title"] = "[ " .. rarityName .. " ] - " .. displayName,
                ["description"] = "Congratulations! You successfully rolled a **" .. rarityName .. "** slime!",
                ["type"] = "rich",
                ["color"] = decColor,
                ["thumbnail"] = thumbUrl ~= "" and {["url"] = thumbUrl} or nil,
                ["fields"] = embedFields,
                ["footer"] = {
                    ["text"] = "Napoleon Premium • Slime RNG • " .. timeStr,
                    ["icon_url"] = "https://cdn.discordapp.com/avatars/1496249659763724471/57428bdea017a7908c4ae32ad2bf5166.png"
                }
            }}
        }
        
        local body = game:GetService("HttpService"):JSONEncode(data)
        pcall(function()
            reqFunc({
                Url = WebhookConfig.WebhookURL,
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

local function addSlimeLog(slimeName, mutations, rarityName, rarityColor, actualOdds)
    sendWebhook(slimeName, mutations, rarityName, rarityColor, actualOdds)

    logCounter = logCounter + 1

    local mutStr, mutColor = formatMutations(mutations)
    local hasMut = mutStr ~= "-"
    local oddsStr = formatOdds(actualOdds)

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, 22)
    row.Position = UDim2.new(0, 2, 0, 0)
    row.BackgroundColor3 = hasMut and C.rowMut or (logCounter % 2 == 0 and C.rowEven or C.rowOdd)
    row.BorderSizePixel = 0
    row.LayoutOrder = logCounter
    row.Parent = ScrollFrame

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 6)
    rowCorner.Parent = row

    if hasMut then
        local stroke = Instance.new("UIStroke")
        stroke.Color = mutColor
        stroke.Thickness = 0.8
        stroke.Transparency = 0.4
        stroke.Parent = row
    end

    local rowL = Instance.new("UIListLayout")
    rowL.FillDirection = Enum.FillDirection.Horizontal
    rowL.SortOrder = Enum.SortOrder.LayoutOrder
    rowL.Parent = row

    local nameL = Instance.new("TextLabel")
    nameL.Size = UDim2.new(0.28, 0, 1, 0)
    nameL.BackgroundTransparency = 1
    nameL.Text = slimeName or "?"
    nameL.TextColor3 = hasMut and mutColor or C.textSub
    nameL.TextSize = 10
    nameL.Font = hasMut and Enum.Font.GothamMedium or Enum.Font.Gotham
    nameL.TextXAlignment = Enum.TextXAlignment.Left
    nameL.TextTruncate = Enum.TextTruncate.AtEnd
    nameL.LayoutOrder = 1
    local namePad = Instance.new("UIPadding")
    namePad.PaddingLeft = UDim.new(0, 8)
    namePad.Parent = nameL
    nameL.Parent = row

    local mutL = Instance.new("TextLabel")
    mutL.Size = UDim2.new(0.22, 0, 1, 0)
    mutL.BackgroundTransparency = 1
    mutL.Text = mutStr
    mutL.TextColor3 = mutColor
    mutL.TextSize = 10
    mutL.Font = hasMut and Enum.Font.GothamMedium or Enum.Font.Gotham
    mutL.TextXAlignment = Enum.TextXAlignment.Center
    mutL.LayoutOrder = 2
    mutL.Parent = row

    local rarL = Instance.new("TextLabel")
    rarL.Size = UDim2.new(0.26, 0, 1, 0)
    rarL.BackgroundTransparency = 1
    rarL.Text = rarityName or "Basic"
    rarL.TextColor3 = rarityColor or RARITY_COLORS["Basic"]
    rarL.TextSize = 10
    rarL.Font = Enum.Font.GothamMedium
    rarL.TextXAlignment = Enum.TextXAlignment.Center
    rarL.TextTruncate = Enum.TextTruncate.AtEnd
    rarL.LayoutOrder = 3
    rarL.Parent = row

    local oddsL = Instance.new("TextLabel")
    oddsL.Size = UDim2.new(0.24, 0, 1, 0)
    oddsL.BackgroundTransparency = 1
    oddsL.Text = oddsStr
    oddsL.TextColor3 = C.accent
    oddsL.TextSize = 10
    oddsL.Font = Enum.Font.GothamBold
    oddsL.TextXAlignment = Enum.TextXAlignment.Center
    oddsL.LayoutOrder = 4
    oddsL.Parent = row

    table.insert(logQueue, row)

    if #logQueue > 60 then
        local old = table.remove(logQueue, 1)
        old:Destroy()
    end

    task.spawn(function()
        task.wait(0.05)
        ScrollFrame.CanvasPosition = Vector2.new(0, 999999)
    end)
end

-- ============================================================
-- NORMAL ROLL HOOKS
-- ============================================================
local function InitNormalRollHooks()
    pcall(function()
        if RollSlice and RollSlice.actions then
            if RollSlice.actions.setInstantRevealRoll and not oldSetInstant then
                oldSetInstant = RollSlice.actions.setInstantRevealRoll
                RollSlice.actions.setInstantRevealRoll = function(state)
                    if rollMode == "Normal Roll" and autoRollEnabled then
                        return oldSetInstant(true)
                    end
                    return oldSetInstant(state)
                end
            end

            if RollSlice.actions.setRollTable and not oldSetRollTable then
                oldSetRollTable = RollSlice.actions.setRollTable
                RollSlice.actions.setRollTable = function(rollData)
                    if rollMode == "Normal Roll" and autoRollEnabled and type(rollData) == "table" then
                        local newData = {}
                        for k, v in pairs(rollData) do newData[k] = v end
                        newData.rollTime = 0
                        newData.rollSpeedMultiplier = 0
                        return oldSetRollTable(newData)
                    end
                    return oldSetRollTable(rollData)
                end
            end
        end
    end)

    pcall(function()
        if ErrorMessages and type(ErrorMessages.add) == "function" and not oldErrorAdd then
            oldErrorAdd = ErrorMessages.add
            ErrorMessages.add = function(message, ...)
                if autoRollEnabled and (message == "Roll failed. Try again." or message == "You can't roll yet.") then
                    return
                end
                return oldErrorAdd(message, ...)
            end
        end
    end)
end

-- ============================================================
-- NORMAL ROLL LOOP
-- ============================================================
local normalRollLastTime = 0
local normalRollConnection = nil

local function StartNormalRollLoop()
    if normalRollConnection then
        normalRollConnection:Disconnect()
        normalRollConnection = nil
    end
    normalRollConnection = RunService.Heartbeat:Connect(function()
        if not autoRollEnabled or rollMode ~= "Normal Roll" or stackerExecuting then return end
        local now = tick()
        if now - normalRollLastTime >= 0.15 then
            normalRollLastTime = now
            pcall(function()
                if RollClientInstance then RollClientInstance:roll() end
            end)
        end
    end)
end

local function StopNormalRollLoop()
    if normalRollConnection then
        normalRollConnection:Disconnect()
        normalRollConnection = nil
    end
    pcall(function()
        if RollSlice then
            RollSlice.actions.setInstantRevealRoll(false)
            RollSlice.actions.resetRollCompletions()
            RollSlice.rollResults({})
            RollSlice.bonusRollResults({})
            task.wait(0.1)
            if not RollSlice.hiddenRoll() then
                RollSlice.rollScreenShown(false)
            end
        end
    end)
end

-- ============================================================
-- FAST ROLL LOOP
-- ============================================================
local fastRollTotalRolls = 0
local fastRollSessionId = 0

local function FireOneRoll(sessionId)
    if not FastRollRemote then return end
    local ok, results = pcall(function()
        return FastRollRemote:InvokeServer("requestRoll")
    end)
    if sessionId ~= fastRollSessionId then return end
    if ok and type(results) == "table" then
        for _, column in ipairs(results) do
            if type(column) == "table" then
                for _, slimeData in ipairs(column) do
                    if type(slimeData) == "table" and slimeData.id then
                        local rarName, rarColor, actualOdds = getSlimeInfo(slimeData.id, slimeData.mutations)
                        addSlimeLog(slimeData.id, slimeData.mutations, rarName, rarColor, actualOdds)
                    end
                end
            end
        end
    end
end

local function DoFastRollLoop()
    if not FastRollRemote then return end
    local sid = fastRollSessionId
    local THREAD_COUNT = fastRollThreadCount

    local function workerThread(idx)
        task.wait(idx * 0.05)
        while autoRollEnabled and rollMode == "Fast Roll" and sid == fastRollSessionId do
            if not stackerExecuting then
                FireOneRoll(sid)
            end
            task.wait()
        end
    end

    for i = 0, THREAD_COUNT - 1 do
        task.spawn(workerThread, i)
    end

    while autoRollEnabled and rollMode == "Fast Roll" and sid == fastRollSessionId do
        task.wait(0.5)
    end
end

local function StartFastRollLoop()
    fastRollSessionId = fastRollSessionId + 1
    fastRollTotalRolls = 0
    if rollLoopThread then
        task.cancel(rollLoopThread)
        rollLoopThread = nil
    end
    rollLoopThread = task.spawn(DoFastRollLoop)
end

local function StopFastRollLoop()
    fastRollSessionId = fastRollSessionId + 1
    if rollLoopThread then
        task.cancel(rollLoopThread)
        rollLoopThread = nil
    end
end

-- ============================================================
-- SMART DICE STACKER (PREMIUM) LOOP
-- ============================================================
local function DoStackerLoop()
    while stackerEnabled do
        pcall(function()
            if not DataServiceClient then return end
            local prog = DataServiceClient:get("specialRollProgression")
            if not prog then return end
            
            local targets = {}
            if targetGolden and prog.golden then targets.golden = prog.golden end
            if targetDiamond and prog.diamond then targets.diamond = prog.diamond end
            if targetVoid and prog.void then targets.void = prog.void end
            
            local hasTargets = false
            local maxRollsLeft = 0
            
            for kind, data in pairs(targets) do
                hasTargets = true
                if data.rollsUntilNext > maxRollsLeft then
                    maxRollsLeft = data.rollsUntilNext
                end
            end
            
            if not hasTargets then return end
            
            local allReady = true
            
            for kind, data in pairs(targets) do
                if data.rollsUntilNext > 1 then
                    allReady = false
                    if data.paused and RollServiceClient then
                        RollServiceClient:setSpecialRollPaused(kind, false)
                    end
                elseif data.rollsUntilNext <= 1 then
                    local cadence = SAFE_CADENCE[kind] or 8
                    
                    if maxRollsLeft <= cadence then
                        if not data.paused and RollServiceClient then
                            RollServiceClient:setSpecialRollPaused(kind, true)
                        end
                        if not data.paused then
                            allReady = false 
                        end
                    else
                        allReady = false
                        if data.paused and RollServiceClient then
                            RollServiceClient:setSpecialRollPaused(kind, false)
                        end
                    end
                end
            end
            
            if allReady and hasTargets then
                stackerExecuting = true
                notif("Executing Smart Stacker with " .. selectedDice, 4, "Premium")
                
                task.wait(0.5) 
                
                if InventoryServiceClient then
                    InventoryServiceClient:useItem(selectedDice)
                end
                
                task.wait(0.5) 
                
                for kind, _ in pairs(targets) do
                    if RollServiceClient then
                        RollServiceClient:setSpecialRollPaused(kind, false)
                    end
                end
                
                task.wait(0.2) 
                
                if FastRollRemote then
                    FastRollRemote:InvokeServer("requestRoll")
                elseif RollClientInstance then
                    RollClientInstance:roll()
                end
                
                task.wait(2.5) 
                stackerExecuting = false
            end
        end)
        task.wait(0.5)
    end
end

local function SetStackerState(state)
    stackerEnabled = state
    if state then
        if stackerThread then task.cancel(stackerThread) end
        stackerThread = task.spawn(DoStackerLoop)
        notif("Smart Dice Stacker Enabled.", 3, "Napoleon")
    else
        if stackerThread then
            task.cancel(stackerThread)
            stackerThread = nil
        end
        stackerExecuting = false
        notif("Smart Dice Stacker Disabled.", 3, "Napoleon")
    end
end

-- ============================================================
-- AUTO COLLECT LOOT
-- ============================================================
local function DoAutoCollectLoop()
    local LootRemote = nil
    pcall(function() LootRemote = game:GetService("ReplicatedStorage"):WaitForChild("Packages", 5):WaitForChild("_Index", 5):WaitForChild("leifstout_networker@0.3.1", 5):WaitForChild("networker", 5):WaitForChild("_remotes", 5):WaitForChild("LootService", 5):WaitForChild("RemoteFunction", 5) end)
    
    while autoCollectEnabled do
        local lootFolder = workspace:FindFirstChild("Loot")
        if LootRemote and lootFolder then
            for _, item in ipairs(lootFolder:GetChildren()) do
                if not autoCollectEnabled then break end
                pcall(function()
                    local uuid = item:GetAttribute("UUID") or item:GetAttribute("uuid") or item.Name
                    LootRemote:InvokeServer("requestCollect", uuid)
                end)
                task.wait(0.05)
            end
        end
        task.wait(0.5)
    end
end

local function SetAutoCollectState(state)
    autoCollectEnabled = state
    if state then
        if autoCollectThread then task.cancel(autoCollectThread) end
        autoCollectThread = task.spawn(DoAutoCollectLoop)
        notif("Auto Collect Loot Enabled.", 3, "Napoleon")
    else
        if autoCollectThread then
            task.cancel(autoCollectThread)
            autoCollectThread = nil
        end
        notif("Auto Collect Loot Disabled.", 3, "Napoleon")
    end
end

-- ============================================================
-- AUTO FARM ZONE
-- ============================================================
local function DoAutoFarmZoneLoop()
    local ZonesRemote = nil
    pcall(function()
        ZonesRemote = game:GetService("ReplicatedStorage")
            :WaitForChild("Packages", 5)
            :WaitForChild("_Index", 5)
            :WaitForChild("leifstout_networker@0.3.1", 5)
            :WaitForChild("networker", 5)
            :WaitForChild("_remotes", 5)
            :WaitForChild("ZonesService", 5)
            :WaitForChild("RemoteFunction", 5)
    end)
    
    while autoFarmZoneEnabled do
        pcall(function()
            if ZonesRemote and DataServiceClient then
                ZonesRemote:InvokeServer("requestPurchaseZone")
                
                local maxZone = DataServiceClient:get("maxZone") or 1
                local currentZone = DataServiceClient:get("zone") or 1
                
                if currentZone ~= maxZone then
                    ZonesRemote:InvokeServer("requestTeleportZone", maxZone)
                end
            end
        end)
        task.wait(0.1) -- Jeda dikurangi menjadi 0.1 agar sangat cepat
    end
end

local function SetAutoFarmZoneState(state)
    autoFarmZoneEnabled = state
    if state then
        if autoFarmZoneThread then task.cancel(autoFarmZoneThread) end
        autoFarmZoneThread = task.spawn(DoAutoFarmZoneLoop)
        notif("Auto Farm Zone Enabled.", 3, "Napoleon")
    else
        if autoFarmZoneThread then
            task.cancel(autoFarmZoneThread)
            autoFarmZoneThread = nil
        end
        notif("Auto Farm Zone Disabled.", 3, "Napoleon")
    end
end

-- ============================================================
-- SMART UPGRADE
-- ============================================================
local autoUpgradeEnabled = false
local autoUpgradeTargets = {}
local autoUpgradeThread = nil

local function DoAutoUpgradeLoop()
    while autoUpgradeEnabled do
        pcall(function()
            local UpgradeRemote = nil
            pcall(function() UpgradeRemote = game:GetService("ReplicatedStorage"):WaitForChild("Packages", 5):WaitForChild("_Index", 5):WaitForChild("leifstout_networker@0.3.1", 5):WaitForChild("networker", 5):WaitForChild("_remotes", 5):WaitForChild("UpgradeService", 5):WaitForChild("RemoteFunction", 5) end)
            if UpgradeRemote and #autoUpgradeTargets > 0 then
                for _, upgradeName in ipairs(autoUpgradeTargets) do
                    UpgradeRemote:InvokeServer("requestUnlock", upgradeName)
                    task.wait(0.2)
                end
            end
        end)
        task.wait(1)
    end
end

local function SetAutoUpgradeState(state)
    autoUpgradeEnabled = state
    if state then
        if autoUpgradeThread then task.cancel(autoUpgradeThread) end
        autoUpgradeThread = task.spawn(DoAutoUpgradeLoop)
        notif("Smart Upgrade Enabled.", 3, "Napoleon")
    else
        if autoUpgradeThread then task.cancel(autoUpgradeThread) autoUpgradeThread = nil end
        notif("Smart Upgrade Disabled.", 3, "Napoleon")
    end
end

-- ============================================================
-- AUTO CLAIM RECIPE
-- ============================================================
local autoClaimRecipeEnabled = false
local autoClaimRecipeThread = nil

local function DoAutoClaimRecipeLoop()
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local CollectionService = game:GetService("CollectionService")
    local NetworkerRemotes = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("leifstout_networker@0.3.1"):WaitForChild("networker"):WaitForChild("_remotes")
    
    local CraftingRemote, ZonesRemote
    pcall(function()
        CraftingRemote = NetworkerRemotes.CraftingService.RemoteFunction
        ZonesRemote = NetworkerRemotes.ZonesService.RemoteFunction
    end)
    
    while autoClaimRecipeEnabled do
        pcall(function()
            local Character = LocalPlayer.Character
            local HRP = Character and Character:FindFirstChild("HumanoidRootPart")
            if not HRP then return end
            
            if not CraftingRemote or not DataServiceClient then return end
            
            local unlockedRecipes = DataServiceClient:get("craftingRecipes") or {}
            local maxZone = DataServiceClient:get("maxZone") or 1
            
            local allRecipes = CollectionService:GetTagged("Recipe")
            local pendingRecipesByZone = {}
            local count = 0
            
            for _, instance in ipairs(allRecipes) do
                local recipeKey = instance:GetAttribute("key")
                if recipeKey and not unlockedRecipes[recipeKey] then
                    local zoneId = 1
                    local parent = instance.Parent
                    while parent do
                        if parent:IsA("Model") and tonumber(parent.Name) then
                            zoneId = tonumber(parent.Name)
                            break
                        end
                        parent = parent.Parent
                    end
                    
                    if zoneId <= maxZone then
                        if not pendingRecipesByZone[zoneId] then
                            pendingRecipesByZone[zoneId] = {}
                        end
                        table.insert(pendingRecipesByZone[zoneId], { instance = instance, key = recipeKey })
                        count = count + 1
                    end
                end
            end
            
            if count > 0 then
                local originalCFrame = HRP.CFrame
                notif("Auto Claim: Ditemukan " .. tostring(count) .. " recipe baru!", 3, "Recipes")
                
                for zoneId = 1, maxZone do
                    if not autoClaimRecipeEnabled then break end
                    if pendingRecipesByZone[zoneId] then
                        if ZonesRemote then
                            pcall(function()
                                ZonesRemote:InvokeServer("requestTeleportZone", zoneId)
                            end)
                            task.wait(1.5)
                        end
                        
                        for _, recipeData in ipairs(pendingRecipesByZone[zoneId]) do
                            if not autoClaimRecipeEnabled then break end
                            Character:PivotTo(recipeData.instance.CFrame * CFrame.new(0, 3, 0))
                            task.wait(0.5)
                            
                            pcall(function()
                                CraftingRemote:InvokeServer("requestClaimRecipe", recipeData.key, recipeData.instance)
                            end)
                            task.wait(0.5)
                        end
                    end
                end
                
                if autoClaimRecipeEnabled then
                    Character:PivotTo(originalCFrame)
                end
            end
        end)
        
        -- Cek setiap 30 detik (agar tidak spam/lag jika tidak ada recipe)
        for i = 1, 30 do
            if not autoClaimRecipeEnabled then break end
            task.wait(1)
        end
    end
end

local function SetAutoClaimRecipeState(state)
    autoClaimRecipeEnabled = state
    if state then
        if autoClaimRecipeThread then task.cancel(autoClaimRecipeThread) end
        autoClaimRecipeThread = task.spawn(DoAutoClaimRecipeLoop)
        notif("Auto Claim Recipes Enabled.", 3, "Napoleon")
    else
        if autoClaimRecipeThread then task.cancel(autoClaimRecipeThread) autoClaimRecipeThread = nil end
        notif("Auto Claim Recipes Disabled.", 3, "Napoleon")
    end
end

-- ============================================================
-- AUTO POTION
-- ============================================================
local autoPotionEnabled = false
local autoPotionTargets = {}
local autoPotionThread = nil

local function DoAutoPotionLoop()
    local RS = game:GetService("ReplicatedStorage")
    local BoostRemote = nil
    pcall(function()
        BoostRemote = RS:WaitForChild("Packages", 5):WaitForChild("_Index", 5):WaitForChild("leifstout_networker@0.3.1", 5):WaitForChild("networker", 5):WaitForChild("_remotes", 5):WaitForChild("BoostService", 5):WaitForChild("RemoteFunction", 5)
    end)
    
    while autoPotionEnabled do
        pcall(function()
            if not BoostRemote or #autoPotionTargets == 0 then return end
            
            for _, boostId in ipairs(autoPotionTargets) do
                pcall(function()
                    BoostRemote:InvokeServer("requestUseBoost", boostId)
                end)
                task.wait(0.3)
            end
        end)
        task.wait(5)
    end
end

local function SetAutoPotionState(state)
    autoPotionEnabled = state
    if state then
        if autoPotionThread then task.cancel(autoPotionThread) end
        autoPotionThread = task.spawn(DoAutoPotionLoop)
        notif("Auto Potion Enabled.", 3, "Napoleon")
    else
        if autoPotionThread then task.cancel(autoPotionThread) autoPotionThread = nil end
        notif("Auto Potion Disabled.", 3, "Napoleon")
    end
end

-- ============================================================
-- AUTO FEED BEST SLIME
-- ============================================================
local autoFeedBestEnabled = false
local autoFeedBestThread = nil

local slimeUuidCache = {} -- Cache UUID setelah di-trigger: key = rawKey (ex: "big_-halo"), value = uuid (ex: ".bbcdc...")

local function DoAutoFeedBestLoop()
    local RS = game:GetService("ReplicatedStorage")
    local InvRemote = nil
    local InventoryUtils = nil
    
    pcall(function()
        InvRemote = RS:WaitForChild("Packages", 5):WaitForChild("_Index", 5):WaitForChild("leifstout_networker@0.3.1", 5):WaitForChild("networker", 5):WaitForChild("_remotes", 5):WaitForChild("InventoryService", 5):WaitForChild("RemoteFunction", 5)
        InventoryUtils = require(RS:WaitForChild("Source", 5):WaitForChild("Features", 5):WaitForChild("Inventory", 5):WaitForChild("InventoryServiceUtils", 5))
    end)
    
    while autoFeedBestEnabled do
        local success, err = pcall(function()
            if not InvRemote or not DataServiceClient then return end

            local inv = DataServiceClient:get("inventory") or {}
            local equippedRaw = DataServiceClient:get("equipped") or {}

            -- ============================================================
            -- STEP 1: RESOLVE SEMUA UUID SLIME YANG DI-EQUIP
            -- ============================================================
            local resolvedUuids = {} -- berisi UUID valid (berawalan ".") siap pakai
            
            for _, rawKey in pairs(equippedRaw) do
                local key = tostring(rawKey)
                
                if string.sub(key, 1, 1) == "." then
                    -- Sudah punya UUID langsung
                    table.insert(resolvedUuids, key)
                else
                    -- Tidak punya UUID. Cek cache dulu
                    if slimeUuidCache[key] then
                        table.insert(resolvedUuids, slimeUuidCache[key])
                    else
                        -- Belum ada di cache, TRIGGER DULU dengan 1 makanan untuk generate UUID
                        local foodItems = DataServiceClient:get("items") or {}
                        local excludeKws = {"dice", "potion", "boost", "aura", "jar", "crystal", "gem", "shard", "key"}
                        local triggerFood = nil
                        for fKey, fData in pairs(foodItems) do
                            if type(fData) == "number" and fData > 0 then
                                local isExcluded = false
                                for _, ex in ipairs(excludeKws) do
                                    if string.find(string.lower(fKey), ex) then
                                        isExcluded = true
                                        break
                                    end
                                end
                                if not isExcluded then
                                    triggerFood = fKey
                                    break
                                end
                            end
                        end
                        
                        if triggerFood then
                            print(string.format("[UUID TRIGGER] Slime '%s' belum ada UUID, memicu dengan '%s'...", key, triggerFood))
                            pcall(function()
                                InvRemote:InvokeServer("requestUseFood", triggerFood, key, 1)
                            end)
                            task.wait(1.0) -- Tunggu server generate UUID baru
                            
                            -- Re-read equipped setelah trigger
                            local refreshedEquipped = DataServiceClient:get("equipped") or {}
                            for _, rKey in pairs(refreshedEquipped) do
                                local rk = tostring(rKey)
                                -- Cari UUID baru yang sesuai dengan base ID slime ini
                                -- UUID baru akan berawalan "." di dalam inventory
                                if string.sub(rk, 1, 1) == "." then
                                    local freshInv = DataServiceClient:get("inventory") or {}
                                    local slimeData = freshInv[rk]
                                    if type(slimeData) == "table" then
                                        -- Cocokkan dengan base ID dari key asli (misal: "big_-halo" -> "halo")
                                        local baseId = string.split(key, "-")
                                        local baseEnd = baseId[#baseId]
                                        local slimeId = slimeData.id or slimeData.slimeId or ""
                                        if string.find(string.lower(slimeId), string.lower(baseEnd)) then
                                            slimeUuidCache[key] = rk
                                            table.insert(resolvedUuids, rk)
                                            print(string.format("[UUID RESOLVED] '%s' -> '%s'", key, rk))
                                            break
                                        end
                                    end
                                end
                            end
                        else
                            print(string.format("[SKIP] Tidak ada makanan untuk trigger UUID slime '%s'", key))
                        end
                    end
                end
            end
            
            if #resolvedUuids == 0 then return end

            -- ============================================================
            -- STEP 2: KUMPULKAN SEMUA MAKANAN DARI ITEMS
            -- ============================================================
            local itemsData = DataServiceClient:get("items") or {}
            local foodCandidates = {}
            local excludeKeywords = {"dice", "potion", "boost", "aura", "jar", "crystal", "gem", "shard", "key"}
            
            for itemKey, itemAmount in pairs(itemsData) do
                if type(itemAmount) == "number" and itemAmount > 0 then
                    local isExcluded = false
                    local lk = string.lower(itemKey)
                    for _, ex in ipairs(excludeKeywords) do
                        if string.find(lk, ex) then
                            isExcluded = true
                            break
                        end
                    end
                    if not isExcluded then
                        table.insert(foodCandidates, {id = itemKey, amount = itemAmount})
                    end
                end
            end
            
            if #foodCandidates == 0 then return end

            -- ============================================================
            -- STEP 3: SMART FEEDER - BAGI RATA KE SEMUA SLIME
            -- Tiap 1 makanan -> ke slime berikutnya (round-robin)
            -- ============================================================
            local slotIndex = 1
            for _, food in ipairs(foodCandidates) do
                if not autoFeedBestEnabled then return end
                for i = 1, food.amount do
                    if not autoFeedBestEnabled then return end
                    
                    local targetUuid = resolvedUuids[slotIndex]
                    
                    -- Lookup nama slime dari UUID untuk konfirmasi log
                    local freshInv = DataServiceClient:get("inventory") or {}
                    local slimeData = freshInv[targetUuid]
                    local slimeName = (type(slimeData) == "table" and (slimeData.id or slimeData.slimeId)) or "Unknown"
                    
                    print(string.format("[FEED] %s x1 -> [%s] UUID:%s", food.id, string.upper(slimeName), targetUuid))
                    
                    pcall(function()
                        InvRemote:InvokeServer("requestUseFood", food.id, targetUuid, 1)
                    end)
                    task.wait(0.2)
                    
                    slotIndex = slotIndex + 1
                    if slotIndex > #resolvedUuids then slotIndex = 1 end
                end
            end
            
            task.wait(0.5)
        end)
        
        if not success then
            warn("[CRASH AutoFeed] " .. tostring(err))
        end
        
        task.wait(3)
    end
end

local function SetAutoFeedBestState(state)
    autoFeedBestEnabled = state
    if state then
        if autoFeedBestThread then task.cancel(autoFeedBestThread) end
        autoFeedBestThread = task.spawn(DoAutoFeedBestLoop)
        notif("Auto Feed Best Slime Enabled.", 3, "Napoleon")
    else
        if autoFeedBestThread then task.cancel(autoFeedBestThread) autoFeedBestThread = nil end
        notif("Auto Feed Best Slime Disabled.", 3, "Napoleon")
    end
end

-- ============================================================
-- AUTO REBIRTH
-- ============================================================
local function DoAutoRebirthLoop()
    local RebirthRemote = nil
    pcall(function() RebirthRemote = game:GetService("ReplicatedStorage"):WaitForChild("Packages", 5):WaitForChild("_Index", 5):WaitForChild("leifstout_networker@0.3.1", 5):WaitForChild("networker", 5):WaitForChild("_remotes", 5):WaitForChild("RebirthService", 5):WaitForChild("RemoteFunction", 5) end)
    
    while autoRebirthEnabled do
        if RebirthRemote then pcall(function() RebirthRemote:InvokeServer("requestRebirth") end) end
        task.wait(5)
    end
end

local function SetAutoRebirthState(state)
    autoRebirthEnabled = state
    if state then
        if autoRebirthThread then task.cancel(autoRebirthThread) end
        autoRebirthThread = task.spawn(DoAutoRebirthLoop)
        notif("Auto Rebirth Enabled.", 3, "Napoleon")
    else
        if autoRebirthThread then
            task.cancel(autoRebirthThread)
            autoRebirthThread = nil
        end
        notif("Auto Rebirth Disabled.", 3, "Napoleon")
    end
end

-- ============================================================
-- AUTO CLAIM INDEX
-- ============================================================
local function DoAutoClaimIndexLoop()
    local IndexRemote = nil
    pcall(function() IndexRemote = game:GetService("ReplicatedStorage"):WaitForChild("Packages", 5):WaitForChild("_Index", 5):WaitForChild("leifstout_networker@0.3.1", 5):WaitForChild("networker", 5):WaitForChild("_remotes", 5):WaitForChild("IndexService", 5):WaitForChild("RemoteFunction", 5) end)
    
    local CATEGORIES = {"basic", "big", "huge", "shiny", "inverted"}
    
    while autoClaimIndexEnabled do
        if IndexRemote then
            for _, categoryId in ipairs(CATEGORIES) do
                if not autoClaimIndexEnabled then break end
                pcall(function()
                    local canClaim = true
                    while autoClaimIndexEnabled and canClaim do
                        local success = IndexRemote:InvokeServer("requestClaimReward", categoryId)
                        if not success then
                            canClaim = false
                        end
                        task.wait(0.2)
                    end
                end)
                task.wait(0.5)
            end
        end
        task.wait(5)
    end
end

local function SetAutoClaimIndexState(state)
    autoClaimIndexEnabled = state
    if state then
        if autoClaimIndexThread then task.cancel(autoClaimIndexThread) end
        autoClaimIndexThread = task.spawn(DoAutoClaimIndexLoop)
        notif("Auto Claim Index Enabled.", 3, "Napoleon")
    else
        if autoClaimIndexThread then
            task.cancel(autoClaimIndexThread)
            autoClaimIndexThread = nil
        end
        notif("Auto Claim Index Disabled.", 3, "Napoleon")
    end
end

-- ============================================================
-- AUTO EQUIP BEST
-- ============================================================
local function DoAutoEquipBestLoop()
    local InventoryRemote = nil
    pcall(function() InventoryRemote = game:GetService("ReplicatedStorage"):WaitForChild("Packages", 5):WaitForChild("_Index", 5):WaitForChild("leifstout_networker@0.3.1", 5):WaitForChild("networker", 5):WaitForChild("_remotes", 5):WaitForChild("InventoryService", 5):WaitForChild("RemoteFunction", 5) end)
    
    while autoEquipBestEnabled do
        if InventoryRemote then pcall(function() InventoryRemote:InvokeServer("requestEquipBest") end) end
        task.wait(10)
    end
end

local function SetAutoEquipBestState(state)
    autoEquipBestEnabled = state
    if state then
        if autoEquipBestThread then task.cancel(autoEquipBestThread) end
        autoEquipBestThread = task.spawn(DoAutoEquipBestLoop)
        notif("Auto Equip Best Enabled.", 3, "Napoleon")
    else
        if autoEquipBestThread then
            task.cancel(autoEquipBestThread)
            autoEquipBestThread = nil
        end
        notif("Auto Equip Best Disabled.", 3, "Napoleon")
    end
end

-- ============================================================
-- AUTO ATTACK SLIME (GOOP GUN)
-- ============================================================
local function DoAutoAttackSlimeLoop()
    local GoopGunClient = nil
    pcall(function() GoopGunClient = require(game:GetService("ReplicatedStorage").Source.Features.GoopGun.GoopGunServiceClient) end)

    while autoAttackSlimeEnabled do
        pcall(function()
            if GoopGunClient and GoopGunClient.wrapper then
                local wrapper = GoopGunClient.wrapper
                
                -- Force equip the weapon if not equipped
                if not wrapper.isEquipped then
                    wrapper:equip()
                end
                
                -- The game's native GoopGun script has built-in auto-fire logic (isHoldingInput).
                -- We just simulate holding down the click!
                if not wrapper.isHoldingInput then
                    wrapper.isHoldingInput = true
                    wrapper:onActivated()
                end
            end
        end)
        task.wait(0.25) -- periodically ensure it's still holding (in case user manually clicks and releases)
    end
    
    -- Cleanup: when disabled, stop holding input
    pcall(function()
        if GoopGunClient and GoopGunClient.wrapper then
            GoopGunClient.wrapper.isHoldingInput = false
            GoopGunClient.wrapper.stickyTargetId = nil
            if GoopGunClient.wrapper.sprayPromise then
                GoopGunClient.wrapper.sprayPromise:cancel()
                GoopGunClient.wrapper.sprayPromise = nil
            end
        end
    end)
end

local function SetAutoAttackSlimeState(state)
    autoAttackSlimeEnabled = state
    if state then
        if autoAttackSlimeThread then task.cancel(autoAttackSlimeThread) end
        autoAttackSlimeThread = task.spawn(DoAutoAttackSlimeLoop)
        notif("Auto Attack Slime Enabled.", 3, "Napoleon")
    else
        if autoAttackSlimeThread then
            task.cancel(autoAttackSlimeThread)
            autoAttackSlimeThread = nil
        end
        notif("Auto Attack Slime Disabled.", 3, "Napoleon")
    end
end

-- ============================================================
-- MASTER ROLL TOGGLE
-- ============================================================
local function SetAutoRollState(state)
    autoRollEnabled = state
    LogGUI.Enabled = state

    if state then
        logVisible = true
        ContentFrame.Visible = true
        MinBtn.Text = "-"
        MainFrame.Size = UDim2.new(0, FRAME_W, 0, FRAME_H)

        if rollMode == "Normal Roll" then
            StopFastRollLoop()
            StartNormalRollLoop()
            notif("Normal Roll Enabled.", 3, "Napoleon")
        else
            StopNormalRollLoop()
            StartFastRollLoop()
            notif("Fast Roll Enabled.", 3, "Napoleon")
        end
    else
        StopNormalRollLoop()
        StopFastRollLoop()
        notif("Auto Roll Disabled.", 3, "Napoleon")
    end
end

local function SetRollMode(mode)
    rollMode = mode
    if autoRollEnabled then
        SetAutoRollState(false)
        task.wait(0.2)
        SetAutoRollState(true)
    end
end

-- ============================================================
-- INIT HOOKS
-- ============================================================
InitNormalRollHooks()
task.wait(1)

-- ============================================================
-- 1. Anti-AFK
-- ============================================================
local VirtualUser = game:GetService("VirtualUser")
getgenv().autoAFKEnabled = false -- Deklarasi variabel global agar bisa dibaca UI

-- Modern Anti-AFK (Bypass Roblox's 20-min idle kick)
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

LocalPlayer.Idled:Connect(function()
    if getgenv().autoAFKEnabled then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

-- ============================================================
-- NAPOLEON WINDOW
-- ============================================================
local Window = Library:Window({
    Title = "Napoleon",
    Footer = "Slime RNG",
    Color = Color3.fromRGB(255, 255, 255),
    Color2 = Color3.fromRGB(192, 192, 192),
    ["Tab Width"] = 130,
    Image = "136289055140268",
    WindowIMG = "93732999692312",
    LogoHUB = "136289055140268"
})
local Tabs = Window

-- ─── TAB 1: INFO ───
local function LoadInfoTab()
    local InfoTab = Tabs:AddTab({ Name = "Info", Icon = "info" })
    local InfoSection = InfoTab:AddSection("Napoleon Slime RNG", true)
    InfoSection:AddParagraph({
        Title = "Script Information",
        Content = "Normal Roll: Bypasses animation, rolls via client.\nFast Roll: Fires RemoteFunction using 3 parallel threads.\nLive Log uses a modern responsive design with value probability."
    })
    InfoSection:AddButton({
        Title = "Join Discord",
        Callback = function()
            if setclipboard then
                setclipboard("https://discord.gg/RKaZ9vEbpb")
                notif("Discord link copied.", 3, "Napoleon")
            else
                notif("Join manually: discord.gg/RKaZ9vEbpb", 5, "Napoleon")
            end
        end
    })
end

-- ─── TAB 2: MAIN ───
local function LoadMainTab()
    local MainTab = Tabs:AddTab({ Name = "Main", Icon = "rod" })
    
    local FarmSection = MainTab:AddSection("Progression")
    FarmSection:AddToggle({
        Title = "Auto Farm Zone",
        Title2 = "Enable",
        Content = "Automatically buys next zone and teleports there fast.",
        Default = false,
        Callback = function(val) SetAutoFarmZoneState(val) end
    })

    local RollSection = MainTab:AddSection("Roll Controls")
    RollSection:AddToggle({
        Title = "Auto Roll",
        Title2 = "Enable",
        Content = "Enables auto roll and displays the Live Log UI.",
        Default = false,
        Callback = function(val) SetAutoRollState(val) end
    })

    RollSection:AddDropdown({
        Title = "Roll Mode",
        Content = "Select the rolling method.",
        Default = "Normal Roll",
        Options = { "Normal Roll", "Fast Roll" },
        Callback = function(val) SetRollMode(val) end
    })

    RollSection:AddSlider({
        Title = "Fast Roll Speed (Threads)",
        Content = "More threads = faster rolls. (Careful with rate limits!)",
        Default = 5,
        Min = 1,
        Max = 20,
        Increment = 1,
        Callback = function(val) fastRollThreadCount = val end
    })

    local LogSection = MainTab:AddSection("Live Log Panel")
    LogSection:AddButton({
        Title = "Clear Live Log",
        Callback = function()
            for _, row in ipairs(logQueue) do row:Destroy() end
            logQueue = {}
            logCounter = 0
        end
    })
end

-- ─── TAB 3: AUTO ───
local function LoadAutoTab()
    local AutoTab = Tabs:AddTab({ Name = "Auto", Icon = "rbxassetid://109899764114277" })
    
    local CollectSection = AutoTab:AddSection("Looting System")
    CollectSection:AddToggle({
        Title = "Auto Collect Loot",
        Title2 = "Enable",
        Content = "Automatically collects dropped loot boxes.",
        Default = false,
        Callback = function(val) SetAutoCollectState(val) end
    })

    local CombatSection = AutoTab:AddSection("Combat")
    CombatSection:AddToggle({
        Title = "Auto Attack Slimes",
        Title2 = "Enable",
        Content = "Spams Goop Gun at all alive enemies instantly.",
        Default = false,
        Callback = function(val) SetAutoAttackSlimeState(val) end
    })

    local RebirthSection = AutoTab:AddSection("Progression")
    RebirthSection:AddToggle({
        Title = "Auto Rebirth",
        Title2 = "Enable",
        Content = "Automatically rebirths when you have enough Goop.",
        Default = false,
        Callback = function(val) SetAutoRebirthState(val) end
    })

    RebirthSection:AddToggle({
        Title = "Auto Claim Index",
        Title2 = "Enable",
        Content = "Automatically claims all available index rewards.",
        Default = false,
        Callback = function(val) SetAutoClaimIndexState(val) end
    })

    local UpgradeSection = AutoTab:AddSection("Smart Upgrade")
    
    local SMART_UPGRADE_MAP = {
        -- Upgrade ID sesuai UpgradeTree di source dump
        ["Luck"] = {"luck", "luck2", "luck3", "luck4", "luck5", "luck6", "luck7", "luck8", "luck9", "luck10", "luck11", "luck12", "luck13", "luck14", "luck15"},
        ["Roll Speed"] = {"rollSpeed1", "rollSpeed2", "rollSpeed3", "rollSpeed4", "rollSpeed5", "rollSpeed6"},
        ["Coin Income"] = {"coinIncome", "coinIncome2", "coinIncome3", "coinIncome4", "coinIncome5", "coinIncome6", "coinIncome7", "coinIncome8", "coinIncome9", "coinIncome10"},
        ["Goop Drop"] = {"goop", "goopDropRate1", "goopDropRate2", "goopDropRate3", "goopDropRate4", "goopDropRate5", "goopDropRate6", "goopDropRate7"},
        ["Slime Slots"] = {"backpack", "slots2", "slots3", "slots4", "slots5", "slots6", "slots7"},
        ["Enemy Count"] = {"enemyCount2", "enemyCount3", "enemyCount4", "enemyCount5", "enemyCount6", "enemyCount7"},
        ["Enemy Spawn"] = {"enemySpawnSpeed1", "enemySpawnSpeed2", "enemySpawnSpeed3"},
        ["Bonus Rolls"] = {"bonusRolls1", "bonusRolls2", "bonusRolls3", "extraRollChance1", "extraRollChance2", "extraRollChance3"},
        ["Special Rolls"] = {"goldenRolls", "goldenRolls2", "goldenRolls3", "goldenRolls4", "diamondRolls", "diamondRolls2", "diamondRolls3", "diamondRolls4", "voidRolls", "voidRolls2", "voidRolls3", "voidRolls4", "cloverRolls1", "cloverRolls2", "cloverRolls3", "cloverRolls4", "cloverRolls5"},
        ["Friend Luck"] = {"friendLuck1", "friendLuck2", "friendLuck3", "friendLuck4", "friendLuck5", "friendLuck6", "friendLuckBoost1", "friendLuckBoost2", "friendLuckBoost3", "friendLuckBoost4"},
        ["Slime Mutations"] = {"bigSlimes", "hugeSlimes", "shinySlimes", "invertedSlimes"},
        ["Enemy Mutations"] = {"bigEnemies", "hugeEnemies", "shinyEnemies", "invertedEnemies", "bigEnemyChance1", "hugeEnemyChance1", "shinyEnemyChance1", "invertedEnemyChance1"},
        ["Magnet & Speed"] = {"magnetRadius1", "magnetRadius2", "magnetRadius3", "walkSpeed1", "walkSpeed2", "walkSpeed3"},
        ["Offline Loot"] = {"offlineLootAmount1", "offlineLootAmount2", "offlineLootAmount3", "offlineLootAmount4", "offlineLootAmount5"},
        ["Auto Roll"] = {"backpack", "autoRoll"}
    }
    
    local SMART_UPGRADE_KEYS = {}
    for k, _ in pairs(SMART_UPGRADE_MAP) do table.insert(SMART_UPGRADE_KEYS, k) end

    UpgradeSection:AddDropdown({
        Title = "Smart Upgrade Priority",
        Content = "Select priority upgrade categories.",
        Multi = true,
        Default = {},
        Options = SMART_UPGRADE_KEYS,
        Callback = function(val)
            local selectedCategories = type(val) == "table" and val or {val}
            autoUpgradeTargets = {}
            for _, category in ipairs(selectedCategories) do
                if SMART_UPGRADE_MAP[category] then
                    for _, id in ipairs(SMART_UPGRADE_MAP[category]) do
                        table.insert(autoUpgradeTargets, id)
                    end
                end
            end
        end
    })

    UpgradeSection:AddToggle({
        Title = "Auto Smart Upgrade",
        Title2 = "Enable",
        Content = "Automatically buys selected upgrades when affordable.",
        Default = false,
        Callback = function(val) SetAutoUpgradeState(val) end
    })

    local RecipeSection = AutoTab:AddSection("Crafting Recipes")
    RecipeSection:AddToggle({
        Title = "Auto Claim Missing Recipes",
        Title2 = "Enable",
        Content = "Berjalan di background (AFK). TP dari Zone 1 s/d Max Zone untuk auto ambil recipe.",
        Default = false,
        Callback = function(val) SetAutoClaimRecipeState(val) end
    })
end

-- ─── TAB 4: INVENTORY ───
local function LoadInventoryTab()
    local InventoryTab = Tabs:AddTab({ Name = "Inventory", Icon = "rbxassetid://127446443729865" })
    local EquipSection = InventoryTab:AddSection("Slime Management")
    
    EquipSection:AddToggle({
        Title = "Auto Equip Best",
        Title2 = "Enable",
        Content = "Periodically equips your best slimes.",
        Default = false,
        Callback = function(val) SetAutoEquipBestState(val) end
    })

    local FeedSection = InventoryTab:AddSection("Slime Feeding")
    FeedSection:AddToggle({
        Title = "Auto Feed Best Slime",
        Title2 = "Enable",
        Content = "Automatically distributes food to equipped slimes.",
        Default = false,
        Callback = function(val) SetAutoFeedBestState(val) end
    })

    local PotionSection = InventoryTab:AddSection("Auto Potions")
    local POTION_OPTS = {"luck", "ultraLuck", "currency", "rollSpeed"}
    PotionSection:AddDropdown({
        Title = "Target Potions",
        Content = "Select which potions to auto use.",
        Multi = true,
        Default = {},
        Options = POTION_OPTS,
        Callback = function(val)
            autoPotionTargets = type(val) == "table" and val or {val}
        end
    })

    PotionSection:AddToggle({
        Title = "Auto Use Potions",
        Title2 = "Enable",
        Content = "Automatically uses the selected potions.",
        Default = false,
        Callback = function(val) SetAutoPotionState(val) end
    })
end

local function LoadWebhookTab()
    local WebhookTab = Tabs:AddTab({ Name = "Webhook", Icon = "rbxassetid://130986441300365" })
    local WebhookSection = WebhookTab:AddSection("Discord Webhook Settings")

    WebhookSection:AddToggle({
        Title = "Enable Webhook",
        Title2 = "Enable",
        Content = "Send a webhook log when target slime is rolled",
        Default = WebhookConfig.EnableWebhook,
        Callback = function(val)
            WebhookConfig.EnableWebhook = val
            notif("Webhook " .. (val and "ON" or "OFF"), 3, "Webhook")
        end
    })

    WebhookSection:AddInput({
        Title = "Webhook URL",
        Content = "Enter your Discord webhook URL",
        Default = WebhookConfig.WebhookURL,
        Callback = function(val)
            WebhookConfig.WebhookURL = val
            notif("Webhook URL saved!", 3, "Webhook")
        end
    })

    local WEBHOOK_RARITY_OPTS = {"None", "Basic", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Divine", "Prismatic", "Transcendent", "Ethereal", "Secret", "Celestial", "Astral", "Nova", "Solar", "Lunar", "Galactic", "Stellar", "Nebula", "Quantum", "Void", "Paradox"}
    local WEBHOOK_MUTATION_OPTS = {"None", "Big", "Shiny", "Huge", "Inverted"}

    WebhookSection:AddDropdown({
        Title = "Target Rarities",
        Content = "Select rarities to trigger webhook",
        Options = WEBHOOK_RARITY_OPTS,
        Default = WebhookConfig.WebhookRarities,
        Multi = true,
        Callback = function(val)
            if type(val) == "table" then
                WebhookConfig.WebhookRarities = val
            else
                WebhookConfig.WebhookRarities = {val}
            end
        end
    })

    WebhookSection:AddDropdown({
        Title = "Target Mutations",
        Content = "Select mutations to trigger webhook",
        Options = WEBHOOK_MUTATION_OPTS,
        Default = WebhookConfig.WebhookMutations,
        Multi = true,
        Callback = function(val)
            if type(val) == "table" then
                WebhookConfig.WebhookMutations = val
            else
                WebhookConfig.WebhookMutations = {val}
            end
        end
    })

    WebhookSection:AddButton({
        Title = "Test Webhook",
        Content = "Send a test message to Discord",
        Callback = function()
            if WebhookConfig.WebhookURL == "" then
                notif("Please enter a Webhook URL first!", 3, "Webhook")
                return
            end
            notif("Sending test webhook...", 3, "Webhook")
            local testMut = {shiny = true}
            sendWebhook("goopy", testMut, "Secret", Color3.fromRGB(255, 71, 71), 1000000)
        end
    })
end

-- ─── TAB 5: MISC ───
local function LoadPremiumTab()
    local PremiumTab = Tabs:AddTab({ Name = "Misc", Icon = "rbxassetid://130986441300365" })
    local StackerSection = PremiumTab:AddSection("Smart Dice Stacker")
    
    StackerSection:AddParagraph({
        Title = "Dynamic Smart Sync",
        Content = "The script dynamically syncs special rolls. Lower tier rolls will not pause if the highest tier is far away, maximizing efficiency."
    })

    StackerSection:AddToggle({
        Title = "Sync Golden Roll",
        Default = true,
        Callback = function(val) targetGolden = val end
    })
    StackerSection:AddToggle({
        Title = "Sync Diamond Roll",
        Default = true,
        Callback = function(val) targetDiamond = val end
    })
    StackerSection:AddToggle({
        Title = "Sync Void Roll",
        Default = false,
        Callback = function(val) targetVoid = val end
    })

    StackerSection:AddDropdown({
        Title = "Item Dice to Consume",
        Content = "The dice item to automatically consume before stacking.",
        Default = "hugeDice",
        Options = { "hugeDice", "shinyDice", "bigDice", "invertedDice" },
        Callback = function(val) selectedDice = val end
    })

    StackerSection:AddToggle({
        Title = "Enable Smart Stacker",
        Title2 = "Activate",
        Content = "Runs the smart stacker bot in the background.",
        Default = false,
        Callback = function(val) SetStackerState(val) end
    })

    local CodesSection = PremiumTab:AddSection("Auto Redeem Codes")
    CodesSection:AddButton({
        Title = "Redeem All Active Codes",
        Callback = function()
            task.spawn(function()
                notif("Fetching active codes...", 2, "Napoleon")
                local codesList = {}
                
                pcall(function()
                    local CodesMod = require(game:GetService("ReplicatedStorage"):WaitForChild("Source", 3):WaitForChild("Features", 3):WaitForChild("Codes", 3):WaitForChild("Codes", 3))
                    if type(CodesMod) == "table" then
                        for k, v in pairs(CodesMod) do
                            if type(k) == "string" then
                                table.insert(codesList, k)
                            elseif type(v) == "string" then
                                table.insert(codesList, v)
                            elseif type(v) == "table" and type(v.code) == "string" then
                                table.insert(codesList, v.code)
                            end
                        end
                    end
                end)
                
                local knownCodes = {
                    "Release", "Update1", "Update2", "Update3", "Update4", "Update5", 
                    "Slime", "RNG", "SorryForBugs", "1KLikes", "10KLikes", "100KLikes", "SecretCode"
                }
                for _, c in ipairs(knownCodes) do
                    if not table.find(codesList, c) then
                        table.insert(codesList, c)
                    end
                end

                local CodeRemote = nil
                pcall(function()
                    CodeRemote = game:GetService("ReplicatedStorage"):WaitForChild("Packages", 5):WaitForChild("_Index", 5):WaitForChild("leifstout_networker@0.3.1", 5):WaitForChild("networker", 5):WaitForChild("_remotes", 5):WaitForChild("CodeService", 5):WaitForChild("RemoteFunction", 5)
                end)

                if not CodeRemote then
                    notif("Error: Code remote not found!", 3, "Napoleon")
                    return
                end

                local successCount = 0
                for _, code in ipairs(codesList) do
                    pcall(function()
                        local res = CodeRemote:InvokeServer("redeem", code)
                        if res == 5 then
                            successCount = successCount + 1
                            notif("Redeemed: " .. tostring(code), 2, "Napoleon")
                        end
                    end)
                    task.wait(0.2)
                end
                notif("Finished! Redeemed " .. tostring(successCount) .. " codes.", 5, "Napoleon")
            end)
        end
    })

    local AntiAFKSection = PremiumTab:AddSection("Anti AFK")
    AntiAFKSection:AddToggle({
        Title = "Anti AFK",
        Title2 = "Enable",
        Content = "Auto Spacebar key press to prevent AFK kick.",
        Default = false,
        Callback = function(val) getgenv().autoAFKEnabled = val end
    })
end

-- ============================================================
-- INIT UI
-- ============================================================
LoadInfoTab()
task.wait(0.05)
LoadMainTab()
task.wait(0.05)
LoadAutoTab()
task.wait(0.05)
LoadInventoryTab()
task.wait(0.05)
LoadWebhookTab()
task.wait(0.05)
LoadPremiumTab()

_G.ScriptFullyLoaded = true
notif("Napoleon V2 Loaded.", 5, "Napoleon")