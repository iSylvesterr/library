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
                .. "?script=Jump-To-Steal"
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
    Footer = "Jump Soccer",
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
    AutoCollectSlime = false,
    CollectSlimeRarities = {"None"},
    AutoPlaceOpenBlock = false,
    PlaceOpenBlockRarities = {"None"},
    AutoUpgradeSlime = false,
    AutoCollectEarnings = false,
    AutoGiftTarget = "None",
    AutoPickupPlayers = false,
    AutoGift = false,
    AutoGiftItems = {"None"},
    AutoRebirth = false,
    AutoSpeed = false,
    AntiAFK = false,
    LoopFriendBoost = false,
    AutoSell = false,
    AutoSellItems = {"None"},
}

-- ============================================================
-- ANTI-SPAM NOTIFICATION HOOK
-- ============================================================
task.spawn(function()
    pcall(function()
        local Shared = game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Shared")
        local Lib = require(Shared)
        if Lib and Lib.Signal and type(Lib.Signal.Fire) == "function" then
            local origFire = Lib.Signal.Fire
            Lib.Signal.Fire = function(self, name, text, ...)
                if name == "Send Notification" and text == "You need more money." and Config.AutoUpgradeSlime then
                    return -- Silently drop the notification to prevent spam
                end
                return origFire(self, name, text, ...)
            end
        end
    end)
end)


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
-- AUTO PICK UP PLAYERS LOGIC
-- ============================================================
local function AutoPickupLoop()
    local localPlayer = game:GetService("Players").LocalPlayer
    local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Network"):WaitForChild("Remotes")
    local PickupEvent = Remotes:WaitForChild("Pickup Slime")
    
    while Config.AutoPickupPlayers do
        task.wait(1)
        local live = workspace:FindFirstChild("Live")
        if not live then continue end
        local playerSlimes = live:FindFirstChild("PlayerSlimes")
        if not playerSlimes then continue end
        local mySlimes = playerSlimes:FindFirstChild(localPlayer.Name)
        if not mySlimes then continue end
        
        for _, stand in ipairs(mySlimes:GetChildren()) do
            if not Config.AutoPickupPlayers then break end
            pcall(function()
                PickupEvent:FireServer(stand.Name)
            end)
            task.wait(0.1)
        end
    end
end

