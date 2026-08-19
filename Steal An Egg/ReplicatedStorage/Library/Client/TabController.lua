-- Decompiled with Potassium's decompiler.

local GuiService = game:GetService("GuiService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local StarterGui = game:GetService("StarterGui");
local Lighting = game:GetService("Lighting");
local Workspace = game:GetService("Workspace");
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local ConsoleCmds = require(ReplicatedStorage.Library.Client.ConsoleCmds);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local InfoOverlay = require(ReplicatedStorage.Library.Client.InfoOverlay);
local Lock = require(ReplicatedStorage.Library.Functions.Lock);
local SearchArray = require(ReplicatedStorage.Library.Functions.SearchArray);
local Tween = require(ReplicatedStorage.Library.Functions.Tween);
local Event = require(ReplicatedStorage.Library.Modules.Event);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Player = require(ReplicatedStorage.Library.Player);
local Variables = require(ReplicatedStorage.Library.Variables);
local u1 = table.freeze({ "Message", "BuyMultiple" });
local v2 = Log.new();
local u3 = nil;
local u4 = {};
local u5 = Player.Camera();
local FieldOfView = u5.FieldOfView;
local DepthOfFieldEffect = Instance.new("DepthOfFieldEffect");
DepthOfFieldEffect.FarIntensity = 0.755;
DepthOfFieldEffect.FocusDistance = 200;
DepthOfFieldEffect.InFocusRadius = 13.25;
DepthOfFieldEffect.NearIntensity = 0;
DepthOfFieldEffect.Name = "TabControllerDepthBlur";
DepthOfFieldEffect.Enabled = false;
DepthOfFieldEffect.Parent = Lighting;
local u6 = {};
local u7 = nil;
local u8 = nil;
local u9 = false;
local u10 = nil;
local u11 = {};
local u12 = {};
local u13 = Lock();
local u14 = {
    Opened = Event.new(),
    Closed = Event.new()
};

local function isLockedAgainstTransition(p15) -- Line: 65
    -- upvalues: u10 (ref), u7 (ref)
    local v16;

    if u10 == nil or u7 ~= u10 then
        v16 = false;
    else
        v16 = p15 ~= u10;
    end;

    return v16;
end;

local function ToggleCoreUI(p17) -- Line: 69
    -- upvalues: StarterGui (copy)
    if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList) ~= p17 then
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, p17);
    end;
end;

local function doMobile(p18) -- Line: 75
    -- upvalues: u3 (ref), Variables (copy)
    if u3 then
        u3();
        u3 = nil;

        if p18 then
            return;
        end;
    end;

    u3 = Variables.Locks.DisableTouchControls:ObtainLock();
end;

local function closeTab(p19, u20, u21) -- Line: 87
    -- upvalues: u14 (copy), u9 (ref), GuiService (copy), u7 (ref), GUI (copy), u6 (copy), Variables (copy), u3 (ref), u12 (copy), Workspace (copy), StarterGui (copy), u4 (copy), DepthOfFieldEffect (copy), Tween (copy), u5 (copy), FieldOfView (copy), InfoOverlay (copy)
    if not u14.IsOpen() then
        u9 = false;

        return;
    end;

    u9 = true;

    if u20 == nil then
        if GuiService.SelectedObject then
            GuiService.SelectedObject = nil;
        end;

        if GuiService.GuiNavigationEnabled then
            GuiService.GuiNavigationEnabled = false;
        end;
    end;

    local u22;

    if u7 == nil then
        u22 = nil;
    else
        local v23 = GUI.Get(u7);
        local v24 = v23:IsA("ScreenGui");
        local v25 = `Tab {u7} must be a ScreenGui`;
        assert(v24, v25);

        if u6[v23] then
            u22 = u6[v23];
        else
            u6[v23] = {
                isOpen = false,
                initializedClose = false,
                ui = v23
            };
            u22 = u6[v23];
        end;
    end;

    if u22 then
        if Variables.Mobile then
            if u3 then
                u3();
                u3 = nil;
            else
                u3 = Variables.Locks.DisableTouchControls:ObtainLock();
            end;
        end;

        local v26 = u22.ui:FindFirstChildOfClass("Frame") or u22.ui:FindFirstChildWhichIsA("ImageLabel");
        assert(v26, "Expected uiFrame to exist in TabController.");
        local v27 = v26:FindFirstChildOfClass("UIScale");

        if not v27 then
            v27 = Instance.new("UIScale");
            assert(v27, "Failed to create UIScale in TabController.");
            v27.Name = "TabControllerUIScale";
            v27.Parent = v26;
        end;

        local function close() -- Line: 139
            -- upvalues: u22 (ref), u12 (ref), u7 (ref), u20 (copy), u21 (copy), Variables (ref), Workspace (ref), StarterGui (ref), u14 (ref), u4 (ref)
            u22.isOpen = false;

            for _, v in u12 do
                task.spawn(function() -- Line: 143
                    -- upvalues: v (copy), u7 (ref), u20 (ref), u21 (ref)
                    v(u7, u20, u21 == true);
                end);
            end;

            local v28 = u7;

            if Variables.Mobile and (Workspace.CurrentCamera.ViewportSize.Y > 550 and StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList) ~= true) then
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true);
            end;

            u7 = nil;
            u14.Closed:FireAsync(v28, u20, u21 == true);

            for _, v in ipairs(u4) do
                v.Enabled = true;
            end;
        end;

        if p19 then
            if u21 then
                DepthOfFieldEffect.Enabled = false;
            end;

            u22.ui.Enabled = false;
            close();
        else
            local v29 = Tween(v26, {
                Position = UDim2.new(0.5, 0, 0.6, v26.Position.Y.Offset)
            }, { 0.045, "Linear", "Out" });
            Tween(assert(v27, "Expected close tween UIScale to exist"), {
                Scale = 0.85
            }, { 0.045, "Linear", "Out" });
            Tween(u5, {
                FieldOfView = FieldOfView
            }, { 0.2, "Sine", "Out" });
            Tween(DepthOfFieldEffect, {
                FocusDistance = 200
            }, { 0.2, "Sine", "Out" }).Completed:Connect(function() -- Line: 184
                -- upvalues: DepthOfFieldEffect (ref)
                DepthOfFieldEffect.Enabled = false;
            end);
            v29.Completed:Wait();
            u22.ui.Enabled = false;
            close();
        end;

        InfoOverlay.Remove();
    end;
