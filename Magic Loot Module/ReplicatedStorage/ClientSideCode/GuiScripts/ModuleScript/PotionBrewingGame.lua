-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local Workspace = game:GetService("Workspace");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local GameCfg = require(script.GameCfg);
local GameUtil = require(script.GameUtil);
local AddListen = UtilsSystem.AddListen;
local AnimationModule = UtilsSystem.AnimationModule;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local GetData = UtilsSystem.GetData;
local HumanModule = UtilsSystem.HumanModule;
local InsMgr = UtilsSystem.InsMgr;
local LocalPlayer = UtilsSystem.LocalPlayer;
local Log = UtilsSystem.Log;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local TimeTransfer = UtilsSystem.TimeTransfer;
local TipsModule = UtilsSystem.TipsModule;
local UIMgr = UtilsSystem.UIMgr;
local Alchemy = GetData.Alchemy;
local Backpack = GetData.Backpack;
local ItemType = EnumMgr.ItemType;
local u1 = {};
local u2 = GameUtil.CreateSceneManager();
local u3 = GameUtil.CreateOrchestrator({
    SceneManager = u2
});
local u4 = false;
local u5 = 0;
local u6 = false;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = {};
local u18 = {};
local u19 = 0;
local u20 = nil;
local u21 = nil;
local u22 = nil;

local function _findBlackGui() -- Line: 99
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if not (PlayerGui and PlayerGui:IsA("PlayerGui")) then
        return nil;
    end;

    local BlackGui = PlayerGui:FindFirstChild("BlackGui");

    if BlackGui and BlackGui:IsA("ScreenGui") then
        return BlackGui;
    end;

    return nil;
end;

local function _setBlackGuiEnabled(p23) -- Line: 117
    -- upvalues: LocalPlayer (copy), Log (copy), u13 (ref), u14 (ref), u15 (ref)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");
    local v24;

    if PlayerGui and PlayerGui:IsA("PlayerGui") then
        v24 = PlayerGui:FindFirstChild("BlackGui");

        if not (v24 and v24:IsA("ScreenGui")) then
            v24 = nil;
        end;
    else
        v24 = nil;
    end;

    if not v24 then
        if p23 then
            Log.warn("[PotionBrewingGame] 缺少 PlayerGui.BlackGui");
        end;

        return nil;
    end;

    local BG = v24:FindFirstChild("BG");
    local v25 = v24:FindFirstChild("黑屏");

    if p23 then
        if u13 == nil then
            u13 = v24.Enabled;
        end;

        v24.Enabled = true;

        if BG and BG:IsA("GuiObject") then
            if u14 == nil then
                u14 = BG.Visible;
            end;

            BG.Visible = true;
        end;

        if v25 and v25:IsA("GuiObject") then
            if u15 == nil then
                u15 = v25.Visible;
            end;

            v25.Visible = false;
        end;
    else
        if BG and (BG:IsA("GuiObject") and u14 ~= nil) then
            BG.Visible = u14;
        end;

        if v25 and (v25:IsA("GuiObject") and u15 ~= nil) then
            v25.Visible = u15;
        end;

        if u13 == nil then
            v24.Enabled = false;
        else
            v24.Enabled = u13;
        end;

        u13 = nil;
        u14 = nil;
        u15 = nil;
    end;

    return nil;
end;

local function _setScreenGuiFullHidden(p26) -- Line: 172
    -- upvalues: LocalPlayer (copy), Log (copy), u16 (ref)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if not (PlayerGui and PlayerGui:IsA("PlayerGui")) then
        return nil;
    end;

    local ScreenGui_Full = PlayerGui:FindFirstChild("ScreenGui_Full");

    if ScreenGui_Full and ScreenGui_Full:IsA("ScreenGui") then
        if p26 then
            if u16 == nil then
                u16 = ScreenGui_Full.Enabled;
            end;

            ScreenGui_Full.Enabled = false;
        else
            if u16 ~= nil then
                ScreenGui_Full.Enabled = u16;
            end;

            u16 = nil;
        end;

        return nil;
    end;

    if p26 then
        Log.warn("[PotionBrewingGame] 缺少 PlayerGui.ScreenGui_Full");
    end;

    return nil;
end;