-- ============================================================
-- AUTO COLLECT SLIME LOGIC
-- ============================================================
local function AutoCollectSlimeLoop()
    local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Network"):WaitForChild("Remotes")
    local HoldSlimeEvent = Remotes:WaitForChild("Holding Slime")
    local PlayAnimEvent = Remotes:WaitForChild("Play Hold Animation")
    
    while Config.AutoCollectSlime do
        task.wait(0.1)
        local slimesFolder = workspace:FindFirstChild("Live") and workspace.Live:FindFirstChild("Slimes")
        if not slimesFolder then continue end
        
        local localPlayer = game:GetService("Players").LocalPlayer
        local character = localPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then continue end
        
        for _, slime in ipairs(slimesFolder:GetChildren()) do
            if not Config.AutoCollectSlime then break end
            
            -- Check Rarity
            local rarityAttr = slime:GetAttribute("_Rarity") or slime:GetAttribute("Rarity")
            local rarityStr = tostring(rarityAttr or "")
            
            local shouldCollect = false
            if table.find(Config.CollectSlimeRarities, rarityStr) or table.find(Config.CollectSlimeRarities, "All") then
                shouldCollect = true
            elseif rarityAttr == nil then
                for _, r in ipairs(Config.CollectSlimeRarities) do
                    if string.match(slime.Name, r) then
                        shouldCollect = true
                        break
                    end
                end
            end
            
            if shouldCollect then
                local slimeId = slime:GetAttribute("_RegisteredID") or slime:GetAttribute("Id") or slime:GetAttribute("ID") or slime.Name
                local targetPart = slime.PrimaryPart or slime:FindFirstChildWhichIsA("BasePart")
                
                if targetPart then
                    -- Teleport to slime
                    character.HumanoidRootPart.CFrame = targetPart.CFrame
                    
                    -- IMPORTANT: Wait for position to replicate to server so distance checks pass
                    task.wait(0.4)
                    
                    -- Check for Proximity Prompt
                    local prompt = slime:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt and fireproximityprompt then
                        fireproximityprompt(prompt)
                    end
                    
                    -- Fire Touch Interest
                    if firetouchinterest then
                        firetouchinterest(character.HumanoidRootPart, targetPart, 0)
                        task.wait()
                        firetouchinterest(character.HumanoidRootPart, targetPart, 1)
                    end
                end
                
                -- Also fire the local signals as requested to sync UI animations just in case
                pcall(function()
                    if firesignal then
                        firesignal(PlayAnimEvent.OnClientEvent, tostring(slimeId))
                        firesignal(HoldSlimeEvent.OnClientEvent, true, {
                            capacity = 1,
                            count = 1
                        })
                    end
                end)
                
                -- Wait for pickup to process fully
                task.wait(0.5)
                
                -- Teleport back to base carpet to complete the collection
                pcall(function()
                    local returnDest = nil
                    
                    -- Iterate through all Plots to find the one owned by the LocalPlayer
                    local plotsFolder = workspace:FindFirstChild("Plots")
                    if plotsFolder then
                        for _, plot in ipairs(plotsFolder:GetChildren()) do
                            local ownerVal = plot:FindFirstChild("owner")
                            if ownerVal and ownerVal:IsA("StringValue") and ownerVal.Value == localPlayer.Name then
                                if plot:FindFirstChild("MainBase") and plot.MainBase:FindFirstChild("Carpet") then
                                    local carpetChildren = plot.MainBase.Carpet:GetChildren()
                                    if #carpetChildren >= 2 then
                                        returnDest = carpetChildren[2]
                                    else
                                        returnDest = plot.MainBase.Carpet:FindFirstChildWhichIsA("BasePart")
                                    end
                                end
                                break
                            end
                        end
                    end
                    
                    -- Fallback to the specific BasePos4 if somehow not found
                    if not returnDest and plotsFolder and plotsFolder:FindFirstChild("BasePos4") then
                        local fallbackPlot = plotsFolder.BasePos4
                        if fallbackPlot:FindFirstChild("MainBase") and fallbackPlot.MainBase:FindFirstChild("Carpet") then
                            returnDest = fallbackPlot.MainBase.Carpet:GetChildren()[2]
                        end
                    end
                    
                    if returnDest and character:FindFirstChild("HumanoidRootPart") then
                        -- Optional: get a CFrame if returnDest is a BasePart
                        if returnDest:IsA("BasePart") then
                            character.HumanoidRootPart.CFrame = returnDest.CFrame * CFrame.new(0, 3, 0)
                        else
                            character.HumanoidRootPart.CFrame = returnDest.CFrame
                        end
                    end
                end)
                
                -- Fire signal to stop the holding animation so the character doesn't get stuck
                pcall(function()
                    if firesignal then
                        firesignal(HoldSlimeEvent.OnClientEvent, false, {
                            capacity = 1,
                            count = 0
                        })
                    end
                end)
                
                -- Wait a moment for server to process before looping again
                task.wait(0.5)
            end
        end
    end
end

