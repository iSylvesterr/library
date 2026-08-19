-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1 = {};
local u8 = {
    ModelAdded = require(ReplicatedStorage.Library.Modules.Packages.Signal).new(),

    ApplyModelHidden = function(p2, p3) -- Line: 22, Name: ApplyModelHidden
        -- upvalues: Asserts (copy)
        Asserts.Model(p2);
        Asserts.boolean(p3);

        for _, descendant in ipairs(p2:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.LocalTransparencyModifier = p3 and 1 or 0;
            end;
        end;
    end,

    ResolveModel = function(p4) -- Line: 33, Name: ResolveModel
        -- upvalues: Asserts (copy), Workspace (copy)
        Asserts.string(p4);
        local v5 = Workspace:FindFirstChild(p4);

        if v5 == nil then
            return nil;
        end;

        local v6 = v5:IsA("Model");
        local v7 = `Workspace area egg {p4} must be a Model`;
        assert(v6, v7);

        return v5;
    end
};

function u8.SetHidden(p9, p10) -- Line: 43
    -- upvalues: Asserts (copy), u1 (copy), Workspace (copy), u8 (copy)
    Asserts.string(p9);
    Asserts.boolean(p10);

    if p10 then
        u1[p9] = true;
    else
        u1[p9] = nil;
    end;

    for _, child in ipairs(Workspace:GetChildren()) do
        if child.Name == p9 and child:IsA("Model") then
            u8.ApplyModelHidden(child, p10);
        end;
    end;
end;

function u8.Start() -- Line: 59
    -- upvalues: Workspace (copy), u1 (copy), u8 (copy)
    Workspace.ChildAdded:Connect(function(p11) -- Line: 60
        -- upvalues: Workspace (ref), u1 (ref), u8 (ref)
        if not p11:IsA("Model") or p11.Parent ~= Workspace then
            return;
        end;

        if u1[p11.Name] == true then
            u8.ApplyModelHidden(p11, true);
        end;

        u8.ModelAdded:Fire(p11);
    end);
end;

return table.freeze(u8);