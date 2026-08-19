-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 9, Name: __tostring
        return "VisitorTipVisibilityController";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 14
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3, p4) -- Line: 18
    p3.plot = p4;
end;

function u1.onStart(u5) -- Line: 21
    task.spawn(function() -- Line: 22
        -- upvalues: u5 (copy)
        local v6, u7 = u5.plot:awaitPlotNumber():await();

        if not v6 or u7 == nil then
            return nil;
        end;

        u5.plot:observePlots(function(p8, p9) -- Line: 27
            -- upvalues: u5 (ref), u7 (copy)
            local VisitorTip = p8:FindFirstChild("VisitorTip");

            if VisitorTip then
                u5:setVisible(VisitorTip, p9 == u7);
            end;
        end);
    end);
end;

function u1.setVisible(p10, p11, p12) -- Line: 35
    for _, descendant in p11:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = p12 and 0 or 1;
        elseif descendant:IsA("SurfaceGui") then
            descendant.Enabled = p12;
        end;
    end;
end;

Reflect.defineMetadata(u1, "identifier", "client/controllers/plot/VisitorTipVisibilityController@VisitorTipVisibilityController");
Reflect.defineMetadata(u1, "flamework:parameters", { "client/controllers/plot/PlotController@PlotController" });
Reflect.defineMetadata(u1, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u1, "$:flamework@Controller", Controller, { {} });

return {
    VisitorTipVisibilityController = u1
};