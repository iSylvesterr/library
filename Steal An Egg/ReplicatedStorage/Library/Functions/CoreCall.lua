-- Decompiled with Potassium's decompiler.

local StarterGui = game:GetService("StarterGui");
local RunService = game:GetService("RunService");

return function(p1, ...) -- Line: 3
    -- upvalues: StarterGui (copy), RunService (copy)
    local v2 = {};

    for _ = 1, 8 do
        v2 = { pcall(StarterGui[p1], StarterGui, ...) };

        if v2[1] then
            break;
        end;

        RunService.RenderStepped:Wait();
    end;

    return unpack(v2);
end;