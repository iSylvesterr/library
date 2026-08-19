-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local AssetChatBubbleComponent = require(ReplicatedStorage.Library.Client.UI.AssetChatBubbleComponent);
local Assets = require(ReplicatedStorage.Directory.Assets);
local AssetModels = require(ReplicatedStorage.Library.Modules.AssetModels);
local AssetRuntime = require(ReplicatedStorage.Library.Types.AssetRuntime);
local ActiveAssets = require(ReplicatedStorage.Library.Types.ActiveAssets);
local Audio = require(ReplicatedStorage.Library.Audio);
local BBFromModelVisibleOnly = require(ReplicatedStorage.Library.Functions.BBFromModelVisibleOnly);
local ItemDisplay = require(ReplicatedStorage.Library.Modules.ItemDisplay);
local MusicController = require(ReplicatedStorage.Library.Client.MusicController);
local Player = require(ReplicatedStorage.Library.Player);
local ScaleParticle = require(ReplicatedStorage.Library.Functions.ScaleParticle);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
require(script.Parent.AssetBillboardController);
local AssetInteractionPrompt = require(script.Parent.AssetInteractionPrompt);
local AssetDnaStealAnimation = require(script.Parent.AssetDnaStealAnimation);
local Config = require(script.Parent.AssetDnaStealAnimation.Config);
require(script.Parent.AssetMovementBatch);
local AssetWanderSimulator = require(script.Parent.AssetWanderSimulator);
require(script.Parent.Types);
local u1 = {};
u1.__index = u1;
local SmokeTrail = ReplicatedStorage.Assets.Particles.Pets.SmokeTrail;
local v2 = SmokeTrail:IsA("Attachment");
assert(v2, "SmokeTrail pet particle template must be an Attachment");
local Love = ReplicatedStorage.Assets.Particles.Pets.Love;
local v3 = Love:IsA("Attachment");
assert(v3, "Love pet particle template must be an Attachment");

