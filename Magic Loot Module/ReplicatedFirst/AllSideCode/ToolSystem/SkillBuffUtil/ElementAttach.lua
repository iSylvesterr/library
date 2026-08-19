-- Decompiled with Potassium's decompiler.

local Apply = require(script.Apply);
local Query = require(script.Query);
local Registry = require(script.Registry);
local Tick = require(script.Tick);

return {
    registerFromBuffRow = function(p1, p2, p3, p4, p5) -- Line: 15, Name: registerFromBuffRow
        -- upvalues: Apply (copy)
        return Apply.registerFromBuffRow(p1, p2, p3, p4, p5);
    end,

    hasAttach = function(p6, p7) -- Line: 19, Name: hasAttach
        -- upvalues: Query (copy)
        return Query.hasAttach(p6, p7);
    end,

    getTraitAmp = function(p8, p9) -- Line: 23, Name: getTraitAmp
        -- upvalues: Query (copy)
        return Query.getTraitAmp(p8, p9);
    end,

    getAttachTier = function(p10, p11) -- Line: 27, Name: getAttachTier
        -- upvalues: Query (copy)
        return Query.getAttachTier(p10, p11);
    end,

    getActiveElementTps = function(p12) -- Line: 31, Name: getActiveElementTps
        -- upvalues: Query (copy)
        return Query.getActiveElementTps(p12);
    end,

    consumeAttach = function(p13, p14) -- Line: 35, Name: consumeAttach
        -- upvalues: Registry (copy)
        return Registry.consume(p13, p14);
    end,

    runDotTicks = function(p15) -- Line: 39, Name: runDotTicks
        -- upvalues: Tick (copy)
        Tick.run(p15);
    end,

    pruneExpired = function(p16) -- Line: 43, Name: pruneExpired
        -- upvalues: Registry (copy)
        Registry.pruneExpired(p16);
    end
};