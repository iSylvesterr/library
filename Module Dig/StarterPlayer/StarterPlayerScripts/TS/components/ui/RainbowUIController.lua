-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 9, Name: __tostring
        return "RainbowUIController";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 14
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3) -- Line: 18
    p3.rainbowUI = {};
end;

function u1.onStart(u4) -- Line: 21
    -- upvalues: RunService (copy)
    RunService.Heartbeat:Connect(function(u5) -- Line: 22
        -- upvalues: u4 (copy)
        local function _(p6, p7) -- Line: 25
            -- upvalues: u5 (copy)
            p7.Rotation = (p7.Rotation + p6 * u5) % 360;
        end;

        for i, v in u4.rainbowUI do
            i.Rotation = (i.Rotation + v * u5) % 360;
        end;
    end);
end;

function u1.addGradient(p8, p9, p10) -- Line: 34
    p8.rainbowUI[p9] = p10 == nil and 45 or p10;
end;

function u1.removeGradient(p11, p12) -- Line: 43
    p11.rainbowUI[p12] = nil;
end;

Reflect.defineMetadata(u1, "identifier", "client/components/ui/RainbowUIController@RainbowUIController");
Reflect.defineMetadata(u1, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u1, "$:flamework@Controller", Controller, { {} });

return {
    RainbowUIController = u1
};