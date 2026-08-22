-- PERBAIKAN DARURAT: ~467 baris pertama file ini (header, blok Zombie Mode, sistem
-- auth/key) HILANG dari file secara gak jelas sebabnya -- BUKAN dari edit sesi ini,
-- ketauan pas file dijalanin dan error "attempt to index nil with Character" karena
-- Players/LocalPlayer di bawah ini gak ke-declare lagi. Minimal fix: declare ulang
-- dua ini (isinya PASTI sama, cuma game:GetService biasa, gak ada yang ditebak).
-- Blok Zombie Mode & auth/key yang ikut hilang SENGAJA TIDAK direkonstruksi di sini --
-- Zombie Mode sendiri sudah dinonaktifkan permanen sesi ini, jadi bukan kehilangan
-- fungsional. Auth/key perlu dicek terpisah kalau ternyata dibutuhkan.
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- HOOK GLOBAL: TweenService:Create() yang dipanggil NewUI.lua (library UI yang
-- di-DOWNLOAD LIVE dari GitHub tiap run lewat LoadNapoleonUI di bawah, BUKAN dari file
-- lokal -- makanya gak bisa dipatch langsung di source-nya) kadang gagal dengan error
-- "lacking capability Plugin" pas drag/resize window atau resize list tab. Quirk lama
-- Potassium (udah pernah ketauan & di-pcall manual di SATU tempat di NewUI.lua --
-- AddToggle -- tapi drag/resize/list-resize gak ke-cover di situ). Solusinya: hook
-- TweenService:Create secara global DI SINI (punya kita, selalu kepake) biar SEMUA
-- pemanggil -- termasuk yang di dalam library remote -- otomatis ke-pcall. Gagal ->
-- balikin objek dummy yang method-nya no-op, biar kode pemanggil yang manggil
-- :Play()/.Completed di hasilnya juga gak ikut error.
local dummyTween = {}
dummyTween.Play = function() end
dummyTween.Pause = function() end
dummyTween.Cancel = function() end
dummyTween.Completed = {
    Connect = function() return { Disconnect = function() end } end,
    Once = function() return { Disconnect = function() end } end,
    Wait = function() end,
}
local originalTweenCreate
originalTweenCreate = hookfunction(TweenService.Create, newcclosure(function(self, ...)
    local ok, result = pcall(originalTweenCreate, self, ...)
    if ok then return result end
    return dummyTween
end))

-- HOOK LEBIH LUAS: ternyata "lacking capability Plugin" BUKAN cuma dari
-- TweenService:Create (di atas) -- banyak tempat lain di library nulis properti Instance
-- LANGSUNG (contoh: `KeybindFrame.Size = ...`, `ScrollSelect.CanvasSize = ...`) dan itu
-- ikut gagal juga. Hook Tween doang gak cukup nutup semua. Solusinya: hook __newindex
-- GLOBAL (nyegat SEMUA penulisan properti Instance di seluruh game), tapi DIBATASI cuma
-- buat Instance di bawah CoreGui -- di situ doang UI kita numpang -- biar gak nyentuh
-- (dan gak nambah overhead ke) sistem property-write game sendiri (egg growth, guard,
-- dll di luar UI kita). Gagal nulis properti di UI kita -> ditelan diam-diam.
local CoreGuiRef = game:GetService("CoreGui")
local originalNewindex
originalNewindex = hookmetamethod(game, "__newindex", newcclosure(function(self, key, value)
    if typeof(self) == "Instance" then
        local isOurUI = false
        pcall(function()
            isOurUI = self:IsDescendantOf(CoreGuiRef)
        end)
        if isOurUI then
            pcall(originalNewindex, self, key, value)
            return
        end
    end
    return originalNewindex(self, key, value)
end))

-- Sama kayak pola di Gag2.lua: cegah toggle yang di-restore otomatis mulai loop
-- SEBELUM semua dropdown filter di section yang sama sempat ke-restore juga. Baru
-- jadi true di paling bawah script, setelah semua UI + restore selesai settle.
local UI_LOADED = false

-- PENTING: queue_on_teleport di Potassium ternyata GAK sekali-pakai -- begitu
-- dititipkan sekali (misal buat Anti AFK), dia TERUS nempel dan ke-jalanin lagi di
-- teleport BERIKUTNYA juga -- termasuk pas user RELOG MANUAL sendiri (bukan gara-gara
-- script kita). Makanya "auto exec" kejadian padahal bukan kita yang mindahin.
-- Fix: clear queue-nya SEKALI di paling awal tiap kali script ini jalan.
-- CATATAN: script ini SUDAH TIDAK PERNAH nitipin apa pun ke queue_on_teleport lagi
-- (auto-execute/self-resume dicabut total). Clear di sini murni jaring pengaman buat
-- nyabut queue basi peninggalan versi LAMA script ini yang mungkin masih nempel.
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

-- DIMATIKAN TOTAL (update game bikin trik ini BALIK NYERANG).
--
-- Cara kerjanya dulu: sengaja NGEBUNUH karakter (`humanoid.Health = 0`) buat masuk state
-- "mati palsu", lalu nahan Health tetap penuh tiap RenderStepped -> karakter jadi kebal.
-- Itu berhenti bekerja setelah update game. Dibuktikan lewat tes terkontrol TANPA script:
-- rejoin bersih, SetStateEnabled(Dead/FallingDown/Ragdoll,false) SEMUA sukses, lalu
-- `Health = 0` SEKALI -> `Died` tetap fire dan karakter TETAP RESPAWN dalam 2.7 detik.
-- Jadi disable state di client udah gak nyegah apa pun; server yang nentuin.
--
-- Akibatnya blok ini bukan cuma gak berguna, tapi bikin script GAK BISA DIPAKAI:
--     Health = 0 -> mati beneran -> respawn -> CharacterAdded -> setupInvincibility lagi
--     -> Health = 0 lagi -> loop tak berujung
-- Terukur 12 respawn dalam 30 detik (interval ~2.4s, cocok sama RespawnTime=2 game).
--
-- Sengaja DITINGGALKAN sebagai komentar, bukan dihapus, biar kalau nanti ketemu
-- pendekatan pengganti, konteks kenapa yang lama gagal masih ada di sini.
--
-- local function setupInvincibility(humanoid)
--     if not humanoid then return end
--     local healthConn
--     pcall(function()
--         humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
--         humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
--         humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
--     end)
--     humanoid.Died:Connect(function()
--         local maxHp = humanoid.MaxHealth
--         healthConn = RunService.RenderStepped:Connect(function()
--             if not humanoid or not humanoid.Parent then
--                 if healthConn then healthConn:Disconnect() end
--                 return
--             end
--             humanoid.Health = maxHp
--         end)
--     end)
--     task.spawn(function()
--         task.wait(0.05)
--         humanoid.Health = 0   -- <-- INI yang sekarang bikin mati beneran
--     end)
-- end
--
-- task.spawn(function()
--     local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
--     local hum = char:WaitForChild("Humanoid", 5)
--     if hum then setupInvincibility(hum) end
-- end)
--
-- LocalPlayer.CharacterAdded:Connect(function(newChar)
--     local hum = newChar:WaitForChild("Humanoid", 5)
--     if hum then setupInvincibility(hum) end
-- end)

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
    TweenSpeedMultiplier = 2.5, -- Default; live-editable lewat slider "Move Speed Multiplier" di section Auto Farm (range 1-10)
    ApproachSettleDelay = 0.4, -- Fixed, no UI control (dulu slider, dicabut atas permintaan user)
    AntiTreadmillMount = true, -- Toggle-able lewat "Anti Treadmill Mount" di tab Misc
    -- SENGAJA toggle SENDIRI, bukan numpang AntiTreadmillMount: semantiknya berlawanan.
    -- AntiTreadmillMount = "jangan pernah mount". AutoTreadmillIdle = "mount pas nganggur".
    -- Kalau digabung, satu switch bakal ngendaliin dua perilaku yang saling bertentangan.
    AutoTreadmillIdle = false, -- Toggle-able lewat "Auto Treadmill When Idle" di tab Misc
    AntiGuardKnockback = true, -- Toggle-able lewat "Anti Guard Knockback" di tab Misc
    EggPredictUI = false,
    EggESP = false -- Toggle-able lewat "ESP" di tab Misc
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
--    gak butuh instan-instan amat), sementara cek state (murah) tetep tiap frame.
--
--    BUG SEBELUMNYA (Anti Guard "gak berfungsi" pas Auto Steal jalan): enforcer ini dulu
--    di-skip TOTAL pas Config.IsStealing aktif, dengan alasan "AutoStealLoop udah punya
--    abortTripIfDropped sendiri" -- tapi abortTripIfDropped cuma ngecek State record egg
--    di SERVER (buat tau kapan harus retry trip), BUKAN ngecek/benerin state ragdoll
--    karakter kita sendiri. Efeknya: kalau ke-ragdoll/statenya "jatuh" PAS lagi di tengah
--    Auto Steal (justru momen paling sering ketabrak Guard), gak ada apa pun yang
--    makSA balik ke GettingUp/re-enable Motor6D sampai Auto Steal di-OFF-in dulu --
--    keliatan kayak Anti Guard "mati" selama Auto Steal jalan. Bagian state/constraint
--    correction ini gak nyentuh velocity/CFrame sama sekali (beda sama Velocity Dampener
--    di bawah yang MEMANG masih perlu di-skip -- itu yang pernah bentrok literally sama
--    kecepatan tween), jadi aman tetep jalan biarpun lagi ditween.
local FALLDOWN_STATES = {
    [Enum.HumanoidStateType.Physics] = true,
    [Enum.HumanoidStateType.FallingDown] = true,
    [Enum.HumanoidStateType.Ragdoll] = true,
    [Enum.HumanoidStateType.PlatformStanding] = true,
    [Enum.HumanoidStateType.Seated] = true
}
local lastRagdollScanAt = 0
RunService.Stepped:Connect(function()
    if not Config.AntiGuardKnockback then return end
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

    -- Ambang ikut speed tween yang SEBENARNYA dipakai. Sejak multiplier dicabut, tween jalan
    -- persis di WalkSpeed -- jadi ambangnya WalkSpeed * 1.5, bukan lagi dikali multiplier.
    -- (Dulu pakai Config.TweenSpeedMultiplier; kalau dibiarkan, ambangnya bisa 10x lebih
    -- longgar dari gerakan kita yang sebenarnya -> dorongan asing lolos gak diredam.)
    local currentVelocity = hrp.AssemblyLinearVelocity
    local allowedMagnitude = math.max(walkSpeed * 1.5, 100)
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
--    slot key-nya salah).
--
--    DUA BUG YANG BARU DIBENERIN DI SINI:
--
--    (a) SINGLE-SHOT: dulu `lastHeldEggRecord = nil` di-set LANGSUNG abis
--        RequestCarryAreaEgg, tanpa mastiin carry-nya beneran nyantol. Server nolak
--        diam-diam (hal yang JELAS BISA kejadian -- itu justru alasan slot key
--        dihitung ulang di atas) = jaring pengamannya nembak sekali terus nyerah,
--        dan egg-nya beneran ilang. Sekarang record-nya DIPERTAHANIN sampai iterasi
--        berikutnya BENERAN ngeliat kita megang egg-nya lagi (carriedRecord != nil).
--        Kalau belum, retry sampai STICKY_MAX_ATTEMPTS dengan cooldown antar-percobaan.
--
--    (b) MATI TOTAL SELAMA IsStealing: dulu seluruh blok ini di-skip pas
--        Config.IsStealing aktif -- padahal itu PERSIS window di mana Guard mukul kita.
--        Alasan aslinya (jangan rebutan sama retry-nya AutoStealLoop) tetep valid, tapi
--        solusinya bukan matiin total: sekarang jaring ini tetep MANTAU terus (jadi
--        record-nya selalu fresh, gak nil pas dibutuhin), dan cuma nunggu grace period
--        STICKY_GRACE_WHILE_STEALING sebelum ikut turun tangan. AutoStealLoop tetep
--        dapet kesempatan pertama -- retry dia jauh lebih agresif (~0.05s) -- tapi kalau
--        abis grace itu egg-nya TETEP kelepas, jaring ini gak diem aja lagi.
local lastHeldEggRecord = nil
local stickyRecarryAttempts = 0
local stickyRecarryNextAt = 0
local stickyEggLostAt = 0
-- MAX_ATTEMPTS dinaikin 5 -> 20 BARENGAN sama cooldown diturunin di bawah. Budgetnya
-- dihitung per-PERCOBAAN bukan per-WAKTU -- kalau cuma cooldown yang diturunin tanpa
-- naikin ini, jendela keterlibatan jaring malah MENGECIL (5 x 0.35s = 1.75s jadi
-- 5 x 0.1s = 0.5s), padahal egg abis dijatuhin Guard sering masih transisi state
-- (GuardCarried/belum Dropped) selama beberapa ratus ms -- percobaan awal wajar gagal.
-- 20 x 0.1s = ~2s, jendela balik sepadan (malah sedikit lebih luas) dari sebelumnya.
local STICKY_MAX_ATTEMPTS = 20
-- NILAI DI BAWAH DITURUNKAN -- dulu dipilih waktu kita masih ngira ada lapis lain
-- yang beneran nyegah drop-nya (hook Ragdoll, blokir REQUEST_AREA_EGG_DROP, dll).
-- Terbukti dari source game sendiri: drop-nya dipanggil server (GameplayToolGuard.
-- DropHeldEggFromPlayerHit) bareng Ragdoll server-side, BUKAN lewat remote yang kita
-- blokir di client (RequestDropHeldAreaEgg nol pemanggil di seluruh client script).
-- Jadi jaring sticky ini SATU-SATUNYA lapis yang masih beneran kerja -- grace &
-- cooldown lama itu jeda mati yang mahal, bukan lagi "kasih kesempatan lapis lain".
local STICKY_RETRY_COOLDOWN = 0.1
local STICKY_GRACE_WHILE_STEALING = 0.2

local function resetStickyRecarry()
    lastHeldEggRecord = nil
    stickyRecarryAttempts = 0
    stickyRecarryNextAt = 0
    stickyEggLostAt = 0
end

-- Modul AreaEggSlotIdentity di-cache sekali dipakai selamanya. DULU require-nya
-- dipanggil ulang TIAP computeFirstAreaSlotKey kepanggil -- dan itu jalan di loop 10 Hz
-- (sticky re-carry) plus tiap percobaan steal. require() sendiri di-cache Roblox, tapi
-- rantai game:GetService() + 3x index + pemanggilan pcall/require-nya tetep kejadian
-- tiap kali. Warn-nya sengaja SEKALI aja -- kalau modulnya beneran gak ada, spam warn
-- 10x per detik cuma nutupin log yang berguna.
local areaEggSlotIdentityCache = nil
local areaEggSlotIdentityWarned = false

local function getAreaEggSlotIdentity()
    if areaEggSlotIdentityCache then return areaEggSlotIdentityCache end
    local ok, mod = pcall(function()
        return require(game:GetService("ReplicatedStorage").Library.Util.AreaEggSlotIdentity)
    end)
    if ok and mod then
        areaEggSlotIdentityCache = mod
    elseif not areaEggSlotIdentityWarned then
        areaEggSlotIdentityWarned = true
        warn("[SlotKey] Gagal require AreaEggSlotIdentity, FirstAreaSlotKey dipaksa nil (aman buat egg biasa):", mod)
    end
    return areaEggSlotIdentityCache
end

