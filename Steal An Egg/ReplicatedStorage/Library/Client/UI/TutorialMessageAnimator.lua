-- Decompiled with Potassium's decompiler.

local ReplicatedFirst = game:GetService("ReplicatedFirst");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Audio = require(ReplicatedStorage.Library.Audio);
local Normal = require(ReplicatedStorage.Directory.Sounds.Languages.Alphabet._Index.Normal);
local u1 = {};
u1.__index = u1;
u1.__class = "TutorialMessageAnimator";

function u1.new(p2, p3, p4, p5) -- Line: 39
    -- upvalues: u1 (copy)
    local v6 = setmetatable({}, u1);
    v6._textLabel = p2;
    v6._animationId = 0;
    v6._typingSoundId = p3 or "rbxassetid://91414159854126";
    v6._typingSoundsEnabled = p5 ~= false;
    v6._typingSpeed = p4 or 0.09;
    v6._typingValue = nil;
    v6._typingConnection = nil;
    v6._typingTween = nil;

    return v6;
end;

function u1._playAlphabetSound(p7, p8, p9) -- Line: 61
    -- upvalues: Normal (copy), Audio (copy), ReplicatedFirst (copy)
    if p8 == " " then
        return;
    end;

    local v10 = Normal[string.lower(p8)];

    if v10 then
        Audio.ScheduleAndPlay(v10.Sound:Clone(), function() -- Line: 72
            return nil;
        end, v10.Sound.Parent);

        return;
    end;

    Audio.Play(p9, ReplicatedFirst);
end;

function u1._getVisibleGraphemes(p11, p12) -- Line: 81
    local v13 = string.gsub(p12, "<.->", "");
    local v14 = {};

    for i, v in utf8.graphemes(v13) do
        v14[#v14 + 1] = string.sub(v13, i, v);
    end;

    return v14;
end;

function u1.Stop(p15) -- Line: 95
    p15._animationId = p15._animationId + 1;

    if p15._typingTween then
        p15._typingTween:Cancel();
        p15._typingTween = nil;
    end;

    if p15._typingConnection then
        p15._typingConnection:Disconnect();
        p15._typingConnection = nil;
    end;

    if p15._typingValue then
        p15._typingValue:Destroy();
        p15._typingValue = nil;
    end;

    p15._textLabel.MaxVisibleGraphemes = -1;
end;

function u1.SetInstant(p16, p17, p18) -- Line: 116
    if p16._textLabel.Text == p17 and (p16._textLabel.TextColor3 == p18 and p16._textLabel.MaxVisibleGraphemes == -1) then
        return;
    end;

    p16:Stop();
    p16._textLabel.RichText = true;
    p16._textLabel.Text = p17;
    p16._textLabel.TextColor3 = p18;
    p16._textLabel.MaxVisibleGraphemes = -1;
end;

function u1.SetAnimated(u19, p20, p21) -- Line: 132
    -- upvalues: TweenService (copy)
    if u19._textLabel.Text == p20 and u19._textLabel.TextColor3 == p21 then
        return;
    end;

    u19:Stop();
    u19._animationId = u19._animationId + 1;
    local _animationId = u19._animationId;
    u19._textLabel.RichText = true;
    u19._textLabel.Text = p20;
    u19._textLabel.TextColor3 = p21;
    local u22 = u19:_getVisibleGraphemes(p20);
    local u23 = #u22;

    if u23 <= 0 then
        u19._textLabel.MaxVisibleGraphemes = -1;

        return;
    end;

    u19._textLabel.MaxVisibleGraphemes = 0;
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Value = 0;
    u19._typingValue = NumberValue;
    local u24 = 0;
    u19._typingConnection = NumberValue:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 159
        -- upvalues: _animationId (copy), u19 (copy), NumberValue (copy), u23 (copy), u24 (ref), u22 (copy)
        if _animationId ~= u19._animationId then
            return;
        end;

        local v25 = math.floor(NumberValue.Value + 0.5);
        local v26 = math.clamp(v25, 0, u23);

        if v26 == u24 then
            return;
        end;

        u19._textLabel.MaxVisibleGraphemes = v26;

        if u19._typingSoundsEnabled then
            for i = u24 + 1, v26 do
                local v27 = u22[i];

                if v27 then
                    u19:_playAlphabetSound(v27, u19._typingSoundId);
                end;
            end;
        end;

        u24 = v26;
    end);
    local v28 = TweenService:Create(NumberValue, TweenInfo.new(u23 * u19._typingSpeed), {
        Value = u23
    });
    u19._typingTween = v28;
    v28.Completed:Connect(function() -- Line: 187
        -- upvalues: _animationId (copy), u19 (copy)
        if _animationId ~= u19._animationId then
            return;
        end;

        u19._textLabel.MaxVisibleGraphemes = -1;

        if u19._typingConnection then
            u19._typingConnection:Disconnect();
            u19._typingConnection = nil;
        end;

        if u19._typingValue then
            u19._typingValue:Destroy();
            u19._typingValue = nil;
        end;

        u19._typingTween = nil;
    end);
    v28:Play();
end;

function u1.Clear(p29) -- Line: 209
    p29:Stop();
    p29._textLabel.Text = "";
end;

return u1;