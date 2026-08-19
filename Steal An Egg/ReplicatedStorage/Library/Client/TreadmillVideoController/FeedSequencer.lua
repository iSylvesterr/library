-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CRC32 = require(ReplicatedStorage.Library.Functions.CRC32);
local Shuffle = require(ReplicatedStorage.Library.Functions.Shuffle);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local TreadmillMediaCatalog = require(ReplicatedStorage.Directory.TreadmillMediaCatalog);
local TreadmillMediaIdentity = require(ReplicatedStorage.Library.Modules.TreadmillMediaIdentity);
require(script.Parent.Types.Interface);
local u1 = { "Funny", "Brainrot", "Satisfying", "Funny", "Satisfying", "WeirdOrHorror", "Funny", "Brainrot", "Satisfying", "Funny", "Music" };
local u2 = #u1;
local u3 = Log.new();
local u4 = {};

local function createEmptyBucketIndices() -- Line: 52
    return {
        Brainrot = {},
        Funny = {},
        Satisfying = {},
        WeirdOrHorror = {},
        Music = {}
    };
end;

local function normalizeFeedIndex(p5) -- Line: 62
    local v6 = math.floor(p5);

    return math.max(0, v6);
end;

local function normalizeReleaseVersion(p7) -- Line: 66
    local v8 = math.floor(p7);

    return math.max(0, v8);
end;

local function normalizeSeed(p9, p10) -- Line: 70
    -- upvalues: CRC32 (copy)
    if p9 > 0 then
        return math.floor(p9);
    end;

    return CRC32((`TreadmillMediaFeed/{p10}`));
end;

local function bucketForFeedIndex(p11) -- Line: 77
    -- upvalues: u2 (copy), u1 (copy)
    return u1[(p11 - 1) % u2 + 1] or u1[1];
end;

local function createBucketOrder(p12, p13, p14, p15) -- Line: 82
    -- upvalues: CRC32 (copy), Shuffle (copy)
    return Shuffle(table.clone(p12), (Random.new(CRC32((`{p15}/{p13}/{p14}`)))));
end;

local function createBucketOrders(p16, p17, p18) -- Line: 93
    -- upvalues: CRC32 (copy), Shuffle (copy)
    return {
        Brainrot = Shuffle(table.clone(p16.Brainrot), (Random.new(CRC32((`{p18}/{p17}/Brainrot`))))),
        Funny = Shuffle(table.clone(p16.Funny), (Random.new(CRC32((`{p18}/{p17}/Funny`))))),
        Satisfying = Shuffle(table.clone(p16.Satisfying), (Random.new(CRC32((`{p18}/{p17}/Satisfying`))))),
        WeirdOrHorror = Shuffle(table.clone(p16.WeirdOrHorror), (Random.new(CRC32((`{p18}/{p17}/WeirdOrHorror`))))),
        Music = Shuffle(table.clone(p16.Music), (Random.new(CRC32((`{p18}/{p17}/Music`)))))
    };
end;

local function takeNextFromBucket(p19, p20, p21) -- Line: 117
    local v22 = p20[p21];
    local v23 = p19[p21][v22];

    if v23 == nil then
        return nil;
    end;

    p20[p21] = v22 + 1;

    return v23;
end;

local function takeNextFromFallbackBucket(p24, p25, p26, p27) -- Line: 131
    if p27 == p26 then
        return nil;
    end;

    local v28 = p25[p27];
    local v29 = p24[p27][v28];

    if v29 == nil then
        return nil;
    end;

    p25[p27] = v28 + 1;

    return v29;
end;

