-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = nil;
local u2 = nil;

local function collectFromFolder(p3, p4) -- Line: 35
    if not p3 then
        return;
    end;

    for _, child in p3:GetChildren() do
        if child:IsA("StringValue") then
            local v5 = tonumber(string.match(child.Value, "rbxassetid://(%d+)"));

            if v5 and v5 > 0 then
                p4[v5] = true;
            end;
        end;
    end;
end;

local function build() -- Line: 46
    -- upvalues: ReplicatedStorage (copy), collectFromFolder (copy), u1 (ref), u2 (ref)
    local v6 = {};
    local SeedData = ReplicatedStorage.SharedModules:FindFirstChild("SeedData");

    if SeedData then
        collectFromFolder(SeedData:FindFirstChild("SeedImages"), v6);
        collectFromFolder(SeedData:FindFirstChild("FruitImages"), v6);
        collectFromFolder(SeedData:FindFirstChild("PlantImages"), v6);
    end;

    collectFromFolder(ReplicatedStorage.SharedModules:FindFirstChild("GearImages"), v6);
    local v7 = {};

    for i in v6 do
        table.insert(v7, i);
    end;

    if #v7 == 0 then
        v6[81520753924742] = true;
        table.insert(v7, 81520753924742);
    end;

    u1 = v7;
    u2 = v6;
end;

local function ensureBuilt() -- Line: 71
    -- upvalues: u1 (ref), u2 (ref), build (copy)
    if not (u1 and u2) then
        build();
    end;

    return u1, u2;
end;

return table.freeze({
    FALLBACK_ICON_ID = 81520753924742,
    DEFAULT_ICON_ID = 81520753924742,

    GetPool = function() -- Line: 84, Name: GetPool
        -- upvalues: u1 (ref), u2 (ref), build (copy)
        if not (u1 and u2) then
            build();
        end;

        return u1;
    end,

    Random = function() -- Line: 89, Name: Random
        -- upvalues: u1 (ref), u2 (ref), build (copy)
        if not (u1 and u2) then
            build();
        end;

        local v8 = u1;

        return v8[math.random(#v8)];
    end,

    IsPoolIcon = function(p9) -- Line: 94, Name: IsPoolIcon
        -- upvalues: u1 (ref), u2 (ref), build (copy)
        if typeof(p9) ~= "number" then
            return false;
        end;

        if not (u1 and u2) then
            build();
        end;

        return u2[p9] == true;
    end
});