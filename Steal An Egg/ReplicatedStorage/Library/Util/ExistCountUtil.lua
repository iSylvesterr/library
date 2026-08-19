-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LibDeflate = require(ReplicatedStorage.Library.Functions.LibDeflate);
local Buffer = require(ReplicatedStorage.Library.Modules.Buffer);
local CRC32C = require(ReplicatedStorage.Library.Functions.CRC32C);
local Hash = require(ReplicatedStorage.Library.Functions.Hash);
local Digest = require(ReplicatedStorage.Library.Functions.MurmurHash3).Digest;
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();

return {
    encodeFromHash = function(p2) -- Line: 18, Name: encodeFromHash
        -- upvalues: Buffer (copy), LibDeflate (copy), Hash (copy), CRC32C (copy)
        local v3 = {};
        local v4 = 4;

        for i in pairs(p2) do
            table.insert(v3, i);
            v4 = v4 + 12;
        end;

        table.sort(v3);
        local v5 = Buffer.allocate(v4);
        v5:writeu32(#v3);
        local v6 = 0;

        for _, v in ipairs(v3) do
            v5:writeu32(v - v6);
            v6 = v;
        end;

        for _, v in ipairs(v3) do
            v5:writei64(p2[v]);
        end;

        v5:flip();
        local v7 = LibDeflate:CompressDeflate((tostring(v5)));

        return Hash.bin_to_base64(v7), CRC32C((tostring(v5)));
    end,

    hashKey = function(p8, p9) -- Line: 45, Name: hashKey
        -- upvalues: Digest (copy)
        return Digest(p8 .. p9);
    end,

    decode = function(p10) -- Line: 49, Name: decode
        -- upvalues: Hash (copy), u1 (copy), LibDeflate (copy), Buffer (copy)
        if typeof(p10) ~= "string" then
            return {};
        end;

        local success, result = pcall(Hash.base64_to_bin, p10);

        if not success then
            u1:AtWarning():Log(`Failed to decode base64 data for exist counts: {result}`, p10);

            return {};
        end;

        local v11 = LibDeflate:DecompressDeflate(result);

        if not v11 then
            return {};
        end;

        local v12 = Buffer.from(v11);
        local v13 = v12:readu32();
        local v14 = table.create(v13, 0);
        local v15 = 0;

        for i = 1, v13 do
            v15 = v15 + v12:readu32();
            v14[i] = v15;
        end;

        local v16 = {};

        for i = 1, v13 do
            v16[v14[i]] = v12:readi64();
        end;

        return v16;
    end
};