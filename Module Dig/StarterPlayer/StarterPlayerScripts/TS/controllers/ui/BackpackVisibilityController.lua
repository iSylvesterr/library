-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local FrameComponent = RuntimeLib.import(script, script.Parent.Parent.Parent, "components", "ui", "FrameComponent").FrameComponent;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 12, Name: __tostring
        return "BackpackVisibilityController";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 17
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3) -- Line: 21
    p3.hideReasons = {};
end;

function u1.onStart(u4) -- Line: 24
    -- upvalues: FrameComponent (copy)
    task.spawn(function() -- Line: 25
        -- upvalues: u4 (copy)
        return u4:resolveGui();
    end);
    FrameComponent.onOpened.Event:Connect(function() -- Line: 28
        -- upvalues: u4 (copy)
        return u4:setHidden("menu", true);
    end);
    FrameComponent.onFullyClosed.Event:Connect(function() -- Line: 31
        -- upvalues: FrameComponent (ref), u4 (copy)
        if FrameComponent.activeFrame == nil then
            u4:setHidden("menu", false);
        end;
    end);
end;

function u1.setHidden(p5, p6, p7) -- Line: 37
    if p7 == (p5.hideReasons[p6] ~= nil) then
        return nil;
    end;

    if p7 then
        if next(p5.hideReasons) == nil then
            local backpackGui = p5.backpackGui;

            if backpackGui ~= nil then
                backpackGui = backpackGui.Enabled;
            end;

            p5.savedEnabled = backpackGui;
        end;

        p5.hideReasons[p6] = true;
    else
        p5.hideReasons[p6] = nil;
    end;

    p5:apply();
end;

function u1.resolveGui(u8) -- Line: 62
    -- upvalues: PlayerGui (copy)
    local BackpackGui = PlayerGui:WaitForChild("BackpackGui", 30);
    local v9;

    if BackpackGui == nil then
        v9 = BackpackGui;
    else
        v9 = BackpackGui:IsA("ScreenGui");
    end;

    if v9 then
        u8:bind(BackpackGui);
    end;

    PlayerGui.ChildAdded:Connect(function(p10) -- Line: 71
        -- upvalues: u8 (copy)
        if p10.Name == "BackpackGui" and p10:IsA("ScreenGui") then
            u8:bind(p10);
        end;
    end);
end;

function u1.bind(p11, p12) -- Line: 77
    p11.backpackGui = p12;

    if next(p11.hideReasons) ~= nil then
        p11.savedEnabled = p12.Enabled;
    end;

    p11:apply();
end;

function u1.apply(p13) -- Line: 84
    local backpackGui = p13.backpackGui;
    local v14;

    if backpackGui == nil then
        v14 = backpackGui;
    else
        v14 = backpackGui.Parent;
    end;

    if not v14 then
        return nil;
    end;

    if next(p13.hideReasons) ~= nil then
        backpackGui.Enabled = false;

        return nil;
    end;

    if p13.savedEnabled == nil then
        return nil;
    end;

    backpackGui.Enabled = p13.savedEnabled;
    p13.savedEnabled = nil;
end;

Reflect.defineMetadata(u1, "identifier", "client/controllers/ui/BackpackVisibilityController@BackpackVisibilityController");
Reflect.defineMetadata(u1, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u1, "$:flamework@Controller", Controller, { {} });

return {
    BackpackVisibilityController = u1
};