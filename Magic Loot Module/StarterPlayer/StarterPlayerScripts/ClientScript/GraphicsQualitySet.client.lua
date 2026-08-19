-- Decompiled with Potassium's decompiler.

local MaterialService = game:GetService("MaterialService");
local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local GetData = UtilsSystem.GetData;
local DeviceType = UtilsSystem.DeviceType;
local AddListen = UtilsSystem.AddListen;
local Lighting = UtilsSystem.Lighting;
local LocalPlayer = UtilsSystem.LocalPlayer;
local ReplicatedStorage = UtilsSystem.ReplicatedStorage;
local Terrain = workspace:WaitForChild("Terrain", (1 / 0));

local function _getOrCreateMaterialServiceFolder() -- Line: 42
    -- upvalues: ReplicatedStorage (copy)
    local MaterialService2 = ReplicatedStorage:FindFirstChild("MaterialService");

    if MaterialService2 and MaterialService2:IsA("Folder") then
        return MaterialService2;
    end;

    if MaterialService2 then
        MaterialService2:Destroy();
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "MaterialService";
    Folder.Parent = ReplicatedStorage;

    return Folder;
end;

local MaterialService2 = ReplicatedStorage:FindFirstChild("MaterialService");

if not (MaterialService2 and MaterialService2:IsA("Folder")) then
    if MaterialService2 then
        MaterialService2:Destroy();
    end;

    MaterialService2 = Instance.new("Folder");
    MaterialService2.Name = "MaterialService";
    MaterialService2.Parent = ReplicatedStorage;
end;

local Plastic = Enum.Material.Plastic;
local u1 = {
    Monster = true,
    Terrain = true,
    Camera = true,
    CurrentCamera = true
};
local u2 = nil;
local u3 = nil;
local u4 = {};
local u5 = {};
local u6 = 0;
local u7 = false;

local function _shouldSkipWorkspaceChild(p8) -- Line: 91
    -- upvalues: u1 (copy)
    return u1[p8.Name] and true or ((p8:IsA("Terrain") or p8:IsA("Camera")) and true or (p8:IsA("Model") and p8:FindFirstChildOfClass("Humanoid") and true or false));
end;

local function _getWorkspaceChildAncestor(p9) -- Line: 111
    while p9 do
        local Parent = p9.Parent;

        if Parent == workspace then
            return p9;
        end;

        if Parent == nil then
            return nil;
        end;

        p9 = Parent;
    end;

    return nil;
end;

local function _shouldProcessPart(p10) -- Line: 132
    -- upvalues: u1 (copy)
    while true do
        if not p10 then
            p10 = nil;
            break;
        end;

        local Parent = p10.Parent;

        if Parent == workspace then
            break;
        end;

        if Parent == nil then
            p10 = nil;
            break;
        end;

        p10 = Parent;
    end;

    if p10 then
        return not (u1[p10.Name] or (p10:IsA("Terrain") or p10:IsA("Camera") or p10:IsA("Model") and p10:FindFirstChildOfClass("Humanoid"))) and true or false;
    end;

    return false;
end;

local function _applyPlasticMaterial(p11) -- Line: 146
    -- upvalues: u5 (copy), Plastic (copy)
    if not p11.Parent then
        return;
    end;

    if u5[p11] then
        return;
    end;

    if p11:GetAttribute("LowQualityOriginalMaterial") == nil then
        p11:SetAttribute("LowQualityOriginalMaterial", p11.Material.Name);
        p11:SetAttribute("LowQualityOriginalMaterialVariant", p11.MaterialVariant);
    end;

    p11.Material = Plastic;
    p11.MaterialVariant = "";
    u5[p11] = true;
end;

local function _restorePlasticMaterial(p12) -- Line: 168
    -- upvalues: u5 (copy)
    u5[p12] = nil;
    local v13 = p12:GetAttribute("LowQualityOriginalMaterial");

    if type(v13) ~= "string" then
        return;
    end;

    local v14 = Enum.Material[v13];

    if v14 ~= nil then
        p12.Material = v14;
    end;

    local v15 = p12:GetAttribute("LowQualityOriginalMaterialVariant");
    p12.MaterialVariant = type(v15) ~= "string" and "" or v15;
    p12:SetAttribute("LowQualityOriginalMaterial", nil);
    p12:SetAttribute("LowQualityOriginalMaterialVariant", nil);
end;

