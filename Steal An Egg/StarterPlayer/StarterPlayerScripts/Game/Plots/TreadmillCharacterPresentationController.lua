-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Easing = require(ReplicatedStorage.Library.Functions.Easing);
local Player = require(ReplicatedStorage.Library.Player);
local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds);
local RuntimeInstanceRegistry = require(ReplicatedStorage.Library.Modules.RuntimeInstanceRegistry);
local TreadmillUtil = require(ReplicatedStorage.Library.Util.TreadmillUtil);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local LocalPlayer = Players.LocalPlayer;
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts");
local u1 = require(PlayerScripts.PlayerModule):GetCameras();
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = 0;
local u6 = {};
local u7 = {};
local u8 = {};

local function restoreSnapshot(p9) -- Line: 65
    for i, v in pairs(p9.PartStates) do
        if i.Parent ~= nil then
            i.Transparency = v;
        end;
    end;
end;

local function restoreActiveSnapshot() -- Line: 73
    -- upvalues: u3 (ref)
    local v10 = u3;
    u3 = nil;

    if v10 == nil then
        return;
    end;

    v10.DescendantTrove:Destroy();

    for i, v in pairs(v10.PartStates) do
        if i.Parent ~= nil then
            i.Transparency = v;
        end;
    end;
end;

local function restoreBillboardAlwaysOnTop(p11, p12) -- Line: 85
    -- upvalues: u6 (copy)
    if u6[p11] ~= p12 then
        return;
    end;

    u6[p11] = nil;

    if p11.Parent ~= nil and p11.AlwaysOnTop == false then
        p11.AlwaysOnTop = p12;
    end;
end;

local function setBillboardNotAlwaysOnTop(u13) -- Line: 96
    -- upvalues: Asserts (copy), u2 (ref), u6 (copy)
    Asserts.BillboardGui(u13);
    local v14 = u2;

    if v14 == nil or u6[u13] ~= nil then
        return;
    end;

    local AlwaysOnTop = u13.AlwaysOnTop;
    u6[u13] = AlwaysOnTop;
    u13.AlwaysOnTop = false;
    v14:Connect(u13:GetPropertyChangedSignal("AlwaysOnTop"), function() -- Line: 107
        -- upvalues: u13 (copy), u6 (ref)
        if u13.AlwaysOnTop ~= false then
            u6[u13] = nil;
        end;
    end);
    v14:Add(function() -- Line: 112
        -- upvalues: u13 (copy), AlwaysOnTop (copy), u6 (ref)
        local v15 = u13;
        local v16 = AlwaysOnTop;

        if u6[v15] ~= v16 then
            return;
        end;

        u6[v15] = nil;

        if v15.Parent ~= nil and v15.AlwaysOnTop == false then
            v15.AlwaysOnTop = v16;
        end;
    end);
end;

local function restoreHumanoidDisplayDistanceType(p17, p18) -- Line: 117
    -- upvalues: u7 (copy)
    if u7[p17] ~= p18 then
        return;
    end;

    u7[p17] = nil;

    if p17.Parent ~= nil and p17.DisplayDistanceType == Enum.HumanoidDisplayDistanceType.None then
        p17.DisplayDistanceType = p18;
    end;
end;

local function hideVisibleHumanoidDisplayDistance(u19) -- Line: 131
    -- upvalues: Asserts (copy), u2 (ref), u7 (copy)
    Asserts.Humanoid(u19);
    local v20 = u2;

    if v20 == nil or u7[u19] ~= nil then
        return;
    end;

    local DisplayDistanceType = u19.DisplayDistanceType;

    if DisplayDistanceType == Enum.HumanoidDisplayDistanceType.None then
        return;
    end;

    u7[u19] = DisplayDistanceType;
    u19.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None;
    v20:Connect(u19:GetPropertyChangedSignal("DisplayDistanceType"), function() -- Line: 146
        -- upvalues: u19 (copy), u7 (ref)
        if u19.DisplayDistanceType ~= Enum.HumanoidDisplayDistanceType.None then
            u7[u19] = nil;
        end;
    end);
    v20:Add(function() -- Line: 151
        -- upvalues: u19 (copy), DisplayDistanceType (copy), u7 (ref)
        local v21 = u19;
        local v22 = DisplayDistanceType;

        if u7[v21] ~= v22 then
            return;
        end;

        u7[v21] = nil;

        if v21.Parent ~= nil and v21.DisplayDistanceType == Enum.HumanoidDisplayDistanceType.None then
            v21.DisplayDistanceType = v22;
        end;
    end);
