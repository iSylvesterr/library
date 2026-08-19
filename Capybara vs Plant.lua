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

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- LOAD NAPOLEON UI LIBRARY
-- ============================================================
local function LoadNapoleonUI()
    local url = "https://raw.githubusercontent.com/Fdhlnn23/NapoleonUI/refs/heads/main/NPLN-UIv4.lua"
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and result and string.len(result) > 100 then
        -- [PATCH] Replace CoreGui with PlayerGui
        result = string.gsub(result, 'game:GetService%("CoreGui"%)', 'game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")')
        
        local func, err = loadstring(result)
        if func then
            local success2, lib = pcall(func)
            if success2 and lib then 
                return lib 
            else
                warn("[NapoleonUI] Execution Error: " .. tostring(lib))
            end
        else
            warn("[NapoleonUI] Parse Error: " .. tostring(err))
        end
    else
        warn("[NapoleonUI] Download Error or URL Dead.")
    end
    
    return nil
end

local Library = LoadNapoleonUI()
if not Library then
    warn("CRITICAL ERROR: Failed to load NapoleonUI library.")
    return
end

-- ============================================================
-- CONFIG & DATA
-- ============================================================
local Config = {
    AutoBounty = false,
    
    AutoBuyEgg = false,
    TargetEgg = {"None"},
    
    AutoBuyGear = false,
    TargetGear = {"None"},

    AutoBuyMerchant = false,
    TargetMerchant = {"None"},

    AutoCollectCash = false,
    AntiAFK = false,
    
    AutoClaim = false,
    AutoHatch = false,
    
    AutoSummonBoss = false,
    TargetBoss = {"None"},

    AutoSellCapybara = false,
    TargetSellCapybara = {"None"},
    
    AutoSellPlant = false,
    TargetSellPlant = {"None"}
}

local EGG_ROTATION = {
    "None",
    "Capybara Egg",
    "Alpha Capybara Egg",
    "Archer Capybara Egg",
    "Magic Capybara Egg",
    "Ghost Capybara Egg",
    "Golem Capybara Egg",
    "Robot Capybara Egg",
    "Disco Capybara Egg",
    "Angel Capybara Egg"
}

local GEAR_ROTATION = {
    "None",
    "Hatch Hammer", 
    "Nametag", 
    "Mutation Sponge", 
    "Boombox", 
    "Bizarre Stopwatch"
}

local MERCHANT_ROTATION = {
    "None",
    -- Martian
    "Raygun", "Alien Tesla", "Totem Of Stars",
    -- Timbles
    "Totem Of Might", "Totem Of Marrow", "Rainbow Scroll",
    -- King Capybara
    "Gilded Hatch Hammer", "Gold Scroll", "Totem Of Status",
    -- Jester
    "Moonlit Scroll", "Chilly Scroll", "Toasty Scroll", "Tranquil Scroll", "Shocked Scroll", "Glitched Scroll"
}

local SELL_CAPYBARA_LIST = {
    "None",
    "Capybara", "Alpha Capybara", "Archer Capybara", "Magic Capybara", 
    "Ghost Capybara", "Golem Capybara", "Robot Capybara", "Disco Capybara", "Angel Capybara"
}
local SELL_PLANT_LIST = {
    "None",
    "Carrot", "Potato", "Orange Tulip", "Broccoli", "Tomato", "Sunflower", 
    "Garlic", "Watermelon", "Cocotree", "Fancy Avocado", "Mandrake", 
    "Carnivorous Plant", "Ghost Pepper", "Magic Mushroom", "Pumpking", 
    "True Carrot", "Scarlet Carrot", "Red Potato", "Dark Tomato", 
    "Skull Flower", "Holy Grailic", "Carnivorous Jester", "Pumpkin Tyrant", "Golem King"
}

local BOSS_LIST = {
    "None",
    "Scarlet Carrot",
    "Red Potato",
    "Dark Tomato",
    "Skull Flower",
    "Holy Grailic",
    "Carnivorous Jester",
    "Pumpkin Tyrant",
    "Golem King",
    "Conqueror Carrot"
}

