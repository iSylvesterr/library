-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local PartIcles = require(script.Parent.Parent.PartIcles);
local u1 = {};
local u2 = false;
local u3 = {
    await = true,
    parseDuration = true
};

function u1.EnsureActivated() -- Line: 44
    -- upvalues: u2 (ref), RunService (copy), PartIcles (copy)
    if u2 then
        return;
    end;

    if not RunService:IsClient() then
        return;
    end;

    if PartIcles.Connection then
        u2 = true;

        return;
    end;

    if type(PartIcles.Activate) ~= "function" then
        return;
    end;

    PartIcles:Activate();
    u2 = true;
end;

function u1.Stop(p4, p5, p6) -- Line: 71
    -- upvalues: u1 (copy), PartIcles (copy)
    if p4 ~= u1 then
        p6 = p5;
        p5 = p4;
    end;

    if not p5 then
        return;
    end;

    u1.EnsureActivated();

    if p6 then
        PartIcles:Disable(p5);

        return;
    end;

    PartIcles:SoftDisable(p5);
end;

setmetatable(u1, {
    __index = function(p7, p8) -- Line: 93, Name: __index
        -- upvalues: PartIcles (copy), u3 (copy), RunService (copy), u2 (ref), u1 (copy)
        local u9 = PartIcles[p8];

        if type(u9) == "function" then
            return not u3[p8] and (p8 == "Activate" and function(p10, ...) -- Line: 103
                -- upvalues: RunService (ref), u9 (copy), PartIcles (ref), u2 (ref)
                if RunService:IsClient() then
                    local v11 = u9(PartIcles, ...);
                    u2 = true;

                    return v11;
                end;
            end or (p8 == "Deactivate" and function(p12, ...) -- Line: 113
                -- upvalues: u2 (ref), u9 (copy), PartIcles (ref)
                u2 = false;

                return u9(PartIcles, ...);
            end or function(p13, ...) -- Line: 118
                -- upvalues: u1 (ref), u9 (copy), PartIcles (ref)
                u1.EnsureActivated();

                return u9(PartIcles, ...);
            end)) or u9;
        end;

        return u9;
    end
});

return u1;