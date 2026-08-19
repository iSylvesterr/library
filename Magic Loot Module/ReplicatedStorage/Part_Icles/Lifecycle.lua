-- Decompiled with Potassium's decompiler.

local Selection = game:GetService("Selection");
local RunService = game:GetService("RunService");
local u1 = RunService:IsStudio();
local success = pcall(function() -- Line: 11
    -- upvalues: Selection (copy)
    return Selection:Get();
end);
local u2 = RunService:IsClient() and RunService.PreRender or RunService.Heartbeat;
local TypeRegistry = require(script.Parent.TypeRegistry);
local Particles = require(script.Parent.Particles);
local Events = require(script.Parent.Events);
local Pool = require(script.Parent.Pool);
local EvenCycle = require(script.Parent.EvenCycle);

return function(u3) -- Line: 22
    -- upvalues: TypeRegistry (copy), EvenCycle (copy), Particles (copy), success (copy), Events (copy), u2 (copy), u1 (copy), Selection (copy), Pool (copy)
    local function cancelAnimation(p4, p5) -- Line: 25
        local u6 = p4.ActiveAnimates[p5];

        if not u6 then
            return;
        end;

        if (u6.Type == "Beam" or (u6.Type == "Highlight" or u6.Type == "TrailEmitter")) and (u6.VisualPart and u6.VisualPart.Parent) then
            local u7 = u6.BeamSnapshot or (u6.HighlightSnapshot or u6.TrailEmitterSnapshot);

            if u7 then
                pcall(function() -- Line: 35
                    -- upvalues: u7 (copy), u6 (copy)
                    for i, v in pairs(u7) do
                        u6.VisualPart[i] = v;
                    end;
                end);
            end;

            u6.VisualPart.Enabled = false;
        end;

        if u6.InitialAnchorCF and (u6.VisualPart and u6.VisualPart.Parent) then
            if u6.Type == "Model" then
                u6.VisualPart:PivotTo(u6.InitialAnchorCF);

                if u6.InitialScale then
                    pcall(function() -- Line: 45
                        -- upvalues: u6 (copy)
                        u6.VisualPart:ScaleTo(u6.InitialScale);
                    end);
                end;
            elseif u6.Type ~= "Beam" then
                u6.VisualPart.CFrame = u6.InitialAnchorCF;
            end;
        end;

        if (u6.Type == "Part" or u6.Type == "Attachment") and (u6.VisualPart and u6.VisualPart.Parent) then
            pcall(function() -- Line: 53
                -- upvalues: u6 (copy)
                u6.VisualPart.Transparency = 1;
                local v8 = u6.HasDecal and u6.VisualPart:FindFirstChildOfClass("Decal");

                if v8 then
                    v8.Transparency = 1;
                end;
            end);
        end;

        if (u6.Type == "Screen" or (u6.Type == "ImageLabel" or (u6.Type == "Lightning" or (u6.Type == "Rocks" or u6.Type == "Rope")))) and u6.VisualPart then
            pcall(function() -- Line: 63
                -- upvalues: u6 (copy)
                u6.VisualPart:Destroy();
            end);
        end;

        if u6._scaleMapKeys and p4._parentScaleMap then
            for _, v in ipairs(u6._scaleMapKeys) do
                p4._parentScaleMap[v] = nil;
            end;
        end;

        for i = #p4.ActiveEmits, 1, -1 do
            if p4.ActiveEmits[i] == u6 then
                local v9 = #p4.ActiveEmits;

                if i < v9 then
                    p4.ActiveEmits[i] = p4.ActiveEmits[v9];
                end;

                p4.ActiveEmits[v9] = nil;
                break;
            end;
        end;

        p4.ActiveAnimates[p5] = nil;
    end;

    function u3._cancelAnimation(p10, p11) -- Line: 83
        -- upvalues: cancelAnimation (copy)
        cancelAnimation(p10, p11);
    end;

    local function haltEmission(p12, u13, p14) -- Line: 90
        -- upvalues: u3 (copy), cancelAnimation (copy), TypeRegistry (ref), EvenCycle (ref), Particles (ref)
        if u3.ActiveLoops[u13] then
            task.cancel(u3.ActiveLoops[u13]);
            u3.ActiveLoops[u13] = nil;
        end;

        local v15 = u3.ActiveChainLoops[u13];

        if v15 then
            for _, v in ipairs(v15) do
                pcall(task.cancel, v);
            end;

            u3.ActiveChainLoops[u13] = nil;
        end;

        u13:SetAttribute("AnimateLoop", false);
        local u16 = (u13:GetAttribute("_emitGen") or 0) + 1;
        pcall(function() -- Line: 102
            -- upvalues: u13 (copy), u16 (copy)
            u13:SetAttribute("_emitGen", u16);
        end);

        if p14 then
            cancelAnimation(p12, u13);
        end;

        local v17 = TypeRegistry.getConfig(u13);

        if v17 then
            v17:SetAttribute("Enabled", false);
        end;

        pcall(function() -- Line: 106
            -- upvalues: u13 (copy)
            u13:SetAttribute("_PartIclePlaying", nil);
        end);
        EvenCycle.clear(p12._evenCycleStore, u13:GetAttribute("_EvenCycleId") or u13);

        for _, descendant in ipairs(u13:GetDescendants()) do
            if descendant:GetAttribute("Transformed") then
                if p14 then
                    p12:Disable(descendant);
                else
                    p12:SoftDisable(descendant);
                end;
            elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
                if p14 then
                    Particles.CancelNative(descendant);
                else
                    pcall(function() -- Line: 114
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false;
                    end);
                end;
            elseif descendant:IsA("Beam") or descendant:IsA("Highlight") then
                pcall(function() -- Line: 116
                    -- upvalues: descendant (copy)
                    descendant.Enabled = false;
                end);
            end;
        end;
    end;

    function u3.Disable(p18, p19) -- Line: 124
        -- upvalues: success (ref), haltEmission (copy)
        if not p19 then
            return;
        end;

        local v20 = success and (game:GetService("RunService"):IsEdit() and game:GetService("ChangeHistoryService")) or nil;

        if v20 then
            v20:SetWaypoint("Part-Icles: Before Disable");
        end;

        haltEmission(p18, p19, true);
        local ActiveEmits = p18.ActiveEmits;

        for i = #ActiveEmits, 1, -1 do
            local v21 = ActiveEmits[i];

            if v21 and v21._sourceItem == p19 then
                if v21.VisualPart and v21.VisualPart.Parent then
                    p18:_releaseOrDestroy(v21, v21.VisualPart);
                end;

                if v21._scaleMapKeys and p18._parentScaleMap then
                    for _, v in ipairs(v21._scaleMapKeys) do
                        p18._parentScaleMap[v] = nil;
                    end;
                end;

                local v22 = #ActiveEmits;

                if i < v22 then
                    ActiveEmits[i] = ActiveEmits[v22];
                end;

                ActiveEmits[v22] = nil;
            end;
        end;

        if p18._lingerByItem and p18._lingerByItem[p19] then
            for _, v in ipairs(p18._lingerByItem[p19]) do
                if v then
                    local u23 = false;
                    pcall(function() -- Line: 153
                        -- upvalues: u23 (ref), v (copy)
                        u23 = v:GetAttribute("_lingerCounted") == true;
                    end);

                    if u23 then
                        p18._lingerVisualCount = math.max(0, (p18._lingerVisualCount or 0) - 1);
                        pcall(function() -- Line: 156
                            -- upvalues: v (copy)
                            v:SetAttribute("_lingerCounted", nil);
                        end);
                    end;

                    if v.Parent then
                        pcall(function() -- Line: 159
                            -- upvalues: v (copy)
                            v:Destroy();
                        end);
                    end;
                end;
            end;

            p18._lingerByItem[p19] = nil;
        end;

        if v20 then
            v20:SetWaypoint("Part-Icles: Disable");
        end;
    end;

    local function _hasTransformedAncestor(p24, p25) -- Line: 169
        local Parent = p24.Parent;

        while Parent and Parent ~= p25 do
            if Parent:GetAttribute("Transformed") then
                return true;
            end;

            Parent = Parent.Parent;
        end;

        return false;
    end;

    function u3.AbsoluteEnable(p26, u27, p28) -- Line: 184
        -- upvalues: TypeRegistry (ref), _hasTransformedAncestor (copy)
        if not u27 then
            return;
        end;

        if u27:GetAttribute("Transformed") then
            pcall(function() -- Line: 193
                -- upvalues: u27 (copy)
                u27:SetAttribute("_PartIclePlaying", true);
            end);
            local v29 = TypeRegistry.getConfig(u27);

            if v29 then
                v29:SetAttribute("Enabled", true);
            end;

            p26:Enable(u27, nil, (1 / 0));

            return;
        end;

        if u27:IsA("ParticleEmitter") or (u27:IsA("Trail") or u27:IsA("Beam")) then
            if p28 then
                return;
            end;

            pcall(function() -- Line: 202
                -- upvalues: u27 (copy)
                u27.Enabled = true;
            end);

            return;
        end;

        local v30;

        if u27:IsA("BasePart") or u27:IsA("Attachment") then
            v30 = not p28;
        else
            v30 = u27:IsA("Model") and not p28;
        end;

        if v30 then
            for _, descendant in ipairs(u27:GetDescendants()) do
                if (descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or descendant:IsA("Beam"))) and not (descendant:GetAttribute("Transformed") or _hasTransformedAncestor(descendant, u27)) then
                    pcall(function() -- Line: 211
                        -- upvalues: descendant (copy)
                        descendant.Enabled = true;
                    end);
                end;
            end;
        end;

        local v31 = v30 or p28;

        for _, child in u27:GetChildren() do
            if not u27:IsA("BasePart") or (not child:IsA("BasePart") or child:GetAttribute("Transformed")) then
                p26:AbsoluteEnable(child, v31);
            end;
        end;
    end;

    function u3.SoftDisable(p32, p33) -- Line: 227
        -- upvalues: success (ref), haltEmission (copy)
        if not p33 then
            return;
        end;

        local v34 = success and (game:GetService("RunService"):IsEdit() and game:GetService("ChangeHistoryService")) or nil;

        if v34 then
            v34:SetWaypoint("Part-Icles: Before Soft Disable");
        end;

        haltEmission(p32, p33, false);

        if v34 then
            v34:SetWaypoint("Part-Icles: Soft Disable");
        end;
    end;

    function u3.AbsoluteDisable(p35, u36, p37) -- Line: 240
        -- upvalues: _hasTransformedAncestor (copy)
        if not u36 then
            return;
        end;

        if u36:GetAttribute("Transformed") then
            p35:SoftDisable(u36);

            return;
        end;

        if u36:IsA("ParticleEmitter") or (u36:IsA("Trail") or u36:IsA("Beam")) then
            if p37 then
                return;
            end;

            pcall(function() -- Line: 248
                -- upvalues: u36 (copy)
                u36.Enabled = false;
            end);

            return;
        end;

        local v38;

        if u36:IsA("BasePart") or u36:IsA("Attachment") then
            v38 = not p37;
        else
            v38 = u36:IsA("Model") and not p37;
        end;

        if v38 then
            for _, descendant in ipairs(u36:GetDescendants()) do
                if (descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or descendant:IsA("Beam"))) and not (descendant:GetAttribute("Transformed") or _hasTransformedAncestor(descendant, u36)) then
                    pcall(function() -- Line: 257
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false;
                    end);
                end;
            end;
        end;

        local v39 = v38 or p37;

        for _, child in u36:GetChildren() do
            if not u36:IsA("BasePart") or (not child:IsA("BasePart") or child:GetAttribute("Transformed")) then
                p35:AbsoluteDisable(child, v39);
            end;
        end;
    end;

    function u3.EmitAnimate(p40, p41, p42, p43) -- Line: 271
        -- upvalues: u3 (copy), cancelAnimation (copy)
        p40:_warnIfNotActivated("EmitAnimate");

        if (p41:IsA("BlurEffect") or (p41:IsA("BloomEffect") or p41:IsA("ColorCorrectionEffect") or (p41:IsA("Atmosphere") or p41:IsA("ImageLabel")) or (u3._isLightning(p41) or u3._isCameraShake(p41) or (u3._isRocks(p41) or u3._isRope(p41))))) and p40.ActiveAnimates[p41] then
            return;
        end;

        cancelAnimation(p40, p41);

        if p41:IsA("Beam") then
            p40:EmitBeamAnimate(p41, p42, p43);

            return;
        end;

        if p41:IsA("Trail") and p41:FindFirstChild("PartIcleProperties") then
            p40:EmitTrailAnimate(p41, p42, p43);

            return;
        end;

        if p41:IsA("Highlight") then
            p40:EmitHighlightAnimate(p41, p42, p43);

            return;
        end;

        if p41:IsA("Attachment") then
            p40:EmitAttachmentAnimate(p41, p42, p43);

            return;
        end;

        if p41:IsA("Model") then
            p40:EmitModelAnimate(p41, p42, p43);

            return;
        end;

        if p41:IsA("BlurEffect") then
            p40:EmitBlurAnimate(p41, p42, p43);

            return;
        end;

        if p41:IsA("BloomEffect") then
            p40:EmitBloomAnimate(p41, p42, p43);

            return;
        end;

        if p41:IsA("ColorCorrectionEffect") then
            p40:EmitColorCorrectionAnimate(p41, p42, p43);

            return;
        end;

        if p41:IsA("Atmosphere") then
            p40:EmitAtmosphereAnimate(p41, p42, p43);

            return;
        end;

        if p41:IsA("ImageLabel") then
            p40:EmitImageLabelAnimate(p41, p42, p43);

            return;
        end;

        if u3._isLightning(p41) then
            p40:EmitLightningAnimate(p41, p42, p43);

            return;
        end;

        if u3._isCameraShake(p41) then
            p40:EmitCameraShakeAnimate(p41, p42, p43);

            return;
        end;

        if u3._isRocks(p41) then
            p40:EmitRocksAnimate(p41, p42, p43);

            return;
        end;

        if u3._isRope(p41) then
            p40:EmitRopeAnimate(p41, p42, p43);

            return;
        end;

        if p41:IsA("BasePart") then
            p40:EmitPartAnimate(p41, p42, p43);
        end;
    end;

    function u3.EnableEmit(u44, u45, u46, u47) -- Line: 302
        -- upvalues: Particles (ref), EvenCycle (ref), TypeRegistry (ref), Events (ref)
        u44:_warnIfNotActivated("EnableEmit");
        local v48 = u45:GetAttribute("EmissionMode") or "Emit";
        local v49 = u45:GetAttribute("EmitCount");
        local v50 = v49 == nil and 1 or v49;
        local u51 = v50 <= 0 and (u47 and u47.EventDriven) and 1 or v50;
        local v52 = u45:GetAttribute("EmitDelay") or 0;
        local u53 = Particles.parseDuration(u45:GetAttribute("EmitDuration")) or 0;

        if v48 ~= "Animate" and (u51 <= 0 and u53 <= 0) then
            return;
        end;

        local u54;

        if u47 then
            u54 = u47.ChainCtx ~= nil;
        else
            u54 = u47;
        end;

        local u55;

        if u47 then
            u55 = u47._parentAlive ~= nil;
        else
            u55 = u47;
        end;

        local u56 = u54 or (u55 or u53 <= 0);

        if not (u54 or u55) then
            EvenCycle.ensureIds(u45);
        end;

        local u57;

        if u56 then
            u57 = nil;
        else
            u57 = (u45:GetAttribute("_emitGen") or 0) + 1;
            pcall(function() -- Line: 330
                -- upvalues: u45 (copy), u57 (ref)
                u45:SetAttribute("_emitGen", u57);
            end);
        end;

        local u58 = u44._engineGen or 0;

        local function genStillCurrent() -- Line: 334
            -- upvalues: u44 (copy), u58 (copy), u45 (copy), u56 (copy), u57 (ref), u47 (copy)
            if u44.Connection == nil then
                return false;
            end;

            if (u44._engineGen or 0) ~= u58 then
                return false;
            end;

            if not u45.Parent then
                return false;
            end;

            if u56 or (u45:GetAttribute("_emitGen") or 0) == u57 then
                return (not u47 or (not u47._parentAlive or u47._parentAlive[1])) and true or false;
            end;

            return false;
        end;

        if v48 == "Animate" then
            local function doAnimate() -- Line: 347
                -- upvalues: u44 (copy), u58 (copy), u45 (copy), u56 (copy), u57 (ref), u47 (copy), u53 (copy), u46 (copy)
                local v59;

                if u44.Connection == nil or ((u44._engineGen or 0) ~= u58 or (not u45.Parent or not u56 and (u45:GetAttribute("_emitGen") or 0) ~= u57)) then
                    v59 = false;
                else
                    v59 = (not u47 or (not u47._parentAlive or u47._parentAlive[1])) and true or false;
                end;

                if not v59 then
                    return;
                end;

                if u53 > 0 then
                    u45:SetAttribute("AnimateLoop", true);
                    task.delay(u53, function() -- Line: 351
                        -- upvalues: u44 (ref), u58 (ref), u45 (ref), u56 (ref), u57 (ref), u47 (ref)
                        local v60;

                        if u44.Connection == nil or ((u44._engineGen or 0) ~= u58 or (not u45.Parent or not u56 and (u45:GetAttribute("_emitGen") or 0) ~= u57)) then
                            v60 = false;
                        else
                            v60 = (not u47 or (not u47._parentAlive or u47._parentAlive[1])) and true or false;
                        end;

                        if not v60 then
                            return;
                        end;

                        if u45:GetAttribute("AnimateLoop") then
                            u45:SetAttribute("AnimateLoop", false);
                        end;
                    end);
                end;

                u44:EmitAnimate(u45, u46, u47);
            end;

            if v52 > 0 then
                task.delay(v52, doAnimate);
            else
                doAnimate();
            end;

            return;
        end;

        local u61 = TypeRegistry.getConfig(u45);

        local function doEmit() -- Line: 364
            -- upvalues: u44 (copy), u58 (copy), u45 (copy), u56 (copy), u57 (ref), u47 (copy), EvenCycle (ref), u61 (copy), u51 (ref), u46 (copy), Events (ref), u53 (copy), u54 (copy), u55 (copy)
            local v62;

            if u44.Connection == nil or ((u44._engineGen or 0) ~= u58 or (not u45.Parent or not u56 and (u45:GetAttribute("_emitGen") or 0) ~= u57)) then
                v62 = false;
            else
                v62 = (not u47 or (not u47._parentAlive or u47._parentAlive[1])) and true or false;
            end;

            if not v62 then
                return;
            end;

            local v63, v64 = EvenCycle.evenFlags(u61);
            local v65, v66, v67, v68;

            if v63 or v64 then
                local v69 = u45:GetAttribute("_EvenCycleId") or u45;
                local v70 = u61 and u61:GetAttribute("Rate") or 10;
                v65, v66, v67, v68 = EvenCycle.advance(u44._evenCycleStore, v69, u61, v70, v63, v64);
            else
                v66 = 0;
                v67 = 1;
                v68 = 0;
                v65 = 1;
            end;

            for i = 1, u51 do
                u44:Emit(u45, u46, Events.withEvenOffset(u47, i, u51, v65, v66, v67, v68));
            end;

            if u53 > 0 then
                if u54 or u55 then
                    u44:Enable(u45, u46, u53, u47);

                    return;
                end;

                u45:SetAttribute("_PartIclePlaying", true);

                if u61 then
                    u61:SetAttribute("Enabled", true);
                end;

                u44:Enable(u45, u46, u53, u47);
                task.delay(u53, function() -- Line: 393
                    -- upvalues: u44 (ref), u58 (ref), u45 (ref), u56 (ref), u57 (ref), u47 (ref), u61 (ref)
                    local v71;

                    if u44.Connection == nil or ((u44._engineGen or 0) ~= u58 or (not u45.Parent or not u56 and (u45:GetAttribute("_emitGen") or 0) ~= u57)) then
                        v71 = false;
                    else
                        v71 = (not u47 or (not u47._parentAlive or u47._parentAlive[1])) and true or false;
                    end;

                    if not v71 then
                        return;
                    end;

                    if u61 and u61.Parent then
                        u61:SetAttribute("Enabled", false);
                    end;

                    u45:SetAttribute("_PartIclePlaying", nil);
                end);
            end;
        end;

        if v52 > 0 then
            task.delay(v52, doEmit);
        else
            doEmit();
        end;
    end;

    function u3.Enable(u72, u73, u74, p75, u76) -- Line: 407
        -- upvalues: TypeRegistry (ref), u3 (copy), u2 (ref), u1 (ref), success (ref), Selection (ref), EvenCycle (ref), Events (ref)
        u72:_warnIfNotActivated("Enable");
        local u77 = u72:GetData(u73);

        if not u77 then
            return;
        end;

        if (u73:GetAttribute("EmissionMode") or "Emit") == "Animate" then
            u73:SetAttribute("AnimateLoop", true);
            u72:EmitAnimate(u73, u74, u76);

            return;
        end;

        local u78 = p75 or (1 / 0);
        local u79 = TypeRegistry.getConfig(u73);
        local v80;

        if u76 then
            v80 = u76.ChainCtx ~= nil;
        else
            v80 = u76;
        end;

        local u81;

        if u76 then
            u81 = u76._parentAlive ~= nil;
        else
            u81 = u76;
        end;

        local u82;

        if u76 then
            u82 = u76._playToken;
        else
            u82 = u76;
        end;

        local u83 = u82 ~= nil;
        local u84 = v80 or (u81 or u83);
        local u85 = u72._engineGen or 0;

        local function loopBody() -- Line: 431
            -- upvalues: u73 (copy), u84 (copy), u72 (copy), u85 (copy), u81 (copy), u76 (copy), u83 (copy), u82 (copy), u3 (ref), u78 (copy), u77 (copy), u2 (ref), u1 (ref), success (ref), Selection (ref), u79 (copy), EvenCycle (ref), u74 (copy), Events (ref)
            local v86 = os.clock();
            local v87 = 0;
            local v88 = u73:GetAttribute("_EvenCycleId") or u73;

            while (not u84 or (u72._engineGen or 0) == u85) and ((not u81 or (not u76._parentAlive or u76._parentAlive[1])) and (not u83 or u82.Alive)) do
                if not (u73 and u73.Parent) then
                    if not u84 then
                        u3.ActiveLoops[u73] = nil;

                        return;
                    end;

                    break;
                end;

                if u78 <= os.clock() - v86 then
                    if not u84 then
                        u3.ActiveLoops[u73] = nil;

                        return;
                    end;

                    break;
                end;

                if not (u84 or u77.CheckEnabled()) then
                    u3.ActiveLoops[u73] = nil;

                    return;
                end;

                local v89 = u2:Wait();

                if u1 and (success and (not u3._focused and (#Selection:Get() == 0 or u3._unfocusedAt > 0 and os.clock() - u3._unfocusedAt > 600))) then
                    v87 = 0;
                else
                    local v90 = u79 and u79:GetAttribute("Rate") or 10;

                    if v90 <= 0 then
                        v87 = 0;
                    else
                        local v91 = 1 / v90;
                        v87 = v87 + v89;
                        local v92 = (u77.PosXEven or (u77.PosYEven or u77.PosZEven)) == true;
                        local v93;

                        if (u77.RotXEven or (u77.RotYEven or u77.RotZEven)) == true then
                            v93 = true;
                        else
                            v93 = false;
                        end;

                        while v91 <= v87 do
                            v87 = v87 - v91;

                            if v92 or v93 then
                                local v94, v95, v96, v97 = EvenCycle.advance(u72._evenCycleStore, v88, u79, v90, v92, v93);
                                u72:Emit(u73, u74, Events.withEvenOffset(u76, 1, 1, v94, v95, v96, v97));
                            else
                                u72:Emit(u73, u74, u76);
                            end;
                        end;
                    end;
                end;
            end;
        end;

        if u84 then
            local v100 = task.spawn(function() -- Line: 483
                -- upvalues: loopBody (copy), u3 (ref), u73 (copy)
                loopBody();
                local v98 = coroutine.running();
                local v99 = u3.ActiveChainLoops[u73];

                if not v99 then
                    return;
                end;

                for i = #v99, 1, -1 do
                    if v99[i] == v98 then
                        table.remove(v99, i);
                        break;
                    end;
                end;

                if #v99 == 0 then
                    u3.ActiveChainLoops[u73] = nil;
                end;
            end);
            local v101 = u3.ActiveChainLoops[u73];

            if not v101 then
                v101 = {};
                u3.ActiveChainLoops[u73] = v101;
            end;

            table.insert(v101, v100);

            if u83 then
                table.insert(u82.Loops, v100);
            end;
        else
            if u3.ActiveLoops[u73] then
                task.cancel(u3.ActiveLoops[u73]);
            end;

            u3.ActiveLoops[u73] = task.spawn(loopBody);
        end;
    end;

    local u102 = {};
    local u103 = false;

    function u3.EnableEmitAt(p104, p105, p106, p107) -- Line: 507
        -- upvalues: u102 (copy), u103 (ref)
        if not (p105 and (p105.Parent and p106)) then
            return;
        end;

        if not (p105:IsA("BasePart") or (p105:IsA("Attachment") or p105:IsA("Model"))) then
            local ClassName = p105.ClassName;

            if not u102[ClassName] then
                u102[ClassName] = true;
                warn(("[Part-Icles] EnableEmitAt does not support %s targets (origin override is BasePart/Attachment/Model only). Emit skipped."):format(ClassName));
            end;

            return;
        end;

        if (p105:GetAttribute("EmissionMode") or "Emit") == "Animate" then
            if not u103 then
                u103 = true;
                warn("[Part-Icles] EnableEmitAt does not support Animate-mode targets in v1; use EmitMode=AtTarget for Animate sources. Emit skipped.");
            end;

            return;
        end;

        local v108 = p107 or {};

        if v108.Link ~= nil then
            p104:SetLink(p105, v108.Link, v108.LinkMode or "Weld");
        end;

        if v108.EmitParent ~= nil then
            p104:SetEmitParent(p105, v108.EmitParent);
        end;

        p104:EnableEmit(p105, nil, {
            ChainCtx = v108.ChainCtx,
            EventOriginCF = p106,
            EventOriginResolver = v108.OriginResolver,
            UseFullOrigin = v108.UseFullOrigin ~= false,
            IgnoreLink = v108.IgnoreLink == true,
            EventDriven = v108.EventDriven == true
        });
    end;

    function u3._fireOnDeath(p109, p110) -- Line: 551
        -- upvalues: Events (ref)
        if p110.Events and (p110.Events.OnDeath and (not p110._killedManually or p110._fireOnDeathOverride)) then
            Events.fire(p109, p110, "OnDeath", p110.EventChainCtx, nil);
        end;
    end;

    function u3._fireOnDestruction(p111, p112, p113) -- Line: 559
        -- upvalues: Events (ref)
        if p112.Events and (p112.Events.OnDestruction and (p113 and p113.Parent)) then
            Events.fire(p111, p112, "OnDestruction", p112.EventChainCtx, nil);
        end;
    end;

    function u3._releaseOrDestroy(p114, p115, u116) -- Line: 566
        -- upvalues: TypeRegistry (ref), Pool (ref)
        if p115._extraLights then
            for _, v in ipairs(p115._extraLights) do
                pcall(function() -- Line: 571
                    -- upvalues: v (copy)
                    v:Destroy();
                end);
            end;

            p115._extraLights = nil;
        end;

        if not u116 then
            return;
        end;

        if not u116.Parent then
            return;
        end;

        if p115.IsAnimate or not (p115._sourceRT and p115._poolKind) then
            pcall(function() -- Line: 578
                -- upvalues: u116 (copy)
                u116:Destroy();
            end);

            return;
        end;

        local v117 = nil;
        local _sourceItem = p115._sourceItem;

        if _sourceItem and _sourceItem.Parent then
            local v118 = TypeRegistry.getConfig(_sourceItem);

            if v118 then
                v117 = v118:GetAttribute("Rate");
            end;
        end;

        Pool.release(u116, p115._sourceRT, p115._poolKind, v117);
    end;

    function u3._makeAliveCheck(u119) -- Line: 592
        local u120 = u119._engineGen or 0;

        return function() -- Line: 594
            -- upvalues: u119 (copy), u120 (copy)
            local v121;

            if u119.Connection == nil then
                v121 = false;
            else
                v121 = (u119._engineGen or 0) == u120;
            end;

            return v121;
        end;
    end;

    function u3._fireAnimateCycleRestartEvents(p122, p123) -- Line: 600
        -- upvalues: Events (ref)
        if p123.Events and p123.Events.OnHit then
            p123.LastHitCheckPos = Events.getWorldPosition(p123);
            p123.LastHitCheckTime = nil;
        end;

        if p123.Events and p123.Events.OnEmit then
            local v124 = Events.makePayload(p122, p123, "OnEmit", {
                EmitIndex = nil,
                ChainCtx = p123.EventChainCtx
            });
            Events.fire(p122, p123, "OnEmit", p123.EventChainCtx, v124);
        end;
    end;

    function u3._killParticle(p125, p126, p127) -- Line: 613
        -- upvalues: TypeRegistry (ref)
        p126._killedManually = true;
        p126._fireOnDeathOverride = (p127 or {}).fireOnDeath == true;
        p126._forceDead = true;
        p126.PartLife = 0;
        local u128 = p126.IsAnimate and p126._sourceItem;

        if u128 then
            pcall(function() -- Line: 622
                -- upvalues: u128 (copy), TypeRegistry (ref)
                u128:SetAttribute("AnimateLoop", false);
                local v129 = TypeRegistry.getConfig(u128);

                if v129 then
                    v129:SetAttribute("Enabled", false);
                end;
            end);
        end;
    end;
end;