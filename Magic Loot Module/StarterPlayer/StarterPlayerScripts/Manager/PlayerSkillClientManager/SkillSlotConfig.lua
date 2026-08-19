-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local PlayerData = UtilsSystem.PlayerData;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local LocalPlayer = UtilsSystem.LocalPlayer;
local u1 = {};
local v2 = UtilsSystem.SystemGameConfig.GetValue("技能系统") or {};
local u3 = v2["技能默认快捷键"] or {};
u1.MAX_SKILL_COUNT = v2 and v2["玩家可掌握技能数"] or 3;
u1.SKILL_SLOT3_PASS_TAG = "SkillSlot3";
u1.DASH_SLOT_INDEX = u1.MAX_SKILL_COUNT + 1;
u1.NORMAL_ATTACK_SLOT_INDEX = u1.MAX_SKILL_COUNT + 2;
u1.BLOCK_SLOT_INDEX = u1.MAX_SKILL_COUNT + 3;
u1.PLAYER_GLOBAL_COOLDOWN_VALUE_NAME = "技能公共冷却结束时间";
local u4 = {};
local u5 = {};
local u6 = {
    leftctrl = "LeftControl",
    rightctrl = "RightControl",
    ctrl = "LeftControl",
    leftshift = "LeftShift",
    rightshift = "RightShift",
    shift = "LeftShift",
    leftalt = "LeftAlt",
    rightalt = "RightAlt",
    alt = "LeftAlt"
};

local function _normalizeKey(p7) -- Line: 58
    if type(p7) ~= "string" then
        return nil;
    end;

    local v8 = string.lower(p7);

    if v8 == "" then
        return nil;
    end;

    return v8;
end;

local function _getPlayerBinds() -- Line: 73
    -- upvalues: PlayerData (copy), LocalPlayer (copy)
    local v9 = PlayerData.GetPlrDataByKey(LocalPlayer, "InputSettings");

    if type(v9) ~= "table" then
        return nil;
    end;

    local binds = v9.binds;

    if type(binds) == "table" then
        return binds;
    end;

    return nil;
end;

local function _resolveBindKey(p10, p11) -- Line: 91
    -- upvalues: PlayerData (copy), LocalPlayer (copy)
    local v12 = PlayerData.GetPlrDataByKey(LocalPlayer, "InputSettings");
    local v13;

    if type(v12) == "table" then
        v13 = v12.binds;

        if type(v13) ~= "table" then
            v13 = nil;
        end;
    else
        v13 = nil;
    end;

    local v14;

    if type(v13) == "table" then
        v14 = v13[p10] or nil;
    else
        v14 = nil;
    end;

    local v15;

    if type(v14) == "string" then
        v15 = string.lower(v14);

        if v15 == "" then
            v15 = nil;
        end;
    else
        v15 = nil;
    end;

    if not v15 then
        if type(p11) ~= "string" then
            return nil;
        end;

        v15 = string.lower(p11);

        if v15 == "" then
            return nil;
        end;
    end;

    return v15;
end;

local function _parseInputKey(p16) -- Line: 107
    -- upvalues: u6 (copy)
    if not p16 then
        return nil, nil;
    end;

    if p16 == "mouse1" or p16 == "mousebutton1" then
        return nil, Enum.UserInputType.MouseButton1;
    end;

    if p16 == "mouse2" or p16 == "mousebutton2" then
        return nil, Enum.UserInputType.MouseButton2;
    end;

    local v17 = u6[p16] or string.upper(p16:sub(1, 1)) .. p16:sub(2);
    local v18 = Enum.KeyCode[v17];

    if v18 then
        return v18, nil;
    end;

    return nil, nil;
end;

