-- Decompiled with Potassium's decompiler.

local u1 = {
    PlaceIds = ({
        [10563114921] = {
            Default = 107778070777162,
            NewPlayerServer = 133470009013038
        },
        [10650210095] = {
            Default = 135851379034158,
            NewPlayerServer = 117867539925583
        }
    })[game.GameId]
};

function u1.GetPlaceIds() -- Line: 18
    -- upvalues: u1 (copy)
    return u1.PlaceIds;
end;

function u1.IsDefaultPlace() -- Line: 22
    -- upvalues: u1 (copy)
    local PlaceIds = u1.PlaceIds;
    local v2;

    if PlaceIds == nil then
        v2 = false;
    else
        v2 = PlaceIds.Default == game.PlaceId;
    end;

    return v2;
end;

function u1.IsNewPlayerServer() -- Line: 27
    -- upvalues: u1 (copy)
    local PlaceIds = u1.PlaceIds;
    local v3;

    if PlaceIds == nil then
        v3 = false;
    else
        v3 = PlaceIds.NewPlayerServer == game.PlaceId;
    end;

    return v3;
end;

return u1;