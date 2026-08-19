-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local TranslationHelper = UtilsSystem.TranslationHelper;
local DeviceType = UtilsSystem.DeviceType;
local GetData = UtilsSystem.GetData;
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local SystemGuide = UtilsSystem.SystemGuide;
local UIMgr = UtilsSystem.UIMgr;
local LocalPlayer = UtilsSystem.LocalPlayer;
local ReplicatedStorage = UtilsSystem.ReplicatedStorage;
local RunService = UtilsSystem.RunService;
local CollectionService = UtilsSystem.CollectionService;
local TweenService = UtilsSystem.TweenService;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", (1 / 0));
local GuideName = LocalPlayer:WaitForChild("GuideName", (1 / 0));
local GuideTips = PlayerGui:WaitForChild("Guide", (1 / 0)):WaitForChild("GuideTips", (1 / 0));
local TextLabel = GuideTips:WaitForChild("TextLabel", (1 / 0));
GuideTips.Visible = false;
GuideTips.GroupTransparency = 0;
local Guide = ReplicatedStorage:WaitForChild("ModelRes"):WaitForChild("Guide");
local u1 = Guide:WaitForChild("引导高光");
local u2 = Guide:WaitForChild("引导线");
local Beam = u2:WaitForChild("Beam");
local v3 = SystemGameConfig.GetValue("引导") or {};
local u4 = v3.Defaults or {};
local u5 = v3.Cfg or {};
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = false;
local u12 = 0;
local u13 = nil;
local u14 = nil;

local function _bindPlayerLineAttachment(p15, p16) -- Line: 67
    -- upvalues: u11 (ref), u12 (ref), LocalPlayer (copy), Beam (copy), u10 (ref)
    local v17 = p15:FindFirstChildOfClass("Humanoid");
    local v18;

    if v17 then
        v18 = v17;
    else
        v18 = p15:WaitForChild("Humanoid", 10);

        if v18 then
            if not v18:IsA("Humanoid") then
                v18 = v17;
            end;
        else
            v18 = v17;
        end;
    end;

    if not v18 or v18.Health <= 0 then
        return false;
    end;

    local v19 = p15:FindFirstChild("HumanoidRootPart") or p15:WaitForChild("HumanoidRootPart", 10);

    if not (v19 and v19:IsA("BasePart")) then
        return false;
    end;

    if not u11 or (u12 ~= p16 or LocalPlayer.Character ~= p15) then
        return false;
    end;

    Beam.Attachment1 = nil;

    if u10 and u10.Parent then
        u10:Destroy();
    end;

    local Attachment = Instance.new("Attachment");
    Attachment.Name = "GuideLine_PlayerAttachment";
    Attachment.Parent = v19;
    u10 = Attachment;
    Beam.Attachment1 = Attachment;

    return true;
end;

local function _activatePlayerLineAttachment() -- Line: 108
    -- upvalues: u11 (ref), u12 (ref), LocalPlayer (copy), _bindPlayerLineAttachment (copy)
    u11 = true;
    u12 = u12 + 1;
    local Character = LocalPlayer.Character;

    if Character then
        _bindPlayerLineAttachment(Character, u12);
    end;
end;

local function findWorldPart(p20) -- Line: 119
    if not p20 or p20 == "" then
        return nil;
    end;

    local v21 = workspace;
    local v22 = string.split(p20, ".");

    for i, v in ipairs(v22) do
        if i == 1 and v == "Workspace" then
            v21 = workspace;
        else
            v21 = v21:FindFirstChild(v);

            if not v21 then
                break;
            end;
        end;
    end;

    return v21 or nil;
end;

local function findGuiByPath(p23) -- Line: 143
    -- upvalues: PlayerGui (copy)
    if not p23 or p23 == "" then
        return nil;
    end;

    local v24 = PlayerGui;

    for _, v in ipairs(string.split(p23, ".")) do
        v24 = v24:FindFirstChild(v);

        if not v24 then
            return nil;
        end;
    end;

    return v24;
end;

