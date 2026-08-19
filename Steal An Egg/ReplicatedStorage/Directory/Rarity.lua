-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Interface = require(script.Types.Interface);
local MakeTableStrict = require(ReplicatedStorage.Library.Functions.MakeTableStrict);
local PrepareItemDir = require(ReplicatedStorage.Library.Functions.PrepareItemDir);
local _Index = script._Index;
local v1 = {};
local u2 = {
    Rare = require(_Index.Rare),
    SuperRare = require(_Index.SuperRare),
    Mythical = require(_Index.Mythical),
    Legendary = require(_Index.Legendary),
    Rainbow = require(_Index.Rainbow),
    Basic = require(_Index.Basic),
    Celestial = require(_Index.Celestial),
    Exotic = require(_Index.Exotic),
    Superior = require(_Index.Superior),
    BrainrotGod = require(_Index.BrainrotGod),
    Common = require(_Index.Common),
    Uncommon = require(_Index.Uncommon),
    Rare = require(_Index.Rare),
    Epic = require(_Index.Epic),
    Legendary = require(_Index.Legendary),
    Mythic = require(_Index.Mythic),
    Cosmic = require(_Index.Cosmic),
    Secret = require(_Index.Secret),
    Eternal = require(_Index.Eternal),
    Divine = require(_Index.Divine),
    Exclusive = require(_Index.Exclusive),
    Limited = require(_Index.Limited),
    Prismatic = require(_Index.Rainbow),
    Transcendent = require(_Index.Superior),
    Admin = require(_Index.Exclusive),
    Mythical = require(_Index.Mythical)
};
v1.Rarities = u2;
v1.Types = Interface;

function v1.Types.RarityNameExists(u3) -- Line: 56
    -- upvalues: u2 (copy)
    if pcall(function() -- Line: 57
        -- upvalues: u2 (ref), u3 (copy)
        return u2[u3];
    end) then
        return true;
    end;

    return false, `Rarity name "{u3}" does not exist in the Rarities directory.`;
end;

PrepareItemDir(u2, true);
MakeTableStrict(u2, "Directory.Rarities");

if Constants.IS_STUDIO then
    for _, child in pairs(script._Index:GetChildren()) do
        local v4 = child:IsA("ModuleScript");
        local v5 = `Bad instance found inside the configs env: {child.Name}`;
        assert(v4, v5);
        local v6 = u2[child.Name];
        local v7 = `Config module: {child.Name}, not found under the directory`;
        local v8 = assert(v6, v7);
        local v9, v10 = Interface.DefaultConfig(v8);
        local v11 = `Config module: {child.Name}, failed to pass the type check: {v10}`;
        assert(v9, v11);
    end;
end;

return v1;