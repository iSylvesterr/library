-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local UIanima = UtilsSystem.UIanima;
local TranslationHelper = UtilsSystem.TranslationHelper;

if not Players.LocalPlayer then
    error("LocalPlayer not found");
end;

local u1 = {};
local Parent = script.Parent;
local Frame = Parent:FindFirstChild("Frame");
local v2;

if Frame and Frame:IsA("Frame") then
    v2 = Frame:FindFirstChild("Window");
else
    v2 = nil;
end;

local BG = Parent:FindFirstChild("BG");

if BG and BG:IsA("Frame") then
    BG = BG:FindFirstChild("标题英文");
end;

local u3 = nil;
local BG2 = Parent:FindFirstChild("BG");

if BG2 and BG2:IsA("Frame") then
    local Exit = BG2:FindFirstChild("Exit");
    local v4 = Exit and Exit:IsA("Frame") and Exit:FindFirstChild("Button");

    if v4 then
        AddListen.AddMouseCLick(v4, function() -- Line: 56
            -- upvalues: u1 (copy)
            u1:closeUi();
        end, Exit);
    end;
end;

local u5 = nil;

if v2 and v2:IsA("Frame") then
    local Confirm = v2:FindFirstChild("Confirm");

    if Confirm and Confirm:IsA("Frame") then
        local Button = Confirm:FindFirstChild("Button");

        if Button then
            AddListen.AddMouseCLick(Button, function() -- Line: 70
                -- upvalues: u3 (ref), u1 (copy)
                if u3 and (u3.func and type(u3.func) == "function") then
                    u3.func();
                end;

                u1:closeUi();
            end, Confirm);
        end;

        local Frame2 = Confirm:FindFirstChild("Frame");

        if Frame2 and Frame2:IsA("Frame") then
            u5 = Frame2:FindFirstChild("Left");
        end;
    end;
end;

local u6 = nil;

if v2 and v2:IsA("Frame") then
    local Cancel = v2:FindFirstChild("Cancel");

    if Cancel and Cancel:IsA("Frame") then
        local Button = Cancel:FindFirstChild("Button");

        if Button then
            AddListen.AddMouseCLick(Button, function() -- Line: 92
                -- upvalues: u1 (copy)
                u1:closeUi();
            end, Cancel);
        end;

        local Frame2 = Cancel:FindFirstChild("Frame");

        if Frame2 and Frame2:IsA("Frame") then
            u6 = Frame2:FindFirstChild("Right");
        end;
    end;
end;

local u7;

if v2 and v2:IsA("Frame") then
    u7 = v2:FindFirstChild("Tips");
else
    u7 = nil;
end;

function u1.updateUi(p8, p9) -- Line: 114
    -- upvalues: u3 (ref), u7 (ref), TranslationHelper (copy), BG (ref), u5 (ref), u6 (ref)
    u3 = p9;

    if not u3 then
        return;
    end;

    if u3.Tips and (u7 and u7:IsA("TextLabel")) then
        if type(u3.Tips) == "table" then
            TranslationHelper.SetText(u7, u3.Tips[1], u3.Tips[2]);
        else
            TranslationHelper.SetText(u7, u3.Tips);
        end;

        if u3.Tips.RichText == nil then
            u7.RichText = false;
        else
            u7.RichText = u3.Tips.RichText;
        end;
    end;

    if BG and BG:IsA("TextLabel") then
        if u3.Title then
            if type(u3.Title) == "table" then
                TranslationHelper.SetText(BG, u3.Title[1], u3.Title[2]);
            else
                TranslationHelper.SetText(BG, u3.Title);
            end;
        else
            TranslationHelper.SetText(BG, "确认");
        end;
    end;

    if u5 and u5:IsA("TextLabel") then
        if u3.Left then
            if type(u3.Left) == "table" then
                TranslationHelper.SetText(u5, u3.Left[1], u3.Left[2]);
            else
                TranslationHelper.SetText(u5, u3.Left);
            end;
        else
            TranslationHelper.SetText(u5, "确认");
        end;
    end;

    if u6 and u6:IsA("TextLabel") then
        if u3.Right then
            if type(u3.Right) == "table" then
                TranslationHelper.SetText(u6, u3.Right[1], u3.Right[2]);

                return;
            end;

            TranslationHelper.SetText(u6, u3.Right);

            return;
        end;

        TranslationHelper.SetText(u6, "取消");
    end;
end;

function u1.openUi(p10) -- Line: 175
end;

function u1.closeUi(p11) -- Line: 182
    -- upvalues: UIanima (copy), Parent (copy)
    UIanima.PopBack(Parent);
end;

return u1;