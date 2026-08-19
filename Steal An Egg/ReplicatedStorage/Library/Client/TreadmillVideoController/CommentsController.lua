-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local TextChatService = game:GetService("TextChatService");
local TweenService = game:GetService("TweenService");
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
local VideoCommentsCmds = require(ReplicatedStorage.Library.Client.VideoCommentsCmds);
require(ReplicatedStorage.Library.Client.VideoCommentsCmds.Types.Interface);
require(ReplicatedStorage.Library.Client.TreadmillVideoController.Types.Interface);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local TreadmillMediaCommentsConfig = require(ReplicatedStorage.Library.Modules.TreadmillMediaCommentsConfig);
local TreadmillMediaIdentity = require(ReplicatedStorage.Library.Modules.TreadmillMediaIdentity);
local wcall = require(ReplicatedStorage.Library.Functions.wcall);
local Media = require(script.Parent.Media);
local CommentRenderer = require(script.CommentRenderer);
local PhotoInputController = require(script.PhotoInputController);
require(script.Types.Interface);
local u1 = Color3.fromRGB(232, 158, 158);
local u2 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u3 = Log.new();
local u4 = {};
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = false;
local u9 = {};
local u10 = nil;
local u11 = nil;
local u12 = false;
local u13 = false;
local u14 = false;
local u15 = "";
local u16 = nil;
local u17 = 1;
local u18 = 0;
local u19 = nil;
local u20 = {};
local u21 = nil;
local u22 = {};
local u23 = 0;
local u24 = nil;

local function u26(p25) -- Line: 62
end;

local u27 = nil;
local u28 = nil;
local u29 = 0;
local u30 = nil;

local function u31() -- Line: 67
end;

local u32 = {};

local function trim(p33) -- Line: 76
    return p33:match("^%s*(.-)%s*$") or "";
end;

local function characterCount(p34) -- Line: 80
    local v35 = utf8.len(p34);
    assert(v35 ~= nil, "Comment text must contain valid UTF-8");

    return v35;
end;

local function showTooLongNotification() -- Line: 86
    -- upvalues: Message (copy)
    Message.Top({
        Message = "Your message is too long, please make it shorter!",
        Time = 3,
        ShowShadow = true,
        Color = Color3.new(1, 1, 1)
    });
end;

local function showAlreadyCommentedNotification() -- Line: 95
    -- upvalues: Message (copy)
    Message.Top({
        Message = "You already commented this video.",
        Time = 3,
        ShowShadow = true,
        Color = Color3.new(1, 1, 1)
    });
end;

local function showInvalidImageNotification() -- Line: 104
    -- upvalues: Message (copy)
    Message.Top({
        Message = "Invalid image, please upload another image.",
        Time = 3,
        ShowShadow = true,
        Color = Color3.new(1, 1, 1)
    });
end;

local function showImageLookupFailedNotification() -- Line: 113
    -- upvalues: Message (copy)
    Message.Top({
        Message = "Something went wrong, please try again later.",
        Time = 3,
        ShowShadow = true,
        Color = Color3.new(1, 1, 1)
    });
end;

local function showPostRateLimitNotification() -- Line: 122
    -- upvalues: Message (copy)
    Message.Top({
        Message = "You\'re doing this too fast, please wait a bit.",
        Time = 3,
        ShowShadow = true,
        Color = Color3.new(1, 1, 1)
    });
end;

local function showFilteredCommentNotification() -- Line: 131
    -- upvalues: Message (copy)
    Message.Top({
        Message = "Your comment was filtered, please try another message!",
        Time = 3,
        ShowShadow = true,
        Color = Color3.new(1, 1, 1)
    });
end;

local function isRateLimitError(p36) -- Line: 140
    return p36 == "You\'re doing that too fast!" and true or p36 == "You\'re on cooldown. Please try again later.";
end;

local function formatCommentsTitle(p37) -- Line: 144
    -- upvalues: Simple (copy)
    return p37 == 1 and "1 comment" or `{Simple.FormatCompact(p37, ".#")} comments`;
end;

