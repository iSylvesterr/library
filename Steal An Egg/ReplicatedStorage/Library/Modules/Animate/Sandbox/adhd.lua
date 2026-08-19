-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local v1 = assert(script.Parent, "Animate script has no parent!");

if not v1:IsA("Model") then
    v1 = nil;
end;

local u2 = assert(v1, "Parent of Animate must be a Model!");
local v3 = u2:FindFirstChildOfClass("Humanoid");
local u4 = assert(v3, "No Humanoid found for the Animate script to use!");
local u5 = u4:FindFirstChildOfClass("Animator");

if not u5 then
    if RunService:IsServer() then
        u5 = Instance.new("Animator");
        assert(u5).Parent = u4;
    else
        u5 = u4;
    end;
end;

local u6 = OverlapParams.new();
u6.FilterDescendantsInstances = { u2 };
u6.MaxParts = 5;
local u7 = {
    Animations = {},
    Defaults = {},
    Emotes = {},
    Callbacks = {},
    DidLoop = {},
    LocomotionMap = {},
    Emotes = {
        wave = false,
        point = false,
        dance = true,
        dance2 = true,
        dance3 = true,
        laugh = false,
        cheer = false
    },
    Defaults = {
        idle = { {
                Id = "rbxassetid://507766666",
                Weight = 1
            }, {
                Id = "rbxassetid://507766951",
                Weight = 1
            }, {
                Id = "rbxassetid://507766388",
                Weight = 9
            } },
        walk = { {
                Id = "rbxassetid://507777826",
                Weight = 10
            } },
        run = { {
                Id = "rbxassetid://507767714",
                Weight = 10
            } },
        swim = { {
                Id = "rbxassetid://507784897",
                Weight = 10
            } },
        swimidle = { {
                Id = "rbxassetid://507785072",
                Weight = 10
            } },
        jump = { {
                Id = "rbxassetid://507765000",
                Weight = 10
            } },
        fall = { {
                Id = "rbxassetid://507767968",
                Weight = 10
            } },
        climb = { {
                Id = "rbxassetid://507765644",
                Weight = 10
            } },
        sit = { {
                Id = "rbxassetid://2506281703",
                Weight = 10
            } },
        toolnone = { {
                Id = "rbxassetid://507768375",
                Weight = 10
            } },
        toolslash = { {
                Id = "rbxassetid://522635514",
                Weight = 10
            } },
        toollunge = { {
                Id = "rbxassetid://522638767",
                Weight = 10
            } },
        wave = { {
                Id = "rbxassetid://507770239",
                Weight = 10
            } },
        point = { {
                Id = "rbxassetid://507770453",
                Weight = 10
            } },
        dance = { {
                Id = "rbxassetid://507771019",
                Weight = 10
            }, {
                Id = "rbxassetid://507771955",
                Weight = 10
            }, {
                Id = "rbxassetid://507772104",
                Weight = 10
            } },
        dance2 = { {
                Id = "rbxassetid://507776043",
                Weight = 10
            }, {
                Id = "rbxassetid://507776720",
                Weight = 10
            }, {
                Id = "rbxassetid://507776879",
                Weight = 10
            } },
        dance3 = { {
                Id = "rbxassetid://507777268",
                Weight = 10
            }, {
                Id = "rbxassetid://507777451",
                Weight = 10
            }, {
                Id = "rbxassetid://507777623",
                Weight = 10
            } },
        laugh = { {
                Id = "rbxassetid://507770818",
                Weight = 10
            } },
        cheer = { {
                Id = "rbxassetid://507770677",
                Weight = 10
            } }
    },
    LocomotionMap = {
        run = {
            Speed = 12.8,
            Velocity = Vector2.yAxis * 12.8
        },
        walk = {
            Speed = 6.4,
            Velocity = Vector2.yAxis * 6.4
        }
    }
};

local function newAnimSet() -- Line: 209
    return {
        TotalWeight = 0
    };
end;

local function signedAngle(p8, p9) -- Line: 213
    return -math.atan2(p8.X * p9.Y - p8.Y * p9.X, p8.X * p9.X + p8.Y * p9.Y);
end;

local function registerCallback(p10, p11) -- Line: 217
    -- upvalues: u7 (copy)
    u7.Callbacks[p10] = p11;
end;