local function _flushPendingDescendantParts() -- Line: 191
    -- upvalues: u4 (copy), u7 (ref), u1 (copy), _applyPlasticMaterial (copy), u3 (ref)
    local v16 = 48;

    while true do
        local v17 = 0;

        while true do
            if v17 == 0 then
                v17 = -1;
                local v18;

                repeat
                    if v16 <= 0 or #u4 <= 0 then
                        if #u4 == 0 and u3 then
                            u3:Disconnect();
                            u3 = nil;
                        end;

                        return;
                    end;

                    v18 = table.remove(u4);
                    v16 = v16 - 1;
                until v18 and (v18.Parent and u7);

                local v19 = v18;
                local v20, v21;

                while true do
                    if not v18 then
                        v18 = nil;
                    end;

                    local Parent = v18.Parent;

                    if Parent == workspace then
                        if v18 then
                            v20 = u1[v18.Name] and true or ((v18:IsA("Terrain") or v18:IsA("Camera")) and true or (v18:IsA("Model") and v18:FindFirstChildOfClass("Humanoid") and true or false));
                            v21 = not v20;
                        else
                            v21 = false;
                        end;

                        if v21 then
                            _applyPlasticMaterial(v19);
                        end;

                        v17 = 0;
                        break;
                    end;

                    if Parent == nil then
                        v18 = nil;
                    end;

                    v18 = Parent;
                end;

                if v17 ~= 0 then
                    continue;
                end;

                if v18 then
                    v20 = u1[v18.Name] and true or ((v18:IsA("Terrain") or v18:IsA("Camera")) and true or (v18:IsA("Model") and v18:FindFirstChildOfClass("Humanoid") and true or false));
                    v21 = not v20;
                else
                    v21 = false;
                end;

                if v21 then
                    _applyPlasticMaterial(v19);
                end;

                break;
            else
                break;
            end;
        end;
    end;
end;

local function _ensureDescendantFlushConnection() -- Line: 211
    -- upvalues: u3 (ref), RunService (copy), _flushPendingDescendantParts (copy)
    if u3 then
        return;
    end;

    u3 = RunService.Heartbeat:Connect(_flushPendingDescendantParts);
end;

local function _onSceneDescendantAdded(p22) -- Line: 224
    -- upvalues: u7 (ref), u1 (copy), u4 (copy), u3 (ref), RunService (copy), _flushPendingDescendantParts (copy)
    if not u7 then
        return;
    end;

    if not p22:IsA("BasePart") then
        return;
    end;

    local v23 = p22;

    while true do
        if not p22 then
            p22 = nil;
            break;
        end;

        local Parent = p22.Parent;

        if Parent == workspace then
            break;
        end;

        if Parent == nil then
            p22 = nil;
            break;
        end;

        p22 = Parent;
    end;

    local v24;

    if p22 then
        local v25 = u1[p22.Name] and true or ((p22:IsA("Terrain") or p22:IsA("Camera")) and true or (p22:IsA("Model") and p22:FindFirstChildOfClass("Humanoid") and true or false));
        v24 = not v25;
    else
        v24 = false;
    end;

    if not v24 then
        return;
    end;

    table.insert(u4, v23);

    if u3 then
        return;
    end;

    u3 = RunService.Heartbeat:Connect(_flushPendingDescendantParts);
end;

local function _clearPendingDescendantParts() -- Line: 243
    -- upvalues: u4 (copy), u3 (ref)
    table.clear(u4);

    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;
end;

local function _setSceneMaterialListenerEnabled(p26) -- Line: 257
    -- upvalues: u2 (ref), _onSceneDescendantAdded (copy), u4 (copy), u3 (ref)
    if p26 then
        if u2 == nil then
            u2 = workspace.DescendantAdded:Connect(_onSceneDescendantAdded);
        end;
    elseif u2 ~= nil then
        u2:Disconnect();
        u2 = nil;
        table.clear(u4);

        if u3 then
            u3:Disconnect();
            u3 = nil;
        end;
    end;
end;

local function _processBranchBaseParts(p27, p28, p29) -- Line: 277
    -- upvalues: u6 (ref)
    local v30 = { p27 };
    local v31 = 0;

    while #v30 > 0 do
        if p29 ~= u6 then
            return;
        end;

        local v32 = table.remove(v30);

        if v32:IsA("BasePart") then
            p28(v32);
            v31 = v31 + 1;

            if v31 >= 64 then
                task.wait();
                v31 = 0;
            end;
        end;

        for _, child in v32:GetChildren() do
            table.insert(v30, child);
        end;
    end;
end;

local function _applyScenePlasticDeferred(p33) -- Line: 305
    -- upvalues: u6 (ref), u1 (copy), _processBranchBaseParts (copy), _applyPlasticMaterial (copy)
    for _, child in workspace:GetChildren() do
        if p33 ~= u6 then
            return;
        end;

        if not (u1[child.Name] or (child:IsA("Terrain") or child:IsA("Camera")) or child:IsA("Model") and child:FindFirstChildOfClass("Humanoid")) then
            _processBranchBaseParts(child, _applyPlasticMaterial, p33);
        end;
    end;
