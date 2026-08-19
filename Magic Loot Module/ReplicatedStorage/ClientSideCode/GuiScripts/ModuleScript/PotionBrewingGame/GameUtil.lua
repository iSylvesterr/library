-- Decompiled with Potassium's decompiler.

local u1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local GameCfg = require(script.Parent.GameCfg);
local MaterialCfgApply = require(script.Parent.MaterialCfgApply);
local _ = UtilsSystem.EnumMgr;
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local InsMgr = UtilsSystem.InsMgr;
local HumanModule = UtilsSystem.HumanModule;
local AnimationModule = UtilsSystem.AnimationModule;
local LocalPlayer = UtilsSystem.LocalPlayer;
local Log = UtilsSystem.Log;
local ResourceUtil = UtilsSystem.ResourceUtil;
local SoundModule = UtilsSystem.SoundModule;
local Alchemy = UtilsSystem.GetData.Alchemy;
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = 0;
local u7 = 0;
local u8 = 0;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = {};
local u13 = nil;
local u14 = nil;
local u15 = false;
local u16 = 0;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = {
    mortar = nil,
    conn = nil,
    rels = {}
};

local function _mortarAttachCFrame(p21) -- Line: 80
    if p21.PrimaryPart then
        return p21.PrimaryPart.CFrame;
    end;

    return p21:GetPivot();
end;

local function _resolveMortarPrimaryPart(p22) -- Line: 93
    local PrimaryPart = p22.PrimaryPart;

    if PrimaryPart and PrimaryPart:IsA("BasePart") then
        return PrimaryPart;
    end;

    return p22:FindFirstChildWhichIsA("BasePart", true);
end;

local function _setMortarPrimaryAnchoredOnly(p23) -- Line: 107
    -- upvalues: VisibleMgr (copy)
    if not (p23 and p23:IsA("Model")) then
        return nil;
    end;

    VisibleMgr.UnAnchoredAll(p23);
    local PrimaryPart = p23.PrimaryPart;

    if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
        PrimaryPart = p23:FindFirstChildWhichIsA("BasePart", true);
    end;

    if PrimaryPart then
        PrimaryPart.Anchored = true;
    end;

    return nil;
end;

function u1.StopMaterialFollowMortar() -- Line: 122
    -- upvalues: u20 (copy)
    if u20.conn then
        u20.conn:Disconnect();
        u20.conn = nil;
    end;

    table.clear(u20.rels);
    u20.mortar = nil;
end;

local function _captureMaterialFollowRel(p24, p25) -- Line: 134
    -- upvalues: u20 (copy)
    local v26;

    if p24.PrimaryPart then
        v26 = p24.PrimaryPart.CFrame;
    else
        v26 = p24:GetPivot();
    end;

    if not (v26 and p25.Parent) then
        return;
    end;

    u20.rels[p25] = v26:Inverse() * p25:GetPivot();
end;

local function _applyMaterialFollowOnce() -- Line: 145
    -- upvalues: u20 (copy), VisibleMgr (copy)
    local mortar = u20.mortar;

    if not (mortar and mortar.Parent) then
        return;
    end;

    local v27;

    if mortar.PrimaryPart then
        v27 = mortar.PrimaryPart.CFrame;
    else
        v27 = mortar:GetPivot();
    end;

    if not v27 then
        return;
    end;

    for i, v in pairs(u20.rels) do
        if i.Parent then
            i:PivotTo(v27 * v);
            VisibleMgr.AnchoredAll(i);
        else
            u20.rels[i] = nil;
        end;
    end;
end;

function u1.StartMaterialFollowMortar(p28, p29) -- Line: 170
    -- upvalues: u20 (copy), VisibleMgr (copy), RunService (copy), _applyMaterialFollowOnce (copy)
    u20.mortar = p28;
    table.clear(u20.rels);

    for _, v in ipairs(p29) do
        if v.Parent then
            VisibleMgr.AnchoredAll(v);
            VisibleMgr.UnCollideAll(v);
            local v30;

            if p28.PrimaryPart then
                v30 = p28.PrimaryPart.CFrame;
            else
                v30 = p28:GetPivot();
            end;

            if v30 then
                if v.Parent then
                    u20.rels[v] = v30:Inverse() * v:GetPivot();
                end;
            end;
        end;
    end;

    if not u20.conn then
        u20.conn = RunService.Heartbeat:Connect(function() -- Line: 181
            -- upvalues: _applyMaterialFollowOnce (ref)
            _applyMaterialFollowOnce();
        end);
    end;

    _applyMaterialFollowOnce();
end;

local function _setAnchoredMaterialWorldCf(p31, p32, p33) -- Line: 191
    -- upvalues: VisibleMgr (copy), u20 (copy)
    p32:PivotTo(p33);
    VisibleMgr.AnchoredAll(p32);
    VisibleMgr.UnCollideAll(p32);
    local v34;

    if p31.PrimaryPart then
        v34 = p31.PrimaryPart.CFrame;
    else
        v34 = p31:GetPivot();
    end;

    if v34 then
        if not p32.Parent then
            return;
        end;

        u20.rels[p32] = v34:Inverse() * p32:GetPivot();
    end;
end;

local function _refreshMaterialFollowList(p35, p36) -- Line: 201
    -- upvalues: VisibleMgr (copy), u20 (copy)
    local v37 = {};

    for _, v in ipairs(p36) do
        v37[v] = true;

        if v.Parent then
            VisibleMgr.AnchoredAll(v);

            if u20.rels[v] then
                local v38;

                if p35.PrimaryPart then
                    v38 = p35.PrimaryPart.CFrame;
                else
                    v38 = p35:GetPivot();
                end;

                if v38 then
                    if v.Parent then
                        u20.rels[v] = v38:Inverse() * v:GetPivot();
                    end;
                end;
            else
                local v39;

                if p35.PrimaryPart then
                    v39 = p35.PrimaryPart.CFrame;
                else
                    v39 = p35:GetPivot();
                end;

                if v39 then
                    if v.Parent then
                        u20.rels[v] = v39:Inverse() * v:GetPivot();
                    end;
                end;
            end;
        end;
    end;

    for i in pairs(u20.rels) do
        if not v37[i] then
            u20.rels[i] = nil;
        end;
    end;

    u20.mortar = p35;
end;

function u1.ListChildrenNames(p40) -- Line: 228
    if not p40 then
        return "";
    end;

    local v41 = {};

    for _, child in ipairs(p40:GetChildren()) do
        table.insert(v41, child.Name);
    end;

    return table.concat(v41, ", ");
end;

function u1.CreateSceneManager() -- Line: 244
    -- upvalues: Log (copy), u1 (copy), InsMgr (copy)
    return {
        tempFolder = nil,
        folder = nil,

        GetPart = function(p42, p43, p44) -- Line: 249, Name: GetPart
            -- upvalues: Log (ref)
            if not p42.folder then
                return nil;
            end;

            local v45 = p42.folder:FindFirstChild(p43) or p42.folder:FindFirstChild(p43, true);

            if v45 then
                return v45;
            end;

            local v46 = p42.folder:WaitForChild(p43, p44) or p42.folder:FindFirstChild(p43, true);

            if not v46 then
                Log.warn("缺少场景部件:", p43);
            end;

            return v46;
        end,

        CreateModel = function(p47, p48, p49) -- Line: 266, Name: CreateModel
            -- upvalues: Log (ref), u1 (ref)
            if not p47.folder then
                return nil;
            end;

            if p48 == "研磨棒" then
                local v50 = p47.folder:FindFirstChild("石臼") or p47.folder:FindFirstChild("石臼", true);

                if v50 then
                    return v50:FindFirstChild("Meshes1") or v50:FindFirstChild("Meshes1", true);
                end;

                return nil;
            end;

            local v51 = p47.folder:FindFirstChild(p48) or p47.folder:FindFirstChild(p48, true);

            if v51 then
                return v51;
            end;

            Log.warn("[FATAL] 常驻模型不存在:", p48, "场景子物体:", u1.ListChildrenNames(p47.folder));

            return nil;
        end,

        ResetTempFolder = function(p52) -- Line: 284, Name: ResetTempFolder
            -- upvalues: InsMgr (ref)
            local v53 = InsMgr.GetIns("Game2临时节点", "Folder", workspace);
            v53:ClearAllChildren();
            p52.tempFolder = v53;

            return p52.tempFolder;
        end,

        ClearTempFolder = function(p54) -- Line: 290, Name: ClearTempFolder
            -- upvalues: InsMgr (ref)
            InsMgr.GetIns("Game2临时节点", "Folder", workspace):ClearAllChildren();
        end
    };
end;

function u1.SetMortarCollisionEnabled(p55, p56) -- Line: 304
    -- upvalues: VisibleMgr (copy)
    if not p55 then
        return;
    end;

    local v57 = p55:FindFirstChild("碰撞体", true);

    if not v57 then
        return;
    end;

    VisibleMgr.AnchoredAll(v57);

    if p56 then
        VisibleMgr.CollideAll(v57);

        return;
    end;

    VisibleMgr.UnCollideAll(v57);
end;

local function _getOrCreateSolidFolder(p58) -- Line: 326
    local v59 = p58:FindFirstChild("被选中的材料");

    if not v59 then
        v59 = Instance.new("Folder");
        v59.Name = "被选中的材料";
        v59.Parent = p58;
    end;

    local v60 = v59:FindFirstChild("固体材料");

    if not v60 then
        v60 = Instance.new("Folder");
        v60.Name = "固体材料";
        v60.Parent = v59;
    end;

    if v60:IsA("Folder") then
        return v60;
    end;

    return nil;
end;

local function _collectSlotCFrames(p61) -- Line: 351
    local v62 = p61:FindFirstChild("材料点位");
    local v63 = {};

    if not v62 then
        return v63;
    end;

    local v64 = v62:GetChildren();
    table.sort(v64, function(p65, p66) -- Line: 359
        local v67 = tonumber(p65.Name);
        local v68 = tonumber(p66.Name);

        if v67 and v68 then
            return v67 < v68;
        end;

        if v67 then
            return true;
        end;

        if v68 then
            return false;
        end;

        return p65.Name < p66.Name;
    end);

    for _, v in ipairs(v64) do
        if v:IsA("BasePart") then
            table.insert(v63, v.CFrame);
        elseif v:IsA("Model") then
            table.insert(v63, v:GetPivot());
        elseif v:IsA("Attachment") then
            table.insert(v63, v.WorldCFrame);
        end;
    end;

    return v63;
end;

local function _cloneBowlMaterialModel(p69, u70) -- Line: 393
    -- upvalues: ResourceUtil (copy), GameCfg (copy), MaterialCfgApply (copy), Log (copy)
    local Material = ResourceUtil.ModelCategory.Material;

    if type(u70) ~= "string" or u70 == "" then
        u70 = p69;
    end;

    local function _tagSeed(p71) -- Line: 397
        -- upvalues: u70 (copy)
        p71.Name = u70;
        p71:SetAttribute("BrewAppearanceBase", u70);
        p71:SetAttribute("Stage", 0);

        return p71;
    end;

    local function _applyPreCrushScale(p72) -- Line: 408
        -- upvalues: GameCfg (ref)
        if not p72.ScaleTo then
            return;
        end;

        local v73 = tonumber(GameCfg.BOWL_MATERIAL_SCALE);
        p72:ScaleTo((not v73 or v73 <= 0) and 1 or v73);
    end;

    local v74 = ResourceUtil.GetModel(Material, u70);

    if v74 and v74:IsA("Model") then
        if v74.ScaleTo then
            local v75 = tonumber(GameCfg.BOWL_MATERIAL_SCALE);
            v74:ScaleTo((not v75 or v75 <= 0) and 1 or v75);
        end;

        v74.Name = u70;
        v74:SetAttribute("BrewAppearanceBase", u70);
        v74:SetAttribute("Stage", 0);

        return v74;
    end;

    local v76 = GameCfg.BOWL_MATERIAL_FRAGMENT_KIND or "研磨块";
    local MATERIAL_FRAGMENT_TEMPLATES = GameCfg.MATERIAL_FRAGMENT_TEMPLATES;
    local v77 = MATERIAL_FRAGMENT_TEMPLATES and MATERIAL_FRAGMENT_TEMPLATES[v76] or "模板" .. v76;
    local v78 = ResourceUtil.GetModel(Material, v77);

    if v78 and v78:IsA("Model") then
        MaterialCfgApply.ApplyFragmentAppearance(v78, u70, v76);

        if v78.ScaleTo then
            local v79 = tonumber(GameCfg.BOWL_MATERIAL_SCALE);
            v78:ScaleTo((not v79 or v79 <= 0) and 1 or v79);
        end;

        v78.Name = u70;
        v78:SetAttribute("BrewAppearanceBase", u70);
        v78:SetAttribute("Stage", 0);

        return v78;
    end;

    local v80 = ResourceUtil.GetModel(Material, u70 .. v76);

    if not (v80 and v80:IsA("Model")) then
        Log.warn("[GameUtil] 无法克隆碗内材料:", p69, u70, v77);

        return nil;
    end;

    if v80.ScaleTo then
        local v81 = tonumber(GameCfg.BOWL_MATERIAL_SCALE);
        v80:ScaleTo((not v81 or v81 <= 0) and 1 or v81);
    end;

    v80.Name = u70;
    v80:SetAttribute("BrewAppearanceBase", u70);
    v80:SetAttribute("Stage", 0);

    return v80;
end;

function u1.ClearSpawnedBowlMaterials(p82) -- Line: 453
    -- upvalues: u1 (copy)
    u1.StopMaterialFollowMortar();

    if not p82 then
        return;
    end;

    local v83 = p82:FindFirstChild("被选中的材料");

    if not v83 then
        return;
    end;

    local v84 = v83:FindFirstChild("固体材料");

    if not v84 then
        return;
    end;

    for _, child in ipairs(v84:GetChildren()) do
        if child:GetAttribute("BrewPresentSpawned") == true then
            child:Destroy();
        end;
    end;
end;

