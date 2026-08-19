-- Decompiled with Potassium's decompiler.

return {
    Encode = function(p1) -- Line: 5, Name: Encode
        return (p1:gsub(".", function(p2) -- Line: 7
            local v3 = string.byte(p2);
            local v4 = "";

            for i = 8, 1, -1 do
                v4 = v4 .. (v3 % 2 ^ i - v3 % 2 ^ (i - 1) > 0 and "1" or "0");
            end;

            return v4;
        end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(p5) -- Line: 14
            if #p5 < 6 then
                return "";
            end;

            local v6 = 0;

            for i = 1, 6 do
                if p5:sub(i, i) == "1" then
                    v6 = v6 + 2 ^ (6 - i);
                end;
            end;

            return ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(v6 + 1, v6 + 1);
        end) .. ({ "", "==", "=" })[#p1 % 3 + 1];
    end,

    Decode = function(p7) -- Line: 29, Name: Decode
        return p7:gsub("[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=]", ""):gsub(".", function(p8) -- Line: 33
            if p8 == "=" then
                return "";
            end;

            local v9 = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):find(p8) - 1;
            local v10 = "";

            for i = 6, 1, -1 do
                v10 = v10 .. (v9 % 2 ^ i - v9 % 2 ^ (i - 1) > 0 and "1" or "0");
            end;

            return v10;
        end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(p11) -- Line: 44
            if #p11 ~= 8 then
                return "";
            end;

            local v12 = 0;

            for i = 1, 8 do
                if p11:sub(i, i) == "1" then
                    v12 = v12 + 2 ^ (8 - i);
                end;
            end;

            return string.char(v12);
        end);
    end
};