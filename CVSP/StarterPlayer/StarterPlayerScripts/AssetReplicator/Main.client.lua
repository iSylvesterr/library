-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local Bindables = ReplicatedStorage:WaitForChild("Bindables");
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local ClientEffectsModules = ReplicatedStorage:WaitForChild("ClientEffectsModules");
local GameRules = require(Modules.GameRules);
require(Modules.EggData);
local TowerData = require(Modules.TowerData);
local Effects = require(ClientEffectsModules.Effects);
local MutationRenderer = require(Modules.MutationRenderer);
local MysteryList = require(Modules.MysteryList);
local UISoundController = require(ReplicatedStorage.Sounds.UISoundController);
local Eggs = Assets:WaitForChild("Eggs");
local Towers = Assets:WaitForChild("Towers");
local Plants = Assets:WaitForChild("Plants");
local Totems = Assets:WaitForChild("Totems");
local World = workspace:WaitForChild("World", (1 / 0));
local PlacedItems = World.Map.PlacedItems;
local Plants2 = World.Map.Plants;
local PottedPlants = World.Map.PottedPlants;
local Client = PlacedItems:WaitForChild("Client");
local Server = PlacedItems:WaitForChild("Server");
local Client2 = Plants2:WaitForChild("Client");
local Server2 = Plants2:WaitForChild("Server");
local Client3 = PottedPlants:WaitForChild("Client");
local Server3 = PottedPlants:WaitForChild("Server");

repeat
    task.wait();
until workspace:GetAttribute("Loaded") == true;

local function getTrueName(p1) -- Line: 66
    return p1:split(":")[1];
end;

local function parseMutationList(p2) -- Line: 71
    local v3 = {};

    for i in string.gmatch(p2, "([^,]+)") do
        table.insert(v3, i:match("^%s*(.-)%s*$"));
    end;

    return v3;
end;

local function renderMutations(p4, p5, p6) -- Line: 81
    -- upvalues: MutationRenderer (copy), parseMutationList (copy)
    if p6 then
        MutationRenderer.renderMutation(p4, p6);
    end;

    local Variant = p5:FindFirstChild("Variant");

    if not Variant then
        return;
    end;

    MutationRenderer.renderMutation(p4, Variant.Value);
    local Mutations = p5:FindFirstChild("Mutations");

    if not Mutations then
        return;
    end;

    for _, v in parseMutationList(Mutations.Value) do
        MutationRenderer.renderMutation(p4, v);
    end;
end;

local function cleanClientModel(p7) -- Line: 101
    local PrimaryPart = p7.PrimaryPart;

    for _, descendant in p7:GetDescendants() do
        if descendant:IsA("BasePart") or descendant:IsA("UnionOperation") then
            descendant.CanCollide = false;
            descendant.Massless = true;

            if descendant.Name == "PrimaryPart" or (descendant == PrimaryPart or descendant.Transparency == 1) then
                descendant.CanQuery = false;
            else
                descendant.CanQuery = true;
            end;
        end;
    end;
end;

local function placeEffect(u8, u9, p10) -- Line: 121
    -- upvalues: TweenService (copy), Effects (copy)
    local v11 = u8 + Vector3.new(0, 1.5, 0);
    u9:PivotTo(v11);
    local CFrameValue = Instance.new("CFrameValue");
    CFrameValue.Value = v11;
    local v12 = TweenService:Create(CFrameValue, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Value = u8
    });
    CFrameValue:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 134
        -- upvalues: u9 (copy), CFrameValue (copy)
        u9:PivotTo(CFrameValue.Value);
    end);
    v12:Play();
    v12.Completed:Once(function() -- Line: 139
        -- upvalues: Effects (ref), u8 (copy), CFrameValue (copy)
        Effects.Play("PlaceEffect", {
            Position = u8.Position
        });
        CFrameValue:Destroy();
    end);
end;

