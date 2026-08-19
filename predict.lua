local WebhookURL = "https://discord.com/api/webhooks/1515337841532604486/sm4DRS4lZsaFCtyb_Su8lQH9Enxdeebk3zVGDwfAoVDEfziQAYhbIDrTQBaeSvt2lgaK"

local function SendWebhook(contentString)
    -- Mendukung berbagai executor (Synapse, Krnl, Fluxus, dll)
    local req = http_request or request or HttpPost or (syn and syn.request)
    if not req then
        warn("Executor kamu tidak mendukung HTTP requests!")
        return
    end

    local data = {
        ["content"] = contentString
    }

    local jsonData = game:GetService("HttpService"):JSONEncode(data)

    req({
        Url = WebhookURL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = jsonData
    })
end

local TimeCycleData = require(game:GetService("ReplicatedStorage").SharedModules.TimeCycleData)

-- Fungsi untuk meramal cuaca malam ini (game menggunakan os.time() Global)
-- RNG = Random.new(cycleIndex * 1000 + phaseIndex) -- dari TimeCycleController.lua
local function PredictNightWeather()
    local totalDuration = 450 + 30 + 120 -- Day + Sunset + Night = 600 detik
    local currentDayID = math.floor(os.time() / totalDuration)
    
    -- Fase malam adalah fase ke-3 (StartOrder=3)
    local rng = Random.new((currentDayID * 1000) + 3)
    
    -- URUTAN VERIFIED dari screenshot: Moon → Bloodmoon → Rainbow Moon → Goldmoon
    local nightWeathers = {
        {Name = "Moon",         Chance = 79},
        {Name = "Bloodmoon",    Chance = 2},
        {Name = "Rainbow Moon", Chance = 6},
        {Name = "Goldmoon",     Chance = 13},
    }
    local totalChance = 100 -- total tanpa Mega Moon
    
    local roll = rng:NextNumber() * totalChance
    local currentChance = 0
    for _, wData in ipairs(nightWeathers) do -- ipairs = deterministik
        currentChance = currentChance + wData.Chance
        if roll <= currentChance then
            return wData.Name
        end
    end
    return "Moon" -- fallback
end

-- Fungsi Radar untuk mencari kapan cuaca tertentu berikutnya muncul
local function FindNextSchedule(targetWeather, isDiscord)
    local totalDuration = 600
    local currentDayID = math.floor(os.time() / totalDuration)
    
    local phaseWeathers, phaseIndex, phaseStartTime
    if targetWeather == "Sunset" then
        phaseWeathers = TimeCycleData.Data.Sunset.Weathers
        phaseIndex = 2
        phaseStartTime = 450
    else
        phaseWeathers = TimeCycleData.Data.Night.Weathers
        phaseIndex = 3
        phaseStartTime = 480
    end
    
    local totalChance = 0
    for _, wData in pairs(phaseWeathers) do
        totalChance = totalChance + wData.Chance
    end
    
    -- Scan hingga 100 siklus (sekitar 16 jam ke depan)
    for offset = 0, 100 do
        local checkDayID = currentDayID + offset
        local rng = Random.new((checkDayID * 1000) + phaseIndex)
        
        local roll = rng:NextNumber() * totalChance
        local currentChance = 0
        local predictedWeather = "Unknown"
        for wName, wData in pairs(phaseWeathers) do
            currentChance = currentChance + wData.Chance
            if roll <= currentChance then
                predictedWeather = wName
                break
            end
        end
        
        if predictedWeather == targetWeather then
            -- Hitung sisa waktu mundur secara real-time
            local timeUntil = (offset * totalDuration) - (os.time() % totalDuration) 
            timeUntil = timeUntil + phaseStartTime
            
            local phaseDuration = (targetWeather == "Sunset") and 30 or 120
            
            if timeUntil + phaseDuration >= 0 then
                local targetUnixTime = math.floor(os.time() + timeUntil)
                
                if isDiscord then
                    if timeUntil < 0 then
                        return "SEDANG BERLANGSUNG! (Dimulai <t:" .. targetUnixTime .. ":R>)"
                    elseif offset == 0 then
                        return "Siklus ini! (<t:" .. targetUnixTime .. ":R>)"
                    else
                        return "Dalam " .. offset .. " Siklus (<t:" .. targetUnixTime .. ":R>)"
                    end
                else
                    if timeUntil < 0 then
                        return "SEDANG BERLANGSUNG sekarang!"
                    end
                    local minutes = math.floor(timeUntil / 60)
                    local seconds = timeUntil % 60
                    if offset == 0 then
                        return "Siklus saat ini! (" .. minutes .. " Menit " .. seconds .. " Detik lagi)"
                    else
                        return "Dalam " .. offset .. " Siklus (" .. minutes .. " Menit " .. seconds .. " Detik lagi)"
                    end
                end
            end
        end
    end
    return "Tidak ditemukan dalam 16 jam ke depan"
end

-- Deteksi saat fase waktu berubah
workspace:GetAttributeChangedSignal("ActivePhase"):Connect(function()
    local currentPhase = workspace:GetAttribute("ActivePhase")
    
    -- Kirim Prediksi Webhook SAAT PETANG (Sunset), sebelum malam tiba!
    if currentPhase == "Sunset" then
        local predictedWeather = PredictNightWeather()
        -- Kita gunakan isDiscord = true untuk menggunakan <t:UnixTime:R>
        local rainbowSchedule = FindNextSchedule("Rainbow Moon", true)
        local goldSchedule = FindNextSchedule("Goldmoon", true)
        local bloodmoonSchedule = FindNextSchedule("Bloodmoon", true)
        local moonSchedule = FindNextSchedule("Moon", true)
        local sunsetSchedule = FindNextSchedule("Sunset", true)
        
        local messageText = "🌙 **Prediksi Malam Ini:** " .. predictedWeather .. "\n" ..
                            "🌈 **Jadwal Rainbow Moon:** " .. rainbowSchedule .. "\n" ..
                            "🪙 **Jadwal Gold Moon:** " .. goldSchedule .. "\n" ..
                            "🩸 **Jadwal Bloodmoon:** " .. bloodmoonSchedule .. "\n" ..
                            "🌑 **Jadwal Moon:** " .. moonSchedule .. "\n" ..
                            "🌅 **Jadwal Sunset:** " .. sunsetSchedule
                            
        SendWebhook(messageText)
        print("[Webhook] Prediksi Malam Ini terkirim ke Discord!")
    end
end)

-- Ramal cuaca malam ini saat script baru pertama kali dijalankan
print("==============================================")
print("[Webhook] Monitoring Cuaca Dimulai!")
print("[Webhook] RAMALAN MALAM INI: " .. PredictNightWeather())
print("[Webhook] JADWAL RAINBOW MOON: " .. FindNextSchedule("Rainbow Moon", false))
print("[Webhook] JADWAL GOLD MOON: " .. FindNextSchedule("Goldmoon", false))
print("[Webhook] JADWAL BLOODMOON: " .. FindNextSchedule("Bloodmoon", false))
print("[Webhook] JADWAL MOON: " .. FindNextSchedule("Moon", false))
print("[Webhook] JADWAL SUNSET: " .. FindNextSchedule("Sunset", false))
print("==============================================")