local function getTrackController(p12) -- Line: 221
    -- upvalues: u7 (copy)
    local v13 = u7.Animations[p12];
    local v14 = "Unknown animation name: " .. tostring(p12);

    return assert(v13, v14);
end;

local function getNumber(p15, p16) -- Line: 226
    local v17 = p15:FindFirstChild(p16);

    if v17 and v17:IsA("NumberValue") then
        return v17.Value;
    end;

    local v18 = p15:GetAttribute(p16);

    if typeof(v18) == "number" then
        return v18;
    end;

    return nil;
end;

local function getHeightScale() -- Line: 242
    -- upvalues: u4 (copy)
    if not u4.AutomaticScalingEnabled then
        return 1;
    end;

    local v19 = script;
    local ScaleDampeningPercent = v19:FindFirstChild("ScaleDampeningPercent");
    local v20;

    if ScaleDampeningPercent and ScaleDampeningPercent:IsA("NumberValue") then
        v20 = ScaleDampeningPercent.Value;
    else
        v20 = v19:GetAttribute("ScaleDampeningPercent");

        if typeof(v20) ~= "number" then
            v20 = nil;
        end;
    end;

    if v20 then
        return 1 + (u4.HipHeight - 2) * v20 / 2;
    end;

    return u4.HipHeight / 2;
end;

local function getTimePosition(p21) -- Line: 256
    local ActiveTrack = p21.ActiveTrack;

    if ActiveTrack and (ActiveTrack.IsPlaying and ActiveTrack.WeightTarget > 0.0001) then
        return ActiveTrack.TimePosition;
    end;
end;

local function loadAnimation(p22) -- Line: 266
    -- upvalues: u4 (copy), u5 (ref), u7 (copy)
    if not p22.Track then
        local Animation = p22.Animation;

        if Animation == nil then
            Animation = Instance.new("Animation");
            assert(Animation);
            Animation.AnimationId = assert(p22.Id);
            p22.Animation = Animation;
        end;

        local v23;

        if script:GetAttribute("DebugHumanoidLoadAnimation") then
            v23 = u4;
        else
            v23 = u5;
        end;

        local u24 = v23:LoadAnimation(assert(Animation));
        u24.Priority = Enum.AnimationPriority.Core;
        u24.DidLoop:Connect(function() -- Line: 289
            -- upvalues: u7 (ref), u24 (copy)
            u7.DidLoop[u24] = true;
        end);
        p22.Track = u24;
    end;

    return assert(p22.Track);
end;

local function getAnimSetForAnimation(p25) -- Line: 299
    -- upvalues: u7 (copy)
    local Parent = p25.Parent;

    if not (Parent and Parent:IsA("StringValue")) then
        return;
    end;

    if Parent.Parent == script then
        local Name = Parent.Name;
        local v26 = u7.Animations[Name];

        if not v26 then
            v26 = {
                DefaultSet = {
                    TotalWeight = 0
                },
                CustomSet = {
                    TotalWeight = 0
                }
            };
            u7.Animations[Name] = v26;
        end;

        return v26.CustomSet, Name;
    end;
end;

local function canEmote() -- Line: 356
    -- upvalues: u4 (copy)
    local MoveDirection = u4.MoveDirection;
    local v27 = u4:GetState();

    if MoveDirection == Vector3.new(0, 0, 0) then
        return v27 == Enum.HumanoidStateType.Running;
    end;

    return false;
end;

local function checkAnimationAdded(p28) -- Line: 375
    -- upvalues: getAnimSetForAnimation (copy), loadAnimation (copy), u7 (copy)
    if p28:IsA("Animation") then
        local v29, v30 = getAnimSetForAnimation(p28);

        if v29 then
            local v31 = p28:GetAttribute("LinearVelocity");
            local Weight = p28:FindFirstChild("Weight");
            local v32;

            if Weight and Weight:IsA("NumberValue") then
                v32 = Weight.Value;
            else
                v32 = p28:GetAttribute("Weight");

                if typeof(v32) ~= "number" then
                    v32 = nil;
                end;
            end;

            local v33 = v32 or 1;
            local v34 = {
                Id = p28.AnimationId,
                Animation = p28,
                Weight = v33
            };
            v29.TotalWeight = v29.TotalWeight + v33;
            loadAnimation(v34);

            if v30 and typeof(v31) == "Vector2" then
                u7.LocomotionMap[v30] = {
                    Velocity = v31,
                    Speed = v31.Magnitude
                };
            end;

            table.insert(v29, v34);
        end;
    end;
