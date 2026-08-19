local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Sama kayak pola di Gag2.lua: cegah toggle yang di-restore otomatis mulai loop
-- SEBELUM semua dropdown filter di section yang sama sempat ke-restore juga. Baru
-- jadi true di paling bawah script, setelah semua UI + restore selesai settle.
local UI_LOADED = false

-- PENTING: queue_on_teleport di Potassium ternyata GAK sekali-pakai -- begitu
-- dititipkan sekali (misal buat Server Hop/Anti AFK), dia TERUS nempel dan ke-jalanin
-- lagi di teleport BERIKUTNYA juga -- termasuk pas user RELOG MANUAL sendiri (bukan
-- gara-gara script kita). Makanya "auto exec" kejadian padahal bukan kita yang hop.
-- Fix: clear queue-nya SEKALI di paling awal tiap kali script ini jalan -- baru nanti
-- kalau kita BENERAN mau hop (queueSelfForTeleport), dititipkan ulang secara sengaja.
pcall(function()
    local queueFunc = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport)
    if queueFunc then
        pcall(queueFunc, "")
    end
end)

-- ============================================================
-- GLOBAL ZOMBIE MODE (INVINCIBILITY)
-- ============================================================
-- Hilangkan efek darah merah berkedip saat kena damage
pcall(function()
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
end)

local function setupInvincibility(humanoid)
    if not humanoid then return end

    local healthConn

    -- Step 1: Disable state mati
    pcall(function()
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    end)

    -- Step 2: Listener saat "mati"
    humanoid.Died:Connect(function()

        local maxHp = humanoid.MaxHealth
        healthConn = RunService.RenderStepped:Connect(function()
            if not humanoid or not humanoid.Parent then
                if healthConn then healthConn:Disconnect() end
                return
            end
            humanoid.Health = maxHp
        end)

    end)

    -- Step 3: Picu kematian palsu
    task.spawn(function()
        task.wait(0.05)
        humanoid.Health = 0
    end)
end

task.spawn(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then setupInvincibility(hum) end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    local hum = newChar:WaitForChild("Humanoid", 5)
    if hum then setupInvincibility(hum) end
end)

-- ============================================================
-- TELEPORT BYPASS (SMOOTH BULK MOVE) - THE ULTIMATE BYPASS
-- ============================================================
-- ============================================================
-- ============================================================
-- ============================================================
-- 1. (DIHAPUS) DISABLE GUARDS / DEATH BY HOOKING MODULE
-- ============================================================
-- DULU di sini ada hook GuardAreaLookupUtil.IsInGameplaySide = function() return false end
-- buat nyegah karakter dibunuh Boss/Guard pas Instant Teleport ke area mereka.
--
-- DIHAPUS karena ternyata IsInGameplaySide itu fungsi SHARED yang DIPAKE JUGA sama
-- AreaEggs.client.lua (source game asli) buat nentuin Prompt.Enabled tiap egg:
--     v17 = GuardAreaLookupUtil.IsInGameplaySide(SeparationLine, hrp.Position)
--     ...
--     Prompt.Enabled = v17
-- Hook lama ini bikin fungsi itu SELALU return false ke SIAPA PUN yang manggil --
-- bukan cuma logic guard, tapi ikut bikin PROMPT EGG PERMANEN DISABLED (gak kelihatan
-- sama sekali, gak bisa diambil manual tanpa script). Baru ketauan sekarang karena
-- Auto Steal emang gak butuh Prompt sama sekali (langsung EggCmds.RequestCarryAreaEgg).
--
-- Perlindungan dari efek Guard sekarang udah dicover jauh lebih presisi & lengkap
-- lewat "ANTI GUARD KNOCKBACK" di bawah (collision group, ragdoll module hook, state
-- enforcer, blokir hit-report, blokir egg-drop) -- gak perlu hack fungsi shared ini lagi.

-- ============================================================
-- CONFIGURATION
-- ============================================================
local Config = {
    AutoSteal = false,
    StealAreas = {"None"},
    StealRarities = {"None"},
    AutoStealServerHop = false,
    AntiAFK = true,
    AutoPlace = false,
    PlaceRarities = {"None"},
    AutoHatch = false,
    SellAll = false,
    AutoSell = false,
    SellNames = {"None"},
    SellRarities = {"None"},
    AutoSellEgg = false,
    SellEggRarities = {"None"},
    WebhookEnabled = false,
    WebhookURL = "",
    TweenSpeedMultiplier = 2, -- Live-editable via the "Move Speed Multiplier" input below Auto Steal (max 5)
    AntiTreadmillMount = true, -- Toggle-able lewat "Anti Treadmill Mount" di tab Misc
    AntiGuardKnockback = true, -- Toggle-able lewat "Anti Guard Knockback" di tab Misc
    EggPredictUI = false
}

-- ============================================================
-- ANTI GUARD KNOCKBACK
-- ============================================================
-- PENTING: blok ini HARUS di bawah deklarasi `local Config` di atas -- kalau
-- ditaruh SEBELUM `local Config = {}`, semua referensi Config di dalam fungsi-
-- fungsi ini bakal ke-resolve ke GLOBAL Config (nil) gara-gara lexical scoping
-- Lua, bukan ke local Config yang beneran -- pernah kejadian, bikin runtime
-- error pas fungsinya kepanggil. Jangan pindahin ke atas lagi.
--
-- Guard gak nyimpen field damage/knockback numerik apa pun di config-nya (cek
-- Directory.Guards.Types.Schema) -- jadi gak ada satu angka yang bisa di-spoof
-- kayak trik Health di Zombie Mode. Banyak lapis dipasang sekaligus:
--
-- 1) COLLISION GROUP: guard punya Collider dengan CollisionGroup = "Guards"
--    (lihat ReplicatedStorage.Library.Types.CollisionGroups), game ini juga
--    punya group "GuardsNoCollide" -- kemungkinan besar pairing-nya udah di-setup
--    server, kita masukin karakter kita ke situ.
local guardNoCollideOriginals = {}

local function setGuardNoCollide(character, enable)
    if not character then return end

    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            if enable then
                if guardNoCollideOriginals[descendant] == nil then
                    guardNoCollideOriginals[descendant] = descendant.CollisionGroup
                end
                pcall(function() descendant.CollisionGroup = "GuardsNoCollide" end)
            else
                local original = guardNoCollideOriginals[descendant]
                if original then
                    pcall(function() descendant.CollisionGroup = original end)
                end
            end
        end
    end
end

-- 2) DISABLE STATE "Physics"/"FallingDown"/"Ragdoll"/"PlatformStanding"/"Seated": semua
--    state yang bisa dipakai buat "menjatuhkan" karakter, termasuk yang belum kepake
--    Zombie Mode (yang cuma disable Dead/FallingDown/Ragdoll -- BUKAN Physics, state
--    yang BENERAN dipakai ragdoll di Ragdoll.lua).
local function setGuardRagdollImmune(humanoid, enable)
    if not humanoid then return end
    pcall(function()
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, not enable)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, not enable)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, not enable)
        humanoid.BreakJointsOnDeath = false
    end)
end

-- 3) HOOK SEMUA fungsi Ragdoll module (module biasa, dipanggil pakai titik, jadi bisa
--    langsung di-replace tanpa hookfunction): ApplyClientRagdoll, Ragdoll, TimedRagdoll,
--    TimedRagdollAsync sekaligus -- sebelumnya cuma ApplyClientRagdoll yang di-hook,
--    padahal bisa jadi yang kepake buat guard di area LAIN (bukan Forest) itu salah
--    satu dari fungsi lain ini, bukan ApplyClientRagdoll.
local RagdollModule
do
    local ok, mod = pcall(function()
        return require(game:GetService("ReplicatedStorage").Library.Modules.Ragdoll)
    end)
    if ok and mod then
        RagdollModule = mod
        local originalApplyClientRagdoll = mod.ApplyClientRagdoll
        mod.ApplyClientRagdoll = function(character, impulse)
            if Config.AntiGuardKnockback and character == LocalPlayer.Character then
                return
            end
            return originalApplyClientRagdoll(character, impulse)
        end

        local originalRagdoll = mod.Ragdoll
        mod.Ragdoll = function(character)
            if Config.AntiGuardKnockback and character == LocalPlayer.Character then
                return
            end
            return originalRagdoll(character)
        end

        local originalTimedRagdoll = mod.TimedRagdoll
        mod.TimedRagdoll = function(character, duration, impulse)
            if Config.AntiGuardKnockback and character == LocalPlayer.Character then
                return
            end
            return originalTimedRagdoll(character, duration, impulse)
        end

        local originalTimedRagdollAsync = mod.TimedRagdollAsync
        mod.TimedRagdollAsync = function(character, duration, impulse)
            if Config.AntiGuardKnockback and character == LocalPlayer.Character then
                return
            end
            return originalTimedRagdollAsync(character, duration, impulse)
        end
    else
        warn("[AntiGuardKnockback] Gagal require Ragdoll module buat di-hook:", mod)
    end
end

-- 4) ENFORCER KONTINYU -- jaga Motor6D tetep Enabled, hancurin constraint/attachment
--    ragdoll yang somehow kepasang, dan paksa balik ke Running/GettingUp kalau
--    kedeteksi masuk state "jatuh" apa pun.
--
--    BUG SEBELUMNYA (bikin jalan kedut-kedut): scan SEMUA descendant karakter (Motor6D/
--    constraint/attachment) itu di-lakuin TIAP SATU FRAME Stepped tanpa jeda -- lumayan
--    berat apalagi kalau ada aksesoris/tools nempel, nyumbang ke stutter. Sekarang bagian
--    scan yang berat itu di-throttle (~5x/detik, cukup buat backstop ragdoll yang emang
--    gak butuh instan-instan amat), sementara cek state (murah) tetep tiap frame. Juga
--    di-skip total pas Config.IsStealing aktif -- AutoStealLoop udah punya deteksi
--    drop/cancel sendiri (abortTripIfDropped) yang lebih akurat buat momen itu, dan gak
--    perlu enforcer ini ikut campur pas lagi ditween.
local FALLDOWN_STATES = {
    [Enum.HumanoidStateType.Physics] = true,
    [Enum.HumanoidStateType.FallingDown] = true,
    [Enum.HumanoidStateType.Ragdoll] = true,
    [Enum.HumanoidStateType.PlatformStanding] = true,
    [Enum.HumanoidStateType.Seated] = true
}
local lastRagdollScanAt = 0
RunService.Stepped:Connect(function()
    if not Config.AntiGuardKnockback or Config.IsStealing then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")

    local now = os.clock()
    if now - lastRagdollScanAt >= 0.2 then
        lastRagdollScanAt = now
        for _, descendant in ipairs(char:GetDescendants()) do
            if descendant:IsA("Motor6D") then
                if not descendant.Enabled then
                    descendant.Enabled = true
                end
            elseif descendant:IsA("BallSocketConstraint") or descendant:IsA("HingeConstraint") then
                if descendant:GetAttribute("RagdollConstraint") or descendant.Name:find("Ragdoll") then
                    pcall(function() descendant:Destroy() end)
                end
            elseif descendant:IsA("Attachment") then
                if descendant:GetAttribute("RagdollAttachment") or descendant.Name:find("Ragdoll") then
                    pcall(function() descendant:Destroy() end)
                end
            end
        end
    end

    if hum then
        if hum.PlatformStand then hum.PlatformStand = false end
        if hum.Sit then hum.Sit = false end
        if FALLDOWN_STATES[hum:GetState()] then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
    end
end)

-- 5) VELOCITY DAMPENER: jaga-jaga ada dorongan (AssemblyLinearVelocity/impulse) yang
--    diapply langsung ke RootPart di luar jalur ragdoll yang udah diblokir di atas.
--
--    BUG SEBELUMNYA (kedut-kedut, MAKIN parah abis threshold pertama dinaikin): masih
--    ngebandingin ke WalkSpeed x2 doang, padahal "Move Speed Multiplier" (TweenSpeedMultiplier)
--    bisa sampe 5x -- pas lagi ditween cepat (misal WalkSpeed 300 x multiplier 5 = niat
--    gerak 1500 stud/detik), velocity implisitnya jauh ngelewatin WalkSpeed x2, ke-anggap
--    "dorongan asing" terus-terusan, di-rem paksa tiap frame -> makin kedut. Sekarang:
--    (a) threshold ikut TweenSpeedMultiplier YANG SEBENARNYA dipakai (bukan asumsi x2),
--    (b) di-skip TOTAL pas Config.IsStealing aktif -- itu PERSIS momen kita sengaja
--        gerak cepat lewat tween sendiri, biarin TweenMoveTo + abortTripIfDropped yang
--        pegang kendali penuh, jangan direcokin dampener ini.
local lastGuardCheckVelocity = Vector3.zero
RunService.Heartbeat:Connect(function()
    if not Config.AntiGuardKnockback or Config.IsStealing then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local walkSpeed = (hum and hum.WalkSpeed) or 16
    local multiplier = tonumber(Config.TweenSpeedMultiplier) or 2

    local currentVelocity = hrp.AssemblyLinearVelocity
    local allowedMagnitude = math.max(walkSpeed * multiplier * 1.5, 100)
    local suddenDelta = (currentVelocity - lastGuardCheckVelocity).Magnitude

    if currentVelocity.Magnitude > allowedMagnitude and suddenDelta > 40 then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        currentVelocity = Vector3.zero
    end

    lastGuardCheckVelocity = currentVelocity
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    guardNoCollideOriginals = {}
    local hum = character:WaitForChild("Humanoid", 5)
    if Config.AntiGuardKnockback then
        setGuardNoCollide(character, true)
        setGuardRagdollImmune(hum, true)
    end
    character.DescendantAdded:Connect(function(descendant)
        if Config.AntiGuardKnockback and descendant:IsA("BasePart") then
            if guardNoCollideOriginals[descendant] == nil then
                guardNoCollideOriginals[descendant] = descendant.CollisionGroup
            end
            pcall(function() descendant.CollisionGroup = "GuardsNoCollide" end)
        end
    end)
end)

task.spawn(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid", 5)
    if Config.AntiGuardKnockback then
        setGuardNoCollide(char, true)
        setGuardRagdollImmune(hum, true)
    end
end)

-- 6) BLOKIR HIT REPORT (Forest + Speed): Forest itu satu-satunya area yang guard-nya
--    disimulasikan CLIENT (ForestGuardRuntime.lua) -- Attack handler-nya cuma fire
--    report ke server (Network.Fire(Guards.FOREST_HIT, {...})), gak nge-apply
--    knockback sendiri. Area lain kemungkinan pakai mekanisme "speed" (RequiredSpeedSign
--    / GuardEscapeSignController yang udah ditemuin sebelumnya) -- SPEED_HIT_OFFER dan
--    SPEED_HIT_WARNING itu remote report serupa. Kalau laporan-laporan ini gak pernah nyampe
--    ke server, server gak akan pernah tau kita "kena", jadi gak nge-apply konsekuensinya
--    (knockback ATAU egg drop).
--
-- 7) BLOKIR REQUEST_AREA_EGG_DROP YANG BUKAN INISIATIF KITA SENDIRI: dikonfirmasi dari
--    source asli (EggCmds.lua + Types/AreaEggs.lua) -- egg drop itu SELALU request yang
--    diinisiasi CLIENT lewat EggCmds.RequestDropHeldAreaEgg(reason), dan reason "GuardHit"
--    itu LITERAL ada di DropReasons schema. Artinya "egg jatoh pas kena guard" itu BUKAN
--    server maksa drop sepihak -- itu SATU SCRIPT CLIENT (bukan script kita) yang manggil
--    RequestDropHeldAreaEgg("GuardHit") begitu kena hit. Blokir requestnya di titik
--    Network.Invoke DAN di EggCmds.RequestDropHeldAreaEgg sekaligus (dua lapis, jaga-jaga
--    salah satu ke-bypass) -- cuma reason "PlayerRequest" (atau nil, artinya kita sendiri
--    yang minta lepas) yang dibiarkan lolos.
local function hookGuardNetworkAndEggDrop()
    local ok, err = pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Network = require(ReplicatedStorage.Library.Client.Network)
        local Constants = require(ReplicatedStorage.Library.Globals.Constants)
        local Guards2 = Constants.NETWORK_MAP.Guards
        local Eggs2 = Constants.NETWORK_MAP.Eggs
        local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds)

        local originalFire = Network.Fire
        Network.Fire = function(eventName, ...)
            if Config.AntiGuardKnockback and (eventName == Guards2.FOREST_HIT or eventName == Guards2.SPEED_HIT_OFFER or eventName == Guards2.SPEED_HIT_WARNING) then
                return
            end
            return originalFire(eventName, ...)
        end

        local originalInvoke = Network.Invoke
        Network.Invoke = function(endpoint, args, ...)
            if Config.AntiGuardKnockback and endpoint == Eggs2.REQUEST_AREA_EGG_DROP then
                local reason = typeof(args) == "table" and args.Reason or nil
                if reason ~= nil and reason ~= "PlayerRequest" then
                    return false, "Blocked involuntary egg drop (" .. tostring(reason) .. ")"
                end
            end
            return originalInvoke(endpoint, args, ...)
        end

        local originalRequestDrop = EggCmds.RequestDropHeldAreaEgg
        EggCmds.RequestDropHeldAreaEgg = function(reason)
            if Config.AntiGuardKnockback and reason ~= nil and reason ~= "PlayerRequest" then
                return false, "Blocked involuntary egg drop (" .. tostring(reason) .. ")"
            end
            return originalRequestDrop(reason)
        end
    end)
    if not ok then
        warn("[AntiGuardKnockback] Gagal hook Network/EggCmds buat blokir hit report & egg drop:", err)
    end
end
task.spawn(hookGuardNetworkAndEggDrop)

-- 8) STICKY EGG RE-CARRY (jaring pengaman terakhir): kalau egg yang lagi kita bawa
--    somehow tetep kelepas (lapis manapun di atas gagal), langsung coba ambil ulang
--    dalam <1 detik. FirstAreaSlotKey dihitung ulang pakai AreaEggSlotIdentity yang
--    sama kayak AutoStealLoop -- BUKAN selalu nil kayak versi awal, itu bug yang
--    udah pernah kita fix (server nolak carry diam-diam buat egg "FirstArea" kalau
--    slot key-nya salah). Di-skip kalau Config.IsStealing lagi aktif (AutoStealLoop
--    udah punya retry logic sendiri, jangan sampe rebutan/tabrakan).
local lastHeldEggRecord = nil

local function computeFirstAreaSlotKey(uid, areaId, nestId)
    local ok, AreaEggSlotIdentity = pcall(function()
        return require(game:GetService("ReplicatedStorage").Library.Util.AreaEggSlotIdentity)
    end)
    if not ok or not AreaEggSlotIdentity then return nil end
    local isFirstOk, isFirst = pcall(AreaEggSlotIdentity.IsFirstAreaUid, tostring(uid))
    if isFirstOk and isFirst and type(areaId) == "string" and type(nestId) == "string" then
        local buildOk, built = pcall(AreaEggSlotIdentity.BuildSlotKey, areaId, nestId)
        if buildOk then return built end
    end
    return nil
end

task.spawn(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds)

    while true do
        task.wait(0.1)
        if Config.AntiGuardKnockback and not Config.IsStealing then
            local ok = pcall(function()
                local snapshot = EggCmds.GetAreaEggSnapshot()
                local carriedRecord = nil
                if snapshot and snapshot.Records then
                    for _, record in pairs(snapshot.Records) do
                        if record.State == "Carried" and record.CarrierUserId == LocalPlayer.UserId then
                            carriedRecord = record
                            break
                        end
                    end
                end

                if carriedRecord then
                    lastHeldEggRecord = carriedRecord
                elseif lastHeldEggRecord then
                    local slotKey = computeFirstAreaSlotKey(lastHeldEggRecord.Uid, lastHeldEggRecord.AreaId, lastHeldEggRecord.NestId)
                    EggCmds.RequestCarryAreaEgg(lastHeldEggRecord.Uid, slotKey)
                    lastHeldEggRecord = nil
                end
            end)
            if not ok then
                lastHeldEggRecord = nil
            end
        end
    end
end)

-- ============================================================
-- CATATAN: gak perlu sistem persist custom di sini. NPLN-UIv4.lua (library UI-nya)
-- SUDAH auto-save & auto-restore tiap Toggle/Dropdown ke Napoleon/Config/Napoleon_<gameId>.json
-- dengan sendirinya (lihat ConfigData[configKey] check di AddToggle/AddDropdown).
-- Yang perlu kita tangani sendiri cuma: (1) cegah loop mulai duluan sebelum SEMUA
-- element (termasuk dropdown filter) selesai di-restore -> pakai UI_LOADED gate,
-- dan (2) bikin script ini re-exec abis server hop -> queue_on_teleport di bawah.
-- ============================================================

-- RESUME ABIS TELEPORT (Anti AFK abis idle, ATAU Server Hop di Auto Steal) --
-- SEBELUMNYA coba baca ulang source sendiri dari file lokal (debug.getinfo path),
-- tapi itu SERING GAGAL di executor kayak Potassium yang gak expose path file asli
-- (log "GAGAL ambil source" berkali-kali). Sekarang dipakai cara yang SAMA PERSIS
-- kayak player beneran load script ini pertama kali: loadstring(HttpGet(URL resmi)) --
-- jauh lebih reliable karena gak bergantung sama fitur-fitur executor yang beda-beda.
local RESUME_SCRIPT_URL = "https://napoleonn.net/api/script"

-- Log ke FILE (bukan cuma console) tiap kali queueSelfForTeleport dipanggil -- karena
-- pemicu utamanya (Anti AFK abis 18 menit idle, atau Server Hop) sering kejadian pas
-- user LAGI GAK DI DEPAN LAYAR, jadi gak ada yang bisa liat warn() di console pas itu
-- kejadian. Kalau nanti masih gagal auto-lanjut, tinggal cek isi file ini abis balik.
local ANTIAFK_LOG_PATH = "Napoleon_AntiAFK_Log.txt"
local ANTIAFK_LOG_MAX_LINES = 50

local function logSelfTeleportAttempt(message)
    pcall(function()
        if typeof(writefile) ~= "function" then return end

        -- APPEND (bukan overwrite kayak sebelumnya) -- biar histori kejadiannya kesimpen
        -- semua, gak cuma pesan paling terakhir. Dibatasi ANTIAFK_LOG_MAX_LINES baris
        -- biar gak membengkak kalau dibiarin farming lama.
        local existing = ""
        if typeof(readfile) == "function" and typeof(isfile) == "function" and isfile(ANTIAFK_LOG_PATH) then
            existing = readfile(ANTIAFK_LOG_PATH) or ""
        end

        local lines = {}
        for line in existing:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end
        table.insert(lines, "[" .. os.date("%Y-%m-%d %H:%M:%S") .. "] " .. message)

        while #lines > ANTIAFK_LOG_MAX_LINES do
            table.remove(lines, 1)
        end

        writefile(ANTIAFK_LOG_PATH, table.concat(lines, "\n"))
    end)
