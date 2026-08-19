-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out");
local Controller = v1.Controller;
local Modding = v1.Modding;
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "DataNetwork");
local DataEvents = v2.DataEvents;
local DataFunctions = v2.DataFunctions;
local DataUtils = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "data", "DataUtils").DataUtils;
local u3 = setmetatable({}, {
    __tostring = function() -- Line: 14, Name: __tostring
        return "DataController";
    end
});
u3.__index = u3;

function u3.new(...) -- Line: 19
    -- upvalues: u3 (ref)
    local v4 = setmetatable({}, u3);

    return v4:constructor(...) or v4;
end;

function u3.constructor(p5) -- Line: 23
    p5.listeners = {};
    p5.revision = 0;
    p5.fetching = false;
    p5.loadStart = os.clock();
    p5.loadedPrinted = false;
end;

function u3.onStart(u6) -- Line: 30
    -- upvalues: Modding (copy), DataEvents (copy)
    Modding.onListenerAdded(function(p7) -- Line: 31
        -- upvalues: u6 (copy)
        local listeners = u6.listeners;
        listeners[p7] = true;

        return listeners;
    end, "client/controllers/data/DataController@OnDataChanged");
    Modding.onListenerRemoved(function(p8) -- Line: 37
        -- upvalues: u6 (copy)
        local listeners = u6.listeners;
        local v9 = listeners[p8] ~= nil;
        listeners[p8] = nil;

        return v9;
    end, "client/controllers/data/DataController@OnDataChanged");
    DataEvents.DataPartialUpdate:connect(function(p10, u11, u12) -- Line: 46
        -- upvalues: u6 (copy)
        if p10 <= u6.revision then
            return nil;
        end;

        u6.revision = p10;
        task.spawn(function() -- Line: 51
            -- upvalues: u6 (ref), u11 (copy), u12 (copy)
            return u6:applyUpdate(u11, u12);
        end);
    end);
    task.spawn(function() -- Line: 55
        -- upvalues: u6 (copy)
        return u6:fetchData();
    end);
end;

u3.fetchData = RuntimeLib.async(function(u13) -- Line: 59
    -- upvalues: RuntimeLib (copy), DataFunctions (copy)
    if u13.fetching or u13.data then
        return nil;
    end;

    u13.fetching = true;
    RuntimeLib.try(function() -- Line: 64
        -- upvalues: u13 (copy), RuntimeLib (ref), DataFunctions (ref)
        u13.data = RuntimeLib.await(DataFunctions.requestDataUpdate:invoke());

        if u13.data and not u13.loadedPrinted then
            local v14 = print;
            local v15 = (os.clock() - u13.loadStart) * 1000;
            v14((`Data loaded in {math.floor(v15)}ms`));
            u13.loadedPrinted = true;
        end;
    end, function() -- Line: 70
        -- upvalues: u13 (copy)
        u13.data = nil;
    end);
    u13.fetching = false;
end);
u3.applyUpdate = RuntimeLib.async(function(u16, u17, p18) -- Line: 75
    -- upvalues: RuntimeLib (copy), DataUtils (copy)
    if not u16.data then
        RuntimeLib.await(u16:fetchData());
    end;

    if not u16.data then
        return nil;
    end;

    if DataUtils.validatePartialData(p18) then
        DataUtils.mergePartialUpdate(u16.data, p18);
    end;

    for i in u16.listeners do
        task.spawn(function() -- Line: 86
            -- upvalues: i (copy), u17 (copy), u16 (copy)
            return i:onDataChanged(u17, u16.data);
        end);
    end;
end);

function u3.getData(p19) -- Line: 91
    while not p19.data do
        task.wait();
    end;

    return p19.data;
end;

function u3.getDataIfLoaded(p20) -- Line: 97
    return p20.data;
end;

Reflect.defineMetadata(u3, "identifier", "client/controllers/data/DataController@DataController");
Reflect.defineMetadata(u3, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u3, "$:flamework@Controller", Controller, { {} });

return {
    DataController = u3
};