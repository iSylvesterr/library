-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local EnumMgr = UtilsSystem.EnumMgr;
local LocalPlayer = UtilsSystem.LocalPlayer;
local PlayerData = UtilsSystem.PlayerData;
local u1 = {};
local u2 = {};

local function _hasAnyBroom() -- Line: 36
    -- upvalues: PlayerData (copy), LocalPlayer (copy), EnumMgr (copy)
    local v3 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");

    if type(v3) ~= "table" then
        return false;
    end;

    local Broom = EnumMgr.ItemType.Broom;

    for _, v in pairs(v3) do
        if type(v) == "table" and (tonumber(v.tp) == Broom and (tonumber(v.count) or 0) > 0) then
            return true;
        end;
    end;

    return false;
end;

local function _setFxInstanceEnabled(p4, p5) -- Line: 59
    if p4:IsA("Beam") or p4:IsA("ParticleEmitter") then
        p4.Enabled = p5;
    end;
end;

local function _applyModelFx(p6, p7) -- Line: 72
    for _, descendant in p6:GetDescendants() do
        if descendant:IsA("Beam") or descendant:IsA("ParticleEmitter") then
            descendant.Enabled = p7;
        end;
    end;
end;

local function _unbindDescendantWatch(p8) -- Line: 98
    -- upvalues: u2 (copy)
    local v9 = u2[p8];

    if v9 then
        v9:Disconnect();
        u2[p8] = nil;
    end;
end;

local function _trackModel(p10) -- Line: 112
    -- upvalues: u1 (copy), _hasAnyBroom (copy), u2 (copy)
    if u1[p10] then
        local v11 = _hasAnyBroom();

        for _, descendant in p10:GetDescendants() do
            if descendant:IsA("Beam") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = v11;
            end;
        end;

        return;
    end;

    u1[p10] = true;
    local v12 = _hasAnyBroom();

    for _, descendant in p10:GetDescendants() do
        if descendant:IsA("Beam") or descendant:IsA("ParticleEmitter") then
            descendant.Enabled = v12;
        end;
    end;

    local v13 = u2[p10];

    if v13 then
        v13:Disconnect();
        u2[p10] = nil;
    end;

    u2[p10] = p10.DescendantAdded:Connect(function(p14) -- Line: 121
        -- upvalues: _hasAnyBroom (ref)
        local v15 = _hasAnyBroom();

        if p14:IsA("Beam") or p14:IsA("ParticleEmitter") then
            p14.Enabled = v15;
        end;
    end);
end;

local function _untrackModel(p16) -- Line: 132
    -- upvalues: u2 (copy), u1 (copy)
    local v17 = u2[p16];

    if v17 then
        v17:Disconnect();
        u2[p16] = nil;
    end;

    u1[p16] = nil;
end;

local function _onTaggedAdded(p18) -- Line: 143
    -- upvalues: _trackModel (copy)
    if p18:IsA("Model") then
        _trackModel(p18);
    end;
end;

local function _onTaggedRemoved(p19) -- Line: 155
    -- upvalues: u2 (copy), u1 (copy)
    if p19:IsA("Model") then
        local v20 = u2[p19];

        if v20 then
            v20:Disconnect();
            u2[p19] = nil;
        end;

        u1[p19] = nil;
    end;
end;

local function _refreshAll() -- Line: 83
    -- upvalues: _hasAnyBroom (copy), u1 (copy)
    local v21 = _hasAnyBroom();

    for i in pairs(u1) do
        if i.Parent then
            for _, descendant in i:GetDescendants() do
                if descendant:IsA("Beam") or descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = v21;
                end;
            end;
        end;
    end;
end;

for _, v in CollectionService:GetTagged("TeleEffect") do
    if v:IsA("Model") then
        _trackModel(v);
    end;
end;

CollectionService:GetInstanceAddedSignal("TeleEffect"):Connect(_onTaggedAdded);
CollectionService:GetInstanceRemovedSignal("TeleEffect"):Connect(_onTaggedRemoved);
PlayerData.ListenClientSync(function(p22, p23) -- Line: 168
    -- upvalues: _refreshAll (copy)
    if p22 == nil then
        _refreshAll();

        return;
    end;

    if type(p22) == "table" then
        p22 = p22[1];
    end;

    if p22 == "Bag" then
        _refreshAll();
    end;
end);
task.defer(_refreshAll);