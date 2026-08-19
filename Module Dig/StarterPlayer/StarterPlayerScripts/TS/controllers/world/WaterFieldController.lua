-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local CollectionService = v1.CollectionService;
local Workspace = v1.Workspace;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 23, Name: __tostring
        return "WaterFieldController";
    end
});
u2.__index = u2;

function u2.new(...) -- Line: 28
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4) -- Line: 32
    p4.sourceTiles = {};
    p4.sourceKeys = {};
    p4.tiles = {};
    p4.pool = {};
    p4.pending = {};
    p4.animated = {};
    p4.tileSize = 0;
    p4.originX = 0;
    p4.originY = 0;
    p4.originZ = 0;
    p4.cameraX = 0;
    p4.cameraZ = 0;
    p4.hasCameraTile = false;
    p4.sinceUpdate = 0;
    p4.elapsed = 0;
end;

function u2.registerTile(p5, p6) -- Line: 49
    if not p5.template then
        p5:createTemplate(p6);
    end;

    local v7 = p5:encode(p5:tileIndex(p6.Position.X, p5.originX), p5:tileIndex(p6.Position.Z, p5.originZ));
    p5.sourceTiles[v7] = p6;
    p5.sourceKeys[p6] = v7;
    local v8 = p5.tiles[v7];

    if v8 then
        p5:release(v7, v8);
    end;

    p5:refreshAnimated();
end;

function u2.unregisterTile(p9, p10) -- Line: 66
    local v11 = p9.sourceKeys[p10];

    if v11 == nil then
        return nil;
    end;

    p9.sourceKeys[p10] = nil;
    p9.sourceTiles[v11] = nil;

    if p9:isInRange(v11) then
        table.insert(p9.pending, v11);
    end;

    p9:refreshAnimated();
end;

function u2.onTick(p12, p13) -- Line: 83
    -- upvalues: Workspace (copy)
    local template = p12.template;

    if not template then
        return nil;
    end;

    p12.sinceUpdate = p12.sinceUpdate + p13;

    if p12.sinceUpdate < 0.2 then
        return nil;
    end;

    p12.sinceUpdate = 0;
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return nil;
    end;

    local Position = CurrentCamera.CFrame.Position;
    local v14 = p12:tileIndex(Position.X, p12.originX);
    local v15 = p12:tileIndex(Position.Z, p12.originZ);

    if not p12.hasCameraTile or (v14 ~= p12.cameraX or v15 ~= p12.cameraZ) then
        p12.cameraX = v14;
        p12.cameraZ = v15;
        p12.hasCameraTile = true;
        p12:rebuild();
    end;

    p12:spawnPending(template);
end;

function u2.onRender(p16, p17) -- Line: 108
    if #p16.animated == 0 then
        return nil;
    end;

    p16.elapsed = p16.elapsed + p17;
    local v18 = p16.elapsed * 0.6;
    local v19 = v18 + math.sin(p16.elapsed * 0.9 * 0.3) * 0.4 + math.sin(p16.elapsed * 0.9 * 0.71) * 0.13999999999999999;
    local v20 = v18 * 0.5 + math.cos(p16.elapsed * 0.9 * 0.23) * 0.4 + math.cos(p16.elapsed * 0.9 * 0.57) * 0.13999999999999999;

    for _, v in p16.animated do
        v.OffsetStudsU = v19;
        v.OffsetStudsV = v20;
    end;
end;

function u2.createTemplate(p21, p22) -- Line: 121
    -- upvalues: CollectionService (copy), Workspace (copy)
    p21.tileSize = p22.Size.X;
    p21.originX = p22.Position.X;
    p21.originY = p22.Position.Y;
    p21.originZ = p22.Position.Z;
    local v23 = p22:Clone();
    CollectionService:RemoveTag(v23, "Water");
    v23.Name = "WaterTile";
    v23.Anchored = true;
    v23.CanCollide = false;
    v23.CanQuery = false;
    v23.CanTouch = false;
    v23.CastShadow = false;

    for _, child in v23:GetChildren() do
        if not child:IsA("Texture") or child.Face ~= Enum.NormalId.Top then
            child:Destroy();
        end;
    end;

    p21.template = v23;
    local Folder = Instance.new("Folder");
    Folder.Name = "WaterField";
    Folder.Parent = Workspace;
    p21.field = Folder;
