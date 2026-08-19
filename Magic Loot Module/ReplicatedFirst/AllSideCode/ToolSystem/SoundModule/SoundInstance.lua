-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local ResRestore = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).ResRestore;
local u1 = {};
u1.__index = u1;
local u2 = {};
local u3 = 0;
local u4 = {};
local u5 = nil;
local u6 = nil;
local u7 = false;

local function _ensureClientReady() -- Line: 46
    -- upvalues: RunService (copy), u7 (ref), u5 (ref), ReplicatedStorage (copy), u6 (ref), Workspace (copy), SoundService (copy)
    if not RunService:IsClient() then
        warn("SoundInstance 仅客户端可用");

        return false;
    end;

    if u7 then
        return true;
    end;

    u5 = Instance.new("Folder");
    u5.Name = "Sound2D";
    u5.Parent = ReplicatedStorage;
    u6 = Instance.new("Folder");
    u6.Name = "Sound3D";
    u6.Parent = Workspace;

    for _, child in SoundService:GetChildren() do
        if child:IsA("SoundGroup") then
            for _, child2 in child:GetChildren() do
                if child2:IsA("Sound") then
                    child2.SoundGroup = child;
                end;
            end;
        end;
    end;

    u7 = true;

    return true;
end;

local function _cloneSound(p8) -- Line: 83
    -- upvalues: u4 (copy), SoundService (copy), ResRestore (copy)
    local v9 = u4[p8];

    if not (v9 and v9.Parent) then
        v9 = nil;

        for _, descendant in SoundService:GetDescendants() do
            if descendant:IsA("Sound") and descendant.Name == p8 then
                u4[p8] = descendant;
                v9 = descendant;
                break;
            end;
        end;
    end;

    if not v9 then
        return nil;
    end;

    ResRestore.Restore(v9);

    return v9:Clone();
end;

local function _cancelActiveTween(p10) -- Line: 108
    if p10._activeTween then
        p10._activeTween:Cancel();
        p10._activeTween = nil;
    end;
end;

function u1.new(p11, p12) -- Line: 124
    -- upvalues: _ensureClientReady (copy), u3 (ref), u1 (copy), _cloneSound (copy), u5 (ref), u6 (ref), u2 (copy)
    if not _ensureClientReady() then
        return nil;
    end;

    local SoundName = p12.SoundName;

    if not SoundName then
        return nil;
    end;

    local SoundTag = p12.SoundTag;

    if not SoundTag then
        SoundTag = SoundName .. tostring(u3);
        u3 = u3 + 1;
    end;

    local v13 = u1:GetSoundByTag(SoundTag);

    if v13 then
        return v13;
    end;

    local v14 = _cloneSound(SoundName);

    if not v14 then
        warn(SoundName, "Sound 文件未找到，无法播放音效");

        return nil;
    end;

    local v15 = p12.Is2D == nil and true or p12.Is2D;
    local AttachPart = p12.AttachPart;
    local PlayPosition = p12.PlayPosition;
    local v16 = setmetatable({}, u1);
    v16.sound = v14;
    local v17;

    if p12.Volume then
        v17 = p12.Volume;
    else
        v17 = v14.Volume;
    end;

    v16.oriVolume = v17;
    v16.sound.Volume = v16.oriVolume;
    v16.soundName = SoundName;
    v16.soundTag = SoundTag;
    v16.oriPlaySpeed = v14.PlaybackSpeed;
    v16.playSpeed = v16.oriPlaySpeed;
    v16.is2D = v15;
    v16.playPosition = PlayPosition;
    v16.parentPart = nil;
    v16._activeTween = nil;

    if v15 then
        v14.Parent = u5;
    else
        local Part = Instance.new("Part");
        Part.Name = SoundName;

        if PlayPosition then
            Part.Position = PlayPosition;
        end;

        Part.Transparency = 1;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.Anchored = true;
        Part.Massless = true;
        Part.Parent = u6;
        v14.Parent = Part;
        v16.parentPart = Part;

        if AttachPart then
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = Part;
            WeldConstraint.Part1 = AttachPart;
            WeldConstraint.Parent = Part;
            Part.Anchored = false;
        end;
    end;

    v14:SetAttribute("SoundTag", SoundTag);
    u2[SoundTag] = v16;

    return v16;