local function _ensurePopUiFrame() -- Line: 203
    -- upvalues: LocalPlayer (copy), Log (copy)
    local v27 = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5);

    if not (v27 and v27:IsA("PlayerGui")) then
        Log.warn("[PotionBrewingGame] 缺少 PlayerGui");

        return nil;
    end;

    local ScreenGui = v27:FindFirstChild("ScreenGui");

    if not (ScreenGui and ScreenGui:IsA("ScreenGui")) then
        ScreenGui = v27:FindFirstChild("ScreenGui_Full");
    end;

    if not (ScreenGui and ScreenGui:IsA("ScreenGui")) then
        Log.warn("[PotionBrewingGame] 缺少 ScreenGui / ScreenGui_Full");

        return nil;
    end;

    local PotionBrewingGame = ScreenGui:FindFirstChild("PotionBrewingGame");

    if PotionBrewingGame and PotionBrewingGame:IsA("Frame") then
        return PotionBrewingGame;
    end;

    local Frame = Instance.new("Frame");
    Frame.Name = "PotionBrewingGame";
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Position = UDim2.fromScale(0, 0);
    Frame.Visible = false;
    Frame.ZIndex = 10;
    local BoolValue = Instance.new("BoolValue");
    BoolValue.Name = "是否是弹窗";
    BoolValue.Value = true;
    BoolValue.Parent = Frame;
    Frame.Parent = ScreenGui;

    return Frame;
end;

local function _requestClosePopUi() -- Line: 250
    -- upvalues: u6 (ref), NetWork (copy), NetMsg (copy), u4 (ref), u1 (copy)
    if u6 then
        return nil;
    end;

    u6 = true;
    NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "PotionBrewingGame", nil, false, false);

    if u4 then
        u1:closeUi();
    end;

    u6 = false;

    return nil;
end;

local function _bindSkipButton(p28) -- Line: 271
    -- upvalues: u20 (ref), UIMgr (copy), Log (copy), AddListen (copy), u4 (ref), u6 (ref), NetWork (copy), NetMsg (copy), u1 (copy)
    if u20 then
        return nil;
    end;

    local Frame = p28:FindFirstChild("Frame");
    local v29;

    if Frame then
        v29 = Frame:FindFirstChild("跳过按钮");
    else
        v29 = nil;
    end;

    local v30 = v29 or p28:FindFirstChild("跳过按钮", true);
    local v31 = UIMgr.FindButtonInFrame(v30);

    if v31 and v31:IsA("GuiButton") then
        u20 = AddListen.AddMouseCLick(v31, function() -- Line: 287
            -- upvalues: u4 (ref), u6 (ref), NetWork (ref), NetMsg (ref), u1 (ref)
            if not u4 then
                return;
            end;

            if u6 then
                return;
            end;

            u6 = true;
            NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "PotionBrewingGame", nil, false, false);

            if u4 then
                u1:closeUi();
            end;

            u6 = false;
        end, v30);

        return nil;
    end;

    Log.warn("[PotionBrewingGame] 缺少跳过按钮 Frame/跳过按钮/Button");

    return nil;
end;

local function _setClientBrewGameState(p32) -- Line: 302
    -- upvalues: InsMgr (copy), LocalPlayer (copy)
    InsMgr.GetIns("进入炼药游戏", "NumberValue", LocalPlayer).Value = p32 and 1 or 0;

    return nil;
end;

local function _setDepthOfFieldEnabled(p33) -- Line: 314
    -- upvalues: InsMgr (copy), Lighting (copy), u10 (ref)
    local v34 = InsMgr.GetIns("DepthOfField", "DepthOfFieldEffect", Lighting);

    if u10 == nil then
        u10 = v34.Enabled;
    end;

    v34.Enabled = p33;

    return nil;
end;

local function _restoreDepthOfField() -- Line: 328
    -- upvalues: Lighting (copy), u10 (ref)
    local DepthOfField = Lighting:FindFirstChild("DepthOfField");

    if DepthOfField and DepthOfField:IsA("DepthOfFieldEffect") then
        if u10 == nil then
            DepthOfField.Enabled = false;
        else
            DepthOfField.Enabled = u10;
        end;
    end;

    u10 = nil;

    return nil;
end;

