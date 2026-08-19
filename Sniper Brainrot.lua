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
--                 .. "?script=brainrot-sniper"
--                 .. "&userid=" .. userid
--                 .. "&username=" .. username
--                 .. "&executor=" .. (executor:gsub(" ", "%%20"))
--                 .. "&placeid=" .. placeid
--                 .. "&key=" .. key
                
--             game:HttpGet(url)
--         end
--     end)
-- end)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Fdhlnn23/NapoleonUI/refs/heads/main/NPLN-UIv4.lua"))()

local Config = {
    AutoFarm = false,
    AutoSnipeBalloon = false,
    TargetBrainrot = { ["None"] = true },
    TargetMutation = { ["None"] = true },
    TargetRarity   = { ["None"] = true },
    AutoFuse       = false,
    TargetFuseBrainrot = "None",
    AutoGift            = false,
    GiftTargetPlayer    = "",
    GiftTargetBrainrot  = "None",
    GiftTargetRarity    = "None",
    GiftTargetMutation  = "None",
    GiftAmount          = 1,
    AutoAcceptGift      = false,
    AutoUpgrade         = false,
    UpgradeTargetLevel  = 10,
}

-- ==========================================
-- ANTI-AFK
-- ==========================================
local LocalPlayer = game:GetService("Players").LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local BRAINROT_ID_MAP = {
    [1]="Tung Tung Tung Sahur",[2]="StrawberryElephant",[3]="Boneca Ambalabu",[4]="Bombombini Gusini",[5]="John Pork",[6]="Ballerina Cappuccina",[7]="Brr Brr Patapim",[8]="Lirili Larila",[9]="Orangutini Ananassini",[10]="Cappuccino Assassino",
    [11]="Pakrahmatmamat",[12]="Pipi Avocado",[13]="Karkerkar Kurkur",[14]="Trippi Troppi",[15]="67",[16]="TimCheese",[17]="Los Tung Tung Tung Citos",[18]="La Vacca Saturno Saturnita",[19]="Mastodontico Telepiedone",[20]="Tralalero Tralala",
    [21]="Tralalerita Tralala",[22]="Pipi Kiwi",[23]="Bananita Dolphinita",[24]="FluriFlura",[25]="Glorbo Fruttodrillo",[26]="Meowl",[27]="Odin Din Din Dun",[28]="Strawberrelli Flamingelli",[29]="Penguino Cocosino",[30]="Frigo Camelo",
    [31]="TipiTopiTaco",[32]="Cacto Hipopotamo",[33]="Matteo",[34]="SwagSoda",[35]="Tatata Sahur",[36]="Chimpanzini Spiderini",[37]="Los Bros",[38]="Ketupat Kepat",[39]="EsokSekolah",[40]="Dragon",
    [41]="ChillinChilli",[42]="Burguro And Fryuro",[43]="CapiTaco",[44]="Chimpanzini Bananini",[45]="Rhino Toasterino",[46]="Ganganzelli Trulala",[47]="GaramaAndMadundung",[48]="CookiAndMilki",[49]="OrcaleroOrcala",[50]="Orcalita Orcala",
    [51]="Bisonte Giuppitere",[52]="Agarrini La Palini",[53]="Antonio",[54]="Lavadorito Spinito",[55]="Alessio",[56]="Bambini Crostini",[57]="Zibra Zubra Zibralini",[58]="Bandito Axolito",[59]="Trenostruzzo Turbo 3000",[60]="Los Tralaleritos",
    [61]="Urubini Flamenguini",[62]="Carrotini Brainini",[63]="Brr es Teh Patipum",[64]="Tukanno Bananno",[65]="Bombardiro Crocodilo",[66]="Tric Trac Baraboom",[67]="Bulbito Bandito Traktorito",[68]="LosCrocodillitos",[69]="Cavallo Virtuoso",[70]="Ta Ta Ta Ta Sahur",
    [71]="Burbaloni Loliloli",[72]="Te Te Te Sahur",[73]="Svinina Bombardino",[74]="Brri Brri Bicus Dicus Bombicus",[75]="Talpa Di Fero",[76]="Cacasito Satalito",
    [77]="Esok Sekolah",[78]="Pipi Potato",[79]="Chicleteira Bicicleteira",[80]="Quivioli Ameleonni",[81]="Sigma Boy",[82]="Sigma Girl",[83]="Dul Dul Dul",
    [2000]="Pandaccini Bananini",[2001]="Cocofanto Elefanto",[3001]="SneakyTralalaeritos",[3002]="Spaghetti Tualetti",[3003]="LosMatteos",[3004]="Trulimero Trulicina",[3005]="Tictac Sahur",[3006]="PotHotspot",[3007]="Gangster Footera",
    [4001]="Avocadini Guffo",[4002]="Avocadini Antilopini",[4003]="Avocadorilla",[4004]="Blackhole Goat",[4005]="Spioniro Golubiro"
}

