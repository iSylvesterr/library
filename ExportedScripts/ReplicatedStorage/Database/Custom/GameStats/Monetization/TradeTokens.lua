-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Router = require(ReplicatedStorage.Database.Security.Router);
local u1 = RunService:IsServer();

return table.freeze({
    ["Credits Starter Pack"] = {
        Price = 57,

        OnPurchased = function(p2, p3) -- Line: 26, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Purchase Credits Starter Pack With Tokens", p2, p3);
        end
    },
    ["+ 400 Credits"] = {
        Price = 229,

        OnPurchased = function(p4, p5) -- Line: 35, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Purchase Credits With Tokens", p4, 400, p5);
        end
    },
    ["+ 950 Credits"] = {
        Price = 517,

        OnPurchased = function(p6, p7) -- Line: 43, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Purchase Credits With Tokens", p6, 950, p7);
        end
    },
    ["+ 3,100 Credits"] = {
        Price = 1437,

        OnPurchased = function(p8, p9) -- Line: 51, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Purchase Credits With Tokens", p8, 3100, p9);
        end
    },
    ["+ 6,500 Credits"] = {
        Price = 2874,

        OnPurchased = function(p10, p11) -- Line: 59, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Purchase Credits With Tokens", p10, 6500, p11);
        end
    },
    ["+ 13,250 Credits"] = {
        Price = 5749,

        OnPurchased = function(p12, p13) -- Line: 67, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Purchase Credits With Tokens", p12, 13250, p13);
        end
    },
    ["+ 27,000 Credits"] = {
        Price = 11499,

        OnPurchased = function(p14, p15) -- Line: 75, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Purchase Credits With Tokens", p14, 27000, p15);
        end
    },
    ["+ 67,500 Credits"] = {
        Price = 28749,

        OnPurchased = function(p16, p17) -- Line: 83, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Purchase Credits With Tokens", p16, 67500, p17);
        end
    },
    ["Gift + 400 Credits"] = {
        Price = 229,

        OnPurchased = function(p18, p19) -- Line: 92, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Credits With Tokens", p18, 400, p19);
        end
    },
    ["Gift + 950 Credits"] = {
        Price = 517,

        OnPurchased = function(p20, p21) -- Line: 100, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Credits With Tokens", p20, 950, p21);
        end
    },
    ["Gift + 3,100 Credits"] = {
        Price = 1437,

        OnPurchased = function(p22, p23) -- Line: 108, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Credits With Tokens", p22, 3100, p23);
        end
    },
    ["Gift + 6,500 Credits"] = {
        Price = 2874,

        OnPurchased = function(p24, p25) -- Line: 116, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Credits With Tokens", p24, 6500, p25);
        end
    },
    ["Gift + 13,250 Credits"] = {
        Price = 5749,

        OnPurchased = function(p26, p27) -- Line: 124, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Credits With Tokens", p26, 13250, p27);
        end
    },
    ["Gift + 27,000 Credits"] = {
        Price = 11499,

        OnPurchased = function(p28, p29) -- Line: 132, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Credits With Tokens", p28, 27000, p29);
        end
    },
    ["Gift + 67,500 Credits"] = {
        Price = 28749,

        OnPurchased = function(p30, p31) -- Line: 140, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Credits With Tokens", p30, 67500, p31);
        end
    },
    ["Purchase Featured Bundle"] = {
        Price = 1149,

        OnPurchased = function(p32, p33) -- Line: 149, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Purchase Featured Bundle With Tokens", p32, p33);
        end
    },
    ["Gift Featured Bundle"] = {
        Price = 1149,

        OnPurchased = function(p34, p35) -- Line: 158, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Featured Bundle With Tokens", p34, p35);
        end
    },
    ["M4A4 | Freedom"] = {
        Price = 689,

        OnPurchased = function(p36, p37) -- Line: 167, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Purchase Featured Package With Tokens", p36, "M4A4 | Freedom", p37);
        end
    },
    ["AWP | Freedom"] = {
        Price = 459,

        OnPurchased = function(p38, p39) -- Line: 175, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Purchase Featured Package With Tokens", p38, "AWP | Freedom", p39);
        end
    },
    ["Desert Eagle | Freedom"] = {
        Price = 574,

        OnPurchased = function(p40, p41) -- Line: 183, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Purchase Featured Package With Tokens", p40, "Desert Eagle | Freedom", p41);
        end
    },
    ["Gift M4A4 | Freedom"] = {
        Price = 689,

        OnPurchased = function(p42, p43) -- Line: 192, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Featured Package With Tokens", p42, "M4A4 | Freedom", p43);
        end
    },
    ["Gift AWP | Freedom"] = {
        Price = 459,

        OnPurchased = function(p44, p45) -- Line: 200, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Featured Package With Tokens", p44, "AWP | Freedom", p45);
        end
    },
    ["Gift Desert Eagle | Freedom"] = {
        Price = 574,

        OnPurchased = function(p46, p47) -- Line: 208, Name: OnPurchased
            -- upvalues: u1 (copy), Router (copy)
            assert(u1, "This function should only be called on the server.");

            return Router.broadcastRouter("Gift Featured Package With Tokens", p46, "Desert Eagle | Freedom", p47);
        end
    }
});