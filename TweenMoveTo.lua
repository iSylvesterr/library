local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- speed efektif = WalkSpeed asli karakter x SPEED_MULTIPLIER
local SPEED_MULTIPLIER = 2

-- floor durasi biar tween gak collapse jadi keliatan teleport pas WalkSpeed/multiplier
-- lagi tinggi (jarak pendek + speed tinggi = selesai dalam hitungan milidetik)
local MIN_TWEEN_DURATION = 0.15

local activeMoveTweens = {}

-- isCancelledFn (opsional): dipanggil tiap frame selama tween jalan, balikin true buat
-- Cancel() tween-nya di tengah jalan tanpa nunggu durasi abis
local function TweenMoveTo(hrp, hum, targetCFrame, isCancelledFn)
    if not hrp then return end
    if isCancelledFn and isCancelledFn() then return end

    local prevTween = activeMoveTweens[hrp]
    if prevTween then
        prevTween:Cancel()
        activeMoveTweens[hrp] = nil
    end

    local distance = (targetCFrame.Position - hrp.Position).Magnitude
    if distance < 0.1 then
        hrp.CFrame = targetCFrame
        hrp.AssemblyLinearVelocity = Vector3.zero
        return
    end

    local speed = hum and hum.WalkSpeed
    if not speed or speed <= 0 then
        speed = 16
    end
    speed = speed * SPEED_MULTIPLIER

    local duration = math.max(distance / speed, MIN_TWEEN_DURATION)
    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
        { CFrame = targetCFrame }
    )
    activeMoveTweens[hrp] = tween

    tween:Play()

    while tween.PlaybackState == Enum.PlaybackState.Playing do
        if isCancelledFn and isCancelledFn() then
            tween:Cancel()
            break
        end
        RunService.Heartbeat:Wait()
    end

    if activeMoveTweens[hrp] == tween then
        activeMoveTweens[hrp] = nil
    end

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end

return TweenMoveTo
