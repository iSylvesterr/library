-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Easing = require(ReplicatedStorage.Library.Functions.Easing);
local Signal = require(ReplicatedStorage.Library.Signal);
local GuardAreaLookupUtil = require(ReplicatedStorage.Library.Util.GuardAreaLookupUtil);
local Player = require(ReplicatedStorage.Library.Player);
local RenderStepped = require(ReplicatedStorage.Library.Functions.RenderStepped);
local Signal2 = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local ON_CLIENT_TELEPORT_COMPLETED = Signal.MAP.Client.ClientCharacter.ON_CLIENT_TELEPORT_COMPLETED;
local __OBJECTS = Workspace.__OBJECTS;
local v1 = __OBJECTS:IsA("Folder");
assert(v1, "Workspace.__OBJECTS must be a Folder");
local Areas = __OBJECTS.Areas;
local v2 = Areas:IsA("Folder");
assert(v2, "Workspace.__OBJECTS.Areas must be a Folder");
local SeparationLine = Areas.SeparationLine;
local v3 = SeparationLine:IsA("BasePart");
assert(v3, "Workspace.__OBJECTS.Areas.SeparationLine must be a BasePart");
local WallStartVisual = Areas.WallStartVisual;
local v4 = WallStartVisual:IsA("BasePart");
assert(v4, "Workspace.__OBJECTS.Areas.WallStartVisual must be a BasePart");
local WallStartCollision = Areas.WallStartCollision;
local Size = WallStartVisual.Size;
local u5 = WallStartVisual.CFrame * CFrame.new(0, -Size.Y * 0.5, 0);
local u6 = nil;
local u7 = false;
local LocalPlayer = Players.LocalPlayer;
WallStartVisual.CanCollide = false;
local u8 = {
    Changed = Signal2.new()
};

local function wallHeight(p9) -- Line: 47
    -- upvalues: Size (copy), WallStartVisual (copy), u5 (copy)
    local v10 = math.clamp(p9, 0, Size.Y);
    WallStartVisual.Size = Vector3.new(Size.X, v10, Size.Z);
    WallStartVisual.CFrame = u5 * CFrame.new(0, v10 * 0.5, 0);
end;

