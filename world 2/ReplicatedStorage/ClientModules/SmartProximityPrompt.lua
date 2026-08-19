-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = nil;

local function getCharacterPosition() -- Line: 11
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        return HumanoidRootPart.Position;
    end;

    return nil;
end;

local function getClosestPointOnPart(p4, p5) -- Line: 25
    local v6 = p4.CFrame:PointToObjectSpace(p5);
    local v7 = p4.Size * 0.5;
    local v8 = math.clamp(v6.X, -v7.X, v7.X);
    local v9 = math.clamp(v6.Y, -v7.Y, v7.Y);
    local v10 = math.clamp(v6.Z, -v7.Z, v7.Z);
    local v11 = Vector3.new(v8, v9, v10);

    return p4.CFrame:PointToWorldSpace(v11);
end;

local function getBestPromptPosition(p12, p13, p14) -- Line: 38
    -- upvalues: getClosestPointOnPart (copy)
    local v15 = (1 / 0);
    local v16 = nil;

    for _, v in p12 do
        if v.Parent then
            local v17 = getClosestPointOnPart(v, p13);
            local Magnitude = (p13 - v17).Magnitude;

            if Magnitude < v15 then
                v16 = v17;
                v15 = Magnitude;
            end;
        end;
    end;

    if not v16 then
        return nil;
    end;

    local v18 = p13 - v16;

    return v16 + (v18.Magnitude < 0.0001 and Vector3.new(0, 1, 0) or v18.Unit) * p14;
end;

local function rebuildPartCache(p19, p20) -- Line: 66
    local v21 = {};

    for _, descendant in p19:GetDescendants() do
        if descendant:IsA("BasePart") and descendant ~= p20 then
            table.insert(v21, descendant);
        end;
    end;

    return v21;
end;

local function getOrCreateAnchorPart(p22, p23) -- Line: 76
    local v24 = p22:FindFirstChild(p23);

    if v24 and v24:IsA("BasePart") then
        return v24;
    end;

    local v25 = p22.PrimaryPart or p22:FindFirstChildWhichIsA("BasePart");

    if not v25 then
        return nil;
    end;

    local Part = Instance.new("Part");
    Part.Name = p23;
    Part.Size = Vector3.new(1, 1, 1);
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanTouch = false;
    Part.CanQuery = false;
    Part.CFrame = v25.CFrame;
    Part.Parent = p22;

    return Part;
end;

local function ensureHeartbeat() -- Line: 101
    -- upvalues: u3 (ref), RunService (copy), u2 (copy), LocalPlayer (copy), getBestPromptPosition (copy)
    if u3 then
        return;
    end;

    u3 = RunService.Heartbeat:Connect(function(p26) -- Line: 106
        -- upvalues: u2 (ref), u3 (ref), LocalPlayer (ref), getBestPromptPosition (ref)
        if next(u2) == nil then
            if u3 then
                u3:Disconnect();
                u3 = nil;
            end;

            return;
        end;

        local Character = LocalPlayer.Character;
        local v27;

        if Character then
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

            if HumanoidRootPart then
                v27 = HumanoidRootPart.Position;
            else
                v27 = nil;
            end;
        else
            v27 = nil;
        end;

        if not v27 then
            return;
        end;

        for i, v in u2 do
            if i.Parent then
                local model = v.model;
                local part = v.part;

                if model and (model.Parent and (part and part.Parent)) then
                    if v.trackDistance >= (model:GetPivot().Position - v27).Magnitude then
                        local v28 = getBestPromptPosition(v.parts, v27, v.surfaceOffset);

                        if v28 then
                            local v29 = math.clamp(p26 * v.followSpeed, 0, 1);
                            part.CFrame = CFrame.new(part.Position:Lerp(v28, v29));
                        end;
                    end;
                else
                    if v.partsConn then
                        v.partsConn:Disconnect();
                    end;

                    if v.partsRemovedConn then
                        v.partsRemovedConn:Disconnect();
                    end;

                    u2[i] = nil;
                end;
            else
                if v.partsConn then
                    v.partsConn:Disconnect();
                end;

                if v.partsRemovedConn then
                    v.partsRemovedConn:Disconnect();
                end;

                u2[i] = nil;
            end;
        end;
    end);
