-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local SoundService = game:GetService("SoundService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local MagicDiceConfig = require(ReplicatedStorage.SharedModules.MagicDiceConfig);
local Flash = require(ReplicatedStorage.ClientModules.Flash);
local LocalPlayer = Players.LocalPlayer;
local u2 = MagicDiceConfig.ROLL_TIME + MagicDiceConfig.ZOOM_TIME + MagicDiceConfig.HOLD_TIME + MagicDiceConfig.FADE_TIME;
local ROLL_TIME = MagicDiceConfig.ROLL_TIME;
local u3 = MagicDiceConfig.ROLL_TIME + MagicDiceConfig.ZOOM_TIME;

local function isLoading() -- Line: 27
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("LoadingScreenActive") == true;
end;

local function applyToTool(p4) -- Line: 31
    -- upvalues: LocalPlayer (copy)
    if p4:GetAttribute("MagicDice") == nil then
        return;
    end;

    p4.Enabled = LocalPlayer:GetAttribute("LoadingScreenActive") ~= true;
end;

local function refreshContainer(p5) -- Line: 36
    -- upvalues: LocalPlayer (copy)
    if not p5 then
        return;
    end;

    for _, child in p5:GetChildren() do
        if child:IsA("Tool") then
            if child:GetAttribute("MagicDice") ~= nil then
                child.Enabled = LocalPlayer:GetAttribute("LoadingScreenActive") ~= true;
            end;
        end;
    end;
end;

local function refreshAll() -- Line: 45
    -- upvalues: refreshContainer (copy), LocalPlayer (copy)
    refreshContainer(LocalPlayer:FindFirstChild("Backpack"));
    refreshContainer(LocalPlayer.Character);
end;

local function watchContainer(p6) -- Line: 50
    -- upvalues: refreshContainer (copy), applyToTool (copy)
    refreshContainer(p6);
    p6.ChildAdded:Connect(function(p7) -- Line: 52
        -- upvalues: applyToTool (ref)
        if p7:IsA("Tool") then
            task.defer(applyToTool, p7);
        end;
    end);
end;

local u8 = {};

local function getCamera() -- Line: 86
    return workspace.CurrentCamera;
end;

local function getMagicDiceSound(p9) -- Line: 91
    -- upvalues: SoundService (copy)
    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("MagicDice");
    end;

    if SFX then
        SFX = SFX:FindFirstChild(p9);
    end;

    if SFX and SFX:IsA("Sound") then
        return SFX;
    end;

    return nil;
end;

local function cleanupRoll(p10) -- Line: 101
    -- upvalues: u8 (copy)
    local v11 = u8[p10];

    if not v11 then
        return;
    end;

    u8[p10] = nil;

    if v11.Connection then
        v11.Connection:Disconnect();
    end;

    if v11.FovTween then
        v11.FovTween:Cancel();
    end;

    for _, v in v11.Sounds do
        v:Destroy();
    end;

    if v11.Clone then
        v11.Clone:Destroy();
    end;

    for _, v in v11.Hidden do
        if v.Inst.Parent then
            v.Inst[v.Prop] = v.Value;
        end;
    end;

    local v12 = v11.IsLocal and (v11.SavedFOV and workspace.CurrentCamera);

    if v12 then
        v12.FieldOfView = v11.SavedFOV;
    end;
end;

local function findDiceTool(p13) -- Line: 136
    for _, child in p13:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("MagicDice") ~= nil then
            return child;
        end;
    end;

    return nil;
end;

local function buildClone(p14) -- Line: 147
    local v15 = p14:Clone();
    local Handle = v15:FindFirstChild("Handle");

    for _, descendant in v15:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.LocalTransparencyModifier = 0;
        elseif descendant:IsA("BaseScript") then
            descendant:Destroy();
        end;
    end;

    local Model = Instance.new("Model");

    for _, child in v15:GetChildren() do
        child.Parent = Model;
    end;

    v15:Destroy();

    if not (Handle and Handle:IsA("BasePart")) then
        Handle = Model:FindFirstChildWhichIsA("BasePart", true);
    end;

    if not (Handle and Handle:IsA("BasePart")) then
        Model:Destroy();

        return nil, nil;
    end;

    Model.PrimaryPart = Handle;
    Model.Name = "MagicDiceRoll";

    return Model, Handle;
end;

local function startRollLoop(u16, u17) -- Line: 182
    -- upvalues: RunService (copy), cleanupRoll (copy), MagicDiceConfig (copy), ROLL_TIME (copy), TweenService (copy), Flash (copy), u3 (copy), u2 (copy)
    u17.Connection = RunService.RenderStepped:Connect(function() -- Line: 183
        -- upvalues: u17 (copy), u16 (copy), cleanupRoll (ref), MagicDiceConfig (ref), ROLL_TIME (ref), TweenService (ref), Flash (ref), u3 (ref), u2 (ref)
        local v18 = os.clock();
        local v19 = v18 - u17.LastClock;
        u17.LastClock = v18;
        local v20 = v18 - u17.StartTime;
        local Character = u16.Character;
        local v21;

        if Character then
            v21 = Character:FindFirstChild("HumanoidRootPart");
        else
            v21 = Character;
        end;

        if not (Character and (v21 and v21:IsA("BasePart"))) then
            cleanupRoll(u16);

            return;
        end;

        if u17.Clone and u17.StartObjOffset then
            local v22 = math.clamp(v20 / MagicDiceConfig.MOVE_TIME, 0, 1);
            local v23 = u17.StartObjOffset:Lerp(MagicDiceConfig.FRONT_OFFSET, v22);
            local v24 = v21.CFrame:PointToWorldSpace(v23);
            local v25 = 2.0943951023931953 + 15.707963267948966 * v20;
            local v26 = u17;
            v26.SpinY = v26.SpinY + v19 * v25;
            local v27 = u17;
            v27.SpinX = v27.SpinX + v19 * v25 * 0.6;
            u17.Clone:PivotTo(CFrame.new(v24) * CFrame.Angles(u17.SpinX, u17.SpinY, 0));
        end;

        if u17.IsLocal then
            if not u17.ZoomStarted and ROLL_TIME <= v20 then
                u17.ZoomStarted = true;
                local CurrentCamera = workspace.CurrentCamera;

                if CurrentCamera then
                    u17.SavedFOV = CurrentCamera.FieldOfView;
                    local v28 = TweenService:Create(CurrentCamera, TweenInfo.new(MagicDiceConfig.ZOOM_TIME, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
                        FieldOfView = MagicDiceConfig.ZOOM_FOV
                    });
                    u17.FovTween = v28;
                    v28:Play();
                end;

                Flash({
                    Transparency = 0,
                    FadeInTime = MagicDiceConfig.ZOOM_TIME,
                    HoldTime = MagicDiceConfig.HOLD_TIME,
                    FadeOutTime = MagicDiceConfig.FADE_TIME,
                    FadeInEasingStyle = Enum.EasingStyle.Exponential,
                    FadeInEasingDirection = Enum.EasingDirection.In
                });
            end;

            if not u17.FovRestored and u3 <= v20 then
                u17.FovRestored = true;

                if u17.FovTween then
                    u17.FovTween:Cancel();
                    u17.FovTween = nil;
                end;

                local CurrentCamera = workspace.CurrentCamera;

                if CurrentCamera and u17.SavedFOV then
                    CurrentCamera.FieldOfView = u17.SavedFOV;
                end;
            end;
        end;

        if u2 <= v20 then
            cleanupRoll(u16);
        end;
    end);
end;

local function playRoll(u29) -- Line: 255
    -- upvalues: u8 (copy), cleanupRoll (copy), findDiceTool (copy), buildClone (copy), LocalPlayer (copy), MagicDiceConfig (copy), SoundService (copy), RunService (copy), ROLL_TIME (copy), TweenService (copy), Flash (copy), u3 (copy), u2 (copy)
    if typeof(u29) ~= "Instance" or not u29:IsA("Player") then
        return;
    end;

    if u8[u29] then
        cleanupRoll(u29);
    end;

    local Character = u29.Character;
    local v30;

    if Character then
        v30 = Character:FindFirstChild("HumanoidRootPart");
    else
        v30 = Character;
    end;

    if not (Character and (v30 and v30:IsA("BasePart"))) then
        return;
    end;

    local v31 = findDiceTool(Character);
    local v32 = nil;
    local v33;

    if v31 then
        local v34;
        v33, v34 = buildClone(v31);

        if v33 and v34 then
            v33.Parent = workspace;
            v32 = v30.CFrame:PointToObjectSpace(v33:GetPivot().Position);
        end;
    else
        v33 = nil;
    end;

    local v35 = os.clock();
    local u36 = {
        SpinX = 0,
        SpinY = 0,
        ZoomStarted = false,
        FovRestored = false,
        Clone = v33,
        StartObjOffset = v32,
        Hidden = {},
        Sounds = {},
        IsLocal = u29 == LocalPlayer,
        StartTime = v35,
        LastClock = v35
    };
    u8[u29] = u36;

    if v31 and u29 == LocalPlayer then
        v31:SetAttribute("CooldownEnd", os.clock() + MagicDiceConfig.COOLDOWN);
    end;

    if v31 then
        for _, descendant in v31:GetDescendants() do
            if descendant:IsA("BasePart") then
                table.insert(u36.Hidden, {
                    Prop = "LocalTransparencyModifier",
                    Inst = descendant,
                    Value = descendant.LocalTransparencyModifier
                });
                descendant.LocalTransparencyModifier = 1;
            elseif descendant:IsA("Decal") then
                table.insert(u36.Hidden, {
                    Prop = "Transparency",
                    Inst = descendant,
                    Value = descendant.Transparency
                });
                descendant.Transparency = 1;
            end;
        end;
    end;

    local v37 = {};
    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("MagicDice");
    end;

    if SFX then
        SFX = SFX:FindFirstChild("MagicDiceActivate");
    end;

    if not (SFX and SFX:IsA("Sound")) then
        SFX = nil;
    end;

    local SFX2 = SoundService:FindFirstChild("SFX");

    if SFX2 then
        SFX2 = SFX2:FindFirstChild("MagicDice");
    end;

    if SFX2 then
        SFX2 = SFX2:FindFirstChild("MagicDiceSpin");
    end;

    if not (SFX2 and SFX2:IsA("Sound")) then
        SFX2 = nil;
    end;

    v37[1], v37[2] = SFX, SFX2;

    for _, v in v37 do
        if v then
            local v38 = v:Clone();

            if u36.IsLocal then
                v38.Parent = SoundService;
                table.insert(u36.Sounds, v38);
                v38:Play();
            elseif v33 and v33.PrimaryPart then
                v38.Parent = v33.PrimaryPart;
                v38:Play();
            else
                v38:Destroy();
            end;
        end;
    end;

    u36.Connection = RunService.RenderStepped:Connect(function() -- Line: 183
        -- upvalues: u36 (copy), u29 (copy), cleanupRoll (ref), MagicDiceConfig (ref), ROLL_TIME (ref), TweenService (ref), Flash (ref), u3 (ref), u2 (ref)
        local v39 = os.clock();
        local v40 = v39 - u36.LastClock;
        u36.LastClock = v39;
        local v41 = v39 - u36.StartTime;
        local Character2 = u29.Character;
        local v42;

        if Character2 then
            v42 = Character2:FindFirstChild("HumanoidRootPart");
        else
            v42 = Character2;
        end;

        if not (Character2 and (v42 and v42:IsA("BasePart"))) then
            cleanupRoll(u29);

            return;
        end;

        if u36.Clone and u36.StartObjOffset then
            local v43 = math.clamp(v41 / MagicDiceConfig.MOVE_TIME, 0, 1);
            local v44 = u36.StartObjOffset:Lerp(MagicDiceConfig.FRONT_OFFSET, v43);
            local v45 = v42.CFrame:PointToWorldSpace(v44);
            local v46 = 2.0943951023931953 + 15.707963267948966 * v41;
            local v47 = u36;
            v47.SpinY = v47.SpinY + v40 * v46;
            local v48 = u36;
            v48.SpinX = v48.SpinX + v40 * v46 * 0.6;
            u36.Clone:PivotTo(CFrame.new(v45) * CFrame.Angles(u36.SpinX, u36.SpinY, 0));
        end;

        if u36.IsLocal then
            if not u36.ZoomStarted and ROLL_TIME <= v41 then
                u36.ZoomStarted = true;
                local CurrentCamera = workspace.CurrentCamera;

                if CurrentCamera then
                    u36.SavedFOV = CurrentCamera.FieldOfView;
                    local v49 = TweenService:Create(CurrentCamera, TweenInfo.new(MagicDiceConfig.ZOOM_TIME, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
                        FieldOfView = MagicDiceConfig.ZOOM_FOV
                    });
                    u36.FovTween = v49;
                    v49:Play();
                end;

                Flash({
                    Transparency = 0,
                    FadeInTime = MagicDiceConfig.ZOOM_TIME,
                    HoldTime = MagicDiceConfig.HOLD_TIME,
                    FadeOutTime = MagicDiceConfig.FADE_TIME,
                    FadeInEasingStyle = Enum.EasingStyle.Exponential,
                    FadeInEasingDirection = Enum.EasingDirection.In
                });
            end;

            if not u36.FovRestored and u3 <= v41 then
                u36.FovRestored = true;

                if u36.FovTween then
                    u36.FovTween:Cancel();
                    u36.FovTween = nil;
                end;

                local CurrentCamera = workspace.CurrentCamera;

                if CurrentCamera and u36.SavedFOV then
                    CurrentCamera.FieldOfView = u36.SavedFOV;
                end;
            end;
        end;

        if u2 <= v41 then
            cleanupRoll(u29);
        end;
    end);
end;

local function reportLoadingDone() -- Line: 346
    -- upvalues: Networking (copy)
    Networking.MagicDice.LoadingDone:Fire();
end;

local function watchLoadingDone() -- Line: 350
    -- upvalues: LocalPlayer (copy), Networking (copy)
    if LocalPlayer:GetAttribute("LoadingScreenDone") == true then
        Networking.MagicDice.LoadingDone:Fire();

        return;
    end;

    local u50 = nil;
    u50 = LocalPlayer:GetAttributeChangedSignal("LoadingScreenDone"):Connect(function() -- Line: 356
        -- upvalues: LocalPlayer (ref), u50 (ref), Networking (ref)
        if LocalPlayer:GetAttribute("LoadingScreenDone") == true then
            if u50 then
                u50:Disconnect();
                u50 = nil;
            end;

            Networking.MagicDice.LoadingDone:Fire();
        end;
    end);
end;

function v1.Init(p51) -- Line: 370
end;

function v1.Start(p52) -- Line: 372
    -- upvalues: LocalPlayer (copy), refreshContainer (copy), applyToTool (copy), cleanupRoll (copy), refreshAll (copy), watchLoadingDone (copy), Networking (copy), playRoll (copy), Players (copy)
    local v53 = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack", 10);

    if v53 then
        refreshContainer(v53);
        v53.ChildAdded:Connect(function(p54) -- Line: 52
            -- upvalues: applyToTool (ref)
            if p54:IsA("Tool") then
                task.defer(applyToTool, p54);
            end;
        end);
    end;

    if LocalPlayer.Character then
        local Character = LocalPlayer.Character;
        refreshContainer(Character);
        Character.ChildAdded:Connect(function(p55) -- Line: 52
            -- upvalues: applyToTool (ref)
            if p55:IsA("Tool") then
                task.defer(applyToTool, p55);
            end;
        end);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p56) -- Line: 382
        -- upvalues: cleanupRoll (ref), LocalPlayer (ref), refreshContainer (ref), applyToTool (ref)
        cleanupRoll(LocalPlayer);
        refreshContainer(p56);
        p56.ChildAdded:Connect(function(p57) -- Line: 52
            -- upvalues: applyToTool (ref)
            if p57:IsA("Tool") then
                task.defer(applyToTool, p57);
            end;
        end);
        local v58 = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack", 10);

        if v58 then
            refreshContainer(v58);
            v58.ChildAdded:Connect(function(p59) -- Line: 52
                -- upvalues: applyToTool (ref)
                if p59:IsA("Tool") then
                    task.defer(applyToTool, p59);
                end;
            end);
        end;
    end);
    LocalPlayer:GetAttributeChangedSignal("LoadingScreenActive"):Connect(refreshAll);
    watchLoadingDone();
    Networking.MagicDice.PlayRoll.OnClientEvent:Connect(playRoll);
    Players.PlayerRemoving:Connect(function(p60) -- Line: 404
        -- upvalues: cleanupRoll (ref)
        cleanupRoll(p60);
    end);
end;

return v1;