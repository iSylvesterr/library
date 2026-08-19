-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = {};

function v1.Init(p3) -- Line: 6
    for _, child in script:GetChildren() do
        require(child);
    end;
end;

function v1.GetMutationModule(p4, p5) -- Line: 12
    -- upvalues: u2 (copy)
    if u2[p5] then
        return u2[p5];
    end;

    local v6 = script:FindFirstChild(p5);

    if not v6 then
        return nil;
    end;

    u2[p5] = require(v6);

    return u2[p5];
end;

function v1.ApplyMutation(p7, p8) -- Line: 26
    local v9 = p8:GetAttribute("Mutation");

    if not v9 then
        return;
    end;

    local v10 = p7:GetMutationModule(v9);

    if v10 and v10.ApplyMutationEffect then
        v10.ApplyMutationEffect(p8);
    end;
end;

function v1.SetupListener(u11, p12) -- Line: 36
    for _, v in p12:QueryDescendants("[$Mutation]") do
        u11:ApplyMutation(v);
    end;

    p12.DescendantAdded:Connect(function(u13) -- Line: 41
        -- upvalues: u11 (copy)
        if not (u13:IsA("Model") or u13:IsA("Tool")) then
            return;
        end;

        if u13:GetAttribute("Mutation") then
            u11:ApplyMutation(u13);
        end;

        u13:GetAttributeChangedSignal("Mutation"):Connect(function() -- Line: 47
            -- upvalues: u13 (copy), u11 (ref)
            if u13:GetAttribute("Mutation") then
                u11:ApplyMutation(u13);
            end;
        end);
    end);
end;

function v1.Start(p14) -- Line: 55
    p14:SetupListener(workspace);
end;

return v1;