local function collisionState(p11) -- Line: 53
    -- upvalues: WallStartCollision (copy)
    if WallStartCollision:IsA("BasePart") then
        WallStartCollision.CanCollide = p11;
    end;

    for _, descendant in ipairs(WallStartCollision:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = p11;
        end;
    end;
end;

local function currentPlayerIsOutsideGameplay() -- Line: 64
    -- upvalues: Player (copy), LocalPlayer (copy), GuardAreaLookupUtil (copy), SeparationLine (copy)
    local v12 = Player.Optional.HumanoidRootPart(LocalPlayer);

    if v12 == nil then
        return false;
    end;

    return not GuardAreaLookupUtil.IsInGameplaySide(SeparationLine, v12.Position);
end;

local function publishClosed(p13) -- Line: 72
    -- upvalues: u7 (ref), u8 (copy)
    if u7 == p13 then
        return;
    end;

    u7 = p13;
    u8.Changed:Fire(u7);
end;

local function interruptAnimation() -- Line: 80
    -- upvalues: u6 (ref)
    if u6 ~= nil then
        u6:Disconnect();
        u6 = nil;
    end;
end;

local function animateHeight(u14, u15, p16, u17, u18) -- Line: 87
    -- upvalues: u6 (ref), Size (copy), WallStartVisual (copy), u5 (copy), RenderStepped (copy), Easing (copy)
    if u6 ~= nil then
        u6:Disconnect();
        u6 = nil;
    end;

    local v19 = math.clamp(u14, 0, Size.Y);
    WallStartVisual.Size = Vector3.new(Size.X, v19, Size.Z);
    WallStartVisual.CFrame = u5 * CFrame.new(0, v19 * 0.5, 0);
    local v24 = RenderStepped(function(p20, p21) -- Line: 96
        -- upvalues: Easing (ref), u17 (copy), u18 (copy), u14 (copy), u15 (copy), Size (ref), WallStartVisual (ref), u5 (ref)
        local v22 = Easing(p21, u17, u18);
        local v23 = math.clamp(u14 + (u15 - u14) * v22, 0, Size.Y);
        WallStartVisual.Size = Vector3.new(Size.X, v23, Size.Z);
        WallStartVisual.CFrame = u5 * CFrame.new(0, v23 * 0.5, 0);

        return false;
    end, p16, true);
    u6 = v24;
    v24:Wait();

    if u6 == v24 then
        u6 = nil;
        local v25 = math.clamp(u15, 0, Size.Y);
        WallStartVisual.Size = Vector3.new(Size.X, v25, Size.Z);
        WallStartVisual.CFrame = u5 * CFrame.new(0, v25 * 0.5, 0);
    end;
end;

function u8.GetVisualWallPart() -- Line: 113
    -- upvalues: WallStartVisual (copy)
    return WallStartVisual;
end;

function u8.IsClosed() -- Line: 117
    -- upvalues: u7 (ref)
    return u7;
end;

function u8.PrepareReveal() -- Line: 121
    -- upvalues: u6 (ref), collisionState (copy), Player (copy), LocalPlayer (copy), GuardAreaLookupUtil (copy), SeparationLine (copy), u7 (ref), u8 (copy), Size (copy), WallStartVisual (copy), u5 (copy)
    if u6 ~= nil then
        u6:Disconnect();
        u6 = nil;
    end;

    local v26 = Player.Optional.HumanoidRootPart(LocalPlayer);
    local v27;

    if v26 == nil then
        v27 = false;
    else
        v27 = not GuardAreaLookupUtil.IsInGameplaySide(SeparationLine, v26.Position);
    end;

    collisionState(v27);

    if u7 ~= true then
        u7 = true;
        u8.Changed:Fire(u7);
    end;

    local v28 = math.clamp(0, 0, Size.Y);
    WallStartVisual.Size = Vector3.new(Size.X, v28, Size.Z);
    WallStartVisual.CFrame = u5 * CFrame.new(0, v28 * 0.5, 0);
end;

function u8.Reveal() -- Line: 128
    -- upvalues: animateHeight (copy), Size (copy)
    animateHeight(0, Size.Y, 1, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out);
end;

function u8.GetVisualWall() -- Line: 132
    -- upvalues: WallStartVisual (copy)
    return WallStartVisual;
end;

function u8.Collapse() -- Line: 136
    -- upvalues: collisionState (copy), u7 (ref), u8 (copy), animateHeight (copy), WallStartVisual (copy)
    collisionState(false);

    if u7 ~= false then
        u7 = false;
        u8.Changed:Fire(u7);
    end;

    animateHeight(WallStartVisual.Size.Y, 0, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
end;

function u8.Reset() -- Line: 142
    -- upvalues: u6 (ref), collisionState (copy), u7 (ref), u8 (copy), Size (copy), WallStartVisual (copy), u5 (copy)
    if u6 ~= nil then
        u6:Disconnect();
        u6 = nil;
    end;

    collisionState(false);

    if u7 ~= false then
        u7 = false;
        u8.Changed:Fire(u7);
    end;

    local v29 = math.clamp(0, 0, Size.Y);
    WallStartVisual.Size = Vector3.new(Size.X, v29, Size.Z);
    WallStartVisual.CFrame = u5 * CFrame.new(0, v29 * 0.5, 0);
end;

Signal.Fired(ON_CLIENT_TELEPORT_COMPLETED):Connect(function() -- Line: 153
    -- upvalues: u7 (ref), Player (copy), LocalPlayer (copy), GuardAreaLookupUtil (copy), SeparationLine (copy), collisionState (copy)
    if u7 then
        local v30 = Player.Optional.HumanoidRootPart(LocalPlayer);
        local v31;

        if v30 == nil then
            v31 = false;
        else
            v31 = not GuardAreaLookupUtil.IsInGameplaySide(SeparationLine, v30.Position);
        end;

        if v31 then
            collisionState(true);
        end;
    end;
end);

return u8;