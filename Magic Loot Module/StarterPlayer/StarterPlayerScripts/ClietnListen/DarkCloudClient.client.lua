-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local AssetPaths = UtilsSystem.AssetPaths;
local AssetRegistry = UtilsSystem.AssetRegistry;
local ResRestore = UtilsSystem.ResRestore;
local SoundModule = UtilsSystem.SoundModule;
local SystemLogicalEnemy = UtilsSystem.SystemLogicalEnemy;
local u1 = { "音效-技能-雷4-打雷1", "音效-技能-雷4-打雷2", "音效-技能-雷4-打雷3", "音效-技能-雷4-打雷4", "音效-技能-雷4-打雷5", "音效-技能-雷4-打雷6", "音效-技能-雷4-打雷7", "音效-技能-雷4-打雷8", "音效-技能-雷4-打雷9" };
local u2 = nil;

local function _playSound3D(p3, p4) -- Line: 63
    -- upvalues: SoundModule (copy)
    if not SoundModule then
        return;
    end;

    SoundModule:PlaySoundLocal({
        Is2D = false,
        SoundName = p3,
        PlayPosition = p4
    });
end;

local function _pickRandomStrikeSound() -- Line: 78
    -- upvalues: u1 (copy)
    local v5 = #u1;

    if v5 == 0 then
        return nil;
    end;

    return u1[math.random(1, v5)];
end;

local function _fxParent() -- Line: 90
    return workspace:FindFirstChild("Debris") or workspace;
end;

local function _cloneSkillModel(p6) -- Line: 101
    -- upvalues: AssetPaths (copy), AssetRegistry (copy), ResRestore (copy)
    local v7 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(AssetRegistry.ModelCategory.Skill, p6));

    if not (v7 and v7:IsA("Model")) then
        return nil;
    end;

    local v8 = v7:Clone();

    if ResRestore and ResRestore.Restore then
        ResRestore.Restore(v8);
    end;

    return v8;
end;

local function _recycleCloud() -- Line: 117
    -- upvalues: u2 (ref), FXUtil (copy)
    local v9 = u2;
    u2 = nil;

    if not v9 then
        return;
    end;

    FXUtil.OffEnableVfx(v9);
    FXUtil.Debris(v9, 0.5);
end;

local function _placeFxOnGround(p10, p11) -- Line: 137
    p10:PivotTo(CFrame.new(p11.X, 0, p11.Z));
    local PrimaryPart = p10.PrimaryPart;
    local v12;

    if PrimaryPart then
        v12 = PrimaryPart.Position.Y - PrimaryPart.Size.Y * 0.5;
    else
        local v13, v14 = p10:GetBoundingBox();
        v12 = v13.Position.Y - v14.Y * 0.5;
    end;

    p10:PivotTo(p10:GetPivot() + Vector3.new(0, 3 - v12, 0));
end;

local function _resolveStrikeModel(p15) -- Line: 156
    -- upvalues: SystemLogicalEnemy (copy)
    local v16 = SystemLogicalEnemy and SystemLogicalEnemy.GetModel and SystemLogicalEnemy.GetModel(p15);

    if v16 then
        return v16;
    end;

    local v17 = tostring(p15);
    local Monster = workspace:FindFirstChild("Monster");

    if Monster then
        local v18 = Monster:FindFirstChild(v17);

        if v18 and v18:IsA("Model") then
            return v18;
        end;
    end;

    local LocalMonster = workspace:FindFirstChild("LocalMonster");

    if LocalMonster then
        local v19 = LocalMonster:FindFirstChild(v17);

        if v19 and v19:IsA("Model") then
            return v19;
        end;
    end;

    return nil;
end;

