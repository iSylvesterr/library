-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");

local function loadFlag(u1) -- Line: 9
    local success, result = pcall(function() -- Line: 10
        -- upvalues: u1 (copy)
        return UserSettings():IsUserFeatureEnabled(u1);
    end);

    return success and result;
end;

local u2 = "UserSoundsUseRelativeVelocity2";
local success, result = pcall(function() -- Line: 10
    -- upvalues: u2 (copy)
    return UserSettings():IsUserFeatureEnabled(u2);
end);
local u3 = success and result;
local u4 = {
    Climbing = {
        SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3",
        Looped = true
    },
    Died = {
        SoundId = "rbxasset://sounds/uuhhh.mp3"
    },
    FreeFalling = {
        SoundId = "rbxasset://sounds/action_falling.mp3",
        Looped = true
    },
    GettingUp = {
        SoundId = "rbxasset://sounds/action_get_up.mp3"
    },
    Jumping = {
        SoundId = "rbxasset://sounds/action_jump.mp3"
    },
    Landing = {
        SoundId = "rbxasset://sounds/action_jump_land.mp3"
    },
    Running = {
        SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3",
        Looped = true,
        Pitch = 1.85
    },
    Splash = {
        SoundId = "rbxasset://sounds/impact_water.mp3"
    },
    Swimming = {
        SoundId = "rbxasset://sounds/action_swim.mp3",
        Looped = true,
        Pitch = 1.6
    }
};

local function map(p5, p6, p7, p8, p9) -- Line: 55
    return (p5 - p6) * (p9 - p8) / (p7 - p6) + p8;
end;

local function getRelativeVelocity(p10, p11) -- Line: 59
    if not p10 then
        return p11;
    end;

    local v12 = p10.ActiveController and (p10.ActiveController:IsA("GroundController") and p10.GroundSensor or p10.ActiveController:IsA("ClimbController") and p10.ClimbSensor);

    if v12 and v12.SensedPart then
        return p11 - v12.SensedPart:GetVelocityAtPosition(p10.RootPart.Position);
    end;

    return p11;
end;

local function playSound(p13) -- Line: 76
    p13.TimePosition = 0;
    p13.Playing = true;
end;

local function shallowCopy(p14) -- Line: 81
    local v15 = {};

    for i, v in pairs(p14) do
        v15[i] = v;
    end;

    return v15;
end;