local BRAINROT_RARITY_MAP = {
    [1]=1,[2]=2,[3]=1,[4]=1,[5]=1,[6]=1,[7]=1,[8]=2,[9]=2,[10]=2,
    [11]=2,[12]=1,[13]=2,[14]=2,[15]=3,[16]=3,[17]=3,[18]=3,[19]=3,[20]=3,
    [21]=3,[22]=4,[23]=4,[24]=4,[25]=4,[26]=4,[27]=4,[28]=4,[29]=4,[30]=4,
    [31]=5,[32]=5,[33]=5,[34]=5,[35]=5,[36]=5,[37]=5,[38]=5,[39]=5,[40]=5,
    [41]=5,[42]=6,[43]=6,[44]=6,[45]=6,[46]=6,[47]=6,[48]=6,[49]=7,[50]=7,
    [51]=7,[52]=7,[53]=7,[54]=7,[55]=7,[56]=8,[57]=8,[58]=8,[59]=8,[60]=8,
    [61]=8,[62]=8,[63]=9,[64]=9,[65]=9,[66]=9,[67]=9,[68]=9,[69]=9,[70]=10,
    [71]=10,[72]=10,[73]=10,[74]=10,[75]=10,[76]=10,
    [77]=11,[78]=11,[79]=11,[80]=11,[81]=11,[82]=11,[83]=11,
    [2000]=101,[2001]=4,[3001]=101,[3002]=101,[3003]=101,[3004]=101,[3005]=101,[3006]=101,[3007]=101,
    [4001]=101,[4002]=101,[4003]=101,[4004]=102,[4005]=102
}

local MUTATION_MAP = {
    [1]="Normal", [2]="Gold", [3]="Diamond", [4]="Emerald", [5]="Void", [6]="Rainbow"
}

local RARITY_NAME_MAP = {
    [1]="Common", [2]="Rare", [3]="Epic", [4]="Legendary", [5]="Mythic", [6]="Secret", 
    [7]="Celestial", [8]="Godly", [9]="Divine", [10]="Transcendent", [11]="Cosmic", [101]="Frenzy", [102]="Immortal"
}

local ZONE_CFRAMES = {
    ["Common"]       = CFrame.new(279.68, 191.90, 1474.32) * CFrame.Angles(0, math.rad(19.50), 0),
    ["Rare"]         = CFrame.new(295.17, 181.56, 1301.17) * CFrame.Angles(0, math.rad(5.64), 0),
    ["Epic"]         = CFrame.new(294.47, 173.52, 1091.13) * CFrame.Angles(0, math.rad(-1.44), 0),
    ["Legendary"]    = CFrame.new(294.65, 166.50, 894.31) * CFrame.Angles(0, math.rad(-3.23), 0),
    ["Mythic"]       = CFrame.new(287.85, 160.55, 686.10) * CFrame.Angles(0, math.rad(-3.25), 0),
    ["Secret"]       = CFrame.new(297.42, 154.67, 497.02) * CFrame.Angles(0, math.rad(-1.30), 0),
    ["Celestial"]    = CFrame.new(306.67, 148.97, 295.00) * CFrame.Angles(0, math.rad(-2.89), 0),
    ["Godly"]        = CFrame.new(305.56, 143.18, 94.27) * CFrame.Angles(0, math.rad(-0.18), 0),
    ["Divine"]       = CFrame.new(305.37, 138.55, -100.32) * CFrame.Angles(0, math.rad(0.05), 0),
    ["Transcendent"] = CFrame.new(305.11, 135.67, -305.94) * CFrame.Angles(0, math.rad(-0.18), 0),
    ["Cosmic"]       = CFrame.new(307.21, 161.81, -495.49) * CFrame.Angles(0, math.rad(-0.76), 0)
}

-- Buat list untuk UI Dropdown
local ALL_BRAINROTS = {"None", "All Possible"}
for _, v in pairs(BRAINROT_ID_MAP) do table.insert(ALL_BRAINROTS, v) end
table.sort(ALL_BRAINROTS, function(a, b)
    if a == "None" then return true end
    if b == "None" then return false end
    if a == "All Possible" then return true end
    if b == "All Possible" then return false end
    return a < b
end)

local MUTATION_LIST = {"None", "All Possible"}
for _, v in ipairs(MUTATION_MAP) do table.insert(MUTATION_LIST, v) end