local function takeNextPatternMedia(p30, p31, p32) -- Line: 143
    local v33 = p31[p32];
    local v34 = p30[p32][v33];

    if v34 == nil then
        v34 = nil;
    else
        p31[p32] = v33 + 1;
    end;

    if not v34 then
        if p32 == "Brainrot" then
            v34 = nil;
        else
            local Brainrot = p31.Brainrot;
            v34 = p30.Brainrot[Brainrot];

            if v34 == nil then
                v34 = nil;
            else
                p31.Brainrot = Brainrot + 1;
            end;
        end;

        if not v34 then
            if p32 == "Funny" then
                v34 = nil;
            else
                local Funny = p31.Funny;
                v34 = p30.Funny[Funny];

                if v34 == nil then
                    v34 = nil;
                else
                    p31.Funny = Funny + 1;
                end;
            end;

            if not v34 then
                if p32 == "Satisfying" then
                    v34 = nil;
                else
                    local Satisfying = p31.Satisfying;
                    v34 = p30.Satisfying[Satisfying];

                    if v34 == nil then
                        v34 = nil;
                    else
                        p31.Satisfying = Satisfying + 1;
                    end;
                end;

                if not v34 then
                    if p32 == "WeirdOrHorror" then
                        v34 = nil;
                    else
                        local WeirdOrHorror = p31.WeirdOrHorror;
                        v34 = p30.WeirdOrHorror[WeirdOrHorror];

                        if v34 == nil then
                            v34 = nil;
                        else
                            p31.WeirdOrHorror = WeirdOrHorror + 1;
                        end;
                    end;

                    if not v34 then
                        if p32 == "Music" then
                            v34 = nil;
                        else
                            local Music = p31.Music;
                            v34 = p30.Music[Music];

                            if v34 == nil then
                                v34 = nil;
                            else
                                p31.Music = Music + 1;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    assert(v34 ~= nil, "Expected unseen treadmill media while sequence is incomplete");

    return v34;
end;

local function generatePatternOrder(p35, p36, p37, p38, p39) -- Line: 158
    -- upvalues: createBucketOrders (copy), u2 (copy), u1 (copy), takeNextPatternMedia (copy)
    local v40 = createBucketOrders(p35, p37, p38);
    local v41 = table.create(p36);
    local v42 = {
        Brainrot = 1,
        Funny = 1,
        Satisfying = 1,
        WeirdOrHorror = 1,
        Music = 1
    };

    for i = 1, p36 do
        v41[i] = takeNextPatternMedia(v40, v42, u1[(p39 + i - 1 - 1) % u2 + 1] or u1[1]);
    end;

    return v41;
end;

local function generateFullPass(p43, p44) -- Line: 181
    -- upvalues: CRC32 (copy), generatePatternOrder (copy)
    local v45 = CRC32((`TreadmillMediaPass/{p43.Seed}/{p44}`));

    return generatePatternOrder(p43.BucketIndices, p43.TotalMediaCount, v45, "TreadmillMediaPassBucket", p44 * p43.TotalMediaCount + 1);
end;

local function resolveFullMediaIndex(p46, p47) -- Line: 193
    -- upvalues: CRC32 (copy), generatePatternOrder (copy)
    local v48 = math.floor((p47 - 1) / p46.TotalMediaCount);

    if p46.CachedPassNumber ~= v48 then
        local v49 = CRC32((`TreadmillMediaPass/{p46.Seed}/{v48}`));
        p46.CachedPassOrder = generatePatternOrder(p46.BucketIndices, p46.TotalMediaCount, v49, "TreadmillMediaPassBucket", v48 * p46.TotalMediaCount + 1);
        p46.CachedPassNumber = v48;
    end;

    return p46.CachedPassOrder[(p47 - 1) % p46.TotalMediaCount + 1];
end;

local function exportState(p50) -- Line: 203
    return {
        AlgorithmVersion = 5,
        Seed = p50.Seed,
        CurrentIndex = p50.CurrentIndex,
        HasSwappedRight = p50.HasSwappedRight,
        ReleaseTrackingInitialized = p50.ReleaseTrackingInitialized,
        FullFeedReleaseVersion = p50.FullFeedReleaseVersion,
        CompletedReleaseVersion = p50.CompletedReleaseVersion,
        PendingReleaseVersion = p50.PendingReleaseVersion,
        PendingCurrentMediaKey = p50.PendingCurrentMediaKey,
        SeenPendingMediaKeys = table.clone(p50.SeenPendingMediaKeys)
    };
end;

