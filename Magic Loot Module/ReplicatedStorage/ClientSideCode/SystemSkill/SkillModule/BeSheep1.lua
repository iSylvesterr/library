-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
local SkillBuffUtil = UtilsSystem.SkillBuffUtil;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local SystemDungeon = UtilsSystem.SystemDungeon;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Space,
    InitialState = "Apply",
    ControlOpenState = "Apply",
    States = {
        Apply = {
            Duration = 0.5,
            OnEnterClient = "Client_EnterApply",
            OnEnterServer = "Server_EnterApply",
            OnExitClient = nil,
            OnExitServer = nil
        },
        Recovery = {
            Duration = 0.05,
            OnEnterClient = "Client_EnterRecovery",
            OnEnterServer = "Server_EnterRecovery",
            OnExitClient = nil,
            OnExitServer = nil
        },
        Finished = {
            Duration = 0,
            IsTerminal = true
        },
        Interrupted = {
            Duration = 0,
            IsTerminal = true
        }
    },
    Transitions = {
        {
            From = "Apply",
            To = "Recovery",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Recovery",
            To = "Finished",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Apply",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Apply",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "Recovery",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        }
    }
};

local function _resolveBeSheepBuffInstId(p2) -- Line: 77
    -- upvalues: CfgFind (copy), EnumMgr (copy)
    local v3 = tonumber(p2);

    if v3 and v3 > 0 then
        local v4 = CfgFind.FindCfgByID(v3, EnumMgr.ItemType.Skill);

        if v4 then
            v4 = v4.buffs;
        end;

        if type(v4) == "table" then
            local v5 = tonumber(v4[1]);

            if v5 and v5 > 0 then
                return v5;
            end;
        end;
    end;

    return 18000013;
end;

local function _getClientStageId(p6) -- Line: 97
    local DungeonAggroStage = p6:FindFirstChild("DungeonAggroStage");

    if DungeonAggroStage and (DungeonAggroStage:IsA("NumberValue") and DungeonAggroStage.Value > 0) then
        return DungeonAggroStage.Value;
    end;

    local InDungeonChallenge = p6:FindFirstChild("InDungeonChallenge");

    return (not InDungeonChallenge or (not InDungeonChallenge:IsA("NumberValue") or InDungeonChallenge.Value <= 0)) and 0 or InDungeonChallenge.Value;
end;

local function _disconnectProcListen(p7) -- Line: 113
    local skillRunData = p7.skillRunData;

    if not skillRunData then
        return;
    end;

    local _beSheepProcConn = skillRunData._beSheepProcConn;

    if _beSheepProcConn then
        _beSheepProcConn:Disconnect();
        skillRunData._beSheepProcConn = nil;
    end;
end;

local function _listenProcAndPlaySuccessFx(u8) -- Line: 129
    -- upvalues: SkillBuffUtil (copy)
    local u9 = u8.skillInputData and u8.skillInputData.character;

    if not u9 then
        return;
    end;

    local u10 = false;

    local function tryPlay() -- Line: 136
        -- upvalues: u10 (ref), u9 (copy), u8 (copy), SkillBuffUtil (ref)
        if u10 then
            return;
        end;

        if u9:GetAttribute("BeSheepProc") == nil then
            return;
        end;

        u10 = true;
        local skillRunData = u8.skillRunData;
        local v11 = skillRunData and skillRunData._beSheepProcConn;

        if v11 then
            v11:Disconnect();
            skillRunData._beSheepProcConn = nil;
        end;

        local skillRunData2 = u8.skillRunData;

        if skillRunData2 then
            skillRunData2 = skillRunData2.material;
        end;

        SkillBuffUtil.PlayBeSheepCasterSuccessFxFromMaterial(skillRunData2, u9);
    end;

    if not u10 and u9:GetAttribute("BeSheepProc") ~= nil then
        u10 = true;
        local skillRunData = u8.skillRunData;
        local v12 = skillRunData and skillRunData._beSheepProcConn;

        if v12 then
            v12:Disconnect();
            skillRunData._beSheepProcConn = nil;
        end;

        local skillRunData2 = u8.skillRunData;

        if skillRunData2 then
            skillRunData2 = skillRunData2.material;
        end;

        SkillBuffUtil.PlayBeSheepCasterSuccessFxFromMaterial(skillRunData2, u9);
    end;

    if u10 then
        return;
    end;

    local skillRunData = u8.skillRunData;

    if not skillRunData then
        return;
    end;

    skillRunData._beSheepProcConn = u9:GetAttributeChangedSignal("BeSheepProc"):Connect(tryPlay);
    task.delay(2, function() -- Line: 159
        -- upvalues: u8 (copy)
        local skillRunData2 = u8.skillRunData;

        if not skillRunData2 then
            return;
        end;

        local _beSheepProcConn = skillRunData2._beSheepProcConn;

        if _beSheepProcConn then
            _beSheepProcConn:Disconnect();
            skillRunData2._beSheepProcConn = nil;
        end;
    end);
end;

local function _markProcSuccess(u13) -- Line: 168
    -- upvalues: Workspace (copy)
    u13:SetAttribute("BeSheepProc", Workspace:GetServerTimeNow());
    task.delay(2, function() -- Line: 170
        -- upvalues: u13 (copy)
        if u13.Parent then
            u13:SetAttribute("BeSheepProc", nil);
        end;
    end);
