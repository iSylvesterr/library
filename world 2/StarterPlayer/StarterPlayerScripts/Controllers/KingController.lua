-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerValues = ReplicatedStorage.ServerValues;
local KingFruitID = ServerValues.KingFruitID;
local KingEnabled = ServerValues.KingEnabled;
local Gardens = workspace:WaitForChild("Gardens");
local u1 = {};
local v2 = {
    StartOrder = 3
};

for _, v in require(ReplicatedStorage.SharedModules.SeedData) do
    local v3 = v.SeedName or v.PlantName;

    if v.IsSingleHarvest then
        u1[v3] = true;
    end;
end;

local u4 = nil;
local u5 = nil;
local u6 = 0;
local u7 = 0;

local function cleanupHighlight() -- Line: 28
    -- upvalues: u6 (ref), u4 (ref), u5 (ref)
    u6 = u6 + 1;

    if u4 then
        u4:Destroy();
        u4 = nil;
    end;

    if u5 then
        u5:Destroy();
        u5 = nil;
    end;
end;

local function cleanupAll() -- Line: 40
    -- upvalues: u6 (ref), u4 (ref), u5 (ref), u7 (ref)
    u6 = u6 + 1;

    if u4 then
        u4:Destroy();
        u4 = nil;
    end;

    if u5 then
        u5:Destroy();
        u5 = nil;
    end;

    u7 = u7 + 1;
end;

local function getVisibleCenter(p8) -- Line: 45
    local v9 = 0;
    local v10 = Vector3.new(0, 0, 0);

    for _, descendant in p8:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            v9 = v9 + 1;
            v10 = v10 + descendant.Position;
        end;
    end;

    if v9 == 0 then
        return nil;
    end;

    return v10 / v9;
end;

local function assignKingFruit(u11) -- Line: 58
    -- upvalues: u6 (ref), u4 (ref), u5 (ref), getVisibleCenter (copy)
    u6 = u6 + 1;

    if u4 then
        u4:Destroy();
        u4 = nil;
    end;

    if u5 then
        u5:Destroy();
        u5 = nil;
    end;

    u6 = u6 + 1;
    local u12 = u6;
    task.spawn(function() -- Line: 64
        -- upvalues: u12 (copy), u6 (ref), getVisibleCenter (ref), u11 (copy), u4 (ref), u5 (ref)
        local v13 = nil;

        while u12 == u6 do
            v13 = getVisibleCenter(u11);

            if v13 then
                break;
            end;

            if not u11.Parent then
                return;
            end;

            task.wait(0.1);
        end;

        if u12 ~= u6 then
            return;
        end;

        u4 = Instance.new("Highlight");
        u4.FillTransparency = 0.25;
        u4.OutlineTransparency = 0.5;
        u4.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
        u4.FillColor = Color3.new(1, 0.784314, 0);
        u4.OutlineColor = Color3.new(1, 0.784314, 0);
        u4.Adornee = u11;
        u4.Name = "KingHighlight";
        u4.Parent = u11;
        u5 = script.attRef:Clone();
        u5.Parent = u11;
        u5.WorldCFrame = CFrame.new(v13);
        local CurrentCamera = workspace.CurrentCamera;

        while u12 == u6 do
            local Position = CurrentCamera.CFrame.Position;

            if not (u11.Parent and u11.PrimaryPart) then
                break;
            end;

            local Position2 = u11.PrimaryPart.Position;
            local v14 = (Vector3.new(Position.X, 0, Position.Z) - Vector3.new(Position2.X, 0, Position2.Z)).Magnitude < 200;
            u4.Enabled = v14;
            u5.BillboardGui.Enabled = v14;
            task.wait();
        end;
    end);
end;

