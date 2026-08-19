-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;

if not UtilsSystem.WorldUtil.IsDebugEnabled() then
    return;
end;

local ModuleScript = game.ReplicatedStorage.ClientSideCode.GuiScripts.ModuleScript;
local DebugSystem = require(ModuleScript.DebugSystem);
local PotionBrewingGame = require(ModuleScript.PotionBrewingGame);
local LocalPlayer = game:GetService("Players").LocalPlayer;
local PlayerSkillControlHub = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Manager"):WaitForChild("PlayerSkillClientManager"):WaitForChild("PlayerSkillControlHub"));
local u1 = true;

local function _refreshAutoAttackButtonLabel() -- Line: 55
    -- upvalues: u1 (ref), DebugSystem (copy)
    DebugSystem.SetButtonText("开关自动攻击", u1 and "自动攻击: 开" or "自动攻击: 关");
end;

local v2 = {
    {
        {
            Name = "获得所有材料"
        },

        function() -- Line: 63
            -- upvalues: NetWork (copy), NetMsg (copy)
            NetWork.FireServer(NetMsg.DEBUG_BAG, {
                msgType = 4
            });
        end
    },
    {
        {
            Name = "获得所有药水"
        },

        function() -- Line: 69
            -- upvalues: NetWork (copy), NetMsg (copy)
            NetWork.FireServer(NetMsg.DEBUG_BAG, {
                msgType = 5
            });
        end
    },
    {
        {
            Name = "修改记录",
            Param1Name = "记录名称",
            Param2Name = "修改值"
        },

        function() -- Line: 75
            -- upvalues: NetWork (copy), NetMsg (copy), DebugSystem (copy)
            NetWork.FireServer(NetMsg.DEBUG_SPECIAL, "修改记录", { DebugSystem.GetButtonParam1("修改记录"), DebugSystem.GetButtonParam2("修改记录") });
        end
    },
    {
        {
            Name = "刷私有怪",
            Param1Name = "怪物ID",
            Param2Name = "白名单玩家ID"
        },

        function() -- Line: 84
            -- upvalues: NetWork (copy), NetMsg (copy), DebugSystem (copy)
            NetWork.FireServer(NetMsg.DEBUG_SPECIAL, "刷私有怪", { DebugSystem.GetButtonParam1("刷私有怪"), DebugSystem.GetButtonParam2("刷私有怪") });
        end
    },
    {
        {
            Name = "刷新全部变异怪"
        },

        function() -- Line: 93
            -- upvalues: NetWork (copy), NetMsg (copy)
            NetWork.FireServer(NetMsg.DEBUG_SPECIAL, "刷新全部变异怪", {});
        end
    },
    {
        {
            Name = "初始化角色数据"
        },

        function() -- Line: 99
            -- upvalues: NetWork (copy), NetMsg (copy)
            NetWork.FireServer(NetMsg.DEBUG_RESET);
        end
    },
    {
        {
            Name = "测试炼金表现"
        },

        function() -- Line: 105
            -- upvalues: PotionBrewingGame (copy)
            PotionBrewingGame.StartFromCraftPresent({
                recipeId = 0,
                potionId = 0,
                materials = { {
                        id = 2010001,
                        count = 2
                    } }
            });
        end
    },
    {
        {
            Name = "结束炼制等待"
        },

        function() -- Line: 117
            -- upvalues: NetWork (copy), NetMsg (copy)
            NetWork.FireServer(NetMsg.DEBUG_SPECIAL, "结束炼制等待", {});
        end
    },
    {
        {
            Name = "开关自动攻击"
        },

        function() -- Line: 123
            -- upvalues: u1 (ref), PlayerSkillControlHub (copy), DebugSystem (copy)
            u1 = not u1;
            PlayerSkillControlHub.setDebugAutoAttackEnabled(u1);
            DebugSystem.SetButtonText("开关自动攻击", u1 and "自动攻击: 开" or "自动攻击: 关");
        end
    },
    {
        {
            Name = "设置超高血量"
        },

        function() -- Line: 131
            -- upvalues: NetWork (copy), NetMsg (copy)
            NetWork.FireServer(NetMsg.DEBUG_SPECIAL, "设置血量", {});
        end
    },
    {
        {
            Name = "修改属性",
            Param1Name = "属性ID或名称",
            Param2Name = "属性值"
        },

        function() -- Line: 137
            -- upvalues: NetWork (copy), NetMsg (copy), DebugSystem (copy)
            NetWork.FireServer(NetMsg.DEBUG_SPECIAL, "修改属性", { DebugSystem.GetButtonParam1("修改属性"), DebugSystem.GetButtonParam2("修改属性") });
        end
    },
    {
        {
            Name = "增加在线时长",
            Param1Name = "秒数"
        },

        function() -- Line: 146
            -- upvalues: NetWork (copy), NetMsg (copy), DebugSystem (copy)
            NetWork.FireServer(NetMsg.DEBUG_SPECIAL, "增加在线时长", { DebugSystem.GetButtonParam1("增加在线时长") });
        end
    },
    {
        {
            Name = "重置在线奖励"
        },

        function() -- Line: 154
            -- upvalues: NetWork (copy), NetMsg (copy)
            NetWork.FireServer(NetMsg.DEBUG_SPECIAL, "重置在线奖励", {});
        end
    },
    {
        {
            Name = "重置每日签到"
        },

        function() -- Line: 160
            -- upvalues: NetWork (copy), NetMsg (copy)
            NetWork.FireServer(NetMsg.DEBUG_SPECIAL, "重置每日签到", {});
        end
    },
    {
        {
            Name = "设置签到日期",
            Param1Name = "天数"
        },

        function() -- Line: 166
            -- upvalues: NetWork (copy), NetMsg (copy), DebugSystem (copy)
            NetWork.FireServer(NetMsg.DEBUG_SPECIAL, "设置签到日期", { DebugSystem.GetButtonParam1("设置签到日期") });
        end
    },
    {
        {
            Name = "打开Login UI"
        },

        function() -- Line: 174
            -- upvalues: NetWork (copy), NetMsg (copy)
            NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "Login", nil, true, true);
        end
    },
    {
        {
            Name = "解锁技能槽3"
        },

        function() -- Line: 180
            -- upvalues: NetWork (copy), NetMsg (copy)
            NetWork.FireServer(NetMsg.DEBUG_SPECIAL, "解锁技能槽3", {});
        end
    }
};
DebugSystem.OnAddClick(function() -- Line: 186
    -- upvalues: DebugSystem (copy), NetWork (copy), NetMsg (copy)
    local v3 = {
        msgType = 1,
        itemID = tonumber(DebugSystem.GetID()),
        itemCount = tonumber(DebugSystem.GetAmount())
    };
    NetWork.FireServer(NetMsg.DEBUG_BAG, v3);
end);
DebugSystem.OnReduceClick(function() -- Line: 195
    -- upvalues: DebugSystem (copy), NetWork (copy), NetMsg (copy)
    local v4 = {
        msgType = 2,
        itemID = tonumber(DebugSystem.GetID()),
        itemCount = tonumber(DebugSystem.GetAmount())
    };
    NetWork.FireServer(NetMsg.DEBUG_BAG, v4);
end);
DebugSystem.OnClearClick(function() -- Line: 204
    -- upvalues: DebugSystem (copy), NetWork (copy), NetMsg (copy)
    local v5 = {
        msgType = 3,
        itemID = tonumber(DebugSystem.GetID())
    };
    NetWork.FireServer(NetMsg.DEBUG_BAG, v5);
end);
DebugSystem.OnEquipSkillClick(function() -- Line: 212
    -- upvalues: NetWork (copy), NetMsg (copy), DebugSystem (copy)
    NetWork.FireServer(NetMsg.DEBUG_SPECIAL, "装备技能", { DebugSystem.GetSkillSlot1ID(), DebugSystem.GetSkillSlot2ID(), DebugSystem.GetSkillSlot3ID() });
end);
DebugSystem.OnUnequipSkillClick(function() -- Line: 220
    -- upvalues: NetWork (copy), NetMsg (copy)
    NetWork.FireServer(NetMsg.DEBUG_SPECIAL, "卸下技能", {});
end);

for _, v in pairs(v2) do
    DebugSystem.AddButton(v[1], v[2]);
end;

DebugSystem.SetButtonParam2("刷私有怪", (tostring(LocalPlayer.UserId)));
DebugSystem.SetButtonParam1("增加在线时长", "3600");
DebugSystem.SetButtonParam1("设置签到日期", "1");
DebugSystem.SetButtonText("开关自动攻击", u1 and "自动攻击: 开" or "自动攻击: 关");