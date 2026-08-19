-- Decompiled with Potassium's decompiler.

game:GetService("RunService");
local v1 = {};
local u2 = Random.new();

function v1.totalWeight(p3, p4) -- Line: 25
    local v5 = 0;

    for _, v in p4 do
        v5 = v5 + v.weight;
    end;

    return v5;
end;

function v1.Roll(p6, p7, p8) -- Line: 33
    -- upvalues: u2 (copy)
    local v9 = p6:totalWeight(p7);
    local v10 = u2:NextInteger(1, v9);

    if p8 then
        print("total weight ", v9);
        print("rand ", v10);
        print("table ", p7);
    end;

    for i, v in p7 do
        v10 = v10 - v.weight;

        if v10 < 1 then
            if p8 then
                print("result ", v);
            end;

            return v, i;
        end;
    end;

    error("roll went oob, this should never occur");
end;

return v1;