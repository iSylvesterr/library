-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local GetProductInfo = require(ReplicatedStorage.Library.Functions.GetProductInfo);
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local wcall = require(ReplicatedStorage.Library.Functions.wcall);
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
require(script.Parent.Types.Interface);
local u1 = {};
u1.__index = u1;
u1.__class = "PhotoInputController";
local u2 = t.interface({
    AssetTypeId = t.number
});

function u1.new(p3, p4) -- Line: 54
    -- upvalues: u1 (copy), Trove (copy)
    local AddPhoto = p3.AddPhoto;
    local Content = p3.Sheet.Actions.Content;
    local v5 = setmetatable({}, u1);
    v5._addButton = AddPhoto.Frame.Buttons.Add;
    v5._attachment = Content.TextInputWrapper.AddedPhoto;
    v5._cancelButton = AddPhoto.Frame.Buttons.Cancel;
    v5._composerAddPhotoButton = Content.AddPhoto;
    v5._destroyed = false;
    v5._imageAssetId = nil;
    v5._input = AddPhoto.Frame.TextInputWrapper.TextInput;
    v5._onInteraction = p4;
    v5._overlay = AddPhoto;
    v5._removeButton = v5._attachment.RemoveButton;
    v5._requestSerial = 0;
    v5._textInputWrapper = Content.TextInputWrapper;
    v5._trove = Trove.new();
    v5:_init();

    return v5;
end;

local function parseImageAssetId(p6) -- Line: 79
    local v7 = p6:match("^%s*(.-)%s*$") or "";
    local v8 = v7:match("^%d+$");

    if v8 == nil then
        v8 = string.lower(v7):match("^rbxassetid://(%d+)$");
    end;

    local v9;

    if v8 == nil then
        v9 = nil;
    else
        v9 = tonumber(v8);
    end;

    if v9 == nil or (v9 <= 0 or v9 % 1 ~= 0) then
        return nil;
    end;

    return v9;
end;

local function showInvalidImageNotification() -- Line: 94
    -- upvalues: Message (copy)
    Message.Top({
        Message = "Invalid image, please upload another image.",
        Time = 3,
        ShowShadow = true,
        Color = Color3.new(1, 1, 1)
    });
end;

local function showImageLookupFailedNotification() -- Line: 103
    -- upvalues: Message (copy)
    Message.Top({
        Message = "Something went wrong, please try again later.",
        Time = 3,
        ShowShadow = true,
        Color = Color3.new(1, 1, 1)
    });
end;

local function isImageAsset(p10) -- Line: 112
    -- upvalues: wcall (copy), GetProductInfo (copy), u2 (copy)
    local v11, v12 = wcall(GetProductInfo, p10, Enum.InfoType.Asset);

    if not v11 then
        return false, "ImageAssetLookupFailed";
    end;

    if not u2(v12) then
        return false, "ImageAssetLookupFailed";
    end;

    local AssetTypeId = v12.AssetTypeId;

    if AssetTypeId == Enum.AssetType.Image.Value or AssetTypeId == Enum.AssetType.Decal.Value then
        return true, nil;
    end;

    return false, "InvalidImageAssetId";
end;

function u1._setAttachment(p13, p14) -- Line: 130
    p13._imageAssetId = p14;
    p13._attachment.Visible = p14 ~= nil;

    if p14 == nil then
        p13._attachment.Icon.Image = "";

        return;
    end;

    p13._attachment.Icon.Image = `rbxassetid://{p14}`;
end;

function u1._closeOverlay(p15) -- Line: 140
    p15._requestSerial = p15._requestSerial + 1;
    p15._addButton.Active = true;
    p15._overlay.Visible = false;
    p15._input.Text = "";
end;

function u1.GetImageAssetId(p16) -- Line: 151
    return p16._imageAssetId;
end;

function u1.Reset(p17) -- Line: 155
    p17:_closeOverlay();
    p17:_setAttachment(nil);
end;

function u1.Destroy(p18) -- Line: 160
    if p18._destroyed then
        return;
    end;

    p18._destroyed = true;
    p18:Reset();
    p18._trove:Destroy();
end;

function u1._init(u19) -- Line: 174
    -- upvalues: Players (copy), Constants (copy), ButtonFX (copy), parseImageAssetId (copy), Message (copy), isImageAsset (copy)
    local v20 = Players.LocalPlayer.UserId == Constants.OWNER_ID;
    u19._overlay.Visible = false;
    u19._attachment.Visible = false;
    u19._composerAddPhotoButton.Visible = v20;
    u19._composerAddPhotoButton.Active = v20;
    u19._composerAddPhotoButton.Selectable = v20;
    local _textInputWrapper = u19._textInputWrapper;
    local v21;

    if v20 then
        v21 = UDim2.new(1, -105, 0, 48);
    else
        v21 = UDim2.new(1, -50, 0, 48);
    end;

    _textInputWrapper.Size = v21;

    if not v20 then
        return;
    end;

    u19._trove:Add(ButtonFX(u19._composerAddPhotoButton, nil, function() -- Line: 186
        -- upvalues: u19 (copy)
        u19._onInteraction();
        u19._overlay.Visible = true;
        u19._input:CaptureFocus();
    end));
    u19._trove:Add(ButtonFX(u19._cancelButton, 1.08, function() -- Line: 191
        -- upvalues: u19 (copy)
        u19._onInteraction();
        u19:_closeOverlay();
    end));
    u19._trove:Add(ButtonFX(u19._removeButton, nil, function() -- Line: 195
        -- upvalues: u19 (copy)
        u19._onInteraction();
        u19:_setAttachment(nil);
    end));
    u19._trove:Add(ButtonFX(u19._addButton, 1.08, function() -- Line: 199
        -- upvalues: u19 (copy), parseImageAssetId (ref), Message (ref), isImageAsset (ref)
        u19._onInteraction();
        local u22 = parseImageAssetId(u19._input.Text);

        if u22 == nil then
            Message.Top({
                Message = "Invalid image, please upload another image.",
                Time = 3,
                ShowShadow = true,
                Color = Color3.new(1, 1, 1)
            });

            return;
        end;

        local v23 = u19;
        v23._requestSerial = v23._requestSerial + 1;
        local _requestSerial = u19._requestSerial;
        u19._addButton.Active = false;
        task.spawn(function() -- Line: 210
            -- upvalues: isImageAsset (ref), u22 (copy), u19 (ref), _requestSerial (copy), Message (ref)
            local v24, v25 = isImageAsset(u22);

            if u19._destroyed or _requestSerial ~= u19._requestSerial then
                return;
            end;

            u19._addButton.Active = true;

            if v24 then
                u19:_setAttachment(u22);
                u19:_closeOverlay();

                return;
            end;

            if v25 == "ImageAssetLookupFailed" then
                Message.Top({
                    Message = "Something went wrong, please try again later.",
                    Time = 3,
                    ShowShadow = true,
                    Color = Color3.new(1, 1, 1)
                });

                return;
            end;

            Message.Top({
                Message = "Invalid image, please upload another image.",
                Time = 3,
                ShowShadow = true,
                Color = Color3.new(1, 1, 1)
            });
        end);
    end));
end;

return u1;