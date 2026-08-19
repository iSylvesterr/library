-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Constructors = script:WaitForChild("Constructors");
local Connections = Constructors:WaitForChild("Connections");
local Declarations = Constructors:WaitForChild("Declarations");
local Memory = Constructors:WaitForChild("Memory");
local States = Constructors:WaitForChild("States");
local Utilities = Constructors:WaitForChild("Utilities");
local Modules = script:WaitForChild("Modules");
require(Modules:WaitForChild("Types"));
local New = require(Declarations:WaitForChild("New"));
local Children = require(Declarations:WaitForChild("Children"));
local Value = require(States:WaitForChild("Value"));
local Computed = require(States:WaitForChild("Computed"));
local Spring = require(States.Animation:WaitForChild("Spring"));
local Tween = require(States.Animation:WaitForChild("Tween"));
local Scope = require(Memory:WaitForChild("Scope"));
local OnEvent = require(Connections:WaitForChild("OnEvent"));
local OnChanged = require(Connections:WaitForChild("OnChanged"));
local Attribute = require(Declarations:WaitForChild("Attribute"));
local OnAttributeChanged = require(Connections:WaitForChild("OnAttributeChanged"));
local Lifetime = require(Declarations:WaitForChild("Lifetime"));
local Rendered = require(States:WaitForChild("Rendered"));
local FollowProperty = require(Declarations:WaitForChild("FollowProperty"));
local FollowAttribute = require(Declarations:WaitForChild("FollowAttribute"));
local GetValue = require(Utilities:WaitForChild("GetValue"));
local Component = require(Declarations:WaitForChild("Component"));
local Tags = require(Declarations:WaitForChild("Tags"));
local SetValue = require(Utilities:WaitForChild("SetValue"));
local IsState = require(Utilities:WaitForChild("IsState"));
local IsComponent = require(Utilities:WaitForChild("IsComponent"));
local LockValue = require(Utilities:WaitForChild("LockValue"));
local Inspect = require(Utilities:WaitForChild("Inspect"));
local OnAttached = require(Connections:WaitForChild("OnAttached"));
local Destroyed = require(Declarations:WaitForChild("Destroyed"));
local EventSequence = require(Declarations:WaitForChild("EventSequence"));
local ForPairs = require(States:WaitForChild("ForPairs"));
local v1 = {};

local function Init() -- Line: 119
    -- upvalues: RunService (copy)
    if RunService:IsServer() then
        return;
    end;

    if not game:IsLoaded() then
        game.Loaded:Wait();
    end;
end;

v1.New = New;
v1.Children = Children;
v1.Value = Value;
v1.Computed = Computed;
v1.Spring = Spring;
v1.Tween = Tween;
v1.Scope = Scope;
v1.OnEvent = OnEvent;
v1.OnChanged = OnChanged;
v1.Attribute = Attribute;
v1.OnAttributeChanged = OnAttributeChanged;
v1.Lifetime = Lifetime;
v1.Rendered = Rendered;
v1.FollowProperty = FollowProperty;
v1.FollowAttribute = FollowAttribute;
v1.GetValue = GetValue;
v1.Component = Component;
v1.Tags = Tags;
v1.SetValue = SetValue;
v1.IsState = IsState;
v1.IsComponent = IsComponent;
v1.LockValue = LockValue;
v1.Inspect = Inspect;
v1.OnAttached = OnAttached;
v1.Destroyed = Destroyed;
v1.EventSequence = EventSequence;
v1.ForPairs = ForPairs;

if RunService:IsServer() then
    return v1;
end;

if not game:IsLoaded() then
    game.Loaded:Wait();
end;

return v1;