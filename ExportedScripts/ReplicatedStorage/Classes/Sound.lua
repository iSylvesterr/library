-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local DataController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("DataController"));
require(script:WaitForChild("Types"));
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local ObjectPool = require(ReplicatedStorage.Shared.ObjectPool);
local u2 = ReplicatedStorage:FindFirstChild("Sounds") or Instance.new("Folder", ReplicatedStorage);
u2.Name = "Sounds";
local Debris = workspace:WaitForChild("Debris");
local Part = Instance.new("Part");
Part.Size = Vector3.new(1, 1, 1);
Part.CanCollide = false;
Part.CanTouch = false;
Part.CanQuery = false;
Part.CastShadow = false;
Part.Anchored = true;
Part.Transparency = 1;
Part.Name = "Sound";
local u4 = ObjectPool.new(Part, {
    InitialSize = 8,
    MaxRetained = 32,

    Reset = function(p3) -- Line: 49, Name: Reset
        p3.CFrame = CFrame.identity;
    end
});
local u5 = {};
local u6 = 1;
local u7 = nil;

local function SelectSound(p8) -- Line: 73
    local v9 = p8:GetChildren();

    return v9[math.random(1, #v9)]:Clone();
end;

local function TranslateSoundPath(p10) -- Line: 82
    local v11 = string.split(p10, ".");
    local v12 = game;

    for i, v in ipairs(v11) do
        if v12 and i > 1 then
            if v12 == game then
                local success, result = pcall(function() -- Line: 90
                    -- upvalues: v (copy)
                    return game:GetService(v);
                end);
                v12 = success and result and result or v12:FindFirstChild(v);
            else
                v12 = v12:FindFirstChild(v);
            end;

            if not v12 then
                error((`Path: "{p10}" does not exist`));
            end;
        end;
    end;

    return v12;
end;

local function CreateSoundInstance(p13, p14, p15) -- Line: 112
    local Sound = Instance.new("Sound");
    Sound.RollOffMaxDistance = p15.RollOffMaxDistance or 10000;
    Sound.RollOffMinDistance = p15.RollOffMinDistance or 10;
    Sound.TimePosition = p15.TimePosition or 0;
    Sound.RollOffMode = Enum.RollOffMode.Inverse;
    Sound.Looped = p15.Looped or false;
    Sound.SoundId = `rbxassetid://{p14}`;
    Sound.Volume = p15.Volume or 0.5;
    Sound.Name = p13;
    local Pitch = p15.Pitch;

    if typeof(Pitch) == "number" and Pitch ~= 1 then
        local PitchShiftSoundEffect = Instance.new("PitchShiftSoundEffect");
        PitchShiftSoundEffect.Name = "PitchShift";
        PitchShiftSoundEffect.Octave = math.clamp(Pitch, 0.5, 2);
        PitchShiftSoundEffect.Parent = Sound;
    end;

    return Sound;
end;

local function GetMasterVolumeMultiplier() -- Line: 134
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v16 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100;

    return (tonumber(v16) or 100) / 100;
end;

local function ApplyTrackedVolume(p17, p18) -- Line: 139
    -- upvalues: u6 (ref)
    p17.Volume = p18.BaseVolume * u6 * p18.OtherMultiplier;
    p17:SetAttribute("MasterVolumeMultiplier", u6);
end;

local function EnsureMasterVolumeListener() -- Line: 144
    -- upvalues: u7 (ref), u6 (ref), DataController (copy), LocalPlayer (copy), u5 (copy)
    if u7 then
        return;
    end;

    local v19 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100;
    u6 = (tonumber(v19) or 100) / 100;
    u7 = DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", function(p20) -- Line: 150
        -- upvalues: u6 (ref), u5 (ref)
        u6 = (tonumber(p20) or 100) / 100;

        for i, v in pairs(u5) do
            if i.Parent then
                i.Volume = v.BaseVolume * u6 * v.OtherMultiplier;
                i:SetAttribute("MasterVolumeMultiplier", u6);
            else
                u5[i] = nil;
            end;
        end;
    end);
end;

local function TrackMasterVolume(u21, p22, p23) -- Line: 163
    -- upvalues: u7 (ref), u6 (ref), DataController (copy), LocalPlayer (copy), u5 (copy)
    local v24 = p23 or 1;
    local v25 = {
        BaseVolume = p22,
        OtherMultiplier = v24
    };

    if not u7 then
        local v26 = DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100;
        u6 = (tonumber(v26) or 100) / 100;
        u7 = DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", function(p27) -- Line: 150
            -- upvalues: u6 (ref), u5 (ref)
            u6 = (tonumber(p27) or 100) / 100;

            for i, v in pairs(u5) do
                if i.Parent then
                    i.Volume = v.BaseVolume * u6 * v.OtherMultiplier;
                    i:SetAttribute("MasterVolumeMultiplier", u6);
                else
                    u5[i] = nil;
                end;
            end;
        end);
    end;

    u5[u21] = v25;
    u21:SetAttribute("BaseVolume", p22);
    u21:SetAttribute("OtherVolumeMultiplier", v24);
    u21.Volume = v25.BaseVolume * u6 * v25.OtherMultiplier;
    u21:SetAttribute("MasterVolumeMultiplier", u6);
    u21.Destroying:Once(function() -- Line: 177
        -- upvalues: u5 (ref), u21 (copy)
        u5[u21] = nil;
    end);
