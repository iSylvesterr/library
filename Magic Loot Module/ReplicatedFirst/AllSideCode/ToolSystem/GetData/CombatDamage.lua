-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local Log = UtilsSystem.Log;
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local PlayerAttr = require(script.Parent.PlayerAttr);
local u1 = {};
local ElementTp = EnumMgr.ElementTp;
local u2 = {
    [ElementTp.Fire] = ElementTp.Wind,
    [ElementTp.Wind] = ElementTp.Earth,
    [ElementTp.Earth] = ElementTp.Water,
    [ElementTp.Water] = ElementTp.Fire,
    [ElementTp.Light] = ElementTp.Dark,
    [ElementTp.Dark] = ElementTp.Light,
    [ElementTp.Thunder] = ElementTp.Water,
    [ElementTp.Ice] = ElementTp.Wind,
    [ElementTp.Space] = ElementTp.Dark,
    [ElementTp.Poison] = ElementTp.Earth
};

local function _getSkillBuffUtil() -- Line: 68
    -- upvalues: UtilsSystem (copy)
    return UtilsSystem.SkillBuffUtil;
end;

local function _getRemoteEvent() -- Line: 76
    -- upvalues: UtilsSystem (copy)
    local RemoteEvent = UtilsSystem.RemoteEvent;

    if RemoteEvent then
        return RemoteEvent.RemoteEvent;
    end;

    return nil;
end;

local function _resolveCharacter(p3) -- Line: 89
    if typeof(p3) == "Instance" and p3:IsA("Player") then
        return p3.Character;
    end;

    if typeof(p3) == "Instance" and p3:IsA("Model") then
        return p3;
    end;

    return nil;
end;

local function _resolvePlayer(p4) -- Line: 104
    -- upvalues: Players (copy)
    if typeof(p4) == "Instance" and p4:IsA("Player") then
        return p4;
    end;

    if typeof(p4) == "Instance" and p4:IsA("Model") then
        return Players:GetPlayerFromCharacter(p4);
    end;

    return nil;
end;

local function _elementCounterMult(p5, p6) -- Line: 120
    -- upvalues: ElementTp (copy), u2 (copy)
    return (p5 == ElementTp.None or p6 == ElementTp.None) and 1 or (u2[p5] == p6 and 2 or ((u2[p6] == p5 or p5 == p6) and 0.5 or 1));
end;

local function _getEleDmgAdd(p7, p8) -- Line: 136
    return 0;
end;

local function _getEleRes(p9, p10) -- Line: 143
    return 0;
end;

local function _isDodgeInvincible(p11) -- Line: 152
    local v12 = p11:FindFirstChild("闪避无敌");

    return v12 and (v12:IsA("NumberValue") and v12.Value > workspace:GetServerTimeNow()) and true or false;
end;

local function _isPerfectDefenseActive(p13) -- Line: 165
    local v14 = p13:FindFirstChild("完美弹反防御");

    return v14 and (v14:IsA("NumberValue") and v14.Value > workspace:GetServerTimeNow()) and true or false;
end;

local function _fireMagicDefensePresentationToNearby(p15, p16, p17) -- Line: 179
    -- upvalues: RunService (copy), UtilsSystem (copy), Players (copy)
    if not RunService:IsServer() then
        return;
    end;

    local RemoteEvent = UtilsSystem.RemoteEvent;
    local v18;

    if RemoteEvent then
        v18 = RemoteEvent.RemoteEvent;
    else
        v18 = nil;
    end;

    if not v18 then
        return;
    end;

    local v19;

    if typeof(p15) == "Instance" and p15:IsA("Player") then
        v19 = p15;
    elseif typeof(p15) == "Instance" and p15:IsA("Model") then
        v19 = Players:GetPlayerFromCharacter(p15);
    else
        v19 = nil;
    end;

    if typeof(p15) == "Instance" and p15:IsA("Player") then
        p15 = p15.Character;
    elseif typeof(p15) ~= "Instance" or not p15:IsA("Model") then
        p15 = nil;
    end;

    if not (v19 and p15) then
        return;
    end;

    local v20 = nil;
    local v21;

    if type(p16) == "table" then
        v21 = p16.hitboxWorldPosition;

        if typeof(v21) ~= "Vector3" then
            v21 = v20;
        end;
    else
        v21 = v20;
    end;

    local v22 = {
        defenderUserId = v19.UserId,
        hitboxPosition = v21
    };
    local Position = p15:GetPivot().Position;

    for _, v in Players:GetPlayers() do
        local Character = v.Character;

        if Character and (Character:GetPivot().Position - Position).Magnitude < 100 then
            v18:FireClient(v, p17, v22);
        end;
    end;