local function hatchEffect(p13, u14, p15, p16) -- Line: 145
    -- upvalues: TweenService (copy), Effects (copy)
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Value = p16;
    local v17 = TweenService:Create(NumberValue, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Value = p15
    });
    NumberValue:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 155
        -- upvalues: u14 (copy), NumberValue (copy)
        u14:ScaleTo(NumberValue.Value);
    end);
    Effects.Play("HatchEffect", {
        Position = p13.Position
    });
    v17:Play();
    v17.Completed:Once(function() -- Line: 162
        -- upvalues: NumberValue (copy)
        NumberValue:Destroy();
    end);
end;

local function mysteryHatchEffect(p18, u19, p20, p21, p22, p23, p24) -- Line: 167
    -- upvalues: MysteryList (copy), TweenService (copy), Effects (copy), Towers (copy), Client (copy), LocalPlayer (copy), UISoundController (copy)
    local v25 = table.clone(MysteryList[p22]);
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Value = p21;
    local v26 = TweenService:Create(NumberValue, TweenInfo.new(3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Value = p20
    });
    v26:Play();
    Effects.Play("HatchEffect", {
        NoShine = true,
        Position = p18.Position
    });
    u19.Parent = nil;
    local v27 = nil;
    local v28 = nil;

    for i = 1, 15 do
        if v27 then
            v27:Destroy();
        end;

        local v29;

        repeat
            v29 = math.random(#v25);
        until #v25 == 1 or v29 ~= v28;

        local v30 = Towers:FindFirstChild(v25[v29]);

        if v30 then
            v27 = v30.ClientModel:Clone();
            v27:PivotTo(p18);
            local v31 = os.clock();
            local v32 = p21 + (p20 - p21) * ((i - 1) / 15);
            local v33 = p21 + (p20 - p21) * (i / 15);
            local Highlight = Instance.new("Highlight");
            Highlight.FillTransparency = 0;
            Highlight.OutlineTransparency = 0;
            Highlight.Enabled = true;
            Highlight.FillColor = Color3.new(0, 0, 0);
            Highlight.Parent = v27;
            Highlight.Adornee = v27;

            for _, descendant in v27:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Color = Color3.new();
                    descendant.Material = Enum.Material.Neon;
                    descendant.CastShadow = false;

                    if descendant:IsA("UnionOperation") then
                        descendant.UsePartColor = true;
                    end;
                elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
                    descendant.Transparency = 1;
                elseif descendant:IsA("ParticleEmitter") or (descendant:IsA("Beam") or descendant:IsA("Trail")) then
                    descendant.Enabled = false;
                end;
            end;

            v27.Parent = Client;

            while true do
                local v34 = (os.clock() - v31) / 0.025;
                local v35 = math.clamp(v34, 0, 1);
                v27:ScaleTo(v32 + (v33 - v32) * v35 ^ 2);

                if v35 >= 1 then
                    break;
                end;

                task.wait();
            end;
        end;

        local v36 = (i - 1) / 14;
        local v37 = v36 ^ 2 * -0.7500000000000001 + 1.6 + math.random(-5, 5) * 0.01;

        if p24 == LocalPlayer.UserId then
            UISoundController.PlayWithPitch("Click", v37);
        end;

        task.wait(v36 ^ 4 * 0.72 + 0.03);
        v28 = v29;
    end;

    UISoundController.Play("Click");

    if v27 then
        v27:Destroy();
    end;

    u19.Parent = Client;
    u19:PivotTo(p18);
    NumberValue.Value = (p21 + p20) / 2;
    local v38 = TweenService:Create(NumberValue, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Value = p20
    });
    NumberValue:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 291
        -- upvalues: u19 (copy), NumberValue (copy)
        u19:ScaleTo(NumberValue.Value);
    end);
    Effects.Play("MysteryHatchEffect", {
        Position = p18.Position,
        Rarity = p23
    });
    v38:Play();
    v38.Completed:Once(function() -- Line: 298
        -- upvalues: NumberValue (copy)
        NumberValue:Destroy();
    end);
    v26.Completed:Wait();
    NumberValue:Destroy();
