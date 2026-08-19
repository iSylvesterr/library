-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local GetDisplayNameFromUserIdAsync = require(ReplicatedStorage.Library.Functions.GetDisplayNameFromUserIdAsync);
local GetThumbnailFromUserIdAsync = require(ReplicatedStorage.Library.Functions.GetThumbnailFromUserIdAsync);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Network = require(ReplicatedStorage.Library.Client.Network);
local TreadmillMediaIdentity = require(ReplicatedStorage.Library.Modules.TreadmillMediaIdentity);
local Schema = require(ReplicatedStorage.Library.Types.TreadmillMediaLike.Types.Schema);
require(ReplicatedStorage.Library.Types.TreadmillMediaLike.Types.Interface);
local wcall = require(ReplicatedStorage.Library.Functions.wcall);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
require(script.Parent.Types.Interface);
local u1 = {};
u1.__index = u1;
u1.__class = "FriendLikesController";
local Treadmills = Constants.NETWORK_MAP.Treadmills;
local u2 = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u3 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local u4 = TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut);
local u5 = Vector2.new(0.13, 0.13);
local u6 = Log.new();
local u7 = GUI.TreadmillScreenFriendLikes();
local v8 = u7:IsA("SurfaceGui");
assert(v8, "Treadmill friend-like GUI must be a SurfaceGui");
local Frame = u7.Frame;
local Main = Frame.Main;
local Template = Main.Template;
local v9 = Template:IsA("Frame");
assert(v9, "Treadmill friend-like template must be a Frame");
local v10 = Template.Button:IsA("ImageButton");
assert(v10, "Treadmill friend-like template button must be an ImageButton");
local Profile = Frame.Profile;
local v11 = Profile:IsA("Frame");
assert(v11, "Treadmill friend-like profile must be a Frame");
local Position = Profile.Position;
local PlayerIcon = Profile.Main.Icon.PlayerIcon;
local v12 = PlayerIcon:IsA("ImageLabel");
assert(v12, "Treadmill friend-like profile icon must be an ImageLabel");
local TextLabel = Profile.Main.TextLabel;
local v13 = TextLabel:IsA("TextLabel");
assert(v13, "Treadmill friend-like profile label must be a TextLabel");

function u1.new(p14, p15, p16, p17, p18) -- Line: 90
    -- upvalues: Asserts (copy), u1 (copy), Profile (copy), PlayerIcon (copy), TextLabel (copy), Position (copy), Main (copy), Trove (copy), Template (copy), u7 (copy)
    Asserts.func(p14);
    Asserts.func(p15);
    Asserts.table(p16);
    Asserts.table(p17);
    Asserts.BasePart(p18);
    local v19 = setmetatable({}, u1);
    v19._destroyed = false;
    v19._friendLikeUserIdsByMediaLikeKey = {};
    v19._getActiveVideoIndex = p14;
    v19._interactionCallback = p15;
    v19._mediaEntries = p16;
    v19._profile = Profile;
    v19._profilePlayerIcon = PlayerIcon;
    v19._profileTextLabel = TextLabel;
    v19._profileTween = nil;
    v19._profileVisiblePosition = Position;
    v19._rowsContainer = Main;
    v19._rowsTrove = Trove.new();
    v19._rowTemplate = Template;
    v19._screenTapSuppressUntil = 0;
    v19._snapshotRequestSerial = 0;
    v19._surfaceGui = u7;
    v19._trove = p17:Extend();
    v19:_init(p18);

    return v19;
end;

local function escapeRichText(p20) -- Line: 129
    return p20:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;"):gsub("\'", "&apos;");
end;

local function getRandomFloatPosition(p21) -- Line: 133
    -- upvalues: u5 (copy)
    return UDim2.fromScale(0.5 + p21:NextNumber(-u5.X, u5.X), 0.5 + p21:NextNumber(-u5.Y, u5.Y));
end;

local function startButtonFloat(u22, p23) -- Line: 140
    -- upvalues: TweenService (copy), u4 (copy), u5 (copy)
    local u24 = Random.new();
    local u25 = nil;
    local u26 = false;
    u22.AnchorPoint = Vector2.new(0.5, 0.5);
    u22.Position = UDim2.fromScale(0.5, 0.5);

    local function playNext() -- Line: 148
        -- upvalues: u26 (ref), u22 (copy), TweenService (ref), u4 (ref), u24 (copy), u5 (ref), u25 (ref), playNext (copy)
        if u26 or u22.Parent == nil then
            return;
        end;

        local v27 = {};
        local v28 = u24;
        v27.Position = UDim2.fromScale(0.5 + v28:NextNumber(-u5.X, u5.X), 0.5 + v28:NextNumber(-u5.Y, u5.Y));
        local u29 = TweenService:Create(u22, u4, v27);
        u25 = u29;
        u29.Completed:Once(function() -- Line: 157
            -- upvalues: u25 (ref), u29 (copy), playNext (ref)
            if u25 ~= u29 then
                return;
            end;

            u25 = nil;
            playNext();
        end);
        u29:Play();
    end;

    p23:Add(function() -- Line: 168
        -- upvalues: u26 (ref), u25 (ref)
        u26 = true;

        if u25 ~= nil then
            u25:Cancel();
            u25 = nil;
        end;
    end);
    playNext();