local function _setCameraScriptable(p35, p36) -- Line: 348
    -- upvalues: Workspace (copy), u7 (ref), u8 (ref), u9 (ref), GameCfg (copy), GameUtil (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return nil;
    end;

    if u7 == nil then
        u7 = CurrentCamera.CameraType;
        u8 = CurrentCamera.CFrame;
        u9 = CurrentCamera.FieldOfView;
    end;

    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    local v37 = GameCfg.CAMERA_CONFIG and tonumber(GameCfg.CAMERA_CONFIG.FieldOfViewUI);

    if v37 then
        CurrentCamera.FieldOfView = v37;
    end;

    if p35 then
        local v38 = tonumber(p36);

        if v38 and v38 > 0.02 then
            GameUtil.TweenCameraTo(p35, v38);
        else
            GameUtil.StartCameraDrive(p35);
        end;
    else
        GameUtil.StartCameraDrive(CurrentCamera.CFrame);
    end;

    return nil;
end;

local function _restoreCamera(p39) -- Line: 382
    -- upvalues: Workspace (copy), GameUtil (copy), u7 (ref), u8 (ref), u9 (ref), GameCfg (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        GameUtil.StopCameraDrive();
        u7 = nil;
        u8 = nil;
        u9 = nil;

        return nil;
    end;

    local v40 = GameCfg.CAMERA_CONFIG or {};
    local v41 = tonumber(p39);
    local v42 = v41 == nil and (tonumber(v40.RestoreMoveSec) or 0.7) or v41;

    if u8 and v42 > 0.02 then
        GameUtil.TweenCameraTo(u8, v42);
    end;

    GameUtil.StopCameraDrive();

    if u7 == nil then
        CurrentCamera.CameraType = Enum.CameraType.Custom;
    else
        CurrentCamera.CameraType = u7;
    end;

    if u8 then
        CurrentCamera.CFrame = u8;
    end;

    if u9 ~= nil then
        CurrentCamera.FieldOfView = u9;
    end;

    u7 = nil;
    u8 = nil;
    u9 = nil;

    return nil;
end;

local function _placeLocalCharacterAtBrewActor(p43) -- Line: 425
    -- upvalues: u5 (ref), u4 (ref), HumanModule (copy), LocalPlayer (copy), Alchemy (copy), u2 (copy), Log (copy), u11 (ref), u12 (ref), AnimationModule (copy)
    if p43 ~= u5 or not u4 then
        return nil;
    end;

    local v44 = HumanModule.GetCharacter(LocalPlayer);

    if not v44 then
        return nil;
    end;

    local v45 = Alchemy.ResolveBrewActorCFrame and Alchemy.ResolveBrewActorCFrame();

    if not v45 and u2.folder then
        local v46 = u2.folder:FindFirstChild("镜头动画");

        if v46 then
            v46 = v46:FindFirstChild("炼金人");
        end;

        if v46 and v46:IsA("Model") then
            v45 = v46:GetPivot();
        elseif v46 and v46:IsA("BasePart") then
            v45 = v46.CFrame;
        end;
    end;

    local v47 = v44.PrimaryPart or HumanModule.GetHumanoidRootPart(v44);

    if not v47 then
        Log.warn("[PotionBrewingGame] 缺少 HumanoidRootPart");

        return v44;
    end;

    if p43 ~= u5 or not u4 then
        return nil;
    end;

    v44.PrimaryPart = v47;

    if u11 == nil then
        u11 = v44:GetPivot();
        u12 = v47.Anchored;
    end;

    if v45 then
        v44:PivotTo(v45);
    end;

    v47.Anchored = true;
    AnimationModule.PlayAnimByModel(v44, "Idle");
    HumanModule.SnapshotCharacterMotor6DC0C1(v44);

    return v44;
end;

local function _getDrawWandDelaySec() -- Line: 473
    -- upvalues: SystemGameConfig (copy)
    local v48 = tonumber(SystemGameConfig.GetValue({ "装备", "拿出武器到手部延迟秒" }));

    return (not v48 or v48 < 0) and 0.35 or v48;
end;

local function _isHoldingEquippedWand() -- Line: 485
    -- upvalues: HumanModule (copy), LocalPlayer (copy), Backpack (copy)
    return HumanModule.GetHeldToolbarOnlyId(LocalPlayer) == Backpack.HELD_TOOLBAR_ONLY_ID_WEAPON;
end;

local function _ensureEquippedWandInHand(p49) -- Line: 494
    -- upvalues: u5 (ref), u4 (ref), HumanModule (copy), LocalPlayer (copy), Backpack (copy), SystemGameConfig (copy), NetWork (copy), NetMsg (copy), Log (copy)
    if p49 ~= u5 or not u4 then
        return nil;
    end;

    if HumanModule.GetHeldToolbarOnlyId(LocalPlayer) == Backpack.HELD_TOOLBAR_ONLY_ID_WEAPON then
        return nil;
    end;

    local v50 = tonumber(SystemGameConfig.GetValue({ "装备", "拿出武器到手部延迟秒" }));
    local v51 = (not v50 or v50 < 0) and 0.35 or v50;
    local v52 = os.clock() + v51 + 0.15;

    while os.clock() < v52 do
        if p49 ~= u5 or not u4 then
            return nil;
        end;

        if HumanModule.GetHeldToolbarOnlyId(LocalPlayer) == Backpack.HELD_TOOLBAR_ONLY_ID_WEAPON then
            task.wait();

            return nil;
        end;

        task.wait();
    end;

    if p49 ~= u5 or not u4 then
        return nil;
    end;

    if HumanModule.GetHeldToolbarOnlyId(LocalPlayer) == Backpack.HELD_TOOLBAR_ONLY_ID_WEAPON then
        return nil;
    end;

    NetWork.FireServer(NetMsg.BACKPACK_TOGGLE_HELD, {
        uiSlotIndex = 1
    });
    local v53 = os.clock() + math.max(2, v51 + 0.75);

    while os.clock() < v53 do
        if p49 ~= u5 or not u4 then
            return nil;
        end;

        if HumanModule.GetHeldToolbarOnlyId(LocalPlayer) == Backpack.HELD_TOOLBAR_ONLY_ID_WEAPON then
            task.wait();

            return nil;
        end;

        task.wait();
    end;

    Log.warn("[PotionBrewingGame] 等待取出魔杖超时");

    return nil;
end;

local function _scaleHeldWandForBrew() -- Line: 548
    -- upvalues: u21 (ref), HumanModule (copy), LocalPlayer (copy), Log (copy), GameCfg (copy), u22 (ref)
    if u21 then
        return nil;
    end;

    local v54, v55 = HumanModule.GetHeldItem(LocalPlayer);

    if not v54 or v55 ~= "Weapon" then
        Log.warn("[PotionBrewingGame] 未找到右手魔杖，无法缩放");

        return nil;
    end;

    local PrimaryPart = v54.PrimaryPart;
    local v56 = v54:FindFirstChild("魔杖尖端");

    if not (PrimaryPart and v56) then
        Log.warn("[PotionBrewingGame] 魔杖缺少主节点或魔杖尖端，无法缩放");

        return nil;
    end;

    local v57 = nil;

    if v56:IsA("BasePart") then
        v57 = v56.Position;
    elseif v56:IsA("Attachment") then
        v57 = v56.WorldPosition;
    elseif v56:IsA("Model") then
        v57 = v56:GetPivot().Position;
    end;

    if not v57 then
        Log.warn("[PotionBrewingGame] 魔杖尖端类型不支持:", v56.ClassName);

        return nil;
    end;

    local Magnitude = (PrimaryPart.Position - v57).Magnitude;
    local v58 = tonumber(GameCfg.BREW_WAND_TIP_DISTANCE) or 0;

    if Magnitude <= 0 or v58 <= 0 then
        Log.warn("[PotionBrewingGame] 无效的魔杖尖端距离:", Magnitude, v58);

        return nil;
    end;

    u21 = v54;
    u22 = v54:GetScale();
    v54:ScaleTo(u22 * v58 / Magnitude);

    return nil;
end;

local function _restoreBrewWandScale() -- Line: 597
    -- upvalues: u21 (ref), u22 (ref)
    if u21 and (u21.Parent and u22) then
        u21:ScaleTo(u22);
    end;

    u21 = nil;
    u22 = nil;

    return nil;
end;

local function _restoreLocalCharacter() -- Line: 611
    -- upvalues: HumanModule (copy), LocalPlayer (copy), AnimationModule (copy), u11 (ref), u12 (ref)
    local u59 = HumanModule.GetCharacter(LocalPlayer);

    if u59 then
        pcall(function() -- Line: 614
            -- upvalues: AnimationModule (ref), u59 (copy)
            AnimationModule.StopAnimByModel(u59, "Idle");
        end);
        HumanModule.RestoreCharacterMotor6DC0C1(u59);

        if u11 then
            pcall(function() -- Line: 619
                -- upvalues: u59 (copy), u11 (ref)
                u59:PivotTo(u11);
            end);
        end;

        local v60 = HumanModule.GetHumanoidRootPart(u59);

        if v60 then
            local v61;

            if u12 == nil then
                v61 = false;
            else
                v61 = u12;
            end;

            v60.Anchored = v61;
        end;
    end;

    u11 = nil;
    u12 = nil;

    return nil;
end;

local function _awaitCallbackPlay(u62) -- Line: 639
    -- upvalues: Log (copy), u4 (ref)
    if type(u62) ~= "function" then
        return nil;
    end;

    local u63 = false;
    local success, result = pcall(function() -- Line: 644
        -- upvalues: u62 (copy), u63 (ref)
        u62(function() -- Line: 645
            -- upvalues: u63 (ref)
            u63 = true;
        end);
    end);

    if not success then
        Log.warn("[PotionBrewingGame] 过场播放失败:", result);

        return nil;
    end;

    local v64 = os.clock() + 60;

    while not u63 and os.clock() < v64 do
        if not u4 then
            return nil;
        end;

        task.wait();
    end;

    return nil;
end;

local function _playMortarCrushFull() -- Line: 668
    -- upvalues: u2 (copy), EnumMgr (copy), Log (copy), GameCfg (copy), GameUtil (copy)
    if not u2.folder then
        return nil;
    end;

    local u65 = u2:CreateModel("石臼", EnumMgr.ItemType.Cauldron);

    if not u65 then
        Log.warn("[PotionBrewingGame] 缺少石臼模型");

        return nil;
    end;

    local GAME1_ANIM_ANCHOR_TIMES = GameCfg.GAME1_ANIM_ANCHOR_TIMES;
    local u66 = type(GAME1_ANIM_ANCHOR_TIMES) == "table" and #GAME1_ANIM_ANCHOR_TIMES > 0 and (tonumber(GAME1_ANIM_ANCHOR_TIMES[#GAME1_ANIM_ANCHOR_TIMES]) or 13) or 13;
    local success, result = pcall(function() -- Line: 681
        -- upvalues: GameUtil (ref), u2 (ref), u65 (copy), u66 (copy)
        GameUtil.PlayMortarCrushWithKeyframes(u2.folder, u65, "捣材料动画", u66);
    end);

    if not success then
        Log.warn("[PotionBrewingGame] 捣材料关键帧流程异常:", result);
        task.wait(u66);
    end;

    return nil;
end;

local function _playStirBeat() -- Line: 696
    -- upvalues: GameUtil (copy), u2 (copy), Log (copy), u4 (ref)
    local u67 = false;
    local success, result = pcall(function() -- Line: 698
        -- upvalues: GameUtil (ref), u2 (ref), u67 (ref)
        GameUtil.PlayStirPresentation(u2.folder, function() -- Line: 699
            -- upvalues: u67 (ref)
            u67 = true;
        end);
    end);

    if success then
        local v68 = os.clock() + 30;

        while not u67 and os.clock() < v68 do
            if not u4 then
                return nil;
            end;

            task.wait();
        end;

        return nil;
    end;

    Log.warn("[PotionBrewingGame] 搅拌表现异常:", result);
    task.wait(2.5);

    return nil;
end;

local function _buildBowlMaterialEntries() -- Line: 723
    -- upvalues: u17 (copy), u18 (copy), CfgFind (copy), ItemType (copy), Log (copy)
    local v69 = {};

    for _, v in ipairs(u17) do
        local v70 = tonumber(u18[v]) or 1;
        local v71 = math.floor(v70);
        local v72 = v71 < 1 and 1 or v71;
        local v73 = CfgFind.FindCfgByID(v, ItemType.Material);
        local v74 = nil;
        local v75 = nil;

        if type(v73) == "table" then
            if type(v73.ZhName) == "string" and v73.ZhName ~= "" then
                v74 = v73.ZhName;
            elseif type(v73.Name) == "string" and v73.Name ~= "" then
                v74 = v73.Name;
            end;

            if type(v73.Model) == "string" and v73.Model ~= "" then
                v75 = v73.Model;

                if not v74 then
                    v74 = v73.Model;
                end;
            end;
        end;

        if type(v74) == "string" and v74 ~= "" then
            table.insert(v69, {
                name = v74,
                count = v72,
                model = v75
            });
        else
            Log.warn("[PotionBrewingGame] 材料缺少名称配置:", v);
        end;
    end;

    return v69;
end;

local function _spawnMaterialsInBowl() -- Line: 764
    -- upvalues: u2 (copy), _buildBowlMaterialEntries (copy), Log (copy), GameUtil (copy)
    if not u2.folder then
        return nil;
    end;

    local v76 = _buildBowlMaterialEntries();

    if #v76 == 0 then
        Log.warn("[PotionBrewingGame] 无材料可摆入碗内");

        return nil;
    end;

    if GameUtil.SpawnMaterialsAtBowlSlots(u2.folder, v76) <= 0 then
        Log.warn("[PotionBrewingGame] 碗内材料生成失败");
    end;

    return nil;
end;

local function _runAutoPresentation(u77) -- Line: 786
    -- upvalues: u5 (ref), u6 (ref), NetWork (copy), NetMsg (copy), u4 (ref), u1 (copy), GameCfg (copy), Alchemy (copy), _setCameraScriptable (copy), _placeLocalCharacterAtBrewActor (copy), _ensureEquippedWandInHand (copy), _scaleHeldWandForBrew (copy), u2 (copy), _buildBowlMaterialEntries (copy), Log (copy), GameUtil (copy), _playMortarCrushFull (copy), u3 (copy), _awaitCallbackPlay (copy), _playStirBeat (copy)
    local function finishAndClose() -- Line: 787
        -- upvalues: u77 (copy), u5 (ref), u6 (ref), NetWork (ref), NetMsg (ref), u4 (ref), u1 (ref)
        if u77 ~= u5 then
            return nil;
        end;

        if not u6 then
            u6 = true;
            NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "PotionBrewingGame", nil, false, false);

            if u4 then
                u1:closeUi();
            end;

            u6 = false;
        end;

        return nil;
    end;

    local v78 = tonumber((GameCfg.CAMERA_CONFIG or {}).Stage1MoveSec) or 0.85;
    local v79 = Alchemy.ResolveStage1CameraCFrame and Alchemy.ResolveStage1CameraCFrame();
    _setCameraScriptable(v79, v78);

    if u77 ~= u5 or not u4 then
        return nil;
    end;

    _placeLocalCharacterAtBrewActor(u77);

    if u77 ~= u5 or not u4 then
        return nil;
    end;

    _ensureEquippedWandInHand(u77);

    if u77 ~= u5 or not u4 then
        return nil;
    end;

    _scaleHeldWandForBrew();

    if u2.folder then
        local v80 = _buildBowlMaterialEntries();

        if #v80 == 0 then
            Log.warn("[PotionBrewingGame] 无材料可摆入碗内");
        elseif GameUtil.SpawnMaterialsAtBowlSlots(u2.folder, v80) <= 0 then
            Log.warn("[PotionBrewingGame] 碗内材料生成失败");
        end;
    end;

    if u77 ~= u5 or not u4 then
        return nil;
    end;

    _playMortarCrushFull();

    if u77 ~= u5 or not u4 then
        return nil;
    end;

    if u3 and type(u3.PlayTransitionToGame2) == "function" then
        _awaitCallbackPlay(u3.PlayTransitionToGame2);
    end;

    if u77 ~= u5 or not u4 then
        return nil;
    end;

    _playStirBeat();

    if u77 ~= u5 or not u4 then
        return nil;
    end;

    if u77 == u5 and not u6 then
        u6 = true;
        NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "PotionBrewingGame", nil, false, false);

        if u4 then
            u1:closeUi();
        end;

        u6 = false;
    end;

    return nil;
