-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);

local function isZeusInventorySpace(p1) -- Line: 13
    return p1.Name == "Zeus x27";
end;

local function getSpaceNumber(p2, p3) -- Line: 17
    for i, v in ipairs(p2) do
        if v.Identifier == p3 then
            return i;
        end;
    end;

    return 0;
end;

local function getPreferredSpaceOrder(p4, p5, p6) -- Line: 26
    local v7 = {};

    if p4 ~= 3 then
        for i = 1, #p5 do
            if not p6 or p6(p5[i]) then
                table.insert(v7, i);
            end;
        end;

        return v7;
    end;

    for i, v in ipairs(p5) do
        if v.Name ~= "Zeus x27" then
            table.insert(v7, i);
        end;
    end;

    for i, v in ipairs(p5) do
        if v.Name == "Zeus x27" then
            table.insert(v7, i);
        end;
    end;

    return v7;
end;

local function getPreferredSpaceNumber(p8, p9, p10, p11) -- Line: 58
    -- upvalues: getPreferredSpaceOrder (copy)
    local v12 = getPreferredSpaceOrder(p8, p9, p11);
    local v13 = v12[1];

    if not v13 then
        return 0;
    end;

    if not p10 then
        return v13;
    end;

    for i, v in ipairs(p9) do
        if v.Identifier == p10 then
            break;
        end;
    end;

    if i == 0 then
        return v13;
    end;

    for i, v in ipairs(v12) do
        if v == i then
            return v12[i + 1] or v13;
        end;
    end;

    return v13;
end;

return function(p14, p15) -- Line: 92
    -- upvalues: InventoryController (copy), getPreferredSpaceNumber (copy), getPreferredSpaceOrder (copy)
    local v16 = InventoryController.getCurrentEquipped();
    local v17 = InventoryController.getInventorySlot(p14);

    if v17 then
        if v16 then
            if (v16.Slot or 1) == p14 then
                local v18 = getPreferredSpaceNumber(p14, v17._items, v16.Identifier, p15);

                if v18 > 0 then
                    InventoryController.equip(p14, v18);
                end;
            else
                local v19 = getPreferredSpaceOrder(p14, v17._items, p15)[1] or 0;

                if v19 > 0 then
                    InventoryController.equip(p14, v19);
                end;
            end;
        else
            local v20 = getPreferredSpaceOrder(p14, v17._items, p15)[1] or 0;

            if v20 > 0 then
                InventoryController.equip(p14, v20);
            end;
        end;
    end;
end;