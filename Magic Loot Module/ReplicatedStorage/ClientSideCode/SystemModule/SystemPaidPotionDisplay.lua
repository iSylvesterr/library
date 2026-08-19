-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local AnimationModule = UtilsSystem.AnimationModule;
local AssetPaths = UtilsSystem.AssetPaths;
local AssetRegistry = UtilsSystem.AssetRegistry;
local CfgFind = UtilsSystem.CfgFind;
local CollectionService = UtilsSystem.CollectionService;
local HeldItemVisualUtil = UtilsSystem.HeldItemVisualUtil;
local InsMgr = UtilsSystem.InsMgr;
local LocalDrinkPotionPresentation = UtilsSystem.LocalDrinkPotionPresentation;
local LocalPlayer = UtilsSystem.LocalPlayer;
local LocalSkillPresentation = UtilsSystem.LocalSkillPresentation;
local Log = UtilsSystem.Log;
local RayCast = UtilsSystem.RayCast;
local ResourceUtil = UtilsSystem.ResourceUtil;
local SystemBuyRoblox = UtilsSystem.SystemBuyRoblox;
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIMgr = UtilsSystem.UIMgr;
local ItemType = UtilsSystem.EnumMgr.ItemType;
local ModelCategory = ResourceUtil.ModelCategory;
local v1 = {};
local v2 = AssetRegistry.BuildCatalogPath("BillBoard", "Sell");
local RigFolder = ModelCategory.RigFolder;
local u3 = ResourceUtil.GetTemplate(v2);

if not u3 then
    Log.warn("[SystemPaidPotionDisplay] 缺少 Assets.BillBoard.Sell，路径:", v2);
end;

local u4 = false;
local u5 = nil;
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = {};

local function _cfgNumber(p10, p11) -- Line: 132
    -- upvalues: SystemGameConfig (copy)
    local v12 = tonumber(SystemGameConfig.GetValue({ "付费药水展示", p10 }));

    if v12 == nil then
        return p11;
    end;

    return v12;
end;

local function _getDisplayWandId() -- Line: 145
    -- upvalues: SystemGameConfig (copy)
    local v13 = tonumber(SystemGameConfig.GetValue({ "付费药水展示", "展示魔杖ID" }));

    return (not v13 or v13 <= 0) and (tonumber(SystemGameConfig.GetValue({ "装备", "初始魔杖ID" })) or 6000001) or v13;
end;

local function _getDrawDelaySec() -- Line: 159
    -- upvalues: SystemGameConfig (copy)
    local v14 = tonumber(SystemGameConfig.GetValue({ "装备", "拿出武器到手部延迟秒" }));

    return v14 == nil and 0.35 or math.clamp(v14, 0, 10);
end;

local function _resolvePotionSkill(p15) -- Line: 173
    -- upvalues: CfgFind (copy), ItemType (copy)
    local v16 = CfgFind.FindCfgByID(p15, ItemType.Potion);

    if not v16 then
        return nil, nil;
    end;

    local v17 = tonumber(v16.SkillID) or 0;
    local Model = v16.Model;

    if v17 <= 0 then
        local v18 = nil;

        if type(Model) == "string" then
            return v18, Model;
        end;

        return v18, nil;
    end;

    local v19 = CfgFind.FindCfgByID(v17, ItemType.Skill);

    if not v19 then
        local v20 = nil;

        if type(Model) == "string" then
            return v20, Model;
        end;

        return v20, nil;
    end;

    local ScriptName = v19.ScriptName;

    if type(ScriptName) == "string" and ScriptName ~= "" then
        if type(Model) == "string" then
            return ScriptName, Model;
        end;

        return ScriptName, nil;
    end;

    local v21 = nil;

    if type(Model) == "string" then
        return v21, Model;
    end;

    return v21, nil;
end;

local function _prepareDisplayRig(p22) -- Line: 200
    -- upvalues: HeldItemVisualUtil (copy)
    local HumanoidRootPart = p22:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        p22.PrimaryPart = HumanoidRootPart;
    end;

    HeldItemVisualUtil.SetupWeaponMountParts(p22);
    local Torso = p22:FindFirstChild("Torso");

    if Torso and Torso:IsA("BasePart") then
        HeldItemVisualUtil.EnsureHolsterMount(Torso);
    end;

    HeldItemVisualUtil.EnsureHeldFolder(p22);
    HeldItemVisualUtil.EnsureHolsterFolder(p22);
    HeldItemVisualUtil.SetCharacterAnchored(p22, true);
    local v23 = p22:FindFirstChildOfClass("Humanoid");

    if v23 then
        v23.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None;
        v23.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff;
        v23.WalkSpeed = 0;
        v23.JumpPower = 0;
        v23.AutoRotate = false;

        if not v23:FindFirstChildOfClass("Animator") then
            Instance.new("Animator").Parent = v23;
        end;
    end;

    return p22;