-- ============================================================
-- AUTO PLACE & OPEN LUCKY BLOCK LOGIC
-- ============================================================
local function AutoPlaceOpenBlockLoop()
    local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Network"):WaitForChild("Remotes")
    local PlaceSlimeEvent = Remotes:WaitForChild("Place Slime")
    local OpenBlockEvent = Remotes:WaitForChild("Open Lucky Block")
    
    local currentStandIndex = 1
    
    while Config.AutoPlaceOpenBlock do
        task.wait(0.1)
        local localPlayer = game:GetService("Players").LocalPlayer
        local backpack = localPlayer:FindFirstChild("Backpack")
        local character = localPlayer.Character
        if not backpack or not character or not character:FindFirstChild("HumanoidRootPart") then continue end
        
        -- Get the stands folder for the player
        local plotsFolder = workspace:FindFirstChild("Plots")
        local standsFolder = nil
        
        if plotsFolder then
            for _, plot in ipairs(plotsFolder:GetChildren()) do
                local ownerVal = plot:FindFirstChild("owner")
                if ownerVal and ownerVal:IsA("StringValue") and ownerVal.Value == localPlayer.Name then
                    standsFolder = plot:FindFirstChild("Stands")
                    break
                end
            end
        end
        
        -- Fallback
        if not standsFolder and plotsFolder and plotsFolder:FindFirstChild("BasePos4") then
            standsFolder = plotsFolder.BasePos4:FindFirstChild("Stands")
        end
        
        -- Gather all tools from Backpack and Character (in case one is already equipped)
        local allTools = {}
        if backpack then
            for _, t in ipairs(backpack:GetChildren()) do
                if t:IsA("Tool") then table.insert(allTools, t) end
            end
        end
        if character then
            for _, t in ipairs(character:GetChildren()) do
                if t:IsA("Tool") then table.insert(allTools, t) end
            end
        end
        
        for _, tool in ipairs(allTools) do
            if not Config.AutoPlaceOpenBlock then break end
            
            -- Try to determine if it's a lucky block and get its rarity
            local rarityAttr = tool:GetAttribute("_Rarity") or tool:GetAttribute("Rarity") or tool:GetAttribute("rarity")
            local rarityStr = tostring(rarityAttr or "")
            
            local shouldProcess = false
            if table.find(Config.PlaceOpenBlockRarities, rarityStr) or table.find(Config.PlaceOpenBlockRarities, "All") then
                shouldProcess = true
            elseif rarityAttr == nil then
                -- Fallback check by name or tooltip
                for _, r in ipairs(Config.PlaceOpenBlockRarities) do
                    if string.match(tool.Name, r) or (tool.ToolTip and string.match(tool.ToolTip, r)) then
                        shouldProcess = true
                        break
                    end
                end
            end
            
            if shouldProcess then
                -- 1. Explicitly check for 'slimeuid' as the user noted
                local uuid = tool:GetAttribute("slimeuid") or tool:GetAttribute("slimeUid")
                
                local uuidPattern = "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$"
                
                -- 2. Check Tool Name
                if not uuid and string.match(tool.Name, uuidPattern) then
                    uuid = tool.Name
                end
                
                -- 3. Check Attributes
                if not uuid then
                    for k, v in pairs(tool:GetAttributes()) do
                        if type(v) == "string" and string.match(v, uuidPattern) then
                            uuid = v
                            break
                        end
                    end
                end
                
                -- 4. Check StringValue Children
                if not uuid then
                    for _, child in ipairs(tool:GetChildren()) do
                        if child:IsA("StringValue") and string.match(child.Value, uuidPattern) then
                            uuid = child.Value
                            break
                        end
                    end
                end
                
                -- 5. Fallback to common names if the format is somehow non-standard
                if not uuid then
                    uuid = tool:GetAttribute("uid") or tool:GetAttribute("uuid") or tool:GetAttribute("UUID") or tool.Name
                end
                
                -- Helper to check if a stand is occupied
                local function isStandOccupied(standNumStr)
                    local live = workspace:FindFirstChild("Live")
                    if live then
                        local playerSlimes = live:FindFirstChild("PlayerSlimes")
                        if playerSlimes then
                            local mySlimes = playerSlimes:FindFirstChild(localPlayer.Name)
                            if mySlimes and mySlimes:FindFirstChild(standNumStr) then
                                return true
                            end
                        end
                    end
                    return false
                end
                
                -- Helper to find a specific prompt in the stand
                local function findPrompt(stand, promptName)
                    if stand then
                        local main = stand:FindFirstChild("Main")
                        if main then
                            local holder = main:FindFirstChild("Holder")
                            if holder then
                                local targetPart = holder:FindFirstChild(promptName)
                                if targetPart then
                                    return targetPart:FindFirstChildWhichIsA("ProximityPrompt", true)
                                end
                            end
                        end
                    end
                    return nil
                end
                
                -- Equip the Tool first so Place prompts update locally
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid:EquipTool(tool)
                    task.wait(0.1) -- Wait for local scripts to enable the Place prompt on empty stands
                end
                
                local standIdStr = nil
                local foundStand = nil
                
                if standsFolder then
                    local startSearch = currentStandIndex
                    local looped = false
                    
                    while true do
                        local testStr = tostring(currentStandIndex)
                        local testStand = standsFolder:FindFirstChild(testStr)
                        
                        -- If stand doesn't exist (e.g. we reached the end of unlocked stands), reset to 1
                        if not testStand then
                            if looped then break end -- Prevent infinite loop if NO stands exist
                            currentStandIndex = 1
                            looped = true
                            continue
                        end
                        
                        -- Verify it's purchased and empty
                        if testStand:FindFirstChild("Main") and not isStandOccupied(testStr) then
                            local placeP = findPrompt(testStand, "Place")
                            -- If Place prompt is enabled, it's 100% empty!
                            -- Or if it's disabled but we know it's not occupied, it might just be lag, so we try anyway
                            if (placeP and placeP.Enabled) or not placeP then
                                standIdStr = testStr
                                foundStand = testStand
                                break
                            elseif placeP and not placeP.Enabled then
                                -- The prompt exists but is disabled even though we hold a slime, meaning it's occupied by something else (like an unopened lucky block)
                            end
                        end
                        
                        -- Otherwise, check the next one
                        currentStandIndex = currentStandIndex + 1
                        if looped and currentStandIndex > startSearch then
                            break -- We checked every stand and ALL are occupied
                        end
                    end
                end
                
                -- If we couldn't find an empty stand, disable the auto place toggle automatically
                if not foundStand then
                    Config.AutoPlaceOpenBlock = false
                    break
                end
                
                -- NOTE: Teleportation removed to allow placing from far away!
                -- If it fails from far away, the Remotes or fireproximityprompt will bypass or fail gracefully.
                -- Helper to find a specific prompt in the stand
                local function findPrompt(stand, promptName)
                    if stand then
                        local main = stand:FindFirstChild("Main")
                        if main then
                            local holder = main:FindFirstChild("Holder")
                            if holder then
                                local targetPart = holder:FindFirstChild(promptName)
                                if targetPart then
                                    return targetPart:FindFirstChildWhichIsA("ProximityPrompt", true)
                                end
                            end
                        end
                    end
                    return nil
                end
                
                -- Place it using the physical Prompt (safest way to bypass remote arg issues!)
                local placePrompt = findPrompt(foundStand, "Place")
                if placePrompt and fireproximityprompt then
                    placePrompt.Enabled = true -- Force enable it in case the local script hasn't updated it yet
                    fireproximityprompt(placePrompt)
                end
                
                -- Unconditional fallback to remote just in case
                pcall(function()
                    PlaceSlimeEvent:FireServer(standIdStr, uuid)
                end)
                
                -- Wait for the server to process the place and for the OPEN prompt to enable
                task.wait(0.15)
                
                -- Open it using the physical Prompt (The Sell prompt acts as OPEN for Lucky Blocks)
                local openPrompt = findPrompt(foundStand, "Sell")
                if openPrompt and fireproximityprompt then
                    openPrompt.Enabled = true
                    fireproximityprompt(openPrompt)
                end
                
                -- Unconditional fallback
                pcall(function()
                    OpenBlockEvent:FireServer(standIdStr)
                end)
                
                -- Wait for animation/server response before doing the next one
                task.wait(0.15)
                
                -- Move to the next stand for the next block
                currentStandIndex = currentStandIndex + 1
            end
        end
    end
