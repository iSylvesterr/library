local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProximityPromptService = game:GetService("ProximityPromptService")

-- Mendapatkan modul HatchReveal dan RollingHud
local HatchReveal = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Services"):WaitForChild("PlotStationsService"):WaitForChild("HatchReveal"))
local RollingHud = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Services"):WaitForChild("PlotStationsService"):WaitForChild("RollingHud"))

-- 1. Hook task.wait & task.delay KHUSUS untuk HatchReveal agar TIDAK ADA JEDA SAMA SEKALI
-- Menggunakan pcall untuk keamanan agar tidak merusak script lain
if hookfunction then
    local oldWait
    oldWait = hookfunction(task.wait, function(n)
        local success, source = pcall(debug.info, 2, "s")
        if success and source and source:match("HatchReveal") then
            -- Memberikan fake delta-time besar tanpa yield (menunggu)
            -- Semua loop animasi akan selesai di frame yang sama secara instan!
            return 999 
        end
        return oldWait(n)
    end)

    local oldDelay
    oldDelay = hookfunction(task.delay, function(t, cb)
        local success, source = pcall(debug.info, 2, "s")
        if success and source and source:match("HatchReveal") then
            -- Memaksa jeda 1 detik sebelum tombol "Buy" muncul menjadi 0 detik
            return oldDelay(0, cb)
        end
        return oldDelay(t, cb)
    end)
end

-- Simpan fungsi aslinya
local oldHatchPlay = HatchReveal.play
local oldRollingTick = RollingHud.tick
local oldRollingReveal = RollingHud.reveal

-- Bypass/Hook HatchReveal.play (Animasi 3D unboxing telur)
HatchReveal.play = function(...)
    local args = {...}
    args[7] = math.huge -- Kecepatan maksimal absolut
    
    local userId = args[1]
    local station = args[3]
    
    -- Kembalikan fitur Instant Ready (tanpa delay) seperti sebelumnya!
    -- Kita hanya memberi sinyal "Animasi Selesai" ke server supaya kamu bisa spam Roll.
    -- KITA TIDAK AUTO-BUY, jadi tombol Buy manual kamu tetap berfungsi normal tanpa bug!
    if userId == game:GetService("Players").LocalPlayer.UserId and station then
        task.spawn(function()
            task.wait()
            local Network = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"))
            Network.send("hatch_ready", station)
        end)
    end
    
    return oldHatchPlay(unpack(args))
end

-- Bypass/Hook RollingHud.tick (Animasi 2D Roll)
RollingHud.tick = function(...)
    local args = {...}
    args[3] = 0 -- 0 detik durasi animasi tween
    return oldRollingTick(unpack(args))
end

RollingHud.reveal = function(...)
    local args = {...}
    return oldRollingReveal(unpack(args))
end

-- 2. Hapus Waktu Tahan (HoldDuration) dari Tombol Roll!
local Plots = workspace:WaitForChild("Plots", 5)

local function optimizePrompt(prompt)
    if prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0 -- Klik jadi instan tanpa ditekan lama
        
        -- HANYA terapkan spam bypass ke tombol Roll!
        if prompt.ActionText == "Roll!" or prompt.ActionText:match("Roll") then
            prompt:GetPropertyChangedSignal("Enabled"):Connect(function()
                if not prompt.Enabled then
                    prompt.Enabled = true
                end
            end)
            prompt.Enabled = true
        end
    end
end

if Plots then
    for _, obj in Plots:GetDescendants() do
        optimizePrompt(obj)
    end
    Plots.DescendantAdded:Connect(optimizePrompt)
end

-- =========================================================================
-- FITUR TAMBAHAN: ROLL LOGS UI
-- =========================================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Membuat UI Container
local UI = Instance.new("ScreenGui")
UI.Name = "FastRollLogsUI"
UI.ResetOnSpawn = false

-- Menggunakan gethui() jika ada (agar tidak terdeteksi game), jika tidak pakai CoreGui/PlayerGui
local targetGui = (pcall(function() return gethui() end) and gethui()) or (CoreGui:FindFirstChild("RobloxGui") and CoreGui) or LocalPlayer:WaitForChild("PlayerGui")
UI.Parent = targetGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(1, -320, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
Frame.BorderSizePixel = 0
Frame.Parent = UI

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = " Gacha Logs (Bisa Digeser)"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Frame

-- Fungsi agar UI bisa digeser (Draggable)
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)
Title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, 0, 1, -30)
Scroll.Position = UDim2.new(0, 0, 0, 30)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 4
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = Frame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Scroll
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local logCount = 0
local function addLogToUI(itemName)
    logCount = logCount + 1
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = (logCount % 2 == 0) and 0 or 1
    label.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    label.TextColor3 = Color3.fromRGB(150, 255, 150)
    label.Text = string.format(" [%d] %s", logCount, itemName)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = Scroll
    
    -- Auto scroll ke paling bawah setiap ada log baru
    task.spawn(function()
        task.wait()
        Scroll.CanvasPosition = Vector2.new(0, Scroll.AbsoluteCanvasSize.Y)
    end)
end

-- Menyadap (Intercept) sinyal Remote Event untuk mendapatkan hasil Gacha asli dari Server
local BounceEvent = ReplicatedStorage:WaitForChild("BounceEvent", 3)
if BounceEvent then
    BounceEvent.OnClientEvent:Connect(function(action, userId, station, eggType, categories, items, ...)
        if action == "station_hatch" and userId == LocalPlayer.UserId then
            if type(items) == "table" then
                for _, item in ipairs(items) do
                    addLogToUI(tostring(item))
                end
            end
        end
    end)
end

print("Fast Roll Kilat (NO DELAY) + UI Logs berhasil diaktifkan!")