end;

function u1.playSound(u18, p19) -- Line: 204
    -- upvalues: TweenService (copy)
    if not u18.sound then
        return;
    end;

    if u18._activeTween then
        u18._activeTween:Cancel();
        u18._activeTween = nil;
    end;

    u18.sound.Volume = 0;
    u18.sound:Play();
    local v20 = TweenService:Create(u18.sound, TweenInfo.new(p19 or 0.1), {
        Volume = u18.oriVolume
    });
    u18._activeTween = v20;
    v20:Play();

    if not u18.sound.Looped then
        u18.sound.Ended:Once(function() -- Line: 224
            -- upvalues: u18 (copy)
            u18:destroy();
        end);
    end;
end;

function u1.stopSound(u21, p22, u23) -- Line: 235
    -- upvalues: TweenService (copy)
    if not u21.sound then
        return;
    end;

    if u23 == nil then
        u23 = not u21.sound.Looped;
    end;

    if u21._activeTween then
        u21._activeTween:Cancel();
        u21._activeTween = nil;
    end;

    local v24 = TweenService:Create(u21.sound, TweenInfo.new(p22 or 0.1), {
        Volume = 0
    });
    u21._activeTween = v24;
    v24.Completed:Once(function() -- Line: 253
        -- upvalues: u21 (copy), u23 (ref)
        u21._activeTween = nil;

        if u21.sound then
            u21.sound:Stop();
        end;

        if u23 then
            u21:destroy();
        end;
    end);
    v24:Play();
end;

function u1.destroy(p25) -- Line: 268
    -- upvalues: u2 (copy)
    if p25._activeTween then
        p25._activeTween:Cancel();
        p25._activeTween = nil;
    end;

    if p25.sound then
        p25.sound:Stop();
        p25.sound:Destroy();
        p25.sound = nil;
    end;

    if p25.parentPart then
        p25.parentPart:Destroy();
        p25.parentPart = nil;
    end;

    if p25.soundTag then
        u2[p25.soundTag] = nil;
    end;
end;

function u1.destroySound(p26) -- Line: 288
    p26:destroy();
end;

function u1.setPlaySpeed(p27, p28) -- Line: 296
    if not p27.sound then
        return;
    end;

    p27.playSpeed = p28;
    p27.sound.PlaybackSpeed = p28;
end;

function u1.GetSoundByTag(p29, p30) -- Line: 313
    -- upvalues: u2 (copy)
    if p30 then
        return u2[p30];
    end;

    return nil;
end;

function u1.GetSoundByName(p31, p32) -- Line: 325
    -- upvalues: u2 (copy)
    local v33 = {};

    if not p32 then
        return v33;
    end;

    for _, v in u2 do
        if v.soundName == p32 then
            table.insert(v33, v);
        end;
    end;

    return v33;
end;

function u1.SetSoundGroupVolume(p34, p35, p36, p37) -- Line: 345
    -- upvalues: SoundService (copy), TweenService (copy)
    local v38 = p37 or 0;
    local v39 = SoundService:FindFirstChild(p35);

    if not (v39 and v39:IsA("SoundGroup")) then
        return;
    end;

    if v38 <= 0 then
        v39.Volume = p36;

        return;
    end;

    TweenService:Create(v39, TweenInfo.new(v38), {
        Volume = p36
    }):Play();
end;

function u1.SetSoundGroupPlaySpeed(p40, p41, p42) -- Line: 370
    -- upvalues: SoundService (copy), u2 (copy)
    local v43 = p42 or 1;
    local v44 = SoundService:FindFirstChild(p41);

    if not (v44 and v44:IsA("SoundGroup")) then
        return;
    end;

    for _, v in u2 do
        if v.sound and v.sound.SoundGroup == v44 then
            v:setPlaySpeed(v.oriPlaySpeed * v43);
        end;
    end;

    v44:SetAttribute("PlaySpeed", v43);
end;

return u1;