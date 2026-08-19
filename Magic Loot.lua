-- -- -- -- -- -- -- KEY SISTEM DI BAWAH INI BANG

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

-- ============================================================
-- KEY SYSTEM (Ed25519 Challenge-Response + Server Response Verification)
-- ============================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local key = getgenv().Key or _G.Key
local privateKey = getgenv().PrivateKey or _G.PrivateKey
local serverUrl = "https://napoleonn.net"

-- ===== SERVER PUBLIC KEY — hardcoded, never changes =====
-- Get from .env SERVER_PUBLIC_KEY (shown in server console on startup)
local SERVER_PUBLIC_KEY = "75dce92b8fcda87aa2e50eadd3c264f153d2f9953eb37b2870047daa0a42637f"

if not key then
    showWarningUI("Key tidak ditemukan! Silahkan masukkan getgenv().Key")
    return
end

local hwid = tostring(LocalPlayer.UserId)

-- ===== HELPERS =====
local function httpGet(url)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    return ok and res or nil
end

local function jsonDecode(str)
    local ok, val = pcall(function() return HttpService:JSONDecode(str) end)
    return ok and val or nil
end

-- ===== RESPONSE VERIFIER (fixed — 3 methods + fallback) =====
local function decodeBase64(str)
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    str = string.gsub(str, '[^'..b..'=]', '')
    return (str:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d%d%d%d%d%d', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

local function customHash(str)
    local nativeHash
    pcall(function()
        if crypt and crypt.hash then
            local t = crypt.hash("test", "sha256")
            if t == "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08" then nativeHash = crypt.hash(str, "sha256")
            else
                local t2 = crypt.hash("sha256", "test")
                if t2 == "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08" then nativeHash = crypt.hash("sha256", str) end
            end
        end
    end)
    pcall(function()
        if not nativeHash and syn and syn.crypto and syn.crypto.hash then
            local t = syn.crypto.hash("sha256", "test")
            if t == "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08" then nativeHash = syn.crypto.hash("sha256", str) end
        end
    end)
    if nativeHash then return nativeHash end

    local K = {0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da, 0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070, 0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2}
    local band, bnot, bxor, lshift, rshift = bit32.band, bit32.bnot, bit32.bxor, bit32.lshift, bit32.rshift
    local ror = bit32.rrotate
    local H = {0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19}
    
    local bit_len = #str * 8
    str = str .. string.char(0x80)
    local padLen = 64 - (#str % 64)
    if padLen < 8 then padLen = padLen + 64 end
    str = str .. string.rep("\0", padLen - 8)
    local hi = math.floor(bit_len / 4294967296)
    local lo = bit_len % 4294967296
    str = str .. string.char(band(rshift(hi, 24), 255), band(rshift(hi, 16), 255), band(rshift(hi, 8), 255), band(hi, 255), band(rshift(lo, 24), 255), band(rshift(lo, 16), 255), band(rshift(lo, 8), 255), band(lo, 255))
    
    for i = 1, #str, 64 do
        local W = {}
        for j = 0, 15 do
            local b1, b2, b3, b4 = string.byte(str, i + j*4, i + j*4 + 3)
            W[j] = lshift(b1, 24) + lshift(b2, 16) + lshift(b3, 8) + b4
        end
        for j = 16, 63 do
            local s0 = bxor(ror(W[j - 15], 7), ror(W[j - 15], 18), rshift(W[j - 15], 3))
            local s1 = bxor(ror(W[j - 2], 17), ror(W[j - 2], 19), rshift(W[j - 2], 10))
            W[j] = (W[j - 16] + s0 + W[j - 7] + s1) % 4294967296
        end
        local a, b, c, d, e, f, g, h = H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]
        for j = 0, 63 do
            local S1 = bxor(ror(e, 6), ror(e, 11), ror(e, 25))
            local ch = bxor(band(e, f), band(bnot(e), g))
            local temp1 = (h + S1 + ch + K[j + 1] + W[j]) % 4294967296
            local S0 = bxor(ror(a, 2), ror(a, 13), ror(a, 22))
            local maj = bxor(band(a, b), band(a, c), band(b, c))
            local temp2 = (S0 + maj) % 4294967296
            h = g; g = f; f = e; e = (d + temp1) % 4294967296; d = c; c = b; b = a; a = (temp1 + temp2) % 4294967296
        end
        H[1] = (H[1] + a) % 4294967296; H[2] = (H[2] + b) % 4294967296; H[3] = (H[3] + c) % 4294967296; H[4] = (H[4] + d) % 4294967296
        H[5] = (H[5] + e) % 4294967296; H[6] = (H[6] + f) % 4294967296; H[7] = (H[7] + g) % 4294967296; H[8] = (H[8] + h) % 4294967296
    end
    local out = ""
    for i = 1, 8 do out = out .. string.format("%08x", H[i]) end
    return out
end

local function customVerify(payload, sig, pubKey)
    local str = pubKey .. payload .. "NAPOLEON"
    local hash = customHash(str)
    return hash == sig
end

local function customSign(payload, pubKey)
    local str = pubKey .. payload .. "NAPOLEON"
    return customHash(str)
end

local function verifyServerResponse(raw)
    local ok, json = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok or not json then return nil, "Legacy" end
    
    if json.sig and json.server_key then
        -- Check 1: server identity
        if SERVER_PUBLIC_KEY ~= "" and json.server_key ~= SERVER_PUBLIC_KEY then
            return nil, "Server key mismatch!"
        end

        local scriptPayload = json.data and json.data.payload or ""
        local sigValid = customVerify(scriptPayload, json.sig, json.server_key)

        if not sigValid then
            return nil, "Invalid Signature! Server response tampered."
        end

        if json.ok == false then
            return nil, json.data and json.data.error or "Server error"
        end
        
        if json.data.is_base64 then
            local okDec, decScript = pcall(function()
                if crypt and crypt.base64decode then return crypt.base64decode(scriptPayload) end
                return decodeBase64(scriptPayload)
            end)
            if okDec and decScript then 
                local okJ, decodedJson = pcall(function() return HttpService:JSONDecode(decScript) end)
                if okJ and decodedJson then
                    return decodedJson, nil
                end
            end
            return nil, "Failed to decode base64 payload"
        end

        return json.data, nil
    end
    return nil, "Legacy"
end

-- ===== LEGACY XOR (fallback for old keys) =====
-- local SECRET_KEY = "HOEEEE_MALING_PANGSIT"

local function encryptXOR(text, secretKey)
    local result = {}
    local charIdx = 0
    local keyLen = #secretKey
    for i = 1, #text do
        local byte = text:byte(i)
        local keyChar = secretKey:byte((charIdx % keyLen) + 1)
        table.insert(result, string.format("%02x", bit32.bxor(byte, keyChar)))
        charIdx = charIdx + 1
    end
    return table.concat(result)
end

local function decryptXOR(hexStr, secretKey)
    local result = {}
    local charIdx = 0
    local keyLen = #secretKey
    local iter = 0
    for hexByte in string.gmatch(hexStr, "..") do
        local byte = tonumber(hexByte, 16)
        if not byte then return nil end
        local keyChar = secretKey:byte((charIdx % keyLen) + 1)
        table.insert(result, string.char(bit32.bxor(byte, keyChar)))
        charIdx = charIdx + 1
        iter = iter + 1
        if iter % 2500 == 0 then task.wait() end
    end
    return table.concat(result)
end

-- -- ===== MAIN AUTH =====
local mySessionNonce = HttpService:GenerateGUID(false)
local authSuccess = false
local authMessage = ""

-- TRY ED25519 (if PrivateKey set)
if privateKey and privateKey ~= "" then
    local chalUrl = serverUrl .. "/api/challenge?key=" .. key
    local chalRes = httpGet(chalUrl)

    if chalRes then
        local chalJson = jsonDecode(chalRes)
        if chalJson and chalJson.ok and chalJson.crypto then
            local authRaw = httpGet(serverUrl .. "/api/auth_module")
            if authRaw then
                local authOK, authMod = pcall(function() return loadstring(authRaw)() end)
                if authOK and authMod and authMod.sign_safe then
                    local message = chalJson.challenge .. mySessionNonce
                    local sigOK, signature = pcall(function() return authMod.sign_safe(privateKey, message) end)

                    if sigOK and signature then
                        local checkUrl = serverUrl .. "/api/check"
                            .. "?key=" .. key
                            .. "&hwid=" .. hwid
                            .. "&nonce=" .. mySessionNonce
                            .. "&challenge=" .. chalJson.challenge
                            .. "&signature=" .. signature
                            .. "&base64=true"

                        local successCheck, responseCheck = pcall(function() return httpGet(checkUrl) end)

                        if successCheck and responseCheck then
                            local signedData, _ = verifyServerResponse(responseCheck)
                            if signedData then
                                authSuccess = signedData.valid
                                authMessage = signedData.message or "Key verified"
                            else
                                -- Fallback XOR
                                local decrypted = decryptXOR(responseCheck, SECRET_KEY)
                                if decrypted then
                                    local splitPos = decrypted:find("|")
                                    if splitPos then
                                        local data = jsonDecode(decrypted:sub(splitPos + 1))
                                        if data and type(data) == "table" then
                                            if data.nonce ~= mySessionNonce then
                                                LocalPlayer:Kick("Security: HTTP Spoofing!")
                                                while true do end
                                            end
                                            authSuccess = data.valid
                                            authMessage = data.message or ""
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- FALLBACK: legacy XOR (no PrivateKey)
if not authSuccess and not privateKey then
    local checkUrl = serverUrl .. "/api/check?key=" .. key .. "&hwid=" .. hwid .. "&nonce=" .. mySessionNonce .. "&base64=true"
    local successCheck, responseCheck = pcall(function() return httpGet(checkUrl) end)

    if successCheck and responseCheck then
        local signedData, _ = verifyServerResponse(responseCheck)
        if signedData then
            authSuccess = signedData.valid
            authMessage = signedData.message or ""
        else
            local decrypted = decryptXOR(responseCheck, SECRET_KEY)
            if decrypted then
                local splitPos = decrypted:find("|")
                if splitPos then
                    local timestampStr = decrypted:sub(1, splitPos - 1)
                    local serverTime = tonumber(timestampStr)
                    local localTime = workspace:GetServerTimeNow()
                    if serverTime and math.abs(localTime - serverTime) > 60 then
                        showWarningUI("Sesi kadaluarsa / Time Mismatch!")
                        return
                    end
                    local data = jsonDecode(decrypted:sub(splitPos + 1))
                    if data and type(data) == "table" then
                        if data.nonce ~= mySessionNonce then
                            LocalPlayer:Kick("Security: HTTP Spoofing!")
                            while true do end
                        end
                        authSuccess = data.valid
                        authMessage = data.message or ""
                    end
                end
            end
        end
    end
end

-- ===== RESULT =====
if not authSuccess then
    showWarningUI(authMessage ~= "" and authMessage or "Key tidak valid / Gagal verifikasi!")
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
        local currentTime = workspace:GetServerTimeNow()
        local logPath = "Napoleon_KICK-A-LUCKY-BLOCK_LastExec.txt"
        
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

        local player = LocalPlayer
        if player then
            local userid = tostring(player.UserId)
            local username = player.Name
            local executor = getExecutorName()
            local placeid = tostring(game.PlaceId)
            
            local url = serverUrl .. "/api/track"
                .. "?script=Grow-a-Garden-2"
                .. "&userid=" .. userid
                .. "&username=" .. username
                .. "&executor=" .. (executor:gsub(" ", "%%20"))
                .. "&placeid=" .. placeid
                .. "&key=" .. key
                
            httpGet(url)
        end
    end)
