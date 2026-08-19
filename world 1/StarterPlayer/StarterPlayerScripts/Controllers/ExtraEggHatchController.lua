-- Decompiled with Potassium's decompiler.

local u1 = {};
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local u2 = Random.new();
TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0);
require(game.Players.LocalPlayer.PlayerScripts.Controllers.BlockSmashController);
local u3 = {};

function u1.StopWobble(p4, p5) -- Line: 14
    -- upvalues: u3 (copy)
    local v6 = u3[p5];

    if v6 then
        v6.Connection:Disconnect();

        if p5.Parent then
            p5:PivotTo(v6.StartPivot);
        end;

        u3[p5] = nil;
    end;
end;

function u1.ScaleUp(p7, u8, u9, u10, p11) -- Line: 25
    -- upvalues: u1 (copy), RunService (copy), TweenService (copy)
    u1:StopWobble(u8);
    local u12 = p11 or Enum.EasingStyle.Exponential;
    local v13, v14 = u8:GetBoundingBox();
    local u15 = v13.Position.Y - v14.Y / 2;
    local u16 = u8:GetScale();
    local u17 = os.clock();
    local u18 = nil;
    u18 = RunService.Heartbeat:Connect(function() -- Line: 34
        -- upvalues: u8 (copy), u18 (ref), u17 (copy), u10 (copy), TweenService (ref), u12 (ref), u16 (copy), u9 (copy), u15 (copy)
        if not u8.Parent then
            u18:Disconnect();

            return;
        end;

        local v19 = (os.clock() - u17) / u10;
        local v20 = math.clamp(v19, 0, 1);
        local v21 = TweenService:GetValue(v20, u12, Enum.EasingDirection.Out);
        u8:ScaleTo(u16 + (u9 - u16) * v21);
        local v22, v23 = u8:GetBoundingBox();
        local v24 = v22.Position.Y - v23.Y / 2;
        u8:PivotTo(u8:GetPivot() + Vector3.new(0, u15 - v24, 0));

        if v20 >= 1 then
            u18:Disconnect();
        end;
    end);
end;

function u1.Wobble(p25, u26, p27, p28) -- Line: 53
    -- upvalues: u1 (copy), u2 (copy), RunService (copy), u3 (copy)
    u1:StopWobble(u26);
    local u29 = p27 or 1;
    local u30 = p28 or 0.5;
    local v31, v32 = u26:GetBoundingBox();
    u26.WorldPivot = v31 * CFrame.new(0, -v32.Y / 2, 0);
    local u33 = u26:GetPivot();
    local u34 = os.clock();
    local u35 = u2:NextNumber(0, 6.283185307179586);
    local u36 = u2:NextInteger(0, 1) == 0 and 1 or -1;
    local u37 = nil;
    u37 = RunService.Heartbeat:Connect(function() -- Line: 66
        -- upvalues: u26 (copy), u37 (ref), u3 (ref), u34 (copy), u30 (ref), u29 (ref), u36 (copy), u33 (copy), u35 (copy)
        if not u26.Parent then
            u37:Disconnect();
            u3[u26] = nil;

            return;
        end;

        local v38 = os.clock() - u34;
        local v39 = math.clamp(v38 / u30, 0, 1);
        local v40 = math.sin(v38 * 25) * 0.2617993877991494 * u29 * (1 - v39) * u36;
        u26:PivotTo(u33 * CFrame.Angles(0, u35, 0) * CFrame.Angles(0, 0, v40) * CFrame.Angles(0, -u35, 0));

        if v39 >= 1 then
            u26:PivotTo(u33);
            u37:Disconnect();
            u3[u26] = nil;
        end;
    end);
    u3[u26] = {
        Connection = u37,
        StartPivot = u33
    };
end;

function u1.ScaleUpInstant(p41, p42, p43) -- Line: 88
    -- upvalues: u1 (copy)
    u1:StopWobble(p42);
    local v44, v45 = p42:GetBoundingBox();
    local v46 = v44.Position.Y - v45.Y / 2;
    p42:ScaleTo(p43);
    local v47, v48 = p42:GetBoundingBox();
    local v49 = v47.Position.Y - v48.Y / 2;
    p42:PivotTo(p42:GetPivot() + Vector3.new(0, v46 - v49, 0));
end;

