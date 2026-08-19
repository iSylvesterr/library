-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Audio = require(ReplicatedStorage.Library.Audio);
local u1 = {};

local function getScaleMultiplier(p2, p3, p4) -- Line: 23
    local v5 = 1;
    local v6;

    if p4 then
        v6 = p4.weight;
    else
        v6 = nil;
    end;

    local v7;

    if p4 then
        v7 = p4.baseWeight;
    else
        v7 = nil;
    end;

    if p3 == "WalkSound" and (typeof(v6) == "number" and (typeof(v7) == "number" and v7 > 0)) then
        return math.max(v6 / v7, 0.001);
    end;

    if p4 and typeof(p4.baseModelScale) == "number" then
        v5 = p4.baseModelScale;
    end;

    local v8 = p2:GetScale() / (v5 <= 0 and 1 or v5);

    return math.max(v8, 0.001);
end;

local function applyScaledProperty(p9, p10, p11, p12) -- Line: 45
    if typeof(p9) == "number" then
        return p9 * math.clamp(p10, p11, p12);
    end;

    return nil;
end;

local function parseMutationsAttribute(p13) -- Line: 59
    local v14 = {};

    if typeof(p13) ~= "string" or p13 == "" then
        return v14;
    end;

    for i in string.gmatch(p13, "[^,]+") do
        local v15 = i:gsub("^%s*(.-)%s*$", "%1");

        if v15 ~= "" then
            table.insert(v14, v15);
        end;
    end;

    return v14;
end;

local function ensureFrozenSoundEffect(p16, p17) -- Line: 75
    local FrozenMutationReverb = p16:FindFirstChild("FrozenMutationReverb");

    if not p17 then
        if FrozenMutationReverb then
            FrozenMutationReverb:Destroy();
        end;

        return;
    end;

    if FrozenMutationReverb and FrozenMutationReverb:IsA("ReverbSoundEffect") then
        return;
    end;

    if FrozenMutationReverb then
        FrozenMutationReverb:Destroy();
    end;

    local ReverbSoundEffect = Instance.new("ReverbSoundEffect");
    ReverbSoundEffect.Name = "FrozenMutationReverb";
    ReverbSoundEffect.Parent = p16;
end;

local function hasMutation(p18, p19, p20) -- Line: 97
    if p19 == p20 then
        return true;
    end;

    if typeof(p18) == "table" then
        return table.find(p18, p20) ~= nil;
    end;

    return false;
end;

local function getStoredBasePlaybackSpeed(p21) -- Line: 109
    local v22 = p21:GetAttribute("AssetSoundUtilBasePlaybackSpeed");

    if typeof(v22) == "number" and v22 > 0 then
        return v22;
    end;

    local PlaybackSpeed = p21.PlaybackSpeed;
    local v23 = PlaybackSpeed <= 0 and 1 or PlaybackSpeed;
    p21:SetAttribute("AssetSoundUtilBasePlaybackSpeed", v23);

    return v23;
end;

local function getMutationPlaybackSpeedMultiplier(p24, p25) -- Line: 124
    local v26;

    if p25 == "Shocked" then
        v26 = true;
    elseif typeof(p24) == "table" then
        v26 = table.find(p24, "Shocked") ~= nil;
    else
        v26 = false;
    end;

    return v26 and 2 or 1;
end;

local function multiplyPlaybackSpeed(p27, p28) -- Line: 132
    if type(p27) == "number" then
        return p27 * p28;
    end;

    if type(p27) ~= "table" then
        return p28;
    end;

    local v29 = table.clone(p27);

    for i, v in ipairs(p27) do
        v29[i] = v * p28;
    end;

    return v29;
end;

local function syncMutationPlaybackSpeed(p30, p31, p32) -- Line: 148
    local v33 = p30:GetAttribute("AssetSoundUtilBasePlaybackSpeed");

    if typeof(v33) ~= "number" or v33 <= 0 then
        local PlaybackSpeed = p30.PlaybackSpeed;
        v33 = PlaybackSpeed <= 0 and 1 or PlaybackSpeed;
        p30:SetAttribute("AssetSoundUtilBasePlaybackSpeed", v33);
    end;

    local v34;

    if p32 == "Shocked" then
        v34 = true;
    elseif typeof(p31) == "table" then
        v34 = table.find(p31, "Shocked") ~= nil;
    else
        v34 = false;
    end;

    local v35 = v33 * (v34 and 2 or 1);

    if math.abs(p30.PlaybackSpeed - v35) > 0.001 then
        p30.PlaybackSpeed = v35;
    end;
end;

function u1.CreateConfiguredSound(p36, p37, p38, p39, p40) -- Line: 156
    -- upvalues: Audio (copy), getScaleMultiplier (copy)
    if not p38 then
        return nil;
    end;

    local Sound = Instance.new("Sound");
    Sound.Name = p39;
    Audio.PrepareSoundFromSoundFile(Sound, p38);
    Sound.RollOffMaxDistance = 40;
    local v41 = getScaleMultiplier(p37, p39, p40);
    local Volume = Sound.Volume;

    if Volume > 0 then
        local _ = p39 == "WalkSound";
        local v42 = 1;
        local v43 = p39 == "WalkSound" and 3.5 or 3;
        local v44;

        if typeof(Volume) == "number" then
            v44 = Volume * math.clamp(v41, v42, v43);
        else
            v44 = nil;
        end;

        if v44 then
            Sound.Volume = v44;
        end;
    end;

    local RollOffMaxDistance = Sound.RollOffMaxDistance;

    if typeof(RollOffMaxDistance) == "number" and RollOffMaxDistance > 0 then
        local _ = p39 == "WalkSound";
        local v45 = 0.7;
        local _ = p39 == "WalkSound";
        local v46 = 1.2;
        local v47;

        if typeof(RollOffMaxDistance) == "number" then
            v47 = RollOffMaxDistance * math.clamp(v41, v45, v46);
        else
            v47 = nil;
        end;

        if v47 then
            Sound.RollOffMaxDistance = v47;
        end;
    end;

    Sound.Parent = p36;

    return Sound;
