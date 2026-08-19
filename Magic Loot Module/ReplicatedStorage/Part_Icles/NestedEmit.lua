-- Decompiled with Potassium's decompiler.

local Pool = require(script.Parent.Pool);
local u10 = {
    walk = function(u1, p2, u3, u4, u5, u6) -- Line: 17, Name: walk
        -- upvalues: Pool (copy)
        local u7 = Pool._cloneMaps and Pool._cloneMaps[u3];

        local function visit(p8) -- Line: 19
            -- upvalues: u6 (copy), u5 (copy), u4 (copy), u7 (copy), u1 (copy), u3 (copy), visit (copy)
            if not p8:GetAttribute("Transformed") then
                for _, child in p8:GetChildren() do
                    visit(child);
                end;

                return;
            end;

            if u6 then
                u6(p8);
            end;

            local v9 = {};

            if u5 then
                v9.ChainCtx = u5.ChainCtx;
                v9.EmitIndex = u5.EmitIndex;
                v9.EmitCount = u5.EmitCount;
                v9._playToken = u5._playToken;
            end;

            v9._parentAlive = u4;
            v9._parentCloneMap = u7;
            u1:EnableEmit(p8, u3, v9);
        end;

        visit(p2);
    end
};

function u10.walkWithScale(u11, p12, p13, p14, p15, u16, p17) -- Line: 46
    -- upvalues: u10 (copy)
    if not u16 then
        u10.walk(u11, p12, p13, p14, p15);

        return;
    end;

    u11._parentScaleMap = u11._parentScaleMap or {};
    local u18 = {};
    u10.walk(u11, p12, p13, p14, p15, function(p19) -- Line: 53
        -- upvalues: u11 (copy), u16 (copy), u18 (copy)
        u11._parentScaleMap[p19] = u16;
        u18[#u18 + 1] = p19;
    end);
    p17._scaleMapKeys = u18;
end;

return u10;