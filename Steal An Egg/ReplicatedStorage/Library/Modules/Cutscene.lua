-- Decompiled with Potassium's decompiler.

local u1 = {
    Settings = {
        YieldPauseArgument = false,
        FreezeEnabled = false
    }
};
local LocalPlayer = game.Players.LocalPlayer;
local u2 = nil;
local u3 = nil;

local function characterAdded(p4) -- Line: 15
    -- upvalues: u1 (copy), u2 (ref), u3 (ref)
    p4:WaitForChild("Humanoid").Died:Connect(function() -- Line: 16
        -- upvalues: u1 (ref)
        if u1.Playing then
            u1.Playing:Cancel();
        end;
    end);
    u2 = p4;
    u3 = u2:WaitForChild("HumanoidRootPart");
end;

if LocalPlayer.Character then
    local Character = LocalPlayer.Character;
    Character:WaitForChild("Humanoid").Died:Connect(function() -- Line: 16
        -- upvalues: u1 (copy)
        if u1.Playing then
            u1.Playing:Cancel();
        end;
    end);
    u2 = Character;
    u3 = u2:WaitForChild("HumanoidRootPart");
end;

LocalPlayer.CharacterAdded:Connect(characterAdded);
u2 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
u3 = u2:WaitForChild("HumanoidRootPart");
local RunService = game:GetService("RunService");
local StarterGui = game:GetService("StarterGui");
local u5 = require(LocalPlayer.PlayerScripts.PlayerModule):GetControls();
local EasingFunctions = require(script.EasingFunctions);
local CurrentCamera = workspace.CurrentCamera;
local clock = os.clock;
local u6 = {};
u6.__index = u6;
local u7 = nil;

local function acquireRunnerThreadAndCallEventHandler(p8, ...) -- Line: 45
    -- upvalues: u7 (ref)
    local v9 = u7;
    u7 = nil;
    p8(...);
    u7 = v9;
end;

local function runEventHandlerInFreeThread(...) -- Line: 52
    -- upvalues: acquireRunnerThreadAndCallEventHandler (copy)
    acquireRunnerThreadAndCallEventHandler(...);

    while true do
        acquireRunnerThreadAndCallEventHandler(coroutine.yield());
    end;
end;

local u10 = {};
u10.__index = u10;

function u10.new(p11, p12) -- Line: 62
    -- upvalues: u10 (copy)
    return setmetatable({
        Connected = true,
        _next = false,
        _signal = p11,
        _fn = p12
    }, u10);
end;

function u10.Disconnect(p13) -- Line: 71
    assert(p13.Connected, "Can\'t disconnect a connection twice");
    p13.Connected = false;

    if p13._signal._handlerListHead == p13 then
        p13._signal._handlerListHead = p13._next;

        return;
    end;

    local _handlerListHead = p13._signal._handlerListHead;

    while _handlerListHead and _handlerListHead._next ~= p13 do
        _handlerListHead = _handlerListHead._next;
    end;

    if _handlerListHead then
        _handlerListHead._next = p13._next;
    end;
end;

function u6.new() -- Line: 87
    -- upvalues: u6 (copy)
    return setmetatable({
        _handlerListHead = false
    }, u6);
end;

function u6.Connect(p14, p15) -- Line: 91
    -- upvalues: u10 (copy)
    local v16 = u10.new(p14, p15);

    if not p14._handlerListHead then
        p14._handlerListHead = v16;

        return v16;
    end;

    v16._next = p14._handlerListHead;
    p14._handlerListHead = v16;

    return v16;
end;

function u6.DisconnectAll(p17) -- Line: 102
    p17._handlerListHead = false;
end;

function u6.Fire(p18, ...) -- Line: 106
    -- upvalues: u7 (ref), runEventHandlerInFreeThread (copy)
    local _handlerListHead = p18._handlerListHead;

    while _handlerListHead do
        if _handlerListHead.Connected then
            if not u7 then
                u7 = coroutine.create(runEventHandlerInFreeThread);
            end;

            task.spawn(u7, _handlerListHead._fn, ...);
        end;

        _handlerListHead = _handlerListHead._next;
    end;
end;