end;

local function _waitFallbackR6RigSource() -- Line: 235
    -- upvalues: ReplicatedStorage (copy), Log (copy), RigFolder (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");
    local v24;

    if Assets then
        v24 = Assets:FindFirstChild("ModelRes");
    else
        v24 = nil;
    end;

    local v25 = v24 or ReplicatedStorage:FindFirstChild("ModelRes");

    if not v25 then
        local v26 = Assets or ReplicatedStorage:WaitForChild("Assets", 30);

        if v26 then
            v25 = v26:FindFirstChild("ModelRes") or v26:WaitForChild("ModelRes", 30);
        end;

        v25 = v25 or ReplicatedStorage:WaitForChild("ModelRes", 30);
    end;

    if not v25 then
        Log.warn("[SystemPaidPotionDisplay] 未找到 ModelRes（Assets.ModelRes / RS.ModelRes）");

        return nil;
    end;

    local v27 = v25:FindFirstChild(RigFolder) or v25:WaitForChild(RigFolder, 30);

    if not v27 then
        Log.warn("[SystemPaidPotionDisplay] 未找到 RigFolder，期望路径: ModelRes/RigFolder 当前 ModelRes=", v25:GetFullName());

        return nil;
    end;

    local v28 = v27:FindFirstChild("R6Rig") or v27:WaitForChild("R6Rig", 30);

    if not v28 then
        Log.warn("[SystemPaidPotionDisplay] 未找到 R6Rig，期望: ModelRes/RigFolder/R6Rig 当前 RigFolder=", v27:GetFullName());

        return nil;
    end;

    if v28:IsA("Model") then
        return v28;
    end;

    local v29 = v28:FindFirstChildWhichIsA("Model", true);

    if v29 then
        Log.warn("[SystemPaidPotionDisplay] R6Rig 节点不是 Model，已取子级 Model:", v29:GetFullName());

        return v29;
    end;

    Log.warn("[SystemPaidPotionDisplay] R6Rig 类型错误，需要 Model，实际:", v28.ClassName, v28:GetFullName());

    return nil;
end;

local function _getFallbackR6RigTemplate() -- Line: 297
    -- upvalues: AssetPaths (copy), _waitFallbackR6RigSource (copy), ResourceUtil (copy), RigFolder (copy), Log (copy), AssetRegistry (copy), _prepareDisplayRig (copy)
    AssetPaths.ClearCache();
    local v30 = _waitFallbackR6RigSource();
    local v31;

    if v30 then
        v31 = v30:Clone();
    else
        v31 = ResourceUtil.GetModel(RigFolder, "R6Rig");
    end;

    if not v31 then
        Log.warn("[SystemPaidPotionDisplay] 缺少兜底 Rig:", AssetRegistry.BuildModelPath(RigFolder, "R6Rig"));

        return nil;
    end;

    v31.Name = "PaidPotionDisplayFallbackRig";
    local v32 = v31:FindFirstChild("HumanoidRootPart") ~= nil;
    local v33 = v31:FindFirstChildOfClass("Humanoid") ~= nil;
    local v34 = v31:FindFirstChild("Left Arm") ~= nil;
    local v35 = v31:FindFirstChild("Right Arm") ~= nil;
    local v36 = v31:FindFirstChild("Torso") ~= nil;

    if not (v32 and (v33 and (v34 and (v35 and v36)))) then
        Log.warn("[SystemPaidPotionDisplay] R6Rig 结构不完整 HRP=", v32, " Humanoid=", v33, " LeftArm=", v34, " RightArm=", v35, " Torso=", v36, " path=", not v30 and "(GetModel)" or v30:GetFullName());
    end;

    local v37 = _prepareDisplayRig(v31);
    Log.print("[SystemPaidPotionDisplay] R6Rig 兜底模板已就绪");

    return v37;
end;

local function _waitPlayerAvatarReadyForever() -- Line: 344
    -- upvalues: ReplicatedStorage (copy), LocalPlayer (copy)
    local PlayerLocalAvatar = ReplicatedStorage:WaitForChild("PlayerLocalAvatar");

    if not PlayerLocalAvatar then
        return nil;
    end;

    local v38 = tostring(LocalPlayer.UserId);
    local v39 = PlayerLocalAvatar:WaitForChild(v38);

    while not (v39 and v39:IsA("Model")) do
        task.wait(0.1);
        v39 = PlayerLocalAvatar:FindFirstChild(v38) or PlayerLocalAvatar:WaitForChild(v38);
    end;

    while v39:GetAttribute("Ready") ~= true do
        task.wait(0.1);
    end;

    return v39;
end;

local function _getOrCreateLocalFolder() -- Line: 366
    -- upvalues: Workspace (copy)
    local PaidPotionDisplayLocal = Workspace:FindFirstChild("PaidPotionDisplayLocal");

    if not PaidPotionDisplayLocal then
        PaidPotionDisplayLocal = Instance.new("Folder");
        PaidPotionDisplayLocal.Name = "PaidPotionDisplayLocal";
        PaidPotionDisplayLocal.Parent = Workspace;
    end;

    return PaidPotionDisplayLocal;
end;

local function _getStationFolder(p40) -- Line: 382
    local Parent = p40.Parent;

    if Parent and Parent:IsA("Folder") then
        return Parent;
    end;

    return nil;
end;

local function _validateFolderAttrs(p41) -- Line: 396
    -- upvalues: Log (copy)
    if p41:GetAttribute("PaidPotionDisplay") == nil then
        Log.warn("[SystemPaidPotionDisplay] Folder 缺少 PaidPotionDisplay", p41:GetFullName());

        return nil, nil, false;
    end;

    local v42 = tonumber(p41:GetAttribute("PotionId"));

    if not v42 or v42 <= 0 then
        Log.warn("[SystemPaidPotionDisplay] Folder 缺少有效 PotionId", p41:GetFullName());

        return nil, nil, false;
    end;

    local v43 = p41:GetAttribute("OnlyTag");

    if type(v43) ~= "string" or v43 == "" then
        v43 = nil;
    end;

    if v43 then
        return v42, v43, true;
    end;

    Log.warn("[SystemPaidPotionDisplay] Folder 缺少 OnlyTag", p41:GetFullName());

    return nil, nil, false;
end;

local function _ensurePending(p44) -- Line: 421
    -- upvalues: u7 (copy)
    if not u7[p44] then
        u7[p44] = {
            touch = nil,
            info = nil,
            anchor = nil
        };
    end;

    return u7[p44];
end;

local function _alignToAnchor(p45, p46) -- Line: 435
    -- upvalues: HeldItemVisualUtil (copy)
    local HumanoidRootPart = p45:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        p45.PrimaryPart = HumanoidRootPart;
    end;

    p45:PivotTo(p46.CFrame);
    HeldItemVisualUtil.SetCharacterAnchored(p45, true);

    return nil;
end;

local function _cloneItemModel(p47, p48, p49) -- Line: 453
    -- upvalues: ResourceUtil (copy)
    local v50 = ResourceUtil.GetModel(p47, p48);

    if not v50 then
        return nil;
    end;

    v50:SetAttribute("ItemID", p49);
    v50:SetAttribute("ModelName", p48);

    return v50;
end;

local function _resetToIdle(p51) -- Line: 469
    -- upvalues: AnimationModule (copy), LocalSkillPresentation (copy), LocalDrinkPotionPresentation (copy), HeldItemVisualUtil (copy), _getDisplayWandId (copy), CfgFind (copy), ItemType (copy), ModelCategory (copy), ResourceUtil (copy)
    local displayModel = p51.displayModel;
    AnimationModule.StopAnimByModel(displayModel, "喝下药水-展示", 0.05);
    AnimationModule.StopAnimByModel(displayModel, "拿出武器", 0.05);
    AnimationModule.StopAnimByModel(displayModel, "Idle", 0.05);

    if p51.scriptName then
        LocalSkillPresentation.Stop(p51.scriptName, p51.token);
    end;

    LocalDrinkPotionPresentation.Stop(p51.token);
    HeldItemVisualUtil.ClearHeldModels(displayModel);

    if not HeldItemVisualUtil.FindHolsteredWeapon(displayModel) then
        local v52 = displayModel:FindFirstChild(HeldItemVisualUtil.HELD_FOLDER_NAME);

        if v52 then
            for _, child in ipairs(v52:GetChildren()) do
                if child:IsA("Model") and child:GetAttribute(HeldItemVisualUtil.ATTR_SLOT_EQUIPPED_WEAPON) == true then
                    HeldItemVisualUtil.AttachModelToHolster(displayModel, child);
                end;
            end;
        end;
    end;

    if not HeldItemVisualUtil.FindHolsteredWeapon(displayModel) then
        local v53 = _getDisplayWandId();
        local v54 = CfgFind.FindCfgByID(v53, ItemType.Weapon);

        if v54 and type(v54.Model) == "string" then
            local Model = v54.Model;
            local v55 = ResourceUtil.GetModel(ModelCategory.Weapon, Model);

            if v55 then
                v55:SetAttribute("ItemID", v53);
                v55:SetAttribute("ModelName", Model);
            else
                v55 = nil;
            end;

            if v55 then
                HeldItemVisualUtil.AttachModelToHolster(displayModel, v55);
            end;
        end;
    end;

    if p51.potionCfgModelName then
        local potionCfgModelName = p51.potionCfgModelName;
        local potionId = p51.potionId;
        local v56 = ResourceUtil.GetModel(ModelCategory.Potion, potionCfgModelName);

        if v56 then
            v56:SetAttribute("ItemID", potionId);
            v56:SetAttribute("ModelName", potionCfgModelName);
        else
            v56 = nil;
        end;

        if v56 then
            HeldItemVisualUtil.AttachModelToRightWeapon(displayModel, v56, "Potion", nil, true);
        end;
    end;

    local anchorPart = p51.anchorPart;
    local HumanoidRootPart = displayModel:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        displayModel.PrimaryPart = HumanoidRootPart;
    end;

    displayModel:PivotTo(anchorPart.CFrame);
    HeldItemVisualUtil.SetCharacterAnchored(displayModel, true);
    AnimationModule.PlayAnimByModel(displayModel, "待机-展示", 1, nil, nil, Enum.AnimationPriority.Idle);

    return nil;
end;

local function _resolveGoalCF(p57) -- Line: 524
    -- upvalues: SystemGameConfig (copy), RayCast (copy)
    local v58 = p57.displayModel:GetPivot();
    local v59 = tonumber(SystemGameConfig.GetValue({ "付费药水展示", "技能目标前方偏移" }));
    local v60 = tonumber(SystemGameConfig.GetValue({ "付费药水展示", "地面未命中下偏" }));
    local v61 = v60 == nil and 2.5 or v60;
    local v62 = v58:ToWorldSpace(CFrame.new(0, 0, -(v59 == nil and 10 or v59)));
    local v63 = RayCast.RayCastDirection(v62.Position + Vector3.new(0, 8, 0), Vector3.new(0, -1, 0), 40, "Ground");
    local v64;

    if v63 and v63.Position then
        v64 = v63.Position + Vector3.new(0, 0.5, 0);
    else
        v64 = v62.Position - Vector3.new(0, v61, 0);
    end;

    local v65 = Vector3.new(v58.LookVector.X, 0, v58.LookVector.Z);

    return CFrame.lookAt(v64, v64 + (v65.Magnitude < 0.05 and Vector3.new(0, 0, -1) or v65.Unit), Vector3.new(0, 1, 0));
end;

local function _bumpToken(p66) -- Line: 553
    -- upvalues: LocalSkillPresentation (copy), LocalDrinkPotionPresentation (copy), AnimationModule (copy)
    local token = p66.token;

    if p66.scriptName then
        LocalSkillPresentation.Stop(p66.scriptName, token);
    end;

    LocalDrinkPotionPresentation.Stop(token);
    AnimationModule.StopAnimByModel(p66.displayModel, "喝下药水-展示", 0.05);
    AnimationModule.StopAnimByModel(p66.displayModel, "拿出武器", 0.05);
    AnimationModule.StopAnimByModel(p66.displayModel, "技能释放动作4", 0.05);
    p66.token = token + 1;

    return p66.token;
end;

local function _playOneCycle(u67) -- Line: 572
    -- upvalues: _bumpToken (copy), _resetToIdle (copy), HeldItemVisualUtil (copy), Log (copy), AnimationModule (copy), LocalDrinkPotionPresentation (copy), SystemGameConfig (copy), LocalSkillPresentation (copy), _resolveGoalCF (copy)
    local u68 = _bumpToken(u67);

    local function isValid() -- Line: 574
        -- upvalues: u67 (copy), u68 (copy)
        return u67.token == u68;
    end;

    _resetToIdle(u67);

    if u67.token ~= u68 then
        return nil;
    end;

    local displayModel = u67.displayModel;
    local v69 = displayModel:FindFirstChild(HeldItemVisualUtil.HELD_FOLDER_NAME);
    local v70 = nil;

    if v69 then
        for _, child in ipairs(v69:GetChildren()) do
            if child:IsA("Model") and child:GetAttribute("ItemType") == "Potion" then
                v70 = child;
                break;
            end;
        end;
    end;

    if not v70 then
        Log.warn("[SystemPaidPotionDisplay] 无手持药水，跳过演出", u67.potionId);

        return nil;
    end;

    AnimationModule.StopAnimByModel(displayModel, "待机-展示", 0.05);
    AnimationModule.StopAnimByModel(displayModel, "Idle", 0.05);
    local u71 = false;
    LocalDrinkPotionPresentation.Play({
        animName = "喝下药水-展示",
        character = displayModel,
        potionModel = v70,
        token = u68,
        isTokenValid = isValid,

        onAnimEnd = function() -- Line: 610, Name: onAnimEnd
            -- upvalues: u71 (ref)
            u71 = true;
        end
    });
    local v72 = os.clock();

    while not u71 and (u67.token == u68 and os.clock() - v72 < 8) do
        task.wait(0.05);
    end;

    if u67.token ~= u68 then
        return nil;
    end;

    HeldItemVisualUtil.ClearHeldModels(displayModel);
    AnimationModule.PlayAnimByModel(displayModel, "拿出武器", 1, nil, nil, Enum.AnimationPriority.Action3);
    local v73 = tonumber(SystemGameConfig.GetValue({ "装备", "拿出武器到手部延迟秒" }));
    local v74 = v73 == nil and 0.35 or math.clamp(v73, 0, 10);

    if v74 > 0 then
        task.wait(v74);
    end;

    if u67.token ~= u68 then
        return nil;
    end;

    HeldItemVisualUtil.MoveModelFromHolsterToHand(displayModel);
    local scriptName = u67.scriptName;

    if not (scriptName and LocalSkillPresentation.Has(scriptName)) then
        Log.warn("[SystemPaidPotionDisplay] 无 LocalPresentation，跳过施法", scriptName or u67.potionId);

        return nil;
    end;

    AnimationModule.StopAnimByModel(displayModel, "待机-展示", 0.05);
    AnimationModule.PlayAnimByModel(displayModel, "Idle", 1, nil, nil, Enum.AnimationPriority.Idle);
    local u75 = false;
    local v76 = _resolveGoalCF(u67);
    LocalSkillPresentation.Play(scriptName, {
        character = displayModel,
        goalCF = v76,
        token = u68,
        isTokenValid = isValid,

        onPresentationDone = function() -- Line: 653, Name: onPresentationDone
            -- upvalues: u75 (ref)
            u75 = true;
        end
    });
    local v77 = os.clock();

    while not u75 and (u67.token == u68 and os.clock() - v77 < 12) do
        task.wait(0.05);
    end;

    return nil;
end;

local function _runStationPump(p78) -- Line: 672
    -- upvalues: SystemGameConfig (copy), _playOneCycle (copy), _resetToIdle (copy)
    local v79 = tonumber(SystemGameConfig.GetValue({ "付费药水展示", "循环空档秒" }));

    if v79 == nil then
        v79 = 0.5;
    end;

    while p78.inZone or p78.pendingReplay do
        p78.pendingReplay = false;
        p78.busy = true;
        _playOneCycle(p78);
        _resetToIdle(p78);
        local v80 = os.clock();

        while os.clock() - v80 < v79 do
            task.wait(0.05);
        end;
    end;

    p78.busy = false;
    p78.loopTask = nil;

    return nil;
end;

local function _ensureStationPump(u81) -- Line: 699
    -- upvalues: _runStationPump (copy)
    if u81.loopTask then
        return nil;
    end;

    u81.loopTask = task.spawn(function() -- Line: 703
        -- upvalues: _runStationPump (ref), u81 (copy)
        _runStationPump(u81);
    end);

    return nil;
end;

function v1.OnEnterZone(p82) -- Line: 715
    -- upvalues: u6 (copy), _runStationPump (copy)
    for _, v in ipairs(u6) do
        if v.touchPart == p82 then
            v.inZone = true;

            if v.busy then
                v.pendingReplay = true;

                return nil;
            end;

            if not v.loopTask then
                v.loopTask = task.spawn(function() -- Line: 703
                    -- upvalues: _runStationPump (ref), v (copy)
                    _runStationPump(v);
                end);
            end;

            return nil;
        end;
    end;

    return nil;
end;

function v1.OnLeaveZone(p83) -- Line: 736
    -- upvalues: u6 (copy)
    for _, v in ipairs(u6) do
        if v.touchPart == p83 then
            v.inZone = false;

            return nil;
        end;
    end;

    return nil;
end;

local function _bindBuyPrompt(p84) -- Line: 752
    -- upvalues: Log (copy), SystemGameConfig (copy), InsMgr (copy), TranslationHelper (copy), AddListen (copy), SystemBuyRoblox (copy), LocalPlayer (copy)
    if not p84.onlyTag then
        Log.warn("[SystemPaidPotionDisplay] Touch 缺少 OnlyTag，跳过购买 Prompt", p84.potionId);

        return nil;
    end;

    local v85 = SystemGameConfig.GetValue({ "付费药水展示", "购买提示文案" });
    local v86 = (type(v85) ~= "string" or v85 == "") and "购买" or v85;
    local v87 = tonumber(SystemGameConfig.GetValue({ "付费药水展示", "购买交互距离" }));
    local v88 = InsMgr.GetIns("PaidPotionBuyPrompt", "ProximityPrompt", p84.infoPart);
    v88.Enabled = true;
    v88.HoldDuration = 0.1;
    v88.Style = Enum.ProximityPromptStyle.Custom;
    v88.MaxActivationDistance = v87 == nil and 12 or v87;
    v88.RequiresLineOfSight = false;
    TranslationHelper.SetText(v88, v86);
    local onlyTag = p84.onlyTag;
    local v89 = AddListen.AddProximityPrompt(v88, function() -- Line: 772
        -- upvalues: SystemBuyRoblox (ref), LocalPlayer (ref), onlyTag (copy)
        SystemBuyRoblox.BuyRobloxByOnlyTag(LocalPlayer, onlyTag);
    end);
    p84.prompt = v88;
    p84.promptConn = v89;

    return nil;
end;

local function _applySellBillboard(p90, p91, p92, p93) -- Line: 789
    -- upvalues: TranslationHelper (copy), UIMgr (copy)
    local ZhName = p90:FindFirstChild("ZhName");

    if ZhName and ZhName:IsA("TextLabel") then
        local v94 = p91.ZhName or p92.ZhName;

        if type(v94) == "string" and v94 ~= "" then
            TranslationHelper.SetText(ZhName, v94);
        end;
    end;

    local XYD = p90:FindFirstChild("XYD");

    if XYD and XYD:IsA("TextLabel") then
        local v95 = tonumber(p91.xyd) or 1;
        local v96 = math.floor(v95);
        local v97 = UIMgr.getXydName(v96);

        if type(v97) == "string" and v97 ~= "" then
            TranslationHelper.SetText(XYD, v97);
        end;

        UIMgr.RemoveGradientColor(XYD);
        UIMgr.AddGradientColor(v96, XYD, true, nil, false);
    end;

    local Cost = p90:FindFirstChild("Cost");

    if Cost and Cost:IsA("TextLabel") then
        UIMgr.SetRobuxPriceLabel(Cost, p93);
    end;

    return nil;
end;

local function _bindSellBillboard(p98) -- Line: 828
    -- upvalues: u3 (copy), Log (copy), LocalPlayer (copy), CfgFind (copy), ItemType (copy), _applySellBillboard (copy)
    if p98.billboard then
        if p98.billboard.Parent then
            p98.billboard:Destroy();
        end;

        p98.billboard = nil;
    end;

    if not u3 then
        return nil;
    end;

    if not p98.onlyTag then
        Log.warn("[SystemPaidPotionDisplay] Folder 缺少 OnlyTag，跳过 Sell Billboard", p98.potionId);

        return nil;
    end;

    local v99 = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10);

    if not v99 then
        Log.warn("[SystemPaidPotionDisplay] 未找到 PlayerGui，跳过 Sell Billboard", p98.potionId);

        return nil;
    end;

    local onlyTag = p98.onlyTag;
    local v100 = CfgFind.FindCfgByOnlyTag(onlyTag);

    if not v100 then
        Log.warn("[SystemPaidPotionDisplay] 未找到付费项配置 OnlyTag=", onlyTag);

        return nil;
    end;

    local v101 = CfgFind.FindCfgByID(p98.potionId, ItemType.Potion) or {};
    local v102 = u3:Clone();
    v102.Name = "Sell" .. "_" .. tostring(p98.potionId);
    v102.Adornee = p98.infoPart;
    v102.Parent = v99;
    _applySellBillboard(v102, v101, v100, onlyTag);
    p98.billboard = v102;

    return nil;