local function ClearBlack() -- Line: 157
    -- upvalues: u8 (ref), u4 (copy), u6 (ref), TweenService (copy)
    local v25 = u8 and u8.animTimeOut or (u4.ui and u4.ui.animTimeOut or 0.2);
    local v26 = u8 and u8.startScale or (u4.ui and u4.ui.startScale or 2);
    local u27 = u6;
    u6 = nil;
    u8 = nil;

    if u27 and u27.Parent then
        if v25 > 0 then
            local HighlightFrame = u27:FindFirstChild("HighlightFrame");
            local v28;

            if HighlightFrame then
                v28 = HighlightFrame:FindFirstChildOfClass("UIStroke");
            else
                v28 = HighlightFrame;
            end;

            local v29 = TweenInfo.new(v25, Enum.EasingStyle.Quad, Enum.EasingDirection.In);

            if v28 and v28.Parent then
                TweenService:Create(v28, v29, {
                    Transparency = 1
                }):Play();
            end;

            if HighlightFrame and HighlightFrame.Parent then
                local Offset = HighlightFrame.Size.X.Offset;
                local Offset2 = HighlightFrame.Size.Y.Offset;
                local v30 = Offset * v26;
                local v31 = Offset2 * v26;
                local v32 = HighlightFrame.Position.X.Offset + Offset * 0.5 - v30 * 0.5;
                local v33 = HighlightFrame.Position.Y.Offset + Offset2 * 0.5 - v31 * 0.5;
                TweenService:Create(HighlightFrame, v29, {
                    Size = UDim2.fromOffset(v30, v31),
                    Position = UDim2.fromOffset(v32, v33)
                }):Play();
            end;

            task.delay(v25, function() -- Line: 188
                -- upvalues: u27 (copy)
                if u27.Parent then
                    u27:Destroy();
                end;
            end);

            return;
        end;

        u27:Destroy();
    end;
end;

local function clearGuide() -- Line: 201
    -- upvalues: ClearBlack (copy), u7 (ref), u1 (copy), Guide (copy), u9 (ref), u11 (ref), u12 (ref), Beam (copy), u10 (ref), u2 (copy), u13 (ref)
    ClearBlack();

    if u7 then
        u7:Disconnect();
        u7 = nil;
    end;

    if u1 then
        u1.Adornee = nil;
        u1.Enabled = false;
        u1.Parent = Guide;
    end;

    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    u11 = false;
    u12 = u12 + 1;

    if Beam then
        Beam.Attachment1 = nil;
    end;

    if u10 and u10.Parent then
        u10:Destroy();
    end;

    u10 = nil;

    if u2 then
        u2.Parent = Guide;
    end;

    u13 = nil;
end;

local function ensureUIOverlay(p34, p35, p36) -- Line: 242
    -- upvalues: u6 (ref), PlayerGui (copy), Guide (copy), DeviceType (copy), TranslationHelper (copy), TweenService (copy)
    if u6 and u6.Parent then
        return u6;
    end;

    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "Guide_UIOverlay";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.DisplayOrder = 999;
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    ScreenGui.Parent = PlayerGui;
    local Frame = Instance.new("Frame");
    Frame.Name = "HighlightFrame";
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.Active = false;
    Frame.ZIndex = 2;
    Frame.ClipsDescendants = false;
    Frame.Parent = ScreenGui;
    Frame.Visible = true;
    u6 = ScreenGui;

    if p34 then
        local v37 = Guide:FindFirstChild(p35);

        if not v37 then
            warn("[Guide] 找不到箭头模板: ", p35, "（应位于 ReplicatedStorage.ModelRes.Guide）");

            return ScreenGui;
        end;

        local v38 = v37:Clone();
        v38.Parent = Frame;
        local v39 = DeviceType.IsMobile() and v38:FindFirstChildOfClass("UIScale");

        if v39 then
            v39.Scale = 0.5;
        end;

        local GuideText = v38:FindFirstChild("GuideText");

        if GuideText then
            if p36 == nil then
                GuideText.Visible = false;
            else
                GuideText.Visible = true;
                TranslationHelper.SetText(GuideText, p36);
            end;
        end;

        local Rot = v38:FindFirstChild("Rot");

        if Rot then
            local v40 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.InOut, -1, true);

            if p35 == "右" then
                TweenService:Create(Rot, v40, {
                    Rotation = 40
                }):Play();

                return ScreenGui;
            end;

            if p35 == "左下" then
                TweenService:Create(Rot, v40, {
                    Rotation = -90
                }):Play();

                return ScreenGui;
            end;

            TweenService:Create(Rot, v40, {
                Rotation = -40
            }):Play();
        end;
    end;

    return ScreenGui;
end;