local BOSS_COOLDOWNS = {
    ["Scarlet Carrot"] = 30,
    ["Red Potato"] = 60,
    ["Dark Tomato"] = 210,
    ["Skull Flower"] = 300,
    ["Holy Grailic"] = 600,
    ["Carnivorous Jester"] = 1800,
    ["Pumpkin Tyrant"] = 3600,
    ["Golem King"] = 7200,
    ["Conqueror Carrot"] = 14400
}

local QUEST_IDS = {
    -- Daily
    "DailyDefeat75", "DailyDefeat150", "DailyHatch10", "DailyHatch15", 
    "DailyRare20", "DailyRare40", "DailyLegendary5", "DailyLegendary10", 
    "DailyBounty2", "DailyBounty4",
    
    -- Lifetime (L1 - L11)
    "L1Tutorial", "L1Defeat", "L1Hatch",
    "L2Defeat", "L2Rare", "L2Bounty",
    "L3Defeat", "L3Legend", "L3Bounty",
    "L4Defeat", "L4Legend", "L4Bounty",
    "L5Defeat", "L5Legend", "L5Mythic",
    "L6Defeat", "L6Mythic", "L6Bounty",
    "L7Defeat", "L7Mythic", "L7Divine",
    "L8Defeat", "L8Mythic", "L8Bounty",
    "L9Defeat", "L9Mythic", "L9Divine",
    "L10Defeat", "L10Divine", "L10Bounty",
    "L11Defeat", "L11Divine", "L11Bounty"
}

-- Helper untuk multi-select dropdown agar "None" otomatis hilang saat item lain dipilih,
-- dan "None" otomatis terpilih jika semua item di-unselect.
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
-- BUILD UI
-- ============================================================
local Window = Library:Window({
    Title = "Napoleon",
    Footer = "Capybara vs Plant",
    Color = Color3.fromRGB(81, 66, 255),
    Color2 = Color3.fromRGB(0, 0, 14),
    ["Tab Width"] = 130,
    Image = "111895858615511",
    WindowIMG = "91334002283698",
    LogoHUB = "136289055140268"
})

local Tabs = Window

-- 1. TAB MAIN
local MainTab = Tabs:AddTab({ Name = "Main", Icon = "home" })

local BountySection = MainTab:AddSection("Bounty", false)
BountySection:AddToggle({
    Title = "Auto Bounty Progress",
    Content = "Otomatis mencari, menghancurkan, dan menyetorkan plant yang diminta Bounty",
    Default = false,
    Callback = function(val)
        Config.AutoBounty = val
    end
})

local MainSection = MainTab:AddSection("Main Features", false)

-- 2. TAB AUTO
local AutoTab = Tabs:AddTab({ Name = "Auto", Icon = "play" })
local AutoSection = AutoTab:AddSection("Auto Farm", false)

AutoSection:AddToggle({
    Title = "Auto Collect Cash",
    Content = "Otomatis mengambil cash dari Collection Machine",
    Default = false,
    Callback = function(val)
        Config.AutoCollectCash = val
    end
})

AutoSection:AddToggle({
    Title = "Auto Hatch Egg",
    Content = "Otomatis menetaskan telur yang ada di plot",
    Default = false,
    Callback = function(val)
        Config.AutoHatch = val
    end
})

local BossSection = AutoTab:AddSection("Auto Boss", false)

BossSection:AddToggle({
    Title = "Auto Summon Boss",
    Content = "Otomatis memanggil boss jika cooldown sudah selesai",
    Default = false,
    Callback = function(val)
        Config.AutoSummonBoss = val
    end
})

local BossDropdown
BossDropdown = BossSection:AddDropdown({
    Title = "Target Boss",
    Options = BOSS_LIST,
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.TargetBoss = handleDropdownChange(val, BossDropdown)
    end
})

local AutoSellSection = AutoTab:AddSection("Auto Sell", false)

AutoSellSection:AddToggle({
    Title = "Auto Sell Capybara",
    Content = "Otomatis meng-equip dan menjual Capybara",
    Default = false,
    Callback = function(val)
        Config.AutoSellCapybara = val
    end
})

local SellCapybaraDropdown
SellCapybaraDropdown = AutoSellSection:AddDropdown({
    Title = "Target Capybara (Sell)",
    Options = SELL_CAPYBARA_LIST,
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.TargetSellCapybara = handleDropdownChange(val, SellCapybaraDropdown)
    end
})

