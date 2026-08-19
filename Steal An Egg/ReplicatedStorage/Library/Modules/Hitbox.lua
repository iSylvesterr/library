-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local StarterPlayer = game:GetService("StarterPlayer");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Settings = script:WaitForChild("Settings");
local v1 = Settings:FindFirstChild("Alive Folder");
assert(v1, "No Alive Folder setting found in HitboxClass settings! Make an object value and name it \'Alive Folder\' and parent it there!");
local MobsCache = workspace:WaitForChild("MobsCache", Constants.STUDIO_YIELD_TIMEOUT);
local v2 = Settings:FindFirstChild("Projectile Folder");
assert(v2, "No Projectile Folder setting found in HitboxClass settings! Make an object value and name it \'Projectile Folder\' and parent it there!");
local SpawnedObjects = workspace:WaitForChild("SpawnedObjects");
local u3 = Settings:FindFirstChild("Velocity Prediction Constant");

if not u3 then
    warn("Velocity Constant Setting has been deleted! 6 will be used as a default. (HitboxClass)");
end;

assert(MobsCache ~= nil, "Set the alive characters folder in the HitboxClass settings!");
assert(SpawnedObjects ~= nil, "Set the projectiles folder in the HitboxClass settings!");
local v4 = MobsCache:IsDescendantOf(workspace);
assert(v4, "The alive folder must be a descendant of workspace! (HitboxClass)");
local v5 = SpawnedObjects:IsDescendantOf(workspace);
assert(v5, "The projectile folder must be a descendant of workspace! (HitboxClass)");
require(script.Types);
local Signal = require(script.Signal);
local Timer = require(script.Timer);
local u6 = OverlapParams.new();
u6.FilterDescendantsInstances = { MobsCache };
u6.FilterType = Enum.RaycastFilterType.Include;
u6.MaxParts = 150;
local u7 = OverlapParams.new();
u7.FilterDescendantsInstances = { SpawnedObjects };
u7.FilterType = Enum.RaycastFilterType.Exclude;
local u8 = CFrame.new(Vector3.new(0, 0, 0));
local u9 = nil;

local function SetupClients() -- Line: 74
    -- upvalues: ReplicatedStorage (copy), u9 (ref), StarterPlayer (copy), Players (copy)
    local RemoteEvent = Instance.new("RemoteEvent");
    RemoteEvent.Name = "HitboxClassRemote";
    RemoteEvent.Parent = ReplicatedStorage;
    u9 = RemoteEvent;
    local u10 = script.HitboxClassLocal:Clone();
    local v11 = script.Signal:Clone();
    local ObjectValue = Instance.new("ObjectValue");
    ObjectValue.Value = script;
    ObjectValue.Name = "HitboxClass Module";
    ObjectValue.Parent = u10;
    v11.Parent = u10;
    u10.Parent = StarterPlayer:FindFirstChildOfClass("StarterPlayerScripts");
    task.spawn(function() -- Line: 92
        -- upvalues: Players (ref), u10 (copy)
        for _, child in pairs(Players:GetChildren()) do
            local ScreenGui = Instance.new("ScreenGui");
            ScreenGui.Name = "HitboxClassContainer";
            ScreenGui.ResetOnSpawn = false;
            local v12 = u10:Clone();
            v12.Parent = ScreenGui;
            v12.Enabled = true;
            ScreenGui.Parent = child:WaitForChild("PlayerGui");
        end;
    end);
    u10.Enabled = true;
end;

if RunService:IsServer() then
    SetupClients();
else
    u9 = ReplicatedStorage:FindFirstChild("HitboxClassRemote");

    if not u9 then
        warn("HitboxClass must be initialized on the server before using it on the client! Waiting for RemoteEvent!");
        u9 = ReplicatedStorage:WaitForChild("HitboxClassRemote");
    end;
end;

local u13 = {};
local u14 = {};

local function DeepCopyTable(p15) -- Line: 123
    -- upvalues: DeepCopyTable (copy)
    local v16 = {};

    for i, v in pairs(p15) do
        if type(v) == "table" then
            v16[i] = DeepCopyTable(v);
        else
            v16[i] = v;
        end;
    end;

    return v16;