function u1.new(p4, p5, p6, p7, p8, p9, p10) -- Line: 127
    -- upvalues: AssetRuntime (copy), Asserts (copy), u1 (copy), Trove (copy), ItemDisplay (copy), BBFromModelVisibleOnly (copy), AssetModels (copy), AssetWanderSimulator (copy), Assets (copy), Audio (copy), AssetChatBubbleComponent (copy), AssetInteractionPrompt (copy), Players (copy)
    local v11 = AssetRuntime.SchemaValidation.RuntimeAssetRecord(p4);
    assert(v11, "Invalid runtime asset record");
    Asserts.Player(p5);
    Asserts.BasePart(p6);
    Asserts.Instance(p7);
    local u12 = setmetatable({}, u1);
    u12._trove = Trove.new();
    u12._record = p4;
    u12._owner = p5;
    u12._billboards = p8;
    u12._movementBatch = p9;
    u12._dnaStealAnimation = nil;
    u12._dnaStealFrozen = false;
    u12._hiddenTransparencySnapshot = nil;
    u12._model = ItemDisplay.CreateWanderingAssetModel(p4.OwnerUserId, p4.UID, p4.ItemData, p7);
    u12._trove:Connect(u12._model.DescendantAdded, function(p13) -- Line: 150
        -- upvalues: u12 (copy)
        local _hiddenTransparencySnapshot = u12._hiddenTransparencySnapshot;

        if _hiddenTransparencySnapshot == nil or (not p13:IsA("BasePart") or _hiddenTransparencySnapshot[p13] ~= nil) then
            return;
        end;

        _hiddenTransparencySnapshot[p13] = p13.Transparency;
        p13.Transparency = 1;
    end);
    local PrimaryPart = u12._model.PrimaryPart;
    local v14 = `Asset model {u12._model.Name} must have a PrimaryPart`;
    u12._rootPart = assert(PrimaryPart, v14);
    local CENTER = u12._model:FindFirstChild("CENTER");
    local v15 = `Asset model {u12._model.Name} must contain CENTER`;
    local v16 = assert(CENTER, v15);
    local v17 = v16:IsA("BasePart");
    local v18 = `Asset model {u12._model.Name}.CENTER must be a BasePart`;
    assert(v17, v18);
    u12._centerPart = v16;
    local v19, v20 = BBFromModelVisibleOnly(u12._model);
    local v21 = u12._model:GetPivot():PointToObjectSpace(v19.Position).Y - v20.Y * 0.5;
    local v22 = AssetModels.GetVisibleBoundsData(p4.ItemData.Category);
    local v23 = v22.Size / v22.TemplateScale;
    local v24 = 2.5 + v20.Z * 0.5 * 0.8;
    local v25 = (math.max(v20.Y, 4.5) / 4.5) ^ 0.7;
    local v26 = (math.max(v20.X, v20.Z) - 5.625) / 4.5;
    local v27 = v25 + math.max(v26, 0) ^ 0.65 * 1.15;
    u12._wanderSimulator = AssetWanderSimulator.new(p4.Seed, p5, p6, p4.ItemData, p4.IsFirstPlacement == true, v24, v27);
    local Model = u12._model:FindFirstChild("Model");
    local v28 = `Asset model {u12._model.Name} must contain Model`;
    local v29 = assert(Model, v28):FindFirstChildWhichIsA("AnimationController");
    local v30 = `Asset model {u12._model.Name}.Model must contain AnimationController`;
    local v31 = assert(v29, v30);
    local v32 = v31:FindFirstChildWhichIsA("Animator") or Instance.new("Animator");
    v32.Parent = v31;
    local v33 = Assets.Directory[p4.ItemData.Category];
    local Idle = v33.Animations.Idle;
    local Walk = v33.Animations.Walk;
    local v34 = `Missing Idle animation for {p4.ItemData.Category}`;
    assert(Idle ~= nil, v34);
    local v35 = `Missing Walk animation for {p4.ItemData.Category}`;
    assert(Walk ~= nil, v35);
    u12._idleTrack = v32:LoadAnimation(Idle);
    u12._walkTrack = v32:LoadAnimation(Walk);
    u12._walkAnimationReferenceSpeed = v33.WalkAnimationReferenceSpeed or 8;
    u12._animationTransitionFadeDuration = v33.Animations.TransitionFadeDuration;
    u12._walkAnimationAlwaysOn = u12._animationTransitionFadeDuration == 0;
    u12._idleTrack.Looped = true;
    u12._walkTrack.Looped = true;
    u12._currentTrack = nil;
    u12._idleTransitionRemaining = 0;
    u12._wasJumping = false;
    u12._greetingEffectsActive = false;
    local v36 = (math.max(v20.X, v20.Y, v20.Z) / 6) ^ 0.5;
    u12._greetingEffectScale = math.clamp(v36, 0.7, 6);
    u12._greetingSmokeAttachment = nil;
    u12._greetingLoveAttachment = nil;
    u12._greetingRunLoopSound = nil;
    u12._greetingLoveLoopSound = nil;
    local v37 = math.max(v20.X, v20.Y, v20.Z) / 6 - 1;
    local v38 = math.max(v37, 0) ^ 0.5;
    local v39 = math.clamp(v38 + 1, 1, 3);
    local v40 = math.clamp(v38 + 1, 1, 2);
    u12._jumpSoundVolume = v39 * 0.75;
    u12._jumpSoundMaxDistance = v40 * 50;
    u12._jumpSounds = {};
    u12._walkSound = nil;
    u12._walkSoundBasePlaybackSpeed = 1;
    u12._walkSoundTargetVolume = 0;
    u12._walkSoundFadeTween = nil;
    u12._walkSoundWasMoving = false;
    u12._simulationWasMoving = false;
    u12._randomIdleSound = nil;
    u12._randomIdleRandom = Random.new(p4.Seed);
    u12._soundsSuppressed = false;
    local WalkSound = v33.WalkSound;

    if WalkSound ~= nil then
        local Part = Instance.new("Part");
        Part.Name = "AssetWalkSoundEmitter";
        Part.Anchored = false;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.Massless = true;
        Part.Transparency = 1;
        Part.Size = Vector3.new(0.05, 0.05, 0.05);
        Part.CFrame = u12._rootPart.CFrame * CFrame.new(0, -v20.Y * 0.5, 0);
        Part.Parent = u12._model;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Name = "AssetWalkSoundEmitterWeld";
        WeldConstraint.Part0 = Part;
        WeldConstraint.Part1 = u12._rootPart;
        WeldConstraint.Parent = Part;
        local Sound = Instance.new("Sound");
        Sound.Name = "AssetWalkSound";
        Audio.PrepareSoundFromSoundFile(Sound, WalkSound);
        Sound.Looped = true;
        local v41 = math.max(v20.X, v20.Y, v20.Z) / 6 - 1;
        local v42 = math.max(v41, 0) ^ 0.5;
        local v43 = math.clamp(v42 + 1, 1, 5);
        local v44 = math.clamp(v42 + 1, 1, 3);
        u12._walkSoundBasePlaybackSpeed = Sound.PlaybackSpeed;
        u12._walkSoundTargetVolume = Sound.Volume * v43;
        Sound.RollOffMaxDistance = math.min(Sound.RollOffMaxDistance * v44, 120);
        Sound.Volume = 0;
        Sound.Parent = Part;
        u12._walkSound = Sound;
        local RandomIdleSound = v33.RandomIdleSound;

        if RandomIdleSound ~= nil then
            local Sound2 = Instance.new("Sound");
            Sound2.Name = "AssetRandomIdleSound";
            Audio.PrepareSoundFromSoundFile(Sound2, RandomIdleSound);
            Sound2.Volume = Sound2.Volume * v43;
            Sound2.RollOffMaxDistance = Sound2.RollOffMaxDistance * v44;
            Sound2.Parent = Part;
            u12._randomIdleSound = Sound2;
        end;

        u12._trove:Add(Part);
    end;

    u12._chatBubble = AssetChatBubbleComponent.new(u12._model, u12._centerPart, (v23.X > 6.0229997634887695 or v23.Y > 4.925000190734863) and true or v23.Z > 3.3399999141693115);
    u12._bubbleSuppressionActive = false;
    u12._prompt = AssetInteractionPrompt.new(p4.OwnerUserId, p4.UID, p4.ItemData, u12._model);
    local v45 = p10 or u1._initialCFrame(p4, p6);
    u12._model:PivotTo(v45);
    u12._movementBatch:Add(u12._model, { u12._rootPart }, v45, v21, p6, p5 == Players.LocalPlayer, function(p46, p47) -- Line: 303
        -- upvalues: u12 (copy)
        u12:_step(p46, p47);
    end);

    if u12._walkAnimationAlwaysOn then
        u12:_play(u12._walkTrack);

        return u12;
    end;

    u12:_play(u12._idleTrack);

    return u12;