AutoSellSection:AddToggle({
    Title = "Auto Sell Plant",
    Content = "Otomatis meng-equip dan menjual Plant",
    Default = false,
    Callback = function(val)
        Config.AutoSellPlant = val
    end
})

local SellPlantDropdown
SellPlantDropdown = AutoSellSection:AddDropdown({
    Title = "Target Plant (Sell)",
    Options = SELL_PLANT_LIST,
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.TargetSellPlant = handleDropdownChange(val, SellPlantDropdown)
    end
})

-- 3. TAB SHOP
local ShopTab = Tabs:AddTab({ Name = "Shop", Icon = "shopping-cart" })

-- == EGG SHOP ==
local EggSection = ShopTab:AddSection("Egg Shop", false)
EggSection:AddToggle({
    Title = "Auto Buy Egg",
    Content = "Otomatis membeli telur pilihan saat muncul di shop",
    Default = false,
    Callback = function(val)
        Config.AutoBuyEgg = val
    end
})

local EggDropdown
EggDropdown = EggSection:AddDropdown({
    Title = "Target Egg",
    Options = EGG_ROTATION,
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.TargetEgg = handleDropdownChange(val, EggDropdown)
    end
})

-- == GEAR SHOP ==
local GearSection = ShopTab:AddSection("Gear Shop", false)
GearSection:AddToggle({
    Title = "Auto Buy Gear",
    Content = "Otomatis membeli gear pilihan saat muncul di shop",
    Default = false,
    Callback = function(val)
        Config.AutoBuyGear = val
    end
})

local GearDropdown
GearDropdown = GearSection:AddDropdown({
    Title = "Target Gear",
    Options = GEAR_ROTATION,
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.TargetGear = handleDropdownChange(val, GearDropdown)
    end
})

-- == MERCHANT SHOP ==
local MerchantSection = ShopTab:AddSection("Merchant Shop", false)
MerchantSection:AddToggle({
    Title = "Auto Buy Merchant",
    Content = "Otomatis membeli item pilihan dari Traveling Merchant",
    Default = false,
    Callback = function(val)
        Config.AutoBuyMerchant = val
    end
})

local MerchantDropdown
MerchantDropdown = MerchantSection:AddDropdown({
    Title = "Target Item",
    Options = MERCHANT_ROTATION,
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.TargetMerchant = handleDropdownChange(val, MerchantDropdown)
    end
})

-- 4. TAB MISC
local MiscTab = Tabs:AddTab({ Name = "Misc", Icon = "settings" })
local MiscSection = MiscTab:AddSection("Miscellaneous", false)

MiscSection:AddToggle({
    Title = "Auto Claim (Quests & Playtime)",
    Content = "Otomatis mengklaim hadiah Playtime, Daily Quest, dan Lifetime Quest",
    Default = false,
    Callback = function(val)
        Config.AutoClaim = val
    end
})

MiscSection:AddToggle({
    Title = "Anti AFK",
    Content = "Mencegah ter-kick dari game jika AFK lebih dari 20 menit",
    Default = false,
    Callback = function(val)
        Config.AntiAFK = val
    end
})

local spoofingActive = false
local function escapePattern(str)
    return str:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
end

local trackerInitialized = false
local trackedObjects = {}
local connections = {}

