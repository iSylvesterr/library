-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AnimationModule = UtilsSystem.AnimationModule;
local AssetPaths = UtilsSystem.AssetPaths;
local AssetRegistry = UtilsSystem.AssetRegistry;
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local SkillCommon = require(game.ReplicatedStorage.ClientSideCode.SystemSkill.SkillModule._Templates.SkillCommon);
local u1 = {};
local u2 = { 0.783, 0.932, 1.081, 1.231, 1.38, 1.529, 1.678, 1.827, 1.976, 2.125, 2.274, 2.423, 2.572, 2.721, 2.87, 3.019, 3.168, 3.317, 3.466, 3.617 };
local u3 = {};

local function _cloneSkillModel(p4) -- Line: 70
    -- upvalues: AssetPaths (copy), AssetRegistry (copy)
    local v5 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(AssetRegistry.ModelCategory.Skill, p4));

    if v5 and v5:IsA("Model") then
        return v5:Clone();
    end;

    return nil;
end;

local function _openEmitEnable(p6) -- Line: 78
    -- upvalues: FXUtil (copy)
    FXUtil.EmitBurstEmitInName(p6, true);
    FXUtil.SetEnableNameVfx(p6, true);
    FXUtil.SetEmittersTrailsBeamsEnabled(p6, true);

    return nil;
end;

local function _openStartGroundFx(p7) -- Line: 86
    -- upvalues: FXUtil (copy)
    FXUtil.EmitBurstEmitInName(p7, true);
    FXUtil.SetEnableNameVfx(p7, true);

    return nil;
end;

local function _track(p8, p9) -- Line: 92
    table.insert(p8.spawned, p9);

    return nil;
end;

local function _still(p10) -- Line: 97
    -- upvalues: u3 (copy)
    local v11 = p10.isTokenValid() and u3[p10.token] == p10;

    return v11;
end;

local function _delay(u12, p13, u14) -- Line: 101
    -- upvalues: u3 (copy)
    task.delay(p13, function() -- Line: 102
        -- upvalues: u12 (copy), u3 (ref), u14 (copy)
        local v15 = u12;
        local v16 = v15.isTokenValid() and u3[v15.token] == v15;

        if not v16 then
            return;
        end;

        u14();
    end);

    return nil;
end;

local function _disconnectNamed(p17, p18) -- Line: 111
    local v19 = p17.namedConns[p18];

    if v19 then
        v19:Disconnect();
        p17.namedConns[p18] = nil;
    end;

    return nil;
end;

local function _scheduleEnableOffThenRecycle(u20, u21, p22, p23) -- Line: 120
    -- upvalues: FXUtil (copy), u3 (copy)
    local u24 = p23 or 2;

    local function u25() -- Line: 127
        -- upvalues: u21 (copy), FXUtil (ref), u24 (copy)
        if not u21.Parent then
            return;
        end;

        FXUtil.OffEnableVfx(u21);
        task.delay(u24, function() -- Line: 132
            -- upvalues: u21 (ref)
            if u21.Parent then
                u21:Destroy();
            end;
        end);
    end;

    task.delay(p22, function() -- Line: 102
        -- upvalues: u20 (copy), u3 (ref), u25 (copy)
        local v26 = u20;
        local v27 = v26.isTokenValid() and u3[v26.token] == v26;

        if not v27 then
            return;
        end;

        u25();
    end);

    return nil;
end;

local function _sampleDomainGroundPos(p28, p29, p30, p31, p32) -- Line: 141
    -- upvalues: SkillCommon (copy)
    local v33 = (p30:NextNumber() * 2 - 1) * p29;
    local v34 = (p30:NextNumber() * 2 - 1) * p29;
    local v35 = p28 + Vector3.new(v33, p31, v34);

    return SkillCommon.getGroundCF(CFrame.new(v35), p31, p32, "Ground").Position;
end;

local function _firePresentationDone(p36, p37) -- Line: 154
    if p36.presentationDone then
        return nil;
    end;

    p36.presentationDone = true;

    if p37.onPresentationDone then
        p37.onPresentationDone();
    end;

    return nil;
end;

