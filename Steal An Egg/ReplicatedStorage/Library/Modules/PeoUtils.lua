-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local HttpService = game:GetService("HttpService");
local TweenService = game:GetService("TweenService");
local BindableEvent = Instance.new("BindableEvent");
local u1 = {};
local u31 = {
    ResizeParticlesByFactor = function(p2, p3) -- Line: 10, Name: ResizeParticlesByFactor
        if not p2 then
            return;
        end;

        local v4 = p3 or 1;

        for _, descendant in pairs(p2:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                local v5 = {};

                for _, v in pairs(descendant.Size.Keypoints) do
                    table.insert(v5, NumberSequenceKeypoint.new(v.Time, v.Value * v4, v.Envelope * v4));
                end;

                descendant.Size = NumberSequence.new(v5);
            end;
        end;
    end,

    EmitParticles = function(p6) -- Line: 33, Name: EmitParticles
        if p6 then
            for _, descendant in pairs(p6:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    local u7 = descendant:GetAttribute("EmitCount");
                    local v8 = descendant:GetAttribute("EmitDelay");

                    if v8 then
                        task.delay(v8, function() -- Line: 42
                            -- upvalues: descendant (copy), u7 (copy)
                            descendant:Emit(u7 or 0);
                        end);
                    elseif u7 then
                        descendant:Emit(u7);
                    end;
                end;
            end;

            return true;
        end;
    end,

    EmitParticlesAndExecute = function(p9, u10) -- Line: 53, Name: EmitParticlesAndExecute
        if p9 then
            for _, descendant in pairs(p9:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    local u11 = descendant:GetAttribute("EmitCount");
                    local v12 = descendant:GetAttribute("EmitDelay");

                    if v12 then
                        task.delay(v12, function() -- Line: 62
                            -- upvalues: descendant (copy), u11 (copy), u10 (copy)
                            descendant:Emit(u11 or 0);

                            if u10 then
                                task.defer(u10, descendant);
                            end;
                        end);
                    elseif u11 then
                        descendant:Emit(u11);

                        if u10 then
                            task.defer(u10, descendant);
                        end;
                    end;
                end;
            end;

            return true;
        end;
    end,

    ValidateBeforeEmitParticles = function(p13, p14) -- Line: 79, Name: ValidateBeforeEmitParticles
        if p13 and p14 then
            for _, descendant in pairs(p13:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") and p14(descendant) then
                    local u15 = descendant:GetAttribute("EmitCount");
                    local v16 = descendant:GetAttribute("EmitDelay");

                    if v16 then
                        task.delay(v16, function() -- Line: 88
                            -- upvalues: descendant (copy), u15 (copy)
                            descendant:Emit(u15 or 0);
                        end);
                    elseif u15 then
                        descendant:Emit(u15);
                    end;
                end;
            end;

            return true;
        end;
    end,

    SetParticleEnabled = function(p17, p18) -- Line: 99, Name: SetParticleEnabled
        if p17 then
            for _, descendant in pairs(p17:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = p18;
                end;
            end;

            return true;
        end;
    end,

    CFrameLookAt = function(p19, p20) -- Line: 111, Name: CFrameLookAt
        local Unit = (p20 - p19).Unit;
        local v21 = -(Unit ~= Unit and Vector3.new(0, 0, -1) or Unit);
        local v22 = v21:Cross(Vector3.new(0, -1, 0));
        local v23 = v21:Cross(v22);

        return CFrame.fromMatrix(p19, v22, v23, v21);
    end,

    DeferredTask = function(u24) -- Line: 122, Name: DeferredTask
        local u25 = {};
        local u26 = {};
        local u27 = "Processing";
        local u28 = nil;

        function u25.AndThen(p29, p30) -- Line: 127
            -- upvalues: u27 (ref), u26 (copy), u28 (ref), u25 (copy)
            if u27 == "Processing" then
                table.insert(u26, p30);
            else
                p30(table.unpack(u28 or {}));
            end;

            return u25;
        end;

        local function resolve(...) -- Line: 135
            -- upvalues: u28 (ref), u27 (ref), u26 (copy)
            u28 = { ... };
            u27 = "Resolved";

            for _, v in pairs(u26) do
                v(table.unpack(u28));
            end;
        end;

        coroutine.wrap(function() -- Line: 142
            -- upvalues: u24 (copy), resolve (copy)
            pcall(u24, resolve);
        end)();

        return u25;
    end
};

function u31.Trajectory(p32, p33, p34) -- Line: 148
    -- upvalues: u31 (copy)
    local Gravity = workspace.Gravity;
    local v35 = p33 - p32;
    local v36 = Vector3.new(v35.X, 0, v35.Z);
    local Magnitude = v36.Magnitude;
    local Y = v35.Y;
    local v37 = math.rad(p34);
    local v38 = math.cos(v37) ^ 2 * 2 * (Magnitude * math.tan(v37) - Y);

    if v38 <= 0 then
        return u31.TimedTrajectory(p32, p33, 1);
    end;

    local v39 = math.sqrt(Gravity * Magnitude ^ 2 / v38);

    if v39 == v39 then
        local v40 = v36.Unit * v39 * math.cos(v37);
        local v41 = v39 * math.sin(v37);

        return v40 + Vector3.new(0, v41, 0);
    end;
end;

function u31.TimedTrajectory(p42, p43, p44) -- Line: 172
    local Gravity = workspace.Gravity;
    local v45 = p43 - p42;

    return Vector3.new(v45.X, 0, v45.Z) / p44 + Vector3.new(0, (v45.Y + 0.5 * Gravity * p44 ^ 2) / p44, 0);
end;

function u31.Dust(p46, p47, p48) -- Line: 180
    -- upvalues: BindableEvent (copy)
    if not p47 then
        return;
    end;

    local v49 = p48 or 1;

    if typeof(v49) ~= "number" or v49 <= 0 then
        return;
    end;

    BindableEvent:Fire(p47, v49);
end;

function u31.GetMobCenterPosition(p50) -- Line: 191
    local Monster = workspace:FindFirstChild("Monster");

    if not Monster then
        return nil;
    end;

    local v51 = Vector3.new(0, 0, 0);
    local v52 = 0;

    for _, child in ipairs(Monster:GetChildren()) do
        if child:IsA("Folder") then
            for _, child2 in ipairs(child:GetChildren()) do
                if child2:IsA("Model") and (child2.Name == p50 and child2.PrimaryPart) then
                    v51 = v51 + child2.PrimaryPart.Position;
                    v52 = v52 + 1;
                end;
            end;
        end;
    end;

    if v52 == 0 then
        return nil;
    end;

    return v51 / v52;
end;

function u31.KillThread(p53) -- Line: 215
    -- upvalues: u1 (copy)
    if typeof(p53) == "table" then
        for _, v in ipairs(p53) do
            local v54 = u1[v];

            if v54 then
                v54._Dead = true;
                u1[v] = nil;
            end;
        end;

        return;
    end;

    local v55 = u1[p53];

    if v55 then
        v55._Dead = true;
        u1[p53] = nil;
    end;
end;

BindableEvent.Event:Connect(function(u56, p57) -- Line: 235
    -- upvalues: u31 (copy), u1 (copy)
    u31.KillThread(u56);
    local u58 = {};

    if typeof(u56) == "table" then
        for _, v in ipairs(u56) do
            u58[v] = {
                _Dead = false
            };
            u1[v] = u58[v];
        end;
    else
        u58[u56] = {
            _Dead = false
        };
        u1[u56] = u58[u56];
    end;

    task.delay(p57, function() -- Line: 247
        -- upvalues: u56 (copy), u58 (copy), u31 (ref)
        if typeof(u56) == "table" then
            for _, v in ipairs(u56) do
                local v59 = u58[v];

                if v59 and not v59._Dead then
                    if v and v:IsDescendantOf(game) then
                        v:Destroy();
                    end;

                    u31.KillThread(v);
                end;
            end;

            table.clear(u58);

            return;
        end;

        local v60 = u58[u56];

        if not v60 or v60._Dead then
            return;
        end;

        if u56 and u56:IsDescendantOf(game) then
            u56:Destroy();
        end;

        u31.KillThread(u56);
        table.clear(u58);
    end);
end);

function u31.PlayOneShotAnim(p61, p62, p63, p64) -- Line: 276
    local u65 = p61:LoadAnimation(p62);

    if p64 then
        u65:AdjustSpeed(p64);
    end;

    u65:Play(p63 or 0);
    local u66 = nil;
    u66 = u65.Stopped:Once(function() -- Line: 283
        -- upvalues: u65 (copy), u66 (ref)
        u65:Destroy();

        if u66 then
            u66:Disconnect();
            u66 = nil;
        end;
    end);

    return u65;
end;

function u31.RandomUniqueId() -- Line: 293
    -- upvalues: HttpService (copy)
    return HttpService:GenerateGUID(false):gsub("-", ""):sub(1, 15):gsub(".", function(p67) -- Line: 295
        if math.random() < 0.5 then
            p67 = string.upper(p67) or p67;
        end;

        return p67;
    end);
end;

function u31.LerpCF(u68, u69, u70) -- Line: 301
    -- upvalues: RunService (copy), TweenService (copy)
    local CFrame2 = u68.CFrame;
    local u71 = 0;
    local u73 = RunService.Heartbeat:Connect(function(p72) -- Line: 304
        -- upvalues: u71 (ref), u69 (copy), TweenService (ref), u68 (copy), CFrame2 (copy), u70 (copy)
        u71 = math.min(u71 + p72 / u69.Time, 1);
        u68.CFrame = CFrame2:Lerp(u70, (TweenService:GetValue(u71, u69.EasingStyle or Enum.EasingStyle.Linear, u69.EasingDirection or Enum.EasingDirection.InOut)));
    end);
    task.delay(u69.Time + 0.001, function() -- Line: 313
        -- upvalues: u73 (ref)
        u73:Disconnect();
        u73 = nil;
    end);
end;

return u31;