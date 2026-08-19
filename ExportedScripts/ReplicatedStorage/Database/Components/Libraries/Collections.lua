-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
require(script:WaitForChild("Types"));
local u2 = require(ReplicatedStorage.Packages.Signal).new();
v1.OnAvailableCollectionsUpdated = u2;
local u3 = nil;

local function UpdateAvailableCollections(p4) -- Line: 25
    -- upvalues: u3 (ref), HttpService (copy), u2 (copy)
    u3 = HttpService:JSONDecode(p4);

    if #u2:GetConnections() <= 0 then
        return;
    end;

    u2:Fire(u3);
end;

function v1.GetCollectionByName(p5) -- Line: 37
    -- upvalues: u3 (ref)
    for _, v in ipairs(u3) do
        if v.name == p5 then
            return v;
        end;
    end;

    return nil;
end;

function v1.ObserveAvailableCollections(p6) -- Line: 50
    -- upvalues: u2 (copy), u3 (ref)
    local u7 = u2:Connect(p6);

    if u3 then
        p6(u3);
    end;

    return function() -- Line: 57
        -- upvalues: u7 (copy)
        u7:Disconnect();
    end;
end;

if ReplicatedStorage:GetAttribute("AvailableCollections") then
    u3 = HttpService:JSONDecode((ReplicatedStorage:GetAttribute("AvailableCollections")));

    if #u2:GetConnections() > 0 then
        u2:Fire(u3);
    end;
end;

ReplicatedStorage:GetAttributeChangedSignal("AvailableCollections"):Connect(function() -- Line: 73
    -- upvalues: ReplicatedStorage (copy), u3 (ref), HttpService (copy), u2 (copy)
    local v8 = ReplicatedStorage:GetAttribute("AvailableCollections");

    if not v8 then
        return;
    end;

    u3 = HttpService:JSONDecode(v8);

    if #u2:GetConnections() <= 0 then
        return;
    end;

    u2:Fire(u3);
end);

return v1;