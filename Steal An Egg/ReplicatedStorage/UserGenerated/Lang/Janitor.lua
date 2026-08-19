-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Bindable = require(ReplicatedStorage.UserGenerated.Concurrency.Bindable);

local function DestroyThing(u1) -- Line: 57
    if typeof(u1) == "RBXScriptConnection" then
        task.spawn(u1.Disconnect, u1);

        return;
    end;

    if typeof(u1) == "Instance" then
        if u1:IsA("AnimationTrack") and u1.IsPlaying then
            task.spawn(function() -- Line: 63
                -- upvalues: u1 (copy)
                u1:Stop(0.05);
                task.delay(0.11666666666666667, function() -- Line: 65
                    -- upvalues: u1 (ref)
                    u1:Destroy();
                end);
            end);

            return;
        end;

        task.spawn(u1.Destroy, u1);

        return;
    end;

    if type(u1) == "thread" then
        pcall(task.cancel, u1);

        return;
    end;

    if type(u1) == "function" then
        task.spawn(u1);

        return;
    end;

    if type(u1) == "table" then
        task.spawn(function(p2) -- Line: 77
            if p2.Destroy then
                p2:Destroy();

                return;
            end;

            if p2.Disconnect then
                p2:Disconnect();
            end;
        end, u1);
    end;
end;

local function Add(p3, p4) -- Line: 103
    -- upvalues: DestroyThing (copy)
    if p4 ~= nil then
        if typeof(p4) ~= "RBXScriptConnection" and (typeof(p4) ~= "Instance" and (type(p4) ~= "thread" and type(p4) ~= "function")) then
            if type(p4) == "table" then
                if type(p4.Destroy) ~= "function" and type(p4.Disconnect) ~= "function" then
                    error("Unknown thing: table (missing Destroy/Disconnect)");
                end;
            else
                error((`Unknown thing: {typeof(p4)}`));
            end;
        end;

        if not p3.Destroyed then
            table.insert(p3.Things, p4);

            return p4;
        end;

        DestroyThing(p4);
    end;

    return p4;
end;

local v7 = {
    Destroy = function(p5) -- Line: 87, Name: Destroy
        -- upvalues: DestroyThing (copy)
        if p5.Destroyed then
            return false;
        end;

        p5.Destroyed = true;

        for _, v in ipairs(p5.Things) do
            DestroyThing(v);
        end;

        p5.Destroying:Fire();

        return true;
    end,

    IsDestroyed = function(p6) -- Line: 99, Name: IsDestroyed
        return p6.Destroyed;
    end,

    Add = Add
};
local u8 = table.freeze({
    __index = v7,
    __call = Add
});
table.freeze(v7);

return table.freeze({
    new = function() -- Line: 144, Name: new
        -- upvalues: Bindable (copy), u8 (copy)
        local v9 = {
            Destroyed = false,
            Destroying = Bindable.new(),
            Things = {}
        };

        return setmetatable(v9, u8);
    end
});