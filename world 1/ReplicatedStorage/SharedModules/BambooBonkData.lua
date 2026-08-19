-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local u1 = FastFlags.Replicated("Game.BambooBonk.JumpGraceSeconds", Asserts.FiniteNonNegative, 0.4);
local u2 = {
    TemplatePath = { "Assets", "Minigames" },
    ArenaName = "BambooBonk",
    PlayerPlatformsName = "PlayerPlatforms",
    CenterPlatformName = "CenterPlatform",
    FloorName = "Floor",
    RotatingTag = "BambooRotating",
    ArenaTag = "BambooBonkArena",
    PlatformAttribute = "Platform",
    RaiseStartAttribute = "BambooBonkRaiseStart",
    SpinStartAttribute = "BambooBonkSpinStart",
    SpinEndAttribute = "BambooBonkSpinEnd",
    BasePivotAttribute = "BambooBonkBasePivot",
    ArmBaseAttribute = "BambooBonkArmBase",
    PlayerSlotAttribute = "BambooBonkPlatform",
    PlayerAnchorAttribute = "BambooBonkAnchor",
    MaxPlayers = 8,
    RaiseHeight = 80,
    RaiseHoldDuration = 2,
    RaiseDuration = 3,
    RaiseEasingStyle = Enum.EasingStyle.Quad,
    RaiseEasingDirection = Enum.EasingDirection.Out,
    PostRaiseHoldDuration = 2,
    CountdownSeconds = 3,
    GameDuration = 90,
    EndHoldDuration = 5,
    ArmStartSize = Vector3.new(0.001, 2, 1),
    ArmEndSize = Vector3.new(365, 2, 1),
    GrowDuration = 5,
    SpinStartRps = 0.1,
    SpinEndRps = 0.5,
    SpinRampDuration = 90,
    FallThreshold = 15,
    HitRadiusPadding = 3,
    HitVerticalGrace = 0.5,
    JumpRiseSpeed = 8
};

local function GetBodySpanY(p3) -- Line: 203
    local v4 = (1 / 0);
    local v5 = (-1 / 0);

    for _, child in p3:GetChildren() do
        if child:IsA("BasePart") then
            local CFrame = child.CFrame;
            local Size = child.Size;
            local v6 = (math.abs(CFrame.RightVector.Y) * Size.X + math.abs(CFrame.UpVector.Y) * Size.Y + math.abs(CFrame.LookVector.Y) * Size.Z) / 2;
            v4 = math.min(v4, CFrame.Position.Y - v6);
            v5 = math.max(v5, CFrame.Position.Y + v6);
        end;
    end;

    if v4 == (1 / 0) then
        return nil, nil;
    end;

    return v4, v5;
end;

function u2.GetRaiseOffset(p7, p8) -- Line: 114
    -- upvalues: u2 (copy), TweenService (copy)
    local v9 = p7 - p8;

    if v9 <= 0 then
        return -u2.RaiseHeight;
    end;

    local v10 = TweenService:GetValue(math.min(v9 / u2.RaiseDuration, 1), u2.RaiseEasingStyle, u2.RaiseEasingDirection);

    return -u2.RaiseHeight * (1 - v10);
end;

function u2.GetSpinAngle(p11) -- Line: 130
    -- upvalues: u2 (copy)
    if p11 <= 0 then
        return 0;
    end;

    local SpinStartRps = u2.SpinStartRps;
    local SpinEndRps = u2.SpinEndRps;
    local SpinRampDuration = u2.SpinRampDuration;
    local v12 = math.min(p11, SpinRampDuration);
    local v13 = SpinStartRps * v12 + (SpinEndRps - SpinStartRps) * v12 * v12 / (2 * SpinRampDuration);

    if SpinRampDuration < p11 then
        v13 = v13 + SpinEndRps * (p11 - SpinRampDuration);
    end;

    return v13 * 6.283185307179586;
end;

function u2.GetArmSize(p14) -- Line: 147
    -- upvalues: u2 (copy)
    local v15 = math.clamp(p14 / u2.GrowDuration, 0, 1);

    return u2.ArmStartSize:Lerp(u2.ArmEndSize, v15);
end;

function u2.GetArmLength(p16) -- Line: 153
    -- upvalues: u2 (copy)
    local v17 = math.clamp(p16 / u2.GrowDuration, 0, 1);

    return u2.ArmStartSize:Lerp(u2.ArmEndSize, v17).X;
