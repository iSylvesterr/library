-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local HttpService = game:GetService("HttpService");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local v1 = getfenv(0);
local Encode = v1.Encode;
local ensureOriginalRoot = v1.ensureOriginalRoot;
local u2 = {};
u2.__index = u2;
local u3 = {};
u3.__index = u3;
local u4 = Log.new();
local v5 = RunService:IsRunning();
local u6 = RunService:IsServer();
local u7 = RunService:IsClient();
local u8 = { "BodyVelocity", "BodyGyro", "BodyPosition" };
local u9 = {
    BodyVelocity = {
        P = 15000,
        MaxForce = Vector3.new(300000, 300000, 300000)
    },
    BodyPosition = {
        P = 9000,
        D = 325,
        MaxForce = Vector3.new(30000000, 30000000, 30000000)
    },
    BodyGyro = {
        P = 10000,
        D = 150,
        MaxTorque = Vector3.new(400000, 400000, 400000)
    },
    AlignPosition = {
        ApplyAtCenterOfMass = true,
        RigidityEnabled = true,
        Mode = Enum.PositionAlignmentMode.OneAttachment
    }
};
local u10 = {};
local u11 = {};
local u12 = {};
local BodyMover = ReplicatedStorage.Remotes.BodyMover;
local StunAnimator = require(game.ServerStorage.StunAnimator);

local function getServerPlayerFromCharacter(p13) -- Line: 118
    -- upvalues: Players (copy), u6 (copy), u7 (copy)
    if not p13 then
        return nil;
    end;

    local v14 = Players:GetPlayerFromCharacter(p13);

    if u6 and (v14 and not u7) then
        return v14;
    end;

    return nil;
end;

local function removeEntryByKey(p15, p16) -- Line: 131
    for i = 1, #p15 do
        if p15[i].key == p16 then
            table.remove(p15, i);

            return;
        end;
    end;
end;

local function insertEntry(p17, p18) -- Line: 140
    -- upvalues: HttpService (copy)
    local v19 = HttpService:GenerateGUID(false);
    table.insert(p17, {
        key = v19,
        value = p18
    });

    return v19;
end;

local function getOrCreateNoopProxy() -- Line: 149
    local u20 = nil;
    u20 = setmetatable({}, {
        __index = function() -- Line: 152, Name: __index
            -- upvalues: u20 (ref)
            return u20;
        end,

        __call = function() -- Line: 155, Name: __call
            -- upvalues: u20 (ref)
            return u20;
        end
    });

    return u20;
end;

task.spawn(function() -- Line: 162
    -- upvalues: u10 (copy), u11 (copy)
    while task.wait(10) do
        for i, _ in next, u10 do
            if i.Parent == nil then
                u10[i] = nil;
                u11[i] = nil;
            end;
        end;
    end;
end);

