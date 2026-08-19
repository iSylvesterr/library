-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);
local SeedPackSpawnServerLocations = game.Workspace.Map.SeedPackSpawnServerLocations;
local SeedPackSpawnClient = game.Workspace.Map.SeedPackSpawnClient;
local SeedPacks = game.ReplicatedStorage.Assets.SeedPacks;
local Seeds = game.ReplicatedStorage.Assets.Seeds;
local PopVFXModel = game.ReplicatedStorage.Assets.PopVFXModel;
local NotificationController = require(Players.LocalPlayer.PlayerScripts.Controllers.NotificationController);
local u2 = {};
local u3 = {};
local u4 = nil;

local function StartLoop() -- Line: 34
    -- upvalues: u4 (ref), RunService (copy), u2 (copy), u3 (copy)
    if u4 then
        return;
    end;

    u4 = RunService.Heartbeat:Connect(function() -- Line: 36
        -- upvalues: u2 (ref), u3 (ref)
        local v5 = os.clock();
        local v6 = math.sin(v5 * 2) * 0.5;
        local v7 = CFrame.Angles(0, v5 * 1.5, 0);

        for _, v in u2 do
            local v8 = u3[v[3]];

            if v8 and v[3].Parent then
                v[3].CFrame = v8 * v7 + Vector3.new(0, v6, 0);
            end;
        end;
    end);
end;

local function StopLoop() -- Line: 50
    -- upvalues: u4 (ref)
    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;
end;

local function WaitForSeedPackAttributes(p9) -- Line: 60
    local v10 = os.clock() + 1;

    while p9.Parent do
        local v11 = p9:GetAttribute("SeedPack");
        local v12 = p9:GetAttribute("RainbowSeed") == true;
        local v13 = p9:GetAttribute("GoldSeed") == true;
        local v14 = p9:GetAttribute("MegaSeed") == true;

        if v11 ~= nil or (v12 or (v13 or v14)) then
            if type(v11) ~= "string" then
                v11 = nil;
            end;

            return v11, v12, v13, v14;
        end;

        if v10 <= os.clock() then
            break;
        end;

        p9:GetAttributeChangedSignal("SeedPack"):Wait();
    end;

    return nil, false, false, false;
end;

function u1.SpawnClient(p15, u16, u17) -- Line: 76
    -- upvalues: WaitForSeedPackAttributes (copy), Seeds (copy), SeedPacks (copy), SeedPackSpawnClient (copy), u3 (copy), u2 (copy), u1 (copy), u4 (ref), RunService (copy), NotificationController (copy)
    task.spawn(function() -- Line: 77
        -- upvalues: u16 (copy), u17 (ref), WaitForSeedPackAttributes (ref), Seeds (ref), SeedPacks (ref), SeedPackSpawnClient (ref), u3 (ref), u2 (ref), u1 (ref), u4 (ref), RunService (ref), NotificationController (ref)
        if not u16.Parent then
            return;
        end;

        local v18 = u16:GetAttribute("RainbowSeed") == true;
        local v19 = u16:GetAttribute("GoldSeed") == true;
        local v20 = u16:GetAttribute("MegaSeed") == true;

        if not v18 and (not v19 and (not v20 and (u17 == nil or u17 == ""))) then
            local v21;
            v21, v18, v19, v20 = WaitForSeedPackAttributes(u16);
            u17 = v21;
        end;

        if not u16.Parent then
            return;
        end;

        local v22 = nil;
        local v23 = nil;
        local v24 = nil;

        if v18 then
            v22 = Seeds:FindFirstChild("Rainbow");
            v23 = 5;
            v24 = "Rainbow Seed";
        elseif v19 then
            v22 = Seeds:FindFirstChild("Gold");
            v23 = 5;
            v24 = "Gold Seed";
        elseif v20 then
            v22 = Seeds:FindFirstChild("Mega") or Seeds:FindFirstChild("Gold");
            v23 = 2;
            v24 = "Mega Seed";
        elseif type(u17) == "string" and u17 ~= "" then
            v22 = SeedPacks:FindFirstChild(u17);
            v24 = u17;
            v23 = 3;
        end;

        if not v22 then
            return;
        end;

        local Part = Instance.new("Part");
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.Size = Vector3.new(1, 1, 1);
        Part.Transparency = 1;
        Part.CFrame = u16.CFrame;
        Part.Parent = SeedPackSpawnClient;
        local v25 = v22:Clone();

        if v25:IsA("BasePart") then
            v25.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0.3, 0.5);
        end;

        local u26;

        if v25:IsA("BasePart") then
            u26 = Instance.new("Model");
            v25.Anchored = false;
            v25.Parent = u26;
            u26.PrimaryPart = v25;
            u26.Parent = SeedPackSpawnClient;
            u26:ScaleTo(v23);
        else
            u26 = v25;
            u26.Parent = SeedPackSpawnClient;

            if not u26.PrimaryPart then
                for _, descendant in u26:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        u26.PrimaryPart = descendant;
                        break;
                    end;
                end;
            end;

            if not u26.PrimaryPart then
                Part:Destroy();
                u26:Destroy();

                return;
            end;

            u26:ScaleTo(v23);
        end;

        local _, v27 = u26:GetBoundingBox();
        u3[Part] = u16.CFrame * CFrame.new(0, -u16.Size.Y / 2, 0) * CFrame.new(0, v27.Y / 2 + 1, 0);
        local Attachment = Instance.new("Attachment");
        Attachment.Parent = u26.PrimaryPart;
        local Attachment2 = Instance.new("Attachment");
        Attachment2.Parent = Part;
        local AlignPosition = Instance.new("AlignPosition");
        AlignPosition.Attachment0 = Attachment;
        AlignPosition.Attachment1 = Attachment2;
        AlignPosition.RigidityEnabled = true;
        AlignPosition.Parent = u26.PrimaryPart;
        local AlignOrientation = Instance.new("AlignOrientation");
        AlignOrientation.Attachment0 = Attachment;
        AlignOrientation.Attachment1 = Attachment2;
        AlignOrientation.RigidityEnabled = true;
        AlignOrientation.Parent = u26.PrimaryPart;
        table.insert(u2, { u16, u26, Part });
        local u28 = nil;
        u28 = u16.Destroying:Connect(function() -- Line: 188
            -- upvalues: u1 (ref), u16 (ref), u26 (ref), u28 (ref)
            u1:DespawnClient(u16, u26);
            u28:Disconnect();
        end);

        if not u4 then
            u4 = RunService.Heartbeat:Connect(function() -- Line: 36
                -- upvalues: u2 (ref), u3 (ref)
                local v29 = os.clock();
                local v30 = math.sin(v29 * 2) * 0.5;
                local v31 = CFrame.Angles(0, v29 * 1.5, 0);

                for _, v in u2 do
                    local v32 = u3[v[3]];

                    if v32 and v[3].Parent then
                        v[3].CFrame = v32 * v31 + Vector3.new(0, v30, 0);
                    end;
                end;
            end);
        end;

        if v24 then
            NotificationController:CreateSeedPackSpawnNotification(v24);
        end;
    end);
