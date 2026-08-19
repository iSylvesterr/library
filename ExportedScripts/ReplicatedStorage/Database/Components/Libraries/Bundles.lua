-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
require(script:WaitForChild("Types"));
local u2 = require(ReplicatedStorage.Packages.Signal).new();
v1.OnActiveBundleUpdated = u2;
local u3 = nil;

local function UpdateActiveBundle(p4) -- Line: 28
    -- upvalues: u3 (ref), HttpService (copy), u2 (copy)
    u3 = HttpService:JSONDecode(p4);

    if #u2:GetConnections() <= 0 then
        return;
    end;

    u2:Fire(u3);
end;

function v1.GetActiveBundle() -- Line: 40
    -- upvalues: u3 (ref)
    return u3;
end;

function v1.ObserveActiveBundle(p5) -- Line: 46
    -- upvalues: u2 (copy), u3 (ref)
    local u6 = u2:Connect(p5);

    if u3 then
        p5(u3);
    end;

    return function() -- Line: 53
        -- upvalues: u6 (copy)
        u6:Disconnect();
    end;
end;

if ReplicatedStorage:GetAttribute("ActiveBundle") then
    u3 = HttpService:JSONDecode((ReplicatedStorage:GetAttribute("ActiveBundle")));

    if #u2:GetConnections() > 0 then
        u2:Fire(u3);
    end;
end;

ReplicatedStorage:GetAttributeChangedSignal("ActiveBundle"):Connect(function() -- Line: 69
    -- upvalues: ReplicatedStorage (copy), u3 (ref), HttpService (copy), u2 (copy)
    local v7 = ReplicatedStorage:GetAttribute("ActiveBundle");

    if not v7 then
        return;
    end;

    u3 = HttpService:JSONDecode(v7);

    if #u2:GetConnections() <= 0 then
        return;
    end;

    u2:Fire(u3);
end);

return v1;