function u6.Wait(p19) -- Line: 119
    local u20 = coroutine.running();
    local u21 = nil;
    u21 = p19:Connect(function(...) -- Line: 122
        -- upvalues: u21 (ref), u20 (copy)
        u21:Disconnect();
        task.spawn(u20, ...);
    end);

    return coroutine.yield();
end;

function u1.getCoreGuisEnabled() -- Line: 142
    -- upvalues: StarterGui (copy)
    return {
        Backpack = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack),
        Chat = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat),
        EmotesMenu = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu),
        Health = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health),
        PlayerList = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList)
    };
end;

u1.Enum = {
    DisableControls = "DisableControls",
    CurrentCameraPoint = "CurrentCameraPoint",
    DefaultCameraPoint = "DefaultCameraPoint",
    FreezeCharacter = "FreezeCharacter",
    CustomCamera = "CustomCamera"
};
local u34 = {
    Start = {
        { "CustomCamera", function(p22, p23) -- Line: 164
                -- upvalues: CurrentCamera (ref)
                assert(p23, "CustomCamera Argument 1 missing or nil");
                CurrentCamera = p23;
                p22.CustomCamera = p23;
            end },
        { "DisableControls", function() -- Line: 172
                -- upvalues: u5 (copy)
                u5:Disable();
            end },
        { "FreezeCharacter", function(p24, p25) -- Line: 178
                -- upvalues: u2 (ref), u3 (ref)
                if p25 ~= false then
                    for _, v in ipairs(u2.Humanoid.Animator:GetPlayingAnimationTracks()) do
                        v:Stop();
                    end;
                end;

                u3.Anchored = true;
            end },
        { "CurrentCameraPoint", function(p26, p27) -- Line: 189
                -- upvalues: CurrentCamera (ref)
                table.insert(p26.PointsCopy, p27 or #p26.PointsCopy + 1, CurrentCamera.CFrame);
            end },
        { "DefaultCameraPoint", function(p28, p29, p30) -- Line: 195
                -- upvalues: LocalPlayer (copy), CurrentCamera (ref), u3 (ref)
                local v31 = 12.5;

                if p30 == false then
                    local CameraMinZoomDistance = LocalPlayer.CameraMinZoomDistance;
                    local CameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance;
                    LocalPlayer.CameraMinZoomDistance = v31;
                    LocalPlayer.CameraMaxZoomDistance = v31;
                    task.wait();
                    LocalPlayer.CameraMinZoomDistance = CameraMinZoomDistance;
                    LocalPlayer.CameraMaxZoomDistance = CameraMaxZoomDistance;
                else
                    v31 = (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude;
                end;

                local v32 = u3.CFrame.Position + Vector3.new(0, u3.Size.Y / 2 + 0.5, 0);
                local Position = (u3.CFrame * CFrame.new(0, v31 / 2.639783059671599, v31 / 1.035276097119764)).Position;
                table.insert(p28.PointsCopy, p29 or #p28.PointsCopy + 1, CFrame.lookAt(Position, v32));
            end }
    },
    End = {
        { "DisableControls", function() -- Line: 226
                -- upvalues: u5 (copy)
                u5:Enable(true);
            end },
        { "FreezeCharacter", function() -- Line: 232
                -- upvalues: u3 (ref)
                u3.Anchored = false;
            end },
        { "CustomCamera", function(p33) -- Line: 238
                -- upvalues: CurrentCamera (ref)
                CurrentCamera.CameraType = p33.PreviousCameraType;
                CurrentCamera = workspace.CurrentCamera;
            end }
    },
    StartKeys = {},
    EndKeys = {}
};

local function getCF(p35, p36) -- Line: 131
    local v37 = { unpack(p35) };
    local v38 = #v37;

    for i = 1, v38 - 1 do
        for i2 = 1, v38 - i do
            v37[i2] = v37[i2]:Lerp(v37[i2 + 1], p36);
        end;
    end;

    return v37[1];
end;

for i, v in ipairs(u34.Start) do
    table.insert(u34.StartKeys, v[1]);
    u34.Start[i] = v[2];
end;

for i, v in ipairs(u34.End) do
    table.insert(u34.EndKeys, v[1]);
    u34.End[i] = v[2];
end;

local u39 = {};
u39.__index = u39;
u39.ClassName = "Cutscene";

function u1.Thaw(p40) -- Line: 262
    -- upvalues: u1 (copy)
    if not (p40 or u1.FreezeEnabled) then
        return;
    end;

    if typeof(u1.Freezer) == "RBXScriptConnection" then
        u1.Freezer:Disconnect();
    end;

    u1.Freezer = nil;
end;

function u1.Freeze(p41, u42) -- Line: 273
    -- upvalues: u1 (copy), CurrentCamera (ref), RunService (copy)
    if not (p41 or u1.FreezeEnabled) then
        return;
    end;

    local u43 = typeof(u42) == "CFrame" and u42 and u42 or CurrentCamera.CFrame;
    u1.Thaw();
    u1.Freezer = RunService.Heartbeat:Connect(function() -- Line: 280
        -- upvalues: CurrentCamera (ref), u42 (copy), u43 (copy)
        CurrentCamera.CFrame = typeof(u42) == "Instance" and u42.CFrame or u43;
    end);
end;

function u39.Play(u44, u45) -- Line: 285
    -- upvalues: u1 (copy), EasingFunctions (copy), StarterGui (copy), CurrentCamera (ref), u34 (copy), clock (copy), RunService (copy), getCF (copy)
    if u1.Playing then
        u1.Playing:Cancel();
    end;

    u1.Thaw();

    if not (u1.Playing and u1.Playing.CurrentCutscene) then
        u1.Playing = u44;
    end;

    u44.PointsCopy = { unpack(u44.Points) };
    local PointsCopy = u44.PointsCopy;
    local u46 = EasingFunctions[u44.EasingFunction];
    local Duration = u44.Duration;
    local u47 = nil;

    if not u44.Next then
        u44.PreviousCoreGuis = u1.getCoreGuisEnabled();

        if not u44.Reset.Preserve_Cores then
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false);
        end;

        u44.PreviousCameraType = CurrentCamera.CameraType;
    end;

    for _, v in ipairs(u44.SpecialFunctions[1]) do
        if type(v) == "table" then
            u34.Start[v[1]](u44, select(2, unpack(v)));
        else
            u34.Start[v](u44);
        end;
    end;

    assert(#u44.PointsCopy > 1, "More than one point is required");
    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    u44.PlaybackState = Enum.PlaybackState.Playing;
    local u48 = clock();
    RunService:BindToRenderStep("Cutscene", Enum.RenderPriority.Camera.Value + 1, function() -- Line: 325
        -- upvalues: u47 (ref), clock (ref), u48 (copy), Duration (copy), CurrentCamera (ref), getCF (ref), PointsCopy (copy), u46 (copy), u44 (copy), RunService (ref), u34 (ref), u1 (ref), StarterGui (ref), u45 (copy)
        u47 = clock() - u48;

        if u47 <= Duration then
            CurrentCamera.CFrame = getCF(PointsCopy, u46(u47, 0, 1, Duration));
            u44.Progress = u47 / Duration;
            u44.PassedTime = u47;

            return;
        end;

        RunService:UnbindFromRenderStep("Cutscene");
        u44.Progress = 1;
        u44.PassedTime = Duration;

        for _, v in ipairs(u44.SpecialFunctions[2]) do
            if type(v) == "table" then
                u34.End[v[1]](u44, select(2, unpack(v)));
            else
                u34.End[v](u44);
            end;
        end;

        u44.PlaybackState = Enum.PlaybackState.Completed;

        if not u44.Next then
            u1.Playing = nil;

            if not u44.CustomCamera then
                CurrentCamera.CameraType = u44.Reset.Camera and Enum.CameraType[u44.Reset.Camera] or u44.PreviousCameraType;
            end;

            if u45 then
                u1.Freeze();
            end;

            local Core_Gui = u44.Reset.Core_Gui;

            for i, v in next, typeof(Core_Gui) == "table" and Core_Gui and Core_Gui or u44.PreviousCoreGuis do
                local v49 = Enum.CoreGuiType[i];

                if typeof(Core_Gui) ~= "table" then
                    local v = Core_Gui or false;
                end;

                StarterGui:SetCoreGuiEnabled(v49, v);
            end;

            u44.Completed:Fire(Enum.PlaybackState.Completed);

            return;
        end;

        if u44.Next ~= 0 then
            if u1.Playing.CurrentCutscene then
                u1.Playing.CurrentCutscene = u44.Next;
            end;

            u44.Completed:Fire(Enum.PlaybackState.Completed);
            u44.Next:Play();

            return;
        end;

        local Playing = u1.Playing;
        u1.Playing = nil;
        Playing.PlaybackState = Enum.PlaybackState.Completed;
        CurrentCamera.CameraType = Playing.PreviousCameraType;
        Playing.CurrentCutscene = nil;
        local Core_Gui = u44.Reset.Core_Gui;

        for i, v in next, typeof(Core_Gui) == "table" and Core_Gui and Core_Gui or u44.PreviousCoreGuis do
            local v50 = Enum.CoreGuiType[i];

            if typeof(Core_Gui) ~= "table" then
                local v = Core_Gui or false;
            end;

            StarterGui:SetCoreGuiEnabled(v50, v);
        end;

        for _, v in ipairs(Playing.Cutscenes) do
            v.Next = nil;
        end;

        Playing.Completed:Fire(Enum.PlaybackState.Completed);
    end);
end;

function u39.Pause(u51, u52) -- Line: 401
    -- upvalues: u1 (copy), RunService (copy), CurrentCamera (ref)
    if not u1.Playing then
        error("Error while calling Pause - There was no cutscene playing");

        return;
    end;

    if u51.PassedTime == nil then
        error("Error while calling Pause - Cutscene hasn\'t started yet");
    end;

    RunService:UnbindFromRenderStep("Cutscene");
    local u53;

    if u1.Playing.CurrentCutscene then
        u53 = u1.Playing;
    else
        u53 = nil;
    end;

    u1.Playing = nil;
    u51.PlaybackState = Enum.PlaybackState.Paused;

    if u51.CustomCamera then
        CurrentCamera = workspace.CurrentCamera;
    end;

    if u52 then
        if u1.Settings.YieldPauseArgument then
            task.wait(u52);

            if u53 then
                u53:Resume();
            else
                u51:Resume();
            end;
        else
            task.spawn(function() -- Line: 427
                -- upvalues: u52 (copy), u53 (ref), u51 (copy)
                task.wait(u52);

                if u53 then
                    u53:Resume();

                    return;
                end;

                u51:Resume();
            end);
        end;
    end;
end;

function u39.Resume(u54) -- Line: 442
    -- upvalues: u1 (copy), EasingFunctions (copy), CurrentCamera (ref), clock (copy), RunService (copy), getCF (copy), u34 (copy), StarterGui (copy)
    if u1.Playing ~= nil and u1.Playing.CurrentCutscene ~= u54 then
        error("Error while calling Resume - The cutscene was already playing");

        return;
    end;

    if not u54.PassedTime or u54.PassedTime == 0 then
        u54:Play();

        return;
    end;

    u1.Playing = u1.Playing or u54;
    local Duration = u54.Duration;
    local PointsCopy = u54.PointsCopy;
    local u55 = EasingFunctions[u54.EasingFunction];
    local PassedTime = u54.PassedTime;
    u54.PlaybackState = Enum.PlaybackState.Playing;

    if u54.CustomCamera then
        CurrentCamera = u54.CustomCamera;
    end;

    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    local u56 = clock() - PassedTime;
    RunService:BindToRenderStep("Cutscene", Enum.RenderPriority.Camera.Value + 1, function() -- Line: 458
        -- upvalues: PassedTime (ref), clock (ref), u56 (copy), Duration (copy), CurrentCamera (ref), getCF (ref), PointsCopy (copy), u55 (copy), u54 (copy), RunService (ref), u34 (ref), u1 (ref), StarterGui (ref)
        PassedTime = clock() - u56;

        if PassedTime <= Duration then
            CurrentCamera.CFrame = getCF(PointsCopy, u55(PassedTime, 0, 1, Duration));
            u54.Progress = PassedTime / Duration;
            u54.PassedTime = PassedTime;

            return;
        end;

        RunService:UnbindFromRenderStep("Cutscene");
        u54.Progress = 1;
        u54.PassedTime = Duration;

        for _, v in ipairs(u54.SpecialFunctions[2]) do
            if type(v) == "table" then
                u34.End[v[1]](u54, select(2, unpack(v)));
            else
                u34.End[v](u54);
            end;
        end;

        u54.PlaybackState = Enum.PlaybackState.Completed;

        if not u54.Next then
            u1.Playing = nil;

            if not u54.CustomCamera then
                CurrentCamera.CameraType = u54.PreviousCameraType;
            end;

            for i, v in next, u54.PreviousCoreGuis do
                if v then
                    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[i], true);
                end;
            end;

            u54.Completed:Fire(Enum.PlaybackState.Completed);

            return;
        end;

        if u54.Next ~= 0 then
            if u1.Playing.CurrentCutscene then
                u1.Playing.CurrentCutscene = u54.Next;
            end;

            u54.Completed:Fire(Enum.PlaybackState.Completed);
            u54.Next:Play();

            return;
        end;

        local Playing = u1.Playing;
        u1.Playing = nil;
        Playing.PlaybackState = Enum.PlaybackState.Completed;
        CurrentCamera.CameraType = Playing.PreviousCameraType;
        Playing.CurrentCutscene = nil;

        for i, v in next, Playing.PreviousCoreGuis do
            if v then
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[i], true);
            end;
        end;

        for _, v in ipairs(Playing.Cutscenes) do
            v.Next = nil;
        end;

        Playing.Completed:Fire(Enum.PlaybackState.Completed);
    end);
end;

function u39.Cancel(p57) -- Line: 526
    -- upvalues: u1 (copy), RunService (copy), u34 (copy), CurrentCamera (ref), StarterGui (copy)
    if not u1.Playing then
        error("Error while calling Cancel - There was no cutscene playing");

        return;
    end;

    u1.Thaw();
    RunService:UnbindFromRenderStep("Cutscene");
    u1.Playing = nil;

    for _, v in ipairs(p57.SpecialFunctions[2]) do
        if type(v) == "table" then
            u34.End[v[1]](p57, select(2, unpack(v)));
        else
            u34.End[v](p57);
        end;
    end;

    if not p57.Next then
        if not p57.CustomCamera then
            CurrentCamera.CameraType = p57.PreviousCameraType;
        end;

        for i, v in next, p57.PreviousCoreGuis do
            if v then
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[i], true);
            end;
        end;
    end;

    p57.PlaybackState = Enum.PlaybackState.Cancelled;
    p57.Completed:Fire(Enum.PlaybackState.Cancelled);
