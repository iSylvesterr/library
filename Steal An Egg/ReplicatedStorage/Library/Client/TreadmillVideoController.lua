-- Decompiled with Potassium's decompiler.

local ContextActionService = game:GetService("ContextActionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SocialService = game:GetService("SocialService");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local Workspace = game:GetService("Workspace");
local ActionPromptCmds = require(ReplicatedStorage.Library.Client.ActionPromptCmds);
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local CommentsController = require(script.CommentsController);
local ConsoleCmds = require(ReplicatedStorage.Library.Client.ConsoleCmds);
local FriendLikesController = require(script.FriendLikesController);
local Signal = require(ReplicatedStorage.Library.Signal);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local ImageColorPulse = require(ReplicatedStorage.Library.Client.GUIFX.ImageColorPulse);
local LikeController = require(script.LikeController);
local Network = require(ReplicatedStorage.Library.Client.Network);
local PreloadAssets = require(ReplicatedStorage.Library.Functions.PreloadAssets);
local PreloadSounds = require(ReplicatedStorage.Library.Functions.PreloadSounds);
local ScaleUDim2 = require(ReplicatedStorage.Library.Functions.ScaleUDim2);
local wcall = require(ReplicatedStorage.Library.Functions.wcall);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Signal2 = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local RuntimeInstanceRegistry = require(ReplicatedStorage.Library.Modules.RuntimeInstanceRegistry);
local TreadmillUtil = require(ReplicatedStorage.Library.Util.TreadmillUtil);
local TouchTapTracker = require(ReplicatedStorage.Library.Client.Input.TouchTapTracker);
local Variables = require(ReplicatedStorage.Library.Variables);
local FeedSequencer = require(script.FeedSequencer);
require(script.Types.Interface);
local Schema = require(script.Types.Schema);
local Media = require(script.Media);
local VideoFramePool = require(script.VideoFramePool);
local Treadmills = Constants.NETWORK_MAP.Treadmills;
local u1 = TweenInfo.new(0.75, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false);
local Value = Enum.ContextActionPriority.High.Value;
local ButtonL2 = Enum.KeyCode.ButtonL2;
local ButtonR2 = Enum.KeyCode.ButtonR2;
local u2 = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local u3 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local u4 = Color3.fromRGB(255, 0, 0);
local u5 = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true);
task.spawn(PreloadSounds, "rbxassetid://84371411600743", "rbxassetid://90908618020821");
local LocalPlayer = Players.LocalPlayer;
local u6 = Log.new();
local u7 = GUI.TreadmillScreenButtonSwapLeft();
local v8 = u7:IsA("SurfaceGui");
assert(v8, "Treadmill left swap GUI must be a SurfaceGui");
local u9 = GUI.TreadmillScreenButtonSwapRight();
local v10 = u9:IsA("SurfaceGui");
assert(v10, "Treadmill right swap GUI must be a SurfaceGui");
local u11 = GUI.TreadmillScreenButtonShare();
local v12 = u11:IsA("SurfaceGui");
assert(v12, "Treadmill share GUI must be a SurfaceGui");
local u13 = GUI.TreadmillScreenSideButtons();
local v14 = u13:IsA("SurfaceGui");
assert(v14, "Treadmill side buttons GUI must be a SurfaceGui");
local u15 = GUI.TreadmillVideoSurfaceGui();
local v16 = u15:IsA("SurfaceGui");
assert(v16, "Treadmill video GUI must be a SurfaceGui");
local ButtonSwapLeft = u7.ButtonSwapLeft;
local v17 = ButtonSwapLeft:IsA("GuiButton");
assert(v17, "Treadmill left swap button must be a GuiButton");
local ButtonSwapRight = u9.ButtonSwapRight;
local v18 = ButtonSwapRight:IsA("ImageButton");
assert(v18, "Treadmill right swap button must be an ImageButton");
local ConsoleButton = u7.ButtonSwapLeft.ConsoleButton;
local v19 = ConsoleButton:IsA("GuiObject");
assert(v19, "Treadmill left swap ConsoleButton must be a GuiObject");
local v20 = ConsoleButton:GetAttribute("ConsoleButton") == "ButtonLB";
assert(v20, "Treadmill left swap ConsoleButton must use ButtonLB");
local ConsoleButton2 = u9.ButtonSwapRight.ConsoleButton;
local v21 = ConsoleButton2:IsA("GuiObject");
assert(v21, "Treadmill right swap ConsoleButton must be a GuiObject");
local v22 = ConsoleButton2:GetAttribute("ConsoleButton") == "ButtonRB";
assert(v22, "Treadmill right swap ConsoleButton must use ButtonRB");
local ShareButton = u11.Frame.ShareButton;
local v23 = ShareButton:IsA("GuiButton");
assert(v23, "Treadmill share button must be a GuiButton");
local VideoFrame = u15.VideoFrame;
local v24 = VideoFrame:IsA("Frame");
assert(v24, "Treadmill video frame container must be a Frame");
local MainVideo = VideoFrame.MainVideo;
local v25 = MainVideo:IsA("VideoFrame");
assert(v25, "Treadmill main video must be a VideoFrame");
local StopPlay = VideoFrame.StopPlay;
local v26 = StopPlay:IsA("ImageLabel");
assert(v26, "Treadmill stop-play indicator must be an ImageLabel");
local MusicImage = VideoFrame.MusicImage;
local v27 = MusicImage:IsA("ImageLabel");
assert(v27, "Treadmill music image must be an ImageLabel");
local Loading = VideoFrame.Loading;
local v28 = Loading:IsA("GuiObject");
assert(v28, "Treadmill video loading frame must be a GuiObject");
local Spin = Loading.Spin;
local v29 = Spin:IsA("GuiObject");
assert(v29, "Treadmill video loading spinner must be a GuiObject");
local Bar = VideoFrame.Bar;
local v30 = Bar:IsA("GuiObject");
assert(v30, "Treadmill video bar must be a GuiObject");
local Progress = Bar.Progress;
local v31 = Progress:IsA("GuiObject");
assert(v31, "Treadmill video progress must be a GuiObject");
local u32 = 0;
local u33 = nil;
local u34 = nil;
local u35 = table.clone(Media);

