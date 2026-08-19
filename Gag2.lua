local UI_LOADED = false
-- ============================================================
-- CORE SECURITY: ANTI-HOOK, ANTI-SPY, & ANTI-TAMPER V3.2
-- ============================================================
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

-- Pet response: XOR encrypted + Ed25519 signed
local function verifyPetResponse(raw)
    local HttpService = game:GetService("HttpService")
    local okJson, json = pcall(function() return HttpService:JSONDecode(raw) end)
    
    local function decryptLegacyXOR(hexStr)
        local decryptedRaw = decryptXOR(hexStr, "HOEEEE_MALING_PANGSIT")
        if decryptedRaw then
            local ok, decoded = pcall(function() return HttpService:JSONDecode(decryptedRaw) end)
            if ok and decoded then return decoded else warn("[GagTest] JSONDecode on decryptedRaw failed: " .. tostring(decoded)) end
        else
            warn("[GagTest] decryptedRaw is nil (XOR parsing failed)")
        end
        return nil
    end

    if not okJson or not json then
        warn("[GagTest] First JSONDecode failed! Error: " .. tostring(json))
        warn("[GagTest] First 200 chars of raw: " .. string.sub(tostring(raw), 1, 200))
        return decryptLegacyXOR(raw)
    end
    
    if json.data and type(json.data) == "string" then
        if json.sig and json.server_key then
            local sigValid = customVerify(json.data, json.sig, json.server_key)
            
            if not sigValid then
                warn("[GagTest] Invalid signature for pet response!")
                return nil
            end
            
            if sigValid then
                return decryptLegacyXOR(json.data)
            end
        else
            return decryptLegacyXOR(json.data)
        end
    end
    return nil
end

-- Decompiled/Rewritten for Grow a Garden
repeat task.wait() until game:IsLoaded()

;(function() -- scope reset

if _G.GagAutoScriptActive then
    _G.GagAutoScriptActive = false
    task.wait(0.5) -- Beri waktu untuk loop lama berhenti
end
_G.GagAutoScriptActive = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")

-- ============================================================
-- SECURITY & TRACKING
-- ============================================================
local UserID = LocalPlayer.UserId
local HWID = game:GetService("RbxAnalyticsService"):GetClientId()

-- ============================================================
-- GAME MODULES & DATA
-- ============================================================
local Networking = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Networking"))
local SeedData = require(ReplicatedStorage.SharedModules.SeedData)
local SellValueData = require(ReplicatedStorage.SharedModules.SellValueData)
local MutationData = require(ReplicatedStorage.SharedModules.MutationData)
local FruitValueCalc = require(ReplicatedStorage.SharedModules.FruitValueCalc)
local SellFlags = require(ReplicatedStorage.SharedModules.Flags.SellFlags)

local fruitStockCache = {}
local lastFruitStockFetch = 0
local fetchingFruitStock = false
local stockEventConnected = false

local function getFruitStockMultiplier(fruitName)
    if not stockEventConnected then
        stockEventConnected = true
        task.spawn(function()
            pcall(function()
                local Net = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
                Net.FruitStock.Snapshot.OnClientEvent:Connect(function(res)
                    if typeof(res) == "table" and typeof(res.entries) == "table" then
                        for k,v in pairs(res.entries) do
                            fruitStockCache[k] = v.multiplier or 1
                        end
                    end
                end)
            end)
        end)
    end

    if os.time() - lastFruitStockFetch > 60 and not fetchingFruitStock then
        fetchingFruitStock = true
        task.spawn(function()
            pcall(function()
                local Net = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
                local res = Net.FruitStock.Request:Fire()
                if typeof(res) == "table" and typeof(res.entries) == "table" then
                    for k,v in pairs(res.entries) do
                        fruitStockCache[k] = v.multiplier or 1
                    end
                end
            end)
            lastFruitStockFetch = os.time()
            fetchingFruitStock = false
        end)
    end
    return fruitStockCache[fruitName] or 1
end

local FruitVisualizerController
pcall(function()
    FruitVisualizerController = require(LocalPlayer.PlayerScripts:WaitForChild("Controllers"):WaitForChild("FruitVisualizerController"))
end)

local SEED_LIST = {}
local RARITY_LIST = {}
local PET_RARITIES = {}
local MUTATION_LIST = {"None"}
pcall(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    -- Load Pet Data dynamically
    local PetData = require(ReplicatedStorage:WaitForChild("SharedData"):WaitForChild("PetData"))
    local raritySet = {}
    for key, data in pairs(PetData) do
        if type(data) == "table" and data.DisplayName and data.Rarity then
            PET_RARITIES[data.DisplayName] = data.Rarity
            PET_RARITIES[key] = data.Rarity
            if not raritySet[data.Rarity] then
                raritySet[data.Rarity] = true
                table.insert(RARITY_LIST, data.Rarity)
            end
        end
    end
    local order = {Common = 1, Uncommon = 2, Rare = 3, Epic = 4, Legendary = 5, Mythic = 6, Super = 7, Godly = 8, Secret = 9}
    table.sort(RARITY_LIST, function(a,b) return (order[a] or 99) < (order[b] or 99) end)
    
    local mutDataMod = ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("MutationData")
    
    local temp = {}
    for _, child in ipairs(mutDataMod:GetChildren()) do
        if child:IsA("ModuleScript") then
            table.insert(temp, child.Name)
        end
    end
    
    if #temp == 0 then
        local mutData = require(mutDataMod)
        if type(mutData.GetMutation) == "function" then
            local getuv = debug.getupvalues or getupvalues
            if getuv then
                for _, upval in pairs(getuv(mutData.GetMutation)) do
                    if type(upval) == "table" and (upval.Gold or upval.Rainbow) then
                        for k, _ in pairs(upval) do
                            if type(k) == "string" and k ~= "None" and string.match(k, "^%u") and k ~= "ReturnPriceMultiplier" then
                                if not table.find(temp, k) then table.insert(temp, k) end
                            end
                        end
                        break
                    end
                end
            end
        end
    end

    table.sort(temp)
    for _, v in ipairs(temp) do table.insert(MUTATION_LIST, v) end
end)

for seedName, _ in pairs(SellValueData) do
    if type(seedName) == "string" then
        table.insert(SEED_LIST, seedName)
    end
end
table.sort(SEED_LIST)
table.insert(SEED_LIST, 1, "None")

local GEAR_LIST = {}
local UNGIFTABLE_GEARS = {"Shovel", "Build", "Megaphone", "Bicycle", "Boombox", "Metal Detector", "Wagon", "Camera", "Fishing Rod", "Bug Net"}
pcall(function()
    local GearShopData = require(ReplicatedStorage.SharedModules:WaitForChild("GearShopData"))
    if GearShopData and GearShopData.Data then
        for _, gear in ipairs(GearShopData.Data) do
            if gear.ItemName then
                table.insert(GEAR_LIST, gear.ItemName)
                if gear.EquippableGear == true and not table.find(UNGIFTABLE_GEARS, gear.ItemName) then
                    table.insert(UNGIFTABLE_GEARS, gear.ItemName)
                end
            end
        end
        table.sort(GEAR_LIST)
    end
end)
table.insert(GEAR_LIST, 1, "None")

local PROP_LIST = {}
pcall(function()
    local CrateData = require(ReplicatedStorage.SharedModules:WaitForChild("CrateData"))
    if CrateData and CrateData.GetAllCrates then
        for _, crate in ipairs(CrateData.GetAllCrates()) do
            if crate.Name then
                table.insert(PROP_LIST, crate.Name)
            end
            if crate.Items and type(crate.Items) == "table" then
                for _, item in ipairs(crate.Items) do
                    if item.Name and not table.find(PROP_LIST, item.Name) then
                        table.insert(PROP_LIST, item.Name)
                    end
                end
            end
        end
        table.sort(PROP_LIST)
    end
end)
table.insert(PROP_LIST, 1, "None")

local PET_LIST = {}
pcall(function()
    local PetModules = ReplicatedStorage:FindFirstChild("SharedModules") and ReplicatedStorage.SharedModules:FindFirstChild("PetModules")
    if PetModules then
        for _, module in ipairs(PetModules:GetChildren()) do
            if module:IsA("ModuleScript") then
                table.insert(PET_LIST, module.Name)
            end
        end
        table.sort(PET_LIST)
    end
end)
table.insert(PET_LIST, 1, "None")
table.insert(PET_LIST, 2, "All")

local Config = {
    WebSyncInventory = true,
    WebControlEnabled = false,
    AutoPlant = false,
    PlantSeedNames = {"None"},
    PlantLocation = "Random",
    PlantDelay = 0.5,
    AutoTrowel = false,
    TrowelPlants = {"All"},
    TrowelPositionMode = "Player Position",
    AutoShovel = false,
    AutoShovelSeeds = {"None"},
    AutoSwingShovel = false,
    AutoProtectBase = false,
    AutoHarvest = false,
    HarvestDelay = 0.5,
    CollectFruits = {"All"},
    MaxHarvestKg = 0,
    AutoSteal = false,
    StealDelay = 0.5,
    MaxSteal = 50,
    AutoClaim = false,
    AutoClaimTypes = {"Items", "Seedpack", "Pet Items"},
    AutoSell = false,
    AutoSellDailyDeal = false,
    SellAllDelay = 2,
    SellMode = "Sell All",
    SellNames = {"None"},
    SellRarities = {"None"},
    SellMutations = {"None"},
    SellMaxKg = 0,
    AutoFavFruit = false,
    AutoFavNames = {"None"},
    AutoFavMutations = {"None"},
    AutoFavMinKg = 0,
    ESPFruit = false,
    ESPMode = "Market Price",
    ESPFruitFilter = "All",
    ESPValueFilter = "All",
    ESPPlotFilter = "All",
    ESPPlantFeet = false,
    ESPPlantFeetMode = "Current + Final",
    AutoBuySeed = false,
    SeedToBuy = {"None"},
    PredictUI = false,
    PredictTargetSeed = "Apple Seed",

    AutoBuyGear = false,
    GearToBuy = {"None"},
    AutoBuyProp = false,
    PropToBuy = {"None"},
    AutoBuyAuction = false,
    AuctionSnipeItems = {"None"},
    AuctionSnipeTime = "10s",
    AutoTamePet = false,
    TamePets = {"None"},
    AutoPetFinderHop = false,
    AutoJoinPetFinder = false,
    PetFinderHopTarget = {"None"},
    AntiAFK = true,
    AntiKnockback = false,
    GPUSaver = false,
    HideOtherGardens = false,
    HideGardensTarget = {"None"},
    EnableWebhook = false,
    WebhookURL = "",
    PredictWeather = true,
    MoonFinderActive = false,
    MoonFinderTarget = {"Rainbow Moon"},
    HideNotifications = false,
    AutoLeaveWeather = false,
    AutoLeaveWeatherTarget = {"Goldmoon"},
    AutoReconnect = true,
    HelperAutoEclipse = false,
    HelperEclipseMaxKg = 0,
    HelperEclipseDelay = 120,
    DisableAllPrompts = false
}

-- ============================================================
-- UTILITIES
-- ============================================================

    
local function notif(text, dur, title)
    print("EEfklnaenfankefa")
    if not Config.HideNotifications then
        pcall(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = title or "Napoleon",
                Text = text,
                Duration = dur or 3
            })
        end)
    end
    print(Config.WebControlEnabled)
    if Config.WebControlEnabled then
        local sUrl = getgenv().ServerURL or _G.ServerURL or "https://napoleonn.net"
        local key = getgenv().Key or _G.Key or "Unknown_Key"
        
        warn("[Napoleon Debug] Preparing Notif | URL: " .. tostring(sUrl) .. " | Key: " .. tostring(key))
        
        if sUrl and key then
            task.spawn(function()
                local success, err = pcall(function()
                    local requestFunc = syn and syn.request or http_request or request or fluxus and fluxus.request
                    local bodyData = game:GetService("HttpService"):JSONEncode({
                        key = key,
                        title = title or "Napoleon",
                        message = text,
                        type = "info"
                    })
                    local endpoint = sUrl .. "/api/script/notification"
                    
                    if requestFunc then
                        warn("[Napoleon Debug] Sending POST with requestFunc to: " .. endpoint)
                        requestFunc({
                            Url = endpoint,
                            Method = "POST",
                            Headers = { ["Content-Type"] = "application/json" },
                            Body = bodyData
                        })
                    else
                        warn("[Napoleon Debug] NO REQUEST FUNCTION, using HttpPostAsync to: " .. endpoint)
                        game:HttpPostAsync(endpoint, bodyData, "application/json")
                    end
                end)
                if not success then
                    warn("[Napoleon] Failed to send notification to web: " .. tostring(err))
                end
            end)
        else
            warn("[Napoleon Debug] sUrl or key is missing!")
        end
    else
        warn("[Napoleon Debug] Config.WebControlEnabled is FALSE")
    end
end

local function setupAutoReconnect()
    task.spawn(function()
        while task.wait(2) do
            if Config.AutoReconnect then
                pcall(function()
                    local coreGui = game:GetService("CoreGui")
                    local promptOverlay = coreGui:FindFirstChild("RobloxPromptGui") and coreGui.RobloxPromptGui:FindFirstChild("promptOverlay")
                    if promptOverlay then
                        local errPrompt = promptOverlay:FindFirstChild("ErrorPrompt")
                        if errPrompt and errPrompt.Visible then
                            if _G.SuppressAutoReconnect then
                                game:GetService("GuiService"):ClearError()
                                return
                            end
                            local delay = math.floor(_G.AutoReconnectDelay or 2)
                            _G.AutoReconnectDelay = nil -- Reset for next time
                            
                            local messageLabel = nil
                            pcall(function()
                                for _, desc in ipairs(errPrompt:GetDescendants()) do
                                    if desc:IsA("TextLabel") and string.find(desc.Text, "dalam %d+ detik") then
                                        messageLabel = desc
                                        break
                                    end
                                end
                            end)

                            for i = delay, 1, -1 do
                                if messageLabel then
                                    pcall(function()
                                        messageLabel.Text = string.gsub(messageLabel.Text, "dalam %d+ detik", "dalam " .. i .. " detik")
                                    end)
                                end
                                task.wait(1)
                            end
                            local TS = game:GetService("TeleportService")
                            pcall(function() TS:Teleport(game.PlaceId, game.Players.LocalPlayer) end)
                        end
                    end
                end)
            end
        end
    end)
end
setupAutoReconnect()

-- ============================================================
-- EMERGENCY STOP UI
-- ============================================================
local EmergencyStopBtn
task.spawn(function()
    pcall(function()
        local coreGui = game:GetService("CoreGui")
        if coreGui:FindFirstChild("NapoStopHop") then
            coreGui.NapoStopHop:Destroy()
        end
        
        local sg = Instance.new("ScreenGui")
        sg.Name = "NapoStopHop"
        sg.ResetOnSpawn = false
        sg.DisplayOrder = 999999
        sg.Parent = coreGui
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 200, 0, 50)
        btn.Position = UDim2.new(0.5, -100, 0, 20)
        btn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 24
        btn.Font = Enum.Font.GothamBold
        btn.Text = "STOP AUTO HOP"
        btn.Visible = false
        btn.Parent = sg
        
        local uicorner = Instance.new("UICorner")
        uicorner.CornerRadius = UDim.new(0, 8)
        uicorner.Parent = btn
        
        local uistroke = Instance.new("UIStroke")
        uistroke.Color = Color3.new(1, 1, 1)
        uistroke.Thickness = 2
        uistroke.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            Config.MoonFinderActive = false
            Config.AutoPetFinderHop = false
            Config.AutoJoinPetFinder = false
            Config.AutoTamePet = false
            _G.ProtectSwingActive = false
            btn.Visible = false
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.PlatformStand = false
                        humanoid.AutoRotate = true
                    end
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                        local gyro = hrp:FindFirstChild("GagAimbot")
                        if gyro then gyro:Destroy() end
                    end
                end
                local cam = workspace.CurrentCamera
                if cam and cam.CameraType == Enum.CameraType.Scriptable then
                    cam.CameraType = Enum.CameraType.Custom
                end
            end)
            pcall(function()
                if writefile then
                    writefile("Napoleon_GAG_MoonFinder_Visited.json", game:GetService("HttpService"):JSONEncode({visited = {}, target = {"Rainbow Moon"}, serverCache = {}, lastHopTime = 0}))
                    writefile("Napoleon_GAG_PetHop_Visited.json", game:GetService("HttpService"):JSONEncode({active = false, target = {"None"}, lastHopTime = 0}))
                end
            end)
            notif("Emergency Stop! All features cancelled.", 5, "System")
        end)
        
        EmergencyStopBtn = btn
    end)
end)

local function setEmergencyStopVisible(state)
    if EmergencyStopBtn then
        EmergencyStopBtn.Visible = state
    end
end

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

local function getPlotOwner(plot)
    if not plot then return nil, nil end
    local ownerId, ownerUsername = nil, nil
    
    pcall(function() ownerId = tonumber(plot:GetAttribute("OwnerUserId")) end)
    pcall(function() ownerUsername = tostring(plot:GetAttribute("Owner") or "") end)
    
    if not ownerId or ownerId == 0 then
        pcall(function()
            local val = plot:FindFirstChild("OwnerUserId") or plot["OwnerUserId"]
            if val and typeof(val) == "Instance" and (val:IsA("IntValue") or val:IsA("NumberValue") or val:IsA("StringValue")) then
                ownerId = tonumber(val.Value)
            elseif val then
                ownerId = tonumber(val)
            end
        end)
    end
    
    if not ownerUsername or ownerUsername == "" or ownerUsername == "nil" then
        pcall(function()
            local val = plot:FindFirstChild("Owner") or plot["Owner"]
            if val and typeof(val) == "Instance" then
                if val:IsA("StringValue") or val:IsA("ValueBase") then
                    ownerUsername = tostring(val.Value)
                elseif val:IsA("ObjectValue") and val.Value then
                    ownerUsername = val.Value.Name
                    if val.Value:IsA("Player") and not ownerId then
                        ownerId = val.Value.UserId
                    end
                end
            elseif val and type(val) == "string" then
                ownerUsername = val
            end
        end)
    end
    
    return ownerId, ownerUsername
end

local function getMyPlot()
    local gardensFolder = workspace:FindFirstChild("Gardens")
    if gardensFolder then
        local myId = LocalPlayer.UserId
        local myName = LocalPlayer.DisplayName
        local myRealName = LocalPlayer.Name
        for _, plot in ipairs(gardensFolder:GetChildren()) do
            local oId, oName = getPlotOwner(plot)
            if tonumber(oId) == myId or tostring(oName) == myName or tostring(oName) == myRealName then
                return plot
            end
            local textLabel = plot:FindFirstChild("Signs") 
                and plot.Signs:FindFirstChild("Garden")
                and plot.Signs.Garden:FindFirstChild("CorePart")
                and plot.Signs.Garden.CorePart:FindFirstChild("SurfaceGui")
                and plot.Signs.Garden.CorePart.SurfaceGui:FindFirstChild("Player")
                and plot.Signs.Garden.CorePart.SurfaceGui.Player:FindFirstChild("TextLabel")
                
            if textLabel and textLabel:IsA("TextLabel") then
                local txt = textLabel.Text
                if txt and (string.find(txt, myName, 1, true) or string.find(txt, myRealName, 1, true)) then
                    return plot
                end
            end
        end
    end
    return nil
end

local function removeBodyVelocity(hrp)
    for _, v in ipairs(hrp:GetChildren()) do
        if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
            v:Destroy()
        end
    end
end

local function tweenTeleport(hrp, targetPos, speed)
    if not hrp or not hrp.Parent then return end
    removeBodyVelocity(hrp)
    local dist = (hrp.Position - targetPos).Magnitude
    speed = speed or 30
    local duration = math.max(dist / speed, 0.15)
    local rot = hrp.CFrame - hrp.CFrame.Position
    local tween = game:GetService("TweenService"):Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos) * rot})
    tween:Play()
    tween.Completed:Wait()
end

local function isItemInShop(shopName, itemName)
    local stock = ReplicatedStorage:FindFirstChild("StockValues")
    if not stock then return false end
    local shop = stock:FindFirstChild(shopName)
    if not shop then return false end
    local items = shop:FindFirstChild("Items")
    if not items then return false end

    local targetItem = items:FindFirstChild(itemName)
    if not targetItem then
        for _, v in pairs(items:GetChildren()) do
            if v.Name == itemName then targetItem = v break end
            if v:IsA("StringValue") and v.Value == itemName then targetItem = v break end
        end
    end

    if targetItem then
        if (targetItem:IsA("IntValue") or targetItem:IsA("NumberValue")) and targetItem.Value <= 0 then
            return false
        end

        for _, child in pairs(targetItem:GetChildren()) do
            if (child:IsA("IntValue") or child:IsA("NumberValue")) and child.Value <= 0 then
                return false
            end
            if child:IsA("BoolValue") and string.find(string.lower(child.Name), "sold") and child.Value == true then
                return false
            end
        end
        
        for k, v in pairs(targetItem:GetAttributes()) do
            local lowerK = string.lower(k)
            if type(v) == "number" and v <= 0 and (string.find(lowerK, "stock") or string.find(lowerK, "amount")) then
                return false
            end
            if type(v) == "boolean" and v == true and string.find(lowerK, "sold") then
                return false
            end
        end
        return true
    end
    return false
end

-- ============================================================
-- CORE LOOPS
-- ============================================================
local autoSwingActive = false
local function startAutoSwingShovelLoop()
    if autoSwingActive then return end
    autoSwingActive = true
    task.spawn(function()
        local VirtualUser = game:GetService("VirtualUser")
        while (Config.AutoSwingShovel or _G.ProtectSwingActive) and _G.GagAutoScriptActive do
            pcall(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("Humanoid") then
                    -- Equip Shovel if not equipped
                    local equipped = character:FindFirstChildWhichIsA("Tool")
                    if not (equipped and equipped:GetAttribute("Shovel")) then
                        local foundShovel = nil
                        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                            if tool:IsA("Tool") and tool:GetAttribute("Shovel") then
                                foundShovel = tool
                                break
                            end
                        end
                        if foundShovel then
                            character.Humanoid:EquipTool(foundShovel)
                            task.wait(0.2)
                        end
                    end
                    
                    -- Swing Shovel without auto clicker
                    equipped = character:FindFirstChildWhichIsA("Tool")
                    if equipped and equipped:GetAttribute("Shovel") then
                        pcall(function()
                            local myHrp = character:FindFirstChild("HumanoidRootPart")
                            if not myHrp then return end
                            
                            -- 1. Play swing animation locally
                            local animator = character.Humanoid:FindFirstChildOfClass("Animator")
                            if animator then
                                local anim = Instance.new("Animation")
                                anim.AnimationId = "rbxassetid://78592768207309"
                                local track = animator:LoadAnimation(anim)
                                track.Priority = Enum.AnimationPriority.Action4
                                track:Play()
                            end
                            
                            -- 2. Fire Swing remote
                            local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
                            Networking.Shovel.SwingShovel:Fire()
                            
                            -- 3. Hit nearby players & pets (Kill Aura logic)
                            local myPos = myHrp.Position
                            local closestTargetPos = nil
                            local closestDist = 25 -- Range diperbesar ke 25
                            
                            -- A. Hajar Player (Smarter Check: Harus hidup)
                            for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
                                if p ~= LocalPlayer and p.Character then
                                    local targetHrp = p.Character:FindFirstChild("HumanoidRootPart")
                                    local targetHum = p.Character:FindFirstChild("Humanoid")
                                    if targetHrp and targetHum and targetHum.Health > 0 then
                                        local dist = (targetHrp.Position - myPos).Magnitude
                                        if dist <= 25 then 
                                            Networking.Shovel.HitPlayer:Fire(p.UserId)
                                            if dist < closestDist then
                                                closestDist = dist
                                                closestTargetPos = targetHrp.Position
                                            end
                                        end
                                    end
                                end
                            end
                            
                            -- B. Hajar Pet / Bunny
                            local petVisuals = workspace:FindFirstChild("_PetVisualClient")
                            if petVisuals then
                                local models = petVisuals:FindFirstChild("Models")
                                if models then
                                    for _, petModel in pairs(models:GetChildren()) do
                                        local petId = petModel:GetAttribute("PetID")
                                        local ownerName = petModel:GetAttribute("Owner")
                                        
                                        if type(petId) == "string" and petId ~= "" and type(ownerName) == "string" and ownerName ~= LocalPlayer.Name then
                                            local primary = petModel.PrimaryPart
                                            if primary then
                                                local dist = (primary.Position - myPos).Magnitude
                                                if dist <= 25 then
                                                    local ownerPlayer = game:GetService("Players"):FindFirstChild(ownerName)
                                                    if ownerPlayer then
                                                        Networking.Pets.ScarePet:Fire(ownerPlayer.UserId, petId)
                                                        if dist < closestDist then
                                                            closestDist = dist
                                                            closestTargetPos = primary.Position
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            
                            -- C. Auto Face Closest Target (Smooth Aimbot pake BodyGyro)
                            local gyro = myHrp:FindFirstChild("GagAimbot")
                            if closestTargetPos then
                                if not gyro then
                                    gyro = Instance.new("BodyGyro")
                                    gyro.Name = "GagAimbot"
                                    gyro.MaxTorque = Vector3.new(0, math.huge, 0) -- Cuma muter kiri kanan (Y axis)
                                    gyro.P = 15000 -- Responsif tapi smooth
                                    gyro.D = 1000  -- Dampening biar ga getar
                                    gyro.Parent = myHrp
                                end
                                local lookPos = Vector3.new(closestTargetPos.X, myPos.Y, closestTargetPos.Z)
                                gyro.CFrame = CFrame.lookAt(myPos, lookPos)
                            else
                                if gyro then gyro:Destroy() end
                            end
                        end)
                    else
                        -- Hapus Gyro kalau lagi gak pegang sekop
                        pcall(function()
                            local myHrp = character:FindFirstChild("HumanoidRootPart")
                            if myHrp then
                                local gyro = myHrp:FindFirstChild("GagAimbot")
                                if gyro then gyro:Destroy() end
                            end
                        end)
                    end
                end
            end)
            task.wait(0.05) -- Swing SUPER CEPAT (2x lebih kencang)
        end
        
        -- Clean up
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local gyro = char.HumanoidRootPart:FindFirstChild("GagAimbot")
                if gyro then gyro:Destroy() end
            end
        end)
        
        autoSwingActive = false
    end)
end

local harvestActive = false
local function startHarvestLoop()
    if harvestActive then return end
    harvestActive = true
    local recentlyHarvested = {}
    
    task.spawn(function()
        while Config.AutoHarvest and _G.GagAutoScriptActive do
            -- Cleanup old harvested records to prevent memory leak
            local now = os.time()
            for key, timestamp in pairs(recentlyHarvested) do
                if now - timestamp > 2 then
                    recentlyHarvested[key] = nil
                end
            end
            
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local myPlot = getMyPlot()
                if myPlot then
                    -- Lite Executor Fix: Gabungkan hasil dari CollectionService dan scan langsung folder Plants di myPlot
                    local prompts = {}
                    local promptSet = {}
                    
                    for _, p in ipairs(CollectionService:GetTagged("HarvestPrompt")) do
                        if p:IsA("ProximityPrompt") and p.Enabled and not promptSet[p] then
                            promptSet[p] = true
                            table.insert(prompts, p)
                        end
                    end
                    
                    local plantsFolder = myPlot:FindFirstChild("Plants")
                    if plantsFolder then
                        for _, p in ipairs(plantsFolder:GetDescendants()) do
                            if p:IsA("ProximityPrompt") and p.Enabled and not promptSet[p] then
                                promptSet[p] = true
                                table.insert(prompts, p)
                            end
                        end
                    end
                    
                    local harvestedThisFrame = 0
                    for _, prompt in ipairs(prompts) do
                        if not Config.AutoHarvest then break end
                        
                        -- Cepat skip prompt yang tidak aktif
                        if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                            local parent = prompt.Parent
                            local model = parent and parent:FindFirstAncestorWhichIsA("Model")
                            
                            -- Cek kepemilikan secepat mungkin
                            if model and model:IsDescendantOf(myPlot) then
                                local isTarget = false
                                local mutationMatch = false
                                
                                local mutation = model:GetAttribute("Mutation") or ""
                                
                                if type(Config.HarvestMutations) == "table" then
                                    if table.find(Config.HarvestMutations, "None") or #Config.HarvestMutations == 0 then
                                        mutationMatch = true
                                    elseif mutation == "" and table.find(Config.HarvestMutations, "Non Mutasi") then
                                        mutationMatch = true
                                    elseif mutation ~= "" and table.find(Config.HarvestMutations, mutation) then
                                        mutationMatch = true
                                    end
                                else
                                    mutationMatch = true
                                end
                                
                                if type(Config.CollectFruits) == "table" then
                                    if table.find(Config.CollectFruits, "None") then
                                        isTarget = false
                                    elseif table.find(Config.CollectFruits, "All") then
                                        isTarget = true
                                    else
                                        -- Tarik atribut hanya jika dibutuhkan
                                        local seedName = model:GetAttribute("SeedName") or ""
                                        local coreName = model:GetAttribute("CorePartName") or ""
                                        local fruitName = model:GetAttribute("FruitName") or ""
                                        local namesToCheck = {seedName, coreName, fruitName}
                                        
                                        for _, targetName in ipairs(Config.CollectFruits) do
                                            local t_lower = string.lower(targetName)
                                            for _, n in ipairs(namesToCheck) do
                                                if n and n ~= "" then
                                                    local n_lower = string.lower(n)
                                                    local n_base = string.gsub(n_lower, "%s+seed$", "")
                                                    if t_lower == n_lower or t_lower == n_base then
                                                        isTarget = true
                                                        break
                                                    end
                                                end
                                            end
                                            if isTarget then break end
                                        end
                                    end
                                end

                                if isTarget and not mutationMatch then
                                    isTarget = false
                                end

                                -- Check weight limit
                                if isTarget and Config.MaxHarvestKg > 0 then
                                    local weightGrams = 0
                                    if FruitVisualizerController then
                                        pcall(function()
                                            weightGrams = FruitVisualizerController:CalculateFruitWeight(model)
                                            if not weightGrams and FruitVisualizerController.CalculatePlantWeight then
                                                weightGrams = FruitVisualizerController:CalculatePlantWeight(model)
                                            end
                                        end)
                                    end
                                    weightGrams = tonumber(weightGrams) or 0
                                    
                                    if weightGrams == 0 then
                                        pcall(function()
                                            local baseName = model:GetAttribute("CorePartName") or model:GetAttribute("SeedName") or ""
                                            baseName = string.gsub(baseName, "%s+[sS]eed$", "")
                                            local sizeMulti = model:GetAttribute("SizeMulti") or 1
                                            local baseWeight = 0
                                            local RS = game:GetService("ReplicatedStorage")
                                            local fruitMod = RS:FindFirstChild("PlantGenerationModules") and RS.PlantGenerationModules:FindFirstChild("Fruits") and RS.PlantGenerationModules.Fruits:FindFirstChild(baseName)
                                            local plantMod = RS:FindFirstChild("PlantGenerationModules") and RS.PlantGenerationModules:FindFirstChild("Plants") and RS.PlantGenerationModules.Plants:FindFirstChild(baseName)
                                            local targetMod = fruitMod or plantMod
                                            
                                            if targetMod then
                                                local req = require(targetMod)
                                                if req and req.GrowData and req.GrowData.BaseWeight then
                                                    baseWeight = req.GrowData.BaseWeight
                                                end
                                            end
                                            
                                            local age = model:GetAttribute("Age") or 100
                                            local maxAge = model:GetAttribute("MaxAge") or 100
                                            local overtime = 1
                                            if age >= maxAge then
                                                local plantedAt = model:GetAttribute("PlantedAt")
                                                if plantedAt then
                                                    overtime = math.max(1, (now - plantedAt) / 3600)
                                                end
                                            end
                                            weightGrams = baseWeight * sizeMulti * overtime
                                        end)
                                    end
                                    
                                    if weightGrams == 0 then weightGrams = 9999999 end
                                    if weightGrams > Config.MaxHarvestKg then isTarget = false end
                                end

                                if isTarget then
                                    local plantId = model:GetAttribute("PlantId")
                                    local fruitId = model:GetAttribute("FruitId") or ""
                                    local harvestKey = tostring(plantId) .. "_" .. tostring(fruitId)
                                    
                                    if plantId and not recentlyHarvested[harvestKey] then
                                        recentlyHarvested[harvestKey] = now
                                        
                                        task.spawn(function()
                                            pcall(function() Networking.Garden.CollectFruit:Fire(plantId, fruitId) end)
                                            -- Menonaktifkan fireproximityprompt karena memicu animasi gamenya yang membuat karakter berhenti (stutter).
                                            -- Remote Networking sudah cukup untuk panen secara instan tanpa jeda gerakan.
                                        end)
                                        
                                        -- Fast Harvest Logic: Batch 5 buah per frame jika delay 0 untuk menghindari lag di Lite Executor
                                        if Config.HarvestDelay > 0 then
                                            task.wait(Config.HarvestDelay)
                                        else
                                            harvestedThisFrame = harvestedThisFrame + 1
                                            if harvestedThisFrame % 30 == 0 then
                                                task.wait()
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    notif("Plot not found! Claim a plot first.", 3, "Auto Harvest")
                    task.wait(2)
                end
            end
            task.wait(0.1)
        end
        harvestActive = false
    end)
end



local plantActive = false
local function getSeedToolByAttribute(seedName)
    local char = LocalPlayer.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool:GetAttribute("SeedTool") == seedName then
                return tool
            end
        end
    end
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool:GetAttribute("SeedTool") == seedName then
                return tool
            end
        end
    end
    return nil
end

local function triggerTrowelOnce()
    task.spawn(function()
        local Networking = Networking or require(game:GetService("ReplicatedStorage").SharedModules.Networking)
        
        local trowelInitialPosition = nil
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            trowelInitialPosition = char.HumanoidRootPart.Position
        end

        local plotId = LocalPlayer:GetAttribute("PlotId")
        if not plotId then return end
        
        local gardens = workspace:FindFirstChild("Gardens")
        local myPlot = gardens and gardens:FindFirstChild("Plot" .. tostring(plotId))
        local plantsFolder = myPlot and myPlot:FindFirstChild("Plants")
        
        if plantsFolder then
            local plants = plantsFolder:GetChildren()
            for _, plant in ipairs(plants) do
                if plant:IsA("Model") then
                    local plantType = plant:GetAttribute("SeedName") or plant.Name
                    
                    local shouldTrowel = false
                    if table.find(Config.TrowelPlants, "All") then
                        shouldTrowel = true
                    elseif table.find(Config.TrowelPlants, plantType) then
                        shouldTrowel = true
                    end
                    
                    if shouldTrowel then
                        local targetPos = nil
                        if Config.TrowelPositionMode == "Player Position" then
                            targetPos = trowelInitialPosition
                        elseif Config.TrowelPositionMode == "Random" then
                            local base = myPlot:FindFirstChild("Base")
                            if base then
                                local rx = math.random(-15, 15)
                                local rz = math.random(-15, 15)
                                targetPos = base.Position + Vector3.new(rx, 3, rz)
                            end
                        end
                        
                        if targetPos then
                            local currentPos = nil
                            if plant.PrimaryPart then
                                currentPos = plant.PrimaryPart.Position
                            else
                                local core = plant:FindFirstChild("Core")
                                if core then currentPos = core.Position end
                            end
                            
                            if currentPos then
                                local dist = (Vector3.new(currentPos.X, 0, currentPos.Z) - Vector3.new(targetPos.X, 0, targetPos.Z)).Magnitude
                                if dist > 2 then
                                    Networking.Trowel.MovePlant:Fire(plant.Name, targetPos, 0)
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function startPlantLoop()
    if plantActive then return end
    plantActive = true
    task.spawn(function()
        while Config.AutoPlant and _G.GagAutoScriptActive do
            local hasValidSeed = false
            for _, s in ipairs(Config.PlantSeedNames) do
                if s ~= "None" then hasValidSeed = true break end
            end
            
            if hasValidSeed then
                local myPlot = getMyPlot()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                
                local seedTool = nil
                local selectedSeedName = nil
                for _, seedName in ipairs(Config.PlantSeedNames) do
                    if seedName ~= "None" then
                        seedTool = getSeedToolByAttribute(seedName)
                        if seedTool then
                            selectedSeedName = seedName
                            break
                        end
                    end
                end
                
                if myPlot and hrp and seedTool and selectedSeedName then
                    local targetPos = nil
                    if Config.PlantLocation == "Player Position" then
                        targetPos = hrp.Position - Vector3.new(0, 2.5, 0)
                    elseif Config.PlantLocation == "Saved Position" and _G.SavedPlantPosition then
                        local origin = _G.SavedPlantPosition
                        local randRadius = math.random() * 3
                        local randAngle = math.random() * math.pi * 2
                        targetPos = origin + Vector3.new(math.cos(randAngle) * randRadius, 0, math.sin(randAngle) * randRadius)
                    else
                        if myPlot:FindFirstChild("Visual") and myPlot.Visual:FindFirstChild("GardenZonePart") then
                            local zone = myPlot.Visual.GardenZonePart
                            local size = zone.Size
                            local cf = zone.CFrame
                            local randX = (math.random() - 0.5) * (size.X * 0.9)
                            local randZ = (math.random() - 0.5) * (size.Z * 0.9)
                            
                            local topPos = (cf * CFrame.new(randX, size.Y/2 + 5, randZ)).Position
                            local rayDir = Vector3.new(0, -size.Y - 50, 0)
                            local hitPos = nil
                            
                            local ignoreList = {LocalPlayer.Character}
                            for i = 1, 20 do
                                local rayParams = RaycastParams.new()
                                rayParams.FilterDescendantsInstances = ignoreList
                                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                                
                                local hit = workspace:Raycast(topPos, rayDir, rayParams)
                                if hit then
                                    local p = hit.Instance
                                    local m = p:FindFirstAncestorWhichIsA("Model")
                                    
                                    local isPlant = false
                                    if m and (m:GetAttribute("PlantId") or m:GetAttribute("SeedName") or m.Name == "Plant" or m.Name == "Seed") then
                                        isPlant = true
                                    end
                                    if p:FindFirstChildOfClass("ProximityPrompt") then
                                        isPlant = true
                                    end
                                    
                                    if isPlant or p.Name == "GardenZonePart" or p.Transparency >= 0.9 then
                                        table.insert(ignoreList, m or p)
                                    else
                                        hitPos = hit.Position
                                        break
                                    end
                                else
                                    break
                                end
                            end
                            
                            if hitPos then
                                targetPos = hitPos
                            else
                                targetPos = (cf * CFrame.new(randX, -size.Y/2 + 0.5, randZ)).Position
                            end
                        end
                    end
                    
                    if targetPos then
                        pcall(function()
                            -- Auto-equip just in case the server requires it
                            if seedTool.Parent ~= char then
                                local humanoid = char:FindFirstChildOfClass("Humanoid")
                                if humanoid then humanoid:EquipTool(seedTool) end
                            end
                            Networking.Plant.PlantSeed:Fire(targetPos, selectedSeedName, seedTool)
                        end)
                        task.wait(Config.PlantDelay)
                    else
                        task.wait(1)
                    end
                else
                    task.wait(2) -- Plot not found or out of seeds
                end
            else
                task.wait(1)
            end
        end
        plantActive = false
    end)
end

local function GetPlantFt(plantModel)
    local plantFt = plantModel:GetAttribute("ESP_PlantFt")
    local labelOffset = plantModel:GetAttribute("ESP_LabelOffset")
    if plantFt then return plantFt, labelOffset end
    
    plantFt = plantModel:GetAttribute("Height")
    labelOffset = 3

    if not plantFt then
        local maxY = -math.huge
        local minY = math.huge
        local hasParts = false

        local excludedParents = {
            Fruits = true,
            FruitSpawnLocations = true
        }

        for _, part in ipairs(plantModel:GetDescendants()) do
            if part:IsA("BasePart") then
                local isExcluded = false
                local currentParent = part.Parent
                
                while currentParent and currentParent ~= plantModel do
                    if excludedParents[currentParent.Name] then
                        isExcluded = true
                        break
                    end
                    currentParent = currentParent.Parent
                end

                if not isExcluded then
                    hasParts = true
                    local topY = (part.CFrame * CFrame.new(0, part.Size.Y / 2, 0)).Position.Y
                    if topY > maxY then maxY = topY end
                    
                    local bottomY = (part.CFrame * CFrame.new(0, -part.Size.Y / 2, 0)).Position.Y
                    if bottomY < minY then minY = bottomY end
                end
            end
        end

        if hasParts then
            plantFt = math.round(maxY - minY)
            labelOffset = (maxY - minY) / 2
        else
            return nil, nil
        end
    else
        pcall(function()
            local _, size = plantModel:GetBoundingBox()
            labelOffset = size.Y / 2
        end)
    end
    plantModel:SetAttribute("ESP_PlantFt", plantFt)
    plantModel:SetAttribute("ESP_LabelOffset", labelOffset)
    return plantFt, labelOffset
end

local shovelActive = false
local function startShovelLoop()
    if shovelActive then return end
    shovelActive = true
    task.spawn(function()
        while Config.AutoShovel and _G.GagAutoScriptActive do
            if #Config.AutoShovelSeeds > 0 and not (Config.AutoShovelSeeds[1] == "None" and #Config.AutoShovelSeeds == 1) then
                local myPlot = getMyPlot()
                if myPlot then
                    local plantsFolder = myPlot:FindFirstChild("Plants")
                    if plantsFolder then
                        for _, plant in ipairs(plantsFolder:GetChildren()) do
                            if not Config.AutoShovel then break end
                            local seedName = plant:GetAttribute("SeedName")
                            if seedName and table.find(Config.AutoShovelSeeds, seedName) then
                                local minFt = tonumber(Config.AutoShovelMinFt) or 0
                                if minFt > 0 then
                                    local pFt, _ = GetPlantFt(plant)
                                    if not pFt then continue end -- Wait until plant fully loads!
                                    if pFt >= minFt then
                                        continue
                                    end
                                end
                                local shovelTool = nil
                                local char = LocalPlayer.Character
                                if char then
                                    for _, t in ipairs(char:GetChildren()) do
                                        if t:IsA("Tool") and t:GetAttribute("Shovel") then shovelTool = t break end
                                    end
                                end
                                if not shovelTool then
                                    for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
                                        if t:IsA("Tool") and t:GetAttribute("Shovel") then shovelTool = t break end
                                    end
                                end
                                
                                if shovelTool then
                                    local shovelAttr = shovelTool:GetAttribute("Shovel")
                                    if shovelAttr then
                                        pcall(function()
                                            local hum = char and char:FindFirstChildOfClass("Humanoid")
                                            if hum and shovelTool.Parent ~= char then
                                                hum:EquipTool(shovelTool)
                                                task.wait(0.1)
                                            end
                                            Networking.Shovel.UseShovel:Fire(plant.Name, "", shovelAttr, shovelTool)
                                        end)
                                    end
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.2)
        end
        shovelActive = false
    end)
end

local shovelFruitActive = false
local function startShovelFruitLoop()
    if shovelFruitActive then return end
    shovelFruitActive = true
    task.spawn(function()
        local RS = game:GetService("ReplicatedStorage")
        local FruitVisualizerController = nil
        pcall(function()
            FruitVisualizerController = require(LocalPlayer.PlayerScripts:WaitForChild("Controllers"):WaitForChild("FruitVisualizerController"))
        end)
        
        local recentlyShoveled = {}
        
        while Config.AutoShovelFruit and _G.GagAutoScriptActive do
            for key, timestamp in pairs(recentlyShoveled) do
                if os.time() - timestamp > 3 then
                    recentlyShoveled[key] = nil
                end
            end
            
            pcall(function()
                local myPlot = getMyPlot()
                if myPlot then
                    local plantsFolder = myPlot:FindFirstChild("Plants")
                    if plantsFolder then
                        local shovelTool = nil
                        
                        for _, plant in ipairs(plantsFolder:GetChildren()) do
                            if not Config.AutoShovelFruit then break end
                            
                            local fruitsFolder = plant:FindFirstChild("Fruits")
                            if fruitsFolder then
                                for _, model in ipairs(fruitsFolder:GetChildren()) do
                                    if not Config.AutoShovelFruit then break end
                                    if not model:IsA("Model") then continue end
                                    
                                    local seedName = model:GetAttribute("SeedName") or ""
                                    local coreName = model:GetAttribute("CorePartName") or ""
                                    local fruitName = model:GetAttribute("FruitName") or ""
                                    
                                    local namesToCheck = {seedName, coreName, fruitName}
                                    local isTarget = false
                                    
                                    if type(Config.AutoShovelFruits) == "table" then
                                        if table.find(Config.AutoShovelFruits, "None") then
                                            isTarget = false
                                        elseif table.find(Config.AutoShovelFruits, "All") then
                                            isTarget = true
                                        else
                                            for _, targetName in ipairs(Config.AutoShovelFruits) do
                                                local t_lower = string.lower(targetName)
                                                for _, n in ipairs(namesToCheck) do
                                                    if n and n ~= "" then
                                                        local n_lower = string.lower(n)
                                                        local n_base = string.gsub(n_lower, "%s+seed$", "")
                                                        if t_lower == n_lower or t_lower == n_base then
                                                            isTarget = true
                                                            break
                                                        end
                                                    end
                                                end
                                                if isTarget then break end
                                            end
                                        end
                                    end

                                    if isTarget then
                                        local weightKg = 0
                                        if FruitVisualizerController then
                                            pcall(function()
                                                weightKg = FruitVisualizerController:CalculateFruitWeight(model)
                                                if not weightKg and FruitVisualizerController.CalculatePlantWeight then
                                                    weightKg = FruitVisualizerController:CalculatePlantWeight(model)
                                                end
                                            end)
                                        end
                                        weightKg = tonumber(weightKg) or 0
                                        
                                        if weightKg == 0 then
                                            pcall(function()
                                                local baseName = model:GetAttribute("CorePartName") or model:GetAttribute("SeedName") or ""
                                                baseName = string.gsub(baseName, "%s+[sS]eed$", "")
                                                local sizeMulti = model:GetAttribute("SizeMulti") or 1
                                                local baseWeight = 0
                                                local fruitMod = RS:FindFirstChild("PlantGenerationModules") and RS.PlantGenerationModules:FindFirstChild("Fruits") and RS.PlantGenerationModules.Fruits:FindFirstChild(baseName)
                                                local plantMod = RS:FindFirstChild("PlantGenerationModules") and RS.PlantGenerationModules:FindFirstChild("Plants") and RS.PlantGenerationModules.Plants:FindFirstChild(baseName)
                                                local targetMod = fruitMod or plantMod
                                                if targetMod then
                                                    local req = require(targetMod)
                                                    if req and req.GrowData and req.GrowData.BaseWeight then
                                                        baseWeight = req.GrowData.BaseWeight
                                                    end
                                                end
                                                local age = model:GetAttribute("Age") or 100
                                                local maxAge = model:GetAttribute("MaxAge") or 100
                                                local overtime = 1
                                                if age >= maxAge then
                                                    overtime = 1 + math.floor((age - maxAge) / 100) * 0.05
                                                end
                                                weightKg = baseWeight * sizeMulti * overtime
                                            end)
                                        end
                                        
                                        local kgLimit = tonumber(Config.AutoShovelFruitKg) or 0
                                        
                                        local shouldShovel = false
                                        if kgLimit <= 0 then
                                            shouldShovel = true
                                        else
                                            if weightKg > 0 and weightKg <= kgLimit then
                                                shouldShovel = true
                                            end
                                        end
                                        
                                        if shouldShovel then
                                            local plantId = model:GetAttribute("PlantId") or (model.Parent and model.Parent.Parent and model.Parent.Parent.Name) or ""
                                            local fruitId = model:GetAttribute("FruitId") or model.Name
                                            local shovelKey = tostring(plantId) .. "_" .. tostring(fruitId)
                                            
                                            if plantId ~= "" and not recentlyShoveled[shovelKey] then
                                                recentlyShoveled[shovelKey] = os.time()
                                                
                                                local char = LocalPlayer.Character
                                                if char and not shovelTool then
                                                    for _, t in ipairs(char:GetChildren()) do
                                                        if t:IsA("Tool") and t:GetAttribute("Shovel") then shovelTool = t break end
                                                    end
                                                    if not shovelTool then
                                                        for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
                                                            if t:IsA("Tool") and t:GetAttribute("Shovel") then shovelTool = t break end
                                                        end
                                                    end
                                                end
                                                
                                                if shovelTool then
                                                    local shovelAttr = shovelTool:GetAttribute("Shovel")
                                                    if shovelAttr then
                                                        pcall(function()
                                                            local hum = char and char:FindFirstChildOfClass("Humanoid")
                                                            if hum and shovelTool.Parent ~= char then
                                                                hum:EquipTool(shovelTool)
                                                                task.wait(0.05)
                                                            end
                                                            
                                                            if Networking and Networking.Shovel and Networking.Shovel.UseShovel then
                                                                Networking.Shovel.UseShovel:Fire(plantId, fruitId, shovelAttr, shovelTool)
                                                            end
                                                        end)
                                                    end
                                                    task.wait()
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
            task.wait(0.2)
        end
        shovelFruitActive = false
    end)
end

local protectActive = false
local function startProtectLoop()
    if protectActive then return end
    protectActive = true
    task.spawn(function()
        local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
        while Config.AutoProtectBase and _G.GagAutoScriptActive do
            pcall(function()
                local myPlot = getMyPlot()
                local myChar = LocalPlayer.Character
                local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local myHum = myChar and myChar:FindFirstChild("Humanoid")
                
                if myPlot and myHrp and myHum and myHum.Health > 0 then
                    local zone = myPlot:FindFirstChild("Visual") and myPlot.Visual:FindFirstChild("GardenZonePart")
                    if zone then
                        local intruder = nil
                        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
                            if p ~= LocalPlayer and p.Character then
                                local targetHrp = p.Character:FindFirstChild("HumanoidRootPart")
                                local targetHum = p.Character:FindFirstChild("Humanoid")
                                if targetHrp and targetHum and targetHum.Health > 0 then
                                    local distToGarden = (targetHrp.Position - zone.Position).Magnitude
                                    if distToGarden < 100 then
                                        local isStealing = p:GetAttribute("IsStealingFruit")
                                        local carrying = p:GetAttribute("CarryingStolenFruit")
                                        -- Optional: also check if they are in our plot based on their PlotId attribute
                                        -- local plotId = p:GetAttribute("PlotId")
                                        if isStealing or carrying then
                                            intruder = p
                                            break
                                        end
                                    end
                                end
                            end
                        end
                        
                        if intruder and intruder.Character and intruder.Character:FindFirstChild("HumanoidRootPart") then
                            local targetHrp = intruder.Character.HumanoidRootPart
                            
                            local shovelTool = nil
                            for _, t in ipairs(myChar:GetChildren()) do
                                if t:IsA("Tool") and t:GetAttribute("Shovel") then shovelTool = t break end
                            end
                            if not shovelTool then
                                for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
                                    if t:IsA("Tool") and t:GetAttribute("Shovel") then shovelTool = t break end
                                end
                            end
                            
                            if shovelTool then
                                if shovelTool.Parent ~= myChar then
                                    myHum:EquipTool(shovelTool)
                                    task.wait(0.2)
                                end
                                
                                -- Face and teleport to intruder
                                local lookPos = Vector3.new(targetHrp.Position.X, myHrp.Position.Y, targetHrp.Position.Z)
                                myHrp.CFrame = CFrame.lookAt(targetHrp.Position + (myHrp.Position - targetHrp.Position).Unit * 3, lookPos)
                                
                                -- Swing
                                local animator = myHum:FindFirstChildOfClass("Animator")
                                if animator then
                                    local anim = Instance.new("Animation")
                                    anim.AnimationId = "rbxassetid://78592768207309"
                                    local track = animator:LoadAnimation(anim)
                                    track.Priority = Enum.AnimationPriority.Action4
                                    track:Play()
                                end
                                
                                Networking.Shovel.SwingShovel:Fire()
                                Networking.Shovel.HitPlayer:Fire(intruder.UserId)
                            end
                        end
                    end
                end
            end)
            task.wait(0.1)
        end
        protectActive = false
    end)
end

local function formatTime(seconds)
    if not seconds then return "Unknown" end
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    return string.format("%02d:%02d:%02d", h, m, s)
end

_G.DailyDealParagraph = nil
local dailyDealCheckerActive = false
local function startDailyDealCheckerLoop()
    if dailyDealCheckerActive then return end
    dailyDealCheckerActive = true
    task.spawn(function()
        local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
        local lastCheck = 0
        local localTimeRemaining = 0
        local isAvailable = false
        
        while _G.GagAutoScriptActive do
            if _G.DailyDealParagraph then
                pcall(function()
                    local now = tick()
                    if now - lastCheck >= 10 or (not isAvailable and localTimeRemaining <= 0) then
                        local data = Networking.NPCS.CheckDailyDeal:Fire()
                        if type(data) == "table" then
                            isAvailable = data.Available
                            localTimeRemaining = data.TimeRemaining or 0
                        elseif data == true then
                            isAvailable = true
                            localTimeRemaining = 0
                        else
                            isAvailable = false
                            localTimeRemaining = 0
                        end
                        lastCheck = now
                    end
                    
                    if isAvailable then
                        _G.DailyDealParagraph:SetContent("AVAILABLE! (5x Multiplier Active)")
                    else
                        _G.DailyDealParagraph:SetContent("Cooldown. Time Remaining: " .. formatTime(localTimeRemaining))
                        if localTimeRemaining > 0 then
                            localTimeRemaining = localTimeRemaining - 1
                        end
                    end
                end)
            end
            task.wait(1)
        end
        dailyDealCheckerActive = false
    end)
end

local function getInventoryFruits()
    local fruits = {}
    local function collectItemsFrom(container, useDescendants)
        if not container then return end
        local items = useDescendants and container:GetDescendants() or container:GetChildren()
        for _, t in ipairs(items) do
            if t:IsA("Tool") or t:IsA("Configuration") then
                local isFruit = t:GetAttribute("HarvestedFruit") == true
                local isInvalidBP = string.find(t.Name, "Seed") or string.find(t.Name, "Sapling") or string.find(t.Name, "Potted")
                if isFruit and not isInvalidBP then
                    local bName = t:GetAttribute("FruitName") or t:GetAttribute("Fruit") or t.Name
                    bName = string.gsub(bName, "%s*%[[%d%.]+kg%]", "")
                
                    local bMut = t:GetAttribute("Mutation") or t:GetAttribute("Variant") or "None"
                    if bMut == "None" then
                        local mutMatch = string.match(t.Name, "%[(%a+)%]")
                        if mutMatch and not string.match(mutMatch, "kg") then
                            bMut = mutMatch
                            bName = string.gsub(bName, "%[%w+%]", ""):match("^%s*(.-)%s*$")
                        end
                    end
                    
                    local kgStr = string.match(t.Name, "%[([%d%.]+)kg%]")
                    local weightAttr = t:GetAttribute("Weight")
                    local bSizeMulti = t:GetAttribute("SizeMulti") or t:GetAttribute("SizeMultiplier")
                    if not bSizeMulti then
                        local smVal = t:FindFirstChild("SizeMulti") or t:FindFirstChild("SizeMultiplier")
                        if smVal and (smVal:IsA("NumberValue") or smVal:IsA("StringValue")) then
                            bSizeMulti = tonumber(smVal.Value)
                        end
                    end
                    
                    local bKg = nil
                    if kgStr then
                        bKg = tonumber(kgStr)
                    elseif weightAttr then
                        bKg = weightAttr
                    elseif bSizeMulti then
                        bKg = 100 * bSizeMulti
                    else
                        bKg = 0
                    end
                    
                    local isFav = t:GetAttribute("IsFavorite") == true
                    local fruitId = t:GetAttribute("Id")
                    if fruitId then
                        table.insert(fruits, {
                            Tool = t,
                            Name = bName,
                            Mut = bMut,
                            Kg = bKg,
                            Id = fruitId,
                            IsFavorite = isFav
                        })
                    end
                end
            end
        end
    end
    collectItemsFrom(LocalPlayer.Backpack, false)
    if LocalPlayer.Character then
        collectItemsFrom(LocalPlayer.Character, true)
    end
    return fruits
end

local autoFavActive = false
local function startAutoFavLoop()
    if autoFavActive then return end
    autoFavActive = true
    task.spawn(function()
        local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
        while Config.AutoFavFruit and _G.GagAutoScriptActive do
            pcall(function()
                local fruits = getInventoryFruits()
                for _, f in ipairs(fruits) do
                    if not f.IsFavorite then
                        local nameMatch = false
                        if not table.find(Config.AutoFavNames, "None") then
                            nameMatch = table.find(Config.AutoFavNames, "All") or table.find(Config.AutoFavNames, f.Name)
                        end
                        
                        local mutMatch = false
                        if not table.find(Config.AutoFavMutations, "None") then
                            mutMatch = table.find(Config.AutoFavMutations, "All") or table.find(Config.AutoFavMutations, f.Mut) or (f.Mut == "None" and table.find(Config.AutoFavMutations, "Non Mutasi"))
                        end
                        
                        if nameMatch and mutMatch and f.Kg >= Config.AutoFavMinKg then
                            Networking.Backpack.SetFruitFavorite:Fire(f.Id, true)
                            task.wait(0.2)
                        end
                    end
                end
            end)
            task.wait(1.5)
        end
        autoFavActive = false
    end)
end

local function getInventoryPets()
    local pets = {}
    local function collectPetsFrom(container, useDescendants)
        if not container then return end
        local items = useDescendants and container:GetDescendants() or container:GetChildren()
        for _, t in ipairs(items) do
            if t:IsA("Tool") or t:IsA("Configuration") then
                local petId = t:GetAttribute("PetId")
                if petId then
                    local pName = t:GetAttribute("PetName") or t.Name
                    table.insert(pets, {
                        Tool = t,
                        Name = pName,
                        Id = petId,
                        IsFavorite = t:GetAttribute("IsFavorite") == true
                    })
                end
            end
        end
    end
    collectPetsFrom(LocalPlayer:FindFirstChild("Backpack"), false)
    if LocalPlayer.Character then collectPetsFrom(LocalPlayer.Character, false) end
    return pets
end

local sellActive = false
local function startSellLoop()
    if sellActive then return end
    sellActive = true
    task.spawn(function()
        local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
        while Config.AutoSell or Config.AutoSellDailyDeal or Config.AutoSellPet do
            if Config.AutoSellDailyDeal then
                pcall(function()
                    local data = Networking.NPCS.CheckDailyDeal:Fire()
                    if (type(data) == "table" and data.Available) or data == true then
                        Networking.NPCS.UseDailyDealAll:Fire()
                        -- Wait a bit after successful deal sell
                        task.wait(2)
                    end
                end)
            end
            
            if Config.AutoSell then
            if Config.SellMode == "Sell All" then
                pcall(function()
                    Networking.NPCS.SellAll:Fire()
                end)
                task.wait(Config.SellAllDelay)
            else
                local bp = LocalPlayer:FindFirstChild("Backpack")
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                
                if hum then
                    local fruits = getInventoryFruits()
                    for _, f in ipairs(fruits) do
                        if not Config.AutoSell then break end
                        
                        local nameMatch = false
                        if not table.find(Config.SellNames, "None") then
                            nameMatch = table.find(Config.SellNames, "All") or table.find(Config.SellNames, f.Name)
                        end
                        
                        local mutMatch = false
                        if not table.find(Config.SellMutations, "None") then
                            mutMatch = table.find(Config.SellMutations, "All") or table.find(Config.SellMutations, f.Mut) or (f.Mut == "None" and table.find(Config.SellMutations, "Non Mutasi"))
                        end
                        
                        local kgMatch = true
                        if Config.SellMaxKg > 0 then
                            kgMatch = f.Kg <= Config.SellMaxKg
                        end
                        
                        if nameMatch and mutMatch and kgMatch then
                            pcall(function()
                                local targetTool = f.Tool
                                if targetTool:IsA("Configuration") then
                                    Networking.Backpack.PromoteFruit:Fire(f.Id)
                                    task.wait(0.1)
                                    targetTool = nil
                                    if bp then
                                        for _, t in ipairs(bp:GetChildren()) do
                                            if t:IsA("Tool") and t:GetAttribute("Id") == f.Id then
                                                targetTool = t
                                                break
                                            end
                                        end
                                    end
                                    if not targetTool and char then
                                        for _, t in ipairs(char:GetChildren()) do
                                            if t:IsA("Tool") and t:GetAttribute("Id") == f.Id then
                                                targetTool = t
                                                break
                                            end
                                        end
                                    end
                                end
                                
                                if targetTool and targetTool:IsA("Tool") then
                                    hum:EquipTool(targetTool)
                                    task.wait(0.05)
                                    Networking.NPCS.SellFruit:Fire(f.Id)
                                    task.wait(0.05)
                                end
                            end)
                        end
                    end
                end
                task.wait(0.5)
            end
            
            end -- Close if Config.AutoSell then
            
            if Config.AutoSellPet then
                local bp = LocalPlayer:FindFirstChild("Backpack")
                local char = LocalPlayer.Character
                if bp or char then
                    local pets = getInventoryPets()
                    for _, p in ipairs(pets) do
                        if not Config.AutoSellPet then break end
                        if p.IsFavorite then continue end
                        local nameMatch = false
                        if Config.SellPets and not table.find(Config.SellPets, "None") then
                            nameMatch = table.find(Config.SellPets, "All") or table.find(Config.SellPets, p.Name)
                        end
                        if nameMatch then
                            pcall(function()
                                Networking.NPCS.SellPet:Fire(p.Id)
                            end)
                            task.wait(0.1)
                        end
                    end
                end
            end
            
            task.wait(0.5)
        end
        sellActive = false
    end)
end

local function getStolenFruitCount()
    local char = LocalPlayer.Character
    if not char then return 0 end
    local count = 0
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChild("FruitAnchor") then
            count = count + 1
        end
    end
    return count
end

local stealActive = false
local function startStealLoop()
    if stealActive then return end
    stealActive = true
    task.spawn(function()
        local currentStealPlot = nil
        
        while Config.AutoSteal do
            local nightObj = game.ReplicatedStorage:FindFirstChild("Night")
            if nightObj and nightObj.Value == true then
                local prompts = CollectionService:GetTagged("StealPrompt")
                local stoleSomethingThisTick = false
                
                -- NEW LOGIC: Lock onto the first valid plot we find in this cycle
                local targetPlot = nil
                
                for _, prompt in ipairs(prompts) do
                    if not Config.AutoSteal then break end
                    if getStolenFruitCount() >= Config.MaxSteal then break end
                    
                    if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                        local model = prompt.Parent and prompt.Parent:FindFirstAncestorWhichIsA("Model")
                        if model then
                            local userId = tonumber(model:GetAttribute("UserId"))
                            local plantId = model:GetAttribute("PlantId")
                            local fruitId = model:GetAttribute("FruitId") or ""
                            
                            if userId and userId ~= LocalPlayer.UserId and plantId then
                                local plotName = nil
                                local current = model
                                while current and current.Parent do
                                    if current.Parent.Name == "Gardens" then
                                        plotName = current.Name
                                        break
                                    end
                                    current = current.Parent
                                end
                                
                                local isAway = false
                                if plotName then
                                    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                                    local plotGui = playerGui and playerGui:FindFirstChild(plotName)
                                    if plotGui then
                                        local playerFrame = plotGui:FindFirstChild("PlayerFrame")
                                        if playerFrame then
                                            local topText = playerFrame:FindFirstChild("toptext") or playerFrame:FindFirstChild("TopText")
                                            if topText and topText.Visible == true then
                                                isAway = true
                                            end
                                        end
                                    end
                                end
                                
                                if isAway then
                                    if targetPlot == nil then
                                        targetPlot = plotName
                                        currentStealPlot = plotName
                                    end
                                    
                                    if targetPlot == plotName then
                                        local char = LocalPlayer.Character
                                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                                        
                                        if hrp then
                                            tweenTeleport(hrp, (model:GetPivot() + Vector3.new(0, 3, 0)).Position)
                                        end
                                        
                                        pcall(function()
                                            Networking.Steal.BeginSteal:Fire(userId, plantId, fruitId)
                                            Networking.Steal.CompleteSteal:Fire()
                                        end)
                                        
                                        stoleSomethingThisTick = true
                                        task.wait(Config.StealDelay)
                                    end
                                end
                            end
                        end
                    end
                end
                
                if getStolenFruitCount() >= Config.MaxSteal then
                    local myPlot = getMyPlot()
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if myPlot and hrp and currentStealPlot ~= nil then
                        if myPlot:FindFirstChild("Visual") and myPlot.Visual:FindFirstChild("GardenZonePart") then
                            tweenTeleport(hrp, (myPlot.Visual.GardenZonePart.CFrame + Vector3.new(0, 5, 0)).Position)
                        end
                    end
                    currentStealPlot = nil
                    notif("Stolen " .. tostring(Config.MaxSteal) .. " fruits. Depositing at base...", 3, "Steal")
                    
                    task.wait(2) -- Wait for deposit to process
                elseif not stoleSomethingThisTick and currentStealPlot ~= nil then
                    -- Plot is now empty or owner returned, return to base
                    local myPlot = getMyPlot()
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if myPlot and hrp then
                        if myPlot:FindFirstChild("Visual") and myPlot.Visual:FindFirstChild("GardenZonePart") then
                            tweenTeleport(hrp, (myPlot.Visual.GardenZonePart.CFrame + Vector3.new(0, 5, 0)).Position)
                        end
                    end
                    currentStealPlot = nil
                end
            else
                if currentStealPlot ~= nil then
                    local myPlot = getMyPlot()
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if myPlot and hrp then
                        if myPlot:FindFirstChild("Visual") and myPlot.Visual:FindFirstChild("GardenZonePart") then
                            tweenTeleport(hrp, (myPlot.Visual.GardenZonePart.CFrame + Vector3.new(0, 5, 0)).Position)
                        end
                    end
                    currentStealPlot = nil
                end
                task.wait(2)
            end
            task.wait(1)
        end
        stealActive = false
    end)
end

local buyActive = false
local function startBuyLoop()
    if buyActive then return end
    buyActive = true
    task.spawn(function()
        while Config.AutoBuySeed or Config.AutoBuyGear or Config.AutoBuyProp do
            if Config.AutoBuySeed then
                for _, item in ipairs(Config.SeedToBuy) do
                    if item ~= "None" and isItemInShop("SeedShop", item) then
                        pcall(function() Networking.SeedShop.PurchaseSeed:Fire(item) end)
                        task.wait(0.05)
                    end
                end
            end
            if Config.AutoBuyGear then
                for _, item in ipairs(Config.GearToBuy) do
                    if item ~= "None" and isItemInShop("GearShop", item) then
                        pcall(function() Networking.GearShop.PurchaseGear:Fire(item) end)
                        task.wait(0.05)
                    end
                end
            end
            if Config.AutoBuyProp then
                for _, item in ipairs(Config.PropToBuy) do
                    if item ~= "None" then
                        -- Check CrateShop or PropShop stock
                        if isItemInShop("CrateShop", item) or isItemInShop("PropShop", item) or isItemInShop("GearShop", item) then
                            pcall(function() 
                                if Networking.CrateShop then
                                    Networking.CrateShop.PurchaseCrate:Fire(item) 
                                elseif Networking.PropShop then
                                    Networking.PropShop.PurchaseProp:Fire(item)
                                else
                                    Networking.GearShop.PurchaseGear:Fire(item)
                                end
                            end)
                            task.wait(0.05)
                        end
                    end
                end
            end
            task.wait(0.5)
        end
        buyActive = false
    end)
end

local tameActive = false
local function startTameLoop()
    if tameActive then return end
    tameActive = true
    task.spawn(function()
        local wildPetRef = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("WildPetRef")
        local Net = Networking or require(game:GetService("ReplicatedStorage").SharedModules.Networking)
        
        local isTamingBusy = false

        -- ══════════════════════════════════════════════════════════════
        -- TRUE INSTANT TELEPORT & FRAME-SPAM ACQUISITION
        -- Rahasia kenapa player lain bisa "instant teleport dan langsung beli":
        -- 1. Teleportasi dilakukan INSTAN 1 frame (tanpa step/blink/lerp lambat).
        -- 2. Remote pembelian (WildPetTame:Fire) ditembakkan SETIAP FRAME (16ms via Heartbeat)
        --    tanpa jeda/wait artificial (seperti wait 0.5s atau polling lambat).
        -- 
        -- Ketika CFrame diubah instan di client, engine Roblox mengirim paket fisika (UDP)
        -- ke server yang memakan waktu sebesar ping jaringan (~30-60ms).
        -- Karena remote ditembakkan setiap frame tanpa henti, tepat pada milidetik ke-30..60
        -- saat server menerima paket UDP posisi kamu, remote frame tersebut LANGSUNG 
        -- memvalidasi jarakmu yang sudah di dekat pet dan mengesahkan kepemilikan pet INSTAN!
        -- ══════════════════════════════════════════════════════════════
        local function TamePet(petPart)
            if not Config.AutoTamePet then return end
            if not petPart:IsA("BasePart") then return end
            if isTamingBusy then return end
            
            local petName = petPart:GetAttribute("PetName")
            if petName and (table.find(Config.TamePets, "All") or table.find(Config.TamePets, petName)) then
                isTamingBusy = true

                -- ═══════════════════════════════════════════════════════════
                -- STEP-TELEPORT & INSTANT PET ANCHOR SNAP (BYPASS SERVER VALIDATION)
                -- ═══════════════════════════════════════════════════════════
                -- KUNCI BYPASS: Server menolak pembelian pet (WildPetTame) jika "pet yang kita bawa"
                -- (equipped pets / pet anchor di server) belum sampai di lokasi kita!
                -- Dengan menembakkan remote Net.Pets.SnapPets:Fire(pos) saat kita bergerak/teleport,
                -- server langsung me-teleportasi pet kita ke titik tujuan (0ms travel delay!),
                -- sehingga server langsung memvalidasi kehadiran kita dan menyetujui pembelian INSTAN!
                local function snapPetsToServer(pos)
                    pcall(function()
                        local Controllers = LocalPlayer:FindFirstChild("PlayerScripts") and LocalPlayer.PlayerScripts:FindFirstChild("Controllers")
                        if Controllers then
                            local PetVisualController = require(Controllers:FindFirstChild("PetVisualController"))
                            if PetVisualController and PetVisualController.SnapLocalPetsToFollow then
                                PetVisualController:SnapLocalPetsToFollow()
                            end
                        end
                        Net.Pets.SnapPets:Fire(pos)
                    end)
                end

                local function safeTeleport(hrp, targetPos)
                    tweenTeleport(hrp, targetPos)
                    snapPetsToServer(targetPos)
                end

                while petPart and petPart.Parent and Config.AutoTamePet do
                    local currentPrice = petPart:GetAttribute("Price") or 0
                    if currentPrice > (Config.MaxTamePrice or math.huge) and petPart:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId then
                        break -- Give up on this pet if it's too expensive, so we can tame others
                    end

                    if petPart:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId then
                        local char = LocalPlayer.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            while petPart and petPart.Parent and petPart:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId do
                                if not Config.AutoTamePet then break end
                                
                                local currentPrice = petPart:GetAttribute("Price") or 0
                                if currentPrice > (Config.MaxTamePrice or math.huge) then
                                    break
                                end

                                local targetPos = petPart.Position + Vector3.new(0, 3, 0)
                                local dist = (hrp.Position - targetPos).Magnitude
                                removeBodyVelocity(hrp)

                                -- TWEEN with live destination update
                                local TweenService = game:GetService("TweenService")
                                local duration = math.max(dist / 24, 0.3)
                                local rot = hrp.CFrame - hrp.CFrame.Position
                                local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = CFrame.new(petPart.Position + Vector3.new(0, 3, 0)) * rot})
                                tween:Play()

                                local tweenStart = os.clock()
                                while os.clock() - tweenStart < duration do
                                    if not Config.AutoTamePet then break end
                                    if not petPart or not petPart.Parent then break end
                                    if petPart:GetAttribute("OwnerUserId") == LocalPlayer.UserId then break end
                                    local price = petPart:GetAttribute("Price") or 0
                                    if price > (Config.MaxTamePrice or math.huge) then break end

                                    local newTarget = CFrame.new(petPart.Position + Vector3.new(0, 3, 0)) * rot
                                    pcall(function() tween:Cancel() end)
                                    local elapsed = os.clock() - tweenStart
                                    local remaining = math.max(duration - elapsed, 0.1)
                                    tween = TweenService:Create(hrp, TweenInfo.new(remaining, Enum.EasingStyle.Linear), {CFrame = newTarget})
                                    tween:Play()

                                    pcall(function() Net.Pets.WildPetTame:Fire(petPart) end)
                                    task.wait(0.2)
                                end
                                tween:Cancel()
                                break
                            end
                        end
                    end

                    -- Setelah pet berhasil dibeli (OwnerUserId == LocalPlayer.UserId)
                    local currentOwner = petPart:GetAttribute("OwnerUserId")
                    if currentOwner == LocalPlayer.UserId then
                        -- Jika fitur Protect Wild Pet diaktifkan, lindungi pet dengan auto shovel
                        if Config.ProtectWildPet then
                            _G.ProtectSwingActive = true
                            startAutoSwingShovelLoop()

                            while petPart and petPart.Parent and petPart:GetAttribute("OwnerUserId") == LocalPlayer.UserId and Config.AutoTamePet and Config.ProtectWildPet do
                                local char = LocalPlayer.Character
                                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    if (hrp.Position - petPart.Position).Magnitude > 15 then
                                        safeTeleport(hrp, petPart.Position + Vector3.new(0, 3, 0))
                                    else
                                        hrp.AssemblyLinearVelocity = Vector3.zero
                                        hrp.AssemblyAngularVelocity = Vector3.zero
                                    end
                                end
                                task.wait(0.5)
                            end

                            if protectHeartbeat then protectHeartbeat:Disconnect(); protectHeartbeat = nil end
                            _G.ProtectSwingActive = false
                        end

                        -- CRITICAL FIX: Keluar dari outer loop saat pet sudah dibeli!
                        break
                    end
                    
                    -- Safety yield
                    task.wait(0.1)
                end
                
                -- Selesai urusan dengan pet ini, buka kunci untuk pet lain
                isTamingBusy = false
            end
        end

        -- 1. Tangkap pet yang baru spawn (0ms reaction time!)
        local connection
        if wildPetRef then
            connection = wildPetRef.ChildAdded:Connect(function(petPart)
                if Config.AutoTamePet then
                    task.spawn(TamePet, petPart)
                end
            end)
        end

        -- 2. Loop untuk mengecek pet yang sudah ada
        while Config.AutoTamePet do
            local hasValidPet = false
            for _, p in ipairs(Config.TamePets) do
                if p ~= "None" then hasValidPet = true break end
            end

            if hasValidPet and wildPetRef then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local pets = {}
                for _, petPart in ipairs(wildPetRef:GetChildren()) do
                    if petPart:IsA("BasePart") and petPart:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId then
                        local petName = petPart:GetAttribute("PetName")
                        if petName and (table.find(Config.TamePets, "All") or table.find(Config.TamePets, petName)) then
                            local price = petPart:GetAttribute("Price") or 0
                            if price <= (Config.MaxTamePrice or math.huge) then
                                local dist = hrp and (hrp.Position - petPart.Position).Magnitude or math.huge
                                table.insert(pets, {part = petPart, dist = dist})
                            end
                        end
                    end
                end
                table.sort(pets, function(a, b) return a.dist < b.dist end)
                for _, entry in ipairs(pets) do
                    if not Config.AutoTamePet then break end
                    TamePet(entry.part)
                end
            end
            task.wait(0.5) -- Loop ini hanya backup, tangkapan utama ada di ChildAdded
        end
        
        if connection then connection:Disconnect() end
        _G.ProtectSwingActive = false
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                    humanoid.AutoRotate = true
                end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    local gyro = hrp:FindFirstChild("GagAimbot")
                    if gyro then gyro:Destroy() end
                end
            end
            local cam = workspace.CurrentCamera
            if cam and cam.CameraType == Enum.CameraType.Scriptable then
                cam.CameraType = Enum.CameraType.Custom
            end
        end)
        tameActive = false
    end)
end

local function instantClaimSeedpack(item)
    if not Config.AutoClaim or not table.find(Config.AutoClaimTypes, "Seedpack") then return end
    if item:GetAttribute("NapoClaiming") then return end
    item:SetAttribute("NapoClaiming", true)
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Tunggu sedetik kalau partnya belum dimuat client
    local targetPart = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true)
    if not targetPart then
        task.wait(0.05)
        targetPart = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true)
    end
    
    if targetPart then
        local originalCFrame = hrp.CFrame
        tweenTeleport(hrp, targetPart.CFrame.Position)
        hrp.Velocity = Vector3.new(0,0,0)
        
        -- Bypass instan ke server
        pcall(function() Networking.SeedPack.ClickPack:Fire(item.Name) end)
        
        -- Coba proxy prompt juga
        task.spawn(function()
            local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
            if not prompt then task.wait(0.1); prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true) end
            if prompt then
                pcall(function()
                    if not prompt.Enabled then prompt.Enabled = true end
                    fireproximityprompt(prompt)
                end)
            end
        end)
        
        -- Tidak perlu balik posisi agar karakter tidak terasa maju-mundur (rollback)
    else
        pcall(function() Networking.SeedPack.ClickPack:Fire(item.Name) end)
    end
    
    -- Fallback jika gagal instant claim, biar loop normal bisa ambil alih
    task.delay(5, function()
        if item and item.Parent then item:SetAttribute("NapoClaiming", nil) end
    end)
end

task.spawn(function()
    local mapFolder = workspace:WaitForChild("Map", 10)
    if mapFolder then
        local seedSpawns = mapFolder:WaitForChild("SeedPackSpawnServerLocations", 10)
        if seedSpawns then
            seedSpawns.ChildAdded:Connect(instantClaimSeedpack)
            -- Untuk yang sudah ada pas execute
            for _, child in ipairs(seedSpawns:GetChildren()) do
                task.spawn(instantClaimSeedpack, child)
            end
        end
    end
end)

local claimActive = false
local function startClaimLoop()
    if claimActive then return end
    claimActive = true
    task.spawn(function()
        local didAnyTeleport = false
        while Config.AutoClaim do
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local itemsToClaim = {}

                -- Scan for known drop folders including Map locations
                local dropFolders = {}
                local function addFolder(folder)
                    if folder then table.insert(dropFolders, folder) end
                end

                addFolder(workspace:FindFirstChild("Drops"))
                addFolder(workspace:FindFirstChild("DroppedItems"))
                addFolder(workspace:FindFirstChild("Items"))
                addFolder(workspace:FindFirstChild("Debris"))
                addFolder(workspace:FindFirstChild("Temporary"))
                
                local mapFolder = workspace:FindFirstChild("Map")
                if mapFolder then
                    addFolder(mapFolder:FindFirstChild("SeedPackSpawnServerLocations"))
                    addFolder(mapFolder:FindFirstChild("WildPets"))
                end

                for _, f in ipairs(dropFolders) do
                    if f then
                        for _, item in ipairs(f:GetChildren()) do
                            table.insert(itemsToClaim, item)
                        end
                    end
                end
                
                -- Fallback: Scan direct workspace children
                for _, v in ipairs(workspace:GetChildren()) do
                    local name = string.lower(v.Name)
                    if string.find(name, "drop") or string.find(name, "seed") or string.find(name, "fruit") or string.find(name, "pet") then
                        if v.Parent == workspace then
                            table.insert(itemsToClaim, v)
                        end
                    end
                end
                
                -- === DEBUG: Khusus scan SeedPackSpawnServerLocations ===
                local seedFolder = mapFolder and mapFolder:FindFirstChild("SeedPackSpawnServerLocations")
                if seedFolder then
                    local seedChildren = seedFolder:GetChildren()
                    for i, child in ipairs(seedChildren) do
                        local promptCount = 0
                        for _, desc in ipairs(child:GetDescendants()) do
                            if desc:IsA("ProximityPrompt") then promptCount = promptCount + 1 end
                        end
                    end
                else
                end


                local originalCFrame = hrp.CFrame

                local validItems = {}
                for _, item in ipairs(itemsToClaim) do
                    if not Config.AutoClaim then break end
                    if item:GetAttribute("NapoClaiming") then continue end
                    
                    local parentName = item.Parent and item.Parent.Name or ""
                    local itemNameLower = string.lower(item.Name)
                    local itemCategory = tostring(item:GetAttribute("ItemCategory") or "")
                    
                    local isSeedpack = (parentName == "SeedPackSpawnServerLocations") or string.find(itemNameLower, "seedpack") or (itemCategory == "Seedpack") or (itemCategory == "Seedpacks")
                    local isPetItem = (parentName == "WildPets") or (item:GetAttribute("PetId") ~= nil) or string.find(itemNameLower, "pet") or (itemCategory == "Pet") or (itemCategory == "Pets")
                    local isGenericItem = not isSeedpack and not isPetItem
                    
                    local shouldClaim = false
                    if isSeedpack and table.find(Config.AutoClaimTypes, "Seedpack") then shouldClaim = true end
                    if isPetItem and table.find(Config.AutoClaimTypes, "Pet Items") then shouldClaim = true end
                    if isGenericItem and table.find(Config.AutoClaimTypes, "Items") then shouldClaim = true end
                    
                    if shouldClaim then
                        table.insert(validItems, item)
                    end
                end

                local function getItemPosition(itm)
                    if itm:IsA("BasePart") then return itm.Position end
                    local p = itm:FindFirstChildWhichIsA("BasePart", true)
                    return p and p.Position or nil
                end

                table.sort(validItems, function(a, b)
                    local posA = getItemPosition(a)
                    local posB = getItemPosition(b)
                    if not posA then return false end
                    if not posB then return true end
                    return (hrp.Position - posA).Magnitude < (hrp.Position - posB).Magnitude
                end)
                
                if #validItems == 0 and didAnyTeleport then
                    didAnyTeleport = false
                    pcall(function()
                        local Event = game:GetService("ReplicatedStorage").SharedModules.Packet.RemoteEvent
                        Event:FireServer(
                            (function(bytes)
                                local b = buffer.create(#bytes)
                                for i = 1, #bytes do
                                    buffer.writeu8(b, i - 1, bytes[i])
                                end
                                return b
                            end)({ 18, 0, 6, 71, 97, 114, 100, 101, 110, 112, 0, 192, 151, 200, 67, 6, 129, 18, 67, 8, 172, 3, 195 })
                        )
                    end)
                    task.wait(1)
                end

                for _, item in ipairs(validItems) do
                    item:SetAttribute("NapoClaiming", true)
                    task.delay(5, function()
                        if item and item.Parent then item:SetAttribute("NapoClaiming", nil) end
                    end)
                    local parentName = item.Parent and item.Parent.Name or ""
                    
                    -- Khusus untuk Seed Pack Spawns: claim SEMUA yang ada di folder ini
                    if parentName == "SeedPackSpawnServerLocations" then
                        
                        -- Cari ProximityPrompt di dalam part (juga cek children langsung)
                        local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
                        -- Juga cek children langsung
                        if not prompt then
                            for _, child in ipairs(item:GetChildren()) do
                                if child:IsA("ProximityPrompt") then
                                    prompt = child
                                    break
                                end
                            end
                        end
                        
                        if prompt then
                        end
                        
                        local targetPart = nil
                        if item:IsA("BasePart") then
                            targetPart = item
                        else
                            targetPart = item:FindFirstChildWhichIsA("BasePart", true)
                        end
                        
                        
                        if targetPart then
                            didAnyTeleport = true
                            tweenTeleport(hrp, targetPart.CFrame.Position)
                            
                            local attempt = 0
                            -- Wait up to 3 seconds (200 * 0.015s) for the item to be claimed and destroyed
                            while item:IsDescendantOf(workspace) and attempt < 200 do
                                attempt = attempt + 1
                                hrp.Velocity = Vector3.new(0,0,0)
                                
                                -- Tembak ProximityPrompt (Sangat penting karena server gamenya wajib menerima signal ini)
                                if prompt then
                                    pcall(function()
                                        if not prompt.Enabled then prompt.Enabled = true end
                                        fireproximityprompt(prompt)
                                    end)
                                end
                                
                                -- Tembak Remote ClickPack (Sebagai backup brutal)
                                pcall(function()
                                    Networking.SeedPack.ClickPack:Fire(item.Name)
                                    local seedPackName = item:GetAttribute("SeedPack")
                                    if seedPackName then
                                        Networking.SeedPack.ClickPack:Fire(seedPackName)
                                    end
                                end)
                                
                                -- Touch semua BasePart yang punya TouchTransmitter
                                for _, desc in ipairs(item:GetDescendants()) do
                                    if desc:IsA("BasePart") and desc:FindFirstChildOfClass("TouchTransmitter") then
                                        pcall(function()
                                            firetouchinterest(hrp, desc, 0)
                                            firetouchinterest(hrp, desc, 1)
                                        end)
                                    end
                                end
                                
                                task.wait()
                            end
                        else
                            pcall(function()
                                Networking.SeedPack.ClickPack:Fire(item.Name)
                            end)
                        end
                        continue
                    end
                    
                    -- Specific logic for Wild Pets (Hanya beli jika Auto Buy Wild Pet aktif & harga memenuhi limit)
                    if parentName == "WildPets" or item:GetAttribute("PetId") then
                        if Config.AutoTamePet then
                            local petName = item:GetAttribute("PetName")
                            local currentPrice = item:GetAttribute("Price") or 0
                            if petName and (table.find(Config.TamePets, "All") or table.find(Config.TamePets, petName)) and currentPrice <= (Config.MaxTamePrice or math.huge) and item:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId then
                                pcall(function()
                                    Networking.Pets.WildPetTame:Fire(item)
                                end)
                            end
                        end
                        continue
                    end
                    
                    local partsToTouch = {}
                    local promptsToFire = {}
                    local targetPart = nil
                    
                    if item:IsA("BasePart") then targetPart = item end
                    
                    -- Check for specific Collect events (like Sheckles)
                    local collectEvent = item:FindFirstChild("Collect")
                    if collectEvent then
                        if collectEvent:IsA("RemoteEvent") then
                            collectEvent:FireServer()
                        elseif collectEvent:IsA("BindableEvent") then
                            collectEvent:Fire()
                        elseif collectEvent:IsA("ProximityPrompt") then
                            table.insert(promptsToFire, collectEvent)
                            targetPart = collectEvent.Parent
                        end
                    end
                    
                    for _, part in ipairs(item:GetDescendants()) do
                        if part:IsA("BasePart") and part:FindFirstChildOfClass("TouchTransmitter") then
                            table.insert(partsToTouch, part)
                        elseif part:IsA("ProximityPrompt") then
                            local tags = CollectionService:GetTags(part)
                            if not table.find(tags, "HarvestPrompt") and not table.find(tags, "StealPrompt") then
                                table.insert(promptsToFire, part)
                            end
                        end
                    end
                    
                    if item.Parent and (item.Parent.Name == "DroppedItems" or item.Parent.Name == "Drops") then
                        pcall(function()
                            Networking.DroppedItem.RequestPickup:Fire(item.Name)
                        end)
                    end
                    
                    if #partsToTouch > 0 or #promptsToFire > 0 or (item.Parent and item.Parent.Name == "DroppedItems") then
                        local targetPart = partsToTouch[1]
                        if not targetPart and #promptsToFire > 0 then
                            local p = promptsToFire[1]
                            if p.Parent and p.Parent:IsA("BasePart") then
                                targetPart = p.Parent
                            elseif p.Parent and p.Parent:IsA("Attachment") and p.Parent.Parent and p.Parent.Parent:IsA("BasePart") then
                                targetPart = p.Parent.Parent
                            end
                        end
                        if not targetPart and item:IsA("Model") and item.PrimaryPart then
                            targetPart = item.PrimaryPart
                        end
                        if not targetPart then
                            targetPart = item:FindFirstChildWhichIsA("BasePart", true)
                        end
                        if targetPart and targetPart:IsA("BasePart") then
                            local dist = (hrp.Position - targetPart.Position).Magnitude
                            
                            if dist > 12 then
                                didAnyTeleport = true
                                tweenTeleport(hrp, targetPart.CFrame.Position)
                            end
                            
                            local attempt = 0
                            -- Wait up to 5 seconds (50 * 0.1s) for the item to be claimed and destroyed
                            while item:IsDescendantOf(workspace) and attempt < 50 do
                                attempt = attempt + 1
                                hrp.Velocity = Vector3.new(0,0,0)
                                
                                for _, p in ipairs(partsToTouch) do
                                    pcall(function()
                                        firetouchinterest(hrp, p, 0)
                                        firetouchinterest(hrp, p, 1)
                                    end)
                                end
                                for _, p in ipairs(promptsToFire) do
                                    pcall(function()
                                        if not p.Enabled then p.Enabled = true end
                                        fireproximityprompt(p)
                                    end)
                                end
                                task.wait(0.1)
                            end
                        end
                    end
                    -- Keluar dari loop for setelah mengambil SATU item terdekat
                    -- Ini memastikan iterasi selanjutnya akan mencari item terdekat dari POSISI BARU karakter
                    break
                end

                -- Hapus fitur balik ke posisi awal agar tidak terasa seperti rollback
            end
            task.wait()
        end
        claimActive = false
    end)
end



local tradeActive = false
local function startTradeLoop()
    if tradeActive then return end
    tradeActive = true
    task.spawn(function()
        local u2_types = {
            Fruit = "HarvestedFruits", Crate = "Crates", Gnome = "Gnomes", 
            Mushroom = "Mushrooms", Sprinkler = "Sprinklers", WateringCan = "WateringCans",
            HarvestedFruit = "HarvestedFruits", SeedTool = "Seeds",
            Teleporter = "Teleporters", Magnet = "Magnets", Wheelbarrow = "Wheelbarrows",
            Trowel = "Trowels", Crowbar = "Crowbars", Ladder = "Ladders",
            FreezeRay = "FreezeRays", PowerHose = "PowerHoses", Rake = "Rakes",
            Lantern = "Lanterns", Sign = "Signs", EmptyPot = "EmptyPots",
            Flashbang = "Flashbangs", Bird = "Birds", Bench = "Benches",
            Light = "Lights", Fence = "Fences"
        }
        local tradedCount = 0
        while Config.AutoTrade do
            task.wait(0.5) -- Jeda aman agar tidak pernah freeze
            
            if Config.TradeTarget and Config.TradeTarget ~= "" and Config.TradeItem and Config.TradeItem ~= "" then
                local targetPlayer = Players:FindFirstChild(Config.TradeTarget)
                if targetPlayer then
                    local maxAmount = Config.TradeAmount or 0
                    if maxAmount > 0 and tradedCount >= maxAmount then
                        Config.AutoTrade = false
                        notif("Trade amount reached. Auto Trade stopped.", 5, "Trade")
                        break
                    end
                    
                    local char = LocalPlayer.Character
                    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                    local targetTool = nil
                    
                    -- Cari item apa saja yang namanya cocok atau isi attribute-nya cocok
                    local function checkTool(item)
                        local tradeName = string.lower(Config.TradeItem)
                        local isMatch = false
                        
                        -- Cek dari Nama Item
                        if string.find(string.lower(item.Name), tradeName) then
                            isMatch = true
                        end
                        
                        -- Cek dari isi Attribute (seperti attribute "Fruit" yang isinya "Tomato")
                        if not isMatch then
                            for attrKey, _ in pairs(u2_types) do
                                local val = item:GetAttribute(attrKey)
                                if type(val) == "string" and string.find(string.lower(val), tradeName) then
                                    isMatch = true
                                    break
                                end
                            end
                        end
                        
                        if isMatch then
                            if item:GetAttribute("Id") ~= nil then
                                for attrKey, _ in pairs(u2_types) do
                                    if item:GetAttribute(attrKey) ~= nil then
                                        return item
                                    end
                                end
                            end
                        end
                        return nil
                    end
                    
                    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                        targetTool = checkTool(tool)
                        if targetTool then break end
                    end
                    
                    if not targetTool and char then
                        for _, tool in ipairs(char:GetChildren()) do
                            targetTool = checkTool(tool)
                            if targetTool then break end
                        end
                    end
                    
                    if targetTool then
                        local itemType, itemUuid
                        for attrKey, typeName in pairs(u2_types) do
                            local attrVal = targetTool:GetAttribute(attrKey)
                            if attrVal then
                                local idVal = targetTool:GetAttribute("Id")
                                if idVal ~= nil then 
                                    itemUuid = tostring(idVal)
                                else 
                                    itemUuid = targetTool.Name 
                                end
                                itemType = typeName
                                break
                            end
                        end
                        
                        if not targetTool:IsA("Tool") and itemUuid then
                            task.spawn(function()
                                pcall(function()
                                    local Networking = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Networking"))
                                    Networking.Backpack.PromoteFruit:Fire(itemUuid)
                                end)
                            end)
                            task.wait(1) -- Tunggu server mengubah item menjadi Tool
                        elseif targetTool:IsA("Tool") and humanoid and targetTool.Parent == LocalPlayer.Backpack then
                            pcall(function() humanoid:EquipTool(targetTool) end)
                            task.wait(0.2)
                        end
                        
                        if itemType and itemUuid then
                            local tradeResponse = nil
                            local conn
                            
                            pcall(function()
                                conn = Networking.Gifting.Response.OnClientEvent:Connect(function(status)
                                    tradeResponse = status
                                end)
                            end)
                            
                            pcall(function()
                                Networking.Gifting.Send:Fire(targetPlayer.UserId, itemType, itemUuid)
                            end)
                            
                            local waitTime = 0
                            while waitTime < 35 do
                                if tradeResponse ~= nil then
                                    break
                                end
                                if not targetTool or (targetTool.Parent ~= LocalPlayer.Backpack and targetTool.Parent ~= char) then
                                    tradeResponse = true
                                    break
                                end
                                if not Config.AutoTrade then break end
                                task.wait(0.5)
                                waitTime = waitTime + 0.5
                            end
                            
                            if conn then pcall(function() conn:Disconnect() end) end
                            
                            if tradeResponse == true then
                                tradedCount = tradedCount + 1
                                task.wait(2.5)
                            else
                                local reason = tradeResponse == false and "ditolak" or "diabaikan"
                                notif("Trade " .. reason .. " by target. Auto Trade stopped.", 5, "Trade")
                                Config.AutoTrade = false
                                break
                            end
                        end
                    end
                end
            end
        end
        tradeActive = false
    end)
end

pcall(function()
    Networking.Gifting.Prompted.OnClientEvent:Connect(function(player, itemName)
        if Config.AutoAcceptTrade then
            task.wait(0.5)
            pcall(function()
                local giftingGui = LocalPlayer.PlayerGui:FindFirstChild("Gifting")
                local clicked = false
                if giftingGui and getconnections then
                    local notif = giftingGui:FindFirstChild("Notification")
                    if notif and notif:FindFirstChild("Buttons") and notif.Buttons:FindFirstChild("AcceptButton") then
                        for _, conn in pairs(getconnections(notif.Buttons.AcceptButton.Activated)) do
                            pcall(function() conn:Fire(); clicked = true end)
                        end
                    end
                end
                if not clicked then
                    Networking.Gifting.Response:Fire(player, true)
                    if giftingGui then giftingGui.Enabled = false end
                end
            end)
        end
    end)
end)

local predictActive = false

local function startPredictLoop()
    if predictActive then return end
    predictActive = true
    task.spawn(function()
        local RS = game:GetService("ReplicatedStorage")
        local SharedModules = RS:WaitForChild("SharedModules")
        local TimeCycleData, MoonGating
        pcall(function()
            TimeCycleData = require(SharedModules:WaitForChild("TimeCycleData", 3))
            MoonGating = require(SharedModules:WaitForChild("MoonGating", 3))
        end)
        
        local function FindNextSchedule(targetWeather)
            if not TimeCycleData then return "Loading..." end
            
            local phases = {}
            for name, data in pairs(TimeCycleData.Data) do
                table.insert(phases, {
                    Name = name,
                    Weathers = data.Weathers,
                    Duration = data.Lasts,
                    Order = data.StartOrder
                })
            end
            table.sort(phases, function(a, b) return a.Order < b.Order end)
            
            local totalDuration = 0
            local targetPhase = nil
            for _, phase in ipairs(phases) do
                phase.StartTime = totalDuration
                totalDuration = totalDuration + phase.Duration
                if phase.Weathers and phase.Weathers[targetWeather] then
                    targetPhase = phase
                end
            end
            
            if not targetPhase or totalDuration == 0 then return "N/A" end
            
            local totalChance = 0
            for wName, wData in pairs(targetPhase.Weathers) do
                if not wData.AdminOnly and (not MoonGating or MoonGating.IsNaturallySpawnable(wName)) then
                    totalChance = totalChance + wData.Chance
                end
            end
            
            local currentCycleID = math.floor(os.time() / totalDuration)
            
            for offset = 0, 1000 do
                local checkCycleID = currentCycleID + offset
                local rng = Random.new((checkCycleID * 1000) + targetPhase.Order)
                local roll = rng:NextNumber() * totalChance
                
                local accumulated = 0
                local predictedWeather = nil
                for wName, wData in pairs(targetPhase.Weathers) do
                    if not wData.AdminOnly and (not MoonGating or MoonGating.IsNaturallySpawnable(wName)) then
                        accumulated = accumulated + wData.Chance
                        if roll <= accumulated then
                            predictedWeather = wName
                            break
                        end
                    end
                end
                
                if predictedWeather == targetWeather then
                    local cycleStartTime = checkCycleID * totalDuration
                    local phaseUnixStart = cycleStartTime + targetPhase.StartTime
                    local timeUntil = phaseUnixStart - os.time()
                    
                    if timeUntil + targetPhase.Duration >= 0 then
                        if timeUntil < 0 then return "ACTIVE NOW!" end
                        local hours   = math.floor(timeUntil / 3600)
                        local minutes = math.floor((timeUntil % 3600) / 60)
                        local seconds = timeUntil % 60
                        if hours > 0 then return string.format("in %dh %02dm %02ds", hours, minutes, seconds)
                        else return string.format("in %02dm %02ds", minutes, seconds) end
                    end
                end
            end
            return "N/A"
        end

        local function ensureUIExists(frame, cloneName, weatherTitle, imageId, color)
            if not frame:FindFirstChild(cloneName) then
                local template = frame:FindFirstChild("Rain") or frame:FindFirstChild("Bloodmoon") or frame:FindFirstChild("Night")
                if template then
                    local newIcon = template:Clone()
                    newIcon.Name = cloneName
                    newIcon.Visible = true
                    
                    local vector = newIcon:FindFirstChild("Vector")
                    if vector and vector:IsA("ImageLabel") then
                        vector.Image = imageId
                    else
                        -- Fallback just in case Vector doesn't exist
                        local img = newIcon:FindFirstChildWhichIsA("ImageLabel", true)
                        if img then 
                            img.Image = imageId 
                        elseif newIcon:IsA("ImageLabel") then
                            newIcon.Image = imageId
                        end
                    end
                    
                    local timeLbl = newIcon:FindFirstChild("Time")
                    if timeLbl then timeLbl.Text = "Loading..." end
                    
                    local weatherLbl = newIcon:FindFirstChild("Weather")
                    if weatherLbl then 
                        weatherLbl.Text = weatherTitle 
                        if color then weatherLbl.TextColor3 = color end
                    end
                    
                    newIcon.Parent = frame
                end
            end
            
            local icon = frame:FindFirstChild(cloneName)
            if icon then icon.Visible = true end
        end

        -- Clean up existing 'Pred' frames to ensure fresh creation with fixed images
        pcall(function()
            local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui and playerGui:FindFirstChild("WeatherUI") and playerGui.WeatherUI:FindFirstChild("Frame") then
                local frame = playerGui.WeatherUI.Frame
                for _, name in pairs({"PredBloodmoon", "PredNight", "PredRainbow", "PredGoldmoon", "PredSunset"}) do
                    local oldIcon = frame:FindFirstChild(name)
                    if oldIcon then oldIcon:Destroy() end
                end
            end
        end)

        while _G.GagAutoScriptActive do
            if Config.PredictWeather then
                pcall(function()
                    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                    if playerGui and playerGui:FindFirstChild("WeatherUI") and playerGui.WeatherUI:FindFirstChild("Frame") then
                        local frame = playerGui.WeatherUI.Frame
                        
                        ensureUIExists(frame, "PredBloodmoon", "Bloodmoon", "rbxassetid://140465339393451", Color3.new(0.51, 0, 0))
                        ensureUIExists(frame, "PredNight", "Night", "rbxassetid://91446334780160", Color3.new(0.12, 0.28, 0.58))
                        ensureUIExists(frame, "PredRainbow", "Rainbow Moon", "rbxassetid://93602895495056", Color3.new(0.65, 0.09, 1))
                        ensureUIExists(frame, "PredGoldmoon", "Goldmoon", "rbxassetid://84902063004871", Color3.new(1, 0.87, 0))
                        ensureUIExists(frame, "PredSunset", "Sunset", "rbxassetid://86217612022586", Color3.new(1, 0.89, 0.35))
                        
                        if frame:FindFirstChild("PredBloodmoon") then
                            frame.PredBloodmoon.Time.Text = FindNextSchedule("Bloodmoon")
                        end
                        if frame:FindFirstChild("PredNight") then
                            frame.PredNight.Time.Text = FindNextSchedule("Moon")
                        end
                        if frame:FindFirstChild("PredRainbow") then
                            frame.PredRainbow.Time.Text = FindNextSchedule("Rainbow Moon")
                        end
                        if frame:FindFirstChild("PredGoldmoon") then
                            frame.PredGoldmoon.Time.Text = FindNextSchedule("Goldmoon")
                        end
                        if frame:FindFirstChild("PredSunset") then
                            frame.PredSunset.Time.Text = FindNextSchedule("Sunset")
                        end
                    end
                end)
            else
                pcall(function()
                    local frame = game:GetService("Players").LocalPlayer.PlayerGui.WeatherUI.Frame
                    for _, name in pairs({"PredBloodmoon", "PredNight", "PredRainbow", "PredGoldmoon", "PredSunset"}) do
                        local icon = frame:FindFirstChild(name)
                        if icon then icon.Visible = false end
                    end
                end)
            end
            task.wait(1)
            if not predictActive then break end
        end
        
        predictActive = false
    end)
end


local autoLeaveWeatherActive = false
local function startAutoLeaveWeatherLoop()
    if autoLeaveWeatherActive then return end
    autoLeaveWeatherActive = true
    task.spawn(function()
        local RS = game:GetService("ReplicatedStorage")
        local SharedModules = RS:WaitForChild("SharedModules")
        local TimeCycleData = nil
        pcall(function() TimeCycleData = require(SharedModules:WaitForChild("TimeCycleData", 3)) end)
        local MoonGating = nil
        pcall(function() MoonGating = require(SharedModules:WaitForChild("MoonGating", 3)) end)
        local WeatherData = nil
        pcall(function() WeatherData = require(SharedModules:WaitForChild("WeatherData", 3)) end)

        local function GetActiveWeatherTimeLeft(targetWeather)
            -- 1. Check TimeCycle Moons (Goldmoon, Bloodmoon, dll) di workspace
            if workspace:GetAttribute("ActiveWeather") == targetWeather then
                local phaseDuration = workspace:GetAttribute("PhaseDuration") or 0
                local serverTimeNow = workspace:GetServerTimeNow()
                local timeLeft = phaseDuration - serverTimeNow
                if timeLeft > 0 then
                    return timeLeft
                end
            end

            -- 2. Check Standard Weathers (Aurora, Rain, Snowfall, dll) di WeatherValues
            local WeatherValues = RS:FindFirstChild("WeatherValues")
            if WeatherValues then
                local isPlaying = WeatherValues:GetAttribute(targetWeather .. "_Playing")
                if isPlaying then
                    local endTime = WeatherValues:GetAttribute(targetWeather .. "_EndTime") or 0
                    local unixNow = DateTime.now().UnixTimestamp
                    local timeLeft = endTime - unixNow
                    if timeLeft > 0 then
                        return timeLeft
                    end
                end
            end
            return -1
        end

        while Config.AutoLeaveWeather and _G.GagAutoScriptActive do
            if type(Config.AutoLeaveWeatherTarget) == "table" and #Config.AutoLeaveWeatherTarget > 0 then
                local kicked = false
                for _, target in ipairs(Config.AutoLeaveWeatherTarget) do
                    if target == "None" then continue end
                    
                    -- Check Server Active Weathers (100% accurate)
                    local timeLeft = GetActiveWeatherTimeLeft(target)
                    if timeLeft > 0 then
                        _G.AutoReconnectDelay = timeLeft + 5
                        game.Players.LocalPlayer:Kick("Menghindari cuaca " .. target .. ".\nReconnect otomatis dalam " .. math.floor(_G.AutoReconnectDelay) .. " detik.")
                        kicked = true
                        break
                    end

                    -- Check Workspace Attributes (Weather Mutations)
                    if workspace:GetAttribute(target) then
                        local duration = 150
                        if WeatherData and WeatherData.Data then
                            for _, w in ipairs(WeatherData.Data) do
                                if w.Name == target then
                                    duration = w.Last or 150
                                    break
                                end
                            end
                        end
                        _G.AutoReconnectDelay = duration + 5
                        game.Players.LocalPlayer:Kick("Menghindari cuaca " .. target .. ".\nReconnect otomatis dalam " .. math.floor(_G.AutoReconnectDelay) .. " detik.")
                        kicked = true
                        break
                    end
                end
                if kicked then break end
            end
            task.wait(5)
        end
        autoLeaveWeatherActive = false
    end)
end


-- ============================================================
-- ANTI AFK
-- ============================================================
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
    if Config.AntiAFK then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

-- Custom Game Anti-AFK Bypass (Bypasses AntiAfkController.lua)
task.spawn(function()
    while task.wait(5) do
        if Config.AntiAFK then
            pcall(function()
                LocalPlayer:SetAttribute("AntiAfkIdleOverride", 9e9)
            end)
        end
    end
end)

-- ============================================================
-- ANTI KNOCKBACK & ANTI FLING
-- ============================================================
RunService.Stepped:Connect(function()
    if Config.AntiKnockback then
        local char = LocalPlayer.Character
        if char then
            for _, desc in ipairs(char:GetDescendants()) do
                if desc:IsA("BasePart") then
                    for _, mover in ipairs(desc:GetChildren()) do
                        if mover:IsA("BodyVelocity") or mover:IsA("BodyPosition") or mover:IsA("BodyGyro") or mover:IsA("BodyThrust") or mover:IsA("BodyForce") or mover:IsA("LinearVelocity") or mover:IsA("VectorForce") or mover:IsA("AlignPosition") or mover:IsA("AlignOrientation") then
                            if mover.Name ~= "GagAimbot" then
                                mover:Destroy()
                            end
                        elseif mover:IsA("Weld") or mover:IsA("WeldConstraint") or mover:IsA("ManualWeld") then
                            if mover.Part0 and mover.Part1 then
                                if not mover.Part0:IsDescendantOf(char) or not mover.Part1:IsDescendantOf(char) then
                                    mover:Destroy()
                                end
                            end
                        end
                    end
                elseif desc:IsA("Motor6D") then
                    if not desc.Enabled then
                        desc.Enabled = true
                    end
                end
            end
            
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                if hum.PlatformStand then
                    hum.PlatformStand = false
                end
                
                local badStates = {
                    Enum.HumanoidStateType.Seated,
                    Enum.HumanoidStateType.Ragdoll,
                    Enum.HumanoidStateType.FallingDown,
                    Enum.HumanoidStateType.Physics,
                    Enum.HumanoidStateType.PlatformStanding
                }
                
                for _, s in ipairs(badStates) do
                    if hum:GetStateEnabled(s) then
                        hum:SetStateEnabled(s, false)
                    end
                end
                
                if hum.Sit then
                    hum.Sit = false
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
                
                local state = hum:GetState()
                if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.PlatformStanding then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    for _, part in ipairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
    end
end)

-- ============================================================
-- RESTOCK DETECTION & DISCORD LOG
-- ============================================================
-- Listens for the ReplicaSet remote event which signals a restock.
-- Reads stock values from SeedShop.Items, filters value > 0,
-- then sends data to server. Server handles deduplication so
-- only 1 Discord log is sent per restock regardless of how many
-- clients are running the script.
-- ============================================================

local RESTOCK_API_URL = "https://napoleonn.net/api/restock"

local function getRestockItems()
    local stockItems = {}
    local ok, err = pcall(function()
        local stockFolder = ReplicatedStorage:FindFirstChild("StockValues")
        if not stockFolder then return end
        local seedShop = stockFolder:FindFirstChild("SeedShop")
        if not seedShop then return end
        local items = seedShop:FindFirstChild("Items")
        if not items then return end

        for _, child in ipairs(items:GetChildren()) do
            if (child:IsA("NumberValue") or child:IsA("IntValue")) and child.Value > 0 then
                stockItems[child.Name] = child.Value
            end
        end
    end)
    if not ok then
        warn("[Restock] Error reading stock:", err)
    end
    return stockItems
end

local function sendRestockLog(stockItems)
    task.spawn(function()
        pcall(function()
            local payload = HttpService:JSONEncode({
                items = stockItems,
                serverId = tostring(game.JobId),
                reportedBy = LocalPlayer.Name
            })

            local success, response = pcall(function()
                return (syn and syn.request or http_request or request)({
                    Url = RESTOCK_API_URL,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = payload
                })
            end)

            if not success then
                -- Fallback: try game:HttpGet with query params (limited but works on some executors)
                pcall(function()
                    local itemsStr = ""
                    for name, value in pairs(stockItems) do
                        if itemsStr ~= "" then itemsStr = itemsStr .. "," end
                        itemsStr = itemsStr .. name .. ":" .. tostring(value)
                    end
                    game:HttpGet(RESTOCK_API_URL .. "?items=" .. itemsStr .. "&serverId=" .. tostring(game.JobId) .. "&reportedBy=" .. LocalPlayer.Name)
                end)
            end
        end)
    end)
end

local lastSeedRestockNotify = 0
pcall(function()
    local replicaEvent = ReplicatedStorage:WaitForChild("RemoteEvents", 10)
    if not replicaEvent then return end
    local replicaSet = replicaEvent:FindFirstChild("ReplicaSet")
    if not replicaSet then return end

    replicaSet.OnClientEvent:Connect(function(...)
        local args = {...}
        -- Check if this is a restock signal
        -- The signal comes as: 1, {"PurchasedThisRestock", "Seeds"}, {}
        local isRestock = false
        for _, arg in ipairs(args) do
            if type(arg) == "table" then
                for _, v in ipairs(arg) do
                    if type(v) == "string" and v == "PurchasedThisRestock" then
                        isRestock = true
                        break
                    end
                end
            end
            if isRestock then break end
        end

        if isRestock then
            if os.time() - lastSeedRestockNotify < 60 then return end
            lastSeedRestockNotify = os.time()
            
            -- Small delay to let stock values update
            task.wait(1)

            local stockItems = getRestockItems()
            local count = 0
            for _ in pairs(stockItems) do count = count + 1 end

            if count > 0 then
                sendRestockLog(stockItems)
                notif("Restock detected! " .. count .. " items available.", 5, "Restock")
            else
                notif("Restock detected but no items available.", 3, "Restock")
            end
        end
    end)
end)

-- ============================================================
-- GEAR RESTOCK DETECTION & DISCORD LOG
-- ============================================================
local GEAR_RESTOCK_API_URL = "http://napoleonn.net/api/gearrestock"
local gearLastRestockUnix = 0

-- ============================================================
-- MULTI-SAMPLE LOCK (gear predict)
-- Tiap restock asli direkam {anchor=unix, stock={name=qty}}. Solver mencari
-- SATU formula yang cocok ke SEMUA sample → formula palsu tersaring otomatis.
-- Jalan di background lewat listener restock walau UI gear predict mati.
-- ============================================================
local gearSamples = {}
local GEAR_SAMPLE_CAP = 10

local function recordGearSample(stockItems)
    -- Anchor = unix restock (boundary), bukan os.time() deteksi yang telat beberapa detik.
    local anchor = os.time()
    pcall(function()
        local sv = ReplicatedStorage:FindFirstChild("StockValues")
        if sv then
            local gs = sv:FindFirstChild("GearShop")
            local ss = sv:FindFirstChild("SeedShop")
            local ul = (gs and gs:FindFirstChild("UnixLastRestock"))
                or (ss and ss:FindFirstChild("UnixLastRestock"))
            if ul and ul.Value and ul.Value > 0 then anchor = ul.Value end
        end
    end)
    -- Hindari duplikat anchor (restock sama tercatat 2x)
    for _, s in ipairs(gearSamples) do
        if s.anchor == anchor then return end
    end
    -- Copy stock supaya tidak ke-mutate
    local snap = {}
    for name, qty in pairs(stockItems) do snap[name] = qty end
    table.insert(gearSamples, { anchor = anchor, stock = snap })
    while #gearSamples > GEAR_SAMPLE_CAP do table.remove(gearSamples, 1) end
end

local function getGearRestockItems()
    local stockItems = {}
    local ok, err = pcall(function()
        local stockFolder = ReplicatedStorage:FindFirstChild("StockValues")
        if not stockFolder then return end
        local gearShop = stockFolder:FindFirstChild("GearShop")
        if not gearShop then return end
        local items = gearShop:FindFirstChild("Items")
        if not items then return end

        for _, child in ipairs(items:GetChildren()) do
            if (child:IsA("NumberValue") or child:IsA("IntValue")) and child.Value > 0 then
                stockItems[child.Name] = child.Value
            end
        end
    end)
    if not ok then
        warn("[GearRestock] Error reading stock:", err)
    end
    return stockItems
end

local function sendGearRestockLog(stockItems)
    task.spawn(function()
        pcall(function()
            local payload = HttpService:JSONEncode({
                items = stockItems,
                serverId = tostring(game.JobId),
                reportedBy = LocalPlayer.Name
            })

            local success, response = pcall(function()
                return (syn and syn.request or http_request or request)({
                    Url = GEAR_RESTOCK_API_URL,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = payload
                })
            end)

            if not success then
                pcall(function()
                    local itemsStr = ""
                    for name, value in pairs(stockItems) do
                        if itemsStr ~= "" then itemsStr = itemsStr .. "," end
                        itemsStr = itemsStr .. name .. ":" .. tostring(value)
                    end
                    game:HttpGet(GEAR_RESTOCK_API_URL .. "?items=" .. itemsStr .. "&serverId=" .. tostring(game.JobId) .. "&reportedBy=" .. LocalPlayer.Name)
                end)
            end
        end)
    end)
end

local lastGearRestockNotify = 0
pcall(function()
    local replicaEvent = ReplicatedStorage:WaitForChild("RemoteEvents", 10)
    if not replicaEvent then return end
    local replicaSet = replicaEvent:FindFirstChild("ReplicaSet")
    if not replicaSet then return end

    replicaSet.OnClientEvent:Connect(function(...)
        local args = {...}
        local isGearRestock = false
        for _, arg in ipairs(args) do
            if type(arg) == "table" then
                local hasPurchased = false
                local hasGear = false
                for _, v in ipairs(arg) do
                    if type(v) == "string" and v == "PurchasedThisRestock" then hasPurchased = true end
                    if type(v) == "string" and v == "Gears" then hasGear = true end
                end
                if hasPurchased and hasGear then
                    isGearRestock = true
                    break
                end
            end
            if isGearRestock then break end
        end

        if isGearRestock then
            if os.time() - lastGearRestockNotify < 60 then return end
            lastGearRestockNotify = os.time()
            gearLastRestockUnix = os.time()

            task.wait(1)

            local stockItems = getGearRestockItems()
            local count = 0
            for _ in pairs(stockItems) do count = count + 1 end

            if count > 0 then
                recordGearSample(stockItems)
                sendGearRestockLog(stockItems)
                notif("Gear restock detected! " .. count .. " items available.", 5, "Gear Restock")
            end
        end
    end)
end)

-- ============================================================
-- PET FINDER / TRACKER

local PET_API_URL = serverUrl .. "/api/pets?customsig=true"

local KNOWN_MUTATIONS = {
    "Gold", "Golden", "Big", "Rainbow", "Huge", "Giant", "Tiny", "Radioactive"
}
if MUTATION_LIST then
    for _, m in ipairs(MUTATION_LIST) do
        if m ~= "None" and not table.find(KNOWN_MUTATIONS, m) then
            table.insert(KNOWN_MUTATIONS, m)
        end
    end
end

local function parsePetName(rawName)
    local mutation = "None"
    local baseName = rawName
    for _, mut in ipairs(KNOWN_MUTATIONS) do
        if string.sub(rawName, 1, string.len(mut)) == mut then
            mutation = mut
            baseName = string.sub(rawName, string.len(mut) + 1)
            break
        end
    end
    -- Fallback for specific edge cases or manual mapping
    if baseName == "GoldenDragonfly" then mutation = "Golden"; baseName = "Dragonfly" end
    if baseName == "BigFrog" then mutation = "Big"; baseName = "Frog" end
    if baseName == "RainbowOwl" then mutation = "Rainbow"; baseName = "Owl" end
    
    local rarity = PET_RARITIES[baseName] or "Unknown"
    return baseName, rarity, mutation
end

local function sendPetData(action, petName, petId, customTime, rarity, mutation)

    local dTime = customTime or math.floor(os.time() + 300) -- 5 minutes max
    local body = HttpService:JSONEncode({
        action = action,
        serverId = game.JobId,
        petId = petId,
        petName = petName,
        despawnTime = dTime,
        reportedBy = LocalPlayer.Name,
        rarity = rarity or "Unknown",
        mutation = mutation or "None"
    })
    
    local payloadXOR = encryptXOR(body, SECRET_KEY)
    local sig = customSign(payloadXOR, SERVER_PUBLIC_KEY)
    
    local encryptedBody = HttpService:JSONEncode({
        payload = payloadXOR,
        sig = sig
    })
    
    task.spawn(function()
        pcall(function()
            local requestFunc = syn and syn.request or http_request or request
            if requestFunc then
                requestFunc({
                    Url = PET_API_URL,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = encryptedBody
                })
            else
                game:HttpPost(PET_API_URL, encryptedBody, "application/json")
            end
        end)
    end)
end

task.spawn(function()
    local map = workspace:WaitForChild("Map", 9e9)
    if not map then return end
    local wildPetSpawns = map:WaitForChild("WildPetSpawns", 9e9)
    if not wildPetSpawns then return end
    
    local function parsePetTime(pet)
        -- Format usually: WildPet_Frog_WildPet_xxxx
        -- Format usually: WildPet_Frog_WildPet_xxxx
        local rawName = string.match(pet.Name, "WildPet_(.-)_WildPet") or "Unknown"
        local pName, rarity, mutation = parsePetName(rawName)
        
        -- Default to 5 mins if we can't read the UI
        local timeLeft = 300 
        
        local rootPart = pet:FindFirstChild("RootPart")
        if rootPart then
            local timerGui = rootPart:FindFirstChild("PetLeaveTimer")
            if timerGui then
                local textLabel = timerGui:FindFirstChild("TextLabel")
                if textLabel and textLabel.Text then
                    local t = textLabel.Text
                    local m_ms, s_ms = string.match(t, "(%d+)m%s*(%d+)s")
                    local m_colon, s_colon = string.match(t, "(%d+):(%d+)")
                    local s_only = string.match(t, "^(%d+)s$")
                    
                    if m_ms and s_ms then
                        timeLeft = (tonumber(m_ms) * 60) + tonumber(s_ms) - 3
                    elseif m_colon and s_colon then
                        timeLeft = (tonumber(m_colon) * 60) + tonumber(s_colon) - 3
                    elseif s_only then
                        timeLeft = tonumber(s_only) - 3
                    end
                end
            end
        end
        
        return pName, timeLeft, rarity, mutation
    end
    
    local existingPets = wildPetSpawns:GetChildren()
    
    for _, pet in ipairs(existingPets) do
        if pet:IsA("Model") then
            local pName, timeLeft, rarity, mutation = parsePetTime(pet)
            local exactDespawn = math.floor(os.time() + timeLeft)
            sendPetData("add", pName, pet.Name, exactDespawn, rarity, mutation)
        end
    end
    
    wildPetSpawns.ChildAdded:Connect(function(pet)
        if pet:IsA("Model") then
            -- Wait for UI to load completely
            pet:WaitForChild("RootPart", 5)
            task.wait(1.5)
            
            local pName, timeLeft, rarity, mutation = parsePetTime(pet)
            local exactDespawn = math.floor(os.time() + timeLeft)
            sendPetData("add", pName, pet.Name, exactDespawn, rarity, mutation)
        end
    end)
    
    wildPetSpawns.ChildRemoved:Connect(function(pet)
        if pet:IsA("Model") then
            local rawName = string.match(pet.Name, "WildPet_(.-)_WildPet") or "Unknown"
            local pName, _, _ = parsePetName(rawName)
            sendPetData("remove", pName, pet.Name)
        end
    end)
end)

-- ============================================================
-- UI SETUP (Napoleon Library)
-- ============================================================
_G.ScriptFullyLoaded = false
local function LoadNapoleonUI()
    local url = "https://raw.githubusercontent.com/Fdhlnn23/NapoleonUI/refs/heads/main/NPLN-UIv4.lua"
    local cacheName = "NPLN-UIv4_cached.lua"
    
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
        result = string.gsub(result, 'game:GetService%("CoreGui"%)', 'game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")')
        
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
end-- ============================================================
-- WEB UI PROXY HOOKS (DYNAMIC SCHEMA GENERATOR)
-- ============================================================
_G.WebUISchema = {}
_G.WebUIHandlers = {}

local RealWindow = Library.Window
Library.Window = function(self, windowArgs)
    local realWin = RealWindow(self, windowArgs)
    
    local RealAddTab = realWin.AddTab
    realWin.AddTab = function(winSelf, tabArgs)
        local realTab = RealAddTab(winSelf, tabArgs)
        local tabName = tabArgs.Name or tabArgs.Title or "Tab"
        
        local schemaCategory = nil
        for _, c in ipairs(_G.WebUISchema) do
            if c.category == tabName then schemaCategory = c break end
        end
        if not schemaCategory then
            schemaCategory = { category = tabName, items = {} }
            table.insert(_G.WebUISchema, schemaCategory)
        end
        
        local RealAddSection = realTab.AddSection
        realTab.AddSection = function(tabSelf, secName, ...)
            local realSection = RealAddSection(tabSelf, secName, ...)
            
            local function registerItem(itemType, id, title, defaultVal, options, isMulti)
                if not id then return end
                for _, item in ipairs(schemaCategory.items) do
                    if item.id == id then return end
                end
                table.insert(schemaCategory.items, {
                    id = id, type = itemType, title = title, value = defaultVal, options = options, multi = isMulti, section = secName
                })
            end
            
            local RealAddToggle = realSection.AddToggle
            realSection.AddToggle = function(secSelf, args)
                local id = args.Flag or args.Title or args.Name
                registerItem("toggle", id, args.Title, args.Default)
                local origCb = args.Callback
                args.Callback = function(val)
                    if _G.WebUIHandlers[id] then _G.WebUIHandlers[id].val = val end
                    if origCb then origCb(val) end
                end
                local obj = RealAddToggle(secSelf, args)
                _G.WebUIHandlers[id] = { obj = obj, type = "toggle", val = args.Default }
                return obj
            end
            
            local RealAddDropdown = realSection.AddDropdown
            realSection.AddDropdown = function(secSelf, args)
                local id = args.Flag or args.Title or args.Name
                local isMulti = args.Multi or args.multi
                registerItem("dropdown", id, args.Title, args.Default, args.Values or args.Options, isMulti)
                local origCb = args.Callback
                args.Callback = function(val)
                    if _G.WebUIHandlers[id] then _G.WebUIHandlers[id].val = val end
                    if origCb then origCb(val) end
                end
                local obj = RealAddDropdown(secSelf, args)
                _G.WebUIHandlers[id] = { obj = obj, type = "dropdown", val = args.Default }
                return obj
            end
            
            local RealAddButton = realSection.AddButton
            realSection.AddButton = function(secSelf, args)
                local id = "BTN_" .. (args.Title or args.Name):gsub("[^%w]", "")
                registerItem("button", id, args.Title, nil)
                local obj = RealAddButton(secSelf, args)
                _G.WebUIHandlers[id] = { obj = obj, type = "button", cb = args.Callback }
                return obj
            end
            
            local RealAddInput = realSection.AddInput
            realSection.AddInput = function(secSelf, args)
                local id = args.Flag or args.Title or args.Name
                registerItem("input", id, args.Title, args.Default)
                local origCb = args.Callback
                args.Callback = function(val)
                    if _G.WebUIHandlers[id] then _G.WebUIHandlers[id].val = val end
                    if origCb then origCb(val) end
                end
                local obj = RealAddInput(secSelf, args)
                _G.WebUIHandlers[id] = { obj = obj, type = "input", val = args.Default }
                return obj
            end
            
            return realSection
        end
        return realTab
    end
    return realWin
end

local ICON_ID = "96531489912535"

-- Override notif to use NPLN-UI
notif = function(content, duration, title)
    if not Config.HideNotifications then
        if Library and Library.MakeNotify then
            Library:MakeNotify({ Title = title or "NAPOLEON", Content = content, Delay = duration or 4, Icon = "rbxassetid://" .. ICON_ID })
        end
    end
    
    if Config.WebControlEnabled then
        local sUrl = getgenv().ServerURL or _G.ServerURL or "https://napoleonn.net"
        local key = getgenv().Key or _G.Key or "Unknown_Key"
        if sUrl and key then
            task.spawn(function()
                pcall(function()
                    local requestFunc = syn and syn.request or http_request or request or fluxus and fluxus.request
                    local bodyData = game:GetService("HttpService"):JSONEncode({
                        key = key,
                        username = game.Players.LocalPlayer and game.Players.LocalPlayer.Name or "Unknown",
                        title = title or "Napoleon",
                        message = content,
                        type = "info"
                    })
                    local endpoint = sUrl .. "/api/script/notification"
                    
                    if requestFunc then
                        requestFunc({
                            Url = endpoint,
                            Method = "POST",
                            Headers = { ["Content-Type"] = "application/json" },
                            Body = bodyData
                        })
                    else
                        game:HttpPostAsync(endpoint, bodyData, "application/json")
                    end
                end)
            end)
        end
    end
end

local Window = Library:Window({
    Title = "Napoleon",
    Footer = "Grow a Garden 2",
    Color = Color3.fromRGB(81, 66, 255),
    Color2 = Color3.fromRGB(0, 0, 14),
    ["Tab Width"] = 130,
    Image = "111895858615511",
    WindowIMG = "91334002283698",
    LogoHUB = "136289055140268"
})
local Tabs = Window

local function LoadInfoTab()
-- TAB INFO
local InfoTab = Tabs:AddTab({ Name = "Info", Icon = "info" })
local InfoSection = InfoTab:AddSection("Napoleon — Grow a Garden", true)
InfoSection:AddParagraph({
    Title = "?? Script Info",
    Content = "Auto Harvest: Scan your plot for ripe fruits and collect them automatically.\nAuto Sell: Sell fruits automatically based on filters.\nGPU Saver: Disable rendering to reduce lag."
})
InfoSection:AddButton({
    Title = "Join Discord",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/RKaZ9vEbpb")
            notif("Discord link copied to clipboard!", 3, "Napoleon")
        end
    end
}) 


end

local function LoadMainTab()
-- TAB MAIN
local MainTab = Tabs:AddTab({ Name = "Main", Icon = "rod" })

local PlantSection = MainTab:AddSection("Auto Plant")
PlantSection:AddToggle({
    Title = "Enable Auto Plant",
    Title2 = "Enable",
    Content = "Automatically plant selected seed on your plot",
    Default = false,
    Callback = function(val)
        Config.AutoPlant = val
        if UI_LOADED and val then startPlantLoop() end
    end
})

local PlantSeedDropdown
PlantSeedDropdown = PlantSection:AddDropdown({
    Title = "Select Seed to Plant",
    Options = SEED_LIST,
    Default = {"None"},
    Multi = true,
    Callback = function(val) 
        Config.PlantSeedNames = handleDropdownChange(val, PlantSeedDropdown)
    end
})

PlantSection:AddDropdown({
    Title = "Plant Location",
    Options = {"Random", "Player Position", "Saved Position"},
    Default = {"Random"},
    Callback = function(val) 
        if type(val) == "table" then val = val[1] end
        Config.PlantLocation = val 
    end
})

PlantSection:AddButton({
    Title = "Save Current Position",
    Content = "Save your current location as the plant spot.",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            _G.SavedPlantPosition = char.HumanoidRootPart.Position - Vector3.new(0, 2.5, 0)
            
            pcall(function()
                if workspace:FindFirstChild("GagSavedPosVisual") then
                    workspace.GagSavedPosVisual:Destroy()
                end
                local part = Instance.new("Part")
                part.Name = "GagSavedPosVisual"
                part.Shape = Enum.PartType.Cylinder
                part.Size = Vector3.new(0.5, 6, 6)
                part.Orientation = Vector3.new(0, 0, 90)
                part.Position = _G.SavedPlantPosition + Vector3.new(0, 0.25, 0)
                part.Anchored = true
                part.CanCollide = false
                part.Material = Enum.Material.ForceField
                part.Color = Color3.fromRGB(81, 66, 255)
                part.Parent = workspace
            end)
            
            if UI_LOADED then
                notif("Position saved!", 3, "Auto Plant")
            end
        end
    end
})

PlantSection:AddInput({
    Title = "Plant Delay (Seconds)",
    Content = "Delay between planting each seed",
    Default = "0.5",
    Numeric = true,
    Callback = function(val)
        Config.PlantDelay = tonumber(val) or 0.5
    end
})

local ShovelSection = MainTab:AddSection("Auto Shovel")
ShovelSection:AddToggle({
    Title = "Enable Auto Shovel",
    Title2 = "Enable",
    Content = "Automatically remove selected plants from your garden",
    Default = false,
    Callback = function(val)
        Config.AutoShovel = val
        if UI_LOADED and val then startShovelLoop() end
    end
})

local AutoShovelDropdown
AutoShovelDropdown = ShovelSection:AddDropdown({
    Title = "Select Plants to Shovel",
    Options = SEED_LIST,
    Default = {"None"},
    Multi = true,
    Callback = function(val) 
        Config.AutoShovelSeeds = handleDropdownChange(val, AutoShovelDropdown)
    end
})

ShovelSection:AddInput({
    Title = "Shovel Seed by Ft",
    Content = "Shovel plants that are LESS THAN this ft (e.g. 38 means < 38ft). 0 to disable.",
    Default = "0",
    Numeric = true,
    Callback = function(val)
        Config.AutoShovelMinFt = tonumber(val) or 0
    end
})

ShovelSection:AddToggle({
    Title = "Auto Shovel Fruit",
    Title2 = "Enable",
    Content = "Automatically remove selected fruits from your garden based on weight",
    Default = false,
    Callback = function(val)
        Config.AutoShovelFruit = val
        if UI_LOADED and val then startShovelFruitLoop() end
    end
})

local SHOVEL_FRUIT_LIST = {"None"}
for _, v in ipairs(SEED_LIST) do
    if v ~= "None" then table.insert(SHOVEL_FRUIT_LIST, v) end
end

local AutoShovelFruitDropdown
AutoShovelFruitDropdown = ShovelSection:AddDropdown({
    Title = "Select Fruit to Shovel",
    Options = SHOVEL_FRUIT_LIST,
    Default = {"None"},
    Multi = true,
    Callback = function(val) 
        Config.AutoShovelFruits = handleDropdownChange(val, AutoShovelFruitDropdown)
    end
})

ShovelSection:AddInput({
    Title = "Shovel Fruit by KG",
    Content = "Shovel fruits that are less than or equal to this KG (e.g. 5 means <= 5kg)",
    Default = "0",
    Numeric = true,
    Callback = function(val)
        Config.AutoShovelFruitKg = tonumber(val) or 0
    end
})

ShovelSection:AddToggle({
    Title = "Auto Swing Shovel (Auto Punch)",
    Title2 = "Enable",
    Content = "Otomatis pegang shovel dan pukul-pukul tanpa henti.",
    Default = false,
    Callback = function(val)
        Config.AutoSwingShovel = val
        if UI_LOADED and val then startAutoSwingShovelLoop() end
    end
})

ShovelSection:AddToggle({
    Title = "Auto Protect Base",
    Title2 = "Enable",
    Content = "Teleport and attack players stealing from your garden.",
    Default = false,
    Callback = function(val)
        Config.AutoProtectBase = val
        if UI_LOADED and val then startProtectLoop() end
    end
})

local HarvestSection = MainTab:AddSection("Auto Harvest")

HarvestSection:AddToggle({
    Title = "Auto Harvest",
    Content = "Otomatis panen tanamanmu jika sudah siap panen.",
    Default = false,
    Callback = function(val)
        Config.AutoHarvest = val
        if UI_LOADED then
            if val then notif("Auto Harvest ON", 3, "Harvest") else notif("Auto Harvest OFF", 3, "Harvest") end
        end
        if UI_LOADED and val then startHarvestLoop() end
    end
})



local HARVEST_LIST = {"None", "All"}
for _, v in ipairs(SEED_LIST) do
    if v ~= "None" then table.insert(HARVEST_LIST, v) end
end

local CollectFruitsDropdown
CollectFruitsDropdown = HarvestSection:AddDropdown({
    Title = "Select Fruits to Harvest",
    Content = "Pilih buah yang INGIN di-harvest (Pilih 'All' untuk panen semua)",
    Options = HARVEST_LIST,
    Default = {"All"},
    Multi = true,
    Callback = function(val)
        Config.CollectFruits = handleDropdownChange(val, CollectFruitsDropdown)
    end
})

local HARVEST_MUTATION_LIST = {"None", "Non Mutasi"}
for _, v in ipairs(MUTATION_LIST) do
    if v ~= "None" then table.insert(HARVEST_MUTATION_LIST, v) end
end

local HarvestMutationDropdown
HarvestMutationDropdown = HarvestSection:AddDropdown({
    Title = "Select Mutation to Harvest",
    Content = "Pilih mutasi spesifik. 'Non Mutasi' untuk tanpa mutasi. 'None' untuk panen semua mutasi.",
    Options = HARVEST_MUTATION_LIST,
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.HarvestMutations = handleDropdownChange(val, HarvestMutationDropdown)
    end
})

HarvestSection:AddInput({
    Title = "Max KG (Weight Limit)",
    Content = "Batas maksimum KG buah untuk dipanen (Isi 0 untuk tanpa batas)",
    Default = "0",
    Numeric = true,
    Callback = function(val)
        Config.MaxHarvestKg = tonumber(val) or 0
    end
})

HarvestSection:AddInput({
    Title = "Harvest Delay (Seconds)",
    Content = "Delay between collecting each fruit",
    Default = "0",
    Numeric = true,
    Callback = function(val)
        Config.HarvestDelay = tonumber(val) or 0
    end
})

local ClaimSection = MainTab:AddSection("Auto Claim Drops")
ClaimSection:AddToggle({
    Title = "Auto Claim Drop Items",
    Content = "Otomatis klaim semua item yang jatuh di map.",
    Default = false,
    Callback = function(val)
        Config.AutoClaim = val
        if UI_LOADED then
            if val then notif("Auto Claim ON", 3, "Claim") else notif("Auto Claim OFF", 3, "Claim") end
        end
        if UI_LOADED and val then startClaimLoop() end
    end
})

local AutoClaimDropdown
AutoClaimDropdown = ClaimSection:AddDropdown({
    Title = "Select What to Claim",
    Content = "Pilih barang yang ingin di-claim",
    Options = {"Items", "Seedpack", "Pet Items"},
    Default = {"Items", "Seedpack", "Pet Items"},
    Multi = true,
    Callback = function(val)
        Config.AutoClaimTypes = handleDropdownChange(val, AutoClaimDropdown)
    end
})

local StealSection = MainTab:AddSection("Auto Steal")
StealSection:AddToggle({
    Title = "Auto Steal Fruits",
    Content = "Curi buah dari kebun pemain lain diam-diam.",
    Default = false,
    Callback = function(val)
        Config.AutoSteal = val
        if UI_LOADED then
            if val then notif("Auto Steal ON", 3, "Steal") else notif("Auto Steal OFF", 3, "Steal") end
        end
        if UI_LOADED and val then startStealLoop() end
    end
})

StealSection:AddInput({
    Title = "Max Steal Amount",
    Content = "How many fruits to steal before returning to base",
    Default = "50",
    Numeric = true,
    Callback = function(val)
        Config.MaxSteal = tonumber(val) or 50
    end
})

StealSection:AddInput({
    Title = "Steal Delay (Seconds)",
    Content = "Delay between stealing each fruit",
    Default = "0.5",
    Numeric = true,
    Callback = function(val)
        Config.StealDelay = tonumber(val) or 0.5
    end
})

local TrowelSection = MainTab:AddSection("Auto Trowel")
TrowelSection:AddButton({
    Title = "Execute Trowel",
    Content = "Gather selected plants to a specific spot instantly",
    Callback = function()
        triggerTrowelOnce()
    end
})

local trowelPlantsOptions = {"All"}
for _, s in ipairs(SEED_LIST) do
    if s ~= "None" then table.insert(trowelPlantsOptions, s) end
end

local TrowelPlantsDropdown
TrowelPlantsDropdown = TrowelSection:AddDropdown({
    Title = "Select Plants to Trowel",
    Options = trowelPlantsOptions,
    Default = {"All"},
    Multi = true,
    Callback = function(val)
        Config.TrowelPlants = handleDropdownChange(val, TrowelPlantsDropdown)
    end
})

TrowelSection:AddDropdown({
    Title = "Position Mode",
    Options = {"Player Position", "Random"},
    Default = "Player Position",
    Multi = false,
    Callback = function(val)
        Config.TrowelPositionMode = val
    end
})

local SellSection = MainTab:AddSection("Auto Sell")
SellSection:AddToggle({
    Title = "Auto Sell",
    Content = "Jual buah secara otomatis ke NPC.",
    Default = false,
    Callback = function(val)
        Config.AutoSell = val
        if UI_LOADED then
            if val then notif("Auto Sell ON", 3, "Sell") else notif("Auto Sell OFF", 3, "Sell") end
        end
        if UI_LOADED and val then startSellLoop() end
    end
})

SellSection:AddToggle({
    Title = "Auto Sell Pet",
    Content = "Jual pet secara otomatis ke NPC Steven.",
    Default = false,
    Callback = function(val)
        Config.AutoSellPet = val
        if UI_LOADED then
            if val then notif("Auto Sell Pet ON", 3, "Sell") else notif("Auto Sell Pet OFF", 3, "Sell") end
        end
        if UI_LOADED and val then startSellLoop() end
    end
})

local SellPetsDropdown
SellPetsDropdown = SellSection:AddDropdown({
    Title = "Select Pets to Sell",
    Options = PET_LIST,
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.SellPets = handleDropdownChange(val, SellPetsDropdown)
    end
})

SellSection:AddToggle({
    Title = "Auto Sell Daily Deal",
    Content = "Automatically sell all items (5x multiplier) when the Daily Deal is available.",
    Default = false,
    Callback = function(val)
        Config.AutoSellDailyDeal = val
        if UI_LOADED and val then startSellLoop() end
    end
})

local dealPara = SellSection:AddParagraph({
    Title = "Daily Deal Status",
    Content = "Fetching data..."
})
_G.DailyDealParagraph = dealPara
startDailyDealCheckerLoop()

SellSection:AddDropdown({
    Title = "Sell Mode",
    Content = "Choose how to sell items",
    Options = {"Sell All", "Filter"},
    Default = "Sell All",
    Multi = false,
    Callback = function(val)
        Config.SellMode = val
    end
})

SellSection:AddInput({
    Title = "Sell All Delay (Seconds)",
    Content = "Delay loop for Sell All mode",
    Default = "2",
    Numeric = true,
    Callback = function(val)
        Config.SellAllDelay = tonumber(val) or 2
    end
})

local sellNamesOpts = {"None", "All"}
for _, s in ipairs(SEED_LIST) do
    if s ~= "None" then table.insert(sellNamesOpts, s) end
end
local SellNamesDropdown
SellNamesDropdown = SellSection:AddDropdown({
    Title = "Target Names (Filter Mode)",
    Options = sellNamesOpts,
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.SellNames = handleDropdownChange(val, SellNamesDropdown)
    end
})

local sellMutOpts = {"None", "All", "Non Mutasi"}
for _, m in ipairs(MUTATION_LIST) do
    if m ~= "None" then table.insert(sellMutOpts, m) end
end
local SellMutationsDropdown
SellMutationsDropdown = SellSection:AddDropdown({
    Title = "Target Mutations (Filter Mode)",
    Options = sellMutOpts,
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.SellMutations = handleDropdownChange(val, SellMutationsDropdown)
    end
})

SellSection:AddInput({
    Title = "Maximum Kg (0 = Sell All Kg)",
    Default = "0",
    Numeric = true,
    Callback = function(val)
        Config.SellMaxKg = tonumber(val) or 0
    end
})

local FavSection = MainTab:AddSection("Auto Favorite")

FavSection:AddToggle({
    Title = "Auto Favorite Fruit",
    Content = "Automatically favorite fruits based on criteria below",
    Default = false,
    Callback = function(val)
        Config.AutoFavFruit = val
        if UI_LOADED and val then startAutoFavLoop() end
    end
})

local autoFavOpts = {"None", "All"}
for _, s in ipairs(SEED_LIST) do
    if s ~= "None" then table.insert(autoFavOpts, s) end
end
local AutoFavNamesDropdown
AutoFavNamesDropdown = FavSection:AddDropdown({
    Title = "Fruit Name",
    Options = autoFavOpts,
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.AutoFavNames = handleDropdownChange(val, AutoFavNamesDropdown)
    end
})

local autoFavMutOpts = {"None", "All", "Non Mutasi"}
for _, m in ipairs(MUTATION_LIST) do
    if m ~= "None" then table.insert(autoFavMutOpts, m) end
end
local AutoFavMutationsDropdown
AutoFavMutationsDropdown = FavSection:AddDropdown({
    Title = "Mutation",
    Options = autoFavMutOpts,
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.AutoFavMutations = handleDropdownChange(val, AutoFavMutationsDropdown)
    end
})

FavSection:AddInput({
    Title = "Minimum Kg",
    Default = "0",
    Numeric = true,
    Callback = function(val)
        Config.AutoFavMinKg = tonumber(val) or 0
    end
})

FavSection:AddButton({
    Title = "Unfav All Fruits",
    Callback = function()
        task.spawn(function()
            local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
            local fruits = getInventoryFruits()
            local count = 0
            for _, f in ipairs(fruits) do
                if f.IsFavorite then
                    Networking.Backpack.SetFruitFavorite:Fire(f.Id, false)
                    count = count + 1
                    task.wait(0.1)
                end
            end
            if UI_LOADED then
                notif("Unfavorited " .. count .. " fruits!", 3, "Favorite")
            end
        end)
    end
})



end

local EGG_LIST = {}
pcall(function()
    local EggData = require(game:GetService("ReplicatedStorage").SharedModules:WaitForChild("EggData"))
    if EggData and EggData.Data then
        for _, egg in ipairs(EggData.Data) do
            if egg.EggName and not table.find(EGG_LIST, egg.EggName) then
                table.insert(EGG_LIST, egg.EggName)
            end
        end
        table.sort(EGG_LIST)
    end
end)

local PACK_LIST = {}
pcall(function()
    local SeedPackData = require(game:GetService("ReplicatedStorage").SharedModules:WaitForChild("SeedPackData"))
    if SeedPackData and SeedPackData.Data then
        for _, pack in ipairs(SeedPackData.Data) do
            if pack.PackName and not table.find(PACK_LIST, pack.PackName) then
                table.insert(PACK_LIST, pack.PackName)
            end
        end
    end
    local CrateData = require(game:GetService("ReplicatedStorage").SharedModules:WaitForChild("CrateData"))
    if CrateData and CrateData.GetAllCrates then
        for _, crate in ipairs(CrateData.GetAllCrates()) do
            if crate.Name and not table.find(PACK_LIST, crate.Name) then
                table.insert(PACK_LIST, crate.Name)
            end
        end
    end
    table.sort(PACK_LIST)
end)

local AUCTION_LIST = {}
for _, v in ipairs(SEED_LIST) do if v ~= "None" and not table.find(AUCTION_LIST, v) then table.insert(AUCTION_LIST, v) end end
for _, v in ipairs(GEAR_LIST) do if v ~= "None" and not table.find(AUCTION_LIST, v) then table.insert(AUCTION_LIST, v) end end
for _, v in ipairs(PROP_LIST) do if v ~= "None" and not table.find(AUCTION_LIST, v) then table.insert(AUCTION_LIST, v) end end
for _, v in ipairs(PET_LIST) do if v ~= "None" and not table.find(AUCTION_LIST, v) then table.insert(AUCTION_LIST, v) end end
for _, v in ipairs(EGG_LIST) do if v ~= "None" and not table.find(AUCTION_LIST, v) then table.insert(AUCTION_LIST, v) end end
for _, v in ipairs(PACK_LIST) do if v ~= "None" and not table.find(AUCTION_LIST, v) then table.insert(AUCTION_LIST, v) end end
table.sort(AUCTION_LIST)
table.insert(AUCTION_LIST, 1, "None")
table.insert(AUCTION_LIST, 2, "All")

local function extractAuctionDataMemory()
    local extractedLots, extractedStocks = {}, {}
    local extracted = false
    
    local success, err = pcall(function()
        local getuv = debug.getupvalue or getupvalue
        if not getuv then return end
        
        local ctrl = require(game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts", 5):WaitForChild("Controllers", 5):WaitForChild("AuctioneerController", 5))
        if not ctrl or type(ctrl.Start) ~= "function" then return end
        
        local _, u206 = getuv(ctrl.Start, 1)
        if type(u206) ~= "function" then return end
        
        local u144
        for i = 1, 80 do
            local name, val = getuv(u206, i)
            if name == nil then break end
            if name == "u144" then u144 = val; break end
        end
        
        if type(u144) == "function" then
            local u12, u13
            for i = 1, 30 do
                local name, val = getuv(u144, i)
                if name == nil then break end
                if name == "u12" then u12 = val end
                if name == "u13" then u13 = val end
            end
            
            if type(u12) == "table" then
                for _, lot in ipairs(u12) do
                    if type(lot) == "table" then
                        table.insert(extractedLots, lot)
                    end
                end
                extractedStocks = type(u13) == "table" and u13 or {}
                extracted = true
            end
        end
    end)
    
    if not extracted then
        pcall(function()
            local foundLots, foundStocks
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" then
                    if type(rawget(v, 1)) == "table" and rawget(v[1], "lotId") and rawget(v[1], "startPrice") then
                        if not foundLots then foundLots = v end
                    end
                    if rawget(v, "manifest") and type(rawget(v, "manifest")) == "table" and type(v.manifest.lots) == "table" then
                        local firstLot = rawget(v.manifest.lots, 1)
                        if firstLot and type(firstLot) == "table" and type(rawget(firstLot, "startPrice")) == "number" and rawget(firstLot, "decrementPercent") then
                            foundLots = v.manifest.lots
                            if type(rawget(v, "stock")) == "table" then foundStocks = v.stock end
                        end
                    end
                end
            end
            if foundLots then
                for _, lot in ipairs(foundLots) do
                    if type(lot) == "table" then
                        table.insert(extractedLots, lot)
                    end
                end
                if foundStocks then
                    for k, v in pairs(foundStocks) do
                        extractedStocks[k] = v
                    end
                end
                extracted = true
            end
        end)
    end
    
    return extractedLots, extractedStocks, extracted
end

local autoAuctionActive = false
local function startAuctionSnipeLoop()
    if autoAuctionActive then return end
    autoAuctionActive = true

    task.spawn(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Networking = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Networking"))
        local Auctioneer = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Auctioneer"))
        
        local lots = {}
        local stocks = {}
        local snipedLots = {}
        local snipeTickCounter = 0
        local lastHeartbeatTime = os.clock()
        
        -- Deep-copy a lot table to avoid shared reference mutation
        local function deepCopyLot(lot)
            if type(lot) ~= "table" then return lot end
            local copy = {}
            for k, v in pairs(lot) do
                if type(v) == "table" then
                    copy[k] = deepCopyLot(v)
                else
                    copy[k] = v
                end
            end
            return copy
        end
        
        -- Helper: re-extract auction data from game memory (deep-copies to avoid stale refs)
        local function refreshFromMemory()
            local exLots, exStocks, exOk = extractAuctionDataMemory()
            if exOk and #exLots > 0 then
                local copied = {}
                for _, lot in ipairs(exLots) do
                    table.insert(copied, deepCopyLot(lot))
                end
                lots = copied
                -- Deep-copy stocks too
                local copiedStocks = {}
                if type(exStocks) == "table" then
                    for k, v in pairs(exStocks) do copiedStocks[k] = v end
                end
                stocks = copiedStocks
                table.clear(snipedLots)
                return true
            end
            return false
        end
        
        -- Initial extraction
        local initOk = refreshFromMemory()
        warn("[AuctionSnipe] Loop started. Initial memory extraction: " .. (initOk and ("OK, " .. #lots .. " lots") or "FAILED"))
        
        -- Snapshot event listener
        local snapConn = Networking.Auctioneer.Snapshot.OnClientEvent:Connect(function(data)
            if type(data) == "table" then
                if data.manifest and type(data.manifest.lots) == "table" then
                    local newLots = {}
                    for _, lotData in pairs(data.manifest.lots) do
                        if type(lotData) == "table" and lotData.lotId ~= nil then
                            table.insert(newLots, deepCopyLot(lotData))
                        end
                    end
                    -- Merge by lotId instead of blind replace to prevent partial snapshots wiping data
                    if #newLots >= #lots or #lots == 0 then
                        lots = newLots
                    else
                        local lotMap = {}
                        for i, lot in ipairs(lots) do
                            if lot.lotId then lotMap[lot.lotId] = i end
                        end
                        for _, newLot in ipairs(newLots) do
                            local existingIdx = lotMap[newLot.lotId]
                            if existingIdx then
                                lots[existingIdx] = newLot
                            else
                                table.insert(lots, newLot)
                            end
                        end
                    end
                    table.clear(snipedLots)
                    warn("[AuctionSnipe] Snapshot received: " .. #lots .. " lots updated.")
                end
                if type(data.stock) == "table" then
                    for k,v in pairs(data.stock) do stocks[k] = v end
                end
            end
        end)
        
        local updateConn = Networking.Auctioneer.StockUpdate.OnClientEvent:Connect(function(data)
            if type(data) == "table" and type(data.stock) == "table" then
                for k,v in pairs(data.stock) do stocks[k] = v end
            end
        end)
        
        pcall(function() Networking.Auctioneer.RequestSnapshot:Fire() end)
        task.wait(2)
        
        local function getServerTime()
            local success, t = pcall(function() return workspace:GetServerTimeNow() end)
            return success and t or os.time()
        end

        local function parseTimeStr(tStr)
            if tStr == "10s" then return 10
            elseif tStr == "20s" then return 20
            elseif tStr == "30s" then return 30
            elseif tStr == "1m" then return 60
            elseif tStr == "2m" then return 120
            elseif tStr == "3m" then return 180
            elseif tStr == "5m" then return 300
            elseif tStr == "7m" then return 420
            elseif tStr == "10m" then return 600
            end
            return 10
        end

        -- Time-based restock detection: track which 30-min window we're in
        local currentRestockWindow = math.floor(getServerTime() / 1800)
        local restockRefreshing = false

        -- Full refresh: clear everything and re-acquire data
        local function fullRefresh(reason)
            warn("[AuctionSnipe] Full refresh triggered: " .. reason)
            restockRefreshing = true
            
            -- Clear old data completely
            lots = {}
            stocks = {}
            table.clear(snipedLots)
            _G._auctionSnipeFieldsLogged = nil
            
            -- Attempt 1: Request snapshot from server
            warn("[AuctionSnipe] Requesting fresh snapshot from server...")
            pcall(function() Networking.Auctioneer.RequestSnapshot:Fire() end)
            task.wait(3)
            
            if #lots > 0 then
                warn("[AuctionSnipe] Snapshot refresh berhasil! " .. #lots .. " lots.")
                restockRefreshing = false
                return
            end
            
            -- Attempt 2: Memory re-extraction
            warn("[AuctionSnipe] Snapshot kosong, mencoba memory re-extraction...")
            if refreshFromMemory() then
                warn("[AuctionSnipe] Memory refresh berhasil! " .. #lots .. " lots.")
                restockRefreshing = false
                return
            end
            
            -- Attempt 3: Wait longer and try both again
            warn("[AuctionSnipe] Data belum ready, menunggu 5 detik...")
            task.wait(5)
            pcall(function() Networking.Auctioneer.RequestSnapshot:Fire() end)
            task.wait(3)
            
            if #lots == 0 then
                refreshFromMemory()
            end
            
            if #lots > 0 then
                warn("[AuctionSnipe] Retry berhasil! " .. #lots .. " lots.")
            else
                warn("[AuctionSnipe] Data masih kosong. Akan retry di tick berikutnya.")
            end
            restockRefreshing = false
        end

        while Config.AutoBuyAuction and autoAuctionActive and _G.GagAutoScriptActive do
            local loopOk, loopErr = pcall(function()
                local now = getServerTime()
                local targetTime = parseTimeStr(Config.AuctionSnipeTime or "10s")
                local clockNow = os.clock()
                
                -- Heartbeat: log every 60 seconds to confirm loop is alive
                if (clockNow - lastHeartbeatTime) >= 60 then
                    lastHeartbeatTime = clockNow
                    local timeToRestock = math.max(0, (math.ceil(now / 1800) * 1800) - now)
                    warn("[AuctionSnipe] ♥ Alive | Lots: " .. #lots .. " | Restock in: " .. math.floor(timeToRestock) .. "s | Target: " .. targetTime .. "s")
                end
                
                -- Time-based restock detection: did we cross a 30-min boundary?
                local newWindow = math.floor(now / 1800)
                if newWindow ~= currentRestockWindow then
                    currentRestockWindow = newWindow
                    warn("[AuctionSnipe] ⏰ Restock window changed! Triggering full refresh...")
                    fullRefresh("30-min boundary crossed (window " .. newWindow .. ")")
                    return -- Skip this tick, let next iteration handle snipe
                end
                
                -- If lots is empty and not currently refreshing, try to get data
                if #lots == 0 and not restockRefreshing then
                    fullRefresh("lots table empty")
                    return
                end
                
                -- Normal snipe loop
                for _, lot in ipairs(lots) do
                    local lotId = lot.lotId
                    local stock = stocks[lotId]
                    
                    local isSoldOut = false
                    if stock == nil then
                        if lot.stockQuantity then isSoldOut = (lot.stockQuantity <= 0) end
                    else
                        isSoldOut = (stock <= 0)
                    end
                    
                    if not isSoldOut then
                        local itemName = lot.item or "Unknown"
                        if lot.count and lot.count > 1 then itemName = itemName .. " x" .. lot.count end
                        
                        local shouldSnipe = false
                        local baseName = lot.item or "Unknown"
                        if type(Config.AuctionSnipeItems) == "table" then
                            if table.find(Config.AuctionSnipeItems, "All") then
                                shouldSnipe = true
                            else
                                for _, target in ipairs(Config.AuctionSnipeItems) do
                                    if target ~= "None" and (target == baseName or string.find(baseName, target, 1, true)) then
                                        shouldSnipe = true
                                        break
                                    end
                                end
                            end
                        end
                        
                        if shouldSnipe then
                            local currentNow = getServerTime()
                            local expireTime = lot.expiresAt or lot.endTime or lot.endsAt or lot.expiry or 0
                            if expireTime == 0 and not _G._auctionSnipeFieldsLogged then
                                _G._auctionSnipeFieldsLogged = true
                                warn("[AuctionSnipe] No expire time field found for '" .. baseName .. "'. Lot fields:")
                                for k, v in pairs(lot) do warn("  " .. tostring(k) .. " = " .. tostring(v)) end
                            end
                            local timeLeft = math.max(0, expireTime - currentNow)
                            
                            -- Cek target time secara individual
                            if timeLeft > 0 and timeLeft <= targetTime and (not snipedLots[lotId] or (os.clock() - snipedLots[lotId]) > 3) then
                                local success, estPrice = pcall(function() return Auctioneer.CurrentPrice(lot, currentNow) end)
                                if not success then estPrice = lot.startPrice or 9999999999 end
                                
                                pcall(function()
                                    Networking.Auctioneer.PurchaseLot:Fire(lot.lotId, estPrice)
                                    snipedLots[lotId] = os.clock()
                                    if UI_LOADED then
                                        notif("Sniped " .. itemName .. " at " .. tostring(estPrice) .. "¢", 3, "Auction Snipe")
                                    end
                                end)
                                task.wait(0.2)
                            end
                        end
                    end
                end
                
                task.wait(0.5)
                snipeTickCounter = snipeTickCounter + 1
                
                -- Periodic snapshot refresh every ~15 seconds
                if snipeTickCounter >= 30 then
                    snipeTickCounter = 0
                    pcall(function() Networking.Auctioneer.RequestSnapshot:Fire() end)
                end
            end)
            
            if not loopOk then
                warn("[AuctionSnipe] ⚠ Loop error caught: " .. tostring(loopErr))
                task.wait(2) -- Wait a bit before retrying to avoid spam
            end
        end
        
        -- Log why the loop exited
        warn("[AuctionSnipe] Loop exited. AutoBuyAuction=" .. tostring(Config.AutoBuyAuction)
            .. " autoAuctionActive=" .. tostring(autoAuctionActive)
            .. " GagAutoScriptActive=" .. tostring(_G.GagAutoScriptActive))
        
        autoAuctionActive = false
        if snapConn then snapConn:Disconnect() end
        if updateConn then updateConn:Disconnect() end
    end)
end

local function ToggleAuctionUI()
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local CoreGui = game:GetService("CoreGui")

    local sgName = "PremiumAuctionUI"
    if CoreGui:FindFirstChild(sgName) then
        CoreGui[sgName]:Destroy()
        return
    end

    local Networking = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Networking"))
    local Auctioneer = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Auctioneer"))
    local NumberUtils = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("NumberUtils"))
    local LocalPlayer = Players.LocalPlayer

    local lots = {}
    local stocks = {}
    local lotUIs = {}
    local rollWindowUnix = 0

    local sg = Instance.new("ScreenGui")
    sg.Name = sgName
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    if syn then syn.protect_gui(sg) end
    sg.Parent = CoreGui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 520, 0, 360)
    main.Position = UDim2.new(0.5, -260, 0.5, -180)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    main.BackgroundTransparency = 0.1
    main.Active = true
    main.Draggable = true
    main.Parent = sg

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = main

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.85
    stroke.Thickness = 1
    stroke.Parent = main

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 45)
    header.BackgroundTransparency = 1
    header.Parent = main

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Auction Stock Tracker"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = header

    local restockLbl = Instance.new("TextLabel")
    restockLbl.Size = UDim2.new(1, -80, 0, 15)
    restockLbl.Position = UDim2.new(0, 18, 0, 26)
    restockLbl.BackgroundTransparency = 1
    restockLbl.Text = "Next Restock: Waiting..."
    restockLbl.TextColor3 = Color3.fromRGB(150, 255, 150)
    restockLbl.TextXAlignment = Enum.TextXAlignment.Left
    restockLbl.Font = Enum.Font.GothamSemibold
    restockLbl.TextSize = 12
    restockLbl.Parent = header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -45, 0, 6)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeBtn.BackgroundTransparency = 0.8
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 150, 150)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.Parent = header

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn

    closeBtn.MouseButton1Click:Connect(function()
        sg:Destroy()
    end)
    closeBtn.MouseEnter:Connect(function()
        closeBtn.BackgroundTransparency = 0.4
    end)
    closeBtn.MouseLeave:Connect(function()
        closeBtn.BackgroundTransparency = 0.8
    end)

    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, -40, 0, 1)
    sep.Position = UDim2.new(0, 20, 0, 45)
    sep.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sep.BackgroundTransparency = 0.85
    sep.Parent = main

    local cols = Instance.new("Frame")
    cols.Size = UDim2.new(1, -40, 0, 20)
    cols.Position = UDim2.new(0, 20, 0, 52)
    cols.BackgroundTransparency = 1
    cols.Parent = main

    local function createColHeader(text, xPos, width)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(width, 0, 1, 0)
        lbl.Position = UDim2.new(xPos, 0, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(160, 160, 160)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextSize = 11
        lbl.Parent = cols
    end

    createColHeader("ITEM", 0, 0.35)
    createColHeader("PRICE", 0.35, 0.2)
    createColHeader("STOCK", 0.55, 0.15)
    createColHeader("TIME", 0.7, 0.15)
    createColHeader("BUY", 0.85, 0.15)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -40, 1, -95)
    scroll.Position = UDim2.new(0, 20, 0, 75)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    scroll.ScrollBarImageTransparency = 0.5
    scroll.Parent = main

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = scroll

    local function formatTime(seconds)
        if type(seconds) ~= "number" or seconds <= 0 then return "0s" end
        local m = math.floor(seconds / 60)
        local s = math.floor(seconds % 60)
        if m >= 60 then
            local h = math.floor(m / 60)
            return string.format("%dh %dm", h, m % 60)
        else
            return string.format("%dm %02ds", m, s)
        end
    end

    local function getServerTime()
        local success, t = pcall(function() return workspace:GetServerTimeNow() end)
        return success and t or os.time()
    end

    local function formatPrice(price)
        if type(price) ~= "number" then return tostring(price) end
        if NumberUtils and NumberUtils.Abbreviate then
            return NumberUtils.Abbreviate(math.floor(price)) .. "¢"
        else
            local formatted = tostring(math.floor(price))
            while true do  
                formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
                if (k==0) then break end
            end
            return formatted .. "¢"
        end
    end

    local function rebuildUI()
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        table.clear(lotUIs)
        
        for _, lot in ipairs(lots) do
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, -5, 0, 40)
            f.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            f.BackgroundTransparency = 0.6
            f.Parent = scroll
            
            local fc = Instance.new("UICorner")
            fc.CornerRadius = UDim.new(0, 6)
            fc.Parent = f
            
            local fStroke = Instance.new("UIStroke")
            fStroke.Color = Color3.fromRGB(255, 255, 255)
            fStroke.Transparency = 0.9
            fStroke.Parent = f

            local itemName = lot.item or "Unknown"
            if lot.count and lot.count > 1 then
                itemName = itemName .. " x" .. lot.count
            end
            
            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(0.35, -10, 1, 0)
            nameLbl.Position = UDim2.new(0, 10, 0, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.TextColor3 = Color3.fromRGB(245, 245, 245)
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.Font = Enum.Font.GothamMedium
            nameLbl.TextSize = 13
            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
            nameLbl.Text = itemName
            nameLbl.Parent = f
            
            local priceLbl = Instance.new("TextLabel")
            priceLbl.Size = UDim2.new(0.2, 0, 1, 0)
            priceLbl.Position = UDim2.new(0.35, 0, 0, 0)
            priceLbl.BackgroundTransparency = 1
            priceLbl.TextColor3 = Color3.fromRGB(255, 215, 0)
            priceLbl.TextXAlignment = Enum.TextXAlignment.Left
            priceLbl.Font = Enum.Font.GothamSemibold
            priceLbl.TextSize = 13
            priceLbl.Text = "..."
            priceLbl.Parent = f
            
            local stockLbl = Instance.new("TextLabel")
            stockLbl.Size = UDim2.new(0.15, 0, 1, 0)
            stockLbl.Position = UDim2.new(0.55, 0, 0, 0)
            stockLbl.BackgroundTransparency = 1
            stockLbl.TextColor3 = Color3.fromRGB(100, 255, 140)
            stockLbl.TextXAlignment = Enum.TextXAlignment.Left
            stockLbl.Font = Enum.Font.GothamBold
            stockLbl.TextSize = 13
            stockLbl.Text = "..."
            stockLbl.Parent = f
            
            local timeLbl = Instance.new("TextLabel")
            timeLbl.Size = UDim2.new(0.15, 0, 1, 0)
            timeLbl.Position = UDim2.new(0.7, 0, 0, 0)
            timeLbl.BackgroundTransparency = 1
            timeLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
            timeLbl.TextXAlignment = Enum.TextXAlignment.Left
            timeLbl.Font = Enum.Font.Gotham
            timeLbl.TextSize = 12
            timeLbl.Text = "..."
            timeLbl.Parent = f
            
            local buyBtn = Instance.new("TextButton")
            buyBtn.Size = UDim2.new(0.12, 0, 0.6, 0)
            buyBtn.Position = UDim2.new(0.86, 0, 0.2, 0)
            buyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            buyBtn.Text = "Buy"
            buyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            buyBtn.Font = Enum.Font.GothamBold
            buyBtn.TextSize = 12
            buyBtn.Parent = f
            
            local buyCorner = Instance.new("UICorner")
            buyCorner.CornerRadius = UDim.new(0, 4)
            buyCorner.Parent = buyBtn
            
            buyBtn.MouseEnter:Connect(function()
                if buyBtn.Text == "Buy" then
                    buyBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 255)
                end
            end)
            buyBtn.MouseLeave:Connect(function()
                if buyBtn.Text == "Buy" then
                    buyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                end
            end)
            
            buyBtn.MouseButton1Click:Connect(function()
                pcall(function()
                    if buyBtn.Text ~= "Buy" then return end
                    buyBtn.Text = "..."
                    local serverTime = workspace:GetServerTimeNow()
                    local estPrice = lot.startPrice or 9999999999
                    pcall(function() estPrice = Auctioneer.CurrentPrice(lot, serverTime) end)
                    Networking.Auctioneer.PurchaseLot:Fire(lot.lotId, estPrice)
                    task.wait(1)
                    buyBtn.Text = "Buy"
                end)
            end)
            
            lotUIs[lot.lotId] = {
                frame = f,
                lot = lot,
                priceLbl = priceLbl,
                stockLbl = stockLbl,
                timeLbl = timeLbl,
                buyBtn = buyBtn
            }
        end
        
        scroll.CanvasSize = UDim2.new(0, 0, 0, #(lots or {}) * 48)
    end

    local needsRebuild = false

    local function fetchSnapshot()
        task.spawn(function()
            local exLots, exStocks, exOk = extractAuctionDataMemory()
            if exOk then
                lots = exLots
                stocks = exStocks
                needsRebuild = true
            end
            
            task.spawn(function()
                while true do
                    if not sg.Parent then break end
                    pcall(function() Networking.Auctioneer.RequestSnapshot:Fire() end)
                    task.wait(15)
                end
            end)
        end)
    end

    fetchSnapshot()

    local snapConn
    snapConn = Networking.Auctioneer.Snapshot.OnClientEvent:Connect(function(data)
        if type(data) == "table" then
            if type(data.rollWindowUnix) == "number" then rollWindowUnix = data.rollWindowUnix end
            if data.manifest and type(data.manifest.lots) == "table" then
                local newLots = {}
                for _, lotData in pairs(data.manifest.lots) do
                    if type(lotData) == "table" and lotData.lotId ~= nil then table.insert(newLots, lotData) end
                end
                -- Merge by lotId instead of blind replace to prevent partial snapshots wiping data
                if #newLots >= #lots or #lots == 0 then
                    lots = newLots
                else
                    local lotMap = {}
                    for i, lot in ipairs(lots) do
                        if lot.lotId then lotMap[lot.lotId] = i end
                    end
                    for _, newLot in ipairs(newLots) do
                        local existingIdx = lotMap[newLot.lotId]
                        if existingIdx then
                            lots[existingIdx] = newLot
                        else
                            table.insert(lots, newLot)
                        end
                    end
                end
                needsRebuild = true
            end
            if type(data.stock) == "table" then
                for k,v in pairs(data.stock) do stocks[k] = v end
            end
        end
    end)

    local updateConn
    updateConn = Networking.Auctioneer.StockUpdate.OnClientEvent:Connect(function(data)
        if type(data) == "table" and type(data.stock) == "table" then
            for k,v in pairs(data.stock) do stocks[k] = v end
        end
    end)

    task.spawn(function()
        while true do
            if not sg.Parent then
                if snapConn then snapConn:Disconnect() end
                if updateConn then updateConn:Disconnect() end
                break
            end
            
            if needsRebuild then
                needsRebuild = false
                pcall(rebuildUI)
            end
            
            local now = getServerTime()
            
            for lotId, ui in pairs(lotUIs) do
                local lot = ui.lot
                local stock = stocks[lotId]
                
                local timeLeft = math.max(0, (lot.expiresAt or 0) - now)
                ui.timeLbl.Text = formatTime(timeLeft)
                
                local success, price = pcall(function() return Auctioneer.CurrentPrice(lot, now) end)
                if success then ui.priceLbl.Text = formatPrice(price) end
                
                local isSoldOut = false
                if stock == nil then
                    if lot.stockQuantity then
                        ui.stockLbl.Text = tostring(lot.stockQuantity)
                        isSoldOut = (lot.stockQuantity <= 0)
                    else
                        ui.stockLbl.Text = "Unlimited"
                    end
                else
                    ui.stockLbl.Text = tostring(math.floor(stock))
                    isSoldOut = (stock <= 0)
                end
                
                local isBuyable = true
                if isSoldOut then
                    ui.stockLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
                    ui.stockLbl.Text = "Sold Out"
                    ui.buyBtn.Text = "Sold"
                    ui.buyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                    isBuyable = false
                else
                    ui.stockLbl.TextColor3 = Color3.fromRGB(100, 255, 140)
                end
                
                if timeLeft <= 0 then
                    ui.timeLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
                    ui.timeLbl.Text = "Expired"
                    ui.buyBtn.Text = "Ended"
                    ui.buyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                    isBuyable = false
                else
                    ui.timeLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
                end
                
                if isBuyable and ui.buyBtn.Text ~= "..." then
                    ui.buyBtn.Text = "Buy"
                    ui.buyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                end
            end
            
            local nextRestockUnix = math.ceil(now / 1800) * 1800
            local timeToRestock = math.max(0, nextRestockUnix - now)
            if timeToRestock > 0 then
                restockLbl.Text = "Next Restock: " .. formatTime(timeToRestock)
            else
                restockLbl.Text = "Next Restock: Rolling..."
            end
            
            task.wait(0.1)
        end
    end)
end

local autoPetFinderHopActive = false
local startPetFinderHopLoop  -- forward declare agar bisa diakses di luar LoadShopTab
local autoJoinPetFinderActive = false
local startJoinPetFinderLoop

local function LoadShopTab()
-- TAB SHOP
local ShopTab = Tabs:AddTab({ Name = "Shop", Icon = "shopping-cart" })
local SeedShopSection = ShopTab:AddSection("Seed Shop")
SeedShopSection:AddToggle({
    Title = "Auto Buy Seed",
    Title2 = "Enable",
    Default = false,
    Callback = function(val)
        Config.AutoBuySeed = val
        if UI_LOADED and val then startBuyLoop() end
    end
})
local BuySeedDropdown
BuySeedDropdown = SeedShopSection:AddDropdown({
    Title = "Select Seed",
    Options = SEED_LIST,
    Default = {"None"},
    Multi = true,
    Callback = function(val) 
        Config.SeedToBuy = handleDropdownChange(val, BuySeedDropdown)
    end
})

local GearShopSection = ShopTab:AddSection("Gear Shop")
GearShopSection:AddToggle({
    Title = "Auto Buy Gear",
    Title2 = "Enable",
    Default = false,
    Callback = function(val)
        Config.AutoBuyGear = val
        if UI_LOADED and val then startBuyLoop() end
    end
})
local BuyGearDropdown
BuyGearDropdown = GearShopSection:AddDropdown({
    Title = "Select Gear",
    Options = GEAR_LIST,
    Default = {"None"},
    Multi = true,
    Callback = function(val) 
        Config.GearToBuy = handleDropdownChange(val, BuyGearDropdown)
    end
})

local PropShopSection = ShopTab:AddSection("Prop/Crate Shop")
PropShopSection:AddToggle({
    Title = "Auto Buy Prop/Crate",
    Title2 = "Enable",
    Default = false,
    Callback = function(val)
        Config.AutoBuyProp = val
        if UI_LOADED and val then startBuyLoop() end
    end
})
local BuyPropDropdown
BuyPropDropdown = PropShopSection:AddDropdown({
    Title = "Select Prop/Crate",
    Options = PROP_LIST,
    Default = {"None"},
    Multi = true,
    Callback = function(val) 
        Config.PropToBuy = handleDropdownChange(val, BuyPropDropdown)
    end
})

local AuctionSection = ShopTab:AddSection("Auction Snipe")
AuctionSection:AddToggle({
    Title = "Auto Buy Auction",
    Title2 = "Enable",
    Content = "Automatically snipe items in auction when countdown reaches the target time.",
    Default = false,
    Callback = function(val)
        Config.AutoBuyAuction = val
        if UI_LOADED and val then startAuctionSnipeLoop() end
    end
})
local AuctionSnipeDropdown
AuctionSnipeDropdown = AuctionSection:AddDropdown({
    Title = "Select Items to Snipe",
    Options = AUCTION_LIST,
    Default = {"None"},
    Multi = true,
    Callback = function(val) 
        Config.AuctionSnipeItems = handleDropdownChange(val, AuctionSnipeDropdown)
    end
})
AuctionSection:AddDropdown({
    Title = "Snipe When Countdown At",
    Options = {"10s", "20s", "30s", "1m", "2m", "3m", "5m", "7m", "10m"},
    Default = "10s",
    Multi = false,
    Callback = function(val)
        Config.AuctionSnipeTime = val
    end
})

AuctionSection:AddButton({
    Title = "Show/Hide Auction Tracker",
    Content = "Buka/Tutup jendela UI Premium Auction Tracker",
    Callback = function()
        ToggleAuctionUI()
    end
})

-- ============================================================
-- AUTO PET FINDER HOP & JOIN HELPER (WAIT FOR CLAIM)
-- ============================================================
local function waitForTargetPetClaim(targets, notifTitle)
    if not targets or #targets == 0 or targets[1] == "None" then return false end
    
    local map = workspace:FindFirstChild("Map")
    if not map then return false end
    
    local function getMatchingPetStatus()
        local foundUnowned = false
        local foundOwnedByUs = false
        
        local folders = {}
        local ref = map:FindFirstChild("WildPetRef")
        local spawns = map:FindFirstChild("WildPetSpawns")
        if ref then table.insert(folders, ref) end
        if spawns then table.insert(folders, spawns) end
        
        for _, folder in ipairs(folders) do
            for _, pet in ipairs(folder:GetChildren()) do
                local pName = pet:GetAttribute("PetName")
                if not pName and pet:IsA("Model") then
                    local rawName = string.match(pet.Name, "WildPet_(.-)_WildPet") or "Unknown"
                    pName, _, _ = parsePetName(rawName)
                end
                
                if pName then
                    for _, target in ipairs(targets) do
                        local tLower = string.lower(target)
                        if tLower == "all" or tLower == "any" or string.lower(pName) == tLower or string.find(string.lower(pName), tLower) then
                            local ownerId = pet:GetAttribute("OwnerUserId")
                            if not ownerId or ownerId == 0 then
                                foundUnowned = true
                            elseif ownerId == LocalPlayer.UserId then
                                foundOwnedByUs = true
                            end
                            break
                        end
                    end
                end
            end
        end
        
        return foundUnowned, foundOwnedByUs
    end

    local foundUnowned, foundOwnedByUs = getMatchingPetStatus()
    if not foundUnowned and not foundOwnedByUs then
        return false
    end

    print("Pet Finder: Target pet detected in server! Entering wait & claim loop...")
    setEmergencyStopVisible(false)
    
    local initialPetCount = #getInventoryPets()
    local hasTamed = foundOwnedByUs
    local lastNotifTime = 0
    
    while _G.GagAutoScriptActive do
        if not Config.AutoPetFinderHop and not Config.AutoJoinPetFinder then break end
        
        foundUnowned, foundOwnedByUs = getMatchingPetStatus()
        
        if foundOwnedByUs then
            hasTamed = true
        end
        
        if foundUnowned or foundOwnedByUs then
            if os.clock() - lastNotifTime > 5 then
                lastNotifTime = os.clock()
                if foundOwnedByUs then
                    notif("Pet berhasil di-tame! Menunggu masuk ke inventory...", 4, notifTitle or "Auto Pet Finder")
                else
                    notif("Target pet ada di garden! Menunggu Auto Buy Pet...", 4, notifTitle or "Auto Pet Finder")
                end
            end
            task.wait(0.5)
        else
            if hasTamed then
                notif("Pet tamed! Verifikasi klaim ke inventory...", 3, notifTitle or "Auto Pet Finder")
                local claimVerified = false
                local startVerify = os.clock()
                while os.clock() - startVerify < 8 and _G.GagAutoScriptActive do
                    if #getInventoryPets() > initialPetCount then
                        claimVerified = true
                        break
                    end
                    task.wait(0.5)
                end
                if claimVerified then
                    notif("Pet sukses terclaim & masuk inventory! Melanjutkan hop...", 5, notifTitle or "Auto Pet Finder")
                else
                    notif("Pet selesai diproses di garden. Melanjutkan hop...", 4, notifTitle or "Auto Pet Finder")
                end
                task.wait(2)
            end
            break
        end
    end
    
    return true
end

-- ============================================================
-- AUTO PET FINDER HOP
-- ============================================================
startPetFinderHopLoop = function()
    if autoPetFinderHopActive then return end
    autoPetFinderHopActive = true
    setEmergencyStopVisible(true)
    task.wait(10)
    
    task.spawn(function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        print("Auto Pet Finder Hop Active (Random Hop Mode)")
        
        while Config.AutoPetFinderHop and autoPetFinderHopActive and _G.GagAutoScriptActive do
            if not Config.PetFinderHopTarget or #Config.PetFinderHopTarget == 0 or Config.PetFinderHopTarget[1] == "None" then
                setEmergencyStopVisible(false)
                notif("Pet Finder: Pilih Pet terlebih dahulu", 5, "Auto Pet Finder")
                task.wait(2)
                continue
            end
            
            if waitForTargetPetClaim(Config.PetFinderHopTarget, "Auto Pet Finder") then
                continue
            end
            
            setEmergencyStopVisible(true)
            notif("Pet not found in server. Random hopping...", 4, "Auto Pet Finder")
            _G.SuppressAutoReconnect = true
            
            pcall(function()
                if writefile then
                    writefile("Napoleon_GAG_PetHop_Visited.json", game:GetService("HttpService"):JSONEncode({active = true, target = Config.PetFinderHopTarget, lastHopTime = os.time(), mode = "random"}))
                end
            end)
            
            local placeId = game.PlaceId
            local currentJobId = game.JobId
            local url = "https://games.roblox.com/v1/games/" .. tostring(placeId) .. "/servers/Public?sortOrder=Asc&limit=100"
            
            local success, response = pcall(function()
                return game:HttpGet(url)
            end)
            
            if success and response then
                local decodeSuccess, data = pcall(function()
                    return HttpService:JSONDecode(response)
                end)
                if decodeSuccess and data and data.data then
                    local servers = data.data
                    for i = #servers, 2, -1 do
                        local j = math.random(i)
                        servers[i], servers[j] = servers[j], servers[i]
                    end
                    for _, server in ipairs(servers) do
                        if not Config.AutoPetFinderHop then break end
                        if server.playing and server.maxPlayers and server.playing < server.maxPlayers and server.playing > 0 and server.id ~= currentJobId then
                            local tpSuccess, tpError = pcall(function()
                                TeleportService:TeleportToPlaceInstance(placeId, server.id, game.Players.LocalPlayer)
                            end)
                            if tpSuccess then
                                local failed = false
                                local conn
                                conn = TeleportService.TeleportInitFailed:Connect(function(plr, result, msg)
                                    if plr == game.Players.LocalPlayer then
                                        failed = true
                                        game:GetService("GuiService"):ClearError()
                                        notif("Server full/closed. Trying another...", 3, "Auto Pet Finder")
                                        conn:Disconnect()
                                    end
                                end)
                                for i = 1, 10 do
                                    task.wait(1)
                                    if failed or not Config.AutoPetFinderHop then break end
                                end
                                if conn then conn:Disconnect() end
                                if not failed and Config.AutoPetFinderHop then
                                    task.wait(10)
                                    break
                                end
                            else
                                task.wait(1)
                            end
                        end
                    end
                end
            end
            
            if Config.AutoPetFinderHop then
                task.wait(3)
            end
            _G.SuppressAutoReconnect = false
        end
        
        autoPetFinderHopActive = false
        setEmergencyStopVisible(false)
    end)
end

startJoinPetFinderLoop = function()
    if autoJoinPetFinderActive then return end
    autoJoinPetFinderActive = true
    
    task.spawn(function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        print("Auto Join Pet Finder Active (Global API Mode)")
        
        while Config.AutoJoinPetFinder and autoJoinPetFinderActive and _G.GagAutoScriptActive do
            if not Config.PetFinderHopTarget or #Config.PetFinderHopTarget == 0 or Config.PetFinderHopTarget[1] == "None" then
                setEmergencyStopVisible(false)
                notif("Pet Finder: Pilih Pet terlebih dahulu", 5, "Auto Pet Finder")
                task.wait(2)
                continue
            end
            
            if waitForTargetPetClaim(Config.PetFinderHopTarget, "Auto Pet Finder") then
                continue
            end
            
            setEmergencyStopVisible(true)
            
            local allFoundPets = {}
            print("Pet Finder: Fetching data for selected targets...")
            local reqBody = HttpService:JSONEncode({
                action = "fetch",
                targets = Config.PetFinderHopTarget,
                rarities = {},
                mutations = {},
                key = key,
                hwid = hwid
            })
            
            local payloadXOR = encryptXOR(reqBody, SECRET_KEY)
            local sig = customSign(payloadXOR, SERVER_PUBLIC_KEY)
            local encryptedBody = HttpService:JSONEncode({
                payload = payloadXOR,
                sig = sig
            })
            
            local success, res = pcall(function()
                local requestFunc = syn and syn.request or http_request or request
                if requestFunc then
                    local r = requestFunc({
                        Url = PET_API_URL,
                        Method = "POST",
                        Headers = { ["Content-Type"] = "application/json" },
                        Body = encryptedBody
                    })
                    return r.Body
                else
                    return game:HttpPost(PET_API_URL, encryptedBody, "application/json")
                end
            end)
            
            if success and res and res ~= "" then
                local decoded = verifyPetResponse(res)
                if decoded and decoded.success and decoded.data then
                    for _, pet in ipairs(decoded.data) do
                        if pet.despawnTime and pet.despawnTime > os.time() + 15 and pet.serverId ~= game.JobId then
                            table.insert(allFoundPets, pet)
                        end
                    end
                end
            end
            
            table.sort(allFoundPets, function(a, b) return a.despawnTime > b.despawnTime end)
            
            if #allFoundPets > 0 then
                for _, pet in ipairs(allFoundPets) do
                    if not Config.AutoJoinPetFinder then break end
                    
                    notif("Found " .. pet.petName .. "! Hopping server...", 4, "Auto Pet Finder")
                    _G.SuppressAutoReconnect = true
                    
                    pcall(function()
                        if writefile then
                            writefile("Napoleon_GAG_PetHop_Visited.json", game:GetService("HttpService"):JSONEncode({active = true, target = Config.PetFinderHopTarget, lastHopTime = os.time(), mode = "join"}))
                        end
                    end)
                    
                    local tpSuccess, tpError = pcall(function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, pet.serverId, game.Players.LocalPlayer)
                    end)
                    
                    if tpSuccess then
                        local failed = false
                        local conn
                        conn = TeleportService.TeleportInitFailed:Connect(function(plr, result, msg)
                            if plr == game.Players.LocalPlayer then
                                failed = true
                                game:GetService("GuiService"):ClearError()
                                notif("Server full/closed. Trying another...", 3, "Auto Pet Finder")
                                conn:Disconnect()
                            end
                        end)
                        
                        for i = 1, 10 do
                            task.wait(1)
                            if failed or not Config.AutoJoinPetFinder then break end
                        end
                        if conn then conn:Disconnect() end
                        
                        if not failed and Config.AutoJoinPetFinder then
                            task.wait(10)
                        end
                    else
                        notif("Teleport err: " .. tostring(tpError), 3, "Auto Pet Finder")
                        task.wait(1)
                    end
                    _G.SuppressAutoReconnect = false
                end
            else
                task.wait(3) -- Fast polling if nothing found
            end
        end
        
        autoJoinPetFinderActive = false
        setEmergencyStopVisible(false)
    end)
end

local WildPetSection = ShopTab:AddSection("Wild Pets")
WildPetSection:AddToggle({
    Title = "Auto Buy Wild Pet",
    Title2 = "Enable",
    Content = "Automatically teleport and buy spawned pets",
    Default = false,
    Callback = function(val)
        Config.AutoTamePet = val
        if UI_LOADED and val then startTameLoop() end
    end
})
local TamePetsDropdown
TamePetsDropdown = WildPetSection:AddDropdown({
    Title = "Select Pets",
    Options = PET_LIST,
    Default = {"None"},
    Multi = true,
    Callback = function(val) 
        Config.TamePets = handleDropdownChange(val, TamePetsDropdown)
    end
})

local function parseSuffixNumber(str)
    if not str or str == "" then return nil end
    str = tostring(str):gsub("[%s%c,_]", ""):lower()
    local num = tonumber(str)
    if num then return num end
    local valStr, suffix = string.match(str, "^([%d%.]+)([a-z]+)$")
    if not valStr then return nil end
    local val = tonumber(valStr)
    if not val then return nil end
    if suffix == "k" or suffix == "rb" or suffix == "thousand" then return val * 1e3
    elseif suffix == "m" or suffix == "mil" or suffix == "million" or suffix == "jt" or suffix == "juta" then return val * 1e6
    elseif suffix == "b" or suffix == "bil" or suffix == "billion" or suffix == "milyar" then return val * 1e9
    elseif suffix == "t" or suffix == "tril" or suffix == "trillion" or suffix == "triliun" then return val * 1e12
    end
    return nil
end

Config.MaxTamePrice = math.huge
WildPetSection:AddInput({
    Title = "Max Buy Price",
    Content = "Limit auto buy price (e.g. 1k, 1m, 1.5b)",
    Default = "",
    Callback = function(val)
        if not val or val == "" or tostring(val):gsub("[%s%c]", "") == "" or tostring(val):gsub("[%s%c]", "") == "0" then
            Config.MaxTamePrice = math.huge
            notif("Max Buy Price limit cleared (UNLIMITED)", 3, "Wild Pets")
        else
            local parsed = parseSuffixNumber(val)
            if parsed then
                Config.MaxTamePrice = parsed
                notif("Max Buy Price limit set to: " .. tostring(parsed), 3, "Wild Pets")
            else
                notif("Invalid price format! Limit unchanged (" .. (Config.MaxTamePrice == math.huge and "Unlimited" or tostring(Config.MaxTamePrice)) .. ")", 4, "Wild Pets")
            end
        end
    end
})

Config.ProtectWildPet = true
WildPetSection:AddToggle({
    Title = "Protect Pet After Buy",
    Content = "Automatically teleport to pet and auto shovel to protect it after taming",
    Default = true,
    Callback = function(val)
        Config.ProtectWildPet = val
    end
})

WildPetSection:AddToggle({
    Title = "Auto Finder Hop Random Server",
    Content = "Automatically server hop to random servers until selected wild pets are found",
    Default = false,
    Callback = function(val)
        Config.AutoPetFinderHop = val
        if val then
            if Config.AutoJoinPetFinder then
                notif("Please disable Auto Join Pet Finder first!", 4, "Auto Pet Finder")
            end
            if UI_LOADED then startPetFinderHopLoop() end
        else
            autoPetFinderHopActive = false
            setEmergencyStopVisible(false)
            pcall(function()
                if writefile then
                    writefile("Napoleon_GAG_PetHop_Visited.json", game:GetService("HttpService"):JSONEncode({active = false, target = {"None"}, lastHopTime = 0}))
                end
            end)
        end
    end
})

WildPetSection:AddToggle({
    Title = "Auto Join Global Pet Finder",
    Content = "Automatically query global pet database and join server with selected wild pets",
    Default = false,
    Callback = function(val)
        Config.AutoJoinPetFinder = val
        if val then
            if Config.AutoPetFinderHop then
                notif("Please disable Auto Finder Hop first!", 4, "Auto Pet Finder")
            end
            if UI_LOADED then startJoinPetFinderLoop() end
        else
            autoJoinPetFinderActive = false
            setEmergencyStopVisible(false)
            pcall(function()
                if writefile then
                    writefile("Napoleon_GAG_PetHop_Visited.json", game:GetService("HttpService"):JSONEncode({active = false, target = {"None"}, lastHopTime = 0}))
                end
            end)
        end
    end
})

local PetFinderHopDropdown
PetFinderHopDropdown = WildPetSection:AddDropdown({
    Title = "Select Pet to Find / Join",
    Options = PET_LIST,
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.PetFinderHopTarget = handleDropdownChange(val, PetFinderHopDropdown)
    end
})

local petFinderToggle

local function createPetFinderUI()
    local coreGui = game:GetService("CoreGui")
    if coreGui:FindFirstChild("GagPetFinder") then
        coreGui.GagPetFinder:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GagPetFinder"
    screenGui.Parent = coreGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 520, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -260, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14) -- Napoleon Dark
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(81, 66, 255) -- Napoleon Purple
    mainStroke.Thickness = 1
    mainStroke.Transparency = 0.3
    mainStroke.Parent = mainFrame
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = mainFrame
    
    local logoImage = Instance.new("ImageLabel")
    logoImage.Size = UDim2.new(0, 26, 0, 26)
    logoImage.Position = UDim2.new(0, 12, 0, 9)
    logoImage.BackgroundTransparency = 1
    logoImage.Image = "rbxassetid://136289055140268"
    logoImage.Parent = mainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -45, 0, 45)
    titleLabel.Position = UDim2.new(0, 45, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Napoleon Pet Finder"
    titleLabel.TextColor3 = Color3.fromRGB(200, 190, 255)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = mainFrame
    
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(0, 90, 0, 30)
    refreshBtn.Position = UDim2.new(1, -140, 0, 7)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(81, 66, 255)
    refreshBtn.Text = "Refresh"
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.TextSize = 14
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.Parent = mainFrame
    
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 4)
    refreshCorner.Parent = refreshBtn
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -40, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = mainFrame
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        if petFinderToggle then
            pcall(function() petFinderToggle:Set(false) end)
        end
    end)
    
    local fetchPets -- Forward declaration
    
    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -20, 0, 34)
    searchBox.Position = UDim2.new(0, 10, 0, 45)
    searchBox.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    searchBox.PlaceholderText = "Search Pet Name..."
    searchBox.Text = ""
    searchBox.TextColor3 = Color3.fromRGB(220, 220, 220)
    searchBox.TextSize = 13
    searchBox.Font = Enum.Font.Gotham
    searchBox.Parent = mainFrame
    
    local searchStroke = Instance.new("UIStroke")
    searchStroke.Color = Color3.fromRGB(60, 60, 70)
    searchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    searchStroke.Transparency = 0.5
    searchStroke.Parent = searchBox
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 6)
    searchCorner.Parent = searchBox
    
    local selectedRarities = {}
    local selectedMutations = {}
    
    local function getLabelText(tbl, def)
        local count = 0
        for _, _ in pairs(tbl) do count = count + 1 end
        if count == 0 then return def end
        if count == 1 then
            for k, _ in pairs(tbl) do return k end
        end
        return count .. " Selected"
    end
    
    -- RARITY FILTER
    local rarityFilterBtn = Instance.new("TextButton")
    rarityFilterBtn.Size = UDim2.new(0.5, -14, 0, 32)
    rarityFilterBtn.Position = UDim2.new(0, 10, 0, 85)
    rarityFilterBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    rarityFilterBtn.Text = "All Rarities"
    rarityFilterBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    rarityFilterBtn.TextSize = 13
    rarityFilterBtn.Font = Enum.Font.Gotham
    rarityFilterBtn.Parent = mainFrame
    
    local rarityStroke = Instance.new("UIStroke")
    rarityStroke.Color = Color3.fromRGB(60, 60, 70)
    rarityStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    rarityStroke.Transparency = 0.5
    rarityStroke.Parent = rarityFilterBtn
    
    local rarityBtnCorner = Instance.new("UICorner")
    rarityBtnCorner.CornerRadius = UDim.new(0, 6)
    rarityBtnCorner.Parent = rarityFilterBtn
    
    local rarityDropdown = Instance.new("ScrollingFrame")
    rarityDropdown.Size = UDim2.new(0.5, -14, 0, 120)
    rarityDropdown.Position = UDim2.new(0, 10, 0, 120)
    rarityDropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    rarityDropdown.BorderSizePixel = 0
    rarityDropdown.ZIndex = 10
    rarityDropdown.Visible = false
    rarityDropdown.ScrollBarThickness = 4
    rarityDropdown.Parent = mainFrame
    
    local rLayout = Instance.new("UIListLayout")
    rLayout.Parent = rarityDropdown
    
    local rarities = {"All Rarities"}
    for _, r in ipairs(RARITY_LIST) do table.insert(rarities, r) end
    for _, r in ipairs(rarities) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = "  " .. r
        optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        optBtn.TextSize = 14
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.ZIndex = 11
        optBtn.Parent = rarityDropdown
        
        optBtn.MouseButton1Click:Connect(function()
            if r == "All Rarities" then
                selectedRarities = {}
                for _, child in ipairs(rarityDropdown:GetChildren()) do
                    if child:IsA("TextButton") then child.TextColor3 = Color3.fromRGB(200, 200, 200) end
                end
            else
                if selectedRarities[r] then
                    selectedRarities[r] = nil
                    optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                else
                    selectedRarities[r] = true
                    optBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
                end
            end
            rarityFilterBtn.Text = getLabelText(selectedRarities, "All Rarities")
            if fetchPets then fetchPets() end
        end)
    end
    rarityDropdown.CanvasSize = UDim2.new(0, 0, 0, #rarities * 30)
    
    -- MUTATION FILTER
    local mutationFilterBtn = Instance.new("TextButton")
    mutationFilterBtn.Size = UDim2.new(0.5, -14, 0, 32)
    mutationFilterBtn.Position = UDim2.new(0.5, 4, 0, 85)
    mutationFilterBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    mutationFilterBtn.Text = "All Mutations"
    mutationFilterBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    mutationFilterBtn.TextSize = 13
    mutationFilterBtn.Font = Enum.Font.Gotham
    mutationFilterBtn.Parent = mainFrame
    
    local mutationStroke = Instance.new("UIStroke")
    mutationStroke.Color = Color3.fromRGB(60, 60, 70)
    mutationStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    mutationStroke.Transparency = 0.5
    mutationStroke.Parent = mutationFilterBtn
    
    local mutationBtnCorner = Instance.new("UICorner")
    mutationBtnCorner.CornerRadius = UDim.new(0, 6)
    mutationBtnCorner.Parent = mutationFilterBtn
    
    local mutationDropdown = Instance.new("ScrollingFrame")
    mutationDropdown.Size = UDim2.new(0.5, -14, 0, 120)
    mutationDropdown.Position = UDim2.new(0.5, 4, 0, 120)
    mutationDropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    mutationDropdown.BorderSizePixel = 0
    mutationDropdown.ZIndex = 10
    mutationDropdown.Visible = false
    mutationDropdown.ScrollBarThickness = 4
    mutationDropdown.Parent = mainFrame
    
    local mLayout = Instance.new("UIListLayout")
    mLayout.Parent = mutationDropdown
    
    local mutationsList = {"All Mutations", "None", "Golden", "Big", "Rainbow", "Huge", "Giant", "Tiny", "Radioactive"}
    if MUTATION_LIST then
        for _, m in ipairs(MUTATION_LIST) do
            if m ~= "None" and not table.find(mutationsList, m) then
                table.insert(mutationsList, m)
            end
        end
    end
    for _, m in ipairs(mutationsList) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = "  " .. m
        optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        optBtn.TextSize = 14
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.ZIndex = 11
        optBtn.Parent = mutationDropdown
        
        optBtn.MouseButton1Click:Connect(function()
            if m == "All Mutations" then
                selectedMutations = {}
                for _, child in ipairs(mutationDropdown:GetChildren()) do
                    if child:IsA("TextButton") then child.TextColor3 = Color3.fromRGB(200, 200, 200) end
                end
            else
                if selectedMutations[m] then
                    selectedMutations[m] = nil
                    optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                else
                    selectedMutations[m] = true
                    optBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
                end
            end
            mutationFilterBtn.Text = getLabelText(selectedMutations, "All Mutations")
            if fetchPets then fetchPets() end
        end)
    end
    mutationDropdown.CanvasSize = UDim2.new(0, 0, 0, #mutationsList * 30)
    
    rarityFilterBtn.MouseButton1Click:Connect(function()
        rarityDropdown.Visible = not rarityDropdown.Visible
        mutationDropdown.Visible = false
    end)
    
    mutationFilterBtn.MouseButton1Click:Connect(function()
        mutationDropdown.Visible = not mutationDropdown.Visible
        rarityDropdown.Visible = false
    end)
    
    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, -20, 1, -130)
    listFrame.Position = UDim2.new(0, 10, 0, 125)
    listFrame.BackgroundTransparency = 1
    listFrame.ScrollBarThickness = 4
    listFrame.Parent = mainFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = listFrame
    
    fetchPets = function()
        for _, child in ipairs(listFrame:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end
        
        local loadingLabel = Instance.new("TextLabel")
        loadingLabel.Size = UDim2.new(1, 0, 0, 30)
        loadingLabel.BackgroundTransparency = 1
        loadingLabel.Text = "Fetching live pet data..."
        loadingLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        loadingLabel.TextSize = 14
        loadingLabel.Font = Enum.Font.Gotham
        loadingLabel.Parent = listFrame
        
        local reqBody = HttpService:JSONEncode({
            action = "fetch",
            search = string.lower(searchBox.Text),
            rarities = selectedRarities,
            mutations = selectedMutations,
            key = key,
            hwid = hwid
        })
        
        local payloadXOR = encryptXOR(reqBody, SECRET_KEY)
        local sig = customSign(payloadXOR, SERVER_PUBLIC_KEY)
        local encryptedBody = HttpService:JSONEncode({
            payload = payloadXOR,
            sig = sig
        })
        
        task.spawn(function()
            local success, res = pcall(function()
                local requestFunc = syn and syn.request or http_request or request or fluxus and fluxus.request
                if requestFunc then
                    local r = requestFunc({
                        Url = PET_API_URL,
                        Method = "POST",
                        Headers = { ["Content-Type"] = "application/json" },
                        Body = encryptedBody
                    })
                    return r.Body
                else
                    return game:HttpPost(PET_API_URL, encryptedBody, "application/json")
                end
            end)
            
            loadingLabel:Destroy()
            
            if success and res and res ~= "" then
                
                local decoded = verifyPetResponse(res)
                local petsFromResponse = nil
                if decoded and decoded.success and decoded.data then
                    petsFromResponse = decoded.data
                end
                
                if petsFromResponse and #petsFromResponse > 0 then
                    local matchCount = 0
                    
                    for _, pet in ipairs(petsFromResponse) do
                        if matchCount >= 50 then
                            local limitLabel = Instance.new("TextLabel")
                            limitLabel.Size = UDim2.new(1, -10, 0, 30)
                            limitLabel.BackgroundTransparency = 1
                            limitLabel.Text = "Showing top 50 results (Server filtered)."
                            limitLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                            limitLabel.TextSize = 13
                            limitLabel.Font = Enum.Font.Gotham
                            limitLabel.Parent = listFrame
                            break
                        end
                        
                        matchCount = matchCount + 1
                        if matchCount % 10 == 0 then task.wait() end
                        
                        local itemFrame = Instance.new("Frame")
                        itemFrame.Size = UDim2.new(1, -10, 0, 50)
                        itemFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
                        itemFrame.BorderSizePixel = 0
                        itemFrame.Parent = listFrame
                        
                        local itemStroke = Instance.new("UIStroke")
                        itemStroke.Color = Color3.fromRGB(81, 66, 255)
                        itemStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                        itemStroke.Transparency = 0.6
                        itemStroke.Parent = itemFrame
                        
                        local itemCorner = Instance.new("UICorner")
                        itemCorner.CornerRadius = UDim.new(0, 6)
                        itemCorner.Parent = itemFrame
                        
                        local rarityColor = Color3.fromRGB(180, 180, 180) -- Common
                        if pet.rarity == "Uncommon" then rarityColor = Color3.fromRGB(100, 255, 100)
                        elseif pet.rarity == "Rare" then rarityColor = Color3.fromRGB(50, 150, 255)
                        elseif pet.rarity == "Legendary" then rarityColor = Color3.fromRGB(255, 150, 50)
                        elseif pet.rarity == "Mythic" then rarityColor = Color3.fromRGB(255, 50, 255)
                        elseif pet.rarity == "Super" then rarityColor = Color3.fromRGB(255, 50, 50) end
                        
                        local mutColor = Color3.fromRGB(200, 200, 200)
                        if pet.mutation == "Golden" then mutColor = Color3.fromRGB(255, 215, 0)
                        elseif pet.mutation == "Rainbow" then mutColor = Color3.fromRGB(255, 105, 180)
                        elseif pet.mutation == "Radioactive" then mutColor = Color3.fromRGB(0, 255, 0) end
                        
                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Size = UDim2.new(0.4, 0, 0.6, 0)
                        nameLabel.Position = UDim2.new(0, 10, 0, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.Text = pet.petName
                        nameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                        nameLabel.TextSize = 15
                        nameLabel.Font = Enum.Font.GothamBold
                        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                        nameLabel.Parent = itemFrame
                        
                        local detailLabel = Instance.new("TextLabel")
                        detailLabel.Size = UDim2.new(0.4, 0, 0.4, 0)
                        detailLabel.Position = UDim2.new(0, 10, 0.6, 0)
                        detailLabel.BackgroundTransparency = 1
                        
                        local rText = "<font color='rgb(" .. math.floor(rarityColor.R*255) .. "," .. math.floor(rarityColor.G*255) .. "," .. math.floor(rarityColor.B*255) .. ")'>[" .. (pet.rarity or "Unknown") .. "]</font>"
                        local mText = ""
                        if pet.mutation and pet.mutation ~= "None" then
                            mText = " <font color='rgb(" .. math.floor(mutColor.R*255) .. "," .. math.floor(mutColor.G*255) .. "," .. math.floor(mutColor.B*255) .. ")'>(" .. pet.mutation .. ")</font>"
                        end
                        
                        detailLabel.RichText = true
                        detailLabel.Text = rText .. mText
                        detailLabel.TextSize = 11
                        detailLabel.Font = Enum.Font.Gotham
                        detailLabel.TextXAlignment = Enum.TextXAlignment.Left
                        detailLabel.Parent = itemFrame
                        
                        local despawnTime = pet.despawnTime
                        
                        local timeLabel = Instance.new("TextLabel")
                        timeLabel.Size = UDim2.new(0.3, 0, 1, 0)
                        timeLabel.Position = UDim2.new(0.4, 0, 0, 0)
                        timeLabel.BackgroundTransparency = 1
                        timeLabel.TextSize = 14
                        timeLabel.Font = Enum.Font.Gotham
                        timeLabel.Parent = itemFrame
                        
                        local joinBtn = Instance.new("TextButton")
                        joinBtn.Size = UDim2.new(0, 90, 0, 32)
                        joinBtn.Position = UDim2.new(1, -100, 0.5, -16)
                        joinBtn.BackgroundColor3 = Color3.fromRGB(81, 66, 255)
                        joinBtn.Text = "Join Server"
                        joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                        joinBtn.TextSize = 12
                        joinBtn.Font = Enum.Font.GothamBold
                        joinBtn.Parent = itemFrame
                        
                        local btnCorner = Instance.new("UICorner")
                        btnCorner.CornerRadius = UDim.new(0, 6)
                        btnCorner.Parent = joinBtn
                        
                        joinBtn.MouseButton1Click:Connect(function()
                            if joinBtn.Text == "Joining..." then return end
                            joinBtn.Text = "Joining..."
                            
                            local ts = game:GetService("TeleportService")
                            
                            _G.SuppressAutoReconnect = true
                            
                            local success, err = pcall(function()
                                ts:TeleportToPlaceInstance(game.PlaceId, pet.serverId, game.Players.LocalPlayer)
                            end)
                            
                            if not success then
                                _G.SuppressAutoReconnect = false
                                joinBtn.Text = "Join Failed"
                                warn("Pet Finder Teleport Error: " .. tostring(err))
                                notif("Error: " .. tostring(err), 7, "Pet Finder")
                                task.wait(2)
                                if joinBtn and joinBtn.Parent then
                                    joinBtn.Text = "Join Server"
                                end
                            else
                                task.spawn(function()
                                    local conn
                                    conn = ts.TeleportInitFailed:Connect(function(plr, result, msg)
                                        if plr == game.Players.LocalPlayer then
                                            _G.SuppressAutoReconnect = false
                                            game:GetService("GuiService"):ClearError()
                                            notif("Teleport failed: " .. tostring(msg), 5, "Pet Finder")
                                            if joinBtn and joinBtn.Parent then
                                                joinBtn.Text = "Join Server"
                                            end
                                            conn:Disconnect()
                                        end
                                    end)
                                    task.wait(20)
                                    _G.SuppressAutoReconnect = false
                                    if conn then conn:Disconnect() end
                                end)
                            end
                        end)
                        
                        task.spawn(function()
                            while timeLabel.Parent do
                                local timeLeft = math.max(0, despawnTime - os.time())
                                local timeText = timeLeft > 0 and string.format("%dm %ds left", math.floor(timeLeft/60), timeLeft%60) or "Expired"
                                local timeColor = timeLeft > 0 and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
                                timeLabel.Text = timeText
                                timeLabel.TextColor3 = timeColor
                                
                                if timeLeft <= 0 then
                                    joinBtn.Visible = false
                                end
                                task.wait(1)
                            end
                        end)
                    end
                    
                    if matchCount == 0 then
                        local noDataLabel = Instance.new("TextLabel")
                        noDataLabel.Size = UDim2.new(1, 0, 0, 30)
                        noDataLabel.BackgroundTransparency = 1
                        noDataLabel.Text = "No pets match your filter."
                        noDataLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                        noDataLabel.TextSize = 14
                        noDataLabel.Font = Enum.Font.Gotham
                        noDataLabel.Parent = listFrame
                    end
                else
                    local noDataLabel = Instance.new("TextLabel")
                    noDataLabel.Size = UDim2.new(1, 0, 0, 30)
                    noDataLabel.BackgroundTransparency = 1
                    noDataLabel.Text = "No active wild pets found across servers."
                    noDataLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                    noDataLabel.TextSize = 14
                    noDataLabel.Font = Enum.Font.Gotham
                    noDataLabel.Parent = listFrame
                end
                listFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
            else
                local errLabel = Instance.new("TextLabel")
                errLabel.Size = UDim2.new(1, 0, 0, 30)
                errLabel.BackgroundTransparency = 1
                errLabel.Text = "Failed to connect to Pet Finder Server."
                errLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                errLabel.TextSize = 14
                errLabel.Font = Enum.Font.Gotham
                errLabel.Parent = listFrame
            end
        end)
    end
    
    searchBox.FocusLost:Connect(fetchPets)
    refreshBtn.MouseButton1Click:Connect(fetchPets)
    
    fetchPets()
    
    task.spawn(function()
        while screenGui.Parent do
            task.wait(30)
            if screenGui.Parent then
                fetchPets()
            end
        end
    end)
end

petFinderToggle = WildPetSection:AddToggle({
    Title = "Global Pet Finder",
    Default = false,
    Callback = function(val)
        local coreGui = game:GetService("CoreGui")
        local existing = coreGui:FindFirstChild("GagPetFinder")
        
        if val then
            if not existing then
                createPetFinderUI()
            end
        else
            if existing then
                existing:Destroy()
            end
        end
    end
})

end

local function LoadTradeTab()
-- TAB TRADE
local TradeTab = Tabs:AddTab({ Name = "Trade", Icon = "users" })
local TradeSection = TradeTab:AddSection("Auto Gifting")

local playerList = {}
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then table.insert(playerList, p.Name) end
end

local TradeDropdown
TradeDropdown = TradeSection:AddDropdown({
    Title = "Target Player",
    Options = playerList,
    Default = "None",
    Callback = function(val)
        Config.TradeTarget = val
    end
})

local TradeItemDropdown
TradeItemDropdown = TradeSection:AddDropdown({
    Title = "Item Name",
    Options = SEED_LIST,
    Default = "None",
    Callback = function(val)
        Config.TradeItem = val
    end
})

TradeSection:AddInput({
    Title = "Trade Amount",
    Content = "0 = Trade All",
    Callback = function(val)
        Config.TradeAmount = tonumber(val) or 0
    end
})

TradeSection:AddToggle({
    Title = "Auto Send Trade",
    Title2 = "Enable",
    Content = "Automatically gift the selected item to target",
    Default = false,
    Callback = function(val)
        Config.AutoTrade = val
        if UI_LOADED and val then startTradeLoop() end
    end
})

TradeSection:AddToggle({
    Title = "Auto Accept Trade",
    Title2 = "Enable",
    Content = "Automatically accept incoming gifts",
    Default = false,
    Callback = function(val)
        Config.AutoAcceptTrade = val
    end
})

local autoClaimMailboxActive = false
local function startAutoClaimMailboxLoop()
    if autoClaimMailboxActive then return end
    autoClaimMailboxActive = true
    task.spawn(function()
        local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
        
        local conn
        pcall(function()
            conn = Networking.Mailbox.Updated.OnClientEvent:Connect(function(payload)
                if Config.AutoClaimMailbox and typeof(payload) == "table" and typeof(payload.Mailbox) == "table" then
                    for mailId, _ in pairs(payload.Mailbox) do
                        if not Config.AutoClaimMailbox then break end
                        pcall(function()
                            Networking.Mailbox.Claim:Fire(mailId)
                        end)
                        task.wait(0.5)
                    end
                end
            end)
        end)
        
        while Config.AutoClaimMailbox do
            if _G.GagAutoScriptActive then
                local ok, payload = pcall(function()
                    return Networking.Mailbox.OpenInbox:Fire()
                end)
                
                if ok and type(payload) == "table" then
                    local actualMail = payload.Mailbox or payload
                    
                    local count = 0
                    for mailId, mailData in pairs(actualMail) do
                        if type(mailId) == "string" and type(mailData) == "table" then
                            count = count + 1
                            if not Config.AutoClaimMailbox then break end
                            pcall(function()
                                Networking.Mailbox.Claim:Fire(mailId)
                            end)
                            task.wait(0.5)
                        end
                    end
                    
                    -- FALLBACK: If payload was empty but UI has items, claim from UI!
                    if count == 0 then
                        local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                        if pg then
                            local receiveFrame = nil
                            for _, gui in ipairs(pg:GetDescendants()) do
                                if gui.Name == "RecieveFrame" or gui.Name == "ReceiveFrame" then
                                    receiveFrame = gui
                                    break
                                end
                            end
                            
                            if receiveFrame then
                                for _, child in ipairs(receiveFrame:GetChildren()) do
                                    if child.Name:sub(1, 5) == "Gift_" then
                                        local mailId = child.Name:sub(6)
                                        if not Config.AutoClaimMailbox then break end
                                        local claimOk = pcall(function()
                                            return Networking.Mailbox.Claim:Fire(mailId)
                                        end)
                                        if claimOk then
                                            child:Destroy()
                                        end
                                        task.wait(0.5)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait(10)
        end
        if conn then conn:Disconnect() end
        autoClaimMailboxActive = false
    end)
end

local MailboxSection = TradeTab:AddSection("Auto Mailbox")

MailboxSection:AddToggle({
    Title = "Auto Claim Mailbox",
    Title2 = "Enable",
    Content = "Automatically claims all items sent to your mailbox.",
    Default = Config.AutoClaimMailbox or false,
    Callback = function(val)
        Config.AutoClaimMailbox = val
        if val then
            startAutoClaimMailboxLoop()
        end
    end
})

local MailboxTarget = ""
MailboxSection:AddInput({
    Title = "Target Username",
    Content = "Enter target player's username",
    Callback = function(val)
        MailboxTarget = val
    end
})

local fruitIndexMap = {}
local MailboxItemDropdown
local MailboxFruitDropdown

-- Helper: reliably detect if a tool is a harvested fruit
-- Uses attribute check first, then falls back to name pattern
-- Fruit tool names contain weight like "[238.93k]", "[14.19kg]", or mutation like "[Gold]", "[Bloodlif]"
local function isFruitTool(tool)
    if tool:GetAttribute("HarvestedFruit") == true then
        return true
    end
    return false
end

local function FormatMoney(value)
    if value < 1000 then return tostring(math.floor(value)) end
    
    local index = math.floor(math.log10(value) / 3)
    local formatted = string.format("%.2f", value / (10 ^ (index * 3))):gsub("%.?0+$", "")
    
    local suffixes = {"K", "M", "B", "T", "Qd", "Qn"}
    if index <= #suffixes then
        return formatted .. suffixes[index]
    end
    
    local alphaIndex = index - #suffixes - 1
    local suffix = ""
    local length = 2
    
    while true do
        local maxForLength = 26 ^ length
        if alphaIndex < maxForLength then
            for i = 1, length do
                suffix = string.char(97 + (alphaIndex % 26)) .. suffix
                alphaIndex = math.floor(alphaIndex / 26)
            end
            break
        else
            alphaIndex = alphaIndex - maxForLength
            length = length + 1
        end
    end
    
    return formatted .. suffix
end

local function calculateSimpleFruitValue(fruitName, sizeMulti, mutation)
    local basePrices = {
        Carrot = 5, Strawberry = 3, Tomato = 9, Blueberry = 5, Apple = 12, Bamboo = 800,
        Cactus = 40, Pineapple = 30, ["Green Bean"] = 10, Banana = 35, Grape = 45, Mushroom = 13000,
        Coconut = 60, Mango = 90, ["Dragon Fruit"] = 150, Acorn = 200, Cherry = 350, Sunflower = 1750,
        ["Venus Fly Trap"] = 3000, Pomegranate = 900, ["Poison Apple"] = 900, ["Moon Bloom"] = 9000,
        ["Dragon's Breath"] = 3400, ["Poison Ivy"] = 1700, ["Glow Mushroom"] = 700,
        ["Ghost Pepper"] = 2500, ["Horned Melon"] = 200, Corn = 34, ["Baby Cactus"] = 70, Tulip = 60,
        ["Venom Spitter"] = 3800, ["Rocket Pop"] = 22500, ["Fire Fern"] = 900,
        ["Hypno Bloom"] = 9500, ["Briar Rose"] = 6500
    }
    local mutMultipliers = {
        Aurora = 1.5, Bloodlit = 60, Chained = 8, Electric = 25, Frozen = 14,
        Gold = 10, Ignited = 60, Rainbow = 30, Starstruck = 50
    }
    
    local baseVal = basePrices[fruitName] or 0
    if baseVal == 0 then return nil end
    
    local sizeExp = 2.65
    if fruitName == "Mushroom" then sizeExp = 1.9 end
    if fruitName == "Bamboo" then sizeExp = 1.75 end
    
    local v23 = (sizeMulti or 1) ^ sizeExp
    local mutMulti = mutMultipliers[mutation] or 1
    
    local friends = game.Players.LocalPlayer:GetAttribute("Friends") or 0
    local friendBoost = 1 + (friends * 0.1)
    
    return math.floor(baseVal * v23 * mutMulti * friendBoost)
end

local function getFormattedFruitName(tool)
    local name = tool.Name
    local baseName = tool:GetAttribute("FruitName") or tool:GetAttribute("Fruit")
    local weight = tool:GetAttribute("Weight")
    
    if not baseName then
        baseName = string.match(name, "^(.-)%s*%[") or name
    end
    
    -- Selalu hitung ulang harga sesuai Config.ESPMode (abaikan attribute Value bawaan game)
    local value = nil
    local sizeMulti = tool:GetAttribute("SizeMulti") or tool:GetAttribute("SizeMultiplier") or 1
    local mutation = tool:GetAttribute("Mutation") or "None"
    local decayAlpha = tool:GetAttribute("DecayAlpha")
    
    -- FruitValueCalc menggunakan nama buah asli (tanpa " Seed")
    local fruitName = baseName
    if string.match(fruitName, " [sS]eed$") then
        fruitName = string.gsub(fruitName, " [sS]eed$", "")
    end
    
    local useStock = (Config.ESPInventoryMode ~= "Base Price")
    pcall(function()
        if FruitValueCalc then
            local mutParam = mutation ~= "None" and mutation or nil
            local rawValue = FruitValueCalc(fruitName, sizeMulti, mutParam, LocalPlayer, decayAlpha)
            if rawValue and rawValue > 0 then
                local stockMult = useStock and getFruitStockMultiplier(baseName) or 1
                value = math.floor(SellFlags.Apply(baseName, rawValue) * stockMult)
            end
        end
    end)
    
    pcall(function()
        if not value or value == 0 then
            local lookupName = SellValueData[seedName] and seedName or (SellValueData[baseName] and baseName or nil)
            if lookupName then
                local baseValue = SellValueData[lookupName] or 0
                if baseValue > 0 then
                    local mutMulti = 1
                    if MutationData and MutationData.ReturnPriceMultiplier then
                        mutMulti = MutationData.ReturnPriceMultiplier(mutation) or 1
                    end
                    local stockMult = useStock and getFruitStockMultiplier(baseName) or 1
                    value = math.floor(SellFlags.Apply(baseName, baseValue * sizeMulti ^ 2.65 * mutMulti) * stockMult)
                end
            end
        end
    end)
    
    if not value or value == 0 then
        value = calculateSimpleFruitValue(baseName, sizeMulti, mutation)
    end
    
    local vStr = ""
    if value then
        vStr = "$" .. FormatMoney(value)
    else
        vStr = "$?" -- Tampilkan $? jika dari gamenya memang tidak ada attribute harga
    end
    
    local formattedName = baseName
    if vStr ~= "" then formattedName = "[" .. vStr .. "] " .. formattedName end
    
    if formattedName == baseName and vStr == "" then
        formattedName = name
    end
    
    return formattedName
end



-- Collect all inventory instances from BOTH Backpack AND Character
-- Removes IsA("Tool") restriction because custom inventories often store
-- unequipped items as non-Tool Instances (e.g. Models/Values) in the Backpack
local function getAllPlayerTools()
    local tools = {}
    if LocalPlayer.Backpack then
        for _, obj in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if not obj:IsA("Script") and not obj:IsA("LocalScript") then
                table.insert(tools, obj)
            end
        end
    end
    if LocalPlayer.Character then
        for _, obj in ipairs(LocalPlayer.Character:GetChildren()) do
            if obj:IsA("Tool") then
                table.insert(tools, obj)
            end
        end
    end
    return tools
end

-- Single scan: builds BOTH item list and fruit list in one pass
-- Scans Backpack + Character to catch all tools including currently equipped ones
local function buildInventoryLists()
    local itemList = {}
    local fruitList = {}
    fruitIndexMap = {}
    local fruitCountByName = {}

    for _, tool in ipairs(getAllPlayerTools()) do
        local name = tool.Name
        if not table.find(UNGIFTABLE_GEARS, name) then
            if isFruitTool(tool) then
                local formattedName = getFormattedFruitName(tool)

                fruitCountByName[formattedName] = (fruitCountByName[formattedName] or 0) + 1
                local displayName = formattedName .. " [" .. fruitCountByName[formattedName] .. "]"
                table.insert(fruitList, displayName)
                fruitIndexMap[displayName] = tool
            else
                -- Add to item list (deduplicated, sorted)
                local displayName = name
                if (table.find(SEED_LIST, name) or table.find(MUTATION_LIST, name) or name == "Gold" or name == "Mega" or name == "Rainbow") and not string.match(name, " Seed$") then
                    displayName = name .. " Seed"
                end
                if not table.find(itemList, displayName) then
                    table.insert(itemList, displayName)
                end
            end
        end
    end

    pcall(function()
        local PlayerStateClient = require(game:GetService("ReplicatedStorage").ClientModules.PlayerStateClient)
        local replica = PlayerStateClient:GetLocalReplica()
        if replica and replica.Data and replica.Data.Inventory then
            if replica.Data.Inventory.Props then
                for propName, propCount in pairs(replica.Data.Inventory.Props) do
                    if type(propCount) == "number" and propCount > 0 then
                        if not table.find(itemList, propName) then table.insert(itemList, propName) end
                    end
                end
            end
            if replica.Data.Inventory.Eggs then
                for eggName, eggCount in pairs(replica.Data.Inventory.Eggs) do
                    if type(eggCount) == "number" and eggCount > 0 then
                        if not table.find(itemList, eggName) then table.insert(itemList, eggName) end
                    end
                end
            end
        end
    end)

    table.sort(itemList)
    if #itemList == 0 then table.insert(itemList, "None") end
    if #fruitList == 0 then table.insert(fruitList, "None") end
    return itemList, fruitList
end

local function getGiftableInventory()
    local items, _ = buildInventoryLists()
    return items
end

local function getHarvestedFruitInventory()
    local _, fruits = buildInventoryLists()
    return fruits
end


MailboxItemDropdown = MailboxSection:AddDropdown({
    Title = "Items to Send (Non-Fruit)",
    Multi = true,
    Options = getGiftableInventory(),
    Default = {"None"},
    Callback = function(val)
        if type(val) == "table" and #val == 0 then
            Config.MailboxItems = {"None"}
        else
            Config.MailboxItems = type(val) == "table" and val or {val}
        end
    end
})

MailboxFruitDropdown = MailboxSection:AddDropdown({
    Title = "Fruits to Send",
    Multi = true,
    Options = getHarvestedFruitInventory(),
    Default = {"None"},
    Callback = function(val)
        if type(val) == "table" and #val == 0 then
            Config.MailboxFruits = {"None"}
        else
            Config.MailboxFruits = type(val) == "table" and val or {val}
        end
    end
})

MailboxSection:AddButton({
    Title = "Refresh Inventory",
    Content = "Auto-retry 5x tiap 0.5 detik agar backpack sync",
    Callback = function()
        local finalItems, finalFruits
        for i = 1, 5 do
            local items, fruits = buildInventoryLists()
            finalItems = items
            finalFruits = fruits
            MailboxItemDropdown:SetValues(items)
            MailboxFruitDropdown:SetValues(fruits)
            if i < 5 then task.wait(0.5) end
        end
        local itemCount = math.max(0, #finalItems - 1)
        local fruitCount = math.max(0, #finalFruits - 1)
        notif("Refreshed! " .. itemCount .. " items, " .. fruitCount .. " fruits", 4, "Mailbox")
    end
})

local MailboxAmount = 0
MailboxSection:AddInput({
    Title = "Amount (untuk Items non-fruit)",
    Content = "Jumlah per item yang dikirim (e.g., 50, 100)",
    Callback = function(val)
        MailboxAmount = tonumber(val) or 0
    end
})

MailboxSection:AddButton({
    Title = "Send via Mailbox",
    Content = "Kirim items dan fruits terpilih secara bersamaan",
    Callback = function(isFromWeb)
        local itemsToSend = Config.MailboxItems or {}
        local fruitsToSend = Config.MailboxFruits or {}
        local hasItem = false
        for _, v in ipairs(itemsToSend) do
            if v and v ~= "None" then hasItem = true break end
        end
        local hasFruit = false
        for _, v in ipairs(fruitsToSend) do
            if v and v ~= "None" then hasFruit = true break end
        end
        if not hasItem and not hasFruit then
            notif("Pilih minimal 1 item atau 1 fruit!", 5, "Mailbox")
            return
        end
        if hasItem and MailboxAmount <= 0 then
            notif("Isi Amount terlebih dahulu untuk pengiriman non-fruit!", 5, "Mailbox")
            return
        end
        if MailboxTarget == "" then
            notif("Isi Target Username terlebih dahulu!", 5, "Mailbox")
            return
        end
        task.spawn(function()
            local targetId = 0
            local targetPlayer = Players:FindFirstChild(MailboxTarget)
            if targetPlayer then
                targetId = targetPlayer.UserId
            else
                local ok2, result = pcall(function()
                    return Players:GetUserIdFromNameAsync(MailboxTarget)
                end)
                if ok2 and result then
                    targetId = result
                else
                    notif("Player Username tidak valid / tidak ditemukan!", 5, "Mailbox")
                    return
                end
            end
            local payload = {}
            local overallFound = 0

            -- ============ PROSES FRUITS ============
            if hasFruit then
                buildInventoryLists() -- Refresh map to get latest tool references
                for _, displayName in ipairs(fruitsToSend) do
                    if displayName == "None" then continue end
                    local tool = fruitIndexMap[displayName]
                    if not tool or not tool.Parent then
                        notif("Fruit '" .. displayName .. "' tidak ada di tas!", 4, "Mailbox")
                        continue
                    end
                    local originalToolName = tool.Name
                    local uuid = tool:GetAttribute("UUID") or tool:GetAttribute("Id") or tool:GetAttribute("ItemKey")
                    if not uuid then
                        for _, v in pairs(tool:GetAttributes()) do
                            if type(v) == "string" and string.match(v, "%w+%-%w+%-%w+%-%w+%-%w+") then
                                uuid = v break
                            end
                        end
                    end
                    if uuid then
                        table.insert(payload, { Category = "HarvestedFruits", ItemKey = uuid, Count = 1 })
                    else
                        table.insert(payload, { Category = "HarvestedFruits", ItemKey = originalToolName, Count = 1 })
                    end
                    overallFound = overallFound + 1
                end
            end

            -- ============ PROSES ITEMS BIASA ============
            if hasItem then
                for _, itemName in ipairs(itemsToSend) do
                    if itemName == "None" then continue end
                    
                    local foundCount = 0
                    local isStacked = false
                    local category = "Gears"
                    local itemKey = itemName
                    local baseName = string.gsub(itemName, " Seed$", "")
                    
                    if string.match(itemName, " Seed$") or table.find(SEED_LIST, itemName) or table.find(SEED_LIST, baseName) or table.find(MUTATION_LIST, baseName) or baseName == "Gold" or baseName == "Mega" or baseName == "Rainbow" then
                        category = "Seeds"; itemKey = baseName; isStacked = true
                    elseif string.match(itemName, " Sprinkler$") then
                        category = "Sprinklers"; isStacked = true
                    elseif string.match(itemName, " Watering Can$") then
                        category = "WateringCans"; isStacked = true
                    elseif itemName == "Trowel" or string.match(itemName, " Trowel$") then
                        category = "Trowels"; isStacked = true
                    elseif itemName == "Gnome" or string.match(itemName, " Gnome$") then
                        category = "Gnomes"; isStacked = true
                    elseif itemName == "Mushroom" or string.match(itemName, " Mushroom$") then
                        category = "Mushrooms"; isStacked = true
                    elseif string.match(itemName, " Crate$") then
                        category = "Crates"; isStacked = true
                    elseif string.match(itemName, " Seed Pack$") then
                        category = "SeedPacks"; isStacked = true
                    elseif itemName == "Empty Pot" then
                        category = "EmptyPots"; isStacked = true
                    elseif string.match(itemName, " Egg$") or string.find(itemName, "Egg") then
                        category = "Eggs"; isStacked = true
                    end
                    
                    if isStacked then
                        local toSend = MailboxAmount
                        while toSend > 0 do
                            local taking = math.min(toSend, 9999)
                            table.insert(payload, { Category = category, ItemKey = itemKey, Count = taking })
                            toSend = toSend - taking
                        end
                        overallFound = overallFound + MailboxAmount
                        continue
                    end
                    
                    for _, tool in ipairs(getAllPlayerTools()) do
                        if tool.Name == itemName then
                            local toolCat = "Props"
                            local uuid = tool:GetAttribute("UUID") or tool:GetAttribute("Id") or tool:GetAttribute("ItemKey")
                            
                            local u5 = {
                                PetId = "Pets", SeedTool = "Seeds", SeedPack = "SeedPacks", Crate = "Crates",
                                Sprinkler = "Sprinklers", WateringCan = "WateringCans", Mushroom = "Mushrooms",
                                Gnome = "Gnomes", Raccoon = "Raccoons", Teleporter = "Teleporters",
                                Magnet = "Magnets", Wheelbarrow = "Wheelbarrows", Trowel = "Trowels",
                                Crowbar = "Crowbars", Ladder = "Ladders", FreezeRay = "FreezeRays",
                                PowerHose = "PowerHoses", Rake = "Rakes", Lantern = "Lanterns",
                                Sign = "Signs", EmptyPot = "EmptyPots", Flashbang = "Flashbangs",
                                Bird = "Birds", Bench = "Benches", Light = "Lights", Fence = "Fences",
                                Egg = "Eggs"
                            }
                            
                            for attr, cat in pairs(u5) do
                                if tool:GetAttribute(attr) ~= nil then
                                    toolCat = cat
                                    if not uuid then uuid = tool:GetAttribute(attr) end
                                    break
                                end
                            end
                            
                            if toolCat == "Props" then
                                if string.match(itemName, "^Ladder") then toolCat = "Ladders"
                                elseif string.match(itemName, "^Bench") then toolCat = "Benches"
                                elseif string.match(itemName, "^Light") then toolCat = "Lights"
                                elseif string.match(itemName, "^Fence") then toolCat = "Fences"
                                elseif string.match(itemName, " Egg$") then toolCat = "Eggs"
                                elseif itemName == "Deer" or itemName == "Frog" or itemName == "Bee" or itemName == "Cat" or string.match(itemName, "Dragonfly$") then toolCat = "Pets"
                                end
                            end
                            
                            if not uuid then
                                for _, v in pairs(tool:GetAttributes()) do
                                    if type(v) == "string" and string.match(v, "%w+%-%w+%-%w+%-%w+%-%w+") then
                                        uuid = v break
                                    end
                                end
                            end
                            
                            if uuid then
                                table.insert(payload, { Category = toolCat, ItemKey = uuid, Count = 1 })
                            else
                                table.insert(payload, { Category = toolCat, ItemKey = itemName, Count = 1 })
                            end
                            
                            foundCount = foundCount + 1
                            overallFound = overallFound + 1
                            if foundCount >= MailboxAmount then break end
                        end
                    end
                    
                    if foundCount == 0 then
                        local hasInStacked = false
                        local stackedCategory = "Props"
                        
                        pcall(function()
                            local PlayerStateClient = require(game:GetService("ReplicatedStorage").ClientModules.PlayerStateClient)
                            local replica = PlayerStateClient:GetLocalReplica()
                            if replica and replica.Data and replica.Data.Inventory then
                                if replica.Data.Inventory.Props and (replica.Data.Inventory.Props[itemName] or 0) > 0 then
                                    hasInStacked = true
                                    stackedCategory = "Props"
                                elseif replica.Data.Inventory.Eggs and (replica.Data.Inventory.Eggs[itemName] or 0) > 0 then
                                    hasInStacked = true
                                    stackedCategory = "Eggs"
                                end
                            end
                        end)
                        
                        if hasInStacked then
                            local toSend = MailboxAmount
                            while toSend > 0 do
                                local taking = math.min(toSend, 9999)
                                table.insert(payload, { Category = stackedCategory, ItemKey = itemName, Count = taking })
                                toSend = toSend - taking
                            end
                            overallFound = overallFound + MailboxAmount
                        else
                            notif("Item '" .. itemName .. "' tidak ditemukan di tas, PropInventory, atau Eggs.", 5, "Mailbox Error")
                        end
                    end
                end
            end

            if #payload == 0 then
                notif("Tidak ada item valid untuk dikirim!", 5, "Mailbox Error")
                return
            end
            
            local function executeSend()
                task.spawn(function()
                    notif("Memulai pengiriman " .. overallFound .. " items (" .. #payload .. " jenis) ke " .. MailboxTarget .. "...", 5, "Mailbox")
                    local RS = game:GetService("ReplicatedStorage")
                    local Networking = require(RS.SharedModules.Networking)
                    
                    local totalCycles = math.ceil(#payload / 20)
                    if totalCycles == 0 then totalCycles = 1 end

                    local currentBatch = {}
                    local cycle = 1
                    
                    for i, itemData in ipairs(payload) do
                        table.insert(currentBatch, itemData)
                        
                        if #currentBatch >= 20 or i == #payload then
                            local ok, r1, r2 = pcall(function()
                                return Networking.Mailbox.SendBatch:Fire(targetId, currentBatch, "Auto Mailbox")
                            end)
                            
                            if ok and r1 == true then
                                print("[Mailbox] Cycle " .. cycle .. "/" .. totalCycles .. " sukses terkirim!")
                                notif("Cycle " .. cycle .. "/" .. totalCycles .. " sukses (" .. #currentBatch .. " tipe)", 3, "Mailbox")
                            elseif ok and r1 == false then
                                warn("[Mailbox Error] Server Rejected Cycle " .. cycle .. ": " .. tostring(r2))
                                notif("Server Reject Cycle " .. cycle .. ": " .. tostring(r2), 5, "Mailbox Error")
                            else
                                warn("[Mailbox Error] Script Crash Cycle " .. cycle .. ": " .. tostring(r1))
                                notif("Script Error Cycle " .. cycle .. "! Cek F9.", 5, "Mailbox Error")
                            end
                            
                            table.clear(currentBatch)
                            cycle = cycle + 1
                            if i < #payload then task.wait(11) end
                        end
                    end
                    notif("Selesai memproses pengiriman ke " .. MailboxTarget .. "!", 5, "Mailbox")
                end)
            end
            
            if isFromWeb == true then
                executeSend()
                return
            end
            
            local sg = Instance.new("ScreenGui")
            sg.Name = "SendConfirmGAG"
            sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            local p = pcall(function() sg.Parent = game:GetService("CoreGui") end)
            if not p then sg.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end
            
            local bg = Instance.new("TextButton")
            bg.Size = UDim2.new(1, 0, 1, 0)
            bg.BackgroundColor3 = Color3.new(0,0,0)
            bg.BackgroundTransparency = 0.5
            bg.Text = ""
            bg.AutoButtonColor = false
            bg.Parent = sg
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 400, 0, 160)
            frame.Position = UDim2.new(0.5, -200, 0.5, -80)
            frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            frame.BorderSizePixel = 0
            frame.Parent = bg
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
            
            local avatarImg = Instance.new("ImageLabel")
            avatarImg.Size = UDim2.new(0, 70, 0, 70)
            avatarImg.Position = UDim2.new(0, 20, 0, 20)
            avatarImg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            avatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(targetId) .. "&w=150&h=150"
            avatarImg.Parent = frame
            Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -120, 0, 70)
            lbl.Position = UDim2.new(0, 110, 0, 20)
            lbl.BackgroundTransparency = 1
            lbl.TextWrapped = true
            lbl.Text = "Are you sure you want to send " .. overallFound .. " items (" .. #payload .. " types) to " .. MailboxTarget .. "?"
            lbl.TextColor3 = Color3.new(1,1,1)
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 16
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = frame
            
            local btnYes = Instance.new("TextButton")
            btnYes.Size = UDim2.new(0.4, 0, 0, 35)
            btnYes.Position = UDim2.new(0.05, 0, 1, -45)
            btnYes.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            btnYes.Text = "Yes, Send"
            btnYes.TextColor3 = Color3.new(1,1,1)
            btnYes.Font = Enum.Font.GothamBold
            btnYes.TextSize = 14
            btnYes.Parent = frame
            Instance.new("UICorner", btnYes).CornerRadius = UDim.new(0, 6)
            
            local btnNo = Instance.new("TextButton")
            btnNo.Size = UDim2.new(0.4, 0, 0, 35)
            btnNo.Position = UDim2.new(0.55, 0, 1, -45)
            btnNo.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            btnNo.Text = "Cancel"
            btnNo.TextColor3 = Color3.new(1,1,1)
            btnNo.Font = Enum.Font.GothamBold
            btnNo.TextSize = 14
            btnNo.Parent = frame
            Instance.new("UICorner", btnNo).CornerRadius = UDim.new(0, 6)
            
            btnYes.MouseButton1Click:Connect(function()
                sg:Destroy()
                executeSend()
            end)
            btnNo.MouseButton1Click:Connect(function()
                sg:Destroy()
            end)
        end)
    end
})

MailboxSection:AddButton({
    Title = "Send All Items",
    Content = "Send semua item (kecuali buah, telur,& pet) max 20 tipe per cycle",
    Callback = function(isFromWeb)
        if MailboxTarget == "" then
            notif("Isi Target Username terlebih dahulu!", 5, "Mailbox")
            return
        end
        
        local targetId = 0
        local targetPlayer = game:GetService("Players"):FindFirstChild(MailboxTarget)
        if targetPlayer then
            targetId = targetPlayer.UserId
        else
            local ok2, result = pcall(function()
                return game:GetService("Players"):GetUserIdFromNameAsync(MailboxTarget)
            end)
            if ok2 and result then
                targetId = result
            else
                notif("Player Username tidak valid / tidak ditemukan!", 5, "Mailbox")
                return
            end
        end
        
        local PlayerStateClient = require(game:GetService("ReplicatedStorage").ClientModules.PlayerStateClient)
        local replica = PlayerStateClient:GetLocalReplica()
        if not (replica and replica.Data and replica.Data.Inventory) then
            notif("Inventory belum siap!", 5, "Mailbox")
            return
        end
        
        local allPayload = {}
        local totalItems = 0
        
        for category, items in pairs(replica.Data.Inventory) do
            if category ~= "HarvestedFruits" and category ~= "Eggs" and category ~= "Pets" and category ~= "EmptyPots" and type(items) == "table" then
                for itemKey, entry in pairs(items) do
                    local strKey = tostring(itemKey)
                    if string.match(strKey, " Pot$") or strKey == "Pot" or strKey == "Basic Pot" then continue end
                    
                    local count = 0
                    if type(entry) == "number" then
                        count = entry
                    elseif type(entry) == "table" and type(entry.Count) == "number" then
                        count = entry.Count
                    elseif type(entry) == "table" and entry.Id then
                        count = 1
                    end
                    
                    if count > 0 then
                        local toSend = count
                        while toSend > 0 do
                            local taking = math.min(toSend, 9999)
                            table.insert(allPayload, { Category = category, ItemKey = itemKey, Count = taking })
                            toSend = toSend - taking
                        end
                        totalItems = totalItems + count
                    end
                end
            end
        end
        
        if #allPayload == 0 then
            notif("Tidak ada item yang bisa dikirim!", 5, "Mailbox")
            return
        end
        
        local function executeSendAll()
            task.spawn(function()
                notif("Memulai pengiriman " .. totalItems .. " items (" .. #allPayload .. " jenis) ke " .. MailboxTarget .. "...", 5, "Mailbox")
                local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
                
                local currentBatch = {}
                local cycle = 1
                local totalCycles = math.ceil(#allPayload / 20)
                
                for i, itemData in ipairs(allPayload) do
                    table.insert(currentBatch, itemData)
                    
                    if #currentBatch >= 20 or i == #allPayload then
                        local ok, r1, r2 = pcall(function()
                            return Networking.Mailbox.SendBatch:Fire(targetId, currentBatch, "Auto Mailbox")
                        end)
                        
                        if ok and r1 == true then
                            print("[Mailbox] Cycle " .. cycle .. "/" .. totalCycles .. " sukses terkirim!")
                            notif("Cycle " .. cycle .. "/" .. totalCycles .. " sukses (" .. #currentBatch .. " tipe)", 3, "Mailbox")
                        elseif ok and r1 == false then
                            warn("[Mailbox Error] Server Rejected Cycle " .. cycle .. ": " .. tostring(r2))
                            notif("Server Reject Cycle " .. cycle .. ": " .. tostring(r2), 5, "Mailbox Error")
                        else
                            warn("[Mailbox Error] Script Crash Cycle " .. cycle .. ": " .. tostring(r1))
                            notif("Script Error Cycle " .. cycle .. "! Cek F9.", 5, "Mailbox Error")
                        end
                        
                        table.clear(currentBatch)
                        cycle = cycle + 1
                        if i < #allPayload then task.wait(11) end
                    end
                end
                notif("Selesai memproses pengiriman ke " .. MailboxTarget .. "!", 5, "Mailbox")
            end)
        end
        
        if isFromWeb == true then
            executeSendAll()
            return
        end
        
        -- Custom UI Alert
        local sg = Instance.new("ScreenGui")
        sg.Name = "SendAllConfirmGAG"
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        local p = pcall(function() sg.Parent = game:GetService("CoreGui") end)
        if not p then sg.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end
        
        local bg = Instance.new("TextButton")
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.new(0,0,0)
        bg.BackgroundTransparency = 0.5
        bg.Text = ""
        bg.AutoButtonColor = false
        bg.Parent = sg
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 400, 0, 160)
        frame.Position = UDim2.new(0.5, -200, 0.5, -80)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        frame.BorderSizePixel = 0
        frame.Parent = bg
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
        
        local avatarImg = Instance.new("ImageLabel")
        avatarImg.Size = UDim2.new(0, 70, 0, 70)
        avatarImg.Position = UDim2.new(0, 20, 0, 20)
        avatarImg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        avatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(targetId) .. "&w=150&h=150"
        avatarImg.Parent = frame
        Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -120, 0, 70)
        lbl.Position = UDim2.new(0, 110, 0, 20)
        lbl.BackgroundTransparency = 1
        lbl.TextWrapped = true
        lbl.Text = "Are you sure you want to send " .. totalItems .. " items (" .. #allPayload .. " types) to " .. MailboxTarget .. "?"
        lbl.TextColor3 = Color3.new(1,1,1)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 16
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame
        
        local btnYes = Instance.new("TextButton")
        btnYes.Size = UDim2.new(0.4, 0, 0, 35)
        btnYes.Position = UDim2.new(0.05, 0, 1, -45)
        btnYes.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        btnYes.Text = "Yes, Send All"
        btnYes.TextColor3 = Color3.new(1,1,1)
        btnYes.Font = Enum.Font.GothamBold
        btnYes.TextSize = 14
        btnYes.Parent = frame
        Instance.new("UICorner", btnYes).CornerRadius = UDim.new(0, 6)
        
        local btnNo = Instance.new("TextButton")
        btnNo.Size = UDim2.new(0.4, 0, 0, 35)
        btnNo.Position = UDim2.new(0.55, 0, 1, -45)
        btnNo.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        btnNo.Text = "Cancel"
        btnNo.TextColor3 = Color3.new(1,1,1)
        btnNo.Font = Enum.Font.GothamBold
        btnNo.TextSize = 14
        btnNo.Parent = frame
        Instance.new("UICorner", btnNo).CornerRadius = UDim.new(0, 6)
        
        btnYes.MouseButton1Click:Connect(function()
            sg:Destroy()
            executeSendAll()
        end)
        btnNo.MouseButton1Click:Connect(function()
            sg:Destroy()
        end)
    end
})

MailboxSection:AddButton({
    Title = "Send All Fruit",
    Content = "Send semua buah (max 20 buah per cycle)",
    Callback = function(isFromWeb)
        if MailboxTarget == "" then
            notif("Isi Target Username terlebih dahulu!", 5, "Mailbox")
            return
        end
        
        local targetId = 0
        local targetPlayer = game:GetService("Players"):FindFirstChild(MailboxTarget)
        if targetPlayer then
            targetId = targetPlayer.UserId
        else
            local ok2, result = pcall(function()
                return game:GetService("Players"):GetUserIdFromNameAsync(MailboxTarget)
            end)
            if ok2 and result then
                targetId = result
            else
                notif("Player Username tidak valid / tidak ditemukan!", 5, "Mailbox")
                return
            end
        end
        
        local allPayload = {}
        local totalFruits = 0
        
        for _, tool in ipairs(getAllPlayerTools()) do
            local name = tool.Name
            if not table.find(UNGIFTABLE_GEARS, name) then
                if isFruitTool(tool) then
                    local originalToolName = tool.Name
                    local uuid = tool:GetAttribute("UUID") or tool:GetAttribute("Id") or tool:GetAttribute("ItemKey")
                    if not uuid then
                        for _, v in pairs(tool:GetAttributes()) do
                            if type(v) == "string" and string.match(v, "%w+%-%w+%-%w+%-%w+%-%w+") then
                                uuid = v break
                            end
                        end
                    end
                    if uuid then
                        table.insert(allPayload, { Category = "HarvestedFruits", ItemKey = uuid, Count = 1 })
                    else
                        table.insert(allPayload, { Category = "HarvestedFruits", ItemKey = originalToolName, Count = 1 })
                    end
                    totalFruits = totalFruits + 1
                end
            end
        end
        
        if #allPayload == 0 then
            notif("Tidak ada buah yang bisa dikirim!", 5, "Mailbox")
            return
        end
        
        local function executeSendAllFruit()
            task.spawn(function()
                notif("Memulai pengiriman " .. totalFruits .. " fruits ke " .. MailboxTarget .. "...", 5, "Mailbox")
                local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
                
                local currentBatch = {}
                local cycle = 1
                local totalCycles = math.ceil(#allPayload / 20)
                
                for i, itemData in ipairs(allPayload) do
                    table.insert(currentBatch, itemData)
                    
                    if #currentBatch >= 20 or i == #allPayload then
                        local ok, r1, r2 = pcall(function()
                            return Networking.Mailbox.SendBatch:Fire(targetId, currentBatch, "Auto Mailbox")
                        end)
                        
                        if ok and r1 == true then
                            print("[Mailbox] Cycle " .. cycle .. "/" .. totalCycles .. " sukses terkirim!")
                            notif("Cycle " .. cycle .. "/" .. totalCycles .. " sukses (" .. #currentBatch .. " buah)", 3, "Mailbox")
                        elseif ok and r1 == false then
                            warn("[Mailbox Error] Server Rejected Cycle " .. cycle .. ": " .. tostring(r2))
                            notif("Server Reject Cycle " .. cycle .. ": " .. tostring(r2), 5, "Mailbox Error")
                        else
                            warn("[Mailbox Error] Script Crash Cycle " .. cycle .. ": " .. tostring(r1))
                            notif("Script Error Cycle " .. cycle .. "! Cek F9.", 5, "Mailbox Error")
                        end
                        
                        table.clear(currentBatch)
                        cycle = cycle + 1
                        if i < #allPayload then task.wait(11) end
                    end
                end
                notif("Selesai memproses pengiriman buah ke " .. MailboxTarget .. "!", 5, "Mailbox")
            end)
        end
        
        if isFromWeb == true then
            executeSendAllFruit()
            return
        end
        
        -- Custom UI Alert
        local sg = Instance.new("ScreenGui")
        sg.Name = "SendAllFruitConfirmGAG"
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        local p = pcall(function() sg.Parent = game:GetService("CoreGui") end)
        if not p then sg.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end
        
        local bg = Instance.new("TextButton")
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.new(0,0,0)
        bg.BackgroundTransparency = 0.5
        bg.Text = ""
        bg.AutoButtonColor = false
        bg.Parent = sg
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 400, 0, 160)
        frame.Position = UDim2.new(0.5, -200, 0.5, -80)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        frame.BorderSizePixel = 0
        frame.Parent = bg
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
        
        local avatarImg = Instance.new("ImageLabel")
        avatarImg.Size = UDim2.new(0, 70, 0, 70)
        avatarImg.Position = UDim2.new(0, 20, 0, 20)
        avatarImg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        avatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(targetId) .. "&w=150&h=150"
        avatarImg.Parent = frame
        Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -120, 0, 70)
        lbl.Position = UDim2.new(0, 110, 0, 20)
        lbl.BackgroundTransparency = 1
        lbl.TextWrapped = true
        lbl.Text = "Are you sure you want to send " .. totalFruits .. " fruits (" .. #allPayload .. " total) to " .. MailboxTarget .. "?"
        lbl.TextColor3 = Color3.new(1,1,1)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 16
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame
        
        local btnYes = Instance.new("TextButton")
        btnYes.Size = UDim2.new(0.4, 0, 0, 35)
        btnYes.Position = UDim2.new(0.05, 0, 1, -45)
        btnYes.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        btnYes.Text = "Yes, Send All"
        btnYes.TextColor3 = Color3.new(1,1,1)
        btnYes.Font = Enum.Font.GothamBold
        btnYes.TextSize = 14
        btnYes.Parent = frame
        Instance.new("UICorner", btnYes).CornerRadius = UDim.new(0, 6)
        
        local btnNo = Instance.new("TextButton")
        btnNo.Size = UDim2.new(0.4, 0, 0, 35)
        btnNo.Position = UDim2.new(0.55, 0, 1, -45)
        btnNo.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        btnNo.Text = "Cancel"
        btnNo.TextColor3 = Color3.new(1,1,1)
        btnNo.Font = Enum.Font.GothamBold
        btnNo.TextSize = 14
        btnNo.Parent = frame
        Instance.new("UICorner", btnNo).CornerRadius = UDim.new(0, 6)
        
        btnYes.MouseButton1Click:Connect(function()
            sg:Destroy()
            executeSendAllFruit()
        end)
        btnNo.MouseButton1Click:Connect(function()
            sg:Destroy()
        end)
    end
})

local MailboxExploitsSection = TradeTab:AddSection("Mailbox UI Mod")

MailboxExploitsSection:AddButton({
    Title = "Patch Mailbox UI (Bypass Limit & Show Fruits)",
    Callback = function()
        if _G.MailboxPatched then
            notif("Mailbox sudah di-patch!", 3, "Info")
            return
        end
        
        local ok, MailboxController = pcall(function()
            return require(game:GetService("Players").LocalPlayer.PlayerScripts.Controllers.MailboxController)
        end)
        
        if ok and MailboxController and MailboxController._addToSend then
            local old_addToSend = MailboxController._addToSend
            local u44 = debug.getupvalue(old_addToSend, 1)
            local NotificationController = debug.getupvalue(old_addToSend, 2)
            local rebuildInventory = debug.getupvalue(old_addToSend, 3)
            local rebuildSending = debug.getupvalue(old_addToSend, 4)
            
            local PlayerStateClient
            for i = 1, 20 do
                local val = debug.getupvalue(rebuildInventory, i)
                if type(val) == "table" and type(val.GetLocalReplica) == "function" then
                    PlayerStateClient = val
                    break
                end
            end
            
            if type(rebuildInventory) == "function" and hookfunction then
                local old_rebuild
                old_rebuild = hookfunction(rebuildInventory, function()
                    if PlayerStateClient then
                        local replica = PlayerStateClient:GetLocalReplica()
                        if replica and replica.Data and replica.Data.Inventory then
                            if not replica.Data.Inventory.HarvestedFruits then
                                replica.Data.Inventory.HarvestedFruits = {}
                            end
                            table.clear(replica.Data.Inventory.HarvestedFruits)
                            
                            local bp = game:GetService("Players").LocalPlayer:FindFirstChild("Backpack")
                            if bp then
                                for _, item in ipairs(bp:GetChildren()) do
                                    if item:GetAttribute("HarvestedFruit") == true then
                                        local fruitName = item:GetAttribute("FruitName") or item:GetAttribute("Fruit")
                                        if type(fruitName) ~= "string" then fruitName = item.Name end
                                        
                                        local uuid = item:GetAttribute("Id")
                                        if uuid then
                                            replica.Data.Inventory.HarvestedFruits[uuid] = {
                                                Id = uuid,
                                                Name = item.Name,
                                                FruitName = fruitName,
                                                Mutation = item:GetAttribute("Mutation"),
                                                Weight = item:GetAttribute("Weight"),
                                                SizeMultiplier = item:GetAttribute("SizeMultiplier") or item:GetAttribute("Size"),
                                                Equipped = false
                                            }
                                        end
                                    end
                                end
                            end
                        end
                    end
                    return old_rebuild()
                end)
            end
            
            local function promptQuantity(actionType, maxCount, callback)
                local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                local mailboxUI = playerGui and playerGui:FindFirstChild("MailboxUI")
                if not mailboxUI then callback(1) return end
                
                if mailboxUI:FindFirstChild("QuantityPopupGAG") then return end
                
                local popup = Instance.new("TextButton")
                popup.Name = "QuantityPopupGAG"
                popup.Size = UDim2.new(1, 0, 1, 0)
                popup.BackgroundColor3 = Color3.new(0, 0, 0)
                popup.BackgroundTransparency = 0.9
                popup.Text = ""
                popup.AutoButtonColor = false
                popup.ZIndex = 100
                popup.Parent = mailboxUI
                
                local container = Instance.new("Frame")
                container.Size = UDim2.new(0, 300, 0, 160)
                container.Position = UDim2.new(0.5, -150, 0.5, -80)
                container.BackgroundColor3 = Color3.fromRGB(120, 60, 35)
                container.BorderSizePixel = 0
                container.ZIndex = 101
                container.Parent = popup
                Instance.new("UICorner", container).CornerRadius = UDim.new(0, 10)
                
                local mailboxFrame = mailboxUI:FindFirstChild("Frame")
                local targetFontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                if mailboxFrame then
                    local headerLbl = mailboxFrame:FindFirstChild("Header") and mailboxFrame.Header:FindFirstChild("TextLabel") and mailboxFrame.Header.TextLabel:FindFirstChild("TextLabel")
                    if headerLbl and headerLbl:IsA("TextLabel") then
                        pcall(function() targetFontFace = headerLbl.FontFace end)
                    end
                end
                
                local function addTexture(parent)
                    if mailboxFrame then
                        if mailboxFrame:FindFirstChild("BevelEffect") then
                            mailboxFrame.BevelEffect:Clone().Parent = parent
                        end
                        if mailboxFrame:FindFirstChild("InletTexture") then
                            local tex = mailboxFrame.InletTexture:Clone()
                            if tex:IsA("ImageLabel") and tex.ScaleType == Enum.ScaleType.Tile then
                                local cx = tex.TileSize.X.Offset
                                local cy = tex.TileSize.Y.Offset
                                if cx > 0 and cy > 0 then
                                    tex.TileSize = UDim2.new(0, cx * 0.8, 0, cy * 0.8)
                                else
                                    tex.TileSize = UDim2.new(0, 50, 0, 50)
                                end
                            end
                            tex.Parent = parent
                        end
                    end
                end
                
                addTexture(container)
                
                local function styleTextComponent(parentObj, textStr, zIdxBase)
                    parentObj.Text = ""
                    local headerLbl = mailboxFrame and mailboxFrame:FindFirstChild("Header") and mailboxFrame.Header:FindFirstChild("TextLabel")
                    if headerLbl and headerLbl:IsA("TextLabel") then
                        local lbl = headerLbl:Clone()
                        lbl.Size = UDim2.new(0.9, 0, 0.9, 0)
                        lbl.Position = UDim2.new(0.5, 0, 0.5, 0)
                        lbl.AnchorPoint = Vector2.new(0.5, 0.5)
                        lbl.Text = textStr
                        lbl.TextScaled = true
                        lbl.TextWrapped = true
                        lbl.ZIndex = zIdxBase + 1
                        lbl.TextXAlignment = Enum.TextXAlignment.Center
                        lbl.TextYAlignment = Enum.TextYAlignment.Center
                        lbl.Parent = parentObj
                        for _, child in ipairs(lbl:GetDescendants()) do
                            if child:IsA("TextLabel") then
                                child.Text = textStr
                                child.TextScaled = true
                                child.TextWrapped = true
                                child.ZIndex = zIdxBase + 2
                                child.TextXAlignment = Enum.TextXAlignment.Center
                                child.TextYAlignment = Enum.TextYAlignment.Center
                            elseif child:IsA("UIStroke") then
                                child.ZIndex = zIdxBase + 2
                            end
                        end
                    else
                        parentObj.Text = textStr
                        if targetFontFace then parentObj.FontFace = targetFontFace end
                        parentObj.TextScaled = true
                        parentObj.TextWrapped = true
                        parentObj.TextXAlignment = Enum.TextXAlignment.Center
                        parentObj.TextYAlignment = Enum.TextYAlignment.Center
                        parentObj.TextColor3 = Color3.new(1, 1, 1)
                    end
                end

                local title = Instance.new("TextLabel")
                title.BackgroundTransparency = 1
                title.Size = UDim2.new(1, 0, 0, 50)
                title.Position = UDim2.new(0, 0, 0, 0)
                title.ZIndex = 102
                title.Parent = container
                styleTextComponent(title, "Input Amount\n(Maksimal: " .. tostring(maxCount) .. ")", 102)
                
                local input = Instance.new("TextBox")
                input.Size = UDim2.new(0.8, 0, 0, 40)
                input.Position = UDim2.new(0.1, 0, 0, 55)
                input.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                input.BackgroundTransparency = 0.5
                input.TextColor3 = Color3.new(1, 1, 1)
                input.Text = tostring(maxCount)
                input.FontFace = targetFontFace
                input.TextSize = 18
                input.ZIndex = 102
                input.ClearTextOnFocus = true
                input.Parent = container
                Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)
                
                local btnConfirm = Instance.new("TextButton")
                btnConfirm.Size = UDim2.new(0.35, 0, 0, 40)
                btnConfirm.Position = UDim2.new(0.1, 0, 0, 105)
                btnConfirm.BackgroundColor3 = Color3.fromRGB(0, 194, 0)
                btnConfirm.ZIndex = 102
                btnConfirm.Parent = container
                Instance.new("UICorner", btnConfirm).CornerRadius = UDim.new(0, 6)
                addTexture(btnConfirm)
                styleTextComponent(btnConfirm, actionType, 102)
                
                local btnCancel = Instance.new("TextButton")
                btnCancel.Size = UDim2.new(0.35, 0, 0, 40)
                btnCancel.Position = UDim2.new(0.55, 0, 0, 105)
                btnCancel.BackgroundColor3 = Color3.fromRGB(182, 4, 4)
                btnCancel.ZIndex = 102
                btnCancel.Parent = container
                Instance.new("UICorner", btnCancel).CornerRadius = UDim.new(0, 6)
                addTexture(btnCancel)
                styleTextComponent(btnCancel, "Cancel", 102)
                
                local function close()
                    popup:Destroy()
                end
                
                btnConfirm.MouseButton1Click:Connect(function()
                    local val = tonumber(input.Text)
                    close()
                    if val and val > 0 then
                        callback(math.min(math.floor(val), maxCount))
                    end
                end)
                
                btnCancel.MouseButton1Click:Connect(close)
            end
            
            MailboxController._addToSend = function(self, p268, p269, p270, p271)
                local maxAmt = 1
                if PlayerStateClient then
                    local replica = PlayerStateClient:GetLocalReplica()
                    if replica and replica.Data and replica.Data.Inventory then
                        local realVal = replica.Data.Inventory[p269] and replica.Data.Inventory[p269][p270]
                        if type(realVal) == "number" then maxAmt = realVal end
                    end
                end
                
                local totalSelected = 0
                for k, v in pairs(u44) do
                    if v.Category == p269 and v.ItemKey == p270 then
                        totalSelected = totalSelected + (v.Selected or 0)
                    end
                end
                
                local available = maxAmt - totalSelected
                if available <= 0 then return end
                
                local function applyAmount(addCount)
                    local toAdd = addCount
                    local baseKey = p268
                    
                    local variantCount = 0
                    for k, v in pairs(u44) do
                        if v.Selected and v.Selected > 0 then variantCount = variantCount + 1 end
                    end
                    
                    for k, v in pairs(u44) do
                        if v.Category == p269 and v.ItemKey == p270 then
                            if v.Selected < 9999 then
                                local space = 9999 - v.Selected
                                local taking = math.min(toAdd, space)
                                v.Selected = v.Selected + taking
                                toAdd = toAdd - taking
                            end
                        end
                    end
                    
                    while toAdd > 0 do
                        if variantCount >= 20 then
                            if NotificationController and type(NotificationController.CreateNotification) == "function" then
                                NotificationController:CreateNotification("Up to 20 items per gift")
                            elseif typeof(notif) == "function" then
                                notif("Maksimal 20 varian slot per gift!", 3, "Error")
                            end
                            break
                        end
                        
                        local newKey = baseKey
                        if u44[newKey] then
                            local sIndex = 1
                            while u44[baseKey .. "_s" .. sIndex] do sIndex = sIndex + 1 end
                            newKey = baseKey .. "_s" .. sIndex
                        end
                        
                        local taking = math.min(toAdd, 9999)
                        u44[newKey] = {
                            Selected = taking,
                            Category = p269,
                            ItemKey = p270,
                            EntryValue = p271
                        }
                        toAdd = toAdd - taking
                        variantCount = variantCount + 1
                    end
                    
                    local totalNow = 0
                    for k, v in pairs(u44) do
                        if v.Category == p269 and v.ItemKey == p270 then totalNow = totalNow + (v.Selected or 0) end
                    end
                    local remaining = maxAmt - totalNow
                    
                    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                    local inventoryFrame = playerGui and playerGui:FindFirstChild("MailboxUI") and playerGui.MailboxUI:FindFirstChild("InventoryFrame", true)
                    if inventoryFrame then
                        local targetTile = inventoryFrame:FindFirstChild("Inv_" .. p268)
                        if targetTile then
                            if remaining <= 0 then
                                targetTile.Visible = false
                            else
                                local btn = targetTile:FindFirstChild("Button", true)
                                if btn then
                                    for _, lbl in ipairs(btn:GetDescendants()) do
                                        if lbl:IsA("TextLabel") and lbl.Name:match("^AmountTextLabel") then
                                            lbl.Text = (p269 == "Pets") and "" or ("x" .. tostring(remaining))
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if type(rebuildSending) == "function" then rebuildSending() end
                end
                
                if available > 1 then
                    promptQuantity("Add", available, applyAmount)
                else
                    applyAmount(1)
                end
            end
            
            if MailboxController._removeFromSend then
                MailboxController._removeFromSend = function(self, p275)
                    local v276 = u44[p275]
                    if not v276 or v276.Selected <= 0 then return end
                    
                    local maxAmt = 1
                    if PlayerStateClient then
                        local replica = PlayerStateClient:GetLocalReplica()
                        if replica and replica.Data and replica.Data.Inventory then
                            local realVal = replica.Data.Inventory[v276.Category] and replica.Data.Inventory[v276.Category][v276.ItemKey]
                            if type(realVal) == "number" then maxAmt = realVal end
                        end
                    end
                    
                    local currentSelected = v276.Selected
                    
                    local function applyRemove(removeCount)
                        v276.Selected = v276.Selected - removeCount
                        if v276.Selected <= 0 then u44[p275] = nil end
                        
                        local totalNow = 0
                        for k, v in pairs(u44) do
                            if v.Category == v276.Category and v.ItemKey == v276.ItemKey then
                                totalNow = totalNow + (v.Selected or 0)
                            end
                        end
                        local remaining = maxAmt - totalNow
                        
                        local baseKey = p275:gsub("_s%d+$", "")
                        
                        local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                        local inventoryFrame = playerGui and playerGui:FindFirstChild("MailboxUI") and playerGui.MailboxUI:FindFirstChild("InventoryFrame", true)
                        if inventoryFrame then
                            local targetTile = inventoryFrame:FindFirstChild("Inv_" .. baseKey)
                            if targetTile then
                                local btn = targetTile:FindFirstChild("Button", true)
                                if btn then
                                    for _, lbl in ipairs(btn:GetDescendants()) do
                                        if lbl:IsA("TextLabel") and lbl.Name:match("^AmountTextLabel") then
                                            lbl.Text = (v276.Category == "Pets") and "" or ("x" .. tostring(remaining))
                                        end
                                    end
                                end
                                
                                local customSearchBox = playerGui.MailboxUI:FindFirstChild("CustomSearchBox", true)
                                local query = customSearchBox and customSearchBox.Text:lower() or ""
                                local itemName = targetTile.Name:sub(5):match("^[^:]+:(.+)$")
                                itemName = itemName and itemName:lower() or ""
                                
                                if query == "" or itemName:find(query, 1, true) then
                                    targetTile.Visible = true
                                else
                                    targetTile.Visible = false
                                end
                            end
                        end
                        
                        if type(rebuildSending) == "function" then rebuildSending() end
                    end
                    
                    if currentSelected > 1 then
                        promptQuantity("Remove", currentSelected, applyRemove)
                    else
                        applyRemove(1)
                    end
                end
            end
            
            -- UI Search Filter & Details Injection
            local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                local mailboxUI = playerGui:FindFirstChild("MailboxUI")
                if mailboxUI then
                    local itemSendFrame = mailboxUI:FindFirstChild("ItemSendFrame", true)
                    local scrollingFrames = itemSendFrame and itemSendFrame:FindFirstChild("ScrollingFrames")
                    local inventoryFrame = scrollingFrames and scrollingFrames:FindFirstChild("InventoryFrame")
                    local selectPlayerFrame = mailboxUI:FindFirstChild("SelectPlayerFrame", true)
                    local originalTopbar = selectPlayerFrame and selectPlayerFrame:FindFirstChild("Topbar")
                    
                    if itemSendFrame and scrollingFrames and inventoryFrame and originalTopbar and not itemSendFrame:FindFirstChild("Topbar") then
                        -- Sesuai request user: copy seluruh Topbar ke dalam ItemSendFrame
                        local clonedTopbar = originalTopbar:Clone()
                        clonedTopbar.Parent = itemSendFrame
                        
                        -- Sembunyikan tulisan 'Your Inventory' lama
                        local yourInventory = itemSendFrame:FindFirstChild("Your Inventory")
                        if yourInventory then yourInventory.Visible = false end
                        
                        -- Set ulang posisi InventoryFrame secara presisi sesuai request
                        inventoryFrame.Position = UDim2.new(0.320875138, 0, 0.600000024, 0)
                        
                        local searchBox = clonedTopbar:FindFirstChild("SearchBox")
                        if searchBox then
                            searchBox.Text = ""
                            searchBox.PlaceholderText = "Search item..."
                            
                            -- Hapus script bawaan dari original UI
                            for _, v in ipairs(searchBox:GetChildren()) do
                                if v:IsA("LocalScript") or v:IsA("Script") then v:Destroy() end
                            end
                        end
                        
                        local MailboxItemCatalog = require(game:GetService("Players").LocalPlayer.PlayerScripts.Controllers.MailboxController.MailboxItemCatalog)
                        
                        local function applyLabel(child, category, itemKey, inv, MailboxItemCatalog)
                            local originalItemKey = itemKey:gsub("_s%d+$", "")
                            local resolvedName = originalItemKey
                            if inv and inv[category] and inv[category][originalItemKey] then
                                local entryData = inv[category][originalItemKey]
                                local rName = MailboxItemCatalog.Resolve(category, originalItemKey, entryData)
                                if rName then
                                    resolvedName = rName
                                    if category == "HarvestedFruits" and type(entryData) == "table" then
                                        local mut = entryData.Mutation
                                        local weight = entryData.Weight
                                        local fruitName = entryData.FruitName or entryData.Name or "Fruit"
                                        resolvedName = fruitName
                                        
                                        if mut and mut ~= "" and mut ~= "None" then resolvedName = resolvedName .. " [" .. mut .. "]" end
                                        if weight then resolvedName = resolvedName .. string.format(" (%.2f kg)", weight) end
                                        
                                        local ok, err = pcall(function()
                                            local RS = game:GetService("ReplicatedStorage")
                                            local sizeMulti = entryData.SizeMultiplier or entryData.SizeMulti or 1
                                            local decayAlpha = entryData.DecayAlpha or 0
                                            
                                            local rawName = fruitName
                                            if string.match(rawName, " [sS]eed$") then rawName = string.gsub(rawName, " [sS]eed$", "") end
                                            
                                            local FruitValueCalc = require(RS.SharedModules.FruitValueCalc)
                                            local SellFlags = require(RS.SharedModules.Flags.SellFlags)
                                            
                                            local rawVal = FruitValueCalc(rawName, sizeMulti, (mut ~= "" and mut ~= "None") and mut or nil, game:GetService("Players").LocalPlayer, decayAlpha)
                                            local sellVal = math.floor(SellFlags.Apply(rawName, rawVal))
                                            
                                            if sellVal == 0 then
                                                local SellValueData = require(RS.SharedModules.FruitData.SellValueData)
                                                local baseValue = SellValueData[rawName] or 0
                                                if baseValue > 0 then
                                                    local mutMulti = 1
                                                    local MutationData = require(RS.SharedModules.FruitData.MutationData)
                                                    if MutationData and MutationData.ReturnPriceMultiplier then
                                                        mutMulti = MutationData.ReturnPriceMultiplier(mut) or 1
                                                    end
                                                    sellVal = math.floor(SellFlags.Apply(rawName, baseValue * sizeMulti ^ 2.65 * mutMulti))
                                                end
                                            end
                                            
                                            if sellVal > 0 then
                                                resolvedName = resolvedName .. " | 💸" .. tostring(sellVal)
                                            end
                                        end)
                                        if not ok then
                                            resolvedName = resolvedName .. " | Err"
                                            warn("Mailbox ESP Error: " .. tostring(err))
                                        end
                                    end
                                end
                            end
                            local lbl = child:FindFirstChild("CustomItemName", true)
                            if not lbl then
                                lbl = Instance.new("TextLabel")
                                lbl.Name = "CustomItemName"
                                lbl.Size = UDim2.new(1, 0, 0, 26)
                                lbl.Position = UDim2.new(0, 0, 0, 0)
                                lbl.BackgroundTransparency = 0.5
                                lbl.BackgroundColor3 = Color3.new(0,0,0)
                                lbl.TextColor3 = Color3.new(1,1,1)
                                lbl.TextScaled = true
                                lbl.Font = Enum.Font.GothamBold
                                lbl.ZIndex = 5
                                local frame = child:FindFirstChild("Frame")
                                local btn = frame and frame:FindFirstChild("Button")
                                lbl.Parent = btn or child
                            end
                            lbl.Text = resolvedName
                            return resolvedName
                        end

                        local function refreshListAndLabels()
                            if not searchBox then return end
                            local query = searchBox.Text:lower()
                            local replica = PlayerStateClient and PlayerStateClient:GetLocalReplica()
                            local inv = replica and replica.Data and replica.Data.Inventory
                            
                            for _, child in ipairs(inventoryFrame:GetChildren()) do
                                if child:IsA("Frame") and child.Name:match("^Inv_") then
                                    local p268 = child.Name:sub(5)
                                    local category, itemKey = p268:match("^([^:]+):(.+)$")
                                    local isMatch = false
                                    if category and itemKey then
                                        local maxAmt = 1
                                        if inv and inv[category] and inv[category][itemKey] then
                                            local realVal = inv[category][itemKey]
                                            if type(realVal) == "number" then maxAmt = realVal end
                                        end
                                        
                                        local selected = (u44 and u44[p268] and u44[p268].Selected) or 0
                                        local remaining = maxAmt - selected
                                        
                                        local resolvedName = applyLabel(child, category, itemKey, inv, MailboxItemCatalog)
                                        local itemName = resolvedName:lower()
                                        
                                        if remaining > 0 then
                                            if query == "" or itemName:find(query, 1, true) or category:lower():find(query, 1, true) then
                                                isMatch = true
                                            end
                                        end
                                    end
                                    child.Visible = isMatch
                                end
                            end
                            
                            local realSendingFrame = mailboxUI:FindFirstChild("Frame") 
                                and mailboxUI.Frame:FindFirstChild("SendingFrame") 
                                and mailboxUI.Frame.SendingFrame:FindFirstChild("ItemSendFrame") 
                                and mailboxUI.Frame.SendingFrame.ItemSendFrame:FindFirstChild("ScrollingFrames") 
                                and mailboxUI.Frame.SendingFrame.ItemSendFrame.ScrollingFrames:FindFirstChild("SendingFrame")
                            if realSendingFrame then
                                for _, child in ipairs(realSendingFrame:GetChildren()) do
                                    if child:IsA("Frame") and child.Name:match("^Send_") then
                                        local category, itemKey = child.Name:sub(6):match("^([^:]+):(.+)$")
                                        if category and itemKey then
                                            applyLabel(child, category, itemKey, inv, MailboxItemCatalog)
                                        end
                                    end
                                end
                            end
                        end
                        
                        if searchBox then
                            searchBox:GetPropertyChangedSignal("Text"):Connect(refreshListAndLabels)
                        end
                        
                        -- Sistem debounce untuk mengatasi bug lag ekstrem saat mengklik barang ke daftar kirim
                        local isRefreshing = false
                        local function requestRefresh()
                            if isRefreshing then return end
                            isRefreshing = true
                            task.defer(function()
                                refreshListAndLabels()
                                isRefreshing = false
                            end)
                        end
                        
                        -- Dengarkan UI update
                        inventoryFrame.ChildAdded:Connect(function(child)
                            if child:IsA("Frame") and child.Name:match("^Inv_") then
                                requestRefresh()
                            end
                        end)
                        
                        local realSendingFrame = mailboxUI:FindFirstChild("Frame") 
                            and mailboxUI.Frame:FindFirstChild("SendingFrame") 
                            and mailboxUI.Frame.SendingFrame:FindFirstChild("ItemSendFrame") 
                            and mailboxUI.Frame.SendingFrame.ItemSendFrame:FindFirstChild("ScrollingFrames") 
                            and mailboxUI.Frame.SendingFrame.ItemSendFrame.ScrollingFrames:FindFirstChild("SendingFrame")
                        if realSendingFrame then
                            realSendingFrame.ChildAdded:Connect(function(child)
                                if child:IsA("Frame") and child.Name:match("^Send_") then
                                    requestRefresh()
                                end
                            end)
                        end
                        
                        -- Initial trigger
                        task.spawn(function()
                            task.wait(0.1)
                            requestRefresh()
                        end)
                    end
                end
            end
            
            if type(rebuildInventory) == "function" then rebuildInventory() end
            _G.MailboxPatched = true
            notif("Mailbox UI Patched! (Limit bypassed, Fruits shown & Search added)", 3, "Success")
        else
            notif("Gagal melakukan patch pada MailboxController", 3, "Error")
        end
    end
})


local AutoDropSection = TradeTab:AddSection("Auto Drop")
Config.AutoDropItems = {}

local function getDroppableInventory()
    local list = {}
    for _, tool in ipairs(getAllPlayerTools()) do
        local name = tool.Name
        if not table.find(UNGIFTABLE_GEARS, name) then
            local displayName = name
            if isFruitTool(tool) then
                displayName = getFormattedFruitName(tool)
            elseif (table.find(SEED_LIST, name) or table.find(MUTATION_LIST, name) or name == "Gold" or name == "Mega" or name == "Rainbow") and not string.match(name, " Seed$") then
                displayName = name .. " Seed"
            end
            
            if not table.find(list, displayName) then
                table.insert(list, displayName)
            end
        end
    end
    table.sort(list)
    if #list == 0 then table.insert(list, "None") end
    return list
end

local AutoDropDropdown
AutoDropDropdown = AutoDropSection:AddDropdown({
    Title = "Items to Drop",
    Options = getDroppableInventory(),
    Default = {},
    Multi = true,
    Callback = function(val)
        if type(val) == "table" then
            Config.AutoDropItems = val
        else
            Config.AutoDropItems = {val}
        end
    end
})

local AutoDropAmount = 0
AutoDropSection:AddInput({
    Title = "Amount to Drop",
    Content = "Batas drop per item (0 = tak terbatas/semuanya)",
    Callback = function(val)
        AutoDropAmount = tonumber(val) or 0
    end
})

AutoDropSection:AddButton({
    Title = "Refresh Items List",
    Content = "Refresh the dropdown with current inventory items",
    Callback = function()
        local newList = getDroppableInventory()
        AutoDropDropdown:SetValues(newList)
        notif("Drop list updated!", 3, "Trade")
    end
})

local autoDropActive = false
function startAutoDropLoop()
    if autoDropActive then return end
    autoDropActive = true
    task.spawn(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Net = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Networking"))
        
        local droppedCounts = {} -- Tracks drops during this toggle session
        
        while Config.AutoDrop and _G.GagAutoScriptActive do
                    local char = LocalPlayer.Character
                    local bp = LocalPlayer:FindFirstChild("Backpack")
                    
                    local itemsToDrop = {}
                    
                    local function checkItem(itemObj)
                        if itemObj.Name == "Shovel" or itemObj.Name == "Build" then return end
                        
                        local category = nil
                        local uuid = nil
                        
                        if itemObj:GetAttribute("HarvestedFruit") == true then
                            category = "HarvestedFruits"
                            uuid = itemObj:GetAttribute("Id")
                        elseif itemObj:GetAttribute("PetId") and type(itemObj:GetAttribute("PetId")) == "string" and itemObj:GetAttribute("PetId") ~= "" then
                            category = "Pets"
                            uuid = itemObj:GetAttribute("PetId")
                        else
                            local u5 = {
                                SeedTool = "Seeds",
                                SeedPack = "SeedPacks",
                                Crate = "Crates",
                                Sprinkler = "Sprinklers",
                                WateringCan = "WateringCans",
                                Mushroom = "Mushrooms",
                                Gnome = "Gnomes",
                                Raccoon = "Raccoons",
                                Teleporter = "Teleporters",
                                Magnet = "Magnets",
                                Wheelbarrow = "Wheelbarrows",
                                Trowel = "Trowels",
                                Crowbar = "Crowbars",
                                Ladder = "Ladders",
                                FreezeRay = "FreezeRays",
                                PowerHose = "PowerHoses",
                                Rake = "Rakes",
                                Lantern = "Lanterns",
                                Sign = "Signs",
                                EmptyPot = "EmptyPots",
                                Flashbang = "Flashbangs",
                                Bird = "Birds"
                            }
                            for attr, cat in pairs(u5) do
                                if itemObj:GetAttribute(attr) ~= nil then
                                    category = cat
                                    uuid = itemObj:GetAttribute(attr)
                                    break
                                end
                            end
                        end
                        
                        if category and uuid then
                            local toolName = itemObj.Name
                            local matchName = toolName
                            if isFruitTool(itemObj) then
                                matchName = getFormattedFruitName(itemObj)
                            elseif (table.find(SEED_LIST, toolName) or table.find(MUTATION_LIST, toolName) or toolName == "Gold" or toolName == "Mega" or toolName == "Rainbow") and not string.match(toolName, " Seed$") then
                                matchName = toolName .. " Seed"
                            end
                            
                            local isSelected = false
                            for _, selectedCat in ipairs(Config.AutoDropItems) do
                                if matchName == selectedCat then
                                    isSelected = true
                                    break
                                end
                            end
                            
                            if isSelected then
                                table.insert(itemsToDrop, {Category = category, Id = uuid, ItemObj = itemObj, MatchName = matchName})
                            end
                        end
                    end
                    
                    for _, v in ipairs(getAllPlayerTools()) do checkItem(v) end
                    
                    for _, dropData in ipairs(itemsToDrop) do
                        if not Config.AutoDrop then break end
                        
                        local mName = dropData.MatchName
                        droppedCounts[mName] = droppedCounts[mName] or 0
                        
                        -- Skip if we have reached the user-specified amount limit
                        if AutoDropAmount > 0 and droppedCounts[mName] >= AutoDropAmount then
                            continue
                        end
                        
                        if dropData.ItemObj and char and dropData.ItemObj.Parent ~= char then
                            local humanoid = char:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid:EquipTool(dropData.ItemObj)
                                task.wait(0.2)
                            end
                        end
                        
                        pcall(function() Net.DroppedItem.RequestDrop:Fire(dropData.Category, dropData.Id) end)
                        droppedCounts[mName] = droppedCounts[mName] + 1
                        
                        local timeout = 0
                        while dropData.ItemObj and dropData.ItemObj.Parent and (dropData.ItemObj.Parent == char or dropData.ItemObj.Parent == bp) and timeout < 20 do
                            task.wait(0.1)
                            timeout = timeout + 1
                        end
                    end
                    
                    task.wait(2)
                end
            autoDropActive = false
        end)
end

AutoDropSection:AddToggle({
    Title = "Enable Auto Drop",
    Default = false,
    Callback = function(val)
        Config.AutoDrop = val
        if UI_LOADED and val then
            startAutoDropLoop()
        end
    end
})

-- Handle player list updates
Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then
        table.insert(playerList, p.Name)
        TradeDropdown:SetValues(playerList)
    end
end)
Players.PlayerRemoving:Connect(function(p)
    local idx = table.find(playerList, p.Name)
    if idx then
        table.remove(playerList, idx)
        TradeDropdown:SetValues(playerList)
    end
end)
end -- LoadTradeTab
local helperWCActive = false
local function startHelperWCLoop()
    if helperWCActive then return end
    helperWCActive = true
    task.spawn(function()
        local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
        local wcNotFoundCount = 0
        
        while Config.HelperAutoWateringCan do
            if not _G.GagAutoScriptActive then
                task.wait(1)
                continue
            end
            
            local plotMode = Config.HelperWCPlotMode or "My Plot"
            local targetTreeName = Config.HelperWCTree or "Apple"
            
            local char = LocalPlayer.Character
            if not char then
                task.wait(1)
                continue
            end
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then
                task.wait(1)
                continue
            end
            
            -- SAVED POSITION MODE
            if plotMode == "Saved Position" then
                if not Config.HelperWCSavedPos then
                    notif("No saved position! Save a position first.", 3, "Error")
                    task.wait(3)
                    continue
                end
                
                local targetPos = Vector3.new(Config.HelperWCSavedPos.X, Config.HelperWCSavedPos.Y, Config.HelperWCSavedPos.Z)
                
                -- Tween to position
                local distance = (hrp.Position - targetPos).Magnitude
                if distance > 5 then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    local walkSpeed = humanoid and humanoid.WalkSpeed or 16
                    local duration = math.clamp(distance / walkSpeed, 0.3, 15)
                    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
                    tween:Play()
                    tween.Completed:Wait()
                end
                
                -- Auto Watering Can
                local toolName = Config.HelperWCTool or "Super Watering Can"
                local swcTool = char:FindFirstChild(toolName) or LocalPlayer.Backpack:FindFirstChild(toolName)
                if swcTool then
                    pcall(function()
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        if swcTool.Parent ~= char and humanoid then humanoid:EquipTool(swcTool) end
                        Networking.WateringCan.UseWateringCan:Fire(targetPos, swcTool.Name, swcTool)
                    end)
                    wcNotFoundCount = 0
                else
                    wcNotFoundCount = wcNotFoundCount + 1
                    if wcNotFoundCount > 10 then Config.HelperAutoWateringCan = false end
                end
                
                task.wait(Config.HelperWCDelay or 1)
                continue
            end
            
            -- PLOT MODE (My Plot or Friend's Plot)
            local targetPlot = nil
            if plotMode == "My Plot" then
                targetPlot = getMyPlot()
            elseif plotMode == "Friend's Plot" then
                local fName = string.lower(Config.HelperWCFriendName or "")
                if fName ~= "" then
                    for _, plot in ipairs(workspace.Gardens:GetChildren()) do
                        local _, owner = getPlotOwner(plot)
                        if owner and string.lower(tostring(owner)) == fName then
                            targetPlot = plot
                            break
                        end
                    end
                end
            end
            
            if not targetPlot then
                task.wait(3)
                continue
            end
            
            -- Find tree
            local targetPlant = nil
            local function findInFolder(folderName)
                local folder = targetPlot:FindFirstChild(folderName)
                if folder then
                    for _, model in ipairs(folder:GetChildren()) do
                        if model:IsA("Model") then
                            local seedName = model:GetAttribute("SeedName") or ""
                            local coreName = model:GetAttribute("CorePartName") or ""
                            local fruitName = model:GetAttribute("FruitName") or ""
                            local plantName = model:GetAttribute("PlantName") or ""
                            
                            local plantType = fruitName ~= "" and fruitName or coreName
                            if plantType == "" then plantType = seedName end
                            
                            if plantType == targetTreeName or seedName == targetTreeName or plantName == targetTreeName then
                                targetPlant = model
                                break
                            end
                        end
                    end
                end
            end
            findInFolder("Props")
            if not targetPlant then findInFolder("Plants") end
            
            if not targetPlant then
                task.wait(3)
                continue
            end
            
            local targetPos = targetPlant:GetPivot().Position
            
            -- Tween to tree
            local distance = (hrp.Position - targetPos).Magnitude
            if distance > 5 then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local walkSpeed = humanoid and humanoid.WalkSpeed or 16
                local duration = math.clamp(distance / walkSpeed, 0.3, 15)
                local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetPlant:GetPivot() + Vector3.new(0, 4, 0)})
                tween:Play()
                tween.Completed:Wait()
            end
            
            -- Auto Watering Can
            local toolName = Config.HelperWCTool or "Super Watering Can"
            local swcTool = char:FindFirstChild(toolName) or LocalPlayer.Backpack:FindFirstChild(toolName)
            if swcTool then
                pcall(function()
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if swcTool.Parent ~= char and humanoid then humanoid:EquipTool(swcTool) end
                    Networking.WateringCan.UseWateringCan:Fire(targetPos, swcTool.Name, swcTool)
                end)
                wcNotFoundCount = 0
            else
                wcNotFoundCount = wcNotFoundCount + 1
                if wcNotFoundCount > 10 then Config.HelperAutoWateringCan = false end
            end
            
            task.wait(Config.HelperWCDelay or 1)
        end
        helperWCActive = false
    end)
end

local helperSSActive = false
local function startHelperSSLoop()
    if helperSSActive then return end
    helperSSActive = true
    task.spawn(function()
        local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
        local ssNotFoundCount = 0
        
        local function isSprinklerNearby(pos, radius)
            local gardens = workspace:FindFirstChild("Gardens")
            if gardens then
                for _, plot in ipairs(gardens:GetChildren()) do
                    local function checkFolder(folderName)
                        local folder = plot:FindFirstChild(folderName)
                        if folder then
                            for _, p in ipairs(folder:GetChildren()) do
                                if p:IsA("Model") or p:IsA("BasePart") then
                                    local isSprinkler = p:GetAttribute("SprinklerName") or string.find(string.lower(p.Name), "sprinkler") or folderName == "Sprinklers"
                                    if isSprinkler then
                                        local pivot = p:IsA("Model") and p:GetPivot().Position or p.Position
                                        local dist = Vector3.new(pivot.X, 0, pivot.Z) - Vector3.new(pos.X, 0, pos.Z)
                                        if dist.Magnitude <= radius then
                                            return true
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    if checkFolder("Sprinklers") then return true end
                    if checkFolder("Props") then return true end
                end
            end
            return false
        end
        
        while Config.HelperAutoSprinkler do
            if not _G.GagAutoScriptActive then
                task.wait(1)
                continue
            end
            
            local plotMode = Config.HelperSSPlotMode or "My Plot"
            local targetTreeName = Config.HelperSSTree or "Apple"
            
            local char = LocalPlayer.Character
            if not char then
                task.wait(1)
                continue
            end
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then
                task.wait(1)
                continue
            end
            
            -- SAVED POSITION MODE
            if plotMode == "Saved Position" then
                if not Config.HelperSSSavedPos then
                    notif("No saved position! Save a position first.", 3, "Error")
                    task.wait(3)
                    continue
                end
                
                local targetPos = Vector3.new(Config.HelperSSSavedPos.X, Config.HelperSSSavedPos.Y, Config.HelperSSSavedPos.Z)
                
                -- Auto Sprinkler
                if not isSprinklerNearby(targetPos, 25) then
                    -- Tween to position
                    local distance = (hrp.Position - targetPos).Magnitude
                    if distance > 5 then
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        local walkSpeed = humanoid and humanoid.WalkSpeed or 16
                        local duration = math.clamp(distance / walkSpeed, 0.3, 15)
                        local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
                        tween:Play()
                        tween.Completed:Wait()
                    end
                    
                    local toolName = Config.HelperSSTool or "Super Sprinkler"
                    local ssTool = char:FindFirstChild(toolName) or LocalPlayer.Backpack:FindFirstChild(toolName)
                    if ssTool then
                        pcall(function()
                            local humanoid = char:FindFirstChildOfClass("Humanoid")
                            if ssTool.Parent ~= char and humanoid then humanoid:EquipTool(ssTool) end
                            Networking.Place.PlaceSprinkler:Fire(targetPos + Vector3.new(1.5, 0, 0), toolName, ssTool, 1) -- fake plotId for saved pos
                        end)
                        task.wait(1)
                    else
                        ssNotFoundCount = ssNotFoundCount + 1
                        if ssNotFoundCount > 10 then Config.HelperAutoSprinkler = false end
                    end
                end
                
                task.wait(1)
                continue
            end
            
            -- PLOT MODE (My Plot or Friend's Plot)
            local targetPlot = nil
            if plotMode == "My Plot" then
                targetPlot = getMyPlot()
            elseif plotMode == "Friend's Plot" then
                local fName = string.lower(Config.HelperSSFriendName or "")
                if fName ~= "" then
                    for _, plot in ipairs(workspace.Gardens:GetChildren()) do
                        local _, owner = getPlotOwner(plot)
                        if owner and string.lower(tostring(owner)) == fName then
                            targetPlot = plot
                            break
                        end
                    end
                end
            end
            
            if not targetPlot then
                task.wait(3)
                continue
            end
            
            -- Find tree
            local targetPlant = nil
            local function findInFolder(folderName)
                local folder = targetPlot:FindFirstChild(folderName)
                if folder then
                    for _, model in ipairs(folder:GetChildren()) do
                        if model:IsA("Model") then
                            local seedName = model:GetAttribute("SeedName") or ""
                            local coreName = model:GetAttribute("CorePartName") or ""
                            local fruitName = model:GetAttribute("FruitName") or ""
                            local plantName = model:GetAttribute("PlantName") or ""
                            
                            local plantType = fruitName ~= "" and fruitName or coreName
                            if plantType == "" then plantType = seedName end
                            
                            if plantType == targetTreeName or seedName == targetTreeName or plantName == targetTreeName then
                                targetPlant = model
                                break
                            end
                        end
                    end
                end
            end
            findInFolder("Props")
            if not targetPlant then findInFolder("Plants") end
            
            if not targetPlant then
                task.wait(3)
                continue
            end
            
            local targetPos = targetPlant:GetPivot().Position
            
            -- Auto Sprinkler
            if not isSprinklerNearby(targetPos, 25) then
                -- Tween to tree
                local distance = (hrp.Position - targetPos).Magnitude
                if distance > 5 then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    local walkSpeed = humanoid and humanoid.WalkSpeed or 16
                    local duration = math.clamp(distance / walkSpeed, 0.3, 15)
                    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetPlant:GetPivot() + Vector3.new(0, 4, 0)})
                    tween:Play()
                    tween.Completed:Wait()
                end
                
                local toolName = Config.HelperSSTool or "Super Sprinkler"
            local ssTool = char:FindFirstChild(toolName) or LocalPlayer.Backpack:FindFirstChild(toolName)
                if ssTool then
                    pcall(function()
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        if ssTool.Parent ~= char and humanoid then humanoid:EquipTool(ssTool) end
                        local plotId = tonumber(string.match(targetPlot.Name, "%d+")) or 1
                        Networking.Place.PlaceSprinkler:Fire(targetPos + Vector3.new(1.5, 0, 0), toolName, ssTool, plotId)
                    end)
                    task.wait(1)
                else
                    ssNotFoundCount = ssNotFoundCount + 1
                    if ssNotFoundCount > 10 then Config.HelperAutoSprinkler = false end
                end
            end
            
            task.wait(1)
        end
        helperSSActive = false
    end)
end

local helperPotActive = false
local function startHelperPotLoop()
    if helperPotActive then return end
    helperPotActive = true
    task.spawn(function()
        local potCount = 0
        while Config.HelperAutoPot and _G.GagAutoScriptActive do
            task.wait(0.5)
            if not Config.HelperAutoPot then break end
            
            if Config.HelperAutoPotAmount > 0 and potCount >= Config.HelperAutoPotAmount then
                notif("Auto Pot selesai: Mencapai limit (" .. potCount .. ")", 3, "Helper")
                Config.HelperAutoPot = false
                break
            end
            
            local hasSeeds = type(Config.HelperAutoPotSeeds) == "table" and #Config.HelperAutoPotSeeds > 0 and not (Config.HelperAutoPotSeeds[1] == "None" and #Config.HelperAutoPotSeeds == 1)
            if not hasSeeds then continue end
            
            local myPlot = getMyPlot()
            if myPlot then
                local plantsFolder = myPlot:FindFirstChild("Plants")
                if plantsFolder then
                    for _, plant in ipairs(plantsFolder:GetChildren()) do
                        if not Config.HelperAutoPot then break end
                        if Config.HelperAutoPotAmount > 0 and potCount >= Config.HelperAutoPotAmount then break end
                        
                        local seedName = plant:GetAttribute("SeedName")
                        if seedName and table.find(Config.HelperAutoPotSeeds, seedName) then
                            local potTool = nil
                            local char = LocalPlayer.Character
                            if char then
                                potTool = char:FindFirstChild(Config.HelperAutoPotTool)
                                if not potTool then
                                    for _, t in ipairs(char:GetChildren()) do
                                        if t:IsA("Tool") and t.Name == Config.HelperAutoPotTool then potTool = t break end
                                    end
                                end
                            end
                            if not potTool then
                                for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
                                    if t:IsA("Tool") and t.Name == Config.HelperAutoPotTool then potTool = t break end
                                end
                            end
                            
                            if potTool then
                                local hum = char and char:FindFirstChildOfClass("Humanoid")
                                if hum and potTool.Parent ~= char then
                                    hum:EquipTool(potTool)
                                    task.wait(0.1)
                                end
                                
                                local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
                                pcall(function()
                                    if Networking.Garden and Networking.Garden.PotPlant then
                                        Networking.Garden.PotPlant:Fire(plant.Name)
                                    end
                                end)
                                
                                potCount = potCount + 1
                                
                                local timeout = 0
                                while plant and plant.Parent and timeout < 3 do
                                    task.wait(0.1)
                                    timeout = timeout + 0.1
                                end
                                
                                task.wait(0.5)
                            else
                                notif(Config.HelperAutoPotTool .. " tidak ditemukan di inventory!", 3, "Error")
                                Config.HelperAutoPot = false
                                break
                            end
                        end
                    end
                end
            end
        end
        helperPotActive = false
    end)
end

local helperPlacePotActive = false
local function startHelperPlacePotLoop()
    if helperPlacePotActive then return end
    helperPlacePotActive = true
    task.spawn(function()
        while Config.HelperAutoPlacePot and _G.GagAutoScriptActive do
            task.wait(0.6)
            if not Config.HelperAutoPlacePot then break end
            
            local hasPlants = type(Config.HelperPlacePotPlants) == "table" and #Config.HelperPlacePotPlants > 0 and not (Config.HelperPlacePotPlants[1] == "None" and #Config.HelperPlacePotPlants == 1)
            if not hasPlants then continue end
            
            local char = LocalPlayer.Character
            if not char then continue end
            local myPlot = getMyPlot()
            if not myPlot then continue end
            
            local potTools = {}
            local containers = {char, LocalPlayer:FindFirstChild("Backpack")}
            for _, cont in ipairs(containers) do
                if cont then
                    for _, item in ipairs(cont:GetChildren()) do
                        if item:IsA("Tool") then
                            local isPotted = item:GetAttribute("PottedPlant") or string.find(item.Name, "Potted")
                            if isPotted then
                                local plantName = item:GetAttribute("PlantName")
                                if not plantName or plantName == "" then
                                    plantName = string.gsub(item.Name, "Potted ", "")
                                    plantName = string.gsub(plantName, "Potted", "")
                                    plantName = string.match(plantName, "^%s*(.-)%s*$")
                                end
                                
                                local matchAll = table.find(Config.HelperPlacePotPlants, "All") ~= nil
                                local matchSpecific = table.find(Config.HelperPlacePotPlants, plantName) or table.find(Config.HelperPlacePotPlants, item.Name)
                                if matchAll or matchSpecific then
                                    table.insert(potTools, item)
                                end
                            end
                        end
                    end
                end
            end
            
            if #potTools == 0 then continue end
            
            local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
            if not (Networking.PotPlacement and Networking.PotPlacement.PlacePottedPlant) then continue end
            
            for _, tool in ipairs(potTools) do
                if not Config.HelperAutoPlacePot then break end
                
                local toolId = tool:GetAttribute("Id") or tool:GetAttribute("id") or tool:GetAttribute("UUID") or tool.Name
                if not toolId or toolId == "" then continue end
                
                local mode = Config.HelperPlacePotMode or "Player Position"
                local targetPos = nil
                
                if mode == "Player Position" then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local origin = hrp.Position + hrp.CFrame.LookVector * 3 + Vector3.new(0, 2, 0)
                        local rayParams = RaycastParams.new()
                        rayParams.FilterDescendantsInstances = {char}
                        rayParams.FilterType = Enum.RaycastFilterType.Exclude
                        
                        local hit = workspace:Raycast(origin, Vector3.new(0, -20, 0), rayParams)
                        if hit then
                            targetPos = hit.Position
                        else
                            targetPos = hrp.Position + hrp.CFrame.LookVector * 3 - Vector3.new(0, 3, 0)
                        end
                    end
                else
                    local zone = myPlot:FindFirstChild("Visual") and myPlot.Visual:FindFirstChild("GardenZonePart")
                    if not zone then zone = myPlot:FindFirstChild("GardenZonePart") end
                    if zone then
                        local size = zone.Size
                        local cf = zone.CFrame
                        local randX = (math.random() - 0.5) * (size.X * 0.85)
                        local randZ = (math.random() - 0.5) * (size.Z * 0.85)
                        
                        local topPos = (cf * CFrame.new(randX, size.Y/2 + 5, randZ)).Position
                        local rayDir = Vector3.new(0, -size.Y - 50, 0)
                        local hitPos = nil
                        
                        local ignoreList = {char}
                        for i = 1, 15 do
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = ignoreList
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            
                            local hit = workspace:Raycast(topPos, rayDir, rayParams)
                            if hit then
                                local p = hit.Instance
                                local m = p:FindFirstAncestorWhichIsA("Model")
                                local isPlantOrPot = false
                                if m and (m:GetAttribute("PlantId") or m:GetAttribute("SeedName") or m:FindFirstChild("PotVisual") or string.find(m.Name, "Potted")) then
                                    isPlantOrPot = true
                                end
                                if p:FindFirstChildOfClass("ProximityPrompt") then
                                    isPlantOrPot = true
                                end
                                
                                if isPlantOrPot or p.Name == "GardenZonePart" or p.Transparency >= 0.9 then
                                    table.insert(ignoreList, m or p)
                                else
                                    hitPos = hit.Position
                                    break
                                end
                            else
                                break
                            end
                        end
                        
                        if hitPos then
                            targetPos = hitPos
                        else
                            targetPos = (cf * CFrame.new(randX, -size.Y/2 + 0.5, randZ)).Position
                        end
                    end
                end
                
                if targetPos then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and tool.Parent ~= char then
                        pcall(function() hum:EquipTool(tool) end)
                        task.wait(0.2)
                    end
                    
                    local rotY = math.random(0, 359)
                    pcall(function()
                        Networking.PotPlacement.PlacePottedPlant:Fire(targetPos, rotY, toolId)
                    end)
                    task.wait(0.8)
                end
            end
        end
        helperPlacePotActive = false
    end)
end


local helperEclipseActive = false
local function startHelperEclipseLoop()
    if helperEclipseActive then return end
    helperEclipseActive = true
    
    local function checkEclipseActive()
        local isEclipse = false
        local RS = game:GetService("ReplicatedStorage")
        local activeW = workspace:GetAttribute("ActiveWeather") or ""
        if string.find(string.lower(tostring(activeW)), "eclipse") then
            isEclipse = true
        end
        local wv = RS:FindFirstChild("WeatherValues")
        if wv then
            if wv:GetAttribute("Eclipse_Playing") == true then
                local endTime = wv:GetAttribute("Eclipse_EndTime") or 0
                if endTime == 0 or endTime > os.time() then
                    isEclipse = true
                end
            end
        end
        return isEclipse
    end
    
    task.spawn(function()
        while Config.HelperAutoEclipse and _G.GagAutoScriptActive do
            task.wait(1)
            if not Config.HelperAutoEclipse then break end
            
            -- 1. Cek apakah cuaca Eclipse sudah aktif
            if checkEclipseActive() then
                continue
            end
            
            -- 3. Cari plot milik kita
            local myPlot = getMyPlot()
            if not myPlot then continue end
            
            -- Kumpulkan semua ProximityPrompt dari CollectionService & folder plot (persis seperti Auto Harvest)
            local prompts = {}
            local promptSet = {}
            
            for _, p in ipairs(CollectionService:GetTagged("HarvestPrompt")) do
                if p:IsA("ProximityPrompt") and p.Enabled and not promptSet[p] then
                    promptSet[p] = true
                    table.insert(prompts, p)
                end
            end
            
            local plantsFolder = myPlot:FindFirstChild("Plants")
            if plantsFolder then
                for _, p in ipairs(plantsFolder:GetDescendants()) do
                    if p:IsA("ProximityPrompt") and p.Enabled and not promptSet[p] then
                        promptSet[p] = true
                        table.insert(prompts, p)
                    end
                end
            end
            
            -- 4. Cari Eclipse Bloom yang siap dipanen
            local targetPrompt = nil
            local targetPlantId = nil
            local targetFruitId = ""
            local targetModel = nil
            local targetsToHarvest = {}
            
            for _, prompt in ipairs(prompts) do
                if not Config.HelperAutoEclipse then break end
                
                local parent = prompt.Parent
                local model = parent and parent:FindFirstAncestorWhichIsA("Model")
                if not (model and model:IsDescendantOf(myPlot)) then
                    continue
                end
                
                -- Cek secara mendalam apakah ini Eclipse Bloom (cek nama object text, nama part, dan semua atribut)
                local isEclipseBloom = false
                local objText = string.lower(tostring(prompt.ObjectText or ""))
                local actText = string.lower(tostring(prompt.ActionText or ""))
                if string.find(objText, "eclipse", 1, true) or string.find(actText, "eclipse", 1, true) then
                    isEclipseBloom = true
                end
                
                local curr = prompt.Parent
                while curr and curr ~= workspace and curr ~= myPlot do
                    local n = string.lower(tostring(curr.Name or ""))
                    if string.find(n, "eclipse", 1, true) then
                        isEclipseBloom = true
                    end
                    local sName = string.lower(tostring(curr:GetAttribute("SeedName") or ""))
                    local cName = string.lower(tostring(curr:GetAttribute("CorePartName") or ""))
                    local fName = string.lower(tostring(curr:GetAttribute("FruitName") or ""))
                    local pName = string.lower(tostring(curr:GetAttribute("PlantName") or ""))
                    if string.find(sName, "eclipse", 1, true) or string.find(cName, "eclipse", 1, true) or string.find(fName, "eclipse", 1, true) or string.find(pName, "eclipse", 1, true) then
                        isEclipseBloom = true
                    end
                    curr = curr.Parent
                end
                
                if isEclipseBloom then
                    -- Cek Max KG jika diatur > 0
                    local isUnderLimit = true
                    if Config.HelperEclipseMaxKg > 0 then
                        local weightGrams = 0
                        if FruitVisualizerController then
                            pcall(function()
                                weightGrams = FruitVisualizerController:CalculateFruitWeight(model)
                                if not weightGrams and FruitVisualizerController.CalculatePlantWeight then
                                    weightGrams = FruitVisualizerController:CalculatePlantWeight(model)
                                end
                            end)
                        end
                        weightGrams = tonumber(weightGrams) or 0
                        
                        if weightGrams == 0 then
                            pcall(function()
                                local baseName = model:GetAttribute("CorePartName") or model:GetAttribute("SeedName") or ""
                                baseName = string.gsub(baseName, "%s+[sS]eed$", "")
                                local sizeMulti = model:GetAttribute("SizeMulti") or 1
                                local baseWeight = 0
                                local fruitMod = RS:FindFirstChild("PlantGenerationModules") and RS.PlantGenerationModules:FindFirstChild("Fruits") and RS.PlantGenerationModules.Fruits:FindFirstChild(baseName)
                                local plantMod = RS:FindFirstChild("PlantGenerationModules") and RS.PlantGenerationModules:FindFirstChild("Plants") and RS.PlantGenerationModules.Plants:FindFirstChild(baseName)
                                local targetMod = fruitMod or plantMod
                                
                                if targetMod then
                                    local req = require(targetMod)
                                    if req and req.GrowData and req.GrowData.BaseWeight then
                                        baseWeight = req.GrowData.BaseWeight
                                    end
                                end
                                
                                local age = model:GetAttribute("Age") or 100
                                local maxAge = model:GetAttribute("MaxAge") or 100
                                local overtime = 1
                                if age >= maxAge then
                                    local plantedAt = model:GetAttribute("PlantedAt")
                                    if plantedAt then
                                        overtime = math.max(1, (os.time() - plantedAt) / 3600)
                                    end
                                end
                                weightGrams = baseWeight * sizeMulti * overtime
                            end)
                        end
                        
                        if weightGrams == 0 then weightGrams = 9999999 end
                        if weightGrams > Config.HelperEclipseMaxKg then
                            isUnderLimit = false
                        end
                    end
                    
                    if isUnderLimit then
                        -- Prioritaskan ambil ID dari model (seperti Auto Harvest biasa), baru cari ke hierarki ancestor
                        local pId = model:GetAttribute("PlantId")
                        local fId = model:GetAttribute("FruitId") or ""
                        
                        local c = prompt.Parent
                        while c and c ~= workspace and c ~= myPlot do
                            if not pId then
                                pId = c:GetAttribute("PlantId")
                            end
                            if fId == "" or not fId then
                                local fid = c:GetAttribute("FruitId")
                                if fid and fid ~= "" then
                                    fId = fid
                                end
                            end
                            c = c.Parent
                        end
                        
                        if pId then
                            if not targetPrompt then targetPrompt = prompt end
                            targetPlantId = pId
                            table.insert(targetsToHarvest, { prompt = prompt, plantId = pId, fruitId = fId })
                        end
                    end
                end
            end
            
            -- 5. Eksekusi harvest 1 buah Eclipse Bloom untuk memicu cuaca
            if #targetsToHarvest > 0 then
                local target = targetsToHarvest[1]
                notif("Memanen 1 buah Eclipse Bloom untuk memicu cuaca Eclipse...", 3, "Helper Eclipse")
                local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
                
                -- Kirim remote event dengan berbagai format ID agar kompatibel di semua executor
                pcall(function() Networking.Garden.CollectFruit:Fire(target.plantId, target.fruitId) end)
                pcall(function() Networking.Garden.CollectFruit:Fire(tonumber(target.plantId) or target.plantId, target.fruitId) end)
                
                -- Tembak ProximityPrompt secara fisik
                if target.prompt and target.prompt:IsA("ProximityPrompt") then
                    pcall(function()
                        if not target.prompt.Enabled then target.prompt.Enabled = true end
                        if fireproximityprompt then
                            fireproximityprompt(target.prompt)
                        end
                    end)
                end
                
                -- Delay 2 detik sebelum mengecek status cuaca Eclipse
                task.wait(2)
                
                -- Cek apakah cuaca Eclipse sudah aktif pasca panen 1 buah
                if checkEclipseActive() then
                    local delaySecs = tonumber(Config.HelperEclipseDelay) or 120
                    if delaySecs < 1 then delaySecs = 1 end
                    notif("Cuaca Eclipse berhasil aktif! Menunggu jeda " .. tostring(delaySecs) .. " detik...", 3, "Helper Eclipse")
                    local waited = 0
                    while waited < delaySecs and Config.HelperAutoEclipse and _G.GagAutoScriptActive do
                        task.wait(1)
                        waited = waited + 1
                    end
                else
                    notif("Cuaca Eclipse belum aktif! Mencoba harvest 1 buah lagi...", 3, "Helper Eclipse")
                end
            end
        end
        helperEclipseActive = false
    end)
end

local function LoadHelperTab()
    local HelperTab = Tabs:AddTab({ Name = "Helper", Icon = "wrench" })
    
    local helperWCOptions = {}
    local helperSSOptions = {}
    for _, gear in ipairs(GEAR_LIST) do
        if string.find(gear, "Watering Can") then
            table.insert(helperWCOptions, gear)
        end
        if string.find(gear, "Sprinkler") then
            table.insert(helperSSOptions, gear)
        end
    end
    if #helperWCOptions == 0 then helperWCOptions = {"Common Watering Can", "Super Watering Can", "Golden Watering Can"} end
    if #helperSSOptions == 0 then helperSSOptions = {"Common Sprinkler", "Super Sprinkler"} end

    -- =================== AUTO WATERING CAN ===================
    local HelperWCSection = HelperTab:AddSection("Auto Watering Can")
    
    HelperWCSection:AddParagraph({
        Title = "Info:",
        Content = "Fitur Auto Watering Can berjalan secara loop terus menerus tanpa melakukan rejoin."
    })
    
    Config.HelperWCTool = Config.HelperWCTool or "Super Watering Can"
    HelperWCSection:AddDropdown({
        Title = "Select Watering Can",
        Options = helperWCOptions,
        Default = {Config.HelperWCTool},
        Multi = false,
        Callback = function(val)
            if type(val) == "table" then val = val[1] end
            Config.HelperWCTool = val
        end
    })
    
    Config.HelperWCPlotMode = Config.HelperWCPlotMode or "My Plot"
    HelperWCSection:AddDropdown({
        Title = "Player Plot",
        Options = {"My Plot", "Friend's Plot", "Saved Position"},
        Default = {Config.HelperWCPlotMode},
        Multi = false,
        Callback = function(val)
            if type(val) == "table" then val = val[1] end
            Config.HelperWCPlotMode = val
        end
    })
    
    Config.HelperWCFriendName = Config.HelperWCFriendName or ""
    HelperWCSection:AddInput({
        Title = "Friend's Display Name",
        Default = Config.HelperWCFriendName,
        Callback = function(val) Config.HelperWCFriendName = val end
    })
    
    Config.HelperWCTree = Config.HelperWCTree or "Apple"
    local helperTreeOptions = {}
    for _, s in ipairs(SEED_LIST) do
        if s ~= "None" then table.insert(helperTreeOptions, s) end
    end
    HelperWCSection:AddDropdown({
        Title = "Select Tree/Plant",
        Options = helperTreeOptions,
        Default = {Config.HelperWCTree},
        Multi = false,
        Callback = function(val)
            if type(val) == "table" then val = val[1] end
            Config.HelperWCTree = val
        end
    })
    
    Config.HelperWCSavedPos = Config.HelperWCSavedPos or nil
    local wcSavedPosParagraph = HelperWCSection:AddParagraph({
        Title = "Saved Position:",
        Content = Config.HelperWCSavedPos and ("X: " .. math.floor(Config.HelperWCSavedPos.X) .. " Y: " .. math.floor(Config.HelperWCSavedPos.Y) .. " Z: " .. math.floor(Config.HelperWCSavedPos.Z)) or "Not saved yet"
    })
    
    pcall(function()
        if isfile and readfile and HttpService then
            if isfile("Napoleon_GAG_WC_SavedPos.json") then
                local data = HttpService:JSONDecode(readfile("Napoleon_GAG_WC_SavedPos.json"))
                if data and data.X then
                    Config.HelperWCSavedPos = data
                    local text = "X: " .. math.floor(data.X) .. " Y: " .. math.floor(data.Y) .. " Z: " .. math.floor(data.Z)
                    pcall(function() wcSavedPosParagraph:SetContent(text) end)
                end
            end
        end
    end)
    
    HelperWCSection:AddButton({
        Title = "Save Current Position",
        Callback = function()
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos = hrp.Position
                    Config.HelperWCSavedPos = {X = pos.X, Y = pos.Y, Z = pos.Z}
                    pcall(function()
                        if writefile and HttpService then
                            writefile("Napoleon_GAG_WC_SavedPos.json", HttpService:JSONEncode(Config.HelperWCSavedPos))
                        end
                    end)
                    local text = "X: " .. math.floor(pos.X) .. " Y: " .. math.floor(pos.Y) .. " Z: " .. math.floor(pos.Z)
                    pcall(function() wcSavedPosParagraph:SetContent(text) end)
                    notif("Watering Can Position saved!", 3, "Helper")
                end
            end
        end
    })
    
    Config.HelperWCDelay = Config.HelperWCDelay or 1
    HelperWCSection:AddInput({
        Title = "Watering Delay (Seconds)",
        Content = "Delay time between each watering",
        Default = tostring(Config.HelperWCDelay),
        Numeric = true,
        Callback = function(val)
            Config.HelperWCDelay = tonumber(val) or 1
        end
    })
    
    HelperWCSection:AddToggle({
        Title = "Auto Watering Can",
        Default = false,
        Callback = function(val)
            Config.HelperAutoWateringCan = val
            if UI_LOADED and val then startHelperWCLoop() end
        end
    })
    
    -- =================== AUTO SPRINKLER ===================
    local HelperSSSection = HelperTab:AddSection("Auto Sprinkler")
    
    Config.HelperSSTool = Config.HelperSSTool or "Super Sprinkler"
    HelperSSSection:AddDropdown({
        Title = "Select Sprinkler",
        Options = helperSSOptions,
        Default = {Config.HelperSSTool},
        Multi = false,
        Callback = function(val)
            if type(val) == "table" then val = val[1] end
            Config.HelperSSTool = val
        end
    })
    
    Config.HelperSSPlotMode = Config.HelperSSPlotMode or "My Plot"
    HelperSSSection:AddDropdown({
        Title = "Player Plot",
        Options = {"My Plot", "Friend's Plot", "Saved Position"},
        Default = {Config.HelperSSPlotMode},
        Multi = false,
        Callback = function(val)
            if type(val) == "table" then val = val[1] end
            Config.HelperSSPlotMode = val
        end
    })
    
    Config.HelperSSFriendName = Config.HelperSSFriendName or ""
    HelperSSSection:AddInput({
        Title = "Friend's Display Name",
        Default = Config.HelperSSFriendName,
        Callback = function(val) Config.HelperSSFriendName = val end
    })
    
    Config.HelperSSTree = Config.HelperSSTree or "Apple"
    HelperSSSection:AddDropdown({
        Title = "Select Tree/Plant",
        Options = helperTreeOptions,
        Default = {Config.HelperSSTree},
        Multi = false,
        Callback = function(val)
            if type(val) == "table" then val = val[1] end
            Config.HelperSSTree = val
        end
    })
    
    Config.HelperSSSavedPos = Config.HelperSSSavedPos or nil
    local ssSavedPosParagraph = HelperSSSection:AddParagraph({
        Title = "Saved Position:",
        Content = Config.HelperSSSavedPos and ("X: " .. math.floor(Config.HelperSSSavedPos.X) .. " Y: " .. math.floor(Config.HelperSSSavedPos.Y) .. " Z: " .. math.floor(Config.HelperSSSavedPos.Z)) or "Not saved yet"
    })
    
    HelperSSSection:AddButton({
        Title = "Save Current Position",
        Callback = function()
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos = hrp.Position
                    Config.HelperSSSavedPos = {X = pos.X, Y = pos.Y, Z = pos.Z}
                    pcall(function()
                        local HttpService = game:GetService("HttpService")
                        if writefile and HttpService then
                            writefile("Napoleon_GAG_SS_SavedPos.json", HttpService:JSONEncode(Config.HelperSSSavedPos))
                        end
                    end)
                    local text = "X: " .. math.floor(pos.X) .. " Y: " .. math.floor(pos.Y) .. " Z: " .. math.floor(pos.Z)
                    pcall(function() ssSavedPosParagraph:SetContent(text) end)
                    notif("Sprinkler Position saved!", 3, "Helper")
                end
            end
        end
    })
    
    pcall(function()
        local HttpService = game:GetService("HttpService")
        if isfile and readfile and HttpService then
            if isfile("Napoleon_GAG_SS_SavedPos.json") then
                local data = HttpService:JSONDecode(readfile("Napoleon_GAG_SS_SavedPos.json"))
                if data and data.X then
                    Config.HelperSSSavedPos = data
                    local text = "X: " .. math.floor(data.X) .. " Y: " .. math.floor(data.Y) .. " Z: " .. math.floor(data.Z)
                    pcall(function() ssSavedPosParagraph:SetContent(text) end)
                end
            end
        end
    end)
    
    HelperSSSection:AddToggle({
        Title = "Auto Sprinkler",
        Default = false,
        Callback = function(val)
            Config.HelperAutoSprinkler = val
            if UI_LOADED and val then startHelperSSLoop() end
        end
    })
    
    -- =================== AUTO PUT IN POT ===================
    local HelperPotSection = HelperTab:AddSection("Auto Put in Pot")
    
    Config.HelperAutoPotTool = Config.HelperAutoPotTool or "Basic Pot"
    HelperPotSection:AddDropdown({
        Title = "Select Pot Tool",
        Options = {"Basic Pot", "Advanced Pot", "Magic Pot"},
        Default = {Config.HelperAutoPotTool},
        Multi = false,
        Callback = function(val)
            if type(val) == "table" then val = val[1] end
            Config.HelperAutoPotTool = val
        end
    })
    
    Config.HelperAutoPotSeeds = Config.HelperAutoPotSeeds or {"None"}
    HelperPotSection:AddDropdown({
        Title = "Select Plant",
        Options = helperTreeOptions,
        Default = Config.HelperAutoPotSeeds,
        Multi = true,
        Callback = function(val)
            Config.HelperAutoPotSeeds = val
        end
    })
    
    Config.HelperAutoPotAmount = Config.HelperAutoPotAmount or 0
    HelperPotSection:AddInput({
        Title = "Input Amount (0 = Infinite)",
        Default = tostring(Config.HelperAutoPotAmount),
        Numeric = true,
        Callback = function(val)
            Config.HelperAutoPotAmount = tonumber(val) or 0
        end
    })
    
    HelperPotSection:AddToggle({
        Title = "Auto Put in Pot",
        Default = false,
        Callback = function(val)
            Config.HelperAutoPot = val
            if UI_LOADED and val then startHelperPotLoop() end
        end
    })
    
    local placePotTreeOptions = {"All"}
    for _, opt in ipairs(helperTreeOptions) do
        table.insert(placePotTreeOptions, opt)
    end
    Config.HelperPlacePotPlants = Config.HelperPlacePotPlants or {"All"}
    HelperPotSection:AddDropdown({
        Title = "Select Potted Plant to Place",
        Options = placePotTreeOptions,
        Default = Config.HelperPlacePotPlants,
        Multi = true,
        Callback = function(val)
            Config.HelperPlacePotPlants = val
        end
    })
    
    Config.HelperPlacePotMode = Config.HelperPlacePotMode or "Player Position"
    HelperPotSection:AddDropdown({
        Title = "Place Position Mode",
        Options = {"Player Position", "Random (Plot)"},
        Default = {Config.HelperPlacePotMode},
        Multi = false,
        Callback = function(val)
            if type(val) == "table" then val = val[1] end
            Config.HelperPlacePotMode = val
        end
    })
    
    HelperPotSection:AddToggle({
        Title = "Auto Place Potted Plant",
        Default = false,
        Callback = function(val)
            Config.HelperAutoPlacePot = val
            if UI_LOADED and val then startHelperPlacePotLoop() end
        end
    })
    
    HelperPotSection:AddButton({
        Title = "Collect All Placed Potted Plants",
        Callback = function()
            task.spawn(function()
                local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
                if not (Networking.PotPlacement and Networking.PotPlacement.PickUpPottedPlant) then
                    notif("Remote PickUpPottedPlant tidak ditemukan!", 3, "Error")
                    return
                end
                
                local myPlot = getMyPlot()
                if myPlot then
                    local count = 0
                    local folders = {myPlot:FindFirstChild("Plants"), myPlot:FindFirstChild("Props")}
                    for _, folder in ipairs(folders) do
                        if folder then
                            for _, child in ipairs(folder:GetChildren()) do
                                if child:IsA("Model") and #child.Name > 20 then
                                    local isPotted = child:FindFirstChild("PotVisual") ~= nil
                                    if isPotted then
                                        Networking.PotPlacement.PickUpPottedPlant:Fire(child.Name)
                                        count = count + 1
                                        
                                        -- Jeda stabil 0.6 detik agar tidak terkena rate-limit/spam filter server
                                        task.wait(1.2)
                                    end
                                end
                            end
                        end
                    end
                    notif("Berhasil request ambil " .. count .. " potted plants!", 3, "Helper")
                else
                    notif("Plot Anda tidak ditemukan!", 3, "Error")
                end
            end)
        end
    })
    
    local HelperEclipseSection = HelperTab:AddSection("Auto Eclipse Weather")
    
    HelperEclipseSection:AddParagraph({
        Title = "Info Auto Eclipse",
        Content = "Fitur ini akan memanen tepat 1 buah Eclipse Bloom untuk memicu cuaca Eclipse. Jika cuaca aktif, script akan menunggu sesuai durasi Eclipse Harvest Delay. Jika belum aktif, script akan mencoba memanen 1 buah lagi."
    })
    
    Config.HelperEclipseMaxKg = Config.HelperEclipseMaxKg or 0
    HelperEclipseSection:AddInput({
        Title = "Max KG (Weight Limit)",
        Content = "Batas maksimum KG Eclipse Bloom untuk dipanen (Isi 0 untuk tanpa batas kg)",
        Default = tostring(Config.HelperEclipseMaxKg),
        Numeric = true,
        Callback = function(val)
            Config.HelperEclipseMaxKg = tonumber(val) or 0
        end
    })
    
    Config.HelperEclipseDelay = Config.HelperEclipseDelay or 120
    HelperEclipseSection:AddInput({
        Title = "Eclipse Harvest Delay (Seconds)",
        Content = "Jeda waktu per panen Eclipse Bloom (Default: 120 detik / 2 menit)",
        Default = tostring(Config.HelperEclipseDelay),
        Numeric = true,
        Callback = function(val)
            local d = tonumber(val) or 120
            if d < 1 then d = 1 end
            Config.HelperEclipseDelay = d
        end
    })
    
    HelperEclipseSection:AddToggle({
        Title = "Auto Eclipse Weather",
        Default = false,
        Callback = function(val)
            Config.HelperAutoEclipse = val
            if UI_LOADED and val then startHelperEclipseLoop() end
        end
    })
end


local hideGardensConns = {}
local hiddenPlants = {}
local plantDescConns = {} -- Track per-plant DescendantAdded connections to prevent stacking
local HiddenPlantsFolder = game:GetService("Lighting"):FindFirstChild("HiddenPlantsCache") or Instance.new("Folder")
HiddenPlantsFolder.Name = "HiddenPlantsCache"
HiddenPlantsFolder.Parent = game:GetService("Lighting")

local hideUpdateId = 0

-- ====== QUEUE-BASED PLANT PROCESSOR ======
-- Instead of processing all plants at once (causing CPU spikes),
-- we process 1 plant per heartbeat frame, spreading the work.
local _hideQueue = {}        -- {plant, folder, mode}
local _hideQueueRunning = false
local _hideQueueConn = nil
local _processedPlants = {}  -- set of plants already fully processed (prevents re-work)

-- Pre-compute important name set (shared across all plants)
local _importantNames = {
    CorePart = true, Hitbox = true, FruitSpawnLocations = true
}

-- Pre-compute destroy-on-add classes (shared across all per-plant handlers)
local _destroyOnAdd = {
    ParticleEmitter = true, Fire = true, Smoke = true,
    Sparkles = true, Trail = true, Beam = true
}

-- Lightweight instant-hide: just make all BaseParts invisible immediately
-- This is very cheap (<0.1ms per plant) and prevents visual pop-in
local function instantHidePlant(plant, mode)
    if not plant then return end
    if mode ~= "Plants" then
        -- Fast path: Hide everything immediately without checking tree hierarchy
        for _, desc in ipairs(plant:GetDescendants()) do
            local cn = desc.ClassName
            if desc:IsA("BasePart") or cn == "Decal" or cn == "Texture" then
                desc.Transparency = 1
            end
        end
        return
    end
    -- Plants mode (keep fruits visible): check parent name
    for _, desc in ipairs(plant:GetDescendants()) do
        local cn = desc.ClassName
        if desc:IsA("BasePart") or cn == "Decal" or cn == "Texture" then
            local isFruit = false
            local curr = desc
            while curr and curr ~= plant do
                if curr.Name == "Fruits" or curr.Name == "HarvestPart" then
                    isFruit = true
                    break
                end
                curr = curr.Parent
            end
            if not isFruit then desc.Transparency = 1 end
        end
    end
end

-- Heavy cleanup for a single plant (called from queue, 1 per frame)
local function deepCleanPlant(plant, folder)
    if not plant or not plant.Parent then return end
    
    local mode = Config.HideGardenMode or "Fruit & Plants"
    
    -- Disconnect existing per-plant connection to prevent stacking
    if plantDescConns[plant] then
        pcall(function() plantDescConns[plant]:Disconnect() end)
        plantDescConns[plant] = nil
    end
    
    plant:SetAttribute("PlantDestroyed", true)
    
    local primaryPart = plant.PrimaryPart
    
    local function isImportantTreePart(desc)
        if desc == primaryPart or desc:IsA("Attachment") then return true end
        
        local curr = desc
        while curr and curr ~= plant do
            if _importantNames[curr.Name] then return true end
            curr = curr.Parent
        end
        
        for _, c in ipairs(desc:GetChildren()) do
            if _importantNames[c.Name] or c == primaryPart or c:IsA("Attachment") then
                return true
            end
        end
        return false
    end
    
    local function hideDescendant(desc)
        if desc:IsA("BasePart") or desc:IsA("Decal") or desc:IsA("Texture") or desc:IsA("ParticleEmitter") or desc:IsA("Fire") or desc:IsA("PointLight") or desc:IsA("SurfaceLight") or desc:IsA("SpotLight") then
            local isFruit = false
            local curr = desc
            while curr and curr ~= plant do
                if curr.Name == "Fruits" or curr.Name == "HarvestPart" then
                    isFruit = true
                    break
                end
                curr = curr.Parent
            end
            
            if not isFruit then
                pcall(function()
                    local important = isImportantTreePart(desc)
                    if important then
                        if desc:IsA("BasePart") then
                            desc.Transparency = 1
                            desc.CanCollide = false
                            desc.CanQuery = false
                            desc.CanTouch = false
                        elseif desc:IsA("Decal") or desc:IsA("Texture") then
                            desc.Transparency = 1
                        end
                    else
                        desc:Destroy()
                    end
                end)
            else
                -- Bagian buah
                if mode == "Fruit & Plants" then
                    pcall(function()
                        if desc:IsA("BasePart") then
                            desc.Transparency = 1
                            desc.CanCollide = false
                            desc.CanQuery = false
                            desc.CanTouch = false
                            
                            local tConn = desc:GetPropertyChangedSignal("Transparency"):Connect(function()
                                if desc.Transparency ~= 1 then desc.Transparency = 1 end
                            end)
                            table.insert(hideGardensConns, tConn)
                        elseif desc:IsA("Decal") or desc:IsA("Texture") then
                            desc.Transparency = 1
                        end
                    end)
                end
            end
        end
    end

    for _, desc in ipairs(plant:GetDescendants()) do
        hideDescendant(desc)
    end
    
    -- DescendantAdded: for new parts that stream in AFTER cleanup.
    local dConn = plant.DescendantAdded:Connect(function(desc)
        local isFruit = false
        local curr = desc
        while curr and curr ~= plant do
            if curr.Name == "Fruits" or curr.Name == "HarvestPart" then
                isFruit = true
                break
            end
            curr = curr.Parent
        end
        
        if isFruit then
            if mode == "Plants" then return end
            
            local cn = desc.ClassName
            if desc:IsA("BasePart") then
                desc.Transparency = 1
                desc.CanCollide = false
                desc.CanQuery = false
                desc.CanTouch = false
                
                local tConn = desc:GetPropertyChangedSignal("Transparency"):Connect(function()
                    if desc.Transparency ~= 1 then desc.Transparency = 1 end
                end)
                table.insert(hideGardensConns, tConn)
            elseif cn == "Decal" or cn == "Texture" then
                desc.Transparency = 1
            end
            return
        end
        
        task.defer(function()
            if not desc or not desc.Parent then return end
            pcall(function()
                local cn = desc.ClassName
                if _destroyOnAdd[cn] then
                    desc:Destroy()
                    return
                end
                
                if desc:IsA("BasePart") or desc:IsA("Decal") or desc:IsA("Texture") or desc:IsA("ParticleEmitter") or desc:IsA("Fire") or desc:IsA("PointLight") or desc:IsA("SurfaceLight") or desc:IsA("SpotLight") then
                    local important = isImportantTreePart(desc)
                    if important then
                        if desc:IsA("BasePart") then
                            desc.Transparency = 1
                            desc.CanCollide = false
                            desc.CanQuery = false
                            desc.CanTouch = false
                        elseif cn == "Decal" or cn == "Texture" then
                            desc.Transparency = 1
                        end
                    else
                        desc:Destroy()
                    end
                end
            end)
        end)
    end)
    plantDescConns[plant] = dConn
    table.insert(hideGardensConns, dConn)
    

    
    _processedPlants[plant] = true
end

-- Start the queue processor (time-budgeted per Heartbeat frame)
local function startHideQueue()
    if _hideQueueRunning then return end
    _hideQueueRunning = true
    
    if _hideQueueConn then
        pcall(function() _hideQueueConn:Disconnect() end)
    end
    
    _hideQueueConn = RunService.Heartbeat:Connect(function()
        if #_hideQueue == 0 then
            -- Queue empty, stop processing
            _hideQueueRunning = false
            if _hideQueueConn then
                _hideQueueConn:Disconnect()
                _hideQueueConn = nil
            end
            return
        end
        
        -- Process items using time budget (< 3ms per frame) & pop from end (O(1)) instead of table.remove(1) (O(N))
        local startTime = os.clock()
        while #_hideQueue > 0 do
            local idx = #_hideQueue
            local item = _hideQueue[idx]
            _hideQueue[idx] = nil
            if item and item.plant and item.plant.Parent then
                pcall(function()
                    deepCleanPlant(item.plant, item.folder)
                    if item.mode ~= "Fruit & Plants" and item.plant.Parent == HiddenPlantsFolder then
                        item.plant.Parent = item.folder
                    end
                end)
            end
            if os.clock() - startTime >= 0.003 then
                break
            end
        end
    end)
end

-- Add plant to processing queue (deduplicates automatically)
local function queuePlantForHide(plant, folder, mode)
    -- Skip if already fully processed
    if _processedPlants[plant] then return end
    
    -- Check if already in queue
    for _, item in ipairs(_hideQueue) do
        if item.plant == plant then return end
    end
    
    table.insert(_hideQueue, { plant = plant, folder = folder, mode = mode })
    startHideQueue()
end

local function updateHideGardens()
    hideUpdateId = hideUpdateId + 1
    local currentId = hideUpdateId
    
    task.spawn(function()
        local Gardens = workspace:FindFirstChild("Gardens")
        if not Gardens then return end

        for _, conn in ipairs(hideGardensConns) do
            if conn then conn:Disconnect() end
        end
        table.clear(hideGardensConns)
        
        -- Clear queue and processed cache on full update
        table.clear(_hideQueue)
        table.clear(_processedPlants)
        
        local plotsToHide = {}
        if Config.HideOtherGardens then
            for _, plot in ipairs(Gardens:GetChildren()) do
                local ownerId, ownerName = getPlotOwner(plot)
                local isMe = (tonumber(ownerId) == LocalPlayer.UserId or tostring(ownerName) == LocalPlayer.Name or tostring(ownerName) == LocalPlayer.DisplayName)
                
                local shouldHide = false
                if table.find(Config.HideGardensTarget, "All") and not isMe then shouldHide = true end
                if table.find(Config.HideGardensTarget, "Me") and isMe then shouldHide = true end
                
                if shouldHide then
                    plotsToHide[plot.Name] = true
                end
            end
        end

        -- Pindahkan kembali semua plant yang mungkin tersangkut di HiddenPlantsFolder dari versi sebelumnya
        local hiddenCount = 0
        for _, plant in ipairs(HiddenPlantsFolder:GetChildren()) do
            hiddenCount = hiddenCount + 1
            if hiddenCount % 20 == 0 then task.wait() end
            
            local plotName = plant:GetAttribute("OriginalPlot")
            local folderName = plant:GetAttribute("OriginalFolder")
            if plotName and folderName then
                -- Unhiding: disconnect per-plant connection and clear attribute
                if plantDescConns[plant] then
                    pcall(function() plantDescConns[plant]:Disconnect() end)
                    plantDescConns[plant] = nil
                end
                pcall(function() plant:SetAttribute("PlantDestroyed", nil) end)
                
                local plot = Gardens:FindFirstChild(plotName)
                if plot then
                    local f = plot:FindFirstChild(folderName)
                    if f then
                        plant.Parent = f
                    end
                end
            end
        end

        table.clear(hiddenPlants)
        if Config.HideOtherGardens then
            local mode = Config.HideGardenMode or "Fruit & Plants"
            for _, plot in ipairs(Gardens:GetChildren()) do
                if hideUpdateId ~= currentId then return end
                
                if plotsToHide[plot.Name] then
                    local plantsFolder = plot:FindFirstChild("Plants")
                    if plantsFolder then
                        -- Initial pass: instant-hide all, then queue deep cleanup
                        -- (We yield every 10 plants to prevent game freezing/crashing on first enable)
                        local initialCount = 0
                        for _, plant in ipairs(plantsFolder:GetChildren()) do
                            if hideUpdateId ~= currentId then return end
                            initialCount = initialCount + 1
                            if initialCount % 10 == 0 then task.wait() end
                            
                            instantHidePlant(plant, mode)
                            queuePlantForHide(plant, plantsFolder, mode)
                        end
                        
                        -- ChildAdded: when streaming brings plants back
                        local conn = plantsFolder.ChildAdded:Connect(function(plant)
                            local currentMode = Config.HideGardenMode or "Fruit & Plants"
                            -- STEP 1: Instant lightweight hide (< 0.1ms, no CPU spike)
                            instantHidePlant(plant, currentMode)
                            

                            
                            -- STEP 2: Mark as unprocessed and queue for deep cleanup
                            -- (will be processed 1 per frame, no spike)
                            _processedPlants[plant] = nil
                            
                            -- Small delay to let descendants stream in before deep cleanup
                            task.delay(0.5, function()
                                if plant and plant.Parent then
                                    queuePlantForHide(plant, plantsFolder, currentMode)
                                end
                            end)
                        end)
                        table.insert(hideGardensConns, conn)
                    end
                end
                
                pcall(function()
                    table.insert(hideGardensConns, plot:GetAttributeChangedSignal("OwnerUserId"):Connect(function()
                        if Config.HideOtherGardens then updateHideGardens() end
                    end))
                    table.insert(hideGardensConns, plot:GetAttributeChangedSignal("Owner"):Connect(function()
                        if Config.HideOtherGardens then updateHideGardens() end
                    end))
                end)
            end
        else
            -- Feature disabled: clean up all per-plant connections
            for plant, conn in pairs(plantDescConns) do
                pcall(function() conn:Disconnect() end)
            end
            table.clear(plantDescConns)
            -- Stop queue processor
            if _hideQueueConn then
                pcall(function() _hideQueueConn:Disconnect() end)
                _hideQueueConn = nil
                _hideQueueRunning = false
            end
            table.clear(_hideQueue)
            table.clear(_processedPlants)
        end
    end)
end

-- ============================================================
-- DISABLE ALL PROXIMITY PROMPTS
-- ============================================================
local function updateDisableAllPrompts()
    if Config.DisableAllPrompts then
        pcall(function()
            for _, prompt in ipairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    prompt.Enabled = false
                end
            end
        end)
        
        if _G.DisablePromptsConn == nil then
            _G.DisablePromptsConn = workspace.DescendantAdded:Connect(function(desc)
                if Config.DisableAllPrompts and desc:IsA("ProximityPrompt") then
                    desc.Enabled = false
                end
            end)
        end
        
        if not _G.DisablePromptsLoopActive then
            _G.DisablePromptsLoopActive = true
            task.spawn(function()
                while Config.DisableAllPrompts and _G.GagAutoScriptActive do
                    task.wait(2)
                    if not Config.DisableAllPrompts then break end
                    pcall(function()
                        for _, prompt in ipairs(workspace:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                                prompt.Enabled = false
                            end
                        end
                    end)
                end
                _G.DisablePromptsLoopActive = false
            end)
        end
        if UI_LOADED then notif("Disable All Prompts ON", 3, "Visuals") end
    else
        if _G.DisablePromptsConn then
            _G.DisablePromptsConn:Disconnect()
            _G.DisablePromptsConn = nil
        end
        pcall(function()
            for _, prompt in ipairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and not prompt.Enabled then
                    prompt.Enabled = true
                end
            end
        end)
        if UI_LOADED then notif("Disable All Prompts OFF", 3, "Visuals") end
    end
end

-- ============================================================
-- MOON CYCLE FINDER (SERVER HOP)
-- ============================================================
local VISITED_SERVERS_FILE = "Napoleon_GAG_MoonFinder_Visited.json"
local moonFinderActive = false

local function getMoonFinderData()
    local data = { visited = {}, target = {"Rainbow Moon"}, serverCache = {}, lastHopTime = 0 }
    pcall(function()
        if isfile and isfile(VISITED_SERVERS_FILE) then
            local raw = readfile(VISITED_SERVERS_FILE)
            local decoded = HttpService:JSONDecode(raw)
            if type(decoded) == "table" then
                if decoded.visited then
                    data.visited = decoded.visited or {}
                    data.target = decoded.target or {"Rainbow Moon"}
                    data.serverCache = decoded.serverCache or {}
                    data.lastHopTime = decoded.lastHopTime or 0
                elseif decoded.servers then
                    -- Migration from old format
                    data.visited = decoded.servers or {}
                    data.target = decoded.target or {"Rainbow Moon"}
                end
                if type(data.target) == "string" then
                    data.target = {data.target}
                end
            end
        end
    end)
    return data
end

local function saveMoonFinderData(data)
    pcall(function()
        if writefile then
            writefile(VISITED_SERVERS_FILE, HttpService:JSONEncode({
                visited = data.visited or {},
                target = data.target or Config.MoonFinderTarget,
                serverCache = data.serverCache or {},
                lastHopTime = os.time()
            }))
        end
    end)
end

local function clearVisitedServers()
    pcall(function()
        if writefile then
            writefile(VISITED_SERVERS_FILE, "{}")
        end
    end)
end

local function fetchAndCacheServers(data)
    -- Fetch server list from Roblox API (only called when cache is empty/exhausted)
    local placeId = game.PlaceId
    local allServers = {}
    local nextCursor = ""
    
    for page = 1, 3 do  -- Up to 300 servers
        local url = "https://games.roblox.com/v1/games/" .. tostring(placeId) .. "/servers/Public?sortOrder=Asc&limit=100"
        if nextCursor and nextCursor ~= "" then
            url = url .. "&cursor=" .. nextCursor
        end
        
        local success, response = pcall(function()
            return game:HttpGet(url)
        end)
        
        if not success or not response then break end
        
        local decodeSuccess, decoded = pcall(function()
            return HttpService:JSONDecode(response)
        end)
        
        if not decodeSuccess or not decoded or not decoded.data then break end
        
        for _, server in ipairs(decoded.data) do
            if server.id and server.playing and server.maxPlayers then
                table.insert(allServers, {
                    id = server.id,
                    playing = server.playing,
                    maxPlayers = server.maxPlayers
                })
            end
        end
        
        nextCursor = decoded.nextPageCursor
        if not nextCursor or nextCursor == "" then break end
        task.wait(0.5)
    end
    
    -- Shuffle
    for i = #allServers, 2, -1 do
        local j = math.random(i)
        allServers[i], allServers[j] = allServers[j], allServers[i]
    end
    
    data.serverCache = allServers
    data.visited = {}  -- Reset visited when fetching fresh
    saveMoonFinderData(data)
    return allServers
end

local PredictScreenGui = nil
local PredictTextLabel = nil


local function makePredictWindow(name, accentColor, titleText, initPos)
    local gui = Instance.new("ScreenGui")
    gui.Name = name
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
    local pcore = game:GetService("CoreGui")
    local ok = pcall(function() gui.Parent = pcore end)
    if not ok then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 0)
    frame.Position = initPos
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Parent = gui

    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingBottom = UDim.new(0, 16)
    uiPadding.Parent = frame

    local UserInputService = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 15))
    }
    gradient.Rotation = 90
    gradient.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = accentColor
    stroke.Thickness = 1.5
    stroke.Transparency = 0.2
    stroke.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    topBar.BackgroundTransparency = 0.5
    topBar.BorderSizePixel = 0
    topBar.Parent = frame

    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 8)
    topCorner.Parent = topBar

    local hideBottomCorner = Instance.new("Frame")
    hideBottomCorner.Size = UDim2.new(1, 0, 0, 10)
    hideBottomCorner.Position = UDim2.new(0, 0, 1, -10)
    hideBottomCorner.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    hideBottomCorner.BackgroundTransparency = 0.5
    hideBottomCorner.BorderSizePixel = 0
    hideBottomCorner.Parent = topBar

    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 24, 0, 24)
    logo.Position = UDim2.new(0, 12, 0.5, -12)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://136289055140268"
    logo.ImageColor3 = accentColor
    logo.Parent = topBar

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = topBar

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, 0)
    line.BackgroundColor3 = accentColor
    line.BorderSizePixel = 0
    line.Parent = topBar

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -24, 0, 0)
    textLabel.Position = UDim2.new(0, 12, 0, 52)
    textLabel.AutomaticSize = Enum.AutomaticSize.Y
    textLabel.BackgroundTransparency = 1
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    textLabel.Text = "Fetching..."
    textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.TextSize = 12
    textLabel.LineHeight = 1.15
    textLabel.RichText = true
    textLabel.Parent = frame

    return gui, textLabel
end

local function togglePredictUI(state)
    if state then
        if not PredictScreenGui then
            PredictScreenGui, PredictTextLabel = makePredictWindow(
                "NapoleonSeedPredictUI",
                Color3.fromRGB(0, 170, 255),
                "SEED PREDICTOR",
                UDim2.new(1, -320, 0.5, -130)
            )
        end
        PredictScreenGui.Enabled = true
    else
        if PredictScreenGui then PredictScreenGui.Enabled = false end
    end
end


local seedPredictActive = false
local function startSeedPredictLoop()
    if seedPredictActive then return end
    seedPredictActive = true
    task.spawn(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local SeedData = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("SeedData"))
        local SeedShop = ReplicatedStorage:WaitForChild("StockValues"):WaitForChild("SeedShop")
        local Items = SeedShop:WaitForChild("Items")
        local UnixNextRestock = SeedShop:WaitForChild("UnixNextRestock")
        local UnixLastRestock = SeedShop:WaitForChild("UnixLastRestock")
        
        local function GetRealStock()
            local real = {}
            for _, item in ipairs(Items:GetChildren()) do
                if item.Value > 0 then real[item.Name] = item.Value end
            end
            return real
        end

        local function SimulateRestock(seedVal)
            local rng = Random.new(seedVal)
            local result = {}
            for _, seedInfo in ipairs(SeedData) do
                if seedInfo.RestockShop and seedInfo.RestockChance then
                    local roll = rng:NextNumber() * 100
                    if roll <= seedInfo.RestockChance then
                        local qty = 1
                        if seedInfo.RestockValues then
                            qty = rng:NextInteger(seedInfo.RestockValues.Min, seedInfo.RestockValues.Max)
                        end
                        result[seedInfo.SeedName] = qty
                    end
                end
            end
            return result
        end

        local function ScoreMatch(real, predicted)
            local match = 0
            local total = 0
            for name, _ in pairs(real) do
                total = total + 1
                if predicted[name] then match = match + 1 end
            end
            return match, total
        end

        local BRUTE_OFFSET_RANGE = 50
        local INTERVALS = { 300, 360, 600, 900, 1800 }

        local cachedNextUnix = 0
        local cachedTargetSeed = ""
        local cachedNextStock = {}
        local cachedTargetStr = ""

        while Config.PredictUI and _G.GagAutoScriptActive do
            local lastUnix = UnixLastRestock.Value
            local nextUnix = UnixNextRestock.Value
            
            if nextUnix ~= cachedNextUnix or Config.PredictTargetSeed ~= cachedTargetSeed then
                cachedNextUnix = nextUnix
                cachedTargetSeed = Config.PredictTargetSeed
                
                local formulas = {}
                table.insert(formulas, { label = "raw UnixLast", seed = lastUnix })
                table.insert(formulas, { label = "raw UnixNext", seed = nextUnix })

                for _, interval in ipairs(INTERVALS) do
                    local cycleID = math.floor(lastUnix / interval)
                    local nextCycleID = math.floor(nextUnix / interval)

                    table.insert(formulas, { seed = cycleID, interval = interval })
                    table.insert(formulas, { seed = nextCycleID, interval = interval, isNext = true })

                    for k = 0, 9 do
                        table.insert(formulas, { seed = cycleID * 1000 + k, interval = interval, mul = 1000, k = k })
                    end

                    for offset = -BRUTE_OFFSET_RANGE, BRUTE_OFFSET_RANGE do
                        table.insert(formulas, { seed = cycleID + offset, interval = interval, offset = offset })
                    end
                end
                
                local realStock = GetRealStock()
                local bestScore = -1
                local bestFormula = nil
                
                for _, f in ipairs(formulas) do
                    local predicted = SimulateRestock(f.seed)
                    local match, _ = ScoreMatch(realStock, predicted)
                    if match > bestScore then
                        bestScore = match
                        bestFormula = f
                    end
                end
                
                local function getSeedFromFormula(f, i_offset)
                    if f.label == "raw UnixLast" or f.label == "raw UnixNext" then
                        local interval = f.interval or 300
                        return nextUnix + (i_offset * interval)
                    elseif f.interval then
                        local interval = f.interval
                        local nextCycleID = math.floor(nextUnix / interval)
                        local futCycleID = nextCycleID + i_offset
                        if f.mul then
                            return futCycleID * 1000 + f.k
                        else
                            local diff = f.seed - math.floor(lastUnix / interval)
                            return futCycleID + diff
                        end
                    else
                        return f.seed
                    end
                end
                
                local nextSeedVal = bestFormula and getSeedFromFormula(bestFormula, 0) or nil
                cachedNextStock = nextSeedVal and SimulateRestock(nextSeedVal) or {}
                
                -- Predict Future (Up to 3000 cycles = 250 hours)
                cachedTargetStr = ""
                if Config.PredictTargetSeed and Config.PredictTargetSeed ~= "None" and bestFormula then
                    local foundCycle = -1
                    for i = 1, 3000 do
                        local futSeedVal = getSeedFromFormula(bestFormula, i)
                        local futStock = SimulateRestock(futSeedVal)
                        if futStock[Config.PredictTargetSeed] then
                            foundCycle = i
                            break
                        end
                    end
                    if foundCycle == -1 then
                        cachedTargetStr = string.format("\n<font color='rgb(255,255,255)'><b>%s</b></font>\n<font color='rgb(150,150,150)'><i>Tidak ditemukan (batas 250 jam).</i></font>", Config.PredictTargetSeed)
                    else
                        local intv = bestFormula.interval or 300
                        local foundHours = math.floor((foundCycle * intv) / 3600)
                        local foundMins = math.floor(((foundCycle * intv) % 3600) / 60)
                        cachedTargetStr = string.format("\n<font color='rgb(0,255,150)'><b>%s</b></font>\n<font color='rgb(220,220,220)'>Muncul dlm %d siklus (%d jam, %d menit)</font>", Config.PredictTargetSeed, foundCycle, foundHours, foundMins)
                    end
                end
            end
            
            if PredictTextLabel then
                local timeLeft = nextUnix - os.time()
                if timeLeft < 0 then timeLeft = 0 end
                local displayStr = string.format("<font color='rgb(0,170,255)'><b>NEXT RESTOCK IN %02d:%02d</b></font>\n\n", math.floor(timeLeft/60), timeLeft%60)
                
                local count = 0
                for name, qty in pairs(cachedNextStock) do
                    local isTarget = (name == Config.PredictTargetSeed)
                    local color = isTarget and "rgb(0,255,150)" or "rgb(220,220,220)"
                    local bullet = isTarget and "\226\152\133" or "\226\128\162" -- escape sequences for Star and Bullet
                    
                    displayStr = displayStr .. string.format("<font color='%s'>%s %s x%d</font>\n", color, bullet, name, qty)
                    count = count + 1
                end
                if count == 0 then displayStr = displayStr .. " \226\128\162 <font color='rgb(100,100,100)'><i>Tidak ada stok / Gagal Prediksi</i></font>\n" end
                
                displayStr = displayStr .. "\n<font color='rgb(0,170,255)'><b>\240\159\142\175 TARGET TRACKER:</b></font>" .. cachedTargetStr
                PredictTextLabel.Text = displayStr
            end
            
            task.wait(1)
        end
        seedPredictActive = false
        togglePredictUI(false)
    end)
end

-- ======================================================================
-- WEATHER PREDICTOR (FIXED v2 - based on TimeCycleController.lua decompile)
-- TimeCycleData: Day=450s, Sunset=30s, Night=120s → Total=600s per cycle
-- Night Phase is index 3 in sorted order (StartOrder: Day=1, Sunset=2, Night=3)
-- RNG Formula (from TimeCycleController): Random.new(cycleIndex * 1000 + phaseIndex)
-- phaseIndex = 3 (Night's StartOrder), cycleIndex = math.floor(os.time() / totalCycleDuration)
-- ============================================================
local function predictNextNightWeather()
    local RS = game:GetService("ReplicatedStorage")
    local SharedModules = RS:FindFirstChild("SharedModules")
    local TimeCycleData, MoonGating
    if SharedModules then
        pcall(function()
            TimeCycleData = require(SharedModules:WaitForChild("TimeCycleData", 3))
            MoonGating = require(SharedModules:WaitForChild("MoonGating", 3))
        end)
    end
    
    if not TimeCycleData or not MoonGating then return "Moon", 0, false end
    
    local phases = {}
    for name, data in pairs(TimeCycleData.Data) do
        table.insert(phases, {
            Name = name,
            Weathers = data.Weathers,
            Duration = data.Lasts,
            Order = data.StartOrder
        })
    end
    table.sort(phases, function(a, b) return a.Order < b.Order end)
    
    local totalCycleDuration = 0
    local nightPhase, nightPhaseOffset = nil, 0
    for _, phase in ipairs(phases) do
        if phase.Name == "Night" then
            nightPhase = phase
            nightPhaseOffset = totalCycleDuration
        end
        totalCycleDuration = totalCycleDuration + phase.Duration
    end
    if not nightPhase or totalCycleDuration == 0 then return "Moon", 0, false end
    
    local now = os.time()
    local phaseName = workspace:GetAttribute("ActivePhase")
    local phaseEnd = workspace:GetAttribute("PhaseDuration")
    
    if phaseName == "Night" then
        local liveWeather = workspace:GetAttribute("ActiveWeather")
        if liveWeather and liveWeather ~= "None" then
            local timeRemaining = (phaseEnd or 0) - now
            if timeRemaining > 0 then return liveWeather, timeRemaining, true end
        end
    end
    
    local cycleIndex = math.floor(now / totalCycleDuration)
    local targetCycleIdx = cycleIndex
    local targetNightStart = (cycleIndex * totalCycleDuration) + nightPhaseOffset
    
    if now >= targetNightStart + nightPhase.Duration then
        targetCycleIdx = cycleIndex + 1
        targetNightStart = targetNightStart + totalCycleDuration
    elseif phaseName == "Night" then
        -- Inside night but invalid weather, predict this night's roll
        targetCycleIdx = cycleIndex
        targetNightStart = targetNightStart
    end
    
    local rng = Random.new(targetCycleIdx * 1000 + nightPhase.Order)
    local totalChance = 0
    for wName, wData in pairs(nightPhase.Weathers) do
        if not wData.AdminOnly and MoonGating.IsNaturallySpawnable(wName) then
            totalChance = totalChance + wData.Chance
        end
    end
    
    local roll = rng:NextNumber() * totalChance
    local accumulated = 0
    local predictedWeather = nil
    for wName, wData in pairs(nightPhase.Weathers) do
        if not wData.AdminOnly and MoonGating.IsNaturallySpawnable(wName) then
            accumulated = accumulated + wData.Chance
            if roll <= accumulated then
                predictedWeather = wName
                break
            end
        end
    end
    if not predictedWeather then
        for wName, wData in pairs(nightPhase.Weathers) do
            if not wData.AdminOnly and MoonGating.IsNaturallySpawnable(wName) then
                predictedWeather = wName
                break
            end
        end
    end
    
    local timeUntilNight = targetNightStart - now
    if timeUntilNight < 0 then timeUntilNight = 0 end
    return predictedWeather or "Moon", timeUntilNight, false
end

local function startMoonFinderLoop()
    if moonFinderActive then return end
    moonFinderActive = true
    
    task.spawn(function()
        -- Step 0: Check current server
        local currentWeather, timeUntil, isActive = predictNextNightWeather()
        local targetMoons = Config.MoonFinderTarget
        if type(targetMoons) == "string" then targetMoons = {targetMoons} end
        
        local targetsStr = table.concat(targetMoons, " or ")
        
        if table.find(targetMoons, currentWeather) then
            setEmergencyStopVisible(false) -- Hide when found
            if isActive then
                notif(currentWeather .. " is ACTIVE on this server!", 10, "Moon Finder")
                notif("Staying until event ends (" .. math.floor(timeUntil) .. "s left), then resuming hop.", 10, "Moon Finder")
                task.wait(timeUntil + 5) -- Wait for event to finish completely + buffer
            else
                local m = math.floor(timeUntil / 60)
                local s = math.floor(timeUntil % 60)
                notif(currentWeather .. " coming in " .. m .. "m " .. s .. "s! Staying here.", 10, "Moon Finder")
                task.wait(timeUntil + 120 + 5) -- Wait until it starts, finishes (120s), and buffer
            end
            
            -- After event ends, automatically continue finding
            if Config.MoonFinderActive then
                notif("Moon event ended. Resuming server hop...", 5, "Moon Finder")
                moonFinderActive = false
                task.wait(2)
                setEmergencyStopVisible(true)
                startMoonFinderLoop()
            end
            return
        end
        
        setEmergencyStopVisible(true) -- Show while hopping
        
        -- Not matching, need to hop
        local statusText = isActive and (currentWeather .. " active now, next night: " .. currentWeather) or ("Next night: " .. currentWeather)
        notif(statusText .. ". Searching for " .. targetsStr .. "...", 5, "Moon Finder")
        
        -- Give user 5 seconds to cancel before initiating hop sequence
        for i = 1, 10 do
            if not Config.MoonFinderActive then
                moonFinderActive = false
                setEmergencyStopVisible(false)
                notif("Hopping cancelled by user.", 3, "Moon Finder")
                return
            end
            task.wait(1)
        end
        
        -- Load persisted data (cached servers + visited list)
        local data = getMoonFinderData()
        data.target = targetMoons
        
        -- Mark current server as visited
        if not table.find(data.visited, game.JobId) then
            table.insert(data.visited, game.JobId)
        end
        
        -- If no cached servers, fetch fresh from API (only time we hit the API)
        if #data.serverCache == 0 then
            notif("Fetching server list from Roblox API...", 3, "Moon Finder")
            fetchAndCacheServers(data)
        else
            saveMoonFinderData(data)  -- Just save updated visited list
        end
        
        -- Find first unvisited candidate from cache
        local candidates = {}
        for _, server in ipairs(data.serverCache) do
            if server.id ~= game.JobId and not table.find(data.visited, server.id) then
                table.insert(candidates, server)
            end
        end
        
        if #candidates == 0 then
            -- All cached servers exhausted! Re-fetch + reset
            notif("All " .. #data.serverCache .. " cached servers visited! Re-fetching...", 5, "Moon Finder")
            task.wait(3)
            fetchAndCacheServers(data)
            
            -- Rebuild candidates from fresh cache
            for _, server in ipairs(data.serverCache) do
                if server.id ~= game.JobId then
                    table.insert(candidates, server)
                end
            end
            
            if #candidates == 0 then
                notif("No servers available. Retrying in 10s...", 5, "Moon Finder")
                task.wait(10)
                moonFinderActive = false
                if Config.MoonFinderActive then startMoonFinderLoop() end
                return
            end
        end
        
        -- Try teleporting to candidates, retry on failure
        for attempt, targetServer in ipairs(candidates) do
            if not Config.MoonFinderActive then
                moonFinderActive = false
                setEmergencyStopVisible(false)
                return
            end
            
            -- Mark visited BEFORE teleporting
            if not table.find(data.visited, targetServer.id) then
                table.insert(data.visited, targetServer.id)
                saveMoonFinderData(data)
            end
            
            local hopNum = #data.visited
            notif("Hop #" .. hopNum .. "/" .. #data.serverCache .. " -> Server (" .. targetServer.playing .. "/" .. targetServer.maxPlayers .. ")...", 5, "Moon Finder")
            
            local TeleportService = game:GetService("TeleportService")
            
            _G.SuppressAutoReconnect = true
            
            local tpSuccess, tpError = pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServer.id, LocalPlayer)
            end)
            
            if tpSuccess then
                local failed = false
                local conn
                conn = TeleportService.TeleportInitFailed:Connect(function(plr, result, msg)
                    if plr == LocalPlayer then
                        failed = true
                        game:GetService("GuiService"):ClearError()
                        notif("Server penuh/tertutup. Melewati...", 3, "Moon Finder")
                        conn:Disconnect()
                    end
                end)
                
                task.wait(10)
                if conn then conn:Disconnect() end
                _G.SuppressAutoReconnect = false
                
                if not failed then
                    notif("Teleport hanging. Trying next server...", 3, "Moon Finder")
                end
            else
                _G.SuppressAutoReconnect = false
                local errStr = tostring(tpError)
                warn("Moon Finder Teleport Error: " .. errStr)
                notif("Error: " .. string.sub(errStr, 1, 60), 5, "Moon Finder")
                task.wait(2)
            end
            
            if attempt >= 5 then
                break
            end
        end
        
        moonFinderActive = false
        if Config.MoonFinderActive then startMoonFinderLoop() end
    end)
end

-- Auto-resume Moon Finder after server hop (file persists across teleports)
task.spawn(function()
    task.wait(3)  -- Wait for script to fully load
    pcall(function()
        if isfile and isfile(VISITED_SERVERS_FILE) then
            local data = getMoonFinderData()
            -- Only auto-resume if the last hop was within the last 5 minutes (300s)
            if #data.visited > 0 and data.lastHopTime and (os.time() - data.lastHopTime) < 300 then
                Config.MoonFinderTarget = data.target or {"Rainbow Moon"}
                Config.MoonFinderActive = true
                setEmergencyStopVisible(true)
                startMoonFinderLoop()
            else
                -- Stale session or manual rejoin, clear visited list so it doesn't auto-resume later
                if #data.visited > 0 then
                    clearVisitedServers()
                end
            end
        end
    end)
end)

-- Auto-resume Pet Finder Hop after server hop
task.spawn(function()
    task.wait(3)
    pcall(function()
        if isfile and isfile("Napoleon_GAG_PetHop_Visited.json") then
            local HttpService = game:GetService("HttpService")
            local raw = readfile("Napoleon_GAG_PetHop_Visited.json")
            if raw and raw ~= "" then
                local data = HttpService:JSONDecode(raw)
                if data.active and data.lastHopTime and (os.time() - data.lastHopTime) < 300 then
                    Config.PetFinderHopTarget = data.target or {"None"}
                    if data.mode == "join" then
                        Config.AutoJoinPetFinder = true
                        setEmergencyStopVisible(true)
                        startJoinPetFinderLoop()
                    else
                        Config.AutoPetFinderHop = true
                        setEmergencyStopVisible(true)
                        startPetFinderHopLoop()
                    end
                else
                    if writefile then
                        writefile("Napoleon_GAG_PetHop_Visited.json", HttpService:JSONEncode({active = false, target = {"None"}, lastHopTime = 0}))
                    end
                end
            end
        end
    end)
end)


local function LoadVisualsTab()
-- TAB MISC
local VisualsTab = Tabs:AddTab({ Name = "Visuals", Icon = "eye" })

local FruitESPSection = VisualsTab:AddSection("Fruit ESP")
FruitESPSection:AddDropdown({
    Title = "Fruit ESP Mode",
    Description = "Market Price: harga real-time. Base Price: harga dasar.",
    Options = {"Market Price", "Base Price"},
    Default = {"Market Price"},
    Multi = false,
    Callback = function(v)
        Config.ESPFruitMode = type(v) == "table" and v[1] or v
    end
})
FruitESPSection:AddToggle({
    Title = "Enable Fruit ESP",
    Title2 = "On/Off",
    Description = "Tampilkan info buah (KG, Value, Mutation)",
    Default = Config.ESPFruit,
    Callback = function(v)
        Config.ESPFruit = v
    end
})

local espFruitOpts = {"All"}
for _, s in ipairs(SEED_LIST) do table.insert(espFruitOpts, s) end

FruitESPSection:AddDropdown({
    Title = "Plant Filter",
    Description = "Buah spesifik yang ingin ditampilkan ESP-nya",
    Options = espFruitOpts,
    Default = {"All"},
    Callback = function(v) Config.ESPFruitFilter = type(v) == "table" and v[1] or v end
})

-- ============================================================
-- PLANT FEET ESP SECTION
local PlantFeetESPSection = VisualsTab:AddSection("Plant Feet ESP")
PlantFeetESPSection:AddToggle({
    Title = "Enable Plant Feet ESP",
    Title2 = "On/Off",
    Description = "Tampilkan ukuran (KG/feet) tanaman saat tumbuh, bahkan sebelum 100%",
    Default = Config.ESPPlantFeet,
    Callback = function(v)
        Config.ESPPlantFeet = v
    end
})
PlantFeetESPSection:AddDropdown({
    Title = "Display Mode",
    Description = "Current: ukuran sekarang. Current+Final: sekarang & ukuran 100%",
    Options = {"Current Only", "Current + Final"},
    Default = {"Current + Final"},
    Multi = false,
    Callback = function(v)
        Config.ESPPlantFeetMode = type(v) == "table" and v[1] or v
    end
})

local InvESPSection = VisualsTab:AddSection("Inventory ESP")
InvESPSection:AddDropdown({
    Title = "Inventory ESP Mode",
    Description = "Market Price: harga real-time. Base Price: harga dasar.",
    Options = {"Market Price", "Base Price"},
    Default = {"Market Price"},
    Multi = false,
    Callback = function(v)
        Config.ESPInventoryMode = type(v) == "table" and v[1] or v
        -- Refresh mailbox fruit dropdown biar harga ikut mode ESP
        pcall(function()
            local items, fruits = buildInventoryLists()
            if MailboxItemDropdown then MailboxItemDropdown:SetValues(items) end
            if MailboxFruitDropdown then MailboxFruitDropdown:SetValues(fruits) end
            if AutoDropDropdown then AutoDropDropdown:SetValues(getDroppableInventory()) end
        end)
    end
})
InvESPSection:AddToggle({
    Title = "Enable Inventory ESP",
    Title2 = "On/Off",
    Description = "Tampilkan info value buah di dalam Inventory UI",
    Default = Config.ESPInventory,
    Callback = function(v)
        Config.ESPInventory = v
    end
})

FruitESPSection:AddDropdown({
    Title = "Plot Filter",
    Description = "Hanya tampilkan dari plot tertentu",
    Options = {"All", "My Plot"},
    Default = {"All"},
    Callback = function(v) Config.ESPPlotFilter = type(v) == "table" and v[1] or v end
})

FruitESPSection:AddDropdown({
    Title = "Value Filter",
    Description = "Tampilkan semua, paling mahal, atau paling berat",
    Options = {"All", "Highest Value", "Highest KG"},
    Default = {"All"},
    Callback = function(v) Config.ESPValueFilter = type(v) == "table" and v[1] or v end
})
local skipAnimConn = nil

local function updateSkipAnimationLoop()
    if skipAnimConn then
        skipAnimConn:Disconnect()
        skipAnimConn = nil
    end
    
    if Config.SkipGrowthAnimation then
        local Gardens = workspace:FindFirstChild("Gardens")
        if Gardens then
            -- Mencegat part buah baru secara instan sebelum script game sempat meresizenya
            skipAnimConn = Gardens.DescendantAdded:Connect(function(desc)
                if not Config.SkipGrowthAnimation then return end
                if desc:IsA("BasePart") then
                    -- Cek apakah part ini ada di dalam folder Fruits atau HarvestPart
                    local curr = desc.Parent
                    local isFruit = false
                    while curr and curr.Name ~= "Gardens" do
                        if curr.Name == "Fruits" or curr.Name == "HarvestPart" then
                            isFruit = true
                            break
                        end
                        curr = curr.Parent
                    end
                    
                    if isFruit then
                        -- Inject attribute rahasia game 'DontShow' agar script bawaan gamenya 
                        -- mengabaikan part ini dan tidak akan pernah me-resize atau menganimasikannya.
                        -- Buah akan langsung spawn 100% full size!
                        desc:SetAttribute("DontShow", true)
                    end
                end
            end)
            
            -- Apply ke tanaman yang sudah ada (hanya jika baru dinyalakan)
            for _, plot in ipairs(Gardens:GetChildren()) do
                local plantsFolder = plot:FindFirstChild("Plants")
                if plantsFolder then
                    for _, plant in ipairs(plantsFolder:GetChildren()) do
                        for _, desc in ipairs(plant:GetDescendants()) do
                            if desc:IsA("BasePart") then
                                local curr = desc.Parent
                                local isFruit = false
                                while curr and curr.Name ~= "Gardens" do
                                    if curr.Name == "Fruits" or curr.Name == "HarvestPart" then
                                        isFruit = true
                                        break
                                    end
                                    curr = curr.Parent
                                end
                                if isFruit then
                                    desc:SetAttribute("DontShow", true)
                                    -- Paksa tampil karena mungkin sebelumnya sudah sempat disembunyikan game
                                    desc.Transparency = desc:GetAttribute("OG_Transparency") or 0
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end


local FpsSection = VisualsTab:AddSection("FPS Boost")

FpsSection:AddToggle({
    Title = "GPU Saver",
    Title2 = "Enable",
    Content = "Reduce rendering to save performance",
    Default = false,
    Callback = function(val)
        Config.GPUSaver = val
        if val then
            RunService:Set3dRenderingEnabled(false)
            if UI_LOADED then notif("GPU Saver ON", 3, "System") end
        else
            RunService:Set3dRenderingEnabled(true)
            if UI_LOADED then notif("GPU Saver OFF", 3, "System") end
        end
    end
})

FpsSection:AddToggle({
    Title = "Extreme Low Graphic",
    Title2 = "Enable",
    Content = "Removes textures, shadows, effects, kills RGB controllers, and optimizes rendering. (Rejoin to fully disable)",
    Default = false,
    Callback = function(val)
        Config.ExtremeLowGraphic = val
        local Lighting = game:GetService("Lighting")
        local Terrain = workspace:FindFirstChildOfClass("Terrain")
        local CollectionService = game:GetService("CollectionService")
        
        if val then
            -- ====== LIGHTING ======
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            Lighting.ShadowSoftness = 0
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
            Lighting.Brightness = 1
            
            -- Force Legacy rendering pipeline (lightest, no PBR)
            -- DISABLED: Setting Technology to 0 (Legacy) is highly unstable and causes GPU driver crashes on Mobile.
            -- if sethiddenproperty then
            --     pcall(function() sethiddenproperty(Lighting, "Technology", 0) end)
            -- end
            
            -- ====== GRAPHICS QUALITY OVERRIDE ======
            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            end)
            pcall(function()
                local gs = UserSettings():GetService("UserGameSettings")
                gs.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
            end)
            
            -- ====== TERRAIN ======
            if Terrain then
                pcall(function()
                    Terrain.WaterWaveSize = 0
                    Terrain.WaterWaveSpeed = 0
                    Terrain.WaterReflectance = 0
                    Terrain.WaterTransparency = 0
                    Terrain.Decoration = false
                end)
            end
            
            -- ====== POST-PROCESSING & SKY ======
            for _, v in pairs(Lighting:GetDescendants()) do
                if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("Cloud") then
                    pcall(function() v.Enabled = false end)
                    if v:IsA("Sky") then pcall(function() v:Destroy() end) end
                end
            end
            
            -- ====== MUTATION / RGB TAG LIST ======
            local tagsToStrip = {
                "RedPulse", "yAxisBrightnessPulse", "MovingTextureYAxis",
                "Rainbow", "Electric", "Gold", "Frozen", "Ignited", 
                "Bloodlit", "Chained", "Aurora", "Secret", "Starstruck"
            }
            local tagSet = {}
            for _, tag in ipairs(tagsToStrip) do tagSet[tag] = true end
            
            -- Lookup tables for O(1) class checks
            local destroyClasses = {
                ParticleEmitter = true, Trail = true, Beam = true,
                Fire = true, Smoke = true, Sparkles = true, SurfaceAppearance = true,
                Atmosphere = true, PostEffect = true, SunRaysEffect = true, BloomEffect = true,
                BlurEffect = true, ColorCorrectionEffect = true, DepthOfFieldEffect = true
            }
            local disableClasses = {
                Highlight = true, PointLight = true,
                SpotLight = true, SurfaceLight = true
            }
            
            -- ====== CORE: KILL RGB CONTROLLERS VIA getgc() ======
            -- Game uses CollectionService-driven scripts that listen for tags
            -- and run color-cycling coroutines. We find and kill those threads.
            -- DISABLED FOR MOBILE STABILITY: getgc(true) and coroutine.close() cause silent memory corruption 
            -- and GC crashes on mobile executors after ~1 minute. Tag intercept below is enough!
            --[[
            task.spawn(function()
                pcall(function()
                    if getgc then
                        local gc = getgc(true)
                        for i, obj in ipairs(gc) do
                            if i % 4000 == 0 then task.wait() end
                            pcall(function()
                                if type(obj) == "table" then
                                    if obj.Rainbow or obj.Electric or obj.Aurora or obj.Gold then
                                        for k, v in pairs(obj) do
                                            if type(v) == "function" then
                                                obj[k] = function() end
                                            end
                                        end
                                    end
                                elseif type(obj) == "thread" and coroutine.status(obj) ~= "dead" then
                                    local info = debug.getinfo and debug.getinfo(obj, "s")
                                    if info and info.source then
                                        local src = string.lower(info.source)
                                        if string.find(src, "mutation") or string.find(src, "color") or string.find(src, "rainbow") or string.find(src, "visualizer") then
                                            pcall(function() coroutine.close(obj) end)
                                            pcall(function() task.cancel(obj) end)
                                        end
                                    end
                                end
                            end)
                        end
                    end
                end)
            end)
            ]]
            
            -- ====== CORE: TAG INTERCEPT via CollectionService ======
            -- This is the KEY fix: instead of waiting for DescendantAdded,
            -- we hook GetInstanceAddedSignal per tag. This fires the INSTANT
            -- a tag is applied to any instance, before the game's own
            -- controller can start its RGB loop.
            if _G.LowGfxTagConns then
                for _, conn in ipairs(_G.LowGfxTagConns) do
                    pcall(function() conn:Disconnect() end)
                end
            end
            _G.LowGfxTagConns = {}
            
            for _, tag in ipairs(tagsToStrip) do
                -- Strip from all currently tagged instances
                for _, inst in ipairs(CollectionService:GetTagged(tag)) do
                    pcall(function() CollectionService:RemoveTag(inst, tag) end)
                end
                -- Intercept future tag applications instantly
                local conn = CollectionService:GetInstanceAddedSignal(tag):Connect(function(inst)
                    if not Config.ExtremeLowGraphic then return end
                    pcall(function()
                        CollectionService:RemoveTag(inst, tag)
                    end)
                end)
                table.insert(_G.LowGfxTagConns, conn)
            end
            
            -- ====== VFX CLEANER (INSTANT O(1) OPTIMIZED) ======
            local function cleanVFX(v)
                local cn = v.ClassName
                
                -- BasePart optimization (material, shadow, mesh fidelity)
                if v:IsA("BasePart") then
                    if v.CastShadow then v.CastShadow = false end
                    if v.Material ~= Enum.Material.SmoothPlastic then v.Material = Enum.Material.SmoothPlastic end
                    if v.Reflectance ~= 0 then v.Reflectance = 0 end
                    if cn == "MeshPart" and v.TextureID ~= "" then
                        v.TextureID = ""
                    end
                    return
                elseif cn == "Decal" or cn == "Texture" then
                    local model = v:FindFirstAncestorWhichIsA("Model")
                    if model and game:GetService("Players"):GetPlayerFromCharacter(model) then
                        if v.Transparency ~= 1 then v.Transparency = 1 end
                        return
                    end
                    v:Destroy()
                    return
                elseif cn == "SpecialMesh" then
                    if v.TextureId ~= "" then v.TextureId = "" end
                    return
                elseif destroyClasses[cn] or cn == "Trail" or cn == "Beam" then
                    v:Destroy()
                    return
                elseif disableClasses[cn] or v:IsA("Light") or cn == "Sound" then
                    local model = v:FindFirstAncestorWhichIsA("Model")
                    if model and game:GetService("Players"):GetPlayerFromCharacter(model) then
                        if cn == "Sound" then
                            if v.Playing then v.Playing = false end
                            if v.Volume ~= 0 then v.Volume = 0 end
                        else
                            if v.Enabled then v.Enabled = false end
                        end
                        return
                    end
                    v:Destroy()
                    return
                elseif cn == "Animator" or cn == "AnimationController" or cn == "Animation" then
                    local model = v:FindFirstAncestorWhichIsA("Model")
                    if model and game:GetService("Players"):GetPlayerFromCharacter(model) then
                        return -- Jangan disable animasi milik Player (keterkecualian animasi player)
                    end
                    v:Destroy()
                    return
                end
                
                -- Check exact name without string allocation/lowercasing (O(1) pointer comparison)
                local name = v.Name
                if name == "Rain" or name == "Snow" or name == "Weather" or name == "ElectricVFX" or name == "rain" or name == "snow" or name == "weather" or name == "WeatherStaff" or name == "VFX" or name == "vfx" then
                    v:Destroy()
                    return
                end
            end
            
            -- Clean up old queue connection if any
            if _G.LowGfxQueueConn then
                pcall(function() _G.LowGfxQueueConn:Disconnect() end)
                _G.LowGfxQueueConn = nil
            end
            _G.LowGfxDescQueue = _G.LowGfxDescQueue or {}
            table.clear(_G.LowGfxDescQueue)
            _G.LowGfxInitialNotifyPending = true
            
            -- Time-budgeted background processor: handles both initial load AND StreamingEnabled chunk in/out smoothly!
            local allDesc = workspace:GetDescendants()
            for i = 1, #allDesc do
                _G.LowGfxDescQueue[#_G.LowGfxDescQueue + 1] = allDesc[i]
            end
            
            _G.LowGfxQueueConn = RunService.Heartbeat:Connect(function()
                if not Config.ExtremeLowGraphic then return end
                local q = _G.LowGfxDescQueue
                local n = #q
                if n == 0 then
                    if _G.LowGfxInitialNotifyPending then
                        _G.LowGfxInitialNotifyPending = false
                        if UI_LOADED then
                            notif("Low Gfx: Optimasi Selesai! (100%)", 4, "FPS Boost")
                        end
                    end
                    return
                end
                
                local startTime = os.clock()
                while n > 0 do
                    local inst = q[n]
                    q[n] = nil
                    n = n - 1
                    
                    if inst and inst.Parent then
                        cleanVFX(inst)
                    end
                    
                    if n % 50 == 0 then
                        if os.clock() - startTime >= 0.0015 then
                            break
                        end
                    end
                end
            end)
            
            -- ====== STRIP OTHER PLAYERS ======
            local function stripPlayerVisuals(character)
                if not character then return end
                for _, part in ipairs(character:GetDescendants()) do
                    pcall(function()
                        if part:IsA("Accessory") then
                            part:Destroy()
                        elseif part:IsA("ShirtGraphic") or part:IsA("Shirt") or part:IsA("Pants") then
                            part:Destroy()
                        elseif part:IsA("MeshPart") and part.Name ~= "HumanoidRootPart" then
                            part.TextureID = ""
                            part.Material = Enum.Material.SmoothPlastic
                        end
                    end)
                end
            end
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    pcall(function() stripPlayerVisuals(player.Character) end)
                end
            end
            
            if _G.LowGfxPlayerConn then
                pcall(function() _G.LowGfxPlayerConn:Disconnect() end)
            end
            _G.LowGfxPlayerConn = Players.PlayerAdded:Connect(function(player)
                if not Config.ExtremeLowGraphic then return end
                player.CharacterAdded:Connect(function(char)
                    if not Config.ExtremeLowGraphic then return end
                    task.wait(1)
                    stripPlayerVisuals(char)
                end)
            end)
            
            -- ====== DESCENDANT ADDED (ULTRA-FAST QUEUE PUSH O(1)) ======
            -- Pushes incoming StreamingEnabled parts in 0.001ms without blocking the frame!
            if _G.LowGfxConn then
                _G.LowGfxConn:Disconnect()
                _G.LowGfxConn = nil
            end
            
            _G.LowGfxConn = workspace.DescendantAdded:Connect(function(v)
                if not Config.ExtremeLowGraphic then return end
                _G.LowGfxDescQueue[#_G.LowGfxDescQueue + 1] = v
            end)
            
            -- ====== LIGHTING DESCENDANT ADDED (catch new post-effects) ======
            if _G.LowGfxLightingConn then
                pcall(function() _G.LowGfxLightingConn:Disconnect() end)
            end
            _G.LowGfxLightingConn = Lighting.DescendantAdded:Connect(function(v)
                if not Config.ExtremeLowGraphic then return end
                if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("Cloud") then
                    pcall(function() v.Enabled = false end)
                    if v:IsA("Sky") then pcall(function() v:Destroy() end) end
                end
            end)
            
            if UI_LOADED then notif("Extreme Low Graphic ON", 3, "System") end
        else
            Lighting.GlobalShadows = true
            -- Disconnect all low gfx connections
            if _G.LowGfxConn then
                _G.LowGfxConn:Disconnect()
                _G.LowGfxConn = nil
            end
            if _G.LowGfxTagConns then
                for _, conn in ipairs(_G.LowGfxTagConns) do
                    pcall(function() conn:Disconnect() end)
                end
                _G.LowGfxTagConns = nil
            end
            if _G.LowGfxPlayerConn then
                pcall(function() _G.LowGfxPlayerConn:Disconnect() end)
                _G.LowGfxPlayerConn = nil
            end
            if _G.LowGfxLightingConn then
                pcall(function() _G.LowGfxLightingConn:Disconnect() end)
                _G.LowGfxLightingConn = nil
            end
            if _G.LowGfxQueueConn then
                pcall(function() _G.LowGfxQueueConn:Disconnect() end)
                _G.LowGfxQueueConn = nil
            end
            if _G.LowGfxDescQueue then table.clear(_G.LowGfxDescQueue) end
            _G.LowGfxInitialNotifyPending = false
            if UI_LOADED then notif("Disabled (Rejoin to restore textures)", 3, "System") end
        end
    end
})
FpsSection:AddToggle({
    Title = "Skip Growth Animation",
    Title2 = "Enable",
    Content = "Membypass kalkulasi animasi tumbuh. Buah akan langsung divisualisasikan 100% matang di layarmu seketika saat muncul (Menghemat banyak CPU).",
    Default = false,
    Callback = function(val)
        Config.SkipGrowthAnimation = val
        if UI_LOADED then
            if val then notif("Skip Growth Animation ON", 3, "System") else notif("Skip Growth Animation OFF", 3, "System") end
        end
        updateSkipAnimationLoop()
    end
})


FpsSection:AddToggle({
    Title = "Hide Gardens",
    Title2 = "Enable",
    Content = "Hides plants from other gardens to reduce lag.",
    Default = false,
    Callback = function(val)
        Config.HideOtherGardens = val
        updateHideGardens()
    end
})

local HideGardensDrop
HideGardensDrop = FpsSection:AddDropdown({
    Title = "Hide Garden Target",
    Options = {"None", "All", "Me"},
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.HideGardensTarget = handleDropdownChange(val, HideGardensDrop)
        if Config.HideOtherGardens then
            updateHideGardens()
        end
    end
})

local HideGardenModeDrop
HideGardenModeDrop = FpsSection:AddDropdown({
    Title = "Hide Garden Mode",
    Options = {"Fruit & Plants", "Plants"},
    Default = {"Fruit & Plants"},
    Multi = false,
    Callback = function(val)
        local newVal = handleDropdownChange(val, HideGardenModeDrop)
        if newVal and type(newVal) == "table" and newVal[1] then
            Config.HideGardenMode = newVal[1]
        else
            Config.HideGardenMode = "Fruit & Plants"
        end
        if Config.HideOtherGardens then
            updateHideGardens()
        end
    end
})

FpsSection:AddToggle({
    Title = "Disable All Prompts",
    Title2 = "Enable",
    Content = "Menyembunyikan / menonaktifkan seluruh ProximityPrompt di dalam game untuk membersihkan layar dan mengurangi lag rendering.",
    Default = false,
    Callback = function(val)
        Config.DisableAllPrompts = val
        updateDisableAllPrompts()
    end
})
end

local function LoadMiscTab()
local MiscTab = Tabs:AddTab({ Name = "Misc", Icon = "settings" })

local SeedPredictSection = MiscTab:AddSection("Seed Predictor")

SeedPredictSection:AddToggle({
    Title = "Show Predict UI",
    Content = "Menampilkan UI untuk meramal isi shop.",
    Default = false,
    Callback = function(val)
        Config.PredictUI = val
        if val then
            togglePredictUI(true)
            startSeedPredictLoop()
        else
            togglePredictUI(false)
        end
    end
})

local PredictTargetDropdown
PredictTargetDropdown = SeedPredictSection:AddDropdown({
    Title = "Select Seed to Track",
    Options = SEED_LIST,
    Default = "Apple Seed",
    Multi = false,
    Callback = function(val)
        Config.PredictTargetSeed = val
    end
})




local PredictSection = MiscTab:AddSection("Predict Weather UI")
PredictSection:AddToggle({
    Title = "Auto Predict UI",
    Title2 = "Enable",
    Content = "Automatically updates the Weather UI on screen",
    Default = true,
    Callback = function(val)
        Config.PredictWeather = val
        if UI_LOADED and val then startPredictLoop() end
    end
})


local MoonFinderSection = MiscTab:AddSection("Moon Cycle Finder")

local MoonFinderTargetDropdown
MoonFinderTargetDropdown = MoonFinderSection:AddDropdown({
    Title = "Target Moon",
    Content = "Select the moon types to search for",
    Options = {"Rainbow Moon", "Goldmoon", "Bloodmoon", "Mega Moon"},
    Default = {"Rainbow Moon"},
    Multi = true,
    Callback = function(val)
        if type(val) ~= "table" then val = {val} end
        Config.MoonFinderTarget = val
    end
})

MoonFinderSection:AddToggle({
    Title = "Start Moon Finder",
    Title2 = "Enable",
    Content = "Server hop to find the selected moon type. Saves visited servers to file.",
    Default = false,
    Callback = function(val)
        Config.MoonFinderActive = val
        if val then
            setEmergencyStopVisible(true)
            startMoonFinderLoop()
        else
            moonFinderActive = false
            setEmergencyStopVisible(false)
            clearVisitedServers() -- Wipe session memory so it doesn't auto-resume later
            notif("Moon Finder stopped! Session cleared.", 3, "Moon Finder")
        end
    end
})

MoonFinderSection:AddButton({
    Title = "Reset Visited Servers",
    Content = "Clear the visited server list manually.",
    Callback = function()
        clearVisitedServers()
        notif("Visited server list cleared!", 3, "Moon Finder")
    end
})

local SystemSection = MiscTab:AddSection("System")

SystemSection:AddToggle({
    Title = "Auto Reconnect",
    Title2 = "Enable",
    Content = "Automatically reconnect/rejoin if disconnected from the server",
    Default = true,
    Callback = function(val)
        Config.AutoReconnect = val
    end
})

local AutoLeaveDropdown
AutoLeaveDropdown = SystemSection:AddDropdown({
    Title = "Auto Leave Weather Target",
    Content = "Pilih cuaca untuk dihindari",
    Options = {"None", "Goldmoon", "Rainbow Moon", "Bloodmoon", "Mega Moon", "Aurora", "Snowfall", "Starfall", "Sunburst", "Rain", "Lightning", "Rainbow"},
    Default = {"Goldmoon"},
    Multi = true,
    Callback = function(val)
        if type(val) ~= "table" then val = {val} end
        Config.AutoLeaveWeatherTarget = val
    end
})

SystemSection:AddToggle({
    Title = "Auto Leave Weather",
    Title2 = "Enable",
    Content = "Kick otomatis jika cuaca terpilih aktif, lalu auto reconnect setelah cuaca berakhir.",
    Default = false,
    Callback = function(val)
        Config.AutoLeaveWeather = val
        if UI_LOADED and val then startAutoLeaveWeatherLoop() end
    end
})

SystemSection:AddToggle({
    Title = "Hide Notifications",
    Title2 = "Enable",
    Content = "Mute all Napoleon Script notifications on screen",
    Default = false,
    Callback = function(val)
        Config.HideNotifications = val
    end
})

SystemSection:AddToggle({
    Title = "Anti-Knockback & Anti-Fling",
    Title2 = "Enable",
    Content = "Prevents being pushed by other players or shovels (Anti Punch/Moved)",
    Default = false,
    Callback = function(val)
        Config.AntiKnockback = val
        if not val then
            pcall(function()
                local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true) end
            end)
        end
    end
})

SystemSection:AddToggle({
    Title = "Anti-AFK",
    Title2 = "Enable",
    Content = "Prevent kick from inactivity",
    Default = true,
    Callback = function(val)
        Config.AntiAFK = val
    end
})


SystemSection:AddButton({
    Title = "Rejoin Server",
    Content = "Leave and rejoin the current server.",
    Callback = function()
        notif("Rejoining...", 3, "System")
        local success, errorMessage = pcall(function()
            local TeleportService = game:GetService("TeleportService")
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            
            if LocalPlayer then
                LocalPlayer:Kick("\nRejoining...")
                task.wait(1) 
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            else
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
            end
        end)

        if not success then
            warn("Gagal Rejoin: " .. tostring(errorMessage))
            notif("Rejoin Error: " .. tostring(errorMessage), 5, "Error")
        end
    end
})

SystemSection:AddButton({
    Title = "Server Hop",
    Content = "Automatically find and hop to another public server.",
    Callback = function()
        notif("Mencari server baru...", 5, "Server Hop")
        task.spawn(function()
            local HttpService = game:GetService("HttpService")
            local TeleportService = game:GetService("TeleportService")
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            
            local placeId = game.PlaceId
            local currentJobId = game.JobId
            
            local url = "https://games.roblox.com/v1/games/" .. tostring(placeId) .. "/servers/Public?sortOrder=Asc&limit=100"
            
            local success, response = pcall(function()
                return game:HttpGet(url)
            end)
            
            if not success or not response then
                notif("Gagal mengambil daftar server dari API Roblox!", 5, "Error")
                return
            end
            
            local decodeSuccess, data = pcall(function()
                return HttpService:JSONDecode(response)
            end)
            
            if decodeSuccess and data and data.data then
                local servers = data.data
                local foundServer = false
                
                for i = #servers, 2, -1 do
                    local j = math.random(i)
                    servers[i], servers[j] = servers[j], servers[i]
                end
                
                for _, server in ipairs(servers) do
                    if server.playing and server.maxPlayers and server.playing < server.maxPlayers and server.playing > 0 and server.id ~= currentJobId then
                        notif("Server ideal ditemukan (" .. server.playing .. "/" .. server.maxPlayers .. "). Teleporting...", 5, "Server Hop")
                        foundServer = true
                        
                        local tpSuccess, tpError = pcall(function()
                            TeleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer)
                        end)
                        
                        if tpSuccess then
                            task.wait(10) 
                            break
                        else
                            notif("Gagal teleport: " .. tostring(tpError), 3, "Error")
                        end
                    end
                end
                
                if not foundServer then
                    notif("Semua 100 server penuh atau error.", 5, "Server Hop")
                end
            else
                notif("Format data API server tidak sesuai.", 5, "Error")
            end
        end)
    end
})

local WebControlSection = MiscTab:AddSection("Web Dashboard Control")

WebControlSection:AddToggle({
    Title = "Inventory Data",
    Content = "Send your full inventory to the dashboard",
    Default = false,
    Callback = function(val)
        Config.WebSyncInventory = val
    end
})

WebControlSection:AddToggle({
    Title = "Web Control",
    Content = "Allow dashboard to control this script",
    Default = false,
    Callback = function(val)
        Config.WebControlEnabled = val
    end
})

print("misc tab loaded!")
end

local function LoadRollbackTab()
local RollbackTab = Tabs:AddTab({ Name = "Rollback", Icon = "history" })
local VunreableSection = RollbackTab:AddSection("vunreable")
VunreableSection:AddButton({
    Title = "rollback",
    Content = "Fire rollback remote",
    Callback = function()
        local Event = game:GetService("ReplicatedStorage").SharedModules.Packet.RemoteEvent
        Event:FireServer(
            54,
            ":\xF7"
        )
    end
})

VunreableSection:AddButton({
    Title = "clear rollback",
    Content = "Fire clear rollback remote",
    Callback = function()
        local Event = game:GetService("ReplicatedStorage").SharedModules.Packet.RemoteEvent
        Event:FireServer(54, "")
        Event:FireServer(54, "")
        Event:FireServer(54, "nil")
    end
})



local BigFruitMethodSection = RollbackTab:AddSection("Auto Big Fruit Method")

BigFruitMethodSection:AddParagraph({
    Title = "Note:",
    Content = "don't forget to turn on auto harvest and auto sell also!"
})

Config.BigFruitMethodTarget = Config.BigFruitMethodTarget or "Apple"
BigFruitMethodSection:AddDropdown({
    Title = "Select Plant/Tree",
    Options = SEED_LIST,
    Default = Config.BigFruitMethodTarget,
    Callback = function(val)
        if type(val) == "table" then val = val[1] end
        Config.BigFruitMethodTarget = val
    end
})

Config.BigFruitMethodMaxSWC = Config.BigFruitMethodMaxSWC or 100
BigFruitMethodSection:AddInput({
    Title = "Total SWC",
    Content = "Amount of Super Watering Can to use before checking",
    Default = tostring(Config.BigFruitMethodMaxSWC),
    Numeric = true,
    Callback = function(val)
        Config.BigFruitMethodMaxSWC = tonumber(val) or 100
    end
})

Config.BigFruitMethodTargetKg = Config.BigFruitMethodTargetKg or 5000
BigFruitMethodSection:AddInput({
    Title = "Target KG",
    Content = "Target weight to cancel rollback",
    Default = tostring(Config.BigFruitMethodTargetKg),
    Numeric = true,
    Callback = function(val)
        Config.BigFruitMethodTargetKg = tonumber(val) or 5000
    end
})

Config.BigFruitMethodWebhook = Config.BigFruitMethodWebhook or ""
BigFruitMethodSection:AddInput({
    Title = "Webhook URL",
    Content = "Discord Webhook for Big Fruit alerts",
    Default = Config.BigFruitMethodWebhook,
    Callback = function(val)
        Config.BigFruitMethodWebhook = val
    end
})

Config.BigFruitMethodSprinkler = Config.BigFruitMethodSprinkler or false
BigFruitMethodSection:AddToggle({
    Title = "Use Super Sprinkler",
    Default = Config.BigFruitMethodSprinkler,
    Callback = function(val)
        Config.BigFruitMethodSprinkler = val
    end
})

function startAutoBigFruitMethodLoop()
    task.spawn(function()
        print("Starting auto big fruit method loop")
        task.wait(1)
        notif("Waiting 5 seconds to prepare", 5, "Big Fruit")
        task.wait(5)
        local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
        local SeedData = require(game:GetService("ReplicatedStorage").SharedModules.SeedData)
        local FruitVisualizerController = nil
        pcall(function()
            FruitVisualizerController = require(LocalPlayer.PlayerScripts:WaitForChild("Controllers"):WaitForChild("FruitVisualizerController"))
        end)
        
        while Config.AutoBigFruitMethod do
            local Event = game:GetService("ReplicatedStorage").SharedModules.Packet.RemoteEvent
            Event:FireServer(54, ":\xF7")
            
            local maxSWC = tonumber(Config.BigFruitMethodMaxSWC) or 100
            local usedSWC = 0
            local targetPlantName = Config.BigFruitMethodTarget or "Apple"
            
            notif("Watering " .. targetPlantName .. " " .. maxSWC .. " times...", 3, "Big Fruit")
            
            local hasTeleported = false
            local cachedPlot = nil
            
            while usedSWC < maxSWC and Config.AutoBigFruitMethod do
                if LocalPlayer:GetAttribute("LoadingScreenActive") == true or LocalPlayer:GetAttribute("OfflineCutscenePlaying") == true then
                    notif("Waiting for Cutscene to finish...", 2, "Info")
                    task.wait(2)
                    continue
                end
                
                local char = LocalPlayer.Character
                if not cachedPlot or not cachedPlot.Parent then
                    cachedPlot = getMyPlot()
                end
                local myPlot = cachedPlot
                local swcTool = nil
                
                if char then
                    swcTool = char:FindFirstChild("Super Watering Can")
                end
                if not swcTool then
                    swcTool = LocalPlayer.Backpack:FindFirstChild("Super Watering Can")
                end
                
                local targetPlant = nil
                if myPlot then
                    local function findInFolder(folderName)
                        local folder = myPlot:FindFirstChild(folderName)
                        if folder then
                            for _, model in ipairs(folder:GetChildren()) do
                                if model:IsA("Model") then
                                    local seedName = model:GetAttribute("SeedName") or ""
                                    local coreName = model:GetAttribute("CorePartName") or ""
                                    local fruitName = model:GetAttribute("FruitName") or ""
                                    local plantName = model:GetAttribute("PlantName") or ""
                                    
                                    local plantType = fruitName ~= "" and fruitName or coreName
                                    if plantType == "" then plantType = seedName end
                                    
                                    if plantType == targetPlantName or seedName == targetPlantName or plantName == targetPlantName then
                                        targetPlant = model
                                        break
                                    end
                                end
                            end
                        end
                    end
                    findInFolder("Props")
                    if not targetPlant then findInFolder("Plants") end
                end
                
                if myPlot and targetPlant and swcTool then
                    if not hasTeleported then
                        pcall(function()
                            local hrp = char:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                tweenTeleport(hrp, (targetPlant:GetPivot() + Vector3.new(0, 4, 0)).Position)
                            end
                        end)
                        hasTeleported = true
                        task.wait(0.5) -- wait for teleport to sync with server
                        
                        if Config.BigFruitMethodSprinkler then
                            local ssTool = char:FindFirstChild("Super Sprinkler") or LocalPlayer.Backpack:FindFirstChild("Super Sprinkler")
                            if ssTool then
                                pcall(function()
                                    if ssTool.Parent ~= char then
                                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                                        if humanoid then humanoid:EquipTool(ssTool) end
                                    end
                                    local pos = targetPlant:GetPivot().Position
                                    local plotId = tonumber(string.match(myPlot.Name, "%d+")) or 1
                                    Networking.Place.PlaceSprinkler:Fire(pos + Vector3.new(1.5, 0, 0), "Super Sprinkler", ssTool, plotId)
                                end)
                                task.wait(0.5)
                            else
                                notif("Super Sprinkler not found in inventory!", 3, "Warning")
                            end
                        end
                    end
                    
                    pcall(function()
                        if swcTool.Parent ~= char then
                            local humanoid = char:FindFirstChildOfClass("Humanoid")
                            if humanoid then humanoid:EquipTool(swcTool) end
                        end
                        Networking.WateringCan.UseWateringCan:Fire(targetPlant:GetPivot().Position, swcTool.Name, swcTool)
                    end)
                    usedSWC = usedSWC + 1
                    task.wait(1)
                else
                    if not myPlot then
                        notif("Waiting for Plot to load... (Cutscene/Loading)", 2, "Info")
                    elseif not swcTool then
                        notif("Super Watering Can not found in inventory! Waiting...", 2, "Warning")
                    elseif not targetPlant then
                        notif(targetPlantName .. " not found on plot!", 2, "Error")
                    end
                    task.wait(2)
                end
            end
            
            if not Config.AutoBigFruitMethod then break end
            
            notif("Waiting 10 seconds for growth effects...", 4, "Big Fruit")
            task.wait(10)
            
            if not Config.AutoBigFruitMethod then break end
            
            local foundTarget = false
            local foundWeight = 0
            local targetKg = tonumber(Config.BigFruitMethodTargetKg) or 5000
            
            local myPlot = getMyPlot()
            if myPlot then
                local CollectionService = game:GetService("CollectionService")
                local prompts = CollectionService:GetTagged("HarvestPrompt")
                
                for _, prompt in ipairs(prompts) do
                    if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                        local adorneePart = prompt.Parent
                        local plantModel = adorneePart and adorneePart:FindFirstAncestorWhichIsA("Model")
                        if plantModel and plantModel:IsDescendantOf(myPlot) then
                            local seedName = plantModel:GetAttribute("SeedName") or ""
                            local coreName = plantModel:GetAttribute("CorePartName") or ""
                            local fruitName = plantModel:GetAttribute("FruitName") or ""
                            
                            local plantType = fruitName ~= "" and fruitName or coreName
                            if plantType == "" then plantType = seedName end
                            
                            if plantType == targetPlantName or plantModel:GetAttribute("PlantName") == targetPlantName then
                                local weightKg = 0
                                pcall(function()
                                    if FruitVisualizerController then
                                        weightKg = FruitVisualizerController:CalculateFruitWeight(plantModel)
                                        if not weightKg and FruitVisualizerController.CalculatePlantWeight then
                                            weightKg = FruitVisualizerController:CalculatePlantWeight(plantModel)
                                        end
                                    end
                                end)
                                weightKg = tonumber(weightKg) or 0
                                if weightKg == 0 then
                                    local sizeMulti = plantModel:GetAttribute("SizeMulti") or 1
                                    local baseWeight = 100
                                    pcall(function()
                                        local sData = SeedData[targetPlantName]
                                        if sData then
                                            if sData.GrowData and sData.GrowData.BaseWeight then baseWeight = sData.GrowData.BaseWeight
                                            elseif sData.Weight then baseWeight = sData.Weight end
                                        end
                                    end)
                                    weightKg = baseWeight * sizeMulti
                                end
                                
                                if weightKg >= targetKg then
                                    foundTarget = true
                                    if weightKg > foundWeight then foundWeight = weightKg end
                                end
                            end
                        end
                    end
                end
            end
            
            if foundTarget then
                Event:FireServer(54, "")
                Event:FireServer(54, "")
                Event:FireServer(54, "nil")
                task.wait(0.1)
                Config.AutoBigFruitMethod = false
                notif("Target " .. targetPlantName .. " (" .. targetKg .. " KG) reached! Rollback cancelled.", 5, "Big Fruit")
                print("Big fruit target reached. Disabling auto reconnect.")
                
                if Config.BigFruitMethodWebhook and Config.BigFruitMethodWebhook ~= "" then
                    pcall(function()
                        local HttpService = game:GetService("HttpService")
                        local req = syn and syn.request or http_request or request
                        if req then
                            local weightFormat = tostring(math.floor(foundWeight))
                            local data = {
                                ["content"] = "WOW! **" .. LocalPlayer.Name .. "** successfully found a **" .. weightFormat .. "kg** " .. targetPlantName .. "! 🌳\n@everyone"
                            }
                            req({
                                Url = Config.BigFruitMethodWebhook,
                                Method = "POST",
                                Headers = { ["Content-Type"] = "application/json" },
                                Body = HttpService:JSONEncode(data)
                            })
                        end
                    end)
                end
                
                task.wait(0.1)
                Event:FireServer(54, "")
                Event:FireServer(54, "")
                Event:FireServer(54, "nil")
                Config.AutoReconnect = false
                task.wait(1)
                LocalPlayer:Kick("\nSuccess found " .. targetPlantName .. " " .. tostring(math.floor(foundWeight).. "kg"))
                break
            else
                pcall(function()
                    local TeleportService = game:GetService("TeleportService")
                    local Players = game:GetService("Players")
                    local LocalPlayer = Players.LocalPlayer
                    
                    if LocalPlayer then
                        LocalPlayer:Kick("\nRejoining...")
                        task.wait(1) 
                        TeleportService:Teleport(game.PlaceId, LocalPlayer)
                    else
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                    end
                end)
                task.wait(2)
            end
        end
    end)
end

BigFruitMethodSection:AddToggle({
    Title = "Auto Big Fruit Method",
    Title2 = "Enable",
    Content = "Fire rollback, use SWC, check KG, cancel/rejoin.",
    Default = false,
    Callback = function(val)
        Config.AutoBigFruitMethod = val
        if UI_LOADED and val then startAutoBigFruitMethodLoop() end
    end
})

local EggRollbackSection = RollbackTab:AddSection("Gatcha Egg Rollback")

Config.EggRollbackType = Config.EggRollbackType or "Common Egg"
EggRollbackSection:AddDropdown({
    Title = "Select Egg Type",
    Options = {"Common Egg", "Big Egg", "Mega Egg", "Rainbow Egg"},
    Default = Config.EggRollbackType,
    Callback = function(val)
        if type(val) == "table" then val = val[1] end
        Config.EggRollbackType = val
    end
})

Config.EggRollbackAmount = Config.EggRollbackAmount or 100
EggRollbackSection:AddInput({
    Title = "Egg Amount",
    Content = "Amount of eggs to open before rejoin",
    Default = tostring(Config.EggRollbackAmount),
    Callback = function(val)
        Config.EggRollbackAmount = tonumber(val) or 100
    end
})

Config.EggRollbackWebhookURL = Config.EggRollbackWebhookURL or ""
EggRollbackSection:AddInput({
    Title = "Egg Webhook URL",
    Content = "Discord webhook for successful egg target",
    Default = Config.EggRollbackWebhookURL,
    Callback = function(val)
        Config.EggRollbackWebhookURL = val
    end
})

Config.EggRollbackTargetPet = Config.EggRollbackTargetPet or {"None"}
EggRollbackSection:AddDropdown({
    Title = "Target Pet",
    Options = PET_LIST,
    Default = Config.EggRollbackTargetPet,
    Multi = true,
    Callback = function(val)
        if type(val) == "table" and #val == 0 then
            Config.EggRollbackTargetPet = {"None"}
        else
            Config.EggRollbackTargetPet = type(val) == "table" and val or {val}
        end
    end
})

Config.EggRollbackTargetMutation = Config.EggRollbackTargetMutation or {"Any"}
EggRollbackSection:AddDropdown({
    Title = "Target Mutation",
    Options = {"Any", "Huge", "Big", "Rainbow", "Normal", "Big Normal", "Big Rainbow", "Huge Normal", "Huge Rainbow", "Normal Rainbow", "Normal Normal"},
    Default = Config.EggRollbackTargetMutation,
    Multi = true,
    Callback = function(val)
        if type(val) == "table" and #val == 0 then
            Config.EggRollbackTargetMutation = {"Any"}
        else
            Config.EggRollbackTargetMutation = type(val) == "table" and val or {val}
        end
    end
})

Config.EggRollbackLogic = Config.EggRollbackLogic or "AND"
EggRollbackSection:AddDropdown({
    Title = "Logic (Pet & Mutation)",
    Options = {"AND", "OR"},
    Default = Config.EggRollbackLogic,
    Callback = function(val)
        if type(val) == "table" then val = val[1] end
        Config.EggRollbackLogic = val
    end
})

function startEggRollbackLoop()
    task.spawn(function()
        print("Starting auto egg rollback loop")
        task.wait(1)
        notif("Waiting 5 seconds before starting egg rollback")
        task.wait(5)
        local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
        
        while Config.AutoEggRollback do
            local Event = game:GetService("ReplicatedStorage").SharedModules.Packet.RemoteEvent
            Event:FireServer(54, ":\xF7")
            
            local maxEgg = tonumber(Config.EggRollbackAmount) or 100
            local opened = 0
            
            local loopStartTime = tick()
            notif("Starting to open " .. maxEgg .. " eggs...", 3, "Egg Rollback")
            
            local foundTarget = false
            local foundInfo = ""
            
            while opened < maxEgg and Config.AutoEggRollback do
                local targetEgg = Config.EggRollbackType or "Common Egg"
                
                local res = nil
                pcall(function()
                    res = Networking.Egg.OpenEgg:Fire(targetEgg)
                end)
                
                opened = opened + 1
                task.wait(0.1)
                
                if res then
                    local encodedRes = tostring(res)
                    if type(res) == "table" then
                        pcall(function() encodedRes = game:GetService("HttpService"):JSONEncode(res) end)
                    end
                    print("[Egg Debug] OpenEgg Result: " .. encodedRes)
                    notif("Egg Result: " .. string.sub(encodedRes, 1, 80), 3, "Egg Debug")
                    
                    local petFound = false
                    local mutFound = false
                    
                    local foundPets = {}
                    local foundMuts = {}
                    
                    local tp = Config.EggRollbackTargetPet or {"None"}
                    if type(tp) ~= "table" then tp = {tp} end
                    
                    local tm = Config.EggRollbackTargetMutation or {"Any"}
                    if type(tm) ~= "table" then tm = {tm} end
                    
                    local perfectMatchFound = false
                    
                    local function checkPet(petInfo)
                        local pName = petInfo.PetName or petInfo.petName or petInfo.Name or petInfo.name or petInfo.WonPet or petInfo.wonPet
                        if not pName then return end
                        
                        local pSize = petInfo.Size or petInfo.size or petInfo.WonSize or petInfo.wonSize or "Normal"
                        local pType = petInfo.Type or petInfo.type or petInfo.WonType or petInfo.wonType or "Normal"
                        
                        local mutStr = tostring(pSize) .. " " .. tostring(pType)
                        local rawStr = ""
                        pcall(function() rawStr = string.lower(game:GetService("HttpService"):JSONEncode(petInfo)) end)
                        
                        local thisPetMatch = false
                        local thisMutMatch = false
                        
                        if table.find(tp, "None") then
                            thisPetMatch = true
                        else
                            for _, p in ipairs(tp) do
                                if p ~= "None" and (string.lower(tostring(pName)) == string.lower(p) or string.find(string.lower(tostring(pName)), string.lower(p))) then
                                    thisPetMatch = true
                                    table.insert(foundPets, p)
                                end
                            end
                        end
                        
                        if table.find(tm, "Any") then
                            thisMutMatch = true
                        else
                            for _, m in ipairs(tm) do
                                if m ~= "Any" then
                                    local targetMut = string.lower(m)
                                    if string.lower(mutStr) == targetMut or string.find(string.lower(tostring(pName)), targetMut) then
                                        thisMutMatch = true
                                        table.insert(foundMuts, m)
                                    elseif targetMut == "huge" and (string.lower(tostring(pSize)) == "huge" or string.find(rawStr, "huge")) then
                                        thisMutMatch = true table.insert(foundMuts, m)
                                    elseif targetMut == "big" and (string.lower(tostring(pSize)) == "big" or string.find(rawStr, "big")) then
                                        thisMutMatch = true table.insert(foundMuts, m)
                                    elseif targetMut == "rainbow" and (string.lower(tostring(pType)) == "rainbow" or string.find(rawStr, "rainbow")) then
                                        thisMutMatch = true table.insert(foundMuts, m)
                                    elseif targetMut == "normal" and (string.lower(tostring(pSize)) == "normal" and string.lower(tostring(pType)) == "normal") then
                                        thisMutMatch = true table.insert(foundMuts, m)
                                    end
                                end
                            end
                        end
                        
                        if thisPetMatch then petFound = true end
                        if thisMutMatch then mutFound = true end
                        if thisPetMatch and thisMutMatch then perfectMatchFound = true end
                    end
                    
                    local function searchTable(t)
                        if type(t) == "table" then
                            if t.PetName or t.petName or t.Name or t.name or t.WonPet or t.wonPet then
                                checkPet(t)
                            end
                            for _, v in pairs(t) do
                                if type(v) == "table" then
                                    searchTable(v)
                                end
                            end
                        end
                    end
                    
                    if type(res) == "table" then
                        searchTable(res)
                    elseif type(res) == "string" then
                        for _, p in ipairs(tp) do
                            if p ~= "None" and string.find(string.lower(res), string.lower(p)) then 
                                petFound = true 
                                table.insert(foundPets, p)
                            end
                        end
                        for _, m in ipairs(tm) do
                            if m ~= "Any" and string.find(string.lower(res), string.lower(m)) then 
                                mutFound = true 
                                table.insert(foundMuts, m)
                            end
                        end
                    end
                    
                    local hasNone = false
                    for _, p in ipairs(tp) do if p == "None" then hasNone = true end end
                    
                    local hasAny = false
                    for _, m in ipairs(tm) do if m == "Any" then hasAny = true end end
                    
                    local isMatch = false
                    if Config.EggRollbackLogic == "AND" then
                        if perfectMatchFound then
                            isMatch = true
                        elseif type(res) == "string" then
                            local pMatch = (hasNone or petFound)
                            local mMatch = (hasAny or mutFound)
                            isMatch = (pMatch and mMatch)
                        end
                    else
                        local pMatch = (not hasNone and petFound)
                        local mMatch = (not hasAny and mutFound)
                        isMatch = (pMatch or mMatch)
                    end
                    
                    if isMatch and not (hasNone and hasAny) then
                        foundTarget = true
                        local petStr = #foundPets > 0 and table.concat(foundPets, ", ") or (hasNone and "None" or "N/A")
                        local mutStr = #foundMuts > 0 and table.concat(foundMuts, ", ") or (hasAny and "Any" or "N/A")
                        foundInfo = "Pet: " .. petStr .. " | Mut: " .. mutStr
                        break
                    end
                end
                
                if not Config.AutoEggRollback then break end
            end
            
            if not Config.AutoEggRollback then break end
            
            if foundTarget then
                Event:FireServer(54, "")
                Event:FireServer(54, "")
                Event:FireServer(54, "nil")
                task.wait(0.1)
                Config.AutoEggRollback = false
                notif("Egg Rollback Target Found! (" .. foundInfo .. ") Rollback cancelled.", 5, "Egg Rollback")
                print("Egg Rollback Target Found! (" .. foundInfo .. ") Rollback cancelled.")
                
                if Config.EggRollbackWebhookURL and Config.EggRollbackWebhookURL ~= "" then
                    pcall(function()
                        local sendRequest = (syn and syn.request) or (http and http.request) or http_request or request
                        if sendRequest then
                            local data = {
                                ["content"] = "**" .. game:GetService("Players").LocalPlayer.Name .. "** successfully found an Egg Target! 🥚\n> " .. foundInfo .. "\n@everyone"
                            }
                            local newData = game:GetService("HttpService"):JSONEncode(data)
                            sendRequest({
                                Url = Config.EggRollbackWebhookURL,
                                Method = "POST",
                                Headers = {
                                    ["Content-Type"] = "application/json"
                                },
                                Body = newData
                            })
                        end
                    end)
                end
                
                task.wait(0.1)
                Event:FireServer(54, "")
                Event:FireServer(54, "")
                Event:FireServer(54, "nil")
                Config.AutoReconnect = false
                task.wait(1)
                -- LocalPlayer:Kick("\nSuccess found target: " .. foundInfo)
                break
            else
                local elapsedTime = tick() - loopStartTime
                if elapsedTime < 10 then
                    task.wait(10 - elapsedTime)
                end
                
                pcall(function()
                    local TeleportService = game:GetService("TeleportService")
                    local Players = game:GetService("Players")
                    local LocalPlayer = Players.LocalPlayer
                    
                    if LocalPlayer then
                        LocalPlayer:Kick("\nTarget not found, Rejoining...")
                        task.wait(1) 
                        TeleportService:Teleport(game.PlaceId, LocalPlayer)
                    else
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                    end
                end)
                task.wait(2)
            end
        end
    end)
end

EggRollbackSection:AddToggle({
    Title = "Auto Gatcha Egg Rollback",
    Title2 = "Enable",
    Content = "Fire rollback, open eggs, check target, cancel/rejoin.",
    Default = false,
    Callback = function(val)
        Config.AutoEggRollback = val
        if UI_LOADED and val then startEggRollbackLoop() end
    end
})



local TARGET_ITEM_LIST = {"None"}
for _, v in ipairs(SEED_LIST) do table.insert(TARGET_ITEM_LIST, v) end
for _, v in ipairs(PROP_LIST) do table.insert(TARGET_ITEM_LIST, v) end
for _, v in ipairs(GEAR_LIST) do table.insert(TARGET_ITEM_LIST, v) end

local PackRollbackSection = RollbackTab:AddSection("Gatcha Crate/Seedpack")

Config.PackRollbackType = Config.PackRollbackType or "Basic Seed Pack"
PackRollbackSection:AddDropdown({
    Title = "Select Pack/Crate",
    Options = PACK_LIST,
    Default = Config.PackRollbackType,
    Callback = function(val)
        if type(val) == "table" then val = val[1] end
        Config.PackRollbackType = val
    end
})

Config.PackRollbackAmount = Config.PackRollbackAmount or 100
PackRollbackSection:AddInput({
    Title = "Open Amount",
    Content = "Amount of packs to open before rejoin",
    Default = tostring(Config.PackRollbackAmount),
    Callback = function(val)
        Config.PackRollbackAmount = tonumber(val) or 100
    end
})

Config.PackRollbackWebhookURL = Config.PackRollbackWebhookURL or ""
PackRollbackSection:AddInput({
    Title = "Webhook URL",
    Content = "Discord webhook for successful target",
    Default = Config.PackRollbackWebhookURL,
    Callback = function(val)
        Config.PackRollbackWebhookURL = val
    end
})

Config.PackRollbackTargetItem = Config.PackRollbackTargetItem or {"None"}
PackRollbackSection:AddDropdown({
    Title = "Target Item",
    Options = TARGET_ITEM_LIST,
    Default = Config.PackRollbackTargetItem,
    Multi = true,
    Callback = function(val)
        if type(val) == "table" and #val == 0 then
            Config.PackRollbackTargetItem = {"None"}
        else
            Config.PackRollbackTargetItem = type(val) == "table" and val or {val}
        end
    end
})

function startPackRollbackLoop()
    task.spawn(function()
        print("Starting auto pack rollback loop")
        task.wait(1)
        notif("Waiting 5 seconds before starting pack rollback")
        task.wait(5)
        local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
        
        while Config.AutoPackRollback do
            local Event = game:GetService("ReplicatedStorage").SharedModules.Packet.RemoteEvent
            Event:FireServer(54, ":\xF7")
            
            local maxPack = tonumber(Config.PackRollbackAmount) or 100
            local opened = 0
            
            local loopStartTime = tick()
            notif("Starting to open " .. maxPack .. " packs...", 3, "Pack Rollback")
            
            local foundTarget = false
            local foundInfo = ""
            
            while opened < maxPack and Config.AutoPackRollback do
                local targetPack = Config.PackRollbackType or "Basic Seed Pack"
                
                local res = nil
                pcall(function()
                    if string.match(targetPack, "Pack$") then
                        res = Networking.SeedPack.OpenSeedPack:Fire(targetPack)
                    else
                        res = Networking.Crate.OpenCrate:Fire(targetPack)
                    end
                end)
                
                opened = opened + 1
                task.wait(0.2)
                
                if res then
                    local itemFound = false
                    local foundItems = {}
                    
                    local tp = Config.PackRollbackTargetItem or {"None"}
                    if type(tp) ~= "table" then tp = {tp} end
                    
                    local rawStr = ""
                    if type(res) == "table" then
                        pcall(function() rawStr = string.lower(game:GetService("HttpService"):JSONEncode(res)) end)
                    end
                    
                    local wonItemName = nil
                    if type(res) == "table" then
                        if res.WonItem and type(res.WonItem) == "table" then
                            wonItemName = res.WonItem.Name or res.WonItem.name
                        elseif type(res.WonItem) == "string" then
                            wonItemName = res.WonItem
                        elseif res.WonSeed and type(res.WonSeed) == "string" then
                            wonItemName = res.WonSeed
                        end
                    end
                    
                    if wonItemName then
                        for _, targetStr in ipairs(tp) do
                            if targetStr ~= "None" and (string.lower(wonItemName) == string.lower(targetStr) or string.find(string.lower(wonItemName), string.lower(targetStr))) then
                                itemFound = true
                                table.insert(foundItems, targetStr)
                            end
                        end
                    end
                    
                    if itemFound then
                        foundTarget = true
                        foundInfo = table.concat(foundItems, ", ")
                        break
                    end
                end
            end
            
            if not Config.AutoPackRollback then break end
            
            local elapsedTime = tick() - loopStartTime
            if elapsedTime < 10 then
                notif("Waiting " .. math.ceil(10 - elapsedTime) .. "s to reach 10s minimum...", 3, "Delay")
                task.wait(10 - elapsedTime)
            end
            
            if not Config.AutoPackRollback then break end
            
            if foundTarget then
                notif("Target reached! Found: " .. foundInfo, 5, "Success")
                Config.AutoPackRollback = false
                pcall(function()
                    local HttpService = game:GetService("HttpService")
                    if Config.PackRollbackWebhookURL and Config.PackRollbackWebhookURL ~= "" then
                        local payload = {
                            content = "@everyone",
                            embeds = {{
                                title = "Gatcha Pack/Crate Target Found!",
                                description = "**Player:** " .. LocalPlayer.Name .. "\n**Found Item:** " .. foundInfo,
                                color = 3066993,
                                timestamp = DateTime.now():ToIsoDate()
                            }}
                        }
                        local data = HttpService:JSONEncode(payload)
                        if request then
                            request({
                                Url = Config.PackRollbackWebhookURL,
                                Method = "POST",
                                Headers = {["Content-Type"] = "application/json"},
                                Body = data
                            })
                        end
                    end
                end)
                
                local Event = game:GetService("ReplicatedStorage").SharedModules.Packet.RemoteEvent
                Event:FireServer(54, "")
                Event:FireServer(54, "")
                Event:FireServer(54, "nil")
                
                break
            else
                notif("Target not found, rejoining server...", 3, "Rejoin")
                task.wait(1)
                
                if Config.AutoPackRollback then
                    LocalPlayer:Kick("\nTarget not found, Rejoining...")
                    task.wait(1)
                    local TeleportService = game:GetService("TeleportService")
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                    task.wait(10)
                end
            end
        end
    end)
end

PackRollbackSection:AddToggle({
    Title = "Auto Gatcha Pack Rollback",
    Title2 = "Enable",
    Content = "Fire rollback, open packs, check target, cancel/rejoin.",
    Default = false,
    Callback = function(val)
        Config.AutoPackRollback = val
        if UI_LOADED and val then startPackRollbackLoop() end
    end
})

-- ============== Watering Can Rollback (Inf Watering Can) ==============
local WCRollbackSection = RollbackTab:AddSection("Inf Watering Can Rollback")

WCRollbackSection:AddParagraph({
    Title = "How it works:",
    Content = "Rollback → Water selected tree (your plot or friend's plot) → Rejoin. Repeat infinitely for infinite watering can."
})

Config.WCRollbackPlotMode = Config.WCRollbackPlotMode or "My Plot"
WCRollbackSection:AddDropdown({
    Title = "Player Plot",
    Content = "Choose whose plot to water trees on, or use saved position",
    Options = {"My Plot", "Friend's Plot", "Saved Position"},
    Default = Config.WCRollbackPlotMode,
    Multi = false,
    Callback = function(val)
        if type(val) == "table" then val = val[1] end
        Config.WCRollbackPlotMode = val
    end
})

Config.WCRollbackFriendName = Config.WCRollbackFriendName or ""
WCRollbackSection:AddInput({
    Title = "Friend's Display Name",
    Content = "Display name of the friend (only used if 'Friend's Plot' is selected)",
    Default = Config.WCRollbackFriendName,
    Callback = function(val)
        Config.WCRollbackFriendName = val
    end
})

Config.WCRollbackTree = Config.WCRollbackTree or "Apple"
local wcTreeOptions = {}
for _, s in ipairs(SEED_LIST) do
    if s ~= "None" then table.insert(wcTreeOptions, s) end
end
WCRollbackSection:AddDropdown({
    Title = "Select Tree/Plant",
    Content = "Choose which tree to water",
    Options = wcTreeOptions,
    Default = Config.WCRollbackTree,
    Multi = false,
    Callback = function(val)
        if type(val) == "table" then val = val[1] end
        Config.WCRollbackTree = val
    end
})

Config.WCRollbackAmount = Config.WCRollbackAmount or 50
WCRollbackSection:AddInput({
    Title = "Watering Can Amount",
    Content = "How many times to water before rejoin",
    Default = tostring(Config.WCRollbackAmount),
    Numeric = true,
    Callback = function(val)
        Config.WCRollbackAmount = tonumber(val) or 50
    end
})

Config.WCRollbackWebhook = Config.WCRollbackWebhook or ""
WCRollbackSection:AddInput({
    Title = "Webhook URL",
    Content = "Discord Webhook for watering can rollback notifications",
    Default = Config.WCRollbackWebhook,
    Callback = function(val)
        Config.WCRollbackWebhook = val
    end
})

Config.WCRollbackSprinkler = Config.WCRollbackSprinkler or false
WCRollbackSection:AddToggle({
    Title = "Use Super Sprinkler",
    Content = "Place Super Sprinkler next to the tree before watering",
    Default = Config.WCRollbackSprinkler,
    Callback = function(val)
        Config.WCRollbackSprinkler = val
    end
})

-- Save Position feature
local spPath = "Napoleon_WCSavedPos.json"

local function loadSavedPos()
    if isfile and readfile and isfile(spPath) then
        pcall(function()
            local HttpService = game:GetService("HttpService")
            local data = HttpService:JSONDecode(readfile(spPath))
            if data and data.X and data.Y and data.Z then
                Config.WCRollbackSavedPos = data
            end
        end)
    end
end

local function saveSavedPos(pos)
    if isfile and writefile then
        pcall(function()
            local HttpService = game:GetService("HttpService")
            writefile(spPath, HttpService:JSONEncode(pos))
        end)
    end
end

loadSavedPos()
Config.WCRollbackSavedPos = Config.WCRollbackSavedPos or nil

local wcSavedPosParagraph = WCRollbackSection:AddParagraph({
    Title = "Saved Position:",
    Content = Config.WCRollbackSavedPos and ("X: " .. math.floor(Config.WCRollbackSavedPos.X) .. " Y: " .. math.floor(Config.WCRollbackSavedPos.Y) .. " Z: " .. math.floor(Config.WCRollbackSavedPos.Z)) or "Not saved yet (only used if 'Saved Position' mode is selected)"
})

WCRollbackSection:AddButton({
    Title = "Save Current Position",
    Content = "Save your current standing position for watering",
    Callback = function()
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos = hrp.Position
                Config.WCRollbackSavedPos = {X = pos.X, Y = pos.Y, Z = pos.Z}
                saveSavedPos(Config.WCRollbackSavedPos)
                local text = "X: " .. math.floor(pos.X) .. " Y: " .. math.floor(pos.Y) .. " Z: " .. math.floor(pos.Z)
                pcall(function() wcSavedPosParagraph:SetContent(text) end)
                notif("Position saved! (" .. text .. ")", 3, "WC Rollback")
            end
        end
    end
})

function startWateringCanRollbackLoop()
    task.spawn(function()
        print("Starting auto watering can rollback loop")
        task.wait(1)
        notif("Waiting 5 seconds before starting watering can rollback", 5, "WC Rollback")
        task.wait(5)
        local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
        local TweenService = game:GetService("TweenService")
        
        -- Step 1: Fire rollback repeatedly every 5 seconds to ensure success
        task.spawn(function()
            local Event = game:GetService("ReplicatedStorage").SharedModules.Packet.RemoteEvent
            while Config.AutoWateringCanRollback do
                pcall(function() Event:FireServer(54, ":\xF7") end)
                task.wait(5)
            end
        end)
        
        while Config.AutoWateringCanRollback do
            
            local maxWC = tonumber(Config.WCRollbackAmount) or 50
            local usedWC = 0
            local targetTreeName = Config.WCRollbackTree or "Apple"
            local plotMode = Config.WCRollbackPlotMode or "My Plot"
            
            notif("Watering " .. targetTreeName .. " " .. maxWC .. " times (" .. plotMode .. ")...", 3, "WC Rollback")
            
            local cachedPlot = nil
            local wcNotFoundCount = 0
            local function isSprinklerNearby(pos, radius)
                local gardens = workspace:FindFirstChild("Gardens")
                if gardens then
                    for _, plot in ipairs(gardens:GetChildren()) do
                        local function checkFolder(folderName)
                            local folder = plot:FindFirstChild(folderName)
                            if folder then
                                for _, p in ipairs(folder:GetChildren()) do
                                    if p:IsA("Model") or p:IsA("BasePart") then
                                        local isSprinkler = p:GetAttribute("SprinklerName") or string.find(string.lower(p.Name), "sprinkler") or folderName == "Sprinklers"
                                        if isSprinkler then
                                            local pivot = p:IsA("Model") and p:GetPivot().Position or p.Position
                                            local dist = Vector3.new(pivot.X, 0, pivot.Z) - Vector3.new(pos.X, 0, pos.Z)
                                            if dist.Magnitude <= radius then
                                                return true
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        
                        if checkFolder("Sprinklers") then return true end
                        if checkFolder("Props") then return true end
                    end
                end
                return false
            end
            
            -- Step 2: Water the tree
            while usedWC < maxWC and Config.AutoWateringCanRollback do
                if LocalPlayer:GetAttribute("LoadingScreenActive") == true or LocalPlayer:GetAttribute("OfflineCutscenePlaying") == true then
                    notif("Waiting for Cutscene to finish...", 2, "Info")
                    task.wait(2)
                    continue
                end
                
                local char = LocalPlayer.Character
                
                -- === SAVED POSITION MODE: skip all plot/tree detection ===
                if plotMode == "Saved Position" then
                    if not Config.WCRollbackSavedPos then
                        notif("No saved position! Save a position first.", 3, "Error")
                        task.wait(3)
                        break
                    end
                    
                    local swcTool = nil
                    if char then
                        swcTool = char:FindFirstChild("Super Watering Can")
                    end
                    if not swcTool then
                        swcTool = LocalPlayer.Backpack:FindFirstChild("Super Watering Can")
                    end
                    
                    if char and swcTool then
                        wcNotFoundCount = 0
                        -- Tween to saved position
                        pcall(function()
                            local hrp = char:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local sp = Config.WCRollbackSavedPos
                                local targetCF = CFrame.new(sp.X, sp.Y, sp.Z)
                                local distance = (hrp.Position - targetCF.Position).Magnitude
                                if distance > 5 then
                                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                                    local walkSpeed = humanoid and humanoid.WalkSpeed or 16
                                    local duration = math.clamp(distance / walkSpeed, 0.3, 15)
                                    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCF})
                                    tween:Play()
                                    tween.Completed:Wait()
                                end
                            end
                        end)
                        
                        -- Check and place Sprinkler if needed
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        local sp = Config.WCRollbackSavedPos
                        local spVector = Vector3.new(sp.X, sp.Y, sp.Z)
                        
                        if Config.WCRollbackSprinkler and hrp and (hrp.Position - spVector).Magnitude <= 15 then
                            if not isSprinklerNearby(spVector, 25) then
                                local ssTool = char:FindFirstChild("Super Sprinkler") or LocalPlayer.Backpack:FindFirstChild("Super Sprinkler")
                                if ssTool then
                                    pcall(function()
                                        if ssTool.Parent ~= char then
                                            local humanoid = char:FindFirstChildOfClass("Humanoid")
                                            if humanoid then humanoid:EquipTool(ssTool) end
                                        end
                                        
                                        local plotId = LocalPlayer:GetAttribute("PlotId") or 1
                                        local gardens = workspace:FindFirstChild("Gardens")
                                        if gardens then
                                            local closestDist = math.huge
                                            for _, plot in ipairs(gardens:GetChildren()) do
                                                local core = plot:FindFirstChild("Signs") and plot.Signs:FindFirstChild("Garden") and plot.Signs.Garden:FindFirstChild("CorePart")
                                                if core then
                                                    local dist = (core.Position - spVector).Magnitude
                                                    if dist < closestDist then
                                                        closestDist = dist
                                                        plotId = tonumber(string.match(plot.Name, "%d+")) or plotId
                                                    end
                                                end
                                            end
                                        end
                                        
                                        Networking.Place.PlaceSprinkler:Fire(spVector + Vector3.new(1.5, 0, 0), "Super Sprinkler", ssTool, plotId)
                                        task.wait(0.5)
                                    end)
                                else
                                    notif("Super Sprinkler not found in inventory!", 3, "Warning")
                                end
                            end
                        end
                        
                        -- Water at saved position
                        pcall(function()
                            if swcTool.Parent ~= char then
                                local humanoid = char:FindFirstChildOfClass("Humanoid")
                                if humanoid then humanoid:EquipTool(swcTool) end
                            end
                            local sp = Config.WCRollbackSavedPos
                            Networking.WateringCan.UseWateringCan:Fire(Vector3.new(sp.X, sp.Y, sp.Z), swcTool.Name, swcTool)
                        end)
                        usedWC = usedWC + 1
                        task.wait(1)
                    else
                        if not swcTool then
                            notif("Super Watering Can not found! Waiting...", 2, "Warning")
                            wcNotFoundCount = wcNotFoundCount + 1
                            if wcNotFoundCount >= 5 then
                                notif("Watering can missing for 5 cycles. Rejoining...", 3, "Error")
                                task.wait(1)
                                break
                            end
                        end
                        task.wait(2)
                    end
                else
                -- === MY PLOT / FRIEND'S PLOT MODE ===
                -- Find the correct plot
                if not cachedPlot or not cachedPlot.Parent then
                    if plotMode == "My Plot" then
                        cachedPlot = getMyPlot()
                    else
                        -- Find friend's plot by display name
                        local friendName = Config.WCRollbackFriendName or ""
                        if friendName ~= "" then
                            local gardensFolder = workspace:FindFirstChild("Gardens")
                            if gardensFolder then
                                for _, plot in ipairs(gardensFolder:GetChildren()) do
                                    local textLabel = plot:FindFirstChild("Signs")
                                        and plot.Signs:FindFirstChild("Garden")
                                        and plot.Signs.Garden:FindFirstChild("CorePart")
                                        and plot.Signs.Garden.CorePart:FindFirstChild("SurfaceGui")
                                        and plot.Signs.Garden.CorePart.SurfaceGui:FindFirstChild("Player")
                                        and plot.Signs.Garden.CorePart.SurfaceGui.Player:FindFirstChild("TextLabel")
                                    if textLabel and textLabel:IsA("TextLabel") then
                                        if string.find(textLabel.Text, friendName, 1, true) then
                                            cachedPlot = plot
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                local targetPlot = cachedPlot
                
                -- Find SWC tool
                local swcTool = nil
                if char then
                    swcTool = char:FindFirstChild("Super Watering Can")
                end
                if not swcTool then
                    swcTool = LocalPlayer.Backpack:FindFirstChild("Super Watering Can")
                end
                
                -- Find target tree on the plot
                local targetPlant = nil
                if targetPlot then
                    local function findInFolder(folderName)
                        local folder = targetPlot:FindFirstChild(folderName)
                        if folder then
                            for _, model in ipairs(folder:GetChildren()) do
                                if model:IsA("Model") then
                                    local seedName = model:GetAttribute("SeedName") or ""
                                    local coreName = model:GetAttribute("CorePartName") or ""
                                    local fruitName = model:GetAttribute("FruitName") or ""
                                    local plantName = model:GetAttribute("PlantName") or ""
                                    
                                    local plantType = fruitName ~= "" and fruitName or coreName
                                    if plantType == "" then plantType = seedName end
                                    
                                    if plantType == targetTreeName or seedName == targetTreeName or plantName == targetTreeName then
                                        targetPlant = model
                                        break
                                    end
                                end
                            end
                        end
                    end
                    findInFolder("Props")
                    if not targetPlant then findInFolder("Plants") end
                end
                
                if targetPlot and targetPlant and swcTool then
                    wcNotFoundCount = 0
                    -- Tween to tree at WalkSpeed
                    pcall(function()
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local targetCF = targetPlant:GetPivot() + Vector3.new(0, 4, 0)
                            local distance = (hrp.Position - targetCF.Position).Magnitude
                            if distance > 5 then
                                local humanoid = char:FindFirstChildOfClass("Humanoid")
                                local walkSpeed = humanoid and humanoid.WalkSpeed or 16
                                local duration = math.clamp(distance / walkSpeed, 0.3, 15)
                                local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCF})
                                tween:Play()
                                tween.Completed:Wait()
                            end
                        end
                    end)
                    
                    -- Check and place Sprinkler if needed
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local targetPos = targetPlant:GetPivot().Position
                    
                    if Config.WCRollbackSprinkler and hrp and (hrp.Position - targetPos).Magnitude <= 15 then
                        if not isSprinklerNearby(targetPos, 25) then
                            local ssTool = char:FindFirstChild("Super Sprinkler") or LocalPlayer.Backpack:FindFirstChild("Super Sprinkler")
                            if ssTool then
                                pcall(function()
                                    if ssTool.Parent ~= char then
                                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                                        if humanoid then humanoid:EquipTool(ssTool) end
                                    end
                                    
                                    local plotId = tonumber(string.match(targetPlot.Name, "%d+")) or 1
                                    Networking.Place.PlaceSprinkler:Fire(targetPos + Vector3.new(1.5, 0, 0), toolName, ssTool, plotId)
                                    task.wait(0.5)
                                end)
                            else
                                notif("Super Sprinkler not found in inventory!", 3, "Warning")
                            end
                        end
                    end
                    
                    pcall(function()
                        if swcTool.Parent ~= char then
                            local humanoid = char:FindFirstChildOfClass("Humanoid")
                            if humanoid then humanoid:EquipTool(swcTool) end
                        end
                        Networking.WateringCan.UseWateringCan:Fire(targetPlant:GetPivot().Position, swcTool.Name, swcTool)
                    end)
                    usedWC = usedWC + 1
                    task.wait(1)
                else
                    if not targetPlot then
                        if plotMode == "My Plot" then
                            notif("Waiting for your plot to load...", 2, "Info")
                        else
                            notif("Friend's plot not found! Check display name: " .. (Config.WCRollbackFriendName or ""), 2, "Error")
                        end
                    elseif not swcTool then
                        notif("Super Watering Can not found! Waiting...", 2, "Warning")
                        wcNotFoundCount = wcNotFoundCount + 1
                        if wcNotFoundCount >= 5 then
                            notif("Watering can missing for 5 cycles. Rejoining...", 3, "Error")
                            task.wait(1)
                            break
                        end
                    elseif not targetPlant then
                        notif(targetTreeName .. " not found on " .. (plotMode == "My Plot" and "your" or "friend's") .. " plot!", 2, "Error")
                    end
                    task.wait(2)
                end
                end -- end of My Plot / Friend's Plot else block
            end
            
            if not Config.AutoWateringCanRollback then break end
            
            notif("Watered " .. usedWC .. "x done. Rejoining...", 3, "WC Rollback")
            
            -- Send webhook notification
            if Config.WCRollbackWebhook and Config.WCRollbackWebhook ~= "" then
                pcall(function()
                    local HttpService = game:GetService("HttpService")
                    local req = syn and syn.request or http_request or request
                    if req then
                        local data = {
                            ["content"] = "\xF0\x9F\x8C\x8A **" .. LocalPlayer.Name .. "** used **" .. usedWC .. "x** Super Watering Can on **" .. targetTreeName .. "** (" .. plotMode .. "). Rejoining...\n@everyone"
                        }
                        req({
                            Url = Config.WCRollbackWebhook,
                            Method = "POST",
                            Headers = { ["Content-Type"] = "application/json" },
                            Body = HttpService:JSONEncode(data)
                        })
                    end
                end)
            end
            
            task.wait(1)
            
            -- Step 3: Rejoin
            if Config.AutoWateringCanRollback then
                LocalPlayer:Kick("\nRejoining for watering can rollback...")
                task.wait(1)
                local TeleportService = game:GetService("TeleportService")
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
                task.wait(10)
            end
        end
    end)
end

WCRollbackSection:AddToggle({
    Title = "Auto Watering Can Rollback",
    Title2 = "Enable",
    Content = "Fire rollback, water tree, rejoin. Repeat infinitely for infinite watering can.",
    Default = false,
    Callback = function(val)
        Config.AutoWateringCanRollback = val
        if UI_LOADED and val then startWateringCanRollbackLoop() end
    end
})

print("rollback tab loaded!")
end

LoadInfoTab()
task.wait(0.05)
LoadMainTab()
task.wait(0.05)
LoadShopTab()
task.wait(0.05)
LoadTradeTab()
task.wait(0.05)
LoadHelperTab()
task.wait(0.05)
LoadVisualsTab()
task.wait(0.05)
LoadMiscTab()
task.wait(0.05)
-- LoadRollbackTab()
Tabs:AddConfigTab() 
task.wait(2)

print("Load all tabs")
UI_LOADED = true


if Config.AutoPlant then task.spawn(startPlantLoop) end
if Config.AutoShovel then task.spawn(startShovelLoop) end
if Config.AutoShovelFruits then task.spawn(startShovelFruitLoop) end
if Config.AutoSwingShovel then task.spawn(startAutoSwingShovelLoop) end
if Config.ProtectFromTrowel then task.spawn(startProtectLoop) end
if Config.AutoHarvest then task.spawn(startHarvestLoop) end
if Config.AutoClaim then task.spawn(startClaimLoop) end
if Config.AutoSteal then task.spawn(startStealLoop) end
if Config.AutoFavFruit then task.spawn(startAutoFavLoop) end
if Config.AutoSell then task.spawn(startSellLoop) end
if Config.AutoBuySeed or Config.AutoBuyGear or Config.AutoBuyProp then task.spawn(startBuyLoop) end
if Config.TamePets then task.spawn(startTameLoop) end
if Config.AutoPetFinderHop then task.spawn(startPetFinderHopLoop) end
if Config.AutoJoinPetFinder then task.spawn(startJoinPetFinderLoop) end
if Config.AutoTrade then task.spawn(startTradeLoop) end
if Config.AutoDrop then task.spawn(startAutoDropLoop) end
if Config.PredictWeather then task.spawn(startPredictLoop) end
if Config.AutoLeaveWeather then task.spawn(startAutoLeaveWeatherLoop) end
if Config.MoonFinderActive then task.spawn(startMoonFinderLoop) end
if Config.HelperWCPlotMode then task.spawn(startHelperWCLoop) end
if Config.HelperAutoSprinkler then task.spawn(startHelperSSLoop) end
if Config.HelperAutoPot then task.spawn(startHelperPotLoop) end
if Config.HelperAutoPlacePot then task.spawn(startHelperPlacePotLoop) end
if Config.HelperAutoEclipse then task.spawn(startHelperEclipseLoop) end

-- if Config.AutoBigFruitMethod then task.spawn(startAutoBigFruitMethodLoop) end
-- if Config.AutoEggRollback then task.spawn(startEggRollbackLoop) end
-- if Config.AutoPackRollback then task.spawn(startPackRollbackLoop) end
-- if Config.AutoWateringCanRollback then task.spawn(startWateringCanRollbackLoop) end

notif("GAG Script Loaded!", 5, "Napoleon")
print("Script GAG 2 Loaded!")

task.spawn(function()
    local ActiveESPs = {}
    
    local function cleanESP(plant)
        if ActiveESPs[plant] then
            if ActiveESPs[plant].Gui then ActiveESPs[plant].Gui:Destroy() end
            if ActiveESPs[plant].Highlight then 
                ActiveESPs[plant].Highlight:Destroy() 
            end
            ActiveESPs[plant] = nil
        end
    end

    local function FormatMoney(value)
        if value < 1000 then return tostring(math.floor(value)) end
        
        local index = math.floor(math.log10(value) / 3)
        local formatted = string.format("%.2f", value / (10 ^ (index * 3))):gsub("%.?0+$", "")
        
        local suffixes = {"K", "M", "B", "T", "Qd", "Qn"}
        if index <= #suffixes then
            return formatted .. suffixes[index]
        end
        
        local alphaIndex = index - #suffixes - 1
        local suffix = ""
        local length = 2
        
        while true do
            local maxForLength = 26 ^ length
            if alphaIndex < maxForLength then
                for i = 1, length do
                    suffix = string.char(97 + (alphaIndex % 26)) .. suffix
                    alphaIndex = math.floor(alphaIndex / 26)
                end
                break
            else
                alphaIndex = alphaIndex - maxForLength
                length = length + 1
            end
        end
        
        return formatted .. suffix
    end

    local CollectionService = game:GetService("CollectionService")

    local function UpdateWorldESP()
        if not Config.ESPFruit then
            for plant, _ in pairs(ActiveESPs) do cleanESP(plant) end
            return
        end
        
        local gardensFolder = workspace:FindFirstChild("Gardens")
        if not gardensFolder then return end
        
        local targetPlants = {}
        local myPlot = getMyPlot()
        
        local prompts = CollectionService:GetTagged("HarvestPrompt")
        for _, p in ipairs(CollectionService:GetTagged("StealPrompt")) do table.insert(prompts, p) end
        
        local espLoopCount = 0
        for _, prompt in ipairs(prompts) do
            espLoopCount = espLoopCount + 1
            if espLoopCount % 20 == 0 then task.wait() end
            if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                local adorneePart = prompt.Parent
                local plantModel = adorneePart and adorneePart:FindFirstAncestorWhichIsA("Model")
                
                if plantModel and plantModel:IsDescendantOf(gardensFolder) then
                    local plot = plantModel
                    while plot and plot.Parent ~= gardensFolder do
                        plot = plot.Parent
                    end
                    if Config.ESPPlotFilter == "My Plot" and plot ~= myPlot then continue end
                    
                    local seedName = plantModel:GetAttribute("SeedName") or ""
                    local coreName = plantModel:GetAttribute("CorePartName") or ""
                    local fruitName = plantModel:GetAttribute("FruitName") or ""
                    local mutation = plantModel:GetAttribute("Mutation") or "None"
                    
                    local plantType = fruitName ~= "" and fruitName or coreName
                    if plantType == "" then plantType = seedName end
                    
                    local passesFilter = false
                    if Config.ESPFruitFilter == "All" then passesFilter = true
                    elseif Config.ESPFruitFilter == plantType then passesFilter = true end
                    
                    if passesFilter then
                        local sizeMulti = plantModel:GetAttribute("SizeMulti") or 1
                        
                        -- Calculate display weight (KG) using FruitVisualizerController
                        local weightKg = 0
                        if FruitVisualizerController then
                            pcall(function()
                                weightKg = FruitVisualizerController:CalculateFruitWeight(plantModel)
                                if not weightKg and FruitVisualizerController.CalculatePlantWeight then
                                    weightKg = FruitVisualizerController:CalculatePlantWeight(plantModel)
                                end
                            end)
                        end
                        weightKg = tonumber(weightKg) or 0
                        if weightKg == 0 then
                            weightKg = 100 * sizeMulti
                        end
                        
                        -- Calculate sell value using the game's actual FruitValueCalc + SellFlags
                        local sellValue = 0
                        local useStock = (Config.ESPFruitMode ~= "Base Price")
                        local fruitName = plantType
                        if string.match(fruitName, " [sS]eed$") then fruitName = string.gsub(fruitName, " [sS]eed$", "") end
                        pcall(function()
                            local decayAlpha = plantModel:GetAttribute("DecayAlpha")
                            local rawValue = FruitValueCalc(fruitName, sizeMulti, mutation ~= "None" and mutation or nil, LocalPlayer, decayAlpha)
                            -- Apply server GlobalMultiplier & per-fruit PriceMultipliers
                            -- Sell Price mode: juga kalikan stock multiplier real-time
                            -- Base Price mode: hanya pakai harga dasar per-kg tanpa stock
                            local stockMult = useStock and getFruitStockMultiplier(fruitName) or 1
                            sellValue = math.floor(SellFlags.Apply(fruitName, rawValue) * stockMult)
                        end)
                        -- Fallback if FruitValueCalc fails
                        if sellValue == 0 then
                            local baseValue = SellValueData[fruitName] or SellValueData[plantType] or SellValueData[seedName] or 0
                            local mutMulti = 1
                            if MutationData and MutationData.ReturnPriceMultiplier then
                                mutMulti = MutationData.ReturnPriceMultiplier(mutation) or 1
                            end
                            local stockMult = useStock and getFruitStockMultiplier(plantType) or 1
                            sellValue = math.floor(SellFlags.Apply(plantType, baseValue * sizeMulti ^ 2.65 * mutMulti) * stockMult)
                        end
                        
                        if weightKg > 0 then
                            table.insert(targetPlants, {
                                Part = adorneePart,
                                PlantModel = plantModel,
                                Plot = plot,
                                Kg = weightKg,
                                Mutation = mutation,
                                Value = sellValue,
                                Name = plantType
                            })
                        end
                    end
                end
            end
        end
        
        if (Config.ESPValueFilter == "Highest Value" or Config.ESPValueFilter == "Highest KG") and #targetPlants > 0 then
            local highestPerPlot = {}
            for _, tp in ipairs(targetPlants) do
                local plotKey = tp.Plot or "UnknownPlot"
                if not highestPerPlot[plotKey] then
                    highestPerPlot[plotKey] = tp
                else
                    if Config.ESPValueFilter == "Highest Value" then
                        if tp.Value > highestPerPlot[plotKey].Value then
                            highestPerPlot[plotKey] = tp
                        end
                    elseif Config.ESPValueFilter == "Highest KG" then
                        if tp.Kg > highestPerPlot[plotKey].Kg then
                            highestPerPlot[plotKey] = tp
                        end
                    end
                end
            end
            
            targetPlants = {}
            for _, tp in pairs(highestPerPlot) do
                table.insert(targetPlants, tp)
            end
        end
        
        local currentValidParts = {}
        for _, tp in ipairs(targetPlants) do
            currentValidParts[tp.Part] = true
            
            local fruitModel = tp.PlantModel
            if fruitModel then
                if not ActiveESPs[tp.Part] then
                    local bgui = Instance.new("BillboardGui")
                    bgui.Name = "FruitESP"
                    bgui.Size = UDim2.new(0, 200, 0, 70)
                    bgui.StudsOffset = Vector3.new(0, 2, 0)
                    bgui.AlwaysOnTop = true
                    
                    local pcore = game:GetService("CoreGui")
                    if pcore then
                        bgui.Parent = pcore
                    else
                        bgui.Parent = LocalPlayer:WaitForChild("PlayerGui")
                    end
                    
                    bgui.Adornee = fruitModel
                    
                    local tl = Instance.new("TextLabel")
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.BackgroundTransparency = 1
                    tl.RichText = true
                    tl.TextStrokeTransparency = 0.5
                    tl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
                    tl.TextColor3 = Color3.fromRGB(255,255,255)
                    tl.Font = Enum.Font.GothamBold
                    tl.TextSize = 14
                    tl.Parent = bgui
                    
                    ActiveESPs[tp.Part] = { Gui = bgui, Label = tl, Highlight = nil }
                end
                
                local espData = ActiveESPs[tp.Part]
                
                if Config.ESPValueFilter == "Highest Value" or Config.ESPValueFilter == "Highest KG" then
                    if not espData.Highlight then
                        local h = Instance.new("Highlight")
                        h.Name = "FruitESPHighlight"
                        h.FillColor = Color3.fromRGB(81, 66, 255)
                        h.OutlineColor = Color3.fromRGB(255, 255, 255)
                        h.FillTransparency = 0.5
                        local pcore = game:GetService("CoreGui")
                        h.Parent = pcore or LocalPlayer:WaitForChild("PlayerGui")
                        h.Adornee = fruitModel
                        espData.Highlight = h
                    end
                else
                    if espData.Highlight then
                        espData.Highlight:Destroy()
                        espData.Highlight = nil
                    end
                end
                
                if espData and espData.Label then
                    local mutText = tp.Mutation ~= "None" and "<font color='rgb(255,215,0)'>[" .. tp.Mutation .. "]</font> " or ""
                    local valText = "<font color='rgb(100,255,100)'>$" .. FormatMoney(tp.Value) .. "</font>"
                    espData.Label.Text = mutText .. tp.Name .. "\n" .. string.format("%.2f", tp.Kg) .. " KG\n" .. valText
                end
            end
        end
        
        for part, _ in pairs(ActiveESPs) do
            if not currentValidParts[part] or not part.Parent then
                cleanESP(part)
            end
        end
    end

    -- ============================================================
    -- PLANT FEET ESP LOOP (scan all growing plants, show HEIGHT in ft)
    local ActivePlantFeetESPs = {}
    local function cleanPlantFeetESP(key)
        if ActivePlantFeetESPs[key] then
            if ActivePlantFeetESPs[key].Gui then ActivePlantFeetESPs[key].Gui:Destroy() end
            ActivePlantFeetESPs[key] = nil
        end
    end

    -- Build lookup table: SeedName -> YHeight (max height in ft)
    local SEED_YHEIGHT = {}
    pcall(function()
        local SD = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("SeedData"))
        for _, s in ipairs(SD) do
            if s.SeedName and s.YHeight then
                SEED_YHEIGHT[s.SeedName] = s.YHeight
            end
        end
    end)

    local function UpdatePlantFeetESP()
        if not Config.ESPPlantFeet then
            for k, _ in pairs(ActivePlantFeetESPs) do cleanPlantFeetESP(k) end
            return
        end

        local Gardens = workspace:FindFirstChild("Gardens")
        if not Gardens then return end

        local currentKeys = {}

        for _, plot in ipairs(Gardens:GetChildren()) do
            local plantsFolder = plot:FindFirstChild("Plants")
            if not plantsFolder then continue end

            for _, plantModel in ipairs(plantsFolder:GetChildren()) do
                if not plantModel:IsA("Model") then continue end

                local age = plantModel:GetAttribute("Age")
                local maxAge = plantModel:GetAttribute("MaxAge")
                if not age then continue end
                maxAge = maxAge or 100

                local progress = math.clamp(age / maxAge * 100, 0, 100)

                -- Nama dan mutasi tanaman
                local seedName = plantModel:GetAttribute("SeedName") or plantModel:GetAttribute("FruitName") or plantModel.Name
                local cleanName = string.gsub(seedName, "%s+[sS]eed$", "")
                local mutation = plantModel:GetAttribute("Mutation") or "None"

                local key = plantModel
                currentKeys[key] = true

                local espData = ActivePlantFeetESPs[key]
                local plantFt, labelOffset
                if espData then
                    plantFt = espData.PlantFt
                    labelOffset = espData.LabelOffset
                else
                    plantFt, labelOffset = GetPlantFt(plantModel)
                end

                if plantFt <= 0 then continue end

                if not espData then
                    local bgui = Instance.new("BillboardGui")
                    bgui.Name = "PlantFeetESP"
                    bgui.Size = UDim2.new(0, 200, 0, 45)
                    bgui.StudsOffset = Vector3.new(0, math.max(labelOffset + 1, 2.5), 0)
                    bgui.AlwaysOnTop = true
                    bgui.Adornee = plantModel
                    local ok, pcore = pcall(function() return game:GetService("CoreGui") end)
                    bgui.Parent = (ok and pcore) or LocalPlayer:WaitForChild("PlayerGui")

                    local tl = Instance.new("TextLabel")
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.BackgroundTransparency = 1
                    tl.RichText = true
                    tl.TextStrokeTransparency = 0.5
                    tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    tl.TextColor3 = Color3.fromRGB(255, 255, 255)
                    tl.Font = Enum.Font.GothamBold
                    tl.TextSize = 13
                    tl.Parent = bgui

                    espData = { Gui = bgui, Label = tl, PlantFt = plantFt, LabelOffset = labelOffset }
                    ActivePlantFeetESPs[key] = espData
                end

                if espData and espData.Label then
                    local progressFraction = math.clamp(progress / 100, 0.1, 1)
                    local visualHeight = espData.PlantFt * progressFraction
                    espData.Gui.StudsOffset = Vector3.new(0, visualHeight - (espData.PlantFt / 2) + 2, 0)

                    local mutText = mutation ~= "None" and "<font color='rgb(255,215,0)'>[" .. mutation .. "]</font> " or ""
                    local progressColor = progress >= 100 and "rgb(100,255,100)" or "rgb(255,200,50)"
                    local progressText = "<font color='" .. progressColor .. "'>" .. string.format("%.0f", progress) .. "%</font>"
                    local ftColor = progress >= 100 and "rgb(100,255,100)" or "rgb(100,220,255)"

                    espData.Label.Text = mutText .. cleanName .. "\n"
                        .. "<font color='" .. ftColor .. "'>" .. tostring(espData.PlantFt) .. " ft</font>  " .. progressText
                end
            end
        end

        -- Bersihkan ESP tanaman yang sudah tidak ada
        for k, _ in pairs(ActivePlantFeetESPs) do
            if not currentKeys[k] or not k.Parent then
                cleanPlantFeetESP(k)
            end
        end
    end







    local function UpdateInventoryESP()
        -- Inventory ESP
        pcall(function()
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if not pg then return end
            local bpGui = pg:FindFirstChild("BackpackGui")
            local backpack = bpGui and bpGui:FindFirstChild("Backpack")
            if not backpack then return end
            
            local containers = {}
            local inv = backpack:FindFirstChild("Inventory")
            if inv then
                local sf = inv:FindFirstChild("ScrollingFrame")
                if sf then 
                    table.insert(containers, sf) 
                    local uigrid = sf:FindFirstChild("UIGridFrame")
                    if uigrid then table.insert(containers, uigrid) end
                end
                local fi = inv:FindFirstChild("FruitInventory")
                if fi then table.insert(containers, fi) end
            end
            
            local hotbar = backpack:FindFirstChild("Hotbar")
            if hotbar then table.insert(containers, hotbar) end
            
            local usedTools = {}
            local backpackItems = {}
            local groupedBPItems = {}
            
            local function collectItemsFrom(container, useDescendants)
                if not container then return end
                local items = useDescendants and container:GetDescendants() or container:GetChildren()
                for _, t in ipairs(items) do
                    if (t:IsA("Tool") or t:IsA("Folder") or t:IsA("Model") or t:IsA("Configuration")) then
                        local isInvalidBP = string.find(t.Name, "Seed") or string.find(t.Name, "Sapling") or string.find(t.Name, "Potted")
                        if not isInvalidBP then
                            local bName = t:GetAttribute("FruitName") or t:GetAttribute("Fruit") or t.Name
                            bName = string.gsub(bName, "%s*%[[%d%.]+kg%]", "")
                        
                            local bMut = t:GetAttribute("Mutation") or t:GetAttribute("Variant") or "None"
                            if bMut == "None" then
                                local mutMatch = string.match(t.Name, "%[(%a+)%]")
                                if mutMatch and not string.match(mutMatch, "kg") then
                                    bMut = mutMatch
                                    bName = string.gsub(bName, "%[%w+%]", ""):match("^%s*(.-)%s*$")
                                end
                            end
                            
                            local kgStr = string.match(t.Name, "%[([%d%.]+)kg%]")
                            local weightAttr = t:GetAttribute("Weight")
                            local bSizeMulti = t:GetAttribute("SizeMulti") or t:GetAttribute("SizeMultiplier")
                            if not bSizeMulti then
                                local smVal = t:FindFirstChild("SizeMulti") or t:FindFirstChild("SizeMultiplier")
                                if smVal and (smVal:IsA("NumberValue") or smVal:IsA("StringValue")) then
                                    bSizeMulti = tonumber(smVal.Value)
                                end
                            end
                            
                            local bKg = nil
                            if kgStr then
                                bKg = tonumber(kgStr)
                            elseif weightAttr then
                                bKg = weightAttr
                            elseif bSizeMulti then
                                bKg = 100 * bSizeMulti
                            else
                                bKg = 0
                            end
                            
                            local itemData = {
                                Tool = t,
                                Name = bName,
                                Mut = bMut,
                                Kg = bKg,
                                SizeMulti = bSizeMulti or 1,
                                DecayAlpha = t:GetAttribute("DecayAlpha")
                            }
                            table.insert(backpackItems, itemData)
                            local bNameLower = string.lower(bName)
                            if not groupedBPItems[bNameLower] then groupedBPItems[bNameLower] = {} end
                            table.insert(groupedBPItems[bNameLower], itemData)
                        end
                    end
                end
            end
            
            collectItemsFrom(LocalPlayer.Backpack, false)
            if LocalPlayer.Character then
                collectItemsFrom(LocalPlayer.Character, true)
            end
            
            local totalInventoryValue = 0
            local useStockInv = (Config.ESPInventoryMode ~= "Base Price")
            if Config.ESPInventory then
                for _, bp in ipairs(backpackItems) do
                    local baseValue = SellValueData[bp.Name]
                    if baseValue and bp.Kg and bp.Kg > 0 then
                        local sellValue = 0
                        local fruitName = bp.Name
                        if string.match(fruitName, " [sS]eed$") then fruitName = string.gsub(fruitName, " [sS]eed$", "") end
                        pcall(function()
                            local rawValue = FruitValueCalc(fruitName, bp.SizeMulti, bp.Mut ~= "None" and bp.Mut or nil, LocalPlayer, bp.DecayAlpha)
                            local stockMult = useStockInv and getFruitStockMultiplier(fruitName) or 1
                            sellValue = math.floor(SellFlags.Apply(fruitName, rawValue) * stockMult)
                        end)
                        if sellValue == 0 then
                            local mutMulti = 1
                            if MutationData and MutationData.ReturnPriceMultiplier then
                                mutMulti = MutationData.ReturnPriceMultiplier(bp.Mut) or 1
                            end
                            local stockMult = useStockInv and getFruitStockMultiplier(fruitName) or 1
                            sellValue = math.floor(SellFlags.Apply(fruitName, baseValue * bp.SizeMulti ^ 2.65 * mutMulti) * stockMult)
                        end
                        totalInventoryValue = totalInventoryValue + sellValue
                    end
                end
                
                if inv then
                    local totalValLbl = inv:FindFirstChild("GagTotalValueLbl")
                    if not totalValLbl then
                        totalValLbl = Instance.new("TextLabel")
                        totalValLbl.Name = "GagTotalValueLbl"
                        totalValLbl.Size = UDim2.new(0, 200, 0, 32)
                        totalValLbl.Position = UDim2.new(1, 0, 0, -6)
                        totalValLbl.AnchorPoint = Vector2.new(1, 1)
                        totalValLbl.BackgroundTransparency = 0.3
                        totalValLbl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                        totalValLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
                        totalValLbl.Font = Enum.Font.GothamBold
                        totalValLbl.TextSize = 16
                        totalValLbl.TextXAlignment = Enum.TextXAlignment.Right
                        totalValLbl.RichText = true
                        
                        local corner = Instance.new("UICorner")
                        corner.CornerRadius = UDim.new(0, 6)
                        corner.Parent = totalValLbl
                        
                        local pad = Instance.new("UIPadding")
                        pad.PaddingRight = UDim.new(0, 10)
                        pad.Parent = totalValLbl
                        
                        totalValLbl.Parent = inv
                    end
                    totalValLbl.Visible = true
                    totalValLbl.Text = "TOTAL VALUE: <b>$" .. FormatMoney(totalInventoryValue) .. "</b>"
                end
            else
                if inv then
                    local totalValLbl = inv:FindFirstChild("GagTotalValueLbl")
                    if totalValLbl then totalValLbl.Visible = false end
                end
            end

            local uiCount = 0
            for _, container in ipairs(containers) do
                for _, item in ipairs(container:GetChildren()) do
                    uiCount = uiCount + 1
                    if uiCount % 20 == 0 then task.wait() end
                    if item:IsA("TextButton") or item:IsA("ImageButton") or item:IsA("Frame") then
                        local toolNameLabel = item:FindFirstChild("ToolName")
                        if toolNameLabel and toolNameLabel:IsA("TextLabel") then
                            local text = toolNameLabel.Text
                            local isInvalidUI = string.find(text, "Seed") or string.find(text, "Sapling") or string.find(text, "Potted")
                            
                            if isInvalidUI then
                                local espLbl = item:FindFirstChild("InvESPLabel")
                                if espLbl then espLbl.Visible = false end
                            else
                                local name = text
                                local kg = 0
                                local mutation = "None"
                                
                                local toolCountLabel = item:FindFirstChild("ToolCount")
                                if toolCountLabel and toolCountLabel:IsA("TextLabel") then
                                    local kgMatch = string.match(toolCountLabel.Text, "([%d%.]+)kg")
                                    if kgMatch then
                                        kg = tonumber(kgMatch) or 0
                                    end
                                end
                                
                                if kg == 0 then
                                    local kgMatch = string.match(text, "([%d%.]+)kg")
                                    if kgMatch then
                                        kg = tonumber(kgMatch) or 0
                                        name = string.gsub(text, "[%s%c%(]*[%d%.]+kg[%)]*", "")
                                    end
                                end
                                
                                local mutMatch = string.match(name, "%[(.-)%]")
                                if mutMatch then
                                    mutation = mutMatch
                                    name = string.gsub(name, "%[%w+%]", ""):match("^%s*(.-)%s*$")
                                end
                            
                            local sizeMulti = 1
                            local decayAlpha = nil
                            local originalKg = kg
                            
                            -- Find the matching UI kg from backpackItems
                            local matchedItem = nil
                            local nameLower = string.lower(name)
                            local candidates = groupedBPItems[nameLower] or backpackItems
                            
                            if kg > 0 then
                                local bestDiff = math.huge
                                for _, bp in ipairs(candidates) do
                                    if not usedTools[bp.Tool] then
                                        local nMatch = true
                                        if candidates == backpackItems then
                                            local bpLower = string.lower(bp.Name)
                                            nMatch = (bpLower == nameLower) or (string.find(bpLower, nameLower, 1, true) ~= nil) or (string.find(nameLower, bpLower, 1, true) ~= nil)
                                        end
                                        if nMatch then
                                            local diff = math.abs(bp.Kg - kg)
                                            if diff < 1.0 and diff < bestDiff then
                                                bestDiff = diff
                                                matchedItem = bp
                                            end
                                        end
                                    end
                                end
                            end
                            
                            -- Fallback to name match ONLY for tools without weight
                            if not matchedItem and kg == 0 then
                                for _, bp in ipairs(candidates) do
                                    if not usedTools[bp.Tool] and bp.Kg == 0 then
                                        local nMatch = true
                                        if candidates == backpackItems then
                                            local bpLower = string.lower(bp.Name)
                                            nMatch = (bpLower == nameLower) or (string.find(bpLower, nameLower, 1, true) ~= nil) or (string.find(nameLower, bpLower, 1, true) ~= nil)
                                        end
                                        if nMatch then
                                            matchedItem = bp
                                            break
                                        end
                                    end
                                end
                            end
                            
                            local baseValue = SellValueData[name]
                            
                            if matchedItem then
                                usedTools[matchedItem.Tool] = true
                                name = matchedItem.Name
                                mutation = matchedItem.Mut ~= "None" and matchedItem.Mut or mutation
                                sizeMulti = matchedItem.SizeMulti
                                decayAlpha = matchedItem.DecayAlpha
                            end
                            if baseValue and kg > 0 then
                                -- Use FruitValueCalc + SellFlags for accurate sell value
                                local sellValue = 0
                                local fruitName = name
                                if string.match(fruitName, " [sS]eed$") then fruitName = string.gsub(fruitName, " [sS]eed$", "") end
                                local stockMult = useStockInv and getFruitStockMultiplier(fruitName) or 1
                                pcall(function()
                                    local rawValue = FruitValueCalc(fruitName, sizeMulti, mutation ~= "None" and mutation or nil, LocalPlayer, decayAlpha)
                                    -- Apply server GlobalMultiplier & per-fruit PriceMultipliers
                                    sellValue = math.floor(SellFlags.Apply(fruitName, rawValue) * stockMult)
                                end)
                                -- Fallback if FruitValueCalc fails
                                if sellValue == 0 then
                                    local mutMulti = 1
                                    if MutationData and MutationData.ReturnPriceMultiplier then
                                        mutMulti = MutationData.ReturnPriceMultiplier(mutation) or 1
                                    end
                                    sellValue = math.floor(SellFlags.Apply(fruitName, baseValue * sizeMulti ^ 2.65 * mutMulti) * stockMult)
                                end
                                
                                local espLbl = item:FindFirstChild("InvESPLabel")
                                if not espLbl then
                                    espLbl = Instance.new("TextLabel")
                                    espLbl.Name = "InvESPLabel"
                                    espLbl.Size = UDim2.new(1, 0, 0.35, 0)
                                    espLbl.Position = UDim2.new(0, 0, 0, 0)
                                    espLbl.BackgroundColor3 = Color3.fromRGB(0,0,0)
                                    espLbl.BackgroundTransparency = 0.5
                                    espLbl.TextColor3 = Color3.fromRGB(80, 255, 80)
                                    espLbl.Font = Enum.Font.GothamBold
                                    espLbl.TextScaled = true
                                    espLbl.ZIndex = 50
                                    espLbl.RichText = true
                                    
                                    local constraint = Instance.new("UITextSizeConstraint")
                                    constraint.MaxTextSize = 14
                                    constraint.Parent = espLbl
                                    
                                    local corner = Instance.new("UICorner")
                                    corner.CornerRadius = UDim.new(0, 8)
                                    corner.Parent = espLbl
                                    
                                    espLbl.Parent = item
                                end
                                espLbl.Text = "$" .. FormatMoney(sellValue)
                                espLbl.Visible = Config.ESPInventory
                            else
                                local espLbl = item:FindFirstChild("InvESPLabel")
                                if espLbl then espLbl.Visible = false end
                            end
                            end
                        end
                    end
                end
            end
        end)
    end

    while true do
        task.wait(1)
        UpdateWorldESP()
        UpdatePlantFeetESP()
        UpdateInventoryESP()
    end
end)

-- ============================================================
-- COMPLETELY DISABLE OFFLINE CUTSCENE
-- ============================================================
task.spawn(function()
    pcall(function()
        local OfflineController = require(LocalPlayer.PlayerScripts:WaitForChild("Controllers", 10):WaitForChild("OfflineGrowthAnimationController", 10))
        if OfflineController and type(OfflineController.PlayOfflineCutscene) == "function" then
            OfflineController.PlayOfflineCutscene = function()
                return false -- Returning false forces the game to instantly apply fallback (no animation)
            end
            print("Successfully disabled Offline Cutscene!")
        end
    end)
end)

-- ============================================================
-- AUTO SKIP CUTSCENE / LOADING SCREEN
-- ============================================================
task.spawn(function()
    local vim = game:GetService("VirtualInputManager")
    while task.wait(1) do
        local loading = LocalPlayer:GetAttribute("LoadingScreenActive") == true
        local offlineCutscene = LocalPlayer:GetAttribute("OfflineCutscenePlaying") == true
        if loading or offlineCutscene then
            pcall(function()
                vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.1)
                vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            end)
        end
    end
end)
-- ============================================================
-- SERVER HEARTBEAT
-- ============================================================
task.spawn(function()
    local hwid = tostring(LocalPlayer.UserId)
    local username = tostring(LocalPlayer.Name)
    local key = getgenv().Key or _G.Key or "Unknown_Key"
    local sUrl = getgenv().ServerURL or _G.ServerURL or "https://napoleonn.net"
    
    local function serializeInventory()
        local inventoryCounts = {}
        
        local function determineCat(itemName, isFruitConfig, inst)
            if isFruitConfig or (inst and inst:GetAttribute("HarvestedFruit") == true) then return "Fruits" end
            
            local baseName = string.gsub(itemName or "", "%s*%[[%d%.]+kg%]", "")
            baseName = string.gsub(baseName, "%[%w+%]", "")
            local matched = string.match(baseName, "^%s*(.-)%s*$")
            if matched then baseName = matched end
            
            if inst and inst:GetAttribute("SeedTool") then return "Seeds" end
            
            local seedList = SEED_LIST or {}
            local noSeedName = string.gsub(baseName, "%s*Seed$", "")
            if table.find(seedList, baseName) or table.find(seedList, noSeedName) then return "Seeds" end
            
            local gearList = GEAR_LIST or {}
            if table.find(gearList, baseName) then return "Tools" end
            
            local petList = PET_LIST or {}
            if table.find(petList, baseName) then return "Pets" end
            
            local eggList = EGG_LIST or {}
            if table.find(eggList, baseName) then return "Eggs" end
            
            local packList = PACK_LIST or {}
            if table.find(packList, baseName) then return "Eggs" end
            
            local propList = PROP_LIST or {}
            if table.find(propList, baseName) then return "Props" end
            
            local ln = string.lower(baseName)
            if string.find(ln, "seed") then return "Seeds" end
            if string.find(ln, "sprinkler") or string.find(ln, "watering can") or string.find(ln, "trowel") or string.find(ln, "shovel") or string.find(ln, "mushroom") or string.find(ln, "build") or string.find(ln, "axe") or string.find(ln, "gear") then return "Tools" end
            if string.find(ln, "egg") or string.find(ln, "crate") or string.find(ln, "box") or string.find(ln, "pack") then return "Eggs" end
            if string.find(ln, "prop") or string.find(ln, "ladder") or string.find(ln, "radio") or string.find(ln, "sign") then return "Props" end
            if string.find(ln, "pet") or string.find(ln, "serpent") or string.find(ln, "unicorn") or string.find(ln, "deer") or string.find(ln, "bee") or string.find(ln, "fox") or string.find(ln, "dragon") or string.find(ln, "bunny") then return "Pets" end
            
            return "Fruits"
        end

        local function processContainer(container, useDescendants)
            local items = useDescendants and container:GetDescendants() or container:GetChildren()
            for _, item in ipairs(items) do
                local isFruitConfig = item:IsA("Configuration") and (item:GetAttribute("HarvestedFruit") == true)
                if item:IsA("Tool") or isFruitConfig then
                    local bName = item.Name
                    if item:GetAttribute("SeedTool") and not string.match(string.lower(bName), "seed") then
                        bName = bName .. " Seed"
                    end
                    local amt = item:GetAttribute("Amount") or item:GetAttribute("Count") or item:GetAttribute("Stock")
                    if type(amt) ~= "number" or amt <= 0 then amt = 1 end
                    local isFav = item:GetAttribute("IsFavorite") == true
                    local cat = determineCat(bName, isFruitConfig, item)
                    
                    if inventoryCounts[bName] then
                        inventoryCounts[bName].amount = inventoryCounts[bName].amount + amt
                        inventoryCounts[bName].isFav = inventoryCounts[bName].isFav or isFav
                    else
                        inventoryCounts[bName] = { amount = amt, isFav = isFav, category = cat }
                    end
                end
            end
        end
        
        if LocalPlayer:FindFirstChild("Backpack") then processContainer(LocalPlayer.Backpack, false) end
        if LocalPlayer.Character then processContainer(LocalPlayer.Character, true) end
        
        -- Try to grab props and eggs from internal inventory
        pcall(function()
            local pStateClient = require(game:GetService("ReplicatedStorage").ClientModules.PlayerStateClient)
            local replica = pStateClient:GetLocalReplica()
            if replica and replica.Data and replica.Data.Inventory then
                if replica.Data.Inventory.Props then
                    for pName, pCount in pairs(replica.Data.Inventory.Props) do
                        if type(pCount) == "number" and pCount > 0 then
                            if inventoryCounts[pName] then
                                inventoryCounts[pName].amount = inventoryCounts[pName].amount + pCount
                            else
                                inventoryCounts[pName] = { amount = pCount, isFav = false, category = determineCat(pName, false, nil) }
                            end
                        end
                    end
                end
                if replica.Data.Inventory.Eggs then
                    for eName, eCount in pairs(replica.Data.Inventory.Eggs) do
                        if type(eCount) == "number" and eCount > 0 then
                            if inventoryCounts[eName] then
                                inventoryCounts[eName].amount = inventoryCounts[eName].amount + eCount
                            else
                                inventoryCounts[eName] = { amount = eCount, isFav = false, category = determineCat(eName, false, nil) }
                            end
                        end
                    end
                end
            end
        end)
        
        local result = {}
        for name, data in pairs(inventoryCounts) do
            table.insert(result, { name = name, amount = data.amount, isFav = data.isFav, category = data.category })
        end
        
        local shecklesAmount = 0
        pcall(function()
            if LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Sheckles") then
                shecklesAmount = LocalPlayer.leaderstats.Sheckles.Value
            end
            local pStateClient = require(game:GetService("ReplicatedStorage").ClientModules.PlayerStateClient)
            local replica = pStateClient:GetLocalReplica()
            if replica and replica.Data then
                if replica.Data.Sheckles then shecklesAmount = replica.Data.Sheckles end
                if replica.Data.Currencies and replica.Data.Currencies.Sheckles then shecklesAmount = replica.Data.Currencies.Sheckles end
            end
        end)
        table.insert(result, { name = "Sheckles", amount = shecklesAmount, isFav = false, category = "Currency" })
        
        return result
    end

    local function serializeUIState()
        for _, cat in ipairs(_G.WebUISchema or {}) do
            for _, item in ipairs(cat.items) do
                local handler = _G.WebUIHandlers[item.id]
                if handler then
                    item.value = handler.val
                end
            end
        end
        return _G.WebUISchema or {}
    end

    local function processCommands(commands)
        if type(commands) ~= "table" then return end
        for _, cmd in ipairs(commands) do
            local handler = _G.WebUIHandlers[cmd.configKey]
            if handler then
                if cmd.action == "SET_TOGGLE" and handler.type == "toggle" then
                    pcall(function() handler.obj:Set(cmd.value) end)
                elseif cmd.action == "SET_DROPDOWN" and handler.type == "dropdown" then
                    pcall(function() handler.obj:Set(cmd.value) end)
                elseif cmd.action == "SET_INPUT" and handler.type == "input" then
                    pcall(function() handler.obj:Set(cmd.value) end)
                elseif cmd.action == "BUTTON_CLICK" and handler.type == "button" then
                    if handler.cb then pcall(function() handler.cb(true) end) end
                end
            end
        end
    end

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

end)() -- scope reset           