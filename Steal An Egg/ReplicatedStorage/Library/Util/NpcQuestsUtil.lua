-- Decompiled with Potassium's decompiler.

local u1 = {
    __database = {
        Merged_Packages = {
            ["Interact#Peach_Stars"] = { "Have#Stars" }
        },
        Error_Tokens = {
            INVALID_NODE = 1
        }
    }
};

function u1.Filter_Progress(p2, p3) -- Line: 14
    -- upvalues: u1 (copy)
    if typeof(p3) == "table" then
        p3 = p3.Tensor or p3;
    end;

    local v4 = u1.__database.Merged_Packages[p3];

    if v4 then
        v4 = table.find(v4, p2.Token);
    end;

    if p3 == "__Spoof" or v4 then
        p3 = p2.Token or p3;
    end;

    if p2.Token ~= p3 then
        return u1.__database.Error_Tokens.INVALID_NODE;
    end;

    if typeof(p2) == "table" and (p2.Modifier == "IncrementProgress" and p2.State == "Active") then
        return p2.Progress;
    end;
end;

return u1;