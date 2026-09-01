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

## Built-in Info Tab

Setiap `Window` otomatis membuat tab `Info` sebagai tab pertama. Script pengguna tidak perlu menulis `Window:AddTab({ Name = "Info" })`.

Isi bawaan:

```text
Info Script Hub
└── Welcome to <Window Title>

[Discord Server Icon] Server Name
│   ├── Member Count
│   └── Online Count
└── [Copy Discord Invite] [Update Info]
```

`Script Information`, `Quick Guide`, `Community & Support`, dan heading tambahan di atas card Discord tidak ditampilkan. Data komunitas diambil secara asynchronous dari public Discord Invite API (`with_counts=true`) tanpa bot token. Request mendukung `syn.request`, `http.request`, `http_request`, `request`, dan fallback `game:HttpGet`. Jika request gagal, card berubah menjadi error state tanpa merusak tab Info.

Roblox `ImageLabel` tidak dapat menampilkan URL CDN Discord secara langsung. Zeroin mengunduh icon server ke `Zeroin/Cache/`, lalu mengubahnya menggunakan `getcustomasset()`. File memakai cache berdasarkan guild ID dan icon hash supaya tidak diunduh berulang kali. Jika executor tidak mendukung file/custom asset, logo Discord Footagesus digunakan sebagai fallback.

Tombol `Copy Discord Invite` menyalin invite yang sama dengan footer. Tombol `Update Info` mengambil ulang nama server, icon server, total member, dan online member. Atur invite dari config Window:

```lua
local Window = Zeroin:Window({
    Title = "My Script Hub",
    Version = "1.2.0",
    Discord = "https://discord.gg/yourinvite"
})
```

Tab Info dapat dimatikan bila benar-benar tidak diperlukan:

```lua
BuiltInInfo = false
```

Untuk kompatibilitas, script lama yang masih memanggil `AddTab({ Name = "Info" })` akan menerima tab Info bawaan dan tidak membuat duplikat.

## Membuat Tab dan Section

```lua
local MainTab = Window:AddTab({
    Name = "Main",
    Icon = "home"
})

-- Section selalu terbuka dan tidak dapat ditutup.
local FarmSection = MainTab:AddSection("Farming")
```

## Sistem Layout: Grid atau Independent Columns

Pilih layout saat membuat section:

```lua
-- Pair kiri/kanan disinkronkan sebagai baris.
local GridSection = Tab:AddSection({
    Title = "Grid Example",
    Layout = "Grid",
    ColumnGap = 6,
    ItemGap = 4
})

-- Kiri dan kanan memiliki vertical stack independen.
local ColumnsSection = Tab:AddSection({
    Title = "Compact Example",
    Layout = "Columns",
    ColumnGap = 6,
    ItemGap = 2
})
```

| Mode | Perilaku | Cocok untuk |
|---|---|---|
| `Grid` (default) | Tinggi kiri dan kanan disamakan per row | Pasangan komponen dengan tinggi serupa |
| `Columns` | Jarak vertikal kiri dan kanan dihitung secara independen | Toggle di kiri dan slider/dropdown/input di kanan |

Pada mode `Grid`, komponen kanan yang lebih tinggi membuat tinggi row kiri ikut membesar. Pada mode `Columns`, toggle berikutnya langsung berada `ItemGap` pixel di bawah toggle sebelumnya dan tidak dipengaruhi tinggi slider di kanan. Toggle title-only memakai tinggi compact 37px; dengan default `ItemGap = 2`, dua toggle tepat berjumlah 76px dan sejajar dengan satu dropdown standar.

`ColumnGap` mengatur jarak horizontal kiri-kanan. `ItemGap` mengatur jarak vertikal antar-item.

## Column, Row, dan FullWidth

Semua komponen dapat ditempatkan langsung dari script tanpa mengubah library:

```lua
Column = "Left"  -- sisi kiri
Column = "Right" -- sisi kanan
Column = "Full"  -- satu baris penuh
Row = 1           -- nomor baris (mulai dari 1)
```

Prioritas layout:

1. `Column + Row` menempatkan komponen secara eksplisit. Pada `Columns`, `Row` adalah urutan di dalam kolom tersebut.
2. `Column` tanpa `Row` mencari posisi kosong berikutnya pada sisi tersebut.
3. `FullWidth` tetap tersedia untuk kompatibilitas script lama.
4. Tanpa semua properti di atas, library memakai layout default komponen.

Jika slot yang diminta sudah terisi, Zeroin tidak menimpa komponen lama; komponen baru dipindahkan ke row kosong berikutnya pada kolom yang sama.

