-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local Log = UtilsSystem.Log;
local MathMgr = UtilsSystem.MathMgr;
local ResourceUtil = UtilsSystem.ResourceUtil;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIMgr = UtilsSystem.UIMgr;
local ItemType = UtilsSystem.EnumMgr.ItemType;
local v1 = { "HeldPotion", "HeldMaterial" };
local v2 = UtilsSystem.AssetRegistry.BuildCatalogPath("BillBoard", "Drop");
local u3 = ResourceUtil.GetTemplate(v2);

if not u3 then
    Log.warn("[HeldItemInfo] 缺少 Assets.BillBoard.Drop，路径:", v2);
end;

local u4 = {};
local u5 = {};

local function _disconnectAttrListen(p6) -- Line: 57
    -- upvalues: u5 (copy)
    local v7 = u5[p6];

    if v7 then
        for _, v in ipairs(v7) do
            v:Disconnect();
        end;

        u5[p6] = nil;
    end;

    return nil;
end;

local function _resolveHeldCfgId(p8) -- Line: 74
    local v9 = tonumber(p8:GetAttribute("PotionID"));

    if v9 and v9 > 0 then
        return v9;
    end;

    local v10 = tonumber(p8:GetAttribute("ItemID"));

    if v10 and v10 > 0 then
        return v10;
    end;

    return nil;
end;

local function _resolveHeldItemType(p11) -- Line: 92
    -- upvalues: ItemType (copy), CollectionService (copy)
    local v12 = p11:GetAttribute("ItemType");

    if v12 == "Potion" then
        return ItemType.Potion;
    end;

    if v12 == "Material" then
        return ItemType.Material;
    end;

    local PrimaryPart = p11.PrimaryPart;

    if PrimaryPart then
        if CollectionService:HasTag(PrimaryPart, "HeldPotion") then
            return ItemType.Potion;
        end;

        if CollectionService:HasTag(PrimaryPart, "HeldMaterial") then
            return ItemType.Material;
        end;
    end;

    return nil;
end;

local function _resolveHeldGoldValue(p13, p14) -- Line: 119
    -- upvalues: _resolveHeldItemType (copy), ItemType (copy)
    local v15 = tonumber(p13:GetAttribute("HeldItemGoldValue"));

    if v15 ~= nil then
        local v16 = math.floor(v15);

        return math.max(0, v16);
    end;

    local v17 = _resolveHeldItemType(p13);

    if v17 == ItemType.Material then
        local v18 = tonumber(p14.GoldValue) or 0;
        local v19 = math.floor(v18);

        return math.max(0, v19);
    end;

    if v17 ~= ItemType.Potion then
        return 0;
    end;

    local v20 = tonumber(p14.Price) or 0;
    local v21 = math.floor(v20);

    return math.max(0, v21);
end;

local function _applyHeldBillboard(p22, p23, p24) -- Line: 143
    -- upvalues: TranslationHelper (copy), UIMgr (copy), _resolveHeldItemType (copy), ItemType (copy), _resolveHeldGoldValue (copy), MathMgr (copy)
    local ZhName = p22:FindFirstChild("ZhName");

    if ZhName and ZhName:IsA("TextLabel") then
        TranslationHelper.SetText(ZhName, p24.ZhName);
    end;

    local v25 = tonumber(p23:GetAttribute("HeldItemXyd")) or tonumber(p23:GetAttribute("HeldPotionXyd")) or (tonumber(p24.xyd) or 1);
    local XYD = p22:FindFirstChild("XYD");

    if XYD and XYD:IsA("TextLabel") then
        UIMgr.setXydLabel(XYD, math.floor(v25), false);
    end;

    local v26 = _resolveHeldItemType(p23);
    local Cost = p22:FindFirstChild("Cost");

    if Cost and Cost:IsA("TextLabel") then
        if v26 == ItemType.Potion then
            Cost.Visible = false;
        else
            Cost.Visible = true;
            local v27 = _resolveHeldGoldValue(p23, p24);
            TranslationHelper.SetText_UnTrans(Cost, "$" .. MathMgr.getNumStr(v27));
        end;
    end;

    local Price = p22:FindFirstChild("Price");

    if Price and Price:IsA("GuiObject") then
        Price.Visible = v26 ~= ItemType.Potion;
    end;

    return nil;