local RARITY_LIST = {"None", "All Possible"}
for _, v in pairs(RARITY_NAME_MAP) do table.insert(RARITY_LIST, v) end

-- Utilities Dropdown
local function parseMultiDropdown(val)
    local dict = {}
    if type(val) == "table" then
        local count = 0
        for k, v in pairs(val) do
            if type(k) == "number" then dict[v] = true; count = count + 1
            elseif v == true then dict[k] = true; count = count + 1 end
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
    if #arr > 1 and table.find(arr, "None") then
        local newArr = {}
        for _, item in ipairs(arr) do if item ~= "None" then table.insert(newArr, item) end end
        arr = newArr
        changed = true
    elseif #arr == 0 then
        arr = {"None"}
        changed = true
    end
    if changed and dropObj then dropObj:Set(arr) end
    return arr
end

-- ==========================================
-- HOOK INSTANT DRONE
-- ==========================================
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if Config.AutoFarm and not checkcaller() then
        if method == "InvokeServer" and tostring(self) == "RF/DroneCapture" then
            local droneUid = args[2]
            if droneUid then
                task.spawn(function()
                    local claimEvent = game:GetService("ReplicatedStorage").Shared.Packages.Net:FindFirstChild("RE/DroneClaim")
                    if claimEvent then
                        claimEvent:FireServer(droneUid)
                    end
                end)
            end
        end
    end
    
    return oldNamecall(self, ...)
end)

-- ==========================================
-- HOOK INSTANT BALLOON
-- ==========================================
local NetPackages = game:GetService("ReplicatedStorage").Shared.Packages.Net
local BalloonSpawn = NetPackages:FindFirstChild("RE/BalloonSpawn")
local BalloonHit = NetPackages:FindFirstChild("RE/BalloonHit")

if BalloonSpawn and BalloonHit then
    BalloonSpawn.OnClientEvent:Connect(function(balloons)
        if Config.AutoSnipeBalloon and type(balloons) == "table" then
            for _, b in ipairs(balloons) do
                if b.id then
                    task.spawn(function()
                        BalloonHit:FireServer(b.id)
                    end)
                end
            end
        end
    end)
end

-- ==========================================
-- ZERO-TICK AUTO SNIPE (HOOK)
-- ==========================================
local BrainrotMoveEvent = NetPackages:FindFirstChild("RE/BrainrotMove")

if BrainrotMoveEvent then
    BrainrotMoveEvent.OnClientEvent:Connect(function(dataList)
        if not Config.AutoFarm then return end
        if type(dataList) ~= "table" then return end
        
        local attackEvent = NetPackages:FindFirstChild("RE/BrainrotAttack")
        local requestEvent = NetPackages:FindFirstChild("RF/DroneRequest")
        local captureEvent = NetPackages:FindFirstChild("RF/DroneCapture")
        local claimEvent = NetPackages:FindFirstChild("RE/DroneClaim")
        
        -- Eksekusi milidetik yang sama saat server mengirim info!
        for _, bData in ipairs(dataList) do
            if not bData.destroy and bData.uid and bData.id then
                local bId = bData.id
                local mId = bData.mutation or 1
                local uid = bData.uid
                
                local bName = BRAINROT_ID_MAP[bId] or "Unknown"
                local mName = MUTATION_MAP[mId] or "Normal"
                local rId = BRAINROT_RARITY_MAP[bId] or 1
                local rName = RARITY_NAME_MAP[rId] or "Common"
                
                if Config.TargetBrainrot["None"] and Config.TargetMutation["None"] and Config.TargetRarity["None"] then
                    continue
                end
                
                local passBrainrot = Config.TargetBrainrot["None"] or Config.TargetBrainrot["All Possible"] or Config.TargetBrainrot[bName]
                local passMutation = Config.TargetMutation["None"] or Config.TargetMutation["All Possible"] or Config.TargetMutation[mName]
                local passRarity = Config.TargetRarity["None"] or Config.TargetRarity["All Possible"] or Config.TargetRarity[rName]
                
                if passBrainrot and passMutation and passRarity then
                    if attackEvent then
                        attackEvent:FireServer(uid)
                    end
                    
                    task.spawn(function()
                        local endPos = bData.position or Vector3.new(0,0,0)
                        if requestEvent then
                            pcall(function()
                                requestEvent:InvokeServer({
                                    startPos = CFrame.new(endPos),
                                    endPos = endPos,
                                    startTick = tick(),
                                    brainrotUid = uid
                                })
                            end)
                        end
                        
                        local droneUid = uid .. "Drone"
                        if captureEvent then
                            pcall(function() captureEvent:InvokeServer(uid, droneUid) end)
                        end
                        if claimEvent then
                            pcall(function() claimEvent:FireServer(droneUid) end)
                        end
                    end)
                end
            end
        end
    end)
