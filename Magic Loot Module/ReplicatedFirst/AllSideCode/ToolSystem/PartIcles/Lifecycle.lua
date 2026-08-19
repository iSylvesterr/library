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

        if (u6.Type == "Screen" or u6.Type == "ImageLabel") and u6.VisualPart then
            pcall(function() -- Line: 62
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

    function u3._cancelAnimation(p10, p11) -- Line: 82
        -- upvalues: cancelAnimation (copy)
        cancelAnimation(p10, p11);
    end;

    local function haltEmission(p12, u13, p14) -- Line: 89
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
        pcall(function() -- Line: 101
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

        pcall(function() -- Line: 105
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
                    pcall(function() -- Line: 113
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false;
                    end);
                end;
            elseif descendant:IsA("Beam") or descendant:IsA("Highlight") then
                pcall(function() -- Line: 115
                    -- upvalues: descendant (copy)
                    descendant.Enabled = false;
                end);
            end;
        end;
    end;

    function u3.Disable(p18, p19) -- Line: 123
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
                    pcall(function() -- Line: 152
                        -- upvalues: u23 (ref), v (copy)
                        u23 = v:GetAttribute("_lingerCounted") == true;
                    end);

                    if u23 then
                        p18._lingerVisualCount = math.max(0, (p18._lingerVisualCount or 0) - 1);
                        pcall(function() -- Line: 155
                            -- upvalues: v (copy)
                            v:SetAttribute("_lingerCounted", nil);
                        end);
                    end;

                    if v.Parent then
                        pcall(function() -- Line: 158
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

    local function _hasTransformedAncestor(p24, p25) -- Line: 168
        local Parent = p24.Parent;

        while Parent and Parent ~= p25 do
            if Parent:GetAttribute("Transformed") then
                return true;
            end;

            Parent = Parent.Parent;
        end;

        return false;
    end;

    function u3.AbsoluteEnable(p26, u27, p28) -- Line: 183
        -- upvalues: TypeRegistry (ref), _hasTransformedAncestor (copy)
        if not u27 then
            return;
        end;

        if u27:GetAttribute("Transformed") then
            pcall(function() -- Line: 192
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

            pcall(function() -- Line: 201
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
                    pcall(function() -- Line: 210
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

    function u3.SoftDisable(p32, p33) -- Line: 226
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

    function u3.AbsoluteDisable(p35, u36, p37) -- Line: 239
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

            pcall(function() -- Line: 247
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
                    pcall(function() -- Line: 256
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

    function u3.EmitAnimate(p40, p41, p42, p43) -- Line: 270
        -- upvalues: cancelAnimation (copy)
        p40:_warnIfNotActivated("EmitAnimate");

        if (p41:IsA("BlurEffect") or (p41:IsA("BloomEffect") or p41:IsA("ColorCorrectionEffect") or (p41:IsA("Atmosphere") or p41:IsA("ImageLabel")))) and p40.ActiveAnimates[p41] then
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

        if p41:IsA("BasePart") then
            p40:EmitPartAnimate(p41, p42, p43);
        end;
    end;

    function u3.EnableEmit(u44, u45, u46, u47) -- Line: 293
        -- upvalues: Particles (ref), EvenCycle (ref), TypeRegistry (ref), Events (ref)
        u44:_warnIfNotActivated("EnableEmit");
        local v48 = u45:GetAttribute("EmissionMode") or "Emit";
        local v49 = u45:GetAttribute("EmitCount");
        local u50 = v49 == nil and 1 or v49;
        local v51 = u45:GetAttribute("EmitDelay") or 0;
        local u52 = Particles.parseDuration(u45:GetAttribute("EmitDuration")) or 0;

        if v48 ~= "Animate" and (u50 <= 0 and u52 <= 0) then
            return;
        end;

        local u53;

        if u47 then
            u53 = u47.ChainCtx ~= nil;
        else
            u53 = u47;
        end;

        local u54;

        if u47 then
            u54 = u47._parentAlive ~= nil;
        else
            u54 = u47;
        end;

        local u55 = u53 or (u54 or u52 <= 0);

        if not (u53 or u54) then
            EvenCycle.ensureIds(u45);
        end;

        local u56;

        if u55 then
            u56 = nil;
        else
            u56 = (u45:GetAttribute("_emitGen") or 0) + 1;
            pcall(function() -- Line: 317
                -- upvalues: u45 (copy), u56 (ref)
                u45:SetAttribute("_emitGen", u56);
            end);
        end;

        local u57 = u44._engineGen or 0;

        local function genStillCurrent() -- Line: 321
            -- upvalues: u44 (copy), u57 (copy), u45 (copy), u55 (copy), u56 (ref), u47 (copy)
            if u44.Connection == nil then
                return false;
            end;

            if (u44._engineGen or 0) ~= u57 then
                return false;
            end;

            if not u45.Parent then
                return false;
            end;

            if u55 or (u45:GetAttribute("_emitGen") or 0) == u56 then
                return (not u47 or (not u47._parentAlive or u47._parentAlive[1])) and true or false;
            end;

            return false;
        end;

        if v48 == "Animate" then
            local function doAnimate() -- Line: 334
                -- upvalues: u44 (copy), u57 (copy), u45 (copy), u55 (copy), u56 (ref), u47 (copy), u52 (copy), u46 (copy)
                local v58;

                if u44.Connection == nil or ((u44._engineGen or 0) ~= u57 or (not u45.Parent or not u55 and (u45:GetAttribute("_emitGen") or 0) ~= u56)) then
                    v58 = false;
                else
                    v58 = (not u47 or (not u47._parentAlive or u47._parentAlive[1])) and true or false;
                end;

                if not v58 then
                    return;
                end;

                if u52 > 0 then
                    u45:SetAttribute("AnimateLoop", true);
                    task.delay(u52, function() -- Line: 338
                        -- upvalues: u44 (ref), u57 (ref), u45 (ref), u55 (ref), u56 (ref), u47 (ref)
                        local v59;

                        if u44.Connection == nil or ((u44._engineGen or 0) ~= u57 or (not u45.Parent or not u55 and (u45:GetAttribute("_emitGen") or 0) ~= u56)) then
                            v59 = false;
                        else
                            v59 = (not u47 or (not u47._parentAlive or u47._parentAlive[1])) and true or false;
                        end;

                        if not v59 then
                            return;
                        end;

                        if u45:GetAttribute("AnimateLoop") then
                            u45:SetAttribute("AnimateLoop", false);
                        end;
                    end);
                end;

                u44:EmitAnimate(u45, u46, u47);
            end;

            if v51 > 0 then
                task.delay(v51, doAnimate);
            else
                doAnimate();
            end;

            return;
        end;

        local u60 = TypeRegistry.getConfig(u45);

        local function doEmit() -- Line: 351
            -- upvalues: u44 (copy), u57 (copy), u45 (copy), u55 (copy), u56 (ref), u47 (copy), EvenCycle (ref), u60 (copy), u50 (copy), u46 (copy), Events (ref), u52 (copy), u53 (copy), u54 (copy)
            local v61;

            if u44.Connection == nil or ((u44._engineGen or 0) ~= u57 or (not u45.Parent or not u55 and (u45:GetAttribute("_emitGen") or 0) ~= u56)) then
                v61 = false;
            else
                v61 = (not u47 or (not u47._parentAlive or u47._parentAlive[1])) and true or false;
            end;

            if not v61 then
                return;
            end;

            local v62, v63 = EvenCycle.evenFlags(u60);
            local v64, v65, v66, v67;

            if v62 or v63 then
                local v68 = u45:GetAttribute("_EvenCycleId") or u45;
                local v69 = u60 and u60:GetAttribute("Rate") or 10;
                v64, v65, v66, v67 = EvenCycle.advance(u44._evenCycleStore, v68, u60, v69, v62, v63);
            else
                v65 = 0;
                v66 = 1;
                v67 = 0;
                v64 = 1;
            end;

            for i = 1, u50 do
                u44:Emit(u45, u46, Events.withEvenOffset(u47, i, u50, v64, v65, v66, v67));
            end;

            if u52 > 0 then
                if u53 or u54 then
                    u44:Enable(u45, u46, u52, u47);

                    return;
                end;

                u45:SetAttribute("_PartIclePlaying", true);

                if u60 then
                    u60:SetAttribute("Enabled", true);
                end;

                u44:Enable(u45, u46, u52, u47);
                task.delay(u52, function() -- Line: 380
                    -- upvalues: u44 (ref), u57 (ref), u45 (ref), u55 (ref), u56 (ref), u47 (ref), u60 (ref)
                    local v70;

                    if u44.Connection == nil or ((u44._engineGen or 0) ~= u57 or (not u45.Parent or not u55 and (u45:GetAttribute("_emitGen") or 0) ~= u56)) then
                        v70 = false;
                    else
                        v70 = (not u47 or (not u47._parentAlive or u47._parentAlive[1])) and true or false;
                    end;

                    if not v70 then
                        return;
                    end;

                    if u60 and u60.Parent then
                        u60:SetAttribute("Enabled", false);
                    end;

                    u45:SetAttribute("_PartIclePlaying", nil);
                end);
            end;
        end;

        if v51 > 0 then
            task.delay(v51, doEmit);
        else
            doEmit();
        end;
    end;

    function u3.Enable(u71, u72, u73, p74, u75) -- Line: 394
        -- upvalues: TypeRegistry (ref), u3 (copy), u2 (ref), u1 (ref), success (ref), Selection (ref), EvenCycle (ref), Events (ref)
        u71:_warnIfNotActivated("Enable");
        local u76 = u71:GetData(u72);

        if not u76 then
            return;
        end;

        if (u72:GetAttribute("EmissionMode") or "Emit") == "Animate" then
            u72:SetAttribute("AnimateLoop", true);
            u71:EmitAnimate(u72, u73, u75);

            return;
        end;

        local u77 = p74 or (1 / 0);
        local u78 = TypeRegistry.getConfig(u72);
        local v79;

        if u75 then
            v79 = u75.ChainCtx ~= nil;
        else
            v79 = u75;
        end;

        local u80;

        if u75 then
            u80 = u75._parentAlive ~= nil;
        else
            u80 = u75;
        end;

        local u81 = v79 or u80;
        local u82 = u71._engineGen or 0;

        local function loopBody() -- Line: 413
            -- upvalues: u72 (copy), u81 (copy), u71 (copy), u82 (copy), u80 (copy), u75 (copy), u3 (ref), u77 (copy), u76 (copy), u2 (ref), u1 (ref), success (ref), Selection (ref), u78 (copy), EvenCycle (ref), u73 (copy), Events (ref)
            local v83 = os.clock();
            local v84 = 0;
            local v85 = u72:GetAttribute("_EvenCycleId") or u72;

            while (not u81 or (u71._engineGen or 0) == u82) and (not u80 or (not u75._parentAlive or u75._parentAlive[1])) do
                if not (u72 and u72.Parent) then
                    if not u81 then
                        u3.ActiveLoops[u72] = nil;

                        return;
                    end;

                    break;
                end;

                if u77 <= os.clock() - v83 then
                    if not u81 then
                        u3.ActiveLoops[u72] = nil;

                        return;
                    end;

                    break;
                end;

                if not (u81 or u76.CheckEnabled()) then
                    u3.ActiveLoops[u72] = nil;

                    return;
                end;

                local v86 = u2:Wait();

                if u1 and (success and (not u3._focused and (#Selection:Get() == 0 or u3._unfocusedAt > 0 and os.clock() - u3._unfocusedAt > 600))) then
                    v84 = 0;
                else
                    local v87 = u78 and u78:GetAttribute("Rate") or 10;

                    if v87 <= 0 then
                        v84 = 0;
                    else
                        local v88 = 1 / v87;
                        v84 = v84 + v86;
                        local v89 = (u76.PosXEven or (u76.PosYEven or u76.PosZEven)) == true;
                        local v90;

                        if (u76.RotXEven or (u76.RotYEven or u76.RotZEven)) == true then
                            v90 = true;
                        else
                            v90 = false;
                        end;

                        while v88 <= v84 do
                            v84 = v84 - v88;

                            if v89 or v90 then
                                local v91, v92, v93, v94 = EvenCycle.advance(u71._evenCycleStore, v85, u78, v87, v89, v90);
                                u71:Emit(u72, u73, Events.withEvenOffset(u75, 1, 1, v91, v92, v93, v94));
                            else
                                u71:Emit(u72, u73, u75);
                            end;
                        end;
                    end;
                end;
            end;
        end;

        if not u81 then
            if u3.ActiveLoops[u72] then
                task.cancel(u3.ActiveLoops[u72]);
            end;

            u3.ActiveLoops[u72] = task.spawn(loopBody);

            return;
        end;

        local v97 = task.spawn(function() -- Line: 463
            -- upvalues: loopBody (copy), u3 (ref), u72 (copy)
            loopBody();
            local v95 = coroutine.running();
            local v96 = u3.ActiveChainLoops[u72];

            if not v96 then
                return;
            end;

            for i = #v96, 1, -1 do
                if v96[i] == v95 then
                    table.remove(v96, i);
                    break;
                end;
            end;

            if #v96 == 0 then
                u3.ActiveChainLoops[u72] = nil;
            end;
        end);
        local v98 = u3.ActiveChainLoops[u72];

        if not v98 then
            v98 = {};
            u3.ActiveChainLoops[u72] = v98;
        end;

        table.insert(v98, v97);
    end;

    local u99 = {};
    local u100 = false;

    function u3.EnableEmitAt(p101, p102, p103, p104) -- Line: 485
        -- upvalues: u99 (copy), u100 (ref)
        if not (p102 and (p102.Parent and p103)) then
            return;
        end;

        if not (p102:IsA("BasePart") or (p102:IsA("Attachment") or p102:IsA("Model"))) then
            local ClassName = p102.ClassName;

            if not u99[ClassName] then
                u99[ClassName] = true;
                warn(("[Part-Icles] EnableEmitAt does not support %s targets (origin override is BasePart/Attachment/Model only). Emit skipped."):format(ClassName));
            end;

            return;
        end;

        if (p102:GetAttribute("EmissionMode") or "Emit") == "Animate" then
            if not u100 then
                u100 = true;
                warn("[Part-Icles] EnableEmitAt does not support Animate-mode targets in v1; use EmitMode=AtTarget for Animate sources. Emit skipped.");
            end;

            return;
        end;

        local v105 = p104 or {};

        if v105.Link ~= nil then
            p101:SetLink(p102, v105.Link, v105.LinkMode or "Weld");
        end;

        if v105.EmitParent ~= nil then
            p101:SetEmitParent(p102, v105.EmitParent);
        end;

        p101:EnableEmit(p102, nil, {
            ChainCtx = v105.ChainCtx,
            EventOriginCF = p103,
            EventOriginResolver = v105.OriginResolver,
            UseFullOrigin = v105.UseFullOrigin ~= false,
            IgnoreLink = v105.IgnoreLink == true
        });
    end;

    function u3._registerEmit(p106, p107, p108) -- Line: 525
        -- upvalues: Events (ref)
        if (p106.MAX_ACTIVE_PARTICLES or 1000) <= #p106.ActiveEmits + (p106._lingerVisualCount or 0) then
            local v109 = p107.IsAnimate and ((p107.Type == "Part" or (p107.Type == "Attachment" or p107.Type == "Beam")) and true or p107.Type == "Model");

            if p107.IsAnimate and p107._sourceItem then
                p106.ActiveAnimates[p107._sourceItem] = nil;
            end;

            if not v109 and (p107.VisualPart and p107.VisualPart.Parent) then
                p106:_releaseOrDestroy(p107, p107.VisualPart);
            end;

            return;
        end;

        p107.EventChainCtx = p108 and p108.ChainCtx or (p107.EventChainCtx or Events.newChainCtx());
        table.insert(p106.ActiveEmits, p107);

        if p107.Events and p107.Events.OnHit then
            p107.LastHitCheckPos = Events.getWorldPosition(p107);
            p107.HitParams = Events.makeHitParams(p107);
            p107._hitFired = false;
        end;

        if p107.Events and p107.Events.OnEmit then
            local v110 = Events.makePayload(p106, p107, "OnEmit", p108);
            Events.fire(p106, p107, "OnEmit", p107.EventChainCtx, v110);
        end;
    end;

    function u3._fireOnDeath(p111, p112) -- Line: 560
        -- upvalues: Events (ref)
        if p112.Events and (p112.Events.OnDeath and (not p112._killedManually or p112._fireOnDeathOverride)) then
            Events.fire(p111, p112, "OnDeath", p112.EventChainCtx, nil);
        end;
    end;

    function u3._fireOnDestruction(p113, p114, p115) -- Line: 568
        -- upvalues: Events (ref)
        if p114.Events and (p114.Events.OnDestruction and (p115 and p115.Parent)) then
            Events.fire(p113, p114, "OnDestruction", p114.EventChainCtx, nil);
        end;
    end;

    function u3._releaseOrDestroy(p116, p117, u118) -- Line: 575
        -- upvalues: TypeRegistry (ref), Pool (ref)
        if not u118 then
            return;
        end;

        if not u118.Parent then
            return;
        end;

        if p117.IsAnimate or not (p117._sourceRT and p117._poolKind) then
            pcall(function() -- Line: 579
                -- upvalues: u118 (copy)
                u118:Destroy();
            end);

            return;
        end;

        local v119 = nil;
        local _sourceItem = p117._sourceItem;

        if _sourceItem and _sourceItem.Parent then
            local v120 = TypeRegistry.getConfig(_sourceItem);

            if v120 then
                v119 = v120:GetAttribute("Rate");
            end;
        end;

        Pool.release(u118, p117._sourceRT, p117._poolKind, v119);
    end;

    function u3._makeAliveCheck(u121) -- Line: 593
        local u122 = u121._engineGen or 0;

        return function() -- Line: 595
            -- upvalues: u121 (copy), u122 (copy)
            local v123;

            if u121.Connection == nil then
                v123 = false;
            else
                v123 = (u121._engineGen or 0) == u122;
            end;

            return v123;
        end;
    end;

    function u3._fireAnimateCycleRestartEvents(p124, p125) -- Line: 601
        -- upvalues: Events (ref)
        if p125.Events and p125.Events.OnHit then
            p125.LastHitCheckPos = Events.getWorldPosition(p125);
            p125.LastHitCheckTime = nil;
        end;

        if p125.Events and p125.Events.OnEmit then
            local v126 = Events.makePayload(p124, p125, "OnEmit", {
                EmitIndex = nil,
                ChainCtx = p125.EventChainCtx
            });
            Events.fire(p124, p125, "OnEmit", p125.EventChainCtx, v126);
        end;
    end;

    function u3._killParticle(p127, p128, p129) -- Line: 614
        -- upvalues: TypeRegistry (ref)
        p128._killedManually = true;
        p128._fireOnDeathOverride = (p129 or {}).fireOnDeath == true;
        p128._forceDead = true;
        p128.PartLife = 0;
        local u130 = p128.IsAnimate and p128._sourceItem;

        if u130 then
            pcall(function() -- Line: 623
                -- upvalues: u130 (copy), TypeRegistry (ref)
                u130:SetAttribute("AnimateLoop", false);
                local v131 = TypeRegistry.getConfig(u130);

                if v131 then
                    v131:SetAttribute("Enabled", false);
                end;
            end);
        end;
    end;
end;