end)

print("Success!!")

-- ============================================================
-- LOAD NAPOLEON UI LIBRARY
-- ============================================================
local function LoadNapoleonUI()
    local url = "https://raw.githubusercontent.com/iSylvesterr/library/refs/heads/main/NewUI.lua"
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and result and string.len(result) > 100 then

        local func, err = loadstring(result)
        if func then
            local success2, lib = pcall(func)
            if success2 and lib then 
                return lib 
            end
        end
    end
    
    return nil
end

local Library = LoadNapoleonUI()
if not Library then
    return
end
-- ============================================================
-- BUILD UI
-- ============================================================
local Window = Library:Window({
    Title = "Napoleon",
    Footer = "Magic Loot",
    Color = Color3.fromRGB(50, 50, 50),
    Color2 = Color3.fromRGB(20, 20, 20),
    ["Tab Width"] = 130,
    Image = "111895858615511",
    WindowIMG = "91334002283698",
    LogoHUB = "119958938217417"
})

local Tabs = Window

-- ============================================================
-- DATA & CONFIG
-- ============================================================
local Config = {
    AutoDungeon = false,
    TargetStage = 1,
    AutoReturn = false,
    AutoTraining = false,
    AutoPickup = false,
    AutoPickupName = {"None"},
    AutoPickupRarity = {"None"},
    AutoCraft = false,
    AutoCraftTarget = 1,
    AutoClaimOnline = false,
    AutoTrade = false,
    AutoTradePlayer = "",
    AutoTradeItem = "None",
    AutoTradeAmount = 1,
    AutoSell = false,
    AutoSellAll = false,
    AutoSellName = {},
    AutoSellRarities = {
        [1]=false, [2]=false, [3]=false, [4]=false, [5]=false,
        [6]=false, [7]=false, [8]=false, [9]=false, [10]=false
    }
}

local STAGE_LIST = {}
for i = 1, 27 do
    table.insert(STAGE_LIST, tostring(i))
end

