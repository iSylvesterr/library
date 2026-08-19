-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedFirst = game:GetService("ReplicatedFirst");
local UtilsSystem = require(ReplicatedFirst.AllSideCode.UtilsSystem);
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local EnumMgr = UtilsSystem.EnumMgr;
local CfgFind = UtilsSystem.CfgFind;
local EnemyVisibilityUtil = UtilsSystem.EnemyVisibilityUtil;
local SkillFxGate = UtilsSystem.SkillFxGate;
local SkillHitPresentationSoundMap = require(script.Parent.SkillHitPresentationSoundMap);
local v1 = {};
local u2 = nil;

local function _findNpcEntityCfg(p3) -- Line: 48
    -- upvalues: CfgFind (copy), EnumMgr (copy)
    local v4 = p3:GetAttribute("ID");

    if v4 == nil then
        return nil;
    end;

    if p3:GetAttribute("EntityType") == "Summon" then
        return CfgFind.FindCfgByID(v4, EnumMgr.ItemType.SummonedCreature);
    end;

    return CfgFind.FindCfgByID(v4, EnumMgr.ItemType.Enemy);
end;

local function _resolveTargetModelScale(p5) -- Line: 65
    if not (p5 and p5:IsA("Model")) then
        return 1;
    end;

    local v6 = p5:GetScale();

    return (typeof(v6) ~= "number" or v6 <= 0) and 1 or v6;
end;

local function _resolveMonsterInjuredSoundKey(p7) -- Line: 82
    -- upvalues: _findNpcEntityCfg (copy)
    local v8 = _findNpcEntityCfg(p7);

    if not v8 then
        return nil;
    end;

    local InjuredSound = v8.InjuredSound;

    if typeof(InjuredSound) == "string" and InjuredSound ~= "" then
        return InjuredSound;
    end;

    return nil;
end;

local function _buildEntry(p9, p10) -- Line: 101
    -- upvalues: SkillHitPresentationSoundMap (copy), _findNpcEntityCfg (copy)
    if p10 then
        p10 = p10.hitPresentation;
    end;

    if type(p10) ~= "table" then
        return nil;
    end;

    local hitPos = p10.hitPos;

    if typeof(hitPos) ~= "Vector3" then
        return nil;
    end;

    if p10.suppressPresentation == true then
        return nil;
    end;

    local effectName = p10.effectName;
    local v11 = (typeof(effectName) ~= "string" or effectName == "") and "通用受击" or effectName;
    local resolveHitSounds = SkillHitPresentationSoundMap.resolveHitSounds;
    local skillSoundKey = p10.skillSoundKey;
    local v12 = _findNpcEntityCfg(p9);
    local v13;

    if v12 then
        v13 = v12.InjuredSound;

        if typeof(v13) ~= "string" or v13 == "" then
            v13 = nil;
        end;
    else
        v13 = nil;
    end;

    local v14 = {
        effectName = v11,
        soundNames = resolveHitSounds(skillSoundKey, v13),
        hitPos = hitPos
    };
    local v15;

    if p9 and p9:IsA("Model") then
        local v16 = p9:GetScale();
        v15 = (typeof(v16) ~= "number" or v16 <= 0) and 1 or v16;
    else
        v15 = 1;
    end;

    v14.targetScale = v15;
    v14.targetModel = p9;

    return v14;
end;

local function _dispatchEntries(p17, p18) -- Line: 141
    -- upvalues: Players (copy), SkillFxGate (copy), EnemyVisibilityUtil (copy), NetWork (copy), NetMsg (copy)
    if #p17 == 0 then
        return;
    end;

    for _, v in Players:GetPlayers() do
        if SkillFxGate.IsEnabled(v) then
            local Character = v.Character;

            if Character then
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                    local Position = HumanoidRootPart.Position;
                    local v19 = {};

                    for _, v2 in p17 do
                        local targetModel = v2.targetModel;

                        if targetModel and (targetModel.Parent and ((Position - v2.hitPos).Magnitude <= 100 and EnemyVisibilityUtil.canPlayerSee(targetModel, v.UserId))) then
                            table.insert(v19, {
                                effectName = v2.effectName,
                                soundNames = v2.soundNames,
                                hitPos = v2.hitPos,
                                targetScale = v2.targetScale
                            });
                        end;
                    end;

                    if #v19 > 0 then
                        NetWork.FireClient(v, NetMsg.SKILL_HIT_PRESENTATION, v19);
                    end;
                end;
            end;
        end;
    end;
end;

function v1.beginBatch(p20) -- Line: 186
    -- upvalues: u2 (ref)
    u2 = {
        attackerUserId = p20,
        entries = {}
    };
end;

function v1.flushBatch() -- Line: 198
    -- upvalues: u2 (ref), _dispatchEntries (copy)
    local v21 = u2;
    u2 = nil;

    if not v21 or #v21.entries == 0 then
        return;
    end;

    _dispatchEntries(v21.entries, v21.attackerUserId);
end;

function v1.accumulateFromCombat(p22, p23, p24) -- Line: 214
    -- upvalues: _buildEntry (copy), u2 (ref), _dispatchEntries (copy)
    if p23 <= 0 or not p22 then
        return;
    end;

    if type(p24) == "table" and type(p24.skillDotFixedDamage) == "number" then
        return;
    end;

    local v25 = _buildEntry(p22, p24);

    if not v25 then
        return;
    end;

    if u2 then
        table.insert(u2.entries, v25);

        return;
    end;

    _dispatchEntries({ v25 }, p24.attackerPlayerId);
end;

return v1;