end;

local function _preloadStationSkillsAsync(u103) -- Line: 876
    -- upvalues: ResourceUtil (copy), Log (copy)
    if #u103 == 0 then
        return;
    end;

    task.defer(function() -- Line: 880
        -- upvalues: u103 (copy), ResourceUtil (ref), Log (ref)
        for _, v in ipairs(u103) do
            local success, result = pcall(function() -- Line: 882
                -- upvalues: ResourceUtil (ref), v (copy)
                ResourceUtil.PreloadSkill(v);
            end);

            if not success then
                Log.warn("[SystemPaidPotionDisplay] PreloadSkill 失败，跳过:", v, result);
            end;
        end;
    end);
end;

local function _destroyStation(p104) -- Line: 898
    -- upvalues: _bumpToken (copy), u8 (copy), u6 (copy)
    p104.inZone = false;
    p104.pendingReplay = false;
    p104.busy = false;
    p104.loopTask = nil;
    _bumpToken(p104);

    if p104.promptConn then
        p104.promptConn:Disconnect();
        p104.promptConn = nil;
    end;

    if p104.prompt and p104.prompt.Parent then
        p104.prompt:Destroy();
        p104.prompt = nil;
    end;

    if p104.billboard and p104.billboard.Parent then
        p104.billboard:Destroy();
        p104.billboard = nil;
    end;

    if p104.displayModel and p104.displayModel.Parent then
        p104.displayModel:Destroy();
    end;

    u8[p104.stationFolder] = nil;

    for i, v in ipairs(u6) do
        if v == p104 then
            table.remove(u6, i);
            break;
        end;
    end;

    return nil;
