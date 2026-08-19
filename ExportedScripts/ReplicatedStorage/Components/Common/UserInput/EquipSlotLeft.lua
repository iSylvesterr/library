-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);

local function getSpaceNumber(p1, p2) -- Line: 10
    for i, v in ipairs(p1) do
        if v.Identifier == p2 then
            return i;
        end;
    end;

    return 0;
end;

return function() -- Line: 22
    -- upvalues: InventoryController (copy)
    local v3 = InventoryController.getCurrentEquipped();

    if v3 then
        local v4 = v3.Slot or 1;
        local _items = InventoryController.getInventorySlot(v4)._items;
        local Identifier = v3.Identifier;

        for i, v in ipairs(_items) do
            if v.Identifier == Identifier then
                break;
            end;
        end;

        if i <= 1 then
            local v5 = InventoryController.getCurrentInventory();
            local v6 = v4;

            for i = #v5, 1, -1 do
                if #v5[i]._items > 0 and i < v4 then
                    v4 = i;
                    break;
                end;
            end;

            if v4 == v6 then
                for i = #v5, 1, -1 do
                    if #v5[i]._items > 0 and v4 < i then
                        v4 = i;
                    end;
                end;
            end;

            local v7 = InventoryController.getInventorySlot(v4);
            InventoryController.equip(v4, #v7._items);

            return;
        end;

        InventoryController.equip(v4, i - 1);
    end;
end;