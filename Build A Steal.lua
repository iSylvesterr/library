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
-- NAPOLEON | BUILD A STEAL (AUTO ROLL & SNAP BUY)
-- ============================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ProximityPromptService = game:GetService("ProximityPromptService")
local CoreGui = game:GetService("CoreGui")

_G.ScriptActive = true

-- ============================================================
-- LOAD NAPOLEON UI LIBRARY
-- ============================================================
local function LoadNapoleonUI()
    local url       = "https://raw.githubusercontent.com/Fdhlnn23/NapoleonUI/refs/heads/main/NPLN-UIv4.lua"
    local cacheName = "Napoleon_NewUI_cached.lua"
    local result = nil
    if isfile and readfile and isfile(cacheName) then
        pcall(function() result = readfile(cacheName) end)
    end
    if not result or result == "" or string.len(result) < 100 then
        for i = 1, 3 do
            local ok, res = pcall(function() return game:HttpGet(url) end)
            if ok and res and string.len(res) > 100 and not string.match(res, "404: Not Found") then
                result = res
                if writefile then pcall(function() writefile(cacheName, result) end) end
                break
            end
            task.wait(1)
        end
    end
    if result and string.len(result) > 100 then
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
    warn("Gagal load NapoleonUI!")
    return
end

-- ============================================================
-- FETCH PET DATA & RARITIES
-- ============================================================
local PETS_LIST = {"None"}
local BLOCKS_LIST = {"None"}
local RARITY_LIST = {"None", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Godly", "Secret", "Divine", "Celestial", "OG"}
local MUTATION_LIST = {"None", "Non Mutation", "Normal", "Golden", "Inferno", "Cosmic", "Admin"}

pcall(function()
    local petsFolder = ReplicatedStorage:FindFirstChild("Pets")
    if petsFolder then
        for _, pet in ipairs(petsFolder:GetChildren()) do
            table.insert(PETS_LIST, pet.Name)
        end
    else
        local Chances = require(ReplicatedStorage:WaitForChild("Chances"))
        if Chances and Chances.Pets then
            for _, pData in ipairs(Chances.Pets) do
                table.insert(PETS_LIST, pData.Name)
            end
        end
    end
end)

pcall(function()
    local blocksFolder = ReplicatedStorage:FindFirstChild("Blocks")
    if blocksFolder then
        for _, block in ipairs(blocksFolder:GetChildren()) do
            table.insert(BLOCKS_LIST, block.Name)
        end
    else
        local Chances = require(ReplicatedStorage:WaitForChild("Chances"))
        if Chances and Chances.Blocks then
            for _, bData in ipairs(Chances.Blocks) do
                table.insert(BLOCKS_LIST, bData.Name)
            end
        end
    end
    
    local defFolder = ReplicatedStorage:FindFirstChild("Defenses")
    if defFolder then
        for _, def in ipairs(defFolder:GetChildren()) do
            table.insert(BLOCKS_LIST, def.Name)
        end
    else
        local Chances = require(ReplicatedStorage:WaitForChild("Chances"))
        if Chances and Chances.Defenses then
            for _, dData in ipairs(Chances.Defenses) do
                table.insert(BLOCKS_LIST, dData.Name)
            end
        end
    end
end)

local HatchUtils = nil
pcall(function()
    HatchUtils = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Services"):WaitForChild("PlotStationsService"):WaitForChild("HatchUtils"))
end)

local PetMath = nil
pcall(function()
    PetMath = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Services"):WaitForChild("PetService"):WaitForChild("PetMath"))
end)

local NumberShorten = nil
pcall(function()
    NumberShorten = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("NumberShorten"))
end)

local function getRarity(itemName)
    local rValue = "Unknown"
    local category = "Unknown"
    pcall(function()
        if HatchUtils and HatchUtils.resolveRarity then
            local ok, res = pcall(function() return HatchUtils.resolveRarity("Pets", itemName) end)
            if ok and res then 
                rValue = res 
                category = "Pets"
                return 
            end
            
            local ok2, res2 = pcall(function() return HatchUtils.resolveRarity("Blocks", itemName) end)
            if ok2 and res2 then
                rValue = res2
                category = "Blocks"
                return
            end
            
            local ok3, res3 = pcall(function() return HatchUtils.resolveRarity("Defenses", itemName) end)
            if ok3 and res3 then
                rValue = res3
                category = "Blocks" -- Treat defenses as blocks for auto-roll logic
                return
            end
        end
        
        local petsFolder = ReplicatedStorage:FindFirstChild("Pets")
        if petsFolder then
            local pet = petsFolder:FindFirstChild(itemName)
            if pet and pet:FindFirstChild("Rarity") then
                rValue = pet.Rarity.Value
                category = "Pets"
                return
            end
        end
        
        local blocksFolder = ReplicatedStorage:FindFirstChild("Blocks")
        if blocksFolder then
            local block = blocksFolder:FindFirstChild(itemName)
            if block and block:FindFirstChild("Rarity") then
                rValue = block.Rarity.Value
                category = "Blocks"
                return
            end
        end
        
        local defFolder = ReplicatedStorage:FindFirstChild("Defenses")
        if defFolder then
            local def = defFolder:FindFirstChild(itemName)
            if def and def:FindFirstChild("Rarity") then
                rValue = def.Rarity.Value
                category = "Blocks"
                return
            end
        end
    end)
    return rValue, category