end;

local function _createStation(p105, p106, p107, p108, p109, p110) -- Line: 943
    -- upvalues: u5 (ref), _resolvePotionSkill (copy), LocalSkillPresentation (copy), Log (copy), u9 (copy), ResourceUtil (copy), Workspace (copy), HeldItemVisualUtil (copy), _resetToIdle (copy), _bindBuyPrompt (copy), _bindSellBillboard (copy), u6 (copy), u8 (copy)
    local v111 = u5;

    if not v111 then
        return nil;
    end;

    local v112, v113 = _resolvePotionSkill(p109);

    if v112 and not LocalSkillPresentation.Has(v112) then
        Log.warn("[SystemPaidPotionDisplay] 暂无 LocalPresentation，施法段将跳过:", v112);
    end;

    if v112 and not u9[v112] then
        u9[v112] = true;
        local u114 = { v112 };

        if #u114 ~= 0 then
            task.defer(function() -- Line: 880
                -- upvalues: u114 (copy), ResourceUtil (ref), Log (ref)
                for _, v in ipairs(u114) do
                    local success, result = pcall(function() -- Line: 882
                        -- upvalues: ResourceUtil (ref), v (copy)
                        ResourceUtil.PreloadSkill(v);
                    end);

                    if not success then
                        Log.warn("[SystemPaidPotionDisplay] PreloadSkill 失败，跳过:", v, result);
                    end;
                end;
            end);
        end;
    end;

    if not v113 then
        Log.warn("[SystemPaidPotionDisplay] potionConf.Model 缺失", p109);

        return nil;
    end;

    local v115 = v111:Clone();
    v115.Name = "PaidPotionDisplay_" .. tostring(p109);
    local PaidPotionDisplayLocal = Workspace:FindFirstChild("PaidPotionDisplayLocal");

    if not PaidPotionDisplayLocal then
        PaidPotionDisplayLocal = Instance.new("Folder");
        PaidPotionDisplayLocal.Name = "PaidPotionDisplayLocal";
        PaidPotionDisplayLocal.Parent = Workspace;
    end;

    v115.Parent = PaidPotionDisplayLocal;
    local v116 = {
        token = 0,
        inZone = false,
        busy = false,
        pendingReplay = false,
        loopTask = nil,
        prompt = nil,
        promptConn = nil,
        billboard = nil,
        stationFolder = p105,
        touchPart = p106,
        infoPart = p107,
        anchorPart = p108,
        potionId = p109,
        onlyTag = p110,
        scriptName = v112,
        displayModel = v115,
        potionCfgModelName = v113
    };
    local HumanoidRootPart = v115:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        v115.PrimaryPart = HumanoidRootPart;
    end;

    v115:PivotTo(p108.CFrame);
    HeldItemVisualUtil.SetCharacterAnchored(v115, true);
    _resetToIdle(v116);
    _bindBuyPrompt(v116);
    _bindSellBillboard(v116);
    table.insert(u6, v116);
    u8[p105] = v116;
    Log.print("[SystemPaidPotionDisplay] 展台就绪", p105:GetFullName(), p109);

    return nil;
