-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Library = ReplicatedStorage:WaitForChild("Library");
local Modules = Library:WaitForChild("Modules");
local Client = Library:WaitForChild("Client");
local Signal = require(Library.Signal);
local Network = require(Client.Network);
local Settings = require(Client.Settings);
local Mutex = require(Modules.Mutex);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local DeepFreezeUnsafe = require(ReplicatedStorage.Library.Functions.DeepFreezeUnsafe);
local Event = require(Modules.Event);
local u1 = require(Modules.Packages.Log).new();
local Trove = require(Modules.Packages.Trove);
require(Library.Modules.DefaultStats.Types.Interface);
local u2 = {};
local u3 = {};
local u4 = {};
local LocalPlayer = Players.LocalPlayer;
local u5 = false;
local u6 = Event.new();
local u7 = Event.new();
local u8 = Event.new();
local u9 = Event.new();
local u10 = Event.new();
local u11 = Event.new();
local u12 = Event.new();
local u13 = {
    StatChanged = u6,
    OtherStatChanged = u7,
    StatsChanged = u8,
    OtherStatsChanged = u9,
    LoadedStats = u10,
    LoadedOtherStats = u11,
    StatsRemoved = u12,

    GetSaves = function() -- Line: 87, Name: GetSaves
        -- upvalues: u2 (copy)
        return u2;
    end
};

function u13.GetUnsafe(p14) -- Line: 91
    -- upvalues: u13 (copy)
    return u13.Get(p14);
end;

function u13.IsLocalDataLoaded() -- Line: 95
    -- upvalues: u5 (ref)
    return u5;
end;

function u13.Get(p15, p16) -- Line: 99
    -- upvalues: LocalPlayer (copy), u2 (copy), u3 (copy), Mutex (copy)
    local u17 = p15 or LocalPlayer;

    if not (u17 and u17.Parent) then
        return nil;
    end;

    if (p16 == nil and true or p16 == true) and u2[u17] then
        return u2[u17];
    end;

    local v18 = u3[u17];

    if not v18 then
        v18 = Mutex.new();
        u3[u17] = v18;
    end;

    return v18:run(function() -- Line: 117
        -- upvalues: u17 (copy), LocalPlayer (ref), u2 (ref)
        if not (u17 and u17.Parent) then
            return nil;
        end;

        if not Update(u17) and (u17 and u17 == LocalPlayer) then
            repeat
                task.wait(1.05);
            until not (u17 and (u17.Parent and Update(u17)));
        end;

        if u17 then
            return u2[u17];
        end;

        return nil;
    end);
end;

function Update(u19)
    -- upvalues: u2 (copy), LocalPlayer (copy), Network (copy), RunService (copy), u1 (copy), Settings (copy), DeepFreezeUnsafe (copy), u5 (ref), u10 (copy), Signal (copy), u11 (copy)
    local v20;

    if typeof(u19) == "Instance" then
        v20 = u19:IsA("Player");
    else
        v20 = false;
    end;

    assert(v20, "Expected player to be a Player Instance when updating save.");

    if u2[u19] then
        return true;
    end;

    local UserId = u19.UserId;
    local v21 = LocalPlayer == u19;
    local success, result = pcall(function() -- Line: 150
        -- upvalues: Network (ref), u19 (copy)
        return Network.Invoke("Get Stats", u19);
    end);

    if not success then
        print("ARE WE ON THE CLIENT", RunService:IsClient());
        warn(string.format("[SAVE] Player \'%d\' save failed to load: \'%s\'", UserId, (tostring(result))));

        return false;
    end;

    if not u19 then
        warn(string.format("[SAVE] Player \'%d\' logged out while loading save", UserId));

        return false;
    end;

    if not result then
        return false;
    end;

    u1:AtTrace():Log("[SAVE] retried player save form server:", result);

    if typeof(result) ~= "table" then
        warn(string.format("[SAVE] Player \'%d\' save was invalid type: \'%s\'", UserId, (typeof(result))));

        if v21 then
            u19.Character = nil;
            u19:Kick("Something went wrong fetching save. Please rejoin!");
        end;

        return false;
    end;

    if u2[u19] then
        return true;
    end;

    for i, v in pairs(result) do
        if type(v) == "table" and not Settings.StatsNoFreeze[i] then
            DeepFreezeUnsafe(v);
        end;
    end;

    u2[u19] = result;

    if v21 then
        u5 = true;
        u10:FireAsync(u19);
        Signal.Fire("Loaded Stats", u19);
    else
        u11:FireAsync(u19);
        Signal.Fire("Loaded Other Stats", u19);
    end;

    return true;
end;

local function ApplyInventoryPatch(p22, p23) -- Line: 205
    if typeof(p23) ~= "table" or p23.__patch ~= true then
        return p23, false;
    end;

    local v24 = p22.Inventory or {};

    if p23.Remove then
        for i in p23.Remove do
            if v24[i] ~= nil then
                v24[i] = nil;
            end;
        end;
    end;

    if p23.Set then
        for i, v in p23.Set do
            v24[i] = v;
        end;
    end;

    return v24, true;
end;

local function ProcessChanges(p25, p26, p27) -- Line: 230
    -- upvalues: Asserts (copy), u2 (copy), ApplyInventoryPatch (copy), Settings (copy), DeepFreezeUnsafe (copy)
    Asserts.Player(p25);
    Asserts.table(p26);

    if p27 then
        Asserts.table(p27);
    end;

    local v28 = u2[p25];

    if not v28 then
        return;
    end;

    local v29 = {};
    local v30 = {};

    if p27 then
        for i in pairs(p27) do
            v30[i] = v28[i];
            v28[i] = nil;
        end;
    end;

    for i, v in pairs(p26) do
        v30[i] = v28[i];
        local v31;

        if i == "Inventory" then
            local v32;
            v31, v32 = ApplyInventoryPatch(v28, v);

            if not v32 then
                v31 = v;
            end;
        else
            v31 = v;
        end;

        if type(v31) == "table" and not Settings.StatsNoFreeze[i] then
            DeepFreezeUnsafe(v31);
        end;

        v28[i] = v31;
        v29[i] = v31;
    end;

    FireStatChangedForChange(p25, v29, p27, v30, p26);