end

-- ============================================================
-- AUTO UPGRADE SLIME LOGIC
-- ============================================================
local function AutoUpgradeSlimeLoop()
    local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Network"):WaitForChild("Remotes")
    local UpgradeEvent = Remotes:WaitForChild("Upgrade Slime")
    
    local function isStandOccupied(localPlayer, standNumStr)
        local live = workspace:FindFirstChild("Live")
        if live then
            local playerSlimes = live:FindFirstChild("PlayerSlimes")
            if playerSlimes then
                local mySlimes = playerSlimes:FindFirstChild(localPlayer.Name)
                if mySlimes and mySlimes:FindFirstChild(standNumStr) then
                    return true
                end
            end
        end
        return false
    end
    
    local function getIncome(localPlayer, standNumStr, stand)
        local income = 0
        local function extractIncome(text)
            text = tostring(text):lower()
            if string.match(text, "/s") then
                text = string.gsub(text, "<[^>]+>", "")
                local numStr = string.match(text, "([%d%.%,]+)")
                if numStr then
                    numStr = string.gsub(numStr, ",", "")
                    local num = tonumber(numStr)
                    if num then
                        if string.match(text, "k%s*/s") then num = num * 1000
                        elseif string.match(text, "m%s*/s") then num = num * 1000000
                        elseif string.match(text, "b%s*/s") then num = num * 1000000000
                        elseif string.match(text, "t%s*/s") then num = num * 1000000000000
                        end
                        if num > income then income = num end
                    end
                end
            end
        end
        
        if stand then
            for _, desc in ipairs(stand:GetDescendants()) do
                if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
                    extractIncome(desc.Text)
                end
            end
        end
        
        local live = workspace:FindFirstChild("Live")
        if live then
            local playerSlimes = live:FindFirstChild("PlayerSlimes")
            if playerSlimes then
                local mySlimes = playerSlimes:FindFirstChild(localPlayer.Name)
                if mySlimes then
                    local mySlime = mySlimes:FindFirstChild(standNumStr)
                    if mySlime then
                        for _, desc in ipairs(mySlime:GetDescendants()) do
                            if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
                                extractIncome(desc.Text)
                            end
                        end
                    end
                end
            end
        end
        return income
    end
    
    while Config.AutoUpgradeSlime do
        task.wait(5) -- Check once every 5 seconds to avoid lag
        local localPlayer = game:GetService("Players").LocalPlayer
        
        local plotsFolder = workspace:FindFirstChild("Plots")
        local standsFolder = nil
        
        if plotsFolder then
            for _, plot in ipairs(plotsFolder:GetChildren()) do
                local ownerVal = plot:FindFirstChild("owner")
                if ownerVal and ownerVal:IsA("StringValue") and ownerVal.Value == localPlayer.Name then
                    standsFolder = plot:FindFirstChild("Stands")
                    break
                end
            end
        end
        
        if not standsFolder and plotsFolder and plotsFolder:FindFirstChild("BasePos4") then
            standsFolder = plotsFolder.BasePos4:FindFirstChild("Stands")
        end
        
        if standsFolder then
            local validStands = {}
            for _, stand in ipairs(standsFolder:GetChildren()) do
                if not Config.AutoUpgradeSlime then break end
                local standStr = stand.Name
                
                -- Only attempt to upgrade if there's actually a slime sitting there
                if isStandOccupied(localPlayer, standStr) then
                    local inc = getIncome(localPlayer, standStr, stand)
                    table.insert(validStands, {standStr = standStr, income = inc})
                end
            end
            
            -- Sort by highest income first
            table.sort(validStands, function(a, b)
                return a.income > b.income
            end)
            
            for _, data in ipairs(validStands) do
                if not Config.AutoUpgradeSlime then break end
                pcall(function()
                    UpgradeEvent:FireServer(data.standStr)
                end)
                task.wait(0.05) -- Tiny delay between stands
            end
        end
    end
