-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local Debris = game:GetService("Debris");
local UserInputService = game:GetService("UserInputService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local success, result = pcall(function() -- Line: 16
    -- upvalues: ReplicatedStorage (copy)
    return require(ReplicatedStorage.SharedModules.Flags.StrawberrySniperFlags);
end);
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
setmetatable(u2, {
    __mode = "k"
});

local function playSniperSfx(p3) -- Line: 32
    -- upvalues: SoundService (copy)
    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("StrawberrySniper");
    end;

    if SFX then
        SFX = SFX:FindFirstChild(p3);
    end;

    if not (SFX and SFX:IsA("Sound")) then
        return;
    end;

    local u4 = SFX:Clone();
    u4.Parent = SoundService;
    u4:Play();
    u4.Ended:Once(function() -- Line: 41
        -- upvalues: u4 (copy)
        u4:Destroy();
    end);
end;

local Animation = Instance.new("Animation");
Animation.AnimationId = "rbxassetid://112941551893838";
local Animation2 = Instance.new("Animation");
Animation2.AnimationId = "rbxassetid://131307149737196";
local Animation3 = Instance.new("Animation");
Animation3.AnimationId = "rbxassetid://109911056301120";
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = 0;

local function getCamera() -- Line: 71
    return workspace.CurrentCamera;
end;

local function raycastFromScreen(p10, p11, p12) -- Line: 82
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return nil;
    end;

    local v13 = CurrentCamera:ScreenPointToRay(p11, p12);
    local v14 = RaycastParams.new();
    v14.FilterType = Enum.RaycastFilterType.Exclude;
    v14.FilterDescendantsInstances = { p10 };
    local Origin = v13.Origin;
    local v15 = v13.Direction * 5000;

    for _ = 1, 10 do
        local v16 = workspace:Raycast(Origin, v15, v14);

        if not v16 then
            return Origin + v15;
        end;

        if v16.Instance.Transparency < 1 then
            return v16.Position;
        end;

        local FilterDescendantsInstances = v14.FilterDescendantsInstances;
        table.insert(FilterDescendantsInstances, v16.Instance);
        v14.FilterDescendantsInstances = FilterDescendantsInstances;
        local v17 = v15.Magnitude - (v16.Position - Origin).Magnitude;
        Origin = v16.Position + v13.Direction * 0.01;
        v15 = v13.Direction * v17;
    end;

    return Origin + v15;
end;

local function getTorso(p18) -- Line: 119
    local v19 = p18:FindFirstChild("UpperTorso") or (p18:FindFirstChild("Torso") or p18:FindFirstChild("HumanoidRootPart"));

    if v19 and v19:IsA("BasePart") then
        return v19;
    end;

    return nil;
end;

local function getAimAssistPixelRadius() -- Line: 132
    -- upvalues: success (copy), result (copy)
    if success and result then
        local success2, result2 = pcall(function() -- Line: 134
            -- upvalues: result (ref)
            return result.AimAssistPixelRadius:Get();
        end);

        if success2 and type(result2) == "number" then
            return result2;
        end;
    end;

    return 120;
end;

