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
--                 .. "?script=catch-and-tame"
--                 .. "&userid=" .. userid
--                 .. "&username=" .. username
--                 .. "&executor=" .. (executor:gsub(" ", "%%20"))
--                 .. "&placeid=" .. placeid
--                 .. "&key=" .. key
                
--             game:HttpGet(url)
--         end
--     end)
-- end)


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

local LocalPlayer = Players.LocalPlayer

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
    Footer   = "Catch And Tame",
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
    local InfoSection = InfoTab:AddSection("Napoleon — Catch And Tame", true)

    InfoSection:AddParagraph({
        Title   = "📋 Script Info",
        Content = "Script Napoleon untuk game Catch And Tame."
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
-- TAB: EXPLOIT
-- ============================================================
local function LoadExploitTab()
    local ExploitTab = Tabs:AddTab({ Name = "Exploit", Icon = "rod" })

    local ExploitSection = ExploitTab:AddSection("Exploits")
    
    ExploitSection:AddParagraph({
        Title   = "⚠️ HIGH RISK WARNING",
        Content = "Fitur di bawah ini sangat beresiko tinggi dan bisa menyebabkan BANNED dari game. Gunakan dengan risiko tanggung sendiri (Use at your own risk)!"
    })

    ExploitSection:AddButton({
        Title    = "Buy All Items (Infinite)",
        Callback = function()
            notif("Executing Server Bypass...", 3, "Exploit")
            
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                
                -- Menggunakan path absolute untuk langsung mendapatkan RemoteEvent dari Knit
                local Event = ReplicatedStorage:FindFirstChild("BuyFood", true)
                if not Event then
                    -- Coba cari dengan path manual jika FindFirstChild lambat/gagal
                    pcall(function()
                        Event = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.FoodService.RE.BuyFood
                    end)
                end
                
                if not Event then
                    notif("Gagal mendapatkan RemoteEvent BuyFood!", 3, "Error")
                    return
                end
                
                local totalBeli = 0
                
                -- Loop semua modul Config yang ada di game
                local ConfigFolder = ReplicatedStorage:FindFirstChild("Configs")
                if ConfigFolder then
                    for _, module in ipairs(ConfigFolder:GetChildren()) do
                        if module:IsA("ModuleScript") then
                            local success, data = pcall(require, module)
                            if success and type(data) == "table" then
                                for itemName, itemData in pairs(data) do
                                    if type(itemName) == "string" and type(itemData) == "table" then
                                        -- Langsung sikat semua tanpa pandang bulu (bypassing price check)
                                        -- Hal ini membuat semua totem, lure, coconut, dsb ikut terbeli
                                        task.spawn(function()
                                            Event:FireServer(itemName, 0/0)
                                        end)
                                        totalBeli = totalBeli + 1
                                        task.wait(0.01) -- Jeda kecil agar tidak dikick karena spam
                                    end
                                end
                            end
                        end
                    end
                else
                    notif("Folder Configs tidak ditemukan!", 3, "Error")
                    return
                end
                
                notif("Berhasil mengirim " .. tostring(totalBeli) .. " bypass requests!", 5, "Exploit Success")
            end)
        end
    })

    ExploitSection:AddButton({
        Title    = "Infinite Fruit & Food",
        Callback = function()
            notif("Initializing Fruit Generator...", 3, "Exploit")
            
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local LocalPlayer = game:GetService("Players").LocalPlayer
                
                -- Cari Event FeedPet (RF)
                local Event = nil
                pcall(function()
                    Event = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.FoodService.RF.FeedPet
                end)
                
                if not Event then
                    notif("Gagal mendapatkan RemoteFunction FeedPet!", 3, "Error")
                    return
                end
                
                -- Cari Pet UUID milik LocalPlayer di Pen
                local petGUID = nil
                pcall(function()
                    local pensFolder = workspace:FindFirstChild("PlayerPens")
                    if pensFolder then
                        for _, pen in ipairs(pensFolder:GetChildren()) do
                            local petsFolder = pen:FindFirstChild("Pets")
                            if petsFolder then
                                for _, pet in ipairs(petsFolder:GetChildren()) do
                                    -- Pastikan komparasinya aman menggunakan tostring
                                    if tostring(pet:GetAttribute("OwnerId")) == tostring(LocalPlayer.UserId) then
                                        petGUID = pet.Name -- UUID Pet
                                        break
                                    end
                                end
                            end
                            if petGUID then break end
                        end
                    end
                end)
                
                if not petGUID then
                    notif("Initialization failed! Require active target.", 4, "Error")
                    return
                end
                
                notif("Bypass Ready: " .. string.sub(tostring(petGUID), 1, 8), 3, "Info")
                
                local targetFruits = {
                    "Cosmic Fruit", "Volcanic Fruit", "Alien Fruit", "Bloodmoon Grape",
                    "Heart Chocolate", "Radioactive Strawberry", "Cave Mushroom", 
                    "Cotton Candy", "Banana", "Taco", "Star", "Waffle", "Pepper", 
                    "Abyss Crystal", "Chocolate Egg", "Tuna Fish", "Dog Treat", 
                    "Can Of Worms", "Bag Of Worms", "Fruit Bowl", "Crystal Berry", 
                    "Golden Carrot", "Coral Fruit"
                }
                
                local totalInject = 0
                for _, itemName in ipairs(targetFruits) do
                    task.spawn(function() 
                        pcall(function() Event:InvokeServer(itemName, petGUID, 0/0) end) 
                    end)
                    
                    totalInject = totalInject + 1
                    task.wait(0.15) -- Jeda antar buah agar tidak kena Rate Limit (Dropped Packets)
                end
                
                notif("Successfully generated " .. tostring(totalInject) .. " target items!", 5, "Exploit Success")
            end)
        end
    })

    local dupeFishEnabled = false
    ExploitSection:AddToggle({
        Title    = "Dupe Fish",
        Title2   = "Enable",
        Content  = "Spam eksekusi EndFIshing perlahan untuk dupe catch ikan",
        Default  = false,
        Callback = function(val)
            dupeFishEnabled = val
            if val then
                notif("Dupe Fish ON", 3, "Exploit")
                task.spawn(function()
                    local Event = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("EndFIshing")
                    while dupeFishEnabled do
                        pcall(function()
                            Event:FireServer()
                        end)
                        task.wait(0.25) -- Diperlambat agar aman dan sukses nge-dupe
                    end
                end)
            else
                notif("Dupe Fish OFF", 3, "Exploit")
            end
        end
    })

    ExploitSection:AddButton({
        Title    = "Buy Highest Lasso (Inferno)",
        Callback = function()
            notif("Membeli Lasso Tertinggi (Inferno Lasso)...", 3, "Exploit")
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local Event = ReplicatedStorage:FindFirstChild("BuyLasso", true)
                
                if not Event then
                    pcall(function()
                        Event = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.LassoService.RE.BuyLasso
                    end)
                end
                
                if not Event then
                    notif("Gagal mendapatkan RemoteEvent BuyLasso!", 3, "Error")
                    return
                end
                
                pcall(function()
                    Event:FireServer("Inferno Lasso")
                end)
                
                notif("Berhasil mengeksekusi pembelian Inferno Lasso!", 5, "Exploit Success")
            end)
        end
    })
