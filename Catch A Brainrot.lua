-- ============================================================
-- NAPOLEON | CATCH A BRAINROT
-- Auto Farm Script by Napoleon Hub
-- ============================================================

repeat task.wait() until game:IsLoaded()

if _G.CABScriptActive then
    _G.CABScriptActive = false
    task.wait(0.5)
end
_G.CABScriptActive = true

-- ============================================================
-- SERVICES
-- ============================================================
local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local VirtualUser       = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- LOAD UI LIBRARY (sama persis dengan Gag2.lua)
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
        result = string.gsub(result, 'game:GetService%("CoreGui"%)', 'game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")')
        local func, err = loadstring(result)
        if func then
            local ok, lib = pcall(func)
            if ok and lib then return lib end
            warn("[NapoleonUI] Execution Error: " .. tostring(lib))
        else
            warn("[NapoleonUI] Parse Error: " .. tostring(err))
        end
    end
    return nil
end

local Library = LoadNapoleonUI()
if not Library then
    warn("[CAB] CRITICAL: Gagal load NapoleonUI! Cek koneksi internet / executor.")
    return
end

-- ============================================================
-- GAME MODULES
-- ============================================================
local Core = nil
pcall(function()
    Core = require(ReplicatedStorage:WaitForChild("Brainrot", 5):WaitForChild("Core", 5))
end)

-- ============================================================
-- ROT & RARITY LIST (dari Core.Species)
-- ============================================================
local ROT_LIST    = {"None"}
local RARITY_LIST = {"None", "Common", "Uncommon", "Rare", "Epic", "Insane", "Exclusive"}
local MODE_LIST   = {"Catch", "Kill"}
local BALL_LIST   = {"Rot Box", "Silver Box", "Gold Box", "Snow Box", "Snowman Box", "Miner Box", "Frozen Box", "Crystal Box", "Infinity Box"}

pcall(function()
    if Core and Core.Species then
        local names = {}
        for rotName, _ in pairs(Core.Species) do
            table.insert(names, rotName)
        end
        table.sort(names)
        for _, name in ipairs(names) do
            table.insert(ROT_LIST, name)
        end
    end
end)

-- ============================================================
-- CONFIG
-- ============================================================
local Config = {
    AutoFarm      = false,
    AutoHeal      = false,
    TargetRot     = {"None"},
    TargetRarity  = {"None"},
    BattleMode    = "Catch",
    BallType      = "Rot Box",
    SkipCutscene  = true,
    TPDelay       = 0.3,
    AntiAFK       = true,
    AutoReconnect = true,
    HideNotif     = false,
}

-- ============================================================
-- UTILITIES
-- ============================================================
local ICON_ID = "136289055140268"

local function notif(msg, delay, title)
    if Config.HideNotif then return end
    if Library and Library.MakeNotify then
        Library:MakeNotify({
            Title   = title or "Napoleon | CAB",
            Content = msg or "",
            Delay   = delay or 4,
            Icon    = "rbxassetid://" .. ICON_ID,
        })
    end
end

-- handleDropdownChange: sama persis pattern Gag2.lua
-- Jika pilih None bersama yang lain → hapus yang lain
-- Jika pilih lain → hapus None
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

    -- Kalau ada None + item lain → hapus None
    if #arr > 1 and table.find(arr, "None") then
        local newArr = {}
        for _, item in ipairs(arr) do
            if item ~= "None" then table.insert(newArr, item) end
        end
        arr = newArr
        changed = true
    -- Kalau kosong → default None
    elseif #arr == 0 then
        arr = {"None"}
        changed = true
    end

    if changed and dropObj then
        pcall(function() dropObj:Set(arr) end)
    end
    return arr
end

local function getCharacter()
    return LocalPlayer.Character
end

local function getHRP()
    local char = getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function isAlive()
    local char = getCharacter()
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