end

-- ============================================================
-- AUTO COLLECT EARNINGS LOGIC
-- ============================================================
local function AutoCollectEarningsLoop()
    local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Network"):WaitForChild("Remotes")
    local CollectEvent = Remotes:WaitForChild("Collect Earnings")
    
    local function isStandOccupied(localPlayer, standNumStr)
        local live = workspace:FindFirstChild("Live")
        if live then
            local playerSlimes = live:FindFirstChild("PlayerSlimes")
            if playerSlimes then
                local mySlimes = playerSlimes:FindFirstChild(localPlayer.Name)
                if mySlimes and mySlimes:FindFirstChild(standNumStr) then
                    return true
                end
            end
        end
        return false
    end
    
    while Config.AutoCollectEarnings do
        task.wait(0.1) -- Collect extremely fast to test if the server has a cooldown
        local localPlayer = game:GetService("Players").LocalPlayer
        
        local plotsFolder = workspace:FindFirstChild("Plots")
        local standsFolder = nil
        
        if plotsFolder then
            for _, plot in ipairs(plotsFolder:GetChildren()) do
                local ownerVal = plot:FindFirstChild("owner")
                if ownerVal and ownerVal:IsA("StringValue") and ownerVal.Value == localPlayer.Name then
                    standsFolder = plot:FindFirstChild("Stands")
                    break
                end
            end
        end
        
        if not standsFolder and plotsFolder and plotsFolder:FindFirstChild("BasePos4") then
            standsFolder = plotsFolder.BasePos4:FindFirstChild("Stands")
        end
        
        if standsFolder then
            for _, stand in ipairs(standsFolder:GetChildren()) do
                if not Config.AutoCollectEarnings then break end
                local standStr = stand.Name
                
                -- Only attempt to collect if there's actually a slime generating cash there
                if isStandOccupied(localPlayer, standStr) then
                    pcall(function()
                        CollectEvent:FireServer(standStr)
                    end)
                    task.wait(0.05) -- Tiny delay between stands
                end
            end
        end
    end
end

-- ============================================================
-- AUTO SELL LOGIC
-- ============================================================
local function AutoSellLoop()
    local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Network"):WaitForChild("Remotes")
    local SellEvent = Remotes:WaitForChild("Sell Slime From Inventory")
    
    while Config.AutoSell do
        task.wait(1)
        
        local localPlayer = game:GetService("Players").LocalPlayer
        local backpack = localPlayer:FindFirstChild("Backpack")
        if not backpack then continue end
        
        for _, tool in ipairs(backpack:GetChildren()) do
            if not Config.AutoSell then break end
            if tool:IsA("Tool") then
                local shouldProcess = false
                
                local rarityAttr = tool:GetAttribute("_Rarity") or tool:GetAttribute("Rarity") or tool:GetAttribute("rarity")
                local rarityStr = tostring(rarityAttr or "")
                
                if table.find(Config.AutoSellItems, "All") then
                    shouldProcess = true
                elseif table.find(Config.AutoSellItems, tool.Name) then
                    shouldProcess = true
                elseif table.find(Config.AutoSellItems, rarityStr) then
                    shouldProcess = true
                else
                    for _, r in ipairs(Config.AutoSellItems) do
                        if string.match(tool.Name, r) or (tool.ToolTip and string.match(tool.ToolTip, r)) then
                            shouldProcess = true
                            break
                        end
                    end
                end
                
                if shouldProcess then
                    local uuid = tool:GetAttribute("slimeuid") or tool:GetAttribute("slimeUid")
                    local uuidPattern = "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$"
                    if not uuid and string.match(tool.Name, uuidPattern) then uuid = tool.Name end
                    if not uuid then
                        for k, v in pairs(tool:GetAttributes()) do
                            if type(v) == "string" and string.match(v, uuidPattern) then
                                uuid = v
                                break
                            end
                        end
                    end
                    if not uuid then
                        for _, child in ipairs(tool:GetChildren()) do
                            if child:IsA("StringValue") and string.match(child.Value, uuidPattern) then
                                uuid = child.Value
                                break
                            end
                        end
                    end
                    if not uuid then
                        uuid = tool:GetAttribute("uid") or tool:GetAttribute("uuid") or tool:GetAttribute("UUID") or tool.Name
                    end
                    
                    pcall(function()
                        SellEvent:FireServer(uuid)
                    end)
                    task.wait(0.2)
                end
            end
        end
    end
