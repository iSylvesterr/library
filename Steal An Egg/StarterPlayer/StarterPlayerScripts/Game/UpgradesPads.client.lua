-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Pads = require(ReplicatedStorage.Library.Client.WorldFX.Pads);
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);

local function bindPad(p1, p2, u3) -- Line: 16
    -- upvalues: Pads (copy), TabController (copy)
    local v4 = Pads.new(p2);
    p1:Add(v4);
    p1:Add(v4:AddEnterListener(function() -- Line: 19
        -- upvalues: TabController (ref), u3 (copy)
        TabController.OpenTab(u3);
    end));
    p1:Add(v4:AddLeaveListener(function() -- Line: 22
        -- upvalues: TabController (ref), u3 (copy)
        if TabController.Get() == u3 then
            TabController.CloseTab(true);
        end;
    end));
end;

for _, child in Workspace:WaitForChild("Stands"):WaitForChild("Pads"):GetChildren() do
    if child:IsA("BasePart") then
        bindPad(Trove.new(), child, child.Name);
    end;
end;