local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

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
        print("[ZombieMode] Died terpanggil — server baca kematian!")
        
        local maxHp = humanoid.MaxHealth
        healthConn = RunService.RenderStepped:Connect(function()
            if not humanoid or not humanoid.Parent then
                if healthConn then healthConn:Disconnect() end
                return
            end
            humanoid.Health = maxHp
        end)
        
        print("[ZombieMode] Invincibility aktif — mayat hidup!")
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
-- 1. DISABLE GUARDS / DEATH BY HOOKING MODULE
-- ============================================================
-- Ini untuk mencegah karakter dibunuh oleh Boss/Guard di client
-- saat melakukan Instant Teleport ke dalam area mereka.
local successHook, GuardLookup = pcall(function()
    return require(game:GetService("ReplicatedStorage").Library.Util.GuardAreaLookupUtil)
end)
if successHook and GuardLookup then
    GuardLookup.IsInGameplaySide = function()
        return false
    end
    print("[Bypass] GuardAreaLookupUtil berhasil di-hook! Guard tidak akan menyerang.")
end


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
    SellEggRarities = {"None"}
}

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
    local url = "https://raw.githubusercontent.com/Fdhlnn23/NapoleonUI/refs/heads/main/NPLN-UIv4.lua"
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
-- BUILD UI WINDOW
-- ============================================================
local Window = Library:Window({
    Title = "Napoleon",
    Footer = "Steal An Egg",
    Color = Color3.fromRGB(81, 66, 255),
    Color2 = Color3.fromRGB(0, 0, 14),
    ["Tab Width"] = 130,
    Image = "111895858615511",
    WindowIMG = "91334002283698",
    LogoHUB = "136289055140268"
})

local Tabs = Window