end;

local function _firePerfectDodgePresentation(p23) -- Line: 218
    -- upvalues: RunService (copy), UtilsSystem (copy), Players (copy)
    if not RunService:IsServer() then
        return;
    end;

    local RemoteEvent = UtilsSystem.RemoteEvent;
    local v24;

    if RemoteEvent then
        v24 = RemoteEvent.RemoteEvent;
    else
        v24 = nil;
    end;

    if not v24 then
        return;
    end;

    local v25;

    if typeof(p23) == "Instance" and p23:IsA("Player") then
        v25 = p23;
    elseif typeof(p23) == "Instance" and p23:IsA("Model") then
        v25 = Players:GetPlayerFromCharacter(p23);
    else
        v25 = nil;
    end;

    if typeof(p23) == "Instance" and p23:IsA("Player") then
        p23 = p23.Character;
    elseif typeof(p23) ~= "Instance" or not p23:IsA("Model") then
        p23 = nil;
    end;

    if not (v25 and p23) then
        return;
    end;

    local Position = p23:GetPivot().Position;

    for _, v in Players:GetPlayers() do
        local Character = v.Character;

        if Character and (Character:GetPivot().Position - Position).Magnitude < 100 then
            v24:FireClient(v, "完美闪避表现", v25.UserId);
        end;
    end;
end;

local function _tryCondDmgAmpFromAttach(p26, p27, p28, p29, p30) -- Line: 251
    -- upvalues: UtilsSystem (copy), CfgFind (copy), EnumMgr (copy)
    local SkillBuffUtil = UtilsSystem.SkillBuffUtil;

    if not SkillBuffUtil then
        return p30;
    end;

    if not SkillBuffUtil.HasElementAttach(p26, p29) then
        return p30;
    end;

    local v31 = p27 == p29;

    if not v31 then
        local v32 = tonumber(p28.skillid);

        if v32 then
            local v33 = CfgFind.FindCfgByID(v32, EnumMgr.ItemType.Skill);
            v31 = v33 and tonumber(v33.isBase) == EnumMgr.SkillTp.Base and true or v31;
        end;
    end;

    if not v31 then
        return p30;
    end;

    local v34 = SkillBuffUtil.GetElementTraitAmp(p26, p29);

    if v34 and (v34 > 0 and v34 == v34) then
        return p30 * (1 + v34);
    end;

    return p30;
end;

local function _tryPerfectParryDispatch(p35, p36) -- Line: 292
    -- upvalues: RunService (copy)
    if not RunService:IsServer() then
        return;
    end;

    local success, result = pcall(function() -- Line: 296
        return require(game.ServerStorage.ServerSideCode.System.MagicBlockPerfectParryDispatch);
    end);

    if success and (result and result.tryOnPlayerPerfectBlock) then
        result.tryOnPlayerPerfectBlock(p35, p36);
    end;
end;

local function _getMagicShieldDamageRate() -- Line: 308
    -- upvalues: SystemGameConfig (copy)
    local v37 = 0.5;
    local v38 = SystemGameConfig.GetValue({ "战斗数值", "魔法护盾减伤倍率" });

    if type(v38) == "number" then
        if v38 ~= v38 then
            v38 = v37;
        end;
    else
        v38 = v37;
    end;

    return math.clamp(1 - v38, 0.01, 1);
end;

local function _applyDefenderMitigation(p39, p40, p41, p42) -- Line: 325
    -- upvalues: ElementTp (copy), u2 (copy), PlayerAttr (copy), EnumMgr (copy)
    local None = ElementTp.None;
    local v43 = (p40 == ElementTp.None or None == ElementTp.None) and 1 or (u2[p40] == None and 2 or ((u2[None] == p40 or p40 == None) and 0.5 or 1));
    local v44 = PlayerAttr.GetPlrAttr(p39, EnumMgr.PlrAttr.Dmg_Reduction);
    local v45 = tonumber(p42);
    local v46 = math.clamp((not v45 or v45 ~= v45) and 1 or v45, 0, 1);

    return p41 * v43 * 1 * (1 - v44) * v46;
end;

