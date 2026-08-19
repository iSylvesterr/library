-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local EnumMgr = UtilsSystem.EnumMgr;
local EnemyVisibilityUtil = UtilsSystem.EnemyVisibilityUtil;
local EnemyLogicalTypes = UtilsSystem.EnemyLogicalTypes;
local Log = UtilsSystem.Log;
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local Config = require(script.Parent.Parent.Config);
local u5 = {};
local u6 = 0;

local function _ensureServerDeps() -- Line: 44
    -- upvalues: u1 (ref), RunService (copy), UtilsSystem (copy), u2 (ref), u3 (ref), u4 (ref)
    if u1 then
        return true;
    end;

    if not RunService:IsServer() then
        return false;
    end;

    u1 = UtilsSystem.SystemEnemy;
    u2 = UtilsSystem.SystemDungeon;
    u3 = UtilsSystem.SystemPlrAttr;
    u4 = UtilsSystem.SetData;
    local v7;

    if u1 == nil then
        v7 = false;
    else
        v7 = u2 ~= nil;
    end;

    return v7;
end;

function u5.isBeSheepBuff(p8, p9) -- Line: 64
    -- upvalues: EnumMgr (copy)
    if p8 and p8.RuntimeTag == EnumMgr.SkillBuffRuntimeTag.BeSheep then
        return true;
    end;

    if p8 then
        p8 = p8.BuffTp;
    end;

    return tonumber(p8) == EnumMgr.SkillBuffTypeTp.BeSheep;
end;

function u5.isExcludedTarget(p10) -- Line: 76
    if not p10 then
        return true;
    end;

    if p10:GetAttribute("SpecialEnemyConfigId") ~= nil then
        return true;
    end;

    local PrimaryPart = p10.PrimaryPart;

    return PrimaryPart and PrimaryPart:GetAttribute("Boss") == true and true or false;
end;

local function _snapshotNumberValueFolder(p11, p12) -- Line: 96
    local v13 = {};
    local v14 = p11:FindFirstChild(p12);

    if not v14 then
        return v13;
    end;

    for _, child in v14:GetChildren() do
        if child:IsA("NumberValue") then
            local v15 = {
                name = child.Name,
                value = child.Value,
                attrs = child:GetAttributes()
            };
            table.insert(v13, v15);
        end;
    end;

    return v13;
end;

local function _restoreNumberValueFolder(p16, p17, p18) -- Line: 120
    if type(p18) ~= "table" or #p18 == 0 then
        return;
    end;

    local v19 = p16:FindFirstChild(p17);

    if not v19 then
        v19 = Instance.new("Folder");
        v19.Name = p17;
        v19.Parent = p16;
    end;

    v19:ClearAllChildren();

    for _, v in ipairs(p18) do
        local NumberValue = Instance.new("NumberValue");
        NumberValue.Name = v.name;
        NumberValue.Value = v.value;

        if type(v.attrs) == "table" then
            for i, v2 in v.attrs do
                NumberValue:SetAttribute(i, v2);
            end;
        end;

        NumberValue.Parent = v19;
    end;
end;

local function _buildExtraDataFromModel(p20, p21) -- Line: 150
    -- upvalues: EnemyVisibilityUtil (copy), EnumMgr (copy)
    local v22 = {
        health = p21
    };
    local v23 = tonumber(p20:GetAttribute("Stage"));

    if v23 and v23 > 0 then
        v22.stageId = v23;
    end;

    local v24 = p20:GetAttribute("hpAdd");

    if typeof(v24) == "number" then
        v22.hpAdd = v24;
    end;

    local v25 = p20:GetAttribute("atkAdd");

    if typeof(v25) == "number" then
        v22.atkAdd = v25;
    end;

    if not EnemyVisibilityUtil.isPrivate(p20) then
        v22.visibilityMode = EnumMgr.EnemyVisibilityMode.Shared;

        return v22;
    end;

    v22.visibilityMode = EnumMgr.EnemyVisibilityMode.Private;
    local v26 = {};

    for i in EnemyVisibilityUtil.parseAllowedPlayerIds(p20:GetAttribute("AllowedPlayerIds")) do
        table.insert(v26, i);
    end;

    v22.allowedPlayerIds = v26;

    return v22;