end;

function u1.DespawnClient(p33, p34, p35) -- Line: 202
    -- upvalues: u2 (copy), u3 (copy), u4 (ref)
    for _, v in pairs(u2) do
        if v[1] == p34 then
            local v36 = table.find(u2, v);

            if v[3] then
                u3[v[3]] = nil;
                v[3]:Destroy();
                v[3] = nil;
            end;

            if v[2] then
                v[2]:Destroy();
                v[2] = nil;
            end;

            if v36 then
                table.remove(u2, v36);
            end;

            break;
        end;
    end;

    if #u2 == 0 and u4 then
        u4:Disconnect();
        u4 = nil;
    end;
end;

function u1.Start(p37) -- Line: 226
end;

function u1.Init(p38) -- Line: 230
    -- upvalues: SeedPackSpawnServerLocations (copy), u1 (copy), Networking (copy), PopVFXModel (copy), SoundService (copy)
    for _, child in pairs(SeedPackSpawnServerLocations:GetChildren()) do
        u1:SpawnClient(child, child:GetAttribute("SeedPack"));
    end;

    SeedPackSpawnServerLocations.ChildAdded:Connect(function(p39) -- Line: 234
        -- upvalues: u1 (ref)
        u1:SpawnClient(p39, p39:GetAttribute("SeedPack"));
    end);
    Networking.SeedPackSpawn.FX.OnClientEvent:Connect(function(p40, p41) -- Line: 237
        -- upvalues: PopVFXModel (ref), SoundService (ref)
        local v42 = p41 == "Mega Seed" and 2 or 1;
        local u43 = PopVFXModel:Clone();
        u43:ScaleTo(v42);
        u43:PivotTo(CFrame.new(p40));
        u43.Parent = game.Workspace;
        local Sound = Instance.new("Sound");
        Sound.Volume = Sound.Volume * v42;
        Sound.SoundId = "rbxassetid://70730950826307";
        Sound.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        Sound.SoundGroup = SoundService:FindFirstChild("SFXGroup");
        Sound.Parent = u43.PopVFX;
        task.defer(function() -- Line: 260
            -- upvalues: u43 (copy), Sound (copy)
            for _, child in pairs(u43.PopVFX.PopEffect:GetChildren()) do
                child:Emit(child:GetAttribute("EmitCount"));
            end;

            Sound:Play();
            game.Debris:AddItem(u43, 3);
        end);
    end);
end;

return u1;