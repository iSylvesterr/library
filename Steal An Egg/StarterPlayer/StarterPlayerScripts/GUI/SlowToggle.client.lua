-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Save = require(ReplicatedStorage.Library.Client.Save);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Tween = require(ReplicatedStorage.Library.Functions.Tween);
local u1 = Color3.fromRGB(0, 255, 0);
local LocalPlayer = Players.LocalPlayer;
local SlowToggle = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Elements"):WaitForChild("Left"):WaitForChild("Tools"):WaitForChild("SlowToggle");
local ImageButton = SlowToggle:WaitForChild("ImageButton");
local Circle = SlowToggle:WaitForChild("Circle");
local BackgroundColor3 = SlowToggle.BackgroundColor3;
local Position = Circle.Position;
local u2 = false;
local BASE_WALK_SPEED = Constants.BASE_WALK_SPEED;
local u3 = nil;
local u4 = nil;
local u5 = nil;

local function setToggleVisuals(p6) -- Line: 42
    -- upvalues: SlowToggle (copy), u1 (copy), Tween (copy), Circle (copy), Position (copy), BackgroundColor3 (copy)
    if p6 then
        SlowToggle.BackgroundColor3 = u1;
        Tween(Circle, {
            Position = UDim2.new(0.73, Position.X.Offset, Position.Y.Scale, Position.Y.Offset)
        }, { 0.15 });

        return;
    end;

    SlowToggle.BackgroundColor3 = BackgroundColor3;
    Tween(Circle, {
        Position = Position
    }, { 0.15 });
end;

local function reconcileSlowToggleState(p7) -- Line: 58
    -- upvalues: u2 (ref), setToggleVisuals (copy)
    if u2 == p7 then
        return;
    end;

    u2 = p7;
    setToggleVisuals(p7);
end;

local function updateSlowToggleVisibility(p8) -- Line: 67
    -- upvalues: u3 (ref), u2 (ref), SlowToggle (copy)
    local v9;

    if u3 == nil then
        v9 = u2 or p8 > 50;
    else
        v9 = false;
    end;

    SlowToggle.Visible = v9;

    return v9;
end;

local function resolveVisibleWalkSpeed() -- Line: 73
    -- upvalues: u4 (ref), BASE_WALK_SPEED (ref)
    local v10 = u4;

    if v10 == nil or (v10.Parent == nil or v10.Health <= 0) then
        return BASE_WALK_SPEED;
    end;

    return v10.WalkSpeed;
end;

local function refreshVisibilityFromCurrentWalkSpeed() -- Line: 82
    -- upvalues: u4 (ref), BASE_WALK_SPEED (ref), u3 (ref), u2 (ref), SlowToggle (copy)
    local v11 = u4;
    local v12;

    if v11 == nil or (v11.Parent == nil or v11.Health <= 0) then
        v12 = BASE_WALK_SPEED;
    else
        v12 = v11.WalkSpeed;
    end;

    local v13;

    if u3 == nil then
        v13 = u2 or v12 > 50;
    else
        v13 = false;
    end;

    SlowToggle.Visible = v13;
end;

local function applyServerSlowToggleState(p14, p15) -- Line: 86
    -- upvalues: BASE_WALK_SPEED (ref), u2 (ref), setToggleVisuals (copy), u4 (ref), u3 (ref), SlowToggle (copy)
    BASE_WALK_SPEED = p15;

    if u2 ~= p14 then
        u2 = p14;
        setToggleVisuals(p14);
    end;

    local v16 = u4;
    local v17;

    if v16 == nil or (v16.Parent == nil or v16.Health <= 0) then
        v17 = BASE_WALK_SPEED;
    else
        v17 = v16.WalkSpeed;
    end;

    local v18;

    if u3 == nil then
        v18 = u2 or v17 > 50;
    else
        v18 = false;
    end;

    SlowToggle.Visible = v18;
end;

