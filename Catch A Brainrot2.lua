

-- ============================================================
-- NAPOLEON | CATCH A BRAINROT v2
-- Auto Farm Script by Napoleon Hub
-- ============================================================

repeat task.wait() until game:IsLoaded()

if _G.CAB2ScriptActive then
    _G.CAB2ScriptActive = false
    task.wait(0.5)
end
_G.CAB2ScriptActive = true

-- ============================================================
-- SERVICES
-- ============================================================
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- CRASH PREVENTION HOOKS
-- ============================================================
pcall(function()
    local World1Context = require(ReplicatedStorage:WaitForChild("Brainrot"):WaitForChild("Worlds"):WaitForChild("Controllers"):WaitForChild("1"):WaitForChild("Context"))
    if World1Context then
        if type(World1Context.ResetParams) == "function" then
            local oldReset = World1Context.ResetParams
            World1Context.ResetParams = function(self, ...)
                if not self.Goat or not self.Gate1 or not self.Gate2 then return end
                return oldReset(self, ...)
            end
        end
        if type(World1Context.PostLoop) == "function" then
            local oldPost = World1Context.PostLoop
            World1Context.PostLoop = function(self, ...)
                if not self.Goat or not self.Gate1 or not self.Gate2 then return end
                return oldPost(self, ...)
            end
        end
    end

    local World2Context = require(ReplicatedStorage:WaitForChild("Brainrot"):WaitForChild("Worlds"):WaitForChild("Controllers"):WaitForChild("2"):WaitForChild("World2Context"))
    if World2Context then
        if type(World2Context.ResetParams) == "function" then
            local oldReset = World2Context.ResetParams
            World2Context.ResetParams = function(self, ...)
                local ok, err = pcall(oldReset, self, ...)
                return nil
            end
        end
        if type(World2Context.PostLoop) == "function" then
            local oldPost = World2Context.PostLoop
            World2Context.PostLoop = function(self, ...)
                local ok, err = pcall(oldPost, self, ...)
                return nil
            end
        end
    end
    print("[CAB2 DEBUG] World 1 & 2 Context patched successfully")
end)

-- ============================================================
-- ANTI AFK SYSTEM (Bypasses AntiKickScript.client.lua)
-- ============================================================
task.spawn(function()
    while task.wait(5) do
        if type(Config) == "table" and Config.AntiAFK then
            pcall(function()
                local antiKick = LocalPlayer.PlayerScripts:FindFirstChild("AntiKickScript", true)
                if antiKick and antiKick:IsA("LocalScript") and not antiKick.Disabled then
                    antiKick.Disabled = true
                end
            end)
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

local OldNameCall
OldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" then
        local selfName = tostring(self)
        if selfName == "AntiKickReconnect" or selfName == "SetAFKSafe" then
            if type(Config) == "table" and Config.AntiAFK then
                return
            end
        end
    end
    return OldNameCall(self, ...)
end)
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
        -- [PATCH] Replace CoreGui with PlayerGui to fix Potassium 'lacking capability Plugin' error
        -- result = string.gsub(result, 'game:GetService%("CoreGui"%)', 'game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")')

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
    warn("[CAB2] CRITICAL: Gagal load NapoleonUI! Cek koneksi internet / executor.")
    return
end

-- ============================================================
-- GAME MODULES
-- ============================================================
local Core = nil
pcall(function()
    Core = require(ReplicatedStorage:WaitForChild("Brainrot", 5):WaitForChild("Core", 5))
end)

-- RotChiller.Client = singleton module yang SUDAH di-require game (live, ter-update
-- otomatis lewat RunService.Heartbeat internal). Kita cuma numpang baca .AllContainers,
-- BUKAN bikin listener/poller sendiri seperti script lama.
local RotChillerClient = nil
pcall(function()
    RotChillerClient = require(ReplicatedStorage:WaitForChild("Brainrot", 5):WaitForChild("RotChiller", 5):WaitForChild("Client", 5))
end)

-- Sumber kebenaran zona mana yang udah kebuka buat player ini. Server juga
-- ngecek ini sendiri di CatchRequest, jadi ini cuma buat efisiensi (skip
-- target yang bakal ke-reject) bukan buat safety lagi.
local UnlockedZonesModule = nil
pcall(function()
    UnlockedZonesModule = require(ReplicatedStorage:WaitForChild("Brainrot", 5):WaitForChild("UnlockedZones", 5))
end)

-- WorldsClient.CurrentWorld = World yang KITA lagi aktif di situ sekarang.
-- RotChillerClient.AllContainers ternyata isinya SEMUA World sekaligus
-- (tiap container nyimpen .World sendiri) -- makanya target dari World LAIN
-- (misal kita di Forest tapi ke-detect ada Epic di Winter) ikut kedeteksi
-- padahal CatchRequest PASTI ditolak server (RotChiller/Server.lua:374 --
-- OnCatchRequest butuh p67.Data.World == container punya World). Ini sumber
-- "notif muncul tapi gak battle" -- makanya perlu difilter di sini juga,
-- bukan cuma zona.
local WorldsClientModule = nil
pcall(function()
    WorldsClientModule = require(ReplicatedStorage:WaitForChild("Brainrot", 5):WaitForChild("Worlds", 5):WaitForChild("Client", 5))
end)

-- MyBag = mirror LIVE jumlah ball yang kita PUNYA (di-update client-side tiap
-- inventory berubah). Server ngecek ini juga di processCatchInput --
-- Bag[BallName] >= 1 -- kalau kita gak punya ball yang dipilih di dropdown,
-- Catch PASTI di-reject (ini konfirmasi sumber "ERROR" + "gak mau catch").
local MyBagModule = nil
pcall(function()
    MyBagModule = require(ReplicatedStorage:WaitForChild("Brainrot", 5):WaitForChild("Bag", 5):WaitForChild("MyBag", 5))
end)

local function getOwnedBallCount(ballName)
    if not MyBagModule then return nil end
    local count = nil
    pcall(function() count = MyBagModule.Bag[ballName] end)
    return count or 0
end

local function getTeamUniqueIDs()
    local ids = {}
    pcall(function()
        local client = require(ReplicatedStorage.Brainrot.InitialInfo.Client)
        if client and client.Team then
            for _, rot in pairs(client.Team) do
                if rot and rot.UniqueID then
                    ids[rot.UniqueID] = true
                end
            end
        end
    end)
    return ids
end

local function teamHasNewRot(teamBefore)
    local newFound = false
    pcall(function()
        local client = require(ReplicatedStorage.Brainrot.InitialInfo.Client)
        if client and client.Team then
            for _, rot in pairs(client.Team) do
                if rot and rot.UniqueID and not teamBefore[rot.UniqueID] then
                    newFound = true
                    break
                end
            end
        end
    end)
    return newFound
end

-- MyRots.Changed: BindableEvent yg fire tiap kali team berubah (rot baru,
-- rot mati, dsb). Auto-heal pake ini buat trigger UI refresh.
-- Kita pake buat deteksi catch success: kalau Changed fire setelah lempar
-- ball, berarti ada rot baru → catch sukses.
local MyRotsModule = nil
pcall(function()
    MyRotsModule = require(ReplicatedStorage:WaitForChild("Brainrot", 5):WaitForChild("Rot", 5):WaitForChild("MyRots", 5))
end)

local function waitForTeamChanged(timeoutSec)
    if not MyRotsModule or not MyRotsModule.Changed then
        print("[CAB2 DEBUG] waitForTeamChanged: MyRotsModule nil or Changed nil")
        return false
    end
    local fired = false
    local conn
    pcall(function()
        -- Changed bisa jadi BindableEvent (pake .Event:Connect) atau
        -- custom event table (pake :Connect langsung)
        local sig = MyRotsModule.Changed.Event or MyRotsModule.Changed
        conn = sig:Connect(function()
            fired = true
        end)
    end)
    if not conn then
        print("[CAB2 DEBUG] waitForTeamChanged: gagal connect ke Changed")
        return false
    end
    local waited = 0
    while waited < timeoutSec and not fired and _G.CAB2ScriptActive do
        task.wait(0.2)
        waited = waited + 0.2
    end
    pcall(function() conn:Disconnect() end)
    print("[CAB2 DEBUG] waitForTeamChanged:", fired and "FIRED" or "TIMEOUT", "after", string.format("%.1f", waited) .. "s")
    return fired
end

-- ============================================================
-- ROT & RARITY LIST (dari Core.Species / Core.DisplayTiers)
-- ============================================================
local ROT_LIST    = {"None"}
local RARITY_LIST = {"None", "Common", "Uncommon", "Rare", "Epic", "Insane", "Exclusive"}
local BALL_LIST    = {"Rot Box", "Silver Box", "Gold Box", "Snow Box", "Snowman Box", "Miner Box", "Frozen Box", "Crystal Box", "Rare Box", "Epic Box", "Demon Box", "Infinity Box"}
-- Dropdown-only: "Best Ball" bukan ball beneran, resolveBallType() yang
-- nerjemahin ke ball asli tiap turn -- BALL_LIST sendiri tetep isi ball
-- asli doang (dipakai buat iterasi bandingin catch chance).
local BALL_TYPE_OPTIONS = {"Best Ball"}
for _, name in ipairs(BALL_LIST) do table.insert(BALL_TYPE_OPTIONS, name) end

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
    AutoFarm       = false,
    AutoHeal       = false,
    TargetRot      = {"None"},
    TargetRarity   = {"None"},
    BattleMode     = "Catch", -- "Catch" | "Kill"
    BallType       = "Rot Box",
    CatchThreshold = 0.4, -- lempar ball begitu peluang tangkap >= ini
    HideNotif      = false,
    AutoSkipDialog = false,
    AutoHop        = false,
    AutoHopTimeout = 20, -- detik gak nemu target (sesuai filter) sebelum hop
    ShopAutoBuy    = false,
    AutoSellEnabled = false,
    AutoSellRarity  = {"None"},
    AutoSellName    = {"None"},
}

-- ============================================================
-- UTILITIES
-- ============================================================
local ICON_ID = "136289055140268"

local function notif(content, duration, title)
    if Config.HideNotif then return end
    if Library and Library.MakeNotify then
        Library:MakeNotify({
            Title   = title or "Napoleon | CAB",
            Content = content or "",
            Delay   = duration or 4,
            Icon    = "rbxassetid://" .. ICON_ID,
        })
    end
end

-- handleDropdownChange: sama persis pattern Gag2.lua
-- Jika pilih None bersama yang lain -> hapus yang lain
-- Jika pilih lain -> hapus None
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

local function trim(s) return s:match("^%s*(.-)%s*$") or s end

local function getCharacter()
    return LocalPlayer.Character
end

local function isAlive()
    local char = getCharacter()
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function isInBattle()
    local inBattle = false
    pcall(function()
        local Checks = require(ReplicatedStorage.Modules.Checks)
        if Checks and Checks.Taken and Checks.Taken.Battle == true then
            inBattle = true
        end
    end)
    if inBattle then return true end

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

-- ============================================================
-- RARITY LOOKUP (Core.Species[name].DisplayTier.Name)
-- ============================================================
local rarityCache = {}
local function getRarity(speciesName)
    if rarityCache[speciesName] then return rarityCache[speciesName] end
    local result = "Unknown"
    pcall(function()
        if Core and Core.Species and Core.Species[speciesName] then
            local tier = Core.Species[speciesName].DisplayTier
            if tier and tier.Name then
                result = tier.Name
            end
        end
    end)
    rarityCache[speciesName] = result
    return result
end

