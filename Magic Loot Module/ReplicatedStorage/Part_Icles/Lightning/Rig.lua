-- Decompiled with Potassium's decompiler.

local Pool = require(script.Parent.Parent.Pool);
local BoltGen = require(script.Parent.BoltGen);
local u1 = CFrame.new(1000000000, 1000000000, 1000000000);
local u2 = {
    MAX_BOLT_PARTS = 64,
    Rigs = setmetatable({}, {
        __mode = "k"
    })
};

local function buildSegment(p3) -- Line: 24
    -- upvalues: Pool (copy)
    local v4 = Pool.copyBare(p3);
    v4.Anchored = true;
    v4.CanCollide = false;
    v4.CanQuery = false;
    v4.CanTouch = false;
    v4.Massless = true;
    v4.Locked = true;
    v4.Archivable = false;
    v4.Transparency = 0;

    return v4, v4:FindFirstChildWhichIsA("Decal") or v4:FindFirstChildWhichIsA("Texture");
end;

function u2.layoutFor(p5) -- Line: 40
    -- upvalues: BoltGen (copy)
    return BoltGen.layout(p5.SegmentCount.Max, p5.ForkDepth.Max, p5.ForkChance.Max, 64);
end;

function u2.buildRig(p6) -- Line: 46
    -- upvalues: u2 (copy), Pool (copy), u1 (copy)
    local v7, v8, v9, v10 = u2.layoutFor(p6);
    local Model = Instance.new("Model");
    Model.Name = "LightningBolt";
    Model.Archivable = false;
    Model:SetAttribute("_lightningBolt", true);
    local v11 = {
        partCount = v7,
        mainSegs = v8,
        forkSegs = v9,
        forkSlots = v10,
        parts = table.create(v7),
        rollCFs = table.create(v7),
        writeCFs = table.create(v7),
        segLen = table.create(v7),
        revealDist = table.create(v7),
        revealOrder = table.create(v7),
        widthScale = table.create(v7),
        decals = table.create(v7),
        slotDepth = table.create((math.max(v10, 1))),
        ptBuf = table.create(v8 + 1),
        basePtBuf = table.create(v8 + 1),
        forkPtBuf = table.create(v9 + 1),
        forkAnchorPos = {},
        forkAnchorDir = {},
        forkAnchorReveal = {},
        forkAnchorSlot = {},
        forkAnchorPtIdx = {},
        forkOriginIdx = {},
        forkParentSlot = {},
        forkParentPtIdx = {},
        forkLen = {},
        forkU = {},
        forkV = {},
        forkSeedU = {},
        forkSeedV = {},
        forkLocalPts = {},
        forkWorldPts = {},
        prevLive = table.create(v7),
        lastWrittenLen = table.create(v7),
        sizeWriteIdx = table.create(v7),
        newlyLiveIdx = table.create(v7),
        gradColor = table.create(v7)
    };

    for i = 1, v10 do
        v11.forkLocalPts[i] = table.create(v9 + 1);
        v11.forkWorldPts[i] = table.create(v9 + 1);
        v11.forkOriginIdx[i] = 0;
        v11.forkParentSlot[i] = 0;
    end;

    local v12;

    if v10 > 0 then
        local v13 = math.ceil(v10 / 2);
        v12 = math.max(1, v13) or 0;
    else
        v12 = 0;
    end;

    for i = 1, v10 do
        v11.slotDepth[i] = i <= v12 and 1 or 2;
    end;

    local v14 = math.max(0.45, p6.ForkLengthScale and (p6.ForkLengthScale.Max or 0.4) or 0.4);

    for i = 1, v7 do
        local v15 = Pool.copyBare(p6.RenderTemplate);
        v15.Anchored = true;
        v15.CanCollide = false;
        v15.CanQuery = false;
        v15.CanTouch = false;
        v15.Massless = true;
        v15.Locked = true;
        v15.Archivable = false;
        v15.Transparency = 0;
        local v16 = v15:FindFirstChildWhichIsA("Decal") or v15:FindFirstChildWhichIsA("Texture");
        v15.Name = "Seg" .. i;
        v15.CFrame = u1;
        v15.Parent = Model;
        v11.parts[i] = v15;
        v11.decals[i] = v16;
        v11.rollCFs[i] = u1;
        v11.writeCFs[i] = u1;
        v11.segLen[i] = 0.05;
        v11.revealDist[i] = (1 / 0);
        v11.revealOrder[i] = i;
        v11.prevLive[i] = false;
        v11.lastWrittenLen[i] = -1;

        if i <= v8 then
            v11.widthScale[i] = 1;
        else
            local v17 = math.floor((i - v8 - 1) / v9) + 1;
            v11.widthScale[i] = v14 ^ (v11.slotDepth[v17] or 1);
        end;
    end;

    u2.Rigs[Model] = v11;

    return Model, v11;
end;

function u2.acquireBolt(p18) -- Line: 126
    -- upvalues: u2 (copy), Pool (copy)
    local v19 = u2.layoutFor(p18);
    local u20 = p18.Pool ~= false and Pool.acquire(p18.RenderTemplate, "Lightning");

    if u20 then
        local v21 = u2.Rigs[u20];

        if v21 and (v21.partCount == v19 and (v21.parts[1] and v21.parts[1].Parent == u20)) then
            u20:SetAttribute("_PartIcleEmit", true);

            return u20, v21;
        end;

        pcall(function() -- Line: 136
            -- upvalues: u20 (copy)
            u20:Destroy();
        end);
    end;

    local v22, v23 = u2.buildRig(p18);
    v22:SetAttribute("_PartIcleEmit", true);

    return v22, v23;
end;

return u2;