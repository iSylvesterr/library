-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Tween = require(ReplicatedStorage.Library.Functions.Tween);
local InteractSound = require(script.Parent.InteractSound);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Signal = require(ReplicatedStorage.Library.Signal);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Variables = require(ReplicatedStorage.Library.Variables);
local BUTTON_MOUSE_DOWN_SOUND = Constants.BUTTON_FX.BUTTON_MOUSE_DOWN_SOUND;
local BUTTON_CLOSE_SOUND = Constants.BUTTON_FX.BUTTON_CLOSE_SOUND;
local u1 = {};
Log.new():AtInfo():Log("Button effects initialized");

local function emptyCleanup() -- Line: 39
end;

return function(u2, p3, u4, p5) -- Line: 46
    -- upvalues: Asserts (copy), u1 (copy), emptyCleanup (copy), Trove (copy), BUTTON_CLOSE_SOUND (copy), Tween (copy), Signal (copy), Variables (copy), InteractSound (copy), BUTTON_MOUSE_DOWN_SOUND (copy)
    Asserts.GuiButton(u2);
    Asserts.optional.number(p3);
    Asserts.optional.func(u4);
    local u6 = false;
    local u7 = false;
    local u8 = p3 or 1.2;
    local v9 = p5 or u2:GetAttribute("MuteSounds") == true;

    if u1[u2] then
        return emptyCleanup;
    end;

    u1[u2] = true;
    local u10 = Trove.new();
    local v11 = u2:IsA("ImageButton") and u2.Image == BUTTON_CLOSE_SOUND;
    local u12 = nil;

    if v11 then
        for _, child in u2:GetChildren() do
            if child:IsA("TextLabel") and child.Text == "X" then
                u12 = child;
                break;
            end;
        end;
    end;

    local u13;

    if u12 then
        if u12:FindFirstChildOfClass("UIScale") then
            u13 = u12:FindFirstChildOfClass("UIScale");
        else
            u13 = Instance.new("UIScale");
            u13.Name = "ButtonUIScale";
            u13.Parent = u12;
        end;
    else
        u13 = nil;
    end;

    local u14 = u2:FindFirstChildOfClass("UIScale");

    if not u14 then
        u14 = Instance.new("UIScale");
        u14.Name = "ButtonUIScale";
        u14.Parent = u2;
    end;

    u14:SetAttribute("ButtonFXOwned", true);

    local function handlePress() -- Line: 104
        -- upvalues: u6 (ref), u7 (ref), Tween (ref), u14 (ref), u13 (ref), u12 (ref)
        if not u6 then
            u6 = true;
            u7 = false;
            Tween(u14, {
                Scale = 0.9
            }, { 0.065, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out });

            if u13 and u12 then
                Tween(u13, {
                    Scale = 0.9
                }, { 0.065, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out });
                Tween(u12, {
                    Position = UDim2.fromScale(0.5, 0.6)
                }, { 0.065, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out });
            end;
        end;
    end;

    local function handleRelease() -- Line: 130
        -- upvalues: u6 (ref), Tween (ref), u14 (ref), u13 (ref), u12 (ref)
        if u6 then
            u6 = false;
            Tween(u14, {
                Scale = 1
            }, { 0.25, Enum.EasingStyle.Circular, Enum.EasingDirection.Out });

            if u13 and u12 then
                Tween(u13, {
                    Scale = 1
                }, { 0.25, Enum.EasingStyle.Circular, Enum.EasingDirection.Out });
                Tween(u12, {
                    Position = UDim2.fromScale(0.5, 0.5)
                }, { 0.25, Enum.EasingStyle.Circular, Enum.EasingDirection.Out });
            end;
        end;
    end;

    local function handleUnhover() -- Line: 155
        -- upvalues: u7 (ref), u6 (ref), u13 (ref), u12 (ref), Tween (ref), u14 (ref)
        if u7 then
            u7 = false;

            if u6 then
                if u13 and u12 then
                    Tween(u12, {
                        Position = UDim2.fromScale(0.5, 0.5)
                    }, { 0.7, Enum.EasingStyle.Circular, Enum.EasingDirection.Out });
                end;
            else
                Tween(u14, {
                    Scale = 1
                }, { 0.7, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out });

                if u13 then
                    Tween(u13, {
                        Scale = 1
                    }, { 0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out });
                end;
            end;
        end;
    end;

    local function handleHover() -- Line: 185
        -- upvalues: u7 (ref), u6 (ref), Tween (ref), u14 (ref), u8 (copy), u13 (ref)
        if not u7 then
            u7 = true;

            if not u6 then
                Tween(u14, {
                    Scale = u8
                }, { 0.7, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out });

                if u13 then
                    Tween(u13, {
                        Scale = u8
                    }, { 0.7, Enum.EasingStyle.Circular, Enum.EasingDirection.Out });
                end;
            end;
        end;
    end;

    if u4 then
        u10:Add(u2.Activated:Connect(u4));
        u10:Add(Signal.Fired("Console: Released Button"):Connect(function(p15) -- Line: 211
            -- upvalues: u2 (copy), u4 (copy)
            if p15 == u2 then
                u4();
            end;
        end));
    end;

    u10:Add(u2.InputBegan:Connect(function(p16) -- Line: 218
        -- upvalues: u2 (copy), handlePress (copy)
        if not u2.Active then
            return;
        end;

        if p16.UserInputType == Enum.UserInputType.MouseButton1 or p16.UserInputType == Enum.UserInputType.Touch and p16.UserInputState == Enum.UserInputState.Begin or p16.KeyCode == Enum.KeyCode.ButtonA then
            handlePress();
        end;
    end));
    u10:Add(u2.InputEnded:Connect(function(p17) -- Line: 232
        -- upvalues: u2 (copy), handleRelease (copy)
        if not u2.Active then
            return;
        end;

        if p17.UserInputType == Enum.UserInputType.MouseButton1 or (p17.UserInputType == Enum.UserInputType.Touch or p17.KeyCode == Enum.KeyCode.ButtonA) then
            handleRelease();
        end;
    end));
    u10:Add(u2.MouseEnter:Connect(function() -- Line: 246
        -- upvalues: u2 (copy), Variables (ref), handleHover (copy)
        if not u2.Active then
            return;
        end;

        if Variables.Desktop then
            handleHover();
        end;
    end));
    u10:Add(u2.MouseLeave:Connect(function() -- Line: 256
        -- upvalues: u2 (copy), Variables (ref), handleUnhover (copy)
        if not u2.Active then
            return;
        end;

        if Variables.Desktop then
            handleUnhover();
        end;
    end));
    local v18;

    if v9 then
        v18 = nil;
    else
        v18 = InteractSound(u2, "mousedown", BUTTON_MOUSE_DOWN_SOUND, 1.8, true);
    end;

    if v18 ~= nil then
        u10:Add(v18);
    end;

    local u19 = false;

    local function cleanup() -- Line: 279
        -- upvalues: u19 (ref), u10 (copy), u14 (ref), u13 (ref), u12 (ref), u1 (ref), u2 (copy)
        if u19 then
            return;
        end;

        u19 = true;
        u10:Destroy();

        if u14 and u14.Parent then
            u14.Scale = 1;
        end;

        if u13 and u12 then
            u12.Position = UDim2.fromScale(0.5, 0.5);
            u13.Scale = 1;
        end;

        u1[u2] = nil;
    end;

    u10:Add(u2.Destroying:Connect(cleanup));

    return cleanup;
end;