-- ============================================================
-- AUTO STEAL LOGIC (RAGDOLL BYPASS + STEAL + BACK)
-- ============================================================
local function AutoStealLoop()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds)
    -- Tidak perlu StealEvent manual, kita pakai EggCmds yang sudah ada
    
    -- Invincibility sekarang ditangani secara global oleh Zombie Mode di atas

    while Config.AutoSteal do
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if char and hrp then
            local eggSnapshot = EggCmds.GetAreaEggSnapshot()
            local targetEgg = nil
            
            if eggSnapshot and eggSnapshot.Records then
                local highestWeight = -1
                
                for _, record in pairs(eggSnapshot.Records) do
                    local area = record.AreaId
                    
                    -- Lookup Rarity dari game data
                    local Assets = require(game:GetService("ReplicatedStorage").Directory.Assets)
                    local rarityData = Assets.Directory[record.AssetCategory] and Assets.Directory[record.AssetCategory].Rarity
                    local rarity = rarityData and rarityData.DisplayName or rarityData and rarityData._id or "Unknown"
                    
                        if (record.State == "Slot" or record.State == "Dropped") and record.BottomCFrame then -- Pastikan telur fisik sudah render
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
                                    targetEgg.Rarity = rarity -- Simpan ke record sementara untuk dipakai di print
                                end
                            end
                        end
                    end
                end
            
            -- Lakukan pencurian via CARRY + DROP (mekanisme resmi game)
            if targetEgg then
                Config.IsStealing = true
                print("[AutoSteal] Target:", targetEgg.Uid, "Rarity:", targetEgg.Rarity)
                
                local success, err = pcall(function()
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChild("Humanoid")
                    if not hrp or not hum then return end
                    
                    -- Lepas telur yang mungkin sedang dipegang oleh AutoPlace
                    hum:UnequipTools()
                    
                    local safezoneCF = CFrame.new(542.92, 70.57, -364.83) * CFrame.Angles(math.rad(-180.00), math.rad(-89.13), math.rad(-180.00))
                    
                    -- TP KE SAFEZONE DULU SEBELUM MENGAMBIL TELUR (Mencegah bug Anti-Cheat)
                    if (hrp.Position - safezoneCF.Position).Magnitude > 5 then
                        local initSafezoneConn = RunService.Heartbeat:Connect(function()
                            if hrp then 
                                hrp.CFrame = safezoneCF 
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                hrp.AssemblyAngularVelocity = Vector3.zero
                            end
                        end)
                        task.wait(0.5) -- Beri waktu agar server mencatat posisi kita di safezone
                        initSafezoneConn:Disconnect()
                    end
                    
                    -- Simpan posisi awal player SEBELUM TP ke telur
                    local returnCF = hrp.CFrame
                    local safezoneCF = CFrame.new(542.92, 70.57, -364.83) * CFrame.Angles(math.rad(-180.00), math.rad(-89.13), math.rad(-180.00))
                    local eggCF = targetEgg.BottomCFrame * CFrame.new(0, 3, 0)
                    
                    -- ==========================================
                    -- 1. LOOP CFrame KE TELUR (TANPA anchor)
                    -- Anchor di sini justru blokir server baca posisi kita
                    -- untuk proximity check → carry gagal. Pakai loop biasa.
                    -- ==========================================
                    local loopConn = game:GetService("RunService").Heartbeat:Connect(function()
                        hrp.CFrame = eggCF
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                    end)
                    
                    -- ==========================================
                    -- 2. REQUEST CARRY (Spam berkali-kali)
                    -- Karena posisi butuh waktu sampai ke server, kita spam 
                    -- request carry-nya sampai diterima (max 10x percobaan).
                    -- Ini bikin TP adaptif & secepat ping/koneksi internetmu.
                    -- ==========================================
                    local carryOk, carryErr
                    for i = 1, 10 do
                        carryOk, carryErr = EggCmds.RequestCarryAreaEgg(targetEgg.Uid)
                        if carryOk then 
                            break 
                        end
                        task.wait(0.03) -- Jeda 1-2 frame antar request
                    end
                    
                    loopConn:Disconnect()
                    
                    if not carryOk then
                        print("[AutoSteal] Carry gagal setelah 10x percobaan:", carryErr)
                        hrp.CFrame = returnCF
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        return
                    end
                    
                    print("[AutoSteal] Carry berhasil! Kembali ke safezone...")
                    -- task.wait setelah carry dihapus, langsung TP ke safezone
                    
                    -- ==========================================
                    -- 3. LOOP KE SAFEZONE (TANPA anchor, sama seperti ke telur)
                    -- Server akan otomatis validasi posisi & claim egg
                    -- Tanpa anchor supaya posisi terbaca server → guard tidak menyerang
                    -- ==========================================
                    local safezoneConn = game:GetService("RunService").Heartbeat:Connect(function()
                        hrp.CFrame = safezoneCF
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                    end)
                    
                    -- Tunggu egg hilang dari snapshot = server sudah claim (max 5 detik)
                    local claimWaited = 0
                    local maxClaimWait = 5.0
                    repeat
                        task.wait(0.03) -- Poll super cepat
                        claimWaited = claimWaited + 0.03
                        -- Cek setelah minimal 0.06s
                        if claimWaited >= 0.06 and EggCmds.GetAreaEggRecord(targetEgg.Uid) == nil then
                            print("[AutoSteal] Egg berhasil di-claim oleh server! (" .. string.format("%.2f", claimWaited) .. "s)")
                            break
                        end
                    until claimWaited >= maxClaimWait
                    
                    safezoneConn:Disconnect()
                    
                    if claimWaited >= maxClaimWait then
                        print("[AutoSteal] Claim timeout (" .. maxClaimWait .. "s) - server tidak merespons, lanjut...")
                    end

                    print("[AutoSteal] Selesai! Lanjut ke egg berikutnya...")
                end)
                
                if not success then
                    warn("[AutoSteal] Error saat mencuri:", err)
                end
                
                Config.IsStealing = false
                task.wait(0.05)
            else
                pcall(function()
                    EggCmds.RequestAreaEggSnapshot()
                end)
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

FarmSection:AddToggle({
    Title = "Auto Steal Egg",
    Content = "Automatically teleports and steals eggs based on filters",
    Default = false,
    Callback = function(val)
        Config.AutoSteal = val
        if val then
            print("Auto Steal Started!")
            task.spawn(AutoStealLoop)
        else
            print("Auto Steal Stopped!")
            Config.IsStealing = false
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
        print("Areas selected:")
        for _, v in ipairs(Config.StealAreas) do print("-", v) end
    end
})

local rarityDropdown
rarityDropdown = FarmSection:AddDropdown({
    Title = "Filter By Rarity",
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
        
        print("Rarities selected:")
        for _, r in ipairs(Config.StealRarities) do
            print("- " .. r)
        end
    end
})
-- ============================================================
-- AUTO TAB (Auto Place Egg)
-- ============================================================
local AutoTab = Tabs:AddTab({ Name = "Auto", Icon = "rbxassetid://10734950309" })
local PlaceSection = AutoTab:AddSection("Auto Place Egg")