end;

function u1._tryPlayRandomIdleSound(p48) -- Line: 315
    local _randomIdleSound = p48._randomIdleSound;

    if p48._soundsSuppressed or (_randomIdleSound == nil or p48._randomIdleRandom:NextInteger(1, 13) ~= 1) then
        return;
    end;

    _randomIdleSound.TimePosition = 0;
    _randomIdleSound:Play();
end;

function u1._initialCFrame(p49, p50) -- Line: 329
    local v51 = Random.new(p49.Seed);
    local v52 = p50.Size * 0.5;
    local Position = (p50.CFrame * CFrame.new(v51:NextNumber(-v52.X, v52.X), 0, v51:NextNumber(-v52.Z, v52.Z))).Position;

    return CFrame.new(Position) * CFrame.Angles(0, v51:NextNumber(0, 6.283185307179586), 0);
end;

function u1._play(p53, p54) -- Line: 338
    if p53._currentTrack == p54 then
        return;
    end;

    if p53._currentTrack ~= nil then
        p53._currentTrack:Stop(p53._animationTransitionFadeDuration or 0.35);
    end;

    p53._currentTrack = p54;
    p54:Play(p53._animationTransitionFadeDuration or 0.5);
end;

function u1._walkAnimationSpeed(p55, p56) -- Line: 349
    return math.clamp(p56 / p55._walkAnimationReferenceSpeed, 0.3, 5);
