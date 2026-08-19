-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Notification = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "Notification").Notification;
local SprayBottles = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "cleaning", "SprayBottles").SprayBottles;
local Detectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Detectors").Detectors;
local Shovels = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Shovels").Shovels;
local isIslandUnlocked = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "world", "Islands").isIslandUnlocked;
local RichTextUtil = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "ui", "RichTextUtil").RichTextUtil;

local function shovelNotice(u1, p2) -- Line: 12
    -- upvalues: Shovels (copy)
    local v3 = Shovels[u1];
    local displayName = v3.displayName;
    local cost = v3.cost;
    local islandId = v3.islandId;

    return {
        id = `shovel:{u1}`,
        displayName = displayName,
        cost = cost,
        color = p2,
        islandId = islandId,

        isOwned = function(p4) -- Line: 23, Name: isOwned
            -- upvalues: u1 (copy)
            return table.find(p4.OwnedShovels, u1) ~= nil;
        end
    };
end;

local function sprayNotice(u5, p6) -- Line: 30
    -- upvalues: SprayBottles (copy)
    local v7 = SprayBottles[u5];
    local displayName = v7.displayName;
    local cost = v7.cost;
    local islandId = v7.islandId;

    return {
        id = `spray:{u5}`,
        displayName = displayName,
        cost = cost,
        color = p6,
        islandId = islandId,

        isOwned = function(p8) -- Line: 41, Name: isOwned
            -- upvalues: u5 (copy)
            return table.find(p8.OwnedSprays, u5) ~= nil;
        end
    };
end;

local function detectorNotice(u9, p10) -- Line: 48
    -- upvalues: Detectors (copy)
    local v11 = Detectors[u9];
    local displayName = v11.displayName;
    local cost = v11.cost;
    local islandId = v11.islandId;

    return {
        id = `detector:{u9}`,
        displayName = displayName,
        cost = cost,
        color = p10,
        islandId = islandId,

        isOwned = function(p12) -- Line: 59, Name: isOwned
            -- upvalues: u9 (copy)
            return table.find(p12.OwnedDetectors, u9) ~= nil;
        end
    };
end;

local u13 = {};
local v14 = Color3.fromRGB(178, 116, 42);
local woodShovel = Shovels.woodShovel;
local v15 = {
    id = "shovel:woodShovel",
    displayName = woodShovel.displayName,
    cost = woodShovel.cost,
    color = v14,
    islandId = woodShovel.islandId
};
local u16 = "woodShovel";

function v15.isOwned(p17) -- Line: 23
    -- upvalues: u16 (copy)
    return table.find(p17.OwnedShovels, u16) ~= nil;
end;

local v18 = Color3.fromRGB(150, 172, 205);
local stoneShovel = Shovels.stoneShovel;
local v19 = {
    id = "shovel:stoneShovel",
    displayName = stoneShovel.displayName,
    cost = stoneShovel.cost,
    color = v18,
    islandId = stoneShovel.islandId
};
local u20 = "stoneShovel";

function v19.isOwned(p21) -- Line: 23
    -- upvalues: u20 (copy)
    return table.find(p21.OwnedShovels, u20) ~= nil;
end;

local v22 = Color3.fromRGB(208, 221, 240);
local metalShovel = Shovels.metalShovel;
local v23 = {
    id = "shovel:metalShovel",
    displayName = metalShovel.displayName,
    cost = metalShovel.cost,
    color = v22,
    islandId = metalShovel.islandId
};
local u24 = "metalShovel";

function v23.isOwned(p25) -- Line: 23
    -- upvalues: u24 (copy)
    return table.find(p25.OwnedShovels, u24) ~= nil;
end;

local v26 = Color3.fromRGB(240, 206, 30);
local goldShovel = Shovels.goldShovel;
local v27 = {
    id = "shovel:goldShovel",
    displayName = goldShovel.displayName,
    cost = goldShovel.cost,
    color = v26,
    islandId = goldShovel.islandId
};
local u28 = "goldShovel";

function v27.isOwned(p29) -- Line: 23
    -- upvalues: u28 (copy)
    return table.find(p29.OwnedShovels, u28) ~= nil;
