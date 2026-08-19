-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
game:GetService("ReplicatedStorage"):WaitForChild("Remotes");
local LocalPlayer = Players.LocalPlayer;
local Map = workspace:WaitForChild("World"):WaitForChild("Map", (1 / 0));
local Plots = Map:WaitForChild("Plots");
local NPCs = Map:WaitForChild("NPCs");
local EggNPC = NPCs:WaitForChild("EggNPC");
local SellNPC = NPCs:WaitForChild("SellNPC");
local GearNPC = NPCs:WaitForChild("GearNPC");
local EggShop = Map:WaitForChild("EggShop");
local SellShop = Map:WaitForChild("SellShop");
local GearShop = Map:WaitForChild("GearShop");
local PlotMainIslandPortal = Map:WaitForChild("PlotMainIslandPortal");
local BossSummoner = Map:WaitForChild("BossSummoner");

repeat
    task.wait();
until workspace:GetAttribute("Loaded") == true;

local v1 = Plots:FindFirstChild("1");

local function findOwnedPlot() -- Line: 32
    -- upvalues: Plots (copy), LocalPlayer (copy)
    for _, child in Plots:GetChildren() do
        if child:GetAttribute("Owner") == LocalPlayer.UserId then
            return child;
        end;
    end;

    return nil;
end;

local v2 = findOwnedPlot();

if not v2 then
    local v3 = os.clock() + 15;

    repeat
        task.wait(0.1);
        v2 = findOwnedPlot();
    until v2 or v3 < os.clock();
end;

if v2 and v2 ~= v1 then
    local CFrame = v1:WaitForChild("ReferencePoint").CFrame;
    local CFrame2 = v2:WaitForChild("ReferencePoint").CFrame;

    local function waitForAssembly(p4) -- Line: 65
        local PrimaryPart = p4.PrimaryPart;

        if not PrimaryPart then
            return;
        end;

        local v5 = os.clock() + 10;

        while true do
            if os.clock() >= v5 then
                return;
            end;

            local v6 = true;

            for _, descendant in p4:GetDescendants() do
                if descendant:IsA("BasePart") and (not descendant.Anchored and descendant.AssemblyRootPart ~= PrimaryPart.AssemblyRootPart) then
                    v6 = false;
                    break;
                end;
            end;

            if v6 then
                return;
            end;

            task.wait(0.05);
        end;
    end;

    local function moveObject(u7) -- Line: 90
        -- upvalues: waitForAssembly (copy), CFrame (copy), CFrame2 (copy)
        if not u7.PrimaryPart then
            local v8 = os.clock() + 10;
            local v9;

            repeat
                task.wait(0.05);
                v9 = u7.PrimaryPart;
            until v9 or v8 < os.clock();

            if not v9 then
                warn("MoveShopNPCs: no PrimaryPart for", u7.Name, "- skipping");

                return;
            end;
        end;

        waitForAssembly(u7);
        local u10 = CFrame2 * CFrame:ToObjectSpace(u7.PrimaryPart.CFrame);
        u7:PivotTo(u10);
        local PrimaryPart = u7.PrimaryPart;
        local u11 = PrimaryPart:GetPropertyChangedSignal("CFrame"):Connect(function() -- Line: 131
            -- upvalues: PrimaryPart (copy), u10 (copy), u7 (copy)
            if (PrimaryPart.Position - u10.Position).Magnitude > 1 then
                u7:PivotTo(u10);
            end;
        end);
        u7.Destroying:Once(function() -- Line: 141
            -- upvalues: u11 (ref)
            if u11 then
                u11:Disconnect();
            end;
        end);
    end;

    for _, v in ipairs({
        EggNPC,
        SellNPC,
        GearNPC,
        EggShop,
        SellShop,
        GearShop,
        PlotMainIslandPortal,
        BossSummoner
    }) do
        if v and v:IsA("Model") then
            task.spawn(moveObject, v);
        end;
    end;
end;