-- ============================================================
-- AUTO SELL LOGIC
-- ============================================================
local function AutoSellLoop()
    while Config.AutoSell do
        local success, UtilsSystem = pcall(function() 
            return require(game:GetService("ReplicatedFirst").AllSideCode.UtilsSystem)
        end)
        local CfgFind = success and UtilsSystem.CfgFind or nil
        
        if CfgFind then
            local onlyIDList = {}
            local PlayerData = UtilsSystem.PlayerData
            local EnumMgr = UtilsSystem.EnumMgr
            local materialType = (EnumMgr and EnumMgr.ItemType) and EnumMgr.ItemType.Material or 2
            
            if PlayerData then
                local LocalPlayer = game:GetService("Players").LocalPlayer
                local bagData = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag")
                
                if type(bagData) == "table" then
                    for k, itemData in pairs(bagData) do
                        if type(itemData) == "table" then
                            local tp = tonumber(itemData.tp)
                            local isLocked = (itemData.lock == 1 or itemData.lock == true or itemData.lock == "1" or itemData.lock == "true")
                            
                            if (not tp or tp == materialType) and not isLocked then
                                local itemId = tonumber(itemData.id) or tonumber(itemData.ItemId) or tonumber(itemData.configId)
                                local onlyID = tonumber(itemData.onlyID) or tonumber(itemData.onlyId) or tonumber(k)
                                
                                if itemId and onlyID then
                                    local shouldSell = false
                                    
                                    if Config.AutoSellAll then
                                        shouldSell = true
                                    else
                                        local cfg = CfgFind.FindCfgByID(itemId)
                                        if cfg then
                                            local rarity = tonumber(cfg.xyd) or 1
                                            if Config.AutoSellRarities[rarity] then
                                                shouldSell = true
                                            end
                                        end
                                        
                                        if not shouldSell and type(Config.AutoSellName) == "table" then
                                            local NAME_TO_ID = {
                                                ["Blueberry"] = 2010001, ["Withered Mushroom"] = 2010002, ["Golden Tooth"] = 2010003, ["Goblin Finger"] = 2010004, ["Dwarf Emblem"] = 2010005, ["Copper Earring"] = 2010006, ["Flame Crest"] = 2010007, ["Furnace Core"] = 2010008,
                                                ["Coconut"] = 2020001, ["Shell"] = 2020002, ["Stale Bread"] = 2020003, ["Rum Bottle"] = 2020004, ["Black Powder"] = 2020005, ["Undead Skeletons"] = 2020006, ["Cursed Ring"] = 2020007, ["Undying Spirit"] = 2020008,
                                                ["Sulphur Lumps"] = 2030001, ["Volcanic Rock"] = 2030002, ["Orc Teeth"] = 2030003, ["Orc Ears"] = 2030004, ["Iron Armour"] = 2030005, ["Lava Behemoth Remains"] = 2030006, ["Golem Core"] = 2030007, ["Inferno Lotus"] = 2030008,
                                                ["Crystal Orchid"] = 2040001, ["Spider Saliva"] = 2040002, ["Spider's cocoon"] = 2040003, ["Spider Claws"] = 2040004, ["Fluorescent Spider Silk"] = 2040005, ["Deadly Spider Powder"] = 2040006, ["Queen's Crown"] = 2040007, ["Queen Blood Sac"] = 2040008,
                                                ["Ginseng"] = 2050001, ["Tree Spirit"] = 2050002, ["Eye of Stone"] = 2050003, ["Firefly"] = 2050004, ["Dwarf Emblem"] = 2050005, ["Staff Gem"] = 2050006, ["Ritual Mask"] = 2050007, ["Prismatic Lotus"] = 2050008,
                                                ["Sharp Fangs"] = 2060001, ["Bear Bone"] = 2060002, ["Ice Magic Crystal"] = 2060003, ["Bear Paw"] = 2060004, ["Scarlet Heart Flower"] = 2060005, ["Blue Dragon Egg"] = 2060006, ["Frost Vein"] = 2060007, ["Eye of the Ice Dragon"] = 2060008
                                            }
                                            for _, nOpt in ipairs(Config.AutoSellName) do
                                                if itemId == NAME_TO_ID[nOpt] then
                                                    shouldSell = true
                                                    break
                                                end
                                            end
                                        end
                                    end
                                    
                                    if shouldSell then
                                        table.insert(onlyIDList, onlyID)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            if #onlyIDList > 0 then
                pcall(function()
                    local Event = game:GetService("ReplicatedStorage"):FindFirstChild("Msg")
                    if Event and Event:FindFirstChild("RemoteFunction") and Event.RemoteFunction:FindFirstChild("NetWorkRemoteFunction") then
                        Event.RemoteFunction.NetWorkRemoteFunction:InvokeServer(
                            "\xE5\x87\xBA\xE5\x94\xAE\xE6\x9D\x90\xE6\x96\x99",
                            {
                                onlyIDList = onlyIDList
                            }
                        )
                    end
                end)
            end
        end
        task.wait(5)
    end
end

-- ============================================================
-- AUTO TRADE LOGIC
-- ============================================================
local function AutoTradeLoop()
    task.spawn(function()
        local success, UtilsSystem = pcall(function() 
            return require(game:GetService("ReplicatedFirst").AllSideCode.UtilsSystem)
        end)
        
        while Config.AutoTrade do
            pcall(function()
                if Config.AutoTradePlayer == "" or Config.AutoTradePlayer == "None" or Config.AutoTradeItem == "None" or Config.AutoTradeAmount <= 0 then
                    return
                end
                
                local Players = game:GetService("Players")
                local targetPlayer = nil
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.Name == Config.AutoTradePlayer or p.DisplayName == Config.AutoTradePlayer then
                        targetPlayer = p
                        break
                    end
                end
                
                if not targetPlayer then return end
                
                local LocalPlayer = Players.LocalPlayer
                local PlayerData = UtilsSystem.PlayerData
                
                if PlayerData then
                    local bagData = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag")
                    if bagData then
                        local itemsToTrade = {}
                        for _, item in pairs(bagData) do
                            if type(item) == "table" and tonumber(item.tp) then
                                local onlyID = tonumber(item.onlyID)
                                local cfg = UtilsSystem.CfgFind.FindCfgByID(item.id, tonumber(item.tp))
                                local name = cfg and cfg.ZhName or ""
                                
                                if UtilsSystem.TranslationHelper and UtilsSystem.TranslationHelper.TranslateByKey then
                                    local eng = UtilsSystem.TranslationHelper.TranslateByKey(name)
                                    if eng and type(eng) == "string" and eng ~= "" and not eng:match("未本地化") then
                                        name = eng
                                    end
                                end
                                
                                local displayName = name
                                local targetItemName = Config.AutoTradeItem
                                
                                -- Strip the "[ID] " prefix from the dropdown option if it exists
                                local prefixMatch = string.match(targetItemName, "%[%d+%]%s+(.+)")
                                if prefixMatch then
                                    targetItemName = prefixMatch
                                end
                                
                                if displayName == targetItemName or name == targetItemName then
                                    table.insert(itemsToTrade, onlyID)
                                end
                            end
                        end
                        
                        local tradedCount = 0
                        local NetWork = UtilsSystem.NetWork
                        local NetMsg = UtilsSystem.NetMsg
                        
                        if NetWork and NetMsg and #itemsToTrade > 0 then
                            for _, onlyID in ipairs(itemsToTrade) do
                                if not Config.AutoTrade or tradedCount >= Config.AutoTradeAmount then break end
                                
                                -- Teleport to target player to ensure we are within trading distance
                                pcall(function()
                                    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                                    end
                                end)
                                task.wait(0.5)
                                
                                pcall(function()
                                    NetWork.FireServer(NetMsg.BACKPACK_TOOLBAR_DRAG, {
                                        from = { zone = "warehouse", onlyID = onlyID },
                                        to = { zone = "toolbar", equipSlot = 6 }
                                    })
                                end)
                                task.wait(0.5)
                                
                                pcall(function()
                                    NetWork.FireServer(NetMsg.BACKPACK_TOGGLE_HELD, {
                                        uiSlotIndex = 6
                                    })
                                end)
                                task.wait(0.5)
                                
                                pcall(function()
                                    NetWork.FireServer(NetMsg.GIFT_REQUEST, targetPlayer.UserId)
                                end)
                                -- Increased delay to 4 seconds to respect server cooldowns and animation times
                                task.wait(4)
                                
                                tradedCount = tradedCount + 1
                            end
                            
                            if tradedCount >= Config.AutoTradeAmount or tradedCount == #itemsToTrade then
                                Config.AutoTrade = false
                            end
                        end
                    end
                end
            end)
            task.wait(1)
        end
    end)