-- ============================================================
-- FILTER LOGIC (None = all pass)
-- ============================================================
local function trim(s) return s:match("^%s*(.-)%s*$") or s end

local function rotMatchesFilter(rotName, rarityName)
    local filterRot    = Config.TargetRot or {"None"}
    local filterRarity = Config.TargetRarity or {"None"}
    
    local isRotNone    = (filterRot[1] and trim(filterRot[1]) == "None" or #filterRot == 0)
    local isRarityNone = (filterRarity[1] and trim(filterRarity[1]) == "None" or #filterRarity == 0)
    
    local nameMatch = false
    if not isRotNone then
        for _, target in ipairs(filterRot) do
            if string.lower(trim(rotName)) == string.lower(trim(target)) then
                nameMatch = true
                break
            end
        end
    else
        nameMatch = true -- Jika None, berarti semua nama lolos filter
    end
    
    local rarityMatch = false
    if not isRarityNone then
        for _, target in ipairs(filterRarity) do
            if string.lower(trim(rarityName)) == string.lower(trim(target)) then
                rarityMatch = true
                break
            end
        end
    else
        rarityMatch = true -- Jika None, berarti semua rarity lolos filter
    end
    
    -- Harus memenuhi KEDUA syarat (AND logic)
    return nameMatch and rarityMatch
end

-- ============================================================
-- SKIP CUTSCENE / ENCOUNTER ANIMATION
-- ============================================================
local function trySkipCutscene()
    if not Config.SkipCutscene then return end
    pcall(function()
        -- Skip lewat Space / Z key (umum di Roblox games)
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.05)
        vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        task.wait(0.05)
        vim:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.05)
        vim:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end)
end

local ignoredRots = {}

-- ============================================================
-- ============================================================
-- LIVE ROT TRACKER — via RotChiller.Server.Update remote
-- ============================================================
-- Helper: cari rarity dari nama rot (multi-format)
local function getRarity(rotName)
    if spawnRarityCache[rotName] then return spawnRarityCache[rotName] end
    local result = "Unknown"
    pcall(function()
        if Core and Core.Species then
            local names = {rotName, rotName:gsub(" ", ""), rotName:gsub(" ", "-")}
            for _, n in ipairs(names) do
                if Core.Species[n] then
                    result = Core.Species[n].DisplayTier and Core.Species[n].DisplayTier.Name or "Unknown"
                    if result ~= "Unknown" then break end
                end
            end
            if result == "Unknown" then
                for _, speciesData in pairs(Core.Species) do
                    if speciesData.DisplayName == rotName then
                        result = speciesData.DisplayTier and speciesData.DisplayTier.Name or "Unknown"
                        break
                    end
                end
            end
        end
    end)
    spawnRarityCache[rotName] = result
    return result
end

-- Listen Update event buat tracking spawn/despawn real-time
task.spawn(function()
    pcall(function()
        local UpdateEvent = ReplicatedStorage:WaitForChild("Brainrot"):WaitForChild("RotChiller"):WaitForChild("Server"):WaitForChild("Update")
        UpdateEvent.OnClientEvent:Connect(function(data)
            if type(data) ~= "table" then return end
            for _, update in ipairs(data) do
                if update.Type == "Spawn" and update.Rot and type(update.Rot) == "table" then
                    local rot = update.Rot
                    local id = tostring(rot.ID or "")
                    if id ~= "" then
                        local rotName = (rot.RotInstance and rot.RotInstance.Name) or (rot.Species) or "Unknown"
                        spawnedRots[id] = {
                            Name = rotName,
                            Rarity = getRarity(rotName),
                            ContainerID = update.Container or "",
                            RotObj = rot,
                        }
                    end
                elseif update.Type == "Despawn" then
                    local rotId = tostring(update.Rot or "")
                    if rotId ~= "" then spawnedRots[rotId] = nil end
                end
            end
        end)
    end)
end)

