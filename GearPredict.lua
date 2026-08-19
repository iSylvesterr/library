local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GearShopData = require(ReplicatedStorage.SharedModules.GearShopData)
local GearShop = ReplicatedStorage:WaitForChild("StockValues"):WaitForChild("GearShop")
local Items = GearShop:WaitForChild("Items")
local UnixNextRestock = GearShop:WaitForChild("UnixNextRestock")
local UnixLastRestock = GearShop:WaitForChild("UnixLastRestock")

local BRUTE_OFFSET_RANGE = 50
local INTERVALS = { 300, 360, 600, 900, 1800 }

-- Hanya item yang benar-benar di-restock secara random (punya RestockChance + RestockValues, bukan equippable, bukan hidden)
local RESTOCKABLE = {}
for _, gearInfo in ipairs(GearShopData.Data) do
	if gearInfo.RestockChance and gearInfo.RestockValues
		and not gearInfo.EquippableGear
		and not gearInfo.HideFromShop then
		RESTOCKABLE[gearInfo.ItemName] = true
	end
end

local function GetRealStock()
	local real = {}
	for _, item in ipairs(Items:GetChildren()) do
		-- Hanya baca item yang memang restockable, skip equippable/owned items
		if RESTOCKABLE[item.Name] and item.Value > 0 then
			real[item.Name] = item.Value
		end
	end
	return real
end

local function SimulateRestock(seed)
	local rng = Random.new(seed)
	local result = {}
	for _, gearInfo in ipairs(GearShopData.Data) do
		if gearInfo.RestockChance and gearInfo.RestockValues
			and not gearInfo.EquippableGear
			and not gearInfo.HideFromShop then
			local roll = rng:NextNumber() * 100
			if roll <= gearInfo.RestockChance then
				local qty = rng:NextInteger(gearInfo.RestockValues.Min, gearInfo.RestockValues.Max)
				result[gearInfo.ItemName] = qty
			end
		end
	end
	return result
end

-- Score: match dikurangi false positive (item diprediksi tapi tidak di stok nyata)
-- Makin tinggi score makin bagus. Ini mencegah seed yang "lucky match" tapi banyak salah
local function ScoreMatch(real, predicted)
	local match = 0
	local total = 0
	local falsePositive = 0
	for name, _ in pairs(real) do
		total = total + 1
		if predicted[name] then match = match + 1 end
	end
	for name, _ in pairs(predicted) do
		if not real[name] then falsePositive = falsePositive + 1 end
	end
	-- Score = match bersih dikurangi penalty false positive
	local score = match - (falsePositive * 0.5)
	return score, match, total
end

local lastUnix = UnixLastRestock.Value
local nextUnix = UnixNextRestock.Value

-- Build formula table (silent)
local formulas = {}
table.insert(formulas, { label = "raw UnixLast", seed = lastUnix })
table.insert(formulas, { label = "raw UnixNext", seed = nextUnix })

for _, interval in ipairs(INTERVALS) do
	local cycleID = math.floor(lastUnix / interval)
	local nextCycleID = math.floor(nextUnix / interval)

	table.insert(formulas, { seed = cycleID, interval = interval })
	table.insert(formulas, { seed = nextCycleID, interval = interval, isNext = true })

	for k = 0, 9 do
		table.insert(formulas, { seed = cycleID * 1000 + k, interval = interval, mul = 1000, k = k })
	end

	for offset = -BRUTE_OFFSET_RANGE, BRUTE_OFFSET_RANGE do
		table.insert(formulas, { seed = cycleID + offset, interval = interval, offset = offset })
	end
end

-- Scan (silent)
local realStock = GetRealStock()
local bestScore = -math.huge
local bestFormula = nil

for _, f in ipairs(formulas) do
	local predicted = SimulateRestock(f.seed)
	local score, _, _ = ScoreMatch(realStock, predicted)
	if score > bestScore then
		bestScore = score
		bestFormula = f
	end
end

-- Hitung nextSeed
local nextSeed = nil
if bestFormula then
	local label = bestFormula.label

	if label == "raw UnixLast" or label == "raw UnixNext" then
		nextSeed = nextUnix
	elseif bestFormula.interval then
		local interval = bestFormula.interval
		local lastCycleID = math.floor(lastUnix / interval)
		local nextCycleID = math.floor(nextUnix / interval)
		local baseSeed = bestFormula.seed

		if bestFormula.mul then
			nextSeed = nextCycleID * 1000 + bestFormula.k
		else
			local diff = baseSeed - lastCycleID
			nextSeed = nextCycleID + diff
		end
	else
		nextSeed = bestFormula.seed
	end
end

-- ============================================================
-- OUTPUT BERSIH
-- ============================================================
local timeLeft = math.max(nextUnix - os.time(), 0)
local mins = math.floor(timeLeft / 60)
local secs = timeLeft % 60

print("╔══════════════════════════════════════╗")
print("║       NEXT GEAR RESTOCK PREDICT      ║")
print("╠══════════════════════════════════════╣")
print(string.format("║  Restock dalam:  %dm %ds%s║",
	mins, secs, string.rep(" ", 18 - #tostring(mins) - #tostring(secs))))

if nextSeed then
	local predicted = SimulateRestock(nextSeed)

	-- Urutkan sesuai urutan GearShopData.Data
	local ordered = {}
	for _, gearInfo in ipairs(GearShopData.Data) do
		if predicted[gearInfo.ItemName] then
			table.insert(ordered, { name = gearInfo.ItemName, qty = predicted[gearInfo.ItemName] })
		end
	end

	print("╠══════════════════════════════════════╣")
	print("║  Item                       Qty      ║")
	print("╠══════════════════════════════════════╣")

	for _, item in ipairs(ordered) do
		local line = string.format("║  %-26s x%-4d ║", item.name, item.qty)
		print(line)
	end
else
	print("║  Prediksi tidak tersedia             ║")
end

print("╚══════════════════════════════════════╝")
