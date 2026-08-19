-- Decompiled with Potassium's decompiler.

local Trove = require(script.Parent.Parent.Trove);
require(script.Parent.Streamable);

return {
    Compound = function(u1, u2) -- Line: 47, Name: Compound
        -- upvalues: Trove (copy)
        local v3 = Trove.new();
        local u4 = Trove.new();
        local u5 = false;

        local function Check() -- Line: 51
            -- upvalues: u5 (ref), u1 (copy), u2 (copy), u4 (copy)
            if u5 then
                return;
            end;

            for _, v in pairs(u1) do
                if not v.Instance then
                    return;
                end;
            end;

            u5 = true;
            u2(u1, u4);
        end;

        local function Cleanup() -- Line: 63
            -- upvalues: u5 (ref), u4 (copy)
            if not u5 then
                return;
            end;

            u5 = false;
            u4:Clean();
        end;

        for _, v in pairs(u1) do
            v3:Add(v:Observe(function(p6, p7) -- Line: 71
                -- upvalues: u5 (ref), u1 (copy), u2 (copy), u4 (copy), Cleanup (copy)
                if not u5 then
                    for _, v2 in pairs(u1) do
                        if not v2.Instance then
                            break;
                        end;
                    end;
                end;

                p7:Add(Cleanup);
            end));
        end;

        v3:Add(Cleanup);

        return v3;
    end
};