-- Poller: tiap 2 detik sync dari RotChiller Client (fallback kalau remote missed)
local spawnRarityCache = {} -- cache rarity lookup
task.spawn(function()
    while _G.CABScriptActive do
        task.wait(2)
        pcall(function()
            local Client = require(ReplicatedStorage.Brainrot.RotChiller.Client)
            if not Client.AllContainers then return end
            for _, c in pairs(Client.AllContainers) do
                if not c.Rots then continue end
                for id, rot in pairs(c.Rots) do
                    local idStr = tostring(id)
                    if not spawnedRots[idStr] then
                        local rotName = rot.Species or (rot.RotInstance and rot.RotInstance.Name) or "Unknown"
                        spawnedRots[idStr] = {
                            Name = rotName,
                            Rarity = getRarity(rotName),
                            ContainerID = c.ID or "",
                            RotObj = rot,
                        }
                    end
                end
            end
        end)
    end
end)

-- Initial seed: jalanin poller 1x langsung biar spawnedRots gak kosong
pcall(function()
    local Client = require(ReplicatedStorage.Brainrot.RotChiller.Client)
    if Client.AllContainers then
        for _, c in pairs(Client.AllContainers) do
            if not c.Rots then continue end
            for id, rot in pairs(c.Rots) do
                local idStr = tostring(id)
                local rotName = rot.Species or (rot.RotInstance and rot.RotInstance.Name) or "Unknown"
                spawnedRots[idStr] = {
                    Name = rotName,
                    Rarity = getRarity(rotName),
                    ContainerID = c.ID or "",
                    RotObj = rot,
                }
            end
        end
    end
end)

-- ============================================================
-- FIND CHILL ROTS — dari live tracker + fallback workspace scan
-- ============================================================
local function getChillRots()
    local results = {}
    local seen = {}

    -- Cara 1: Live tracker (data real-time dari remote)
    for id, data in pairs(spawnedRots) do
        if not rotMatchesFilter(data.Name, data.Rarity) then continue end
        if seen[id] or ignoredRots[id] then continue end
        seen[id] = true

        -- Cari posisi model di workspace, fallback ke container CFrame
        local modelPos = nil
        local containerPos = nil
        pcall(function()
            local rotFolder = workspace["ROT OBJECTS"]
            if rotFolder then
                local model = rotFolder:FindFirstChild(id)
                if model and model.PrimaryPart then
                    modelPos = model.PrimaryPart.Position
                end
            end
            -- Fallback: ambil posisi container dari Client module
            if not modelPos and data.ContainerID then
                local Client = require(ReplicatedStorage.Brainrot.RotChiller.Client)
                for _, c in pairs(Client.AllContainers) do
                    if c.ID == data.ContainerID then
                        containerPos = c.CFrame.Position
                        break
                    end
                end
            end
        end)

        table.insert(results, {
            Name         = data.Name,
            Rarity       = data.Rarity,
            ContainerPos = modelPos or containerPos, -- prefer model, fallback container
            ExactPos     = modelPos,
            ID           = id,
            RotObj       = data.RotObj or { ID = id, ContainerID = data.ContainerID },
        })
    end

    -- Cara 2: Fallback scan workspace langsung
    if #results == 0 then
        pcall(function()
            local rotFolder = workspace["ROT OBJECTS"]
            if not rotFolder then return end
            for _, obj in ipairs(rotFolder:GetChildren()) do
                if not obj:IsA("Model") then continue end
                local id = obj.Name
                -- Ambil nama & rarity dari live tracker (UID -> data lookup)
                local rotName = id
                local rarityName = "Unknown"
                if spawnedRots[id] then
                    rotName = spawnedRots[id].Name
                    rarityName = spawnedRots[id].Rarity
                else
                    -- Fallback: coba baca Species attribute
                    rotName = obj:GetAttribute("Species") or rotName
                    rarityName = getRarity(rotName)
                end
                if not rotMatchesFilter(rotName, rarityName) then continue end
                if seen[id] or ignoredRots[id] then continue end
                seen[id] = true
                local pos = obj.PrimaryPart and obj.PrimaryPart.Position
                if not pos then continue end
                table.insert(results, {
                    Name         = rotName,
                    Rarity       = rarityName,
                    ContainerPos = pos,
                    ExactPos     = pos,
                    ID           = id,
                    RotObj       = { ID = id },
                })
            end
        end)
    end

    return results
