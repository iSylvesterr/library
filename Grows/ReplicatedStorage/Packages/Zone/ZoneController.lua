-- Decompiled with Potassium's decompiler.

local Janitor = require(script.Parent.Janitor);
local Enum2 = require(script.Parent.Enum);
require(script.Parent.Signal);
local Tracker = require(script.Tracker);
local CollectiveWorldModel = require(script.CollectiveWorldModel);
local enums = Enum2.enums;
local Players = game:GetService("Players");
local u1 = {};
local u2 = 0;
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = 0;
local RunService = game:GetService("RunService");
local Heartbeat = RunService.Heartbeat;
local u10 = {};
local u11 = RunService:IsClient() and Players.LocalPlayer;
local u12 = {};
local u13 = {
    player = Tracker.new("player"),
    item = Tracker.new("item")
};
u12.trackers = u13;

local function dictLength(p14) -- Line: 40
    local v15 = 0;

    for _, _ in pairs(p14) do
        v15 = v15 + 1;
    end;

    return v15;
end;

local function fillOccupants(p16, p17, p18) -- Line: 48
    local v19 = p16[p17];

    if not v19 then
        v19 = {};
        p16[p17] = v19;
    end;

    local v20 = p18:IsA("Player") and p18.Character;
    v19[p18] = v20 or true;
end;

local u29 = {
    player = function(p21) -- Line: 59
        -- upvalues: u12 (copy), u1 (copy), u2 (ref)
        return u12._getZonesAndItems("player", u1, u2, true, p21);
    end,

    localPlayer = function(p22) -- Line: 62
        -- upvalues: u11 (copy), u12 (copy), u13 (copy)
        local v23 = {};
        local Character = u11.Character;

        if not Character then
            return v23;
        end;

        local v24 = u12.getTouchingZones(Character, true, p22, u13.player);

        for _, v in pairs(v24) do
            if v.activeTriggers.localPlayer then
                local v25 = u11;
                local v26 = v23[v];

                if not v26 then
                    v26 = {};
                    v23[v] = v26;
                end;

                local v27 = v25:IsA("Player") and v25.Character;
                v26[v25] = v27 or true;
            end;
        end;

        return v23;
    end,

    item = function(p28) -- Line: 76
        -- upvalues: u12 (copy), u1 (copy), u2 (ref)
        return u12._getZonesAndItems("item", u1, u2, true, p28);
    end
};

function u12._registerZone(p30) -- Line: 84
    -- upvalues: u4 (copy), Janitor (copy), u12 (copy)
    u4[p30] = true;
    local v31 = p30.janitor:add(Janitor.new(), "destroy");
    p30._registeredJanitor = v31;
    v31:add(p30.updated:Connect(function() -- Line: 88
        -- upvalues: u12 (ref)
        u12._updateZoneDetails();
    end), "Disconnect");
    u12._updateZoneDetails();
end;

function u12._deregisterZone(p32) -- Line: 94
    -- upvalues: u4 (copy), u12 (copy)
    u4[p32] = nil;
    p32._registeredJanitor:destroy();
    p32._registeredJanitor = nil;
    u12._updateZoneDetails();
end;

function u12._registerConnection(p33, p34) -- Line: 101
    -- upvalues: u9 (ref), u1 (copy), u12 (copy), u3 (copy), u29 (copy)
    local v35 = 0;

    for _, _ in pairs(p33.activeTriggers) do
        v35 = v35 + 1;
    end;

    u9 = u9 + 1;

    if v35 == 0 then
        u1[p33] = true;
        u12._updateZoneDetails();
    end;

    local v36 = u3[p34];
    u3[p34] = v36 and v36 + 1 or 1;
    p33.activeTriggers[p34] = true;

    if p33.touchedConnectionActions[p34] then
        p33:_formTouchedConnection(p34);
    end;

    if u29[p34] then
        u12._formHeartbeat(p34);
    end;
end;

