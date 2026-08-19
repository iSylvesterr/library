local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Fdhlnn23/NapoleonUI/refs/heads/main/NPLN-UIv4.lua"))()

local Config = {
    AutoFarm = false,
    TargetMobs = { ["All Possible"] = true },
}

-- Utilities Dropdown (Diambil dari struktur UI Napoleon)
local function parseMultiDropdown(val)
    local dict = {}
    if type(val) == "table" then
        local count = 0
        for k, v in pairs(val) do
            if type(k) == "number" then dict[v] = true; count = count + 1
            elseif v == true then dict[k] = true; count = count + 1 end
        end
        if count == 0 then dict["None"] = true end
    else
        dict[val or "None"] = true
    end
    return dict
end

local function handleDropdownChange(val, dropObj)
    local arr = type(val) == "table" and val or {val}
    local changed = false
    if #arr > 1 and table.find(arr, "None") then
        local newArr = {}
        for _, item in ipairs(arr) do if item ~= "None" then table.insert(newArr, item) end end
        arr = newArr
        changed = true
    elseif #arr == 0 then
        arr = {"None"}
        changed = true
    end
    if changed and dropObj then dropObj:Set(arr) end
    return arr
end

-- ==========================================
-- ANTI-AFK
-- ==========================================
local LocalPlayer = game:GetService("Players").LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ==========================================
-- INIT KNIT SERVICES
-- ==========================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = nil
local CombatService = nil
local CatchPetService = nil
local AreaController = nil
local MobController = nil
local PetController = nil

pcall(function()
    Knit = require(ReplicatedStorage.Packages.Knit)
    -- Ambil Service / Controller secara langsung melalui Framework Knit gamenya
    CombatService = Knit.GetService("CombatService")
    CatchPetService = Knit.GetService("CatchPetService")
    AreaController = Knit.GetController("AreaController")
    MobController = Knit.GetController("MobController")
    PetController = Knit.GetController("PetController")
end)

-- Fungsi untuk mendapatkan SEMUA UID Pet milik player
local function getMyPetUids()
    local myPets = {}
    local petsFolder = workspace:FindFirstChild("Live") and workspace.Live:FindFirstChild("Pets")
    if petsFolder then
        local serverPets = petsFolder:FindFirstChild("Server")
        if serverPets then
            for _, pet in ipairs(serverPets:GetChildren()) do
                if pet:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
                    table.insert(myPets, pet.Name)
                end
            end
        end
    end
    return myPets
end

-- ==========================================
-- LOGIC AUTO FARM (INSTANT KILL + INSTANT CATCH)
-- ==========================================
local farmLoop = false
local lastTargetUid = nil
local lastHealth = {}