local function statesEqual(p51, p52) -- Line: 218
    if p51.Seed ~= p52.Seed or (p51.CurrentIndex ~= p52.CurrentIndex or (p51.AlgorithmVersion ~= p52.AlgorithmVersion or (p51.HasSwappedRight ~= p52.HasSwappedRight or (p51.ReleaseTrackingInitialized ~= p52.ReleaseTrackingInitialized or (p51.FullFeedReleaseVersion ~= p52.FullFeedReleaseVersion or (p51.CompletedReleaseVersion ~= p52.CompletedReleaseVersion or (p51.PendingReleaseVersion ~= p52.PendingReleaseVersion or p51.PendingCurrentMediaKey ~= p52.PendingCurrentMediaKey))))))) then
        return false;
    end;

    for i, v in pairs(p51.SeenPendingMediaKeys) do
        if v ~= p52.SeenPendingMediaKeys[i] then
            return false;
        end;
    end;

    for i, v in pairs(p52.SeenPendingMediaKeys) do
        if v ~= p51.SeenPendingMediaKeys[i] then
            return false;
        end;
    end;

    return true;
end;

local function rebuildFullFeedCatalog(p53, p54) -- Line: 246
    -- upvalues: createEmptyBucketIndices (copy)
    local v55 = createEmptyBucketIndices();
    local v56 = 0;

    for i, v in ipairs(p53.MediaEntries) do
        if v.ReleaseVersion <= p54 then
            table.insert(v55[v.BucketType], i);
            v56 = v56 + 1;
        end;
    end;

    local v57 = `Treadmill full feed release {p54} must not be empty`;
    assert(v56 > 0, v57);
    p53.BucketIndices = v55;
    p53.TotalMediaCount = v56;
    p53.CachedPassNumber = nil;
    p53.CachedPassOrder = {};
end;

local function buildDeltaOrder(p58) -- Line: 262
    -- upvalues: createEmptyBucketIndices (copy), TreadmillMediaIdentity (copy), CRC32 (copy), generatePatternOrder (copy)
    local v59 = createEmptyBucketIndices();
    local v60 = {};
    local v61 = 0;

    for i, v in ipairs(p58.MediaEntries) do
        if v.ReleaseVersion > p58.CompletedReleaseVersion and v.ReleaseVersion <= p58.PendingReleaseVersion then
            v60[TreadmillMediaIdentity.GetMediaKey(v)] = i;
            table.insert(v59[v.BucketType], i);
            v61 = v61 + 1;
        end;
    end;

    p58.DeltaMediaIndexByKey = v60;
    p58.DeltaPosition = 0;
    p58.DeltaCurrentMediaIndex = nil;

    if v61 == 0 then
        p58.DeltaOrder = {};

        return;
    end;

    p58.DeltaOrder = generatePatternOrder(v59, v61, CRC32((`TreadmillMediaDelta/{p58.Seed}/{p58.PendingReleaseVersion}`)), "TreadmillMediaDeltaBucket", 1);
    local PendingCurrentMediaKey = p58.PendingCurrentMediaKey;

    if PendingCurrentMediaKey ~= nil then
        local v62 = v60[PendingCurrentMediaKey];

        if v62 ~= nil then
            p58.DeltaCurrentMediaIndex = v62;

            for i, v in ipairs(p58.DeltaOrder) do
                if v == v62 then
                    p58.DeltaPosition = i;

                    return;
                end;
            end;

            return;
        end;

        p58.PendingCurrentMediaKey = nil;
    end;
end;

local function completeDelta(p63) -- Line: 305
    -- upvalues: rebuildFullFeedCatalog (copy)
    p63.CompletedReleaseVersion = p63.PendingReleaseVersion;
    p63.PendingReleaseVersion = 0;
    p63.PendingCurrentMediaKey = nil;
    p63.SeenPendingMediaKeys = {};
    p63.DeltaOrder = {};
    p63.DeltaMediaIndexByKey = {};
    p63.DeltaCurrentMediaIndex = nil;
    p63.DeltaPosition = 0;
    p63.CurrentIndex = 0;
    p63.FullFeedReleaseVersion = p63.CurrentReleaseVersion;
    rebuildFullFeedCatalog(p63, p63.FullFeedReleaseVersion);