end;

local function _tryApplyBeSheepToStage(p14) -- Line: 181
    -- upvalues: Players (copy), _getClientStageId (copy), SystemDungeon (copy), SkillBuffUtil (copy), CfgFind (copy), EnumMgr (copy), Workspace (copy)
    local u15 = p14.skillInputData and p14.skillInputData.character;

    if not u15 then
        return;
    end;

    local v16 = Players:GetPlayerFromCharacter(u15);

    if not v16 then
        return;
    end;

    local v17 = _getClientStageId(v16);

    if v17 <= 0 then
        return;
    end;

    if SystemDungeon.isStageChecked(v16, v17) then
        return;
    end;

    SystemDungeon.markStageChecked(v16, v17);
    local v18 = SystemDungeon.GetAliveStageEnemies(v16);
    local v19 = {};

    for _, v in ipairs(v18) do
        if not (SkillBuffUtil.IsPolymorphActive(v) or SkillBuffUtil.IsBeSheepExcludedTarget(v)) then
            table.insert(v19, v);
        end;
    end;

    if #v19 == 0 then
        return;
    end;

    local v20 = tonumber(p14.skillID);
    local v21;

    if v20 and v20 > 0 then
        local v22 = CfgFind.FindCfgByID(v20, EnumMgr.ItemType.Skill);

        if v22 then
            v22 = v22.buffs;
        end;

        if type(v22) == "table" then
            local v23 = tonumber(v22[1]);
            v21 = (not v23 or v23 <= 0) and 18000013 or v23;
        else
            v21 = 18000013;
        end;
    else
        v21 = 18000013;
    end;

    local v24 = SkillBuffUtil.GetProcChanceFromBuffInst(v21);

    if type(v24) ~= "number" or v24 <= 0 then
        return;
    end;

    if v24 < math.random() then
        return;
    end;

    u15:SetAttribute("BeSheepProc", Workspace:GetServerTimeNow());
    task.delay(2, function() -- Line: 170
        -- upvalues: u15 (copy)
        if u15.Parent then
            u15:SetAttribute("BeSheepProc", nil);
        end;
    end);
    local v25 = tonumber(p14.skillID) or 0;
    local v26 = {
        attacker = v16,
        casterUserId = v16.UserId,
        attackerPlayerId = v16.UserId
    };

    for _, v in ipairs(v19) do
        if v.Parent then
            SkillBuffUtil.TryApplyBeSheepToEnemy(v, v25, v26, nil);
        end;
    end;
end;

local function _registerPerStageReset(p27, u28) -- Line: 242
    -- upvalues: SystemDungeon (copy)
    SystemDungeon.registerStageCallback(p27, "BeSheep_CdReset", function(p29, p30) -- Line: 243
        -- upvalues: u28 (copy)
        local v31 = p29:FindFirstChild("技能CD时间戳");

        if v31 and v31:IsA("Folder") then
            local v32 = v31:FindFirstChild("Slot" .. tostring(u28));

            if v32 and v32:IsA("NumberValue") then
                v32.Value = 0;
            end;
        end;
    end);
    SystemDungeon.registerCdSlot(p27, u28);
end;

function v1.Client_EnterApply(p33) -- Line: 256
    -- upvalues: _listenProcAndPlaySuccessFx (copy)
    _listenProcAndPlaySuccessFx(p33);
end;

function v1.Server_EnterApply(p34) -- Line: 260
    -- upvalues: _tryApplyBeSheepToStage (copy), Players (copy), SystemDungeon (copy)
    _tryApplyBeSheepToStage(p34);
    local v35 = p34.skillInputData and p34.skillInputData.character;
    local v36 = v35 and Players:GetPlayerFromCharacter(v35);

    if v36 then
        local u37 = p34.skillInputData and p34.skillInputData.slotIndex;

        if type(u37) == "number" and u37 > 0 then
            SystemDungeon.registerStageCallback(v36, "BeSheep_CdReset", function(p38, p39) -- Line: 243
                -- upvalues: u37 (copy)
                local v40 = p38:FindFirstChild("技能CD时间戳");

                if v40 and v40:IsA("Folder") then
                    local v41 = v40:FindFirstChild("Slot" .. tostring(u37));

                    if v41 and v41:IsA("NumberValue") then
                        v41.Value = 0;
                    end;
                end;
            end);
            SystemDungeon.registerCdSlot(v36, u37);
        end;
    end;
end;

function v1.Server_EnterRecovery(p42) -- Line: 277
    p42:releaseControl();
end;

function v1.Client_EnterRecovery(p43) -- Line: 281
    local skillRunData = p43.skillRunData;

    if not skillRunData then
        return;
    end;

    local _beSheepProcConn = skillRunData._beSheepProcConn;

    if _beSheepProcConn then
        _beSheepProcConn:Disconnect();
        skillRunData._beSheepProcConn = nil;
    end;
end;

v1.SoundList = {};
v1.AnimateList = {};
v1.ResNameList = { "变羊术_成功特效", "变羊_羊出现特效" };
v1.hitboxConfig = {};
v1.Action = {};

return v1;