MiscSection:AddToggle({
    Title = "Streamer Mode (Spoof Names)",
    Content = "Menyamarkan semua nama player di Leaderboard, ESC, Chat, dan Sign Plot menjadi #NAPOLEON",
    Default = false,
    Callback = function(val)
        spoofingActive = val
        if val then
            local function applySpoof(textObj)
                if not spoofingActive then return end
                
                pcall(function()
                    local txt = textObj.Text
                    if not txt or txt == "" or txt == "#NAPOLEON" or string.find(txt, "#NAPOLEON") then return end
                    
                    local changed = false
                    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
                        if p.Name and p.Name ~= "" and txt:find(p.Name, 1, true) then
                            txt = txt:gsub(escapePattern(p.Name), "#NAPOLEON")
                            changed = true
                        end
                        if p.DisplayName and p.DisplayName ~= "" and txt:find(p.DisplayName, 1, true) then
                            txt = txt:gsub(escapePattern(p.DisplayName), "#NAPOLEON")
                            changed = true
                        end
                    end
                    if changed then
                        textObj.Text = txt
                    end
                end)
            end

            local function trackObj(obj)
                if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                    if not connections[obj] then
                        connections[obj] = obj:GetPropertyChangedSignal("Text"):Connect(function()
                            applySpoof(obj)
                        end)
                        table.insert(trackedObjects, obj)
                        applySpoof(obj)
                    end
                end
            end

            local function initTracker(parent)
                pcall(function()
                    for _, obj in ipairs(parent:GetDescendants()) do
                        trackObj(obj)
                    end
                    connections[parent] = parent.DescendantAdded:Connect(trackObj)
                end)
            end

            if not trackerInitialized then
                trackerInitialized = true
                initTracker(game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
                initTracker(game:GetService("CoreGui"))
                
                local plots = workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Map") and workspace.World.Map:FindFirstChild("Plots")
                if plots then
                    initTracker(plots)
                end
            else
                for _, obj in ipairs(trackedObjects) do
                    applySpoof(obj)
                end
            end
        end
    end
})

-- ============================================================
-- LOOPS
-- ============================================================
local lastSummonTimes = {}
local lastQuestClaimTime = 0
local lastHatchAttempt = {}

local function autoBuyLoop()
    while task.wait(1) do
        -- Auto Sell Logic
        local function equipAndSell(tool)
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid and tool.Parent ~= character then
                humanoid:EquipTool(tool)
                task.wait(0.1)
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                if remotes and remotes:FindFirstChild("Sell") then
                    remotes.Sell:FireServer("equippedItem")
                end
                task.wait(0.1)
            end
        end

        if Config.AutoSellCapybara or Config.AutoSellPlant then
            pcall(function()
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if backpack then
                    for _, tool in ipairs(backpack:GetChildren()) do
                        if tool:IsA("Tool") and tool:GetAttribute("Favorited") ~= true then
                            local sold = false
                            -- Check Capybara
                            if Config.AutoSellCapybara then
                                for _, targetName in ipairs(Config.TargetSellCapybara) do
                                    if targetName ~= "None" and string.find(tool.Name, targetName) then
                                        equipAndSell(tool)
                                        sold = true
                                        break
                                    end
                                end
                            end
                            
                            -- Check Plant
                            if not sold and Config.AutoSellPlant then
                                for _, targetName in ipairs(Config.TargetSellPlant) do
                                    if targetName ~= "None" and string.find(tool.Name, targetName) then
                                        equipAndSell(tool)
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end

        -- Auto Collect Cash
        if Config.AutoCollectCash then
            pcall(function()
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                if remotes then
                    local collectRemote = remotes:FindFirstChild("CollectionMachine")
                    if collectRemote and collectRemote:IsA("RemoteEvent") then
                        collectRemote:FireServer()
                    end
                end
            end)
        end
        
        -- Auto Hatch Egg
        if Config.AutoHatch then
            pcall(function()
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                if remotes and remotes:FindFirstChild("Hatch") then
                    local placedItems = workspace:FindFirstChild("World") 
                        and workspace.World:FindFirstChild("Map") 
                        and workspace.World.Map:FindFirstChild("PlacedItems")
                        
                    if placedItems then
                        local clientItems = placedItems:FindFirstChild("Client")
                        local serverItems = placedItems:FindFirstChild("Server")
                        
                        if clientItems and serverItems then
                            for _, item in ipairs(clientItems:GetChildren()) do
                                if string.find(item.Name, "Egg:") then
                                    local serverEgg = serverItems:FindFirstChild(item.Name)
                                    if serverEgg then
                                        local timerLbl = serverEgg:FindFirstChild("PrimaryPart")
                                            and serverEgg.PrimaryPart:FindFirstChild("EggInfoBillboard")
                                            and serverEgg.PrimaryPart.EggInfoBillboard:FindFirstChild("Frame")
                                            and serverEgg.PrimaryPart.EggInfoBillboard.Frame:FindFirstChild("Timer")
                                        
                                        if timerLbl and timerLbl:IsA("TextLabel") then
                                            local text = string.upper(timerLbl.Text)
                                            if text == "READY" or text == "READY!" then
                                                local lastAttempt = lastHatchAttempt[item.Name] or 0
                                                if os.clock() - lastAttempt >= 5 then
                                                    lastHatchAttempt[item.Name] = os.clock()
                                                    remotes.Hatch:FireServer(item.Name)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end

        -- Auto Summon Boss
        if Config.AutoSummonBoss then
            pcall(function()
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                if remotes and remotes:FindFirstChild("SummonBoss") then
                    for _, bossName in ipairs(Config.TargetBoss) do
                        if bossName ~= "None" then
                            local cd = BOSS_COOLDOWNS[bossName] or 30
                            local lastTime = lastSummonTimes[bossName] or 0
                            
                            -- Cek apakah cooldown sudah selesai
                            if os.clock() - lastTime >= cd then
                                lastSummonTimes[bossName] = os.clock() -- Update waktu agar tidak spam
                                
                                task.spawn(function()
                                    pcall(function()
                                        remotes.SummonBoss:InvokeServer("Summon", bossName)
                                    end)
                                end)
                            end
                        end
                    end
                end
            end)
        end

        -- Auto Claim (Playtime & Quests)
        if Config.AutoClaim then
            -- 1. Playtime Reward (Membaca UI)
            pcall(function()
                local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if PlayerGui then
                    local RewardsFrame = PlayerGui:FindFirstChild("MainGui")
                        and PlayerGui.MainGui:FindFirstChild("Root")
                        and PlayerGui.MainGui.Root:FindFirstChild("Frames")
                        and PlayerGui.MainGui.Root.Frames:FindFirstChild("PlaytimeRewards")
                        and PlayerGui.MainGui.Root.Frames.PlaytimeRewards:FindFirstChild("RewardsFrame")
                    
                    if RewardsFrame then
                        local claimRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("ClaimPlaytimeReward")
                        if claimRemote then
                            for i = 1, 11 do
                                local rewardObj = RewardsFrame:FindFirstChild("Reward" .. tostring(i))
                                if rewardObj then
                                    local costTextLabel = rewardObj:FindFirstChild("Claim") 
                                        and rewardObj.Claim:FindFirstChild("Details") 
                                        and rewardObj.Claim.Details:FindFirstChild("Cost")
                                    
                                    if costTextLabel and costTextLabel:IsA("TextLabel") then
                                        local ownedFrame = rewardObj:FindFirstChild("OwnedFrame")
                                        local isOwned = ownedFrame and ownedFrame.Visible == true
                                        local isClaimVisible = rewardObj:FindFirstChild("Claim") and rewardObj.Claim.Visible ~= false
                                        
                                        if not isOwned and isClaimVisible and string.upper(costTextLabel.Text) == "CLAIM" then
                                            claimRemote:FireServer("Reward" .. tostring(i))
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            
            -- 2. Quest Reward (Loop 60 detik)
            if os.clock() - lastQuestClaimTime >= 60 then
                lastQuestClaimTime = os.clock()
                task.spawn(function()
                    pcall(function()
                        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                        if remotes and remotes:FindFirstChild("ClaimQuest") then
                            local QuestData = require(ReplicatedStorage.Modules.QuestData)
                            
                            -- Claim semua Daily
                            for _, q in ipairs(QuestData.Daily or {}) do
                                pcall(function() remotes.ClaimQuest:InvokeServer(q.Id) end)
                                task.wait(0.05)
                            end
                            pcall(function() remotes.ClaimQuest:InvokeServer("DailyBonus") end)
                            
                            -- Claim semua Lifetime & LevelReward
                            for level, levelData in pairs(QuestData.Lifetime or {}) do
                                for _, q in ipairs(levelData.Quests or {}) do
                                    pcall(function() remotes.ClaimQuest:InvokeServer(q.Id) end)
                                    task.wait(0.05)
                                end
                                pcall(function() remotes.ClaimQuest:InvokeServer("LevelReward:" .. tostring(level)) end)
                                task.wait(0.05)
                            end
                        end
                    end)
                end)
            end
        end

        -- Egg
        if Config.AutoBuyEgg then
            pcall(function()
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                if remotes then
                    local buyRemote = remotes:FindFirstChild("Purchase") or remotes:FindFirstChild("BuyItem") or remotes:FindFirstChild("ShopPurchase")
                    if buyRemote then
                        for _, eggName in ipairs(Config.TargetEgg) do
                            if eggName ~= "None" then
                                if buyRemote:IsA("RemoteEvent") then buyRemote:FireServer(eggName)
                                elseif buyRemote:IsA("RemoteFunction") then buyRemote:InvokeServer(eggName) end
                            end
                        end
                    end
                end
            end)
        end

        -- Gear
        if Config.AutoBuyGear then
            pcall(function()
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                if remotes then
                    local buyRemote = remotes:FindFirstChild("Purchase") or remotes:FindFirstChild("BuyItem") or remotes:FindFirstChild("ShopPurchase")
                    if buyRemote then
                        for _, gearName in ipairs(Config.TargetGear) do
                            if gearName ~= "None" then
                                if buyRemote:IsA("RemoteEvent") then buyRemote:FireServer(gearName)
                                elseif buyRemote:IsA("RemoteFunction") then buyRemote:InvokeServer(gearName) end
                            end
                        end
                    end
                end
            end)
        end

        -- Merchant
        if Config.AutoBuyMerchant then
            pcall(function()
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                if remotes then
                    local buyRemote = remotes:FindFirstChild("BuyMerchantItem")
                    if buyRemote then
                        for _, merchantItem in ipairs(Config.TargetMerchant) do
                            if merchantItem ~= "None" then
                                if buyRemote:IsA("RemoteEvent") then buyRemote:FireServer(merchantItem)
                                elseif buyRemote:IsA("RemoteFunction") then buyRemote:InvokeServer(merchantItem) end
                            end
                        end
                    end
                end
            end)
        end
    end
end

task.spawn(autoBuyLoop)

-- ============================================================
-- EVENTS
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
-- AUTO BOUNTY LOOP
-- ============================================================
task.spawn(function()
    local lastBountyId = ""
    local triedTools = {}
    
    local plantRarities = {}
    pcall(function()
        local plantData = game:GetService("ReplicatedStorage"):FindFirstChild("Modules") and game:GetService("ReplicatedStorage").Modules:FindFirstChild("PlantData")
        if plantData then
            for _, child in ipairs(plantData:GetChildren()) do
                local rarity = child:FindFirstChild("Rarity")
                if rarity then
                    table.insert(plantRarities, {Name = child.Name, Rarity = rarity.Value})
                end
            end
            -- Sort by name length descending so "Red Potato" is matched before "Potato"
            table.sort(plantRarities, function(a, b) return string.len(a.Name) > string.len(b.Name) end)
        end
    end)
    
    local function isToolValid(toolName, bounty)
        if bounty.PlantName and not string.find(toolName, bounty.PlantName) then return false end
        
        if bounty.Mutations then
            for _, mut in ipairs(bounty.Mutations) do
                if not string.find(toolName, mut) then return false end
            end
        end
        
        -- Cek Rarity cerdas berdasarkan PlantData bawaan game!
        if bounty.Rarity then
            local toolRarity = nil
            for _, pData in ipairs(plantRarities) do
                if string.find(toolName, pData.Name) then
                    toolRarity = pData.Rarity
                    break
                end
            end
            
            if toolRarity and toolRarity ~= bounty.Rarity then
                return false
            end
        end
        
        return true
    end

    while task.wait(1) do
        if not Config.AutoBounty then continue end
        
        pcall(function()
            local BountyData = require(game:GetService("ReplicatedStorage").Modules.BountyData)
            local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
            if not remotes or not remotes:FindFirstChild("RequestBounties") then return end
            
            local status = remotes.RequestBounties:InvokeServer()
            if not status then return end
            
            local easy, hard = BountyData.generate()
            local activeBounties = {}
            if not status.EasyClaimed then table.insert(activeBounties, easy) end
            if not status.HardClaimed then table.insert(activeBounties, hard) end
            
            if #activeBounties == 0 then return end
            
            local character = game:GetService("Players").LocalPlayer.Character
            local backpack = game:GetService("Players").LocalPlayer:FindFirstChild("Backpack")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if not character or not backpack or not humanoid then return end
            
            -- Step 1: Cek Backpack untuk SEMUA active bounties
            local foundInBackpack = false
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:GetAttribute("isPlant") and not triedTools[tool] then
                    for _, bounty in ipairs(activeBounties) do
                        if isToolValid(tool.Name, bounty) then
                            humanoid:EquipTool(tool)
                            task.wait(0.5)
                            local success = remotes.TurnInBounty:InvokeServer()
                            if success then
                                foundInBackpack = true
                                break
                            else
                                triedTools[tool] = true
                            end
                        end
                    end
                    if foundInBackpack then break end
                end
            end
            
            if foundInBackpack then return end
            
            -- Step 2: Cari plant di map untuk SEMUA active bounties
            local clientPlants = workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Map") and workspace.World.Map:FindFirstChild("Plants") and workspace.World.Map.Plants:FindFirstChild("Client")
            local serverPlants = workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Map") and workspace.World.Map:FindFirstChild("Plants") and workspace.World.Map.Plants:FindFirstChild("Server")
            
            if clientPlants and serverPlants and character.PrimaryPart then
                local targetPlantModel = nil
                
                for _, plant in ipairs(clientPlants:GetChildren()) do
                    local serverPlant = serverPlants:FindFirstChild(plant.Name)
                    if serverPlant and serverPlant:GetAttribute("Owner") == game:GetService("Players").LocalPlayer.UserId then
                        local plantName = string.split(plant.Name, ":")[1]
                        
                        local rarityLbl = plant:FindFirstChild("PrimaryPart") and plant.PrimaryPart:FindFirstChild("PlantInfoBillboard") and plant.PrimaryPart.PlantInfoBillboard:FindFirstChild("Frame") and plant.PrimaryPart.PlantInfoBillboard.Frame:FindFirstChild("Rarity")
                        local rarityStr = rarityLbl and rarityLbl.Text or "Common"
                        
                        local mutations = {}
                        local mutFolder = plant:FindFirstChild("PrimaryPart") and plant.PrimaryPart:FindFirstChild("PlantInfoBillboard") and plant.PrimaryPart.PlantInfoBillboard:FindFirstChild("Frame") and plant.PrimaryPart.PlantInfoBillboard.Frame:FindFirstChild("Mutations")
                        if mutFolder then
                            for _, mutLbl in ipairs(mutFolder:GetChildren()) do
                                local mutName = string.gsub(mutLbl.Name, "TextLabel", "")
                                table.insert(mutations, mutName)
                            end
                        end
                        
                        for _, bounty in ipairs(activeBounties) do
                            if BountyData.matches(bounty, plantName, rarityStr, 10, mutations) then
                                targetPlantModel = plant
                                break
                            end
                        end
                        if targetPlantModel then break end
                    end
                end
                
                -- Step 3: Datangi dan Pukul!
                if targetPlantModel and targetPlantModel.PrimaryPart then
                    local shovel = character:FindFirstChildOfClass("Tool")
                    if not (shovel and string.find(shovel.Name, "Shovel")) then
                        shovel = nil
                        for _, t in ipairs(backpack:GetChildren()) do
                            if string.find(t.Name, "Shovel") then
                                shovel = t
                                break
                            end
                        end
                    end
                    
                    if shovel then
                        local originalCFrame = character.PrimaryPart.CFrame
                        
                        humanoid:EquipTool(shovel)
                        
                        local RunService = game:GetService("RunService")
                        local connection
                        connection = RunService.Heartbeat:Connect(function()
                            if targetPlantModel.Parent and targetPlantModel.PrimaryPart and character.PrimaryPart then
                                local targetCFrame = targetPlantModel.PrimaryPart.CFrame
                                character.PrimaryPart.CFrame = CFrame.lookAt((targetCFrame * CFrame.new(0, 0, 3)).Position, targetCFrame.Position)
                            else
                                if connection then connection:Disconnect() end
                            end
                        end)
                        
                        local timeout = 0
                        while targetPlantModel.Parent and timeout < 40 do
                            shovel:Activate()
                            task.wait(0.15)
                            timeout = timeout + 1
                        end
                        
                        if connection then connection:Disconnect() end
                        
                        -- Kembalikan ke tempat semula agar tidak nyangkut
                        if character and character.PrimaryPart then
                            character.PrimaryPart.CFrame = originalCFrame
                        end
                    end
                end
            end
        end)
    end
end)

Library:Init()