end;

local function checkAnimationRemoving(p35) -- Line: 404
    -- upvalues: getAnimSetForAnimation (copy)
    local v36 = p35:IsA("Animation") and getAnimSetForAnimation(p35);

    if v36 then
        local v37 = nil;

        for i, v in ipairs(v36) do
            if v.Animation == p35 then
                v36.TotalWeight = v36.TotalWeight - v.Weight;
                v37 = i;
                break;
            end;
        end;

        if v37 then
            table.remove(v36, v37);
        end;
    end;
end;

local function rollAnimation(p38) -- Line: 325
    -- upvalues: loadAnimation (copy)
    local v39;

    if #p38.CustomSet == 0 then
        v39 = p38.DefaultSet;
    else
        v39 = p38.CustomSet;
    end;

    if #v39 == 1 then
        return loadAnimation(v39[1]), false;
    end;

    if #v39 == 0 then
        return nil, nil;
    end;

    local v40 = assert(v39.TotalWeight);
    local v41 = math.random() * v40;
    local v42 = 0;
    local v43 = 1;

    while v42 < v40 do
        local v44 = assert(v39[v43]);
        local v45 = v42 + v44.Weight;

        if v42 <= v41 and v41 < v45 then
            return loadAnimation(v44), true;
        end;

        v43 = v43 + 1;
        v42 = v45;
    end;

    return nil, nil;
end;

for i, v in u7.Defaults do
    local v46 = {
        TotalWeight = 0
    };

    for _, v2 in v do
        v46.TotalWeight = v46.TotalWeight + v2.Weight;
        table.insert(v46, v2);
        loadAnimation(v2);
    end;

    u7.Animations[i] = {
        DefaultSet = v46,
        CustomSet = {
            TotalWeight = 0
        }
    };
end;

for _, descendant in script:GetDescendants() do
    checkAnimationAdded(descendant);
end;

script.DescendantAdded:Connect(checkAnimationAdded);
script.DescendantRemoving:Connect(checkAnimationRemoving);
local u47 = nil;
local u48 = nil;
local u49 = 0;
local u50 = 0;

local function onFreefall() -- Line: 467
    -- upvalues: u49 (ref), u7 (copy)
    local v51;

    if os.clock() < u49 then
        local jump = u7.Animations.jump;
        local v52 = "Unknown animation name: " .. tostring("jump");
        v51 = assert(jump, v52);
    else
        local fall = u7.Animations.fall;
        local v53 = "Unknown animation name: " .. tostring("fall");
        v51 = assert(fall, v53);
    end;

    v51.Weight = 1;
    v51.FadeTime = 0.1;
end;

local function onSeated() -- Line: 476
    -- upvalues: u7 (copy)
    local sit = u7.Animations.sit;
    local v54 = "Unknown animation name: " .. tostring("sit");
    local v55 = assert(sit, v54);
    v55.FadeTime = 0.4;
    v55.Weight = 1;
    v55.Speed = 0;
end;

local function onClimbing() -- Line: 483
    -- upvalues: u4 (copy), u7 (copy)
    local RootPart = u4.RootPart;
    local v56 = not RootPart and 0 or RootPart.AssemblyLinearVelocity.Y / 5;
    local climb = u7.Animations.climb;
    local v57 = "Unknown animation name: " .. tostring("climb");
    local v58 = assert(climb, v57);
    v58.Speed = v56;
    v58.Weight = 1;
end;

local function onSwimming() -- Line: 497
    -- upvalues: u4 (copy), u7 (copy)
    local RootPart = u4.RootPart;
    local v59 = not RootPart and 0 or RootPart.AssemblyLinearVelocity.Magnitude;
    local swim = u7.Animations.swim;
    local v60 = "Unknown animation name: " .. tostring("swim");
    local v61 = assert(swim, v60);
    v61.FadeTime = 0.4;
    local swimidle = u7.Animations.swimidle;
    local v62 = "Unknown animation name: " .. tostring("swimidle");
    local v63 = assert(swimidle, v62);
    v63.FadeTime = 0.4;

    if v59 <= 1 then
        v63.Weight = 1;

        return;
    end;

    v61.Speed = v59 / 10;
    v61.Weight = 1;
end;

