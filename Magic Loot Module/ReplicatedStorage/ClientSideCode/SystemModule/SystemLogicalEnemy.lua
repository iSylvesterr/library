-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local Workspace = game:GetService("Workspace");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ResourceUtil = UtilsSystem.ResourceUtil;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local EnemyLogicalTypes = UtilsSystem.EnemyLogicalTypes;
local VisibleMgr = UtilsSystem.VisibleMgr;
local Log = UtilsSystem.Log;
local MonsterLocomotion = UtilsSystem.MonsterLocomotion;
local MonsterDeathFx = UtilsSystem.MonsterDeathFx;
local TweenService = UtilsSystem.TweenService;
local v1 = {};
local u2 = {};
local u3 = nil;
local u4 = false;
local u5 = true;
local u6 = 0;
local u7 = Vector3.new(0, 0, 0);
local u8 = nil;

local function _getFolder() -- Line: 137
    -- upvalues: EnemyLogicalTypes (copy)
    local LOCAL_MONSTER_FOLDER_NAME = EnemyLogicalTypes.LOCAL_MONSTER_FOLDER_NAME;
    local v9 = workspace:FindFirstChild(LOCAL_MONSTER_FOLDER_NAME);

    if v9 and v9:IsA("Folder") then
        return v9;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = LOCAL_MONSTER_FOLDER_NAME;
    Folder.Parent = workspace;

    return Folder;
end;

local function _getRoot(p10) -- Line: 155
    local v11 = p10.PrimaryPart or p10:FindFirstChild("HumanoidRootPart");

    if v11 and v11:IsA("BasePart") then
        return v11;
    end;

    return nil;
end;

local function _ensureRoot(p12) -- Line: 172
    local root = p12.root;

    if root and root.Parent then
        return root;
    end;

    local model = p12.model;

    if not (model and model.Parent) then
        p12.root = nil;

        return nil;
    end;

    local v13 = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart");

    if not (v13 and v13:IsA("BasePart")) then
        v13 = nil;
    end;

    p12.root = v13;

    return v13;
end;

local function _flatDist(p14, p15) -- Line: 194
    local v16 = p14.X - p15.X;
    local v17 = p14.Z - p15.Z;

    return math.sqrt(v16 * v16 + v17 * v17);
end;

local function _horizontalUnit(p18) -- Line: 206
    local v19 = Vector3.new(p18.X, 0, p18.Z);

    return v19.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v19.Unit;
end;

local function _resolveMaxYawRate(p20, p21) -- Line: 223
    if p20 >= 2.0943951023931953 then
        return nil;
    end;

    local v22 = p21 and 7.5 or 10;

    if p20 <= 0.6981317007977318 then
        return v22;
    end;

    return v22 * (math.clamp((p20 - 0.6981317007977318) / 1.3962634015954634, 0, 1) * 2 + 1);
end;

local function _smoothLook(p23, p24, p25, p26) -- Line: 246
    local v27 = Vector3.new(p24.X, 0, p24.Z);
    local v28 = v27.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v27.Unit;

    if p26 or p25 <= 0 then
        p23.displayLook = v28;

        return v28;
    end;

    local displayLook = p23.displayLook;

    if not displayLook then
        p23.displayLook = v28;

        return v28;
    end;

    local v29 = Vector3.new(displayLook.X, 0, displayLook.Z);
    local v30 = v29.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v29.Unit;
    local v31 = v30:Dot(v28);
    local v32 = math.clamp(v31, -1, 1);
    local v33 = math.acos(v32);

    if v33 < 0.0001 then
        p23.displayLook = v28;

        return v28;
    end;

    local isBoss = p23.isBoss;
    local v34;

    if v33 >= 2.0943951023931953 then
        v34 = nil;
    else
        v34 = isBoss and 7.5 or 10;

        if v33 > 0.6981317007977318 then
            v34 = v34 * (math.clamp((v33 - 0.6981317007977318) / 1.3962634015954634, 0, 1) * 2 + 1);
        end;
    end;

    if not v34 then
        p23.displayLook = v28;

        return v28;
    end;

    local v35 = v30:Lerp(v28, (math.clamp(v34 * p25 / v33, 0, 1)));
    local v36 = Vector3.new(v35.X, 0, v35.Z);
    local v37 = v36.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v36.Unit;
    p23.displayLook = v37;

    return v37;
