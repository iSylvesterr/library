-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TextService = game:GetService("TextService");
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local GetDisplayNameFromUserIdAsync = require(ReplicatedStorage.Library.Functions.GetDisplayNameFromUserIdAsync);
local GetThumbnailFromUserIdAsync = require(ReplicatedStorage.Library.Functions.GetThumbnailFromUserIdAsync);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
require(script.Parent.Types.Interface);
require(ReplicatedStorage.Library.Client.VideoCommentsCmds.Types.Interface);
local u1 = Color3.fromRGB(232, 68, 86);
local u2 = Color3.fromRGB(255, 255, 255);
local u3 = Log.new();
local v4 = {};

local function formatPostedAt(p5) -- Line: 38
    local v6 = os.time() - p5;
    local v7 = math.max(0, v6);

    if v7 < 60 then
        return "just now";
    end;

    if v7 < 3600 then
        return `{math.floor(v7 / 60)}m ago`;
    end;

    if v7 < 86400 then
        return `{math.floor(v7 / 3600)}h ago`;
    end;

    return `{math.floor(v7 / 86400)}d ago`;
end;

local function fitDisplayName(p8, p9) -- Line: 55
    -- upvalues: TextService (copy)
    p8.Text = p9;
    p8.AutomaticSize = Enum.AutomaticSize.X;
    p8.TextTruncate = Enum.TextTruncate.AtEnd;
    local X = TextService:GetTextSize(p9, p8.TextSize, p8.Font, Vector2.new((1 / 0), p8.AbsoluteSize.Y)).X;
    local v10 = math.ceil(X) + 2;
    local v11 = math.min(v10, 140);
    p8.Size = UDim2.new(0, v11, p8.Size.Y.Scale, p8.Size.Y.Offset);
end;

local function configureDynamicLayout(p12) -- Line: 70
    p12.AutomaticSize = Enum.AutomaticSize.Y;
    p12.Size = UDim2.fromScale(1, 0);
    p12.Content.AutomaticSize = Enum.AutomaticSize.Y;
    p12.Content.Size = UDim2.new(p12.Content.Size.X.Scale, p12.Content.Size.X.Offset, 0, 0);
    p12.Content.Comment.AutomaticSize = Enum.AutomaticSize.Y;
    p12.Content.Comment.Size = UDim2.fromScale(1, 0);
    p12.Content.Comment.TextWrapped = true;
end;

local function configureOwnerPresentation(p13, p14, p15) -- Line: 80
    -- upvalues: u2 (copy)
    local DisplayName = p13.Content.User.DisplayName;
    p13.Content.User.OwnerTag.Visible = p14;
    DisplayName.OwnerGradient.Enabled = p14;
    DisplayName.OwnerStroke.Enabled = p14;

    if p14 then
        p15 = u2;
    end;

    DisplayName.TextColor3 = p15;
end;

local function loadUserPresentation(u16, u17) -- Line: 92
    -- upvalues: fitDisplayName (copy), GetDisplayNameFromUserIdAsync (copy), Constants (copy), u3 (copy), GetThumbnailFromUserIdAsync (copy)
    fitDisplayName(u16.Content.User.DisplayName, "Loading...");
    task.spawn(function() -- Line: 94
        -- upvalues: GetDisplayNameFromUserIdAsync (ref), u17 (copy), u16 (copy), Constants (ref), fitDisplayName (ref), u3 (ref)
        local success, result = pcall(GetDisplayNameFromUserIdAsync, u17);

        if u16.Parent == nil then
            return;
        end;

        if not success then
            u3:AtTrace():Log((`Failed to resolve comment display name for user {u17}`));

            return;
        end;

        if u17 == Constants.OWNER_ID then
            result = `{result}`;
        end;

        fitDisplayName(u16.Content.User.DisplayName, result);
    end);
    task.spawn(function() -- Line: 108
        -- upvalues: GetThumbnailFromUserIdAsync (ref), u17 (copy), u16 (copy), u3 (ref)
        local success, result = pcall(GetThumbnailFromUserIdAsync, u17, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150);

        if u16.Parent == nil then
            return;
        end;

        if success and result ~= nil then
            u16.Avatar.Image = result;

            return;
        end;

        u3:AtTrace():Log((`Failed to resolve comment avatar for user {u17}`));
    end);
