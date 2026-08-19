-- Decompiled with Potassium's decompiler.

local PoolHide = require(script.Parent.PoolHide);
local u1 = {};

local function _getPoolFolder() -- Line: 15
    local Part_IclesPooled = workspace.Terrain:FindFirstChild("Part_IclesPooled");

    if Part_IclesPooled then
        return Part_IclesPooled;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "Part_IclesPooled";
    Folder.Archivable = false;
    Folder.Parent = workspace.Terrain;

    return Folder;
end;

u1._pools = setmetatable({}, {
    __mode = "k"
});
u1._totalSize = 0;
u1._lastSweepAt = 0;
u1._lastReportAt = 0;
u1.MAX_POOL_TOTAL = 2048;
u1.TTL = 5;
u1.SWEEP_INTERVAL = 2;
u1.REPORT_INTERVAL = 0;
u1.MIN_CAP = 8;
u1.CAP_SAFETY = 1.25;

local function estimateCap(p2) -- Line: 39
    -- upvalues: u1 (copy)
    local v3 = math.max(p2 or 0, 0) * u1.TTL * u1.CAP_SAFETY;

    return math.ceil(v3) + u1.MIN_CAP;
end;

local function getOrInitPool(p4) -- Line: 44
    -- upvalues: u1 (copy)
    local v5 = u1._pools[p4];

    if v5 then
        return v5;
    end;

    local v6 = {
        peakSize = 0,
        hits = 0,
        misses = 0,
        evictions = 0,
        entries = {},
        gen = p4:GetAttribute("_PoolGen") or 0,
        cap = u1.MIN_CAP
    };
    u1._pools[p4] = v6;

    return v6;
end;

local function destroyEntry(u7) -- Line: 58
    if u7 and u7.instance then
        pcall(function() -- Line: 60
            -- upvalues: u7 (copy)
            u7.instance:Destroy();
        end);
    end;
end;

