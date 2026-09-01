# Zeroin UI Library

Dokumentasi penggunaan `ZeroLib.lua` untuk script Roblox.

## Quick Start

```lua
local Zeroin = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/iSylvesterr/library/refs/heads/main/ZeroLib.lua"
))()

local Window = Zeroin:Window({
    Title = "Zeroin",
    Color = Color3.fromRGB(0, 205, 122),
    Color2 = Color3.fromRGB(4, 28, 18),
    ["Tab Width"] = 130,
    Image = "79481584966698",      -- floating open button
    WindowIMG = "124404129684886", -- watermark dalam window
    LogoHUB = "124404129684886",   -- logo header
    Version = 1
})
```

## Membuat Tab dan Section

```lua
local MainTab = Window:AddTab({
    Name = "Main",
    Icon = "home"
})

-- Section selalu terbuka dan tidak dapat ditutup.
local FarmSection = MainTab:AddSection("Farming")
```

## Sistem Layout: FullWidth

Setiap komponen mendukung properti `FullWidth`.

| Komponen | Default | Untuk mengubah |
|---|---:|---|
| `AddToggle` | Setengah baris | `FullWidth = true` untuk satu baris penuh |
| `AddDropdown` | Penuh | `FullWidth = false` untuk setengah baris |
| `AddSlider` | Penuh | `FullWidth = false` untuk setengah baris |
| `AddInput` | Penuh | `FullWidth = false` untuk setengah baris |
| `AddButton` | Penuh | `FullWidth = false` untuk setengah baris |
| `AddParagraph` | Penuh | `FullWidth = false` untuk setengah baris |
| `AddPanel` | Penuh | `FullWidth = false` untuk setengah baris |

Komponen setengah baris ditempatkan berdasarkan urutan:

```text
Komponen ke-1 -> kiri
Komponen ke-2 -> kanan
Komponen ke-3 -> kiri pada row berikutnya
Komponen ke-4 -> kanan pada row berikutnya
```

Jika hanya ada satu komponen setengah baris lalu komponen penuh dibuat, sisi kanan row sebelumnya dibiarkan kosong.

## Contoh Layout Lengkap

Target layout:

```text
Paragraph                       (full)
Toggle Kiri | Toggle Kanan      (1:1)
Toggle Kiri | Toggle Kanan      (1:1)
Dropdown Kiri | Dropdown Kanan  (1:1)
Dropdown                        (full)
Slider                          (full)
Button                          (full)
```

Kode:

```lua
local Section = MainTab:AddSection("Auto Farm")

Section:AddParagraph({
    Title = "Information",
    Content = "Paragraph panjang otomatis wrap dan menyesuaikan tinggi.",
    Icon = "info"
})

Section:AddToggle({
    Title = "Auto Collect",
    Default = false,
    Callback = function(value)
        print("Auto Collect:", value)
    end
})

Section:AddToggle({
    Title = "Auto Sell",
    Default = false,
    Callback = function(value)
        print("Auto Sell:", value)
    end
})

Section:AddToggle({
    Title = "Auto Upgrade",
    Content = "Toggle dengan description otomatis memakai layout title di atas.",
    Default = false,
    Callback = function(value)
        print("Auto Upgrade:", value)
    end
})

Section:AddToggle({
    Title = "Auto Rebirth",
    Default = false,
    Callback = function(value)
        print("Auto Rebirth:", value)
    end
})

-- Dropdown setengah baris kiri.
Section:AddDropdown({
    Title = "Target",
    Content = "Select target",
    FullWidth = false,
    Options = {"Nearest", "Highest", "Random"},
    Default = "Nearest",
    Callback = function(value)
        print("Target:", value)
    end
})

-- Dropdown setengah baris kanan.
Section:AddDropdown({
    Title = "Rarity",
    Content = "Select rarity",
    FullWidth = false,
    Options = {"Common", "Rare", "Epic", "Legendary"},
    Default = "Rare",
    Callback = function(value)
        print("Rarity:", value)
    end
})

-- Dropdown full row (default).
Section:AddDropdown({
    Title = "Item Filter",
    Options = {"All", "Weapons", "Pets", "Materials"},
    Default = "All",
    Callback = function(value)
        print("Item Filter:", value)
    end
})

Section:AddSlider({
    Title = "Range",
    Content = "Maximum detection range",
    Min = 10,
    Max = 100,
    Increment = 1,
    Default = 50,
    Callback = function(value)
        print("Range:", value)
    end
})

Section:AddButton({
    Title = "Start Farm",
    Callback = function()
        print("Farm started")
    end
})
```

## Toggle