function u2.new(p21, p22) -- Line: 173
    -- upvalues: u7 (copy), Players (copy), u4 (copy), getOrCreateNoopProxy (copy), u6 (copy), ensureOriginalRoot (copy), getServerPlayerFromCharacter (copy), u2 (copy), u11 (copy), u10 (copy)
    local v23 = p22 or {};
    local HumanoidRootPart = p21:FindFirstChild("HumanoidRootPart");
    local v24;

    if u7 and not Players:GetPlayerFromCharacter(p21) then
        u4:AtWarning():Log("DANGEROUS BODYMOVER DETECTED. DO NOT INSTANCE ENEMY BODYMOVERS IN THE CLIENT.");
        v24 = true;
    else
        v24 = false;
    end;

    local AntiMover = p21:FindFirstChild("AntiMover");

    if v23.BypassAntiMover then
        AntiMover = nil;
    end;

    if not HumanoidRootPart or (AntiMover or v24) then
        return getOrCreateNoopProxy();
    end;

    local v25 = HumanoidRootPart:IsA("BasePart");
    assert(v25, "HumanoidRootPart must be a BasePart");

    if u6 then
        HumanoidRootPart = ensureOriginalRoot(HumanoidRootPart);
    end;

    local v26 = getServerPlayerFromCharacter(p21);

    if v26 then
        return setmetatable({
            Parent = HumanoidRootPart,
            Player = v26,
            Meta = v23
        }, u2);
    end;

    local v27 = u11[p21];

    if v27 then
        return v27;
    end;

    local v28 = HumanoidRootPart:FindFirstChild("BodyVelocity") or p21:FindFirstChild("BodyVelocity");
    local v29 = HumanoidRootPart:FindFirstChild("BodyPosition") or p21:FindFirstChild("BodyPosition");
    local v30 = HumanoidRootPart:FindFirstChild("BodyGyro") or p21:FindFirstChild("BodyGyro");

    if not (v28 and (v29 and v30)) then
        v28 = Instance.new("BodyVelocity");
        v29 = Instance.new("BodyPosition");
        v30 = Instance.new("BodyGyro");
        local v31;

        if v28 then
            v31 = v28:IsA("BodyVelocity");
        else
            v31 = v28;
        end;

        assert(v31, "BodyVelocity instance creation failed");
        local v32;

        if v29 then
            v32 = v29:IsA("BodyPosition");
        else
            v32 = v29;
        end;

        assert(v32, "BodyPosition instance creation failed");
        local v33;

        if v30 then
            v33 = v30:IsA("BodyGyro");
        else
            v33 = v30;
        end;

        assert(v33, "BodyGyro instance creation failed");
        v28.MaxForce = Vector3.new();
        v29.MaxForce = Vector3.new();
        v30.MaxTorque = Vector3.new();
    end;

    if not u10[p21] then
        u10[p21] = {
            BodyVelocity = {},
            BodyPosition = {},
            BodyGyro = {}
        };
    end;

    local v34;

    if v28 then
        v34 = v28:IsA("BodyVelocity");
    else
        v34 = v28;
    end;

    assert(v34, "BodyVelocity must exist");
    local v35;

    if v29 then
        v35 = v29:IsA("BodyPosition");
    else
        v35 = v29;
    end;

    assert(v35, "BodyPosition must exist");
    local v36;

    if v30 then
        v36 = v30:IsA("BodyGyro");
    else
        v36 = v30;
    end;

    assert(v36, "BodyGyro must exist");
    local v37 = u10[p21];
    assert(v37, "Running movers table is missing");
    local v38 = setmetatable({
        Running = v37,
        Parent = HumanoidRootPart,
        BodyVelocity = v28,
        BodyPosition = v29,
        BodyGyro = v30
    }, u2);
    u11[p21] = v38;

    if u7 and Players:GetPlayerFromCharacter(p21) == Players.LocalPlayer then
        v38.Player2 = true;
    end;

    if u6 then
        v38.Meta = v23;
    end;

    return v38;
end;

function u2.GetActive(p39, p40) -- Line: 266
    -- upvalues: u10 (copy)
    return u10[p40];
end;