local function syncSlowToggleStateFromServer() -- Line: 92
    -- upvalues: Network (copy), Constants (copy), BASE_WALK_SPEED (ref), u2 (ref), setToggleVisuals (copy), u4 (ref), u3 (ref), SlowToggle (copy)
    local v19, v20 = Network.Invoke(Constants.NETWORK_MAP.Treadmills.REQUEST_GET_SLOW_TOGGLE_STATE);
    local v21 = typeof(v19) == "boolean";
    assert(v21, "Expected slow-toggle enabled state from server");
    local v22 = typeof(v20) == "number";
    assert(v22, "Expected slow-toggle restored walk speed from server");
    BASE_WALK_SPEED = v20;

    if u2 ~= v19 then
        u2 = v19;
        setToggleVisuals(v19);
    end;

    local v23 = u4;
    local v24;

    if v23 == nil or (v23.Parent == nil or v23.Health <= 0) then
        v24 = BASE_WALK_SPEED;
    else
        v24 = v23.WalkSpeed;
    end;

    local v25;

    if u3 == nil then
        v25 = u2 or v24 > 50;
    else
        v25 = false;
    end;

    SlowToggle.Visible = v25;
end;

local function setSlowToggleEnabled(p26) -- Line: 99
    -- upvalues: Network (copy), Constants (copy), BASE_WALK_SPEED (ref), u2 (ref), setToggleVisuals (copy), u4 (ref), u3 (ref), SlowToggle (copy)
    local v27, v28 = Network.Invoke(Constants.NETWORK_MAP.Treadmills.REQUEST_SET_SLOW_TOGGLE_ENABLED, p26);
    local v29 = typeof(v27) == "boolean";
    assert(v29, "Expected slow-toggle enabled state from server");
    local v30 = typeof(v28) == "number";
    assert(v30, "Expected slow-toggle restored walk speed from server");
    BASE_WALK_SPEED = v28;

    if u2 ~= v27 then
        u2 = v27;
        setToggleVisuals(v27);
    end;

    local v31 = u4;
    local v32;

    if v31 == nil or (v31.Parent == nil or v31.Health <= 0) then
        v32 = BASE_WALK_SPEED;
    else
        v32 = v31.WalkSpeed;
    end;

    local v33;

    if u3 == nil then
        v33 = u2 or v32 > 50;
    else
        v33 = false;
    end;

    SlowToggle.Visible = v33;
end;

local function bindHumanoid(p34) -- Line: 107
    -- upvalues: u5 (ref), u4 (ref), BASE_WALK_SPEED (ref), u3 (ref), u2 (ref), SlowToggle (copy)
    if u5 ~= nil then
        u5:Disconnect();
        u5 = nil;
    end;

    u4 = p34;
    u5 = p34:GetPropertyChangedSignal("WalkSpeed"):Connect(function() -- Line: 114
        -- upvalues: u4 (ref), BASE_WALK_SPEED (ref), u3 (ref), u2 (ref), SlowToggle (ref)
        local v35 = u4;
        local v36;

        if v35 == nil or (v35.Parent == nil or v35.Health <= 0) then
            v36 = BASE_WALK_SPEED;
        else
            v36 = v35.WalkSpeed;
        end;

        local v37;

        if u3 == nil then
            v37 = u2 or v36 > 50;
        else
            v37 = false;
        end;

        SlowToggle.Visible = v37;
    end);
    local v38 = u4;
    local v39;

    if v38 == nil or (v38.Parent == nil or v38.Health <= 0) then
        v39 = BASE_WALK_SPEED;
    else
        v39 = v38.WalkSpeed;
    end;

    local v40;

    if u3 == nil then
        v40 = u2 or v39 > 50;
    else
        v40 = false;
    end;

    SlowToggle.Visible = v40;
end;

local function connectCharacter(p41) -- Line: 120
    -- upvalues: bindHumanoid (copy), Network (copy), Constants (copy), BASE_WALK_SPEED (ref), u2 (ref), setToggleVisuals (copy), u4 (ref), u3 (ref), SlowToggle (copy)
    bindHumanoid((p41:WaitForChild("Humanoid")));
    local v42, v43 = Network.Invoke(Constants.NETWORK_MAP.Treadmills.REQUEST_GET_SLOW_TOGGLE_STATE);
    local v44 = typeof(v42) == "boolean";
    assert(v44, "Expected slow-toggle enabled state from server");
    local v45 = typeof(v43) == "number";
    assert(v45, "Expected slow-toggle restored walk speed from server");
    BASE_WALK_SPEED = v43;

    if u2 ~= v42 then
        u2 = v42;
        setToggleVisuals(v42);
    end;

    local v46 = u4;
    local v47;

    if v46 == nil or (v46.Parent == nil or v46.Health <= 0) then
        v47 = BASE_WALK_SPEED;
    else
        v47 = v46.WalkSpeed;
    end;

    local v48;

    if u3 == nil then
        v48 = u2 or v47 > 50;
    else
        v48 = false;
    end;

    SlowToggle.Visible = v48;