function u1.SpawnMaterialsAtBowlSlots(p85, p86) -- Line: 480
    -- upvalues: u1 (copy), _getOrCreateSolidFolder (copy), Log (copy), _collectSlotCFrames (copy), _cloneBowlMaterialModel (copy), VisibleMgr (copy)
    if not p85 or (type(p86) ~= "table" or #p86 == 0) then
        return 0;
    end;

    u1.ClearSpawnedBowlMaterials(p85);
    local v87 = _getOrCreateSolidFolder(p85);

    if not v87 then
        Log.warn("[GameUtil] 无法创建固体材料文件夹");

        return 0;
    end;

    local v88 = _collectSlotCFrames(p85);
    local v89 = p85:FindFirstChild("石臼");
    local v90 = nil;

    if v89 then
        if v89:IsA("Model") then
            v90 = v89:GetPivot() * CFrame.new(0, 1, 0);
        elseif v89:IsA("BasePart") then
            v90 = v89.CFrame * CFrame.new(0, 1, 0);
        end;
    end;

    local v91 = 0;
    local v92 = 0;

    for _, v in ipairs(p86) do
        if type(v) == "table" then
            local name = v.name;

            if type(name) == "string" and name ~= "" then
                local v93 = tonumber(v.count) or 1;
                local v94 = math.floor(v93);
                local v95 = math.max(1, v94);

                for _ = 1, v95 do
                    local v96 = _cloneBowlMaterialModel(name, v.model);

                    if v96 then
                        v91 = v91 + 1;
                        local v97;

                        if #v88 > 0 then
                            v97 = v88[(v91 - 1) % #v88 + 1];
                        elseif v90 then
                            local v98 = (v91 - 1) * (6.283185307179586 / math.max(v95, 3));
                            v97 = v90 * CFrame.new(math.cos(v98) * 0.25, 0, math.sin(v98) * 0.25);
                        else
                            v97 = CFrame.new();
                        end;

                        v96:SetAttribute("BrewPresentSpawned", true);
                        v96.Parent = v87;
                        v96:PivotTo(v97);
                        VisibleMgr.AnchoredAll(v96);
                        VisibleMgr.UnCollideAll(v96);
                        v92 = v92 + 1;
                    end;
                end;
            end;
        end;
    end;

    if v92 == 0 then
        Log.warn("[GameUtil] 碗内材料摆放为 0；材料点位:", #v88, "条目:", #p86);
    end;

    return v92;
end;

function u1.CollectSolidMaterialModels(p99) -- Line: 549
    local v100 = {};

    if not p99 then
        return v100;
    end;

    local v101 = p99:FindFirstChild("被选中的材料");

    if v101 then
        v101 = v101:FindFirstChild("固体材料");
    end;

    if not v101 then
        return v100;
    end;

    for _, child in ipairs(v101:GetChildren()) do
        if child:IsA("Model") and child.Parent then
            table.insert(v100, child);
        end;
    end;

    return v100;
end;

local function _materialCheckRateHit(p102, p103, p104) -- Line: 570
    local v105 = 1;
    local v106 = {};

    for _, v in ipairs(p102) do
        if v105 <= p103 then
            table.insert(v106, v);
        end;

        v105 = v105 + 1;

        if p104 < v105 then
            v105 = 1;
        end;
    end;

    return v106;
end;

local function _materialSpawnFragmentsFromModel(p107, p108, p109, p110) -- Line: 588
    -- upvalues: GameCfg (copy), ResourceUtil (copy), Log (copy), MaterialCfgApply (copy), VisibleMgr (copy)
    local MATERIAL_FRAGMENT_TEMPLATES = GameCfg.MATERIAL_FRAGMENT_TEMPLATES;
    local v111 = MATERIAL_FRAGMENT_TEMPLATES and MATERIAL_FRAGMENT_TEMPLATES[p108] or "模板" .. p108;
    local v112 = ResourceUtil.GetModel(ResourceUtil.ModelCategory.Material, v111);

    if not (v112 and v112:IsA("Model")) then
        Log.warn("[GameUtil] 缺少碎片模板:", v111);

        return {};
    end;

    local v113 = p107:GetAttribute("BrewAppearanceBase");

    if type(v113) ~= "string" or v113 == "" then
        v113 = p107.Name;
    end;

    local PrimaryPart = p107.PrimaryPart;
    local v114 = p107:GetPivot();
    local v115;

    if PrimaryPart then
        local v116 = PrimaryPart.Size.X * 0.3;
        local v117 = PrimaryPart.Size.Z * 0.3;
        v115 = {
            PrimaryPart.CFrame * CFrame.new(v116, 0, v117),
            PrimaryPart.CFrame * CFrame.new(v116, 0, -v117),
            PrimaryPart.CFrame * CFrame.new(-v116, 0, v117),
            PrimaryPart.CFrame * CFrame.new(-v116, 0, -v117)
        };
    else
        v115 = {
            v114 * CFrame.new(0.35, 0, 0.35),
            v114 * CFrame.new(0.35, 0, -0.35),
            v114 * CFrame.new(-0.35, 0, 0.35),
            v114 * CFrame.new(-0.35, 0, -0.35)
        };
    end;

    local v118 = tonumber(GameCfg.CRUSH_BLOCK_SCALE) or 1;
    local v119 = {};

    for i = 1, p109 do
        local v120 = v112:Clone();
        MaterialCfgApply.ApplyFragmentAppearance(v120, v113, p108);

        if p108 == "研磨块" and (v118 > 0 and (v118 ~= 1 and v120.ScaleTo)) then
            v120:ScaleTo(v120:GetScale() * v118);
        end;

        v120.Name = v113;
        v120:SetAttribute("BrewAppearanceBase", v113);
        v120:SetAttribute("BrewPresentSpawned", true);
        v120:SetAttribute("Stage", p110);
        v120.Parent = p107.Parent;
        v120:PivotTo(v115[(i - 1) % #v115 + 1]);
        VisibleMgr.AnchoredAll(v120);
        VisibleMgr.UnCollideAll(v120);
        table.insert(v119, v120);
    end;

    return v119;
end;

local function _materialSpliceMaterials(p121, p122, p123, p124, p125, p126, p127) -- Line: 649
    -- upvalues: _materialCheckRateHit (copy), _materialSpawnFragmentsFromModel (copy)
    local v128 = {};

    for _, v in ipairs(p121) do
        if p122 == nil or v:GetAttribute("Stage") == p122 then
            table.insert(v128, v);
        end;
    end;

    local v129 = _materialCheckRateHit(v128, p123, p124);
    local v130 = {};

    for _, v in ipairs(v129) do
        v130[v] = true;
    end;

    local v131 = {};

    for _, v in ipairs(p121) do
        if (p122 == nil and true or v:GetAttribute("Stage") == p122) and (v130[v] == true and v.Parent) then
            local v132 = _materialSpawnFragmentsFromModel(v, p125, p126, p127);

            for _, v2 in ipairs(v132) do
                table.insert(v131, v2);
            end;

            v:Destroy();
        elseif v.Parent then
            table.insert(v131, v);
        end;
    end;

    return v131;
end;

local function _getMortarOrbitCenterAndMaxRadius(p133) -- Line: 689
    local PrimaryPart = p133.PrimaryPart;

    if not PrimaryPart then
        return nil, 0;
    end;

    local Position = PrimaryPart.Position;
    local v134 = math.max(PrimaryPart.Size.X, PrimaryPart.Size.Z) * 0.5;

    return Position, math.min(12, v134);
end;

local function _clampModelXZToMortarRange(p135, p136, p137, p138) -- Line: 702
    -- upvalues: VisibleMgr (copy), u20 (copy)
    local v139 = p136:GetPivot();
    local Position = v139.Position;
    local v140 = Vector3.new(Position.X - p137.X, 0, Position.Z - p137.Z);
    local Magnitude = v140.Magnitude;

    if Magnitude <= p138 then
        p136:PivotTo(v139);
        VisibleMgr.AnchoredAll(p136);
        VisibleMgr.UnCollideAll(p136);
        local v141;

        if p135.PrimaryPart then
            v141 = p135.PrimaryPart.CFrame;
        else
            v141 = p135:GetPivot();
        end;

        if v141 then
            if not p136.Parent then
                return;
            end;

            u20.rels[p136] = v141:Inverse() * p136:GetPivot();
        end;

        return;
    end;

    local v142 = 1 / Magnitude;
    local v143 = Vector3.new(v140.X * v142 * p138, 0, v140.Z * v142 * p138);
    local v144, v145, v146 = v139:ToOrientation();
    p136:PivotTo(CFrame.new(p137.X + v143.X, Position.Y, p137.Z + v143.Z) * CFrame.Angles(v144, v145, v146));
    VisibleMgr.AnchoredAll(p136);
    VisibleMgr.UnCollideAll(p136);
    local v147;

    if p135.PrimaryPart then
        v147 = p135.PrimaryPart.CFrame;
    else
        v147 = p135:GetPivot();
    end;

    if v147 then
        if not p136.Parent then
            return;
        end;

        u20.rels[p136] = v147:Inverse() * p136:GetPivot();
    end;
end;

local function _clampOrbitMaterialsToMortar(p148, p149) -- Line: 718
    -- upvalues: _clampModelXZToMortarRange (copy), _refreshMaterialFollowList (copy)
    local PrimaryPart = p148.PrimaryPart;
    local v150, v151;

    if PrimaryPart then
        v150 = PrimaryPart.Position;
        local v152 = math.max(PrimaryPart.Size.X, PrimaryPart.Size.Z) * 0.5;
        v151 = math.min(12, v152);
    else
        v150 = nil;
        v151 = 0;
    end;

    if not v150 then
        return;
    end;

    for _, v in ipairs(p149) do
        if v.Parent then
            _clampModelXZToMortarRange(p148, v, v150, v151);
        end;
    end;

    _refreshMaterialFollowList(p148, p149);
end;

function u1.ApplyCrushKnock(p153, p154, p155) -- Line: 739
    -- upvalues: _materialSpliceMaterials (copy), _clampOrbitMaterialsToMortar (copy)
    local v156 = tonumber(p154) or 0;
    local v157 = math.floor(v156);

    if v157 == 1 then
        p153 = _materialSpliceMaterials(p153, nil, 1, 2, "研磨块", 2, 1);
    elseif v157 == 2 then
        p153 = _materialSpliceMaterials(p153, nil, 1, 1, "研磨块", 2, 1);
    elseif v157 == 3 then
        p153 = _materialSpliceMaterials(p153, 1, 1, 2, "研磨球", 2, 2);
    elseif v157 == 4 then
        p153 = _materialSpliceMaterials(p153, 1, 1, 1, "研磨球", 2, 2);
    elseif v157 == 5 then
        p153 = _materialSpliceMaterials(p153, 2, 1, 2, "研磨球", 2, 3);
    elseif v157 == 6 then
        p153 = _materialSpliceMaterials(p153, 2, 1, 1, "研磨球", 2, 3);
    end;

    if p155 then
        _clampOrbitMaterialsToMortar(p155, p153);
    end;

    return p153;
end;

function u1.CreateCrushAnimState(p158, p159) -- Line: 778
    -- upvalues: u1 (copy)
    local v160 = u1.CollectSolidMaterialModels(p158);
    u1.StartMaterialFollowMortar(p159, v160);

    return {
        knockTime = 0,
        orbitPaused = true,
        orbitMoveToken = 0,
        orbitMaterials = v160,
        sceneFolder = p158,
        mortarModel = p159
    };
end;

local function _orbitEnsureAnchored(p161) -- Line: 794
    -- upvalues: VisibleMgr (copy)
    for _, v in ipairs(p161.orbitMaterials) do
        if v.Parent then
            VisibleMgr.AnchoredAll(v);
            VisibleMgr.UnCollideAll(v);
        end;
    end;
end;

local function _orbitSetModelOnArc(p162, p163, p164, p165, p166, p167, p168) -- Line: 803
    -- upvalues: VisibleMgr (copy), u20 (copy)
    local v169 = p164.X + p165 * math.cos(p167);
    local v170 = p164.Z + p165 * math.sin(p167);
    local v171 = Vector3.new(v169, p166, v170);
    local mortarModel = p162.mortarModel;
    p163:PivotTo(CFrame.new(v171) * p168);
    VisibleMgr.AnchoredAll(p163);
    VisibleMgr.UnCollideAll(p163);
    local v172;

    if mortarModel.PrimaryPart then
        v172 = mortarModel.PrimaryPart.CFrame;
    else
        v172 = mortarModel:GetPivot();
    end;

    if v172 then
        if not p163.Parent then
            return;
        end;

        u20.rels[p163] = v172:Inverse() * p163:GetPivot();
    end;
end;

local function _orbitTweenArcSegment(u173, u174, u175, u176, u177, u178, u179, u180, u181, p182) -- Line: 808
    -- upvalues: VisibleMgr (copy), u20 (copy), TweenService (copy)
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Value = 0;
    local v183 = u175.X + u176 * math.cos(u178);
    local v184 = u175.Z + u176 * math.sin(u178);
    local v185 = Vector3.new(v183, u177, v184);
    local mortarModel = u173.mortarModel;
    u174:PivotTo(CFrame.new(v185) * u180);
    VisibleMgr.AnchoredAll(u174);
    VisibleMgr.UnCollideAll(u174);
    local v186;

    if mortarModel.PrimaryPart then
        v186 = mortarModel.PrimaryPart.CFrame;
    else
        v186 = mortarModel:GetPivot();
    end;

    if v186 and u174.Parent then
        u20.rels[u174] = v186:Inverse() * u174:GetPivot();
    end;

    local u187 = TweenService:Create(NumberValue, TweenInfo.new(p182 * 1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
        Value = 1
    });
    local u188 = false;
    local v199 = NumberValue.Changed:Connect(function() -- Line: 826
        -- upvalues: u181 (copy), u173 (copy), u188 (ref), u187 (copy), u175 (copy), NumberValue (copy), u174 (copy), u176 (copy), u177 (copy), u178 (copy), u179 (copy), u180 (copy), VisibleMgr (ref), u20 (ref)
        if u181 ~= u173.orbitMoveToken or u173.orbitPaused then
            if not u188 then
                u188 = true;
                u187:Cancel();
            end;

            return;
        end;

        local PrimaryPart = u173.mortarModel.PrimaryPart;
        local v189;

        if PrimaryPart then
            v189 = PrimaryPart.Position;
            local v190 = math.max(PrimaryPart.Size.X, PrimaryPart.Size.Z) * 0.5;
            math.min(12, v190);
        else
            v189 = nil;
        end;

        local v191 = v189 or u175;
        local v192 = u174;
        local v193 = u176;
        local v194 = u178 + (u179 - u178) * NumberValue.Value;
        local v195 = v191.X + v193 * math.cos(v194);
        local v196 = v191.Z + v193 * math.sin(v194);
        local v197 = Vector3.new(v195, u177, v196);
        local mortarModel2 = u173.mortarModel;
        v192:PivotTo(CFrame.new(v197) * u180);
        VisibleMgr.AnchoredAll(v192);
        VisibleMgr.UnCollideAll(v192);
        local v198;

        if mortarModel2.PrimaryPart then
            v198 = mortarModel2.PrimaryPart.CFrame;
        else
            v198 = mortarModel2:GetPivot();
        end;

        if v198 then
            if not v192.Parent then
                return;
            end;

            u20.rels[v192] = v198:Inverse() * v192:GetPivot();
        end;
    end);
    u187:Play();
    u187.Completed:Wait();
    v199:Disconnect();
    NumberValue:Destroy();

    if u181 == u173.orbitMoveToken and not u173.orbitPaused then
        local PrimaryPart = u173.mortarModel.PrimaryPart;
        local v200;

        if PrimaryPart then
            v200 = PrimaryPart.Position;
            local v201 = math.max(PrimaryPart.Size.X, PrimaryPart.Size.Z) * 0.5;
            math.min(12, v201);
        else
            v200 = nil;
        end;

        local v202 = v200 or u175;
        local v203 = v202.X + u176 * math.cos(u179);
        local v204 = v202.Z + u176 * math.sin(u179);
        local v205 = Vector3.new(v203, u177, v204);
        local mortarModel2 = u173.mortarModel;
        u174:PivotTo(CFrame.new(v205) * u180);
        VisibleMgr.AnchoredAll(u174);
        VisibleMgr.UnCollideAll(u174);
        local v206;

        if mortarModel2.PrimaryPart then
            v206 = mortarModel2.PrimaryPart.CFrame;
        else
            v206 = mortarModel2:GetPivot();
        end;

        if v206 and u174.Parent then
            u20.rels[u174] = v206:Inverse() * u174:GetPivot();
        end;
    end;
end;

local function _orbitTweenModelArcLoop(p207, p208, p209, p210, p211, p212, p213) -- Line: 849
    -- upvalues: _clampModelXZToMortarRange (copy), _orbitTweenArcSegment (copy), _orbitEnsureAnchored (copy)
    _clampModelXZToMortarRange(p207.mortarModel, p208, p209, p210);
    local v214 = p208:GetPivot();
    local Position = v214.Position;
    local v215 = Vector3.new(Position.X - p209.X, 0, Position.Z - p209.Z);

    if v215.Magnitude <= 0.0001 then
        return;
    end;

    local Y = Position.Y;
    local Magnitude = v215.Magnitude;
    local v216, v217, v218 = v214:ToOrientation();
    local v219 = CFrame.Angles(v216, v217, v218);
    local v220 = math.atan2(v215.Z, v215.X);

    while p212 == p207.orbitMoveToken and (not p207.orbitPaused and p208.Parent) do
        local PrimaryPart = p207.mortarModel.PrimaryPart;
        local v221;

        if PrimaryPart then
            v221 = PrimaryPart.Position;
            local v222 = math.max(PrimaryPart.Size.X, PrimaryPart.Size.Z) * 0.5;
            math.min(12, v222);
        else
            v221 = nil;
        end;

        local v223 = v220 + p211 * 3.141592653589793;
        _orbitTweenArcSegment(p207, p208, v221 or p209, Magnitude, Y, v220, v223, v219, p212, p213);
        v220 = v223;
    end;

    _orbitEnsureAnchored(p207);
end;

local function _orbitStartArcLoops(u224, p225) -- Line: 880
    -- upvalues: VisibleMgr (copy), _orbitTweenModelArcLoop (copy)
    u224.orbitMoveToken = u224.orbitMoveToken + 1;
    local orbitMoveToken = u224.orbitMoveToken;
    local u226 = p225 or (math.random() > 0.5 and 1 or -1);
    local PrimaryPart = u224.mortarModel.PrimaryPart;
    local u227, u228;

    if PrimaryPart then
        u227 = PrimaryPart.Position;
        local v229 = math.max(PrimaryPart.Size.X, PrimaryPart.Size.Z) * 0.5;
        u228 = math.min(12, v229);
    else
        u227 = nil;
        u228 = 0;
    end;

    if not u227 then
        return;
    end;

    for _, v in ipairs(u224.orbitMaterials) do
        task.spawn(function() -- Line: 889
            -- upvalues: orbitMoveToken (copy), u224 (copy), v (copy), VisibleMgr (ref), _orbitTweenModelArcLoop (ref), u227 (copy), u228 (copy), u226 (copy)
            task.wait(math.random() * 0.2);

            if orbitMoveToken ~= u224.orbitMoveToken or u224.orbitPaused then
                if v.Parent then
                    VisibleMgr.AnchoredAll(v);
                end;

                return;
            end;

            local v230 = 0.9 + math.random() * 0.20000000000000007;
            local PrimaryPart2 = u224.mortarModel.PrimaryPart;
            local v231, v232;

            if PrimaryPart2 then
                v231 = PrimaryPart2.Position;
                local v233 = math.max(PrimaryPart2.Size.X, PrimaryPart2.Size.Z) * 0.5;
                v232 = math.min(12, v233);
            else
                v231 = nil;
                v232 = 0;
            end;

            if v232 <= 0 then
                v232 = u228;
            end;

            _orbitTweenModelArcLoop(u224, v, v231 or u227, v232, u226, orbitMoveToken, v230);
        end);
    end;
end;

local function _crushChangeMaterState(p234) -- Line: 907
    -- upvalues: u1 (copy), _refreshMaterialFollowList (copy)
    p234.knockTime = p234.knockTime + 1;
    p234.orbitMaterials = u1.ApplyCrushKnock(p234.orbitMaterials, p234.knockTime, p234.mortarModel);
    _refreshMaterialFollowList(p234.mortarModel, p234.orbitMaterials);
end;

local function _crushRotAni(p235) -- Line: 916
    -- upvalues: SoundModule (copy), u1 (copy), _refreshMaterialFollowList (copy), FXUtil (copy)
    pcall(function() -- Line: 917
        -- upvalues: SoundModule (ref)
        SoundModule:PlaySoundLocal({
            SoundName = "音效-炼金-研磨"
        });
    end);
    p235.knockTime = p235.knockTime + 1;
    p235.orbitMaterials = u1.ApplyCrushKnock(p235.orbitMaterials, p235.knockTime, p235.mortarModel);
    _refreshMaterialFollowList(p235.mortarModel, p235.orbitMaterials);
    pcall(function() -- Line: 921
        -- upvalues: SoundModule (ref)
        SoundModule:PlaySoundLocal({
            SoundName = "音效-炼金-升起尘土"
        });
    end);
    local u236 = p235.sceneFolder:FindFirstChild("研磨特效") or p235.sceneFolder:FindFirstChild("研磨特效", true);

    if u236 then
        pcall(function() -- Line: 926
            -- upvalues: FXUtil (ref), u236 (copy)
            FXUtil.Start_All_Particles(u236);
        end);
    end;
end;

local function _crushEffectKeyframe(p237) -- Line: 935
    -- upvalues: u1 (copy), _refreshMaterialFollowList (copy), SoundModule (copy), FXUtil (copy)
    p237.knockTime = p237.knockTime + 1;
    p237.orbitMaterials = u1.ApplyCrushKnock(p237.orbitMaterials, p237.knockTime, p237.mortarModel);
    _refreshMaterialFollowList(p237.mortarModel, p237.orbitMaterials);
    pcall(function() -- Line: 937
        -- upvalues: SoundModule (ref)
        SoundModule:PlaySoundLocal({
            SoundName = "音效-炼金-捶打"
        });
    end);
    local u238 = p237.sceneFolder:FindFirstChild("捶打特效") or p237.sceneFolder:FindFirstChild("捶打特效", true);

    if u238 then
        pcall(function() -- Line: 942
            -- upvalues: FXUtil (ref), u238 (copy)
            FXUtil.Emit_Particles_GetDescendants(u238);
        end);
    end;
end;

local function _crushEndAni(p239) -- Line: 951
    -- upvalues: _orbitEnsureAnchored (copy), _refreshMaterialFollowList (copy), SoundModule (copy)
    p239.orbitPaused = true;
    p239.orbitMoveToken = p239.orbitMoveToken + 1;
    _orbitEnsureAnchored(p239);
    _refreshMaterialFollowList(p239.mortarModel, p239.orbitMaterials);
    pcall(function() -- Line: 956
        -- upvalues: SoundModule (ref)
        SoundModule:StopSoundLocal({
            SoundName = "音效-炼金-研磨"
        });
        SoundModule:PlaySoundLocal({
            SoundName = "音效-炼金-研磨完毕磕到一边"
        });
    end);
end;

local function _crushOrbitPrepareBeforeMove(p240, p241) -- Line: 965
    -- upvalues: _orbitEnsureAnchored (copy), _orbitStartArcLoops (copy)
    p240.orbitPaused = false;
    p240.orbitMoveToken = p240.orbitMoveToken + 1;
    _orbitEnsureAnchored(p240);
    _orbitStartArcLoops(p240, p241);
end;

function u1.PlayMortarCrushWithKeyframes(p242, p243, u244, p245) -- Line: 981
    -- upvalues: Log (copy), u1 (copy), VisibleMgr (copy), u4 (ref), AnimationModule (copy), RunService (copy), LocalPlayer (copy), _crushEffectKeyframe (copy), _crushRotAni (copy), _orbitEnsureAnchored (copy), _refreshMaterialFollowList (copy), SoundModule (copy), _orbitStartArcLoops (copy)
    local u246 = p243:FindFirstChildOfClass("AnimationController") or p243:FindFirstChild("AnimationController");

    if u246 then
        u246 = u246:FindFirstChildOfClass("Animator");
    end;

    if not u246 then
        Log.warn("[GameUtil] 石臼缺少 Animator");
        task.wait(p245);

        return p245;
    end;

    for _, descendant in ipairs(p243:GetDescendants()) do
        if descendant:IsA("Beam") then
            descendant.Enabled = true;
        end;
    end;

    u1.CaptureMortarHomePose(p243);

    if p243 and p243:IsA("Model") then
        VisibleMgr.UnAnchoredAll(p243);
        local PrimaryPart = p243.PrimaryPart;

        if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
            PrimaryPart = p243:FindFirstChildWhichIsA("BasePart", true);
        end;

        if PrimaryPart then
            PrimaryPart.Anchored = true;
        end;
    end;

    u1.SetMortarMeshes1Visible(p243, true);
    local u247 = u1.CreateCrushAnimState(p242, p243);
    u4 = u247;

    if #u247.orbitMaterials == 0 then
        Log.warn("[GameUtil] 捣臼关键帧：固体材料为空");
    end;

    pcall(function() -- Line: 1013
        -- upvalues: AnimationModule (ref), u246 (copy), u244 (copy)
        AnimationModule.StopAnim(u246, u244, 0.1);
    end);
    local v248 = RunService:IsStudio() and (LocalPlayer and LocalPlayer.Name == "QuinnClarkk") and 2 or 1;
    local v254 = AnimationModule.PlayAnim(u246, u244, v248, { "Effect", "转", "扒拉", "End", "顺", "逆", "左", "右" }, {
        function() -- Line: 1029
            -- upvalues: _crushEffectKeyframe (ref), u247 (copy)
            _crushEffectKeyframe(u247);
        end,

        function() -- Line: 1032
            -- upvalues: _crushRotAni (ref), u247 (copy)
            _crushRotAni(u247);
        end,

        function() -- Line: 1035
            -- upvalues: _crushRotAni (ref), u247 (copy)
            _crushRotAni(u247);
        end,

        function() -- Line: 1038
            -- upvalues: u247 (copy), _orbitEnsureAnchored (ref), _refreshMaterialFollowList (ref), SoundModule (ref)
            local v249 = u247;
            v249.orbitPaused = true;
            v249.orbitMoveToken = v249.orbitMoveToken + 1;
            _orbitEnsureAnchored(v249);
            _refreshMaterialFollowList(v249.mortarModel, v249.orbitMaterials);
            pcall(function() -- Line: 956
                -- upvalues: SoundModule (ref)
                SoundModule:StopSoundLocal({
                    SoundName = "音效-炼金-研磨"
                });
                SoundModule:PlaySoundLocal({
                    SoundName = "音效-炼金-研磨完毕磕到一边"
                });
            end);
        end,

        function() -- Line: 1041
            -- upvalues: u247 (copy), _orbitEnsureAnchored (ref), _orbitStartArcLoops (ref)
            local v250 = u247;
            v250.orbitPaused = false;
            v250.orbitMoveToken = v250.orbitMoveToken + 1;
            _orbitEnsureAnchored(v250);
            _orbitStartArcLoops(v250, 1);
        end,

        function() -- Line: 1044
            -- upvalues: u247 (copy), _orbitEnsureAnchored (ref), _orbitStartArcLoops (ref)
            local v251 = u247;
            v251.orbitPaused = false;
            v251.orbitMoveToken = v251.orbitMoveToken + 1;
            _orbitEnsureAnchored(v251);
            _orbitStartArcLoops(v251, -1);
        end,

        function() -- Line: 1047
            -- upvalues: u247 (copy), _orbitEnsureAnchored (ref), _orbitStartArcLoops (ref)
            local v252 = u247;
            v252.orbitPaused = false;
            v252.orbitMoveToken = v252.orbitMoveToken + 1;
            _orbitEnsureAnchored(v252);
            _orbitStartArcLoops(v252, nil);
        end,

        function() -- Line: 1050
            -- upvalues: u247 (copy), _orbitEnsureAnchored (ref), _orbitStartArcLoops (ref)
            local v253 = u247;
            v253.orbitPaused = false;
            v253.orbitMoveToken = v253.orbitMoveToken + 1;
            _orbitEnsureAnchored(v253);
            _orbitStartArcLoops(v253, nil);
        end
    });
    local v255 = tonumber(v254);

    if v255 then
        if v255 > 0 then
            p245 = v255;
        end;
    end;

    local v256 = math.max(0.5, p245) / math.max(0.01, v248);
    local v257 = os.clock() + v256;

    while os.clock() < v257 do
        if u4 ~= u247 then
            return v256;
        end;

        task.wait();
    end;

    u247.orbitPaused = true;
    u247.orbitMoveToken = u247.orbitMoveToken + 1;

    if u4 == u247 then
        u4 = nil;
    end;

    pcall(function() -- Line: 1076
        -- upvalues: AnimationModule (ref), u246 (copy), u244 (copy)
        AnimationModule.StopAnim(u246, u244, 0);
    end);
    u1.SetMortarMeshes1Visible(p243, false);
    u1.RestoreMortarHomePose(p243);

    return v256;
end;

local function _readWorldPose(p258) -- Line: 1090
    if p258:IsA("Model") then
        return p258:GetPivot();
    end;

    if p258:IsA("BasePart") then
        return p258.CFrame;
    end;

    if p258:IsA("Attachment") then
        return p258.WorldCFrame;
    end;

    return nil;
end;

local function _writeWorldPose(p259, p260) -- Line: 1110
    if p259:IsA("Model") then
        p259:PivotTo(p260);
    elseif p259:IsA("BasePart") then
        p259.CFrame = p260;
    elseif p259:IsA("Attachment") then
        p259.WorldCFrame = p260;
    end;

    return nil;
end;

local function _captureVisualAttrs(p261, u262, u263) -- Line: 1129
    local function captureOne(p264) -- Line: 1130
        -- upvalues: u262 (copy), u263 (copy)
        if p264:IsA("BasePart") or (p264:IsA("Decal") or p264:IsA("Texture")) then
            u262[p264] = p264.Transparency;
        end;

        if p264:IsA("PointLight") or (p264:IsA("SpotLight") or (p264:IsA("SurfaceLight") or (p264:IsA("ParticleEmitter") or (p264:IsA("Trail") or (p264:IsA("BillboardGui") or p264:IsA("SurfaceGui")))))) then
            u263[p264] = p264.Enabled;
        end;
    end;

    captureOne(p261);

    for _, descendant in ipairs(p261:GetDescendants()) do
        captureOne(descendant);
    end;

    return nil;
end;

local function _collectFxSnapshotTargets(p265, p266) -- Line: 1159
    local u267 = {};
    local u268 = {};

    local function addTree(p269) -- Line: 1162
        -- upvalues: u268 (copy), u267 (copy)
        if u268[p269] then
            return;
        end;

        u268[p269] = true;
        table.insert(u267, p269);

        for _, descendant in ipairs(p269:GetDescendants()) do
            if not u268[descendant] then
                u268[descendant] = true;
                table.insert(u267, descendant);
            end;
        end;
    end;

    for _, v in ipairs(p266) do
        local v270 = p265:FindFirstChild(v) or p265:FindFirstChild(v, true);

        if v270 then
            addTree(v270);
        end;
    end;

    local v271 = p265:FindFirstChild("水面") or p265:FindFirstChild("水面", true);

    if v271 then
        addTree(v271);
    end;

    return u267;
end;

function u1.CaptureSceneOriginalState(p272) -- Line: 1194
    -- upvalues: u2 (ref), GameCfg (copy), _captureVisualAttrs (copy), _collectFxSnapshotTargets (copy), VisibleMgr (copy), u3 (ref)
    if u2 or not p272 then
        return nil;
    end;

    local v273 = GameCfg.SCENE_SNAPSHOT or {};
    local v274 = v273.PoseNames or { "石臼", "药水锅", "锅搅拌棒", "水面" };
    local v275 = v273.FxFolderNames or { "FX_搅拌", "FX_泡泡", "研磨特效", "捶打特效" };
    local v276 = v273.CollisionBodyName or "碰撞体";
    local v277 = {
        poses = {},
        partColors = {},
        particleColors = {},
        particleEnabled = {},
        beamEnabled = {},
        canCollide = {},
        transparencies = {},
        fxEnabled = {}
    };

    for _, v in ipairs(v274) do
        local v278 = p272:FindFirstChild(v) or p272:FindFirstChild(v, true);

        if v278 then
            local v279;

            if v278:IsA("Model") then
                v279 = v278:GetPivot();
            elseif v278:IsA("BasePart") then
                v279 = v278.CFrame;
            elseif v278:IsA("Attachment") then
                v279 = v278.WorldCFrame;
            else
                v279 = nil;
            end;

            if v279 then
                v277.poses[v278] = v279;
            end;

            _captureVisualAttrs(v278, v277.transparencies, v277.fxEnabled);

            if v == "石臼" then
                local v280 = v278:FindFirstChild("Meshes1") or v278:FindFirstChild("Meshes1", true);

                if v280 then
                    local v281;

                    if v280:IsA("Model") then
                        v281 = v280:GetPivot();
                    elseif v280:IsA("BasePart") then
                        v281 = v280.CFrame;
                    elseif v280:IsA("Attachment") then
                        v281 = v280.WorldCFrame;
                    else
                        v281 = nil;
                    end;

                    if v281 then
                        v277.poses[v280] = v281;
                    end;
                end;

                for _, descendant in ipairs(v278:GetDescendants()) do
                    if descendant:IsA("Beam") then
                        v277.beamEnabled[descendant] = descendant.Enabled;
                    end;
                end;
            end;
        end;
    end;

    for _, v in ipairs((_collectFxSnapshotTargets(p272, v275))) do
        if v:IsA("BasePart") then
            v277.partColors[v] = v.Color;
        elseif v:IsA("ParticleEmitter") then
            v277.particleColors[v] = v.Color;
            v277.particleEnabled[v] = v.Enabled;
        end;
    end;

    local v282 = p272:FindFirstChild(v276, true);

    if v282 then
        if v282:IsA("BasePart") then
            v277.canCollide[v282] = v282.CanCollide;
        end;

        for _, descendant in ipairs(v282:GetDescendants()) do
            if descendant:IsA("BasePart") then
                v277.canCollide[descendant] = descendant.CanCollide;
            end;
        end;
    end;

    u2 = v277;
    local v283 = p272:FindFirstChild("石臼") or p272:FindFirstChild("石臼", true);

    if v283 and v283:IsA("Model") then
        if v283 and v283:IsA("Model") then
            VisibleMgr.UnAnchoredAll(v283);
            local PrimaryPart = v283.PrimaryPart;

            if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
                PrimaryPart = v283:FindFirstChildWhichIsA("BasePart", true);
            end;

            if PrimaryPart then
                PrimaryPart.Anchored = true;
            end;
        end;

        u3 = v283:GetPivot();
    end;

    return nil;
end;

local function _stopMeshes1HideLock() -- Line: 1274
    -- upvalues: u13 (ref)
    if u13 then
        u13:Disconnect();
        u13 = nil;
    end;
end;

local function _startMeshes1HideLock(u284) -- Line: 1286
    -- upvalues: u13 (ref), RunService (copy), u1 (copy)
    if u13 then
        u13:Disconnect();
        u13 = nil;
    end;

    u13 = RunService.Heartbeat:Connect(function() -- Line: 1288
        -- upvalues: u284 (copy), u1 (ref)
        local v285 = u284:FindFirstChild("石臼") or u284:FindFirstChild("石臼", true);

        if v285 and v285:IsA("Model") then
            u1.SetMortarMeshes1Visible(v285, false);
        end;
    end);
end;

local function _cancelMortarPoseTween() -- Line: 1299
    -- upvalues: u8 (ref), u9 (ref), u10 (ref), u11 (ref)
    u8 = u8 + 1;

    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    if u10 then
        pcall(function() -- Line: 1306
            -- upvalues: u10 (ref)
            u10:Cancel();
        end);
        u10 = nil;
    end;

    if u11 then
        u11:Destroy();
        u11 = nil;
    end;
end;

local function _disconnectPourDropConns() -- Line: 1320
    -- upvalues: u12 (copy)
    for _, v in ipairs(u12) do
        if v.Connected then
            v:Disconnect();
        end;
    end;

    table.clear(u12);
end;

local function _resetAnimTransforms(p286) -- Line: 1334
    for _, descendant in ipairs(p286:GetDescendants()) do
        if descendant:IsA("Motor6D") or descendant:IsA("Bone") then
            pcall(function() -- Line: 1337
                -- upvalues: descendant (copy)
                descendant.Transform = CFrame.identity;
            end);
        end;
    end;
end;

function u1.AbortActivePresentations(p287) -- Line: 1350
    -- upvalues: u7 (ref), _cancelMortarPoseTween (copy), _disconnectPourDropConns (copy), u6 (ref), u5 (ref), u4 (ref), u1 (copy), u13 (ref), AnimationModule (copy), _resetAnimTransforms (copy), GameCfg (copy)
    u7 = u7 + 1;
    _cancelMortarPoseTween();
    _disconnectPourDropConns();
    u6 = u6 + 1;

    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;

    if u4 then
        u4.orbitPaused = true;
        local v288 = u4;
        v288.orbitMoveToken = v288.orbitMoveToken + 1;
        u4 = nil;
    end;

    u1.StopMaterialFollowMortar();

    if u13 then
        u13:Disconnect();
        u13 = nil;
    end;

    u1.StopCameraDrive();

    if type(AnimationModule.StopActiveMoonAnimator) == "function" then
        pcall(function() -- Line: 1368
            -- upvalues: AnimationModule (ref)
            AnimationModule.StopActiveMoonAnimator();
        end);
    end;

    if p287 then
        local v289 = p287:FindFirstChild("石臼") or p287:FindFirstChild("石臼", true);

        if v289 and v289:IsA("Model") then
            u1.SetMortarMeshes1Visible(v289, false);
            local u290 = v289:FindFirstChildOfClass("AnimationController") or v289:FindFirstChild("AnimationController", true);

            if u290 then
                u290 = u290:FindFirstChildOfClass("Animator");
            end;

            if u290 then
                pcall(function() -- Line: 1381
                    -- upvalues: AnimationModule (ref), u290 (copy)
                    AnimationModule.StopAll(u290);
                end);
            end;

            _resetAnimTransforms(v289);
        end;

        for _, v in ipairs(GameCfg.SCENE_SNAPSHOT and GameCfg.SCENE_SNAPSHOT.PoseNames or { "石臼", "药水锅", "锅搅拌棒", "水面" }) do
            local v291 = p287:FindFirstChild(v) or p287:FindFirstChild(v, true);

            if v291 and v291 ~= v289 then
                _resetAnimTransforms(v291);
            end;
        end;
    end;

    return nil;
end;

function u1.RestoreSceneOriginalState(u292) -- Line: 1406
    -- upvalues: u1 (copy), u2 (ref), _resetAnimTransforms (copy), VisibleMgr (copy), u3 (ref)
    u1.AbortActivePresentations(u292);

    if u292 then
        u1.ClearSpawnedBowlMaterials(u292);
    end;

    local v293 = u2;

    if not v293 then
        if u292 then
            local v294 = u292:FindFirstChild("石臼") or u292:FindFirstChild("石臼", true);

            if v294 and v294:IsA("Model") then
                u1.RestoreMortarHomePose(v294);
                u1.SetMortarMeshes1Visible(v294, false);
            end;
        end;

        return nil;
    end;

    for i, v in pairs(v293.poses) do
        if i.Parent then
            pcall(function() -- Line: 1427
                -- upvalues: _resetAnimTransforms (ref), i (copy), v (copy)
                _resetAnimTransforms(i);
                local v295 = i;
                local v296 = v;

                if v295:IsA("Model") then
                    v295:PivotTo(v296);

                    return;
                end;

                if v295:IsA("BasePart") then
                    v295.CFrame = v296;

                    return;
                end;

                if v295:IsA("Attachment") then
                    v295.WorldCFrame = v296;
                end;
            end);
        end;
    end;

    for i, v in pairs(v293.partColors) do
        if i.Parent and i:IsA("BasePart") then
            i.Color = v;
        end;
    end;

    for i, v in pairs(v293.particleColors) do
        if i.Parent and i:IsA("ParticleEmitter") then
            i.Color = v;
        end;
    end;

    for i, v in pairs(v293.particleEnabled) do
        if i.Parent and i:IsA("ParticleEmitter") then
            i.Enabled = v;
        end;
    end;

    for i, v in pairs(v293.beamEnabled) do
        if i.Parent and i:IsA("Beam") then
            local v297 = false;

            if u292 then
                local v298 = u292:FindFirstChild("石臼") or u292:FindFirstChild("石臼", true);

                if v298 and v298:IsA("Model") then
                    local v299 = v298:FindFirstChild("Meshes1") or v298:FindFirstChild("Meshes1", true);
                    v297 = v299 and (i == v299 or i:IsDescendantOf(v299)) and true or v297;
                end;
            end;

            if not v297 then
                i.Enabled = v;
            end;
        end;
    end;

    for i, v in pairs(v293.canCollide) do
        if i.Parent and i:IsA("BasePart") then
            i.CanCollide = v;
        end;
    end;

    for i, v in pairs(v293.fxEnabled) do
        if i.Parent then
            local v300 = false;

            if u292 then
                local v301 = u292:FindFirstChild("石臼") or u292:FindFirstChild("石臼", true);

                if v301 and v301:IsA("Model") then
                    local v302 = v301:FindFirstChild("Meshes1") or v301:FindFirstChild("Meshes1", true);
                    v300 = v302 and (i == v302 or i:IsDescendantOf(v302)) and true or v300;
                end;
            end;

            if not v300 then
                pcall(function() -- Line: 1484
                    -- upvalues: i (copy), v (copy)
                    i.Enabled = v;
                end);
            end;
        end;
    end;

    for i, v in pairs(v293.transparencies) do
        if i.Parent then
            local v303 = false;

            if u292 then
                local v304 = u292:FindFirstChild("石臼") or u292:FindFirstChild("石臼", true);

                if v304 and v304:IsA("Model") then
                    local v305 = v304:FindFirstChild("Meshes1") or v304:FindFirstChild("Meshes1", true);
                    v303 = v305 and (i == v305 or i:IsDescendantOf(v305)) and true or v303;
                end;
            end;

            if not v303 then
                pcall(function() -- Line: 1504
                    -- upvalues: i (copy), v (copy)
                    i.Transparency = v;
                end);
            end;
        end;
    end;

    if u292 then
        local v306 = u292:FindFirstChild("石臼") or u292:FindFirstChild("石臼", true);

        if v306 and v306:IsA("Model") then
            if v306 and v306:IsA("Model") then
                VisibleMgr.UnAnchoredAll(v306);
                local PrimaryPart = v306.PrimaryPart;

                if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
                    PrimaryPart = v306:FindFirstChildWhichIsA("BasePart", true);
                end;

                if PrimaryPart then
                    PrimaryPart.Anchored = true;
                end;
            end;

            u1.SetMortarMeshes1Visible(v306, false);
        end;
    end;

    local poses = v293.poses;
    task.defer(function() -- Line: 1522
        -- upvalues: poses (copy), _resetAnimTransforms (ref), u292 (copy), u1 (ref)
        for i, v in pairs(poses) do
            if i.Parent then
                pcall(function() -- Line: 1525
                    -- upvalues: _resetAnimTransforms (ref), i (copy), v (copy)
                    _resetAnimTransforms(i);
                    local v307 = i;
                    local v308 = v;

                    if v307:IsA("Model") then
                        v307:PivotTo(v308);

                        return;
                    end;

                    if v307:IsA("BasePart") then
                        v307.CFrame = v308;

                        return;
                    end;

                    if v307:IsA("Attachment") then
                        v307.WorldCFrame = v308;
                    end;
                end);
            end;
        end;

        if u292 then
            local v309 = u292:FindFirstChild("石臼") or u292:FindFirstChild("石臼", true);

            if v309 and v309:IsA("Model") then
                u1.SetMortarMeshes1Visible(v309, false);
            end;
        end;
    end);
    u2 = nil;
    u3 = nil;

    return nil;
end;

function u1.CaptureMortarHomePose(p310) -- Line: 1549
    -- upvalues: u3 (ref)
    if p310 and (p310.Parent and not u3) then
        u3 = p310:GetPivot();
    end;
end;

function u1.RestoreMortarHomePose(p311) -- Line: 1562
    -- upvalues: u3 (ref), u2 (ref), VisibleMgr (copy)
    if not (p311 and p311.Parent) then
        return;
    end;

    if u3 then
        p311:PivotTo(u3);
    elseif u2 and u2.poses[p311] then
        p311:PivotTo(u2.poses[p311]);
    end;

    if p311 then
        if not p311:IsA("Model") then
            return;
        end;

        VisibleMgr.UnAnchoredAll(p311);
        local PrimaryPart = p311.PrimaryPart;

        if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
            PrimaryPart = p311:FindFirstChildWhichIsA("BasePart", true);
        end;

        if PrimaryPart then
            PrimaryPart.Anchored = true;
        end;
    end;
end;

function u1.TweenMortarToHomePose(u312, p313, u314) -- Line: 1582
    -- upvalues: u3 (ref), u2 (ref), GameCfg (copy), VisibleMgr (copy), _cancelMortarPoseTween (copy), u8 (ref), TweenService (copy), u11 (ref), u10 (ref), u9 (ref)
    if not (u312 and u312.Parent) then
        if u314 then
            u314();
        end;

        return nil;
    end;

    local u315 = u3;

    if not u315 and u2 then
        u315 = u2.poses[u312];
    end;

    if not u315 then
        if u314 then
            u314();
        end;

        return nil;
    end;

    local v316 = GameCfg.POUR_DROP or {};
    local v317 = tonumber(p313) or (tonumber(v316.MortarReturnSec) or 0.85);
    local v318 = math.max(0.05, v317);
    local v319 = u312:GetPivot();

    if (v319.Position - u315.Position).Magnitude < 0.05 then
        u312:PivotTo(u315);

        if u312 and u312:IsA("Model") then
            VisibleMgr.UnAnchoredAll(u312);
            local PrimaryPart = u312.PrimaryPart;

            if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
                PrimaryPart = u312:FindFirstChildWhichIsA("BasePart", true);
            end;

            if PrimaryPart then
                PrimaryPart.Anchored = true;
            end;
        end;

        if u314 then
            u314();
        end;

        return nil;
    end;

    if u312 and u312:IsA("Model") then
        VisibleMgr.UnAnchoredAll(u312);
        local PrimaryPart = u312.PrimaryPart;

        if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
            PrimaryPart = u312:FindFirstChildWhichIsA("BasePart", true);
        end;

        if PrimaryPart then
            PrimaryPart.Anchored = true;
        end;
    end;

    _cancelMortarPoseTween();
    local u320 = u8;
    local CFrameValue = Instance.new("CFrameValue");
    CFrameValue.Value = v319;
    local u321 = TweenService:Create(CFrameValue, TweenInfo.new(v318, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        Value = u315
    });
    u11 = CFrameValue;
    u10 = u321;
    local u322 = CFrameValue:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 1624
        -- upvalues: u320 (copy), u8 (ref), u312 (copy), CFrameValue (copy)
        if u320 ~= u8 then
            return;
        end;

        if u312.Parent then
            u312:PivotTo(CFrameValue.Value);
        end;
    end);
    u9 = u322;
    u321.Completed:Connect(function() -- Line: 1633
        -- upvalues: u9 (ref), u322 (copy), u11 (ref), CFrameValue (copy), u10 (ref), u321 (copy), u320 (copy), u8 (ref), u312 (copy), u315 (ref), VisibleMgr (ref), u314 (copy)
        if u9 == u322 then
            u9 = nil;
        end;

        u322:Disconnect();

        if u11 == CFrameValue then
            u11 = nil;
        end;

        if u10 == u321 then
            u10 = nil;
        end;

        CFrameValue:Destroy();

        if u320 ~= u8 then
            return;
        end;

        if u312.Parent then
            u312:PivotTo(u315);
            local v323 = u312;

            if v323 and v323:IsA("Model") then
                VisibleMgr.UnAnchoredAll(v323);
                local PrimaryPart = v323.PrimaryPart;

                if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
                    PrimaryPart = v323:FindFirstChildWhichIsA("BasePart", true);
                end;

                if PrimaryPart then
                    PrimaryPart.Anchored = true;
                end;
            end;
        end;

        if u314 then
            u314();
        end;
    end);
    u321:Play();

    return nil;
end;

local function _makePourWeld(p324, p325) -- Line: 1669
    for _, child in ipairs(p325:GetChildren()) do
        if child:IsA("WeldConstraint") and child.Name == "BrewPourWeld" then
            child:Destroy();
        end;
    end;

    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Name = "BrewPourWeld";
    WeldConstraint.Part0 = p325;
    WeldConstraint.Part1 = p324;
    WeldConstraint.Parent = p325;

    return nil;
end;

local function _breakPourWelds(p326) -- Line: 1690
    for _, descendant in ipairs(p326:GetDescendants()) do
        if descendant:IsA("WeldConstraint") and descendant.Name == "BrewPourWeld" then
            descendant:Destroy();
        end;
    end;

    return nil;
end;

function u1.SetMortarMeshes1Visible(p327, u328) -- Line: 1706
    if not p327 then
        return;
    end;

    local v329 = p327:FindFirstChild("Meshes1") or p327:FindFirstChild("Meshes1", true);

    if not v329 then
        return;
    end;

    local u330 = u328 and 0 or 1;
    local u331 = u328 and 0 or 1;

    local function applyOne(p332) -- Line: 1718
        -- upvalues: u330 (copy), u331 (copy), u328 (copy)
        if p332:IsA("BasePart") then
            p332.Transparency = u330;
            p332.LocalTransparencyModifier = u331;

            return;
        end;

        if p332:IsA("Decal") or p332:IsA("Texture") then
            p332.Transparency = u330;

            return;
        end;

        if p332:IsA("Beam") or (p332:IsA("ParticleEmitter") or (p332:IsA("Trail") or p332:IsA("PointLight"))) then
            p332.Enabled = u328;
        end;
    end;

    applyOne(v329);

    for _, descendant in ipairs(v329:GetDescendants()) do
        applyOne(descendant);
    end;
end;

local function _cframeFromPotCandidate(p333, p334) -- Line: 1742
    if p333:IsA("Model") then
        return p333:GetPivot() * CFrame.new(0, p334, 0);
    end;

    if p333:IsA("BasePart") then
        return p333.CFrame * CFrame.new(0, p333.Size.Y * 0.5 + p334 * 0.5, 0);
    end;

    local v335 = p333:FindFirstChildWhichIsA("Model", true);

    if v335 then
        return v335:GetPivot() * CFrame.new(0, p334, 0);
    end;

    local v336 = p333:FindFirstChildWhichIsA("BasePart", true);

    if v336 then
        return v336.CFrame * CFrame.new(0, v336.Size.Y * 0.5 + p334 * 0.5, 0);
    end;

    return nil;
end;

local function _resolvePourTipCFrame(p337, p338) -- Line: 1767
    if not p337 then
        return nil;
    end;

    local v339 = p337:FindFirstChild(p338) or p337:FindFirstChild(p338, true);

    if not v339 then
        return nil;
    end;

    if v339:IsA("BasePart") then
        return v339.CFrame;
    end;

    if v339:IsA("Attachment") then
        return v339.WorldCFrame;
    end;

    if v339:IsA("Model") then
        return v339:GetPivot();
    end;

    local v340 = v339:FindFirstChildWhichIsA("BasePart", true);

    if v340 then
        return v340.CFrame;
    end;

    return nil;
end;

local function _tweenModelPivotTo(u341, u342, p343, u344) -- Line: 1800
    -- upvalues: VisibleMgr (copy), TweenService (copy)
    if not u341.Parent then
        if u344 then
            u344();
        end;

        return nil;
    end;

    VisibleMgr.AnchoredAll(u341);
    VisibleMgr.UnCollideAll(u341);
    local v345 = u341:GetPivot();
    local v346 = math.max(0.05, p343);
    local CFrameValue = Instance.new("CFrameValue");
    CFrameValue.Value = v345;
    local v347 = TweenService:Create(CFrameValue, TweenInfo.new(v346, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Value = u342
    });
    local u348 = CFrameValue:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 1818
        -- upvalues: u341 (copy), CFrameValue (copy)
        if u341.Parent then
            u341:PivotTo(CFrameValue.Value);
        end;
    end);
    v347.Completed:Connect(function() -- Line: 1823
        -- upvalues: u348 (copy), CFrameValue (copy), u341 (copy), u342 (copy), u344 (copy)
        u348:Disconnect();
        CFrameValue:Destroy();

        if u341.Parent then
            u341:PivotTo(u342);
        end;

        if u344 then
            u344();
        end;
    end);
    v347:Play();

    return nil;
end;

local function _resolvePotDropCFrame(p349) -- Line: 1845
    -- upvalues: GameCfg (copy), _cframeFromPotCandidate (copy)
    local POUR_DROP = GameCfg.POUR_DROP;
    local v350 = (type(POUR_DROP) ~= "table" or not tonumber(POUR_DROP.PotHeightOffset)) and 0.6 or tonumber(POUR_DROP.PotHeightOffset);
    local v351 = (type(POUR_DROP) ~= "table" or (type(POUR_DROP.DropMarkerNames) ~= "table" or #POUR_DROP.DropMarkerNames <= 0)) and { "材料进锅位置", "水面", "药水锅", "锅", "大锅", "炼药锅" } or POUR_DROP.DropMarkerNames;

    for _, v in ipairs(v351) do
        local v352 = p349:FindFirstChild(v) or p349:FindFirstChild(v, true);

        if v352 then
            local v353 = _cframeFromPotCandidate(v352, v350);

            if v353 then
                return v353;
            end;
        end;
    end;

    return nil;
end;

function u1.PlayPourMaterialsIntoPot(p354, u355, p356) -- Line: 1877
    -- upvalues: u7 (ref), u1 (copy), _resolvePotDropCFrame (copy), GameCfg (copy), _resolvePourTipCFrame (copy), VisibleMgr (copy), _breakPourWelds (copy), Log (copy), _disconnectPourDropConns (copy), RunService (copy), u12 (copy)
    local u357 = u7;
    local u358 = p354:FindFirstChild("石臼") or p354:FindFirstChild("石臼", true);
    local u359 = u1.CollectSolidMaterialModels(p354);
    u1.StopMaterialFollowMortar();
    local u360 = type(p356) ~= "table" or p356.restoreMortar ~= false;

    local function isAlive() -- Line: 1892
        -- upvalues: u357 (copy), u7 (ref)
        return u357 == u7;
    end;

    local v361 = _resolvePotDropCFrame(p354);
    local v362 = GameCfg.POUR_DROP or {};
    local u363 = (type(v362.PourTipMarkerName) ~= "string" or v362.PourTipMarkerName == "") and "倾倒点位" or v362.PourTipMarkerName;
    local u364 = _resolvePourTipCFrame(u358, u363);
    local v365 = tonumber(v362.StaggerSec) or 0.025;
    local v366 = math.max(0, v365);
    local v367 = tonumber(v362.DropDownStuds) or 5;
    local u368 = math.max(0.5, v367);
    local v369 = tonumber(v362.SimGravity) or workspace.Gravity;
    local u370 = math.max(1, v369);

    for _, v in ipairs(u359) do
        if v.Parent then
            VisibleMgr.AnchoredAll(v);
            VisibleMgr.UnCollideAll(v);
            local v371 = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart", true);

            if v371 and v371:IsA("BasePart") then
                v371.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                v371.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
            end;

            _breakPourWelds(v);
        end;
    end;

    local function finishPour() -- Line: 1918
        -- upvalues: u357 (copy), u7 (ref), u360 (ref), u358 (copy), u1 (ref), u355 (copy)
        if u357 ~= u7 then
            return;
        end;

        if u360 and (u358 and u358:IsA("Model")) then
            u1.RestoreMortarHomePose(u358);
        end;

        if u355 then
            u355();
        end;
    end;

    if #u359 == 0 then
        Log.warn("[GameUtil] 倒入：无固体材料");

        if u357 == u7 then
            if u360 and (u358 and u358:IsA("Model")) then
                u1.RestoreMortarHomePose(u358);
            end;

            if u355 then
                u355();
            end;
        end;

        return;
    end;

    if not u364 then
        Log.warn("[GameUtil] 倒入：石臼下缺少「" .. u363 .. "」，无法按倾倒点位倾倒");

        for _, v in ipairs(u359) do
            if v.Parent then
                v:Destroy();
            end;
        end;

        if u357 == u7 then
            if u360 and (u358 and u358:IsA("Model")) then
                u1.RestoreMortarHomePose(u358);
            end;

            if u355 then
                u355();
            end;
        end;

        return;
    end;

    local u372;

    if v361 then
        u372 = v361.Position.Y;
    else
        u372 = nil;
    end;

    local u373 = false;
    local u374 = #u359;
    _disconnectPourDropConns();

    local function markOneDone() -- Line: 1952
        -- upvalues: u373 (ref), u357 (copy), u7 (ref), u374 (ref), _disconnectPourDropConns (ref), u360 (ref), u358 (copy), u1 (ref), u355 (copy)
        if u373 or u357 ~= u7 then
            return;
        end;

        u374 = u374 - 1;

        if u374 <= 0 then
            u373 = true;
            _disconnectPourDropConns();

            if u357 ~= u7 then
                return;
            end;

            if u360 and (u358 and u358:IsA("Model")) then
                u1.RestoreMortarHomePose(u358);
            end;

            if u355 then
                u355();
            end;
        end;
    end;

    local function dropOne(u375) -- Line: 1968
        -- upvalues: u357 (copy), u7 (ref), u373 (ref), u374 (ref), _disconnectPourDropConns (ref), u360 (ref), u358 (copy), u1 (ref), u355 (copy), _breakPourWelds (ref), VisibleMgr (ref), _resolvePourTipCFrame (ref), u363 (copy), u364 (copy), u368 (copy), u372 (copy), RunService (ref), u370 (copy), u12 (ref)
        if u357 ~= u7 or not u375.Parent then
            if not u373 then
                if u357 ~= u7 then
                    return;
                end;

                u374 = u374 - 1;

                if u374 <= 0 then
                    u373 = true;
                    _disconnectPourDropConns();

                    if u357 ~= u7 then
                        return;
                    end;

                    if u360 and (u358 and u358:IsA("Model")) then
                        u1.RestoreMortarHomePose(u358);
                    end;

                    if u355 then
                        u355();
                    end;
                end;
            end;

            return;
        end;

        _breakPourWelds(u375);
        VisibleMgr.AnchoredAll(u375);
        VisibleMgr.UnCollideAll(u375);
        local Position = (_resolvePourTipCFrame(u358, u363) or u364).Position;
        local v376 = u375:GetPivot();
        local u377 = v376 - v376.Position;
        u375:PivotTo(CFrame.new(Position) * u377);
        local X = Position.X;
        local Z = Position.Z;
        local Y = Position.Y;
        local u378 = Y - u368;

        if u372 ~= nil and u372 < u378 then
            u378 = u372;
        end;

        local u379 = 0;
        local u380 = false;
        local u381 = nil;
        u381 = RunService.Heartbeat:Connect(function(p382) -- Line: 1997
            -- upvalues: u380 (ref), u373 (ref), u357 (ref), u7 (ref), u381 (ref), u375 (copy), u374 (ref), _disconnectPourDropConns (ref), u360 (ref), u358 (ref), u1 (ref), u355 (ref), u379 (ref), u370 (ref), Y (ref), u378 (ref), X (copy), Z (copy), u377 (copy)
            if u380 then
                return;
            end;

            if u373 or u357 ~= u7 then
                u380 = true;

                if u381 then
                    u381:Disconnect();
                end;

                return;
            end;

            if not u375.Parent then
                u380 = true;

                if u381 then
                    u381:Disconnect();
                end;

                if not u373 then
                    if u357 ~= u7 then
                        return;
                    end;

                    u374 = u374 - 1;

                    if u374 <= 0 then
                        u373 = true;
                        _disconnectPourDropConns();

                        if u357 ~= u7 then
                            return;
                        end;

                        if u360 and (u358 and u358:IsA("Model")) then
                            u1.RestoreMortarHomePose(u358);
                        end;

                        if u355 then
                            u355();
                        end;
                    end;
                end;

                return;
            end;

            u379 = u379 + u370 * p382;
            Y = Y - u379 * p382;

            if Y > u378 then
                u375:PivotTo(CFrame.new(X, Y, Z) * u377);

                return;
            end;

            Y = u378;
            u380 = true;

            if u381 then
                u381:Disconnect();
            end;

            if u375.Parent then
                u375:PivotTo(CFrame.new(X, Y, Z) * u377);
                u375:Destroy();
            end;

            if not u373 then
                if u357 ~= u7 then
                    return;
                end;

                u374 = u374 - 1;

                if u374 <= 0 then
                    u373 = true;
                    _disconnectPourDropConns();

                    if u357 ~= u7 then
                        return;
                    end;

                    if u360 and (u358 and u358:IsA("Model")) then
                        u1.RestoreMortarHomePose(u358);
                    end;

                    if u355 then
                        u355();
                    end;
                end;
            end;
        end);
        table.insert(u12, u381);
    end;

    for i, v in ipairs(u359) do
        task.delay(v366 * (i - 1), function() -- Line: 2040
            -- upvalues: u373 (ref), u357 (copy), u7 (ref), v (copy), dropOne (copy), u374 (ref), _disconnectPourDropConns (ref), u360 (ref), u358 (copy), u1 (ref), u355 (copy)
            if u373 or u357 ~= u7 then
                return;
            end;

            if v and v.Parent then
                dropOne(v);

                return;
            end;

            if not u373 then
                if u357 ~= u7 then
                    return;
                end;

                u374 = u374 - 1;

                if u374 <= 0 then
                    u373 = true;
                    _disconnectPourDropConns();

                    if u357 ~= u7 then
                        return;
                    end;

                    if u360 and (u358 and u358:IsA("Model")) then
                        u1.RestoreMortarHomePose(u358);
                    end;

                    if u355 then
                        u355();
                    end;
                end;
            end;
        end);
    end;

    if u372 ~= nil and u364 then
        u368 = math.max(u368, u364.Position.Y - u372);
    end;

    local v383 = math.max(0.01, u368 * 2 / u370);
    local v384 = math.sqrt(v383) + 0.5;
    task.delay(v366 * #u359 + v384 + 2, function() -- Line: 2059
        -- upvalues: u373 (ref), u357 (copy), u7 (ref), _disconnectPourDropConns (ref), u359 (copy), u360 (ref), u358 (copy), u1 (ref), u355 (copy)
        if u373 or u357 ~= u7 then
            return;
        end;

        u373 = true;
        _disconnectPourDropConns();

        for _, v in ipairs(u359) do
            if v.Parent then
                v:Destroy();
            end;
        end;

        if u357 ~= u7 then
            return;
        end;

        if u360 and (u358 and u358:IsA("Model")) then
            u1.RestoreMortarHomePose(u358);
        end;

        if u355 then
            u355();
        end;
    end);
end;

local function CreatePlayTransitionToGame2(u385) -- Line: 2079
    -- upvalues: u7 (ref), u13 (ref), FXUtil (copy), VisibleMgr (copy), _cancelMortarPoseTween (copy), u8 (ref), TweenService (copy), u11 (ref), u10 (ref), u9 (ref), Alchemy (copy), u1 (copy), GameCfg (copy), RunService (copy), AnimationModule (copy), _makePourWeld (copy), HumanModule (copy), LocalPlayer (copy), Log (copy)
    return function(u386) -- Line: 2080
        -- upvalues: u385 (copy), u7 (ref), u13 (ref), FXUtil (ref), VisibleMgr (ref), _cancelMortarPoseTween (ref), u8 (ref), TweenService (ref), u11 (ref), u10 (ref), u9 (ref), Alchemy (ref), u1 (ref), GameCfg (ref), RunService (ref), AnimationModule (ref), _makePourWeld (ref), HumanModule (ref), LocalPlayer (ref), Log (ref)
        if not (u385 and u385.folder) then
            if u386 then
                u386();
            end;

            return;
        end;

        local u387 = u7;
        local u388 = false;

        local function _() -- Line: 2094
            -- upvalues: u388 (ref), u387 (copy), u7 (ref)
            return not u388 and u387 == u7;
        end;

        local function safeComplete() -- Line: 2097
            -- upvalues: u388 (ref), u387 (copy), u7 (ref), u13 (ref), u386 (copy)
            if not (not u388 and u387 == u7) then
                return;
            end;

            u388 = true;

            if u13 then
                u13:Disconnect();
                u13 = nil;
            end;

            if u386 then
                u386();
            end;
        end;

        local function stopCrushFx() -- Line: 2111
            -- upvalues: u385 (ref), FXUtil (ref)
            for _, v in ipairs({ "研磨特效", "捶打特效" }) do
                local u389 = u385.folder:FindFirstChild(v) or u385.folder:FindFirstChild(v, true);

                if u389 then
                    pcall(function() -- Line: 2116
                        -- upvalues: FXUtil (ref), u389 (copy)
                        FXUtil.Stop_All_Particles(u389);
                    end);
                end;
            end;
        end;

        local function tiltMortarZThen(u390, p391, p392, u393) -- Line: 2126
            -- upvalues: u388 (ref), u387 (copy), u7 (ref), VisibleMgr (ref), _cancelMortarPoseTween (ref), u8 (ref), TweenService (ref), u11 (ref), u10 (ref), u9 (ref)
            if not (not u388 and u387 == u7) then
                return;
            end;

            local v394 = math.rad(p391);

            if math.abs(v394) < 0.0001 or p392 <= 0 then
                if math.abs(v394) >= 0.0001 then
                    if u390 and u390:IsA("Model") then
                        VisibleMgr.UnAnchoredAll(u390);
                        local PrimaryPart = u390.PrimaryPart;

                        if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
                            PrimaryPart = u390:FindFirstChildWhichIsA("BasePart", true);
                        end;

                        if PrimaryPart then
                            PrimaryPart.Anchored = true;
                        end;
                    end;

                    u390:PivotTo(u390:GetPivot() * CFrame.Angles(0, 0, v394));
                end;

                u393();

                return;
            end;

            if u390 and u390:IsA("Model") then
                VisibleMgr.UnAnchoredAll(u390);
                local PrimaryPart = u390.PrimaryPart;

                if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
                    PrimaryPart = u390:FindFirstChildWhichIsA("BasePart", true);
                end;

                if PrimaryPart then
                    PrimaryPart.Anchored = true;
                end;
            end;

            _cancelMortarPoseTween();
            local u395 = u8;
            local v396 = u390:GetPivot();
            local u397 = v396 * CFrame.Angles(0, 0, v394);
            local CFrameValue = Instance.new("CFrameValue");
            CFrameValue.Value = v396;
            local u398 = TweenService:Create(CFrameValue, TweenInfo.new(p392, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Value = u397
            });
            u11 = CFrameValue;
            u10 = u398;
            local u399 = CFrameValue:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 2153
                -- upvalues: u395 (copy), u8 (ref), u388 (ref), u387 (ref), u7 (ref), u390 (copy), CFrameValue (copy)
                if u395 == u8 then
                    if not u388 and u387 == u7 then
                        if u390.Parent then
                            u390:PivotTo(CFrameValue.Value);
                        end;
                    end;
                end;
            end);
            u9 = u399;
            u398.Completed:Connect(function() -- Line: 2162
                -- upvalues: u9 (ref), u399 (copy), u11 (ref), CFrameValue (copy), u10 (ref), u398 (copy), u395 (copy), u8 (ref), u388 (ref), u387 (ref), u7 (ref), u390 (copy), u397 (copy), VisibleMgr (ref), u393 (copy)
                if u9 == u399 then
                    u9 = nil;
                end;

                u399:Disconnect();

                if u11 == CFrameValue then
                    u11 = nil;
                end;

                if u10 == u398 then
                    u10 = nil;
                end;

                CFrameValue:Destroy();

                if u395 == u8 then
                    if not u388 and u387 == u7 then
                        if u390.Parent then
                            u390:PivotTo(u397);
                            local v400 = u390;

                            if v400 and v400:IsA("Model") then
                                VisibleMgr.UnAnchoredAll(v400);
                                local PrimaryPart = v400.PrimaryPart;

                                if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
                                    PrimaryPart = v400:FindFirstChildWhichIsA("BasePart", true);
                                end;

                                if PrimaryPart then
                                    PrimaryPart.Anchored = true;
                                end;
                            end;
                        end;

                        u393();
                    end;
                end;
            end);
            u398:Play();
        end;

        local function playPourThenReturnMortar() -- Line: 2190
            -- upvalues: u388 (ref), u387 (copy), u7 (ref), Alchemy (ref), u385 (ref), u1 (ref), VisibleMgr (ref), u13 (ref), u386 (copy), GameCfg (ref), tiltMortarZThen (copy)
            if not (not u388 and u387 == u7) then
                return;
            end;

            local function resolveStage2CameraCf() -- Line: 2199
                -- upvalues: Alchemy (ref), u385 (ref)
                local v401 = Alchemy and (type(Alchemy.ResolveStage2CameraCFrame) == "function" and Alchemy.ResolveStage2CameraCFrame());

                if v401 then
                    return v401;
                end;

                local v402 = u385.folder:FindFirstChild("摄像机_2阶段") or u385.folder:FindFirstChild("摄像机_2阶段", true);

                if not v402 then
                    return nil;
                end;

                if v402:IsA("BasePart") then
                    return v402.CFrame;
                end;

                if v402:IsA("Model") then
                    return v402:GetPivot();
                end;

                if v402:IsA("Attachment") then
                    return v402.WorldCFrame;
                end;

                return nil;
            end;

            local function afterStage2Camera() -- Line: 2226
                -- upvalues: u388 (ref), u387 (ref), u7 (ref), u385 (ref), u1 (ref), VisibleMgr (ref), u13 (ref), u386 (ref), GameCfg (ref), tiltMortarZThen (ref)
                if not (not u388 and u387 == u7) then
                    return;
                end;

                local v403 = u385.folder:FindFirstChild("石臼") or u385.folder:FindFirstChild("石臼", true);

                if v403 and v403:IsA("Model") then
                    u1.SetMortarMeshes1Visible(v403, false);
                end;

                local function startMaterialPour() -- Line: 2236
                    -- upvalues: u388 (ref), u387 (ref), u7 (ref), u1 (ref), u385 (ref), VisibleMgr (ref), u13 (ref), u386 (ref)
                    if not (not u388 and u387 == u7) then
                        return;
                    end;

                    local v404 = u1.CollectSolidMaterialModels(u385.folder);

                    for _, v in ipairs(v404) do
                        if v.Parent then
                            VisibleMgr.AnchoredAll(v);
                            VisibleMgr.UnCollideAll(v);
                            local v405 = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart", true);

                            if v405 and v405:IsA("BasePart") then
                                v405.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                                v405.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
                            end;
                        end;
                    end;

                    u1.PlayPourMaterialsIntoPot(u385.folder, function() -- Line: 2253
                        -- upvalues: u388 (ref), u387 (ref), u7 (ref), u385 (ref), u1 (ref), u13 (ref), u386 (ref)
                        if not (not u388 and u387 == u7) then
                            return;
                        end;

                        local u406 = u385.folder:FindFirstChild("石臼") or u385.folder:FindFirstChild("石臼", true);

                        if u406 and u406:IsA("Model") then
                            u1.SetMortarMeshes1Visible(u406, false);
                            u1.TweenMortarToHomePose(u406, nil, function() -- Line: 2260
                                -- upvalues: u388 (ref), u387 (ref), u7 (ref), u1 (ref), u406 (copy), u385 (ref), u13 (ref), u386 (ref)
                                if not (not u388 and u387 == u7) then
                                    return;
                                end;

                                u1.SetMortarMeshes1Visible(u406, false);
                                u1.ClearSpawnedBowlMaterials(u385.folder);

                                if not (not u388 and u387 == u7) then
                                    return;
                                end;

                                u388 = true;

                                if u13 then
                                    u13:Disconnect();
                                    u13 = nil;
                                end;

                                if u386 then
                                    u386();
                                end;
                            end);

                            return;
                        end;

                        u1.ClearSpawnedBowlMaterials(u385.folder);

                        if not (not u388 and u387 == u7) then
                            return;
                        end;

                        u388 = true;

                        if u13 then
                            u13:Disconnect();
                            u13 = nil;
                        end;

                        if u386 then
                            u386();
                        end;
                    end, {
                        restoreMortar = false
                    });
                end;

                local v407 = GameCfg.POUR_DROP or {};
                local v408 = tonumber(v407.PourTiltZDeg) or -10;
                local v409 = tonumber(v407.PourTiltSec) or 0.25;
                local v410 = math.max(0, v409);

                if v403 and v403:IsA("Model") then
                    tiltMortarZThen(v403, v408, v410, startMaterialPour);

                    return;
                end;

                startMaterialPour();
            end;

            task.wait();

            if not (not u388 and u387 == u7) then
                return;
            end;

            local v411 = tonumber((GameCfg.CAMERA_CONFIG or {}).Stage2MoveSec) or 0.85;
            local v412 = resolveStage2CameraCf();
            local CurrentCamera = workspace.CurrentCamera;

            if CurrentCamera then
                u1.StartCameraDrive(CurrentCamera.CFrame);
            end;

            if v412 then
                u1.TweenCameraTo(v412, v411);
            end;

            if not (not u388 and u387 == u7) then
                return;
            end;

            afterStage2Camera();
        end;

        stopCrushFx();
        local folder = u385.folder;

        if u13 then
            u13:Disconnect();
            u13 = nil;
        end;

        u13 = RunService.Heartbeat:Connect(function() -- Line: 1288
            -- upvalues: folder (copy), u1 (ref)
            local v413 = folder:FindFirstChild("石臼") or folder:FindFirstChild("石臼", true);

            if v413 and v413:IsA("Model") then
                u1.SetMortarMeshes1Visible(v413, false);
            end;
        end);
        local u414 = u385:CreateModel("石臼");

        if u414 and u414:IsA("Model") then
            u1.CaptureMortarHomePose(u414);
            local u415 = u414:FindFirstChildOfClass("AnimationController") or u414:FindFirstChild("AnimationController", true);

            if u415 then
                u415 = u415:FindFirstChildOfClass("Animator");
            end;

            if u415 then
                pcall(function() -- Line: 2317
                    -- upvalues: AnimationModule (ref), u415 (copy)
                    AnimationModule.StopAll(u415);
                end);
            end;

            u1.RestoreMortarHomePose(u414);
            u1.SetMortarMeshes1Visible(u414, false);
        end;

        u1.StopMaterialFollowMortar();
        local v416 = u1.CollectSolidMaterialModels(u385.folder);
        local u417 = u414 and u414:IsA("Model") and (u414.PrimaryPart or u414:FindFirstChildWhichIsA("BasePart", true));

        if u417 and u417:IsA("BasePart") then
            for _, v in ipairs(v416) do
                if v.Parent then
                    VisibleMgr.UnAnchoredAll(v);
                    VisibleMgr.UnCollideAll(v);
                    local u418 = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart", true);

                    if u418 and u418:IsA("BasePart") then
                        pcall(function() -- Line: 2337
                            -- upvalues: _makePourWeld (ref), u417 (copy), u418 (copy)
                            _makePourWeld(u417, u418);
                        end);
                    end;
                end;
            end;
        end;

        if u414 and u414:IsA("Model") then
            u1.RestoreMortarHomePose(u414);
            u1.SetMortarMeshes1Visible(u414, false);
        end;

        task.wait();

        if not (not u388 and u387 == u7) then
            return;
        end;

        u1.StopCameraDrive();
        local u419 = u414 and (u414:FindFirstChild("高光") or u414:FindFirstChild("高光", true));

        if u419 then
            pcall(function() -- Line: 2363
                -- upvalues: u419 (copy), VisibleMgr (ref)
                if u419:IsA("BasePart") then
                    u419.Anchored = false;
                end;

                VisibleMgr.fadeAllTween(u419, 0);
            end);
        end;

        local POUR_TO_POT_MOON_ANIMS = GameCfg.POUR_TO_POT_MOON_ANIMS;
        local v420 = (type(POUR_TO_POT_MOON_ANIMS) ~= "table" or #POUR_TO_POT_MOON_ANIMS == 0) and { "甩锅入杠4", "甩锅入杠" } or POUR_TO_POT_MOON_ANIMS;
        local v421 = HumanModule.GetCharacter(LocalPlayer);
        local u422 = v421 and { v421 } or nil;

        local function tryPlayMoon(u423) -- Line: 2380
            -- upvalues: stopCrushFx (copy), u414 (copy), u1 (ref), AnimationModule (ref), u385 (ref), Log (ref), u422 (copy), playPourThenReturnMortar (copy)
            if type(u423) ~= "string" or u423 == "" then
                return false;
            end;

            stopCrushFx();

            if u414 and u414:IsA("Model") then
                u1.RestoreMortarHomePose(u414);
            end;

            pcall(function() -- Line: 2389
                -- upvalues: AnimationModule (ref), u423 (copy), u385 (ref)
                AnimationModule.ChangeRootFolder(u423, u385.folder, "炼药场景");
            end);
            Log.warn("[GameUtil] 开始倒材料进锅 Moon:", u423);
            local v424 = false;

            if type(AnimationModule.PlayMoonAnimatorWithCameraOffset) == "function" then
                local success, result = pcall(function() -- Line: 2396
                    -- upvalues: AnimationModule (ref), u423 (copy), u422 (ref), playPourThenReturnMortar (ref)
                    return AnimationModule.PlayMoonAnimatorWithCameraOffset(u423, u422, playPourThenReturnMortar);
                end);

                if success and result == true then
                    v424 = true;
                elseif not success then
                    Log.warn("[GameUtil] 甩锅入杠（镜头偏移）失败:", result);
                end;
            end;

            if not v424 and type(AnimationModule.PlayMoonAnimator) == "function" then
                local success, result = pcall(function() -- Line: 2406
                    -- upvalues: AnimationModule (ref), u423 (copy), u422 (ref), playPourThenReturnMortar (ref)
                    return AnimationModule.PlayMoonAnimator(u423, u422, playPourThenReturnMortar);
                end);

                if success and result == true then
                    return true;
                end;

                if not success then
                    Log.warn("[GameUtil] 甩锅入杠回退播放失败:", result);
                end;
            end;

            return v424;
        end;

        for _, v in ipairs(v420) do
            if tryPlayMoon(v) then
                task.delay(45, function() -- Line: 2420
                    -- upvalues: u388 (ref), u387 (copy), u7 (ref), Log (ref), v (copy), playPourThenReturnMortar (copy)
                    if not u388 and u387 == u7 then
                        Log.warn("[GameUtil] 甩锅入杠超时，强制结束:", v);
                        playPourThenReturnMortar();
                    end;
                end);

                return;
            end;
        end;

        Log.warn("[GameUtil] 倒材料进锅 Moon 全部失败，改用垂直掉落兜底");
        playPourThenReturnMortar();
    end;
end;

local function _collectStirFxTargets(p425) -- Line: 2438
    -- upvalues: GameCfg (copy)
    local v426 = GameCfg.STIR_PRESENTATION or {};
    local v427 = {};
    local v428 = p425:FindFirstChild(v426.FxFolderName or "FX_搅拌") or p425:FindFirstChild(v426.FxFolderName or "FX_搅拌", true);

    if v428 then
        for _, descendant in ipairs(v428:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                table.insert(v427, descendant);
            end;
        end;
    end;

    local v429 = p425:FindFirstChild("水面") or p425:FindFirstChild("水面", true);

    if v429 and v429:IsA("BasePart") then
        table.insert(v427, v429);
    end;

    local v430 = p425:FindFirstChild("FX_泡泡") or p425:FindFirstChild("FX_泡泡", true);

    if v430 then
        for _, descendant in ipairs(v430:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                table.insert(v427, descendant);
            end;
        end;
    end;

    return v427;
end;

local function _resolveStage3CameraCFrame(p431, p432) -- Line: 2473
    -- upvalues: Alchemy (copy)
    local v433 = Alchemy and type(Alchemy.ResolveStage3CameraCFrame) == "function" and Alchemy.ResolveStage3CameraCFrame();

    if v433 then
        return v433;
    end;

    if not p431 then
        return nil;
    end;

    local v434 = p431:FindFirstChild(p432) or p431:FindFirstChild(p432, true);

    if not v434 then
        return nil;
    end;

    if v434:IsA("BasePart") then
        return v434.CFrame;
    end;

    if v434:IsA("Model") then
        return v434:GetPivot();
    end;

    if v434:IsA("Attachment") then
        return v434.WorldCFrame;
    end;

    local v435 = v434:FindFirstChildWhichIsA("BasePart", true);

    if v435 then
        return v435.CFrame;
    end;

    return nil;
end;

function u1.StartCameraDrive(p436) -- Line: 2509
    -- upvalues: u14 (ref), u15 (ref), RunService (copy)
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return nil;
    end;

    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    u14 = p436 or CurrentCamera.CFrame;

    if not u15 then
        RunService:BindToRenderStep("PotionBrewingGameCam", Enum.RenderPriority.Camera.Value + 1, function() -- Line: 2517
            -- upvalues: u14 (ref)
            local CurrentCamera2 = workspace.CurrentCamera;

            if CurrentCamera2 and u14 then
                CurrentCamera2.CameraType = Enum.CameraType.Scriptable;
                CurrentCamera2.CFrame = u14;
            end;
        end);
        u15 = true;
    end;

    return nil;
end;

function u1.StopCameraDrive() -- Line: 2534
    -- upvalues: u16 (ref), u17 (ref), u18 (ref), u19 (ref), u15 (ref), RunService (copy), u14 (ref)
    u16 = u16 + 1;

    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    if u18 then
        pcall(function() -- Line: 2541
            -- upvalues: u18 (ref)
            u18:Cancel();
        end);
        u18 = nil;
    end;

    if u19 then
        u19:Destroy();
        u19 = nil;
    end;

    if u15 then
        pcall(function() -- Line: 2551
            -- upvalues: RunService (ref)
            RunService:UnbindFromRenderStep("PotionBrewingGameCam");
        end);
        u15 = false;
    end;

    local CurrentCamera = workspace.CurrentCamera;

    if CurrentCamera and u14 then
        CurrentCamera.CameraType = Enum.CameraType.Scriptable;
        CurrentCamera.CFrame = u14;
    end;

    u14 = nil;

    return nil;
end;

function u1.TweenCameraTo(p437, p438) -- Line: 2572
    -- upvalues: GameCfg (copy), u1 (copy), u16 (ref), u17 (ref), u18 (ref), u19 (ref), u14 (ref), TweenService (copy)
    if not p437 then
        return nil;
    end;

    local v439 = GameCfg.CAMERA_CONFIG or {};
    local v440 = tonumber(p438) or (tonumber(v439.Stage1MoveSec) or 0.85);
    local v441 = math.max(0.05, v440);
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return nil;
    end;

    local CFrame2 = CurrentCamera.CFrame;
    u1.StartCameraDrive(CFrame2);
    u16 = u16 + 1;
    local u442 = u16;

    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    if u18 then
        pcall(function() -- Line: 2594
            -- upvalues: u18 (ref)
            u18:Cancel();
        end);
        u18 = nil;
    end;

    if u19 then
        u19:Destroy();
        u19 = nil;
    end;

    local Magnitude = (CFrame2.Position - p437.Position).Magnitude;
    local v443 = CFrame2.LookVector:Dot(p437.LookVector);

    if Magnitude < 0.02 and v443 > 0.999 then
        u14 = p437;

        return nil;
    end;

    local CFrameValue = Instance.new("CFrameValue");
    CFrameValue.Value = CFrame2;
    u19 = CFrameValue;
    local v444 = TweenService:Create(CFrameValue, TweenInfo.new(v441, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {
        Value = p437
    });
    u18 = v444;
    u17 = CFrameValue:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 2620
        -- upvalues: u442 (copy), u16 (ref), u14 (ref), CFrameValue (copy)
        if u442 == u16 then
            u14 = CFrameValue.Value;
        end;
    end);
    local u445 = false;
    v444.Completed:Connect(function() -- Line: 2627
        -- upvalues: u445 (ref)
        u445 = true;
    end);
    v444:Play();
    local v446 = os.clock() + v441 + 0.5;

    while not u445 and os.clock() < v446 do
        if u442 ~= u16 then
            return nil;
        end;

        task.wait();
    end;

    if u442 == u16 then
        u14 = p437;

        if u17 then
            u17:Disconnect();
            u17 = nil;
        end;

        u18 = nil;

        if u19 then
            u19:Destroy();
            u19 = nil;
        end;
    end;

    return nil;
end;

local function _setStirFxEnabled(p447, p448) -- Line: 2658
    -- upvalues: GameCfg (copy)
    local v449 = GameCfg.STIR_PRESENTATION or {};
    local v450 = p447:FindFirstChild(v449.FxFolderName or "FX_搅拌") or p447:FindFirstChild(v449.FxFolderName or "FX_搅拌", true);

    if not v450 then
        return;
    end;

    local v451 = v450:FindFirstChild(v449.FxPartName or "搅拌") or v450;

    for _, v in ipairs(v449.EnableEmitterNames or {}) do
        local v452 = v451:FindFirstChild(v, true);

        if v452 and v452:IsA("ParticleEmitter") then
            v452.Enabled = p448;
        end;
    end;

    for _, descendant in ipairs(v451:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") and string.find(descendant.Name, "搅拌", 1, true) then
            descendant.Enabled = p448;
        end;
    end;
end;

local function _applyStirColorProgress(p453, p454, p455) -- Line: 2686
    local v456 = math.clamp(p453, 0, 1);
    local v457 = Color3.fromHSV(v456 * 0.9, v456 * 0.2 + 0.75, 1);

    for _, v in ipairs(p454) do
        local v458 = p455[v] or Color3.new(1, 1, 1);
        local v459 = v458:Lerp(v457, v456);

        if v:IsA("ParticleEmitter") then
            local v460 = Color3.fromHSV((v456 * 0.9 + 0.33) % 1, 0.85, 1);
            local v461 = Color3.fromHSV((v456 * 0.9 + 0.66) % 1, 0.85, 1);
            v.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, v459), ColorSequenceKeypoint.new(0.5, v458:Lerp(v460, v456)), ColorSequenceKeypoint.new(1, v458:Lerp(v461, v456)) });
        elseif v:IsA("BasePart") then
            v.Color = v459;
        end;
    end;
end;

function u1.PlayStirPresentation(u462, u463) -- Line: 2713
    -- upvalues: GameCfg (copy), _resolveStage3CameraCFrame (copy), u1 (copy), Log (copy), _collectStirFxTargets (copy), _setStirFxEnabled (copy), u6 (ref), u5 (ref), RunService (copy), _applyStirColorProgress (copy)
    local u464 = GameCfg.STIR_PRESENTATION or {};
    local v465 = tonumber(u464.OrbitCount) or 1;
    local v466 = math.floor(v465);
    local v467 = math.max(1, v466);
    local v468 = tonumber(u464.OrbitSpeedDeg) or 180;
    local u469 = math.max(30, v468);
    local u470 = v467 * 360 / u469;
    local v471 = u464.RodModelName or "锅搅拌棒";
    local v472 = u464.CameraMarkerName or "摄像机_3阶段";
    local v473 = GameCfg.CAMERA_CONFIG or {};
    local v474 = tonumber(u464.CameraMoveSec) or (tonumber(v473.Stage3MoveSec) or 1.8);

    if not u462 then
        local v475 = tonumber(u464.EndHoldSec) or 0.5;
        local v476 = math.max(0, v475);
        task.wait(v474 + u470 + v476);

        if u463 then
            u463();
        end;

        return;
    end;

    local v477 = _resolveStage3CameraCFrame(u462, v472);

    if v477 then
        u1.TweenCameraTo(v477, v474);
    else
        Log.warn("[GameUtil] 缺少搅拌镜头标记:", v472);
    end;

    local u478 = u462:FindFirstChild(v471) or u462:FindFirstChild(v471, true);
    local u479 = _collectStirFxTargets(u462);
    local u480 = {};

    for _, v in ipairs(u479) do
        if v:IsA("ParticleEmitter") then
            local Keypoints = v.Color.Keypoints;
            local v481;

            if Keypoints and Keypoints[1] then
                v481 = Keypoints[1].Value;
            else
                v481 = Color3.new(1, 1, 1);
            end;

            u480[v] = v481;
        elseif v:IsA("BasePart") then
            u480[v] = v.Color;
        end;
    end;

    _setStirFxEnabled(u462, true);
    local u482 = nil;

    if u478 and u478:IsA("Model") then
        u482 = u478:GetPivot();
    elseif u478 and u478:IsA("BasePart") then
        u482 = u478.CFrame;
    else
        Log.warn("[GameUtil] 缺少搅拌棒，仅播特效变色:", v471);
    end;

    u6 = u6 + 1;
    local u483 = u6;
    local u484 = 0;

    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;

    u5 = RunService.Heartbeat:Connect(function(p485) -- Line: 2771
        -- upvalues: u483 (copy), u6 (ref), u5 (ref), u484 (ref), u470 (copy), _applyStirColorProgress (ref), u479 (copy), u480 (copy), u482 (ref), u478 (copy), u469 (copy), _setStirFxEnabled (ref), u462 (copy), u464 (copy), u463 (copy)
        if u483 ~= u6 then
            if u5 then
                u5:Disconnect();
                u5 = nil;
            end;

            return;
        end;

        u484 = u484 + p485;
        _applyStirColorProgress(math.clamp(u484 / u470, 0, 1), u479, u480);

        if u482 and (u478 and u478.Parent) then
            local v486 = math.rad(u469 * u484);
            local v487 = u482 * CFrame.Angles(0, v486, 0);

            if u478:IsA("Model") then
                u478:PivotTo(v487);
            elseif u478:IsA("BasePart") then
                u478.CFrame = v487;
            end;
        end;

        if u470 <= u484 then
            if u5 then
                u5:Disconnect();
                u5 = nil;
            end;

            if u483 ~= u6 then
                return;
            end;

            _applyStirColorProgress(1, u479, u480);

            if u482 and (u478 and u478.Parent) then
                if u478:IsA("Model") then
                    u478:PivotTo(u482);
                elseif u478:IsA("BasePart") then
                    u478.CFrame = u482;
                end;
            end;

            task.delay(0.35, function() -- Line: 2810
                -- upvalues: u483 (ref), u6 (ref), _setStirFxEnabled (ref), u462 (ref)
                if u483 == u6 then
                    _setStirFxEnabled(u462, false);
                end;
            end);
            local v488 = tonumber(u464.EndHoldSec) or 0.5;
            local v489 = math.max(0, v488);

            if v489 > 0 then
                local v490 = os.clock() + v489;

                while os.clock() < v490 do
                    if u483 ~= u6 then
                        return;
                    end;

                    task.wait();
                end;
            end;

            if u483 ~= u6 then
                return;
            end;

            if u463 then
                u463();
            end;
        end;
    end);
end;

function u1.CreateOrchestrator(u491) -- Line: 2841
    -- upvalues: u7 (ref), u13 (ref), FXUtil (copy), VisibleMgr (copy), _cancelMortarPoseTween (copy), u8 (ref), TweenService (copy), u11 (ref), u10 (ref), u9 (ref), Alchemy (copy), u1 (copy), GameCfg (copy), RunService (copy), AnimationModule (copy), _makePourWeld (copy), HumanModule (copy), LocalPlayer (copy), Log (copy)
    if u491 then
        u491 = u491.SceneManager;
    end;

    if not u491 then
        error("[GameUtil] CreateOrchestrator: sharedState.SceneManager is required");
    end;

    return {
        PlayTransitionToGame2 = function(u492) -- Line: 2080
            -- upvalues: u491 (copy), u7 (ref), u13 (ref), FXUtil (ref), VisibleMgr (ref), _cancelMortarPoseTween (ref), u8 (ref), TweenService (ref), u11 (ref), u10 (ref), u9 (ref), Alchemy (ref), u1 (ref), GameCfg (ref), RunService (ref), AnimationModule (ref), _makePourWeld (ref), HumanModule (ref), LocalPlayer (ref), Log (ref)
            if not (u491 and u491.folder) then
                if u492 then
                    u492();
                end;

                return;
            end;

            local u493 = u7;
            local u494 = false;

            local function _() -- Line: 2094
                -- upvalues: u494 (ref), u493 (copy), u7 (ref)
                return not u494 and u493 == u7;
            end;

            local function _() -- Line: 2097
                -- upvalues: u494 (ref), u493 (copy), u7 (ref), u13 (ref), u492 (copy)
                if not (not u494 and u493 == u7) then
                    return;
                end;

                u494 = true;

                if u13 then
                    u13:Disconnect();
                    u13 = nil;
                end;

                if u492 then
                    u492();
                end;
            end;

            local function u496() -- Line: 2111
                -- upvalues: u491 (ref), FXUtil (ref)
                for _, v in ipairs({ "研磨特效", "捶打特效" }) do
                    local u495 = u491.folder:FindFirstChild(v) or u491.folder:FindFirstChild(v, true);

                    if u495 then
                        pcall(function() -- Line: 2116
                            -- upvalues: FXUtil (ref), u495 (copy)
                            FXUtil.Stop_All_Particles(u495);
                        end);
                    end;
                end;
            end;

            local function u508(u497, p498, p499, u500) -- Line: 2126
                -- upvalues: u494 (ref), u493 (copy), u7 (ref), VisibleMgr (ref), _cancelMortarPoseTween (ref), u8 (ref), TweenService (ref), u11 (ref), u10 (ref), u9 (ref)
                if not (not u494 and u493 == u7) then
                    return;
                end;

                local v501 = math.rad(p498);

                if math.abs(v501) < 0.0001 or p499 <= 0 then
                    if math.abs(v501) >= 0.0001 then
                        if u497 and u497:IsA("Model") then
                            VisibleMgr.UnAnchoredAll(u497);
                            local PrimaryPart = u497.PrimaryPart;

                            if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
                                PrimaryPart = u497:FindFirstChildWhichIsA("BasePart", true);
                            end;

                            if PrimaryPart then
                                PrimaryPart.Anchored = true;
                            end;
                        end;

                        u497:PivotTo(u497:GetPivot() * CFrame.Angles(0, 0, v501));
                    end;

                    u500();

                    return;
                end;

                if u497 and u497:IsA("Model") then
                    VisibleMgr.UnAnchoredAll(u497);
                    local PrimaryPart = u497.PrimaryPart;

                    if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
                        PrimaryPart = u497:FindFirstChildWhichIsA("BasePart", true);
                    end;

                    if PrimaryPart then
                        PrimaryPart.Anchored = true;
                    end;
                end;

                _cancelMortarPoseTween();
                local u502 = u8;
                local v503 = u497:GetPivot();
                local u504 = v503 * CFrame.Angles(0, 0, v501);
                local CFrameValue = Instance.new("CFrameValue");
                CFrameValue.Value = v503;
                local u505 = TweenService:Create(CFrameValue, TweenInfo.new(p499, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Value = u504
                });
                u11 = CFrameValue;
                u10 = u505;
                local u506 = CFrameValue:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 2153
                    -- upvalues: u502 (copy), u8 (ref), u494 (ref), u493 (ref), u7 (ref), u497 (copy), CFrameValue (copy)
                    if u502 == u8 then
                        if not u494 and u493 == u7 then
                            if u497.Parent then
                                u497:PivotTo(CFrameValue.Value);
                            end;
                        end;
                    end;
                end);
                u9 = u506;
                u505.Completed:Connect(function() -- Line: 2162
                    -- upvalues: u9 (ref), u506 (copy), u11 (ref), CFrameValue (copy), u10 (ref), u505 (copy), u502 (copy), u8 (ref), u494 (ref), u493 (ref), u7 (ref), u497 (copy), u504 (copy), VisibleMgr (ref), u500 (copy)
                    if u9 == u506 then
                        u9 = nil;
                    end;

                    u506:Disconnect();

                    if u11 == CFrameValue then
                        u11 = nil;
                    end;

                    if u10 == u505 then
                        u10 = nil;
                    end;

                    CFrameValue:Destroy();

                    if u502 == u8 then
                        if not u494 and u493 == u7 then
                            if u497.Parent then
                                u497:PivotTo(u504);
                                local v507 = u497;

                                if v507 and v507:IsA("Model") then
                                    VisibleMgr.UnAnchoredAll(v507);
                                    local PrimaryPart = v507.PrimaryPart;

                                    if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
                                        PrimaryPart = v507:FindFirstChildWhichIsA("BasePart", true);
                                    end;

                                    if PrimaryPart then
                                        PrimaryPart.Anchored = true;
                                    end;
                                end;
                            end;

                            u500();
                        end;
                    end;
                end);
                u505:Play();
            end;

            local function u524() -- Line: 2190
                -- upvalues: u494 (ref), u493 (copy), u7 (ref), Alchemy (ref), u491 (ref), u1 (ref), VisibleMgr (ref), u13 (ref), u492 (copy), GameCfg (ref), u508 (copy)
                if not (not u494 and u493 == u7) then
                    return;
                end;

                local function v511() -- Line: 2199
                    -- upvalues: Alchemy (ref), u491 (ref)
                    local v509 = Alchemy and (type(Alchemy.ResolveStage2CameraCFrame) == "function" and Alchemy.ResolveStage2CameraCFrame());

                    if v509 then
                        return v509;
                    end;

                    local v510 = u491.folder:FindFirstChild("摄像机_2阶段") or u491.folder:FindFirstChild("摄像机_2阶段", true);

                    if not v510 then
                        return nil;
                    end;

                    if v510:IsA("BasePart") then
                        return v510.CFrame;
                    end;

                    if v510:IsA("Model") then
                        return v510:GetPivot();
                    end;

                    if v510:IsA("Attachment") then
                        return v510.WorldCFrame;
                    end;

                    return nil;
                end;

                local function v521() -- Line: 2226
                    -- upvalues: u494 (ref), u493 (ref), u7 (ref), u491 (ref), u1 (ref), VisibleMgr (ref), u13 (ref), u492 (ref), GameCfg (ref), u508 (ref)
                    if not (not u494 and u493 == u7) then
                        return;
                    end;

                    local v512 = u491.folder:FindFirstChild("石臼") or u491.folder:FindFirstChild("石臼", true);

                    if v512 and v512:IsA("Model") then
                        u1.SetMortarMeshes1Visible(v512, false);
                    end;

                    local function v516() -- Line: 2236
                        -- upvalues: u494 (ref), u493 (ref), u7 (ref), u1 (ref), u491 (ref), VisibleMgr (ref), u13 (ref), u492 (ref)
                        if not (not u494 and u493 == u7) then
                            return;
                        end;

                        local v513 = u1.CollectSolidMaterialModels(u491.folder);

                        for _, v in ipairs(v513) do
                            if v.Parent then
                                VisibleMgr.AnchoredAll(v);
                                VisibleMgr.UnCollideAll(v);
                                local v514 = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart", true);

                                if v514 and v514:IsA("BasePart") then
                                    v514.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                                    v514.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
                                end;
                            end;
                        end;

                        u1.PlayPourMaterialsIntoPot(u491.folder, function() -- Line: 2253
                            -- upvalues: u494 (ref), u493 (ref), u7 (ref), u491 (ref), u1 (ref), u13 (ref), u492 (ref)
                            if not (not u494 and u493 == u7) then
                                return;
                            end;

                            local u515 = u491.folder:FindFirstChild("石臼") or u491.folder:FindFirstChild("石臼", true);

                            if u515 and u515:IsA("Model") then
                                u1.SetMortarMeshes1Visible(u515, false);
                                u1.TweenMortarToHomePose(u515, nil, function() -- Line: 2260
                                    -- upvalues: u494 (ref), u493 (ref), u7 (ref), u1 (ref), u515 (copy), u491 (ref), u13 (ref), u492 (ref)
                                    if not (not u494 and u493 == u7) then
                                        return;
                                    end;

                                    u1.SetMortarMeshes1Visible(u515, false);
                                    u1.ClearSpawnedBowlMaterials(u491.folder);

                                    if not (not u494 and u493 == u7) then
                                        return;
                                    end;

                                    u494 = true;

                                    if u13 then
                                        u13:Disconnect();
                                        u13 = nil;
                                    end;

                                    if u492 then
                                        u492();
                                    end;
                                end);

                                return;
                            end;

                            u1.ClearSpawnedBowlMaterials(u491.folder);

                            if not (not u494 and u493 == u7) then
                                return;
                            end;

                            u494 = true;

                            if u13 then
                                u13:Disconnect();
                                u13 = nil;
                            end;

                            if u492 then
                                u492();
                            end;
                        end, {
                            restoreMortar = false
                        });
                    end;

                    local v517 = GameCfg.POUR_DROP or {};
                    local v518 = tonumber(v517.PourTiltZDeg) or -10;
                    local v519 = tonumber(v517.PourTiltSec) or 0.25;
                    local v520 = math.max(0, v519);

                    if v512 and v512:IsA("Model") then
                        u508(v512, v518, v520, v516);

                        return;
                    end;

                    v516();
                end;

                task.wait();

                if not (not u494 and u493 == u7) then
                    return;
                end;

                local v522 = tonumber((GameCfg.CAMERA_CONFIG or {}).Stage2MoveSec) or 0.85;
                local v523 = v511();
                local CurrentCamera = workspace.CurrentCamera;

                if CurrentCamera then
                    u1.StartCameraDrive(CurrentCamera.CFrame);
                end;

                if v523 then
                    u1.TweenCameraTo(v523, v522);
                end;

                if not (not u494 and u493 == u7) then
                    return;
                end;

                v521();
            end;

            u496();
            local folder = u491.folder;

            if u13 then
                u13:Disconnect();
                u13 = nil;
            end;

            u13 = RunService.Heartbeat:Connect(function() -- Line: 1288
                -- upvalues: folder (copy), u1 (ref)
                local v525 = folder:FindFirstChild("石臼") or folder:FindFirstChild("石臼", true);

                if v525 and v525:IsA("Model") then
                    u1.SetMortarMeshes1Visible(v525, false);
                end;
            end);
            local u526 = u491:CreateModel("石臼");

            if u526 and u526:IsA("Model") then
                u1.CaptureMortarHomePose(u526);
                local u527 = u526:FindFirstChildOfClass("AnimationController") or u526:FindFirstChild("AnimationController", true);

                if u527 then
                    u527 = u527:FindFirstChildOfClass("Animator");
                end;

                if u527 then
                    pcall(function() -- Line: 2317
                        -- upvalues: AnimationModule (ref), u527 (copy)
                        AnimationModule.StopAll(u527);
                    end);
                end;

                u1.RestoreMortarHomePose(u526);
                u1.SetMortarMeshes1Visible(u526, false);
            end;

            u1.StopMaterialFollowMortar();
            local v528 = u1.CollectSolidMaterialModels(u491.folder);
            local u529 = u526 and u526:IsA("Model") and (u526.PrimaryPart or u526:FindFirstChildWhichIsA("BasePart", true));

            if u529 and u529:IsA("BasePart") then
                for _, v in ipairs(v528) do
                    if v.Parent then
                        VisibleMgr.UnAnchoredAll(v);
                        VisibleMgr.UnCollideAll(v);
                        local u530 = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart", true);

                        if u530 and u530:IsA("BasePart") then
                            pcall(function() -- Line: 2337
                                -- upvalues: _makePourWeld (ref), u529 (copy), u530 (copy)
                                _makePourWeld(u529, u530);
                            end);
                        end;
                    end;
                end;
            end;

            if u526 and u526:IsA("Model") then
                u1.RestoreMortarHomePose(u526);
                u1.SetMortarMeshes1Visible(u526, false);
            end;

            task.wait();

            if not (not u494 and u493 == u7) then
                return;
            end;

            u1.StopCameraDrive();
            local u531 = u526 and (u526:FindFirstChild("高光") or u526:FindFirstChild("高光", true));

            if u531 then
                pcall(function() -- Line: 2363
                    -- upvalues: u531 (copy), VisibleMgr (ref)
                    if u531:IsA("BasePart") then
                        u531.Anchored = false;
                    end;

                    VisibleMgr.fadeAllTween(u531, 0);
                end);
            end;

            local POUR_TO_POT_MOON_ANIMS = GameCfg.POUR_TO_POT_MOON_ANIMS;
            local v532 = (type(POUR_TO_POT_MOON_ANIMS) ~= "table" or #POUR_TO_POT_MOON_ANIMS == 0) and { "甩锅入杠4", "甩锅入杠" } or POUR_TO_POT_MOON_ANIMS;
            local v533 = HumanModule.GetCharacter(LocalPlayer);
            local u534 = v533 and { v533 } or nil;

            local function v537(u535) -- Line: 2380
                -- upvalues: u496 (copy), u526 (copy), u1 (ref), AnimationModule (ref), u491 (ref), Log (ref), u534 (copy), u524 (copy)
                if type(u535) ~= "string" or u535 == "" then
                    return false;
                end;

                u496();

                if u526 and u526:IsA("Model") then
                    u1.RestoreMortarHomePose(u526);
                end;

                pcall(function() -- Line: 2389
                    -- upvalues: AnimationModule (ref), u535 (copy), u491 (ref)
                    AnimationModule.ChangeRootFolder(u535, u491.folder, "炼药场景");
                end);
                Log.warn("[GameUtil] 开始倒材料进锅 Moon:", u535);
                local v536 = false;

                if type(AnimationModule.PlayMoonAnimatorWithCameraOffset) == "function" then
                    local success, result = pcall(function() -- Line: 2396
                        -- upvalues: AnimationModule (ref), u535 (copy), u534 (ref), u524 (ref)
                        return AnimationModule.PlayMoonAnimatorWithCameraOffset(u535, u534, u524);
                    end);

                    if success and result == true then
                        v536 = true;
                    elseif not success then
                        Log.warn("[GameUtil] 甩锅入杠（镜头偏移）失败:", result);
                    end;
                end;

                if not v536 and type(AnimationModule.PlayMoonAnimator) == "function" then
                    local success, result = pcall(function() -- Line: 2406
                        -- upvalues: AnimationModule (ref), u535 (copy), u534 (ref), u524 (ref)
                        return AnimationModule.PlayMoonAnimator(u535, u534, u524);
                    end);

                    if success and result == true then
                        return true;
                    end;

                    if not success then
                        Log.warn("[GameUtil] 甩锅入杠回退播放失败:", result);
                    end;
                end;

                return v536;
            end;

            for _, v in ipairs(v532) do
                if v537(v) then
                    task.delay(45, function() -- Line: 2420
                        -- upvalues: u494 (ref), u493 (copy), u7 (ref), Log (ref), v (copy), u524 (copy)
                        if not u494 and u493 == u7 then
                            Log.warn("[GameUtil] 甩锅入杠超时，强制结束:", v);
                            u524();
                        end;
                    end);

                    return;
                end;
            end;

            Log.warn("[GameUtil] 倒材料进锅 Moon 全部失败，改用垂直掉落兜底");
            u524();
        end
    };
end;

return u1;