end;

function u2.XZAngle(p18, p19) -- Line: 167
    return math.atan2(-p19, p18);
end;

function u2.SweptPast(p20, p21, p22) -- Line: 180
    local v23 = p21 - p20;

    if v23 <= 0 then
        return false;
    end;

    return v23 >= 3.141592653589793 and true or (p22 - p20) % 3.141592653589793 <= v23;
end;

u2.GetBodySpanY = GetBodySpanY;

function u2.WasSweptInto(p24, p25, p26, p27, p28) -- Line: 232
    -- upvalues: GetBodySpanY (copy), u2 (copy)
    local v29, v30 = GetBodySpanY(p24);

    if not (v29 and v30) then
        return false;
    end;

    local v31 = u2.ArmEndSize.Y / 2;

    if p25.Y + v31 - u2.HitVerticalGrace <= v29 then
        return false;
    end;

    if v30 <= p25.Y - v31 then
        return false;
    end;

    local Position = p24:GetPivot().Position;
    local v32 = Position.X - p25.X;
    local v33 = Position.Z - p25.Z;
    local v34 = math.sqrt(v32 * v32 + v33 * v33);
    local v35 = math.clamp(p28 / u2.GrowDuration, 0, 1);

    if u2.ArmStartSize:Lerp(u2.ArmEndSize, v35).X / 2 + u2.HitRadiusPadding < v34 then
        return false;
    end;

    local v36;

    if p27 <= 0 then
        v36 = 0;
    else
        local SpinStartRps = u2.SpinStartRps;
        local SpinEndRps = u2.SpinEndRps;
        local SpinRampDuration = u2.SpinRampDuration;
        local v37 = math.min(p27, SpinRampDuration);
        local v38 = SpinStartRps * v37 + (SpinEndRps - SpinStartRps) * v37 * v37 / (2 * SpinRampDuration);

        if SpinRampDuration < p27 then
            v38 = v38 + SpinEndRps * (p27 - SpinRampDuration);
        end;

        v36 = v38 * 6.283185307179586;
    end;

    local v39 = p26 + v36;
    local v40;

    if p28 <= 0 then
        v40 = 0;
    else
        local SpinStartRps = u2.SpinStartRps;
        local SpinEndRps = u2.SpinEndRps;
        local SpinRampDuration = u2.SpinRampDuration;
        local v41 = math.min(p28, SpinRampDuration);
        local v42 = SpinStartRps * v41 + (SpinEndRps - SpinStartRps) * v41 * v41 / (2 * SpinRampDuration);

        if SpinRampDuration < p28 then
            v42 = v42 + SpinEndRps * (p28 - SpinRampDuration);
        end;

        v40 = v42 * 6.283185307179586;
    end;

    local v43 = math.atan2(-v33, v32);
    local v44 = p26 + v40 - v39;

    if v44 <= 0 then
        return false;
    end;

    return v44 >= 3.141592653589793 and true or (v43 - v39) % 3.141592653589793 <= v44;
end;

function u2.NewJumpTracker() -- Line: 281
    return {
        Rising = false
    };
end;

function u2.TrackJump(p45, p46, p47) -- Line: 300
    -- upvalues: u2 (copy)
    local LastFeetY = p45.LastFeetY;
    local LastSampleAt = p45.LastSampleAt;
    p45.LastFeetY = p46;
    p45.LastSampleAt = p47;

    if not (p46 and (LastFeetY and LastSampleAt)) then
        return;
    end;

    local v48 = p47 - LastSampleAt;

    if v48 <= 0 then
        return;
    end;

    local v49 = (p46 - LastFeetY) / v48 >= u2.JumpRiseSpeed;

    if v49 and not p45.Rising then
        p45.LastJumpAt = p47;
    end;

    p45.Rising = v49;
end;

function u2.IsJumpForgiven(p50, p51) -- Line: 327
    -- upvalues: u1 (copy)
    local v52 = u1:Get();

    if v52 <= 0 then
        return false;
    end;

    local LastJumpAt = p50.LastJumpAt;
    local v53;

    if LastJumpAt == nil then
        v53 = false;
    else
        v53 = p51 - LastJumpAt <= v52;
    end;

    return v53;
end;

return table.freeze(u2);