local function applyUIGuide(p41) -- Line: 316
    -- upvalues: DeviceType (copy), findGuiByPath (copy), ensureUIOverlay (copy), u4 (copy), u8 (ref), u7 (ref), RunService (copy)
    local path = p41.path;

    if DeviceType.IsMobile() and p41.path_Mobile then
        path = p41.path_Mobile;
    end;

    if not path then
        return;
    end;

    local u42 = findGuiByPath(path);

    if not u42 then
        warn("[Guide] 找不到 UI 目标: ", path);

        return;
    end;

    local pathCheck = p41.pathCheck;

    if pathCheck then
        u42 = pathCheck(u42);
    end;

    if not u42 then
        return;
    end;

    local u43 = ensureUIOverlay(p41.Arrow ~= "", p41.Arrow, p41.ArrowText);
    local v44 = u4.ui or {};

    if not (p41.strokeColor or (p41.color or (v44.strokeColor or v44.color))) then
        Color3.new(0, 0, 0);
    end;

    local _ = p41.thickness or v44.thickness;
    local _ = p41.animTime or v44.animTime;
    local v45 = p41.maskDelay or (v44.maskDelay or 0);
    local _ = p41.maskTransparency or v44.maskTransparency;
    local _ = p41.cornerRadius or v44.cornerRadius;
    u8 = {
        animTimeOut = p41.animTimeOut ~= nil and p41.animTimeOut or (v44.animTimeOut or 0.2),
        startScale = p41.startScale or (v44.startScale or 2)
    };
    local HighlightFrame = u43:FindFirstChild("HighlightFrame");

    local function updateMask() -- Line: 367
        -- upvalues: u42 (ref), u43 (copy), HighlightFrame (copy)
        if not (u42 and u42.Parent) then
            return;
        end;

        local AbsolutePosition = u42.AbsolutePosition;
        local AbsoluteSize = u42.AbsoluteSize;
        local AbsolutePosition2 = u43.AbsolutePosition;
        local v46 = AbsolutePosition.Y - AbsolutePosition2.Y - 1;
        local v47 = math.ceil(AbsolutePosition.X - AbsolutePosition2.X - 1);
        local v48 = math.max(0, v47);
        local v49 = math.ceil(v46);
        local v50 = math.max(0, v49);
        HighlightFrame.Position = UDim2.fromOffset(v48 + AbsoluteSize.X / 2, v50 + AbsoluteSize.Y / 2);
    end;

    local function showMaskAndAnimation() -- Line: 386
        -- upvalues: u43 (copy), updateMask (copy)
        if not u43.Parent then
            return;
        end;

        updateMask();
    end;

    HighlightFrame.Transparency = 1;
    HighlightFrame.Visible = true;

    if v45 > 0 then
        task.delay(v45, function() -- Line: 398
            -- upvalues: u43 (copy), updateMask (copy)
            if u43.Parent then
                if not u43.Parent then
                    return;
                end;

                updateMask();
            end;
        end);
    elseif u43.Parent then
        updateMask();
    end;

    if u7 then
        u7:Disconnect();
    end;

    updateMask();
    local _ = u42.AbsolutePosition.X;
    local _ = u42.AbsolutePosition.Y;
    local _ = u42.AbsoluteSize.X;
    local _ = u42.AbsoluteSize.Y;
    local CurrentCamera = workspace.CurrentCamera;

    if not (CurrentCamera and CurrentCamera.ViewportSize.X) then
        local _ = u43.AbsoluteSize.X;
    end;

    if not (CurrentCamera and CurrentCamera.ViewportSize.Y) then
        local _ = u43.AbsoluteSize.Y;
    end;

    u7 = RunService.RenderStepped:Connect(function() -- Line: 419
        -- upvalues: updateMask (copy)
        updateMask();
    end);
end;

local function applyWorldHighlight(p51) -- Line: 425
    -- upvalues: findWorldPart (copy), u1 (copy)
    if not (p51 and p51.path) then
        return;
    end;

    local v52 = findWorldPart(p51.path);

    if not v52 then
        warn("[Guide] 找不到场景高光目标: ", p51.path);

        return;
    end;

    u1.Adornee = v52;
    u1.Enabled = true;
    u1.Parent = workspace;
end;

local function applyGuideText(p53) -- Line: 441
    -- upvalues: TranslationHelper (copy), TextLabel (copy), UIMgr (copy), GuideTips (copy)
    TranslationHelper.SetText(TextLabel, p53);
    UIMgr.RefreshPopShowState();
    local Parent = GuideTips.Parent;

    if Parent and Parent:IsA("ScreenGui") then
        Parent.Enabled = true;
    end;

    GuideTips.GroupTransparency = 0;
    UIMgr.SetGuideTipsVisible(true);
    GuideTips.Visible = true;
end;

