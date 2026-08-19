-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local Workspace = game:GetService("Workspace");
local Players = game:GetService("Players");
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Observers = require(ReplicatedStorage.Packages.Observers);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local LocalPlayer = Players.LocalPlayer;
local u1 = {
    WarmupColorCorrection = true,
    FlashbangColorCorrection = true
};
local v2 = {};
local u3 = nil;

local function getWarmupAssets() -- Line: 39
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if not Assets then
        return nil;
    end;

    local Warmup = Assets:FindFirstChild("Warmup");

    if Warmup and Warmup:IsA("Folder") then
        return Warmup;
    end;

    return nil;
end;

local function getBestMapColorCorrection() -- Line: 53
    -- upvalues: u3 (ref), Lighting (copy), u1 (copy)
    local v4 = u3;

    if v4 and (v4:IsDescendantOf(Lighting) and not u1[v4.Name]) then
        return v4;
    end;

    local v5 = nil;
    local v6 = nil;

    for _, descendant in ipairs(Lighting:GetDescendants()) do
        if descendant:IsA("ColorCorrectionEffect") and not u1[descendant.Name] then
            if descendant.Enabled then
                v5 = v5 or descendant;
            end;

            if not v6 then
                v6 = descendant;
            end;
        end;
    end;

    u3 = v5 or v6;

    return u3;
end;

