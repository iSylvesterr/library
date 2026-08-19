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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BuyShopItem = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlantRush"):WaitForChild("BuyShopItem")

local GEAR_LIST = {}
local SEED_LIST = {}
local SEED_RARITY = { ['Grape'] = "Rare", ['Horned Melon'] = "Divine", ['Spring Onion'] = "Legendary", ['Cherry Blossom'] = "Prismatic", ['Carrot'] = "Common", ['Corn'] = "Epic", ['Galaxy Hibiscus'] = "Prismatic", ['Ember Fruit'] = "Transcended", ['Dragonfruit'] = "Exotic", ['Beanstalk'] = "Secret", ['Golden Apple'] = "Divine", ['Pumpkin'] = "Common", ['Striped Starfruit'] = "Exotic", ['Frostbell'] = "Prismatic", ['Garden Golem'] = "Transcended", ['Amber Wisp'] = "Divine", ['Muck Monarch'] = "Transcended", ['Mooncap'] = "Transcended", ['Twinflame Tulip'] = "Epic", ['Cocoa'] = "Divine", ['Admin Crownflower'] = "Secret", ['Iron Fern'] = "Prismatic", ['Honeysuckle'] = "Epic", ['Garlic'] = "Prismatic", ['Apple'] = "Prismatic", ['Onion'] = "Uncommon", ['Ghost Pepper'] = "Transcended", ['Admin Starroot'] = "Exotic", ['Dreadcap'] = "Divine", ['Crowned Pear'] = "Exotic", ['Cabbage'] = "Rare", ['Glasswing'] = "Secret", ['Plum'] = "Epic", ['Blood Orange'] = "Prismatic", ['Banana'] = "Legendary", ['Mushroom'] = "Legendary", ['Blueberry'] = "Rare", ['Darkmatter Bramble'] = "Exotic", ['Void Fruit'] = "Exotic", ['Strawberry'] = "Secret", ['Cantaloupe'] = "Uncommon", ['Papaya'] = "Transcended", ['Diamond Blossom'] = "Divine", ['Watermelon'] = "Uncommon", ['Durian'] = "Transcended", ['Pomegranate'] = "Divine", ['Passionfruit'] = "Exotic", ['Garden Devourer'] = "Transcended", ['Soulbound Orchid'] = "Transcended", ['Peach'] = "Rare", ['Rush Root'] = "Prismatic", ['Elder Dragonroot'] = "Exotic", ['Hex Sprout'] = "Prismatic", ['Heart of Corruption'] = "Transcended", ['Compost Hydra'] = "Divine", ['Promise Lily'] = "Uncommon", ['Amulet Anemone'] = "Legendary", ['Admin Rose'] = "Transcended", ['Potato'] = "Legendary", ['Glowshroom'] = "Secret", ['Admin Bloom'] = "Divine", ['Monsoon Crown'] = "Secret", ['Duoheart Daisy'] = "Prismatic", ['Moonflower'] = "Exotic", ['Bamboo'] = "Rare", ['Beetroot'] = "Common", ['Nectarine'] = "Epic", ['Truckers Delight'] = "Exotic", ['Pepper'] = "Exotic", ['Crystalberry'] = "Divine", ['Cauliflower'] = "Epic", ['Kiwi'] = "Exotic", ['Wheat'] = "Uncommon", ['Golden Quillflower'] = "Transcended", ['Citrus'] = "Epic", ['Queens Blossom'] = "Transcended", ['Witherfang'] = "Exotic", ['Pineapple'] = "Prismatic", ['Muckthorn'] = "Exotic", ['Martian Melon'] = "Epic", ['Uranium Reed'] = "Exotic", ['Heartvine Bloom'] = "Exotic", ['Tomato'] = "Secret", ['Crimson Higanbana'] = "Exotic", ['Sunflower'] = "Epic", ['Admin Sunflower'] = "Epic", ['Melon'] = "Uncommon", ['Starfruit'] = "Secret", ['Mango'] = "Legendary", ['Aurora Lotus'] = "Transcended", ['Cinnamon'] = "Prismatic" }

pcall(function()
    local Registry = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Registry"))
    if Registry.Plants then
        for k, v in pairs(Registry.Plants) do
            if type(v) == "table" then
                table.insert(SEED_LIST, k)
                SEED_RARITY[k] = v.Rarity
            end
        end
        table.sort(SEED_LIST)
    end
    if Registry.Gear then
        for k, _ in pairs(Registry.Gear) do
            table.insert(GEAR_LIST, k)
        end
        table.sort(GEAR_LIST)
    end
end)