local function projectCount(p38) -- Line: 148
    -- upvalues: u29 (ref), u27 (ref), Simple (copy), u28 (ref)
    u29 = math.max(0, p38);
    u27.Text = Simple.FormatCompact(u29, ".#");
    local v39 = u29;
    u28.Sheet.Header.Content.SubContent.Title.Text = v39 == 1 and "1 comment" or `{Simple.FormatCompact(v39, ".#")} comments`;
end;

local function updateEmptyState() -- Line: 154
    -- upvalues: u22 (copy), u13 (ref), u6 (ref), u19 (ref)
    local v40;

    if next(u22) == nil then
        v40 = not u13;
    else
        v40 = false;
    end;

    u6.Visible = not v40;
    u19.Visible = v40;
end;

local function clearRows() -- Line: 160
    -- upvalues: u22 (copy), u4 (copy), u20 (copy), u17 (ref), u18 (ref), u6 (ref)
    for i, v in u22 do
        v.Destroy();
        u22[i] = nil;
    end;

    table.clear(u4);
    table.clear(u20);
    u17 = 1;
    u18 = 0;
    u6.CanvasPosition = Vector2.zero;
end;

local function renderComment(p41, p42) -- Line: 173
    -- upvalues: u22 (copy), u4 (copy), CommentRenderer (copy), u24 (ref), u6 (ref), u32 (copy)
    if u22[p41.Id] ~= nil then
        return;
    end;

    u4[p41.Id] = p41;
    u22[p41.Id] = CommentRenderer.Create(u24, u6, p41, p42, u32.ToggleLike);
end;

local function requestPage() -- Line: 183
    -- upvalues: u12 (ref), u13 (ref), u8 (ref), u16 (ref), u15 (ref), u22 (copy), u6 (ref), u19 (ref), u23 (ref), VideoCommentsCmds (copy), TreadmillMediaCommentsConfig (copy), u3 (copy), u17 (ref), u4 (copy), CommentRenderer (copy), u24 (ref), u32 (copy)
    if not u12 or (u13 or (not u8 or (u16 == nil or u15 == ""))) then
        return;
    end;

    u13 = true;
    local v43;

    if next(u22) == nil then
        v43 = not u13;
    else
        v43 = false;
    end;

    u6.Visible = not v43;
    u19.Visible = v43;
    local u44 = u16;
    local u45 = u23;
    local u46 = u15;
    task.spawn(function() -- Line: 193
        -- upvalues: VideoCommentsCmds (ref), u46 (copy), u44 (copy), TreadmillMediaCommentsConfig (ref), u12 (ref), u45 (copy), u23 (ref), u13 (ref), u8 (ref), u16 (ref), u22 (ref), u6 (ref), u19 (ref), u3 (ref), u17 (ref), u4 (ref), CommentRenderer (ref), u24 (ref), u32 (ref)
        local v47 = VideoCommentsCmds.RequestCommentPage(u46, u44, TreadmillMediaCommentsConfig.COMMENT_PAGE_SIZE);

        if not u12 or u45 ~= u23 then
            return;
        end;

        u13 = false;

        if not v47.Ok then
            u8 = false;
            u16 = nil;
            local v48;

            if next(u22) == nil then
                v48 = not u13;
            else
                v48 = false;
            end;

            u6.Visible = not v48;
            u19.Visible = v48;
            u3:AtTrace():Log((`Unable to load treadmill comments: {v47.Error}`));

            return;
        end;

        VideoCommentsCmds.ReconcileCommentCount(u46, v47.TotalCreatedCount);

        for _, v in v47.Comments do
            local v49 = u17;

            if u22[v.Id] == nil then
                u4[v.Id] = v;
                u22[v.Id] = CommentRenderer.Create(u24, u6, v, v49, u32.ToggleLike);
            end;

            u17 = u17 + 1;
        end;

        u16 = v47.NextCursor;
        u8 = v47.NextCursor ~= nil;
        local v50;

        if next(u22) == nil then
            v50 = not u13;
        else
            v50 = false;
        end;

        u6.Visible = not v50;
        u19.Visible = v50;
    end);
end;

local function requestInitialPage() -- Line: 221
    -- upvalues: u23 (ref), u16 (ref), u8 (ref), u13 (ref), requestPage (copy)
    u23 = u23 + 1;
    u16 = 0;
    u8 = true;
    u13 = false;
    requestPage();
end;

