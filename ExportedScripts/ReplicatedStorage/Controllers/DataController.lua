-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local Stock = require(ReplicatedStorage.Database.Components.Libraries.Stock);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Promise = require(ReplicatedStorage.Shared.Promise);
local u2 = {};
local u3 = {};

local function GetPossiblePaths(p4) -- Line: 37
    local v5 = {};
    local v6 = "";

    for i, v in ipairs(p4) do
        if i <= 1 then
            v6 = v;
        elseif i > 1 then
            v6 = `{v6}.{v}`;
        end;

        table.insert(v5, v6);
    end;

    return v5;
end;

local function ExecuteListeners(p7, p8) -- Line: 56
    -- upvalues: GetPossiblePaths (copy), u3 (copy), u1 (copy), Promise (copy)
    local v9 = GetPossiblePaths(p8);

    for _, v in ipairs(v9) do
        local v10 = u3[p7];

        if v10 then
            local v11 = v10[v];

            if v11 then
                local v12 = u1.Get(p7, v);

                for _, v2 in pairs(v11) do
                    Promise.try(v2, v12);
                end;
            end;
        end;
    end;
end;

local function DenormalizeInventoryItemFromRemote(u13) -- Line: 78
    -- upvalues: HttpService (copy)
    local success, result = pcall(function() -- Line: 81
        -- upvalues: HttpService (ref), u13 (copy)
        return HttpService:JSONEncode(u13);
    end);

    if not (success and result) then
        return u13;
    end;

    local success2, result2 = pcall(function() -- Line: 89
        -- upvalues: HttpService (ref), result (copy)
        return HttpService:JSONDecode(result);
    end);

    if not (success2 and result2) then
        return u13;
    end;

    for _, v in ipairs({ "Serial", "Pattern" }) do
        if result2[v] ~= nil and typeof(result2[v]) == "string" then
            result2[v] = tonumber(result2[v]) or result2[v];
        end;
    end;

    if result2.MetaData and typeof(result2.MetaData) == "table" then
        for _, v in ipairs({ "OriginalOwner", "Owner" }) do
            if result2.MetaData[v] ~= nil and typeof(result2.MetaData[v]) == "string" then
                result2.MetaData[v] = tonumber(result2.MetaData[v]) or result2.MetaData[v];
            end;
        end;
    end;

    return result2;
end;

local function ShouldDenormalizeInventoryItem(p14) -- Line: 121
    if typeof(p14) ~= "table" then
        return false;
    end;

    if typeof(p14.Serial) == "string" or typeof(p14.Pattern) == "string" then
        return true;
    end;

    local MetaData = p14.MetaData;

    if typeof(MetaData) == "table" then
        if typeof(MetaData.OriginalOwner) == "string" then
            return true;
        end;

        if typeof(MetaData.Owner) == "string" then
            return true;
        end;
    end;

    return false;
end;

local function ApplyInventoryDelta(p15, p16, p17) -- Line: 145
    -- upvalues: u2 (copy), ShouldDenormalizeInventoryItem (copy), DenormalizeInventoryItemFromRemote (copy), ExecuteListeners (copy)
    local v18 = u2[p15];

    if not (v18 and v18.Inventory) then
        return;
    end;

    local v19 = false;

    if p17 then
        local v20 = {};

        for _, v in ipairs(p17) do
            v20[v] = true;
        end;

        for i = #v18.Inventory, 1, -1 do
            local v21 = v18.Inventory[i];

            if v21 and (v21._id and v20[v21._id]) then
                table.remove(v18.Inventory, i);
                v19 = true;
            end;
        end;
    end;

    local v22 = {};

    for _, v in ipairs(v18.Inventory) do
        if v and v._id then
            v22[v._id] = true;
        end;
    end;

    for _, v in ipairs(p16) do
        if ShouldDenormalizeInventoryItem(v) then
            local v = DenormalizeInventoryItemFromRemote(v);
        end;

        if v and (v._id and not v22[v._id]) then
            table.insert(v18.Inventory, v);
            v22[v._id] = true;
            v19 = true;
        end;
    end;

    if v19 then
        ExecuteListeners(p15, { "Inventory" });
    end;
end;

function u1.IsDataLoaded(p23) -- Line: 198
    -- upvalues: u2 (copy)
    return u2[p23] ~= nil;
end;

function u1.WaitForDataLoaded(p24) -- Line: 204
    -- upvalues: u2 (copy)
    local v25 = 0;

    while not u2[p24] do
        v25 = v25 + task.wait();

        if v25 >= 60 then
            error((`[DataController] Failed to load player profile for {p24.Name} after 60 seconds`));
        end;
    end;

    return u2[p24];
