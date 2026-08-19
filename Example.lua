-- Mengambil library dari NewUI.lua (bisa diganti loadstring dari URL jika sudah di-upload)
local Napoleon = loadfile("NewUI.lua")()
-- Jika kamu ingin memuatnya dari web, gunakan:
-- local Napoleon = loadstring(game:HttpGet("URL_SCRIPT_KAMU"))()

-- Membuat Window Utama
local Window = Napoleon:Window({
    Title = "Napoleon Hub",
    Footer = "By The Local Maze",
    Color = Color3.fromRGB(0, 255, 150),
    Color2 = Color3.fromRGB(255, 255, 255),
    Theme = "136289055140268", -- ID Image untuk background (opsional)
    ThemeTransparency = 0.5,
    LogoHUB = "136289055140268",
    WindowIMG = "136289055140268",
    ["Tab Width"] = 120,
    Version = 1,
})

-- Membuat Tab Baru
local MainTab = Window:AddTab({
    Name = "Main Menu",
    Icon = "player" -- Bisa menggunakan Icon bawaan (player, web, dll) atau ID gambar
})

-- Membuat Section (AlwaysOpen = true/false untuk menentukan apakah section bisa di minimize)
local PlayerSection = MainTab:AddSection("Player Features", true)

-- Menambahkan Paragraph (Teks Info)
PlayerSection:AddParagraph({
    Title = "Welcome!",
    Content = "Ini adalah script GUI menggunakan Napoleon UI. Kamu sedang berada di game: [UP] Just a baseplate.",
    Icon = "user"
})

-- Menambahkan Button
PlayerSection:AddButton({
    Title = "Print Hello World",
    SubTitle = "Sub Button (Opsional)",
    Callback = function()
        print("Hello World ditekan!")
        Napoleon:MakeNotify({
            Title = "Sukses",
            Description = "Button",
            Content = "Hello World berhasil di-print!",
            Color = Color3.fromRGB(0, 255, 150),
            Time = 0.5,
            Delay = 3
        })
    end,
    SubCallback = function()
        print("Sub Button ditekan!")
    end
})

-- Menambahkan Toggle
PlayerSection:AddToggle({
    Title = "Auto Farm",
    Title2 = "Mulai farming otomatis", -- Opsional
    Content = "Fitur ini akan membunuh monster secara otomatis.",
    Default = false,
    Callback = function(Value)
        print("Auto Farm status:", Value)
    end
})

-- Menambahkan Slider
PlayerSection:AddSlider({
    Title = "WalkSpeed",
    Content = "Mengatur kecepatan jalan karakter.",
    Increment = 1,
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

-- Menambahkan Panel dengan Text Input
PlayerSection:AddPanel({
    Title = "Target Player",
    Content = "Masukkan nama player yang ingin di-target",
    Placeholder = "Nama Player...",
    Default = "",
    ButtonText = "Set Target",
    Callback = function(text)
        print("Target di set ke:", text)
    end
})

-- Menambahkan Tab Tambahan
local SettingsTab = Window:AddTab({
    Name = "Settings",
    Icon = "settings"
})

local UISection = SettingsTab:AddSection("UI Settings", true)

UISection:AddButton({
    Title = "Tutup UI",
    Callback = function()
        -- Kamu bisa menekan F3 untuk toggle / menutup UI juga
        print("Tekan F3 untuk membuka / menutup UI.")
    end
})