end;

function u13.new(p17) -- Line: 137
    -- upvalues: u13 (copy), RunService (copy), Signal (copy), DeepCopyTable (copy), u9 (ref), u8 (copy), u14 (copy)
    local u18 = setmetatable({}, {
        __index = u13
    });
    u18.TaggedChars = {};
    u18.TaggedObjects = {};
    u18.SendingChars = {};
    u18.SendingObjects = {};
    u18.DelayThreads = {};

    if RunService:IsClient() and p17._Tick then
        u18.TickVal = p17._Tick;
    else
        u18.TickVal = workspace:GetServerTimeNow();
    end;

    if p17.ID then
        u18.ID = p17.ID;
    end;

    u18.Blacklist = p17.Blacklist;
    u18.HitSomeone = Signal.new();
    u18.HitObject = Signal.new();
    u18.DebugMode = p17.Debug or false;
    u18.Lifetime = p17.Debris or 0;
    u18.LookingFor = p17.LookingFor or "Humanoid";

    if p17.UseClient then
        u18.Client = p17.UseClient;
        local v19 = DeepCopyTable(p17);
        v19.UseClient = nil;
        v19._Tick = u18.TickVal;
        local u20 = false;
        local v23 = u9.OnServerEvent:Connect(function(p21, p22) -- Line: 184
            -- upvalues: u18 (copy), u20 (ref)
            if p21 ~= u18.Client then
                return;
            end;

            if p22 ~= u18.TickVal then
                return;
            end;

            u20 = true;
        end);
        assert(u18.Client, "No client provided for the hitbox! (HitboxClass)");
        local v24 = workspace:GetServerTimeNow();
        u9:FireClient(u18.Client, "New", v19);

        repeat
            task.wait();
        until u20 or workspace:GetServerTimeNow() - v24 >= 1.5;

        v23:Disconnect();

        if not u20 then
            return u18, false;
        end;
    else
        u18.Position = p17.InitialPosition or u8;
        u18.Frequency = p17.Frequency or 0;
        u18.HitSomeoneDebounce = p17.HitSomeoneDebounce or 0;
        u18.VelocityPrediction = p17.VelocityPrediction;

        if u18.VelocityPrediction == nil then
            u18.VelocityPrediction = true;
        end;

        u18.DotProductRequirement = p17.DotProductRequirement;
        u18.DebugMode = p17.Debug or false;

        if typeof(p17.SizeOrPart) == "Vector3" then
            u18.SpatialOption = p17.SpatialOption or "InBox";
            assert(u18.SpatialOption ~= "InRadius", "You can\'t use InRadius as the SpatialOption if a Vector3 is passed! Only InPart and InBox! (HitboxClass)");
            u18.Mode = "Part";
            u18.Size = p17.SizeOrPart;

            if u18.SpatialOption == "InPart" then
                u18:_GeneratePart();
            end;
        elseif type(p17.SizeOrPart) == "number" then
            u18.SpatialOption = p17.SpatialOption or "Magnitude";

            if u18.SpatialOption == "InRadius" then
                u18.Mode = "Part";
                u18.Size = p17.SizeOrPart;
            elseif u18.SpatialOption == "InPart" then
                u18.Mode = "Part";
                u18.Size = Vector3.new(p17.SizeOrPart, p17.SizeOrPart, p17.SizeOrPart);
                u18:_GeneratePart();
            elseif u18.SpatialOption == "InBox" then
                u18.Mode = "Part";
                u18.Size = Vector3.new(p17.SizeOrPart, p17.SizeOrPart, p17.SizeOrPart);
            else
                u18.Mode = "Magnitude";
                u18.Size = p17.SizeOrPart;
            end;
        else
            u18.Mode = "Part";
            u18.Size = p17.SizeOrPart.Size;
            u18.Part = p17.SizeOrPart:Clone();
            u18.SpatialOption = "InPart";
            assert(u18.Part, "No part provided?");
            local v25 = u18.Part and u18.Part:IsA("Part");
            local v26 = "SizeOrPart must be a part or a number! Type given: " .. typeof(p17.SizeOrPart);
            assert(v25, v26);
            u18.Part.Color = Color3.new(1, 0, 0);
            u18.Part.Name = "Hitbox" .. u18.TickVal;
        end;

        if u18.DebugMode then
            u18:SetDebug(true);
        end;
    end;

    table.insert(u14, u18);

    return u18, true;
