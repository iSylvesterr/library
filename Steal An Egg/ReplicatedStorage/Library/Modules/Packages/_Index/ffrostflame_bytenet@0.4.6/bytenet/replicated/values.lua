-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local replicatedValue = require(script.Parent.replicatedValue);
local u1 = RunService:IsServer() and "server" or "client";
local u2 = nil;
local u3 = {};

return {
    start = function() -- Line: 14, Name: start
        -- upvalues: u1 (copy), ReplicatedStorage (copy), u2 (ref)
        if u1 ~= "server" then
            if u1 == "client" then
                u2 = ReplicatedStorage:WaitForChild("BytenetStorage");
            end;

            return;
        end;

        local Folder = Instance.new("Folder");
        Folder.Name = "BytenetStorage";
        Folder.Parent = ReplicatedStorage;
        u2 = Folder;
    end,

    access = function(p4) -- Line: 26, Name: access
        -- upvalues: u3 (copy), u1 (copy), u2 (ref), replicatedValue (copy)
        if u3[p4] then
            return u3[p4];
        end;

        if u1 == "client" then
            local v5 = u2:FindFirstChild(p4);

            if v5 and v5:IsA("StringValue") then
                local v6 = replicatedValue(v5);
                u3[p4] = v6;

                return v6;
            end;
        elseif u1 == "server" then
            local StringValue = Instance.new("StringValue");
            StringValue.Name = p4;
            StringValue.Parent = u2;
            local v7 = replicatedValue(StringValue);
            u3[p4] = v7;

            return v7;
        end;

        return u3[p4];
    end
};