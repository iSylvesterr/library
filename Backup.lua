

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

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
    PlaceRarities = {"None"}
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
    
    -- ============================================================
    -- INVINCIBILITY & HEALTH SPOOFING
    -- ============================================================
    local function setupInvincibility(hum)
        pcall(function()
            -- Disable state Dead — karakter tidak bisa mati secara fisik
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end)
        -- Paksa darah selalu 100 di setiap frame sebelum UI dirender
        -- Ini agar UI bar darah bawaan Roblox (pojok kanan atas) tidak pernah
        -- kelihatan abu-abu/kosong, menyembunyikan fakta bahwa karakter aslinya mati.
        pcall(function()
            local maxHp = hum.MaxHealth
            local loopConn
            loopConn = game:GetService("RunService").RenderStepped:Connect(function()
                if not hum.Parent then
                    loopConn:Disconnect()
                    return
                end
                -- Force ke 100 (MaxHealth) terus-menerus
                hum.Health = maxHp
            end)
        end)
    end
    
    -- Setup invincibility untuk karakter saat ini
    local initChar = LocalPlayer.Character
    if initChar then
        local initHum = initChar:FindFirstChild("Humanoid")
        if initHum then setupInvincibility(initHum) end
    end
    
    -- Setiap kali karakter baru muncul (setelah mati/respawn)
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        local newHum = newChar:WaitForChild("Humanoid", 5)
        if newHum then
            setupInvincibility(newHum)
        end
    end)

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
                print("[AutoSteal] Target:", targetEgg.Uid, "Rarity:", targetEgg.Rarity)
                
                local success, err = pcall(function()
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChild("Humanoid")
                    if not hrp or not hum then return end
                    
                    -- Simpan posisi awal player SEBELUM TP apapun
                    local returnCF = hrp.CFrame
                    local safezoneCF = CFrame.new(549.43, 70.43, -302.52) * CFrame.Angles(math.rad(-180.00), math.rad(-85.09), math.rad(-180.00))
                    local eggCF = targetEgg.BottomCFrame * CFrame.new(0, 3, 0)
                    
                    -- ==========================================
                    -- 1. LOOP CFrame KE TELUR (TANPA anchor)
                    -- Anchor di sini justru blokir server baca posisi kita
                    -- untuk proximity check ? carry gagal. Pakai loop biasa.
                    -- ==========================================
                    local loopConn = game:GetService("RunService").Heartbeat:Connect(function()
                        hrp.CFrame = eggCF
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                    end)
                    task.wait(0.25) -- Sweet Spot: 0.25s untuk baca posisi
                    loopConn:Disconnect()
                    
                    -- ==========================================
                    -- 2. REQUEST CARRY (Angkat Telur)
                    -- ==========================================
                    local carryOk, carryErr = EggCmds.RequestCarryAreaEgg(targetEgg.Uid)
                    
                    if not carryOk then
                        print("[AutoSteal] Carry gagal:", carryErr)
                        hrp.CFrame = returnCF
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        return
                    end
                    
                    print("[AutoSteal] Carry berhasil! Kembali ke safezone...")
                    task.wait(0.03)
                    
                    -- ==========================================
                    -- 3. ANCHOR + LOOP KE SAFEZONE
                    -- ==========================================
                    hrp.Anchored = true
                    local safezoneConn = game:GetService("RunService").Heartbeat:Connect(function()
                        hrp.CFrame = safezoneCF
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                    end)
                    task.wait(0.25) -- Sweet Spot: 0.25s untuk auto-claim di safezone
                    safezoneConn:Disconnect()
                    hrp.Anchored = false
                    
                    -- Kembalikan ke posisi awal user (bukan hardcoded)
                    hrp.CFrame = returnCF
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    
                    print("[AutoSteal] Selesai! Menunggu server reset sebelum steal berikutnya...")
                end) -- tutup pcall
                
                if not success then
                    print("[AutoSteal] Error:", err)
                end
                
                task.wait(0.2) -- Jeda antar steal
            else
                -- JIKA TIDAK ADA TELUR, REQUEST UPDATE DARI SERVER
                pcall(function()
                    EggCmds.RequestAreaEggSnapshot()
                end)
                task.wait(0.3) -- Jeda update jika telur kosong
            end
        end
        task.wait(0.1) -- Scan interval super cepat
    end
