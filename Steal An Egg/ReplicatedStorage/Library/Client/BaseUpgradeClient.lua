-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Bases = require(ReplicatedStorage.Directory.Bases);
local BaseUpgradeTransition = require(ReplicatedStorage.Library.Client.GUIFX.BaseUpgradeTransition);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local wcall = require(ReplicatedStorage.Library.Functions.wcall);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Mutex = require(ReplicatedStorage.Library.Modules.Mutex);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
local Save = require(ReplicatedStorage.Library.Client.Save);
local Plots = Constants.NETWORK_MAP.Plots;
local LocalPlayer = Players.LocalPlayer;
local u1 = Log.new();
local u2 = Mutex.new();
local u3 = {};

local function playTransitionAndRequest() -- Line: 34
    -- upvalues: BaseUpgradeTransition (copy), Network (copy), Plots (copy)
    BaseUpgradeTransition.Play(function() -- Line: 35
        -- upvalues: Network (ref), Plots (ref)
        Network.Fire(Plots.REQUEST_BASE_UPGRADE);
    end);
end;

function u3.GetNextConfig(p4) -- Line: 44
    -- upvalues: Asserts (copy), Bases (copy)
    Asserts.integerNonNegative(p4.BaseUpgradeLevel);
    local v5 = p4.BaseUpgradeLevel + 1;

    return v5, Bases.BASES[v5];
end;

function u3.CanAffordNext(p6) -- Line: 50
    -- upvalues: u3 (copy)
    local _, v7 = u3.GetNextConfig(p6);
    local v8;

    if v7 == nil then
        v8 = false;
    else
        v8 = p6.Money >= v7.Cost;
    end;

    return v8;
end;

function u3.RequestCashUpgrade() -- Line: 55
    -- upvalues: Save (copy), LocalPlayer (copy), u3 (copy), Message (copy), u2 (copy), wcall (copy), playTransitionAndRequest (copy), u1 (copy)
    local v9 = Save.Get(LocalPlayer, false);
    assert(v9 ~= nil, "Base upgrade request requires loaded data");
    local _, v10 = u3.GetNextConfig(v9);

    if v10 == nil then
        Message.Bottom({
            Message = "Max base upgrade reached",
            Time = 2
        });

        return false;
    end;

    if v9.Money < v10.Cost then
        Message.Bottom({
            Message = "Not enough money",
            Time = 2,
            Color = Color3.fromRGB(255, 64, 64)
        });

        return false;
    end;

    local u11 = u2:tryLock();

    if u11 == nil then
        return false;
    end;

    task.spawn(function() -- Line: 74
        -- upvalues: wcall (ref), playTransitionAndRequest (ref), u2 (ref), u11 (copy), u1 (ref)
        local v12, v13 = wcall(playTransitionAndRequest);
        u2:unlock(u11);

        if not v12 then
            u1:AtError():Log((`Base upgrade transition failed: {v13}`));
        end;
    end);

    return true;
end;

return u3;