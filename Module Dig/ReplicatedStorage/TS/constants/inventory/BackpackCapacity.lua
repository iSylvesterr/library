-- Decompiled with Potassium's decompiler.

return {
    MAX_BACKPACK_CAPACITY = 50,
    BackpackCapacity = {
        count = function(p1) -- Line: 6, Name: count
            local v2 = 0;

            for _, v in p1 do
                if v.pedestalSlot == nil and v.polisherSlot == nil then
                    v2 = v2 + 1;
                end;
            end;

            return v2;
        end,

        isFull = function(p3) -- Line: 16, Name: isFull
            local v4 = 0;

            for _, v in p3 do
                if v.pedestalSlot == nil and v.polisherSlot == nil then
                    v4 = v4 + 1;
                end;
            end;

            return v4 >= 50;
        end
    }
};