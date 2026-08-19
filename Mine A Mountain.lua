-- Mencegah tabrakan saat script di run 2 kali
if getgenv()._NapoMinMounRunning then
    getgenv()._NapoMinMounRunning = false
    task.wait(0.5) -- Tunggu loop lama mati
end
getgenv()._NapoMinMounRunning = true

local config = {
    CrystalESP = false,
    ESPRarities = {"All"},
    ESPTerrain = false,
    ESPTerrainMaterials = {"Limestone"},
    AutoMine = false,
    AutoCollectDrop = false,
    SelectedRarities = {"All"},
    SelectedSizes = {"All"},
    AutoSellTrigger = "Backpack Full",
    AntiAFK = true,
    InstantProximity = false,
    GodMode = false,
    TerrainNukeAura = false,
    AutoBotMountain = false,
    AutoClearArea = false,
    ClearAreaCenter = Vector3.new(0, 0, 0),
    ClearAreaUp = 200,
    ClearAreaDown = 500,
    ClearAreaRadius = 50,
    MountainDensity = 5,
    AreaDensity = 5,
    updateVisualizer = nil,
    updateESP = nil
}

-- ============================================================
-- TEMPLATE UI - KUMPULAN SEMUA FUNGSI UI YANG TERSEDIA
-- Digabungkan dari Wizard, AOT, BeFlash, kick a lucky
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

-- ============================================================
-- KEY SYSTEM (Ed25519 Challenge-Response + Server Response Verification)
-- ============================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local key = getgenv().Key or _G.Key   
local privateKey = config.PrivateKey or config.PrivateKey
local serverUrl = "https://napoleonn.net"

-- ===== SERVER PUBLIC KEY — hardcoded, never changes =====
-- Get from .env SERVER_PUBLIC_KEY (shown in server console on startup)
local SERVER_PUBLIC_KEY = "75dce92b8fcda87aa2e50eadd3c264f153d2f9953eb37b2870047daa0a42637f"

if not key then
    showWarningUI("Key not found! Please enter config.Key")
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

-- ===== OPTIMIZED FAST XOR CRYPTO =====
local SECRET_KEY = "HOEEEE_MALING_PANGSIT"
local SK_LEN = #SECRET_KEY
local SK_BYTES = { string.byte(SECRET_KEY, 1, SK_LEN) }

local HEX_TO_BYTE = {}
local BYTE_TO_HEX = {}
for i = 0, 255 do
    local hexLow = string.format("%02x", i)
    local hexUp = string.format("%02X", i)
    HEX_TO_BYTE[hexLow] = i
    HEX_TO_BYTE[hexUp] = i
    BYTE_TO_HEX[i] = hexLow
end

local function encryptXOR(text, secretKey)
    if not text or text == "" then return "" end
    local len = #text
    local keyLen = (secretKey == SECRET_KEY) and SK_LEN or #secretKey
    local keyBytes = (secretKey == SECRET_KEY) and SK_BYTES or { string.byte(secretKey, 1, keyLen) }
    local result = table.create and table.create(len) or {}
    for i = 1, len do
        local b = string.byte(text, i)
        local k = keyBytes[(i - 1) % keyLen + 1]
        result[i] = BYTE_TO_HEX[bit32.bxor(b, k)]
    end
    return table.concat(result)
end

local function decryptXOR(hexStr, secretKey)
    if not hexStr or hexStr == "" then return nil end
    local len = #hexStr
    local nBytes = math.floor(len / 2)
    local keyLen = (secretKey == SECRET_KEY) and SK_LEN or #secretKey
    local keyBytes = (secretKey == SECRET_KEY) and SK_BYTES or { string.byte(secretKey, 1, keyLen) }
    local resBytes = table.create and table.create(nBytes) or {}
    local idx = 1
    for i = 1, len, 2 do
        local h = string.sub(hexStr, i, i + 1)
        local b = HEX_TO_BYTE[h] or tonumber(h, 16) or 0
        local k = keyBytes[(idx - 1) % keyLen + 1]
        resBytes[idx] = bit32.bxor(b, k)
        idx = idx + 1
    end
    local chunkLen = 4000
    local chunks = {}
    for i = 1, nBytes, chunkLen do
        local j = math.min(i + chunkLen - 1, nBytes)
        table.insert(chunks, string.char(table.unpack(resBytes, i, j)))
    end
    return table.concat(chunks)
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
                        showWarningUI("Session expired / Time Mismatch!")
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
    showWarningUI(authMessage ~= "" and authMessage or "Invalid Key / Verification Failed!")
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
        local logPath = "Napoleon_Template_LastExec.txt"
        
        if isfile and readfile and writefile then
            if isfile(logPath) then
                local lastTime = tonumber(readfile(logPath))
                if lastTime and (currentTime - lastTime) < 3600 then
                    return 
                end
            end
            writefile(logPath, tostring(currentTime))
        else
            if config._Napoleon_ExecLogged_Template then return end
            config._Napoleon_ExecLogged_Template = true
        end

        local player = LocalPlayer
        if player then
            local userid = tostring(player.UserId)
            local username = player.Name
            local executor = getExecutorName()
            local placeid = tostring(game.PlaceId)
            
            local url = serverUrl .. "/api/track"
                .. "?script=Template-UI"
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
-- UI SETUP (Napoleon Library)
-- ============================================================
local function LoadNapoleonUI()
    local url = "https://raw.githubusercontent.com/iSylvesterr/library/refs/heads/main/NewUI.lua"
    local cacheName = "Napoleon_NewUI_cached.lua"
    
    local result = nil
    if isfile and readfile and isfile(cacheName) then
        pcall(function() result = readfile(cacheName) end)
    end
    
    if not result or result == "" or string.len(result) < 100 then
        for i = 1, 3 do
            local success, res = pcall(function()
                return game:HttpGet(url)
            end)
            if success and res and string.len(res) > 100 and not string.match(res, "404: Not Found") then
                result = res
                if writefile then
                    pcall(function() writefile(cacheName, result) end)
                end
                break
            end
            task.wait(1)
        end
    end
    
    if result and string.len(result) > 100 then
        -- [PATCH] Replace CoreGui with PlayerGui to fix Potassium 'lacking capability Plugin' error
        result = string.gsub(result, 'game:GetService%%("CoreGui"%%)', 'game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")')
        
        local func, err = loadstring(result)
        if func then
            local success, lib = pcall(func)
            if success and lib then 
                return lib 
            else
                warn("[NapoleonUI] Execution Error: " .. tostring(lib))
            end
        else
            warn("[NapoleonUI] Parse Error: " .. tostring(err))
        end
    end
    
    return nil
end

local Library = LoadNapoleonUI()
if not Library then
    warn("CRITICAL ERROR: Failed to load NapoleonUI library from GitHub. Please check your internet connection or executor.")
    return
end
local ICON_ID = "96531489912535" 

-- ============================================================
-- FUNGSI NOTIFIKASI BAWAAN LIBRARY
-- ============================================================
local function notif(content, duration, title)
    if Library and Library.MakeNotify then
        Library:MakeNotify({ 
            Title = title or "Notification", 
            Content = content, 
            Delay = duration or 4, 
            Icon = "rbxassetid://" .. ICON_ID 
        })
    end
end

-- ============================================================
-- 1. MEMBUAT WINDOW UTAMA
-- ============================================================
local Window = Library:Window({
    Title = "Napoleon",
    Footer = "Mine Mountain",
    Color = Color3.fromRGB(50, 50, 50),
    Color2 = Color3.fromRGB(20, 20, 20),
    ["Tab Width"] = 130,
    Image = "111895858615511",
    WindowIMG = "91334002283698",
    LogoHUB = "119958938217417"
})
local Tabs = Window

