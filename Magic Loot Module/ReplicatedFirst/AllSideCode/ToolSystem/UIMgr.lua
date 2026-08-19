-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local Lighting = game:GetService("Lighting");
local TweenService = game:GetService("TweenService");
local AssetService = game:GetService("AssetService");
local CollectionService = game:GetService("CollectionService");
local ProximityPromptService = game:GetService("ProximityPromptService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local MathMgr = UtilsSystem.MathMgr;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local ViewportFrameModule = UtilsSystem.ViewportFrameModule;
local ShowDetail = UtilsSystem.ShowDetail;
local TranslationHelper = UtilsSystem.TranslationHelper;
local ResourceUtil = UtilsSystem.ResourceUtil;
local InsMgr = UtilsSystem.InsMgr;
local ArmorModelUtil = UtilsSystem.ArmorModelUtil;
local GetData = UtilsSystem.GetData;
local ModelCategory = ResourceUtil.ModelCategory;
local ItemType = EnumMgr.ItemType;
local u2 = { "抽宠物弹窗" };
local u3 = {
    Mian = true,
    Main = true,
    Detail = true,
    UIAnima = true
};
local u4 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u5 = {};
local u6 = nil;
local u7 = 0;
local u8 = nil;
local u9 = false;
local u10 = false;
local u11 = Color3.new(0, 0, 0);
local u12 = Color3.new(0.741176, 0.741176, 0.741176);
local u13 = Color3.new(1, 0.478431, 0.458824);
local u14 = Color3.new(1, 1, 1);
local u15 = {};

local function _toImageUri(p16) -- Line: 174
    if typeof(p16) == "number" then
        if p16 <= 0 then
            return nil;
        end;

        return "rbxassetid://" .. tostring(p16);
    end;

    if typeof(p16) ~= "string" or p16 == "" then
        return nil;
    end;

    if string.find(p16, "rbxasset", 1, true) then
        return p16;
    end;

    local v17 = tonumber(p16);

    if v17 and v17 > 0 then
        return "rbxassetid://" .. p16;
    end;

    return nil;
end;

local function _applyImageAspectRatio(p18, p19) -- Line: 205
    local v20 = p18:FindFirstChildOfClass("UIAspectRatioConstraint");

    if not v20 then
        v20 = Instance.new("UIAspectRatioConstraint");
        v20.Parent = p18;
    end;

    v20.AspectRatio = p19.X / p19.Y;
end;

local function _getLocalPlayerGui() -- Line: 219
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        return nil;
    end;

    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if PlayerGui and PlayerGui:IsA("PlayerGui") then
        return PlayerGui;
    end;

    return nil;
end;

local function _getScreenGui() -- Line: 235
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;
    local v21;

    if LocalPlayer then
        v21 = LocalPlayer:FindFirstChild("PlayerGui");

        if not (v21 and v21:IsA("PlayerGui")) then
            v21 = nil;
        end;
    else
        v21 = nil;
    end;

    if not v21 then
        return nil;
    end;

    local ScreenGui = v21:FindFirstChild("ScreenGui");

    if ScreenGui and ScreenGui:IsA("ScreenGui") then
        return ScreenGui;
    end;

    return nil;
end;

local function _getScreenGuiFull() -- Line: 251
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;
    local v22;

    if LocalPlayer then
        v22 = LocalPlayer:FindFirstChild("PlayerGui");

        if not (v22 and v22:IsA("PlayerGui")) then
            v22 = nil;
        end;
    else
        v22 = nil;
    end;

    if not v22 then
        return nil;
    end;

    local ScreenGui_Full = v22:FindFirstChild("ScreenGui_Full");

    if ScreenGui_Full and ScreenGui_Full:IsA("ScreenGui") then
        return ScreenGui_Full;
    end;

    return nil;
end;

local function _getExpBar() -- Line: 267
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;
    local v23;

    if LocalPlayer then
        v23 = LocalPlayer:FindFirstChild("PlayerGui");

        if not (v23 and v23:IsA("PlayerGui")) then
            v23 = nil;
        end;
    else
        v23 = nil;
    end;

    local v24;

    if v23 then
        v24 = v23:FindFirstChild("ScreenGui_Full");

        if not (v24 and v24:IsA("ScreenGui")) then
            v24 = nil;
        end;
    else
        v24 = nil;
    end;

    if not v24 then
        return nil;
    end;

    local Top = v24:FindFirstChild("Top");

    if not Top then
        return nil;
    end;

    local v25 = Top:FindFirstChild("经验进度条");

    if v25 and v25:IsA("GuiObject") then
        return v25;
    end;

    return nil;
end;

local function _getSkillBar() -- Line: 287
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;
    local v26;

    if LocalPlayer then
        v26 = LocalPlayer:FindFirstChild("PlayerGui");

        if not (v26 and v26:IsA("PlayerGui")) then
            v26 = nil;
        end;
    else
        v26 = nil;
    end;

    local v27;

    if v26 then
        v27 = v26:FindFirstChild("ScreenGui");

        if not (v27 and v27:IsA("ScreenGui")) then
            v27 = nil;
        end;
    else
        v27 = nil;
    end;

    if not v27 then
        return nil;
    end;

    local Main = v27:FindFirstChild("Main");

    if not (Main and Main:IsA("Frame")) then
        return nil;
    end;

    local Skill = Main:FindFirstChild("Skill");

    if Skill and Skill:IsA("GuiObject") then
        return Skill;
    end;

    return nil;
end;

local function _reconcileSkillBarVisible() -- Line: 304
    -- upvalues: _getSkillBar (copy), u8 (ref), u9 (ref), u10 (ref)
    local v28 = _getSkillBar();

    if not v28 then
        return;
    end;

    v28.Visible = (u8 == nil and not u9 and true or false) and u10;
end;

local function _applyPartialMainUIVisible(p29, p30, p31) -- Line: 319
    -- upvalues: u8 (ref)
    p29.Visible = true;

    if not p30 then
        if not u8 then
            u8 = {};
        end;

        for _, child in pairs(p29:GetChildren()) do
            if child:IsA("GuiObject") and (child.Name ~= "ButtomLeft" or p31) then
                if u8[child] == nil then
                    u8[child] = child.Visible;
                end;

                child.Visible = false;
            end;
        end;

        return;
    end;

    if not u8 then
        for _, child in pairs(p29:GetChildren()) do
            if child:IsA("GuiObject") then
                child.Visible = true;
            end;
        end;

        return;
    end;

    for i, v in pairs(u8) do
        if i.Parent == p29 then
            i.Visible = v;
        end;
    end;

    u8 = nil;
end;

local function _setPetUIVisible(p32) -- Line: 361
    -- upvalues: Players (copy), u2 (copy)
    local LocalPlayer = Players.LocalPlayer;
    local v33;

    if LocalPlayer then
        v33 = LocalPlayer:FindFirstChild("PlayerGui");

        if not (v33 and v33:IsA("PlayerGui")) then
            v33 = nil;
        end;
    else
        v33 = nil;
    end;

    local v34;

    if v33 then
        v34 = v33:FindFirstChild("ScreenGui");

        if not (v34 and v34:IsA("ScreenGui")) then
            v34 = nil;
        end;
    else
        v34 = nil;
    end;

    if not v34 then
        return;
    end;

    for _, v in pairs(u2) do
        local v35 = v34:FindFirstChild(v);

        if v35 and v35:IsA("Frame") then
            v35.Visible = p32;
        end;
    end;
end;

local function _setHeroAward(p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48) -- Line: 390
    -- upvalues: ResourceUtil (copy), ViewportFrameModule (copy), u1 (copy), CfgFind (copy), TranslationHelper (copy)
    local v49 = p39 or 1;

    if p46 then
        p46.Visible = true;
        local v50 = ResourceUtil.GetModel(ResourceUtil.ModelCategory.Anime, p37);

        if v50 then
            ViewportFrameModule.new(p46, v50, v50:GetAttribute("Head") or Vector3.new(0, 0, 0));
        end;
    end;

    if p42 then
        p42.Visible = false;
    end;

    if p44 then
        p44.Visible = false;
    end;

    if p47 then
        p47.Visible = true;
        u1.SetRoleIcon(p47, CfgFind.FindCfgByID(p37).Role);
    end;

    if p48 then
        if p41 then
            if p45 then
                p45.Visible = false;
            end;

            p48.Visible = true;

            if p43 then
                p43.Visible = true;
                TranslationHelper.SetRawText(p43, "x" .. p41);
            end;
        else
            if p43 then
                p43.Visible = false;
            end;

            p48.Visible = false;

            if p45 then
                p45.Visible = true;
                TranslationHelper.SetText(p45, "等级为", { v49 });
            end;
        end;
    else
        if p43 then
            p43.Visible = false;
        end;

        if p45 then
            p45.Visible = true;
            TranslationHelper.SetText(p45, "等级为", { v49 });
        end;
    end;
end;

local function _setHeroShardAward(p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61) -- Line: 478
    -- upvalues: CfgFind (copy), EnumMgr (copy), ResourceUtil (copy), ViewportFrameModule (copy), u1 (copy), TranslationHelper (copy)
    local v62 = CfgFind.FindCfgByID(p52.HeroID, EnumMgr.ItemType.Hero);

    if not v62 then
        return;
    end;

    if p59 then
        p59.Visible = true;
        local v63 = ResourceUtil.GetModel(ResourceUtil.ModelCategory.Anime, p52.HeroID);

        if v63 then
            ViewportFrameModule.new(p59, v63, v63:GetAttribute("Head") or Vector3.new(0, 0, 0));
        end;
    end;

    if p55 then
        p55.Visible = false;
        p55.Size = UDim2.new(1, 0, 1, 0);
    end;

    if p57 then
        p57.Visible = false;
    end;

    if p60 then
        p60.Visible = true;
        u1.SetRoleIcon(p60, v62.Role);
    end;

    if p61 and p53 then
        if p58 then
            p58.Visible = false;
        end;

        p61.Visible = true;

        if p56 then
            p56.Visible = true;
            TranslationHelper.SetRawText(p56, "x" .. p53);
        end;
    end;
end;

local function _setEquipmentAward(p64, p65, p66, p67, p68, p69, p70, p71, p72, p73) -- Line: 547
    -- upvalues: TranslationHelper (copy)
    local v74 = p66 or 0;

    if p71 then
        p71.Visible = false;
    end;

    if p67 then
        p67.Size = UDim2.new(1, 0, 1, 0);
        p67.Visible = true;
        p67.Image = "rbxassetid://" .. p65.Icon;
    end;

    if p68 then
        p68.Visible = false;
    end;

    if p69 then
        p69.Visible = true;
        TranslationHelper.SetText(p69, "等级为", { p65.RequireLv });
    end;

    if p70 then
        if v74 > 0 then
            p70.Visible = true;
            TranslationHelper.SetRawText(p70, "+" .. v74);
        else
            p70.Visible = false;
        end;
    end;

    if p72 then
        p72.Visible = false;
    end;

    if p73 then
        p73.Visible = false;
    end;
end;

local function _setOtherAward(p75, p76, p77, p78, p79, p80, p81, p82, p83, p84) -- Line: 613
    -- upvalues: EnumMgr (copy), TranslationHelper (copy), MathMgr (copy)
    if p82 then
        p82.Visible = false;
    end;

    if p78 then
        p78.Visible = true;
        p78.Image = "rbxassetid://" .. p76.Icon;

        if p76.tp == EnumMgr.ItemType.Title then
            p78.Size = UDim2.new(1.8, 0, 1.8, 0);
        else
            p78.Size = UDim2.new(1, 0, 1, 0);
        end;
    end;

    if p79 then
        if p77 and p77 > 0 then
            p79.Visible = true;
            TranslationHelper.SetRawText(p79, "x" .. MathMgr.getNumStr(p77));
        else
            p79.Visible = false;
        end;
    end;

    if p80 then
        p80.Visible = false;
    end;

    if p81 then
        p81.Visible = false;
    end;

    if p83 then
        p83.Visible = false;
    end;

    if p84 then
        p84.Visible = false;
    end;
end;

function u1.SetRoleIcon(p85, p86) -- Line: 672
    if not p85 then
        return;
    end;

    local v87 = p86 == nil and "" or (tostring(p86) or "");
    local v88 = false;

    for _, child in p85:GetChildren() do
        if child:IsA("GuiObject") then
            local v89;

            if v87 == "" then
                v89 = false;
            else
                v89 = child.Name == v87;
            end;

            child.Visible = v89;

            if v89 then
                v88 = true;
            end;
        end;
    end;

    if not v88 then
        for _, child in p85:GetChildren() do
            if child:IsA("GuiObject") then
                child.Visible = false;
            end;
        end;
    end;
end;

function u1.SetAward(u90, u91, p92, p93, p94, p95, p96) -- Line: 711
    -- upvalues: CfgFind (copy), EnumMgr (copy), u1 (copy), TranslationHelper (copy), _setHeroAward (copy), _setHeroShardAward (copy), _setEquipmentAward (copy), _setOtherAward (copy), UtilsSystem (copy), ShowDetail (copy)
    local Icon = u90:FindFirstChild("Icon");
    local Count = u90:FindFirstChild("Count");
    local ReqLv = u90:FindFirstChild("ReqLv");
    local LevelStr = u90:FindFirstChild("LevelStr");
    local ViewportFrame = u90:FindFirstChild("ViewportFrame");
    local RoleIcon = u90:FindFirstChild("RoleIcon");
    local ZhName = u90:FindFirstChild("ZhName");
    local ShardIcon = u90:FindFirstChild("ShardIcon");
    local v97 = CfgFind.FindCfgByID(u91);

    if not v97 then
        return;
    end;

    local v98 = p94 or v97.xyd;
    local v99 = v98 and v97.tp == EnumMgr.ItemType.Hero and tonumber(v98);

    if v99 then
        u1.SetHeroXyd(u90, v99);
    end;

    if ZhName then
        TranslationHelper.SetText(ZhName, v97.ZhName);
    end;

    if v97.tp == EnumMgr.ItemType.Hero then
        _setHeroAward(u90, u91, p92, p93 or 1, p94, p95, Icon, Count, ReqLv, LevelStr, ViewportFrame, RoleIcon, ShardIcon);
    elseif v97.tp == EnumMgr.ItemType.HeroShard then
        _setHeroShardAward(u90, v97, p92, p93 or 1, Icon, Count, ReqLv, LevelStr, ViewportFrame, RoleIcon, ShardIcon);
    elseif v97.tp == EnumMgr.ItemType.Equipment then
        _setEquipmentAward(u90, v97, p93 or 0, Icon, Count, ReqLv, LevelStr, ViewportFrame, RoleIcon, ShardIcon);
    else
        _setOtherAward(u90, v97, p92, Icon, Count, ReqLv, LevelStr, ViewportFrame, RoleIcon, ShardIcon);
    end;

    if (p96 == nil and true or p96) and (v97.tp == EnumMgr.ItemType.Item or v97.tp == EnumMgr.ItemType.UseItem) then
        local Parent = u90.Parent;
        local v100 = Parent and Parent:FindFirstChild("Button");

        if v100 then
            UtilsSystem.AddListen.AddMouseCLick(v100, function() -- Line: 773
                -- upvalues: u91 (copy), ShowDetail (ref), u90 (copy)
                ShowDetail.ShowDetailByData({
                    id = u91,
                    onlyID = u91
                }, u90, "通用物品详情", true);
            end, u90);
        end;
    end;
end;

function u1.SetMainUIVisible(p101, p102) -- Line: 792
    -- upvalues: Players (copy), _applyPartialMainUIVisible (copy), _getSkillBar (copy), u8 (ref), u9 (ref), u10 (ref)
    local LocalPlayer = Players.LocalPlayer;
    local v103;

    if LocalPlayer then
        v103 = LocalPlayer:FindFirstChild("PlayerGui");

        if not (v103 and v103:IsA("PlayerGui")) then
            v103 = nil;
        end;
    else
        v103 = nil;
    end;

    local v104;

    if v103 then
        v104 = v103:FindFirstChild("ScreenGui");

        if not (v104 and v104:IsA("ScreenGui")) then
            v104 = nil;
        end;
    else
        v104 = nil;
    end;

    if not v104 then
        return;
    end;

    local v105 = true;

    if p101 == nil then
        for _, child in pairs(v104:GetChildren()) do
            local v106 = child:IsA("Frame") and child and child or nil;

            if v106 and v106.Visible == true then
                local v107 = v106:FindFirstChild("背景模糊");
                local v108 = v106:FindFirstChild("隐藏主界面");

                if v107 and (v107:IsA("BoolValue") and v107.Value == true) or v108 and (v108:IsA("BoolValue") and v108.Value == true) then
                    v105 = false;
                    break;
                end;
            end;
        end;
    else
        v105 = p101;
    end;

    local Main = v104:FindFirstChild("Main");

    if Main then
        local v109 = p102 == true;

        if not (v105 or v109) then
            for _, child in pairs(v104:GetChildren()) do
                if child:IsA("Frame") and (child.Visible == true and child:GetAttribute("HideButtomLeft") == true) then
                    v109 = true;
                    break;
                end;
            end;
        end;

        _applyPartialMainUIVisible(Main, v105, v109);
        local v110 = _getSkillBar();

        if v110 then
            v110.Visible = (u8 == nil and not u9 and true or false) and u10;
        end;
    end;

    local LocalPlayer2 = Players.LocalPlayer;
    local v111;

    if LocalPlayer2 then
        v111 = LocalPlayer2:FindFirstChild("PlayerGui");

        if not (v111 and v111:IsA("PlayerGui")) then
            v111 = nil;
        end;
    else
        v111 = nil;
    end;

    local v112 = v111 and v111:FindFirstChild("SystemGui");

    if v112 then
        v112.Enabled = v105;
    end;
end;

function u1.SetSkillBarVisible(p113) -- Line: 852
    -- upvalues: u9 (ref), _getSkillBar (copy), u8 (ref), u10 (ref)
    u9 = not p113;
    local v114 = _getSkillBar();

    if not v114 then
        return;
    end;

    v114.Visible = (u8 == nil and not u9 and true or false) and u10;
end;

function u1.SetSkillBarHasEquippedSkill(p115) -- Line: 862
    -- upvalues: u10 (ref), _getSkillBar (copy), u8 (ref), u9 (ref)
    u10 = p115 == true;
    local v116 = _getSkillBar();

    if not v116 then
        return;
    end;

    v116.Visible = (u8 == nil and not u9 and true or false) and u10;
end;

function u1.HideGui() -- Line: 871
    -- upvalues: _setPetUIVisible (copy)
    _setPetUIVisible(false);
end;

function u1.ShowGui() -- Line: 879
    -- upvalues: _setPetUIVisible (copy)
    _setPetUIVisible(true);
end;

function u1.HideScreenGui() -- Line: 887
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;
    local v117;

    if LocalPlayer then
        v117 = LocalPlayer:FindFirstChild("PlayerGui");

        if not (v117 and v117:IsA("PlayerGui")) then
            v117 = nil;
        end;
    else
        v117 = nil;
    end;

    local v118;

    if v117 then
        v118 = v117:FindFirstChild("ScreenGui");

        if not (v118 and v118:IsA("ScreenGui")) then
            v118 = nil;
        end;
    else
        v118 = nil;
    end;

    if v118 then
        v118.Enabled = false;
    end;
end;

function u1.ShowScreenGui() -- Line: 898
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;
    local v119;

    if LocalPlayer then
        v119 = LocalPlayer:FindFirstChild("PlayerGui");

        if not (v119 and v119:IsA("PlayerGui")) then
            v119 = nil;
        end;
    else
        v119 = nil;
    end;

    local v120;

    if v119 then
        v120 = v119:FindFirstChild("ScreenGui");

        if not (v120 and v120:IsA("ScreenGui")) then
            v120 = nil;
        end;
    else
        v120 = nil;
    end;

    if v120 then
        v120.Enabled = true;
    end;
end;

local function _screenGuiNeedsBackgroundBlur(p121) -- Line: 910
    if not p121.Enabled then
        return false;
    end;

    for _, child in pairs(p121:GetChildren()) do
        if child:IsA("Frame") and child.Visible then
            local v122 = child:FindFirstChild("背景模糊");

            if v122 and (v122:IsA("BoolValue") and v122.Value) then
                return true;
            end;
        end;
    end;

    return false;
end;

function u1.UpdateBlurVisible() -- Line: 930
    -- upvalues: Lighting (copy), Players (copy), _screenGuiNeedsBackgroundBlur (copy)
    local v123 = Lighting:FindFirstChild("UI模糊");

    if not (v123 and v123:IsA("BlurEffect")) then
        v123 = Instance.new("BlurEffect");
        v123.Name = "UI模糊";
        v123.Enabled = false;
        v123.Parent = Lighting;
    end;

    local LocalPlayer = Players.LocalPlayer;
    local v124;

    if LocalPlayer then
        v124 = LocalPlayer:FindFirstChild("PlayerGui");

        if not (v124 and v124:IsA("PlayerGui")) then
            v124 = nil;
        end;
    else
        v124 = nil;
    end;

    local v125;

    if v124 then
        v125 = v124:FindFirstChild("ScreenGui");

        if not (v125 and v125:IsA("ScreenGui")) then
            v125 = nil;
        end;
    else
        v125 = nil;
    end;

    local LocalPlayer2 = Players.LocalPlayer;
    local v126;

    if LocalPlayer2 then
        v126 = LocalPlayer2:FindFirstChild("PlayerGui");

        if not (v126 and v126:IsA("PlayerGui")) then
            v126 = nil;
        end;
    else
        v126 = nil;
    end;

    local v127;

    if v126 then
        v127 = v126:FindFirstChild("ScreenGui_Full");

        if not (v127 and v127:IsA("ScreenGui")) then
            v127 = nil;
        end;
    else
        v127 = nil;
    end;

    local v128 = v125 ~= nil and _screenGuiNeedsBackgroundBlur(v125);

    if not v128 then
        if v127 == nil then
            v128 = false;
        else
            v128 = _screenGuiNeedsBackgroundBlur(v127);
        end;
    end;

    v123.Enabled = v128;
end;

local function _isBillboardHiddenDistance(p129) -- Line: 953
    return p129 <= 0.0011;
end;

local function _shouldHideWorldUi() -- Line: 963
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;

    if LocalPlayer then
        local v130 = LocalPlayer:FindFirstChild("是否弹窗打开中");

        if v130 and (v130:IsA("BoolValue") and v130.Value == true) then
            return true;
        end;

        local Setting = LocalPlayer:FindFirstChild("Setting");

        if Setting then
            local HideUI = Setting:FindFirstChild("HideUI");

            if HideUI and (HideUI:IsA("NumberValue") and HideUI.Value == 0) then
                return true;
            end;
        end;
    end;

    local CurrentCamera = workspace.CurrentCamera;

    return CurrentCamera and CurrentCamera.CameraType == Enum.CameraType.Scriptable and true or false;
end;

function u1.UpdateWorldUi() -- Line: 995
    -- upvalues: _shouldHideWorldUi (copy), CollectionService (copy), ProximityPromptService (copy)
    local v131 = _shouldHideWorldUi();

    for _, v in CollectionService:GetTagged("BillboardGui") do
        if v:IsA("BillboardGui") then
            if v131 then
                if v:GetAttribute("MaxDis") == nil then
                    local MaxDistance = v.MaxDistance;

                    if MaxDistance > 0.0011 then
                        v:SetAttribute("MaxDis", MaxDistance);
                    end;
                end;

                v.MaxDistance = 0.001;
            else
                local v132 = v:GetAttribute("MaxDis");

                if typeof(v132) == "number" and v132 > 0.0011 then
                    v.MaxDistance = v132;
                elseif v.MaxDistance <= 0.0011 then
                    v:SetAttribute("MaxDis", nil);
                    v.MaxDistance = (1 / 0);
                end;
            end;
        end;
    end;

    ProximityPromptService.Enabled = not v131;
end;

function u1.RefreshPopShowState() -- Line: 1030
    -- upvalues: Players (copy), InsMgr (copy), u1 (copy)
    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        return;
    end;

    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if not (PlayerGui and PlayerGui:IsA("PlayerGui")) then
        return;
    end;

    local v133 = InsMgr.GetIns("是否弹窗打开中", "BoolValue", LocalPlayer);
    local v134 = false;

    for _, child in pairs(PlayerGui:GetChildren()) do
        if child:IsA("ScreenGui") then
            local v135 = child:FindFirstChild("是否是弹窗");

            if v135 and v135:IsA("BoolValue") then
                if v135.Value == true and child.Enabled == true then
                    v134 = true;
                end;
            elseif child.Enabled == true then
                for _, child2 in pairs(child:GetChildren()) do
                    if child2:IsA("Frame") then
                        local v136 = child2:FindFirstChild("是否是弹窗");

                        if v136 and (v136:IsA("BoolValue") and (v136.Value == true and child2.Visible == true)) then
                            v134 = true;
                            break;
                        end;
                    end;
                end;

                if v134 then
                    break;
                end;
            end;
        end;
    end;

    v133.Value = v134;
    u1.UpdateWorldUi();
end;

function u1.CloseBlur() -- Line: 1083
    -- upvalues: Lighting (copy)
    local v137 = Lighting:FindFirstChild("UI模糊");

    if v137 and v137:IsA("BlurEffect") then
        v137.Enabled = false;
    end;
end;

function u1.VisibleDepth(p138) -- Line: 1095
    -- upvalues: Lighting (copy)
    local v139 = Lighting:FindFirstChild("景深");

    if not (v139 and v139:IsA("DepthOfFieldEffect")) then
        return;
    end;

    v139.Enabled = p138;
end;

function u1.HideOtherUI(p140) -- Line: 1108
    -- upvalues: u3 (copy)
    local PlayerGui = p140:FindFirstChild("PlayerGui");

    if not (PlayerGui and PlayerGui:IsA("PlayerGui")) then
        return;
    end;

    local ScreenGui = PlayerGui:FindFirstChild("ScreenGui");

    if not (ScreenGui and ScreenGui:IsA("ScreenGui")) then
        return;
    end;

    for _, child in pairs(ScreenGui:GetChildren()) do
        if child:IsA("Frame") and (child.Visible and not u3[child.Name]) then
            local u141 = child:FindFirstChild("刷新UI");

            if u141 and u141:IsA("ModuleScript") then
                local success, result = pcall(function() -- Line: 1123
                    -- upvalues: u141 (copy)
                    return require(u141);
                end);

                if success and (result and type(result.closeUi) == "function") then
                    result:closeUi();
                end;
            end;
        end;
    end;
end;

function u1.GetImagePixelSize(p142) -- Line: 1140
    -- upvalues: _toImageUri (copy), u15 (copy), AssetService (copy)
    local u143 = _toImageUri(p142);

    if not u143 then
        return nil;
    end;

    local v144 = u15[u143];

    if v144 then
        return v144;
    end;

    local success, result = pcall(function() -- Line: 1151
        -- upvalues: AssetService (ref), u143 (copy)
        return AssetService:CreateEditableImageAsync(Content.fromUri(u143));
    end);

    if not (success and result) then
        return nil;
    end;

    local Size = result.Size;
    result:Destroy();

    if Size.X <= 0 or Size.Y <= 0 then
        return nil;
    end;

    u15[u143] = Size;

    return Size;
end;

function u1.SetImage(u145, p146, u147, u148) -- Line: 1178
    -- upvalues: _toImageUri (copy), u1 (copy)
    if u147 == nil then
        u147 = false;
    end;

    if u148 == nil then
        u148 = false;
    end;

    if not (u145 and (u145:IsA("ImageLabel") or u145:IsA("ImageButton"))) then
        return;
    end;

    local u149 = _toImageUri(p146);

    if not u149 then
        u145.Image = "";

        return;
    end;

    u145.Image = u149;

    if not (u147 or u148) then
        return;
    end;

    task.spawn(function() -- Line: 1207
        -- upvalues: u1 (ref), u149 (copy), u145 (copy), u147 (ref), u148 (ref)
        local v150 = u1.GetImagePixelSize(u149);

        if not v150 then
            return;
        end;

        if not u145.Parent or u145.Image ~= u149 then
            return;
        end;

        if u147 then
            u145.Size = UDim2.fromOffset(v150.X, v150.Y);
        end;

        if u148 then
            local v151 = u145;
            local v152 = v151:FindFirstChildOfClass("UIAspectRatioConstraint");

            if not v152 then
                v152 = Instance.new("UIAspectRatioConstraint");
                v152.Parent = v151;
            end;

            v152.AspectRatio = v150.X / v150.Y;
        end;
    end);
end;

function u1.SetTitel(p153, p154) -- Line: 1230
    -- upvalues: CfgFind (copy), EnumMgr (copy)
    if p153 <= 0 then
        p154.Image = "";
        p154.Visible = false;

        return;
    end;

    local v155 = CfgFind.FindCfgByID(p153, EnumMgr.ItemType.Title);

    if not v155 then
        return;
    end;

    p154.Visible = true;
    p154.Image = "rbxassetid://" .. v155.Icon;
    local v156 = p154:FindFirstChildOfClass("UIAspectRatioConstraint");

    if v156 and (v155.Size and #v155.Size >= 2) then
        v156.AspectRatio = v155.Size[1] / v155.Size[2];
    end;
end;

function u1.AddTextLength(p157) -- Line: 1256
    if p157:FindFirstChild("LengthAdjustment") then
        return;
    end;

    if not p157:IsA("TextLabel") then
        return;
    end;

    local LengthAdjustment = script:FindFirstChild("LengthAdjustment");

    if not LengthAdjustment then
        return;
    end;

    LengthAdjustment:Clone().Parent = p157;
end;

function u1.SetRbPrice(p158, p159) -- Line: 1280
    -- upvalues: TranslationHelper (copy)
    if not p158:IsA("TextLabel") then
        return;
    end;

    local v160 = p158:FindFirstChildOfClass("UIStroke");

    if v160 then
        v160:Destroy();
    end;

    p158.RichText = true;
    TranslationHelper.SetRawText(p158, " " .. p159);
end;

function u1.SetRobuxPriceLabel(u161, p162, p163) -- Line: 1311
    -- upvalues: TranslationHelper (copy), GetData (copy), CfgFind (copy)
    if not (u161 and u161:IsA("TextLabel")) then
        return;
    end;

    if type(p162) ~= "string" or p162 == "" then
        return;
    end;

    local v164 = type(p163) ~= "table" and {} or p163;
    local write = v164.write;
    local format = v164.format;

    local function defaultWrite(p165, p166) -- Line: 1323
        -- upvalues: TranslationHelper (ref), format (copy)
        if not p165.Parent then
            return;
        end;

        p165.RichText = false;

        if p166 == nil then
            TranslationHelper.SetText_UnTrans(p165, "");

            return;
        end;

        local v167;

        if type(format) == "function" then
            v167 = tostring(format(p166));
        else
            local v168 = math.floor(p166);
            v167 = tostring(v168);
        end;

        TranslationHelper.SetText_UnTrans(p165, v167);
    end;

    if type(write) ~= "function" then
        write = defaultWrite;
    end;

    local function apply(p169) -- Line: 1343
        -- upvalues: u161 (copy), write (copy)
        if u161.Parent then
            write(u161, p169);
        end;
    end;

    local v170 = GetData.GetCachedRobuxPrice(p162);

    if v170 then
        if u161.Parent then
            write(u161, v170);
        end;

        return;
    end;

    local v171 = tonumber(v164.fallbackPrice);

    if (not v171 or v171 <= 0) and v164.useCfgFallback ~= false then
        local v172 = CfgFind.FindCfgByOnlyTag(p162);

        if v172 then
            v171 = tonumber(v172.price);
        else
            v171 = nil;
        end;
    end;

    if v171 and v171 > 0 then
        if u161.Parent then
            write(u161, v171);
        end;
    elseif u161.Parent then
        write(u161, nil);
    end;

    GetData.FetchRobuxPrice(p162, function(p173) -- Line: 1367
        -- upvalues: u161 (copy), write (copy)
        if p173 ~= nil and u161.Parent then
            write(u161, p173);
        end;
    end);
end;

function u1.SetRobuxBuyBtnPrice(p174, p175) -- Line: 1383
    -- upvalues: u1 (copy)
    if not p174 or (type(p175) ~= "string" or p175 == "") then
        return;
    end;

    local Price = p174:FindFirstChild("Price");

    if Price then
        Price = Price:FindFirstChild("PriceNum");
    end;

    if not (Price and Price:IsA("TextLabel")) then
        return;
    end;

    u1.SetRobuxPriceLabel(Price, p175);
end;

function u1.SetUIlistSize(p176) -- Line: 1414
    -- upvalues: Players (copy), u1 (copy)
    local v177 = p176:FindFirstChildOfClass("UIListLayout");
    local v178 = p176:FindFirstChildOfClass("UIGridLayout");

    if not (v177 or v178) then
        return;
    end;

    local u179 = 1;
    local LocalPlayer = Players.LocalPlayer;
    local v180;

    if LocalPlayer then
        v180 = LocalPlayer:FindFirstChild("PlayerGui");
    else
        v180 = nil;
    end;

    local u181;

    if v180 then
        local ScreenGui = v180:FindFirstChild("ScreenGui");

        if ScreenGui and ScreenGui:IsA("ScreenGui") then
            local UIScale = ScreenGui:FindFirstChild("UIScale");
            u181 = p176;

            while p176 and p176.Parent ~= ScreenGui do
                p176 = p176.Parent;
            end;

            if p176 then
                p176 = p176:FindFirstChild("UIScale");
            end;

            if UIScale and (UIScale:IsA("UIScale") and (p176 and p176:IsA("UIScale"))) then
                u179 = UIScale.Scale * p176.Scale;
            elseif UIScale and UIScale:IsA("UIScale") then
                u179 = UIScale.Scale;
            elseif p176 and p176:IsA("UIScale") then
                u179 = p176.Scale;
            end;
        else
            u181 = p176;
        end;
    else
        u181 = p176;
    end;

    local v182 = u181:FindFirstChildOfClass("UIPadding");
    local Size = u181.Size;
    local v183 = 0;
    local v184 = 0;
    local Horizontal = Enum.FillDirection.Horizontal;
    local v185 = false;

    if v177 then
        v183 = v177.Padding.Offset;
        v184 = v177.Padding.Offset;
        Horizontal = v177.FillDirection;
        v185 = v177.Wraps;
    elseif v178 then
        v183 = v178.CellPadding.X.Offset;
        v184 = v178.CellPadding.Y.Offset;
        Horizontal = v178.FillDirection;
        v185 = true;
    end;

    local v186, v187;

    if v182 then
        v186 = v182.PaddingLeft.Offset + v182.PaddingRight.Offset;
        v187 = v182.PaddingTop.Offset + v182.PaddingBottom.Offset;
        Size = Size - UDim2.new(0, v186, 0, v187);
    else
        v186 = 0;
        v187 = 0;
    end;

    local function getLogicalSize(p188) -- Line: 1497
        -- upvalues: u179 (ref)
        local X = p188.Size.X;
        local Y = p188.Size.Y;
        local v189 = 0;
        local v190 = 0;

        if X.Offset == 0 then
            if X.Scale ~= 0 then
                v189 = p188.AbsoluteSize.X / u179;
            end;
        else
            v189 = X.Offset;
        end;

        if Y.Offset ~= 0 then
            return v189, Y.Offset;
        end;

        if Y.Scale ~= 0 then
            v190 = p188.AbsoluteSize.Y / u179;
        end;

        return v189, v190;
    end;

    local function isTitleRow(p191) -- Line: 1525
        return (p191.Name == "Title" or p191.Name == "TitleFrame") and true or p191:GetAttribute("Title") == true;
    end;

    local function applyScrollFrameCanvasSize(p192, p193) -- Line: 1556
        -- upvalues: u181 (copy), u179 (ref)
        if not u181:IsA("ScrollingFrame") then
            return;
        end;

        if u181.ScrollingDirection == Enum.ScrollingDirection.X then
            local v194 = math.max(p192, u181.AbsoluteSize.X / u179);
            u181.CanvasSize = UDim2.new(0, v194, 0, 0);

            return;
        end;

        local v195 = math.max(p193, u181.AbsoluteSize.Y / u179);
        u181.CanvasSize = UDim2.new(0, 0, 0, v195);
    end;

    local function isLayoutCellGui(p196) -- Line: 1535
        if not (p196:IsA("GuiObject") and p196.Visible) then
            return false;
        end;

        if p196:IsA("UIListLayout") or (p196:IsA("UIGridLayout") or p196:IsA("UIPadding")) then
            return false;
        end;

        if p196:IsA("LocalScript") then
            return false;
        end;

        return p196.Name ~= "Temp" and p196.Name ~= "_Temp";
    end;

    for _, child in ipairs(u181:GetChildren()) do
        if (child:IsA("Frame") or child:IsA("ScrollingFrame")) and (child.Visible and (child:FindFirstChildOfClass("UIListLayout") or child:FindFirstChildOfClass("UIGridLayout"))) then
            u1.SetUIlistSize(child);
        end;
    end;

    local v197 = {};
    local v198 = nil;

    for _, child in pairs(u181:GetChildren()) do
        if isLayoutCellGui(child) then
            if (child.Name == "Title" or child.Name == "TitleFrame") and true or child:GetAttribute("Title") == true then
                v198 = child;
            else
                table.insert(v197, child);
            end;
        end;
    end;

    local v199 = #v197;

    if (Horizontal ~= Enum.FillDirection.Horizontal or not v185) and not v178 then
        local v200 = 0;
        local v201 = 0;

        if v198 then
            local X = v198.Size.X;
            local Y = v198.Size.Y;
            local v202 = 0;
            local v203 = 0;

            if X.Offset == 0 then
                if X.Scale ~= 0 then
                    v202 = v198.AbsoluteSize.X / u179;
                end;
            else
                v202 = X.Offset;
            end;

            if Y.Offset == 0 then
                if Y.Scale ~= 0 then
                    v203 = v198.AbsoluteSize.Y / u179;
                end;
            else
                v203 = Y.Offset;
            end;

            v200 = v200 + v203;

            if v199 > 0 then
                v200 = v200 + v184;
            end;
        end;

        for _, v in ipairs(v197) do
            local X = v.Size.X;
            local Y = v.Size.Y;
            local v204 = 0;
            local v205 = 0;

            if X.Offset == 0 then
                if X.Scale ~= 0 then
                    v204 = v.AbsoluteSize.X / u179;
                end;
            else
                v204 = X.Offset;
            end;

            if Y.Offset == 0 then
                if Y.Scale ~= 0 then
                    v205 = v.AbsoluteSize.Y / u179;
                end;
            else
                v205 = Y.Offset;
            end;

            v200 = v200 + v205;
            v201 = v201 + v204;
        end;

        local v206;

        if v199 > 0 then
            if Horizontal == Enum.FillDirection.Vertical then
                v183 = v184 or v183;
            end;

            v206 = v183 * (v199 - 1);
        else
            v206 = 0;
        end;

        if u181:IsA("ScrollingFrame") then
            applyScrollFrameCanvasSize(v186 + v201 + v206, v187 + v200 + v206);
        elseif u181:IsA("Frame") then
            if Horizontal == Enum.FillDirection.Vertical then
                u181.Size = UDim2.new(Size.X.Scale, Size.X.Offset + v186, 0, v187 + v200 + v206);
            else
                u181.Size = UDim2.new(0, v186 + v201 + v206, Size.Y.Scale, v187 + Size.Y.Offset);
            end;
        end;

        return;
    end;

    local Offset = Size.X.Offset;

    if Offset <= 0 then
        Offset = u181.AbsoluteSize.X / u179 - v186;
    end;

    local v207;

    if v198 then
        local X = v198.Size.X;
        local Y = v198.Size.Y;
        local v208 = 0;
        v207 = 0;

        if X.Offset == 0 then
            if X.Scale ~= 0 then
                v208 = v198.AbsoluteSize.X / u179;
            end;
        else
            v208 = X.Offset;
        end;

        if Y.Offset == 0 then
            if Y.Scale ~= 0 then
                v207 = v198.AbsoluteSize.Y / u179;
            end;
        else
            v207 = Y.Offset;
        end;
    else
        v207 = 0;
    end;

    local v209;

    if v199 > 0 then
        local v210, v211;

        if v178 then
            v210 = v178.CellSize.X.Offset;
            v211 = v178.CellSize.Y.Offset;
        else
            local v212 = v197[1];
            local X = v212.Size.X;
            local Y = v212.Size.Y;
            v210 = 0;
            v211 = 0;

            if X.Offset == 0 then
                if X.Scale ~= 0 then
                    v210 = v212.AbsoluteSize.X / u179;
                end;
            else
                v210 = X.Offset;
            end;

            if Y.Offset == 0 then
                if Y.Scale ~= 0 then
                    v211 = v212.AbsoluteSize.Y / u179;
                end;
            else
                v211 = Y.Offset;
            end;
        end;

        local v213 = v210 + v183;
        local v214 = 1;

        if v178 and v178.FillDirectionMaxCells > 0 then
            v214 = math.max(1, v178.FillDirectionMaxCells);
        elseif v213 > 0 then
            local v215 = math.floor((Offset + v183) / v213);
            v214 = math.max(1, v215);
        end;

        local v216 = math.ceil(v199 / v214);
        local v217 = math.max(1, v216);
        v209 = v217 * v211 + (v217 - 1) * v184;
    else
        v209 = 0;
    end;

    local v218;

    if v198 then
        v218 = v187 + v207;

        if v199 > 0 then
            v218 = v218 + v184;
        end;
    else
        v218 = v187;
    end;

    local v219 = v218 + v209;

    if u181:IsA("ScrollingFrame") then
        if u181.ScrollingDirection == Enum.ScrollingDirection.X and v199 > 0 then
            local Offset2 = Size.Y.Offset;

            if Offset2 <= 0 then
                Offset2 = u181.AbsoluteSize.Y / u179 - v187;
            end;

            local v220, v221;

            if v178 then
                v220 = v178.CellSize.X.Offset;
                v221 = v178.CellSize.Y.Offset;
            else
                local v222 = v197[1];
                local X = v222.Size.X;
                local Y = v222.Size.Y;
                v220 = 0;
                v221 = 0;

                if X.Offset == 0 then
                    if X.Scale ~= 0 then
                        v220 = v222.AbsoluteSize.X / u179;
                    end;
                else
                    v220 = X.Offset;
                end;

                if Y.Offset == 0 then
                    if Y.Scale ~= 0 then
                        v221 = v222.AbsoluteSize.Y / u179;
                    end;
                else
                    v221 = Y.Offset;
                end;
            end;

            local v223 = v221 + v184;
            local v224 = 1;

            if v178 and v178.FillDirectionMaxCells > 0 then
                v224 = math.max(1, v178.FillDirectionMaxCells);
            elseif v223 > 0 then
                local v225 = math.floor((Offset2 + v184) / v223);
                v224 = math.max(1, v225);
            end;

            local v226 = math.ceil(v199 / v224);
            local v227 = math.max(1, v226);
            v186 = v186 + v227 * v220 + (v227 - 1) * v183;
        end;

        applyScrollFrameCanvasSize(v186, v219);
    else
        u181.Size = UDim2.new(Size.X.Scale, Size.X.Offset + v186, 0, v219);
    end;
end;

function u1.HideAllBut(p228) -- Line: 1757
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        return;
    end;

    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if not (PlayerGui and PlayerGui:IsA("PlayerGui")) then
        return;
    end;

    for _, child in PlayerGui:GetChildren() do
        if child:IsA("ScreenGui") and (child.Name ~= p228 and (child.Name ~= "BlackGui" and child.Enabled == true)) then
            child:SetAttribute("Enabled", true);
            child.Enabled = false;
        end;
    end;
end;

function u1.RecoverHideUI() -- Line: 1785
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        return;
    end;

    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if not (PlayerGui and PlayerGui:IsA("PlayerGui")) then
        return;
    end;

    for _, child in PlayerGui:GetChildren() do
        if child:IsA("ScreenGui") then
            local v229 = child:GetAttribute("Enabled");

            if v229 then
                child.Enabled = v229;
                child:SetAttribute("Enabled", nil);
            end;
        end;
    end;
end;

local function _findBlackScreenFrame() -- Line: 1811
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;
    local v230;

    if LocalPlayer then
        v230 = LocalPlayer:FindFirstChild("PlayerGui");

        if not (v230 and v230:IsA("PlayerGui")) then
            v230 = nil;
        end;
    else
        v230 = nil;
    end;

    if not v230 then
        return nil;
    end;

    local BlackGui = v230:FindFirstChild("BlackGui");

    if not (BlackGui and BlackGui:IsA("ScreenGui")) then
        return nil;
    end;

    local v231 = BlackGui:FindFirstChild("黑屏");

    if v231 and v231:IsA("Frame") then
        return v231;
    end;

    return nil;
end;

function u1.CancelBlackScreenFade(p232) -- Line: 1832
    -- upvalues: u7 (ref), u6 (ref), _findBlackScreenFrame (copy)
    u7 = u7 + 1;

    if u6 then
        u6:Cancel();
        u6 = nil;
    end;

    local v233 = p232 == true and _findBlackScreenFrame();

    if v233 then
        v233.BackgroundTransparency = 1;
    end;
end;

function u1.PlayBlackScreenFade(p234, p235, u236) -- Line: 1856
    -- upvalues: _findBlackScreenFrame (copy), u7 (ref), u6 (ref), TweenService (copy)
    local u237 = _findBlackScreenFrame();

    if not u237 then
        warn("[UIMgr] 缺少 PlayerGui.BlackGui/黑屏，跳过黑屏过场");

        if u236 then
            u236();
        end;

        return;
    end;

    local Parent = u237.Parent;

    if Parent and Parent:IsA("ScreenGui") then
        Parent.Enabled = true;
    end;

    u237.Visible = true;
    u7 = u7 + 1;
    local u238 = u7;

    if u6 then
        u6:Cancel();
        u6 = nil;
    end;

    local u239 = p234 and 0 or 1;
    local v240 = typeof(p235) ~= "number" and 0.5 or p235;
    local v241 = v240 < 0 and 0 or v240;

    local function finish() -- Line: 1885
        -- upvalues: u238 (copy), u7 (ref), u237 (copy), u239 (copy), u236 (copy)
        if u238 ~= u7 then
            return;
        end;

        u237.BackgroundTransparency = u239;

        if u236 then
            u236();
        end;
    end;

    if v241 <= 0 or math.abs(u237.BackgroundTransparency - u239) < 0.001 then
        if u238 ~= u7 then
            return;
        end;

        u237.BackgroundTransparency = u239;

        if u236 then
            u236();
        end;

        return;
    end;

    local v242 = TweenService:Create(u237, TweenInfo.new(v241, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = u239
    });
    u6 = v242;
    v242.Completed:Connect(function(p243) -- Line: 1905
        -- upvalues: u238 (copy), u7 (ref), u6 (ref), u237 (copy), u239 (copy), u236 (copy)
        if u238 ~= u7 then
            return;
        end;

        u6 = nil;

        if p243 == Enum.PlaybackState.Completed then
            if u238 ~= u7 then
                return;
            end;

            u237.BackgroundTransparency = u239;

            if u236 then
                u236();
            end;
        end;
    end);
    v242:Play();
end;

local u244 = {
    UIListLayout = true,
    UIGridLayout = true,
    UIPadding = true
};

local function _shouldKeepScrollItem(p245, p246, p247, p248) -- Line: 1935
    -- upvalues: u244 (copy)
    if p246[p245] then
        return true;
    end;

    if p248[p245.Name] then
        return true;
    end;

    local ClassName = p245.ClassName;

    return (p247[ClassName] or u244[ClassName]) and true or false;
end;

function u1.ClearScrollItems(p249, p250) -- Line: 1960
    -- upvalues: u244 (copy)
    if not p249 then
        return;
    end;

    local v251 = {};
    local v252 = {};
    local v253 = {};

    if p250 then
        if p250.keepInstances then
            for _, v in p250.keepInstances do
                v251[v] = true;
            end;
        end;

        if p250.keepClasses then
            for _, v in p250.keepClasses do
                v252[v] = true;
            end;
        end;

        if p250.keepNames then
            for _, v in p250.keepNames do
                v253[v] = true;
            end;
        end;
    end;

    for _, child in p249:GetChildren() do
        local v254;

        if v251[child] or v253[child.Name] then
            v254 = true;
        else
            local ClassName = child.ClassName;
            v254 = (v252[ClassName] or u244[ClassName]) and true or false;
        end;

        if not v254 then
            child:Destroy();
        end;
    end;
end;

local function _scrollAlignOffset(p255, p256, p257) -- Line: 2026
    if p257 == "left" or p257 == "top" then
        return 0;
    end;

    if p257 == "right" or p257 == "bottom" then
        return p255 - p256;
    end;

    return p255 * 0.5 - p256 * 0.5;
end;

local function _cancelScrollToChildTween(p258) -- Line: 2041
    -- upvalues: u5 (copy)
    local v259 = u5[p258];

    if v259 then
        v259:Cancel();
        u5[p258] = nil;
    end;
end;

local function _isScrollChildAbsoluteReady(p260, p261) -- Line: 2055
    local X = p261.AbsoluteSize.X;
    local Y = p261.AbsoluteSize.Y;
    local v262;

    if p260.AbsoluteWindowSize.X > 1 or p260.AbsoluteWindowSize.Y > 1 then
        v262 = X > 1 and true or Y > 1;
    else
        v262 = false;
    end;

    return v262;
end;

function u1.ScheduleScrollToChild(u263, u264, p265) -- Line: 2072
    -- upvalues: u4 (copy), u1 (copy), u5 (copy), TweenService (copy)
    if not (u263 and (u264 and u264:IsDescendantOf(u263))) then
        return;
    end;

    local u266 = p265 or {};
    local u267 = u266.alignX or "center";
    local u268 = u266.alignY or "center";
    local u269 = u266.useTween == nil and true or u266.useTween;
    local u270 = u266.tweenInfo or u4;
    local u271 = math.max(1, u266.layoutWaitFrames or 2);
    local u272 = u266.skipLayoutRefresh == true;
    task.defer(function() -- Line: 2089
        -- upvalues: u266 (copy), u263 (copy), u271 (copy), u272 (copy), u264 (copy), u1 (ref), u268 (copy), u267 (copy), u5 (ref), u269 (copy), TweenService (ref), u270 (copy)
        local waitSec = u266.waitSec;

        if waitSec and waitSec > 0 then
            task.wait(waitSec);
        end;

        local ScrollingDirection = u263.ScrollingDirection;
        local v273 = ScrollingDirection == Enum.ScrollingDirection.X and true or ScrollingDirection == Enum.ScrollingDirection.XY;
        local v274 = ScrollingDirection == Enum.ScrollingDirection.Y and true or ScrollingDirection == Enum.ScrollingDirection.XY;

        for i = 1, u271 do
            if not u272 then
                local v275 = u263;
                local v276 = u264;
                local X = v276.AbsoluteSize.X;
                local Y = v276.AbsoluteSize.Y;
                local v277;

                if v275.AbsoluteWindowSize.X > 1 or v275.AbsoluteWindowSize.Y > 1 then
                    v277 = X > 1 and true or Y > 1;
                else
                    v277 = false;
                end;

                if not v277 then
                    u1.SetUIlistSize(u263);
                end;
            end;

            task.wait();

            if not (u264.Parent and u264:IsDescendantOf(u263)) then
                return;
            end;

            local v278 = u263;
            local v279 = u264;
            local X = v279.AbsoluteSize.X;
            local Y = v279.AbsoluteSize.Y;
            local v280;

            if v278.AbsoluteWindowSize.X > 1 or v278.AbsoluteWindowSize.Y > 1 then
                v280 = X > 1 and true or Y > 1;
            else
                v280 = false;
            end;

            if v280 then
                break;
            end;

            if i == u271 and not u272 then
                u1.SetUIlistSize(u263);
            end;
        end;

        if u272 then
            local v281 = u263;
            local v282 = u264;
            local X = v282.AbsoluteSize.X;
            local Y = v282.AbsoluteSize.Y;
            local v283;

            if v281.AbsoluteWindowSize.X > 1 or v281.AbsoluteWindowSize.Y > 1 then
                v283 = X > 1 and true or Y > 1;
            else
                v283 = false;
            end;

            if not v283 then
                for _ = 1, math.max(0, 8 - u271) do
                    task.wait();

                    if not (u264.Parent and u264:IsDescendantOf(u263)) then
                        return;
                    end;

                    local v284 = u263;
                    local v285 = u264;
                    local X2 = v285.AbsoluteSize.X;
                    local Y2 = v285.AbsoluteSize.Y;
                    local v286;

                    if v284.AbsoluteWindowSize.X > 1 or v284.AbsoluteWindowSize.Y > 1 then
                        v286 = X2 > 1 and true or Y2 > 1;
                    else
                        v286 = false;
                    end;

                    if v286 then
                        break;
                    end;
                end;
            end;
        end;

        if not (u264.Parent and u264:IsDescendantOf(u263)) then
            return;
        end;

        local v287 = u263;
        local v288 = u264;
        local X = v288.AbsoluteSize.X;
        local Y = v288.AbsoluteSize.Y;
        local v289;

        if v287.AbsoluteWindowSize.X > 1 or v287.AbsoluteWindowSize.Y > 1 then
            v289 = X > 1 and true or Y > 1;
        else
            v289 = false;
        end;

        if not v289 then
            return;
        end;

        local CanvasPosition = u263.CanvasPosition;
        local v290;

        if v274 then
            local Y2 = u263.AbsoluteWindowSize.Y;

            if Y2 < 1 then
                Y2 = u263.Size.Y.Offset;
            end;

            local v291 = math.max(0, u263.AbsoluteCanvasSize.Y - Y2);
            local Y3 = u264.AbsoluteSize.Y;
            local v292 = u268;
            local v293;

            if v292 == "left" or v292 == "top" then
                v293 = 0;
            elseif v292 == "right" or v292 == "bottom" then
                v293 = Y3 - Y2;
            else
                v293 = Y3 * 0.5 - Y2 * 0.5;
            end;

            v290 = Vector2.new(CanvasPosition.X, (math.clamp(u264.AbsolutePosition.Y - u263.AbsolutePosition.Y + u263.CanvasPosition.Y + v293, 0, v291)));
        else
            v290 = CanvasPosition;
        end;

        if v273 then
            local X2 = u263.AbsoluteWindowSize.X;

            if X2 < 1 then
                X2 = u263.Size.X.Offset;
            end;

            local v294 = math.max(0, u263.AbsoluteCanvasSize.X - X2);
            local X3 = u264.AbsoluteSize.X;
            local v295 = u267;
            local v296;

            if v295 == "left" or v295 == "top" then
                v296 = 0;
            elseif v295 == "right" or v295 == "bottom" then
                v296 = X3 - X2;
            else
                v296 = X3 * 0.5 - X2 * 0.5;
            end;

            v290 = Vector2.new(math.clamp(u264.AbsolutePosition.X - u263.AbsolutePosition.X + u263.CanvasPosition.X + v296, 0, v294), v290.Y);
        end;

        if ScrollingDirection == Enum.ScrollingDirection.X then
            CanvasPosition = Vector2.new(CanvasPosition.X, 0);
            v290 = Vector2.new(v290.X, 0);
        end;

        if (v290 - CanvasPosition).Magnitude < 1 then
            return;
        end;

        local v297 = u263;
        local v298 = u5[v297];

        if v298 then
            v298:Cancel();
            u5[v297] = nil;
        end;

        u263.CanvasPosition = CanvasPosition;

        if not u269 then
            u263.CanvasPosition = v290;

            return;
        end;

        local u299 = TweenService:Create(u263, u270, {
            CanvasPosition = v290
        });
        u5[u263] = u299;
        u299.Completed:Once(function() -- Line: 2176
            -- upvalues: u5 (ref), u263 (ref), u299 (copy)
            if u5[u263] == u299 then
                u5[u263] = nil;
            end;
        end);
        u299:Play();
    end);
end;

function u1.FindButtonInFrame(p300) -- Line: 2193
    if not p300 then
        return nil;
    end;

    local v301 = p300:FindFirstChild("Btn") or p300:FindFirstChild("Button");

    if v301 and v301:IsA("GuiButton") then
        return v301;
    end;

    local v302 = p300:FindFirstChildWhichIsA("GuiButton");

    if v302 and v302:IsA("GuiButton") then
        return v302;
    end;

    return nil;
end;

local function _findCfgForViewport(p303, p304) -- Line: 2212
    -- upvalues: CfgFind (copy)
    return p304 and CfgFind.FindCfgByID(p303, p304) or (CfgFind.FindCfgByID(p303) or CfgFind.GetCfgByNameAndID("weaponConf", p303));
end;

local function _readCameraOffsetFrom(p305) -- Line: 2226
    local v306 = p305:GetAttribute("CameraOffset");

    if typeof(v306) == "CFrame" then
        return v306;
    end;

    local v307 = p305:IsA("Model") and p305.PrimaryPart;

    if v307 then
        local v308 = v307:GetAttribute("CameraOffset");

        if typeof(v308) == "CFrame" then
            return v308;
        end;
    end;

    return nil;
end;

local function _resolveViewportCameraOffset(p309, p310) -- Line: 2243
    -- upvalues: ItemType (copy)
    if p310 then
        p310 = tonumber(p310.tp);
    end;

    if p310 == ItemType.Armor then
        local Torso = p309:FindFirstChild("Torso");

        if Torso and Torso:IsA("Model") then
            local v311 = Torso:GetAttribute("CameraOffset");

            if typeof(v311) ~= "CFrame" then
                local v312 = Torso:IsA("Model") and Torso.PrimaryPart;

                if v312 then
                    v311 = v312:GetAttribute("CameraOffset");

                    if typeof(v311) ~= "CFrame" then
                        v311 = nil;
                    end;
                else
                    v311 = nil;
                end;
            end;

            if v311 then
                return v311;
            end;
        end;

        local Head = p309:FindFirstChild("Head");

        if Head and Head:IsA("Model") then
            local v313 = Head:GetAttribute("CameraOffset");

            if typeof(v313) ~= "CFrame" then
                local v314 = Head:IsA("Model") and Head.PrimaryPart;

                if v314 then
                    v313 = v314:GetAttribute("CameraOffset");

                    if typeof(v313) ~= "CFrame" then
                        v313 = nil;
                    end;
                else
                    v313 = nil;
                end;
            end;

            if v313 then
                return v313;
            end;
        end;
    end;

    local v315 = p309:GetAttribute("CameraOffset");

    if typeof(v315) == "CFrame" then
        return v315;
    end;

    local v316 = p309:IsA("Model") and p309.PrimaryPart;

    if v316 then
        local v317 = v316:GetAttribute("CameraOffset");

        if typeof(v317) == "CFrame" then
            return v317;
        end;
    end;

    return nil;
end;

local function _readTypedAttrFrom(p318, p319, p320) -- Line: 2271
    local v321 = p318:GetAttribute(p319);

    if typeof(v321) == p320 then
        return v321;
    end;

    local v322 = p318:IsA("Model") and p318.PrimaryPart;

    if v322 then
        local v323 = v322:GetAttribute(p319);

        if typeof(v323) == p320 then
            return v323;
        end;
    end;

    return nil;
end;

local function _resolveViewportLightAttr(p324, p325, p326, p327) -- Line: 2296
    -- upvalues: ItemType (copy)
    if tonumber(p325) == ItemType.Armor then
        local Torso = p324:FindFirstChild("Torso");

        if Torso and Torso:IsA("Model") then
            local v328 = Torso:GetAttribute(p326);

            if typeof(v328) ~= p327 then
                if Torso:IsA("Model") then
                    local PrimaryPart = Torso.PrimaryPart;

                    if PrimaryPart then
                        v328 = PrimaryPart:GetAttribute(p326);

                        if typeof(v328) ~= p327 then
                            v328 = nil;
                        end;
                    else
                        v328 = nil;
                    end;
                else
                    v328 = nil;
                end;
            end;

            if v328 ~= nil then
                return v328;
            end;
        end;

        local Head = p324:FindFirstChild("Head");

        if Head and Head:IsA("Model") then
            local v329 = Head:GetAttribute(p326);

            if typeof(v329) ~= p327 then
                if Head:IsA("Model") then
                    local PrimaryPart = Head.PrimaryPart;

                    if PrimaryPart then
                        v329 = PrimaryPart:GetAttribute(p326);

                        if typeof(v329) ~= p327 then
                            v329 = nil;
                        end;
                    else
                        v329 = nil;
                    end;
                else
                    v329 = nil;
                end;
            end;

            if v329 ~= nil then
                return v329;
            end;
        end;
    end;

    local v330 = p324:GetAttribute(p326);

    if typeof(v330) == p327 then
        return v330;
    end;

    local v331 = p324:IsA("Model") and p324.PrimaryPart;

    if v331 then
        local v332 = v331:GetAttribute(p326);

        if typeof(v332) == p327 then
            return v332;
        end;
    end;

    return nil;
end;

local function _applyViewportLightFromModel(p333, p334, p335) -- Line: 2324
    -- upvalues: _resolveViewportLightAttr (copy)
    local v336 = p333:GetAttribute("LightDirection");

    if not v336 then
        v336 = p333.LightDirection;
        p333:SetAttribute("LightDirection", v336);
    end;

    local v337 = _resolveViewportLightAttr(p334, p335, "LightDirection", "Vector3");

    if v337 then
        p333.LightDirection = v337;
    else
        p333.LightDirection = v336;
    end;

    local v338 = p333:GetAttribute("LightColor");

    if not v338 then
        v338 = p333.LightColor;
        p333:SetAttribute("LightColor", v338);
    end;

    local v339 = _resolveViewportLightAttr(p334, p335, "LightColor", "Color3");

    if v339 then
        p333.LightColor = v339;

        return;
    end;

    p333.LightColor = v338;
end;

local function _itemUsesWeaponViewportPrimary(p340) -- Line: 2350
    -- upvalues: ItemType (copy)
    return tonumber(p340) == ItemType.Weapon;
end;

local function _itemUsesLongItemShadowOffset(p341) -- Line: 2354
    -- upvalues: ItemType (copy)
    local v342 = tonumber(p341);

    return v342 == ItemType.Weapon and true or v342 == ItemType.Broom;
end;

local function _getModelCategoryByItemTp(p343) -- Line: 2359
    -- upvalues: ItemType (copy), ModelCategory (copy)
    local v344 = tonumber(p343);

    if v344 == ItemType.Weapon then
        return ModelCategory.Weapon;
    end;

    if v344 == ItemType.Armor then
        return ModelCategory.Armor;
    end;

    if v344 == ItemType.Pet then
        return ModelCategory.Pet;
    end;

    if v344 == ItemType.PetEgg then
        return ModelCategory.PetEgg;
    end;

    if v344 == ItemType.Enemy then
        return ModelCategory.Enemy;
    end;

    if v344 == ItemType.Material then
        return ModelCategory.Material;
    end;

    if v344 == ItemType.Potion then
        return ModelCategory.Potion;
    end;

    if v344 == ItemType.Broom then
        return ModelCategory.Broom;
    end;

    return nil;
end;

local function _getViewportModelClone(p345, p346) -- Line: 2388
    -- upvalues: _getModelCategoryByItemTp (copy), ResourceUtil (copy), ModelCategory (copy)
    if not p345 or p345 == "" then
        return nil;
    end;

    local v347 = _getModelCategoryByItemTp(p346);

    if v347 then
        return ResourceUtil.GetModel(v347, p345);
    end;

    for _, v in {
        ModelCategory.Material,
        ModelCategory.Weapon,
        ModelCategory.Pet,
        ModelCategory.Effect,
        ModelCategory.PetEgg
    } do
        local v348 = ResourceUtil.GetModel(v, p345);

        if v348 then
            return v348;
        end;
    end;

    return nil;
end;

local function _destroyViewportShadow(p349) -- Line: 2405
    if not (p349 and p349.Parent) then
        return;
    end;

    local v350 = p349.Parent:FindFirstChild(p349.Name .. "Shadow");

    if v350 then
        v350:Destroy();
    end;
end;

local function _setWeaponAbsoluteCenterPivot(p351) -- Line: 2416
    local v352 = p351:FindFirstChild("绝对中心");

    if not (v352 and v352:IsA("Part")) then
        if v352 then
            v352:Destroy();
        end;

        v352 = Instance.new("Part");
        v352.Name = "绝对中心";
        v352.Size = Vector3.new(0.1, 0.1, 0.1);
        v352.Transparency = 1;
        v352.CanCollide = false;
        v352.CanQuery = false;
        v352.CastShadow = false;
        v352.Massless = true;
        v352.Anchored = true;
        v352.Parent = p351;
    end;

    local v353 = p351:GetPivot();
    local Position = select(1, p351:GetBoundingBox()).Position;
    v352.CFrame = v353 * CFrame.new(v353:PointToObjectSpace(Position));
    p351.PrimaryPart = v352;
end;

local function _getAttrTemplate(p354) -- Line: 2442
    local v355 = p354:FindFirstChild("AttrTemp") or p354:FindFirstChild("_AttrTemp");

    if v355 and v355:IsA("Frame") then
        return v355;
    end;

    return nil;
end;

local function _clearAttrRows(p356, p357) -- Line: 2450
    for _, child in ipairs(p356:GetChildren()) do
        if child ~= p357 and not child:IsA("UIListLayout") then
            child:Destroy();
        end;
    end;

    p357.Visible = false;
end;

local function _formatPlrAttrValueStr(p358, p359) -- Line: 2459
    -- upvalues: MathMgr (copy)
    if p358 then
        p358 = p358.isPercent == 1;
    end;

    local v360 = tonumber(p359);

    if p358 and v360 then
        return MathMgr.GetPercentStr(v360 * 100);
    end;

    if v360 then
        return MathMgr.getNumStr(v360);
    end;

    return tostring(p359);
end;

local function _getPlrAttrValueColor(p361) -- Line: 2471
    -- upvalues: u14 (copy)
    if not (p361 and p361.Color) then
        return u14;
    end;

    local Color = p361.Color;

    if type(Color) ~= "string" then
        if type(Color) == "table" and Color.r then
            return Color3.new(Color.r, Color.g, Color.b);
        end;

        return u14;
    end;

    if string.sub(Color, 1, 1) == "#" then
        Color = string.sub(Color, 2);
    end;

    if #Color == 6 then
        local v362 = Color:sub(1, 2);
        local v363 = tonumber(v362, 16);
        local v364 = Color:sub(3, 4);
        local v365 = tonumber(v364, 16);
        local v366 = Color:sub(5, 6);
        local v367 = tonumber(v366, 16);

        if v363 and (v365 and v367) then
            return Color3.new(v363 / 255, v365 / 255, v367 / 255);
        end;
    end;

    return Color3.fromHex(p361.Color);
end;

local function _fillRowsFromCfgAttr(p368, p369, p370, p371) -- Line: 2497
    -- upvalues: CfgFind (copy), MathMgr (copy), _getPlrAttrValueColor (copy)
    local v372 = type(p370.attr) == "table" and p370.attr or (p370.attr and ({ p370.attr } or {}) or {});
    local v373 = type(p370.attrNum) == "table" and p370.attrNum or (p370.attrNum and { p370.attrNum } or {});
    local v374 = 0;

    for i = 1, math.max(#v372, #v373) do
        local v375 = v372[i];
        local v376 = v373[i];

        if v375 ~= nil and v376 ~= nil then
            local v377 = CfgFind.GetPlrDataCfg(v375);

            if v377 and v377.ZhName then
                local v378 = p369:Clone();
                v374 = v374 + 1;
                v378.LayoutOrder = v374;
                v378.Parent = p368;
                v378.Visible = true;
                local v379 = v377.ZhName .. "为";
                local v380;

                if v377 then
                    v380 = v377.isPercent == 1;
                else
                    v380 = v377;
                end;

                local v381 = tonumber(v376);
                local v382;

                if v380 and v381 then
                    v382 = MathMgr.GetPercentStr(v381 * 100);
                elseif v381 then
                    v382 = MathMgr.getNumStr(v381);
                else
                    v382 = tostring(v376);
                end;

                p371(v378, v379, v382, (_getPlrAttrValueColor(v377)));
            end;
        end;
    end;

    return v374;
end;

function u1.SetWeaponAbsoluteCenterPivot(p383) -- Line: 2535
    -- upvalues: _setWeaponAbsoluteCenterPivot (copy)
    _setWeaponAbsoluteCenterPivot(p383);
end;

function u1.SetViewPort(p384, p385, p386, p387) -- Line: 2550
    -- upvalues: CfgFind (copy), ItemType (copy), ArmorModelUtil (copy), _getViewportModelClone (copy), InsMgr (copy), _resolveViewportCameraOffset (copy), ViewportFrameModule (copy), _setWeaponAbsoluteCenterPivot (copy), _applyViewportLightFromModel (copy), u11 (copy)
    if not p384 then
        return nil;
    end;

    if p385 == nil or p385 == 0 then
        local v388 = p384 and p384.Parent and p384.Parent:FindFirstChild(p384.Name .. "Shadow");

        if v388 then
            v388:Destroy();
        end;

        for _, child in p384:GetChildren() do
            if not child:IsA("Camera") then
                child:Destroy();
            end;
        end;

        p384.Visible = false;
        p384:SetAttribute("ID", nil);
        p384:SetAttribute("DisplayModel", nil);

        return nil;
    end;

    local v389 = p384:GetAttribute("ID");

    if type(p387) ~= "table" then
        p387 = nil;
    end;

    local v390;

    if p387 then
        v390 = tonumber(p387.itemTp) or nil;
    else
        v390 = nil;
    end;

    local v391 = v390 and CfgFind.FindCfgByID(p385, v390) or (CfgFind.FindCfgByID(p385) or CfgFind.GetCfgByNameAndID("weaponConf", p385));
    local v392 = nil;

    if p387 and (type(p387.displayModelName) == "string" and p387.displayModelName ~= "") then
        v392 = p387.displayModelName;
    elseif v391 then
        v392 = v391.model or v391.Model;
    end;

    local v393 = p384:GetAttribute("DisplayModel");

    if v389 == p385 and (v393 == v392 and p384:FindFirstChildWhichIsA("Model")) then
        p384.Visible = true;

        return true;
    end;

    local v394 = p384.Name .. "Shadow";
    local Parent = p384.Parent;
    local v395 = (not p386 and Parent and true or false) and Parent:FindFirstChild(v394);

    if v395 then
        v395:Destroy();
    end;

    for _, child in p384:GetChildren() do
        if not child:IsA("Camera") then
            child:Destroy();
        end;
    end;

    local v396 = v390 and CfgFind.FindCfgByID(p385, v390) or (CfgFind.FindCfgByID(p385) or CfgFind.GetCfgByNameAndID("weaponConf", p385));

    if not v396 then
        return false;
    end;

    local v397 = v392 or (v396.model or v396.Model);

    if not v397 or v397 == "" then
        return false;
    end;

    p384:SetAttribute("ID", p385);
    p384:SetAttribute("DisplayModel", v397);
    local v398 = v390 or tonumber(v396.tp);
    local v399;

    if v398 == ItemType.Armor then
        v399 = ArmorModelUtil.BuildViewportShowModel(v397);
    else
        v399 = nil;
    end;

    local v400 = v399 or _getViewportModelClone(v397, v398);

    if not v400 then
        return false;
    end;

    local v401 = InsMgr.GetIns("Camera", "Camera", p384);
    p384.CurrentCamera = v401;
    local v402 = _resolveViewportCameraOffset(v400, v396);

    if v402 then
        v401:PivotTo(v402);
    else
        v400:PivotTo(CFrame.new());
        v401:PivotTo(ViewportFrameModule.ResolveShowModelCamera(v400));
    end;

    v400:PivotTo(CFrame.new());

    if tonumber(v398) == ItemType.Weapon then
        _setWeaponAbsoluteCenterPivot(v400);
    end;

    v400.Parent = p384;
    p384.Visible = true;
    _applyViewportLightFromModel(p384, v400, v398);

    if p386 and Parent then
        local v403 = tonumber(v398);
        local v404 = (v403 == ItemType.Weapon and true or v403 == ItemType.Broom) and 0.06 or 0.08;
        local v405 = Parent:FindFirstChild(v394);

        if not v405 then
            v405 = p384:Clone();
            v405.Name = v394;
            v405.Parent = Parent;
            v405.ZIndex = math.max(0, p384.ZIndex - 1);
            v405.ImageColor3 = u11;
            v405.ImageTransparency = 0.4;
        end;

        v405.LightDirection = p384.LightDirection;
        v405.LightColor = p384.LightColor;
        local Position = p384.Position;
        v405.Position = UDim2.new(Position.X.Scale * (v404 + 1), Position.X.Offset, Position.Y.Scale * (v404 + 1), Position.Y.Offset);

        for _, child in v405:GetChildren() do
            if not child:IsA("Camera") then
                child:Destroy();
            end;
        end;

        local v406 = v405:FindFirstChildOfClass("Camera") or InsMgr.GetIns("Camera", "Camera", v405);
        v405.CurrentCamera = v406;
        v406.CFrame = v401.CFrame;
        local v407 = v400:Clone();
        v407:PivotTo(CFrame.new());

        if tonumber(v398) == ItemType.Weapon then
            _setWeaponAbsoluteCenterPivot(v407);
        end;

        v407.Parent = v405;
        v405.Visible = true;
    end;

    return true;
end;

function u1.SetAttributeItem(p408, p409, p410, p411, p412, p413) -- Line: 2704
    -- upvalues: TranslationHelper (copy), u13 (copy), u12 (copy), u14 (copy)
    local AttrName = p408:FindFirstChild("AttrName");
    local AttrValue = p408:FindFirstChild("AttrValue");
    local mpTp = p408:FindFirstChild("mpTp");
    local v414;

    if mpTp and mpTp:IsA("TextLabel") then
        v414 = mpTp;
    else
        v414 = nil;
    end;

    local v415;

    if p413 == true then
        v415 = v414 ~= nil;
    else
        v415 = false;
    end;

    if AttrName then
        TranslationHelper.SetText(AttrName, p409);

        if p409 == "伤害为" then
            AttrName.TextColor3 = u13;
        else
            AttrName.TextColor3 = u12;
        end;
    end;

    if v415 then
        if AttrValue then
            AttrValue.Visible = false;
            local ElementIcon = AttrValue:FindFirstChild("ElementIcon");

            if ElementIcon then
                ElementIcon.Visible = false;
            end;
        end;

        TranslationHelper.SetText_UnTrans(v414, p410);
        v414.TextColor3 = p411 or u14;
        v414.Visible = true;

        if mpTp and (mpTp:IsA("GuiObject") and mpTp ~= v414) then
            mpTp.Visible = true;
        end;

        return;
    end;

    if mpTp and mpTp:IsA("GuiObject") then
        mpTp.Visible = false;
    end;

    if not AttrValue then
        return;
    end;

    AttrValue.Visible = true;
    TranslationHelper.SetText_UnTrans(AttrValue, p410);
    AttrValue.TextColor3 = p411 or u14;
    local ElementIcon = AttrValue:FindFirstChild("ElementIcon");

    if ElementIcon then
        if p412 then
            ElementIcon.Visible = true;
            ElementIcon.Image = "rbxassetid://" .. tostring(p412);

            return;
        end;

        ElementIcon.Visible = false;
    end;
end;

function u1.ShowItemAttributes(p416, p417, p418, p419, p420) -- Line: 2775
    -- upvalues: _clearAttrRows (copy), u1 (copy), ItemType (copy), _fillRowsFromCfgAttr (copy)
    if not (p416 and p418) then
        return 0;
    end;

    local v421 = p416:FindFirstChild("AttrTemp") or p416:FindFirstChild("_AttrTemp");

    if not (v421 and v421:IsA("Frame")) then
        v421 = nil;
    end;

    if not v421 then
        return 0;
    end;

    _clearAttrRows(p416, v421);

    return p419 ~= ItemType.Weapon and p419 ~= ItemType.Armor and 0 or _fillRowsFromCfgAttr(p416, v421, p418, function(p422, p423, p424, p425) -- Line: 2793, Name: setRow
        -- upvalues: u1 (ref)
        u1.SetAttributeItem(p422, p423, p424, p425);
    end);
end;

function u1.FormatPlrAttrValueStr(p426, p427) -- Line: 2811
    -- upvalues: _formatPlrAttrValueStr (copy)
    return _formatPlrAttrValueStr(p426, p427);
end;

function u1.GetPlrAttrValueColor(p428) -- Line: 2820
    -- upvalues: _getPlrAttrValueColor (copy)
    return _getPlrAttrValueColor(p428);
end;

local u429 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u430 = {};
local u431 = 0;
local u432 = false;

local function _stopGuideTipsTweens() -- Line: 2837
    -- upvalues: u431 (ref), u430 (copy)
    u431 = u431 + 1;

    for _, v in ipairs(u430) do
        v:Cancel();
    end;

    table.clear(u430);

    return u431;
end;

local function _resetGuideTipsOpacity(p433) -- Line: 2852
    p433.GroupTransparency = 0;
end;

local function _playGuideTipsFadeOut(u434, u435) -- Line: 2864
    -- upvalues: TweenService (copy), u429 (copy), u430 (copy), u431 (ref), u432 (ref)
    local v436 = TweenService:Create(u434, u429, {
        GroupTransparency = 1
    });
    table.insert(u430, v436);
    v436.Completed:Connect(function(p437) -- Line: 2867
        -- upvalues: u435 (copy), u431 (ref), u430 (ref), u432 (ref), u434 (copy)
        if u435 ~= u431 then
            return;
        end;

        table.clear(u430);

        if u432 then
            return;
        end;

        u434.Visible = false;
        u434.GroupTransparency = 0;
    end);
    v436:Play();
end;

function u1.SetGuideTipsVisible(p438) -- Line: 2889
    -- upvalues: Players (copy), u432 (ref), u431 (ref), u430 (copy), _playGuideTipsFadeOut (copy)
    local LocalPlayer = Players.LocalPlayer;
    local v439;

    if LocalPlayer then
        v439 = LocalPlayer:FindFirstChild("PlayerGui");

        if not (v439 and v439:IsA("PlayerGui")) then
            v439 = nil;
        end;
    else
        v439 = nil;
    end;

    if not v439 then
        return;
    end;

    local Guide = v439:FindFirstChild("Guide");

    if not Guide then
        return;
    end;

    local GuideTips = Guide:FindFirstChild("GuideTips");

    if not (GuideTips and GuideTips:IsA("CanvasGroup")) then
        return;
    end;

    if p438 ~= false then
        u432 = true;
        u431 = u431 + 1;

        for _, v in ipairs(u430) do
            v:Cancel();
        end;

        table.clear(u430);
        GuideTips.GroupTransparency = 0;
        GuideTips.Visible = true;

        return;
    end;

    u432 = false;

    if not GuideTips.Visible then
        u431 = u431 + 1;

        for _, v in ipairs(u430) do
            v:Cancel();
        end;

        table.clear(u430);
        GuideTips.GroupTransparency = 0;

        return;
    end;

    if GuideTips.GroupTransparency < 0.999 then
        u431 = u431 + 1;

        for _, v in ipairs(u430) do
            v:Cancel();
        end;

        table.clear(u430);
        _playGuideTipsFadeOut(GuideTips, u431);

        return;
    end;

    u431 = u431 + 1;

    for _, v in ipairs(u430) do
        v:Cancel();
    end;

    table.clear(u430);
    GuideTips.Visible = false;
    GuideTips.GroupTransparency = 0;
end;

function u1.SetGuideArrowVisible(u440) -- Line: 2937
    -- upvalues: Players (copy)
    task.spawn(function() -- Line: 2938
        -- upvalues: Players (ref), u440 (copy)
        local LocalPlayer = Players.LocalPlayer;
        local v441;

        if LocalPlayer then
            v441 = LocalPlayer:FindFirstChild("PlayerGui");

            if not (v441 and v441:IsA("PlayerGui")) then
                v441 = nil;
            end;
        else
            v441 = nil;
        end;

        if not v441 then
            return;
        end;

        local Guide_UIOverlay = v441:FindFirstChild("Guide_UIOverlay");

        if not Guide_UIOverlay then
            if not u440 then
                return;
            end;

            Guide_UIOverlay = v441:WaitForChild("Guide_UIOverlay", (1 / 0));
        end;

        if Guide_UIOverlay and Guide_UIOverlay:IsA("ScreenGui") then
            Guide_UIOverlay.Enabled = u440;
        end;
    end);
end;

for i, v in require(script.Gradients) do
    u1[i] = v;
end;

function u1.ApplyItemIconOrViewport(p442, p443, p444) -- Line: 2969
    -- upvalues: CfgFind (copy), u1 (copy)
    if not p442 then
        return;
    end;

    local Icon = p442:FindFirstChild("Icon");
    local ViewportFrame = p442:FindFirstChild("ViewportFrame");
    local v445 = p444 or "";
    local v446 = CfgFind.FindCfgByID(p443);
    local v447 = not v446 and "" or tostring(v446.Icon or "");

    if v445 ~= "" then
        if Icon and Icon:IsA("ImageLabel") then
            Icon.Visible = true;
            u1.SetImage(Icon, v445);
        end;

        if ViewportFrame and ViewportFrame:IsA("GuiObject") then
            ViewportFrame.Visible = false;
        end;

        return;
    end;

    if v447 == "" or v447 == "0" then
        if Icon and Icon:IsA("ImageLabel") then
            Icon.Visible = false;
        end;

        if ViewportFrame and ViewportFrame:IsA("ViewportFrame") then
            if u1.SetViewPort(ViewportFrame, p443, true) then
                ViewportFrame.Visible = true;

                return;
            end;

            ViewportFrame.Visible = false;

            if Icon and Icon:IsA("ImageLabel") then
                Icon.Visible = true;
            end;
        end;

        return;
    end;

    if Icon and Icon:IsA("ImageLabel") then
        Icon.Visible = true;
        u1.SetImage(Icon, v447);
    end;

    if ViewportFrame and ViewportFrame:IsA("GuiObject") then
        ViewportFrame.Visible = false;
    end;
end;

function u1.GetTaskDes(p448, p449, p450) -- Line: 3024
    -- upvalues: CfgFind (copy), ItemType (copy)
    if type(p448) ~= "table" or (type(p450) ~= "string" or p450 == "") then
        return nil, nil;
    end;

    local need = p448.need;
    local param = p448.param;
    local v451;

    if type(need) == "table" then
        v451 = tonumber(need[p449]) or (tonumber(need[1]) or 1);
    else
        v451 = tonumber(need) or 1;
    end;

    local v452;

    if type(param) == "table" then
        v452 = param[p449];

        if v452 == nil then
            v452 = param[1];
        end;
    else
        v452 = param;
    end;

    local v453 = { v451 };

    if p450 == "击杀任意怪物" then
        return { v451 }, nil;
    end;

    if p450 == "炼制N个任意药水" or (p450 == "通关N次任意关卡" or p450 == "在线时长N分钟") then
        return { v451 }, nil;
    end;

    if p450 == "收集N个任意材料" then
        return {
            v451,
            { "任意材料" }
        }, nil;
    end;

    if p450 == "击杀N只指定怪物" then
        local v454 = CfgFind.FindCfgByID(v452, ItemType.Enemy);

        if v454 then
            table.insert(v453, { v454.ZhName });
        else
            table.insert(v453, v452);
        end;

        return v453, nil;
    end;

    if p450 == "收集N个指定材料" then
        local v455 = CfgFind.FindCfgByID(v452, ItemType.Material);

        if v455 then
            table.insert(v453, { v455.ZhName });
        else
            table.insert(v453, v452);
        end;

        return v453, nil;
    end;

    if p450 == "购买N个指定道具" then
        local v456 = CfgFind.FindCfgByID(v452);

        if v456 then
            table.insert(v453, { v456.ZhName });
        else
            table.insert(v453, v452);
        end;

        return v453, nil;
    end;

    local v457 = CfgFind.FindCfgByID(v452, ItemType.Enemy);

    if v457 then
        table.insert(v453, { v457.ZhName });
    else
        table.insert(v453, v452);
    end;

    return v453, nil;
end;

function u1.GetTaskDesText(p458, p459, p460) -- Line: 3098
    -- upvalues: u1 (copy), CfgFind (copy)
    local v461, v462 = u1.GetTaskDes(p458, p459, p460);

    if not v461 then
        return nil, nil;
    end;

    if v462 then
        return v461, v462;
    end;

    local v463 = CfgFind.GetTasktypeCfg(p460);

    return v461, v463 and v463.ZhName or nil;
end;

return u1;