end;

local function _notifyBrewWaitAfterPresentation() -- Line: 845
    -- upvalues: Alchemy (copy), LocalPlayer (copy), Workspace (copy), u19 (ref), CfgFind (copy), TipsModule (copy), TimeTransfer (copy)
    if not Alchemy.IsPlayerMaterialBrewing(LocalPlayer) then
        return nil;
    end;

    local v81 = Workspace:GetServerTimeNow();
    local v82 = math.floor(v81);
    local v83 = Alchemy.GetBrewRemainingSeconds(LocalPlayer, v82);

    if v83 <= 0 and u19 > 0 then
        local v84 = CfgFind.FindAlchemyRecipeById(u19);

        if v84 then
            v83 = Alchemy.GetRecipeCraftTimeSeconds(v84);
        end;
    end;

    if v83 <= 0 then
        return nil;
    end;

    TipsModule.NormalTips(LocalPlayer, "炼制药水完成需等待", { TimeTransfer.FormatTimeMMSS(v83) });

    return nil;
end;

function u1.updateUi(p85, p86) -- Line: 870
    -- upvalues: u19 (ref), u2 (copy), u17 (copy), u18 (copy)
    if type(p86) ~= "table" then
        return nil;
    end;

    u19 = tonumber(p86.recipeId) or 0;

    if p86.cauldronModel then
        u2.folder = p86.cauldronModel;

        if type(u2.ResetTempFolder) == "function" then
            u2:ResetTempFolder();
        end;
    end;

    table.clear(u17);
    table.clear(u18);

    if type(p86.materials) == "table" then
        if p86.materials[1] == nil then
            for i, v in pairs(p86.materials) do
                local v87 = tonumber(i);
                local v88 = tonumber(v) or 0;
                local v89 = math.floor(v88);

                if v87 and (v87 > 0 and v89 > 0) then
                    u18[v87] = v89;
                    table.insert(u17, v87);
                end;
            end;
        else
            for _, v in ipairs(p86.materials) do
                if type(v) == "table" then
                    local v90 = tonumber(v.id);
                    local v91 = tonumber(v.count) or 0;
                    local v92 = math.floor(v91);

                    if v90 and (v90 > 0 and v92 > 0) then
                        u18[v90] = (u18[v90] or 0) + v92;
                        table.insert(u17, v90);
                    end;
                end;
            end;
        end;
    elseif type(p86.materialList) == "table" then
        for _, v in ipairs(p86.materialList) do
            local v93 = tonumber(v);

            if v93 and v93 > 0 then
                u18[v93] = 1;
                table.insert(u17, v93);
            end;
        end;
    end;

    return nil;