end;

local function _isSettled(p38, p39, p40) -- Line: 283
    if p38.vel.Magnitude >= 0.02 then
        return false;
    end;

    local Position = p39.Position;
    local Position2 = p40.Position;
    local v41 = Position.X - Position2.X;
    local v42 = Position.Z - Position2.Z;

    if math.sqrt(v41 * v41 + v42 * v42) >= 0.02 then
        return false;
    end;

    return p39.CFrame.LookVector:Dot(p40.LookVector) >= 0.999;
end;

local function _shouldLodSkip(p43, p44) -- Line: 301
    -- upvalues: u5 (ref)
    if not u5 or (p44 or p43.isBoss) then
        return false;
    end;

    if p43.lodDistSq < 14400 then
        return false;
    end;

    p43.frameCursor = p43.frameCursor + 1;

    if p43.frameCursor < 2 then
        return true;
    end;

    p43.frameCursor = 0;

    return false;
end;

local function _bindRenderIfNeeded() -- Line: 321
    -- upvalues: u3 (ref), RunService (copy), u8 (ref)
    if u3 then
        return;
    end;

    u3 = RunService.RenderStepped:Connect(function(p45) -- Line: 325
        -- upvalues: u8 (ref)
        u8(p45);
    end);
end;

local function _unbindRenderIfEmpty() -- Line: 335
    -- upvalues: u2 (copy), u3 (ref)
    if next(u2) ~= nil then
        return;
    end;

    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;
end;

local function _payloadServerTime(p46) -- Line: 351
    if typeof(p46.t) == "number" then
        return p46.t;
    end;

    return workspace:GetServerTimeNow();
end;

local function _payloadCFrame(p47) -- Line: 364
    -- upvalues: EnemyLogicalTypes (copy)
    return EnemyLogicalTypes.unpackCFrame(p47.posX, p47.posY, p47.posZ, p47.lookX, p47.lookY, p47.lookZ);
end;

local function _pushSnapshot(p48, p49, p50) -- Line: 383
    local latest = p48.latest;

    if latest then
        if p50 <= latest.t + 0.0001 then
            return;
        end;

        p48.prev = latest;
        local v51 = p50 - latest.t;

        if v51 > 0.0001 then
            local v52 = (p49.Position - latest.cf.Position) / v51;

            if p48.vel.Magnitude < 0.02 then
                p48.vel = v52;
            else
                p48.vel = p48.vel:Lerp(v52, 0.35);
            end;

            p48.interpDelay = math.clamp(v51 * 0.9, 0.05, 0.09);
            p48.extrapMax = p48.interpDelay * 2;
        end;
    end;

    p48.latest = {
        cf = p49,
        t = p50
    };
end;

local function _resolveDesiredCf(p53, p54) -- Line: 417
    local latest = p53.latest;

    if not latest then
        return nil, false;
    end;

    local prev = p53.prev;

    if prev and p54 <= latest.t then
        local v55 = latest.t - prev.t;

        if v55 <= 0.0001 then
            return latest.cf, false;
        end;

        local v56 = math.clamp((p54 - prev.t) / v55, 0, 1);

        return prev.cf:Lerp(latest.cf, v56), false;
    end;

    if not prev then
        return latest.cf, false;
    end;

    local v57 = p54 - latest.t;

    if v57 <= 0 then
        return latest.cf, false;
    end;

    local extrapMax = p53.extrapMax;
    local v58 = extrapMax <= 0.0001 and 0.18 or extrapMax;

    if v57 > v58 then
        return latest.cf, true;
    end;

    local v59 = latest.cf.Position + p53.vel * v57 * (1 - v57 / v58);
    local LookVector = latest.cf.LookVector;

    return CFrame.lookAt(v59, v59 + (LookVector.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or LookVector)), false;
