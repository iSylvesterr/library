-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Bezier2 = require(ReplicatedStorage.Library.Functions.Bezier2);
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local Easing = require(ReplicatedStorage.Library.Functions.Easing);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Lock = require(ReplicatedStorage.Library.Functions.Lock);
local Network = require(ReplicatedStorage.Library.Client.Network);
local RenderStepped = require(ReplicatedStorage.Library.Functions.RenderStepped);
local TreadmillMediaIdentity = require(ReplicatedStorage.Library.Modules.TreadmillMediaIdentity);
local Schema = require(ReplicatedStorage.Library.Types.TreadmillMediaLike.Types.Schema);
require(ReplicatedStorage.Library.Types.TreadmillMediaLike.Types.Interface);
local wcall = require(ReplicatedStorage.Library.Functions.wcall);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
require(ReplicatedStorage.Library.Modules.Packages.Trove);
require(script.Parent.Types.Interface);
local PreloadAssets = require(ReplicatedStorage.Library.Functions.PreloadAssets);
local u1 = {};
u1.__index = u1;
u1.__class = "LikeController";
local Treadmills = Constants.NETWORK_MAP.Treadmills;
local u2 = Color3.fromRGB(255, 92, 122);
local u3 = Log.new();
task.spawn(PreloadAssets, "rbxassetid://90146064998908", "rbxassetid://123761405635833");
local u4 = GUI.TreadmillScreenSideButtons();
local v5 = u4:IsA("SurfaceGui");
assert(v5, "Treadmill like GUI must be a SurfaceGui");
local LikeButton = u4.Frame.Buttons.LikeButton;
local v6 = LikeButton:IsA("ImageButton");
assert(v6, "Treadmill like button must be an ImageButton");
local LikeCount = LikeButton.LikeCount;
local v7 = LikeCount:IsA("TextLabel");
assert(v7, "Treadmill like count label must be a TextLabel");

function u1.new(p8, p9, p10, p11, p12, p13) -- Line: 91
    -- upvalues: Asserts (copy), u1 (copy), LikeButton (copy), LikeCount (copy), u4 (copy)
    Asserts.func(p8);
    Asserts.func(p9);
    Asserts.table(p10);
    Asserts.table(p11);
    Asserts.Instance(p12);
    Asserts.BasePart(p13);
    local v14 = setmetatable({}, u1);
    v14._countsByMediaLikeKey = {};
    v14._defaultLikeButtonColor = LikeButton.ImageColor3;
    v14._destroyed = false;
    v14._getActiveVideoIndex = p8;
    v14._lastScreenTapPosition = nil;
    v14._lastScreenTapTime = nil;
    v14._likeButton = LikeButton;
    v14._likeCountLabel = LikeCount;
    v14._likeRequestLocks = {};
    v14._likeSurfaceGui = u4;
    v14._likedTreadmillMedia = {};
    v14._mediaEntries = p10;
    v14._onSingleTap = p9;
    v14._pendingSingleTapSerial = 0;
    v14._snapshotRequestSerial = 0;
    v14._screenTapSuppressUntil = 0;
    v14._trove = p11:Extend();
    v14._videoFrame = p12;
    v14:_init(p13);

    return v14;
end;

local function formatLikeCount(p15) -- Line: 133
    -- upvalues: Simple (copy)
    return Simple.FormatCompact(math.max(p15, 0), ".#");
end;

local function getSquareHeartSize(p16, p17) -- Line: 137
    local v18 = math.min(p16.X, p16.Y);

    return UDim2.fromScale(v18 / p16.X * p17, v18 / p16.Y * p17);
end;

function u1._isAlive(p19) -- Line: 145
    return not p19._destroyed;
end;

function u1._getMediaKey(p20) -- Line: 149
    -- upvalues: TreadmillMediaIdentity (copy)
    local v21 = p20._getActiveVideoIndex();
    local v22 = p20._mediaEntries[v21];
    local v23 = `Missing treadmill media entry for index {v21}`;
    assert(v22 ~= nil, v23);

    return TreadmillMediaIdentity.GetMediaKey(v22);
end;

function u1._setRuntimeLikedState(p24, p25, p26) -- Line: 156
    if p26 then
        p24._likedTreadmillMedia[p25] = true;

        return;
    end;

    p24._likedTreadmillMedia[p25] = nil;
end;

