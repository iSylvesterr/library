-- Decompiled with Potassium's decompiler.

local Info = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Info");
local CustomEnum = require(Info:WaitForChild("CustomEnum"));
local v1 = {};
local u2 = {
    {
        [CustomEnum.PLACE_TYPE.Lobby] = 0,
        [CustomEnum.PLACE_TYPE.GameMain] = 0
    }
};

function v1.getBetaID(p3) -- Line: 21
    return 10645090264;
end;

function v1.GetID(p4, p5) -- Line: 25
    -- upvalues: u2 (copy)
    if not u2[game.GameId] then
        error("EXPERIANCE IDS NOT SET UP");
    end;

    return u2[game.GameId][p5];
end;

return v1;