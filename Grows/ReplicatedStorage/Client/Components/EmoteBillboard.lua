-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("CollectionService");
local TweenService = game:GetService("TweenService");
local Emotes = game:GetService("SoundService"):WaitForChild("SoundEffects"):WaitForChild("Emotes");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Component = require(ReplicatedStorage.Packages.Component);
local Maid = require(ReplicatedStorage.Packages.Maid);
require(ReplicatedStorage.Shared.Info.Constants);
local EmotesInfo = require(ReplicatedStorage.Shared.Info.EmotesInfo);
local LocalPlayer = Players.LocalPlayer;
local v1 = Component.new({
    Tag = "EmoteBillboard"
});

function v1.PrepImages(p2) -- Line: 23
    p2.freeSlots = {};
    p2.template = p2.Instance:WaitForChild("EmoteTemplate");

    for _ = 1, 5 do
        local v3 = p2.template:Clone();
        v3.Parent = p2.Instance;
        table.insert(p2.freeSlots, v3);
    end;
end;

function v1.PlayEmote(u4, u5) -- Line: 35
    -- upvalues: EmotesInfo (copy), TweenService (copy)
    if u4.freeSlots and #u4.freeSlots < 1 then
        table.insert(u4.emoteQueue, u5);

        return;
    end;

    task.spawn(function() -- Line: 41
        -- upvalues: u4 (copy), EmotesInfo (ref), u5 (copy), TweenService (ref)
        local v6 = table.remove(u4.freeSlots, 1);
        local v7 = EmotesInfo.Emotes[u5];

        if u4.sounds[u5].IsPlaying == false then
            u4.sounds[u5].PlaybackSpeed = u4.RNG:NextNumber(0.9, 1.1);
            u4.sounds[u5]:Play();
        end;

        v6.EmoteIcon.Image = v7.image;
        v6.Position = u4.template.Position + UDim2.fromScale(u4.RNG:NextNumber(-0.1, 0.1), 0);
        v6.EmoteIcon.Size = UDim2.fromScale(0, 0);
        v6.Visible = true;
        TweenService:Create(v6.EmoteIcon, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = u4.template.Size
        }):Play();
        TweenService:Create(v6, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = u4.template.Position + UDim2.fromScale(0, -0.6)
        }):Play();
        task.wait(0.4);
        TweenService:Create(v6.EmoteIcon, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.fromScale(0, 0)
        }):Play();
        task.wait(0.5);
        v6.Visible = false;

        if not u4.freeSlots then
            return;
        end;

        table.insert(u4.freeSlots, v6);

        if #u4.emoteQueue > 0 then
            u4:PlayEmote((table.remove(u4.emoteQueue, 1)));
        end;
    end);
end;

function v1.PrepSfx(p8) -- Line: 93
    -- upvalues: EmotesInfo (copy), Emotes (copy)
    local Parent = p8.Instance.Parent;
    p8.sounds = {};

    for i, _ in EmotesInfo.Emotes do
        local v9 = Emotes:WaitForChild(i):Clone();
        v9.PlayOnRemove = false;
        v9.Parent = Parent;
        p8.sounds[i] = v9;
    end;
end;

function v1.Start(u10) -- Line: 106
    -- upvalues: Knit (copy), Maid (copy), LocalPlayer (copy)
    Knit.OnStart():await();
    u10.SideMenus = Knit.GetController("SideMenus");
    u10.EmoteService = Knit.GetService("EmoteService");
    u10._maid = Maid.new();
    u10.playerID = u10.Instance:GetAttribute("PlayerID");
    u10.isLocal = u10.playerID == LocalPlayer.UserId;
    u10.RNG = Random.new();
    u10.emoteQueue = {};
    u10:PrepImages();
    u10:PrepSfx();

    if u10.isLocal then
        u10._maid:GiveTask(u10.SideMenus.playEmoteLocal:Connect(function(p11) -- Line: 123
            -- upvalues: u10 (copy)
            u10:PlayEmote(p11);
        end));
    else
        u10._maid:GiveTask(u10.EmoteService.playClientEmotes:Connect(function(p12) -- Line: 127
            -- upvalues: u10 (copy)
            local v13 = p12[tostring(u10.playerID)];

            if not v13 then
                return;
            end;

            for _, v in v13 do
                table.insert(u10.emoteQueue, v);
            end;

            if #u10.emoteQueue > 0 then
                u10:PlayEmote((table.remove(u10.emoteQueue, 1)));
            end;
        end));
    end;

    u10._maid:GiveTask(function() -- Line: 143
        -- upvalues: u10 (copy)
        u10.freeSlots = nil;
        u10.usedSlots = nil;
    end);
end;

function v1.Stop(p14) -- Line: 149
    if p14._maid then
        p14._maid:Destroy();
    end;
end;

return v1;