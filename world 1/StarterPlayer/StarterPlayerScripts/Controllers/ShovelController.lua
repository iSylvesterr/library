-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 1
};
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local GamepadService = game:GetService("GamepadService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
require(ReplicatedStorage.SharedModules.Environment);
local MessagePrompt = require(ReplicatedStorage.ClientModules.MessagePrompt);
local PlayerStateClient = require(ReplicatedStorage.ClientModules.PlayerStateClient);
local CutsceneGate = require(ReplicatedStorage.ClientModules.CutsceneGate);
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = workspace.CurrentCamera;
local u2 = { "Dig it up", "Cancel" };
local u3 = nil;
local u4 = false;
local u5 = false;
LocalPlayer:WaitForChild("HideCollectProximityPrompts");
local Gardens = workspace:WaitForChild("Gardens");
local GardenZoneData = ReplicatedStorage:WaitForChild("GardenZoneData");
local Gnomes = workspace:WaitForChild("Gnomes");
local u6 = nil;
local u7 = 0;
local u8 = false;
local u9 = nil;
local u10 = 0;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = 0;
local u17 = {};

local function dbgHit(...) -- Line: 71
end;

local function profileBegin(p18) -- Line: 79
    debug.profilebegin("Controllers/ShovelController/" .. p18);
end;

local function profileEnd() -- Line: 83
    debug.profileend();
end;

local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = nil;

local function getGnomeVisuals() -- Line: 97
    -- upvalues: u6 (ref)
    if not u6 then
        u6 = workspace:FindFirstChild("GnomeVisuals");
    end;

    return u6;
end;

local function playAnimation() -- Line: 109
    -- upvalues: LocalPlayer (copy), u25 (ref)
    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    local v26 = Character:FindFirstChildOfClass("Humanoid");

    if not v26 then
        return;
    end;

    local v27 = v26:FindFirstChildOfClass("Animator");

    if not v27 then
        return;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = "rbxassetid://78592768207309";
    u25 = v27:LoadAnimation(Animation);
    u25.Looped = false;
    u25.Priority = Enum.AnimationPriority.Action4;
    u25:Play();
end;

local function stopAnimation() -- Line: 126
    -- upvalues: u25 (ref)
    if u25 then
        u25:Stop();
    end;
end;

local function hasDugBefore() -- Line: 132
    -- upvalues: u4 (ref)
    return u4;
end;

local TweenService = game:GetService("TweenService");
local u28 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);

function v1.Init(p29) -- Line: 139
    -- upvalues: Networking (copy), TweenService (copy), u28 (copy)
    Networking.ShovelFX.Protected.OnClientEvent:Connect(function(p30) -- Line: 140
        -- upvalues: TweenService (ref), u28 (ref)
        local v31 = game.Players:FindFirstChild(p30);
        local v32 = v31 and v31.Character;

        if v32 then
            if v32:FindFirstChild("HitHighlight") then
                return;
            end;

            local Highlight = Instance.new("Highlight");
            Highlight.Name = "HitHighlight";
            Highlight.Parent = v32;
            Highlight.FillTransparency = 0;
            Highlight.FillColor = Color3.new(1, 1, 1);
            Highlight.OutlineTransparency = 1;
            local v33 = TweenService:Create(Highlight, u28, {
                FillTransparency = 1
            });
            v33:Play();
            game.Debris:AddItem(v33, u28.Time);
            game.Debris:AddItem(Highlight, u28.Time);
        end;
    end);
end;

