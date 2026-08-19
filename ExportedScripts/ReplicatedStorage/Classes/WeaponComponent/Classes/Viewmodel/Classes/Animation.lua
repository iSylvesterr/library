-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local u2 = { "7", "73", "735", "7355", "73556", "735560", "7355608" };

local function isInspectVariantName(p3) -- Line: 52
    return p3 == "Inspect" and true or string.match(p3, "^Inspect%d+$") ~= nil;
end;

local function getVariantBaseName(p4) -- Line: 58
    local v5 = string.gsub(p4, "%d+$", "");

    if v5 == "" then
        return p4;
    end;

    return v5;
end;

local function shouldSkipDuplicateSoundEvent(p6, p7) -- Line: 66
    local v8 = tick();
    local v9 = p6:GetAttribute("LastSoundEventName");
    local v10 = p6:GetAttribute("LastSoundEventTick");

    if v9 == p7 and (type(v10) == "number" and (v8 - v10 >= 0 and v8 - v10 <= 0.02)) then
        return true;
    end;

    p6:SetAttribute("LastSoundEventName", p7);
    p6:SetAttribute("LastSoundEventTick", v8);

    return false;
end;

local function handleAnimationSoundEvent(u11, p12, p13, p14, p15, p16, p17) -- Line: 87
    -- upvalues: shouldSkipDuplicateSoundEvent (copy), FlashEffect (copy), PlayerGui (copy), LocalPlayer (copy), Remotes (copy)
    if p16 then
        p16 = p16:FindFirstChild(p14);
    end;

    if u11.IsDestroyed then
        return;
    end;

    local Character = p17.Character;

    if not Character then
        return;
    end;

    if not p16 or #p16:GetChildren() <= 0 then
        return;
    end;

    if shouldSkipDuplicateSoundEvent(p12, p14) then
        return;
    end;

    local u18 = p15:play({
        Parent = PlayerGui,
        Name = p14
    }, (FlashEffect.GetAudioFadeMultiplier()));

    if u18 then
        u11.ActiveSounds[u18] = p13;
        u18.Ended:Once(function() -- Line: 125
            -- upvalues: u11 (copy), u18 (copy)
            if not u11.IsDestroyed then
                u11.ActiveSounds[u18] = nil;
            end;
        end);
    end;

    if Character:FindFirstChild("Head") then
        local Head = Character:WaitForChild("Head");
        local v19 = string.gsub(p13, "%d+$", "");

        if v19 == "" then
            v19 = p13;
        end;

        if v19 == "Equip" or (p13 == "Inspect" or string.match(p13, "^Inspect%d+$") ~= nil) then
            return;
        end;

        if LocalPlayer ~= p17 then
            return;
        end;

        if p14 == "Prepare" and p15.SoundGroupName == "R8 Revolver" then
            return;
        end;

        Remotes.Sound.ReplicateSound.Send({
            Parent = Head,
            Class = p15.SoundGroupName,
            Name = p14
        });
    end;
end;

local function connectTrackSoundEvents(p20, u21, u22) -- Line: 156
    -- upvalues: handleAnimationSoundEvent (copy)
    local Sound = p20.Sound;
    local Sounds = Sound.Sounds;
    local Player = p20.Player;
    local u23 = {};
    local u24 = setmetatable({}, {
        __mode = "v"
    });
    u24.instance = p20;
    table.insert(u23, u21.KeyframeReached:Connect(function(p25) -- Line: 169, Name: onSoundEvent
        -- upvalues: u24 (copy), handleAnimationSoundEvent (ref), u21 (copy), u22 (copy), Sound (copy), Sounds (copy), Player (copy)
        local instance = u24.instance;

        if not instance then
            return;
        end;

        handleAnimationSoundEvent(instance, u21, u22, p25, Sound, Sounds, Player);
    end));

    if Sounds then
        for _, child in ipairs(Sounds:GetChildren()) do
            if child:IsA("Folder") then
                local Name = child.Name;
                local v26 = u21:GetMarkerReachedSignal(Name);
                table.insert(u23, v26:Connect(function() -- Line: 195
                    -- upvalues: Name (copy), u24 (copy), handleAnimationSoundEvent (ref), u21 (copy), u22 (copy), Sound (copy), Sounds (copy), Player (copy)
                    local instance = u24.instance;

                    if not instance then
                        return;
                    end;

                    handleAnimationSoundEvent(instance, u21, u22, Name, Sound, Sounds, Player);
                end));
            end;
        end;
    end;

    return function() -- Line: 201
        -- upvalues: u23 (copy)
        for _, v in ipairs(u23) do
            v:Disconnect();
        end;

        table.clear(u23);
    end;
