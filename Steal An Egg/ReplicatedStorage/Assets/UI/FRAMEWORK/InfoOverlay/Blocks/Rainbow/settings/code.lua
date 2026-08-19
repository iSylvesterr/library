-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Functions = require(ReplicatedStorage.Library.Functions);

return function(u1, p2, p3, p4) -- Line: 4, Name: UpdateUI
    -- upvalues: Functions (copy)
    local u5 = { u1.title.Gradient, u1.title.UIStroke.Gradient };
    Functions.RenderStepped(function(p6, p7) -- Line: 10
        -- upvalues: u1 (copy), u5 (copy)
        if not u1.Parent then
            return true;
        end;

        local v8 = os.clock() % 3 / 3;
        local v9 = Color3.fromHSV(v8, 0.65, 1);

        for _, v in ipairs(u5) do
            v.Color = ColorSequence.new(v9);
        end;

        return nil;
    end);
end;