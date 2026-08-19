-- Decompiled with Potassium's decompiler.

game:GetService("Workspace");
game:GetService("Lighting");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("ServerScriptService");
game:GetService("ServerStorage");
game:GetService("Debris");
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Trove).new();
local u2 = false;

return {
    StartEvent = function(p3, p4) -- Line: 26, Name: StartEvent
        -- upvalues: u1 (copy), u2 (ref)
        u1:Clean();
        u2 = true;
    end,

    StopEvent = function(p5) -- Line: 32, Name: StopEvent
        -- upvalues: u1 (copy), u2 (ref)
        u1:Clean();
        u2 = false;
    end
};