end

-- ============================================================
-- AUTO GIFT LOGIC
-- ============================================================
local function AutoGiftLoop()
    local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Network"):WaitForChild("Remotes")
    local GiftEvent = Remotes:WaitForChild("Gift Slime")
    
    while Config.AutoGift do
        task.wait(1)
        
        local targetName = Config.AutoGiftTarget
        if not targetName or targetName == "" then continue end
        
        local localPlayer = game:GetService("Players").LocalPlayer
        local backpack = localPlayer:FindFirstChild("Backpack")
        local character = localPlayer.Character
        
        local allTools = {}
        if backpack then
            for _, t in ipairs(backpack:GetChildren()) do
                if t:IsA("Tool") then table.insert(allTools, t) end
            end
        end
        if character then
            for _, t in ipairs(character:GetChildren()) do
                if t:IsA("Tool") then table.insert(allTools, t) end
            end
        end
        
        for _, tool in ipairs(allTools) do
            if not Config.AutoGift then break end
            
            local shouldProcess = false
            if table.find(Config.AutoGiftItems, tool.Name) or table.find(Config.AutoGiftItems, "All") then
                shouldProcess = true
            end
            
            if shouldProcess then
                local uuid = tool:GetAttribute("slimeuid") or tool:GetAttribute("slimeUid")
                local uuidPattern = "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$"
                
                if not uuid and string.match(tool.Name, uuidPattern) then uuid = tool.Name end
                
                if not uuid then
                    for k, v in pairs(tool:GetAttributes()) do
                        if type(v) == "string" and string.match(v, uuidPattern) then
                            uuid = v
                            break
                        end
                    end
                end
                
                if not uuid then
                    for _, child in ipairs(tool:GetChildren()) do
                        if child:IsA("StringValue") and string.match(child.Value, uuidPattern) then
                            uuid = child.Value
                            break
                        end
                    end
                end
                
                if not uuid then
                    uuid = tool:GetAttribute("uid") or tool:GetAttribute("uuid") or tool:GetAttribute("UUID") or tool.Name
                end
                
                pcall(function()
                    GiftEvent:InvokeServer(targetName, uuid)
                end)
                task.wait(0.5) -- Delay between gifts to avoid rate limits/spam
            end
        end
    end
end

-- ============================================================
-- AUTO REBIRTH & SPEED LOGIC
-- ============================================================
local function AutoRebirthLoop()
    local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Network"):WaitForChild("Remotes")
    local RebirthEvent = Remotes:WaitForChild("Rebirth")
    
    while Config.AutoRebirth do
        task.wait(2) -- Check rebirth requirement every 2 seconds
        pcall(function()
            RebirthEvent:FireServer()
        end)
    end
end

local function AutoSpeedLoop()
    local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Network"):WaitForChild("Remotes")
    local SpeedEvent = Remotes:WaitForChild("Buy Speed Upgrade")
    
    while Config.AutoSpeed do
        task.wait(0.5) -- Spam speed buy 
        pcall(function()
            SpeedEvent:FireServer(3)
        end)
    end
end

-- ============================================================
-- 1. TAB MAIN
-- ============================================================
local function LoadMainTab()
    local MainTab = Tabs:AddTab({ Name = "Main", Icon = "rbxassetid://10723396652" })

    local FarmSection = MainTab:AddSection("Farm")

    FarmSection:AddToggle({
        Title = "Auto Collect Lucky Block",
        Content = "Automatically collect based on rarity",
        Default = false,
        Callback = function(val)
            Config.AutoCollectSlime = val
            if val then
                task.spawn(AutoCollectSlimeLoop)
            end
        end
    })

    local rarityDrop
    rarityDrop = FarmSection:AddDropdown({
        Title = "Filter By Rarity",
        Content = "Select rarities to pick up",
        Options = {
            "None", "All", "Common", "Rare", "Epic", "Legendary", "Mythic", "Secret", "Slime God", "Exclusive", "OG", "Champions", "Spain", "Divine", "Icons"
        },
        Default = {"None"},
        Multi = true,
        Callback = function(val)
            Config.CollectSlimeRarities = handleDropdownChange(val, rarityDrop)
        end
    })
