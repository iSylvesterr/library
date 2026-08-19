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
-- NAPOLEON | THROW A COIN
-- Auto Throw Script by Napoleon Hub
-- ============================================================

repeat task.wait() until game:IsLoaded()

if _G.ThrowCoinScriptActive then
    _G.ThrowCoinScriptActive = false
    task.wait(0.5)
end
_G.ThrowCoinScriptActive = true

-- ============================================================
-- SERVICES
-- ============================================================
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- LOAD UI LIBRARY
-- ============================================================
local function LoadNapoleonUI()
    local url       = "https://raw.githubusercontent.com/Fdhlnn23/NapoleonUI/refs/heads/main/NPLN-UIv4.lua"
    local cacheName = "Napoleon_NewUI_cached.lua"
    local result    = nil

    if isfile and readfile and isfile(cacheName) then
        pcall(function() result = readfile(cacheName) end)
    end

    if not result or #result < 100 then
        for i = 1, 3 do
            local ok, res = pcall(function() return game:HttpGet(url) end)
            if ok and res and #res > 100 and not res:match("404: Not Found") then
                result = res
                if writefile then pcall(function() writefile(cacheName, result) end) end
                break
            end
            task.wait(1)
        end
    end

    if result and #result > 100 then
        local func, err = loadstring(result)
        if func then
            local ok, lib = pcall(func)
            if ok and lib then return lib end
        end
    end
    return nil
end

local Library = LoadNapoleonUI()
if not Library then
    warn("[ThrowCoin] CRITICAL: Gagal load NapoleonUI!")
    return
end

-- ============================================================
-- COIN LIST (untuk validasi nama)
-- ============================================================
local COIN_SET = {
    -- World 3 Coins
    ["Helios Coin"]    = true,
    ["Angelic Coin"]   = true,
    ["Hercules Coin"]  = true,
    ["Judgement Coin"] = true,
    ["Atlas Coin"]     = true,
    ["Empyrean Coin"]  = true,
    ["Dominion Coin"]  = true,
    ["Grace Coin"]     = true,
    -- World 2 Coins
    ["Infinity Coin"]  = true,
    ["Apex Coin"]      = true,
    ["Nexus Coin"]     = true,
    ["Miracle Coin"]   = true,
    ["Paradox Coin"]   = true,
    ["Soul Coin"]      = true,
    ["Tempest Coin"]   = true,
    ["Obsidian Coin"]  = true,
    ["Mirage Coin"]    = true,
    ["Eclipse Coin"]   = true,
    ["Chronos Coin"]   = true,
    ["Void Coin"]      = true,
    ["Galaxy Coin"]    = true,
    -- World 1 Coins
    ["Starlight Coin"] = true,
    ["Aether Coin"]    = true,
    ["Volt Coin"]      = true,
    ["Prism Coin"]     = true,
    ["Fire Coin"]      = true,
    ["Sapphire Coin"]  = true,
    ["Fortune Coin"]   = true,
    ["Copper Coin"]    = true,
    ["Basic Coin"]     = true,
}

-- ============================================================
-- REMOTE & POSITION
-- ============================================================
local CoinLanded = ReplicatedStorage:WaitForChild("Assets", 10)
    and ReplicatedStorage.Assets:WaitForChild("Events", 10)
    and ReplicatedStorage.Assets.Events:WaitForChild("CoinLanded", 10)

local SellAllEvent = ReplicatedStorage:WaitForChild("Assets", 10)
    and ReplicatedStorage.Assets:WaitForChild("Events", 10)
    and ReplicatedStorage.Assets.Events:WaitForChild("SellAll", 10)

local SellStackEvent = ReplicatedStorage:WaitForChild("Assets", 10)
    and ReplicatedStorage.Assets:WaitForChild("Events", 10)
    and ReplicatedStorage.Assets.Events:WaitForChild("SellStack", 10)

local SyncUpgradesEvent = ReplicatedStorage:WaitForChild("Assets", 10)
    and ReplicatedStorage.Assets:WaitForChild("Events", 10)
    and ReplicatedStorage.Assets.Events:WaitForChild("SyncUpgrades", 10)