if Constants.IS_STUDIO then
    local v36, v37 = Schema.TreadmillMediaEntries(u35);
    local v38 = `Failed to validate treadmill video media entries: {v37}`;
    assert(v36, v38);
end;

local u39 = {
    MediaChanged = Signal2.new(),
    Stopped = Signal2.new()
};

local function cancelStopPlayTween(p40) -- Line: 178
    local StopPlayTween = p40.StopPlayTween;
    p40.StopPlayTween = nil;

    if StopPlayTween ~= nil then
        StopPlayTween:Cancel();
    end;
end;

local function resetStopPlayIndicator(p41) -- Line: 186
    local StopPlayTween = p41.StopPlayTween;
    p41.StopPlayTween = nil;

    if StopPlayTween ~= nil then
        StopPlayTween:Cancel();
    end;

    p41.StopPlay.ImageTransparency = 0;
    p41.StopPlay.Size = p41.StopPlayBaseSize;
end;

local function animateStopPlayIndicator(u42, u43) -- Line: 192
    -- upvalues: ScaleUDim2 (copy), TweenService (copy), u2 (copy), u3 (copy)
    local StopPlayTween = u42.StopPlayTween;
    u42.StopPlayTween = nil;

    if StopPlayTween ~= nil then
        StopPlayTween:Cancel();
    end;

    local StopPlay2 = u42.StopPlay;
    StopPlay2.Visible = true;
    StopPlay2.Image = u43 and "rbxassetid://90908618020821" or "rbxassetid://84371411600743";
    StopPlay2.ImageTransparency = 0;
    StopPlay2.Size = ScaleUDim2(u42.StopPlayBaseSize, u43 and 1.24 or 0.76);
    local u44 = TweenService:Create(StopPlay2, u2, {
        Size = u42.StopPlayBaseSize
    });
    u42.StopPlayTween = u44;
    u44.Completed:Once(function() -- Line: 208
        -- upvalues: u42 (copy), u44 (copy), u43 (copy), TweenService (ref), StopPlay2 (copy), u3 (ref)
        if u42.StopPlayTween ~= u44 then
            return;
        end;

        u42.StopPlayTween = nil;

        if not u43 then
            return;
        end;

        local u45 = TweenService:Create(StopPlay2, u3, {
            ImageTransparency = 1
        });
        u42.StopPlayTween = u45;
        u45.Completed:Once(function() -- Line: 222
            -- upvalues: u42 (ref), u45 (copy), StopPlay2 (ref)
            if u42.StopPlayTween ~= u45 then
                return;
            end;

            u42.StopPlayTween = nil;
            StopPlay2.Visible = false;
            StopPlay2.ImageTransparency = 0;
        end);
        u45:Play();
    end);
    u44:Play();
end;

local function setSoundPlaying(p46, p47) -- Line: 236
    if not p47 then
        p46:Pause();

        return;
    end;

    if p46.TimePosition > 0 then
        p46:Resume();

        return;
    end;

    p46:Play();
end;

local function setMediaPlaying(p48, p49, p50) -- Line: 248
    -- upvalues: animateStopPlayIndicator (copy)
    local MusicSound = p48.MusicSound;

    if MusicSound == nil then
        if p49 then
            p48.VideoFramePool.GetActiveFrame():Play();
            local VideoBackgroundMusicSound = p48.VideoBackgroundMusicSound;

            if VideoBackgroundMusicSound ~= nil then
                if VideoBackgroundMusicSound.TimePosition > 0 then
                    VideoBackgroundMusicSound:Resume();
                else
                    VideoBackgroundMusicSound:Play();
                end;
            end;
        else
            p48.VideoFramePool.GetActiveFrame():Pause();
            local VideoBackgroundMusicSound = p48.VideoBackgroundMusicSound;

            if VideoBackgroundMusicSound ~= nil then
                VideoBackgroundMusicSound:Pause();
            end;
        end;
    elseif p49 then
        if MusicSound.TimePosition > 0 then
            MusicSound:Resume();
        else
            MusicSound:Play();
        end;
    else
        MusicSound:Pause();
    end;

    if p50 ~= false then
        animateStopPlayIndicator(p48, p49);

        return;
    end;

    local StopPlayTween = p48.StopPlayTween;
    p48.StopPlayTween = nil;

    if StopPlayTween ~= nil then
        StopPlayTween:Cancel();
    end;

    p48.StopPlay.ImageTransparency = 0;
    p48.StopPlay.Size = p48.StopPlayBaseSize;
    p48.StopPlay.Visible = not p49;
end;

local function getSurfaceHitScale(p51, p52, p53) -- Line: 275
    local v54 = p52 == Enum.NormalId.Front and Vector3.new(0, 0, -1) or (p52 == Enum.NormalId.Back and Vector3.new(0, 0, 1) or (p52 == Enum.NormalId.Right and Vector3.new(1, 0, 0) or (p52 == Enum.NormalId.Left and Vector3.new(-1, 0, 0) or (p52 == Enum.NormalId.Top and Vector3.new(0, 1, 0) or Vector3.new(0, -1, 0)))));
    local Unit = v54:Cross(math.abs(v54.Y) == 1 and Vector3.new(0, 0, 1) or Vector3.new(0, 1, 0)).Unit;
    local Unit2 = Unit:Cross(v54).Unit;
    local v55 = p51.CFrame:PointToObjectSpace(p53);
    local v56 = p51.Size * 0.5;
    local v57 = math.abs(v54.X) * v56.X + math.abs(v54.Y) * v56.Y + math.abs(v54.Z) * v56.Z;
    local v58 = math.abs(Unit.X) * v56.X + math.abs(Unit.Y) * v56.Y + math.abs(Unit.Z) * v56.Z;
    local v59 = math.abs(Unit2.X) * v56.X + math.abs(Unit2.Y) * v56.Y + math.abs(Unit2.Z) * v56.Z;
    local v60 = v55 - v54 * v57;
    local new = Vector2.new;
    local v61 = 0.5 - v60:Dot(Unit) / (v58 * 2);
    local v62 = math.clamp(v61, 0, 1);
    local v63 = 0.5 - v60:Dot(Unit2) / (v59 * 2);

    return new(v62, (math.clamp(v63, 0, 1)));