end

-- ==========================================
-- LOGIC INSTANT KILL (FAILSAFE LOOP)
-- ==========================================
local farmLoop = false

local function startInstantKill()
    if farmLoop then return end
    farmLoop = true
    
    local attackEvent = game:GetService("ReplicatedStorage").Shared.Packages.Net:FindFirstChild("RE/BrainrotAttack")
    if not attackEvent then
        if Library and Library.MakeNotify then
            Library:MakeNotify({Title = "Error", Content = "RE/BrainrotAttack tidak ditemukan!", Delay = 3})
        end
        farmLoop = false
        return
    end

    local function getTargetCFrame()
        local highestNum = 0
        local bestRarity = nil
        
        if not Config.TargetRarity["None"] and not Config.TargetRarity["All Possible"] then
            for rName, _ in pairs(Config.TargetRarity) do
                for id, name in pairs(RARITY_NAME_MAP) do
                    if name == rName then
                        local n = id
                        if n == 101 then n = 11 end
                        if n == 102 then n = 12 end
                        if n > highestNum then 
                            highestNum = n 
                            bestRarity = name
                        end
                    end
                end
            end
        end
        
        if not Config.TargetBrainrot["None"] and not Config.TargetBrainrot["All Possible"] then
            for bName, _ in pairs(Config.TargetBrainrot) do
                local bId
                for id, name in pairs(BRAINROT_ID_MAP) do
                    if name == bName then
                        bId = id
                        break
                    end
                end
                if bId then
                    local rId = BRAINROT_RARITY_MAP[bId]
                    local rName = RARITY_NAME_MAP[rId]
                    local n = rId
                    if n == 101 then n = 11 end
                    if n == 102 then n = 12 end
                    if n > highestNum then
                        highestNum = n
                        bestRarity = rName
                    end
                end
            end
        end
        
        if not bestRarity then
            return ZONE_CFRAMES["Common"]
        end
        
        if ZONE_CFRAMES[bestRarity] then
            return ZONE_CFRAMES[bestRarity]
        elseif highestNum >= 10 then
            return ZONE_CFRAMES["Transcendent"]
        else
            return ZONE_CFRAMES["Common"]
        end
    end

    task.spawn(function()
        while Config.AutoFarm and farmLoop do
            pcall(function()
                -- TELEPORT LOGIC
                local hrp = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local targetCFrame = getTargetCFrame()
                    if targetCFrame then
                        -- Hanya teleport jika jaraknya jauh (biar tidak patah-patah kalau sudah di lokasi)
                        if (hrp.Position - targetCFrame.Position).Magnitude > 20 then
                            if not originalCFrame then originalCFrame = hrp.CFrame end
                            hrp.Anchored = false
                            hrp.CFrame = targetCFrame
                            -- Tunggu 1 detik agar jatuh menginjak tanah dan map selesai merender
                            task.wait(1) 
                        end
                        -- Setelah mendarat dengan aman, kunci posisinya
                        hrp.Anchored = true
                    end
                end

                local modelsFolder = workspace:FindFirstChild("GameFolder") and workspace.GameFolder:FindFirstChild("BrainrotModels")
                if modelsFolder then
                    for _, model in ipairs(modelsFolder:GetChildren()) do
                        local bId = model:GetAttribute("BrainrotId")
                        local mId = model:GetAttribute("BrainrotMutation") or 1 -- Default ke Normal jika tidak ada
                        local uid = model:GetAttribute("Uid") or model.Name
                        
                        if bId and uid then
                            local bName = BRAINROT_ID_MAP[bId] or "Unknown"
                            local mName = MUTATION_MAP[mId] or "Normal"
                            local rId = BRAINROT_RARITY_MAP[bId] or 1
                            local rName = RARITY_NAME_MAP[rId] or "Common"
                            
                            -- Cek Filter (Abaikan target jika filter diset ke "None" KECUALI kalau semuanya None berarti tidak nyerang)
                            -- Jika filter = "All Possible", serang semuanya.
                            -- Perbaikan logika: Jika kita set "None", itu berarti kita TIDAK mengecek parameter tersebut.
                            -- Namun jika semua diset None, jangan jalankan script agar tidak mati semua.
                            
                            if Config.TargetBrainrot["None"] and Config.TargetMutation["None"] and Config.TargetRarity["None"] then
                                return -- Do nothing jika filter masih default
                            end
                            
                            local passBrainrot = Config.TargetBrainrot["None"] or Config.TargetBrainrot["All Possible"] or Config.TargetBrainrot[bName]
                            local passMutation = Config.TargetMutation["None"] or Config.TargetMutation["All Possible"] or Config.TargetMutation[mName]
                            local passRarity = Config.TargetRarity["None"] or Config.TargetRarity["All Possible"] or Config.TargetRarity[rName]
                            
                            if passBrainrot and passMutation and passRarity then
                                -- Tembak!
                                attackEvent:FireServer(uid)
                                
                                -- Request Drone agar dikirim dari server
                                task.spawn(function()
                                    local net = game:GetService("ReplicatedStorage").Shared.Packages.Net
                                    local requestEvent = net:FindFirstChild("RF/DroneRequest")
                                    local captureEvent = net:FindFirstChild("RF/DroneCapture")
                                    local claimEvent = net:FindFirstChild("RE/DroneClaim")
                                    
                                    local endPos = Vector3.new(0, 0, 0)
                                    pcall(function() endPos = model:GetPivot().Position end)
                                    
                                    -- 1. Request Drone: Lempar koordinat jauh ke dalam tanah (VOID) agar tidak terlihat siapa pun
                                    if requestEvent then
                                        pcall(function()
                                            requestEvent:InvokeServer({
                                                startPos = CFrame.new(endPos.X, -10000, endPos.Z),
                                                endPos = Vector3.new(endPos.X, -10000, endPos.Z),
                                                startTick = tick(),
                                                brainrotUid = uid
                                            })
                                        end)
                                    end
                                    
                                    -- 2. Langsung paksa Capture tanpa nunggu animasi
                                    local droneUid = uid .. "Drone"
                                    if captureEvent then
                                        pcall(function()
                                            captureEvent:InvokeServer(uid, droneUid)
                                        end)
                                    end
                                    
                                    -- 3. Langsung Claim Drone!
                                    if claimEvent then
                                        pcall(function()
                                            claimEvent:FireServer(droneUid)
                                        end)
                                    end
                                end)
                                
                                task.wait(0.01) -- delay super cepat untuk multi-kill
                            end
                        end
                    end
                end
            end)
            task.wait(1) -- Looping pencarian model tiap 1 detik (karena Hook 0-Tick sudah handle 99%)
        end
        farmLoop = false
    end)