end

-- ============================================================
-- CONFIG & HELPERS
-- ============================================================
_G.NapoleonAutoRoll = false

local Config = {
    AutoRoll       = false,
    TargetPet      = { ["None"] = true },
    TargetRarity   = { ["None"] = true },
    TargetMutation = { ["None"] = true },
    TargetBlock    = { ["None"] = true },
    TargetBlockRarity = { ["None"] = true },
    AutoRollPet    = false,
    AutoRollBlock  = false,
    AntiAFK        = true,
    AutoCollect    = false,
}

local targetPromptPet = nil
local targetPromptBlock = nil

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
        task.spawn(function()
            task.wait()
            pcall(function() dropObj:Set(arr) end)
        end)
    end
    
    local dict = {}
    for _, v in ipairs(arr) do dict[v] = true end
    return dict
end

local function hasSpecific(dict)
    for k, v in pairs(dict) do
        if k ~= "None" and v then return true end
    end
    return false
end

local function shouldSnapBuy(itemName, rarity, mutationName)
    local petActive      = hasSpecific(Config.TargetPet)
    local rarityActive   = hasSpecific(Config.TargetRarity)
    local mutationActive = hasSpecific(Config.TargetMutation)

    if not petActive and not rarityActive and not mutationActive then
        return false
    end

    local petOk      = (not petActive)      or (Config.TargetPet[itemName] == true)
    local rarityOk   = (not rarityActive)   or (Config.TargetRarity[rarity] == true)
    
    local mutationOk = false
    if not mutationActive then
        mutationOk = true
    else
        -- Jika tidak ada mutasi (nil, false, atau "None"), cek apakah user memilih "Non Mutation"
        if mutationName == "None" or mutationName == "false" or mutationName == "nil" or mutationName == "" or mutationName == false then
            mutationOk = (Config.TargetMutation["Non Mutation"] == true)
        else
            -- Jika bermutasi, cek apakah user memilih nama mutasi tersebut
            mutationOk = (Config.TargetMutation[mutationName] == true)
        end
    end

    return petOk and rarityOk and mutationOk
end

local function shouldSnapBuyBlock(itemName, rarity)
    local blockActive = hasSpecific(Config.TargetBlock)
    local rarityActive = hasSpecific(Config.TargetBlockRarity)
    
    if not blockActive and not rarityActive then
        return false
    end
    
    local blockOk = (not blockActive) or (Config.TargetBlock[itemName] == true)
    local rarityOk = (not rarityActive) or (Config.TargetBlockRarity[rarity] == true)
    
    return blockOk and rarityOk
end

local function notif(content, title)
    if Library and Library.MakeNotify then
        Library:MakeNotify({
            Title   = title or "Napoleon",
            Content = content or "",
            Delay   = 3,
            Icon    = "rbxassetid://136289055140268",
        })
    end
end

-- ============================================================
-- GACHA LOGS UI (Modern - Max 10 entries)
-- ============================================================
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local LogsGui = PlayerGui:FindFirstChild("GachaLogsUI")
if LogsGui then LogsGui:Destroy() end

LogsGui = Instance.new("ScreenGui")
LogsGui.Name = "GachaLogsUI"
LogsGui.ResetOnSpawn = false
LogsGui.IgnoreGuiInset = true
LogsGui.Parent = PlayerGui

local LogFrame = Instance.new("Frame")
LogFrame.Name = "LogFrame"
LogFrame.Size = UDim2.new(0, 260, 0, 390)
LogFrame.Position = UDim2.new(0.01, 0, 0.55, 0)
LogFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
LogFrame.BackgroundTransparency = 0.15
LogFrame.BorderSizePixel = 0
LogFrame.Active = true
LogFrame.Draggable = true
LogFrame.Visible = false
LogFrame.Parent = LogsGui

Instance.new("UICorner", LogFrame).CornerRadius = UDim.new(0, 12)

local LogStroke = Instance.new("UIStroke")
LogStroke.Color = Color3.fromRGB(100, 90, 220)
LogStroke.Thickness = 1.2
LogStroke.Transparency = 0.3
LogStroke.Parent = LogFrame

local LogHeader = Instance.new("Frame")
LogHeader.Size = UDim2.new(1, 0, 0, 34)
LogHeader.BackgroundColor3 = Color3.fromRGB(20, 18, 30)
LogHeader.BorderSizePixel = 0
LogHeader.Parent = LogFrame
Instance.new("UICorner", LogHeader).CornerRadius = UDim.new(0, 12)

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0.5, 0)
HeaderFix.Position = UDim2.new(0, 0, 0.5, 0)
HeaderFix.BackgroundColor3 = Color3.fromRGB(25, 20, 55)
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = LogHeader