end;

local function _applyDesired(p60, p61, p62, p63, p64) -- Line: 472
    -- upvalues: _smoothLook (copy)
    local Position = p61.Position;
    local Position2 = p62.Position;
    local v65 = Position.X - Position2.X;
    local v66 = Position.Z - Position2.Z;
    local v67 = math.sqrt(v65 * v65 + v66 * v66);

    if v67 >= 10 then
        p61.CFrame = p62;
        local LookVector = p62.LookVector;
        local v68 = Vector3.new(LookVector.X, 0, LookVector.Z);
        p60.displayLook = v68.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v68.Unit;

        return;
    end;

    if v67 >= 6 then
        local v69 = math.clamp(p64 * 30, 0, 1);
        p61.CFrame = p61.CFrame:Lerp(p62, v69);
        local LookVector = p61.CFrame.LookVector;
        local v70 = Vector3.new(LookVector.X, 0, LookVector.Z);
        p60.displayLook = v70.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v70.Unit;

        return;
    end;

    if not p63 then
        local v71 = _smoothLook(p60, p62.LookVector, p64, false);
        local Position3 = p62.Position;
        p61.CFrame = CFrame.lookAt(Position3, Position3 + v71);

        return;
    end;

    local v72 = math.clamp(p64 * 18, 0, 1);
    p61.CFrame = p61.CFrame:Lerp(p62, v72);
    local LookVector = p61.CFrame.LookVector;
    local v73 = Vector3.new(LookVector.X, 0, LookVector.Z);
    p60.displayLook = v73.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v73.Unit;
end;

local function _refreshLodDistances(p74) -- Line: 503
    -- upvalues: u5 (ref), u6 (ref), Workspace (copy), u7 (ref), u2 (copy)
    if not u5 then
        return;
    end;

    u6 = u6 + p74;

    if u6 < 0.15 then
        return;
    end;

    u6 = 0;
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera then
        u7 = CurrentCamera.CFrame.Position;
    end;

    for _, v in pairs(u2) do
        local root = v.root;

        if not (root and root.Parent) then
            local model = v.model;

            if model and model.Parent then
                root = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart");

                if not (root and root:IsA("BasePart")) then
                    root = nil;
                end;

                v.root = root;
            else
                v.root = nil;
                root = nil;
            end;
        end;

        if root then
            local v75 = root.Position - u7;
            v.lodDistSq = v75:Dot(v75);
        end;
    end;
end;

local function _parseEasingStyle(u76) -- Line: 533
    if type(u76) ~= "string" then
        return Enum.EasingStyle.Quad;
    end;

    local success, result = pcall(function() -- Line: 537
        -- upvalues: u76 (copy)
        return Enum.EasingStyle[u76];
    end);

    return success and result and result or Enum.EasingStyle.Quad;
end;

local function _parseEasingDirection(u77) -- Line: 552
    if type(u77) ~= "string" then
        return Enum.EasingDirection.Out;
    end;

    local success, result = pcall(function() -- Line: 556
        -- upvalues: u77 (copy)
        return Enum.EasingDirection[u77];
    end);

    return success and result and result or Enum.EasingDirection.Out;
end;

local function _finishDisplace(p78, p79) -- Line: 572
    local displace = p78.displace;

    if not displace or displace.gen ~= p79 then
        return;
    end;

    p78.displace = nil;
    local root = p78.root;

    if not (root and root.Parent) then
        local model = p78.model;

        if model and model.Parent then
            root = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart");

            if not (root and root:IsA("BasePart")) then
                root = nil;
            end;

            p78.root = root;
        else
            p78.root = nil;
            root = nil;
        end;
    end;

    local endPos = displace.endPos;
    local look = displace.look;
    local v80 = Vector3.new(look.X, 0, look.Z);
    local v81 = v80.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v80.Unit;
    local v82 = CFrame.lookAt(endPos, endPos + v81);

    if root then
        root.CFrame = v82;
    end;

    p78.displayLook = v81;
    local v83 = workspace:GetServerTimeNow();
    local interpDelay = p78.interpDelay;
    p78.prev = {
        cf = v82,
        t = v83 - (interpDelay <= 0 and 0.09 or interpDelay)
    };
    p78.latest = {
        cf = v82,
        t = v83
    };
    p78.vel = Vector3.new(0, 0, 0);
