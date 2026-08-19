-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local _ = game:GetService("RunService").Heartbeat;
local Signal = require(script.Parent.Parent.Signal);
local Janitor = require(script.Parent.Parent.Janitor);
local u1 = {};
u1.__index = u1;
local u2 = {};
u1.trackers = u2;
u1.itemAdded = Signal.new();
u1.itemRemoved = Signal.new();
u1.bodyPartsToIgnore = {
    UpperTorso = true,
    LowerTorso = true,
    Torso = true,
    LeftHand = true,
    RightHand = true,
    LeftFoot = true,
    RightFoot = true
};

function u1.getCombinedTotalVolumes() -- Line: 35
    -- upvalues: u2 (copy)
    local v3 = 0;

    for i, _ in pairs(u2) do
        v3 = v3 + i.totalVolume;
    end;

    return v3;
end;

function u1.getCharacterSize(p4) -- Line: 43
    local v5;

    if p4 then
        v5 = p4:FindFirstChild("Head");
    else
        v5 = p4;
    end;

    if p4 then
        p4 = p4:FindFirstChild("HumanoidRootPart");
    end;

    if not (p4 and v5) then
        return nil;
    end;

    if not v5:IsA("BasePart") then
        v5 = p4;
    end;

    local Y = v5.Size.Y;
    local Size = p4.Size;

    return Size * Vector3.new(2, 2, 1) + Vector3.new(0, Y, 0), p4.CFrame * CFrame.new(0, Y / 2 - Size.Y / 2, 0);
end;

function u1.new(p6) -- Line: 60
    -- upvalues: u1 (copy), Janitor (copy), Players (copy), u2 (copy)
    local u7 = {};
    setmetatable(u7, u1);
    u7.name = p6;
    u7.totalVolume = 0;
    u7.parts = {};
    u7.partToItem = {};
    u7.items = {};
    u7.whitelistParams = nil;
    u7.characters = {};
    u7.baseParts = {};
    u7.exitDetections = {};
    u7.janitor = Janitor.new();

    if p6 == "player" then
        local function updatePlayerCharacters() -- Line: 76
            -- upvalues: Players (ref), u7 (copy)
            local v8 = {};

            for _, v in pairs(Players:GetPlayers()) do
                local Character = v.Character;

                if Character then
                    v8[Character] = true;
                end;
            end;

            u7.characters = v8;
        end;

        local function playerAdded(p9) -- Line: 87
            -- upvalues: updatePlayerCharacters (copy), u7 (copy)
            local function charAdded(p10) -- Line: 88
                -- upvalues: updatePlayerCharacters (ref), u7 (ref)
                local v11 = p10:FindFirstChildOfClass("Humanoid");

                if not v11 then
                    local v12 = tick();

                    repeat
                        task.wait(0.1);
                        v11 = p10:FindFirstChildOfClass("Humanoid");
                    until v11 or tick() - v12 > 3;
                end;

                if v11 then
                    updatePlayerCharacters();
                    u7:update();

                    for _, child in pairs(v11:GetChildren()) do
                        if child:IsA("NumberValue") then
                            child.Changed:Connect(function() -- Line: 102
                                -- upvalues: u7 (ref)
                                u7:update();
                            end);
                        end;
                    end;
                end;
            end;

            if p9.Character then
                charAdded(p9.Character);
            end;

            p9.CharacterAdded:Connect(charAdded);
            p9.CharacterRemoving:Connect(function(p13) -- Line: 113
                -- upvalues: u7 (ref)
                u7.exitDetections[p13] = nil;
            end);
        end;

        Players.PlayerAdded:Connect(playerAdded);

        for _, v in pairs(Players:GetPlayers()) do
            playerAdded(v);
        end;

        Players.PlayerRemoving:Connect(function(p14) -- Line: 123
            -- upvalues: updatePlayerCharacters (copy), u7 (copy)
            updatePlayerCharacters();
            u7:update();
        end);
    elseif p6 == "item" then
        local function updateItem(p15, p16) -- Line: 130
            -- upvalues: u7 (copy)
            if p15.isCharacter then
                u7.characters[p15.item] = p16;
            elseif p15.isBasePart then
                u7.baseParts[p15.item] = p16;
            end;

            u7:update();
        end;

        u1.itemAdded:Connect(function(p17) -- Line: 138
            -- upvalues: u7 (copy)
            if p17.isCharacter then
                u7.characters[p17.item] = true;
            elseif p17.isBasePart then
                u7.baseParts[p17.item] = true;
            end;

            u7:update();
        end);
        u1.itemRemoved:Connect(function(p18) -- Line: 141
            -- upvalues: u7 (copy)
            u7.exitDetections[p18.item] = nil;

            if p18.isCharacter then
                u7.characters[p18.item] = nil;
            elseif p18.isBasePart then
                u7.baseParts[p18.item] = nil;
            end;

            u7:update();
        end);
    end;

    u2[u7] = true;
    task.defer(u7.update, u7);

    return u7;