end

-- ============================================================
-- AUTO FARM MODULES
-- ============================================================
local function triggerEncounter(rotData)
    local hrp = getHRP()
    if not hrp then return false end
    if not rotData.ContainerPos then return false end

    notif("→ " .. rotData.Name .. " (" .. rotData.Rarity .. ")", 2, "Target")

    -- Hover 10 studs di atas container sambil nunggu model spawn
    pcall(function()
        hrp.CFrame = CFrame.new(rotData.ContainerPos + Vector3.new(0, 10, 0))
    end)

    -- Heartbeat: cek model tiap 0.2s. Pas spawn → tunggu 2s → dive
    local phase = "hover"
    local hoverWait = os.clock() + 30
    while os.clock() < hoverWait and _G.CABScriptActive and Config.AutoFarm do
        if isInBattle() then return true end
        
        local livePos = nil
        pcall(function()
            local m = workspace["ROT OBJECTS"] and workspace["ROT OBJECTS"]:FindFirstChild(rotData.ID)
            if m and m.PrimaryPart then livePos = m.PrimaryPart.Position end
        end)
        
        if livePos and phase == "hover" then
            -- Rot spawned! Tunggu 2 detik biar settle
            task.wait(2)
            phase = "dive"
        end
        
        if livePos and phase == "dive" then
            -- Dive: tempel ke badan rot tiap frame
            pcall(function() hrp.CFrame = CFrame.new(livePos) end)
        end
        
        task.wait(0.2)
        if phase == "dive" and not livePos then break end -- Rot despawn saat dive
    end
    
    return true
end

local function isInBattle()
    -- Cek 1: Checks module
    local inBattle = false
    pcall(function()
        local Checks = require(ReplicatedStorage.Modules.Checks)
        if Checks and Checks.Taken and Checks.Taken.Battle == true then
            inBattle = true
        end
    end)
    if inBattle then return true end
    
    -- Cek 2: Battle GUI visible
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    if pgui then
        for _, gui in ipairs(pgui:GetChildren()) do
            if gui.Enabled and gui:IsA("ScreenGui") then
                local n = string.lower(gui.Name)
                if n:find("battle") or n:find("encounter") then return true end
            end
        end
    end
    return false
end

local function clickBattleButton(keywords)
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    if not pgui then return false end

    for _, gui in ipairs(pgui:GetDescendants()) do
        if gui:IsA("GuiButton") and gui.Visible and gui.AbsoluteSize.X > 0 and gui.AbsoluteSize.Y > 0 then
            local n = string.lower(gui.Name)
            local t = ""
            if gui:IsA("TextLabel") or gui:IsA("TextButton") then
                t = string.lower(gui.Text)
            else
                local tl = gui:FindFirstChildOfClass("TextLabel")
                if tl then t = string.lower(tl.Text) end
            end

            for _, kw in ipairs(keywords) do
                if string.find(n, kw) or string.find(t, kw) then
                    pcall(function()
                        if getconnections then
                            for _, conn in pairs(getconnections(gui.MouseButton1Click)) do
                                conn:Fire()
                            end
                            for _, conn in pairs(getconnections(gui.Activated)) do
                                conn:Fire()
                            end
                        end
                    end)
                    pcall(function()
                        local vim = game:GetService("VirtualInputManager")
                        local pos = gui.AbsolutePosition
                        local size = gui.AbsoluteSize
                        local cx, cy = pos.X + (size.X / 2), pos.Y + (size.Y / 2) + 36
                        vim:SendMouseButtonEvent(cx, cy, 0, true, game, 1)
                        task.wait(0.05)
                        vim:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
                    end)
                    return true
                end
            end
        end
    end
    return false