end

-- ============================================================
-- MAIN TAB
-- ============================================================
local MainTab = Tabs:AddTab({ Name = "Main", Icon = "rbxassetid://10734950309" })

local FarmSection = MainTab:AddSection("Auto Farm", false)

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
        "Desert", 
        "Snow",
        "Jungle", 
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
    Default = {"None"}, -- Default incaran utama
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
local PlaceSection = AutoTab:AddSection("Auto Place Egg", false)

PlaceSection:AddToggle({
    Title = "Auto Place Egg",
    Content = "Automatically place matching eggs on your plot",
    Default = false,
    Callback = function(val)
        Config.AutoPlace = val
        print("Auto Place:", val)
        if val then
            task.spawn(function()
                while Config.AutoPlace do
                    task.wait(2)
                    pcall(function()
                        local ReplicatedStorage = game:GetService("ReplicatedStorage")
                        local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds)
                        local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds)
                        local Assets = require(ReplicatedStorage.Directory.Assets)
                        
                        -- Dapatkan Plot milik kita sendiri
                        local plotData = PlotCmds.GetPlotData()
                        if not plotData then 
                            print("Auto Place: GAGAL! Kamu belum punya Plot. Silakan claim Plot dulu!")
                            return 
                        end
                        
                        -- Dapatkan telur yang kita punya di dalam tas (Runtime Records)
                        local myEggs = EggCmds.GetOwnerRuntimeRecords(LocalPlayer.UserId)
                        
                        local eggsToPlace = {}
                        local totalUnplaced = 0
                        for uid, record in pairs(myEggs) do
                            if record.Placement == nil then
                                totalUnplaced = totalUnplaced + 1
                                local rarityData = Assets.Directory[record.AssetCategory] and Assets.Directory[record.AssetCategory].Rarity
                                local rarity = rarityData and rarityData.DisplayName or (rarityData and rarityData._id) or "Unknown"
                                
                                local match = false
                                if #Config.PlaceRarities == 0 or table.find(Config.PlaceRarities, "None") then
                                    match = true
                                else
                                    match = table.find(Config.PlaceRarities, rarity) ~= nil
                                end
                                
                                if match then
                                    table.insert(eggsToPlace, {Uid = uid, Rarity = rarity})
                                end
                            end
                        end
                        
                        if totalUnplaced > 0 and #eggsToPlace == 0 then
                            -- Peringatan logik: Telur ada tapi nggak masuk filter
                            -- print("Auto Place: Ada telur di tas, tapi Rarity-nya nggak ada yang cocok sama filter Dropdown!")
                        end
                        
                        if #eggsToPlace > 0 then
                            local char = LocalPlayer.Character
                            local hrp = char and char:FindFirstChild("HumanoidRootPart")
                            local hum = char and char:FindFirstChild("Humanoid")
                            local originalCF = hrp and hrp.CFrame
                            
                            -- Pindah ke Plot dulu dengan Bypass
                            if hrp and hum and plotData.CenterPoint then
                                hum.Sit = false
                                hum.Jump = true
                                task.wait(0.1)
                                
                                InstantTeleport(char, plotData.CenterPoint.CFrame * CFrame.new(0, 3, 0))
                                task.wait(0.1)
                                
                                -- Paksa karakter berdiri agar tidak tiduran
                                hum.PlatformStand = false
                                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                                task.wait(0.3) -- Biarkan karakter berdiri & server tahu kita sudah di area Plot
                            end
                            
                            local plotIsFull = false
                            
                            -- Taruh semua telur yang cocok dengan PELAN TAPI PASTI
                            for _, eggInfo in ipairs(eggsToPlace) do
                                if not Config.AutoPlace or plotIsFull then break end
                                
                                local eqSuccess, eqErr = EggCmds.RequestEquipTool(eggInfo.Uid)
                                if eqSuccess then
                                    task.wait(1) -- Jeda 1 detik penuh agar server benar-benar tahu tool sudah dipegang
                                    
                                    local retries = 0
                                    local placed = false
                                    
                                    while retries < 3 and not placed and Config.AutoPlace and not plotIsFull do
                                        -- Random menyebar di SELURUH area Plot secara matematis akurat
                                        local placeCFrame = CFrame.new(0, -0.5, 0)
                                        
                                        if plotData.PetArea and plotData.CenterPoint then
                                            -- 1. Ambil titik acak di dalam kotak PetArea
                                            local rx = (math.random() - 0.5) * (plotData.PetArea.Size.X - 8)
                                            local rz = (math.random() - 0.5) * (plotData.PetArea.Size.Z - 8)
                                            
                                            -- 2. Jadikan posisi Dunia nyata (World Space)
                                            local worldPos = plotData.PetArea.CFrame * Vector3.new(rx, 0, rz)
                                            
                                            -- 3. Konversi menjadi kordinat relatif (Local Space) terhadap CenterPoint
                                            local localPos = plotData.CenterPoint.CFrame:PointToObjectSpace(worldPos)
                                            
                                            -- 4. Set CFrame final untuk dikirim ke Server (Y = -0.5, Rotasi = Acak)
                                            local randomYaw = math.rad(math.random(0, 360))
                                            placeCFrame = CFrame.new(localPos.X, -0.5, localPos.Z) * CFrame.Angles(0, randomYaw, 0)
                                        end
                                        
                                        local plSuccess, plErr = EggCmds.RequestPlaceEgg(eggInfo.Uid, placeCFrame)
                                        if plSuccess then
                                            print("Auto Place: Berhasil menaruh", eggInfo.Rarity)
                                            placed = true
                                        else
                                            -- Deteksi jika error karena Plot Kepenuhan
                                            if plErr and (string.find(string.lower(plErr), "full") or string.find(string.lower(plErr), "limit") or string.find(string.lower(plErr), "capacity") or string.find(string.lower(plErr), "maximum")) then
                                                print("Auto Place: STOP! Plot kamu sudah KEPENUHAN! (" .. tostring(plErr) .. ")")
                                                Config.AutoPlace = false
                                                plotIsFull = true
                                                break
                                            end
                                            
                                            print("Auto Place: Gagal menaruh -", plErr, "| Mencoba lagi...")
                                            retries = retries + 1
                                            task.wait(1) -- Tunggu 1 detik sebelum mencoba tempat lain
                                        end
                                    end
                                    
                                    task.wait(0.5) -- Jeda antar telur agar santai
                                else
                                    print("Auto Place: Gagal Equip -", eqErr)
                                    task.wait(1) -- Tunggu sebelum skip ke telur berikutnya
                                end
                            end
                            
                            task.wait(1) -- Jeda ekstra aman sebelum pulang ke treadmill
                            
                            -- Kembalikan pemain ke posisi awal (Treadmill) dengan Bypass
                            if hrp and hum and originalCF then
                                InstantTeleport(char, originalCF)
                                task.wait(0.1)
                                
                                -- Paksa karakter berdiri lagi
                                hum.PlatformStand = false
                                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                            end
                        end
                    end)
                end
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
-- MISC TAB & ANTI AFK
-- ============================================================
local MiscTab = Tabs:AddTab({ Name = "Misc", Icon = "rbxassetid://10734950309" })
local MiscSection = MiscTab:AddSection("Player Settings", false)

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