end;

function u1._playJumpSound(u57, p58) -- Line: 357
    -- upvalues: Asserts (copy), Player (copy), Players (copy), Audio (copy)
    Asserts.Vector3(p58);

    if u57._soundsSuppressed then
        return;
    end;

    local v59 = Player.Optional.PrimaryPart(Players.LocalPlayer);

    if v59 == nil or (v59.Position - p58).Magnitude > u57._jumpSoundMaxDistance then
        return;
    end;

    local u60 = Audio.Play("rbxassetid://99709497839588", p58, nil, u57._jumpSoundVolume, u57._jumpSoundMaxDistance);

    if u60 ~= nil then
        u57._jumpSounds[u60] = true;
        u60.Destroying:Once(function() -- Line: 371
            -- upvalues: u57 (copy), u60 (copy)
            u57._jumpSounds[u60] = nil;
        end);
    end;
end;

function u1._setAttachmentEmittersEnabled(p61, p62) -- Line: 377
    -- upvalues: Asserts (copy)
    Asserts.Instance(p61);
    Asserts.boolean(p62);

    for _, descendant in ipairs(p61:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = p62;
        end;
    end;
end;

function u1._prepareGreetingAttachment(p63, p64, p65) -- Line: 388
    -- upvalues: Asserts (copy), ScaleParticle (copy)
    Asserts.Instance(p63);
    Asserts.string(p64);
    Asserts.number(p65);
    local v66 = p63:Clone();
    v66.Name = p64;

    for _, descendant in ipairs(v66:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            ScaleParticle(descendant, p65);
            descendant.Enabled = false;
        end;
    end;

    return v66;
end;

function u1._isLocalPlayerNear(p67, p68) -- Line: 405
    -- upvalues: Asserts (copy), Player (copy), Players (copy)
    Asserts.number(p68);
    local v69 = Player.Optional.PrimaryPart(Players.LocalPlayer);
    local v70;

    if v69 == nil then
        v70 = false;
    else
        v70 = (v69.Position - p67._rootPart.Position).Magnitude <= p68;
    end;

    return v70;
end;

function u1._getGreetingSmokeAttachment(p71) -- Line: 412
    -- upvalues: u1 (copy), SmokeTrail (copy)
    local _greetingSmokeAttachment = p71._greetingSmokeAttachment;

    if _greetingSmokeAttachment ~= nil then
        return _greetingSmokeAttachment;
    end;

    local v72 = u1._prepareGreetingAttachment(SmokeTrail, "AssetGreetingSmokeTrail", p71._greetingEffectScale);
    v72.Parent = p71._rootPart;
    p71._greetingSmokeAttachment = v72;

    return v72;
end;

function u1._getGreetingLoveAttachment(p73) -- Line: 429
    -- upvalues: u1 (copy), Love (copy)
    local _greetingLoveAttachment = p73._greetingLoveAttachment;

    if _greetingLoveAttachment ~= nil then
        return _greetingLoveAttachment;
    end;

    local v74 = u1._prepareGreetingAttachment(Love, "AssetGreetingLove", p73._greetingEffectScale);
    v74.Parent = p73._rootPart;
    p73._greetingLoveAttachment = v74;

    return v74;
end;

function u1._stopGreetingLoopSounds(p75) -- Line: 446
    local _greetingRunLoopSound = p75._greetingRunLoopSound;

    if _greetingRunLoopSound ~= nil then
        p75._greetingRunLoopSound = nil;
        _greetingRunLoopSound:Stop();
        _greetingRunLoopSound:Destroy();
    end;

    local _greetingLoveLoopSound = p75._greetingLoveLoopSound;

    if _greetingLoveLoopSound ~= nil then
        p75._greetingLoveLoopSound = nil;
        _greetingLoveLoopSound:Stop();
        _greetingLoveLoopSound:Destroy();
    end;
end;

function u1._startGreetingLoopSounds(p76) -- Line: 462
    -- upvalues: Audio (copy)
    if p76._soundsSuppressed or not p76:_isLocalPlayerNear(80) then
        return;
    end;

    if p76._greetingRunLoopSound == nil then
        p76._greetingRunLoopSound = Audio.Play("rbxassetid://95120998510832", p76._rootPart, nil, 0.75, 80, nil, true);
    end;

    if p76._greetingLoveLoopSound == nil then
        p76._greetingLoveLoopSound = Audio.Play("rbxassetid://97690085331828", p76._rootPart, nil, 0.75, 80, nil, true);
    end;
end;

function u1._setGreetingEffectsActive(p77, p78) -- Line: 491
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.boolean(p78);

    if p78 then
        if not p77._greetingEffectsActive then
            u1._setAttachmentEmittersEnabled(p77:_getGreetingSmokeAttachment(), true);
            u1._setAttachmentEmittersEnabled(p77:_getGreetingLoveAttachment(), true);
        end;

        if p77:_isLocalPlayerNear(80) then
            p77:_startGreetingLoopSounds();
        else
            p77:_stopGreetingLoopSounds();
        end;
    elseif p77._greetingEffectsActive then
        local _greetingSmokeAttachment = p77._greetingSmokeAttachment;

        if _greetingSmokeAttachment ~= nil then
            u1._setAttachmentEmittersEnabled(_greetingSmokeAttachment, false);
        end;

        local _greetingLoveAttachment = p77._greetingLoveAttachment;

        if _greetingLoveAttachment ~= nil then
            u1._setAttachmentEmittersEnabled(_greetingLoveAttachment, false);
        end;

        p77:_stopGreetingLoopSounds();
    end;

    p77._greetingEffectsActive = p78;
end;

function u1._destroyGreetingEffects(p79) -- Line: 519
    p79:_setGreetingEffectsActive(false);
    local _greetingSmokeAttachment = p79._greetingSmokeAttachment;

    if _greetingSmokeAttachment ~= nil then
        p79._greetingSmokeAttachment = nil;
        _greetingSmokeAttachment:Destroy();
    end;

    local _greetingLoveAttachment = p79._greetingLoveAttachment;

    if _greetingLoveAttachment ~= nil then
        p79._greetingLoveAttachment = nil;
        _greetingLoveAttachment:Destroy();
    end;
end;

function u1._releaseBubbleSuppression(p80) -- Line: 533
    if not p80._bubbleSuppressionActive then
        return;
    end;

    p80._bubbleSuppressionActive = false;
    p80._billboards:SetSuppressed(p80._model, false);
end;

function u1._displayChatBubble(u81, p82) -- Line: 542
    if not u81._bubbleSuppressionActive then
        u81._bubbleSuppressionActive = true;
        u81._billboards:SetSuppressed(u81._model, true);
    end;

    u81._chatBubble:Display(p82, function() -- Line: 547
        -- upvalues: u81 (copy)
        u81:_releaseBubbleSuppression();
    end);
end;

function u1._setWalkSoundMoving(u83, p84, p85) -- Line: 552
    -- upvalues: Audio (copy)
    if u83._soundsSuppressed then
        p84 = false;
    end;

    local _walkSound = u83._walkSound;

    if _walkSound == nil then
        return;
    end;

    if p84 then
        local v86 = math.clamp(p85 / 8, 0.3, 5);
        _walkSound.PlaybackSpeed = u83._walkSoundBasePlaybackSpeed * v86;

        if not u83._walkSoundWasMoving then
            local _walkSoundFadeTween = u83._walkSoundFadeTween;

            if _walkSoundFadeTween ~= nil then
                _walkSoundFadeTween:Cancel();
            end;

            _walkSound.Volume = 0;

            if _walkSound.IsLoaded and _walkSound.TimeLength > 2 then
                _walkSound.TimePosition = math.random() * (_walkSound.TimeLength - 1);
            end;

            _walkSound:Play();
        end;

        if not u83._walkSoundWasMoving then
            local v87 = Audio.Fade(_walkSound, u83._walkSoundTargetVolume, 0.1);
            u83._walkSoundFadeTween = v87;
            v87:Play();
        end;

        u83._walkSoundWasMoving = true;

        return;
    end;

    if not u83._walkSoundWasMoving then
        return;
    end;

    u83._walkSoundWasMoving = false;
    local _walkSoundFadeTween = u83._walkSoundFadeTween;

    if _walkSoundFadeTween ~= nil then
        _walkSoundFadeTween:Cancel();
    end;

    local u88 = Audio.Fade(_walkSound, 0, 0.1);
    u83._walkSoundFadeTween = u88;
    u88:Play();
    u88.Completed:Once(function() -- Line: 599
        -- upvalues: u83 (copy), u88 (copy), _walkSound (copy)
        if u83._walkSoundFadeTween == u88 then
            u83._walkSoundFadeTween = nil;
            _walkSound:Stop();
        end;
    end);
end;

function u1._setSoundsSuppressed(p89, p90) -- Line: 607
    -- upvalues: Asserts (copy)
    Asserts.boolean(p90);

    if p89._soundsSuppressed == p90 then
        return;
    end;

    p89._soundsSuppressed = p90;

    if not p90 then
        return;
    end;

    p89:_stopGreetingLoopSounds();

    for i in p89._jumpSounds do
        i:Stop();
    end;

    table.clear(p89._jumpSounds);
    local _randomIdleSound = p89._randomIdleSound;

    if _randomIdleSound ~= nil then
        _randomIdleSound:Stop();
    end;

    p89:_setWalkSoundMoving(false, 0);
end;

function u1._step(p91, p92, p93) -- Line: 630
    -- upvalues: MusicController (copy)
    p91:_setSoundsSuppressed(MusicController.IsNonDefaultTreadmillActive() or p93);
    local v94 = p91._movementBatch:GetSimulationCFrame(p91._model);
    local v95, v96, v97, v98, v99, v100 = p91._wanderSimulator:Step(p92, v94);
    local v101 = p91._simulationWasMoving and not v96;
    p91._simulationWasMoving = v96;

    if v100 ~= nil then
        p91:_displayChatBubble(v100);
    end;

    if v99 then
        v99 = not p93;
    end;

    p91:_setGreetingEffectsActive(v99);
    local v102 = not v97;

    if v102 and not p91._wasJumping then
        p91:_playJumpSound(v94.Position);
    end;

    p91._wasJumping = v102;
    p91._movementBatch:SetGroundingEnabled(p91._model, v97);
    p91._movementBatch:SetTarget(p91._model, v95);

    if p91._dnaStealFrozen then
        p91:_setWalkSoundMoving(false, 0);
        local _currentTrack = p91._currentTrack;

        if _currentTrack ~= nil then
            _currentTrack:AdjustSpeed(0);
        end;

        return;
    end;

    if v101 then
        p91:_tryPlayRandomIdleSound();
    end;

    local v103;

    if v96 then
        v103 = not p93;
    else
        v103 = v96;
    end;

    p91:_setWalkSoundMoving(v103, v98);

    if p91._walkAnimationAlwaysOn then
        p91._idleTransitionRemaining = 0;
        p91:_play(p91._walkTrack);
        p91._walkTrack:AdjustSpeed(p93 and 0 or p91:_walkAnimationSpeed(v98));

        return;
    end;

    if p93 then
        p91._idleTransitionRemaining = 0;
        p91:_play(p91._idleTrack);
        p91._idleTrack:AdjustSpeed(1);

        return;
    end;

    if v96 then
        p91._idleTransitionRemaining = 0.28;
        p91:_play(p91._walkTrack);
        p91._walkTrack:AdjustSpeed(p91:_walkAnimationSpeed(v98));

        return;
    end;

    if p91._currentTrack ~= p91._walkTrack or p91._idleTransitionRemaining <= 0 then
        p91:_play(p91._idleTrack);

        return;
    end;

    p91._idleTransitionRemaining = math.max(p91._idleTransitionRemaining - p92, 0);
    p91._walkTrack:AdjustSpeed(p91:_walkAnimationSpeed(v98));
end;

function u1.GetOwnerUserId(p104) -- Line: 689
    return p104._record.OwnerUserId;
end;

function u1.GetUid(p105) -- Line: 693
    return p105._record.UID;
end;

function u1.GetModel(p106) -- Line: 697
    return p106._model;
end;

function u1.GetRuntimeRecord(p107) -- Line: 701
    return p107._record;
end;

function u1.IsHidden(p108) -- Line: 705
    return p108._hiddenTransparencySnapshot ~= nil;
end;

function u1.SetHidden(p109, p110) -- Line: 709
    -- upvalues: Asserts (copy)
    Asserts.boolean(p110);

    if p109:IsHidden() == p110 then
        return;
    end;

    if not p110 then
        local v111 = assert(p109._hiddenTransparencySnapshot, "Hidden asset must own a transparency snapshot");
        p109._hiddenTransparencySnapshot = nil;

        for i, v in pairs(v111) do
            if i.Parent ~= nil then
                i.Transparency = v;
            end;
        end;

        table.clear(v111);
        p109._prompt:SetSuppressed(false);
        p109._chatBubble:SetSuppressed(false);

        return;
    end;

    p109:_setGreetingEffectsActive(false);
    p109._chatBubble:SetSuppressed(true);
    p109:_releaseBubbleSuppression();
    p109._prompt:SetSuppressed(true);
    local v112 = {};
    p109._hiddenTransparencySnapshot = v112;

    for _, descendant in ipairs(p109._model:GetDescendants()) do
        if descendant:IsA("BasePart") then
            v112[descendant] = descendant.Transparency;
            descendant.Transparency = 1;
        end;
    end;
end;

function u1.ActivateDnaSteal(p113) -- Line: 743
    p113._prompt:Activate();
end;

function u1.SetRuntimeRecord(p114, p115) -- Line: 747
    -- upvalues: AssetRuntime (copy)
    local v116 = AssetRuntime.SchemaValidation.RuntimeAssetRecord(p115);
    assert(v116, "Invalid runtime asset record");
    p114._record = p115;
    p114._wanderSimulator:SetItemData(p115.ItemData, p115.IsFirstPlacement == true);
end;

function u1.SetAssetArea(p117, p118) -- Line: 753
    -- upvalues: Asserts (copy)
    Asserts.BasePart(p118);
    p117._wanderSimulator:SetAssetArea(p118);
    p117._movementBatch:SetAssetArea(p117._model, p118);
end;

function u1.PlayDnaStealAnimation(u119, p120) -- Line: 759
    -- upvalues: ActiveAssets (copy), AssetDnaStealAnimation (copy), Config (copy)
    local v121 = ActiveAssets.DnaStealAnimationPayload(p120);
    assert(v121, "Invalid DNA steal animation payload");
    local _dnaStealAnimation = u119._dnaStealAnimation;

    if _dnaStealAnimation ~= nil then
        _dnaStealAnimation:Destroy();
    end;

    local u122 = nil;
    u122 = AssetDnaStealAnimation.new(u119._movementBatch, u119._model, p120, function(p123) -- Line: 769
        -- upvalues: u119 (copy), Config (ref), u122 (ref)
        u119._dnaStealFrozen = p123;

        if not p123 then
            local _currentTrack = u119._currentTrack;

            if _currentTrack ~= nil then
                _currentTrack:AdjustSpeed(1);
            end;
        end;

        local v124;

        if p123 then
            v124 = nil;
        else
            v124 = Config.CatchUpSeconds;
        end;

        u119._movementBatch:SetPresentationFrozen(u119._model, p123, v124);

        if not p123 and u119._dnaStealAnimation == u122 then
            u119._dnaStealAnimation = nil;
        end;
    end);
    u119._dnaStealAnimation = u122;
end;

function u1.Destroy(p125) -- Line: 789
    local _dnaStealAnimation = p125._dnaStealAnimation;

    if _dnaStealAnimation ~= nil then
        _dnaStealAnimation:Destroy();
        p125._dnaStealAnimation = nil;
    end;

    p125:_destroyGreetingEffects();
    p125._chatBubble:Destroy();
    p125._prompt:Destroy();
    p125._movementBatch:Remove(p125._model);
    p125._trove:Destroy();
    p125._model:Destroy();
end;

return u1;