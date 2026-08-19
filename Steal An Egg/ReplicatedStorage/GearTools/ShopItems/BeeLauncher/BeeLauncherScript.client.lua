-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local ToolGameplayGuard = require(ReplicatedStorage.Library.Client.ToolGameplayGuard);
local LocalPlayer = Players.LocalPlayer;
LocalPlayer:GetMouse();
local Parent = script.Parent;
local u1 = 0;
local BeeLauncherRemote = script.Parent:WaitForChild("BeeLauncherRemote");
local u2 = nil;
local u3 = {};

local function removePlayerHighlights(p4) -- Line: 21
    -- upvalues: u3 (ref)
    if u3[p4] then
        for _, v in pairs(u3[p4]) do
            if v and v.Parent then
                v:Destroy();
            end;
        end;

        u3[p4] = nil;
    end;
end;

local function addPlayerHighlights(p5) -- Line: 32
    -- upvalues: removePlayerHighlights (copy), u3 (ref)
    local Character = p5.Character;

    if not Character then
        return;
    end;

    removePlayerHighlights(p5);
    local v6 = {};
    local Highlight = Instance.new("Highlight");
    Highlight.OutlineColor = Color3.new(1, 0.933333, 0);
    Highlight.Parent = Character;
    table.insert(v6, Highlight);
    u3[p5] = v6;
end;

local function onUnequipped() -- Line: 50
    -- upvalues: u2 (ref), u3 (ref)
    if u2 then
        u2:Disconnect();
        u2 = nil;
    end;

    for _, v in pairs(u3) do
        for _, v2 in pairs(v) do
            if v2 and v2.Parent then
                v2:Destroy();
            end;
        end;
    end;

    u3 = {};
end;

local function onActivated() -- Line: 103
    -- upvalues: ToolGameplayGuard (copy), Parent (copy), LocalPlayer (copy), u1 (ref), Players (copy), BeeLauncherRemote (copy)
    if not ToolGameplayGuard.CanActivateLocal(Parent) then
        return;
    end;

    if not (LocalPlayer.Character and LocalPlayer.Character.PrimaryPart) then
        return;
    end;

    local Position = LocalPlayer.Character.PrimaryPart.Position;
    local v7 = tick();

    if v7 - u1 < 60 then
        return;
    end;

    u1 = v7;

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and (v.Character and v.Character.PrimaryPart) then
            local _ = (v.Character.PrimaryPart.Position - Position).Magnitude <= 30;
        end;
    end;

    BeeLauncherRemote:FireServer(Position);
end;

Parent.Equipped:Connect(function() -- Line: 66, Name: onEquipped
    -- upvalues: u2 (ref), RunService (copy), LocalPlayer (copy), onUnequipped (copy), Players (copy), u3 (ref), addPlayerHighlights (copy), removePlayerHighlights (copy)
    if u2 then
        u2:Disconnect();
    end;

    u2 = RunService.Heartbeat:Connect(function() -- Line: 71
        -- upvalues: LocalPlayer (ref), onUnequipped (ref), Players (ref), u3 (ref), addPlayerHighlights (ref), removePlayerHighlights (ref)
        if not (LocalPlayer.Character and LocalPlayer.Character.PrimaryPart) then
            onUnequipped();

            return;
        end;

        local Position = LocalPlayer.Character.PrimaryPart.Position;
        local v8 = {};

        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and (v.Character and v.Character.PrimaryPart) then
                if (v.Character.PrimaryPart.Position - Position).Magnitude <= 30 then
                    table.insert(v8, v);

                    if not u3[v] then
                        addPlayerHighlights(v);
                    end;
                else
                    removePlayerHighlights(v);
                end;
            end;
        end;

        for i, _ in pairs(u3) do
            if not table.find(v8, i) and i ~= LocalPlayer then
                removePlayerHighlights(i);
            end;
        end;
    end);
end);
Parent.Unequipped:Connect(onUnequipped);
Parent.Activated:Connect(onActivated);
LocalPlayer.CharacterRemoving:Connect(function() -- Line: 137
    -- upvalues: onUnequipped (copy)
    onUnequipped();
end);