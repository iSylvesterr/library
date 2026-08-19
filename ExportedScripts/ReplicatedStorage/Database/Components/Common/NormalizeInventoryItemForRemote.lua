-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");

return function(u1) -- Line: 9
    -- upvalues: HttpService (copy)
    local success, result = pcall(function() -- Line: 11
        -- upvalues: HttpService (ref), u1 (copy)
        return HttpService:JSONEncode(u1);
    end);

    if not (success and result) then
        return u1;
    end;

    local success2, result2 = pcall(function() -- Line: 21
        -- upvalues: HttpService (ref), result (copy)
        return HttpService:JSONDecode(result);
    end);

    if not (success2 and result2) then
        return u1;
    end;

    for _, v in ipairs({ "_id", "Type", "Name", "Skin", "Rarity", "OriginalOwner" }) do
        if result2[v] ~= nil and typeof(result2[v]) == "number" then
            result2[v] = tostring(result2[v]);
        end;
    end;

    if result2.MetaData and typeof(result2.MetaData) == "table" then
        for _, v in ipairs({ "LastTradeAt", "CreatedAt" }) do
            if result2.MetaData[v] ~= nil and typeof(result2.MetaData[v]) == "string" then
                local v2 = tonumber(result2.MetaData[v]);

                if v2 == nil then
                    result2.MetaData[v] = nil;
                else
                    result2.MetaData[v] = v2;
                end;
            end;
        end;

        for _, v in ipairs({ "GlobalMarketPlaceListingReference" }) do
            if result2.MetaData[v] == false then
                result2.MetaData[v] = nil;
            end;
        end;

        for _, v in ipairs({ "OriginalOwner", "Owner", "Origin", "GlobalMarketPlaceListingReference" }) do
            if result2.MetaData[v] ~= nil and typeof(result2.MetaData[v]) == "number" then
                result2.MetaData[v] = tostring(result2.MetaData[v]);
            end;
        end;
    end;

    return result2;
end;