end;

local function _applyDisplace(p84, p85) -- Line: 603
    -- upvalues: _finishDisplace (copy), TweenService (copy)
    local displace = p84.displace;

    if not displace then
        return false;
    end;

    local root = p84.root;

    if not (root and root.Parent) then
        local model = p84.model;

        if model and model.Parent then
            root = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart");

            if not (root and root:IsA("BasePart")) then
                root = nil;
            end;

            p84.root = root;
        else
            p84.root = nil;
            root = nil;
        end;
    end;

    if not root then
        return true;
    end;

    local duration = displace.duration;

    if duration <= 0 then
        _finishDisplace(p84, displace.gen);

        return false;
    end;

    local v86 = math.clamp((p85 - displace.t0) / duration, 0, 1);
    local v87 = TweenService:GetValue(v86, displace.easingStyle, displace.easingDirection);
    local v88 = displace.startPos:Lerp(displace.endPos, v87);
    local look = displace.look;
    local v89 = Vector3.new(look.X, 0, look.Z);
    local v90 = v89.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v89.Unit;
    p84.displayLook = v90;
    root.CFrame = CFrame.lookAt(v88, v88 + v90);

    if v86 >= 1 then
        _finishDisplace(p84, displace.gen);
    end;

    return true;
end;

u8 = function(p91) -- Line: 635
    -- upvalues: _refreshLodDistances (copy), u2 (copy), _applyDisplace (copy), _resolveDesiredCf (copy), u5 (ref), _applyDesired (copy)
    _refreshLodDistances(p91);
    local v92 = workspace:GetServerTimeNow();

    for _, v in pairs(u2) do
        local model = v.model;

        if model and (model.Parent and not _applyDisplace(v, v92)) then
            local root = v.root;

            if not (root and root.Parent) then
                local model2 = v.model;

                if model2 and model2.Parent then
                    root = model2.PrimaryPart or model2:FindFirstChild("HumanoidRootPart");

                    if not (root and root:IsA("BasePart")) then
                        root = nil;
                    end;

                    v.root = root;
                else
                    v.root = nil;
                    root = nil;
                end;
            end;

            if root then
                local interpDelay = v.interpDelay;
                local v93, v94 = _resolveDesiredCf(v, v92 - (interpDelay <= 0 and 0.09 or interpDelay));

                if v93 then
                    local Position = root.Position;
                    local Position2 = v93.Position;
                    local v95 = Position.X - Position2.X;
                    local v96 = Position.Z - Position2.Z;
                    local v97 = v94 or math.sqrt(v95 * v95 + v96 * v96) >= 6;
                    local v98;

                    if v97 then
                        if u5 and not (v97 or v.isBoss) and v.lodDistSq >= 14400 then
                            v.frameCursor = v.frameCursor + 1;

                            if v.frameCursor >= 2 then
                                v.frameCursor = 0;
                                v98 = false;
                            else
                                v98 = true;
                            end;
                        else
                            v98 = false;
                        end;

                        if not v98 then
                            _applyDesired(v, root, v93, v94, p91);
                        end;
                    else
                        local v99;

                        if v.vel.Magnitude >= 0.02 then
                            v99 = false;
                        else
                            local Position3 = root.Position;
                            local Position4 = v93.Position;
                            local v100 = Position3.X - Position4.X;
                            local v101 = Position3.Z - Position4.Z;

                            if math.sqrt(v100 * v100 + v101 * v101) >= 0.02 then
                                v99 = false;
                            else
                                v99 = root.CFrame.LookVector:Dot(v93.LookVector) >= 0.999;
                            end;
                        end;

                        if not v99 then
                            if u5 and not (v97 or v.isBoss) and v.lodDistSq >= 14400 then
                                v.frameCursor = v.frameCursor + 1;

                                if v.frameCursor >= 2 then
                                    v.frameCursor = 0;
                                    v98 = false;
                                else
                                    v98 = true;
                                end;
                            else
                                v98 = false;
                            end;

                            if not v98 then
                                _applyDesired(v, root, v93, v94, p91);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