local function startAutoFarm()
    if farmLoop then return end
    farmLoop = true
    
    if not CombatService or not CatchPetService then
        if Library and Library.MakeNotify then
            Library:MakeNotify({ Title = "Error", Content = "Gagal memuat Service. Pastikan game sudah loading penuh.", Delay = 3 })
        end
        farmLoop = false
        return
    end

    task.spawn(function()
        while Config.AutoFarm and farmLoop do
            pcall(function()
                local currentArea = AreaController and AreaController:GetAreaNow() or ""
                local myPetUids = getMyPetUids()
                
                local mobsFolder = workspace:FindFirstChild("Live") and workspace.Live:FindFirstChild("Mobs")
                if mobsFolder then
                    local serverMobs = mobsFolder:FindFirstChild("Server")
                    if serverMobs then
                        for _, mob in ipairs(serverMobs:GetChildren()) do
                            if not Config.AutoFarm then break end
                            
                            local mobUid = mob.Name 
                            local health = mob:GetAttribute("Health") or 0
                            local knocked = mob:GetAttribute("Knocked")
                            local knockedBy = mob:GetAttribute("KnockedBy")
                            
                            -- Pengecekan Filter Target Mob
                            local passFilter = Config.TargetMobs["All Possible"]
                            if not passFilter and MobController and MobController.mobs then
                                local mobNode = MobController.mobs[mobUid]
                                if mobNode then
                                    local displayName = mobNode._mobId
                                    if type(mobNode._mobInfo) == "table" and mobNode._mobInfo.Name then
                                        displayName = mobNode._mobInfo.Name
                                    elseif type(mobNode._mobInfo) == "string" then
                                        displayName = mobNode._mobInfo
                                    end
                                    
                                    if displayName and Config.TargetMobs[displayName] then
                                        passFilter = true
                                    end
                                end
                            end
                            
                            -- Jika filter None atau tidak lolos filter, skip!
                            if Config.TargetMobs["None"] or not passFilter then
                                continue
                            end
                            
                            -- 1. JIKA SUDAH MATI (KNOCKED)
                            if knocked then
                                -- Pastikan mob ini mati oleh kita agar tidak error "Not Your Catch!"
                                if knockedBy == LocalPlayer.UserId then
                                    CatchPetService:LockForCapture(mobUid)
                                    CatchPetService:TryCatch(mobUid, currentArea)
                                end
                                continue -- Skip proses damage jika sudah mati
                            end
                            
                            -- 2. JIKA MASIH HIDUP, INSTANT KILL!
                            if health > 0 then
                                -- 1. KILL AURA DULU (Spam burst damage tanpa nge-lock target)
                                for _, petUid in ipairs(myPetUids) do
                                    local hasValidSkill = false
                                    if PetController then
                                        local petNode = PetController:GetPet(petUid)
                                        if petNode and petNode._petData and petNode._petData.skills then
                                            for _, skillInfo in pairs(petNode._petData.skills) do
                                                if type(skillInfo) == "table" and skillInfo.id then
                                                    -- Spam 3x lipat per skill per pet
                                                    for i = 1, 3 do
                                                        CombatService:PetSkillDamage(petUid, skillInfo.id, skillInfo.level or 1, mobUid)
                                                    end
                                                    hasValidSkill = true
                                                end
                                            end
                                        end
                                    end
                                    
                                    -- Failsafe jika gagal mengambil skill dari PetController
                                    if not hasValidSkill then
                                        for i = 1, 3 do
                                            CombatService:PetSkillDamage(petUid, "Fireball", 1, mobUid)
                                            CombatService:PetSkillDamage(petUid, "Comet", 1, mobUid)
                                            CombatService:PetSkillDamage(petUid, "Tornado", 1, mobUid)
                                        end
                                    end
                                end

                                -- Deteksi apakah darah sudah berkurang
                                local maxHealth = mob:GetAttribute("MaxHealth")
                                local isDamaged = false
                                if maxHealth then
                                    isDamaged = health < maxHealth
                                else
                                    if not lastHealth[mobUid] then
                                        lastHealth[mobUid] = health
                                    elseif health < lastHealth[mobUid] then
                                        isDamaged = true
                                    end
                                end

                                -- 2. KETIKA DARAH UDAH BERKURANG, BARU ANGGAP KITA SEDANG PERANG (SET TARGET)
                                if isDamaged then
                                    if lastTargetUid ~= mobUid then
                                        pcall(function()
                                            CombatService:SetTarget(mobUid)
                                        end)
                                        lastTargetUid = mobUid
                                    end
                                    -- Fokus ke mob yang udah sekarat ini agar tidak di-rollback server!
                                    break
                                else
                                    -- Update history darah
                                    lastHealth[mobUid] = health
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(0.05) -- Kecepatan fix di 0.05 detik sesuai permintaan
        end
        farmLoop = false
    end)
end

-- ==========================================
-- UI SETUP
-- ==========================================
local MarketplaceService = game:GetService("MarketplaceService")
local GameName = "Blox Monster"

pcall(function()
    GameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

local Window = Library:Window({
    Title    = "Napoleon",
    Footer   = GameName,
    Color    = Color3.fromRGB(81, 66, 255),
    Color2   = Color3.fromRGB(0, 0, 14),
    ["Tab Width"] = 130,
    Image      = "111895858615511",
    WindowIMG  = "91334002283698",
    LogoHUB    = "136289055140268"
})

local Tabs = Window
local MainTab = Tabs:AddTab({ Name = "Main", Icon = "rod" })
local FarmSection = MainTab:AddSection("Auto Farm (Instant Kill)")

FarmSection:AddToggle({
    Title   = "Auto Farm & Catch",
    Title2  = "Enable",
    Content = "Membunuh seluruh monster di map dan langsung menangkapnya secara instan!",
    Default = false,
    Callback = function(val)
        Config.AutoFarm = val
        if val then
            startAutoFarm()
            if Library and Library.MakeNotify then
                Library:MakeNotify({ Title = "Auto Farm", Content = "Auto Farm (Instant Kill) ON ✅", Delay = 2 })
            end
        else
            farmLoop = false
            if Library and Library.MakeNotify then
                Library:MakeNotify({ Title = "Auto Farm", Content = "Auto Farm OFF", Delay = 2 })
            end
        end
    end,
})

local dropTargetMobs
local function getActiveMobs()
    local list = {"None", "All Possible"}
    local uniqueMobs = {}
    
    if MobController and MobController.mobs then
        for _, mobNode in pairs(MobController.mobs) do
            local displayName = mobNode._mobId
            if type(mobNode._mobInfo) == "table" and mobNode._mobInfo.Name then
                displayName = mobNode._mobInfo.Name
            elseif type(mobNode._mobInfo) == "string" then
                displayName = mobNode._mobInfo
            end
            
            if displayName and not uniqueMobs[displayName] then
                uniqueMobs[displayName] = true
                table.insert(list, displayName)
            end
        end
    end
    
    table.sort(list, function(a, b)
        if a == "None" then return true end
        if b == "None" then return false end
        if a == "All Possible" then return true end
        if b == "All Possible" then return false end
        return a < b
    end)
    
    return list
end

dropTargetMobs = FarmSection:AddDropdown({
    Title   = "Target Mob",
    Content = "Pilih spesifik mob yang ingin diserang (Multi-select)",
    Options = getActiveMobs(),
    Default = {"All Possible"},
    Multi   = true,
    Callback = function(val)
        local arr = handleDropdownChange(val, dropTargetMobs)
        Config.TargetMobs = parseMultiDropdown(arr)
    end,
})

FarmSection:AddButton({
    Title = "Refresh Mob List",
    Callback = function()
        if dropTargetMobs and dropTargetMobs.SetValues then
            dropTargetMobs:SetValues(getActiveMobs(), {"All Possible"})
            if Library and Library.MakeNotify then
                Library:MakeNotify({ Title = "Success", Content = "Daftar Mob berhasil diperbarui!", Delay = 2 })
            end
        end
    end
})

if Library and Library.MakeNotify then
    Library:MakeNotify({ Title = "Napoleon", Content = "Blox Monster Script Loaded!", Delay = 3, Icon = "rbxassetid://96531489912535" })
end
