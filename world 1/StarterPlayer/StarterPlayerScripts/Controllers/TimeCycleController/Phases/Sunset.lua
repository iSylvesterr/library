-- Decompiled with Potassium's decompiler.

local v1 = {};
local LightingController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.LightingController);
local u2 = {
    ClockTime = 17
};

function v1.Start(p3, p4, p5) -- Line: 9
    -- upvalues: LightingController (copy), u2 (copy)
    local v6 = {};

    for i, v in LightingController:GetDefault() do
        v6[i] = v;
    end;

    for i, v in u2 do
        v6[i] = v;
    end;

    LightingController:TransitionTo(v6);
end;

function v1.End(p7) -- Line: 20
end;

return v1;