end

-- Titipkan resume script (loadstring ulang dari URL resmi, BUKAN baca file lokal)
-- ke queue_on_teleport, supaya begitu landing di server/place baru abis teleport
-- apa pun, executor otomatis nge-run script ini lagi persis kayak pas awal exe --
-- Config-nya sendiri otomatis kebalikin lagi dari save file NPLN-UIv4.lua yang
-- udah ada, jadi Auto Steal/filter rarity/dll lanjut sesuai state terakhir.
local function queueSelfForTeleport()
    local queueFunc = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport)
    if not queueFunc then
        warn("[SelfPersist] Executor gak punya queue_on_teleport! Abis teleport, kamu perlu inject manual lagi.")
        logSelfTeleportAttempt("GAGAL: executor gak punya queue_on_teleport sama sekali.")
        return false
    end

    local keynow = getgenv().Key or _G.Key
    local keyLine = ""
    if keynow then
        keyLine = "getgenv().Key = " .. string.format("%q", tostring(keynow)) .. "\n"
    end
    local resumeScript = keyLine
        .. "getgenv().Fromrejoin = true\n"
        .. "loadstring(game:HttpGet(" .. string.format("%q", RESUME_SCRIPT_URL) .. "))()"

    local qok, qerr = pcall(queueFunc, resumeScript)
    if qok then
        logSelfTeleportAttempt("SUKSES dititipkan (resume via " .. RESUME_SCRIPT_URL .. ").")
        return true
    else
        warn("[SelfPersist] queue_on_teleport gagal:", qerr)
        logSelfTeleportAttempt("GAGAL queue_on_teleport: " .. tostring(qerr))
        return false
    end
end

-- Ambil 1 jobId server PUBLIK lain (BUKAN server kita sekarang) lewat API resmi Roblox
-- (games.roblox.com), buat dipake TeleportToPlaceInstance. PENTING: TeleportService:
-- Teleport(placeId, player) POLOS itu GAK JAMIN pindah server beneran -- bisa aja
-- nyangkut balik ke server yang SAMA (kejadian pas testing, apalagi kalau server
-- publik yang aktif dikit), jadi cuma keliatan "rejoin", bukan "hop". Return nil kalau
-- gagal ambil list (nanti fallback ke Teleport() biasa, mending daripada diem).
local function getRandomOtherServerJobId()
    -- PENTING: endpoint ini minta PLACE ID langsung di URL-nya, BUKAN universe id --
    -- percobaan pertama pakai universeId selalu balas 400 "The place is invalid"
    -- (udah dicross-check LANGSUNG ke Roblox, bukan cuma lewat game). Confirmed bener
    -- pakai game.PlaceId dari pola yang sama di Gag2.lua punya kita sendiri.
    local HttpService = game:GetService("HttpService")
    local ok, jobId = pcall(function()
        local candidates = {}
        local cursor = ""
        for _ = 1, 4 do -- maks 4 halaman (~400 server) -- cukup buat nemu 1 yang beda
            local url = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100"
            if cursor ~= "" then
                url = url .. "&cursor=" .. HttpService:UrlEncode(cursor)
            end
            local data = HttpService:JSONDecode(game:HttpGet(url))
            for _, server in ipairs(data.data or {}) do
                if server.id ~= game.JobId and (server.playing or 0) < (server.maxPlayers or 0) then
                    table.insert(candidates, server.id)
                end
            end
            if not data.nextPageCursor or data.nextPageCursor == "" then
                break
            end
            cursor = data.nextPageCursor
        end

        if #candidates == 0 then
            return nil
        end
        return candidates[math.random(1, #candidates)]
    end)
    if ok then
        return jobId
    end
    return nil
end

-- Wrapper hop server: titip resume dulu, coba ambil server LAIN yang spesifik (biar
-- BENERAN pindah, bukan cuma rejoin ke server yang sama), fallback ke Teleport() biasa
-- kalau gagal ambil list server.
local LAST_HOP_JOBID_PATH = "Napoleon_LastHopJobId.txt"

-- Lapis 0 (di bawah, Anti AFK) nge-block SEMUA TeleportService:Teleport(placeId sama,
-- LocalPlayer) -- termasuk punya KITA SENDIRI pas hopToNewServer() fallback ke Teleport()
-- polos (server list API gagal)! Ketauan dari log: "Lapis 0 BLOKIR" nyegat hop kita
-- sendiri, bikin gak pernah beneran pindah. Flag ini dicek sama Lapis 0 buat bedain
-- "soft-kick AFK dari game" (blokir) vs "hop yang KITA sengaja lakuin" (lolosin).
local intentionalHopTeleportInProgress = false

local function hopToNewServer()
    queueSelfForTeleport()
    -- Simpen jobId SEBELUM pindah -- dicek pas landing (lihat blok deket UI_LOADED di
    -- bawah): kalau ternyata jobId abis landing SAMA kayak yang disimpen di sini, berarti
    -- Teleport() polos nyangkutin kita balik ke server yang sama -- bukan hop beneran --
    -- dan bakal langsung di-hop ULANG otomatis tanpa nunggu.
    pcall(function()
        if typeof(writefile) == "function" then
            writefile(LAST_HOP_JOBID_PATH, game.JobId)
        end
    end)

    local otherJobId = getRandomOtherServerJobId()
    if otherJobId then
        logSelfTeleportAttempt("Hop ke server spesifik lain: " .. otherJobId)
        pcall(function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, otherJobId, LocalPlayer)
        end)
    else
        logSelfTeleportAttempt("Gagal ambil list server lain, fallback ke Teleport() biasa -- bisa aja nyangkut server yang sama, tapi dicek & di-retry otomatis abis landing.")
        intentionalHopTeleportInProgress = true
        pcall(function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
        end)
        intentionalHopTeleportInProgress = false
    end
end

local RarityWeights = {
    ["Common"] = 1,
    ["Uncommon"] = 2,
    ["Rare"] = 3,
    ["Epic"] = 4,
    ["Legendary"] = 5,
    ["Mythic"] = 6,
    ["Cosmic"] = 7,
    ["Secret"] = 8,
    ["Eternal"] = 9,
    ["Divine"] = 10,
    ["Prismatic"] = 11,
    ["Transcendent"] = 12
}

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
    warn("Failed to load Napoleon UI Library!")
    return
end

-- ============================================================
-- HELPER FUNCTIONS
-- ============================================================
-- PENTING: dropObj:Set(...) di NPLN-UIv4.lua, di akhir eksekusinya, manggil balik
-- DropdownConfig.Callback(...) -- yaitu Callback KITA SENDIRI. Jadi kalau
-- handleDropdownChange manggil dropObj:Set() buat "benerin" pilihan (misal strip
-- "None"), itu bikin Callback kita ke-panggil ULANG secara rekursif dari dalam
-- panggilan yang lagi berjalan. Biasanya berhenti sendiri di 1 level, tapi ini
-- re-entrant call chain yang rawan -- apalagi kalau user klik cepat berturut-turut,
-- beberapa event Activated bisa numpuk sebelum call stack yang pertama kelar, dan
-- itu kemungkinan besar penyebab item yang gak diklik ikut ke-toggle. Guard ini
-- mastiin Callback gak pernah masuk lagi ke dirinya sendiri buat dropdown yang sama.
local dropdownUpdateGuard = {}
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

    if dropObj and dropdownUpdateGuard[dropObj] then
        -- Lagi di tengah proses koreksi buat dropdown ini (dipanggil ulang dari
        -- dalam dropObj:Set() di bawah) -- jangan koreksi lagi, cukup balikin apa adanya.
        return arr
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
        dropdownUpdateGuard[dropObj] = true
        pcall(function() dropObj:Set(arr) end)
        dropdownUpdateGuard[dropObj] = nil
    end
    return arr
end

-- ============================================================
-- SMOOTH MOVEMENT (TWEEN, BUKAN TELEPORT)
-- ============================================================
-- Gerakin HumanoidRootPart secara mulus dari posisi sekarang ke targetCFrame,
-- dengan kecepatan = Humanoid.WalkSpeed karakter saat ini (studs/detik).
-- WalkSpeed ini server-authoritative (di-set lewat SpeedController game, hasil
-- akumulasi semua speed upgrade/modifier yang kita punya), jadi nge-tween di
-- speed ini otomatis ngikutin speed MAKSIMAL yang valid dikenal server --
-- bukan CFrame snap instan yang keliatan/tercatat sebagai teleport.
-- Multiplier di atas WalkSpeed asli karakter -- tetep pakai speed asli kita di game
-- (bukan angka ngasal), tapi dipercepat lagi biar gerakannya gak selambat jalan normal.
-- Nilai AKTIF-nya sekarang live lewat Config.TweenSpeedMultiplier, yang bisa diubah
-- kapan aja dari input "Move Speed Multiplier" di bawah toggle Auto Steal Egg
-- (max 5, kosong/invalid/lebih dari 5 balik ke default 2).
local DEFAULT_TWEEN_SPEED_MULTIPLIER = 2
local MAX_TWEEN_SPEED_MULTIPLIER = 5

-- Floor durasi minimum tiap tween -- kalau WalkSpeed karakter lagi tinggi (game ini
-- bisa sampe 300 lewat upgrade treadmill) dikali TweenSpeedMultiplier sampe 5x, speed
-- efektifnya bisa ~1500 stud/detik, dan jarak pendek jadi selesai dalam hitungan
-- milidetik -- visualnya SAMA PERSIS kayak teleport instan, apalagi di device dengan
-- frame rate rendah (mobile/executor kayak Delta). Floor ini mastiin tween SELALU
-- keliatan sebagai gerakan, gak pernah collapse jadi snap sekejap mata lagi.
local MIN_TWEEN_DURATION = 0.15

local activeMoveTweens = {}
-- isCancelledFn (opsional): dipanggil TIAP FRAME selama tween jalan. Kalau
-- balikin true (misal karena toggle Config-nya di-OFF-in di tengah jalan),
-- tween langsung di-Cancel() SEKARANG JUGA -- gak nunggu sampe durasi abis.
-- Ini yang bikin toggle OFF beneran ngestop script seketika, bukan nunggu
-- tween/loop yang lagi jalan kelar dulu.
local function TweenMoveTo(hrp, hum, targetCFrame, isCancelledFn)
    if not hrp then return end
    if isCancelledFn and isCancelledFn() then return end

    -- Batalin tween yang masih jalan di HRP yang sama biar gak numpuk/tabrakan
    local prevTween = activeMoveTweens[hrp]
    if prevTween then
        prevTween:Cancel()
        activeMoveTweens[hrp] = nil
    end

    local distance = (targetCFrame.Position - hrp.Position).Magnitude
    if distance < 0.1 then
        hrp.CFrame = targetCFrame
        hrp.AssemblyLinearVelocity = Vector3.zero
        return
    end

    local speed = hum and hum.WalkSpeed
    if not speed or speed <= 0 then
        speed = 16 -- fallback ke BASE_WALK_SPEED game kalau Humanoid belum siap
    end

    local multiplier = tonumber(Config.TweenSpeedMultiplier)
    if not multiplier or multiplier <= 0 then
        multiplier = DEFAULT_TWEEN_SPEED_MULTIPLIER
    end
    speed = speed * multiplier

    local duration = math.max(distance / speed, MIN_TWEEN_DURATION)
    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
        { CFrame = targetCFrame }
    )
    activeMoveTweens[hrp] = tween

    tween:Play()

    -- Poll tiap Heartbeat (bukan tween.Completed:Wait() doang) biar bisa
    -- di-cancel di tengah jalan begitu toggle di-OFF-in.
    while tween.PlaybackState == Enum.PlaybackState.Playing do
        if isCancelledFn and isCancelledFn() then
            tween:Cancel()
            break
        end
        RunService.Heartbeat:Wait()
    end

    if activeMoveTweens[hrp] == tween then
        activeMoveTweens[hrp] = nil
    end

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end

-- ============================================================
-- ANTI TRAP (Auto Delete PlayerTrap di workspace.__DEBRIS) -- SELALU AKTIF, gak ada toggle
-- ============================================================
-- CATATAN: PlayerTrap ini instance yang muncul di workspace.__DEBRIS, sementara status
-- "IsTrapped" yang beneran nge-block prompt/carry itu ATTRIBUTE di Character yang
-- di-set SERVER (lihat AreaEggs.client.lua bawaan game). Artinya :Destroy() di sini
-- cuma ngapus REPLIKA LOKAL part-nya -- kalau server yang nentuin status trapped-nya,
-- ini gak jamin lepas dari efeknya, cuma ngilangin visualnya. Tetep worth dicoba
-- (gak ada ruginya kalau ternyata gak ngefek).
local function destroyPlayerTrap(inst)
    if inst and inst.Name == "PlayerTrap" then
        pcall(function() inst:Destroy() end)
    end
end

-- Jalan sekali begitu script di-exec: bersihin trap yang udah ada, terus pantau
-- terus-terusan (ChildAdded) biar trap baru yang muncul kapan aja langsung kehapus.
local function startAutoRemoveTraps()
    local debris = workspace:FindFirstChild("__DEBRIS") or workspace:WaitForChild("__DEBRIS", 10)
    if not debris then
        warn("[AntiTrap] workspace.__DEBRIS gak ketemu, gak bisa mantau trap.")
        return
    end

    for _, child in ipairs(debris:GetChildren()) do
        destroyPlayerTrap(child)
    end

    debris.ChildAdded:Connect(function(child)
        destroyPlayerTrap(child)
    end)
end
task.spawn(startAutoRemoveTraps)

-- ============================================================
-- ANTI TREADMILL MOUNT -- toggle-able lewat "Anti Treadmill Mount" di tab Misc
-- ============================================================
-- BUG: treadmill di game ini otomatis "nempel"/ke-mount begitu karakter berdiri
-- persis di atasnya (raycast turun tiap Heartbeat dari game sendiri, lihat
-- TreadmillStaticController.client.lua di dump game -- fungsi tryEnterStaticTreadmill).
-- Kalau tween Auto Place (ke PetArea) kebetulan lewat/mendarat di atas treadmill KITA
-- SENDIRI, karakter bisa ke-mount gak sengaja dan macet di situ.
--
-- Daripada coba hitung ulang geometri buat NGEHINDARIN posisi treadmill (rapuh, posisi
-- PetArea vs treadmill beda-beda tiap plot), kita pantau event YANG SAMA yang dipakai
-- game buat nge-track status mount kita sendiri (Treadmills.ACTIVE_TREADMILL_EVENT --
-- Network.Fired ngasih signal yang bisa didengerin banyak listener sekaligus, jadi kita
-- bisa numpang dengerin tanpa ganggu listener asli game). Begitu ke-detect ke-mount
-- (treadmillId ~= nil) DAN Config.AntiTreadmillMount lagi nyala, langsung minta lepas
-- lewat remote resmi REQUEST_UNEQUIP. Kalau togglenya dimatiin, listener-nya tetep
-- jalan tapi gak ngapa-ngapain -- jadi treadmill bisa dipake normal kapan aja mau,
-- dan tinggal dinyalain lagi pas mau fokus farming tanpa gangguan.
local function setupAntiTreadmillMount()
    local ok, err = pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Network = require(ReplicatedStorage.Library.Client.Network)
        local Constants = require(ReplicatedStorage.Library.Globals.Constants)
        local Treadmills = Constants.NETWORK_MAP.Treadmills

        Network.Fired(Treadmills.ACTIVE_TREADMILL_EVENT):Connect(function(treadmillId)
            if treadmillId == nil then return end
            if not Config.AntiTreadmillMount then return end
            task.spawn(function()
                task.wait(0.05) -- Kasih waktu sepersekian detik biar state kesinkron server dulu
                if not Config.AntiTreadmillMount then return end -- Dicek ulang, siapa tau keburu dimatiin
                local uOk, uErr = pcall(function()
                    return Network.Invoke(Treadmills.REQUEST_UNEQUIP)
                end)
                if uOk then
                else
                    warn("[AntiTreadmill] Ke-detect ke-mount tapi gagal minta lepas:", uErr)
                end
            end)
        end)
    end)
    if not ok then
        warn("[AntiTreadmill] Gagal setup listener:", err)
    end
end
task.spawn(setupAntiTreadmillMount)

-- ============================================================
-- FPS BOOST (low graphics + hide other players' pets & placed eggs)
-- ============================================================
-- Data game yang dipake di sini (dicek dari dump NewSteal An Egg):
-- - ReplicatedStorage.Library.Variables.PotatoMode: flag boolean bawaan game,
--   dibaca GraphicsQuality.lua & FixParticleRate.lua buat maksa quality level 1
--   + minimalin rate semua particle effect di seluruh game.
-- - ReplicatedStorage.Library.Client.LightingsController: sistem layering lighting
--   bawaan game (:SetModifier), dipake biar perubahan kita gak "ditimpa balik" sama
--   modifier lain (misal transisi malam) -- alih-alih ngedit Lighting children langsung.
-- - ReplicatedStorage.Library.Client.SettingsCmds: sistem "Settings" resmi game
--   (server-authoritative, lewat RemoteFunction) -- ada key "HideOtherPets" yang
--   udah disediain game sendiri buat nyembunyiin pet pemain lain.
-- - ReplicatedStorage.Library.Client.Eggs.PlacedEggRenderer.GetRenderFolder(): folder
--   berisi SEMUA telur yang ditaruh SEMUA pemain (nama Model = "{OwnerUserId}_{Uid}").
--   Gak ada toggle bawaan buat nyembunyiin punya orang lain, jadi kita bikin sendiri.
local fpsBoostApplied = false

-- Dipakai buat egg (workspace.PlacedEggRenders) DAN pet (workspace.ClientRenderedAssets)
-- -- dua-duanya sama persis pola nama Model-nya: "{OwnerUserId}_{Uid}" (dicek langsung
-- dari source: PlacedEggRenderer.lua pakai `{OwnerUserId}_{Uid}`, ItemDisplay.lua
-- (CreateWanderingAssetModel) juga persis sama `{OwnerUserId}_{Uid}`).
local function hideModelIfNotMine(model)
    if not model or not model:IsA("Model") then return end
    local ownerIdStr = model.Name:match("^(%d+)_")
    local ownerId = ownerIdStr and tonumber(ownerIdStr)
    if not ownerId or ownerId == LocalPlayer.UserId then return end

    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
            part.CanCollide = false
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = 1
        elseif part:IsA("ParticleEmitter") or part:IsA("Trail") or part:IsA("Beam") then
            part.Enabled = false
        elseif part:IsA("BillboardGui") or part:IsA("SurfaceGui") then
            part.Enabled = false
        end
    end
end

local function hideOtherPlayersEggs()
    local ok, err = pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local PlacedEggRenderer = require(ReplicatedStorage.Library.Client.Eggs.PlacedEggRenderer)
        local renderFolder = PlacedEggRenderer.GetRenderFolder()
        if not renderFolder then return end

        local children = renderFolder:GetChildren()
        local hidden = 0
        for _, model in ipairs(children) do
            local ownerIdStr = model.Name:match("^(%d+)_")
            local ownerId = ownerIdStr and tonumber(ownerIdStr)
            if ownerId and ownerId ~= LocalPlayer.UserId then
                hidden = hidden + 1
            end
            hideModelIfNotMine(model)
        end

        -- Telur pemain lain terus ditaruh selama kita main -- pantau terus biar
        -- yang baru muncul juga langsung ke-hide, gak cuma yang udah ada sekarang.
        renderFolder.ChildAdded:Connect(function(model)
            task.defer(hideModelIfNotMine, model)
        end)
    end)
    if not ok then
        warn("[FPSBoost] Gagal hide egg pemain lain:", err)
    end
end

-- Sama kayak hideModelIfNotMine, tapi TANPA pengecualian owner -- dipakai khusus
-- buat pet, karena request user: pet DIHILANGIN SEMUA (termasuk punya kita sendiri),
-- yang tetep kelihatan cuma egg-nya doang. Pet gak ngaruh ke fungsi steal/carry sama
-- sekali (itu semua jalan lewat EggCmds & data, bukan lewat visual), jadi aman disembunyiin total.
local function hideModelAlways(model)
    if not model or not model:IsA("Model") then return end
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
            part.CanCollide = false
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = 1
        elseif part:IsA("ParticleEmitter") or part:IsA("Trail") or part:IsA("Beam") then
            part.Enabled = false
        elseif part:IsA("BillboardGui") or part:IsA("SurfaceGui") then
            part.Enabled = false
        elseif part:IsA("Highlight") then
            part.Enabled = false
        end
    end
end

-- CATATAN: SettingsCmds.Set("HideOtherPets", true) di-coba dulu (fitur resmi game,
-- meski itu cuma nyembunyiin punya ORANG LAIN), TAPI ditambah sistem hide MANUAL
-- independen yang nyembunyiin SEMUA pet (termasuk punya kita sendiri, sesuai
-- permintaan user: "sisain kelihatan egg nya aja"). Manual hide ini gak bergantung
-- sama sekali ke toggle bawaan, jadi tetep jalan walau toggle-nya gak ngefek.
local function hideOtherPlayersPets()
    local ok, err = pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local SettingsCmds = require(ReplicatedStorage.Library.Client.SettingsCmds)
        local setOk = SettingsCmds.Set("HideOtherPets", true)
    end)
    if not ok then
        warn("[FPSBoost] Gagal set HideOtherPets bawaan game:", err)
    end

    local ok2, err2 = pcall(function()
        local renderFolder = workspace:FindFirstChild("ClientRenderedAssets")
            or workspace:WaitForChild("ClientRenderedAssets", 10)
        if not renderFolder then return end

        local children = renderFolder:GetChildren()
        for _, model in ipairs(children) do
            hideModelAlways(model)
        end

        if not fpsBoostApplied then
            renderFolder.ChildAdded:Connect(function(model)
                task.defer(hideModelAlways, model)
            end)
        end
    end)
    if not ok2 then
        warn("[FPSBoost] Gagal hide pet (manual):", err2)
    end
end

