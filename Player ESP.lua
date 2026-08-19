-- Player ESP
-- Box/Highlight tembus tembok buat semua player lain. Generic Roblox API (Highlight + DepthMode
-- AlwaysOnTop), gak gantung ke data game-specific -- jadi bisa jalan di game manapun.

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local GUI_NAME = "NapoleonPlayerESPGui"

-- ============================================================
-- SELF-PERSIST ACROSS TELEPORT (round abis / menang-kalah / balik lobby)
-- Di game round-based (kayak CS), abis menang/kalah biasanya kamu di-TELEPORT (server/place
-- baru, bukan cuma karakter di-respawn di tempat) -- itu bikin SELURUH script Lua ke-reset
-- total, termasuk watchdog highlight-nya. Watchdog gak bakal bisa nolong kasus ini karena
-- scriptnya sendiri ikut mati. Fix-nya: titipkan diri sendiri ke queue_on_teleport (kayak
-- yang udah proven jalan di Anti AFK "Steal An Egg.lua"), jadi begitu landing di server/round
-- baru, executor otomatis nge-run script ini lagi dari awal -- gak perlu re-exe manual.
-- ============================================================
local AUTOEXEC_BACKUP_PATH = "autoexec/Player ESP.lua"

local function getOwnScriptSource()
    if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" then
        return nil, "readfile/isfile gak ada di executor ini"
    end

    local ok, info = pcall(debug.getinfo, 1, "S")
    local src = ok and info and info.source or ""
    local path = src:gsub("^@", "")

    if path ~= "" and isfile(path) then
        local content = readfile(path)
        if content and #content >= 500 then
            return content
        end
    end

    -- Fallback: kalau path asli gagal (misal script-nya di-paste langsung ke exec box,
    -- bukan dijalanin dari file), coba baca balik backup autoexec dari sesi sebelumnya.
    if isfile(AUTOEXEC_BACKUP_PATH) then
        local backupContent = readfile(AUTOEXEC_BACKUP_PATH)
        if backupContent and #backupContent >= 500 then
            return backupContent
        end
    end

    return nil, "Gak nemu source sendiri lewat path: '" .. tostring(path) .. "', dan gak ada backup autoexec juga"
end

local function selfInstallAutoExec()
    pcall(function()
        if typeof(writefile) ~= "function" or typeof(isfolder) ~= "function" or typeof(makefolder) ~= "function" then
            return
        end
        local content = getOwnScriptSource()
        if not content then return end
        if not isfolder("autoexec") then
            makefolder("autoexec")
        end
        writefile(AUTOEXEC_BACKUP_PATH, content)
    end)
end

local function queueSelfForTeleport()
    local queueFunc = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport)
    if not queueFunc then
        warn("[Player ESP] Executor gak punya queue_on_teleport -- abis round/teleport, ESP perlu di-exe manual lagi.")
        return false
    end

    local ownSource, srcErr = getOwnScriptSource()
    if not ownSource then
        warn("[Player ESP] Gagal ambil source sendiri buat dititipkan ke queue_on_teleport:", srcErr)
        return false
    end

    local qok, qerr = pcall(queueFunc, ownSource)
    if not qok then
        warn("[Player ESP] queue_on_teleport gagal:", qerr)
    end
    return qok
end

-- Backup dulu ke autoexec (buat fallback source), BARU titipkan ke queue_on_teleport.
-- Dipanggil UNCONDITIONAL tiap script ini jalan (termasuk pas re-exec abis teleport),
-- jadi rantai "titip lagi buat teleport BERIKUTNYA" ini nyambung terus tanpa putus.
selfInstallAutoExec()
queueSelfForTeleport()

-- Bersihin sisa run sebelumnya kalo script ini di-exe ulang
local oldGui = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild(GUI_NAME)
if oldGui then oldGui:Destroy() end

local Config = {
    Enabled = true,
}

