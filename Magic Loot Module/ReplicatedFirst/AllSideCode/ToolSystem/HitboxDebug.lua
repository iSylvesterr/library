-- Decompiled with Potassium's decompiler.

local HitboxDebugConfig = require(script.HitboxDebugConfig);
local u3 = {
    shouldShow = function(p1) -- Line: 29, Name: shouldShow
        -- upvalues: HitboxDebugConfig (copy)
        local v2 = tonumber(p1);

        if v2 and v2 > 0 then
            return HitboxDebugConfig.SHOW_SKILL_IDS[v2] == true;
        end;

        return false;
    end
};

function u3.applyPartTransparency(p4, p5, p6) -- Line: 43
    -- upvalues: u3 (copy), HitboxDebugConfig (copy)
    if not p4 then
        return;
    end;

    if p6 and u3.shouldShow(p5) then
        p4.Transparency = HitboxDebugConfig.DEBUG_TRANSPARENCY;

        return;
    end;

    p4.Transparency = 1;
end;

return u3;