end

-- ============================================================
-- 2. TAB AUTO
-- ============================================================
local function LoadAutoTab()
    local AutoTab = Tabs:AddTab({ Name = "Auto", Icon = "rbxassetid://10723415903" })

    local AutoCollectCashSection = AutoTab:AddSection("Auto Collect Cash")

    AutoCollectCashSection:AddToggle({
        Title = "Auto Collect Earnings",
        Content = "Automatically harvest cash from all soccer players",
        Default = false,
        Callback = function(val)
            Config.AutoCollectEarnings = val
            if val then
                task.spawn(AutoCollectEarningsLoop)
            end
        end
    })

    local AutoPlaceOpenSection = AutoTab:AddSection("Auto Place & Open")
    
    AutoPlaceOpenSection:AddToggle({
        Title = "Auto Place & Open Lucky Block",
        Content = "Automatically place and open blocks from backpack",
        Default = false,
        Callback = function(val)
            Config.AutoPlaceOpenBlock = val
            if val then
                task.spawn(AutoPlaceOpenBlockLoop)
            end
        end
    })
    
    local placeOpenRarityDrop
    placeOpenRarityDrop = AutoPlaceOpenSection:AddDropdown({
        Title = "Filter By Rarity",
        Content = "Select rarities to auto place & open",
        Options = {
            "None", "All", "Common", "Rare", "Epic", "Legendary", "Mythic", "Secret", "Slime God", "Exclusive", "OG", "Champions", "Spain", "Icons"
        },
        Default = {"None"},
        Multi = true,
        Callback = function(val)
            Config.PlaceOpenBlockRarities = handleDropdownChange(val, placeOpenRarityDrop)
        end
    })
    
    AutoPlaceOpenSection:AddToggle({
        Title = "Auto Pick Up All Soccer Players",
        Content = "Automatically clears your plot by picking up all placed soccer players",
        Default = false,
        Callback = function(val)
            Config.AutoPickupPlayers = val
            if val then
                task.spawn(AutoPickupLoop)
            end
        end
    })
    
    AutoPlaceOpenSection:AddButton({
        Title = "Pick Up All Players NOW",
        Callback = function()
            local localPlayer = game:GetService("Players").LocalPlayer
            local live = workspace:FindFirstChild("Live")
            if live and live:FindFirstChild("PlayerSlimes") then
                local mySlimes = live.PlayerSlimes:FindFirstChild(localPlayer.Name)
                if mySlimes then
                    local Event = game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Network"):WaitForChild("Remotes"):FindFirstChild("Pickup Slime")
                    if Event then
                        for _, stand in ipairs(mySlimes:GetChildren()) do
                            pcall(function()
                                Event:FireServer(stand.Name)
                            end)
                            task.wait(0.05)
                        end
                    end
                end
            end
        end
    })
    
    local AutoUpgradeSection = AutoTab:AddSection("Auto Upgrade")
    
    AutoUpgradeSection:AddToggle({
        Title = "Auto Upgrade Soccer Players",
        Content = "Automatically max out all placed soccer players",
        Default = false,
        Callback = function(val)
            Config.AutoUpgradeSlime = val
            if val then
                task.spawn(AutoUpgradeSlimeLoop)
            end
        end
    })

    local AutoPlayerProgressionSection = AutoTab:AddSection("Player Progression")
    
    AutoPlayerProgressionSection:AddToggle({
        Title = "Auto Buy Speed Upgrade",
        Content = "Spams the speed upgrade purchase",
        Default = false,
        Callback = function(val)
            Config.AutoSpeed = val
            if val then
                task.spawn(AutoSpeedLoop)
            end
        end
    })
    
    AutoPlayerProgressionSection:AddToggle({
        Title = "Auto Rebirth",
        Content = "Automatically rebirths when speed requirement is met",
        Default = false,
        Callback = function(val)
            Config.AutoRebirth = val
            if val then
                task.spawn(AutoRebirthLoop)
            end
        end
    })
    
    local AutoSellSection = AutoTab:AddSection("Auto Sell")
    
    local function getSellItems()
        local list = { "None", "All", "Common", "Rare", "Epic", "Legendary", "Mythic", "Secret", "Slime God", "Exclusive", "LIMITED", "OG", "Champions", "Spain", "Divine", "Icons" }
        local localPlayer = game:GetService("Players").LocalPlayer
        local backpack = localPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, t in ipairs(backpack:GetChildren()) do
                if t:IsA("Tool") then
                    if not table.find(list, t.Name) then
                        table.insert(list, t.Name)
                    end
                end
            end
        end
        return list
    end
    
    local autoSellDrop
    autoSellDrop = AutoSellSection:AddDropdown({
        Title = "Filter By Rarity/Item",
        Content = "Select rarities to auto sell from Backpack",
        Options = getSellItems(),
        Default = {"None"},
        Multi = true,
        Callback = function(val)
            Config.AutoSellItems = handleDropdownChange(val, autoSellDrop)
        end
    })
    
    AutoSellSection:AddButton({
        Title = "Refresh Sell List",
        Callback = function()
            local newList = getSellItems()
            pcall(function() autoSellDrop:SetValues(newList, Config.AutoSellItems or {"None"}) end)
        end
    })
    
    AutoSellSection:AddToggle({
        Title = "Auto Sell From Backpack",
        Content = "Automatically sell selected items",
        Default = false,
        Callback = function(val)
            Config.AutoSell = val
            if val then
                task.spawn(AutoSellLoop)
            end
        end
    })
