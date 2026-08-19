-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Resources = script.Resources;
local Private = script.Private;
local Library = ReplicatedStorage.Library;
local u1 = require(Library.Functions.AppendAssetId).Wrap("rbxassetid");
local PipelineBuilder = require(Library.Modules.PipelineBuilder);
local Log = require(Library.Modules.Packages.Log);
local u2 = Log.new();
local TestEz = require(Library.Modules.Packages.TestEz);
local Asserts = require(Library.Asserts);
local DefaultProps = require(Private.DefaultProps);
local GetReplicatedProps = require(Library.Modules.PipelineBuilder.Shared.GetReplicatedProps);
require(Private.Types);
local v3 = {};

if Log.isWithinLevel("Debug") then
    task.delay(1, function() -- Line: 30
        -- upvalues: TestEz (copy), u2 (copy)
        TestEz.run(script.Sandbox, function(p4) -- Line: 31
            -- upvalues: u2 (ref)
            u2:AtDebug():Log("(Sound pipeline): TestEz result:", p4);
        end);
    end);
end;

function v3.PrepareInstance(p5, p6) -- Line: 42
    -- upvalues: u1 (copy)
    local Sound = Instance.new("Sound");
    Sound.SoundId = u1(p6);

    return Sound;
end;

local v7 = PipelineBuilder.create({
    Modifiers = v3
});

function v7._setSoundProps(p8, p9, p10, p11) -- Line: 57
    -- upvalues: Asserts (copy), GetReplicatedProps (copy), DefaultProps (copy), Resources (copy)
    Asserts.Instance(p8);
    Asserts.optional.table(p9);

    if not p11 then
        p9 = GetReplicatedProps(DefaultProps, p9, p10);
    end;

    if not p9 then
        return p8;
    end;

    p8.Parent = typeof(p9.Store) == "Instance" and p9.Store or (p9.Store and Resources or p8.Parent);

    if p9.Props then
        Asserts.table(p9.Props);

        for i, v in p9.Props do
            p8[i] = v;
        end;
    end;

    return p8;
end;

function v7.BuildSoundFromProps(p12, p13, p14, p15) -- Line: 92
    -- upvalues: GetReplicatedProps (copy), DefaultProps (copy)
    local v16 = GetReplicatedProps(DefaultProps, p14, p15);
    local v17 = p12:RushGetTrackedInstance(p13);

    if typeof(v17) ~= "table" then
        return p12._setSoundProps(v17, v16, nil, true);
    end;

    local v18 = {};

    for _, v in v17 do
        local v19 = p12._setSoundProps(v, v16, nil, true);

        if v19 then
            table.insert(v18, v19);
        end;
    end;

    return v18;
end;

return v7;