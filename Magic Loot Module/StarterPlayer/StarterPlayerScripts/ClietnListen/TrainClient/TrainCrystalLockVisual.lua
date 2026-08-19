-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local CollectionService = UtilsSystem.CollectionService;
local EnumMgr = UtilsSystem.EnumMgr;
local GetData = UtilsSystem.GetData;
local LocalPlayer = UtilsSystem.LocalPlayer;
local u1 = {};
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {};

local function _isToggleableEnabled(p6) -- Line: 51
    return p6:IsA("ParticleEmitter") or p6:IsA("Beam") or (p6:IsA("Trail") or p6:IsA("Fire")) or (p6:IsA("Smoke") or p6:IsA("Sparkles") or (p6:IsA("PointLight") or p6:IsA("SpotLight")) or (p6:IsA("SurfaceLight") or p6:IsA("BillboardGui") or (p6:IsA("SurfaceGui") or p6:IsA("Highlight"))));
end;

local function _applyShownToInst(p7, p8) -- Line: 73
    -- upvalues: u4 (copy), _isToggleableEnabled (copy), u3 (copy)
    if p7:IsA("BasePart") then
        p7.LocalTransparencyModifier = p8 and 0 or 1;

        return nil;
    end;

    if p7:IsA("Decal") or p7:IsA("Texture") then
        if p8 then
            local v9 = u4[p7];

            if v9 ~= nil then
                p7.Transparency = v9;
                u4[p7] = nil;
            end;
        else
            if u4[p7] == nil then
                u4[p7] = p7.Transparency;
            end;

            p7.Transparency = 1;
        end;

        return nil;
    end;

    if not _isToggleableEnabled(p7) then
        return nil;
    end;

    if p8 then
        local v10 = u3[p7];

        if v10 ~= nil then
            p7.Enabled = v10;
            u3[p7] = nil;
        end;
    else
        if u3[p7] == nil then
            u3[p7] = p7.Enabled == true;
        end;

        p7.Enabled = false;
    end;

    return nil;
end;

local function _setModelShown(p11, p12) -- Line: 120
    -- upvalues: u2 (copy), _applyShownToInst (copy)
    if u2[p11] == p12 then
        return nil;
    end;

    u2[p11] = p12;

    for _, descendant in p11:GetDescendants() do
        _applyShownToInst(descendant, p12);
    end;

    return nil;
end;

local function _resolveTrainModel(p13) -- Line: 137
    if not (p13 and p13.Parent) then
        return nil;
    end;

    local Parent = p13.Parent;

    if Parent:IsA("BasePart") and (Parent.Parent and Parent.Parent:IsA("Model")) then
        Parent = Parent.Parent;
    end;

    if Parent:IsA("Model") then
        return Parent;
    end;

    return nil;
end;

local function _findCrystalModel(p14, p15) -- Line: 158
    local v16 = p14:FindFirstChild(p15);

    if v16 and v16:IsA("Model") then
        return v16;
    end;

    return nil;
end;

local function _bindModelWatch(u17) -- Line: 172
    -- upvalues: u5 (copy), u2 (copy), _applyShownToInst (copy)
    if u5[u17] then
        return nil;
    end;

    u5[u17] = true;
    u17.DescendantAdded:Connect(function(p18) -- Line: 177
        -- upvalues: u2 (ref), u17 (copy), _applyShownToInst (ref)
        if u2[u17] == false then
            _applyShownToInst(p18, false);
        end;
    end);
    u17.Destroying:Connect(function() -- Line: 183
        -- upvalues: u2 (ref), u17 (copy), u5 (ref)
        u2[u17] = nil;
        u5[u17] = nil;
    end);

    return nil;
end;

local function _applyPairVisibility(p19, p20, p21) -- Line: 198
    -- upvalues: _bindModelWatch (copy), u2 (copy), _applyShownToInst (copy)
    if p19 then
        _bindModelWatch(p19);
        local v22 = not p21;

        if u2[p19] ~= v22 then
            u2[p19] = v22;

            for _, descendant in p19:GetDescendants() do
                _applyShownToInst(descendant, v22);
            end;
        end;
    end;

    if p20 then
        _bindModelWatch(p20);

        if u2[p20] ~= p21 then
            u2[p20] = p21;

            for _, descendant in p20:GetDescendants() do
                _applyShownToInst(descendant, p21);
            end;
        end;
    end;

    return nil;
end;

