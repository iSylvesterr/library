-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local StarterGui = game:GetService("StarterGui");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local Sound = require(ReplicatedStorage.Classes.Sound);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local Promise = require(ReplicatedStorage.Shared.Promise);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local MenuState = require(script.MenuState);
local Screens = script:WaitForChild("Screens");
local u2 = ReplicatedStorage.Assets.UI:WaitForChild("MainGui") or PlayerGui:FindFirstChild("MainGui");
u2.Parent = PlayerGui;
local u3 = nil;
local u4 = nil;
local u5 = 1;
local u6 = { "Ammo", "Armor", "Health", "Inventory", "Money" };

local function promiseRequire(u7) -- Line: 62
    -- upvalues: Profiler (copy), Promise (copy)
    local u8 = Profiler.getInstancePath(u7, script);

    return Promise.try(function() -- Line: 65
        -- upvalues: u8 (copy), Profiler (ref), u7 (copy)
        debug.setmemorycategory((`Interface.{u8}`));
        Profiler.mark((`Interface.Require.{u8}`));

        return require(u7);
    end):catch(warn);
end;

local function recursive(p9, p10) -- Line: 74
    -- upvalues: recursive (copy), Profiler (copy), Promise (copy), u2 (copy), RunService (copy)
    if p10 then
        for _, child in ipairs(p9:GetChildren()) do
            local u11 = p10:FindFirstChild(child.Name);

            if child:IsA("Folder") then
                if u11 then
                    recursive(child, u11);
                else
                    warn((`Missing corresponding interface folder : "{string.lower(child:GetFullName())}"`));
                end;
            elseif child:IsA("ModuleScript") then
                if u11 then
                    local u12 = Profiler.getInstancePath(child, script);
                    local u13 = Profiler.getInstancePath(child, script);
                    Promise.try(function() -- Line: 65
                        -- upvalues: u13 (copy), Profiler (ref), child (copy)
                        debug.setmemorycategory((`Interface.{u13}`));
                        Profiler.mark((`Interface.Require.{u13}`));

                        return require(child);
                    end):catch(warn):andThen(function(u14) -- Line: 96
                        -- upvalues: Promise (ref), u12 (copy), Profiler (ref), u2 (ref), u11 (copy)
                        local v15;

                        if u14.Initialize then
                            v15 = Promise.try(function() -- Line: 99
                                -- upvalues: u12 (ref), Profiler (ref), u14 (copy), u2 (ref), u11 (ref)
                                debug.setmemorycategory((`Interface.{u12}`));
                                Profiler.mark((`Interface.Initialize.{u12}`));

                                return u14.Initialize(u2, u11);
                            end);
                        else
                            v15 = Promise.resolve();
                        end;

                        v15:andThen(function() -- Line: 109
                            -- upvalues: u14 (copy), Promise (ref), u12 (ref), Profiler (ref)
                            if u14.Start then
                                return Promise.try(function() -- Line: 114
                                    -- upvalues: u12 (ref), Profiler (ref), u14 (ref)
                                    debug.setmemorycategory((`Interface.{u12}`));
                                    Profiler.mark((`Interface.Start.{u12}`));

                                    return u14.Start();
                                end);
                            end;
                        end):catch(warn);
                    end);
                elseif RunService:IsStudio() then
                    warn((`Missing corresponding interface module for : "{string.lower(child:GetFullName())}"`));
                end;
            end;
        end;

        return;
    end;

    warn((`Pointer: "{p9.Name}" is not apart of interface.`));
end;

local function getInterfaceSoundGroup(p16) -- Line: 132
    -- upvalues: u3 (ref), Sound (copy), u4 (ref)
    if p16 == "Interface" then
        if not (u3 and u3.Sounds) then
            u3 = Sound.new("Interface");
        end;

        return u3;
    end;

    if not (u4 and u4.Sounds) then
        u4 = Sound.new("Store");
    end;

    return u4;
end;

local function playInterfaceSound(p17, p18) -- Line: 148
    -- upvalues: u3 (ref), Sound (copy), u4 (ref), PlayerGui (copy), u5 (ref)
    local v19;

    if p17 == "Interface" then
        if not (u3 and u3.Sounds) then
            u3 = Sound.new("Interface");
        end;

        v19 = u3;
    else
        if not (u4 and u4.Sounds) then
            u4 = Sound.new("Store");
        end;

        v19 = u4;
    end;

    if not v19 then
        return;
    end;

    v19:playOneTime({
        Parent = PlayerGui,
        Name = p18
    }, u5);
