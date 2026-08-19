-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local TweenFunctions = require(script.TweenFunctions);
local Lerps = require(script.Lerps);
local Heartbeat = RunService.Heartbeat;
local v1 = {};
local u2 = {
    Heartbeat = true,
    Stepped = true,
    RenderStepped = true
};

if not RunService:IsClient() then
    u2.RenderStepped = nil;
end;

local u3 = {
    FabricAccelerate = {
        In = TweenFunctions.InFabricAccelerate,
        Out = TweenFunctions.OutFabricAccelerate,
        InOut = TweenFunctions.InOutFabricAccelerate,
        OutIn = TweenFunctions.OutInFabricAccelerate
    },
    UWPAccelerate = {
        In = TweenFunctions.InUWPAccelerate,
        Out = TweenFunctions.OutUWPAccelerate,
        InOut = TweenFunctions.InOutUWPAccelerate,
        OutIn = TweenFunctions.OutInUWPAccelerate
    },
    Circ = {
        In = TweenFunctions.InCirc,
        Out = TweenFunctions.OutCirc,
        InOut = TweenFunctions.InOutCirc,
        OutIn = TweenFunctions.OutInCirc
    },
    RevBack = {
        In = TweenFunctions.InRevBack,
        Out = TweenFunctions.OutRevBack,
        InOut = TweenFunctions.InOutRevBack,
        OutIn = TweenFunctions.OutInRevBack
    },
    Spring = {
        In = TweenFunctions.InSpring,
        Out = TweenFunctions.OutSpring,
        InOut = TweenFunctions.InOutSpring,
        OutIn = TweenFunctions.OutInSpring
    },
    Standard = {
        In = TweenFunctions.InStandard,
        Out = TweenFunctions.OutStandard,
        InOut = TweenFunctions.InOutStandard,
        OutIn = TweenFunctions.OutInStandard
    },
    StandardExpressive = {
        In = TweenFunctions.InStandardExpressive,
        Out = TweenFunctions.OutStandardExpressive,
        InOut = TweenFunctions.InOutStandardExpressive,
        OutIn = TweenFunctions.OutInStandardExpressive
    },
    Linear = {
        In = TweenFunctions.InLinear,
        Out = TweenFunctions.OutLinear,
        InOut = TweenFunctions.InOutLinear,
        OutIn = TweenFunctions.OutInLinear
    },
    ExitProductive = {
        In = TweenFunctions.InExitProductive,
        Out = TweenFunctions.OutExitProductive,
        InOut = TweenFunctions.InOutExitProductive,
        OutIn = TweenFunctions.OutInExitProductive
    },
    Deceleration = {
        In = TweenFunctions.InDeceleration,
        Out = TweenFunctions.OutDeceleration,
        InOut = TweenFunctions.InOutDeceleration,
        OutIn = TweenFunctions.OutInDeceleration
    },
    Smoother = {
        In = TweenFunctions.InSmoother,
        Out = TweenFunctions.OutSmoother,
        InOut = TweenFunctions.InOutSmoother,
        OutIn = TweenFunctions.OutInSmoother
    },
    FabricStandard = {
        In = TweenFunctions.InFabricStandard,
        Out = TweenFunctions.OutFabricStandard,
        InOut = TweenFunctions.InOutFabricStandard,
        OutIn = TweenFunctions.OutInFabricStandard
    },
    RidiculousWiggle = {
        In = TweenFunctions.InRidiculousWiggle,
        Out = TweenFunctions.OutRidiculousWiggle,
        InOut = TweenFunctions.InOutRidiculousWiggle,
        OutIn = TweenFunctions.OutInRidiculousWiggle
    },
    MozillaCurve = {
        In = TweenFunctions.InMozillaCurve,
        Out = TweenFunctions.OutMozillaCurve,
        InOut = TweenFunctions.InOutMozillaCurve,
        OutIn = TweenFunctions.OutInMozillaCurve
    },
    Expo = {
        In = TweenFunctions.InExpo,
        Out = TweenFunctions.OutExpo,
        InOut = TweenFunctions.InOutExpo,
        OutIn = TweenFunctions.OutInExpo
    },
    Sine = {
        In = TweenFunctions.InSine,
        Out = TweenFunctions.OutSine,
        InOut = TweenFunctions.InOutSine,
        OutIn = TweenFunctions.OutInSine
    },
    Cubic = {
        In = TweenFunctions.InCubic,
        Out = TweenFunctions.OutCubic,
        InOut = TweenFunctions.InOutCubic,
        OutIn = TweenFunctions.OutInCubic
    },
    EntranceExpressive = {
        In = TweenFunctions.InEntranceExpressive,
        Out = TweenFunctions.OutEntranceExpressive,
        InOut = TweenFunctions.InOutEntranceExpressive,
        OutIn = TweenFunctions.OutInEntranceExpressive
    },
    Elastic = {
        In = TweenFunctions.InElastic,
        Out = TweenFunctions.OutElastic,
        InOut = TweenFunctions.InOutElastic,
        OutIn = TweenFunctions.OutInElastic
    },
    Quint = {
        In = TweenFunctions.InQuint,
        Out = TweenFunctions.OutQuint,
        InOut = TweenFunctions.InOutQuint,
        OutIn = TweenFunctions.OutInQuint
    },
    EntranceProductive = {
        In = TweenFunctions.InEntranceProductive,
        Out = TweenFunctions.OutEntranceProductive,
        InOut = TweenFunctions.InOutEntranceProductive,
        OutIn = TweenFunctions.OutInEntranceProductive
    },
    Bounce = {
        In = TweenFunctions.InBounce,
        Out = TweenFunctions.OutBounce,
        InOut = TweenFunctions.InOutBounce,
        OutIn = TweenFunctions.OutInBounce
    },
    Smooth = {
        In = TweenFunctions.InSmooth,
        Out = TweenFunctions.OutSmooth,
        InOut = TweenFunctions.InOutSmooth,
        OutIn = TweenFunctions.OutInSmooth
    },
    Back = {
        In = TweenFunctions.InBack,
        Out = TweenFunctions.OutBack,
        InOut = TweenFunctions.InOutBack,
        OutIn = TweenFunctions.OutInBack
    },
    Quart = {
        In = TweenFunctions.InQuart,
        Out = TweenFunctions.OutQuart,
        InOut = TweenFunctions.InOutQuart,
        OutIn = TweenFunctions.OutInQuart
    },
    StandardProductive = {
        In = TweenFunctions.InStandardProductive,
        Out = TweenFunctions.OutStandardProductive,
        InOut = TweenFunctions.InOutStandardProductive,
        OutIn = TweenFunctions.OutInStandardProductive
    },
    Quad = {
        In = TweenFunctions.InQuad,
        Out = TweenFunctions.OutQuad,
        InOut = TweenFunctions.InOutQuad,
        OutIn = TweenFunctions.OutInQuad
    },
    FabricDecelerate = {
        In = TweenFunctions.InFabricDecelerate,
        Out = TweenFunctions.OutFabricDecelerate,
        InOut = TweenFunctions.InOutFabricDecelerate,
        OutIn = TweenFunctions.OutInFabricDecelerate
    },
    Acceleration = {
        In = TweenFunctions.InAcceleration,
        Out = TweenFunctions.OutAcceleration,
        InOut = TweenFunctions.InOutAcceleration,
        OutIn = TweenFunctions.OutInAcceleration
    },
    SoftSpring = {
        In = TweenFunctions.InSoftSpring,
        Out = TweenFunctions.OutSoftSpring,
        InOut = TweenFunctions.InOutSoftSpring,
        OutIn = TweenFunctions.OutInSoftSpring
    },
    ExitExpressive = {
        In = TweenFunctions.InExitExpressive,
        Out = TweenFunctions.OutExitExpressive,
        InOut = TweenFunctions.InOutExitExpressive,
        OutIn = TweenFunctions.OutInExitExpressive
    },
    Sharp = {
        In = TweenFunctions.InSharp,
        Out = TweenFunctions.OutSharp,
        InOut = TweenFunctions.InOutSharp,
        OutIn = TweenFunctions.OutInSharp
    }
};

