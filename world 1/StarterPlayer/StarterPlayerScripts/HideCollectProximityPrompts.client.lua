-- Decompiled with Potassium's decompiler.

local HideCollectProximityPrompts = game.Players.LocalPlayer:WaitForChild("HideCollectProximityPrompts");
local CollectionService = game:GetService("CollectionService");

local function TrackPrompt(u1, u2) -- Line: 12
    -- upvalues: HideCollectProximityPrompts (copy)
    u1[u2] = true;

    if HideCollectProximityPrompts.Value == true then
        u2.Enabled = false;
    end;

    u2.Destroying:Once(function() -- Line: 17
        -- upvalues: u1 (copy), u2 (copy)
        u1[u2] = nil;
    end);
end;

local u3 = {};
local u4 = {};

for _, v in CollectionService:GetTagged("HarvestPrompt") do
    u3[v] = true;

    if HideCollectProximityPrompts.Value == true then
        v.Enabled = false;
    end;

    v.Destroying:Once(function() -- Line: 17
        -- upvalues: u3 (copy), v (copy)
        u3[v] = nil;
    end);
end;

for _, v in CollectionService:GetTagged("StealPrompt") do
    u4[v] = true;

    if HideCollectProximityPrompts.Value == true then
        v.Enabled = false;
    end;

    v.Destroying:Once(function() -- Line: 17
        -- upvalues: u4 (copy), v (copy)
        u4[v] = nil;
    end);
end;

CollectionService:GetInstanceAddedSignal("HarvestPrompt"):Connect(function(u5) -- Line: 30
    -- upvalues: u3 (copy), HideCollectProximityPrompts (copy)
    local u6 = u3;
    u6[u5] = true;

    if HideCollectProximityPrompts.Value == true then
        u5.Enabled = false;
    end;

    u5.Destroying:Once(function() -- Line: 17
        -- upvalues: u6 (copy), u5 (copy)
        u6[u5] = nil;
    end);
end);
CollectionService:GetInstanceAddedSignal("StealPrompt"):Connect(function(u7) -- Line: 34
    -- upvalues: u4 (copy), HideCollectProximityPrompts (copy)
    local u8 = u4;
    u8[u7] = true;

    if HideCollectProximityPrompts.Value == true then
        u7.Enabled = false;
    end;

    u7.Destroying:Once(function() -- Line: 17
        -- upvalues: u8 (copy), u7 (copy)
        u8[u7] = nil;
    end);
end);
HideCollectProximityPrompts:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 38
    -- upvalues: HideCollectProximityPrompts (copy), u3 (copy), u4 (copy)
    local Value = HideCollectProximityPrompts.Value;

    for i in u3 do
        i.Enabled = not Value;
    end;

    for i in u4 do
        i.Enabled = not Value;
    end;
end);