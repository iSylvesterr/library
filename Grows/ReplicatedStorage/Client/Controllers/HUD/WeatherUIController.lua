-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Maid = require(ReplicatedStorage.Packages.Maid);
local WeatherConfig = require(ReplicatedStorage.Shared.Info.WeatherConfig);
local MutationConfig = require(ReplicatedStorage.Shared.Info.MutationConfig);
local v1 = Knit.CreateController({
    Name = "WeatherUIController"
});

local function rgbTag(p2) -- Line: 25
    return string.format("rgb(%d,%d,%d)", math.round(p2.R * 255), math.round(p2.G * 255), (math.round(p2.B * 255)));
end;

local function formatTimer(p3) -- Line: 29
    local v4 = math.floor(p3);
    local v5 = math.max(0, v4);

    return string.format("%d:%02d", math.floor(v5 / 60), v5 % 60);
end;

local function mutationColor(p6) -- Line: 34
    -- upvalues: WeatherConfig (copy), MutationConfig (copy)
    local v7 = WeatherConfig.Weathers[p6];

    if v7 then
        v7 = MutationConfig.Mutations[v7.mutationKey];
    end;

    return v7 and v7.textColor or Color3.new(1, 1, 1);
end;

function v1.KnitStart(p8) -- Line: 40
    -- upvalues: Players (copy), Knit (copy), Maid (copy), UserInputService (copy), WeatherConfig (copy), MutationConfig (copy), RunService (copy), ReplicatedStorage (copy)
    local LocalPlayer = Players.LocalPlayer;
    local BottomRight = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("BottomRight");
    local WeatherIdentifier = BottomRight:WaitForChild("WeatherIdentifier");
    local Button = WeatherIdentifier:WaitForChild("Button");
    local Icon = Button:WaitForChild("Icon");
    local Timer = Button:WaitForChild("Timer");
    local WeatherInfo = BottomRight:WaitForChild("WeatherInfo");
    local WeatherName = WeatherInfo:WaitForChild("Content"):WaitForChild("WeatherName");
    local Info = WeatherInfo.Content:WaitForChild("Info");
    local u9 = WeatherName:FindFirstChildWhichIsA("UIGradient");
    local v10 = Knit.GetService("WeatherService");
    local SoundController = p8.SoundController;
    local NotificationController = p8.NotificationController;
    WeatherIdentifier.Visible = false;
    WeatherInfo.Visible = false;
    local u11 = nil;
    local u12 = 0;
    local u13 = Maid.new();

    local function isMobile() -- Line: 64
        -- upvalues: UserInputService (ref)
        return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled;
    end;

    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        local function copyPlacement(p14, p15) -- Line: 71
            if p14 and p15 then
                p14.AnchorPoint = p15.AnchorPoint;
                p14.Position = p15.Position;
                p14.Size = p15.Size;
            end;
        end;

        local WeatherIdentifierMOBILE = BottomRight:FindFirstChild("WeatherIdentifierMOBILE");
        local WeatherInfoMOBILE = BottomRight:FindFirstChild("WeatherInfoMOBILE");

        if WeatherIdentifier and WeatherIdentifierMOBILE then
            WeatherIdentifier.AnchorPoint = WeatherIdentifierMOBILE.AnchorPoint;
            WeatherIdentifier.Position = WeatherIdentifierMOBILE.Position;
            WeatherIdentifier.Size = WeatherIdentifierMOBILE.Size;
        end;

        if WeatherInfo and WeatherInfoMOBILE then
            WeatherInfo.AnchorPoint = WeatherInfoMOBILE.AnchorPoint;
            WeatherInfo.Position = WeatherInfoMOBILE.Position;
            WeatherInfo.Size = WeatherInfoMOBILE.Size;
        end;

        local v16 = WeatherIdentifierMOBILE and WeatherIdentifierMOBILE:FindFirstChild("Button") and WeatherIdentifierMOBILE.Button:FindFirstChild("Timer");

        if v16 then
            Timer.AnchorPoint = v16.AnchorPoint;
            Timer.Position = v16.Position;
        end;
    end;

    local function populateInfo(p17) -- Line: 93
        -- upvalues: WeatherConfig (ref), MutationConfig (ref), WeatherName (copy), u9 (copy), Info (copy)
        local v18 = WeatherConfig.Weathers[p17];
        local v19 = MutationConfig.Mutations[v18.mutationKey];
        local v20 = WeatherConfig.Weathers[p17];

        if v20 then
            v20 = MutationConfig.Mutations[v20.mutationKey];
        end;

        local v21 = v20 and v20.textColor or Color3.new(1, 1, 1);
        WeatherName.RichText = false;
        WeatherName.Text = v18.displayName:upper();
        local v22 = p17 == "Rainbow";

        if u9 then
            u9.Enabled = v22;
        end;

        local v23;

        if v22 then
            v23 = Color3.new(1, 1, 1) or v21;
        else
            v23 = v21;
        end;

        WeatherName.TextColor3 = v23;
        Info.RichText = true;
        Info.Text = string.format("Seeds and fruits have a %s%% chance to become <font color=\"%s\">%s</font>!", string.format("%g", v18.chance * 100), string.format("rgb(%d,%d,%d)", math.round(v21.R * 255), math.round(v21.G * 255), (math.round(v21.B * 255))), v19.displayName);
    end;

    local function showWeather(p24, p25, p26) -- Line: 113
        -- upvalues: u11 (ref), u12 (ref), WeatherConfig (ref), Icon (copy), populateInfo (copy), WeatherIdentifier (copy), MutationConfig (ref), NotificationController (copy), SoundController (copy), LocalPlayer (copy), u13 (ref), Maid (ref), RunService (ref), Timer (copy)
        u11 = p24;
        u12 = p25 or 0;
        local v27 = WeatherConfig.Weathers[p24];

        if not v27 then
            return;
        end;

        if v27.icon then
            Icon.Image = v27.icon;
        end;

        populateInfo(p24);
        WeatherIdentifier.Visible = true;

        if p26 and p26 ~= "" then
            local format = string.format;
            local v28 = WeatherConfig.Weathers[p24];

            if v28 then
                v28 = MutationConfig.Mutations[v28.mutationKey];
            end;

            local v29 = v28 and v28.textColor or Color3.new(1, 1, 1);
            NotificationController:SendNotification(format("%s made the weather <font color=\"%s\">%s</font>!", p26, string.format("rgb(%d,%d,%d)", math.round(v29.R * 255), math.round(v29.G * 255), (math.round(v29.B * 255))), v27.displayName), 4, Color3.new(1, 1, 1), false, false, false, 0, true);
        else
            local v30 = WeatherConfig.Weathers[p24];

            if v30 then
                v30 = MutationConfig.Mutations[v30.mutationKey];
            end;

            NotificationController:SendNotification(v27.notifText, 4, v30 and v30.textColor or Color3.new(1, 1, 1));
        end;

        SoundController:PlaySound("Weather Change", LocalPlayer);
        u13:Destroy();
        u13 = Maid.new();
        u13:GiveTask(RunService.Heartbeat:Connect(function() -- Line: 137
            -- upvalues: u12 (ref), Timer (ref)
            if u12 <= 0 then
                Timer.Visible = false;

                return;
            end;

            Timer.Visible = true;
            local v31 = u12 - workspace:GetServerTimeNow();
            local v32 = math.floor(v31);
            local v33 = math.max(0, v32);
            Timer.Text = string.format("%d:%02d", math.floor(v33 / 60), v33 % 60);
        end));
    end;

    local function hideWeather() -- Line: 147
        -- upvalues: u11 (ref), u12 (ref), WeatherIdentifier (copy), WeatherInfo (copy), u13 (ref), Maid (ref)
        u11 = nil;
        u12 = 0;
        WeatherIdentifier.Visible = false;
        WeatherInfo.Visible = false;
        u13:Destroy();
        u13 = Maid.new();
    end;

    Button.MouseEnter:Connect(function() -- Line: 157
        -- upvalues: u11 (ref), UserInputService (ref), WeatherInfo (copy)
        if u11 then
            if not (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled) then
                WeatherInfo.Visible = true;
            end;
        end;
    end);
    Button.MouseLeave:Connect(function() -- Line: 160
        -- upvalues: UserInputService (ref), WeatherInfo (copy)
        if not (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled) then
            WeatherInfo.Visible = false;
        end;
    end);
    Button.MouseButton1Down:Connect(function() -- Line: 163
        -- upvalues: u11 (ref), UserInputService (ref), WeatherInfo (copy)
        if u11 then
            if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
                WeatherInfo.Visible = true;
            end;
        end;
    end);
    Button.MouseButton1Up:Connect(function() -- Line: 166
        -- upvalues: UserInputService (ref), WeatherInfo (copy)
        if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
            WeatherInfo.Visible = false;
        end;
    end);
    v10.WeatherChanged:Connect(function(p34, p35, p36) -- Line: 170
        -- upvalues: showWeather (copy), u11 (ref), u12 (ref), WeatherIdentifier (copy), WeatherInfo (copy), u13 (ref), Maid (ref)
        if p34 and p34 ~= "" then
            showWeather(p34, p35 or 0, p36);

            return;
        end;

        u11 = nil;
        u12 = 0;
        WeatherIdentifier.Visible = false;
        WeatherInfo.Visible = false;
        u13:Destroy();
        u13 = Maid.new();
    end);
    local v37 = ReplicatedStorage:FindFirstChild("CurrentWeather") or ReplicatedStorage:WaitForChild("CurrentWeather", 10);

    if v37 and v37.Value ~= "" then
        showWeather(v37.Value, v37:GetAttribute("EndTime") or 0);
    end;
end;

function v1.KnitInit(p38) -- Line: 186
    -- upvalues: Knit (copy)
    p38.SoundController = Knit.GetController("SoundController");
    p38.NotificationController = Knit.GetController("NotificationController");
end;

return v1;