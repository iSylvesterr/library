-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("RunService");
local Packages = ReplicatedStorage:WaitForChild("Packages");
local Shared = ReplicatedStorage:WaitForChild("Shared");
Shared:WaitForChild("Info");
local Utility = Shared:WaitForChild("Utility");
require(Packages:WaitForChild("Knit"));
require(Utility:WaitForChild("RollWeighted"));
local Items = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Info"):WaitForChild("Items");

return {
    GetItemModule = function(p1, p2) -- Line: 17, Name: GetItemModule
        -- upvalues: Items (copy)
        if not p2 then
            return nil;
        end;

        local v3 = Items:FindFirstChild(p2, true);

        if v3 then
            return require(v3);
        end;

        return nil;
    end
};