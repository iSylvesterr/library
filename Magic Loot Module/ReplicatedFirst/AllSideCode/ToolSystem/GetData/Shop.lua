-- Decompiled with Potassium's decompiler.

local MarketplaceService = game:GetService("MarketplaceService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local MathMgr = UtilsSystem.MathMgr;
local PlayerData = UtilsSystem.PlayerData;
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local PlayerMirror = require(script.Parent.PlayerMirror);
local u1 = {};
local u2 = { "付费商店", "付费材料稀有度" };
u1.ROBUX_MATERIAL_OFFER_FOLDER = "RobuxMaterialOffer";
u1.BLOCK_BEFORE = "Before";
u1.BLOCK_BUY_LIMIT = "BuyLimit";
local GamePass = EnumMgr.RobuxType.GamePass;
local u3 = {};
local u4 = nil;
local u5 = nil;

local function _ensureGoodsIdMap() -- Line: 62
    -- upvalues: u4 (ref), CfgFind (copy)
    if u4 then
        return;
    end;

    u4 = {};
    local v6 = CfgFind.GetCfgByName("itemshopdataConf");

    if not v6 then
        return;
    end;

    for i, v in pairs(v6) do
        if v then
            local v = v.OnlyTag;
        end;

        if type(v) == "string" and v ~= "" then
            local v7 = tonumber(i);

            if v7 then
                u4[v] = v7;
            end;
        end;
    end;
end;

local function _ensureMaterialIdsByXyd() -- Line: 85
    -- upvalues: u5 (ref), CfgFind (copy), EnumMgr (copy)
    if u5 then
        return;
    end;

    u5 = {};
    local v8 = CfgFind.GetCfgByName("materialConf");

    if not v8 then
        return;
    end;

    local Material = EnumMgr.ItemType.Material;

    for i, v in pairs(v8) do
        local v9 = tonumber(i);

        if v9 and (v and tonumber(v.tp) == Material) then
            local v10 = tonumber(v.xyd) or 0;
            local v11 = math.floor(v10);

            if v11 > 0 then
                local v12 = u5[v11];

                if not v12 then
                    v12 = {};
                    u5[v11] = v12;
                end;

                table.insert(v12, v9);
            end;
        end;
    end;
end;

function u1.GetBuyLimitNum(p13) -- Line: 117
    if not p13 then
        return 0;
    end;

    local v14 = tonumber(p13.BuyLimitNum);

    return (not v14 or v14 <= 0) and 0 or math.floor(v14);
end;

function u1.FindGoodsIdByOnlyTag(p15) -- Line: 134
    -- upvalues: _ensureGoodsIdMap (copy), u4 (ref)
    if type(p15) ~= "string" or p15 == "" then
        return nil;
    end;

    _ensureGoodsIdMap();

    if u4 then
        return u4[p15];
    end;

    return nil;
end;

function u1.GetShopBuyCount(p16, p17) -- Line: 152
    -- upvalues: PlayerData (copy)
    if not p16 or (type(p17) ~= "string" or p17 == "") then
        return 0;
    end;

    local v18 = PlayerData.GetPlrDataByKey(p16, { "Shop", p17 });

    if type(v18) == "number" then
        local v19 = math.floor(v18);

        return math.max(0, v19);
    end;

    local v20 = type(v18) == "table" and tonumber(v18.count);

    if not v20 then
        return 0;
    end;

    local v21 = math.floor(v20);

    return math.max(0, v21);
end;

function u1.HasBoughtShopItem(p22, p23) -- Line: 176
    -- upvalues: PlayerMirror (copy), u1 (copy)
    if p22 and (type(p23) == "string" and p23 ~= "") then
        return PlayerMirror.IsHasPass(p22, p23) and true or u1.GetShopBuyCount(p22, p23) > 0;
    end;

    return false;
end;

function u1.GetShopBuyBlockReason(p24, p25) -- Line: 193
    -- upvalues: u1 (copy)
    if not (p24 and p25) then
        return u1.BLOCK_BUY_LIMIT;
    end;

    local Before = p25.Before;

    if type(Before) == "string" and (Before ~= "" and (Before ~= tostring(p25.OnlyTag or "") and not u1.HasBoughtShopItem(p24, Before))) then
        return u1.BLOCK_BEFORE;
    end;

    local v26 = u1.GetBuyLimitNum(p25);

    if v26 <= 0 then
        return nil;
    end;

    local v27 = tostring(p25.OnlyTag or "");

    if v27 == "" then
        return u1.BLOCK_BUY_LIMIT;
    end;

    if v26 <= u1.GetShopBuyCount(p24, v27) then
        return u1.BLOCK_BUY_LIMIT;
    end;

    return nil;
end;

function u1.CanBuyShopItem(p28, p29) -- Line: 229
    -- upvalues: u1 (copy)
    return u1.GetShopBuyBlockReason(p28, p29) == nil;
end;

function u1.IsRobuxMaterialPack(p30) -- Line: 239
    -- upvalues: u1 (copy)
    return u1.GetRobuxMaterialOfferXyd(p30) ~= nil;
end;

function u1.GetRobuxMaterialPackOnlyTags() -- Line: 248
    -- upvalues: SystemGameConfig (copy), u2 (copy)
    local v31 = SystemGameConfig.GetValue(u2);
    local v32 = {};

    if type(v31) ~= "table" then
        return v32;
    end;

    for i, _ in pairs(v31) do
        if type(i) == "string" and (i ~= "" and tonumber(v31[i])) then
            table.insert(v32, i);
        end;
    end;

    table.sort(v32);

    return v32;
end;

function u1.GetRobuxMaterialOfferXyd(p33) -- Line: 269
    -- upvalues: SystemGameConfig (copy), u2 (copy)
    if type(p33) ~= "string" or p33 == "" then
        return nil;
    end;

    local v34 = SystemGameConfig.GetValue(u2);

    if type(v34) ~= "table" then
        return nil;
    end;

    local v35 = tonumber(v34[p33]);

    if v35 and v35 > 0 then
        return math.floor(v35);
    end;

    return nil;
end;

function u1.RollRobuxMaterialId(p36) -- Line: 290
    -- upvalues: u1 (copy), _ensureMaterialIdsByXyd (copy), u5 (ref), MathMgr (copy)
    local v37 = u1.GetRobuxMaterialOfferXyd(p36);

    if not v37 then
        return nil;
    end;

    _ensureMaterialIdsByXyd();

    if not u5 then
        return nil;
    end;

    local v38 = u5[v37];

    if type(v38) ~= "table" or #v38 == 0 then
        return nil;
    end;

    local v39 = table.create(#v38, 1);

    return MathMgr.RollPoolItemByWeight(v38, v39);
end;

function u1.GetRobuxMaterialOfferId(p40, p41) -- Line: 314
    -- upvalues: u1 (copy)
    if not p40 or (type(p41) ~= "string" or p41 == "") then
        return nil;
    end;

    local v42 = p40:FindFirstChild(u1.ROBUX_MATERIAL_OFFER_FOLDER);

    if not (v42 and v42:IsA("Folder")) then
        return nil;
    end;

    local v43 = v42:FindFirstChild(p41);

    if not (v43 and v43:IsA("NumberValue")) then
        return nil;
    end;

    local v44 = tonumber(v43.Value) or 0;
    local v45 = math.floor(v44);

    if v45 <= 0 then
        return nil;
    end;

    return v45;
end;

local function _resolveShopCfg(p46) -- Line: 339
    -- upvalues: CfgFind (copy)
    if type(p46) == "table" then
        return p46;
    end;

    if type(p46) == "string" and p46 ~= "" then
        return CfgFind.FindCfgByOnlyTag(p46);
    end;

    return nil;
end;

local function _robuxPriceCacheKey(p47, p48) -- Line: 356
    return tostring(p48) .. ":" .. tostring(p47);
end;

function u1.GetCachedRobuxPrice(p49) -- Line: 366
    -- upvalues: CfgFind (copy), u3 (copy)
    if type(p49) ~= "table" then
        if type(p49) == "string" and p49 ~= "" then
            p49 = CfgFind.FindCfgByOnlyTag(p49);
        else
            p49 = nil;
        end;
    end;

    if not p49 then
        return nil;
    end;

    local v50 = tonumber(p49.passID);
    local v51 = tonumber(p49.cost);

    if v50 and v51 then
        return u3[tostring(v51) .. ":" .. tostring(v50)];
    end;

    return nil;
end;

function u1.FetchRobuxPrice(p52, u53) -- Line: 386
    -- upvalues: CfgFind (copy), u3 (copy), GamePass (copy), MarketplaceService (copy)
    if type(u53) ~= "function" then
        return;
    end;

    if type(p52) ~= "table" then
        if type(p52) == "string" and p52 ~= "" then
            p52 = CfgFind.FindCfgByOnlyTag(p52);
        else
            p52 = nil;
        end;
    end;

    if not p52 then
        task.defer(u53, nil);

        return;
    end;

    local u54 = tonumber(p52.passID);
    local u55 = tonumber(p52.cost);

    if not (u54 and u55) then
        task.defer(u53, nil);

        return;
    end;

    local u56 = tostring(u55) .. ":" .. tostring(u54);
    local v57 = u3[u56];

    if v57 then
        task.defer(u53, v57);

        return;
    end;

    task.spawn(function() -- Line: 409
        -- upvalues: u55 (copy), GamePass (ref), MarketplaceService (ref), u54 (copy), u3 (ref), u56 (copy), u53 (copy)
        local u58;

        if u55 == GamePass then
            u58 = Enum.InfoType.GamePass;
        else
            u58 = Enum.InfoType.Product;
        end;

        local success, result = pcall(function() -- Line: 413
            -- upvalues: MarketplaceService (ref), u54 (ref), u58 (copy)
            return MarketplaceService:GetProductInfo(u54, u58);
        end);
        local v59;

        if success and type(result) == "table" then
            v59 = tonumber(result.PriceInRobux);

            if v59 then
                u3[u56] = v59;
            end;
        else
            v59 = nil;
        end;

        u53(v59);
    end);
end;

return u1;