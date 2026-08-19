-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Variables = require(ReplicatedStorage.Library.Variables);
local Treadmills = Constants.NETWORK_MAP.Treadmills;
local u1 = Log.new();
local u2 = nil;

local function updateTreadmillSession(p3) -- Line: 27
    -- upvalues: Asserts (copy), u2 (ref), Variables (copy), u1 (copy)
    Asserts.optional.string(p3);

    if p3 == nil or u2 ~= nil then
        if p3 == nil and u2 ~= nil then
            u2();
            u2 = nil;
            u1:AtDebug():Log("Released treadmill shift-lock suppression");
        end;

        return;
    end;

    u2 = Variables.Locks.DisableShiftLock:ObtainLock();
    u1:AtDebug():Log("Disabled shift lock for the active treadmill session");
end;

Network.Fired(Treadmills.ACTIVE_TREADMILL_EVENT):Connect(updateTreadmillSession);