end;

local function _destroyHeldBillboard(p28) -- Line: 183
    -- upvalues: u4 (copy)
    local v29 = u4[p28];

    if v29 then
        if v29.Parent then
            v29:Destroy();
        end;

        u4[p28] = nil;
    end;

    return nil;
end;

local function _mountHeldBillboard(u30, u31) -- Line: 201
    -- upvalues: u4 (copy), u3 (copy), _resolveHeldItemType (copy), CfgFind (copy), _applyHeldBillboard (copy), u5 (copy)
    if u4[u30] then
        return nil;
    end;

    if not u3 then
        return nil;
    end;

    local v32 = tonumber(u31:GetAttribute("PotionID"));

    if not v32 or v32 <= 0 then
        v32 = tonumber(u31:GetAttribute("ItemID"));

        if not v32 or v32 <= 0 then
            v32 = nil;
        end;
    end;

    if not v32 then
        return nil;
    end;

    local v33 = _resolveHeldItemType(u31);

    if not v33 then
        return nil;
    end;

    local v34 = CfgFind.FindCfgByID(v32, v33);

    if not v34 then
        return nil;
    end;

    local v35 = u3:Clone();
    v35.Name = "Drop";
    v35.Parent = u30;
    _applyHeldBillboard(v35, u31, v34);
    u4[u30] = v35;
    u31.AncestryChanged:Connect(function() -- Line: 231
        -- upvalues: u31 (copy), u30 (copy), u5 (ref), u4 (ref)
        if not u31.Parent then
            local v36 = u30;
            local v37 = u5[v36];

            if v37 then
                for _, v in ipairs(v37) do
                    v:Disconnect();
                end;

                u5[v36] = nil;
            end;

            local v38 = u30;
            local v39 = u4[v38];

            if v39 then
                if v39.Parent then
                    v39:Destroy();
                end;

                u4[v38] = nil;
            end;
        end;
    end);

    return nil;
end;

local function _tryMountHeldBillboard(p40, p41) -- Line: 247
    -- upvalues: u5 (copy), u4 (copy), _mountHeldBillboard (copy)
    local v42 = tonumber(p41:GetAttribute("PotionID"));

    if not v42 or v42 <= 0 then
        v42 = tonumber(p41:GetAttribute("ItemID"));

        if not v42 or v42 <= 0 then
            v42 = nil;
        end;
    end;

    if v42 then
        local v43 = u5[p40];

        if v43 then
            for _, v in ipairs(v43) do
                v:Disconnect();
            end;

            u5[p40] = nil;
        end;

        local v44 = u4[p40];

        if v44 then
            if v44.Parent then
                v44:Destroy();
            end;

            u4[p40] = nil;
        end;

        _mountHeldBillboard(p40, p41);
    end;

    return nil;
end;