end;

local function _tryAssembleStation(p117) -- Line: 1008
    -- upvalues: u8 (copy), u7 (copy), _validateFolderAttrs (copy), u5 (ref), _createStation (copy)
    if u8[p117] then
        return nil;
    end;

    local v118 = u7[p117];

    if not (v118 and (v118.touch and (v118.info and v118.anchor))) then
        return nil;
    end;

    if v118.touch.Parent == p117 and (v118.info.Parent == p117 and v118.anchor.Parent == p117) then
        local v119, v120, v121 = _validateFolderAttrs(p117);

        if not (v121 and (v119 and v120)) then
            return nil;
        end;

        if not u5 then
            return nil;
        end;

        _createStation(p117, v118.touch, v118.info, v118.anchor, v119, v120);

        return nil;
    end;

    if v118.touch.Parent ~= p117 then
        v118.touch = nil;
    end;

    if v118.info.Parent ~= p117 then
        v118.info = nil;
    end;

    if v118.anchor.Parent ~= p117 then
        v118.anchor = nil;
    end;

    if not (v118.touch or (v118.info or v118.anchor)) then
        u7[p117] = nil;
    end;

    return nil;
end;

local function _onTaggedPartAdded(p122, p123) -- Line: 1050
    -- upvalues: Log (copy), u7 (copy), _tryAssembleStation (copy)
    if not p122:IsA("BasePart") then
        return nil;
    end;

    local Parent = p122.Parent;

    if not (Parent and Parent:IsA("Folder")) then
        Parent = nil;
    end;

    if not Parent then
        Log.warn("[SystemPaidPotionDisplay] 标签 Part 父级须为 Folder", p122:GetFullName());

        return nil;
    end;

    if not u7[Parent] then
        u7[Parent] = {
            touch = nil,
            info = nil,
            anchor = nil
        };
    end;

    local v124 = u7[Parent];

    if not v124[p123] then
        v124[p123] = p122;
    end;

    _tryAssembleStation(Parent);

    return nil;