end;

local function takeNextDeltaMedia(p64) -- Line: 319
    -- upvalues: TreadmillMediaIdentity (copy)
    local v65 = #p64.DeltaOrder;
    local v66 = p64.DeltaPosition + 1;

    if p64.DeltaCurrentMediaIndex == nil then
        v66 = 0;

        for i, v in ipairs(p64.DeltaOrder) do
            local v67 = TreadmillMediaIdentity.GetMediaKey(p64.MediaEntries[v]);

            if not p64.SeenPendingMediaKeys[v67] then
                v66 = i;
                break;
            end;
        end;
    end;

    if v66 < 1 or v65 < v66 then
        return nil;
    end;

    local v68 = p64.DeltaOrder[v66];
    local v69 = TreadmillMediaIdentity.GetMediaKey(p64.MediaEntries[v68]);
    p64.DeltaPosition = v66;
    p64.DeltaCurrentMediaIndex = v68;
    p64.PendingCurrentMediaKey = v69;
    p64.SeenPendingMediaKeys[v69] = true;

    return v68;
end;

local function takePreviousDeltaMedia(p70) -- Line: 345
    -- upvalues: TreadmillMediaIdentity (copy)
    for i = p70.DeltaPosition - 1, 1, -1 do
        local v71 = p70.DeltaOrder[i];
        local v72 = TreadmillMediaIdentity.GetMediaKey(p70.MediaEntries[v71]);

        if p70.SeenPendingMediaKeys[v72] then
            p70.DeltaPosition = i;
            p70.DeltaCurrentMediaIndex = v71;
            p70.PendingCurrentMediaKey = v72;

            return v71;
        end;
    end;

    return nil;
end;

local function startDelta(p73) -- Line: 359
    -- upvalues: buildDeltaOrder (copy), takeNextDeltaMedia (copy), completeDelta (copy)
    p73.PendingReleaseVersion = p73.CurrentReleaseVersion;
    p73.PendingCurrentMediaKey = nil;
    p73.SeenPendingMediaKeys = {};
    buildDeltaOrder(p73);
    local v74 = takeNextDeltaMedia(p73);

    if v74 == nil then
        completeDelta(p73);
    end;

    return v74;
end;

local function takeNextFullMedia(p75) -- Line: 371
    -- upvalues: CRC32 (copy), generatePatternOrder (copy)
    p75.CurrentIndex = p75.CurrentIndex + 1;

    if p75.FullFeedReleaseVersion == p75.CurrentReleaseVersion and p75.CurrentIndex >= p75.TotalMediaCount then
        p75.CompletedReleaseVersion = math.max(p75.CompletedReleaseVersion, p75.FullFeedReleaseVersion);
    end;

    local CurrentIndex = p75.CurrentIndex;
    local v76 = math.floor((CurrentIndex - 1) / p75.TotalMediaCount);

    if p75.CachedPassNumber ~= v76 then
        local v77 = CRC32((`TreadmillMediaPass/{p75.Seed}/{v76}`));
        p75.CachedPassOrder = generatePatternOrder(p75.BucketIndices, p75.TotalMediaCount, v77, "TreadmillMediaPassBucket", v76 * p75.TotalMediaCount + 1);
        p75.CachedPassNumber = v76;
    end;

    return p75.CachedPassOrder[(CurrentIndex - 1) % p75.TotalMediaCount + 1];
end;

function u4.IsReleaseTrackingStateCurrent(p78) -- Line: 386
    local v79;

    if p78.Seed > 0 and (p78.AlgorithmVersion == 5 and p78.HasSwappedRight ~= nil) then
        v79 = p78.ReleaseTrackingInitialized;
    else
        v79 = false;
    end;

    return v79;
end;