function u1.rebuildKeyMap() -- Line: 129
    -- upvalues: u4 (copy), u5 (copy), u1 (copy), u3 (copy), PlayerData (copy), LocalPlayer (copy), _parseInputKey (copy)
    table.clear(u4);
    table.clear(u5);

    for i = 1, u1.MAX_SKILL_COUNT do
        local v19 = u3[i];
        local v20 = "skill_" .. tostring(i);
        local v21 = PlayerData.GetPlrDataByKey(LocalPlayer, "InputSettings");
        local v22;

        if type(v21) == "table" then
            v22 = v21.binds;

            if type(v22) ~= "table" then
                v22 = nil;
            end;
        else
            v22 = nil;
        end;

        local v23;

        if type(v22) == "table" then
            v23 = v22[v20] or nil;
        else
            v23 = nil;
        end;

        local v24;

        if type(v23) == "string" then
            v24 = string.lower(v23);

            if v24 == "" then
                v24 = nil;
            end;
        else
            v24 = nil;
        end;

        if not v24 then
            if type(v19) == "string" then
                v24 = string.lower(v19);

                if v24 == "" then
                    v24 = nil;
                end;
            else
                v24 = nil;
            end;
        end;

        local v25, v26 = _parseInputKey(v24);

        if v25 then
            u4[v25] = i;
        end;

        if v26 then
            u5[v26] = i;
        end;
    end;

    local v27 = PlayerData.GetPlrDataByKey(LocalPlayer, "InputSettings");
    local v28;

    if type(v27) == "table" then
        v28 = v27.binds;

        if type(v28) ~= "table" then
            v28 = nil;
        end;
    else
        v28 = nil;
    end;

    local v29 = type(v28) == "table" and v28.dash or nil;
    local v30;

    if type(v29) == "string" then
        v30 = string.lower(v29);

        if v30 == "" then
            v30 = nil;
        end;
    else
        v30 = nil;
    end;

    if not v30 then
        local v31 = "q";

        if type(v31) == "string" then
            v30 = string.lower(v31);

            if v30 == "" then
                v30 = nil;
            end;
        else
            v30 = nil;
        end;
    end;

    local v32, v33 = _parseInputKey(v30);

    if v32 then
        u4[v32] = u1.DASH_SLOT_INDEX;
    end;

    if v33 then
        u5[v33] = u1.DASH_SLOT_INDEX;
    end;

    local v34 = PlayerData.GetPlrDataByKey(LocalPlayer, "InputSettings");
    local v35;

    if type(v34) == "table" then
        v35 = v34.binds;

        if type(v35) ~= "table" then
            v35 = nil;
        end;
    else
        v35 = nil;
    end;

    local v36 = type(v35) == "table" and v35.block or nil;
    local v37;

    if type(v36) == "string" then
        v37 = string.lower(v36);

        if v37 == "" then
            v37 = nil;
        end;
    else
        v37 = nil;
    end;

    if not v37 then
        local v38 = "f";

        if type(v38) == "string" then
            v37 = string.lower(v38);

            if v37 == "" then
                v37 = nil;
            end;
        else
            v37 = nil;
        end;
    end;

    local v39, v40 = _parseInputKey(v37);

    if v39 then
        u4[v39] = u1.BLOCK_SLOT_INDEX;
    end;

    if v40 then
        u5[v40] = u1.BLOCK_SLOT_INDEX;
    end;

    u5[Enum.UserInputType.MouseButton1] = u1.NORMAL_ATTACK_SLOT_INDEX;
    u4[Enum.KeyCode.ButtonX] = 1;
    u4[Enum.KeyCode.ButtonY] = 2;
    u4[Enum.KeyCode.ButtonB] = 3;
    u4[Enum.KeyCode.ButtonL2] = u1.DASH_SLOT_INDEX;
    u4[Enum.KeyCode.ButtonR1] = u1.BLOCK_SLOT_INDEX;
    u4[Enum.KeyCode.ButtonR2] = u1.NORMAL_ATTACK_SLOT_INDEX;
end;

function u1.getSlotByKeyCode(p41) -- Line: 182
    -- upvalues: u4 (copy)
    return u4[p41];
end;

function u1.getSlotByInputType(p42) -- Line: 191
    -- upvalues: u5 (copy)
    return u5[p42];
end;

function u1.resolveSlotIndex(p43, p44) -- Line: 201
    -- upvalues: u4 (copy), u5 (copy)
    return u4[p43] or u5[p44];
end;

function u1.isActiveSkillSlot(p45) -- Line: 211
    -- upvalues: u1 (copy)
    local v46;

    if type(p45) == "number" and p45 >= 1 then
        v46 = p45 <= u1.MAX_SKILL_COUNT;
    else
        v46 = false;
    end;

    return v46;
end;

function u1.isSlotBlockedByPlayerGlobalCooldown(p47) -- Line: 221
    -- upvalues: u1 (copy)
    return u1.isActiveSkillSlot(p47) and true or p47 == u1.NORMAL_ATTACK_SLOT_INDEX;
end;

function u1.isPlayerGlobalCooldownBlockingSlot(p48) -- Line: 234
    -- upvalues: u1 (copy), LocalPlayer (copy)
    if p48 ~= nil and not u1.isSlotBlockedByPlayerGlobalCooldown(p48) then
        return false;
    end;

    local v49 = LocalPlayer:FindFirstChild(u1.PLAYER_GLOBAL_COOLDOWN_VALUE_NAME);

    if v49 and v49:IsA("NumberValue") then
        return workspace:GetServerTimeNow() < v49.Value;
    end;

    return false;
end;

function u1.resolveGroupSkillName(p50) -- Line: 250
    -- upvalues: CfgFind (copy), EnumMgr (copy)
    if not p50 or p50 <= 0 then
        return nil;
    end;

    local v51 = CfgFind.FindCfgByID(p50, EnumMgr.ItemType.Skill);

    if not v51 then
        return nil;
    end;

    local ScriptName = v51.ScriptName;

    if type(ScriptName) == "string" and ScriptName ~= "" then
        return ScriptName;
    end;

    return nil;
end;

function u1.normalizeUpdateKey(p52) -- Line: 270
    if p52 == nil then
        return nil;
    end;

    if type(p52) == "string" then
        return p52;
    end;

    if type(p52) == "table" then
        return p52[1];
    end;

    return nil;
end;

u1.rebuildKeyMap();

return u1;