local function onRunning() -- Line: 520
    -- upvalues: u4 (copy), u6 (copy), u7 (copy)
    local RootPart = u4.RootPart;
    local zero = Vector2.zero;
    local v64;

    if RootPart then
        local v65 = RootPart.Position - Vector3.new(0, 1, 0) * (u4.HipHeight + RootPart.Size.Y / 2);
        local v66 = workspace:GetPartBoundsInRadius(v65, 1, u6);
        local AssemblyLinearVelocity = RootPart.AssemblyLinearVelocity;
        local v67 = {};

        for _, v in v66 do
            local v68;

            if v:IsA("BasePart") then
                v68 = v.AssemblyRootPart;
            else
                v68 = nil;
            end;

            local v69 = assert(v68);

            if not v67[v69] then
                AssemblyLinearVelocity = AssemblyLinearVelocity - v69:GetVelocityAtPosition(v65);
                v67[v69] = true;
            end;
        end;

        local CFrame = RootPart.CFrame;
        local v70 = CFrame.RightVector:Dot(AssemblyLinearVelocity);
        local v71 = CFrame.LookVector:Dot(AssemblyLinearVelocity);
        zero = Vector2.new(v70, v71);
        v64 = zero.Magnitude;
    else
        v64 = 0;
    end;

    local v72;

    if u4.AutomaticScalingEnabled then
        local v73 = script;
        local ScaleDampeningPercent = v73:FindFirstChild("ScaleDampeningPercent");
        local v74;

        if ScaleDampeningPercent and ScaleDampeningPercent:IsA("NumberValue") then
            v74 = ScaleDampeningPercent.Value;
        else
            v74 = v73:GetAttribute("ScaleDampeningPercent");

            if typeof(v74) ~= "number" then
                v74 = nil;
            end;
        end;

        if v74 then
            v72 = 1 + (u4.HipHeight - 2) * v74 / 2;
        else
            v72 = u4.HipHeight / 2;
        end;
    else
        v72 = 1;
    end;

    local v75 = v64 / 12.8 / v72;

    if v72 / 2 >= v64 then
        local idle = u7.Animations.idle;
        local v76 = "Unknown animation name: " .. tostring("idle");
        assert(idle, v76).Weight = 1;

        return;
    end;

    local v77 = (v75 - 0.5) / 0.5;
    local v78 = math.log(v77 + 1);
    local v79 = math.max(1, v78);
    local v80 = math.clamp(v77, 0.0001, 1);
    local v81;

    if v80 == 0.0001 then
        v81 = v75 / 0.5;
    else
        v81 = 1 - v77;
    end;

    local v82 = math.clamp(v81, 0.0001, 1);
    local v83 = {};
    local v84 = false;
    local v85 = false;
    local v86 = false;
    local v87 = false;
    local v88 = false;
    local v89 = false;

    for i, v in u7.LocomotionMap do
        local Velocity = v.Velocity;

        if zero:Dot(Velocity) > 0 then
            v83[i] = v;
        end;

        if not v84 then
            v85 = v85 or Velocity.X < 0;
            v89 = v89 or Velocity.Y < 0;
            v84 = v85 and v89;
        end;

        if not v87 then
            v88 = v88 or Velocity.X > 0;
            v86 = v86 or Velocity.Y > 0;
            v87 = v88 and v86;
        end;
    end;

    if v84 and v87 then
        local v90 = {};
        local v91 = 0;
        local v92 = 0;
        local v93 = {};
        local v94 = 0;

        for i, v in v83 do
            local Velocity = v.Velocity;
            local v95 = -math.atan2(zero.X * Velocity.Y - zero.Y * Velocity.X, zero.X * Velocity.X + zero.Y * Velocity.Y);
            local v96 = 1 - math.abs(v95);
            local v97 = math.clamp(v96, 0, 1);
            local Speed = v.Speed;

            if math.abs(Speed - 12.8) < math.abs(Speed - 6.4) then
                v90[i] = v97;
                v91 = v91 + v97;
            else
                v93[i] = v97;
                v94 = v94 + v97;
            end;

            local v98 = u7.Animations[i];
            local v99 = "Unknown animation name: " .. tostring(i);
            local ActiveTrack = assert(v98, v99).ActiveTrack;
            local v100;

            if ActiveTrack and (ActiveTrack.IsPlaying and ActiveTrack.WeightTarget > 0.0001) then
                v100 = ActiveTrack.TimePosition;
            else
                v100 = nil;
            end;

            if v100 then
                v92 = math.max(v92, v100);
            end;
        end;

        for i, v in v90 do
            local v101 = u7.Animations[i];
            local v102 = "Unknown animation name: " .. tostring(i);
            local v103 = assert(v101, v102);
            v103.Weight = math.clamp(v / v91 * v80, 0.0001, 1);
            v103.TimePosition = v92;
            v103.Speed = v79;
        end;

        for i, v in v93 do
            local v104 = u7.Animations[i];
            local v105 = "Unknown animation name: " .. tostring(i);
            local v106 = assert(v104, v105);
            v106.Weight = math.clamp(v / v94 * v82, 0.0001, 1);
            v106.TimePosition = v92;
        end;

        return;
    end;

    local run = u7.Animations.run;
    local v107 = "Unknown animation name: " .. tostring("run");
    local v108 = assert(run, v107);
    v108.Weight = v80;
    v108.Speed = v79;
    local walk = u7.Animations.walk;
    local v109 = "Unknown animation name: " .. tostring("walk");
    assert(walk, v109).Weight = v82;