end

-- ============================================================
-- 3. TAB TRADE
-- ============================================================
local function LoadTradeTab()
    local TradeTab = Tabs:AddTab({ Name = "Trade", Icon = "rbxassetid://10723415903" })

    local AutoGiftSection = TradeTab:AddSection("Auto Gift")

    local function getPlayersList()
        local list = {}
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            if p ~= game:GetService("Players").LocalPlayer then
                table.insert(list, p.Name)
            end
        end
        if #list == 0 then table.insert(list, "None") end
        return list
    end

    local function getBackpackItems()
        local list = {}
        local localPlayer = game:GetService("Players").LocalPlayer
        local backpack = localPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, t in ipairs(backpack:GetChildren()) do
                if t:IsA("Tool") then
                    if not table.find(list, t.Name) then
                        table.insert(list, t.Name)
                    end
                end
            end
        end
        if #list > 0 and not table.find(list, "None") then table.insert(list, 1, "All") end
        if #list == 0 then table.insert(list, "None") end
        return list
    end

    local targetDrop
    targetDrop = AutoGiftSection:AddDropdown({
        Title = "Target Player",
        Content = "Select player to gift",
        Options = getPlayersList(),
        Default = "None",
        Multi = false,
        Callback = function(val)
            Config.AutoGiftTarget = tostring(val)
        end
    })

    AutoGiftSection:AddButton({
        Title = "Refresh Player List",
        Callback = function()
            local newList = getPlayersList()
            pcall(function() targetDrop:SetValues(newList, Config.AutoGiftTarget or "None") end)
        end
    })

    local itemDrop
    itemDrop = AutoGiftSection:AddDropdown({
        Title = "Select Items to Gift",
        Content = "Choose from current inventory",
        Options = getBackpackItems(),
        Default = {"None"},
        Multi = true,
        Callback = function(val)
            Config.AutoGiftItems = handleDropdownChange(val, itemDrop)
        end
    })

    AutoGiftSection:AddButton({
        Title = "Refresh Item List",
        Callback = function()
            local newList = getBackpackItems()
            pcall(function() itemDrop:SetValues(newList, Config.AutoGiftItems or {"None"}) end)
        end
    })

    AutoGiftSection:AddToggle({
        Title = "Auto Gift Items",
        Content = "Automatically send selected items",
        Default = false,
        Callback = function(val)
            Config.AutoGift = val
            if val then
                task.spawn(AutoGiftLoop)
            end
        end
    })
end

-- ============================================================
-- 4. TAB MISC
-- ============================================================
local function LoadMiscTab()
    local MiscTab = Tabs:AddTab({ Name = "Misc", Icon = "rbxassetid://10734949856" })
    
    local ServerSection = MiscTab:AddSection("Server")
    
    local antiAfkConnection
    ServerSection:AddToggle({
        Title = "Anti AFK",
        Content = "Prevents the 20-minute idle disconnect",
        Default = false,
        Callback = function(val)
            Config.AntiAFK = val
            if val and not antiAfkConnection then
                local VirtualUser = game:GetService("VirtualUser")
                antiAfkConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                    if Config.AntiAFK then
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end
                end)
            end
        end
    })
end

-- Load all tabs
LoadMainTab()
task.wait(0.05)
LoadAutoTab()
task.wait(0.05)
LoadTradeTab()
task.wait(0.05)
LoadMiscTab()
task.wait(0.05)