function u2.Create(u41, p42, u43) -- Line: 270
    -- upvalues: u9 (copy), u6 (copy), StunAnimator (copy), u3 (copy), insertEntry (copy), u2 (copy), BodyMover (copy), Encode (copy)
    if not u41.Player then
        for i, v in next, u9[p42] do
            if u43[i] == nil then
                u43[i] = v;
            end;
        end;

        local v44 = {};

        for i, v in next, u43 do
            if i ~= "Duration" and (i ~= "Priority" and (i ~= "AirFix" and (i ~= "AnimationType" and i ~= "Meta"))) then
                if i == "Velocity" then
                    local v45 = typeof(v) == "Vector3";
                    assert(v45, "Velocity must be a Vector3");

                    if v ~= v or v.Magnitude < 0.001 then
                        local v = Vector3.new(0, 0.0010000000474974513, 0);
                    end;
                end;

                v44[i] = v;

                if i == "MaxForce" or i == "MaxTorque" then
                    local v46 = v44[i];
                    local v47 = typeof(v46) == "Vector3";
                    assert(v47, "MaxForce/MaxTorque must be a Vector3");
                    local v48 = v46 * (u41.Parent.Size.Y - 1) ^ 2;
                    local v49 = math.min(600000, v48.X);
                    local v50 = math.min(600000, v48.Y);
                    local v51 = math.min(600000, v48.Z);
                    v44[i] = Vector3.new(v49, v50, v51) * (p42 == "BodyVelocity" and 1.5 or 15);
                end;
            end;
        end;

        u43.Values = v44;
        u43.Priority = u43.Priority or 1;
        u43.Duration = u43.Duration or (1 / 0);
        u43.AirFix = u43.AirFix or false;
        u43.Type = p42;
        u43.StartTime = tick();
        u43.Enabled = true;
        u43.LastCurrent = false;
        u43.ApplyCounter = 0;
        u43.Parent = u41;
    end;

    if u41.Player then
        u43.ID = math.random(9999999);
        u43.Character = u41.Player.Character;
    elseif u41.Player2 then
        local v52 = (1 / 0);

        if p42 == "BodyPosition" then
            local MaxForce = u43.Values.MaxForce;
            v52 = typeof(MaxForce) == "Vector3" and (MaxForce.X > 0 or MaxForce.Z > 0) and 600 or v52;
        end;

        u43.Duration = math.min(u43.Duration or (1 / 0), v52);
    end;

    if u41.Meta then
        u43.Meta = u41.Meta;
    end;

    if u43.Velocity and u43.Velocity ~= u43.Velocity then
        u43.Velocity = Vector3.new(0, 0, 0);
    end;

    local u53 = u6 and u43.AnimationType ~= "None" and u41.Parent:FindFirstChild("StunObjects");

    if u53 then
        local function addStunAnimatorMarker(p54) -- Line: 350
            -- upvalues: u43 (copy), u53 (copy), u41 (copy), StunAnimator (ref)
            local Folder = Instance.new("Folder");
            Folder.Name = "_";
            Folder:SetAttribute("LastBodyVelocityValue", p54);
            Folder:SetAttribute("LastBodyVelocityDuration", u43.Duration or (1 / 0));
            Folder:SetAttribute("LastBodyVelocityTimestamp", workspace:GetServerTimeNow());
            Folder:SetAttribute("LastBodyVelocityPriority", u43.Priority or 1);

            if u43.AnimationType then
                Folder:SetAttribute("AnimationType", u43.AnimationType);
            end;

            Folder.Parent = u53;

            local function v55() -- Line: 362
                -- upvalues: u43 (ref), Folder (copy)
                u43.DestroyCallback = nil;
                Folder.Name = "_";
                Folder:Destroy();
            end;

            u43.DestroyCallback = v55;

            if u43.Duration and u43.Duration < 1000000 then
                task.delay(u43.Duration, v55);
            end;

            local Parent = u41.Parent.Parent;

            if Parent and Parent:IsA("Model") then
                StunAnimator(Parent, nil);
            end;
        end;

        if u43.Velocity then
            addStunAnimatorMarker(u43.Velocity);
        elseif u43.Position then
            addStunAnimatorMarker((Vector3.new(0, 0.0010000000474974513, 0)));
        end;
    end;

    local v56 = setmetatable(u43, u3);

    if u41.Player then
        if u6 and u41.Player then
            BodyMover:FireClient(u41.Player, Encode(v56), "Create", p42, u43);
        end;

        return v56;
    end;

    local Running = u41.Running;
    assert(Running, "Running movers list missing on body mover");
    insertEntry(Running[p42], v56);
    u2.UpdateAll(u41, 0);

    return v56;
end;

function u2.UpdateAll(p57, p58) -- Line: 410
    -- upvalues: u10 (copy), u8 (copy), u3 (copy), removeEntryByKey (copy), u12 (copy)
    local v59 = tick();

    for i, v in next, u10 do
        local v60;

        if i then
            v60 = i:FindFirstChild("HumanoidRootPart");
        else
            v60 = i;
        end;

        for _, v2 in ipairs(u8) do
            local v61 = v[v2];
            local v62;

            if v2 == "BodyGyro" then
                v62 = {
                    P = 0,
                    D = 0,
                    MaxTorque = Vector3.new()
                };
            elseif v2 == "BodyVelocity" then
                v62 = {
                    P = 0,
                    _D = 0,
                    MaxForce = Vector3.new()
                };
            else
                v62 = {
                    P = 0,
                    D = 0,
                    MaxForce = Vector3.new()
                };
            end;

            local v63 = setmetatable({
                Priority = (-1 / 0),
                Enabled = false,
                Duration = 0,
                AirFix = false,
                StartTime = 0,
                LastCurrent = false,
                ApplyCounter = 0,
                Type = v2,
                Parent = v60,
                Values = v62
            }, u3);

            for _, v3 in pairs(v61) do
                local key = v3.key;
                local value = v3.value;

                if v59 - value.StartTime > value.Duration or value.Removing then
                    value.Enabled = false;
                    value.Removing = true;

                    if value.DestroyCallback then
                        task.spawn(value.DestroyCallback);
                    end;

                    local v64 = u10[i];
                    assert(v64, "Body mover table missing for character");
                    removeEntryByKey(v64[v2], key);
                    u12[v2] = nil;

                    if v2 == "BodyPosition" then
                        if v60 and v60:IsA("BasePart") then
                            v60.AssemblyLinearVelocity = Vector3.new();
                        end;
                    elseif v2 == "BodyVelocity" and (value.AirFix and (v60 and v60:IsA("BasePart"))) then
                        v60.AssemblyLinearVelocity = v60.AssemblyLinearVelocity * Vector3.new(0.20000000298023224, 0.20000000298023224, 0.20000000298023224);
                    end;
                end;

                if value.Priority >= v63.Priority and not value.Removing then
                    v63 = value;
                end;
            end;

            if v63.Enabled then
                if u12[v2] ~= v63 then
                    u12[v2] = v63;
                    u3._SetActive(v63, true);
                end;
            else
                if v63[v2] ~= v63 then
                    u12[v2] = v63;

                    if v60 and v60:FindFirstChild(v63.Type) then
                        u3._SetActive(v63, false);
                    end;
                end;

                if not v63.Parent then
                    u12[v2] = nil;
                end;
            end;
        end;
    end;