function u1.PopupFadeEffect(p50, p51, p52, p53) -- Line: 100
    -- upvalues: u1 (copy), TweenService (copy)
    local v54 = p51:Clone();
    v54.Parent = game.Workspace;
    v54:PivotTo(p51:GetPivot());
    u1:ScaleUp(v54, p52, 0.5);
    local v55 = TweenInfo.new(p53, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0);

    for _, descendant in pairs(v54:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            local v56 = TweenService:Create(descendant, v55, {
                Transparency = 1
            });
            v56:Play();
            game.Debris:AddItem(v56, v55.Time);
        end;
    end;

    game.Debris:AddItem(v54, v55.Time);
end;

function u1.PlayPopVFX(p57, p58, p59) -- Line: 120
    for _, descendant in pairs(p58.Main:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") and descendant.Name == "Level" .. tostring(p59) then
            descendant:Emit(descendant:GetAttribute("EmitCount"));
        end;
    end;
end;

function u1.HighlightFlash(p60, p61, p62) -- Line: 129
    -- upvalues: TweenService (copy)
    local v63 = TweenInfo.new(p62, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);
    local Highlight = Instance.new("Highlight");
    Highlight.OutlineTransparency = 1;
    Highlight.FillColor = Color3.new(1, 1, 1);
    Highlight.FillTransparency = 0;
    Highlight.Parent = p61;
    Highlight.Adornee = p61;
    local v64 = TweenService:Create(Highlight, v63, {
        FillTransparency = 1
    });
    v64:Play();
    game.Debris:AddItem(v64, v63.Time);
    game.Debris:AddItem(Highlight, v63.Time);
end;

function u1.PlayHatchUpOne(p65, p66) -- Line: 144
    -- upvalues: u1 (copy)
    u1:ScaleUpInstant(p66, 2);
    u1:PopupFadeEffect(p66, 3, 0.5);
    u1:PlayPopVFX(p66, 1);
    u1:HighlightFlash(p66, 0.5);
end;

function u1.PlayHatchUpTwo(p67, p68) -- Line: 154
    -- upvalues: u1 (copy)
    u1:ScaleUpInstant(p68, 4);
    u1:PopupFadeEffect(p68, 7, 0.5);
    u1:PlayPopVFX(p68, 2);
    u1:HighlightFlash(p68, 0.5);
end;

function u1.PlayHatchUpOneElastic(p69, u70) -- Line: 164
    -- upvalues: u1 (copy)
    u1:ScaleUp(u70, 1.35, 1.2, Enum.EasingStyle.Elastic);
    task.spawn(function() -- Line: 167
        -- upvalues: u1 (ref), u70 (copy)
        task.wait(0.2);
        u1:PopupFadeEffect(u70, 1.75, 0.5);
        u1:PlayPopVFX(u70, 1);
        u1:HighlightFlash(u70, 0.5);
    end);
end;

function u1.PlayHatchUpTwoElastic(p71, u72) -- Line: 175
    -- upvalues: u1 (copy)
    u1:ScaleUp(u72, 2, 1.2, Enum.EasingStyle.Elastic);
    task.spawn(function() -- Line: 178
        -- upvalues: u1 (ref), u72 (copy)
        task.wait(0.2);
        u1:PopupFadeEffect(u72, 2.5, 0.5);
        u1:PlayPopVFX(u72, 2);
        u1:HighlightFlash(u72, 0.5);
    end);
end;

function u1.PlayHatchUpScale(p73, p74, p75, p76) -- Line: 186
    -- upvalues: u1 (copy)
    u1:ScaleUpInstant(p74, p75);
    u1:PopupFadeEffect(p74, p75 * 1.5, 0.5);
    u1:PlayPopVFX(p74, p76);
    u1:HighlightFlash(p74, 0.5);
end;

function u1.NormalEffect(p77, p78) -- Line: 196
    -- upvalues: u2 (copy), u1 (copy)
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:Wobble(p78, 0.7, 0.5);

    if math.random(1, 10) == 1 then
        task.wait(u2:NextNumber(0.5, 1.5));
        u1:Wobble(p78, 0.7, 0.5);
    end;

    task.wait(u2:NextNumber(0.5, 1.5));
end;

function u1.BigEffect(p79, p80) -- Line: 206
    -- upvalues: u2 (copy), u1 (copy)
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:Wobble(p80, 0.7, 0.5);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:Wobble(p80, 0.7, 0.5);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:PlayHatchUpOne(p80);

    if math.random(1, 10) == 1 then
        task.wait(u2:NextNumber(0.5, 1.5));
        u1:Wobble(p80, 0.7, 0.5);
    end;

    task.wait(u2:NextNumber(0.5, 1.5));
end;

function u1.HugeEffect(p81, p82) -- Line: 220
    -- upvalues: u2 (copy), u1 (copy)
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:Wobble(p82, 0.7, 0.5);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:Wobble(p82, 0.7, 0.5);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:PlayHatchUpOne(p82);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:Wobble(p82, 0.7, 0.5);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:PlayHatchUpTwo(p82);
end;

function u1.NormalEffectMode2(p83, p84) -- Line: 233
    -- upvalues: u2 (copy), u1 (copy)
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:Wobble(p84, 0.7, 0.5);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:Wobble(p84, 0.7, 0.5);

    if math.random(1, 10) == 1 then
        task.wait(u2:NextNumber(0.5, 1.5));
        u1:Wobble(p84, 1, 0.5);
        task.wait(u2:NextNumber(0.5, 1.5));
        u1:PlayHatchUpScale(p84, 1.5, 1);
        task.wait(u2:NextNumber(0.5, 1.5));
        u1:Wobble(p84, 0.7, 0.5);
    end;

    task.wait(u2:NextNumber(0.5, 1.5));
end;

function u1.BigEffectMode2(p85, p86) -- Line: 249
    -- upvalues: u2 (copy), u1 (copy)
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:Wobble(p86, 0.7, 0.5);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:Wobble(p86, 0.7, 0.5);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:Wobble(p86, 1, 0.5);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:PlayHatchUpScale(p86, 1.5, 1);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:Wobble(p86, 0.7, 0.5);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:Wobble(p86, 1, 0.5);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:PlayHatchUpScale(p86, 2, 2);

    if math.random(1, 10) == 1 then
        task.wait(u2:NextNumber(0.5, 1.5));
        u1:Wobble(p86, 1.2, 0.75);
        task.wait(u2:NextNumber(0.5, 1.5));
        u1:PlayHatchUpScale(p86, 3, 3);
        task.wait(u2:NextNumber(0.5, 1.5));
        u1:Wobble(p86, 0.7, 0.5);
    end;

    task.wait(u2:NextNumber(0.5, 1.5));
end;

function u1.HugeEffectMode2(p87, p88) -- Line: 275
    -- upvalues: u2 (copy), u1 (copy)
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:Wobble(p88, 0.7, 0.5);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:Wobble(p88, 0.7, 0.5);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:Wobble(p88, 1, 0.5);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:PlayHatchUpScale(p88, 1.5, 1);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:Wobble(p88, 0.7, 0.5);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:Wobble(p88, 1, 0.5);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:PlayHatchUpScale(p88, 2, 2);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:Wobble(p88, 1.2, 0.75);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:PlayHatchUpScale(p88, 3, 3);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:Wobble(p88, 1.5, 0.75);
    task.wait(u2:NextNumber(0.5, 1.5));
    u1:PlayHatchUpScale(p88, 4, 3);
    task.wait(u2:NextNumber(0.5, 1.5));
end;

function u1.HatchEgg(p89, u90, u91, p92, p93) -- Line: 301
    -- upvalues: u1 (copy)
    local u94 = p93 or 1;

    if p92 == "Instant" then
        task.spawn(function() -- Line: 306
            -- upvalues: u94 (ref), u91 (copy), u1 (ref), u90 (copy)
            if u94 == 1 then
                if u91 == "Normal" then
                    u1:NormalEffect(u90);

                    return;
                end;

                if u91 == "Big" then
                    u1:BigEffect(u90);

                    return;
                end;

                if u91 == "Huge" then
                    u1:HugeEffect(u90);
                end;
            elseif u94 == 2 then
                if u91 == "Normal" then
                    u1:NormalEffectMode2(u90);

                    return;
                end;

                if u91 == "Big" then
                    u1:BigEffectMode2(u90);

                    return;
                end;

                if u91 == "Huge" then
                    u1:HugeEffectMode2(u90);
                end;
            end;
        end);
    end;
end;

return u1;