end;

local function _waitForEnemyPack(p27, p28) -- Line: 186
    -- upvalues: u1 (ref)
    local v29 = os.clock() + p28;

    while os.clock() < v29 do
        local v30 = u1.getPackByModel(p27);

        if v30 and v30.entity then
            return true;
        end;

        task.wait();
    end;

    local v31 = u1.getPackByModel(p27);
    local v32;

    if v31 == nil then
        v32 = false;
    else
        v32 = v31.entity ~= nil;
    end;

    return v32;
end;

local function _applyInheritedHealth(p33, p34, p35) -- Line: 206
    -- upvalues: u4 (ref), EnumMgr (copy), u3 (ref)
    local v36 = p33:FindFirstChildOfClass("Humanoid");

    if not v36 then
        return;
    end;

    local v37 = math.max(1, p34);
    local v38 = math.clamp(p35, 0, v37);

    if u4 and u4.SetPlrAttr then
        u4.SetPlrAttr(p33, EnumMgr.PlrAttr.HP, v37);
    end;

    if u3 and u3.UpdateHumanState then
        u3.UpdateHumanState(p33, false);
    end;

    v36.MaxHealth = v37;
    v36.Health = v38;
end;

local function _getEnemyCfgId(p39) -- Line: 228
    local v40 = tonumber(p39:GetAttribute("ID"));

    if v40 and v40 > 0 then
        return v40;
    end;

    return nil;
end;

local function _allocToken() -- Line: 240
    -- upvalues: u6 (ref)
    u6 = u6 + 1;

    return u6;
end;

local function _isLogicalHost(p41) -- Line: 250
    -- upvalues: EnemyLogicalTypes (copy), u1 (ref)
    if p41:GetAttribute(EnemyLogicalTypes.ATTR_IS_LOGICAL) == true then
        return true;
    end;

    local v42 = u1.getPackByModel(p41);
    local v43;

    if v42 == nil then
        v43 = false;
    else
        v43 = v42.isLogical == true;
    end;

    return v43;
end;

local u44 = nil;

local function _schedulePolymorphRestore(u45, p46, p47) -- Line: 277
    -- upvalues: _snapshotNumberValueFolder (copy), u44 (ref)
    if not p46 or p47 <= 0 then
        return;
    end;

    local u48 = u45:GetAttribute("PolymorphToken");
    task.delay(p47, function() -- Line: 282
        -- upvalues: u45 (copy), u48 (copy), _snapshotNumberValueFolder (ref), u44 (ref)
        if not u45.Parent then
            return;
        end;

        if u45:GetAttribute("PolymorphToken") ~= u48 then
            return;
        end;

        if u45:GetAttribute("PolymorphActive") ~= true then
            return;
        end;

        local v49 = tonumber(u45:GetAttribute("PolymorphSourceEnemyId"));

        if not v49 or v49 <= 0 then
            return;
        end;

        local v50 = u45:FindFirstChildOfClass("Humanoid");

        if not v50 or v50.Health <= 0 then
            return;
        end;

        u44(u45, v49, v50.MaxHealth, v50.Health, _snapshotNumberValueFolder(u45, "HitPlr"), _snapshotNumberValueFolder(u45, "HitPlrID"), nil, false, 0);
    end);
end;

local function _notifyDeathIfAlreadyDead(u51) -- Line: 322
    -- upvalues: u2 (ref)
    local v52 = u51:FindFirstChildOfClass("Humanoid");

    if not v52 or v52.Health > 0 then
        return;
    end;

    if u2 and u2.NotifyEnemyDeath then
        pcall(function() -- Line: 328
            -- upvalues: u2 (ref), u51 (copy)
            u2.NotifyEnemyDeath(u51);
        end);
    end;
end;

