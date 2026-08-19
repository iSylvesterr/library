-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = {};
local Animation = Instance.new("Animation");
Animation.AnimationId = "rbxassetid://102073079493908";
local Reticule = script.Reticule;

local function PlaySound(p3, p4, p5) -- Line: 23
    if p3 then
        local Sound = Instance.new("Sound");
        Sound.SoundId = p4;
        Sound.Volume = 1;
        Sound.RollOffMaxDistance = 300;
        Sound.Looped = p5 or false;
        Sound.Parent = p3;
        Sound:Play();

        if not p5 then
            Sound.Ended:Once(function() -- Line: 35
                -- upvalues: Sound (copy)
                Sound:Destroy();
            end);
        end;

        return Sound;
    end;
end;

function v1.Setup(u6) -- Line: 43
    -- upvalues: u2 (copy)
    u2[u6] = {
        Effects = {}
    };
    local v7 = game.MaterialService.ToolMaterials.GlowWeldTemplate:Clone();
    v7.EmissiveTint = Color3.fromRGB(49, 255, 255);
    v7.EmissiveStrength = 0;
    v7.Parent = game.MaterialService.ToolMaterials;
    v7.Name = "Magnet-" .. tostring(os.time());
    u2[u6].Material = v7;
    u6.Handle.MaterialVariant = v7.Name;
    u6.Destroying:Connect(function() -- Line: 57
        -- upvalues: u2 (ref), u6 (copy)
        u2[u6].Material:Destroy();
        u2[u6].Active = false;

        if u2[u6].PullingSound then
            u2[u6].PullingSound:Destroy();
            u2[u6].PullingSound = nil;
        end;

        for _, v in u2[u6].Effects do
            v:Destroy();
        end;

        u2[u6] = nil;
    end);
end;

local u8 = RaycastParams.new();
u8.FilterDescendantsInstances = {};

local function castGroundRay(p9, p10) -- Line: 81
    -- upvalues: u8 (copy)
    local v11 = game.Workspace:Raycast(p9, p10, u8);

    if not v11 then
        return v11, 0;
    end;

    if not v11.Instance then
        return v11, 0;
    end;

    if v11.Instance.Transparency < 1 then
        return v11, 0;
    end;

    local v12 = RaycastParams.new();
    v12.FilterType = u8.FilterType;
    v12.IgnoreWater = u8.IgnoreWater;
    v12.RespectCanCollide = u8.RespectCanCollide;
    v12.FilterDescendantsInstances = u8.FilterDescendantsInstances;
    v12:AddToFilter(v11.Instance);

    for i = 1, 8 do
        local v13 = game.Workspace:Raycast(p9, p10, v12);

        if not v13 then
            return v13, i;
        end;

        if not v13.Instance then
            return v13, i;
        end;

        if v13.Instance.Transparency < 1 then
            return v13, i;
        end;

        v12:AddToFilter(v13.Instance);
    end;

    return nil, 8;
end;

