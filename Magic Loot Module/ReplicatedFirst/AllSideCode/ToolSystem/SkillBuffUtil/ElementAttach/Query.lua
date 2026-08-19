-- Decompiled with Potassium's decompiler.

local Config = require(script.Parent.Parent.Config);
local Registry = require(script.Parent.Registry);

return {
    hasAttach = function(p1, p2) -- Line: 11, Name: hasAttach
        -- upvalues: Registry (copy)
        return Registry.findEntry(p1, p2) ~= nil;
    end,

    getAttachEntry = function(p3, p4) -- Line: 15, Name: getAttachEntry
        -- upvalues: Registry (copy)
        return Registry.findEntry(p3, p4);
    end,

    getActiveElementTps = function(p5) -- Line: 20, Name: getActiveElementTps
        -- upvalues: Registry (copy)
        local v6 = {};

        if typeof(p5) ~= "Instance" or not p5.Parent then
            return v6;
        end;

        local v7 = workspace:GetServerTimeNow();
        local v8 = {};

        for _, v in Registry.getEntries() do
            if v.owner == p5 and (v7 < v.endAt and (v.owner.Parent and not v8[v.elementTp])) then
                v8[v.elementTp] = true;
                table.insert(v6, v.elementTp);
            end;
        end;

        return v6;
    end,

    getTraitAmp = function(p9, p10) -- Line: 37, Name: getTraitAmp
        -- upvalues: Registry (copy), Config (copy)
        local v11 = Registry.findEntry(p9, p10);

        if v11 then
            return Config.getPrimaryScalarFromBuffInst(v11.buffInstId);
        end;

        return nil;
    end,

    getAttachTier = function(p12, p13) -- Line: 46, Name: getAttachTier
        -- upvalues: Registry (copy)
        local v14 = Registry.findEntry(p12, p13);

        if not v14 then
            return nil;
        end;

        local v15 = tonumber(v14.tier);

        if v15 and v15 >= 1 then
            return v15;
        end;

        return nil;
    end
};