end;

function u1._isAlive(p30) -- Line: 178
    return not p30._destroyed;
end;

function u1._getMediaKey(p31) -- Line: 182
    -- upvalues: TreadmillMediaIdentity (copy)
    local v32 = p31._getActiveVideoIndex();
    local v33 = p31._mediaEntries[v32];
    local v34 = `Missing treadmill media entry for index {v32}`;
    assert(v33 ~= nil, v34);

    return TreadmillMediaIdentity.GetMediaKey(v33);
end;

function u1._getProfileHiddenPosition(p35) -- Line: 189
    local _profileVisiblePosition = p35._profileVisiblePosition;

    return UDim2.new(_profileVisiblePosition.X.Scale, _profileVisiblePosition.X.Offset, 2, _profileVisiblePosition.Y.Offset);
end;

function u1._cancelProfileTween(p36) -- Line: 199
    local _profileTween = p36._profileTween;
    p36._profileTween = nil;

    if _profileTween ~= nil then
        _profileTween:Cancel();
    end;
end;

function u1._hideProfileImmediate(p37) -- Line: 207
    p37:_cancelProfileTween();
    p37._profile.Visible = false;
    p37._profile.Position = p37:_getProfileHiddenPosition();
end;

function u1._clearRows(p38) -- Line: 213
    -- upvalues: Trove (copy)
    p38._rowsTrove:Destroy();
    p38._rowsTrove = Trove.new();
end;

function u1._getRequestedMediaKeys(p39) -- Line: 218
    -- upvalues: TreadmillMediaIdentity (copy)
    local v40 = p39._getActiveVideoIndex();
    local v41 = {};
    local v42 = {};

    for _, v in ipairs({ v40, v40 + 1, v40 - 1 }) do
        local v43 = p39._mediaEntries[v];

        if v43 ~= nil then
            local v44 = TreadmillMediaIdentity.GetMediaKey(v43);

            if not v41[v44] then
                v41[v44] = true;
                table.insert(v42, v44);
            end;
        end;
    end;

    return v42;
end;

function u1._requestFriendLikeSnapshot(u45, p46) -- Line: 245
    -- upvalues: wcall (copy), Network (copy), Treadmills (copy), u6 (copy), Schema (copy)
    local v47, v48 = wcall(function() -- Line: 249
        -- upvalues: Network (ref), Treadmills (ref), u45 (copy)
        return Network.Invoke(Treadmills.REQUEST_FRIEND_LIKE_SNAPSHOT, {
            MediaKeys = u45:_getRequestedMediaKeys()
        });
    end);

    if not v47 then
        u6:AtError():Log((`Failed to load treadmill friend-like snapshot: {v48}`));

        return;
    end;

    if not Schema.FriendLikeSnapshot(v48) then
        u6:AtError():Log("Invalid treadmill friend-like snapshot payload");

        return;
    end;

    if not u45:_isAlive() or p46 ~= u45._snapshotRequestSerial then
        return;
    end;

    u45._friendLikeUserIdsByMediaLikeKey = table.clone(v48.FriendLikeUserIdsByMediaLikeKey);
    u45:UpdatePresentation();
end;

function u1._requestFriendLikeSnapshotAsync(u49) -- Line: 274
    u49._snapshotRequestSerial = u49._snapshotRequestSerial + 1;
    local _snapshotRequestSerial = u49._snapshotRequestSerial;
    task.spawn(function() -- Line: 277
        -- upvalues: u49 (copy), _snapshotRequestSerial (copy)
        if not u49:_isAlive() then
            return;
        end;

        u49:_requestFriendLikeSnapshot(_snapshotRequestSerial);
    end);
end;

function u1._resolveDisplayName(p50, p51) -- Line: 286
    -- upvalues: Players (copy), GetDisplayNameFromUserIdAsync (copy)
    local v52 = Players:GetPlayerByUserId(p51);

    if v52 == nil then
        return GetDisplayNameFromUserIdAsync(p51);
    end;

    return v52.DisplayName;
end;

