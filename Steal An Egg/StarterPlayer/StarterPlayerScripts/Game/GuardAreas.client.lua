-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local GuardComponent = require(script.GuardComponent);
local GuardEscapeSignController = require(script.GuardEscapeSignController);
local ForestGuardRuntime = require(script.ForestGuardRuntime);
local GuardTutorialController = require(script.GuardTutorialController);
local Network = require(ReplicatedStorage.Library.Client.Network);
local RequiredSpeedSign = require(script.Parent.Parent.GUI.GuardAreas.RequiredSpeedSign);
local Guards = require(ReplicatedStorage.Library.Globals.Constants).NETWORK_MAP.Guards;
local u1 = {};
local u2 = {};
local v3 = GuardTutorialController.new();
local __OBJECTS = Workspace:WaitForChild("__OBJECTS");
local v4 = __OBJECTS:IsA("Folder");
assert(v4, "Workspace.__OBJECTS must be a Folder");
local Areas = __OBJECTS.Areas;
local v5 = Areas:IsA("Folder");
assert(v5, "Workspace.__OBJECTS.Areas must be a Folder");
local GuardAreas = Areas.GuardAreas;
local v6 = GuardAreas:IsA("Folder");
assert(v6, "Workspace.__OBJECTS.Areas.GuardAreas must be a Folder");

local function setupAreaModel(u7) -- Line: 46
    -- upvalues: u1 (copy), ForestGuardRuntime (copy), GuardComponent (copy), GuardAreas (copy), u2 (copy), RequiredSpeedSign (copy), GuardEscapeSignController (copy)
    if u1[u7] ~= nil then
        return;
    end;

    local v8 = nil;
    local u9;

    if u7.Name == "Forest" then
        v8 = ForestGuardRuntime.new(u7);
        u9 = GuardComponent.new(u7);
        v8:SetWakeHandler(function(p10) -- Line: 57
            -- upvalues: u9 (ref)
            u9:PlayWakeUp();
        end);
    else
        u9 = GuardComponent.new(u7);
    end;

    if u7.Parent ~= GuardAreas then
        u9:Destroy();

        if v8 ~= nil then
            v8:Destroy();
        end;

        return;
    end;

    local u11 = {
        GuardEscapeSignController = nil,
        RequiredSpeedSign = nil,
        ForestRuntime = v8,
        Guard = u9
    };
    u1[u7] = u11;
    u2[u9:GetGuardModel()] = u9;

    if v8 ~= nil then
        v8:Start();
    end;

    local Position = u9:GetGuardModel().HumanoidRootPart.Position;
    task.spawn(function() -- Line: 85
        -- upvalues: RequiredSpeedSign (ref), u7 (copy), GuardEscapeSignController (ref), Position (copy), u1 (ref), u11 (copy), GuardAreas (ref)
        local v12 = RequiredSpeedSign.new(u7);
        local v13 = GuardEscapeSignController.new(u7, Position, v12);

        if u1[u7] == u11 and u7.Parent == GuardAreas then
            u11.GuardEscapeSignController = v13;
            u11.RequiredSpeedSign = v12;

            return;
        end;

        v13:Destroy();
        v12:Destroy();
    end);
end;

local function cleanupAreaModel(p14) -- Line: 98
    -- upvalues: u1 (copy), u2 (copy)
    local v15 = u1[p14];

    if v15 == nil then
        return;
    end;

    u1[p14] = nil;
    u2[v15.Guard:GetGuardModel()] = nil;
    local GuardEscapeSignController2 = v15.GuardEscapeSignController;

    if GuardEscapeSignController2 ~= nil then
        v15.GuardEscapeSignController = nil;
        GuardEscapeSignController2:Destroy();
    end;

    local RequiredSpeedSign2 = v15.RequiredSpeedSign;

    if RequiredSpeedSign2 ~= nil then
        v15.RequiredSpeedSign = nil;
        RequiredSpeedSign2:Destroy();
    end;

    v15.Guard:Destroy();

    if v15.ForestRuntime ~= nil then
        v15.ForestRuntime:Destroy();
    end;
end;

for _, child in ipairs(GuardAreas:GetChildren()) do
    local v16 = child:IsA("Model");
    local v17 = `{child:GetFullName()} must be a guard area Model`;
    assert(v16, v17);
    task.spawn(setupAreaModel, child);
end;

GuardAreas.ChildAdded:Connect(function(p18) -- Line: 131
    -- upvalues: setupAreaModel (copy)
    local v19 = p18:IsA("Model");
    local v20 = `{p18:GetFullName()} must be a guard area Model`;
    assert(v19, v20);
    setupAreaModel(p18);
end);
GuardAreas.ChildRemoved:Connect(function(p21) -- Line: 136
    -- upvalues: cleanupAreaModel (copy)
    local v22 = p21:IsA("Model");
    local v23 = `{p21:GetFullName()} must be a guard area Model`;
    assert(v22, v23);
    cleanupAreaModel(p21);
end);
Network.Fired(Guards.WAKE_UP):Connect(function(p24) -- Line: 141
    -- upvalues: u2 (copy)
    local v25 = u2[p24];

    if v25 == nil then
        return;
    end;

    v25:PlayWakeUp();
end);
v3:Start();