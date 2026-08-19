-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases);
local Buttons = require(ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.Buttons);
local u1 = {
    Forbidden = 7,
    Special = 6,
    Red = 5,
    Pink = 4,
    Purple = 3,
    Blue = 2,
    Stock = 1
};
local u2 = {
    ["Sticker Capsule"] = 14,
    ["Charm Capsule"] = 13,
    ["Music Kit"] = 8,
    Graffiti = 11,
    Grenade = 16,
    Sticker = 10,
    ["Zeus x27"] = 3,
    Charm = 9,
    Melee = 1,
    Glove = 2,
    Badge = 7,
    Case = 12,
    C4 = 15
};
local u3 = {
    Melee = 1,
    Glove = 2,
    Case = 3,
    ["Charm Capsule"] = 4,
    ["Sticker Capsule"] = 4
};
local u4 = {
    Miscellaneous = 18,
    Equipment = 17,
    Pistol = 3,
    Rifle = 6,
    Heavy = 5,
    SMG = 4
};
local u5 = {
    Pistols = 1,
    ["Mid Tier"] = 2,
    Rifles = 3
};
local u6 = {
    ["Equipped Melee"] = 1,
    ["Equipped Gloves"] = 2,
    ["Equipped Badge"] = 3,
    ["Equipped Music Kit"] = 4,
    ["Equipped Graffiti"] = 5,
    ["Equipped Zeus x27"] = 6
};

local function IsStockSkin(p7) -- Line: 98
    return (p7.Skin == "Stock" or p7.MetaData and p7.MetaData.Origin == "Stock") and true or false;
end;

local function IsBadge(p8) -- Line: 102
    return p8.Name == "Badge";
end;

local function IsCharm(p9) -- Line: 106
    return p9.Name == "Charm";
end;

local function GetItemIdentity(p10) -- Line: 110
    return p10.Type == "Case" and (p10.Skin or "") or (p10.Name or "") .. "|" .. (p10.Skin or "");
end;

local function GetCollectionNameForItem(p11, p12) -- Line: 119
    -- upvalues: Buttons (copy), Cases (copy), Skins (copy)
    if Buttons.IsCapsule(p11) then
        return "Capsules";
    end;

    if p11.Type ~= "Case" then
        if not (p11.Name and p11.Skin) then
            return nil;
        end;

        local v13 = Skins.GetSkinInformation(p11.Name, p11.Skin);

        return v13 and v13.collection or nil;
    end;

    if not p11.Skin then
        return nil;
    end;

    local v14 = Cases.GetCaseByName(p11.Skin);

    if not v14 then
        return nil;
    end;

    if p12 then
        p12 = p12();
    end;

    if not p12 then
        return nil;
    end;

    for _, v in ipairs(p12) do
        if v.cases then
            for _, v2 in ipairs(v.cases) do
                if v2 == v14.name then
                    return v.name;
                end;
            end;
        end;
    end;

    return nil;
end;

local function GetEquippedItemPriority(p15, p16) -- Line: 164
    -- upvalues: DataController (copy), u5 (copy), u6 (copy)
    local v17 = nil;
    local v18 = DataController.Get(p16, "Loadout");

    if not v18 then
        return nil;
    end;

    for _, v in ipairs({ "Counter-Terrorists", "Terrorists" }) do
        local v19 = v18[v];

        if v19 and v19.Loadout then
            for i, v2 in pairs(u5) do
                if v2 and (v19.Loadout[i] and v19.Loadout[i].Options) then
                    for i2, v3 in ipairs(v19.Loadout[i].Options) do
                        if v3 == p15 then
                            local v20 = v2 * 1000 + i2;

                            if not v17 or v20 < v17 then
                                v17 = v20;
                            end;
                        end;
                    end;
                end;
            end;

            if v19.Equipped then
                for i, v2 in pairs(v19.Equipped) do
                    if v2 == p15 then
                        local v21 = u6[i] or 99;

                        if not v17 or v21 < v17 then
                            v17 = v21;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return v17;
end;

local function GetCreatedAt(p22) -- Line: 208
    return p22.MetaData and p22.MetaData.CreatedAt or 0;
end;

local function GetNewestSortTimestamp(p23, p24) -- Line: 214
    local v25 = tonumber(p23.MetaData.LastTradeAt);
    local v26 = tonumber(p23.MetaData.CreatedAt);

    if v25 > 0 then
        v26 = v25 or v26;
    end;

    return v26;