local function findEnemy(p54) -- Line: 455
    -- upvalues: LocalPlayer (copy), u14 (ref), CollectionService (copy)
    if not p54 then
        return;
    end;

    local EntitiesPos = workspace:FindFirstChild("EntitiesPos");
    local HumanoidRootPart = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart", (1 / 0));

    if EntitiesPos then
        u14 = EntitiesPos:FindFirstChild(p54);
    end;

    local v55 = (1 / 0);
    local v56 = nil;

    for _, v in ipairs(CollectionService:GetTagged("Enemy")) do
        local Parent = v.Parent;

        if Parent and Parent:GetAttribute("ID") == p54 then
            local Magnitude = (v.Position - HumanoidRootPart.Position).Magnitude;

            if Magnitude < v55 then
                v56 = v;
                v55 = Magnitude;
            end;
        end;
    end;

    if v56 then
        u14 = v56;
    end;
end;

local function applyLineGuideEnemy(u57) -- Line: 497
    -- upvalues: findEnemy (copy), u14 (ref), applyLineGuideEnemy (copy), u11 (ref), u12 (ref), LocalPlayer (copy), _bindPlayerLineAttachment (copy), u2 (copy), u9 (ref), RunService (copy)
    findEnemy(u57);

    if not u14 then
        task.delay(1, function() -- Line: 502
            -- upvalues: applyLineGuideEnemy (ref), u57 (copy)
            applyLineGuideEnemy(u57);
        end);

        return;
    end;

    u11 = true;
    u12 = u12 + 1;
    local Character = LocalPlayer.Character;

    if Character then
        _bindPlayerLineAttachment(Character, u12);
    end;

    u2.Parent = workspace;
    u2.CFrame = u14:GetPivot();
    u9 = RunService.Heartbeat:Connect(function() -- Line: 515
        -- upvalues: u14 (ref), u9 (ref), applyLineGuideEnemy (ref), u57 (copy), u2 (ref)
        if u14 and u14.Parent then
            u2.CFrame = u14:GetPivot();

            return;
        end;

        u9:Disconnect();
        u9 = nil;
        applyLineGuideEnemy(u57);
    end);
end;

local function findBestDropPart() -- Line: 528
    local DropsClient = workspace:FindFirstChild("DropsClient");

    if not DropsClient then
        return nil;
    end;

    local v58 = -1;
    local v59 = nil;

    for _, child in DropsClient:GetChildren() do
        for _, child2 in child:GetChildren() do
            if child2:IsA("Model") then
                local PrimaryPart = child2.PrimaryPart;

                if PrimaryPart and PrimaryPart:IsA("BasePart") then
                    local v60 = tonumber(child2:GetAttribute("GoldValue")) or 0;

                    if v58 < v60 then
                        v59 = PrimaryPart;
                        v58 = v60;
                    end;
                end;
            end;
        end;
    end;

    return v59;
end;

local function _isBestDropGuideActive() -- Line: 562
    -- upvalues: GetData (copy), GuideName (copy), u5 (copy)
    local v61, v62 = GetData.parseGuideName(GuideName.Value);
    local v63 = u5[v61];

    if not v63 or type(v63) ~= "table" then
        return false;
    end;

    local v64 = v63[tostring(v62)] or v63["1"];
    local v65;

    if type(v64) == "table" and (v64.bestDrop ~= nil and v64.bestDrop ~= false) then
        v65 = v64.bestDrop ~= 0;
    else
        v65 = false;
    end;

    return v65;
end;

local function applyLineGuideBestDrop() -- Line: 577
    -- upvalues: u13 (ref), findBestDropPart (copy), _isBestDropGuideActive (copy), applyLineGuideBestDrop (copy), u11 (ref), u12 (ref), LocalPlayer (copy), _bindPlayerLineAttachment (copy), u2 (copy), u9 (ref), RunService (copy)
    u13 = findBestDropPart();

    if not u13 then
        task.delay(0.5, function() -- Line: 580
            -- upvalues: _isBestDropGuideActive (ref), applyLineGuideBestDrop (ref)
            if _isBestDropGuideActive() then
                applyLineGuideBestDrop();
            end;
        end);

        return;
    end;

    u11 = true;
    u12 = u12 + 1;
    local Character = LocalPlayer.Character;

    if Character then
        _bindPlayerLineAttachment(Character, u12);
    end;

    u2.Parent = workspace;
    u2.CFrame = u13:GetPivot();
    u9 = RunService.Heartbeat:Connect(function() -- Line: 592
        -- upvalues: u13 (ref), u9 (ref), _isBestDropGuideActive (ref), applyLineGuideBestDrop (ref), findBestDropPart (ref), u2 (ref)
        if not (u13 and u13.Parent) then
            if u9 then
                u9:Disconnect();
                u9 = nil;
            end;

            if _isBestDropGuideActive() then
                applyLineGuideBestDrop();
            end;

            return;
        end;

        local v66 = findBestDropPart();

        if v66 and v66 ~= u13 then
            u13 = v66;
        end;

        if u13 and u13.Parent then
            u2.CFrame = u13:GetPivot();
        end;
    end);
