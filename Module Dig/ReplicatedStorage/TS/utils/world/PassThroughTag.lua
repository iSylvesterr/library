-- Decompiled with Potassium's decompiler.

local CollectionService = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").CollectionService;

local function tagPart(p1) -- Line: 5
    -- upvalues: CollectionService (copy)
    if not CollectionService:HasTag(p1, "Passthrough") then
        CollectionService:AddTag(p1, "Passthrough");
    end;
end;

return {
    PASS_THROUGH_CAMERA_TAG = "Passthrough",
    PassThroughTag = {
        applyToPart = function(p2) -- Line: 13, Name: applyToPart
            -- upvalues: CollectionService (copy)
            if not CollectionService:HasTag(p2, "Passthrough") then
                CollectionService:AddTag(p2, "Passthrough");
            end;
        end,

        applyToModel = function(p3) -- Line: 17, Name: applyToModel
            -- upvalues: CollectionService (copy)
            for _, descendant in p3:GetDescendants() do
                if descendant:IsA("BasePart") and not CollectionService:HasTag(descendant, "Passthrough") then
                    CollectionService:AddTag(descendant, "Passthrough");
                end;
            end;

            return p3.DescendantAdded:Connect(function(p4) -- Line: 23
                -- upvalues: CollectionService (ref)
                if p4:IsA("BasePart") and not CollectionService:HasTag(p4, "Passthrough") then
                    CollectionService:AddTag(p4, "Passthrough");
                end;
            end);
        end
    }
};