function u1.Stop(p38) -- Line: 165
    -- upvalues: u3 (copy), AnimationModule (copy)
    local v39 = u3[p38];

    if not v39 then
        return nil;
    end;

    u3[p38] = nil;

    for _, v in pairs(v39.namedConns) do
        v:Disconnect();
    end;

    table.clear(v39.namedConns);

    for _, v in ipairs(v39.conns) do
        v:Disconnect();
    end;

    table.clear(v39.conns);

    for _, v in ipairs(v39.spawned) do
        if v.Parent then
            v:Destroy();
        end;
    end;

    table.clear(v39.spawned);
    AnimationModule.StopAnimByModel(v39.character, "技能释放动作4", 0.05);

    return nil;
end;

function u1.Play(u40) -- Line: 189
    -- upvalues: u1 (copy), u3 (copy), AnimationModule (copy), SkillCommon (copy), AssetPaths (copy), AssetRegistry (copy), RunService (copy), VisibleMgr (copy), FXUtil (copy), _sampleDomainGroundPos (copy), u2 (copy)
    local character = u40.character;
    local goalCF = u40.goalCF;
    local token = u40.token;
    local isTokenValid = u40.isTokenValid;

    if not (character and (goalCF and isTokenValid)) then
        return false;
    end;

    u1.Stop(token);
    local u41 = {
        presentationDone = false,
        token = token,
        character = character,
        spawned = {},
        conns = {},
        namedConns = {},
        isTokenValid = isTokenValid
    };
    u3[token] = u41;
    local Position = goalCF.Position;
    local u42 = Position - Vector3.new(0, 15, 0);
    local LookVector = goalCF.LookVector;
    local v43 = Vector3.new(LookVector.X, 0, LookVector.Z);
    local Rotation = CFrame.lookAt(u42, u42 + (v43.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v43.Unit), Vector3.new(0, 1, 0)).Rotation;
    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");
    AnimationModule.PlayAnimByModel(character, "技能释放动作4", 1, nil, nil, Enum.AnimationPriority.Action4, 0.1);
    local u44 = SkillCommon.resolveWandTipFromCharacter(character);
    local v45 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(AssetRegistry.ModelCategory.Skill, "毒系尾迹"));
    local u46;

    if v45 and v45:IsA("Model") then
        u46 = v45:Clone();
    else
        u46 = nil;
    end;

    if u46 then
        table.insert(u41.spawned, u46);

        local function u52() -- Line: 240
            -- upvalues: SkillCommon (ref), character (copy), u44 (copy), u46 (copy), RunService (ref), u41 (copy), u3 (ref)
            if not (SkillCommon.resolveWandTipFromCharacter(character) or u44) then
                return;
            end;

            for _, descendant in pairs(u46:GetDescendants()) do
                if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = true;
                end;
            end;

            u46.Parent = workspace.Debris;
            local v51 = RunService.RenderStepped:Connect(function() -- Line: 251
                -- upvalues: u41 (ref), u3 (ref), u46 (ref), SkillCommon (ref), character (ref)
                local v47 = u41;
                local v48 = v47.isTokenValid() and u3[v47.token] == v47;

                if not (v48 and u46.Parent) then
                    return;
                end;

                local v49 = SkillCommon.resolveWandTipFromCharacter(character);
                local v50 = SkillCommon.resolveWandTipWorldCFrame(v49);

                if v50 then
                    u46:PivotTo(v50);
                end;
            end);
            u41.namedConns.trailFollow = v51;
        end;

        task.delay(0.23, function() -- Line: 102
            -- upvalues: u41 (copy), u3 (ref), u52 (copy)
            local v53 = u41;
            local v54 = v53.isTokenValid() and u3[v53.token] == v53;

            if not v54 then
                return;
            end;

            u52();
        end);

        local function u56() -- Line: 263
            -- upvalues: u41 (copy), u46 (copy)
            local v55 = u41;
            local trailFollow = v55.namedConns.trailFollow;

            if trailFollow then
                trailFollow:Disconnect();
                v55.namedConns.trailFollow = nil;
            end;

            if u46.Parent then
                for _, descendant in pairs(u46:GetDescendants()) do
                    if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = false;
                    end;
                end;
            end;
        end;

        task.delay(0.9, function() -- Line: 102
            -- upvalues: u41 (copy), u3 (ref), u56 (copy)
            local v57 = u41;
            local v58 = v57.isTokenValid() and u3[v57.token] == v57;

            if not v58 then
                return;
            end;

            u56();
        end);
    end;

    local v59 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(AssetRegistry.ModelCategory.Skill, "巫毒领域_法阵"));
    local u60;

    if v59 and v59:IsA("Model") then
        u60 = v59:Clone();
    else
        u60 = nil;
    end;

    if u60 then
        u60:ScaleTo(1);
        VisibleMgr.UnQueryAll(u60);

        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
            local Rotation2 = u60:GetPivot().Rotation;
            local v61 = HumanoidRootPart.CFrame.Rotation:Inverse() * Rotation2;
            local v62 = HumanoidRootPart.Position - Vector3.new(0, 2.5, 0);
            local LookVector2 = HumanoidRootPart.CFrame.LookVector;
            local v63 = Vector3.new(LookVector2.X, 0, LookVector2.Z);

            if v63.Magnitude > 0.05 then
                u60:PivotTo(CFrame.lookAt(v62, v62 + v63.Unit) * v61);
            else
                u60:PivotTo(CFrame.new(v62) * v61);
            end;
        else
            u60:PivotTo(CFrame.new(Position - Vector3.new(0, 2.5, 0)) * Rotation);
        end;

        u60.Parent = workspace.Debris;
        table.insert(u41.spawned, u60);

        local function u65() -- Line: 298
            -- upvalues: u60 (copy), FXUtil (ref), SkillCommon (ref)
            local v64 = u60;
            FXUtil.EmitBurstEmitInName(v64, true);
            FXUtil.SetEnableNameVfx(v64, true);
            FXUtil.SetEmittersTrailsBeamsEnabled(v64, true);
            SkillCommon.playSoundLocal3D("音效-技能-毒气弹-法阵", u60:GetPivot().Position);
        end;

        task.delay(0.717, function() -- Line: 102
            -- upvalues: u41 (copy), u3 (ref), u65 (copy)
            local v66 = u41;
            local v67 = v66.isTokenValid() and u3[v66.token] == v66;

            if not v67 then
                return;
            end;

            u65();
        end);
        local u68 = 2;

        local function u69() -- Line: 127
            -- upvalues: u60 (copy), FXUtil (ref), u68 (copy)
            if not u60.Parent then
                return;
            end;

            FXUtil.OffEnableVfx(u60);
            task.delay(u68, function() -- Line: 132
                -- upvalues: u60 (ref)
                if u60.Parent then
                    u60:Destroy();
                end;
            end);
        end;

        task.delay(1.85, function() -- Line: 102
            -- upvalues: u41 (copy), u3 (ref), u69 (copy)
            local v70 = u41;
            local v71 = v70.isTokenValid() and u3[v70.token] == v70;

            if not v71 then
                return;
            end;

            u69();
        end);
    end;

    local v72 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(AssetRegistry.ModelCategory.Skill, "巫毒领域_法杖"));
    local u73;

    if v72 and v72:IsA("Model") then
        u73 = v72:Clone();
    else
        u73 = nil;
    end;

    if u73 then
        u73:ScaleTo(1);
        VisibleMgr.UnQueryAll(u73);
        u73.Parent = workspace.Debris;
        table.insert(u41.spawned, u73);

        local function u81() -- Line: 312
            -- upvalues: SkillCommon (ref), u73 (copy), FXUtil (ref), character (copy), u41 (copy), RunService (ref), u3 (ref)
            local v74 = SkillCommon.findDescendantByName(u73, "Enabled_普攻") or u73;
            FXUtil.EmitBurstEmitInName(v74, true);
            FXUtil.SetEnableNameVfx(v74, true);
            FXUtil.SetEmittersTrailsBeamsEnabled(v74, true);
            FXUtil.SetEnableNameVfx(u73, true);
            FXUtil.SetEmittersTrailsBeamsEnabled(u73, true);

            local function pivotStaffToWandTip() -- Line: 318
                -- upvalues: SkillCommon (ref), character (ref), u73 (ref)
                local v75 = SkillCommon.resolveWandTipFromCharacter(character);

                if v75 then
                    v75 = SkillCommon.resolveWandTipWorldCFrame(v75);
                end;

                if v75 and u73.Parent then
                    SkillCommon.pivotInstanceToWorldCF(u73, v75);
                end;
            end;

            local v76 = SkillCommon.resolveWandTipFromCharacter(character);

            if v76 then
                v76 = SkillCommon.resolveWandTipWorldCFrame(v76);
            end;

            if v76 and u73.Parent then
                SkillCommon.pivotInstanceToWorldCF(u73, v76);
            end;

            local v77 = u41;
            local staffFollow = v77.namedConns.staffFollow;

            if staffFollow then
                staffFollow:Disconnect();
                v77.namedConns.staffFollow = nil;
            end;

            u41.namedConns.staffFollow = RunService.RenderStepped:Connect(function() -- Line: 328
                -- upvalues: u41 (ref), u3 (ref), u73 (ref), SkillCommon (ref), character (ref)
                local v78 = u41;
                local v79 = v78.isTokenValid() and u3[v78.token] == v78;

                if not (v79 and u73.Parent) then
                    return;
                end;

                local v80 = SkillCommon.resolveWandTipFromCharacter(character);

                if v80 then
                    v80 = SkillCommon.resolveWandTipWorldCFrame(v80);
                end;

                if v80 and u73.Parent then
                    SkillCommon.pivotInstanceToWorldCF(u73, v80);
                end;
            end);
        end;

        task.delay(0.683, function() -- Line: 102
            -- upvalues: u41 (copy), u3 (ref), u81 (copy)
            local v82 = u41;
            local v83 = v82.isTokenValid() and u3[v82.token] == v82;

            if not v83 then
                return;
            end;

            u81();
        end);

        local function u85() -- Line: 337
            -- upvalues: u41 (copy), FXUtil (ref), u73 (copy)
            local v84 = u41;
            local staffFollow = v84.namedConns.staffFollow;

            if staffFollow then
                staffFollow:Disconnect();
                v84.namedConns.staffFollow = nil;
            end;

            FXUtil.OffEnableVfx(u73);
            task.delay(2, function() -- Line: 340
                -- upvalues: u73 (ref)
                if u73.Parent then
                    u73:Destroy();
                end;
            end);
        end;

        task.delay(0.75, function() -- Line: 102
            -- upvalues: u41 (copy), u3 (ref), u85 (copy)
            local v86 = u41;
            local v87 = v86.isTokenValid() and u3[v86.token] == v86;

            if not v87 then
                return;
            end;

            u85();
        end);
    end;

    local function u88() -- Line: 348
        -- upvalues: u40 (copy)
        if u40.onCastDone then
            u40.onCastDone();
        end;
    end;

    task.delay(0.75, function() -- Line: 102
        -- upvalues: u41 (copy), u3 (ref), u88 (copy)
        local v89 = u41;
        local v90 = v89.isTokenValid() and u3[v89.token] == v89;

        if not v90 then
            return;
        end;

        u88();
    end);
    local v91 = Random.new(token + 109004);
    local u92 = {};

    for _ = 1, 20 do
        local v93 = _sampleDomainGroundPos(Position, 37.5, v91, 4, 0.5);
        table.insert(u92, v93);
    end;

    local function u101() -- Line: 364
        -- upvalues: AssetPaths (ref), AssetRegistry (ref), VisibleMgr (ref), SkillCommon (ref), Position (copy), Rotation (copy), u41 (copy), FXUtil (ref), u3 (ref)
        local v94 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(AssetRegistry.ModelCategory.Skill, "巫毒领域_起手地面特效"));
        local u95;

        if v94 and v94:IsA("Model") then
            u95 = v94:Clone();
        else
            u95 = nil;
        end;

        if not u95 then
            return;
        end;

        u95:ScaleTo(1);
        VisibleMgr.UnQueryAll(u95);
        SkillCommon.pivotInstanceToWorldCF(u95, CFrame.new(Position) * Rotation);
        u95.Parent = workspace.Debris;
        table.insert(u41.spawned, u95);
        FXUtil.EmitBurstEmitInName(u95, true);
        FXUtil.SetEnableNameVfx(u95, true);
        local u96 = u41;
        local u97 = 2;

        local function u98() -- Line: 127
            -- upvalues: u95 (copy), FXUtil (ref), u97 (copy)
            if not u95.Parent then
                return;
            end;

            FXUtil.OffEnableVfx(u95);
            task.delay(u97, function() -- Line: 132
                -- upvalues: u95 (ref)
                if u95.Parent then
                    u95:Destroy();
                end;
            end);
        end;

        task.delay(3.767, function() -- Line: 102
            -- upvalues: u96 (copy), u3 (ref), u98 (copy)
            local v99 = u96;
            local v100 = v99.isTokenValid() and u3[v99.token] == v99;

            if not v100 then
                return;
            end;

            u98();
        end);
    end;

    task.delay(1, function() -- Line: 102
        -- upvalues: u41 (copy), u3 (ref), u101 (copy)
        local v102 = u41;
        local v103 = v102.isTokenValid() and u3[v102.token] == v102;

        if not v103 then
            return;
        end;

        u101();
    end);

    local function u137() -- Line: 378
        -- upvalues: AssetPaths (ref), AssetRegistry (ref), VisibleMgr (ref), u42 (copy), Rotation (copy), u41 (copy), FXUtil (ref), RunService (ref), u3 (ref), Position (copy), SkillCommon (ref)
        local v104 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(AssetRegistry.ModelCategory.Skill, "巫毒领域_球形领域"));
        local u105;

        if v104 and v104:IsA("Model") then
            u105 = v104:Clone();
        else
            u105 = nil;
        end;

        local v106 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(AssetRegistry.ModelCategory.Skill, "巫毒领域_地面领域"));
        local u107;

        if v106 and v106:IsA("Model") then
            u107 = v106:Clone();
        else
            u107 = nil;
        end;

        if u105 then
            u105:ScaleTo(1);
            VisibleMgr.UnQueryAll(u105);
            u105:PivotTo(CFrame.new(u42) * Rotation);
            u105.Parent = workspace.Debris;
            table.insert(u41.spawned, u105);
            u105:SetAttribute("ModelScale", 1);
            u105:SetAttribute("Scale", 0.01);
            FXUtil.Set_Scale_Model(u105, 0.01);
            local u108 = u105:FindFirstChild("主节点");
            local u109;

            if u108 and (u108:IsA("Model") or u108:IsA("BasePart")) then
                local v110 = u105:GetPivot();
                local v111;

                if u108:IsA("Model") then
                    v111 = u108:GetPivot();
                else
                    v111 = u108:GetPivot();
                end;

                u109 = v110:ToObjectSpace(v111);
            else
                u109 = nil;
            end;

            local u112 = 0;
            local u113 = 0;

            if u108 and u109 then
                local v114 = u41;
                local mainNodeSpin = v114.namedConns.mainNodeSpin;

                if mainNodeSpin then
                    mainNodeSpin:Disconnect();
                    v114.namedConns.mainNodeSpin = nil;
                end;

                u41.namedConns.mainNodeSpin = RunService.Heartbeat:Connect(function(p115) -- Line: 403
                    -- upvalues: u41 (ref), u3 (ref), u105 (copy), u108 (copy), u113 (ref), u112 (ref), u109 (ref)
                    local v116 = u41;
                    local v117 = v116.isTokenValid() and u3[v116.token] == v116;

                    if not (v117 and (u105.Parent and u108.Parent)) then
                        return;
                    end;

                    u113 = u113 + p115;
                    u112 = u112 + (u113 < 3.784 and 1 or 1 - math.clamp((u113 - 3.784) / 0.4, 0, 1)) * 5 * p115;
                    local v118 = u105:GetPivot() * u109 * CFrame.Angles(0, math.rad(u112), 0);

                    if u108:IsA("Model") then
                        u108:PivotTo(v118);

                        return;
                    end;

                    if u108:IsA("BasePart") then
                        u108:PivotTo(v118);
                    end;
                end);
            end;

            local u119 = u41;

            local function u120() -- Line: 422
                -- upvalues: u105 (copy), FXUtil (ref)
                if u105.Parent then
                    FXUtil.Instance_Transparency_Tween(u105, 0.4, 1, Enum.EasingStyle.Linear, Enum.EasingDirection.In);
                end;
            end;

            task.delay(3.784, function() -- Line: 102
                -- upvalues: u119 (copy), u3 (ref), u120 (copy)
                local v121 = u119;
                local v122 = v121.isTokenValid() and u3[v121.token] == v121;

                if not v122 then
                    return;
                end;

                u120();
            end);
            local u123 = u41;

            local function u125() -- Line: 427
                -- upvalues: u41 (ref), u105 (copy)
                local v124 = u41;
                local mainNodeSpin = v124.namedConns.mainNodeSpin;

                if mainNodeSpin then
                    mainNodeSpin:Disconnect();
                    v124.namedConns.mainNodeSpin = nil;
                end;

                if u105.Parent then
                    u105:Destroy();
                end;
            end;

            task.delay(4.184, function() -- Line: 102
                -- upvalues: u123 (copy), u3 (ref), u125 (copy)
                local v126 = u123;
                local v127 = v126.isTokenValid() and u3[v126.token] == v126;

                if not v127 then
                    return;
                end;

                u125();
            end);
        end;

        if u107 then
            u107:ScaleTo(1);
            VisibleMgr.UnQueryAll(u107);
            u107:PivotTo(CFrame.new(Position) * Rotation);
            u107.Parent = workspace.Debris;
            table.insert(u41.spawned, u107);
            u107:SetAttribute("ModelScale", 1);
            u107:SetAttribute("Scale", 0.01);
            FXUtil.Set_Scale_Model(u107, 0.01);
            FXUtil.EmitBurstEmitInName(u107, true);
            FXUtil.SetEnableNameVfx(u107, true);
            FXUtil.SetEmittersTrailsBeamsEnabled(u107, true);
            local u128 = u41;
            local u129 = 2;

            local function u130() -- Line: 127
                -- upvalues: u107 (copy), FXUtil (ref), u129 (copy)
                if not u107.Parent then
                    return;
                end;

                FXUtil.OffEnableVfx(u107);
                task.delay(u129, function() -- Line: 132
                    -- upvalues: u107 (ref)
                    if u107.Parent then
                        u107:Destroy();
                    end;
                end);
            end;

            task.delay(3.784, function() -- Line: 102
                -- upvalues: u128 (copy), u3 (ref), u130 (copy)
                local v131 = u128;
                local v132 = v131.isTokenValid() and u3[v131.token] == v131;

                if not v132 then
                    return;
                end;

                u130();
            end);
        end;

        local u133 = u41;

        local function u134() -- Line: 448
            -- upvalues: u105 (copy), FXUtil (ref), SkillCommon (ref), u42 (ref), u107 (copy)
            if u105 and u105.Parent then
                FXUtil.Set_Scale_Model_Tween(u105, 0.767, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                SkillCommon.playSoundLocal3D("音效-技能-巫毒领域-攻击", u42);
            end;

            if u107 and u107.Parent then
                FXUtil.Set_Scale_Model_Tween(u107, 0.767, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            end;
        end;

        task.delay(0.017, function() -- Line: 102
            -- upvalues: u133 (copy), u3 (ref), u134 (copy)
            local v135 = u133;
            local v136 = v135.isTokenValid() and u3[v135.token] == v135;

            if not v136 then
                return;
            end;

            u134();
        end);
    end;

    task.delay(0.983, function() -- Line: 102
        -- upvalues: u41 (copy), u3 (ref), u137 (copy)
        local v138 = u41;
        local v139 = v138.isTokenValid() and u3[v138.token] == v138;

        if not v139 then
            return;
        end;

        u137();
    end);

    local function u147() -- Line: 459
        -- upvalues: AssetPaths (ref), AssetRegistry (ref), VisibleMgr (ref), SkillCommon (ref), u42 (copy), Rotation (copy), u41 (copy), FXUtil (ref), u3 (ref)
        local v140 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(AssetRegistry.ModelCategory.Skill, "巫毒领域_领域展开后开启"));
        local u141;

        if v140 and v140:IsA("Model") then
            u141 = v140:Clone();
        else
            u141 = nil;
        end;

        if not u141 then
            return;
        end;

        u141:ScaleTo(1);
        VisibleMgr.UnQueryAll(u141);
        SkillCommon.pivotInstanceToWorldCF(u141, CFrame.new(u42) * Rotation);
        u141.Parent = workspace.Debris;
        table.insert(u41.spawned, u141);
        FXUtil.EmitBurstEmitInName(u141, true);
        FXUtil.SetEnableNameVfx(u141, true);
        FXUtil.SetEmittersTrailsBeamsEnabled(u141, true);
        local u142 = u41;
        local u143 = 3.5;

        local function u144() -- Line: 127
            -- upvalues: u141 (copy), FXUtil (ref), u143 (copy)
            if not u141.Parent then
                return;
            end;

            FXUtil.OffEnableVfx(u141);
            task.delay(u143, function() -- Line: 132
                -- upvalues: u141 (ref)
                if u141.Parent then
                    u141:Destroy();
                end;
            end);
        end;

        task.delay(4.317, function() -- Line: 102
            -- upvalues: u142 (copy), u3 (ref), u144 (copy)
            local v145 = u142;
            local v146 = v145.isTokenValid() and u3[v145.token] == v145;

            if not v146 then
                return;
            end;

            u144();
        end);
    end;

    task.delay(1.45, function() -- Line: 102
        -- upvalues: u41 (copy), u3 (ref), u147 (copy)
        local v148 = u41;
        local v149 = v148.isTokenValid() and u3[v148.token] == v148;

        if not v149 then
            return;
        end;

        u147();
    end);

    for i, v in u2 do
        local function u153() -- Line: 474
            -- upvalues: AssetPaths (ref), AssetRegistry (ref), VisibleMgr (ref), u92 (copy), i (copy), Position (copy), u41 (copy), FXUtil (ref)
            local v150 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(AssetRegistry.ModelCategory.Skill, "巫毒领域_领域展开地面毒特效"));
            local u151;

            if v150 and v150:IsA("Model") then
                u151 = v150:Clone();
            else
                u151 = nil;
            end;

            if not u151 then
                return;
            end;

            u151:ScaleTo(1);
            VisibleMgr.UnQueryAll(u151);
            local v152 = u92[i] or Position;
            local Rotation2 = u151:GetPivot().Rotation;
            u151:PivotTo(CFrame.new(v152) * Rotation2);
            u151.Parent = workspace.Debris;
            table.insert(u41.spawned, u151);
            FXUtil.EmitBurstEmitInName(u151, true);
            task.delay(2, function() -- Line: 488
                -- upvalues: u151 (copy)
                if u151.Parent then
                    u151:Destroy();
                end;
            end);
        end;

        task.delay(0.75 + v, function() -- Line: 102
            -- upvalues: u41 (copy), u3 (ref), u153 (copy)
            local v154 = u41;
            local v155 = v154.isTokenValid() and u3[v154.token] == v154;

            if not v155 then
                return;
            end;

            u153();
        end);
    end;

    local function u158() -- Line: 496
        -- upvalues: u3 (ref), token (copy), u41 (copy), u40 (copy)
        if u3[token] == u41 then
            u3[token] = nil;
        end;

        local v156 = u41;
        local v157 = u40;

        if v156.presentationDone then
            return;
        end;

        v156.presentationDone = true;

        if v157.onPresentationDone then
            v157.onPresentationDone();
        end;
    end;

    task.delay(9.35, function() -- Line: 102
        -- upvalues: u41 (copy), u3 (ref), u158 (copy)
        local v159 = u41;
        local v160 = v159.isTokenValid() and u3[v159.token] == v159;

        if not v160 then
            return;
        end;

        u158();
    end);

    local function u161() -- Line: 504
    end;

    task.delay(2.32, function() -- Line: 102
        -- upvalues: u41 (copy), u3 (ref), u161 (copy)
        local v162 = u41;
        local v163 = v162.isTokenValid() and u3[v162.token] == v162;

        if not v163 then
            return;
        end;

        u161();
    end);

    return true;
end;

return u1;