-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local GroupSkillClient = UtilsSystem.GroupSkillClient;
local _ = UtilsSystem.PlayerData;
local AddListen = UtilsSystem.AddListen;
local LocalPlayer = UtilsSystem.LocalPlayer;
local ResourceUtil = UtilsSystem.ResourceUtil;
local PlayerSkillContext = require(script.Parent.PlayerSkillContext);
local SkillSlotConfig = require(script.Parent.SkillSlotConfig);
local v1 = {};
local u2 = 0;

local function _destroyBindingState() -- Line: 30
    -- upvalues: PlayerSkillContext (copy)
    for _, v in PlayerSkillContext.skillSlotListenConnections do
        if v and v.Connected then
            v:Disconnect();
        end;
    end;

    table.clear(PlayerSkillContext.skillSlotListenConnections);

    for _, v in PlayerSkillContext.localPlayerSkill do
        v:destroy();
    end;

    table.clear(PlayerSkillContext.localPlayerSkill);
end;

local function _bindSkill(p3, p4, p5, p6, p7) -- Line: 51
    -- upvalues: PlayerSkillContext (copy), GroupSkillClient (copy), ResourceUtil (copy)
    local v8 = PlayerSkillContext.localPlayerSkill[p4];

    if v8 and v8.skillName == p3 then
        if p7 then
            v8.skillID = p7;
        end;

        return;
    end;

    if v8 then
        v8:destroy();
        PlayerSkillContext.localPlayerSkill[p4] = nil;
    end;

    local v9 = GroupSkillClient.new(p3, p4, p5, p6, p7);

    if v9 then
        task.defer(ResourceUtil.PreloadSkill, p3);
        PlayerSkillContext.localPlayerSkill[p4] = v9;

        return;
    end;

    PlayerSkillContext.localPlayerSkill[p4] = nil;
    warn("绑定技能组失败（模块不存在或加载失败）", p3, p4, p5, p6);
end;

local function _unbindSkill(p10) -- Line: 84
    -- upvalues: PlayerSkillContext (copy)
    local v11 = PlayerSkillContext.localPlayerSkill[p10];

    if v11 then
        v11:destroy();
        PlayerSkillContext.localPlayerSkill[p10] = nil;
    end;
end;

local function _bindSkillByID(p12, p13) -- Line: 97
    -- upvalues: SkillSlotConfig (copy), _bindSkill (copy), LocalPlayer (copy), PlayerSkillContext (copy)
    local v14 = SkillSlotConfig.resolveGroupSkillName(p12);

    if v14 then
        _bindSkill(v14, p13, LocalPlayer.UserId, "Player", p12);

        return;
    end;

    local v15 = PlayerSkillContext.localPlayerSkill[p13];

    if v15 then
        v15:destroy();
        PlayerSkillContext.localPlayerSkill[p13] = nil;
    end;
end;

function v1.destroyAll() -- Line: 109
    -- upvalues: u2 (ref), _destroyBindingState (copy)
    u2 = u2 + 1;
    _destroyBindingState();
end;

