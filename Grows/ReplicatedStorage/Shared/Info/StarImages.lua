-- Decompiled with Potassium's decompiler.

require(game.ReplicatedStorage.Shared.Info.CustomEnum);
local Images = require(game.ReplicatedStorage.Shared.Info.Images);

return function(p1) -- Line: 5
    -- upvalues: Images (copy)
    local v2 = false;
    local STAR_HALF = Images.STAR_HALF;

    if p1 == 0 then
        STAR_HALF = Images.STAR_HALF;
        v2 = true;
    elseif p1 == 1 then
        STAR_HALF = Images.STAR_ONE;
        v2 = true;
    elseif p1 == 2 then
        STAR_HALF = Images.STAR_TWO;
        v2 = true;
    elseif p1 == 3 then
        STAR_HALF = Images.STAR_THREE;
        v2 = true;
    elseif p1 == 4 then
        STAR_HALF = Images.STAR_FOUR;
        v2 = true;
    elseif p1 == 5 then
        STAR_HALF = Images.STAR_FIVE;
        v2 = true;
    elseif p1 then
        warn("INVALID STAR AMOUNT RECIEVED " .. p1);
    end;

    return STAR_HALF, v2;
end;