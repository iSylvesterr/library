-- Decompiled with Potassium's decompiler.

local SkillResPreload = require(script.Parent.SkillResPreload);
local u1 = {
    Category = {
        Skill = "Skill"
    }
};
local u2 = false;

function u1.init() -- Line: 54
    -- upvalues: u2 (ref)
    if u2 then
        return;
    end;

    u2 = true;
end;

function u1.preload(p3) -- Line: 67
    -- upvalues: u2 (ref), u1 (copy), SkillResPreload (copy)
    if not u2 then
        u1.init();
    end;

    if p3.category == "Skill" then
        SkillResPreload.handle(p3.skillIds);

        return;
    end;

    warn("[PreloadManager] 未知预加载类别:", p3.category);
end;

return u1;