local function reduceGraphicsQuality()
    -- Native Roblox render settings -- dibungkus pcall masing-masing karena beberapa
    -- executor/security context bisa nolak nulis ke sini.
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    pcall(function()
        UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    end)

    -- Flag bawaan game -- maksa quality level 1 + minimalin particle rate di semua
    -- sistem yang udah baca flag ini sendiri (lihat catatan di atas).
    pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Variables = require(ReplicatedStorage.Library.Variables)
        Variables.PotatoMode = true
    end)

    -- Matiin efek Lighting yang paling mahal lewat sistem modifier bawaan game
    -- (bukan edit Lighting children langsung, biar gak ketimpa modifier lain kayak
    -- transisi malam/hari). CATATAN: Fog di-drop dari sini -- Fog di Roblox itu cuma
    -- shader tint doang, GAK beneran nge-cull rendering apa pun (gak nambah FPS), dan
    -- malah keliatan kayak "kabut aneh". Yang beneran nurunin beban render itu material
    -- flatten + CastShadow di bawah.
    pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local LightingsController = require(ReplicatedStorage.Library.Client.LightingsController)
        LightingsController:SetModifier("FPSBoost", function(cfg)
            local boosted = table.clone(cfg)
            boosted.Bloom = nil
            boosted.ColorCorrection = nil
            boosted.SunRays = nil
            boosted.DepthOfField = nil
            boosted.Blur = nil
            boosted.Clouds = nil
            boosted.Atmosphere = nil
            boosted.ShadowSoftness = 1
            return boosted
        end, 100, 0) -- priority tinggi biar menang dari modifier lain, tween 0 = langsung
    end)

    -- Setting Lighting yang gak masuk skema modifier di atas (GlobalShadows gak
    -- di-serialize/di-apply LightingsCore, jadi harus di-set langsung).
    -- CATATAN: sebelumnya di sini juga ada Lighting.Technology = Compatibility +
    -- EnvironmentDiffuseScale/EnvironmentSpecularScale = 0 -- itu YANG BIKIN keliatan
    -- kayak "kabut aneh" (ganti technology rendering + nge-nolin environment lighting
    -- bikin skybox/permukaan jauh keliatan flat abu-abu ngambang, mirip kabut). Dicabut
    -- karena efek visualnya lebih ganggu daripada manfaat FPS-nya -- material flatten
    -- (SmoothPlastic + CastShadow off) di bawah udah cukup buat FPS gain-nya.
    pcall(function()
        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = false
    end)

    -- Matiin semua particle/trail/beam/fire/smoke yang masih tersisa di workspace
    -- (di luar yang udah kena PotatoMode) buat boost maksimal.
    pcall(function()
        for _, inst in ipairs(workspace:GetDescendants()) do
            if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam")
                or inst:IsA("Fire") or inst:IsA("Smoke") or inst:IsA("Sparkles") then
                inst.Enabled = false
            end
        end
    end)
end

-- Ini yang beneran bikin "full abu-abu": paksa SEMUA BasePart di workspace pake
-- Material SmoothPlastic (paling murah dirender, gak ada texture/bump) + Color abu-abu
-- rata + CastShadow off. Sekali sapu penuh workspace, TERUS dipasang DescendantAdded
-- biar part baru yang muncul (pet baru wander, egg baru di-render, dll) ikut kena juga.
local GRAY_MATERIAL_COLOR = Color3.fromRGB(120, 120, 120)

local function flattenPart(part)
    if not part or not part:IsA("BasePart") then return end
    part.Material = Enum.Material.SmoothPlastic
    part.Color = GRAY_MATERIAL_COLOR
    part.CastShadow = false
end

local function flattenWorldMaterials()
    local ok, err = pcall(function()
        for _, inst in ipairs(workspace:GetDescendants()) do
            flattenPart(inst)
        end
        if not fpsBoostApplied then
            workspace.DescendantAdded:Connect(function(inst)
                task.defer(flattenPart, inst)
            end)
        end
    end)
    if not ok then
        warn("[FPSBoost] Gagal flatten material workspace:", err)
    end
end

-- Hapus TOTAL (bukan cuma hide) plot pemain lain -- instance yang di-Destroy() gak
-- dirender, gak dihitung fisika, gak jalanin update loop apa pun sama sekali, jadi
-- jauh lebih ngirit daripada sekadar transparan. Dibandingin per SLOT NUMBER (nama
-- folder-nya = tostring(slot)), bukan reference Instance -- karena plot bisa
-- di-recreate ulang sama sistem Streamable bawaan game (misal abis balik dari jauh),
-- jadi cache reference Instance bisa jadi basi & keliru ngedelete plot kita sendiri.
local function deleteOtherPlayersPlots()
    local ok, err = pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds)

        -- Jaga-jaga: kalau slot kita BELUM ke-resolve (PlotCmds.GetMySlot() masih nil,
        -- misal karena baru join/data belum sinkron), JANGAN hapus apa-apa dulu --
        -- daripada semua plot (termasuk punya kita) ke-anggep "bukan punya kita" dan
        -- ke-Destroy() semua. Mending nunggu, coba lagi kapan-kapan.
        local mySlot = PlotCmds.GetMySlot()
        if mySlot == nil then
            warn("[FPSBoost] Slot plot kita belum ke-resolve, skip delete plot dulu (biar aman).")
            return
        end

        local function isMyPlot(plot)
            local currentSlot = PlotCmds.GetMySlot()
            return currentSlot ~= nil and plot.Name == tostring(currentSlot)
        end

        local plotsFolder = PlotCmds.GetPlotsFolder() or workspace:WaitForChild("Plots", 10)
        if not plotsFolder then
            warn("[FPSBoost] workspace.Plots gak ketemu sama sekali.")
            return
        end

        local children = plotsFolder:GetChildren()
        local deleted = 0
        for _, plot in ipairs(children) do
            if not isMyPlot(plot) then
                local dOk = pcall(function() plot:Destroy() end)
                if dOk then deleted = deleted + 1 end
            end
        end

        if not fpsBoostApplied then
            plotsFolder.ChildAdded:Connect(function(plot)
                task.defer(function()
                    if plot.Parent and not isMyPlot(plot) then
                        pcall(function() plot:Destroy() end)
                    end
                end)
            end)
        end
    end)
    if not ok then
        warn("[FPSBoost] Gagal delete plot pemain lain:", err)
    end
end

-- Treadmill di-render flat di workspace.__ClientTreadmillRenders (gak per-plot-folder).
-- BUG SEBELUMNYA: ownership cuma dicek pakai PlotCmds.IsWorldPositionWithinLocalPlotBounds
-- (cek posisi treadmill ada di dalem bounding-box plot kita) -- ini heuristik doang,
-- dan kalau pivot/posisi treadmill kebetulan ada di pinggir/luar bounding-box plot
-- (misal nempel pager/border), treadmill KITA SENDIRI ikut ke-anggep "bukan punya kita"
-- dan ke-Destroy(). Sekarang dicek DUA LAPIS: (1) cara PASTI -- game sendiri nyimpen
-- reference treadmill KITA di RuntimeInstanceRegistry dengan key "TreadmillPlotRender"
-- (cuma di-set buat treadmill milik LocalPlayer, lihat TreadmillStaticController.client.lua
-- di dump game) -- kalau model-nya PERSIS sama reference itu, udah pasti punya kita,
-- gak peduli hasil cek posisi. (2) fallback ke cek bounding-box kalau registry-nya
-- belum ke-set (misal treadmill kita belum sempet ke-render).
local function deleteOtherPlayersTreadmills()
    local ok, err = pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds)
        local RuntimeInstanceRegistry = require(ReplicatedStorage.Library.Modules.RuntimeInstanceRegistry)
        local folder = workspace:FindFirstChild("__ClientTreadmillRenders")
            or workspace:WaitForChild("__ClientTreadmillRenders", 10)
        if not folder then return end

        -- Diambil FRESH tiap panggilan (bukan di-cache), biar tetep akurat kalau
        -- treadmill kita ke-rebuild ulang (misal abis upgrade base/treadmill).
        local function getMyTreadmillModel()
            local mySlot = PlotCmds.GetMySlot()
            if mySlot == nil then return nil end
            local okReg, result = pcall(RuntimeInstanceRegistry.Get, "TreadmillPlotRender", tostring(mySlot))
            if okReg then return result end
            return nil
        end

        local function isMyTreadmill(model)
            local myTreadmillModel = getMyTreadmillModel()
            if myTreadmillModel and model == myTreadmillModel then
                return true
            end
            local okPos, pos = pcall(function() return model:GetPivot().Position end)
            if not okPos then return true end -- gak yakin posisinya, jangan diapa-apain
            local okBounds, within = pcall(PlotCmds.IsWorldPositionWithinLocalPlotBounds, pos)
            return okBounds and within
        end

        local children = folder:GetChildren()
        local deleted = 0
        for _, model in ipairs(children) do
            if model:IsA("Model") and not isMyTreadmill(model) then
                local dOk = pcall(function() model:Destroy() end)
                if dOk then deleted = deleted + 1 end
            end
        end

        if not fpsBoostApplied then
            folder.ChildAdded:Connect(function(model)
                task.defer(function()
                    if model.Parent and model:IsA("Model") and not isMyTreadmill(model) then
                        pcall(function() model:Destroy() end)
                    end
                end)
            end)
        end
    end)
    if not ok then
        warn("[FPSBoost] Gagal delete treadmill pemain lain:", err)
    end
end

local function ApplyFPSBoost()
    reduceGraphicsQuality()
    -- Delete plot/treadmill orang lain DULU sebelum flatten material, biar gak
    -- buang waktu ngeflatten part yang toh bakal ke-Destroy() abis ini juga.
    deleteOtherPlayersPlots()
    deleteOtherPlayersTreadmills()
    flattenWorldMaterials()
    hideOtherPlayersPets()
    -- hideOtherPlayersEggs() masang listener ChildAdded -- cuma sekali aja biar gak
    -- numpuk koneksi duplikat kalau tombolnya diklik berkali-kali.
    if not fpsBoostApplied then
        hideOtherPlayersEggs()
    end
    fpsBoostApplied = true
end

-- ============================================================
-- BUILD UI WINDOW
-- ============================================================
local Window = Library:Window({
    Title = "Napoleon",
    Footer = "Steal An Egg",
    Color = Color3.fromRGB(50, 50, 50),
    Color2 = Color3.fromRGB(20, 20, 20),
    ["Tab Width"] = 130,
    Image = "111895858615511",
    WindowIMG = "91334002283698",
    LogoHUB = "119958938217417"
})

local Tabs = Window

-- ============================================================
-- AUTO STEAL LOGIC (RAGDOLL BYPASS + STEAL + BACK)
-- ============================================================
local IDLE_HOP_DELAY_SECONDS = 8 -- tunggu segini detik idle-tanpa-target dulu sebelum Server Hop re-roll

-- Formula seed egg (AreaEggResetTimeUtil.GetSlotSeed(period, area, slot)) itu MURNI
-- berdasarkan period+area+slot -- GAK ada faktor server/jobId sama sekali. Artinya
-- SEMUA server dapet hasil roll yang PERSIS SAMA di period yang sama. Jadi kalau target
-- rarity kita emang GAK dijadwalin muncul sama sekali di period sekarang, hop ke server
-- LAIN itu PERCUMA -- server manapun bakal punya hasil sama sampai period berikutnya
-- (5 menit). Dipakai buat nge-gate idle-hop biar gak asal hop pas emang belum waktunya.
local function isTargetRarityExpectedThisPeriod(targetRarities)
    local ok, result = pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local AreaEggResetTimeUtil = require(ReplicatedStorage.Library.Util.AreaEggResetTimeUtil)
        local AreasDir = require(ReplicatedStorage.Directory.Areas).Directory
        local AssetsDir = require(ReplicatedStorage.Directory.Assets).Directory
        local LotteryCustomFn = require(ReplicatedStorage.Library.Functions.LotteryCustom)

        local areasList = { "Forest", "Lake", "Desert", "Jungle", "Snow", "Volcano", "Abyss Ocean", "Prehistoric", "Cosmic" }
        local slotsList = { "Slot_001", "Slot_002", "Slot_003", "Slot_004", "Slot_005" }

        local now = game:GetService("Workspace"):GetServerTimeNow()
        local currentPeriod = AreaEggResetTimeUtil.GetPeriodIndex(now)

        for _, areaName in ipairs(areasList) do
            local areaConfig = AreasDir[areaName]
            if areaConfig and areaConfig.DropTable then
                for _, slotName in ipairs(slotsList) do
                    local seed = AreaEggResetTimeUtil.GetSlotSeed(currentPeriod, areaName, slotName)
                    local petName = LotteryCustomFn(Random.new(seed), areaConfig.DropTable)
                    if petName then
                        local assetData = AssetsDir[petName]
                        local rarityName = assetData and assetData.Rarity and assetData.Rarity.DisplayName
                        if rarityName and table.find(targetRarities, rarityName) then
                            return true
                        end
                    end
                end
            end
        end
        return false
    end)
    if ok then
        return result
    end
    -- Gagal simulasi (module gak ke-load, dll) -- anggap TRUE (izinin hop kayak
    -- sebelumnya) daripada malah macet gak pernah hop sama sekali.
    return true
end

