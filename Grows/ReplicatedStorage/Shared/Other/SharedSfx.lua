-- Decompiled with Potassium's decompiler.

local v1 = {};
game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local Packages = ReplicatedStorage:WaitForChild("Packages");
local Maid = require(Packages:WaitForChild("Maid"));
local SoundEffects = SoundService:WaitForChild("SoundEffects");
local u2 = Random.new();
local u3 = {};

local function setupDestroyedSoundSource() -- Line: 24
    -- upvalues: u3 (copy)
    game.Workspace.DescendantRemoving:Connect(function(p4) -- Line: 25
        -- upvalues: u3 (ref)
        if u3[p4] then
            for _, v in u3[p4] do
                v:Destroy();
            end;

            u3[p4] = nil;
        end;
    end);
end;

game.Workspace.DescendantRemoving:Connect(function(p5) -- Line: 25
    -- upvalues: u3 (copy)
    if u3[p5] then
        for _, v in u3[p5] do
            v:Destroy();
        end;

        u3[p5] = nil;
    end;
end);

local function processPossibleRange(p6) -- Line: 36
    -- upvalues: u2 (copy)
    if typeof(p6) == "number" then
        return p6;
    end;

    if typeof(p6) == "NumberRange" then
        return u2:NextNumber(p6.Min, p6.Max);
    end;

    error("invalid property value");
end;

function v1.PlaySFX(p7, p8, u9, p10) -- Line: 46
    -- upvalues: SoundService (copy), u2 (copy), u3 (copy), SoundEffects (copy), Maid (copy)
    local v11 = p10 or {};

    if typeof(p8) == "string" then
        local v12 = p8;
        p8 = SoundService:FindFirstChild(v12, true);

        if not p8 then
            warn("Cannot find sound effect ", v12);

            return;
        end;
    end;

    local u13;

    if p8:IsA("Folder") then
        u13 = p8.Name;
        local v14 = p8:GetChildren();
        p8 = v14[u2:NextInteger(1, #v14)];
    else
        u13 = p8.Name;

        if string.find(p8.Name, "Charge") then
            u13 = "Charge";
        end;
    end;

    if u3[u9] and u3[u9][u13] then
        if p8.Looped or v11.Looped then
            return;
        end;

        u3[u9][u13]:Destroy();
    end;

    local u15 = p8:Clone();

    if v11.Volume then
        local Volume = v11.Volume;

        if typeof(Volume) ~= "number" then
            if typeof(Volume) == "NumberRange" then
                Volume = u2:NextNumber(Volume.Min, Volume.Max);
            else
                error("invalid property value");
                Volume = nil;
            end;
        end;

        u15.Volume = Volume;
    end;

    if v11.PlaybackSpeed then
        local PlaybackSpeed = v11.PlaybackSpeed;

        if typeof(PlaybackSpeed) ~= "number" then
            if typeof(PlaybackSpeed) == "NumberRange" then
                PlaybackSpeed = u2:NextNumber(PlaybackSpeed.Min, PlaybackSpeed.Max);
            else
                error("invalid property value");
                PlaybackSpeed = nil;
            end;
        end;

        u15.PlaybackSpeed = PlaybackSpeed;
    end;

    if v11.Looped then
        u15.Looped = v11.Looped;
    end;

    if v11.RollOffMaxDistance then
        u15.RollOffMaxDistance = v11.RollOffMaxDistance;
    end;

    if v11.RollOffMinDistance then
        u15.RollOffMinDistance = v11.RollOffMinDistance;
    end;

    if v11.RollOffMode then
        u15.RollOffMode = v11.RollOffMode;
    end;

    if not u15.SoundGroup then
        u15.SoundGroup = SoundEffects;
    end;

    u15.Parent = u9;

    if not u15.PlayOnRemove then
        u15:Play();

        if not u3[u9] then
            u3[u9] = {};
        end;

        local u16 = Maid.new();
        u3[u9][u13] = u16;
        u16:GiveTask(function() -- Line: 120
            -- upvalues: u15 (ref), u9 (copy), u3 (ref), u13 (ref)
            if u15 then
                u15:Stop();
                u15.PlayOnRemove = false;
                u15:Destroy();
            end;

            if u9 and u3[u9] then
                u3[u9][u13] = nil;
            end;
        end);
        u16:GiveTask(u15.Ended:Connect(function() -- Line: 131
            -- upvalues: u15 (ref), u16 (copy)
            if not u15.Looped and u16 then
                u16:Destroy();
            end;
        end));

        return u13;
    end;

    u15:Destroy();
end;

function v1.StopSFX(p17, p18, p19) -- Line: 141
    -- upvalues: u3 (copy)
    if u3[p19] and u3[p19][p18] then
        u3[p19][p18]:Destroy();
    end;
end;

function v1.StopSFXFromParent(p20, p21) -- Line: 147
    -- upvalues: u3 (copy)
    if u3[p21] then
        for _, v in u3[p21] do
            v:Destroy();
        end;

        u3[p21] = nil;
    end;
end;

function v1.GetSoundObject(p22, p23, p24) -- Line: 156
    if not p24 then
        return nil;
    end;

    for _, child in pairs(p24:GetChildren()) do
        if child:IsA("Sound") and child.Name == p23 then
            return child;
        end;
    end;

    return nil;
end;

return v1;