end;

function v4.Create(p18, p19, u20, p21, u22) -- Line: 127
    -- upvalues: Trove (copy), formatPostedAt (copy), configureDynamicLayout (copy), Constants (copy), u2 (copy), u1 (copy), Simple (copy), loadUserPresentation (copy), ButtonFX (copy)
    local v23 = p18:Clone();
    v23.Name = `Comment_{u20.Id}`;
    v23.LayoutOrder = p21;
    v23.Visible = true;
    v23.Parent = p19;
    local Content = v23.Content;
    local PostedAt = Content.Actions.Left.PostedAt;
    local Like = Content.Actions.Right.Like;
    local Icon = Like.Icon;
    local TextColor3 = Icon.TextColor3;
    local FontFace = Icon.FontFace;
    local TextColor32 = Content.User.DisplayName.TextColor3;
    local u24 = Trove.new();
    PostedAt.LayoutOrder = Content.User.DisplayName.LayoutOrder + 1;
    Content.Comment.Text = u20.Message;
    PostedAt.Text = formatPostedAt(u20.CreatedAt);
    configureDynamicLayout(v23);
    local v25 = u20.UserId == Constants.OWNER_ID;
    local DisplayName = v23.Content.User.DisplayName;
    v23.Content.User.OwnerTag.Visible = v25;
    DisplayName.OwnerGradient.Enabled = v25;
    DisplayName.OwnerStroke.Enabled = v25;

    if v25 then
        TextColor32 = u2;
    end;

    DisplayName.TextColor3 = TextColor32;

    if u20.ImageAssetId == nil then
        Content.Photo.Visible = false;
    else
        Content.Photo.Visible = true;
        Content.Photo.Container.Image.Image = `rbxassetid://{u20.ImageAssetId}`;
        Content.Photo.Container.Image.ScaleType = Enum.ScaleType.Crop;
    end;

    local function updateLike(p26, p27) -- Line: 163
        -- upvalues: Icon (copy), u1 (ref), TextColor3 (copy), FontFace (copy), Like (copy), Simple (ref)
        local v28;

        if p26 then
            v28 = u1;
        else
            v28 = TextColor3;
        end;

        Icon.TextColor3 = v28;
        local v29;

        if p26 then
            v29 = Font.new(FontFace.Family, Enum.FontWeight.Bold, FontFace.Style);
        else
            v29 = FontFace;
        end;

        Icon.FontFace = v29;
        Like.Label.Text = Simple.FormatCompact(math.max(0, p27), ".#");
    end;

    local LikedByViewer = u20.LikedByViewer;
    local LikeCount = u20.LikeCount;

    if LikedByViewer then
        TextColor3 = u1;
    end;

    Icon.TextColor3 = TextColor3;

    if LikedByViewer then
        FontFace = Font.new(FontFace.Family, Enum.FontWeight.Bold, FontFace.Style);
    end;

    Icon.FontFace = FontFace;
    Like.Label.Text = Simple.FormatCompact(math.max(0, LikeCount), ".#");
    loadUserPresentation(v23, u20.UserId);
    u24:Add(ButtonFX(Like, nil, function() -- Line: 173
        -- upvalues: u22 (copy), u20 (copy)
        u22(u20.Id);
    end));
    u24:Add(v23);

    return {
        Row = v23,
        UpdateLike = updateLike,

        Destroy = function() -- Line: 181, Name: Destroy
            -- upvalues: u24 (copy)
            u24:Destroy();
        end
    };
end;

return v4;