end;

local function openTab(u30, u31, p32) -- Line: 197
    -- upvalues: u7 (ref), closeTab (copy), GUI (copy), u6 (copy), u4 (copy), Variables (copy), u3 (ref), ConsoleCmds (copy), u14 (copy), ButtonFX (copy), Tween (copy), DepthOfFieldEffect (copy), SearchArray (copy), u1 (copy), u5 (copy), Workspace (copy), StarterGui (copy), u8 (ref), u11 (copy)
    if u7 == u30 then
        return;
    end;

    if u7 ~= nil then
        closeTab(true, u30, false);
    end;

    local v33 = GUI.Get(u30);
    local v34 = v33:IsA("ScreenGui");
    local v35 = `Tab {u30} must be a ScreenGui`;
    assert(v34, v35);
    local v36;

    if u6[v33] then
        v36 = u6[v33];
    else
        v36 = {
            isOpen = false,
            initializedClose = false,
            ui = v33
        };
        u6[v33] = v36;
    end;

    if v36 then
        v36.ui.Enabled = true;
        v36.isOpen = true;

        for _, v in ipairs(u4) do
            v.Enabled = false;
        end;

        if Variables.Mobile then
            if u3 then
                u3();
                u3 = nil;
            end;

            u3 = Variables.Locks.DisableTouchControls:ObtainLock();
        end;

        Variables.HideProgressUI = true;
        local v37 = v36.ui:FindFirstChildOfClass("Frame") or v36.ui:FindFirstChildWhichIsA("ImageLabel");
        assert(v37, "Expected uiFrame to exist in TabController for opening a tab.");
        local v38 = v37:FindFirstChildOfClass("UIScale");

        if not v38 then
            v38 = Instance.new("UIScale");
            assert(v38, "Failed to create UIScale in TabController during openTab.");
            v38.Name = "TabControllerUIScale";
            v38.Parent = v37;
        end;

        assert(v38, "Expected uiScale to exist in TabController during openTab.");

        if not v36.initializedClose and v37 then
            local v39 = v37:FindFirstChildWhichIsA("Frame");
            local Close = v37:FindFirstChild("Close");

            if Close then
                v39 = Close;
            elseif v39 then
                v39 = v39:FindFirstChild("Close");
            end;

            if v39 then
                local v40 = v39:IsA("GuiButton");
                assert(v40, "Expected closeButton to be a GuiButton in TabController.");
                ConsoleCmds.ConfigureCloseButton(v39);
                GUI.ButtonActivated(v39, function() -- Line: 255
                    -- upvalues: u14 (ref)
                    u14.CloseTab(true);
                end);
                ButtonFX(v39);
            end;

            v36.initializedClose = true;
        end;

        local v41;

        if u7 == "Ultimates" then
            v41 = u30 == "Inventory";
        else
            v41 = false;
        end;

        if not v41 then
            if u7 == nil and v37 then
                v38.Scale = 0.975;
                v37.Position = UDim2.new(0.5, 0, 0.6, v37.Position.Y.Offset);
                Tween(v37, {
                    Position = UDim2.fromScale(0.5, 0.5)
                }, { 0.1, Enum.EasingStyle.Circular, "Out" });
                Tween(v38, {
                    Scale = 1
                }, { 0.15, Enum.EasingStyle.Circular, "Out" });
                DepthOfFieldEffect.FocusDistance = 200;
                DepthOfFieldEffect.Enabled = true;
                Tween(DepthOfFieldEffect, {
                    FocusDistance = 5
                }, { 0.2, Enum.EasingStyle.Circular, "Out" });

                if not SearchArray(u1, u30) then
                    Tween(u5, {
                        FieldOfView = 76
                    }, { 0.325, Enum.EasingStyle.Circular, "Out" });
                end;
            elseif u7 ~= nil and v37 then
                v38.Scale = 1;
                v37.Position = UDim2.new(0.5, 0, 0.525, v37.Position.Y.Offset);
                Tween(v37, {
                    Position = UDim2.fromScale(0.5, 0.5)
                }, { 0.1, "Sine", "Out" });
            end;
        end;

        if Variables.Mobile and (Workspace.CurrentCamera.ViewportSize.Y > 550 and StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList) ~= false) then
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
        end;

        u7 = u30;

        if p32 then
            u8 = nil;
        else
            u8 = u30;
        end;

        for _, v in ipairs(u11) do
            task.spawn(function() -- Line: 320
                -- upvalues: v (copy), u30 (copy), u31 (copy)
                v(u30, u31 == true);
            end);
        end;

        u14.Opened:FireAsync(u30, u31 == true);
    end;