end;

function u1.getAnimation(p27, p28) -- Line: 211
    return p27.Animations[p28];
end;

local function computeVariantProbabilities(p29) -- Line: 230
    local v30 = #p29;
    local v31 = 0;
    local v32 = 0;
    local v33 = {};

    for _, v in ipairs(p29) do
        if v.weight == nil then
            v32 = v32 + 1;
        else
            v31 = v31 + math.max(v.weight, 0);
        end;
    end;

    local v34 = math.max(0, 1 - v32 / v30);
    local v35 = v30 - v32;

    for i, v in ipairs(p29) do
        if v.weight == nil then
            v33[i] = 1 / v30;
        elseif v31 > 0 then
            v33[i] = v34 * (math.max(v.weight, 0) / v31);
        else
            v33[i] = v34 / v35;
        end;
    end;

    return v33;
end;

local function rollVariant(p36, p37) -- Line: 262
    -- upvalues: computeVariantProbabilities (copy)
    if not p36 or #p36 == 0 then
        return p37;
    end;

    if #p36 == 1 then
        return p36[1].name;
    end;

    local v38 = computeVariantProbabilities(p36);
    local v39 = math.random();
    local v40 = 0;

    for i, v in ipairs(p36) do
        v40 = v40 + v38[i];

        if v39 < v40 then
            return v.name;
        end;
    end;

    return p36[#p36].name;
end;

function u1.pickVariant(p41, p42) -- Line: 291
    -- upvalues: rollVariant (copy)
    return rollVariant(p41.VariantGroups[p42], p42);
end;

function u1.pickInspectVariant(p43) -- Line: 303
    -- upvalues: rollVariant (copy)
    local v44 = os.clock();

    if p43.LastInspectVariant and (p43.LastInspectCancelTime and (v44 - p43.LastInspectCancelTime <= 1 and p43.Animations[p43.LastInspectVariant])) then
        return p43.LastInspectVariant;
    end;

    local v45 = rollVariant(p43.VariantGroups.Inspect, "Inspect");
    p43.LastInspectVariant = v45;
    p43.LastInspectTime = v44;

    return v45;
end;

function u1.markInspectCancel(p46) -- Line: 324
    p46.LastInspectCancelTime = os.clock();
end;

function u1.adjustAnimationSpeed(p47, p48, p49) -- Line: 330
    local v50 = p47:getAnimation(p48);

    if v50 then
        v50:AdjustSpeed(v50.Length / p49);
    end;
end;

function u1.play(p51, p52, ...) -- Line: 340
    local v53 = p51:getAnimation(p52);
    p51.CurrentAnimation = p52;

    if not v53 then
        return nil;
    end;

    v53:Play(...);

    return v53;
end;

function u1.stop(p54, p55, p56) -- Line: 355
    local v57 = p54:getAnimation(p55);

    if v57 and v57.IsPlaying then
        v57:Stop(p56 or 0);
    end;
end;

local function hermiteEaseOut(p58) -- Line: 370
    return p58 * 3 * p58 - p58 * 2 * p58 * p58;
end;

function u1.cancelCrossfade(p59) -- Line: 376
    if p59.CrossfadeConnection then
        p59.CrossfadeConnection:Disconnect();
        p59.CrossfadeConnection = nil;
    end;

    if p59.CrossfadeTempTrack then
        p59.CrossfadeTempTrack:Stop(0);
        p59.CrossfadeTempTrack:Destroy();
        p59.CrossfadeTempTrack = nil;
    end;

    p59.IsCrossfading = false;
end;

function u1.isCrossfading(p60) -- Line: 392
    return p60.IsCrossfading == true;
end;

function u1.crossfadeRestart(u61, p62, p63) -- Line: 398
    -- upvalues: connectTrackSoundEvents (copy), RunServiceController (copy)
    local u64 = p63 or 0.25;
    u61:cancelCrossfade();
    local VariantGroups = u61.VariantGroups;
    local v65 = string.gsub(p62, "%d+$", "");

    if v65 == "" then
        v65 = p62;
    end;

    local v66 = VariantGroups[v65];

    if v66 then
        for _, v in ipairs(v66) do
            if v.name ~= p62 then
                local v67 = u61.Animations[v.name];

                if v67 and v67.IsPlaying then
                    v67:Stop(0);
                end;
            end;
        end;
    end;

    local u68 = u61:getAnimation(p62);

    if not u68 then
        return nil;
    end;

    local WeightCurrent = u68.WeightCurrent;

    if not u68.IsPlaying then
        u68:Play(0, 1, 1);

        return u68;
    end;

    local u69 = math.max(WeightCurrent, 0.5);
    local Animation = u68.Animation;

    if not Animation then
        u68:Stop(0);
        u68:Play(0, 1, 1);

        return u68;
    end;

    local success, result = pcall(function() -- Line: 444
        -- upvalues: u61 (copy), Animation (copy)
        return u61.Animator:LoadAnimation(Animation);
    end);

    if not (success and result) then
        u68:Stop(0);
        u68:Play(0, 1, 1);

        return u68;
    end;

    local u70 = connectTrackSoundEvents(u61, result, p62);
    result:Play(0, 0.01, 1);
    result.TimePosition = 0;
    u61.CrossfadeTempTrack = result;
    local u71 = tick();
    u61.CurrentAnimation = p62;
    u61.IsCrossfading = true;
    local v72 = RunServiceController.CreateBindingName("Classes.Viewmodel.Animation.Crossfade");
    u61.CrossfadeConnection = RunServiceController.BindToRenderStep(v72, function() -- Line: 468
        -- upvalues: u61 (copy), u70 (copy), u71 (copy), u64 (copy), u69 (copy), u68 (copy), result (copy)
        if u61.IsDestroyed then
            u70();
            u61:cancelCrossfade();

            return;
        end;

        local v73 = (tick() - u71) / u64;
        local v74 = math.clamp(v73, 0, 1);
        local v75 = v74 * 3 * v74 - v74 * 2 * v74 * v74;
        local v76 = math.max(v75, 0.01);
        u68:AdjustWeight(u69 * (1 - v75), 0);
        result:AdjustWeight(v76, 0);

        if v74 >= 1 then
            u70();
            local TimePosition = result.TimePosition;
            u68:Stop(0);
            u68:Play(0, 1, 1);
            u68.TimePosition = TimePosition;
            u68:AdjustWeight(1, 0);
            result:Stop(0);
            result:Destroy();
            u61.CrossfadeTempTrack = nil;
            u61:cancelCrossfade();
        end;
    end);

    return u68;
end;

function u1.crossfadeTo(u77, p78, p79) -- Line: 514
    -- upvalues: RunServiceController (copy)
    u77:cancelCrossfade();
    local u80 = {};
    local u81 = p79 or 0.25;

    for i, v in pairs(u77.Animations) do
        if v.IsPlaying and (i ~= "Idle" and i ~= p78) then
            table.insert(u80, {
                track = v,
                startWeight = v.WeightCurrent
            });
        end;
    end;

    local u82 = u77:getAnimation(p78);
    local u83 = p78 == "Idle";

    if not (u82 or u83) then
        return nil;
    end;

    u77.CurrentAnimation = p78;
    u77.IsCrossfading = true;

    if u82 and not u83 then
        u82:Play(0, 0, 1);
    end;

    local u84 = tick();
    local v85 = RunServiceController.CreateBindingName("Classes.Viewmodel.Animation.Crossfade");
    u77.CrossfadeConnection = RunServiceController.BindToRenderStep(v85, function() -- Line: 552
        -- upvalues: u77 (copy), u84 (copy), u81 (copy), u80 (copy), u82 (copy), u83 (copy)
        if u77.IsDestroyed then
            u77:cancelCrossfade();

            return;
        end;

        local v86 = (tick() - u84) / u81;
        local v87 = math.clamp(v86, 0, 1);
        local v88 = 1 - v87;
        local v89 = v88 * 3 * v88 - v88 * 2 * v88 * v88;

        for _, v in ipairs(u80) do
            if v.track then
                v.track:AdjustWeight(v.startWeight * v89, 0);
            end;
        end;

        if u82 and not u83 then
            u82:AdjustWeight(1 - v89, 0);
        end;

        if v87 >= 1 then
            for _, v in ipairs(u80) do
                if v.track and v.track.IsPlaying then
                    v.track:Stop(0);
                end;
            end;

            if u83 and u82 then
                u82:Play(0, 1, 1);
            elseif u82 then
                u82:AdjustWeight(1, 0);
            end;

            u77:cancelCrossfade();
        end;
    end);

    return u82;
end;

function u1.stopAnimations(p90, p91) -- Line: 602
    p90:cancelCrossfade();

    for _, v in pairs(p90.Animations) do
        if v.IsPlaying then
            v:Stop(p91 or 0);
        end;
    end;

    p90:stopSounds();
end;

function u1.stopSounds(p92) -- Line: 617
    for i, v in pairs(p92.ActiveSounds) do
        if v then
            local v = string.find(v, "Shoot") ~= nil;
        end;

        if not v then
            p92.ActiveSounds[i] = nil;

            if i and i.Parent then
                i:Destroy();
            end;
        end;
    end;
end;

function u1.unregister(p93, p94) -- Line: 634
    if not p93.Animations[p94] then
        return;
    end;

    p93.Janitor:Remove("AnimationSoundConnections_" .. p94);
    p93.Janitor:RemoveNoClean("AnimationCleanup_" .. p94);

    if p93.Animations[p94] then
        local v95 = p93.Animations[p94];
        p93.Animations[p94] = nil;

        if v95.IsPlaying then
            v95:Stop();
        end;

        v95:Destroy();
    end;
end;

function u1.unregisterGroup(p96, ...) -- Line: 659
    for _, v in ipairs({ ... }) do
        p96:unregister(v);
    end;
end;

function u1.register(u97, u98, u99) -- Line: 667
    -- upvalues: connectTrackSoundEvents (copy)
    u97:unregister(u98);
    local success, result = pcall(function() -- Line: 671
        -- upvalues: u97 (copy), u99 (copy)
        return u97.Animator:LoadAnimation(u99);
    end);

    if success then
        u97.Animations[u98] = result;
        local u100 = setmetatable({}, {
            __mode = "v"
        });
        u100.instance = u97;
        u97.Janitor:Add(function() -- Line: 683
            -- upvalues: u100 (copy), u98 (copy)
            local instance = u100.instance;

            if instance and not instance.IsDestroyed then
                instance:unregister(u98);
            end;
        end, true, "AnimationCleanup_" .. u98);
        u97.Janitor:Add(connectTrackSoundEvents(u97, result, u98), true, "AnimationSoundConnections_" .. u98);
    end;
end;

function u1.construct(p101) -- Line: 695
    -- upvalues: GetWeaponProperties (copy)
    local v102 = GetWeaponProperties(p101.Animation);

    if not v102 then
        return;
    end;

    local CameraAnimations = v102.CameraAnimations;

    if typeof(CameraAnimations) ~= "Instance" or not CameraAnimations:IsA("Folder") then
        return;
    end;

    p101.VariantGroups = {};

    for _, child in ipairs(CameraAnimations:GetChildren()) do
        if child:IsA("Animation") then
            p101:register(child.Name, child);

            if p101.Animations[child.Name] then
                local Name = child.Name;
                local v103 = string.gsub(Name, "%d+$", "");

                if v103 == "" then
                    v103 = Name;
                end;

                local v104 = child:FindFirstChildWhichIsA("IntValue") or child:FindFirstChildWhichIsA("NumberValue");
                local v105 = p101.VariantGroups[v103];

                if not v105 then
                    v105 = {};
                    p101.VariantGroups[v103] = v105;
                end;

                local v106 = {
                    name = child.Name
                };
                local v107;

                if v104 then
                    v107 = v104.Value;
                else
                    v107 = nil;
                end;

                v106.weight = v107;
                table.insert(v105, v106);
            end;
        end;
    end;
end;

function u1.setModel(u108, p109) -- Line: 741
    -- upvalues: u2 (copy), LocalPlayer (copy)
    if not p109 then
        return;
    end;

    u108.Animation = p109.Name;
    u108.Animator = p109:WaitForChild("AnimationController"):WaitForChild("Animator");
    u108:stopAnimations();
    u108:construct();

    if u108.Animation == "C4" then
        local u110 = p109:FindFirstChild("Weapon") and p109.Weapon:FindFirstChild("Interactive");

        if u110 and u110:FindFirstChild("SurfaceGui") then
            u110.SurfaceGui.TextLabel.Text = "*******";
        end;

        for _, v in pairs(u108.Animations) do
            u108.Janitor:Add(v.KeyframeReached:Connect(function(p111) -- Line: 763
                -- upvalues: u2 (ref), u110 (copy), u108 (copy), LocalPlayer (ref)
                if table.find(u2, p111) then
                    if u110 and u110:FindFirstChild("SurfaceGui") then
                        u110.SurfaceGui.TextLabel.Text = string.rep("*", 7 - #p111) .. p111;
                    end;

                    u108.Sound:play({
                        Parent = LocalPlayer.PlayerGui,
                        Name = p111
                    });
                end;
            end));
        end;
    end;
end;

function u1.new(p112, p113, p114, p115) -- Line: 780
    -- upvalues: u1 (copy), Janitor (copy)
    local v116 = setmetatable({}, u1);
    v116.Janitor = Janitor.new();
    v116.IsDestroyed = false;
    v116.IsCrossfading = false;
    v116.CrossfadeConnection = nil;
    v116.CrossfadeTempTrack = nil;
    v116.Player = p113;
    v116.ActiveSounds = {};
    v116.Animations = {};
    v116.VariantGroups = {};
    v116.CurrentAnimation = nil;
    v116.Sound = p115;

    if p114 then
        v116:setModel(p114);
    end;

    return v116;
end;

function u1.destroy(p117) -- Line: 820
    if not p117.IsDestroyed then
        p117.IsDestroyed = true;
        p117:cancelCrossfade();
        p117:stopAnimations();
        local v118 = {};

        for i, _ in pairs(p117.Animations) do
            table.insert(v118, i);
        end;

        for _, v in ipairs(v118) do
            p117:unregister(v);
        end;

        p117:stopSounds();
        table.clear(p117.ActiveSounds);
        table.clear(p117.Animations);
        table.clear(p117.VariantGroups);
        p117.CurrentAnimation = nil;
        p117.Animation = nil;
        p117.Animator = nil;
        p117.Player = nil;
        p117.Sound = nil;
        p117.Janitor:Destroy();
        p117.Janitor = nil;
    end;
end;

return u1;