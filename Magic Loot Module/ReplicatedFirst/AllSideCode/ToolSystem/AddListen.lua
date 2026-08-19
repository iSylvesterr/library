-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SoundModule = UtilsSystem.SoundModule;
local UIanima = UtilsSystem.UIanima;
local Log = UtilsSystem.Log;
local u1 = {};
local MouseEnabled = UserInputService.MouseEnabled;

local function _updateFrameVisibleByPass(p2, p3, p4) -- Line: 70
    if p3.Value >= 1 then
        p2.Visible = p4;

        return;
    end;

    p2.Visible = not p4;
end;

function u1.NumValueAdd(p5, p6, p7) -- Line: 88
    if p7 == nil or p7 == true then
        p6(p5.Value);
    end;

    return p5.Changed:Connect(p6);
end;

function u1.AddProximityPrompt(p8, u9) -- Line: 102
    -- upvalues: RunService (copy), Players (copy)
    if p8 then
        return p8.Triggered:Connect(function(p10) -- Line: 107
            -- upvalues: RunService (ref), Players (ref), u9 (copy)
            local v11 = RunService:IsClient() and Players.LocalPlayer;

            if v11 then
                local PlayerGui = v11:FindFirstChild("PlayerGui");
                local v12 = PlayerGui and PlayerGui:FindFirstChild("CustomEUI");

                if v12 then
                    local v13 = v12:FindFirstChildOfClass("BillboardGui");

                    if v13 and v13.MaxDistance <= 0.1 then
                        return;
                    end;
                end;
            end;

            u9(p10);
        end);
    end;

    return nil;
end;

function u1.AddMouseCLick(u14, u15, u16) -- Line: 134
    -- upvalues: UIanima (copy), SoundModule (copy)
    local v17 = {};

    local function _restoreScaleIfPressed(p18) -- Line: 142
        -- upvalues: UIanima (ref)
        if p18:GetAttribute("MouseDown") == 1 then
            p18:SetAttribute("MouseDown", nil);
            UIanima.ButtonUp(p18);
        end;
    end;

    v17[#v17 + 1] = u14.MouseButton1Down:Connect(function() -- Line: 149
        -- upvalues: u16 (copy), UIanima (ref)
        if u16 then
            u16:SetAttribute("MouseDown", 1);
            UIanima.ButtonDown(u16);
        end;
    end);
    v17[#v17 + 1] = u14.MouseButton1Up:Connect(function() -- Line: 157
        -- upvalues: u16 (copy), UIanima (ref)
        if u16 then
            local v19 = u16;

            if v19:GetAttribute("MouseDown") == 1 then
                v19:SetAttribute("MouseDown", nil);
                UIanima.ButtonUp(v19);
            end;
        end;
    end);
    v17[#v17 + 1] = u14.MouseLeave:Connect(function() -- Line: 164
        -- upvalues: u16 (copy), UIanima (ref)
        if u16 then
            local v20 = u16;

            if v20:GetAttribute("MouseDown") == 1 then
                v20:SetAttribute("MouseDown", nil);
                UIanima.ButtonUp(v20);
            end;
        end;
    end);
    v17[#v17 + 1] = u14.MouseButton1Click:Connect(function() -- Line: 170
        -- upvalues: u14 (copy), SoundModule (ref), u15 (copy)
        local v21 = u14:GetAttribute("ClickSound");

        if v21 then
            SoundModule:PlaySoundLocal({
                SoundName = v21
            });
        else
            SoundModule:PlaySoundLocal({
                SoundName = "音效-UI-通用中度点击"
            });
        end;

        u15();
    end);

    return v17;
end;

function u1.DisconnectAll(p22) -- Line: 188
    for i, v in pairs(p22) do
        if v then
            v:Disconnect();
            p22[i] = nil;
        end;
    end;
end;

function u1.RemoveMouseClick(p23) -- Line: 202
    -- upvalues: u1 (copy)
    u1.DisconnectAll(p23);
end;

function u1.EnableByGamePass(p24, u25, p26, u27) -- Line: 214
    -- upvalues: Log (copy), u1 (copy)
    local GamePass = p24:WaitForChild("GamePass", 30);

    if not (GamePass and GamePass:IsA("Folder")) then
        Log.warn("EnableByGamePass: GamePass 文件夹等待超时或无效", p24.Name);

        return nil;
    end;

    local u28 = GamePass:WaitForChild(p26, 30);

    if u28 and u28:IsA("NumberValue") then
        return u1.NumValueAdd(u28, function() -- Line: 227
            -- upvalues: u25 (copy), u28 (copy), u27 (copy)
            local v29 = u25;
            local v30 = u27;

            if u28.Value >= 1 then
                v29.Visible = v30;

                return;
            end;

            v29.Visible = not v30;
        end);
    end;

    Log.warn("EnableByGamePass: 通行证 Tag 等待超时或无效", p24.Name, p26);

    return nil;
end;

function u1.AddMouseHover(p31, u32, u33) -- Line: 240
    -- upvalues: MouseEnabled (copy)
    local v34 = {};

    if not (p31 and p31:IsA("GuiObject")) then
        return v34;
    end;

    if MouseEnabled then
        table.insert(v34, p31.MouseEnter:Connect(u32));
        table.insert(v34, p31.MouseLeave:Connect(u33));

        return v34;
    end;

    if p31:IsA("GuiButton") then
        table.insert(v34, p31.MouseButton1Down:Connect(u32));
    else
        table.insert(v34, p31.InputBegan:Connect(function(p35) -- Line: 256
            -- upvalues: u32 (copy)
            if p35.UserInputType == Enum.UserInputType.Touch then
                u32();
            end;
        end));
    end;

    table.insert(v34, p31.MouseLeave:Connect(u33));

    if not p31:IsA("GuiButton") then
        table.insert(v34, p31.InputEnded:Connect(function(p36) -- Line: 264
            -- upvalues: u33 (copy)
            if p36.UserInputType == Enum.UserInputType.Touch then
                u33();
            end;
        end));
    end;

    return v34;
end;

return u1;