end;

function u3.SetForce(p65, p66) -- Line: 511
    -- upvalues: getServerPlayerFromCharacter (copy), u6 (copy), BodyMover (copy), Encode (copy), u12 (copy)
    local Parent = p65.Parent;
    local v67 = p66 * (Parent.Parent.Size.Y - 1) ^ 2;
    local v68 = math.min(600000, v67.X);
    local v69 = math.min(600000, v67.Y);
    local v70 = math.min(600000, v67.Z);
    local v71 = Vector3.new(v68, v69, v70) * 15;
    local v72 = getServerPlayerFromCharacter(p65.Character);

    if v72 then
        if u6 then
            BodyMover:FireClient(v72, Encode(p65), "SetForce", v71);
        end;

        return;
    end;

    local v73 = Parent.Parent[p65.Type];
    local v74 = u12[p65.Type] == p65;

    if p65.Type == "BodyVelocity" or p65.Type == "BodyPosition" then
        p65.Values.MaxForce = v71;

        if v74 then
            v73.MaxForce = v71;
        end;
    elseif p65.Type == "BodyGyro" then
        p65.Values.MaxTorque = v71;

        if v74 then
            v73.MaxTorque = v71;
        end;
    end;
end;

function u3.Set(p75, p76) -- Line: 544
    -- upvalues: getServerPlayerFromCharacter (copy), BodyMover (copy), Encode (copy), u12 (copy)
    local v77 = getServerPlayerFromCharacter(p75.Character);

    if v77 then
        BodyMover:FireClient(v77, Encode(p75), "Set", p76);

        return;
    end;

    local v78 = p75.Parent.Parent[p75.Type];
    local v79 = u12[p75.Type] == p75;

    if p75.Type == "BodyVelocity" then
        local v80 = typeof(p76) == "Vector3";
        assert(v80, "BodyVelocity value must be Vector3");

        if p76 ~= p76 or p76.Magnitude < 0.001 then
            p76 = Vector3.new(0, 0.0010000000474974513, 0);
        end;

        p75.Values.Velocity = p76;

        if v79 then
            v78.Velocity = p76;
        end;
    elseif p75.Type == "BodyPosition" or p75.Type == "AlignPosition" then
        local v81 = typeof(p76) == "Vector3";
        assert(v81, "BodyPosition/AlignPosition value must be Vector3");
        p75.Values.Position = p76;

        if v79 then
            v78.Position = p76;
        end;
    elseif p75.Type == "BodyGyro" then
        local v82 = typeof(p76) == "CFrame";
        assert(v82, "BodyGyro value must be CFrame");
        p75.Values.CFrame = p76;

        if v79 then
            v78.CFrame = p76;
        end;
    end;
end;

function u3.Enable(p83) -- Line: 579
    -- upvalues: getServerPlayerFromCharacter (copy), BodyMover (copy), Encode (copy), u2 (copy)
    local v84 = getServerPlayerFromCharacter(p83.Character);

    if v84 then
        BodyMover:FireClient(v84, Encode(p83), "Enable");

        return;
    end;

    p83.Enabled = true;
    u2.UpdateAll(p83.Parent, 0);
end;

function u3.Disable(p85) -- Line: 590
    -- upvalues: getServerPlayerFromCharacter (copy), BodyMover (copy), Encode (copy), u2 (copy)
    local v86 = getServerPlayerFromCharacter(p85.Character);

    if v86 then
        BodyMover:FireClient(v86, Encode(p85), "Disable");

        return;
    end;

    p85.Enabled = false;
    u2.UpdateAll(p85.Parent, 0);
end;