function u4.ResolveReleaseTrackingState(p80, p81, p82) -- Line: 393
    -- upvalues: u4 (copy), TreadmillMediaCatalog (copy), CRC32 (copy)
    if u4.IsReleaseTrackingStateCurrent(p80) then
        return p80;
    end;

    local v83 = math.floor(p80.CurrentIndex);
    local v84 = math.max(0, v83);
    local v85;

    if p80.Seed > 0 then
        v85 = p80.AlgorithmVersion == 5;
    else
        v85 = false;
    end;

    local v86 = (not v85 or TreadmillMediaCatalog.BASELINE_MEDIA_COUNT > v84) and 0 or TreadmillMediaCatalog.BASELINE_RELEASE_VERSION;
    local v87 = {
        AlgorithmVersion = 5,
        ReleaseTrackingInitialized = true,
        PendingReleaseVersion = 0,
        PendingCurrentMediaKey = nil
    };
    local v88 = not v85 and 0 or p80.Seed;
    local v89;

    if v88 > 0 then
        v89 = math.floor(v88);
    else
        v89 = CRC32((`TreadmillMediaFeed/{p81}`));
    end;

    v87.Seed = v89;
    v87.CurrentIndex = v86 <= 0 and 0 or v84;
    v87.HasSwappedRight = p82;
    local v90;

    if v86 > 0 then
        v90 = TreadmillMediaCatalog.BASELINE_RELEASE_VERSION;
    else
        v90 = TreadmillMediaCatalog.CURRENT_RELEASE_VERSION;
    end;

    v87.FullFeedReleaseVersion = v90;
    v87.CompletedReleaseVersion = v86;
    v87.SeenPendingMediaKeys = {};

    return v87;
end;

