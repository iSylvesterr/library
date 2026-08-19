-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local Networking = require(ReplicatedStorage.SharedModules.Networking);
require(ReplicatedStorage.ClientModules.Signal).new();
local u1 = {};
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = false;
local u6 = nil;
local u7 = 0;
local u8 = 0;
local u9 = nil;
local u10 = OverlapParams.new();
u10.FilterType = Enum.RaycastFilterType.Include;
u10.FilterDescendantsInstances = {};

local function rebuildOverlapFilter() -- Line: 39
    -- upvalues: Players (copy), u10 (copy)
    local v11 = {};

    for _, v in Players:GetPlayers() do
        if v.Character then
            table.insert(v11, v.Character);
        end;
    end;

    u10.FilterDescendantsInstances = v11;
end;

Players.PlayerAdded:Connect(rebuildOverlapFilter);
Players.PlayerRemoving:Connect(rebuildOverlapFilter);
task.spawn(function() -- Line: 52
    -- upvalues: rebuildOverlapFilter (copy)
    while true do
        rebuildOverlapFilter();
        task.wait(5);
    end;
end);

function u1.GetPlantFromFruit(p12, p13) -- Line: 59
    local Parent = p13.Parent;

    if Parent and (not Parent or Parent.Name == "Fruits") then
        return Parent.Parent;
    end;
end;

function u1.UpdateAppearance(p14, p15, p16) -- Line: 65
    -- upvalues: ReplicatedStorage (copy), CollectionService (copy)
    if not p16 then
        for _, v in CollectionService:GetTagged("GhostPepperAppearance") do
            if v:IsDescendantOf(p15) then
                v:RemoveTag("GhostPepperAppearance");

                if v:IsA("ParticleEmitter") then
                    v.Enabled = false;
                    game.Debris:AddItem(v, 1);
                end;
            end;
        end;

        return;
    end;

    local BurningVFX = ReplicatedStorage.Assets.VFX.StatusVFX:FindFirstChild("BurningVFX");

    if BurningVFX == nil then
        return;
    end;

    for _, child in BurningVFX:GetChildren() do
        local v17 = child:Clone();
        v17.Parent = p15:FindFirstChild("Torso") or p15.PrimaryPart;
        v17.Enabled = true;
        v17:AddTag("GhostPepperAppearance");
    end;
end;

function u1.StartLocalBurnEffects(p18) -- Line: 95
    -- upvalues: u5 (ref), u7 (ref), u8 (ref), LocalPlayer (copy), u9 (ref), u6 (ref), RunService (copy)
    if u5 then
        return;
    end;

    u5 = true;
    u7 = tick();
    u8 = 0;
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    if Character then
        Character.WalkSpeed = Character.WalkSpeed + 7;
        u9 = Character;
    end;

    u6 = RunService.Heartbeat:Connect(function() -- Line: 113
        -- upvalues: u7 (ref), LocalPlayer (ref), u8 (ref)
        local v19 = tick() - u7;
        local Character2 = LocalPlayer.Character;

        if Character2 then
            Character2 = Character2:FindFirstChildOfClass("Humanoid");
        end;

        if Character2 and Character2.Health > 0 then
            Character2.Jump = true;
        end;

        if Character2 and (Character2.Health > 0 and v19 - u8 >= 0.1) then
            u8 = v19;
            Character2:TakeDamage(1);
        end;
    end);
end;

function u1.StopLocalBurnEffects(p20) -- Line: 132
    -- upvalues: u5 (ref), u6 (ref), u9 (ref)
    if not u5 then
        return;
    end;

    u5 = false;

    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;

    if u9 and u9.Parent then
        u9.WalkSpeed = u9.WalkSpeed - 7;
    end;

    u9 = nil;
end;

LocalPlayer.CharacterAdded:Connect(function() -- Line: 152
    -- upvalues: u5 (ref), u6 (ref), u9 (ref)
    if u5 then
        u5 = false;

        if u6 then
            u6:Disconnect();
            u6 = nil;
        end;

        u9 = nil;
    end;
end);

