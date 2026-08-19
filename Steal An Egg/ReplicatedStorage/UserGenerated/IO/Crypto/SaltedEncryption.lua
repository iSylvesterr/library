-- Decompiled with Potassium's decompiler.

local AES = require(game.ReplicatedStorage.UserGenerated.IO.Crypto.AES);
local Base64 = require(game.ReplicatedStorage.UserGenerated.IO.Base64);
local HMAC = require(game.ReplicatedStorage.UserGenerated.IO.Crypto.HMAC);
local ISAAC = require(game.ReplicatedStorage.UserGenerated.Randoms.ISAAC);
local SHA256 = require(game.ReplicatedStorage.UserGenerated.IO.Crypto.SHA256);
require(game.ReplicatedStorage.UserGenerated.IO.Crypto.Hash);
local u1 = ISAAC.Unique();

local function GetRandomBytes(p2) -- Line: 44
    -- upvalues: u1 (copy)
    local v3 = buffer.create(p2);

    for i = 0, p2 - 1 do
        local v4 = u1:NextInteger(0, 255);
        buffer.writeu8(v3, i, v4);
    end;

    return v3;
end;

local function PBKDF2(p5, p6, p7, p8, p9) -- Line: 62
    -- upvalues: HMAC (copy)
    local v10 = HMAC.Derive(p9, p5);
    local OutputSize = p9.OutputSize;
    local v11 = math.ceil(p7 / OutputSize);
    local v12 = buffer.create(p7);
    local v13 = 0;

    for i = 1, v11 do
        local v14 = buffer.create(buffer.len(p6) + 4);
        buffer.copy(v14, 0, p6);
        local v15 = buffer.len(p6);
        local v16 = bit32.byteswap(i);
        buffer.writeu32(v14, v15, v16);
        local v17 = v10.DigestBuffer(v14);
        local v18 = buffer.create(buffer.len(v17));
        buffer.copy(v18, 0, v17);

        for _ = 2, p8 do
            v17 = v10.DigestBuffer(v17);

            for i2 = 0, buffer.len(v17) - 1 do
                local v19 = buffer.readu8(v18, i2);
                local v20 = buffer.readu8(v17, i2);
                local v21 = bit32.bxor(v19, v20);
                buffer.writeu8(v18, i2, v21);
            end;
        end;

        local v22 = math.min(OutputSize, p7 - v13);
        buffer.copy(v12, v13, v18, 0, v22);
        v13 = v13 + v22;
    end;

    return v12;
end;

local function ApplyPKCS7Padding(p23) -- Line: 109
    local v24 = buffer.len(p23);
    local v25 = 16 - v24 % 16;
    local v26 = v24 + v25;
    local v27 = buffer.create(v26);
    buffer.copy(v27, 0, p23);

    for i = v24, v26 - 1 do
        buffer.writeu8(v27, i, v25);
    end;

    return v27;
end;

local function RemovePKCS7Padding(p28) -- Line: 131
    local v29 = buffer.len(p28);

    if v29 == 0 then
        error("Invalid padding: empty input");
    end;

    local v30 = buffer.readu8(p28, v29 - 1);

    if v30 < 1 or v30 > 16 then
        error("Invalid padding length: " .. v30);
    end;

    for i = v29 - v30, v29 - 1 do
        if buffer.readu8(p28, i) ~= v30 then
            error("Invalid padding");
        end;
    end;

    local v31 = v29 - v30;
    local v32 = buffer.create(v31);
    buffer.copy(v32, 0, p28, 0, v31);

    return v32;
end;

local function Encrypt(p33, p34, p35) -- Line: 166
    -- upvalues: SHA256 (copy), GetRandomBytes (copy), PBKDF2 (copy), ApplyPKCS7Padding (copy), AES (copy), Base64 (copy)
    local v36 = buffer.fromstring(p33);
    local v37 = GetRandomBytes(8);
    local v38 = PBKDF2(p34, v37, 48, 10000, p35 or SHA256);
    local v39 = buffer.create(32);
    buffer.copy(v39, 0, v38, 0, 32);
    local v40 = buffer.create(16);
    buffer.copy(v40, 0, v38, 32, 16);
    local v41 = ApplyPKCS7Padding(v36);
    local v42 = AES.new(buffer.tostring(v39), AES.modes.CBC, AES.pads.None):Encrypt(v41, nil, v40);
    local v43 = 16 + buffer.len(v42);
    local v44 = buffer.create(v43);
    buffer.writestring(v44, 0, "Salted__");
    buffer.copy(v44, 8, v37);
    buffer.copy(v44, 16, v42);

    return buffer.tostring(Base64.EncodeBuffer(v44));
end;

local function Decrypt(p45, p46, p47) -- Line: 220
    -- upvalues: SHA256 (copy), Base64 (copy), PBKDF2 (copy), AES (copy), RemovePKCS7Padding (copy)
    local v48 = Base64.DecodeBuffer(buffer.fromstring(p45));

    if buffer.len(v48) < 16 then
        error("Invalid data: too short");
    end;

    local v49 = buffer.create(8);
    buffer.copy(v49, 0, v48, 0, 8);

    if buffer.tostring(v49) ~= "Salted__" then
        error("Invalid data: Missing \'Salted__\' header");
    end;

    local v50 = buffer.create(8);
    buffer.copy(v50, 0, v48, 8, 8);
    local v51 = buffer.len(v48) - 16;
    local v52 = buffer.create(v51);
    buffer.copy(v52, 0, v48, 16, v51);
    local v53 = PBKDF2(p46, v50, 48, 10000, p47 or SHA256);
    local v54 = buffer.create(32);
    buffer.copy(v54, 0, v53, 0, 32);
    local v55 = buffer.create(16);
    buffer.copy(v55, 0, v53, 32, 16);
    local v56 = RemovePKCS7Padding((AES.new(buffer.tostring(v54), AES.modes.CBC, AES.pads.None):Decrypt(v52, nil, v55)));

    return buffer.tostring(v56);
end;

local v63 = {
    Encrypt = Encrypt,
    Decrypt = Decrypt,

    EncryptString = function(p57, p58, p59) -- Line: 281, Name: EncryptString
        -- upvalues: Encrypt (copy)
        return Encrypt(p57, buffer.fromstring(p58), p59);
    end,

    DecryptString = function(p60, p61, p62) -- Line: 294, Name: DecryptString
        -- upvalues: Decrypt (copy)
        return Decrypt(p60, buffer.fromstring(p61), p62);
    end,

    PBKDF2 = PBKDF2,
    GetRandomBytes = GetRandomBytes
};
table.freeze(v63);

return v63;