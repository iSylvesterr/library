-- Decompiled with Potassium's decompiler.

local u1 = {
    tags = {},
    tagStack = {}
};

function u1.BeginSample(p2, p3) -- Line: 7
    -- upvalues: u1 (copy)
    local v4 = p2.tags[p3];

    if v4 == nil then
        v4 = {
            averages = {},
            average = 0,
            currentSample = 0
        };
        p2.tags[p3] = v4;
    end;

    v4._startTime = os.clock();
    table.insert(u1.tagStack, p3);
end;

function u1.EndSample(p5) -- Line: 22
    -- upvalues: u1 (copy)
    if #u1.tagStack == 0 then
        warn("Profile tagstack already empty");

        return;
    end;

    local v6 = u1.tags[u1.tagStack[#u1.tagStack]];
    table.remove(u1.tagStack, #u1.tagStack);
    v6.currentSample = os.clock() - v6._startTime;
    table.insert(v6.averages, v6.currentSample);

    if #v6.averages > 10 then
        table.remove(v6.averages, 1);
    end;
end;

function u1.Print(p7, p8) -- Line: 38
    -- upvalues: u1 (copy)
    local v9 = u1.tags[p8];

    if v9 == nil then
        warn("Unknown tag");

        return;
    end;

    local v10 = 0;
    local v11 = 0;

    for _, v in v9.averages do
        v10 = v10 + v;
        v11 = v11 + 1;
    end;

    print(p8, string.format("%.3f", v9.currentSample * 1000) .. "ms avg:", string.format("%.3f", v10 / v11 * 1000) .. "ms");
end;

local _ = os.clock() + 1;

return u1;