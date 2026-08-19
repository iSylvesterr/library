-- Decompiled with Potassium's decompiler.

local Parent = script.Parent;
local Humanoid = Parent:WaitForChild("Humanoid");
local u1 = "Standing";
local success, result = pcall(function() -- Line: 7
    return UserSettings():IsUserFeatureEnabled("UserNoUpdateOnLoop");
end);
local u2 = success and result;
local success2, result2 = pcall(function() -- Line: 12
    return UserSettings():IsUserFeatureEnabled("UserAnimateScaleRun");
end);
local u3 = success2 and result2;

local function getRigScale() -- Line: 17
    -- upvalues: u3 (copy), Parent (copy)
    return not u3 and 1 or Parent:GetScale();
end;

local ScaleDampeningPercent = script:FindFirstChild("ScaleDampeningPercent");
local u4 = "";
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = 1;
local u9 = nil;
local u10 = nil;
local u11 = {};
local u12 = {};
local u13 = {
    idle = { {
            id = "http://www.roblox.com/asset/?id=507766666",
            weight = 1
        }, {
            id = "http://www.roblox.com/asset/?id=507766951",
            weight = 1
        }, {
            id = "http://www.roblox.com/asset/?id=507766388",
            weight = 9
        } },
    walk = { {
            id = "http://www.roblox.com/asset/?id=507777826",
            weight = 10
        } },
    run = { {
            id = "http://www.roblox.com/asset/?id=507767714",
            weight = 10
        } },
    swim = { {
            id = "http://www.roblox.com/asset/?id=507784897",
            weight = 10
        } },
    swimidle = { {
            id = "http://www.roblox.com/asset/?id=507785072",
            weight = 10
        } },
    jump = { {
            id = "http://www.roblox.com/asset/?id=507765000",
            weight = 10
        } },
    fall = { {
            id = "http://www.roblox.com/asset/?id=507767968",
            weight = 10
        } },
    climb = { {
            id = "http://www.roblox.com/asset/?id=507765644",
            weight = 10
        } },
    sit = { {
            id = "http://www.roblox.com/asset/?id=2506281703",
            weight = 10
        } },
    toolnone = { {
            id = "http://www.roblox.com/asset/?id=507768375",
            weight = 10
        } },
    toolslash = { {
            id = "http://www.roblox.com/asset/?id=522635514",
            weight = 10
        } },
    toollunge = { {
            id = "http://www.roblox.com/asset/?id=522638767",
            weight = 10
        } },
    wave = { {
            id = "http://www.roblox.com/asset/?id=507770239",
            weight = 10
        } },
    point = { {
            id = "http://www.roblox.com/asset/?id=507770453",
            weight = 10
        } },
    dance = { {
            id = "http://www.roblox.com/asset/?id=507771019",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=507771955",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=507772104",
            weight = 10
        } },
    dance2 = { {
            id = "http://www.roblox.com/asset/?id=507776043",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=507776720",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=507776879",
            weight = 10
        } },
    dance3 = { {
            id = "http://www.roblox.com/asset/?id=507777268",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=507777451",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=507777623",
            weight = 10
        } },
    laugh = { {
            id = "http://www.roblox.com/asset/?id=507770818",
            weight = 10
        } },
    cheer = { {
            id = "http://www.roblox.com/asset/?id=507770677",
            weight = 10
        } }
};
local u14 = {
    wave = false,
    point = false,
    dance = true,
    dance2 = true,
    dance3 = true,
    laugh = false,
    cheer = false
};
math.randomseed(tick());

function findExistingAnimationInSet(p15, p16)
    if p15 == nil or p16 == nil then
        return 0;
    end;

    for i = 1, p15.count do
        if p15[i].anim.AnimationId == p16.AnimationId then
            return i;
        end;
    end;

    return 0;
end;

