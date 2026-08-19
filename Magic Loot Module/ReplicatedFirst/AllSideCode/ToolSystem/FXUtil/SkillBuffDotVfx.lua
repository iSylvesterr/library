-- Decompiled with Potassium's decompiler.

return function(u1) -- Line: 9
    local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
    local RunService = game:GetService("RunService");
    local Players = game:GetService("Players");
    local ReplicatedStorage = game:GetService("ReplicatedStorage");
    local UserInputService = game:GetService("UserInputService");
    local CollectionService = game:GetService("CollectionService");
    local VisibleMgr = UtilsSystem.VisibleMgr;
    local PlayEffectInternal = require(script.Parent.PlayEffectInternal);
    local u2 = { "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso", "Hitbox", "Root", "Main" };

    local function _findDefenderInstInFolder(p3, p4) -- Line: 37
        if not p3 then
            return nil;
        end;

        local v5 = p3:FindFirstChild(p4);

        if v5 and (v5:IsA("Model") or v5:IsA("BasePart")) then
            return v5;
        end;

        for _, descendant in p3:GetDescendants() do
            if (descendant:IsA("Model") or descendant:IsA("BasePart")) and descendant.Name == p4 then
                return descendant;
            end;
        end;

        return nil;
    end;

    local function _resolveDotDefenderTarget(p6, p7) -- Line: 59
        -- upvalues: Players (copy), _findDefenderInstInFolder (copy), CollectionService (copy)
        if type(p6) == "number" then
            local v8 = Players:GetPlayerByUserId(p6);

            return v8 and v8.Character or nil;
        end;

        if type(p7) == "string" and p7 ~= "" then
            local v9 = _findDefenderInstInFolder(workspace:FindFirstChild("Monster"), p7);

            if v9 then
                return v9;
            end;

            local v10 = _findDefenderInstInFolder(workspace:FindFirstChild("Summons"), p7);

            if v10 then
                return v10;
            end;

            for _, v in CollectionService:GetTagged("CanBroke") do
                if v.Name == p7 and (v:IsA("Model") or v:IsA("BasePart")) then
                    return v;
                end;
            end;
        end;

        return nil;
    end;

    local function _resolveSkillBuffDefenderAttachPart(p11) -- Line: 87
        -- upvalues: u2 (copy)
        if p11:IsA("BasePart") then
            return p11;
        end;

        if not p11:IsA("Model") then
            return nil;
        end;

        for _, v in u2 do
            local v12 = p11:FindFirstChild(v);

            if v12 and v12:IsA("BasePart") then
                return v12;
            end;
        end;

        if p11.PrimaryPart and p11.PrimaryPart:IsA("BasePart") then
            return p11.PrimaryPart;
        end;

        local v13 = 0;
        local v14 = nil;

        for _, descendant in p11:GetDescendants() do
            if descendant:IsA("BasePart") then
                local v15 = descendant.Size.X * descendant.Size.Y * descendant.Size.Z;

                if v13 < v15 then
                    v14 = descendant;
                    v13 = v15;
                end;
            end;
        end;

        return v14;
    end;

    local function _weldSkillFxModelToWorldPart(p16, p17) -- Line: 119
        -- upvalues: u1 (copy)
        return u1.WeldFxModelToBasePart(p16, p17);
    end;

    local u18 = {};

    local function _skillBuffDotVfxCacheKey(p19, p20, p21) -- Line: 139
        if type(p21) ~= "string" or p21 == "" then
            return nil;
        end;

        if type(p19) == "number" then
            return "p" .. tostring(p19) .. "_" .. p21;
        end;

        if type(p20) == "string" and p20 ~= "" then
            return "m" .. p20 .. "_" .. p21;
        end;

        return nil;
    end;

    local function _cleanupSkillBuffDotVfxPooled(p22) -- Line: 156
        -- upvalues: PlayEffectInternal (copy), VisibleMgr (copy)
        if not p22 then
            return;
        end;

        PlayEffectInternal.destroyFxWeldConstraintsRecursive(p22);
        VisibleMgr.UnAnchoredAll(p22);
        PlayEffectInternal.stopPooledVfxAndRecycle(p22);
    end;

    local function _cancelSkillBuffDotVfxHandle(p23, p24) -- Line: 170
        -- upvalues: PlayEffectInternal (copy), VisibleMgr (copy), u18 (copy)
        if not p24 or p24.cancelled then
            return;
        end;

        p24.cancelled = true;

        if p24.dieConn then
            p24.dieConn:Disconnect();
            p24.dieConn = nil;
        end;

        local fx = p24.fx;

        if fx then
            PlayEffectInternal.destroyFxWeldConstraintsRecursive(fx);
            VisibleMgr.UnAnchoredAll(fx);
            PlayEffectInternal.stopPooledVfxAndRecycle(fx);
        end;

        if p23 and u18[p23] == p24 then
            u18[p23] = nil;
        end;
    end;

    local function _emitSkillBuffDotVfx(p25, p26) -- Line: 193
        -- upvalues: u1 (copy)
        if p26 then
            u1.Emit_Particles_GetDescendants(p25, true);

            return;
        end;

        u1.EmitOnceThenEnableContinuous(p25);
    end;

    local function _scheduleSkillBuffDotVfxExpire(u27, u28, u29, u30) -- Line: 208
        -- upvalues: u18 (copy), PlayEffectInternal (copy), VisibleMgr (copy)
        u28.renewGen = (u28.renewGen or 0) + 1;
        local renewGen = u28.renewGen;
        task.spawn(function() -- Line: 216
            -- upvalues: u30 (copy), u29 (copy), u28 (copy), renewGen (copy), u27 (copy), u18 (ref), PlayEffectInternal (ref), VisibleMgr (ref)
            local v31;

            if u30 then
                v31 = math.min(u29, 4);
            else
                v31 = u29;
            end;

            task.wait(v31);

            if u28.cancelled or u28.renewGen ~= renewGen then
                return;
            end;

            if (u27 and u18[u27]) ~= u28 then
                return;
            end;

            local v32 = u27;
            local v33 = u28;

            if v33 then
                if v33.cancelled then
                    return;
                end;

                v33.cancelled = true;

                if v33.dieConn then
                    v33.dieConn:Disconnect();
                    v33.dieConn = nil;
                end;

                local fx = v33.fx;

                if fx then
                    PlayEffectInternal.destroyFxWeldConstraintsRecursive(fx);
                    VisibleMgr.UnAnchoredAll(fx);
                    PlayEffectInternal.stopPooledVfxAndRecycle(fx);
                end;

                if v32 and u18[v32] == v33 then
                    u18[v32] = nil;
                end;
            end;
        end);
    end;

    local function _bindSkillBuffDotVfxLifecycle(u34, u35, u36) -- Line: 236
        -- upvalues: PlayEffectInternal (copy), VisibleMgr (copy), u18 (copy)
        if u36.dieConn then
            u36.dieConn:Disconnect();
            u36.dieConn = nil;
        end;

        local v37 = u34:IsA("Model") and u34:FindFirstChildOfClass("Humanoid");

        if v37 then
            u36.dieConn = v37.Died:Connect(function() -- Line: 244
                -- upvalues: u35 (copy), u36 (copy), PlayEffectInternal (ref), VisibleMgr (ref), u18 (ref)
                local v38 = u35;
                local v39 = u36;

                if v39 then
                    if v39.cancelled then
                        return;
                    end;

                    v39.cancelled = true;

                    if v39.dieConn then
                        v39.dieConn:Disconnect();
                        v39.dieConn = nil;
                    end;

                    local fx = v39.fx;

                    if fx then
                        PlayEffectInternal.destroyFxWeldConstraintsRecursive(fx);
                        VisibleMgr.UnAnchoredAll(fx);
                        PlayEffectInternal.stopPooledVfxAndRecycle(fx);
                    end;

                    if v38 and u18[v38] == v39 then
                        u18[v38] = nil;
                    end;
                end;
            end);

            return;
        end;

        u36.dieConn = u34.AncestryChanged:Connect(function() -- Line: 250
            -- upvalues: u34 (copy), u35 (copy), u36 (copy), PlayEffectInternal (ref), VisibleMgr (ref), u18 (ref)
            if not u34.Parent then
                local v40 = u35;
                local v41 = u36;

                if v41 then
                    if v41.cancelled then
                        return;
                    end;

                    v41.cancelled = true;

                    if v41.dieConn then
                        v41.dieConn:Disconnect();
                        v41.dieConn = nil;
                    end;

                    local fx = v41.fx;

                    if fx then
                        PlayEffectInternal.destroyFxWeldConstraintsRecursive(fx);
                        VisibleMgr.UnAnchoredAll(fx);
                        PlayEffectInternal.stopPooledVfxAndRecycle(fx);
                    end;

                    if v40 and u18[v40] == v41 then
                        u18[v40] = nil;
                    end;
                end;
            end;
        end);
    end;

    local function _tryRenewSkillBuffDotVfxHandle(u42, u43, p44, u45, u46) -- Line: 261
        -- upvalues: u1 (copy), u18 (copy), PlayEffectInternal (copy), VisibleMgr (copy)
        if u42.cancelled or not (u42.fx and u42.fx.Parent) then
            return false;
        end;

        if not u1.WeldFxModelToBasePart(u42.fx, p44) then
            return false;
        end;

        local fx = u42.fx;

        if u46 then
            u1.Emit_Particles_GetDescendants(fx, true);
        else
            u1.EmitOnceThenEnableContinuous(fx);
        end;

        u42.renewGen = (u42.renewGen or 0) + 1;
        local renewGen = u42.renewGen;
        task.spawn(function() -- Line: 216
            -- upvalues: u46 (copy), u45 (copy), u42 (copy), renewGen (copy), u43 (copy), u18 (ref), PlayEffectInternal (ref), VisibleMgr (ref)
            local v47;

            if u46 then
                v47 = math.min(u45, 4);
            else
                v47 = u45;
            end;

            task.wait(v47);

            if u42.cancelled or u42.renewGen ~= renewGen then
                return;
            end;

            if (u43 and u18[u43]) ~= u42 then
                return;
            end;

            local v48 = u43;
            local v49 = u42;

            if v49 then
                if v49.cancelled then
                    return;
                end;

                v49.cancelled = true;

                if v49.dieConn then
                    v49.dieConn:Disconnect();
                    v49.dieConn = nil;
                end;

                local fx2 = v49.fx;

                if fx2 then
                    PlayEffectInternal.destroyFxWeldConstraintsRecursive(fx2);
                    VisibleMgr.UnAnchoredAll(fx2);
                    PlayEffectInternal.stopPooledVfxAndRecycle(fx2);
                end;

                if v48 and u18[v48] == v49 then
                    u18[v48] = nil;
                end;
            end;
        end);

        return true;
    end;

    local function _shouldUseLiteSkillBuffDotVfx() -- Line: 283
        -- upvalues: UtilsSystem (copy), Players (copy), UserInputService (copy)
        local GetData = UtilsSystem.GetData;
        local v50 = UtilsSystem.LocalPlayer or Players.LocalPlayer;

        return GetData and (v50 and GetData.GetSetting(v50, "GraphicsQuality") == 0) and true or (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and true or false);
    end;

    function u1.PlayModelResSkillBuffDotHitFx(p51, p52, p53, p54) -- Line: 297
        -- upvalues: RunService (copy), _resolveDotDefenderTarget (copy), _resolveSkillBuffDefenderAttachPart (copy), ReplicatedStorage (copy), UtilsSystem (copy), Players (copy), UserInputService (copy), u18 (copy), _tryRenewSkillBuffDotVfxHandle (copy), PlayEffectInternal (copy), VisibleMgr (copy), u1 (copy), _bindSkillBuffDotVfxLifecycle (copy)
        if RunService:IsServer() then
            return;
        end;

        if type(p51) ~= "string" or p51 == "" then
            return;
        end;

        local v55 = tonumber(p54);
        local u56 = (not v55 or (v55 <= 0 or v55 ~= v55)) and 5 or v55;
        local v57 = _resolveDotDefenderTarget(p52, p53);

        if not (v57 and v57.Parent) then
            return;
        end;

        local v58 = _resolveSkillBuffDefenderAttachPart(v57);

        if not (v58 and v58.Parent) then
            return;
        end;

        local ModelRes = ReplicatedStorage:FindFirstChild("ModelRes");

        if ModelRes then
            ModelRes = ModelRes:FindFirstChild("Skill");
        end;

        if ModelRes then
            ModelRes = ModelRes:FindFirstChild(p51);
        end;

        if not (ModelRes and ModelRes:IsA("Model")) then
            return;
        end;

        local u59;

        if type(p51) == "string" and p51 ~= "" then
            if type(p52) == "number" then
                u59 = "p" .. tostring(p52) .. "_" .. p51;
            elseif type(p53) == "string" and p53 ~= "" then
                u59 = "m" .. p53 .. "_" .. p51;
            else
                u59 = nil;
            end;
        else
            u59 = nil;
        end;

        local GetData = UtilsSystem.GetData;
        local v60 = UtilsSystem.LocalPlayer or Players.LocalPlayer;
        local u61 = GetData and (v60 and GetData.GetSetting(v60, "GraphicsQuality") == 0) and true or (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and true or false);
        local v62;

        if u59 then
            v62 = u18[u59];
        else
            v62 = u59;
        end;

        if v62 and _tryRenewSkillBuffDotVfxHandle(v62, u59, v58, u56, u61) then
            return;
        end;

        if v62 and (v62 and not v62.cancelled) then
            v62.cancelled = true;

            if v62.dieConn then
                v62.dieConn:Disconnect();
                v62.dieConn = nil;
            end;

            local fx = v62.fx;

            if fx then
                PlayEffectInternal.destroyFxWeldConstraintsRecursive(fx);
                VisibleMgr.UnAnchoredAll(fx);
                PlayEffectInternal.stopPooledVfxAndRecycle(fx);
            end;

            if u59 and u18[u59] == v62 then
                u18[u59] = nil;
            end;
        end;

        local v63 = u1.GetInstance_From_Pool(ModelRes);

        if not (v63 and v63:IsA("Model")) then
            return;
        end;

        local ResRestore = UtilsSystem.ResRestore;

        if ResRestore and ResRestore.Restore then
            ResRestore.Restore(v63);
        end;

        local u64 = {
            cancelled = false,
            dieConn = nil,
            renewGen = 0,
            fx = v63
        };

        if u59 then
            u18[u59] = u64;
        end;

        PlayEffectInternal.prepEffectModelForWorldShared(v63, true);
        v63.Parent = workspace.Debris;

        if not u1.WeldFxModelToBasePart(v63, v58) then
            if u64 then
                if u64.cancelled then
                    return;
                end;

                u64.cancelled = true;

                if u64.dieConn then
                    u64.dieConn:Disconnect();
                    u64.dieConn = nil;
                end;

                local fx = u64.fx;

                if fx then
                    PlayEffectInternal.destroyFxWeldConstraintsRecursive(fx);
                    VisibleMgr.UnAnchoredAll(fx);
                    PlayEffectInternal.stopPooledVfxAndRecycle(fx);
                end;

                if u59 and u18[u59] == u64 then
                    u18[u59] = nil;
                end;
            end;

            return;
        end;

        _bindSkillBuffDotVfxLifecycle(v57, u59, u64);

        if u61 then
            u1.Emit_Particles_GetDescendants(v63, true);
        else
            u1.EmitOnceThenEnableContinuous(v63);
        end;

        u64.renewGen = (u64.renewGen or 0) + 1;
        local renewGen = u64.renewGen;
        task.spawn(function() -- Line: 216
            -- upvalues: u61 (copy), u56 (copy), u64 (copy), renewGen (copy), u59 (copy), u18 (ref), PlayEffectInternal (ref), VisibleMgr (ref)
            local v65;

            if u61 then
                v65 = math.min(u56, 4);
            else
                v65 = u56;
            end;

            task.wait(v65);

            if u64.cancelled or u64.renewGen ~= renewGen then
                return;
            end;

            if (u59 and u18[u59]) ~= u64 then
                return;
            end;

            local v66 = u59;
            local v67 = u64;

            if v67 then
                if v67.cancelled then
                    return;
                end;

                v67.cancelled = true;

                if v67.dieConn then
                    v67.dieConn:Disconnect();
                    v67.dieConn = nil;
                end;

                local fx = v67.fx;

                if fx then
                    PlayEffectInternal.destroyFxWeldConstraintsRecursive(fx);
                    VisibleMgr.UnAnchoredAll(fx);
                    PlayEffectInternal.stopPooledVfxAndRecycle(fx);
                end;

                if v66 and u18[v66] == v67 then
                    u18[v66] = nil;
                end;
            end;
        end);
    end;

    function u1.StopModelResSkillBuffDotHitFx(p68, p69, p70) -- Line: 357
        -- upvalues: RunService (copy), u18 (copy), PlayEffectInternal (copy), VisibleMgr (copy)
        if RunService:IsServer() then
            return;
        end;

        if type(p68) ~= "string" or p68 == "" then
            return;
        end;

        local v71;

        if type(p68) == "string" and p68 ~= "" then
            if type(p69) == "number" then
                v71 = "p" .. tostring(p69) .. "_" .. p68;
            elseif type(p70) == "string" and p70 ~= "" then
                v71 = "m" .. p70 .. "_" .. p68;
            else
                v71 = nil;
            end;
        else
            v71 = nil;
        end;

        if not v71 then
            return;
        end;

        local v72 = u18[v71];

        if v72 and v72 then
            if v72.cancelled then
                return;
            end;

            v72.cancelled = true;

            if v72.dieConn then
                v72.dieConn:Disconnect();
                v72.dieConn = nil;
            end;

            local fx = v72.fx;

            if fx then
                PlayEffectInternal.destroyFxWeldConstraintsRecursive(fx);
                VisibleMgr.UnAnchoredAll(fx);
                PlayEffectInternal.stopPooledVfxAndRecycle(fx);
            end;

            if v71 and u18[v71] == v72 then
                u18[v71] = nil;
            end;
        end;
    end;
end;