`Column = "Left"` atau `"Right"` otomatis menggunakan visual half-width. `Column = "Full"` otomatis menggunakan visual full-width.

### Dua toggle sama-sama di kiri, tetap rapat

```lua
local Section = Tab:AddSection({
    Title = "Farm",
    Layout = "Columns",
    ItemGap = 2
})

Section:AddToggle({
    Title = "Auto Collect",
    Column = "Left",
    Row = 1
})

Section:AddToggle({
    Title = "Auto Sell",
    Column = "Left",
    Row = 2
})
```

Hasil:

```text
Auto Collect | kosong
Auto Sell    | kosong
```

### Mengisi sisi kanan secara bebas

```lua
Section:AddDropdown({
    Title = "Target",
    Column = "Right",
    Row = 2,
    Options = {"Nearest", "Highest"}
})
```

Hasil:

```text
Auto Collect | kosong
Auto Sell    | Target dropdown
```

### Full row eksplisit

```lua
Section:AddSlider({
    Title = "Range",
    Column = "Full",
    Row = 3,
    Min = 10,
    Max = 100
})
```

### Kompatibilitas FullWidth

Setiap komponen masih mendukung properti `FullWidth`.

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

Dropdown menampilkan maksimal 5 opsi. Opsi tambahan dapat dicari dengan search atau internal scroll. Klik di luar atau Escape menutup popup. Popup memakai animasi `0.16s`: fade dan scale `0.96→1` saat buka, lalu `1→0.96` saat tutup, disertai pergeseran vertikal 5px dan rotasi chevron. Tween lama otomatis dibatalkan ketika selector diklik cepat agar state tidak glitch.

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

## Window Lifecycle, Cleanup, dan Execute Ulang

Zeroin memakai single-instance registry global. Ketika script dieksekusi ulang:

```text
Window lama ditemukan
→ full lifecycle Destroy window lama
→ toggle aktif menerima false
→ connection dan GUI internal lama dibersihkan
→ window baru dibuat
```

Jadi execute ulang tidak membuat dua Zeroin UI menumpuk dan tidak membutuhkan rejoin. Sebagai fallback, library juga menghapus `ZeroinOnTop`, `ToggleUIZeroin`, dan `NotifyGui` lama jika registry dari versi lama tidak tersedia atau proses sebelumnya terputus.

Registry hanya dapat dibersihkan oleh instance yang sedang aktif, sehingga cleanup window lama tidak akan menghapus referensi window baru.

Tombol silang juga menjalankan full lifecycle cleanup, bukan hanya menghapus GUI:

1. Semua toggle aktif dipanggil dengan `false` tanpa menimpa config tersimpan.
2. Semua callback `OnClose` dijalankan.
3. Semua resource dari `AddCleanup` dibersihkan.
4. Semua loop dari `Window:Spawn` dibatalkan.
5. Internal global connections, element registry, notification, floating button, dan GUI utama dibersihkan.

### Toggle feature

Callback toggle wajib menangani `false` untuk menghentikan fiturnya:

```lua
local AutoCollect = false

Section:AddToggle({
    Title = "Auto Collect",
    Callback = function(value)
        AutoCollect = value
    end
})
```

Saat window ditutup ketika toggle ON, callback otomatis menerima `false`.

### Loop yang otomatis berhenti

```lua
Window:Spawn(function(token)
    while token.Alive do
        if AutoCollect then
            -- auto collect logic
        end
        task.wait(0.1)
    end
end)
```

`Window:Spawn` mendaftarkan token dan thread sekaligus. Ketika window ditutup, token menjadi mati dan thread dibatalkan.

Alternatif manual:

```lua
local token = Window:CreateCleanupToken()

local thread = task.spawn(function()
    while token.Alive do
        task.wait(0.1)
    end
end)

Window:AddCleanup(thread)
```

### Connection

```lua
local connection = game:GetService("RunService").Heartbeat:Connect(function()
    if AutoCollect then
        -- feature logic
    end
end)

Window:AddCleanup(connection)
```

Connection otomatis di-`Disconnect()` saat close.

### Instance, ESP, Highlight, Folder, atau object sementara

```lua
local folder = Instance.new("Folder")
folder.Name = "MyScriptRuntime"
folder.Parent = workspace

Window:AddCleanup(folder)
```

Instance otomatis di-`Destroy()` saat close.

### Custom cleanup callback

```lua
Window:AddCleanup(function()
    -- Hapus table cache, reset character property, matikan noclip, dll.
end)
```

Atau gunakan callback khusus close:

```lua
Window:OnClose(function()
    AutoCollect = false
    AutoSell = false
end)
```