local function updateInputLimitPresentation() -- Line: 229
    -- upvalues: u10 (ref), TreadmillMediaCommentsConfig (copy), u1 (copy), u7 (ref), u11 (ref), TweenService (copy), u2 (copy)
    local v51 = utf8.len(u10.Text);
    assert(v51 ~= nil, "Comment text must contain valid UTF-8");
    local v52;

    if TreadmillMediaCommentsConfig.MAX_COMMENT_CHARACTERS <= v51 then
        v52 = u1;
    else
        v52 = u7;
    end;

    if u11 ~= nil then
        u11:Cancel();
    end;

    local v53 = TweenService:Create(u10, u2, {
        BackgroundColor3 = v52
    });
    u11 = v53;
    v53:Play();
end;

local function postComment() -- Line: 242
    -- upvalues: u14 (ref), u15 (ref), u9 (copy), Message (copy), u31 (ref), u10 (ref), TreadmillMediaCommentsConfig (copy), u21 (ref), u23 (ref), VideoCommentsCmds (copy), u3 (copy), u18 (ref), u22 (copy), u4 (copy), CommentRenderer (copy), u24 (ref), u6 (ref), u32 (copy), u29 (ref), u13 (ref), u19 (ref)
    if u14 or u15 == "" then
        return;
    end;

    if u9[u15] then
        Message.Top({
            Message = "You already commented this video.",
            Time = 3,
            ShowShadow = true,
            Color = Color3.new(1, 1, 1)
        });

        return;
    end;

    u31();
    local Text = u10.Text;
    local v54 = utf8.len(Text);
    assert(v54 ~= nil, "Comment text must contain valid UTF-8");

    if TreadmillMediaCommentsConfig.MAX_COMMENT_CHARACTERS < v54 then
        Message.Top({
            Message = "Your message is too long, please make it shorter!",
            Time = 3,
            ShowShadow = true,
            Color = Color3.new(1, 1, 1)
        });

        return;
    end;

    local u55 = Text:match("^%s*(.-)%s*$") or "";
    local u56 = u21:GetImageAssetId();

    if u55 == "" and u56 == nil then
        return;
    end;

    u14 = true;
    local u57 = u23;
    local u58 = u15;
    task.spawn(function() -- Line: 268
        -- upvalues: VideoCommentsCmds (ref), u58 (copy), u55 (copy), u56 (copy), u57 (copy), u23 (ref), u14 (ref), u9 (ref), Message (ref), u3 (ref), u10 (ref), u21 (ref), u18 (ref), u22 (ref), u4 (ref), CommentRenderer (ref), u24 (ref), u6 (ref), u32 (ref), u29 (ref), u13 (ref), u19 (ref)
        local v59 = VideoCommentsCmds.PostComment(u58, u55, u56);

        if u57 ~= u23 then
            return;
        end;

        u14 = false;

        if not v59.Ok then
            if v59.Error == "AlreadyCommented" then
                u9[u58] = true;
                Message.Top({
                    Message = "You already commented this video.",
                    Time = 3,
                    ShowShadow = true,
                    Color = Color3.new(1, 1, 1)
                });
            elseif v59.Error == "MessageFiltered" then
                Message.Top({
                    Message = "Your comment was filtered, please try another message!",
                    Time = 3,
                    ShowShadow = true,
                    Color = Color3.new(1, 1, 1)
                });
            elseif v59.Error == "InvalidImageAssetId" then
                Message.Top({
                    Message = "Invalid image, please upload another image.",
                    Time = 3,
                    ShowShadow = true,
                    Color = Color3.new(1, 1, 1)
                });
            elseif v59.Error == "ImageAssetLookupFailed" then
                Message.Top({
                    Message = "Something went wrong, please try again later.",
                    Time = 3,
                    ShowShadow = true,
                    Color = Color3.new(1, 1, 1)
                });
            else
                local Error = v59.Error;

                if Error == "You\'re doing that too fast!" and true or Error == "You\'re on cooldown. Please try again later." then
                    Message.Top({
                        Message = "You\'re doing this too fast, please wait a bit.",
                        Time = 3,
                        ShowShadow = true,
                        Color = Color3.new(1, 1, 1)
                    });
                end;
            end;

            u3:AtTrace():Log((`Unable to post treadmill comment: {v59.Error}`));

            return;
        end;

        u9[u58] = true;
        u10.Text = "";
        u21:Reset();
        u18 = u18 - 1;
        local Comment = v59.Comment;
        local v60 = u18;

        if u22[Comment.Id] == nil then
            u4[Comment.Id] = Comment;
            u22[Comment.Id] = CommentRenderer.Create(u24, u6, Comment, v60, u32.ToggleLike);
        end;

        VideoCommentsCmds.ReconcileCommentCount(u58, u29 + 1);
        local v61;

        if next(u22) == nil then
            v61 = not u13;
        else
            v61 = false;
        end;

        u6.Visible = not v61;
        u19.Visible = v61;
        u6.CanvasPosition = Vector2.zero;
    end);
