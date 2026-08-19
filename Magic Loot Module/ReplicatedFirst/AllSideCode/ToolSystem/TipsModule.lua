-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local MathMgr = UtilsSystem.MathMgr;
local Log = UtilsSystem.Log;
local u1 = {};

local function _showTipsByKey(p2, p3, p4, p5, p6) -- Line: 81
    -- upvalues: u1 (copy)
    u1.showTips(p2, p4, p5, p3, p6);
end;

function u1.showTips(p7, p8, p9, p10, p11, p12) -- Line: 95
    -- upvalues: Log (copy), RunService (copy), NetWork (copy), NetMsg (copy)
    Log.print(p8);

    if RunService:IsClient() then
        NetWork.FireBindable(NetMsg.SHOW_TIPS, p8, p9, p10, p11, p12);

        return;
    end;

    NetWork.FireClient(p7, NetMsg.SHOW_TIPS, p8, p9, p10, p11, p12);
end;

function u1.showTips_2Key(p13, p14, p15, p16, p17) -- Line: 121
    -- upvalues: Log (copy), RunService (copy), NetWork (copy), NetMsg (copy)
    Log.print(p14, p15);

    if RunService:IsClient() then
        NetWork.FireBindable(NetMsg.SHOW_TIPS_2KEY, p14, p15, p16, p17);

        return;
    end;

    NetWork.FireClient(p13, NetMsg.SHOW_TIPS_2KEY, p14, p15, p16, p17);
end;

function u1.NormalTips(p18, p19, p20, p21) -- Line: 139
    -- upvalues: EnumMgr (copy), u1 (copy)
    u1.showTips(p18, p19, p20, EnumMgr.TipTp.Normal, p21);
end;

function u1.ErrorTips(p22, p23, p24, p25) -- Line: 151
    -- upvalues: EnumMgr (copy), u1 (copy)
    u1.showTips(p22, p23, p24, EnumMgr.TipTp.Error, p25);
end;

function u1.RainbowTips(p26, p27, p28, p29, p30) -- Line: 164
    -- upvalues: u1 (copy), EnumMgr (copy)
    u1.showTips(p26, p27, p28, EnumMgr.TipTp.Rainbow, p29, p30);
end;

function u1.ClaimItemSuccess(p31, p32) -- Line: 180
    -- upvalues: CfgFind (copy), u1 (copy)
    local v33 = CfgFind.FindCfgByID(p32);
    local v34;

    if v33 and (type(v33.ZhName) == "string" and v33.ZhName ~= "") then
        v34 = { v33.ZhName };
    else
        v34 = tostring(p32);
    end;

    if v33 then
        v33 = v33.xyd;
    end;

    local v35 = tonumber(v33) or 1;
    u1.RainbowTips(p31, "领取XX成功", { v34 }, nil, v35);
end;

function u1.NormalTips_2Key(p36, p37, p38, p39) -- Line: 197
    -- upvalues: u1 (copy), EnumMgr (copy)
    u1.showTips_2Key(p36, p37, p38, p39, EnumMgr.TipTp.Normal);
end;

function u1.ErrorTips_2Key(p40, p41, p42, p43) -- Line: 209
    -- upvalues: u1 (copy), EnumMgr (copy)
    u1.showTips_2Key(p40, p41, p42, p43, EnumMgr.TipTp.Error);
end;

function u1.TipsNotEnoughItem(p44, p45, p46, p47) -- Line: 221
    -- upvalues: MathMgr (copy), CfgFind (copy), u1 (copy)
    local v48 = MathMgr.getNumStr(p46 - p47);
    local v49 = CfgFind.FindCfgByID(p45);

    if not (v49 and v49.ZhName) then
        return;
    end;

    u1.ErrorTips(p44, "还差多少道具", { v48, v49.ZhName });
end;

function u1.ShowTipsAward(p50, p51, p52) -- Line: 238
end;

function u1.NewShowTips(p53, p54) -- Line: 248
    -- upvalues: RunService (copy), NetWork (copy), NetMsg (copy)
    if RunService:IsServer() then
        NetWork.FireClient(p53, NetMsg.NEW_SHOW_TIPS, p54);

        return;
    end;

    NetWork.FireBindable(NetMsg.NEW_SHOW_TIPS, p54);
end;

function u1.NewShowTipsWithType(p55, p56, p57) -- Line: 263
    -- upvalues: RunService (copy), NetWork (copy), NetMsg (copy)
    if RunService:IsServer() then
        NetWork.FireClient(p55, NetMsg.NEW_SHOW_TIPS_WITH_TYPE, p56, p57);

        return;
    end;

    NetWork.FireBindable(NetMsg.NEW_SHOW_TIPS_WITH_TYPE, p56, p57);
end;

function u1.NewShowTipsTemplate(p58, p59) -- Line: 277
    -- upvalues: RunService (copy), NetWork (copy), NetMsg (copy)
    if RunService:IsServer() then
        NetWork.FireClient(p58, NetMsg.NEW_SHOW_TIPS_WITH_TEMP, p59);

        return;
    end;

    NetWork.FireBindable(NetMsg.NEW_SHOW_TIPS_WITH_TEMP, p59);
end;

function u1.ShowAwardPop(p60, p61, p62) -- Line: 292
    -- upvalues: RunService (copy), NetWork (copy), NetMsg (copy)
    if not RunService:IsServer() then
        warn("ShowAwardPop 仅服务端可用");

        return;
    end;

    if type(p61) == "table" and type(p62) == "table" then
        NetWork.FireClient(p60, NetMsg.SHOW_LOCAL_UI, "奖励领取弹窗无文字", {
            AwardID = p61,
            Count = p62
        }, true);

        return;
    end;

    warn("奖励领取弹窗 传入类型不对 不是table");
end;

function u1.FireDmgTip(p63, p64, p65, p66, p67) -- Line: 320
    -- upvalues: RunService (copy), EnumMgr (copy), NetWork (copy), NetMsg (copy)
    if not RunService:IsServer() then
        return;
    end;

    if not (p63 and p63.Parent) then
        return;
    end;

    if typeof(p64) ~= "Vector3" or type(p65) ~= "string" then
        return;
    end;

    local v68 = p66 == true;
    local v69 = tonumber(p67);

    if not v69 then
        if v68 then
            v69 = EnumMgr.DmgTp.PlayerDmgCrit;
        else
            v69 = EnumMgr.DmgTp.PlayerDmg;
        end;
    end;

    NetWork.FireClient(p63, NetMsg.DAMAGE_TIP, p64, p65, v68, v69);
end;

function u1.ShowDmg(p70, p71, p72, p73, p74) -- Line: 356
    -- upvalues: RunService (copy), MathMgr (copy), u1 (copy)
    if not RunService:IsServer() then
        return;
    end;

    if not (p70 and p70.Parent) then
        return;
    end;

    if typeof(p72) ~= "Vector3" then
        return;
    end;

    local v75 = MathMgr.getNumStr((math.floor(p71 or 0)));
    u1.FireDmgTip(p70, p72, v75, p73, p74);
end;

return u1;