local function computeFirstAreaSlotKey(uid, areaId, nestId)
    local AreaEggSlotIdentity = getAreaEggSlotIdentity()
    if not AreaEggSlotIdentity then return nil end
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
        -- Poll dipercepat dari 0.1 -> 0.05 buat alesan yang sama kayak STICKY_RETRY_COOLDOWN
        -- di atas: ini sekarang satu-satunya jaring yang beneran nahan egg kelepas gara-gara
        -- Guard, jadi tiap 50ms nunggu tambahan itu jendela yang beneran kepake orang lain.
        task.wait(0.05)
        if Config.AntiGuardKnockback then
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

                -- Kebawa (masih, atau udah nyantol lagi abis retry) -> carry SUKSES.
                -- Ini satu-satunya bukti valid kalau request kita diterima server;
                -- balikan RequestCarryAreaEgg sendiri gak bisa dipercaya buat itu.
                if carriedRecord then
                    lastHeldEggRecord = carriedRecord
                    stickyRecarryAttempts = 0
                    stickyRecarryNextAt = 0
                    stickyEggLostAt = 0
                    return
                end

                if not lastHeldEggRecord then return end

                local nowClock = os.clock()
                if stickyEggLostAt == 0 then
                    stickyEggLostAt = nowClock
                end

                -- AutoStealLoop dapet kesempatan pertama selama grace period.
                if Config.IsStealing and (nowClock - stickyEggLostAt) < STICKY_GRACE_WHILE_STEALING then
                    return
                end

                if nowClock < stickyRecarryNextAt then return end

                if stickyRecarryAttempts >= STICKY_MAX_ATTEMPTS then
                    resetStickyRecarry()
                    return
                end

                -- Masih worth dicoba? Kalau egg-nya udah ilang total dari snapshot, atau
                -- State-nya udah bukan Slot/Dropped lagi (= keduluan diambil orang lain /
                -- keburu dibawa Guard), nembakin request cuma buang-buang remote call.
                local fresh = EggCmds.GetAreaEggRecord(lastHeldEggRecord.Uid)
                if fresh == nil or not (fresh.State == "Slot" or fresh.State == "Dropped") then
                    resetStickyRecarry()
                    return
                end

                stickyRecarryAttempts = stickyRecarryAttempts + 1
                stickyRecarryNextAt = nowClock + STICKY_RETRY_COOLDOWN

                -- Pakai AreaId/NestId dari record FRESH, bukan dari record lama yang kita
                -- simpen -- posisi slot egg bisa udah beda dari terakhir kali kita bawa.
                local slotKey = computeFirstAreaSlotKey(fresh.Uid, fresh.AreaId, fresh.NestId)
                EggCmds.RequestCarryAreaEgg(fresh.Uid, slotKey)
                -- lastHeldEggRecord SENGAJA dipertahanin -- iterasi berikutnya yang jadi
                -- juri apakah carry-nya beneran nyantol. Kalau enggak, retry lagi.
            end)
            if not ok then
                -- Error di sini paling sering cuma snapshot yang belum siap sesaat, BUKAN
                -- tanda egg-nya beneran gak bisa diambil -- jadi jangan langsung buang
                -- targetnya kayak versi lama. Dihitung sebagai satu percobaan gagal aja;
                -- kalau beneran rusak terus, STICKY_MAX_ATTEMPTS yang nyetop.
                stickyRecarryAttempts = stickyRecarryAttempts + 1
                stickyRecarryNextAt = os.clock() + STICKY_RETRY_COOLDOWN
                if stickyRecarryAttempts >= STICKY_MAX_ATTEMPTS then
                    resetStickyRecarry()
                end
            end
        end
    end
end)

-- ============================================================
-- CATATAN: gak perlu sistem persist custom di sini. NPLN-UIv4.lua (library UI-nya)
-- SUDAH auto-save & auto-restore tiap Toggle/Dropdown ke Napoleon/Config/Napoleon_<gameId>.json
-- dengan sendirinya (lihat ConfigData[configKey] check di AddToggle/AddDropdown).
-- Yang perlu kita tangani sendiri cuma: cegah loop mulai duluan sebelum SEMUA
-- element (termasuk dropdown filter) selesai di-restore -> pakai UI_LOADED gate.
-- ============================================================

-- AUTO-EXECUTE / SELF-RESUME: DIHAPUS TOTAL atas permintaan user.
--
-- Dulu di sini ada RESUME_SCRIPT_URL + queueSelfForTeleport(): tiap periode idle,
-- script nitipin `loadstring(game:HttpGet(<URL>))()` ke queue_on_teleport, supaya abis
-- ke-rejoin otomatis (AFK-kick 18 menit) dia jalan lagi sendiri. Itu DICABUT karena:
--   1. queue_on_teleport di Potassium gak sekali-pakai -- queue basi kefire di teleport
--      APA PUN sesudahnya, termasuk relog manual. Gejalanya "script jalan sendiri".
--   2. Yang di-resume itu versi dari URL (published), BUKAN file ini -- jadi yang jalan
--      bisa versi lama tanpa fix apa pun yang ada di sini.
--   3. Tiap resume nambah SATU INSTANCE LAGI di client yang sama -- lengkap dengan tabel
--      Config sendiri. Karena Config itu local, instance lama GAK BISA dikendalikan dari
--      UI instance baru; gejalanya persis "udah kumatiin tapi tetep jalan".
--
-- CATATAN PENTING buat siapa pun yang baca ini nanti: mencabut auto-execute TIDAK
-- menghilangkan risiko duplikasi. Duplikasi yang TERUKUR di client user datang dari
-- EXECUTE MANUAL DUA KALI dalam satu sesi, bukan dari auto-resume. Sempat ada penjaga
-- single-instance di paling atas file yang nolak eksekusi kedua, tapi itu dihapus atas
-- permintaan user. Jadi kalau user execute 2x, dua instance bakal jalan bareng tanpa
-- peringatan apa pun. Cara bersihinnya: REJOIN (terukur nge-reset semuanya -- artefak
-- GUI, loop, dan getgenv), lalu execute SEKALI saja.
--
-- Konsekuensi yang disengaja: kalau kena AFK-kick, script TIDAK lanjut sendiri --
-- harus di-execute manual lagi. Anti AFK sendiri TIDAK diubah dan tetap jalan penuh
-- (lapis hook Teleport/Kick, disable koneksi Idled, dan gerak-dikit MoveTo di bawah);
-- yang hilang cuma jaring pengaman "kalau ternyata tetap ke-kick".
--
-- Clear queue di paling atas file (pcall(queueFunc, "")) SENGAJA DIPERTAHANKAN sebagai
-- jaring pengaman: dia nyabut queue basi yang mungkin ditinggalkan versi LAMA script ini.

-- Log ke FILE (bukan cuma console) buat lapis-lapis Anti AFK di bawah -- karena
-- pemicunya (idle lama) sering kejadian pas
-- user LAGI GAK DI DEPAN LAYAR, jadi gak ada yang bisa liat warn() di console pas itu
-- kejadian. Kalau nanti ada yang aneh, tinggal cek isi file ini abis balik.
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

-- (queueSelfForTeleport dihapus -- lihat blok "AUTO-EXECUTE / SELF-RESUME" di atas.)

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
        -- PATCH SUMBER SEBELUM loadstring -- akar "lacking capability Plugin".
        -- Callback yang di-fire ENGINE (property-changed buat layout/ukur teks, ChildAdded,
        -- Changed) jalan di thread identity 2, dan dari identity segitu SEMUA akses Instance
        -- di bawah CoreGui ditolak: baca, tulis, maupun method call. Terverifikasi live --
        -- identity 8 lolos, identity 2 gagal; gethui() gak nolong (isinya CoreGui.RobloxGui,
        -- kena aturan yang sama), PlayerGui lolos tapi kena ResetOnSpawn + keliatan script
        -- game. Hook __newindex di paling atas file ini cuma nutup jalur TULIS, sementara
        -- yang gagal duluan justru BACAAN di sisi kanan assignment -- makanya lolos mentah.
        -- Daripada nambal baris per baris (2492, terus 1863, terus 3160, ...), yang dibungkus
        -- handler-nya: tiap signal engine dilewatin __ptsafe dulu, jadi semua handler yang
        -- nyangkut di situ otomatis ke-pcall. Prologue-nya digabung ke baris 1 tanpa newline
        -- dan semua pengganti tetap di baris asalnya, biar nomor baris di stack trace gak
        -- bergeser. Event input (MouseButton1Click dll) SENGAJA gak disentuh -- itu jalan
        -- normal di identity 8, kalau ikut di-pcall bug asli malah ketutup.
        local prologue = "local function __ptsafe(sig) return { Connect = function(_, fn) return sig:Connect(function(...) return (pcall(fn, ...)) end) end } end;"
        result = prologue .. result
        result = string.gsub(result, "([%w_%.]+):GetPropertyChangedSignal(%b()):Connect%(",
            "__ptsafe(%1:GetPropertyChangedSignal%2):Connect(")
        for _, ev in ipairs({ "Changed", "ChildAdded", "ChildRemoved", "DescendantAdded", "DescendantRemoving", "AncestryChanged" }) do
            result = string.gsub(result, "([%w_%.]+)%." .. ev .. ":Connect%(", "__ptsafe(%1." .. ev .. "):Connect(")
        end

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

-- Baca isi dropdown LANGSUNG dari library, JANGAN dari cache Config kita.
--
-- KENAPA INI ADA (bug nyata, bikin pet member kejual habis): di NewUI.lua,
-- `DropdownFunc:Set` ngerjain urutan ini --
--   (1) DropdownFunc.Value = nilai baru
--   (2) ConfigData[key] = nilai baru + SaveConfig()
--   (3) loop TweenService:Create(...):Play() buat semua opsi  <-- GAK di-pcall
--   (4) DropdownConfig.Callback(DropdownFunc.Value)           <-- Callback KITA, PALING AKHIR
-- Kalau TweenService:Create throw di (3) -- dan "lacking capability Plugin" itu KEJADIAN
-- NYATA di executor ini, bukan teori -- maka (4) GAK PERNAH JALAN. Efeknya: library-nya
-- sendiri UDAH update (dan JSON-nya juga, dari langkah 2), tapi cache kita nyangkut di
-- nilai LAMA. Buat filter yang keputusannya DESTRUKTIF, cache nyangkut = tetep jual
-- barang yang user udah nyoba cabut dari filter. Persis yang kejadian: user unselect
-- rarity, jualan gak berhenti.
--
-- CATATAN penting soal TOGGLE: `ToggleFunc:Set` di library yang SAMA manggil Callback
-- PALING AWAL (sebelum ConfigData & sebelum tween apa pun), dan dibungkus pcall sendiri.
-- Jadi toggle GAK kena masalah ini -- Config.AutoSell/SellAll/AutoSellEgg tetep bisa
-- dipercaya. Yang rusak khusus DROPDOWN, gara-gara urutannya kebalik. Makanya helper ini
-- cuma dipakai buat dropdown, bukan disebar ke semua state UI.
--
-- `DropdownFunc.Value` di-set di langkah (1), SEBELUM tween mana pun bisa throw, jadi
-- GetValue() selalu akurat.
--
-- Balikin nil kalau nilainya GAK BISA dibaca. Pemanggil WAJIB nganggep nil sebagai
-- "jangan lakuin apa-apa", BUKAN "pakai nilai terakhir yang diketahui" -- buat operasi
-- yang gak bisa di-undo kayak jual aset, gagal baca filter harus berarti berhenti.
local function readDropdownFilter(dropObj)
    if not dropObj or type(dropObj.GetValue) ~= "function" then return nil end

    local ok, val = pcall(function() return dropObj:GetValue() end)
    if not ok then return nil end

    -- Bentuknya bisa array {"Cosmic","Mythic"} atau dict {Cosmic=true} tergantung
    -- jalur mana yang terakhir nge-set -- sama kayak yang di-handle handleDropdownChange.
    if type(val) == "table" then
        local arr = {}
        for k, v in pairs(val) do
            if type(k) == "number" then
                table.insert(arr, v)
            elseif type(k) == "string" and v == true then
                table.insert(arr, k)
            end
        end
        return arr
    end

    if type(val) == "string" then return {val} end

    return nil
end

-- SATU-SATUNYA tempat aturan "pet ini kena filter jual apa enggak" ditulis.
--
-- Sengaja dipakai DUA kali di jalur yang sama: sekali pas nyusun daftar kandidat, dan
-- sekali lagi pas mau nembak penjualannya. Kalau logic ini ditulis ulang di dua tempat,
-- dua-duanya bakal drift seiring waktu -- dan drift di antara "apa yang dipilih" vs "apa
-- yang dijual" itu PERSIS bentuk bug yang bikin pet member kejual habis. Satu sumber
-- kebenaran, dipanggil dari mana pun butuh.
--
-- Config.SellAll ikut dicek DI DALAM sini (bukan di pemanggil) supaya kalau toggle
-- "Auto Sell All Pet" dimatiin di tengah batch, re-check-nya ikut berhenti nganggep
-- semua pet match.
local function petMatchesSellFilter(petName, rarity, names, rarities)
    if Config.SellAll then return true end
    if type(names) ~= "table" or type(rarities) ~= "table" then return false end

    local nameMatch = false
    if #names == 0 or table.find(names, "None") then
        nameMatch = false
    elseif table.find(names, "All") then
        nameMatch = true
    else
        nameMatch = table.find(names, petName) ~= nil
    end

    local rarityMatch = false
    if #rarities == 0 or table.find(rarities, "None") then
        rarityMatch = false
    elseif table.find(rarities, "All") then
        rarityMatch = true
    else
        rarityMatch = table.find(rarities, rarity) ~= nil
    end

    return nameMatch or rarityMatch
end

-- Versi egg. Dipisah karena aturannya beda (cuma rarity, gak ada filter nama, dan gak
-- ada modifier SellAll) -- tapi alasan keberadaannya sama: satu sumber kebenaran yang
-- dipakai BARENGAN pas nyusun kandidat dan pas mau nembak penjualannya.
local function eggMatchesSellFilter(rarity, rarities)
    if type(rarities) ~= "table" then return false end
    if #rarities == 0 or table.find(rarities, "None") then return false end
    if table.find(rarities, "All") then return true end
    return table.find(rarities, rarity) ~= nil
end

-- ============================================================
-- SMOOTH MOVEMENT (TWEEN, BUKAN TELEPORT)
-- ============================================================
-- Gerakin HumanoidRootPart secara mulus dari posisi sekarang ke targetCFrame,
-- dengan kecepatan = Humanoid.WalkSpeed karakter saat ini (studs/detik) dikali
-- multiplier. WalkSpeed ASLI (multiplier=1) server-authoritative jadi otomatis
-- ngikutin speed yang valid dikenal server -- tapi begitu dikali multiplier > batas
-- aman, delta posisi per update ngelewatin apa yang server anggap wajar buat
-- WalkSpeed kita, dan carry request/posisi bisa DIAM-DIAM DITOLAK (bukan crash/error
-- keliatan -- gejalanya karakter keliatan "stuck" di egg lokal, terus begitu pin
-- dilepas posisinya rubber-band balik ke titik terakhir yang server akui). Makanya
-- speed final di-clamp lewat MAX_SAFE_SPEED_MULTIPLIER di bawah, terpisah dari
-- multiplier mentah yang dipilih user.
--
-- Fallback kalau Config.TweenSpeedMultiplier invalid/kosong. Nilai aslinya sekarang
-- live-editable lewat slider "Move Speed Multiplier" (section Auto Farm, range 1-10) --
-- slider gak bisa ngehasilin nilai di luar range itu (drag maupun ketik manual di
-- textbox-nya sama-sama di-clamp sama library-nya sendiri), jadi fallback ini praktis
-- cuma kejalanin sebelum UI sempat init atau kalau ConfigData korup.
local DEFAULT_TWEEN_SPEED_MULTIPLIER = 2.5