end;

function u39.Destroy(p58) -- Line: 558
    table.clear(p58);
    setmetatable(p58, nil);
end;

function u1.Create(p59, p60, p61, p62, ...) -- Line: 563
    -- upvalues: u6 (copy), EasingFunctions (copy), u34 (copy), u39 (copy)
    assert(p60, "Argument 1 (points) missing or nil");
    assert(p61, "Argument 2 (duration) missing or nil");
    local v63 = {
        Progress = 0,
        PreviousCameraType = nil,
        PreviousCoreGuis = nil,
        Completed = u6.new(),
        PlaybackState = Enum.PlaybackState.Begin,
        Duration = p61,
        Reset = p62
    };
    local v64 = { ... };

    if typeof(p60) == "Instance" then
        local v65 = typeof(p60) ~= "table";
        assert(v65, "Argument 1 (points) not an instance or table");
        local v66 = p60:GetChildren();
        table.sort(v66, function(p67, p68) -- Line: 584
            return tonumber(p67.Name) < tonumber(p68.Name);
        end);
        p60 = {};

        for _, v in ipairs(v66) do
            table.insert(p60, v.CFrame);
        end;
    end;

    v63.Points = p60;
    v63.EasingFunction = "Linear";
    local v69 = nil;
    local v70 = "In";

    for _, v in ipairs(v64) do
        if EasingFunctions[v] then
            v63.EasingFunction = v;
        elseif typeof(v) == "EnumItem" then
            if v.EnumType == Enum.EasingDirection then
                v70 = v.Name;
            elseif v.EnumType == Enum.EasingStyle then
                v69 = v.Name;
            end;
        end;
    end;

    if v69 then
        assert(EasingFunctions[v70 .. v69], "EasingFunction " .. v70 .. v69 .. " not found");
        v63.EasingFunction = v70 .. v69;
    end;

    v63.SpecialFunctions = { {}, {} };

    for i, v in ipairs(u34.StartKeys) do
        local v71 = 0;

        repeat
            v71 = table.find(v64, v, v71 + 1);

            if v71 then
                local v72 = v71 + 1;
                local v73 = {};
                local v74;

                repeat
                    local v75;

                    if true then
                        v75 = v64[v72];

                        if (v75 or v75 == false) and typeof(v75) ~= "string" then
                            v74 = typeof(v75) ~= "EnumItem";
                        else
                            v74 = false;
                        end;
                    end;

                    if v74 then
                        table.insert(v73, v75);
                        v72 = v72 + 1;
                    end;
                until not v74;

                if #v73 == 0 then
                    table.insert(v63.SpecialFunctions[1], i);
                else
                    table.insert(v73, 1, i);
                    table.insert(v63.SpecialFunctions[1], v73);
                end;
            end;
        until not v71;
    end;

    for i, v in ipairs(u34.EndKeys) do
        local v76 = 0;

        repeat
            v76 = table.find(v64, v, v76 + 1);

            if v76 then
                local v77 = v76 + 1;
                local v78 = {};
                local v79;

                repeat
                    local v80;

                    if true then
                        v80 = v64[v77];

                        if (v80 or v80 == false) and typeof(v80) ~= "string" then
                            v79 = typeof(v80) ~= "EnumItem";
                        else
                            v79 = false;
                        end;
                    end;

                    if v79 then
                        table.insert(v78, v80);
                        v77 = v77 + 1;
                    end;
                until not v79;

                if #v78 == 0 then
                    table.insert(v63.SpecialFunctions[2], i);
                else
                    table.insert(v78, 1, i);
                    table.insert(v63.SpecialFunctions[2], v78);
                end;
            end;
        until not v76;
    end;

    return setmetatable(v63, u39);
