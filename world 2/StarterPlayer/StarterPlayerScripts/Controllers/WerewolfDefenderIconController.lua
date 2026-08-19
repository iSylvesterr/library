-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local WerewolfNightData = require(ReplicatedStorage.SharedModules.WerewolfNightData);
local LocalPlayer = Players.LocalPlayer;
local u2 = UDim2.fromScale(3, 3);
local u3 = {};
local u4 = {};

local function clearIcon(p5) -- Line: 36
    -- upvalues: u3 (copy)
    local v6 = u3[p5];

    if v6 then
        v6:Destroy();
        u3[p5] = nil;
    end;
end;

local function refresh(p7) -- Line: 44
    -- upvalues: WerewolfNightData (copy), u3 (copy), LocalPlayer (copy), u2 (copy)
    if p7:GetAttribute(WerewolfNightData.DefenderAttribute) ~= true then
        local v8 = u3[p7];

        if v8 then
            v8:Destroy();
            u3[p7] = nil;
        end;

        return;
    end;

    local Character = p7.Character;

    if Character then
        Character = Character:FindFirstChild("Head");
    end;

    if not (Character and Character:IsA("BasePart")) then
        local v9 = u3[p7];

        if v9 then
            v9:Destroy();
            u3[p7] = nil;
        end;

        return;
    end;

    local v10 = u3[p7];

    if v10 then
        if v10.Adornee == Character then
            return;
        end;

        local v11 = u3[p7];

        if v11 then
            v11:Destroy();
            u3[p7] = nil;
        end;
    end;

    local v12 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if not v12 then
        return;
    end;

    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Name = "WerewolfDefenderIcon";
    BillboardGui.Adornee = Character;
    BillboardGui.Size = u2;
    BillboardGui.StudsOffset = Vector3.new(0, 3, 0);
    BillboardGui.MaxDistance = 100;
    BillboardGui.LightInfluence = 0;
    BillboardGui.ResetOnSpawn = false;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.Image = WerewolfNightData.DefenderIcon;
    ImageLabel.Parent = BillboardGui;
    BillboardGui.Parent = v12;
    u3[p7] = BillboardGui;
end;

local function untrack(p13) -- Line: 91
    -- upvalues: u3 (copy), u4 (copy)
    local v14 = u3[p13];

    if v14 then
        v14:Destroy();
        u3[p13] = nil;
    end;

    local v15 = u4[p13];

    if not v15 then
        return;
    end;

    for _, v in v15 do
        v:Disconnect();
    end;

    u4[p13] = nil;
end;

local function track(u16) -- Line: 103
    -- upvalues: u4 (copy), WerewolfNightData (copy), refresh (copy), u3 (copy)
    if u4[u16] then
        return;
    end;

    local v17 = {};
    local v18 = u16:GetAttributeChangedSignal(WerewolfNightData.DefenderAttribute);
    table.insert(v17, v18:Connect(function() -- Line: 111
        -- upvalues: refresh (ref), u16 (copy)
        refresh(u16);
    end));
    table.insert(v17, u16.CharacterAdded:Connect(function(p19) -- Line: 117
        -- upvalues: refresh (ref), u16 (copy)
        p19:WaitForChild("Head", 10);
        refresh(u16);
    end));
    table.insert(v17, u16.CharacterRemoving:Connect(function() -- Line: 127
        -- upvalues: u16 (copy), u3 (ref)
        local v20 = u16;
        local v21 = u3[v20];

        if v21 then
            v21:Destroy();
            u3[v20] = nil;
        end;
    end));
    u4[u16] = v17;
    refresh(u16);
end;

function v1.Init(p22) -- Line: 136
end;

function v1.Start(p23) -- Line: 138
    -- upvalues: Players (copy), track (copy), untrack (copy)
    for _, v in Players:GetPlayers() do
        track(v);
    end;

    Players.PlayerAdded:Connect(track);
    Players.PlayerRemoving:Connect(untrack);
end;

return v1;