local function discardAllEntries(p8) -- Line: 64
    -- upvalues: u1 (copy)
    for i = 1, #p8.entries do
        local u9 = p8.entries[i];

        if u9 and u9.instance then
            pcall(function() -- Line: 60
                -- upvalues: u9 (copy)
                u9.instance:Destroy();
            end);
        end;
    end;

    u1._totalSize = math.max(0, u1._totalSize - #p8.entries);
    p8.entries = {};
end;

function u1.acquire(p10, p11) -- Line: 71
    -- upvalues: getOrInitPool (copy), discardAllEntries (copy), u1 (copy), PoolHide (copy)
    if not p10 then
        return nil;
    end;

    local v12 = getOrInitPool(p10);
    local v13 = p10:GetAttribute("_PoolGen") or 0;

    if v13 ~= v12.gen then
        discardAllEntries(v12);
        v12.gen = v13;
    end;

    while #v12.entries > 0 do
        local v14 = table.remove(v12.entries);
        u1._totalSize = math.max(0, u1._totalSize - 1);
        local instance = v14.instance;

        if instance and instance.Parent then
            PoolHide.show(instance, p11);
            v12.hits = v12.hits + 1;

            return instance;
        end;
    end;

    v12.misses = v12.misses + 1;

    return nil;
end;

function u1.release(u15, p16, p17, p18) -- Line: 95
    -- upvalues: getOrInitPool (copy), u1 (copy), PoolHide (copy)
    if not (u15 and p16) then
        return;
    end;

    if not u15.Parent then
        return;
    end;

    local v19 = getOrInitPool(p16);

    if p18 then
        local v20 = math.max(p18 or 0, 0) * u1.TTL * u1.CAP_SAFETY;
        v19.cap = math.ceil(v20) + u1.MIN_CAP;
    end;

    if u1._totalSize >= u1.MAX_POOL_TOTAL then
        pcall(function() -- Line: 101
            -- upvalues: u15 (copy)
            u15:Destroy();
        end);

        return;
    end;

    while #v19.entries >= v19.cap do
        local u21 = table.remove(v19.entries, 1);
        u1._totalSize = math.max(0, u1._totalSize - 1);

        if u21 and u21.instance then
            pcall(function() -- Line: 60
                -- upvalues: u21 (copy)
                u21.instance:Destroy();
            end);
        end;

        v19.evictions = v19.evictions + 1;
    end;

    PoolHide.hide(u15, p17);
    pcall(function() -- Line: 114
        -- upvalues: u15 (copy)
        local Part_IclesPooled = workspace.Terrain:FindFirstChild("Part_IclesPooled");

        if not Part_IclesPooled then
            Part_IclesPooled = Instance.new("Folder");
            Part_IclesPooled.Name = "Part_IclesPooled";
            Part_IclesPooled.Archivable = false;
            Part_IclesPooled.Parent = workspace.Terrain;
        end;

        u15.Parent = Part_IclesPooled;
    end);
    v19.entries[#v19.entries + 1] = {
        instance = u15,
        pooledAt = os.clock()
    };
    local v22 = u1;
    v22._totalSize = v22._totalSize + 1;

    if #v19.entries > v19.peakSize then
        v19.peakSize = #v19.entries;
    end;
end;

function u1.tickSweep(p23) -- Line: 121
    -- upvalues: u1 (copy)
    if p23 - u1._lastSweepAt < u1.SWEEP_INTERVAL then
        return;
    end;

    u1._lastSweepAt = p23;
    local v24 = 64;
    local v25 = nil;

    for i, v in pairs(u1._pools) do
        local v26 = 1;

        while v26 <= #v.entries and v24 > 0 do
            local u27 = v.entries[v26];
            local instance = u27.instance;

            if p23 - u27.pooledAt > u1.TTL and true or not (instance and instance.Parent) then
                if u27 and u27.instance then
                    pcall(function() -- Line: 60
                        -- upvalues: u27 (copy)
                        u27.instance:Destroy();
                    end);
                end;

                local v28 = #v.entries;

                if v26 < v28 then
                    v.entries[v26] = v.entries[v28];
                end;

                v.entries[v28] = nil;
                u1._totalSize = math.max(0, u1._totalSize - 1);
                v.evictions = v.evictions + 1;
                v24 = v24 - 1;
            else
                v26 = v26 + 1;
            end;
        end;

        if #v.entries == 0 and not (i and i.Parent) then
            v25 = v25 or {};
            v25[#v25 + 1] = i;
        end;
    end;

    if v25 then
        for _, v in ipairs(v25) do
            u1._pools[v] = nil;
        end;
    end;
end;

function u1.bumpGen(u29) -- Line: 162
    if not u29 then
        return;
    end;

    local u30 = u29:GetAttribute("_PoolGen") or 0;
    pcall(function() -- Line: 165
        -- upvalues: u29 (copy), u30 (copy)
        u29:SetAttribute("_PoolGen", u30 + 1);
    end);
end;

function u1.flushSource(p31) -- Line: 169
    -- upvalues: u1 (copy), discardAllEntries (copy)
    local v32 = u1._pools[p31];

    if not v32 then
        return;
    end;

    discardAllEntries(v32);
    u1._pools[p31] = nil;
end;

function u1.flushAll() -- Line: 177
    -- upvalues: u1 (copy), discardAllEntries (copy)
    for _, v in pairs(u1._pools) do
        discardAllEntries(v);
    end;

    u1._pools = setmetatable({}, {
        __mode = "k"
    });
    u1._totalSize = 0;
end;

function u1.tickReport(p33) -- Line: 186
    -- upvalues: u1 (copy)
    if u1.REPORT_INTERVAL <= 0 then
        return;
    end;

    if p33 - u1._lastReportAt < u1.REPORT_INTERVAL then
        return;
    end;

    u1._lastReportAt = p33;
    local v34 = 0;
    local v35 = 0;
    local v36 = 0;
    local v37 = 0;
    local v38 = 0;
    local v39 = 0;

    for _ in pairs(u1._pools) do
        v34 = v34 + 1;
    end;

    for _, v in pairs(u1._pools) do
        v35 = v35 + #v.entries;
        v36 = v36 + v.hits;
        v37 = v37 + v.misses;
        v38 = v38 + v.evictions;

        if v39 < v.peakSize then
            v39 = v.peakSize;
        end;
    end;

    print(string.format("[Part-Icles Pool] sources=%d entries=%d/%d peak=%d hits=%d misses=%d (%.1f%% hit) evictions=%d", v34, v35, u1.MAX_POOL_TOTAL, v39, v36, v37, v36 + v37 > 0 and (v36 / (v36 + v37) * 100 or 0) or 0, v38));
end;

function u1.acquireOrClone(p40, p41, p42) -- Line: 209
    -- upvalues: u1 (copy)
    local v43;

    if p42 == false then
        v43 = p40:Clone();
    else
        v43 = u1.acquire(p40, p41) or p40:Clone();
    end;

    v43:SetAttribute("_PartIcleEmit", true);

    return v43;
end;

local function copyBare(p44, p45, p46) -- Line: 223
    -- upvalues: copyBare (copy)
    local v47 = p45 or {};
    local v48 = Instance.fromExisting(p44);
    v47[p44] = v48;

    for _, child in ipairs(p44:GetChildren()) do
        if not child:GetAttribute("Transformed") then
            copyBare(child, v47, false).Parent = v48;
        end;
    end;

    if p46 == nil or p46 then
        for i, v in pairs(v47) do
            if i:IsA("Trail") or i:IsA("Beam") then
                local Attachment0 = i.Attachment0;
                local Attachment1 = i.Attachment1;

                if Attachment0 and v47[Attachment0] then
                    v.Attachment0 = v47[Attachment0];
                end;

                if Attachment1 and v47[Attachment1] then
                    v.Attachment1 = v47[Attachment1];
                end;
            end;
        end;
    end;

    return v48, v47;
end;

u1.copyBare = copyBare;
u1._cloneMaps = setmetatable({}, {
    __mode = "k"
});

function u1.acquireOrCopyBare(p49, p50, p51) -- Line: 252
    -- upvalues: copyBare (copy), u1 (copy)
    local v52, v53;

    if p51 == false then
        v52, v53 = copyBare(p49);
    else
        v52 = u1.acquire(p49, p50);

        if v52 then
            v53 = u1._cloneMaps[v52];
        else
            v52, v53 = copyBare(p49);
        end;
    end;

    if v53 then
        u1._cloneMaps[v52] = v53;
    end;

    v52:SetAttribute("_PartIcleEmit", true);

    return v52;
end;

function u1.restoreTrails(u54, u55) -- Line: 274
    -- upvalues: PoolHide (copy)
    task.delay(0, function() -- Line: 275
        -- upvalues: u54 (copy), PoolHide (ref), u55 (copy)
        if not (u54 and u54.Parent) then
            return;
        end;

        PoolHide.restoreTrails(u54, u55);
    end);
end;

function u1.tick(p56) -- Line: 282
    -- upvalues: u1 (copy)
    u1.tickSweep(p56);
    u1.tickReport(p56);
end;

function u1.stats() -- Line: 287
    -- upvalues: u1 (copy)
    local v57 = {
        totalSize = u1._totalSize,
        sources = {}
    };

    for i, v in pairs(u1._pools) do
        v57.sources[i] = {
            size = #v.entries,
            peakSize = v.peakSize,
            cap = v.cap,
            gen = v.gen,
            hits = v.hits,
            misses = v.misses,
            evictions = v.evictions
        };
    end;

    return v57;
end;

return u1;