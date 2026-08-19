-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Private = script.Private;
local Library = ReplicatedStorage.Library;
local u1 = require(Library.Functions.AppendAssetId).Wrap("rbxassetid");
local PipelineBuilder = require(Library.Modules.PipelineBuilder);
require(Library.Modules.Packages.Log).new();
require(Library.Modules.Packages.TestEz);
local Asserts = require(Library.Asserts);
local GetReplicatedProps = require(Library.Modules.PipelineBuilder.Shared.GetReplicatedProps);
local DefaultTransitions = require(Private.DefaultTransitions);
require(Private.Types);
local v4 = PipelineBuilder.create({
    Modifiers = {
        PrepareInstance = function(p2, p3) -- Line: 45, Name: PrepareInstance
            -- upvalues: u1 (copy)
            local Animation = Instance.new("Animation");
            Animation.AnimationId = u1(p3);

            return Animation;
        end
    },
    Resources = {
        DefaultTransitions = DefaultTransitions
    }
});

function v4.GetDataFromAnimation(p5, p6, p7, p8, p9) -- Line: 61
    -- upvalues: Asserts (copy), GetReplicatedProps (copy), DefaultTransitions (copy)
    Asserts.Instance(p6);
    Asserts.optional.table(p7);

    if not p9 then
        p7 = GetReplicatedProps(DefaultTransitions, p7, p8);
    end;

    return not p7 and {
        weight = 1,
        anim = p6
    } or {
        anim = p6,
        looped = p7.Looped,
        weight = p7.DropWeight or 1,
        protocol = {
            Play = p7.Play,
            Stop = p7.Stop
        }
    };
end;

function v4.GetAndSerializeAnimation(p10, p11, p12, p13) -- Line: 94
    -- upvalues: GetReplicatedProps (copy), DefaultTransitions (copy)
    local v14 = GetReplicatedProps(DefaultTransitions, p12, p13);
    local v15 = p10:RushGetTrackedInstance(p11);

    if typeof(v15) ~= "table" then
        return p10:GetDataFromAnimation(v15, v14, nil, true);
    end;

    local v16 = {};

    for _, v in v15 do
        local v17 = p10:GetDataFromAnimation(v, v14, nil, true);

        if v17 then
            table.insert(v16, v17);
        end;
    end;

    return v16;
end;

return v4;