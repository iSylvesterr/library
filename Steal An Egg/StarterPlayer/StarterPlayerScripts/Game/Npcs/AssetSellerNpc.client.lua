-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Players = game:GetService("Players");
local Audio = require(ReplicatedStorage.Library.Audio);
local Save = require(ReplicatedStorage.Library.Client.Save);
local Message = require(ReplicatedStorage.Library.Client.Message);
local AssetItemSerialization = require(ReplicatedStorage.Library.Util.AssetItemSerialization);
local EggItemUtil = require(ReplicatedStorage.Library.Util.EggItemUtil);
local wcall = require(ReplicatedStorage.Library.Functions.wcall);
local GetPriceValueForItem = require(ReplicatedStorage.Library.Util.GetPriceValueForItem);
local Assets = require(ReplicatedStorage.Directory.Assets);
local Network = require(ReplicatedStorage.Library.Client.Network);
require(ReplicatedStorage.Library.Types.AssetItem);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Streamable = require(ReplicatedStorage.Library.Modules.Packages.Streamable).Streamable;
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local u1 = Color3.fromRGB(0, 255, 8):ToHex();
local u2 = Color3.fromRGB(255, 170, 0):ToHex();
local u3 = Color3.fromRGB(207, 58, 255):ToHex();
local AssetInventory = Network.NET_MAP.AssetInventory;
local Stands = Workspace.Stands;
local v4 = Stands:IsA("Folder");
assert(v4, "Workspace.Stands must be a Folder");
local Prompts = Stands.Prompts;
local v5 = Prompts:IsA("Folder");
assert(v5, "Workspace.Stands.Prompts must be a Folder");
local LocalPlayer = Players.LocalPlayer;
local u6 = Log.new();

local function getInventoryItemData(p7) -- Line: 59
    -- upvalues: Save (copy), wcall (copy), AssetItemSerialization (copy), u6 (copy)
    local v8 = Save.Get();

    if v8 then
        v8 = v8.Inventory;
    end;

    if not v8 then
        return nil;
    end;

    local v9 = v8[p7];

    if not v9 then
        return nil;
    end;

    local v10, v11 = wcall(AssetItemSerialization.Deserialize, v9);

    if v10 then
        return v11;
    end;

    u6:AtDebug():Log((`Skipped invalid seller inventory item {p7}`));

    return nil;
end;

local function isEquipped(p12) -- Line: 80
    -- upvalues: Save (copy)
    local v13 = Save.Get();
    local v14;

    if v13 == nil then
        v14 = false;
    else
        v14 = table.find(v13.EquippedAssets, p12) ~= nil;
    end;

    return v14;
end;

local function computeItemValue(p15) -- Line: 85
    -- upvalues: GetPriceValueForItem (copy), LocalPlayer (copy)
    local v16 = GetPriceValueForItem(p15);

    if LocalPlayer:GetAttribute("VIP") then
        v16 = v16 * 2;
    end;

    return v16;
end;

local function getEggItemData(p17) -- Line: 95
    -- upvalues: Save (copy), EggItemUtil (copy)
    local v18 = Save.Get();

    if v18 then
        v18 = v18.EggInventory;
    end;

    if v18 == nil then
        return nil, nil, nil;
    end;

    local v19 = v18[p17];

    if v19 == nil or v19.Placement ~= nil then
        return nil, nil, nil;
    end;

    local v20 = EggItemUtil.DeserializeSavedEgg(v19);

    return EggItemUtil.BuildAssetItemData(v20), EggItemUtil.GetSellPrice(v20), EggItemUtil.GetDisplayNameWithWeight(v20);
end;

local function formatPrice(p21) -- Line: 113
    -- upvalues: u1 (copy), Simple (copy)
    return string.format("<font color=\'#%s\'>$%s</font>", u1, Simple.FormatCompact(p21, "."));
end;

