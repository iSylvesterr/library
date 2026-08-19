-- Decompiled with Potassium's decompiler.

local u1 = {
    List = {}
};
local u2 = nil;

local function AdjustSkyboxes() -- Line: 7
    -- upvalues: u1 (copy), u2 (ref)
    local v3 = nil;
    local v4 = nil;

    for i, v in u1.List do
        if not v3 or v3 <= v then
            v4 = i;
            v3 = v;
        end;
    end;

    if u2 and u2 ~= v4 then
        u2.Parent = script;
    end;

    u2 = v4;
    v4.Parent = game.Lighting;
end;

function u1.SetOrder(p5, p6) -- Line: 28
    -- upvalues: u1 (copy), AdjustSkyboxes (copy)
    u1.List[p5] = p6;
    AdjustSkyboxes();
end;

u1.SetOrder(game.Lighting.Sky, 1);

return u1;