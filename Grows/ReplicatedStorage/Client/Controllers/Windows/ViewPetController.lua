-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local PetConfig = require(ReplicatedStorage.Shared.Info.PetConfig);
local PetUI = require(ReplicatedStorage.Client.Modules.Utility.PetUI);
local v1 = Knit.CreateController({
    Name = "ViewPetController"
});

function v1.KnitStart(p2) -- Line: 12
    -- upvalues: Players (copy), Knit (copy), PetUI (copy), PetConfig (copy), RunService (copy)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
    local u3 = Knit.GetService("PlayerPlotService");
    local UI_Manager = p2.UI_Manager;
    local ViewPet = PlayerGui:WaitForChild("Windows"):WaitForChild("ViewPet");
    local Exit = ViewPet.Top:WaitForChild("Exit");
    local Cash = ViewPet.Top:FindFirstChild("Cash");
    local Pet = ViewPet.LeftSide:WaitForChild("Pet");
    local ViewportFrame = Pet:FindFirstChild("ViewportFrame");
    local PetName = Pet:FindFirstChild("PetName");
    local Description = ViewPet:FindFirstChild("Description");
    local v4 = Description and Description:FindFirstChild("TextLabel");
    local u5 = v4;
    local Bars = ViewPet:FindFirstChild("Bars");
    local u6 = nil;
    local u7 = nil;

    local function refreshBars() -- Line: 32
        -- upvalues: u6 (ref), u3 (copy), PetUI (ref), Bars (copy), u5 (ref), PetConfig (ref), UI_Manager (copy), ViewPet (copy)
        if not u6 then
            return;
        end;

        local v8, v9 = u3:GetPlacedPet(u6):await();

        if v8 and v9 then
            PetUI.applyBars(Bars, v9);

            if u5 then
                u5.Text = PetConfig.DescribeOwned(v9.petType, v9.level);
            end;

            return;
        end;

        if not v8 then
            return;
        end;

        UI_Manager:CloseWindow(ViewPet, true);
        u6 = nil;
    end;

    function p2.Open(p10) -- Line: 48
        -- upvalues: u3 (copy), u6 (ref), u7 (ref), Cash (copy), PetUI (ref), PetName (copy), u5 (ref), PetConfig (ref), ViewportFrame (copy), Bars (copy), UI_Manager (copy), ViewPet (copy)
        local v11, v12 = u3:GetPlacedPet(p10):await();

        if not (v11 and v12) then
            return;
        end;

        u6 = p10;
        u7 = v12.petType;

        if Cash then
            Cash.RichText = true;
            Cash.Text = PetUI.titleFor(v12.petType);
        end;

        if PetName then
            PetName.Text = tostring(v12.petName);
        end;

        if u5 then
            u5.RichText = true;
            u5.Text = PetConfig.DescribeOwned(v12.petType, v12.level);
        end;

        PetUI.renderAnimatedPet(ViewportFrame, v12.petType);
        PetUI.applyBars(Bars, v12);
        UI_Manager:OpenWindow(ViewPet, true);
    end;

    UI_Manager:AddBounceButton(Exit, 1.05, true);
    Exit.Activated:Connect(function() -- Line: 71
        -- upvalues: u6 (ref), UI_Manager (copy), ViewPet (copy)
        u6 = nil;
        UI_Manager:CloseWindow(ViewPet, true);
    end);
    local u13 = 0;
    RunService.Heartbeat:Connect(function(p14) -- Line: 78
        -- upvalues: ViewPet (copy), u6 (ref), u13 (ref), refreshBars (copy)
        if not (ViewPet.Visible and u6) then
            return;
        end;

        u13 = u13 + p14;

        if u13 < 1 then
            return;
        end;

        u13 = 0;
        refreshBars();
    end);
end;

function v1.KnitInit(p15) -- Line: 87
    -- upvalues: Knit (copy)
    p15.UI_Manager = Knit.GetController("UI_Manager");
    p15.DataClient = Knit.GetController("DataClient");
end;

return v1;