end;

local function applyLineGuide(p67) -- Line: 615
    -- upvalues: findWorldPart (copy), u11 (ref), u12 (ref), LocalPlayer (copy), _bindPlayerLineAttachment (copy), u2 (copy), u9 (ref), RunService (copy)
    if not (p67 and p67.path) then
        return;
    end;

    local u68 = findWorldPart(p67.path);

    if not u68 then
        warn("[Guide] 找不到引导线目标: ", p67.path);

        return;
    end;

    u11 = true;
    u12 = u12 + 1;
    local Character = LocalPlayer.Character;

    if Character then
        _bindPlayerLineAttachment(Character, u12);
    end;

    u2.Parent = workspace;
    u2.CFrame = u68:GetPivot();
    u9 = RunService.Heartbeat:Connect(function() -- Line: 629
        -- upvalues: u68 (copy), u2 (ref)
        if not (u68 and u68.Parent) then
            return;
        end;

        u2.CFrame = u68:GetPivot();
    end);
end;

LocalPlayer.CharacterAdded:Connect(function(u69) -- Line: 637
    -- upvalues: u11 (ref), u12 (ref), _bindPlayerLineAttachment (copy)
    if not u11 then
        return;
    end;

    local u70 = u12;
    task.defer(function() -- Line: 643
        -- upvalues: _bindPlayerLineAttachment (ref), u69 (copy), u70 (copy)
        _bindPlayerLineAttachment(u69, u70);
    end);
end);
local u71 = 0;
AddListen.NumValueAdd(GuideName, function(p72) -- Line: 653
    -- upvalues: clearGuide (copy), u71 (ref), GetData (copy), UIMgr (copy), u5 (copy), applyUIGuide (copy), findWorldPart (copy), u1 (copy), applyLineGuide (copy), applyLineGuideEnemy (copy), applyLineGuideBestDrop (copy), TranslationHelper (copy), TextLabel (copy), GuideTips (copy), GuideName (copy), SystemGuide (copy), LocalPlayer (copy)
    clearGuide();
    u71 = u71 + 1;
    local u73 = u71;
    local u74, u75 = GetData.parseGuideName(p72);

    if p72 == nil or (p72 == "" or u74 == "") then
        UIMgr.SetGuideTipsVisible(false);

        return;
    end;

    local v76 = u5[u74];

    if not v76 or type(v76) ~= "table" then
        UIMgr.SetGuideTipsVisible(false);

        return;
    end;

    local v77 = v76[tostring(u75)] or v76["1"];

    if not v77 or type(v77) ~= "table" then
        UIMgr.SetGuideTipsVisible(false);

        return;
    end;

    if v77.ui then
        applyUIGuide(v77.ui);
    end;

    if v77.worldHighlight then
        local worldHighlight = v77.worldHighlight;

        if worldHighlight and worldHighlight.path then
            local v78 = findWorldPart(worldHighlight.path);

            if v78 then
                u1.Adornee = v78;
                u1.Enabled = true;
                u1.Parent = workspace;
            else
                warn("[Guide] 找不到场景高光目标: ", worldHighlight.path);
            end;
        end;
    end;

    if v77.line then
        applyLineGuide(v77.line);
    end;

    if v77.enemy then
        applyLineGuideEnemy(v77.enemy);
    end;

    if v77.bestDrop then
        applyLineGuideBestDrop();
    end;

    if v77.Text then
        TranslationHelper.SetText(TextLabel, v77.Text);
        UIMgr.RefreshPopShowState();
        local Parent = GuideTips.Parent;

        if Parent and Parent:IsA("ScreenGui") then
            Parent.Enabled = true;
        end;

        GuideTips.GroupTransparency = 0;
        UIMgr.SetGuideTipsVisible(true);
        GuideTips.Visible = true;
    else
        UIMgr.SetGuideTipsVisible(false);
    end;

    local v79 = tonumber(v77.autoCompleteSec);

    if v79 and v79 > 0 then
        local Value = GuideName.Value;
        task.delay(v79, function() -- Line: 703
            -- upvalues: u73 (copy), u71 (ref), GuideName (ref), Value (copy), SystemGuide (ref), LocalPlayer (ref), u74 (copy), u75 (copy)
            if u73 ~= u71 then
                return;
            end;

            if GuideName.Value ~= Value then
                return;
            end;

            SystemGuide.CompleteGuide(LocalPlayer, u74, u75);
        end);
    end;
end);