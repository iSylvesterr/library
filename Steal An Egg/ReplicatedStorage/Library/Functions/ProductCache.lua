-- Decompiled with Potassium's decompiler.

local MarketplaceService = game:GetService("MarketplaceService");
local u1 = {
    UpdateRate = 900,
    RetryRate = 900
};
local u2 = {};

function u1.clear() -- Line: 10
    -- upvalues: u2 (ref)
    u2 = {};
end;

function u1.getProductInfo(u3, u4) -- Line: 14
    -- upvalues: u2 (ref), u1 (copy), MarketplaceService (copy)
    local v5 = type(u3) == "number";
    assert(v5);
    local v6;

    if typeof(u4) == "EnumItem" then
        v6 = u4.EnumType == Enum.InfoType;
    else
        v6 = false;
    end;

    assert(v6);
    local v7 = u2[u4];

    if not v7 then
        v7 = {};
        u2[u4] = v7;
    end;

    local v8 = v7[u3];

    if not v8 then
        v8 = {};
        v7[u3] = v8;
    end;

    if v8.Info and (v8.LastUpdated and time() - v8.LastUpdated < u1.UpdateRate) then
        return v8, true;
    end;

    if v8.LastFailure and time() - v8.LastFailure < u1.RetryRate then
        return v8, false;
    end;

    local success, result = pcall(function() -- Line: 38
        -- upvalues: MarketplaceService (ref), u3 (copy), u4 (copy)
        return MarketplaceService:GetProductInfo(u3, u4);
    end);
    local v9 = time();

    if success then
        v8.LastUpdated = v9;
        v8.Info = result;

        return v8, true;
    end;

    v8.LastFailure = v9;
    warn(string.format("[ProductCache] Failed to retrieve: productId=%d infoType=%s error=\'%s\'", u3, u4.Name, (tostring(result))));

    return v8, false;
end;

return u1;