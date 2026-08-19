-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts");
local Modules = game.ReplicatedStorage.Client:WaitForChild("Modules");
local NodeGraph = require(Modules:WaitForChild("NodeGraph"));

return function(p1, p2) -- Line: 20, Name: graphFactory
    -- upvalues: NodeGraph (copy), CollectionService (copy)
    local v3 = NodeGraph.new();
    task.wait(3);
    local v4 = {};

    for _, v in CollectionService:GetTagged(p1) do
        v4[v] = v3:AddNode({
            Part = v,
            Position = v.Position
        });

        if not p2 then
            if v:IsA("BasePart") then
                v.Transparency = 1;
            end;

            for _, descendant in v:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Transparency = 1;
                elseif descendant:IsA("BillboardGui") then
                    descendant:Destroy();
                end;
            end;
        end;
    end;

    for i, v in v4 do
        local ConnectedNodes = i:FindFirstChild("ConnectedNodes");

        if ConnectedNodes then
            for _, child in ConnectedNodes:GetChildren() do
                local Value = child.Value;

                if Value then
                    if v == v4[Value] then
                        warn("Cannot make edge between the same node. Node name: PROBLEM_EDGE_SAME_NODE");
                        Value.Name = "PROBLEM_EDGE_SAME_NODE";
                        child.Name = "PROBLEM_EDGE_SAME_NODE";
                    elseif v4[Value] then
                        v3:AddEdge(v, v4[Value], (Value.Position - i.Position).Magnitude);
                    else
                        warn((`{Value.Name} is not a Node. Node name: PROBLEM_REF_NOT_NODE`));
                        child.Name = "PROBLEM_REF_NOT_NODE";
                        i.Name = "PROBLEM_REF_NOT_NODE";
                    end;
                else
                    warn((`No Value for connected node {child.Parent.Parent.Name}. Node name: PROBLEM_REF_NIL`));
                    Value.Name = "PROBLEM_REF_NIL";
                    child.Name = "PROBLEM_REF_NIL";
                    i.Name = "PROBLEM_REF_NIL";
                end;
            end;
        else
            warn((`No Configuration named "ConnectedNodes" exists in {i.Name}`));
        end;
    end;

    return v3;
end;