end;

local function getVideoScreenTapScale(p64, p65) -- Line: 306
    -- upvalues: Workspace (copy), getSurfaceHitScale (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera == nil then
        return nil;
    end;

    local v66 = CurrentCamera:ScreenPointToRay(p65.X, p65.Y);
    local v67 = Workspace:Raycast(v66.Origin, v66.Direction * 1000, p64.VideoScreenRaycastParams);

    if v67 == nil or v67.Instance ~= p64.VideoScreenPart then
        return nil;
    end;

    return getSurfaceHitScale(p64.VideoScreenPart, p64.VideoSurfaceGui.Face, v67.Position);
end;

local function toggleMediaPlaying(p68) -- Line: 322
    -- upvalues: setMediaPlaying (copy)
    local MusicSound = p68.MusicSound;

    if MusicSound == nil then
        setMediaPlaying(p68, not p68.VideoFramePool.GetActiveFrame().Playing);

        return;
    end;

    setMediaPlaying(p68, not MusicSound.IsPlaying);
end;

local function setVideoProgress(p69, p70) -- Line: 332
    local Size = p69.Progress.Size;
    p69.Progress.Size = UDim2.new(math.clamp(p70, 0, 1), 0, Size.Y.Scale, Size.Y.Offset);
end;

local function updateMediaProgress(p71) -- Line: 337
    local MusicSound = p71.MusicSound;

    if MusicSound ~= nil then
        local TimeLength = MusicSound.TimeLength;

        if TimeLength <= 0 then
            local Size = p71.Progress.Size;
            p71.Progress.Size = UDim2.new(0, 0, Size.Y.Scale, Size.Y.Offset);

            return;
        end;

        local Size = p71.Progress.Size;
        p71.Progress.Size = UDim2.new(math.clamp(MusicSound.TimePosition / TimeLength, 0, 1), 0, Size.Y.Scale, Size.Y.Offset);

        return;
    end;

    local v72 = p71.VideoFramePool.GetActiveFrame();
    local TimeLength = v72.TimeLength;

    if TimeLength <= 0 then
        local Size = p71.Progress.Size;
        p71.Progress.Size = UDim2.new(0, 0, Size.Y.Scale, Size.Y.Offset);

        return;
    end;

    local Size = p71.Progress.Size;
    p71.Progress.Size = UDim2.new(math.clamp(v72.TimePosition / TimeLength, 0, 1), 0, Size.Y.Scale, Size.Y.Offset);
end;

local function hideLoading(p73) -- Line: 360
    local LoadingTween = p73.LoadingTween;
    p73.LoadingTween = nil;

    if LoadingTween ~= nil then
        LoadingTween:Cancel();
    end;

    p73.Loading.Visible = false;
    p73.LoadingSpin.Rotation = 0;
end;

local function showLoading(p74) -- Line: 371
    -- upvalues: TweenService (copy), u1 (copy)
    local LoadingTween = p74.LoadingTween;
    p74.LoadingTween = nil;

    if LoadingTween ~= nil then
        LoadingTween:Cancel();
    end;

    p74.Loading.Visible = false;
    p74.LoadingSpin.Rotation = 0;
    p74.Loading.Visible = true;
    p74.ShareSurfaceGui.Enabled = false;
    p74.SideButtonsSurfaceGui.Enabled = false;
    local v75 = TweenService:Create(p74.LoadingSpin, u1, {
        Rotation = 360
    });
    p74.LoadingTween = v75;
    v75:Play();
end;

local function clearMusicImage(p76) -- Line: 384
    p76.MusicImage.Visible = false;
    p76.MusicImage.Image = "";
    local MusicSound = p76.MusicSound;
    p76.MusicSound = nil;

    if MusicSound == nil then
        return;
    end;

    MusicSound:Stop();
    MusicSound:Destroy();
end;

local function clearVideoBackgroundMusic(p77) -- Line: 398
    local VideoBackgroundMusicSound = p77.VideoBackgroundMusicSound;
    p77.VideoBackgroundMusicSound = nil;

    if VideoBackgroundMusicSound == nil then
        return;
    end;

    VideoBackgroundMusicSound:Stop();
    VideoBackgroundMusicSound:Destroy();
end;

local function unloadVideo(p78) -- Line: 409
    p78.VideoTrove:Clean();
    local LoadingTween = p78.LoadingTween;
    p78.LoadingTween = nil;

    if LoadingTween ~= nil then
        LoadingTween:Cancel();
    end;

    p78.Loading.Visible = false;
    p78.LoadingSpin.Rotation = 0;
    p78.MusicImage.Visible = false;
    p78.MusicImage.Image = "";
    local MusicSound = p78.MusicSound;
    p78.MusicSound = nil;

    if MusicSound ~= nil then
        MusicSound:Stop();
        MusicSound:Destroy();
    end;

    local VideoBackgroundMusicSound = p78.VideoBackgroundMusicSound;
    p78.VideoBackgroundMusicSound = nil;

    if VideoBackgroundMusicSound ~= nil then
        VideoBackgroundMusicSound:Stop();
        VideoBackgroundMusicSound:Destroy();
    end;

    p78.VideoFramePool.ClearActive();
    p78.MainVideo.Size = p78.MainVideoBaseSize;
    p78.MainVideo.Volume = 1;
    p78.MainVideo.Video = "";
    local StopPlayTween = p78.StopPlayTween;
    p78.StopPlayTween = nil;

    if StopPlayTween ~= nil then
        StopPlayTween:Cancel();
    end;

    p78.StopPlay.ImageTransparency = 0;
    p78.StopPlay.Size = p78.StopPlayBaseSize;
    p78.StopPlay.Visible = true;
    local Size = p78.Progress.Size;
    p78.Progress.Size = UDim2.new(0, 0, Size.Y.Scale, Size.Y.Offset);
end;

local function wrapVideoIndex(p79) -- Line: 423
    -- upvalues: u35 (copy)
    return p79 < 1 and #u35 or (#u35 < p79 and 1 or p79);
end;

local function preloadDirectionalAssets(p80, p81, p82) -- Line: 435
    -- upvalues: u35 (copy), PreloadAssets (copy)
    if p82 < 0 then
        return;
    end;

    local v83 = {};
    local v84 = {};

    for i = 1, 3 do
        local v85 = p81 + p82 * i;
        local v86;

        if v85 < 1 then
            v86 = #u35;
        else
            v86 = #u35 < v85 and 1 or v85;
        end;

        local v87 = u35[v86];

        if v87.Kind == "Video" then
            table.insert(v84, {
                MediaEntry = v87,
                MediaIndex = v86
            });
            local Music = v87.Music;

            if Music then
                table.insert(v83, Music.SoundId);
            end;
        elseif v87.Kind == "MusicImage" then
            table.insert(v83, v87.Image);
            table.insert(v83, v87.SoundId);
        end;
    end;

    p80.VideoFramePool.Preload(v84);

    if #v83 > 0 then
        task.spawn(PreloadAssets, v83);
    end;
end;

local function loadVideoBackgroundMusic(u88, p89) -- Line: 466
    local Sound = Instance.new("Sound");
    Sound.Name = "TreadmillVideoBackgroundMusic";
    Sound.SoundId = p89.SoundId;
    Sound.Volume = p89.Volume;
    Sound.Looped = true;
    Sound.Parent = u88.MainVideo;
    u88.VideoBackgroundMusicSound = Sound;
    u88.VideoTrove:Add(function() -- Line: 474
        -- upvalues: u88 (copy), Sound (copy)
        if u88.VideoBackgroundMusicSound == Sound then
            u88.VideoBackgroundMusicSound = nil;
        end;

        if Sound.Parent ~= nil then
            Sound:Stop();
            Sound:Destroy();
        end;
    end);
end;

local function resetVideoBackgroundMusic(p90) -- Line: 486
    local VideoBackgroundMusicSound = p90.VideoBackgroundMusicSound;

    if VideoBackgroundMusicSound == nil then
        return;
    end;

    VideoBackgroundMusicSound:Stop();
    VideoBackgroundMusicSound.TimePosition = 0;
end;

local function loadVideoMedia(u91, p92, u93) -- Line: 496
    -- upvalues: loadVideoBackgroundMusic (copy), u32 (ref), showLoading (copy)
    local v94 = u91.VideoFramePool.Activate(u91.VideoIndex, p92);
    v94.Size = p92.Size or u91.MainVideoBaseSize;
    local Size = u91.Progress.Size;
    u91.Progress.Size = UDim2.new(0, 0, Size.Y.Scale, Size.Y.Offset);
    local Music = p92.Music;

    if Music ~= nil then
        loadVideoBackgroundMusic(u91, Music);
    end;

    u91.VideoTrove:Add(v94.Ended:Connect(function() -- Line: 505
        -- upvalues: u32 (ref), u91 (copy), u93 (copy)
        if u32 ~= u91.Token or u91.VideoSerial ~= u93 then
            return;
        end;

        local VideoBackgroundMusicSound = u91.VideoBackgroundMusicSound;

        if VideoBackgroundMusicSound == nil then
            return;
        end;

        VideoBackgroundMusicSound:Stop();
        VideoBackgroundMusicSound.TimePosition = 0;
    end));

    if not v94.IsLoaded then
        u91.StopPlay.Visible = false;
        showLoading(u91);
        local u95 = nil;
        u95 = v94.Loaded:Connect(function() -- Line: 524
            -- upvalues: u32 (ref), u91 (copy), u93 (copy), u95 (ref)
            if u32 ~= u91.Token or u91.VideoSerial ~= u93 then
                return;
            end;

            u95:Disconnect();
            local v96 = u91;
            local LoadingTween = v96.LoadingTween;
            v96.LoadingTween = nil;

            if LoadingTween ~= nil then
                LoadingTween:Cancel();
            end;

            v96.Loading.Visible = false;
            v96.LoadingSpin.Rotation = 0;
            u91.ShareSurfaceGui.Enabled = true;
            u91.SideButtonsSurfaceGui.Enabled = true;
            local v97 = u91;
            local MusicSound = v97.MusicSound;

            if MusicSound == nil then
                v97.VideoFramePool.GetActiveFrame():Play();
                local VideoBackgroundMusicSound = v97.VideoBackgroundMusicSound;

                if VideoBackgroundMusicSound ~= nil then
                    if VideoBackgroundMusicSound.TimePosition > 0 then
                        VideoBackgroundMusicSound:Resume();
                    else
                        VideoBackgroundMusicSound:Play();
                    end;
                end;
            elseif MusicSound.TimePosition > 0 then
                MusicSound:Resume();
            else
                MusicSound:Play();
            end;

            local StopPlayTween = v97.StopPlayTween;
            v97.StopPlayTween = nil;

            if StopPlayTween ~= nil then
                StopPlayTween:Cancel();
            end;

            v97.StopPlay.ImageTransparency = 0;
            v97.StopPlay.Size = v97.StopPlayBaseSize;
            v97.StopPlay.Visible = false;
        end);
        u91.VideoTrove:Add(u95);

        return;
    end;

    local LoadingTween = u91.LoadingTween;
    u91.LoadingTween = nil;

    if LoadingTween ~= nil then
        LoadingTween:Cancel();
    end;

    u91.Loading.Visible = false;
    u91.LoadingSpin.Rotation = 0;
    u91.ShareSurfaceGui.Enabled = true;
    u91.SideButtonsSurfaceGui.Enabled = true;
    local MusicSound = u91.MusicSound;

    if MusicSound == nil then
        u91.VideoFramePool.GetActiveFrame():Play();
        local VideoBackgroundMusicSound = u91.VideoBackgroundMusicSound;

        if VideoBackgroundMusicSound ~= nil then
            if VideoBackgroundMusicSound.TimePosition > 0 then
                VideoBackgroundMusicSound:Resume();
            else
                VideoBackgroundMusicSound:Play();
            end;
        end;
    elseif MusicSound.TimePosition > 0 then
        MusicSound:Resume();
    else
        MusicSound:Play();
    end;

    local StopPlayTween = u91.StopPlayTween;
    u91.StopPlayTween = nil;

    if StopPlayTween ~= nil then
        StopPlayTween:Cancel();
    end;

    u91.StopPlay.ImageTransparency = 0;
    u91.StopPlay.Size = u91.StopPlayBaseSize;
    u91.StopPlay.Visible = false;
end;

local function loadMusicImageMedia(u98, p99, u100) -- Line: 538
    -- upvalues: showLoading (copy), u32 (ref)
    u98.VideoFramePool.ClearActive();
    u98.MainVideo.Video = "";
    u98.MusicImage.Image = p99.Image;
    u98.MusicImage.Visible = true;
    local Size = u98.Progress.Size;
    u98.Progress.Size = UDim2.new(0, 0, Size.Y.Scale, Size.Y.Offset);
    local Sound = Instance.new("Sound");
    Sound.Name = "TreadmillMusicImageSound";
    Sound.SoundId = p99.SoundId;
    Sound.Volume = p99.Volume;
    Sound.Parent = u98.MainVideo;
    Sound.Looped = true;
    u98.MusicSound = Sound;
    u98.VideoTrove:Add(function() -- Line: 552
        -- upvalues: u98 (copy), Sound (copy)
        if u98.MusicSound == Sound then
            u98.MusicSound = nil;
        end;

        if Sound.Parent ~= nil then
            Sound:Stop();
            Sound:Destroy();
        end;
    end);

    if not Sound.IsLoaded then
        u98.StopPlay.Visible = false;
        showLoading(u98);
        local u101 = nil;
        u101 = Sound.Loaded:Connect(function() -- Line: 574
            -- upvalues: u32 (ref), u98 (copy), u100 (copy), u101 (ref)
            if u32 ~= u98.Token or u98.VideoSerial ~= u100 then
                return;
            end;

            u101:Disconnect();
            local v102 = u98;
            local LoadingTween = v102.LoadingTween;
            v102.LoadingTween = nil;

            if LoadingTween ~= nil then
                LoadingTween:Cancel();
            end;

            v102.Loading.Visible = false;
            v102.LoadingSpin.Rotation = 0;
            u98.ShareSurfaceGui.Enabled = true;
            u98.SideButtonsSurfaceGui.Enabled = true;
            local v103 = u98;
            local MusicSound = v103.MusicSound;

            if MusicSound == nil then
                v103.VideoFramePool.GetActiveFrame():Play();
                local VideoBackgroundMusicSound = v103.VideoBackgroundMusicSound;

                if VideoBackgroundMusicSound ~= nil then
                    if VideoBackgroundMusicSound.TimePosition > 0 then
                        VideoBackgroundMusicSound:Resume();
                    else
                        VideoBackgroundMusicSound:Play();
                    end;
                end;
            elseif MusicSound.TimePosition > 0 then
                MusicSound:Resume();
            else
                MusicSound:Play();
            end;

            local StopPlayTween = v103.StopPlayTween;
            v103.StopPlayTween = nil;

            if StopPlayTween ~= nil then
                StopPlayTween:Cancel();
            end;

            v103.StopPlay.ImageTransparency = 0;
            v103.StopPlay.Size = v103.StopPlayBaseSize;
            v103.StopPlay.Visible = false;
        end);
        u98.VideoTrove:Add(u101);

        return;
    end;

    local LoadingTween = u98.LoadingTween;
    u98.LoadingTween = nil;

    if LoadingTween ~= nil then
        LoadingTween:Cancel();
    end;

    u98.Loading.Visible = false;
    u98.LoadingSpin.Rotation = 0;
    u98.ShareSurfaceGui.Enabled = true;
    u98.SideButtonsSurfaceGui.Enabled = true;
    local MusicSound = u98.MusicSound;

    if MusicSound == nil then
        u98.VideoFramePool.GetActiveFrame():Play();
        local VideoBackgroundMusicSound = u98.VideoBackgroundMusicSound;

        if VideoBackgroundMusicSound ~= nil then
            if VideoBackgroundMusicSound.TimePosition > 0 then
                VideoBackgroundMusicSound:Resume();
            else
                VideoBackgroundMusicSound:Play();
            end;
        end;
    elseif MusicSound.TimePosition > 0 then
        MusicSound:Resume();
    else
        MusicSound:Play();
    end;

    local StopPlayTween = u98.StopPlayTween;
    u98.StopPlayTween = nil;

    if StopPlayTween ~= nil then
        StopPlayTween:Cancel();
    end;

    u98.StopPlay.ImageTransparency = 0;
    u98.StopPlay.Size = u98.StopPlayBaseSize;
    u98.StopPlay.Visible = false;
end;

local function loadVideo(p104, p105, p106, p107) -- Line: 588
    -- upvalues: u35 (copy), Network (copy), Treadmills (copy), unloadVideo (copy), u39 (copy), loadVideoMedia (copy), loadMusicImageMedia (copy), preloadDirectionalAssets (copy)
    p104.VideoSerial = p104.VideoSerial + 1;
    local VideoSerial = p104.VideoSerial;
    local v108;

    if p105 < 1 then
        v108 = #u35;
    else
        v108 = #u35 < p105 and 1 or p105;
    end;

    p104.VideoIndex = v108;
    Network.Fire(Treadmills.UPDATE_MEDIA_INDEX, p106);
    unloadVideo(p104);
    p104.LikeController:UpdatePresentation();
    p104.FriendLikesController:HandleMediaChanged();
    local v109 = u35[p104.VideoIndex];
    u39.MediaChanged:Fire(v109, p104.VideoScreenPart);

    if v109.Kind == "Video" then
        loadVideoMedia(p104, v109, VideoSerial);
    else
        loadMusicImageMedia(p104, v109, VideoSerial);
    end;

    preloadDirectionalAssets(p104, p104.VideoIndex, p107);
end;

local function cleanupRuntime() -- Line: 608
    -- upvalues: u32 (ref), u39 (copy), u33 (ref), u34 (ref), unloadVideo (copy)
    u32 = u32 + 1;
    u39.Stopped:Fire();
    local v110 = u33;
    u33 = nil;

    if v110 ~= nil then
        v110:Destroy();
    end;

    local v111 = u34;
    u34 = nil;

    if v111 == nil then
        return;
    end;

    unloadVideo(v111);
    v111.LikeController:Destroy();
    v111.FriendLikesController:Destroy();
    v111.StopPlay.Visible = true;
    v111.LeftSurfaceGui.Enabled = false;
    v111.RightSurfaceGui.Enabled = false;
    v111.ShareSurfaceGui.Enabled = false;
    v111.SideButtonsSurfaceGui.Enabled = false;
    v111.VideoSurfaceGui.Enabled = false;
    v111.Trove:Destroy();
end;

local function projectConsoleSwapMarker(p112, p113) -- Line: 637
    -- upvalues: Variables (copy), ConsoleCmds (copy)
    local v114 = Variables.Console and p112:GetAttribute("HideOnLoad") ~= true;
    p112.Visible = v114;

    if not Variables.Console then
        return;
    end;

    if p112:IsA("ImageLabel") then
        p112.Image = ConsoleCmds.GetImageForString(p113);

        return;
    end;

    if p112:IsA("ImageButton") then
        p112.Image = ConsoleCmds.GetImageForString(p113);
    end;
end;

local function projectConsoleSwapMarkers() -- Line: 653
    -- upvalues: projectConsoleSwapMarker (copy), ConsoleButton (copy), ConsoleButton2 (copy)
    projectConsoleSwapMarker(ConsoleButton, "ButtonLB");
    projectConsoleSwapMarker(ConsoleButton2, "ButtonRB");
end;

local function bindVideoRuntime(p115, p116, p117, p118) -- Line: 658
    -- upvalues: u32 (ref), TreadmillUtil (copy), u6 (copy), Trove (copy), FeedSequencer (copy), u35 (copy), LocalPlayer (copy), VideoFramePool (copy), MainVideo (copy), LikeController (copy), setMediaPlaying (copy), VideoFrame (copy), FriendLikesController (copy), u7 (copy), Loading (copy), Spin (copy), MusicImage (copy), Progress (copy), u9 (copy), u11 (copy), u13 (copy), StopPlay (copy), u15 (copy), u34 (ref), ImageColorPulse (copy), ButtonSwapRight (copy), u4 (copy), u5 (copy), loadVideo (copy), ButtonFX (copy), ButtonSwapLeft (copy), projectConsoleSwapMarker (copy), ConsoleButton (copy), ConsoleButton2 (copy), Signal (copy), projectConsoleSwapMarkers (copy), ContextActionService (copy), CommentsController (copy), Value (copy), ActionPromptCmds (copy), ButtonL2 (copy), ButtonR2 (copy), ShareButton (copy), wcall (copy), SocialService (copy), TouchTapTracker (copy), getVideoScreenTapScale (copy), UserInputService (copy), updateMediaProgress (copy), unloadVideo (copy)
    if p118 ~= u32 then
        return;
    end;

    local v119, v120, v121 = TreadmillUtil.FindVideoPresentationParts(p115);

    if v119 == nil or (v120 == nil or v121 == nil) then
        u6:AtTrace():Log((`[TreadmillVideoController] Skipped video presentation for {p116}`));

        return;
    end;

    if p118 ~= u32 then
        return;
    end;

    local v122 = Trove.new();
    local v123 = v122:Extend();
    local v124 = RaycastParams.new();
    v124.FilterType = Enum.RaycastFilterType.Include;
    v124.FilterDescendantsInstances = { v119 };
    local v125 = FeedSequencer.CreateRuntime(u35, p117, LocalPlayer.UserId);
    local v126 = VideoFramePool.new(MainVideo);
    local u127 = nil;
    local u130 = LikeController.new(function() -- Line: 681
        -- upvalues: u127 (ref)
        local v128 = u127;

        return v128 == nil and 1 or v128.VideoIndex;
    end, function() -- Line: 684
        -- upvalues: u127 (ref), setMediaPlaying (ref)
        local v129 = u127;
        assert(v129 ~= nil, "Treadmill runtime must exist before handling like single tap");
        local MusicSound = v129.MusicSound;

        if MusicSound == nil then
            setMediaPlaying(v129, not v129.VideoFramePool.GetActiveFrame().Playing);

            return;
        end;

        setMediaPlaying(v129, not MusicSound.IsPlaying);
    end, u35, v122, VideoFrame, v119);
    local u132 = {
        LoadingTween = nil,
        MusicSound = nil,
        StopPlayTween = nil,
        VideoBackgroundMusicSound = nil,
        VideoIndex = 1,
        VideoSerial = 0,
        Feed = v125,
        FriendLikesController = FriendLikesController.new(function() -- Line: 689
            -- upvalues: u127 (ref)
            local v131 = u127;

            return v131 == nil and 1 or v131.VideoIndex;
        end, function() -- Line: 692
            -- upvalues: u130 (copy)
            u130:SuppressScreenTap();
        end, u35, v122, v119),
        LeftSurfaceGui = u7,
        LikeController = u130,
        Loading = Loading,
        LoadingSpin = Spin,
        MainVideo = MainVideo,
        MainVideoBaseSize = MainVideo.Size,
        MusicImage = MusicImage,
        Progress = Progress,
        RightSurfaceGui = u9,
        ShareSurfaceGui = u11,
        SideButtonsSurfaceGui = u13,
        StopPlay = StopPlay,
        StopPlayBaseSize = StopPlay.Size,
        Token = p118,
        Trove = v122,
        VideoFrame = VideoFrame,
        VideoScreenPart = v119,
        VideoScreenRaycastParams = v124,
        VideoSurfaceGui = u15,
        VideoTrove = v123,
        VideoFramePool = v126
    };
    u127 = u132;
    v122:Add(v126.Destroy);

    if p118 ~= u32 then
        v122:Destroy();

        return;
    end;

    u34 = u132;
    u7.Adornee = v120;
    u9.Adornee = v121;
    u11.Adornee = v119;
    u13.Adornee = v119;
    u15.Adornee = v119;
    u7.Enabled = true;
    u9.Enabled = true;
    u11.Enabled = true;
    u13.Enabled = true;
    u15.Enabled = true;
    VideoFrame.Active = true;
    MainVideo.Active = true;
    local u133;

    if u132.Feed.HasSwappedRight then
        u133 = nil;
    else
        u133 = ImageColorPulse.Start(ButtonSwapRight, u4, u5);
        v122:Add(function() -- Line: 750
            -- upvalues: u133 (ref)
            local v134 = u133;

            if v134 ~= nil then
                v134();
                u133 = nil;
            end;
        end);
    end;

    local function swapRight() -- Line: 766
        -- upvalues: FeedSequencer (ref), u132 (copy), u133 (ref), loadVideo (ref)
        local v135, v136 = FeedSequencer.Next(u132.Feed);
        local v137 = u133;

        if v137 ~= nil then
            v137();
            u133 = nil;
        end;

        loadVideo(u132, v135, v136, 1);
    end;

    v122:Add(ButtonFX(ButtonSwapLeft, nil, function() -- Line: 759, Name: swapLeft
        -- upvalues: FeedSequencer (ref), u132 (copy), loadVideo (ref)
        local v138, v139, v140 = FeedSequencer.Previous(u132.Feed);

        if not v140 then
            return;
        end;

        loadVideo(u132, v138, v139, -1);
    end));
    v122:Add(ButtonFX(ButtonSwapRight, nil, swapRight));
    projectConsoleSwapMarker(ConsoleButton, "ButtonLB");
    projectConsoleSwapMarker(ConsoleButton2, "ButtonRB");
    v122:Add(Signal.Fired("Changed Platform"):Connect(projectConsoleSwapMarkers));
    ContextActionService:BindActionAtPriority("TreadmillVideoActions", function(p141, p142, p143) -- Line: 781
        -- upvalues: FeedSequencer (ref), u132 (copy), loadVideo (ref), u133 (ref), u130 (copy), CommentsController (ref)
        if p142 == Enum.UserInputState.Begin then
            local KeyCode = p143.KeyCode;

            if KeyCode == Enum.KeyCode.ButtonL1 then
                local v144, v145, v146 = FeedSequencer.Previous(u132.Feed);

                if v146 then
                    loadVideo(u132, v144, v145, -1);
                end;
            elseif KeyCode == Enum.KeyCode.ButtonR1 then
                local v147, v148 = FeedSequencer.Next(u132.Feed);
                local v149 = u133;

                if v149 ~= nil then
                    v149();
                    u133 = nil;
                end;

                loadVideo(u132, v147, v148, 1);
            elseif KeyCode == Enum.KeyCode.ButtonL2 then
                u130:Toggle();
            elseif KeyCode == Enum.KeyCode.ButtonR2 then
                CommentsController.Toggle();
            end;
        end;

        return Enum.ContextActionResult.Sink;
    end, false, Value, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1, Enum.KeyCode.ButtonL2, Enum.KeyCode.ButtonR2);
    v122:Add(function() -- Line: 808
        -- upvalues: ContextActionService (ref)
        ContextActionService:UnbindAction("TreadmillVideoActions");
    end);
    ActionPromptCmds.SetLeftBoundary(0.2);
    ActionPromptCmds.Show("TreadmillLike", ButtonL2, "Like");

    if CommentsController.IsAvailable() then
        ActionPromptCmds.Show("TreadmillComments", ButtonR2, "Comments");
    end;

    v122:Add(function() -- Line: 816
        -- upvalues: ActionPromptCmds (ref)
        ActionPromptCmds.Hide("TreadmillLike");
        ActionPromptCmds.Hide("TreadmillComments");
        ActionPromptCmds.SetLeftBoundary(nil);
    end);
    v122:Add(ButtonFX(ShareButton, nil, function() -- Line: 821
        -- upvalues: u132 (copy), wcall (ref), SocialService (ref), LocalPlayer (ref)
        u132.LikeController:SuppressScreenTap();
        local v150, v151 = wcall(SocialService.CanSendGameInviteAsync, SocialService, LocalPlayer);

        if not (v150 and v151) then
            return;
        end;

        SocialService:PromptGameInvite(LocalPlayer);
    end));
    local u152 = TouchTapTracker.new();

    local function handleVideoScreenTap(p153) -- Line: 831
        -- upvalues: getVideoScreenTapScale (ref), u132 (copy)
        local v154 = getVideoScreenTapScale(u132, Vector2.new(p153.Position.X, p153.Position.Y));

        if v154 == nil then
            return;
        end;

        u132.FriendLikesController:HandleScreenTap();
        u132.LikeController:HandleScreenTap(v154);
    end;

    v122:Connect(UserInputService.InputBegan, function(p155, p156) -- Line: 840
        -- upvalues: u152 (copy), UserInputService (ref), getVideoScreenTapScale (ref), u132 (copy)
        if p156 then
            return;
        end;

        if p155.UserInputType == Enum.UserInputType.Touch then
            u152:Begin(p155);

            return;
        end;

        if p155.UserInputType == Enum.UserInputType.MouseButton1 and not UserInputService.TouchEnabled then
            local v157 = getVideoScreenTapScale(u132, Vector2.new(p155.Position.X, p155.Position.Y));

            if v157 == nil then
                return;
            end;

            u132.FriendLikesController:HandleScreenTap();
            u132.LikeController:HandleScreenTap(v157);
        end;
    end);
    v122:Connect(UserInputService.InputChanged, function(p158) -- Line: 854
        -- upvalues: u152 (copy)
        if p158.UserInputType == Enum.UserInputType.Touch and u152:IsTrackingInput(p158) then
            u152:Update(p158);
        end;
    end);
    v122:Connect(UserInputService.InputEnded, function(p159, p160) -- Line: 859
        -- upvalues: u152 (copy), getVideoScreenTapScale (ref), u132 (copy)
        if p159.UserInputType == Enum.UserInputType.Touch and (u152:IsTrackingInput(p159) and u152:Evaluate(p159, p160)) then
            local v161 = getVideoScreenTapScale(u132, Vector2.new(p159.Position.X, p159.Position.Y));

            if v161 == nil then
                return;
            end;

            u132.FriendLikesController:HandleScreenTap();
            u132.LikeController:HandleScreenTap(v161);
        end;
    end);
    v122:Add(function() -- Line: 866
        -- upvalues: u152 (copy)
        u152:Reset();
    end);
    v122:BindToRenderStep("TreadmillVideoProgress", Enum.RenderPriority.Last.Value, function() -- Line: 869
        -- upvalues: u32 (ref), u132 (copy), updateMediaProgress (ref)
        if u32 == u132.Token then
            updateMediaProgress(u132);
        end;
    end);
    v122:Add(function() -- Line: 874
        -- upvalues: unloadVideo (ref), u132 (copy), StopPlay (ref), u7 (ref), u9 (ref), u11 (ref), u13 (ref), u15 (ref)
        unloadVideo(u132);
        u132.LikeController:Destroy();
        u132.FriendLikesController:Destroy();
        StopPlay.Visible = true;
        u7.Enabled = false;
        u9.Enabled = false;
        u11.Enabled = false;
        u13.Enabled = false;
        u15.Enabled = false;
    end);
    local v162, v163 = FeedSequencer.Current(u132.Feed);
    loadVideo(u132, v162, v163, 1);
    u6:AtTrace():Log((`[TreadmillVideoController] Started treadmill video for {p116}`));
end;

local function bindVideoRuntimeWhenReady(u164, u165, u166) -- Line: 891
    -- upvalues: Trove (copy), u33 (ref), u32 (ref), bindVideoRuntime (copy), RuntimeInstanceRegistry (copy)
    local u167 = Trove.new();
    u33 = u167;
    local u168 = false;

    local function bindIfCurrent(p169) -- Line: 896
        -- upvalues: u168 (ref), u166 (copy), u32 (ref), u33 (ref), u167 (copy), u164 (copy), bindVideoRuntime (ref), u165 (copy)
        if u168 or (p169 == nil or (u166 ~= u32 or u33 ~= u167)) then
            return;
        end;

        local v170 = p169:IsA("Tool");
        local v171 = `Runtime treadmill "{u164}" must be a Tool`;
        assert(v170, v171);
        u168 = true;
        u33 = nil;
        u167:Destroy();
        bindVideoRuntime(p169, u164, u165, u166);
    end;

    u167:Add(RuntimeInstanceRegistry.Changed:Connect(function(p172, p173, p174) -- Line: 909
        -- upvalues: u164 (copy), bindIfCurrent (copy)
        if p172 == "Treadmill" and p173 == u164 then
            bindIfCurrent(p174);
        end;
    end));
    bindIfCurrent(RuntimeInstanceRegistry.Get("Treadmill", u164));
end;

function u39.Start(p175, p176) -- Line: 922
    -- upvalues: cleanupRuntime (copy), u32 (ref), bindVideoRuntimeWhenReady (copy)
    cleanupRuntime();
    u32 = u32 + 1;
    bindVideoRuntimeWhenReady(p175, p176, u32);
end;

function u39.GetStoppedIconImage() -- Line: 930
    return "rbxassetid://84371411600743";
end;

function u39.ResolveCoverImage(p177) -- Line: 934
    return p177.Kind == "Video" and (p177.CoverImage or "") or p177.Image;
end;

function u39.GetCurrentMediaEntry(p178) -- Line: 942
    -- upvalues: FeedSequencer (copy), LocalPlayer (copy), u35 (copy)
    local v179 = FeedSequencer.ResolveReleaseTrackingState(p178, LocalPlayer.UserId, p178.HasSwappedRight == true);
    local v180 = FeedSequencer.CreateRuntime(u35, v179, LocalPlayer.UserId);

    return u35[FeedSequencer.Current(v180)];
end;

function u39.Stop() -- Line: 950
    -- upvalues: cleanupRuntime (copy)
    cleanupRuntime();
end;

function u39.SuppressScreenTap() -- Line: 954
    -- upvalues: u34 (ref)
    local v181 = u34;

    if v181 ~= nil then
        v181.LikeController:SuppressScreenTap();
    end;
end;

function u39.SetShareButtonVisible(p182) -- Line: 961
    -- upvalues: ShareButton (copy)
    ShareButton.Visible = p182;
end;

CommentsController.Start({
    MediaChanged = u39.MediaChanged,
    SetShareButtonVisible = u39.SetShareButtonVisible,
    Stopped = u39.Stopped,
    SuppressScreenTap = u39.SuppressScreenTap
});

return u39;