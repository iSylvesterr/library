-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Mutations = require(ReplicatedStorage.Library.Modules.Mutations);

local function applyMutationVisuals(p1, p2) -- Line: 8
    -- upvalues: Mutations (copy)
    local v3 = Mutations.Exists(p2);
    local v4 = `Mutation {p2} does not exist`;
    assert(v3, v4);
    p1.Image = assert(Mutations.GetMutation(p2)).Icon or "";
end;

return function(p5, p6, p7) -- Line: 14
    -- upvalues: Asserts (copy), Mutations (copy)
    local v8 = assert(p5:FindFirstChild("icon"));
    v8.Visible = false;
    Asserts.array.string(p7);

    if #p7 == 0 then
        return;
    end;

    for _, v in ipairs(p7) do
        local v9 = v8:Clone();
        v9.Name = v;
        v9.Visible = true;
        local v10 = Mutations.Exists(v);
        local v11 = `Mutation {v} does not exist`;
        assert(v10, v11);
        v9.Image = assert(Mutations.GetMutation(v)).Icon or "";
        v9.Parent = p5;
    end;
end;