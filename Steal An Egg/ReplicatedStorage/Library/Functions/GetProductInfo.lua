-- Decompiled with Potassium's decompiler.

local ProductCache = require(script.Parent.ProductCache);

return function(p1, p2) -- Line: 3
    -- upvalues: ProductCache (copy)
    return ProductCache.getProductInfo(p1, p2 or Enum.InfoType.Product).Info;
end;