end;

function v1.AttachToModel(u30, u31, p32) -- Line: 153
    -- upvalues: getOrCreateAnchorPart (copy), rebuildPartCache (copy), u2 (copy), u3 (ref), RunService (copy), LocalPlayer (copy), getBestPromptPosition (copy)
    local v33 = p32 or {};

    if not (u30 and u31) then
        return function() -- Line: 156
        end;
    end;

    local v34 = v33.PartName or "SmartPromptPart";
    local v35 = tonumber(v33.SurfaceOffset) or 0.75;
    local v36 = tonumber(v33.FollowSpeed) or 18;
    local v37 = tonumber(v33.TrackDistance) or 24;
    local v38 = tonumber(v33.MaxActivationDistance);
    local u39 = getOrCreateAnchorPart(u31, v34);

    if not u39 then
        return function() -- Line: 167
        end;
    end;

    if v38 then
        u30.MaxActivationDistance = v38;
    end;

    u30.RequiresLineOfSight = false;
    u30.Parent = u39;
    local u40 = {
        model = u31,
        part = u39,
        surfaceOffset = v35,
        followSpeed = v36,
        trackDistance = math.max(v37, u30.MaxActivationDistance + 8),
        parts = rebuildPartCache(u31, u39)
    };

    local function refreshParts(p41) -- Line: 189
        -- upvalues: u40 (copy), rebuildPartCache (ref), u31 (copy), u39 (copy)
        if p41 and not p41:IsA("BasePart") then
            return;
        end;

        u40.parts = rebuildPartCache(u31, u39);
    end;

    u40.partsConn = u31.DescendantAdded:Connect(refreshParts);
    u40.partsRemovedConn = u31.DescendantRemoving:Connect(refreshParts);
    u2[u30] = u40;

    if not u3 then
        u3 = RunService.Heartbeat:Connect(function(p42) -- Line: 106
            -- upvalues: u2 (ref), u3 (ref), LocalPlayer (ref), getBestPromptPosition (ref)
            if next(u2) == nil then
                if u3 then
                    u3:Disconnect();
                    u3 = nil;
                end;

                return;
            end;

            local Character = LocalPlayer.Character;
            local v43;

            if Character then
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                if HumanoidRootPart then
                    v43 = HumanoidRootPart.Position;
                else
                    v43 = nil;
                end;
            else
                v43 = nil;
            end;

            if not v43 then
                return;
            end;

            for i, v in u2 do
                if i.Parent then
                    local model = v.model;
                    local part = v.part;

                    if model and (model.Parent and (part and part.Parent)) then
                        if v.trackDistance >= (model:GetPivot().Position - v43).Magnitude then
                            local v44 = getBestPromptPosition(v.parts, v43, v.surfaceOffset);

                            if v44 then
                                local v45 = math.clamp(p42 * v.followSpeed, 0, 1);
                                part.CFrame = CFrame.new(part.Position:Lerp(v44, v45));
                            end;
                        end;
                    else
                        if v.partsConn then
                            v.partsConn:Disconnect();
                        end;

                        if v.partsRemovedConn then
                            v.partsRemovedConn:Disconnect();
                        end;

                        u2[i] = nil;
                    end;
                else
                    if v.partsConn then
                        v.partsConn:Disconnect();
                    end;

                    if v.partsRemovedConn then
                        v.partsRemovedConn:Disconnect();
                    end;

                    u2[i] = nil;
                end;
            end;
        end);
    end;

    local function cleanup() -- Line: 201
        -- upvalues: u2 (ref), u30 (copy)
        local v46 = u2[u30];

        if v46 then
            if v46.partsConn then
                v46.partsConn:Disconnect();
            end;

            if v46.partsRemovedConn then
                v46.partsRemovedConn:Disconnect();
            end;
        end;

        u2[u30] = nil;
    end;

    u30.Destroying:Once(cleanup);
    u31.Destroying:Once(cleanup);

    return cleanup;
end;

return v1;