end;

local function watchStoppedState(p39) -- Line: 315
    local u40 = {
        activeTween = nil,
        stopped = p39:FindFirstChild("Stopped") ~= nil,
        connections = {}
    };
    table.insert(u40.connections, p39.ChildAdded:Connect(function(p41) -- Line: 324
        -- upvalues: u40 (copy)
        if p41.Name == "Stopped" and p41:IsA("BoolValue") then
            u40.stopped = true;

            if u40.activeTween then
                u40.activeTween:Pause();
            end;
        end;
    end));
    table.insert(u40.connections, p39.ChildRemoved:Connect(function(p42) -- Line: 336
        -- upvalues: u40 (copy)
        if p42.Name == "Stopped" and p42:IsA("BoolValue") then
            u40.stopped = false;

            if u40.activeTween then
                u40.activeTween:Play();
            end;
        end;
    end));

    return u40;
end;

local function disconnectStoppedState(p43) -- Line: 349
    for _, v in p43.connections do
        v:Disconnect();
    end;

    table.clear(p43.connections);
end;

local function moveModelToWaypoint(u44, p45, p46, p47) -- Line: 363
    -- upvalues: TweenService (copy)
    if not (u44 and (u44.Parent and (u44.PrimaryPart and p45))) then
        return false;
    end;

    local Position = u44:GetPivot().Position;
    local v48 = p45 - Position;
    local v49 = Vector3.new(v48.X, 0, v48.Z);

    if v49.Magnitude == 0 then
        return true;
    end;

    local Unit = v49.Unit;
    local u50 = p45 + Vector3.new(0, u44.PrimaryPart.Size.Y / 2, 0);
    local u51 = CFrame.lookAt(Position, Position + Unit) - Position;
    local Magnitude = (Position - p45).Magnitude;
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Value = 0;
    local v52 = TweenService:Create(NumberValue, TweenInfo.new(Magnitude / p46, Enum.EasingStyle.Linear), {
        Value = 1
    });
    local u53 = nil;
    u53 = NumberValue.Changed:Connect(function() -- Line: 390
        -- upvalues: u44 (copy), u53 (ref), Position (copy), u50 (copy), NumberValue (copy), u51 (copy)
        if u44 and u44.Parent then
            u44:PivotTo(CFrame.new(Position:Lerp(u50, NumberValue.Value)) * u51);

            return;
        end;

        u53:Disconnect();
    end);

    if p47 then
        p47.activeTween = v52;
    end;

    v52:Play();

    if p47 and p47.stopped then
        v52:Pause();
    end;

    v52.Completed:Wait();

    if p47 then
        p47.activeTween = nil;
    end;

    if u53 then
        u53:Disconnect();
    end;

    NumberValue:Destroy();

    if u44 and u44.Parent then
        return true;
    end;

    v52:Cancel();

    return false;
end;

local function hatchPercentageUpdated(u54, u55, u56) -- Line: 432
    task.spawn(function() -- Line: 433
        -- upvalues: u56 (copy), u55 (copy), u54 (copy)
        local v57 = u56 / 2;
        local v58 = math.clamp(u55, 0, 100) / 100 * 10;
        local v59 = math.floor(v58) / 10;
        u54:ScaleTo(v57 + (u56 - v57) * v59);

        if u55 >= 100 then
            u54:SetAttribute("FullyGrown", true);
        end;
    end);
end;