-- Batas ATAS speed efektif yang BENERAN dipake, terpisah dari angka yang dipilih di
-- slider UI (yang boleh sampe 10 buat fleksibilitas). Berapa pun multiplier yang
-- di-set user, dia di-clamp ke sini dulu sebelum dikali WalkSpeed. Nilai 3 dipilih
-- karena 2.5 adalah default lama yang kebanyakan aman (sebelum slider ini ada) --
-- dikasih headroom dikit di atasnya, BUKAN dibebasin ke berapa pun. Kalau nanti ada
-- data lebih pasti dari carryErr/remote spy soal ambang toleransi server yang
-- sebenernya, angka ini yang pertama harus di-review ulang.
local MAX_SAFE_SPEED_MULTIPLIER = 3

-- Floor durasi minimum tiap tween. NILAI DITURUNKAN 0.15 -> 0.08 abis multiplier
-- dicabut. Alesan 0.15 dulu: speed efektif bisa ~1500 stud/detik (WalkSpeed 300 x
-- multiplier 5), jarak pendek selesai dalam hitungan milidetik = keliatan kayak
-- teleport. Tapi 0.15 itu ternyata KETINGGIAN buat WalkSpeed asli (~200-an) --
-- floor-nya jadi lebih sering nentuin durasi daripada distance/speed sendiri, dan
-- hasilnya tween keliatan/kerasa LEBIH LAMBAT dari WalkSpeed karakter yang
-- sebenarnya (WalkSpeed 207: jarak di bawah ~31 stud kena floor, bukan speed asli).
-- Dipilih 0.08 (bukan 0.05) sebagai lindung nilai buat device lambat (Redfinger/cloud
-- Android) yang komentar lama berkali-kali sebut sebagai alasan floor ini ada -- di
-- 30fps, 0.05 cuma ~1.5 frame (praktis balik jadi snap), 0.08 masih ~3 frame. Di
-- WalkSpeed 207, 0.08 cuma dominan buat jarak <~17 stud (vs <31 stud di floor lama
-- 0.15) -- mayoritas hop tetep dapet speed asli, gain-nya gak banyak berkurang.
local MIN_TWEEN_DURATION = 0.08

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

    -- MULTIPLIER DICABUT -- tween sekarang PERSIS ngikutin WalkSpeed asli karakter di game.
    --
    -- Dulu: speed = WalkSpeed * Config.TweenSpeedMultiplier (di-clamp MAX_SAFE_SPEED_MULTIPLIER).
    -- Masalahnya, gerak lebih cepat dari WalkSpeed yang server tau itu yang bikin delta posisi
    -- per update kelewat jauh -> server diam-diam nolak carry request -> gejalanya "udah nyampe
    -- egg tapi gak ke-stole", terus posisi rubber-band balik pas pin dilepas.
    --
    -- Sekarang speed = WalkSpeed apa adanya. Jadi kalau user mau lebih cepat, jalurnya lewat
    -- MENAIKKAN WalkSpeed di dalam game (treadmill/upgrade) -- yang otomatis diakui server --
    -- bukan lewat ngelebihin angka yang server percaya.
    local duration = math.max(distance / speed, MIN_TWEEN_DURATION)

    -- Matiin collision karakter SELAMA tween jalan -- kalau CFrame paksa ini
    -- numbuk sesuatu (wall, player lain, dll) di tengah jalan, physics engine
    -- nyoba "ngedorong balik" buat resolve interpenetrasi, keliatan/kerasa
    -- kayak jitter/patah-patah -- apalagi di device frame rate rendah yang
    -- jarak antar update CFrame-nya lebih renggang. Disimpen part mana aja
    -- yang tadinya CanCollide=true biar bisa dipulihin persis, bukan asal
    -- di-set true semua di akhir (ada part yang emang dari awal false).
    local character = hrp.Parent
    local restoreCollide = {}
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                restoreCollide[part] = true
                part.CanCollide = false
            end
        end
    end

    -- PlatformStand biar Humanoid-nya gak ikut "ngelawan" paksaan CFrame ini
    -- lewat state machine jalan/animasi bawaannya sendiri.
    if hum then hum.PlatformStand = true end

    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
        { CFrame = targetCFrame }
    )
    activeMoveTweens[hrp] = tween

    tween:Play()

    -- Poll tiap Heartbeat (bukan tween.Completed:Wait() doang) biar bisa
    -- di-cancel di tengah jalan begitu toggle di-OFF-in.
    --
    -- BUG SEBELUMNYA (laporan mobile/cloud device: karakter keliatan "stuck" nanggung
    -- persis ke arah egg tapi gak pernah beneran nyampe/ke-verifikasi server, harus
    -- toggle Auto Steal OFF lalu ON lagi baru lanjut): loop ini nunggu
    -- tween.PlaybackState lewat RunService.Heartbeat:Wait() TANPA batas waktu sama
    -- sekali. Kalau device-nya lagi severely throttled (cloud Android/Redfinger, app
    -- di-background, dll), Heartbeat bisa jarang banget nge-fire -- dan TWEEN ITU
    -- SENDIRI (jalan lewat scheduler internal Roblox yang sama) ikut nge-stall
    -- bareng. Hasilnya: CFrame nyangkut PERSIS DI TENGAH JALAN (baru sebagian ke arah
    -- target, bukan di egg beneran) selama-lamanya, nunggu Heartbeat yang gak
    -- kunjung nge-fire lagi -- dari luar keliatan kayak "stuck ngarah ke egg" persis
    -- yang dilaporkan.
    -- Fix: kasih TIMEOUT berbasis waktu ASLI (os.clock(), bukan hitungan frame) --
    -- kalau udah lewat dari perkiraan durasi + margin aman, JANGAN nunggu sinyal
    -- PlaybackState lagi -- paksa Cancel() tween-nya dan HARD-SNAP CFrame langsung
    -- ke targetCFrame, baru lanjut. Ini mastiin TweenMoveTo GAK PERNAH nyangkut
    -- selama-lamanya nunggu Heartbeat yang gak dateng-dateng, walau device-nya lagi
    -- berat -- otomatis "beres sendiri" tanpa butuh toggle OFF/ON manual lagi.
    local tweenStartedAt = os.clock()
    local tweenTimeoutAt = tweenStartedAt + duration + math.max(duration, 2)
    while tween.PlaybackState == Enum.PlaybackState.Playing do
        if isCancelledFn and isCancelledFn() then
            tween:Cancel()
            break
        end
        if os.clock() >= tweenTimeoutAt then
            tween:Cancel()
            hrp.CFrame = targetCFrame
            break
        end

        -- Redam residual velocity (gravitasi dll numpuk walau CanCollide
        -- udah dimatiin -- gravitasi tetep jalan ke part yang gak di-Anchor)
        -- tiap frame, biar gak berasa "kesedot"/lompat begitu tween kelar.
        local vel = hrp.AssemblyLinearVelocity
        hrp.AssemblyLinearVelocity = Vector3.new(vel.X * 0.4, 0, vel.Z * 0.4)
        hrp.AssemblyAngularVelocity = Vector3.zero

        RunService.Heartbeat:Wait()
    end

    if activeMoveTweens[hrp] == tween then
        activeMoveTweens[hrp] = nil
    end

    for part in pairs(restoreCollide) do
        if part and part.Parent then
            part.CanCollide = true
        end
    end
    if hum then hum.PlatformStand = false end

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
-- Status mount TERAKHIR yang kita tau: nil = gak mounted, string = treadmillId aktif.
-- SENGAJA dicatat dari event TANPA peduli toggle (lihat listener di bawah) -- kalau
-- pencatatannya ikut digate toggle, state ini jadi bohong tiap kali toggle-nya sempat
-- OFF, dan rekonsiliasi di bawah bakal buta.
local treadmillActiveId = nil

-- Baca status mount dari SERVER. Balikin true / false / nil (nil = gak bisa ditentuin).
--
-- Kenapa perlu, padahal udah ada listener event: kalau script di-exec PAS karakter udah
-- mounted (re-exec sambil berdiri di treadmill, atau queue_on_teleport yang landing di
-- footprint), gak ada event apa pun yang fire sejak exec -- `treadmillActiveId` masih nil
-- dan kita nyimpulin "gak mounted" padahal mounted. Ini yang KEJADIAN NYATA: karakter
-- pernah nyangkut mounted lama (backpack GUI mati) tanpa ada yang nurunin.
--
-- Sumbernya endpoint resmi yang dipakai controller game sendiri
-- (TreadmillStaticController.synchronizeRemoteSessionSnapshot): balikannya array userId
-- yang lagi aktif di treadmill. Ini INVOKE ke server, jadi JANGAN di-poll rapat --
-- dipakai buat probe sekali di startup + re-sync jarang. Tracking normal dari event.
--
-- CATATAN: JANGAN pakai proxy UI (`GUI.Backpack().Enabled == false`) buat ini. Backpack
-- juga dimatiin sama PlayerScripts.GUI.TrappedBackpackLock pas kita kena PlayerTrap, jadi
-- proxy itu AMBIGU antara "mounted" dan "ke-trap" -- bisa bikin kita nembak unequip
-- berulang padahal cuma ke-trap.
local function readTreadmillMountedFromServer()
    local ok, activeIds = pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Network = require(ReplicatedStorage.Library.Client.Network)
        local Treadmills = require(ReplicatedStorage.Library.Globals.Constants).NETWORK_MAP.Treadmills
        return Network.Invoke(Treadmills.REQUEST_ACTIVE_RENDER_SNAPSHOT)
    end)
    if not ok or type(activeIds) ~= "table" then return nil end
    return table.find(activeIds, LocalPlayer.UserId) ~= nil
end

-- Minta lepas dari treadmill. Balikin ok, alasan.
-- REQUEST_UNEQUIP itu RemoteFunction yang balikin (ok, reason) -- versi lama cuma nyimpen
-- hasil pcall dan buang balikannya, jadi PENOLAKAN SERVER ke-anggep sukses.
local function requestTreadmillUnequip()
    local pcallOk, serverOk, reason = pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Network = require(ReplicatedStorage.Library.Client.Network)
        local Treadmills = require(ReplicatedStorage.Library.Globals.Constants).NETWORK_MAP.Treadmills
        return Network.Invoke(Treadmills.REQUEST_UNEQUIP)
    end)
    if not pcallOk then return false, tostring(serverOk) end
    if serverOk ~= true then return false, tostring(reason) end
    -- SENGAJA GAK nge-clear treadmillActiveId di sini.
    --
    -- Versi awal fungsi ini nge-set `treadmillActiveId = nil` begitu server ngasih ack --
    -- yaitu nganggep "request diterima" = "keadaan udah berubah". Itu salah, dan efeknya
    -- nyata: pemanggil yang mau NUNGGU sampai beneran lepas jadi gak bisa nunggu apa pun,
    -- karena state-nya udah kita palsuin jadi "lepas" sebelum transisinya kelar.
    --
    -- Yang boleh nge-clear cuma DUA sumber kebenaran: event ACTIVE_TREADMILL_EVENT yang
    -- fire dengan nil, dan probe server di rekonsiliasi. Request cuma MINTA, bukan NENTUIN.
    -- Kalau server nerima tapi event-nya kelewat, state-nya basi sampai rekonsiliasi 30
    -- detik nyapu -- itu jauh lebih baik daripada state yang bohong seketika.
    return true
end

-- Part tempat karakter berdiri buat ke-mount. Dicari ULANG tiap kali, jangan di-cache:
-- render treadmill muncul/ilang seiring pemain join-leave (kekonfirmasi live -- jumlah
-- anak __ClientTreadmillRenders berubah di antara dua pembacaan), dan slot kita bisa beda.
local function findMyTreadmillStandPart()
    local ok, part = pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local slot = require(ReplicatedStorage.Library.Client.PlotCmds).GetMySlot()
        if slot == nil then return nil end
        local folder = workspace:FindFirstChild("__ClientTreadmillRenders")
        if not folder then return nil end
        local render = folder:FindFirstChild("TreadmillRender_" .. tostring(slot))
        if not render then return nil end
        -- "Root" itu titik yang PERSIS ditempatin karakter pas ke-mount (terverifikasi:
        -- posisi HRP pas mounted sama persis dengan Root.Position).
        local root = render:FindFirstChild("Root")
        if root and root:IsA("BasePart") then return root end
        return nil
    end)
    if not ok then return nil end
    return part
end

-- Dipakai AutoStealLoop SEBELUM mulai carry. Murah kalau kita gak mounted (kasus
-- mayoritas): cuma baca variabel lokal, nol remote call.
--
-- Kenapa ini perlu padahal tween steal toh mindahin kita keluar dari treadmill: masalahnya
-- BUKAN posisi. Pas mount kejadian, game manggil Humanoid:UnequipTools() (lihat
-- PlayerScripts.GUI.TreadmillUI.Visibility) dan matiin backpack GUI. Kalau itu kejadian di
-- tengah proses carry/sell yang ngandelin tool ke-equip, prosesnya gagal senyap. Jadi yang
-- kita butuh itu JAMINAN URUTAN: pastiin udah lepas SEBELUM mulai, bukan gerakan tambahan.
-- Nunggunya berbasis KONFIRMASI, bukan asumsi waktu. Dulu fungsi ini cuma nembak request
-- terus langsung return, dan pemanggilnya lanjut ke tween seketika -- karakter "maju
-- duluan" padahal transisi lepas treadmill belum kelar (laporan nyata dari user).
local UNMOUNT_CONFIRM_TIMEOUT = 1.5
-- Jeda kecil SETELAH konfirmasi. Ini bukan tebak-tebakan durasi: `UnequipTools()` +
-- backpack GUI dijalanin listener GAME di EVENT YANG SAMA (PlayerScripts.GUI.TreadmillUI
-- .Visibility), dan urutan listener dalam satu signal GAK DIJAMIN -- listener kita bisa
-- jalan SEBELUM listener game-nya. Jadi "event udah fire" belum berarti transisinya kelar.
-- Jeda ini ngasih listener lain di event yang sama kesempatan selesai.
local UNMOUNT_SETTLE_DELAY = 0.12

local function ensureUnmountedBeforeSteal()
    -- Kasus mayoritas: gak mounted. Nol remote call, nol delay.
    if treadmillActiveId == nil then return true end

    local ok, reason = requestTreadmillUnequip()
    if not ok then
        warn("[Treadmill] Gagal minta lepas dari treadmill sebelum steal:", reason)
    end

    -- Tunggu event ACTIVE_TREADMILL_EVENT beneran fire dengan nil (listener kita yang
    -- nge-clear treadmillActiveId). Keluar begitu kekonfirmasi -- biasanya jauh lebih
    -- cepat dari delay tetap, dan gak nebak durasi round-trip.
    local waited = 0
    while treadmillActiveId ~= nil and waited < UNMOUNT_CONFIRM_TIMEOUT do
        task.wait(0.05)
        waited = waited + 0.05
        -- Toggle dimatiin di tengah nunggu -> jangan nahan, keluar sekarang.
        if not Config.AutoSteal then return false end
    end

    if treadmillActiveId ~= nil then
        -- TIMEOUT: tetep LANJUT steal, jangan abort. Nahan farming tanpa batas gara-gara
        -- satu konfirmasi yang gak dateng itu lebih buruk daripada sekali tween yang
        -- kurang mulus -- dan siklus berikutnya bakal nyoba lagi.
        warn("[Treadmill] Lepas treadmill gak kekonfirmasi dalam " .. UNMOUNT_CONFIRM_TIMEOUT .. "s, steal dilanjut apa adanya.")
        return false
    end

    task.wait(UNMOUNT_SETTLE_DELAY)
    return true
