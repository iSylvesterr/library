local Napoleon = loadfile('d:/Documents/Napoleon_Source/NewUI.lua')(); -- Membuat Window Utama seperti di Steal An Egg.lua
local Window = Napoleon:Window({
    Title = "Napoleon",
    Footer = "Steal An Egg",
    Color = Color3.fromRGB(81, 66, 255),
    Color2 = Color3.fromRGB(0, 0, 14),
    ["Tab Width"] = 130,
    Image = "111895858615511",
    WindowIMG = "91334002283698",
    LogoHUB = "136289055140268"
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

