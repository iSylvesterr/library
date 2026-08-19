-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local CollectionService = UtilsSystem.CollectionService;
local EnumMgr = UtilsSystem.EnumMgr;
local MathMgr = UtilsSystem.MathMgr;
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local PlayerAttr = require(script.Parent.PlayerAttr);
local PlayerMirror = require(script.Parent.PlayerMirror);
local Bag = require(script.Parent.Bag);
local Shop = require(script.Parent.Shop);
local u1 = {};
local u2 = { "Root", "Zone", "TrainZone" };

local function _parseTrainIdFromModelName(p3) -- Line: 63
    local v4 = string.match(p3, "^训练场(%d+)$");

    if not v4 then
        return nil;
    end;

    local v5 = tonumber(v4);

    if v5 and v5 > 0 then
        return math.floor(v5);
    end;

    return nil;
end;

local function _getTrainGroundContainer(p6) -- Line: 81
    if p6:IsA("Model") then
        return p6;
    end;

    local Parent = p6.Parent;

    if Parent and Parent:IsA("Model") then
        return Parent;
    end;

    return p6;
end;

local function _resolveTaggedTrain(p7) -- Line: 99
    -- upvalues: u1 (copy)
    local v8 = u1.GetTrainIdFromInstance(p7);

    if not v8 then
        return nil, nil;
    end;

    if not p7:IsA("BasePart") then
        p7 = u1.ResolveZonePart(p7);
    end;

    if p7 then
        return p7, v8;
    end;

    return nil, nil;
end;

local function _resolveFromTrainModel(p9) -- Line: 118
    -- upvalues: CollectionService (copy), _resolveTaggedTrain (copy), u2 (copy)
    if CollectionService:HasTag(p9, "Train") then
        return _resolveTaggedTrain(p9);
    end;

    for _, v in u2 do
        local v10 = p9:FindFirstChild(v);

        if v10 and (v10:IsA("BasePart") and CollectionService:HasTag(v10, "Train")) then
            return _resolveTaggedTrain(v10);
        end;
    end;

    return nil, nil;
end;

function u1.GetTrainIdFromInstance(p11) -- Line: 146
    -- upvalues: CollectionService (copy)
    if not p11 then
        return nil;
    end;

    local v12 = p11;
    local v13 = nil;

    while true do
        if not p11 or p11 == workspace then
            p11 = v13;
            break;
        end;

        if CollectionService:HasTag(p11, "Train") then
            break;
        end;

        p11 = p11.Parent;
    end;

    if p11 then
        v12 = p11;
    elseif not CollectionService:HasTag(v12, "Train") then
        v12 = p11;
    end;

    if not v12 then
        return nil;
    end;

    local v14 = tonumber(v12:GetAttribute("TrainId"));

    if v14 and v14 > 0 then
        return math.floor(v14);
    end;

    local v15;

    if v12:IsA("Model") then
        v15 = v12;
    else
        v15 = v12.Parent;

        if v15 then
            if not v15:IsA("Model") then
                v15 = v12;
            end;
        else
            v15 = v12;
        end;
    end;

    if v15:IsA("Model") then
        local v16 = string.match(v15.Name, "^训练场(%d+)$");
        local v17;

        if v16 then
            local v18 = tonumber(v16);

            if v18 and v18 > 0 then
                v17 = math.floor(v18);
            else
                v17 = nil;
            end;
        else
            v17 = nil;
        end;

        if v17 then
            return v17;
        end;
    end;

    local Parent = v12.Parent;

    while Parent and Parent ~= workspace do
        if Parent:IsA("Model") then
            local v19 = string.match(Parent.Name, "^训练场(%d+)$");
            local v20;

            if v19 then
                local v21 = tonumber(v19);

                if v21 and v21 > 0 then
                    v20 = math.floor(v21);
                else
                    v20 = nil;
                end;
            else
                v20 = nil;
            end;

            if v20 then
                return v20;
            end;
        end;

        Parent = Parent.Parent;
    end;

    return nil;
end;

function u1.ResolveZonePart(p22) -- Line: 200
    -- upvalues: u2 (copy)
    if p22:IsA("BasePart") then
        return p22;
    end;

    if not p22:IsA("Model") then
        return nil;
    end;

    for _, v in u2 do
        local v23 = p22:FindFirstChild(v);

        if v23 and v23:IsA("BasePart") then
            return v23;
        end;
    end;

    if p22.PrimaryPart and p22.PrimaryPart:IsA("BasePart") then
        return p22.PrimaryPart;
    end;

    local v24 = p22:FindFirstChildWhichIsA("BasePart", true);

    if v24 and v24:IsA("BasePart") then
        return v24;
    end;

    return nil;
end;

