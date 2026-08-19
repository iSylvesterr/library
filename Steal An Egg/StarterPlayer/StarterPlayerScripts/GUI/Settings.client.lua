-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Audio = require(ReplicatedStorage.Library.Audio);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local SettingsCmds = require(ReplicatedStorage.Library.Client.SettingsCmds);
require(ReplicatedStorage.Library.Client.SettingsCmds.Types.Interface);
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local TopBarPlus = require(ReplicatedStorage.Library.Modules.Packages.TopBarPlus);
local Variables = require(ReplicatedStorage.Library.Variables);
local u1 = Color3.fromRGB(255, 17, 0);
local u2 = Color3.fromRGB(0, 255, 8);
local u3 = TopBarPlus.new();
local ScrollingFrame = GUI.Settings().Frame.Frame.ScrollingFrame;
local v4 = ScrollingFrame:IsA("ScrollingFrame");
assert(v4, "Settings scrolling frame must be a ScrollingFrame");
local u5 = {};
local u6 = {};
local v7 = {};

local function registerConfiguredSettingRow(p8, p9, p10) -- Line: 42
    -- upvalues: ScrollingFrame (copy)
    local v11 = ScrollingFrame:FindFirstChild(p8);

    if v11 and v11:IsA("Frame") then
        return;
    end;

    local SFX = ScrollingFrame:FindFirstChild("SFX");

    if not (SFX and SFX:IsA("Frame")) then
        return;
    end;

    local v12 = SFX:Clone();
    v12.Name = p8;
    v12.LayoutOrder = p10;

    for _, descendant in ipairs(v12:GetDescendants()) do
        if descendant:IsA("TextLabel") and descendant.Name ~= "Status" then
            descendant.Text = p9;
            break;
        end;
    end;

    v12.Parent = ScrollingFrame;
end;

local function applyVisuals(p13, p14, p15) -- Line: 67
    -- upvalues: u2 (copy), u1 (copy)
    local v16;

    if p15 then
        v16 = u2;
    else
        v16 = u1;
    end;

    p13.BackgroundColor3 = v16;
    p14.Text = p15 and "On" or "Off";
end;

local function refresh(p17) -- Line: 72
    -- upvalues: SettingsCmds (copy), u6 (copy), u2 (copy), u1 (copy)
    local v18 = SettingsCmds.IsEnabled(p17);
    local v19 = u6[p17];

    if v19 then
        local Status = v19.Status;
        local v20;

        if v18 then
            v20 = u2;
        else
            v20 = u1;
        end;

        v19.Button.BackgroundColor3 = v20;
        Status.Text = v18 and "On" or "Off";
    end;
end;

local function attemptToggle(p21) -- Line: 80
    -- upvalues: u5 (copy), SettingsCmds (copy), u6 (copy), u2 (copy), u1 (copy)
    if u5[p21] then
        return;
    end;

    u5[p21] = true;
    local v22 = SettingsCmds.Toggle(p21);
    u5[p21] = nil;

    if not v22 then
        local v23 = SettingsCmds.IsEnabled(p21);
        local v24 = u6[p21];

        if v24 then
            local Status = v24.Status;
            local v25;

            if v23 then
                v25 = u2;
            else
                v25 = u1;
            end;

            v24.Button.BackgroundColor3 = v25;
            Status.Text = v23 and "On" or "Off";
        end;
    end;
end;

local function registerSettingRow(u26) -- Line: 94
    -- upvalues: ScrollingFrame (copy), u6 (copy), u5 (copy), SettingsCmds (copy), u2 (copy), u1 (copy)
    local v27 = ScrollingFrame:FindFirstChild(u26);

    if not v27 then
        return;
    end;

    local Button = v27:FindFirstChild("Button");

    if not (Button and Button:IsA("GuiButton")) then
        return;
    end;

    local Status = Button:FindFirstChild("Status");

    if not (Status and Status:IsA("TextLabel")) then
        return;
    end;

    u6[u26] = {
        Button = Button,
        Status = Status
    };
    Button.Activated:Connect(function() -- Line: 115
        -- upvalues: u26 (copy), u5 (ref), SettingsCmds (ref), u6 (ref), u2 (ref), u1 (ref)
        local v28 = u26;

        if u5[v28] then
            return;
        end;

        u5[v28] = true;
        local v29 = SettingsCmds.Toggle(v28);
        u5[v28] = nil;

        if not v29 then
            local v30 = SettingsCmds.IsEnabled(v28);
            local v31 = u6[v28];

            if v31 then
                local Status2 = v31.Status;
                local v32;

                if v30 then
                    v32 = u2;
                else
                    v32 = u1;
                end;

                v31.Button.BackgroundColor3 = v32;
                Status2.Text = v30 and "On" or "Off";
            end;
        end;
    end);
