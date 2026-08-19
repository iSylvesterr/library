local logs = {}
local loggingEnabled = true
local maxLogs = 300 -- Naikkan limit
local lastBulkPos = nil -- Track posisi terakhir untuk filter walking noise

local function logMessage(msg)
    if not loggingEnabled then return end
    if #logs >= maxLogs then
        table.insert(logs, "--- LOG PENUH, MENGHENTIKAN PENCATATAN ---")
        loggingEnabled = false
    else
        table.insert(logs, "[SCANNER] " .. msg)
    end
    
    print("[SCANNER] " .. msg)
    
    if setclipboard then
        -- Langsung copy seluruh log ke clipboard tiap kali ada log baru
        setclipboard(table.concat(logs, "\n"))
    end
end

logMessage("Scanner Aktif! Silakan eksekusi script orang lain dan coba teleportnya...")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Pantau kalau ada script yang dihapus dari karakter
local function monitorCharacter(char)
    char.DescendantRemoving:Connect(function(desc)
        if desc:IsA("LocalScript") or desc:IsA("Script") then
            logMessage("Script Dihapus: " .. desc.Name)
        end
    end)
    
    -- Pantau juga State Humanoid secara pasif
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        hum.StateChanged:Connect(function(old, new)
            logMessage("Humanoid State: " .. tostring(old) .. " -> " .. tostring(new))
        end)
    end
end

if LocalPlayer.Character then
    monitorCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(monitorCharacter)

-- Helper: dapatkan posisi HRP saat ini
local function getHRPPos()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        return string.format("(%.1f, %.1f, %.1f)", hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
    end
    return "(unknown)"
end

-- Hook untuk mendeteksi RemoteEvents, RemoteFunctions, dan Teleportasi
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    if not loggingEnabled then return oldNamecall(self, ...) end
    
    local method = getnamecallmethod()
    local args = {...}
    
    -- Tangkap Remote - sertakan posisi HRP saat ini!
    if method == "InvokeServer" or method == "FireServer" then
        local remoteName = tostring(self)
        local blocked = {"MouseMovement","CameraMovement","Report","Ping","FocusState","OfflineAssets"}
        local skip = false
        for _, b in ipairs(blocked) do
            if remoteName:find(b) then skip = true; break end
        end
        if not skip then
            local argStr = "nil"
            if args[1] ~= nil then 
                if typeof(args[1]) == "table" then
                    argStr = "Table{ "
                    for k,v in pairs(args[1]) do argStr = argStr .. tostring(k) .. "=" .. tostring(v) .. " " end
                    argStr = argStr .. "}"
                else
                    argStr = tostring(args[1])
                end
            end
            -- Posisi HRP saat remote dikirim adalah kunci investigasi!
            logMessage("REMOTE[" .. method .. "] " .. remoteName .. " Args=" .. argStr .. " HRPPos=" .. getHRPPos())
        end
        
    -- BulkMoveTo - FILTER: hanya log jika lompatan > 10 studs (teleport), bukan jalan biasa
    elseif method == "BulkMoveTo" then
        local parts = args[1]
        if typeof(parts) == "table" then
            for _, p in ipairs(parts) do
                if p.Name == "HumanoidRootPart" and p:IsDescendantOf(workspace) then
                    local newCF = args[2] and args[2][1]
                    if newCF then
                        local newPos = newCF.Position
                        local jumped = false
                        if lastBulkPos then
                            local dist = (newPos - lastBulkPos).Magnitude
                            if dist > 10 then
                                jumped = true
                                logMessage(">>> TELEPORT TERDETEKSI! Jump " .. string.format("%.1f", dist) .. " studs -> (" .. string.format("%.1f,%.1f,%.1f", newPos.X, newPos.Y, newPos.Z) .. ") HRPPos=" .. getHRPPos())
                            end
                        end
                        lastBulkPos = newPos
                    end
                    break
                end
            end
        end
        
    -- Tangkap ChangeState
    elseif method == "ChangeState" then
        if self:IsA("Humanoid") then
            logMessage("ChangeState: " .. tostring(args[1]))
        end
    end
    
    return oldNamecall(self, ...)
end)

-- Hook untuk mendeteksi perubahan properti (CFrame, Anchored)
local oldNewindex
oldNewindex = hookmetamethod(game, "__newindex", function(self, key, value)
    if loggingEnabled then
        if key == "CFrame" or key == "Position" then
            if self.Name == "HumanoidRootPart" and self:IsDescendantOf(workspace) then
                logMessage("HRP CFrame Diubah! Nilai: " .. tostring(value))
            end
        elseif key == "Anchored" then
            if self.Name == "HumanoidRootPart" then
                logMessage("HRP Anchored Diubah menjadi: " .. tostring(value))
            end
        elseif key == "PlatformStand" or key == "Sit" or key == "WalkSpeed" or key == "WalkToPoint" then
            if self:IsA("Humanoid") then
                logMessage("Humanoid Property Diubah: " .. tostring(key) .. " = " .. tostring(value))
            end
        elseif key == "AssemblyLinearVelocity" or key == "AssemblyAngularVelocity" or key == "Velocity" then
            if self.Name == "HumanoidRootPart" then
                -- Jangan log velocity kalau nilainya 0,0,0 karena itu normal
                if value.Magnitude > 0 then
                    logMessage("Velocity Diubah: " .. tostring(value))
                end
            end
        end
    end
    
    return oldNewindex(self, key, value)
end)

logMessage("Hooks terpasang! Jangan lupa matikan auto steal di script ini dan jalankan script orang tersebut.")