function u1.ResolveTrainFromTouch(p25) -- Line: 230
    -- upvalues: CollectionService (copy), _resolveTaggedTrain (copy), _resolveFromTrainModel (copy)
    if not (p25 and p25:IsA("BasePart")) then
        return nil, nil;
    end;

    local v26 = p25;

    while p25 and p25 ~= workspace do
        if CollectionService:HasTag(p25, "Train") then
            return _resolveTaggedTrain(p25);
        end;

        p25 = p25.Parent;
    end;

    local v27 = v26:FindFirstAncestorWhichIsA("Model");

    if v27 then
        return _resolveFromTrainModel(v27);
    end;

    return nil, nil;
end;

function u1.FindZonePartByTrainId(p28) -- Line: 254
    -- upvalues: CollectionService (copy), u1 (copy)
    local v29 = tonumber(p28) or 0;
    local v30 = math.floor(v29);

    if v30 <= 0 then
        return nil;
    end;

    for _, v in CollectionService:GetTagged("Train") do
        if u1.GetTrainIdFromInstance(v) == v30 then
            return u1.ResolveZonePart(v);
        end;
    end;

    return nil;
end;

function u1.IsWorldPointInZonePart(p31, p32, p33) -- Line: 276
    if not p31 or (not p31:IsA("BasePart") or typeof(p32) ~= "Vector3") then
        return false;
    end;

    local v34 = p31.CFrame:PointToObjectSpace(p32);
    local v35 = p31.Size * 0.5;
    local v36 = tonumber(p33) or 0;
    local v37 = v36 < 0 and 0 or v36;
    local v38;

    if math.abs(v34.X) <= v35.X + v37 and math.abs(v34.Y) <= v35.Y + v37 then
        v38 = math.abs(v34.Z) <= v35.Z + v37;
    else
        v38 = false;
    end;

    return v38;
end;

function u1.IsPlayerInTrainZone(p39, p40, p41) -- Line: 299
    -- upvalues: u1 (copy)
    if not (p39 and p39:IsA("Player")) then
        return false;
    end;

    local Character = p39.Character;

    if not Character then
        return false;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return false;
    end;

    local v42 = u1.FindZonePartByTrainId(p40);

    if v42 then
        return u1.IsWorldPointInZonePart(v42, HumanoidRootPart.Position, p41);
    end;

    return false;
end;

function u1.GetTrainPayMul(p43) -- Line: 327
    -- upvalues: u1 (copy), Shop (copy)
    if not (p43 and p43:IsA("Player")) then
        return 1;
    end;

    local v44 = u1.GetTrainValue("训练提升通行证");

    if type(v44) ~= "table" then
        return 1;
    end;

    local v45 = 1;

    for i, v in pairs(v44) do
        if type(i) == "string" and i ~= "" then
            local v46 = tonumber(v);

            if v46 and (v45 < v46 and Shop.HasBoughtShopItem(p43, i)) then
                v45 = v46;
            end;
        end;
    end;

    return v45;
end;

function u1.CalcPaidPowerGrant(p47, p48) -- Line: 358
    -- upvalues: u1 (copy), PlayerAttr (copy)
    if not p47 or (not p47:IsA("Player") or (type(p48) ~= "string" or p48 == "")) then
        return nil;
    end;

    local v49 = u1.GetTrainValue("付费力量包");

    if type(v49) ~= "table" then
        return nil;
    end;

    local v50 = tonumber(v49[p48]);

    if not v50 or v50 <= 0 then
        return nil;
    end;

    local v51 = v50 * PlayerAttr.GetRebirthExpAddMul(p47);

    return math.ceil(v51);
end;

function u1.CalcTrainGain(p52, p53) -- Line: 384
    -- upvalues: PlayerAttr (copy), u1 (copy)
    if not (p52 and p52:IsA("Player")) then
        return 0;
    end;

    local v54 = tonumber(p53) or 1;
    local v55 = PlayerAttr.GetEffectiveTrainAtk(p52);

    if v55 <= 0 then
        return 0;
    end;

    local v56 = v55 * u1.GetTrainPayMul(p52) * (v54 < 0 and 0 or v54);

    return math.ceil(v56);
end;

function u1.FormatGain(p57) -- Line: 406
    -- upvalues: MathMgr (copy)
    local v58 = tonumber(p57) or 0;
    local v59 = math.floor(v58);

    return v59 <= 0 and "+0" or "+" .. MathMgr.getNumStr(v59);
end;

function u1.FormatAddMul(p60) -- Line: 420
    local v61 = tonumber(p60) or 1;
    local v62 = v61 <= 0 and 1 or v61;
    local v63 = v62 - math.floor(v62 + 0.001);

    if math.abs(v63) >= 0.01 then
        return "x" .. string.format("%.1f", v62);
    end;

    local v64 = math.floor(v62 + 0.001);

    return "x" .. tostring(v64);
end;

