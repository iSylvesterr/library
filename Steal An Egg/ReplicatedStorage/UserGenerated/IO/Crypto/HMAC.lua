-- Decompiled with Potassium's decompiler.

require(game.ReplicatedStorage.UserGenerated.IO.Crypto.Hash);

local function Derive(u1, p2) -- Line: 46
    local BlockSize = u1.BlockSize;

    if BlockSize < buffer.len(p2) then
        p2 = u1.DigestBuffer(p2);
    end;

    local v3 = buffer.create(BlockSize);
    buffer.copy(v3, 0, p2);
    local u4 = buffer.create(BlockSize);
    local u5 = buffer.create(BlockSize);

    for i = 0, BlockSize - 1 do
        local v6 = buffer.readu8(v3, i);
        local v7 = bit32.bxor(v6, 92);
        buffer.writeu8(u4, i, v7);
        local v8 = bit32.bxor(v6, 54);
        buffer.writeu8(u5, i, v8);
    end;

    local function ComputeHmac(p9) -- Line: 69
        -- upvalues: BlockSize (copy), u5 (copy), u1 (copy), u4 (copy)
        local v10 = buffer.create(BlockSize + buffer.len(p9));
        buffer.copy(v10, 0, u5);
        buffer.copy(v10, BlockSize, p9);
        local v11 = u1.DigestBuffer(v10);
        local v12 = buffer.create(BlockSize + buffer.len(v11));
        buffer.copy(v12, 0, u4);
        buffer.copy(v12, BlockSize, v11);

        return u1.DigestBuffer(v12);
    end;

    return {
        Name = "HMAC-" .. u1.Name,
        BlockSize = u1.BlockSize,
        OutputSize = u1.OutputSize,

        Digest = function(p13) -- Line: 89, Name: Digest
            -- upvalues: ComputeHmac (copy)
            return buffer.tostring(ComputeHmac(buffer.fromstring(p13)));
        end,

        DigestBuffer = ComputeHmac,

        DigestToBuffer = function(p14) -- Line: 93, Name: DigestToBuffer
            -- upvalues: ComputeHmac (copy)
            return ComputeHmac(buffer.fromstring(p14));
        end
    };
end;

return {
    Derive = Derive,

    DeriveString = function(p15, p16) -- Line: 108, Name: DeriveString
        -- upvalues: Derive (copy)
        return Derive(p15, buffer.fromstring(p16));
    end
};