local function _refreshOne(p23) -- Line: 216
    -- upvalues: GetData (copy), _resolveTrainModel (copy), LocalPlayer (copy), _bindModelWatch (copy), u2 (copy), _applyShownToInst (copy)
    local v24 = GetData.Train.GetTrainIdFromInstance(p23);

    if not v24 then
        return nil;
    end;

    local v25 = _resolveTrainModel((GetData.Train.ResolveZonePart(p23)));

    if not v25 then
        return nil;
    end;

    local v26 = v25:FindFirstChild("水晶");

    if not (v26 and v26:IsA("Model")) then
        v26 = nil;
    end;

    local v27 = v25:FindFirstChild("未解锁水晶");

    if not (v27 and v27:IsA("Model")) then
        v27 = nil;
    end;

    if not (v26 or v27) then
        return nil;
    end;

    local v28 = not GetData.Train.CanEnterTrainGround(LocalPlayer, v24).ok;

    if v26 then
        _bindModelWatch(v26);
        local v29 = not v28;

        if u2[v26] ~= v29 then
            u2[v26] = v29;

            for _, descendant in v26:GetDescendants() do
                _applyShownToInst(descendant, v29);
            end;
        end;
    end;

    if v27 then
        _bindModelWatch(v27);

        if u2[v27] ~= v28 then
            u2[v27] = v28;

            for _, descendant in v27:GetDescendants() do
                _applyShownToInst(descendant, v28);
            end;
        end;
    end;

    return nil;
end;

function u1.RefreshAll() -- Line: 245
    -- upvalues: CollectionService (copy), _refreshOne (copy)
    for _, v in CollectionService:GetTagged("Train") do
        _refreshOne(v);
    end;

    return nil;
end;

local function _bindRebirthWatch() -- Line: 257
    -- upvalues: GetData (copy), LocalPlayer (copy), EnumMgr (copy), u1 (copy)
    task.spawn(function() -- Line: 258
        -- upvalues: GetData (ref), LocalPlayer (ref), EnumMgr (ref), u1 (ref)
        local v30 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.Rebirth);
        u1.RefreshAll();
        v30.Changed:Connect(function() -- Line: 262
            -- upvalues: u1 (ref)
            u1.RefreshAll();
        end);
    end);

    return nil;
end;

local function _bindGamePassWatch() -- Line: 274
    -- upvalues: CfgFind (copy), LocalPlayer (copy), u1 (copy)
    task.spawn(function() -- Line: 275
        -- upvalues: CfgFind (ref), LocalPlayer (ref), u1 (ref)
        local v31 = CfgFind.CollectTrainPassOnlyTags();

        if #v31 == 0 then
            return nil;
        end;

        local GamePass = LocalPlayer:WaitForChild("GamePass", (1 / 0));

        for _, v in v31 do
            local v32 = GamePass:WaitForChild(v, (1 / 0));

            if v32:IsA("NumberValue") then
                v32.Changed:Connect(u1.RefreshAll);
            end;
        end;
    end);

    return nil;
end;

function u1.Init() -- Line: 296
    -- upvalues: u1 (copy), CollectionService (copy), _refreshOne (copy), GetData (copy), LocalPlayer (copy), EnumMgr (copy), CfgFind (copy)
    u1.RefreshAll();
    CollectionService:GetInstanceAddedSignal("Train"):Connect(function(u33) -- Line: 298
        -- upvalues: _refreshOne (ref)
        task.defer(function() -- Line: 299
            -- upvalues: _refreshOne (ref), u33 (copy)
            _refreshOne(u33);
        end);
    end);
    task.spawn(function() -- Line: 258
        -- upvalues: GetData (ref), LocalPlayer (ref), EnumMgr (ref), u1 (ref)
        local v34 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.Rebirth);
        u1.RefreshAll();
        v34.Changed:Connect(function() -- Line: 262
            -- upvalues: u1 (ref)
            u1.RefreshAll();
        end);
    end);
    task.spawn(function() -- Line: 275
        -- upvalues: CfgFind (ref), LocalPlayer (ref), u1 (ref)
        local v35 = CfgFind.CollectTrainPassOnlyTags();

        if #v35 == 0 then
            return nil;
        end;

        local GamePass = LocalPlayer:WaitForChild("GamePass", (1 / 0));

        for _, v in v35 do
            local v36 = GamePass:WaitForChild(v, (1 / 0));

            if v36:IsA("NumberValue") then
                v36.Changed:Connect(u1.RefreshAll);
            end;
        end;
    end);

    return nil;
end;

return u1;