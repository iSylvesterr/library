-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace;
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "MiscNetwork");
local MiscEvents = v1.MiscEvents;
local MiscFunctions = v1.MiscFunctions;

local function plotIndexOf(p2) -- Line: 12
    if not p2:IsA("Model") then
        return nil;
    end;

    local v3 = string.match(p2.Name, "^Plot_(%d+)$");

    return tonumber(v3);
end;

local u4 = setmetatable({}, {
    __tostring = function() -- Line: 21, Name: __tostring
        return "PlotController";
    end
});
u4.__index = u4;

function u4.new(...) -- Line: 26
    -- upvalues: u4 (ref)
    local v5 = setmetatable({}, u4);

    return v5:constructor(...) or v5;
end;

function u4.constructor(u6) -- Line: 30
    -- upvalues: RuntimeLib (copy)
    u6.ready = RuntimeLib.Promise.new(function(p7) -- Line: 31
        -- upvalues: u6 (copy)
        u6.resolveReady = p7;

        return u6.resolveReady;
    end);
    u6.binds = {};
    u6.bound = {};
end;

function u4.onStart(u8) -- Line: 38
    -- upvalues: MiscEvents (copy), RuntimeLib (copy), MiscFunctions (copy)
    MiscEvents.SendPlotNumber:connect(function(p9) -- Line: 39
        -- upvalues: u8 (copy)
        return u8:setPlotNumber(p9);
    end);
    task.spawn(RuntimeLib.async(function() -- Line: 42
        -- upvalues: RuntimeLib (ref), MiscFunctions (ref), u8 (copy)
        local v10 = RuntimeLib.await(MiscFunctions.RequestPlotNumber:invoke());

        if v10 ~= nil then
            u8:setPlotNumber(v10);
        end;
    end));
    task.spawn(function() -- Line: 48
        -- upvalues: u8 (copy)
        return u8:watchPlots();
    end);
end;

function u4.watchPlots(u11) -- Line: 52
    -- upvalues: Workspace (copy)
    local Plots = Workspace:WaitForChild("Plots");
    Plots.ChildAdded:Connect(function(p12) -- Line: 54
        -- upvalues: u11 (copy)
        return u11:addPlot(p12);
    end);
    Plots.ChildRemoved:Connect(function(p13) -- Line: 57
        -- upvalues: u11 (copy)
        return u11:removePlot(p13);
    end);

    for _, child in Plots:GetChildren() do
        u11:addPlot(child);
    end;
end;

function u4.addPlot(p14, p15) -- Line: 64
    local v16;

    if p15:IsA("Model") then
        local v17 = string.match(p15.Name, "^Plot_(%d+)$");
        v16 = tonumber(v17);
    else
        v16 = nil;
    end;

    if v16 == nil then
        return nil;
    end;

    if p14.bound[p15] ~= nil then
        return nil;
    end;

    local v18 = {};
    p14.bound[p15] = v18;

    for _, v in p14.binds do
        p14:runBind(v, p15, v16, v18);
    end;
end;

function u4.removePlot(p19, p20) -- Line: 79
    if not p20:IsA("Model") then
        return nil;
    end;

    local v21 = p19.bound[p20];

    if not v21 then
        return nil;
    end;

    p19.bound[p20] = nil;

    for _, v in v21 do
        v:Destroy();
    end;
end;

function u4.runBind(p22, p23, p24, p25, p26) -- Line: 96
    -- upvalues: Janitor (copy)
    local v27 = Janitor.new();
    p26[p23] = v27;
    p23(p24, p25, v27);
end;

function u4.observePlots(p28, p29) -- Line: 103
    table.insert(p28.binds, p29);

    for i, v in p28.bound do
        local v30;

        if i:IsA("Model") then
            local v31 = string.match(i.Name, "^Plot_(%d+)$");
            v30 = tonumber(v31);
        else
            v30 = nil;
        end;

        if v30 ~= nil then
            p28:runBind(p29, i, v30, v);
        end;
    end;
end;

function u4.setPlotNumber(p32, p33) -- Line: 114
    p32.plotNumber = p33;
    local resolveReady = p32.resolveReady;

    if resolveReady ~= nil then
        resolveReady(p33);
    end;

    p32.resolveReady = nil;
end;

function u4.getPlotNumber(p34) -- Line: 122
    return p34.plotNumber;
end;

function u4.awaitPlotNumber(p35) -- Line: 125
    return p35.ready;
end;

function u4.getPlot(p36) -- Line: 128
    -- upvalues: Workspace (copy)
    if p36.plotNumber == nil then
        return nil;
    end;

    local Plots = Workspace:FindFirstChild("Plots");

    if Plots ~= nil then
        Plots = Plots:FindFirstChild((`Plot_{p36.plotNumber}`));
    end;

    local v37;

    if Plots == nil then
        v37 = Plots;
    else
        v37 = Plots:IsA("Model");
    end;

    if v37 then
        return Plots;
    end;

    return nil;
end;

u4.awaitPlot = RuntimeLib.async(function(p38) -- Line: 144
    -- upvalues: RuntimeLib (copy), Workspace (copy)
    local v39 = RuntimeLib.await(p38.ready);

    return Workspace:WaitForChild("Plots"):WaitForChild((`Plot_{v39}`));
end);
Reflect.defineMetadata(u4, "identifier", "client/controllers/plot/PlotController@PlotController");
Reflect.defineMetadata(u4, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u4, "$:flamework@Controller", Controller, { {} });

return {
    PlotController = u4
};