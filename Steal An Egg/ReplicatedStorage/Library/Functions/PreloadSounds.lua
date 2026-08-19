-- Decompiled with Potassium's decompiler.

local ContentProvider = game:GetService("ContentProvider");

local function insertAsset(p1, p2) -- Line: 5
    -- upvalues: insertAsset (copy)
    local v3 = type(p2);

    if v3 == "string" then
        table.insert(p1, p2);

        return nil;
    end;

    if v3 == "number" then
        local v4 = "rbxassetid://" .. tostring(p2);
        table.insert(p1, v4);

        return nil;
    end;

    if v3 == "table" then
        for _, v in pairs(p2) do
            insertAsset(p1, v);
        end;

        return nil;
    end;

    error(("Unknown type: %s"):format(v3));
end;

return function(...) -- Line: 23
    -- upvalues: insertAsset (copy), ContentProvider (copy)
    local v5 = table.pack(...);
    local v6 = {};

    for i = 1, v5.n do
        insertAsset(v6, v5[i]);
    end;

    local v7 = {};

    for _, v in ipairs(v6) do
        local Sound = Instance.new("Sound");
        Sound.SoundId = v;
        table.insert(v7, Sound);
    end;

    ContentProvider:PreloadAsync(v7);

    return nil;
end;