-- Fallback jika gagal mengambil data dari game
if #SEED_LIST == 0 then
    SEED_LIST = {
        "Admin Bloom", "Admin Crownflower", "Admin Rose", "Admin Starroot", "Admin Sunflower", "Amber Wisp", "Amulet Anemone", "Apple", "Aurora Lotus", "Bamboo", "Banana", "Beanstalk", "Beetroot", "Blood Orange", "Blueberry", "Cabbage", "Cantaloupe", "Carrot", "Cauliflower", "Cherry Blossom", "Cinnamon", "Citrus", "Cocoa", "Compost Hydra", "Corn", "Crimson Higanbana", "Crowned Pear", "Crystalberry", "Darkmatter Bramble", "Diamond Blossom", "Dragonfruit", "Dreadcap", "Duoheart Daisy", "Durian", "Elder Dragonroot", "Ember Fruit", "Frostbell", "Galaxy Hibiscus", "Garden Devourer", "Garden Golem", "Garlic", "Ghost Pepper", "Glasswing", "Glowshroom", "Golden Apple", "Golden Quillflower", "Grape", "Heart of Corruption", "Heartvine Bloom", "Hex Sprout", "Honeysuckle", "Horned Melon", "Iron Fern", "Kiwi", "Mango", "Martian Melon", "Melon", "Monsoon Crown", "Mooncap", "Moonflower", "Muck Monarch", "Muckthorn", "Mushroom", "Nectarine", "Onion", "Papaya", "Passionfruit", "Peach", "Pepper", "Pineapple", "Plum", "Pomegranate", "Potato", "Promise Lily", "Pumpkin", "Queens Blossom", "Rush Root", "Soulbound Orchid", "Spring Onion", "Starfruit", "Strawberry", "Striped Starfruit", "Sunflower", "Tomato", "Truckers Delight", "Twinflame Tulip", "Uranium Reed", "Void Fruit", "Watermelon", "Wheat", "Witherfang"
    }
end

if #GEAR_LIST == 0 then
    GEAR_LIST = {
        "Acid Spray", "Autumn Spray", "Bee Fertilizer", "Bubblegum Spray", "Corrupted Seed Pack", "Cosmic Spray", "Dinosaur Egg", "Fire Spray", "Frozen Spray", "Normal Fertilizer", "Normal Pet Treat", "Plant Rush Boss Box", "Prismatic Fertilizer", "Radioactive Spray", "Rainbow Spray", "Scrappy Fertilizer", "Strong Fertilizer", "Strong Pet Treat", "Super Fertilizer", "Super Pet Treat", "Tropical Seed Pack", "Trucker Spray", "Void Spray", "Wet Spray"
    }
end

-- Insert None at the beginning of SEED_LIST
table.insert(SEED_LIST, 1, "None")

local RARITY_LIST = {
    "None", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Secret", "Prismatic", "Divine", "Exotic", "Transcended"
}

local EGG_LIST = {
    "Common Egg", "Rare Egg", "Epic Egg", "Dinosaur Egg"
}

local Config = {
    TargetItem = "BossBox",
    Quantity = 0/0,
    
    AutoRollSeed = false,
    TargetSeed = {},
    TargetRarity = {},
    
    AutoBuyGear = false,
    TargetGear = {},
    
    AutoBuyEgg = false,
    TargetEgg = {},
    
    AutoSellCrate = false,
    
    AutoUpgradeSeed = false,
    TargetUpgradeSeed = "None",
    TargetUpgradeLevel = 1,
    
    AutoSmartPlant = false,
    TargetSmartPlant = "None",
    
    AntiAFK = true,
    
    FastBuyPlantRush = false,
    TargetPlantRushItems = {"CosmicSpray"}
}

local function executeBuy()
    local success, result = pcall(function()
        return BuyShopItem:InvokeServer(Config.TargetItem, Config.Quantity)
    end)
    if success then
        notif("Successfully exploited " .. Config.TargetItem, 3, "Success")
    else
        notif("Failed: " .. tostring(result), 3, "Error")
    end
end


-- ============================================================
-- EVENT LISTENERS & HELPERS
-- ============================================================

local function getEggSlotFromName(eggName)
    local merchant = workspace:FindFirstChild("PetMerchant")
    if not merchant then return nil end
    for i = 1, 5 do
        local lever = merchant:FindFirstChild("Podium" .. i .. "Lever")
        if lever then
            local att = lever:FindFirstChild("PromptAttachment")
            if att then
                local prompt = att:FindFirstChild("EggShopPrompt")
                if prompt then
                    local text = string.gsub(prompt.ObjectText, "%s+", ""):lower()
                    local target = string.gsub(eggName, "%s+", ""):lower()
                    if text == target then
                        return i
                    end
                end
            end
        end
    end
    return nil
end

local function getSelectedItems(valTable)
    local selected = {}
    if type(valTable) == "table" then
        for k, v in pairs(valTable) do
            if type(k) == "string" and v == true then
                table.insert(selected, k)
            elseif type(v) == "string" then
                table.insert(selected, v)
            end
        end
    elseif type(valTable) == "string" then
        table.insert(selected, valTable)
    end
    return selected
end

local isBuyingSeed = false

