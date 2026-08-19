-- Decompiled with Potassium's decompiler.

local ContentProvider = game:GetService("ContentProvider");

local function insertAsset(p1, p2) -- Line: 8
    -- upvalues: insertAsset (copy)
    if typeof(p2) == "Instance" or type(p2) == "string" then
        table.insert(p1, p2);

        return;
    end;

    if type(p2) == "number" then
        local v3 = ("rbxassetid://%d"):format(p2);
        table.insert(p1, v3);

        return;
    end;

    if type(p2) == "table" then
        for _, v in pairs(p2) do
            insertAsset(p1, v);
        end;

        return;
    end;

    error(("Unknown type: %s"):format((type(p2))));
end;

local function preloadWithRetry(p4, p5) -- Line: 25
    -- upvalues: ContentProvider (copy)
    local v6 = table.clone(p4);

    for i = 1, 3 do
        local u7 = {};
        local success, result = pcall(ContentProvider.PreloadAsync, ContentProvider, v6, function(p8, p9) -- Line: 32, Name: onStatus
            -- upvalues: u7 (ref)
            if p9 ~= Enum.AssetFetchStatus.Success then
                table.insert(u7, p8);
            end;
        end);

        if not success then
            warn(("PreloadAsync threw on attempt %d: %s"):format(i, result), p5);
            u7 = v6;
        end;

        if #u7 == 0 then
            return true;
        end;

        v6 = u7;
        task.wait(i * 0.5);
    end;

    return false, v6;
end;

return function(...) -- Line: 55
    -- upvalues: insertAsset (copy), preloadWithRetry (copy)
    local v10 = table.pack(...);
    local v11 = {};

    for i = 1, v10.n do
        insertAsset(v11, v10[i]);
    end;

    local v12 = debug.traceback();
    local v13, v14 = preloadWithRetry(v11, v12);

    if not v13 then
        warn(("still failing after %d retries:"):format(3), v14, v12);
    end;

    return v11;
end;