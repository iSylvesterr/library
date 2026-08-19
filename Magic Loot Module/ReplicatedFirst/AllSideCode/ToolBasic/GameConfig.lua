-- Decompiled with Potassium's decompiler.

local v1 = {
    ["版本号"] = 1.13,
    DataStore = "Data",
    Dungeon = {
        ["怪物刷新CD"] = 30,
        ["变异怪刷新时间"] = { 10, 10, 30 },
        ["变异怪存在时间"] = 5,
        ["前门UI距离淡出"] = {
            ["完全透明距离"] = 16,
            ["完全不透明距离"] = 36
        },
        ["掉落表现"] = {
            ["抛物线高度"] = 6,
            ["抛物线时长"] = 0.6,
            ["浮动幅度"] = 0.12,
            ["浮动周期"] = 2.5,
            ["旋转速度"] = 45,
            ["表面间隙"] = 0.08,
            ["拾取时长"] = 0.5
        }
    },
    CharacterMoveSpeed = {
        ["玩家行走移动速度"] = 16,
        ["玩家奔跑移动速度"] = 24
    },
    FootStep = {
        ["启用"] = true
    },
    Bgm = {
        ["启用"] = true,
        ["默认BGM"] = "BGM1",
        ["区域标签"] = "BGMArea",
        ["区域BGM属性"] = "BGM",
        ["淡入淡出秒"] = 2,
        ["检测间隔秒"] = 0.5,
        ["区域边界容差"] = 0.001
    },
    Setting = {
        ["启用"] = true,
        ["音量渐变秒"] = 0.5
    },
    Clock = {
        ["启用"] = true
    },
    SmartBone = {
        ["启用"] = true
    },
    Broom = {
        ["启用"] = true
    },
    CameraModule = {
        ["默认视野角度"] = 60
    },
    ["群组设置"] = {
        ["群组ID"] = 0
    },
    Event = {
        TicketIntervalSec = 900,
        TicketDailyMax = 3,
        TimedTaskResetSec = 3600,
        MaxTasksPerResetType = 3,
        OnceTaskRefill = false,
        ForceActive = false
    },
    ["每日签到"] = {
        ["每日签到最大天数"] = 7
    },
    AFK = {
        ["挂机超时秒"] = 1080,
        ["空闲重置秒"] = 60
    },
    Feedback = {
        ["Webhook网址"] = "https://discord.com/api/webhooks/1527550437027217468/tvRUKpdD37wIN8EGxbGJPr70hFu8tohXgeekaV6OISjZ6Z6errKOB27t2O14SgjaCOU8",
        ["反馈CD分钟"] = 5
    },
    ["战斗数值"] = {
        ["魔法护盾减伤倍率"] = 0.5,
        ["荆棘反伤攻击力系数"] = 1
    },
    ["装备"] = {
        ["初始魔杖ID"] = 6000001,
        ["槽位武器手持缩放"] = 1,
        ["槽位武器背挂缩放"] = 0.6,
        ["拿出武器到手部延迟秒"] = 0.35
    },
    ["付费药水展示"] = {
        ["循环空档秒"] = 0.5,
        ["展示魔杖ID"] = 6000001,
        ["技能目标前方偏移"] = 10,
        ["地面未命中下偏"] = 2.5,
        ["购买提示文案"] = "购买",
        ["购买交互距离"] = 12
    },
    ["背包配置"] = {
        ["仓库上限"] = 999,
        ["工具栏快捷槽数"] = 8
    },
    ["技能系统"] = {
        ["玩家可掌握技能数"] = 3,
        ["玩家可掌握普攻数"] = 1,
        ["玩家公共冷却秒"] = 0.5,
        ["默认普攻技能ID"] = 10000001,
        ["默认冲刺技能ID"] = 10000002,
        ["默认格挡技能ID"] = 10000003,
        ["闪避"] = {
            ["无敌时间"] = 0.5
        },
        ["命中物理"] = {
            ["怪物对玩家击退"] = false
        },
        ["技能默认快捷键"] = { "e", "r", "t" }
    },
    ["怪物配置"] = {
        CD = 1,
        useLogicalPrivateEnemy = true,
        MonsterEgg = {
            default = {
                eggInitHpRatio = 0.5,
                eggRegenPerSec = 1,
                eggMaxDamagePerHit = 1,
                eggScaleTweenSec = 0.6,
                hatchSummonSkillKey = "SpiderEgg_Hatch",
                hatchMaxCount = 8,
                eggHatchIds = { 5040001, 5040003 },
                eggHatchWeights = { 50, 50 },
                eggStageScales = { 0.5, 0.75, 1 }
            },
            [5040008] = {}
        },
        hitParticipationTimeoutSeconds = 10,
        deathFleeDurationSeconds = 2,
        deathFleeFadeDelaySeconds = 1,
        deathFleeWalkSpeed = 12
    },
    ["训练系统"] = {
        ["魔力速度档位"] = { {
                minPower = 0,
                maxPower = 427549,
                animSpeedMul = 3
            }, {
                minPower = 427549,
                maxPower = 386880449,
                animSpeedMul = 6
            }, {
                minPower = 386880449,
                maxPower = 3379785780449,
                animSpeedMul = 9
            }, {
                minPower = 3379785780449,
                maxPower = (1 / 0),
                animSpeedMul = 10
            } },
        ["水晶旋转速度上限"] = 10,
        ["水晶旋转档位"] = { {
                ["魔力下限"] = 0,
                ["魔力上限"] = 4094,
                ["上限角速度度每秒"] = 600
            }, {
                ["魔力下限"] = 4094,
                ["魔力上限"] = 427549,
                ["上限角速度度每秒"] = 1200
            }, {
                ["魔力下限"] = 427549,
                ["魔力上限"] = 386880449,
                ["上限角速度度每秒"] = 2400
            }, {
                ["魔力下限"] = 386880449,
                ["魔力上限"] = 3379785780449,
                ["上限角速度度每秒"] = 4800
            }, {
                ["魔力下限"] = 3379785780449,
                ["魔力上限"] = (1 / 0),
                ["上限角速度度每秒"] = 7200
            } },
        ["水晶旋转地板比例"] = 0.05,
        ["水晶命中冲量比例"] = 0.8,
        ["水晶旋转半衰期秒"] = 0.2,
        ["水晶超上限持续秒"] = 0.1,
        ["水晶命中目标随机偏移"] = 3,
        ["训练手动派生缓冲秒"] = 0.25,
        ["水晶浮动幅度"] = 0.35,
        ["水晶浮动周期"] = 2,
        ["点屏最大频率"] = 15,
        ["训练场结算间隔秒"] = 0.5,
        ["飘字停留秒"] = 0.5,
        ["飘字淡出秒"] = 0.25,
        ["训练提升通行证"] = {
            x2Power = 2,
            x4Power = 4,
            x8Power = 8,
            x16Power = 16,
            x32Power = 32,
            x64Power = 64
        },
        ["付费力量包"] = {
            Power1 = 1000000,
            Power2 = 10000000,
            Power3 = 100000000,
            Power4 = 1000000000
        }
    },
    ["付费商店"] = {
        ["付费材料稀有度"] = {
            RobuxMaterial1 = 7,
            RobuxMaterial2 = 8,
            RobuxMaterial3 = 9
        }
    },
    ["离线收益"] = {
        ["离线收益上限"] = 10800,
        ["离线训练每秒次数"] = 1,
        ["离线金币时间单位秒"] = 600,
        ["离线金币保底材料ID"] = 2010001
    }
};

