-- Decompiled with Potassium's decompiler.

local CROWD_AREA_MARGIN = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "npc", "VisitorConstants").CROWD_AREA_MARGIN;

return {
    CrowdSim = {
        areaFromPart = function(p1) -- Line: 7, Name: areaFromPart
            -- upvalues: CROWD_AREA_MARGIN (copy)
            return {
                centerX = p1.Position.X,
                centerZ = p1.Position.Z,
                halfX = math.max(p1.Size.X / 2 - CROWD_AREA_MARGIN, 1),
                halfZ = math.max(p1.Size.Z / 2 - CROWD_AREA_MARGIN, 1)
            };
        end
    }
};