function u1.StartOrRefreshBurn(p21, u22, p23, p24) -- Line: 165
    -- upvalues: u3 (copy), u1 (copy), LocalPlayer (copy), Networking (copy), u4 (copy)
    if table.find(u3, u22) == nil then
        table.insert(u3, u22);
        u1:UpdateAppearance(u22.Character, true);

        if u22 == LocalPlayer then
            u1:StartLocalBurnEffects();
        end;

        if p23 then
            Networking.GhostPepperService.TouchBegan:Fire(u22.Character, p23, p24 or "");
        end;
    end;

    local u25 = {};
    u4[u22] = u25;
    task.delay(5, function() -- Line: 185
        -- upvalues: u4 (ref), u22 (copy), u25 (copy), u1 (ref)
        if u4[u22] ~= u25 then
            return;
        end;

        u4[u22] = nil;
        u1:EndBurn(u22);
    end);
end;

function u1.EndBurn(p26, p27) -- Line: 194
    -- upvalues: u3 (copy), u1 (copy), LocalPlayer (copy), Networking (copy)
    local v28 = table.find(u3, p27);

    if not v28 then
        return;
    end;

    table.remove(u3, v28);

    if p27.Character then
        u1:UpdateAppearance(p27.Character, false);
    end;

    if p27 == LocalPlayer then
        u1:StopLocalBurnEffects();
    end;

    Networking.GhostPepperService.TouchEnded:Fire(p27.Character);
end;

function u1.RegisterPoisonObject(p29, p30) -- Line: 211
    -- upvalues: u2 (copy)
    table.insert(u2, {
        Object = p30
    });
end;

function u1.UnregisterPoisonObject(p31, p32) -- Line: 217
    -- upvalues: u2 (copy)
    for i, v in u2 do
        if v.Object == p32 then
            table.remove(u2, i);

            return;
        end;
    end;
end;

function u1.GetTouchingParts(p33, p34) -- Line: 226
    -- upvalues: Players (copy), u10 (copy), u1 (copy), LocalPlayer (copy)
    local Position = p34.Position;
    local v35 = false;

    for _, v in Players:GetPlayers() do
        local Character = v.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        if Character and (Character.Position - Position).Magnitude < 30 then
            v35 = true;
            break;
        end;
    end;

    if not v35 then
        return;
    end;

    local v36 = workspace:GetPartsInPart(p34, u10);

    if #v36 == 0 then
        return;
    end;

    local v37 = {};

    for _, v in v36 do
        if v.Parent then
            local v38 = v:FindFirstAncestorWhichIsA("Model");
            local v39;

            if v38 then
                v39 = Players:GetPlayerFromCharacter(v38);
            else
                v39 = nil;
            end;

            if v39 and not v37[v39] then
                local v40 = u1:GetPlantFromFruit(p34.Parent);

                if v40 then
                    local v41 = v40:GetAttribute("UserId");

                    if v41 and (not v41 or v41 ~= LocalPlayer.UserId) then
                        v37[v39] = true;
                        local v42;

                        if p34.Parent then
                            v42 = p34.Parent:GetAttribute("FruitId") or nil;
                        else
                            v42 = nil;
                        end;

                        local v43;

                        if p34.Parent then
                            v43 = p34.Parent:GetAttribute("PlantId") or nil;
                        else
                            v43 = nil;
                        end;

                        u1:StartOrRefreshBurn(v39, v42, v43);
                    end;
                end;
            end;
        end;
    end;
end;

function u1.Routine(p44) -- Line: 265
    -- upvalues: u2 (copy), u1 (copy)
    for _, v in u2 do
        u1:GetTouchingParts(v.Object);
    end;
end;

function u1.Init(p45) -- Line: 274
    -- upvalues: CollectionService (copy), u1 (copy)
    for _, v in CollectionService:GetTagged("GhostPepper") do
        u1:RegisterPoisonObject(v);
    end;

    CollectionService:GetInstanceAddedSignal("GhostPepper"):Connect(function(p46) -- Line: 279
        -- upvalues: u1 (ref)
        u1:RegisterPoisonObject(p46);
    end);
    CollectionService:GetInstanceRemovedSignal("GhostPepper"):Connect(function(p47) -- Line: 283
        -- upvalues: u1 (ref)
        u1:UnregisterPoisonObject(p47);
    end);
    task.spawn(function() -- Line: 287
        -- upvalues: u1 (ref)
        while true do
            u1:Routine();
            task.wait(0.5);
        end;
    end);
end;

return u1;