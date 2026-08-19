-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local u1 = false;
local u2 = {
    Completed = Signal.new(),

    Begin = function() -- Line: 20, Name: Begin
        -- upvalues: u1 (ref)
        assert(not u1, "Base upgrade transition is already playing");
        u1 = true;
    end
};

function u2.Complete() -- Line: 25
    -- upvalues: u1 (ref), u2 (copy)
    assert(u1, "Base upgrade transition must be playing before completion");
    u1 = false;
    u2.Completed:Fire();
end;

function u2.IsPlaying() -- Line: 31
    -- upvalues: u1 (ref)
    return u1;
end;

return u2;