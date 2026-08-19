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
        local v5 = InventoryController.getInventorySlot(v4);
        local Identifier = v3.Identifier;

        for i, v in ipairs(v5._items) do
            if v.Identifier == Identifier then
                break;
            end;
        end;

        if #v5._items <= i then
            local v6 = InventoryController.getCurrentInventory();
            local v7 = v4;

            for i = 1, #v6 do
                if #v6[i]._items > 0 and v4 < i then
                    v4 = i;
                    break;
                end;
            end;

            if v4 == v7 then
                for i = 1, #v6 do
                    if #v6[i]._items > 0 and i < v4 then
                        v4 = i;
                        break;
                    end;
                end;
            end;

            InventoryController.equip(v4, 1);

            return;
        end;

        InventoryController.equip(v4, i + 1);
    end;
end;