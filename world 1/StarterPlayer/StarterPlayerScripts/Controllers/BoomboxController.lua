-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local HttpService = game:GetService("HttpService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local BoomboxFlags = require(ReplicatedStorage.SharedModules.Flags.BoomboxFlags);
local GuiController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.GuiController);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local u2 = LocalPlayer:GetMouse();
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = 1;
local u14 = false;
local u15 = 0;

function u1.ParseConfig(u16) -- Line: 52
    -- upvalues: HttpService (copy)
    local v17 = {
        soundId = "",
        volume = 1,
        paused = false
    };

    if type(u16) ~= "string" or u16 == "" then
        return v17;
    end;

    local success, result = pcall(function() -- Line: 57
        -- upvalues: HttpService (ref), u16 (copy)
        return HttpService:JSONDecode(u16);
    end);

    if not success or type(result) ~= "table" then
        return v17;
    end;

    if type(result.s) == "string" then
        v17.soundId = result.s;
    end;

    if type(result.v) == "number" and result.v == result.v then
        v17.volume = math.clamp(result.v, 0, 2);
    end;

    v17.paused = result.p == true;

    return v17;
end;

local function percentToVolume(p18) -- Line: 73
    return math.clamp(p18, 0, 1) * 2 + 0;
end;

local function volumeToPercent(p19) -- Line: 77
    return math.clamp((p19 - 0) / 2, 0, 1);
end;

local function snapPercent(p20) -- Line: 81
    return math.round(p20 / 0.05) * 0.05;
end;

local function setBar(p21) -- Line: 85
    -- upvalues: u9 (ref)
    if u9 then
        u9.Size = UDim2.new(p21, 0, 1, 0);
    end;
end;

local function setVolumeValue(p22) -- Line: 91
    -- upvalues: u13 (ref), u9 (ref)
    u13 = math.clamp(p22, 0, 2);
    local v23 = math.clamp((u13 - 0) / 2, 0, 1);

    if u9 then
        u9.Size = UDim2.new(v23, 0, 1, 0);
    end;
end;

local function setCharCount(p24) -- Line: 96
    -- upvalues: u6 (ref)
    if u6 then
        u6.Text = `{p24}/{100}`;
    end;
end;

local function commit(p25) -- Line: 103
    -- upvalues: u12 (ref), u5 (ref), Networking (copy), u13 (ref)
    if not (u12 and u5) then
        return;
    end;

    local Text = u5.Text;

    if #Text > 100 then
        Text = string.sub(Text, 1, 100);
    end;

    Networking.Boombox.SetConfig:Fire(u12, Text, u13, p25 == true);
end;

local function closeMenu() -- Line: 112
    -- upvalues: u14 (ref), GuiController (copy)
    if not u14 then
        return;
    end;

    GuiController:Close();
end;

local function rollDice() -- Line: 119
    -- upvalues: u15 (ref), BoomboxFlags (copy), u5 (ref), u12 (ref), Networking (copy), u13 (ref)
    local v26 = os.clock();

    if v26 - u15 < BoomboxFlags.SoundChangeCooldown:Get() then
        return;
    end;

    u15 = v26;

    if u5 then
        u5.Text = BoomboxFlags.RandomSound();
    end;

    if u12 then
        if not u5 then
            return;
        end;

        local Text = u5.Text;

        if #Text > 100 then
            Text = string.sub(Text, 1, 100);
        end;

        Networking.Boombox.SetConfig:Fire(u12, Text, u13, true);
    end;
end;

