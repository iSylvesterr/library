-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Sentries = Workspace.__OBJECTS.Sentries;
local v1 = Sentries:IsA("Folder");
assert(v1, "Workspace.__OBJECTS.Sentries must be a Folder");

return function(p2, p3) -- Line: 23
    -- upvalues: Asserts (copy), Sentries (copy)
    Asserts.Vector3(p2);
    Asserts.number(p3);

    for _, child in ipairs(Sentries:GetChildren()) do
        if child:IsA("Model") and (child:GetPivot().Position - p2).Magnitude <= p3 then
            child:Destroy();
        end;
    end;
end;