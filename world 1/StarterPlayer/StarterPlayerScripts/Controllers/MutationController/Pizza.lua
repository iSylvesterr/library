-- Decompiled with Potassium's decompiler.

local v1 = {};
game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local u2 = {};
local _ = script.VFX;

local function isInsideFruits(p3, p4) -- Line: 14
    local Parent = p3.Parent;

    while Parent and Parent ~= p4 do
        if Parent.Name == "Fruits" then
            return true;
        end;

        Parent = Parent.Parent;
    end;

    return false;
end;

function v1.ApplyMutationEffect(p5) -- Line: 27
    -- upvalues: u2 (copy), CollectionService (copy)
    if u2[p5] then
        return;
    end;

    CollectionService:AddTag(p5, "Pizza");
    local v6 = {};

    if p5:IsA("BasePart") then
        table.insert(v6, p5);
    end;

    for _, v in p5:QueryDescendants("BasePart") do
        table.insert(v6, v);
    end;

    table.sort(v6, function(p7, p8) -- Line: 43
        return p7.Position.Y > p8.Position.Y;
    end);
    local v9 = { Color3.fromRGB(255, 196, 144) };
    local v10 = { Color3.fromRGB(191, 18, 18), Color3.fromRGB(255, 227, 124), Color3.fromRGB(13, 191, 0) };

    for i = 1, #v6 do
        local v11 = v6[i];
        local v12 = math.floor(i / 4);
        local v13 = math.clamp(v12, 1, 3);

        if v13 == 1 then
            v11.Color = v9[v13];
        else
            v11.Color = v10[Random.new():NextInteger(1, #v10)];
        end;
    end;
end;

CollectionService:GetInstanceAddedSignal("Pizza"):Connect(v1.ApplyMutationEffect);

for _, v in CollectionService:GetTagged("Pizza") do
    task.spawn(v1.ApplyMutationEffect, v);
end;

return v1;