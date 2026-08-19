-- ============================================================
-- NAPOLEON | BRAINBLAST A LUCKY BLOCK (UNIVERSAL BYPASS & EXPLOITS)
-- ============================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")

_G.ScriptActive = true

-- ============================================================
-- LOAD NAPOLEON UI LIBRARY
-- ============================================================
local function LoadNapoleonUI()
    local url       = "https://raw.githubusercontent.com/Fdhlnn23/NapoleonUI/refs/heads/main/NPLN-UIv4.lua"
    local cacheName = "NPLN-UIv4_cached.lua"
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
        local func, err = loadstring(result)
        if func then
            local ok, lib = pcall(func)
            if ok and lib then return lib end
        end
    end
    return nil
end

local Library = LoadNapoleonUI()
if not Library then
    warn("Gagal load NapoleonUI!")
    return
end

local function notif(content, title)
    if Library and Library.MakeNotify then
        Library:MakeNotify({
            Title   = title or "Napoleon",
            Content = content or "",
            Delay   = 3,
            Icon    = "rbxassetid://136289055140268",
        })
    end
end

-- ============================================================
-- CONFIGURATION & STATE
-- ============================================================
local Config = {
    UnlockAllGP    = true,
    InstantX2Claim = true,
    AntiAFK        = true,
    SpamRate       = 0.05
}

local GAMEPASS_ATTRIBUTES = {
    "GP_x2Cash",           -- x2 Income from all sources
    "GP_AutoCollect",      -- Auto collect cash every 5s anywhere
    "GP_MoreUpgrades",     -- +10 Levels above maximum on upgrades
    "GP_X2MutationLuck",   -- x2 Probability of modifiers on lucky blocks
    "GP_X2Luck",           -- x2 Luck in blast (stackable)
    "GP_X2Brains",         -- x2 Brainpower when training
    "GP_X2BlastPower",     -- x2 Blast power in parabola
    "GP_VIP",              -- VIP Tag + x1.5 Luck + x1.5 Cash
    "GP_DoubleLuckyBlock", -- Throws 2 Lucky Blocks per blast instead of 1
    "GP_AutoPerfect",      -- Automatic Perfect power on every blast
    "GP_AutoX2",           -- Automatic X2 button click while training
    "GP_InstantlyTP",      -- Automatic TP to safezone after zombie spawn
    "IsVIP"                -- VIP Character flag override
}

local Remotes = ReplicatedStorage:WaitForChild("Remotes", 5)

-- ============================================================
-- 1. UNIVERSAL GAMEPASS BYPASS ENGINE
-- ============================================================
local function applyAllBypasses()
    if not Config.UnlockAllGP then return end
    for _, attr in ipairs(GAMEPASS_ATTRIBUTES) do
        LocalPlayer:SetAttribute(attr, true)
    end
    if LocalPlayer.Character then
        LocalPlayer.Character:SetAttribute("IsVIP", true)
    end
end

for _, attr in ipairs(GAMEPASS_ATTRIBUTES) do
    LocalPlayer:GetAttributeChangedSignal(attr):Connect(function()
        if Config.UnlockAllGP and LocalPlayer:GetAttribute(attr) ~= true then
            LocalPlayer:SetAttribute(attr, true)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if Config.UnlockAllGP then
        char:SetAttribute("IsVIP", true)
        applyAllBypasses()
    end
end)

-- Apply immediately on injection
applyAllBypasses()

-- ============================================================
-- 2. 0MS ZERO-LATENCY X2 BRAIN TRAINING HOOK
-- ============================================================
if Remotes and Remotes:FindFirstChild("Training") then
    local trainingRemotes = Remotes.Training
    local showX2Btn = trainingRemotes:FindFirstChild("ShowX2Button")
    local claimX2Bonus = trainingRemotes:FindFirstChild("ClaimX2Bonus")

    if showX2Btn and claimX2Bonus then
        showX2Btn.OnClientEvent:Connect(function()
            if Config.InstantX2Claim and _G.ScriptActive then
                pcall(function()
                    claimX2Bonus:FireServer()
                end)
            end
        end)
    end
end