local function setupSlider() -- Line: 129
    -- upvalues: u10 (ref), u11 (ref), u2 (copy), u9 (ref), u13 (ref), u12 (ref), u5 (ref), Networking (copy), UserInputService (copy)
    if not (u10 and u11) then
        return;
    end;

    local u27 = u10;
    local v28 = u11;
    local u29 = -1;

    local function getPercent() -- Line: 136
        -- upvalues: u2 (ref), u27 (copy)
        local v30 = (u2.X - u27.AbsolutePosition.X) / math.max(u27.AbsoluteSize.X, 1);
        local v31 = math.clamp(v30, 0, 1) / 0.05;

        return math.round(v31) * 0.05;
    end;

    local function updateSlider() -- Line: 142
        -- upvalues: u2 (ref), u27 (copy), u9 (ref), u29 (ref), u13 (ref)
        local v32 = (u2.X - u27.AbsolutePosition.X) / math.max(u27.AbsoluteSize.X, 1);
        local v33 = math.clamp(v32, 0, 1) / 0.05;
        local v34 = math.round(v33) * 0.05;

        if u9 then
            u9.Size = UDim2.new(v34, 0, 1, 0);
        end;

        if v34 ~= u29 then
            u29 = v34;
            u13 = math.clamp(v34, 0, 1) * 2 + 0;
        end;
    end;

    local u35 = false;

    local function startDragLoop() -- Line: 152
        -- upvalues: u35 (ref), u2 (ref), u27 (copy), u9 (ref), u29 (ref), u13 (ref)
        while u35 do
            local v36 = (u2.X - u27.AbsolutePosition.X) / math.max(u27.AbsoluteSize.X, 1);
            local v37 = math.clamp(v36, 0, 1) / 0.05;
            local v38 = math.round(v37) * 0.05;

            if u9 then
                u9.Size = UDim2.new(v38, 0, 1, 0);
            end;

            if v38 ~= u29 then
                u29 = v38;
                u13 = math.clamp(v38, 0, 1) * 2 + 0;
            end;

            task.wait(0.01);
        end;
    end;

    local function endDrag() -- Line: 161
        -- upvalues: u35 (ref), u12 (ref), u5 (ref), Networking (ref), u13 (ref)
        if not u35 then
            return;
        end;

        u35 = false;

        if u12 then
            if not u5 then
                return;
            end;

            local Text = u5.Text;

            if #Text > 100 then
                Text = string.sub(Text, 1, 100);
            end;

            Networking.Boombox.SetConfig:Fire(u12, Text, u13, false);
        end;
    end;

    v28.InputBegan:Connect(function(p39) -- Line: 167
        -- upvalues: u35 (ref), u2 (ref), u27 (copy), u9 (ref), u29 (ref), u13 (ref)
        if p39.UserInputType == Enum.UserInputType.MouseButton1 or p39.UserInputType == Enum.UserInputType.Touch then
            if u35 then
                return;
            end;

            u35 = true;

            while u35 do
                local v40 = (u2.X - u27.AbsolutePosition.X) / math.max(u27.AbsoluteSize.X, 1);
                local v41 = math.clamp(v40, 0, 1) / 0.05;
                local v42 = math.round(v41) * 0.05;

                if u9 then
                    u9.Size = UDim2.new(v42, 0, 1, 0);
                end;

                if v42 ~= u29 then
                    u29 = v42;
                    u13 = math.clamp(v42, 0, 1) * 2 + 0;
                end;

                task.wait(0.01);
            end;
        end;
    end);
    v28.InputEnded:Connect(function(p43) -- Line: 176
        -- upvalues: u35 (ref), u12 (ref), u5 (ref), Networking (ref), u13 (ref)
        if p43.UserInputType == Enum.UserInputType.MouseButton1 or p43.UserInputType == Enum.UserInputType.Touch then
            if not u35 then
                return;
            end;

            u35 = false;

            if u12 then
                if not u5 then
                    return;
                end;

                local Text = u5.Text;

                if #Text > 100 then
                    Text = string.sub(Text, 1, 100);
                end;

                Networking.Boombox.SetConfig:Fire(u12, Text, u13, false);
            end;
        end;
    end);
    UserInputService.InputEnded:Connect(function(p44) -- Line: 183
        -- upvalues: u35 (ref), u12 (ref), u5 (ref), Networking (ref), u13 (ref)
        if p44.UserInputType == Enum.UserInputType.MouseButton1 or p44.UserInputType == Enum.UserInputType.Touch then
            if not u35 then
                return;
            end;

            u35 = false;

            if u12 then
                if not u5 then
                    return;
                end;

                local Text = u5.Text;

                if #Text > 100 then
                    Text = string.sub(Text, 1, 100);
                end;

                Networking.Boombox.SetConfig:Fire(u12, Text, u13, false);
            end;
        end;
    end);