-- ============================================================
-- LIVE DASHBOARD UI
-- ============================================================
local RARITY_COLORS = {
    ["Common"] = "#82FF5C",
    ["Uncommon"] = "#3CD67E",
    ["Rare"] = "#63B9FF",
    ["Epic"] = "#A059FF",
    ["Legendary"] = "#FF843C",
    ["Secret"] = "#FF4747",
    ["Prismatic"] = "#2DD4FF",
    ["Divine"] = "#FFD63D",
    ["Exotic"] = "#FF6F6F",
    ["Transcended"] = "#7C5EFF"
}

local GUI_PARENT = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
pcall(function() GUI_PARENT = game:GetService("CoreGui") end)

local oldLog = GUI_PARENT:FindFirstChild("NapoleonRollLog")
if oldLog then oldLog:Destroy() end

local RollLogGUI = Instance.new("ScreenGui")
RollLogGUI.Name = "NapoleonRollLog"
RollLogGUI.ResetOnSpawn = false
RollLogGUI.Parent = GUI_PARENT

local DashboardFrame = Instance.new("Frame")
DashboardFrame.Name = "DashboardFrame"
DashboardFrame.Size = UDim2.new(0, 280, 0, 220)
DashboardFrame.Position = UDim2.new(1, -300, 0.5, -110)
DashboardFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
DashboardFrame.BackgroundTransparency = 0.05
DashboardFrame.BorderSizePixel = 0
DashboardFrame.Active = true
DashboardFrame.Draggable = true
DashboardFrame.ClipsDescendants = true
DashboardFrame.Parent = RollLogGUI
DashboardFrame.Visible = false

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 8)
UICornerMain.Parent = DashboardFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 75)
UIStroke.Thickness = 1
UIStroke.Transparency = 0.2
UIStroke.Parent = DashboardFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 34)
TitleBar.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = DashboardFrame

local TitleLine = Instance.new("Frame")
TitleLine.Size = UDim2.new(1, 0, 0, 1)
TitleLine.Position = UDim2.new(0, 0, 1, -1)
TitleLine.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
TitleLine.BorderSizePixel = 0
TitleLine.Parent = TitleBar

local TitleIcon = Instance.new("ImageLabel")
TitleIcon.Size = UDim2.new(0, 16, 0, 16)
TitleIcon.Position = UDim2.new(0, 12, 0.5, 0)
TitleIcon.AnchorPoint = Vector2.new(0, 0.5)
TitleIcon.BackgroundTransparency = 1
TitleIcon.Image = "rbxassetid://136289055140268"
TitleIcon.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 36, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Live Roll Status"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -34)
ContentFrame.Position = UDim2.new(0, 0, 0, 34)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = DashboardFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 0)
UIListLayout.Parent = ContentFrame

local PodiumRows = {}
for i = 1, 6 do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 31)
    row.BackgroundColor3 = (i % 2 == 0) and Color3.fromRGB(22, 22, 28) or Color3.fromRGB(18, 18, 22)
    row.BorderSizePixel = 0
    row.Parent = ContentFrame

    local lblLeft = Instance.new("TextLabel")
    lblLeft.Size = UDim2.new(0.65, 0, 1, 0)
    lblLeft.Position = UDim2.new(0, 14, 0, 0)
    lblLeft.BackgroundTransparency = 1
    lblLeft.RichText = true
    lblLeft.Text = "<font color=\"#6b6b7a\">" .. i .. ".</font> Waiting..."
    lblLeft.TextColor3 = Color3.fromRGB(240, 240, 240)
    lblLeft.Font = Enum.Font.GothamMedium
    lblLeft.TextSize = 13
    lblLeft.TextXAlignment = Enum.TextXAlignment.Left
    lblLeft.Parent = row

    local lblRight = Instance.new("TextLabel")
    lblRight.Size = UDim2.new(0.35, -14, 1, 0)
    lblRight.Position = UDim2.new(0.65, 0, 0, 0)
    lblRight.BackgroundTransparency = 1
    lblRight.RichText = true
    lblRight.Text = "-"
    lblRight.TextColor3 = Color3.fromRGB(120, 120, 135)
    lblRight.Font = Enum.Font.GothamBold
    lblRight.TextSize = 12
    lblRight.TextXAlignment = Enum.TextXAlignment.Right
    lblRight.Parent = row
    
    PodiumRows[i] = { Left = lblLeft, Right = lblRight }
end

-- Simpan koneksi bawaan game agar bisa di-disable (menghilangkan semua animasi & zoom)
local gameRollConnections = {}
pcall(function()
    if getconnections and ReplicatedStorage.Remotes:FindFirstChild("RollSeeds") then
        for _, conn in pairs(getconnections(ReplicatedStorage.Remotes.RollSeeds.OnClientEvent)) do
            table.insert(gameRollConnections, conn)
        end
    end
end)