end

local function tryThrowBall()
    -- Jika di menu utama, buka Bag
    clickBattleButton({"bag", "tas", "inventory"})
    task.wait(0.3)
    -- Pilih Ball
    if Config.BallType and Config.BallType ~= "" then
        clickBattleButton({string.lower(Config.BallType)})
        task.wait(0.3)
    end
    -- Konfirmasi Use/Catch
    clickBattleButton({"use", "pakai", "tangkap", "catch"})
end

local function tryAutoAttack()
    -- Buka menu Fight
    if clickBattleButton({"fight", "attack", "serang"}) then
        task.wait(0.3)
    end
    -- Klik salah satu move
    clickBattleButton({"move", "serang"})
end

local function handleBattle()
    local timeout = 30
    local t = 0

    -- Tunggu masuk battle
    while not isInBattle() and t < 5 do
        task.wait(0.2)
        t = t + 0.2
    end

    if not isInBattle() then return end

    notif("Battle dimulai! Mode: " .. tostring(Config.BattleMode), 2, "Napoleon | CAB")

    t = 0
    while isInBattle() and t < timeout and _G.CABScriptActive and Config.AutoFarm do
        trySkipCutscene()
        
        -- Coba klik tombol swap jika prompt rot mati muncul
        clickBattleButton({"send out", "pilih", "select", "swap"})
        
        if Config.BattleMode == "Catch" then
            tryThrowBall()
            task.wait(1.5)
        elseif Config.BattleMode == "Kill" then
            tryAutoAttack()
            task.wait(1)
        end
        
        t = t + 1
    end

    task.wait(0.5)
end

local farmActive = false
local function startFarmLoop()
    if farmActive then return end
    farmActive = true

    task.spawn(function()
        notif("Auto Farm dimulai! (Fresh start)", 3, "Napoleon | CAB")

        while Config.AutoFarm and _G.CABScriptActive do
            if not isAlive() then task.wait(1) continue end
            if isInBattle() then
                handleBattle()
                continue
            end

            -- Ambil semua brainrot sesuai filter
            local rots = getChillRots()

            if #rots == 0 then
                -- Clear ignored list biar rot baru bisa ditemukan
                if next(ignoredRots) then ignoredRots = {} end
                if not _G.CABLastEmptyNotif or os.clock() - _G.CABLastEmptyNotif > 5 then
                    _G.CABLastEmptyNotif = os.clock()
                    notif("Tidak ada Brainrot yang cocok filter!", 2, "Napoleon | CAB")
                end
                local hrp = getHRP()
                if hrp then pcall(function() hrp.Anchored = false end) end
                task.wait(1)
                continue
            end

            -- Pastikan jika menemukan target, karakter bisa bergerak lagi
            local hrp = getHRP()
            if hrp then pcall(function() hrp.Anchored = false end) end
            if not hrp then task.wait(0.3) continue end

            -- Cari rot terdekat dengan posisi kita saat ini
            local closest, closestDist = nil, math.huge
            for _, rotData in ipairs(rots) do
                if rotData.ContainerPos then
                    local dist = (rotData.ContainerPos - hrp.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = rotData
                    end
                end
            end

            if not closest then
                -- Gak ada rot dengan posisi valid, skip
                task.wait(0.5)
                continue
            end

            -- Pastikan ContainerPos valid (cari ulang kalau nil)
            if not closest.ContainerPos then
                pcall(function()
                    local Client = require(ReplicatedStorage.Brainrot.RotChiller.Client)
                    for _, c in pairs(Client.AllContainers) do
                        if closest.RotObj and c.ID == (closest.RotObj.ContainerID or "") then
                            closest.ContainerPos = c.CFrame.Position
                            break
                        end
                    end
                end)
                if not closest.ContainerPos then
                    task.wait(0.5)
                    continue
                end
            end

            -- Panggil trigger encounter
            local ok = triggerEncounter(closest)

            if ok then
                -- Target ini sukses di-encounter, jangan dicari lagi (tambah ke blacklist sementara)
                if closest.ID and closest.ID ~= "" then
                    ignoredRots[closest.ID] = true
                end

                -- Tunggu masuk battle setelah encounter (max 5 detik)
                local enc = 0
                while not isInBattle() and enc < 5 and _G.CABScriptActive do
                    task.wait(0.2)
                    enc = enc + 0.2
                end

                -- Jika masuk battle, tunggu battle selesai
                if isInBattle() then
                    notif("Battle dimulai!", 2, "Napoleon | CAB")
                    handleBattle()
                    -- Tunggu sampai keluar dari battle
                    local bt = 0
                    while isInBattle() and bt < 60 and _G.CABScriptActive do
                        task.wait(0.5)
                        bt = bt + 0.5
                    end
                end

                -- Jeda sebentar setelah encounter/battle selesai
                -- supaya server sempat spawn brainrot baru
                task.wait(1.5)
            else
                -- triggerEncounter gagal (model ghost), masukkan ke ignore list
                if closest.ID and closest.ID ~= "" then
                    ignoredRots[closest.ID] = true
                end
                task.wait(2)
            end
        end

        farmActive = false
        notif("Auto Farm dihentikan.", 3, "Napoleon | CAB")
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
        end)
    end
end)

