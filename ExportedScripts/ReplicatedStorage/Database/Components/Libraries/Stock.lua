-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);
local u2 = { "USP-S", "Glock-18", "P250", "Desert Eagle", "Tec-9", "CZ75-Auto", "Five-SeveN", "Dual Berettas", "R8 Revolver", "MAC-10", "MP9", "MP7", "MP5-SD", "UMP-45", "P90", "PP-Bizon", "AK-47", "M4A1-S", "M4A4", "AUG", "SG 553", "FAMAS", "Galil AR", "AWP", "SSG 08", "SCAR-20", "G3SG1", "XM1014", "Nova", "MAG-7", "Sawed-Off", "Negev", "M249", "CT Knife", "T Knife", "CT Glove", "T Glove", "Molotov", "Incendiary Grenade", "HE Grenade", "Flashbang", "Smoke Grenade", "Decoy Grenade", "C4", "Zeus x27" };

local function GetInventoryItemType(p3) -- Line: 81
    -- upvalues: ReplicatedStorage (copy)
    if p3 == "Zeus x27" then
        return "Zeus x27";
    end;

    if p3 == "C4" then
        return "C4";
    end;

    local v4 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(p3);

    if not v4 then
        return "Weapon";
    end;

    local Class = require(v4).Class;

    return Class == "Weapon" and "Weapon" or (Class == "Melee" and "Melee" or (Class == "Glove" and "Glove" or (Class == "Grenade" and "Grenade" or (Class == "C4" and "C4" or "Weapon"))));
end;

local function CreateStockItem(p5) -- Line: 117
    -- upvalues: GetInventoryItemType (copy)
    return {
        Serial = 0,
        Skin = "Stock",
        Float = 0,
        StatTrack = false,
        IsTradeable = false,
        NameTag = false,
        Charm = false,
        _id = p5 .. "_Stock",
        Type = GetInventoryItemType(p5),
        Name = p5,
        Stickers = {},
        MetaData = {
            LastTradeAt = 0,
            CreatedAt = 0,
            OriginalOwner = 0,
            Owner = 0,
            Origin = "Stock",
            TradeHistory = {}
        }
    };
end;

function u1.IsStockIdentifier(p6) -- Line: 144
    return string.sub(p6, -6) == "_Stock";
end;

function u1.GetWeaponNameFromStockId(p7) -- Line: 150
    -- upvalues: u1 (copy)
    if u1.IsStockIdentifier(p7) then
        return string.sub(p7, 1, -7);
    end;

    return nil;
end;

function u1.GetStockInventoryItem(p8) -- Line: 159
    -- upvalues: u2 (copy), CreateStockItem (copy)
    if table.find(u2, p8) then
        return CreateStockItem(p8);
    end;

    return nil;
end;

function u1.GenerateStockInventoryItems() -- Line: 169
    -- upvalues: u2 (copy), CreateStockItem (copy)
    local v9 = {};

    for _, v in ipairs(u2) do
        local v10 = CreateStockItem(v);
        table.insert(v9, v10);
    end;

    return v9;
end;

function u1.InjectStockItems(p11) -- Line: 181
    -- upvalues: u1 (copy)
    local v12 = u1.GenerateStockInventoryItems();
    local v13 = {};
    local v14 = {};

    for _, v in ipairs(p11) do
        v13[v._id] = true;

        if v.Skin == "Stock" then
            v14[v.Name] = true;
        end;
    end;

    for _, v in ipairs(v12) do
        if not (v13[v._id] or v14[v.Name]) then
            table.insert(p11, v);
        end;
    end;

    return p11;
end;

return u1;