end;

local function getCameraTransparency(p23) -- Line: 156
    return p23 <= 5 and 1 or math.clamp(1 - (p23 - 5) / 8, 0, 1);
end;

local function trackCharacterPart(p24, p25) -- Line: 166
    if not p25:IsA("BasePart") then
        return;
    end;

    if p25:FindFirstAncestorWhichIsA("Tool") ~= nil then
        return;
    end;

    if p24.PartStates[p25] ~= nil then
        return;
    end;

    p24.PartStates[p25] = p25.Transparency;
end;

local function bindCharacter(p26) -- Line: 182
    -- upvalues: u2 (ref), u3 (ref)
    local v27 = u2;

    if v27 == nil then
        return;
    end;

    local v28 = u3;
    u3 = nil;

    if v28 ~= nil then
        v28.DescendantTrove:Destroy();

        for i, v in pairs(v28.PartStates) do
            if i.Parent ~= nil then
                i.Transparency = v;
            end;
        end;
    end;

    local u29 = {
        Character = p26,
        DescendantTrove = v27:Extend(),
        PartStates = {}
    };
    u3 = u29;

    for _, descendant in ipairs(p26:GetDescendants()) do
        if descendant:IsA("BasePart") then
            if descendant:FindFirstAncestorWhichIsA("Tool") == nil then
                if u29.PartStates[descendant] == nil then
                    u29.PartStates[descendant] = descendant.Transparency;
                end;
            end;
        end;
    end;

    u29.DescendantTrove:Connect(p26.DescendantAdded, function(p30) -- Line: 201
        -- upvalues: u29 (copy)
        local v31 = u29;

        if not p30:IsA("BasePart") then
            return;
        end;

        if p30:FindFirstAncestorWhichIsA("Tool") ~= nil then
            return;
        end;

        if v31.PartStates[p30] ~= nil then
            return;
        end;

        v31.PartStates[p30] = p30.Transparency;
    end);
end;

local function updateCharacterTransparency() -- Line: 206
    -- upvalues: Workspace (copy), Player (copy), LocalPlayer (copy), u3 (ref)
    local CurrentCamera = Workspace.CurrentCamera;
    local v32 = Player.Optional.Head(LocalPlayer);

    if CurrentCamera == nil or v32 == nil then
        return;
    end;

    local v33 = u3;

    if v33 == nil or v32.Parent ~= v33.Character then
        return;
    end;

    local Magnitude = (CurrentCamera.CFrame.Position - v32.Position).Magnitude;
    local v34 = Magnitude <= 5 and 1 or math.clamp(1 - (Magnitude - 5) / 8, 0, 1);

    for i, v in pairs(v33.PartStates) do
        if i.Parent == nil then
            v33.PartStates[i] = nil;
        else
            i.Transparency = math.max(v, v34);
        end;
    end;
end;

local function resolveCurrentTransparency() -- Line: 231
    -- upvalues: Workspace (copy), Player (copy), LocalPlayer (copy), u3 (ref)
    local CurrentCamera = Workspace.CurrentCamera;
    local v35 = Player.Optional.Head(LocalPlayer);

    if CurrentCamera == nil or v35 == nil then
        return nil;
    end;

    local v36 = u3;

    if v36 == nil or v35.Parent ~= v36.Character then
        return nil;
    end;

    local Magnitude = (CurrentCamera.CFrame.Position - v35.Position).Magnitude;

    return Magnitude <= 5 and 1 or math.clamp(1 - (Magnitude - 5) / 8, 0, 1);
end;

