-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local Notify = ReplicatedStorage:WaitForChild("Notify");

local function ComputePhase(p1) -- Line: 27
    if p1 <= 0 then
        return 0;
    end;

    if p1 > 13 then
        return (p1 - 13) / 0.25 + 9.611640903764576;
    end;

    local v2 = 4 - p1 * 3.75 / 13;

    return math.log(4 / (v2 <= 0.001 and 0.001 or v2)) * 3.466666666666667;
end;

return function(u3) -- Line: 44
    -- upvalues: LocalPlayer (copy), Notify (copy), Networking (copy), Players (copy)
    local Data = u3.Build.Data;
    local TargetTilt = Data.TargetTilt;
    local UP = Data:FindFirstChild("UP");
    local Tilt = u3.Build.Tilt;
    local ATT1 = Tilt.Center.ATT1;
    local u4 = false;

    for _, descendant in Tilt:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = false;
        end;
    end;

    local u5 = u3:GetAttribute("UserId");
    local u6 = u3:GetAttribute("PropId");
    local u7 = { Tilt.OBJ1, Tilt.OBJ2 };

    for _, v in u7 do
        if v:IsA("BasePart") then
            v.CanCollide = false;
        end;
    end;

    local u8 = { nil, nil };
    local u9 = { nil, nil };
    local u10 = false;
    local u11 = nil;
    local u12 = nil;
    local u13 = nil;

    local function CancelSoloNotify() -- Line: 75
        -- upvalues: u13 (ref)
        if u13 then
            task.cancel(u13);
            u13 = nil;
        end;
    end;

    local function ScheduleSoloNotify() -- Line: 82
        -- upvalues: u13 (ref), u9 (copy), LocalPlayer (ref), Notify (ref)
        if u13 then
            task.cancel(u13);
            u13 = nil;
        end;

        u13 = task.delay(2, function() -- Line: 84
            -- upvalues: u13 (ref), u9 (ref), LocalPlayer (ref), Notify (ref)
            u13 = nil;

            if u9[1] ~= LocalPlayer.UserId and u9[2] ~= LocalPlayer.UserId then
                return;
            end;

            if (not u9[1] or u9[1] == LocalPlayer.UserId) and (not u9[2] or u9[2] == LocalPlayer.UserId) then
                Notify:Fire("Ask a friend to join you!");
            end;
        end);
    end;

    local u14 = 0;
    local u15 = 0;
    local u16 = 0;

    local function UpdateTilt(p17) -- Line: 111
        -- upvalues: ATT1 (copy)
        ATT1.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, (math.rad(p17)));
    end;

    local function SampleTiltVelocity(p18) -- Line: 115
        -- upvalues: u15 (ref), u16 (ref), u14 (ref)
        local v19 = os.clock();

        if u15 > 0 then
            local v20 = v19 - u15;

            if v20 > 0.0001 then
                u16 = (p18 - u14) / v20;
            end;
        end;

        u14 = p18;
        u15 = v19;
    end;

    local function ResetTiltVelocitySample() -- Line: 127
        -- upvalues: u15 (ref), u16 (ref), u14 (ref), TargetTilt (copy)
        u15 = 0;
        u16 = 0;
        u14 = TargetTilt.Value;
    end;

    local function ApplyLocalExitFling(p21) -- Line: 133
        -- upvalues: LocalPlayer (ref), u16 (ref), u3 (copy)
        local Character = LocalPlayer.Character;

        if not Character then
            return;
        end;

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
        local u22 = Character:FindFirstChildWhichIsA("Humanoid");

        if not (HumanoidRootPart and u22) then
            return;
        end;

        local v23 = math.abs(u16) / 376.99111843077515;
        local v24 = math.clamp(v23, 0, 1);
        local v25 = math.lerp(1.5, 22.5, v24);
        local LookVector = HumanoidRootPart.CFrame.LookVector;
        local v26 = Vector3.new(LookVector.X, 0, LookVector.Z);
        local v27 = v26.Magnitude <= 0.01 and Vector3.new(0, 0, 1) or v26.Unit;
        local v28 = v27 * 7.5 * v25 + Vector3.new(0, v25 * 24, 0);
        u22.PlatformStand = true;
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, 2.5, 0);
        HumanoidRootPart.AssemblyLinearVelocity = v28;
        local v29 = v27:Cross(Vector3.new(0, 1, 0));
        local u30;

        if v29.Magnitude > 0.1 then
            u30 = v29.Unit * (v24 * 21 * v25);
            HumanoidRootPart.AssemblyAngularVelocity = u30;
        else
            u30 = Vector3.new(0, 0, 0);
        end;

        task.spawn(function() -- Line: 165
            -- upvalues: Character (copy), u3 (ref), u30 (ref), u22 (copy), HumanoidRootPart (copy)
            local v31 = RaycastParams.new();
            v31.FilterType = Enum.RaycastFilterType.Exclude;
            v31.FilterDescendantsInstances = { Character, u3 };
            local v32 = u30;

            while u22.Parent and (HumanoidRootPart.Parent and u22.PlatformStand) do
                if workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -4, 0), v31) then
                    HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
                    local v33 = Vector3.new(HumanoidRootPart.CFrame.LookVector.X, 0, HumanoidRootPart.CFrame.LookVector.Z);

                    if v33.Magnitude > 0.01 then
                        HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + v33);
                    end;

                    break;
                end;

                v32 = v32 * 0.92;
                HumanoidRootPart.AssemblyAngularVelocity = v32;
                task.wait();
            end;

            if u22.Parent then
                u22.PlatformStand = false;
            end;
        end);
    end;

    local function ClearWeld(p34) -- Line: 192
        -- upvalues: u8 (copy)
        if u8[p34] then
            u8[p34]:Destroy();
            u8[p34] = nil;
        end;
    end;

    local function CreateWeld(p35, p36) -- Line: 199
        -- upvalues: u8 (copy), u7 (copy)
        if u8[p35] then
            u8[p35]:Destroy();
            u8[p35] = nil;
        end;

        local HumanoidRootPart = p36:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart then
            return;
        end;

        local Weld = Instance.new("Weld");
        Weld.Name = "SeatWeld";
        Weld.Part0 = u7[p35];
        Weld.Part1 = HumanoidRootPart;
        Weld.C0 = CFrame.new(0, 2, 0);
        Weld.Parent = u7[p35];
        u8[p35] = Weld;
    end;

    local function StopAnimation() -- Line: 213
        -- upvalues: u10 (ref), u11 (ref), u4 (ref), ATT1 (copy), TargetTilt (copy), UP (copy), u15 (ref), u16 (ref), u14 (ref)
        u10 = false;

        if u11 then
            task.cancel(u11);
            u11 = nil;
        end;

        if not u4 then
            ATT1.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
            TargetTilt.Value = 0;

            if UP then
                UP.Value = 0;
            end;
        end;

        u15 = 0;
        u16 = 0;
        u14 = TargetTilt.Value;
    end;

    local function StartAnimation(u37) -- Line: 227
        -- upvalues: u10 (ref), u11 (ref), u4 (ref), ATT1 (copy), TargetTilt (copy), UP (copy), u15 (ref), u16 (ref), u14 (ref), u13 (ref)
        u10 = false;

        if u11 then
            task.cancel(u11);
            u11 = nil;
        end;

        if not u4 then
            ATT1.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
            TargetTilt.Value = 0;

            if UP then
                UP.Value = 0;
            end;
        end;

        u15 = 0;
        u16 = 0;
        u14 = TargetTilt.Value;

        if u13 then
            task.cancel(u13);
            u13 = nil;
        end;

        u10 = true;
        u11 = task.spawn(function() -- Line: 232
            -- upvalues: u10 (ref), u4 (ref), u37 (copy), ATT1 (ref), u15 (ref), u16 (ref), u14 (ref), TargetTilt (ref), UP (ref)
            while u10 and not u4 do
                local v38 = workspace:GetServerTimeNow() - u37;
                local v39;

                if v38 <= 0 then
                    v39 = 0;
                elseif v38 <= 13 then
                    local v40 = 4 - v38 * 3.75 / 13;
                    v39 = math.log(4 / (v40 <= 0.001 and 0.001 or v40)) * 3.466666666666667;
                else
                    v39 = (v38 - 13) / 0.25 + 9.611640903764576;
                end;

                local v41 = math.sin(6.283185307179586 * v39) * 15;
                ATT1.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, (math.rad(v41)));
                local v42 = os.clock();

                if u15 > 0 then
                    local v43 = v42 - u15;

                    if v43 > 0.0001 then
                        u16 = (v41 - u14) / v43;
                    end;
                end;

                u14 = v41;
                u15 = v42;
                TargetTilt.Value = v41;

                if UP then
                    UP.Value = v38 * 0.6;
                end;

                task.wait();
            end;
        end);
    end;

    local function ConnectLocalUnsit() -- Line: 246
        -- upvalues: u12 (ref), LocalPlayer (ref), u13 (ref), u9 (copy), u8 (copy), ApplyLocalExitFling (copy), u10 (ref), u11 (ref), u4 (ref), ATT1 (copy), TargetTilt (copy), UP (copy), u15 (ref), u16 (ref), u14 (ref), Networking (ref), u5 (copy), u6 (copy)
        if u12 then
            u12:Disconnect();
            u12 = nil;
        end;

        local Character = LocalPlayer.Character;

        if not Character then
            return;
        end;

        local u44 = Character:FindFirstChildWhichIsA("Humanoid");

        if not u44 then
            return;
        end;

        u12 = u44:GetPropertyChangedSignal("Sit"):Connect(function() -- Line: 257
            -- upvalues: u44 (copy), u13 (ref), u9 (ref), LocalPlayer (ref), u8 (ref), ApplyLocalExitFling (ref), u10 (ref), u11 (ref), u4 (ref), ATT1 (ref), TargetTilt (ref), UP (ref), u15 (ref), u16 (ref), u14 (ref), Networking (ref), u5 (ref), u6 (ref)
            if u44.Sit then
                return;
            end;

            if u13 then
                task.cancel(u13);
                u13 = nil;
            end;

            for i = 1, 2 do
                if u9[i] == LocalPlayer.UserId then
                    if u8[i] then
                        u8[i]:Destroy();
                        u8[i] = nil;
                    end;

                    ApplyLocalExitFling(i);
                    u9[i] = nil;
                    u10 = false;

                    if u11 then
                        task.cancel(u11);
                        u11 = nil;
                    end;

                    if not u4 then
                        ATT1.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
                        TargetTilt.Value = 0;

                        if UP then
                            UP.Value = 0;
                        end;
                    end;

                    u15 = 0;
                    u16 = 0;
                    u14 = TargetTilt.Value;
                    Networking.Seesaw.Unsit:Fire(u5, u6, i);

                    return;
                end;
            end;
        end);
    end;

    local u64 = Networking.Seesaw.SeatChanged.OnClientEvent:Connect(function(p45, p46, p47, p48, u49) -- Line: 273
        -- upvalues: u5 (copy), u6 (copy), u8 (copy), u9 (copy), u10 (ref), u11 (ref), u4 (ref), ATT1 (copy), TargetTilt (copy), UP (copy), u15 (ref), u16 (ref), u14 (ref), LocalPlayer (ref), u13 (ref), Players (ref), CreateWeld (copy)
        if p45 ~= u5 or p46 ~= u6 then
            return;
        end;

        if p48 ~= 0 then
            if p48 == LocalPlayer.UserId then
                if u49 > 0 then
                    u10 = false;

                    if u11 then
                        task.cancel(u11);
                        u11 = nil;
                    end;

                    if not u4 then
                        ATT1.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
                        TargetTilt.Value = 0;

                        if UP then
                            UP.Value = 0;
                        end;
                    end;

                    u15 = 0;
                    u16 = 0;
                    u14 = TargetTilt.Value;

                    if u13 then
                        task.cancel(u13);
                        u13 = nil;
                    end;

                    u10 = true;
                    u11 = task.spawn(function() -- Line: 232
                        -- upvalues: u10 (ref), u4 (ref), u49 (copy), ATT1 (ref), u15 (ref), u16 (ref), u14 (ref), TargetTilt (ref), UP (ref)
                        while u10 and not u4 do
                            local v50 = workspace:GetServerTimeNow() - u49;
                            local v51;

                            if v50 <= 0 then
                                v51 = 0;
                            elseif v50 <= 13 then
                                local v52 = 4 - v50 * 3.75 / 13;
                                v51 = math.log(4 / (v52 <= 0.001 and 0.001 or v52)) * 3.466666666666667;
                            else
                                v51 = (v50 - 13) / 0.25 + 9.611640903764576;
                            end;

                            local v53 = math.sin(6.283185307179586 * v51) * 15;
                            ATT1.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, (math.rad(v53)));
                            local v54 = os.clock();

                            if u15 > 0 then
                                local v55 = v54 - u15;

                                if v55 > 0.0001 then
                                    u16 = (v53 - u14) / v55;
                                end;
                            end;

                            u14 = v53;
                            u15 = v54;
                            TargetTilt.Value = v53;

                            if UP then
                                UP.Value = v50 * 0.6;
                            end;

                            task.wait();
                        end;
                    end);
                end;

                return;
            end;

            u9[p47] = p48;
            local v56 = Players:GetPlayerByUserId(p48);

            if v56 and v56.Character then
                local v57 = v56.Character:FindFirstChildWhichIsA("Humanoid");

                if v57 then
                    v57.Sit = true;
                end;

                CreateWeld(p47, v56.Character);
            end;

            if u49 > 0 then
                u10 = false;

                if u11 then
                    task.cancel(u11);
                    u11 = nil;
                end;

                if not u4 then
                    ATT1.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
                    TargetTilt.Value = 0;

                    if UP then
                        UP.Value = 0;
                    end;
                end;

                u15 = 0;
                u16 = 0;
                u14 = TargetTilt.Value;

                if u13 then
                    task.cancel(u13);
                    u13 = nil;
                end;

                u10 = true;
                u11 = task.spawn(function() -- Line: 232
                    -- upvalues: u10 (ref), u4 (ref), u49 (copy), ATT1 (ref), u15 (ref), u16 (ref), u14 (ref), TargetTilt (ref), UP (ref)
                    while u10 and not u4 do
                        local v58 = workspace:GetServerTimeNow() - u49;
                        local v59;

                        if v58 <= 0 then
                            v59 = 0;
                        elseif v58 <= 13 then
                            local v60 = 4 - v58 * 3.75 / 13;
                            v59 = math.log(4 / (v60 <= 0.001 and 0.001 or v60)) * 3.466666666666667;
                        else
                            v59 = (v58 - 13) / 0.25 + 9.611640903764576;
                        end;

                        local v61 = math.sin(6.283185307179586 * v59) * 15;
                        ATT1.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, (math.rad(v61)));
                        local v62 = os.clock();

                        if u15 > 0 then
                            local v63 = v62 - u15;

                            if v63 > 0.0001 then
                                u16 = (v61 - u14) / v63;
                            end;
                        end;

                        u14 = v61;
                        u15 = v62;
                        TargetTilt.Value = v61;

                        if UP then
                            UP.Value = v58 * 0.6;
                        end;

                        task.wait();
                    end;
                end);
            end;

            return;
        end;

        if u8[p47] then
            u8[p47]:Destroy();
            u8[p47] = nil;
        end;

        u9[p47] = nil;
        u10 = false;

        if u11 then
            task.cancel(u11);
            u11 = nil;
        end;

        if not u4 then
            ATT1.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
            TargetTilt.Value = 0;

            if UP then
                UP.Value = 0;
            end;
        end;

        u15 = 0;
        u16 = 0;
        u14 = TargetTilt.Value;
    end);

    for i = 1, 2 do
        u7[i].Touched:Connect(function(p65) -- Line: 310
            -- upvalues: u9 (copy), i (copy), LocalPlayer (ref), CreateWeld (copy), ConnectLocalUnsit (copy), u13 (ref), Notify (ref), Networking (ref), u5 (copy), u6 (copy)
            if u9[i] then
                return;
            end;

            local v66 = p65:FindFirstAncestorWhichIsA("Model");

            if v66 ~= LocalPlayer.Character then
                return;
            end;

            local v67 = v66:FindFirstChildWhichIsA("Humanoid");

            if not v67 then
                return;
            end;

            if v67.Sit then
                return;
            end;

            v67.Sit = true;
            CreateWeld(i, v66);
            u9[i] = LocalPlayer.UserId;
            ConnectLocalUnsit();

            if u13 then
                task.cancel(u13);
                u13 = nil;
            end;

            u13 = task.delay(2, function() -- Line: 84
                -- upvalues: u13 (ref), u9 (ref), LocalPlayer (ref), Notify (ref)
                u13 = nil;

                if u9[1] ~= LocalPlayer.UserId and u9[2] ~= LocalPlayer.UserId then
                    return;
                end;

                if (not u9[1] or u9[1] == LocalPlayer.UserId) and (not u9[2] or u9[2] == LocalPlayer.UserId) then
                    Notify:Fire("Ask a friend to join you!");
                end;
            end);
            Networking.Seesaw.Sit:Fire(u5, u6, i);
        end);
    end;

    ConnectLocalUnsit();
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 333
        -- upvalues: ConnectLocalUnsit (copy)
        task.wait();
        ConnectLocalUnsit();
    end);
    u3.Destroying:Connect(function() -- Line: 338
        -- upvalues: u4 (ref), u13 (ref), u9 (copy), LocalPlayer (ref), u8 (copy), u10 (ref), u11 (ref), ATT1 (copy), TargetTilt (copy), UP (copy), u15 (ref), u16 (ref), u14 (ref), u64 (copy), u12 (ref)
        u4 = true;

        if u13 then
            task.cancel(u13);
            u13 = nil;
        end;

        for i = 1, 2 do
            if u9[i] == LocalPlayer.UserId then
                if u8[i] then
                    u8[i]:Destroy();
                    u8[i] = nil;
                end;

                u9[i] = nil;
                local Character = LocalPlayer.Character;

                if Character then
                    local v68 = Character:FindFirstChildWhichIsA("Humanoid");

                    if v68 then
                        v68.Sit = false;
                    end;
                end;
            elseif u8[i] then
                if u8[i] then
                    u8[i]:Destroy();
                    u8[i] = nil;
                end;

                u9[i] = nil;
            end;
        end;

        u10 = false;

        if u11 then
            task.cancel(u11);
            u11 = nil;
        end;

        if not u4 then
            ATT1.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
            TargetTilt.Value = 0;

            if UP then
                UP.Value = 0;
            end;
        end;

        u15 = 0;
        u16 = 0;
        u14 = TargetTilt.Value;
        u64:Disconnect();

        if u12 then
            u12:Disconnect();
        end;
    end);
    ATT1.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
    Networking.Seesaw.RequestState:Fire(u5, u6);
end;