local LogTitle = Instance.new("TextLabel")
LogTitle.Size = UDim2.new(1, -75, 1, 0)
LogTitle.Position = UDim2.new(0, 10, 0, 0)
LogTitle.BackgroundTransparency = 1
LogTitle.Text = "✨ Gacha Roll Log"
LogTitle.TextColor3 = Color3.fromRGB(220, 210, 255)
LogTitle.Font = Enum.Font.GothamBold
LogTitle.TextSize = 12
LogTitle.TextXAlignment = Enum.TextXAlignment.Left
LogTitle.Parent = LogHeader

local RollCountBadge = Instance.new("TextLabel")
RollCountBadge.Name = "RollCount"
RollCountBadge.Size = UDim2.new(0, 58, 0, 18)
RollCountBadge.Position = UDim2.new(1, -62, 0.5, -9)
RollCountBadge.BackgroundColor3 = Color3.fromRGB(81, 66, 255)
RollCountBadge.BackgroundTransparency = 0.3
RollCountBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
RollCountBadge.Font = Enum.Font.GothamBold
RollCountBadge.TextSize = 9
RollCountBadge.Text = "0 rolls"
RollCountBadge.Parent = LogHeader
Instance.new("UICorner", RollCountBadge).CornerRadius = UDim.new(0, 7)

local LogScroll = Instance.new("ScrollingFrame")
LogScroll.Size = UDim2.new(1, -12, 1, -42)
LogScroll.Position = UDim2.new(0, 6, 0, 38)
LogScroll.BackgroundTransparency = 1
LogScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
LogScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
LogScroll.ScrollBarThickness = 2
LogScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 80, 255)
LogScroll.ScrollingDirection = Enum.ScrollingDirection.Y
LogScroll.Parent = LogFrame

local LogListLayout = Instance.new("UIListLayout")
LogListLayout.Parent = LogScroll
LogListLayout.SortOrder = Enum.SortOrder.LayoutOrder
LogListLayout.Padding = UDim.new(0, 2)

local RARITY_COLORS = {
    Common    = Color3.fromRGB(180, 180, 180),
    Uncommon  = Color3.fromRGB(80, 220, 80),
    Rare      = Color3.fromRGB(60, 140, 255),
    Epic      = Color3.fromRGB(160, 60, 255),
    Legendary = Color3.fromRGB(255, 165, 0),
    Mythical  = Color3.fromRGB(255, 50, 100),
    Godly     = Color3.fromRGB(255, 50, 50),
    Secret    = Color3.fromRGB(255, 20, 200),
    Divine    = Color3.fromRGB(255, 210, 50),
    Celestial = Color3.fromRGB(100, 230, 255),
    Unknown   = Color3.fromRGB(150, 150, 150),
}

local MUTATION_COLORS = {
    ["Normal"]  = Color3.fromRGB(255, 255, 255),
    ["Golden"]  = Color3.fromRGB(255, 215, 0),
    ["Inferno"] = Color3.fromRGB(255, 50, 50),
    ["Cosmic"]  = Color3.fromRGB(138, 43, 226),
    ["Admin"]   = Color3.fromRGB(0, 255, 255),
}

local MAX_LOG_ENTRIES = 10
local totalRolls = 0

local LOG_SLOTS = {}
for i = 1, MAX_LOG_ENTRIES do
    local card = Instance.new("Frame")
    card.Name = "Slot" .. i
    card.LayoutOrder = i
    card.Size = UDim2.new(1, -2, 0, 32)
    card.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    card.BorderSizePixel = 0
    card.Visible = false
    card.Parent = LogScroll
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local gradient = Instance.new("UIGradient", card)
    gradient.Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1))
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.82),
        NumberSequenceKeypoint.new(1, 0.98)
    })

    local stroke = Instance.new("UIStroke", card)
    stroke.Color = Color3.fromRGB(50, 255, 120)
    stroke.Thickness = 1.2
    stroke.Transparency = 0.5
    stroke.Enabled = false

    local stripe = Instance.new("Frame", card)
    stripe.Name = "Stripe"
    stripe.Size = UDim2.new(0, 3, 1, -10)
    stripe.Position = UDim2.new(0, 6, 0, 5)
    stripe.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    stripe.BorderSizePixel = 0
    Instance.new("UICorner", stripe).CornerRadius = UDim.new(1, 0)

    local nameLbl = Instance.new("TextLabel", card)
    nameLbl.Size = UDim2.new(1, -90, 0, 16)
    nameLbl.Position = UDim2.new(0, 16, 0, 2)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 11
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    nameLbl.TextColor3 = Color3.fromRGB(245, 245, 255)
    nameLbl.Text = ""

    local rarityLbl = Instance.new("TextLabel", card)
    rarityLbl.Size = UDim2.new(0, 80, 0, 14)
    rarityLbl.Position = UDim2.new(0, 16, 0, 16)
    rarityLbl.BackgroundTransparency = 1
    rarityLbl.Font = Enum.Font.Gotham
    rarityLbl.TextSize = 10
    rarityLbl.TextXAlignment = Enum.TextXAlignment.Left
    rarityLbl.Text = ""

    local mutBadge = Instance.new("Frame", card)
    mutBadge.Size = UDim2.new(0, 50, 0, 12)
    mutBadge.Position = UDim2.new(0, 80, 0, 17)
    mutBadge.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mutBadge.BackgroundTransparency = 0.8
    Instance.new("UICorner", mutBadge).CornerRadius = UDim.new(0, 4)
    mutBadge.Visible = false

    local mutLbl = Instance.new("TextLabel", mutBadge)
    mutLbl.Size = UDim2.new(1, 0, 1, 0)
    mutLbl.BackgroundTransparency = 1
    mutLbl.Font = Enum.Font.GothamBold
    mutLbl.TextSize = 8
    mutLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    mutLbl.Text = ""

    local mpsLbl = Instance.new("TextLabel", card)
    mpsLbl.Size = UDim2.new(0, 75, 0, 16)
    mpsLbl.Position = UDim2.new(1, -85, 0.5, -8)
    mpsLbl.BackgroundTransparency = 1
    mpsLbl.Font = Enum.Font.GothamBold
    mpsLbl.TextSize = 10
    mpsLbl.TextXAlignment = Enum.TextXAlignment.Right
    mpsLbl.TextColor3 = Color3.fromRGB(130, 255, 170)
    mpsLbl.Text = ""

    LOG_SLOTS[i] = { 
        card = card, 
        stripe = stripe, 
        stroke = stroke, 
        nameLbl = nameLbl, 
        rarityLbl = rarityLbl,
        mutBadge = mutBadge,
        mutLbl = mutLbl,
        mpsLbl = mpsLbl 
    }