local DEFAULT_LAND_POS = Vector3.new(-1167.19140625, 0.72600001096725, -163.87882995605)
local VIP_LAND_POS     = Vector3.new(-1155.4671630859, 0.72600001096725, 75.134056091309)

-- ============================================================
-- HELPERS
-- ============================================================
local ICON_ID = "136289055140268"

local function notif(content, duration, title)
    if Library and Library.MakeNotify then
        Library:MakeNotify({
            Title   = title or "Napoleon | Throw A Coin",
            Content = content or "",
            Delay   = duration or 4,
            Icon    = "rbxassetid://" .. ICON_ID,
        })
    end
end

-- Baca coin yang sedang di-equip dari HUD PlayerGui
-- Game nampilin nama coin di TextLabel di dalam HUD.Coin
local function getEquippedCoinName()
    local found = nil

    pcall(function()
        -- Path: PlayerGui -> UiFolder -> Main -> HUD -> Coin
        local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not playerGui then return end

        local uiFolder = playerGui:FindFirstChild("UiFolder")
        if not uiFolder then return end

        local main = uiFolder:FindFirstChild("Main")
        if not main then return end

        local hud = main:FindFirstChild("HUD")
        if not hud then return end

        local coinFrame = hud:FindFirstChild("Coin")
        if not coinFrame then return end

        -- Cari TextLabel yang isinya nama koin yang valid
        for _, obj in ipairs(coinFrame:GetDescendants()) do
            if obj:IsA("TextLabel") and COIN_SET[obj.Text] then
                found = obj.Text
                return
            end
        end
    end)

    -- Fallback: cari di seluruh PlayerGui (lebih lambat tapi lebih toleran)
    if not found then
        pcall(function()
            local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
            if not playerGui then return end
            for _, obj in ipairs(playerGui:GetDescendants()) do
                if obj:IsA("TextLabel") and COIN_SET[obj.Text] then
                    found = obj.Text
                    return
                end
            end
        end)
    end

    return found or "Basic Coin"
end

local function getLandPosition()
    local offsetX = (math.random() - 0.5) * 2
    local offsetZ = (math.random() - 0.5) * 2
    return Vector3.new(
        DEFAULT_LAND_POS.X + offsetX,
        DEFAULT_LAND_POS.Y,
        DEFAULT_LAND_POS.Z + offsetZ
    )
end

local function getVIPLandPosition()
    local offsetX = (math.random() - 0.5) * 4
    local offsetZ = (math.random() - 0.5) * 4
    return Vector3.new(
        VIP_LAND_POS.X + offsetX,
        VIP_LAND_POS.Y,
        VIP_LAND_POS.Z + offsetZ
    )
end

-- ============================================================
-- THROW LOGIC
-- ============================================================
local throwActive  = false
local totalThrows  = 0
local sessionStart = os.clock()

local function doSingleThrow()
    if not CoinLanded then
        warn("[ThrowCoin] Remote CoinLanded tidak ditemukan!")
        return false
    end

    local coinName = getEquippedCoinName()
    local landPos  = getLandPosition()

    local ok, err = pcall(function()
        CoinLanded:FireServer(Config.ThrowPower or 5, landPos, coinName, nil, nil)
    end)

    if ok then
        totalThrows = totalThrows + 1
        return true
    else
        warn("[ThrowCoin] FireServer error: " .. tostring(err))
        return false
    end
end

local function doSingleVIPThrow()
    if not CoinLanded then return false end
    local coinName = getEquippedCoinName()
    local landPos  = getVIPLandPosition()
    local ok, err = pcall(function()
        CoinLanded:FireServer(Config.ThrowPower or 5, landPos, coinName, nil, nil)
    end)
    if ok then
        totalThrows = totalThrows + 1
        return true
    else
        warn("[ThrowCoin VIP] FireServer error: " .. tostring(err))
        return false
    end
end