local function restoreAutoCameraState() -- Line: 247
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera ~= nil and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
        CurrentCamera.CameraType = Enum.CameraType.Custom;
    end;
end;

local function commitAutoCameraDistance(p37) -- Line: 254
    -- upvalues: u1 (copy)
    u1:CommitCameraCFrame(p37, Enum.CameraType.Custom);
end;

local function completeAutoCameraState(p38) -- Line: 258
    -- upvalues: u4 (ref), u1 (copy), Workspace (copy)
    local v39 = u4;
    u4 = nil;

    if v39 == nil then
        return;
    end;

    u1:CommitCameraCFrame(p38, Enum.CameraType.Custom);
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera ~= nil and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
        CurrentCamera.CameraType = Enum.CameraType.Custom;
    end;
end;

local function clearAutoCameraState() -- Line: 269
    -- upvalues: u4 (ref), Workspace (copy)
    local v40 = u4;
    u4 = nil;

    if v40 == nil then
        return;
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera ~= nil and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
        CurrentCamera.CameraType = Enum.CameraType.Custom;
    end;
end;

local function resolveAutoCameraFocusPoint(p41, p42) -- Line: 279
    return p41.CFrame:PointToWorldSpace(p42);
end;

local function resolveAutoCameraTargetCFrame(p43, p44) -- Line: 283
    local v45 = p43.Position - p44;

    if v45.Magnitude <= 0.001 then
        v45 = -p43.CFrame.LookVector;
    end;

    return CFrame.lookAt(p44 - v45.Unit * 1.8, p43.Position + Vector3.new(0, 0.12, 0), Vector3.new(0, 1, 0));
end;

local function updateAutoCamera() -- Line: 294
    -- upvalues: u4 (ref), Workspace (copy), Player (copy), LocalPlayer (copy), Easing (copy), u1 (copy)
    local v46 = u4;

    if v46 == nil then
        return;
    end;

    local CurrentCamera = Workspace.CurrentCamera;
    local v47 = Player.Optional.Head(LocalPlayer);
    local v48 = Player.Optional.HumanoidRootPart(LocalPlayer);
    local VideoScreenPart = v46.VideoScreenPart;

    if CurrentCamera == nil or (v47 == nil or v48 == nil) then
        return;
    end;

    if VideoScreenPart == nil then
        return;
    end;

    if VideoScreenPart.Parent == nil then
        local v49 = u4;
        u4 = nil;

        if v49 == nil then
            return;
        end;

        local CurrentCamera2 = Workspace.CurrentCamera;

        if CurrentCamera2 ~= nil and CurrentCamera2.CameraType == Enum.CameraType.Scriptable then
            CurrentCamera2.CameraType = Enum.CameraType.Custom;
        end;

        return;
    end;

    local v50 = v48.CFrame:PointToWorldSpace(v46.FocusOffset);
    local v51 = VideoScreenPart.Position - v50;

    if v51.Magnitude <= 0.001 then
        v51 = -VideoScreenPart.CFrame.LookVector;
    end;

    local v52 = CFrame.lookAt(v50 - v51.Unit * 1.8, VideoScreenPart.Position + Vector3.new(0, 0.12, 0), Vector3.new(0, 1, 0));
    local v53 = (os.clock() - v46.StartedAt) / 0.35;
    local v54 = math.clamp(v53, 0, 1);
    CurrentCamera.CFrame = v46.InitialCameraCFrame:Lerp(v52, Easing(v54, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut));

    if v54 >= 1 then
        local v55 = u4;
        u4 = nil;

        if v55 == nil then
            return;
        end;

        u1:CommitCameraCFrame(v52, Enum.CameraType.Custom);
        local CurrentCamera2 = Workspace.CurrentCamera;

        if CurrentCamera2 ~= nil and CurrentCamera2.CameraType == Enum.CameraType.Scriptable then
            CurrentCamera2.CameraType = Enum.CameraType.Custom;
        end;
    end;
end;

