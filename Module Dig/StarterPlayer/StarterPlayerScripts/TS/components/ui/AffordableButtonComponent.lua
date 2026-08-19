-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local Component = v1.Component;
local BaseComponent = v1.BaseComponent;
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 24, Name: __tostring
        return "AffordableButtonComponent";
    end,

    __index = BaseComponent
});
u2.__index = u2;

function u2.new(...) -- Line: 30
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4, p5) -- Line: 34
    -- upvalues: BaseComponent (copy), Janitor (copy)
    BaseComponent.constructor(p4);
    p4.dataController = p5;
    p4.janitor = Janitor.new();
end;

function u2.ensureSharedTick(p6) -- Line: 39
    -- upvalues: u2 (ref), RunService (copy)
    if u2.tickStarted then
        return nil;
    end;

    u2.tickStarted = true;
    local u7 = 0;
    RunService.Heartbeat:Connect(function(p8) -- Line: 45
        -- upvalues: u7 (ref), u2 (ref)
        u7 = u7 + p8;

        if u7 < 0.1 then
            return nil;
        end;

        u7 = 0;

        for i in u2.active do
            i:refresh();
        end;
    end);
end;

function u2.onStart(u9) -- Line: 56
    -- upvalues: u2 (ref)
    local Green = u9.instance:FindFirstChild("Green");

    if Green and Green:IsA("UIGradient") then
        u9.greenGradient = Green;
    end;

    local Grey = u9.instance:FindFirstChild("Grey");

    if Grey and Grey:IsA("UIGradient") then
        u9.greyGradient = Grey;
    end;

    u9.janitor:Add(u9.instance:GetAttributeChangedSignal("cost"):Connect(function() -- Line: 65
        -- upvalues: u9 (copy)
        return u9:refresh();
    end), "Disconnect");
    u9.janitor:Add(u9.instance:GetAttributeChangedSignal("locked"):Connect(function() -- Line: 68
        -- upvalues: u9 (copy)
        return u9:refresh();
    end), "Disconnect");
    u2.active[u9] = true;
    u2:ensureSharedTick();
    u9:refresh();
end;

function u2.refresh(p10) -- Line: 79
    local v11 = p10.dataController:getDataIfLoaded();

    if not v11 then
        return nil;
    end;

    local cost = p10.attributes.cost;
    local v12 = not (p10.attributes.locked == true) and (cost == nil and (1 / 0) or cost) <= v11.Gold;

    if v12 == p10.lastAffordable then
        return nil;
    end;

    p10.lastAffordable = v12;

    if p10.greenGradient then
        p10.greenGradient.Enabled = v12;
    end;

    if p10.greyGradient then
        p10.greyGradient.Enabled = not v12;
    end;
end;

function u2.destroy(p13) -- Line: 103
    -- upvalues: u2 (ref)
    u2.active[p13] = nil;
    p13.janitor:Destroy();
end;

u2.active = {};
u2.tickStarted = false;
Reflect.defineMetadata(u2, "identifier", "client/components/ui/AffordableButtonComponent@AffordableButtonComponent");
Reflect.defineMetadata(u2, "flamework:parameters", { "client/controllers/data/DataController@DataController" });
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$c:components@Component", Component, {
    {
        tag = "AffordableButton",
        attributes = {
            cost = t.optional(t.number),
            locked = t.optional(t.boolean)
        },
        instanceGuard = t.instanceIsA("GuiButton")
    }
});

return {
    AffordableButtonComponent = u2
};