local function _playStrikeOnTarget(u20, p21) -- Line: 187
    -- upvalues: _cloneSkillModel (copy), _placeFxOnGround (copy), FXUtil (copy), u1 (copy), SoundModule (copy), VisibleMgr (copy)
    local v22 = _cloneSkillModel("落雷_打雷特效");

    if v22 then
        v22.Parent = workspace:FindFirstChild("Debris") or workspace;
        _placeFxOnGround(v22, p21);
        FXUtil.Emit_Particles_GetDescendants(v22, true);
        local v23 = #u1;
        local v24;

        if v23 == 0 then
            v24 = nil;
        else
            v24 = u1[math.random(1, v23)];
        end;

        if v24 and SoundModule then
            SoundModule:PlaySoundLocal({
                Is2D = false,
                SoundName = v24,
                PlayPosition = p21
            });
        end;

        FXUtil.Debris(v22, 2);
    end;

    if not (u20 and u20:IsA("Model")) then
        return;
    end;

    task.delay(0.16, function() -- Line: 203
        -- upvalues: u20 (copy), VisibleMgr (ref)
        if u20.Parent then
            VisibleMgr.fadeAll(u20, 1);
        end;
    end);
    task.delay(0.36, function() -- Line: 208
        -- upvalues: u20 (copy), VisibleMgr (ref)
        if u20.Parent then
            VisibleMgr.showAll(u20);
        end;
    end);
end;

(function() -- Line: 219, Name: _bindRemotes
    -- upvalues: NetWork (copy), NetMsg (copy), u2 (ref), FXUtil (copy), _cloneSkillModel (copy), SoundModule (copy), _resolveStrikeModel (copy), _playStrikeOnTarget (copy)
    NetWork.RegisterClientRemoteEvent(NetMsg.DARKCLOUD_CREATE, function(p25) -- Line: 220
        -- upvalues: u2 (ref), FXUtil (ref), _cloneSkillModel (ref), SoundModule (ref)
        if typeof(p25) ~= "Vector3" then
            return;
        end;

        local v26 = u2;
        u2 = nil;

        if v26 then
            FXUtil.OffEnableVfx(v26);
            FXUtil.Debris(v26, 0.5);
        end;

        local v27 = _cloneSkillModel("落雷_乌云");

        if not v27 then
            return;
        end;

        v27.Parent = workspace:FindFirstChild("Debris") or workspace;
        v27:PivotTo(CFrame.new(p25));
        FXUtil.Emit_Particles_GetDescendants(v27, false);
        FXUtil.SetEnableNameVfx(v27, true);
        u2 = v27;

        if not SoundModule then
            return;
        end;

        SoundModule:PlaySoundLocal({
            SoundName = "音效-技能-雷4-乌云",
            Is2D = false,
            PlayPosition = p25
        });
    end);
    NetWork.RegisterClientRemoteEvent(NetMsg.DARKCLOUD_MOVE, function(p28) -- Line: 237
        -- upvalues: u2 (ref), SoundModule (ref)
        if typeof(p28) ~= "Vector3" then
            return;
        end;

        if u2 and u2.Parent then
            u2:PivotTo(CFrame.new(p28));

            if not SoundModule then
                return;
            end;

            SoundModule:PlaySoundLocal({
                SoundName = "音效-技能-雷4-乌云",
                Is2D = false,
                PlayPosition = p28
            });
        end;
    end);
    NetWork.RegisterClientRemoteEvent(NetMsg.DARKCLOUD_STRIKE, function(p29) -- Line: 247
        -- upvalues: _resolveStrikeModel (ref), _playStrikeOnTarget (ref)
        if type(p29) ~= "table" then
            return;
        end;

        for _, v in p29 do
            if type(v) == "table" and typeof(v.pos) == "Vector3" then
                local v30 = nil;

                if v.enemyId == nil then
                    if typeof(v.model) == "Instance" and v.model:IsA("Model") then
                        v30 = v.model;
                    end;
                else
                    v30 = _resolveStrikeModel(v.enemyId);
                end;

                _playStrikeOnTarget(v30, v.pos);
            end;
        end;
    end);
    NetWork.RegisterClientRemoteEvent(NetMsg.DARKCLOUD_STOP, function() -- Line: 266
        -- upvalues: u2 (ref), FXUtil (ref)
        local v31 = u2;
        u2 = nil;

        if not v31 then
            return;
        end;

        FXUtil.OffEnableVfx(v31);
        FXUtil.Debris(v31, 0.5);
    end);
end)();