-- Decompiled with Potassium's decompiler.

local u30 = {
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
            else
                local u16 = (Type == "Lightning" or (Type == "Rocks" or Type == "Rope")) and p13._rig;

                if u16 then
                    local u17 = u16.partCount or u16.chunkCap;
                    pcall(function() -- Line: 124
                        -- upvalues: u17 (copy), u16 (copy), u14 (copy)
                        for i = 1, u17 do
                            u16.parts[i].Color = u14;
                        end;
                    end);
                end;
            end;
        end;
    end,

    applyTransparency = function(p18, p19) -- Line: 138, Name: applyTransparency
        if type(p19) ~= "number" then
            return;
        end;

        local v20 = math.min(1, p19);
        local u21 = math.max(0, v20);
        p18.SkipTransparency = true;
        local VisualPart = p18.VisualPart;

        if not (VisualPart and VisualPart.Parent) then
            return;
        end;

        local Type = p18.Type;

        if Type == "Part" or Type == "Model" then
            if VisualPart:IsA("BasePart") then
                pcall(function() -- Line: 146
                    -- upvalues: VisualPart (copy), u21 (ref)
                    VisualPart.Transparency = u21;
                end);
            end;

            local u22 = VisualPart.FindFirstChildOfClass and VisualPart:FindFirstChildOfClass("Decal");

            if u22 then
                pcall(function() -- Line: 148
                    -- upvalues: u22 (copy), u21 (ref)
                    u22.Transparency = u21;
                end);
            end;
        elseif Type == "Beam" or (Type == "TrailEmitter" or Type == "BeamNative") then
            pcall(function() -- Line: 150
                -- upvalues: VisualPart (copy), u21 (ref)
                VisualPart.Transparency = NumberSequence.new(u21);
            end);
        elseif Type == "PointLight" then
            local u23 = p18._baseBrightness or VisualPart.Brightness;
            p18._baseBrightness = u23;
            pcall(function() -- Line: 154
                -- upvalues: VisualPart (copy), u23 (copy), u21 (ref)
                VisualPart.Brightness = u23 * (1 - u21);
            end);
        elseif Type == "Highlight" then
            pcall(function() -- Line: 156
                -- upvalues: VisualPart (copy), u21 (ref)
                VisualPart.FillTransparency = u21;
            end);
            pcall(function() -- Line: 157
                -- upvalues: VisualPart (copy), u21 (ref)
                VisualPart.OutlineTransparency = u21;
            end);
        elseif Type == "ImageLabel" then
            pcall(function() -- Line: 159
                -- upvalues: VisualPart (copy), u21 (ref)
                VisualPart.ImageTransparency = u21;
            end);
        elseif Type == "Lightning" or (Type == "Rocks" or Type == "Rope") then
            p18._curTrans = u21;
            local _rig = p18._rig;

            if _rig then
                local u24 = _rig.partCount or _rig.chunkCap;
                pcall(function() -- Line: 165
                    -- upvalues: u24 (copy), _rig (copy), u21 (ref)
                    for i = 1, u24 do
                        _rig.parts[i].Transparency = u21;
                    end;
                end);
            end;
        end;
    end,

    attachSkipSetters = function(p25, u26) -- Line: 179, Name: attachSkipSetters
        function p25.SetSkipColor(p27) -- Line: 180
            -- upvalues: u26 (copy)
            u26.SkipColor = p27 == true;
        end;

        function p25.SetSkipTransparency(p28) -- Line: 181
            -- upvalues: u26 (copy)
            u26.SkipTransparency = p28 == true;
        end;

        function p25.SetSkipSize(p29) -- Line: 182
            -- upvalues: u26 (copy)
            u26.SkipSize = p29 == true;
        end;
    end
};

local function _clearSettleState(p31) -- Line: 196
    p31._settleEngaged = false;
    p31._restTimer = 0;
    p31._settleRotDamp = 1;
    p31._settleContactPos = nil;
    p31._settleSpawnHalf = nil;
    p31._lastHitNormal = nil;
    p31._collisionStopped = false;
    p31._displacementMirrorX = nil;
    p31._displacementMirrorY = nil;
    p31._displacementMirrorZ = nil;