local function startThrowLoop()
    if throwActive then return end
    throwActive  = true
    sessionStart = os.clock()
    totalThrows  = 0

    task.spawn(function()
        local coinName = getEquippedCoinName()
        notif("Auto Throw aktif! Coin: " .. coinName, 4, "Napoleon | Throw A Coin")

        while Config.AutoThrow and _G.ThrowCoinScriptActive do
            doSingleThrow()
            task.wait(0.1)
        end

        throwActive = false
        notif("Auto Throw berhenti. Total: " .. totalThrows .. " throws", 4, "Napoleon | Throw A Coin")
    end)
end

local vipThrowActive = false
local vipTotalThrows  = 0

local function startVIPThrowLoop()
    if vipThrowActive then return end
    vipThrowActive = true
    vipTotalThrows = 0

    task.spawn(function()
        local coinName = getEquippedCoinName()
        notif("VIP Throw aktif! Arg=3 | Coin: " .. coinName, 4, "Napoleon | VIP Throw")

        while Config.VIPAutoThrow and _G.ThrowCoinScriptActive do
            doSingleVIPThrow()
            vipTotalThrows = vipTotalThrows + 1
            task.wait(0.1)
        end

        vipThrowActive = false
        notif("VIP Throw berhenti. Total: " .. vipTotalThrows .. " throws", 4, "Napoleon | VIP Throw")
    end)
end

local sellAllActive = false
local function startSellAllLoop()
    if sellAllActive then return end
    sellAllActive = true

    task.spawn(function()
        notif("Auto Sell All aktif!", 4, "Napoleon | Shop")
        while Config.AutoSellAll and _G.ThrowCoinScriptActive do
            if SellAllEvent then
                pcall(function() SellAllEvent:FireServer() end)
            end
            task.wait(2) -- Jual semua setiap 2 detik supaya nggak spam
        end
        sellAllActive = false
        notif("Auto Sell All berhenti.", 4, "Napoleon | Shop")
    end)
end

local sellStackActive = false
local function startSellStackLoop()
    if sellStackActive then return end
    sellStackActive = true

    task.spawn(function()
        notif("Auto Sell Stack aktif!", 4, "Napoleon | Shop")
        while Config.AutoSellStack and _G.ThrowCoinScriptActive do
            if SellStackEvent and LocalPlayer.Character then
                pcall(function() SellStackEvent:FireServer(LocalPlayer.Character) end)
            end
            task.wait(1.5)
        end
        sellStackActive = false
        notif("Auto Sell Stack berhenti.", 4, "Napoleon | Shop")
    end)
end

local syncUpgradesActive = false
local function startSyncUpgradesLoop()
    if syncUpgradesActive then return end
    syncUpgradesActive = true

    task.spawn(function()
        notif("Auto Sync Upgrades aktif!", 4, "Napoleon | Upgrades")
        while Config.AutoSyncUpgrades and _G.ThrowCoinScriptActive do
            if SyncUpgradesEvent then
                pcall(function() SyncUpgradesEvent:FireServer() end)
            end
            task.wait(5)
        end
        syncUpgradesActive = false
        notif("Auto Sync Upgrades berhenti.", 4, "Napoleon | Upgrades")
    end)
end

-- ============================================================
-- VIP MODULE
-- ============================================================
local function enableVIP()
    LocalPlayer:SetAttribute("VIP", true)
    pcall(function()
        local wall = workspace:WaitForChild("Map", 5):FindFirstChild("vipWall")
        if wall then wall.CanCollide = false end
    end)
    -- Bypass Policy (gambling restriction)
    task.delay(2, function()
        pcall(function()
            local CS = game:GetService("CollectionService")
            for _, v in CS:GetTagged("PolicyAPI") do v.Scale = 1 end
            local vipLuck = workspace:WaitForChild("Map"):WaitForChild("VIPFountain")
                :WaitForChild("Fountain"):WaitForChild("Model")
                :WaitForChild("v"):WaitForChild("v"):FindFirstChild("VIPLuck")
            if vipLuck then vipLuck.Enabled = true end
        end)
    end)
    notif("VIP: ACTIVATED | Wall bypass + Policy bypass", 4, "Napoleon | VIP")
