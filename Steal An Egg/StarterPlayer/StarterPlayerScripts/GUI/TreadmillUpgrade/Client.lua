-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
local PromptPurchase = require(ReplicatedStorage.Library.Shared.Functions.PromptPurchase);
local Save = require(ReplicatedStorage.Library.Client.Save);
local Treadmills = require(ReplicatedStorage.Directory.Treadmills);
require(ReplicatedStorage.Directory.Treadmills.Types.Interface);
local Treadmills2 = Constants.NETWORK_MAP.Treadmills;
local u1 = Color3.fromRGB(255, 64, 64);
local u2 = Log.new();
local u5 = {
    GetNextConfig = function(p3) -- Line: 31, Name: GetNextConfig
        -- upvalues: Asserts (copy), Treadmills (copy)
        Asserts.integerNonNegative(p3.TreadmillUpgradeLevel);
        local v4 = p3.TreadmillUpgradeLevel + 1;

        return v4, Treadmills.GetByUpgradeLevel(v4);
    end
};

function u5.CanAffordNext(p6) -- Line: 37
    -- upvalues: u5 (copy)
    local _, v7 = u5.GetNextConfig(p6);
    local v8;

    if v7 == nil then
        v8 = false;
    else
        v8 = p6.Money >= v7.Price;
    end;

    return v8;
end;

function u5.RequestCashUpgrade() -- Line: 42
    -- upvalues: Save (copy), u5 (copy), Message (copy), u1 (copy), Network (copy), Treadmills2 (copy), u2 (copy)
    local v9 = Save.Get();
    assert(v9 ~= nil, "Treadmill cash upgrade requires loaded data");
    local _, v10 = u5.GetNextConfig(v9);

    if v10 == nil then
        Message.Bottom({
            Message = "Max treadmill upgrade reached",
            Time = 2
        });

        return false;
    end;

    if v9.Money < v10.Price then
        Message.Bottom({
            Message = "Not enough money",
            Time = 2,
            Color = u1
        });

        return false;
    end;

    local v11, v12 = Network.Invoke(Treadmills2.REQUEST_UPGRADE, v10._id);

    if v11 == true then
        return true;
    end;

    local v13 = v12 or "Treadmill upgrade failed";
    u2:AtWarning():Log(v13);
    Message.Bottom({
        Time = 2,
        Message = v13,
        Color = u1
    });

    return false;
end;

function u5.PromptRobuxUpgrade() -- Line: 67
    -- upvalues: Save (copy), u5 (copy), Message (copy), u2 (copy), PromptPurchase (copy)
    local v14 = Save.Get();
    assert(v14 ~= nil, "Treadmill Robux upgrade requires loaded data");
    local _, v15 = u5.GetNextConfig(v14);

    if v15 == nil then
        Message.Bottom({
            Message = "Max treadmill upgrade reached",
            Time = 2
        });

        return false;
    end;

    local ProductId = v15.ProductId;

    if ProductId == nil then
        u2:AtWarning():Log((`Treadmill "{v15._id}" has no Robux upgrade product`));

        return false;
    end;

    PromptPurchase.Prompt(ProductId, true);

    return true;
end;

return u5;