local function promptSellHeld() -- Line: 117
    -- upvalues: LocalPlayer (copy), Message (copy), getEggItemData (copy), getInventoryItemData (copy), Save (copy), Assets (copy), GetPriceValueForItem (copy), u3 (copy), formatPrice (copy), Network (copy), AssetInventory (copy), Audio (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        Message.New("No item equipped.");

        return;
    end;

    local v22 = Character:FindFirstChildWhichIsA("Tool");
    local v23;

    if v22 then
        v23 = v22:GetAttribute("UID");
    else
        v23 = nil;
    end;

    if v22 == nil or type(v23) ~= "string" then
        Message.New("No item equipped.");

        return;
    end;

    local v24 = nil;
    local v25 = v22:GetAttribute("ItemType");

    if v25 == "AssetEgg" then
        local v26, v27, v28 = getEggItemData(v23);
        v24 = v26 ~= nil and (v27 ~= nil and v28 ~= nil) and {
            isFavorite = false,
            kind = "egg",
            displayName = v28,
            itemData = v26,
            price = v27,
            uid = v23
        } or v24;
    elseif v25 == "Asset" then
        local v29 = getInventoryItemData(v23);

        if v29 ~= nil then
            local v30 = Save.Get();
            local v31;

            if v30 == nil then
                v31 = false;
            else
                v31 = table.find(v30.EquippedAssets, v23) ~= nil;
            end;

            if not (v31 or v29.InFuse) then
                v24 = {
                    kind = "pet",
                    displayName = Assets.Directory[v29.Category].DisplayName or v29.Category,
                    isFavorite = v29.IsFavorite == true,
                    itemData = v29
                };
                local v32 = GetPriceValueForItem(v29);

                if LocalPlayer:GetAttribute("VIP") then
                    v32 = v32 * 2;
                end;

                v24.price = v32;
                v24.uid = v23;
            end;
        end;
    end;

    if v24 == nil then
        Message.New("No item equipped.");

        return;
    end;

    if v24.isFavorite then
        local v33 = string.format("<font color=\'#%s\'>favorited</font>", u3);
        Message.New(string.format("You can\'t sell %s items.", v33));

        return;
    end;

    local v34 = Assets.Directory[v24.itemData.Category].Rarity.Color:ToHex();
    local v35 = string.format("Would you like to sell %s <font color=\'#%s\'>%s</font> for %s?", v24.kind, v34, v24.displayName, formatPrice(v24.price));

    if Message.New(v35, true) then
        Network.Fire(AssetInventory.SELL_ASSET, { v24.uid });
        Audio.PlayQuestion();
    end;
end;

local function getSellableInventory() -- Line: 189
    -- upvalues: Save (copy), wcall (copy), AssetItemSerialization (copy)
    local v36 = {};
    local v37 = Save.Get();

    if v37 then
        v37 = v37.Inventory;
    end;

    if not v37 then
        return v36;
    end;

    for i, v in pairs(v37) do
        local v38, v39 = wcall(AssetItemSerialization.Deserialize, v);

        if v38 and v39.IsFavorite ~= true then
            local v40 = Save.Get();
            local v41;

            if v40 == nil then
                v41 = false;
            else
                v41 = table.find(v40.EquippedAssets, i) ~= nil;
            end;

            if not (v41 or v39.InFuse) then
                table.insert(v36, {
                    uid = i,
                    itemData = v39
                });
            end;
        end;
    end;

    return v36;
end;

local function promptSellAll() -- Line: 207
    -- upvalues: getSellableInventory (copy), Message (copy), GetPriceValueForItem (copy), LocalPlayer (copy), u2 (copy), formatPrice (copy), Network (copy), AssetInventory (copy), Audio (copy)
    local v42 = getSellableInventory();

    if #v42 == 0 then
        Message.New("You don\'t have any pets in your inventory.");

        return;
    end;

    local v43 = 0;
    local v44 = {};

    for _, v in ipairs(v42) do
        local v45 = GetPriceValueForItem(v.itemData);

        if LocalPlayer:GetAttribute("VIP") then
            v45 = v45 * 2;
        end;

        v43 = v43 + v45;
        table.insert(v44, v.uid);
    end;

    local v46 = string.format("Would you like to sell <font color=\'#%s\'>%d pets</font> for %s?", u2, #v42, formatPrice(v43));

    if Message.New(v46, true) then
        Network.Fire(AssetInventory.SELL_ALL_ASSETS, v44);
        Audio.PlayQuestion();
    end;
end;

local function bindPrompt(p47, u48) -- Line: 235
    -- upvalues: Streamable (copy), Prompts (copy)
    Streamable.new(Prompts, p47):Observe(function(p49, p50) -- Line: 237
        -- upvalues: Streamable (ref), u48 (copy)
        local u51 = Streamable.new(p49, "ProximityPrompt");
        p50:Add(function() -- Line: 239
            -- upvalues: u51 (copy)
            u51:Destroy();
        end);
        p50:Add(u51:Observe(function(p52, p53) -- Line: 242
            -- upvalues: u48 (ref)
            p53:Connect(p52.Triggered, u48);
        end));
    end);
end;

Streamable.new(Prompts, "SellHeldAsset"):Observe(function(p54, p55) -- Line: 237
    -- upvalues: Streamable (copy), promptSellHeld (copy)
    local u56 = Streamable.new(p54, "ProximityPrompt");
    p55:Add(function() -- Line: 239
        -- upvalues: u56 (copy)
        u56:Destroy();
    end);
    p55:Add(u56:Observe(function(p57, p58) -- Line: 242
        -- upvalues: promptSellHeld (ref)
        p58:Connect(p57.Triggered, promptSellHeld);
    end));
end);
Streamable.new(Prompts, "SellAll"):Observe(function(p59, p60) -- Line: 237
    -- upvalues: Streamable (copy), promptSellAll (copy)
    local u61 = Streamable.new(p59, "ProximityPrompt");
    p60:Add(function() -- Line: 239
        -- upvalues: u61 (copy)
        u61:Destroy();
    end);
    p60:Add(u61:Observe(function(p62, p63) -- Line: 242
        -- upvalues: promptSellAll (ref)
        p63:Connect(p62.Triggered, promptSellAll);
    end));
end);