function v1.initFromNumberValues() -- Line: 118
    -- upvalues: u2 (ref), _destroyBindingState (copy), LocalPlayer (copy), SkillSlotConfig (copy), _bindSkill (copy), PlayerSkillContext (copy), AddListen (copy)
    u2 = u2 + 1;
    local v16 = u2;
    _destroyBindingState();
    local v17 = LocalPlayer:WaitForChild("技能相关", (1 / 0));

    if v16 ~= u2 then
        return;
    end;

    for i = 1, SkillSlotConfig.MAX_SKILL_COUNT do
        local v18 = v17:WaitForChild("Skill" .. tostring(i), (1 / 0));

        if v16 ~= u2 then
            return;
        end;

        local Value = v18.Value;
        local v19 = SkillSlotConfig.resolveGroupSkillName(Value);

        if v19 then
            _bindSkill(v19, i, LocalPlayer.UserId, "Player", Value);
        else
            local v20 = PlayerSkillContext.localPlayerSkill[i];

            if v20 then
                v20:destroy();
                PlayerSkillContext.localPlayerSkill[i] = nil;
            end;
        end;

        local v25 = AddListen.NumValueAdd(v18, function(p21) -- Line: 137
            -- upvalues: i (copy), SkillSlotConfig (ref), _bindSkill (ref), LocalPlayer (ref), PlayerSkillContext (ref)
            local v22 = i;
            local v23 = SkillSlotConfig.resolveGroupSkillName(p21);

            if v23 then
                _bindSkill(v23, v22, LocalPlayer.UserId, "Player", p21);

                return;
            end;

            local v24 = PlayerSkillContext.localPlayerSkill[v22];

            if v24 then
                v24:destroy();
                PlayerSkillContext.localPlayerSkill[v22] = nil;
            end;
        end);
        table.insert(PlayerSkillContext.skillSlotListenConnections, v25);
    end;

    local Dash = v17:WaitForChild("Dash", (1 / 0));

    if v16 ~= u2 then
        return;
    end;

    local Value = Dash.Value;
    local DASH_SLOT_INDEX = SkillSlotConfig.DASH_SLOT_INDEX;
    local v26 = SkillSlotConfig.resolveGroupSkillName(Value);

    if v26 then
        _bindSkill(v26, DASH_SLOT_INDEX, LocalPlayer.UserId, "Player", Value);
    else
        local v27 = PlayerSkillContext.localPlayerSkill[DASH_SLOT_INDEX];

        if v27 then
            v27:destroy();
            PlayerSkillContext.localPlayerSkill[DASH_SLOT_INDEX] = nil;
        end;
    end;

    table.insert(PlayerSkillContext.skillSlotListenConnections, AddListen.NumValueAdd(Dash, function(p28) -- Line: 150
        -- upvalues: SkillSlotConfig (ref), _bindSkill (ref), LocalPlayer (ref), PlayerSkillContext (ref)
        local DASH_SLOT_INDEX2 = SkillSlotConfig.DASH_SLOT_INDEX;
        local v29 = SkillSlotConfig.resolveGroupSkillName(p28);

        if v29 then
            _bindSkill(v29, DASH_SLOT_INDEX2, LocalPlayer.UserId, "Player", p28);

            return;
        end;

        local v30 = PlayerSkillContext.localPlayerSkill[DASH_SLOT_INDEX2];

        if v30 then
            v30:destroy();
            PlayerSkillContext.localPlayerSkill[DASH_SLOT_INDEX2] = nil;
        end;
    end));
    local NormalAtk = v17:WaitForChild("NormalAtk", (1 / 0));

    if v16 ~= u2 then
        return;
    end;

    local Value2 = NormalAtk.Value;
    local NORMAL_ATTACK_SLOT_INDEX = SkillSlotConfig.NORMAL_ATTACK_SLOT_INDEX;
    local v31 = SkillSlotConfig.resolveGroupSkillName(Value2);

    if v31 then
        _bindSkill(v31, NORMAL_ATTACK_SLOT_INDEX, LocalPlayer.UserId, "Player", Value2);
    else
        local v32 = PlayerSkillContext.localPlayerSkill[NORMAL_ATTACK_SLOT_INDEX];

        if v32 then
            v32:destroy();
            PlayerSkillContext.localPlayerSkill[NORMAL_ATTACK_SLOT_INDEX] = nil;
        end;
    end;

    table.insert(PlayerSkillContext.skillSlotListenConnections, AddListen.NumValueAdd(NormalAtk, function(p33) -- Line: 162
        -- upvalues: SkillSlotConfig (ref), _bindSkill (ref), LocalPlayer (ref), PlayerSkillContext (ref)
        local NORMAL_ATTACK_SLOT_INDEX2 = SkillSlotConfig.NORMAL_ATTACK_SLOT_INDEX;
        local v34 = SkillSlotConfig.resolveGroupSkillName(p33);

        if v34 then
            _bindSkill(v34, NORMAL_ATTACK_SLOT_INDEX2, LocalPlayer.UserId, "Player", p33);

            return;
        end;

        local v35 = PlayerSkillContext.localPlayerSkill[NORMAL_ATTACK_SLOT_INDEX2];

        if v35 then
            v35:destroy();
            PlayerSkillContext.localPlayerSkill[NORMAL_ATTACK_SLOT_INDEX2] = nil;
        end;
    end));
    local Block = v17:WaitForChild("Block", (1 / 0));

    if v16 ~= u2 then
        return;
    end;

    local Value3 = Block.Value;
    local BLOCK_SLOT_INDEX = SkillSlotConfig.BLOCK_SLOT_INDEX;
    local v36 = SkillSlotConfig.resolveGroupSkillName(Value3);

    if v36 then
        _bindSkill(v36, BLOCK_SLOT_INDEX, LocalPlayer.UserId, "Player", Value3);
    else
        local v37 = PlayerSkillContext.localPlayerSkill[BLOCK_SLOT_INDEX];

        if v37 then
            v37:destroy();
            PlayerSkillContext.localPlayerSkill[BLOCK_SLOT_INDEX] = nil;
        end;
    end;

    table.insert(PlayerSkillContext.skillSlotListenConnections, AddListen.NumValueAdd(Block, function(p38) -- Line: 174
        -- upvalues: SkillSlotConfig (ref), _bindSkill (ref), LocalPlayer (ref), PlayerSkillContext (ref)
        local BLOCK_SLOT_INDEX2 = SkillSlotConfig.BLOCK_SLOT_INDEX;
        local v39 = SkillSlotConfig.resolveGroupSkillName(p38);

        if v39 then
            _bindSkill(v39, BLOCK_SLOT_INDEX2, LocalPlayer.UserId, "Player", p38);

            return;
        end;

        local v40 = PlayerSkillContext.localPlayerSkill[BLOCK_SLOT_INDEX2];

        if v40 then
            v40:destroy();
            PlayerSkillContext.localPlayerSkill[BLOCK_SLOT_INDEX2] = nil;
        end;
    end));
end;

function v1.syncSkillPotencyFromPlayerData() -- Line: 183
end;

return v1;