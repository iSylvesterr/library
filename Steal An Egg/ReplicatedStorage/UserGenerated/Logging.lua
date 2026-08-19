-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Keys = require(game.ReplicatedStorage.UserGenerated.Lang.Keys);
local Asserts = require(game.ReplicatedStorage.UserGenerated.Lang.Asserts);
local Stringify = require(game.ReplicatedStorage.UserGenerated.Strings.Stringify);
local u1 = {
    Pretty = true,
    IndentChar = " ",
    IndentSize = 2
};

local function GetPrefix(p2) -- Line: 39
    local v3, v4, v5 = debug.info((p2 or 0) + 2, "sln");
    local v6 = `{v3}:{v4}`;

    if v5 then
        v6 = v6 .. ` {v5}`;
    end;

    return `[{v6}]`;
end;

local function Format(p7) -- Line: 49
    -- upvalues: Stringify (copy), u1 (copy)
    if type(p7) == "string" then
        return p7;
    end;

    if typeof(p7) == "Instance" then
        return `{p7.ClassName}[{p7:GetFullName()}]`;
    end;

    return Stringify.Serialize(p7, u1);
end;

local function FormatArgs(...) -- Line: 59
    -- upvalues: Stringify (copy), u1 (copy)
    local v8 = table.pack(...);

    for i = 1, v8.n do
        local v9 = v8[i];

        if type(v9) ~= "string" then
            if typeof(v9) == "Instance" then
                v9 = `{v9.ClassName}[{v9:GetFullName()}]`;
            else
                v9 = Stringify.Serialize(v9, u1);
            end;
        end;

        v8[i] = v9;
    end;

    return table.unpack(v8);
end;

local v10, v11;

if RunService:IsStudio() then
    v10 = print;
    v11 = warn;
else
    v10 = function(...) -- Line: 67
        -- upvalues: FormatArgs (copy)
        local spawn = task.spawn;

        local function v13(p12, ...) -- Line: 68
            -- upvalues: FormatArgs (ref)
            print(p12, FormatArgs(...));
        end;

        local v14, v15, v16 = debug.info(2, "sln");
        local v17 = `{v14}:{v15}`;

        if v16 then
            v17 = v17 .. ` {v16}`;
        end;

        spawn(v13, `[{v17}]`, ...);
    end;

    v11 = function(...) -- Line: 72
        -- upvalues: FormatArgs (copy)
        local spawn = task.spawn;

        local function v19(p18, ...) -- Line: 73
            -- upvalues: FormatArgs (ref)
            warn(p18, FormatArgs(...));
        end;

        local v20, v21, v22 = debug.info(2, "sln");
        local v23 = `{v20}:{v21}`;

        if v22 then
            v23 = v23 .. ` {v22}`;
        end;

        spawn(v19, `[{v23}]`, ...);
    end;
end;

local function u24() -- Line: 85
end;

local u25 = {
    Trace = 1,
    Debug = 2,
    Info = 3,
    Warn = 4,
    Error = 5,
    Critical = 6,
    Off = 7
};
table.freeze(u25);
local u26 = {
    Trace = v10,
    Debug = v10,
    Info = v10,
    Warn = v11,
    Error = v11,
    Critical = v11,
    Off = u24
};
table.freeze(u26);
local v27 = Asserts.Set(Keys(u25));
local u28 = table.clone(u26);
local u29 = "Info";

local function SetLevel(p30, p31) -- Line: 113
    -- upvalues: u25 (copy), u29 (ref), u28 (copy), u26 (copy), u24 (copy)
    assert(u25[p30]);
    local v32 = p31 == nil and true or type(p31) == "boolean";
    assert(v32);

    if u29 == p30 and not p31 then
        return;
    end;

    u29 = p30;
    local v33 = assert(u25[p30]);

    for i, v in pairs(u25) do
        if v33 <= v then
            u28[i] = u26[i];
        else
            u28[i] = u24;
        end;
    end;
end;

SetLevel(u29, true);
local v34 = {
    Levels = u25,
    AssertLevel = v27
};
setmetatable(v34, {
    __index = u28
});

function v34.GetLevel() -- Line: 138
    -- upvalues: u29 (ref)
    return u29;
end;

function v34.SetLevel(p35) -- Line: 142
    -- upvalues: SetLevel (copy)
    SetLevel(p35);
end;

function v34.Sink(p36) -- Line: 146
    -- upvalues: u28 (copy)
    return assert(u28[p36]);
end;

return table.freeze(v34);