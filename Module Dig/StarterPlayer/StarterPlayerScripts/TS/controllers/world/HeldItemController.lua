-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players;
local Items = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items").Items;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 15, Name: __tostring
        return "HeldItemController";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 20
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3) -- Line: 24
    -- upvalues: Players (copy), Janitor (copy)
    p3.localPlayer = Players.LocalPlayer;
    p3.janitor = Janitor.new();
end;

function u1.onStart(u4) -- Line: 28
    if u4.localPlayer.Character then
        u4:bindCharacter(u4.localPlayer.Character);
    end;

    u4.localPlayer.CharacterAdded:Connect(function(p5) -- Line: 32
        -- upvalues: u4 (copy)
        return u4:bindCharacter(p5);
    end);
end;

function u1.bindCharacter(u6, u7) -- Line: 36
    u6.track = nil;
    u6.janitor:Add(u7.ChildAdded:Connect(function(p8) -- Line: 38
        -- upvalues: u6 (copy), u7 (copy)
        if p8:IsA("Tool") then
            u6:evaluate(u7);
        end;
    end), "Disconnect", "childAdded");
    u6.janitor:Add(u7.ChildRemoved:Connect(function(p9) -- Line: 43
        -- upvalues: u6 (copy), u7 (copy)
        if p9:IsA("Tool") then
            u6:evaluate(u7);
        end;
    end), "Disconnect", "childRemoved");
    u6:evaluate(u7);
end;

function u1.evaluate(p10, p11) -- Line: 50
    local v12 = p11:FindFirstChildOfClass("Tool");

    if v12 ~= nil and p10:isOverheadItem(v12) then
        p10:play(p11);

        return;
    end;

    local track = p10.track;

    if track ~= nil then
        track:Stop(0.15);
    end;
end;

function u1.isOverheadItem(p13, p14) -- Line: 61
    -- upvalues: Items (copy)
    local v15 = p14:GetAttribute("itemId");
    local v16 = v15 ~= nil;

    if v16 then
        local v17 = Items[v15];

        if v17 ~= nil then
            v17 = v17.holdOverhead;
        end;

        v16 = v17 == true;
    end;

    return v16;
end;

function u1.play(p18, p19) -- Line: 73
    if p18.track == nil then
        local v20 = p19:FindFirstChildOfClass("Humanoid");

        if v20 ~= nil then
            v20 = v20:WaitForChild("Animator", 5);
        end;

        if not v20 then
            return nil;
        end;

        local Animation = Instance.new("Animation");
        Animation.AnimationId = "rbxassetid://103263079021021";
        p18.track = v20:LoadAnimation(Animation);
        p18.track.Priority = Enum.AnimationPriority.Action;
        p18.track.Looped = true;
        Animation:Destroy();
    end;

    if not p18.track.IsPlaying then
        p18.track:Play(0.15);
    end;
end;

Reflect.defineMetadata(u1, "identifier", "client/controllers/world/HeldItemController@HeldItemController");
Reflect.defineMetadata(u1, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u1, "$:flamework@Controller", Controller, { {} });

return {
    HeldItemController = u1
};