end


-- ============================================================
-- AUTO CLAIM ONLINE REWARDS
-- ============================================================
local function AutoClaimOnlineLoop()
    task.spawn(function()
        while Config.AutoClaimOnline do 
            pcall(function()
                local Event = game:GetService("ReplicatedStorage"):FindFirstChild("Msg")
                if Event and Event:FindFirstChild("RemoteFunction") and Event.RemoteFunction:FindFirstChild("NetWorkRemoteFunction") then
                    for i = 1, 12 do
                        if not Config.AutoClaimOnline then break end
                        pcall(function()
                            Event.RemoteFunction.NetWorkRemoteFunction:InvokeServer("\xE9\xA2\x86\xE5\x8F\x96\xE5\x9C\xA8\xE7\xBA\xBF\xE5\xA5\x96\xE5\x8A\xB1", i)
                        end)
                        task.wait(0.2)
                    end
                end
            end)
            task.wait(5)
        end
    end)
end

-- ============================================================
-- AUTO RETURN LOGIC
-- ============================================================
local function AutoReturnLoop()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    while Config.AutoReturn do
        task.wait(1)
        
        local isBagFull = false
        pcall(function()
            local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if PlayerGui then
                local mainGui = PlayerGui:FindFirstChild("ScreenGui")
                if mainGui then
                    local bl = mainGui:FindFirstChild("Main") and mainGui.Main:FindFirstChild("ButtomLeft")
                    if bl and bl:FindFirstChild("临时背包容量") then
                        local bagLabel = bl["临时背包容量"]:FindFirstChild("Label")
                        if bagLabel then
                            local curr, max = string.match(bagLabel.Text, "(%d+)/(%d+)")
                            if curr and max and tonumber(curr) >= tonumber(max) and tonumber(max) > 0 then
                                isBagFull = true
                            end
                        end
                    end
                end
            end
        end)

        if isBagFull then
            _G.NapoleonPauseDungeon = true -- Pause AutoDungeon agar tidak nyolong start sebelum server reset
            pcall(function()
                local Event = game:GetService("ReplicatedStorage"):FindFirstChild("Msg")
                if Event and Event:FindFirstChild("RemoteEvent") and Event.RemoteEvent:FindFirstChild("NetWorkRemoteEvent") then
                    Event.RemoteEvent.NetWorkRemoteEvent:FireServer("\229\137\175\230\156\172\229\155\158\229\159\142") -- 副本回城 (DUNGEON_RETURN_TOWN)
                end
            end)
            task.wait(3) -- Beri waktu lebih lama agar player sempat ter-TP ke kota dan AutoDungeon Loop menangkap pause ini
            _G.NapoleonPauseDungeon = false
        end
    end
end

-- ============================================================
-- SHARED DROP LOGIC
-- ============================================================
local function GetValidDrops()
    local validDrops = {}
    local dropsClient = workspace:FindFirstChild("DropsClient")
    if not dropsClient then return validDrops end

    for _, rarityFolder in ipairs(dropsClient:GetChildren()) do
        local rarityStr = rarityFolder.Name
        local rarityNum = tonumber(rarityStr) or 0
        
        for _, dropModel in ipairs(rarityFolder:GetChildren()) do
            if dropModel:IsA("Model") then
                local itemName = ""
                local zhLabel = dropModel:FindFirstChild("ZhName", true)
                if zhLabel and zhLabel:IsA("TextLabel") then
                    itemName = zhLabel.Text
                end
                
                local hasRarityFilter = not table.find(Config.AutoPickupRarity, "None")
                local hasNameFilter = not table.find(Config.AutoPickupName, "None")

                local matchRarity = false
                if hasRarityFilter then
                    local RARITY_MAP = {
                        ["Common"] = "1", ["Uncommon"] = "2", ["Rare"] = "3",
                        ["Epic"] = "4", ["Legendary"] = "5", ["Mythic"] = "6",
                        ["Secret"] = "7", ["Ancient"] = "8", ["Supreme"] = "9", ["Astral"] = "10"
                    }
                    for _, rOpt in ipairs(Config.AutoPickupRarity) do
                        local rNum = RARITY_MAP[rOpt]
                        if rNum and rNum == rarityStr then
                            matchRarity = true
                            break
                        end
                    end
                end

                local matchName = false
                local dropId = tonumber(dropModel:GetAttribute("ItemId")) or 0
                
                if hasNameFilter then
                    local NAME_TO_ID = {
                        ["Blueberry"] = 2010001, ["Withered Mushroom"] = 2010002, ["Golden Tooth"] = 2010003, ["Goblin Finger"] = 2010004, ["Dwarf Emblem"] = 2010005, ["Copper Earring"] = 2010006, ["Flame Crest"] = 2010007, ["Furnace Core"] = 2010008,
                        ["Coconut"] = 2020001, ["Shell"] = 2020002, ["Stale Bread"] = 2020003, ["Rum Bottle"] = 2020004, ["Black Powder"] = 2020005, ["Undead Skeletons"] = 2020006, ["Cursed Ring"] = 2020007, ["Undying Spirit"] = 2020008,
                        ["Sulphur Lumps"] = 2030001, ["Volcanic Rock"] = 2030002, ["Orc Teeth"] = 2030003, ["Orc Ears"] = 2030004, ["Iron Armour"] = 2030005, ["Lava Behemoth Remains"] = 2030006, ["Golem Core"] = 2030007, ["Inferno Lotus"] = 2030008,
                        ["Crystal Orchid"] = 2040001, ["Spider Saliva"] = 2040002, ["Spider's cocoon"] = 2040003, ["Spider Claws"] = 2040004, ["Fluorescent Spider Silk"] = 2040005, ["Deadly Spider Powder"] = 2040006, ["Queen's Crown"] = 2040007, ["Queen Blood Sac"] = 2040008,
                        ["Ginseng"] = 2050001, ["Tree Spirit"] = 2050002, ["Eye of Stone"] = 2050003, ["Firefly"] = 2050004, ["Dwarf Emblem"] = 2050005, ["Staff Gem"] = 2050006, ["Ritual Mask"] = 2050007, ["Prismatic Lotus"] = 2050008,
                        ["Sharp Fangs"] = 2060001, ["Bear Bone"] = 2060002, ["Ice Magic Crystal"] = 2060003, ["Bear Paw"] = 2060004, ["Scarlet Heart Flower"] = 2060005, ["Blue Dragon Egg"] = 2060006, ["Frost Vein"] = 2060007, ["Eye of the Ice Dragon"] = 2060008
                    }
                    for _, nOpt in ipairs(Config.AutoPickupName) do
                        if dropId == NAME_TO_ID[nOpt] then
                            matchName = true
                            break
                        end
                    end
                end
                
                local isSpecialItem = false
                if itemName then
                    local lowerName = string.lower(itemName)
                    if string.match(lowerName, "shadow crystal") or string.match(lowerName, "sacred flame") then
                        isSpecialItem = true
                    end
                end
                
                local shouldPick = false
                if isSpecialItem then
                    shouldPick = true
                elseif not hasRarityFilter and not hasNameFilter then
                    shouldPick = true -- Pick all if both None
                elseif hasRarityFilter and not hasNameFilter then
                    shouldPick = matchRarity
                elseif hasNameFilter and not hasRarityFilter then
                    shouldPick = matchName
                else
                    shouldPick = (matchRarity and matchName)
                end
                
                if shouldPick then
                    local prompt = dropModel:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt then
                        table.insert(validDrops, {
                            prompt = prompt,
                            rarity = rarityNum,
                            itemId = dropId
                        })
                    end
                end
            end
        end
    end
    return validDrops
