-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local FrameComponent = RuntimeLib.import(script, script.Parent.Parent.Parent, "components", "ui", "FrameComponent").FrameComponent;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u1 = Color3.new(1, 1, 1);
local u2 = Color3.new(0, 0, 0);
local u3 = { "LeftButtons", "RightButtons" };
local u4 = setmetatable({}, {
    __tostring = function() -- Line: 14, Name: __tostring
        return "LeftButtonsController";
    end
});
u4.__index = u4;

function u4.new(...) -- Line: 19
    -- upvalues: u4 (ref)
    local v5 = setmetatable({}, u4);

    return v5:constructor(...) or v5;
end;

function u4.constructor(p6) -- Line: 23
    p6.strokesByFrame = {};
end;

function u4.onStart(u7) -- Line: 26
    -- upvalues: u3 (copy), WFChain (copy), PlayerGui (copy), FrameComponent (copy)
    for _, v in u3 do
        local v8 = WFChain(PlayerGui, "HUD", v);

        for _, child in v8:GetChildren() do
            u7:register(child);
        end;

        v8.ChildAdded:Connect(function(p9) -- Line: 32
            -- upvalues: u7 (copy)
            return u7:register(p9);
        end);
    end;

    FrameComponent.onOpened.Event:Connect(function(p10) -- Line: 36
        -- upvalues: u7 (copy)
        return u7:setSelected(p10, true);
    end);
    FrameComponent.onClosed.Event:Connect(function(p11) -- Line: 39
        -- upvalues: u7 (copy)
        return u7:setSelected(p11, false);
    end);
end;

function u4.register(p12, p13) -- Line: 43
    -- upvalues: u2 (copy), u1 (copy)
    if not p13:IsA("ImageButton") then
        return nil;
    end;

    local Frame = p13:FindFirstChild("Frame");

    if Frame ~= nil then
        Frame = Frame.Value;
    end;

    if not Frame then
        return nil;
    end;

    local UIStroke = p13:FindFirstChild("UIStroke");
    local Name = p13:FindFirstChild("Name");
    local v14;

    if Name == nil then
        v14 = Name;
    else
        v14 = Name:FindFirstChild("UIStroke");
    end;

    if not (UIStroke and (Name and v14)) then
        return nil;
    end;

    local v15 = Name:FindFirstChildOfClass("UIGradient");
    local ImageLabel = p13:FindFirstChild("ImageLabel");

    if ImageLabel ~= nil then
        ImageLabel = ImageLabel:FindFirstChildOfClass("UIGradient");
    end;

    local Inner = p13:FindFirstChild("Inner");

    if Inner ~= nil then
        Inner = Inner:FindFirstChildOfClass("UIStroke");
    end;

    local v16;

    if Inner == nil then
        v16 = Inner;
    else
        v16 = Inner:FindFirstChildOfClass("UIGradient");
    end;

    UIStroke.Color = u2;
    v14.Color = u2;
    Name.TextColor3 = u1;
    local v17 = p12.strokesByFrame[Frame.Name];
    local v18 = v17 == nil and {} or v17;
    table.insert(v18, {
        buttonStroke = UIStroke,
        nameLabel = Name,
        nameStroke = v14,
        nameGradient = v15,
        iconGradient = ImageLabel,
        innerStroke = Inner,
        innerGradient = v16
    });
    p12.strokesByFrame[Frame.Name] = v18;
end;

function u4.setSelected(p19, p20, p21) -- Line: 107
    -- upvalues: u1 (copy), u2 (copy)
    local v22 = p19.strokesByFrame[p20];

    if not v22 then
        return nil;
    end;

    local v23;

    if p21 then
        v23 = u1;
    else
        v23 = u2;
    end;

    local v24;

    if p21 then
        v24 = u2;
    else
        v24 = u1;
    end;

    for _, v in v22 do
        v.buttonStroke.Color = v23;
        v.nameStroke.Color = v23;
        v.nameLabel.TextColor3 = v24;

        if v.nameGradient then
            v.nameGradient.Enabled = not p21;
        end;

        if v.iconGradient then
            v.iconGradient.Enabled = not p21;
        end;

        if v.innerStroke then
            v.innerStroke.Color = v24;
        end;

        if v.innerGradient then
            v.innerGradient.Enabled = not p21;
        end;
    end;
end;

Reflect.defineMetadata(u4, "identifier", "client/controllers/ui/LeftButtonsController@LeftButtonsController");
Reflect.defineMetadata(u4, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u4, "$:flamework@Controller", Controller, { {} });

return {
    LeftButtonsController = u4
};