end;

function u13.ClearTaggedChars(p27) -- Line: 282
    -- upvalues: u9 (ref)
    if p27.Client then
        u9:FireClient(p27.Client, "ClrTag", {
            _Tick = p27.TickVal
        });

        return;
    end;

    table.clear(p27.TaggedChars);
end;

function u13.Start(u28) -- Line: 290
    -- upvalues: Timer (copy), u9 (ref), MobsCache (copy), SpawnedObjects (copy), RunService (copy), u8 (copy), u6 (copy), u7 (copy)
    if u28.Lifetime > 0 then
        if u28.Timer then
            u28.Timer:On();
        else
            u28.Timer = Timer.new(0.1, function() -- Line: 296
                -- upvalues: u28 (copy)
                local v29 = u28;
                v29.Lifetime = v29.Lifetime - 0.1;

                if u28.Lifetime <= 0 then
                    u28:Destroy();
                end;
            end);
        end;
    end;

    if u28.Client then
        u28.ClientConnection = u9.OnServerEvent:Connect(function(p30, p31, p32) -- Line: 308
            -- upvalues: u28 (copy), MobsCache (ref)
            if p32 == nil then
                return;
            end;

            if p30 ~= u28.Client then
                return;
            end;

            if p31 ~= u28.TickVal then
                return;
            end;

            if type(p32) ~= "table" then
                return;
            end;

            if u28.LookingFor ~= "Humanoid" then
                if u28.LookingFor == "Object" then
                    for i = #p32, 1, -1 do
                        if p32[i] and (typeof(p32[i]) == "Instance" and p32[i]:IsA("BasePart")) then
                            if u28.Blacklist then
                                for _, v in pairs(u28.Blacklist) do
                                    if p32[i] == v or p32[i]:IsDescendantOf(v) then
                                        table.remove(p32, i);
                                    end;
                                end;
                            end;
                        else
                            table.remove(p32, i);
                        end;
                    end;

                    if #p32 <= 0 then
                        return;
                    end;

                    u28.HitObject:Fire(p32);
                end;

                return;
            end;

            for i = #p32, 1, -1 do
                if not p32[i] or (typeof(p32[i]) ~= "Instance" or not (p32[i]:IsDescendantOf(MobsCache) and (p32[i]:FindFirstChildOfClass("Humanoid") and p32[i]:IsA("Model")))) then
                    table.remove(p32, i);
                end;

                if u28.Blacklist and table.find(u28.Blacklist, p32[i]) then
                    table.remove(p32, i);
                end;
            end;

            if #p32 <= 0 then
                return;
            end;

            u28.HitSomeone:Fire(p32);
        end);
        u9:FireClient(u28.Client, "Start", {
            _Tick = u28.TickVal
        });

        return;
    end;

    if u28.Mode ~= "Magnitude" then
        if u28.SpatialOption == "InPart" or u28.Part and u28.DebugMode == true then
            u28.Part.Parent = SpawnedObjects;
        end;

        u28.RunServiceConnection = RunService.Heartbeat:Connect(function(p33) -- Line: 416
            -- upvalues: u28 (copy), u8 (ref), u6 (ref), u7 (ref)
            if u28.PartWeld then
                u28:SetPosition(u28.PartWeld.CFrame * (u28.PartWeldOffset or u8));
            end;

            local v34;

            if u28.SpatialOption == "InBox" then
                if u28.LookingFor == "Humanoid" then
                    v34 = workspace:GetPartBoundsInBox(u28.Position, u28.Size, u6);
                else
                    v34 = workspace:GetPartBoundsInBox(u28.Position, u28.Size, u7);
                end;
            elseif u28.SpatialOption == "InRadius" then
                if u28.LookingFor == "Humanoid" then
                    v34 = workspace:GetPartBoundsInRadius(u28.Position.Position, u28.Size, u6);
                else
                    v34 = workspace:GetPartBoundsInRadius(u28.Position.Position, u28.Size, u7);
                end;
            elseif u28.LookingFor == "Humanoid" then
                v34 = workspace:GetPartsInPart(u28.Part, u6);
            else
                v34 = workspace:GetPartsInPart(u28.Part, u7);
            end;

            for _, v in pairs(v34) do
                if v.Parent then
                    if u28.LookingFor == "Humanoid" then
                        local Parent = v.Parent;
                        local v35 = Parent:IsA("Model");

                        if v35 then
                            if Parent.PrimaryPart == nil then
                                v35 = false;
                            else
                                v35 = Parent:FindFirstChildOfClass("Humanoid");
                            end;
                        end;

                        if v35 and not (u28.Blacklist and table.find(u28.Blacklist, Parent)) and not (table.find(u28.SendingChars, Parent) or u28.TaggedChars[Parent]) then
                            table.insert(u28.SendingChars, Parent);
                        end;
                    else
                        local v36 = false;

                        if u28.Blacklist then
                            for i = #u28.Blacklist, 1, -1 do
                                local v37 = u28.Blacklist[i];

                                if v == v37 or v:IsDescendantOf(v37) then
                                    v36 = true;
                                    break;
                                end;
                            end;
                        end;

                        if not (table.find(u28.SendingObjects, v) or (u28.TaggedObjects[v] or v36)) then
                            table.insert(u28.SendingObjects, v);
                        end;
                    end;
                end;
            end;

            if u28.LookingFor == "Humanoid" then
                u28:_SiftThroughSendingCharsAndFire();

                return;
            end;

            if u28.LookingFor == "Object" then
                u28:_SiftThroughSendingObjectsAndFire();
            end;
        end);

        return;
    end;

    local v38 = typeof(u28.Size) == "number";
    local v39 = "Magnitude hitbox wasn\'t given a number! Type given: " .. typeof(u28.Size);
    assert(v38, v39);

    if u28.Part and u28.DebugMode then
        u28.Part.Parent = SpawnedObjects;
    end;

    local u40 = 0;
    local u41 = 0;
    u28.RunServiceConnection = RunService.Heartbeat:Connect(function() -- Line: 389
        -- upvalues: u40 (ref), u41 (ref), u28 (copy), u8 (ref), u6 (ref)
        local v42 = os.clock() - u40;
        local v43 = os.clock() - u41;

        if v42 < u28.Frequency or v43 < u28.HitSomeoneDebounce then
            return;
        end;

        u40 = os.clock();

        if u28.PartWeld then
            u28:SetPosition(u28.PartWeld.CFrame * (u28.PartWeldOffset or u8));
        end;

        local v44 = workspace:GetPartBoundsInRadius(u28.Position.Position, u28.Size, u6);

        if #v44 == 0 then
            return;
        end;

        u41 = os.clock();
        u28.HitSomeone:Fire(v44);
    end);
