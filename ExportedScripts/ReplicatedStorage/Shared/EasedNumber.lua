-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local u1 = {};
u1.__index = u1;

local function lerp(p2, p3, p4) -- Line: 17
    return (1 - p4) * p2 + p3 * p4;
end;

function u1.new(p5) -- Line: 21
    -- upvalues: u1 (copy)
    local v6 = setmetatable({}, u1);
    v6.value = p5;
    v6.lastValue = p5;
    v6.goal = p5;
    v6.timestamp = 0;
    v6.rate = nil;
    v6.tweenInfo = nil;

    return v6;
end;

function u1.setGoal(p7, p8) -- Line: 35
    p7.lastValue = p7.value;
    p7.goal = p8;
    p7.timestamp = os.clock();
end;

function u1.useFixedRate(p9, p10) -- Line: 41
    p9.rate = p10;
    p9.tweenInfo = nil;
end;

function u1.useTween(p11, p12) -- Line: 46
    p11.rate = nil;
    p11.tweenInfo = p12;
end;

function u1.get(p13) -- Line: 51
    return p13.value;
end;

function u1.update(p14, p15) -- Line: 55
    -- upvalues: TweenService (copy)
    if p14.value == p14.goal then
        return;
    end;

    if not p14.tweenInfo then
        if p14.rate then
            local v16 = p14.rate * math.sign(p14.goal - p14.value) * p15;
            local v17 = p14.value + v16;

            if v16 < 0 then
                p14.value = math.max(v17, p14.goal);

                return;
            end;

            p14.value = math.min(v17, p14.goal);
        end;

        return;
    end;

    local v18 = (os.clock() - p14.timestamp) / p14.tweenInfo.Time;
    local v19 = TweenService:GetValue(math.clamp(v18, 0, 1), p14.tweenInfo.EasingStyle, p14.tweenInfo.EasingDirection);
    p14.value = (1 - v19) * p14.lastValue + p14.goal * v19;
end;

return u1;