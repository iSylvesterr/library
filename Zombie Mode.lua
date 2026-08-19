local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

pcall(function()
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
end)

local function setupInvincibility(hum)
    if not hum then return end

    local conn

    pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    end)

    hum.Died:Connect(function()
        local maxHp = hum.MaxHealth
        conn = RunService.RenderStepped:Connect(function()
            if not hum or not hum.Parent then
                if conn then conn:Disconnect() end
                return
            end
            hum.Health = maxHp
        end)
    end)

    task.spawn(function()
        task.wait(0.05)
        hum.Health = 0
    end)
end

task.spawn(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then setupInvincibility(hum) end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then setupInvincibility(hum) end
end)
