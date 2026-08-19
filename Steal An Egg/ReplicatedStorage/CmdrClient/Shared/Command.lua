-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local Argument = require(script.Parent.Argument);
local u1 = RunService:IsServer();
local u2 = {};
u2.__index = u2;

function u2.new(p3) -- Line: 12
    -- upvalues: u2 (copy)
    local v4 = {
        Response = nil,
        Dispatcher = p3.Dispatcher,
        Cmdr = p3.Dispatcher.Cmdr,
        Name = p3.CommandObject.Name,
        RawText = p3.Text,
        Object = p3.CommandObject,
        Group = p3.CommandObject.Group,
        State = {},
        Aliases = p3.CommandObject.Aliases,
        Alias = p3.Alias,
        Description = p3.CommandObject.Description,
        Executor = p3.Executor,
        ArgumentDefinitions = p3.CommandObject.Args,
        RawArguments = p3.Arguments,
        Arguments = {},
        Data = p3.Data
    };
    setmetatable(v4, u2);

    return v4;
end;

function u2.Parse(p5, p6) -- Line: 40
    -- upvalues: Argument (copy)
    local v7 = false;

    for i, v in ipairs(p5.ArgumentDefinitions) do
        if type(v) == "function" then
            local v = v(p5);

            if v == nil then
                break;
            end;
        end;

        local v8;

        if v.Default == nil then
            v8 = v.Optional ~= true;
        else
            v8 = false;
        end;

        if v8 and v7 then
            error(("Command %q: Required arguments cannot occur after optional arguments."):format(p5.Name));
        else
            v7 = not v8 and true or v7;
        end;

        if p5.RawArguments[i] == nil and (v8 and p6 ~= true) then
            return false, ("Required argument #%d %s is missing."):format(i, v.Name);
        end;

        if p5.RawArguments[i] or p6 then
            p5.Arguments[i] = Argument.new(p5, v, p5.RawArguments[i] or "");
        end;
    end;

    return true;
end;

function u2.Validate(p9, p10) -- Line: 72
    p9._Validated = true;
    local v11 = "";
    local v12 = true;

    for i, v in pairs(p9.Arguments) do
        local v13, v14 = v:Validate(p10);

        if not v13 then
            v11 = ("%s; #%d %s: %s"):format(v11, i, v.Name, v14 or "error");
            v12 = false;
        end;
    end;

    return v12, v11:sub(3);
end;

function u2.GetLastArgument(p15) -- Line: 91
    for i = #p15.Arguments, 1, -1 do
        if p15.Arguments[i].RawValue then
            return p15.Arguments[i];
        end;
    end;
end;

function u2.GatherArgumentValues(p16) -- Line: 100
    local v17 = {};

    for i = 1, #p16.ArgumentDefinitions do
        local v18 = p16.Arguments[i];

        if v18 then
            v17[i] = v18:GetValue();
        elseif type(p16.ArgumentDefinitions[i]) == "table" then
            v17[i] = p16.ArgumentDefinitions[i].Default;
        end;
    end;

    return v17, #p16.ArgumentDefinitions;
end;

function u2.Run(p19) -- Line: 117
    -- upvalues: u1 (copy)
    if p19._Validated == nil then
        error("Must validate a command before running.");
    end;

    local v20 = p19.Dispatcher:RunHooks("BeforeRun", p19);

    if v20 then
        return v20;
    end;

    if not u1 and (p19.Object.Data and p19.Data == nil) then
        local v21, v22 = p19:GatherArgumentValues();
        p19.Data = p19.Object.Data(p19, unpack(v21, 1, v22));
    end;

    if not u1 and p19.Object.ClientRun then
        local v23, v24 = p19:GatherArgumentValues();
        p19.Response = p19.Object.ClientRun(p19, unpack(v23, 1, v24));
    end;

    if p19.Response == nil then
        if p19.Object.Run then
            local v25, v26 = p19:GatherArgumentValues();
            p19.Response = p19.Object.Run(p19, unpack(v25, 1, v26));
        elseif u1 then
            if p19.Object.ClientRun then
                warn(p19.Name, "command fell back to the server because ClientRun returned nil, but there is no server implementation! Either return a string from ClientRun, or create a server implementation for this command.");
            else
                warn(p19.Name, "command has no implementation!");
            end;

            p19.Response = "No implementation.";
        else
            p19.Response = p19.Dispatcher:Send(p19.RawText, p19.Data);
        end;
    end;

    return p19.Dispatcher:RunHooks("AfterRun", p19) or p19.Response;
end;

function u2.GetArgument(p27, p28) -- Line: 164
    return p27.Arguments[p28];
end;

function u2.GetData(p29) -- Line: 172
    -- upvalues: u1 (copy)
    if p29.Data then
        return p29.Data;
    end;

    if p29.Object.Data and not u1 then
        p29.Data = p29.Object.Data(p29);
    end;

    return p29.Data;
end;

function u2.SendEvent(p30, p31, p32, ...) -- Line: 185
    -- upvalues: u1 (copy), Players (copy)
    local v33 = typeof(p31) == "Instance";
    assert(v33, "Argument #1 must be a Player");
    local v34 = p31:IsA("Player");
    assert(v34, "Argument #1 must be a Player");
    local v35 = type(p32) == "string";
    assert(v35, "Argument #2 must be a string");

    if u1 then
        p30.Dispatcher.Cmdr.RemoteEvent:FireClient(p31, p32, ...);

        return;
    end;

    if p30.Dispatcher.Cmdr.Events[p32] then
        assert(p31 == Players.LocalPlayer, "Event messages can only be sent to the local player on the client.");
        p30.Dispatcher.Cmdr.Events[p32](...);
    end;
end;

function u2.BroadcastEvent(p36, ...) -- Line: 199
    -- upvalues: u1 (copy)
    if not u1 then
        error("Can\'t broadcast event messages from the client.", 2);
    end;

    p36.Dispatcher.Cmdr.RemoteEvent:FireAllClients(...);
end;

function u2.Reply(p37, ...) -- Line: 208
    return p37:SendEvent(p37.Executor, "AddLine", ...);
end;

function u2.GetStore(p38, ...) -- Line: 213
    return p38.Dispatcher.Cmdr.Registry:GetStore(...);
end;

function u2.HasImplementation(p39) -- Line: 218
    -- upvalues: RunService (copy)
    return (RunService:IsClient() and p39.Object.ClientRun or p39.Object.Run) and true or false;
end;

return u2;