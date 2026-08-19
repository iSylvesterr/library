-- GearAnalyzer v3 - Independent Seed Search
-- Mencari SEMUA seed yang valid untuk tiap cycle secara independen,
-- lalu kita akan lihat pola antar seed tersebut.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GearShopData = require(ReplicatedStorage.SharedModules.GearShopData)

local OBSERVED = {
    { cycle = 5939799, unix = 1781939700, items = { "Rare Sprinkler", "Super Sprinkler", "Invisibility Mushroom" } },
    { cycle = 5939801, unix = 1781940300, items = { "Common Sprinkler", "Speed Mushroom", "Basic Pot", "Flashbang" } },
    { cycle = 5939804, unix = 1781941200, items = { "Rare Sprinkler", "Jump Mushroom", "Shrink Mushroom" } },
    { cycle = 5939805, unix = 1781941500, items = { "Gnome" } },
    { cycle = 5939806, unix = 1781941800, items = { "Trowel" } },
}

-- Item yang di-predict oleh Rift Predictor (yang bisa restock berulang)
local TRACKED_ITEMS = {}
for _, gearInfo in ipairs(GearShopData.Data) do
    if gearInfo.RestockChance and gearInfo.RestockValues and not gearInfo.EquippableGear and not gearInfo.HideFromShop then
        TRACKED_ITEMS[gearInfo.ItemName] = true
    end
end

-- Pre-process
for _, obs in ipairs(OBSERVED) do
    local set = {}
    for _, name in ipairs(obs.items) do set[name] = true end
    obs.itemSet = set
    obs.itemCount = #obs.items
end

local function SimulateRestock(seed, variant)
    local rng = Random.new(seed)
    local result = {}
    for _, gearInfo in ipairs(GearShopData.Data) do
        local shouldRoll = false
        if gearInfo.RestockChance and gearInfo.RestockValues then
            if variant == 1 then
                shouldRoll = not gearInfo.EquippableGear and not gearInfo.HideFromShop
            elseif variant == 2 then
                shouldRoll = not gearInfo.EquippableGear
            elseif variant == 3 then
                shouldRoll = true
            end
        end

        if shouldRoll then
            local roll = rng:NextNumber() * 100
            if roll <= gearInfo.RestockChance then
                rng:NextInteger(gearInfo.RestockValues.Min, gearInfo.RestockValues.Max)
                result[gearInfo.ItemName] = true
            end
        end
    end
    return result
end

-- Strict Match: sim harus punya TEPAT item yang sama dengan observasi (untuk item yang di-track)
local function StrictMatch(sim, obsSet, obsCount)
    local simCount = 0
    for name, _ in pairs(sim) do
        if TRACKED_ITEMS[name] then
            simCount = simCount + 1
            if not obsSet[name] then return false end -- Ada item ekstra yang ngga harusnya ada
        end
    end
    return simCount == obsCount
end

print("══════════════════════════════════════════════════")
print("  GearAnalyzer v3 — Independent Seed Search")
print("  Mencari seed untuk 3 cycle pertama...")
print("══════════════════════════════════════════════════")
print("")

local SEARCH_RADIUS = 500000  -- cari +- 500k dari cycleID

for variant = 1, 3 do
    print("▶ Menggunakan RNG Variant: " .. variant)
    
    local foundAnyAll = true
    local cycleSeeds = {}
    
    for i, obs in ipairs(OBSERVED) do
        local center = obs.cycle
        local foundSeeds = {}
        
        -- Brute force independent
        local count = 0
        for seed = center - SEARCH_RADIUS, center + SEARCH_RADIUS do
            count = count + 1
            if count % 20000 == 0 then task.wait() end -- Yield supaya game tidak crash!
            
            local sim = SimulateRestock(seed, variant)
            if StrictMatch(sim, obs.itemSet, obs.itemCount) then
                table.insert(foundSeeds, seed)
                print(string.format("    [+] Ketemu seed: %d (di variant %d)", seed, variant))
            end
        end
        
        cycleSeeds[i] = foundSeeds
        print(string.format("  Cycle %d: Ditemukan %d candidate seed", obs.cycle, #foundSeeds))
        if #foundSeeds == 0 then foundAnyAll = false end
    end
    
    if foundAnyAll then
        print("")
        print("  Daftar seed kandidat per cycle:")
        for i, obs in ipairs(OBSERVED) do
            print(string.format("  Cycle %d seeds: %s", obs.cycle, table.concat(cycleSeeds[i], ", ")))
        end
        
        -- Coba cari pola offset konstan
        local c1 = cycleSeeds[1]
        local c2 = cycleSeeds[2]
        
        for _, s1 in ipairs(c1) do
            for _, s2 in ipairs(c2) do
                local offset1 = s1 - OBSERVED[1].cycle
                local offset2 = s2 - OBSERVED[2].cycle
                if offset1 == offset2 then
                    print(string.format("  🔥 POLA DITEMUKAN! Offset konstan: %d", offset1))
                end
            end
        end
    else
        print("  ❌ Tidak ada seed yang valid di semua cycle (pola tidak nyambung).")
    end
    print("──────────────────────────────────────────────────")
end