end;

function FireStatChangedForChange(p33, p34, p35, p36, p37)
    -- upvalues: Asserts (copy), u2 (copy), LocalPlayer (copy), u6 (copy), u4 (copy), u7 (copy), u8 (copy), u9 (copy)
    Asserts.Player(p33);
    Asserts.table(p34);

    if p35 then
        Asserts.table(p35);
    end;

    if not u2[p33] then
        return;
    end;

    local v38 = LocalPlayer == p33;

    for i in pairs(p34) do
        local v39 = p34[i];
        local v40;

        if p36 then
            v40 = p36[i];
        else
            v40 = p36;
        end;

        local v41;

        if p37 then
            v41 = p37[i];
        else
            v41 = p37;
        end;

        if v38 then
            u6:FireAsync(i, v39, v40, v41);

            if u4[i] then
                u4[i]:FireAsync(v39, v40, v41);
            end;
        else
            u7:FireAsync(p33, i);
        end;
    end;

    if p35 then
        for i in pairs(p35) do
            local v42;

            if p36 then
                v42 = p36[i];
            else
                v42 = p36;
            end;

            if v38 then
                u6:FireAsync(i, nil, v42, nil);

                if u4[i] then
                    u4[i]:FireAsync(nil, v42, nil);
                end;
            else
                u7:FireAsync(p33, i);
            end;
        end;
    end;

    if v38 then
        u8:FireAsync();

        return;
    end;

    u9:FireAsync(p33);
end;

function u13.GetStatChangedSignal(p43) -- Line: 328
    -- upvalues: u4 (copy), Event (copy)
    if u4[p43] then
        return u4[p43];
    end;

    local v44 = Event.new();
    u4[p43] = v44;

    return v44;
end;

function u13.ConnectForDataChanged(p45, p46) -- Line: 338
    -- upvalues: Asserts (copy), Trove (copy), u13 (copy)
    local v47 = typeof(p45) == "string" and ({ p45 } or p45) or p45;
    Asserts.table(v47);
    Asserts.func(p46);
    local v48 = Trove.new();

    for _, v in v47 do
        Asserts.string(v);
        v48:Connect(u13.GetStatChangedSignal(v), p46);
    end;

    return v48;
end;

function u13.ProcessManualChange(p49, p50, p51) -- Line: 352
    -- upvalues: ProcessChanges (copy), LocalPlayer (copy)
    ProcessChanges(p51 or LocalPlayer, {
        [p49] = p50
    });
end;

function u13.FireStatChangedForManuallyChangedSave(p52, p53, p54) -- Line: 358
    -- upvalues: LocalPlayer (copy)
    FireStatChangedForChange(p54 or LocalPlayer, {
        [p52] = p53
    });
end;

function u13.ProcessManualTableKeyChange(p55, p56, p57, p58) -- Line: 364
    -- upvalues: LocalPlayer (copy), u13 (copy), Settings (copy), ProcessChanges (copy)
    local v59 = p58 or LocalPlayer;
    local v60 = u13.Get(v59);

    if not v60 then
        return;
    end;

    local v61 = v60[p55];

    if not v61 then
        return;
    end;

    if not Settings.StatsNoFreeze[p55] then
        v61 = table.clone(v61);
    end;

    v61[p56] = p57;
    ProcessChanges(v59, {
        [p55] = v61
    });
end;

function u13.FetchPlayer(u62) -- Line: 386
    -- upvalues: Asserts (copy), u3 (copy), Mutex (copy), u2 (copy)
    Asserts.Player(u62);
    local v63 = u3[u62];

    if not v63 then
        v63 = Mutex.new();
        u3[u62] = v63;
    end;

    v63:run(function() -- Line: 395
        -- upvalues: u62 (copy), u2 (ref)
        while u62 and not u2[u62] do
            Update(u62);

            if not u62 or (u2[u62] or not u62.Parent) then
                break;
            end;

            task.wait(0.5);
        end;
    end);
end;

Network.Fired("New Stats"):Connect(function(p64, p65, p66) -- Line: 408
    -- upvalues: ProcessChanges (copy), LocalPlayer (copy)
    ProcessChanges(p66 or LocalPlayer, p64, p65);
end);
Players.PlayerAdded:Connect(function(p67) -- Line: 412
    -- upvalues: u13 (copy)
    task.spawn(u13.FetchPlayer, p67);
end);
Players.PlayerRemoving:Connect(function(u68) -- Line: 416
    -- upvalues: u2 (copy), u12 (copy), Signal (copy)
    if u2[u68] then
        task.delay(5, function() -- Line: 418
            -- upvalues: u2 (ref), u68 (copy), u12 (ref), Signal (ref)
            u2[u68] = nil;
            u12:FireAsync(u68);
            Signal.Fire("Stats Removed", u68);
        end);
    end;
end);

for _, v in ipairs(Players:GetPlayers()) do
    task.spawn(u13.FetchPlayer, v);
end;

Players.PlayerRemoving:Connect(function(p69) -- Line: 432
    -- upvalues: u3 (copy)
    local v70 = u3[p69];

    if v70 then
        u3[p69] = nil;
        v70:destroy();
    end;
end);

return u13;