end;

function u1.play(p28, p29, p30) -- Line: 185
    -- upvalues: HttpService (copy), TranslateSoundPath (copy), TrackMasterVolume (copy)
    local v31 = p29.Parent or p29.Path;
    local v32 = `Sound couldn't locate sound parent for {p29.Name}`;
    assert(v31, v32);

    if not p28.Sounds then
        return nil;
    end;

    local v33 = p28.Sounds:FindFirstChild(p29.Name);

    if v33 then
        local v34 = HttpService:GenerateGUID(false);
        local Parent = p29.Parent;

        if p29.Path and not Parent then
            Parent = TranslateSoundPath(p29.Path);
        end;

        if not Parent then
            return nil;
        end;

        local v35 = v33:GetChildren();
        local u36 = v35[math.random(1, #v35)]:Clone();
        u36.Parent = Parent;
        u36.Name = v34;
        TrackMasterVolume(u36, u36.Volume, p30);
        u36:Play();
        u36.Ended:Once(function() -- Line: 218
            -- upvalues: u36 (copy)
            u36:Destroy();
        end);

        return u36;
    end;
end;

function u1.playOneTime(p37, p38, p39) -- Line: 232
    return p37:play(p38, p39 or 1);
end;

function u1.PlaySoundAtPosition(u40, p41, p42, p43, p44, p45) -- Line: 238
    -- upvalues: u4 (copy), Debris (copy), SelectSound (copy), HttpService (copy), TrackMasterVolume (copy)
    if u40.IsDestroyed then
        return;
    end;

    if not u40.Sounds then
        u40:destroy();

        return;
    end;

    local v46 = u40.Sounds:FindFirstChild(p41.Name);

    if not v46 then
        u40:destroy();

        return;
    end;

    local u47, u48 = u4:Acquire();
    u40.Janitor:Add(function() -- Line: 268
        -- upvalues: u4 (ref), u47 (copy), u48 (copy)
        u4:Release(u47, u48);
    end);
    u47.Position = p41.Position;
    u47.CollisionGroup = "Debris";
    u47.Parent = Debris;
    local u49 = u40.Janitor:Add(SelectSound(v46));
    local Volume = u49.Volume;
    u49.Name = HttpService:GenerateGUID(false);
    u49.Parent = u47;

    if (p41.Name == "Headshot" and true or p41.Name == "Helmet Headshot") and p44 then
        u49.RollOffMode = Enum.RollOffMode.InverseTapered;
        u49.RollOffMaxDistance = 10000;
        u49.RollOffMinDistance = 10000;

        if p45 then
            Volume = Volume * 0;
        end;
    end;

    TrackMasterVolume(u49, Volume, p43);
    u49:Play();

    if u49.Looped and p42 then
        u40.Janitor:Add(task.delay(p42, function() -- Line: 302
            -- upvalues: u40 (copy)
            u40:destroy();
        end), true);
    else
        u40.Janitor:Add(u49.Ended:Once(function() -- Line: 309
            -- upvalues: u40 (copy)
            u40:destroy();
        end));
    end;

    u40.Janitor:Add(u49.AncestryChanged:Connect(function() -- Line: 315
        -- upvalues: u49 (copy), u40 (copy)
        if not u49.Parent then
            u40:destroy();
        end;
    end));
end;

function u1.createSoundGroup(p50) -- Line: 325
    -- upvalues: u2 (ref), CreateSoundInstance (copy)
    local v51 = require(p50);
    local Folder = Instance.new("Folder", u2);
    Folder.Name = p50.Name;

    for i, v in pairs(v51) do
        local Folder2 = Instance.new("Folder", Folder);
        Folder2.Name = i;

        for i2, v2 in ipairs(v.Identifiers) do
            CreateSoundInstance(i2, v2, v.Properties).Parent = Folder2;
        end;
    end;
end;

function u1.new(p52) -- Line: 347
    -- upvalues: u1 (copy), Janitor (copy), u2 (ref)
    local v53 = setmetatable({}, u1);
    v53.Janitor = Janitor.new();
    v53.IsDestroyed = false;
    v53.SoundGroupName = p52;
    v53.Sounds = u2:WaitForChild(p52, 10);

    return v53;
end;

function u1.destroy(p54) -- Line: 367
    if not p54.IsDestroyed then
        p54.IsDestroyed = true;
        p54.Janitor:Destroy();
        p54.SoundGroupName = nil;
        p54.Janitor = nil;
        p54.Sounds = nil;
    end;
end;

return u1;