end

local logHead = 1

local function formatMPS(mps)
    if not mps or mps == 0 then return "" end
    if NumberShorten then
        local ok, s = pcall(function() return NumberShorten.Shorten(mps) end)
        if ok and s then return "$" .. s .. "/s" end
    end
    if mps >= 1e12 then return string.format("$%.1ft/s", mps/1e12)
    elseif mps >= 1e9 then return string.format("$%.1fb/s", mps/1e9)
    elseif mps >= 1e6 then return string.format("$%.1fm/s", mps/1e6)
    elseif mps >= 1e3 then return string.format("$%.1fk/s", mps/1e3)
    else return string.format("$%.0f/s", mps) end
end

local function addLog(petName, rarity, isBuy, mutation)
    petName  = tostring(petName  or "Unknown")
    rarity   = tostring(rarity   or "Unknown")
    mutation = tostring(mutation  or "None")
    if mutation == "false" or mutation == "nil" or mutation == "" then
        mutation = "None"
    end
    
    totalRolls = totalRolls + 1
    pcall(function() RollCountBadge.Text = totalRolls .. " rolls" end)

    local mpsValue = 0
    pcall(function()
        if HatchUtils and HatchUtils.resolveMPS then
            mpsValue = HatchUtils.resolveMPS("Pets", petName) or 0
        end
        if mpsValue > 0 and PetMath and mutation ~= "None" then
            local mult = PetMath.mutationMultiplier and PetMath.mutationMultiplier(mutation)
            if mult and mult > 0 then mpsValue = mpsValue * mult end
        end
    end)

    local rarityColor = RARITY_COLORS[rarity] or RARITY_COLORS.Unknown
    local mutColor    = (mutation ~= "None" and MUTATION_COLORS[mutation]) or nil

    local slot = LOG_SLOTS[logHead]
    slot.card.LayoutOrder = totalRolls
    slot.card.Visible = true
    
    if isBuy then
        slot.card.BackgroundColor3 = Color3.fromRGB(30, 80, 50)
        slot.stroke.Enabled = true
        slot.stroke.Color = Color3.fromRGB(80, 255, 130)
        slot.nameLbl.Text = "⭐ " .. petName
        slot.nameLbl.TextColor3 = Color3.fromRGB(150, 255, 180)
    else
        slot.card.BackgroundColor3 = rarityColor
        slot.stroke.Enabled = false
        slot.nameLbl.Text = petName
        slot.nameLbl.TextColor3 = Color3.fromRGB(250, 250, 255)
    end
    
    slot.stripe.BackgroundColor3 = rarityColor
    slot.rarityLbl.Text = rarity
    slot.rarityLbl.TextColor3 = rarityColor
    
    local rarityTextLen = string.len(rarity) * 6 + 18
    slot.mutBadge.Position = UDim2.new(0, rarityTextLen, 0, 17)
    
    if mutation ~= "None" then
        slot.mutBadge.Visible = true
        slot.mutBadge.BackgroundColor3 = mutColor or Color3.fromRGB(200, 200, 200)
        slot.mutBadge.BackgroundTransparency = 0.75
        slot.mutLbl.Text = string.upper(mutation)
        slot.mutLbl.TextColor3 = mutColor or Color3.fromRGB(255, 255, 255)
        local mutLen = string.len(mutation) * 5 + 10
        slot.mutBadge.Size = UDim2.new(0, mutLen, 0, 12)
    else
        slot.mutBadge.Visible = false
    end
    
    slot.mpsLbl.Text = formatMPS(mpsValue)
    
    logHead = (logHead % MAX_LOG_ENTRIES) + 1
    LogScroll.CanvasPosition = Vector2.new(0, 999999)