end;

function u14.AddOpenListener(p42) -- Line: 333
    -- upvalues: u11 (copy)
    table.insert(u11, p42);
end;

function u14.AddCloseListener(p43) -- Line: 337
    -- upvalues: u12 (copy)
    table.insert(u12, p43);
end;

function u14.IsOpen(p44) -- Line: 341
    -- upvalues: u7 (ref), GUI (copy), u6 (copy)
    if p44 == nil then
        return u7 ~= nil;
    end;

    local v45 = GUI.Get(p44);
    local v46 = v45:IsA("ScreenGui");
    local v47 = `Tab {p44} must be a ScreenGui`;
    assert(v46, v47);
    local v48;

    if u6[v45] then
        v48 = u6[v45];
    else
        v48 = {
            isOpen = false,
            initializedClose = false,
            ui = v45
        };
        u6[v45] = v48;
    end;

    return v48.isOpen;
end;

function u14.IsClosed(p49) -- Line: 363
    -- upvalues: u14 (copy)
    return not u14.IsOpen(p49);
end;

function u14.Get() -- Line: 367
    -- upvalues: u7 (ref)
    return u7;
end;

function u14.SetLockedTab(p50) -- Line: 371
    -- upvalues: u10 (ref)
    u10 = p50;
end;

function u14.OpenTab(u51, u52, u53, u54) -- Line: 375
    -- upvalues: u13 (copy), u10 (ref), u7 (ref), openTab (copy)
    local u55 = false;
    u13(function() -- Line: 377
        -- upvalues: u54 (copy), u51 (copy), u10 (ref), u7 (ref), u55 (ref), openTab (ref), u52 (copy), u53 (copy)
        if not u54 then
            local v56 = u51;
            local v57;

            if u10 == nil or u7 ~= u10 then
                v57 = false;
            else
                v57 = v56 ~= u10;
            end;

            if v57 then
                return;
            end;
        end;

        u55 = true;
        openTab(u51, u52, u53);
    end);

    return u55;
end;

function u14.CloseTab(u58) -- Line: 388
    -- upvalues: u13 (copy), u10 (ref), u7 (ref), u9 (ref), closeTab (copy)
    u13(function() -- Line: 389
        -- upvalues: u10 (ref), u7 (ref), u9 (ref), closeTab (ref), u58 (copy)
        local v59;

        if u10 == nil or u7 ~= u10 then
            v59 = false;
        else
            v59 = u10 ~= nil;
        end;

        if v59 then
            u9 = false;

            return;
        end;

        if u7 then
            closeTab(nil, nil, u58 == true);

            return;
        end;

        u9 = false;
    end);
end;

function u14.ToggleTab(p60) -- Line: 403
    -- upvalues: u7 (ref), u14 (copy)
    if u7 == p60 then
        u14.CloseTab();

        return;
    end;

    u14.OpenTab(p60);
end;

function u14.Restore() -- Line: 411
    -- upvalues: u14 (copy), u8 (ref), u9 (ref)
    if not u14.IsOpen() and (u8 and u9) then
        u14.OpenTab(u8, true);
    end;
end;

task.spawn(function() -- Line: 423
    -- upvalues: Variables (copy), u14 (copy), u3 (ref)
    if Variables.Mobile then
        local v61 = u14.Get() == nil;

        if u3 then
            u3();
            u3 = nil;

            if v61 then
                return;
            end;
        end;

        u3 = Variables.Locks.DisableTouchControls:ObtainLock();
    end;
end);
v2:AtInfo():Log("Tab controller initialized");

return u14;