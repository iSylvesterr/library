-- Egg Mutation ESP
-- Nampilin nama pet + mutasi buat egg liar (area) dan egg yang lagi tumbuh di plot kita sendiri,
-- SEBELUM egg itu dicuri/di-hatch -- soalnya field Mutations udah ke-sync ke client dari saat
-- egg itu spawn/ditanam (liat AreaEggs.lua & Eggs.lua schema), bukan pas hatch selesai.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds)
local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds)
local Assets = require(ReplicatedStorage.Directory.Assets)

local ESP_FOLDER_NAME = "NapoleonEggESP"
local GUI_NAME = "NapoleonEggESPGui"

-- Bersihin sisa run sebelumnya kalo script ini di-exe ulang
local oldFolder = workspace:FindFirstChild(ESP_FOLDER_NAME)
if oldFolder then oldFolder:Destroy() end
local oldGui = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild(GUI_NAME)
if oldGui then oldGui:Destroy() end

local Config = {
    Enabled = true,
    OnlyShowMutated = true, -- false = egg "None" (gak bermutasi) juga dikasih label
}

local MUTATION_COLORS = {
    Rainbow = Color3.fromRGB(255, 60, 255),
    Golden = Color3.fromRGB(255, 234, 0),
    Silver = Color3.fromRGB(220, 220, 220),
}
local DEFAULT_MUTATION_COLOR = Color3.fromRGB(255, 255, 255)

local espFolder = Instance.new("Folder")
espFolder.Name = ESP_FOLDER_NAME
espFolder.Parent = workspace

local activeLabels = {} -- [key] = { Part, Text }

local function getPetDisplayName(assetCategory)
    local data = Assets.Directory[assetCategory]
    return (data and data.DisplayName) or assetCategory
end

local function getMutationInfo(record)
    local mutations = record.Mutations
    if not mutations or #mutations == 0 then
        return nil, DEFAULT_MUTATION_COLOR
    end
    local text = table.concat(mutations, " + ")
    local color = MUTATION_COLORS[record.BaseMutation] or DEFAULT_MUTATION_COLOR
    return text, color
end

local function removeLabel(key)
    local entry = activeLabels[key]
    if entry then
        entry.Part:Destroy()
        activeLabels[key] = nil
    end
end

local function upsertLabel(key, worldCFrame, petName, mutationText, mutationColor)
    if Config.OnlyShowMutated and not mutationText then
        removeLabel(key)
        return
    end

    local entry = activeLabels[key]
    if not entry then
        local part = Instance.new("Part")
        part.Name = key
        part.Size = Vector3.new(0.1, 0.1, 0.1)
        part.Transparency = 1
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
        part.Anchored = true
        part.Parent = espFolder

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "Label"
        billboard.Size = UDim2.new(0, 180, 0, 40)
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
        text.TextScaled = true
        text.Parent = billboard

        entry = { Part = part, Text = text }
        activeLabels[key] = entry
    end

    entry.Part.CFrame = worldCFrame
    entry.Text.Text = mutationText and (petName .. "\n[" .. mutationText .. "]") or petName
    entry.Text.TextColor3 = mutationColor
end

-- ===== EGG LIAR (AREA) =====

local function refreshAreaEgg(record)
    if not record then return end
    if record.State ~= "Slot" and record.State ~= "Dropped" then
        removeLabel("Area_" .. record.Uid)
        return
    end
    if not record.BottomCFrame then return end

    local petName = getPetDisplayName(record.AssetCategory)
    local mutationText, mutationColor = getMutationInfo(record)
    upsertLabel("Area_" .. record.Uid, record.BottomCFrame * CFrame.new(0, 2, 0), petName, mutationText, mutationColor)
end

local function refreshAllAreaEggs()
    local snapshot = EggCmds.GetAreaEggSnapshot()
    local seenUids = {}
    if snapshot and snapshot.Records then
        for _, record in pairs(snapshot.Records) do
            seenUids[record.Uid] = true
            refreshAreaEgg(record)
        end
    end
    for key in pairs(activeLabels) do
        if key:sub(1, 5) == "Area_" and not seenUids[key:sub(6)] then
            removeLabel(key)
        end
    end
end

EggCmds.AreaEggUpdated:Connect(function(record)
    if Config.Enabled then refreshAreaEgg(record) end
end)

EggCmds.AreaEggRemoved:Connect(function(uid)
    removeLabel("Area_" .. uid)
end)

-- ===== EGG DI PLOT SENDIRI (LAGI TUMBUH) =====

local function getOwnPlotEggWorldCFrame(record)
    local placement = record.Placement
    if not placement then return nil end
    local plotData = PlotCmds.GetPlotData(LocalPlayer)
    if not plotData or not plotData.CenterPoint then return nil end
    return plotData.CenterPoint.CFrame * placement.LocalCFrame * CFrame.new(0, 2, 0)
end

local function refreshOwnPlacedEggs()
    local records = EggCmds.GetOwnerRuntimeRecords(LocalPlayer.UserId)
    local seenUids = {}
    if records then
        for uid, record in pairs(records) do
            seenUids[uid] = true
            local worldCFrame = getOwnPlotEggWorldCFrame(record)
            if worldCFrame then
                local petName = getPetDisplayName(record.AssetCategory)
                local mutationText, mutationColor = getMutationInfo(record)
                upsertLabel("Own_" .. uid, worldCFrame, petName, mutationText, mutationColor)
            end
        end
    end
    for key in pairs(activeLabels) do
        if key:sub(1, 4) == "Own_" and not seenUids[key:sub(5)] then
            removeLabel(key)
        end
    end
end

EggCmds.RuntimeOwnerUpdated:Connect(function(ownerUserId)
    if ownerUserId == LocalPlayer.UserId and Config.Enabled then
        refreshOwnPlacedEggs()
    end
end)

EggCmds.RuntimeOwnerCleared:Connect(function(ownerUserId)
    if ownerUserId == LocalPlayer.UserId then
        for key in pairs(activeLabels) do
            if key:sub(1, 4) == "Own_" then removeLabel(key) end
        end
    end
end)

-- ===== INIT =====

task.spawn(function()
    pcall(function() EggCmds.RequestAreaEggSnapshot() end)
    pcall(function() EggCmds.RequestRuntimeSnapshot() end)
    task.wait(0.5)
    refreshAllAreaEggs()
    refreshOwnPlacedEggs()
end)

-- ===== TOGGLE GUI (kecil, draggable) =====

local screenGui = Instance.new("ScreenGui")
screenGui.Name = GUI_NAME
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 140, 0, 36)
toggleButton.Position = UDim2.new(0, 10, 0.5, -18)
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.Text = "Egg ESP: ON"
toggleButton.Active = true
toggleButton.Draggable = true
toggleButton.Parent = screenGui

toggleButton.MouseButton1Click:Connect(function()
    Config.Enabled = not Config.Enabled
    toggleButton.Text = "Egg ESP: " .. (Config.Enabled and "ON" or "OFF")
    if Config.Enabled then
        refreshAllAreaEggs()
        refreshOwnPlacedEggs()
    else
        for key in pairs(activeLabels) do
            removeLabel(key)
        end
    end
end)

print("[Egg ESP] Loaded. Rainbow = pink, Golden = kuning, Silver = abu-abu terang.")
