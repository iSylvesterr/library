-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 6
};
local Players = game:GetService("Players");
local SoundService = game:GetService("SoundService");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PropData = require(ReplicatedStorage.SharedModules.PropData);
local FenceData = require(ReplicatedStorage.SharedModules.FenceData);
local GuiController = require(game.Players.LocalPlayer.PlayerScripts.Controllers.GuiController);
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local Click = SoundService.SFX.Click;
local RollFrame_New = PlayerGui:WaitForChild("RollFrame_New");
local Spinner = RollFrame_New:WaitForChild("Frame"):WaitForChild("Spinner");
local Template = Spinner:WaitForChild("UIListLayout"):WaitForChild("Template");
local SkipButton = RollFrame_New:WaitForChild("BlackBackdrop"):WaitForChild("SkipButton");
local u2 = {};

function v1.Init(p3) -- Line: 24
    -- upvalues: Template (copy), PropData (copy), u2 (copy), FenceData (copy)
    Template.Visible = false;

    for _, v in PropData.Data do
        u2[v.PropName] = v.IMG;
    end;

    for _, v in FenceData.Data do
        u2[v.PropName] = v.IMG;
    end;
end;

function v1.Start(p4) -- Line: 36
end;

function v1.GetImage(p5, p6) -- Line: 39
    -- upvalues: u2 (copy)
    return u2[p6] or "";
end;

function v1.ReturnRandomItem(p7, p8) -- Line: 43
    local v9 = 0;

    for _, v in pairs(p8) do
        v9 = v9 + v.Chance;
    end;

    local v10 = math.random() * v9;
    local v11 = 0;

    for _, v in pairs(p8) do
        v11 = v11 + v.Chance;

        if v10 <= v11 then
            return v;
        end;
    end;

    return p8[#p8];
end;

function v1.ClearSpinnerFrames(p12) -- Line: 59
    -- upvalues: Spinner (copy)
    for _, child in pairs(Spinner:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "Template" then
            child:Destroy();
        end;
    end;
end;

function v1.MakeFrame(p13, p14, p15) -- Line: 67
    -- upvalues: Template (copy), Spinner (copy)
    local v16 = Template:Clone();
    local v17 = p14.Image or p13:GetImage(p14.Name);
    v16.Image.Image = v17;
    v16.ItemName.Text = p14.Name;
    v16.Name = "SpinnerFrame";
    v16.LayoutOrder = p15;
    v16.Visible = true;
    v16.Parent = Spinner;

    return v16;
end;

function v1.Roll(p18, p19, p20) -- Line: 79
    -- upvalues: GuiController (copy), Spinner (copy), Click (copy), TweenService (copy), SkipButton (copy)
    GuiController:Open("RollFrame_New");
    p18:ClearSpinnerFrames();
    local v21 = p20 or p18:ReturnRandomItem(p19);
    Spinner.Position = UDim2.new(0.5, 0, 0.5, 0);
    local v22 = {};

    for i = 1, 60 do
        v22[i] = p18:MakeFrame(i == 50 and v21 and v21 or p18:ReturnRandomItem(p19), i);
    end;

    task.wait();
    local v23 = v22[1];
    local X = v23.AbsoluteSize.X;
    local u24;

    if v22[2] then
        u24 = v22[2].AbsolutePosition.X - v23.AbsolutePosition.X;
    else
        u24 = X;
    end;

    local u25 = v23.AbsolutePosition.X + X / 2 - (Spinner.AbsolutePosition.X + Spinner.AbsoluteSize.X / 2);
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Value = 0;

    local function updateSpinner(p26) -- Line: 104
        -- upvalues: u25 (copy), u24 (copy), Spinner (ref)
        Spinner.Position = UDim2.new(0.5, -(u25 + p26 * u24), 0.5, 0);
    end;

    local u27 = 0;
    local v30 = NumberValue.Changed:Connect(function(p28) -- Line: 110
        -- upvalues: u25 (copy), u24 (copy), Spinner (ref), u27 (ref), Click (ref)
        Spinner.Position = UDim2.new(0.5, -(u25 + p28 * u24), 0.5, 0);
        local v29 = math.floor(p28 + 0.5);

        if u27 < v29 then
            u27 = v29;
            Click:Play();
        end;
    end);
    local u31 = TweenService:Create(NumberValue, TweenInfo.new(5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Value = 49
    });
    local u32 = coroutine.running();
    local u33 = false;

    local function finishRoll() -- Line: 127
        -- upvalues: u33 (ref), u31 (copy), NumberValue (copy), u25 (copy), u24 (copy), Spinner (ref), u32 (copy)
        if u33 then
            return;
        end;

        u33 = true;
        u31:Cancel();
        NumberValue.Value = 49;
        Spinner.Position = UDim2.new(0.5, -(u25 + 49 * u24), 0.5, 0);
        task.spawn(u32);
    end;

    local v34 = SkipButton.Activated:Once(finishRoll);
    local v35 = u31.Completed:Once(finishRoll);
    u31:Play();
    coroutine.yield();

    if v34 then
        v34:Disconnect();
    end;

    if v35 then
        v35:Disconnect();
    end;

    v30:Disconnect();
    NumberValue:Destroy();
    task.wait(1);
    GuiController:Close();

    return v21;
end;

return v1;