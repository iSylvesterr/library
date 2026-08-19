-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(ReplicatedStorage.Library.Modules.TreadmillMediaIdentity.Types.Interface);
require(ReplicatedStorage.Library.Client.TreadmillVideoController.Types.Interface);
local u1 = {};

local function extractAssetId(p2) -- Line: 22
    local v3 = string.match(p2, "%d+");
    local v4;

    if v3 == nil then
        v4 = false;
    else
        v4 = v3 ~= "";
    end;

    local v5 = `Invalid treadmill media asset id "{p2}"`;
    assert(v4, v5);

    return v3;
end;

function u1.GetMediaKey(p6) -- Line: 32
    -- upvalues: Asserts (copy)
    Asserts.table(p6);

    if p6.Kind == "Video" then
        local Video = p6.Video;
        local v7 = string.match(Video, "%d+");
        local v8;

        if v7 == nil then
            v8 = false;
        else
            v8 = v7 ~= "";
        end;

        local v9 = `Invalid treadmill media asset id "{Video}"`;
        assert(v8, v9);

        return `Video:{v7}`;
    end;

    local Image = p6.Image;
    local v10 = string.match(Image, "%d+");
    local v11;

    if v10 == nil then
        v11 = false;
    else
        v11 = v10 ~= "";
    end;

    local v12 = `Invalid treadmill media asset id "{Image}"`;
    assert(v11, v12);

    return `Image:{v10}`;
end;

function u1.BuildMediaKeys(p13) -- Line: 42
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.table(p13);
    local v14 = {};
    local v15 = {};

    for _, v in ipairs(p13) do
        local v16 = u1.GetMediaKey(v);

        if not v14[v16] then
            v14[v16] = true;
            table.insert(v15, v16);
        end;
    end;

    return v15, v14;
end;

function u1.GetMediaKeyShardIndex(p17, p18) -- Line: 63
    -- upvalues: Asserts (copy)
    Asserts.string(p17);
    Asserts.positiveInteger(p18);
    local v19 = 0;

    for i = 1, #p17 do
        v19 = (v19 * 33 + string.byte(p17, i)) % p18;
    end;

    return v19;
end;

return u1;