end;

local function onPlayEmote(p110) -- Line: 662
    -- upvalues: u4 (copy), u7 (copy), u48 (ref)
    if typeof(p110) ~= "Instance" then
        return false;
    end;

    if not p110:IsA("Animation") then
        return false;
    end;

    local MoveDirection = u4.MoveDirection;
    local v111 = u4:GetState();
    local v112;

    if MoveDirection == Vector3.new(0, 0, 0) then
        v112 = v111 == Enum.HumanoidStateType.Running;
    else
        v112 = false;
    end;

    if not v112 then
        return false;
    end;

    local v113 = p110.AnimationId:match("%d+$");

    if not v113 then
        return false;
    end;

    local v114 = "emote_" .. assert(v113);

    if u7.Animations[v114] == nil then
        local v115 = {
            DefaultSet = {
                TotalWeight = 0
            },
            CustomSet = {
                TotalWeight = 0
            }
        };
        table.insert(v115.DefaultSet, {
            Weight = 1,
            Id = "rbxassetid://" .. v113,
            Animation = p110
        });
        u7.Animations[v114] = v115;
    end;

    u48 = v114;

    return true;
end;

local function onChatted(p116) -- Line: 703
    -- upvalues: u7 (copy), u4 (copy), u48 (ref)
    local v117 = nil;

    if p116:sub(1, 3) == "/e " then
        v117 = p116:sub(4);
    elseif p116:sub(1, 7) == "/emote " then
        v117 = p116:sub(8);
    end;

    if u7.Emotes[v117] ~= nil then
        local MoveDirection = u4.MoveDirection;
        local v118 = u4:GetState();
        local v119;

        if MoveDirection == Vector3.new(0, 0, 0) then
            v119 = v118 == Enum.HumanoidStateType.Running;
        else
            v119 = false;
        end;

        if v119 then
            u48 = v117;
        end;
    end;
end;

u4.Jumping:Connect(function() -- Line: 463, Name: onJumping
    -- upvalues: u49 (ref)
    u49 = os.clock() + 0.4;
end);

if LocalPlayer then
    LocalPlayer.Chatted:Connect(onChatted);
end;

task.spawn(function() -- Line: 725
    -- upvalues: onPlayEmote (copy)
    local PlayEmote = script:WaitForChild("PlayEmote", (1 / 0));

    if PlayEmote and PlayEmote:IsA("BindableFunction") then
        PlayEmote.OnInvoke = onPlayEmote;
    end;
end);
u7.Callbacks[Enum.HumanoidStateType.Seated] = onSeated;
u7.Callbacks[Enum.HumanoidStateType.Running] = onRunning;
u7.Callbacks[Enum.HumanoidStateType.Climbing] = onClimbing;
u7.Callbacks[Enum.HumanoidStateType.Freefall] = onFreefall;
u7.Callbacks[Enum.HumanoidStateType.Swimming] = onSwimming;
assert(u5);

for _, v in u5:GetPlayingAnimationTracks() do
    v:Stop(0);
    v:Destroy();
end;