local u74 = require(script:WaitForChild("AtomicBinding")).new({
    humanoid = "Humanoid",
    rootPart = "HumanoidRootPart"
}, function(p16) -- Line: 89, Name: initializeSoundSystem
    -- upvalues: u3 (copy), u4 (copy), getRelativeVelocity (copy), RunService (copy)
    local _ = p16.player;
    local humanoid = p16.humanoid;
    local rootPart = p16.rootPart;
    local u17;

    if u3 then
        u17 = humanoid.Parent:FindFirstChild("ControllerManager");
    else
        u17 = nil;
    end;

    local u18 = {};

    for i, v in pairs(u4) do
        local Sound = Instance.new("Sound");
        Sound.Name = i;
        Sound.SoundGroup = game.SoundService.SoundEffects;
        Sound.Archivable = false;
        Sound.RollOffMinDistance = 5;
        Sound.RollOffMaxDistance = 150;
        Sound.Volume = 0.65;

        for i2, v2 in pairs(v) do
            Sound[i2] = v2;
        end;

        Sound.Parent = rootPart;
        u18[i] = Sound;
    end;

    local u19 = {};

    local function stopPlayingLoopedSounds(p20) -- Line: 124
        -- upvalues: u19 (copy)
        local v21 = pairs;
        local v22 = {};

        for i, v in pairs(u19) do
            v22[i] = v;
        end;

        for i in v21(v22) do
            if i ~= p20 then
                i.Playing = false;
                u19[i] = nil;
            end;
        end;
    end;

    local u47 = {
        [Enum.HumanoidStateType.FallingDown] = function() -- Line: 135
            -- upvalues: u19 (copy)
            local v23 = pairs;
            local v24 = {};

            for i, v in pairs(u19) do
                v24[i] = v;
            end;

            for i in v23(v24) do
                if i ~= nil then
                    i.Playing = false;
                    u19[i] = nil;
                end;
            end;
        end,

        [Enum.HumanoidStateType.GettingUp] = function() -- Line: 139
            -- upvalues: u19 (copy), u18 (copy)
            local v25 = pairs;
            local v26 = {};

            for i, v in pairs(u19) do
                v26[i] = v;
            end;

            for i in v25(v26) do
                if i ~= nil then
                    i.Playing = false;
                    u19[i] = nil;
                end;
            end;

            local GettingUp = u18.GettingUp;
            GettingUp.TimePosition = 0;
            GettingUp.Playing = true;
        end,

        [Enum.HumanoidStateType.Jumping] = function() -- Line: 144
            -- upvalues: u19 (copy), u18 (copy)
            local v27 = pairs;
            local v28 = {};

            for i, v in pairs(u19) do
                v28[i] = v;
            end;

            for i in v27(v28) do
                if i ~= nil then
                    i.Playing = false;
                    u19[i] = nil;
                end;
            end;

            local Jumping = u18.Jumping;
            Jumping.TimePosition = 0;
            Jumping.Playing = true;
        end,

        [Enum.HumanoidStateType.Swimming] = function() -- Line: 149
            -- upvalues: rootPart (copy), u18 (copy), u19 (copy)
            local v29 = math.abs(rootPart.AssemblyLinearVelocity.Y);

            if v29 > 0.1 then
                u18.Splash.Volume = math.clamp((v29 - 100) * 0.72 / 250 + 0.28, 0, 1);
                local Splash = u18.Splash;
                Splash.TimePosition = 0;
                Splash.Playing = true;
            end;

            local Swimming = u18.Swimming;
            local v30 = pairs;
            local v31 = {};

            for i, v in pairs(u19) do
                v31[i] = v;
            end;

            for i in v30(v31) do
                if i ~= Swimming then
                    i.Playing = false;
                    u19[i] = nil;
                end;
            end;

            u18.Swimming.Playing = true;
            u19[u18.Swimming] = true;
        end,

        [Enum.HumanoidStateType.Freefall] = function() -- Line: 160
            -- upvalues: u18 (copy), u19 (copy)
            u18.FreeFalling.Volume = 0;
            local FreeFalling = u18.FreeFalling;
            local v32 = pairs;
            local v33 = {};

            for i, v in pairs(u19) do
                v33[i] = v;
            end;

            for i in v32(v33) do
                if i ~= FreeFalling then
                    i.Playing = false;
                    u19[i] = nil;
                end;
            end;

            u19[u18.FreeFalling] = true;
        end,

        [Enum.HumanoidStateType.Landed] = function() -- Line: 166
            -- upvalues: u19 (copy), rootPart (copy), u18 (copy)
            local v34 = pairs;
            local v35 = {};

            for i, v in pairs(u19) do
                v35[i] = v;
            end;

            for i in v34(v35) do
                if i ~= nil then
                    i.Playing = false;
                    u19[i] = nil;
                end;
            end;

            local v36 = math.abs(rootPart.AssemblyLinearVelocity.Y);

            if v36 > 75 then
                u18.Landing.Volume = math.clamp((v36 - 50) * 1 / 50 + 0, 0, 1);
                local Landing = u18.Landing;
                Landing.TimePosition = 0;
                Landing.Playing = true;
            end;
        end,

        [Enum.HumanoidStateType.Running] = function() -- Line: 175
            -- upvalues: u18 (copy), u19 (copy)
            local Running = u18.Running;
            local v37 = pairs;
            local v38 = {};

            for i, v in pairs(u19) do
                v38[i] = v;
            end;

            for i in v37(v38) do
                if i ~= Running then
                    i.Playing = false;
                    u19[i] = nil;
                end;
            end;

            u18.Running.Playing = true;
            u19[u18.Running] = true;
        end,

        [Enum.HumanoidStateType.Climbing] = function() -- Line: 181
            -- upvalues: u18 (copy), rootPart (copy), u3 (ref), getRelativeVelocity (ref), u17 (ref), u19 (copy)
            local Climbing = u18.Climbing;
            local AssemblyLinearVelocity = rootPart.AssemblyLinearVelocity;

            if u3 then
                AssemblyLinearVelocity = getRelativeVelocity(u17, AssemblyLinearVelocity);
            end;

            if math.abs(AssemblyLinearVelocity.Y) > 0.1 then
                Climbing.Playing = true;
                local v39 = pairs;
                local v40 = {};

                for i, v in pairs(u19) do
                    v40[i] = v;
                end;

                for i in v39(v40) do
                    if i ~= Climbing then
                        i.Playing = false;
                        u19[i] = nil;
                    end;
                end;
            else
                local v41 = pairs;
                local v42 = {};

                for i, v in pairs(u19) do
                    v42[i] = v;
                end;

                for i in v41(v42) do
                    if i ~= nil then
                        i.Playing = false;
                        u19[i] = nil;
                    end;
                end;
            end;

            u19[Climbing] = true;
        end,

        [Enum.HumanoidStateType.Seated] = function() -- Line: 194
            -- upvalues: u19 (copy)
            local v43 = pairs;
            local v44 = {};

            for i, v in pairs(u19) do
                v44[i] = v;
            end;

            for i in v43(v44) do
                if i ~= nil then
                    i.Playing = false;
                    u19[i] = nil;
                end;
            end;
        end,

        [Enum.HumanoidStateType.Dead] = function() -- Line: 198
            -- upvalues: u19 (copy), u18 (copy)
            local v45 = pairs;
            local v46 = {};

            for i, v in pairs(u19) do
                v46[i] = v;
            end;

            for i in v45(v46) do
                if i ~= nil then
                    i.Playing = false;
                    u19[i] = nil;
                end;
            end;

            local Died = u18.Died;
            Died.TimePosition = 0;
            Died.Playing = true;
        end
    };
    local u58 = {
        [u18.Climbing] = function(p48, p49, p50) -- Line: 206
            -- upvalues: u3 (ref), getRelativeVelocity (ref), u17 (ref)
            if u3 then
                p50 = getRelativeVelocity(u17, p50);
            end;

            p49.Playing = p50.Magnitude > 0.1;
        end,

        [u18.FreeFalling] = function(p51, p52, p53) -- Line: 211
            if p53.Magnitude > 75 then
                p52.Volume = math.clamp(p52.Volume + p51 * 0.9, 0, 1);

                return;
            end;

            p52.Volume = 0;
        end,

        [u18.Running] = function(p54, p55, p56) -- Line: 219
            -- upvalues: humanoid (copy)
            local v57;

            if p56.Magnitude > 0.5 then
                v57 = humanoid.MoveDirection.Magnitude > 0.5;
            else
                v57 = false;
            end;

            p55.Playing = v57;
        end
    };
    local u59 = {
        [Enum.HumanoidStateType.RunningNoPhysics] = Enum.HumanoidStateType.Running
    };
    local u60 = u59[humanoid:GetState()] or humanoid:GetState();

    local function transitionTo(p61) -- Line: 231
        -- upvalues: u47 (copy), u60 (ref)
        local v62 = u47[p61];

        if v62 then
            v62();
        end;

        u60 = p61;
    end;

    local v63 = u60;
    local v64 = u47[v63];

    if v64 then
        v64();
    end;

    u60 = v63;
    local u69 = humanoid.StateChanged:Connect(function(p65, p66) -- Line: 243
        -- upvalues: u59 (copy), u60 (ref), u47 (copy)
        local v67 = u59[p66] or p66;

        if v67 ~= u60 then
            local v68 = u47[v67];

            if v68 then
                v68();
            end;

            u60 = v67;
        end;
    end);
    local u73 = RunService.Stepped:Connect(function(p70, p71) -- Line: 251
        -- upvalues: u19 (copy), u58 (copy), rootPart (copy)
        for i in pairs(u19) do
            local v72 = u58[i];

            if v72 then
                v72(p71, i, rootPart.AssemblyLinearVelocity);
            end;
        end;
    end);

    return function() -- Line: 262, Name: terminate
        -- upvalues: u69 (copy), u73 (copy), u18 (copy)
        u69:Disconnect();
        u73:Disconnect();

        for _, v in pairs(u18) do
            v:Destroy();
        end;

        table.clear(u18);
    end;
end);
local u75 = {};