function u12.updateDetection(p37) -- Line: 121
    -- upvalues: Tracker (copy), enums (copy)
    for i, v in pairs({
        enterDetection = "_currentEnterDetection",
        exitDetection = "_currentExitDetection"
    }) do
        local v38 = p37[i];
        local v39 = Tracker.getCombinedTotalVolumes();

        if v38 == enums.Detection.Automatic then
            if v39 > 729000 then
                v38 = enums.Detection.Centre;
            else
                v38 = enums.Detection.WholeBody;
            end;
        end;

        p37[v] = v38;
    end;
end;

function u12._formHeartbeat(u40) -- Line: 140
    -- upvalues: u10 (copy), Heartbeat (copy), u1 (copy), u12 (copy), u29 (copy), enums (copy)
    if u10[u40] then
        return;
    end;

    local u41 = 0;
    u10[u40] = Heartbeat:Connect(function() -- Line: 150
        -- upvalues: u41 (ref), u1 (ref), u40 (copy), u12 (ref), u29 (ref), enums (ref)
        local v42 = os.clock();

        if u41 <= v42 then
            local v43 = nil;
            local v44 = nil;

            for i, _ in pairs(u1) do
                if i.activeTriggers[u40] then
                    local accuracy = i.accuracy;

                    if v43 ~= nil and accuracy >= v43 then
                        accuracy = v43;
                    end;

                    u12.updateDetection(i);
                    local _currentEnterDetection = i._currentEnterDetection;

                    if v44 == nil or _currentEnterDetection < v44 then
                        v44 = _currentEnterDetection;
                        v43 = accuracy;
                    else
                        v43 = accuracy;
                    end;
                end;
            end;

            local v45 = u29[u40](v44);
            local v46 = {};
            local v47 = {};

            for i, v in pairs(v45) do
                local v48 = i.settingsGroupName and u12.getGroup(i.settingsGroupName);

                if v48 and v48.onlyEnterOnceExitedAll == true then
                    for i2, _ in pairs(v) do
                        local v49 = v46[i.settingsGroupName];

                        if not v49 then
                            v49 = {};
                            v46[i.settingsGroupName] = v49;
                        end;

                        v49[i2] = i;
                    end;

                    v47[i] = v;
                end;
            end;

            for i, v in pairs(v47) do
                local v50 = v46[i.settingsGroupName];

                if v50 then
                    for i2, _ in pairs(v) do
                        local v51 = v50[i2];

                        if v51 and v51 ~= i then
                            v[i2] = nil;
                        end;
                    end;
                end;
            end;

            local v52 = { {}, {} };

            for i, _ in pairs(u1) do
                if i.activeTriggers[u40] then
                    local accuracy = i.accuracy;
                    local v53 = v45[i] or {};
                    local v54 = false;

                    for _, _ in pairs(v53) do
                        v54 = true;
                        break;
                    end;

                    if v54 then
                        if v43 >= accuracy then
                            accuracy = v43;
                        end;
                    else
                        accuracy = v43;
                    end;

                    local v55 = i:_updateOccupants(u40, v53);
                    v52[1][i] = v55.exited;
                    v52[2][i] = v55.entered;
                    v43 = accuracy;
                end;
            end;

            local v56 = { "Exited", "Entered" };

            for i, v in pairs(v52) do
                local v57 = u40 .. v56[i];

                for i2, v2 in pairs(v) do
                    local v58 = i2[v57];

                    if v58 then
                        for _, v3 in pairs(v2) do
                            v58:Fire(v3);
                        end;
                    end;
                end;
            end;

            u41 = v42 + enums.Accuracy.getProperty(v43);
        end;
    end);
end;

