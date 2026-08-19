-- Decompiled with Potassium's decompiler.

local Bag = require(script.Bag);
local BagEntry = require(script.BagEntry);
local PlayerMirror = require(script.PlayerMirror);
local PlayerAttr = require(script.PlayerAttr);
local EquipAttr = require(script.EquipAttr);
local CombatDamage = require(script.CombatDamage);
local Sell = require(script.Sell);
local SkillScale = require(script.SkillScale);
local Backpack = require(script.Backpack);
local Alchemy = require(script.Alchemy);
local Train = require(script.Train);
local Shop = require(script.Shop);
local OfflineReward = require(script.OfflineReward);
local Login = require(script.Login);
local u1 = {
    Bag = Bag,
    Entry = BagEntry,
    Mirror = PlayerMirror,
    PlayerAttr = PlayerAttr,
    EquipAttr = EquipAttr,
    CombatDamage = CombatDamage,
    Sell = Sell,
    SkillScale = SkillScale,
    Backpack = Backpack,
    Alchemy = Alchemy,
    Train = Train,
    Shop = Shop,
    OfflineReward = OfflineReward,
    Login = Login
};

local function _mergeFlatApi(p2) -- Line: 80
    -- upvalues: u1 (copy)
    for i, v in p2 do
        if type(v) == "function" and u1[i] == nil then
            u1[i] = v;
        end;
    end;
end;

for i, v in Bag do
    if type(v) == "function" and u1[i] == nil then
        u1[i] = v;
    end;
end;

for i, v in BagEntry do
    if type(v) == "function" and u1[i] == nil then
        u1[i] = v;
    end;
end;

for i, v in PlayerMirror do
    if type(v) == "function" and u1[i] == nil then
        u1[i] = v;
    end;
end;

for i, v in PlayerAttr do
    if type(v) == "function" and u1[i] == nil then
        u1[i] = v;
    end;
end;

for i, v in EquipAttr do
    if type(v) == "function" and u1[i] == nil then
        u1[i] = v;
    end;
end;

for i, v in CombatDamage do
    if type(v) == "function" and u1[i] == nil then
        u1[i] = v;
    end;
end;

for i, v in Sell do
    if type(v) == "function" and u1[i] == nil then
        u1[i] = v;
    end;
end;

for i, v in SkillScale do
    if type(v) == "function" and u1[i] == nil then
        u1[i] = v;
    end;
end;

for i, v in Backpack do
    if type(v) == "function" and u1[i] == nil then
        u1[i] = v;
    end;
end;

for i, v in Alchemy do
    if type(v) == "function" and u1[i] == nil then
        u1[i] = v;
    end;
end;

for i, v in Train do
    if type(v) == "function" and u1[i] == nil then
        u1[i] = v;
    end;
end;

for i, v in Shop do
    if type(v) == "function" and u1[i] == nil then
        u1[i] = v;
    end;
end;

for i, v in OfflineReward do
    if type(v) == "function" and u1[i] == nil then
        u1[i] = v;
    end;
end;

for i, v in Login do
    if type(v) == "function" and u1[i] == nil then
        u1[i] = v;
    end;
end;

return u1;