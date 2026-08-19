-- Decompiled with Potassium's decompiler.

local v1 = {};
local Workspace = game:GetService("Workspace");
local u2 = RaycastParams.new();
local u3 = {
    Player = {
        workspaceFolder = "Characters",
        ignoreWater = false,
        ignoreTransparentParts = false,
        filterType = Enum.RaycastFilterType.Include
    },
    Enemy = {
        workspaceFolder = "Monster",
        ignoreWater = false,
        ignoreTransparentParts = false,
        filterType = Enum.RaycastFilterType.Include
    },
    Ground = {
        workspaceFolder = "场景",
        ignoreWater = true,
        ignoreTransparentParts = false,
        filterType = Enum.RaycastFilterType.Include
    },
    All = {
        ignoreWater = false,
        ignoreTransparentParts = false,
        filterType = Enum.RaycastFilterType.Exclude,
        instances = {}
    },
    CollisionGroup = {
        collisionGroup = "Default",
        ignoreWater = false,
        ignoreTransparentParts = false
    }
};
local u4 = {
    ignoreWater = false,
    ignoreTransparentParts = false,
    filterType = Enum.RaycastFilterType.Exclude,
    instances = {}
};

local function _resolveWorkspaceFolder(p5) -- Line: 137
    -- upvalues: Workspace (copy)
    local v6 = Workspace:FindFirstChild(p5);

    return v6 and { v6 } or {};
end;

local function _presetDefToConfig(p7) -- Line: 151
    -- upvalues: Workspace (copy)
    local instances = p7.instances;

    if not instances and p7.workspaceFolder then
        local v8 = Workspace:FindFirstChild(p7.workspaceFolder);
        instances = v8 and { v8 } or {};
    end;

    return {
        filterType = p7.filterType,
        collisionGroup = p7.collisionGroup,
        instances = instances or {},
        ignoreWater = p7.ignoreWater,
        ignoreTransparentParts = p7.ignoreTransparentParts
    };
end;

local function _resolveFinalConfig(p9, p10) -- Line: 172
    -- upvalues: u3 (copy), _presetDefToConfig (copy), u4 (copy)
    local v11 = u3[p9];
    local v12;

    if v11 then
        v12 = _presetDefToConfig(v11);
    else
        warn("未找到射线检测预设类型:", p9, "，使用默认配置");
        v12 = u4;
    end;

    if not p10 then
        return v12;
    end;

    local v13 = {
        filterType = p10.filterType or v12.filterType,
        collisionGroup = p10.collisionGroup or v12.collisionGroup,
        instances = p10.instances or v12.instances
    };
    local v14;

    if p10.ignoreWater == nil then
        v14 = v12.ignoreWater;
    else
        v14 = p10.ignoreWater;
    end;

    v13.ignoreWater = v14;
    local v15;

    if p10.ignoreTransparentParts == nil then
        v15 = v12.ignoreTransparentParts;
    else
        v15 = p10.ignoreTransparentParts;
    end;

    v13.ignoreTransparentParts = v15;

    return v13;
end;

local function _applyConfigToParams(p16, p17) -- Line: 204
    if p17.collisionGroup then
        p16.CollisionGroup = p17.collisionGroup;
        p16.FilterType = Enum.RaycastFilterType.Exclude;
        p16.FilterDescendantsInstances = {};
    else
        p16.CollisionGroup = "";
        p16.FilterType = p17.filterType or Enum.RaycastFilterType.Exclude;
        p16.FilterDescendantsInstances = p17.instances or {};
    end;

    local v18;

    if p17.ignoreWater == nil then
        v18 = false;
    else
        v18 = p17.ignoreWater;
    end;

    p16.IgnoreWater = v18;
end;

local function _updateSharedRaycastParams(p19) -- Line: 224
    -- upvalues: _applyConfigToParams (copy), u2 (copy)
    _applyConfigToParams(u2, p19);

    return u2;
end;

local function _performRaycast(p20, p21, p22, p23) -- Line: 238
    -- upvalues: Workspace (copy)
    local Magnitude = p21.Magnitude;

    if Magnitude <= 0 then
        return nil;
    end;

    local v24 = p21 / Magnitude;
    local v25 = 0;

    while v25 < Magnitude do
        local v26 = Workspace:Raycast(p20, v24 * (Magnitude - v25), p22);

        if not v26 then
            return nil;
        end;

        local Instance = v26.Instance;

        if not p23 or (not Instance:IsA("BasePart") or Instance.Transparency < 1) then
            return v26;
        end;

        v25 = v25 + ((v26.Position - p20).Magnitude + 0.01);

        if Magnitude <= v25 then
            return nil;
        end;

        p20 = v26.Position + v24 * 0.01;
    end;

    return nil;
end;

function v1.GetRayCastParams(p27, p28) -- Line: 292
    -- upvalues: _resolveFinalConfig (copy), _applyConfigToParams (copy)
    local v29 = _resolveFinalConfig(p27, p28);
    local v30 = RaycastParams.new();
    _applyConfigToParams(v30, v29);

    return v30;
end;

function v1.RayCast(p31, p32, p33, p34) -- Line: 308
    -- upvalues: _resolveFinalConfig (copy), _applyConfigToParams (copy), u2 (copy), _performRaycast (copy)
    local v35 = p32 - p31;

    if v35.Magnitude <= 0 then
        warn("射线起点和终点相同，无法进行检测");

        return nil;
    end;

    local v36 = _resolveFinalConfig(p33 or "All", p34);
    _applyConfigToParams(u2, v36);

    return _performRaycast(p31, v35, u2, v36.ignoreTransparentParts);
end;

function v1.RayCastDirection(p37, p38, p39, p40, p41) -- Line: 335
    -- upvalues: _resolveFinalConfig (copy), _applyConfigToParams (copy), u2 (copy), _performRaycast (copy)
    if p38.Magnitude <= 0 then
        warn("射线方向为零向量，无法进行检测");

        return nil;
    end;

    local v42 = _resolveFinalConfig(p40 or "All", p41);
    _applyConfigToParams(u2, v42);

    return _performRaycast(p37, p38.Unit * p39, u2, v42.ignoreTransparentParts);
end;

function v1.GetAvailablePresets() -- Line: 358
    -- upvalues: u3 (copy)
    local v43 = {};

    for i, _ in pairs(u3) do
        table.insert(v43, i);
    end;

    table.sort(v43);

    return v43;
end;

return v1;