function v1.GetHoldProgressGui(p34) -- Line: 161
    -- upvalues: u12 (ref), LocalPlayer (copy), u13 (ref), u14 (ref)
    if u12 then
        return u12;
    end;

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "ShovelHoldProgress";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.DisplayOrder = 200;
    local Frame = Instance.new("Frame");
    Frame.Name = "Ring";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Size = UDim2.fromOffset(64, 64);
    Frame.BackgroundTransparency = 1;
    Frame.Visible = false;
    Frame.Parent = ScreenGui;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Background";
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxasset://textures/ui/Controls/RadialFill.png";
    ImageLabel.ImageColor3 = Color3.fromRGB(120, 20, 20);
    ImageLabel.ImageTransparency = 0.62;
    ImageLabel.Parent = Frame;

    local function createHalf(p35, p36) -- Line: 190
        -- upvalues: Frame (copy)
        local Frame2 = Instance.new("Frame");
        Frame2.Name = p35;
        Frame2.Size = UDim2.fromScale(0.5, 1);
        Frame2.Position = p36 and UDim2.fromScale(0.5, 0) or UDim2.new();
        Frame2.BackgroundTransparency = 1;
        Frame2.ClipsDescendants = true;
        Frame2.Parent = Frame;
        local ImageLabel2 = Instance.new("ImageLabel");
        ImageLabel2.Name = "ProgressBarImage";
        ImageLabel2.Size = UDim2.fromScale(2, 1);
        ImageLabel2.Position = p36 and UDim2.fromScale(-1, 0) or UDim2.new();
        ImageLabel2.BackgroundTransparency = 1;
        ImageLabel2.Image = "rbxasset://textures/ui/Controls/RadialFill.png";
        ImageLabel2.ImageColor3 = Color3.fromRGB(255, 60, 60);
        ImageLabel2.Parent = Frame2;
        local UIGradient = Instance.new("UIGradient");
        UIGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.499, 0),
            NumberSequenceKeypoint.new(0.5, 1),
            NumberSequenceKeypoint.new(1, 1)
        });
        UIGradient.Parent = ImageLabel2;

        return Frame2, UIGradient;
    end;

    local _, u37 = createHalf("RightGradient", true);
    local _, u38 = createHalf("LeftGradient", false);
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Name = "Progress";
    NumberValue.Value = 0;
    NumberValue.Parent = Frame;
    NumberValue.Changed:Connect(function(p39) -- Line: 227
        -- upvalues: u37 (copy), u38 (copy)
        local v40 = math.clamp(p39 * 360, 0, 360);
        u37.Rotation = math.clamp(v40, 0, 180);
        u38.Rotation = math.clamp(v40, 180, 360);
    end);
    ScreenGui.Parent = PlayerGui;
    u12 = ScreenGui;
    u13 = Frame;
    u14 = NumberValue;

    return ScreenGui;
end;

function v1.HideHoldProgress(p41) -- Line: 242
    -- upvalues: u11 (ref), u15 (ref), u13 (ref), u14 (ref)
    if u11 then
        u11:Disconnect();
        u11 = nil;
    end;

    u15 = nil;

    if u13 then
        u13.Visible = false;
    end;

    if u14 then
        u14.Value = 0;
    end;
end;

function v1.ShouldHoldToDelete(p42) -- Line: 256
    -- upvalues: u21 (ref)
    if not u21 then
        return false;
    end;

    if u21.isPlayer then
        return false;
    end;

    return u21.isGnome or u21.isFruit or u21.plantId ~= nil;
end;

function v1.ShowHoldProgress(p43) -- Line: 266
    -- upvalues: u13 (ref)
    p43:GetHoldProgressGui();

    if not u13 then
        return;
    end;

    local v44 = p43:GetReticleScreenPosition();
    u13.Position = UDim2.fromOffset(v44.X, v44.Y);
    u13.Visible = true;
end;

function v1.StartDeleteHold(u45) -- Line: 276
    -- upvalues: u15 (ref), u20 (ref), u11 (ref), RunService (copy), u8 (ref), u13 (ref), u7 (ref), u14 (ref)
    u45:HideHoldProgress();
    u15 = u20;
    u45:ShowHoldProgress();
    u11 = RunService.RenderStepped:Connect(function() -- Line: 280
        -- upvalues: u8 (ref), u45 (copy), u15 (ref), u20 (ref), u13 (ref), u7 (ref), u14 (ref)
        if not u8 then
            u45:HideHoldProgress();

            return;
        end;

        if not u15 or u15 ~= u20 then
            u45:HideHoldProgress();

            return;
        end;

        if not u45:ShouldHoldToDelete() then
            u45:HideHoldProgress();

            return;
        end;

        local v46 = u45:GetReticleScreenPosition();

        if u13 then
            u13.Position = UDim2.fromOffset(v46.X, v46.Y);
        end;

        local v47 = (os.clock() - u7) / 0.65;
        local v48 = math.clamp(v47, 0, 1);

        if u14 then
            u14.Value = v48;
        end;

        if v48 >= 1 then
            u45:HideHoldProgress();
            u45:ProcessShovelAction();
        end;
    end);
end;