-- ============================================================
-- 3. BACKGROUND EXPLOIT LOOP (INFINITE BRAIN SPAM)
-- ============================================================
task.spawn(function()
    while _G.ScriptActive do
        task.wait(Config.SpamRate)
        
        -- Auto Claim X2 / Infinite Brain Spam Exploit
        if Config.InstantX2Claim and Remotes and Remotes:FindFirstChild("Training") then
            local claimX2Bonus = Remotes.Training:FindFirstChild("ClaimX2Bonus")
            if claimX2Bonus then
                pcall(function()
                    claimX2Bonus:FireServer()
                end)
            end
        end
    end
end)

-- ============================================================
-- 4. ANTI AFK SYSTEM (FOOLPROOF)
-- ============================================================
task.spawn(function()
    pcall(function()
        if getconnections then
            for _, connection in pairs(getconnections(LocalPlayer.Idled)) do
                if type(connection) == "table" and connection.Disable then
                    connection:Disable()
                end
            end
        end
    end)
    
    LocalPlayer.Idled:Connect(function()
        if Config.AntiAFK and _G.ScriptActive then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
            end)
        end
    end)
end)

task.spawn(function()
    while task.wait(5) do
        if Config.AntiAFK and _G.ScriptActive then
            pcall(function()
                LocalPlayer:SetAttribute("AntiAfkIdleOverride", 9e9)
            end)
        end
    end
end)

task.spawn(function()
    while _G.ScriptActive do
        task.wait(300)
        if Config.AntiAFK then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Unknown, false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Unknown, false, game)
            end)
        end
    end
end)

-- ============================================================
-- 5. UI SETUP (NAPOLEON UI)
-- ============================================================
local Window = Library:Window({
    Title    = "Napoleon",
    Footer   = "Brainblast A Lucky Block",
    Color    = Color3.fromRGB(81, 66, 255),
    Color2   = Color3.fromRGB(0, 0, 14),
    ["Tab Width"] = 130,
    Image      = "111895858615511",
    WindowIMG  = "91334002283698",
    LogoHUB  = "136289055140268"
})

local MiscTab = Window:AddTab({ Name = "Misc", Icon = "rbxassetid://108886429866687" })
local GPSection = MiscTab:AddSection("Gamepass & VIP Bypass")

GPSection:AddToggle({
    Title    = "Unlock All Gamepass (Auto Re-apply)",
    Title2   = "Enable",
    Content  = "Otomatis mengaktifkan seluruh 12 Gamepass Robux (+10 Upgrade, Double Lucky Block, Auto Perfect, VIP, dll) secara gratis dan anti-reset.",
    Default  = Config.UnlockAllGP,
    Callback = function(val)
        Config.UnlockAllGP = val
        if val then
            applyAllBypasses()
            notif("Unlock All Gamepass diaktifkan!", "Napoleon")
        else
            notif("Unlock All Gamepass dinonaktifkan.", "Napoleon")
        end
    end
})

GPSection:AddToggle({
    Title    = "Auto Claim X2",
    Title2   = "Auto Claim X2",
    Content  = "Klaim otomatis bonus tombol X2 Brain sekaligus spam remote X2 untuk melipatgandakan Brainpower saat latihan (training).",
    Default  = Config.InstantX2Claim,
    Callback = function(val)
        Config.InstantX2Claim = val
        if val then
            notif("Auto Claim X2 diaktifkan!", "Napoleon")
        else
            notif("Auto Claim X2 dinonaktifkan.", "Napoleon")
        end
    end
})

GPSection:AddButton({
    Title   = "Force Re-Apply All Gamepasses",
    Content = "Paksa verifikasi dan aktifkan ulang semua 12 Gamepass & atribut VIP sekarang juga.",
    Callback = function()
        applyAllBypasses()
        notif("Berhasil mengaktifkan ulang 12 Gamepass!", "Napoleon")
    end
})

local AFKSection = MiscTab:AddSection("Anti AFK")

AFKSection:AddToggle({
    Title    = "Anti AFK",
    Title2   = "Anti AFK",
    Content  = "Mencegah kamu di-kick dari game setelah 20 menit diam (AFK).",
    Default  = Config.AntiAFK,
    Callback = function(val)
        Config.AntiAFK = val
        if val then
            notif("Anti AFK diaktifkan!", "Napoleon")
        else
            notif("Anti AFK dinonaktifkan.", "Napoleon")
        end
    end
})

notif("Script berhasil dimuat!", "Napoleon")