local autoPlaceToggle
autoPlaceToggle = PlaceSection:AddToggle({
    Title = "Auto Place Egg",
    Content = "Automatically place matching eggs on your plot",
    Default = false,
    Callback = function(val)
        Config.AutoPlace = val
        print("Auto Place:", val)
        if val then
            task.spawn(function()
                while Config.AutoPlace do
                    task.wait(1.5)
                    local success, err = pcall(function()
                        if Config.IsStealing then return end

                        print("AutoPlace check started...")
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
                                            print("Ditemukan myTruePlot:", p.Name)
                                            break
                                        end
                                    end
                                end
                            end
                        else
                            print("Folder workspace.Plots tidak ada!")
                        end

                        if not myTruePlot then 
                            print("Gagal menemukan Plot milik", LocalPlayer.Name)
                            return 
                        end

                        local ToUpdate = myTruePlot:FindFirstChild("ToUpdate")
                        local PetArea = ToUpdate and ToUpdate:FindFirstChild("PetArea")
                        local CenterPoint = myTruePlot:FindFirstChild("CenterPoint") or PetArea
                        
                        if not PetArea then 
                            print("Gagal menemukan ToUpdate.PetArea di plot!")
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
                    
                    print("Total telor yg match untuk ditaruh:", #eggsToPlace, "| Di plot:", placedCount, "/ 30")
                    
                    -- Simpan posisi awal sebelum TP ke plot (hanya jika kita ada telur)
                    local char = LocalPlayer.Character
                    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                    local originalCF = nil
                    
                    if #eggsToPlace == 0 or placedCount >= 30 then
                        -- Jika tidak ada telur yg mau di place, atau plot penuh,
                        -- maka kembali idle (tunggu iterasi loop selanjutnya)
                        return
                    end
                    
                    if hrp then originalCF = hrp.CFrame end
                    print("Auto Place: Ditemukan telur untuk dipajang! Bergerak ke plot...")
                    
                    if Config.IsStealing then return end
                    
                    -- Teleport ke plot (di atas PetArea)
                        if hrp and PetArea then
                            hrp.CFrame = PetArea.CFrame * CFrame.new(0, 3, 0)
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            task.wait(0.5) -- Tunggu karakter jatuh/sampai dengan aman
                            if Config.IsStealing then return end -- Abort if steal started during wait
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
                                print("Auto Place: Sudah mencapai batas maksimal 30 telur di plot!")
                                stopPlacing = true
                                break
                            end
                            
                            -- PRIORITAS UTAMA: Jika Auto Steal sedang angkat telur, hentikan Auto Place sementara!
                            if Config.IsStealing then
                                print("Auto Place: Jeda dulu, Auto Steal sedang sibuk ambil egg!")
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
                                        print("Auto Place: Grid penuh (tidak ada slot kosong)!")
                                        stopPlacing = true
                                        break
                                    end
                                    
                                    if Config.IsStealing then return end
                                    local plSuccess, plErr = EggCmds.RequestPlaceEgg(uid, placeCFrame)
                                    if plSuccess then
                                        print("Auto Place: Berhasil taruh", eggInfo.Rarity, "| Kg:", eggInfo.Kg)
                                        table.insert(occupiedPositions, placeCFrame.Position)
                                        placedCount = placedCount + 1
                                        placed = true
                                        task.wait(0.15) -- Dipercepat dari 0.5
                                    else
                                        local lErr = plErr and string.lower(tostring(plErr)) or ""
                                        if string.find(lErr, "full") or string.find(lErr, "limit") 
                                            or string.find(lErr, "capacity") or string.find(lErr, "maximum") then
                                            print("Auto Place: Plot server menolak (PENUH)! Mematikan Auto Place.")
                                            Config.AutoPlace = false
                                            stopPlacing = true
                                            break
                                        end
                                        
                                        -- Jika gagal karena tertabrak hitbox telur besar, anggap grid ini penuh & lanjut ke grid sebelah
                                        print("Auto Place: Gagal di slot", searchIdx, "(Tertabrak telur besar?). Mencoba slot sebelahnya...")
                                        table.insert(occupiedPositions, placeCFrame.Position)
                                        searchIdx = searchIdx + 1
                                        task.wait(0.1)
                                    end
                                end
                                
                                if not placed and not stopPlacing then
                                    print("Auto Place: Gagal menaruh telur (semua slot sisa tertutup telur besar).")
                                end
                            end
                        end

                        
                        -- Kembalikan ke posisi awal setelah kelar place
                        if originalCF and hrp and not Config.IsStealing then
                            hrp.CFrame = originalCF
                            task.wait(0.2)
                        end
                    end)
                    if not success then
                        warn("Auto Place Error: " .. tostring(err))
                    end
                end -- End of while loop
            end)
        end
    end
})

local placeDropdown
placeDropdown = PlaceSection:AddDropdown({
    Title = "Filter By Rarity",
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
        print("Auto Hatch:", val)
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
                                print("Auto Hatch: Berhasil menetaskan telur!")
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
                                            print("Auto Sell: Skip", petName, "karena sedang di-equip!")
                                        else
                                            table.insert(uidsToSell, uid)
                                        end
                                    end
                                end
                            end
                        end
                        
                        if #uidsToSell > 0 then
                            print("Auto Sell: Ditemukan " .. tostring(foundMatching) .. " pet match. Menjual " .. tostring(#uidsToSell) .. " pet...")
                            
                            -- Jika mode Ignore Filter aktif, gunakan SellAllAssets agar langsung bersih 1 tas (sangat cepat)
                            -- Jika tidak (pakai filter), gunakan loop individual SellAsset
                            if Config.SellAll then
                                local EventAll = ReplicatedStorage.Network:FindFirstChild("AssetInventory: SellAllAssets")
                                if EventAll then
                                    EventAll:FireServer(uidsToSell)
                                    print("Auto Sell: Berhasil FireServer (SellAllAssets) untuk " .. tostring(#uidsToSell) .. " pet!")
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
                                                print("Auto Sell: Tool pet tidak ditemukan di Backpack untuk UID", uid)
                                            end
                                        end
                                        
                                        EventSell:FireServer({uid})
                                        task.wait(0.05) -- Jeda super singkat antar penjualan
                                    end
                                    print("Auto Sell: Berhasil FireServer (SellAsset) satu per satu untuk " .. tostring(#uidsToSell) .. " pet!")
                            else
                                warn("Auto Sell Error: Remote SellAsset tidak ditemukan di Network!")
                            end
                            end
                        elseif foundMatching > 0 then
                            print("Auto Sell: Ada " .. tostring(foundMatching) .. " pet yang match, tapi semua sedang di-equip atau tidak bisa dijual.")
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
                print("[AutoSellEgg] Filter rarity aktif:", table.concat(Config.SellEggRarities, ", "), "| Total egg record:", totalRecords)

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

                            print("[AutoSellEgg] Scan:", uid, "|", eggName, "| assetId:", tostring(assetId), "| rarity:", rarity, "| rarityMatch:", rarityMatch, "| equipped:", isEquipped, "| favorite:", isFavorite)

                            if rarityMatch and not isFavorite then
                                foundMatching = foundMatching + 1
                                if isEquipped then
                                    local reason = (record.Placement ~= nil) and "sedang dipajang di plot" or "sedang di-equip"
                                    print("Auto Sell Egg: Skip", eggName, "karena", reason)
                                else
                                    table.insert(uidsToSell, uid)
                                end
                            end
                        end
                    end
                end
                
                if #uidsToSell > 0 then
                    print("[AutoSellEgg] Ditemukan " .. tostring(#uidsToSell) .. " UID buat dijual:", table.concat(uidsToSell, ", "))
                    local EventSell = ReplicatedStorage.Network:FindFirstChild("AssetInventory: SellAsset")
                    print("[AutoSellEgg] Remote 'AssetInventory: SellAsset' ditemukan?", EventSell ~= nil)
                    if EventSell then
                        local soldCount = 0
                        for _, uid in ipairs(uidsToSell) do
                            if not Config.AutoSellEgg then break end
                            if Config.IsStealing then break end

                            local eqSuccess, eqErr = EggCmds.RequestEquipTool(uid)
                            print("[AutoSellEgg] RequestEquipTool(" .. tostring(uid) .. ") -> success=" .. tostring(eqSuccess) .. " err=" .. tostring(eqErr))

                            if eqSuccess then
                                task.wait(0.15)
                                EventSell:FireServer({uid})
                                print("[AutoSellEgg] FireServer SellAsset untuk", uid)
                                soldCount = soldCount + 1
                                task.wait(0.1)
                            end
                        end
                        print("[AutoSellEgg] Selesai. Berhasil equip+fire untuk " .. tostring(soldCount) .. "/" .. tostring(#uidsToSell) .. " telur.")
                    else
                        warn("Auto Sell Egg Error: Remote SellAsset tidak ditemukan!")
                    end
                elseif foundMatching > 0 then
                    print("Auto Sell Egg: Ada " .. tostring(foundMatching) .. " telur yang match, tapi semua sedang di-equip/dipajang.")
                else
                    print("Auto Sell Egg: Tidak ada telur yang cocok filter Rarity saat ini (cek pilihan dropdown-nya).")
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
        if val then
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
        if val then
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
    Title = "Filter By Rarity",
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
        "Celestial",
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
        if val then
            startAutoSellEggLoop()
        end
    end
})

local sellEggRarityDropdown
sellEggRarityDropdown = SellEggSection:AddDropdown({
    Title = "Filter By Rarity",
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
        "Celestial",
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
    Content = "Pilih pemain tujuan pengiriman gift",
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
    Content = "Perbarui daftar pemain yang ada di server",
    Callback = function()
        UpdateGiftPlayerList()
        print("[AutoGift] Player list refreshed!")
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
    Content = "Pilih nama item/telur",
    Options = allItemNames,
    Default = "None",
    Multi = false,
    Callback = function(val)
        AutoGiftItemName = (type(val) == "table" and val[1]) or val
        if AutoGiftItemName == "None" then AutoGiftItemName = "" end
        print("[AutoGift] Target Item Name:", AutoGiftItemName == "" and "Any" or AutoGiftItemName)
    end
})

-- Dropdown: Rarity yang mau di-gift
TradeSection:AddDropdown({
    Title = "Rarity to Gift",
    Content = "Pilih rarity telur yang akan dikirim ke target",
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
    Content = "Otomatis kirim telur ke player target berdasarkan rarity",
    Default = false,
    Callback = function(val)
        AutoGiftEnabled = val
        print("[AutoGift]", val and "ON - Kirim ke: " .. tostring(AutoGiftTarget) or "OFF")
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
                        print("[AutoGift] Send Request ke:", targetPlayer.Name, "(", targetPlayer.UserId, ")")
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
                                print("[AutoGift] Item diterima! Lanjut item berikutnya...")
                                break
                            end
                            -- Kalau udah lama dan item masih ada, coba fire ulang
                            if waited >= 5 and waited % 5 < 0.6 then
                                print("[AutoGift] Retry send request...")
                                pcall(function() remote:InvokeServer(targetPlayer.UserId) end)
                            end
                        end
                        if waited >= 15 then
                            print("[AutoGift] Timeout! Target mungkin nolak atau offline.")
                        end
                    end
                end
            else
                print("[AutoGift] Player '" .. tostring(AutoGiftTarget) .. "' tidak ditemukan!")
            end
        end
    end
end)

-- Toggle: Auto Accept Gift
TradeSection:AddToggle({
    Title = "Auto Accept Gift",
    Content = "Otomatis terima semua gift yang masuk",
    Default = false,
    Callback = function(val)
        AutoAcceptGift = val
        print("[AutoAccept]", val and "ON" or "OFF")
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
                            print("[AutoAccept] Gift dari", senderName, "diterima!")
                        end
                    end)
                end)
            end
        end)
    end)
end)

-- ============================================================
-- MISC TAB & ANTI AFK
-- ============================================================
local MiscTab = Tabs:AddTab({ Name = "Misc", Icon = "rbxassetid://10734950309" })
local MiscSection = MiscTab:AddSection("Player Settings")



MiscSection:AddToggle({
    Title = "Anti AFK",
    Content = "Prevents you from getting kicked for being idle (20 mins)",
    Default = true,
    Callback = function(val)
        Config.AntiAFK = val
        print("Anti AFK:", val)
    end
})

-- Anti AFK Logic
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        print("Anti AFK triggered!")
    end
end)

print("UI Steal An Egg loaded successfully!")
