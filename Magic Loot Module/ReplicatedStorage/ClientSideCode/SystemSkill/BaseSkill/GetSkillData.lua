-- Decompiled with Potassium's decompiler.

local u1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
local PlrAttr = UtilsSystem.EnumMgr.PlrAttr;
local HumanModule = UtilsSystem.HumanModule;
local DeviceType = UtilsSystem.DeviceType;
local GetData = UtilsSystem.GetData;
local RunService = game:GetService("RunService");
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local _ = ReplicatedStorage.ClientSideCode.SystemSkill.GroupSkillModule;
local SkillModule = ReplicatedStorage.ClientSideCode.SystemSkill.SkillModule;
local v2 = {
    ElementTp.Wind,
    ElementTp.Fire,
    ElementTp.Water,
    ElementTp.Earth,
    ElementTp.Dark,
    ElementTp.Light,
    ElementTp.Thunder,
    ElementTp.Ice,
    ElementTp.Poison,
    ElementTp.Space
};
u1.ElementCounterDamage = {};
u1.ElementCounterDamage[ElementTp.None] = {
    [ElementTp.None] = 1
};

local function elementCounterMult(p3, p4) -- Line: 30
    -- upvalues: ElementTp (copy)
    if p3 == ElementTp.None or p4 == ElementTp.None then
        return 1;
    end;

    local v5 = {
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

    return v5[p3] == p4 and 2 or ((v5[p4] == p3 or p3 == p4) and 0.5 or 1);
end;

for _, v in ipairs(v2) do
    u1.ElementCounterDamage[ElementTp.None][v] = 1;
end;

for _, v in ipairs(v2) do
    local v6 = {
        [ElementTp.None] = 1
    };

    for _, v3 in ipairs(v2) do
        v6[v3] = elementCounterMult(v, v3);
    end;

    u1.ElementCounterDamage[v] = v6;
end;

local function buildAttackerDataFromInstance(p7) -- Line: 95
    -- upvalues: GetData (copy), PlrAttr (copy), ElementTp (copy)
    return {
        attackPower = GetData.GetCombatAttackPower(p7),
        criticalRate = GetData.GetPlrAttr(p7, PlrAttr.Crit_Rate),
        criticalDamage = GetData.GetPlrAttr(p7, PlrAttr.Crit_Dmg),
        elementEnhancement = ElementTp.None,
        finalDamageBonus = GetData.GetPlrAttr(p7, PlrAttr.Dmg_Bonus)
    };
end;

function u1.getAttackerData(p8, p9) -- Line: 106
    -- upvalues: u1 (copy), buildAttackerDataFromInstance (copy), Players (copy), ElementTp (copy)
    if p9 == "Summon" then
        local v10 = u1.getCharacter("Summon", p8);

        if v10 then
            return buildAttackerDataFromInstance(v10);
        end;
    elseif p9 == "Player" then
        local v11 = tonumber(p8);
        local v12;

        if v11 then
            v12 = Players:GetPlayerByUserId(v11);
        else
            v12 = nil;
        end;

        if v12 then
            return buildAttackerDataFromInstance(v12);
        end;
    else
        local v13 = p9 == "NPC" and u1.getCharacter("NPC", p8);

        if v13 then
            return buildAttackerDataFromInstance(v13);
        end;
    end;

    return {
        attackPower = 1,
        criticalRate = 0,
        criticalDamage = 0,
        finalDamageBonus = 0,
        elementEnhancement = ElementTp.None
    };
end;

function u1.getDefenderData(p14) -- Line: 140
    -- upvalues: ElementTp (copy), GetData (copy), PlrAttr (copy)
    return p14 and {
        elementResistance = 0,
        elementType = ElementTp.None,
        finalDamageReduction = GetData.GetPlrAttr(p14, PlrAttr.Dmg_Reduction)
    } or {
        elementResistance = 0,
        finalDamageReduction = 0,
        elementType = ElementTp.None
    };
end;

function u1.calculateSkillDamage(p15, p16) -- Line: 173
    -- upvalues: SkillModule (copy), ElementTp (copy)
    if not (p15 and p16) then
        warn("计算技能伤害失败 攻击者或被攻击者数据为空");

        return 0, false;
    end;

    local v17 = SkillModule:FindFirstChild(p15.skillName);

    if not v17 then
        warn("计算技能伤害失败 技能配置为空");

        return 0, false;
    end;

    local v18 = require(v17);
    local v19 = require(script.Parent.SkillDamageRateFromCfg).get(p15.skillID, p15.hitboxIndex);
    local v20 = v18.skillElementType or ElementTp.None;
    local v21 = require(script.Parent.DamageResolver).resolveDamage({
        powerMult = 1,
        canCritical = true,
        randomOffset = 0.05,
        attackerData = p15,
        defenderData = p16,
        damageRate = v19,
        hitIndex = p15.hitIndex,
        hitboxIndex = p15.hitboxIndex,
        combatSeed = p15.combatSeed,
        elementType = v20
    });

    return v21.finalDamage, v21.isCritical;
end;

function u1.getCharacter(p22, p23) -- Line: 217
    -- upvalues: Players (copy), RunService (copy), UtilsSystem (copy)
    if p22 == "Player" then
        local v24 = tonumber(p23);
        local v25;

        if v24 then
            v25 = Players:GetPlayerByUserId(v24);
        else
            v25 = nil;
        end;

        if v25 then
            return v25.Character;
        end;
    elseif p22 == "NPC" then
        if RunService:IsServer() then
            local SystemEnemy = UtilsSystem.SystemEnemy;

            if SystemEnemy and SystemEnemy.getPackById then
                local v26 = SystemEnemy.getPackById(p23);

                if v26 and v26.model then
                    return v26.model;
                end;
            end;
        end;

        local SystemLogicalEnemy = UtilsSystem.SystemLogicalEnemy;
        local v27 = SystemLogicalEnemy and SystemLogicalEnemy.GetModel and SystemLogicalEnemy.GetModel(p23);

        if v27 then
            return v27;
        end;

        local Monster = workspace:FindFirstChild("Monster");
        local v28 = Monster and Monster:FindFirstChild((tostring(p23)));

        if v28 then
            return v28;
        end;

        local LocalMonster = workspace:FindFirstChild("LocalMonster");
        local v29 = LocalMonster and LocalMonster:FindFirstChild((tostring(p23)));

        if v29 then
            return v29;
        end;
    elseif p22 == "Summon" then
        local Summons = workspace:FindFirstChild("Summons");
        local v30 = Summons and Summons:FindFirstChild((tostring(p23)));

        if v30 then
            return v30;
        end;
    else
        local v31 = p22 == "Mirror" and workspace:FindFirstChild("SpaceMirrors");

        if v31 then
            local v32 = v31:FindFirstChild((tostring(p23)));

            if v32 and v32:IsA("Model") then
                return v32;
            end;
        end;
    end;

    return nil;
end;

local function CastAllButPlayer(p33, p34, p35) -- Line: 282
    local v36 = RaycastParams.new();
    v36.FilterType = Enum.RaycastFilterType.Include;
    v36.FilterDescendantsInstances = { workspace["场景"], workspace.Monster, workspace:FindFirstChild("LocalMonster") };
    v36.IgnoreWater = true;

    return workspace:Raycast(p33, p34 * p35, v36) or nil;
end;

function u1.isLocalPlayerAutoAimActive() -- Line: 310
    -- upvalues: ReplicatedStorage (copy)
    local NowTargetCurrent = ReplicatedStorage:FindFirstChild("NowTargetCurrent");

    return NowTargetCurrent and NowTargetCurrent.Value and true or false;
end;

function u1.getLocalPlayerManualAimCFrame() -- Line: 321
    -- upvalues: Players (copy), HumanModule (copy), DeviceType (copy), CastAllButPlayer (copy)
    local LocalPlayer = Players.LocalPlayer;
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if not Character then
        return nil;
    end;

    if not (HumanModule.GetIsShiftLocked() and DeviceType.IsMobile()) then
        return LocalPlayer:GetMouse().Hit;
    end;

    local mouseIcon = LocalPlayer.PlayerGui.MobieMouse.mouseIcon;
    local v37 = mouseIcon.AbsolutePosition + mouseIcon.AbsoluteSize / 2;
    local CurrentCamera = workspace.CurrentCamera;
    local Unit = CurrentCamera:ScreenPointToRay(v37.X, v37.Y, 1000).Direction.Unit;
    local v38 = CFrame.new(CurrentCamera.CFrame.Position + 1000 * Unit, CurrentCamera.CFrame.Position + 1001 * Unit);
    local v39 = CastAllButPlayer(CurrentCamera.CFrame.Position, Unit, 1000);

    if v39 then
        v38 = v38.Rotation + v39.Position;
    end;

    return v38;
end;

function u1.getLocalPlayerSkillInputData() -- Line: 348
    -- upvalues: Players (copy), u1 (copy), ReplicatedStorage (copy)
    local Character = Players.LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if not (Character and Character:IsA("BasePart")) then
        return nil, nil;
    end;

    local v40 = Character:GetPivot();
    local v41 = u1.getLocalPlayerManualAimCFrame() or v40;

    if u1.isLocalPlayerAutoAimActive() then
        local NowTargetCurrent = ReplicatedStorage:FindFirstChild("NowTargetCurrent");

        if NowTargetCurrent and NowTargetCurrent.Value then
            v41 = NowTargetCurrent.Value:GetPivot();
        end;
    end;

    return v40, v41;
end;

function u1.getCharacterDirectionStr(p42) -- Line: 378
    -- upvalues: Players (copy)
    if not p42 then
        return "Forward";
    end;

    local HumanoidRootPart = p42:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return "Forward";
    end;

    local v43 = p42:FindFirstChildOfClass("Humanoid");

    if not v43 then
        return "Forward";
    end;

    local LookVector = HumanoidRootPart:GetPivot().LookVector;
    local MoveDirection = v43.MoveDirection;
    local v44 = Vector3.new(MoveDirection.X, 0, MoveDirection.Z);
    local Magnitude = v44.Magnitude;

    if game["Run Service"]:IsClient() then
        if Players.LocalPlayer == Players:GetPlayerFromCharacter(p42) and (not Players.LocalPlayer:GetAttribute("IsShiftLocked") and Magnitude > 0) then
            return "Forward", v44;
        end;

        if Magnitude < 0.1 then
            if Players.LocalPlayer ~= Players:GetPlayerFromCharacter(p42) then
                return "Forward";
            end;

            local LookVector2 = workspace.CurrentCamera.CFrame.LookVector;
            local v45 = Vector3.new(LookVector2.X, 0, LookVector2.Z);
            local _ = v45.Magnitude;

            return "Forward", v45;
        end;
    end;

    local v46 = Vector3.new(LookVector.X, 0, LookVector.Z);
    local Unit = v44.Unit;

    if v46.Magnitude > 0 then
        v46 = v46.Unit or v46;
    end;

    local v47 = Unit:Dot(v46);
    local v48 = math.clamp(v47, -1, 1);
    local v49 = math.acos(v48);
    local v50 = Unit:Cross(v46);
    local v51 = math.deg(v49);

    if v50.Y < 0 then
        v51 = -v51;
    end;

    return v51 >= -45 and v51 < 45 and "Forward" or (v51 >= 45 and v51 < 135 and "Right" or ((v51 >= 135 or v51 < -135) and "Backward" or (v51 >= -135 and v51 < -45 and "Left" or "Forward")));
end;

function u1.getLimitedTargetCF(p52, p53, p54) -- Line: 483
    if not p54 then
        return p53;
    end;

    local v55 = p53.Position - p52.Position;

    if v55.Magnitude <= p54 then
        return p53;
    end;

    return p53.Rotation + p52.Position + v55.Unit * p54;
end;

return u1;