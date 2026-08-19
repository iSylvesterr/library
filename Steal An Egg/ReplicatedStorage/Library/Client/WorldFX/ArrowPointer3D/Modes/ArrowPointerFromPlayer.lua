-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Library.Modules.Packages.Promise);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Parent = require(script.Parent.Parent);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local WaitFor = require(ReplicatedStorage.Library.Modules.Packages.WaitFor);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local FuncWrapper = require(ReplicatedStorage.Library.Modules.FuncWrapper);
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
u2.__index = u2;
u2.__class = "ArrowPointerFromPlayer";

function u2.new(p3, p4, p5) -- Line: 41
    -- upvalues: Parent (copy), u2 (copy), Trove (copy), FuncWrapper (copy), LocalPlayer (copy), Asserts (copy)
    assert(Parent.__types.OptionalConfig(p4));
    p4.CleanupOnPartDestroyed = false;
    local v6 = setmetatable({}, u2);
    v6._trove = Trove.new();
    v6._funcWrapper = FuncWrapper.CreateWrapper(v6);
    v6._trackedPlayer = p5 or LocalPlayer;
    Asserts.Player(v6._trackedPlayer);
    v6._arrowPointer = v6._trove:Add((Parent.new(p3, nil, p4)));
    v6._waitForRootPromise = nil;
    v6:_init();

    return v6;
end;

function u2._onCharacterAdded(u7, p8) -- Line: 68
    -- upvalues: Asserts (copy), u1 (copy), WaitFor (copy)
    Asserts.Model(p8);

    if u7._waitForRootPromise then
        u7._waitForRootPromise:cancel();
    end;

    u1:AtTrace():Log("character added:", p8);
    u7._waitForRootPromise = u7._trove:AddPromise((WaitFor.Child(p8, "HumanoidRootPart"))):andThen(function(p9) -- Line: 79
        -- upvalues: u1 (ref), Asserts (ref), u7 (copy)
        u1:AtTrace():Log("changing target to:", p9);
        Asserts.BasePart(p9);
        u7._arrowPointer:ChangeOrigin(p9);
    end):catch(function(p10) -- Line: 85
        -- upvalues: u1 (ref)
        u1:AtWarning():Log((`Failed to fetch root for arrow tracking: {p10}`));
    end);
end;

function u2._onCharacterRemoving(p11) -- Line: 90
    if p11._waitForRootPromise then
        p11._waitForRootPromise:cancel();
    end;

    p11._arrowPointer:Stop();
end;

function u2.Start(p12) -- Line: 98
    return p12._arrowPointer:Start();
end;

function u2.Stop(p13) -- Line: 102
    return p13._arrowPointer:Stop();
end;

function u2.ChangeTarget(p14, p15) -- Line: 106
    return p14._arrowPointer:ChangeTarget(p15);
end;

function u2.Destroy(p16) -- Line: 110
    p16._trove:Destroy();
    table.clear(p16);
    setmetatable(p16, nil);
end;

function u2._init(p17) -- Line: 121
    local Character = p17._trackedPlayer.Character;

    if Character then
        p17:_onCharacterAdded(Character);
    end;

    p17._trove:Connect(p17._trackedPlayer.CharacterAdded, p17._funcWrapper(p17._onCharacterAdded));
    p17._trove:Connect(p17._trackedPlayer.CharacterRemoving, p17._funcWrapper(p17._onCharacterRemoving));

    return p17;
end;

return u2;