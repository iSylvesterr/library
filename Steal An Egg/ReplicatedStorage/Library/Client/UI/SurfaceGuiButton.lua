-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);

return {
    Get = function(p1, p2) -- Line: 16, Name: Get
        -- upvalues: Asserts (copy)
        Asserts.BasePart(p1);
        Asserts.string(p2);

        for _, child in ipairs(p1:GetChildren()) do
            if child:IsA("SurfaceGui") then
                local v3 = child:FindFirstChild(p2, true);

                if v3 ~= nil and v3:IsA("GuiButton") then
                    return v3;
                end;
            end;
        end;

        return nil;
    end
};