end;

local function open() -- Line: 304
    -- upvalues: u12 (ref), u15 (ref), u31 (ref), u28 (ref), u26 (ref), clearRows (copy), u22 (copy), u13 (ref), u6 (ref), u19 (ref), u23 (ref), u16 (ref), u8 (ref), requestPage (copy)
    if u12 or u15 == "" then
        return;
    end;

    u31();
    u12 = true;
    u28.Visible = true;
    u26(false);
    clearRows();
    local v62;

    if next(u22) == nil then
        v62 = not u13;
    else
        v62 = false;
    end;

    u6.Visible = not v62;
    u19.Visible = v62;
    u23 = u23 + 1;
    u16 = 0;
    u8 = true;
    u13 = false;
    requestPage();
end;

local function handleScroll() -- Line: 318
    -- upvalues: u12 (ref), u8 (ref), u6 (ref), requestPage (copy)
    if not (u12 and u8) then
        return;
    end;

    if u6.AbsoluteCanvasSize.Y - u6.CanvasPosition.Y - u6.AbsoluteWindowSize.Y <= 64 then
        requestPage();
    end;
end;

local function handleMediaChanged(p63, p64) -- Line: 329
    -- upvalues: TreadmillMediaIdentity (copy), u32 (copy), u5 (ref), u15 (ref), VideoCommentsCmds (copy), u29 (ref), u27 (ref), Simple (copy), u28 (ref)
    local v65 = TreadmillMediaIdentity.GetMediaKey(p63);
    u32.Close();
    u5.Adornee = p64;
    u5.Enabled = true;
    u15 = v65;
    local v66 = VideoCommentsCmds.GetCachedCommentCount(v65) or 0;
    u29 = math.max(0, v66);
    u27.Text = Simple.FormatCompact(u29, ".#");
    local v67 = u29;
    u28.Sheet.Header.Content.SubContent.Title.Text = v67 == 1 and "1 comment" or `{Simple.FormatCompact(v67, ".#")} comments`;
end;

function u32.ToggleLike(u68) -- Line: 342
    -- upvalues: u20 (copy), u4 (copy), u22 (copy), u31 (ref), u23 (ref), u15 (ref), VideoCommentsCmds (copy)
    if u20[u68] then
        return;
    end;

    local v69 = u4[u68];
    local v70 = u22[u68];
    local v71;

    if v69 == nil then
        v71 = false;
    else
        v71 = v70 ~= nil;
    end;

    local v72 = `Missing rendered comment {u68}`;
    assert(v71, v72);
    u31();
    u20[u68] = true;
    local LikedByViewer = v69.LikedByViewer;
    local LikeCount = v69.LikeCount;
    local u73 = not LikedByViewer;
    v69.LikedByViewer = u73;
    v69.LikeCount = math.max(0, LikeCount + (u73 and 1 or -1));
    v70.UpdateLike(v69.LikedByViewer, v69.LikeCount);
    local u74 = u23;
    local u75 = u15;
    task.spawn(function() -- Line: 362
        -- upvalues: VideoCommentsCmds (ref), u75 (copy), u68 (copy), u73 (copy), u74 (copy), u23 (ref), u20 (ref), u4 (ref), u22 (ref), LikedByViewer (copy), LikeCount (copy)
        local v76 = VideoCommentsCmds.SetCommentLike(u75, u68, u73);

        if u74 ~= u23 then
            return;
        end;

        u20[u68] = nil;
        local v77 = u4[u68];
        local v78 = u22[u68];

        if v77 == nil or v78 == nil then
            return;
        end;

        if v76.Ok then
            v77.LikedByViewer = v76.Liked;
            v77.LikeCount = math.max(0, v76.LikeCount);
        else
            v77.LikedByViewer = LikedByViewer;
            v77.LikeCount = LikeCount;
        end;

        v78.UpdateLike(v77.LikedByViewer, v77.LikeCount);
    end);