function u1.GetDmg(p47, p48, p49) -- Line: 353
    -- upvalues: Log (copy), _firePerfectDodgePresentation (copy), _fireMagicDefensePresentationToNearby (copy), RunService (copy), Players (copy), _tryPerfectParryDispatch (copy), ElementTp (copy), PlayerAttr (copy), SystemGameConfig (copy), EnumMgr (copy), u2 (copy), _tryCondDmgAmpFromAttach (copy)
    if p48 then
        local v50 = p48:FindFirstChild("闪避无敌");

        if v50 and (v50:IsA("NumberValue") and v50.Value > workspace:GetServerTimeNow()) and true or false then
            Log.warn("当前闪避无敌中");
            _firePerfectDodgePresentation(p48);

            return 0, false;
        end;

        local v51 = p48:FindFirstChild("完美弹反防御");
        local v52 = p48:FindFirstChild("魔法护盾_完美剩余");

        if v51 and (v51:IsA("NumberValue") and v51.Value > workspace:GetServerTimeNow()) then
            local v53;

            if v52 and v52:IsA("NumberValue") then
                v53 = v52.Value;
            else
                v53 = nil;
            end;

            if v53 == nil and true or v53 > 0 then
                _fireMagicDefensePresentationToNearby(p48, p49, "完美防御表现");

                if RunService:IsServer() then
                    if v53 ~= nil and v52 then
                        v52.Value = v53 - 1;
                    end;

                    if typeof(p48) ~= "Instance" or not p48:IsA("Player") then
                        if typeof(p48) == "Instance" and p48:IsA("Model") then
                            p48 = Players:GetPlayerFromCharacter(p48);
                        else
                            p48 = nil;
                        end;
                    end;

                    if p48 then
                        _tryPerfectParryDispatch(p48, p49);
                    end;
                end;
            end;

            return 0, false;
        end;
    end;

    if not p47 then
        return 0, false;
    end;

    local v54 = p49.damageRate or 1;
    local v55 = tonumber(p49.eleTp) or ElementTp.None;
    local isCrit = p49.isCrit;

    if isCrit == nil then
        isCrit = false;
    end;

    local v56 = PlayerAttr.GetCombatAttackPower(p47) * v54;

    if p48 then
        local v57 = p48:FindFirstChild("普通防御");
        local v58 = p48:FindFirstChild("魔法护盾_普通剩余");

        if v57 and (v57:IsA("NumberValue") and v57.Value > workspace:GetServerTimeNow()) then
            local v59;

            if v58 and v58:IsA("NumberValue") then
                v59 = v58.Value;
            else
                v59 = nil;
            end;

            if v59 == nil and true or v59 > 0 then
                _fireMagicDefensePresentationToNearby(p48, p49, "普通防御表现");

                if RunService:IsServer() and (v59 ~= nil and v58) then
                    v58.Value = v59 - 1;
                end;

                local v60 = 0.5;
                local v61 = SystemGameConfig.GetValue({ "战斗数值", "魔法护盾减伤倍率" });

                if type(v61) == "number" then
                    if v61 ~= v61 then
                        v61 = v60;
                    end;
                else
                    v61 = v60;
                end;

                v56 = v56 * math.clamp(1 - v61, 0.01, 1);
            end;
        end;
    end;

    local v62 = 1;
    local v63;

    if isCrit and (RunService:IsServer() and PlayerAttr.GetPlrAttr(p47, EnumMgr.PlrAttr.Crit_Rate) >= math.random()) then
        v62 = v62 + PlayerAttr.GetPlrAttr(p47, EnumMgr.PlrAttr.Crit_Dmg);
        v63 = true;
    else
        v63 = false;
    end;

    local v64 = PlayerAttr.GetPlrAttr(p47, EnumMgr.PlrAttr.Dmg_Bonus);
    local v65;

    if v63 then
        v65 = v56 * 1 * v62 * (1 + v64);
    else
        v65 = v56 * 1 * (1 + v64);
    end;

    if p48 then
        local None = ElementTp.None;
        local v66 = (v55 == ElementTp.None or None == ElementTp.None) and 1 or (u2[v55] == None and 2 or ((u2[None] == v55 or v55 == None) and 0.5 or 1));
        local v67 = PlayerAttr.GetPlrAttr(p48, EnumMgr.PlrAttr.Dmg_Reduction);
        local v68 = tonumber(1);
        local v69 = math.clamp((not v68 or v68 ~= v68) and 1 or v68, 0, 1);
        v65 = v65 * v66 * 1 * (1 - v67) * v69;
        local v70 = nil;

        if typeof(p48) == "Instance" and p48:IsA("Model") then
            v70 = p48;
        elseif typeof(p48) == "Instance" and p48:IsA("Player") then
            v70 = p48.Character;
        end;

        if v70 and v70.Parent then
            local v71 = _tryCondDmgAmpFromAttach(v70, v55, p49, ElementTp.Water, v65);
            v65 = _tryCondDmgAmpFromAttach(v70, v55, p49, ElementTp.Fire, v71);
        end;
    end;

    return v65, v63;
