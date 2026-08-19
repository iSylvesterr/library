-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Products = require(ReplicatedStorage.Directory.Products);
require(ReplicatedStorage.Directory.Products.Types.Interface);
local u1 = nil;

return function(p2) -- Line: 17, Name: GetProductByID
    -- upvalues: u1 (ref), Products (copy)
    if u1 == nil then
        local v3 = {};

        for i, v in pairs(Products.Directory) do
            if v3[v.ProductId] then
                error(`Duplicate Product: {i} / {v.ProductId}`);
            end;

            v3[v.ProductId] = v;
        end;

        u1 = v3;
    end;

    local v4 = assert(u1)[p2];

    if v4 then
        return v4, v4._id;
    end;

    return nil, nil;
end;