local function updateKingFruit() -- Line: 102
    -- upvalues: KingEnabled (copy), u6 (ref), u4 (ref), u5 (ref), u7 (ref), KingFruitID (copy), Gardens (copy), u1 (copy), getVisibleCenter (copy)
    if KingEnabled.Value then
        u7 = u7 + 1;
        local u15 = u7;
        local Value = KingFruitID.Value;
        task.spawn(function() -- Line: 112
            -- upvalues: u15 (copy), u7 (ref), Gardens (ref), u1 (ref), Value (copy), u6 (ref), u4 (ref), u5 (ref), getVisibleCenter (ref)
            while u15 == u7 do
                for _, child in Gardens:GetChildren() do
                    for _, child2 in child.Plants:GetChildren() do
                        if not u1[child2.Name] then
                            local Fruits = child2:FindFirstChild("Fruits");

                            if Fruits then
                                for _, child3 in Fruits:GetChildren() do
                                    if child3:GetAttribute("FruitId") == Value then
                                        u6 = u6 + 1;

                                        if u4 then
                                            u4:Destroy();
                                            u4 = nil;
                                        end;

                                        if u5 then
                                            u5:Destroy();
                                            u5 = nil;
                                        end;

                                        u6 = u6 + 1;
                                        local u16 = u6;
                                        task.spawn(function() -- Line: 64
                                            -- upvalues: u16 (copy), u6 (ref), getVisibleCenter (ref), child3 (copy), u4 (ref), u5 (ref)
                                            local v17 = nil;

                                            while u16 == u6 do
                                                v17 = getVisibleCenter(child3);

                                                if v17 then
                                                    break;
                                                end;

                                                if not child3.Parent then
                                                    return;
                                                end;

                                                task.wait(0.1);
                                            end;

                                            if u16 ~= u6 then
                                                return;
                                            end;

                                            u4 = Instance.new("Highlight");
                                            u4.FillTransparency = 0.25;
                                            u4.OutlineTransparency = 0.5;
                                            u4.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
                                            u4.FillColor = Color3.new(1, 0.784314, 0);
                                            u4.OutlineColor = Color3.new(1, 0.784314, 0);
                                            u4.Adornee = child3;
                                            u4.Name = "KingHighlight";
                                            u4.Parent = child3;
                                            u5 = script.attRef:Clone();
                                            u5.Parent = child3;
                                            u5.WorldCFrame = CFrame.new(v17);
                                            local CurrentCamera = workspace.CurrentCamera;

                                            while u16 == u6 do
                                                local Position = CurrentCamera.CFrame.Position;

                                                if not (child3.Parent and child3.PrimaryPart) then
                                                    break;
                                                end;

                                                local Position2 = child3.PrimaryPart.Position;
                                                local v18 = (Vector3.new(Position.X, 0, Position.Z) - Vector3.new(Position2.X, 0, Position2.Z)).Magnitude < 200;
                                                u4.Enabled = v18;
                                                u5.BillboardGui.Enabled = v18;
                                                task.wait();
                                            end;
                                        end);

                                        return;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;

                task.wait(0.5);
            end;
        end);

        return;
    end;

    u6 = u6 + 1;

    if u4 then
        u4:Destroy();
        u4 = nil;
    end;

    if u5 then
        u5:Destroy();
        u5 = nil;
    end;

    u7 = u7 + 1;
end;