end;

function u1.GetSkillDotTickOutgoingDmg(p72, p73, p74) -- Line: 463
    -- upvalues: PlayerAttr (copy)
    if not p72 then
        return 0;
    end;

    local v75 = tonumber(p74);

    return (not v75 or (v75 ~= v75 or v75 <= 0)) and 0 or v75 * PlayerAttr.GetCombatAttackPower(p72) * 1;
end;

function u1.GetSkillDotTickDamage(p76, p77, p78, p79) -- Line: 486
    -- upvalues: u1 (copy), ElementTp (copy), u2 (copy), PlayerAttr (copy), EnumMgr (copy)
    if not (p76 and p77) then
        return 0;
    end;

    local v80 = tonumber(p79);

    if not v80 or (v80 ~= v80 or v80 <= 0) then
        return 0;
    end;

    local v81 = p77:FindFirstChild("闪避无敌");

    if not v81 or (not v81:IsA("NumberValue") or v81.Value <= workspace:GetServerTimeNow()) then
        local v82 = p77:FindFirstChild("完美弹反防御");

        if not v82 or (not v82:IsA("NumberValue") or v82.Value <= workspace:GetServerTimeNow()) then
            local v83 = u1.GetSkillDotTickOutgoingDmg(p76, p78, p79);
            local None = ElementTp.None;
            local v84 = (p78 == ElementTp.None or None == ElementTp.None) and 1 or (u2[p78] == None and 2 or ((u2[None] == p78 or p78 == None) and 0.5 or 1));
            local v85 = PlayerAttr.GetPlrAttr(p77, EnumMgr.PlrAttr.Dmg_Reduction);
            local v86 = tonumber(1);
            local v87 = math.clamp((not v86 or v86 ~= v86) and 1 or v86, 0, 1);

            return v83 * v84 * 1 * (1 - v85) * v87;
        end;
    end;

    return 0;
end;

function u1.GetEnvHazardDotTickDamage(p88, p89, p90, p91) -- Line: 516
    -- upvalues: ElementTp (copy), u2 (copy), PlayerAttr (copy), EnumMgr (copy)
    if not p88 then
        return 0;
    end;

    local v92 = tonumber(p90);

    if not v92 or (v92 ~= v92 or v92 <= 0) then
        return 0;
    end;

    local v93 = p88:FindFirstChild("闪避无敌");

    if not v93 or (not v93:IsA("NumberValue") or v93.Value <= workspace:GetServerTimeNow()) then
        local v94 = p88:FindFirstChild("完美弹反防御");

        if not v94 or (not v94:IsA("NumberValue") or v94.Value <= workspace:GetServerTimeNow()) then
            local v95 = nil;

            if p88:IsA("Player") then
                local Character = p88.Character;

                if Character then
                    v95 = Character:FindFirstChildOfClass("Humanoid");
                end;
            elseif p88:IsA("Model") then
                v95 = p88:FindFirstChildOfClass("Humanoid");
            end;

            if not v95 or v95.MaxHealth <= 0 then
                return 0;
            end;

            local v96 = v95.MaxHealth * v92;
            local None = ElementTp.None;
            local v97 = (p89 == ElementTp.None or None == ElementTp.None) and 1 or (u2[p89] == None and 2 or ((u2[None] == p89 or p89 == None) and 0.5 or 1));
            local v98 = PlayerAttr.GetPlrAttr(p88, EnumMgr.PlrAttr.Dmg_Reduction);
            local v99 = tonumber(p91);
            local v100 = math.clamp((not v99 or v99 ~= v99) and 1 or v99, 0, 1);

            return v96 * v97 * 1 * (1 - v98) * v100;
        end;
    end;

    return 0;
end;

function u1.GetReflectThornsDamage(p101, p102, p103, p104) -- Line: 560
    -- upvalues: UtilsSystem (copy), u1 (copy)
    if not (p101 and (p102 and p103)) then
        return 0, false;
    end;

    if p104 == nil then
        local SkillBuffUtil = UtilsSystem.SkillBuffUtil;
        p104 = SkillBuffUtil and SkillBuffUtil.GetReflectThornsPrimaryScalar() or 0.5;
    end;

    local isCrit = p103.isCrit;

    if isCrit == nil then
        isCrit = false;
    end;

    return u1.GetDmg(p101, p102, {
        damageRate = (p104 ~= p104 or p104 < 0) and 0 or p104,
        eleTp = p103.eleTp,
        isCrit = isCrit
    });
end;

return u1;