local function _destroyEntry(p102) -- Line: 686
    -- upvalues: u2 (copy), u3 (ref)
    local v103 = u2[p102];

    if not v103 then
        return;
    end;

    u2[p102] = nil;

    if v103.model then
        v103.model:Destroy();
    end;

    if next(u2) ~= nil then
        return;
    end;

    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;
end;

local function _spawnFromPayload(p104) -- Line: 704
    -- upvalues: u2 (copy), u3 (ref), CfgFind (copy), EnumMgr (copy), Log (copy), ResourceUtil (copy), EnemyLogicalTypes (copy), VisibleMgr (copy), CollectionService (copy), UtilsSystem (copy), _pushSnapshot (copy), _payloadServerTime (copy), RunService (copy), u8 (ref), MonsterLocomotion (copy)
    if type(p104) ~= "table" or typeof(p104.id) ~= "number" then
        return;
    end;

    local id = p104.id;
    local v105 = u2[id];

    if v105 then
        u2[id] = nil;

        if v105.model then
            v105.model:Destroy();
        end;

        if next(u2) == nil and u3 then
            u3:Disconnect();
            u3 = nil;
        end;
    end;

    local v106 = CfgFind.FindCfgByID(p104.cfgId, EnumMgr.ItemType.Enemy);

    if not v106 or typeof(v106.model) ~= "string" then
        Log.warn("SystemLogicalEnemy: 配置或 model 名无效", p104.cfgId);

        return;
    end;

    local u107 = ResourceUtil.GetModel(ResourceUtil.ModelCategory.Enemy, v106.model, {
        scope = ResourceUtil.Scope.Shared
    });

    if not (u107 and u107.PrimaryPart) then
        Log.warn("SystemLogicalEnemy: 克隆模型失败（请确认 ReplicatedStorage/Assets/ModelRes/Enemy 下存在）", v106.model);

        return;
    end;

    u107.Name = tostring(id);
    local v108 = EnemyLogicalTypes.unpackCFrame(p104.posX, p104.posY, p104.posZ, p104.lookX, p104.lookY, p104.lookZ);
    u107:PivotTo(v108);
    local PrimaryPart = u107.PrimaryPart;

    if PrimaryPart then
        PrimaryPart.CFrame = v108;
    end;

    VisibleMgr.MasslessAll(u107);
    VisibleMgr.UnCollideAll(u107);
    VisibleMgr.SetCollideID(u107, "Enemy");
    local v109 = v106.boss == "1";

    if u107.PrimaryPart then
        local PrimaryPart2 = u107.PrimaryPart;
        PrimaryPart2.Anchored = true;
        PrimaryPart2.CanCollide = false;
        PrimaryPart2.CanQuery = true;
        CollectionService:AddTag(PrimaryPart2, "Enemy");
    end;

    for _, descendant in u107:GetDescendants() do
        if descendant:IsA("LocalScript") and descendant.Name == "Animate" then
            descendant:Destroy();
        end;
    end;

    local v110 = u107:FindFirstChildOfClass("Humanoid");
    local v111 = v110 or u107:FindFirstChildOfClass("AnimationController");

    if v111 and not v111:FindFirstChildOfClass("Animator") then
        Instance.new("Animator").Parent = v111;
    end;

    if v110 then
        v110.WalkSpeed = 0;
        v110.AutoRotate = false;
    end;

    u107:SetAttribute("ID", p104.cfgId);
    u107:SetAttribute("VisibilityMode", EnumMgr.EnemyVisibilityMode.Private);
    u107:SetAttribute(EnemyLogicalTypes.ATTR_IS_LOGICAL, true);

    if u107.PrimaryPart then
        local PrimaryPart2 = u107.PrimaryPart;
        PrimaryPart2:SetAttribute("AutoAtk", v106.proactiveDetectionAggro);
        PrimaryPart2:SetAttribute("Lv", v106.Lv);
        PrimaryPart2:SetAttribute("Xyd", v106.xyd);
        PrimaryPart2:SetAttribute("ZhName", v106.ZhName);
        PrimaryPart2:SetAttribute("Boss", v109);
    end;

    if type(p104.allowedPlayerIds) == "table" then
        u107:SetAttribute("AllowedPlayerIds", UtilsSystem.EnemyVisibilityUtil.serializeAllowedPlayerIds(p104.allowedPlayerIds));
    end;

    if typeof(p104.stage) == "number" then
        u107:SetAttribute("Stage", p104.stage);
    end;

    if p104.combatReady == false then
        u107:SetAttribute("CombatReady", false);
    elseif p104.combatReady == true then
        u107:SetAttribute("CombatReady", true);
    end;

    if v110 and typeof(p104.maxHp) == "number" then
        v110.MaxHealth = p104.maxHp;
        local v112;

        if typeof(p104.hp) == "number" then
            v112 = p104.hp;
        else
            v112 = p104.maxHp;
        end;

        v110.Health = v112;
    end;

    local LOCAL_MONSTER_FOLDER_NAME = EnemyLogicalTypes.LOCAL_MONSTER_FOLDER_NAME;
    local v113 = workspace:FindFirstChild(LOCAL_MONSTER_FOLDER_NAME);

    if not (v113 and v113:IsA("Folder")) then
        v113 = Instance.new("Folder");
        v113.Name = LOCAL_MONSTER_FOLDER_NAME;
        v113.Parent = workspace;
    end;

    u107.Parent = v113;
    local PrimaryPart2 = u107.PrimaryPart;
    local LookVector = v108.LookVector;
    local v114 = Vector3.new(LookVector.X, 0, LookVector.Z);
    local v115 = {
        prev = nil,
        latest = nil,
        vel = Vector3.new(0, 0, 0),
        interpDelay = 0.09,
        extrapMax = 0.18,
        frameCursor = 0,
        lodDistSq = 0,
        displace = nil,
        displaceGen = 0,
        model = u107,
        cfgId = p104.cfgId,
        root = PrimaryPart2,
        isBoss = v109,
        displayLook = v114.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v114.Unit
    };
    _pushSnapshot(v115, v108, _payloadServerTime(p104));
    u2[id] = v115;

    if not u3 then
        u3 = RunService.RenderStepped:Connect(function(p116) -- Line: 325
            -- upvalues: u8 (ref)
            u8(p116);
        end);
    end;

    if p104.polymorphAppear == true then
        u107:ScaleTo(0.1);
        task.defer(function() -- Line: 832
            -- upvalues: u107 (copy), UtilsSystem (ref)
            if not u107.Parent then
                return;
            end;

            local SkillBuffUtil = UtilsSystem.SkillBuffUtil;

            if SkillBuffUtil and SkillBuffUtil.PlayBeSheepPresentation then
                SkillBuffUtil.PlayBeSheepPresentation(u107);
            end;
        end);
    end;

    if MonsterLocomotion and MonsterLocomotion.flushPending then
        MonsterLocomotion.flushPending((tostring(id)));
    end;