local function findActiveViewmodelModel() -- Line: 78
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return nil;
    end;

    for _, child in ipairs(CurrentCamera:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChild("Stats") then
            return child;
        end;
    end;

    for _, descendant in ipairs(CurrentCamera:GetDescendants()) do
        if descendant:IsA("Model") and descendant:FindFirstChild("Stats") then
            return descendant;
        end;
    end;

    return nil;
end;

local function getViewmodelModelFromInstance(p7, p8) -- Line: 101
    local v9 = nil;

    if not p7:IsA("Model") then
        p7 = p7:FindFirstAncestorOfClass("Model");

        if p7 then
            if not p7:IsA("Model") then
                p7 = v9;
            end;
        else
            p7 = v9;
        end;
    end;

    if p7 and (p7:IsDescendantOf(p8) and p7:FindFirstChild("Stats")) then
        return p7;
    end;

    return nil;
end;

local function playCountdownSound() -- Line: 119
    -- upvalues: Router (copy)
    Router.broadcastRouter("RunRoundSound", "Round Start Countdown");
end;

function v2.Start() -- Line: 126
    -- upvalues: ReplicatedStorage (copy), MenuState (copy), LocalPlayer (copy), getBestMapColorCorrection (copy), TweenService (copy), Router (copy), Workspace (copy), findActiveViewmodelModel (copy), getViewmodelModelFromInstance (copy), GameState (copy), Observers (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");
    local v10;

    if Assets then
        v10 = Assets:FindFirstChild("Warmup");

        if not (v10 and v10:IsA("Folder")) then
            v10 = nil;
        end;
    else
        v10 = nil;
    end;

    if not v10 then
        warn("[WarmupEffectsController] Missing ReplicatedStorage.Assets.Warmup");

        return;
    end;

    local ColorCorrection = v10:FindFirstChild("ColorCorrection");
    local ViewmodelHighlight = v10:FindFirstChild("ViewmodelHighlight");

    if not (ColorCorrection and ColorCorrection:IsA("ColorCorrectionEffect")) then
        warn("[WarmupEffectsController] Missing Assets.Warmup.ColorCorrection (ColorCorrectionEffect)");

        return;
    end;

    if not (ViewmodelHighlight and ViewmodelHighlight:IsA("Highlight")) then
        warn("[WarmupEffectsController] Missing Assets.Warmup.ViewmodelHighlight (Highlight)");

        return;
    end;

    local u11 = 0;
    local u12 = nil;
    local u13 = false;
    local u14 = false;

    local function isEligibleToShow() -- Line: 149
        -- upvalues: MenuState (ref), LocalPlayer (ref)
        if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
            return false;
        end;

        local v15 = MenuState.GetMenuFrame();

        if v15 and v15.Visible then
            return false;
        end;

        local v16 = LocalPlayer:GetAttribute("IsSpectating") == true;

        return LocalPlayer.Character ~= nil or v16;
    end;

    local function stop() -- Line: 167
        -- upvalues: u11 (ref), u12 (ref)
        u11 = u11 + 1;

        if u12 then
            u12();
            u12 = nil;
        end;
    end;

    local function startBuyPeriodEffects() -- Line: 175
        -- upvalues: u11 (ref), u12 (ref), getBestMapColorCorrection (ref), ColorCorrection (copy), TweenService (ref), Router (ref), Workspace (ref), findActiveViewmodelModel (ref), ViewmodelHighlight (copy), getViewmodelModelFromInstance (ref)
        u11 = u11 + 1;

        if u12 then
            u12();
            u12 = nil;
        end;

        u11 = u11 + 1;
        local u17 = u11;
        local u18 = false;
        local u19 = false;
        local u20 = nil;
        local u21 = nil;
        local u22 = getBestMapColorCorrection();
        local u23 = nil;
        local u24;

        if u22 then
            u24 = u22.Enabled or false;
        else
            u24 = false;
        end;

        local u25 = u22 and {
            Brightness = u22.Brightness,
            Contrast = u22.Contrast,
            Saturation = u22.Saturation,
            TintColor = u22.TintColor
        } or nil;

        if u22 then
            u22.Enabled = true;
            u22.Brightness = ColorCorrection.Brightness;
            u22.Contrast = ColorCorrection.Contrast;
            u22.Saturation = ColorCorrection.Saturation;
            u22.TintColor = ColorCorrection.TintColor;
        else
            warn("[WarmupEffectsController] No map ColorCorrectionEffect found under Lighting; warmup CC tween skipped");
        end;

        local function getCountdownRemaining() -- Line: 209
            -- upvalues: u18 (ref), u20 (ref), u21 (ref)
            if not (u18 and (u20 and u21)) then
                return 0;
            end;

            local v26 = u21 - (os.clock() - u20);

            return math.max(0, v26);
        end;

        local function startFinalCountdownTweens(p27) -- Line: 216
            -- upvalues: u18 (ref), u20 (ref), u21 (ref), u22 (copy), u25 (copy), u23 (ref), TweenService (ref)
            if u18 then
                return;
            end;

            if p27 <= 0 then
                return;
            end;

            u18 = true;
            u20 = os.clock();
            u21 = p27;

            if u22 and u25 then
                if u23 then
                    u23:Cancel();
                    u23 = nil;
                end;

                local v28 = TweenService:Create(u22, TweenInfo.new(p27, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Brightness = u25.Brightness,
                    Contrast = u25.Contrast,
                    Saturation = u25.Saturation,
                    TintColor = u25.TintColor
                });
                u23 = v28;
                v28:Play();
            end;
        end;

        local function maybePlayGameticSound(p29) -- Line: 246
            -- upvalues: u19 (ref), Router (ref)
            if u19 then
                return;
            end;

            if p29 <= 2 then
                u19 = true;
                Router.broadcastRouter("RunRoundSound", "Round Start Countdown");
            end;
        end;

        local u30 = nil;
        local u31 = nil;
        local u32 = nil;
        local u33 = nil;
        local u34 = nil;
        local u35 = nil;
        local u36 = false;
        local u37 = false;

        local function startHighlightTweenIfPossible(u38) -- Line: 268
            -- upvalues: u36 (ref), u31 (ref), u30 (ref), u18 (ref), u20 (ref), u21 (ref), TweenService (ref)
            if u36 then
                if u38.Parent then
                    u38:Destroy();
                end;

                if u31 == u38 then
                    u31 = nil;
                end;

                return;
            end;

            if u30 then
                return;
            end;

            if not u18 then
                return;
            end;

            local v39;

            if u18 and (u20 and u21) then
                local v40 = u21 - (os.clock() - u20);
                v39 = math.max(0, v40);
            else
                v39 = 0;
            end;

            if v39 > 0 then
                local u41 = TweenService:Create(u38, TweenInfo.new(v39, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    FillTransparency = 1,
                    OutlineTransparency = 1
                });
                u30 = u41;
                u41.Completed:Connect(function(p42) -- Line: 306
                    -- upvalues: u30 (ref), u41 (copy), u36 (ref), u38 (copy), u31 (ref)
                    if u30 == u41 then
                        u30 = nil;
                    end;

                    if p42 == Enum.PlaybackState.Completed then
                        u36 = true;
                    end;

                    if u38.Parent then
                        u38:Destroy();
                    end;

                    if u31 == u38 then
                        u31 = nil;
                    end;
                end);
                u41:Play();

                return;
            end;

            u36 = true;
            u38.FillTransparency = 1;
            u38.OutlineTransparency = 1;
            u38:Destroy();

            if u31 == u38 then
                u31 = nil;
            end;
        end;

        local function ensureHighlightAttached() -- Line: 328
            -- upvalues: u11 (ref), u17 (copy), u36 (ref), u18 (ref), u20 (ref), u21 (ref), u30 (ref), u31 (ref), Workspace (ref), u35 (ref), findActiveViewmodelModel (ref), ViewmodelHighlight (ref), startHighlightTweenIfPossible (copy)
            if u11 ~= u17 then
                return;
            end;

            if u36 then
                return;
            end;

            if u18 then
                local v43;

                if u18 and (u20 and u21) then
                    local v44 = u21 - (os.clock() - u20);
                    v43 = math.max(0, v44);
                else
                    v43 = 0;
                end;

                if v43 <= 0 then
                    u36 = true;

                    if u30 then
                        u30:Cancel();
                        u30 = nil;
                    end;

                    if u31 then
                        u31:Destroy();
                        u31 = nil;
                    end;

                    return;
                end;
            end;

            local CurrentCamera = Workspace.CurrentCamera;

            if not CurrentCamera then
                return;
            end;

            local v45 = u35;

            if not (v45 and v45:IsDescendantOf(CurrentCamera)) then
                v45 = findActiveViewmodelModel();
                u35 = v45;
            end;

            if not v45 then
                return;
            end;

            local v46 = u31;

            if not v46 or v46.Parent == nil then
                v46 = ViewmodelHighlight:Clone();
                u31 = v46;
                u30 = nil;
            end;

            if v46.Parent ~= v45 then
                v46.Parent = v45;
            end;

            if v46.Adornee ~= v45 then
                v46.Adornee = v45;
            end;

            startHighlightTweenIfPossible(v46);
        end;

        local function queueEnsureHighlightAttached() -- Line: 389
            -- upvalues: u37 (ref), u11 (ref), u17 (copy), u36 (ref), ensureHighlightAttached (copy)
            if u37 or (u11 ~= u17 or u36) then
                return;
            end;

            u37 = true;
            task.defer(function() -- Line: 395
                -- upvalues: u37 (ref), ensureHighlightAttached (ref)
                u37 = false;
                ensureHighlightAttached();
            end);
        end;

        ensureHighlightAttached();

        local function bindToCamera(u47) -- Line: 404
            -- upvalues: u32 (ref), u33 (ref), u34 (ref), u36 (ref), getViewmodelModelFromInstance (ref), u35 (ref), u37 (ref), u11 (ref), u17 (copy), ensureHighlightAttached (copy), u31 (ref), ViewmodelHighlight (ref)
            if u32 then
                u32:Disconnect();
                u32 = nil;
            end;

            if u33 then
                u33:Disconnect();
                u33 = nil;
            end;

            if u34 then
                u34:Disconnect();
                u34 = nil;
            end;

            if not u47 then
                return;
            end;

            u32 = u47.ChildAdded:Connect(function(p48) -- Line: 422
                -- upvalues: u36 (ref), getViewmodelModelFromInstance (ref), u47 (copy), u35 (ref), u37 (ref), u11 (ref), u17 (ref), ensureHighlightAttached (ref)
                if u36 then
                    return;
                end;

                local v49 = getViewmodelModelFromInstance(p48, u47);

                if v49 then
                    u35 = v49;
                end;

                if not u37 and u11 == u17 then
                    if u36 then
                        return;
                    end;

                    u37 = true;
                    task.defer(function() -- Line: 395
                        -- upvalues: u37 (ref), ensureHighlightAttached (ref)
                        u37 = false;
                        ensureHighlightAttached();
                    end);
                end;
            end);
            u34 = u47.ChildRemoved:Connect(function(p50) -- Line: 435
                -- upvalues: u36 (ref), u35 (ref), u37 (ref), u11 (ref), u17 (ref), ensureHighlightAttached (ref)
                if u36 then
                    return;
                end;

                if u35 == p50 or u35 and u35:IsDescendantOf(p50) then
                    u35 = nil;
                end;

                if not u37 and u11 == u17 then
                    if u36 then
                        return;
                    end;

                    u37 = true;
                    task.defer(function() -- Line: 395
                        -- upvalues: u37 (ref), ensureHighlightAttached (ref)
                        u37 = false;
                        ensureHighlightAttached();
                    end);
                end;
            end);
            u33 = u47.DescendantAdded:Connect(function(p51) -- Line: 447
                -- upvalues: u36 (ref), u31 (ref), ViewmodelHighlight (ref), getViewmodelModelFromInstance (ref), u47 (copy), u35 (ref), u37 (ref), u11 (ref), u17 (ref), ensureHighlightAttached (ref)
                if u36 then
                    return;
                end;

                if p51 == u31 or p51:IsA("Highlight") and p51.Name == ViewmodelHighlight.Name then
                    return;
                end;

                local v52 = getViewmodelModelFromInstance(p51, u47);

                if not v52 then
                    return;
                end;

                u35 = v52;

                if not u37 and u11 == u17 then
                    if u36 then
                        return;
                    end;

                    u37 = true;
                    task.defer(function() -- Line: 395
                        -- upvalues: u37 (ref), ensureHighlightAttached (ref)
                        u37 = false;
                        ensureHighlightAttached();
                    end);
                end;
            end);
        end;

        bindToCamera(Workspace.CurrentCamera);
        local u53 = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 470
            -- upvalues: u35 (ref), bindToCamera (copy), Workspace (ref), u37 (ref), u11 (ref), u17 (copy), u36 (ref), ensureHighlightAttached (copy)
            u35 = nil;
            bindToCamera(Workspace.CurrentCamera);

            if not u37 and u11 == u17 then
                if u36 then
                    return;
                end;

                u37 = true;
                task.defer(function() -- Line: 395
                    -- upvalues: u37 (ref), ensureHighlightAttached (ref)
                    u37 = false;
                    ensureHighlightAttached();
                end);
            end;
        end);
        local u56 = Workspace:GetAttributeChangedSignal("Timer"):Connect(function() -- Line: 477
            -- upvalues: u11 (ref), u17 (copy), Workspace (ref), u36 (ref), u30 (ref), u31 (ref), u19 (ref), Router (ref), u18 (ref), startFinalCountdownTweens (copy), startHighlightTweenIfPossible (copy), u37 (ref), ensureHighlightAttached (copy)
            if u11 ~= u17 then
                return;
            end;

            local v54 = Workspace:GetAttribute("Timer");

            if typeof(v54) ~= "number" then
                return;
            end;

            if v54 > 0 then
                if not u19 and v54 <= 2 then
                    u19 = true;
                    Router.broadcastRouter("RunRoundSound", "Round Start Countdown");
                end;

                if not u18 and v54 <= 3 then
                    startFinalCountdownTweens((math.min(3, v54)));
                    local v55 = u31;

                    if v55 then
                        startHighlightTweenIfPossible(v55);

                        return;
                    end;

                    if not u37 and u11 == u17 then
                        if u36 then
                            return;
                        end;

                        u37 = true;
                        task.defer(function() -- Line: 395
                            -- upvalues: u37 (ref), ensureHighlightAttached (ref)
                            u37 = false;
                            ensureHighlightAttached();
                        end);
                    end;
                end;

                return;
            end;

            u36 = true;

            if u30 then
                u30:Cancel();
                u30 = nil;
            end;

            if u31 then
                u31:Destroy();
                u31 = nil;
            end;
        end);
        local v57 = Workspace:GetAttribute("Timer");

        if typeof(v57) == "number" then
            if v57 > 0 and (not u19 and v57 <= 2) then
                u19 = true;
                Router.broadcastRouter("RunRoundSound", "Round Start Countdown");
            end;

            if v57 > 0 and v57 <= 3 then
                startFinalCountdownTweens((math.min(3, v57)));
                local v58 = u31;

                if v58 then
                    startHighlightTweenIfPossible(v58);
                elseif not u37 and (u11 == u17 and not u36) then
                    u37 = true;
                    task.defer(function() -- Line: 395
                        -- upvalues: u37 (ref), ensureHighlightAttached (copy)
                        u37 = false;
                        ensureHighlightAttached();
                    end);
                end;
            end;
        end;

        u12 = function() -- Line: 536
            -- upvalues: u37 (ref), u23 (ref), u30 (ref), u32 (ref), u33 (ref), u34 (ref), u53 (ref), u56 (ref), u31 (ref), u22 (copy), u25 (copy), u24 (copy)
            u37 = false;

            if u23 then
                u23:Cancel();
                u23 = nil;
            end;

            if u30 then
                u30:Cancel();
                u30 = nil;
            end;

            if u32 then
                u32:Disconnect();
                u32 = nil;
            end;

            if u33 then
                u33:Disconnect();
                u33 = nil;
            end;

            if u34 then
                u34:Disconnect();
                u34 = nil;
            end;

            if u53 then
                u53:Disconnect();
                u53 = nil;
            end;

            if u56 then
                u56:Disconnect();
                u56 = nil;
            end;

            if u31 then
                u31:Destroy();
                u31 = nil;
            end;

            if u22 and u25 then
                u22.Brightness = u25.Brightness;
                u22.Contrast = u25.Contrast;
                u22.Saturation = u25.Saturation;
                u22.TintColor = u25.TintColor;
                u22.Enabled = u24;
            end;
        end;
    end;

    local function updateState() -- Line: 590
        -- upvalues: GameState (ref), u13 (ref), MenuState (ref), LocalPlayer (ref), u14 (ref), startBuyPeriodEffects (copy), u11 (ref), u12 (ref)
        u13 = GameState.GetState() == "Buy Period";
        local v59;

        if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
            v59 = false;
        else
            local v60 = MenuState.GetMenuFrame();

            if v60 and v60.Visible then
                v59 = false;
            else
                local v61 = LocalPlayer:GetAttribute("IsSpectating") == true;
                v59 = LocalPlayer.Character ~= nil or v61;
            end;
        end;

        if u13 and v59 then
            if not u14 then
                u14 = true;
                startBuyPeriodEffects();
            end;
        elseif u14 then
            u14 = false;
            u11 = u11 + 1;

            if u12 then
                u12();
                u12 = nil;
            end;
        end;
    end;

    GameState.ListenToState(function(p62, p63) -- Line: 609
        -- upvalues: u13 (ref), GameState (ref), MenuState (ref), LocalPlayer (ref), u14 (ref), startBuyPeriodEffects (copy), u11 (ref), u12 (ref)
        u13 = p63 == "Buy Period";
        u13 = GameState.GetState() == "Buy Period";
        local v64;

        if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
            v64 = false;
        else
            local v65 = MenuState.GetMenuFrame();

            if v65 and v65.Visible then
                v64 = false;
            else
                local v66 = LocalPlayer:GetAttribute("IsSpectating") == true;
                v64 = LocalPlayer.Character ~= nil or v66;
            end;
        end;

        if u13 and v64 then
            if not u14 then
                u14 = true;
                startBuyPeriodEffects();
            end;
        elseif u14 then
            u14 = false;
            u11 = u11 + 1;

            if u12 then
                u12();
                u12 = nil;
            end;
        end;
    end);
    MenuState.OnScreenChanged:Connect(function() -- Line: 615
        -- upvalues: GameState (ref), u13 (ref), MenuState (ref), LocalPlayer (ref), u14 (ref), startBuyPeriodEffects (copy), u11 (ref), u12 (ref)
        u13 = GameState.GetState() == "Buy Period";
        local v67;

        if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
            v67 = false;
        else
            local v68 = MenuState.GetMenuFrame();

            if v68 and v68.Visible then
                v67 = false;
            else
                local v69 = LocalPlayer:GetAttribute("IsSpectating") == true;
                v67 = LocalPlayer.Character ~= nil or v69;
            end;
        end;

        if u13 and v67 then
            if not u14 then
                u14 = true;
                startBuyPeriodEffects();
            end;
        elseif u14 then
            u14 = false;
            u11 = u11 + 1;

            if u12 then
                u12();
                u12 = nil;
            end;
        end;
    end);
    MenuState.OnInspectStateChanged:Connect(function() -- Line: 618
        -- upvalues: GameState (ref), u13 (ref), MenuState (ref), LocalPlayer (ref), u14 (ref), startBuyPeriodEffects (copy), u11 (ref), u12 (ref)
        u13 = GameState.GetState() == "Buy Period";
        local v70;

        if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
            v70 = false;
        else
            local v71 = MenuState.GetMenuFrame();

            if v71 and v71.Visible then
                v70 = false;
            else
                local v72 = LocalPlayer:GetAttribute("IsSpectating") == true;
                v70 = LocalPlayer.Character ~= nil or v72;
            end;
        end;

        if u13 and v70 then
            if not u14 then
                u14 = true;
                startBuyPeriodEffects();
            end;
        elseif u14 then
            u14 = false;
            u11 = u11 + 1;

            if u12 then
                u12();
                u12 = nil;
            end;
        end;
    end);
    MenuState.OnCaseSceneStateChanged:Connect(function() -- Line: 621
        -- upvalues: GameState (ref), u13 (ref), MenuState (ref), LocalPlayer (ref), u14 (ref), startBuyPeriodEffects (copy), u11 (ref), u12 (ref)
        u13 = GameState.GetState() == "Buy Period";
        local v73;

        if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
            v73 = false;
        else
            local v74 = MenuState.GetMenuFrame();

            if v74 and v74.Visible then
                v73 = false;
            else
                local v75 = LocalPlayer:GetAttribute("IsSpectating") == true;
                v73 = LocalPlayer.Character ~= nil or v75;
            end;
        end;

        if u13 and v73 then
            if not u14 then
                u14 = true;
                startBuyPeriodEffects();
            end;
        elseif u14 then
            u14 = false;
            u11 = u11 + 1;

            if u12 then
                u12();
                u12 = nil;
            end;
        end;
    end);
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 626
        -- upvalues: GameState (ref), u13 (ref), MenuState (ref), LocalPlayer (ref), u14 (ref), startBuyPeriodEffects (copy), u11 (ref), u12 (ref)
        u13 = GameState.GetState() == "Buy Period";
        local v76;

        if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
            v76 = false;
        else
            local v77 = MenuState.GetMenuFrame();

            if v77 and v77.Visible then
                v76 = false;
            else
                local v78 = LocalPlayer:GetAttribute("IsSpectating") == true;
                v76 = LocalPlayer.Character ~= nil or v78;
            end;
        end;

        if u13 and v76 then
            if not u14 then
                u14 = true;
                startBuyPeriodEffects();
            end;
        elseif u14 then
            u14 = false;
            u11 = u11 + 1;

            if u12 then
                u12();
                u12 = nil;
            end;
        end;
    end);
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 629
        -- upvalues: GameState (ref), u13 (ref), MenuState (ref), LocalPlayer (ref), u14 (ref), startBuyPeriodEffects (copy), u11 (ref), u12 (ref)
        u13 = GameState.GetState() == "Buy Period";
        local v79;

        if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
            v79 = false;
        else
            local v80 = MenuState.GetMenuFrame();

            if v80 and v80.Visible then
                v79 = false;
            else
                local v81 = LocalPlayer:GetAttribute("IsSpectating") == true;
                v79 = LocalPlayer.Character ~= nil or v81;
            end;
        end;

        if u13 and v79 then
            if not u14 then
                u14 = true;
                startBuyPeriodEffects();
            end;
        elseif u14 then
            u14 = false;
            u11 = u11 + 1;

            if u12 then
                u12();
                u12 = nil;
            end;
        end;
    end);
    Observers.observeAttribute(LocalPlayer, "IsSpectating", function() -- Line: 632
        -- upvalues: GameState (ref), u13 (ref), MenuState (ref), LocalPlayer (ref), u14 (ref), startBuyPeriodEffects (copy), u11 (ref), u12 (ref)
        u13 = GameState.GetState() == "Buy Period";
        local v82;

        if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
            v82 = false;
        else
            local v83 = MenuState.GetMenuFrame();

            if v83 and v83.Visible then
                v82 = false;
            else
                local v84 = LocalPlayer:GetAttribute("IsSpectating") == true;
                v82 = LocalPlayer.Character ~= nil or v84;
            end;
        end;

        if u13 and v82 then
            if not u14 then
                u14 = true;
                startBuyPeriodEffects();
            end;
        elseif u14 then
            u14 = false;
            u11 = u11 + 1;

            if u12 then
                u12();
                u12 = nil;
            end;
        end;

        return function() -- Line: 634
        end;
    end);

    if GameState.GetState() == "Buy Period" then
        u13 = true;
    else
        u13 = false;
    end;

    local v85;

    if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
        v85 = false;
    else
        local v86 = MenuState.GetMenuFrame();

        if v86 and v86.Visible then
            v85 = false;
        else
            local v87 = LocalPlayer:GetAttribute("IsSpectating") == true;
            v85 = LocalPlayer.Character ~= nil or v87;
        end;
    end;

    if u13 and v85 then
        if not u14 then
            u14 = true;
            startBuyPeriodEffects();
        end;
    elseif u14 then
        u14 = false;
        u11 = u11 + 1;

        if u12 then
            u12();
            u12 = nil;
        end;
    end;
end;

return v2;