end;

local u81 = {};
u81.__index = u81;
u81.ClassName = "Queue";

function u81.Play(p82) -- Line: 672
    -- upvalues: u1 (copy), StarterGui (copy), CurrentCamera (ref)
    if u1.Playing ~= nil then
        error("Error while calling Play - A cutscene/queue was already playing");

        return;
    end;

    u1.Playing = p82;
    local Cutscenes = p82.Cutscenes;

    for i, v in ipairs(Cutscenes) do
        if Cutscenes[i + 1] then
            v.Next = Cutscenes[i + 1];
        else
            v.Next = 0;
        end;
    end;

    p82.PreviousCoreGuis = u1.getCoreGuisEnabled();
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false);
    p82.PreviousCameraType = CurrentCamera.CameraType;
    p82.PlaybackState = Enum.PlaybackState.Playing;
    u1.Playing = p82;
    p82.CurrentCutscene = Cutscenes[1];
    Cutscenes[1]:Play();
end;

function u81.Pause(p83, p84) -- Line: 698
    -- upvalues: u1 (copy)
    if u1.Playing then
        p83.CurrentCutscene:Pause(p84);

        return;
    end;

    error("Error while calling Pause - There was no queue playing");
end;

function u81.Resume(p85) -- Line: 706
    -- upvalues: u1 (copy)
    if u1.Playing ~= nil then
        error("Error while calling Resume - A cutscene/queue was already playing");

        return;
    end;

    u1.Playing = p85;
    p85.CurrentCutscene:Resume();
end;

function u81.Cancel(p86) -- Line: 715
    -- upvalues: u1 (copy), CurrentCamera (ref), StarterGui (copy)
    if not u1.Playing then
        error("Error while calling Cancel - There was no queue playing");

        return;
    end;

    p86.CurrentCutscene:Cancel();
    p86.CurrentCutscene = nil;
    CurrentCamera.CameraType = p86.PreviousCameraType;

    for i, v in next, p86.PreviousCoreGuis do
        if v then
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[i], true);
        end;
    end;

    for _, v in ipairs(p86.Cutscenes) do
        v.Next = nil;
    end;

    p86.PlaybackState = Enum.PlaybackState.Cancelled;
    p86.Completed:Fire(Enum.PlaybackState.Cancelled);
end;

function u81.Destroy(p87) -- Line: 735
    table.clear(p87);
    setmetatable(p87, nil);
end;

function u1.CreateQueue(p88, ...) -- Line: 740
    -- upvalues: u6 (copy), u81 (copy)
    local v89 = {
        Completed = u6.new(),
        PlaybackState = Enum.PlaybackState.Begin,
        Cutscenes = { ... }
    };

    return setmetatable(v89, u81);
end;

return u1;