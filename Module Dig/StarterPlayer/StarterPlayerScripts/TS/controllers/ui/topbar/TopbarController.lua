-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Icon = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "topbar-plus", "out").Icon;
local Player = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "constants", "player", "playerConstants").Player;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 10, Name: __tostring
        return "TopbarController";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 15
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3) -- Line: 19
end;

u1.onStart = RuntimeLib.async(function(p4) -- Line: 21
    -- upvalues: Icon (copy), Player (copy)
    Icon.modifyBaseTheme({ "IconButton", "BackgroundTransparency", 0.1 });
    local v5 = Player;

    for _, v in { "PlayerScripts", "TS", "controllers", "ui", "topbar", "icons" } do
        if v5 ~= nil then
            v5 = v5:WaitForChild(v, 30);
        end;

        if not v5 then
            return nil;
        end;
    end;

    local function _(p6) -- Line: 37
        return p6:IsA("ModuleScript");
    end;

    local v7 = 0;
    local v8 = {};

    for i, child in v5:GetChildren() do
        local _ = i - 1;

        if child:IsA("ModuleScript") == true then
            v7 = v7 + 1;
            v8[v7] = child;
        end;
    end;

    for _, v in v8 do
        task.spawn(function() -- Line: 50
            -- upvalues: v (copy)
            require(v).setup();
        end);
    end;
end);
Reflect.defineMetadata(u1, "identifier", "client/controllers/ui/topbar/TopbarController@TopbarController");
Reflect.defineMetadata(u1, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u1, "$:flamework@Controller", Controller, { {} });

return {
    TopbarController = u1
};