end;

function u30.applyTeleport(p32, u33) -- Line: 209
    if typeof(u33) ~= "CFrame" then
        return;
    end;

    p32._settleEngaged = false;
    p32._restTimer = 0;
    p32._settleRotDamp = 1;
    p32._settleContactPos = nil;
    p32._settleSpawnHalf = nil;
    p32._lastHitNormal = nil;
    p32._collisionStopped = false;
    p32._displacementMirrorX = nil;
    p32._displacementMirrorY = nil;
    p32._displacementMirrorZ = nil;
    local VisualPart = p32.VisualPart;

    if not (VisualPart and VisualPart.Parent) then
        return;
    end;

    local Type = p32.Type;

    if Type == "Part" then
        pcall(function() -- Line: 216
            -- upvalues: VisualPart (copy), u33 (copy)
            VisualPart.CFrame = u33;
        end);
    elseif Type == "Attachment" then
        local Parent = VisualPart.Parent;

        if Parent and Parent:IsA("BasePart") then
            pcall(function() -- Line: 221
                -- upvalues: VisualPart (copy), Parent (copy), u33 (copy)
                VisualPart.CFrame = Parent.CFrame:ToObjectSpace(u33);
            end);
        else
            pcall(function() -- Line: 223
                -- upvalues: VisualPart (copy), u33 (copy)
                VisualPart.CFrame = u33;
            end);
        end;
    else
        if Type ~= "Model" then
            return;
        end;

        pcall(function() -- Line: 226
            -- upvalues: VisualPart (copy), u33 (copy)
            VisualPart:PivotTo(u33);
        end);
    end;

    if Type == "Attachment" then
        local Parent = VisualPart.Parent;

        if Parent and Parent:IsA("BasePart") then
            p32.LocalCF = Parent.CFrame:ToObjectSpace(u33);
        else
            p32.LocalCF = u33;
        end;
    else
        local Link = p32.Link;

        if Link and Link.Parent then
            local v34;

            if Link:IsA("Attachment") then
                v34 = Link.WorldCFrame;
            elseif Link:IsA("Model") then
                v34 = Link:GetPivot();
            else
                v34 = Link.CFrame;
            end;

            p32.LocalCF = v34:ToObjectSpace(u33);
        else
            p32.LocalCF = u33;
        end;
    end;

    p32._localWorldCF = p32.LocalCF;

    if Type == "Attachment" then
        p32._postUpdateCF = VisualPart.CFrame;
    elseif Type == "Model" then
        p32._postUpdateCF = VisualPart:GetPivot();
    else
        p32._postUpdateCF = u33;
    end;

    p32.CurrentPosition = u33.Position;
    p32.LastHitCheckPos = u33.Position;
    p32._lastOrientPos = nil;
end;

function u30.applyAddSpin(p35, p36) -- Line: 273
    if typeof(p36) ~= "Vector3" then
        return;
    end;

    p35._spinRate = (p35._spinRate or Vector3.new(0, 0, 0)) + p36;
end;

function u30.applyAddImpulse(p37, p38) -- Line: 280
    if typeof(p38) ~= "Vector3" then
        return;
    end;

    p37._settleEngaged = false;
    p37._restTimer = 0;
    p37._settleRotDamp = 1;
    p37._settleContactPos = nil;
    p37._settleSpawnHalf = nil;
    p37._lastHitNormal = nil;
    p37._collisionStopped = false;
    p37._displacementMirrorX = nil;
    p37._displacementMirrorY = nil;
    p37._displacementMirrorZ = nil;
    p37._accelVel = (p37._accelVel or Vector3.new(0, 0, 0)) + p38;
end;

function u30.applyFreezeTime(p39, p40) -- Line: 289
    p39._timeFrozen = p40 == true;
    p39._freezeTimeExplicit = p40 == true;
