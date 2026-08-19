-- Decompiled with Potassium's decompiler.

require(script.Parent.Types.Interface);
local v1 = { {
        ProductName = "TreadmillSpeed_5Minutes",
        DurationSeconds = 300,
        ProductId = 3612508008
    }, {
        ProductName = "TreadmillSpeed_30Minutes",
        DurationSeconds = 1800,
        ProductId = 3612508088
    }, {
        ProductName = "TreadmillSpeed_1Hour",
        DurationSeconds = 3600,
        ProductId = 3612508192
    }, {
        ProductName = "TreadmillSpeed_4Hours",
        DurationSeconds = 14400,
        ProductId = 3612508244
    } };

for _, v in ipairs(v1) do
    table.freeze(v);
end;

return table.freeze(v1);