end;

function u1.IsDataLoaded(p26) -- Line: 217
    -- upvalues: u2 (copy)
    return u2[p26] ~= nil;
end;

function u1.Get(p27, ...) -- Line: 223
    -- upvalues: u2 (copy)
    local v28 = u2[p27];

    if not v28 then
        return nil;
    end;

    local v29 = {};

    for _, v in table.pack(...) do
        local v30 = v28;

        for _, v2 in string.split(v, ".") do
            v28 = v28[v2];

            if not v28 then
                break;
            end;
        end;

        table.insert(v29, v28);
        v28 = v30;
    end;

    return table.unpack(v29);
end;

function u1.ApplyInventoryDelta(p31, p32, p33) -- Line: 251
    -- upvalues: ApplyInventoryDelta (copy)
    ApplyInventoryDelta(p31, p32, p33);
end;

function u1.RemoveListener(p34, p35, p36) -- Line: 257
    -- upvalues: u3 (copy)
    if u3[p34] and u3[p34][p35] then
        u3[p34][p35][p36] = nil;

        if next(u3[p34][p35]) == nil then
            u3[p34][p35] = nil;
        end;
    end;
end;

function u1.CreateListener(p37, p38, p39) -- Line: 270
    -- upvalues: HttpService (copy), u3 (copy), u1 (copy), Promise (copy)
    local v40 = HttpService:GenerateGUID(false);
    u3[p37] = u3[p37] or {};
    u3[p37][p38] = u3[p37][p38] or {};
    u3[p37][p38][v40] = p39;
    local v41 = u1.Get(p37, p38);

    if v41 ~= nil then
        Promise.try(p39, v41);
    end;

    return v40;
end;

function u1.Initialize() -- Line: 288
    -- upvalues: Remotes (copy), u3 (copy), Stock (copy), u2 (copy), u1 (copy), Promise (copy), ExecuteListeners (copy)
    Remotes.PlayerData.PlayerDataEvent.Listen(function(p42) -- Line: 290
        -- upvalues: u3 (ref), Stock (ref), u2 (ref), u1 (ref), Promise (ref)
        local v43 = u3[p42.Player];

        if p42.Data and p42.Data.Inventory then
            Stock.InjectStockItems(p42.Data.Inventory);
        end;

        u2[p42.Player] = p42.Data;

        if v43 then
            for i, v in pairs(v43) do
                local v44 = u1.Get(p42.Player, i);

                for _, v2 in pairs(v) do
                    Promise.try(v2, v44);
                end;
            end;
        end;
    end);
    Remotes.PlayerData.PlayerDataChanged.Listen(function(p45) -- Line: 311
        -- upvalues: u2 (ref), ExecuteListeners (ref)
        local Player = p45.Player;
        local v46 = u2[Player];

        if v46 then
            for i, v in pairs(p45.Data) do
                local v47 = string.split(i, ".");
                local v48 = v46;

                for i2 = 1, #v47 - 1 do
                    local v49 = v47[i2];

                    if typeof(v46[v49]) ~= "table" then
                        v46[v49] = {};
                    end;

                    v46 = v46[v49];
                end;

                v46[v47[#v47]] = v;
                ExecuteListeners(Player, v47);
                v46 = v48;
            end;

            return;
        end;

        warn((`[DataController] Received data change for {Player.Name} but profile not loaded yet. Requesting full profile.`));
    end);
end;

function u1.Start() -- Line: 340
    -- upvalues: Remotes (copy), Players (copy), ApplyInventoryDelta (copy), u3 (copy), u2 (copy)
    Remotes.PlayerData.RetrieveAllPlayerData.Send();
    Remotes.Store.NewInventoryItem.Listen(function(p50) -- Line: 343
        -- upvalues: Players (ref), ApplyInventoryDelta (ref)
        local v51 = tonumber(p50.Player);

        if not v51 then
            return;
        end;

        local v52 = Players:GetPlayerByUserId(v51);

        if not (v52 and v52:IsDescendantOf(Players)) then
            return;
        end;

        ApplyInventoryDelta(v52, p50.Items, p50.DeletedItemIds);
    end);
    Players.PlayerRemoving:Connect(function(p53) -- Line: 356
        -- upvalues: u3 (ref), u2 (ref)
        u3[p53] = nil;
        u2[p53] = nil;
    end);
end;

return u1;