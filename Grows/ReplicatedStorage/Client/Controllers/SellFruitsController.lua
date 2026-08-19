-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Maid = require(ReplicatedStorage.Packages.Maid);
local v1 = Knit.CreateController({
    Name = "SellFruitsController"
});

function v1.KnitStart(p2) -- Line: 22
    -- upvalues: Maid (copy), Players (copy), Knit (copy)
    local u3 = Maid.new();
    p2._maid = u3;
    local LocalPlayer = Players.LocalPlayer;
    local u4 = Knit.GetService("SellFruitsService");
    local u5 = Knit.GetService("PlayerPlotService");
    local u6 = nil;
    local u7 = nil;
    local u8 = nil;
    local u9 = false;
    local u10 = nil;

    local function updateDisplays() -- Line: 42
        -- upvalues: u9 (ref), u10 (ref), u6 (ref), u8 (ref), u7 (ref)
        if u9 and u10 then
            local v11 = u10:GetAttribute("SellValue") or 0;
            local v12 = u10:GetAttribute("FruitName") or "Fruit";

            if u6 then
                u6.Enabled = true;
            end;

            if u8 then
                u8.Text = "$" .. v11;
            end;

            if u7 then
                u7.ObjectText = v12;
                u7.ActionText = "Sell";
                u7.Enabled = true;
            end;
        else
            if u6 then
                u6.Enabled = false;
            end;

            if u7 then
                u7.Enabled = false;
            end;
        end;
    end;

    local u13 = Maid.new();
    u3:GiveTask(u13);

    local function onChildAdded(p14) -- Line: 76
        -- upvalues: u9 (ref), u10 (ref), updateDisplays (copy)
        if not p14:IsA("Tool") then
            return;
        end;

        if not p14:GetAttribute("IsFruit") then
            return;
        end;

        u9 = true;
        u10 = p14;
        updateDisplays();
    end;

    local function onChildRemoved(p15) -- Line: 84
        -- upvalues: u10 (ref), u9 (ref), updateDisplays (copy)
        if p15 ~= u10 then
            return;
        end;

        u9 = false;
        u10 = nil;
        updateDisplays();
    end;

    local function setupCharacter(p16) -- Line: 91
        -- upvalues: u13 (copy), u9 (ref), u10 (ref), onChildAdded (copy), onChildRemoved (copy), updateDisplays (copy)
        u13:DoCleaning();
        u9 = false;
        u10 = nil;
        u13:GiveTask(p16.ChildAdded:Connect(onChildAdded));
        u13:GiveTask(p16.ChildRemoved:Connect(onChildRemoved));

        for _, child in p16:GetChildren() do
            if child:IsA("Tool") and child:GetAttribute("IsFruit") then
                u9 = true;
                u10 = child;
                break;
            end;
        end;

        updateDisplays();
    end;

    if LocalPlayer.Character then
        setupCharacter(LocalPlayer.Character);
    end;

    u3:GiveTask(LocalPlayer.CharacterAdded:Connect(setupCharacter));
    task.spawn(function() -- Line: 119
        -- upvalues: u5 (copy), u7 (ref), u6 (ref), u8 (ref), u3 (copy), u10 (ref), u4 (copy), updateDisplays (copy)
        local v17, v18 = u5:GetMyPlot():await();

        if not (v17 and v18) then
            return;
        end;

        local BigField = workspace:FindFirstChild("BigField");

        if BigField then
            BigField = BigField:FindFirstChild("PlayerPlots");
        end;

        if BigField then
            BigField = BigField:FindFirstChild("PlayerPlot" .. v18);
        end;

        if not BigField then
            return;
        end;

        local SellFruits = BigField:FindFirstChild("SellFruits");

        if not SellFruits then
            return;
        end;

        u7 = SellFruits:FindFirstChild("ProximityPrompt");
        u6 = SellFruits:FindFirstChild("BillboardGui");

        if u6 then
            local MainFrame = u6:FindFirstChild("MainFrame");

            if MainFrame then
                u8 = MainFrame:FindFirstChild("Amount");
            end;

            u6.Enabled = false;
        end;

        if u7 then
            u7.Style = Enum.ProximityPromptStyle.Custom;
            u7.MaxActivationDistance = 25;
            u7.Enabled = false;
            u3:GiveTask(u7.Triggered:Connect(function() -- Line: 146
                -- upvalues: u10 (ref), u4 (ref)
                if u10 then
                    u4:SellFruit();
                end;
            end));
        end;

        updateDisplays();
    end);
end;

function v1.KnitInit(p19) -- Line: 157
end;

return v1;