end;

function u32.Close() -- Line: 386
    -- upvalues: u23 (ref), u12 (ref), u13 (ref), u14 (ref), u8 (ref), u16 (ref), u28 (ref), u26 (ref), u10 (ref), u21 (ref), clearRows (copy), u22 (copy), u6 (ref), u19 (ref)
    u23 = u23 + 1;
    u12 = false;
    u13 = false;
    u14 = false;
    u8 = false;
    u16 = nil;
    u28.Visible = false;
    u26(true);
    u10.Text = "";
    u21:Reset();
    clearRows();
    local v79;

    if next(u22) == nil then
        v79 = not u13;
    else
        v79 = false;
    end;

    u6.Visible = not v79;
    u19.Visible = v79;
end;

function u32.IsAvailable() -- Line: 401
    -- upvalues: u30 (ref)
    return u30 ~= nil;
end;

function u32.Toggle() -- Line: 405
    -- upvalues: u30 (ref), u12 (ref), u15 (ref), u31 (ref), u28 (ref), u26 (ref), clearRows (copy), u22 (copy), u13 (ref), u6 (ref), u19 (ref), u23 (ref), u16 (ref), u8 (ref), requestPage (copy), u32 (copy)
    if u30 == nil then
        return;
    end;

    if not u12 then
        if not u12 then
            if u15 == "" then
                return;
            end;

            u31();
            u12 = true;
            u28.Visible = true;
            u26(false);
            clearRows();
            local v80;

            if next(u22) == nil then
                v80 = not u13;
            else
                v80 = false;
            end;

            u6.Visible = not v80;
            u19.Visible = v80;
            u23 = u23 + 1;
            u16 = 0;
            u8 = true;
            u13 = false;
            requestPage();
        end;

        return;
    end;

    u31();
    u32.Close();
end;

function u32.Deactivate() -- Line: 419
    -- upvalues: u32 (copy), u15 (ref), u5 (ref), u29 (ref), u27 (ref), Simple (copy), u28 (ref)
    u32.Close();
    u15 = "";
    u5.Enabled = false;
    u29 = 0;
    u27.Text = Simple.FormatCompact(u29, ".#");
    local v81 = u29;
    u28.Sheet.Header.Content.SubContent.Title.Text = v81 == 1 and "1 comment" or `{Simple.FormatCompact(v81, ".#")} comments`;
end;