-- ============================================================
-- AUTO RECONNECT
-- ============================================================
task.spawn(function()
    while task.wait(2) do
        if Config.AutoReconnect then
            pcall(function()
                local coreGui = game:GetService("CoreGui")
                local promptOverlay = coreGui:FindFirstChild("RobloxPromptGui")
                    and coreGui.RobloxPromptGui:FindFirstChild("promptOverlay")
                if promptOverlay then
                    local errPrompt = promptOverlay:FindFirstChild("ErrorPrompt")
                    if errPrompt and errPrompt.Visible then
                        task.wait(2)
                        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
                    end
                end
            end)
        end
    end
end)

-- ============================================================
-- AUTO HEAL LOOP
-- ============================================================
local autoHealActive = false
local function startAutoHealLoop()
    if autoHealActive then return end
    autoHealActive = true
    task.spawn(function()
        -- Ambil cached Client table saat start (ini yang dibaca UI game)
        local cachedClient = nil
        pcall(function()
            cachedClient = require(ReplicatedStorage.Brainrot.InitialInfo.Client)
        end)

        while Config.AutoHeal and _G.CABScriptActive do
            pcall(function()
                local team = cachedClient and cachedClient.Team
                if not (Core and Core.Formula and team) then return end

                local needHeal = false
                for _, rot in pairs(team) do
                    local maxHp = Core.Formula.CalculateHP(rot)
                    if rot.Health <= 0 or rot.Health < maxHp then
                        needHeal = true
                        break
                    end
                end

                if not needHeal then return end

                local healRemote = ReplicatedStorage.Brainrot:FindFirstChild("Center")
                    and ReplicatedStorage.Brainrot.Center:FindFirstChild("Center")
                    and ReplicatedStorage.Brainrot.Center.Center:FindFirstChild("__server__")
                    and ReplicatedStorage.Brainrot.Center.Center.__server__:FindFirstChild("Heal")

                if not (healRemote and healRemote:IsA("RemoteFunction")) then return end

                local newHps = healRemote:InvokeServer()
                if not newHps then return end

                -- Ambil data fresh dari server (seperti saat login)
                local freshData = nil
                pcall(function()
                    local getRemote = ReplicatedStorage.Brainrot.InitialInfo:FindFirstChild("Get")
                    if getRemote then freshData = getRemote:InvokeServer() end
                end)

                if freshData and freshData.Team then
                    -- Patch HP langsung ke cached Client.Team yang dibaca UI
                    for i, freshRot in pairs(freshData.Team) do
                        local cachedRot = team[i]
                        if cachedRot and cachedRot.UniqueID == freshRot.UniqueID then
                            cachedRot.Health = freshRot.Health
                        end
                    end
                else
                    -- Fallback: pakai data dari newHps
                    for _, rot in pairs(team) do
                        local hp = newHps[rot.UniqueID]
                        if hp then rot.Health = hp end
                    end
                end

                -- Trigger UI refresh
                pcall(function()
                    local MyRots = require(ReplicatedStorage.Brainrot.Rot.MyRots)
                    if MyRots and MyRots.Changed then MyRots.Changed:Fire() end
                end)
                pcall(function()
                    require(ReplicatedStorage.Brainrot.Tutorial.MyMetadata).OnHeal()
                end)
                notif("Brainrot berhasil diheal/dihidupkan!", 3, "Auto Heal")
            end)
            task.wait(3)
        end
        autoHealActive = false
    end)