end

local ExecutorEvent = Instance.new("BindableEvent")
ExecutorEvent.Event:Connect(function(action, arg1, arg2, arg3, arg4)
    if action == "addLog" then
        addLog(arg1, arg2, arg3, arg4)
    elseif action == "notif" then
        notif(arg1, arg2)
    end
end)

local LogQueue = {}
task.spawn(function()
    while true do
        task.wait()
        if #LogQueue > 0 then
            local entry = table.remove(LogQueue, 1)
            if entry.type == "log" then
                pcall(addLog, entry.petName, entry.rarity, entry.isBuy, entry.mutation)
            elseif entry.type == "notif" then
                pcall(notif, entry.title, entry.content)
            end
        end
    end
end)

local function logSnapBuy(name, rarity, mutation)
    local mutText = mutation ~= "None" and " [" .. mutation .. "]" or ""
    table.insert(LogQueue, {
        type = "notif",
        title = "Snap Buy: " .. name .. " (" .. rarity .. ")" .. mutText,
        content = "Auto Buy!"
    })
    table.insert(LogQueue, {
        type = "log",
        petName = name,
        rarity = rarity,
        isBuy = true,
        mutation = mutation
    })
end

local Network = nil
pcall(function()
    Network = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"))
end)

if Network and hookfunction and not _G.OriginalNetworkSend then
    _G.OriginalNetworkSend = hookfunction(Network.send, function(...)
        local args = {...}
        local eventName = args[1]
        
        if (eventName == "buy_winner" or eventName == "buy_winner_robux") and _G.ScriptActive and (_G.NapoleonAutoRollPet or _G.NapoleonAutoRollBlock) then
            if not _G.AllowNextBuy then
                return
            end
        end
        
        return _G.OriginalNetworkSend(...)
    end)
end

local HatchReveal = nil
pcall(function()
    HatchReveal = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Services"):WaitForChild("PlotStationsService"):WaitForChild("HatchReveal"))
end)

if HatchReveal then
    if not _G.OriginalHatchPlay then
        _G.OriginalHatchPlay = HatchReveal.play
    end
    
    HatchReveal.play = function(...)
        if not _G.ScriptActive then return _G.OriginalHatchPlay(...) end
        local args = {...}
        local n = select("#", ...)
        if n < 12 then n = 12 end
        
        local userId = args[1]
        local plotOwner = args[2]
        local stationName = args[3]
        local categories = args[4]
        local items = args[5]
        
        if userId == LocalPlayer.UserId and type(items) == "table" then
            local mutations = {}
            for idx = 6, 12 do
                if type(args[idx]) == "table" then
                    for k, v in pairs(args[idx]) do
                        if type(k) == "number" and type(v) == "string" then
                            mutations = args[idx]; break
                        end
                    end
                    if #mutations > 0 or next(mutations) then break end
                end
            end

            for i, item in ipairs(items) do
                local itemName    = tostring(item)
                local rarity, cat = getRarity(itemName)
                local mutationName = mutations[i] or "None"

                local isBuy = false
                if cat == "Pets" or cat == "Unknown" then
                    local allNone = not (hasSpecific(Config.TargetPet) or hasSpecific(Config.TargetRarity) or hasSpecific(Config.TargetMutation))
                    isBuy = (not allNone) and shouldSnapBuy(itemName, rarity, mutationName)
                elseif cat == "Blocks" then
                    local allNone = not (hasSpecific(Config.TargetBlock) or hasSpecific(Config.TargetBlockRarity))
                    isBuy = (not allNone) and shouldSnapBuyBlock(itemName, rarity)
                end

                if isBuy then
                    pcall(function()
                        if Network and Network.send then
                            _G.AllowNextBuy = true
                            Network.send("buy_winner", stationName, i)
                            _G.AllowNextBuy = false
                        end
                    end)
                    local mutText = mutationName ~= "None" and " [" .. mutationName .. "]" or ""
                    
                    table.insert(LogQueue, {
                        type = "notif",
                        title = "Snap Buy: " .. itemName .. " (" .. rarity .. ")" .. mutText,
                        content = "Auto Buy!"
                    })
                    table.insert(LogQueue, {
                        type = "log",
                        petName = itemName,
                        rarity = rarity,
                        isBuy = true,
                        mutation = mutationName
                    })
                else
                    table.insert(LogQueue, {
                        type = "log",
                        petName = itemName,
                        rarity = rarity,
                        isBuy = false,
                        mutation = mutationName
                    })
                end
            end
        end

        -- ── STEP 2: Bypass animasi & Trigger roll berikutnya instan ──
        if (Config.AutoRollPet and _G.NapoleonAutoRollPet) or (Config.AutoRollBlock and _G.NapoleonAutoRollBlock) then
            args[7] = math.huge -- Skip animasi 3D

            if userId == LocalPlayer.UserId and Network and Network.send and stationName then
                -- Kirim hatch_ready langsung (reset server, siap roll baru)
                pcall(function()
                    Network.send("hatch_ready", stationName)
                end)
                
                -- Trigger roll berikutnya di frame berikutnya
                task.defer(function()
                    if Config.AutoRollPet and targetPromptPet and targetPromptPet.Parent then
                        targetPromptPet.HoldDuration = 0
                        targetPromptPet.RequiresLineOfSight = false
                        targetPromptPet.MaxActivationDistance = math.huge
                        pcall(function() fireproximityprompt(targetPromptPet) end)
                    end
                    if Config.AutoRollBlock and targetPromptBlock and targetPromptBlock.Parent then
                        targetPromptBlock.HoldDuration = 0
                        targetPromptBlock.RequiresLineOfSight = false
                        targetPromptBlock.MaxActivationDistance = math.huge
                        pcall(function() fireproximityprompt(targetPromptBlock) end)
                    end
                end)
            end
        end
        
        return _G.OriginalHatchPlay(unpack(args, 1, n))
    end
