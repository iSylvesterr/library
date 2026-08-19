-- Decompiled with Potassium's decompiler.

local u27 = {
    build = function(p1, p2, p3, p4) -- Line: 40, Name: build
        local v5;

        if p4 then
            v5 = p4.Position or nil;
        else
            v5 = nil;
        end;

        local v6 = os.clock();
        local v7 = p1.StartTime and (math.max(0, v6 - p1.StartTime) or 0) or 0;
        local v8 = p1.LifeTime or 0;
        local v9 = v8 > 0 and (math.min(1, v7 / v8) or 0) or 0;
        local v10 = math.max(0, v8 - v7);
        local v11 = {
            SourceItem = p1._sourceItem,
            Source = p1._sourceItem,
            Particle = p1.VisualPart,
            RenderTemplate = p1.VisualPart,
            WorldCFrame = p4,
            WorldPosition = v5,
            LifeProgress = v9,
            TimeRemaining = v10,
            StartTime = p1.StartTime,
            LifeTime = v8,
            SpeedMultiplier = p1.SpeedMultiplier or 1,
            ChainDepth = p1.EventChainCtx and (p1.EventChainCtx.Depth or 0) or 0
        };
        local v12;

        if p3 then
            v12 = p3.EmitCount;
        else
            v12 = p3;
        end;

        v11.EmitCount = v12;
        v11._eventName = p2;

        if p2 == "OnEmit" then
            v11.EmitPosition = v5;

            if p3 then
                p3 = p3.EmitIndex;
            end;

            v11.EmitIndex = p3;

            return v11;
        end;

        if p2 ~= "OnDeath" then
            if p2 == "OnDestruction" then
                v11.DeathPosition = v5;

                if p1._lingerStartTime then
                    v11.LingerElapsed = math.max(0, v6 - p1._lingerStartTime);

                    return v11;
                end;

                v11.LingerElapsed = 0;
            end;

            return v11;
        end;

        v11.DeathPosition = v5;

        if p1.StartTime then
            v11.Age = math.max(0, v6 - p1.StartTime);

            return v11;
        end;

        v11.Age = p1.LifeTime;

        return v11;
    end,

    applyColor = function(p13, u14) -- Line: 94, Name: applyColor
        if typeof(u14) ~= "Color3" then
            return;
        end;

        p13.SkipColor = true;
        local VisualPart = p13.VisualPart;

        if not (VisualPart and VisualPart.Parent) then
            return;
        end;

        local Type = p13.Type;

        if Type == "Part" or Type == "Model" then
            if VisualPart:IsA("BasePart") then
                pcall(function() -- Line: 101
                    -- upvalues: VisualPart (copy), u14 (copy)
                    VisualPart.Color = u14;
                end);
            end;

            local u15 = VisualPart.FindFirstChildOfClass and VisualPart:FindFirstChildOfClass("SurfaceAppearance");

            if u15 then
                pcall(function() -- Line: 103
                    -- upvalues: u15 (copy), u14 (copy)
                    u15.Color = u14;
                end);
            end;
        else
            if Type == "Beam" or (Type == "TrailEmitter" or Type == "BeamNative") then
                pcall(function() -- Line: 105
                    -- upvalues: VisualPart (copy), u14 (copy)
                    VisualPart.Color = ColorSequence.new(u14);
                end);

                return;
            end;

            if Type == "PointLight" then
                pcall(function() -- Line: 107
                    -- upvalues: VisualPart (copy), u14 (copy)
                    VisualPart.Color = u14;
                end);

                return;
            end;

            if Type == "Highlight" then
                pcall(function() -- Line: 109
                    -- upvalues: VisualPart (copy), u14 (copy)
                    VisualPart.FillColor = u14;
                end);
                pcall(function() -- Line: 110
                    -- upvalues: VisualPart (copy), u14 (copy)
                    VisualPart.OutlineColor = u14;
                end);

                return;
            end;

            if Type == "ImageLabel" then
                pcall(function() -- Line: 112
                    -- upvalues: VisualPart (copy), u14 (copy)
                    VisualPart.ImageColor3 = u14;
                end);

                return;
            end;

            if Type == "Screen" then
                if p13.Kind == "ColorCorrection" then
                    pcall(function() -- Line: 115
                        -- upvalues: VisualPart (copy), u14 (copy)
                        VisualPart.TintColor = u14;
                    end);

                    return;
                end;

                if p13.Kind == "Atmosphere" then
                    pcall(function() -- Line: 117
                        -- upvalues: VisualPart (copy), u14 (copy)
                        VisualPart.Color = u14;
                    end);
                end;
            end;
        end;
    end,

    applyTransparency = function(p16, p17) -- Line: 129, Name: applyTransparency
        if type(p17) ~= "number" then
            return;
        end;

        local v18 = math.min(1, p17);
        local u19 = math.max(0, v18);
        p16.SkipTransparency = true;
        local VisualPart = p16.VisualPart;

        if not (VisualPart and VisualPart.Parent) then
            return;
        end;

        local Type = p16.Type;

        if Type == "Part" or Type == "Model" then
            if VisualPart:IsA("BasePart") then
                pcall(function() -- Line: 137
                    -- upvalues: VisualPart (copy), u19 (ref)
                    VisualPart.Transparency = u19;
                end);
            end;

            local u20 = VisualPart.FindFirstChildOfClass and VisualPart:FindFirstChildOfClass("Decal");

            if u20 then
                pcall(function() -- Line: 139
                    -- upvalues: u20 (copy), u19 (ref)
                    u20.Transparency = u19;
                end);
            end;
        elseif Type == "Beam" or (Type == "TrailEmitter" or Type == "BeamNative") then
            pcall(function() -- Line: 141
                -- upvalues: VisualPart (copy), u19 (ref)
                VisualPart.Transparency = NumberSequence.new(u19);
            end);
        elseif Type == "PointLight" then
            local u21 = p16._baseBrightness or VisualPart.Brightness;
            p16._baseBrightness = u21;
            pcall(function() -- Line: 145
                -- upvalues: VisualPart (copy), u21 (copy), u19 (ref)
                VisualPart.Brightness = u21 * (1 - u19);
            end);
        elseif Type == "Highlight" then
            pcall(function() -- Line: 147
                -- upvalues: VisualPart (copy), u19 (ref)
                VisualPart.FillTransparency = u19;
            end);
            pcall(function() -- Line: 148
                -- upvalues: VisualPart (copy), u19 (ref)
                VisualPart.OutlineTransparency = u19;
            end);
        elseif Type == "ImageLabel" then
            pcall(function() -- Line: 150
                -- upvalues: VisualPart (copy), u19 (ref)
                VisualPart.ImageTransparency = u19;
            end);
        end;
    end,

    attachSkipSetters = function(p22, u23) -- Line: 161, Name: attachSkipSetters
        function p22.SetSkipColor(p24) -- Line: 162
            -- upvalues: u23 (copy)
            u23.SkipColor = p24 == true;
        end;

        function p22.SetSkipTransparency(p25) -- Line: 163
            -- upvalues: u23 (copy)
            u23.SkipTransparency = p25 == true;
        end;

        function p22.SetSkipSize(p26) -- Line: 164
            -- upvalues: u23 (copy)
            u23.SkipSize = p26 == true;
        end;
    end
};

