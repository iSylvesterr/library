-- Decompiled with Potassium's decompiler.

local Workspace = game:GetService("Workspace");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BaseUpgradeTransitionLifecycle = require(ReplicatedStorage.Library.Client.BaseUpgradeTransitionLifecycle);
local Audio = require(ReplicatedStorage.Library.Audio);

return {
    Play = function(p1) -- Line: 93, Name: Play
        -- upvalues: Workspace (copy), BaseUpgradeTransitionLifecycle (copy), Audio (copy)
        assert(Workspace.CurrentCamera ~= nil, "Base upgrade transition requires CurrentCamera");
        BaseUpgradeTransitionLifecycle.Begin();
        Audio.Play(119855061490364, script, { 0.9, 1.1 }, 1.5);
        task.spawn(p1);
        BaseUpgradeTransitionLifecycle.Complete();
    end
};