end;

function u2.rebuild(p24) -- Line: 145
    table.clear(p24.pending);

    for i = 3, 0, -1 do
        local v25 = -i;
        local v26 = false;

        while true do
            if true then
                if v26 then
                    v25 = v25 + 1;
                else
                    v26 = true;
                end;
            end;

            if v25 > i then
                break;
            end;

            local v27 = -i;
            local v28 = false;

            while true do
                if true then
                    if v28 then
                        v27 = v27 + 1;
                    else
                        v28 = true;
                    end;
                end;

                if v27 > i then
                    break;
                end;

                local v29 = math.abs(v25);
                local v30 = math.abs(v27);

                if math.max(v29, v30) == i then
                    local v31 = p24:encode(p24.cameraX + v25, p24.cameraZ + v27);

                    if p24.sourceTiles[v31] == nil and p24.tiles[v31] == nil then
                        table.insert(p24.pending, v31);
                    end;
                end;
            end;
        end;
    end;

    for i, v in p24.tiles do
        if not p24:isInRange(i) then
            p24:release(i, v);
        end;
    end;

    p24:refreshAnimated();
end;

function u2.spawnPending(p32, p33) -- Line: 192
    local v34 = 0;

    while v34 < 6 do
        local pending = p32.pending;
        local v35 = #pending;
        local v36 = pending[v35];
        pending[v35] = nil;

        if v36 == nil then
            return nil;
        end;

        if p32.sourceTiles[v36] == nil and p32.tiles[v36] == nil then
            local v37 = math.floor(v36 / 4096) - 2048;
            local v38 = v36 % 4096 - 2048;
            local pool = p32.pool;
            local v39 = #pool;
            local v40 = pool[v39];
            pool[v39] = nil;

            if v40 == nil then
                v40 = p33:Clone();
            end;

            v40.Position = Vector3.new(p32.originX + v37 * p32.tileSize, p32.originY, p32.originZ + v38 * p32.tileSize);
            v40.Parent = p32.field;
            p32.tiles[v36] = v40;

            if math.abs(v37 - p32.cameraX) <= 1 and math.abs(v38 - p32.cameraZ) <= 1 then
                p32:collectTextures(v40);
            end;

            v34 = v34 + 1;
        end;
    end;
end;

function u2.release(p41, p42, p43) -- Line: 230
    p41.tiles[p42] = nil;
    p43.Parent = nil;
    table.insert(p41.pool, p43);
end;

function u2.refreshAnimated(p44) -- Line: 239
    table.clear(p44.animated);

    if not p44.hasCameraTile then
        return nil;
    end;

    for i = -1, 1 do
        for i2 = -1, 1 do
            local v45 = p44:encode(p44.cameraX + i, p44.cameraZ + i2);
            local v46 = p44.sourceTiles[v45] or p44.tiles[v45];

            if v46 then
                p44:collectTextures(v46);
            end;
        end;
    end;
end;

function u2.collectTextures(p47, p48) -- Line: 254
    for _, child in p48:GetChildren() do
        if child:IsA("Texture") then
            table.insert(p47.animated, child);
        end;
    end;
end;

function u2.isInRange(p49, p50) -- Line: 262
    if not p49.hasCameraTile then
        return false;
    end;

    local v51 = math.floor(p50 / 4096) - 2048;
    local v52 = p50 % 4096 - 2048;
    local v53;

    if math.abs(v51 - p49.cameraX) <= 3 then
        v53 = math.abs(v52 - p49.cameraZ) <= 3;
    else
        v53 = false;
    end;

    return v53;
end;

function u2.tileIndex(p54, p55, p56) -- Line: 270
    return math.round((p55 - p56) / p54.tileSize);
end;

function u2.encode(p57, p58, p59) -- Line: 273
    return (p58 + 2048) * 4096 + (p59 + 2048);
end;

Reflect.defineMetadata(u2, "identifier", "client/controllers/world/WaterFieldController@WaterFieldController");
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnTick", "$:flamework@OnRender" });
Reflect.decorate(u2, "$:flamework@Controller", Controller, { {} });

return {
    WATER_TAG = "Water",
    WaterFieldController = u2
};