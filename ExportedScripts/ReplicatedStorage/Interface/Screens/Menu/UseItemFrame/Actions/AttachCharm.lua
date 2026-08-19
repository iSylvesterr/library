-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local u2 = nil;
local u3 = nil;
u1.ActionType = "AttachCharm";

local function IsCharmEligibleWeapon(p4) -- Line: 52
    return p4.Type == "Weapon" and true or p4.Type == "Zeus x27";
end;

local function WeaponsWithoutCharm(p5, p6) -- Line: 57
    if p5.Type ~= "Weapon" and p5.Type ~= "Zeus x27" then
        return false;
    end;

    local v7;

    if p5.Charm == nil or p5.Charm == false then
        v7 = false;
    else
        v7 = (type(p5.Charm) == "string" or p5.Charm == true) and true or type(p5.Charm) == "table";
    end;

    return not v7;
end;

local function AllCharms(p8, p9) -- Line: 66
    -- upvalues: DataController (copy), LocalPlayer (copy)
    if p8.Type ~= "Charm" then
        return false;
    end;

    local v10 = DataController.Get(LocalPlayer, "Inventory");

    if v10 then
        for _, v in ipairs(v10) do
            if v.Charm then
                local v11 = type(v.Charm) == "table" and v.Charm._id;

                if not v11 then
                    if type(v.Charm) == "string" then
                        v11 = v.Charm;
                    else
                        v11 = false;
                    end;
                end;

                if v11 == p8._id then
                    return false;
                end;
            end;
        end;
    end;

    return true;
end;

function u1.GetFilter(p12) -- Line: 90
    -- upvalues: AllCharms (copy), WeaponsWithoutCharm (copy)
    if p12.Type == "Weapon" and true or p12.Type == "Zeus x27" then
        return AllCharms;
    end;

    return p12.Type ~= "Charm" and function() -- Line: 99
        return false;
    end or WeaponsWithoutCharm;
end;

function u1.GetContext(p13) -- Line: 104
    -- upvalues: u1 (copy)
    return {
        ActionType = u1.ActionType,
        SourceItem = p13,
        Title = p13.Type == "Charm" and "Select Weapon" or "Select Charm"
    };
end;

function u1.OnItemSelected(p14, p15) -- Line: 119
    -- upvalues: u2 (ref), Router (copy)
    if not p15.SourceItem then
        return;
    end;

    local SourceItem = p15.SourceItem;
    local v16, v17;

    if SourceItem.Type == "Weapon" and true or SourceItem.Type == "Zeus x27" then
        if p14.Type ~= "Charm" then
            return;
        end;

        v16 = SourceItem._id;
        v17 = p14._id;
        p14 = SourceItem;
    else
        if SourceItem.Type ~= "Charm" then
            return;
        end;

        if p14.Type ~= "Weapon" and p14.Type ~= "Zeus x27" then
            return;
        end;

        v16 = p14._id;
        v17 = SourceItem._id;
    end;

    u2 = {
        WeaponId = v16,
        CharmId = v17,
        WeaponItem = p14
    };
    Router.broadcastRouter("WeaponInspect", p14.Name, p14.Skin, p14.Float, p14.StatTrack, p14.NameTag, {
        Position = "1",
        _id = v17
    }, p14.Stickers, p14.Type, p14.Pattern, p14._id, p14.Serial, p14.IsTradeable);
end;

function u1.OnCancelled(p18) -- Line: 176
    -- upvalues: u2 (ref)
    u2 = nil;
end;

function u1.ConfirmAttachment() -- Line: 183
    -- upvalues: u2 (ref), Router (copy), Remotes (copy)
    if not u2 then
        return false;
    end;

    local v19 = Router.broadcastRouter("GetCurrentCharmPosition") or 1;
    Remotes.Inventory.UpdateWeaponCharm.Send({
        WeaponId = u2.WeaponId,
        CharmId = u2.CharmId,
        Position = tostring(v19)
    });
    u2 = nil;
    Router.broadcastRouter("WeaponInspectClose");

    return true;
end;

function u1.CancelAttachment() -- Line: 208
    -- upvalues: u2 (ref), Router (copy)
    if not u2 then
        return false;
    end;

    u2 = nil;
    Router.broadcastRouter("WeaponInspectClose");

    return true;
end;

function u1.HasPendingAttachment() -- Line: 219
    -- upvalues: u2 (ref)
    return u2 ~= nil;
end;

function u1.Initialize() -- Line: 225
    -- upvalues: u3 (ref), MenuState (copy), u2 (ref), Router (copy), u1 (copy)
    u3 = MenuState.OnInspectStateChanged:Connect(function(p20) -- Line: 227
        -- upvalues: u2 (ref)
        if not p20 and u2 then
            u2 = nil;
        end;
    end);
    Router.observerRouter("ConfirmCharmAttachment", function() -- Line: 235
        -- upvalues: u1 (ref)
        return u1.ConfirmAttachment();
    end);
    Router.observerRouter("HasPendingCharmAttachment", function() -- Line: 239
        -- upvalues: u1 (ref)
        return u1.HasPendingAttachment();
    end);
    Router.observerRouter("CancelCharmAttachment", function() -- Line: 243
        -- upvalues: u1 (ref)
        return u1.CancelAttachment();
    end);
end;

function u1.Destroy() -- Line: 250
    -- upvalues: u3 (ref), u2 (ref)
    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;

    u2 = nil;
end;

return u1;