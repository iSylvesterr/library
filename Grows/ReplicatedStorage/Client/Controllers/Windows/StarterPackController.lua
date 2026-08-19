-- Decompiled with Potassium's decompiler.

local Knit = require(game.ReplicatedStorage.Packages.Knit);
local UI_Manager = require(game.ReplicatedStorage.Client.Controllers.UI_Manager);
require(game.ReplicatedStorage.Client.Modules.Utility.MusicAndAmbience);
require(game.ReplicatedStorage.Shared.Info.Constants);
require(game.ReplicatedStorage.Shared.Info.CustomEnum);
local v1 = Knit.CreateController({
    Name = "StarterPackController"
});
local PlayerGui = game.Players.LocalPlayer.PlayerGui;
local Windows = PlayerGui:WaitForChild("Windows");
local StarterPack = Windows:WaitForChild("StarterPack");
local Exit = StarterPack:WaitForChild("Top"):WaitForChild("Exit");
local Cash = StarterPack:WaitForChild("Top"):WaitForChild("Cash");
local Button = StarterPack:WaitForChild("RobuxButton"):WaitForChild("Button");
local Seeds = StarterPack:WaitForChild("Content"):WaitForChild("Seeds");
local Icon = Seeds:WaitForChild("Orange"):WaitForChild("Icon");
local Icon2 = Seeds:WaitForChild("Avocado"):WaitForChild("Icon");
local Icon3 = Seeds:WaitForChild("Lemon"):WaitForChild("Icon");
local StarterPackButton = PlayerGui:WaitForChild("HUD"):WaitForChild("SideMenus"):WaitForChild("Right"):WaitForChild("Buttons"):WaitForChild("StarterPackButton");
local Timer = StarterPackButton:WaitForChild("Button"):WaitForChild("Timer");

local function formatTimer(p2) -- Line: 40
    local v3 = math.floor(p2);
    local v4 = math.max(0, v3);

    return ("%dm %ds"):format(v4 // 60, v4 % 60);
end;

local function offerRemaining(p5) -- Line: 46
    if not p5 or (p5.StarterPackOfferStart or 0) <= 0 then
        return 0;
    end;

    local v6 = p5.StarterPackOfferRemaining or 0;
    local v7 = p5.StarterPackSessionStart or os.time();
    local v8 = os.time() - v7;

    return v6 - math.max(0, v8);
end;

function v1.Update(p9) -- Line: 53
    -- upvalues: StarterPackButton (copy), Timer (copy), Cash (copy), StarterPack (copy)
    local currentData = p9.DataClient.currentData;
    local v10;

    if currentData then
        v10 = currentData.StarterPackPurchased == true;
    else
        v10 = currentData;
    end;

    local v11 = currentData and (currentData.StarterPackOfferStart or 0) or 0;
    local v12;

    if currentData and (currentData.StarterPackOfferStart or 0) > 0 then
        local v13 = currentData.StarterPackOfferRemaining or 0;
        local v14 = currentData.StarterPackSessionStart or os.time();
        local v15 = os.time() - v14;
        v12 = v13 - math.max(0, v15);
    else
        v12 = 0;
    end;

    local v16 = not v10 and v12 > 0;
    StarterPackButton.Visible = v16;

    if not v16 then
        if StarterPack.Visible and (v10 or v11 > 0) then
            p9.UI_Manager:CloseWindow(StarterPack, true);
        end;

        return;
    end;

    local v17 = math.floor(v12);
    local v18 = math.max(0, v17);
    local v19 = ("%dm %ds"):format(v18 // 60, v18 % 60);
    Timer.Text = v19;
    Cash.Text = "OFFER ENDS IN: " .. v19;
end;

function v1.KnitStart(u20) -- Line: 71
    -- upvalues: UI_Manager (copy), Exit (copy), StarterPack (copy), Button (copy), Windows (copy), Icon (copy), Icon2 (copy), Icon3 (copy)
    UI_Manager:AddBounceButton(Exit, 1.2, true);
    Exit.Activated:Connect(function() -- Line: 74
        -- upvalues: UI_Manager (ref), StarterPack (ref)
        UI_Manager:CloseWindow(StarterPack, true);
    end);
    UI_Manager:AddBounceButton(Button, 1.05);
    Button.Activated:Connect(function() -- Line: 79
        -- upvalues: u20 (copy)
        u20.PurchaseManager.PromptProductPurchase:Fire("StarterPack");
    end);
    u20.StarterPackService.OfferStarted:Connect(function() -- Line: 83
        -- upvalues: Windows (ref), u20 (copy), UI_Manager (ref), StarterPack (ref)
        task.spawn(function() -- Line: 84
            -- upvalues: Windows (ref), u20 (ref), UI_Manager (ref), StarterPack (ref)
            task.wait(1);
            local Rebirth = Windows:WaitForChild("Rebirth");

            while Rebirth.Visible do
                Rebirth:GetPropertyChangedSignal("Visible"):Wait();
            end;

            task.wait(0.5);
            local currentData = u20.DataClient.currentData;

            if currentData and currentData.StarterPackPurchased ~= true then
                local v21;

                if currentData and (currentData.StarterPackOfferStart or 0) > 0 then
                    local v22 = currentData.StarterPackOfferRemaining or 0;
                    local v23 = currentData.StarterPackSessionStart or os.time();
                    local v24 = os.time() - v23;
                    v21 = v22 - math.max(0, v24);
                else
                    v21 = 0;
                end;

                if v21 > 0 then
                    u20:Update();
                    UI_Manager:OpenWindow(StarterPack, true, true);
                end;
            end;
        end);
    end);
    u20.DataClient.EV_UPDATE:Connect(function() -- Line: 101
        -- upvalues: u20 (copy)
        u20:Update();
    end);
    task.spawn(function() -- Line: 104
        -- upvalues: u20 (copy)
        while true do
            u20:Update();
            task.wait(0.5);
        end;
    end);
    UI_Manager:AddEmitterTemplate(Icon, UDim2.new(0.5, 0, 0.5, 0), UI_Manager.PARTICLE_TEMPLATES.SPARKLE, {
        zIndex = 4,
        em_delay = 0.8
    });
    UI_Manager:AddShineV3(Icon, 1.75, Color3.new(1, 1, 1), {
        noThinTwinkle = true,
        rotSpeed = 20
    });
    UI_Manager:AddEmitterTemplate(Icon2, UDim2.new(0.5, 0, 0.5, 0), UI_Manager.PARTICLE_TEMPLATES.SPARKLE, {
        zIndex = 4,
        em_delay = 0.9
    });
    UI_Manager:AddShineV3(Icon2, 1.75, Color3.new(1, 1, 1), {
        noThinTwinkle = true,
        rotSpeed = 20
    });
    UI_Manager:AddEmitterTemplate(Icon3, UDim2.new(0.5, 0, 0.5, 0), UI_Manager.PARTICLE_TEMPLATES.SPARKLE, {
        zIndex = 4,
        em_delay = 1.1
    });
    UI_Manager:AddShineV3(Icon3, 1.75, Color3.new(1, 1, 1), {
        noThinTwinkle = true,
        rotSpeed = 20
    });
end;

function v1.KnitInit(p25) -- Line: 156
    -- upvalues: Knit (copy)
    p25.DataClient = Knit.GetController("DataClient");
    p25.UI_Manager = Knit.GetController("UI_Manager");
    p25.PurchaseManager = Knit.GetService("PurchaseManager");
    p25.StarterPackService = Knit.GetService("StarterPackService");
end;

return v1;