end

-- ============================================================
-- AUTO DUNGEON LOGIC
-- ============================================================
local function AutoDungeonLoop()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local ReplicatedFirst = game:GetService("ReplicatedFirst")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local ok, UtilsSystem = pcall(function()
        return require(ReplicatedFirst.AllSideCode.UtilsSystem)
    end)
    local NetWork = ok and UtilsSystem and UtilsSystem.NetWork or nil
    local CfgFind = ok and UtilsSystem and UtilsSystem.CfgFind or nil
    local EnumMgr = ok and UtilsSystem and UtilsSystem.EnumMgr or nil

    local jumpDoneThisRun = false
    local activeStageOverride = 1

    -- Hitung max stage yang bisa di-jump pakai broom
    local function getBroomJumpMax()
        local careerObj = LocalPlayer:FindFirstChild("CareerMaxStage")
        local careerMax = careerObj and careerObj:IsA("NumberValue") and math.floor(careerObj.Value) or 0
        if careerMax <= 0 then return 0 end

        local nowBroomObj = LocalPlayer:FindFirstChild("NowBroom")
        local nowBroom = nowBroomObj and math.floor(nowBroomObj.Value) or 0
        if nowBroom <= 0 then return 0 end

        local broomMax = 0
        if CfgFind and EnumMgr then
            local broomCfg = CfgFind.FindCfgByID(nowBroom, EnumMgr.ItemType.Broom)
            broomMax = broomCfg and tonumber(broomCfg.Dungeon) or 0
        end
        if broomMax <= 0 then return 0 end

        return math.min(careerMax + 1, broomMax)
    end

    local lastClear = nil

    while Config.AutoDungeon do
        task.wait(0.1)

        if _G.NapoleonPauseDungeon then continue end

        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then continue end
        local rootPart = character.HumanoidRootPart

        -- Cek apakah player di lobby atau di dungeon
        local inDungeonObj = LocalPlayer:FindFirstChild("InDungeonChallenge")
        local inDungeon = inDungeonObj and inDungeonObj:IsA("NumberValue") and inDungeonObj.Value > 0

        -- Jika di lobby (awal run), reset state jump & override
        if not inDungeon then
            jumpDoneThisRun = false
            activeStageOverride = 1
            lastClear = nil
        end

        local maxClearObj = LocalPlayer:FindFirstChild("DungeonRunMaxClear")
        local currentClear = (maxClearObj and maxClearObj:IsA("NumberValue")) and math.floor(maxClearObj.Value) or 0

        -- Jika stage baru saja diselesaikan, tunggu sebentar untuk loot (auto pick up)
        if lastClear and currentClear > lastClear then
            task.wait(1) -- Beri waktu sedikit agar item baru spawn
            local maxWait = 10 -- Wait up to 10 half-seconds (5 seconds total)
            local waited = 0
            while Config.AutoPickup and waited < maxWait do
                if _G.NapoleonPauseDungeon then break end
                local drops = GetValidDrops()
                if #drops == 0 then
                    break -- Semua item yang sesuai filter sudah diambil (atau tidak ada item drop valid)
                end
                task.wait(0.5)
                waited = waited + 1
            end
        end
        lastClear = currentClear

        -- Jika sedang paused karena town return, skip execution code di bawah agar tidak spawn dungeon stage secara ilegal
        if _G.NapoleonPauseDungeon then
            continue
        end

        -- Sinkronkan target stage: jika baru jump, gunakan hasil jump (override)
        -- Setelah clear stage itu, currentClear akan menyalip override
        local targetActiveStage = math.max(currentClear + 1, activeStageOverride)

        if targetActiveStage > Config.TargetStage then
            task.wait(1)
            continue
        end

        -- 3. BROOM JUMP
        if not jumpDoneThisRun and NetWork then
            jumpDoneThisRun = true
            local effectiveJump = getBroomJumpMax()

            if effectiveJump > 1 then
                local jumpTo = math.min(effectiveJump, Config.TargetStage)

                -- Hapus 传送起点 → StageJumpPresentation skip animasi terbang
                pcall(function()
                    local sc = workspace:FindFirstChild("场景")
                    local sp = sc and sc:FindFirstChild("传送起点")
                    if sp then sp:Destroy() end
                end)

                pcall(function() NetWork.FireServer("关卡跳关请求", jumpTo) end)

                -- Aggressive TP: pantau dan spam TP selama 2.5 detik untuk melawan server
                -- Begitu stage terload, karakter langsung di-TP ke atas tanpa sempat menyentuh tanah
                local endTime = os.clock() + 2.5
                while os.clock() < endTime do
                    task.wait(0.05)
                    local sc = workspace:FindFirstChild("场景")
                    local sf = sc and sc:FindFirstChild(tostring(jumpTo))
                    local ba = sf and sf:FindFirstChild("战斗区域", true)
                    
                    if ba then
                        local pName = "AutoDungeonPlatformNPLN"
                        local p = workspace:FindFirstChild(pName)
                        if not p then
                            p = Instance.new("Part")
                            p.Name = pName
                            p.Size = Vector3.new(15, 1, 15)
                            p.Anchored = true
                            p.Transparency = 1
                            p.Parent = workspace
                        end
                        p.CFrame = ba.CFrame * CFrame.new(0, 4, 0)
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then hrp.CFrame = ba.CFrame * CFrame.new(0, 7, 0) end
                    end
                end

                -- Set override agar loop utama bisa lanjut normal
                activeStageOverride = jumpTo
                continue
            end
        end

        -- 4. Cari Area Pertarungan
        local battleArea = nil
        local scenery = workspace:FindFirstChild("场景")
        if scenery then
            local stageFolder = scenery:FindFirstChild(tostring(targetActiveStage))
            if stageFolder then
                battleArea = stageFolder:FindFirstChild("战斗区域", true)
            end
        end

        if not battleArea then
            task.wait(1)
            continue
        end

        -- 5. Buat & Posisikan Platform, lalu TP karakter ke atas (elevated)
        local platformName = "AutoDungeonPlatformNPLN"
        local platform = workspace:FindFirstChild(platformName)
        if not platform then
            platform = Instance.new("Part")
            platform.Name = platformName
            platform.Size = Vector3.new(15, 1, 15)
            platform.Anchored = true
            platform.Transparency = 1
            platform.Parent = workspace
        end
        platform.CFrame = battleArea.CFrame * CFrame.new(0, 4, 0)
        rootPart.CFrame = battleArea.CFrame * CFrame.new(0, 7, 0)

        -- 6. Spawn Monster
        task.wait(0.5)
        if not workspace:FindFirstChild("LocalMonster") or #workspace.LocalMonster:GetChildren() == 0 then
            pcall(function()
                local Event = game:GetService("ReplicatedStorage"):FindFirstChild("Msg")
                if Event and Event:FindFirstChild("RemoteEvent") and Event.RemoteEvent:FindFirstChild("NetWorkRemoteEvent") then
                    Event.RemoteEvent.NetWorkRemoteEvent:FireServer("\229\137\175\230\156\172\229\133\179\229\141\161\229\136\183\230\128\170", targetActiveStage)
                end
            end)
        end
    end

    -- Cleanup
    local p = workspace:FindFirstChild("AutoDungeonPlatformNPLN")
    if p then p:Destroy() end
