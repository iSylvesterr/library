-- Decompiled with Potassium's decompiler.

local Workspace = game:GetService("Workspace");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AnimationModule = UtilsSystem.AnimationModule;
local VisibleMgr = UtilsSystem.VisibleMgr;
local Debris = UtilsSystem.Debris;
local u1 = {};
local u2 = {};

function u1.findRuntimeNpcModel(p3) -- Line: 38
    -- upvalues: UtilsSystem (copy), Workspace (copy)
    local SystemLogicalEnemy = UtilsSystem.SystemLogicalEnemy;
    local v4 = SystemLogicalEnemy and SystemLogicalEnemy.GetModel and SystemLogicalEnemy.GetModel(p3);

    if v4 then
        return v4;
    end;

    local LocalMonster = Workspace:FindFirstChild("LocalMonster");

    if LocalMonster then
        local v5 = LocalMonster:FindFirstChild(p3);

        if v5 and v5:IsA("Model") then
            return v5;
        end;
    end;

    local Monster = Workspace:FindFirstChild("Monster");

    if Monster then
        local v6 = Monster:FindFirstChild(p3);

        if v6 and v6:IsA("Model") then
            return v6;
        end;
    end;

    local Summons = Workspace:FindFirstChild("Summons");

    if Summons then
        local v7 = Summons:FindFirstChild(p3);

        if v7 and v7:IsA("Model") then
            return v7;
        end;
    end;

    return nil;
end;

local function _getDebrisFolder() -- Line: 77
    -- upvalues: Workspace (copy)
    local Debris2 = Workspace:FindFirstChild("Debris");

    if Debris2 and Debris2:IsA("Folder") then
        return Debris2;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "Debris";
    Folder.Parent = Workspace;

    return Folder;
end;

local function _hideTrueModelLocally(p8) -- Line: 93
    for _, descendant in p8:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = 1;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            descendant.Transparency = 1;
        elseif descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or descendant:IsA("Beam")) then
            descendant.Enabled = false;
        elseif descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui") then
            descendant.Enabled = false;
        end;
    end;
end;

local function _stripScripts(p9) -- Line: 114
    for _, descendant in p9:GetDescendants() do
        if descendant:IsA("Script") or (descendant:IsA("LocalScript") or descendant:IsA("ModuleScript")) then
            descendant:Destroy();
        end;
    end;
end;

local function _createDeathClone(u10) -- Line: 128
    -- upvalues: _stripScripts (copy), Workspace (copy)
    local success, result = pcall(function() -- Line: 129
        -- upvalues: u10 (copy)
        return u10:Clone();
    end);

    if not (success and (result and result:IsA("Model"))) then
        return nil;
    end;

    _stripScripts(result);
    result.Name = u10.Name .. "_DeathFx";
    result:PivotTo(u10:GetPivot());
    local Debris2 = Workspace:FindFirstChild("Debris");

    if not (Debris2 and Debris2:IsA("Folder")) then
        Debris2 = Instance.new("Folder");
        Debris2.Name = "Debris";
        Debris2.Parent = Workspace;
    end;

    result.Parent = Debris2;

    return result;
end;

local function _playSummonIdleDeathOnClone(u11, p12) -- Line: 148
    -- upvalues: AnimationModule (copy), VisibleMgr (copy)
    if typeof(p12) == "string" and p12 ~= "" then
        AnimationModule.PlayAnimByModel(u11, p12, 1, nil, nil, nil, 0.2);
    end;

    task.delay(1, function() -- Line: 152
        -- upvalues: u11 (copy), VisibleMgr (ref)
        if u11.Parent then
            VisibleMgr.DieEffectUnHuman(u11);
        end;
    end);
end;

function u1.playOnModel(p13, p14) -- Line: 166
    -- upvalues: _createDeathClone (copy), _hideTrueModelLocally (copy), _playSummonIdleDeathOnClone (copy), VisibleMgr (copy), Debris (copy)
    if not p13 or (not p13.Parent or type(p14) ~= "table") then
        return false;
    end;

    local v15 = _createDeathClone(p13);

    if not v15 then
        return false;
    end;

    _hideTrueModelLocally(p13);
    local kind = p14.kind;

    if ((typeof(kind) ~= "string" or kind == "") and "default" or kind) == "summonIdle" then
        local animName = p14.animName;

        if typeof(animName) ~= "string" or animName == "" then
            animName = nil;
        end;

        _playSummonIdleDeathOnClone(v15, animName);
    else
        VisibleMgr.DieEffect(v15);
    end;

    Debris:AddItem(v15, 2.5);

    return true;
end;

function u1.playFromPayload(p16) -- Line: 204
    -- upvalues: u2 (copy), u1 (copy)
    if type(p16) ~= "table" then
        return false;
    end;

    local v17;

    if p16.monsterId == nil then
        v17 = nil;
    else
        v17 = tostring(p16.monsterId) or nil;
    end;

    if not v17 then
        return false;
    end;

    local serverTime = p16.serverTime;

    if typeof(serverTime) == "number" then
        local v18 = u2[v17];

        if typeof(v18) == "number" and serverTime < v18 then
            return false;
        end;

        u2[v17] = serverTime;
    end;

    local v19 = u1.findRuntimeNpcModel(v17);

    if v19 then
        return u1.playOnModel(v19, p16);
    end;

    return false;
end;

return u1;