function configureAnimationSet(u17, u18)
    -- upvalues: u12 (copy), u11 (copy), Humanoid (copy)
    if u12[u17] ~= nil then
        for _, v in pairs(u12[u17].connections) do
            v:disconnect();
        end;
    end;

    u12[u17] = {};
    u12[u17].count = 0;
    u12[u17].totalWeight = 0;
    u12[u17].connections = {};
    local u19 = true;
    local success3, _ = pcall(function() -- Line: 143
        -- upvalues: u19 (ref)
        u19 = game:GetService("StarterPlayer").AllowCustomAnimations;
    end);
    u19 = not success3 and true or u19;
    local v20 = script:FindFirstChild(u17);

    if u19 and v20 ~= nil then
        table.insert(u12[u17].connections, v20.ChildAdded:connect(function(p21) -- Line: 155
            -- upvalues: u17 (copy), u18 (copy)
            configureAnimationSet(u17, u18);
        end));
        table.insert(u12[u17].connections, v20.ChildRemoved:connect(function(p22) -- Line: 161
            -- upvalues: u17 (copy), u18 (copy)
            configureAnimationSet(u17, u18);
        end));

        for _, child in pairs(v20:GetChildren()) do
            if child:IsA("Animation") then
                local Weight = child:FindFirstChild("Weight");
                local v23 = Weight == nil and 1 or Weight.Value;
                u12[u17].count = u12[u17].count + 1;
                local count = u12[u17].count;
                u12[u17][count] = {};
                u12[u17][count].anim = child;
                u12[u17][count].weight = v23;
                u12[u17].totalWeight = u12[u17].totalWeight + u12[u17][count].weight;
                table.insert(u12[u17].connections, child.Changed:connect(function(p24) -- Line: 182
                    -- upvalues: u17 (copy), u18 (copy)
                    configureAnimationSet(u17, u18);
                end));
                table.insert(u12[u17].connections, child.ChildAdded:connect(function(p25) -- Line: 188
                    -- upvalues: u17 (copy), u18 (copy)
                    configureAnimationSet(u17, u18);
                end));
                table.insert(u12[u17].connections, child.ChildRemoved:connect(function(p26) -- Line: 194
                    -- upvalues: u17 (copy), u18 (copy)
                    configureAnimationSet(u17, u18);
                end));
            end;
        end;
    end;

    if u12[u17].count <= 0 then
        for i, v in pairs(u18) do
            u12[u17][i] = {};
            u12[u17][i].anim = Instance.new("Animation");
            u12[u17][i].anim.Name = u17;
            u12[u17][i].anim.AnimationId = v.id;
            u12[u17][i].weight = v.weight;
            u12[u17].count = u12[u17].count + 1;
            u12[u17].totalWeight = u12[u17].totalWeight + v.weight;
        end;
    end;

    for _, v in pairs(u12) do
        for i = 1, v.count do
            if u11[v[i].anim.AnimationId] == nil then
                Humanoid:LoadAnimation(v[i].anim);
                u11[v[i].anim.AnimationId] = true;
            end;
        end;
    end;
end;

