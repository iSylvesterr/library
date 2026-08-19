-- Decompiled with Potassium's decompiler.

local Knit = require(game.ReplicatedStorage.Packages.Knit);
local UI_Manager = require(game.ReplicatedStorage.Client.Controllers.UI_Manager);
require(game.ReplicatedStorage.Client.Modules.Utility.MusicAndAmbience);
local Constants = require(game.ReplicatedStorage.Shared.Info.Constants);
require(game.ReplicatedStorage.Shared.Info.CustomEnum);
local v1 = Knit.CreateController({
    Name = "SettingsUI"
});
local SettingsSimple = game.Players.LocalPlayer.PlayerGui:WaitForChild("Windows"):WaitForChild("SettingsSimple");
local Exit = SettingsSimple:WaitForChild("Top"):WaitForChild("Exit");
local Body = SettingsSimple:WaitForChild("Body");
local Button = Body:WaitForChild("Music"):WaitForChild("OnOff"):WaitForChild("Button");
local Button2 = Body:WaitForChild("PerformanceMode"):WaitForChild("OnOff"):WaitForChild("Button");
local Codes = Body:WaitForChild("Codes");
local CodeBox = Codes:WaitForChild("CodeEnter"):WaitForChild("CodeBox");
local Button3 = Codes:WaitForChild("CodeEnter"):WaitForChild("ConfirmButton"):WaitForChild("Button");
local TextLabel = Codes:WaitForChild("Message"):WaitForChild("TextLabel");
local BackgroundColor3 = Button.BackgroundColor3;
local u2 = Color3.new(0.698039, 0.094117, 0.094117);

function v1.Update(p3) -- Line: 43
    -- upvalues: Button (copy), u2 (copy), BackgroundColor3 (copy), Button2 (copy)
    if p3.DataClient.currentData.Settings.MusicMute == true then
        Button.BackgroundColor3 = u2;
        Button.TextLabel.Text = "OFF";
    else
        Button.BackgroundColor3 = BackgroundColor3;
        Button.TextLabel.Text = "ON";
    end;

    if p3.DataClient.currentData.Settings.PerformanceMode == true then
        Button2.BackgroundColor3 = BackgroundColor3;
        Button2.TextLabel.Text = "ON";

        return;
    end;

    Button2.BackgroundColor3 = u2;
    Button2.TextLabel.Text = "OFF";
end;

function v1.KnitStart(u4) -- Line: 63
    -- upvalues: UI_Manager (copy), Exit (copy), Button3 (copy), Button (copy), Button2 (copy), SettingsSimple (copy), TextLabel (copy), CodeBox (copy), Constants (copy)
    UI_Manager:AddBounceButton(Exit, 1.2, true);
    UI_Manager:AddBounceButton(Button3, 1.1);
    UI_Manager:AddBounceButton(Button, 1.1);
    UI_Manager:AddBounceButton(Button2, 1.1);
    Exit.Activated:Connect(function() -- Line: 71
        -- upvalues: UI_Manager (ref), SettingsSimple (ref)
        UI_Manager:CloseWindow(SettingsSimple, true);
    end);
    SettingsSimple:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 75
        -- upvalues: SettingsSimple (ref), TextLabel (ref)
        if SettingsSimple.Visible then
            TextLabel.Text = "";
        end;
    end);
    Button.Activated:Connect(function() -- Line: 81
        -- upvalues: u4 (copy)
        if not u4.DataClient.currentData then
            return;
        end;

        u4.SettingsManager.setMusicMute:Fire(not u4.DataClient.currentData.Settings.MusicMute);
    end);
    Button2.Activated:Connect(function() -- Line: 87
        -- upvalues: u4 (copy)
        if not u4.DataClient.currentData then
            return;
        end;

        u4.SettingsManager.setPerformanceMode:Fire(not u4.DataClient.currentData.Settings.PerformanceMode);
    end);
    Button3.Activated:Connect(function() -- Line: 93
        -- upvalues: u4 (copy), CodeBox (ref), TextLabel (ref), Constants (ref)
        u4.CodeService:ClaimCode(CodeBox.Text):andThen(function(p5) -- Line: 94
            -- upvalues: CodeBox (ref), TextLabel (ref), Constants (ref)
            CodeBox.Text = "";

            if p5.success then
                TextLabel.TextColor3 = Constants.UI_GREEN;
            else
                TextLabel.TextColor3 = Constants.UI_RED;
            end;

            TextLabel.Text = p5.msg or "";
        end);
    end);
    u4.DataClient.EV_UPDATE:Connect(function() -- Line: 108
        -- upvalues: u4 (copy)
        u4:Update();
    end);
    u4.DataClient.EV_FIRST_UPDATE:Once(function() -- Line: 111
    end);
end;

function v1.KnitInit(p6) -- Line: 116
    -- upvalues: Knit (copy)
    p6.DataClient = Knit.GetController("DataClient");
    p6.SettingsManager = Knit.GetService("SettingsManager");
    p6.CodeService = Knit.GetService("CodeService");
    p6.UserInputParser = Knit.GetController("UserInputParser");
end;

return v1;