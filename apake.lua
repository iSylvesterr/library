_G.ScriptFullyLoaded = false

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Fdhlnn23/NapoleonUI/refs/heads/main/NPLN-UIv4.lua"))()

local ICON_ID = "96531489912535"

local function notif(content, duration, title)
    if not _G.ScriptFullyLoaded then return end
    if Library and Library.MakeNotify then
        Library:MakeNotify({
            Title   = title or "Napoleon By Milo",
            Content = content,
            Delay   = duration or 4,
            Icon    = ICON_ID
        })
    end
end

local MarketplaceService = game:GetService("MarketplaceService")

local GameName = "Unknown"

pcall(function()
    GameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

local Window = Library:Window({
    Title    = "Napoleon By Milo",
    Footer   = GameName,
    Color    = Color3.fromRGB(81, 66, 255),
    Color2   = Color3.fromRGB(0, 0, 14),
    ["Tab Width"] = 130,
    Image      = "111895858615511",
    WindowIMG  = "91334002283698",
    LogoHUB    = "136289055140268"
})

local Tabs = Window

-- ==========================================
-- TABS & SECTIONS
-- ==========================================
local AutoTab = Window:AddTab({ Name = "Auto", Icon = "rod" })
local MiscTab = Window:AddTab({ Name = "Misc", Icon = "rod" })

local FarmSection = AutoTab:AddSection("Auto Farm")

-- ==========================================
-- AUTO BUY SEED LOGIC
-- ==========================================
local seedRarities = {"COMMON", "RARE", "EPIC", "LEGENDARY", "MYTHIC", "CELESTIAL", "SECRET", "DIVINE"}
local selectedSeedRarities = {}

FarmSection:AddDropdown({
    Title = "Auto Buy Seed Rarities",
    Default = {},
    Options = seedRarities,
    Multi = true,
    Callback = function(Value)
        selectedSeedRarities = {}
        if type(Value) == "table" then
            for _, v in pairs(Value) do
                selectedSeedRarities[v] = true
            end
        else
            selectedSeedRarities[Value] = true
        end
    end
})

local autoBuySeedEnabled = false
local autoBuySeedConnection = nil

local function ToggleAutoBuySeed()
    if autoBuySeedEnabled then
        if not autoBuySeedConnection then
            local success, SeedConveyorService = pcall(function()
                return game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.6.0"].knit.Services.SeedConveyorService
            end)
            
            if success and SeedConveyorService then
                local SeedSpawnedRE = SeedConveyorService.RE.SeedSpawned
                local RequestPurchaseRF = SeedConveyorService.RF.RequestPurchase
                
                autoBuySeedConnection = SeedSpawnedRE.OnClientEvent:Connect(function(seedData)
                    if not autoBuySeedEnabled then return end
                    
                    if type(seedData) == "table" then
                        local rarity = seedData.rarity
                        if rarity and selectedSeedRarities[rarity] then
                            local spawnId = seedData.spawnId
                            if spawnId then
                                task.spawn(function()
                                    pcall(function()
                                        local canAfford = true
                                        local successKnit, Knit = pcall(function() return require(game:GetService("ReplicatedStorage").Packages.Knit) end)
                                        local successSeed, SeedConfig = pcall(function() return require(game:GetService("ReplicatedStorage").Shared.Info.SeedConfig) end)
                                        
                                        if successKnit and successSeed then
                                            local DataClient = Knit.GetController("DataClient")
                                            local seedInfo = SeedConfig.GetSeed(seedData.seedKey)
                                            local cost = seedInfo and seedInfo.plantCost or 0
                                            local coins = 0
                                            if DataClient and DataClient.currentData and DataClient.currentData.Currency then
                                                coins = DataClient.currentData.Currency["COINS"] or 0
                                            end
                                            if coins < cost then
                                                canAfford = false
                                            end
                                        end
                                        
                                        if canAfford then
                                            RequestPurchaseRF:InvokeServer(spawnId)
                                        end
                                    end)
                                end)
                            end
                        end
                    end
                end)
            else
                warn("Failed to find SeedConveyorService")
            end
        end
    else
        if autoBuySeedConnection then
            autoBuySeedConnection:Disconnect()
            autoBuySeedConnection = nil
        end
    end
end

FarmSection:AddToggle({
    Title = "Auto Buy Seed",
    Content = "Automatically buys seeds as they spawn based on selected rarities, if you can afford them.",
    Default = false,
    Callback = function(val)
        autoBuySeedEnabled = val
        ToggleAutoBuySeed()
        if val then
            notif("Auto Buy Seed: ON", 3, "Auto Farm")
        else
            notif("Auto Buy Seed: OFF", 3, "Auto Farm")
        end
    end
})

-- ==========================================
-- AUTO PLANT & HARVEST LOGIC
-- ==========================================
local seedOptions = {
    "Oak", "Pine", "Apple", "Peach", "Fig", "Orange", "Lemon", "Avocado", "Cherry", 
    "Mango", "Coconut", "Banana", "Starfruit", "DragonFruit", "Glowing", "Blooming", 
    "Magic", "Pizza", "Diamond", "Void", "Mushroom", "Money", "Glowshroom", "Elder"
}

local selectedSeedToPlant = "Oak"
local autoPlantEnabled = false
local autoHarvestEnabled = false
local isPlanting = false
local activeCrashPoint = nil

FarmSection:AddDropdown({
    Title = "Seed to Auto Plant",
    Default = "Oak",
    Options = seedOptions,
    Multi = false,
    Callback = function(Value)
        selectedSeedToPlant = Value
    end
})

local function getBestFertilizer()
    local bestFert = "None"
    local bestMult = 0
    pcall(function()
        local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
        local DataClient = Knit.GetController("DataClient")
        local rebirths = (DataClient and DataClient.currentData) and DataClient.currentData.Rebirth or 0
        local FertilizerConfig = require(game:GetService("ReplicatedStorage").Shared.Info.FertilizerConfig)
        
        for fertName, fertData in pairs(FertilizerConfig.Fertilizers) do
            if rebirths >= fertData.rebirthReq and fertData.mult > bestMult then
                bestMult = fertData.mult
                bestFert = fertName
            end
        end
    end)
    return bestFert
end

local function equipSeed(seedName)
    local success = false
    pcall(function()
        local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
        local DataClient = Knit.GetController("DataClient")
        local ToolService = game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.6.0"].knit.Services.ToolService
        
        if DataClient and DataClient.currentData and DataClient.currentData.Inventory then
            for slotIdx, item in pairs(DataClient.currentData.Inventory.Hotbar) do
                if type(item) == "table" and not item.empty and item.itemType == "Seed" and item.seedType == seedName then
                    ToolService.RE.ToggleEquip:FireServer(true, tonumber(slotIdx))
                    success = true
                    return
                end
            end
            for slotIdx, item in pairs(DataClient.currentData.Inventory.Storage) do
                if type(item) == "table" and not item.empty and item.itemType == "Seed" and item.seedType == seedName then
                    ToolService.RE.ToggleEquip:FireServer(false, tonumber(slotIdx))
                    success = true
                    return
                end
            end
        end
    end)
    return success
end

FarmSection:AddToggle({
    Title = "Auto Plant",
    Content = "Automatically equips & plants the selected seed using the best available fertilizer.",
    Default = false,
    Callback = function(val)
        autoPlantEnabled = val
        if val then
            notif("Auto Plant: ON", 3, "Auto Farm")
            task.spawn(function()
                while autoPlantEnabled do
                    pcall(function()
                        if not isPlanting then
                            if equipSeed(selectedSeedToPlant) then
                                task.wait(0.5) -- Wait a bit for the seed to be equipped
                                local PlantRoundService = game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.6.0"].knit.Services.PlantRoundService
                                if PlantRoundService then
                                    PlantRoundService.RF.StartRound:InvokeServer(selectedSeedToPlant, getBestFertilizer())
                                end
                            end
                        end
                    end)
                    task.wait(2)
                end
            end)
        else
            notif("Auto Plant: OFF", 3, "Auto Farm")
        end
    end
})

FarmSection:AddToggle({
    Title = "Auto Harvest",
    Content = "Automatically harvests trees immediately when lightning strikes.",
    Default = false,
    Callback = function(val)
        autoHarvestEnabled = val
        if val then
            notif("Auto Harvest: ON", 3, "Auto Farm")
        else
            notif("Auto Harvest: OFF", 3, "Auto Farm")
        end
    end
})

local function getCurrentMultiplier()
    local mult = 1
    pcall(function()
        local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            local roundBillboards = playerGui:FindFirstChild("RoundBillboards")
            if roundBillboards then
                for _, obj in pairs(roundBillboards:GetDescendants()) do
                    if obj:IsA("TextLabel") and obj.Text then
                        local text = string.gsub(obj.Text, "<[^>]+>", "")
                        local match = string.match(text, "^([%d%.]+)x$")
                        if match then
                            mult = tonumber(match)
                        end
                    end
                end
            end
        end
    end)
    return mult
end

-- Smart Harvest Logic Loop
task.spawn(function()
    pcall(function()
        local PlantRoundService = game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.6.0"].knit.Services.PlantRoundService
        if PlantRoundService then
            PlantRoundService.RE.RoundStartedAll.OnClientEvent:Connect(function(userId, position, seedType, p4, crashPoint)
                if userId == game.Players.LocalPlayer.UserId then
                    activeCrashPoint = crashPoint
                    isPlanting = true
                end
            end)
            PlantRoundService.RE.PlantStoppedAll.OnClientEvent:Connect(function(userId)
                if userId == game.Players.LocalPlayer.UserId then
                    isPlanting = false
                    activeCrashPoint = nil
                end
            end)
            PlantRoundService.RE.CrashedAll.OnClientEvent:Connect(function(userId)
                if userId == game.Players.LocalPlayer.UserId then
                    isPlanting = false
                    activeCrashPoint = nil
                end
            end)
        end
    end)

    while task.wait(0.1) do
        if autoHarvestEnabled then
            pcall(function()
                local PlantRoundService = game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.6.0"].knit.Services.PlantRoundService
                if PlantRoundService then
                    PlantRoundService.RF.CollectDeadTree:InvokeServer()
                    
                    if activeCrashPoint then
                        local currentMult = getCurrentMultiplier()
                        if currentMult >= activeCrashPoint then
                            PlantRoundService.RF.StopPlant:InvokeServer()
                            activeCrashPoint = nil
                            isPlanting = false
                        end
                    end
                end
            end)
        end
    end
end)

local LootSection = AutoTab:AddSection("Auto Loot")
local MiscSection = MiscTab:AddSection("Miscellaneous")

-- ==========================================
-- SCRIPT LOADED
-- ==========================================
_G.ScriptFullyLoaded = true
notif("Script loaded successfully!", 5, "Napoleon Lite By Milo")

