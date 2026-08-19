-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CollectionService = UtilsSystem.CollectionService;
local GetData = UtilsSystem.GetData;
local MathMgr = UtilsSystem.MathMgr;
local PlayerData = UtilsSystem.PlayerData;
local RankConfig = UtilsSystem.RankConfig;
local TimeTransfer = UtilsSystem.TimeTransfer;
local TranslationHelper = UtilsSystem.TranslationHelper;
local LocalPlayer = UtilsSystem.LocalPlayer;
local ItemID = UtilsSystem.EnumMgr.ItemID;
local UserId = LocalPlayer.UserId;
local u1 = {};

local function _isInDungeonChallenge() -- Line: 43
    -- upvalues: LocalPlayer (copy)
    local InDungeonChallenge = LocalPlayer:FindFirstChild("InDungeonChallenge");
    local v2;

    if InDungeonChallenge == nil then
        v2 = false;
    else
        v2 = InDungeonChallenge:IsA("NumberValue") and InDungeonChallenge.Value > 0;
    end;

    return v2;
end;

local InDungeonChallenge = LocalPlayer:FindFirstChild("InDungeonChallenge");
local v3;

if InDungeonChallenge == nil then
    v3 = false;
else
    v3 = InDungeonChallenge:IsA("NumberValue") and InDungeonChallenge.Value > 0;
end;

if v3 then
    script:Destroy();

    return;
end;

local function _findRankName(p4) -- Line: 58
    -- upvalues: RankConfig (copy)
    while p4 do
        if RankConfig.RANK_DATA_FIELDS[p4.Name] ~= nil then
            return p4.Name;
        end;

        p4 = p4.Parent;
    end;

    return nil;
end;

local function _findMyRankOnBoard(p5) -- Line: 75
    -- upvalues: RankConfig (copy), UserId (copy)
    local v6 = workspace:FindFirstChild(RankConfig.WORKSPACE_CACHE_FOLDER);

    if not v6 then
        return nil, nil;
    end;

    local v7 = v6:FindFirstChild(p5);

    if not v7 then
        return nil, nil;
    end;

    for i = 1, RankConfig.RANK_COUNTS do
        local v8 = v7:FindFirstChild((tostring(i)));

        if v8 then
            local UserId2 = v8:FindFirstChild("UserId");
            local Score = v8:FindFirstChild("Score");

            if UserId2 and (Score and (UserId2:IsA("NumberValue") and (Score:IsA("NumberValue") and UserId2.Value == UserId))) then
                return i, Score.Value;
            end;
        end;
    end;

    return nil, nil;
end;

local function _getLocalScore(p9) -- Line: 110
    -- upvalues: GetData (copy), LocalPlayer (copy), ItemID (copy), RankConfig (copy), PlayerData (copy)
    if p9 == "Rank_Gold" then
        return GetData.GetItemCountByID(LocalPlayer, ItemID.Coin) or 0;
    end;

    if p9 == "Rank_Magic" then
        return (GetData.GetItemCountByID(LocalPlayer, ItemID.Power) or 0) + (GetData.GetItemCountByID(LocalPlayer, ItemID.PowerUsed) or 0);
    end;

    local v10 = RankConfig.RANK_DATA_FIELDS[p9];

    return v10 and (tonumber(PlayerData.GetPlrDataByKey(LocalPlayer, { "Record", v10 })) or 0) or 0;
end;

local function _setNumberText(p11, p12, p13, p14) -- Line: 135
    -- upvalues: MathMgr (copy), RankConfig (copy), TranslationHelper (copy), TimeTransfer (copy)
    if p14 then
        p13 = MathMgr.backRankNum(p13);
    end;

    if p12 == RankConfig.RANK_TIME_NAME then
        TranslationHelper.SetText_UnTrans(p11, (tostring(TimeTransfer.UniqueTimeStringRank(p13))));

        return;
    end;

    TranslationHelper.SetText_UnTrans(p11, MathMgr.getNumStr(p13));
end;

local function _refreshMyRankFrame(p15) -- Line: 149
    -- upvalues: RankConfig (copy), _findMyRankOnBoard (copy), _getLocalScore (copy), _setNumberText (copy), TranslationHelper (copy), LocalPlayer (copy)
    local v16 = p15;
    local v17;

    while true do
        if not p15 then
            v17 = nil;
            break;
        end;

        if RankConfig.RANK_DATA_FIELDS[p15.Name] ~= nil then
            v17 = p15.Name;
            break;
        end;

        p15 = p15.Parent;
    end;

    if not v17 then
        return;
    end;

    local Username = v16:FindFirstChild("Username");
    local Number = v16:FindFirstChild("Number");
    local Rank = v16:FindFirstChild("Rank");

    if not (Username and Username:IsA("TextLabel")) then
        return;
    end;

    if not (Number and Number:IsA("TextLabel")) then
        return;
    end;

    if not (Rank and Rank:IsA("TextLabel")) then
        return;
    end;

    local v18, v19 = _findMyRankOnBoard(v17);
    local v20 = false;

    if v19 == nil then
        v19 = _getLocalScore(v17);
    else
        v20 = true;
    end;

    _setNumberText(Number, v17, v19, v20);

    if v18 == nil then
        TranslationHelper.SetText_UnTrans(Rank, "100+");
    else
        TranslationHelper.SetText_UnTrans(Rank, "#" .. tostring(v18));
        local v21 = RankConfig.RANK_COLORS[v18];

        if v21 then
            Rank.TextColor3 = v21;
            Username.TextColor3 = v21;
        end;
    end;

    TranslationHelper.SetText_UnTrans(Username, LocalPlayer.DisplayName);
end;

task.wait(5);

local function _addFunc(p22) -- Line: 199
    -- upvalues: RankConfig (copy), u1 (copy), _refreshMyRankFrame (copy)
    local u23 = p22;
    local u24;

    while true do
        if not p22 then
            u24 = nil;
            break;
        end;

        if RankConfig.RANK_DATA_FIELDS[p22.Name] ~= nil then
            u24 = p22.Name;
            break;
        end;

        p22 = p22.Parent;
    end;

    if not u24 then
        return;
    end;

    local v25 = u1[u24];

    if v25 then
        task.cancel(v25);
        u1[u24] = nil;
    end;

    u1[u24] = task.spawn(function() -- Line: 211
        -- upvalues: u23 (copy), _refreshMyRankFrame (ref), u1 (ref), u24 (copy)
        while u23.Parent do
            _refreshMyRankFrame(u23);
            task.wait(120);
        end;

        u1[u24] = nil;
    end);
end;

for _, v in ipairs(CollectionService:GetTagged("MyRank")) do
    if v:IsA("Frame") then
        _addFunc(v);
    end;
end;

CollectionService:GetInstanceAddedSignal("MyRank"):Connect(function(p26) -- Line: 228
    -- upvalues: _addFunc (copy)
    if p26:IsA("Frame") then
        _addFunc(p26);
    end;
end);