end;

local function toggleUI() -- Line: 120
    -- upvalues: Audio (copy), Constants (copy), TabController (copy)
    Audio.Play(Constants.BUTTON_FX.BUTTON_MOUSE_DOWN_SOUND, script, math.random(95, 105) / 100, 1.8);
    TabController.ToggleTab("Settings");
end;

local function updateIconEnabled() -- Line: 125
    -- upvalues: u3 (copy), Variables (copy)
    u3:setEnabled(Variables.Locks.HideUI:IsUnlocked());
end;

function v7.Init() -- Line: 133
    -- upvalues: registerConfiguredSettingRow (copy), registerSettingRow (copy), SettingsCmds (copy), u6 (copy), u2 (copy), u1 (copy), u3 (copy), toggleUI (copy), Variables (copy), updateIconEnabled (copy)
    registerConfiguredSettingRow("Trading", "Trading", 4);
    registerSettingRow("Music");
    registerSettingRow("Trading");
    registerSettingRow("HideOtherPets");
    registerSettingRow("DisableVideos");
    SettingsCmds.Changed:Connect(function(p33, p34) -- Line: 142
        -- upvalues: u6 (ref), u2 (ref), u1 (ref)
        local v35 = u6[p33];

        if v35 then
            local Status = v35.Status;
            local v36 = p34 ~= false;
            local v37;

            if v36 then
                v37 = u2;
            else
                v37 = u1;
            end;

            v35.Button.BackgroundColor3 = v37;
            Status.Text = v36 and "On" or "Off";
        end;
    end);
    local v38 = SettingsCmds.IsEnabled("Music");
    local Music = u6.Music;

    if Music then
        local Status = Music.Status;
        local v39;

        if v38 then
            v39 = u2;
        else
            v39 = u1;
        end;

        Music.Button.BackgroundColor3 = v39;
        Status.Text = v38 and "On" or "Off";
    end;

    local v40 = SettingsCmds.IsEnabled("Trading");
    local Trading = u6.Trading;

    if Trading then
        local Status = Trading.Status;
        local v41;

        if v40 then
            v41 = u2;
        else
            v41 = u1;
        end;

        Trading.Button.BackgroundColor3 = v41;
        Status.Text = v40 and "On" or "Off";
    end;

    local v42 = SettingsCmds.IsEnabled("HideOtherPets");
    local HideOtherPets = u6.HideOtherPets;

    if HideOtherPets then
        local Status = HideOtherPets.Status;
        local v43;

        if v42 then
            v43 = u2;
        else
            v43 = u1;
        end;

        HideOtherPets.Button.BackgroundColor3 = v43;
        Status.Text = v42 and "On" or "Off";
    end;

    local v44 = SettingsCmds.IsEnabled("DisableVideos");
    local DisableVideos = u6.DisableVideos;

    if DisableVideos then
        local Status = DisableVideos.Status;
        local v45;

        if v44 then
            v45 = u2;
        else
            v45 = u1;
        end;

        DisableVideos.Button.BackgroundColor3 = v45;
        Status.Text = v44 and "On" or "Off";
    end;

    u3:setImage(101403250204482):modifyTheme({ "IconImage", "ScaleType", Enum.ScaleType.Fit }):setImageScale(0.8):bindEvent("toggled", toggleUI);
    Variables.Locks.HideUI.Modified:Connect(updateIconEnabled);
    u3:setEnabled(Variables.Locks.HideUI:IsUnlocked());
end;

v7.Init();