end;

ImageButton.Activated:Connect(function() -- Line: 130
    -- upvalues: u2 (ref), Network (copy), Constants (copy), BASE_WALK_SPEED (ref), setToggleVisuals (copy), u4 (ref), u3 (ref), SlowToggle (copy)
    local v49, v50 = Network.Invoke(Constants.NETWORK_MAP.Treadmills.REQUEST_SET_SLOW_TOGGLE_ENABLED, not u2);
    local v51 = typeof(v49) == "boolean";
    assert(v51, "Expected slow-toggle enabled state from server");
    local v52 = typeof(v50) == "number";
    assert(v52, "Expected slow-toggle restored walk speed from server");
    BASE_WALK_SPEED = v50;

    if u2 ~= v49 then
        u2 = v49;
        setToggleVisuals(v49);
    end;

    local v53 = u4;
    local v54;

    if v53 == nil or (v53.Parent == nil or v53.Health <= 0) then
        v54 = BASE_WALK_SPEED;
    else
        v54 = v53.WalkSpeed;
    end;

    local v55;

    if u3 == nil then
        v55 = u2 or v54 > 50;
    else
        v55 = false;
    end;

    SlowToggle.Visible = v55;
end);

if Save.IsLocalDataLoaded() then
    local v56, v57 = Network.Invoke(Constants.NETWORK_MAP.Treadmills.REQUEST_GET_SLOW_TOGGLE_STATE);
    local v58 = typeof(v56) == "boolean";
    assert(v58, "Expected slow-toggle enabled state from server");
    local v59 = typeof(v57) == "number";
    assert(v59, "Expected slow-toggle restored walk speed from server");
    BASE_WALK_SPEED = v57;

    if u2 ~= v56 then
        u2 = v56;
        setToggleVisuals(v56);
    end;

    local v60 = u4;
    local v61;

    if v60 == nil or (v60.Parent == nil or v60.Health <= 0) then
        v61 = BASE_WALK_SPEED;
    else
        v61 = v60.WalkSpeed;
    end;

    local v62;

    if u3 == nil then
        v62 = u2 or v61 > 50;
    else
        v62 = false;
    end;

    SlowToggle.Visible = v62;
else
    Save.LoadedStats:Connect(syncSlowToggleStateFromServer);
end;

Network.Fired(Constants.NETWORK_MAP.Treadmills.ACTIVE_TREADMILL_EVENT):Connect(function(p63) -- Line: 144
    -- upvalues: u3 (ref), u4 (ref), BASE_WALK_SPEED (ref), u2 (ref), SlowToggle (copy)
    u3 = p63;
    local v64 = u4;
    local v65;

    if v64 == nil or (v64.Parent == nil or v64.Health <= 0) then
        v65 = BASE_WALK_SPEED;
    else
        v65 = v64.WalkSpeed;
    end;

    local v66;

    if u3 == nil then
        v66 = u2 or v65 > 50;
    else
        v66 = false;
    end;

    SlowToggle.Visible = v66;
end);

if LocalPlayer.Character ~= nil then
    bindHumanoid((LocalPlayer.Character:WaitForChild("Humanoid")));
    local v67, v68 = Network.Invoke(Constants.NETWORK_MAP.Treadmills.REQUEST_GET_SLOW_TOGGLE_STATE);
    local v69 = typeof(v67) == "boolean";
    assert(v69, "Expected slow-toggle enabled state from server");
    local v70 = typeof(v68) == "number";
    assert(v70, "Expected slow-toggle restored walk speed from server");
    BASE_WALK_SPEED = v68;

    if u2 ~= v67 then
        u2 = v67;
        setToggleVisuals(v67);
    end;

    local v71 = u4;
    local v72;

    if v71 == nil or (v71.Parent == nil or v71.Health <= 0) then
        v72 = BASE_WALK_SPEED;
    else
        v72 = v71.WalkSpeed;
    end;

    local v73;

    if u3 == nil then
        v73 = u2 or v72 > 50;
    else
        v73 = false;
    end;

    SlowToggle.Visible = v73;
end;

LocalPlayer.CharacterAdded:Connect(connectCharacter);