-- ============================================================
-- ESP & AUTO MINE LOGIC
-- ============================================================
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local DigRequest = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DigRequest")
local SellRequest = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SellRequest")


-- ESP Function

local function getCrystalsFolder()
    local things = workspace:FindFirstChild("Things")
    if things and things:FindFirstChild("Crystals") then
        return things.Crystals
    end
    return workspace:FindFirstChild("Crystals")
end

local function addESP(crystal)
    if not crystal:IsA("BasePart") and not crystal:IsA("Model") then return end
    local part = crystal:IsA("Model") and crystal.PrimaryPart or crystal
    if not part or not part:IsA("BasePart") then return end

    local rarity = crystal:GetAttribute("TierName") or "Common"
    local cColor = Color3.fromRGB(255, 255, 255)
    if rarity == "Common" then cColor = Color3.fromRGB(150, 150, 150)
    elseif rarity == "Uncommon" then cColor = Color3.fromRGB(0, 255, 0)
    elseif rarity == "Rare" then cColor = Color3.fromRGB(0, 150, 255)
    elseif rarity == "Epic" then cColor = Color3.fromRGB(160, 32, 240)
    elseif rarity == "Legendary" then cColor = Color3.fromRGB(255, 165, 0)
    elseif rarity == "Mythic" then cColor = Color3.fromRGB(255, 0, 0)
    else cColor = Color3.fromRGB(0, 255, 255) end

    local bg = Instance.new("BillboardGui")
    bg.Name = "CrystalESP"
    bg.Adornee = part
    bg.Size = UDim2.new(0, 100, 0, 40)
    bg.StudsOffset = Vector3.new(0, 3, 0)
    bg.AlwaysOnTop = true

    local text = Instance.new("TextLabel")
    text.Parent = bg
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = (crystal:GetAttribute("CrystalName") or crystal.Name) .. " [" .. rarity .. "]"
    text.TextColor3 = cColor
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    text.TextScaled = true

    bg.Parent = part

    local highlight = Instance.new("Highlight")
    highlight.Name = "CrystalHighlight"
    highlight.Adornee = crystal
    highlight.FillColor = cColor
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = cColor
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = part
end

local function removeESP(crystal)
    local part = crystal:IsA("Model") and crystal.PrimaryPart or crystal
    if part then
        if part:FindFirstChild("CrystalESP") then
            part.CrystalESP:Destroy()
        end
        if part:FindFirstChild("CrystalHighlight") then
            part.CrystalHighlight:Destroy()
        end
    end
end

local function updateESP()
    local crystalsFolder = getCrystalsFolder()
    if not crystalsFolder then return end

    for _, crystal in ipairs(crystalsFolder:GetChildren()) do
        local rarity = crystal:GetAttribute("TierName") or "Common"
        local allowed = true
        if config.ESPRarities and #config.ESPRarities > 0 then
            allowed = false
            for _, r in ipairs(config.ESPRarities) do
                if r == "All" or r == rarity then
                    allowed = true
                    break
                end
            end
        end

        if config.CrystalESP and allowed then
            local part = crystal:IsA("Model") and crystal.PrimaryPart or crystal
            if part and not part:FindFirstChild("CrystalESP") then
                addESP(crystal)
            end
        else
            removeESP(crystal)
        end
    end
end

task.spawn(function()
    while getgenv()._NapoMinMounRunning and task.wait(1) do
        updateESP()
    end
end)


local terrainESPFolder = nil
local TerrainProgress = nil

local function clearTerrainESP()
    if terrainESPFolder then
        terrainESPFolder:ClearAllChildren()
    end
    if TerrainProgress then
        pcall(function() TerrainProgress:Set({ Title = "Scan Progress", Content = "Waiting for scan to start..." }) end)
    end
end

local function startTerrainScan()
    if not config.ESPTerrain then return end
    
    if not terrainESPFolder then
        terrainESPFolder = Instance.new("Folder")
        terrainESPFolder.Name = "NapoTerrainESP"
        terrainESPFolder.Parent = workspace
    end
    terrainESPFolder:ClearAllChildren()
    
    -- Ambil dimensi gunung
    local cx = workspace:GetAttribute("MountainCenterX") or 0
    local cz = workspace:GetAttribute("MountainCenterZ") or 0
    local peakY = (workspace:GetAttribute("MountainActualPeakY") or workspace:GetAttribute("MountainPeakY") or 2800) + 200
    local baseY = workspace:GetAttribute("MountainBaseY") or 0
    local radius = workspace:GetAttribute("MountainRadius") or 200
    
    local minX = cx - radius
    local maxX = cx + radius
    local minZ = cz - radius
    local maxZ = cz + radius
    
    local step = 64
    local totalChunks = math.max(1, math.ceil((maxX - minX)/step) * math.ceil((peakY - baseY)/step) * math.ceil((maxZ - minZ)/step))
    local currentChunk = 0
    
    -- SPATIAL GRID CHUNKING UNTUK ESP SUPER CLEAN
    local gridSize = 32
    local gridData = {}
    
    local function getGridKey(gx, gy, gz)
        return math.floor(gx/gridSize) .. "," .. math.floor(gy/gridSize) .. "," .. math.floor(gz/gridSize)
    end
    
    for x = minX, maxX, step do
        for y = baseY, peakY, step do
            for z = minZ, maxZ, step do
                if not config.ESPTerrain or not getgenv()._NapoMinMounRunning then
                    return
                end
                
                currentChunk = currentChunk + 1
                if currentChunk % 5 == 0 then
                    if TerrainProgress then
                        pcall(function() TerrainProgress:Set({ Title = "Scan Progress", Content = "Scanning: " .. math.floor((currentChunk/totalChunks)*100) .. "% (" .. currentChunk .. "/" .. totalChunks .. ")" }) end)
                    end
                    task.wait()
                end
                
                local r3 = Region3.new(Vector3.new(x, y, z), Vector3.new(x + step, y + step, z + step)):ExpandToGrid(4)
                local success, mats, occs = pcall(function() return workspace.Terrain:ReadVoxels(r3, 4) end)
                if success and mats then
                    local sz = mats.Size
                    for i = 1, sz.X, 2 do -- Fast scan
                        for j = 1, sz.Y, 2 do
                            for k = 1, sz.Z, 2 do
                                if occs[i][j][k] > 0.1 then
                                    local mat = mats[i][j][k]
                                    local matName = mat.Name
                                    
                                    local allowed = false
                                    if config.ESPTerrainMaterials and #config.ESPTerrainMaterials > 0 then
                                        for _, selMat in ipairs(config.ESPTerrainMaterials) do
                                            if selMat == "All" or selMat == matName then allowed = true break end
                                        end
                                    end
                                    
                                    if allowed then
                                        local r3Start = r3.CFrame.Position - (r3.Size / 2)
                                        local exactPos = r3Start + Vector3.new((i-0.5)*4, (j-0.5)*4, (k-0.5)*4)
                                        local key = getGridKey(exactPos.X, exactPos.Y, exactPos.Z)
                                        
                                        if not gridData[matName] then gridData[matName] = {} end
                                        if not gridData[matName][key] then
                                            gridData[matName][key] = {
                                                count = 1,
                                                sumPos = exactPos
                                            }
                                        else
                                            gridData[matName][key].count = gridData[matName][key].count + 1
                                            gridData[matName][key].sumPos = gridData[matName][key].sumPos + exactPos
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
    
    -- GENTRATE CLEAN BLOCKS DARI GRID DATA
    local blocksDrawn = 0
    for matName, cells in pairs(gridData) do
        local matModel = Instance.new("Model")
        matModel.Name = matName
        matModel.Parent = terrainESPFolder
        
        local rColor = Color3.new(math.random(50,255)/255, math.random(50,255)/255, math.random(50,255)/255)
        if matName == "Amethyst" then rColor = Color3.fromRGB(160, 32, 240)
        elseif matName == "Neon" then rColor = Color3.fromRGB(0, 255, 255)
        elseif matName == "Basalt" then rColor = Color3.fromRGB(50, 50, 50)
        elseif matName == "Limestone" then rColor = Color3.fromRGB(200, 200, 180) end
        
        for key, data in pairs(cells) do
            if data.count >= 2 then -- Abaikan voxel nyasar (noise)
                local centerPos = data.sumPos / data.count
                
                -- Skala ukuran box berdasarkan kepadatan (count)
                local boxSize = math.clamp(data.count * 1.5, 12, 32)
                
                local p = Instance.new("Part")
                p.Size = Vector3.new(boxSize, boxSize, boxSize)
                p.CFrame = CFrame.new(centerPos)
                p.Anchored = true
                p.CanCollide = false
                p.Transparency = 1
                p.Parent = matModel
                
                local box = Instance.new("BoxHandleAdornment")
                box.Size = p.Size
                box.Adornee = p
                box.Color3 = rColor
                box.Transparency = 0.5
                box.ZIndex = 5
                box.AlwaysOnTop = true
                box.Parent = p
                
                blocksDrawn = blocksDrawn + 1
                
                if not matModel.PrimaryPart then
                    matModel.PrimaryPart = p
                    local bg = Instance.new("BillboardGui")
                    bg.Size = UDim2.new(0, 100, 0, 40)
                    bg.AlwaysOnTop = true
                    bg.StudsOffset = Vector3.new(0, boxSize/2 + 5, 0)
                    local tl = Instance.new("TextLabel")
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.BackgroundTransparency = 1
                    tl.Text = matName
                    tl.TextColor3 = rColor
                    tl.TextStrokeTransparency = 0
                    tl.TextScaled = true
                    tl.Parent = bg
                    bg.Parent = p
                end
            end
        end
    end
    
    if TerrainProgress then
        pcall(function() TerrainProgress:Set({ Title = "Scan Progress", Content = "Scan Complete! Drawing " .. blocksDrawn .. " clear areas." }) end)
    end