function u12._deregisterConnection(p59, p60) -- Line: 249
    -- upvalues: u9 (ref), u3 (copy), u10 (copy), u1 (copy), u12 (copy)
    u9 = u9 - 1;

    if u3[p60] == 1 then
        u3[p60] = nil;
        local v61 = u10[p60];

        if v61 then
            u10[p60] = nil;
            v61:Disconnect();
        end;
    else
        local v62 = u3;
        v62[p60] = v62[p60] - 1;
    end;

    p59.activeTriggers[p60] = nil;
    local v63 = 0;

    for _, _ in pairs(p59.activeTriggers) do
        v63 = v63 + 1;
    end;

    if v63 == 0 then
        u1[p59] = nil;
        u12._updateZoneDetails();
    end;

    if p59.touchedConnectionActions[p60] then
        p59:_disconnectTouchedConnection(p60);
    end;
end;

function u12._updateZoneDetails() -- Line: 271
    -- upvalues: u5 (ref), u6 (ref), u7 (ref), u8 (ref), u2 (ref), u4 (copy), u1 (copy)
    u5 = {};
    u6 = {};
    u7 = {};
    u8 = {};
    u2 = 0;

    for i, _ in pairs(u4) do
        local v64 = u1[i];

        if v64 then
            u2 = u2 + i.volume;
        end;

        for _, v in pairs(i.zoneParts) do
            if v64 then
                table.insert(u5, v);
                u6[v] = i;
            end;

            table.insert(u7, v);
            u8[v] = i;
        end;
    end;
end;

function u12._getZonesAndItems(p65, p66, p67, p68, p69) -- Line: 293
    -- upvalues: u13 (copy), u12 (copy), Players (copy), CollectiveWorldModel (copy)
    if not p67 then
        for i, _ in pairs(p66) do
            p67 = p67 + i.volume;
        end;
    end;

    local v70 = {};
    local v71 = u13[p65];

    if v71.totalVolume < p67 then
        for _, v in pairs(v71.items) do
            local v72 = u12.getTouchingZones(v, p68, p69, v71);

            for _, v2 in pairs(v72) do
                if not p68 or v2.activeTriggers[p65] then
                    local v73;

                    if p65 == "player" then
                        v73 = Players:GetPlayerFromCharacter(v);
                    else
                        v73 = v;
                    end;

                    if v73 then
                        local v74 = v70[v2];

                        if not v74 then
                            v74 = {};
                            v70[v2] = v74;
                        end;

                        local v75 = v73:IsA("Player") and v73.Character;
                        v74[v73] = v75 or true;
                    end;
                end;
            end;
        end;

        return v70;
    end;

    for i, _ in pairs(p66) do
        if not p68 or i.activeTriggers[p65] then
            local v76 = CollectiveWorldModel:GetPartBoundsInBox(i.region.CFrame, i.region.Size, v71.whitelistParams);
            local v77 = {};

            for _, v in pairs(v76) do
                local v78 = v71.partToItem[v];

                if not v77[v78] then
                    v77[v78] = true;
                end;
            end;

            for i2, _ in pairs(v77) do
                if p65 == "player" then
                    local v79 = Players:GetPlayerFromCharacter(i2);

                    if i:findPlayer(v79) then
                        local v80 = v70[i];

                        if not v80 then
                            v80 = {};
                            v70[i] = v80;
                        end;

                        local v81 = v79:IsA("Player") and v79.Character;
                        v80[v79] = v81 or true;
                    end;
                elseif i:findItem(i2) then
                    local v82 = v70[i];

                    if not v82 then
                        v82 = {};
                        v70[i] = v82;
                    end;

                    local v83 = i2:IsA("Player") and i2.Character;
                    v82[i2] = v83 or true;
                end;
            end;
        end;
    end;

    return v70;
end;

function u12.getZones() -- Line: 354
    -- upvalues: u4 (copy)
    local v84 = {};

    for i, _ in pairs(u4) do
        table.insert(v84, i);
    end;

    return v84;
end;