end;

function u1.openUi(p94) -- Line: 926
    -- upvalues: u4 (ref), u5 (ref), _ensurePopUiFrame (copy), _bindSkipButton (copy), InsMgr (copy), LocalPlayer (copy), UIMgr (copy), _setBlackGuiEnabled (copy), _setScreenGuiFullHidden (copy), Lighting (copy), u10 (ref), u2 (copy), Alchemy (copy), Log (copy), GameUtil (copy), EnumMgr (copy), _runAutoPresentation (copy), u6 (ref), NetWork (copy), NetMsg (copy), u1 (copy)
    if u4 then
        return nil;
    end;

    u4 = true;
    u5 = u5 + 1;
    local u95 = u5;
    local v96 = _ensurePopUiFrame();

    if v96 then
        _bindSkipButton(v96);
    end;

    InsMgr.GetIns("进入炼药游戏", "NumberValue", LocalPlayer).Value = 1;
    local v97 = _ensurePopUiFrame();

    if v97 then
        v97:SetAttribute("HideButtomLeft", true);
    end;

    UIMgr.SetMainUIVisible(false, true);
    _setBlackGuiEnabled(true);
    _setScreenGuiFullHidden(true);
    local v98 = InsMgr.GetIns("DepthOfField", "DepthOfFieldEffect", Lighting);

    if u10 == nil then
        u10 = v98.Enabled;
    end;

    v98.Enabled = true;

    if not u2.folder then
        local v99 = Alchemy.FindAlchemyScene and Alchemy.FindAlchemyScene();

        if v99 then
            u2.folder = v99;

            if type(u2.ResetTempFolder) == "function" then
                u2:ResetTempFolder();
            end;
        else
            Log.warn("[PotionBrewingGame] 未找到炼药场景，仍尝试就位播放");
        end;
    end;

    pcall(function() -- Line: 962
        -- upvalues: GameUtil (ref), u2 (ref)
        GameUtil.CaptureSceneOriginalState(u2.folder);
    end);
    pcall(function() -- Line: 966
        -- upvalues: GameUtil (ref), u2 (ref)
        GameUtil.SetMortarCollisionEnabled(u2.folder, true);
    end);
    pcall(function() -- Line: 970
        -- upvalues: u2 (ref), EnumMgr (ref), GameUtil (ref)
        local v100 = u2:CreateModel("石臼", EnumMgr.ItemType.Cauldron);
        GameUtil.SetMortarMeshes1Visible(v100, true);
    end);
    task.spawn(function() -- Line: 975
        -- upvalues: _runAutoPresentation (ref), u95 (copy), Log (ref), u5 (ref), u6 (ref), NetWork (ref), NetMsg (ref), u4 (ref), u1 (ref)
        local success, result = pcall(function() -- Line: 976
            -- upvalues: _runAutoPresentation (ref), u95 (ref)
            _runAutoPresentation(u95);
        end);

        if not success then
            Log.warn("[PotionBrewingGame] 自动演出异常:", result);

            if u95 == u5 then
                if u6 then
                    return;
                end;

                u6 = true;
                NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "PotionBrewingGame", nil, false, false);

                if u4 then
                    u1:closeUi();
                end;

                u6 = false;
            end;
        end;
    end);

    return nil;