end;

local function _restoreScenePlasticDeferred(p34) -- Line: 323
    -- upvalues: u5 (copy), u6 (ref), _restorePlasticMaterial (copy)
    local v35 = {};

    for i in pairs(u5) do
        table.insert(v35, i);
    end;

    local v36 = 0;

    for _, v in ipairs(v35) do
        if p34 ~= u6 then
            return;
        end;

        if v.Parent then
            _restorePlasticMaterial(v);
        else
            u5[v] = nil;
        end;

        v36 = v36 + 1;

        if v36 >= 64 then
            task.wait();
            v36 = 0;
        end;
    end;
end;

local function _setScenePlasticMaterial(p37) -- Line: 353
    -- upvalues: u6 (ref), u7 (ref), u2 (ref), _onSceneDescendantAdded (copy), _applyScenePlasticDeferred (copy), u4 (copy), u3 (ref), _restoreScenePlasticDeferred (copy)
    u6 = u6 + 1;
    local u38 = u6;
    u7 = p37;

    if p37 then
        if u2 == nil then
            u2 = workspace.DescendantAdded:Connect(_onSceneDescendantAdded);
        end;

        task.spawn(function() -- Line: 360
            -- upvalues: _applyScenePlasticDeferred (ref), u38 (copy)
            _applyScenePlasticDeferred(u38);
        end);

        return;
    end;

    if u2 ~= nil then
        u2:Disconnect();
        u2 = nil;
        table.clear(u4);

        if u3 then
            u3:Disconnect();
            u3 = nil;
        end;
    end;

    task.spawn(function() -- Line: 365
        -- upvalues: _restoreScenePlasticDeferred (ref), u38 (copy)
        _restoreScenePlasticDeferred(u38);
    end);
end;

local function _applyGraphicsShadows() -- Line: 376
    -- upvalues: GetData (copy), LocalPlayer (copy), DeviceType (copy), Lighting (copy), Terrain (copy), u6 (ref), u7 (ref), u2 (ref), u4 (copy), u3 (ref), _restoreScenePlasticDeferred (copy), MaterialService2 (copy), MaterialService (copy), _onSceneDescendantAdded (copy), _applyScenePlasticDeferred (copy)
    local v39 = GetData.GetSetting(LocalPlayer, "GraphicsQuality");
    local v40 = v39 == 1;

    if DeviceType.IsMobile() then
        v40 = false;
    end;

    Lighting.GlobalShadows = v40;

    if v40 then
        Terrain.WaterWaveSize = 0.15;
        Terrain.WaterWaveSpeed = 10;
        Terrain.WaterReflectance = 1;
        Terrain.WaterTransparency = 0.3;
    else
        Terrain.WaterWaveSize = 0;
        Terrain.WaterWaveSpeed = 0;
        Terrain.WaterReflectance = 0;
        Terrain.WaterTransparency = 0.3;
    end;

    if v39 == 1 then
        u6 = u6 + 1;
        local u41 = u6;
        u7 = false;

        if u2 ~= nil then
            u2:Disconnect();
            u2 = nil;
            table.clear(u4);

            if u3 then
                u3:Disconnect();
                u3 = nil;
            end;
        end;

        task.spawn(function() -- Line: 365
            -- upvalues: _restoreScenePlasticDeferred (ref), u41 (copy)
            _restoreScenePlasticDeferred(u41);
        end);

        for _, child in ipairs(MaterialService2:GetChildren()) do
            child.Parent = MaterialService;
        end;

        return;
    end;

    for _, child in ipairs(MaterialService:GetChildren()) do
        child.Parent = MaterialService2;
    end;

    u6 = u6 + 1;
    local u42 = u6;
    u7 = true;

    if u2 == nil then
        u2 = workspace.DescendantAdded:Connect(_onSceneDescendantAdded);
    end;

    task.spawn(function() -- Line: 360
        -- upvalues: _applyScenePlasticDeferred (ref), u42 (copy)
        _applyScenePlasticDeferred(u42);
    end);
end;

local GraphicsQuality = LocalPlayer:WaitForChild("Setting", (1 / 0)):WaitForChild("GraphicsQuality", (1 / 0));
AddListen.NumValueAdd(GraphicsQuality, function(p43) -- Line: 413
    -- upvalues: _applyGraphicsShadows (copy)
    _applyGraphicsShadows();
end);
_applyGraphicsShadows();