local function _clearSettleState(p28) -- Line: 178
    p28._settleEngaged = false;
    p28._restTimer = 0;
    p28._settleRotDamp = 1;
    p28._settleContactPos = nil;
    p28._settleSpawnHalf = nil;
    p28._lastHitNormal = nil;
    p28._collisionStopped = false;
    p28._displacementMirrorX = nil;
    p28._displacementMirrorY = nil;
    p28._displacementMirrorZ = nil;
end;

function u27.applyTeleport(p29, u30) -- Line: 191
    if typeof(u30) ~= "CFrame" then
        return;
    end;

    p29._settleEngaged = false;
    p29._restTimer = 0;
    p29._settleRotDamp = 1;
    p29._settleContactPos = nil;
    p29._settleSpawnHalf = nil;
    p29._lastHitNormal = nil;
    p29._collisionStopped = false;
    p29._displacementMirrorX = nil;
    p29._displacementMirrorY = nil;
    p29._displacementMirrorZ = nil;
    local VisualPart = p29.VisualPart;

    if not (VisualPart and VisualPart.Parent) then
        return;
    end;

    local Type = p29.Type;

    if Type == "Part" then
        pcall(function() -- Line: 198
            -- upvalues: VisualPart (copy), u30 (copy)
            VisualPart.CFrame = u30;
        end);
    elseif Type == "Attachment" then
        local Parent = VisualPart.Parent;

        if Parent and Parent:IsA("BasePart") then
            pcall(function() -- Line: 203
                -- upvalues: VisualPart (copy), Parent (copy), u30 (copy)
                VisualPart.CFrame = Parent.CFrame:ToObjectSpace(u30);
            end);
        else
            pcall(function() -- Line: 205
                -- upvalues: VisualPart (copy), u30 (copy)
                VisualPart.CFrame = u30;
            end);
        end;
    else
        if Type ~= "Model" then
            return;
        end;

        pcall(function() -- Line: 208
            -- upvalues: VisualPart (copy), u30 (copy)
            VisualPart:PivotTo(u30);
        end);
    end;

    if Type == "Attachment" then
        local Parent = VisualPart.Parent;

        if Parent and Parent:IsA("BasePart") then
            p29.LocalCF = Parent.CFrame:ToObjectSpace(u30);
        else
            p29.LocalCF = u30;
        end;
    else
        local Link = p29.Link;

        if Link and Link.Parent then
            local v31;

            if Link:IsA("Attachment") then
                v31 = Link.WorldCFrame;
            elseif Link:IsA("Model") then
                v31 = Link:GetPivot();
            else
                v31 = Link.CFrame;
            end;

            p29.LocalCF = v31:ToObjectSpace(u30);
        else
            p29.LocalCF = u30;
        end;
    end;

    p29._localWorldCF = p29.LocalCF;

    if Type == "Attachment" then
        p29._postUpdateCF = VisualPart.CFrame;
    elseif Type == "Model" then
        p29._postUpdateCF = VisualPart:GetPivot();
    else
        p29._postUpdateCF = u30;
    end;

    p29.CurrentPosition = u30.Position;
    p29.LastHitCheckPos = u30.Position;
    p29._lastOrientPos = nil;