```lua
local Toggle = Section:AddToggle({
    Title = "Auto Collect",
    Content = "Optional description",
    Title2 = "Optional subtitle",
    Default = false,
    Keybind = true,
    FullWidth = false,
    Callback = function(value)
        print(value)
    end
})

Toggle:Set(true)
print(Toggle.Value)
```

Catatan:

- Tanpa `Content` dan `Title2`, title otomatis center vertikal.
- Dengan description, title berada di atas dan description wrap di bawah.
- Toggle hanya berubah ketika switch kanan diklik, bukan saat title diklik.

## Dropdown

### Single Select

```lua
local Dropdown = Section:AddDropdown({
    Title = "Target",
    Content = "Choose one target",
    Options = {"Nearest", "Highest", "Random"},
    Default = "Nearest",
    Multi = false,
    FullWidth = true,
    Callback = function(value)
        print(value)
    end
})
```

### Multi Select

```lua
local MultiDropdown = Section:AddDropdown({
    Title = "Rarities",
    Options = {"Common", "Rare", "Epic", "Legendary"},
    Default = {"Rare", "Epic"},
    Multi = true,
    Callback = function(values)
        for _, value in ipairs(values) do
            print(value)
        end
    end
})
```

### Mengubah opsi secara runtime

```lua
Dropdown:SetValues({"Player 1", "Player 2", "Player 3"}, "Player 1")
Dropdown:SetValue("Player 2")
print(Dropdown:GetValue())
Dropdown:Clear()
```

Dropdown menampilkan maksimal 5 opsi. Opsi tambahan dapat dicari dengan search atau internal scroll. Klik di luar atau Escape menutup popup.

## Slider

```lua
local Slider = Section:AddSlider({
    Title = "Walk Speed",
    Content = "Character movement speed",
    Min = 16,
    Max = 200,
    Increment = 1,
    Default = 16,
    FullWidth = true,
    Callback = function(value)
        print(value)
    end
})

Slider:Set(50)
print(Slider.Value)
```

- Drag slider memakai hit area 24px agar mudah dikontrol.
- Saat drag, fill mengikuti pointer tanpa tween lag.
- Textbox menerima input parsial; nilai baru di-commit saat focus dilepas/Enter.
- Nilai otomatis di-clamp ke `Min` dan `Max`.

## Input

```lua
local Input = Section:AddInput({
    Title = "Player Name",
    Content = "Type exact username",
    Default = "",
    FullWidth = true,
    Callback = function(value)
        print(value)
    end
})

Input:Set("Builderman")
print(Input.Value)
```

## Button

```lua
Section:AddButton({
    Title = "Start",
    SubTitle = "Stop", -- optional dual button
    FullWidth = true,
    Callback = function()
        print("Start")
    end,
    SubCallback = function()
        print("Stop")
    end
})
```

## Paragraph

```lua
local Paragraph = Section:AddParagraph({
    Title = "Information",
    Content = "Long content automatically wraps and resizes the paragraph.",
    Icon = "info",
    ButtonText = "Copy",
    ButtonCallback = function()
        print("Copied")
    end
})

Paragraph:SetTitle("Updated Title")
Paragraph:SetContent("Updated long content")
```

## Panel

```lua
local Panel = Section:AddPanel({
    Title = "Profile",
    Content = "Save or load a profile",
    Placeholder = "Profile name",
    Default = "Default",
    ButtonText = "Save",
    SubButtonText = "Load",
    Callback = function(text)
        print("Save", text)
    end,
    SubButtonCallback = function(text)
        print("Load", text)
    end
})

print(Panel:GetInput())
```

## Divider dan SubSection

```lua
Section:AddDivider()
Section:AddSubSection("Advanced")
```

## Notification

```lua
Zeroin:MakeNotify({
    Title = "Zeroin",
    Description = "Success",
    Content = "Feature enabled successfully.",
    Color = Color3.fromRGB(0, 205, 122),
    Delay = 3
})
```

## Config Tab

```lua
-- Tambahkan setelah semua tab/komponen utama dibuat.
Window:AddConfigTab()
```

Config menyimpan toggle, dropdown, slider, dan input berdasarkan judul komponennya.

## Window Controls

- Minimize: tombol minimize dengan animasi ringan.
- Restore: floating logo atau `F3`.
- Fullscreen: tombol fullscreen.
- Close: confirmation dialog.
- Window dapat di-drag dan di-resize.

## Built-in Icon Names

Beberapa icon bawaan yang tersedia:

```text
home, info, player, user, bag, shop, cart, plug, settings,
loop, gps, compas, gamepad, boss, scroll, menu, crosshair,
stat, eyes, sword, discord, star, skeleton, payment, scan,
alert, question, idea, water, start, next, rod, fish
```

`home` dan `info` pada tab dirender sebagai native Lucide-style icons agar selalu tersedia.