end

-- Auto Mine Function

local fireCooldowns = {}

local function getClosestCrystal()
    local crystalsFolder = getCrystalsFolder()
    if not crystalsFolder then return nil end

    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = character.HumanoidRootPart

    local closest = nil
    local minDistance = math.huge

    for _, crystal in ipairs(crystalsFolder:GetChildren()) do
        local part = crystal:IsA("Model") and crystal.PrimaryPart or crystal
        if part and part:IsA("BasePart") then
            -- Filter Rarity (TierName)
            local tName = crystal:GetAttribute("TierName") or "Crystal"
            local allowedRarity = true
            if config.SelectedRarities and #config.SelectedRarities > 0 then
                allowedRarity = false
                for _, r in ipairs(config.SelectedRarities) do
                    if r == "All" or r == tName then
                        allowedRarity = true
                        break
                    end
                end
            end
            
            -- Filter Size (SizeClass)
            local sClass = crystal:GetAttribute("SizeClass") or "S"
            local allowedSize = true
            if config.SelectedSizes and #config.SelectedSizes > 0 then
                allowedSize = false
                for _, s in ipairs(config.SelectedSizes) do
                    if s == "All" or s == sClass then
                        allowedSize = true
                        break
                    end
                end
            end
            
            local allowed = allowedRarity and allowedSize
            
            if allowed and crystal:GetAttribute("Collected") ~= true then
                -- Temukan Proximity Prompt secara rekursif
                local prompt = crystal:FindFirstChildWhichIsA("ProximityPrompt", true)
                
                -- Pastikan prompt ada, aktif, ClickablePrompt true, dan belum dipicu dalam 5 detik terakhir
                if prompt and prompt.Enabled and prompt.ClickablePrompt then
                    local lastFired = fireCooldowns[crystal] or 0
                    if tick() - lastFired > 5 then
                        local dist = (hrp.Position - part.Position).Magnitude
                        if dist < minDistance then
                            minDistance = dist
                            closest = crystal
                        end
                    end
                end
            end
        end
    end

    return closest
end

task.spawn(function()
    while getgenv()._NapoMinMounRunning and task.wait(0.1) do
        if config.AutoMine and not getgenv()._NapoIsSelling and not getgenv()._NapoIsCollectingDrop then
            local target = getClosestCrystal()
            local character = LocalPlayer.Character
            if target and character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart
                
                -- Auto-Equip Tool (agar bot tidak stuck di base setelah mati)
                local tool = character:FindFirstChildOfClass("Tool")
                if not tool then
                    local backpack = LocalPlayer:FindFirstChild("Backpack")
                    if backpack then
                        local foundTool = backpack:FindFirstChildOfClass("Tool")
                        if foundTool then
                            character.Humanoid:EquipTool(foundTool)
                            task.wait(0.5)
                            tool = foundTool
                        end
                    end
                end
                
                if not tool then continue end
                
                local part = target:IsA("Model") and target.PrimaryPart or target
                if part and part:IsA("BasePart") then
                    getgenv()._NapoIsMiningCrystal = true
                    
                    -- Hentikan pergerakan sebelumnya
                    hrp.Velocity = Vector3.zero
                    
                    -- Gunakan BodyVelocity agar karakter tidak jatuh/merosot selama proses menambang
                    local antiGrav = hrp:FindFirstChild("AntiGravTween")
                    if not antiGrav then
                        antiGrav = Instance.new("BodyVelocity")
                        antiGrav.Name = "AntiGravTween"
                        antiGrav.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                        antiGrav.Velocity = Vector3.zero
                        antiGrav.Parent = hrp
                    end
                    
                    -- Teleport bertahap untuk membypass Anti-Cheat Rollback (Simulasi pergerakan super cepat)
                    local targetCFrame = part.CFrame + Vector3.new(0, 4, 0)
                    local dist = (hrp.Position - targetCFrame.Position).Magnitude
                    if dist > 15 then
                        local steps = math.ceil(dist / 15) -- Maksimal 15 studs per lompatan
                        for i = 1, steps do
                            if getgenv()._NapoIsSelling then break end
                            hrp.CFrame = hrp.CFrame:Lerp(targetCFrame, i / steps)
                            task.wait(0.03) -- Jeda sangat singkat agar server sempat mencatat jalur
                        end
                    else
                        hrp.CFrame = targetCFrame
                    end
                    task.wait(0.1) -- Jeda konfirmasi server sebelum mulai menambang
                    
                    local miningTargets = {target}
                    local mainPrompt = target:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if mainPrompt then
                        mainPrompt.HoldDuration = 0
                    end
                    
                    -- Tunggu dan SPAM fire prompt sampai SEMUA crystal di sekitar berhasil ditambang (Batas tunggu 15 detik)
                    local startWait = tick()
                    while config.AutoMine and tick() - startWait < 15 and not getgenv()._NapoIsSelling do
                        local stillExists = false
                        for _, c in ipairs(miningTargets) do
                            -- Beri penanda cooldown agar jika gagal/bug, tidak diulang-ulang tanpa henti (stuck)
                            fireCooldowns[c] = tick()
                            
                            local pr = c:FindFirstChildWhichIsA("ProximityPrompt", true)
                            -- SANGAT PENTING: JANGAN cek `pr.Enabled` di sini!
                            -- Karena saat mulai nambang, server otomatis bikin Enabled = false (agar player lain ga bisa klik).
                            -- Kalau kita cek pr.Enabled, script mengira crystal sudah habis dan langsung pindah sebelum progress selesai!
                            if c.Parent and c:GetAttribute("Collected") ~= true then
                                stillExists = true
                                if pr then
                                    pr.HoldDuration = 0
                                    if fireproximityprompt then
                                        fireproximityprompt(pr)
                                    end
                                end
                            end
                        end
                        
                        if not stillExists then 
                            break 
                        end
                        
                        -- Hancurkan daratan (terrain) di sekitar crystal jika crystal tertimbun
                        -- Agar bisa diklik / ProximityPrompt tidak terhalang Line of Sight
                        local tool = character:FindFirstChildOfClass("Tool")
                        if tool then
                            for _, c in ipairs(miningTargets) do
                                if c.Parent then
                                    local p = c:IsA("Model") and c.PrimaryPart or c
                                    if p and p:IsA("BasePart") then
                                        -- CATCH-UP SYSTEM (Anti-Pusing)
                                        -- Jangan terus-menerus menempel (karena bikin kamera goyang),
                                        -- TAPI jika crystalnya menggelinding menjauh lebih dari 5 studs,
                                        -- barulah kita lompat mengejarnya agar tidak batal di-mine!
                                        if (hrp.Position - p.Position).Magnitude > 5 then
                                            hrp.CFrame = p.CFrame + Vector3.new(0, 4, 0)
                                        end
                                    end
                                end
                            end
                        end
                        
                        task.wait(0.05) -- Loop sangat cepat agar responsif
                    end
                    
                    -- Hapus penahan gravitasi setelah kluster ini selesai
                    if antiGrav then
                        antiGrav:Destroy()
                    end
                    
                    getgenv()._NapoIsMiningCrystal = false
                end
            end
        end
    end
end)