local function bindAutoCameraScreen(p56, p57) -- Line: 332
    -- upvalues: RuntimeInstanceRegistry (copy), u4 (ref), TreadmillUtil (copy), Workspace (copy)
    local v58 = RuntimeInstanceRegistry.Require("Treadmill", p56);
    local v59 = v58:IsA("Tool");
    local v60 = `Runtime treadmill "{p56}" must be a Tool`;
    assert(v59, v60);
    local v61 = u4;

    if v61 == nil or v61.Token ~= p57 then
        return;
    end;

    local v62 = TreadmillUtil.FindVideoFeedScreenPart(v58);

    if v62 ~= nil then
        v61.VideoScreenPart = v62;

        return;
    end;

    local v63 = u4;
    u4 = nil;

    if v63 == nil then
        return;
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera ~= nil and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
        CurrentCamera.CameraType = Enum.CameraType.Custom;
    end;
end;

local function bindPlayerDisplayDistance(u64) -- Line: 349
    -- upvalues: Asserts (copy), u2 (ref), Player (copy), hideVisibleHumanoidDisplayDistance (copy)
    Asserts.Player(u64);
    local u65 = u2;

    if u65 == nil then
        return;
    end;

    local v66 = Player.Optional.Humanoid(u64);

    if v66 ~= nil then
        hideVisibleHumanoidDisplayDistance(v66);
    end;

    local function bindPlayerCharacterDisplayDistance(p67) -- Line: 362
        -- upvalues: Asserts (ref), Player (ref), u64 (copy), hideVisibleHumanoidDisplayDistance (ref), u65 (copy)
        Asserts.Model(p67);
        local v68 = Player.Optional.Humanoid(u64);

        if v68 ~= nil then
            hideVisibleHumanoidDisplayDistance(v68);
        end;

        u65:Connect(p67.ChildAdded, function(p69) -- Line: 370
            -- upvalues: hideVisibleHumanoidDisplayDistance (ref)
            if p69:IsA("Humanoid") then
                hideVisibleHumanoidDisplayDistance(p69);
            end;
        end);
    end;

    if u64.Character ~= nil then
        bindPlayerCharacterDisplayDistance(u64.Character);
    end;

    u65:Connect(u64.CharacterAdded, bindPlayerCharacterDisplayDistance);
end;

local function bindHumanoidDisplayPresentation() -- Line: 383
    -- upvalues: u2 (ref), Players (copy), bindPlayerDisplayDistance (copy)
    local v70 = u2;

    if v70 == nil then
        return;
    end;

    for _, v in ipairs(Players:GetPlayers()) do
        task.defer(bindPlayerDisplayDistance, v);
    end;

    v70:Connect(Players.PlayerAdded, bindPlayerDisplayDistance);
end;

local function bindYourBaseBillboardPresentation() -- Line: 395
    -- upvalues: u2 (ref), PlotCmds (copy), setBillboardNotAlwaysOnTop (copy)
    local v71 = u2;

    if v71 == nil then
        return;
    end;

    local function bindCurrentPlot() -- Line: 401
        -- upvalues: PlotCmds (ref), setBillboardNotAlwaysOnTop (ref)
        local v72 = PlotCmds.GetLocalYourBaseBillboard();

        if v72 ~= nil then
            setBillboardNotAlwaysOnTop(v72);
        end;
    end;

    local v73 = PlotCmds.GetLocalYourBaseBillboard();

    if v73 ~= nil then
        setBillboardNotAlwaysOnTop(v73);
    end;

    v71:Add(PlotCmds.OnLocalPlotUpdated:Connect(bindCurrentPlot));
end;

function u8.Stop() -- Line: 416
    -- upvalues: u5 (ref), u4 (ref), Workspace (copy), u2 (ref), u3 (ref)
    u5 = u5 + 1;
    local v74 = u4;
    u4 = nil;

    if v74 ~= nil then
        local CurrentCamera = Workspace.CurrentCamera;

        if CurrentCamera ~= nil and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
            CurrentCamera.CameraType = Enum.CameraType.Custom;
        end;
    end;

    local v75 = u2;
    u2 = nil;

    if v75 ~= nil then
        v75:Destroy();

        return;
    end;

    local v76 = u3;
    u3 = nil;

    if v76 == nil then
        return;
    end;

    v76.DescendantTrove:Destroy();

    for i, v in pairs(v76.PartStates) do
        if i.Parent ~= nil then
            i.Transparency = v;
        end;
    end;