function u1._applyLocalLikedState(p27, p28, p29) -- Line: 164
    if p27._likedTreadmillMedia[p28] == true == p29 then
        return;
    end;

    p27:_setRuntimeLikedState(p28, p29);
    p27._countsByMediaLikeKey[p28] = math.max((p27._countsByMediaLikeKey[p28] or 0) + (p29 and 1 or -1), 0);
    p27:UpdatePresentation();
end;

function u1._reconcileLikedState(p30, p31, p32) -- Line: 176
    p30:_setRuntimeLikedState(p31, p32.Liked == true);

    if typeof(p32.Count) == "number" then
        p30._countsByMediaLikeKey[p31] = p32.Count;
    end;

    p30:UpdatePresentation();
end;

function u1._requestLikeSnapshot(p33, p34) -- Line: 188
    -- upvalues: wcall (copy), Network (copy), Treadmills (copy), u3 (copy), Schema (copy)
    local v35, v36 = wcall(function() -- Line: 189
        -- upvalues: Network (ref), Treadmills (ref)
        return Network.Invoke(Treadmills.REQUEST_LIKE_SNAPSHOT);
    end);

    if not v35 then
        u3:AtError():Log((`Failed to load treadmill media like snapshot: {v36}`));

        return;
    end;

    if not Schema.LikeSnapshot(v36) then
        u3:AtError():Log("Invalid treadmill media like snapshot payload");

        return;
    end;

    if not p33:_isAlive() or p34 ~= p33._snapshotRequestSerial then
        return;
    end;

    p33._countsByMediaLikeKey = table.clone(v36.CountsByMediaLikeKey);
    p33._likedTreadmillMedia = table.clone(v36.LikedTreadmillMedia);
    p33:UpdatePresentation();
end;

function u1._requestLikeSnapshotAsync(u37) -- Line: 213
    u37._snapshotRequestSerial = u37._snapshotRequestSerial + 1;
    local _snapshotRequestSerial = u37._snapshotRequestSerial;
    task.spawn(function() -- Line: 216
        -- upvalues: u37 (copy), _snapshotRequestSerial (copy)
        if not u37:_isAlive() then
            return;
        end;

        u37:_requestLikeSnapshot(_snapshotRequestSerial);
    end);
end;

function u1._setLikedState(u38, u39) -- Line: 225
    -- upvalues: Lock (copy), wcall (copy), Network (copy), Treadmills (copy), u3 (copy), Schema (copy)
    local u40 = u38:_getMediaKey();
    local v41 = u38._likeRequestLocks[u40];

    if v41 == nil then
        v41 = Lock();
        u38._likeRequestLocks[u40] = v41;
    end;

    v41(function() -- Line: 233
        -- upvalues: u38 (copy), u40 (copy), u39 (copy), wcall (ref), Network (ref), Treadmills (ref), u3 (ref), Schema (ref)
        local v42 = u38;
        v42._snapshotRequestSerial = v42._snapshotRequestSerial + 1;
        local v43 = u38._likedTreadmillMedia[u40] == true;
        local v44 = u38._countsByMediaLikeKey[u40] or 0;
        u38:_applyLocalLikedState(u40, u39);
        local v45, v46 = wcall(function() -- Line: 240
            -- upvalues: Network (ref), Treadmills (ref), u40 (ref), u39 (ref)
            return Network.Invoke(Treadmills.REQUEST_SET_MEDIA_LIKE, u40, u39);
        end);

        if not v45 then
            if not u38:_isAlive() then
                return;
            end;

            u38:_setRuntimeLikedState(u40, v43);
            u38._countsByMediaLikeKey[u40] = v44;
            u38:UpdatePresentation();
            u3:AtError():Log((`Failed to update treadmill media like state: {v46}`));

            return;
        end;

        if not Schema.LikeToggleResult(v46) then
            if not u38:_isAlive() then
                return;
            end;

            u38:_setRuntimeLikedState(u40, v43);
            u38._countsByMediaLikeKey[u40] = v44;
            u38:UpdatePresentation();
            u3:AtError():Log("Rejected treadmill media like state update: Invalid like toggle response");

            return;
        end;

        if v46.Ok == true then
            if not u38:_isAlive() then
                return;
            end;

            u38:_reconcileLikedState(u40, v46);

            return;
        end;

        if not u38:_isAlive() then
            return;
        end;

        u38:_setRuntimeLikedState(u40, v43);
        u38._countsByMediaLikeKey[u40] = v44;
        u38:UpdatePresentation();
        u3:AtError():Log((`Rejected treadmill media like state update: {tostring(v46.Error)}`));
    end);