-- Auto Collect Drops Function
task.spawn(function()
    while getgenv()._NapoMinMounRunning and task.wait(0.1) do
        if config.AutoCollectDrop and not getgenv()._NapoIsSelling and not getgenv()._NapoIsMiningCrystal then
            local droppedFolder = workspace:FindFirstChild("DroppedCrystals")
            if not droppedFolder then continue end
            
            local character = LocalPlayer.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then continue end
            local hrp = character.HumanoidRootPart
            
            local closest = nil
            local minDistance = math.huge
            
            for _, drop in ipairs(droppedFolder:GetChildren()) do
                local prompt = drop:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt and prompt.Enabled then
                    local part = drop:IsA("Model") and drop.PrimaryPart or (drop:IsA("BasePart") and drop or drop:FindFirstChildWhichIsA("BasePart", true))
                    if part then
                        local dist = (hrp.Position - part.Position).Magnitude
                        if dist < minDistance then
                            minDistance = dist
                            closest = drop
                        end
                    end
                end
            end
            
            if closest then
                local prompt = closest:FindFirstChildWhichIsA("ProximityPrompt", true)
                local part = closest:IsA("Model") and closest.PrimaryPart or (closest:IsA("BasePart") and closest or closest:FindFirstChildWhichIsA("BasePart", true))
                if prompt and part then
                    getgenv()._NapoIsCollectingDrop = true
                    hrp.Velocity = Vector3.zero
                    
                    local antiGrav = hrp:FindFirstChild("AntiGravTween")
                    if not antiGrav then
                        antiGrav = Instance.new("BodyVelocity")
                        antiGrav.Name = "AntiGravTween"
                        antiGrav.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                        antiGrav.Velocity = Vector3.zero
                        antiGrav.Parent = hrp
                    end
                    
                    local targetCFrame = part.CFrame + Vector3.new(0, 4, 0)
                    local dist = (hrp.Position - targetCFrame.Position).Magnitude
                    if dist > 15 then
                        local steps = math.ceil(dist / 15)
                        for i = 1, steps do
                            if getgenv()._NapoIsSelling or getgenv()._NapoIsMiningCrystal then break end
                            hrp.CFrame = hrp.CFrame:Lerp(targetCFrame, i / steps)
                            task.wait(0.03)
                        end
                    else
                        hrp.CFrame = targetCFrame
                    end
                    task.wait(0.1)
                    
                    if prompt and prompt.Parent and prompt.Enabled then
                        prompt.HoldDuration = 0
                        if fireproximityprompt then
                            fireproximityprompt(prompt)
                        end
                    end
                    
                    if antiGrav then antiGrav:Destroy() end
                    getgenv()._NapoIsCollectingDrop = false
                end
            end
        end
    end
end)

-- Instant Proximity Function

task.spawn(function()
    while getgenv()._NapoMinMounRunning and task.wait(1) do
        if config.InstantProximity then
            for _, prompt in ipairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    if not prompt:GetAttribute("OriginalDuration") then
                        prompt:SetAttribute("OriginalDuration", prompt.HoldDuration)
                    end
                    prompt.HoldDuration = 0
                end
            end
        else
            for _, prompt in ipairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt:GetAttribute("OriginalDuration") then
                    prompt.HoldDuration = prompt:GetAttribute("OriginalDuration")
                    prompt:SetAttribute("OriginalDuration", nil)
                end
            end
        end
    end
end)

-- God Mode Function

-- Heal Loop for terrain/part damage
local hbConn
hbConn = RunService.Heartbeat:Connect(function()
    if not getgenv()._NapoMinMounRunning then hbConn:Disconnect() return end
    if config.GodMode then
        pcall(function()
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 and humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end
        end)
    end
end)

-- Remote blocker for server-sided damage requests
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    
    if config.GodMode and method == "FireServer" then
        local name = tostring(self)
        if name:find("Damage") or name == "FallDamage" or name == "FreezeDamage" then
            return -- Bypass damage request
        end
    end
    
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- Attributes and Environmental Hazard Blocker for God Mode
task.spawn(function()
    while getgenv()._NapoMinMounRunning and task.wait(1) do
        if config.GodMode then
            pcall(function()
                -- 1. Spoof Fall Damage attributes
                LocalPlayer:SetAttribute("NoFallDamage", true)
                LocalPlayer:SetAttribute("JetpackNoFallDamage", true)
                
                -- 2. Ganti material Lava (CrackedLava) menjadi Limestone di Terrain lokal agar FloorMaterial client tidak mendeteksi Lava
                local terrain = workspace.Terrain
                if terrain then
                    terrain:ReplaceMaterial(Region3.new(Vector3.new(-50000, -50000, -50000), Vector3.new(50000, 50000, 50000)), 4, Enum.Material.CrackedLava, Enum.Material.Limestone)
                end
                
                -- 3. Matikan CanTouch untuk part yang berpotensi sebagai hazard/killbrick
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") then
                        local name = v.Name:lower()
                        if name:find("lava") or name:find("kill") or name:find("damage") or name:find("hazard") then
                            v.CanTouch = false
                        end
                    end
                end
            end)
        end
    end
end)

-- Terrain Nuke Aura Function

