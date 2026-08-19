-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Directory = require(ReplicatedStorage.Directory.Gamepasses).Directory;
local u1 = nil;

return function(p2) -- Line: 10, Name: GetGamepassByID
    -- upvalues: u1 (ref), Directory (copy)
    if not p2 then
        return nil;
    end;

    local v3 = type(p2) == "number";
    assert(v3, "GetGamepassByID: gamepassId must be a number");

    if not u1 then
        local v4 = {};

        for i, v in pairs(Directory) do
            if v4[v.ProductId] then
                error(`Duplicate Product: {i} / {v.ProductId}`);
            end;

            v4[v.ProductId] = v;
        end;

        u1 = v4;
    end;

    local v5 = u1[p2];

    if v5 then
        return v5, v5._id;
    end;

    return nil, nil;
end;