local ESP_COLOR = Color3.fromRGB(255, 60, 60)
local FILL_TRANSPARENCY = 0.75
local OUTLINE_TRANSPARENCY = 0

-- [player] = { Highlight = <Instance>, Character = <Model> } -- nyimpen Character juga biar
-- watchdog bisa ketauan kalo player udah ganti karakter (respawn) tapi highlight lama masih
-- ke-tag "aktif" padahal nempel ke karakter yang udah gak ada lagi.
local activeHighlights = {}

local function removeHighlight(player)
    local entry = activeHighlights[player]
    if entry then
        if entry.Highlight then
            entry.Highlight:Destroy()
        end
        activeHighlights[player] = nil
    end
end

local function addHighlight(player, character)
    removeHighlight(player)
    if not Config.Enabled or not character then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "NapoleonPlayerESP"
    highlight.Enabled = true
    highlight.FillColor = ESP_COLOR
    highlight.OutlineColor = ESP_COLOR
    highlight.FillTransparency = FILL_TRANSPARENCY
    highlight.OutlineTransparency = OUTLINE_TRANSPARENCY
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = character
    highlight.Parent = character

    activeHighlights[player] = { Highlight = highlight, Character = character }
end

local function onCharacterAdded(player, character)
    if player == LocalPlayer then return end
    addHighlight(player, character)
end

local function onPlayerAdded(player)
    if player == LocalPlayer then return end

    player.CharacterAdded:Connect(function(character)
        onCharacterAdded(player, character)
    end)
    player.CharacterRemoving:Connect(function()
        removeHighlight(player)
    end)

    if player.Character then
        onCharacterAdded(player, player.Character)
    end
end

local function onPlayerRemoving(player)
    removeHighlight(player)
end

for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Watchdog: game ini ternyata punya sistem Highlight sendiri buat tim (ReplicatedStorage.Classes
-- .CharacterHighlight, dipasang ulang tiap round lewat Observers/Character.lua) yang keliatannya
-- bentrok sama punya kita entah lewat cara apa persis (destroy, Enabled=false, atau override lain).
-- Daripada coba nebak-nebak detail persisnya, kita brute-force aja: TIAP TICK, hancurin punya kita
-- yang lama dan bikin yang baru dari nol -- gak peduli state sebelumnya kayak apa. Jadi walau ada
-- apa pun di luar sana yang ganggu instance kita, paling lama nunggu 1 tick buat balik normal.
task.spawn(function()
    while true do
        if Config.Enabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local character = player.Character
                    if character then
                        addHighlight(player, character)
                    else
                        removeHighlight(player)
                    end
                end
            end
        end
        task.wait(1)
    end
end)

do
    local otherPlayerCount = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            otherPlayerCount = otherPlayerCount + 1
        end
    end
    print(("[Player ESP] Player lain di server sekarang: %d"):format(otherPlayerCount))
    if otherPlayerCount == 0 then
        warn("[Player ESP] Gak ada player lain di server ini -- makanya belum ada box yang muncul. ESP-nya udah aktif, tinggal nunggu ada player lain join.")
    end
end

-- ===== TOGGLE GUI (kecil, draggable) =====

local screenGui = Instance.new("ScreenGui")
screenGui.Name = GUI_NAME
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 140, 0, 36)
toggleButton.Position = UDim2.new(0, 10, 0.5, 28)
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.Text = "Player ESP: ON"
toggleButton.Active = true
toggleButton.Draggable = true
toggleButton.Parent = screenGui

toggleButton.MouseButton1Click:Connect(function()
    Config.Enabled = not Config.Enabled
    toggleButton.Text = "Player ESP: " .. (Config.Enabled and "ON" or "OFF")

    if Config.Enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                addHighlight(player, player.Character)
            end
        end
    else
        for player in pairs(activeHighlights) do
            removeHighlight(player)
        end
    end
end)

print("[Player ESP] Loaded.")