end;

function u13.Stop(p45) -- Line: 501
    -- upvalues: u9 (ref)
    if p45.Timer then
        p45.Timer:Off();
    end;

    if p45.Client then
        if p45.ClientConnection then
            p45.ClientConnection:Disconnect();
            p45.ClientConnection = nil;
        end;

        u9:FireClient(p45.Client, "Stop", {
            _Tick = p45.TickVal
        });

        return;
    end;

    if p45.Part then
        p45.Part:Remove();
    end;

    if p45.RunServiceConnection then
        p45.RunServiceConnection:Disconnect();
        p45.RunServiceConnection = nil;
    end;
end;

function u13.SetPosition(p46, p47) -- Line: 524
    -- upvalues: u9 (ref), u3 (copy), RunService (copy)
    if p46.Client then
        u9:FireClient(p46.Client, "PosCh", {
            _Tick = p46.TickVal,
            Position = p47
        });
    end;

    local v48 = u3 and (u3.Value or 6) or 6;

    if RunService:IsServer() and (p46.PartWeld and p46.VelocityPrediction) then
        local v49 = p47:VectorToObjectSpace(p46.PartWeld.AssemblyLinearVelocity) / v48;
        p47 = p47 * CFrame.new(v49);
    end;

    p46.Position = p47;

    if p46.Part then
        p46.Part.CFrame = p47;
    end;