local function _finishReplaceIntoSession(p53, p54, u55, p56, p57, p58, p59, p60, p61, p62, p63) -- Line: 349
    -- upvalues: _waitForEnemyPack (copy), Log (copy), u1 (ref), _applyInheritedHealth (copy), _restoreNumberValueFolder (copy), u2 (ref), _snapshotNumberValueFolder (copy), u44 (ref)
    if not _waitForEnemyPack(u55, 2) then
        Log.warn("[BeSheep] 等待 AI 装配超时，销毁失败绵羊", p57);

        if p56 then
            u1.DespawnByRef(p54, "polymorph");
        else
            u1.DespawnByModel(u55, "polymorph");
        end;

        if p53.Parent and p62 then
            p53:SetAttribute("PolymorphActive", nil);
        end;

        return false;
    end;

    if not (u55.Parent and p53.Parent) then
        if p56 then
            u1.DespawnByRef(p54, "polymorph");
        else
            u1.DespawnByModel(u55, "polymorph");
        end;

        if p53.Parent and p62 then
            p53:SetAttribute("PolymorphActive", nil);
        end;

        return false;
    end;

    _applyInheritedHealth(u55, p58, p59);
    _restoreNumberValueFolder(u55, "HitPlr", p60);
    _restoreNumberValueFolder(u55, "HitPlrID", p61);

    if not u2.ReplaceStageEnemyModel(p53, p54) then
        Log.warn("[BeSheep] 副本列表替换失败", p53:GetFullName());

        if p56 then
            u1.DespawnByRef(p54, "polymorph");
        else
            u1.DespawnByModel(u55, "polymorph");
        end;

        if p53.Parent and p62 then
            p53:SetAttribute("PolymorphActive", nil);
        end;

        return false;
    end;

    u1.DespawnByModel(p53, "polymorph");
    local v64 = u55:FindFirstChildOfClass("Humanoid");

    if v64 and (v64.Health <= 0 and (u2 and u2.NotifyEnemyDeath)) then
        pcall(function() -- Line: 328
            -- upvalues: u2 (ref), u55 (copy)
            u2.NotifyEnemyDeath(u55);
        end);
    end;

    if p62 and p63 > 0 then
        local u65 = u55:GetAttribute("PolymorphToken");
        task.delay(p63, function() -- Line: 282
            -- upvalues: u55 (copy), u65 (copy), _snapshotNumberValueFolder (ref), u44 (ref)
            if not u55.Parent then
                return;
            end;

            if u55:GetAttribute("PolymorphToken") ~= u65 then
                return;
            end;

            if u55:GetAttribute("PolymorphActive") ~= true then
                return;
            end;

            local v66 = tonumber(u55:GetAttribute("PolymorphSourceEnemyId"));

            if not v66 or v66 <= 0 then
                return;
            end;

            local v67 = u55:FindFirstChildOfClass("Humanoid");

            if not v67 or v67.Health <= 0 then
                return;
            end;

            u44(u55, v66, v67.MaxHealth, v67.Health, _snapshotNumberValueFolder(u55, "HitPlr"), _snapshotNumberValueFolder(u55, "HitPlrID"), nil, false, 0);
        end);
    end;

    return true;
end;