end

-- ==========================================
-- UI SETUP
-- ==========================================
local MarketplaceService = game:GetService("MarketplaceService")

local GameName = "Unknown"

pcall(function()
    GameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

local Window = Library:Window({
    Title    = "Napoleon",
    Footer   = GameName,
    Color    = Color3.fromRGB(81, 66, 255),
    Color2   = Color3.fromRGB(0, 0, 14),
    ["Tab Width"] = 130,
    Image      = "111895858615511",
    WindowIMG  = "91334002283698",
    LogoHUB    = "136289055140268"
})

local Tabs = Window

local MainTab = Tabs:AddTab({ Name = "Main", Icon = "rod" })
local FarmSection = MainTab:AddSection("Auto Farm (Instant Kill)")

local originalCFrame = nil

FarmSection:AddToggle({
    Title   = "Auto Farm",
    Title2  = "Enable",
    Content = "Automatically instant-kill brainrots matching filters",
    Default = false,
    Callback = function(val)
        Config.AutoFarm = val
        if val then
            pcall(function()
                local hrp = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    originalCFrame = hrp.CFrame
                end
            end)
            
            startInstantKill()
            if Library and Library.MakeNotify then
                Library:MakeNotify({ Title = "Auto Farm", Content = "Sniper (Instant Kill) ON ✅", Delay = 2 })
            end
        else
            farmLoop = false
            pcall(function()
                local hrp = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then 
                    hrp.Anchored = false 
                    if originalCFrame then
                        hrp.CFrame = originalCFrame
                        originalCFrame = nil
                    end
                end
            end)
            if Library and Library.MakeNotify then
                Library:MakeNotify({ Title = "Auto Farm", Content = "Sniper OFF", Delay = 2 })
            end
        end
    end,
})

FarmSection:AddToggle({
    Title   = "Auto Snipe Balloon",
    Title2  = "Enable",
    Content = "Automatically snipe all spawned balloons globally",
    Default = false,
    Callback = function(val)
        Config.AutoSnipeBalloon = val
        if Library and Library.MakeNotify then
            if val then
                Library:MakeNotify({ Title = "Auto Snipe Balloon", Content = "Auto Snipe Balloon ON 🎈", Delay = 2 })
            else
                Library:MakeNotify({ Title = "Auto Snipe Balloon", Content = "Auto Snipe Balloon OFF", Delay = 2 })
            end
        end
    end,
})

local dropBrainrot
dropBrainrot = FarmSection:AddDropdown({
    Title   = "Target Brainrot",
    Content = "Select specific brainrot names (Multi-select)",
    Options = ALL_BRAINROTS,
    Default = {"None"},
    Multi   = true,
    Callback = function(val)
        local arr = handleDropdownChange(val, dropBrainrot)
        Config.TargetBrainrot = parseMultiDropdown(arr)
    end,
})

local dropMutasi
dropMutasi = FarmSection:AddDropdown({
    Title   = "Target Mutation",
    Content = "Select specific mutations (Multi-select)",
    Options = MUTATION_LIST,
    Default = {"None"},
    Multi   = true,
    Callback = function(val)
        local arr = handleDropdownChange(val, dropMutasi)
        Config.TargetMutation = parseMultiDropdown(arr)
    end,
})

local dropRarity
dropRarity = FarmSection:AddDropdown({
    Title   = "Target Rarity",
    Content = "Select specific rarities (Multi-select)",
    Options = RARITY_LIST,
    Default = {"None"},
    Multi   = true,
    Callback = function(val)
        local arr = handleDropdownChange(val, dropRarity)
        Config.TargetRarity = parseMultiDropdown(arr)
    end,
})

-- ==========================================
-- AUTO FUSE TAB & LOGIC
-- ==========================================
local AutoTab = Tabs:AddTab({ Name = "Auto", Icon = "scroll" })
local FuseSection = AutoTab:AddSection("Auto Fuse System")

local autoFuseLoop = false
local function startAutoFuse()
    if autoFuseLoop then return end
    autoFuseLoop = true
    
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local BrainrotController = nil
    local PlayerFlagData = nil
    
    pcall(function()
        BrainrotController = require(ReplicatedStorage.Shared.Controller.BrainrotController)
        PlayerFlagData = require(ReplicatedStorage.Shared.Data.PlayerFlagData)
    end)
    
    local FuseEvent = ReplicatedStorage.Shared.Packages.Net:FindFirstChild("RF/FuseBrainrot")
    
    if not BrainrotController or not FuseEvent then
        if Library and Library.MakeNotify then
            Library:MakeNotify({Title = "Error", Content = "Fuse Controller / Remote tidak ditemukan!", Delay = 3})
        end
        autoFuseLoop = false
        return
    end
    
    task.spawn(function()
        while Config.AutoFuse and autoFuseLoop do
            task.wait(2) -- Delay scan inven tiap 2 detik biar aman dari lag
            pcall(function()
                if Config.TargetFuseBrainrot == "None" then return end
                
                local targetId = nil
                if Config.TargetFuseBrainrot ~= "All Possible" then
                    for id, name in pairs(BRAINROT_ID_MAP) do
                        if name == Config.TargetFuseBrainrot then
                            targetId = id
                            break
                        end
                    end
                    if not targetId then return end
                end
                
                local invList = BrainrotController.GetBrainrotList()
                local grouped = {}
                
                for _, b in ipairs(invList) do
                    local isTarget = (Config.TargetFuseBrainrot == "All Possible") or (b.id == targetId)
                    if isTarget then
                        -- Jangan Fuse yang sedang dipakai (di-equip)
                        if not BrainrotController.IsEquipped(b.uid) then
                            local bId = b.id
                            local mut = b.mutation or 1
                            if mut < 6 then -- Fuse Normal(1), Gold(2), Diamond(3), Emerald(4), Void(5)
                                if not grouped[bId] then grouped[bId] = { [1]={}, [2]={}, [3]={}, [4]={}, [5]={} } end
                                table.insert(grouped[bId][mut], b.uid)
                            end
                        end
                    end
                end
                
                local reqCount = 5
                if PlayerFlagData then
                    reqCount = PlayerFlagData:GetFlag("gamepass_6") and 3 or 5
                end
                
                for bId, mutGroups in pairs(grouped) do
                    if not Config.AutoFuse then break end
                    
                    -- Iterasi dari Normal -> Gold -> Diamond -> Emerald -> Void
                    for mut = 1, 5 do
                        local uids = mutGroups[mut]
                        while #uids >= reqCount do
                            if not Config.AutoFuse then break end
                            local batch = {}
                            for i = 1, reqCount do
                                table.insert(batch, table.remove(uids)) -- Ambil dari belakang list
                            end
                            FuseEvent:InvokeServer(batch)
                            task.wait(0.5) -- Delay perlahan tiap fuse biar lolos validasi server
                        end
                    end
                end
            end)
        end
        autoFuseLoop = false
    end)
end

-- ==========================================
-- AUTO GIFT (TRADE) SYSTEM
-- ==========================================
local autoGiftLoop = false
local function startAutoGift()
    if autoGiftLoop then return end
    autoGiftLoop = true
    
    local GiveGiftRequest = NetPackages:FindFirstChild("RE/GiveGiftRequest")
    
    task.spawn(function()
        while Config.AutoGift and autoGiftLoop do
            task.wait(2)
            pcall(function()
                if not Config.GiftTargetPlayer or Config.GiftTargetPlayer == "" or Config.GiftTargetPlayer == "None" then return end
                if Config.GiftAmount < 0 then return end
                
                local targetId = nil
                for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
                    if p.Name:lower():sub(1, #Config.GiftTargetPlayer) == Config.GiftTargetPlayer:lower() then
                        targetId = p.UserId
                        break
                    end
                end
                
                if not targetId then return end
                
                local bIdTarget = nil
                if Config.GiftTargetBrainrot ~= "All Possible" and Config.GiftTargetBrainrot ~= "None" then
                    bIdTarget = Config.GiftTargetBrainrot
                end
                
                local rIdTarget = nil
                if Config.GiftTargetRarity ~= "All Possible" and Config.GiftTargetRarity ~= "None" then
                    rIdTarget = Config.GiftTargetRarity
                end
                
                local mIdTarget = nil
                if Config.GiftTargetMutation ~= "All Possible" and Config.GiftTargetMutation ~= "None" then
                    mIdTarget = Config.GiftTargetMutation
                end
                
                -- Skip jika ketiganya None
                if not bIdTarget and not rIdTarget and not mIdTarget then return end
                
                local giftedThisTick = 0
                local backpack = game:GetService("Players").LocalPlayer:FindFirstChild("Backpack")
                if not backpack then return end
                
                for _, tool in ipairs(backpack:GetChildren()) do
                    if not Config.AutoGift then break end
                    if Config.GiftAmount > 0 and giftedThisTick >= Config.GiftAmount then break end
                    
                    if tool:IsA("Tool") and tool:GetAttribute("Type") == "Brainrot" then
                        local function trim(s)
                            return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
                        end
                        
                        -- Ambil atribut dari Backpack dan hapus tag HTML-nya
                        local rawName = tool:GetAttribute("toolName") or ""
                        local plainName = trim(string.gsub(rawName, "<[^>]+>", ""))
                        
                        local rawMut = tool:GetAttribute("Mutation")
                        local plainMut = "Normal"
                        if rawMut and type(rawMut) == "string" and rawMut ~= "" then
                            plainMut = trim(string.gsub(rawMut, "<[^>]+>", ""))
                        end
                        
                        -- Cari Rarity berdasarkan nama
                        local bId = nil
                        for id, name in pairs(BRAINROT_ID_MAP) do
                            if name:lower() == plainName:lower() then
                                bId = id
                                break
                            end
                        end
                        
                        local plainRarity = "Common"
                        if bId then
                            local rId = BRAINROT_RARITY_MAP[bId] or 1
                            -- Antisipasi custom ID (Frenzy/Immortal)
                            if rId == 101 then rId = 11 end
                            if rId == 102 then rId = 12 end
                            plainRarity = RARITY_NAME_MAP[rId] or "Common"
                        end
                        
                        local passBrainrot = (not bIdTarget or plainName:lower() == bIdTarget:lower())
                        local passMutation = (not mIdTarget or plainMut:lower() == mIdTarget:lower())
                        local passRarity   = (not rIdTarget or plainRarity:lower() == rIdTarget:lower())
                        
                        if passBrainrot and passMutation and passRarity then
                            local itemUid = tool:GetAttribute("ItemUid") or tool:GetAttribute("BrainrotUID") or tool.Name
                            if itemUid and GiveGiftRequest then
                                GiveGiftRequest:FireServer(targetId, itemUid)
                                giftedThisTick = giftedThisTick + 1
                                task.wait(0.5) -- Jeda aman
                            end
                        end
                    end
                end
                
                -- Jika sudah mengirim sesuai amount, kita off-kan otomatis
                if Config.GiftAmount > 0 and giftedThisTick >= Config.GiftAmount then
                    Config.AutoGift = false
                    autoGiftLoop = false
                    if Library and Library.MakeNotify then
                        Library:MakeNotify({ Title = "Auto Gift", Content = "Selesai mengirim " .. giftedThisTick .. " Brainrot ke " .. Config.GiftTargetPlayer, Delay = 4 })
                    end
                end
            end)
        end
        autoGiftLoop = false
    end)
end

-- HOOK AUTO ACCEPT GIFT
local GiveGiftReceive = NetPackages:FindFirstChild("RE/GiveGiftReceive")
local GiveGiftAccept = NetPackages:FindFirstChild("RF/GiveGiftAccept")

if GiveGiftReceive and GiveGiftAccept then
    GiveGiftReceive.OnClientEvent:Connect(function(data)
        if Config.AutoAcceptGift then
            if data and data.uid then
                task.spawn(function()
                    local res = GiveGiftAccept:InvokeServer(data.uid)
                    
                    -- Hilangkan UI Pop-up bawaan game
                    task.spawn(function()
                        pcall(function()
                            task.wait(0.1)
                            local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", 2)
                            if playerGui then
                                local giveGiftGui = playerGui:FindFirstChild("GiveGift")
                                if giveGiftGui and giveGiftGui:FindFirstChild("confirmation") then
                                    giveGiftGui.confirmation.Visible = false
                                end
                            end
                        end)
                    end)
                    
                    if Library and Library.MakeNotify then
                        Library:MakeNotify({ Title = "Auto Accept", Content = "Berhasil menerima Brainrot dari teman!", Delay = 2 })
                    end
                end)
            end
        end
    end)
end

FuseSection:AddDropdown({
    Title   = "Target Fuse Brainrot",
    Options = ALL_BRAINROTS,
    Default = "None",
    Callback = function(val)
        Config.TargetFuseBrainrot = val
    end
})

FuseSection:AddToggle({
    Title   = "Auto Fuse to Rainbow",
    Title2  = "Enable",
    Content = "Scan inventori (unequipped) & fuse otomatis",
    Default = false,
    Callback = function(val)
        Config.AutoFuse = val
        if val then
            startAutoFuse()
            if Library and Library.MakeNotify then
                Library:MakeNotify({ Title = "Auto Fuse", Content = "Auto Fuse ON 🔥", Delay = 2 })
            end
        else
            if Library and Library.MakeNotify then
                Library:MakeNotify({ Title = "Auto Fuse", Content = "Auto Fuse OFF", Delay = 2 })
            end
        end
    end
})

local GiftSection = AutoTab:AddSection("Auto Trade")

local dropTargetPlayer
local function getPlayers()
    local list = {"None"}
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= game:GetService("Players").LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end

dropTargetPlayer = GiftSection:AddDropdown({
    Title   = "Target Player",
    Options = getPlayers(),
    Default = "None",
    Callback = function(val)
        Config.GiftTargetPlayer = val
    end
})

GiftSection:AddButton({
    Title = "Refresh Player List",
    Callback = function()
        if dropTargetPlayer and dropTargetPlayer.SetValues then
            dropTargetPlayer:SetValues(getPlayers(), "None")
        end
    end
})

GiftSection:AddDropdown({
    Title   = "Target Gift Brainrot",
    Options = ALL_BRAINROTS,
    Default = "None",
    Callback = function(val)
        Config.GiftTargetBrainrot = val
    end
})

GiftSection:AddDropdown({
    Title   = "Target Gift Rarity",
    Options = RARITY_LIST,
    Default = "None",
    Callback = function(val)
        Config.GiftTargetRarity = val
    end
})

GiftSection:AddDropdown({
    Title   = "Target Gift Mutation",
    Options = MUTATION_LIST,
    Default = "None",
    Callback = function(val)
        Config.GiftTargetMutation = val
    end
})

GiftSection:AddInput({
    Title    = "Jumlah Gift",
    Content  = "Ketik 0 untuk kirim semua / tanpa batas",
    Default  = "0",
    Callback = function(val)
        local num = tonumber(val)
        if num then
            Config.GiftAmount = num
        end
    end
})

GiftSection:AddToggle({
    Title   = "Auto Send Gift",
    Title2  = "Enable",
    Content = "Otomatis kirim target Brainrot (unequipped) ke pemain",
    Default = false,
    Callback = function(val)
        Config.AutoGift = val
        if val then
            startAutoGift()
            if Library and Library.MakeNotify then
                Library:MakeNotify({ Title = "Auto Gift", Content = "Mulai mencari & mengirim...", Delay = 2 })
            end
        end
    end
})

local AcceptSection = AutoTab:AddSection("Auto Accept Gift")

AcceptSection:AddToggle({
    Title   = "Auto Accept All Gifts",
    Title2  = "Enable",
    Content = "Setiap ada yang trade/gift, otomatis diterima instan",
    Default = false,
    Callback = function(val)
        Config.AutoAcceptGift = val
    end
})

if Library and Library.MakeNotify then
    Library:MakeNotify({ Title = "Napoleon", Content = "Sniper Brainrot (Instant Kill) loaded!", Delay = 3, Icon = "rbxassetid://96531489912535" })
end
