-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");

function FastTween(p1, p2, p3, p4)
    -- upvalues: TweenService (copy)
    local u5 = TweenService:Create(p1, p2, p3);
    u5.Completed:Once(function() -- Line: 6
        -- upvalues: u5 (copy)
        u5:Destroy();
    end);

    if p4 ~= false then
        u5:Play();
    end;

    return u5;
end;

return FastTween;