### API lifecycle

```lua
Window:AddCleanup(resource)      -- function/connection/instance/thread/object
Window:OnClose(callback)         -- callback final ketika close
Window:CreateCleanupToken()      -- token dengan properti Alive
Window:Spawn(callback)           -- managed task + token
Window:IsDestroyed()             -- true setelah cleanup dimulai
Window:Destroy()                 -- full cleanup programmatic
Window:Close()                   -- alias full cleanup
Window:DestroyGui()              -- alias lama, sekarang full cleanup
```

`AddCleanup` mendukung:

- Function
- `RBXScriptConnection`
- `Instance`
- Luau thread
- Object table yang memiliki method `Cleanup`, `Destroy`, `Disconnect`, atau `Cancel`

> Library tidak dapat menebak semua resource yang dibuat script pengguna. Semua connection, loop, ESP, instance, hook wrapper, dan perubahan state milik feature harus didaftarkan melalui API lifecycle atau dipulihkan dalam callback toggle `false`/`OnClose`.

## Automatic Game Name Chip

Topbar otomatis menampilkan nama game aktif dengan tampilan yang sama seperti chip FPS dan executor:

```text
[Gamepad] Nama Game | [Chart] FPS | [Plug] Executor
```

Nama dideteksi melalui `MarketplaceService:GetProductInfo(game.PlaceId).Name` secara asynchronous, dengan fallback ke `game.Name`. Nama yang melebihi 20 karakter dipotong dengan ellipsis agar topbar tetap rapi; nama lengkap dan PlaceId tersimpan pada attributes `FullGameName` dan `PlaceId` di `GameFrame`. Tidak perlu mengisi nama game pada config Window.

## Window Controls

- Minimize: tombol minimize dengan animasi ringan.
- Restore: floating logo atau `F3`.
- Fullscreen: tombol fullscreen.
- Close: confirmation dialog dan full lifecycle cleanup.
- Window dapat di-drag dan di-resize.

## Footagesus Icon Pack

Icon generik Zeroin sekarang menggunakan vendored [Footagesus Icons](https://github.com/FyyWannaFly/FyyUI/tree/main/vendor/footagesus-icons) dengan lisensi MIT. Source dipisah dari `ZeroLib.lua`:

```text
ZeroinIcons.lua
vendor/footagesus-icons/
├── lucide/dist/Icons.lua
├── geist/dist/Icons.lua
├── craft/dist/Icons.lua
├── gravity/dist/Icons.lua
├── solar/dist/Icons.lua
├── sfsymbols/dist/Icons.lua
└── LICENSE
```

Runtime default hanya memuat `ZeroinIcons.lua` berisi Lucide plus metadata brand yang diperlukan agar tetap ringan. Seluruh vendor pack tetap tersedia di repository sebagai source terpisah. Footer Discord menggunakan `geist:logo-discord` dari spritesheet Footagesus—bukan generic chat bubble—dengan `ImageRectOffset` dan `ImageRectSize` yang tepat.

### Menggunakan nama Lucide langsung

```lua
Window:AddTab({
    Name = "Main",
    Icon = "house"
})

Window:AddTab({
    Name = "Security",
    Icon = "shield-check"
})

Section:AddParagraph({
    Title = "Profile",
    Content = "Player information",
    Icon = "circle-user-round"
})
```

Contoh nama icon:

```text
house, info, repeat-2, backpack, shield-check, bot,
circle-user-round, settings, search, bell, crown, swords,
chart-no-axes-column-increasing, map-pin, gamepad-2,
shopping-cart, credit-card, eye, star, skull, fish
```

Nama dapat ditulis dengan prefix opsional:

```lua
Icon = "lucide:house"
```

### Alias script lama

Nama Zeroin lama tetap didukung dan otomatis dipetakan ke Footagesus/Lucide:

```text
home→house, bag→backpack, loop→repeat-2, player→user-round,
shop→store, cart→shopping-cart, stat→chart-no-axes-column-increasing,
eyes→eye, sword→swords, discord→message-circle
```

### API icon

```lua
local iconAsset = Zeroin:GetIcon("shield-check")
local iconData = Zeroin:GetIconData("discord") -- spritesheet metadata
local exists = Zeroin:HasIcon("shield-check")
local allNames = Zeroin:GetIconNames()
```

Jika `Icon` berisi asset ID atau URL alih-alih nama pack, resolver tetap memakai nilai custom tersebut sebagai fallback.

Logo Zeroin, watermark, floating logo, dan shadow texture tetap memakai asset branding sendiri karena bukan generic UI icon.