function configureAnimationSetOld(u27, u28)
    -- upvalues: u12 (copy), Humanoid (copy)
    if u12[u27] ~= nil then
        for _, v in pairs(u12[u27].connections) do
            v:disconnect();
        end;
    end;

    u12[u27] = {};
    u12[u27].count = 0;
    u12[u27].totalWeight = 0;
    u12[u27].connections = {};
    local u29 = true;
    local success3, _ = pcall(function() -- Line: 241
        -- upvalues: u29 (ref)
        u29 = game:GetService("StarterPlayer").AllowCustomAnimations;
    end);
    u29 = not success3 and true or u29;
    local v30 = script:FindFirstChild(u27);

    if u29 and v30 ~= nil then
        table.insert(u12[u27].connections, v30.ChildAdded:connect(function(p31) -- Line: 253
            -- upvalues: u27 (copy), u28 (copy)
            configureAnimationSet(u27, u28);
        end));
        table.insert(u12[u27].connections, v30.ChildRemoved:connect(function(p32) -- Line: 259
            -- upvalues: u27 (copy), u28 (copy)
            configureAnimationSet(u27, u28);
        end));
        local v33 = 1;

        for _, child in pairs(v30:GetChildren()) do
            if child:IsA("Animation") then
                table.insert(u12[u27].connections, child.Changed:connect(function(p34) -- Line: 268
                    -- upvalues: u27 (copy), u28 (copy)
                    configureAnimationSet(u27, u28);
                end));
                u12[u27][v33] = {};
                u12[u27][v33].anim = child;
                local Weight = child:FindFirstChild("Weight");

                if Weight == nil then
                    u12[u27][v33].weight = 1;
                else
                    u12[u27][v33].weight = Weight.Value;
                end;

                u12[u27].count = u12[u27].count + 1;
                u12[u27].totalWeight = u12[u27].totalWeight + u12[u27][v33].weight;
                v33 = v33 + 1;
            end;
        end;
    end;

    if u12[u27].count <= 0 then
        for i, v in pairs(u28) do
            u12[u27][i] = {};
            u12[u27][i].anim = Instance.new("Animation");
            u12[u27][i].anim.Name = u27;
            u12[u27][i].anim.AnimationId = v.id;
            u12[u27][i].weight = v.weight;
            u12[u27].count = u12[u27].count + 1;
            u12[u27].totalWeight = u12[u27].totalWeight + v.weight;
        end;
    end;

    for _, v in pairs(u12) do
        for i = 1, v.count do
            Humanoid:LoadAnimation(v[i].anim);
        end;
    end;
end;

function scriptChildModified(p35)
    -- upvalues: u13 (copy)
    local v36 = u13[p35.Name];

    if v36 ~= nil then
        configureAnimationSet(p35.Name, v36);
    end;
end;

script.ChildAdded:connect(scriptChildModified);
script.ChildRemoved:connect(scriptChildModified);
local v37;

if Humanoid then
    v37 = Humanoid:FindFirstChildOfClass("Animator");
else
    v37 = nil;
end;

if v37 then
    local v38 = v37:GetPlayingAnimationTracks();

    for _, v in ipairs(v38) do
        v:Stop(0);
        v:Destroy();
    end;
end;

for i, v in pairs(u13) do
    configureAnimationSet(i, v);
end;

local u39 = "None";
local u40 = 0;
local u41 = 0;
local u42 = false;

function stopAllAnimations()
    -- upvalues: u4 (ref), u14 (copy), u42 (ref), u5 (ref), u7 (ref), u6 (ref), u10 (ref), u9 (ref)
    local v43 = u4;
    local v44 = u14[v43] ~= nil and u14[v43] == false and "idle" or v43;

    if u42 then
        v44 = "idle";
        u42 = false;
    end;

    u4 = "";
    u5 = nil;

    if u7 ~= nil then
        u7:disconnect();
    end;

    if u6 ~= nil then
        u6:Stop();
        u6:Destroy();
        u6 = nil;
    end;

    if u10 ~= nil then
        u10:disconnect();
    end;

    if u9 ~= nil then
        u9:Stop();
        u9:Destroy();
        u9 = nil;
    end;

    return v44;
end;

function getHeightScale()
    -- upvalues: Humanoid (copy), getRigScale (copy), ScaleDampeningPercent (ref)
    if not Humanoid then
        return getRigScale();
    end;

    if not Humanoid.AutomaticScalingEnabled then
        return getRigScale();
    end;

    local v45 = Humanoid.HipHeight / 2;

    if ScaleDampeningPercent == nil then
        ScaleDampeningPercent = script:FindFirstChild("ScaleDampeningPercent");
    end;

    if ScaleDampeningPercent ~= nil then
        v45 = 1 + (Humanoid.HipHeight - 2) * ScaleDampeningPercent.Value / 2;
    end;

    return v45;
end;

local function rootMotionCompensation(p46) -- Line: 411
    return p46 * 1.25 / getHeightScale();
end;

