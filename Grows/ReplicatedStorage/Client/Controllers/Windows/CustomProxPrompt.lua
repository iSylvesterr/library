-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ProximityPromptService = game:GetService("ProximityPromptService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Knit = require(ReplicatedStorage.Packages.Knit);
local CustomEnum = require(ReplicatedStorage.Shared.Info.CustomEnum);
local v1 = Knit.CreateController({
    Name = "CustomProxPrompt"
});

local function isMobile() -- Line: 13
    -- upvalues: Knit (copy), CustomEnum (copy)
    return Knit.GetController("UserInputParser"):getInputType() == CustomEnum.INPUT_TYPES.MOBILE;
end;

local CustomProxPrompt = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Greedy"):WaitForChild("CustomProxPrompt");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local u2 = {};

local function isPlotPrompt(p3) -- Line: 28
    local Parent = p3.Parent;

    if not Parent then
        return false;
    end;

    if Parent.Name:match("^TreeBasePrompt_") then
        return true;
    end;

    if Parent.Name == "MultDisplay" then
        return true;
    end;

    local Parent2 = Parent.Parent;
    local v4;

    if Parent2 == nil then
        v4 = false;
    else
        v4 = Parent2.Name == "FruitSpawns";
    end;

    return v4;
end;

local function showBillboard(u5) -- Line: 37
    -- upvalues: u2 (copy), CustomProxPrompt (copy), LocalPlayer (copy), Knit (copy), CustomEnum (copy), PlayerGui (copy)
    if u2[u5] then
        return;
    end;

    local Parent = u5.Parent;

    if not Parent then
        return;
    end;

    local v6 = CustomProxPrompt:Clone();
    v6.Adornee = Parent;
    v6.MaxDistance = math.min(u5.MaxActivationDistance + LocalPlayer.CameraMaxZoomDistance + 15, 10000);
    v6.Enabled = true;
    local Button = v6:FindFirstChild("Button");
    local v7;

    if Button then
        v7 = Button:FindFirstChild("MainFrame");
    else
        v7 = Button;
    end;

    local u8;

    if v7 then
        u8 = v7:FindFirstChild("TextLabel");
    else
        u8 = v7;
    end;

    local v9;

    if u8 then
        u8.Text = u5.ActionText == "" and "Interact" or (u5.ActionText or "Interact");
        v9 = u5:GetPropertyChangedSignal("ActionText"):Connect(function() -- Line: 58, Name: syncText
            -- upvalues: u8 (copy), u5 (copy)
            u8.Text = u5.ActionText == "" and "Interact" or (u5.ActionText or "Interact");
        end);
    else
        v9 = nil;
    end;

    if v7 then
        v7 = v7:FindFirstChild("Keybind");
    end;

    if v7 then
        v7.Image = Knit.GetController("UserInputParser"):getInputType() == CustomEnum.INPUT_TYPES.MOBILE and "rbxassetid://120515921874906" or "rbxassetid://74611557201552";
    end;

    local v10;

    if Button then
        v10 = Button.Activated:Connect(function() -- Line: 72
            -- upvalues: u5 (copy)
            u5:InputHoldBegin();
            task.wait();
            u5:InputHoldEnd();
        end);
    else
        v10 = nil;
    end;

    v6.Parent = PlayerGui;
    u2[u5] = {
        billboard = v6,
        connection = v10,
        textConn = v9
    };
end;

local function hideBillboard(p11) -- Line: 88
    -- upvalues: u2 (copy)
    local v12 = u2[p11];

    if not v12 then
        return;
    end;

    if v12.connection then
        v12.connection:Disconnect();
    end;

    if v12.textConn then
        v12.textConn:Disconnect();
    end;

    v12.billboard:Destroy();
    u2[p11] = nil;
end;

function v1.KnitStart(p13) -- Line: 102
    -- upvalues: ProximityPromptService (copy), LocalPlayer (copy), showBillboard (copy), u2 (copy)
    ProximityPromptService.PromptShown:Connect(function(p14) -- Line: 103
        -- upvalues: LocalPlayer (ref), showBillboard (ref)
        if p14.Style == Enum.ProximityPromptStyle.Default then
            return;
        end;

        local Parent = p14.Parent;
        local v15;

        if Parent then
            if Parent.Name:match("^TreeBasePrompt_") or Parent.Name == "MultDisplay" then
                v15 = true;
            else
                local Parent2 = Parent.Parent;

                if Parent2 == nil then
                    v15 = false;
                else
                    v15 = Parent2.Name == "FruitSpawns";
                end;
            end;
        else
            v15 = false;
        end;

        if v15 then
            return;
        end;

        local v16 = p14:GetAttribute("PlantOwnerId");

        if v16 and v16 ~= LocalPlayer.UserId then
            return;
        end;

        showBillboard(p14);
    end);
    ProximityPromptService.PromptHidden:Connect(function(p17) -- Line: 112
        -- upvalues: u2 (ref)
        local v18 = u2[p17];

        if not v18 then
            return;
        end;

        if v18.connection then
            v18.connection:Disconnect();
        end;

        if v18.textConn then
            v18.textConn:Disconnect();
        end;

        v18.billboard:Destroy();
        u2[p17] = nil;
    end);
end;

function v1.KnitInit(p19) -- Line: 117
end;

return v1;