function v1.Enable(u14, p15, p16) -- Line: 115
    -- upvalues: PlaySound (copy), Animation (copy), u2 (copy), Reticule (copy), u8 (copy), castGroundRay (copy)
    local u17 = p15 or u14:FindFirstChildOfClass("Tool");
    local u18 = u14:FindFirstChild("HumanoidRootPart") or u14.PrimaryPart;
    PlaySound(u18, "rbxassetid://139786085754154");
    local u19 = u17.Handle.Start:GetChildren();
    local u20 = u14.Humanoid.Animator:LoadAnimation(Animation);
    local u21 = false;
    u20:GetMarkerReachedSignal("Activate"):Once(function() -- Line: 138
        -- upvalues: u21 (ref)
        u21 = true;
    end);
    u20:Play(0.05, 10, 1);
    game.TweenService:Create(u2[u17].Material, TweenInfo.new(0.4), {
        EmissiveStrength = 5
    }):Play();

    for _, v in u19 do
        task.delay(v:GetAttribute("EmitDelay") or 0, function() -- Line: 151
            -- upvalues: v (copy)
            v:Emit(v:GetAttribute("EmitCount") or 1);
            v.Enabled = true;
        end);
    end;

    task.wait(0.4);

    if not u21 then
        repeat
            task.wait();
        until u21;
    end;

    u20:AdjustSpeed(0);
    PlaySound(u18, "rbxassetid://114743198643478");
    local v22 = u2[u17];
    local v23;

    if u18 then
        v23 = Instance.new("Sound");
        v23.SoundId = "rbxassetid://72523912557145";
        v23.Volume = 1;
        v23.RollOffMaxDistance = 300;
        v23.Looped = true;
        v23.Parent = u18;
        v23:Play();
    else
        v23 = nil;
    end;

    v22.PullingSound = v23;
    local u24 = script.Highlight:Clone();
    u24.Parent = u17;
    u24.Enabled = true;
    game.TweenService:Create(u24, TweenInfo.new(0.3), {
        OutlineTransparency = 0
    }):Play();
    game.TweenService:Create(u2[u17].Material, TweenInfo.new(0.2), {
        EmissiveStrength = 15
    }):Play();
    task.delay(0.5, function() -- Line: 183
        -- upvalues: u2 (ref), u17 (copy), u24 (copy)
        game.TweenService:Create(u2[u17].Material, TweenInfo.new(0.4), {
            EmissiveStrength = 5
        }):Play();
        game.TweenService:Create(u24, TweenInfo.new(0.4), {
            OutlineTransparency = 0.8
        }):Play();
        u17.Handle.Glow:Emit(15);
        u17.Handle.Glow.Enabled = true;
    end);
    u2[u17].Active = true;
    local u25 = Reticule:Clone();
    local v26 = not p16 and u25.Size or Vector3.new(0.1, p16, p16);
    u25.Size = Vector3.new(0.1, 0.1, 0.1);
    game.TweenService:Create(u25, TweenInfo.new(0.5), {
        Size = v26
    }):Play();
    u25.Parent = workspace.Temporary;

    for _, child in u25.Activate:GetChildren() do
        child:Emit(child:GetAttribute("EmitCount"));
    end;

    local function updatePosition() -- Line: 206
        -- upvalues: u8 (ref), castGroundRay (ref), u14 (copy), u25 (copy)
        u8.FilterDescendantsInstances = game.CollectionService:GetTagged("Character");
        local v27 = castGroundRay(u14.PrimaryPart.Position, Vector3.new(-0, -30, -0));
        local v28;

        if v27 then
            v28 = CFrame.new(v27.Position + Vector3.new(0, 0.05, 0));
        else
            v28 = CFrame.new(u14.PrimaryPart.Position - Vector3.new(0, 2.95, 0));
        end;

        u25:PivotTo(v28);
    end;

    updatePosition();
    local u29 = u14.Torso:WaitForChild("Left Shoulder");
    local u30 = u14.Torso:WaitForChild("Right Shoulder");
    local C0 = u29.C0;
    local C02 = u30.C0;
    task.spawn(function() -- Line: 229
        -- upvalues: u17 (copy), u14 (copy), u2 (ref), u30 (copy), C02 (copy), u29 (copy), C0 (copy)
        local v31 = 0;

        while u17:IsDescendantOf(u14) and u2[u17].Active do
            v31 = v31 + task.wait(0);
            local v32 = CFrame.Angles((math.sin(v31 * 35) * 0.6 + math.sin(v31 * 47) * 0.4) * 0.05235987755982989, (math.sin(v31 * 41) * 0.5 + math.sin(v31 * 53) * 0.5) * 0.05235987755982989, (math.sin(v31 * 38) * 0.6 + math.sin(v31 * 49) * 0.4) * 0.05235987755982989);
            u30.C0 = C02 * v32;
            u29.C0 = C0 * v32;
        end;

        u29.C0 = C0;
        u30.C0 = C02;
    end);
    task.spawn(function() -- Line: 252
        -- upvalues: u17 (copy), u14 (copy), u2 (ref), updatePosition (copy), PlaySound (ref), u18 (copy), u25 (copy), u20 (copy), u19 (copy), u24 (copy)
        while u17:IsDescendantOf(u14) and u2[u17].Active do
            task.wait(0);
            updatePosition();
        end;

        if u2[u17] and u2[u17].PullingSound then
            u2[u17].PullingSound:Stop();
            u2[u17].PullingSound:Destroy();
            u2[u17].PullingSound = nil;
        end;

        PlaySound(u18, "rbxassetid://114743198643478");

        for _, child in u25.Activate:GetChildren() do
            child:Emit(child:GetAttribute("EmitCount"));
        end;

        for _, descendant in u25:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;

        game.TweenService:Create(u25, TweenInfo.new(0.5), {
            Size = Vector3.new(0.1, 0.1, 0.1)
        }):Play();
        game.TweenService:Create(u25.SurfaceGui.Frame, TweenInfo.new(0.5), {
            BackgroundTransparency = 1
        }):Play();
        game.TweenService:Create(u25.SurfaceGui.Frame.UIStroke, TweenInfo.new(0.5), {
            Transparency = 1
        }):Play();
        game.Debris:AddItem(u25, 3);
        u20:AdjustSpeed(-2);
        game.TweenService:Create(u2[u17].Material, TweenInfo.new(0.4), {
            EmissiveStrength = 0
        }):Play();

        for _, v in u19 do
            v:Emit(v:GetAttribute("EmitCount") or 1);
            v.Enabled = false;
        end;

        u17.Handle.Glow.Enabled = false;
        game.TweenService:Create(u24, TweenInfo.new(0.3), {
            OutlineTransparency = 1
        }):Play();
        game.Debris:AddItem(u24, 0.3);
    end);
end;

function v1.AddTarget(p33, p34) -- Line: 304
    -- upvalues: u2 (copy)
    if not (u2[p33] and u2[p33].Active) then
        return false;
    end;

    if u2[p33].Effects[p34] then
        u2[p33].Effects[p34]:Destroy();
    end;

    local v35 = script.Attachment:Clone();
    local v36 = p33.Handle.Beams:Clone();
    v36.Parent = v35;

    for _, child in v36:GetChildren() do
        child.Attachment1 = v35;
        child.Enabled = true;
    end;

    if p34:IsA("BasePart") then
        v35.Parent = p34;
    elseif p34:IsA("Model") then
        v35.Parent = p34.PrimaryPart;
    end;

    u2[p33].Effects[p34] = v35;

    return true;
end;

function v1.RemoveTarget(p37, p38) -- Line: 338
    -- upvalues: u2 (copy)
    if u2[p37].Effects[p38] then
        u2[p37].Effects[p38]:Destroy();
    end;
end;

function v1.Disable(p39, p40) -- Line: 345
    -- upvalues: u2 (copy)
    local v41 = p40 or p39:FindFirstChildOfClass("Tool");
    u2[v41].Active = false;

    for i, v in u2[v41].Effects do
        v:Destroy();
        u2[v41].Effects[i] = nil;
    end;
end;

return v1;