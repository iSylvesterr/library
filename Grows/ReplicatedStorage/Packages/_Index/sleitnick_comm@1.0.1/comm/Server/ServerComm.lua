-- Decompiled with Potassium's decompiler.

local Parent = require(script.Parent);
require(script.Parent.Parent.Types);
local Util = require(script.Parent.Parent.Util);
local u1 = {};
u1.__index = u1;

function u1.new(p2, p3) -- Line: 44
    -- upvalues: Util (copy), u1 (copy)
    assert(Util.IsServer, "ServerComm must be constructed from the server");
    local v4 = typeof(p2) == "Instance";
    assert(v4, "Parent must be of type Instance");
    local v5 = p3 or Util.DefaultCommFolderName;
    local v6 = not p2:FindFirstChild(v5);
    assert(v6, "Parent already has another ServerComm bound to namespace " .. v5);
    local v7 = setmetatable({}, u1);
    v7._instancesFolder = Instance.new("Folder");
    v7._instancesFolder.Name = v5;
    v7._instancesFolder.Parent = p2;

    return v7;
end;

function u1.BindFunction(p8, p9, p10, p11, p12) -- Line: 76
    -- upvalues: Parent (copy)
    return Parent.BindFunction(p8._instancesFolder, p9, p10, p11, p12);
end;

function u1.WrapMethod(p13, p14, p15, p16, p17) -- Line: 108
    -- upvalues: Parent (copy)
    return Parent.WrapMethod(p13._instancesFolder, p14, p15, p16, p17);
end;

function u1.CreateSignal(p18, p19, p20, p21, p22) -- Line: 146
    -- upvalues: Parent (copy)
    return Parent.CreateSignal(p18._instancesFolder, p19, p20, p21, p22);
end;

function u1.CreateProperty(p23, p24, p25, p26, p27) -- Line: 195
    -- upvalues: Parent (copy)
    return Parent.CreateProperty(p23._instancesFolder, p24, p25, p26, p27);
end;

function u1.Destroy(p28) -- Line: 207
    p28._instancesFolder:Destroy();
end;

return u1;