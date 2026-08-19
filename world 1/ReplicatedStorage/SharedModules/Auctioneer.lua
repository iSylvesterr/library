-- Decompiled with Potassium's decompiler.

return {
    CurrentPrice = function(p1, p2) -- Line: 56, Name: CurrentPrice
        if p1.decrementIntervalSeconds <= 0 then
            return p1.startPrice;
        end;

        local v3 = p2 - p1.rolledAt;
        local v4 = math.floor((v3 < 0 and 0 or v3) / p1.decrementIntervalSeconds);
        local v5 = math.round(p1.startPrice * p1.decrementPercent / 100);
        local v6 = p1.startPrice - v5 * v4;

        if v6 < p1.minPrice then
            v6 = p1.minPrice;
        end;

        return v6;
    end,

    TicksElapsed = function(p7, p8) -- Line: 74, Name: TicksElapsed
        if p7.decrementIntervalSeconds <= 0 then
            return 0;
        end;

        local v9 = p8 - p7.rolledAt;

        return math.floor((v9 < 0 and 0 or v9) / p7.decrementIntervalSeconds);
    end,

    IsActive = function(p10, p11, p12) -- Line: 91, Name: IsActive
        if p10.expiresAt <= p11 then
            return false;
        end;

        return p12 == nil and true or p12 > 0;
    end,

    DisplayName = function(p13) -- Line: 103, Name: DisplayName
        if p13.displayName ~= nil and p13.displayName ~= "" then
            return p13.displayName;
        end;

        local v14 = {};

        for _, v in {
            p13.type,
            p13.size,
            p13.mutation,
            p13.item
        } do
            if v ~= nil and v ~= "" then
                table.insert(v14, v);
            end;
        end;

        return table.concat(v14, " ");
    end
};