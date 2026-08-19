-- Decompiled with Potassium's decompiler.

local ProductCache = require(script.Parent.ProductCache);

return function(p1, p2) -- Line: 3
    -- upvalues: ProductCache (copy)
    local v3 = ProductCache.getProductInfo(p1, p2 and Enum.InfoType.Product or Enum.InfoType.GamePass);

    if v3 then
        v3 = v3.Info;
    end;

    if not v3 then
        warn("Failed to grab price for ID (" .. p1 .. ")");

        return 0, false;
    end;

    if not v3.IsForSale then
        return 0, false;
    end;

    local PriceInRobux = v3.PriceInRobux;

    if type(PriceInRobux) == "number" then
        return PriceInRobux, true;
    end;

    return 0, false;
end;