task.spawn(function()
    local offsets = {}
    local radius = 16
    local step = 4
    for x = -radius, radius, step do
        for y = -12, 12, step do
            for z = -radius, radius, step do
                table.insert(offsets, Vector3.new(x, y, z))
            end
        end
    end
    
    local index = 1
    
    while getgenv()._NapoMinMounRunning and task.wait() do
        if config.TerrainNukeAura then
            pcall(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local hrp = character.HumanoidRootPart
                    local tool = character:FindFirstChildOfClass("Tool")
                    
                    if tool then
                        -- Fire 10 positions per tick to clear very fast
                        for i = 1, 10 do
                            local targetPos = hrp.Position + offsets[index]
                            DigRequest:FireServer(tool.Name, targetPos)
                            
                            index = index + 1
                            if index > #offsets then
                                index = 1
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Clear Mountain & Area (Fully Automated Bot)

-- Visualizer Part function
local visualizerPart = nil
local selBox = nil
config.updateVisualizer = function(forceShow)
    if forceShow or config.AutoClearArea then
        if not visualizerPart then
            visualizerPart = Instance.new("Part")
            visualizerPart.Name = "ClearAreaVisualizer"
            visualizerPart.Transparency = 1 -- Part tidak terlihat
            visualizerPart.Anchored = true
            visualizerPart.CanCollide = false
            visualizerPart.Parent = workspace
            
            selBox = Instance.new("SelectionBox")
            selBox.Name = "AreaSelBox"
            selBox.Adornee = visualizerPart
            selBox.Color3 = Color3.new(1, 0, 0)
            selBox.LineThickness = 0.05
            selBox.SurfaceColor3 = Color3.new(1, 0, 0)
            selBox.SurfaceTransparency = 0.85
            selBox.Parent = visualizerPart
        end
        local cx = config.ClearAreaCenter.X
        local cz = config.ClearAreaCenter.Z
        local r = config.ClearAreaRadius or 50
        local peak = config.ClearAreaCenter.Y + (config.ClearAreaUp or 200)
        local base = config.ClearAreaCenter.Y - (config.ClearAreaDown or 500)
        local height = math.abs(peak - base)
        local midY = (peak + base) / 2
        visualizerPart.Size = Vector3.new(r*2, height, r*2) -- Berbentuk Kotak
        visualizerPart.CFrame = CFrame.new(cx, midY, cz)
    else
        if visualizerPart then
            visualizerPart:Destroy()
            visualizerPart = nil
            selBox = nil
        end
    end
end

-- 1. Loop Pergerakan (Pemetaan Gunung & Tween)
local NoclipConnection = nil

task.spawn(function()
    local TweenService = game:GetService("TweenService")
    
    while getgenv()._NapoMinMounRunning and task.wait(1) do
        local isMountainMode = config.AutoBotMountain
        local isAreaMode = config.AutoClearArea
        
        if isMountainMode or isAreaMode then
            pcall(function()
                local character = LocalPlayer.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                local hrp = character.HumanoidRootPart
                
                -- Auto-Equip Tool (Atasi masalah diam di base setelah mati)
                local tool = character:FindFirstChildOfClass("Tool")
                if not tool then
                    local backpack = LocalPlayer:FindFirstChild("Backpack")
                    if backpack then
                        local foundTool = backpack:FindFirstChildOfClass("Tool")
                        if foundTool then
                            character.Humanoid:EquipTool(foundTool)
                            tool = foundTool
                            task.wait(0.5)
                        end
                    end
                end
                
                if not tool then return end
                
                local cx, cz, peakY, baseY, maxRadius
                
                if isMountainMode then
                    cx = workspace:GetAttribute("MountainCenterX") or 0
                    cz = workspace:GetAttribute("MountainCenterZ") or 0
                    peakY = (workspace:GetAttribute("MountainActualPeakY") or workspace:GetAttribute("MountainPeakY") or 2800) + 200
                    baseY = workspace:GetAttribute("MountainBaseY") or 0
                    maxRadius = (workspace:GetAttribute("MountainRadius") or 120)
                else
                    cx = config.ClearAreaCenter.X
                    cz = config.ClearAreaCenter.Z
                    peakY = config.ClearAreaCenter.Y + (config.ClearAreaUp or 200)
                    baseY = config.ClearAreaCenter.Y - (config.ClearAreaDown or 500)
                    maxRadius = config.ClearAreaRadius or 50
                end
                
                -- Noclip karakter agar tidak menabrak/nyangkut di dinding daratan yang belum digali
                if not NoclipConnection then
                    NoclipConnection = RunService.Stepped:Connect(function()
                        if (config.AutoBotMountain or config.AutoClearArea) then
                            local currentCharacter = LocalPlayer.Character
                            if currentCharacter then
                                for _, v in ipairs(currentCharacter:GetDescendants()) do
                                    if v:IsA("BasePart") then
                                        v.CanCollide = false
                                    end
                                end
                            end
                        end
                    end)
                end
                
                -- Gunakan BodyVelocity agar bisa melayang
                local bv = hrp:FindFirstChild("NukeBV")
                if not bv then
                    bv = Instance.new("BodyVelocity")
                    bv.Name = "NukeBV"
                    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                    bv.Velocity = Vector3.new(0, 0, 0)
                    bv.Parent = hrp
                end
                
                if not getgenv()._NapoNotifyHooked then
                    getgenv()._NapoNotifyHooked = true
                    getgenv()._NapoIgnoredAreas = {}
                    
                    local Remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                    if Remotes then
                        local function hookNotify(remote)
                            if remote then
                                local conn = remote:IsA("RemoteEvent") and remote.OnClientEvent or remote.Event
                                conn:Connect(function(a, b)
                                    local msg = typeof(b) == "string" and b or (typeof(a) == "string" and a)
                                    if msg and msg:find("You need a") and msg:find("to break") then
                                        if getgenv()._NapoCurrentClearTarget then
                                            table.insert(getgenv()._NapoIgnoredAreas, getgenv()._NapoCurrentClearTarget)
                                            getgenv()._NapoCurrentClearTarget = nil
                                        end
                                    end
                                end)
                            end
                        end
                        hookNotify(Remotes:FindFirstChild("Notify"))
                        hookNotify(Remotes:FindFirstChild("NotifyLocal"))
                    end
                end
                
                local mineCounter = 0
                local ignoredAreas = getgenv()._NapoIgnoredAreas
                
                -- Loop Dinamis: Cari titik terbaik secara real-time
                while config.AutoBotMountain or config.AutoClearArea do
                    if getgenv()._NapoIsMiningCrystal or getgenv()._NapoIsSelling then
                        task.wait(0.5)
                        continue
                    end
                    
                    mineCounter = mineCounter + 1
                    
                    local bestPoint = nil
                    local bestScore = -math.huge
                    
                    local rayParams = RaycastParams.new()
                    rayParams.FilterType = Enum.RaycastFilterType.Include
                    rayParams.FilterDescendantsInstances = {workspace.Terrain}
                    
                    local density = isMountainMode and config.MountainDensity or config.AreaDensity
                    
                    -- ATURAN SCAN: Full Scan setiap 10 langkah, sisanya Local Scan
                    local isFullScan = (mineCounter % 10 == 1)
                    local scanRadius = isFullScan and maxRadius or (20 * density)
                    local scanCX = isFullScan and cx or hrp.Position.X
                    local scanCZ = isFullScan and cz or hrp.Position.Z
                    
                    local rayCount = 0 -- Penghitung raycast untuk Anti-Lag
                    
                    -- Helper: Menemukan Y terdalam di dalam Box, atau mendeteksi atap padat
                    local function getHitY(tx, tz, peak, base)
                        -- Cek apakah titik ini di-ignore karena indestructible (seperti Gunpowder Stone dll)
                        for _, ig in ipairs(ignoredAreas) do
                            if math.abs(ig.X - tx) < 5 and math.abs(ig.Z - tz) < 5 then
                                return nil -- Skip area ini
                            end
                        end
                        
                        local origin = Vector3.new(tx, peak, tz)
                        local dir = Vector3.new(0, - (peak - base), 0)
                        local hit = workspace:Raycast(origin, dir, rayParams)
                        
                        if hit then
                            return hit.Position.Y
                        else
                            -- Jika nil, cek apakah titik peak tersebut sebenarnya berada di DALAM batu padat (atap)
                            local r3 = Region3.new(Vector3.new(tx-2, peak-2, tz-2), Vector3.new(tx+2, peak+2, tz+2)):ExpandToGrid(4)
                            local success, _, occs = pcall(function() return workspace.Terrain:ReadVoxels(r3, 4) end)
                            if success and occs then
                                local sz = occs.Size
                                for i = 1, sz.X do
                                    for j = 1, sz.Y do
                                        for k = 1, sz.Z do
                                            if occs[i][j][k] > 0.1 then 
                                                return peak 
                                            end
                                        end
                                    end
                                end
                            end
                            return nil
                        end
                    end
                    
                    -- FASE 1: COARSE SCAN
                    local coarseStep = isMountainMode and 20 or density
                    local bestCoarseX, bestCoarseZ = nil, nil
                    local bestCoarseScore = -math.huge
                    
                    for x = -scanRadius, scanRadius, coarseStep do
                        for z = -scanRadius, scanRadius, coarseStep do
                            if x*x + z*z <= scanRadius*scanRadius then
                                local targetX = scanCX + x
                                local targetZ = scanCZ + z
                                
                                local dx = targetX - cx
                                local dz = targetZ - cz
                                
                                -- Tentukan batas berdasarkan mode (Lingkaran vs Kotak)
                                local inBounds = false
                                if isMountainMode then
                                    inBounds = (dx*dx + dz*dz <= maxRadius*maxRadius)
                                else
                                    inBounds = (math.abs(dx) <= maxRadius and math.abs(dz) <= maxRadius)
                                end
                                
                                if inBounds then
                                    rayCount = rayCount + 1
                                    if rayCount % 50 == 0 then task.wait() end -- Anti-Lag: Jeda setiap 50 raycast
                                    
                                    local hitY = getHitY(targetX, targetZ, peakY, baseY)
                                    if hitY then
                                        local targetHitPos = Vector3.new(targetX, hitY, targetZ)
                                        local currentDist = (targetHitPos - hrp.Position).Magnitude
                                        local score = (hitY * 1.5) - currentDist
                                        
                                        if score > bestCoarseScore then
                                            bestCoarseScore = score
                                            bestCoarseX = targetX
                                            bestCoarseZ = targetZ
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    -- FASE 2: FINE SCAN (Berdasarkan Kepadatan)
                    if bestCoarseX and bestCoarseZ then
                        local fineStep = density
                        for fx = bestCoarseX - coarseStep, bestCoarseX + coarseStep, fineStep do
                            for fz = bestCoarseZ - coarseStep, bestCoarseZ + coarseStep, fineStep do
                                local dx = fx - cx
                                local dz = fz - cz
                                
                                local inBounds = false
                                if isMountainMode then
                                    inBounds = (dx*dx + dz*dz <= maxRadius*maxRadius)
                                else
                                    inBounds = (math.abs(dx) <= maxRadius and math.abs(dz) <= maxRadius)
                                end
                                
                                if inBounds then
                                    rayCount = rayCount + 1
                                    if rayCount % 50 == 0 then task.wait() end -- Anti-Lag
                                    
                                    local hitY = getHitY(fx, fz, peakY, baseY)
                                    if hitY then
                                        local targetHitPos = Vector3.new(fx, hitY, fz)
                                        local currentDist = (targetHitPos - hrp.Position).Magnitude
                                        local score = (hitY * 1.5) - currentDist
                                        
                                        if score > bestScore then
                                            bestScore = score
                                            bestPoint = targetHitPos
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    -- Eksekusi langsung ke titik terbaik tersebut
                    if bestPoint then
                        -- Update target saat ini agar jika muncul notifikasi, target ini yang diblacklist
                        getgenv()._NapoCurrentClearTarget = {X = bestPoint.X, Z = bestPoint.Z}
                        
                        -- Tambahkan offset Y agar karakter berada di ATAS daratan, bukan terkubur
                        local targetPos = bestPoint + Vector3.new(0, 3.5, 0)
                        
                        -- CFrame lookAt
                        local flatDir = Vector3.new(targetPos.X - hrp.Position.X, 0, targetPos.Z - hrp.Position.Z)
                        local targetCFrame
                        if flatDir.Magnitude > 0.1 then
                            targetCFrame = CFrame.lookAt(targetPos, targetPos + flatDir)
                        else
                            targetCFrame = CFrame.new(targetPos)
                        end
                        
                        local dist = (hrp.Position - targetPos).Magnitude
                        if dist > 2 then
                            local humanoid = character:FindFirstChildOfClass("Humanoid")
                            local speed = math.max(humanoid and humanoid.WalkSpeed or 16, 1)
                            
                            local tweenInfo = TweenInfo.new(dist / speed, Enum.EasingStyle.Linear)
                            local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
                            tween:Play()
                            
                            -- Custom wait loop agar instan bisa dibatalkan
                            while tween.PlaybackState == Enum.PlaybackState.Playing do
                                if not (config.AutoBotMountain or config.AutoClearArea) or getgenv()._NapoIsMiningCrystal or getgenv()._NapoIsSelling then
                                    tween:Cancel()
                                    break
                                end
                                task.wait()
                            end
                        else
                            hrp.CFrame = targetCFrame
                        end
                        
                        -- Tunggu sejenak agar aura menghancurkan daratan di titik ini
                        task.wait(0.2)
                    else
                        if not isFullScan then
                            -- Jika local scan habis, paksa Full Scan di putaran berikutnya
                            mineCounter = 0
                            task.wait()
                        else
                            -- Jika tidak ada daratan sama sekali dari Full Scan, gunung/area sudah rata
                            notif("Area/Mountain has been completely cleared!", 5, "Success")
                            local wasArea = config.AutoClearArea
                                                                                    if wasArea and config.updateVisualizer then config.updateVisualizer(true) end
                            break
                        end
                    end
                    
                    -- Cek validitas karakter agar loop berhenti jika player mati
                    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or not LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                        break
                    end
                end
                
            end)
        else
            if NoclipConnection then
                NoclipConnection:Disconnect()
                NoclipConnection = nil
            end
            pcall(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local bv = character.HumanoidRootPart:FindFirstChild("NukeBV")
                    if bv then bv:Destroy() end
                end
            end)
        end
    end
end)

-- 2. Loop Penghancuran Terrain (Digging Aura)
task.spawn(function()
    while getgenv()._NapoMinMounRunning and task.wait(0.05) do
        -- MATIKAN TOTAL saat sedang fokus menambang crystal (agar tidak menghancurkan pijakan crystal / error bomb)
        if getgenv()._NapoIsMiningCrystal then continue end
        
        if config.AutoBotMountain or config.AutoClearArea then
            pcall(function()
                local character = LocalPlayer.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                local hrp = character.HumanoidRootPart
                local tool = character:FindFirstChildOfClass("Tool")
                
                if tool then
                    -- Gali ke arah BAWAH player (karena posisi terbang player berada di atas permukaan daratan)
                    DigRequest:FireServer(tool.Name, hrp.Position + Vector3.new(0, -4, 0))  -- Permukaan persis di bawah kaki
                    DigRequest:FireServer(tool.Name, hrp.Position + Vector3.new(0, -8, 0))  -- Agak dalam
                    DigRequest:FireServer(tool.Name, hrp.Position + Vector3.new(0, -12, 0)) -- Lebih dalam lagi agar sekali lewat langsung berlubang besar
                end
            end)
        end
    end
end)



-- 3. Loop Auto Sell
task.spawn(function()
    local lastSell = tick()
    local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
    
    -- Listener Backpack Full
    local BackpackFull = Remotes:FindFirstChild("BackpackFull")
    if BackpackFull then
        BackpackFull.OnClientEvent:Connect(function()
            if config.AutoSell and config.AutoSellTrigger == "Backpack Full" then
                getgenv()._NapoForceSell = true
            end
        end)
    end
    
    while getgenv()._NapoMinMounRunning and task.wait(1) do
        if not config.AutoSell then continue end
        
        local shouldSell = false
        if config.AutoSellTrigger == "Delay" then
            if tick() - lastSell >= (config.AutoSellDelay or 300) then
                shouldSell = true
            end
        elseif config.AutoSellTrigger == "Backpack Full" then
            if getgenv()._NapoForceSell then
                shouldSell = true
            end
        end
        
        if shouldSell then
            getgenv()._NapoForceSell = false
            lastSell = tick()
            
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart
                
                -- Kunci fitur lain
                getgenv()._NapoIsSelling = true
                
                local initialCFrame = hrp.CFrame
                
                -- Teleport via Game Remote
                local GoHome = Remotes:FindFirstChild("GoHome")
                if GoHome then
                    GoHome:FireServer("sell")
                end
                
                task.wait(1) -- Tunggu server memindahkan karakter
                
                -- Eksekusi Jual
                local SellRequest = Remotes:FindFirstChild("SellRequest")
                if SellRequest then
                    SellRequest:FireServer("all")
                end
                task.wait(0.5)
                
                -- Tween cepat kembali ke lokasi awal (karena game tidak menyediakan fitur kembali)
                local dist = (hrp.Position - initialCFrame.Position).Magnitude
                    if dist > 15 then
                        local steps = math.ceil(dist / 15)
                        for i = 1, steps do
                            hrp.CFrame = hrp.CFrame:Lerp(initialCFrame, i / steps)
                            task.wait(0.03)
                        end
                    else
                        hrp.CFrame = initialCFrame
                    end
                
                getgenv()._NapoIsSelling = false
            end
        end
    end
end)



-- 4. Auto Respawn Listener
task.spawn(function()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
    
    -- Listener langsung ke RemoteEvent
    local ReviveShow = Remotes:FindFirstChild("ReviveShow")
    if ReviveShow then
        ReviveShow.OnClientEvent:Connect(function()
            if config.AutoRespawn then
                local ReviveBase = Remotes:FindFirstChild("ReviveBase")
                if ReviveBase then
                    ReviveBase:FireServer()
                end
            end
        end)
    end
    
    -- Listener ke UI untuk mencegah kedipan / Pop-up yang mengganggu
    local function hookRevive(gui)
        if gui.Name == "Revive" then
            local Frame = gui:WaitForChild("Frame", 5)
            if Frame then
                Frame:GetPropertyChangedSignal("Visible"):Connect(function()
                    if config.AutoRespawn and Frame.Visible then
                        Frame.Visible = false
                        local ReviveBase = Remotes:FindFirstChild("ReviveBase")
                        if ReviveBase then
                            ReviveBase:FireServer()
                        end
                    end
                end)
                
                if config.AutoRespawn and Frame.Visible then
                    Frame.Visible = false
                    local ReviveBase = Remotes:FindFirstChild("ReviveBase")
                    if ReviveBase then
                        ReviveBase:FireServer()
                    end
                end
            end
        end
    end
    
    for _, gui in ipairs(PlayerGui:GetChildren()) do
        hookRevive(gui)
    end
    
    PlayerGui.ChildAdded:Connect(hookRevive)
end)



-- 5. Anti-AFK Listener
task.spawn(function()
    -- Disable existing Idled connections if possible
    pcall(function()
        if getconnections then
            for _, connection in pairs(getconnections(LocalPlayer.Idled)) do
                if type(connection) == "table" and connection.Disable then
                    connection:Disable()
                end
            end
        end
    end)
    
    LocalPlayer.Idled:Connect(function()
        if config.AntiAFK then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
    end)
    
    while getgenv()._NapoMinMounRunning and task.wait(5) do
        if config.AntiAFK then
            pcall(function()
                LocalPlayer:SetAttribute("AntiAfkIdleOverride", 9e9)
            end)
        end
    end
end)

-- 6. Anti Fall, Rock Damage & God Mode Loop
task.spawn(function()
    while getgenv()._NapoMinMounRunning and task.wait(0.5) do
        if config.AntiFallRock or config.GodMode then
            pcall(function()
                LocalPlayer:SetAttribute("NoFallDamage", true)
                LocalPlayer:SetAttribute("JetpackNoFallDamage", true)
                
                local character = LocalPlayer.Character
                if config.AntiFallRock and character and character:FindFirstChild("Head") then
                    local head = character.Head
                    
                    -- Deteksi batu jatuh (Anti Ketiban Batu)
                    local ray = Ray.new(head.Position, Vector3.new(0, 100, 0))
                    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {character})
                    
                    if hit and hit.Name:lower():find("rock") and not hit.Anchored then
                        hit:Destroy()
                    end
                end
            end)
        end
    end
end)



-- ============================================================
-- 2. TABS & SECTIONS
-- ============================================================

local InfoTab = Tabs:AddTab({ Name = "Info", Icon = "info" })
local MainTab = Tabs:AddTab({ Name = "Main", Icon = "rod" })
local VisualTab = Tabs:AddTab({ Name = "Visual", Icon = "eye" })
local MiscTab = Tabs:AddTab({ Name = "Misc", Icon = "box" })

-- TAB INFO
local InfoSection = InfoTab:AddSection("Napoleon — Mine Mountain", true)
InfoSection:AddParagraph({
    Title = "⛏️ Script Info",
    Content = "Auto Mine: Automatically finds and mines crystals around you.\nCrystal ESP: Displays locations and names of crystals from afar."
})
InfoSection:AddButton({
    Title = "Join Discord",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/napoleonsc")
            notif("Discord link copied to clipboard!", 3, "Napoleon")
        end
    end
})

-- TAB MAIN
local MineSection = MainTab:AddSection("Mining Features")
MineSection:AddToggle({
    Title = "Auto Mine",
    Content = "Automatically approach and mine the nearest crystal",
    Default = false,
    Callback = function(Value)
        config.AutoMine = Value
    end
})

MineSection:AddToggle({
    Title = "Auto Collect Drops",
    Content = "Automatically approach and collect dropped crystals",
    Default = false,
    Callback = function(Value)
        config.AutoCollectDrop = Value
    end
})

local SizeDropdown = MineSection:AddDropdown({
    Title = "Select Target Size",
    Content = "Select which crystal sizes to target. If empty = mines all.",
    Default = {"All"},
    Options = {"All", "S", "M", "L", "XL", "Giant", "Colossal", "Titan", "Leviathan", "Behemoth"},
    Multi = true,
    Callback = function(Value)
        config.SelectedSizes = Value
    end    
})

local RarityDropdown = MineSection:AddDropdown({
    Title = "Select Target Rarity",
    Content = "Select which crystal rarities to target. If empty = mines all.",
    Default = {"All"},
    Options = {"All", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic"},
    Multi = true,
    Callback = function(Value)
        config.SelectedRarities = Value
    end    
})

local SellSection = MainTab:AddSection("Auto Sell")
SellSection:AddToggle({
    Title = "Auto Sell",
    Content = "Automatically sell crystals to NPC instantly",
    Default = false,
    Callback = function(Value)
        config.AutoSell = Value
    end
})

SellSection:AddDropdown({
    Title = "Auto Sell Trigger",
    Content = "Select the condition for auto-selling",
    Default = "Backpack Full",
    Options = {"Backpack Full", "Delay"},
    Multi = false,
    Callback = function(Value)
        config.AutoSellTrigger = Value
    end
})

SellSection:AddInput({
    Title = "Sell Delay (Seconds)",
    Content = "Delay time if using the Delay trigger",
    Default = "300",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        config.AutoSellDelay = tonumber(Value) or 300
    end
})

local BotSection = MainTab:AddSection("Auto Clear Mountain Bot")
BotSection:AddToggle({
    Title = "Enable Auto Clear Mountain",
    Content = "Smart bot navigates and flattens the mountain.",
    Default = false,
    Callback = function(Value)
        config.AutoBotMountain = Value
    end
})

BotSection:AddInput({
    Title = "Raycast Density",
    Content = "Distance between raycasts (studs). Lower = more accurate but heavier. (Default: 5)",
    Default = "5",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 then
            config.MountainDensity = num
        end
    end
})

local AreaSection = MainTab:AddSection("Auto Clear Custom Area")
AreaSection:AddButton({
    Title = "Set Center to Current Position",
    Content = "Sets your current standing location as the destruction center.",
    Callback = function()
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos = char.HumanoidRootPart.Position
                config.ClearAreaCenter = pos
                notif("Center point set to: " .. math.floor(pos.X) .. ", " .. math.floor(pos.Y) .. ", " .. math.floor(pos.Z), 3, "Area")
                if config.updateVisualizer then config.updateVisualizer(true) end
            end
        end)
    end
})

AreaSection:AddInput({
    Title = "Scan Up Offset (Studs)",
    Content = "Max scan height limit from the center.",
    Default = "200",
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            config.ClearAreaUp = num
            if config.updateVisualizer then config.updateVisualizer(true) end
        end
    end
})

AreaSection:AddInput({
    Title = "Scan Down Offset (Studs)",
    Content = "Max scan depth limit from the center.",
    Default = "500",
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            config.ClearAreaDown = num
            if config.updateVisualizer then config.updateVisualizer(true) end
        end
    end
})

AreaSection:AddInput({
    Title = "Area Radius (Studs)",
    Content = "Half-length of the destruction square side (Default: 50)",
    Default = "50",
    Callback = function(Value)
        local r = tonumber(Value)
        if r and r > 0 then
            config.ClearAreaRadius = r
            if config.updateVisualizer then config.updateVisualizer(true) end
        end
    end
})

AreaSection:AddInput({
    Title = "Area Raycast Density",
    Content = "Distance between raycasts (studs). Lower = more accurate but heavier. (Default: 5)",
    Default = "5",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 then
            config.AreaDensity = num
        end
    end
})

AreaSection:AddToggle({
    Title = "Enable Auto Clear Area",
    Content = "Destroys terrain in a custom defined square area. (Disables Mountain mode)",
    Default = false,
    Callback = function(Value)
        config.AutoClearArea = Value
        if Value then
            config.AutoBotMountain = false
            if config.updateVisualizer then config.updateVisualizer(true) end
        else
            if config.updateVisualizer then config.updateVisualizer(false) end
        end
    end
})

-- TAB VISUAL
local EspSection = VisualTab:AddSection("ESP")
EspSection:AddToggle({
    Title = "Crystal ESP",
    Content = "Displays the locations and colors of crystals",
    Default = false,
    Callback = function(Value)
        config.CrystalESP = Value
        if updateESP then updateESP() end
    end
})

local ESPRarityDropdown = EspSection:AddDropdown({
    Title = "Filter Rarity ESP",
    Content = "Select which crystal rarities to display. If empty = shows all.",
    Default = {"All"},
    Options = {"All", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic"},
    Multi = true,
    Callback = function(Value)
        config.ESPRarities = Value
        if updateESP then updateESP() end
    end
})

local EspTerrainSection = VisualTab:AddSection("ESP Terrain")
TerrainProgress = EspTerrainSection:AddParagraph({
    Title = "Scan Progress",
    Content = "Waiting for scan to start..."
})

EspTerrainSection:AddToggle({
    Title = "Enable ESP Terrain",
    Content = "Finds locations of specific terrain materials inside the mountain.",
    Default = false,
    Callback = function(Value)
        config.ESPTerrain = Value
        if Value then
            task.spawn(startTerrainScan)
        else
            clearTerrainESP()
        end
    end
})

local TerrainMaterialDropdown = EspTerrainSection:AddDropdown({
    Title = "Filter Material Terrain",
    Content = "Select the terrain material to find. (Example: Basalt, Neon, Limestone)",
    Default = {"Limestone"},
    Options = {"All", "Amethyst", "Neon", "DiamondPlate", "Basalt", "CrackedLava", "Glacier", "Ice", "Limestone", "Sandstone", "Granite", "Marble", "Slate", "Cobblestone", "Metal", "CorrodedMetal", "Snow", "Mud", "Rock"},
    Multi = true,
    Callback = function(Value)
        config.ESPTerrainMaterials = Value
    end
})

-- TAB MISC
local AutoSection = MiscTab:AddSection("Features")

AutoSection:AddToggle({
    Title = "Auto Respawn",
    Content = "Automatically respawns when dead and instantly hides the revive popup",
    Default = false,
    Callback = function(Value)
        config.AutoRespawn = Value
    end
})

AutoSection:AddToggle({
    Title = "Anti-AFK",
    Content = "Prevents the character from being kicked out (idle) from the game",
    Default = true,
    Callback = function(Value)
        config.AntiAFK = Value
    end
})

AutoSection:AddToggle({
    Title = "Anti Fall & Rock",
    Content = "Removes fall damage and automatically destroys falling rocks above you",
    Default = false,
    Callback = function(Value)
        config.AntiFallRock = Value
        if not Value then
            pcall(function()
                LocalPlayer:SetAttribute("NoFallDamage", false)
                LocalPlayer:SetAttribute("JetpackNoFallDamage", false)
            end)
        end
    end
})

AutoSection:AddToggle({
    Title = "Instant Proximity",
    Content = "Removes the hold duration when interacting with prompts",
    Default = false,
    Callback = function(Value)
        config.InstantProximity = Value
    end
})

-- Dynamic update options for rarity dropdowns
task.spawn(function()
    local addedOptions = {["Common"]=true, ["Uncommon"]=true, ["Rare"]=true, ["Epic"]=true, ["Legendary"]=true, ["Mythic"]=true}
    while getgenv()._NapoMinMounRunning and task.wait(2) do
        local crystalsFolder = getCrystalsFolder()
        if crystalsFolder then
            for _, crystal in ipairs(crystalsFolder:GetChildren()) do
                local tName = crystal:GetAttribute("TierName")
                if tName and not addedOptions[tName] then
                    addedOptions[tName] = true
                    pcall(function()
                        if RarityDropdown then RarityDropdown:AddOption(tName) end
                        if ESPRarityDropdown then ESPRarityDropdown:AddOption(tName) end
                    end)
                end
            end
        end
    end
end)

-- ============================================================
-- INITIALIZE PESAN SELESAI
-- ============================================================
notif("Napoleon Mine Mountain loaded successfully!", 5, "Success")

 task.spawn(function()
    local hwid = tostring(LocalPlayer.UserId)
    local username = tostring(LocalPlayer.Name)
    local key = getgenv().Key or _G.Key or "Unknown_Key"
    local sUrl = getgenv().ServerURL or _G.ServerURL or "https://napoleonn.net"

    while true do
        local success, err = pcall(function()
            local requestFunc = syn and syn.request or http_request or request or fluxus and fluxus.request
            local url = sUrl .. "/api/heartbeat"
            
            local bodyData = HttpService:JSONEncode({
                key = key,
                userid = hwid,
                username = username,
                inventory = Config.WebSyncInventory and serializeInventory() or {},
                ui_schema = Config.WebControlEnabled and serializeUIState() or {}
            })
            
            local resData = nil
            if requestFunc then
                local res = requestFunc({ 
                    Url = url, 
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = bodyData
                })
                if res and res.Body then resData = res.Body end
            else
                resData = game:HttpPostAsync(url, bodyData, "application/json")
            end
            
            if resData and Config.WebControlEnabled then
                local decoded = HttpService:JSONDecode(resData)
                if decoded and decoded.success and decoded.commands then
                    processCommands(decoded.commands)
                end
            end
        end)
        
        if not success then
            warn("[Gag Heartbeat Error] " .. tostring(err))
        end
        
        task.wait(35)
    end
end) 