end;

function u27.applyAddSpin(p32, p33) -- Line: 255
    if typeof(p33) ~= "Vector3" then
        return;
    end;

    p32._spinRate = (p32._spinRate or Vector3.new(0, 0, 0)) + p33;
end;

function u27.applyAddImpulse(p34, p35) -- Line: 262
    if typeof(p35) ~= "Vector3" then
        return;
    end;

    p34._settleEngaged = false;
    p34._restTimer = 0;
    p34._settleRotDamp = 1;
    p34._settleContactPos = nil;
    p34._settleSpawnHalf = nil;
    p34._lastHitNormal = nil;
    p34._collisionStopped = false;
    p34._displacementMirrorX = nil;
    p34._displacementMirrorY = nil;
    p34._displacementMirrorZ = nil;
    p34._accelVel = (p34._accelVel or Vector3.new(0, 0, 0)) + p35;
end;

function u27.applyFreezeTime(p36, p37) -- Line: 271
    p36._timeFrozen = p37 == true;
    p36._freezeTimeExplicit = p37 == true;
end;

function u27.applyPause(u38, p39) -- Line: 280
    if type(p39) ~= "number" or p39 <= 0 then
        return;
    end;

    u38._timeFrozen = true;
    local u40 = (u38._pauseGen or 0) + 1;
    u38._pauseGen = u40;
    task.delay(p39, function() -- Line: 285
        -- upvalues: u38 (copy), u40 (copy)
        if u38._pauseGen == u40 and not u38._freezeTimeExplicit then
            u38._timeFrozen = false;
        end;
    end);