end

local function setupAntiTreadmillMount()
    local ok, err = pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Network = require(ReplicatedStorage.Library.Client.Network)
        local Constants = require(ReplicatedStorage.Library.Globals.Constants)
        local Treadmills = Constants.NETWORK_MAP.Treadmills

        Network.Fired(Treadmills.ACTIVE_TREADMILL_EVENT):Connect(function(treadmillId)
            -- CATAT DULU, cek toggle BELAKANGAN. Urutannya kebalik di versi lama
            -- (`if treadmillId == nil then return end` sebelum apa pun dicatat), dan itu
            -- yang bikin state kita bohong: mount yang kejadian pas toggle OFF gak pernah
            -- kecatat, jadi nyalain toggle setelahnya gak ngapa-ngapain dan karakter
            -- nyangkut mounted tanpa batas waktu.
            treadmillActiveId = treadmillId

            if treadmillId == nil then return end
            if not Config.AntiTreadmillMount then return end

            task.spawn(function()
                task.wait(0.05) -- Kasih waktu sepersekian detik biar state kesinkron server dulu
                if not Config.AntiTreadmillMount then return end -- Dicek ulang, siapa tau keburu dimatiin
                local uOk, uReason = requestTreadmillUnequip()
                if not uOk then
                    warn("[AntiTreadmill] Ke-detect ke-mount tapi gagal minta lepas:", uReason)
                end
            end)
        end)
    end)
    if not ok then
        warn("[AntiTreadmill] Gagal setup listener:", err)
    end
end
task.spawn(setupAntiTreadmillMount)

-- REKONSILIASI. Listener di atas cuma jalan pas ADA event. Yang gak ke-cover:
--   (a) script di-exec pas udah mounted -> gak ada event sejak exec
--   (b) event kelewat / listener belum kepasang pas event fire
-- Dua-duanya bikin karakter nyangkut mounted selamanya kalau cuma ngandelin event.
--
-- Probe sekali di startup, lalu re-sync JARANG (30s). Sengaja gak rapat: ini Invoke ke
-- server, dan event udah nutup hampir semua kasus -- ini cuma jaring pengaman.
task.spawn(function()
    task.wait(3) -- Biar listener + Config selesai settle dulu

    while true do
        -- PROBE-nya jalan TANPA peduli toggle, cuma AKSI-nya yang digate.
        --
        -- Kalau probe ikut digate Config.AntiTreadmillMount, ada celah: user matiin toggle
        -- itu (karena mau pakai treadmill), script di-exec/re-exec pas udah mounted, terus
        -- Auto Steal jalan -- `treadmillActiveId` masih nil karena gak ada event sejak exec
        -- dan probe-nya ke-skip, jadi ensureUnmountedBeforeSteal() nyangka kita gak mounted
        -- dan gak ngapa-ngapain. Probe-nya sendiri murah (1 invoke tiap 30 detik), jadi gak
        -- ada alasan bikin state kita sengaja buta.
        local mounted = readTreadmillMountedFromServer()
        if mounted ~= nil then
            -- Sinkronin state lokal ke kenyataan server, apa pun hasilnya.
            if not mounted then
                treadmillActiveId = nil
            elseif treadmillActiveId == nil then
                -- Server bilang mounted tapi kita gak tau -- persis kasus (a)/(b).
                treadmillActiveId = "unknown"
            end

            -- AKSI-nya baru digate: cuma turunin kalau user MEMANG gak mau ke-mount.
            if mounted and Config.AntiTreadmillMount then
                local uOk, uReason = requestTreadmillUnequip()
                if not uOk then
                    warn("[AntiTreadmill] Rekonsiliasi: ke-detect mounted tapi gagal minta lepas:", uReason)
                end
            end
        end
        task.wait(30)
    end
end)

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
        for _, model in ipairs(children) do
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
-- Generation counter buat koneksi Heartbeat "pin CFrame" di dalam satu percobaan steal.
-- Sengaja di scope FILE, bukan di dalam AutoStealLoop -- kalau ditaruh di dalem, tiap kali
-- Auto Steal di-OFF lalu di-ON lagi counter-nya mulai dari 0 lagi, dan pin BASI dari sesi
-- sebelumnya (yang kebetulan pegang angka sama) bakal ngira dirinya masih current. Di scope
-- file dia monotonic terus selama script hidup, jadi pin basi mana pun pasti kalah nomor.
local stealPinGeneration = 0