local function childAdded(u60, p61) -- Line: 453
    -- upvalues: Client (copy), Towers (copy), Eggs (copy), Totems (copy), cleanClientModel (copy), placeEffect (copy), Effects (copy), GameRules (copy), renderMutations (copy), TowerData (copy), hatchEffect (copy), mysteryHatchEffect (copy), Client2 (copy), Plants (copy), watchStoppedState (copy), moveModelToWaypoint (copy), Client3 (copy)
    local Name = u60.Name;
    local v62 = u60:GetAttribute("Animation");

    if p61 == "Item" then
        if Client:FindFirstChild(Name) then
            return;
        end;

        local v63 = Name:split(":")[1];
        local v64 = Towers:FindFirstChild(v63);
        local v65 = Eggs:FindFirstChild(v63);
        local v66 = Totems:FindFirstChild(v63);

        if v66 then
            local v67 = v66:WaitForChild("ClientModel"):Clone();
            v67.Name = Name;
            cleanClientModel(v67);

            if not u60:WaitForChild("ServerConfiguration") then
                return;
            end;

            if v62 == "Placed" then
                placeEffect(u60:GetPivot(), v67, false);
            else
                v67:PivotTo(u60:GetPivot());
            end;

            v67.Parent = Client;
        end;

        if v65 then
            local u68 = v65:WaitForChild("ClientModel"):Clone();
            u68.Name = Name;
            cleanClientModel(u68);
            u60:WaitForChild("PrimaryPart");

            if v62 == "Placed" then
                placeEffect(u60:GetPivot(), u68, false);
            else
                u68:PivotTo(u60:GetPivot());
            end;

            if v62 == "Mutated" then
                Effects.Play("MutateEffect", {
                    Position = u68.PrimaryPart.Position
                });
            end;

            if v62 == "Reverted" then
                Effects.Play("TimeEffect", {
                    Position = u68.PrimaryPart.Position
                });
            end;

            if v62 == "Cleaned" then
                Effects.Play("CleanEffect", {
                    Position = u68.PrimaryPart.Position
                });
            end;

            u68:ScaleTo(GameRules.interpretSize(u60.ServerConfiguration.SizeScaling.Value) / 2);
            u68.Parent = Client;
            local ServerConfiguration = u60:FindFirstChild("ServerConfiguration");

            if ServerConfiguration then
                renderMutations(u68, ServerConfiguration, string.find(v63, "Disco") and "Disco" or nil);
                local HatchPercentage = ServerConfiguration:WaitForChild("HatchPercentage", (1 / 0));
                HatchPercentage.Changed:Connect(function() -- Line: 519, Name: updateHatchPercentage
                    -- upvalues: u68 (copy), HatchPercentage (copy), GameRules (ref), u60 (copy)
                    local u69 = u68;
                    local Value = HatchPercentage.Value;
                    local u70 = GameRules.interpretSize(u60.ServerConfiguration.SizeScaling.Value);
                    task.spawn(function() -- Line: 433
                        -- upvalues: u70 (copy), Value (copy), u69 (copy)
                        local v71 = u70 / 2;
                        local v72 = math.clamp(Value, 0, 100) / 100 * 10;
                        local v73 = math.floor(v72) / 10;
                        u69:ScaleTo(v71 + (u70 - v71) * v73);

                        if Value >= 100 then
                            u69:SetAttribute("FullyGrown", true);
                        end;
                    end);
                end);
                local Value = HatchPercentage.Value;
                local u74 = GameRules.interpretSize(u60.ServerConfiguration.SizeScaling.Value);
                task.spawn(function() -- Line: 433
                    -- upvalues: u74 (copy), Value (copy), u68 (copy)
                    local v75 = u74 / 2;
                    local v76 = math.clamp(Value, 0, 100) / 100 * 10;
                    local v77 = math.floor(v76) / 10;
                    u68:ScaleTo(v75 + (u74 - v75) * v77);

                    if Value >= 100 then
                        u68:SetAttribute("FullyGrown", true);
                    end;
                end);
                local ObjectValue = Instance.new("ObjectValue");
                ObjectValue.Name = "CorrespondingAdornee";
                ObjectValue.Value = u68;
                ObjectValue.Parent = u60.PrimaryPart:WaitForChild("HatchPrompt");

                if u68:GetAttribute("FullyGrown") == nil then
                    u68:GetAttributeChangedSignal("FullyGrown"):Wait();
                end;

                u60.PrimaryPart.HatchPrompt.ActionText = "Hatch (Hold)";
            end;
        end;

        if v64 then
            local v78 = v64:WaitForChild("ClientModel"):Clone();
            v78.Name = Name;
            cleanClientModel(v78);
            u60:WaitForChild("PrimaryPart");
            local v79 = u60:GetAttribute("Owner");

            if not v79 then
                return;
            end;

            local ServerConfiguration = u60:WaitForChild("ServerConfiguration");

            if not ServerConfiguration then
                return;
            end;

            local v80 = TowerData.getData(v63);

            if not v80 then
                return;
            end;

            renderMutations(v78, ServerConfiguration, string.find(v63, "Disco") and "Disco" or nil);

            if v62 ~= "Hatched" and v62 ~= "MysteryHatched" then
                v78:ScaleTo(GameRules.interpretSize(ServerConfiguration.SizeScaling.Value));
            end;

            if v62 == "Placed" then
                placeEffect(u60:GetPivot(), v78, true);
            elseif v62 == "Hatched" then
                v78:PivotTo(u60:GetPivot());
                local v81 = GameRules.interpretSize(ServerConfiguration.SizeScaling.Value);
                hatchEffect(u60:GetPivot(), v78, v81, v81 / 4);
            elseif v62 == "MysteryHatched" then
                v78:PivotTo(u60:GetPivot());
                local v82 = GameRules.interpretSize(ServerConfiguration.SizeScaling.Value);
                local v83 = v82 / 4;
                local MysteryEggName = v80:FindFirstChild("MysteryEggName");

                if MysteryEggName then
                    mysteryHatchEffect(u60:GetPivot(), v78, v82, v83, MysteryEggName.Value, v80.Rarity.Value, v79);
                else
                    hatchEffect(u60:GetPivot(), v78, v82, v83);
                end;
            else
                v78:PivotTo(u60:GetPivot());
            end;

            if v62 == "Cleaned" then
                Effects.Play("CleanEffect", {
                    Position = v78.PrimaryPart.Position
                });
            elseif v62 == "Mutated" then
                Effects.Play("MutateEffect", {
                    Position = v78.PrimaryPart.Position
                });
            end;

            v78.Parent = Client;
        end;
    end;

    if p61 == "Plant" then
        if Client2:FindFirstChild(Name) then
            return;
        end;

        local v84 = Name:split(":")[1];
        local v85 = Plants:FindFirstChild(v84);

        if not v85 then
            return;
        end;

        local v86 = v85:WaitForChild("ClientModel"):Clone();
        v86.Name = Name;
        cleanClientModel(v86);
        local ServerConfiguration = u60:WaitForChild("ServerConfiguration");

        if not ServerConfiguration then
            return;
        end;

        for _, v in { "SizeScaling", "Plot", "SpawnNum", "Lane", "Speed", "SlowedSpeed", "Variant", "Mutations" } do
            if not ServerConfiguration:WaitForChild(v, 10) then
                return;
            end;
        end;

        renderMutations(v86, ServerConfiguration, string.find(v84, "Disco") and "Disco" or nil);
        v86:ScaleTo(GameRules.interpretSize(ServerConfiguration.SizeScaling.Value));
        v86:PivotTo(u60:GetPivot());
        v86.Parent = Client2;
        local v87 = workspace.World.Map.Plots:WaitForChild((tostring(ServerConfiguration.Plot.Value)));
        local v88 = v87.Waypoints:WaitForChild("Turn" .. ServerConfiguration.SpawnNum.Value);
        local v89 = v87.Waypoints:WaitForChild("Lane" .. ServerConfiguration.Lane.Value);
        local v90 = v87.Waypoints:WaitForChild("Finish" .. ServerConfiguration.Lane.Value);
        local v91 = watchStoppedState(u60);

        if not moveModelToWaypoint(v86, v88.Position, ServerConfiguration.Speed.Value, v91) then
            for _, v in v91.connections do
                v:Disconnect();
            end;

            table.clear(v91.connections);

            return;
        end;

        if not moveModelToWaypoint(v86, v89.Position, ServerConfiguration.Speed.Value, v91) then
            for _, v in v91.connections do
                v:Disconnect();
            end;

            table.clear(v91.connections);

            return;
        end;

        moveModelToWaypoint(v86, v90.Position, ServerConfiguration.SlowedSpeed.Value, v91);

        for _, v in v91.connections do
            v:Disconnect();
        end;

        table.clear(v91.connections);
    end;

    if p61 == "PottedPlant" then
        if Client2:FindFirstChild(Name) then
            return;
        end;

        local v92 = Name:split(":")[1];
        local v93 = Plants:FindFirstChild(v92);

        if not v93 then
            return;
        end;

        local v94 = v93:WaitForChild("ClientModel"):Clone();
        v94.Name = Name;
        cleanClientModel(v94);
        local ServerConfiguration = u60:WaitForChild("ServerConfiguration");

        if not ServerConfiguration then
            return;
        end;

        renderMutations(v94, ServerConfiguration, string.find(v92, "Disco") and "Disco" or nil);

        if not ServerConfiguration:WaitForChild("SizeScaling", 5) then
            return;
        end;

        v94:ScaleTo(GameRules.interpretSize(ServerConfiguration.SizeScaling.Value));
        v94:PivotTo(u60:GetPivot());
        v94.Parent = Client3;

        if v62 == "Cleaned" then
            Effects.Play("CleanEffect", {
                Position = v94.PrimaryPart.Position
            });
        end;

        if v62 == "Mutated" then
            Effects.Play("MutateEffect", {
                Position = v94.PrimaryPart.Position
            });
        end;
    end;
