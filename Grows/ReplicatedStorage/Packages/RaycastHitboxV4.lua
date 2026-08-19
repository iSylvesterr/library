-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local HitboxCaster = require(script.HitboxCaster);
local Signal = require(script.Signal);
local u1 = {};
u1.__index = u1;
u1.__type = "RaycastHitboxModule";
u1.DetectionMode = {
    Default = 1,
    PartMode = 2,
    Bypass = 3
};

function u1.new(p2, p3, p4) -- Line: 185
    -- upvalues: u1 (copy), CollectionService (copy), HitboxCaster (copy), Signal (copy)
    local PartMode = u1.DetectionMode.PartMode;

    if p3 ~= nil then
        PartMode = u1.DetectionMode.Bypass;
    end;

    if p2 and CollectionService:HasTag(p2, "_RaycastHitboxV4Managed") then
        return HitboxCaster:_FindHitbox(p2);
    end;

    local v5 = {
        HitboxPendingRemoval = false,
        HitboxStopTime = 0,
        HitboxActive = false,
        Visualizer = true,
        DebugLog = false,
        Tag = "_RaycastHitboxV4Managed",
        RaycastParams = p4,
        DetectionMode = PartMode,
        HitboxRaycastPoints = {},
        HitboxObject = p2,
        HitboxHitList = {},
        OnUpdate = Signal:Create(),
        OnHit = Signal:Create()
    };
    local v6 = setmetatable(v5, HitboxCaster);
    v6:_Init();

    return v6;
end;

function u1.GetHitbox(p7, p8) -- Line: 219
    -- upvalues: HitboxCaster (copy)
    if p8 then
        return HitboxCaster:_FindHitbox(p8);
    end;
end;

return u1;