-- Area asal curi (AreaId egg liar-nya, misal "Cosmic"/"Forest") gak kebawa ke event claim
-- ("EggCmds.AreaEggClaimed" cuma ngasih Rarity/Position/Color/AssetCategory/DisplayName --
-- gak ada AreaId sama sekali), dan gak kesimpen juga di runtime record abis diklaim. Jadi
-- dicatat manual di sini tiap kali kita milih target, di-scope FILE (bukan lokal ke
-- AutoStealLoop) biar bisa dibaca dari webhook sender yang jauh di bawah -- keyed by
-- AssetCategory, sesuai pola matching yang udah dipakai getClaimedEggExtraInfo. Aproksimasi
-- (bukan per-UID exact) sama presisinya kayak lookup weight yang udah ada, konsisten sama
-- keterbatasan data yang sama.
local lastStealAreaByCategory = {}

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

    -- Directory.Assets dipakai buat lookup Rarity tiap record. DULU require-nya dipanggil
    -- DI DALAM loop per-record -- jadi kepanggil ulang buat SETIAP egg, SETIAP iterasi
    -- (~0.3s sekali). require() sendiri di-cache Roblox, tapi rantai game:GetService() +
    -- index + pemanggilan fungsinya tetep kejadian tiap record, dan di server rame
    -- (record-nya banyak) itu numpuk jadi kerjaan per-frame yang gak perlu -- kandidat
    -- kuat penyebab keluhan "tween berasa berat/lambat", karena yang ke-drag itu
    -- frame-nya, bukan rumus TweenMoveTo-nya. Sekarang sekali di sini, sejajar EggCmds.
    --
    -- Dibungkus pcall (versi lama gak) -- dulu kalau require ini throw, yang mati bukan
    -- cuma lookup rarity-nya tapi SELURUH AutoStealLoop, soalnya posisinya di body while
    -- yang gak ke-pcall. Sekarang paling jelek Assets == nil dan rarity jadi "Unknown".
    local successAssetsReq, Assets = pcall(function()
        return require(ReplicatedStorage.Directory.Assets)
    end)
    if not successAssetsReq then
        warn("[AutoSteal] Gagal require Directory.Assets, rarity semua egg dianggap Unknown:", Assets)
        Assets = nil
    end

    -- Lookup rarity satu record. Dipakai di dua tempat di bawah (egg yang udah kita bawa,
    -- dan kandidat target baru) -- dulu dua-duanya nulis rantai lookup yang sama persis.
    local function rarityOfRecord(record)
        local categoryData = Assets and Assets.Directory[record.AssetCategory]
        local rarityData = categoryData and categoryData.Rarity
        if not rarityData then return "Unknown" end
        return rarityData.DisplayName or rarityData._id or "Unknown"
    end

    -- Invincibility sekarang ditangani secara global oleh Zombie Mode di atas

    -- UID egg yang BARU AJA berhasil kita carry sendiri. Snapshot lokal (GetAreaEggSnapshot)
    -- kadang telat beberapa frame buat ngapus egg yang udah diklaim, jadi tanpa blacklist ini
    -- iterasi berikutnya bisa milih ulang egg yang barusan KITA sendiri ambil dan gagal carry
    -- (karena udah gak ada di server).
    local recentlyClaimedByMe = {}

    -- Dulu balik-ke-safezone-pas-idle ini jalan TIAP iterasi outer loop (~0.3-0.35 detik
    -- sekali) selama gak ada target -- efeknya character keukeuh ke-tarik balik ke safezone
    -- terus-terusan kalau kita coba gerakin manual pas AutoSteal lagi idle (gak nemu egg).
    -- Sekarang cuma sekali per "sesi idle": begitu udah nyampe/deket safezone, flag ini
    -- di-set true dan gak nge-tween lagi sampai ada target baru ketemu (flag direset).
    local hasSettledAtSafezoneWhileIdle = false

    -- AUTO TREADMILL WHEN IDLE. Dipakai ulang konsep "sesi idle" yang udah ada di atas,
    -- bukan bikin state baru dari nol.
    --
    -- Kenapa cuma pas idle LAMA, bukan tiap siklus steal: SpeedPower itu BANKED PERMANEN
    -- (WalkSpeed = fungsi turunan murni dari SpeedPower yang disimpen di Save, gak ada
    -- decay/reset pas unmount), dan kurvanya logaritmik ekstrem -- terukur langsung:
    -- 10x SpeedPower cuma beli +32 WalkSpeed, dan +1% SpeedPower = +0,14 WalkSpeed.
    -- Jadi waktu treadmill gak pernah HILANG, cuma tertunda, dan nilai marginal per
    -- detiknya nyaris nol. Satu siklus steal = orde 0,02-0,06 WalkSpeed.
    --
    -- Yang bikin re-mount tiap siklus JELEK bukan biaya waktunya (81 stud itu cuma ~0,2
    -- detik), tapi karena TIAP mount nembak Humanoid:UnequipTools() + matiin backpack GUI.
    -- Kalau Auto Sell Pet/Egg jalan bareng, re-mount tiap jeda idle aktif nyabotase dia.
    -- Jadi ini bug interaksi yang kita bikin sendiri, bukan cuma trade-off performa.
    -- Angka ini SATU-SATUNYA dial buat "seberapa cepat balik ke treadmill". Dulu 25 detik,
    -- diturunin ke 10 atas permintaan user (kelamaan nunggu pas semua kerjaan udah kelar).
    --
    -- 25 itu bukan angka hasil pengukuran -- itu tebakan konservatif pas fitur ini dibikin,
    -- dipilih buat jaga jarak dari churn mount/unmount. Gak ada batasan teknis yang maksa
    -- 25, jadi nurunin itu aman. Yang bikin nurunin ini gak berisiko besar: UnequipTools()
    -- cuma fire SEKALI pas mount, bukan terus-terusan selama mounted. Jadi satu sesi idle
    -- = satu gangguan ke Auto Sell, bukan gangguan berkelanjutan. Plus jalur sell sekarang
    -- udah self-correcting (re-check sebelum FireServer, dan egg yang gagal equip diulang
    -- siklus berikutnya).
    --
    -- KAPAN INI PERLU DINAIKIN LAGI: kalau kelihatan mount/unmount flapping -- yaitu target
    -- egg yang match rata-rata muncul dengan jarak MIRIP angka ini, jadi kita mount lalu
    -- kecabut lagi terus-terusan. Gejalanya: karakter bolak-balik safezone-treadmill tanpa
    -- henti. Kalau itu kejadian, naikin sampai di atas jeda antar-target yang biasa.
    local IDLE_BEFORE_TREADMILL = 10 -- detik nganggur sebelum boleh nyoba mount
    local idleTreadmillStartedAt = 0
    local hasTriedTreadmillThisIdleSession = false

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
            while settleWaited < 1 and Config.AutoSteal do
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

            -- Kalau kita UDAH bawa egg (misal abis toggle off/on di tengah carry), itu
            -- yang diprioritasin -- jangan malah cari target baru dan biarin yang di
            -- tangan nyangkut/keclaim orang lain.
            if eggSnapshot and eggSnapshot.Records then
                for _, record in pairs(eggSnapshot.Records) do
                    if record.State == "Carried" and record.CarrierUserId == LocalPlayer.UserId then
                        targetEgg = record
                        targetEgg.Rarity = rarityOfRecord(record)
                        break
                    end
                end
            end

            if not targetEgg and eggSnapshot and eggSnapshot.Records then
                local highestWeight = -1

                for _, record in pairs(eggSnapshot.Records) do
                    local area = record.AreaId

                    -- Lookup Rarity dari game data
                    local rarity = rarityOfRecord(record)

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
                                local weight = RarityWeights[rarity] or 0
                                if weight > highestWeight then
                                    highestWeight = weight
                                    targetEgg = record
                                    -- Ditempel ke record-nya, bukan cuma dipakai lokal: Auto Sell
                                    -- Egg baca `record.Rarity` sebagai FALLBACK kalau lookup dia
                                    -- sendiri ke Directory.Assets gagal (lihat pemakaian
                                    -- `assetData.Rarity or record.Rarity`). Jangan dihapus.
                                    targetEgg.Rarity = rarity
                                end
                            end
                        end
                    end
                end

            -- Lakukan pencurian via CARRY + DROP (mekanisme resmi game)
            if targetEgg then
                -- Ada target lagi -> reset flag idle-settle, biar SESI IDLE BERIKUTNYA
                -- (kalau abis ini gak ada target lagi) dapet 1x kesempatan balik ke
                -- safezone yang fresh, bukan ke-skip terus karena flag lama masih true.
                hasSettledAtSafezoneWhileIdle = false
                idleTreadmillStartedAt = 0
                hasTriedTreadmillThisIdleSession = false

                -- Lepas dari treadmill SEBELUM apa pun. Nol biaya kalau kita gak mounted
                -- (early-return, kasus mayoritas). Alasan lengkapnya di komentar
                -- ensureUnmountedBeforeSteal -- singkatnya: mount nembak
                -- Humanoid:UnequipTools() + matiin backpack GUI, dan kalau itu kejadian di
                -- tengah carry, prosesnya gagal senyap. Yang dibutuhin jaminan URUTAN,
                -- bukan gerakan tambahan (tween ke egg toh mindahin kita keluar sendiri).
                --
                -- SENGAJA di ATAS `Config.IsStealing = true`: fungsi ini bisa nunggu sampai
                -- ~1.6 detik nungguin konfirmasi unmount, dan `IsStealing` itu yang nge-
                -- suppress Auto Place, Auto Sell, Auto Sell Egg, sticky re-carry, DAN
                -- velocity dampener. Gak ada gunanya nahan semua sistem itu selama kita
                -- belum ngapa-ngapain.
                ensureUnmountedBeforeSteal()

                Config.IsStealing = true

                -- Semua koneksi Heartbeat "pin CFrame" yang dibikin selama SATU percobaan steal
                -- didaftarin ke sini, dan dibersihin di SATU tempat abis pcall di bawah balik --
                -- sukses MAUPUN error.
                --
                -- BUG SEBELUMNYA: loopConn & safezoneConn cuma di-Disconnect di jalur normal yang
                -- posisinya DI DALAM pcall. Begitu ada error di antara Connect dan Disconnect
                -- (paling sering: karakter mati/respawn jadi hrp ke-Destroy, atau EggCmds throw),
                -- stack langsung unwind ke `if not success` di bawah dan koneksinya KETINGGALAN
                -- HIDUP -- terus nge-set hrp.CFrame ke posisi lama TIAP FRAME selamanya. Pin basi
                -- ini gak baca Config.AutoSteal, jadi dia GAK ikut mati pas toggle di-OFF-in --
                -- persis laporan player: "nyangkut di egg, gak ke-stole, pas Auto Steal di-OFF-in
                -- posisi malah nyantol di belakang egg".
                stealPinGeneration = stealPinGeneration + 1
                local myPinGeneration = stealPinGeneration
                local stealPinConns = {}

                local function trackStealPin(conn)
                    table.insert(stealPinConns, conn)
                    return conn
                end

                local function releaseStealPins()
                    for i = #stealPinConns, 1, -1 do
                        local conn = stealPinConns[i]
                        stealPinConns[i] = nil
                        pcall(function() conn:Disconnect() end)
                    end
                end

                -- Dipanggil di awal tiap callback pin. Dua lapis:
                -- (1) generation -- kalau ada pin yang somehow masih lolos ke frame berikutnya
                --     padahal percobaan steal-nya udah kelar, dia langsung diem.
                -- (2) hrp.Parent -- kalau karakter udah mati/respawn, hrp-nya instance yatim;
                --     nulis CFrame ke situ cuma bikin error spam tiap frame, gak ada gunanya.
                local function pinStillValid(hrp)
                    return myPinGeneration == stealPinGeneration and hrp.Parent ~= nil
                end

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

                    if targetEgg.AssetCategory and targetEgg.AreaId then
                        lastStealAreaByCategory[targetEgg.AssetCategory] = targetEgg.AreaId
                    end

                    -- BUG SEBELUMNYA: kita SELALU maksa bikin FirstAreaSlotKey (dari AreaId:NestId
                    -- atau regex fallback) buat SEMUA egg -- padahal dicek langsung dari source asli
                    -- game (AreaEggs.client.lua, function bindPrompt yang jalan pas real player mencet
                    -- prompt "Steal"), field ini CUMA boleh diisi buat egg yang UID-nya diawali
                    -- "FirstAreaEgg_" (dicek via AreaEggSlotIdentity.IsFirstAreaUid) -- buat SEMUA
                    -- egg biasa/liar lainnya (mayoritas target kita), field ini HARUS nil. Ngirim
                    -- key "ngarang" buat egg yang seharusnya nil itu yang bikin server nolak carry-nya
                    -- diam-diam ("kadang gak ke-carry" walau posisi udah bener) -- makanya sekarang
                    -- kita replikasi PERSIS logic aslinya, bukan nebak-nebak lagi.
                    -- Logic-nya PERSIS sama kayak yang dipakai sticky re-carry, jadi sekarang
                    -- dua-duanya manggil satu fungsi yang sama (computeFirstAreaSlotKey) --
                    -- dulu blok ini duplikat manual, dan require-nya diulang tiap percobaan
                    -- steal. Kalau aturan slot key ini berubah lagi, cukup edit satu tempat.
                    local firstAreaSlotKey = computeFirstAreaSlotKey(targetEgg.Uid, targetEgg.AreaId, targetEgg.NestId)

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
                    --
                    -- CATATAN: flag ini SENGAJA cuma boolean. Dulu dia nyimpen klasifikasi
                    -- ("claimed"/"lost"/"gaveup"/"cancelled") yang niatnya buat mutusin kapan
                    -- Server Hop dipicu -- tapi hop-nya sendiri gak pernah ada di script ini,
                    -- dan gak ada satu pun kode yang baca nilainya (cuma dipakai sebagai
                    -- kondisi keluar loop). Jadi bedain 4 nilai itu cuma bikin kelihatan ada
                    -- logic yang sebenernya gak jalan. Kalau nanti hop beneran diimplement,
                    -- klasifikasinya dibalikin BARENGAN sama consumer-nya, bukan duluan.
                    local outerAttempt = 0
                    -- Dinaikin dari 4 -> 12. Tiap kali Guard mukul dan egg-nya jatuh, itu makan
                    -- SATU outerAttempt. Dengan 4, cuma butuh 4 pukulan buat kita NYERAH dan
                    -- pindah ke egg lain -- padahal egg-nya masih di situ dan masih bisa diambil.
                    -- Itu persis gejala "jatuh berkali-kali, terus malah pindah ke egg lain".
                    local maxOuterAttempts = 12
                    local stealDone = false

                    while not stealDone do
                        outerAttempt = outerAttempt + 1
                        if stealCancelled() then
                            stealDone = true
                            break
                        end
                        if outerAttempt > maxOuterAttempts then
                            stealDone = true
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
                        if stealCancelled() then stealDone = true break end
                        -- pinPaused: dipakai buat "matiin sementara" pin CFrame di bawah TANPA
                        -- disconnect/reconnect koneksinya berkali-kali -- dipakai sama circuit
                        -- breaker jalan-beneran (lihat komentar di bawah), biar Humanoid:MoveTo()
                        -- gak langsung ke-timpa balik ke eggCF tiap frame sama pin ini.
                        local pinPaused = false
                        trackStealPin(game:GetService("RunService").Heartbeat:Connect(function()
                            if pinPaused then return end
                            if not pinStillValid(hrp) then return end
                            hrp.CFrame = eggCF
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            hrp.AssemblyAngularVelocity = Vector3.zero
                        end))

                        -- PENTING: dulu 0.6s (aman buat device lambat kayak Redfinger/cloud
                        -- Android, yang butuh waktu lebih buat CFrame-pin ke-replicate ke server
                        -- via Heartbeat sebelum carry-nya diterima), tapi user PC komplen delay-nya
                        -- kelamaan -- diturunin ke 0.4s atas keputusan user, no UI control lagi.
                        local settleDelay = tonumber(Config.ApproachSettleDelay)
                        if not settleDelay or settleDelay <= 0 then
                            settleDelay = 0.4
                        end
                        local approachWaited = 0
                        while approachWaited < settleDelay and not stealCancelled() do
                            task.wait(0.05)
                            approachWaited = approachWaited + 0.05
                        end
                        if stealCancelled() then
                            releaseStealPins()
                            stealDone = true
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
                                task.wait(0.05) -- Jeda antar request (dinaikin dikit dari 0.03 buat device lemot)
                            end

                            if stealCancelled() then
                                break
                            end

                            if not carryOk then
                                -- Cek State-nya, bukan cuma record-nya nil apa enggak. Pas orang
                                -- LAIN berhasil carry duluan, record-nya BELUM ilang -- State-nya
                                -- yang berubah jadi "Carried"/"GuardCarried" punya orang lain.
                                -- Tanpa cek State, egg yang udah jelas keduluan masih dianggap
                                -- available dan kita nungguin dia sampe max ronde sia-sia.
                                local freshRecord = EggCmds.GetAreaEggRecord(targetEgg.Uid)
                                eggStillThere = freshRecord ~= nil and (freshRecord.State == "Slot" or freshRecord.State == "Dropped")
                                if eggStillThere and freshRecord.BottomCFrame then
                                    eggCF = freshRecord.BottomCFrame * CFrame.new(0, 3, 0)
                                end
                                if eggStillThere and round < maxRounds then
                                    -- Balik lagi ke telur (BUKAN kabur ke safezone) & pin ulang posisinya.
                                    --
                                    -- BUG SEBELUMNYA (laporan Android/cloud device: keliatan "stuck",
                                    -- visual kita udah persis di egg tapi server belum nyampe, dan gak
                                    -- kunjung ke-pickup sampai Auto Steal di-OFF-in lalu di-ON-in lagi):
                                    -- re-tween ke eggCF yang SAMA PERSIS kayak posisi kita sekarang itu
                                    -- no-op buat TweenMoveTo (distance < 0.1 -> langsung snap ke CFrame
                                    -- yang IDENTIK dgn yang udah ada) -- gak ada gerakan BENERAN yang
                                    -- bisa dipakai jaringan buat re-sync posisi kita ke server. Kalau
                                    -- pin pertama emang belum sempet ke-replicate (device lambat), ngulang
                                    -- nge-set CFrame yang sama terus gak nolong sama sekali.
                                    -- Fix: nudge dulu ke titik yang BEDA (sedikit di atas egg) baru balik
                                    -- ke eggCF -- jaraknya >0.1 mastiin TweenMoveTo BENERAN gerak (bukan
                                    -- snap no-op), ngasih server sampel posisi baru yang jelas buat
                                    -- kekejar/kesinkron ulang.
                                    TweenMoveTo(hrp, hum, eggCF * CFrame.new(0, 2, 0), stealCancelled)
                                    if stealCancelled() then break end
                                    TweenMoveTo(hrp, hum, eggCF, stealCancelled)
                                    if stealCancelled() then break end

                                    -- CIRCUIT BREAKER (tiap ronde ke-3): nudge CFrame di atas itu tetep
                                    -- SATU teknik replikasi doang (Property CFrame di-set manual). Kalau
                                    -- device-nya emang lagi bermasalah spesifik sama jalur itu, ngulang
                                    -- teknik yang sama berkali-kali ya tetep kena masalah yang sama.
                                    -- Humanoid:MoveTo() itu JALUR REPLIKASI YANG TOTAL BEDA -- gerakan
                                    -- jalan biasa yang dipakai JUTAAN pemain normal tiap hari (paling
                                    -- teruji di Roblox), gak lewat CFrame-snap sama sekali. Selipin ini
                                    -- sesekali sebagai jalur alternatif kalau CFrame-pin doang kurang
                                    -- reliable di device tertentu -- pin CFrame DIPAUSE sementara (biar
                                    -- gak langsung ketimpa balik ke eggCF tiap frame) selama jalan ini
                                    -- berlangsung, max nunggu 1 detik.
                                    if round % 3 == 0 then
                                        pcall(function()
                                            pinPaused = true
                                            hum:MoveTo(eggCF.Position)
                                            local moved = false
                                            local moveConn = hum.MoveToFinished:Connect(function()
                                                moved = true
                                            end)
                                            local walkWaited = 0
                                            while not moved and walkWaited < 1 and not stealCancelled() do
                                                task.wait(0.05)
                                                walkWaited = walkWaited + 0.05
                                            end
                                            moveConn:Disconnect()
                                        end)
                                        pinPaused = false
                                        if stealCancelled() then break end
                                    end
                                    -- Progressive backoff: makin banyak ronde gagal, makin lama nunggu
                                    -- sebelum ronde berikutnya (0.15s, 0.25s, 0.35s ... maks 0.6s).
                                    -- Kalau device-nya lambat (Redfinger dkk), round 1-2 emang belum
                                    -- cukup -- ronde berikutnya ngasih waktu lebih biar server sempet
                                    -- kejar replikasi posisi kita, tanpa bikin PC yang udah cepat jadi
                                    -- lambat (mereka biasanya kelar di ronde 1-2 juga).
                                    task.wait(math.min(0.15 + (round - 1) * 0.1, 0.6))
                                end
                            end
                        until carryOk or not eggStillThere or round >= maxRounds

                        -- Pin egg udah gak dibutuhin lagi -- lepas SEKARANG, jangan nunggu
                        -- cleanup abis pcall, biar karakter bebas gerak buat step berikutnya.
                        -- Registry-nya ikut dikosongin, jadi cleanup di bawah gak dobel kerja.
                        releaseStealPins()
                        end

                        if stealCancelled() then
                            stealDone = true
                            break
                        end

                        if not carryOk then
                            if eggStillThere then
                                -- Masih ada tapi udah nyerah abis max ronde -- diem di dekat telur,
                                -- JANGAN balik ke safezone. Iterasi loop utama berikutnya otomatis
                                -- coba lagi (egg ini masih match) atau ganti target kalau udah gak match.
                                stealDone = true
                            else
                                -- Beneran udah keduluan orang lain -- JANGAN balik ke safezone dulu.
                                -- Biarin diem di sini; iterasi loop utama berikutnya (di bawah, cuma
                                -- 0.05s lagi) langsung scan ulang & kalau ketemu egg lain yang masih
                                -- match filter, TweenMoveTo bakal langsung narik kita dari posisi
                                -- SEKARANG ini ke egg baru itu -- gak perlu muter dulu ke safezone.
                                -- Safezone cuma didatengin kalau scan berikutnya BENERAN gak nemu
                                -- target sama sekali (lihat cabang "else" di bawah, di luar pcall ini).
                                stealDone = true
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
                            -- 0.15 -> 0.05: makin cepat kita sadar egg-nya jatuh, makin cepat
                            -- bisa diklaim ulang. 0.15 itu bisa ketinggalan ~3 frame sebelum
                            -- kita bahkan MULAI bereaksi.
                            if now - lastDropCheckAt < 0.05 then
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

                            -- KLAIM ULANG SEKETIKA, SEBELUM balik ke outer loop.
                            -- Pas Guard mukul, egg jatuh PERSIS di kaki kita -- jadi syarat jarak
                            -- ke server kemungkinan besar masih terpenuhi DI DETIK ITU JUGA.
                            -- Kalau kita nunggu jalur normal (balik ke outer loop -> tween ke egg
                            -- -> ApproachSettleDelay -> baru request), jedanya cukup buat kita
                            -- kedorong menjauh atau egg keduluan orang lain.
                            -- Nembak beberapa kali beruntun karena satu request tunggal sering
                            -- jatuh pas server masih proses knockback-nya.
                            for _ = 1, 3 do
                                if stealCancelled() then break end
                                local okNow = false
                                pcall(function()
                                    okNow = EggCmds.RequestCarryAreaEgg(targetEgg.Uid, firstAreaSlotKey) == true
                                end)
                                if okNow then
                                    -- Ke-carry lagi -> lanjutin perjalanan, gak usah balik ke awal.
                                    droppedAgain = false
                                    confirmedCarrying = true
                                    return false
                                end
                                task.wait(0.05)
                            end

                            return true
                        end

                        TweenMoveTo(hrp, hum, safezoneCF, abortTripIfDropped)

                        if stealCancelled() then
                            stealDone = true
                            break
                        end

                        if droppedAgain then
                            -- Lanjut ke outerAttempt berikutnya di while loop
                        else
                            trackStealPin(game:GetService("RunService").Heartbeat:Connect(function()
                                if not pinStillValid(hrp) then return end
                                hrp.CFrame = safezoneCF
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                hrp.AssemblyAngularVelocity = Vector3.zero
                            end))

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

                            releaseStealPins()

                            if stealCancelled() then
                                stealDone = true
                                break
                            end

                            if claimWaited >= maxClaimWait then
                                -- Double-check sebelum nyerah nunggu: mungkin kena pukul PAS
                                -- lagi nunggu klaim di safezone (bukan pas di perjalanan).
                                local rec = EggCmds.GetAreaEggRecord(targetEgg.Uid)
                                if rec == nil then
                                    stealDone = true
                                elseif rec.State ~= "Carried" or rec.CarrierUserId ~= LocalPlayer.UserId then
                                    if rec.BottomCFrame then
                                        eggCF = rec.BottomCFrame * CFrame.new(0, 3, 0)
                                    end
                                    -- Lanjut ke outerAttempt berikutnya di while loop
                                else
                                    stealDone = true
                                end
                            else
                                stealDone = true
                            end
                        end
                    end

                end)

                -- WAJIB duluan sebelum apa pun: kalau pcall di atas mati di tengah jalan,
                -- INI satu-satunya yang nyabut pin CFrame yang ketinggalan nyala. Naikin
                -- generation-nya juga, biar pin yang somehow masih kepanggil di frame yang
                -- sama langsung diem sendiri lewat pinStillValid().
                stealPinGeneration = stealPinGeneration + 1
                releaseStealPins()

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

                -- AUTO TREADMILL WHEN IDLE -- cuma abis nganggur BENERAN lama.
                -- Timer-nya mulai dihitung dari saat udah settle di safezone, bukan dari
                -- iterasi pertama tanpa target: kalau dihitung dari awal, tween balik ke
                -- safezone masih jalan pas timer-nya lewat.
                if Config.AutoTreadmillIdle and not Config.AntiTreadmillMount then
                    if idleTreadmillStartedAt == 0 then
                        idleTreadmillStartedAt = os.clock()
                    elseif not hasTriedTreadmillThisIdleSession
                        and (os.clock() - idleTreadmillStartedAt) >= IDLE_BEFORE_TREADMILL
                        and treadmillActiveId == nil
                    then
                        -- Sekali per sesi idle. Kalau gagal (treadmill gak ketemu, atau
                        -- raycast gak nge-trigger), JANGAN diulang-ulang tiap 0.3 detik --
                        -- nunggu sesi idle berikutnya. Flag-nya direset pas ada target lagi.
                        hasTriedTreadmillThisIdleSession = true
                        pcall(function()
                            local stand = findMyTreadmillStandPart()
                            if not stand or not hrp then return end
                            -- Mount-nya diserahin ke raycast natural game (turun 8 stud dari
                            -- HRP tiap Heartbeat) -- kita cuma perlu naruh karakter di
                            -- titiknya. Root itu posisi yang persis ditempatin karakter pas
                            -- mounted, terverifikasi live.
                            TweenMoveTo(hrp, hum, CFrame.new(stand.Position), function()
                                -- Batalin SEKARANG kalau ada target egg muncul di tengah
                                -- jalan, atau toggle-nya dimatiin. Farming selalu menang
                                -- dari latihan treadmill.
                                return not Config.AutoSteal or not Config.AutoTreadmillIdle or Config.IsStealing
                            end)
                        end)
                    end
                end

                task.wait(0.3)
            end
        end
        task.wait(0.05)
    end