end;

function u1.closeUi(p101, p102) -- Line: 995
    -- upvalues: u4 (ref), InsMgr (copy), LocalPlayer (copy), u21 (ref), u22 (ref), u11 (ref), u12 (ref), _restoreLocalCharacter (copy), u14 (ref), u15 (ref), u13 (ref), u16 (ref), _ensurePopUiFrame (copy), UIMgr (copy), u5 (ref), _notifyBrewWaitAfterPresentation (copy), GameUtil (copy), u2 (copy), Lighting (copy), u10 (ref), _restoreCamera (copy), u17 (copy), u18 (copy), u19 (ref)
    local v103 = u4;

    if not u4 and p102 ~= true then
        InsMgr.GetIns("进入炼药游戏", "NumberValue", LocalPlayer).Value = 0;

        if u21 and (u21.Parent and u22) then
            u21:ScaleTo(u22);
        end;

        u21 = nil;
        u22 = nil;

        if u11 ~= nil or u12 ~= nil then
            _restoreLocalCharacter();
        end;

        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");
        local v104;

        if PlayerGui and PlayerGui:IsA("PlayerGui") then
            v104 = PlayerGui:FindFirstChild("BlackGui");

            if not (v104 and v104:IsA("ScreenGui")) then
                v104 = nil;
            end;
        else
            v104 = nil;
        end;

        if v104 then
            local BG = v104:FindFirstChild("BG");
            local v105 = v104:FindFirstChild("黑屏");

            if BG and (BG:IsA("GuiObject") and u14 ~= nil) then
                BG.Visible = u14;
            end;

            if v105 and (v105:IsA("GuiObject") and u15 ~= nil) then
                v105.Visible = u15;
            end;

            if u13 == nil then
                v104.Enabled = false;
            else
                v104.Enabled = u13;
            end;

            u13 = nil;
            u14 = nil;
            u15 = nil;
        end;

        local PlayerGui2 = LocalPlayer:FindFirstChild("PlayerGui");

        if PlayerGui2 and PlayerGui2:IsA("PlayerGui") then
            local ScreenGui_Full = PlayerGui2:FindFirstChild("ScreenGui_Full");

            if ScreenGui_Full and ScreenGui_Full:IsA("ScreenGui") then
                if u16 ~= nil then
                    ScreenGui_Full.Enabled = u16;
                end;

                u16 = nil;
            end;
        end;

        local v106 = _ensurePopUiFrame();

        if v106 and v106.Visible then
            v106.Visible = false;
            UIMgr.RefreshPopShowState();
        end;

        return nil;
    end;

    u4 = false;
    u5 = u5 + 1;

    if v103 and p102 ~= true then
        _notifyBrewWaitAfterPresentation();
    end;

    if p102 ~= true then
        InsMgr.GetIns("进入炼药游戏", "NumberValue", LocalPlayer).Value = 0;
    end;

    pcall(function() -- Line: 1025
        -- upvalues: GameUtil (ref), u2 (ref)
        GameUtil.RestoreSceneOriginalState(u2.folder);
    end);

    if u21 and (u21.Parent and u22) then
        u21:ScaleTo(u22);
    end;

    u21 = nil;
    u22 = nil;
    _restoreLocalCharacter();
    local DepthOfField = Lighting:FindFirstChild("DepthOfField");

    if DepthOfField and DepthOfField:IsA("DepthOfFieldEffect") then
        if u10 == nil then
            DepthOfField.Enabled = false;
        else
            DepthOfField.Enabled = u10;
        end;
    end;

    u10 = nil;
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");
    local v107;

    if PlayerGui and PlayerGui:IsA("PlayerGui") then
        v107 = PlayerGui:FindFirstChild("BlackGui");

        if not (v107 and v107:IsA("ScreenGui")) then
            v107 = nil;
        end;
    else
        v107 = nil;
    end;

    if v107 then
        local BG = v107:FindFirstChild("BG");
        local v108 = v107:FindFirstChild("黑屏");

        if BG and (BG:IsA("GuiObject") and u14 ~= nil) then
            BG.Visible = u14;
        end;

        if v108 and (v108:IsA("GuiObject") and u15 ~= nil) then
            v108.Visible = u15;
        end;

        if u13 == nil then
            v107.Enabled = false;
        else
            v107.Enabled = u13;
        end;

        u13 = nil;
        u14 = nil;
        u15 = nil;
    end;

    local PlayerGui2 = LocalPlayer:FindFirstChild("PlayerGui");

    if PlayerGui2 and PlayerGui2:IsA("PlayerGui") then
        local ScreenGui_Full = PlayerGui2:FindFirstChild("ScreenGui_Full");

        if ScreenGui_Full and ScreenGui_Full:IsA("ScreenGui") then
            if u16 ~= nil then
                ScreenGui_Full.Enabled = u16;
            end;

            u16 = nil;
        end;
    end;

    if p102 ~= true then
        _restoreCamera();
        UIMgr.SetMainUIVisible(true);
    end;

    local v109 = _ensurePopUiFrame();

    if v109 then
        v109.Visible = false;
        v109:SetAttribute("HideButtomLeft", nil);
    end;

    UIMgr.RefreshPopShowState();
    table.clear(u17);
    table.clear(u18);
    u19 = 0;

    return nil;
end;

function u1.StartFromCraftPresent(p110) -- Line: 1059
    -- upvalues: _ensurePopUiFrame (copy), _bindSkipButton (copy), Alchemy (copy), NetWork (copy), NetMsg (copy)
    local v111 = type(p110) ~= "table" and {} or p110;
    local v112 = _ensurePopUiFrame();

    if not v112 then
        return nil;
    end;

    _bindSkipButton(v112);
    local cauldronModel = v111.cauldronModel;

    if not cauldronModel and Alchemy.FindAlchemyScene then
        cauldronModel = Alchemy.FindAlchemyScene();
    end;

    NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "PotionBrewingGame", {
        materials = v111.materials,
        materialList = v111.materialList,
        cauldronModel = cauldronModel,
        cauldronID = v111.cauldronID,
        recipeId = v111.recipeId,
        potionId = v111.potionId
    }, true, false);

    return nil;
end;

return u1;