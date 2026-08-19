-- Decompiled with Potassium's decompiler.

local Library = game:GetService("ReplicatedStorage").Library;
local Network = require(Library.Client.Network);
require(Library.Items.AbstractItem);
local ExistCountUtil = require(Library.Util.ExistCountUtil);
local v1 = {};
local u2 = {};

function v1.Get(p3) -- Line: 25
    -- upvalues: ExistCountUtil (copy), u2 (copy)
    return u2[ExistCountUtil.hashKey(p3.Class.Name, p3:StackKey())] or 0;
end;

function v1.GetByClassAndStackKey(p4, p5) -- Line: 32
    -- upvalues: ExistCountUtil (copy), u2 (copy)
    return u2[ExistCountUtil.hashKey(p4, p5)] or 0;
end;

Network.Fired(Network.NET_MAP.ExistCounts.UPDATE):Connect(function(p6) -- Line: 40
    -- upvalues: ExistCountUtil (copy), u2 (copy)
    local v7 = ExistCountUtil.decode(p6);

    for i, v in pairs(v7) do
        u2[i] = v;
    end;
end);

return v1;