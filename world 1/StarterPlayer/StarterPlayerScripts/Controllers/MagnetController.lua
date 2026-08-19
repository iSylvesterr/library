-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local MagnetEffect = require(ReplicatedStorage.ClientModules.MagnetEffect);
local MagnetData = require(ReplicatedStorage.SharedModules.MagnetData);
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local u2 = MagnetData.Data[1] and MagnetData.Data[1].Range or 63;
local u3 = {};
local u4 = {};
local u5 = {};

local function isMagnet(p6) -- Line: 45
    local v7 = p6:IsA("Tool") and p6:GetAttribute("PlayerMagnet") ~= nil;

    return v7;
end;

local function isOnCooldown(p8) -- Line: 49
    local v9 = p8:GetAttribute("CooldownEnd");
    local v10;

    if typeof(v9) == "number" then
        v10 = os.clock() < v9;
    else
        v10 = false;
    end;

    return v10;
end;

local function resolveRig(p11) -- Line: 57
    local Handle = p11:FindFirstChild("Handle");

    if Handle and (Handle:IsA("BasePart") and Handle:FindFirstChild("Start")) then
        return Handle;
    end;

    local Start = p11:FindFirstChild("Start", true);

    if Start and (Start.Parent and Start.Parent:IsA("BasePart")) then
        return Start.Parent;
    end;

    return nil;
end;

local function ensureSetup(p12) -- Line: 71
    -- upvalues: u3 (copy), resolveRig (copy), MagnetEffect (copy)
    if u3[p12] then
        return true;
    end;

    local v13 = resolveRig(p12);

    if not v13 then
        for _ = 1, 20 do
            task.wait(0.1);

            if not p12:IsDescendantOf(game) then
                return false;
            end;

            v13 = resolveRig(p12);

            if v13 then
                break;
            end;
        end;
    end;

    if not v13 then
        if p12:IsDescendantOf(game) then
            warn((`[Magnet] tool "{p12.Name}" has no rig part containing "Start" (looked at Handle + child parts). MagnetEffect cannot play -- the tool model needs a part with Start/Glow/Beams.`));
        end;

        return false;
    end;

    for _, v in { "Glow", "Beams" } do
        if not v13:FindFirstChild(v) then
            warn((`[Magnet] tool "{p12.Name}" rig part "{v13.Name}" is missing "{v}" -- MagnetEffect may error.`));
        end;
    end;

    local success, result = pcall(MagnetEffect.Setup, p12);

    if success then
        u3[p12] = true;

        return true;
    end;

    warn((`[Magnet] MagnetEffect.Setup failed for "{p12.Name}": {result}`));
    u3[p12] = false;

    return false;
end;

local function resolvePullTarget(p14) -- Line: 121
    local CFrame = p14.CFrame;
    local v15 = -CFrame.LookVector - CFrame.RightVector;
    local v16 = Vector3.new(v15.X, 0, v15.Z);
    local v17;

    if v16.Magnitude > 0.001 then
        v17 = v16.Unit;
    else
        if v15.Magnitude <= 0.001 then
            return p14.Position;
        end;

        v17 = v15.Unit;
    end;

    return p14.Position + v17 * 2;
end;

local function playEffect(u18, u19, p20, p21) -- Line: 137
    -- upvalues: u5 (copy), ensureSetup (copy), MagnetEffect (copy), Players (copy)
    if u5[u18] then
        return;
    end;

    if not ensureSetup(u18) then
        return;
    end;

    u5[u18] = true;
    local u22 = p20 * 2;
    task.spawn(function() -- Line: 157
        -- upvalues: MagnetEffect (ref), u19 (copy), u18 (copy), u22 (copy)
        local success, result = pcall(MagnetEffect.Enable, u19, u18, u22);

        if not success then
            warn((`[Magnet] MagnetEffect.Enable errored: {result}`));
        end;
    end);
    local v23 = os.clock();
    local v24 = {};

    while true do
        local v25 = os.clock() - v23 < p21 and u18:IsDescendantOf(u19) and u19.PrimaryPart;

        if not v25 then
            break;
        end;

        local Position = v25.Position;
        local v26 = {};

        for _, v in Players:GetPlayers() do
            if v.Character ~= u19 then
                local Character = v.Character;
                local v27;

                if Character then
                    v27 = Character.PrimaryPart;
                else
                    v27 = Character;
                end;

                if v27 and (v27.Position - Position).Magnitude <= p20 then
                    v26[Character] = true;

                    if not v24[Character] then
                        local success, result = pcall(MagnetEffect.AddTarget, u18, Character);

                        if success then
                            if result then
                                v24[Character] = true;
                            end;
                        else
                            warn((`[Magnet] AddTarget failed for {v.Name}: {result}`));
                        end;
                    end;
                end;
            end;
        end;

        for i in v24 do
            if not v26[i] then
                v24[i] = nil;
                pcall(MagnetEffect.RemoveTarget, u18, i);
            end;
        end;

        task.wait(0.15);
    end;

    local success, result = pcall(MagnetEffect.Disable, u19, u18);

    if not success then
        warn((`[Magnet] MagnetEffect.Disable errored: {result}`));
    end;

    u5[u18] = nil;