end;

function v1.Init() -- Line: 854
    -- upvalues: u4 (ref), EnemyLogicalTypes (copy), u2 (copy), u3 (ref), RunService (copy), u8 (ref)
    if u4 then
        return;
    end;

    u4 = true;
    local LOCAL_MONSTER_FOLDER_NAME = EnemyLogicalTypes.LOCAL_MONSTER_FOLDER_NAME;
    local v117 = workspace:FindFirstChild(LOCAL_MONSTER_FOLDER_NAME);

    if not (v117 and v117:IsA("Folder")) then
        local Folder = Instance.new("Folder");
        Folder.Name = LOCAL_MONSTER_FOLDER_NAME;
        Folder.Parent = workspace;
    end;

    if next(u2) ~= nil then
        if u3 then
            return;
        end;

        u3 = RunService.RenderStepped:Connect(function(p118) -- Line: 325
            -- upvalues: u8 (ref)
            u8(p118);
        end);
    end;
end;

function v1.SetLodEnabled(p119) -- Line: 872
    -- upvalues: u5 (ref), u6 (ref), u2 (copy)
    u5 = p119 == true;

    if not u5 then
        u6 = 0;

        for _, v in pairs(u2) do
            v.frameCursor = 0;
        end;
    end;
end;

function v1.IsLodEnabled() -- Line: 887
    -- upvalues: u5 (ref)
    return u5;