local function AutoStealLoop()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds)
    -- Tidak perlu StealEvent manual, kita pakai EggCmds yang sudah ada

    -- Wall reset malam hari (AreaEggResetWall) -- nutup akses ke gameplay side pas lagi
    -- reset cycle (lihat ResetStartTimer.client.lua & AreaEggResetWall.lua bawaan game).
    -- Selama ini kebuka, ngoyo maksa carry cuma buang waktu (server nolak terus) --
    -- mending nunggu dulu sampe collapse (ilang) baru gerak ambil egg.
    local successWallReq, AreaEggResetWall = pcall(function()
        return require(ReplicatedStorage.Library.Client.AreaEggResetWall)
    end)
    if not successWallReq then
        warn("[AutoSteal] Gagal require AreaEggResetWall, skip pengecekan wall:", AreaEggResetWall)
        AreaEggResetWall = nil
    end

    -- Invincibility sekarang ditangani secara global oleh Zombie Mode di atas

    -- UID egg yang BARU AJA berhasil kita carry sendiri. Snapshot lokal (GetAreaEggSnapshot)
    -- kadang telat beberapa frame buat ngapus egg yang udah diklaim, jadi tanpa blacklist ini
    -- iterasi berikutnya bisa milih ulang egg yang barusan KITA sendiri ambil, gagal carry
    -- (karena udah gak ada), dan salah dikira "keduluan orang lain" -> hop yang gak perlu.
    local recentlyClaimedByMe = {}

    -- Semua UID egg yang match filter kita di scan TERAKHIR (bukan cuma 1 UID "terbaik" --
    -- set ini di-replace total tiap iterasi, jadi gak akan pernah nyangkut/stale).
    -- Kalau ada UID yang match di iterasi sebelumnya tapi sekarang hilang dari set yang baru,
    -- dan bukan kita yang ngambil (gak ada di recentlyClaimedByMe), berarti keduluan orang
    -- lain sebelum kita sempat coba sama sekali -- kasus ini gak lewat carry-fail.
    local watchedMatchingUids = {}

    -- Dulu balik-ke-safezone-pas-idle ini jalan TIAP iterasi outer loop (~0.3-0.35 detik
    -- sekali) selama gak ada target -- efeknya character keukeuh ke-tarik balik ke safezone
    -- terus-terusan kalau kita coba gerakin manual pas AutoSteal lagi idle (gak nemu egg).
    -- Sekarang cuma sekali per "sesi idle": begitu udah nyampe/deket safezone, flag ini
    -- di-set true dan gak nge-tween lagi sampai ada target baru ketemu (flag direset).
    local hasSettledAtSafezoneWhileIdle = false
    -- Nge-track sejak kapan kita idle TANPA target sama sekali -- dipakai buat Server
    -- Hop "re-roll": kalau abis beberapa detik idle beneran gak ada target rarity kita
    -- muncul di server ini sama sekali (bukan cuma keduluan orang), hop server baru
    -- buat coba lagi, daripada nunggu sampai 5 menit reset berikutnya di server yang sama.
    local idleNoTargetSince = nil

    -- Karakter yang BARU AJA spawn (join/rejoin) belum tentu langsung "settle" -- macam-
    -- macam script bawaan game (spawn animation, camera, dll) masih jalan barengan detik-
    -- detik pertama, dan bisa bentrok sama tween kita kalau kepepet mulai langsung (nyampe
    -- posisi visual tapi server gak sempet catat, jadi carry gagal). Kasih jeda dikit sebelum
    -- ngejar target pertama kali, cuma sekali tiap AutoStealLoop ini mulai.
    do
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if char and hum then
            local settleWaited = 0
            while settleWaited < 1.5 and Config.AutoSteal do
                task.wait(0.1)
                settleWaited = settleWaited + 0.1
            end
        end
    end

    while Config.AutoSteal do
        -- Bersihin blacklist yang udah kadaluarsa (>5 detik, snapshot pasti udah update)
        local nowClock = os.clock()
        for uid, claimedAt in pairs(recentlyClaimedByMe) do
            if nowClock - claimedAt > 5 then
                recentlyClaimedByMe[uid] = nil
            end
        end

        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")

        if char and hrp then
            local eggSnapshot = EggCmds.GetAreaEggSnapshot()
            local targetEgg = nil
            local currentMatchingUids = {}

            -- Kalau kita UDAH bawa egg (misal abis toggle off/on di tengah carry), itu
            -- yang diprioritasin -- jangan malah cari target baru dan biarin yang di
            -- tangan nyangkut/keclaim orang lain.
            if eggSnapshot and eggSnapshot.Records then
                for _, record in pairs(eggSnapshot.Records) do
                    if record.State == "Carried" and record.CarrierUserId == LocalPlayer.UserId then
                        targetEgg = record
                        local Assets = require(game:GetService("ReplicatedStorage").Directory.Assets)
                        local rarityData = Assets.Directory[record.AssetCategory] and Assets.Directory[record.AssetCategory].Rarity
                        targetEgg.Rarity = rarityData and rarityData.DisplayName or rarityData and rarityData._id or "Unknown"
                        break
                    end
                end
            end

            if not targetEgg and eggSnapshot and eggSnapshot.Records then
                local highestWeight = -1

                for _, record in pairs(eggSnapshot.Records) do
                    local area = record.AreaId

                    -- Lookup Rarity dari game data
                    local Assets = require(game:GetService("ReplicatedStorage").Directory.Assets)
                    local rarityData = Assets.Directory[record.AssetCategory] and Assets.Directory[record.AssetCategory].Rarity
                    local rarity = rarityData and rarityData.DisplayName or rarityData and rarityData._id or "Unknown"

                        if not recentlyClaimedByMe[record.Uid] and (record.State == "Slot" or record.State == "Dropped") and record.BottomCFrame then -- Pastikan telur fisik sudah render
                            -- "None" (belum dipilih) = gak ada batasan buat dimensi itu, jadi match semua.
                            -- Kalau Area diisi tapi Rarity kosong -> ambil semua rarity di area itu.
                            -- Kalau Rarity diisi tapi Area kosong -> ambil rarity itu di area manapun.
                            local areaMatch = false
                            if #Config.StealAreas == 0 or table.find(Config.StealAreas, "None") then
                                areaMatch = true
                            else
                                areaMatch = table.find(Config.StealAreas, area) ~= nil
                            end

                            local rarityMatch = false
                            if #Config.StealRarities == 0 or table.find(Config.StealRarities, "None") then
                                rarityMatch = true
                            else
                                rarityMatch = table.find(Config.StealRarities, rarity) ~= nil
                            end

                            if areaMatch and rarityMatch then
                                currentMatchingUids[record.Uid] = true
                                local weight = RarityWeights[rarity] or 0
                                if weight > highestWeight then
                                    highestWeight = weight
                                    targetEgg = record
                                    targetEgg.Rarity = rarity -- Simpan ke record sementara untuk dipakai di print
                                end
                            end
                        end
                    end
                end

            -- Egg yang match filter kita di iterasi SEBELUMNYA tapi sekarang udah gak match
            -- lagi (hilang dari currentMatchingUids) DAN bukan kita yang ngambil -> kemungkinan
            -- besar keduluan orang lain sebelum kita sempat coba carry.
            for uid in pairs(watchedMatchingUids) do
                if not currentMatchingUids[uid] and not recentlyClaimedByMe[uid] then
                    break -- Cukup 1x per iterasi, gak perlu spam cek sisanya
                end
            end
            watchedMatchingUids = currentMatchingUids

            -- Lakukan pencurian via CARRY + DROP (mekanisme resmi game)
            if targetEgg then
                -- Ada target lagi -> reset flag idle-settle, biar SESI IDLE BERIKUTNYA
                -- (kalau abis ini gak ada target lagi) dapet 1x kesempatan balik ke
                -- safezone yang fresh, bukan ke-skip terus karena flag lama masih true.
                hasSettledAtSafezoneWhileIdle = false
                idleNoTargetSince = nil
                Config.IsStealing = true
                
                local success, err = pcall(function()
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChild("Humanoid")
                    if not hrp or not hum then return end

                    -- Dipakai TweenMoveTo buat cek tiap frame: begitu toggle Auto Steal
                    -- di-OFF-in, tween yang lagi jalan langsung di-Cancel() SEKARANG JUGA.
                    local function stealCancelled()
                        return not Config.AutoSteal
                    end
                    if stealCancelled() then return end

                    -- Lepas telur yang mungkin sedang dipegang oleh AutoPlace
                    hum:UnequipTools()

                    local safezoneCF = CFrame.new(518.66, 70.57, -364.73) * CFrame.Angles(math.rad(180.00), math.rad(-89.82), math.rad(180.00))

                    -- Dulu ada detour "tween ke safezone dulu sebelum ambil telur" di sini
                    -- (buat jaga-jaga anti-cheat), tapi ini bikin bot muter balik ke safezone
                    -- yang jauh dulu SETIAP kali toggle di-off-in lalu di-on-in lagi, walau
                    -- lagi berdiri persis di depan egg -- gak diinginkan, dihapus. Sekarang
                    -- langsung samperin egg-nya dari posisi manapun kita lagi berada.

                    -- eggCF MUTABLE -- di-update ke BottomCFrame TERBARU kalau egg-nya
                    -- kepental/jatuh lagi (misal kena pukul Guard pas kita bawa balik ke
                    -- safezone), biar kita samperin lagi dari lokasi jatuh yang bener.
                    local eggCF = targetEgg.BottomCFrame * CFrame.new(0, 3, 0)

                    -- BUG SEBELUMNYA: kita SELALU maksa bikin FirstAreaSlotKey (dari AreaId:NestId
                    -- atau regex fallback) buat SEMUA egg -- padahal dicek langsung dari source asli
                    -- game (AreaEggs.client.lua, function bindPrompt yang jalan pas real player mencet
                    -- prompt "Steal"), field ini CUMA boleh diisi buat egg yang UID-nya diawali
                    -- "FirstAreaEgg_" (dicek via AreaEggSlotIdentity.IsFirstAreaUid) -- buat SEMUA
                    -- egg biasa/liar lainnya (mayoritas target kita), field ini HARUS nil. Ngirim
                    -- key "ngarang" buat egg yang seharusnya nil itu yang bikin server nolak carry-nya
                    -- diam-diam ("kadang gak ke-carry" walau posisi udah bener) -- makanya sekarang
                    -- kita replikasi PERSIS logic aslinya, bukan nebak-nebak lagi.
                    local firstAreaSlotKey = nil
                    local slotIdentityOk, AreaEggSlotIdentity = pcall(function()
                        return require(ReplicatedStorage.Library.Util.AreaEggSlotIdentity)
                    end)
                    if slotIdentityOk and AreaEggSlotIdentity then
                        local isFirstAreaOk, isFirstArea = pcall(AreaEggSlotIdentity.IsFirstAreaUid, tostring(targetEgg.Uid))
                        if isFirstAreaOk and isFirstArea then
                            if type(targetEgg.AreaId) == "string" and type(targetEgg.NestId) == "string" then
                                local buildOk, built = pcall(AreaEggSlotIdentity.BuildSlotKey, targetEgg.AreaId, targetEgg.NestId)
                                if buildOk then firstAreaSlotKey = built end
                            end
                        end
                    else
                        warn("[AutoSteal] Gagal require AreaEggSlotIdentity, FirstAreaSlotKey dipaksa nil (aman buat egg biasa):", AreaEggSlotIdentity)
                    end

                    -- Kalau wall reset (malam/reset cycle) lagi NUTUP, jangan maksa tween/
                    -- carry -- egg gak bakal keambil (server nolak carry-nya terus) walau
                    -- kita udah di posisinya. Nunggu dulu sampe wall-nya collapse (ilang).
                    if AreaEggResetWall and AreaEggResetWall.IsClosed() then
                        while AreaEggResetWall.IsClosed() and not stealCancelled() do
                            task.wait(0.2)
                        end
                        if stealCancelled() then return end
                    end

                    -- Loop LUAR: kalau kita udah berhasil carry tapi kena pukul Guard di
                    -- tengah jalan balik (egg-nya kepental/jatuh -- State server balik jadi
                    -- "Dropped", BUKAN lagi "Carried" sama kita), JANGAN lanjut ke safezone
                    -- kosongan -- balik lagi ke lokasi jatuhnya & coba carry ulang dari situ.
                    -- Dibatesin maxOuterAttempts biar gak nyangkut selamanya kalau emang
                    -- guard-nya terus-terusan mukul di lokasi yang sama.
                    local outerAttempt = 0
                    local maxOuterAttempts = 4
                    local finalOutcome = nil -- "claimed" | "lost" | "gaveup" | "cancelled"

                    while not finalOutcome do
                        outerAttempt = outerAttempt + 1
                        if stealCancelled() then
                            finalOutcome = "cancelled"
                            break
                        end
                        if outerAttempt > maxOuterAttempts then
                            finalOutcome = "gaveup"
                            break
                        end

                        local carryOk, carryErr
                        local eggStillThere = true

                        -- Kalau egg ini UDAH kita bawa (abis toggle off/on di tengah carry),
                        -- skip tween+request carry, langsung lanjut ke step 3 (balik safezone).
                        local alreadyCarryingTarget = targetEgg.State == "Carried" and targetEgg.CarrierUserId == LocalPlayer.UserId

                        if alreadyCarryingTarget then
                            carryOk = true
                        else
                        -- ==========================================
                        -- 1. TWEEN KE TELUR (bukan teleport), lalu PIN posisi (TANPA anchor)
                        -- Anchor di sini justru blokir server baca posisi kita
                        -- untuk proximity check → carry gagal. Pakai loop biasa buat pin.
                        -- ==========================================
                        -- Kalau kita LAGI DI AREA yang sama kayak egg-nya, langsung samperin
                        -- (gak perlu safezone). Kalau di area lain / di luar, ke safezone dulu.
                        -- Raycast dulu ke arah egg -- kalau ada tembok beneran di tengah jalan,
                        -- baru lewat safezone. Kalau clear, langsung samperin.
                        -- BUG SEBELUMNYA: raycast cuma ngecek hit PERTAMA. Kalau yang kena
                        -- duluan itu non-collidable (dekorasi/grass/dll) yang keberadaan di
                        -- depan tembok ASLI, langsung dianggap "clear" -- padahal tembok
                        -- collidable-nya masih ada di belakang situ. Sekarang "nembus" hit
                        -- non-collidable (exclude & re-cast dari titik itu), sampai ketemu
                        -- collidable beneran (blokir) atau raycast gak kena apa-apa lagi (clear).
                        local pathClear = true
                        pcall(function()
                            local from = hrp.Position + Vector3.new(0, 2, 0)
                            local to = eggCF.Position + Vector3.new(0, 2, 0)
                            local excludeList = {char}
                            local params = RaycastParams.new()
                            params.FilterType = Enum.RaycastFilterType.Exclude

                            local origin = from
                            for _ = 1, 8 do
                                params.FilterDescendantsInstances = excludeList
                                local dir = to - origin
                                if dir.Magnitude < 1 then break end
                                local result = workspace:Raycast(origin, dir, params)
                                if not result then
                                    break
                                end
                                if result.Instance.CanCollide then
                                    pathClear = false
                                    break
                                end
                                table.insert(excludeList, result.Instance)
                                origin = result.Position + dir.Unit * 0.1
                            end
                        end)
                        if not pathClear then
                            TweenMoveTo(hrp, hum, safezoneCF, stealCancelled)
                            if stealCancelled() then return end
                        end
                        TweenMoveTo(hrp, hum, eggCF, stealCancelled)
                        if stealCancelled() then finalOutcome = "cancelled" break end
                        local loopConn = game:GetService("RunService").Heartbeat:Connect(function()
                            hrp.CFrame = eggCF
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            hrp.AssemblyAngularVelocity = Vector3.zero
                        end)

                        local approachWaited = 0
                        while approachWaited < 0.4 and not stealCancelled() do
                            task.wait(0.05)
                            approachWaited = approachWaited + 0.05
                        end
                        if stealCancelled() then
                            loopConn:Disconnect()
                            finalOutcome = "cancelled"
                            break
                        end

                        -- ==========================================
                        -- 2. REQUEST CARRY (Spam berkali-kali, DIULANG kalau kelempar Guard)
                        -- Karena posisi butuh waktu sampai ke server, kita spam request
                        -- carry-nya sampai diterima (max 10x percobaan per ronde). Kalau
                        -- gagal tapi egg-nya MASIH ADA di server (bukan keduluan orang lain,
                        -- tapi kita kelempar/keserempet Guard pas nyoba), JANGAN kabur balik
                        -- ke safezone -- langsung samperin lagi telurnya & coba carry ulang.
                        -- ==========================================
                        local round = 0
                        local maxRounds = 8 -- ~8 ronde x 10 request sebelum nyerah (bukan retreat, cuma stop nyoba)

                        repeat
                            round = round + 1
                            for i = 1, 10 do
                                if stealCancelled() then break end
                                carryOk, carryErr = EggCmds.RequestCarryAreaEgg(targetEgg.Uid, firstAreaSlotKey)
                                if carryOk then
                                    break
                                end
                                task.wait(0.03) -- Jeda 1-2 frame antar request
                            end

                            if stealCancelled() then
                                break
                            end

                            if not carryOk then
                                -- BUG SEBELUMNYA: cuma cek record-nya nil apa enggak. Padahal
                                -- pas orang LAIN berhasil carry duluan, record-nya BELUM ilang --
                                -- State-nya berubah jadi "Carried"/"GuardCarried" (punya orang
                                -- lain), bukan nil. Jadi kecatet "gaveup" (dikira masih available,
                                -- kita cuma kelamaan), bukan "lost" (beneran keduluan) -- makanya
                                -- Server Hop gak pernah kepicu. Sekarang cek State-nya juga.
                                local freshRecord = EggCmds.GetAreaEggRecord(targetEgg.Uid)
                                eggStillThere = freshRecord ~= nil and (freshRecord.State == "Slot" or freshRecord.State == "Dropped")
                                if eggStillThere and freshRecord.BottomCFrame then
                                    eggCF = freshRecord.BottomCFrame * CFrame.new(0, 3, 0)
                                end
                                if eggStillThere and round < maxRounds then
                                    -- Balik lagi ke telur (BUKAN kabur ke safezone) & pin ulang posisinya
                                    TweenMoveTo(hrp, hum, eggCF, stealCancelled)
                                    if stealCancelled() then break end
                                    task.wait(0.15) -- Beri waktu server catat posisi kita balik lagi
                                end
                            end
                        until carryOk or not eggStillThere or round >= maxRounds

                        loopConn:Disconnect()
                        end

                        if stealCancelled() then
                            finalOutcome = "cancelled"
                            break
                        end

                        if not carryOk then
                            if eggStillThere then
                                -- Masih ada tapi udah nyerah abis max ronde -- diem di dekat telur,
                                -- JANGAN balik ke safezone. Iterasi loop utama berikutnya otomatis
                                -- coba lagi (egg ini masih match) atau ganti target kalau udah gak match.
                                finalOutcome = "gaveup"
                            else
                                -- Beneran udah keduluan orang lain -- JANGAN balik ke safezone dulu.
                                -- Biarin diem di sini; iterasi loop utama berikutnya (di bawah, cuma
                                -- 0.05s lagi) langsung scan ulang & kalau ketemu egg lain yang masih
                                -- match filter, TweenMoveTo bakal langsung narik kita dari posisi
                                -- SEKARANG ini ke egg baru itu -- gak perlu muter dulu ke safezone.
                                -- Safezone cuma didatengin kalau scan berikutnya BENERAN gak nemu
                                -- target sama sekali (lihat cabang "else" di bawah, di luar pcall ini).
                                finalOutcome = "lost"
                            end
                            break
                        end

                        recentlyClaimedByMe[targetEgg.Uid] = os.clock()

                        -- ==========================================
                        -- 3. TWEEN KEMBALI KE SAFEZONE, SAMBIL MANTAU status egg (throttled,
                        -- tiap ~0.15s) selama perjalanan. Kalau State-nya balik jadi bukan
                        -- "Carried" sama kita lagi (kena pukul Guard di tengah jalan), langsung
                        -- BATALIN tween ke safezone (BUKAN lanjut ke safezone kosongan) dan
                        -- update eggCF ke lokasi jatuh yang baru buat di-retry outer loop.
                        -- ==========================================
                        -- BUG SEBELUMNYA: TweenMoveTo manggil isCancelledFn() SEKALI LAGI
                        -- di awal, SEBELUM tween mulai jalan sama sekali. Record egg abis
                        -- carry berhasil itu butuh waktu buat kereplikasi ke client (belum
                        -- pasti State-nya udah "Carried" tepat sepersekian detik abis carry
                        -- sukses) -- jadi kalau kita langsung anggap "State bukan Carried" =
                        -- dropped di cek PERTAMA, itu false-positive, dan hasilnya TweenMoveTo
                        -- kabur duluan sebelum sempet mulai (makanya karakter diem di tempat,
                        -- gak pernah tween ke safezone). Makanya sekarang WAJIB kekonfirmasi
                        -- State-nya "Carried" MINIMAL SEKALI dulu (confirmedCarrying) sebelum
                        -- status "bukan Carried" boleh dianggap beneran dropped.
                        local droppedAgain = false
                        local confirmedCarrying = false
                        local lastDropCheckAt = 0
                        local function abortTripIfDropped()
                            if stealCancelled() then return true end
                            local now = os.clock()
                            if now - lastDropCheckAt < 0.15 then
                                return false
                            end
                            lastDropCheckAt = now

                            local rec = EggCmds.GetAreaEggRecord(targetEgg.Uid)
                            if rec == nil then
                                -- Belum kekonfirmasi carrying -> kemungkinan besar cuma delay
                                -- replikasi, bukan dropped. Udah kekonfirmasi -> record kosong
                                -- berarti udah ke-claim duluan (bagus), biar loop klaim di
                                -- bawah yang nangani, bukan di sini.
                                return false
                            end

                            if rec.State == "Carried" and rec.CarrierUserId == LocalPlayer.UserId then
                                confirmedCarrying = true
                                return false
                            end

                            if not confirmedCarrying then
                                -- Belum pernah kekonfirmasi State-nya "Carried" -- kasih
                                -- kesempatan dulu, jangan buru-buru anggap dropped.
                                return false
                            end

                            -- Udah pernah kekonfirmasi Carried, tapi sekarang bukan lagi -> beneran dropped.
                            droppedAgain = true
                            warn("[AutoSteal] Egg " .. tostring(targetEgg.Uid) .. " ke-drop di tengah jalan ke safezone (State sekarang: " .. tostring(rec.State) .. ", Carrier: " .. tostring(rec.CarrierUserId) .. ") -- ngebatalin tween safezone, balik samperin lagi.")
                            if rec.BottomCFrame then
                                eggCF = rec.BottomCFrame * CFrame.new(0, 3, 0)
                            end
                            return true
                        end

                        TweenMoveTo(hrp, hum, safezoneCF, abortTripIfDropped)

                        if stealCancelled() then
                            finalOutcome = "cancelled"
                            break
                        end

                        if droppedAgain then
                            -- Lanjut ke outerAttempt berikutnya di while loop
                        else
                            local safezoneConn = game:GetService("RunService").Heartbeat:Connect(function()
                                hrp.CFrame = safezoneCF
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                hrp.AssemblyAngularVelocity = Vector3.zero
                            end)

                            -- Tunggu egg hilang dari snapshot = server sudah claim (max 5 detik,
                            -- atau berhenti lebih cepat kalau toggle di-OFF-in di tengah jalan)
                            local claimWaited = 0
                            local maxClaimWait = 5.0
                            repeat
                                task.wait(0.03) -- Poll super cepat
                                claimWaited = claimWaited + 0.03
                                -- Cek setelah minimal 0.06s
                                if claimWaited >= 0.06 and EggCmds.GetAreaEggRecord(targetEgg.Uid) == nil then
                                    break
                                end
                            until claimWaited >= maxClaimWait or stealCancelled()

                            safezoneConn:Disconnect()

                            if stealCancelled() then
                                finalOutcome = "cancelled"
                                break
                            end

                            if claimWaited >= maxClaimWait then
                                -- Double-check sebelum nyerah nunggu: mungkin kena pukul PAS
                                -- lagi nunggu klaim di safezone (bukan pas di perjalanan).
                                local rec = EggCmds.GetAreaEggRecord(targetEgg.Uid)
                                if rec == nil then
                                    finalOutcome = "claimed"
                                elseif rec.State ~= "Carried" or rec.CarrierUserId ~= LocalPlayer.UserId then
                                    if rec.BottomCFrame then
                                        eggCF = rec.BottomCFrame * CFrame.new(0, 3, 0)
                                    end
                                    -- Lanjut ke outerAttempt berikutnya di while loop
                                else
                                    finalOutcome = "claimed"
                                end
                            else
                                finalOutcome = "claimed"
                            end
                        end
                    end

                    -- SERVER HOP: target rarity (yang masuk filter StealRarities) beneran
                    -- keduluan orang lain ("lost", bukan "gaveup" -- itu beda kasus, egg-nya
                    -- masih ada tapi kita nyerah nyoba). Hop server baru buat cari lagi,
                    -- KECUALI udah masuk fase malam (AreaEggResetTimeUtil.IsNight) -- di situ
                    -- kita nyerah buat hari ini, biarin Auto Steal jalan normal tanpa hop.
                    if finalOutcome == "lost" and Config.AutoStealServerHop then
                        local isNight = false
                        pcall(function()
                            local AreaEggResetTimeUtil = require(game:GetService("ReplicatedStorage").Library.Util.AreaEggResetTimeUtil)
                            isNight = AreaEggResetTimeUtil.IsNight(game:GetService("Workspace"):GetServerTimeNow())
                        end)

                        if isNight then
                            logSelfTeleportAttempt("ServerHop SKIP (udah malam): " .. tostring(targetEgg.Rarity) .. " keduluan orang lain, gak hop lagi buat hari ini.")
                        else
                            warn("[ServerHop] " .. tostring(targetEgg.Rarity) .. " (" .. tostring(targetEgg.Uid) .. ") keduluan orang lain -- hop server baru...")
                            logSelfTeleportAttempt("ServerHop: " .. tostring(targetEgg.Rarity) .. " keduluan orang lain, hop server baru.")
                            Config.IsStealing = false
                            hopToNewServer()
                        end
                    end

                end)

                if not success then
                    warn("[AutoSteal] Error saat mencuri:", err)
                end

                Config.IsStealing = false
                task.wait(0.05)
            else
                -- Beneran gak ada egg sama sekali yang match filter kita SEKARANG --
                -- baru di titik INI kita balik ke safezone (bukan tiap kali ada egg
                -- yang keduluan orang lain). Kalau abis ini scan berikutnya ternyata
                -- ketemu target lagi, iterasi selanjutnya bakal TweenMoveTo langsung
                -- dari safezone ke egg itu seperti biasa.
                --
                -- CUMA SEKALI per sesi idle (hasSettledAtSafezoneWhileIdle) -- kalau
                -- gak dibatasin gini, ini bakal jalan TIAP iterasi (~0.3 detik sekali)
                -- selama masih idle, jadi kalau kita gerakin character manual pas lagi
                -- gak ngambil egg, langsung ke-tarik balik lagi dalam sepersekian detik,
                -- berulang terus -- itu bug "kesitu lagi kesitu lagi" yang dilaporkan.
                pcall(function()
                    EggCmds.RequestAreaEggSnapshot()
                end)
                if not hasSettledAtSafezoneWhileIdle then
                    pcall(function()
                        if hrp then
                            local safezoneCF = CFrame.new(518.66, 70.57, -364.73) * CFrame.Angles(math.rad(180.00), math.rad(-89.82), math.rad(180.00))
                            if (hrp.Position - safezoneCF.Position).Magnitude > 5 then
                                TweenMoveTo(hrp, hum, safezoneCF, function() return not Config.AutoSteal end)
                            end
                        end
                    end)
                    hasSettledAtSafezoneWhileIdle = true
                end

                -- SERVER HOP "RE-ROLL": server ini beneran gak punya target rarity kita
                -- SAMA SEKALI (bukan keduluan orang -- itu kasus "lost" di atas). Daripada
                -- nunggu sampai 5 menit reset berikutnya di server yang SAMA, hop ke server
                -- lain buat "roll" ulang. Ditunggu dulu beberapa detik (IDLE_HOP_DELAY)
                -- biar snapshot sempet nyampe penuh abis baru landing/rejoin -- jangan
                -- langsung hop di detik pertama gara-gara data belum sinkron.
                if Config.AutoStealServerHop and Config.StealRarities[1] ~= "None" then
                    if not idleNoTargetSince then
                        idleNoTargetSince = os.clock()
                    elseif os.clock() - idleNoTargetSince >= IDLE_HOP_DELAY_SECONDS then
                        -- GATE BARU: seed egg itu sama di SEMUA server (period+area+slot doang,
                        -- gak ada faktor server). Kalau prediksi bilang target kita emang GAK
                        -- dijadwalin muncul period ini, hop ke server lain PERCUMA -- semua server
                        -- bakal sama aja sampai period berikutnya. Jangan hop, tunggu period ganti.
                        if not isTargetRarityExpectedThisPeriod(Config.StealRarities) then
                            idleNoTargetSince = os.clock() -- geser timer, jangan hop, cek lagi nanti
                        else
                            local isNight = false
                            pcall(function()
                                local AreaEggResetTimeUtil = require(game:GetService("ReplicatedStorage").Library.Util.AreaEggResetTimeUtil)
                                isNight = AreaEggResetTimeUtil.IsNight(game:GetService("Workspace"):GetServerTimeNow())
                            end)

                            if isNight then
                                logSelfTeleportAttempt("ServerHop SKIP (udah malam): gak ada target rarity di server ini, gak hop lagi buat hari ini.")
                                idleNoTargetSince = os.clock() -- jangan re-log tiap iterasi, geser lagi
                            else
                                warn("[ServerHop] Gak ada target rarity (" .. table.concat(Config.StealRarities, "/") .. ") di server ini -- hop server baru...")
                                logSelfTeleportAttempt("ServerHop: gak ada target rarity (" .. table.concat(Config.StealRarities, "/") .. ") di server ini, hop server baru.")
                                Config.IsStealing = false
                                hopToNewServer()
                                return
                            end
                        end
                    end
                else
                    idleNoTargetSince = nil
                end

                task.wait(0.3)
            end
        end
        task.wait(0.05)
    end
end

-- ============================================================
-- MAIN TAB
-- ============================================================
local MainTab = Tabs:AddTab({ Name = "Main", Icon = "rbxassetid://10734950309" })

local FarmSection = MainTab:AddSection("Auto Farm")

local autoStealToggle
autoStealToggle = FarmSection:AddToggle({
    Title = "Auto Steal Egg",
    Content = "Automatically teleports and steals eggs based on filters",
    Default = false,
    Callback = function(val)
        Config.AutoSteal = val
        if val and UI_LOADED then
            task.spawn(AutoStealLoop)
        elseif not val then
            Config.IsStealing = false
        end
    end
})

FarmSection:AddToggle({
    Title = "Auto Server Hop",
    Content = "Hops to a new server when the target egg is taken by someone else.",
    Default = false,
    Callback = function(val)
        Config.AutoStealServerHop = val
    end
})

local tweenSpeedInput
tweenSpeedInput = FarmSection:AddInput({
    Title = "Move Speed Multiplier",
    Content = "Speed multiplier for movement (max 5, default 2)",
    Default = tostring(Config.TweenSpeedMultiplier),
    Callback = function(val)
        local num = tonumber(val)
        if num and num > 0 and num <= MAX_TWEEN_SPEED_MULTIPLIER then
            Config.TweenSpeedMultiplier = num
        else
            Config.TweenSpeedMultiplier = DEFAULT_TWEEN_SPEED_MULTIPLIER
            if UI_LOADED then
                warn("Move Speed Multiplier: '" .. tostring(val) .. "' is invalid or over the max (" .. MAX_TWEEN_SPEED_MULTIPLIER .. "), reset to default (" .. DEFAULT_TWEEN_SPEED_MULTIPLIER .. ")")
            end
        end
    end
})

local areaDropdown
areaDropdown = FarmSection:AddDropdown({
    Title = "Select Area",
    Content = "Choose which zone to farm eggs from",
    Options = {
        "None",
        "Forest",
        "Lake",
        "Jungle", 
        "Desert", 
        "Snow", 
        "Volcano", 
        "Abyss Ocean",
        "Prehistoric",
        "Cosmic"
    },
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.StealAreas = handleDropdownChange(val, areaDropdown)
    end
})