end

local function disableVIP()
    LocalPlayer:SetAttribute("VIP", false)
    pcall(function()
        local wall = workspace:WaitForChild("Map"):FindFirstChild("vipWall")
        if wall then wall.CanCollide = true end
    end)
    notif("VIP: DEACTIVATED", 3, "Napoleon | VIP")
end

-- Hook attribute spy biar wall gak reset
LocalPlayer:GetAttributeChangedSignal("VIP"):Connect(function()
    if LocalPlayer:GetAttribute("VIP") == true then
        pcall(function()
            local wall = workspace:WaitForChild("Map"):FindFirstChild("vipWall")
            if wall then wall.CanCollide = false end
        end)
    end
end)

-- ============================================================
-- CONFIG
-- ============================================================
Config = { AutoThrow = false, VIPAutoThrow = false, VIPMode = false, AutoSellAll = false, AutoSellStack = false, AutoSyncUpgrades = false, AntiAFK = false, ThrowPower = 5 }

-- ============================================================
-- UI SETUP
-- ============================================================
local Window = Library:Window({
    Title      = "Napoleon",
    Footer     = "Throw A Coin",
    Color      = Color3.fromRGB(81, 66, 255),
    Color2     = Color3.fromRGB(0, 0, 14),
    ["Tab Width"] = 130,
    Image      = "111895858615511",
    WindowIMG  = "91334002283698",
    LogoHUB    = "136289055140268"
})
local Tabs = Window

local MainTab     = Tabs:AddTab({ Name = "Main", Icon = "payment" })
local ThrowSection = MainTab:AddSection("Auto Throw")

local VipSection = MainTab:AddSection("VIP Bypass")

VipSection:AddToggle({
    Title    = "Enable VIP Auto Throw",
    Title2   = "VIP Throw",
    Content  = "Auto throw via VIP fountain (arg=3). Posisi VIP, luck boost. Gunakan setelah Enable VIP aktif.",
    Default  = false,
    Callback = function(val)
        Config.VIPAutoThrow = val
        if val then startVIPThrowLoop() end
    end
})

VipSection:AddToggle({
    Title    = "Enable VIP",
    Title2   = "VIP",
    Content  = "Bypass VIP wall + spoof tag + unblock PolicyApi (gambling restriction).",
    Default  = false,
    Callback = function(val)
        Config.VIPMode = val
        if val then enableVIP() else disableVIP() end
    end
})

ThrowSection:AddToggle({
    Title    = "Enable Auto Throw",
    Title2   = "Enable",
    Content  = "Otomatis lempar koin. Coin yang dipakai = coin yang sedang kamu equip di game (auto-detect dari HUD).",
    Default  = false,
    Callback = function(val)
        Config.AutoThrow = val
        if val then startThrowLoop() end
    end
})

local ShopTab     = Tabs:AddTab({ Name = "Shop", Icon = "shopping_cart" })
local ShopSection = ShopTab:AddSection("Auto Sell")

ShopSection:AddToggle({
    Title    = "Enable Auto Sell All",
    Title2   = "Sell All",
    Content  = "Otomatis menjual semua item yang bisa dijual (dari Backpack/Inventory).",
    Default  = false,
    Callback = function(val)
        Config.AutoSellAll = val
        if val then startSellAllLoop() end
    end
})

ShopSection:AddToggle({
    Title    = "Enable Auto Sell Stack",
    Title2   = "Sell Stack",
    Content  = "Otomatis menjual tumpukan item (Sell Stack) yang dipegang karakter.",
    Default  = false,
    Callback = function(val)
        Config.AutoSellStack = val
        if val then startSellStackLoop() end
    end
})

local UpgradesSection = ShopTab:AddSection("Upgrades Sync")