local function setRunSpeed(p47) -- Line: 419
    -- upvalues: u6 (ref), u9 (ref)
    local v48 = p47 * 1.25 / getHeightScale();
    local v49 = 0.0001;
    local v50 = 0.0001;
    local v51 = 1;

    if v48 <= 0.5 then
        v51 = v48 / 0.5;
        v49 = 1;
    elseif v48 < 1 then
        v50 = (v48 - 0.5) / 0.5;
        v49 = 1 - v50;
    else
        v51 = v48 / 1;
        v50 = 1;
    end;

    u6:AdjustWeight(v49);
    u9:AdjustWeight(v50);
    u6:AdjustSpeed(v51);
    u9:AdjustSpeed(v51);
end;

function setAnimationSpeed(p52)
    -- upvalues: u4 (ref), setRunSpeed (copy), u8 (ref), u6 (ref)
    if u4 == "walk" then
        setRunSpeed(p52);

        return;
    end;

    if p52 ~= u8 then
        u8 = p52;
        u6:AdjustSpeed(u8);
    end;
end;

function keyFrameReachedFunc(p53)
    -- upvalues: u4 (ref), u2 (copy), u9 (ref), u6 (ref), u14 (copy), u42 (ref), u8 (ref), Humanoid (copy)
    if p53 == "End" then
        if u4 == "walk" then
            if u2 ~= true then
                u9.TimePosition = 0;
                u6.TimePosition = 0;

                return;
            end;

            if u9.Looped ~= true then
                u9.TimePosition = 0;
            end;

            if u6.Looped ~= true then
                u6.TimePosition = 0;
            end;
        else
            local v54 = u4;
            local v55 = u14[v54] ~= nil and u14[v54] == false and "idle" or v54;

            if u42 then
                if u6.Looped then
                    return;
                end;

                v55 = "idle";
                u42 = false;
            end;

            playAnimation(v55, 0.15, Humanoid);
            setAnimationSpeed(u8);
        end;
    end;
end;

function rollAnimation(p56)
    -- upvalues: u12 (copy)
    local v57 = math.random(1, u12[p56].totalWeight);
    local v58 = 1;

    while u12[p56][v58].weight < v57 do
        v57 = v57 - u12[p56][v58].weight;
        v58 = v58 + 1;
    end;

    return v58;
end;

local function switchToAnim(p59, p60, p61, p62) -- Line: 505
    -- upvalues: u5 (ref), u6 (ref), u9 (ref), u2 (copy), u8 (ref), u4 (ref), u7 (ref), u12 (copy), u10 (ref)
    if p59 ~= u5 then
        if u6 ~= nil then
            u6:Stop(p61);
            u6:Destroy();
        end;

        if u9 ~= nil then
            u9:Stop(p61);
            u9:Destroy();

            if u2 == true then
                u9 = nil;
            end;
        end;

        u8 = 1;
        u6 = p62:LoadAnimation(p59);
        u6.Priority = Enum.AnimationPriority.Core;
        u6:Play(p61);
        u4 = p60;
        u5 = p59;

        if u7 ~= nil then
            u7:disconnect();
        end;

        u7 = u6.KeyframeReached:connect(keyFrameReachedFunc);

        if p60 == "walk" then
            local v63 = rollAnimation("run");
            u9 = p62:LoadAnimation(u12.run[v63].anim);
            u9.Priority = Enum.AnimationPriority.Core;
            u9:Play(p61);

            if u10 ~= nil then
                u10:disconnect();
            end;

            u10 = u9.KeyframeReached:connect(keyFrameReachedFunc);
        end;
    end;
end;

function playAnimation(p64, p65, p66)
    -- upvalues: u12 (copy), switchToAnim (copy), u42 (ref)
    local v67 = rollAnimation(p64);
    switchToAnim(u12[p64][v67].anim, p64, p65, p66);
    u42 = false;
end;

function playEmote(p68, p69, p70)
    -- upvalues: switchToAnim (copy), u42 (ref)
    switchToAnim(p68, p68.Name, p69, p70);
    u42 = true;
