local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SeedData = require(ReplicatedStorage.SharedModules.SeedData)
local SeedShop = ReplicatedStorage:WaitForChild("StockValues"):WaitForChild("SeedShop")
local Items = SeedShop:WaitForChild("Items")
local UnixNextRestock = SeedShop:WaitForChild("UnixNextRestock")
local UnixLastRestock = SeedShop:WaitForChild("UnixLastRestock")

local BRUTE_OFFSET_RANGE = 50
local INTERVALS = { 300, 360, 600, 900, 1800 }

local function GetRealStock()
	local real = {}
	for _, item in ipairs(Items:GetChildren()) do
		if item.Value > 0 then
			real[item.Name] = item.Value
		end
	end
	return real
end

local function SimulateRestock(seed)
	local rng = Random.new(seed)
	local result = {}
	for _, seedInfo in ipairs(SeedData) do
		if seedInfo.RestockShop and seedInfo.RestockChance then
			local roll = rng:NextNumber() * 100
			if roll <= seedInfo.RestockChance then
				local qty = 1
				if seedInfo.RestockValues then
					qty = rng:NextInteger(seedInfo.RestockValues.Min, seedInfo.RestockValues.Max)
				end
				result[seedInfo.SeedName] = qty
			end
		end
	end
	return result
end

local function ScoreMatch(real, predicted)
	local match = 0
	local total = 0
	for name, _ in pairs(real) do
		total = total + 1
		if predicted[name] then match = match + 1 end
	end
	return match, total
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
local bestScore = -1
local bestFormula = nil

for _, f in ipairs(formulas) do
	local predicted = SimulateRestock(f.seed)
	local match, _ = ScoreMatch(realStock, predicted)
	if match > bestScore then
		bestScore = match
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
print("║         NEXT RESTOCK PREDICT         ║")
print("╠══════════════════════════════════════╣")
print(string.format("║  Restock dalam:  %dm %ds%s║",
	mins, secs, string.rep(" ", 18 - #tostring(mins) - #tostring(secs))))

if nextSeed then
	local predicted = SimulateRestock(nextSeed)

	-- Sort by SeedShopDisplayOrder
	local ordered = {}
	for _, seedInfo in ipairs(SeedData) do
		if predicted[seedInfo.SeedName] then
			table.insert(ordered, { name = seedInfo.SeedName, qty = predicted[seedInfo.SeedName] })
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