local function characterAdded(p76) -- Line: 285
    -- upvalues: u74 (copy)
    u74:bindRoot(p76);
end;

local function characterRemoving(p77) -- Line: 289
    -- upvalues: u74 (copy)
    u74:unbindRoot(p77);
end;

local function playerAdded(p78) -- Line: 293
    -- upvalues: u75 (copy), u74 (copy), characterAdded (copy), characterRemoving (copy)
    local v79 = u75[p78];

    if not v79 then
        v79 = {};
        u75[p78] = v79;
    end;

    if p78.Character then
        u74:bindRoot(p78.Character);
    end;

    table.insert(v79, p78.CharacterAdded:Connect(characterAdded));
    table.insert(v79, p78.CharacterRemoving:Connect(characterRemoving));
end;

local function playerRemoving(p80) -- Line: 307
    -- upvalues: u75 (copy), u74 (copy)
    local v81 = u75[p80];

    if v81 then
        for _, v in ipairs(v81) do
            v:Disconnect();
        end;

        u75[p80] = nil;
    end;

    if p80.Character then
        u74:unbindRoot(p80.Character);
    end;
end;

for _, v in ipairs(Players:GetPlayers()) do
    task.spawn(playerAdded, v);
end;

Players.PlayerAdded:Connect(playerAdded);
Players.PlayerRemoving:Connect(playerRemoving);