function u1.CanEnterTrainGround(p65, p66) -- Line: 440
    -- upvalues: CfgFind (copy), PlayerMirror (copy), Bag (copy), EnumMgr (copy)
    if not (p65 and p65:IsA("Player")) then
        return {
            ok = false,
            reason = "invalid_player"
        };
    end;

    local v67 = CfgFind.FindTrainCfgById(p66);

    if not v67 then
        return {
            ok = false,
            reason = "invalid_train"
        };
    end;

    local OnlyTag = v67.OnlyTag;

    if type(OnlyTag) == "string" and OnlyTag ~= "" then
        return PlayerMirror.IsHasPass(p65, OnlyTag) and {
            ok = true
        } or {
            ok = false,
            reason = "pass_required",
            needPass = true,
            passOnlyTag = OnlyTag
        };
    end;

    local v68 = tonumber(v67.Rebirth) or 0;
    local v69 = math.floor(v68);
    local v70 = math.max(0, v69);
    local v71 = Bag.GetItemCountByID(p65, EnumMgr.ItemID.Rebirth) or 0;

    return math.floor(v71) < v70 and {
        ok = false,
        reason = "rebirth_not_enough",
        needRebirth = true
    } or {
        ok = true
    };
end;

function u1.GetTrainValue(p72) -- Line: 482
    -- upvalues: SystemGameConfig (copy)
    return SystemGameConfig.GetValue({ "训练系统", p72 });
end;

function u1.GetTrainAnimSpeedMul(p73) -- Line: 492
    -- upvalues: u1 (copy)
    local v74 = u1.GetTrainValue("魔力速度档位");

    if type(v74) ~= "table" then
        return 1;
    end;

    local v75 = tonumber(p73) or 0;

    for _, v in ipairs(v74) do
        if type(v) == "table" then
            local v76 = tonumber(v.minPower) or 0;
            local v77 = tonumber(v.maxPower) or (1 / 0);

            if v76 <= v75 and v75 <= v77 then
                local v78 = tonumber(v.animSpeedMul) or 1;

                if v78 > 0 then
                    return v78;
                end;
            end;
        end;
    end;

    return 1;
end;

local function _parseCrystalRotateTier(p79) -- Line: 529
    return tonumber(p79["魔力下限"] or p79.minPower) or 0, tonumber(p79["魔力上限"] or p79.maxPower) or (1 / 0), tonumber(p79["上限角速度度每秒"] or p79.capDegPerSec) or 0;
end;

function u1.GetCrystalRotateTierCapDeg(p80) -- Line: 542
    -- upvalues: u1 (copy)
    local v81 = u1.GetTrainValue("水晶旋转档位");

    if type(v81) ~= "table" or #v81 == 0 then
        return 180;
    end;

    local v82 = tonumber(p80) or 0;
    local v83 = (-1 / 0);
    local v84 = 180;

    for _, v in ipairs(v81) do
        if type(v) == "table" then
            local v85 = tonumber(v["魔力下限"] or v.minPower) or 0;
            local v86 = tonumber(v["魔力上限"] or v.maxPower) or (1 / 0);
            local v87 = tonumber(v["上限角速度度每秒"] or v.capDegPerSec) or 0;

            if v87 > 0 then
                if v83 <= v86 then
                    v84 = v87;
                    v83 = v86;
                end;
            end;

            if v85 <= v82 and (v82 <= v86 and v87 > 0) then
                return v87;
            end;
        end;
    end;

    if v83 < v82 then
        return v84;
    end;

    return v84;
end;

function u1.GetCrystalRotateFloorDeg(p88) -- Line: 575
    -- upvalues: u1 (copy)
    local v89 = tonumber(u1.GetTrainValue("水晶旋转地板比例")) or 0.05;

    return u1.GetCrystalRotateTierCapDeg(p88) * (v89 < 0 and 0.05 or v89);
end;

function u1.GetCrystalHitImpulseDeg(p90) -- Line: 589
    -- upvalues: u1 (copy)
    local v91 = tonumber(u1.GetTrainValue("水晶命中冲量比例")) or 0.8;

    return u1.GetCrystalRotateTierCapDeg(p90) * (v91 < 0 and 0.8 or v91);
end;

function u1.GetCrystalRotateHalfLifeSec() -- Line: 602
    -- upvalues: u1 (copy)
    local v92 = tonumber(u1.GetTrainValue("水晶旋转半衰期秒"));

    return (type(v92) ~= "number" or v92 <= 0.001) and 0.5 or v92;
end;

function u1.GetCrystalSoftCapSec() -- Line: 615
    -- upvalues: u1 (copy)
    local v93 = tonumber(u1.GetTrainValue("水晶超上限持续秒"));

    return (type(v93) ~= "number" or v93 < 0) and 0.1 or v93;
end;

function u1.GetCrystalAimOffsetStud() -- Line: 628
    -- upvalues: u1 (copy)
    local v94 = tonumber(u1.GetTrainValue("水晶命中目标随机偏移"));

    return (type(v94) ~= "number" or v94 < 0) and 3 or v94;
end;

function u1.GetManualChainBufferSec() -- Line: 641
    -- upvalues: u1 (copy)
    local v95 = tonumber(u1.GetTrainValue("训练手动派生缓冲秒"));

    return (type(v95) ~= "number" or v95 < 0) and 0.25 or v95;
end;

return u1;