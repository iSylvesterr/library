-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local Modules = game.ReplicatedStorage.Client:WaitForChild("Modules");
require(Modules:WaitForChild("NodeGraph"));
require(Modules:WaitForChild("NodeGraph"):WaitForChild("Node"));

local function getRecordLength(p1, p2) -- Line: 22
    local v3 = 0;

    for i, v in p1 do
        if p2(i, v) then
            v3 = v3 + 1;
        end;
    end;

    return v3;
end;

local function filterHashmap(p4, p5) -- Line: 34
    local v6 = {};

    for i, v in p4 do
        if p5(i, v) then
            v6[i] = v;
        end;
    end;

    return v6;
end;

local function getLowestKey(p7) -- Line: 46
    local v8 = (1 / 0);
    local v9 = nil;

    for i, v in p7 do
        if v < v8 then
            v9 = i;
            v8 = v;
        end;
    end;

    return v9;
end;

return function(u10, u11, u12) -- Line: 65, Name: dijkstra
    -- upvalues: filterHashmap (copy)
    if u11 == u12 then
        return {
            {
                Node = u11,
                Position = u11.Data.Position
            }
        };
    end;

    local u13 = u11;
    local u14 = {};
    local u15 = {};
    local u16 = {};
    local u17 = {};

    for _, v in u10.Nodes do
        u14[v] = (1 / 0);
        u15[v] = true;
    end;

    u14[u11] = 0;

    local function getUnvisitedNeighbors(p18) -- Line: 86
        -- upvalues: u10 (copy), u17 (copy), u15 (copy)
        local v19 = {};

        for _, v in u10:GetEdgesForNode(p18) do
            local Node0 = v.Node0;

            if Node0 == p18 then
                Node0 = v.Node1;
            end;

            if u17[Node0] ~= true and u15[Node0] == true then
                table.insert(v19, {
                    Node = Node0,
                    Weight = v.Weight
                });
            end;
        end;

        return v19;
    end;

    local function recursiveStepGraph() -- Line: 112
        -- upvalues: filterHashmap (ref), u14 (copy), u17 (copy), u13 (ref), u12 (copy), u15 (copy), getUnvisitedNeighbors (copy), u16 (copy), recursiveStepGraph (copy)
        local v20 = (1 / 0);
        local v21 = nil;

        for i, v in filterHashmap(u14, function(p22, p23) -- Line: 113
            -- upvalues: u17 (ref)
            return u17[p22] ~= true;
        end) do
            if v < v20 then
                v21 = i;
                v20 = v;
            end;
        end;

        u13 = v21;

        if not u13 then
            warn("no nodes were found that weren\'t in the finished hashmap");

            return table.clone(u14);
        end;

        if u13 == u12 then
            return table.clone(u14);
        end;

        local v24 = u14[u13];
        u15[u13] = false;

        for _, v in getUnvisitedNeighbors(u13) do
            local v25 = v24 + v.Weight;

            if v25 < u14[v.Node] then
                u14[v.Node] = v25;
                u16[v.Node] = u13;
            end;
        end;

        u17[u13] = true;

        local function _(p26, p27) -- Line: 145
            return p27;
        end;

        local v28 = 0;

        for _, v in u15 do
            if v then
                v28 = v28 + 1;
            end;
        end;

        if v28 > 0 then
            return recursiveStepGraph();
        end;

        return table.clone(u14);
    end;

    local u29 = recursiveStepGraph();
    local u30 = u12;
    local u31 = { u12 };

    local function recursivePopulateReversePath() -- Line: 161
        -- upvalues: u10 (copy), u30 (ref), u29 (copy), u31 (copy), u11 (copy), recursivePopulateReversePath (copy)
        local v32 = {};

        for _, v in u10:GetEdgesForNode(u30) do
            if v.Node0 == u30 then
                v32[v.Node1] = u29[v.Node1];
            else
                v32[v.Node0] = u29[v.Node0];
            end;
        end;

        local v33 = (1 / 0);
        local v34 = nil;

        for i, v in v32 do
            if v < v33 then
                v34 = i;
                v33 = v;
            end;
        end;

        u30 = v34;

        if not u30 then
            warn("getLowestKeyWithIncludeList() returned no closest key!!!");
            print(v32);
            print(u29);
        end;

        table.insert(u31, u30);

        if u30 ~= u11 then
            recursivePopulateReversePath();
        end;
    end;

    recursivePopulateReversePath();
    local v35 = {};

    for i = #u31, 1, -1 do
        local v36 = {
            Node = u31[i],
            Position = u31[i].Data.Position
        };
        local v37;

        if i > 1 then
            v37 = u10:GetEdgeForNodes(u31[i], u31[i - 1]) or false;
        else
            v37 = false;
        end;

        v36.Edge = v37;
        table.insert(v35, v36);
    end;

    return v35;
end;