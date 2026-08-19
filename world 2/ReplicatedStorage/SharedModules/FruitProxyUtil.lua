-- Decompiled with Potassium's decompiler.

local WeightFormat = require(script.Parent.WeightFormat);
local v1 = {};

local function SetFruitAttributes(p2, p3) -- Line: 19
    -- upvalues: WeightFormat (copy)
    for i, v in p3 do
        p2:SetAttribute(i, v);
    end;

    p2:SetAttribute("HarvestedFruit", true);
    p2:SetAttribute("Fruit", p3.FruitName);
    p2:SetAttribute("Weight", p3.Weight);
    local v4 = WeightFormat.FormatGrams(p3.Weight or 0);
    local v5 = p3.Mutation and (` [{p3.Mutation}]` or "") or "";
    p2.Name = `{p3.FruitName}{v5} [{v4}]`;
end;

local Networking = require(script.Parent.Networking);

function v1.IsFruitProxy(p6) -- Line: 7
    local v7 = p6:IsA("Configuration") and p6:GetAttribute("FruitProxy") == true;

    return v7;
end;

function v1.IsFruitTool(p8) -- Line: 11
    local v9 = p8:IsA("Tool") and p8:GetAttribute("HarvestedFruit") == true;

    return v9;
end;

function v1.IsFruitInstance(p10) -- Line: 15
    local v11 = p10:IsA("Configuration") and p10:GetAttribute("FruitProxy") == true or p10:IsA("Tool") and p10:GetAttribute("HarvestedFruit") == true;

    return v11;
end;

v1.SetFruitAttributes = SetFruitAttributes;

function v1.CreateProxy(p12) -- Line: 32
    -- upvalues: SetFruitAttributes (copy)
    local Configuration = Instance.new("Configuration");
    Configuration:SetAttribute("FruitProxy", true);
    SetFruitAttributes(Configuration, p12);

    return Configuration;
end;

function v1.CreateTool(p13, p14) -- Line: 39
    -- upvalues: SetFruitAttributes (copy)
    local v15 = p13:Clone();
    SetFruitAttributes(v15, p14);

    return v15;
end;

function v1.RequestPromote(u16) -- Line: 47
    -- upvalues: Networking (copy)
    task.spawn(function() -- Line: 48
        -- upvalues: Networking (ref), u16 (copy)
        Networking.Backpack.PromoteFruit:Fire(u16);
    end);
end;

function v1.RequestDemote(u17) -- Line: 53
    -- upvalues: Networking (copy)
    task.spawn(function() -- Line: 54
        -- upvalues: Networking (ref), u17 (copy)
        Networking.Backpack.DemoteFruit:Fire(u17);
    end);
end;

v1.Pending = {
    Equip = nil,
    Slots = {}
};

return v1;