end


-- Bypass task.wait/delay bawaan gamenya
if hookfunction then
    local oldWait
    oldWait = hookfunction(task.wait, function(n)
        if not _G.ScriptActive then return oldWait(n) end
        local success, source = pcall(debug.info, 2, "s")
        if success and source and source:match("HatchReveal") and (_G.NapoleonAutoRollPet or _G.NapoleonAutoRollBlock) then
            return 999 
        end
        return oldWait(n)
    end)

    local oldDelay
    oldDelay = hookfunction(task.delay, function(t, cb)
        if not _G.ScriptActive then return oldDelay(t, cb) end
        local success, source = pcall(debug.info, 2, "s")
        if success and source and source:match("HatchReveal") and (_G.NapoleonAutoRollPet or _G.NapoleonAutoRollBlock) then
            return oldDelay(0, cb)
        end
        return oldDelay(t, cb)
    end)
end


-- ============================================================
-- ANTI AFK SYSTEM (FOOLPROOF)
-- ============================================================
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")

task.spawn(function()
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
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
            end)
        end
    end)
end)

-- Custom Game Anti-AFK Bypass (Bypasses AntiKickScript.client.lua)
task.spawn(function()
    while task.wait(5) do
        if Config.AntiAFK then
            -- 1. Matikan AntiKickScript bawaan gamenya
            pcall(function()
                local antiKick = LocalPlayer.PlayerScripts:FindFirstChild("AntiKickScript", true)
                if antiKick and antiKick:IsA("LocalScript") and not antiKick.Disabled then
                    antiKick.Disabled = true
                end
            end)
            -- 2. Sembunyikan UI AFK jika sempat muncul
            pcall(function()
                local hud = LocalPlayer.PlayerGui:FindFirstChild("HUD")
                if hud then
                    if hud:FindFirstChild("AFKSafe") then hud.AFKSafe.Visible = false end
                    if hud:FindFirstChild("AFKOffers") then hud.AFKOffers.Visible = false end
                end
            end)
        end
    end
end)

-- 3. Blokir RemoteEvent Reconnect agar tidak bisa mengirim sinyal AFK ke server
local OldNameCall
OldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if Config.AntiAFK and method == "FireServer" then
        if tostring(self) == "AntiKickReconnect" or tostring(self) == "SetAFKSafe" then
            return -- Blokir pengiriman
        end
    end
    return OldNameCall(self, ...)
end)

