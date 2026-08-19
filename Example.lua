-- Mengambil library dari NewUI.lua (bisa diganti loadstring dari URL jika sudah di-upload)
local Napoleon = loadstring(game:HttpGet("https://raw.githubusercontent.com/iSylvesterr/library/refs/heads/main/NewUI.lua"))()

-- Membuat Window Utama seperti di Steal An Egg.lua
local Window = Napoleon:Window({
    Title = "Napoleon",
    Footer = "Steal An Egg",
    Color = Color3.fromRGB(50, 50, 50), -- Warna abu-abu elegan/metalik seperti logo
    Color2 = Color3.fromRGB(20, 20, 20), -- Background abu-abu gelap (tidak ungu)
    ["Tab Width"] = 130,
    Image = "111895858615511",
    WindowIMG = "91334002283698",
    LogoHUB = "119958938217417"
})

-- Membuat Tab Baru
local MainTab = Window:AddTab({
    Name = "Main Menu",
    Icon = "home"
})

-- Membuat Section (AlwaysOpen = true)
local ExampleSection = MainTab:AddSection("Example Features", true)

ExampleSection:AddParagraph({
    Title = "Welcome!",
    Content = "Ini adalah script GUI menggunakan Napoleon UI. Konfigurasi window sudah disamakan dengan Steal An Egg.lua.",
    Icon = "user"
})

ExampleSection:AddButton({
    Title = "Print Hello",
    Callback = function()
        print("Hello World!")
        Napoleon:MakeNotify({
            Title = "Sukses",
            Content = "Berhasil klik tombol!",
            Color = Color3.fromRGB(81, 66, 255),
            Delay = 3
        })
    end
})

ExampleSection:AddToggle({
    Title = "Example Toggle",
    Default = false,
    Keybind = true,
    Callback = function(Value)
        print("Toggle diubah menjadi:", Value)
    end
})