u44 = function(u68, u69, u70, u71, u72, u73, p74, u75, u76) -- Line: 427
    -- upvalues: _buildExtraDataFromModel (copy), EnemyLogicalTypes (copy), u1 (ref), u6 (ref), Log (copy), CollectionService (copy), _finishReplaceIntoSession (copy)
    local v77 = u68:GetPivot();
    local v78 = _buildExtraDataFromModel(u68, u70);
    local v79;

    if u68:GetAttribute(EnemyLogicalTypes.ATTR_IS_LOGICAL) == true then
        v79 = true;
    else
        local v80 = u1.getPackByModel(u68);

        if v80 == nil then
            v79 = false;
        else
            v79 = v80.isLogical == true;
        end;
    end;

    local v81;

    if u75 then
        u6 = u6 + 1;
        v81 = u6;
        v78.polymorphActive = true;
        v78.polymorphSourceEnemyId = p74 or 0;
        v78.polymorphToken = v81;

        if v79 then
            v78.polymorphAppear = true;
        end;
    else
        v81 = nil;
    end;

    if v79 then
        v78.combatReady = false;
    end;

    local u82, u83;

    if v79 then
        u82 = u1.CreateLogicalEnemy(u69, v77, v78);

        if not u82 then
            Log.warn("[BeSheep] CreateLogicalEnemy 失败", u69);

            return nil;
        end;

        u83 = u1.getModelForRef(u82);

        if not u83 then
            Log.warn("[BeSheep] CreateLogicalEnemy 无 host", u69);
            u1.DespawnByRef(u82, "polymorph");

            return nil;
        end;
    else
        u83 = u1.CreateEnemy(u69, v77, v78);

        if not u83 then
            Log.warn("[BeSheep] CreateEnemy 失败", u69);

            return nil;
        end;

        u82 = u83;

        if u75 then
            u83:ScaleTo(0.1);
            CollectionService:AddTag(u83, "PolymorphAppear");
        end;
    end;

    if u75 and v81 then
        u83:SetAttribute("PolymorphActive", true);
        u83:SetAttribute("PolymorphSourceEnemyId", p74 or 0);
        u83:SetAttribute("PolymorphToken", v81);
    else
        u83:SetAttribute("PolymorphActive", nil);
        u83:SetAttribute("PolymorphSourceEnemyId", nil);
        u83:SetAttribute("PolymorphToken", nil);
    end;

    if v79 then
        _finishReplaceIntoSession(u68, u82, u83, true, u69, u70, u71, u72, u73, u75, u76);
    else
        task.spawn(function() -- Line: 515
            -- upvalues: _finishReplaceIntoSession (ref), u68 (copy), u82 (ref), u83 (ref), u69 (copy), u70 (copy), u71 (copy), u72 (copy), u73 (copy), u75 (copy), u76 (copy)
            _finishReplaceIntoSession(u68, u82, u83, false, u69, u70, u71, u72, u73, u75, u76);
        end);
    end;

    return u83;
end;

function u5.tryApply(p84, p85, p86) -- Line: 542
    -- upvalues: RunService (copy), u1 (ref), UtilsSystem (copy), u2 (ref), u3 (ref), u4 (ref), u5 (copy), _snapshotNumberValueFolder (copy), Config (copy), u44 (ref)
    if RunService:IsServer() then
        local v87;

        if u1 then
            v87 = true;
        elseif RunService:IsServer() then
            u1 = UtilsSystem.SystemEnemy;
            u2 = UtilsSystem.SystemDungeon;
            u3 = UtilsSystem.SystemPlrAttr;
            u4 = UtilsSystem.SetData;

            if u1 == nil then
                v87 = false;
            else
                v87 = u2 ~= nil;
            end;
        else
            v87 = false;
        end;

        if v87 then
            if not (p84 and p84.Parent) then
                return;
            end;

            if not u5.isBeSheepBuff(p85, p86) then
                return;
            end;

            if p84:GetAttribute("PolymorphActive") == true then
                return;
            end;

            if u5.isExcludedTarget(p84) then
                return;
            end;

            local v88 = tonumber(p84:GetAttribute("ID"));

            if not v88 or v88 <= 0 then
                v88 = nil;
            end;

            if not v88 or v88 == 5000001 then
                return;
            end;

            local v89 = p84:FindFirstChildOfClass("Humanoid");

            if not v89 or v89.Health <= 0 then
                return;
            end;

            local MaxHealth = v89.MaxHealth;
            local Health = v89.Health;
            local v90 = _snapshotNumberValueFolder(p84, "HitPlr");
            local v91 = _snapshotNumberValueFolder(p84, "HitPlrID");
            local v92 = Config.durFromRow(p85);
            p84:SetAttribute("PolymorphActive", true);
            u44(p84, 5000001, MaxHealth, Health, v90, v91, v88, true, v92);
        end;
    end;
end;

return u5;