end;

return {
    GetSortComparisonFunction = function(p27, u28, u29) -- Line: 230, Name: GetSortComparisonFunction
        -- upvalues: GetCollectionNameForItem (copy), Buttons (copy), u3 (copy), Skins (copy), u1 (copy), GetEquippedItemPriority (copy), u2 (copy), GetWeaponProperties (copy), u4 (copy)
        return p27 == "Alphabetical" and function(p30, p31) -- Line: 236
            local v32 = (p31.Skin == "Stock" or p31.MetaData and p31.MetaData.Origin == "Stock") and true or false;

            if ((p30.Skin == "Stock" or p30.MetaData and p30.MetaData.Origin == "Stock") and true or false) ~= v32 then
                return v32, true;
            end;

            local v33;

            if p30.Type == "Case" then
                v33 = p30.Skin or "";
            else
                v33 = (p30.Name or "") .. "|" .. (p30.Skin or "");
            end;

            local v34;

            if p31.Type == "Case" then
                v34 = p31.Skin or "";
            else
                v34 = (p31.Name or "") .. "|" .. (p31.Skin or "");
            end;

            if v33 ~= v34 then
                return v33 < v34;
            end;

            local v35 = p30.MetaData and (p30.MetaData.CreatedAt or 0) or 0;
            local v36 = p31.MetaData and (p31.MetaData.CreatedAt or 0) or 0;

            if v35 == v36 then
                return (p30._id or "") < (p31._id or "");
            end;

            return v36 < v35;
        end or (p27 == "Collection" and function(p37, p38) -- Line: 262
            -- upvalues: GetCollectionNameForItem (ref), u29 (copy), Buttons (ref), u3 (ref), Skins (ref), u1 (ref)
            local v39 = (p38.Skin == "Stock" or p38.MetaData and p38.MetaData.Origin == "Stock") and true or false;

            if ((p37.Skin == "Stock" or p37.MetaData and p37.MetaData.Origin == "Stock") and true or false) ~= v39 then
                return v39, true;
            end;

            local v40 = GetCollectionNameForItem(p37, u29) or "";
            local v41 = GetCollectionNameForItem(p38, u29) or "";

            if v40 ~= v41 then
                return v40 < v41;
            end;

            local v42 = Buttons.GetEffectiveItemType(p37);
            local v43 = Buttons.GetEffectiveItemType(p38);
            local v44 = u3[v42] or 4;
            local v45 = u3[v43] or 4;

            if v44 ~= v45 then
                return v44 < v45;
            end;

            local v46;

            if p37.Name and p37.Skin then
                v46 = Skins.GetSkinInformation(p37.Name, p37.Skin) or nil;
            else
                v46 = nil;
            end;

            local v47;

            if p38.Name and p38.Skin then
                v47 = Skins.GetSkinInformation(p38.Name, p38.Skin) or nil;
            else
                v47 = nil;
            end;

            local v48 = v46 and u1[v46.rarity] or 0;
            local v49 = v47 and u1[v47.rarity] or 0;

            if v48 ~= v49 then
                return v49 < v48;
            end;

            local v50;

            if p37.Type == "Case" then
                v50 = p37.Skin or "";
            else
                v50 = (p37.Name or "") .. "|" .. (p37.Skin or "");
            end;

            local v51;

            if p38.Type == "Case" then
                v51 = p38.Skin or "";
            else
                v51 = (p38.Name or "") .. "|" .. (p38.Skin or "");
            end;

            if v50 == v51 then
                return (p37.MetaData and p37.MetaData.CreatedAt or 0) > (p38.MetaData and p38.MetaData.CreatedAt or 0);
            end;

            return v50 < v51;
        end or (p27 == "Equipped" and function(p52, p53) -- Line: 313
            -- upvalues: GetEquippedItemPriority (ref), u28 (copy)
            local v54 = (p53.Skin == "Stock" or p53.MetaData and p53.MetaData.Origin == "Stock") and true or false;

            if ((p52.Skin == "Stock" or p52.MetaData and p52.MetaData.Origin == "Stock") and true or false) ~= v54 then
                return v54, true;
            end;

            local v55;

            if p52._id then
                v55 = GetEquippedItemPriority(p52._id, u28) or nil;
            else
                v55 = nil;
            end;

            local v56;

            if p53._id then
                v56 = GetEquippedItemPriority(p53._id, u28) or nil;
            else
                v56 = nil;
            end;

            if v55 ~= nil ~= (v56 ~= nil) then
                return v55 ~= nil;
            end;

            if not (v55 and v56) then
                local v57;

                if p52.Type == "Case" then
                    v57 = p52.Skin or "";
                else
                    v57 = (p52.Name or "") .. "|" .. (p52.Skin or "");
                end;

                local v58;

                if p53.Type == "Case" then
                    v58 = p53.Skin or "";
                else
                    v58 = (p53.Name or "") .. "|" .. (p53.Skin or "");
                end;

                if v57 == v58 then
                    return (p52.MetaData and p52.MetaData.CreatedAt or 0) > (p53.MetaData and p53.MetaData.CreatedAt or 0);
                end;

                return v57 < v58;
            end;

            if v55 ~= v56 then
                return v55 < v56;
            end;

            local v59;

            if p52.Type == "Case" then
                v59 = p52.Skin or "";
            else
                v59 = (p52.Name or "") .. "|" .. (p52.Skin or "");
            end;

            local v60;

            if p53.Type == "Case" then
                v60 = p53.Skin or "";
            else
                v60 = (p53.Name or "") .. "|" .. (p53.Skin or "");
            end;

            if v59 == v60 then
                return (p52.MetaData and p52.MetaData.CreatedAt or 0) > (p53.MetaData and p53.MetaData.CreatedAt or 0);
            end;

            return v59 < v60;
        end or (p27 == "Newest" and function(p61, p62) -- Line: 358
            -- upvalues: u28 (copy)
            local v63 = (p62.Skin == "Stock" or p62.MetaData and p62.MetaData.Origin == "Stock") and true or false;

            if ((p61.Skin == "Stock" or p61.MetaData and p61.MetaData.Origin == "Stock") and true or false) ~= v63 then
                return v63, true;
            end;

            local v64 = tonumber(p61.MetaData.LastTradeAt);
            local v65 = tonumber(p61.MetaData.CreatedAt);

            if v64 > 0 then
                v65 = v64 or v65;
            end;

            local v66 = tonumber(p62.MetaData.LastTradeAt);
            local v67 = tonumber(p62.MetaData.CreatedAt);

            if v66 > 0 then
                v67 = v66 or v67;
            end;

            if v65 ~= v67 then
                return v67 < v65;
            end;

            local v68;

            if p61.Type == "Case" then
                v68 = p61.Skin or "";
            else
                v68 = (p61.Name or "") .. "|" .. (p61.Skin or "");
            end;

            local v69;

            if p62.Type == "Case" then
                v69 = p62.Skin or "";
            else
                v69 = (p62.Name or "") .. "|" .. (p62.Skin or "");
            end;

            if v68 == v69 then
                return (p61._id or "") < (p62._id or "");
            end;

            return v68 < v69;
        end or (p27 == "Quality" and function(p70, p71) -- Line: 384
            -- upvalues: Skins (ref), u1 (ref)
            local v72 = (p71.Skin == "Stock" or p71.MetaData and p71.MetaData.Origin == "Stock") and true or false;

            if ((p70.Skin == "Stock" or p70.MetaData and p70.MetaData.Origin == "Stock") and true or false) ~= v72 then
                return v72, true;
            end;

            local v73;

            if p70.Name and p70.Skin then
                v73 = Skins.GetSkinInformation(p70.Name, p70.Skin) or nil;
            else
                v73 = nil;
            end;

            local v74;

            if p71.Name and p71.Skin then
                v74 = Skins.GetSkinInformation(p71.Name, p71.Skin) or nil;
            else
                v74 = nil;
            end;

            local v75 = v73 and u1[v73.rarity] or 0;
            local v76 = v74 and u1[v74.rarity] or 0;

            if v75 ~= v76 then
                return v76 < v75;
            end;

            local v77;

            if p70.Type == "Case" then
                v77 = p70.Skin or "";
            else
                v77 = (p70.Name or "") .. "|" .. (p70.Skin or "");
            end;

            local v78;

            if p71.Type == "Case" then
                v78 = p71.Skin or "";
            else
                v78 = (p71.Name or "") .. "|" .. (p71.Skin or "");
            end;

            if v77 == v78 then
                return (p70.MetaData and p70.MetaData.CreatedAt or 0) > (p71.MetaData and p71.MetaData.CreatedAt or 0);
            end;

            return v77 < v78;
        end or (p27 == "Type" and function(p79, p80) -- Line: 413
            -- upvalues: Buttons (ref), u2 (ref), GetWeaponProperties (ref), u4 (ref)
            local v81 = (p80.Skin == "Stock" or p80.MetaData and p80.MetaData.Origin == "Stock") and true or false;

            if ((p79.Skin == "Stock" or p79.MetaData and p79.MetaData.Origin == "Stock") and true or false) ~= v81 then
                return v81, true;
            end;

            local v82 = Buttons.GetEffectiveItemType(p79);
            local v83 = Buttons.GetEffectiveItemType(p80);
            local v84 = u2[v82];
            local v85;

            if v84 or v82 ~= "Weapon" then
                v85 = v84 or 99;
            elseif p79.Name then
                local success, result = pcall(GetWeaponProperties, p79.Name);
                v85 = success and (result and result.Type) and (u4[result.Type] or 99) or 99;
            else
                v85 = 99;
            end;

            local v86 = u2[v83];
            local v87;

            if v86 or v83 ~= "Weapon" then
                v87 = v86 or 99;
            elseif p80.Name then
                local success, result = pcall(GetWeaponProperties, p80.Name);
                v87 = success and (result and result.Type) and (u4[result.Type] or 99) or 99;
            else
                v87 = 99;
            end;

            if v85 ~= v87 then
                return v85 < v87;
            end;

            local v88;

            if p79.Type == "Case" then
                v88 = p79.Skin or "";
            else
                v88 = (p79.Name or "") .. "|" .. (p79.Skin or "");
            end;

            local v89;

            if p80.Type == "Case" then
                v89 = p80.Skin or "";
            else
                v89 = (p80.Name or "") .. "|" .. (p80.Skin or "");
            end;

            if v88 == v89 then
                return (p79.MetaData and p79.MetaData.CreatedAt or 0) > (p80.MetaData and p80.MetaData.CreatedAt or 0);
            end;

            return v88 < v89;
        end or (p27 == "Float" and function(p90, p91) -- Line: 479
            local v92 = (p91.Skin == "Stock" or p91.MetaData and p91.MetaData.Origin == "Stock") and true or false;

            if ((p90.Skin == "Stock" or p90.MetaData and p90.MetaData.Origin == "Stock") and true or false) ~= v92 then
                return v92, true;
            end;

            local v93 = p91.Name == "Badge";

            if p90.Name == "Badge" ~= v93 then
                return v93, true;
            end;

            local v94 = p91.Name == "Charm";

            if p90.Name == "Charm" ~= v94 then
                return v94, true;
            end;

            local Float = p90.Float;
            local Float2 = p91.Float;

            if Float ~= nil and Float2 ~= nil then
                if Float ~= Float2 then
                    return Float < Float2;
                end;

                local v95;

                if p90.Type == "Case" then
                    v95 = p90.Skin or "";
                else
                    v95 = (p90.Name or "") .. "|" .. (p90.Skin or "");
                end;

                local v96;

                if p91.Type == "Case" then
                    v96 = p91.Skin or "";
                else
                    v96 = (p91.Name or "") .. "|" .. (p91.Skin or "");
                end;

                if v95 == v96 then
                    return (p90.MetaData and p90.MetaData.CreatedAt or 0) > (p91.MetaData and p91.MetaData.CreatedAt or 0);
                end;

                return v95 < v96;
            end;

            if Float ~= nil then
                return true;
            end;

            if Float2 ~= nil then
                return false;
            end;

            local v97;

            if p90.Type == "Case" then
                v97 = p90.Skin or "";
            else
                v97 = (p90.Name or "") .. "|" .. (p90.Skin or "");
            end;

            local v98;

            if p91.Type == "Case" then
                v98 = p91.Skin or "";
            else
                v98 = (p91.Name or "") .. "|" .. (p91.Skin or "");
            end;

            if v97 == v98 then
                return (p90.MetaData and p90.MetaData.CreatedAt or 0) > (p91.MetaData and p91.MetaData.CreatedAt or 0);
            end;

            return v97 < v98;
        end or nil))))));
    end
};