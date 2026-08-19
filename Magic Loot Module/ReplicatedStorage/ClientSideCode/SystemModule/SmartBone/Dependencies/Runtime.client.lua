-- Decompiled with Potassium's decompiler.

local Parent = script.Parent;
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = false;
local u6 = {};

local function c(p7) -- Line: 11
    -- upvalues: u6 (copy)
    table.insert(u6, p7);
end;

local function cleanup() -- Line: 15
    -- upvalues: u6 (copy)
    for _, v in u6 do
        v:Disconnect();
    end;
end;

local u8 = nil;
u8 = Parent:BindToMessage("Setup", function(p9, p10, p11) -- Line: 22
    -- upvalues: u1 (ref), u2 (ref), u3 (ref), u4 (ref), u5 (ref), u8 (ref)
    u1 = p9;
    u2 = p10;
    u3 = p11;
    u4 = require(p11);
    u5 = true;
    u8:Disconnect();
end);

repeat
    task.wait();
until u5;

local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local u12 = u4.new();
local Dependencies = u3.Dependencies;
local DebugUi = require(Dependencies.Debug.DebugUi);
local Config = require(Dependencies.Config);
local Utilities = require(Dependencies.Utilities);
local u13 = RunService:IsStudio() or Config.ALLOW_LIVE_GAME_DEBUG;
local OverlayEvent = u3:WaitForChild("OverlayEvent");
local u14 = false;
local u15 = {
    Begin = function(...) -- Line: 52, Name: Begin
        -- upvalues: OverlayEvent (copy)
        OverlayEvent:Fire("Begin", ...);
    end,

    End = function(...) -- Line: 55, Name: End
        -- upvalues: OverlayEvent (copy)
        OverlayEvent:Fire("End", ...);
    end,

    Text = function(...) -- Line: 58, Name: Text
        -- upvalues: OverlayEvent (copy)
        OverlayEvent:Fire("Text", ...);
    end
};
shared.FrameCounter = 0;
local u16;

if u13 then
    u16 = require(Dependencies.Iris);

    if not u16.HasInit() then
        u16 = u16.Init();
    end;
else
    u16 = nil;
end;

Parent.Name = `{u1.Name} - {u12.ID}`;
u12:LoadObject(u1);

for _, v in u2 do
    u12:LoadRawCollider(v[1], v[2]);
end;

local u17 = u13 and {
    DRAW_BONE = u16.State(false),
    DRAW_PHYSICAL_BONE = u16.State(false),
    DRAW_ROOT_PART = u16.State(false),
    DRAW_BOUNDING_BOX = u16.State(false),
    DRAW_AXIS_LIMITS = u16.State(false),
    DRAW_COLLIDERS = u16.State(false),
    DRAW_COLLIDER_INFLUENCE = u16.State(false),
    DRAW_COLLIDER_AWAKE = u16.State(false),
    DRAW_COLLIDER_BROADPHASE = u16.State(false),
    DRAW_FILL_COLLIDERS = u16.State(false),
    DRAW_CONTACTS = u16.State(false),
    DRAW_ROTATION_LIMITS = u16.State(false),
    DRAW_ACCELERATION_INFO = u16.State(false)
} or nil;

if u13 then
    u16:Connect(function() -- Line: 104
        -- upvalues: u1 (ref), DebugUi (copy), u16 (ref), u12 (copy), u17 (ref)
        if u1:GetAttribute("Debug") ~= nil then
            DebugUi(u16, u12, u17);
        end;
    end);
end;

local v21 = CollectionService:GetInstanceAddedSignal("SmartCollider"):Connect(function(p18) -- Line: 111
    -- upvalues: u1 (ref), Utilities (copy), u12 (copy)
    if not p18:IsA("BasePart") then
        return;
    end;

    local v19 = p18:GetAttribute("ColliderKey");
    local v20 = u1:GetAttribute("ColliderKey");

    if tostring(v19) ~= tostring(v20) then
        return;
    end;

    u12:LoadRawCollider(Utilities.GetCollider(p18), p18);
end);
table.insert(u6, v21);
local v22 = Parent:BindToMessage("Destroy", function() -- Line: 128
    -- upvalues: u14 (ref)
    u14 = true;
end);
table.insert(u6, v22);
local v25 = RunService.Heartbeat:ConnectParallel(function(p23) -- Line: 132
    -- upvalues: u12 (copy), u14 (ref), u6 (copy), u13 (copy), u1 (ref), u17 (ref), u15 (copy)
    local v24 = shared;
    v24.FrameCounter = v24.FrameCounter + 1;

    if shared.FrameCounter > 131072 then
        shared.FrameCounter = 0;
    end;

    u12:StepBoneTrees(p23);

    if not (u12.ShouldDestroy or u14) then
        if u13 and u1:GetAttribute("Debug") ~= nil then
            task.synchronize();
            u12:DrawDebug(u17.DRAW_COLLIDERS:get(), u17.DRAW_CONTACTS:get(), u17.DRAW_PHYSICAL_BONE:get(), u17.DRAW_BONE:get(), u17.DRAW_AXIS_LIMITS:get(), u17.DRAW_ROOT_PART:get(), u17.DRAW_FILL_COLLIDERS:get(), u17.DRAW_COLLIDER_INFLUENCE:get(), u17.DRAW_COLLIDER_AWAKE:get(), u17.DRAW_COLLIDER_BROADPHASE:get(), u17.DRAW_BOUNDING_BOX:get(), u17.DRAW_ROTATION_LIMITS:get(), u17.DRAW_ACCELERATION_INFO:get());
            u12:DrawOverlay(u15);
        end;

        return;
    end;

    u12:Destroy();
    task.synchronize();

    for _, v in u6 do
        v:Disconnect();
    end;
end);
table.insert(u6, v25);