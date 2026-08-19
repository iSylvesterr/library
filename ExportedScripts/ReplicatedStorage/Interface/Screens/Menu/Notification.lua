-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Router = require(ReplicatedStorage.Database.Security.Router);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local u2 = nil;

function u1.CreateNotification(p3, p4) -- Line: 23
    -- upvalues: Router (copy), u2 (ref)
    Router.broadcastRouter("RunInterfaceSound", "Notification " .. p3);
    u2.TextLabel.Text = p4;
    u2.Visible = true;
end;

function u1.CloseNotification() -- Line: 32
    -- upvalues: u2 (ref)
    u2.Visible = false;
end;

function u1.Initialize(p5, p6) -- Line: 40
    -- upvalues: u2 (ref), CloseButtonRegistry (copy), u1 (copy), Router (copy), Remotes (copy)
    u2 = p6;
    CloseButtonRegistry.Add(u2, u2.Footer.Close, function() -- Line: 43
        -- upvalues: u1 (ref)
        u1.CloseNotification();
    end);
    Router.observerRouter("CreateMenuNotification", function(p7, p8) -- Line: 48
        -- upvalues: u1 (ref)
        u1.CreateNotification(p7, p8);

        return nil;
    end);
    Remotes.UI.CreateMenuNotification.Listen(function(p9) -- Line: 53
        -- upvalues: u1 (ref)
        u1.CreateNotification(p9.notificationType, p9.text);
    end);
end;

return u1;