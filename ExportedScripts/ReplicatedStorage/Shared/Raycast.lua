-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
game:GetService("Debris");
local Sift = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Sift"));
local u1 = table.freeze({
    ["Sandy Brick"] = 0,
    IndoorWall = 0
});
local u2 = table.freeze({
    [Enum.Material.Asphalt] = 0,
    [Enum.Material.Basalt] = 0,
    [Enum.Material.Brick] = 0,
    [Enum.Material.Cobblestone] = 0,
    [Enum.Material.Concrete] = 0,
    [Enum.Material.CrackedLava] = 0,
    [Enum.Material.DiamondPlate] = 0,
    [Enum.Material.Foil] = 0,
    [Enum.Material.Glacier] = 0,
    [Enum.Material.Granite] = 0,
    [Enum.Material.Grass] = 0,
    [Enum.Material.Ground] = 0,
    [Enum.Material.Ice] = 0,
    [Enum.Material.LeafyGrass] = 0,
    [Enum.Material.Limestone] = 0,
    [Enum.Material.Marble] = 0,
    [Enum.Material.Metal] = 0,
    [Enum.Material.Mud] = 0,
    [Enum.Material.Pavement] = 0,
    [Enum.Material.Rock] = 0,
    [Enum.Material.Salt] = 0,
    [Enum.Material.Sand] = 0,
    [Enum.Material.Sandstone] = 0,
    [Enum.Material.Slate] = 0,
    [Enum.Material.Snow] = 0,
    [Enum.Material.ForceField] = 0,
    [Enum.Material.Neon] = 0,
    [Enum.Material.CorrodedMetal] = 0,
    [Enum.Material.Pebble] = 0,
    [Enum.Material.CeramicTiles] = 0,
    [Enum.Material.Plaster] = 0,
    [Enum.Material.Plastic] = 10,
    [Enum.Material.SmoothPlastic] = 10,
    [Enum.Material.Wood] = 10,
    [Enum.Material.WoodPlanks] = 10,
    [Enum.Material.Cardboard] = 10,
    [Enum.Material.Glass] = 25,
    [Enum.Material.Fabric] = 25
});
local Folder = Instance.new("Folder");
Folder.Parent = workspace:FindFirstChild("Debris") or workspace;
Folder.Name = "RaycastVisualizers";

local function _createVisualizer(p3, p4) -- Line: 84
end;

local function isPartOfHumanoid(p5) -- Line: 112
    local v6 = p5:FindFirstAncestorWhichIsA("Model");

    if v6 then
        local v7 = v6:FindFirstChildOfClass("Humanoid") or v6.Parent and v6.Parent:FindFirstChildOfClass("Humanoid");

        if v7 then
            return true, v7;
        end;
    end;

    return false, nil;
end;

local function isPartFiltered(p8) -- Line: 127
    -- upvalues: Folder (copy), isPartOfHumanoid (copy)
    local v9 = p8:IsDescendantOf(Folder);
    isPartOfHumanoid(p8);

    return v9 or (p8:FindFirstAncestorWhichIsA("Accessory") ~= nil or p8.Name == "CollisionCapsule");
end;

local function isPartWhitelisted(p10, p11) -- Line: 139
    for _, v in pairs(p11) do
        if p10 == v or p10:IsDescendantOf(v) then
            return true;
        end;
    end;

    return false;
end;

local function getPenetrationMaterial(p12) -- Line: 149
    local Parent = p12.Parent;

    if Parent and Parent:HasTag("BreakableDoor") then
        return Enum.Material.Metal;
    end;

    return p12.Material;
end;