local rarityDropdown
rarityDropdown = FarmSection:AddDropdown({
    Title = "Filter By Rarity (Steal)",
    Content = "Select which egg rarities to prioritize",
    Options = {
        "None",
        "Common",
        "Uncommon", 
        "Rare", 
        "Epic", 
        "Legendary", 
        "Mythic", 
        "Cosmic",
        "Secret", 
        "Eternal",
        "Divine",
        "Prismatic",
        "Transcendent"
    },
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.StealRarities = handleDropdownChange(val, rarityDropdown)

        if UI_LOADED then
            for _, r in ipairs(Config.StealRarities) do
            end
        end
    end
})
-- ============================================================
-- AUTO TAB (Auto Place Egg)
-- ============================================================
local AutoTab = Tabs:AddTab({ Name = "Auto", Icon = "rbxassetid://10734950309" })
local PlaceSection = AutoTab:AddSection("Auto Place Egg")

local function AutoPlaceLoop()
    while Config.AutoPlace do
        task.wait(1.5)
        local success, err = pcall(function()
            if Config.IsStealing then return end

                        local ReplicatedStorage = game:GetService("ReplicatedStorage")
                        local HttpService = game:GetService("HttpService")
                        local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds)
                        local Assets = require(ReplicatedStorage.Directory.Assets)
                        
                        -- Cari Plot ASLI kita lewat nama di papan PlotSign
                        local myTruePlot = nil
                        local plotsFolder = workspace:FindFirstChild("Plots")
                        if plotsFolder then
                            for _, p in ipairs(plotsFolder:GetChildren()) do
                                local sign = p:FindFirstChild("PlotSign")
                                if sign then
                                    local pSign = sign:FindFirstChild("PlayerPlotSign")
                                    if pSign and pSign:FindFirstChild("Frame") and pSign.Frame:FindFirstChild("PlayerName") then
                                        local rawText = pSign.Frame.PlayerName.Text
                                        local cleanText = string.gsub(rawText, "<[^>]+>", "")
                                        if string.find(string.lower(cleanText), string.lower(LocalPlayer.Name)) or string.find(string.lower(cleanText), string.lower(LocalPlayer.DisplayName)) then
                                            myTruePlot = p
                                            break
                                        end
                                    end
                                end
                            end
                        else
                        end

                        if not myTruePlot then 
                            return 
                        end

                        local ToUpdate = myTruePlot:FindFirstChild("ToUpdate")
                        local PetArea = ToUpdate and ToUpdate:FindFirstChild("PetArea")
                        local CenterPoint = myTruePlot:FindFirstChild("CenterPoint") or PetArea
                        
                        if not PetArea then 
                            return 
                        end

                        -- Kumpulkan telur yang ada di inventory
                        local eggsToPlace = {}
                        local myEggs = EggCmds.GetOwnerRuntimeRecords(LocalPlayer.UserId)
                        
                        local placedCount = 0
                        if type(myEggs) == "table" then
                            for uid, record in pairs(myEggs) do
                                if record.Placement ~= nil then
                                    placedCount = placedCount + 1
                                else
                                    local category = record.AssetCategory
                                    local categoryData = category and Assets.Directory[category]
                                    local rarity = "Unknown"
                                    
                                    if categoryData and categoryData.Rarity then
                                        local rObj = categoryData.Rarity
                                        rarity = rObj.DisplayName or rObj._id or rObj.Name or "Unknown"
                                    end
                                    
                                    local match = false
                                    if #Config.PlaceRarities == 0 or table.find(Config.PlaceRarities, "None") or table.find(Config.PlaceRarities, "All") then
                                        match = true
                                    else
                                        match = table.find(Config.PlaceRarities, rarity) ~= nil
                                    end
                                    
                                    -- Coba ambil nilai Kg dari record atau asset data
                                    local kgVal = tonumber(record.Kg) or tonumber(record.Weight) or tonumber(record.kg)
                                    if not kgVal and categoryData then
                                        kgVal = tonumber(categoryData.Kg) or tonumber(categoryData.Weight) or tonumber(categoryData.kg)
                                    end
                                    kgVal = kgVal or 0

                                    if match then
                                        table.insert(eggsToPlace, { Uid = uid, Rarity = rarity, Kg = kgVal })
                                    end
                                end
                            end
                        end
                    -- Urutkan berdasarkan Kg paling besar (descending)
                    table.sort(eggsToPlace, function(a, b)
                        return a.Kg > b.Kg
                    end)
                    
                    -- Simpan posisi awal sebelum gerak ke plot (hanya jika kita ada telur)
                    local char = LocalPlayer.Character
                    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                    local hum  = char and char:FindFirstChildOfClass("Humanoid")
                    local originalCF = nil

                    if #eggsToPlace == 0 or placedCount >= 30 then
                        -- Jika tidak ada telur yg mau di place, atau plot penuh,
                        -- maka kembali idle (tunggu iterasi loop selanjutnya)
                        return
                    end

                    if hrp then originalCF = hrp.CFrame end

                    if Config.IsStealing then return end

                    -- Dipakai TweenMoveTo buat cek tiap frame: begitu toggle Auto Place
                    -- di-OFF-in (atau Auto Steal jadi prioritas), tween yang lagi jalan
                    -- langsung di-Cancel() SEKARANG JUGA.
                    local function placeCancelled()
                        return not Config.AutoPlace or Config.IsStealing
                    end

                    -- Gerak (tween) ke plot (di atas PetArea)
                        if hrp and PetArea then
                            TweenMoveTo(hrp, hum, PetArea.CFrame * CFrame.new(0, 3, 0), placeCancelled)
                            if placeCancelled() then return end
                            local fallWaited = 0
                            while fallWaited < 0.5 and not placeCancelled() do
                                task.wait(0.05)
                                fallWaited = fallWaited + 0.05
                            end
                            if Config.IsStealing then return end -- Abort if steal started during wait
                            if not Config.AutoPlace then return end
                        end
                        
                        local stopPlacing = false
                        
                        -- Catat semua posisi yang sudah terisi di plot saat ini
                        local occupiedPositions = {}
                        for _, rec in pairs(myEggs) do
                            if rec.Placement then
                                local pos
                                if typeof(rec.Placement) == "CFrame" then pos = rec.Placement.Position
                                elseif typeof(rec.Placement) == "Vector3" then pos = rec.Placement
                                elseif rec.Placement.Position then pos = rec.Placement.Position end
                                if pos then table.insert(occupiedPositions, pos) end
                            end
                        end
                        
                        local searchIdx = 0

                        for _, eggInfo in ipairs(eggsToPlace) do
                            if not Config.AutoPlace or stopPlacing then break end
                            
                            -- CEK LIMIT MAKSIMAL 30 TELUR
                            if placedCount >= 30 then
                                stopPlacing = true
                                break
                            end
                            
                            -- PRIORITAS UTAMA: Jika Auto Steal sedang angkat telur, hentikan Auto Place sementara!
                            if Config.IsStealing then
                                return
                            end
                            
                            local uid = eggInfo.Uid
                            
                            -- Request server untuk nge-equip telurnya karena gak ada fisik tool kalau belum di-equip
                            local eqSuccess, eqErr = EggCmds.RequestEquipTool(uid)
                            if eqSuccess then
                                if Config.IsStealing then return end
                                task.wait(0.15) -- Dipercepat dari 0.5
                                
                                local placed = false
                                while searchIdx < 30 and not placed do
                                    local placeCFrame = nil
                                    if PetArea and CenterPoint then
                                        while searchIdx < 30 do
                                            local columns = 10 -- 10 telur per baris
                                            local paddingX = 6
                                            local paddingZ = 6
                                            
                                            local usableWidth = PetArea.Size.X - paddingX
                                            local usableDepth = PetArea.Size.Z - paddingZ
                                            
                                            local spacingX = usableWidth / columns
                                            local spacingZ = 6 -- Jarak antar baris ke belakang
                                            
                                            local row = math.floor(searchIdx / columns)
                                            local col = searchIdx % columns
                                            
                                            -- Mulai dari pojok kiri atas (-X/2, -Z/2)
                                            local startX = -(usableWidth / 2) + (spacingX / 2)
                                            local startZ = -(usableDepth / 2) + (spacingZ / 2)
                                            
                                            local rx = startX + (col * spacingX)
                                            local rz = startZ + (row * spacingZ)
                                            
                                            local worldPos = PetArea.CFrame * Vector3.new(rx, 0, rz)
                                            local localPos = CenterPoint.CFrame:PointToObjectSpace(worldPos)
                                            local testCFrame = CFrame.new(localPos.X, -0.5, localPos.Z)
                                            
                                            -- Cek apakah posisi ini kosong secara logis (tidak ada telur terdekat)
                                            local isOccupied = false
                                            for _, pos in ipairs(occupiedPositions) do
                                                if (pos - testCFrame.Position).Magnitude < 1.0 then
                                                    isOccupied = true
                                                    break
                                                end
                                            end
                                            
                                            if not isOccupied then
                                                placeCFrame = testCFrame
                                                break
                                            end
                                            searchIdx = searchIdx + 1
                                        end
                                    end
                                    
                                    if not placeCFrame then
                                        stopPlacing = true
                                        break
                                    end
                                    
                                    if Config.IsStealing then return end
                                    local plSuccess, plErr = EggCmds.RequestPlaceEgg(uid, placeCFrame)
                                    if plSuccess then
                                        table.insert(occupiedPositions, placeCFrame.Position)
                                        placedCount = placedCount + 1
                                        placed = true
                                        task.wait(0.15) -- Dipercepat dari 0.5
                                    else
                                        local lErr = plErr and string.lower(tostring(plErr)) or ""
                                        if string.find(lErr, "full") or string.find(lErr, "limit") 
                                            or string.find(lErr, "capacity") or string.find(lErr, "maximum") then
                                            Config.AutoPlace = false
                                            stopPlacing = true
                                            break
                                        end
                                        
                                        -- Jika gagal karena tertabrak hitbox telur besar, anggap grid ini penuh & lanjut ke grid sebelah
                                        table.insert(occupiedPositions, placeCFrame.Position)
                                        searchIdx = searchIdx + 1
                                        task.wait(0.1)
                                    end
                                end
                                
                            end
                        end

                        -- Kembalikan (tween) ke posisi awal setelah kelar place
                        if originalCF and hrp and not Config.IsStealing then
                            TweenMoveTo(hrp, hum, originalCF, placeCancelled)
                            task.wait(0.2)
                        end
        end)
        if not success then
            warn("Auto Place Error: " .. tostring(err))
        end
    end -- End of while loop
end

local autoPlaceToggle
autoPlaceToggle = PlaceSection:AddToggle({
    Title = "Auto Place Egg",
    Content = "Automatically place matching eggs on your plot",
    Default = false,
    Callback = function(val)
        Config.AutoPlace = val
        if val and UI_LOADED then
            task.spawn(AutoPlaceLoop)
        end
    end
})

local placeDropdown
placeDropdown = PlaceSection:AddDropdown({
    Title = "Filter By Rarity (Place)",
    Content = "Select which egg rarities to Auto Place",
    Options = {
        "None",
        "All",
        "Common", 
        "Uncommon", 
        "Rare", 
        "Epic", 
        "Legendary", 
        "Mythic", 
        "Cosmic",
        "Secret", 
        "Eternal",
        "Divine",
        "Prismatic",
        "Transcendent"
    },
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.PlaceRarities = handleDropdownChange(val, placeDropdown)
    end
})

-- ============================================================
-- AUTO HATCH SECTION
-- ============================================================
local HatchSection = AutoTab:AddSection("Auto Hatch Egg")

local autoHatchToggle
autoHatchToggle = HatchSection:AddToggle({
    Title = "Auto Hatch Egg",
    Content = "Automatically hatch any ready eggs on your plot",
    Default = false,
    Callback = function(val)
        Config.AutoHatch = val
        if val then
            task.spawn(function()
                local failedHatchAttempts = {}
                while Config.AutoHatch do
                    task.wait(2.5) -- Loop santai tiap 2.5 detik (tidak akan lag)
                    pcall(function()
                        local ReplicatedStorage = game:GetService("ReplicatedStorage")
                        local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds)
                        
                        -- Dapatkan telur yang kita punya
                        local myEggs = EggCmds.GetOwnerRuntimeRecords(LocalPlayer.UserId)
                        
                        local eggsToHatch = {}
                        for uid, record in pairs(myEggs) do
                            -- Telur HANYA bisa menetas kalau sedang dipajang di Plot (Placement tidak nil)
                            if record.Placement ~= nil then
                                table.insert(eggsToHatch, uid)
                            end
                        end
                        
                        -- Coba hatch semua telur yang dipajang
                        local now = os.time()
                        for _, uid in ipairs(eggsToHatch) do
                            if not Config.AutoHatch then break end
                            
                            -- PRIORITAS UTAMA: Jangan hatch kalau sedang steal
                            if Config.IsStealing then 
                                break 
                            end
                            
                            -- Jangan spam request ke server kalau telur belum siap (baru di-check barusan)
                            if failedHatchAttempts[uid] and now < failedHatchAttempts[uid] then
                                continue
                            end
                            
                            local success, err = EggCmds.RequestHatchEgg(uid)
                            
                            -- Jika server mengembalikan success == true, artinya telur itu READY!
                            if success then
                                EggCmds.RequestCompleteHatchEgg(uid)
                                failedHatchAttempts[uid] = nil -- Bersihkan cache
                                task.wait(0.1)
                            else
                                -- Jika server nolak, berarti BELUM MATENG, kita blacklist ID ini selama 15 detik biar gak spam
                                failedHatchAttempts[uid] = now + 15
                            end
                        end
                    end)
                end -- End of while loop
            end)
        end
    end
})

-- ============================================================
-- AUTO SELL SECTION
-- ============================================================
local SellSection = AutoTab:AddSection("Auto Sell Pet")

local isAutoSellRunning = false
local function startAutoSellLoop()
    if isAutoSellRunning then return end
    isAutoSellRunning = true
    task.spawn(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds)
        local Assets = require(ReplicatedStorage.Directory.Assets)
        local Save = require(ReplicatedStorage.Library.Client.Save)
        local AssetCmds = require(ReplicatedStorage.Library.Client.AssetCmds)
        local LocalPlayer = game:GetService("Players").LocalPlayer
        
        while Config.AutoSell or Config.SellAll do
            local success, err = pcall(function()
                if Config.IsStealing then return end
                        
                        -- Menggunakan Save.Get().Inventory (struktur flat dictionary: [uid] = record)
                        local mySave = Save.Get()
                        local myInventory = mySave and mySave.Inventory or {}
                        
                        -- Ambil array pet yang di-equip dari Save
                        local equippedAssets = mySave and mySave.EquippedAssets or {}
                        
                        local uidsToSell = {}
                        local foundMatching = 0
                        
                        if type(myInventory) == "table" then
                            for uid, record in pairs(myInventory) do
                                if type(record) == "table" then
                                    -- Cek status equip: pet ada di array EquippedAssets milik Save
                                    local isEquipped = record.Equipped or record.IsEquipped or record._eq or table.find(equippedAssets, uid) ~= nil
                                    
                                    -- Cek status favorit (mendukung berbagai nama dari localization / atribut)
                                    local isFavorite = record.IsFavorite == true or record["Jadikan Favorit"] == true or record["Favorite"] == true
                                    
                                    -- Asset ID di data inventory PS99 / Steal an Egg disimpan di .Category
                                    local assetId = record.Category or record.id or record.AssetCategory or record.ItemId
                                    local categoryData = assetId and Assets.Directory[assetId]
                                    
                                    local petName = categoryData and (categoryData.DisplayName or categoryData._id or categoryData.Name) or "Unknown"
                                    local rarityObj = categoryData and categoryData.Rarity
                                    local rarity = rarityObj and (rarityObj.DisplayName or rarityObj._id or rarityObj.Name) or "Unknown"
                                    
                                    local match = false
                                    if Config.SellAll then
                                        match = true
                                    else
                                        local nameMatch = false
                                        if #Config.SellNames == 0 or table.find(Config.SellNames, "None") then
                                            nameMatch = false
                                        elseif table.find(Config.SellNames, "All") then
                                            nameMatch = true
                                        else
                                            nameMatch = table.find(Config.SellNames, petName) ~= nil
                                        end
                                        
                                        local rarityMatch = false
                                        if #Config.SellRarities == 0 or table.find(Config.SellRarities, "None") then
                                            rarityMatch = false
                                        elseif table.find(Config.SellRarities, "All") then
                                            rarityMatch = true
                                        else
                                            rarityMatch = table.find(Config.SellRarities, rarity) ~= nil
                                        end
                                        
                                        match = nameMatch or rarityMatch
                                    end
                                    
                                    if match and not isFavorite then
                                        foundMatching = foundMatching + 1
                                        if isEquipped then
                                        else
                                            table.insert(uidsToSell, uid)
                                        end
                                    end
                                end
                            end
                        end
                        
                        if #uidsToSell > 0 then
                            
                            -- Jika mode Ignore Filter aktif, gunakan SellAllAssets agar langsung bersih 1 tas (sangat cepat)
                            -- Jika tidak (pakai filter), gunakan loop individual SellAsset
                            if Config.SellAll then
                                local EventAll = ReplicatedStorage.Network:FindFirstChild("AssetInventory: SellAllAssets")
                                if EventAll then
                                    EventAll:FireServer(uidsToSell)
                                else
                                    warn("Auto Sell Error: Remote SellAllAssets tidak ditemukan di Network!")
                                end
                            else
                                local EventSell = ReplicatedStorage.Network:FindFirstChild("AssetInventory: SellAsset")
                                if EventSell then
                                    for _, uid in ipairs(uidsToSell) do
                                        -- Di game ini, pet sudah berupa Tool di dalam Backpack.
                                        -- Kita hanya perlu mencari Tool dengan attribute UID yang cocok lalu meng-equip-nya
                                        local char = LocalPlayer.Character
                                        local hum = char and char:FindFirstChildOfClass("Humanoid")
                                        if char and hum then
                                            local foundTool = nil
                                            for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                                                if tool:IsA("Tool") and tool:GetAttribute("UID") == uid then
                                                    foundTool = tool
                                                    break
                                                end
                                            end
                                            if not foundTool then
                                                for _, tool in ipairs(char:GetChildren()) do
                                                    if tool:IsA("Tool") and tool:GetAttribute("UID") == uid then
                                                        foundTool = tool
                                                        break
                                                    end
                                                end
                                            end
                                            
                                            if foundTool then
                                                hum:EquipTool(foundTool)
                                                task.wait(0.05) -- Jeda super singkat (hanya beberapa frame)
                                            else
                                            end
                                        end
                                        
                                        EventSell:FireServer({uid})
                                        task.wait(0.05) -- Jeda super singkat antar penjualan
                                    end
                            else
                                warn("Auto Sell Error: Remote SellAsset tidak ditemukan di Network!")
                            end
                            end
                        elseif foundMatching > 0 then
                        end
                    end)
                    if not success then
                        warn("Auto Sell Error:", err)
                    end
                    task.wait(2)
                end
                isAutoSellRunning = false
            end)
end

local isAutoSellEggRunning = false
local function startAutoSellEggLoop()
    if isAutoSellEggRunning then return end
    isAutoSellEggRunning = true
    task.spawn(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds)
        local Assets = require(ReplicatedStorage.Directory.Assets)
        local Areas = require(ReplicatedStorage.Directory.Areas)
        local Save = require(ReplicatedStorage.Library.Client.Save)
        local LocalPlayer = game:GetService("Players").LocalPlayer

        while Config.AutoSellEgg do
            local success, err = pcall(function()
                if Config.IsStealing then return end
                
                local mySave = Save.Get()
                local equippedAssets = mySave and mySave.EquippedAssets or {}
                
                local myEggs = EggCmds.GetOwnerRuntimeRecords(LocalPlayer.UserId)
                local uidsToSell = {}
                local foundMatching = 0
                local totalRecords = 0
                if type(myEggs) == "table" then
                    for _ in pairs(myEggs) do totalRecords = totalRecords + 1 end
                end

                if type(myEggs) == "table" then
                    for uid, record in pairs(myEggs) do
                        if type(record) == "table" then
                            local isEquipped = record.Equipped or record.IsEquipped or record._eq or table.find(equippedAssets, uid) ~= nil
                            -- Jika telur sedang dipajang di plot, anggap seperti di-equip
                            if record.Placement ~= nil then
                                isEquipped = true
                            end
                            
                            local isFavorite = record.IsFavorite == true or record["Jadikan Favorit"] == true or record["Favorite"] == true

                            -- PENTING: AssetCategory di sini adalah nama PET di dalam egg (mis. "Tob Tobi Tob Tob"),
                            -- bukan nama Area. Assets.Directory & Areas.Directory itu strict table:
                            -- index dengan key yang gak ada bikin ERROR (bukan return nil), jadi jangan pernah
                            -- Areas.Directory[assetId] langsung -- selalu pcall / iterasi pairs() aja.
                            local assetId = record.AssetCategory or record.Category or record.id or record.ItemId

                            local eggName = "Egg"
                            local rarity = "Unknown"

                            local assetOk, assetData = pcall(function()
                                return assetId and Assets.Directory[assetId] or nil
                            end)

                            if assetOk and assetData then
                                local rObj = assetData.Rarity or record.Rarity
                                rarity = type(rObj) == "table" and (rObj.DisplayName or rObj._id or rObj.Name) or type(rObj) == "string" and rObj or "Unknown"

                                -- Cari nama Area asal egg ini dengan iterasi aman (bukan index langsung)
                                local areaOk = pcall(function()
                                    for _, areaData in pairs(Areas.Directory) do
                                        if type(areaData) == "table" and type(areaData.DropTable) == "table" then
                                            for _, entry in ipairs(areaData.DropTable) do
                                                if entry[1] == assetId then
                                                    eggName = (areaData.DisplayName or "Egg") .. " Egg"
                                                    return
                                                end
                                            end
                                        end
                                    end
                                end)
                                if not areaOk then
                                    eggName = tostring(assetId) .. " Egg"
                                end
                            end

                            if rarity == "Unknown" and record.Rarity then
                                local rObj = record.Rarity
                                rarity = type(rObj) == "table" and (rObj.DisplayName or rObj._id or rObj.Name) or type(rObj) == "string" and rObj or "Unknown"
                            end

                            local rarityMatch = false
                            if #Config.SellEggRarities == 0 or table.find(Config.SellEggRarities, "None") then
                                rarityMatch = false
                            elseif table.find(Config.SellEggRarities, "All") then
                                rarityMatch = true
                            else
                                rarityMatch = table.find(Config.SellEggRarities, rarity) ~= nil
                            end

                            if rarityMatch and not isFavorite then
                                foundMatching = foundMatching + 1
                                if isEquipped then
                                    local reason = (record.Placement ~= nil) and "sedang dipajang di plot" or "sedang di-equip"
                                else
                                    table.insert(uidsToSell, uid)
                                end
                            end
                        end
                    end
                end
                
                if #uidsToSell > 0 then
                    local EventSell = ReplicatedStorage.Network:FindFirstChild("AssetInventory: SellAsset")
                    if EventSell then
                        local soldCount = 0
                        for _, uid in ipairs(uidsToSell) do
                            if not Config.AutoSellEgg then break end
                            if Config.IsStealing then break end

                            local eqSuccess, eqErr = EggCmds.RequestEquipTool(uid)

                            if eqSuccess then
                                task.wait(0.15)
                                EventSell:FireServer({uid})
                                soldCount = soldCount + 1
                                task.wait(0.1)
                            end
                        end
                    else
                        warn("Auto Sell Egg Error: Remote SellAsset tidak ditemukan!")
                    end
                elseif foundMatching > 0 then
                else
                end
            end)
            if not success then warn("Auto Sell Egg Error:", err) end
            task.wait(2)
        end
        isAutoSellEggRunning = false
    end)
