-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local v1 = {};

local function attrName(p2) -- Line: 12
    return "Debug_" .. p2;
end;

function v1.IsEnabled(p3) -- Line: 16
    -- upvalues: ReplicatedStorage (copy)
    return ReplicatedStorage:GetAttribute("Debug_" .. p3) == true;
end;

function v1.SetEnabled(p4, p5) -- Line: 21
    -- upvalues: RunService (copy), ReplicatedStorage (copy)
    if RunService:IsServer() or RunService:IsClient() then
        ReplicatedStorage:SetAttribute("Debug_" .. p4, p5);
    end;
end;

function v1.GetAttributeName(p6) -- Line: 29
    return "Debug_" .. p6;
end;

return v1;