end;

function u13.WeldTo(p50, p51, p52) -- Line: 549
    -- upvalues: u9 (ref)
    if p50.Client then
        u9:FireClient(p50.Client, "Weld", {
            _Tick = p50.TickVal,
            WeldTo = p51,
            Offset = p52
        });
    end;

    p50.PartWeld = p51;
    p50.PartWeldOffset = p52;
end;

function u13.Unweld(p53) -- Line: 562
    -- upvalues: u9 (ref)
    if p53.Client then
        u9:FireClient(p53.Client, "Unweld", {
            _Tick = p53.TickVal
        });
    end;

    p53.PartWeld = nil;
    p53.PartWeldOffset = nil;
end;

function u13.ChangeWeldOffset(p54, p55) -- Line: 571
    -- upvalues: u9 (ref)
    if p54.Client then
        u9:FireClient(p54.Client, "WeldOfs", {
            _Tick = p54.TickVal,
            Offset = p55
        });
    end;

    p54.PartWeldOffset = p55;
end;

function u13.SetVelocityPrediction(p56, p57) -- Line: 579
    p56.VelocityPrediction = p57;
end;

function u13.SetDebug(p58, p59) -- Line: 583
    -- upvalues: u9 (ref), SpawnedObjects (copy)
    p58.DebugMode = p59;

    if p58.Client then
        u9:FireClient(p58.Client, "Dbg", {
            _Tick = p58.TickVal,
            Debug = p59
        });

        return;
    end;

    if p58.DebugMode then
        if p58.Part then
            p58.Part.Transparency = 0.45;

            if p58.SpatialOption ~= "InPart" and p58.RunServiceConnection then
                p58.Part.Parent = SpawnedObjects;
            end;
        else
            p58:_GeneratePart();
            assert(p58.Part, "Part wasn\'t generated after the GeneratePart method?");

            if p58.RunServiceConnection then
                p58.Part.Parent = SpawnedObjects;
            end;
        end;
    elseif p58.Part then
        if p58.SpatialOption ~= "InPart" then
            p58.Part:Remove();
        end;

        p58.Part.Transparency = 1;
    end;
end;

function u13.ClearHitboxesWithID(p60) -- Line: 617
    -- upvalues: RunService (copy), u14 (copy)
    if RunService:IsClient() then
        return;
    end;

    for i = #u14, 1, -1 do
        local u61 = u14[i];

        if u61.ID and u61.ID == p60 then
            pcall(function() -- Line: 627
                -- upvalues: u61 (copy)
                u61:Destroy();
            end);
        end;
    end;
end;

function u13.ClearClientHitboxes(p62) -- Line: 634
    -- upvalues: RunService (copy), u14 (copy), u9 (ref)
    if RunService:IsClient() then
        return;
    end;

    for i = #u14, 1, -1 do
        local u63 = u14[i];

        if u63.Client and u63.Client == p62 then
            pcall(function() -- Line: 644
                -- upvalues: u63 (copy)
                u63:Destroy();
            end);
        end;
    end;

    u9:FireClient(p62, "Clr");
end;

function u13.GetHitboxCache() -- Line: 654
    -- upvalues: u14 (copy)
    return u14;
end;

function u13._SiftThroughSendingObjectsAndFire(u64) -- Line: 658
    if #u64.SendingObjects <= 0 then
        return;
    end;

    local v65 = {};

    for _, v in pairs(u64.SendingObjects) do
        table.insert(v65, v);
        u64.TaggedObjects[v] = true;

        if u64.Frequency > 0 then
            local v66 = task.delay(u64.Frequency, function() -- Line: 671
                -- upvalues: u64 (copy), v (copy)
                u64.TaggedObjects[v] = nil;
            end);
            table.insert(u64.DelayThreads, v66);
        end;
    end;

    if #v65 > 0 then
        u64.HitObject:Fire(v65);
    end;

    if u64.SendingObjects then
        table.clear(u64.SendingObjects);
    end;
end;