end

local autoSellToggle
autoSellToggle = SellSection:AddToggle({
    Title = "Auto Sell Pet",
    Content = "Automatically sells pets that match the Name or Rarity filter",
    Default = false,
    Callback = function(val)
        Config.AutoSell = val
        if val and UI_LOADED then
            startAutoSellLoop()
        end
    end
})

SellSection:AddToggle({
    Title = "Auto Sell All Pet",
    Content = "WARNING: If Auto Sell is ON, this ignores filter and sells ALL pets!",
    Default = false,
    Callback = function(val)
        Config.SellAll = val
        if val and UI_LOADED then
            startAutoSellLoop()
        end
    end
})

local petNamesList = {"None", "All"}
pcall(function()
    local Assets = require(game:GetService("ReplicatedStorage").Directory.Assets)
    local namesMap = {}
    for k, v in pairs(Assets.Directory) do
        if type(v) == "table" and (v.DisplayName or v._id or v.Name) then
            local disp = v.DisplayName or v._id or v.Name
            if not namesMap[disp] then
                namesMap[disp] = true
                table.insert(petNamesList, disp)
            end
        end
    end
    table.sort(petNamesList, function(a, b) 
        if a == "None" then return true end
        if b == "None" then return false end
        if a == "All" then return true end
        if b == "All" then return false end
        return a < b 
    end)
end)

local sellNamesDropdown
sellNamesDropdown = SellSection:AddDropdown({
    Title = "Filter By Pet Name",
    Content = "Select which pets to Auto Sell",
    Options = petNamesList,
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.SellNames = handleDropdownChange(val, sellNamesDropdown)
    end
})

local sellRarityDropdown
sellRarityDropdown = SellSection:AddDropdown({
    Title = "Filter By Rarity (Sell Pet)",
    Content = "Select which pet rarities to Auto Sell",
    Options = {
        "None",
        "All",
        "Common", 
        "Uncommon", 
        "Rare", 
        "Epic", 
        "Legendary", 
        "Mythic",
        "Secret",
        "Divine",
        "Cosmic",
        "Eternal",
        "Prismatic",
        "Transcendent"
    },
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.SellRarities = handleDropdownChange(val, sellRarityDropdown)
    end
})

-- ============================================================
-- AUTO SELL EGG SECTION
-- ============================================================
local SellEggSection = AutoTab:AddSection("Auto Sell Egg")

local autoSellEggToggle
autoSellEggToggle = SellEggSection:AddToggle({
    Title = "Auto Sell Egg",
    Content = "Automatically sells eggs that match the Rarity filter",
    Default = false,
    Callback = function(val)
        Config.AutoSellEgg = val
        if val and UI_LOADED then
            startAutoSellEggLoop()
        end
    end
})

local sellEggRarityDropdown
sellEggRarityDropdown = SellEggSection:AddDropdown({
    Title = "Filter By Rarity (Sell Egg)",
    Content = "Select which egg rarities to Auto Sell",
    Options = {
        "None",
        "All",
        "Common", 
        "Uncommon", 
        "Rare", 
        "Epic", 
        "Legendary", 
        "Mythic",
        "Secret",
        "Divine",
        "Cosmic",
        "Eternal",
        "Prismatic",
        "Transcendent"
    },
    Default = {"None"},
    Multi = true,
    Callback = function(val)
        Config.SellEggRarities = handleDropdownChange(val, sellEggRarityDropdown)
    end
})

-- ============================================================
-- AUTO TRADE / GIFT SECTION (Di AutoTab)
-- ============================================================
local TradeSection = AutoTab:AddSection("Auto Trade / Gift")

-- State untuk Auto Gift
local AutoGiftEnabled = false
local AutoAcceptGift = false
local AutoGiftTarget = nil -- Nama player (string)
local AutoGiftItemName = "" -- Nama item/telur (string)
local AutoGiftRarity = nil

-- Helper: Ambil rarity dari Tool via Assets Directory
local function GetItemRarity(tool)
    if not tool:IsA("Tool") then return "Unknown" end
    local category = tool:GetAttribute("Category")
    local ok, assetsDir = pcall(function()
        return require(game:GetService("ReplicatedStorage").Directory.Assets)
    end)
    if ok and assetsDir and assetsDir.Directory and assetsDir.Directory[category] and assetsDir.Directory[category].Rarity then
        local rarityObj = assetsDir.Directory[category].Rarity
        return rarityObj.DisplayName or rarityObj._id or rarityObj.Name or "Unknown"
    end
    return "Unknown"
end

-- Helper: Ambil nama item asli dari Tool via Assets Directory (Biar cocok sama Dropdown)
local function GetItemName(tool)
    if not tool:IsA("Tool") then return tool.Name end
    local category = tool:GetAttribute("Category")
    if not category then return tool.Name end
    local ok, assetsDir = pcall(function()
        return require(game:GetService("ReplicatedStorage").Directory.Assets)
    end)
    if ok and assetsDir and assetsDir.Directory and assetsDir.Directory[category] then
        local data = assetsDir.Directory[category]
        return data.DisplayName or data._id or data.Name or category
    end
    return tool.Name
end

-- Dropdown: Target Player
local giftPlayerDropdown
giftPlayerDropdown = TradeSection:AddDropdown({
    Title = "Target Player",
    Content = "Choose which player receives the gift",
    Options = {"None"},
    Default = "None",
    Multi = false,
    Callback = function(val)
        AutoGiftTarget = (type(val) == "table" and val[1]) or val
    end
})

-- Helper: Update daftar player di dropdown
local function UpdateGiftPlayerList()
    local pList = {"None"}
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(pList, p.Name)
        end
    end
    if giftPlayerDropdown and giftPlayerDropdown.SetValues then
        pcall(function() giftPlayerDropdown:SetValues(pList, pList[1] or "None") end)
    end
end

-- Listener otomatis kalau ada player join/leave
game:GetService("Players").PlayerAdded:Connect(UpdateGiftPlayerList)
game:GetService("Players").PlayerRemoving:Connect(UpdateGiftPlayerList)
UpdateGiftPlayerList()

-- Button: Manual Refresh
TradeSection:AddButton({
    Title = "Refresh Player List",
    Content = "Update the list of players in this server",
    Callback = function()
        UpdateGiftPlayerList()
    end
})

-- Membangun daftar semua item dari Assets.Directory
local allItemNames = {"None"}
local itemAdded = {["None"] = true}
pcall(function()
    local ok, assetsDir = pcall(function()
        return require(game:GetService("ReplicatedStorage").Directory.Assets)
    end)
    if ok and assetsDir and assetsDir.Directory then
        for category, data in pairs(assetsDir.Directory) do
            if type(data) == "table" and data.Rarity then
                local itemName = data.DisplayName or data._id or data.Name or category
                if itemName and not itemAdded[itemName] then
                    itemAdded[itemName] = true
                    table.insert(allItemNames, itemName)
                end
            end
        end
    end
end)
table.sort(allItemNames, function(a, b)
    if a == "None" then return true end
    if b == "None" then return false end
    return a < b
end)

-- Dropdown: Target Item Name
local giftItemDropdown = TradeSection:AddDropdown({
    Title = "Target Item Name",
    Content = "Choose the item/egg name to gift",
    Options = allItemNames,
    Default = "None",
    Multi = false,
    Callback = function(val)
        AutoGiftItemName = (type(val) == "table" and val[1]) or val
        if AutoGiftItemName == "None" then AutoGiftItemName = "" end
    end
})

-- Dropdown: Rarity yang mau di-gift
TradeSection:AddDropdown({
    Title = "Rarity to Gift",
    Content = "Choose the egg rarity to send to the target",
    Options = {"None", "All", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Cosmic", "Secret", "Eternal", "Divine", "Prismatic", "Transcendent"},
    Default = "None",
    Multi = false,
    Callback = function(val)
        AutoGiftRarity = (type(val) == "table" and val[1]) or val
    end
})

-- Toggle: Auto Gift
TradeSection:AddToggle({
    Title = "Auto Gift",
    Content = "Automatically sends eggs to the target player by rarity",
    Default = false,
    Callback = function(val)
        AutoGiftEnabled = val
    end
})

-- Loop Auto Gift
task.spawn(function()
    while task.wait(0.3) do
        if AutoGiftEnabled
            and AutoGiftTarget and AutoGiftTarget ~= ""
            and ((AutoGiftRarity and AutoGiftRarity ~= "None") or AutoGiftItemName ~= "")
        then
            local targetPlayer = game:GetService("Players"):FindFirstChild(AutoGiftTarget)
            if targetPlayer then
                local toolToGift = nil

                local function isValidTool(tool)
                    if not tool:IsA("Tool") then return false end
                    
                    local matchName = true
                    if AutoGiftItemName ~= "" then
                        local realName = GetItemName(tool)
                        local safeRealName = string.gsub(string.lower(realName), "[^%w]", "")
                        local safeTargetName = string.gsub(string.lower(AutoGiftItemName), "[^%w]", "")
                        matchName = string.match(safeRealName, safeTargetName) ~= nil
                    end
                    
                    local matchRarity = true
                    if AutoGiftRarity and AutoGiftRarity ~= "None" and AutoGiftRarity ~= "All" then
                        matchRarity = (GetItemRarity(tool) == AutoGiftRarity)
                    end
                    
                    return matchName and matchRarity
                end

                local function findValidTool()
                    if LocalPlayer:FindFirstChild("Backpack") then
                        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                            if isValidTool(tool) then return tool end
                        end
                    end
                    if LocalPlayer.Character then
                        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                            if isValidTool(tool) then return tool end
                        end
                    end
                    return nil
                end

                toolToGift = findValidTool()

                if toolToGift then
                    -- Equip item ke character
                    pcall(function()
                        if toolToGift.Parent ~= LocalPlayer.Character then
                            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid:EquipTool(toolToGift)
                            else
                                toolToGift.Parent = LocalPlayer.Character
                            end
                            task.wait(0.3)
                        end
                    end)

                    -- Fire remote
                    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Network")
                        and game:GetService("ReplicatedStorage").Network:FindFirstChild("Gifting: Send Request")
                    if remote and remote:IsA("RemoteFunction") then
                        pcall(function() remote:InvokeServer(targetPlayer.UserId) end)

                        -- Tunggu sampai item hilang dari inventory (max 15 detik)
                        local waited = 0
                        while waited < 15 do
                            task.wait(0.5)
                            waited = waited + 0.5
                            -- Cek apakah item masih ada
                            local stillHere = false
                            if toolToGift and toolToGift.Parent then
                                stillHere = true
                            end
                            if not stillHere then
                                break
                            end
                            -- Kalau udah lama dan item masih ada, coba fire ulang
                            if waited >= 5 and waited % 5 < 0.6 then
                                pcall(function() remote:InvokeServer(targetPlayer.UserId) end)
                            end
                        end
                    end
                end
            else
            end
        end
    end
end)

-- Toggle: Auto Accept Gift
TradeSection:AddToggle({
    Title = "Auto Accept Gift",
    Content = "Automatically accepts all incoming gifts",
    Default = false,
    Callback = function(val)
        AutoAcceptGift = val
    end
})

-- Listener Auto Accept Gift
task.spawn(function()
    pcall(function()
        local networkFolder = game:GetService("ReplicatedStorage"):WaitForChild("Network", 10)
        if not networkFolder then return end
        
        local giftRequestEvent = networkFolder:WaitForChild("Gifting: Request", 10)
        if not giftRequestEvent then return end

        giftRequestEvent.OnClientEvent:Connect(function(senderName, senderId, message, uuid)
            if AutoAcceptGift then
                task.spawn(function()
                    pcall(function()
                        local responseRemote = networkFolder:FindFirstChild("Gifting: Response")
                        if responseRemote and responseRemote:IsA("RemoteFunction") then
                            responseRemote:InvokeServer(senderId, uuid, true)
                        end
                    end)
                end)
            end
        end)
    end)
end)

-- ============================================================
-- WEBHOOK TAB
-- ============================================================
local WebhookTab = Tabs:AddTab({ Name = "Webhook", Icon = "rbxassetid://10734950309" })
local WebhookSection = WebhookTab:AddSection("Webhook")

WebhookSection:AddToggle({
    Title = "Webhook Logs",
    Content = "Sends a log to your Discord webhook each time an egg is claimed",
    Default = false,
    Callback = function(val)
        Config.WebhookEnabled = val
    end
})

WebhookSection:AddInput({
    Title = "Webhook URL",
    Content = "Paste your Discord webhook URL here",
    Default = "",
    Callback = function(val)
        Config.WebhookURL = tostring(val or "")
    end
})

-- HttpService:PostAsync itu native Roblox API, tapi Roblox BLOKIR itu dari LocalScript
-- ("Http requests can only be executed by game server") -- beda sama game:HttpGet yang
-- kepake buat load UI, itu fungsi override khusus bikinan executor. Buat POST kita butuh
-- fungsi request/http_request/syn.request bawaan executor yang bypass batasan itu.
local function httpPostJson(url, jsonBody)
    local requestFn = (syn and syn.request) or request or http_request or (http and http.request) or (fluxus and fluxus.request)
    if requestFn then
        local response = requestFn({
            Url = url,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = jsonBody
        })
        local statusCode = response and (response.StatusCode or response.status_code)
        if statusCode and (statusCode < 200 or statusCode >= 300) then
            warn("[Webhook] Discord balas status", statusCode, "-", response and (response.Body or response.body))
        end
        return
    end

    -- Fallback terakhir kalau executor gak punya request/http_request sama sekali
    game:GetService("HttpService"):PostAsync(url, jsonBody, Enum.HttpContentType.ApplicationJson)
end

-- GET biasa lewat request/http_request juga -- ternyata game:HttpGet di executor ini
-- nolak domain thumbnails.roblox.com (kena "not a valid member of DataModel"), padahal
-- API-nya sendiri kalau dicoba langsung 100% jalan & balikin data valid.
local function httpGetText(url)
    local requestFn = (syn and syn.request) or request or http_request or (http and http.request) or (fluxus and fluxus.request)
    if requestFn then
        local response = requestFn({ Url = url, Method = "GET" })
        return response and (response.Body or response.body)
    end
    return game:HttpGet(url)
end

-- AreaEggClaimFeedback gak bawa UID atau AssetScale sama sekali, jadi Kg-nya gak bisa
-- diambil langsung dari payload. Trik-nya: simpen UID egg yang UDAH kita punya, terus pas
-- claim feedback masuk, bandingin sama inventory sekarang -- UID yang BELUM ada di daftar
-- lama tapi AssetCategory-nya cocok = egg yang baru aja diklaim. Dari situ baru kita hitung
-- berat aslinya lewat EggItemUtil.GetWeightKg (fungsi resmi game, formula berdasarkan AssetScale).
local knownEggUids = {}
pcall(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds)
    local myEggs = EggCmds.GetOwnerRuntimeRecords(LocalPlayer.UserId)
    if type(myEggs) == "table" then
        for uid in pairs(myEggs) do knownEggUids[uid] = true end
    end
end)

local function getClaimedEggWeightKg(feedback)
    local ok, result = pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds)
        local EggItemUtil = require(ReplicatedStorage.Library.Util.EggItemUtil)

        for attempt = 1, 10 do
            local myEggs = EggCmds.GetOwnerRuntimeRecords(LocalPlayer.UserId)
            if type(myEggs) == "table" then
                for uid, record in pairs(myEggs) do
                    if not knownEggUids[uid] and record.AssetCategory == feedback.AssetCategory then
                        for uid2 in pairs(myEggs) do knownEggUids[uid2] = true end
                        return EggItemUtil.GetWeightKg(record)
                    end
                end
            end
            task.wait(0.15) -- Inventory kadang telat beberapa frame buat update
        end

        return nil
    end)
    if ok then return result end
    return nil
end