local function checkMaterialDepth(p13, p14, p15, p16, p17, p18, p19, p20) -- Line: 158
    -- upvalues: Workspace (copy), u1 (copy), getPenetrationMaterial (copy), u2 (copy)
    local v21 = RaycastParams.new();
    v21.FilterType = Enum.RaycastFilterType.Include;
    v21.CollisionGroup = "Bullet";
    v21.FilterDescendantsInstances = { p15 };
    local v22 = p13 + p14 * 1000;
    local v23 = Workspace:Raycast(v22, p13 - v22, v21);

    if not v23 then
        return 0, p13, p19, true;
    end;

    local Magnitude = (p13 - v23.Position).Magnitude;
    local Position = v23.Position;
    local v24 = p19 + Magnitude;
    local v25 = false;
    local MaterialVariant = v23.Instance.MaterialVariant;
    local v26;

    if MaterialVariant == "" then
        v26 = false;
    else
        v26 = u1[MaterialVariant] ~= nil;
    end;

    if v26 then
        p18[MaterialVariant] = (p18[MaterialVariant] or 0) + Magnitude;

        if p18[MaterialVariant] > (u1[MaterialVariant] or 0) + p20 then
            return Magnitude, Position, v24, true;
        end;

        local v27 = {
            instance = v23.Instance,
            position = v23.Position,
            normal = v23.Normal,
            material = getPenetrationMaterial(v23.Instance)
        };
        table.insert(p16, v27);

        return Magnitude, Position, v24, v25;
    end;

    local v28 = getPenetrationMaterial(v23.Instance);
    p17[v28] = (p17[v28] or 0) + Magnitude;

    if p17[v28] > (u2[v28] or 0) + p20 then
        return Magnitude, Position, v24, true;
    end;

    table.insert(p16, {
        instance = v23.Instance,
        position = v23.Position,
        normal = v23.Normal,
        material = v23.Material
    });

    return Magnitude, Position, v24, v25;
end;

local function castThroughMaterials(p29, p30, p31, p32) -- Line: 224
    -- upvalues: Workspace (copy), getPenetrationMaterial (copy), checkMaterialDepth (copy)
    local Unit = p30.Unit;
    local v33 = {};
    local v34 = {};
    local v35 = {};
    local v36 = 0;

    for _ = 1, 100 do
        local v37 = Workspace:Raycast(p29, Unit * 1000, p32);

        if not v37 then
            break;
        end;

        p32:AddToFilter(v37.Instance);
        local v38 = {
            instance = v37.Instance,
            position = v37.Position,
            normal = v37.Normal,
            material = getPenetrationMaterial(v37.Instance)
        };
        table.insert(v33, v38);
        local v39, v40;
        v39, p29, v36, v40 = checkMaterialDepth(v37.Position, Unit, v37.Instance, v33, v34, v35, v36, p31);

        if v40 then
            break;
        end;
    end;

    return v33;
end;

local u42 = {
    isPartOfHumanoid = function(p41) -- Line: 282, Name: isPartOfHumanoid
        -- upvalues: isPartOfHumanoid (copy)
        return isPartOfHumanoid(p41);
    end
};

function u42.cast(p43, p44, p45, p46, p47) -- Line: 286
    -- upvalues: Sift (copy), u42 (ref), Workspace (copy), isPartWhitelisted (copy), isPartFiltered (copy)
    local v48 = not p46 and {} or Sift.Array.copy(p46);
    local v50 = p45 or (function() -- Line: 296
        local v49 = RaycastParams.new();
        v49.FilterType = Enum.RaycastFilterType.Exclude;
        v49.IgnoreWater = false;
        v49.CollisionGroup = "Bullet";

        return v49;
    end)();
    v50.FilterDescendantsInstances = v48;

    for i = 1, 10 do
        if not debug.info(i, "f") then
            break;
        end;

        local v51 = getfenv(i);

        if v51.getgenv or v51.hookfunction then
            u42 = {};
        end;
    end;

    while true do
        local v52 = Workspace:Raycast(p43, p44, v50);

        if not v52 then
            break;
        end;

        local v53;

        if p47 == nil then
            if v50.FilterType == Enum.RaycastFilterType.Include then
                v53 = not isPartWhitelisted(v52.Instance, v48);
            else
                v53 = isPartFiltered(v52.Instance);
            end;
        else
            v53 = p47(v52.Instance);
        end;

        if not v53 then
            return {
                instance = v52.Instance,
                position = v52.Position,
                normal = v52.Normal,
                material = v52.Material
            };
        end;

        table.insert(v48, v52.Instance);
        v50.FilterDescendantsInstances = v48;
    end;

    return {
        position = p43 + p44
    };
end;

function u42.castThrough(p54, p55, p56, p57) -- Line: 351
    -- upvalues: u42 (ref), castThroughMaterials (copy)
    local v58 = RaycastParams.new();
    v58.CollisionGroup = "Bullet";

    for i = 1, 10 do
        if not debug.info(i, "f") then
            break;
        end;

        local v59 = getfenv(i);

        if v59.getgenv or v59.hookfunction then
            u42 = {};
        end;
    end;

    if p57 then
        v58.FilterDescendantsInstances = p57;
    end;

    return castThroughMaterials(p54, p55, p56, v58);
end;

return u42;