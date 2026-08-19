-- Decompiled with Potassium's decompiler.

local v1 = {};
local HttpService = game:GetService("HttpService");
local u2 = {};
local u3 = {};
local u4 = 0;
local u5 = false;

local function escape(p6) -- Line: 8
    -- upvalues: u2 (copy)
    return p6:gsub("[%c\"\\]", function(p7) -- Line: 9
        -- upvalues: u2 (ref)
        return "\127" .. u2[p7];
    end);
end;

local function unescape(p8) -- Line: 14
    -- upvalues: u2 (copy)
    return p8:gsub("\127(.)", function(p9) -- Line: 15
        -- upvalues: u2 (ref)
        return u2[p9];
    end);
end;

local function copy(p10) -- Line: 20
    return table.clone(p10);
end;

local function toBase93(p11) -- Line: 24
    -- upvalues: u3 (copy)
    local v12 = "";

    repeat
        local v13 = p11 % 93;
        v12 = u3[v13] .. v12;
        p11 = (p11 - v13) / 93;
    until p11 == 0;

    return v12;
end;

local function toBase10(p14) -- Line: 34
    -- upvalues: u3 (copy)
    local v15 = 0;

    for i = 1, #p14 do
        v15 = v15 + 93 ^ (i - 1) * u3[p14:sub(-i, -i)];
    end;

    return v15;
end;

local function init() -- Line: 42
    -- upvalues: u3 (copy), u4 (ref), u2 (copy), u5 (ref)
    for i = 32, 127 do
        if i ~= 34 and i ~= 92 then
            local v16 = string.char(i);
            u3[v16] = u4;
            u3[u4] = v16;
            u4 = u4 + 1;
        end;
    end;

    for i = 1, 34 do
        local v17 = ({ 34, 92, 127 })[i - 31] or i;
        local v18 = string.char(v17);
        local v19 = string.char(v17 + 31);
        u2[v18] = v19;
        u2[v19] = v18;
    end;

    u5 = true;
end;

local function encodeInternal(p20) -- Line: 62
    -- upvalues: u5 (ref), init (copy), u3 (copy), u2 (copy)
    if not u5 then
        init();
    end;

    local v21 = table.clone(u3);
    local v22 = #v21;
    local v24 = p20:gsub("[%c\"\\]", function(p23) -- Line: 9
        -- upvalues: u2 (ref)
        return "\127" .. u2[p23];
    end);
    local v25 = "";
    local v26 = 0;
    local v27 = {};
    local v28 = 1;
    local v29 = {};

    for i = 1, #v24 do
        local v30 = v24:sub(i, i);
        local v31 = v25 .. v30;

        if v21[v31] then
            v25 = v31;
        else
            local v32 = v21[v25];
            local v33 = "";

            repeat
                local v34 = v32 % 93;
                v33 = u3[v34] .. v33;
                v32 = (v32 - v34) / 93;
            until v32 == 0;

            if v28 < #v33 then
                v29[v28] = v26;
                v28 = #v33;
                v26 = 0;
            end;

            v27[#v27 + 1] = (" "):rep(v28 - #v33) .. v33;
            v26 = v26 + 1;
            v22 = v22 + 1;
            v21[v31] = v22;
            v21[v22] = v31;
            v25 = v30;
        end;
    end;

    local v35 = v21[v25];
    local v36 = "";

    repeat
        local v37 = v35 % 93;
        v36 = u3[v37] .. v36;
        v35 = (v35 - v37) / 93;
    until v35 == 0;

    if v28 < #v36 then
        v29[v28] = v26;
        v28 = #v36;
        v26 = 0;
    end;

    v27[#v27 + 1] = (" "):rep(v28 - #v36) .. v36;
    v29[v28] = v26 + 1;

    return table.concat(v29, ",") .. "|" .. table.concat(v27);
end;

local function decodeInternal(p38) -- Line: 108
    -- upvalues: u5 (ref), init (copy), u3 (copy), toBase10 (copy), unescape (copy)
    if not u5 then
        init();
    end;

    local v39 = table.clone(u3);
    local v40, v41 = p38:match("(.-)|(.*)");
    local v42 = {};
    local v43 = 1;
    local v44 = {};

    for i in v40:gmatch("%d+") do
        local v45 = #v42 + 1;
        v42[v45] = v41:sub(v43, v43 + i * v45 - 1);
        v43 = v43 + i * v45;
    end;

    local v46 = nil;

    for i = 1, #v42 do
        for i2 in v42[i]:gmatch(("."):rep(i)) do
            local v47 = v39[toBase10(i2)];

            if v46 then
                if v47 then
                    v44[#v44 + 1] = v47;
                    v39[#v39 + 1] = v46 .. v47:sub(1, 1);
                else
                    v47 = v46 .. v46:sub(1, 1);
                    v44[#v44 + 1] = v47;
                    v39[#v39 + 1] = v47;
                end;
            else
                v44[1] = v47;
            end;

            v46 = v47;
        end;
    end;

    return unescape(table.concat(v44));
end;

function v1.Encode(u48) -- Line: 144
    -- upvalues: HttpService (copy), encodeInternal (copy)
    local v49;

    if typeof(u48) == "table" then
        local success, result = pcall(function() -- Line: 147
            -- upvalues: HttpService (ref), u48 (ref)
            return HttpService:JSONEncode(u48);
        end);

        if not (success and result) then
            warn("Failed to convert table to string");

            return;
        end;

        u48 = result;
        v49 = true;
    else
        v49 = false;
    end;

    local v50 = encodeInternal(u48);

    if utf8.len(u48) > utf8.len(v50) then
        return v50;
    end;

    return u48, v49;
end;

function v1.Decode(p51) -- Line: 164
    -- upvalues: decodeInternal (copy)
    local v52 = decodeInternal(p51);

    if v52 then
        return v52;
    end;

    warn("Failed to decode string");
end;

return v1;