-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
require(ReplicatedStorage.Library.Types.OfferFunnel);
local wcall = require(ReplicatedStorage.Library.Functions.wcall);
local Analytics = Constants.NETWORK_MAP.Analytics;
local u1 = {};
local v2 = {};

local function fireStep(p3, p4, p5) -- Line: 31
    -- upvalues: Asserts (copy), Network (copy), Analytics (copy)
    Asserts.string(p3);
    Asserts.string(p4);
    Asserts.string(p5);
    assert(p5 ~= "", "SessionKey cannot be empty");
    Network.Fire(Analytics.OFFER_FUNNEL_STEP, {
        OfferName = p3,
        StepName = p4,
        SessionKey = p5
    });
end;

function v2.TrackImpression(p6, p7) -- Line: 49
    -- upvalues: u1 (copy), wcall (copy), fireStep (copy)
    if u1[p6] == p7 then
        return;
    end;

    u1[p6] = p7;
    task.spawn(wcall, fireStep, p6, "Impression", p7);
end;

function v2.TrackOfferClick(p8, p9) -- Line: 59
    -- upvalues: wcall (copy), fireStep (copy)
    task.spawn(wcall, fireStep, p8, "OfferClick", p9);
end;

function v2.TrackBuyClick(p10, p11) -- Line: 63
    -- upvalues: wcall (copy), fireStep (copy)
    task.spawn(wcall, fireStep, p10, "BuyClick", p11);
end;

function v2.TrackDeclined(p12, p13) -- Line: 67
    -- upvalues: wcall (copy), fireStep (copy)
    task.spawn(wcall, fireStep, p12, "Declined", p13);
end;

return v2;