-- Decompiled with Potassium's decompiler.

local Utility = script.Parent.Parent.Utility;
require(script.Parent.Parent.Types);
local SimpleSignal = require(Utility.SimpleSignal);
require(Utility.Preload);
local Switch = require(Utility.Switch);
local RandomWeighted = require(Utility.RandomWeighted);

local function isAction(p1) -- Line: 13
    return p1.Priority.Name:find("Action") ~= nil;
end;

local v2 = {};
local u3 = {
    __index = v2
};

function v2.SetCoreActive(p4, p5) -- Line: 26
    p4._active = p5;
end;

function v2.GetCoreActive(p6) -- Line: 34
    return p6._active;
end;

function v2.GetCurrentTrack(p7) -- Line: 42
    return p7._track;
end;

function v2.GetPose(p8) -- Line: 50
    return p8._lastPose;
end;

function v2.SetPoseEnabled(p9, p10, p11) -- Line: 59
    p9._disabled[p10] = not p11;
end;

function v2.GetCoreAnimInfos(p12, p13) -- Line: 68
    return p12._anims[p13];
end;

function v2.ChangeCoreAnim(p14, p15, p16, p17) -- Line: 82
    local v18 = nil;

    if type(p17) == "table" then
        p14._anims[p15][p16] = p17;
    elseif type(p17) == "string" then
        local Animation = Instance.new("Animation");
        Animation.AnimationId = p17;
        v18 = p14._animator:LoadAnimation(Animation);
        v18.Name = "core";
        v18.Looped = true;
        v18.Priority = Enum.AnimationPriority.Core;
        p14._anims[p15][p16].anim = v18;
    elseif typeof(p17) == "Instance" and p17:IsA("Animation") then
        v18 = p14._animator:LoadAnimation(p17);
        v18.Name = "core";
        v18.Looped = true;
        v18.Priority = Enum.AnimationPriority.Core;
        p14._anims[p15][p16].anim = v18;
    elseif typeof(p17) == "Instance" and p17:IsA("AnimationTrack") then
        p14._anims[p15][p16].anim = p17;
        v18 = p17;
    else
        error((`Invalid value for :ChangeCoreAnim ({p17})`));
    end;

    if p14._lastPose == p15 then
        p14._track:Stop();
        p14:PlayAnimation(p15);
    end;

    return v18;
end;

function v2.GetRandomCoreAnim(p19, p20) -- Line: 131
    -- upvalues: RandomWeighted (copy)
    return RandomWeighted(p19._anims[p20]);
end;

function v2.StopCore(p21, p22) -- Line: 140
    if not p21._animator then
        return;
    end;

    for _, v in p21._animator:GetPlayingAnimationTracks() do
        if v.Priority.Name:find("Action") == nil or v.Name == "emote" then
            v:Stop(p22);
        end;
    end;
end;

function v2.PlayAnimation(u23, u24, p25, p26) -- Line: 159
    if u23._animator then
        local u27 = p25 or 1;
        local v28, v29, v30 = u23:GetRandomCoreAnim(u24);
        u23:StopCore(u23._lastInfo.stopFadeTime or 0.1);
        v28:Play(v30.fadeTime or 0.1, 1, v30.speed or u27);
        u23._track = v28;

        if v29 > 1 then
            v28.DidLoop:Once(function() -- Line: 176
                -- upvalues: u23 (copy), u24 (copy), u27 (ref)
                if u23._active and u23._lastPose == u24 then
                    u23:PlayAnimation(u24, u27);
                end;
            end);
        end;

        return v30;
    end;
end;

function v2.Destroy(p31) -- Line: 188
    p31:StopCore();
    p31.PoseChanged:Destroy();
    p31._active = false;
    setmetatable(p31, nil);
    table.clear(p31);
end;

function v2.ChangePose(p32, p33, p34, p35) -- Line: 205
    if p32._disabled[p33] then
        return;
    end;

    if p35 and not p32._active then
        return;
    end;

    p32._switch:Switch(p33, p34 or 1);
end;

return {
    new = function(p36, p37) -- Line: 229, Name: new
        -- upvalues: SimpleSignal (copy), u3 (copy), Switch (copy)
        local v38 = p36:FindFirstChildWhichIsA("Animator", true);

        if not v38 then
            error((`Animator not found for rig {p36}`));
        end;

        local v39 = {
            _active = true,
            _lastPose = "",
            _track = false,
            _animator = v38,
            _anims = p37,
            _rig = p36,
            _lastInfo = {},
            _disabled = {},
            PoseChanged = SimpleSignal.new()
        };
        local u40 = setmetatable(v39, u3);
        u40._switch = Switch.new("", function(p41, p42) -- Line: 250
            -- upvalues: u40 (copy)
            local _lastPose = u40._lastPose;
            local v43 = u40:PlayAnimation(p41, p42);
            u40.PoseChanged:Fire(_lastPose, p41, u40._track);
            u40._lastPose = p41;
            u40._lastInfo = v43;
        end);
        u40:ChangePose("Idle");

        return u40;
    end
};