end

-- WATCHDOG: AutoStealLoop() dulu langsung di-task.spawn mentah-mentah -- kalau ada satu
-- baris di dalemnya yang error TANPA ke-pcall (misal edge-case data egg aneh di luar
-- pcall besar buat proses carry-nya), seluruh coroutine loop-nya MATI PERMANEN sementara
-- Config.AutoSteal & toggle-nya masih keliatan ON -- user ngerasa Auto Steal "stuck"/
-- gak jalan lagi dan cuma pulih kalau toggle-nya di-OFF-in lalu di-ON-in manual (itu yang
-- bikin coroutine BARU). StartAutoStealLoop() gantiin task.spawn(AutoStealLoop) langsung --
-- mbungkus AutoStealLoop() sendiri pakai pcall, dan kalau ternyata error/berhenti sendiri
-- padahal Config.AutoSteal masih true, langsung di-restart otomatis abis jeda singkat --
-- gak perlu campur tangan manual lagi.
local function StartAutoStealLoop()
    task.spawn(function()
        while Config.AutoSteal do
            local ok, err = pcall(AutoStealLoop)
            if not ok then
                warn("[AutoSteal] Loop berhenti gara-gara error, auto-restart:", err)
            end
            if Config.AutoSteal then
                task.wait(0.5) -- Jeda singkat sebelum restart, jaga-jaga errornya nge-loop cepet
            end
        end
    end)
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
            StartAutoStealLoop()
        elseif not val then
            Config.IsStealing = false
        end
    end
})

