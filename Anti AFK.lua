local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Config = {
    Enabled = true,
}

-- Blocks the game's own soft-kick teleport (TeleportService:Teleport back to the
-- same place after being idle too long). Only works if your executor supports
-- hookfunction properly on native Roblox methods -- some don't, hence the layers below.
local function hookAfkTeleport()
    if typeof(hookfunction) ~= "function" then return end

    local TeleportService = game:GetService("TeleportService")
    local placeId = game.PlaceId
    local original

    local function safeTeleport(self, tpPlaceId, player, ...)
        if Config.Enabled and self == TeleportService and tpPlaceId == placeId and player == LocalPlayer then
            return
        end
        return original(self, tpPlaceId, player, ...)
    end

    original = hookfunction(TeleportService.Teleport, safeTeleport)
end

-- Most games trigger the AFK check off Player.Idled, then teleport/kick from there.
-- Disabling the connection at the source stops it before it can ever fire.
-- Connection objects from getconnections() are often userdata, not a table, so don't
-- gate on type() -- just try Disable/Disconnect and see what sticks.
local function disableIdledConnections()
    local getconns = getconnections or get_signal_cons
    if not getconns then return end

    for _, conn in pairs(getconns(LocalPlayer.Idled)) do
        local ok = pcall(function() conn:Disable() end)
        if not ok then
            pcall(function() conn:Disconnect() end)
        end
    end
end

-- Backup: blocks any Kick call targeting you, in case the game kicks you some
-- other way entirely (bad server response, custom moderation script, etc).
local function hookKick()
    if typeof(hookfunction) ~= "function" then return end
    local original

    local function safeKick(self, message, ...)
        if Config.Enabled and self == LocalPlayer then
            return
        end
        return original(self, message, ...)
    end

    original = hookfunction(LocalPlayer.Kick, safeKick)
end

hookAfkTeleport()
disableIdledConnections()
hookKick()

-- Tiny periodic movement, in case a game checks position/velocity changes
-- instead of (or in addition to) raw input events.
task.spawn(function()
    while true do
        task.wait(20)
        if Config.Enabled then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hum and hrp then
                local offset = Vector3.new((math.random() - 0.5) * 0.4, 0, (math.random() - 0.5) * 0.4)
                hum:MoveTo(hrp.Position + offset)
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    disableIdledConnections()
end)