-- ============================================================
-- FILTER LOGIC (None = semua lolos)
-- ============================================================
local function rotMatchesFilter(speciesName, rarityName)
    local filterRot    = Config.TargetRot or {"None"}
    local filterRarity = Config.TargetRarity or {"None"}

    local isRotNone    = (#filterRot == 0) or (filterRot[1] and trim(filterRot[1]) == "None")
    local isRarityNone = (#filterRarity == 0) or (filterRarity[1] and trim(filterRarity[1]) == "None")

    local nameMatch = isRotNone
    if not isRotNone then
        for _, target in ipairs(filterRot) do
            if string.lower(trim(speciesName)) == string.lower(trim(target)) then
                nameMatch = true
                break
            end
        end
    end

    local rarityMatch = isRarityNone
    if not isRarityNone then
        for _, target in ipairs(filterRarity) do
            if string.lower(trim(rarityName)) == string.lower(trim(target)) then
                rarityMatch = true
                break
            end
        end
    end

    return nameMatch and rarityMatch
end

-- ============================================================
-- ZONE LOCK CHECK (efisiensi -- server tetep validasi ulang di CatchRequest)
-- ============================================================
local function isZoneUnlocked(zoneNumber)
    if not zoneNumber then return true end -- container tanpa tag zona = area bebas

    local unlocked = false
    pcall(function()
        local zoneState = UnlockedZonesModule
            and UnlockedZonesModule.UnlockedZones
            and UnlockedZonesModule.UnlockedZones[zoneNumber]
        if zoneState and zoneState.Value == true then
            unlocked = true
        end
    end)
    return unlocked
end

local function isCurrentWorld(containerWorld)
    if not containerWorld then return true end -- gak ada tag World = anggap area bebas
    if not WorldsClientModule then return true end -- module gak kebaca, jangan blokir
    local matches = true
    pcall(function() matches = (containerWorld == WorldsClientModule.CurrentWorld) end)
    return matches
end

-- ============================================================
-- SCAN SEMUA BRAINROT YANG LAGI SPAWN (live, dari RotChiller.Client)
-- Gak perlu hitung posisi/Origin sama sekali lagi -- kita cuma butuh
-- ContainerID + RotID buat langsung manggil CatchRequest.
-- ============================================================
local function getFarmTargets()
    local results = {}
    if not RotChillerClient or not RotChillerClient.AllContainers then return results end

    for containerID, container in pairs(RotChillerClient.AllContainers) do
        if container.Rots and isZoneUnlocked(container.Zone) and isCurrentWorld(container.World) then
            for rotID, rot in pairs(container.Rots) do
                local speciesName = rot.Species
                if speciesName then
                    local rarityName = getRarity(speciesName)
                    if rotMatchesFilter(speciesName, rarityName) then
                        table.insert(results, {
                            ID          = rotID,
                            ContainerID = containerID,
                            Species     = speciesName,
                            Rarity      = rarityName,
                            Rot         = rot,
                        })
                    end
                end
            end
        end
    end

    return results
end

-- ============================================================
-- AUTO HOP -- kalau target (sesuai filter Target Rot/Rarity) gak ketemu
-- dalam Config.AutoHopTimeout detik, pindah ke server LAIN lewat Roblox
-- public server-list API (endpoint publik, sama yang dipake situs-situs
-- server-hopper) -- filter server yang PENUH dan server SEKARANG (JobId
-- kita sendiri), baru TeleportToPlaceInstance ke salah satu sisanya.
-- ============================================================
local function getOtherServers()
    local url = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100"
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if not (ok and res) then
        print("[CAB2 DEBUG][HOP] HttpGet gagal:", tostring(res))
        return nil
    end
    local decodeOk, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(res)
    end)
    if not (decodeOk and data and data.data) then
        print("[CAB2 DEBUG][HOP] JSONDecode gagal atau data kosong")
        return nil
    end
    local servers = {}
    for _, srv in ipairs(data.data) do
        if srv.id and srv.id ~= game.JobId and srv.playing and srv.maxPlayers and srv.playing < srv.maxPlayers then
            table.insert(servers, srv.id)
        end
    end
    return servers
end

local function hopServer()
    notif("Auto Hop: gak nemu target, nyari server lain...", 3, "Napoleon | CAB")
    print("[CAB2 DEBUG][HOP] Mulai cari server lain (target gak ketemu " .. tostring(Config.AutoHopTimeout) .. "s)")
    local servers = getOtherServers()
    if not servers or #servers == 0 then
        notif("Auto Hop: gak nemu server lain yang ada slot kosong, coba lagi nanti.", 4, "Napoleon | CAB")
        print("[CAB2 DEBUG][HOP] Gak ada server lain ditemukan")
        return false
    end
    local targetJobId = servers[math.random(1, #servers)]
    print("[CAB2 DEBUG][HOP] Teleport ke JobId:", targetJobId)
    notif("Auto Hop: pindah server sekarang...", 3, "Napoleon | CAB")
    local ok, err = pcall(function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, targetJobId, LocalPlayer)
    end)
    if not ok then
        print("[CAB2 DEBUG][HOP] Teleport error:", tostring(err))
        notif("Auto Hop gagal teleport: " .. tostring(err), 4, "Napoleon | CAB")
        return false
    end
    return true
end

-- ============================================================
-- CATCH REQUEST -- LANGSUNG, TANPA TP/DEKET SAMA SEKALI
-- CatchRequest:InvokeServer(containerID, rotID) di server cuma ngecek:
-- belum battling, rot beneran ada di container itu, zona ke-unlock buat
-- player ini -- TIDAK ADA validasi jarak/posisi player sama sekali.
-- ============================================================
local function requestCatch(target)
    local catchRemote = ReplicatedStorage:FindFirstChild("Brainrot")
        and ReplicatedStorage.Brainrot:FindFirstChild("RotChiller")
        and ReplicatedStorage.Brainrot.RotChiller:FindFirstChild("Server")
        and ReplicatedStorage.Brainrot.RotChiller.Server:FindFirstChild("CatchRequest")

    if not (catchRemote and catchRemote:IsA("RemoteFunction")) then
        return nil
    end

    local ok, battleInfo = pcall(function()
        return catchRemote:InvokeServer(target.ContainerID, target.ID)
    end)

    if ok then
        print("[CAB2 DEBUG] requestCatch OK, battleInfo:", battleInfo ~= nil)
    else
        print("[CAB2 DEBUG] requestCatch FAIL:", tostring(battleInfo))
    end
    if ok then return battleInfo end
    return nil
end

-- Reference ke Context battle yang lagi aktif. Diisi 2 cara: (1) LANGSUNG
-- dari return value Context.new(...) di openBattleUI di bawah -- ini yang
-- utama & 100% reliable buat battle yang KITA mulai sendiri, gak butuh
-- hookfunction sama sekali; (2) fallback lewat hookfunction (liat bagian
-- "BATTLE CONTEXT CAPTURE" di bawah) buat battle yang KEJADIAN NATURAL
-- (bukan dari CatchRequest kita), yang mana kita gak pegang return value-nya.
local activeBattleContext = nil

-- Reference ke rot object LIVE dari RotChillerClient.AllContainers --
-- ini yang beneran update HP-nya, bukan stale proxy di battle Context.
local activeTargetRot = nil
local activeTargetContainerID = nil
local activeTargetRotID = nil

local catchInProgress = false

-- Helper untuk menjalankan fungsi sebagai Game Script (Identity 2)
-- Mencegah error "Cannot require a non-RobloxScript module from a RobloxScript"
-- saat game engine mencoba nge-rebuild World Context setelah battle kita selesai.
local function runAsGameScript(func)
    local getID = getthreadidentity or get_thread_identity or (syn and syn.get_thread_identity)
    local setID = setthreadidentity or set_thread_identity or (syn and syn.set_thread_identity)
    
    local oldID = 8
    if getID then
        pcall(function() oldID = getID() end)
    end
    if setID then
        pcall(function() setID(2) end)
    end
    
    local ok, err = pcall(func)
    
    if setID then
        pcall(function() setID(oldID) end)
    end
    
    if not ok then
        warn("[CAB2 DEBUG] runAsGameScript error: " .. tostring(err))
    end
end

-- Safely destroy battle context (hapus CameraModifier, Heartbeat, UI, dll)
-- supaya world Context bisa resume TANPA error "ResetParams" nil.
-- WAJIB dipanggil tiap kali battle selesai -- jangan cuma nil-in reference.
local function destroyBattleContext(alreadyConcluded)
    local ctx = activeBattleContext
    activeBattleContext = nil
    activeTargetRot = nil
    activeTargetContainerID = nil
    activeTargetRotID = nil
    if ctx then
        runAsGameScript(function()
            -- Cek apakah sudah di-destroy oleh game sendiri
            if not ctx.Dead then
                -- KONFIRMASI dari source game (InputProcessing.lua u28.Normal
                -- + ExecuteInputs.lua u182): "Run" itu yang BENERAN ngasih
                -- tau SERVER kita ninggalin battle Wild (manggil
                -- ServerContext:Destroy() di server, bersihin Battles[ID]).
                -- Kalau kita cuma manggil ctx:Destroy() lokal doang (misal
                -- pas nyerah paksa gara-gara toggle Auto Farm OFF di tengah
                -- battle, BUKAN karena GameOver/Catch/Leave alami), server
                -- gak pernah tau battle ini beres -- kita kehitung
                -- "IsBattling()" SELAMANYA, bikin SEMUA CatchRequest
                -- berikutnya ditolak (battleInfo: false) walau udah toggle
                -- Auto Farm nyala lagi.
                --
                -- TAPI kalau battle-nya emang UDAH beres alami (Catch
                -- sukses -- server OTOMATIS manggil Destroy() sendiri pas
                -- itu kejadian, lihat u172 di ExecuteInputs.lua), Battles[ID]
                -- udah gak ada lagi di server -- ngirim Run ke situ CUMA
                -- bakal ditolak & muncul toast ERROR kosmetik doang (gak ada
                -- dampak fungsional, tapi ganggu keliatannya). Makanya
                -- alreadyConcluded (dikirim true dari titik sukses nangkep)
                -- skip kirim Run sama sekali, langsung Destroy() lokal aja.
                if not alreadyConcluded then
                    pcall(function() ctx:OnInput({ Type = "Run" }) end)
                    task.wait(0.3)
                end
                if not ctx.Dead then
                    ctx:Destroy()
                end
            end
        end)
    end
end

-- Sweeper independen buat bug "Listener exist" (lihat penjelasan detail di
-- runAutoBattle/safeOnInput). Ternyata bersihin InputListener cuma pas KITA
-- mau kirim OnInput aja gak selalu cukup -- soalnya listener baru juga bisa
-- muncul dari RE-ARM ALAMI si game sendiri (misal abis Context:Error() pas
-- ada input yang ke-reject, itu JUGA manggil ListenForInputOnNextFrame
-- sendiri) yang sama sekali gak lewat jalur OnInput kita. Jadi kita sapu
-- bersih tiap frame, independen dari kapan kita kirim aksi.
--
-- KONFIRMASI dari source asli (ContextProxy.lua:329-334 & Extended/Misc.lua
-- ListenForInputNow): Heartbeat GAME SENDIRI manggil ListenForInputNow()
-- TIAP FRAME selama InputListenerFlag true -- fungsi itu error("Listener
-- exist") SEBELUM sempet reset InputListenerFlag kalau InputListener lama
-- masih ada, jadi error-nya ulang TIAP FRAME selamanya sampe ada yang
-- bersihin InputListener-nya. Sweeper versi lama nunggu 0.1 detik DAN cuma
-- jalan kalau uiState=="MENU" -- pas transisi mati/FaultSwitch, uiState
-- BUKAN "MENU", jadi sweeper lama diem aja gak nolongin PAS lagi paling
-- butuh (ini akar dari spam "Listener exist" pas abis switch karena
-- brainrot mati). Sekarang: jalan TIAP FRAME (RunService.Heartbeat, bukan
-- task.wait) dan gak peduli uiState apa -- ngebersihin InputListener yang
-- nyangkut aman dilakuin kapan aja, gak butuh nunggu MENU dulu.
game:GetService("RunService").Heartbeat:Connect(function()
    if not _G.CAB2ScriptActive then return end
    if activeBattleContext and not catchInProgress then
        local ctx = activeBattleContext
        -- Kalau context udah Dead (di-destroy game), langsung bersihin
        local isDead = false
        pcall(function() isDead = ctx.Dead == true end)
        if isDead then
            activeBattleContext = nil
            activeTargetRot = nil
            activeTargetContainerID = nil
            activeTargetRotID = nil
        else
            local hasListener = false
            pcall(function() hasListener = ctx.InputListener ~= nil end)
            if hasListener then
                pcall(function()
                    ctx.InputListener:Destroy()
                    ctx.InputListener = nil
                end)
            end
        end
    end
end)

-- Buka battle UI langsung dari BattleInfo hasil CatchRequest.
-- Context.new({Song, MapName, BattleInfo}) ini yang normalnya dipanggil
-- WorldStepController SETELAH encounter fisik kejadian -- kita panggil
-- manual soalnya kita skip proses deket-deketannya sama sekali.
-- MapName "Default" dipakai karena kita gak lewat WorldStepController
-- (yang biasanya resolve MapName spesifik per-zona).
local function openBattleUI(battleInfo)
    local ok = pcall(function()
        local Context = require(ReplicatedStorage.Brainrot.Battle.Context)
        runAsGameScript(function()
            activeBattleContext = Context.new({
                Song       = "Wild",
                MapName    = "Default",
                BattleInfo = battleInfo,
                OnFinish   = function()
                    -- Kosongin aja karena kita destroy manual dari loop
                end
            })
        end)
    end)
    if ok and activeBattleContext then
        print("[CAB2 DEBUG] openBattleUI SUCCESS, activeBattleContext set")
    else
        print("[CAB2 DEBUG] openBattleUI FAILED, ok:", ok, "activeBattleContext:", activeBattleContext ~= nil)
    end
    return ok
end

-- ============================================================
-- BATTLE CONTEXT CAPTURE (fallback)
-- Cara UTAMA dapetin Context udah ditangani di openBattleUI di atas
-- (langsung dari return value, gak butuh hookfunction). Hook di bawah ini
-- cuma FALLBACK buat battle yang kejadian NATURAL (bukan dari CatchRequest
-- kita, misal encounter manual) -- kalau executor gak support hookfunction,
-- fallback ini doang yang gak jalan; battle yang KITA mulai lewat Auto Farm
-- tetep 100% jalan normal.
-- ============================================================
local BattleContextClass = nil
pcall(function()
    BattleContextClass = require(ReplicatedStorage.Brainrot.Battle.Context)
end)

local MovesetUtils = nil
pcall(function()
    MovesetUtils = require(ReplicatedStorage.Brainrot.Core.MovesetUtils)
end)

local originalContextNew  = nil
local battleContextHooked = false

local function hookBattleContextCapture()
    if battleContextHooked then return true end
    if not (BattleContextClass and BattleContextClass.new) then return false end
    if not (hookfunction and newcclosure) then return false end

    local ok = pcall(function()
        originalContextNew = hookfunction(BattleContextClass.new, newcclosure(function(...)
            local self = originalContextNew(...)
            activeBattleContext = self
            print("[CAB2 DEBUG] Hook captured activeBattleContext")
            return self
        end))
    end)
    battleContextHooked = ok
    return ok
end

-- Pasang hook-nya dari sekarang (bukan nunggu toggle Auto Farm dinyalain)
-- biar battle PERTAMA yang kejadian juga ke-capture Context-nya.
hookBattleContextCapture()

-- ============================================================
-- BATTLE DATA HELPERS
-- ============================================================
local function getMaxHP(rotInstance)
    local ok, hp = pcall(function() return Core.Formula.CalculateHP(rotInstance) end)
    if ok and hp and hp > 0 then return hp end
    return 1
end

local NON_DAMAGING_MOVES = {
    ["Charge"] = true,
    ["Heal"]   = true,
    ["Shield"] = true,
}

-- Replikasi Brainrot.Battle.SimpleAttacks.GetBaseDamage: damage move itu
-- DETERMINISTIK (gak ada random roll), dihitung dari stat attacker x
-- faktor Energy move-nya. Jadi bisa dihitung dulu sebelum dipilih.
local function getMoveDamage(attackerRotInstance, moveName)
    local moveData = Core.Moves and Core.Moves[moveName]
    if not moveData then
        print("[CAB2 DEBUG] getMoveDamage FAIL: no moveData for", moveName)
        return 0
    end

    local base = 0
    pcall(function() base = Core.Formula.CalculateBaseDamage(attackerRotInstance) end)

    local e = moveData.Energy or 0
    local dmg = base * ((e + (e / 3 + 1)) / 3)
    print("[CAB2 DEBUG] getMoveDamage:", moveName, "| base:", string.format("%.1f", base), "| energy:", e, "| result:", string.format("%.1f", dmg))
    return dmg
end

-- Daftar move yang dipunya rot yang lagi aktif (slot 1-4), lengkap sama
-- damage yang bakal keluar & apa affordable (cukup Energy) atau enggak.
local function getAvailableMoves(context)
    local moveset = {}
    pcall(function()
        moveset = MovesetUtils.GetMovesetForRot(context.SectionA.BattleRot.RotInstance) or {}
    end)

    local energy = 0
    pcall(function() energy = context.SectionA.EnergyBar.Energy or 0 end)
    print("[CAB2 DEBUG] getAvailableMoves: energy =", string.format("%.1f", energy))

    local attackerRot = context.SectionA.BattleRot.RotInstance

    local moves = {}
    for i, moveName in pairs(moveset) do
        if moveName then
            local moveData = Core.Moves[moveName]
            local cost = (moveData and moveData.Energy) or 0
            
            local rawDmg = getMoveDamage(attackerRot, moveName)
            -- Paksa damage 0 untuk skill support agar bot tidak mengiranya sebagai attack!
            if NON_DAMAGING_MOVES[moveName] then rawDmg = 0 end

            table.insert(moves, {
                Index      = i,
                Name       = moveName,
                Energy     = cost,
                Damage     = rawDmg,
                Affordable = energy >= cost,
            })
        end
    end
    return moves
end

-- ============================================================
-- AUTO BATTLE -- jalanin satu battle penuh, milih aksi tiap giliran
-- sesuai Config.BattleMode.
-- ============================================================
-- "Best Ball": bukan nama ball beneran, cuma penanda di dropdown -- pas
-- kepilih, tiap turn kita itung GetCatchChance buat SEMUA ball yang kita
-- PUNYA (Bag >= 1, atau anggap punya kalau MyBagModule gak kebaca) lawan
-- musuh yang lagi dihadapin, terus pake yang kasih peluang tangkep
-- PALING TINGGI. Infinity Box otomatis menang (GetCatchChance = 1 selalu,
-- konfirmasi Formula.lua getCatchChanceV2) kalau kita punya -- ball lain
-- dibandingin lewat formula yang sama biar akurat per-musuh (bukan cuma
-- tebak dari urutan list, soalnya efektivitas ball tergantung level/zona
-- musuh, bukan cuma "makin ke bawah makin bagus").
local function findBestOwnedBall(enemyRot, catchRateMultiplier)
    local bestName, bestChance = nil, -1
    for _, name in ipairs(BALL_LIST) do
        local owned = getOwnedBallCount(name)
        if owned == nil or owned >= 1 then
            local chance = 0
            pcall(function() chance = Core.Formula.GetCatchChance(enemyRot, name, catchRateMultiplier or 1) end)
            if chance > bestChance then
                bestChance, bestName = chance, name
            end
        end
    end
    return bestName or BALL_LIST[1], bestChance
end

-- Bener-bener abis semua jenis ball (bukan cuma yang di dropdown) -- kalau
-- getOwnedBallCount balikin nil (MyBagModule gak kebaca) buat SEMUA jenis,
-- kita gak yakin beneran abis, jadi jangan maksa nyerah (anggap masih ada).
local function hasAnyBallLeft()
    local anyKnownOwned = false
    local anyUnknown = false
    for _, name in ipairs(BALL_LIST) do
        local owned = getOwnedBallCount(name)
        if owned == nil then
            anyUnknown = true
        elseif owned >= 1 then
            anyKnownOwned = true
        end
    end
    return anyKnownOwned or anyUnknown
end

local function resolveBallType(enemyRot, catchRateMultiplier)
    if Config.BallType ~= "Best Ball" then return Config.BallType end
    local bestName = findBestOwnedBall(enemyRot, catchRateMultiplier)
    return bestName
end

local function CalculateTargetHP(context)
    local targetHP = 1
    pcall(function()
        local enemyRot = context.SectionB.BattleRot.RotInstance
        local originalHealth = enemyRot.Health
        local ballType = resolveBallType(enemyRot, context.CatchRateMultiplier)
        -- Binary search (bukan scan linear 1-per-1) -- GetCatchChance
        -- monoton naik seiring HP turun, jadi aman dicari lewat binary
        -- search: O(log HP) dibanding O(HP) sebelumnya. Penting banget
        -- pas HP musuh gede (ratusan/ribuan).
        local maxHP = math.max(1, math.floor(originalHealth))
        local lo, hi = 1, maxHP
        local found = 1
        while lo <= hi do
            local mid = math.floor((lo + hi) / 2)
            enemyRot.Health = mid
            local cc = Core.Formula.GetCatchChance(enemyRot, ballType, context.CatchRateMultiplier or 1)
            if cc >= Config.CatchThreshold then
                found = mid
                lo = mid + 1
            else
                hi = mid - 1
            end
        end
        targetHP = found
        enemyRot.Health = originalHealth
    end)
    return targetHP
end

local function GenerateOptimalRoute(context, targetHP, forcedStartRotIndex)
    local team = {}
    pcall(function() team = context.SectionA.Team end)
    
    local enemyRot = context.SectionB.BattleRot.RotInstance
    local startEnemyHP = enemyRot.Health
    local startEnergy = context.SectionA.EnergyBar.Energy or 0
    local startRotID = nil
    pcall(function() startRotID = context.SectionA.BattleRot.RotInstance.UniqueID end)
    
    local startRotIndex = 1
    local teamInfo = {}
    for i, rot in pairs(team) do
        if rot and rot.Health and rot.Health > 0 then
            if rot.UniqueID == startRotID then startRotIndex = i end
            local moves = {}
            local rotMoveset = {}
            pcall(function() rotMoveset = MovesetUtils.GetMovesetForRot(rot) or {} end)
            for mIdx, mName in pairs(rotMoveset) do
                if mName and not NON_DAMAGING_MOVES[mName] then
                    local dmg = getMoveDamage(rot, mName)
                    local e = (Core.Moves[mName] and Core.Moves[mName].Energy) or 0
                    if dmg > 0 then
                        table.insert(moves, { Index = mIdx, Name = mName, Energy = e, Damage = dmg })
                    end
                end
            end
            teamInfo[i] = moves
        else
            teamInfo[i] = {}
        end
    end

    if forcedStartRotIndex then startRotIndex = forcedStartRotIndex end

    local queue = { { RotIndex = startRotIndex, Energy = startEnergy, EnemyHP = startEnemyHP, Path = {}, LastAction = "" } }
    local visited = {}
    
    local bestRoute = nil
    local bestRouteTurns = 999
    local bestRouteEnemyHP = startEnemyHP

    local maxDepth = 10
    local head = 1

    local fallbackRoute = nil
    local fallbackLowestHP = startEnemyHP

    while head <= #queue do
        local state = queue[head]
        head = head + 1

        if #state.Path >= maxDepth then continue end
        if bestRoute and #state.Path >= bestRouteTurns then continue end

        local turnEnergy = math.min(10, state.Energy + 1)
        
        -- 1. Charge
        if turnEnergy < 10 and state.LastAction ~= "Charge_3" then
            local nextEnergy = math.min(10, turnEnergy + 2)
            local sig = state.RotIndex .. "_" .. nextEnergy .. "_" .. math.floor(state.EnemyHP)
            if not visited[sig] then
                visited[sig] = true
                local newPath = table.clone(state.Path)
                table.insert(newPath, { Type = "Charge" })
                table.insert(queue, { 
                    RotIndex = state.RotIndex, Energy = nextEnergy, EnemyHP = state.EnemyHP, Path = newPath,
                    LastAction = (state.LastAction == "Charge" and "Charge_2" or (state.LastAction == "Charge_2" and "Charge_3" or "Charge"))
                })
            end
        end

        -- 2. Switch
        if not string.find(state.LastAction, "Switch") then
            for i, movesList in pairs(teamInfo) do
                if i ~= state.RotIndex and #movesList > 0 then
                    local sig = i .. "_" .. turnEnergy .. "_" .. math.floor(state.EnemyHP)
                    if not visited[sig] then
                        visited[sig] = true
                        local newPath = table.clone(state.Path)
                        table.insert(newPath, { Type = "Switch", Index = i })
                        table.insert(queue, { RotIndex = i, Energy = turnEnergy, EnemyHP = state.EnemyHP, Path = newPath, LastAction = "Switch" })
                    end
                end
            end
        end

        -- 3. Move
        local movesList = teamInfo[state.RotIndex]
        if movesList then
            for _, m in ipairs(movesList) do
                if turnEnergy >= m.Energy then
                    local maxDmg = (m.Damage * 1.25) + 2
                    if maxDmg < state.EnemyHP then
                        local newHP = state.EnemyHP - m.Damage
                        local nextEnergy = turnEnergy - m.Energy
                        
                        local newPath = table.clone(state.Path)
                        table.insert(newPath, { Type = "Move", Index = m.Index })
                        
                        if newHP < fallbackLowestHP then
                            fallbackLowestHP = newHP
                            fallbackRoute = newPath
                        end

                        if newHP <= targetHP then
                            if #newPath < bestRouteTurns or (#newPath == bestRouteTurns and newHP < bestRouteEnemyHP) then
                                bestRouteTurns = #newPath
                                bestRouteEnemyHP = newHP
                                bestRoute = newPath
                            end
                        else
                            local sig = state.RotIndex .. "_" .. nextEnergy .. "_" .. math.floor(newHP)
                            if not visited[sig] then
                                visited[sig] = true
                                table.insert(queue, { RotIndex = state.RotIndex, Energy = nextEnergy, EnemyHP = newHP, Path = newPath, LastAction = "Move" })
                            end
                        end
                    end
                end
            end
        end
    end

    return bestRoute or fallbackRoute or {}
end

local function runAutoBattle()
    if not activeBattleContext then
        print("[CAB2 DEBUG] runAutoBattle skipped -- no activeBattleContext")
        return
    end
    print("[CAB2 DEBUG] runAutoBattle ENTERED, BattleMode:", Config.BattleMode)
    local startClock = os.clock()
    local warnedNoContext = false
    local warnedNoBall = false
    local currentRouteStep = 1
    local lastEnemyHealth = 9999999
    local parsedRoute = {}
    -- Buat notif/debug hasil akhir (berhasil/gagal nangkep) -- nama musuh
    -- di-capture sekali di awal (bukan dibaca ulang pas battle abis, soalnya
    -- destroyBattleContext() bakal nil-in activeBattleContext duluan).
    local targetSpeciesName = nil
    local caughtThisBattle = false
    pcall(function() targetSpeciesName = activeBattleContext.SectionB.BattleRot.RotInstance.Name end)
    -- Mode Kill: switch ke brainrot damage-tertinggi SEKALI di awal battle
    -- (kalau brainrot yang lagi aktif emang udah yang terbaik, gak usah
    -- switch sama sekali). Sekali kepake, gak diutak-atik lagi sepanjang
    -- battle ini kecuali dia pingsan (itu ditangani blok FaultSwitch
    -- terpisah di bawah).
    local hasSwitchedToBest = false

    -- Context validity check (lebih reliable drpd isInBattle() yg pake
    -- Checks.Taken.Battle yg gak direset pas kita bypass encounter flow)
    local function contextValid()
        if not activeBattleContext then return false end
        local dead = false
        pcall(function() dead = activeBattleContext.Dead == true end)
        if dead then return false end
        return pcall(function() return activeBattleContext.SectionA end)
    end

    -- Context.Convo = objek dialog/textbox yang lagi aktif (konfirmasi dari
    -- Modules/Convo/Convo.lua: field .Dead, sama persis pattern Context
    -- sendiri). Ini presisi -- CUMA true kalau BENERAN ada textbox info
    -- kebuka (misal "X mati!", "Liar muncul!"), BUKAN pas lagi animasi
    -- serangan/transisi switch/dll (yang sebelumnya IKUT kena klik terus
    -- karena cuma ngecek uiState ~= "MENU", bikin kerasa ganggu/berlebihan).
    local function hasActiveDialogue()
        if not activeBattleContext then return false end
        local active = false
        pcall(function()
            active = activeBattleContext.Convo ~= nil and not activeBattleContext.Convo.Dead
        end)
        return active
    end

    local function clickIfDialogueShowing()
        if hasActiveDialogue() then
            pcall(function()
                local vim = game:GetService("VirtualInputManager")
                vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.05)
                vim:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end)
        end
    end

    -- Circuit breaker: server nolak input yang dikirim di state yang salah
    -- (misal Fight/Catch pas lagi state "FaultSwitch" musuh) tanpa keliatan
    -- errornya di sisi kita -- kalau gak dicegah, loop bakal ngirim ulang
    -- input yang SAMA tiap 0.5 detik selama-lamanya (ini penyebab ERROR
    -- toast numpuk). Kita lacak signature aksi terakhir; kalau ke-ulang
    -- terlalu banyak kali, berhenti sebentar & jangan kirim ulang.
    local lastActionSignature = nil
    local sameActionStreak = 0
    local BACKOFF_STREAK = 4
    local justThrewBall = false

    -- KETEMU ROOT CAUSE dari F9 log: ContextProxy.lua punya Heartbeat loop
    -- ("if InputListenerFlag then ListenForInputNow() end") yang manggil
    -- ListenForInputNow() -- fungsi ini error("Listener exist") KALAU
    -- InputListener LAMA masih nyangkut belum di-destroy. Listener itu
    -- normalnya di-destroy sendiri pas PLAYER KLIK tombol GUI beneran --
    -- tapi kita manggil OnInput() LANGSUNG (skip klik GUI sama sekali),
    -- jadi listener lama gak PERNAH ke-destroy -> ListenForInputNow error
    -- BEFORE sempet reset InputListenerFlag -> Heartbeat nyoba lagi FRAME
    -- BERIKUTNYA -> error lagi -> infinite loop tiap frame (persis log-nya:
    -- puluhan baris identik dalam 1 detik). Ini kemungkinan besar penyebab
    -- UTAMA ERROR spam + HP/Energy UI macet (turn gak pernah beneran
    -- ke-rearm). Fix: kita bersihin InputListener lama sendiri (niruin apa
    -- yang GUI klik lakuin) SEBELUM tiap OnInput kita.
    local function safeOnInput(payload)
        pcall(function()
            -- Set flag ini ke false WAJIB dilakukan karena kita nge-bypass GUI click.
            -- Kalau nggak, Heartbeat loop game bakal terus-terusan nyoba manggil 
            -- ListenForInputNow() di frame berikutnya dan bikin error "Listener exist".
            activeBattleContext.InputListenerFlag = false
            if activeBattleContext.InputListener then
                activeBattleContext.InputListener:Destroy()
                activeBattleContext.InputListener = nil
            end
            if activeBattleContext.UI and activeBattleContext.UI.SetState then
                activeBattleContext.UI:SetState("NONE")
            end
        end)
        local ok, result = pcall(function()
            return activeBattleContext:OnInput(payload)
        end)
        print("[CAB2 DEBUG] OnInput(" .. tostring(payload.Type) .. ") ok:", ok, "| result:", tostring(result))
        return ok, result
    end

    local function shouldSend(signature)
        if signature == lastActionSignature then
            sameActionStreak = sameActionStreak + 1
        else
            lastActionSignature = signature
            sameActionStreak = 0
        end
        if sameActionStreak >= BACKOFF_STREAK then
            notif("Auto-battle: '" .. signature .. "' keulang " .. sameActionStreak .. "x, coba Skip buat resync.", 3, "Napoleon | CAB")
            -- Mode Kill lebih sering mentok di sini drpd Catch -- BUKAN
            -- soal kodenya beda, tapi Kill emang gak pernah main aman
            -- (selalu pukul sekeras mungkin, gak ngehindar), jadi brainrot
            -- kita jauh lebih sering mati mendadak. Pas itu kejadian, dialog
            -- "X mati!" ikut nongol BARENGAN sama transisi switch -- kalau
            -- dialog itu masih nyangkut kebuka pas kita ngirim OnInput lagi,
            -- Context nolak terus (ERROR toast numpuk, ini persis "Listener
            -- exist" case yang sama kayak dialog-skip di bawah). Jadi
            -- sebelum nudge Skip, sapu dulu dialog yang mungkin masih
            -- nyangkut (klik CUMA kalau beneran ada Convo aktif).
            clickIfDialogueShowing()
            task.wait(0.2)
            -- Jangan kirim ulang aksi yang SAMA (kemungkinan emang ke-reject
            -- terus) -- kirim Skip sekali aja sbg nudge, siapa tau state
            -- kita emang lagi gak sinkron sama server (misal turn udah
            -- lewat) dan Skip bisa bantu balik ke "MENU" yang bener.
            if activeBattleContext then
                safeOnInput({ Type = "Skip" })
            end
            task.wait(1.5)
            sameActionStreak = 0
            lastActionSignature = nil
            return false
        end
        return true
    end

    -- SENGAJA gak ada batas waktu tetap (misal 90 detik) lagi -- target
    -- rarity tinggi (Epic/Insane) kadang catch chance-nya kecil banget
    -- walau HP udah minimum, dan nyerah cuma karena "kelamaan" berarti
    -- ngebuang peluang yang beneran ada (biar 1%, tetep > 0% drpd
    -- dibatalin). Selama context masih valid & masih ada ball, kita terus
    -- coba -- nyerah cuma kalau ball beneran abis (dicek di Catch-mode di
    -- bawah) atau tim abis total (blok FaultSwitch di bawah).
    while contextValid() and Config.AutoFarm and _G.CAB2ScriptActive do
        if not activeBattleContext then
            -- Belum ke-capture (biasanya cuma kejadian buat battle NATURAL
            -- yang gak lewat openBattleUI kita -- lihat komentar di atas).
            -- Kalau abis 5 detik masih nil, kasih tau & nunggu pasif aja
            -- biar gak nyangkut nyoba mulu tanpa hasil.
            if not warnedNoContext and os.clock() - startClock > 5 then
                warnedNoContext = true
                notif("Gak dapet Context battle -- auto-battle nunggu pasif aja.", 3, "Napoleon | CAB")
            end
            if warnedNoContext then
                local bt = 0
                while isInBattle() and bt < 60 and Config.AutoFarm and _G.CAB2ScriptActive do
                    task.wait(0.5)
                    bt = bt + 0.5
                end
                return
            end
            task.wait(0.2)
            continue
        end

        local uiState = nil
        pcall(function() uiState = activeBattleContext.UI.UIState end)

        local ourHealth = nil
        pcall(function() ourHealth = activeBattleContext.SectionA.BattleRot.RotInstance.Health end)

        local enemyHealthRaw = nil
        pcall(function() enemyHealthRaw = activeBattleContext.SectionB.BattleRot.RotInstance.Health end)

        -- Dipaksa ganti Brainrot? (HP kita 0, masih ada anggota tim lain)
        -- Cek ini DULUAN, TERLEPAS dari uiState -- pas state "FaultSwitch"
        -- kemungkinan besar uiState bukan literal "MENU", jadi kalau
        -- ini digantung di belakang gate uiState=="MENU", switch-nya
        -- gak akan pernah ke-attempt sama sekali.
        if ourHealth and math.floor(ourHealth) < 1 then
            local team = {}
            pcall(function() team = activeBattleContext.SectionA.Team end)

            -- Cari rot terbaik buat FaultSwitch menggunakan simulasi BFS masa depan!
            local bestIndex = nil
            local shortestRouteLen = 999
            local targetHP = CalculateTargetHP(activeBattleContext)

            for i, rot in pairs(team) do
                if rot and rot.Health and rot.Health > 0 then
                    local simRoute = GenerateOptimalRoute(activeBattleContext, targetHP, i)
                    local routeLen = #simRoute
                    if routeLen < shortestRouteLen then
                        shortestRouteLen = routeLen
                        bestIndex = i
                    end
                end
            end

            -- Fallback kalau semua error (darurat)
            if not bestIndex then
                local bestHP = -1
                for i, rot in pairs(team) do
                    if rot and rot.Health and rot.Health > 0 and rot.Health > bestHP then
                        bestIndex, bestHP = i, rot.Health
                    end
                end
            end

            if bestIndex and shouldSend("Switch:" .. bestIndex) then
                safeOnInput({ Type = "Switch", TeamIndex = bestIndex })
                print("[CAB2 DEBUG] Sent FaultSwitch ke Index", bestIndex, "| Route steps:", shortestRouteLen)
                local t = 0
                local switchDone = false
                while t < 10 and Config.AutoFarm and _G.CAB2ScriptActive do
                    -- KONFIRMASI: ScreenGui battle asli namanya "BattleUI"
                    -- (UI.lua:22), BUKAN sesuatu yang match "party"/"team"/
                    -- "switch" -- kode lama yang nyari-nyari & nge-disable
                    -- ScreenGui berdasar substring itu DIHAPUS karena resiko
                    -- kena ScreenGui LAIN yang gak ada hubungannya (dan gak
                    -- kebukti nolong apa-apa toh gak pernah match BattleUI).
                    -- Klik dismiss juga cuma jalan SELAMA context masih ada
                    -- & belum Dead -- jangan spam klik buta 10 detik penuh
                    -- kalau battle-nya udah kelar/context udah invalid,
                    -- soalnya klik ke overlay yang salah bisa ke-anggap aksi
                    -- lain (misal ke-klik tombol yang gak seharusnya).
                    if not contextValid() then
                        print("[CAB2 DEBUG] Context jadi invalid pas nunggu switch beres -- berhenti klik, keluar.")
                        break
                    end
                    clickIfDialogueShowing()

                    local currentHP = 0
                    pcall(function() currentHP = activeBattleContext.SectionA.BattleRot.RotInstance.Health end)
                    if currentHP and currentHP > 0 then
                        print("[CAB2 DEBUG] Switch (Death) complete! HP is now > 0.")
                        parsedRoute = {} -- WAJIB! Biar dia generate rute baru buat Brainrot yg baru masuk
                        currentRouteStep = 1
                        print("[CAB2 DEBUG] Custom Route Dikosongkan & Reset (Brainrot Mati)")
                        pcall(function()
                            if activeBattleContext.UI and activeBattleContext.UI.SetState then
                                activeBattleContext.UI:SetState("NONE")
                            end
                        end)
                        switchDone = true
                        break
                    end
                    task.wait(0.2)
                    t = t + 0.25
                end
                if not switchDone then
                    print("[CAB2 DEBUG] Switch gak kekonfirmasi (HP masih 0 abis nunggu 10 detik atau context invalid). contextValid():", tostring(contextValid()))
                end
            else
                -- Gak ada bestIndex sama sekali = TIM KITA ABIS TOTAL (semua
                -- Health <= 0) -- kejadian di mode Kill kalau kita gak sempet
                -- Auto Heal antar-battle. Blok di atas cuma dijalanin kalau
                -- ada TeamIndex buat di-switch, jadi kalau kondisi ini kena
                -- gak ada apapun yg kekirim -- dialog "X mati!" & error toast
                -- numpuk gak PERNAH ke-dismiss, loop nyangkut selamanya.
                -- Battle ini emang udah kalah (gak ada Brainrot idup buat
                -- diteruskan) -- sapu dialog yang nyangkut beberapa kali,
                -- terus nyerah dari battle ini (biar farm loop lanjut ke
                -- Auto Heal + encounter berikutnya, bukan macet permanen).
                print("[CAB2 DEBUG] Tim kita abis total (gak ada yang idup buat di-switch) -- sapu dialog & nyerah dari battle ini.")
                for _ = 1, 15 do
                    clickIfDialogueShowing()
                    task.wait(0.2)
                end
                break
            end
            task.wait(0.5)
            continue
        end

        -- Musuh farming KITA SELALU Wild -- dan Wild GAK PERNAH punya
        -- cadangan (konfirmasi ExecuteInputs.lua OnDeath: kalau
        -- TeamHasAtleastOneAliveGuy() false, langsung GameOver, SAMA SEKALI
        -- gak lewat state "FaultSwitch"). Jadi begitu HP musuh 0, battle
        -- SEHARUSNYA otomatis kelar (GameOver) tanpa kita kirim apapun --
        -- kirim "Skip" di sini (asumsi lama: musuh lagi FaultSwitch nunggu
        -- ganti) SELALU DITOLAK karena state udah bukan Normal/FaultSwitch
        -- lagi, numpuk ERROR toast selamanya nunggu musuh "ganti" yang gak
        -- bakal pernah kejadian buat Wild. Tunggu pasif aja -- battle bakal
        -- kebaca gak valid lagi (Context.Dead) lewat contextValid() di atas.
        if enemyHealthRaw and math.floor(enemyHealthRaw) < 1 then
            -- Battle-nya emang udah otomatis nuju GameOver (gak perlu kirim
            -- input apapun), TAPI dialog "X mati!" masih butuh diklik biar
            -- lanjut ke layar "selesai" -- klik CUMA kalau beneran ada
            -- dialog aktif (Context.Convo), gak asal klik terus-terusan.
            clickIfDialogueShowing()
            task.wait(0.5)
            continue
        end

        if uiState ~= "MENU" then
            -- Bukan giliran milih aksi (lagi animasi/transisi/dialog) --
            -- tunggu aja, TAPI cuma klik kalau beneran ada dialog/textbox
            -- aktif (Context.Convo). Dulu diklik terus-terusan selama
            -- uiState != "MENU" (nyakup animasi serangan, transisi switch,
            -- dll juga yang SEBENERNYA gak butuh diklik sama sekali) --
            -- itu yang berasa ganggu/berlebihan.
            clickIfDialogueShowing()
            task.wait(0.2)
            continue
        end

        local enemyHealth = enemyHealthRaw or 0

        -- Deteksi Enemy Heal untuk Reset Siklus
        if enemyHealth > lastEnemyHealth and lastEnemyHealth ~= 9999999 then
            print("[CAB2 DEBUG] Musuh nge-heal! Reset Custom Route ke Step 1.")
            currentRouteStep = 1
        end
        lastEnemyHealth = enemyHealth

        local moves = getAvailableMoves(activeBattleContext)

        local chargeMove = nil
        for _, m in ipairs(moves) do
            if m.Name == "Charge" then chargeMove = m end
        end

        -- ============================================================
        -- DYNAMIC SPEEDRUN ROUTE GENERATOR
        -- ============================================================
        if #parsedRoute == 0 and Config.BattleMode == "Catch" then
            print("[CAB2 DEBUG] Menghitung Dynamic Route terbaik untuk musuh ini...")
            local targetHP = CalculateTargetHP(activeBattleContext)
            print("[CAB2 DEBUG] Target HP optimal untuk ditangkap:", targetHP)
            
            parsedRoute = GenerateOptimalRoute(activeBattleContext, targetHP)
            currentRouteStep = 1
            
            local debugStr = ""
            for _, s in ipairs(parsedRoute) do
                if s.Type == "Switch" then debugStr = debugStr .. "Switch("..s.Index..")->"
                elseif s.Type == "Move" then debugStr = debugStr .. "Skill("..s.Index..")->"
                else debugStr = debugStr .. s.Type .. "->" end
            end
            print("[CAB2 DEBUG] Dynamic Route Ditemukan:", debugStr)
        end

        if currentRouteStep <= #parsedRoute then
            local step = parsedRoute[currentRouteStep]
            local actionSent = false
            local shouldIncrement = true

            local enemyHasShield = false
            pcall(function()
                local state = activeBattleContext.State or (activeBattleContext.ServerDC and activeBattleContext.ServerDC.State)
                if state and state.SimpleState and state.SimpleState.Shields then
                    for _, shield in pairs(state.SimpleState.Shields) do
                        if shield.User == "B" then
                            enemyHasShield = true
                            break
                        end
                    end
                end
            end)

            if step.Type == "Charge" then
                print("[CAB2 DEBUG] Custom Route Step", currentRouteStep, ": Charge")
                if chargeMove and shouldSend("Fight:" .. chargeMove.Index) then
                    safeOnInput({ Type = "Fight", MoveIndex = chargeMove.Index })
                    actionSent = true
                end
            elseif step.Type == "Switch" then
                print("[CAB2 DEBUG] Custom Route Step", currentRouteStep, ": Switch ke TeamIndex", step.Index)
                if shouldSend("Switch:" .. step.Index) then
                    local oldID = nil
                    pcall(function() oldID = activeBattleContext.SectionA.BattleRot.RotInstance.UniqueID end)
                    safeOnInput({ Type = "Switch", TeamIndex = step.Index })
                    actionSent = true
                    
                    local t = 0
                    while t < 10 and Config.AutoFarm and _G.CAB2ScriptActive do
                        local newID = nil
                        pcall(function() newID = activeBattleContext.SectionA.BattleRot.RotInstance.UniqueID end)
                        if newID and newID ~= oldID then break end
                        task.wait(0.5); t = t + 0.5
                    end
                end
            elseif step.Type == "Move" then
                print("[CAB2 DEBUG] Custom Route Step", currentRouteStep, ": Skill Index", step.Index)
                if enemyHasShield then
                    print("[CAB2 DEBUG] Musuh punya Shield! Menahan siklus dengan Charge.")
                    if chargeMove and shouldSend("Fight:" .. chargeMove.Index) then
                        safeOnInput({ Type = "Fight", MoveIndex = chargeMove.Index })
                        actionSent = true
                        shouldIncrement = false -- STALL SIKLUS!
                    end
                else
                    local targetMove = nil
                    for _, m in ipairs(moves) do
                        if m.Index == step.Index then targetMove = m end
                    end
                    if targetMove and targetMove.Affordable then
                        if shouldSend("Fight:" .. targetMove.Index) then
                            safeOnInput({ Type = "Fight", MoveIndex = targetMove.Index })
                            actionSent = true
                        end
                    else
                        print("[CAB2 DEBUG] Energy belum cukup untuk Skill! Menahan siklus dengan Charge.")
                        if chargeMove and shouldSend("Fight:" .. chargeMove.Index) then
                            safeOnInput({ Type = "Fight", MoveIndex = chargeMove.Index })
                            actionSent = true
                            shouldIncrement = false -- STALL SIKLUS!
                        end
                    end
                end
            end

            if actionSent then
                if shouldIncrement then
                    currentRouteStep = currentRouteStep + 1
                end
                task.wait(1.5)
                continue
            end
        end

        if Config.BattleMode == "Catch" then
            if not hasAnyBallLeft() then
                print("[CAB2 DEBUG] Semua jenis ball beneran abis -- nyerah dari battle ini.")
                notif("Ball abis total -- nyerah dari battle ini.", 3, "Napoleon | CAB")
                break
            end

            local ballType = resolveBallType(activeBattleContext.SectionB.BattleRot.RotInstance, activeBattleContext.CatchRateMultiplier)
            local catchChance = 0
            local ccOk, ccErr = pcall(function()
                catchChance = Core.Formula.GetCatchChance(
                    activeBattleContext.SectionB.BattleRot.RotInstance,
                    ballType,
                    activeBattleContext.CatchRateMultiplier or 1
                )
            end)
            if not ccOk then
                print("[CAB2 DEBUG] GetCatchChance ERROR:", tostring(ccErr))
            end

            local safeMove = nil
            local currentRotHasAnySafeMove = false
            for _, m in ipairs(moves) do
                -- Tambahin margin super aman (asumsi damage bisa meleset 25% lebih sakit
                -- gara-gara buff/trait tersembunyi) ditambah base 2 HP margin.
                -- Abaikan skill support (Damage = 0).
                local maxPossibleDamage = (m.Damage * 1.25) + 2
                if m.Damage > 0 and maxPossibleDamage < enemyHealth then
                    currentRotHasAnySafeMove = true
                    if m.Affordable then
                        if not safeMove or m.Damage > safeMove.Damage then
                            safeMove = m
                        end
                    end
                end
            end
            
            -- Cari Brainrot cadangan HANYA jika Brainrot kita saat ini benar-benar
            -- tidak punya skill yang aman (semua skillnya mematikan).
            -- Kalau masih punya skill aman tapi cuma kurang energi, mending CHARGE!
            local bestSwitchIndex = nil
            local bestSwitchSafeDamage = -1
            if not currentRotHasAnySafeMove and catchChance < Config.CatchThreshold then
                local team = {}
                pcall(function() team = activeBattleContext.SectionA.Team end)
                local currentRotID = nil
                pcall(function() currentRotID = activeBattleContext.SectionA.BattleRot.RotInstance.UniqueID end)
                
                for i, rot in pairs(team) do
                    if rot and rot.Health and rot.Health > 0 and rot.UniqueID ~= currentRotID then
                        local rotMoveset = {}
                        pcall(function() rotMoveset = MovesetUtils.GetMovesetForRot(rot) or {} end)
                        
                        local maxSafeDmg = -1
                        for _, moveName in pairs(rotMoveset) do
                            if moveName then
                                local dmg = getMoveDamage(rot, moveName)
                                if NON_DAMAGING_MOVES[moveName] then dmg = 0 end
                                
                                local maxPossibleDamage = (dmg * 1.25) + 2
                                if dmg > 0 and maxPossibleDamage < enemyHealth then
                                    if dmg > maxSafeDmg then
                                        maxSafeDmg = dmg
                                    end
                                end
                            end
                        end
                        
                        if maxSafeDmg > bestSwitchSafeDamage then
                            bestSwitchSafeDamage = maxSafeDmg
                            bestSwitchIndex = i
                        end
                    end
                end
            end

            local ownedBalls = getOwnedBallCount(ballType)
            local canThrowBall = ownedBalls == nil or ownedBalls >= 1

            -- [DEBUG] dump semua state keputusan
            print("[CAB2 DEBUG] ===== Turn Decision =====")
            print("[CAB2 DEBUG] enemyHealthRaw:", tostring(enemyHealthRaw), "| enemyHealth:", enemyHealth)
            print("[CAB2 DEBUG] catchChance:", string.format("%.4f", catchChance or 0), "| threshold:", Config.CatchThreshold)
            print("[CAB2 DEBUG] ballType:", ballType, "(Config:", Config.BallType, ") | ownedBalls:", tostring(ownedBalls), "| canThrow:", canThrowBall)
            print("[CAB2 DEBUG] moves count:", #moves)
            for _, m in ipairs(moves) do
                print("[CAB2 DEBUG]   Move[" .. m.Index .. "]", m.Name, "| dmg:", string.format("%.1f", m.Damage), "| cost:", m.Energy, "| affordable:", m.Affordable, "| safe:", (m.Affordable and m.Damage > 0 and m.Damage < enemyHealth))
            end
            print("[CAB2 DEBUG] safeMove:", safeMove and (safeMove.Name .. " (dmg=" .. string.format("%.1f", safeMove.Damage) .. ")") or "NIL")
            print("[CAB2 DEBUG] bestSwitchIndex:", bestSwitchIndex and ("Rot slot " .. tostring(bestSwitchIndex) .. " (safe dmg=" .. string.format("%.1f", bestSwitchSafeDamage) .. ")") or "NIL")
            print("[CAB2 DEBUG] chargeMove:", chargeMove and "found" or "NIL")

            if not canThrowBall and not warnedNoBall then
                warnedNoBall = true
                notif("Ball '" .. tostring(ballType) .. "' abis/gak punya -- ganti dropdown Ball Type.", 4, "Napoleon | CAB")
            end

            if canThrowBall and catchChance >= Config.CatchThreshold then
                print("[CAB2 DEBUG] ACTION: Catch (chance OK)")
                if shouldSend("Catch:" .. tostring(ballType)) then
                    catchInProgress = true
                    safeOnInput({ Type = "Catch", BallName = ballType })
                    justThrewBall = true
                end
            elseif safeMove then
                print("[CAB2 DEBUG] ACTION: Fight safeMove ->", safeMove.Name)
                if shouldSend("Fight:" .. safeMove.Index) then
                    safeOnInput({ Type = "Fight", MoveIndex = safeMove.Index })
                end
            elseif bestSwitchIndex then
                print("[CAB2 DEBUG] ACTION: Switch to Rot " .. tostring(bestSwitchIndex) .. " for safe move")
                if shouldSend("Switch:" .. bestSwitchIndex) then
                    safeOnInput({ Type = "Switch", TeamIndex = bestSwitchIndex })
                    print("[CAB2 DEBUG] Sent Switch (Safe Move), waiting for animation to finish...")
                    local oldRotID = nil
                    pcall(function() oldRotID = activeBattleContext.SectionA.BattleRot.RotInstance.UniqueID end)
                    local t = 0
                    while t < 10 and Config.AutoFarm and _G.CAB2ScriptActive do
                        local newRotID = nil
                        pcall(function() newRotID = activeBattleContext.SectionA.BattleRot.RotInstance.UniqueID end)
                        if newRotID and newRotID ~= oldRotID then
                            print("[CAB2 DEBUG] Switch (Safe Move) complete! Rot changed.")
                            break
                        end
                        task.wait(0.5)
                        t = t + 0.5
                    end
                end
            elseif canThrowBall and not currentRotHasAnySafeMove and not bestSwitchIndex then
                -- Darurat: gak ada skill aman & gak ada cadangan yang lebih
                -- lemah -- kepaksa lempar ball tanpa bisa nurunin HP lebih
                -- jauh. Kalau ball di dropdown catch chance-nya jelek buat
                -- musuh ini (bisa aja levelnya emang di luar jangkauan ball
                -- itu, HP-nya udah gak ngaruh lagi), coba SEMUA ball yang
                -- kita PUNYA (bukan cuma yang di dropdown) biar peluangnya
                -- paling maksimal -- drpd spam ball lemah di peluang <10%
                -- selama 90 detik sampe timeout tanpa pernah kena sekalipun
                -- (ini konfirmasi gejala aslinya dari F9: catchChance 5.95%
                -- vs threshold 40%, abis 90 detik battle nyerah sendiri).
                local emergencyBall, emergencyChance = findBestOwnedBall(activeBattleContext.SectionB.BattleRot.RotInstance, activeBattleContext.CatchRateMultiplier)
                print("[CAB2 DEBUG] ACTION: Catch (fallback darurat) -- ball dropdown:", ballType, "(chance " .. string.format("%.4f", catchChance) .. ") -> ball terbaik yang dipunya:", emergencyBall, "(chance " .. string.format("%.4f", emergencyChance) .. ")")
                if shouldSend("Catch:" .. tostring(emergencyBall)) then
                    catchInProgress = true
                    safeOnInput({ Type = "Catch", BallName = emergencyBall })
                    justThrewBall = true
                end
            elseif chargeMove then
                print("[CAB2 DEBUG] ACTION: Charge (building energy / no safe/no switch)")
                if shouldSend("Fight:" .. chargeMove.Index) then
                    safeOnInput({ Type = "Fight", MoveIndex = chargeMove.Index })
                end
            else
                print("[CAB2 DEBUG] ACTION: NONE -- all paths dead")
            end
        else -- "Kill"
            -- Sekali di awal battle: cek apa ada anggota tim lain yang base
            -- damage-nya LEBIH GEDE dari brainrot yang lagi aktif -- kalau
            -- ada, switch ke situ dulu sebelum mulai nyerang. Kalau yang
            -- aktif sekarang udah yang paling sakit (atau gak ada yang lebih
            -- baik), gak usah switch -- langsung lanjut nyerang di turn yang
            -- sama, gak buang giliran.
            if not hasSwitchedToBest then
                hasSwitchedToBest = true
                local ourDamage = 0
                pcall(function() ourDamage = Core.Formula.CalculateBaseDamage(activeBattleContext.SectionA.BattleRot.RotInstance) end)

                local team = {}
                pcall(function() team = activeBattleContext.SectionA.Team end)
                local currentRotID = nil
                pcall(function() currentRotID = activeBattleContext.SectionA.BattleRot.RotInstance.UniqueID end)

                local bestIndex, bestDamage = nil, ourDamage
                for i, rot in pairs(team) do
                    if rot and rot.Health and rot.Health > 0 and rot.UniqueID ~= currentRotID then
                        local dmg = 0
                        pcall(function() dmg = Core.Formula.CalculateBaseDamage(rot) end)
                        if dmg > bestDamage then bestIndex, bestDamage = i, dmg end
                    end
                end

                if bestIndex and shouldSend("Switch:" .. bestIndex) then
                    print("[CAB2 DEBUG] Kill mode: switch ke brainrot ter-best (dmg " .. string.format("%.1f", bestDamage) .. " > " .. string.format("%.1f", ourDamage) .. ")")
                    safeOnInput({ Type = "Switch", TeamIndex = bestIndex })
                    local t = 0
                    while t < 10 and Config.AutoFarm and _G.CAB2ScriptActive do
                        local newRotID = nil
                        pcall(function() newRotID = activeBattleContext.SectionA.BattleRot.RotInstance.UniqueID end)
                        if newRotID and newRotID ~= currentRotID then break end
                        task.wait(0.5); t = t + 0.5
                    end
                    task.wait(0.3)
                    continue
                end
            end

            -- Pilih move damage TERTINGGI yang affordable.
            local best = nil
            for _, m in ipairs(moves) do
                if m.Affordable and m.Damage > 0 and (not best or m.Damage > best.Damage) then
                    best = m
                end
            end

            if best then
                if shouldSend("Fight:" .. best.Index) then
                    safeOnInput({ Type = "Fight", MoveIndex = best.Index })
                end
            elseif chargeMove then
                if shouldSend("Fight:" .. chargeMove.Index) then
                    safeOnInput({ Type = "Fight", MoveIndex = chargeMove.Index })
                end
            end
        end

        if justThrewBall then
            justThrewBall = false
            print("[CAB2 DEBUG] Ball thrown, waiting for MyRots.Changed...")
            local caught = waitForTeamChanged(5)
            catchInProgress = false
            if caught then
                caughtThisBattle = true
                print("[CAB2 DEBUG][CATCH RESULT] BERHASIL nangkep", tostring(targetSpeciesName), "-- MyRots.Changed fired, closing battle.")
                notif("Berhasil nangkep " .. tostring(targetSpeciesName) .. "!", 3, "Napoleon | CAB")
                destroyBattleContext(true)
                break
            end
            if not isInBattle() then
                print("[CAB2 DEBUG][CATCH RESULT] Battle ended during catch wait (bukan lewat MyRots.Changed) -- dianggap GAGAL nangkep", tostring(targetSpeciesName))
                break
            end
            print("[CAB2 DEBUG] No team change after 5s -- catch failed, continuing fight")
            -- Tunggu animasi "broke free" selesai sebelum retry
            task.wait(2)
            continue
        end

        task.wait(0.5)
    end
    -- Battle selesai (loop keluar) -- log dulu KENAPA loop-nya berhenti
    -- (biar ketauan kalau kejadian lagi: contextValid() gak lolos, atau
    -- AutoFarm/script dimatiin), baru pastikan context di-destroy bersih.
    print("[CAB2 DEBUG] runAutoBattle loop berhenti -- contextValid():", tostring(contextValid()), "| AutoFarm:", tostring(Config.AutoFarm), "| ScriptActive:", tostring(_G.CAB2ScriptActive))
    if Config.BattleMode == "Catch" and not caughtThisBattle then
        print("[CAB2 DEBUG][CATCH RESULT] GAGAL nangkep", tostring(targetSpeciesName), "-- battle berhenti tanpa MyRots.Changed.")
        notif("Gagal nangkep " .. tostring(targetSpeciesName) .. ".", 3, "Napoleon | CAB")
    end
    destroyBattleContext()
end

-- ============================================================
-- AUTO FARM LOOP
-- ============================================================
-- NOTE: bagian battle/catch (lempar ball, dsb) belum diisi di sini —
-- fokus revisi ini cuma di sistem targeting + trigger encounter di atas.
-- Kalau udah masuk battle, loop nunggu battle selesai dulu.
local farmActive  = false
local ignoredRots = {}

local function startFarmLoop()
    if farmActive then return end
    farmActive = true
    local emptyScanStart = nil

    task.spawn(function()
        notif("Auto Farm dimulai!", 3, "Napoleon | CAB")

        while Config.AutoFarm and _G.CAB2ScriptActive do
            if not isAlive() then
                task.wait(1)
                continue
            end

            if isInBattle() then
                runAutoBattle()
                print("[CAB2 DEBUG] Battle done (isInBattle path)")
                task.wait(1)
                continue
            end

            local targets = getFarmTargets()

            local filtered = {}
            for _, t in ipairs(targets) do
                if not ignoredRots[t.ID] then
                    table.insert(filtered, t)
                end
            end

            if #filtered == 0 then
                if next(ignoredRots) then ignoredRots = {} end
                if Config.AutoHop then
                    if not emptyScanStart then
                        emptyScanStart = os.clock()
                    elseif os.clock() - emptyScanStart >= Config.AutoHopTimeout then
                        emptyScanStart = os.clock() -- reset biar gak spam nyoba hop tiap loop kalau hop pertama gagal
                        hopServer()
                    end
                end
                task.wait(1)
                continue
            end
            emptyScanStart = nil

            -- Gak perlu "terdekat" lagi -- kita gak jalan kemana-mana, jadi
            -- ambil target pertama yang lolos filter aja.
            local target = filtered[1]
            ignoredRots[target.ID] = true

            notif(target.Species .. " (" .. target.Rarity .. ")", 2, "Target")

            -- Simpan reference rot LIVE buat dibaca HP-nya di battle loop
            activeTargetRot = target.Rot
            activeTargetContainerID = target.ContainerID
            activeTargetRotID = target.ID

            local battleInfo = requestCatch(target)

            if battleInfo then
                if openBattleUI(battleInfo) then
                    notif("Battle dimulai! Mode: " .. tostring(Config.BattleMode), 3, "Napoleon | CAB")
                    runAutoBattle()
                    print("[CAB2 DEBUG] Battle done")
                    task.wait(1)
                    task.wait(0.5)
                    continue
                else
                    notif("Gagal buka layar battle buat " .. target.Species, 3, "Napoleon | CAB")
                end
            end

            task.wait(0.5)
        end

        farmActive = false
        notif("Auto Farm dihentikan.", 3, "Napoleon | CAB")
    end)
end

-- ============================================================
-- AUTO HEAL LOOP (100% sama persis kayak Catch A Brainrot.lua)
-- ============================================================
local autoHealActive = false
-- Sumber kebenaran team dipindah ke Brainrot.Rot.MyRots.Team (live,
-- ke-sync otomatis) -- BUKAN InitialInfo.Client yang cuma snapshot SEKALI
-- pas login (gak pernah ke-update lagi walau HP berubah), soalnya
-- HealSection.lua (script asli game) SENDIRI baca dari MyRots.Team.
local function performHealCheck()
    local healed = false
    pcall(function()
        local team = MyRotsModule and MyRotsModule.Team
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

        -- Patch HP pake MyRots.FindRot(uniqueId) -- exact sama kayak
        -- HealSection.lua asli, bukan cocokin index antar 2 snapshot beda.
        local patchedCount = 0
        for uniqueId, hp in pairs(newHps) do
            local rot = MyRotsModule.FindRot(uniqueId)
            if rot then
                rot.Health = hp
                patchedCount = patchedCount + 1
            end
        end

        if patchedCount > 0 then
            pcall(function() MyRotsModule.Changed:Fire() end)
            pcall(function() require(ReplicatedStorage.Brainrot.Tutorial.MyMetadata).OnHeal() end)
            healed = true
        end
    end)
    return healed
end

local function startAutoHealLoop()
    if autoHealActive then return end
    autoHealActive = true
    task.spawn(function()
        while Config.AutoHeal and _G.CAB2ScriptActive do
            if performHealCheck() then
                notif("Brainrot berhasil diheal/dihidupkan!", 3, "Auto Heal")
            end
            task.wait(3)
        end
        autoHealActive = false
    end)
end

-- (Auto Skip Dialog loop has been integrated into runAutoBattle)

-- ============================================================
-- FAST BATTLE ANIMATION
-- Semua animasi timed di battle (impact, catch anim, energy bar, dll)
-- lewat AnimUtils.Heartbeat, yang ternyata cuma re-export langsung dari
-- Modules.Heartbeat -- constructor ini bikin objek dengan field .Speed
-- (default 1) yang ngali deltaTime tiap frame. Ini MURNI visual timing,
-- gak nyentuh logic/hasil battle sama sekali (skill tetep manual).
--
-- Kita hookfunction constructor-nya: tiap kali ada animasi timed BARU
-- dibikin SELAGI lagi battle, langsung naikin .Speed-nya. Butuh executor
-- yang support hookfunction/newcclosure (Synapse X, Script-Ware, dst) --
-- kalau gak ada, fitur ini otomatis nonaktif dengan notif, gak nge-crash.
-- ============================================================
-- 20 = animasi elapsed 20x lebih cepat. Sempat dicoba 9999 tapi ada yang
-- ketunda/janggal, jadi dibalikin ke 20 (nilai yang udah kebukti aman).
local FAST_BATTLE_MULTIPLIER = 20

local HeartbeatModule = nil
pcall(function()
    HeartbeatModule = require(ReplicatedStorage.Modules.Heartbeat)
end)

-- Brainrot.Battle.Utils.Skipping adalah flag BAWAAN game buat skip animasi --
-- dipakai langsung di Attacks.lua (10x), Trainer.lua (10x), CatchAnim lewat
-- Utils.BaseStep (5x), MasterballAnim.lua, BlowupIntoCoinsEffect.lua, dll.
-- Ini yang BENERAN ngatur animasi lempar-ball & nyerang -- Modules.Heartbeat
-- CUMA buat elemen timed generik (energy bar dsb), makanya sebelumnya animasi
-- utama tetep gak instant walau Heartbeat udah di-hook. Game reset flag ini
-- ke false tiap kali mulai animasi baru, jadi kita paksa true terus tiap
-- frame lewat loop kecil selagi battle & fitur ini aktif.
local BattleUtils = nil
pcall(function()
    BattleUtils = require(ReplicatedStorage.Brainrot.Battle.Utils)
end)

-- KONFIRMASI dari source: Attacks.lua ("PlayAttack") dan
-- Trainer/CatchAnim.lua RESET Utils.Skipping = false LANGSUNG di baris
-- pertama tiap kali animasi baru mulai -- loop paksa "Skipping=true" di
-- atas balapan sama reset ini (ada jeda dikit tiap awal animasi sampe
-- loop-nya sempat nyalain balik). Hook 2 titik ini biar Skipping=true
-- dipasang LANGSUNG di frame yang sama animasinya mulai, ngilangin jeda
-- itu -- ini paling maksimal yang aman dilakuin (BUKAN metode spam-input/
-- InputListenerFlag, itu keliatan resiko numpuk lagi bug "Listener exist"
-- yang baru aja dibenerin).
local AttacksModule = nil
pcall(function()
    AttacksModule = require(ReplicatedStorage.Brainrot.Battle.Attacks)
end)
local CatchAnimModule = nil
pcall(function()
    CatchAnimModule = require(ReplicatedStorage.Brainrot.Battle.Trainer.CatchAnim)
end)

local fastBattleOriginal   = nil
local fastBattleHooked     = false
local fastBattleSkipActive = false
local attacksOriginal      = nil
local attacksHooked        = false
local catchAnimOriginal    = nil
local catchAnimHooked      = false

local function setFastBattleAnim(enabled)
    if not HeartbeatModule and not BattleUtils then
        if enabled then
            notif("Gagal pasang Fast Battle -- module game gak ketemu.", 4, "Fast Battle")
        end
        return
    end

    if enabled and BattleUtils and not fastBattleSkipActive then
        fastBattleSkipActive = true
        task.spawn(function()
            while fastBattleSkipActive and _G.CAB2ScriptActive do
                if isInBattle() and not catchInProgress then
                    -- Cuma paksa Skipping selama BUKAN giliran milih aksi
                    -- (uiState == "MENU") -- kalau dipaksa true 24/7 termasuk
                    -- pas lagi nunggu keputusan kita, kemungkinan ganggu
                    -- bookkeeping giliran/input di server (diduga jadi salah
                    -- satu penyebab input kita ke-reject/HP-energy UI macet).
                    local uiState = nil
                    if activeBattleContext then
                        pcall(function() uiState = activeBattleContext.UI.UIState end)
                    end
                    if uiState ~= "MENU" then
                        pcall(function() BattleUtils.Skipping = true end)
                    end
                end
                task.wait()
            end
        end)
    elseif not enabled then
        fastBattleSkipActive = false
    end

    if not (hookfunction and newcclosure) then
        if enabled then
            notif("Executor kamu gak support hookfunction -- sebagian fitur Fast Battle gak bisa jalan.", 4, "Fast Battle")
        end
        return
    end

    if HeartbeatModule then
        if enabled and not fastBattleHooked then
            local ok = pcall(function()
                fastBattleOriginal = hookfunction(HeartbeatModule, newcclosure(function(...)
                    local obj = fastBattleOriginal(...)
                    if obj and isInBattle() then
                        pcall(function() obj.Speed = FAST_BATTLE_MULTIPLIER end)
                    end
                    return obj
                end))
            end)
            fastBattleHooked = ok
            if not ok then
                notif("Gagal pasang Fast Battle (hookfunction error).", 4, "Fast Battle")
            end
        elseif not enabled and fastBattleHooked and fastBattleOriginal then
            pcall(function()
                hookfunction(HeartbeatModule, fastBattleOriginal)
            end)
            fastBattleHooked = false
        end
    end

    -- Hook PlayAttack -- langsung paksa Skipping=true LAGI abis game
    -- reset ke false di baris pertamanya, ngilangin jeda 1-frame yang
    -- sebelumnya cuma diandelin loop task.wait() buat nyusul.
    if AttacksModule and AttacksModule.PlayAttack then
        if enabled and not attacksHooked then
            local ok = pcall(function()
                attacksOriginal = hookfunction(AttacksModule.PlayAttack, newcclosure(function(...)
                    local result = attacksOriginal(...)
                    if isInBattle() then
                        pcall(function() BattleUtils.Skipping = true end)
                    end
                    return result
                end))
            end)
            attacksHooked = ok
        elseif not enabled and attacksHooked and attacksOriginal then
            pcall(function() hookfunction(AttacksModule.PlayAttack, attacksOriginal) end)
            attacksHooked = false
        end
    end

    -- Hook CatchAnim -- sama persis alasannya kayak PlayAttack di atas,
    -- CUMA buat animasi lempar-ball (module-nya sendiri LANGSUNG sebuah
    -- function, bukan dibungkus table).
    if CatchAnimModule then
        if enabled and not catchAnimHooked then
            local ok = pcall(function()
                catchAnimOriginal = hookfunction(CatchAnimModule, newcclosure(function(...)
                    local result = catchAnimOriginal(...)
                    if isInBattle() then
                        pcall(function() BattleUtils.Skipping = true end)
                    end
                    return result
                end))
            end)
            catchAnimHooked = ok
        elseif not enabled and catchAnimHooked and catchAnimOriginal then
            pcall(function() hookfunction(CatchAnimModule, catchAnimOriginal) end)
            catchAnimHooked = false
        end
    end
end

-- ============================================================
-- SHOP -- beli ball pake Coins/Ice Coins (KONFIRMASI dari source game):
-- ReplicatedStorage.Brainrot.ShopViewer.lua fungsi AttemptPurchase(itemName,
-- worldIndex) manggil remote:
--   ReplicatedStorage.Brainrot.ShopViewer.__server__.AttemptPurchase
--     :InvokeServer(itemName, worldIndex)
-- Cuma beli 1 biji per panggilan (gak ada parameter quantity), jadi buat
-- beli banyak kita panggil berkali-kali. Harga DIHITUNG DINAMIS lewat
-- Core.FormulaV2.CalculateBallPriceCurrency(ballName) -> {Amount,
-- CurrencyType} (BUKAN tabel harga statis) -- konfirmasi dari
-- ShopViewer/ShopCategories.lua. worldIndex nentuin ball itu masuk tab
-- shop yang mana (1 = Rot/Silver/Gold Box, 2 = Snow/Snowman/Miner/Frozen
-- Box), diambil dari Core.BallInfos.WorldBalls[1]/[2].
--
-- CUMA 7 ball ini yang bisa dibeli pake Coins lewat remote ini -- Infinity
-- Box Robux-only (developer product, BUKAN kita otomasi -- itu duit
-- beneran, harus manual lewat prompt Roblox sendiri), Crystal Box dibeli
-- lewat remote TERPISAH (WheelArea, pake "Ice Shard"), Rare/Epic/Demon Box
-- CUMA didapat dari Lucky Block (gacha Robux), gak ada remote beli
-- langsungnya sama sekali -- makanya gak dimasukin ke daftar ini.
local SHOP_BALLS = {}
pcall(function()
    for worldIndex, list in ipairs(Core.BallInfos.WorldBalls) do
        for _, ballInfo in ipairs(list) do
            table.insert(SHOP_BALLS, { Name = ballInfo.Name, World = worldIndex })
        end
    end
end)

local function getShopBallWorld(ballName)
    for _, b in ipairs(SHOP_BALLS) do
        if b.Name == ballName then return b.World end
    end
    return nil
end

local function getBallPrice(ballName)
    local amount, currencyType = nil, nil
    pcall(function()
        local price = Core.FormulaV2.CalculateBallPriceCurrency(ballName)
        amount = price.Amount
        currencyType = price.CurrencyType
    end)
    return amount, currencyType
end

local function getCurrencyBalance(currencyType)
    if not MyBagModule then return nil end
    local bal = nil
    pcall(function() bal = MyBagModule.Bag[currencyType] end)
    return bal or 0
end

-- Beli 1 biji. Return true/false + pesan buat notif/debug.
local function buyBallOnce(ballName)
    local worldIndex = getShopBallWorld(ballName)
    if not worldIndex then
        return false, "Ball ini gak bisa dibeli pake Coins (cek tab Shop buat daftar yang bisa)."
    end
    local shopRemote = ReplicatedStorage.Brainrot:FindFirstChild("ShopViewer")
        and ReplicatedStorage.Brainrot.ShopViewer:FindFirstChild("__server__")
        and ReplicatedStorage.Brainrot.ShopViewer.__server__:FindFirstChild("AttemptPurchase")
    if not (shopRemote and shopRemote:IsA("RemoteFunction")) then
        return false, "Remote shop gak ketemu."
    end
    local ok, result = pcall(function()
        return shopRemote:InvokeServer(ballName, worldIndex)
    end)
    if not ok then
        return false, "Error: " .. tostring(result)
    end
    if result then
        return true, "OK"
    end
    return false, "Ditolak server (kemungkinan Coins gak cukup)."
end

-- ============================================================
-- UI SETUP (Napoleon Library)
-- ============================================================
local Window = Library:Window({
    Title    = "Napoleon",
    Footer   = "Catch A Brainrot",
    Color    = Color3.fromRGB(81, 66, 255),
    Color2   = Color3.fromRGB(0, 0, 14),
    ["Tab Width"] = 130,
    Image      = "111895858615511",
    WindowIMG  = "91334002283698",
    LogoHUB    = "136289055140268"
})
local Tabs = Window

local function LoadMainTab()
-- TAB MAIN
local MainTab = Tabs:AddTab({ Name = "Main", Icon = "rod" })

-- ============================================================
-- SECTION: AUTO FARM -- semua dropdown dulu, baru input, baru toggle
-- (kecuali Auto Hop, itu section sendiri di bawah)
-- ============================================================
local FarmSection = MainTab:AddSection("Auto Farm")

-- Dropdown filter ditaruh DI ATAS toggle Enable -- sengaja, biar filter yang
-- kepilih dulu baru "Enable Auto Farm" di-nyalain. Config di-update langsung
-- (synchronous) tiap dropdown di-klik, jadi kalau urutannya begini, saat
-- toggle dinyalain, Config.TargetRot/TargetRarity udah pasti kepake dari
-- pencarian PERTAMA -- gak ada celah buat kepilih Common secara gak sengaja.
local TargetRotDropdown
TargetRotDropdown = FarmSection:AddDropdown({
    Title    = "Target Rot",
    Content  = "Pilih Brainrot target (None = semua)",
    Options  = ROT_LIST,
    Default  = {"None"},
    Multi    = true,
    Callback = function(val)
        Config.TargetRot = handleDropdownChange(val, TargetRotDropdown)
    end
})

local TargetRarityDropdown
TargetRarityDropdown = FarmSection:AddDropdown({
    Title    = "Target Rarity",
    Content  = "Filter rarity (None = semua rarity)",
    Options  = RARITY_LIST,
    Default  = {"None"},
    Multi    = true,
    Callback = function(val)
        Config.TargetRarity = handleDropdownChange(val, TargetRarityDropdown)
    end
})

FarmSection:AddDropdown({
    Title    = "Battle Mode",
    Content  = "Catch = lemahkan tanpa bunuh lalu tangkap | Kill = serang pake damage terbesar",
    Options  = {"Catch", "Kill"},
    Default  = "Catch",
    Multi    = false,
    Callback = function(val)
        if type(val) == "table" then val = val[1] end
        Config.BattleMode = val or "Catch"
    end,
})

FarmSection:AddDropdown({
    Title    = "Ball Type",
    Content  = "Ball yang dipakai buat nangkep (cuma kepakai di mode Catch). 'Best Ball' = otomatis pilih ball yang kita PUNYA dengan peluang tangkep tertinggi buat musuh saat itu.",
    Options  = BALL_TYPE_OPTIONS,
    Default  = "Rot Box",
    Multi    = false,
    Callback = function(val)
        if type(val) == "table" then val = val[1] end
        Config.BallType = val or "Rot Box"
    end,
})

FarmSection:AddInput({
    Title    = "Catch Threshold",
    Content  = "Persentase lempar bola (misal: 0.99 = 99%). Set tinggi untuk paksa weaken sampai 1 HP.",
    Default  = tostring(Config.CatchThreshold),
    Callback = function(val)
        local num = tonumber(val)
        if num then
            Config.CatchThreshold = num
            print("[CAB2 DEBUG] CatchThreshold diubah menjadi:", num)
        end
    end,
})

FarmSection:AddToggle({
    Title    = "Enable Auto Farm",
    Title2   = "Enable",
    Content  = "Atur Target Rot/Rarity/Mode di atas dulu sebelum nyalain ini. Langsung battle otomatis, gak perlu TP.",
    Default  = false,
    Callback = function(val)
        Config.AutoFarm = val
        if val then startFarmLoop() end
    end
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

FarmSection:AddToggle({
    Title    = "Fast Battle Animation",
    Content  = "Percepat animasi battle (impact/catch/dll) -- hasil/odds battle gak berubah, cuma nunggu animasinya doang",
    Default  = false,
    Callback = function(val)
        setFastBattleAnim(val)
    end,
})

-- ============================================================
-- SECTION: AUTO HOP -- pindah server kalau target gak ketemu
-- ============================================================
local AutoHopSection = MainTab:AddSection("Auto Hop")

AutoHopSection:AddToggle({
    Title    = "Auto Hop",
    Content  = "Kalau target (sesuai Target Rot/Rarity) gak ketemu di server ini, pindah server otomatis (butuh auto-execute di executor biar Auto Farm lanjut sendiri abis pindah).",
    Default  = false,
    Callback = function(val)
        Config.AutoHop = val
    end,
})

AutoHopSection:AddInput({
    Title    = "Auto Hop Timeout (detik)",
    Content  = "Berapa lama nunggu gak ada target sebelum pindah server",
    Default  = tostring(Config.AutoHopTimeout),
    Callback = function(val)
        local num = tonumber(val)
        if num and num >= 5 then
            Config.AutoHopTimeout = num
        end
    end,
})

end

local shopAutoBuyActive = false

-- Loop belanja terus-menerus selama toggle nyala & Coins/Ice Coins cukup --
-- gak kepotong sama "Jumlah" (itu cuma buat tombol "Beli Sekarang" manual).
-- Notif di-batch tiap 10x beli biar gak numpuk kalau lagi belanja cepat.
local function startShopAutoBuy(getSelectedBall)
    if shopAutoBuyActive then return end
    shopAutoBuyActive = true
    task.spawn(function()
        notif("Auto Buy dimulai!", 3, "Shop")
        local boughtSinceNotif = 0
        while Config.ShopAutoBuy and _G.CAB2ScriptActive do
            local ballName = getSelectedBall()
            local amount, currencyType = getBallPrice(ballName)
            if amount and currencyType and getCurrencyBalance(currencyType) >= amount then
                local ok, msg = buyBallOnce(ballName)
                print("[CAB2 DEBUG][SHOP] Auto-buy", ballName, "-> ok:", ok, "|", msg)
                if ok then
                    boughtSinceNotif = boughtSinceNotif + 1
                    if boughtSinceNotif >= 10 then
                        notif("Auto Buy: berhasil beli " .. boughtSinceNotif .. "x " .. ballName .. "!", 3, "Shop")
                        boughtSinceNotif = 0
                    end
                end
            end
            task.wait(0.5)
        end
        if boughtSinceNotif > 0 then
            notif("Auto Buy: berhasil beli " .. boughtSinceNotif .. "x lagi, berhenti.", 3, "Shop")
        end
        shopAutoBuyActive = false
    end)
end

-- ============================================================
-- AUTO SELL -- KONFIRMASI dari source: GenericRotSelector/Context.lua
-- SellSelected -> ReplicatedStorage.Brainrot.Sell.Server.RequestSell
-- :InvokeServer(uniqueIDsArray), balikin {Type="Success"} atau
-- {Type="Fail", ErrorCode="TeamAliveRot", ...} (server nolak kalau bakal
-- ngejual SEMUA anggota tim yang masih hidup). Dijual SATU-SATU (bukan
-- bulk sekaligus) -- kalau bulk terus salah 1 kena TeamAliveRot, KEMUNGKINAN
-- SELURUH batch ke-reject (gak ada cara tau server nolak yang mana doang),
-- jadi satu-satu lebih aman: yang gagal cuma skip itu doang, yang lain
-- tetep kejual.
--
-- SAFETY: brainrot yang kejual GAK BISA balik lagi. Kalau Target Rarity
-- DAN Target Name dua-duanya "None" bareng, JANGAN match apapun -- jangan
-- sampai nyalain toggle tanpa filter jelas malah ngejual SEMUA brainrot.
local function autoSellMatchesFilter(speciesName, rarityName)
    local filterRarity = Config.AutoSellRarity or {"None"}
    local filterName = Config.AutoSellName or {"None"}
    local isRarityNone = (#filterRarity == 0) or (filterRarity[1] and trim(filterRarity[1]) == "None")
    local isNameNone = (#filterName == 0) or (filterName[1] and trim(filterName[1]) == "None")
    if isRarityNone and isNameNone then return false end

    local rarityMatch = isRarityNone
    if not isRarityNone then
        for _, target in ipairs(filterRarity) do
            if string.lower(trim(rarityName)) == string.lower(trim(target)) then
                rarityMatch = true
                break
            end
        end
    end

    local nameMatch = isNameNone
    if not isNameNone then
        for _, target in ipairs(filterName) do
            if string.lower(trim(speciesName)) == string.lower(trim(target)) then
                nameMatch = true
                break
            end
        end
    end

    return rarityMatch and nameMatch
end

local function getAutoSellTargets()
    local results = {}
    pcall(function()
        local team = (MyRotsModule and MyRotsModule.Team) or {}
        local pc = (MyRotsModule and MyRotsModule.PC) or {}
        for _, rot in pairs(team) do
            if rot and rot.UniqueID and autoSellMatchesFilter(rot.Name, getRarity(rot.Name)) then
                table.insert(results, rot)
            end
        end
        for _, rot in pairs(pc) do
            if rot and rot.UniqueID and autoSellMatchesFilter(rot.Name, getRarity(rot.Name)) then
                table.insert(results, rot)
            end
        end
    end)
    return results
end

local autoSellActive = false

local function startAutoSellLoop()
    if autoSellActive then return end
    autoSellActive = true
    task.spawn(function()
        notif("Auto Sell dimulai!", 3, "Inventory")
        while Config.AutoSellEnabled and _G.CAB2ScriptActive do
            local targets = getAutoSellTargets()
            if #targets == 0 then
                task.wait(3)
                continue
            end

            local sellRemote = ReplicatedStorage.Brainrot:FindFirstChild("Sell")
                and ReplicatedStorage.Brainrot.Sell:FindFirstChild("Server")
                and ReplicatedStorage.Brainrot.Sell.Server:FindFirstChild("RequestSell")

            local soldCount = 0
            for _, rot in ipairs(targets) do
                if not (Config.AutoSellEnabled and _G.CAB2ScriptActive) then break end
                if sellRemote and sellRemote:IsA("RemoteFunction") then
                    local ok, result = pcall(function()
                        return sellRemote:InvokeServer({ rot.UniqueID })
                    end)
                    if ok and result and result.Type == "Success" then
                        pcall(function() MyRotsModule.DeleteRots({ rot }) end)
                        soldCount = soldCount + 1
                        print("[CAB2 DEBUG][SELL] Jual", rot.Name, "OK")
                    else
                        local errMsg = (ok and result and (result.ErrorCode or result.Message)) or tostring(result)
                        print("[CAB2 DEBUG][SELL] Gagal jual", rot.Name, ":", tostring(errMsg))
                    end
                end
                task.wait(0.3)
            end

            if soldCount > 0 then
                notif("Auto Sell: berhasil jual " .. soldCount .. " brainrot!", 3, "Inventory")
            end
            task.wait(2)
        end
        autoSellActive = false
    end)
end

local function LoadShopTab()
-- TAB INVENTORY (dulu "Shop") -- Beli Ball + Auto Sell
local ShopTab = Tabs:AddTab({ Name = "Inventory", Icon = "shopping-cart" })
local ShopSection = ShopTab:AddSection("Beli Ball")

local shopBallNames = {}
for _, b in ipairs(SHOP_BALLS) do table.insert(shopBallNames, b.Name) end

local selectedShopBall = shopBallNames[1] or "Rot Box"
local buyQuantity = 1

ShopSection:AddDropdown({
    Title    = "Ball",
    Content  = "Pilih ball yang mau dibeli (cuma yang bisa dibeli pake Coins/Ice Coins)",
    Options  = shopBallNames,
    Default  = selectedShopBall,
    Multi    = false,
    Callback = function(val)
        if type(val) == "table" then val = val[1] end
        selectedShopBall = val or selectedShopBall
    end,
})

ShopSection:AddInput({
    Title    = "Jumlah",
    Content  = "Berapa biji yang mau dibeli sekali pencet",
    Default  = "1",
    Callback = function(val)
        local num = tonumber(val)
        if num and num >= 1 then
            buyQuantity = math.floor(num)
        end
    end,
})

ShopSection:AddButton({
    Title    = "Beli Sekarang",
    Content  = "Beli ball yang dipilih sebanyak jumlah di atas -- gak perlu buka shop manual",
    Callback = function()
        task.spawn(function()
            local ballName = selectedShopBall
            local amount, currencyType = getBallPrice(ballName)
            if amount and currencyType then
                local balance = getCurrencyBalance(currencyType)
                local totalCost = amount * buyQuantity
                if balance < totalCost then
                    notif(string.format("%s x%d butuh %d %s, kamu cuma punya %d.", ballName, buyQuantity, totalCost, tostring(currencyType), balance), 4, "Shop")
                    print("[CAB2 DEBUG][SHOP] Gagal -- Coins gak cukup:", ballName, "butuh", totalCost, tostring(currencyType), "punya", balance)
                    return
                end
            end
            notif("Beli " .. buyQuantity .. "x " .. ballName .. "...", 2, "Shop")
            local successCount = 0
            for i = 1, buyQuantity do
                local ok, msg = buyBallOnce(ballName)
                print("[CAB2 DEBUG][SHOP] Beli", ballName, i .. "/" .. buyQuantity, "-> ok:", ok, "|", msg)
                if ok then
                    successCount = successCount + 1
                else
                    notif("Beli " .. ballName .. " berhenti (" .. successCount .. "/" .. buyQuantity .. "): " .. msg, 3, "Shop")
                    break
                end
                task.wait(0.2)
            end
            if successCount == buyQuantity then
                notif("Berhasil beli " .. successCount .. "x " .. ballName .. "!", 3, "Shop")
            end
        end)
    end,
})

ShopSection:AddToggle({
    Title    = "Auto Buy",
    Content  = "Terus-menerus beli Ball yang dipilih di atas selama Coins/Ice Coins cukup -- gak perlu pencet 'Beli Sekarang' berkali-kali.",
    Default  = false,
    Callback = function(val)
        Config.ShopAutoBuy = val
        if val then
            startShopAutoBuy(function() return selectedShopBall end)
        end
    end,
})

-- ============================================================
-- AUTO SELL
-- ============================================================
local AutoSellSection = ShopTab:AddSection("Auto Sell")

local AutoSellRarityDropdown
AutoSellRarityDropdown = AutoSellSection:AddDropdown({
    Title    = "By Rarity",
    Content  = "Jual otomatis brainrot dengan rarity ini (None = jangan filter rarity)",
    Options  = RARITY_LIST,
    Default  = {"None"},
    Multi    = true,
    Callback = function(val)
        Config.AutoSellRarity = handleDropdownChange(val, AutoSellRarityDropdown)
    end
})

local AutoSellNameDropdown
AutoSellNameDropdown = AutoSellSection:AddDropdown({
    Title    = "By Name",
    Content  = "Jual otomatis brainrot dengan nama ini (None = jangan filter nama)",
    Options  = ROT_LIST,
    Default  = {"None"},
    Multi    = true,
    Callback = function(val)
        Config.AutoSellName = handleDropdownChange(val, AutoSellNameDropdown)
    end
})

AutoSellSection:AddToggle({
    Title    = "Auto Sell",
    Title2   = "Enable",
    Content  = "AWAS: brainrot yang kejual GAK BISA balik lagi. Atur By Rarity/By Name dulu sebelum nyalain -- kalau dua-duanya 'None', gak bakal jual apapun (safety, biar gak ke-jual semua gak sengaja).",
    Default  = false,
    Callback = function(val)
        Config.AutoSellEnabled = val
        if val then startAutoSellLoop() end
    end,
})

end

local function LoadMiscTab()
    local MiscTab = Tabs:AddTab({ Name = "Misc", Icon = "settings" })
    local AntiAfkSection = MiscTab:AddSection("Anti AFK")
    
    AntiAfkSection:AddToggle({
        Title    = "Enable Anti AFK",
        Title2   = "Anti AFK",
        Content  = "Mencegah kamu di-kick atau di-reconnect otomatis oleh game setelah diam lama.",
        Default  = false,
        Callback = function(val)
            Config.AntiAFK = val
        end
    })
end

LoadMainTab()
LoadShopTab()
LoadMiscTab()

-- ============================================================
-- DONE
-- ============================================================
notif("Napoleon | Catch A Brainrot v2 loaded!", 5, "Napoleon")
print("[Napoleon CAB2] Script loaded!")