function v1.Start(u49) -- Line: 311
    -- upvalues: UserInputService (copy), CutsceneGate (copy), u10 (ref), u23 (ref), dbgHit (copy), u8 (ref), u7 (ref), u9 (ref), RunService (copy), u3 (ref), PlayerStateClient (copy), LocalPlayer (copy), u24 (ref)
    UserInputService.InputBegan:Connect(function(p50, p51) -- Line: 312
        -- upvalues: CutsceneGate (ref), u49 (copy), u10 (ref), u23 (ref), dbgHit (ref), u8 (ref), u7 (ref), u9 (ref), RunService (ref)
        if p51 then
            return;
        end;

        if CutsceneGate.IsActive() then
            return;
        end;

        local v52 = p50.UserInputType == Enum.UserInputType.Touch;

        if p50.UserInputType == Enum.UserInputType.MouseButton1 or (v52 or p50.KeyCode == Enum.KeyCode.ButtonR2) then
            local v53 = os.clock();
            local v54 = u49:ShouldHoldToDelete();
            local v55 = v53 - u10;

            if not v54 and v55 < 0.65 then
                if u23 then
                    dbgHit(("input ignored: client swing cooldown (%.2fs since last, need %.2fs)"):format(v55, 0.65));
                end;

                return;
            end;

            if v52 then
                if v54 then
                    u8 = true;
                    u7 = v53;
                    u49:StartDeleteHold();
                end;

                return;
            end;

            u8 = true;
            u7 = v53;

            if v54 then
                dbgHit("input routed to hold-to-delete (plant/fruit/gnome highlighted) - no player hit detection this click");
                u49:StartDeleteHold();

                return;
            end;

            u49:ProcessShovelAction();

            if not u9 then
                u9 = RunService.Heartbeat:Connect(function() -- Line: 361
                    -- upvalues: u8 (ref), u7 (ref), u49 (ref), u10 (ref)
                    debug.profilebegin("Controllers/ShovelController/AutoShovel");

                    if u8 and os.clock() - u7 >= 1 then
                        if u49:ShouldHoldToDelete() then
                            debug.profileend();

                            return;
                        end;

                        if os.clock() - u10 >= 0.1 then
                            u49:ProcessShovelAction();
                        end;
                    end;

                    debug.profileend();
                end);
            end;
        end;
    end);
    UserInputService.InputEnded:Connect(function(p56) -- Line: 379
        -- upvalues: u8 (ref), u49 (copy), u9 (ref)
        if (p56.UserInputType == Enum.UserInputType.MouseButton1 or p56.UserInputType == Enum.UserInputType.Touch) and true or p56.KeyCode == Enum.KeyCode.ButtonR2 then
            u8 = false;
            u49:HideHoldProgress();

            if u9 then
                u9:Disconnect();
                u9 = nil;
            end;
        end;
    end);
    UserInputService.TouchTapInWorld:Connect(function(p57, p58) -- Line: 394
        -- upvalues: CutsceneGate (ref), u10 (ref), u49 (copy)
        if p58 then
            return;
        end;

        if CutsceneGate.IsActive() then
            return;
        end;

        if os.clock() - u10 < 0.65 then
            return;
        end;

        if u49:ShouldHoldToDelete() then
            return;
        end;

        u49:ProcessShovelAction();
    end);
    task.spawn(function() -- Line: 406
        -- upvalues: u3 (ref), PlayerStateClient (ref)
        u3 = PlayerStateClient:WaitForLocalReplica(30);
    end);
    local Character = LocalPlayer.Character;

    if Character then
        u49:SetupCharacter(Character);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p59) -- Line: 412
        -- upvalues: u49 (copy)
        u49:SetupCharacter(p59);
    end);
    LocalPlayer:GetAttributeChangedSignal("PlotId"):Connect(function() -- Line: 413
        -- upvalues: u24 (ref)
        u24 = nil;
    end);
end;