function u4.CreateRuntime(p91, p92, p93) -- Line: 425
    -- upvalues: createEmptyBucketIndices (copy), TreadmillMediaCatalog (copy), TreadmillMediaIdentity (copy), CRC32 (copy), u3 (copy), rebuildFullFeedCatalog (copy), buildDeltaOrder (copy)
    assert(#p91 > 0, "Treadmill media catalog must not be empty");
    local v94 = createEmptyBucketIndices();
    local v95 = {};

    for i, v in ipairs(p91) do
        TreadmillMediaCatalog.ResolveEntryReleaseVersion(v.ReleaseVersion);
        local v96 = TreadmillMediaIdentity.GetMediaKey(v);
        local v97 = not v95[v96];
        local v98 = `Duplicate treadmill media key "{v96}"`;
        assert(v97, v98);
        v95[v96] = true;
        table.insert(v94[v.BucketType], i);
    end;

    local CURRENT_RELEASE_VERSION = TreadmillMediaCatalog.CURRENT_RELEASE_VERSION;
    local v99 = {
        CachedPassNumber = nil,
        CompletedReleaseVersion = 0,
        CurrentIndex = 0,
        DeltaCurrentMediaIndex = nil,
        DeltaPosition = 0,
        PendingCurrentMediaKey = nil,
        PendingReleaseVersion = 0,
        ReleaseTrackingInitialized = true,
        BucketIndices = v94,
        CachedPassOrder = {},
        CurrentReleaseVersion = CURRENT_RELEASE_VERSION,
        DeltaMediaIndexByKey = {},
        DeltaOrder = {},
        FullFeedReleaseVersion = CURRENT_RELEASE_VERSION,
        HasSwappedRight = p92.HasSwappedRight == true,
        MediaEntries = p91
    };
    local Seed = p92.Seed;
    local v100;

    if Seed > 0 then
        v100 = math.floor(Seed);
    else
        v100 = CRC32((`TreadmillMediaFeed/{p93}`));
    end;

    v99.Seed = v100;
    v99.SeenPendingMediaKeys = {};
    v99.TotalMediaCount = #p91;

    if p92.AlgorithmVersion ~= 5 then
        u3:AtTrace():Log("Resetting treadmill media feed state for algorithm version change");
        rebuildFullFeedCatalog(v99, v99.FullFeedReleaseVersion);

        return v99;
    end;

    local v101 = math.floor(p92.CurrentIndex);
    v99.CurrentIndex = math.max(0, v101);

    if p92.ReleaseTrackingInitialized then
        local v102 = math.floor(p92.FullFeedReleaseVersion);
        v99.FullFeedReleaseVersion = math.max(0, v102);
        local v103 = math.floor(p92.CompletedReleaseVersion);
        local v104 = math.max(0, v103);
        v99.CompletedReleaseVersion = math.min(v104, CURRENT_RELEASE_VERSION);
        local v105 = math.floor(p92.PendingReleaseVersion);
        v99.PendingReleaseVersion = math.max(0, v105);
        v99.PendingCurrentMediaKey = p92.PendingCurrentMediaKey;
        v99.SeenPendingMediaKeys = table.clone(p92.SeenPendingMediaKeys);
    end;

    if v99.CompletedReleaseVersion == 0 and v99.FullFeedReleaseVersion ~= CURRENT_RELEASE_VERSION then
        v99.CurrentIndex = 0;
        v99.FullFeedReleaseVersion = CURRENT_RELEASE_VERSION;
        v99.PendingReleaseVersion = 0;
        v99.PendingCurrentMediaKey = nil;
        v99.SeenPendingMediaKeys = {};
    end;

    if v99.CompletedReleaseVersion > 0 and v99.FullFeedReleaseVersion == 0 then
        v99.FullFeedReleaseVersion = v99.CompletedReleaseVersion;
    end;

    if v99.PendingReleaseVersion <= v99.CompletedReleaseVersion or CURRENT_RELEASE_VERSION < v99.PendingReleaseVersion then
        v99.PendingReleaseVersion = 0;
        v99.PendingCurrentMediaKey = nil;
        v99.SeenPendingMediaKeys = {};
    else
        buildDeltaOrder(v99);
    end;

    rebuildFullFeedCatalog(v99, v99.FullFeedReleaseVersion);

    return v99;
end;

function u4.Next(p106) -- Line: 504
    -- upvalues: takeNextDeltaMedia (copy), exportState (copy), completeDelta (copy), startDelta (copy), CRC32 (copy), generatePatternOrder (copy)
    p106.HasSwappedRight = true;

    if p106.PendingReleaseVersion > p106.CompletedReleaseVersion then
        local v107 = takeNextDeltaMedia(p106);

        if v107 ~= nil then
            return v107, exportState(p106);
        end;

        completeDelta(p106);
    end;

    if p106.CompletedReleaseVersion > 0 and p106.CompletedReleaseVersion < p106.CurrentReleaseVersion then
        local v108 = startDelta(p106);

        if v108 ~= nil then
            return v108, exportState(p106);
        end;
    end;

    p106.CurrentIndex = p106.CurrentIndex + 1;

    if p106.FullFeedReleaseVersion == p106.CurrentReleaseVersion and p106.CurrentIndex >= p106.TotalMediaCount then
        p106.CompletedReleaseVersion = math.max(p106.CompletedReleaseVersion, p106.FullFeedReleaseVersion);
    end;

    local CurrentIndex = p106.CurrentIndex;
    local v109 = math.floor((CurrentIndex - 1) / p106.TotalMediaCount);

    if p106.CachedPassNumber ~= v109 then
        local v110 = CRC32((`TreadmillMediaPass/{p106.Seed}/{v109}`));
        p106.CachedPassOrder = generatePatternOrder(p106.BucketIndices, p106.TotalMediaCount, v110, "TreadmillMediaPassBucket", v109 * p106.TotalMediaCount + 1);
        p106.CachedPassNumber = v109;
    end;

    return p106.CachedPassOrder[(CurrentIndex - 1) % p106.TotalMediaCount + 1], exportState(p106);
end;

function u4.Current(p111) -- Line: 524
    -- upvalues: exportState (copy), takeNextDeltaMedia (copy), completeDelta (copy), CRC32 (copy), generatePatternOrder (copy)
    if p111.PendingReleaseVersion > p111.CompletedReleaseVersion then
        local DeltaCurrentMediaIndex = p111.DeltaCurrentMediaIndex;

        if DeltaCurrentMediaIndex ~= nil then
            return DeltaCurrentMediaIndex, exportState(p111);
        end;

        local v112 = takeNextDeltaMedia(p111);

        if v112 ~= nil then
            return v112, exportState(p111);
        end;

        completeDelta(p111);
    end;

    local v113 = math.max(p111.CurrentIndex, 1);
    p111.CurrentIndex = v113;
    local v114 = math.floor((v113 - 1) / p111.TotalMediaCount);

    if p111.CachedPassNumber ~= v114 then
        local v115 = CRC32((`TreadmillMediaPass/{p111.Seed}/{v114}`));
        p111.CachedPassOrder = generatePatternOrder(p111.BucketIndices, p111.TotalMediaCount, v115, "TreadmillMediaPassBucket", v114 * p111.TotalMediaCount + 1);
        p111.CachedPassNumber = v114;
    end;

    return p111.CachedPassOrder[(v113 - 1) % p111.TotalMediaCount + 1], exportState(p111);
end;

function u4.Previous(p116) -- Line: 542
    -- upvalues: takePreviousDeltaMedia (copy), exportState (copy), CRC32 (copy), generatePatternOrder (copy)
    if p116.PendingReleaseVersion > p116.CompletedReleaseVersion then
        local DeltaCurrentMediaIndex = p116.DeltaCurrentMediaIndex;
        assert(DeltaCurrentMediaIndex ~= nil, "Pending treadmill media delta must have a current media entry");
        local v117 = takePreviousDeltaMedia(p116);

        if v117 == nil then
            return DeltaCurrentMediaIndex, exportState(p116), false;
        end;

        return v117, exportState(p116), true;
    end;

    local v118 = math.max(p116.CurrentIndex - 1, 1);
    local v119 = v118 ~= p116.CurrentIndex;
    p116.CurrentIndex = v118;
    local v120 = math.floor((v118 - 1) / p116.TotalMediaCount);

    if p116.CachedPassNumber ~= v120 then
        local v121 = CRC32((`TreadmillMediaPass/{p116.Seed}/{v120}`));
        p116.CachedPassOrder = generatePatternOrder(p116.BucketIndices, p116.TotalMediaCount, v121, "TreadmillMediaPassBucket", v120 * p116.TotalMediaCount + 1);
        p116.CachedPassNumber = v120;
    end;

    return p116.CachedPassOrder[(v118 - 1) % p116.TotalMediaCount + 1], exportState(p116), v119;
end;

function u4.ExportState(p122) -- Line: 561
    -- upvalues: exportState (copy)
    return exportState(p122);
end;

function u4.StatesEqual(p123, p124) -- Line: 565
    -- upvalues: statesEqual (copy)
    return statesEqual(p123, p124);
end;

function u4.IsLegalTransition(p125, p126, p127, p128) -- Line: 569
    -- upvalues: statesEqual (copy), u4 (copy)
    if statesEqual(p126, p127) then
        return true;
    end;

    local v129 = u4.CreateRuntime(p125, p126, p128);
    local _, v130 = u4.Current(v129);

    if statesEqual(v130, p127) then
        return true;
    end;

    if p126.PendingReleaseVersion <= p126.CompletedReleaseVersion then
        local v131 = u4.CreateRuntime(p125, p126, p128);
        local v132;

        if p126.PendingReleaseVersion == 0 and (p127.PendingReleaseVersion == 0 and p127.CurrentIndex < p126.CurrentIndex) then
            local v133, v134;
            v133, v132, v134 = u4.Previous(v131);

            if not v134 then
                return false;
            end;
        else
            local v135;
            v135, v132 = u4.Next(v131);
        end;

        return statesEqual(v132, p127);
    end;

    local v136 = u4.CreateRuntime(p125, p126, p128);
    local _, v137, v138 = u4.Previous(v136);

    if v138 and statesEqual(v137, p127) then
        return true;
    end;

    local v139 = u4.CreateRuntime(p125, p126, p128);
    local _, v140 = u4.Next(v139);

    return statesEqual(v140, p127);
end;

return u4;