end;

function u30.applyPause(u41, p42) -- Line: 298
    if type(p42) ~= "number" or p42 <= 0 then
        return;
    end;

    u41._timeFrozen = true;
    local u43 = (u41._pauseGen or 0) + 1;
    u41._pauseGen = u43;
    task.delay(p42, function() -- Line: 303
        -- upvalues: u41 (copy), u43 (copy)
        if u41._pauseGen == u43 and not u41._freezeTimeExplicit then
            u41._timeFrozen = false;
        end;
    end);
end;

function u30.applySetSize(p44, u45) -- Line: 313
    p44.SkipSize = true;
    local VisualPart = p44.VisualPart;

    if not (VisualPart and VisualPart.Parent) then
        return;
    end;

    local Type = p44.Type;

    if Type == "Part" or Type == "Model" then
        if typeof(u45) == "Vector3" and VisualPart:IsA("BasePart") then
            pcall(function() -- Line: 320
                -- upvalues: VisualPart (copy), u45 (copy)
                VisualPart.Size = u45;
            end);

            return;
        end;

        if typeof(u45) == "Vector3" and Type == "Model" then
            pcall(function() -- Line: 323
                -- upvalues: VisualPart (copy), u45 (copy)
                VisualPart:ScaleTo((math.max(0.001, u45.X)));
            end);
        end;
    elseif Type == "ImageLabel" and typeof(u45) == "UDim2" then
        pcall(function() -- Line: 326
            -- upvalues: VisualPart (copy), u45 (copy)
            VisualPart.Size = u45;
        end);
    end;
end;

function u30.applySetVelocity(p46, p47) -- Line: 333
    if p47 == nil then
        p46._speedOverride = nil;

        return;
    end;

    if typeof(p47) ~= "Vector3" then
        return;
    end;

    p46._settleEngaged = false;
    p46._restTimer = 0;
    p46._settleRotDamp = 1;
    p46._settleContactPos = nil;
    p46._settleSpawnHalf = nil;
    p46._lastHitNormal = nil;
    p46._collisionStopped = false;
    p46._displacementMirrorX = nil;
    p46._displacementMirrorY = nil;
    p46._displacementMirrorZ = nil;
    local Magnitude = p47.Magnitude;

    if Magnitude < 0.0001 then
        p46.SpeedMultiplier = 0;
        p46._speedOverride = 0;

        return;
    end;

    p46.BaseDirection = p47 / Magnitude;
    p46._speedOverride = Magnitude;
end;

function u30.applyResurrect(p48) -- Line: 353
    p48._killedManually = false;
    p48._forceDead = false;
end;

function u30.attachAdvancedSetters(p49, u50) -- Line: 360
    -- upvalues: u30 (copy)
    function p49.AddSpin(p51) -- Line: 361
        -- upvalues: u30 (ref), u50 (copy)
        u30.applyAddSpin(u50, p51);
    end;

    function p49.AddImpulse(p52) -- Line: 362
        -- upvalues: u30 (ref), u50 (copy)
        u30.applyAddImpulse(u50, p52);
    end;

    function p49.FreezeTime(p53) -- Line: 363
        -- upvalues: u30 (ref), u50 (copy)
        u30.applyFreezeTime(u50, p53);
    end;

    function p49.Pause(p54) -- Line: 364
        -- upvalues: u30 (ref), u50 (copy)
        u30.applyPause(u50, p54);
    end;

    function p49.SetSize(p55) -- Line: 365
        -- upvalues: u30 (ref), u50 (copy)
        u30.applySetSize(u50, p55);
    end;

    function p49.SetVelocity(p56) -- Line: 366
        -- upvalues: u30 (ref), u50 (copy)
        u30.applySetVelocity(u50, p56);
    end;

    function p49.Resurrect() -- Line: 367
        -- upvalues: u30 (ref), u50 (copy)
        u30.applyResurrect(u50);
    end;
end;

return u30;