end;

local function childRemoved(p95) -- Line: 711
    -- upvalues: Client (copy), Client2 (copy), Client3 (copy)
    local Name = p95.Name;
    local v96 = Client:FindFirstChild(Name);
    local v97 = Client2:FindFirstChild(Name);
    local v98 = Client3:FindFirstChild(Name);

    if v96 then
        v96:Destroy();
    end;

    if v97 then
        v97:Destroy();
    end;

    if v98 then
        v98:Destroy();
    end;
end;

local function connectAndPopulate(p99, u100) -- Line: 733
    -- upvalues: childAdded (copy), childRemoved (copy)
    p99.ChildAdded:Connect(function(p101) -- Line: 734
        -- upvalues: childAdded (ref), u100 (copy)
        task.spawn(childAdded, p101, u100);
    end);
    p99.ChildRemoved:Connect(childRemoved);

    for _, child in p99:GetChildren() do
        task.spawn(childAdded, child, u100);
    end;
end;

connectAndPopulate(Server, "Item");
connectAndPopulate(Server2, "Plant");
connectAndPopulate(Server3, "PottedPlant");
Remotes.UpdateClientModel.OnClientEvent:Connect(function(u102, u103) -- Line: 749
    -- upvalues: childRemoved (copy), Bindables (copy), childAdded (copy)
    task.spawn(function() -- Line: 750
        -- upvalues: childRemoved (ref), u102 (copy), u103 (copy), Bindables (ref), childAdded (ref)
        childRemoved(u102);
        u102:SetAttribute("Animation", u103);
        local ServerConfiguration = u102:WaitForChild("ServerConfiguration");
        Bindables.UpdateBillboard:Fire(u102, ServerConfiguration.Type.Value);

        if ServerConfiguration.Type.Value ~= "Egg" then
            if ServerConfiguration.Type.Value == "Tower" then
                childAdded(u102, "Item");

                return;
            end;

            childAdded(u102, ServerConfiguration.Type.Value);

            return;
        end;

        if not u102.PrimaryPart then
            u102:GetPropertyChangedSignal("PrimaryPart"):Wait();
        end;

        local CorrespondingAdornee = u102.PrimaryPart:FindFirstChild("HatchPrompt"):FindFirstChild("CorrespondingAdornee");

        if CorrespondingAdornee then
            CorrespondingAdornee:Destroy();
        end;

        childAdded(u102, "Item");
    end);
end);