function u13._SiftThroughSendingCharsAndFire(u67) -- Line: 692
    if #u67.SendingChars <= 0 then
        return;
    end;

    local v68 = {};

    for _, v in pairs(u67.SendingChars) do
        table.insert(v68, v);
        u67.TaggedChars[v] = true;

        if u67.Frequency > 0 then
            local v69 = task.delay(u67.Frequency, function() -- Line: 705
                -- upvalues: u67 (copy), v (copy)
                u67.TaggedChars[v] = nil;
            end);
            table.insert(u67.DelayThreads, v69);
        end;
    end;

    if #v68 > 0 then
        u67.HitSomeone:Fire(v68);
    end;

    if u67.SendingChars then
        table.clear(u67.SendingChars);
    end;
end;

function u13._GeneratePart(p70) -- Line: 726
    if p70.Part then
        return;
    end;

    if typeof(p70.Size) ~= "Vector3" then
        if type(p70.Size) == "number" then
            p70.Part = Instance.new("Part");
            local v71 = p70.Part and p70.Part:IsA("Part");
            assert(v71, "Part wasn\'t created when making a sphere part!");
            local v72 = typeof(p70.Size) == "number";
            assert(v72, "self.Size wasn\'t a number when making a sphere part!");
            p70.Part.Shape = Enum.PartType.Ball;
            p70.Part.Anchored = true;
            p70.Part.Massless = true;
            p70.Part.CanCollide = false;
            p70.Part.Size = Vector3.new(p70.Size * 2, p70.Size * 2, p70.Size * 2);
            p70.Part.Transparency = 0.45;
            p70.Part.Color = Color3.new(1, 0, 0);
            p70.Part.CFrame = p70.Position;
            p70.Part.Name = "Hitbox" .. p70.TickVal;
        end;

        return;
    end;

    p70.Mode = "Part";
    p70.Part = Instance.new("Part");
    assert(p70.Part, "Part was nil!");
    local v73 = typeof(p70.Size) == "Vector3";
    assert(v73, "self.Size wasn\'t a vector3 when making a part!");
    p70.Part.Color = Color3.new(1, 0, 0);

    if p70.DebugMode then
        p70.Part.Transparency = 0.45;
    else
        p70.Part.Transparency = 1;
    end;

    p70.Part.Anchored = true;
    p70.Part.Massless = true;
    p70.Part.CanCollide = false;
    p70.Part.Size = p70.Size;
    p70.Part.CFrame = p70.Position;
    p70.Part.Name = "Hitbox" .. p70.TickVal;
end;

function u13.Destroy(u74) -- Line: 772
    -- upvalues: u14 (copy), u9 (ref)
    table.remove(u14, table.find(u14, u74));

    if u74.Client then
        u9:FireClient(u74.Client, "Des", {
            _Tick = u74.TickVal
        });
    end;

    if u74.Client then
        if u74.ClientConnection then
            u74.ClientConnection:Disconnect();
            u74.ClientConnection = nil;
        end;
    else
        if u74.Part then
            u74.Part:Remove();
        end;

        if u74.RunServiceConnection then
            u74.RunServiceConnection:Disconnect();
            u74.RunServiceConnection = nil;
        end;
    end;

    pcall(function() -- Line: 799
        -- upvalues: u74 (copy)
        u74.HitSomeone:Destroy();
    end);
    pcall(function() -- Line: 804
        -- upvalues: u74 (copy)
        u74.HitObject:Destroy();
    end);
    pcall(function() -- Line: 809
        -- upvalues: u74 (copy)
        if u74.Timer then
            u74.Timer:Destroy();
        end;
    end);

    if u74.DelayThreads then
        for _, v in pairs(u74.DelayThreads) do
            pcall(function() -- Line: 818
                -- upvalues: v (copy)
                task.cancel(v);
            end);
        end;
    end;

    if u74.Part then
        u74.Part:Destroy();
    end;

    pcall(function() -- Line: 830
        -- upvalues: u74 (copy)
        table.clear(u74.TaggedChars);
    end);
    pcall(function() -- Line: 834
        -- upvalues: u74 (copy)
        table.clear(u74.SendingChars);
    end);
    pcall(function() -- Line: 838
        -- upvalues: u74 (copy)
        table.clear(u74);
    end);
end;

return u13;