function u32.Start(p82) -- Line: 426
    -- upvalues: u30 (ref), GUI (copy), wcall (copy), TextChatService (copy), Players (copy), u26 (ref), u31 (ref), u5 (ref), u28 (ref), u6 (ref), u24 (ref), u10 (ref), u7 (ref), u19 (ref), u21 (ref), PhotoInputController (copy), u27 (ref), Trove (copy), ButtonFX (copy), open (copy), u32 (copy), postComment (copy), updateInputLimitPresentation (copy), handleScroll (copy), handleMediaChanged (copy), VideoCommentsCmds (copy), u15 (ref), u29 (ref), Simple (copy), TreadmillMediaIdentity (copy), Media (copy), u22 (copy), u13 (ref)
    assert(u30 == nil, "Treadmill comments controller must only start once");
    local CommentsButton = GUI.TreadmillScreenSideButtons().Frame.Buttons.CommentsButton;
    local v83 = GUI.TreadmillScreenButtonShare();
    local v84 = v83:IsA("SurfaceGui");
    assert(v84, "Treadmill share GUI must be a SurfaceGui");
    local ShareButton = v83.Frame.ShareButton;
    local v85 = CommentsButton:IsA("GuiButton");
    assert(v85, "Treadmill comments button must be a GuiButton");
    local v86 = ShareButton:IsA("GuiButton");
    assert(v86, "Treadmill share button must be a GuiButton");
    local v87, v88 = wcall(TextChatService.CanUserChatAsync, TextChatService, Players.LocalPlayer.UserId);

    if v87 then
        v87 = v88 == true;
    end;

    CommentsButton.Visible = v87;

    if not CommentsButton.Visible then
        ShareButton.Position = UDim2.fromScale(0.98, 0.65);

        return;
    end;

    u26 = p82.SetShareButtonVisible;
    u31 = p82.SuppressScreenTap;
    u5 = GUI.TreadmillScreenComments();
    u28 = u5.Frame.CommentsTemplate;
    u6 = u28.Sheet.Content;
    u24 = u6.Comment_01;
    u10 = u28.Sheet.Actions.Content.TextInputWrapper.TextInput;
    local v89 = u5:IsA("SurfaceGui");
    assert(v89, "Treadmill comments GUI must be a SurfaceGui");
    local v90 = u6:IsA("ScrollingFrame");
    assert(v90, "Treadmill comments content must be a ScrollingFrame");
    local v91 = u24:IsA("Frame");
    assert(v91, "Treadmill comments row template must be a Frame");
    local v92 = CommentsButton.CommentsCount:IsA("TextLabel");
    assert(v92, "Treadmill comments count must be a TextLabel");
    u7 = u10.BackgroundColor3;
    u19 = u28.Sheet.NoComments;
    u21 = PhotoInputController.new(u28, u31);
    u27 = CommentsButton.CommentsCount;
    u30 = Trove.new();

    for _, child in u6:GetChildren() do
        if child:IsA("Frame") and child.Name:match("^Comment_%d+$") then
            if child.Name == "Comment_01" then
                child.Visible = false;
            else
                child:Destroy();
            end;
        end;
    end;

    u6.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    u5.Enabled = false;
    u28.Visible = false;
    u28.Overlay.Active = true;
    u28.AddPhoto.Visible = false;
    local v93 = u30;
    assert(v93 ~= nil, "Treadmill comments trove must exist after startup");
    v93:Add(ButtonFX(CommentsButton, nil, open));
    v93:Add(ButtonFX(u28.Sheet.Header.Content.Close, nil, function() -- Line: 482
        -- upvalues: u31 (ref), u32 (ref)
        u31();
        u32.Close();
    end));
    v93:Connect(u28.Overlay.InputBegan, function(p94) -- Line: 486
        -- upvalues: u28 (ref), u31 (ref), u32 (ref)
        if (p94.UserInputType == Enum.UserInputType.MouseButton1 or p94.UserInputType == Enum.UserInputType.Touch) and p94.Position.Y < u28.Sheet.AbsolutePosition.Y then
            u31();
            u32.Close();
        end;
    end);
    v93:Add(ButtonFX(u28.Sheet.Actions.Content.Send, nil, postComment));
    v93:Connect(u10:GetPropertyChangedSignal("Text"), updateInputLimitPresentation);
    v93:Connect(u6:GetPropertyChangedSignal("CanvasPosition"), handleScroll);
    v93:Add(p82.MediaChanged:Connect(handleMediaChanged));
    v93:Add(p82.Stopped:Connect(u32.Deactivate));
    v93:Add(VideoCommentsCmds.CommentCountChanged:Connect(function(p95, p96) -- Line: 500
        -- upvalues: u15 (ref), u29 (ref), u27 (ref), Simple (ref), u28 (ref)
        if p95 == u15 then
            u29 = math.max(0, p96);
            u27.Text = Simple.FormatCompact(u29, ".#");
            local v97 = u29;
            u28.Sheet.Header.Content.SubContent.Title.Text = v97 == 1 and "1 comment" or `{Simple.FormatCompact(v97, ".#")} comments`;
        end;
    end));
    local v98 = TreadmillMediaIdentity.BuildMediaKeys(Media);
    VideoCommentsCmds.StartCommentCountCache(v98);
    u29 = 0;
    u27.Text = Simple.FormatCompact(u29, ".#");
    local v99 = u29;
    u28.Sheet.Header.Content.SubContent.Title.Text = v99 == 1 and "1 comment" or `{Simple.FormatCompact(v99, ".#")} comments`;
    local v100;

    if next(u22) == nil then
        v100 = not u13;
    else
        v100 = false;
    end;

    u6.Visible = not v100;
    u19.Visible = v100;
end;

return u32;