function v1.ActivateHitDetection(p60) -- Line: 416
    -- upvalues: dbgHit (copy), LocalPlayer (copy), Networking (copy), Players (copy), u17 (copy), RunService (copy)
    local v61 = p60:GetEquippedTool();

    if not v61 then
        dbgHit("ActivateHitDetection aborted: no equipped tool");

        return;
    end;

    local v62 = LocalPlayer:GetAttribute("IsInOwnGarden") and "NormalCollision" or "GardenCollision";
    local v63 = {};
    local u64 = {};
    local u65 = {};
    local u66 = {};
    local u67 = {};

    for _, descendant in v61:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Name ~= v62 then
            table.insert(v63, descendant);
        end;
    end;

    dbgHit(("swing started: listening on %d shovel part(s) for %.2fs (ignoring \'%s\' parts)"):format(#v63, 0.4, v62));

    if #v63 == 0 then
        dbgHit("WARNING: 0 hittable parts on the shovel - Touched can never fire, no player can be hit this swing");
    end;

    Networking.Shovel.SwingShovel:Fire();
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if Character then
        local _PetVisualClient = workspace:FindFirstChild("_PetVisualClient");

        if _PetVisualClient then
            _PetVisualClient = _PetVisualClient:FindFirstChild("Models");
        end;

        if _PetVisualClient then
            local Position = Character.Position;

            for _, child in pairs(_PetVisualClient:GetChildren()) do
                local v68 = child:GetAttribute("PetID");
                local v69 = child:GetAttribute("Owner");

                if typeof(v68) == "string" and (v68 ~= "" and (typeof(v69) == "string" and v69 ~= LocalPlayer.Name)) then
                    local PrimaryPart = child.PrimaryPart;

                    if PrimaryPart and (PrimaryPart.Position - Position).Magnitude <= 8 then
                        local v70 = Players:FindFirstChild(v69);

                        if v70 then
                            u64[v68] = true;
                            Networking.Pets.ScarePet:Fire(v70.UserId, v68);
                        end;
                    end;
                end;
            end;
        end;
    end;

    local function reportPresentHit(p71, p72) -- Line: 475
        -- upvalues: u65 (copy), dbgHit (ref), Networking (ref)
        u65[p71] = true;
        dbgHit(p72, "present", p71, "-> firing HitPresentFromClientToServer");
        Networking.Present.HitPresentFromClientToServer:Fire({
            Id = p71
        });
    end;

    if Character then
        local Presents = workspace:FindFirstChild("Presents");

        if Presents then
            for _, child in Presents:GetChildren() do
                if child:IsA("Model") then
                    local v73 = child:GetAttribute("PresentId");

                    if type(v73) == "string" and not u65[v73] then
                        local v74 = child.PrimaryPart or child:FindFirstChild("Primary");

                        if v74 and (v74:IsA("BasePart") and (v74.CanTouch and (v74.Position - Character.Position).Magnitude <= 12)) then
                            u65[v73] = true;
                            dbgHit("swept", "present", v73, "-> firing HitPresentFromClientToServer");
                            Networking.Present.HitPresentFromClientToServer:Fire({
                                Id = v73
                            });
                        end;
                    end;
                end;
            end;
        end;
    end;

    local function tryHitPlayer(p75, p76, p77) -- Line: 507
        -- upvalues: u66 (copy), u17 (ref), dbgHit (ref), LocalPlayer (ref), Networking (ref)
        if u66[p75] then
            return;
        end;

        local v78 = os.clock();

        if u17[p75] and v78 - u17[p75] < 0.5 then
            dbgHit(("%s %s but per-target cooldown active (%.2fs since last, need %.2fs) - not firing HitPlayer"):format(p77, p75.Name, v78 - u17[p75], 0.5));

            return;
        end;

        u66[p75] = true;
        u17[p75] = v78;
        local v79 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
        local HumanoidRootPart = p76:FindFirstChild("HumanoidRootPart");

        if v79 and HumanoidRootPart then
            dbgHit(("%s %s -> firing HitPlayer (client dist %.1f). Server requires dist <= %d"):format(p77, p75.Name, (HumanoidRootPart.Position - v79.Position).Magnitude, 12));
        else
            dbgHit(p77, p75.Name, "-> firing HitPlayer");
        end;

        Networking.Shovel.HitPlayer:Fire(p75.UserId);
    end;

    for _, v in v63 do
        local v87 = v.Touched:Connect(function(p80) -- Line: 532
            -- upvalues: u65 (copy), dbgHit (ref), Networking (ref), u64 (copy), Players (ref), LocalPlayer (ref), tryHitPlayer (copy)
            if p80:HasTag("PresentPart") then
                local v81 = p80:FindFirstAncestorWhichIsA("Model");

                if v81 then
                    v81 = v81:GetAttribute("PresentId");
                end;

                if type(v81) == "string" and not u65[v81] then
                    u65[v81] = true;
                    dbgHit("touched", "present", v81, "-> firing HitPresentFromClientToServer");
                    Networking.Present.HitPresentFromClientToServer:Fire({
                        Id = v81
                    });
                end;

                return;
            end;

            local v82 = p80:FindFirstAncestorWhichIsA("Model");

            if not v82 then
                return;
            end;

            local v83 = v82:GetAttribute("Owner");
            local v84 = v82:GetAttribute("PetID");

            if typeof(v83) ~= "string" or (typeof(v84) ~= "string" or v84 == "") then
                local v85 = Players:GetPlayerFromCharacter(v82);

                if not v85 or v85 == LocalPlayer then
                    return;
                end;

                tryHitPlayer(v85, v82, "touched");

                return;
            end;

            if u64[v84] then
                return;
            end;

            local v86 = Players:FindFirstChild(v83);

            if not v86 then
                return;
            end;

            if v86 == LocalPlayer then
                return;
            end;

            u64[v84] = true;
            Networking.Pets.ScarePet:Fire(v86.UserId, v84);
        end);
        table.insert(u67, v87);
    end;

    table.insert(u67, RunService.Heartbeat:Connect(function() -- Line: 584
        -- upvalues: LocalPlayer (ref), Players (ref), u66 (copy), tryHitPlayer (copy)
        debug.profilebegin("Controllers/ShovelController/HitSweep");
        local Character2 = LocalPlayer.Character;

        if Character2 then
            Character2 = Character2:FindFirstChild("HumanoidRootPart");
        end;

        if Character2 then
            local Position = Character2.Position;

            for _, v in Players:GetPlayers() do
                if v ~= LocalPlayer and not u66[v] then
                    local Character3 = v.Character;
                    local v88;

                    if Character3 then
                        v88 = Character3:FindFirstChild("HumanoidRootPart");
                    else
                        v88 = Character3;
                    end;

                    if v88 and (v88.Position - Position).Magnitude <= 12 then
                        tryHitPlayer(v, Character3, "swept");
                    end;
                end;
            end;
        end;

        debug.profileend();
    end));
    task.delay(0.4, function() -- Line: 602
        -- upvalues: u67 (copy), u66 (copy), dbgHit (ref)
        for _, v in u67 do
            v:Disconnect();
        end;

        if next(u66) == nil then
            dbgHit(("swing window closed after %.2fs: nobody was within %d studs for the whole window (or every candidate was on their per-target cooldown)"):format(0.4, 12));
        end;
    end);
end;

function v1.ProcessShovelAction(u89) -- Line: 612
    -- upvalues: dbgHit (copy), u21 (ref), u10 (ref), playAnimation (copy), u20 (ref), Networking (copy), u4 (ref), u5 (ref), MessagePrompt (copy), u2 (copy)
    local u90 = u89:GetEquippedTool();

    if not u90 then
        dbgHit("ProcessShovelAction aborted: no equipped tool");

        return;
    end;

    local u91 = u90:GetAttribute("Shovel");

    if not u91 then
        dbgHit("ProcessShovelAction aborted: equipped tool", u90.Name, "has no \'Shovel\' attribute");

        return;
    end;

    local v92 = u21 and (u21.plantId ~= nil and true or (u21.isFruit or u21.isGnome));
    local v93 = os.clock();
    local v94 = v93 - u10;

    if not v92 then
        if v94 < 0.65 then
            return;
        end;

        u10 = v93;
    end;

    playAnimation();

    if not (u20 and u21) then
        u89:ActivateHitDetection();

        return;
    end;

    if u21.isPlayer and u21.player then
        u89:ActivateHitDetection();
        u89:ClearHighlight();

        return;
    end;

    if u21.isGnome and u21.gnomePart then
        Networking.Place.RemoveGnome:Fire(u21.gnomePart);
        u89:ClearHighlight();

        return;
    end;

    local plantId = u21.plantId;
    local u95 = u21.fruitId or "";

    if u4 then
        Networking.Shovel.UseShovel:Fire(plantId, u95, u91, u90);
        u89:ActivateHitDetection();

        if u20 then
            u20:Destroy();
            u89:ClearHighlight();
        end;

        return;
    end;

    if u5 then
        return;
    end;

    u5 = true;
    local u96 = u20;
    task.spawn(function() -- Line: 667
        -- upvalues: MessagePrompt (ref), u2 (ref), u5 (ref), u4 (ref), Networking (ref), plantId (copy), u95 (copy), u91 (copy), u90 (copy), u96 (copy), u89 (copy)
        local v97 = MessagePrompt.Prompt({
            message = "The Shovel will <b>permanently remove</b> this from your garden. You won\'t get it back.",
            titleOverride = "Dig This Up?",
            yield = true,
            hideClose = true,
            options = u2
        });
        u5 = false;

        if not v97 then
            return;
        end;

        u4 = true;
        Networking.Shovel.UseShovel:Fire(plantId, u95, u91, u90);

        if u96 then
            u96:Destroy();
        end;

        u89:ClearHighlight();
    end);
end;

function v1.OnInput(p98, p99, p100) -- Line: 697
    -- upvalues: u10 (ref)
    if p100 then
        return;
    end;

    if p99.UserInputType ~= Enum.UserInputType.MouseButton1 and p99.KeyCode ~= Enum.KeyCode.ButtonR2 then
        return;
    end;

    if os.clock() - u10 < 0.65 then
        return;
    end;

    p98:ProcessShovelAction();
end;

function v1.SetupCharacter(u101, p102) -- Line: 711
    -- upvalues: u23 (ref)
    p102.ChildAdded:Connect(function(p103) -- Line: 712
        -- upvalues: u23 (ref), u101 (copy)
        if p103:IsA("Tool") and p103:GetAttribute("Shovel") then
            u23 = p103;
            u101:StartHoverDetection();
        end;
    end);
    p102.ChildRemoved:Connect(function(p104) -- Line: 719
        -- upvalues: u23 (ref), u101 (copy)
        if p104:IsA("Tool") and (p104:GetAttribute("Shovel") and u23 == p104) then
            u23 = nil;
            u101:StopHoverDetection();
        end;
    end);

    for _, child in p102:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("Shovel") then
            u23 = child;
            u101:StartHoverDetection();
        end;
    end;
end;

function v1.GetPlayerPlantsFolder(p105) -- Line: 736
    -- upvalues: u24 (ref), LocalPlayer (copy), Gardens (copy)
    if u24 then
        return u24;
    end;

    local v106 = LocalPlayer:GetAttribute("PlotId");

    if not v106 then
        return nil;
    end;

    local v107 = Gardens:FindFirstChild("Plot" .. tostring(v106));

    if not v107 then
        return nil;
    end;

    u24 = v107:FindFirstChild("Plants");

    return u24;
end;

function v1.IsPlayerInMyGarden(p108, p109) -- Line: 746
    -- upvalues: LocalPlayer (copy), GardenZoneData (copy)
    if p109 == LocalPlayer then
        return false;
    end;

    local v110 = LocalPlayer:GetAttribute("PlotId");

    if not v110 then
        return false;
    end;

    local v111 = GardenZoneData:FindFirstChild(p109.Name);

    if v111 then
        return v111.Value == v110;
    end;

    return false;
end;

function v1.IsPlayerStealingFromMe(p112, p113) -- Line: 755
    -- upvalues: LocalPlayer (copy)
    return p113 ~= LocalPlayer;
end;

function v1.GetPlayerFromCharacter(p114, p115) -- Line: 760
    -- upvalues: Players (copy)
    return Players:GetPlayerFromCharacter(p115);
end;

function v1.GetNearbyPlayerInGarden(p116) -- Line: 764
    -- upvalues: LocalPlayer (copy), Players (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return nil, nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return nil, nil;
    end;

    local Position = HumanoidRootPart.Position;
    local v117 = 7;
    local v118 = nil;
    local v119 = nil;

    for _, v in Players:GetPlayers() do
        if v ~= LocalPlayer and (p116:IsPlayerInMyGarden(v) or p116:IsPlayerStealingFromMe(v)) then
            local Character2 = v.Character;

            if Character2 then
                local HumanoidRootPart2 = Character2:FindFirstChild("HumanoidRootPart");

                if HumanoidRootPart2 then
                    local Magnitude = (HumanoidRootPart2.Position - Position).Magnitude;

                    if Magnitude < v117 then
                        v119 = Character2;
                        v118 = v;
                        v117 = Magnitude;
                    end;
                end;
            end;
        end;
    end;

    if v118 and v119 then
        return v119, {
            plantId = nil,
            fruitId = nil,
            isFruit = false,
            isPlayer = true,
            isGnome = false,
            gnomePart = nil,
            player = v118
        };
    end;

    return nil, nil;
end;

function v1.GetGnomePartFromVisual(p120, p121) -- Line: 794
    -- upvalues: Gnomes (copy)
    return Gnomes:FindFirstChild((string.gsub(p121.Name, "^GnomeVisual_", "")));
end;

function v1.GetHighlightTarget(p122, p123) -- Line: 799
    -- upvalues: u6 (ref), LocalPlayer (copy)
    if not p123 then
        return nil, nil;
    end;

    local v124 = p123;

    while p123 and p123 ~= workspace do
        local Parent = p123.Parent;

        if not u6 then
            u6 = workspace:FindFirstChild("GnomeVisuals");
        end;

        if Parent == u6 and p123:IsA("Model") then
            local v125 = p122:GetGnomePartFromVisual(p123);

            if v125 and v125:GetAttribute("Owner") == LocalPlayer.Name then
                return p123, {
                    plantId = nil,
                    fruitId = nil,
                    isFruit = false,
                    isPlayer = false,
                    player = nil,
                    isGnome = true,
                    gnomePart = v125
                };
            end;

            return nil, nil;
        end;

        p123 = p123.Parent;
    end;

    local v126 = p122:GetPlayerPlantsFolder();

    if not v126 then
        return nil, nil;
    end;

    while v124 and v124 ~= workspace do
        local Parent = v124.Parent;

        if Parent and Parent.Name == "Fruits" then
            local Parent2 = Parent.Parent;

            if Parent2 and Parent2.Parent == v126 then
                return v124, {
                    isFruit = true,
                    isPlayer = false,
                    player = nil,
                    isGnome = false,
                    gnomePart = nil,
                    plantId = Parent2.Name,
                    fruitId = v124.Name
                };
            end;
        end;

        if Parent == v126 then
            return v124, {
                fruitId = nil,
                isFruit = false,
                isPlayer = false,
                player = nil,
                isGnome = false,
                gnomePart = nil,
                plantId = v124.Name
            };
        end;

        v124 = Parent;
    end;

    return nil, nil;
end;

function v1.ClearHighlight(p127) -- Line: 835
    -- upvalues: u19 (ref), u20 (ref), u21 (ref)
    if u19 then
        u19:Destroy();
        u19 = nil;
    end;

    u20 = nil;
    u21 = nil;
end;

function v1.CreateRaycastParams(p128) -- Line: 841
    -- upvalues: LocalPlayer (copy)
    local v129 = RaycastParams.new();
    v129.FilterType = Enum.RaycastFilterType.Exclude;
    local Character = LocalPlayer.Character;

    if Character then
        v129.FilterDescendantsInstances = { Character };
    end;

    return v129;
end;

function v1.IsPartVisible(p130, p131) -- Line: 849
    return p131.Transparency < 1;
end;

function v1.RaycastIgnoreInvisible(p132, p133, p134, p135) -- Line: 853
    -- upvalues: u6 (ref), LocalPlayer (copy)
    local v136 = p134;
    local v137 = {};

    for _ = 1, 10 do
        local v138 = workspace:Raycast(p133, p134, p135);

        if not v138 then
            return nil;
        end;

        if p132:IsPartVisible(v138.Instance) then
            return v138;
        end;

        if not u6 then
            u6 = workspace:FindFirstChild("GnomeVisuals");
        end;

        if u6 then
            local Instance2 = v138.Instance;

            if not u6 then
                u6 = workspace:FindFirstChild("GnomeVisuals");
            end;

            if Instance2:IsDescendantOf(u6) then
                return v138;
            end;
        end;

        table.insert(v137, v138.Instance);
        p135.FilterDescendantsInstances = { LocalPlayer.Character, unpack(v137) };
        local Magnitude = (v138.Position - p133).Magnitude;
        p133 = v138.Position + v136.Unit * 0.01;
        p134 = v136.Unit * (p134.Magnitude - Magnitude);

        if p134.Magnitude < 0.1 then
            return nil;
        end;
    end;

    return nil;
end;

function v1.IsUsingGamepad(p139) -- Line: 873
    -- upvalues: UserInputService (copy)
    local v140 = UserInputService:GetLastInputType();

    return (v140 == Enum.UserInputType.Gamepad1 or (v140 == Enum.UserInputType.Gamepad2 or v140 == Enum.UserInputType.Gamepad3)) and true or v140 == Enum.UserInputType.Gamepad4;
end;

function v1.IsGamepadCursorActive(p141) -- Line: 878
    -- upvalues: GamepadService (copy)
    return GamepadService.GamepadCursorEnabled == true;
end;

function v1.GetReticleScreenPosition(p142) -- Line: 885
    -- upvalues: CurrentCamera (copy), UserInputService (copy)
    if p142:IsUsingGamepad() and not p142:IsGamepadCursorActive() then
        return CurrentCamera.ViewportSize / 2;
    end;

    return UserInputService:GetMouseLocation();
end;

function v1.GetGamepadPlacementRay(p143) -- Line: 892
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return nil, nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        return HumanoidRootPart.Position + HumanoidRootPart.CFrame.LookVector * 8 + Vector3.new(0, 50, 0), Vector3.new(0, -100, 0);
    end;

    return nil, nil;
end;

function v1.GetTargetFromRaycast(p144) -- Line: 904
    -- upvalues: CurrentCamera (copy)
    debug.profilebegin("Controllers/ShovelController/GetTargetFromRaycast");
    local v145 = p144:CreateRaycastParams();
    local v146 = p144:GetReticleScreenPosition();
    local v147 = CurrentCamera:ViewportPointToRay(v146.X, v146.Y);
    local v148 = p144:RaycastIgnoreInvisible(v147.Origin, v147.Direction * 5000, v145);
    local v149 = v148 and v148.Instance or nil;
    debug.profileend();

    return v149;
end;

function v1.UpdateHighlightBlink(p150) -- Line: 915
    -- upvalues: u19 (ref), u8 (ref)
    if not u19 then
        return;
    end;

    local v151 = u8 and p150:ShouldHoldToDelete() and 5.2 or 1.8;
    local v152 = os.clock() * v151 * 3.141592653589793 * 2;
    local v153 = (math.sin(v152) + 1) * 0.5;
    u19.FillTransparency = v153 * 0.4 + 0.35;
    u19.OutlineTransparency = v153 * 0.7 + 0.2;
end;

function v1.UpdateHighlight(p154) -- Line: 926
    -- upvalues: CutsceneGate (copy), u20 (ref), u16 (ref), u19 (ref), u21 (ref)
    if CutsceneGate.IsActive() then
        p154:HideHoldProgress();
        p154:ClearHighlight();

        return;
    end;

    debug.profilebegin("Controllers/ShovelController/UpdateHighlight");
    local v155, v156 = p154:GetHighlightTarget((p154:GetTargetFromRaycast()));

    if not v155 and (u20 and (u20.Parent ~= nil and os.clock() - u16 < 0.15)) then
        p154:UpdateHighlightBlink();
        debug.profileend();

        return;
    end;

    if v155 then
        u16 = os.clock();
    end;

    if v155 == u20 then
        p154:UpdateHighlightBlink();
        debug.profileend();

        return;
    end;

    p154:ClearHighlight();

    if v155 then
        local Highlight = Instance.new("Highlight");

        if v156 and v156.isPlayer then
            Highlight.FillColor = Color3.fromRGB(255, 165, 0);
        elseif v156 and v156.isGnome then
            Highlight.FillColor = Color3.fromRGB(255, 100, 100);
        else
            Highlight.FillColor = Color3.fromRGB(255, 0, 0);
        end;

        Highlight.OutlineColor = Color3.fromRGB(255, 0, 0);
        Highlight.FillTransparency = 0.35;
        Highlight.OutlineTransparency = 0.9;
        Highlight.Parent = v155;
        Highlight.Adornee = v155;
        u19 = Highlight;
        u20 = v155;
        u21 = v156;
        p154:UpdateHighlightBlink();
    end;

    debug.profileend();
end;

function v1.StartHoverDetection(u157) -- Line: 974
    -- upvalues: u22 (ref), RunService (copy)
    if u22 then
        return;
    end;

    u22 = RunService.RenderStepped:Connect(function() -- Line: 976
        -- upvalues: u157 (copy)
        debug.profilebegin("Controllers/ShovelController/RenderStepped");
        u157:UpdateHighlight();
        debug.profileend();
    end);
end;

function v1.StopHoverDetection(p158) -- Line: 983
    -- upvalues: u22 (ref)
    if u22 then
        u22:Disconnect();
        u22 = nil;
    end;

    p158:HideHoldProgress();
    p158:ClearHighlight();
end;

function v1.GetEquippedTool(p159) -- Line: 989
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character then
        return Character:FindFirstChildWhichIsA("Tool");
    end;

    return nil;
end;

return v1;