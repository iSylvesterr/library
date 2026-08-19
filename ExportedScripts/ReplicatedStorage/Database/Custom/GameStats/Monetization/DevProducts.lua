-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
require(ReplicatedStorage.Database.Custom.Types);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local Router = require(ReplicatedStorage.Database.Security.Router);
local u1 = RunService:IsServer();

return table.freeze({
    ["Credits Starter Pack"] = {
        DevProductId = 3550800164,

        OnPurchased = function(p2, p3) -- Line: 31, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Purchase Credits Starter Pack", p2);
        end
    },
    ["Refresh Missions"] = {
        DevProductId = 3509753152,

        OnPurchased = function(p4, p5) -- Line: 40, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Refresh Missions", p4, p5);
        end
    },
    ["+ 400 Credits"] = {
        DevProductId = 3543515479,

        OnPurchased = function(p6, p7) -- Line: 49, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Credits Purchased", p6, 400);
        end
    },
    ["+ 950 Credits"] = {
        DevProductId = 3543515926,

        OnPurchased = function(p8, p9) -- Line: 57, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Credits Purchased", p8, 950);
        end
    },
    ["+ 3,100 Credits"] = {
        DevProductId = 3543516192,

        OnPurchased = function(p10, p11) -- Line: 65, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Credits Purchased", p10, 3100);
        end
    },
    ["+ 6,500 Credits"] = {
        DevProductId = 3543516540,

        OnPurchased = function(p12, p13) -- Line: 73, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Credits Purchased", p12, 6500);
        end
    },
    ["+ 13,250 Credits"] = {
        DevProductId = 3543516770,

        OnPurchased = function(p14, p15) -- Line: 81, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Credits Purchased", p14, 13250);
        end
    },
    ["+ 27,000 Credits"] = {
        DevProductId = 3543517001,

        OnPurchased = function(p16, p17) -- Line: 89, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Credits Purchased", p16, 27000);
        end
    },
    ["+ 67,500 Credits"] = {
        DevProductId = 3543517199,

        OnPurchased = function(p18, p19) -- Line: 97, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Credits Purchased", p18, 67500);
        end
    },
    ["Gift + 400 Credits"] = {
        DevProductId = 3543518894,

        OnPurchased = function(p20, p21) -- Line: 106, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Credits", p20, 400);
        end
    },
    ["Gift + 950 Credits"] = {
        DevProductId = 3543519307,

        OnPurchased = function(p22, p23) -- Line: 114, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Credits", p22, 950);
        end
    },
    ["Gift + 3,100 Credits"] = {
        DevProductId = 3543519553,

        OnPurchased = function(p24, p25) -- Line: 122, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Credits", p24, 3100);
        end
    },
    ["Gift + 6,500 Credits"] = {
        DevProductId = 3543519769,

        OnPurchased = function(p26, p27) -- Line: 130, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Credits", p26, 6500);
        end
    },
    ["Gift + 13,250 Credits"] = {
        DevProductId = 3543520414,

        OnPurchased = function(p28, p29) -- Line: 138, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Credits", p28, 13250);
        end
    },
    ["Gift + 27,000 Credits"] = {
        DevProductId = 3543520614,

        OnPurchased = function(p30, p31) -- Line: 146, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Credits", p30, 27000);
        end
    },
    ["Gift + 67,500 Credits"] = {
        DevProductId = 3543520837,

        OnPurchased = function(p32, p33) -- Line: 154, Name: OnPurchased
            -- upvalues: u1 (copy), Constants (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");
            local v34 = (require(game:GetService("ServerScriptService").Services.DataService).Get(p32, "Statistics.RobuxSpent") or 0) >= Constants.MINIMUM_CREDITS_FOR_SPECIAL_CREDITS_OPTION;
            assert(v34, "Player has not met the minimum spending requirement.");

            return Router.broadcastRouter("Gift Credits", p32, 67500);
        end
    },
    ["+ 400 Trade Tokens"] = {
        DevProductId = 3583969640,

        OnPurchased = function(p35, p36) -- Line: 169, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Trade Tokens Purchased", p35, 400);
        end
    },
    ["+ 800 Trade Tokens"] = {
        DevProductId = 3583969774,

        OnPurchased = function(p37, p38) -- Line: 177, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Trade Tokens Purchased", p37, 800);
        end
    },
    ["+ 1,700 Trade Tokens"] = {
        DevProductId = 3583971349,

        OnPurchased = function(p39, p40) -- Line: 185, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Trade Tokens Purchased", p39, 1700);
        end
    },
    ["+ 4,500 Trade Tokens"] = {
        DevProductId = 3583971424,

        OnPurchased = function(p41, p42) -- Line: 193, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Trade Tokens Purchased", p41, 4500);
        end
    },
    ["+ 10,000 Trade Tokens"] = {
        DevProductId = 3583971510,

        OnPurchased = function(p43, p44) -- Line: 201, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Trade Tokens Purchased", p43, 10000);
        end
    },
    ["+ 22,500 Trade Tokens"] = {
        DevProductId = 3583971584,

        OnPurchased = function(p45, p46) -- Line: 209, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Trade Tokens Purchased", p45, 22500);
        end
    },
    ["Gift + 400 Trade Tokens"] = {
        DevProductId = 3583968287,

        OnPurchased = function(p47, p48) -- Line: 218, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Trade Tokens", p47, "Gift + 400 Trade Tokens", 400);
        end
    },
    ["Gift + 800 Trade Tokens"] = {
        DevProductId = 3583968651,

        OnPurchased = function(p49, p50) -- Line: 226, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Trade Tokens", p49, "Gift + 800 Trade Tokens", 800);
        end
    },
    ["Gift + 1,700 Trade Tokens"] = {
        DevProductId = 3583968837,

        OnPurchased = function(p51, p52) -- Line: 234, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Trade Tokens", p51, "Gift + 1,700 Trade Tokens", 1700);
        end
    },
    ["Gift + 4,500 Trade Tokens"] = {
        DevProductId = 3583968960,

        OnPurchased = function(p53, p54) -- Line: 242, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Trade Tokens", p53, "Gift + 4,500 Trade Tokens", 4500);
        end
    },
    ["Gift + 10,000 Trade Tokens"] = {
        DevProductId = 3583969134,

        OnPurchased = function(p55, p56) -- Line: 250, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Trade Tokens", p55, "Gift + 10,000 Trade Tokens", 10000);
        end
    },
    ["Gift + 22,500 Trade Tokens"] = {
        DevProductId = 3583969448,

        OnPurchased = function(p57, p58) -- Line: 258, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Trade Tokens", p57, "Gift + 22,500 Trade Tokens", 22500);
        end
    },
    ["Purchase Featured Bundle"] = {
        DevProductId = 3607995908,

        OnPurchased = function(p59, p60) -- Line: 267, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Purchase Featured Bundle", p59);
        end
    },
    ["Gift Featured Bundle"] = {
        DevProductId = 3607996827,

        OnPurchased = function(p61, p62) -- Line: 276, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Featured Bundle", p61);
        end
    },
    ["M4A4 | Freedom"] = {
        DevProductId = 3607997525,

        OnPurchased = function(p63, p64) -- Line: 285, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Purchase Featured Package", p63, "M4A4 | Freedom");
        end
    },
    ["AWP | Freedom"] = {
        DevProductId = 3607997308,

        OnPurchased = function(p65, p66) -- Line: 293, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Purchase Featured Package", p65, "AWP | Freedom");
        end
    },
    ["Desert Eagle | Freedom"] = {
        DevProductId = 3607996989,

        OnPurchased = function(p67, p68) -- Line: 301, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Purchase Featured Package", p67, "Desert Eagle | Freedom");
        end
    },
    ["Gift M4A4 | Freedom"] = {
        DevProductId = 3607997581,

        OnPurchased = function(p69, p70) -- Line: 310, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Featured Package", p69, "M4A4 | Freedom");
        end
    },
    ["Gift AWP | Freedom"] = {
        DevProductId = 3607997401,

        OnPurchased = function(p71, p72) -- Line: 318, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Featured Package", p71, "AWP | Freedom");
        end
    },
    ["Gift Desert Eagle | Freedom"] = {
        DevProductId = 3607997209,

        OnPurchased = function(p73, p74) -- Line: 326, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Featured Package", p73, "Desert Eagle | Freedom");
        end
    }
});