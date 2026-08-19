-- Decompiled with Potassium's decompiler.

local Stringify = require(game.ReplicatedStorage.UserGenerated.Strings.Stringify);
local DeepEquals = require(game.ReplicatedStorage.UserGenerated.Collections.DeepEquals);

local function StripErrorSource(p1) -- Line: 35
    local v2 = tostring(p1);
    local v3, v4 = string.match(v2, "^(.*:%d+): (.+)$");

    if v3 then
        v2 = v4 or v2;
    end;

    return v2;
end;

local function ToString(p5) -- Line: 45
    -- upvalues: Stringify (copy)
    return Stringify.Pretty(p5, {
        Pretty = false,
        IndentChar = "",
        IndentSize = 0
    });
end;

return table.freeze({
    IsEqual = function(p6, p7) -- Line: 21, Name: Equals
        return rawequal(p6, p7) and true or (type(p6) ~= "table" or type(p7) ~= "table") and (p6 ~= p6 and p7 ~= p7);
    end,

    ErrorUnsafe = function(p8, p9, ...) -- Line: 57, Name: ErrorUnsafe
        local u10 = nil;
        local v12 = table.pack(xpcall(p9, function(p11) -- Line: 59
            -- upvalues: u10 (ref)
            u10 = p11;
        end, ...));

        if v12[1] then
            error("ExpectedError", 2);
        end;

        if u10 ~= p8 then
            error(`ExpectedError Mismatch: {string.format("%q", (tostring(u10)))}`, 2);
        end;

        return table.unpack(v12, 2);
    end,

    Error = function(p13, p14, ...) -- Line: 72, Name: Error
        -- upvalues: Stringify (copy)
        local u15 = nil;
        local v17 = table.pack(xpcall(p14, function(p16) -- Line: 74
            -- upvalues: u15 (ref)
            u15 = p16;
        end, ...));

        if v17[1] then
            error(`ExpectedError({Stringify.Pretty(p13, {
                Pretty = false,
                IndentChar = "",
                IndentSize = 0
            })})`, 2);
        end;

        if type(u15) == "string" then
            local v18 = tostring(u15);
            local v19, v20 = string.match(v18, "^(.*:%d+): (.+)$");

            if v19 then
                v18 = v20 or v18;
            end;

            u15 = v18;
        end;

        if p13 ~= u15 then
            error(`ExpectedError({Stringify.Pretty(p13, {
                Pretty = false,
                IndentChar = "",
                IndentSize = 0
            })}): {Stringify.Pretty(u15, {
                Pretty = false,
                IndentChar = "",
                IndentSize = 0
            })}`, 2);
        end;

        return table.unpack(v17, 2);
    end,

    Equal = function(p21, p22) -- Line: 90, Name: Equal
        -- upvalues: Stringify (copy)
        if not rawequal(p21, p22) and (type(p21) == "table" and type(p22) == "table" or (p21 == p21 or p22 == p22)) then
            error(`Equal({Stringify.Pretty(p21, {
                Pretty = false,
                IndentChar = "",
                IndentSize = 0
            })}, {Stringify.Pretty(p22, {
                Pretty = false,
                IndentChar = "",
                IndentSize = 0
            })})`, 2);
        end;
    end,

    DeepEqual = function(p23, p24) -- Line: 96, Name: DeepEqual
        -- upvalues: DeepEquals (copy), Stringify (copy)
        if not DeepEquals(p23, p24) then
            error(`DeepEqual({Stringify.Pretty(p23, {
                Pretty = false,
                IndentChar = "",
                IndentSize = 0
            })}, {Stringify.Pretty(p24, {
                Pretty = false,
                IndentChar = "",
                IndentSize = 0
            })})`, 2);
        end;
    end,

    FuzzyEqual = function(p25, p26, p27) -- Line: 102, Name: FuzzyEqual
        if (p27 or 0.001) < math.abs(p25 - p26) then
            error(`FuzzyEqual({tostring(p25)}, {tostring(p26)}): {math.abs(p25 - p26)}`, 2);
        end;
    end,

    ColorEqual = function(p28, p29, p30) -- Line: 109, Name: ColorEqual
        -- upvalues: Stringify (copy)
        local v31 = Vector3.new(p28.R, p28.G, p28.B) * 255;

        if (p30 or 0.001) < (Vector3.new(p29.R, p29.G, p29.B) * 255 - v31).Magnitude then
            error(`ColorEqual({Stringify.Pretty(p28, {
                Pretty = false,
                IndentChar = "",
                IndentSize = 0
            })}, {Stringify.Pretty(p29, {
                Pretty = false,
                IndentChar = "",
                IndentSize = 0
            })})`, 2);
        end;
    end
});