end;

function u1._spawnHeartAnimation(u47, p48) -- Line: 289
    -- upvalues: Asserts (copy), u2 (copy), Bezier2 (copy), RenderStepped (copy), Easing (copy)
    Asserts.finiteVector2(p48);
    local _videoFrame = u47._videoFrame;
    local AbsoluteSize = _videoFrame.AbsoluteSize;
    local v49;

    if AbsoluteSize.X > 0 then
        v49 = AbsoluteSize.Y > 0;
    else
        v49 = false;
    end;

    assert(v49, "Treadmill like animation requires a non-zero video frame size");
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "TreadmillLikeHeart";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://90146064998908";
    ImageLabel.ImageColor3 = u2;
    ImageLabel.ImageTransparency = 0;
    ImageLabel.Position = UDim2.fromScale(p48.X, p48.Y);
    ImageLabel.Size = UDim2.fromScale(0.15, 0.08);
    ImageLabel.ZIndex = u47._likeButton.ZIndex + 10;
    ImageLabel.Parent = _videoFrame;
    Instance.new("UIAspectRatioConstraint").Parent = ImageLabel;
    local v50 = Random.new();
    local v51 = v50:NextNumber(-0.08, 0.08);
    local v52 = -v50:NextNumber(0.24, 0.34);
    local v53 = Vector2.new(math.clamp(p48.X + v51, 0.05, 0.95), (math.clamp(p48.Y + v52, 0.05, 0.95)));
    local u54 = Bezier2(p48, Vector2.new(math.clamp(p48.X + v51 * 0.55, 0.05, 0.95), (math.clamp(p48.Y + v52 * 0.45, 0.05, 0.95))), v53);
    local u55 = nil;
    local u56 = false;

    local function cleanupHeart(p57) -- Line: 330
        -- upvalues: u56 (ref), u55 (ref), ImageLabel (copy)
        if u56 then
            return;
        end;

        u56 = true;
        local u58 = u55;
        u55 = nil;

        if u58 ~= nil then
            if p57 then
                u58:Disconnect();
            end;

            u58:Then(function() -- Line: 342
                -- upvalues: u58 (copy)
                u58:Destroy();
            end);
        end;

        if ImageLabel.Parent ~= nil then
            ImageLabel:Destroy();
        end;
    end;

    u55 = RenderStepped(function(p59, p60) -- Line: 352
        -- upvalues: u47 (copy), ImageLabel (copy), u56 (ref), u55 (ref), Easing (ref), u54 (copy), AbsoluteSize (copy)
        if not u47:_isAlive() or ImageLabel.Parent == nil then
            if not u56 then
                u56 = true;
                local u61 = u55;
                u55 = nil;

                if u61 ~= nil then
                    u61:Then(function() -- Line: 342
                        -- upvalues: u61 (copy)
                        u61:Destroy();
                    end);
                end;

                if ImageLabel.Parent ~= nil then
                    ImageLabel:Destroy();
                end;
            end;

            return true;
        end;

        local v62 = u54((Easing(p60, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)));
        local v63;

        if p60 <= 0.18 then
            v63 = 0.6 + -0.19999999999999996 * Easing(p60 / 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
        else
            v63 = 0.4 + -0.32 * Easing((p60 - 0.18) / 0.82, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
        end;

        ImageLabel.Position = UDim2.fromScale(v62.X, v62.Y);
        local v64 = AbsoluteSize;
        local v65 = math.min(v64.X, v64.Y);
        ImageLabel.Size = UDim2.fromScale(v65 / v64.X * v63, v65 / v64.Y * v63);
        ImageLabel.ImageTransparency = math.clamp((p60 - 0.35) / 0.65, 0, 1);

        if p60 < 1 then
            return false;
        end;

        if not u56 then
            u56 = true;
            local u66 = u55;
            u55 = nil;

            if u66 ~= nil then
                u66:Then(function() -- Line: 342
                    -- upvalues: u66 (copy)
                    u66:Destroy();
                end);
            end;

            if ImageLabel.Parent ~= nil then
                ImageLabel:Destroy();
            end;
        end;

        return true;
    end, 0.65, true);
    u47._trove:Add(function() -- Line: 381
        -- upvalues: cleanupHeart (copy)
        cleanupHeart(true);
    end);
end;

function u1._handleDoubleTap(p67, p68) -- Line: 386
    -- upvalues: Asserts (copy)
    Asserts.finiteVector2(p68);
    p67:_spawnHeartAnimation(p68);
    local v69 = p67:_getMediaKey();

    if p67._likedTreadmillMedia[v69] == true then
        return;
    end;

    p67:_setLikedState(true);
end;

function u1._startRefreshLoop(u70) -- Line: 398
    task.spawn(function() -- Line: 399
        -- upvalues: u70 (copy)
        while u70:_isAlive() do
            task.wait(180);

            if not u70:_isAlive() then
                break;
            end;

            u70:_requestLikeSnapshotAsync();
        end;
    end);
end;

function u1._init(u71, p72) -- Line: 411
    -- upvalues: ButtonFX (copy)
    u71._likeSurfaceGui.Adornee = p72;
    u71._likeSurfaceGui.Enabled = true;
    u71:UpdatePresentation();
    u71._trove:Add(ButtonFX(u71._likeButton, nil, function() -- Line: 416
        -- upvalues: u71 (copy)
        u71:Toggle();
    end));
    u71:_requestLikeSnapshotAsync();
    u71:_startRefreshLoop();
end;

function u1.UpdatePresentation(p73) -- Line: 428
    -- upvalues: u2 (copy), Simple (copy)
    if not p73:_isAlive() then
        return;
    end;

    local v74 = p73:_getMediaKey();
    local v75 = p73._likedTreadmillMedia[v74] == true;
    local v76 = p73._countsByMediaLikeKey[v74] or 0;
    local _likeButton = p73._likeButton;
    local v77;

    if v75 then
        v77 = u2;
    else
        v77 = Color3.fromRGB(255, 255, 255);
    end;

    _likeButton.ImageColor3 = v77;
    p73._likeButton.Image = v75 and "rbxassetid://90146064998908" or "rbxassetid://123761405635833";
    p73._likeCountLabel.Text = Simple.FormatCompact(math.max(v76, 0), ".#");
end;

function u1.SuppressScreenTap(p78) -- Line: 442
    p78._screenTapSuppressUntil = os.clock() + 0.12;
end;

function u1.Toggle(p79) -- Line: 446
    if not p79:_isAlive() then
        return;
    end;

    p79:SuppressScreenTap();
    local v80 = p79:_getMediaKey();
    p79:_setLikedState(p79._likedTreadmillMedia[v80] ~= true);
end;

function u1.HandleScreenTap(u81, p82) -- Line: 456
    -- upvalues: Asserts (copy)
    Asserts.finiteVector2(p82);

    if not u81:_isAlive() or os.clock() < u81._screenTapSuppressUntil then
        return;
    end;

    local v83 = os.clock();
    local AbsoluteSize = u81._videoFrame.AbsoluteSize;
    local v84;

    if AbsoluteSize.X > 0 then
        v84 = AbsoluteSize.Y > 0;
    else
        v84 = false;
    end;

    assert(v84, "Treadmill like tap handling requires a non-zero video frame size");

    if u81._lastScreenTapTime ~= nil and (u81._lastScreenTapPosition ~= nil and (v83 - u81._lastScreenTapTime <= 0.25 and Vector2.new((p82.X - u81._lastScreenTapPosition.X) * AbsoluteSize.X, (p82.Y - u81._lastScreenTapPosition.Y) * AbsoluteSize.Y).Magnitude <= 36)) then
        u81._pendingSingleTapSerial = u81._pendingSingleTapSerial + 1;
        u81._lastScreenTapTime = nil;
        u81._lastScreenTapPosition = nil;
        u81:_handleDoubleTap(p82);

        return;
    end;

    u81._pendingSingleTapSerial = u81._pendingSingleTapSerial + 1;
    local _pendingSingleTapSerial = u81._pendingSingleTapSerial;
    u81._lastScreenTapTime = v83;
    u81._lastScreenTapPosition = p82;
    task.delay(0.25, function() -- Line: 492
        -- upvalues: u81 (copy), _pendingSingleTapSerial (copy)
        if not u81:_isAlive() or u81._pendingSingleTapSerial ~= _pendingSingleTapSerial then
            return;
        end;

        u81._lastScreenTapTime = nil;
        u81._lastScreenTapPosition = nil;
        u81._onSingleTap();
    end);
end;

function u1.Destroy(p85) -- Line: 503
    if p85._destroyed then
        return;
    end;

    p85._destroyed = true;
    p85._pendingSingleTapSerial = p85._pendingSingleTapSerial + 1;
    p85._likeSurfaceGui.Enabled = false;
    p85._trove:Destroy();
end;

return u1;