-- Avatar player buat dipasang di "author" embed (biar username-nya nongol jelas di paling
-- atas card, bukan kecil-kecil di footer). Di-cache karena avatar-nya sama terus tiap claim.
local cachedAvatarUrl = nil
local function getLocalPlayerAvatarUrl()
    if cachedAvatarUrl then return cachedAvatarUrl end
    local ok, result = pcall(function()
        local HttpService = game:GetService("HttpService")
        local resp = httpGetText("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. LocalPlayer.UserId .. "&size=150x150&format=Png&isCircular=false")
        local decoded = HttpService:JSONDecode(resp)
        local entry = decoded and decoded.data and decoded.data[1]
        if entry and entry.state == "Completed" and entry.imageUrl then
            return entry.imageUrl
        end
        return nil
    end)
    if ok and result then
        cachedAvatarUrl = result
    end
    return cachedAvatarUrl
end

-- Kirim satu embed Discord tiap kali server ngasih feedback "berhasil claim egg" ke kita.
-- Payload event-nya persis kayak yang ditemukan lewat Cobalt:
-- Rarity, Position (Vector3), Color (Color3), AssetCategory (nama pet di dalam egg), DisplayName.
local function sendEggClaimWebhook(feedback)
    if not Config.WebhookEnabled then return end
    if type(Config.WebhookURL) ~= "string" or Config.WebhookURL == "" then return end
    if type(feedback) ~= "table" then return end

    task.spawn(function()
        local ok, err = pcall(function()
            local HttpService = game:GetService("HttpService")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Assets = require(ReplicatedStorage.Directory.Assets)

            local rarity = feedback.Rarity or "Unknown"
            local assetCategory = feedback.AssetCategory
            local displayName = feedback.DisplayName or (tostring(assetCategory or "Egg") .. " Egg")

            -- Icon egg-nya ada di Assets.Directory[AssetCategory].Egg.Icon (rbxassetid://...)
            local iconId = nil
            local assetOk, assetData = pcall(function()
                return assetCategory and Assets.Directory[assetCategory]
            end)
            if assetOk and assetData and assetData.Egg and assetData.Egg.Icon then
                iconId = tostring(assetData.Egg.Icon):gsub("rbxassetid://", "")
            end

            -- Resolve assetId -> URL CDN asli (rbxcdn.com) lewat Thumbnails API resmi Roblox.
            -- Endpoint lama (roblox.com/asset-thumbnail/image) sudah dimatiin Roblox (404),
            -- jadi jangan dipakai lagi sebagai fallback.
            local thumbnailUrl = nil
            if iconId then
                local thumbOk, thumbResult = pcall(function()
                    local resp = httpGetText("https://thumbnails.roblox.com/v1/assets?assetIds=" .. iconId .. "&size=420x420&format=Png&isCircular=false")
                    local decoded = HttpService:JSONDecode(resp)
                    local entry = decoded and decoded.data and decoded.data[1]
                    if entry and entry.state == "Completed" and entry.imageUrl then
                        return entry.imageUrl
                    end
                    return nil
                end)
                if thumbOk and thumbResult then
                    thumbnailUrl = thumbResult
                end
            end

            local colorDecimal = 0
            if typeof(feedback.Color) == "Color3" then
                local c = feedback.Color
                colorDecimal = math.floor(c.R * 255) * 65536 + math.floor(c.G * 255) * 256 + math.floor(c.B * 255)
            end

            local weightKg = getClaimedEggWeightKg(feedback)
            local weightText = "Unknown"
            if type(weightKg) == "number" then
                weightText = string.format("%s Kg", tostring(math.floor(weightKg * 100 + 0.5) / 100))
            end

            local embed = {
                author = { name = LocalPlayer.Name, icon_url = getLocalPlayerAvatarUrl() },
                description = "### " .. tostring(displayName),
                color = colorDecimal,
                fields = {
                    { name = "Rarity", value = tostring(rarity), inline = true },
                    { name = "Pet Species", value = tostring(assetCategory or "Unknown"), inline = true },
                    { name = "Weight", value = weightText, inline = true }
                },
                footer = { text = "Napoleon - Steal An Egg" },
                timestamp = DateTime.now():ToIsoDate()
            }
            if thumbnailUrl then
                embed.thumbnail = { url = thumbnailUrl }
            end

            local payload = {
                username = "Napoleon - Steal An Egg",
                embeds = { embed }
            }

            httpPostJson(Config.WebhookURL, HttpService:JSONEncode(payload))
        end)
        if not ok then
            warn("[Webhook] Gagal kirim webhook:", err)
        end
    end)
end

pcall(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds)
    EggCmds.AreaEggClaimed:Connect(function(feedback)
        sendEggClaimWebhook(feedback)
    end)
end)

-- ============================================================
-- MISC TAB & ANTI AFK
-- ============================================================
local MiscTab = Tabs:AddTab({ Name = "Misc", Icon = "rbxassetid://10734950309" })
local PerformanceSection = MiscTab:AddSection("Performance")

PerformanceSection:AddButton({
    Title = "Boost FPS",
    Content = "Flattens graphics to full gray, deletes other players' plots/treadmills, hides ALL pets (yours too), keeps eggs visible",
    Callback = function()
        ApplyFPSBoost()
    end
})

local MiscSection = MiscTab:AddSection("Player Settings")

MiscSection:AddToggle({
    Title = "Anti AFK",
    Content = "Prevents you from getting kicked for being idle (20 mins)",
    Default = true,
    Callback = function(val)
        Config.AntiAFK = val
    end
})

MiscSection:AddToggle({
    Title = "Anti Treadmill Mount",
    Content = "Auto-unmounts if you accidentally get on your treadmill. Turn off to use it yourself.",
    Default = true,
    Callback = function(val)
        Config.AntiTreadmillMount = val
    end
})

MiscSection:AddToggle({
    Title = "Anti Guard Knockback",
    Content = "Prevents getting flung or dropping your egg when a Guard hits you.",
    Default = true,
    Callback = function(val)
        Config.AntiGuardKnockback = val
        local char = LocalPlayer.Character
        setGuardNoCollide(char, val)
        setGuardRagdollImmune(char and char:FindFirstChildOfClass("Humanoid"), val)
    end
})

-- ============================================================
-- EGG PANEL (Egg Logs + Egg Predict) -- panel list bergambar, gaya WisHUB yang
-- direferensiin user. Egg Logs = live snapshot wild-area egg SEKARANG (pet apa,
-- egg apa, berat, mutasi, area) langsung dari EggCmds.GetAreaEggSnapshot(); semua
-- field-nya (Egg.Icon/DisplayName/WeightKg) dikonfirmasi ADA & required di source
-- asli (Directory/Assets/Types/Schema.lua), bukan ngarang.
--
-- Egg Predict tetap pakai formula seed yang sama kayak sebelumnya (AreaEggResetTimeUtil.
-- GetSlotSeed) -- CATATAN PENTING (jangan dihapus): fungsi seed-nya ADA dan bahan-
-- bahannya (DropTable, LotteryCustom) COCOK, tapi GetSlotSeed gak kepanggil di manapun
-- di client dump -- gak ada bukti LANGSUNG server beneran makenya persis gini. Anggap
-- "kemungkinan besar akurat", bukan pasti -- validasi sendiri ke egg beneran kalau
-- mau yakin 100%.
local function simulateSlotEgg(periodIndex, areaName, slotName, areasDir, assetsDir, lotteryFn, resetTimeUtil)
    local areaConfig = areasDir[areaName]
    if not areaConfig or not areaConfig.DropTable then return nil end

    local seed = resetTimeUtil.GetSlotSeed(periodIndex, areaName, slotName)
    local rng = Random.new(seed)
    local petName = lotteryFn(rng, areaConfig.DropTable)
    if not petName then return nil end

    local assetData = assetsDir[petName]
    local rarityObj = assetData and assetData.Rarity
    local rarityName = (rarityObj and rarityObj.DisplayName) or "Common"
    local rarityNumber = (rarityObj and rarityObj.RarityNumber) or 1

    return {
        petName = petName,
        area = areaName,
        slot = slotName,
        rarity = rarityName,
        rarityNumber = rarityNumber
    }
end

local function formatPredictDuration(totalSeconds)
    totalSeconds = math.max(0, math.floor(totalSeconds))
    local days = math.floor(totalSeconds / 86400)
    local hours = math.floor((totalSeconds % 86400) / 3600)
    local mins = math.floor((totalSeconds % 3600) / 60)
    if days > 0 then
        return string.format("%dd %dh %dm", days, hours, mins)
    elseif hours > 0 then
        return string.format("%dh %dm", hours, mins)
    else
        return string.format("%dm %02ds", mins, totalSeconds % 60)
    end
end

local EggPanelReplicatedStorage = game:GetService("ReplicatedStorage")
local EggPanelAssets = require(EggPanelReplicatedStorage.Directory.Assets).Directory
local EggPanelAreas = require(EggPanelReplicatedStorage.Directory.Areas).Directory
local EggPanelResetTimeUtil = require(EggPanelReplicatedStorage.Library.Util.AreaEggResetTimeUtil)
local EggPanelLotteryCustom = require(EggPanelReplicatedStorage.Library.Functions.LotteryCustom)
local EggPanelEggCmds = require(EggPanelReplicatedStorage.Library.Client.EggCmds)

local PREDICT_AREAS = {
    "Forest", "Lake", "Desert", "Jungle", "Snow", "Volcano", "Abyss Ocean", "Prehistoric", "Cosmic"
}
-- Jumlah slot per area ini ASUMSI (5), gak ada di script manapun -- jumlah nest
-- ASLI ditentuin dari model fisik di Workspace tiap area, gak bisa diverifikasi
-- dari script dump doang. Kalau ada area yang nest-nya != 5, slot itu ke-skip.
local PREDICT_SLOTS = { "Slot_001", "Slot_002", "Slot_003", "Slot_004", "Slot_005" }
local MAX_PREDICT_PERIODS_AHEAD = 2016 -- 2016 x 300 detik = 7 hari ke depan

local function eggPanelSimulateSlot(periodIndex, areaName, slotName)
    return simulateSlotEgg(periodIndex, areaName, slotName, EggPanelAreas, EggPanelAssets, EggPanelLotteryCustom, EggPanelResetTimeUtil)
end

-- Katalog rarity yang KEPAKE beneran sama pet di game ini (bukan hardcode semua
-- modul Rarity yang ada -- sebagian kayak "Squishy God"/BrainrotGod itu modul
-- rarity punya game LAIN yang numpang ke-share code, gak dipake pet manapun di sini).
local function buildRarityCatalog()
    local seen = {}
    local list = {}
    for _, assetData in pairs(EggPanelAssets) do
        local r = assetData.Rarity
        if r and r.DisplayName and not seen[r.DisplayName] then
            seen[r.DisplayName] = true
            table.insert(list, { name = r.DisplayName, color = r.Color or Color3.fromRGB(255, 255, 255), order = r.RarityNumber or 0 })
        end
    end
    table.sort(list, function(a, b) return a.order > b.order end)
    return list
end
local RarityCatalog = buildRarityCatalog()
local RarityColorByName = { Any = Color3.fromRGB(255, 255, 255) }
for _, r in ipairs(RarityCatalog) do RarityColorByName[r.name] = r.color end

local MUTATION_COLORS = {
    Rainbow = Color3.fromRGB(255, 60, 255),
    Golden = Color3.fromRGB(255, 234, 0),
    Silver = Color3.fromRGB(220, 220, 220),
}

local function getEggLogEntries()
    local entries = {}
    local snapshot = EggPanelEggCmds.GetAreaEggSnapshot()
    if snapshot and snapshot.Records then
        for _, record in pairs(snapshot.Records) do
            if record.State == "Slot" or record.State == "Dropped" then
                local assetData = EggPanelAssets[record.AssetCategory]
                if assetData and assetData.Egg then
                    local areaData = EggPanelAreas[record.AreaId]
                    local mutationText = nil
                    if record.Mutations and #record.Mutations > 0 then
                        mutationText = table.concat(record.Mutations, " + ")
                    end
                    table.insert(entries, {
                        uid = record.Uid,
                        petName = assetData.DisplayName,
                        eggName = assetData.Egg.DisplayName,
                        eggIcon = assetData.Egg.Icon,
                        weightKg = assetData.Egg.WeightKg,
                        rarityName = (assetData.Rarity and assetData.Rarity.DisplayName) or "Common",
                        rarityOrder = (assetData.Rarity and assetData.Rarity.RarityNumber) or 0,
                        mutationText = mutationText,
                        mutationColor = MUTATION_COLORS[record.BaseMutation] or Color3.fromRGB(255, 255, 255),
                        area = (areaData and areaData.DisplayName) or record.AreaId,
                    })
                end
            end
        end
    end
    table.sort(entries, function(a, b)
        if a.rarityOrder ~= b.rarityOrder then
            return a.rarityOrder > b.rarityOrder -- rarity paling bagus di paling atas
        end
        return a.petName < b.petName
    end)
    return entries
end

-- Scan maju period demi period, kumpulin SEMUA kemunculan yang cocok filter
-- (rarity + search nama pet) sampai maxResults atau maxPeriodsAhead kelewat.
-- Di-yield tiap 50 period biar gak nge-freeze game pas scan jauh.
local function findUpcomingRarityAppearances(rarityFilter, searchText, startPeriod, maxResults, maxPeriodsAhead)
    local results = {}
    local searchLower = string.lower(searchText or "")
    for i = 1, maxPeriodsAhead do
        if i % 50 == 0 then task.wait() end
        local period = startPeriod + i
        for _, areaName in ipairs(PREDICT_AREAS) do
            for _, slotName in ipairs(PREDICT_SLOTS) do
                local egg = eggPanelSimulateSlot(period, areaName, slotName)
                if egg then
                    local rarityOk = (rarityFilter == "Any") or (egg.rarity == rarityFilter)
                    local searchOk = (searchLower == "") or string.find(string.lower(egg.petName), searchLower, 1, true)
                    if rarityOk and searchOk then
                        table.insert(results, {
                            petName = egg.petName,
                            area = egg.area,
                            slot = egg.slot,
                            rarity = egg.rarity,
                            releaseAt = EggPanelResetTimeUtil.GetPeriodStartsAt(period),
                        })
                        if #results >= maxResults then return results end
                    end
                end
            end
        end
    end
    return results
end

-- ===== UI: WINDOW =====

local EggPanelUI = nil
local EggPanelState = {
    ActiveTab = "Logs", -- "Logs" | "Predict"
    SearchText = "",
    SelectedRarity = "Any",
}
local cachedLogsRaw = nil
local cachedPredictRaw = nil
local cachedPredictKey = nil
-- Ditandain "dirty" doang (murah) tiap ada AreaEggUpdated/Removed -- BUKAN langsung
-- render ulang (destroy+recreate ~puluhan card = mahal banget). Event ini bisa nembak
-- berkali-kali per detik di server rame, jadi kalau langsung render tiap event nembak
-- itu yang bikin FPS anjlok parah. Render beneran cuma kejadian di tick loop 2 detik.
local eggLogsDirty = true

local function makeEggPanelWindow()
    local accentColor = Color3.fromRGB(150, 150, 150) -- samain sama warna UI utama Napoleon

    local gui = Instance.new("ScreenGui")
    gui.Name = "NapoleonEggPanelUI"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
    -- CoreGui ditolak nulis property di executor/versi Roblox ini ("lacking capability
    -- Plugin") walau proses parenting-nya sendiri gak langsung error. PlayerGui udah
    -- kebukti jalan normal di UI utama script ini, jadi langsung situ aja.
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    -- Scale-based + UISizeConstraint (bukan angka pixel mati) biar aman di layar kecil
    -- (HP) -- ke-clamp antara 300-380 lebar & 420-480 tinggi, dan Position center-anchor
    -- (bukan "dock ke kanan" kayak sebelumnya) biar gak kepotong di layar sempit.
    frame.Size = UDim2.new(0.72, 0, 0.62, 0)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.ClipsDescendants = true
    frame.Parent = gui

    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.MinSize = Vector2.new(260, 340)
    sizeConstraint.MaxSize = Vector2.new(320, 400)
    sizeConstraint.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 26)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 16))
    })
    gradient.Rotation = 90
    gradient.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = accentColor
    stroke.Thickness = 2.5
    stroke.Transparency = 0.1
    stroke.Parent = frame

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

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 36)
    topBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    topBar.BorderSizePixel = 0
    topBar.Parent = frame
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 10)
    topCorner.Parent = topBar
    local hideBottomCorner = Instance.new("Frame")
    hideBottomCorner.Size = UDim2.new(1, 0, 0, 10)
    hideBottomCorner.Position = UDim2.new(0, 0, 1, -10)
    hideBottomCorner.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    hideBottomCorner.BorderSizePixel = 0
    hideBottomCorner.Parent = topBar

    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 20, 0, 20)
    logo.Position = UDim2.new(0, 10, 0.5, -10)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://136289055140268"
    logo.Parent = topBar

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -66, 1, 0)
    title.Position = UDim2.new(0, 36, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "NAPOLEON | EGG PANEL"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -30, 0.5, -12)
    closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 13
    closeBtn.Parent = topBar
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 6)
    closeBtnCorner.Parent = closeBtn
    closeBtn.MouseButton1Click:Connect(function()
        gui.Enabled = false
    end)

    local tabRow = Instance.new("Frame")
    tabRow.Size = UDim2.new(1, -16, 0, 30)
    tabRow.Position = UDim2.new(0, 8, 0, 42)
    tabRow.BackgroundTransparency = 1
    tabRow.Parent = frame
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.Parent = tabRow

    local function makeTabButton(text)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 110, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.Parent = tabRow
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 6)
        c.Parent = btn
        return btn
    end
    local logsTabBtn = makeTabButton("Egg Logs")
    local predictTabBtn = makeTabButton("Egg Predict")

    local resetLabel = Instance.new("TextLabel")
    resetLabel.Size = UDim2.new(1, -16, 0, 18)
    resetLabel.Position = UDim2.new(0, 8, 0, 76)
    resetLabel.BackgroundTransparency = 1
    resetLabel.TextXAlignment = Enum.TextXAlignment.Left
    resetLabel.Font = Enum.Font.GothamMedium
    resetLabel.TextSize = 11
    resetLabel.TextColor3 = Color3.fromRGB(160, 148, 255)
    resetLabel.Text = "Next Reset: --"
    resetLabel.Parent = frame

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -72, 0, 26)
    searchBox.Position = UDim2.new(0, 8, 0, 98)
    searchBox.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.Text = ""
    searchBox.PlaceholderText = "Cari nama pet/egg..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 12
    searchBox.ClearTextOnFocus = false
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.Parent = frame
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 6)
    searchCorner.Parent = searchBox
    local searchPad = Instance.new("UIPadding")
    searchPad.PaddingLeft = UDim.new(0, 8)
    searchPad.Parent = searchBox

    local clearBtn = Instance.new("TextButton")
    clearBtn.Size = UDim2.new(0, 58, 0, 26)
    clearBtn.Position = UDim2.new(1, -62, 0, 98)
    clearBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    clearBtn.Text = "Clear"
    clearBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    clearBtn.Font = Enum.Font.GothamMedium
    clearBtn.TextSize = 11
    clearBtn.Parent = frame
    local clearCorner = Instance.new("UICorner")
    clearCorner.CornerRadius = UDim.new(0, 6)
    clearCorner.Parent = clearBtn
    clearBtn.MouseButton1Click:Connect(function()
        searchBox.Text = ""
    end)

    local chipScroll = Instance.new("ScrollingFrame")
    -- Tinggi dilebihin dari tinggi chip asli (24) biar scrollbar-nya (di bawah) gak
    -- nempel banget sama chip -- chip di-center vertikal, sisa ruang jadi jarak napas.
    chipScroll.Size = UDim2.new(1, -16, 0, 34)
    chipScroll.Position = UDim2.new(0, 8, 0, 130)
    chipScroll.BackgroundTransparency = 1
    chipScroll.BorderSizePixel = 0
    chipScroll.ScrollBarThickness = 0 -- gak usah keliatan, tapi drag/swipe scroll tetep jalan
    chipScroll.ScrollingDirection = Enum.ScrollingDirection.X
    chipScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    chipScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    chipScroll.Parent = frame
    local chipLayout = Instance.new("UIListLayout")
    chipLayout.FillDirection = Enum.FillDirection.Horizontal
    chipLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    chipLayout.Padding = UDim.new(0, 8)
    chipLayout.Parent = chipScroll

    local listScroll = Instance.new("ScrollingFrame")
    listScroll.Size = UDim2.new(1, -16, 1, -180)
    listScroll.Position = UDim2.new(0, 8, 0, 172)
    listScroll.BackgroundTransparency = 1
    listScroll.BorderSizePixel = 0
    listScroll.ScrollBarThickness = 4
    listScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listScroll.Parent = frame
    local listPad = Instance.new("UIPadding")
    listPad.PaddingTop = UDim.new(0, 2)
    listPad.Parent = listScroll
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 6)
    listLayout.Parent = listScroll

    -- countLabel ini ikut diatur listLayout juga (jadi item pertama, LayoutOrder
    -- default 0 < card yang mulai dari 1) -- Position manual di atas gak ngefek,
    -- posisinya beneran ditentuin urutan flow-nya.
    local countLabel = Instance.new("TextLabel")
    countLabel.Size = UDim2.new(1, 0, 0, 14)
    countLabel.LayoutOrder = -1
    countLabel.BackgroundTransparency = 1
    countLabel.TextXAlignment = Enum.TextXAlignment.Left
    countLabel.Font = Enum.Font.GothamMedium
    countLabel.TextSize = 10
    countLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    countLabel.Text = ""
    countLabel.Parent = listScroll

    return {
        Gui = gui,
        Frame = frame,
        LogsTabBtn = logsTabBtn,
        PredictTabBtn = predictTabBtn,
        ResetLabel = resetLabel,
        SearchBox = searchBox,
        ChipScroll = chipScroll,
        ListScroll = listScroll,
        CountLabel = countLabel,
        AccentColor = accentColor,
    }
end

-- ===== UI: LIST CARD =====

local function createEggCard(layoutOrder, data)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 56)
    card.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    card.LayoutOrder = layoutOrder
    card.Parent = EggPanelUI.ListScroll
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = card

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromRGB(255, 255, 255)
    cardStroke.Thickness = 1
    cardStroke.Transparency = 0.88
    cardStroke.Parent = card

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 4, 1, -12)
    bar.Position = UDim2.new(0, 0, 0, 6)
    bar.BackgroundColor3 = data.rarityColor or Color3.fromRGB(255, 255, 255)
    bar.BorderSizePixel = 0
    bar.Parent = card
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = bar

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 40, 0, 40)
    icon.Position = UDim2.new(0, 12, 0.5, -20)
    icon.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    icon.Image = data.icon or ""
    icon.Parent = card
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 6)
    iconCorner.Parent = icon

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -170, 0, 15)
    titleLbl.Position = UDim2.new(0, 60, 0, 4)
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    titleLbl.Text = data.title or ""
    titleLbl.Parent = card

    local subtitleLbl = Instance.new("TextLabel")
    subtitleLbl.Size = UDim2.new(1, -170, 0, 13)
    subtitleLbl.Position = UDim2.new(0, 60, 0, 19)
    subtitleLbl.BackgroundTransparency = 1
    subtitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLbl.Font = Enum.Font.Gotham
    subtitleLbl.TextSize = 10
    subtitleLbl.TextColor3 = Color3.fromRGB(170, 170, 180)
    subtitleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    subtitleLbl.Text = data.subtitle or ""
    subtitleLbl.Parent = card

    local metaLbl = Instance.new("TextLabel")
    metaLbl.Size = UDim2.new(1, -170, 0, 13)
    metaLbl.Position = UDim2.new(0, 60, 0, 33)
    metaLbl.BackgroundTransparency = 1
    metaLbl.TextXAlignment = Enum.TextXAlignment.Left
    metaLbl.Font = Enum.Font.Gotham
    metaLbl.TextSize = 10
    metaLbl.TextColor3 = data.metaColor or Color3.fromRGB(170, 170, 180)
    metaLbl.TextTruncate = Enum.TextTruncate.AtEnd
    metaLbl.Text = data.meta or ""
    metaLbl.Parent = card

    local rightTop = Instance.new("TextLabel")
    rightTop.Size = UDim2.new(0, 100, 0, 16)
    rightTop.Position = UDim2.new(1, -108, 0, 8)
    rightTop.BackgroundTransparency = 1
    rightTop.TextXAlignment = Enum.TextXAlignment.Right
    rightTop.Font = Enum.Font.GothamBold
    rightTop.TextSize = 12
    rightTop.TextColor3 = data.rightTopColor or Color3.fromRGB(0, 255, 150)
    rightTop.Text = data.rightTop or ""
    rightTop.Parent = card

    local rightBottom = Instance.new("TextLabel")
    rightBottom.Size = UDim2.new(0, 100, 0, 14)
    rightBottom.Position = UDim2.new(1, -108, 0, 26)
    rightBottom.BackgroundTransparency = 1
    rightBottom.TextXAlignment = Enum.TextXAlignment.Right
    rightBottom.Font = Enum.Font.Gotham
    rightBottom.TextSize = 10
    rightBottom.TextColor3 = Color3.fromRGB(130, 130, 140)
    rightBottom.Text = data.rightBottom or ""
    rightBottom.Parent = card

    return card
end

