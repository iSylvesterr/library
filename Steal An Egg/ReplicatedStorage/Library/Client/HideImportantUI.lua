-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage.Library;
local wcall = require(ReplicatedStorage.Library.Functions.wcall);
local FuncWrapper = require(ReplicatedStorage.Library.Modules.FuncWrapper);
local GUI = require(Library.Client.GUI);
local Variables = require(Library.Variables);
local TabController = require(Library.Client.TabController);
local Tween = require(Library.Functions.Tween);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new():LimitUnderLevel("Warning");
local HideUI = Variables.Locks.HideUI;
local u2 = GUI.SideButtons();
local u3 = GUI.FriendBoost();
local u4 = GUI.Money();
local _ = u4.Bottom.Frame.Money;
local _ = u4.Bottom.Frame.FriendBoost;
local u5 = GUI.Backpack();
local u6 = GUI.OfflineMoneyInPlot();
local u7 = {};
u7.__index = u7;
u7.__class = "HideImportantUI";

function u7._build() -- Line: 65
    -- upvalues: u7 (copy), FuncWrapper (copy), u2 (copy), u3 (copy), u4 (copy), u5 (copy), u6 (copy)
    local v8 = setmetatable({}, u7);
    v8._funcWrapper = FuncWrapper.CreateWrapper(v8);
    v8.UiConfig = {
        [u2] = true,
        [u3] = true,
        [u4] = true,
        [u5] = true,
        [u6] = true
    };
    v8:_init();

    return v8;
end;

function u7.SlideInUI(p9, p10) -- Line: 86
    -- upvalues: Tween (copy)
    local v11 = p9.UiConfig[p10];

    if type(v11) == "boolean" then
        if v11 then
            p10.Enabled = true;
        end;
    else
        p10.Enabled = true;

        for i, v in pairs(v11.frames) do
            if v.disableOnly then
                i.Visible = true;
            else
                i.Position = v.goalPosition;
                Tween(i, {
                    Position = v.returnPosition
                }, { 0.4, "Back", "Out" });
            end;
        end;
    end;
end;

function u7.SlideOutUI(p12, u13) -- Line: 107
    -- upvalues: Tween (copy)
    local v14 = p12.UiConfig[u13];

    if type(v14) == "boolean" then
        if v14 then
            u13.Enabled = false;
        end;
    else
        for i, v in pairs(v14.frames) do
            if v.disableOnly then
                i.Visible = false;
            else
                Tween(i, {
                    Position = v.goalPosition
                }, { 0.4, "Back", "In" }).Completed:Once(function() -- Line: 121
                    -- upvalues: u13 (copy)
                    u13.Enabled = false;
                end);
            end;
        end;
    end;
end;

function u7._updateUIVisibility(p15) -- Line: 128
    -- upvalues: Variables (copy), HideUI (copy), TabController (copy)
    local Locks = Variables.Locks;

    for i, v in pairs(p15.UiConfig) do
        local v16 = HideUI:IsUnlocked() and Locks.HideUIAllowNotifications:IsUnlocked();
        local Enabled = i.Enabled;

        if type(v) ~= "boolean" then
            local config = v.config;

            if config and config.extraRequirements then
                if v16 then
                    v16 = config.extraRequirements();
                end;
            end;

            local v17 = next(v.frames);
            Enabled = assert(v17, "Empty frame list").Visible;
        end;

        if Enabled and not v16 then
            p15:SlideOutUI(i);
        elseif not Enabled and v16 then
            p15:SlideInUI(i);
        end;
    end;

    if HideUI:IsLocked() then
        TabController.CloseTab();
    end;
end;

function u7.IsLocked(p18) -- Line: 157
    -- upvalues: HideUI (copy)
    return HideUI:IsLocked();
end;

function u7.IsUnLocked(p19) -- Line: 161
    -- upvalues: HideUI (copy)
    return HideUI:IsUnlocked();
end;

function u7.Hide(p20) -- Line: 165
    -- upvalues: HideUI (copy), u1 (copy)
    HideUI:ObtainLock();
    task.spawn(p20._updateUIVisibility, p20);
    u1:AtTrace():Log((`Hiding UI: {HideUI._obtainedCount}`));

    return HideUI:IsLocked();
end;

function u7.UnHide(p21) -- Line: 175
    -- upvalues: wcall (copy), HideUI (copy), u1 (copy)
    wcall(HideUI.ReleaseLock, HideUI);
    task.spawn(p21._updateUIVisibility, p21);
    u1:AtTrace():Log((`Uniding UI: {HideUI._obtainedCount}`));

    return HideUI:IsUnlocked();
end;

function u7._init(p22) -- Line: 189
    return p22;
end;

return u7._build();