-- Auto Buy Seed Listener (intercepts rolls)
if ReplicatedStorage.Remotes:FindFirstChild("RollSeeds") then
    ReplicatedStorage.Remotes.RollSeeds.OnClientEvent:Connect(function(rolledSeeds)
        if Config.AutoRollSeed and type(rolledSeeds) == "table" then
            for index, seedName in ipairs(rolledSeeds) do
                local match = false
                local rarity = SEED_RARITY[seedName]
                local rarityStr = rarity or "Unknown"
                
                -- Update Live UI dengan RichText & Warna Rarity
                if PodiumRows[index] then
                    local hexColor = RARITY_COLORS[rarityStr] or "#FFFFFF"
                    PodiumRows[index].Left.Text = string.format("<font color=\"#6b6b7a\">%d.</font> %s", index, seedName)
                    PodiumRows[index].Right.Text = string.format("<font color=\"%s\">%s</font>", hexColor, rarityStr:upper())
                end
                
                -- Cek Target Seed spesifik (Multi)
                if table.find(Config.TargetSeed, seedName) then
                    match = true
                end
                
                -- Cek Rarity (Kategori Multi)
                local rarity = SEED_RARITY[seedName]
                if rarity and table.find(Config.TargetRarity, rarity) then
                    match = true
                end
                
                if match then
                    isBuyingSeed = true
                    task.spawn(function()
                        pcall(function()
                            ReplicatedStorage.Remotes.BuySeed:FireServer(index)
                            notif("Successfully bought " .. seedName .. "!", 3, "Auto Buy Seed")
                        end)
                        -- Jeda dipersingkat drastis agar tidak terasa nge-lag saat ketemu seed
                        task.wait(0.1)
                        isBuyingSeed = false
                    end)
                    break -- Hanya beli 1 seed terbaik per roll jika ada lebih dari 1 match (bisa disesuaikan)
                end
            end
        end
    end)
end

-- ============================================================
-- LOOP THREADS
-- ============================================================

-- Auto Roll Seed Loop
task.spawn(function()
    while true do
        task.wait() -- INSTANT SPAM
        if Config.AutoRollSeed and not isBuyingSeed then
            pcall(function()
                -- Tembak 3 kali per frame (sekitar 180 kali per detik)
                for _ = 1, 3 do
                    ReplicatedStorage.Remotes.RollSeeds:FireServer()
                end
            end)
        end
    end
end)

