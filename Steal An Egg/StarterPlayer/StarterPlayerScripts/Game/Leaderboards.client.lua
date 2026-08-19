-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Player = require(ReplicatedStorage.Library.Player);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local LocalPlayer = Players.LocalPlayer;
local u1 = {};
local u2 = 0;

local function getLeaderboardPart(p3) -- Line: 30
    local Adornee = p3.Adornee;

    if Adornee and Adornee:IsA("BasePart") then
        return Adornee;
    end;

    local Parent = p3.Parent;

    if Parent and Parent:IsA("BasePart") then
        return Parent;
    end;

    return nil;
end;

local function updateLeaderboard(p4, p5) -- Line: 44
    -- upvalues: u1 (copy)
    local v6 = u1[p4];

    if not v6 then
        return;
    end;

    local v7 = true;
    local MaxDistance = v6.Gui.MaxDistance;

    if p5 then
        if MaxDistance > 0 then
            v7 = (p5.Position - v6.Part.Position).Magnitude <= MaxDistance;
        end;
    else
        v7 = false;
    end;

    if v6.Gui.Enabled ~= v7 then
        v6.Gui.Enabled = v7;
    end;
end;

local function updateLeaderboards() -- Line: 119
    -- upvalues: Player (copy), LocalPlayer (copy), u1 (copy)
    local v8 = Player.Optional.HumanoidRootPart(LocalPlayer);

    for i in u1 do
        local v9 = u1[i];

        if v9 then
            local v10 = true;
            local MaxDistance = v9.Gui.MaxDistance;

            if v8 then
                if MaxDistance > 0 then
                    v10 = (v8.Position - v9.Part.Position).Magnitude <= MaxDistance;
                end;
            else
                v10 = false;
            end;

            if v9.Gui.Enabled ~= v10 then
                v9.Gui.Enabled = v10;
            end;
        end;
    end;
end;

local function stepLeaderboards(p11) -- Line: 126
    -- upvalues: u2 (ref), Player (copy), LocalPlayer (copy), u1 (copy)
    u2 = u2 + p11;

    if u2 < 0.2 then
        return;
    end;

    u2 = 0;
    local v12 = Player.Optional.HumanoidRootPart(LocalPlayer);

    for i in u1 do
        local v13 = u1[i];

        if v13 then
            local v14 = true;
            local MaxDistance = v13.Gui.MaxDistance;

            if v12 then
                if MaxDistance > 0 then
                    v14 = (v12.Position - v13.Part.Position).Magnitude <= MaxDistance;
                end;
            else
                v14 = false;
            end;

            if v13.Gui.Enabled ~= v14 then
                v13.Gui.Enabled = v14;
            end;
        end;
    end;
end;

local function trackLeaderboard(u15) -- Line: 79
    -- upvalues: u1 (copy), Trove (copy), Player (copy), LocalPlayer (copy)
    if not u15:IsA("ScrollingFrame") then
        return;
    end;

    local v16 = u1[u15];

    if v16 then
        v16.Trove:Clean();

        if v16.Gui.Parent then
            v16.Gui.Enabled = true;
        end;

        u1[u15] = nil;
    end;

    local Parent = u15.Parent;

    if not (Parent and Parent:IsA("Frame")) then
        return;
    end;

    local Parent2 = Parent.Parent;

    if not (Parent2 and Parent2:IsA("SurfaceGui")) then
        return;
    end;

    local Adornee = Parent2.Adornee;

    if not (Adornee and Adornee:IsA("BasePart")) then
        Adornee = Parent2.Parent;

        if not (Adornee and Adornee:IsA("BasePart")) then
            Adornee = nil;
        end;
    end;

    if not Adornee then
        return;
    end;

    local v17 = Trove.new();
    u1[u15] = {
        Part = Adornee,
        Gui = Parent2,
        Trove = v17
    };
    v17:Add(u15.Destroying:Connect(function() -- Line: 108
        -- upvalues: u15 (copy), u1 (ref)
        local v18 = u15;
        local v19 = u1[v18];

        if not v19 then
            return;
        end;

        v19.Trove:Clean();

        if v19.Gui.Parent then
            v19.Gui.Enabled = true;
        end;

        u1[v18] = nil;
    end));
    v17:Add(Parent2.Destroying:Connect(function() -- Line: 112
        -- upvalues: u15 (copy), u1 (ref)
        local v20 = u15;
        local v21 = u1[v20];

        if not v21 then
            return;
        end;

        v21.Trove:Clean();

        if v21.Gui.Parent then
            v21.Gui.Enabled = true;
        end;

        u1[v20] = nil;
    end));
    local v22 = Player.Optional.HumanoidRootPart(LocalPlayer);
    local v23 = u1[u15];

    if not v23 then
        return;
    end;

    local v24 = true;
    local MaxDistance = v23.Gui.MaxDistance;

    if v22 then
        if MaxDistance > 0 then
            v24 = (v22.Position - v23.Part.Position).Magnitude <= MaxDistance;
        end;
    else
        v24 = false;
    end;

    if v23.Gui.Enabled ~= v24 then
        v23.Gui.Enabled = v24;
    end;
end;

local function cleanupLeaderboard(p25) -- Line: 65
    -- upvalues: u1 (copy)
    local v26 = u1[p25];

    if not v26 then
        return;
    end;

    v26.Trove:Clean();

    if v26.Gui.Parent then
        v26.Gui.Enabled = true;
    end;

    u1[p25] = nil;
end;

for _, v in CollectionService:GetTagged("Leaderboard") do
    trackLeaderboard(v);
end;

CollectionService:GetInstanceAddedSignal("Leaderboard"):Connect(trackLeaderboard);
CollectionService:GetInstanceRemovedSignal("Leaderboard"):Connect(cleanupLeaderboard);
RunService.Heartbeat:Connect(stepLeaderboards);