-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "inventory", "BackpackCapacity");
local BackpackCapacity = v1.BackpackCapacity;
local MAX_BACKPACK_CAPACITY = v1.MAX_BACKPACK_CAPACITY;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u2 = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
local u3 = setmetatable({}, {
    __tostring = function() -- Line: 25, Name: __tostring
        return "BackpackCapacityController";
    end
});
u3.__index = u3;

function u3.new(...) -- Line: 30
    -- upvalues: u3 (ref)
    local v4 = setmetatable({}, u3);

    return v4:constructor(...) or v4;
end;

function u3.constructor(p5, p6) -- Line: 34
    p5.data = p6;
end;

function u3.onStart(u7) -- Line: 37
    task.spawn(function() -- Line: 38
        -- upvalues: u7 (copy)
        return u7:setup();
    end);
end;

function u3.onDataChanged(p8, p9) -- Line: 42
    if table.find(p9, "Inventory") ~= nil then
        p8:render();
    end;
end;

function u3.setup(p10) -- Line: 47
    -- upvalues: PlayerGui (copy), WFChain (copy)
    local BackpackGui = PlayerGui:WaitForChild("BackpackGui", 30);

    if not BackpackGui then
        return nil;
    end;

    local v11 = WFChain(BackpackGui, "Backpack", "Inventory");
    WFChain(v11, "Search");
    p10.label = p10:createLabel(v11);
    p10.data:getData();
    p10:render();
end;

function u3.createLabel(p12, p13) -- Line: 58
    -- upvalues: u2 (copy)
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "CapacityLabel";
    TextLabel.AnchorPoint = Vector2.new(0, 1);
    TextLabel.Position = UDim2.new(0, 8, 0, -2);
    TextLabel.Size = UDim2.new(0, 420, 0, 40);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = u2;
    TextLabel.TextSize = 30;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel.ZIndex = 2;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Thickness = 2.5;
    UIStroke.Color = Color3.new(0, 0, 0);
    UIStroke.Parent = TextLabel;
    local UIScale = Instance.new("UIScale");
    UIScale.Parent = TextLabel;
    TextLabel.Parent = p13;
    p12:watchViewport(UIScale);

    return TextLabel;
end;

function u3.watchViewport(p14, u15) -- Line: 81
    -- upvalues: Workspace (copy)
    local function u16() -- Line: 82
        -- upvalues: Workspace (ref), u15 (copy)
        local CurrentCamera = Workspace.CurrentCamera;

        if not CurrentCamera then
            return nil;
        end;

        u15.Scale = math.clamp(CurrentCamera.ViewportSize.Y / 800, 0.7, 1.4);
    end;

    local function u18(p17) -- Line: 89
        -- upvalues: u16 (copy), Workspace (ref), u15 (copy)
        if p17 then
            p17:GetPropertyChangedSignal("ViewportSize"):Connect(u16);
        end;

        local CurrentCamera = Workspace.CurrentCamera;

        if not CurrentCamera then
            return;
        end;

        u15.Scale = math.clamp(CurrentCamera.ViewportSize.Y / 800, 0.7, 1.4);
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(u16);
    end;

    local CurrentCamera2 = Workspace.CurrentCamera;

    if CurrentCamera2 then
        u15.Scale = math.clamp(CurrentCamera2.ViewportSize.Y / 800, 0.7, 1.4);
    end;

    Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 96
        -- upvalues: u18 (copy), Workspace (ref)
        return u18(Workspace.CurrentCamera);
    end);
end;

function u3.render(p19) -- Line: 100
    -- upvalues: BackpackCapacity (copy), MAX_BACKPACK_CAPACITY (copy)
    local label = p19.label;
    local v20 = p19.data:getDataIfLoaded();

    if not (label and v20) then
        return nil;
    end;

    label.Text = `Backpack Capacity: {BackpackCapacity.count(v20.Inventory)}/{MAX_BACKPACK_CAPACITY}`;
end;

Reflect.defineMetadata(u3, "identifier", "client/controllers/ui/BackpackCapacityController@BackpackCapacityController");
Reflect.defineMetadata(u3, "flamework:parameters", { "client/controllers/data/DataController@DataController" });
Reflect.defineMetadata(u3, "flamework:implements", { "$:flamework@OnStart", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u3, "$:flamework@Controller", Controller, { {} });

return {
    BackpackCapacityController = u3
};