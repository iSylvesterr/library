-- Decompiled with Potassium's decompiler.

local Node = require(script:WaitForChild("Node"));
local Edge = require(script:WaitForChild("Edge"));
local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 24
    -- upvalues: u1 (copy)
    local v2 = setmetatable({}, u1);
    v2.Nodes = {};
    v2.Edges = {};
    v2.NodeEdges = {};

    return v2;
end;

function u1.GetNode(p3, p4) -- Line: 34
    for _, v in p3.Nodes do
        for _, v2 in v.Data do
            if p4 == v2 then
                return v;
            end;
        end;
    end;
end;

function u1.GetEdgesForNode(p5, p6) -- Line: 46
    return p5.NodeEdges[p6];
end;

function u1.GetEdgeForNodes(p7, p8, p9) -- Line: 50
    for _, v in p7:GetEdgesForNode(p8) do
        if v.Node0 == p9 or v.Node1 == p9 then
            return v;
        end;
    end;
end;

function u1.AddNode(p10, p11) -- Line: 62
    -- upvalues: Node (copy)
    local v12 = Node.new(p11);
    table.insert(p10.Nodes, v12);
    p10.NodeEdges[v12] = {};

    return v12;
end;

function u1.RemoveNode(p13, p14) -- Line: 70
    for _, v in p13:GetEdgesForNode(p14) do
        p13:RemoveEdge(v);
    end;

    p13.NodeEdges[p14] = nil;

    for i, v in p13.Nodes do
        if v == p14 then
            table.remove(p13.Nodes, i);

            return true;
        end;
    end;

    return false;
end;

function u1.AddEdge(p15, p16, p17, p18) -- Line: 89
    -- upvalues: Edge (copy)
    assert(p16 ~= p17, "Can\'t make an edge between the same node!");

    for _, v in p15:GetEdgesForNode(p16) do
        if v:HasNode(p17) then
            return;
        end;
    end;

    local v19 = Edge.new(p16, p17, p18);
    table.insert(p15.Edges, v19);
    table.insert(p15.NodeEdges[p16], v19);
    table.insert(p15.NodeEdges[p17], v19);

    return v19;
end;

function u1.RemoveEdge(p20, p21) -- Line: 110
    for i, v in p20.Edges do
        if v == p21 then
            table.remove(p20.Edges, i);

            return true;
        end;
    end;

    for i, v in p20.NodeEdges do
        for i2, v2 in v do
            if p21 == v2 then
                table.remove(p20.NodeEdges[i], i2);
            end;
        end;
    end;

    return false;
end;

return u1;