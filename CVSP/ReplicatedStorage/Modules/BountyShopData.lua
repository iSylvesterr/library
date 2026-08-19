-- Decompiled with Potassium's decompiler.

local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
local u1 = {
    Items = { {
            Type = "Totem",
            ItemName = "Totem Of Marrow"
        }, {
            Type = "Totem",
            ItemName = "Bounty Hunter Trophy"
        }, {
            Type = "Egg",
            ItemName = "Bounty Hunter Capybara Egg"
        } }
};
local u2 = {
    Totem = "TotemData",
    Egg = "EggData",
    Gear = "GearData"
};

function u1.getItemData(p3) -- Line: 26
    -- upvalues: Modules (copy), u2 (copy)
    local v4 = Modules:FindFirstChild(u2[p3.Type] or "");

    return v4 and v4:FindFirstChild(p3.ItemName) or nil;
end;

function u1.getCost(p5) -- Line: 32
    -- upvalues: u1 (copy)
    local v6 = u1.getItemData(p5);

    if v6 then
        v6 = v6:FindFirstChild("BountyTokenCost");
    end;

    return v6 and v6.Value or nil;
end;

function u1.getByName(p7) -- Line: 38
    -- upvalues: u1 (copy)
    for _, v in u1.Items do
        if v.ItemName == p7 then
            return v;
        end;
    end;

    return nil;
end;

return u1;