local tweenSpeedInput
-- NONAKTIF -- dulu ngatur speed = WalkSpeed x multiplier ini. Dicabut karena speed
-- lebih dari WalkSpeed asli bikin server diam-diam nolak carry request (lihat komentar
-- di TweenMoveTo). Config.TweenSpeedMultiplier masih ditulis di sini biar gak error,
-- tapi NOL kode lain yang bacanya lagi -- input ini murni gak ngefek apa-apa sekarang.
-- Sengaja gak dihapus (bukan didisable) biar Config JSON lama yang masih nyimpen field
-- ini tetep kebaca tanpa migrasi.
tweenSpeedInput = FarmSection:AddInput({
    Title = "Move Speed Multiplier (Nonaktif)",
    Content = "Sudah gak ngefek -- speed gerak sekarang selalu ngikutin WalkSpeed asli karaktermu di game (naikkan lewat treadmill/upgrade kalau mau lebih cepat).",
    Default = tostring(Config.TweenSpeedMultiplier),
    Callback = function(val)
        -- AddInput ngirim RAW STRING pas FocusLost, gak ada clamp bawaan kayak Slider --
        -- makanya clamp manual di sini. Kalau ketik bukan angka, pertahanin nilai lama
        -- (bukan nil/error) biar Config.TweenSpeedMultiplier gak pernah invalid.
        local num = tonumber(val)
        if not num then
            num = Config.TweenSpeedMultiplier
        end
        Config.TweenSpeedMultiplier = math.clamp(num, 1, 10)
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

-- FORWARD DECLARATION -- WAJIB di atas kedua loop sell di bawah.
-- Dropdown-nya sendiri baru dibikin jauh di bawah (butuh SellSection/SellEggSection dan
-- daftar opsinya), tapi loop sell harus bisa BACA objeknya buat ngambil filter live
-- lewat readDropdownFilter(). Kalau deklarasi local-nya ditaruh di bawah kayak sebelumnya,
-- referensi di dalam fungsi loop ini ke-resolve ke GLOBAL (nil) gara-gara lexical scoping
-- Lua -- fail-safe-nya bakal ke-trigger terus dan sell gak akan pernah jalan. Ini kejadian
-- yang sama persis kayak yang dikomentarin di blok ANTI GUARD KNOCKBACK soal `local Config`.
local sellNamesDropdown
local sellRarityDropdown
local sellEggRarityDropdown

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

        -- Set uid pet yang LAGI DIPAJANG di plot. Balikin nil kalau gak bisa diverifikasi --
        -- pemanggil WAJIB nganggep nil sebagai "jangan jual", bukan "anggap kosong".
        -- Sumbernya sama dengan yang dipakai game sendiri (AssetCmds.GetOwnerRuntimeRecords).
        local function readPlacedUids()
            local ok, runtimeRecords = pcall(function()
                return AssetCmds.GetOwnerRuntimeRecords(LocalPlayer.UserId)
            end)
            if not ok or type(runtimeRecords) ~= "table" then return nil end

            local placed = {}
            for key, rec in pairs(runtimeRecords) do
                if type(key) == "string" then placed[key] = true end
                if type(rec) == "table" and rec.UID then placed[rec.UID] = true end
            end
            return placed
        end

        -- Izin jual untuk SATU pet, divalidasi ULANG tepat sebelum aksi yang gak bisa
        -- di-undo. Daftar kandidat disusun di awal siklus, tapi antara itu sampai tiap
        -- FireServer ada YIELD (EquipTool + task.wait) -- di jendela itu user bisa matiin
        -- toggle, nyempitin filter, atau nge-favorite pet buat nyelametin dia. Ngecek
        -- sekali di awal batch gak nutup itu: tiap penjualan irreversible sendiri-sendiri,
        -- jadi tiap penjualan butuh izinnya sendiri.
        --
        -- Balikin: ok, alasan, scope
        --   scope "global" -> alasannya berlaku buat SELURUH sisa batch (stop total)
        --   scope "pet"    -> cuma pet ini yang gak boleh (lanjut ke pet berikutnya)
        local function stillSellablePet(entry, placedNow)
            if not Config.AutoSell then return false, "toggle Auto Sell Pet udah OFF", "global" end
            if Config.IsStealing then return false, "Auto Steal lagi megang kendali", "global" end

            local namesNow = readDropdownFilter(sellNamesDropdown)
            local raritiesNow = readDropdownFilter(sellRarityDropdown)
            if not namesNow or not raritiesNow then
                return false, "filter dropdown gak bisa dibaca", "global"
            end

            if type(placedNow) ~= "table" then
                return false, "status pet dipajang gak bisa diverifikasi", "global"
            end

            if placedNow[entry.uid] then
                return false, "pet ini dipajang di plot", "pet"
            end

            if not petMatchesSellFilter(entry.petName, entry.rarity, namesNow, raritiesNow) then
                return false, "pet ini udah gak match filter yang sekarang", "pet"
            end

            -- Baca ulang record-nya, bukan pakai salinan dari awal siklus. Selain nangkep
            -- pet yang baru di-favorite user di tengah batch, ini juga nyegah nembak sell
            -- ke uid yang udah kejual (record-nya udah ilang dari inventory).
            local sv = Save.Get()
            local rec = sv and sv.Inventory and sv.Inventory[entry.uid]
            if rec == nil then
                return false, "pet ini udah gak ada di inventory", "pet"
            end
            if rec.IsFavorite == true then
                return false, "pet ini di-favorite", "pet"
            end

            return true
        end

        -- Loop-nya cuma hidup/mati lewat AutoSell -- SellAll SENGAJA gak dipake sebagai
        -- kondisi loop lagi. Sebelumnya "or Config.SellAll" bikin toggle "Auto Sell All
        -- Pet" bisa nahan loop ini idup SENDIRI, kebal total dari toggle "Auto Sell Pet"
        -- utama (matiin itu gak ngaruh apa-apa selama SellAll masih nyala) -- dan karena
        -- SellAll juga bikin match=true buat SEMUA pet (skip filter rarity/nama), efeknya
        -- "gak sengaja pencet SellAll -> jualan semua pet, gak bisa distop dari mana pun".
        -- SellAll sekarang MURNI modifier (bypass filter) yang cuma berlaku SELAGI AutoSell
        -- nyala -- persis kayak warning text-nya sendiri di UI ("If Auto Sell is ON...").
        while Config.AutoSell do
            local success, err = pcall(function()
                if Config.IsStealing then return end

                        -- FILTER DIBACA LIVE DARI DROPDOWN, BUKAN DARI Config.
                        -- Config.SellNames/SellRarities cuma keisi lewat Callback dropdown,
                        -- dan Callback itu BISA GAK PERNAH JALAN (lihat readDropdownFilter).
                        -- Pas itu kejadian, cache-nya nyangkut di filter LAMA dan kita tetep
                        -- jual barang yang user udah cabut dari filter -- inilah yang bikin
                        -- pet member kejual habis. Baca ulang tiap ronde, jangan pernah cache.
                        local sellNames = readDropdownFilter(sellNamesDropdown)
                        local sellRarities = readDropdownFilter(sellRarityDropdown)

                        -- FAIL-SAFE: gak bisa baca filter = JANGAN JUAL. Bukan "pakai nilai
                        -- terakhir yang diketahui" -- jual itu gak bisa di-undo, jadi kalau
                        -- kita gak tau batasannya, satu-satunya pilihan aman adalah berhenti.
                        if not sellNames or not sellRarities then
                            warn("[AutoSell] Filter dropdown gak bisa dibaca -- ronde ini di-SKIP, gak ada yang dijual. Kalau ini terus-terusan, matiin Auto Sell Pet dan lapor.")
                            return
                        end

                        -- Menggunakan Save.Get().Inventory (struktur flat dictionary: [uid] = record)
                        local mySave = Save.Get()
                        local myInventory = mySave and mySave.Inventory or {}

                        -- PET YANG LAGI DIPAJANG DI PLOT -- sumber yang BENERAN dipakai game.
                        --
                        -- BUG SEBELUMNYA (ini yang bikin kerusakannya total): status equip
                        -- dicek pakai `record.Equipped or record.IsEquipped or record._eq or
                        -- table.find(Save.EquippedAssets, uid)`. Aku dump schema record
                        -- inventory yang ASLI di game ini -- field-nya cuma: Category, Scale,
                        -- Gender, ColorIndex, ColorSeed, EyeColor, Personality, Mutations,
                        -- BaseMutation, InFuse, IsFavorite, HasBeenFirstPlaced. `Equipped`,
                        -- `IsEquipped`, `_eq` SEMUANYA GAK ADA, dan `Save.EquippedAssets`
                        -- selalu tabel KOSONG. Jadi keempat-empatnya nil/false SELALU ->
                        -- `isEquipped` selalu false -> guard "jangan jual yang dipajang" itu
                        -- GAK PERNAH nge-block apa pun sejak awal. Begitu filter nyasar,
                        -- pet yang lagi ngehasilin duit di plot ikut kejual.
                        --
                        -- Sumber yang bener: AssetCmds.GetOwnerRuntimeRecords(userId) --
                        -- ini yang dipakai game sendiri buat nentuin "punya pet dipajang"
                        -- (lihat GuardTutorialController.MilestoneAdapter: `_hadPlacedPet =
                        -- next(AssetCmds.GetOwnerRuntimeRecords(LocalPlayer.UserId)) ~= nil`).
                        -- Detail bentuk record-nya ada di komentar readPlacedUids() di atas.
                        local placedUids = readPlacedUids()

                        -- FAIL-SAFE kedua: gak bisa verifikasi mana yang dipajang = JANGAN JUAL.
                        if not placedUids then
                            warn("[AutoSell] Status pet yang dipajang gak bisa diverifikasi -- ronde ini di-SKIP, gak ada yang dijual.")
                            return
                        end

                        -- Nyimpen petName & rarity sekalian, bukan cuma uid: re-check sebelum
                        -- nembak jadi gak perlu lookup Assets.Directory ulang per pet.
                        local petsToSell = {}

                        if type(myInventory) == "table" then
                            for uid, record in pairs(myInventory) do
                                if type(record) == "table" then
                                    -- Dipajang di plot -> JANGAN dijual. Sumbernya runtime
                                    -- record dari game, bukan field tebakan di record inventory.
                                    local isPlaced = placedUids[uid] == true

                                    -- Cek status favorit (mendukung berbagai nama dari localization / atribut)
                                    local isFavorite = record.IsFavorite == true or record["Jadikan Favorit"] == true or record["Favorite"] == true
                                    
                                    -- Asset ID di data inventory PS99 / Steal an Egg disimpan di .Category
                                    local assetId = record.Category or record.id or record.AssetCategory or record.ItemId
                                    local categoryData = assetId and Assets.Directory[assetId]
                                    
                                    local petName = categoryData and (categoryData.DisplayName or categoryData._id or categoryData.Name) or "Unknown"
                                    local rarityObj = categoryData and categoryData.Rarity
                                    local rarity = rarityObj and (rarityObj.DisplayName or rarityObj._id or rarityObj.Name) or "Unknown"
                                    
                                    -- Aturan match-nya dipanggil dari helper yang SAMA yang
                                    -- dipakai stillSellablePet() di bawah -- jangan pernah
                                    -- ditulis ulang di sini, itu yang bikin dua sisi drift.
                                    local match = petMatchesSellFilter(petName, rarity, sellNames, sellRarities)

                                    if match and not isFavorite and not isPlaced then
                                        table.insert(petsToSell, { uid = uid, petName = petName, rarity = rarity })
                                    end
                                end
                            end
                        end
                        
                        if #petsToSell > 0 then

                            -- Jika mode Ignore Filter aktif, gunakan SellAllAssets agar langsung bersih 1 tas (sangat cepat)
                            -- Jika tidak (pakai filter), gunakan loop individual SellAsset
                            if Config.SellAll then
                                local EventAll = ReplicatedStorage.Network:FindFirstChild("AssetInventory: SellAllAssets")
                                if EventAll then
                                    -- Satu panggilan tunggal, jadi granularity per-pet gak
                                    -- relevan di sini -- tapi kalau toggle udah OFF antara
                                    -- batch disusun dan detik ini, jangan tembak sama sekali.
                                    if Config.AutoSell and not Config.IsStealing then
                                        local allUids = {}
                                        for _, entry in ipairs(petsToSell) do
                                            table.insert(allUids, entry.uid)
                                        end
                                        EventAll:FireServer(allUids)
                                    end
                                else
                                    warn("Auto Sell Error: Remote SellAllAssets tidak ditemukan di Network!")
                                end
                            else
                                local EventSell = ReplicatedStorage.Network:FindFirstChild("AssetInventory: SellAsset")
                                if EventSell then
                                    for _, entry in ipairs(petsToSell) do
                                        -- IZIN #1 -- sebelum ngapa-ngapain buat pet ini. Selain
                                        -- nyetop tepat waktu, ini juga nyegah ngequip pet yang
                                        -- toh gak akan dijual.
                                        local placedNow = readPlacedUids()
                                        local okNow, reasonNow, scopeNow = stillSellablePet(entry, placedNow)
                                        if not okNow then
                                            warn("[AutoSell] Gak jual " .. tostring(entry.petName) .. " -- " .. tostring(reasonNow))
                                            if scopeNow == "global" then break end
                                            continue
                                        end

                                        -- Di game ini, pet sudah berupa Tool di dalam Backpack.
                                        -- Kita hanya perlu mencari Tool dengan attribute UID yang cocok lalu meng-equip-nya
                                        local char = LocalPlayer.Character
                                        local hum = char and char:FindFirstChildOfClass("Humanoid")
                                        if char and hum then
                                            local foundTool = nil
                                            for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                                                if tool:IsA("Tool") and tool:GetAttribute("UID") == entry.uid then
                                                    foundTool = tool
                                                    break
                                                end
                                            end
                                            if not foundTool then
                                                for _, tool in ipairs(char:GetChildren()) do
                                                    if tool:IsA("Tool") and tool:GetAttribute("UID") == entry.uid then
                                                        foundTool = tool
                                                        break
                                                    end
                                                end
                                            end

                                            if foundTool then
                                                hum:EquipTool(foundTool)
                                                task.wait(0.05) -- Jeda super singkat (hanya beberapa frame)
                                            end
                                        end

                                        -- IZIN #2 -- WAJIB, jangan dihapus karena "udah dicek di
                                        -- atas". EquipTool + task.wait(0.05) di atas itu YIELD:
                                        -- user bisa matiin toggle / nyempitin filter / nge-favorite
                                        -- pet ini PERSIS di jendela itu. Ini cek terakhir sebelum
                                        -- aksi yang gak bisa ditarik balik.
                                        local placedPreFire = readPlacedUids()
                                        local okFire, reasonFire, scopeFire = stillSellablePet(entry, placedPreFire)
                                        if not okFire then
                                            warn("[AutoSell] Batal di detik terakhir, gak jual " .. tostring(entry.petName) .. " -- " .. tostring(reasonFire))
                                            if scopeFire == "global" then break end
                                            continue
                                        end

                                        EventSell:FireServer({entry.uid})
                                        task.wait(0.05) -- Jeda super singkat antar penjualan
                                    end
                            else
                                warn("Auto Sell Error: Remote SellAsset tidak ditemukan di Network!")
                            end
                            end
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
                
                -- Sama kayak Auto Sell Pet: filter dibaca LIVE dari dropdown, dan kalau gak
                -- kebaca kita BERHENTI, bukan lanjut pakai cache lama. Alasan lengkapnya ada
                -- di komentar readDropdownFilter.
                local sellEggRarities = readDropdownFilter(sellEggRarityDropdown)
                if not sellEggRarities then
                    warn("[AutoSellEgg] Filter rarity gak bisa dibaca -- ronde ini di-SKIP, gak ada yang dijual.")
                    return
                end

                local myEggs = EggCmds.GetOwnerRuntimeRecords(LocalPlayer.UserId)
                local uidsToSell = {}

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

                            -- Helper yang sama dipakai lagi di re-check sebelum FireServer.
                            local rarityMatch = eggMatchesSellFilter(rarity, sellEggRarities)

                            if rarityMatch and not isFavorite and not isEquipped then
                                table.insert(uidsToSell, { uid = uid, rarity = rarity })
                            end
                        end
                    end
                end
                
                if #uidsToSell > 0 then
                    local EventSell = ReplicatedStorage.Network:FindFirstChild("AssetInventory: SellAsset")
                    if EventSell then
                        local soldCount = 0
                        for _, entry in ipairs(uidsToSell) do
                            if not Config.AutoSellEgg then break end
                            if Config.IsStealing then break end

                            local eqSuccess, eqErr = EggCmds.RequestEquipTool(entry.uid)

                            if eqSuccess then
                                task.wait(0.15)

                                -- RE-CHECK sebelum aksi yang gak bisa ditarik balik.
                                -- `task.wait(0.15)` di atas itu YIELD -- di jendela itu user
                                -- bisa nyempitin filter atau nge-favorite egg ini. Daftar
                                -- kandidatnya disusun di awal siklus, jadi dia udah basi.
                                -- Check toggle/IsStealing di atas SENGAJA dibiarin apa adanya.
                                local raritiesNow = readDropdownFilter(sellEggRarityDropdown)

                                local freshRec = nil
                                local okFresh, freshAll = pcall(function()
                                    return EggCmds.GetOwnerRuntimeRecords(LocalPlayer.UserId)
                                end)
                                if okFresh and type(freshAll) == "table" then
                                    freshRec = freshAll[entry.uid]
                                end

                                local blockReason = nil
                                if not raritiesNow then
                                    blockReason = "filter rarity gak bisa dibaca"
                                elseif not okFresh then
                                    blockReason = "record egg gak bisa dibaca ulang"
                                elseif freshRec == nil then
                                    blockReason = "egg-nya udah gak ada"
                                elseif freshRec.IsFavorite == true then
                                    blockReason = "egg-nya di-favorite"
                                elseif freshRec.Placement ~= nil then
                                    blockReason = "egg-nya dipajang di plot"
                                elseif not eggMatchesSellFilter(entry.rarity, raritiesNow) then
                                    blockReason = "udah gak match filter yang sekarang"
                                end

                                if blockReason then
                                    warn("[AutoSellEgg] Batal jual egg " .. tostring(entry.rarity) .. " -- " .. blockReason)
                                else
                                    EventSell:FireServer({entry.uid})
                                    soldCount = soldCount + 1
                                    task.wait(0.1)
                                end
                            end
                        end
                    else
                        warn("Auto Sell Egg Error: Remote SellAsset tidak ditemukan!")
                    end
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
        -- Murni modifier, JANGAN startAutoSellLoop() di sini -- toggle ini gak boleh bisa
        -- nyalain/nahan loop sendirian. Nyalain "Auto Sell Pet" yang jadi satu-satunya
        -- switch buat loop-nya idup/mati (lihat komentar di startAutoSellLoop).
        Config.SellAll = val
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
                        -- BUG SEBELUMNYA: retry-nya pakai `waited >= 5 and waited % 5 < 0.6`.
                        -- `waited` naik per 0.5, jadi DUA nilai lolos tiap window: 5.0 (0 < 0.6)
                        -- DAN 5.5 (0.5 < 0.6) -- sama di 10.0/10.5. Jadi request gift-nya ke-fire
                        -- DOBEL tiap kali retry, bukan sekali. Selain buang remote call, itu
                        -- gampang kebaca server sebagai spam. Sekarang pakai jadwal eksplisit.
                        local nextRetryAt = 5
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
                            if waited >= nextRetryAt then
                                nextRetryAt = waited + 5
                                pcall(function() remote:InvokeServer(targetPlayer.UserId) end)
                            end
                        end
                    end
                end
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
-- Shared -- dipake webhook (Value field) sama Egg ESP, biar format angkanya konsisten
-- di dua tempat (satu fungsi, bukan disalin dua kali).
local function formatMoneyShort(n)
    n = math.floor(n + 0.5)
    if n >= 1e9 then return string.format("%.2fB", n / 1e9) end
    if n >= 1e6 then return string.format("%.2fM", n / 1e6) end
    if n >= 1e3 then return string.format("%.1fK", n / 1e3) end
    return tostring(n)
end

local knownEggUids = {}
pcall(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds)
    local myEggs = EggCmds.GetOwnerRuntimeRecords(LocalPlayer.UserId)
    if type(myEggs) == "table" then
        for uid in pairs(myEggs) do knownEggUids[uid] = true end
    end
end)

-- Weight, Scale, sama rate $/detik semuanya dihitung dari record runtime yang SAMA (satu
-- lookup, bukan tiga) -- pola pencariannya identik kayak yang lama (cocokin AssetCategory
-- ke egg yang belum ke-tandain "known"). Area diambil terpisah dari lastStealAreaByCategory
-- (lihat komentar di deklarasinya) karena runtime record gak nyimpen AreaId sama sekali.
local function getClaimedEggExtraInfo(feedback)
    local ok, result = pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds)
        local EggItemUtil = require(ReplicatedStorage.Library.Util.EggItemUtil)
        local AssetGenerationUtil = require(ReplicatedStorage.Library.Util.AssetGenerationUtil)

        for attempt = 1, 10 do
            local myEggs = EggCmds.GetOwnerRuntimeRecords(LocalPlayer.UserId)
            if type(myEggs) == "table" then
                for uid, record in pairs(myEggs) do
                    if not knownEggUids[uid] and record.AssetCategory == feedback.AssetCategory then
                        for uid2 in pairs(myEggs) do knownEggUids[uid2] = true end

                        local weightOk, weightKg = pcall(function() return EggItemUtil.GetWeightKg(record) end)
                        local rateOk, ratePerSec = pcall(function()
                            return AssetGenerationUtil.GetBaseRateMutationOnly({
                                Category = record.AssetCategory,
                                Mutations = record.Mutations or {},
                                Scale = record.AssetScale or 1
                            })
                        end)

                        return {
                            WeightKg = weightOk and weightKg or nil,
                            Scale = record.AssetScale,
                            RatePerSec = rateOk and ratePerSec or nil,
                            AreaId = lastStealAreaByCategory[feedback.AssetCategory]
                        }
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

            local extra = getClaimedEggExtraInfo(feedback) or {}

            local weightText = "Unknown"
            if type(extra.WeightKg) == "number" then
                weightText = string.format("%s Kg", tostring(math.floor(extra.WeightKg * 100 + 0.5) / 100))
            end

            local sizeText = "Unknown"
            if type(extra.Scale) == "number" then
                sizeText = string.format("%.2fx", extra.Scale)
            end

            local valueText = "Unknown"
            if type(extra.RatePerSec) == "number" then
                valueText = "$" .. formatMoneyShort(extra.RatePerSec) .. "/s"
            end

            local areaText = extra.AreaId and tostring(extra.AreaId) or "Unknown"

            local embed = {
                author = { name = LocalPlayer.Name, icon_url = getLocalPlayerAvatarUrl() },
                description = "### " .. tostring(displayName),
                color = colorDecimal,
                fields = {
                    { name = "Rarity", value = tostring(rarity), inline = true },
                    { name = "Pet Species", value = tostring(assetCategory or "Unknown"), inline = true },
                    { name = "Weight", value = weightText, inline = true },
                    { name = "Value", value = valueText, inline = true },
                    { name = "Size", value = sizeText, inline = true },
                    { name = "Area", value = areaText, inline = true }
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
    Title = "Auto Treadmill When Idle",
    Content = "Trains on your treadmill only after Auto Steal has been idle for a while. Needs Anti Treadmill Mount OFF.",
    Default = false,
    Callback = function(val)
        Config.AutoTreadmillIdle = val
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
-- EGG ESP -- nampilin nama pet, berat (Kg), value $/detik, sama mutasi (kalau ada) di atas egg
-- yang UDAH kita PLACE di plot sendiri (lagi tumbuh, belum di-hatch) -- BUKAN
-- egg liar di area. Semua angkanya dihitung dari formula ASLI game:
--   - Berat: EggItemUtil.GetWeightKg(record) -- formula resmi berdasarkan
--     AssetScale, dites live: variannya BESAR (misal Snake base 3Kg tapi
--     instance tertentu bisa 157Kg).
--   - Value/detik: AssetGenerationUtil.GetBaseRateMutationOnly({Category=...,
--     Scale=..., Mutations=...}) -- formula resmi yang sama dipake backpack
--     UI game buat itung earning rate, ngitung size-multiplier (scale^1.85)
--     + mutation-multiplier, TANPA bonus rebirth/gamepass milik player (itu
--     personal ke player, bukan sifat egg-nya sendiri).
-- Posisi world diambil dari PlotCmds.GetPlotData(LocalPlayer).CenterPoint.CFrame
-- * record.Placement.LocalCFrame -- pola yang sama kayak "Egg Mutation ESP.lua".
-- ============================================================
local eggESPFolder = nil
local eggESPLabels = {} -- [uid] = {Part, Text}
local eggESPConnections = {}

local function removeEggESPLabel(uid)
    local entry = eggESPLabels[uid]
    if entry then
        entry.Part:Destroy()
        eggESPLabels[uid] = nil
    end
end

local function upsertEggESPLabel(uid, worldCFrame, petName, weightKg, ratePerSec, mutationText)
    local entry = eggESPLabels[uid]
    if not entry then
        local part = Instance.new("Part")
        part.Name = uid
        part.Size = Vector3.new(0.1, 0.1, 0.1)
        part.Transparency = 1
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
        part.Anchored = true
        part.Parent = eggESPFolder

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "Label"
        billboard.Size = UDim2.new(0, 170, 0, 64)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = 400
        billboard.Adornee = part
        billboard.Parent = part

        local text = Instance.new("TextLabel")
        text.Name = "Text"
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Font = Enum.Font.GothamBold
        text.TextStrokeTransparency = 0
        text.TextStrokeColor3 = Color3.new(0, 0, 0)
        text.TextColor3 = Color3.fromRGB(255, 255, 255)
        text.TextScaled = true
        text.Parent = billboard

        entry = { Part = part, Text = text }
        eggESPLabels[uid] = entry
    end

    entry.Part.CFrame = worldCFrame
    local weightText = weightKg and (string.format("%.1f", weightKg) .. "Kg") or "?Kg"
    local rateText = ratePerSec and ("$" .. formatMoneyShort(ratePerSec) .. "/s") or "$?/s"
    entry.Text.Text = petName .. "\n" .. weightText .. " | " .. rateText .. "\n" .. (mutationText or "None")
end

local function refreshEggESP(uid, record)
    if not record or not record.Placement then
        removeEggESPLabel(uid)
        return
    end

    local ok = pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Assets = require(ReplicatedStorage.Directory.Assets).Directory
        local EggItemUtil = require(ReplicatedStorage.Library.Util.EggItemUtil)
        local AssetGenerationUtil = require(ReplicatedStorage.Library.Util.AssetGenerationUtil)
        local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds)

        local plotData = PlotCmds.GetPlotData(LocalPlayer)
        if not plotData or not plotData.CenterPoint then return end
        local worldCFrame = plotData.CenterPoint.CFrame * record.Placement.LocalCFrame * CFrame.new(0, 2, 0)

        local assetData = Assets[record.AssetCategory]
        if not assetData then return end
        local petName = assetData.DisplayName or record.AssetCategory

        local weightOk, weightKg = pcall(function() return EggItemUtil.GetWeightKg(record) end)
        if not weightOk then weightKg = nil end

        local rateOk, ratePerSec = pcall(function()
            return AssetGenerationUtil.GetBaseRateMutationOnly({
                Category = record.AssetCategory,
                Mutations = record.Mutations or {},
                Scale = record.AssetScale or 1
            })
        end)
        if not rateOk then ratePerSec = nil end

        -- record.Mutations itu array of string (misal {"Silver"}), kosong {} kalau egg-nya
        -- gak ada mutasi. Gabung semua kalau kebetulan lebih dari satu, "None" kalau kosong.
        local mutationText = "None"
        if type(record.Mutations) == "table" and #record.Mutations > 0 then
            mutationText = table.concat(record.Mutations, ", ")
        end

        upsertEggESPLabel(uid, worldCFrame, petName, weightKg, ratePerSec, mutationText)
    end)
    if not ok then
        removeEggESPLabel(uid)
    end
end

local function refreshAllEggESP()
    pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds)
        local records = EggCmds.GetOwnerRuntimeRecords(LocalPlayer.UserId)
        local seenUids = {}
        if type(records) == "table" then
            for uid, record in pairs(records) do
                if record.Placement then
                    seenUids[uid] = true
                    refreshEggESP(uid, record)
                end
            end
        end
        for uid in pairs(eggESPLabels) do
            if not seenUids[uid] then
                removeEggESPLabel(uid)
            end
        end
    end)