end;

function v1.OnSpawn(p120) -- Line: 897
    -- upvalues: _spawnFromPayload (copy)
    _spawnFromPayload(p120);
end;

function v1.OnSnapshot(p121) -- Line: 907
    -- upvalues: _spawnFromPayload (copy)
    if type(p121) ~= "table" or type(p121.enemies) ~= "table" then
        return;
    end;

    for _, v in ipairs(p121.enemies) do
        _spawnFromPayload(v);
    end;
end;

function v1.OnTransform(p122) -- Line: 922
    -- upvalues: u2 (copy), _pushSnapshot (copy), EnemyLogicalTypes (copy), _payloadServerTime (copy)
    if type(p122) ~= "table" or typeof(p122.id) ~= "number" then
        return;
    end;

    local v123 = u2[p122.id];

    if not v123 then
        return;
    end;

    if v123.displace then
        return;
    end;

    _pushSnapshot(v123, EnemyLogicalTypes.unpackCFrame(p122.posX, p122.posY, p122.posZ, p122.lookX, p122.lookY, p122.lookZ), _payloadServerTime(p122));
end;

function v1.OnDisplace(p124) -- Line: 943
    -- upvalues: u2 (copy)
    if type(p124) ~= "table" or typeof(p124.id) ~= "number" then
        return;
    end;

    local v125 = u2[p124.id];

    if not v125 then
        return;
    end;

    local v126 = tonumber(p124.duration);

    if not v126 or v126 <= 0 then
        return;
    end;

    local v127 = tonumber(p124.t0) or workspace:GetServerTimeNow();
    local v128 = tonumber(p124.startX) or 0;
    local v129 = tonumber(p124.startY) or 0;
    local v130 = tonumber(p124.startZ) or 0;
    local v131 = Vector3.new(v128, v129, v130);
    local v132 = tonumber(p124.endX) or v131.X;
    local v133 = tonumber(p124.endY) or v131.Y;
    local v134 = tonumber(p124.endZ) or v131.Z;
    local v135 = Vector3.new(v132, v133, v134);
    local root = v125.root;

    if not (root and root.Parent) then
        local model = v125.model;

        if model and model.Parent then
            root = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart");

            if not (root and root:IsA("BasePart")) then
                root = nil;
            end;

            v125.root = root;
        else
            v125.root = nil;
            root = nil;
        end;
    end;

    local v136 = Vector3.new(0, 0, -1);

    if root then
        local v137 = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z);

        if v137.Magnitude >= 0.0001 then
            v136 = v137.Unit;
        end;
    end;

    v125.displaceGen = (v125.displaceGen or 0) + 1;
    local v138 = {
        gen = v125.displaceGen,
        startPos = v131,
        endPos = v135,
        look = v136,
        t0 = v127,
        duration = v126
    };
    local easingStyle = p124.easingStyle;
    local v139;

    if type(easingStyle) == "string" then
        local success, result = pcall(function() -- Line: 537
            -- upvalues: easingStyle (copy)
            return Enum.EasingStyle[easingStyle];
        end);
        v139 = success and result and result or Enum.EasingStyle.Quad;
    else
        v139 = Enum.EasingStyle.Quad;
    end;

    v138.easingStyle = v139;
    local easingDirection = p124.easingDirection;
    local v140;

    if type(easingDirection) == "string" then
        local success, result = pcall(function() -- Line: 556
            -- upvalues: easingDirection (copy)
            return Enum.EasingDirection[easingDirection];
        end);
        v140 = success and result and result or Enum.EasingDirection.Out;
    else
        v140 = Enum.EasingDirection.Out;
    end;

    v138.easingDirection = v140;
    v125.displace = v138;