end;

local function _onTaggedPartRemoved(p125, p126) -- Line: 1074
    -- upvalues: u7 (copy), u8 (copy), _destroyStation (copy)
    local v127;

    if p125:IsA("BasePart") then
        v127 = p125.Parent;

        if not (v127 and v127:IsA("Folder")) then
            v127 = nil;
        end;
    else
        v127 = nil;
    end;

    if not v127 then
        for i, v in pairs(u7) do
            if v[p126] == p125 then
                v127 = i;
                break;
            end;
        end;
    end;

    if not v127 then
        for i, v in pairs(u8) do
            if p126 == "touch" and v.touchPart == p125 or (p126 == "info" and v.infoPart == p125 or p126 == "anchor" and v.anchorPart == p125) then
                v127 = i;
                break;
            end;
        end;
    end;

    if not v127 then
        return nil;
    end;

    local v128 = u8[v127];

    if v128 then
        _destroyStation(v128);
        u7[v127] = nil;

        return nil;
    end;

    local v129 = u7[v127];

    if v129 then
        v129[p126] = nil;

        if not (v129.touch or (v129.info or v129.anchor)) then
            u7[v127] = nil;
        end;
    end;

    return nil;
end;

local function _replaceStationAvatars(p130) -- Line: 1126
    -- upvalues: u5 (ref), u6 (copy), _bumpToken (copy), Workspace (copy), HeldItemVisualUtil (copy), _resetToIdle (copy), Log (copy)
    u5 = p130;

    for _, v in ipairs(u6) do
        _bumpToken(v);
        v.inZone = false;
        v.pendingReplay = false;
        v.busy = false;
        v.loopTask = nil;

        if v.displayModel and v.displayModel.Parent then
            v.displayModel:Destroy();
        end;

        local v131 = p130:Clone();
        v131.Name = "PaidPotionDisplay_" .. tostring(v.potionId);
        local PaidPotionDisplayLocal = Workspace:FindFirstChild("PaidPotionDisplayLocal");

        if not PaidPotionDisplayLocal then
            PaidPotionDisplayLocal = Instance.new("Folder");
            PaidPotionDisplayLocal.Name = "PaidPotionDisplayLocal";
            PaidPotionDisplayLocal.Parent = Workspace;
        end;

        v131.Parent = PaidPotionDisplayLocal;
        v.displayModel = v131;
        v.token = v.token + 1;
        local anchorPart = v.anchorPart;
        local HumanoidRootPart = v131:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
            v131.PrimaryPart = HumanoidRootPart;
        end;

        v131:PivotTo(anchorPart.CFrame);
        HeldItemVisualUtil.SetCharacterAnchored(v131, true);
        _resetToIdle(v);
    end;

    Log.print("[SystemPaidPotionDisplay] 已用玩家形象替换展台数", #u6);

    return nil;
end;

local function _bindTagListeners(p132, u133) -- Line: 1157
    -- upvalues: CollectionService (copy), _onTaggedPartAdded (copy), _onTaggedPartRemoved (copy)
    CollectionService:GetInstanceAddedSignal(p132):Connect(function(p134) -- Line: 1158
        -- upvalues: _onTaggedPartAdded (ref), u133 (copy)
        _onTaggedPartAdded(p134, u133);
    end);
    CollectionService:GetInstanceRemovedSignal(p132):Connect(function(p135) -- Line: 1161
        -- upvalues: _onTaggedPartRemoved (ref), u133 (copy)
        _onTaggedPartRemoved(p135, u133);
    end);

    for _, v in CollectionService:GetTagged(p132) do
        _onTaggedPartAdded(v, u133);
    end;

    return nil;
end;

function v1.Init() -- Line: 1175
    -- upvalues: u4 (ref), _getFallbackR6RigTemplate (copy), Log (copy), u5 (ref), _waitPlayerAvatarReadyForever (copy), _replaceStationAvatars (copy), _bindTagListeners (copy), u6 (copy)
    if u4 then
        return true;
    end;

    u4 = true;
    local v136 = _getFallbackR6RigTemplate();

    if not v136 then
        u4 = false;
        Log.warn("[SystemPaidPotionDisplay] 无可用 R6Rig 兜底模板");

        return false;
    end;

    u5 = v136;
    task.spawn(function() -- Line: 1195
        -- upvalues: _waitPlayerAvatarReadyForever (ref), _replaceStationAvatars (ref)
        local v137 = _waitPlayerAvatarReadyForever();

        if v137 then
            _replaceStationAvatars(v137);
        end;
    end);
    _bindTagListeners("PaidPotionTouch", "touch");
    _bindTagListeners("PaidPotionInfo", "info");
    _bindTagListeners("PaidPotionAnchor", "anchor");
    Log.print("[SystemPaidPotionDisplay] Init 完成，Tag 监听已绑定，当前展台数", #u6);

    return true;
end;

return v1;