local function resolveTarget(p20, p21, p22) -- Line: 144
    -- upvalues: success (copy), result (copy), Players (copy), LocalPlayer (copy), raycastFromScreen (copy)
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return nil, nil;
    end;

    local v23 = Vector2.new(p21, p22);
    local v24;

    if success and result then
        local success2, result2 = pcall(function() -- Line: 134
            -- upvalues: result (ref)
            return result.AimAssistPixelRadius:Get();
        end);
        v24 = (not success2 or type(result2) ~= "number") and 120 or result2;
    else
        v24 = 120;
    end;

    if v24 > 0 then
        local v25 = nil;
        local v26 = nil;

        for _, v in Players:GetPlayers() do
            if v ~= LocalPlayer then
                local Character = v.Character;

                if Character then
                    local v27 = Character:FindFirstChildOfClass("Humanoid");

                    if v27 and v27.Health > 0 then
                        local v28 = Character:FindFirstChild("UpperTorso") or (Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart"));

                        if not (v28 and v28:IsA("BasePart")) then
                            v28 = nil;
                        end;

                        if v28 then
                            local v29, v30 = CurrentCamera:WorldToScreenPoint(v28.Position);

                            if v30 then
                                local Magnitude = (Vector2.new(v29.X, v29.Y) - v23).Magnitude;

                                if Magnitude <= v24 then
                                    v26 = v28;
                                    v25 = v;
                                    v24 = Magnitude;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;

        if v25 and v26 then
            return v26.Position, v25;
        end;
    end;

    return raycastFromScreen(p20, p21, p22), nil;
end;

local function faceTarget(p31, p32) -- Line: 186
    local v33 = p31:FindFirstChildOfClass("Humanoid");

    if v33 and v33.SeatPart then
        return;
    end;

    local HumanoidRootPart = p31:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return;
    end;

    local Position = HumanoidRootPart.Position;
    local v34 = Vector3.new(p32.X, Position.Y, p32.Z);

    if (v34 - Position).Magnitude < 0.01 then
        return;
    end;

    HumanoidRootPart.CFrame = CFrame.lookAt(Position, v34);
end;

local u35 = nil;
local u36 = nil;

local function isPCInput() -- Line: 207
    -- upvalues: UserInputService (copy)
    return UserInputService.MouseEnabled and UserInputService.KeyboardEnabled;
end;

local function isMobileInput() -- Line: 211
    -- upvalues: UserInputService (copy)
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled;
end;

local function stopAimFacing() -- Line: 215
    -- upvalues: u35 (ref), u36 (ref), LocalPlayer (copy)
    if u35 then
        u35:Disconnect();
        u35 = nil;
    end;

    if u36 ~= nil then
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        if Character then
            Character.AutoRotate = u36;
        end;

        u36 = nil;
    end;
end;

local function startAimFacing() -- Line: 230
    -- upvalues: u35 (ref), UserInputService (copy), LocalPlayer (copy), u36 (ref), RunService (copy), raycastFromScreen (copy)
    if u35 then
        return;
    end;

    if not (UserInputService.MouseEnabled and UserInputService.KeyboardEnabled) then
        return;
    end;

    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    if not Character then
        return;
    end;

    u36 = Character.AutoRotate;
    Character.AutoRotate = false;
    u35 = RunService.RenderStepped:Connect(function() -- Line: 241
        -- upvalues: LocalPlayer (ref), raycastFromScreen (ref)
        local Character2 = LocalPlayer.Character;

        if not Character2 then
            return;
        end;

        local v37 = Character2:FindFirstChildOfClass("Humanoid");

        if not v37 or v37.Health <= 0 then
            return;
        end;

        if v37.SeatPart then
            return;
        end;

        local HumanoidRootPart = Character2:FindFirstChild("HumanoidRootPart");

        if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
            return;
        end;

        local v38 = LocalPlayer:GetMouse();
        local v39 = raycastFromScreen(Character2, v38.X, v38.Y);

        if not v39 then
            return;
        end;

        local Position = HumanoidRootPart.Position;
        local v40 = Vector3.new(v39.X, Position.Y, v39.Z);

        if (v40 - Position).Magnitude < 0.01 then
            return;
        end;

        HumanoidRootPart.CFrame = CFrame.lookAt(Position, v40);
    end);
end;

local function playHitVFX(p41) -- Line: 275
    -- upvalues: ReplicatedStorage (copy), Debris (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("GearAssets");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("StrawberrySniperHitVFX");
    end;

    if not (Assets and Assets:IsA("BasePart")) then
        warn("[StrawberrySniper] HitVFX template missing under Assets.GearAssets.StrawberrySniperHitVFX");

        return;
    end;

    local v42 = Assets:Clone();
    v42.Anchored = true;
    v42.CanCollide = false;
    v42.CanQuery = false;
    v42.CanTouch = false;
    v42.CFrame = CFrame.new(p41);
    v42.Parent = workspace;
    local v43 = 0;

    for _, descendant in v42:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local v44 = descendant:GetAttribute("EmitCount");
            descendant:Emit(typeof(v44) ~= "number" and 25 or v44);
            descendant.Enabled = false;
            v43 = math.max(v43, descendant.Lifetime.Max);
        end;
    end;

    Debris:AddItem(v42, math.max(v43, 2) + 0.1);
end;

local u45 = false;
local u46 = 0;
local u47 = 0;
local u48 = nil;

local function easeOutQuad(p49) -- Line: 321
    return 1 - (1 - p49) * (1 - p49);
end;

local function currentRecoilAngle() -- Line: 325
    -- upvalues: u45 (ref), u46 (ref), u47 (ref)
    if not u45 then
        return 0;
    end;

    local v50 = os.clock() - u46;

    if v50 < 0.15 then
        local v51 = v50 / 0.15;

        return u47 + (0.3 - u47) * (1 - (1 - v51) * (1 - v51));
    end;

    local v52 = v50 - 0.15;

    if v52 < 0.3 then
        local v53 = v52 / 0.3;

        return (1 - (1 - (1 - v53) * (1 - v53))) * 0.3;
    end;

    u45 = false;

    return 0;
end;

local function applyRecoil() -- Line: 341
    -- upvalues: u45 (ref), u48 (ref), u46 (ref), u47 (ref)
    if not u45 then
        if u48 then
            u48:Disconnect();
            u48 = nil;
        end;

        return;
    end;

    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    local v54;

    if u45 then
        local v55 = os.clock() - u46;

        if v55 < 0.15 then
            local v56 = v55 / 0.15;
            v54 = u47 + (0.3 - u47) * (1 - (1 - v56) * (1 - v56));
        else
            local v57 = v55 - 0.15;

            if v57 < 0.3 then
                local v58 = v57 / 0.3;
                v54 = (1 - (1 - (1 - v58) * (1 - v58))) * 0.3;
            else
                u45 = false;
                v54 = 0;
            end;
        end;
    else
        v54 = 0;
    end;

    if v54 ~= 0 then
        CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.Angles(math.rad(v54), 0, 0);
    end;
end;

local function fireRecoil() -- Line: 359
    -- upvalues: u47 (ref), u45 (ref), u46 (ref), u48 (ref), RunService (copy), applyRecoil (copy)
    local v59;

    if u45 then
        local v60 = os.clock() - u46;

        if v60 < 0.15 then
            local v61 = v60 / 0.15;
            v59 = u47 + (0.3 - u47) * (1 - (1 - v61) * (1 - v61));
        else
            local v62 = v60 - 0.15;

            if v62 < 0.3 then
                local v63 = v62 / 0.3;
                v59 = (1 - (1 - (1 - v63) * (1 - v63))) * 0.3;
            else
                u45 = false;
                v59 = 0;
            end;
        end;
    else
        v59 = 0;
    end;

    u47 = v59;
    u46 = os.clock();
    u45 = true;

    if not u48 then
        u48 = RunService.RenderStepped:Connect(applyRecoil);
    end;
end;

function v1.OnToolActivated(p64, p65, p66) -- Line: 373
    -- upvalues: UserInputService (copy), LocalPlayer (copy), resolveTarget (copy), faceTarget (copy), Networking (copy), playSniperSfx (copy), u47 (ref), u45 (ref), u46 (ref), u48 (ref), RunService (copy), applyRecoil (copy), u8 (ref), Animation3 (copy)
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not p66 then
        return;
    end;

    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    if p65.Parent ~= Character then
        return;
    end;

    local v67 = p65:GetAttribute("CooldownEnd");

    if typeof(v67) == "number" and os.clock() < v67 then
        return;
    end;

    local v68 = LocalPlayer:GetMouse();

    if not v68 then
        return;
    end;

    local v69, v70 = resolveTarget(Character, v68.X, v68.Y);

    if not v69 then
        return;
    end;

    faceTarget(Character, v69);
    Networking.StrawberrySniper.Fire:Fire(v69, p65, v70);
    playSniperSfx("Fire");
    local v71;

    if u45 then
        local v72 = os.clock() - u46;

        if v72 < 0.15 then
            local v73 = v72 / 0.15;
            v71 = u47 + (0.3 - u47) * (1 - (1 - v73) * (1 - v73));
        else
            local v74 = v72 - 0.15;

            if v74 < 0.3 then
                local v75 = v74 / 0.3;
                v71 = (1 - (1 - (1 - v75) * (1 - v75))) * 0.3;
            else
                u45 = false;
                v71 = 0;
            end;
        end;
    else
        v71 = 0;
    end;

    u47 = v71;
    u46 = os.clock();
    u45 = true;

    if not u48 then
        u48 = RunService.RenderStepped:Connect(applyRecoil);
    end;

    local v76 = Character:FindFirstChildOfClass("Humanoid");

    if v76 then
        v76 = v76:FindFirstChildOfClass("Animator");
    end;

    if v76 then
        if u8 then
            u8:Stop();
        end;

        local v77 = v76:LoadAnimation(Animation3);
        v77.Priority = Enum.AnimationPriority.Action;
        u8 = v77;
        v77:Play();
    end;

    local v78 = p65:GetAttribute("Cooldown");
    local v79 = typeof(v78) ~= "number" and 1.5 or v78;
    p65:SetAttribute("CooldownEnd", os.clock() + v79);
end;

function v1.OnEquipped(p80, u81) -- Line: 427
    -- upvalues: u5 (ref), playSniperSfx (copy), startAimFacing (copy), LocalPlayer (copy), u9 (ref), u6 (ref), u7 (ref), Animation (copy), Animation2 (copy)
    u5 = u81;
    playSniperSfx("Equip");
    startAimFacing();
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    if Character then
        Character = Character:FindFirstChildOfClass("Animator");
    end;

    if Character then
        u9 = u9 + 1;
        local u82 = u9;

        if u6 then
            u6:Stop();
            u6 = nil;
        end;

        if u7 then
            u7:Stop();
            u7 = nil;
        end;

        local v83 = Character:LoadAnimation(Animation);
        u6 = v83;
        v83:Play();
        v83.Stopped:Once(function() -- Line: 458
            -- upvalues: u82 (copy), u9 (ref), u5 (ref), u81 (copy), Character (copy), Animation2 (ref), u7 (ref)
            if u82 ~= u9 then
                return;
            end;

            if u5 ~= u81 then
                return;
            end;

            local v84 = Character:LoadAnimation(Animation2);
            v84.Looped = true;
            u7 = v84;
            v84:Play();
        end);
    end;
end;

function v1.OnUnequipped(p85) -- Line: 469
    -- upvalues: u5 (ref), u9 (ref), u6 (ref), u7 (ref), u8 (ref), u35 (ref), u36 (ref), LocalPlayer (copy)
    u5 = nil;
    u9 = u9 + 1;

    if u6 then
        u6:Stop();
        u6 = nil;
    end;

    if u7 then
        u7:Stop();
        u7 = nil;
    end;

    if u8 then
        u8:Stop();
        u8 = nil;
    end;

    if u35 then
        u35:Disconnect();
        u35 = nil;
    end;

    if u36 ~= nil then
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        if Character then
            Character.AutoRotate = u36;
        end;

        u36 = nil;
    end;
end;

function v1.SetupCharacter(u86, p87) -- Line: 489
    -- upvalues: u2 (copy)
    local function tryConnect(u88) -- Line: 490
        -- upvalues: u2 (ref), u86 (copy)
        if u88:IsA("Tool") and u88:GetAttribute("StrawberrySniper") then
            if u2[u88] then
                return;
            end;

            u2[u88] = true;
            u88.Activated:Connect(function() -- Line: 494
                -- upvalues: u86 (ref), u88 (copy)
                u86:OnToolActivated(u88);
            end);
            u88.Equipped:Connect(function() -- Line: 497
                -- upvalues: u86 (ref), u88 (copy)
                u86:OnEquipped(u88);
            end);
            u88.Unequipped:Connect(function() -- Line: 500
                -- upvalues: u86 (ref)
                u86:OnUnequipped();
            end);
        end;
    end;

    p87.ChildAdded:Connect(tryConnect);

    for _, child in p87:GetChildren() do
        tryConnect(child);
    end;
end;

function v1.Init(p89) -- Line: 515
end;

function v1.Start(u90) -- Line: 518
    -- upvalues: Networking (copy), playHitVFX (copy), UserInputService (copy), u5 (ref), LocalPlayer (copy), u9 (ref), u6 (ref), u7 (ref), u8 (ref), u35 (ref), u36 (ref)
    Networking.StrawberrySniper.HitVFX.OnClientEvent:Connect(function(p91) -- Line: 519
        -- upvalues: playHitVFX (ref)
        playHitVFX(p91);
    end);

    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        UserInputService.TouchTapInWorld:Connect(function(p92, p93) -- Line: 527
            -- upvalues: u5 (ref), u90 (copy)
            if p93 then
                return;
            end;

            local v94 = u5;

            if not v94 then
                return;
            end;

            u90:OnToolActivated(v94, true);
        end);
    end;

    local Character = LocalPlayer.Character;

    if Character then
        u90:SetupCharacter(Character);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p95) -- Line: 540
        -- upvalues: u5 (ref), u9 (ref), u6 (ref), u7 (ref), u8 (ref), u35 (ref), u36 (ref), u90 (copy)
        u5 = nil;
        u9 = u9 + 1;
        u6 = nil;
        u7 = nil;
        u8 = nil;

        if u35 then
            u35:Disconnect();
            u35 = nil;
        end;

        u36 = nil;
        u90:SetupCharacter(p95);
    end);
end;

return v1;