end;

function v1.OnState(p141) -- Line: 1001
    -- upvalues: u2 (copy)
    if type(p141) ~= "table" or typeof(p141.id) ~= "number" then
        return;
    end;

    local v142 = u2[p141.id];

    if v142 then
        v142 = v142.model;
    end;

    if not v142 then
        return;
    end;

    if p141.combatReady == false or p141.combatReady == true then
        v142:SetAttribute("CombatReady", p141.combatReady == true);
    end;

    local v143 = v142:FindFirstChildOfClass("Humanoid");

    if v143 then
        if typeof(p141.maxHp) == "number" then
            v143.MaxHealth = p141.maxHp;
        end;

        if typeof(p141.hp) == "number" then
            v143.Health = p141.hp;
        end;

        v143.WalkSpeed = 0;
    end;
end;

function v1.OnDeath(u144) -- Line: 1032
    -- upvalues: u2 (copy), MonsterDeathFx (copy), VisibleMgr (copy)
    if type(u144) ~= "table" or typeof(u144.id) ~= "number" then
        return;
    end;

    local v145 = u2[u144.id];
    local u146;

    if v145 then
        u146 = v145.model;
    else
        u146 = v145;
    end;

    if not u146 then
        return;
    end;

    if v145 then
        v145.displace = nil;
    end;

    local presentation = u144.presentation;

    if MonsterDeathFx and (MonsterDeathFx.handleIncoming and type(presentation) == "table") then
        pcall(function() -- Line: 1047
            -- upvalues: MonsterDeathFx (ref), u144 (copy), presentation (copy)
            MonsterDeathFx.handleIncoming({
                monsterId = tostring(u144.id),
                kind = presentation.kind,
                animName = presentation.animName
            });
        end);

        return;
    end;

    pcall(function() -- Line: 1057
        -- upvalues: VisibleMgr (ref), u146 (copy)
        VisibleMgr.DieEffect(u146);
    end);
end;

function v1.OnDespawn(p147) -- Line: 1068
    -- upvalues: u2 (copy), u3 (ref)
    if type(p147) ~= "table" or typeof(p147.id) ~= "number" then
        return;
    end;

    local id = p147.id;
    local v148 = u2[id];

    if not v148 then
        return;
    end;

    u2[id] = nil;

    if v148.model then
        v148.model:Destroy();
    end;

    if next(u2) ~= nil then
        return;
    end;

    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;
end;

function v1.GetModel(p149) -- Line: 1081
    -- upvalues: u2 (copy)
    local v150 = tonumber(p149);

    if not v150 then
        return nil;
    end;

    local v151 = u2[v150];

    if v151 then
        v151 = v151.model;
    end;

    return v151;
end;

function v1.ClearAll() -- Line: 1095
    -- upvalues: u2 (copy), u3 (ref)
    local v152 = {};

    for i in pairs(u2) do
        table.insert(v152, i);
    end;

    for _, v in ipairs(v152) do
        local v153 = u2[v];

        if v153 then
            u2[v] = nil;

            if v153.model then
                v153.model:Destroy();
            end;

            if next(u2) == nil then
                if u3 then
                    u3:Disconnect();
                    u3 = nil;
                end;
            end;
        end;
    end;
end;

return v1;