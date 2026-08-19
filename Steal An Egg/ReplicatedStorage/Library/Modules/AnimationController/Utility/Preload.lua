-- Decompiled with Potassium's decompiler.

local u7 = {
    preloadAnimArray = function(p1, p2, p3, p4) -- Line: 5, Name: preloadAnimArray
        local v5 = {};

        for _, v in p2 do
            local Animation = Instance.new("Animation");
            Animation.AnimationId = "rbxassetid://" .. tostring(v.id);
            local v6 = p1:LoadAnimation(Animation);
            v6.Priority = p4;
            v6.Looped = v.looped == nil and true or v.looped;
            v6.Name = p3;
            v5[#v5 + 1] = {
                anim = v6,
                weight = v.weight,
                fadeTime = v.fadeTime,
                speed = v.speed
            };
        end;

        return v5;
    end
};

function u7.preloadAnimList(p8, p9, p10, p11) -- Line: 27
    -- upvalues: u7 (copy)
    local v12 = {};

    for i, v in p9 do
        v12[i] = u7.preloadAnimArray(p8, v, p10, p11);
    end;

    return v12;
end;

return u7;