local function updateToolAnimation(p120) -- Line: 755
    -- upvalues: u47 (ref), u50 (ref), u4 (copy), u7 (copy)
    local v121 = os.clock();
    local v122 = "toolnone";
    local toolanim = p120:FindFirstChild("toolanim");

    if toolanim and toolanim:IsA("StringValue") then
        u47 = toolanim.Value;
        u50 = v121 + 0.3;
        toolanim.Parent = nil;
    end;

    if v121 < u50 then
        v122 = u47 == "Slash" and "toolslash" or (u47 == "Lunge" and not u4.Sit and "toollunge" or v122);
    elseif u47 then
        u47 = nil;
    end;

    local v123 = u7.Animations[v122];
    local v124 = "Unknown animation name: " .. tostring(v122);
    local v125 = assert(v123, v124);
    v125.Priority = Enum.AnimationPriority.Action;
    v125.FadeTime = 0.1;
    v125.Weight = 1;
end;

RunService.Heartbeat:Connect(function() -- Line: 782, Name: updateAnimations
    -- upvalues: u2 (copy), updateToolAnimation (copy), u48 (ref), u4 (copy), u7 (copy), rollAnimation (copy)
    local v126 = u2:FindFirstChildWhichIsA("Tool");

    if v126 and v126.RequiresHandle then
        updateToolAnimation(v126);
    end;

    local v127, v128;

    if u48 then
        local MoveDirection = u4.MoveDirection;
        local v129 = u4:GetState();
        local v130;

        if MoveDirection == Vector3.new(0, 0, 0) then
            v130 = v129 == Enum.HumanoidStateType.Running;
        else
            v130 = false;
        end;

        if v130 then
            local v131 = u48;
            local v132 = u7.Animations[v131];
            local v133 = "Unknown animation name: " .. tostring(v131);
            assert(v132, v133).Weight = 1;
        else
            v127 = u4:GetState();
            v128 = u7.Callbacks[v127];

            if v128 then
                v128();
            end;

            u48 = nil;
        end;
    else
        v127 = u4:GetState();
        v128 = u7.Callbacks[v127];

        if v128 then
            v128();
        end;

        u48 = nil;
    end;

    for _, v in u7.Animations do
        local Speed = v.Speed;
        local Weight = v.Weight;
        local FadeTime = v.FadeTime;
        local ActiveTrack = v.ActiveTrack;

        if not (Speed or Weight) then
            if ActiveTrack and ActiveTrack.IsPlaying then
                ActiveTrack:Stop(FadeTime or 0.3);
            end;

            if FadeTime then
                v.FadeTime = nil;
            end;
        end;

        local v134;

        if ActiveTrack then
            v134 = ActiveTrack.IsPlaying;
        else
            v134 = false;
        end;

        local v135;

        if v134 and (ActiveTrack and u7.DidLoop[ActiveTrack]) then
            local v136;
            v135, v136 = rollAnimation(v);

            if v136 then
                v134 = false;
            end;

            u7.DidLoop[ActiveTrack] = nil;
        else
            v135 = nil;
        end;

        if not v134 then
            if ActiveTrack and ActiveTrack ~= v135 then
                ActiveTrack:Stop(FadeTime or 0.3);
            end;

            ActiveTrack = v135 or rollAnimation(v);
            v.ActiveTrack = ActiveTrack;
        end;

        if ActiveTrack then
            local TimePosition = v.TimePosition;
            assert(ActiveTrack);

            if ActiveTrack.IsPlaying then
                local Priority = v.Priority;

                if Weight then
                    v.Weight = nil;

                    if Weight == 0.0001 and ActiveTrack.WeightTarget ~= 0.0001 then
                        ActiveTrack:AdjustWeight(0.0001, FadeTime or 0.3);
                    elseif math.abs(Weight - ActiveTrack.WeightTarget) > 0.01 then
                        ActiveTrack:AdjustWeight(Weight, FadeTime or 0.3);
                    end;
                end;

                if Speed then
                    v.Speed = nil;

                    if math.abs(Speed - ActiveTrack.Speed) > 0.01 and ActiveTrack.WeightTarget > 0.0001 then
                        ActiveTrack:AdjustSpeed(Speed);
                    end;
                end;

                if Priority then
                    ActiveTrack.Priority = Priority;
                    v.Priority = nil;
                end;

                if TimePosition then
                    ActiveTrack.TimePosition = TimePosition;
                end;
            else
                ActiveTrack:Play(FadeTime or 0.3, Weight or 1, Speed or 1);
                ActiveTrack.TimePosition = TimePosition or 0;
            end;

            if TimePosition then
                v.TimePosition = nil;
            end;

            if FadeTime then
                v.FadeTime = nil;
            end;
        end;
    end;
end);