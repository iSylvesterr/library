-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local VisibleMgr = UtilsSystem.VisibleMgr;
local EnumMgr = UtilsSystem.EnumMgr;
local CfgFind = UtilsSystem.CfgFind;
local ResourceUtil = UtilsSystem.ResourceUtil;
local HatchConfig = require(script.HatchConfig);
local HatchCamera = require(script.HatchCamera);
local HatchBoxEffect = require(script.HatchBoxEffect);
local HatchRewardBuild = require(script.HatchRewardBuild);
local HatchRewardEffect = require(script.HatchRewardEffect);
local ShowInfoUI = require(script.ShowInfoUI);
local v1 = {};

local function _playRewardPresentation(p2, p3, p4, p5) -- Line: 116
    -- upvalues: HatchRewardBuild (copy), HatchCamera (copy), ShowInfoUI (copy), HatchRewardEffect (copy)
    local v6 = HatchRewardBuild.buildPetModels(p2);

    if #v6 == 0 then
        warn("缺少可展示的奖励模型");
        HatchCamera.restoreZoom();

        return false;
    end;

    ShowInfoUI.CreateUI(p2, p5);
    ShowInfoUI.ShowUI(p4, p3);
    HatchRewardEffect.play(v6, p4, p5);
    ShowInfoUI.HideUI(p4, p3);

    return true;
end;

local function _getBoxModel(p7) -- Line: 142
    -- upvalues: CfgFind (copy), EnumMgr (copy), ResourceUtil (copy), VisibleMgr (copy)
    local v8 = CfgFind.FindCfgByID(p7);

    if not (v8 and v8.Model) then
        warn("缺少宝箱模型");

        return nil;
    end;

    if v8.tp ~= EnumMgr.ItemType.PetEgg then
        warn("宝箱类型错误", v8.tp);

        return nil;
    end;

    local v9 = ResourceUtil.GetModel(ResourceUtil.ModelCategory.PetEgg, v8.Model);
    VisibleMgr.DisableParticle(v9);
    VisibleMgr.CloseShade(v9);

    return v9;
end;

function v1.ShowHatchEffect(p10, p11, p12, p13) -- Line: 176
    -- upvalues: _getBoxModel (copy), HatchConfig (copy), HatchRewardBuild (copy), HatchBoxEffect (copy), _playRewardPresentation (copy)
    if not next(p11) then
        return;
    end;

    local v14 = p12 or 1;
    local v15 = _getBoxModel(p10);

    if not v15 then
        return;
    end;

    local v16, v17 = HatchConfig.clampRewardIds(p11);
    local v18 = HatchRewardBuild.sortItemIdsByXyd(v16);

    if not HatchBoxEffect.play(v15, v17, v14) then
        warn("容器表现资源缺失，跳过容器动画");
    end;

    if not _playRewardPresentation(v18, v17, v14, p13 or false) then
        return;
    end;

    task.wait(HatchConfig.HATCH_FINISH_WAIT);
end;

function v1.ShowItemEffect(p19, p20) -- Line: 217
    -- upvalues: HatchConfig (copy), HatchRewardBuild (copy), _playRewardPresentation (copy)
    if not next(p19) then
        return;
    end;

    local v21, v22 = HatchConfig.clampRewardIds(p19);

    if not _playRewardPresentation(HatchRewardBuild.sortItemIdsByXyd(v21), v22, 1, p20 or false) then
        return;
    end;

    task.wait(HatchConfig.ITEM_FINISH_WAIT);
end;

return v1;