function u12.getTouchingZones(p85, p86, p87, p88) -- Line: 374
    -- upvalues: enums (copy), Tracker (copy), u5 (ref), u7 (ref), u6 (ref), u8 (ref), CollectiveWorldModel (copy)
    local v89;

    if p88 then
        v89 = p88.exitDetections[p85];
        p88.exitDetections[p85] = nil;
    else
        v89 = nil;
    end;

    local v90 = v89 or p87;
    local v91 = nil;
    local v92 = nil;
    local v93 = p85:IsA("BasePart");
    local v94 = not v93;
    local v95 = {};

    if v93 then
        v91 = p85.Size;
        v92 = p85.CFrame;
        table.insert(v95, p85);
    elseif v90 == enums.Detection.WholeBody then
        v91, v92 = Tracker.getCharacterSize(p85);
        v95 = p85:GetChildren();
    else
        local HumanoidRootPart = p85:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart then
            v91 = HumanoidRootPart.Size;
            v92 = HumanoidRootPart.CFrame;
            table.insert(v95, HumanoidRootPart);
        end;
    end;

    if not (v91 and v92) then
        return {};
    end;

    local v96 = p86 and u5 or u7;
    local v97 = p86 and u6 or u8;
    local v98 = OverlapParams.new();
    v98.FilterType = Enum.RaycastFilterType.Whitelist;
    v98.MaxParts = #v96;
    v98.FilterDescendantsInstances = v96;
    local v99 = CollectiveWorldModel:GetPartBoundsInBox(v92, v91, v98);
    local v100 = {};
    local v101 = {};
    local v102 = {};

    for _, v in pairs(v99) do
        local v103 = v97[v];

        if v103 and v103.allZonePartsAreBlocks then
            v100[v103] = true;
            v101[v] = v103;
        else
            table.insert(v102, v);
        end;
    end;

    local v104 = #v102;
    local v105 = 0;

    if v104 > 0 then
        local v106 = OverlapParams.new();
        v106.FilterType = Enum.RaycastFilterType.Whitelist;
        v106.MaxParts = v104;
        v106.FilterDescendantsInstances = v102;

        for _, v in pairs(v95) do
            local v107 = false;

            if v:IsA("BasePart") and not (v94 and Tracker.bodyPartsToIgnore[v.Name]) then
                local v108 = CollectiveWorldModel:GetPartsInPart(v, v106);

                for _, v2 in pairs(v108) do
                    if not v101[v2] then
                        local v109 = v97[v2];

                        if v109 then
                            v100[v109] = true;
                            v101[v2] = v109;
                            v105 = v105 + 1;
                        end;

                        if v105 == v104 then
                            v107 = true;
                            break;
                        end;
                    end;
                end;

                if v107 then
                    break;
                end;
            end;
        end;
    end;

    local v110 = nil;
    local v111 = {};

    for i, _ in pairs(v100) do
        if v110 == nil or i._currentExitDetection < v110 then
            v110 = i._currentExitDetection;
        end;

        table.insert(v111, i);
    end;

    if v110 and p88 then
        p88.exitDetections[p85] = v110;
    end;

    return v111, v101;
end;

local u112 = {};

function u12.setGroup(p113, p114) -- Line: 491
    -- upvalues: u112 (copy)
    local v115 = u112[p113];

    if not v115 then
        v115 = {};
        u112[p113] = v115;
    end;

    v115.onlyEnterOnceExitedAll = true;
    v115._name = p113;
    v115._memberZones = {};

    if typeof(p114) == "table" then
        for i, v in pairs(p114) do
            v115[i] = v;
        end;
    end;

    return v115;
end;

function u12.getGroup(p116) -- Line: 515
    -- upvalues: u112 (copy)
    return u112[p116];
end;

local u117 = nil;
local u118 = string.format("ZonePlus%sContainer", RunService:IsClient() and "Client" or "Server");

function u12.getWorkspaceContainer() -- Line: 521
    -- upvalues: u117 (ref), u118 (copy)
    local v119 = u117 or workspace:FindFirstChild(u118);

    if not v119 then
        v119 = Instance.new("Folder");
        v119.Name = u118;
        v119.Parent = workspace;
        u117 = v119;
    end;

    return v119;
end;

return u12;