end;

local u71 = "";
local u72 = nil;
local u73 = nil;
local u74 = nil;

function toolKeyFrameReachedFunc(p75)
    -- upvalues: u71 (ref), Humanoid (copy)
    if p75 == "End" then
        playToolAnimation(u71, 0, Humanoid);
    end;
end;

function playToolAnimation(p76, p77, p78, p79)
    -- upvalues: u12 (copy), u73 (ref), u72 (ref), u71 (ref), u74 (ref)
    local v80 = rollAnimation(p76);
    local anim = u12[p76][v80].anim;

    if u73 ~= anim then
        if u72 ~= nil then
            u72:Stop();
            u72:Destroy();
            p77 = 0;
        end;

        u72 = p78:LoadAnimation(anim);

        if p79 then
            u72.Priority = p79;
        end;

        u72:Play(p77);
        u71 = p76;
        u73 = anim;
        u74 = u72.KeyframeReached:connect(toolKeyFrameReachedFunc);
    end;
end;

function stopToolAnimations()
    -- upvalues: u71 (ref), u74 (ref), u73 (ref), u72 (ref)
    local v81 = u71;

    if u74 ~= nil then
        u74:disconnect();
    end;

    u71 = "";
    u73 = nil;

    if u72 ~= nil then
        u72:Stop();
        u72:Destroy();
        u72 = nil;
    end;

    return v81;
end;

function onRunning(p82)
    -- upvalues: u3 (copy), u42 (ref), Humanoid (copy), u1 (ref), u14 (copy), u4 (ref)
    local v83 = not u3 and 1 or getHeightScale();

    if (u42 and Humanoid.MoveDirection == Vector3.new(0, 0, 0) and (Humanoid.WalkSpeed / v83 or 0.75) or 0.75) * v83 >= p82 then
        if u14[u4] == nil and not u42 then
            playAnimation("idle", 0.2, Humanoid);
            u1 = "Standing";
        end;

        return;
    end;

    playAnimation("walk", 0.2, Humanoid);
    setAnimationSpeed(p82 / 16);
    u1 = "Running";
end;

function onDied()
    -- upvalues: u1 (ref)
    u1 = "Dead";
end;

function onJumping()
    -- upvalues: Humanoid (copy), u41 (ref), u1 (ref)
    playAnimation("jump", 0.1, Humanoid);
    u41 = 0.31;
    u1 = "Jumping";
end;

function onClimbing(p84)
    -- upvalues: u3 (copy), Humanoid (copy), u1 (ref)
    if u3 then
        p84 = p84 / getHeightScale();
    end;

    playAnimation("climb", 0.1, Humanoid);
    setAnimationSpeed(p84 / 5);
    u1 = "Climbing";
end;

function onGettingUp()
    -- upvalues: u1 (ref)
    u1 = "GettingUp";
end;

function onFreeFall()
    -- upvalues: u41 (ref), Humanoid (copy), u1 (ref)
    if u41 <= 0 then
        playAnimation("fall", 0.2, Humanoid);
    end;

    u1 = "FreeFall";
end;

function onFallingDown()
    -- upvalues: u1 (ref)
    u1 = "FallingDown";
end;

function onSeated()
    -- upvalues: u1 (ref)
    u1 = "Seated";
end;

function onPlatformStanding()
    -- upvalues: u1 (ref)
    u1 = "PlatformStanding";
end;

function onSwimming(p85)
    -- upvalues: u3 (copy), Humanoid (copy), u1 (ref)
    if u3 then
        p85 = p85 / getHeightScale();
    end;

    if p85 <= 1 then
        playAnimation("swimidle", 0.4, Humanoid);
        u1 = "Standing";

        return;
    end;

    playAnimation("swim", 0.4, Humanoid);
    setAnimationSpeed(p85 / 10);
    u1 = "Swimming";
end;