end;

local v30 = Color3.fromRGB(173, 62, 248);
local amethystShovel = Shovels.amethystShovel;
local v31 = {
    id = "shovel:amethystShovel",
    displayName = amethystShovel.displayName,
    cost = amethystShovel.cost,
    color = v30,
    islandId = amethystShovel.islandId
};
local u32 = "amethystShovel";

function v31.isOwned(p33) -- Line: 23
    -- upvalues: u32 (copy)
    return table.find(p33.OwnedShovels, u32) ~= nil;
end;

local v34 = Color3.fromRGB(82, 124, 255);
local rubber = SprayBottles.rubber;
local v35 = {
    id = "spray:rubber",
    displayName = rubber.displayName,
    cost = rubber.cost,
    color = v34,
    islandId = rubber.islandId
};
local u36 = "rubber";

function v35.isOwned(p37) -- Line: 41
    -- upvalues: u36 (copy)
    return table.find(p37.OwnedSprays, u36) ~= nil;
end;

local v38 = Color3.fromRGB(240, 86, 56);
local plastic = SprayBottles.plastic;
local v39 = {
    id = "spray:plastic",
    displayName = plastic.displayName,
    cost = plastic.cost,
    color = v38,
    islandId = plastic.islandId
};
local u40 = "plastic";

function v39.isOwned(p41) -- Line: 41
    -- upvalues: u40 (copy)
    return table.find(p41.OwnedSprays, u40) ~= nil;
end;

local v42 = Color3.fromRGB(243, 158, 64);
local copper = SprayBottles.copper;
local v43 = {
    id = "spray:copper",
    displayName = copper.displayName,
    cost = copper.cost,
    color = v42,
    islandId = copper.islandId
};
local u44 = "copper";

function v43.isOwned(p45) -- Line: 41
    -- upvalues: u44 (copy)
    return table.find(p45.OwnedSprays, u44) ~= nil;
end;

local v46 = Color3.fromRGB(148, 164, 194);
local steel = SprayBottles.steel;
local v47 = {
    id = "spray:steel",
    displayName = steel.displayName,
    cost = steel.cost,
    color = v46,
    islandId = steel.islandId
};
local u48 = "steel";

function v47.isOwned(p49) -- Line: 41
    -- upvalues: u48 (copy)
    return table.find(p49.OwnedSprays, u48) ~= nil;
end;

local v50 = Color3.fromRGB(232, 203, 74);
local gold = SprayBottles.gold;
local v51 = {
    id = "spray:gold",
    displayName = gold.displayName,
    cost = gold.cost,
    color = v50,
    islandId = gold.islandId
};
local u52 = "gold";

function v51.isOwned(p53) -- Line: 41
    -- upvalues: u52 (copy)
    return table.find(p53.OwnedSprays, u52) ~= nil;
end;

local v54 = Color3.fromRGB(122, 205, 240);
local turquoise = SprayBottles.turquoise;
local v55 = {
    id = "spray:turquoise",
    displayName = turquoise.displayName,
    cost = turquoise.cost,
    color = v54,
    islandId = turquoise.islandId
};
local u56 = "turquoise";

function v55.isOwned(p57) -- Line: 41
    -- upvalues: u56 (copy)
    return table.find(p57.OwnedSprays, u56) ~= nil;
end;

local v58 = Color3.fromRGB(198, 124, 62);
local copper2 = Detectors.copper;
local v59 = {
    id = "detector:copper",
    displayName = copper2.displayName,
    cost = copper2.cost,
    color = v58,
    islandId = copper2.islandId
};
local u60 = "copper";

function v59.isOwned(p61) -- Line: 59
    -- upvalues: u60 (copy)
    return table.find(p61.OwnedDetectors, u60) ~= nil;
end;

local v62 = Color3.fromRGB(196, 202, 208);
local silver = Detectors.silver;
local v63 = {
    id = "detector:silver",
    displayName = silver.displayName,
    cost = silver.cost,
    color = v62,
    islandId = silver.islandId
};
local u64 = "silver";