function v2.Init(p19) -- Line: 134
    -- upvalues: KingEnabled (copy), u6 (ref), u4 (ref), u5 (ref), u7 (ref), KingFruitID (copy), Gardens (copy), u1 (copy), getVisibleCenter (copy), updateKingFruit (copy)
    if KingEnabled.Value then
        if KingEnabled.Value then
            u7 = u7 + 1;
            local u20 = u7;
            local Value = KingFruitID.Value;
            task.spawn(function() -- Line: 112
                -- upvalues: u20 (copy), u7 (ref), Gardens (ref), u1 (ref), Value (copy), u6 (ref), u4 (ref), u5 (ref), getVisibleCenter (ref)
                while u20 == u7 do
                    for _, child in Gardens:GetChildren() do
                        for _, child2 in child.Plants:GetChildren() do
                            if not u1[child2.Name] then
                                local Fruits = child2:FindFirstChild("Fruits");

                                if Fruits then
                                    for _, child3 in Fruits:GetChildren() do
                                        if child3:GetAttribute("FruitId") == Value then
                                            u6 = u6 + 1;

                                            if u4 then
                                                u4:Destroy();
                                                u4 = nil;
                                            end;

                                            if u5 then
                                                u5:Destroy();
                                                u5 = nil;
                                            end;

                                            u6 = u6 + 1;
                                            local u21 = u6;
                                            task.spawn(function() -- Line: 64
                                                -- upvalues: u21 (copy), u6 (ref), getVisibleCenter (ref), child3 (copy), u4 (ref), u5 (ref)
                                                local v22 = nil;

                                                while u21 == u6 do
                                                    v22 = getVisibleCenter(child3);

                                                    if v22 then
                                                        break;
                                                    end;

                                                    if not child3.Parent then
                                                        return;
                                                    end;

                                                    task.wait(0.1);
                                                end;

                                                if u21 ~= u6 then
                                                    return;
                                                end;

                                                u4 = Instance.new("Highlight");
                                                u4.FillTransparency = 0.25;
                                                u4.OutlineTransparency = 0.5;
                                                u4.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
                                                u4.FillColor = Color3.new(1, 0.784314, 0);
                                                u4.OutlineColor = Color3.new(1, 0.784314, 0);
                                                u4.Adornee = child3;
                                                u4.Name = "KingHighlight";
                                                u4.Parent = child3;
                                                u5 = script.attRef:Clone();
                                                u5.Parent = child3;
                                                u5.WorldCFrame = CFrame.new(v22);
                                                local CurrentCamera = workspace.CurrentCamera;

                                                while u21 == u6 do
                                                    local Position = CurrentCamera.CFrame.Position;

                                                    if not (child3.Parent and child3.PrimaryPart) then
                                                        break;
                                                    end;

                                                    local Position2 = child3.PrimaryPart.Position;
                                                    local v23 = (Vector3.new(Position.X, 0, Position.Z) - Vector3.new(Position2.X, 0, Position2.Z)).Magnitude < 200;
                                                    u4.Enabled = v23;
                                                    u5.BillboardGui.Enabled = v23;
                                                    task.wait();
                                                end;
                                            end);

                                            return;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;

                    task.wait(0.5);
                end;
            end);
        else
            u6 = u6 + 1;

            if u4 then
                u4:Destroy();
                u4 = nil;
            end;

            if u5 then
                u5:Destroy();
                u5 = nil;
            end;

            u7 = u7 + 1;
        end;
    end;

    KingFruitID:GetPropertyChangedSignal("Value"):Connect(updateKingFruit);
    Gardens.ChildAdded:Connect(updateKingFruit);
    KingEnabled:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 142
        -- upvalues: KingEnabled (ref), u6 (ref), u4 (ref), u5 (ref), u7 (ref), KingFruitID (ref), Gardens (ref), u1 (ref), getVisibleCenter (ref)
        if not KingEnabled.Value then
            u6 = u6 + 1;

            if u4 then
                u4:Destroy();
                u4 = nil;
            end;

            if u5 then
                u5:Destroy();
                u5 = nil;
            end;

            u7 = u7 + 1;

            return;
        end;

        if KingEnabled.Value then
            u7 = u7 + 1;
            local u24 = u7;
            local Value = KingFruitID.Value;
            task.spawn(function() -- Line: 112
                -- upvalues: u24 (copy), u7 (ref), Gardens (ref), u1 (ref), Value (copy), u6 (ref), u4 (ref), u5 (ref), getVisibleCenter (ref)
                while u24 == u7 do
                    for _, child in Gardens:GetChildren() do
                        for _, child2 in child.Plants:GetChildren() do
                            if not u1[child2.Name] then
                                local Fruits = child2:FindFirstChild("Fruits");

                                if Fruits then
                                    for _, child3 in Fruits:GetChildren() do
                                        if child3:GetAttribute("FruitId") == Value then
                                            u6 = u6 + 1;

                                            if u4 then
                                                u4:Destroy();
                                                u4 = nil;
                                            end;

                                            if u5 then
                                                u5:Destroy();
                                                u5 = nil;
                                            end;

                                            u6 = u6 + 1;
                                            local u25 = u6;
                                            task.spawn(function() -- Line: 64
                                                -- upvalues: u25 (copy), u6 (ref), getVisibleCenter (ref), child3 (copy), u4 (ref), u5 (ref)
                                                local v26 = nil;

                                                while u25 == u6 do
                                                    v26 = getVisibleCenter(child3);

                                                    if v26 then
                                                        break;
                                                    end;

                                                    if not child3.Parent then
                                                        return;
                                                    end;

                                                    task.wait(0.1);
                                                end;

                                                if u25 ~= u6 then
                                                    return;
                                                end;

                                                u4 = Instance.new("Highlight");
                                                u4.FillTransparency = 0.25;
                                                u4.OutlineTransparency = 0.5;
                                                u4.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
                                                u4.FillColor = Color3.new(1, 0.784314, 0);
                                                u4.OutlineColor = Color3.new(1, 0.784314, 0);
                                                u4.Adornee = child3;
                                                u4.Name = "KingHighlight";
                                                u4.Parent = child3;
                                                u5 = script.attRef:Clone();
                                                u5.Parent = child3;
                                                u5.WorldCFrame = CFrame.new(v26);
                                                local CurrentCamera = workspace.CurrentCamera;

                                                while u25 == u6 do
                                                    local Position = CurrentCamera.CFrame.Position;

                                                    if not (child3.Parent and child3.PrimaryPart) then
                                                        break;
                                                    end;

                                                    local Position2 = child3.PrimaryPart.Position;
                                                    local v27 = (Vector3.new(Position.X, 0, Position.Z) - Vector3.new(Position2.X, 0, Position2.Z)).Magnitude < 200;
                                                    u4.Enabled = v27;
                                                    u5.BillboardGui.Enabled = v27;
                                                    task.wait();
                                                end;
                                            end);

                                            return;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;

                    task.wait(0.5);
                end;
            end);

            return;
        end;

        u6 = u6 + 1;

        if u4 then
            u4:Destroy();
            u4 = nil;
        end;

        if u5 then
            u5:Destroy();
            u5 = nil;
        end;

        u7 = u7 + 1;
    end);
end;

return v2;