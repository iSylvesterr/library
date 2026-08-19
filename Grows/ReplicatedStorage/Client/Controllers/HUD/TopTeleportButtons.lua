-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Maid = require(ReplicatedStorage.Packages.Maid);
local v1 = Knit.CreateController({
    Name = "TopTeleportButtons"
});

local function targetPosition(p2) -- Line: 15
    if not p2 then
        return nil;
    end;

    if p2:IsA("Model") then
        return p2:GetPivot().Position;
    end;

    if p2:IsA("BasePart") then
        return p2.Position;
    end;

    return nil;
end;

local function hidePart(p3) -- Line: 25
    if p3:IsA("BasePart") then
        p3.Transparency = 1;
        p3.CanCollide = false;
        p3.CanQuery = false;
    end;
end;

local function dismountIfSeated(p4) -- Line: 35
    -- upvalues: RunService (copy)
    if p4 then
        p4 = p4:FindFirstChildOfClass("Humanoid");
    end;

    if p4 and p4.SeatPart then
        p4.Sit = false;
        p4:ChangeState(Enum.HumanoidStateType.Jumping);
        RunService.Heartbeat:Wait();
    end;
end;

function v1.KnitStart(p5) -- Line: 44
    -- upvalues: Maid (copy), Players (copy), Knit (copy), RunService (copy)
    local v6 = Maid.new();
    local LocalPlayer = Players.LocalPlayer;
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local u7 = Knit.GetService("PlayerPlotService");
    local BigField = workspace:WaitForChild("BigField");
    local SellStand = BigField:WaitForChild("SellStand");
    local SellTP = SellStand:WaitForChild("SellTP");
    local Stand = SellStand:FindFirstChild("Stand");
    local MarketStand = BigField:WaitForChild("MarketStand");
    local MarketTP = MarketStand:WaitForChild("MarketTP");
    local PromptHolder = MarketStand:FindFirstChild("PromptHolder");
    local PlayerPlots = BigField:WaitForChild("PlayerPlots");
    local Buttons = PlayerGui:WaitForChild("HUD"):WaitForChild("TopButtons"):WaitForChild("Center"):WaitForChild("Buttons");
    local Button = Buttons:WaitForChild("Plot"):WaitForChild("Button");
    local Button2 = Buttons:WaitForChild("Sell"):WaitForChild("Button");
    local Button3 = Buttons:WaitForChild("Market"):WaitForChild("Button");
    p5.UI_Manager:AddBounceButton(Button, 1.08, false);
    p5.UI_Manager:AddBounceButton(Button2, 1.08, false);
    p5.UI_Manager:AddBounceButton(Button3, 1.08, false);

    local function teleportTo(p8, p9) -- Line: 72
        -- upvalues: LocalPlayer (copy), RunService (ref)
        if not p8 then
            return;
        end;

        local Character = LocalPlayer.Character;
        local v10;

        if Character then
            v10 = Character:FindFirstChild("HumanoidRootPart");
        else
            v10 = Character;
        end;

        if not v10 then
            return;
        end;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        if Character and Character.SeatPart then
            Character.Sit = false;
            Character:ChangeState(Enum.HumanoidStateType.Jumping);
            RunService.Heartbeat:Wait();
        end;

        local v11 = p8.Position + Vector3.new(0, 3, 0);
        local v12 = nil;
        local v13;

        if p9 then
            if p9:IsA("Model") then
                v13 = p9:GetPivot().Position;
            elseif p9:IsA("BasePart") then
                v13 = p9.Position;
            else
                v13 = nil;
            end;
        else
            v13 = nil;
        end;

        if v13 then
            local v14 = Vector3.new(v13.X - v11.X, 0, v13.Z - v11.Z);

            if v14.Magnitude > 0.01 then
                v12 = v14.Unit;
            end;
        end;

        if v12 then
            v10.CFrame = CFrame.lookAt(v11, v11 + v12);

            return;
        end;

        v10.CFrame = CFrame.new(v11);
    end;

    v6:GiveTask(Button2.Activated:Connect(function() -- Line: 98
        -- upvalues: teleportTo (copy), SellTP (copy), Stand (copy)
        teleportTo(SellTP, Stand);
    end));
    v6:GiveTask(Button3.Activated:Connect(function() -- Line: 102
        -- upvalues: teleportTo (copy), MarketTP (copy), PromptHolder (copy)
        teleportTo(MarketTP, PromptHolder);
    end));
    v6:GiveTask(Button.Activated:Connect(function() -- Line: 106
        -- upvalues: u7 (copy), PlayerPlots (copy), teleportTo (copy)
        local v15, v16 = u7:GetMyPlot():await();

        if not (v15 and v16) then
            return;
        end;

        local v17 = PlayerPlots:FindFirstChild("PlayerPlot" .. v16);

        if not v17 then
            return;
        end;

        teleportTo(v17:FindFirstChild("PlotTP"), v17);
    end));

    local function shouldHideTP(p18) -- Line: 115
        if p18:IsA("BasePart") then
            return (p18.Name == "SellTP" or (p18.Name == "MarketTP" or p18.Name == "FurnitureShopTP")) and true or (p18.Name == "PlotTP" and (p18.Parent and p18.Parent.Name ~= "SeedPlot") and true or false);
        end;

        return false;
    end;

    for _, descendant in BigField:GetDescendants() do
        local v19;

        if descendant:IsA("BasePart") then
            v19 = (descendant.Name == "SellTP" or (descendant.Name == "MarketTP" or descendant.Name == "FurnitureShopTP")) and true or (descendant.Name == "PlotTP" and (descendant.Parent and descendant.Parent.Name ~= "SeedPlot") and true or false);
        else
            v19 = false;
        end;

        if v19 and descendant:IsA("BasePart") then
            descendant.Transparency = 1;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
        end;
    end;

    v6:GiveTask(PlayerPlots.DescendantAdded:Connect(function(p20) -- Line: 125
        local v21;

        if p20:IsA("BasePart") then
            v21 = (p20.Name == "SellTP" or (p20.Name == "MarketTP" or p20.Name == "FurnitureShopTP")) and true or (p20.Name == "PlotTP" and (p20.Parent and p20.Parent.Name ~= "SeedPlot") and true or false);
        else
            v21 = false;
        end;

        if v21 and p20:IsA("BasePart") then
            p20.Transparency = 1;
            p20.CanCollide = false;
            p20.CanQuery = false;
        end;
    end));
    p5._maid = v6;
end;

function v1.KnitInit(p22) -- Line: 132
    -- upvalues: Knit (copy)
    p22.UI_Manager = Knit.GetController("UI_Manager");
end;

return v1;