local function clearEggPanelList()
    for _, c in ipairs(EggPanelUI.ListScroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
end

local function passesSearch(name)
    if EggPanelState.SearchText == "" then return true end
    return string.find(string.lower(name), string.lower(EggPanelState.SearchText), 1, true) ~= nil
end

local function renderEggLogs()
    if not EggPanelUI then return end
    clearEggPanelList()
    local entries = cachedLogsRaw or {}
    local shown = 0
    for _, e in ipairs(entries) do
        local rarityOk = (EggPanelState.SelectedRarity == "Any") or (e.rarityName == EggPanelState.SelectedRarity)
        local searchOk = passesSearch(e.petName) or passesSearch(e.eggName)
        if rarityOk and searchOk then
            shown = shown + 1
            local rarityColor = RarityColorByName[e.rarityName] or Color3.fromRGB(255, 255, 255)
            local mutText = e.mutationText and ("Mutasi: " .. e.mutationText) or "No Mutation"
            createEggCard(shown, {
                icon = e.eggIcon,
                title = e.eggName,
                subtitle = e.petName,
                rarityColor = rarityColor,
                meta = e.rarityName .. " \226\128\162 " .. mutText,
                metaColor = rarityColor,
                rightTop = e.area,
                rightTopColor = Color3.fromRGB(160, 148, 255),
                rightBottom = string.format("%s kg", tostring(e.weightKg or 0)),
            })
        end
    end
    EggPanelUI.CountLabel.Text = shown .. " egg(s) di area sekarang"
end

local function renderEggPredict(now)
    if not EggPanelUI then return end
    clearEggPanelList()
    local hits = cachedPredictRaw or {}
    for i, hit in ipairs(hits) do
        local assetData = EggPanelAssets[hit.petName]
        local eggIcon = (assetData and assetData.Egg and assetData.Egg.Icon) or ""
        local rarityColor = RarityColorByName[hit.rarity] or Color3.fromRGB(255, 255, 255)
        local eta = math.max(0, hit.releaseAt - now)
        local eggName = (assetData and assetData.Egg and assetData.Egg.DisplayName) or (hit.petName .. " Egg")
        createEggCard(i, {
            icon = eggIcon,
            title = eggName,
            subtitle = hit.petName,
            rarityColor = rarityColor,
            meta = hit.rarity .. " \226\128\162 " .. hit.area,
            metaColor = rarityColor,
            rightTop = "in " .. formatPredictDuration(eta),
            rightTopColor = Color3.fromRGB(0, 255, 150),
            rightBottom = os.date("!%H:%M:%S UTC", math.floor(hit.releaseAt)),
        })
    end
    if #hits == 0 then
        EggPanelUI.CountLabel.Text = "0 hit(s) dalam 7 hari ke depan"
    else
        EggPanelUI.CountLabel.Text = #hits .. " hit(s), soonest in " .. formatPredictDuration(math.max(0, hits[1].releaseAt - now))
    end
end

local function refreshEggPanelActiveTab(forceRescan)
    if not EggPanelUI then return end
    if EggPanelState.ActiveTab == "Logs" then
        cachedLogsRaw = getEggLogEntries()
        renderEggLogs()
    else
        local key = EggPanelState.SelectedRarity .. "|" .. EggPanelState.SearchText
        if forceRescan or key ~= cachedPredictKey then
            cachedPredictKey = key
            local now = game:GetService("Workspace"):GetServerTimeNow()
            local currentPeriod = EggPanelResetTimeUtil.GetPeriodIndex(now)
            cachedPredictRaw = findUpcomingRarityAppearances(EggPanelState.SelectedRarity, EggPanelState.SearchText, currentPeriod, 30, MAX_PREDICT_PERIODS_AHEAD)
        end
        renderEggPredict(game:GetService("Workspace"):GetServerTimeNow())
    end
end

local function styleEggPanelTabButtons()
    if not EggPanelUI then return end
    local accent = EggPanelUI.AccentColor
    local function style(btn, active)
        btn.BackgroundColor3 = active and accent or Color3.fromRGB(25, 25, 32)
        btn.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    end
    style(EggPanelUI.LogsTabBtn, EggPanelState.ActiveTab == "Logs")
    style(EggPanelUI.PredictTabBtn, EggPanelState.ActiveTab == "Predict")
end

local function styleEggPanelChips()
    if not EggPanelUI then return end
    for _, chip in ipairs(EggPanelUI.ChipScroll:GetChildren()) do
        if chip:IsA("TextButton") then
            local isSel = chip.Text == EggPanelState.SelectedRarity
            if isSel then
                chip.BackgroundColor3 = RarityColorByName[chip.Text] or EggPanelUI.AccentColor
                chip.TextColor3 = Color3.fromRGB(10, 10, 15)
            else
                chip.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
                chip.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
    end
end

local function buildEggPanelRarityChips()
    for _, c in ipairs(EggPanelUI.ChipScroll:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end

    local function makeChip(name)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, math.max(50, #name * 7 + 24), 0, 24)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.Parent = EggPanelUI.ChipScroll
        local c2 = Instance.new("UICorner")
        c2.CornerRadius = UDim.new(1, 0)
        c2.Parent = btn
        local c2Stroke = Instance.new("UIStroke")
        c2Stroke.Color = Color3.fromRGB(255, 255, 255)
        c2Stroke.Transparency = 0.85
        c2Stroke.Parent = btn
        btn.MouseButton1Click:Connect(function()
            EggPanelState.SelectedRarity = name
            styleEggPanelChips()
            refreshEggPanelActiveTab(true)
        end)
        return btn
    end

    makeChip("Any")
    for _, r in ipairs(RarityCatalog) do
        makeChip(r.name)
    end
end

local function toggleEggPanelUI(state)
    if state then
        if not EggPanelUI then
            EggPanelUI = makeEggPanelWindow()
            buildEggPanelRarityChips()
            styleEggPanelChips()
            styleEggPanelTabButtons()

            EggPanelUI.LogsTabBtn.MouseButton1Click:Connect(function()
                EggPanelState.ActiveTab = "Logs"
                styleEggPanelTabButtons()
                refreshEggPanelActiveTab(false)
            end)
            EggPanelUI.PredictTabBtn.MouseButton1Click:Connect(function()
                EggPanelState.ActiveTab = "Predict"
                styleEggPanelTabButtons()
                refreshEggPanelActiveTab(true)
            end)
            EggPanelUI.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                EggPanelState.SearchText = EggPanelUI.SearchBox.Text
                refreshEggPanelActiveTab(false)
            end)
        end
        EggPanelUI.Gui.Enabled = true
        pcall(function() EggPanelEggCmds.RequestAreaEggSnapshot() end)
        refreshEggPanelActiveTab(true)
    else
        if EggPanelUI then EggPanelUI.Gui.Enabled = false end
    end
end

EggPanelEggCmds.AreaEggUpdated:Connect(function()
    eggLogsDirty = true
end)
EggPanelEggCmds.AreaEggRemoved:Connect(function()
    eggLogsDirty = true
end)

local eggPanelActive = false
local function startEggPanelLoop()
    if eggPanelActive then return end
    eggPanelActive = true
    task.spawn(function()
        while Config.EggPredictUI do
            -- Dibungkus pcall -- sebelumnya satu error di tengah loop (misal nulis
            -- property ke Instance yang ternyata kena batasan capability) bikin SELURUH
            -- coroutine mati diam-diam, macet permanen tanpa ada tanda apa pun kenapa.
            local tickOk, tickErr = pcall(function()
                local Workspace = game:GetService("Workspace")
                local now = Workspace:GetServerTimeNow()
                local nextResetAt = EggPanelResetTimeUtil.GetNextResetAt(now)
                if EggPanelUI then
                    EggPanelUI.ResetLabel.Text = "Next Reset: " .. formatPredictDuration(math.max(0, nextResetAt - now))
                    if EggPanelState.ActiveTab == "Logs" then
                        if eggLogsDirty then
                            eggLogsDirty = false
                            cachedLogsRaw = getEggLogEntries()
                            renderEggLogs()
                        end
                    else
                        renderEggPredict(now)
                    end
                end
            end)
            if not tickOk then
                warn("[EggPanel] Error di tick loop:", tickErr)
            end
            task.wait(2)
        end
        eggPanelActive = false
        toggleEggPanelUI(false)
    end)
end

local EggPanelSection = MiscTab:AddSection("Egg Panel")

EggPanelSection:AddToggle({
    Title = "Show Egg Panel",
    Content = "List egg yang lagi ada di area (nama, gambar, berat, mutasi, area) + prediksi kapan rarity tertentu muncul lagi.",
    Default = false,
    Callback = function(val)
        Config.EggPredictUI = val
        if val and UI_LOADED then
            toggleEggPanelUI(true)
            startEggPanelLoop()
        elseif not val then
            toggleEggPanelUI(false)
        end
    end
})

-- Anti AFK Logic -- TANPA VirtualUser / VirtualInputManager sama sekali.
-- ==========================================================================
-- KONFIRMASI LANGSUNG dari testing: VirtualUser di game INI ke-detect anti-cheat
-- (nyebabin ke-reconnect/kick) -- ternyata bukan aman kayak dugaan awal (VirtualUser
-- itu emang API resmi Roblox buat AFK-prevention, tapi anti-cheat spesifik game ini
-- kayaknya tetep ngawasin pemanggilan Virtual* apa pun). Makanya SEKARANG DAN
-- SETERUSNYA: jangan pakai VirtualUser atau VirtualInputManager lagi buat Anti AFK.
--
-- ROOT CAUSE DIKONFIRMASI dari source asli game (StarterPlayer/AntiAFK.client.lua):
--     LocalPlayer.Idled:Connect(function(idleSeconds)
--         if idleSeconds > 1080 and not Constants.IS_STUDIO then
--             Network.Invoke(REQUEST_AFK_TELEPORT_FLUSH)
--             TeleportService:Teleport(game.PlaceId, LocalPlayer)  -- INI biang "rejoin-rejoin"-nya
--         end
--     end)
-- `Player.Idled` itu signal NATIVE Roblox, dipicu MURNI dari UserInputService (mouse/
-- keyboard/touch/gamepad asli) -- gak ada hubungannya sama sekali sama gerakan
-- karakter/CFrame/Humanoid:MoveTo(). Ini kenapa lapis "gerakin karakter dikit-dikit"
-- di bawah TERBUKTI gak akan pernah bisa nyegah timer ini jalan, walau dari luar
-- kelihatan masuk akal -- root cause-nya emang beda kategori total.
--
-- LAPIS 0 (BARU, PALING KUAT, root-cause fix): daripada coba matiin koneksi Idled
-- (rapuh -- getconnections/Disable() pada signal NATIVE kayak gini sering gak
-- beneran ngefek di banyak executor, beda sama custom Lua Signal), kita HOOK
-- LANGSUNG fungsi TeleportService.Teleport dan blokir spesifik panggilan yang
-- placeId-nya SAMA dengan PlaceId sekarang + player-nya LocalPlayer (persis pola
-- soft-kick di atas). Apa pun jalur yang micu-nya (Idled, atau kalau ternyata ada
-- mekanisme lain juga manggil TeleportService.Teleport dengan pola sama), teleport-
-- nya dicegat di TITIK PALING AKHIR sebelum benar-benar kejadian -- gak gantung ke
-- apakah kita berhasil nyegah si TRIGGER-nya duluan atau enggak.
--
-- Sisanya tetap dipertahankan sebagai lapis cadangan (jaga-jaga kalau executor gak
-- dukung hookfunction):
--
-- LAPIS 1 (diadaptasi dari SlimeRNG.lua "Method 1"): getconnections/get_signal_cons
-- buat matiin koneksi Idled bawaan game. Sekarang cuma backup -- Lapis 0 udah cukup
-- buat nyegah efek akhirnya (teleport) sekalipun Lapis 1 ini gagal diam-diam.
--
-- LAPIS 2: laporin status "aktif" ke server lewat remote YANG SAMA yang dipanggil
-- game sendiri pas ada input asli (Analytics.REPORT_AFK_STATE) -- remote call biasa,
-- bukan simulasi input.
--
-- LAPIS 3: kalau semua di atas gagal dan beneran ke-teleport, queue_on_teleport
-- (queueSelfForTeleport, resume via napoleonn.net/api/script) mastiin script ini
-- auto-lanjut sendiri di server baru.
-- Semua kejadian di sini dicatat ke Napoleon_AntiAFK_Log.txt (bukan cuma print/warn ke
-- console) -- soalnya kalau ini kejadian PAS lagi AFK/gak di depan layar (ya itu emang
-- inti masalahnya), gak bakal ada yang lihat console live. Cek file log-nya abis balik
-- buat tau PERSIS apa yang kejadian: hook aktif atau enggak, ke-blokir atau lolos.
local function hookAntiAfkTeleport()
    local ok, err = pcall(function()
        if typeof(hookfunction) ~= "function" then
            warn("[AntiAFK] Executor gak punya hookfunction, skip Lapis 0 (masih ada Lapis 1/2/3).")
            logSelfTeleportAttempt("Lapis 0 SKIP: executor gak punya hookfunction.")
            return
        end

        local TeleportService = game:GetService("TeleportService")
        local currentPlaceId = game.PlaceId
        local originalTeleport

        local function safeTeleport(self, placeId, player, ...)
            if intentionalHopTeleportInProgress then
                -- Ini teleport yang KITA sendiri sengaja lakuin (Server Hop fallback),
                -- bukan soft-kick AFK dari game -- lolosin, jangan diblokir.
                logSelfTeleportAttempt("Lapis 0 LOLOS (Server Hop kita sendiri): TeleportService:Teleport(" .. tostring(placeId) .. ", LocalPlayer) dibiarkan jalan.")
                return originalTeleport(self, placeId, player, ...)
            end
            if self == TeleportService and placeId == currentPlaceId and player == LocalPlayer then
                warn("[AntiAFK] Lapis 0: blokir TeleportService:Teleport ke PlaceId yang sama (soft-kick AFK bawaan game) -- gak jadi rejoin.")
                logSelfTeleportAttempt("Lapis 0 BLOKIR: TeleportService:Teleport(" .. tostring(placeId) .. ", LocalPlayer) dicegat, gak jadi rejoin.")
                return
            end

            -- Teleport LAIN yang LOLOS (placeId beda / bukan LocalPlayer) -- kemungkinan
            -- besar teleport LEGIT (bukan soft-kick AFK), tapi dicatat juga jaga-jaga kalau
            -- ternyata INI yang jadi penyebab "masih ke-rejoin" (pola beda dari yang dikira).
            logSelfTeleportAttempt("Lapis 0 LOLOS (bukan pola soft-kick): TeleportService:Teleport(" .. tostring(placeId) .. ", " .. tostring(player) .. ") dibiarkan jalan.")
            return originalTeleport(self, placeId, player, ...)
        end

        originalTeleport = hookfunction(TeleportService.Teleport, safeTeleport)
        logSelfTeleportAttempt("Lapis 0 AKTIF: TeleportService.Teleport berhasil di-hook.")
    end)
    if not ok then
        warn("[AntiAFK] Lapis 0 gagal:", err)
        logSelfTeleportAttempt("Lapis 0 GAGAL total: " .. tostring(err))
    end
end
task.spawn(hookAntiAfkTeleport)

-- LAPIS -1 (tambahan, di luar dugaan awal): ternyata BUKAN cuma AntiAFK.client.lua yang
-- bisa nyebabin "reconnect". Ketemu jalur LAIN yang beda total di ReplicatedStorage/Library/
-- Client/Save.lua -- kalau fetch data save si LOCAL PLAYER balik dengan tipe yang gak sesuai
-- (result bukan table), langsung dipanggil:
--     LocalPlayer:Kick("Something went wrong fetching save. Please rejoin!")
-- Ini kick LANGSUNG (bukan teleport), jadi Lapis 0 di atas (yang nyegat TeleportService.
-- Teleport) SAMA SEKALI GAK NGARUH ke jalur ini -- beda fungsi yang dipanggil. Kemungkinan
-- ini yang sebenarnya kejadian selama ini (bukan soal AFK/Idled sama sekali), apalagi bot
-- kita ngirim request server jauh lebih rapat/sering daripada player normal (Auto Steal/
-- Auto Place nonstop), yang bisa aja bikin response "Get Stats" dari server jadi gak normal.
--
-- Sama kayak Lapis 0: HOOK langsung Player.Kick, blokir kalau target-nya LocalPlayer --
-- gak peduli dipanggil dari mana/alasan apa, dan dicatat ke log (termasuk PESAN kick-nya)
-- biar ketauan penyebab aslinya kalau ini yang selama ini bikin "reconnect".
local function hookLocalPlayerKick()
    local ok, err = pcall(function()
        if typeof(hookfunction) ~= "function" then
            warn("[AntiAFK] Executor gak punya hookfunction, skip hook Player:Kick.")
            logSelfTeleportAttempt("Hook Kick SKIP: executor gak punya hookfunction.")
            return
        end

        local originalKick

        local function safeKick(self, message, ...)
            if self == LocalPlayer then
                warn("[AntiAFK] Blokir LocalPlayer:Kick(\"" .. tostring(message) .. "\") -- gak jadi ke-disconnect.")
                logSelfTeleportAttempt("Hook Kick BLOKIR: pesan = \"" .. tostring(message) .. "\"")
                return
            end
            return originalKick(self, message, ...)
        end

        originalKick = hookfunction(LocalPlayer.Kick, safeKick)
        logSelfTeleportAttempt("Hook Kick AKTIF.")
    end)
    if not ok then
        warn("[AntiAFK] Hook Kick gagal:", err)
        logSelfTeleportAttempt("Hook Kick GAGAL total: " .. tostring(err))
    end
end
task.spawn(hookLocalPlayerKick)

local function tryDisableGameIdledConnections()
    local ok, err = pcall(function()
        local getconns = getconnections or get_signal_cons
        if not getconns then
            warn("[AntiAFK] Executor gak punya getconnections/get_signal_cons, skip Lapis 1 (masih ada Lapis 2 & 3).")
            logSelfTeleportAttempt("Lapis 1 SKIP: executor gak punya getconnections.")
            return
        end

        -- PENTING: connection object di beberapa executor (kayak Potassium) itu
        -- type()-nya "userdata", BUKAN "table" -- cek `type(conn) == "table"` bakal
        -- selalu false dan Disable()/Disconnect() gak pernah kepanggil sama sekali.
        -- Jangan gate pakai type()/typeof(), langsung pcall Disable()/Disconnect().
        local disabledCount = 0
        for _, conn in pairs(getconns(LocalPlayer.Idled)) do
            local disabled = pcall(function()
                conn:Disable()
            end)
            if not disabled then
                disabled = pcall(function()
                    conn:Disconnect()
                end)
            end
            if disabled then
                disabledCount = disabledCount + 1
            end
        end
        warn("[AntiAFK] Lapis 1: " .. disabledCount .. " koneksi Idled bawaan game berhasil di-disable.")
        logSelfTeleportAttempt("Lapis 1 AKTIF: " .. disabledCount .. " koneksi Idled di-disable.")
    end)
    if not ok then
        warn("[AntiAFK] Lapis 1 gagal:", err)
        logSelfTeleportAttempt("Lapis 1 GAGAL total: " .. tostring(err))
    end
end
task.spawn(tryDisableGameIdledConnections)

local afkQueuedForRejoin = false
local lastAfkReportAt = 0

LocalPlayer.Idled:Connect(function(idleSeconds)
    if not Config.AntiAFK then
        afkQueuedForRejoin = false
        return
    end

    -- Laporin "aktif" ke server, di-throttle biar gak spam remote tiap Idled numpuk
    if os.clock() - lastAfkReportAt > 15 then
        lastAfkReportAt = os.clock()
        pcall(function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Network = require(ReplicatedStorage.Library.Client.Network)
            local Analytics = require(ReplicatedStorage.Library.Globals.Constants).NETWORK_MAP.Analytics
            Network.Fire(Analytics.REPORT_AFK_STATE, false)
        end)
    end

    -- Sekali per periode idle: titipkan script ini ke queue_on_teleport, jaga-jaga
    -- kalau nanti beneran ke-rejoin otomatis abis 18 menit -- biar lanjut sendiri.
    if not afkQueuedForRejoin then
        afkQueuedForRejoin = true
        queueSelfForTeleport()
    end
end)

-- Begitu ada input FISIK asli lagi, reset flag-nya biar periode idle berikutnya
-- dititipkan ulang (bukan simulasi -- ini cuma DENGERIN, bukan ngirim input).
game:GetService("UserInputService").InputBegan:Connect(function()
    afkQueuedForRejoin = false
end)

-- LAPIS TAMBAHAN (saran temen user): gerakin karakter DIKIT-DIKIT terus-menerus
-- pakai Humanoid:MoveTo() biasa -- jalan beneran (trigger animasi Walk asli, bukan
-- CFrame teleport-tween), BUKAN simulasi input, jadi beda kategori total dari
-- VirtualUser/VirtualInputManager. Jaga-jaga kalau ternyata ada mekanisme AFK/
-- inactivity-detection LAIN (server-side atau di luar Idled bawaan Roblox) yang
-- berdasarkan pergerakan/perubahan posisi karakter, bukan cuma input device mentah.
-- Di-skip kalau Auto Steal lagi megang kendali posisi sendiri (Config.IsStealing),
-- biar gak tabrakan/gangguin tween yang lagi jalan.
task.spawn(function()
    while true do
        task.wait(20)
        pcall(function()
            if not Config.AntiAFK then return end
            if Config.IsStealing then return end

            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then return end

            -- Dikit BANGET (nilai pecahan, bukan math.random integer) -- cukup buat
            -- geser posisi dikit, gak sampe keliatan karakternya jalan jauh.
            local offsetX = (math.random() - 0.5) * 0.4 -- kira-kira -0.2 s/d 0.2 stud
            local offsetZ = (math.random() - 0.5) * 0.4
            hum:MoveTo(hrp.Position + Vector3.new(offsetX, 0, offsetZ))
        end)
    end
end)

-- ============================================================
-- SEMUA ELEMENT SELESAI DIBUAT (& DI-RESTORE OTOMATIS OLEH LIBRARY-NYA SENDIRI)
-- ============================================================
-- Setiap AddToggle/AddDropdown di atas otomatis restore state terakhir dari
-- Napoleon/Config/Napoleon_<gameId>.json lalu langsung nembak Callback-nya saat
-- dibuat (lihat NPLN-UIv4.lua). Karena semua Callback loop-starter di atas kita
-- gate pakai `UI_LOADED`, gak ada loop yang kepancing jalan sebelum semua filter
-- (dropdown yang didefinisikan belakangan) ikut ke-restore. Sekarang, setelah
-- SEMUA element (termasuk yang paling bawah) selesai dibuat & di-restore, baru
-- kita nyalain gate-nya dan kick-off manual loop mana aja yang Config-nya
-- ternyata udah true dari hasil restore tadi.
-- Cek: abis Server Hop, apa kita beneran landing di server BEDA, atau nyangkut balik
-- ke server yang sama (Teleport() polos gak jamin server ganti)? Kalau sama, langsung
-- hop ULANG sekarang juga -- gak perlu nunggu AutoStealLoop scan dulu baru ketauan.
local landedOnSameServerAfterHop = false
pcall(function()
    if typeof(isfile) == "function" and typeof(readfile) == "function" and isfile(LAST_HOP_JOBID_PATH) then
        local lastHopJobId = readfile(LAST_HOP_JOBID_PATH)
        if lastHopJobId == game.JobId then
            landedOnSameServerAfterHop = true
        end
        -- Hapus abis dibaca -- biar gak ke-detect lagi salah di sesi/rejoin berikutnya
        -- yang gak ada hubungannya sama Server Hop sama sekali.
        pcall(function() writefile(LAST_HOP_JOBID_PATH, "") end)
    end
end)

if landedOnSameServerAfterHop and Config.AutoStealServerHop then
    warn("[ServerHop] Nyangkut balik ke server yang sama, hop ulang...")
    logSelfTeleportAttempt("ServerHop: landing di server yang sama kayak sebelum hop, hop ulang otomatis.")
    hopToNewServer()
end

-- Bug di library NPLN-UIv4.lua: ScrollSelect di tiap dropdown CanvasSize-nya
-- stuck di {0,0} walau isinya beneran ada (confirmed: AbsoluteContentSize
-- ratusan-ribuan pixel, CanvasSize tetep {0,0}) -- makanya dropdown gak bisa
-- discroll. Gak bisa edit source-nya (di-host di GitHub orang), jadi di-sync
-- manual dari sini.
pcall(function()
    local rbxGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
    if not rbxGui then return end
    for _, obj in ipairs(rbxGui:GetDescendants()) do
        if obj.Name == "ScrollSelect" and obj:IsA("ScrollingFrame") then
            local listLayout = obj:FindFirstChildOfClass("UIListLayout")
            if listLayout then
                local function syncCanvas()
                    obj.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
                end
                syncCanvas()
                listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(syncCanvas)
            end
        end
    end
end)

UI_LOADED = true

if Config.AutoSteal then
    task.spawn(AutoStealLoop)
end

if Config.AutoPlace then
    task.spawn(AutoPlaceLoop)
end

if Config.AutoSell or Config.SellAll then
    startAutoSellLoop()
end

if Config.AutoSellEgg then
    startAutoSellEggLoop()
end

if Config.EggPredictUI then
    toggleEggPanelUI(true)
    startEggPanelLoop()
end
