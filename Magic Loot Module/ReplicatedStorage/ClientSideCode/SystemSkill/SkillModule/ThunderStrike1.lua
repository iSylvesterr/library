-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local RunService = UtilsSystem.RunService;
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local PlayerAimSync = require(script.Parent.Parent.BaseSkill.PlayerAimSync);

local function resolveStrikeIntent(p1) -- Line: 37
    -- upvalues: SkillCommon (copy)
    SkillCommon.refreshSkillAimSnapshot(p1);
    local skillInputData = p1.skillInputData;

    if skillInputData then
        skillInputData = SkillCommon.resolveTrackTargetHrp(skillInputData);
    end;

    if skillInputData then
        return skillInputData.Position;
    end;

    return p1:getTargetCF().Position;
end;

local function resolveStrikeAnchorPos(p2, p3) -- Line: 50
    -- upvalues: SkillCommon (copy)
    SkillCommon.refreshSkillAimSnapshot(p2);
    local skillInputData = p2.skillInputData;

    if skillInputData then
        skillInputData = SkillCommon.resolveTrackTargetHrp(skillInputData);
    end;

    local v4;

    if skillInputData then
        v4 = skillInputData.Position;
    else
        v4 = p2:getTargetCF().Position;
    end;

    return SkillCommon.resolveStrikeAnchorPosThroughFriendly(p2.skillInputData, v4, {
        extraIgnore = p3,
        casterId = p2.characterId,
        casterType = p2.characterType
    });
end;

local function disconnectRunEvent(p5, p6) -- Line: 62
    local v7;

    if p5 then
        v7 = p5.runEvent[p6];
    else
        v7 = p5;
    end;

    if v7 then
        v7:Disconnect();
        p5.runEvent[p6] = nil;
    end;
end;

local function pivotHitRootToStrike(p8, p9, p10) -- Line: 70
    -- upvalues: SkillCommon (copy)
    local v11 = p10 and p10:IsA("Folder") and { p10 } or nil;
    SkillCommon.refreshSkillAimSnapshot(p8);
    local skillInputData = p8.skillInputData;

    if skillInputData then
        skillInputData = SkillCommon.resolveTrackTargetHrp(skillInputData);
    end;

    local v12;

    if skillInputData then
        v12 = skillInputData.Position;
    else
        v12 = p8:getTargetCF().Position;
    end;

    local v13 = SkillCommon.resolveStrikeAnchorPosThroughFriendly(p8.skillInputData, v12, {
        extraIgnore = v11,
        casterId = p8.characterId,
        casterType = p8.characterType
    });
    SkillCommon.pivotInstanceToWorldCF(p9, CFrame.new(v13));
end;

local function connectStrikeFollow(u14, u15, u16, u17, u18) -- Line: 76
    -- upvalues: PlayerAimSync (copy), pivotHitRootToStrike (copy), RunService (copy), SkillCommon (copy)
    if not PlayerAimSync.isAutoAimActiveForSkill(u14) then
        pivotHitRootToStrike(u14, u17, u18);

        return;
    end;

    pivotHitRootToStrike(u14, u17, u18);
    local v23 = RunService.RenderStepped:Connect(function() -- Line: 88
        -- upvalues: SkillCommon (ref), u14 (copy), u16 (copy), u15 (copy), u17 (copy), pivotHitRootToStrike (ref), u18 (copy)
        if not SkillCommon.isRunningSameGeneration(u14, u16) then
            local v19 = u15;
            local v20;

            if v19 then
                v20 = v19.runEvent["雷击术跟落点"];
            else
                v20 = v19;
            end;

            if v20 then
                v20:Disconnect();
                v19.runEvent["雷击术跟落点"] = nil;
            end;

            return;
        end;

        if u17.Parent then
            pivotHitRootToStrike(u14, u17, u18);

            return;
        end;

        local v21 = u15;
        local v22;

        if v21 then
            v22 = v21.runEvent["雷击术跟落点"];
        else
            v22 = v21;
        end;

        if v22 then
            v22:Disconnect();
            v21.runEvent["雷击术跟落点"] = nil;
        end;
    end);
    u15.runEvent["雷击术跟落点"] = v23;
end;