end;

function u1._preventMultiFrameUpdates(u19, u20, ...) -- Line: 155
    u19._preventMultiDetails = u19._preventMultiDetails or {};
    local u21 = u19._preventMultiDetails[u20];

    if not u21 then
        u21 = {
            calling = false,
            callsThisFrame = 0,
            updatedThisFrame = false
        };
        u19._preventMultiDetails[u20] = u21;
    end;

    u21.callsThisFrame = u21.callsThisFrame + 1;

    if u21.callsThisFrame ~= 1 then
        return true;
    end;

    local u22 = table.pack(...);
    task.defer(function() -- Line: 172
        -- upvalues: u21 (ref), u19 (copy), u20 (copy), u22 (copy)
        local callsThisFrame = u21.callsThisFrame;
        u21.callsThisFrame = 0;

        if callsThisFrame > 1 then
            u19[u20](u19, unpack(u22));
        end;
    end);

    return false;
end;

function u1.update(u23) -- Line: 184
    -- upvalues: u1 (copy), Janitor (copy)
    if u23:_preventMultiFrameUpdates("update") then
        return;
    end;

    u23.totalVolume = 0;
    u23.parts = {};
    u23.partToItem = {};
    u23.items = {};

    for i, _ in pairs(u23.characters) do
        local v24 = u1.getCharacterSize(i);

        if v24 then
            u23.totalVolume = u23.totalVolume + v24.X * v24.Y * v24.Z;
            local u25 = u23.janitor:add(Janitor.new(), "destroy", "trackCharacterParts-" .. u23.name);

            local function updateTrackerOnParentChanged(u26) -- Line: 205
                -- upvalues: u25 (ref), u23 (copy)
                u25:add(u26.AncestryChanged:Connect(function() -- Line: 206
                    -- upvalues: u26 (copy), u25 (ref), u23 (ref)
                    if not u26:IsDescendantOf(game) and (u26.Parent == nil and u25 ~= nil) then
                        u25:destroy();
                        u25 = nil;
                        u23:update();
                    end;
                end), "Disconnect");
            end;

            for _, child in pairs(i:GetChildren()) do
                if child:IsA("BasePart") and not u1.bodyPartsToIgnore[child.Name] then
                    u23.partToItem[child] = i;
                    table.insert(u23.parts, child);
                    u25:add(child.AncestryChanged:Connect(function() -- Line: 206
                        -- upvalues: child (copy), u25 (ref), u23 (copy)
                        if not child:IsDescendantOf(game) and (child.Parent == nil and u25 ~= nil) then
                            u25:destroy();
                            u25 = nil;
                            u23:update();
                        end;
                    end), "Disconnect");
                end;
            end;

            u25:add(i.AncestryChanged:Connect(function() -- Line: 206
                -- upvalues: i (copy), u25 (ref), u23 (copy)
                if not i:IsDescendantOf(game) and (i.Parent == nil and u25 ~= nil) then
                    u25:destroy();
                    u25 = nil;
                    u23:update();
                end;
            end), "Disconnect");
            table.insert(u23.items, i);
        end;
    end;

    for i, _ in pairs(u23.baseParts) do
        local Size = i.Size;
        u23.totalVolume = u23.totalVolume + Size.X * Size.Y * Size.Z;
        u23.partToItem[i] = i;
        table.insert(u23.parts, i);
        table.insert(u23.items, i);
    end;

    u23.whitelistParams = OverlapParams.new();
    u23.whitelistParams.FilterType = Enum.RaycastFilterType.Whitelist;
    u23.whitelistParams.MaxParts = #u23.parts;
    u23.whitelistParams.FilterDescendantsInstances = u23.parts;
end;

return u1;