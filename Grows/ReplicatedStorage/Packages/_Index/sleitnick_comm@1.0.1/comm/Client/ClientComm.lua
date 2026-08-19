-- Decompiled with Potassium's decompiler.

local Parent = require(script.Parent);
require(script.Parent.Parent.Types);
local Util = require(script.Parent.Parent.Util);
local u1 = {};
u1.__index = u1;

function u1.new(p2, p3, p4) -- Line: 46
    -- upvalues: Util (copy), u1 (copy)
    assert(not Util.IsServer, "ClientComm must be constructed from the client");
    local v5 = typeof(p2) == "Instance";
    assert(v5, "Parent must be of type Instance");
    local v6 = p4 or Util.DefaultCommFolderName;
    local v7 = p2:WaitForChild(v6, Util.WaitForChildTimeout);
    assert(v7 ~= nil, "Could not find namespace for ClientComm in parent: " .. v6);
    local v8 = setmetatable({}, u1);
    v8._instancesFolder = v7;
    v8._usePromise = p3;

    return v8;
end;

function u1.GetFunction(p9, p10, p11, p12) -- Line: 95
    -- upvalues: Parent (copy)
    return Parent.GetFunction(p9._instancesFolder, p10, p9._usePromise, p11, p12);
end;

function u1.GetSignal(p13, p14, p15, p16) -- Line: 123
    -- upvalues: Parent (copy)
    return Parent.GetSignal(p13._instancesFolder, p14, p15, p16);
end;

function u1.GetProperty(p17, p18, p19, p20) -- Line: 165
    -- upvalues: Parent (copy)
    return Parent.GetProperty(p17._instancesFolder, p18, p19, p20);
end;

function u1.BuildObject(p21, p22, p23) -- Line: 192
    local v24 = {};
    local RF = p21._instancesFolder:FindFirstChild("RF");
    local RE = p21._instancesFolder:FindFirstChild("RE");
    local RP = p21._instancesFolder:FindFirstChild("RP");

    if RF then
        for _, child in RF:GetChildren() do
            if child:IsA("RemoteFunction") then
                local u25 = p21:GetFunction(child.Name, p22, p23);

                v24[child.Name] = function(p26, ...) -- Line: 203
                    -- upvalues: u25 (copy)
                    return u25(...);
                end;
            end;
        end;
    end;

    if RE then
        for _, child in RE:GetChildren() do
            if child:IsA("RemoteEvent") or child:IsA("UnreliableRemoteEvent") then
                v24[child.Name] = p21:GetSignal(child.Name, p22, p23);
            end;
        end;
    end;

    if RP then
        for _, child in RP:GetChildren() do
            if child:IsA("RemoteEvent") then
                v24[child.Name] = p21:GetProperty(child.Name, p22, p23);
            end;
        end;
    end;

    return v24;
end;

function u1.Destroy(p27) -- Line: 230
end;

return u1;