end

-- ============================================================
-- TAB: AUTO TRADE
-- ============================================================
local function LoadAutoTradeTab()
    local TradeTab = Tabs:AddTab({ Name = "Auto Trade", Icon = "scroll" })
    local TradeSec = TradeTab:AddSection("Auto Trade Setup")

    local selectedPlayer = nil
    local selectedItem = nil
    local tradeAmount = 1
    local isAutoTrading = false
    local currentTradeState = "NONE"

    -- Ambil daftar player (kecuali diri sendiri)
    local playerList = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(playerList, p.Name) end
    end

    -- Ambil daftar makanan dan item
    local combinedList = {}
    local itemCategoryMap = {}
    
    pcall(function()
        local foods = require(ReplicatedStorage.Configs.Food)
        for k, _ in pairs(foods) do 
            table.insert(combinedList, k)
            itemCategoryMap[k] = "Food"
        end
        local items = require(ReplicatedStorage.Configs.ItemConfig)
        for k, _ in pairs(items) do 
            table.insert(combinedList, k)
            itemCategoryMap[k] = "Items"
        end
    end)
    table.sort(combinedList)

    local PlayerDropdown = TradeSec:AddDropdown({
        Title = "Select Player",
        Options = playerList,
        Callback = function(val)
            selectedPlayer = val
        end
    })

    -- Auto-Refresh Player List when someone joins or leaves
    local function updatePlayerDropdown()
        local newList = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(newList, p.Name) end
        end
        if PlayerDropdown and PlayerDropdown.Refresh then
            PlayerDropdown:Refresh(newList)
        end
    end

    Players.PlayerAdded:Connect(updatePlayerDropdown)
    Players.PlayerRemoving:Connect(function(p)
        updatePlayerDropdown()
        -- Reset selectedPlayer jika orangnya keluar
        if type(selectedPlayer) == "string" and p.Name == selectedPlayer then
            selectedPlayer = nil
            if PlayerDropdown.SetValue then PlayerDropdown:SetValue("") end
        end
    end)

    TradeSec:AddDropdown({
        Title = "Select Item/Food",
        Options = combinedList,
        Callback = function(val)
            selectedItem = val
        end
    })

    TradeSec:AddInput({
        Title = "Amount to Offer",
        Default = "1",
        Callback = function(val)
            tradeAmount = tonumber(val) or 1
        end
    })

    local autoTradeConnection = nil
    local lastTradeID = nil

    TradeSec:AddToggle({
        Title = "Full Auto Trade Loop",
        Title2 = "Enable",
        Content = "Otomatis Send Request, Offer Item, & Ready!",
        Default = false,
        Callback = function(val)
            isAutoTrading = val
            
            local KnitPackages = ReplicatedStorage:FindFirstChild("Packages")
            if not KnitPackages then return end
            
            local TradingRE = KnitPackages._Index["sleitnick_knit@1.7.0"].knit.Services.TradingService.RE
            local TransactionRE = KnitPackages._Index["sleitnick_knit@1.7.0"].knit.Services.HandleTransaction.RE
            
            if isAutoTrading then
                if not selectedPlayer or not selectedItem then
                    notif("Pilih Player dan Item terlebih dahulu!", 3, "Error")
                    isAutoTrading = false
                    return
                end
                
                local targetPlayer = Players:FindFirstChild(selectedPlayer)
                if not targetPlayer then
                    notif("Player tidak ditemukan!", 3, "Error")
                    isAutoTrading = false
                    return
                end

                notif("Auto Trade Loop dimulai dengan " .. targetPlayer.Name, 3, "Auto Trade")
                currentTradeState = "NONE"
                lastTradeID = nil

                -- Listen ke SyncTransaction
                if not autoTradeConnection then
                    autoTradeConnection = TransactionRE.SyncTransaction.OnClientEvent:Connect(function(data)
                        if not isAutoTrading then return end
                        if not data or not data.ID then return end
                        
                        local p1 = data.User_1 and data.User_1.PlayerId
                        local p2 = data.User_2 and data.User_2.PlayerId
                        
                        if p1 == targetPlayer.UserId or p2 == targetPlayer.UserId then
                            if data.State == "CREATED" then
                                currentTradeState = "TRADING"
                                
                                if lastTradeID ~= data.ID then
                                    lastTradeID = data.ID
                                    notif("Trade dibuat! Mengisi item & Ready...", 3, "Auto Trade")
                                    
                                    task.spawn(function()
                                        task.wait(0.5)
                                        
                                        local offerData = { Items = { Items = {}, Eggs = {}, Pets = {}, Food = {} }, Currency = 0 }
                                        local category = itemCategoryMap[selectedItem]
                                        if category == "Food" then
                                            offerData.Items.Food[selectedItem] = tradeAmount
                                        elseif category == "Items" then
                                            offerData.Items.Items[selectedItem] = tradeAmount
                                        end
                                        
                                        pcall(function()
                                            TransactionRE.RequestSetOffer:FireServer(data.ID, offerData, 1)
                                        end)
                                        
                                        task.wait(0.5) -- Jeda biar server memproses offer
                                        
                                        pcall(function()
                                            TransactionRE.RequestAccept:FireServer(data.ID, data.TradeVersion + 1, 2)
                                        end)
                                    end)
                                else
                                    -- Sinkronisasi tambahan dari server
                                    local myData = (p1 == LocalPlayer.UserId) and data.User_1 or data.User_2
                                    if myData and not myData.Accepted then
                                        pcall(function()
                                            TransactionRE.RequestAccept:FireServer(data.ID, data.TradeVersion, 2)
                                        end)
                                    end
                                end
                            elseif data.State == "COMPLETED" or data.State == "CANCELLED" or data.State == "DECLINED" then
                                currentTradeState = "NONE"
                                lastTradeID = nil
                                notif("Trade " .. data.State .. ", menunggu trade berikutnya...", 3, "Auto Trade")
                            end
                        end
                    end)
                end

                local requestingTime = 0
                -- Loop pengirim request
                task.spawn(function()
                    while isAutoTrading do
                        if not targetPlayer or not targetPlayer.Parent then
                            notif("Target player leave game!", 3, "Error")
                            isAutoTrading = false
                            break
                        end
                        
                        if currentTradeState == "NONE" then
                            currentTradeState = "REQUESTING"
                            requestingTime = 0
                            pcall(function()
                                TradingRE.SendTradeRequest:FireServer(targetPlayer)
                            end)
                        elseif currentTradeState == "REQUESTING" then
                            requestingTime = requestingTime + 3
                            if requestingTime >= 15 then
                                -- Reset jika 15 detik dicuekin / cooldown habis, agar request lagi
                                currentTradeState = "NONE"
                            end
                        end
                        
                        task.wait(3) -- Cek setiap 3 detik
                    end
                end)
            else
                currentTradeState = "NONE"
                if autoTradeConnection then
                    autoTradeConnection:Disconnect()
                    autoTradeConnection = nil
                end
                notif("Auto Trade Dihentikan!", 3, "Auto Trade")
            end
        end
    })
end

-- ============================================================
-- TAB: MISCELLANEOUS
-- ============================================================
local function LoadMiscTab()
    local MiscTab = Tabs:AddTab({ Name = "Miscellaneous", Icon = "rod" })

    local antiAfkConnection = nil
    local SystemSection = MiscTab:AddSection("System")
    SystemSection:AddToggle({
        Title    = "Anti-AFK",
        Title2   = "Enable",
        Content  = "Bypass 20 menit idle",
        Default  = true,
        Callback = function(val)
            if val then
                notif("Anti-AFK ON", 3, "System")
                
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
-- INIT
-- ============================================================
LoadInfoTab()
LoadExploitTab()
LoadAutoTradeTab()
LoadMiscTab()

_G.ScriptFullyLoaded = true
notif("Script berhasil dimuat!", 5, "Napoleon")