local function Wait(p4) -- Line: 333
    -- upvalues: Heartbeat (copy)
    local v5 = math.max(p4 or 0.03, 0);
    local v6 = v5;

    while v5 > 0 do
        v5 = v5 - Heartbeat:Wait();
    end;

    return v6 - v5;
end;

function v1.Create(p7, u8, p9) -- Line: 344
    -- upvalues: u2 (copy), RunService (copy), u3 (copy), Lerps (copy), Wait (copy)
    if not u8 or typeof(u8) ~= "Instance" then
        return warn("Invalid object to tween:", u8);
    end;

    local u10 = type(p9) == "table" and (p9 or {}) or {};
    local u11 = u2[u10.StepType] and RunService[u10.StepType] or RunService.Stepped;
    local u12 = u3[u10.EasingStyle or "Quad"][u10.EasingDirection or "In"];
    local v13 = type(u10.Time) == "number" and (u10.Time or 1) or 1;
    local u14 = math.max(v13, 0.001);
    local v15 = type(u10.Goal) == "table" and (u10.Goal or {}) or {};
    local u16;

    if type(u10.DelayTime) == "number" and u10.DelayTime > 0.027 then
        u16 = u10.DelayTime;
    else
        u16 = false;
    end;

    local u17 = (type(u10.RepeatCount) == "number" and (math.max(u10.RepeatCount, -1) or 0) or 0) + 1;
    local u18 = {};

    for i, v in pairs(v15) do
        u18[i] = Lerps[typeof(v)](u8[i], v);
    end;

    local BindableEvent = Instance.new("BindableEvent");
    local BindableEvent2 = Instance.new("BindableEvent");
    local BindableEvent3 = Instance.new("BindableEvent");
    local u19 = nil;
    local u20 = os.clock();
    local u21 = 0;
    local u22 = {
        Instance = u8,
        PlaybackState = Enum.PlaybackState.Begin,
        Completed = BindableEvent.Event,
        Resumed = BindableEvent3.Event,
        Stopped = BindableEvent2.Event
    };

    function u22.Destroy() -- Line: 382
        -- upvalues: u19 (ref), BindableEvent (copy), BindableEvent2 (copy), BindableEvent3 (copy), u22 (ref)
        if u19 then
            u19:Disconnect();
            u19 = nil;
        end;

        BindableEvent:Destroy();
        BindableEvent2:Destroy();
        BindableEvent3:Destroy();
        u22 = nil;
    end;

    local u23 = false;
    local u24 = 0;

    local function Play(p25, u26) -- Line: 397
        -- upvalues: u19 (ref), u17 (copy), u22 (ref), BindableEvent (copy), u23 (ref), u24 (ref), u16 (copy), Wait (ref), u20 (ref), u21 (ref), u11 (copy), u14 (copy), u18 (copy), u8 (copy), Play (copy), u10 (ref), u12 (copy)
        if u19 then
            u19:Disconnect();
            u19 = nil;
        end;

        local u27 = p25 or 1;

        if u17 ~= 0 and u17 < u27 then
            u22.PlaybackState = Enum.PlaybackState.Completed;
            BindableEvent:Fire();
            u23 = false;
            u24 = 1;

            return;
        end;

        u24 = u27;

        if u26 then
            u23 = true;
        end;

        if u16 then
            u22.PlaybackState = Enum.PlaybackState.Delayed;
            (u16 < 2 and Wait or wait)(u16);
        end;

        u20 = os.clock() - u21;
        u19 = u11:Connect(function() -- Line: 426
            -- upvalues: u21 (ref), u20 (ref), u14 (ref), u26 (copy), u18 (ref), u8 (ref), u19 (ref), Play (ref), u27 (ref), u10 (ref), u12 (ref)
            u21 = os.clock() - u20;

            if u14 > u21 then
                local v28 = u12(u26 and 1 - u21 / u14 or u21 / u14);
                local v29 = math.clamp(v28, 0, 1);

                for i, v in pairs(u18) do
                    u8[i] = v(v29);
                end;

                return;
            end;

            if u26 then
                for i, v in pairs(u18) do
                    u8[i] = v(0);
                end;
            else
                for i, v in pairs(u18) do
                    u8[i] = v(1);
                end;
            end;

            u19:Disconnect();
            u19 = nil;

            if u26 then
                u21 = 0;
                Play(u27 + 1, false);

                return;
            end;

            if u10.Reverses then
                u21 = 0;
                Play(u27, true);

                return;
            end;

            u21 = 0;
            Play(u27 + 1, false);
        end);
        u22.PlaybackState = Enum.PlaybackState.Playing;
    end;

    function u22.Play() -- Line: 466
        -- upvalues: u21 (ref), Play (copy)
        u21 = 0;
        Play(1, false);
    end;

    function u22.Stop() -- Line: 471
        -- upvalues: u19 (ref), u22 (ref), BindableEvent2 (copy)
        if u19 then
            u19:Disconnect();
            u19 = nil;
            u22.PlaybackState = Enum.PlaybackState.Cancelled;
            BindableEvent2:Fire();
        end;
    end;

    function u22.Resume() -- Line: 480
        -- upvalues: Play (copy), u24 (ref), u23 (ref), BindableEvent3 (copy)
        Play(u24, u23);
        BindableEvent3:Fire();
    end;

    return u22;
end;

return v1;