end;

function u1.OpenFor(p45, p46, p47) -- Line: 196
    -- upvalues: u14 (ref), u4 (ref), u5 (ref), u12 (ref), u1 (copy), u6 (ref), u13 (ref), u9 (ref), GuiController (copy)
    if u14 then
        return false;
    end;

    if not (u4 and u5) then
        return false;
    end;

    u12 = p46;
    local v48 = u1.ParseConfig(p47);
    local v49 = string.match(v48.soundId, "%d+") or "";
    u5.Text = v49;
    local v50 = #v49;

    if u6 then
        u6.Text = `{v50}/{100}`;
    end;

    u13 = math.clamp(v48.volume, 0, 2);
    local v51 = math.clamp((u13 - 0) / 2, 0, 1);

    if u9 then
        u9.Size = UDim2.new(v51, 0, 1, 0);
    end;

    u14 = true;
    GuiController:Open("BoomboxConfigMenu");

    return true;
end;

function u1.Init(p52) -- Line: 217
end;

function u1.Start(p53) -- Line: 220
    -- upvalues: u3 (ref), PlayerGui (copy), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u10 (ref), u9 (ref), u11 (ref), u12 (ref), Networking (copy), u13 (ref), u14 (ref), GuiController (copy), rollDice (copy), setupSlider (copy)
    u3 = PlayerGui:WaitForChild("BoomboxConfigMenu", 30);

    if not u3 then
        warn("[Boombox] BoomboxConfigMenu ScreenGui never replicated; editor disabled");

        return;
    end;

    u3.Enabled = false;
    u4 = u3:FindFirstChild("EditFrame");

    if not u4 then
        warn("[Boombox] BoomboxConfigMenu has no EditFrame; menu disabled");

        return;
    end;

    u5 = u4:FindFirstChild("Input", true);
    u6 = u4:FindFirstChild("CharCount", true);
    u7 = u4:FindFirstChild("DiceButton", true);
    u8 = u4:FindFirstChild("ExitButton", true);
    u10 = u4:FindFirstChild("Slider", true);

    if u10 then
        u9 = u10:FindFirstChild("Bar");
        u11 = u10:FindFirstChild("Notch");
    end;

    if u5 then
        u5.ClearTextOnFocus = false;
        u5:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 247
            -- upvalues: u5 (ref), u6 (ref)
            local Text = u5.Text;

            if #Text > 100 then
                u5.Text = string.sub(Text, 1, 100);

                return;
            end;

            local v54 = #Text;

            if u6 then
                u6.Text = `{v54}/{100}`;
            end;
        end);
        u5.FocusLost:Connect(function(p55) -- Line: 255
            -- upvalues: u12 (ref), u5 (ref), Networking (ref), u13 (ref), u14 (ref), GuiController (ref)
            if u12 and u5 then
                local Text = u5.Text;

                if #Text > 100 then
                    Text = string.sub(Text, 1, 100);
                end;

                Networking.Boombox.SetConfig:Fire(u12, Text, u13, false);
            end;

            if p55 then
                if not u14 then
                    return;
                end;

                GuiController:Close();
            end;
        end);
    end;

    if u7 then
        u7.MouseButton1Click:Connect(rollDice);
    end;

    if u8 then
        u8.MouseButton1Click:Connect(function() -- Line: 268
            -- upvalues: u12 (ref), u5 (ref), Networking (ref), u13 (ref), u14 (ref), GuiController (ref)
            if u12 and u5 then
                local Text = u5.Text;

                if #Text > 100 then
                    Text = string.sub(Text, 1, 100);
                end;

                Networking.Boombox.SetConfig:Fire(u12, Text, u13, false);
            end;

            if not u14 then
                return;
            end;

            GuiController:Close();
        end);
    end;

    setupSlider();
    GuiController.GuiUnfocusedSignal:Connect(function(p56) -- Line: 276
        -- upvalues: u3 (ref), u14 (ref), u12 (ref)
        if p56 ~= u3 then
            return;
        end;

        u14 = false;
        u12 = nil;
    end);
end;

return u1;