end;

local u28 = nil;

local function stopSelfPull() -- Line: 244
    -- upvalues: u28 (ref)
    local v29 = u28;

    if not v29 then
        return;
    end;

    u28 = nil;

    if v29.hbConn then
        v29.hbConn:Disconnect();
    end;

    if v29.align then
        v29.align:Destroy();
    end;

    if v29.att then
        v29.att:Destroy();
    end;
end;

local function onPullReceived(p30, p31, p32) -- Line: 261
    -- upvalues: u2 (copy), LocalPlayer (copy), u28 (ref), RunService (copy)
    if not (p30 and p30:IsA("BasePart")) then
        return;
    end;

    local v33 = p31 or u2;
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if not (Character and Character:IsA("BasePart")) then
        return;
    end;

    if u28 then
        u28.leaseUntil = os.clock() + 0.35000000000000003;
        u28.anchor = p30;
        u28.range = v33;

        return;
    end;

    local Attachment = Instance.new("Attachment");
    Attachment.Name = "MagnetPulledPoint";
    Attachment.Parent = Character;
    local AlignPosition = Instance.new("AlignPosition");
    AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment;
    AlignPosition.Attachment0 = Attachment;
    AlignPosition.RigidityEnabled = false;
    AlignPosition.ReactionForceEnabled = false;
    AlignPosition.Responsiveness = 95.88;
    AlignPosition.MaxForce = 0;
    local CFrame = p30.CFrame;
    local v34 = -CFrame.LookVector - CFrame.RightVector;
    local v35 = Vector3.new(v34.X, 0, v34.Z);
    local v36, v37, u38;

    if v35.Magnitude > 0.001 then
        v36 = v35.Unit;
    else
        if v34.Magnitude <= 0.001 then
            v37 = p30.Position;
            AlignPosition.Position = v37;
            AlignPosition.Parent = Character;
            u38 = {
                leaseUntil = os.clock() + 0.35000000000000003,
                anchor = p30,
                range = v33,
                att = Attachment,
                align = AlignPosition
            };
            u28 = u38;
            u38.hbConn = RunService.Heartbeat:Connect(function() -- Line: 309
                -- upvalues: u28 (ref), u38 (copy), LocalPlayer (ref)
                if u28 ~= u38 then
                    return;
                end;

                local Character2 = LocalPlayer.Character;
                local v39;

                if Character2 then
                    v39 = Character2:FindFirstChild("HumanoidRootPart");
                else
                    v39 = Character2;
                end;

                if Character2 then
                    Character2 = Character2:FindFirstChildOfClass("Humanoid");
                end;

                local anchor = u38.anchor;

                if os.clock() >= u38.leaseUntil or (not v39 or (not v39:IsA("BasePart") or (not Character2 or (Character2.Health <= 0 or (not anchor.Parent or u38.att.Parent ~= v39))))) then
                    local v40 = u28;

                    if not v40 then
                        return;
                    end;

                    u28 = nil;

                    if v40.hbConn then
                        v40.hbConn:Disconnect();
                    end;

                    if v40.align then
                        v40.align:Destroy();
                    end;

                    if v40.att then
                        v40.att:Destroy();
                    end;

                    return;
                end;

                local CFrame2 = anchor.CFrame;
                local v41 = -CFrame2.LookVector - CFrame2.RightVector;
                local v42 = Vector3.new(v41.X, 0, v41.Z);
                local v43, v44, v45;

                if v42.Magnitude > 0.001 then
                    v43 = v42.Unit;
                else
                    if v41.Magnitude <= 0.001 then
                        v44 = anchor.Position;
                        u38.align.Position = v44;
                        v45 = 1 - math.clamp((v39.Position - v44).Magnitude / u38.range, 0, 1);
                        u38.align.MaxForce = v45 ^ 1.08 * 14830.5;

                        return;
                    end;

                    v43 = v41.Unit;
                end;

                v44 = anchor.Position + v43 * 2;
                u38.align.Position = v44;
                v45 = 1 - math.clamp((v39.Position - v44).Magnitude / u38.range, 0, 1);
                u38.align.MaxForce = v45 ^ 1.08 * 14830.5;
            end);

            return;
        end;

        v36 = v34.Unit;
    end;

    v37 = p30.Position + v36 * 2;
    AlignPosition.Position = v37;
    AlignPosition.Parent = Character;
    u38 = {
        leaseUntil = os.clock() + 0.35000000000000003,
        anchor = p30,
        range = v33,
        att = Attachment,
        align = AlignPosition
    };
    u28 = u38;
    u38.hbConn = RunService.Heartbeat:Connect(function() -- Line: 309
        -- upvalues: u28 (ref), u38 (copy), LocalPlayer (ref)
        if u28 ~= u38 then
            return;
        end;

        local Character2 = LocalPlayer.Character;
        local v39;

        if Character2 then
            v39 = Character2:FindFirstChild("HumanoidRootPart");
        else
            v39 = Character2;
        end;

        if Character2 then
            Character2 = Character2:FindFirstChildOfClass("Humanoid");
        end;

        local anchor = u38.anchor;

        if os.clock() >= u38.leaseUntil or (not v39 or (not v39:IsA("BasePart") or (not Character2 or (Character2.Health <= 0 or (not anchor.Parent or u38.att.Parent ~= v39))))) then
            local v40 = u28;

            if not v40 then
                return;
            end;

            u28 = nil;

            if v40.hbConn then
                v40.hbConn:Disconnect();
            end;

            if v40.align then
                v40.align:Destroy();
            end;

            if v40.att then
                v40.att:Destroy();
            end;

            return;
        end;

        local CFrame2 = anchor.CFrame;
        local v41 = -CFrame2.LookVector - CFrame2.RightVector;
        local v42 = Vector3.new(v41.X, 0, v41.Z);
        local v43, v44, v45;

        if v42.Magnitude > 0.001 then
            v43 = v42.Unit;
        else
            if v41.Magnitude <= 0.001 then
                v44 = anchor.Position;
                u38.align.Position = v44;
                v45 = 1 - math.clamp((v39.Position - v44).Magnitude / u38.range, 0, 1);
                u38.align.MaxForce = v45 ^ 1.08 * 14830.5;

                return;
            end;

            v43 = v41.Unit;
        end;

        v44 = anchor.Position + v43 * 2;
        u38.align.Position = v44;
        v45 = 1 - math.clamp((v39.Position - v44).Magnitude / u38.range, 0, 1);
        u38.align.MaxForce = v45 ^ 1.08 * 14830.5;
    end);
