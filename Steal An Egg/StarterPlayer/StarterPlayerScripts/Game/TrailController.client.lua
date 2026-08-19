-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Player = require(ReplicatedStorage.Library.Player);
local Trails = require(ReplicatedStorage.Directory.Trails);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Trails2 = Constants.NETWORK_MAP.Trails;
local u1 = Log.new();
local Trails3 = ReplicatedStorage.Assets.Trails;
local u2 = {};

local function reconcileTrailVisual(u3) -- Line: 42
    -- upvalues: u2 (copy), Trails (copy), Player (copy), Trails3 (copy)
    local v4 = u2[u3];
    local v5 = `Missing trail renderer state for {u3.Name}`;
    local u6 = assert(v4, v5);
    u6.RenderRevision = u6.RenderRevision + 1;
    local RenderRevision = u6.RenderRevision;
    u6.CharacterTrove:Clean();
    local TrailId = u6.TrailId;
    local Character = u6.Character;

    if TrailId == nil or Character == nil then
        return;
    end;

    u6.CharacterTrove:Add(task.defer(function() -- Line: 54
        -- upvalues: Trails (ref), TrailId (copy), Player (ref), u3 (copy), u2 (ref), u6 (copy), RenderRevision (copy), Character (copy), Trails3 (ref)
        local v7 = Trails.Types.TrailNameExists(TrailId);
        local v8 = `Invalid active trail "{TrailId}"`;
        assert(v7, v8);
        local v9 = Player.HumanoidRootPart(u3);

        if u2[u3] ~= u6 or (u6.RenderRevision ~= RenderRevision or (u6.Character ~= Character or (u6.TrailId ~= TrailId or v9.Parent ~= Character))) then
            return;
        end;

        local v10 = Trails3[TrailId];
        local v11 = v10:IsA("BasePart");
        local v12 = `Trail asset "{TrailId}" must be a BasePart`;
        assert(v11, v12);
        local v13 = v10:Clone();
        u6.CharacterTrove:Add(v13);
        v13.Anchored = false;
        v13.CanCollide = false;
        v13.CanTouch = false;
        v13.CanQuery = false;
        v13.Massless = true;
        v13.Transparency = 1;
        v13.CFrame = v9.CFrame;
        v13.Parent = v9;
        local MainPartTrailWeldConstraint = v13.MainPartTrailWeldConstraint;
        local v14 = MainPartTrailWeldConstraint:IsA("WeldConstraint");
        local v15 = `Trail asset "{TrailId}" has an invalid weld`;
        assert(v14, v15);
        MainPartTrailWeldConstraint.Part1 = v9;
    end));
end;

local function applyActiveTrail(p16, p17, p18) -- Line: 89
    -- upvalues: Asserts (copy), u2 (copy), reconcileTrailVisual (copy)
    Asserts.Player(p16);
    Asserts.optional.string(p17);
    local v19 = u2[p16];
    local v20 = `Missing trail renderer state for {p16.Name}`;
    local v21 = assert(v19, v20);
    v21.TrailId = p17;
    v21.ReceivedLiveUpdate = v21.ReceivedLiveUpdate or p18;
    reconcileTrailVisual(p16);
end;

local function bindPlayer(u22) -- Line: 99
    -- upvalues: u2 (copy), Trove (copy), Player (copy), reconcileTrailVisual (copy)
    if u2[u22] ~= nil then
        return;
    end;

    local v23 = Trove.new();
    local v24 = v23:Extend();
    u2[u22] = {
        TrailId = nil,
        RenderRevision = 0,
        ReceivedLiveUpdate = false,
        Character = Player.Optional.Character(u22),
        PlayerTrove = v23,
        CharacterTrove = v24
    };
    local u25 = u2[u22];
    v23:Connect(u22.CharacterAdded, function(p26) -- Line: 116
        -- upvalues: u25 (copy), reconcileTrailVisual (ref), u22 (copy)
        u25.Character = p26;
        reconcileTrailVisual(u22);
    end);
    v23:Connect(u22.CharacterRemoving, function(p27) -- Line: 120
        -- upvalues: u25 (copy), reconcileTrailVisual (ref), u22 (copy)
        if u25.Character == p27 then
            u25.Character = nil;
            reconcileTrailVisual(u22);
        end;
    end);

    if u25.Character ~= nil then
        reconcileTrailVisual(u22);
    end;
end;

Players.PlayerAdded:Connect(bindPlayer);
Players.PlayerRemoving:Connect(function(p28) -- Line: 137, Name: unbindPlayer
    -- upvalues: u2 (copy)
    local v29 = u2[p28];
    local v30 = `Missing trail renderer state for {p28.Name}`;
    local v31 = assert(v29, v30);
    u2[p28] = nil;
    v31.PlayerTrove:Destroy();
end);

local function handleActiveTrailChanged(p32, p33) -- Line: 132
    -- upvalues: bindPlayer (copy), Asserts (copy), u2 (copy), reconcileTrailVisual (copy)
    bindPlayer(p32);
    Asserts.Player(p32);
    Asserts.optional.string(p33);
    local v34 = u2[p32];
    local v35 = `Missing trail renderer state for {p32.Name}`;
    local v36 = assert(v34, v35);
    v36.TrailId = p33;
    v36.ReceivedLiveUpdate = v36.ReceivedLiveUpdate or true;
    reconcileTrailVisual(p32);
end;

local function hydrateActiveTrailSnapshot() -- Line: 143
    -- upvalues: Network (copy), Trails2 (copy), Players (copy), bindPlayer (copy), u2 (copy), Asserts (copy), reconcileTrailVisual (copy), u1 (copy)
    local v37 = Network.Invoke(Trails2.REQUEST_ACTIVE_SNAPSHOT);

    for i, v in pairs(v37) do
        local v38 = Players:GetPlayerByUserId(i);

        if v38 == nil then
            u1:AtDebug():Log((`Skipped trail snapshot for departed user {i}`));
        else
            bindPlayer(v38);
            local v39 = u2[v38];
            local v40 = `Missing trail renderer state for {v38.Name}`;

            if not assert(v39, v40).ReceivedLiveUpdate then
                Asserts.Player(v38);
                Asserts.optional.string(v);
                local v41 = u2[v38];
                local v42 = `Missing trail renderer state for {v38.Name}`;
                local v43 = assert(v41, v42);
                v43.TrailId = v;
                v43.ReceivedLiveUpdate = v43.ReceivedLiveUpdate or false;
                reconcileTrailVisual(v38);
            end;
        end;
    end;
end;

local v44 = {};

for _, v in ipairs(Players:GetPlayers()) do
    task.spawn(bindPlayer, v);
end;

Network.Fired(Trails2.ACTIVE_TRAIL_EVENT):Connect(handleActiveTrailChanged);
task.defer(hydrateActiveTrailSnapshot);

return v44;