end

-- ============================================================
-- HELPER
-- ============================================================
local function handleDropdownChange(val, dropObj)
    local arr = {}
    if type(val) == "table" then
        for k, v in pairs(val) do
            if type(k) == "number" then
                table.insert(arr, v)
            elseif type(k) == "string" and v == true then
                table.insert(arr, k)
            end
        end
    else
        arr = {val}
    end
    
    local changed = false
    if #arr > 1 and table.find(arr, "None") then
        local newArr = {}
        for _, item in ipairs(arr) do
            if item ~= "None" then table.insert(newArr, item) end
        end
        arr = newArr
        changed = true
    elseif #arr == 0 then
        arr = {"None"}
        changed = true
    end
    
    if changed and dropObj then
        pcall(function() dropObj:Set(arr) end)
    end
    return arr
end

-- ============================================================
-- AUTO PICKUP LOOP
-- ============================================================
local function AutoPickupLoop()
    while task.wait(0.5) do
        if not Config.AutoPickup then break end
        
        pcall(function()
            local validDrops = GetValidDrops()
            if #validDrops > 0 then

                -- 2. Urutkan item: Prioritas tertinggi adalah rarity terbesar, lalu itemId terbesar
                table.sort(validDrops, function(a, b)
                    if a.rarity ~= b.rarity then
                        return a.rarity > b.rarity -- Rarity 10 > 9 > 8 dst (Supreme didahulukan dari Ancient)
                    else
                        return a.itemId > b.itemId -- ItemID lebih besar biasanya lebih mahal/langka
                    end
                end)

                -- 3. Ambil item sesuai urutan prioritas
                for _, dropInfo in ipairs(validDrops) do
                    fireproximityprompt(dropInfo.prompt)
                    task.wait(0.02) -- Jeda supersingkat untuk memastikan server memproses sesuai antrian urutan
                end
            end
        end)
    end
end

-- ============================================================
-- AUTO TRAINING LOGIC
-- ============================================================
local function AutoTrainingLoop()
    local ReplicatedFirst = game:GetService("ReplicatedFirst")
    local success, UtilsSystem = pcall(function()
        return require(ReplicatedFirst.AllSideCode.UtilsSystem)
    end)
    local NetWork = success and UtilsSystem.NetWork or nil

    if not NetWork then
        Config.AutoTraining = false
        return
    end

    while Config.AutoTraining do
        pcall(function()
            NetWork.InvokeServer("训练点屏", {})
        end)
        task.wait(0.05) -- Default fast speed
    end
end

-- ============================================================
-- ANTI AFK LOGIC
-- ============================================================
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = game:GetService("Players").LocalPlayer
LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- ============================================================
-- AUTO CRAFTING POTION LOGIC
-- ============================================================
local potionOptions = {}
local recipeMap = {}

task.spawn(function()
    local success, UtilsSystem = pcall(function() 
        return require(game:GetService("ReplicatedFirst").AllSideCode.UtilsSystem)
    end)
    
    local loaded = false
    if success and UtilsSystem and UtilsSystem.CfgFind then
        local CfgFind = UtilsSystem.CfgFind
        if CfgFind.GetAlchemyRecipeList then
            local recipeList = CfgFind.GetAlchemyRecipeList()
            if recipeList and type(recipeList) == "table" and #recipeList > 0 then
                table.sort(recipeList, function(a, b) return a.recipeId < b.recipeId end)
                
                for _, recipe in ipairs(recipeList) do
                    local recipeId = recipe.recipeId
                    local PID = recipe.PID
                    local itemCfg = CfgFind.FindCfgByID(PID)
                    
                    local name = itemCfg and itemCfg.ZhName or ("Potion " .. recipeId)
                    
                    pcall(function()
                        if UtilsSystem.TranslationHelper and UtilsSystem.TranslationHelper.TranslateByKey then
                            local eng = UtilsSystem.TranslationHelper.TranslateByKey(name)
                            if eng and type(eng) == "string" and eng ~= "" and not eng:match("未本地化") then
                                name = eng
                            end
                        end
                    end)
                    
                    local displayName = string.format("[%d] %s", recipeId, name)
                    table.insert(potionOptions, displayName)
                    recipeMap[displayName] = recipeId
                end
                loaded = true
            end
        end
    end
    
    if not loaded then
        for i = 1, 40 do
            local displayName = "Potion " .. i
            table.insert(potionOptions, displayName)
            recipeMap[displayName] = i
        end
    end
end)

