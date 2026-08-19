-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);
require(script:WaitForChild("Types"));
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local CharacterAnimator = require(script.Classes.CharacterAnimator);
local Viewmodel = require(script.Classes.Viewmodel);

function v1.new(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13) -- Line: 29
    -- upvalues: Janitor (copy), GetWeaponProperties (copy), CharacterAnimator (copy), Viewmodel (copy), Skins (copy)
    debug.profilebegin("WeaponComponent.new");
    local u14 = {};
    debug.profilebegin("WeaponComponent.new.Janitor");
    u14.Janitor = Janitor.new();
    u14.IsDestroyed = false;
    debug.profileend();
    u14.OriginalOwner = p11;
    u14.Identifier = p3;
    u14.StatTrack = p9;
    u14.Stickers = p13;
    u14.NameTag = p10;
    u14.Player = p2;
    u14.Float = p8;
    u14.Name = p6;
    u14.Charm = p12;
    u14.Skin = p7;
    u14.Slot = p5;
    u14._id = p4;
    debug.profilebegin("WeaponComponent.new.GetWeaponProperties");
    u14.Properties = GetWeaponProperties(p6);
    debug.profileend();
    debug.profilebegin("WeaponComponent.new.CharacterAnimator");
    u14.CharacterAnimator = CharacterAnimator.new(u14.Player, p6);
    debug.profileend();
    debug.profilebegin("WeaponComponent.new.Viewmodel");
    local success, result = pcall(Viewmodel.new, u14, p6, p7);
    debug.profileend();

    if not success then
        debug.profileend();
        error(result, 2);
    end;

    u14.Viewmodel = result;
    debug.profilebegin("WeaponComponent.new.CleanupCallbacks");
    u14.Janitor:Add(function() -- Line: 86
        -- upvalues: u14 (copy)
        if u14.CharacterAnimator then
            u14.CharacterAnimator:destroy();
            u14.CharacterAnimator = nil;
        end;
    end);
    u14.Janitor:Add(function() -- Line: 94
        -- upvalues: u14 (copy)
        if u14.Viewmodel then
            u14.Viewmodel:destroy();
            u14.Viewmodel = nil;
        end;
    end);
    debug.profileend();

    function u14.updateStatTrackCounter(p15, p16) -- Line: 103
        -- upvalues: Skins (ref)
        p15.StatTrack = p16;
        local v17 = p15.StatTrack and p15.Viewmodel.Model:FindFirstChild("KillTrak", true);

        if not v17 then
            return;
        end;

        v17.Screen.SurfaceGui.TextLabel.Text = Skins.GetKillTrackValue(p16, p15.Name);
    end;

    debug.profileend();

    return u14;
end;

function v1.destroy(p18) -- Line: 125
    debug.profilebegin("WeaponComponent.destroy");

    if p18.CharacterAnimator then
        p18.CharacterAnimator:destroy();
        p18.CharacterAnimator = nil;
    end;

    if p18.Viewmodel then
        p18.Viewmodel:destroy();
        p18.Viewmodel = nil;
    end;

    if p18.Janitor then
        p18.Janitor:Destroy();
        p18.Janitor = nil;
    end;

    p18.updateStatTrackCounter = nil;
    p18.OriginalOwner = nil;
    p18.Properties = nil;
    p18.Identifier = nil;
    p18.StatTrack = nil;
    p18.Stickers = nil;
    p18.NameTag = nil;
    p18.Player = nil;
    p18.Float = nil;
    p18.Name = nil;
    p18.Charm = nil;
    p18.Skin = nil;
    p18.Slot = nil;
    p18._id = nil;
    debug.profileend();
end;

return v1;