local function _isPlayerInDungeon(p2) -- Line: 270
    local InDungeonChallenge = p2:FindFirstChild("InDungeonChallenge");

    if InDungeonChallenge and (InDungeonChallenge:IsA("NumberValue") and InDungeonChallenge.Value > 0) then
        return true;
    end;

    local StageJumping = p2:FindFirstChild("StageJumping");

    return StageJumping and (StageJumping:IsA("NumberValue") and StageJumping.Value > 0) and true or false;
end;

local function _hasSellableLoot(p3) -- Line: 288
    local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
    local ItemType = UtilsSystem.EnumMgr.ItemType;
    local v4 = UtilsSystem.PlayerData.GetPlrDataByKey(p3, "Bag");

    if type(v4) ~= "table" then
        return false;
    end;

    for _, v in pairs(v4) do
        if type(v) == "table" and tonumber(v.tp) == ItemType.Material then
            local lock = v.lock;

            if lock ~= 1 and lock ~= true then
                return true;
            end;
        end;
    end;

    return false;
end;

local function _canAffordWeapon(p5, p6) -- Line: 315
    local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
    local GetData = UtilsSystem.GetData;
    local EnumMgr = UtilsSystem.EnumMgr;
    local v7 = UtilsSystem.EquipShop.FindShopCfg(p6, EnumMgr.ItemType.Weapon);

    if v7 then
        v7 = v7.Price;
    end;

    local v8 = tonumber(v7) or 0;

    if v8 <= 0 then
        return false;
    end;

    return v8 <= GetData.GetItemCountByID(p5, EnumMgr.ItemID.Coin);
end;