local function AutoCraftLoop()
    task.spawn(function()
        local success, UtilsSystem = pcall(function() 
            return require(game:GetService("ReplicatedFirst").AllSideCode.UtilsSystem)
        end)
        
        pcall(function()
            local PotionBrewingGame = require(game:GetService("ReplicatedStorage").ClientSideCode.GuiScripts.ModuleScript.PotionBrewingGame)
            if PotionBrewingGame and type(PotionBrewingGame.StartFromCraftPresent) == "function" then
                if not PotionBrewingGame._originalStartFromCraftPresent then
                    PotionBrewingGame._originalStartFromCraftPresent = PotionBrewingGame.StartFromCraftPresent
                end
                PotionBrewingGame.StartFromCraftPresent = function(...)
                    if Config.AutoCraft then
                        return
                    else
                        return PotionBrewingGame._originalStartFromCraftPresent(...)
                    end
                end
            end
        end)
        
        while Config.AutoCraft do
            pcall(function()
                local player = game:GetService("Players").LocalPlayer
                
                -- 1. Auto Skip (Physically click Skip to reset Camera)
                local playerGui = player:FindFirstChild("PlayerGui")
                if playerGui then
                    local brewingUi = playerGui:FindFirstChild("PotionBrewingGame")
                    if brewingUi and brewingUi.Enabled then
                        for _, obj in ipairs(brewingUi:GetDescendants()) do
                            if obj:IsA("TextButton") or obj:IsA("TextLabel") then
                                if obj.Text == "Skip" or obj.Text == "SKIP" or obj.Name == "\232\183\179\232\191\135\230\140\137\233\146\174" then
                                    local btn = obj
                                    if not btn:IsA("GuiButton") then btn = btn.Parent end
                                    if btn and btn:IsA("GuiButton") then
                                        if getconnections then
                                            for _, conn in ipairs(getconnections(btn.MouseButton1Click)) do conn:Fire() end
                                            for _, conn in ipairs(getconnections(btn.Activated)) do conn:Fire() end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                
                -- 2. Check if currently brewing
                local isBrewing = false
                if success and UtilsSystem and UtilsSystem.GetData and UtilsSystem.GetData.Alchemy then
                    if UtilsSystem.GetData.Alchemy.IsPlayerMaterialBrewing then
                        if UtilsSystem.GetData.Alchemy.IsPlayerMaterialBrewing(player) then
                            isBrewing = true
                        end
                    end
                end
                
                local Event = game:GetService("ReplicatedStorage"):FindFirstChild("Msg")
                if Event and Event:FindFirstChild("RemoteFunction") and Event.RemoteFunction:FindFirstChild("NetWorkRemoteFunction") then
                    local remote = Event.RemoteFunction.NetWorkRemoteFunction
                    
                    if isBrewing then
                        -- Try to pick up (if it's finished brewing, this will succeed silently)
                        task.spawn(function()
                            pcall(function()
                                remote:InvokeServer("\xE7\x82\xBC\xE9\x87\x91\xE6\x8B\xBE\xE5\x8F\x96\xE6\x88\x90\xE5\x93\x81")
                            end)
                        end)
                    else
                        -- Try to start crafting (only if not brewing, to avoid spam)
                        task.spawn(function()
                            pcall(function()
                                remote:InvokeServer(
                                    "\xE7\x82\xBC\xE9\x87\x91\xE7\x82\xBC\xE5\x88\xB6",
                                    { recipeId = Config.AutoCraftTarget }
                                )
                            end)
                        end)
                    end
                end
            end)
            task.wait(1)
        end
    end)
end

-- ============================================================
-- 1. TAB MAIN
-- ============================================================
local function LoadMainTab()
local MainTab = Tabs:AddTab({ Name = "Main", Icon = "rbxassetid://10723396652" })

local AutoDungeonSection = MainTab:AddSection("Dungeon", false)

AutoDungeonSection:AddToggle({
    Title = "Auto Return Full Bag",
    Content = "Automatically return when bag is full",
    Default = false,
    Callback = function(val)
        Config.AutoReturn = val
        if val then
            task.spawn(AutoReturnLoop)
        end
    end
})

AutoDungeonSection:AddToggle({
    Title = "Auto Dungeon",
    Content = "Automatically clear stages up to Target Stage",
    Default = false,
    Callback = function(val)
        Config.AutoDungeon = val
        if val then
            task.spawn(AutoDungeonLoop)
        else
            local p = workspace:FindFirstChild("AutoDungeonPlatformNPLN")
            if p then p:Destroy() end
        end
    end
})

AutoDungeonSection:AddDropdown({
    Title = "Target Stage",
    Options = STAGE_LIST,
    Default = {"1"},
    Multi = false,
    Callback = function(val)
        if type(val) == "table" then
            Config.TargetStage = tonumber(val[1]) or 1
        else
            Config.TargetStage = tonumber(val) or 1
        end
    end
})

-- ============================================================
-- 2. TAB AUTO
-- ============================================================
end

local function LoadAutoTab()
local AutoTab = Tabs:AddTab({ Name = "Auto", Icon = "rbxassetid://10723415903" })

local TradeSection = AutoTab:AddSection("Auto Trade", false)

TradeSection:AddToggle({
    Title = "Auto Trade",
    Content = "Automatically equip and gift items to a target player",
    Default = false,
    Callback = function(val)
        Config.AutoTrade = val
        if val then
            AutoTradeLoop()
        end
    end
})

local playerNames = {"None"}
for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
    if p ~= game:GetService("Players").LocalPlayer then
        table.insert(playerNames, p.Name)
    end
end

local playerDrop = TradeSection:AddDropdown({
    Title = "Target Player",
    Content = "Select player from current server",
    Options = playerNames,
    Default = {"None"},
    Multi = false,
    Callback = function(val)
        local value = type(val) == "table" and val[1] or val
        Config.AutoTradePlayer = value
    end
})

TradeSection:AddButton({
    Title = "Refresh Player List",
    Content = "Click to refresh the dropdown with new players",
    Callback = function()
        local newPlayerNames = {"None"}
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            if p ~= game:GetService("Players").LocalPlayer then
                table.insert(newPlayerNames, p.Name)
            end
        end
        pcall(function() playerDrop:SetValues(newPlayerNames, {"None"}) end)
    end
})



local TRADE_ITEM_LIST = { "None" }
local trade_materials = {
    -- Dropped Potions
    "Lucky Potion", "Super Lucky Potion", 
    "Training Potion", "Super Training Potion",
    "Damage Potion", "Super Damage Potion",
    "Health Potion", "Super Health Potion",
    "Mana Potion", "Super Mana Potion",
    "Defense Potion", "Super Defense Potion",
    
    -- Forest Materials
    "Blueberry", "Withered Mushroom", "Golden Tooth", "Goblin Finger", "Dwarf Emblem", "Copper Earring", "Flame Crest", "Furnace Core",
    -- Pirate Materials
    "Coconut", "Shell", "Stale Bread", "Rum Bottle", "Black Powder", "Undead Skeletons", "Cursed Ring", "Undying Spirit",
    -- Lava Materials
    "Sulphur Lumps", "Volcanic Rock", "Orc Teeth", "Orc Ears", "Iron Armour", "Lava Behemoth Remains", "Golem Core", "Inferno Lotus",
    -- Dark Forest Materials
    "Crystal Orchid", "Spider Saliva", "Spider's cocoon", "Spider Claws", "Fluorescent Spider Silk", "Deadly Spider Powder", "Queen's Crown", "Queen Blood Sac",
    -- Autumn Forest Materials
    "Ginseng", "Tree Spirit", "Eye of Stone", "Firefly", "Dwarf Emblem", "Staff Gem", "Ritual Mask", "Prismatic Lotus",
    -- Winter Forest Materials
    "Sharp Fangs", "Bear Bone", "Ice Magic Crystal", "Bear Paw", "Scarlet Heart Flower", "Blue Dragon Egg", "Frost Vein", "Eye of the Ice Dragon"
}
for _, m in ipairs(trade_materials) do table.insert(TRADE_ITEM_LIST, m) end
for _, p in ipairs(potionOptions) do table.insert(TRADE_ITEM_LIST, p) end


local AutoPickupSection = AutoTab:AddSection("Pickup", false)

AutoPickupSection:AddToggle({
    Title = "Auto Pickup",
    Content = "Automatically pick up dropped items",
    Default = false,
    Callback = function(val)
        Config.AutoPickup = val
        if val then
            task.spawn(AutoPickupLoop)
        end
    end
})

local pickupNameDrop
pickupNameDrop = AutoPickupSection:AddDropdown({
    Title = "Filter By Name",
    Content = "Select item names to pick up",
    Options = {
        "None",
        -- Forest Materials
        "Blueberry", "Withered Mushroom", "Golden Tooth", "Goblin Finger", "Dwarf Emblem", "Copper Earring", "Flame Crest", "Furnace Core",
        -- Pirate Materials
        "Coconut", "Shell", "Stale Bread", "Rum Bottle", "Black Powder", "Undead Skeletons", "Cursed Ring", "Undying Spirit",
        -- Lava Materials
        "Sulphur Lumps", "Volcanic Rock", "Orc Teeth", "Orc Ears", "Iron Armour", "Lava Behemoth Remains", "Golem Core", "Inferno Lotus",
        -- Dark Forest Materials
        "Crystal Orchid", "Spider Saliva", "Spider's cocoon", "Spider Claws", "Fluorescent Spider Silk", "Deadly Spider Powder", "Queen's Crown", "Queen Blood Sac",
        -- Autumn Forest Materials
        "Ginseng", "Tree Spirit", "Eye of Stone", "Firefly", "Dwarf Emblem", "Staff Gem", "Ritual Mask", "Prismatic Lotus",
        -- Winter Forest Materials
        "Sharp Fangs", "Bear Bone", "Ice Magic Crystal", "Bear Paw", "Scarlet Heart Flower", "Blue Dragon Egg", "Frost Vein", "Eye of the Ice Dragon"
    },
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.AutoPickupName = handleDropdownChange(val, pickupNameDrop)
    end
})

local pickupRarityDrop
pickupRarityDrop = AutoPickupSection:AddDropdown({
    Title = "Filter By Rarity",
    Content = "Select item rarities to pick up",
    Options = {
        "None",
        "Common",
        "Uncommon",
        "Rare",
        "Epic",
        "Legendary",
        "Mythic",
        "Secret",
        "Ancient",
        "Supreme",
        "Astral"
    },
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.AutoPickupRarity = handleDropdownChange(val, pickupRarityDrop)
    end
})

local CraftingSection = AutoTab:AddSection("Auto Crafting", false)

task.wait(1) -- Tunggu list potion terisi

CraftingSection:AddToggle({
    Title = "Auto Craft Potion",
    Content = "Automatically crafts the selected potion continuously.",
    Default = false,
    Callback = function(val)
        Config.AutoCraft = val
        if val then
            AutoCraftLoop()
        end
    end
})

CraftingSection:AddDropdown({
    Title = "Select Potion to Craft",
    Options = potionOptions,
    Default = {"Wait..."},
    Multi = false,
    Callback = function(val)
        local value = type(val) == "table" and val[1] or val
        if value == "Wait..." then return end
        local id = recipeMap[value]
        if id then
            Config.AutoCraftTarget = id
        end
    end
})



TradeSection:AddDropdown({
    Title = "Target Item",
    Content = "Select material or potion to trade",
    Options = TRADE_ITEM_LIST,
    Default = {"None"},
    Multi = false,
    Callback = function(val)
        local value = type(val) == "table" and val[1] or val
        Config.AutoTradeItem = value
    end
})



TradeSection:AddInput({
    Title = "Trade Amount",
    Content = "How many items to trade?",
    Default = "1",
    Callback = function(val)
        Config.AutoTradeAmount = tonumber(val) or 1
    end
})

local AutoSellSection = AutoTab:AddSection("Auto Sell", false)

local rarityNames = {
    [1] = "Common", [2] = "Uncommon", [3] = "Rare", [4] = "Epic", [5] = "Legendary",
    [6] = "Mythic", [7] = "Secret", [8] = "Ancient", [9] = "Supreme", [10] = "Celestial"
}

local sellRarityOptions = {}
for i = 1, 10 do
    table.insert(sellRarityOptions, rarityNames[i])
end

AutoSellSection:AddToggle({
    Title = "Auto Sell Inventory",
    Content = "Automatically sells items from your backpack matching the filters.",
    Default = false,
    Callback = function(val)
        Config.AutoSell = val
        if val then
            task.spawn(AutoSellLoop)
        end
    end
})

AutoSellSection:AddToggle({
    Title = "Sell All Materials",
    Content = "Sell EVERY material in your backpack, ignoring filters.",
    Default = false,
    Callback = function(val)
        Config.AutoSellAll = val
    end
})

AutoSellSection:AddDropdown({
    Title = "Filter By Name",
    Content = "Select specific items to sell",
    Options = {
        -- Forest Materials
        "Blueberry", "Withered Mushroom", "Golden Tooth", "Goblin Finger", "Dwarf Emblem", "Copper Earring", "Flame Crest", "Furnace Core",
        -- Pirate Materials
        "Coconut", "Shell", "Stale Bread", "Rum Bottle", "Black Powder", "Undead Skeletons", "Cursed Ring", "Undying Spirit",
        -- Lava Materials
        "Sulphur Lumps", "Volcanic Rock", "Orc Teeth", "Orc Ears", "Iron Armour", "Lava Behemoth Remains", "Golem Core", "Inferno Lotus",
        -- Dark Forest Materials
        "Crystal Orchid", "Spider Saliva", "Spider's cocoon", "Spider Claws", "Fluorescent Spider Silk", "Deadly Spider Powder", "Queen's Crown", "Queen Blood Sac",
        -- Autumn Forest Materials
        "Ginseng", "Tree Spirit", "Eye of Stone", "Firefly", "Dwarf Emblem", "Staff Gem", "Ritual Mask", "Prismatic Lotus",
        -- Winter Forest Materials
        "Sharp Fangs", "Bear Bone", "Ice Magic Crystal", "Bear Paw", "Scarlet Heart Flower", "Blue Dragon Egg", "Frost Vein", "Eye of the Ice Dragon"
    },
    Default = {},
    Multi = true,
    Callback = function(val)
        if type(val) == "table" then
            Config.AutoSellName = val
        else
            Config.AutoSellName = {val}
        end
    end
})

AutoSellSection:AddDropdown({
    Title = "Filter By Rarity",
    Default = {},
    Options = sellRarityOptions,
    Multi = true,
    Callback = function(Value)
        for i = 1, 10 do
            Config.AutoSellRarities[i] = false
        end
        
        if type(Value) == "table" then
            for _, name in pairs(Value) do
                for i = 1, 10 do
                    if rarityNames[i] == name then
                        Config.AutoSellRarities[i] = true
                    end
                end
            end
        else
            for i = 1, 10 do
                if rarityNames[i] == Value then
                    Config.AutoSellRarities[i] = true
                end
            end
        end
    end
})


-- ============================================================
-- 3. TAB MISC
-- ============================================================
end

local function LoadMiscTab()
local MiscTab = Tabs:AddTab({ Name = "Misc", Icon = "rbxassetid://10734949856" })

local MiscSection = MiscTab:AddSection("Miscellaneous", false)

MiscSection:AddToggle({
    Title = "Anti AFK",
    Content = "Prevent being kicked for inactivity",
    Default = false,
    Callback = function(val)
        Config.AntiAFK = val
    end
})

MiscSection:AddToggle({
    Title = "Auto Claim Online Rewards",
    Content = "Automatically claims all available time-based online rewards",
    Default = false,
    Callback = function(val)
        Config.AutoClaimOnline = val
        if val then
            AutoClaimOnlineLoop()
        end
    end
})

local AutoTrainingSection = MiscTab:AddSection("Auto Training", false)

AutoTrainingSection:AddToggle({
    Title = "Auto Training",
    Content = "Automatically attack mobs or farm points",
    Default = false,
    Callback = function(val)
        Config.AutoTraining = val
        if val then
            task.spawn(AutoTrainingLoop)
        end
    end
})
end

LoadMainTab()
task.wait(0.05)
LoadAutoTab()
task.wait(0.05)
LoadMiscTab()
task.wait(0.05)
