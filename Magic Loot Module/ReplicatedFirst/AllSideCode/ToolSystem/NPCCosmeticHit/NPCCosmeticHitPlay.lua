-- Decompiled with Potassium's decompiler.

local Workspace = game:GetService("Workspace");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AnimationModule = UtilsSystem.AnimationModule;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local u1 = {};
local Action4 = Enum.AnimationPriority.Action4;

function u1.findRuntimeNpcModel(p2) -- Line: 36
    -- upvalues: UtilsSystem (copy), Workspace (copy)
    local SystemLogicalEnemy = UtilsSystem.SystemLogicalEnemy;
    local v3 = SystemLogicalEnemy and SystemLogicalEnemy.GetModel and SystemLogicalEnemy.GetModel(p2);

    if v3 then
        return v3;
    end;

    local LocalMonster = Workspace:FindFirstChild("LocalMonster");

    if LocalMonster then
        local v4 = LocalMonster:FindFirstChild(p2);

        if v4 and v4:IsA("Model") then
            return v4;
        end;
    end;

    local Monster = Workspace:FindFirstChild("Monster");

    if Monster then
        local v5 = Monster:FindFirstChild(p2);

        if v5 and v5:IsA("Model") then
            return v5;
        end;
    end;

    local Summons = Workspace:FindFirstChild("Summons");

    if Summons then
        local v6 = Summons:FindFirstChild(p2);

        if v6 and v6:IsA("Model") then
            return v6;
        end;
    end;

    return nil;
end;

local function _findNpcEntityCfg(p7) -- Line: 78
    -- upvalues: CfgFind (copy), EnumMgr (copy)
    local v8 = p7:GetAttribute("ID");

    if v8 == nil then
        return nil;
    end;

    if p7:GetAttribute("EntityType") == "Summon" then
        return CfgFind.FindCfgByID(v8, EnumMgr.ItemType.SummonedCreature);
    end;

    return CfgFind.FindCfgByID(v8, EnumMgr.ItemType.Enemy);
end;

local function _isForceHitAnimation(p9) -- Line: 95
    -- upvalues: CfgFind (copy), EnumMgr (copy)
    if typeof(p9) ~= "number" then
        return false;
    end;

    local v10 = CfgFind.FindCfgByID(p9, EnumMgr.ItemType.Skill);
    local v11;

    if v10 == nil then
        v11 = false;
    else
        v11 = v10.ForceHitAnimation == "1";
    end;

    return v11;
end;

function u1.canPlay(p12, p13) -- Line: 110
    -- upvalues: CfgFind (copy), EnumMgr (copy), _findNpcEntityCfg (copy)
    if not (p12 and p12.Parent) then
        return false;
    end;

    local v14;

    if typeof(p13) == "number" then
        local v15 = CfgFind.FindCfgByID(p13, EnumMgr.ItemType.Skill);

        if v15 == nil then
            v14 = false;
        else
            v14 = v15.ForceHitAnimation == "1";
        end;
    else
        v14 = false;
    end;

    if v14 then
        return true;
    end;

    local v16 = _findNpcEntityCfg(p12);

    if v16 then
        if v16.hitstunDisabled == 1 then
            return false;
        end;

        if p12:GetAttribute("SkillActionLock") then
            return false;
        end;
    end;

    return true;
end;

function u1.playOnModel(p17, p18) -- Line: 136
    -- upvalues: u1 (copy), AnimationModule (copy), Action4 (copy)
    if not p17 or type(p18) ~= "table" then
        return false;
    end;

    local animName = p18.animName;

    if typeof(animName) ~= "string" or animName == "" then
        return false;
    end;

    if not u1.canPlay(p17, p18.skillid) then
        return false;
    end;

    local v19 = typeof(p18.fadeTime) == "number" and (p18.fadeTime or 0.08) or 0.08;
    local v20 = typeof(p18.speed) == "number" and (p18.speed or 1) or 1;
    AnimationModule.PlayAnimByModel(p17, animName, v20, nil, nil, Action4, v19);

    return true;
end;

function u1.playFromPayload(p21) -- Line: 171
    -- upvalues: u1 (copy)
    if type(p21) ~= "table" then
        return false;
    end;

    local v22;

    if p21.monsterId == nil then
        v22 = nil;
    else
        v22 = tostring(p21.monsterId) or nil;
    end;

    if not v22 then
        return false;
    end;

    local v23 = u1.findRuntimeNpcModel(v22);

    if v23 then
        return u1.playOnModel(v23, p21);
    end;

    return false;
end;

return u1;