function animateTool()
    -- upvalues: u39 (ref), Humanoid (copy)
    if u39 == "None" then
        playToolAnimation("toolnone", 0.1, Humanoid, Enum.AnimationPriority.Idle);

        return;
    end;

    if u39 == "Slash" then
        playToolAnimation("toolslash", 0, Humanoid, Enum.AnimationPriority.Action);

        return;
    end;

    if u39 ~= "Lunge" then
        return;
    end;

    playToolAnimation("toollunge", 0, Humanoid, Enum.AnimationPriority.Action);
end;

function getToolAnim(p86)
    for _, child in ipairs(p86:GetChildren()) do
        if child.Name == "toolanim" and child.className == "StringValue" then
            return child;
        end;
    end;

    return nil;
end;

local u87 = 0;

function stepAnimate(p88)
    -- upvalues: u87 (ref), u41 (ref), u1 (ref), Humanoid (copy), Parent (copy), u39 (ref), u40 (ref), u73 (ref)
    local v89 = p88 - u87;
    u87 = p88;

    if u41 > 0 then
        u41 = u41 - v89;
    end;

    if u1 == "FreeFall" and u41 <= 0 then
        playAnimation("fall", 0.2, Humanoid);
    else
        if u1 == "Seated" then
            playAnimation("sit", 0.5, Humanoid);

            return;
        end;

        if u1 == "Running" then
            playAnimation("walk", 0.2, Humanoid);
        elseif u1 == "Dead" or (u1 == "GettingUp" or (u1 == "FallingDown" or (u1 == "Seated" or u1 == "PlatformStanding"))) then
            stopAllAnimations();
        end;
    end;

    local v90 = Parent:FindFirstChildOfClass("Tool");

    if v90 and v90:FindFirstChild("Handle") then
        local v91 = getToolAnim(v90);

        if v91 then
            u39 = v91.Value;
            v91.Parent = nil;
            u40 = p88 + 0.3;
        end;

        if u40 < p88 then
            u40 = 0;
            u39 = "None";
        end;

        animateTool();

        return;
    end;

    stopToolAnimations();
    u39 = "None";
    u73 = nil;
    u40 = 0;
end;

Humanoid.Died:connect(onDied);
Humanoid.Running:connect(onRunning);
Humanoid.Jumping:connect(onJumping);
Humanoid.Climbing:connect(onClimbing);
Humanoid.GettingUp:connect(onGettingUp);
Humanoid.FreeFalling:connect(onFreeFall);
Humanoid.FallingDown:connect(onFallingDown);
Humanoid.Seated:connect(onSeated);
Humanoid.PlatformStanding:connect(onPlatformStanding);
Humanoid.Swimming:connect(onSwimming);
game:GetService("Players").LocalPlayer.Chatted:connect(function(p92) -- Line: 809
    -- upvalues: u1 (ref), u14 (copy), Humanoid (copy)
    local v93 = "";

    if string.sub(p92, 1, 3) == "/e " then
        v93 = string.sub(p92, 4);
    elseif string.sub(p92, 1, 7) == "/emote " then
        v93 = string.sub(p92, 8);
    end;

    if u1 == "Standing" and u14[v93] ~= nil then
        playAnimation(v93, 0.1, Humanoid);
    end;
end);

script:WaitForChild("PlayEmote").OnInvoke = function(p94) -- Line: 823
    -- upvalues: u1 (ref), u14 (copy), Humanoid (copy), u6 (ref)
    if u1 == "Standing" then
        if u14[p94] ~= nil then
            playAnimation(p94, 0.1, Humanoid);

            return true, u6;
        end;

        if typeof(p94) ~= "Instance" or not p94:IsA("Animation") then
            return false;
        end;

        playEmote(p94, 0.1, Humanoid);

        return true, u6;
    end;
end;

if Parent.Parent ~= nil then
    playAnimation("idle", 0.1, Humanoid);
    u1 = "Standing";
end;

while Parent.Parent ~= nil do
    local _, v95 = wait(0.1);
    stepAnimate(v95);
end;