-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local CollectionService = v1.CollectionService;
local Players = v1.Players;
local Workspace = v1.Workspace;
local DIG_ZONE_TAG = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Shovels").DIG_ZONE_TAG;
local u2 = RaycastParams.new();
u2.FilterType = Enum.RaycastFilterType.Exclude;
u2.IgnoreWater = true;
local u3 = RaycastParams.new();
u3.FilterType = Enum.RaycastFilterType.Include;
u3.IgnoreWater = true;
local u4 = nil;
local u5 = nil;

local function invalidateZones() -- Line: 21
    -- upvalues: u4 (ref), u5 (ref)
    u4 = nil;
    u5 = nil;
end;

CollectionService:GetInstanceAddedSignal(DIG_ZONE_TAG):Connect(invalidateZones);
CollectionService:GetInstanceRemovedSignal(DIG_ZONE_TAG):Connect(invalidateZones);

local function digZones() -- Line: 27
    -- upvalues: u4 (ref), CollectionService (copy), DIG_ZONE_TAG (copy), u3 (copy)
    if u4 == nil then
        local function _(p6) -- Line: 32
            return p6:IsA("BasePart");
        end;

        local v7 = 0;
        local v8 = {};

        for i, v in CollectionService:GetTagged(DIG_ZONE_TAG) do
            local _ = i - 1;

            if v:IsA("BasePart") == true then
                v7 = v7 + 1;
                v8[v7] = v;
            end;
        end;

        u4 = v8;
        u3.FilterDescendantsInstances = u4;
    end;

    return u4;
end;

local function probeTop() -- Line: 48
    -- upvalues: u5 (ref), digZones (copy)
    if u5 == nil then
        local v9 = (-1 / 0);

        for _, v in digZones() do
            v9 = math.max(v9, v.Position.Y + v.Size.Y * 0.5);
        end;

        u5 = v9 + 4;
    end;

    return u5;
end;

local function dropToGround(p10, p11) -- Line: 58
    -- upvalues: digZones (copy), Players (copy), u2 (copy), Workspace (copy)
    local v12 = p11.Size.Y * 0.5 + 4;
    local v13 = p11.Position.Y + v12;
    local v14 = {};
    local v15 = #v14;
    local v16 = digZones();
    local v17 = #v16;
    table.move(v16, 1, v17, v15 + 1, v14);

    local function _(p18) -- Line: 70
        return p18.Character;
    end;

    local v19 = 0;
    local v20 = {};

    for i, v in Players:GetPlayers() do
        local _ = i - 1;
        local Character = v.Character;

        if Character ~= nil then
            v19 = v19 + 1;
            v20[v19] = Character;
        end;
    end;

    table.move(v20, 1, #v20, v15 + v17 + 1, v14);
    u2.FilterDescendantsInstances = v14;
    local v21 = Workspace:Raycast(Vector3.new(p10.X, v13, p10.Z), Vector3.new(0, -(v12 * 2), 0), u2);

    if v21 then
        return v21.Position;
    end;

    return p10;
end;

local function digZoneAt(p22) -- Line: 90
    -- upvalues: digZones (copy), probeTop (copy), Workspace (copy), u3 (copy)
    if #digZones() == 0 then
        return nil;
    end;

    local v23 = probeTop();

    if v23 < p22.Y then
        return nil;
    end;

    local v24 = Workspace:Raycast(Vector3.new(p22.X, v23, p22.Z), Vector3.new(0, p22.Y - 4 - v23, 0), u3);

    if v24 ~= nil then
        v24 = v24.Instance;
    end;

    if v24 == nil or not v24:IsA("BasePart") then
        return nil;
    end;

    local Y = v24.CFrame:PointToObjectSpace(p22).Y;

    if math.abs(Y) <= v24.Size.Y * 0.5 then
        return v24;
    end;

    return nil;
end;

return {
    digZoneParts = function() -- Line: 87, Name: digZoneParts
        -- upvalues: digZones (copy)
        return digZones();
    end,

    digZoneAt = digZoneAt,

    randomDigZonePoint = function(p25) -- Line: 109, Name: randomDigZonePoint
        -- upvalues: digZoneAt (copy), dropToGround (copy)
        if #p25 == 0 then
            return nil;
        end;

        local v26 = 0;

        for _, v in p25 do
            v26 = v26 + v.Size.X * v.Size.Z;
        end;

        for _ = 0, 15 do
            local v27 = math.random() * v26;
            local v28 = p25[#p25];

            for _, v in p25 do
                v27 = v27 - v.Size.X * v.Size.Z;

                if v27 <= 0 then
                    v28 = v;
                    break;
                end;
            end;

            local v29 = v28.Size * 0.5;
            local v30 = math.min(3, v29.X * 0.5);
            local v31 = math.min(3, v29.Z * 0.5);
            local CFrame = v28.CFrame;
            local v32 = (math.random() * 2 - 1) * (v29.X - v30);
            local v33 = (math.random() * 2 - 1) * (v29.Z - v31);
            local v34 = CFrame:PointToWorldSpace((Vector3.new(v32, 0, v33)));

            if digZoneAt(v34) == v28 then
                return {
                    position = dropToGround(v34, v28),
                    zone = v28
                };
            end;
        end;

        return nil;
    end,

    digZonePointAhead = function(p35, p36, p37, p38) -- Line: 141, Name: digZonePointAhead
        -- upvalues: digZones (copy), digZoneAt (copy), dropToGround (copy)
        if #digZones() == 0 then
            return nil;
        end;

        local v39 = Vector3.new(p36.X, 0, p36.Z);

        if v39.Magnitude < 0.01 then
            return nil;
        end;

        local v40 = math.atan2(v39.Z, v39.X);
        local v41 = false;
        local v42 = 0;

        while true do
            if v41 then
                v42 = v42 + 1;
            else
                v41 = true;
            end;

            if v42 >= p38 then
                return nil;
            end;

            local v43 = v40 + (v42 % 2 == 0 and 1 or -1) * math.ceil(v42 / 2) * 0.3839724354387525;
            local v44 = math.cos(v43) * p37;
            local v45 = math.sin(v43) * p37;
            local v46 = p35 + Vector3.new(v44, 0, v45);
            local v47 = digZoneAt(v46);

            if v47 then
                return {
                    position = dropToGround(v46, v47),
                    zone = v47
                };
            end;
        end;
    end,

    digZonePointNear = function(p48, p49, p50, p51) -- Line: 178, Name: digZonePointNear
        -- upvalues: digZones (copy), digZoneAt (copy), dropToGround (copy)
        if #digZones() == 0 then
            return nil;
        end;

        local v52 = p49 * p49;
        local v53 = p50 * p50 - v52;
        local v54 = false;
        local v55 = 0;

        while true do
            if v54 then
                v55 = v55 + 1;
            else
                v54 = true;
            end;

            if v55 >= p51 then
                return nil;
            end;

            local v56 = math.random() * 3.141592653589793 * 2;
            local v57 = v52 + math.random() * v53;
            local v58 = math.sqrt(v57);
            local v59 = math.cos(v56) * v58;
            local v60 = math.sin(v56) * v58;
            local v61 = p48 + Vector3.new(v59, 0, v60);
            local v62 = digZoneAt(v61);

            if v62 then
                return {
                    position = dropToGround(v61, v62),
                    zone = v62
                };
            end;
        end;
    end
};