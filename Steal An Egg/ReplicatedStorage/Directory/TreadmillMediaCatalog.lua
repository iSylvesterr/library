-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1 = {
    BASELINE_RELEASE_VERSION = 1,
    BASELINE_MEDIA_COUNT = 246,
    CURRENT_RELEASE_VERSION = 2
};

function u1.ResolveEntryReleaseVersion(p2) -- Line: 20
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.positiveInteger(p2);
    local v3 = p2 <= u1.CURRENT_RELEASE_VERSION;
    local v4 = `Treadmill media release {p2} exceeds current release {u1.CURRENT_RELEASE_VERSION}`;
    assert(v3, v4);

    return p2;
end;

return u1;