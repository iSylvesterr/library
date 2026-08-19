-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local ScreenResolution = require(ReplicatedStorage.Library.Client.ScreenResolution);
local DynamicScale = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Elements").Right.DynamicScale;

local function ScaleRight() -- Line: 28
    -- upvalues: DynamicScale (copy), ScreenResolution (copy)
    DynamicScale.Scale = ScreenResolution.GetScale() + 0.1;
end;

local function UpdateMobile() -- Line: 36
    -- upvalues: UserInputService (copy)
    if UserInputService.TouchEnabled then
    end;
end;

DynamicScale.Scale = ScreenResolution.GetScale() + 0.1;
local _ = UserInputService.TouchEnabled;

local function ScaleAll() -- Line: 32
    -- upvalues: DynamicScale (copy), ScreenResolution (copy)
    DynamicScale.Scale = ScreenResolution.GetScale() + 0.1;
end;

ScreenResolution.Changed:Connect(ScaleAll);

return {};