end;

function u1.ParseMutationsAttribute(p48) -- Line: 201
    -- upvalues: parseMutationsAttribute (copy)
    return parseMutationsAttribute(p48);
end;

function u1.GetMutationStateFromAttributes(p49, p50, p51) -- Line: 205
    -- upvalues: parseMutationsAttribute (copy)
    local v52 = parseMutationsAttribute(p49:GetAttribute(p50 or "Mutations"));
    local v53 = p49:GetAttribute(p51 or "BaseMutation");

    if typeof(v53) ~= "string" or v53 == "" then
        v53 = nil;
    end;

    return v52, v53;
end;

function u1.HasFrozenMutation(p54, p55) -- Line: 221
    if p55 == "Frozen" then
        return true;
    end;

    if typeof(p54) == "table" then
        return table.find(p54, "Frozen") ~= nil;
    end;

    return false;
end;

function u1.HasShockedMutation(p56, p57) -- Line: 225
    if p57 == "Shocked" then
        return true;
    end;

    if typeof(p56) == "table" then
        return table.find(p56, "Shocked") ~= nil;
    end;

    return false;
end;

function u1.GetMutationPlaybackSpeedMultiplier(p58, p59) -- Line: 229
    local v60;

    if p59 == "Shocked" then
        v60 = true;
    elseif typeof(p58) == "table" then
        v60 = table.find(p58, "Shocked") ~= nil;
    else
        v60 = false;
    end;

    return v60 and 2 or 1;
end;

function u1.SetBasePlaybackSpeed(p61, p62) -- Line: 233
    if not p61 then
        return;
    end;

    if typeof(p62) == "number" and p62 > 0 then
        p61:SetAttribute("AssetSoundUtilBasePlaybackSpeed", p62);

        return;
    end;

    p61:SetAttribute("AssetSoundUtilBasePlaybackSpeed", nil);
end;

function u1.CloneSoundFileWithMutationPlaybackSpeed(p63, p64, p65) -- Line: 246
    -- upvalues: multiplyPlaybackSpeed (copy)
    local v66;

    if p65 == "Shocked" then
        v66 = true;
    elseif typeof(p64) == "table" then
        v66 = table.find(p64, "Shocked") ~= nil;
    else
        v66 = false;
    end;

    local v67 = v66 and 2 or 1;

    if v67 == 1 then
        return p63;
    end;

    local v68 = table.clone(p63);
    local v69 = not p63.Data and {} or table.clone(p63.Data);
    v69.Speed = multiplyPlaybackSpeed(v69.Speed, v67);
    v68.Data = v69;

    return v68;
end;

function u1.BuildPlaybackEffectChildren(p70, p71, p72) -- Line: 263
    -- upvalues: u1 (copy)
    local v73 = not p70 and {} or table.clone(p70);

    if u1.HasFrozenMutation(p71, p72) then
        local ReverbSoundEffect = Instance.new("ReverbSoundEffect");
        ReverbSoundEffect.Name = "FrozenMutationReverb";
        table.insert(v73, ReverbSoundEffect);
    end;

    if #v73 == 0 then
        return p70;
    end;

    return v73;
end;

function u1.ParentPlaybackEffectChildren(p74, p75) -- Line: 283
    if not p74 then
        return nil;
    end;

    for _, v in ipairs(p74) do
        v.Parent = p75;
    end;

    return p74;
end;

function u1.SyncPlaybackEffectsFromMutations(p76, p77, p78) -- Line: 295
    -- upvalues: ensureFrozenSoundEffect (copy), u1 (copy)
    if not p76 then
        return;
    end;

    ensureFrozenSoundEffect(p76, u1.HasFrozenMutation(p77, p78));
    local v79 = p76:GetAttribute("AssetSoundUtilBasePlaybackSpeed");

    if typeof(v79) ~= "number" or v79 <= 0 then
        local PlaybackSpeed = p76.PlaybackSpeed;
        v79 = PlaybackSpeed <= 0 and 1 or PlaybackSpeed;
        p76:SetAttribute("AssetSoundUtilBasePlaybackSpeed", v79);
    end;

    local v80;

    if p78 == "Shocked" then
        v80 = true;
    elseif typeof(p77) == "table" then
        v80 = table.find(p77, "Shocked") ~= nil;
    else
        v80 = false;
    end;

    local v81 = v79 * (v80 and 2 or 1);

    if math.abs(p76.PlaybackSpeed - v81) > 0.001 then
        p76.PlaybackSpeed = v81;
    end;
end;

function u1.SyncPlaybackEffectsFromAttributes(p82, p83, p84, p85) -- Line: 304
    -- upvalues: u1 (copy)
    local v86, v87 = u1.GetMutationStateFromAttributes(p83, p84, p85);
    u1.SyncPlaybackEffectsFromMutations(p82, v86, v87);
end;

function u1.PlayWalkSound(p88) -- Line: 315
    if not p88 then
        return;
    end;

    if p88.IsPlaying then
        return;
    end;

    p88.TimePosition = 0;
    p88.Looped = true;
    p88:Play();
end;

function u1.StopWalkSound(p89) -- Line: 327
    if not p89 then
        return;
    end;

    if not p89.IsPlaying then
        return;
    end;

    p89:Stop();
end;

function u1.PlayJumpSound(p90) -- Line: 337
    if not p90 then
        return;
    end;

    p90.TimePosition = 0;
    p90.Looped = false;
    p90:Play();
end;

return u1;