function u1._showProfilePreview(u53, u54, p55) -- Line: 295
    -- upvalues: Constants (copy), escapeRichText (copy), GetThumbnailFromUserIdAsync (copy), TweenService (copy), u2 (copy)
    u53:_cancelProfileTween();
    local v56 = u53:_resolveDisplayName(u54);

    if not u53:_isAlive() then
        return;
    end;

    u53._profilePlayerIcon.Image = p55;
    u53._profileTextLabel.RichText = true;
    local v57 = u54 == Constants.OWNER_ID and " (OWNER)" or "";
    u53._profileTextLabel.Text = `<b>{escapeRichText(v56)}{v57}</b> liked this video`;
    u53._profile.Position = u53:_getProfileHiddenPosition();
    u53._profile.Visible = true;

    if p55 == "" then
        task.spawn(function() -- Line: 315
            -- upvalues: GetThumbnailFromUserIdAsync (ref), u54 (copy), u53 (copy)
            local v58 = GetThumbnailFromUserIdAsync(u54, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180);

            if not (u53:_isAlive() and u53._profile.Visible) then
                return;
            end;

            u53._profilePlayerIcon.Image = v58 == nil and "" or v58;
        end);
    end;

    local u59 = TweenService:Create(u53._profile, u2, {
        Position = u53._profileVisiblePosition
    });
    u53._profileTween = u59;
    u59.Completed:Once(function() -- Line: 332
        -- upvalues: u53 (copy), u59 (copy)
        if u53._profileTween ~= u59 then
            return;
        end;

        u53._profileTween = nil;
    end);
    u59:Play();
end;

function u1._startRefreshLoop(u60) -- Line: 342
    task.spawn(function() -- Line: 343
        -- upvalues: u60 (copy)
        while u60:_isAlive() do
            task.wait(180);

            if not u60:_isAlive() then
                break;
            end;

            u60:_requestFriendLikeSnapshotAsync();
        end;
    end);
end;

function u1._init(p61, p62) -- Line: 355
    p61._surfaceGui.Adornee = p62;
    p61._surfaceGui.Enabled = true;
    p61._rowTemplate.Visible = false;
    p61._profileTextLabel.RichText = true;
    p61:_hideProfileImmediate();
    p61:UpdatePresentation();
    p61:_requestFriendLikeSnapshotAsync();
    p61:_startRefreshLoop();
end;

function u1.UpdatePresentation(u63) -- Line: 370
    -- upvalues: startButtonFloat (copy), ButtonFX (copy), GetThumbnailFromUserIdAsync (copy)
    if not u63:_isAlive() then
        return;
    end;

    u63:_clearRows();
    local v64 = u63:_getMediaKey();
    local v65 = u63._friendLikeUserIdsByMediaLikeKey[v64];

    if v65 == nil or #v65 == 0 then
        return;
    end;

    for i, v in ipairs(v65) do
        local u66 = u63._rowTemplate:Clone();
        local Button = u66.Button;
        u66.Name = `FriendLike_{v}`;
        u66.Visible = true;
        u66.LayoutOrder = i;
        Button.PlayerIcon.Image = "";
        u66.Parent = u63._rowsContainer;
        local v67 = u63._rowsTrove:Extend();
        startButtonFloat(Button, v67);
        v67:Add(ButtonFX(Button, nil, function() -- Line: 395
            -- upvalues: u63 (copy), v (copy), Button (copy)
            u63:SuppressScreenTap();
            u63._interactionCallback();
            u63:_showProfilePreview(v, Button.PlayerIcon.Image);
        end));
        v67:Add(u66);
        task.spawn(function() -- Line: 402
            -- upvalues: GetThumbnailFromUserIdAsync (ref), v (copy), u63 (copy), u66 (copy), Button (copy)
            local v68 = GetThumbnailFromUserIdAsync(v, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180);

            if not u63:_isAlive() or u66.Parent == nil then
                return;
            end;

            Button.PlayerIcon.Image = v68 == nil and "" or v68;
        end);
    end;
end;

function u1.HandleScreenTap(p69) -- Line: 416
    if not p69:_isAlive() or os.clock() < p69._screenTapSuppressUntil then
        return;
    end;

    p69:HideProfilePreview();
end;

function u1.SuppressScreenTap(p70) -- Line: 424
    p70._screenTapSuppressUntil = os.clock() + 0.12;
end;

function u1.HandleMediaChanged(p71) -- Line: 428
    if not p71:_isAlive() then
        return;
    end;

    p71:HideProfilePreview();
    p71:UpdatePresentation();
    p71:_requestFriendLikeSnapshotAsync();
end;

function u1.HideProfilePreview(u72) -- Line: 438
    -- upvalues: TweenService (copy), u3 (copy)
    if not u72:_isAlive() then
        return;
    end;

    u72:_cancelProfileTween();

    if not u72._profile.Visible then
        u72._profile.Position = u72:_getProfileHiddenPosition();

        return;
    end;

    local u73 = TweenService:Create(u72._profile, u3, {
        Position = u72:_getProfileHiddenPosition()
    });
    u72._profileTween = u73;
    u73.Completed:Once(function() -- Line: 453
        -- upvalues: u72 (copy), u73 (copy)
        if u72._profileTween ~= u73 then
            return;
        end;

        u72._profileTween = nil;
        u72._profile.Visible = false;
    end);
    u73:Play();
end;

function u1.Destroy(p74) -- Line: 464
    if p74._destroyed then
        return;
    end;

    p74._destroyed = true;
    p74:_clearRows();
    p74:_hideProfileImmediate();
    p74._surfaceGui.Enabled = false;
    p74._trove:Destroy();
end;

return u1;