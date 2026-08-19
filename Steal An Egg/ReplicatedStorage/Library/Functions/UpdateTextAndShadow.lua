-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);

return function(p1, p2, p3, p4) -- Line: 10
    -- upvalues: Asserts (copy)
    Asserts.string(p2);
    Asserts.TextLabel(p1);
    Asserts.optional.Color3(p3);
    Asserts.optional.string(p4);
    p1.Text = p4 or p2;
    local Shadow = p1:FindFirstChild("Shadow");

    if Shadow then
        Shadow.Text = p2;

        if p3 then
            Shadow.TextColor3 = p3;
        end;
    end;
end;