function v63.isOwned(p65) -- Line: 59
    -- upvalues: u64 (copy)
    return table.find(p65.OwnedDetectors, u64) ~= nil;
end;

local v66 = Color3.fromRGB(236, 199, 68);
local gold2 = Detectors.gold;
local v67 = {
    id = "detector:gold",
    displayName = gold2.displayName,
    cost = gold2.cost,
    color = v66,
    islandId = gold2.islandId
};
local u68 = "gold";

function v67.isOwned(p69) -- Line: 59
    -- upvalues: u68 (copy)
    return table.find(p69.OwnedDetectors, u68) ~= nil;
end;

local v70 = Color3.fromRGB(158, 196, 210);
local platinum = Detectors.platinum;
local v71 = {
    id = "detector:platinum",
    displayName = platinum.displayName,
    cost = platinum.cost,
    color = v70,
    islandId = platinum.islandId
};
local u72 = "platinum";

function v71.isOwned(p73) -- Line: 59
    -- upvalues: u72 (copy)
    return table.find(p73.OwnedDetectors, u72) ~= nil;
end;

u13[1], u13[2], u13[3], u13[4], u13[5], u13[6], u13[7], u13[8], u13[9], u13[10], u13[11], u13[12], u13[13], u13[14], u13[15] = v15, v19, v23, v27, v31, v35, v39, v43, v47, v51, v55, v59, v63, v67, v71;
local u74 = setmetatable({}, {
    __tostring = function() -- Line: 70, Name: __tostring
        return "AffordNotificationController";
    end
});
u74.__index = u74;

function u74.new(...) -- Line: 75
    -- upvalues: u74 (ref)
    local v75 = setmetatable({}, u74);

    return v75:constructor(...) or v75;
end;

function u74.constructor(p76, p77, p78) -- Line: 79
    p76.data = p77;
    p76.tutorial = p78;
    p76.notified = {};
    p76.busy = {};
    p76.deferred = {};
    p76.ready = false;
end;

function u74.onStart(p79) -- Line: 87
    p79:review(p79.data:getData(), false);
    p79.ready = true;
end;

function u74.onDataChanged(p80, p81, p82) -- Line: 91
    if not p80.ready then
        return nil;
    end;

    p80:review(p82, not p80.tutorial:isActive());
end;

function u74.setBusy(p83, p84, p85) -- Line: 97
    if p85 then
        p83.busy[p84] = true;

        return nil;
    end;

    p83.busy[p84] = nil;

    if next(p83.busy) == nil then
        p83:flushDeferred();
    end;
end;

function u74.review(p86, p87, p88) -- Line: 111
    -- upvalues: u13 (copy), isIslandUnlocked (copy)
    for _, v in u13 do
        if p86.notified[v.id] == nil and isIslandUnlocked(v.islandId, p87.UnlockedIslands) then
            local v89 = v.isOwned(p87);

            if v89 or p87.Gold >= v.cost then
                p86.notified[v.id] = true;

                if not v89 and p88 then
                    if next(p86.busy) == nil then
                        p86:announce(v);
                    else
                        table.insert(p86.deferred, v);
                    end;
                end;
            end;
        end;
    end;
end;

function u74.flushDeferred(p90) -- Line: 139
    local v91 = p90.data:getData();

    for _, v in p90.deferred do
        if not v.isOwned(v91) then
            p90:announce(v);
        end;
    end;

    p90.deferred = {};
end;

function u74.announce(p92, p93) -- Line: 148
    -- upvalues: Notification (copy), RichTextUtil (copy)
    Notification.new(`You can afford {RichTextUtil.color(p93.displayName, p93.color)}!`, 3, "Notification");
end;

Reflect.defineMetadata(u74, "identifier", "client/controllers/ui/AffordNotificationController@AffordNotificationController");
Reflect.defineMetadata(u74, "flamework:parameters", { "client/controllers/data/DataController@DataController", "client/controllers/tutorial/TutorialController@TutorialController" });
Reflect.defineMetadata(u74, "flamework:implements", { "$:flamework@OnStart", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u74, "$:flamework@Controller", Controller, { {} });

return {
    AffordNotificationController = u74
};