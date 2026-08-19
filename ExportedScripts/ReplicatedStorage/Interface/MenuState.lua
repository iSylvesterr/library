-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Lighting = game:GetService("Lighting");
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui");
local Signal = require(ReplicatedStorage.Packages.Signal);
u1.OnScreenChanged = Signal.new();
u1.OnInspectStateChanged = Signal.new();
u1.OnCaseSceneStateChanged = Signal.new();
u1.OnTradeUpStateChanged = Signal.new();
local u2 = nil;
local u3 = nil;
local u4 = false;
local u5 = false;
local u6 = false;
local u7 = nil;
local u8 = nil;
local u9 = false;
local u10 = nil;
local u11 = nil;

local function getMenuBlur() -- Line: 54
    -- upvalues: u11 (ref), Lighting (copy)
    if u11 then
        return u11;
    end;

    u11 = Lighting:FindFirstChild("Menu");

    return u11;
end;

local function getMenuFrame() -- Line: 64
    -- upvalues: u10 (ref), PlayerGui (copy)
    if not u10 then
        u10 = PlayerGui:FindFirstChild("MainGui");
    end;

    if u10 then
        return u10:FindFirstChild("Menu");
    end;

    return nil;
end;

function u1.Initialize(p12) -- Line: 81
    -- upvalues: u10 (ref), u11 (ref), Lighting (copy)
    u10 = p12;
    local v13;

    if u11 then
        v13 = u11;
    else
        u11 = Lighting:FindFirstChild("Menu");
        v13 = u11;
    end;

    u11 = v13;
end;

function u1.GetCurrentScreen() -- Line: 89
    -- upvalues: u2 (ref)
    return u2;
end;

function u1.GetPreviousScreen() -- Line: 96
    -- upvalues: u3 (ref)
    return u3;
end;

function u1.IsInspectActive() -- Line: 103
    -- upvalues: u4 (ref)
    return u4;
end;

function u1.IsStoreEnabled() -- Line: 110
    -- upvalues: ReplicatedStorage (copy)
    return ReplicatedStorage:GetAttribute("Environment") == "Production";
end;

function u1.SetScreen(p14) -- Line: 118
    -- upvalues: u2 (ref), u1 (copy), u3 (ref)
    if p14 == u2 or p14 == "Store" and not u1.IsStoreEnabled() then
        return;
    end;

    local v15 = u2;
    u3 = v15;
    u2 = p14;
    u1.OnScreenChanged:Fire(v15, p14);
end;

function u1.SetWantsMainMenu(p16) -- Line: 138
    -- upvalues: u9 (ref)
    u9 = p16 == true;
end;

function u1.WantsMainMenu() -- Line: 146
    -- upvalues: u9 (ref)
    return u9;
end;

function u1.HideMenu() -- Line: 150
    -- upvalues: u10 (ref), PlayerGui (copy), u1 (copy)
    if not u10 then
        u10 = PlayerGui:FindFirstChild("MainGui");
    end;

    local v17;

    if u10 then
        v17 = u10:FindFirstChild("Menu");
    else
        v17 = nil;
    end;

    if v17 then
        v17.Visible = false;
    end;

    u1.SetScreen(nil);
end;

function u1.EnterInspect() -- Line: 165
    -- upvalues: u4 (ref), u7 (ref), u2 (ref), u1 (copy)
    if u4 then
        return;
    end;

    u7 = u2;
    u4 = true;
    u1.OnInspectStateChanged:Fire(true);
end;

function u1.ExitInspect() -- Line: 183
    -- upvalues: u4 (ref), u1 (copy), u7 (ref)
    if not u4 then
        return;
    end;

    u4 = false;
    u1.OnInspectStateChanged:Fire(false);
    u7 = nil;
end;

function u1.GetScreenBeforeInspect() -- Line: 201
    -- upvalues: u7 (ref)
    return u7;
end;

function u1.IsCaseSceneActive() -- Line: 208
    -- upvalues: u5 (ref)
    return u5;
end;

function u1.EnterCaseScene() -- Line: 218
    -- upvalues: u5 (ref), u8 (ref), u2 (ref), u1 (copy)
    if u5 then
        return;
    end;

    u8 = u2;
    u5 = true;
    u1.OnCaseSceneStateChanged:Fire(true);
end;

function u1.ExitCaseScene() -- Line: 236
    -- upvalues: u5 (ref), u1 (copy), u8 (ref)
    if not u5 then
        return;
    end;

    u5 = false;
    u1.OnCaseSceneStateChanged:Fire(false);
    u8 = nil;
end;

function u1.GetScreenBeforeCaseScene() -- Line: 254
    -- upvalues: u8 (ref)
    return u8;
end;

function u1.IsTradeUpActive() -- Line: 261
    -- upvalues: u6 (ref)
    return u6;
end;

function u1.EnterTradeUp() -- Line: 268
    -- upvalues: u6 (ref), u1 (copy)
    if u6 then
        return;
    end;

    u6 = true;
    u1.OnTradeUpStateChanged:Fire(true);
end;

function u1.ExitTradeUp() -- Line: 280
    -- upvalues: u6 (ref), u1 (copy)
    if not u6 then
        return;
    end;

    u6 = false;
    u1.OnTradeUpStateChanged:Fire(false);
end;

function u1.SetBlurEnabled(p18) -- Line: 293
    -- upvalues: u11 (ref), Lighting (copy)
    local v19;

    if u11 then
        v19 = u11;
    else
        u11 = Lighting:FindFirstChild("Menu");
        v19 = u11;
    end;

    if v19 then
        v19.Enabled = p18;
    end;
end;

function u1.IsBlurEnabled() -- Line: 303
    -- upvalues: u11 (ref), Lighting (copy)
    local v20;

    if u11 then
        v20 = u11;
    else
        u11 = Lighting:FindFirstChild("Menu");
        v20 = u11;
    end;

    return v20 and v20.Enabled or false;
end;

function u1.GetMenuFrame() -- Line: 311
    -- upvalues: u10 (ref), PlayerGui (copy)
    if not u10 then
        u10 = PlayerGui:FindFirstChild("MainGui");
    end;

    if u10 then
        return u10:FindFirstChild("Menu");
    end;

    return nil;
end;

function u1.GetMainGui() -- Line: 318
    -- upvalues: u10 (ref), PlayerGui (copy)
    if not u10 then
        u10 = PlayerGui:FindFirstChild("MainGui");
    end;

    return u10;
end;

return u1;