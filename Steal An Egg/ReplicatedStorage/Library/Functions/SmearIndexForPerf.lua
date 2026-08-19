-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1 = require(ReplicatedStorage.Library.Globals.Constants).IS_MOBILE and 100 or 300;

return function(p2, p3) -- Line: 13
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.number(p2);
    Asserts.optional.number(p3);

    if p2 % (p3 or u1) ~= 0 then
        return;
    end;

    task.wait(0);
end;