end

-- PENTING: startEggESP nge-yield (task.wait 0.3 buat kasih waktu RequestRuntimeSnapshot
-- nyampe server) SEBELUM masang listener & ngisi label. Kalau toggle di-klik OFF (atau
-- di-OFF-in lalu di-ON-in lagi) PAS lagi nunggu itu, versi lama lanjut ngisi label &
-- masang listener BEGITU nunggu-nya kelar -- TANPA ngecek toggle-nya masih ON apa
-- nggak. Efeknya: ESP keliatan "gak mau off" (label nongol lagi ~0.3 detik abis di-off-
-- in) atau numpuk listener duplikat kalau toggle-nya dipencet cepet berkali-kali.
-- Fix: eggESPGeneration jadi token -- tiap start/stop nge-bump-nya, dan kerjaan yang
-- ketunda cuma lanjut kalau generation-nya MASIH generation yang sama DAN toggle-nya
-- masih ON pas keburu nyampe situ. Juga dipindah ke task.spawn biar klik toggle-nya
-- sendiri gak nyangkut nunggu 0.3 detik dulu baru switch-nya keliatan gerak.
local eggESPGeneration = 0

local function startEggESP()
    if eggESPFolder then return end
    eggESPGeneration = eggESPGeneration + 1
    local myGeneration = eggESPGeneration

    eggESPFolder = Instance.new("Folder")
    eggESPFolder.Name = "NapoleonEggESP"
    eggESPFolder.Parent = workspace

    task.spawn(function()
        local ok, err = pcall(function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds)

            pcall(function() EggCmds.RequestRuntimeSnapshot() end)
            task.wait(0.3)

            if myGeneration ~= eggESPGeneration or not Config.EggESP then
                return
            end

            refreshAllEggESP()

            table.insert(eggESPConnections, EggCmds.RuntimeOwnerUpdated:Connect(function(ownerUserId)
                if myGeneration == eggESPGeneration and Config.EggESP and ownerUserId == LocalPlayer.UserId then
                    refreshAllEggESP()
                end
            end))
            table.insert(eggESPConnections, EggCmds.RuntimeOwnerCleared:Connect(function(ownerUserId)
                if myGeneration == eggESPGeneration and ownerUserId == LocalPlayer.UserId then
                    for uid in pairs(eggESPLabels) do
                        removeEggESPLabel(uid)
                    end
                end
            end))
        end)
        if not ok then
            warn("[EggESP] Gagal setup listener/populate label:", err)
        end
    end)
end

local function stopEggESP()
    eggESPGeneration = eggESPGeneration + 1
    for _, conn in ipairs(eggESPConnections) do
        pcall(function() conn:Disconnect() end)
    end
    eggESPConnections = {}
    for uid in pairs(eggESPLabels) do
        removeEggESPLabel(uid)
    end
    if eggESPFolder then
        eggESPFolder:Destroy()
        eggESPFolder = nil
    end
end

-- PENTING: HARUS dibungkus pcall. Ketauan LIVE: AddToggle (dari library UI pihak
-- ketiga) manggil ToggleFunc:Set() di akhir eksekusinya buat restore state + animasiin
-- knob-nya (TweenService:Create, GAK di-pcall sama library-nya) -- kalau TweenService:
-- Create() itu gagal ("lacking capability Plugin", kejadian live berkali-kali di
-- eksekusi ini), errornya PROPAGATE ke sini dan (kalau gak ditangkep) NGE-CRASH SISA
-- SELURUH SCRIPT abis titik ini -- termasuk section Egg Panel (gak pernah kebuat) dan
-- `UI_LOADED = true` (gak pernah ke-set, jadi SEMUA toggle lain yang harusnya auto-
-- start loop-nya pas restore -- Auto Steal, Auto Place, dll -- gak pernah beneran
-- jalan walau Config-nya sendiri udah bener true). Ini bukan cuma soal ESP -- pcall di
-- sini nyegah 1 toggle yang lagi apes numbangin SELURUH script.
pcall(function()
    MiscSection:AddToggle({
        Title = "ESP",
        Content = "Shows pet name, weight (Kg), and earning rate ($/s) above eggs placed on your own plot.",
        Default = false,
        Callback = function(val)
            Config.EggESP = val
            if val then
                startEggESP()
            else
                stopEggESP()
            end
        end
    })
end)

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

-- Signature dari SEMUA yang nentuin hasil render tab Logs. Dipakai buat nyekip render
-- yang hasilnya bakal identik -- tanpa nyentuh renderEggLogs() sama sekali.
--
-- MASALAHNYA (terukur di client user): tick loop 2 detik nge-destroy + recreate SEMUA
-- kartu tiap kali `eggLogsDirty` nyala, dan di server hidup event AreaEggUpdated/Removed
-- nembak terus jadi praktis SELALU dirty. Hasilnya spike frame 63-73ms tiap 2 detik persis,
-- padahal 8 dari 10 tick isinya sama sekali gak berubah (44 egg, nol add, nol remove).
--
-- KENAPA SKIP-NYA AMAN, dan ini bisa dibuktikan bukan cuma diasumsikan: semua field yang
-- dirender per kartu itu turunan data STATIS dari Directory.Assets/Areas yang dikunci
-- AssetCategory -- eggName, petName, eggIcon, rarityName, dan weightKg (itu properti JENIS
-- pet, `assetData.Egg.WeightKg`, BUKAN berat per-instance egg). Satu-satunya yang dinamis
-- per record adalah Mutations. Ditambah output-nya difilter SelectedRarity + SearchText
-- (lihat renderEggLogs di atas). Jadi tiga input itu LENGKAP -- kalau signature-nya sama,
-- kartu yang kebentuk PASTI sama.
--
-- Mutations WAJIB masuk signature, jangan cuma uid: mutationText itu dirender di kartu,
-- jadi kalau diabaikan, panel bisa nampilin teks mutasi basi. Itu baru namanya ngubah
-- fungsi, bukan improve performa.
--
-- Di-sort biar order-independent: `pairs()` di getEggLogEntries gak stabil urutannya, jadi
-- tanpa sort dua tick dengan isi sama bisa ngasilin string beda dan skip-nya gak pernah
-- kejadian. Sort ~44 entry itu mikrodetik, gak ada artinya dibanding ~60ms churn GUI.
local function eggLogsSignature(entries)
    local parts = {}
    for _, e in ipairs(entries or {}) do
        table.insert(parts, tostring(e.uid) .. ":" .. (e.mutationText or ""))
    end
    table.sort(parts)
    return EggPanelState.SelectedRarity
        .. "|" .. EggPanelState.SearchText
        .. "|" .. table.concat(parts, ",")
end

-- Signature dari isi yang TERAKHIR beneran dirender. nil = belum pernah render.
local lastRenderedLogsSignature = nil

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
        -- Render tanpa syarat di sini SENGAJA: fungsi ini dipanggil pas pindah tab / UI
        -- baru dibikin / filter berubah, dan di situ list-nya memang harus digambar ulang
        -- (bisa jadi ke-clear atau filternya beda). Yang penting signature-nya ikut
        -- di-update, biar tick berikutnya gak ngulang rebuild yang sama persis.
        lastRenderedLogsSignature = eggLogsSignature(cachedLogsRaw)
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

                            -- `eggLogsDirty` cuma hint MURAH "ada event egg lewat" -- dia
                            -- gak tau apakah yang berubah beneran keliatan di panel. Di
                            -- server hidup dia praktis selalu nyala, jadi kalau langsung
                            -- render, kita rebuild ~500 instance GUI tiap 2 detik buat
                            -- hasil yang mayoritasnya identik.
                            --
                            -- getEggLogEntries() sendiri MURAH (fetch snapshot + sort
                            -- ~44 entry) -- yang mahal itu churn GUI-nya. Jadi aman
                            -- ngitung entries tiap tick, lalu render CUMA kalau isinya
                            -- beneran beda.
                            local entries = getEggLogEntries()
                            local signature = eggLogsSignature(entries)
                            if signature ~= lastRenderedLogsSignature then
                                lastRenderedLogsSignature = signature
                                cachedLogsRaw = entries
                                renderEggLogs()
                            end
                            -- Kalau signature-nya sama, `cachedLogsRaw` SENGAJA dibiarin
                            -- apa adanya -- biar dia selalu sinkron sama apa yang beneran
                            -- kegambar di layar sekarang.
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
-- LAPIS 3 (DIHAPUS): dulu ada jaring terakhir -- kalau semua lapis di atas gagal dan
-- beneran ke-teleport, queue_on_teleport nge-resume script ini otomatis di server baru.
-- Itu dicabut total atas permintaan user (lihat blok "AUTO-EXECUTE / SELF-RESUME" di
-- atas file). Konsekuensinya disengaja: kalau lapis 0-2 semua jebol dan ke-kick beneran,
-- script TIDAK lanjut sendiri -- harus di-execute manual lagi.
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

local lastAfkReportAt = 0

LocalPlayer.Idled:Connect(function(idleSeconds)
    if not Config.AntiAFK then return end

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

    -- (Dulu di sini script nitipin dirinya ke queue_on_teleport biar lanjut sendiri abis
    -- AFK-kick. Dicabut total -- lihat blok "AUTO-EXECUTE / SELF-RESUME" di atas file.)
end)

-- Dulu di sini ada handler InputBegan yang tugasnya CUMA nyabut queue_on_teleport yang
-- dititipkan sendiri sama script ini pas idle. Karena penitipannya udah dicabut total,
-- handler ini jadi gak ada gunanya -- dihapus sekalian, jadi gak ada lagi kode kita yang
-- nyentuh queue_on_teleport di runtime. Satu-satunya sentuhan yang tersisa adalah clear
-- SEKALI di paling atas file, yang fungsinya bersih-bersih queue basi peninggalan versi lama.

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
-- Bug di library NPLN-UIv4.lua: ScrollSelect di tiap dropdown CanvasSize-nya
-- stuck di {0,0} walau isinya beneran ada (confirmed: AbsoluteContentSize
-- ratusan-ribuan pixel, CanvasSize tetep {0,0}) -- makanya dropdown gak bisa
-- discroll. Gak bisa edit source-nya (di-host di GitHub orang), jadi di-sync
-- manual dari sini.
-- PENTING: window Napoleon-nya kadang keparent LANGSUNG di CoreGui (misal
-- "CoreGui.NapoleonOnTop"), bukan selalu di dalam CoreGui.RobloxGui -- makanya
-- scan-nya harus dari CoreGui langsung, bukan dibatasin ke RobloxGui doang
-- (sebelumnya kebatasin ke RobloxGui dan jadi gak ketemu apa-apa lagi).
pcall(function()
    local rbxGui = game:GetService("CoreGui")
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

-- Bug library NPLN-UIv4.lua yang laen: ToggleFunc:Set() di dalem AddToggle jalanin
-- Callback DULU (jadi fitur beneran aktif -- terbukti ESP jalan normal), BARU abis
-- itu beberapa TweenService:Create() buat gerakin knob/circle-nya -- tapi tween-tween
-- ini GAK dibungkus pcall. Kalau salah satu gagal (kejadian live: "lacking capability
-- Plugin" pas restore config), sisa tween abis itu gak pernah jalan -- knob-nya
-- nyangkut di posisi lama padahal Callback & Config-nya udah bener ke-set. Efeknya:
-- toggle KELIATAN off padahal fiturnya AKTIF (atau sebaliknya) -- user ngerasa
-- "gak bisa di-onin" padahal udah on dari restore, atau klik malah keliatan gak
-- ngefek. Paksa sync visual toggle "ESP" biar SESUAI Config.EggESP yang beneran,
-- pake nilai warna/posisi PERSIS yang diambil dari toggle lain yang restore-nya
-- bener (Anti AFK) -- bukan tebak-tebakan.
-- PENTING: satu kali paksa set aja TERNYATA GAK CUKUP (dites live berkali-kali,
-- termasuk dikasih delay 0.6s -- tetep ke-timpa lagi). Kemungkinan si tween restore
-- yang gagal itu nyoba beberapa kali / delay-nya gak konsisten. Jadi diulang beberapa
-- kali selama ~3 detik biar APAPUN yang lagi nimpa itu akhirnya kalah sama fix ini.
local function syncEggESPToggleVisual()
    local rbxGui = game:GetService("CoreGui")
    for _, obj in ipairs(rbxGui:GetDescendants()) do
        if obj:IsA("TextLabel") and obj.Name == "ToggleTitle" and obj.Text == "ESP" then
            local toggleFrame = obj.Parent
            local featureFrame = toggleFrame:FindFirstChild("FeatureFrame")
            local circle = featureFrame and featureFrame:FindFirstChild("ToggleCircle")
            local stroke = featureFrame and featureFrame:FindFirstChildOfClass("UIStroke")
            if featureFrame and circle then
                if Config.EggESP then
                    obj.TextColor3 = Color3.fromRGB(255, 255, 255)
                    circle.Position = UDim2.new(0, 15, 0, 0)
                    circle.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
                    featureFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    featureFrame.BackgroundTransparency = 0
                    if stroke then
                        stroke.Color = Color3.fromRGB(255, 255, 255)
                        stroke.Transparency = 0
                    end
                else
                    obj.TextColor3 = Color3.fromRGB(230, 230, 230)
                    circle.Position = UDim2.new(0, 0, 0, 0)
                    circle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                    featureFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    featureFrame.BackgroundTransparency = 0.92
                    if stroke then
                        stroke.Color = Color3.fromRGB(255, 255, 255)
                        stroke.Transparency = 0.9
                    end
                end
            end
        end
    end
end

task.spawn(function()
    for _ = 1, 8 do
        pcall(syncEggESPToggleVisual)
        task.wait(0.4)
    end
end)

UI_LOADED = true

if Config.AutoSteal then
    StartAutoStealLoop()
end

if Config.AutoPlace then
    task.spawn(AutoPlaceLoop)
end

if Config.AutoSell then
    startAutoSellLoop()
end

if Config.AutoSellEgg then
    startAutoSellEggLoop()
end

if Config.EggPredictUI then
    toggleEggPanelUI(true)
    startEggPanelLoop()
end