end;

local function onActivateBroadcast(p46, p47, p48) -- Line: 339
    -- upvalues: playEffect (copy), u2 (copy)
    if not (p46 and p46:IsA("Tool")) then
        return;
    end;

    local Parent = p46.Parent;

    if not (Parent and (Parent:IsA("Model") and Parent:FindFirstChildOfClass("Humanoid"))) then
        return;
    end;

    task.spawn(playEffect, p46, Parent, p47 or u2, p48 or 10);
end;

local function bindTool(u49) -- Line: 354
    -- upvalues: ensureSetup (copy), u4 (copy), u3 (copy), u5 (copy)
    local v50 = u49:IsA("Tool") and u49:GetAttribute("PlayerMagnet") ~= nil;

    if not v50 then
        return;
    end;

    task.spawn(ensureSetup, u49);

    if not u4[u49] then
        u4[u49] = u49.Activated:Connect(function() -- Line: 364
            -- upvalues: u49 (copy)
            local v51 = u49:GetAttribute("CooldownEnd");
            local v52;

            if typeof(v51) == "number" then
                v52 = os.clock() < v51;
            else
                v52 = false;
            end;

            if v52 then
                return;
            end;

            u49:SetAttribute("CooldownEnd", os.clock() + 60);
        end);
    end;

    u49.AncestryChanged:Connect(function() -- Line: 374
        -- upvalues: u49 (copy), u4 (ref), u3 (ref), u5 (ref)
        if not u49:IsDescendantOf(game) then
            if u4[u49] then
                u4[u49]:Disconnect();
                u4[u49] = nil;
            end;

            u3[u49] = nil;
            u5[u49] = nil;
        end;
    end);
end;

local function watchContainer(p53) -- Line: 386
    -- upvalues: bindTool (copy)
    for _, child in p53:GetChildren() do
        bindTool(child);
    end;

    p53.ChildAdded:Connect(bindTool);
end;

function v1.Init(p54) -- Line: 393
end;

function v1.Start(p55) -- Line: 395
    -- upvalues: Networking (copy), onActivateBroadcast (copy), onPullReceived (copy), LocalPlayer (copy), stopSelfPull (copy), bindTool (copy)
    Networking.Magnet.Activate.OnClientEvent:Connect(onActivateBroadcast);
    Networking.Magnet.Pull.OnClientEvent:Connect(onPullReceived);
    LocalPlayer.CharacterAdded:Connect(stopSelfPull);
    local Backpack = LocalPlayer:WaitForChild("Backpack");

    for _, child in Backpack:GetChildren() do
        bindTool(child);
    end;

    Backpack.ChildAdded:Connect(bindTool);

    if LocalPlayer.Character then
        local Character = LocalPlayer.Character;

        for _, child in Character:GetChildren() do
            bindTool(child);
        end;

        Character.ChildAdded:Connect(bindTool);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p56) -- Line: 409
        -- upvalues: bindTool (ref)
        for _, child in p56:GetChildren() do
            bindTool(child);
        end;

        p56.ChildAdded:Connect(bindTool);
    end);
end;

return v1;