-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("CollectionService");
game:GetService("TweenService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Component = require(ReplicatedStorage.Packages.Component);
local Maid = require(ReplicatedStorage.Packages.Maid);
require(ReplicatedStorage.Shared.Info.Constants);
local Assets = ReplicatedStorage:WaitForChild("Assets");
Assets:WaitForChild("Particles");
Assets:WaitForChild("Misc");
local v1 = Component.new({
    Tag = "ComponentTemplate"
});

function v1.Start(p2) -- Line: 21
    -- upvalues: Knit (copy), Maid (copy)
    Knit.OnStart():await();
    p2._maid = Maid.new();
end;

function v1.Stop(p3) -- Line: 28
    if p3._maid then
        p3._maid:Destroy();
    end;
end;

return v1;