local function _canCraftAnyPotion(p9) -- Line: 334
    local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
    local PlayerData = UtilsSystem.PlayerData;
    local Alchemy = UtilsSystem.GetData.Alchemy;

    if not Alchemy.CanUseAlchemy(p9) then
        return false;
    end;

    local v10 = PlayerData.GetPlrDataByKey(p9, "Bag");

    if type(v10) ~= "table" then
        return false;
    end;

    for _, v in ipairs(Alchemy.GetRecipeList()) do
        if Alchemy.CanMeetRecipeRebirth(p9, v) and Alchemy.CanCraftRecipe(v10, v) then
            return true;
        end;
    end;

    return false;
end;

local function _hasAnyBroom(p11) -- Line: 363
    local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
    local EnumMgr = UtilsSystem.EnumMgr;
    local v12 = UtilsSystem.PlayerData.GetPlrDataByKey(p11, "Bag");

    if type(v12) ~= "table" then
        return false;
    end;

    local Broom = EnumMgr.ItemType.Broom;

    for _, v in pairs(v12) do
        if type(v) == "table" and (tonumber(v.tp) == Broom and (tonumber(v.count) or 0) > 0) then
            return true;
        end;
    end;

    return false;
end;

v1["引导"] = {
    Defaults = {
        ui = {
            path = nil,
            thickness = 2048,
            startScale = 2,
            animTime = 0.25,
            maskDelay = 1,
            maskTransparency = 0.5,
            color = Color3.fromRGB(0, 0, 0)
        },
        worldHighlight = {},
        line = {}
    },
    Cfg = {
        ["初次点击"] = {
            Check = function(p13) -- Line: 398
                return true;
            end,

            Order = 1001,
            ["1"] = {
                Text = "引导文本_点击5次",
                TextVisible = {}
            },
            ["2"] = {
                Text = "引导文本_点击4次",
                TextVisible = {}
            },
            ["3"] = {
                Text = "引导文本_点击3次",
                TextVisible = {}
            },
            ["4"] = {
                Text = "引导文本_点击2次",
                TextVisible = {}
            },
            ["5"] = {
                Text = "引导文本_点击1次",
                TextVisible = {}
            }
        },
        ["进入副本"] = {
            ReStart = true,

            Check = function(p14) -- Line: 426
                return true;
            end,

            Order = 1002,
            ["1"] = {
                Text = "引导文本_进入副本",
                line = {
                    path = "场景.大厅.功能.副本引导"
                },
                TextVisible = {}
            },
            ["2"] = {
                enemy = 5011001,
                Text = "引导文本_击杀全部怪物",
                TextVisible = {}
            },
            ["3"] = {
                bestDrop = 1,
                Text = "引导文本_拾取战利品",
                TextVisible = {}
            }
        },
        ["出售物品"] = {
            Check = function(p15) -- Line: 452
                -- upvalues: _isPlayerInDungeon (copy), _hasSellableLoot (copy)
                local v16 = not _isPlayerInDungeon(p15) and _hasSellableLoot(p15);

                return v16;
            end,

            Order = 1005,
            ["1"] = {
                Text = "引导文本_出售物品",
                line = {
                    path = "场景.大厅.功能.出售商店"
                },
                TextVisible = {}
            }
        },
        ["升级魔杖"] = {
            Check = function(p17) -- Line: 466
                -- upvalues: _isPlayerInDungeon (copy), _canAffordWeapon (copy)
                local v18 = not _isPlayerInDungeon(p17) and _canAffordWeapon(p17, 6000002);

                return v18;
            end,

            Order = 1006,
            ["1"] = {
                Text = "引导文本_升级魔杖",
                line = {
                    path = "场景.大厅.功能.魔杖商店"
                },
                TextVisible = {}
            }
        },
        ["炼制药水"] = {
            Check = function(p19) -- Line: 481
                -- upvalues: _canCraftAnyPotion (copy)
                return _canCraftAnyPotion(p19);
            end,

            SkipWhenCheckFails = true,
            Order = 1008,
            ["1"] = {
                Text = "引导文本_炼制药水",
                line = {
                    path = "场景.大厅.功能.炼药场景"
                },
                TextVisible = {}
            }
        },
        ["引导扫帚"] = {
            Check = function(p20) -- Line: 499
                -- upvalues: _isPlayerInDungeon (copy), _hasAnyBroom (copy)
                local v21 = not _isPlayerInDungeon(p20) and _hasAnyBroom(p20);

                return v21;
            end,

            SkipWhenCheckFails = true,
            Order = 1009,
            ["1"] = {
                Text = "引导文本_使用扫帚",
                Text_Mobile = "引导文本_使用扫帚手机",
                TextVisible = {},
                ui = {
                    path_Mobile = "TouchGui.TouchControlFrame.BroomBtn",
                    Arrow = "左",
                    Visible = {}
                }
            }
        }
    }
};

return v1;