function u3.Destroy(p87) -- Line: 601
    -- upvalues: getServerPlayerFromCharacter (copy), u7 (copy), BodyMover (copy), Encode (copy), u2 (copy)
    if p87.DestroyCallback then
        task.spawn(p87.DestroyCallback);
    end;

    local v88 = getServerPlayerFromCharacter(p87.Character);

    if v88 then
        if not u7 then
            BodyMover:FireClient(v88, Encode(p87), "Destroy");
        end;

        return;
    end;

    p87.Removing = true;
    u2.UpdateAll(p87.Parent, 0);
end;

function u3._SetActive(u89, u90) -- Line: 618
    -- upvalues: u4 (copy)
    local Parent = u89.Parent;
    local u91 = Parent.Parent[u89.Type];

    local function applyValues() -- Line: 623
        -- upvalues: u89 (copy), u91 (copy)
        for i, v in pairs(u89.Values) do
            if i ~= "ID" and (i ~= "Character" and (i ~= "FaceCameraAtEnd" and (i ~= "StopOnCollision" and (i ~= "FollowVelocity" and (i ~= "MaxForce" and (i ~= "MaxTorque" and (i ~= "_D" and (i ~= "DestroyCallback" and i ~= "Meta")))))))) then
                u91[i] = v;
            end;
        end;
    end;

    if u90 then
        applyValues();
    end;

    for i, v in pairs(u89.Values) do
        if i == "MaxForce" or (i == "MaxTorque" or i == "P") then
            u91[i] = v * (u90 and 1 or 0);
        end;
    end;

    local success, result = pcall(function() -- Line: 652
        -- upvalues: u91 (copy), u90 (copy), Parent (copy)
        local v92;

        if u90 then
            v92 = Parent.Parent.Parent;
        else
            v92 = nil;
        end;

        u91.Parent = v92;
    end);

    if not (success or tostring(result):match("current parent: NULL")) then
        u4:AtWarning():Log((tostring(result)));
    end;
end;

if RunService:IsServer() and v5 then
    RunService.Heartbeat:Connect(function(p93) -- Line: 662
        -- upvalues: u2 (copy)
        u2.UpdateAll({}, p93);
    end);
elseif RunService:IsClient() and v5 then
    RunService.RenderStepped:Connect(function(p94) -- Line: 666
        -- upvalues: u2 (copy)
        u2.UpdateAll({}, p94);
    end);
end;

if RunService:IsClient() and v5 then
    task.spawn(function() -- Line: 672
        -- upvalues: BodyMover (copy), Encode (copy), Players (copy), u2 (copy), u3 (copy)
        local u95 = {};
        BodyMover.OnClientEvent:Connect(function(p96, p97, ...) -- Line: 682
            -- upvalues: Encode (ref), Players (ref), u2 (ref), u95 (copy), u3 (ref)
            local u98 = Encode(p96);

            if u98.Character ~= Players.LocalPlayer.Character then
                return;
            end;

            local v99 = u2.new(u98.Character, u98.Meta);

            if p97 == "Create" then
                local v100, v101 = ...;
                local v102 = type(v100) == "string";
                assert(v102, "Remote Create moverType must be a string");
                local v103 = type(v101) == "table";
                assert(v103, "Remote Create moverProperties must be a table");
                local u104 = u2.Create(v99, v100, v101);
                u95[u98.ID] = u104;

                if u104.Duration and u104.Duration < 1000000 then
                    task.delay(u104.Duration + 0.1, function() -- Line: 701
                        -- upvalues: u95 (ref), u98 (copy), u3 (ref), u104 (copy)
                        if u95[u98.ID] then
                            u3.Destroy(u104);
                            u95[u98.ID] = nil;
                        end;
                    end);
                end;
            elseif p97 == "Set" then
                local v105 = u95[u98.ID];

                if v105 then
                    u3.Set(v105, ...);
                end;
            elseif p97 == "Enable" then
                local v106 = u95[u98.ID];

                if v106 then
                    u3.Enable(v106);
                end;
            elseif p97 == "Disable" then
                local v107 = u95[u98.ID];

                if v107 then
                    u3.Disable(v107);
                end;
            else
                local v108 = p97 == "Destroy" and u95[u98.ID];

                if v108 then
                    u3.Destroy(v108);
                    u95[u98.ID] = nil;
                end;
            end;
        end);
    end);
end;

return {
    new = u2.new,
    GetActive = u2.GetActive,
    UpdateAll = u2.UpdateAll
};