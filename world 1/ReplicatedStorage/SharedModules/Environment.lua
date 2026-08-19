-- Decompiled with Potassium's decompiler.

local u1 = {
    Dev = 9638499374,
    Live = 10200395747
};
local u2 = {
    Dev = {
        Primary = 132935919810877,
        NewUser = 99129412870047,
        FirstSession = 115012049182484,
        PetHunt = 115347951392186,
        PetHuntFallHarvest = 102717190507662,
        FallHarvest = 91691467696898,
        BotUser = 112787193138980,
        FallHarvestBotUser = 137781840545002
    },
    Live = {
        Primary = 97598239454123,
        NewUser = 133438856880402,
        FirstSession = 77085202503540,
        PetHunt = 112469282445074,
        FallHarvest = 126987765280963,
        FallHarvestBotUser = 129343810645058,
        PetHuntFallHarvest = 137395689498699,
        BotUser = 73504898027860
    }
};
local v3 = {
    Dev = {
        InstantPurchases = true
    },
    Live = {
        InstantPurchases = false
    }
};
local v4 = {
    Dev = 4
};
local RunService = game:GetService("RunService");
local u5 = {
    Primary = true,
    FirstSession = true,
    NewUser = true,
    PetHunt = true,
    PetHuntFallHarvest = true,
    FallHarvest = true,
    BotUser = true,
    FallHarvestBotUser = true
};
local v6 = {
    PetHunt = true,
    PetHuntFallHarvest = true
};
local v7 = {
    BotUser = true,
    FallHarvestBotUser = true
};
local v8 = (function() -- Line: 108, Name: ResolveEnv
    -- upvalues: u1 (copy), RunService (copy)
    for i, v in u1 do
        if v == game.GameId then
            return i;
        end;
    end;

    if RunService:IsStudio() then
        return "Dev";
    end;

    warn((`[Environment] unknown gameId {game.GameId}; defaulting to Live`));

    return "Live";
end)();
local v11 = (function(p9) -- Line: 151, Name: ResolvePlaceType
    -- upvalues: RunService (copy), u5 (copy), u2 (copy)
    if RunService:IsStudio() then
        local v10 = workspace:GetAttribute("WorldOverride");

        if typeof(v10) == "string" and v10 ~= "" then
            if u5[v10] then
                return v10;
            end;

            warn((`[Environment] WorldOverride "{v10}" is not a known place type; ignoring`));
        end;
    end;

    for i, v in u2[p9] do
        if v == game.PlaceId then
            return i;
        end;
    end;

    if not RunService:IsStudio() then
        warn((`[Environment] unknown placeId {game.PlaceId}; treating as Primary`));
    end;

    return "Primary";
end)(v8);
local v12 = ({
    FallHarvest = "FallHarvest",
    FallHarvestBotUser = "FallHarvest",
    PetHuntFallHarvest = "FallHarvest"
})[v11] or "Main";

local function ResolveServerType() -- Line: 193
    return game.PrivateServerId == "" and "Standard" or (game.PrivateServerOwnerId == 0 and "Reserved" or "Private");
end;

local v13;

if RunService:IsServer() then
    v13 = game.PrivateServerId == "" and "Standard" or (game.PrivateServerOwnerId == 0 and "Reserved" or "Private");
    script:SetAttribute("serverType", v13);
elseif RunService:IsRunning() then
    v13 = script:GetAttribute("serverType");

    if v13 == nil then
        script:GetAttributeChangedSignal("serverType"):Wait();
        v13 = script:GetAttribute("serverType");
    end;

    local v14 = typeof(v13) == "string";
    local v15 = `serverType attribute missing or invalid: {tostring(v13)}`;
    assert(v14, v15);
else
    v13 = game.PrivateServerId == "" and "Standard" or (game.PrivateServerOwnerId == 0 and "Reserved" or "Private");
end;

return table.freeze({
    env = v8,
    gameId = u1[v8],
    placeType = v11,
    placeId = game.PlaceId,
    places = table.freeze(u2[v8]),
    serverType = v13,
    config = table.freeze(v3[v8]),
    dataStoreVersion = v4[v8],
    isPetHuntPlace = v6[v11] == true,
    isBotContainmentPlace = v7[v11] == true,
    worldId = v12
});