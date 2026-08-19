-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Rain = require(ReplicatedStorage.Library.Client.GUIFX.Rain);
local u1 = {
    Volume = 1.3,
    RateScale = 2,
    DragOverride = -0.5,
    Assets = { "rbxassetid://78590382571227" },
    Pitch = { 0.9, 1.1 }
};

return {
    Play = function(p2) -- Line: 26, Name: Play
        -- upvalues: Asserts (copy), Rain (copy), u1 (copy)
        Asserts.string(p2);
        Rain.Play({
            Duration = 1,
            Particles = {
                {
                    SizeScalar = 3,
                    Texture = p2
                }
            },
            SprinkleSounds = u1
        });
    end
};