end;

function u8.StopCameraTransparency() -- Line: 430
    -- upvalues: u8 (copy)
    u8.Stop();
end;

function u8.Start(p77) -- Line: 434
    -- upvalues: Asserts (copy), u8 (copy), u5 (ref), Trove (copy), u2 (ref), Workspace (copy), Player (copy), LocalPlayer (copy), u1 (copy), u4 (ref), bindAutoCameraScreen (copy), bindCharacter (copy), updateAutoCamera (copy), updateCharacterTransparency (copy), bindHumanoidDisplayPresentation (copy), PlotCmds (copy), setBillboardNotAlwaysOnTop (copy), restoreActiveSnapshot (copy), clearAutoCameraState (copy)
    Asserts.string(p77);
    u8.Stop();
    u5 = u5 + 1;
    local v78 = u5;
    local v79 = Trove.new();
    u2 = v79;
    local CurrentCamera = Workspace.CurrentCamera;
    local v80 = Player.Optional.HumanoidRootPart(LocalPlayer);
    local v81 = u1:GetCameraSubjectPosition(Enum.CameraType.Custom);

    if CurrentCamera ~= nil and (v81 ~= nil and v80 ~= nil) then
        u4 = {
            VideoScreenPart = nil,
            FocusOffset = v80.CFrame:PointToObjectSpace(v81),
            InitialCameraCFrame = CurrentCamera.CFrame,
            StartedAt = os.clock(),
            Token = v78
        };
        task.spawn(bindAutoCameraScreen, p77, v78);
    end;

    local Character = LocalPlayer.Character;

    if Character ~= nil then
        bindCharacter(Character);
    end;

    v79:Connect(LocalPlayer.CharacterAdded, bindCharacter);
    v79:BindToRenderStep("TreadmillCameraAutoFrame", Enum.RenderPriority.Camera.Value + 1, updateAutoCamera);
    v79:BindToRenderStep("TreadmillCameraTransparency", Enum.RenderPriority.Camera.Value + 2, updateCharacterTransparency);
    bindHumanoidDisplayPresentation();
    local v82 = u2;

    if v82 ~= nil then
        local function v84() -- Line: 401
            -- upvalues: PlotCmds (ref), setBillboardNotAlwaysOnTop (ref)
            local v83 = PlotCmds.GetLocalYourBaseBillboard();

            if v83 ~= nil then
                setBillboardNotAlwaysOnTop(v83);
            end;
        end;

        local v85 = PlotCmds.GetLocalYourBaseBillboard();

        if v85 ~= nil then
            setBillboardNotAlwaysOnTop(v85);
        end;

        v82:Add(PlotCmds.OnLocalPlotUpdated:Connect(v84));
    end;

    v79:Add(restoreActiveSnapshot);
    v79:Add(clearAutoCameraState);
end;

function u8.StartCameraTransparency(p86) -- Line: 479
    -- upvalues: u8 (copy)
    u8.Start(p86);
end;

function u8.IsLocalCharacterFullyTransparent() -- Line: 483
    -- upvalues: Workspace (copy), Player (copy), LocalPlayer (copy), u3 (ref)
    local CurrentCamera = Workspace.CurrentCamera;
    local v87 = Player.Optional.Head(LocalPlayer);
    local v88;

    if CurrentCamera == nil or v87 == nil then
        v88 = nil;
    else
        local v89 = u3;

        if v89 == nil or v87.Parent ~= v89.Character then
            v88 = nil;
        else
            local Magnitude = (CurrentCamera.CFrame.Position - v87.Position).Magnitude;
            v88 = Magnitude <= 5 and 1 or math.clamp(1 - (Magnitude - 5) / 8, 0, 1);
        end;
    end;

    local v90;

    if v88 == nil then
        v90 = false;
    else
        v90 = v88 >= 1;
    end;

    return v90;
end;

return u8;