-- Proactive Background Loop (Fixes Mobile Executor bug where Idled doesn't fire when app is backgrounded)
task.spawn(function()
    while true do
        task.wait(300) -- Setiap 5 Menit
        if Config.AntiAFK then
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
    end
end)

-- ============================================================
-- AUTO COLLECT CASH
-- ============================================================
task.spawn(function()
    while true do
        task.wait(1.5)
        if Config.AutoCollect and firetouchinterest then
            pcall(function()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local plotId = LocalPlayer:GetAttribute("Plot")
                
                if hrp and plotId then
                    local plot = workspace:FindFirstChild("Plots") and workspace.Plots:FindFirstChild(tostring(plotId))
                    if plot then
                        local pad = plot:FindFirstChild("CollectModel") 
                                    and plot.CollectModel:FindFirstChild("Button") 
                                    and plot.CollectModel.Button:FindFirstChild("Pad")
                                    
                        if pad and pad:IsA("BasePart") then
                            firetouchinterest(hrp, pad, 0)
                            task.wait(0.1)
                            firetouchinterest(hrp, pad, 1)
                        end
                    end
                end
            end)
        end
    end
end)

-- ============================================================
-- AUTO BASE LOCK
-- ============================================================
task.spawn(function()
    while true do
        task.wait(2)
        if Config.AutoLock and firetouchinterest then
            pcall(function()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local plotId = LocalPlayer:GetAttribute("Plot")
                
                if hrp and plotId then
                    local plot = workspace:FindFirstChild("Plots") and workspace.Plots:FindFirstChild(tostring(plotId))
                    if plot then
                        local lockModel = plot:FindFirstChild("Lock")
                        if lockModel then
                            local state = lockModel:GetAttribute("LockState")
                            if state == "Idle" or state == nil then
                                local pad = lockModel:FindFirstChild("Pad")
                                if pad and pad:IsA("BasePart") then
                                    firetouchinterest(hrp, pad, 0)
                                    task.wait(0.1)
                                    firetouchinterest(hrp, pad, 1)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ============================================================
-- UI SETUP
-- ============================================================
local Window = Library:Window({
    Title    = "Napoleon",
    Footer   = "Build A Steal",
    Color    = Color3.fromRGB(81, 66, 255),
    Color2   = Color3.fromRGB(0, 0, 14),
    ["Tab Width"] = 130,
    Image      = "111895858615511",
    WindowIMG  = "91334002283698",
    LogoHUB  = "136289055140268"
})

local MainTab = Window:AddTab({ Name = "Main", Icon = "rbxassetid://108886429866687" })

local PetRollSection = MainTab:AddSection("Auto Gacha & Snap Buy (Pets)")

local TargetPetDropdown
TargetPetDropdown = PetRollSection:AddDropdown({
    Title    = "Target Pet (Snap Buy)",
    Content  = "Pilih Pet apa yang ingin langsung dibeli otomatis. Bisa pilih banyak.",
    Options  = PETS_LIST,
    Default  = {"None"},
    Multi    = true,
    Callback = function(val)
        Config.TargetPet = handleDropdownChange(val, TargetPetDropdown)
    end
})

local TargetMutationDropdown
TargetMutationDropdown = PetRollSection:AddDropdown({
    Title    = "Target Mutation (Snap Buy)",
    Content  = "Pilih Mutasi apa yang ingin langsung dibeli otomatis. Bisa pilih banyak.",
    Options  = MUTATION_LIST,
    Default  = {"None"},
    Multi    = true,
    Callback = function(val)
        Config.TargetMutation = handleDropdownChange(val, TargetMutationDropdown)
    end
})

local TargetRarityDropdown
TargetRarityDropdown = PetRollSection:AddDropdown({
    Title    = "Target Pet Rarity (Snap Buy)",
    Content  = "Pilih Rarity Pet apa yang ingin dibeli otomatis. Bisa pilih banyak.",
    Options  = RARITY_LIST,
    Default  = {"None"},
    Multi    = true,
    Callback = function(val)
        Config.TargetRarity = handleDropdownChange(val, TargetRarityDropdown)
    end
})

PetRollSection:AddToggle({
    Title    = "Enable Auto Roll Pet (Remote)",
    Title2   = "Enable",
    Content  = "Berdirilah di dekat stasiun Pet yang kamu mau, lalu nyalakan ini. Script akan mengingat stasiun itu dan terus roll otomatis.",
    Default  = false,
    Callback = function(val)
        Config.AutoRollPet = val
        _G.NapoleonAutoRollPet = val
        if LogFrame then LogFrame.Visible = val or Config.AutoRollBlock end
        if val then
            -- Cari stasiun terdekat saat dinyalakan
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local closestDist = math.huge
                local Plots = workspace:FindFirstChild("Plots")
                if Plots then
                    for _, obj in ipairs(Plots:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") and (obj.ActionText == "Roll!" or obj.ActionText:match("Roll")) then
                            -- Pastikan ini stasiun Pet (biasanya bernama "Egg" di hierarchy)
                            local isPetStation = false
                            local anc = obj.Parent
                            while anc and anc ~= workspace do
                                if anc.Name == "EggModel" then
                                    isPetStation = true
                                    break
                                end
                                anc = anc.Parent
                            end
                            
                            if isPetStation and obj.Parent and obj.Parent:IsA("BasePart") then
                                local dist = (hrp.Position - obj.Parent.Position).Magnitude
                                if dist < closestDist then
                                    closestDist = dist
                                    targetPromptPet = obj
                                end
                            end
                        end
                    end
                end
                
                if targetPromptPet then
                    notif("Berhasil nge-lock Stasiun Pet terdekat! Memulai roll...", "Napoleon")
                    -- Trigger pertama kali
                    task.spawn(function()
                        if Config.AutoRollPet and targetPromptPet and targetPromptPet.Parent then
                            targetPromptPet.HoldDuration = 0
                            targetPromptPet.RequiresLineOfSight = false
                            targetPromptPet.MaxActivationDistance = math.huge
                            pcall(function() fireproximityprompt(targetPromptPet) end)
                        end
                    end)
                else
                    notif("Gagal mencari stasiun Pet. Pastikan kamu ada di plot-mu!", "Napoleon")
                    Config.AutoRollPet = false
                end
            else
                notif("Gagal mencari stasiun Pet. Pastikan karaktermu spawn!", "Napoleon")
                Config.AutoRollPet = false
            end
        else
            targetPromptPet = nil
            notif("Auto Roll Pet dinonaktifkan.", "Napoleon")
        end
    end
})

local BlockRollSection = MainTab:AddSection("Auto Gacha & Snap Buy (Blocks)")

local TargetBlockDropdown
TargetBlockDropdown = BlockRollSection:AddDropdown({
    Title    = "Target Block (Snap Buy)",
    Content  = "Pilih Block apa yang ingin langsung dibeli otomatis. Bisa pilih banyak.",
    Options  = BLOCKS_LIST,
    Default  = {"None"},
    Multi    = true,
    Callback = function(val)
        Config.TargetBlock = handleDropdownChange(val, TargetBlockDropdown)
    end
})

local TargetBlockRarityDropdown
TargetBlockRarityDropdown = BlockRollSection:AddDropdown({
    Title    = "Target Block Rarity (Snap Buy)",
    Content  = "Pilih Rarity Block apa yang ingin dibeli otomatis. Bisa pilih banyak.",
    Options  = RARITY_LIST,
    Default  = {"None"},
    Multi    = true,
    Callback = function(val)
        Config.TargetBlockRarity = handleDropdownChange(val, TargetBlockRarityDropdown)
    end
})

BlockRollSection:AddToggle({
    Title    = "Enable Auto Roll Block (Remote)",
    Title2   = "Enable",
    Content  = "Berdirilah di dekat stasiun Block yang kamu mau, lalu nyalakan ini. Script akan mengingat stasiun itu dan terus roll otomatis.",
    Default  = false,
    Callback = function(val)
        Config.AutoRollBlock = val
        _G.NapoleonAutoRollBlock = val
        if LogFrame then LogFrame.Visible = val or Config.AutoRollPet end
        if val then
            -- Cari stasiun terdekat saat dinyalakan
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local closestDist = math.huge
                local Plots = workspace:FindFirstChild("Plots")
                if Plots then
                    for _, obj in ipairs(Plots:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") and (obj.ActionText == "Roll!" or obj.ActionText:match("Roll")) then
                            -- Pastikan ini stasiun Block (biasanya bernama "Crate" di hierarchy)
                            local isBlockStation = false
                            local anc = obj.Parent
                            while anc and anc ~= workspace do
                                if anc.Name == "CrateModel" then
                                    isBlockStation = true
                                    break
                                end
                                anc = anc.Parent
                            end
                            
                            if isBlockStation and obj.Parent and obj.Parent:IsA("BasePart") then
                                local dist = (hrp.Position - obj.Parent.Position).Magnitude
                                if dist < closestDist then
                                    closestDist = dist
                                    targetPromptBlock = obj
                                end
                            end
                        end
                    end
                end
                
                if targetPromptBlock then
                    notif("Berhasil nge-lock Stasiun Block terdekat! Memulai roll...", "Napoleon")
                    -- Trigger pertama kali
                    task.spawn(function()
                        if Config.AutoRollBlock and targetPromptBlock and targetPromptBlock.Parent then
                            targetPromptBlock.HoldDuration = 0
                            targetPromptBlock.RequiresLineOfSight = false
                            targetPromptBlock.MaxActivationDistance = math.huge
                            pcall(function() fireproximityprompt(targetPromptBlock) end)
                        end
                    end)
                else
                    notif("Gagal mencari stasiun Block. Pastikan kamu ada di plot-mu!", "Napoleon")
                    Config.AutoRollBlock = false
                end
            else
                notif("Gagal mencari stasiun Block. Pastikan karaktermu spawn!", "Napoleon")
                Config.AutoRollBlock = false
            end
        else
            targetPromptBlock = nil
            notif("Auto Roll Block dinonaktifkan.", "Napoleon")
        end
    end
})

local AutoTab = Window:AddTab({ Name = "Auto", Icon = "rbxassetid://108886429866687" })

local AutoCashSection = AutoTab:AddSection("Auto Cash")
AutoCashSection:AddToggle({
    Title    = "Auto Collect Cash",
    Title2   = "Auto Collect",
    Content  = "Otomatis mengambil uang dari Pad di base/plot kamu dari jarak jauh tanpa perlu mondar-mandir.",
    Default  = false,
    Callback = function(val)
        Config.AutoCollect = val
        if val then
            notif("Auto Collect diaktifkan!", "Napoleon")
        else
            notif("Auto Collect dinonaktifkan.", "Napoleon")
        end
    end
})

local AutoBaseSection = AutoTab:AddSection("Auto Base")
AutoBaseSection:AddToggle({
    Title    = "Auto Lock Base",
    Title2   = "Auto Lock",
    Content  = "Otomatis mengunci (lock) base kamu agar player lain tidak bisa masuk.",
    Default  = false,
    Callback = function(val)
        Config.AutoLock = val
        if val then
            notif("Auto Lock Base diaktifkan!", "Napoleon")
        else
            notif("Auto Lock Base dinonaktifkan.", "Napoleon")
        end
    end
})

local MiscTab = Window:AddTab({ Name = "Misc", Icon = "rbxassetid://108886429866687" })
local MiscSection = MiscTab:AddSection("Anti AFK")

MiscSection:AddToggle({
    Title    = "Anti AFK",
    Title2   = "Anti AFK",
    Content  = "Mencegah kamu di-kick dari game setelah 20 menit diam (AFK).",
    Default  = true,
    Callback = function(val)
        Config.AntiAFK = val
        if val then
            notif("Anti AFK diaktifkan!", "Napoleon")
        else
            notif("Anti AFK dinonaktifkan.", "Napoleon")
        end
    end
})

notif("Script berhasil dimuat!", "Napoleon")