end

-- ============================================================
-- BUILD UI
-- ============================================================
local Window = Library:Window({
    Title     = "Napoleon | Catch A Brainrot",
    Footer    = "v1.0",
    Color     = Color3.fromRGB(81, 66, 255),
    Color2    = Color3.fromRGB(0, 0, 14),
    ["Tab Width"] = 110,
    Image     = "136289055140268",
    LogoHUB   = "136289055140268",
    WindowIMG = "91334002283698",
})
local Tabs = Window

-- ============================================================
-- TAB: FARM
-- ============================================================
local FarmTab = Tabs:AddTab({ Name = "Farm", Icon = "" })

-- SECTION: Auto Farm
local FarmSection = FarmTab:AddSection("Auto Farm", false)

FarmSection:AddToggle({
    Title    = "Auto Farm",
    Content  = "Otomatis TP dan farm Brainrot",
    Default  = false,
    Callback = function(val)
        Config.AutoFarm = val
        if val then 
            startFarmLoop() 
        else
            pcall(function()
                local hrp = getHRP()
                if hrp then hrp.Anchored = false end
            end)
        end
    end,
})

FarmSection:AddToggle({
    Title    = "Auto Heal",
    Content  = "Otomatis heal/hidupkan Brainrot yang mati (Remote)",
    Default  = false,
    Callback = function(val)
        Config.AutoHeal = val
        if val then startAutoHealLoop() end
    end,
})

-- Target Rot dropdown (None = semua)
local TargetRotDrop
TargetRotDrop = FarmSection:AddDropdown({
    Title    = "Target Rot",
    Content  = "Pilih Brainrot target (None = semua)",
    Options  = ROT_LIST,
    Default  = {"None"},
    Multi    = true,
    Callback = function(val)
        Config.TargetRot = handleDropdownChange(val, TargetRotDrop)
    end,
})

-- Target Rarity dropdown (None = semua)
local TargetRarityDrop
TargetRarityDrop = FarmSection:AddDropdown({
    Title    = "Target Rarity",
    Content  = "Filter rarity (None = semua rarity)",
    Options  = RARITY_LIST,
    Default  = {"None"},
    Multi    = true,
    Callback = function(val)
        Config.TargetRarity = handleDropdownChange(val, TargetRarityDrop)
    end,
})

-- Battle Mode dropdown
FarmSection:AddDropdown({
    Title    = "Battle Mode",
    Content  = "Catch = lemahkan lalu tangkap saat sekarat | Kill = serang sampai mati",
    Options  = MODE_LIST,
    Default  = "Catch",
    Multi    = false,
    Callback = function(val)
        if type(val) == "table" then val = val[1] end
        Config.BattleMode = val or "Catch"
    end,
})

