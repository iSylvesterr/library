-- Decompiled with Potassium's decompiler.

local LocalPlayer = game:GetService("Players").LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local GuiController = require(LocalPlayer.PlayerScripts.Controllers.GuiController);
local u1 = Color3.fromRGB(255, 224, 0);
local v2 = {
    StartOrder = 6
};
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = false;

local function FinishSession(p9) -- Line: 28
    -- upvalues: u7 (ref), u8 (ref), u3 (ref), GuiController (copy)
    local v10 = u7;
    u7 = nil;
    u8 = false;

    if u3 and GuiController:IsOpen("ColorPickerGuild") then
        GuiController:Close();
    end;

    if v10 then
        local _, _ = pcall(v10, p9);
    end;
end;

local function ResolveRefs(p11) -- Line: 44
    -- upvalues: u4 (ref), u5 (ref), u6 (ref)
    local Backdrop = p11:FindFirstChild("Backdrop");

    if Backdrop then
        Backdrop = Backdrop:FindFirstChild("ColorPicker");
    end;

    if not Backdrop then
        return;
    end;

    local CurrentColorValue = Backdrop:FindFirstChild("CurrentColorValue");

    if CurrentColorValue and CurrentColorValue:IsA("Color3Value") then
        u4 = CurrentColorValue;
    end;

    local Buttons = Backdrop:FindFirstChild("Buttons");

    if Buttons then
        local ConfirmButton = Buttons:FindFirstChild("ConfirmButton");
        local CancelButton = Buttons:FindFirstChild("CancelButton");

        if ConfirmButton and ConfirmButton:IsA("GuiButton") then
            u5 = ConfirmButton;
        end;

        if CancelButton and CancelButton:IsA("GuiButton") then
            u6 = CancelButton;
        end;
    end;
end;

local function BindButtons() -- Line: 67
    -- upvalues: u5 (ref), u8 (ref), u4 (ref), u7 (ref), u3 (ref), GuiController (copy), u6 (ref)
    if u5 then
        u5.MouseButton1Click:Connect(function() -- Line: 69
            -- upvalues: u8 (ref), u4 (ref), u7 (ref), u3 (ref), GuiController (ref)
            if not u8 then
                return;
            end;

            local v12;

            if u4 then
                v12 = u4.Value;
            else
                v12 = nil;
            end;

            local v13 = u7;
            u7 = nil;
            u8 = false;

            if u3 and GuiController:IsOpen("ColorPickerGuild") then
                GuiController:Close();
            end;

            if v13 then
                local _, _ = pcall(v13, v12);
            end;
        end);
    end;

    if u6 then
        u6.MouseButton1Click:Connect(function() -- Line: 76
            -- upvalues: u8 (ref), u7 (ref), u3 (ref), GuiController (ref)
            if not u8 then
                return;
            end;

            local v14 = u7;
            u7 = nil;
            u8 = false;

            if u3 and GuiController:IsOpen("ColorPickerGuild") then
                GuiController:Close();
            end;

            if v14 then
                local _, _ = pcall(v14, nil);
            end;
        end);
    end;
end;

function v2.Init(p15) -- Line: 84
end;

function v2.Start(p16) -- Line: 86
    -- upvalues: PlayerGui (copy), u3 (ref), ResolveRefs (copy), BindButtons (copy), GuiController (copy), u8 (ref), u7 (ref)
    task.spawn(function() -- Line: 87
        -- upvalues: PlayerGui (ref), u3 (ref), ResolveRefs (ref), BindButtons (ref), GuiController (ref), u8 (ref), u7 (ref)
        local ColorPickerGuild = PlayerGui:WaitForChild("ColorPickerGuild", 30);

        if not (ColorPickerGuild and ColorPickerGuild:IsA("ScreenGui")) then
            return;
        end;

        u3 = ColorPickerGuild;
        ColorPickerGuild.Enabled = false;
        ResolveRefs(ColorPickerGuild);
        BindButtons();
        GuiController.GuiUnfocusedSignal:Connect(function(p17) -- Line: 97
            -- upvalues: ColorPickerGuild (copy), u8 (ref), u7 (ref), u3 (ref), GuiController (ref)
            if p17 == ColorPickerGuild and u8 then
                local v18 = u7;
                u7 = nil;
                u8 = false;

                if u3 and GuiController:IsOpen("ColorPickerGuild") then
                    GuiController:Close();
                end;

                if v18 then
                    local _, _ = pcall(v18, nil);
                end;
            end;
        end);
    end);
end;

function v2.RequestColor(p19, p20, p21) -- Line: 126
    -- upvalues: u8 (ref), u7 (ref), u3 (ref), GuiController (copy), u4 (ref), u1 (copy)
    if u8 then
        local v22 = u7;
        u7 = nil;
        u8 = false;

        if u3 and GuiController:IsOpen("ColorPickerGuild") then
            GuiController:Close();
        end;

        if v22 then
            local _, _ = pcall(v22, nil);
        end;
    end;

    if not u3 then
        p21(nil);

        return;
    end;

    if u4 and u4.Value == Color3.new(0, 0, 0) then
        u4.Value = p20 or u1;
    end;

    u7 = p21;
    u8 = true;
    GuiController:Open("ColorPickerGuild", nil, { "HUD" });
end;

function v2.GetCurrentColor(p23) -- Line: 154
    -- upvalues: u4 (ref)
    if u4 then
        return u4.Value;
    end;

    return nil;
end;

return v2;