-- Auto Buy Gear Loop
task.spawn(function()
    while true do
        task.wait(1)
        if Config.AutoBuyGear then
            pcall(function()
                for _, gearName in ipairs(Config.TargetGear) do
                    if gearName ~= "None" then
                        -- Cek stock gear terlebih dahulu agar tidak spam InvokeServer dan bikin lag saat kosong
                        local player = game:GetService("Players").LocalPlayer
                        local rs = game:GetService("ReplicatedStorage")
                        local stockFolder = rs:FindFirstChild("GearStocks")
                        local hasStock = true -- Fallback jika folder stock gagal diload
                        
                        if stockFolder and player and stockFolder:FindFirstChild(player.Name) then
                            local gearStock = stockFolder[player.Name]:FindFirstChild(gearName)
                            if gearStock and gearStock.Value <= 0 then
                                hasStock = false
                            end
                        end
                        
                        if hasStock then
                            ReplicatedStorage.Remotes.Gear.Transaction:InvokeServer(gearName)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Buy Egg Loop
task.spawn(function()
    while true do
        task.wait(1)
        if Config.AutoBuyEgg then
            pcall(function()
                for _, eggName in ipairs(Config.TargetEgg) do
                    if eggName ~= "None" then
                        local slot = getEggSlotFromName(eggName)
                        if slot then
                            -- Beli telurnya dulu
                            local success, reason, actualEggName = ReplicatedStorage.Remotes.EggShop.Transaction:InvokeServer("BuyEgg", slot)
                            if success then
                                local targetName = actualEggName or eggName
                                -- Mulai proses gacha telur ke server
                                ReplicatedStorage.Remotes.RollEgg:FireServer(targetName)
                                
                                -- Beri jeda sedikit agar server selesai memutar RNG gacha, lalu claim pet-nya agar masuk inventory
                                task.delay(0.5, function()
                                    pcall(function()
                                        ReplicatedStorage.Remotes.RollEgg:FireServer(targetName, "ClaimRolledPet")
                                    end)
                                end)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Sell Crate Loop
task.spawn(function()
    while true do
        task.wait(1)
        if Config.AutoSellCrate then
            pcall(function()
                ReplicatedStorage.Remotes.SellCrates:FireServer()
            end)
        end
    end
end)


-- ============================================================
-- WINDOW UI
-- ============================================================
local Window = Library:Window({
    Title = "Napoleon",
    Footer = "Build A Ring Farm",
    Color = Color3.fromRGB(255, 255, 255),
    Color2 = Color3.fromRGB(192, 192, 192),
    ["Tab Width"] = 130,
    Image = "136289055140268",
    WindowIMG = "93732999692312",
    LogoHUB = "136289055140268"
})
local Tabs = Window

-- ─── TAB INFO ───
local InfoTab = Tabs:AddTab({ Name = "Info", Icon = "info" })
local InfoSection = InfoTab:AddSection("Napoleon — Build A Ring Farm", true)
InfoSection:AddParagraph({ 
    Title = "📋 Script Info", 
    Content = "Build A Ring Farm - Exploit Token Bypass & Automation." 
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

-- ─── TAB MAIN ───
local MainTab = Tabs:AddTab({ Name = "Main", Icon = "rod" })

local RollSection = MainTab:AddSection("Auto Roll & Buy Seed")
RollSection:AddToggle({
    Title = "Auto Roll Seed (Instant)",
    Title2 = "Enable",
    Content = "Automatically rolls seeds continuously at max speed",
    Default = false,
    Callback = function(val)
        Config.AutoRollSeed = val
        -- Matikan animasi bawaan game saat Auto Roll aktif
        pcall(function()
            for _, conn in pairs(gameRollConnections) do
                if val then
                    conn:Disable()
                else
                    conn:Enable()
                end
            end
        end)
        -- Tampilkan UI Live Dashboard
        pcall(function()
            if DashboardFrame then
                DashboardFrame.Visible = val
            end
        end)
        
        notif("Auto Roll Seed " .. (val and "ON" or "OFF"), 3, "Auto Roll")
    end
})
RollSection:AddDropdown({
    Title = "Target Seed",
    Content = "Select one or more specific seeds to buy",
    Options = SEED_LIST,
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.TargetSeed = getSelectedItems(val)
        notif("Target Seed updated", 3, "Auto Roll")
    end
})
RollSection:AddDropdown({
    Title = "Target Rarity",
    Content = "Buy ANY seed that matches these rarities",
    Options = RARITY_LIST,
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.TargetRarity = getSelectedItems(val)
        notif("Target Rarity updated", 3, "Auto Roll")
    end
})


-- ─── TAB AUTO ───
local AutoTab = Tabs:AddTab({ Name = "Automatically", Icon = "next" })

-- Auto Gear Section
local GearSection = AutoTab:AddSection("Auto Buy Gear")
GearSection:AddDropdown({
    Title = "Select Gear",
    Content = "Select one or more gears to automatically buy",
    Options = GEAR_LIST,
    Default = {},
    Multi = true,
    Callback = function(val)
        Config.TargetGear = getSelectedItems(val)
        notif("Target Gear updated", 3, "Auto")
    end
})
GearSection:AddToggle({
    Title = "Auto Buy Gear",
    Title2 = "Enable",
    Content = "Automatically buys the specified gear",
    Default = false,
    Callback = function(val)
        Config.AutoBuyGear = val
        notif("Auto Buy Gear " .. (val and "ON" or "OFF"), 3, "Auto")
    end
})

-- Auto Egg Section
local EggSection = AutoTab:AddSection("Auto Buy Egg")
EggSection:AddDropdown({
    Title = "Select Egg",
    Content = "Select one or more eggs to automatically buy",
    Options = EGG_LIST,
    Default = {},
    Multi = true,
    Callback = function(val)
        Config.TargetEgg = getSelectedItems(val)
        notif("Target Egg updated", 3, "Auto")
    end
})
EggSection:AddToggle({
    Title = "Auto Buy Egg",
    Title2 = "Enable",
    Content = "Automatically buys the selected eggs",
    Default = false,
    Callback = function(val)
        Config.AutoBuyEgg = val
        notif("Auto Buy Egg " .. (val and "ON" or "OFF"), 3, "Auto")
    end
})

-- Auto Sell Crate Section
local CrateSection = AutoTab:AddSection("Auto Sell Crate")
CrateSection:AddToggle({
    Title = "Auto Sell Crate",
    Title2 = "Enable",
    Content = "Automatically sells held crates",
    Default = false,
    Callback = function(val)
        Config.AutoSellCrate = val
        notif("Auto Sell Crate " .. (val and "ON" or "OFF"), 3, "Auto")
    end
})

-- Auto Smart Plant Section
local SmartPlantSection = AutoTab:AddSection("Auto Smart Plant")
SmartPlantSection:AddDropdown({
    Title = "Target Seed",
    Content = "Select seed to auto plant",
    Options = SEED_LIST,
    Default = "None",
    Multi = false,
    Callback = function(val)
        Config.TargetSmartPlant = type(val) == "table" and val[1] or val
        notif("Smart Plant Target set to " .. tostring(Config.TargetSmartPlant), 3, "Auto")
    end
})
SmartPlantSection:AddToggle({
    Title = "Auto Smart Plant",
    Title2 = "Enable",
    Content = "Equips target seed, removes unwanted seeds, and plants them automatically",
    Default = false,
    Callback = function(val)
        Config.AutoSmartPlant = val
        notif("Auto Smart Plant " .. (val and "ON" or "OFF"), 3, "Auto")
        if val then
            task.spawn(function()
                while Config.AutoSmartPlant do
                    if Config.TargetSmartPlant ~= "None" then
                        local player = game:GetService("Players").LocalPlayer
                        local char = player.Character
                        local backpack = player:FindFirstChild("Backpack")
                        local hasSeed = false
                        
                        if char and backpack then
                            local equippedTool = char:FindFirstChildWhichIsA("Tool")
                            if equippedTool and (equippedTool.Name:find(Config.TargetSmartPlant) or equippedTool:GetAttribute("Plant") == Config.TargetSmartPlant) then
                                hasSeed = true
                            else
                                for _, tool in pairs(backpack:GetChildren()) do
                                    if tool:IsA("Tool") and (tool.Name:find(Config.TargetSmartPlant) or tool:GetAttribute("Plant") == Config.TargetSmartPlant) then
                                        if char:FindFirstChild("Humanoid") then
                                            char.Humanoid:EquipTool(tool)
                                            task.wait(0.5) -- Wait for server replication
                                            hasSeed = true
                                        end
                                        break
                                    end
                                end
                            end
                        end
                        
                        if hasSeed then
                            local myPlot
                            local plotsFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Plots")
                            if plotsFolder then
                                for _, p in ipairs(plotsFolder:GetChildren()) do
                                    if p:GetAttribute("OwnerUserId") == player.UserId or tonumber(p:GetAttribute("OwnerUserId")) == player.UserId then
                                        myPlot = p
                                        break
                                    end
                                end
                            end
                            if myPlot then
                                local hrp = char:FindFirstChild("HumanoidRootPart")
                                local originalCFrame = hrp and hrp.CFrame
                                local hasTeleported = false
                                
                                -- Collect all FarmPlots (Floor1 FarmPlot is directly under plot, Floor2+ under FloorX)
                                local farmPlots = {}
                                local fp1 = myPlot:FindFirstChild("FarmPlot")
                                if fp1 then table.insert(farmPlots, fp1) end
                                for i = 2, 10 do
                                    local floorFolder = myPlot:FindFirstChild("Floor" .. i)
                                    if floorFolder then
                                        local fp = floorFolder:FindFirstChild("FarmPlot")
                                        if fp then table.insert(farmPlots, fp) end
                                    end
                                end
                                
                                for _, farmPlot in ipairs(farmPlots) do
                                    for _, plot in ipairs(farmPlot:GetChildren()) do
                                        if plot.Name:match("^Plot") then
                                            local dirt = plot:FindFirstChild("Dirt")
                                            if dirt then
                                                local currentPlant = dirt:GetAttribute("PlantName")
                                                if not currentPlant or currentPlant == "" then
                                                    if hrp then
                                                        hrp.Anchored = false
                                                        hrp.CFrame = dirt.CFrame * CFrame.new(0, 3, 0)
                                                        hasTeleported = true
                                                        task.wait(0.2)
                                                    end
                                                    pcall(function()
                                                        game:GetService("ReplicatedStorage").Remotes.PlantSeed:FireServer(dirt)
                                                    end)
                                                    task.wait(0.15)
                                                end
                                            end
                                        end
                                    end
                                end
                                
                                if hrp and originalCFrame and hasTeleported then
                                    hrp.CFrame = originalCFrame
                                end
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

-- Auto Upgrade Seed Section
local UpgradeSection = AutoTab:AddSection("Auto Upgrade Seed")
UpgradeSection:AddDropdown({
    Title = "Target Seed",
    Content = "Select seed to auto upgrade",
    Options = SEED_LIST,
    Default = "None",
    Multi = false,
    Callback = function(val)
        Config.TargetUpgradeSeed = type(val) == "table" and val[1] or val
        notif("Auto Upgrade Target set to " .. tostring(Config.TargetUpgradeSeed), 3, "Auto")
    end
})
UpgradeSection:AddInput({
    Title = "Target Level",
    Content = "Input max level to upgrade to (e.g. 50)",
    Default = "1",
    Callback = function(val)
        local level = tonumber(val) or 1
        Config.TargetUpgradeLevel = level
        notif("Auto Upgrade Level set to " .. tostring(level), 3, "Auto")
    end
})
UpgradeSection:AddToggle({
    Title = "Auto Upgrade Seed",
    Title2 = "Enable",
    Content = "Automatically upgrades the targeted seed up to the specified level",
    Default = false,
    Callback = function(val)
        Config.AutoUpgradeSeed = val
        notif("Auto Upgrade Seed " .. (val and "ON" or "OFF"), 3, "Auto")
        if val then
            task.spawn(function()
                local player = game:GetService("Players").LocalPlayer
                local activeLoops = {} -- track dirt instances with active loops
                
                while Config.AutoUpgradeSeed do
                    if Config.TargetUpgradeSeed ~= "None" and Config.TargetUpgradeLevel > 1 then
                        local myPlot
                        local plotsFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Plots")
                        if plotsFolder then
                            for _, p in ipairs(plotsFolder:GetChildren()) do
                                if p:GetAttribute("OwnerUserId") == player.UserId or tonumber(p:GetAttribute("OwnerUserId")) == player.UserId then
                                    myPlot = p
                                    break
                                end
                            end
                        end
                        
                        if myPlot then
                            local farmPlots = {}
                            local fp1 = myPlot:FindFirstChild("FarmPlot")
                            if fp1 then table.insert(farmPlots, fp1) end
                            for i = 2, 10 do
                                local floorFolder = myPlot:FindFirstChild("Floor" .. i)
                                if floorFolder then
                                    local fp = floorFolder:FindFirstChild("FarmPlot")
                                    if fp then table.insert(farmPlots, fp) end
                                end
                            end
                            
                            for _, farmPlot in ipairs(farmPlots) do
                                local stage = farmPlot:GetAttribute("FarmPlotStage") or 999
                                for _, plotModel in ipairs(farmPlot:GetChildren()) do
                                    if plotModel:IsA("Model") and plotModel.Name:match("^Plot%d+$") then
                                        local plotNum = tonumber(plotModel.Name:match("(%d+)$"))
                                        if plotNum and plotNum <= stage then
                                            local dirt = plotModel:FindFirstChild("Dirt")
                                            if dirt and not activeLoops[dirt] then
                                                activeLoops[dirt] = true
                                                task.spawn(function()
                                                    -- Read starting level from attribute once, then track via return value
                                                    local trackedLevel = dirt:GetAttribute("PlantLevel") or 1
                                                    
                                                    while Config.AutoUpgradeSeed and dirt.Parent do
                                                        local plantName = dirt:GetAttribute("PlantName")
                                                        if plantName == Config.TargetUpgradeSeed and trackedLevel < Config.TargetUpgradeLevel then
                                                            local ok, newLevel = pcall(function()
                                                                return game:GetService("ReplicatedStorage").Remotes.UpgradePlant:InvokeServer(dirt)
                                                            end)
                                                            -- InvokeServer returns (success, newLevel) - use it to track real level
                                                            if ok and type(newLevel) == "number" then
                                                                trackedLevel = newLevel
                                                            elseif ok and newLevel then
                                                                trackedLevel = trackedLevel + 1
                                                            end
                                                            task.wait(0.05)
                                                        else
                                                            -- Seed changed or target reached - reset tracked level for next seed
                                                            trackedLevel = dirt:GetAttribute("PlantLevel") or 1
                                                            task.wait(0.3)
                                                        end
                                                    end
                                                    activeLoops[dirt] = nil
                                                end)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(1) -- Scan for new dirt every 1 second
                end
                
                -- Cleanup: clear loop tracker
                for dirt in pairs(activeLoops) do
                    activeLoops[dirt] = nil
                end
            end)
        end
    end
})

-- ─── TAB MISC ───
local MiscTab = Tabs:AddTab({ Name = "Miscellaneous", Icon = "rod" })

local GeneralMiscSection = MiscTab:AddSection("General")
GeneralMiscSection:AddToggle({
    Title = "Anti-AFK",
    Title2 = "Enable",
    Content = "Prevents you from being kicked for inactivity",
    Default = true,
    Callback = function(val)
        Config.AntiAFK = val
        notif("Anti-AFK " .. (val and "ON" or "OFF"), 3, "Misc")
    end
})

local ExploitSection = MiscTab:AddSection("Exploit Settings")

ExploitSection:AddParagraph({
    Title = "⚠️ WARNING",
    Content = "HIGH RISK! Using this exploit can lead to your account getting permanently banned. Use it at your own risk."
})

ExploitSection:AddButton({
    Title = "Exploit Token",
    Content = "Execute the exploit manually",
    Callback = function()
        executeBuy()
    end
})

local PLANT_RUSH_ITEMS = {
    "NormalFertilizer", "BasicPetTreat", "TimeSkip1m", "AcidSpray", "TimeSkip2m", 
    "WetSpray", "StrongFertilizer", "RushrootSeed", "FrozenSpray", "TimeSkip5m", 
    "TropicalSeedPack", "AutumnSpray", "SuperPetTreat", "VoidSpray", 
    "RadioactiveSpray", "RainbowSpray", "CosmicSpray"
}

ExploitSection:AddDropdown({
    Title = "Plant Rush Target Item",
    Content = "Select items to fast buy from Plant Rush (multi-select)",
    Options = PLANT_RUSH_ITEMS,
    Default = {"CosmicSpray"},
    Multi = true,
    Callback = function(val)
        Config.TargetPlantRushItems = getSelectedItems(val)
        notif("Plant Rush Target: " .. #Config.TargetPlantRushItems .. " item(s) selected", 3, "Exploit")
    end
})

ExploitSection:AddToggle({
    Title = "Auto Fast Buy Plant Rush",
    Title2 = "Enable",
    Content = "Instantly loop-buys the selected Plant Rush items using NaN exploit",
    Default = false,
    Callback = function(val)
        Config.FastBuyPlantRush = val
        if val then
            task.spawn(function()
                while Config.FastBuyPlantRush do
                    local items = Config.TargetPlantRushItems or {}
                    if #items > 0 then
                        -- Fire each selected item in parallel (5 shots each per frame)
                        for _, itemName in ipairs(items) do
                            for i = 1, 5 do
                                task.spawn(function()
                                    pcall(function()
                                        ReplicatedStorage.Remotes.PlantRush.BuyShopItem:InvokeServer(itemName, 1)
                                    end)
                                end)
                            end
                        end
                    end
                    task.wait()
                end
            end)
        end
        notif("Auto Fast Buy Plant Rush " .. (val and "ON" or "OFF"), 3, "Exploit")
    end
})

-- ============================================================
-- ANTI-LAG & AUTO-COLLECT SYSTEM
-- ============================================================
local AntiLagHooks = {}

local function InitAntiLag()
    local pGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    -- 1. Blokir Paksa Notifikasi di MainUI yang bernama "PopUp" (100% Ampuh)
    local mainUI = pGui:WaitForChild("MainUI", 5)
    if mainUI then
        -- Tangkap PopUp tepat saat mau muncul dan hancurkan
        table.insert(AntiLagHooks, mainUI.ChildAdded:Connect(function(child)
            if Config.FastBuyPlantRush and child.Name == "PopUp" then
                task.defer(function() pcall(function() child.Visible = false; child:Destroy() end) end)
            end
        end))
        
        -- Loop pembersihan untuk membasmi sisa PopUp yang lolos
        task.spawn(function()
            while true do
                task.wait(0.05)
                if Config.FastBuyPlantRush then
                    for _, child in pairs(mainUI:GetChildren()) do
                        if child.Name == "PopUp" then
                            child.Visible = false
                            child:Destroy()
                        end
                    end
                end
            end
        end)
    end
    
    -- 2. Hapus teks melayang 3D (BillboardGui $5.04Qn dll) di Workspace & Karakter
    table.insert(AntiLagHooks, workspace.DescendantAdded:Connect(function(desc)
        if Config.FastBuyPlantRush then
            if desc:IsA("BillboardGui") or desc:IsA("ParticleEmitter") or desc:IsA("Trail") then
                task.defer(function() pcall(function() desc:Destroy() end) end)
            end
        end
    end))
    
    -- 3. Hapus Notifikasi Layar Lainnya (Fallback)
    table.insert(AntiLagHooks, pGui.DescendantAdded:Connect(function(desc)
        if Config.FastBuyPlantRush then
            if desc:IsA("TextLabel") or desc:IsA("TextButton") then
                local text = string.lower(desc.Text)
                if text:find("collected") or text:find("time skip") or text:find("tokens") then
                    task.defer(function()
                        pcall(function()
                            if desc.Parent and not desc:IsAncestorOf(pGui:FindFirstChild("NapoleonRollLog")) then
                                local parent = desc.Parent
                                if parent:IsA("Frame") or parent:IsA("ScreenGui") then
                                    parent:Destroy()
                                else
                                    desc:Destroy()
                                end
                            end
                        end)
                    end)
                end
            end
        end
    end))
    
    -- 4. Auto-Collect Uang / Item Drops (Mencegah lag fisik)
    table.insert(AntiLagHooks, workspace.ChildAdded:Connect(function(obj)
        if Config.FastBuyPlantRush then
            task.defer(function()
                pcall(function()
                    if obj:IsA("Model") or obj:IsA("Part") or obj:IsA("MeshPart") then
                        if not game.Players:GetPlayerFromCharacter(obj) then
                            if obj.Name:lower():find("coin") or obj.Name:lower():find("money") or obj.Name:lower():find("drop") or obj:FindFirstChildOfClass("BillboardGui", true) then
                                local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    if obj:IsA("Model") then
                                        if obj.PrimaryPart then
                                            obj:PivotTo(hrp.CFrame)
                                        else
                                            for _, part in pairs(obj:GetChildren()) do
                                                if part:IsA("BasePart") then part.CFrame = hrp.CFrame end
                                            end
                                        end
                                    elseif obj:IsA("BasePart") then
                                        obj.CFrame = hrp.CFrame
                                    end
                                end
                                
                                for _, desc in pairs(obj:GetDescendants()) do
                                    if desc:IsA("BillboardGui") or desc:IsA("ParticleEmitter") or desc:IsA("Trail") then
                                        desc:Destroy()
                                    elseif desc:IsA("BasePart") then
                                        desc.Transparency = 1
                                    end
                                end
                            end
                        end
                    end
                end)
            end)
        end
    end))
end

InitAntiLag()

local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

_G.ScriptFullyLoaded = true
notif("Script loaded successfully!", 4, "Napoleon")