-- SECTION: Battle Settings
local BattleSection = FarmTab:AddSection("Battle Settings", false)

BattleSection:AddToggle({
    Title    = "Skip Cutscene",
    Content  = "Otomatis skip animasi encounter",
    Default  = true,
    Callback = function(val)
        Config.SkipCutscene = val
    end,
})

BattleSection:AddDropdown({
    Title    = "Ball Type",
    Content  = "Ball yang dipakai saat mode Catch",
    Options  = BALL_LIST,
    Default  = "Rot Box",
    Multi    = false,
    Callback = function(val)
        if type(val) == "table" then val = val[1] end
        Config.BallType = val or "Rot Box"
    end,
})

BattleSection:AddParagraph({
    Title   = "Info Mode",
    Content = "Catch: isi daya → serang → heal/shield jika HP rendah → tangkap saat musuh <25% HP\nKill: isi daya → serang terkuat terus sampai musuh mati (EXP + Coins)\nKeduanya: auto-switch ke rot berikutnya jika rot aktif mati",
})

-- ============================================================
-- TAB: MISC
-- ============================================================
local MiscTab = Tabs:AddTab({ Name = "Misc", Icon = "" })

local SystemSection = MiscTab:AddSection("System", false)

SystemSection:AddToggle({
    Title    = "Anti AFK",
    Content  = "Mencegah kick karena AFK",
    Default  = true,
    Callback = function(val)
        Config.AntiAFK = val
    end,
})

SystemSection:AddToggle({
    Title    = "Auto Reconnect",
    Content  = "Otomatis rejoin jika disconnect",
    Default  = true,
    Callback = function(val)
        Config.AutoReconnect = val
    end,
})

SystemSection:AddToggle({
    Title    = "Hide Notifications",
    Content  = "Sembunyikan semua notifikasi script",
    Default  = false,
    Callback = function(val)
        Config.HideNotif = val
    end,
})

SystemSection:AddDropdown({
    Title    = "TP Delay (detik)",
    Content  = "Jeda setelah teleport sebelum encounter",
    Options  = {"0.1", "0.2", "0.3", "0.5", "0.8", "1.0"},
    Default  = "0.3",
    Multi    = false,
    Callback = function(val)
        if type(val) == "table" then val = val[1] end
        Config.TPDelay = tonumber(val) or 0.3
    end,
})

SystemSection:AddPanel({
    Title          = "Server Hop",
    Content        = "Pindah ke server lain",
    ButtonText     = "Hop Now",
    ButtonCallback = function()
        notif("Mencari server...", 4, "Server Hop")
        task.spawn(function()
            pcall(function()
                local HttpService     = game:GetService("HttpService")
                local TeleportService = game:GetService("TeleportService")
                local placeId         = game.PlaceId
                local currentJobId    = game.JobId
                local url             = "https://games.roblox.com/v1/games/" .. tostring(placeId) .. "/servers/Public?sortOrder=Asc&limit=100"
                local ok, res         = pcall(function() return game:HttpGet(url) end)
                if not ok then return end
                local decOk, data     = pcall(function() return HttpService:JSONDecode(res) end)
                if decOk and data and data.data then
                    for _, server in ipairs(data.data) do
                        if server.playing and server.maxPlayers
                            and server.playing < server.maxPlayers
                            and server.id ~= currentJobId then
                            TeleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer)
                            task.wait(10)
                            break
                        end
                    end
                end
            end)
        end)
    end,
})

SystemSection:AddPanel({
    Title          = "Rejoin",
    Content        = "Keluar dan masuk ulang server",
    ButtonText     = "Rejoin",
    ButtonCallback = function()
        notif("Rejoining...", 3, "System")
        pcall(function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
        end)
    end,
})

-- ============================================================
-- DONE
-- ============================================================
notif("Napoleon | Catch A Brainrot loaded!", 5, "Napoleon")
print("[Napoleon CAB] Script loaded!")