return {
    skillTotalTime = -1,
    visualFadeoutTime = 2.5,
    skillElementType = ElementTp.Thunder,
    skillDistanceLimit = 55,
    InitialState = "Startup",
    ControlOpenState = "Strike",
    States = {
        Startup = {
            Duration = 0.563,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = "Client_ExitStartup"
        },
        Strike = {
            Duration = 1.107,
            OnEnterClient = "Client_EnterStrike",
            OnEnterServer = "Server_EnterStrike",
            OnExitClient = "Client_ExitStrike"
        },
        Recovery = {
            Duration = 0.2,
            OnEnterClient = "Client_EnterRecovery",
            OnEnterServer = "Server_EnterRecovery"
        },
        Finished = {
            Duration = 0,
            IsTerminal = true
        },
        Interrupted = {
            Duration = 0,
            IsTerminal = true
        }
    },
    Transitions = {
        {
            From = "Startup",
            To = "Strike",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Strike",
            To = "Recovery",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Recovery",
            To = "Finished",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Startup",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Strike",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Recovery",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Startup",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "Strike",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "Recovery",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        }
    },

    Client_EnterStartup = function(u24) -- Line: 146, Name: Client_EnterStartup
        -- upvalues: SkillCommon (copy), VisibleMgr (copy), connectStrikeFollow (copy), RunService (copy)
        local skillInputData = u24.skillInputData;
        local v25;

        if skillInputData then
            v25 = skillInputData.character;
        else
            v25 = skillInputData;
        end;

        if not v25 then
            return;
        end;

        local u26 = SkillCommon.resolveWandTipFromCharacter(v25);

        if u26 then
            SkillCommon.scheduleWandTipElementTrail(u24, u26, {
                trailMaterialKey = "雷系尾迹",
                runEventKey = "雷击术Cast尾迹",
                enableAt = 0.2,
                disableAt = 0.6
            });
        end;

        local skillRunData = u24.skillRunData;

        if not (skillRunData and skillRunData.material) then
            return;
        end;

        local u27 = skillRunData.material["雷击术释放"];
        local v28 = skillRunData.material["雷击术被打击"];
        local v29 = skillRunData.material["雷击术闪电"];

        if not (u27 and (v28 and v29)) then
            return;
        end;

        if not (u27:IsA("Model") and (v28:IsA("Model") and v29:IsA("Model"))) then
            return;
        end;

        local runGeneration = u24.runGeneration;
        local v30 = SkillCommon.scaleBandFromData(u24, SkillCommon.bandScaleOptsFromSkillData(u24));
        u27:ScaleTo(v30);
        v28:ScaleTo(v30);
        v29:ScaleTo(v30);
        VisibleMgr.UnQueryAll(u27);
        VisibleMgr.UnQueryAll(v28);
        VisibleMgr.UnQueryAll(v29);
        local characterId = skillInputData.characterId;
        local v31 = {};

        for _, child in workspace.Debris:GetChildren() do
            if child:IsA("Folder") and (child.Name == "ThunderStrikeFx" and child:GetAttribute("ThunderStrikeCaster") == characterId) then
                table.insert(v31, child);
            end;
        end;

        for _, v in v31 do
            v:Destroy();
        end;

        local Folder = Instance.new("Folder");
        Folder.Name = "ThunderStrikeFx";
        Folder:SetAttribute("ThunderStrikeCaster", characterId);
        Folder.Parent = workspace.Debris;
        u27.Parent = Folder;
        v28.Parent = Folder;
        v29.Parent = Folder;
        SkillCommon.appendRunSpawnList(skillRunData, "ThunderStrikeSpawned", Folder);
        connectStrikeFollow(u24, skillRunData, runGeneration, v28, Folder);
        local Attachment_Start = u27:FindFirstChild("Attachment_Start", true);
        local Attachment_End = v28:FindFirstChild("Attachment_End", true);

        if Attachment_Start and (Attachment_End and (Attachment_Start:IsA("Attachment") and Attachment_End:IsA("Attachment"))) then
            for _, descendant in v29:GetDescendants() do
                if descendant:IsA("Beam") then
                    descendant.Attachment0 = Attachment_Start;
                    descendant.Attachment1 = Attachment_End;
                end;
            end;
        end;

        for _, descendant in v29:GetDescendants() do
            if descendant:IsA("Beam") then
                descendant.Enabled = false;
            end;
        end;

        if u26 then
            local function applyCastToWandTip() -- Line: 228
                -- upvalues: SkillCommon (ref), u26 (copy), u27 (copy)
                local v32 = SkillCommon.resolveWandTipWorldCFrame(u26);

                if v32 then
                    u27:PivotTo(v32);
                end;
            end;

            local v33 = SkillCommon.resolveWandTipWorldCFrame(u26);

            if v33 then
                u27:PivotTo(v33);
            end;

            local v39 = RunService.RenderStepped:Connect(function() -- Line: 235
                -- upvalues: SkillCommon (ref), u24 (copy), runGeneration (copy), skillRunData (copy), u27 (copy), u26 (copy)
                if not SkillCommon.isRunningSameGeneration(u24, runGeneration) then
                    local v34 = skillRunData;
                    local v35;

                    if v34 then
                        v35 = v34.runEvent["雷击术跟杖"];
                    else
                        v35 = v34;
                    end;

                    if v35 then
                        v35:Disconnect();
                        v34.runEvent["雷击术跟杖"] = nil;
                    end;

                    return;
                end;

                if u27.Parent and u26.Parent then
                    local v36 = SkillCommon.resolveWandTipWorldCFrame(u26);

                    if v36 then
                        u27:PivotTo(v36);
                    end;

                    return;
                end;

                local v37 = skillRunData;
                local v38;

                if v37 then
                    v38 = v37.runEvent["雷击术跟杖"];
                else
                    v38 = v37;
                end;

                if v38 then
                    v38:Disconnect();
                    v37.runEvent["雷击术跟杖"] = nil;
                end;
            end);
            skillRunData.runEvent["雷击术跟杖"] = v39;
        end;
    end,

    Server_EnterStartup = function(p40) -- Line: 250, Name: Server_EnterStartup
        local v41 = p40.hitbox[1];

        if v41 and v41.hitbox then
            local hitbox = v41.hitbox;

            if hitbox:IsA("BasePart") then
                hitbox.Shape = Enum.PartType.Ball;
            end;

            hitbox.Size = Vector3.new(4, 4, 4);
        end;
    end,

    Client_EnterStrike = function(u42) -- Line: 261, Name: Client_EnterStrike
        -- upvalues: FXUtil (copy), SkillCommon (copy), pivotHitRootToStrike (copy)
        local skillRunData = u42.skillRunData;

        if not (skillRunData and skillRunData.material) then
            return;
        end;

        local u43 = skillRunData.material["雷击术释放"];
        local u44 = skillRunData.material["雷击术被打击"];
        local v45 = skillRunData.material["雷击术闪电"];

        if not (u43 and (u44 and v45)) then
            return;
        end;

        if not (u43:IsA("Model") and (u44:IsA("Model") and v45:IsA("Model"))) then
            return;
        end;

        local runGeneration = u42.runGeneration;
        local Parent = u44.Parent;
        local v46 = u43:FindFirstChild("起手效果_Emit", true);

        if v46 then
            v46 = v46:FindFirstChild("施法", true);
        end;

        local u47 = v45:FindFirstChild("闪电Beam_Enable", true);

        if v46 then
            FXUtil.Emit_Particles_Children(v46, true);
        end;

        local function beamOnOff(u48, p49, p50) -- Line: 292
            -- upvalues: SkillCommon (ref), u42 (copy), runGeneration (copy)
            task.delay(p49, function() -- Line: 293
                -- upvalues: SkillCommon (ref), u42 (ref), runGeneration (ref), u48 (copy)
                if not SkillCommon.isRunningSameGeneration(u42, runGeneration) then
                    return;
                end;

                u48.Enabled = true;
            end);
            task.delay(p50, function() -- Line: 299
                -- upvalues: SkillCommon (ref), u42 (ref), runGeneration (ref), u48 (copy)
                if not SkillCommon.isRunningSameGeneration(u42, runGeneration) then
                    return;
                end;

                u48.Enabled = false;
            end);
        end;

        local function findBeam(p51) -- Line: 306
            -- upvalues: u47 (copy)
            local v52 = u47 and u47:FindFirstChild(p51, true);

            if v52 and v52:IsA("Beam") then
                return v52;
            end;

            return nil;
        end;

        local v53;

        if u47 then
            v53 = u47:FindFirstChild("Lightning_Beam_01", true);
        else
            v53 = u47;
        end;

        if not (v53 and v53:IsA("Beam")) then
            v53 = nil;
        end;

        local v54;

        if u47 then
            v54 = u47:FindFirstChild("Lightning_Beam_02", true);
        else
            v54 = u47;
        end;

        if not (v54 and v54:IsA("Beam")) then
            v54 = nil;
        end;

        local v55;

        if u47 then
            v55 = u47:FindFirstChild("Lightning_Beam_03", true);
        else
            v55 = u47;
        end;

        if not (v55 and v55:IsA("Beam")) then
            v55 = nil;
        end;

        local v56;

        if u47 then
            v56 = u47:FindFirstChild("Lightning_Beam_04", true);
        else
            v56 = u47;
        end;

        if not (v56 and v56:IsA("Beam")) then
            v56 = nil;
        end;

        if u47 then
            u47 = u47:FindFirstChild("Lightning_Beam_05", true);
        end;

        if not (u47 and u47:IsA("Beam")) then
            u47 = nil;
        end;

        if v53 then
            beamOnOff(v53, 0, 0.11666666666666667);
        end;

        if v54 then
            beamOnOff(v54, 0.11666666666666667, 0.21666666666666667);
        end;

        if v55 then
            beamOnOff(v55, 0.05, 0.15);
        end;

        if v56 then
            beamOnOff(v56, 0.1, 0.2);
        end;

        if u47 then
            beamOnOff(u47, 0.16666666666666666, 0.3);
        end;

        task.delay(0.11, function() -- Line: 335
            -- upvalues: SkillCommon (ref), u42 (copy), runGeneration (copy), pivotHitRootToStrike (ref), u44 (copy), Parent (copy), FXUtil (ref), u43 (copy)
            if not SkillCommon.isRunningSameGeneration(u42, runGeneration) then
                return;
            end;

            pivotHitRootToStrike(u42, u44, Parent);
            local v57 = u44:FindFirstChild("被打击点_Emit", true);

            if v57 then
                FXUtil.Emit_Particles_GetDescendants(v57, true);
            end;

            SkillCommon.playSoundLocal3D("音效-技能-雷系普攻", u43:GetPivot().Position);
        end);
        task.delay(0.3, function() -- Line: 347
            -- upvalues: SkillCommon (ref), u42 (copy), runGeneration (copy), skillRunData (copy)
            if not SkillCommon.isRunningSameGeneration(u42, runGeneration) then
                return;
            end;

            local v58 = skillRunData;
            local v59;

            if v58 then
                v59 = v58.runEvent["雷击术跟杖"];
            else
                v59 = v58;
            end;

            if v59 then
                v59:Disconnect();
                v58.runEvent["雷击术跟杖"] = nil;
            end;

            local v60 = skillRunData;
            local v61;

            if v60 then
                v61 = v60.runEvent["雷击术跟落点"];
            else
                v61 = v60;
            end;

            if v61 then
                v61:Disconnect();
                v60.runEvent["雷击术跟落点"] = nil;
            end;
        end);
        SkillCommon.scheduleRunSpawnClear(u42, runGeneration, skillRunData, "ThunderStrikeSpawned", 1.084);
    end,

    Server_EnterStrike = function(u62) -- Line: 358, Name: Server_EnterStrike
        -- upvalues: SkillCommon (copy)
        local u63 = u62.hitbox[1];

        if not u63 then
            return;
        end;

        local runGeneration = u62.runGeneration;
        task.delay(0.11, function() -- Line: 366
            -- upvalues: u62 (copy), runGeneration (copy), SkillCommon (ref), u63 (copy)
            if not u62:isRunningFlow() or u62.runGeneration ~= runGeneration then
                return;
            end;

            local v64 = u62;
            SkillCommon.refreshSkillAimSnapshot(v64);
            local skillInputData = v64.skillInputData;

            if skillInputData then
                skillInputData = SkillCommon.resolveTrackTargetHrp(skillInputData);
            end;

            local v65;

            if skillInputData then
                v65 = skillInputData.Position;
            else
                v65 = v64:getTargetCF().Position;
            end;

            local v66 = SkillCommon.resolveStrikeAnchorPosThroughFriendly(v64.skillInputData, v65, {
                extraIgnore = nil,
                casterId = v64.characterId,
                casterType = v64.characterType
            });
            local v67 = 4 * SkillCommon.scaleBandFromData(u62, SkillCommon.bandScaleOptsFromSkillData(u62));
            local hitbox = u63.hitbox;

            if hitbox:IsA("BasePart") then
                hitbox.Shape = Enum.PartType.Ball;
            end;

            hitbox.Size = Vector3.new(v67, v67, v67);
            hitbox:PivotTo(CFrame.new(v66));
            u63:start();
            task.delay(0.12, function() -- Line: 381
                -- upvalues: u62 (ref), runGeneration (ref), u63 (ref), hitbox (copy)
                if not u62:isRunningFlow() or u62.runGeneration ~= runGeneration then
                    return;
                end;

                if u63.isActive then
                    u63:stop();
                    hitbox.Transparency = 1;
                end;
            end);
        end);
    end,

    Server_EnterRecovery = function(p68) -- Line: 393, Name: Server_EnterRecovery
        p68:releaseControl();
    end,

    Client_ExitStartup = function(u69) -- Line: 397, Name: Client_ExitStartup
        -- upvalues: SkillCommon (copy)
        local skillRunData = u69.skillRunData;

        if not skillRunData then
            return;
        end;

        local runGeneration = u69.runGeneration;
        SkillCommon.clearSpawnIfTerminalAfterExit(u69, runGeneration, skillRunData, "ThunderStrikeSpawned");
        task.defer(function() -- Line: 404
            -- upvalues: u69 (copy), runGeneration (copy), skillRunData (copy)
            if u69.runGeneration ~= runGeneration or not skillRunData then
                return;
            end;

            if u69:isTerminal() then
                local v70 = skillRunData;
                local v71;

                if v70 then
                    v71 = v70.runEvent["雷击术跟杖"];
                else
                    v71 = v70;
                end;

                if v71 then
                    v71:Disconnect();
                    v70.runEvent["雷击术跟杖"] = nil;
                end;

                local v72 = skillRunData;
                local v73;

                if v72 then
                    v73 = v72.runEvent["雷击术跟落点"];
                else
                    v73 = v72;
                end;

                if v73 then
                    v73:Disconnect();
                    v72.runEvent["雷击术跟落点"] = nil;
                end;
            end;
        end);
    end,

    Client_ExitStrike = function(p74) -- Line: 415, Name: Client_ExitStrike
        -- upvalues: SkillCommon (copy)
        local skillRunData = p74.skillRunData;

        if skillRunData then
            local v75;

            if skillRunData then
                v75 = skillRunData.runEvent["雷击术跟杖"];
            else
                v75 = skillRunData;
            end;

            if v75 then
                v75:Disconnect();
                skillRunData.runEvent["雷击术跟杖"] = nil;
            end;

            local v76;

            if skillRunData then
                v76 = skillRunData.runEvent["雷击术跟落点"];
            else
                v76 = skillRunData;
            end;

            if v76 then
                v76:Disconnect();
                skillRunData.runEvent["雷击术跟落点"] = nil;
            end;

            SkillCommon.clearSpawnIfTerminalAfterExit(p74, p74.runGeneration, skillRunData, "ThunderStrikeSpawned");
        end;
    end,

    Client_EnterRecovery = function(p77) -- Line: 424, Name: Client_EnterRecovery
        -- upvalues: SkillCommon (copy)
        local skillRunData = p77.skillRunData;

        if skillRunData then
            local v78;

            if skillRunData then
                v78 = skillRunData.runEvent["雷击术跟杖"];
            else
                v78 = skillRunData;
            end;

            if v78 then
                v78:Disconnect();
                skillRunData.runEvent["雷击术跟杖"] = nil;
            end;

            local v79;

            if skillRunData then
                v79 = skillRunData.runEvent["雷击术跟落点"];
            else
                v79 = skillRunData;
            end;

            if v79 then
                v79:Disconnect();
                skillRunData.runEvent["雷击术跟落点"] = nil;
            end;
        end;

        if skillRunData and skillRunData.material then
            SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "雷系尾迹", "雷击术Cast尾迹");
        end;
    end,

    onEnd = function(p80) -- Line: 435, Name: onEnd
        local skillRunData = p80.skillRunData;

        if skillRunData then
            local v81;

            if skillRunData then
                v81 = skillRunData.runEvent["雷击术跟杖"];
            else
                v81 = skillRunData;
            end;

            if v81 then
                v81:Disconnect();
                skillRunData.runEvent["雷击术跟杖"] = nil;
            end;

            local v82;

            if skillRunData then
                v82 = skillRunData.runEvent["雷击术跟落点"];
            else
                v82 = skillRunData;
            end;

            if v82 then
                v82:Disconnect();
                skillRunData.runEvent["雷击术跟落点"] = nil;
            end;
        end;
    end,

    onEndServer = function(p83) -- Line: 443, Name: onEndServer
        local v84 = p83.hitbox and p83.hitbox[1];

        if v84 and v84.isActive then
            v84:stop();
        end;
    end,

    SoundList = { "音效-技能-雷系普攻" },
    AnimateList = { "技能释放动作11" },
    ResNameList = { "雷系尾迹", "雷击术释放", "雷击术被打击", "雷击术闪电" },
    hitboxConfig = { {
            HitboxIndex = 1,
            PartName = "通用球",
            CollisionGroup = "Player",
            HitPresentationProfile = "通用受击",
            PhysicsEffectName = "通用受击物理效果"
        } },
    Action = {
        {
            action = "LookAt",
            startTime = 0,
            overTime = 0.43,
            speedType = "RELEASE_SKILL_STATE_HALF"
        },
        {
            action = "Animation",
            startTime = 0,
            overTime = 1.27,
            animationName = "技能释放动作11",
            animationSpeed = 1,
            animationFadeTime = 0.1,
            animationPriority = Enum.AnimationPriority.Action4
        }
    }
};