end;

function u27.applySetSize(p41, u42) -- Line: 295
    p41.SkipSize = true;
    local VisualPart = p41.VisualPart;

    if not (VisualPart and VisualPart.Parent) then
        return;
    end;

    local Type = p41.Type;

    if Type == "Part" or Type == "Model" then
        if typeof(u42) == "Vector3" and VisualPart:IsA("BasePart") then
            pcall(function() -- Line: 302
                -- upvalues: VisualPart (copy), u42 (copy)
                VisualPart.Size = u42;
            end);

            return;
        end;

        if typeof(u42) == "Vector3" and Type == "Model" then
            pcall(function() -- Line: 305
                -- upvalues: VisualPart (copy), u42 (copy)
                VisualPart:ScaleTo((math.max(0.001, u42.X)));
            end);
        end;
    elseif Type == "ImageLabel" and typeof(u42) == "UDim2" then
        pcall(function() -- Line: 308
            -- upvalues: VisualPart (copy), u42 (copy)
            VisualPart.Size = u42;
        end);
    end;
end;

function u27.applySetVelocity(p43, p44) -- Line: 315
    if p44 == nil then
        p43._speedOverride = nil;

        return;
    end;

    if typeof(p44) ~= "Vector3" then
        return;
    end;

    p43._settleEngaged = false;
    p43._restTimer = 0;
    p43._settleRotDamp = 1;
    p43._settleContactPos = nil;
    p43._settleSpawnHalf = nil;
    p43._lastHitNormal = nil;
    p43._collisionStopped = false;
    p43._displacementMirrorX = nil;
    p43._displacementMirrorY = nil;
    p43._displacementMirrorZ = nil;
    local Magnitude = p44.Magnitude;

    if Magnitude < 0.0001 then
        p43.SpeedMultiplier = 0;
        p43._speedOverride = 0;

        return;
    end;

    p43.BaseDirection = p44 / Magnitude;
    p43._speedOverride = Magnitude;
end;

function u27.applyResurrect(p45) -- Line: 335
    p45._killedManually = false;
    p45._forceDead = false;
end;

function u27.attachAdvancedSetters(p46, u47) -- Line: 342
    -- upvalues: u27 (copy)
    function p46.AddSpin(p48) -- Line: 343
        -- upvalues: u27 (ref), u47 (copy)
        u27.applyAddSpin(u47, p48);
    end;

    function p46.AddImpulse(p49) -- Line: 344
        -- upvalues: u27 (ref), u47 (copy)
        u27.applyAddImpulse(u47, p49);
    end;

    function p46.FreezeTime(p50) -- Line: 345
        -- upvalues: u27 (ref), u47 (copy)
        u27.applyFreezeTime(u47, p50);
    end;

    function p46.Pause(p51) -- Line: 346
        -- upvalues: u27 (ref), u47 (copy)
        u27.applyPause(u47, p51);
    end;

    function p46.SetSize(p52) -- Line: 347
        -- upvalues: u27 (ref), u47 (copy)
        u27.applySetSize(u47, p52);
    end;

    function p46.SetVelocity(p53) -- Line: 348
        -- upvalues: u27 (ref), u47 (copy)
        u27.applySetVelocity(u47, p53);
    end;

    function p46.Resurrect() -- Line: 349
        -- upvalues: u27 (ref), u47 (copy)
        u27.applyResurrect(u47);
    end;
end;

return u27;