UpgradesSection:AddButton({
    Title    = "Sync Upgrades Now",
    Content  = "Sinkronkan multiplier value & luck dengan server.",
    Callback = function()
        if SyncUpgradesEvent then
            pcall(function() SyncUpgradesEvent:FireServer() end)
            notif("Upgrades disinkronisasikan!", 3, "Napoleon | Upgrades")
        end
    end
})

UpgradesSection:AddToggle({
    Title    = "Enable Auto Sync Upgrades",
    Title2   = "Auto Sync",
    Content  = "Sinkronisasi otomatis setiap 5 detik agar multiplier selalu akurat.",
    Default  = false,
    Callback = function(val)
        Config.AutoSyncUpgrades = val
        if val then startSyncUpgradesLoop() end
    end
})

local MiscTab = Tabs:AddTab({ Name = "Misc", Icon = "settings" })
local MiscSection = MiscTab:AddSection("Utility")

MiscSection:AddToggle({
    Title    = "Enable Anti-AFK",
    Title2   = "Anti AFK",
    Content  = "Mencegah kick AFK (20 min) & bypass idle bawaan game.",
    Default  = false,
    Callback = function(val)
        Config.AntiAFK = val
        if val then enableAntiAFK() end
    end
})

-- ============================================================
-- ANTI-AFK (Bypass game's custom AntiKickScript & Roblox AFK)
-- Mencegah game masuk ke mode "AFK" yang bisa menyalakan
-- auto-throw paksa dari sisi server.
-- ============================================================
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser         = game:GetService("VirtualUser")
local antiAfkConnection   = nil
local antiAfkLoopActive   = false

local function enableAntiAFK()
    if antiAfkLoopActive then return end
    antiAfkLoopActive = true

    -- 1. Bypass Roblox 20-min AFK Kick
    if not antiAfkConnection then
        antiAfkConnection = LocalPlayer.Idled:Connect(function()
            if Config.AntiAFK then
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end
        end)
    end

    -- 2. Bypass Custom Game AFK
    pcall(function()
        if getconnections then
            for _, conn in ipairs(getconnections(game:GetService("UserInputService").WindowFocusReleased)) do
                conn:Disable()
            end
        end
    end)

    -- 3. Matikan AntiKickScript & UI Auto-throw Bawaan Game
    pcall(function()
        local scripts = LocalPlayer:FindFirstChild("PlayerScripts")
        if scripts then
            local antiKick = scripts:FindFirstChild("Scripts") and scripts.Scripts:FindFirstChild("AntiKickScript")
            if antiKick then
                antiKick.Disabled = true
            end
        end
        local hud = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("UiFolder") and LocalPlayer.PlayerGui.UiFolder:FindFirstChild("Main") and LocalPlayer.PlayerGui.UiFolder.Main:FindFirstChild("HUD")
        if hud then
            if hud:FindFirstChild("AFKSafe") then
                hud.AFKSafe.Visible = false
            end
            
            -- Matikan script di tombol Auto-throw bawaan & sembunyikan
            local autoBtn = hud:FindFirstChild("Coin") and hud.Coin:FindFirstChild("AutoButton")
            if autoBtn then
                for _, v in ipairs(autoBtn:GetDescendants()) do
                    if v:IsA("LocalScript") then
                        v.Disabled = true
                    end
                end
                autoBtn.Visible = false
            end
        end
    end)

    -- 4. PUTUS TOTAL koneksi StartAFKSafe (server -> client AFK trigger)
    --    Ini penyebab AUTO-THROW bawaan idup sendiri.
    --    Kita disconnect SEMUA listener, terus pasang listener kosong.
    pcall(function()
        local events = ReplicatedStorage:WaitForChild("Assets", 5):WaitForChild("Events", 5)
        if events then
            -- (A) Putus koneksi StartAFKSafe
            local startAFK = events:FindFirstChild("StartAFKSafe")
            if startAFK and startAFK:IsA("RemoteEvent") then
                local conns = getconnections(startAFK.OnClientEvent)
                for _, conn in ipairs(conns) do
                    conn:Disable()
                end
            end
            -- (B) Blokir SetAFKSafe dari client -> server
            local setAFK = events:FindFirstChild("SetAFKSafe")
            if setAFK and setAFK:IsA("RemoteEvent") then
                -- overwrite FireServer biar gak bisa kirim true
                local oldFire = setAFK.FireServer
                setAFK.FireServer = function(self, state, ...)
                    if state == true then return end -- BLOKIR
                    return oldFire(self, state, ...)
                end
            end
        end
    end)

    -- (C) Anti-kick reconnect juga diputus
    pcall(function()
        local events = ReplicatedStorage:WaitForChild("Assets", 5):WaitForChild("Events", 5)
        if events then
            local reconnect = events:FindFirstChild("AntiKickReconnect")
            if reconnect and reconnect:IsA("RemoteEvent") then
                local oldFire = reconnect.FireServer
                reconnect.FireServer = function(self, ...) return end -- BLOKIR TOTAL
            end
        end
    end)

    -- (D) Hook __namecall buat jaga-jaga event lain yg belum ketemu
    if not _G.AutothrowHooked then
        _G.AutothrowHooked = true
        pcall(function()
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                if not checkcaller() and getnamecallmethod() == "FireServer" then
                    local blockList = {
                        AutothrowState = true,
                        SetAFKSafe = true,
                        AntiKickReconnect = true,
                    }
                    if blockList[self.Name] then
                        return -- BLOKIR semua
                    end
                end
                return oldNamecall(self, ...)
            end)
        end)
    end

    -- 5. Loop KILL AUTO-THROW bawaan game (jalan tiap 3 detik)
    --    Server yang nyalain -> kita matiin terus每秒
    task.spawn(function()
        notif("Anti-AFK aktif! Auto-throw bawaan dibunuh tiap 3 detik.", 3, "Napoleon | Misc")
        
        while Config.AntiAFK and _G.ThrowCoinScriptActive do
            task.wait(3)
            if not Config.AntiAFK then break end
            pcall(function()
                -- (A) Bunuh tombol auto-throw bawaan
                local hud = LocalPlayer:FindFirstChild("PlayerGui")
                    and LocalPlayer.PlayerGui:FindFirstChild("UiFolder")
                    and LocalPlayer.PlayerGui.UiFolder:FindFirstChild("Main")
                    and LocalPlayer.PlayerGui.UiFolder.Main:FindFirstChild("HUD")
                if hud then
                    local coin = hud:FindFirstChild("Coin")
                    if coin then
                        local autoBtn = coin:FindFirstChild("AutoButton")
                        if autoBtn then
                            autoBtn.Visible = false
                            -- disable semua script dalamnya
                            for _, v in ipairs(autoBtn:GetDescendants()) do
                                if v:IsA("LocalScript") or v:IsA("Script") then
                                    v.Disabled = true
                                end
                            end
                            -- Bunuh MouseButton1Click biar gak bisa di-klik
                            local clicks = getconnections(autoBtn.MouseButton1Click)
                            for _, conn in ipairs(clicks) do
                                conn:Disable()
                            end
                        end
                    end
                    -- (B) Sembunyiin AFKSafe UI
                    local afk = hud:FindFirstChild("AFKSafe")
                    if afk and afk.Visible then
                        afk.Visible = false
                    end
                end
                -- (C) Reset idle timer game dengan input REAL
                -- Pakai tombol W (move forward) biar game anggap kita beneran main
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
            end)
        end
        antiAfkLoopActive = false
        notif("Anti-AFK berhenti.", 3, "Napoleon | Misc")
    end)
end

-- ============================================================
-- CLEANUP
-- ============================================================
LocalPlayer.AncestryChanged:Connect(function()
    _G.ThrowCoinScriptActive = false
    Config.AutoThrow         = false
    Config.VIPAutoThrow      = false
    Config.AutoSellAll       = false
    Config.AutoSellStack     = false
    Config.AutoSyncUpgrades  = false
    Config.AntiAFK           = false
end)

print("[ThrowCoin] Script loaded. Napoleon | Throw A Coin | Coin: " .. getEquippedCoinName())
