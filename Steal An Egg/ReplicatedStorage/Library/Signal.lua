-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SIGNALS_MAP = require(ReplicatedStorage.Library.Globals.Constants).SIGNALS_MAP;
local v1 = {};
local u2 = { {}, {} };
local u3 = { "BindableEvent", "BindableFunction" };

for _, v in ipairs({}) do
    v1[v] = true;
end;

local u4;

if RunService:IsServer() then
    u4 = game:GetService("ServerScriptService"):WaitForChild("Signals");
else
    u4 = script;
end;

local v5 = {
    MAP = SIGNALS_MAP
};

local function getName(p6, p7) -- Line: 32
    return p7;
end;

local function getOrCreateSignal(p8, p9) -- Line: 36
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v10 = u2[p8];
    local v11 = v10[p9];

    if not v11 then
        v11 = Instance.new(u3[p8]);
        v11.Name = p9;
        v11.Parent = u4;
        v10[p9] = v11;
    end;

    return v11;
end;

local function getEvent(p12) -- Line: 50
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v13 = u2[1];
    local v14 = v13[p12];

    if not v14 then
        v14 = Instance.new(u3[1]);
        v14.Name = p12;
        v14.Parent = u4;
        v13[p12] = v14;
    end;

    return v14;
end;

local function getFunction(p15) -- Line: 54
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v16 = u2[2];
    local v17 = v16[p15];

    if not v17 then
        v17 = Instance.new(u3[2]);
        v17.Name = p15;
        v17.Parent = u4;
        v16[p15] = v17;
    end;

    return v17;
end;

function v5.Fire(p18, ...) -- Line: 58
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v19 = u2[1];
    local v20 = v19[p18];

    if not v20 then
        v20 = Instance.new(u3[1]);
        v20.Name = p18;
        v20.Parent = u4;
        v19[p18] = v20;
    end;

    v20:Fire(...);
end;

function v5.FireAsync(p21, ...) -- Line: 62
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v22 = u2[1];
    local v23 = v22[p21];

    if not v23 then
        v23 = Instance.new(u3[1]);
        v23.Name = p21;
        v23.Parent = u4;
        v22[p21] = v23;
    end;

    task.spawn(v23.Fire, v23, ...);
end;

function v5.Fired(p24) -- Line: 67
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v25 = u2[1];
    local v26 = v25[p24];

    if not v26 then
        v26 = Instance.new(u3[1]);
        v26.Name = p24;
        v26.Parent = u4;
        v25[p24] = v26;
    end;

    return v26.Event;
end;

function v5.Invoke(p27, ...) -- Line: 71
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v28 = u2[2];
    local v29 = v28[p27];

    if not v29 then
        v29 = Instance.new(u3[2]);
        v29.Name = p27;
        v29.Parent = u4;
        v28[p27] = v29;
    end;

    return v29:Invoke(...);
end;

function v5.Invoked(p30) -- Line: 75
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v31 = u2[2];
    local v32 = v31[p30];

    if not v32 then
        v32 = Instance.new(u3[2]);
        v32.Name = p30;
        v32.Parent = u4;
        v31[p30] = v32;
    end;

    return v32;
end;

return v5;