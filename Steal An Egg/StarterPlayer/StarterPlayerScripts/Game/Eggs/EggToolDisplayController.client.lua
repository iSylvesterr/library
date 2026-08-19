-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds);
local EggToolDisplay = require(ReplicatedStorage.Library.Client.Eggs.EggToolDisplay);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = Log.new();
local u2 = {};

local function destroyActiveDisplay(p3) -- Line: 31
    p3.ActiveDisplayVersion = p3.ActiveDisplayVersion + 1;

    if p3.ActiveDisplay ~= nil then
        p3.ActiveDisplay:Destroy();
        p3.ActiveDisplay = nil;
    end;

    p3.ActiveTool = nil;
end;

local function attachTool(p4, p5) -- Line: 40
    -- upvalues: EggToolDisplay (copy), u1 (copy), EggCmds (copy), Players (copy)
    if p4.ActiveTool == p5 then
        return;
    end;

    p4.ActiveDisplayVersion = p4.ActiveDisplayVersion + 1;

    if p4.ActiveDisplay ~= nil then
        p4.ActiveDisplay:Destroy();
        p4.ActiveDisplay = nil;
    end;

    p4.ActiveTool = nil;
    local v6 = EggToolDisplay.GetToolUid(p5);

    if v6 == nil then
        u1:AtError():Log((`Egg tool {p5:GetFullName()} is missing an egg UID`));

        return;
    end;

    local v7 = EggCmds.GetRuntimeRecord(p4.Owner.UserId, v6);

    if v7 == nil and p4.Owner == Players.LocalPlayer then
        v7 = EggCmds.RequestLocalEggRecord(v6);
    end;

    if v7 == nil then
        u1:AtDebug():Log((`Egg tool {p5:GetFullName()} has no record for owner {p4.Owner.UserId}`));

        return;
    end;

    p4.ActiveTool = p5;
    p4.ActiveDisplayVersion = p4.ActiveDisplayVersion + 1;
    local ActiveDisplayVersion = p4.ActiveDisplayVersion;
    local v8 = EggToolDisplay.new(p5, {
        OwnerUserId = p4.Owner.UserId,
        UID = v6,
        ModelName = `{p4.Owner.UserId}_{v6}`,
        Record = v7
    });

    if p4.ActiveTool == p5 and (p4.ActiveDisplayVersion == ActiveDisplayVersion and p5.Parent ~= nil) then
        p4.ActiveDisplay = v8;

        return;
    end;

    v8:Destroy();
end;

local function refreshActiveTool(p9) -- Line: 80
    -- upvalues: EggToolDisplay (copy), attachTool (copy)
    local Character = p9.Owner.Character;

    if Character == nil then
        return;
    end;

    for _, child in ipairs(Character:GetChildren()) do
        if child.ClassName == "Tool" and EggToolDisplay.IsEggTool(child) then
            attachTool(p9, child);

            return;
        end;
    end;
end;

local function bindCharacter(u10, p11) -- Line: 97
    -- upvalues: Trove (copy), EggToolDisplay (copy), attachTool (copy), refreshActiveTool (copy)
    if u10.CharacterTrove ~= nil then
        u10.CharacterTrove:Destroy();
    end;

    u10.ActiveDisplayVersion = u10.ActiveDisplayVersion + 1;

    if u10.ActiveDisplay ~= nil then
        u10.ActiveDisplay:Destroy();
        u10.ActiveDisplay = nil;
    end;

    u10.ActiveTool = nil;
    local v12 = Trove.new();
    u10.CharacterTrove = v12;
    v12:Connect(p11.ChildAdded, function(p13) -- Line: 105
        -- upvalues: EggToolDisplay (ref), attachTool (ref), u10 (copy)
        if p13.ClassName == "Tool" and EggToolDisplay.IsEggTool(p13) then
            attachTool(u10, p13);
        end;
    end);
    v12:Connect(p11.ChildRemoved, function(p14) -- Line: 110
        -- upvalues: u10 (copy)
        if p14 == u10.ActiveTool then
            local v15 = u10;
            v15.ActiveDisplayVersion = v15.ActiveDisplayVersion + 1;

            if v15.ActiveDisplay ~= nil then
                v15.ActiveDisplay:Destroy();
                v15.ActiveDisplay = nil;
            end;

            v15.ActiveTool = nil;
        end;
    end);
    refreshActiveTool(u10);
end;

local function trackPlayer(p16) -- Line: 131
    -- upvalues: u2 (copy), Trove (copy), bindCharacter (copy)
    local v17 = u2[p16];

    if v17 ~= nil then
        v17.ActiveDisplayVersion = v17.ActiveDisplayVersion + 1;

        if v17.ActiveDisplay ~= nil then
            v17.ActiveDisplay:Destroy();
            v17.ActiveDisplay = nil;
        end;

        v17.ActiveTool = nil;

        if v17.CharacterTrove ~= nil then
            v17.CharacterTrove:Destroy();
        end;

        v17.Trove:Destroy();
        u2[p16] = nil;
    end;

    local u18 = {
        CharacterTrove = nil,
        ActiveTool = nil,
        ActiveDisplay = nil,
        ActiveDisplayVersion = 0,
        Owner = p16,
        Trove = Trove.new()
    };
    u2[p16] = u18;
    u18.Trove:Connect(p16.CharacterAdded, function(p19) -- Line: 144
        -- upvalues: bindCharacter (ref), u18 (copy)
        bindCharacter(u18, p19);
    end);
    u18.Trove:Connect(p16.CharacterRemoving, function() -- Line: 147
        -- upvalues: u18 (copy)
        local v20 = u18;
        v20.ActiveDisplayVersion = v20.ActiveDisplayVersion + 1;

        if v20.ActiveDisplay ~= nil then
            v20.ActiveDisplay:Destroy();
            v20.ActiveDisplay = nil;
        end;

        v20.ActiveTool = nil;

        if u18.CharacterTrove ~= nil then
            u18.CharacterTrove:Destroy();
            u18.CharacterTrove = nil;
        end;
    end);

    if p16.Character ~= nil then
        bindCharacter(u18, p16.Character);
    end;
end;

Players.PlayerAdded:Connect(function(p21) -- Line: 163
    -- upvalues: trackPlayer (copy)
    task.defer(trackPlayer, p21);
end);
Players.PlayerRemoving:Connect(function(p22) -- Line: 118, Name: destroyPlayerState
    -- upvalues: u2 (copy)
    local v23 = u2[p22];

    if v23 == nil then
        return;
    end;

    v23.ActiveDisplayVersion = v23.ActiveDisplayVersion + 1;

    if v23.ActiveDisplay ~= nil then
        v23.ActiveDisplay:Destroy();
        v23.ActiveDisplay = nil;
    end;

    v23.ActiveTool = nil;

    if v23.CharacterTrove ~= nil then
        v23.CharacterTrove:Destroy();
    end;

    v23.Trove:Destroy();
    u2[p22] = nil;
end);

for _, v in ipairs(Players:GetPlayers()) do
    task.defer(trackPlayer, v);
end;