end;

function u1.guarantee(p20) -- Line: 163
    for _ = 1, 15 do
        if pcall(p20) then
            break;
        end;
    end;
end;

function u1.Initialize() -- Line: 177
    -- upvalues: MenuState (copy), u2 (copy), u1 (copy), StarterGui (copy), GetUserPlatform (copy), Profiler (copy), u6 (copy), DataController (copy), LocalPlayer (copy), u5 (ref), Router (copy), u3 (ref), Sound (copy), PlayerGui (copy), u4 (ref)
    MenuState.Initialize(u2);
    u1.guarantee(function() -- Line: 182
        -- upvalues: StarterGui (ref)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false);
        StarterGui:SetCore("ResetButtonCallback", false);
    end);
    local Bottom = u2:WaitForChild("Gameplay"):WaitForChild("Bottom");
    local u21 = {};
    local u22 = table.find(GetUserPlatform(), "Mobile") ~= nil;

    local function getOrCreateHUDScale(p23) -- Line: 194
        local HUDScale = p23:FindFirstChild("HUDScale");

        if HUDScale and HUDScale:IsA("UIScale") then
            return HUDScale;
        end;

        local v24 = p23:FindFirstChildOfClass("UIScale");

        if v24 then
            v24.Name = "HUDScale";

            return v24;
        end;

        local UIScale = Instance.new("UIScale");
        UIScale.Name = "HUDScale";
        UIScale.Parent = p23;

        return UIScale;
    end;

    local function applyHUDScale(p25) -- Line: 213
        -- upvalues: u22 (copy), u21 (copy)
        local v26 = u22 and 1 or p25;

        for _, v in ipairs(u21) do
            v.Scale = v26;
        end;
    end;

    Profiler.spawn("Interface.Initialize.HUDScale", function() -- Line: 224
        -- upvalues: Profiler (ref), u6 (ref), Bottom (copy), u21 (copy), DataController (ref), LocalPlayer (ref), u22 (copy)
        task.wait(0.1);
        Profiler.mark("Interface.HUDScale.Setup");

        for _, v in ipairs(u6) do
            local v27 = Bottom:FindFirstChild(v);

            if v27 and v27:IsA("Frame") then
                local HUDScale = v27:FindFirstChild("HUDScale");

                if not (HUDScale and HUDScale:IsA("UIScale")) then
                    HUDScale = v27:FindFirstChildOfClass("UIScale");

                    if HUDScale then
                        HUDScale.Name = "HUDScale";
                    else
                        HUDScale = Instance.new("UIScale");
                        HUDScale.Name = "HUDScale";
                        HUDScale.Parent = v27;
                    end;
                end;

                table.insert(u21, HUDScale);
            end;
        end;

        local v28 = u22 and 1 or (DataController.Get(LocalPlayer, "Settings.Game.HUD.Scale") or 1);

        for _, v in ipairs(u21) do
            v.Scale = v28;
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Scale", function(p29) -- Line: 241
        -- upvalues: u22 (copy), u21 (copy)
        local v30 = u22 and 1 or (p29 or 1);

        for _, v in ipairs(u21) do
            v.Scale = v30;
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Audio.Music.Main Menu Volume", function(p31) -- Line: 245
        -- upvalues: u5 (ref)
        u5 = (tonumber(p31) or 100) / 100;
    end);
    Router.observerRouter("RunInterfaceSound", function(p32) -- Line: 250
        -- upvalues: u3 (ref), Sound (ref), PlayerGui (ref), u5 (ref)
        if not (u3 and u3.Sounds) then
            u3 = Sound.new("Interface");
        end;

        local v33 = u3;

        if not v33 then
            return;
        end;

        v33:playOneTime({
            Parent = PlayerGui,
            Name = p32
        }, u5);
    end);
    Router.observerRouter("RunStoreSound", function(p34) -- Line: 254
        -- upvalues: u4 (ref), Sound (ref), PlayerGui (ref), u5 (ref)
        if not (u4 and u4.Sounds) then
            u4 = Sound.new("Store");
        end;

        local v35 = u4;

        if not v35 then
            return;
        end;

        v35:playOneTime({
            Parent = PlayerGui,
            Name = p34
        }, u5);
    end);
end;

function u1.Start() -- Line: 259
    -- upvalues: recursive (copy), Screens (copy), u2 (copy)
    recursive(Screens, u2);
end;

return u1;