local function _bindHeldDisplayAttrs(u45, u46) -- Line: 263
    -- upvalues: u5 (copy), u4 (copy), _mountHeldBillboard (copy)
    local v47 = tonumber(u46:GetAttribute("PotionID"));

    if not v47 or v47 <= 0 then
        v47 = tonumber(u46:GetAttribute("ItemID"));

        if not v47 or v47 <= 0 then
            v47 = nil;
        end;
    end;

    if v47 then
        local v48 = u5[u45];

        if v48 then
            for _, v in ipairs(v48) do
                v:Disconnect();
            end;

            u5[u45] = nil;
        end;

        local v49 = u4[u45];

        if v49 then
            if v49.Parent then
                v49:Destroy();
            end;

            u4[u45] = nil;
        end;

        _mountHeldBillboard(u45, u46);
    end;

    if u4[u45] then
        return nil;
    end;

    if u5[u45] then
        return nil;
    end;

    local v81 = {
        [#v81 + 1] = u46:GetAttributeChangedSignal("ItemID"):Connect(function() -- Line: 273
            -- upvalues: u45 (copy), u46 (copy), u5 (ref), u4 (ref), _mountHeldBillboard (ref)
            local v50 = u45;
            local v51 = u46;
            local v52 = tonumber(v51:GetAttribute("PotionID"));

            if not v52 or v52 <= 0 then
                v52 = tonumber(v51:GetAttribute("ItemID"));

                if not v52 or v52 <= 0 then
                    v52 = nil;
                end;
            end;

            if v52 then
                local v53 = u5[v50];

                if v53 then
                    for _, v in ipairs(v53) do
                        v:Disconnect();
                    end;

                    u5[v50] = nil;
                end;

                local v54 = u4[v50];

                if v54 then
                    if v54.Parent then
                        v54:Destroy();
                    end;

                    u4[v50] = nil;
                end;

                _mountHeldBillboard(v50, v51);
            end;
        end),
        [#v81 + 1] = u46:GetAttributeChangedSignal("PotionID"):Connect(function() -- Line: 276
            -- upvalues: u45 (copy), u46 (copy), u5 (ref), u4 (ref), _mountHeldBillboard (ref)
            local v55 = u45;
            local v56 = u46;
            local v57 = tonumber(v56:GetAttribute("PotionID"));

            if not v57 or v57 <= 0 then
                v57 = tonumber(v56:GetAttribute("ItemID"));

                if not v57 or v57 <= 0 then
                    v57 = nil;
                end;
            end;

            if v57 then
                local v58 = u5[v55];

                if v58 then
                    for _, v in ipairs(v58) do
                        v:Disconnect();
                    end;

                    u5[v55] = nil;
                end;

                local v59 = u4[v55];

                if v59 then
                    if v59.Parent then
                        v59:Destroy();
                    end;

                    u4[v55] = nil;
                end;

                _mountHeldBillboard(v55, v56);
            end;
        end),
        [#v81 + 1] = u46:GetAttributeChangedSignal("HeldItemXyd"):Connect(function() -- Line: 279
            -- upvalues: u45 (copy), u4 (ref), u46 (copy), u5 (ref), _mountHeldBillboard (ref)
            local v60 = u45;
            local v61 = u4[v60];

            if v61 then
                if v61.Parent then
                    v61:Destroy();
                end;

                u4[v60] = nil;
            end;

            local v62 = u45;
            local v63 = u46;
            local v64 = tonumber(v63:GetAttribute("PotionID"));

            if not v64 or v64 <= 0 then
                v64 = tonumber(v63:GetAttribute("ItemID"));

                if not v64 or v64 <= 0 then
                    v64 = nil;
                end;
            end;

            if v64 then
                local v65 = u5[v62];

                if v65 then
                    for _, v in ipairs(v65) do
                        v:Disconnect();
                    end;

                    u5[v62] = nil;
                end;

                local v66 = u4[v62];

                if v66 then
                    if v66.Parent then
                        v66:Destroy();
                    end;

                    u4[v62] = nil;
                end;

                _mountHeldBillboard(v62, v63);
            end;
        end),
        [#v81 + 1] = u46:GetAttributeChangedSignal("HeldPotionXyd"):Connect(function() -- Line: 283
            -- upvalues: u45 (copy), u4 (ref), u46 (copy), u5 (ref), _mountHeldBillboard (ref)
            local v67 = u45;
            local v68 = u4[v67];

            if v68 then
                if v68.Parent then
                    v68:Destroy();
                end;

                u4[v67] = nil;
            end;

            local v69 = u45;
            local v70 = u46;
            local v71 = tonumber(v70:GetAttribute("PotionID"));

            if not v71 or v71 <= 0 then
                v71 = tonumber(v70:GetAttribute("ItemID"));

                if not v71 or v71 <= 0 then
                    v71 = nil;
                end;
            end;

            if v71 then
                local v72 = u5[v69];

                if v72 then
                    for _, v in ipairs(v72) do
                        v:Disconnect();
                    end;

                    u5[v69] = nil;
                end;

                local v73 = u4[v69];

                if v73 then
                    if v73.Parent then
                        v73:Destroy();
                    end;

                    u4[v69] = nil;
                end;

                _mountHeldBillboard(v69, v70);
            end;
        end),
        [#v81 + 1] = u46:GetAttributeChangedSignal("HeldItemGoldValue"):Connect(function() -- Line: 287
            -- upvalues: u45 (copy), u4 (ref), u46 (copy), u5 (ref), _mountHeldBillboard (ref)
            local v74 = u45;
            local v75 = u4[v74];

            if v75 then
                if v75.Parent then
                    v75:Destroy();
                end;

                u4[v74] = nil;
            end;

            local v76 = u45;
            local v77 = u46;
            local v78 = tonumber(v77:GetAttribute("PotionID"));

            if not v78 or v78 <= 0 then
                v78 = tonumber(v77:GetAttribute("ItemID"));

                if not v78 or v78 <= 0 then
                    v78 = nil;
                end;
            end;

            if v78 then
                local v79 = u5[v76];

                if v79 then
                    for _, v in ipairs(v79) do
                        v:Disconnect();
                    end;

                    u5[v76] = nil;
                end;

                local v80 = u4[v76];

                if v80 then
                    if v80.Parent then
                        v80:Destroy();
                    end;

                    u4[v76] = nil;
                end;

                _mountHeldBillboard(v76, v77);
            end;
        end)
    };
    u5[u45] = v81;

    return nil;
