-- Decompiled with Potassium's decompiler.

local PropImages = script.Parent.PropImages;

local function getPropImage(p1) -- Line: 4
    -- upvalues: PropImages (copy)
    local v2 = PropImages:FindFirstChild(p1);

    return v2 and v2.Value or "";
end;

local v3 = {
    Data = {}
};

for _, child in game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Props"):GetChildren() do
    local Data = v3.Data;
    local v4 = {
        PropName = child.Name
    };
    local v5 = PropImages:FindFirstChild(child.Name);
    v4.IMG = v5 and v5.Value or "";
    v4.ExtraDataFilter = child:GetAttribute("ExtraDataFilter") == true;
    table.insert(Data, v4);
end;

return v3;