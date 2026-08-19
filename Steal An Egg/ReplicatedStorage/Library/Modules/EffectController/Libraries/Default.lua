-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Utility = require(script.Parent.Parent.Utility.Utility);
local BoatTween = require(script.Parent.BoatTween);

return {
    CreateEffect = function(p1, p2) -- Line: 10, Name: CreateEffect
        -- upvalues: Utility (copy)
        local v3 = p2.Object:Clone();
        v3.Parent = p2.Parent or workspace.__DEBRIS;

        if p2.Position then
            v3:PivotTo(typeof(p2.Position) == "Vector3" and CFrame.new(p2.Position) or p2.Position);
        end;

        if p2.Emit then
            task.delay(p2.EmitDelay, p1.Emit, p1, v3, 1);
        end;

        if p2.Attach and (v3 and (p2.Parent and (p2.Parent:IsA("Part") or p2.Parent:IsA("BasePart")))) then
            if v3:IsA("Model") then
                p1:Attach(v3.PrimaryPart, p2.Parent);
            else
                p1:Attach(v3, p2.Parent);
            end;
        end;

        if p2.DebrisTime then
            Utility:AddItem(v3, p2.DebrisTime);
        end;

        if p2.RaycastColored then
            local v4 = workspace:Raycast(p2.RaycastColored.Origin, p2.RaycastColored.Direction, Utility.RayParams);

            if not v4 then
                return;
            end;

            for _, descendant in v3:GetDescendants() do
                if descendant:IsA("ParticleEmitter") and descendant:GetAttribute("Raycast") then
                    descendant.Color = ColorSequence.new(v4.Instance.Color, v4.Instance.Color);
                end;
            end;
        end;

        return v3;
    end,

    Emit = function(p5, p6, u7, p8) -- Line: 51, Name: Emit
        -- upvalues: TweenService (copy), RunService (copy)
        for _, descendant in p6:GetDescendants() do
            if not (p8 and p8[descendant.Name]) then
                if descendant:IsA("ParticleEmitter") then
                    local v9 = descendant:GetAttribute("EmitDuration") or 0;

                    if v9 < 0.05 then
                        task.delay(descendant:GetAttribute("EmitDelay"), function() -- Line: 57
                            -- upvalues: descendant (copy)
                            descendant:Emit(descendant:GetAttribute("EmitCount"));
                        end);
                    else
                        local u10 = os.clock() + v9;
                        task.spawn(function() -- Line: 62
                            -- upvalues: descendant (copy), u10 (copy)
                            repeat
                                descendant:Emit(descendant:GetAttribute("EmitCount"));
                                task.wait(0.1);
                            until u10 - os.clock() <= 0;
                        end);
                    end;
                elseif descendant:IsA("PointLight") or (descendant:IsA("SpotLight") or descendant:IsA("SurfaceLight")) then
                    TweenService:Create(descendant, TweenInfo.new(u7 or 1), {
                        Brightness = 0
                    }):Play();
                elseif descendant:IsA("Decal") then
                    TweenService:Create(descendant, TweenInfo.new(u7 or 1), {
                        Transparency = 1
                    }):Play();
                elseif descendant:IsA("Beam") then
                    local function UpdateTransparency(p11) -- Line: 78
                        -- upvalues: descendant (copy)
                        descendant.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, p11), NumberSequenceKeypoint.new(1, p11) });
                    end;

                    task.spawn(function() -- Line: 84
                        -- upvalues: descendant (copy), u7 (copy), TweenService (ref), UpdateTransparency (copy), RunService (ref)
                        local v12 = os.clock();
                        local Value = descendant.Transparency.Keypoints[2].Value;

                        repeat
                            local v13 = (os.clock() - v12) / u7;
                            UpdateTransparency((TweenService:GetValue(math.clamp(v13, Value, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)));
                            RunService.Heartbeat:Wait();
                        until u7 < os.clock() - v12;

                        UpdateTransparency(1);
                    end);
                end;
            end;
        end;
    end,

    Attach = function(p14, p15, p16, p17) -- Line: 100, Name: Attach
        -- upvalues: Utility (copy)
        local WeldConstraint = Instance.new("WeldConstraint");
        p15.Massless = true;
        p15.CanCollide = false;
        WeldConstraint.Part0 = p16;
        WeldConstraint.Part1 = p15;
        WeldConstraint.Parent = p15;

        if p17 then
            Utility:AddItem(WeldConstraint, p17);
        end;
    end,

    PlaySound = function(p18, p19, p20) -- Line: 112, Name: PlaySound
        -- upvalues: Utility (copy)
        local v21 = p19:Clone();
        v21.Parent = p20;
        v21:Play();

        if not p19.Looped then
            Utility:AddItem(v21, p19.TimeLength > 0.1 and p19.TimeLength or 1);
        end;

        return v21;
    end,

    SetScale = function(p22, p23, p24, p25) -- Line: 121, Name: SetScale
        for _, descendant in p23:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                if not (table.find(p25, descendant) or table.find(p25, descendant.Name)) then
                    local v26 = {};

                    for _, v in ipairs(descendant.Size.Keypoints) do
                        table.insert(v26, NumberSequenceKeypoint.new(v.Time, v.Value * p24, v.Envelope * p24));
                    end;

                    local v27 = NumberSequence.new(v26);
                    local v28 = NumberRange.new(descendant.Speed.Min * p24, descendant.Speed.Max * p24);
                    local v29 = descendant.Acceleration * p24;
                    descendant.Size = v27;
                    descendant.Speed = v28;
                    descendant.Acceleration = v29;
                end;
            elseif descendant:IsA("Attachment") then
                descendant.Position = descendant.Position * p24;
            elseif descendant:IsA("Beam") then
                descendant.CurveSize0 = descendant.CurveSize0 * p24;
                descendant.CurveSize1 = descendant.CurveSize1 * p24;
                descendant.Width0 = descendant.Width0 * p24;
                descendant.Width1 = descendant.Width1 * p24;
            end;
        end;

        p23:SetAttribute("Scale", p24);
    end,

    ScaleTo = function(u30, u31, u32, u33, p34) -- Line: 151, Name: ScaleTo
        -- upvalues: TweenService (copy), RunService (copy)
        local u35 = p34 or {};

        if not u35 then
            return;
        end;

        task.spawn(function() -- Line: 156
            -- upvalues: u31 (copy), u33 (copy), TweenService (ref), u32 (copy), u30 (copy), u35 (ref), RunService (ref)
            local v36 = os.clock();
            local v37 = u31:GetAttribute("Scale") or 1;

            repeat
                local v38 = (os.clock() - v36) / u33;
                local v39 = TweenService:GetValue(math.clamp(v38, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut);
                u30:SetScale(u31, v37 + (u32 - v37) * v39, u35);
                RunService.Heartbeat:Wait();
            until u33 < os.clock() - v36 or not u31;

            if not u31 then
                return;
            end;

            u30:SetScale(u31, u32, u35);
        end);
    end,

    AdjustSpeed = function(p40) -- Line: 176, Name: AdjustSpeed
    end,

    Recolor = function(p41) -- Line: 178, Name: Recolor
    end,

    CreateLighting = function(p42, p43, p44, p45) -- Line: 180, Name: CreateLighting
        -- upvalues: Lighting (copy), Utility (copy)
        local v46 = Instance.new(p43);
        v46.Parent = Lighting;

        for i, v in p44 do
            if v46[i] then
                v46[i] = v;
            end;
        end;

        if p45 then
            Utility:AddItem(v46, p45);
        end;

        return v46;
    end,

    UpdateStatus = function(p47, p48, u49, p50) -- Line: 194, Name: UpdateStatus
        -- upvalues: BoatTween (copy), TweenService (copy)
        if typeof(p48) == "Instance" then
            p48 = p48:GetDescendants() or p48;
        end;

        for _, v in p48 do
            if not (p50 and p50[v.Name]) then
                task.spawn(function() -- Line: 198
                    -- upvalues: v (copy), u49 (copy), BoatTween (ref), TweenService (ref)
                    if v:IsA("ParticleEmitter") then
                        v.Enabled = u49;

                        return;
                    end;

                    if not (v:IsA("Beam") or v:IsA("Trail")) then
                        if v:IsA("PointLight") or v:IsA("SpotLight") then
                            if u49 then
                                v.Enabled = false;

                                return;
                            end;

                            TweenService:Create(v, TweenInfo.new(1), {
                                Brightness = 0
                            }):Play();
                        end;

                        return;
                    end;

                    if u49 then
                        v.Enabled = true;

                        return;
                    end;

                    local u51 = BoatTween:Create(v, {
                        Time = 1,
                        EasingStyle = "EntranceExpressive",
                        EasingDirection = "Out",
                        StepType = "RenderStepped",
                        Goal = v:IsA("Beam") and {
                            TextureSpeed = 0,
                            Transparency = NumberSequence.new(1, 1)
                        } or {
                            Transparency = NumberSequence.new(1, 1)
                        }
                    });
                    u51:Play();
                    u51.Completed:Connect(function() -- Line: 220
                        -- upvalues: u51 (copy)
                        u51:Destroy();
                    end);
                end);
            end;
        end;
    end
};