end;

local function _onHeldTagAdded(p82) -- Line: 301
    -- upvalues: u4 (copy), _bindHeldDisplayAttrs (copy)
    if u4[p82] then
        return nil;
    end;

    local Parent = p82.Parent;

    if not (Parent and Parent:IsA("Model")) then
        return nil;
    end;

    _bindHeldDisplayAttrs(p82, Parent);

    return nil;
end;

local function _onHeldTagRemoved(p83) -- Line: 321
    -- upvalues: u5 (copy), u4 (copy)
    local v84 = u5[p83];

    if v84 then
        for _, v in ipairs(v84) do
            v:Disconnect();
        end;

        u5[p83] = nil;
    end;

    local v85 = u4[p83];

    if v85 then
        if v85.Parent then
            v85:Destroy();
        end;

        u4[p83] = nil;
    end;

    return nil;
end;

for _, v in ipairs(v1) do
    for _, v3 in ipairs(CollectionService:GetTagged(v)) do
        if v3:IsA("BasePart") then
            if not u4[v3] then
                local Parent = v3.Parent;

                if Parent then
                    if Parent:IsA("Model") then
                        _bindHeldDisplayAttrs(v3, Parent);
                    end;
                end;
            end;
        end;
    end;

    CollectionService:GetInstanceAddedSignal(v):Connect(function(p86) -- Line: 334
        -- upvalues: u4 (copy), _bindHeldDisplayAttrs (copy)
        if p86:IsA("BasePart") then
            if u4[p86] then
                return;
            end;

            local Parent = p86.Parent;

            if Parent then
                if not Parent:IsA("Model") then
                    return;
                end;

                _bindHeldDisplayAttrs(p86, Parent);
            end;
        end;
    end);
    CollectionService:GetInstanceRemovedSignal(v):Connect(function(p87) -- Line: 340
        -- upvalues: u5 (copy), u4 (copy)
        if p87:IsA("BasePart") then
            local v88 = u5[p87];

            if v88 then
                for _, v3 in ipairs(v88) do
                    v3:Disconnect();
                end;

                u5[p87] = nil;
            end;

            local v89 = u4[p87];

            if v89 then
                if v89.Parent then
                    v89:Destroy();
                end;

                u4[p87] = nil;
            end;
        end;
    end);
end;