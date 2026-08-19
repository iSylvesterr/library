-- Decompiled with Potassium's decompiler.

local GamepadService = game:GetService("GamepadService");
local GuiService = game:GetService("GuiService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local Library = ReplicatedStorage:WaitForChild("Library");
local Client = Library:WaitForChild("Client");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local CircularBar = require(Client.GUIFX.CircularBar);
local Functions = require(Library.Functions);
local Audio = require(Library.Audio);
local Variables = require(Library.Variables);
local u1 = game.Players.LocalPlayer:GetMouse();
local ImageColor3 = Assets.UI.Items.Dial.Left.ImageColor3;
local u2 = { 0.15, "Expo", "Out" };
local u3 = { 0.2, "Expo", "Out" };

local function cloneDial() -- Line: 42
    -- upvalues: Assets (copy)
    return Assets.UI.Items.Dial:Clone();
end;

local function getScrollingFrame(p4) -- Line: 46
    return p4:FindFirstAncestorOfClass("ScrollingFrame");
end;

local function setScrollingEnabledIfNeeded(p5, p6) -- Line: 50
    -- upvalues: Variables (copy)
    if not Variables.Mobile then
        return;
    end;

    local v7 = p5:FindFirstAncestorOfClass("ScrollingFrame");

    if v7 then
        v7.ScrollingEnabled = p6;
    end;
end;

return function(u8, u9, p10) -- Line: 61, Name: CreateDial
    -- upvalues: Assets (copy), Variables (copy), ImageColor3 (copy), Audio (copy), GamepadService (copy), Functions (copy), u2 (copy), u1 (copy), UserInputService (copy), RunService (copy), GuiService (copy), u3 (copy), CircularBar (copy)
    local u11 = Assets.UI.Items.Dial:Clone();
    u11.Parent = u8;
    local u12 = false;
    local u13 = false;
    local u14 = false;
    local u15 = {};
    local u16 = 1;
    local u17 = u9;
    local u18 = nil;
    local u19 = p10 or 1;

    local function destroyDial() -- Line: 78
        -- upvalues: u15 (copy), u11 (copy), u12 (ref), u8 (copy), Variables (ref)
        for _, v in ipairs(u15) do
            v:Disconnect();
        end;

        u11:Destroy();
        u12 = false;

        if not Variables.Mobile then
            return;
        end;

        local v20 = u8:FindFirstAncestorOfClass("ScrollingFrame");

        if v20 then
            v20.ScrollingEnabled = true;
        end;
    end;

    local function updateDial() -- Line: 88
        -- upvalues: u11 (copy), u19 (copy), u17 (ref), ImageColor3 (ref), u9 (copy), u18 (ref), Audio (ref), u16 (ref)
        if u11:GetAttribute("IsLocked") then
            return;
        end;

        local v21 = u19 > 1;
        local v22;

        if v21 then
            v22 = u17 % u19 == 0 and true or u17 > 100;
        else
            v22 = v21;
        end;

        local v23 = u19 <= u17;
        u11.Quantity.Text = tostring(u17);

        if v21 then
            u11.Quantity.TextColor3 = u17 > 0 and (v22 and Color3.new(1, 1, 1) or Color3.fromRGB(181, 181, 181)) or Color3.fromRGB(255, 205, 205);
        else
            u11.Quantity.TextColor3 = u17 > 0 and Color3.new(1, 1, 1) or Color3.fromRGB(255, 205, 205);
        end;

        if v21 then
            u11.Left.ImageColor3 = v22 and ImageColor3 or (v23 and Color3.fromRGB(255, 233, 65) or Color3.fromRGB(85, 85, 85));
            u11.Right.ImageColor3 = v22 and ImageColor3 or (v23 and Color3.fromRGB(255, 233, 65) or Color3.fromRGB(85, 85, 85));
        end;

        u11:SetAttribute("Progress", (math.clamp(u17 / u9, 0.001, 0.999)));
        u11:SetAttribute("Quantity", u17);

        if u18 ~= u17 then
            u18 = u17;
            Audio.Play("rbxassetid://96979035335854", script, u16 + 1, 0.1);
        end;
    end;

    local function startTracking(u24) -- Line: 130
        -- upvalues: u11 (copy), u12 (ref), Variables (ref), GamepadService (ref), u8 (copy), Functions (ref), u2 (ref), u1 (ref), UserInputService (ref), u9 (copy), u17 (ref), u19 (copy), u16 (ref), updateDial (copy), RunService (ref), GuiService (ref)
        if u11:GetAttribute("IsLocked") then
            return;
        end;

        if u12 then
            return;
        end;

        Variables.DisableInfoOverlay = true;
        u12 = true;
        u11:SetAttribute("Tracking", true);

        if Variables.Console then
            GamepadService:EnableGamepadCursor(u8);
            local v25 = u8:FindFirstAncestorOfClass("ScrollingFrame");

            if v25 then
                v25.ScrollingEnabled = false;
            end;
        end;

        local v26 = Variables.Mobile and u8:FindFirstAncestorOfClass("ScrollingFrame");

        if v26 then
            v26.ScrollingEnabled = false;
        end;

        Functions.Tween(u11, {
            Size = UDim2.fromScale(0.75, 1)
        }, u2);
        Functions.Tween(u11.Deadzone, {
            BackgroundTransparency = 0
        }, u2);
        Functions.Tween(u11.Deadzone.zero, {
            TextTransparency = 0
        }, u2);
        local u27 = 0;
        task.spawn(function() -- Line: 166
            -- upvalues: u12 (ref), u11 (ref), u1 (ref), u27 (ref), UserInputService (ref), u24 (ref), u9 (ref), u17 (ref), u19 (ref), u16 (ref), updateDial (ref), RunService (ref), Variables (ref), GamepadService (ref), u8 (ref), GuiService (ref)
            while u12 do
                local v28 = u11.AbsolutePosition + u11.AbsoluteSize / 2;
                local v29 = Vector2.new(u1.X, u1.Y) - v28;
                local v30 = math.atan2(v29.Y, v29.X);
                local v31 = (math.deg(v30) + 90) % 360;
                local v32 = ((v31 <= 6 or v31 >= 354) and 0 or (v31 - 6) / 348 * 360) / 360;

                if (v32 >= 1 or v32 <= 0.25) and u27 > 0.75 then
                    v32 = 1;
                elseif (v32 <= 0 or v32 >= 0.75) and u27 < 0.25 then
                    v32 = 0;
                else
                    u27 = v32;
                end;

                local v33 = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift);
                local v34 = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl);

                if not v33 and u24 and v32 <= 0 then
                    v32 = 1;
                    u27 = 1;
                else
                    u24 = false;
                end;

                if u9 >= 100000 then
                    local v35 = math.floor(u9 * v32 / 100 + 0.5) * 100;
                    u17 = math.round(v35);
                elseif u9 >= 10000 then
                    local v36 = math.floor(u9 * v32 / 25 + 0.5) * 25;
                    u17 = math.round(v36);
                elseif u9 >= 1000 then
                    local v37 = math.floor(u9 * v32 / 5 + 0.5) * 5;
                    u17 = math.round(v37);
                else
                    u17 = math.round(u9 * v32);
                end;

                if u9 >= u19 * 5 then
                    local v38 = u17 % u19;

                    if u19 / 2 <= v38 then
                        u17 = u17 + u19 - v38;
                    else
                        u17 = u17 - v38;
                    end;
                end;

                u17 = math.clamp(u17, 0, u9);

                if v34 then
                    u17 = 1;
                end;

                u16 = v32;
                updateDial();
                RunService.RenderStepped:Wait();
            end;

            u11:SetAttribute("Tracking", false);

            if Variables.Console then
                GamepadService:DisableGamepadCursor();
                local v39 = u8:FindFirstAncestorOfClass("ScrollingFrame");

                if v39 then
                    v39.ScrollingEnabled = true;
                end;

                GuiService.SelectedObject = u8;

                if not GuiService.GuiNavigationEnabled then
                    GuiService.GuiNavigationEnabled = true;
                end;
            end;

            Variables.DisableInfoOverlay = false;
        end);
    end;

    local function stopTracking() -- Line: 246
        -- upvalues: u12 (ref), Variables (ref), u8 (copy), u17 (ref), destroyDial (copy), Functions (ref), u11 (copy), u3 (ref), u2 (ref)
        if not u12 then
            return;
        end;

        Variables.DisableInfoOverlay = false;
        local v40 = Variables.Mobile and u8:FindFirstAncestorOfClass("ScrollingFrame");

        if v40 then
            v40.ScrollingEnabled = true;
        end;

        u12 = false;

        if u17 == 0 then
            destroyDial();

            return;
        end;

        local v41 = Functions.Tween(u11, {
            Size = UDim2.fromScale(0.35, 1)
        }, u3);
        Functions.Tween(u11.Deadzone, {
            BackgroundTransparency = 1
        }, u3);
        Functions.Tween(u11.Deadzone.zero, {
            TextTransparency = 1
        }, u2);
        v41.Completed:Wait();
    end;

    local function initializeDial() -- Line: 272
        -- upvalues: u9 (copy), u19 (copy), startTracking (copy), u15 (copy), u8 (copy), Variables (ref), u13 (ref), UserInputService (ref), u14 (ref), stopTracking (copy), updateDial (copy)
        if u9 < u19 then
            return;
        end;

        startTracking(true);
        u15[#u15 + 1] = u8.MouseButton1Down:Connect(function() -- Line: 279
            -- upvalues: u8 (ref), Variables (ref), u13 (ref), startTracking (ref)
            local v42 = Variables.Mobile and u8:FindFirstAncestorOfClass("ScrollingFrame");

            if v42 then
                v42.ScrollingEnabled = false;
            end;

            if u13 then
                return;
            end;

            u13 = true;
            startTracking(false);
            u13 = false;
        end);
        u15[#u15 + 1] = UserInputService.InputEnded:Connect(function(p43, p44) -- Line: 291
            -- upvalues: u14 (ref), stopTracking (ref)
            local v45;

            if p43.UserInputType == Enum.UserInputType.Gamepad1 then
                v45 = p43.KeyCode == Enum.KeyCode.ButtonA;
            else
                v45 = false;
            end;

            if not u14 and (p43.UserInputType == Enum.UserInputType.MouseButton1 and true or p43.UserInputType == Enum.UserInputType.Touch or v45) then
                u14 = true;
                stopTracking();
                u14 = false;
            end;
        end);
        updateDial();
    end;

    local function setValue(p46) -- Line: 307
        -- upvalues: stopTracking (copy), u17 (ref), u9 (copy), updateDial (copy)
        stopTracking();
        u17 = math.clamp(p46, 0, u9);
        updateDial();
    end;

    u11:GetAttributeChangedSignal("IsLocked"):Connect(function() -- Line: 313
        -- upvalues: u11 (copy), stopTracking (copy)
        if u11:GetAttribute("IsLocked") then
            stopTracking();
        end;
    end);
    CircularBar(u11);
    initializeDial();

    return u11, destroyDial, setValue;
end;