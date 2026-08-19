-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local Client = game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Client");
local Save = require(Client.Save);

function v1.Owns(p2, p3) -- Line: 9
    -- upvalues: Players (copy), Save (copy)
    local v4 = Save.Get(p3 or Players.LocalPlayer);

    if v4 then
        return v4.Products[tostring(p2)];
    end;

    return false;
end;

function v1.GetAll(p5) -- Line: 19
    -- upvalues: Players (copy), Save (copy)
    local v6 = Save.Get(p5 or Players.LocalPlayer);

    return v6 and v6.Products or {};
end;

return v1;